unit DeDeCore;

interface

uses
  Classes, SysUtils, DeDeClasses, DeDeClassHandle, DeDeCoreServices;

type
  EDeDeOutputExists = class(EInOutError);

  TDeDeExportOptions = record
    IncludeDFM: Boolean;
    IncludePAS: Boolean;
    IncludeDPR: Boolean;
    IncludeEventRVA: Boolean;
    IncludeAnalysisReport: Boolean;
    IncludeCrossReferenceReport: Boolean;
  end;

  TDeDeAnalysisResult = record
    InputFile: string;
    ProjectName: string;
    CompilerVersion: string;
    ClassCount: Integer;
    FormCount: Integer;
    UnitCount: Integer;
  end;

  TDeDeSessionActivation = record
    CoreContext: TDeDeCoreContext;
    IsELF: Boolean;
  end;

  TDeDeAnalysisSession = class
  private
    FPEFile: ThePEFile;
    FPEHeader: TPEHeader;
    FIsELF: Boolean;
    FClassesDumper: TClassesDumper;
    FOpcodeList: TList;
    FSymbolsList: TList;
    FAnalysisResult: TDeDeAnalysisResult;
    FContext: TDeDeCoreContext;
    FOwnsContext: Boolean;
    FOwnsAnalysis: Boolean;
    FFinalized: Boolean;
    FOnProgress: TDeDeCoreProgressEvent;
    FOnWarning: TDeDeCoreWarningEvent;
    procedure ActivateLegacyState(out APreviousState: TDeDeSessionActivation);
    procedure RestoreLegacyState(
      const APreviousState: TDeDeSessionActivation);
    procedure ReleaseAnalysis;
    procedure SetOnProgress(const AValue: TDeDeCoreProgressEvent);
    procedure SetOnWarning(const AValue: TDeDeCoreWarningEvent);
    procedure ConfigureDisassembler;
    procedure PopulateFormLists;
  public
    constructor Create;
    destructor Destroy; override;
    class procedure ConfigureVersion(const AVersion: string); static;
    function Analyze(const AFileName: string): TDeDeAnalysisResult;
    procedure AttachAnalysis(APEFile: ThePEFile; APEHeader: TPEHeader;
      AClassesDumper: TClassesDumper; const ACompilerVersion: string;
      AAlreadyAnalyzed: Boolean = True);
    procedure DetachAnalysis;
    procedure DumpClasses(AUserProcs, ABSS: Boolean);
    procedure FinalizeAnalysis;
    function ExportProject(const AOutputDirectory: string;
      const AOptions: TDeDeExportOptions; AForce: Boolean): TStringList;
    property ClassesDumper: TClassesDumper read FClassesDumper;
    property PEFile: ThePEFile read FPEFile;
    property PEHeader: TPEHeader read FPEHeader;
    property Context: TDeDeCoreContext read FContext;
    property OnProgress: TDeDeCoreProgressEvent read FOnProgress
      write SetOnProgress;
    property OnWarning: TDeDeCoreWarningEvent read FOnWarning
      write SetOnWarning;
  end;

function HasDelphi2BooleanMarker(AFile: ThePEFile; AHeader: TPEHeader;
  AOffset: DWORD): Boolean;

implementation

uses
  DeDeConstants, DeDeDisAsm, DisASM,
  DeDeClassEmulator, DeDeSym, DeDeELFClasses, DeDePAS, DeDeRes,
  DeDeAnsiStream, DeDeXRef;

procedure WriteAnsiText(AStream: TStream; const AText: string);
var
  Bytes: AnsiString;
begin
  Bytes := AnsiString(AText);
  if Bytes <> '' then
    AStream.WriteBuffer(Bytes[1], Length(Bytes));
end;

function JSONString(const AValue: string): string;
var
  I: Integer;
begin
  Result := '"';
  for I := 1 to Length(AValue) do
    case AValue[I] of
      '"': Result := Result + '\"';
      '\': Result := Result + '\\';
      #8: Result := Result + '\b';
      #9: Result := Result + '\t';
      #10: Result := Result + '\n';
      #12: Result := Result + '\f';
      #13: Result := Result + '\r';
    else
      if Ord(AValue[I]) < 32 then
        Result := Result + '\u00' + IntToHex(Ord(AValue[I]), 2)
      else
        Result := Result + AValue[I];
    end;
  Result := Result + '"';
end;

function SafeIdentifier(const AValue: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AValue) do
    if CharInSet(AValue[I], ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
      Result := Result + AValue[I]
    else
      Result := Result + '_';
  if Result = '' then
    Result := '_';
  if not CharInSet(Result[1], ['A'..'Z', 'a'..'z', '_']) then
    Result := '_' + Result;
end;

procedure SaveUTF8Text(const AFileName, AText: string);
var
  Stream: TFileStream;
  Bytes: UTF8String;
begin
  Bytes := UTF8Encode(AText);
  Stream := TFileStream.Create(AFileName, fmCreate);
  try
    if Bytes <> '' then
      Stream.WriteBuffer(Bytes[1], Length(Bytes));
  finally
    Stream.Free;
  end;
end;

constructor TDeDeAnalysisSession.Create;
begin
  inherited Create;
end;

destructor TDeDeAnalysisSession.Destroy;
begin
  ReleaseAnalysis;
  inherited Destroy;
end;

procedure TDeDeAnalysisSession.ActivateLegacyState(
  out APreviousState: TDeDeSessionActivation);
begin
  if FContext = nil then
    raise EInvalidOp.Create('Analysis session has no core context');
  APreviousState.CoreContext := DeDeCoreContext;
  APreviousState.IsELF := bELF;
  DeDeCoreContext := FContext;
  bELF := FIsELF;
end;

procedure TDeDeAnalysisSession.RestoreLegacyState(
  const APreviousState: TDeDeSessionActivation);
begin
  DeDeCoreContext := APreviousState.CoreContext;
  bELF := APreviousState.IsELF;
end;

procedure TDeDeAnalysisSession.ReleaseAnalysis;
var
  PreviousState: TDeDeSessionActivation;
  ContextToFree: TDeDeCoreContext;
  OwnsContext: Boolean;
  HasActiveContext: Boolean;
begin
  FFinalized := False;
  ContextToFree := FContext;
  OwnsContext := FOwnsContext;
  HasActiveContext := FContext <> nil;
  if HasActiveContext then
    ActivateLegacyState(PreviousState);
  try
    if FOwnsAnalysis then
    begin
      DeDeCoreContext.ClassesDumper := nil;
      DeDeDisAsm.ClsDmp := nil;
      DeDeDisAsm.FOpCodeList := nil;
      DeDeDisAsm.SymbolsList := nil;
      DeDeDisAsm.UnitList.Clear;
      if FClassesDumper <> nil then
        FreeAndNil(FClassesDumper);
    end
    else
      FClassesDumper := nil;
    if FOpcodeList <> nil then
      FreeAndNil(FOpcodeList);
    if FSymbolsList <> nil then
      FreeAndNil(FSymbolsList);
    if FOwnsAnalysis then
    begin
      if FPEHeader <> nil then
        FreeAndNil(FPEHeader);
      if FPEFile <> nil then
        FreeAndNil(FPEFile);
      DeDeCoreContext.PEHeader := nil;
      DeDeCoreContext.PEFile := nil;
      DeDeCoreContext.FileName := '';
      DeDeCoreContext.ProjectName := '';
      DeDeCoreContext.ClassCount := 0;
      DeDeCoreContext.UnitList.Clear;
      DeDeCoreContext.ClearDFMForms;
      DeDeCoreContext.DFMNameList.Clear;
      DeDeCoreContext.PASNameList.Clear;
      DeDeCoreContext.Warnings.Clear;
    end
    else
    begin
      FPEHeader := nil;
      FPEFile := nil;
    end;
  finally
    if HasActiveContext then
      RestoreLegacyState(PreviousState);
    FOwnsAnalysis := False;
    FContext := nil;
    FOwnsContext := False;
    FIsELF := False;
    if OwnsContext then
      ContextToFree.Free;
  end;
end;

procedure TDeDeAnalysisSession.SetOnProgress(
  const AValue: TDeDeCoreProgressEvent);
begin
  FOnProgress := AValue;
  if FContext <> nil then
    FContext.OnProgress := AValue;
end;

procedure TDeDeAnalysisSession.SetOnWarning(
  const AValue: TDeDeCoreWarningEvent);
begin
  FOnWarning := AValue;
  if FContext <> nil then
    FContext.OnWarning := AValue;
end;

class procedure TDeDeAnalysisSession.ConfigureVersion(
  const AVersion: string);
var
  VersionText: string;
begin
  VersionText := AVersion;
  while Length(VersionText) < 6 do
    VersionText := VersionText + ' ';

  DeDeCoreContext.DelphiVersionCompatibility := $0E;
  case VersionText[2] of
    '2': DeDeCoreContext.DelphiVersionCompatibility := $08;
    '3': DeDeCoreContext.DelphiVersionCompatibility := $01;
    '4': DeDeCoreContext.DelphiVersionCompatibility := $02;
    '5': DeDeCoreContext.DelphiVersionCompatibility := $04;
    '6': DeDeCoreContext.DelphiVersionCompatibility := $10;
    'C':
      case VersionText[4] of
        '3': DeDeCoreContext.DelphiVersionCompatibility := $01;
        '4': DeDeCoreContext.DelphiVersionCompatibility := $02;
        '5': DeDeCoreContext.DelphiVersionCompatibility := $04;
        'n': DeDeCoreContext.DelphiVersionCompatibility := $0E;
      end;
    'y':
      if CharInSet(VersionText[6], ['1', '2']) then
        DeDeCoreContext.DelphiVersionCompatibility := $10;
  end;

  case VersionText[2] of
    '2': ReducedDelphiVersion := dvD2;
    '3': ReducedDelphiVersion := dvD3;
    '4': ReducedDelphiVersion := dvD4;
    '5': ReducedDelphiVersion := dvD5;
    '6': ReducedDelphiVersion := dvD6;
    'C':
      case VersionText[4] of
        '3': ReducedDelphiVersion := dvBCB3;
        '4': ReducedDelphiVersion := dvBCB4;
        '5': ReducedDelphiVersion := dvBCB5;
        'n': ReducedDelphiVersion := dvConsole;
        else ReducedDelphiVersion := dvNone;
      end;
    'y': ReducedDelphiVersion := dvKylix;
    else ReducedDelphiVersion := dvNone;
  end;

  DelphiVersion := AVersion;
  GlobDelphi2 := SameText(AVersion, 'D2');
  GlobCBuilder := (Length(AVersion) >= 3) and
    SameText(Copy(AVersion, 1, 3), 'BCB');
end;

procedure TDeDeAnalysisSession.ConfigureDisassembler;
var
  CodeIndex: Integer;
begin
  DeDeDisAsm.DFMNameList := DeDeCoreContext.DFMNameList;
  DeDeDisAsm.PASNameList := DeDeCoreContext.PASNameList;
  DeDeDisAsm.UnitList.Clear;
  DeDeDisAsm.ControlNames.Clear;
  DeDeDisAsm.ControlIDs.Clear;
  DeDeDisAsm.GlobBEmulation := bBSS;
  DeDeDisAsm.GlobCustomEmulInit := False;

  if FIsELF then
    CodeIndex := FPEHeader.GetSectionIndexEx('.text')
  else
    CodeIndex := 1;
  if (CodeIndex < 1) or (CodeIndex > FPEHeader.ObjectNum) then
    raise Exception.Create('Executable code section was not found');

  if FOwnsAnalysis then
  begin
    FOpcodeList := TList.Create;
    DeDeDisAsm.FOpCodeList := FOpcodeList;
    FSymbolsList := TList.Create;
    DeDeDisAsm.SymbolsList := FSymbolsList;
  end;
end;

procedure TDeDeAnalysisSession.DumpClasses(AUserProcs, ABSS: Boolean);
var
  PreviousState: TDeDeSessionActivation;
begin
  if (FPEFile = nil) or (FPEHeader = nil) or (FClassesDumper = nil) then
    raise EInvalidOp.Create('Analysis session is not attached to a binary');
  ActivateLegacyState(PreviousState);
  try
    FClassesDumper.SetImage(FPEFile, FPEHeader);
    DeDeCoreContext.ClassesDumper := FClassesDumper;
    bUserProcs := AUserProcs;
    bBSS := ABSS;
    DeDeSym.FirstCodeRVA := FPEHeader.BaseOfCode + FPEHeader.IMAGE_BASE;
    DeDeSym.FirstCodeRVA := FPEHeader.BaseOfCode + FPEHeader.IMAGE_BASE;
    ConfigureDisassembler;
    FClassesDumper.ClearClasses;
    DeDeCoreContext.ReportProgress('Analyzing ', DelphiVersion, 1, 100);
    FClassesDumper.Dump;
    FFinalized := False;
  finally
    RestoreLegacyState(PreviousState);
  end;
end;

procedure TDeDeAnalysisSession.PopulateFormLists;
var
  I: Integer;
  ClassDumper: TClassDumper;
begin
  DeDeCoreContext.DFMNameList.Clear;
  DeDeCoreContext.PASNameList.Clear;
  DeDeCoreContext.UnitList.Clear;
  for I := 0 to FClassesDumper.Classes.Count - 1 do
  begin
    ClassDumper := TClassDumper(FClassesDumper.Classes[I]);
    if ClassDumper.FdwDFMOffset = 0 then
      Continue;
    DeDeCoreContext.DFMNameList.Add(ClassDumper.FsClassName);
    DeDeCoreContext.PASNameList.Add(ClassDumper.FsUnitName);
    DeDeCoreContext.UnitList.Add(ClassDumper.FsUnitName);
  end;
  DeDeDisAsm.UnitList.Assign(DeDeCoreContext.UnitList);
end;

procedure TDeDeAnalysisSession.FinalizeAnalysis;
var
  PreviousState: TDeDeSessionActivation;
begin
  if FClassesDumper = nil then
    raise EInvalidOp.Create('No class dump is available to finalize');
  if FFinalized then
    Exit;
  ActivateLegacyState(PreviousState);
  try
    FClassesDumper.FinilizeDump;
    FFinalized := True;
  finally
    RestoreLegacyState(PreviousState);
  end;
end;

function HasDelphi2BooleanMarker(AFile: ThePEFile; AHeader: TPEHeader;
  AOffset: DWORD): Boolean;
const
  Marker: array[0..7] of Byte =
    ($07, $42, $6F, $6F, $6C, $65, $61, $6E);
var
  Bytes: array[0..7] of Byte;
  SectionOffset: DWORD;
begin
  Result := False;
  if AHeader.ObjectNum = 0 then
    Exit;
  SectionOffset := AHeader.Objects[1].PHYSICAL_OFFSET;
  if (AOffset > AHeader.Objects[1].PHYSICAL_SIZE) or
    (AHeader.Objects[1].PHYSICAL_SIZE - AOffset < SizeOf(Bytes)) then
    Exit;
  AFile.PEStream.Seek(SectionOffset + AOffset, soFromBeginning);
  if AFile.PEStream.Read(Bytes[0], SizeOf(Bytes)) <> SizeOf(Bytes) then
    Exit;
  Result := CompareMem(@Bytes[0], @Marker[0], SizeOf(Marker));
end;

function TDeDeAnalysisSession.Analyze(
  const AFileName: string): TDeDeAnalysisResult;
var
  Version: string;
  RecFile: string;
  IsD2: Boolean;
  PreviousState: TDeDeSessionActivation;
begin
  ReleaseAnalysis;
  FContext := TDeDeCoreContext.Create;
  FOwnsContext := True;
  FContext.OnProgress := FOnProgress;
  FContext.OnWarning := FOnWarning;
  try
    ActivateLegacyState(PreviousState);
    try
      DeDeCoreContext.ReportProgress('Loading ', ExtractFileName(AFileName),
        0, 100);
      LoadPEBinary(AFileName, FPEFile, FPEHeader, FIsELF);
      FContext.PEFile := FPEFile;
      FContext.PEHeader := FPEHeader;
      FOwnsAnalysis := True;

      IsD2 := False;
      if not bELF and (FPEHeader.ObjectNum > 0) then
      begin
        IsD2 := HasDelphi2BooleanMarker(FPEFile, FPEHeader, 5) or
          HasDelphi2BooleanMarker(FPEFile, FPEHeader, 1);
      end;
      GlobDelphi2 := IsD2;
      GlobCBuilder := False;
      DeDeCoreContext.FileName := AFileName;
      DeDeCoreContext.ProjectName := SafeIdentifier(
        ChangeFileExt(ExtractFileName(AFileName), ''));
      DeDeCoreContext.ExecutableName := ParamStr(0);
      DeDeCoreContext.ClassInfoList.Clear;
      DeDeCoreContext.Warnings.Clear;
      RecFile := ExtractFilePath(DeDeCoreContext.ExecutableName) +
        'classes.lst';
      if FileExists(RecFile) then
        DeDeCoreContext.ClassInfoList.LoadFromFile(RecFile);

      Version := GetDelphiVersion(
        FPEFile, FPEHeader, FIsELF, GlobCBuilder, GlobDelphi2);
      if (Version = '') or (Version = '<unknown version>') or
        (Version = '<check failed>') then
        raise EConvertError.CreateFmt(
          'Unable to identify a supported Delphi target: %s', [AFileName]);
      ConfigureVersion(Version);
      DeDeDisAsm.GlobGetImports := True;
      FClassesDumper := TClassesDumper.Create;
      DeDeCoreContext.ClassesDumper := FClassesDumper;
      DumpClasses(False, False);
      PopulateFormLists;
      FinalizeAnalysis;

      Result.InputFile := AFileName;
      Result.ProjectName := DeDeCoreContext.ProjectName;
      Result.CompilerVersion := Version;
      Result.ClassCount := FClassesDumper.Classes.Count;
      Result.FormCount := DeDeCoreContext.DFMNameList.Count;
      Result.UnitCount := DeDeCoreContext.UnitList.Count;
      DeDeCoreContext.ReportProgress('Analysis complete', '', 100, 100);
      FAnalysisResult := Result;
    finally
      RestoreLegacyState(PreviousState);
    end;
  except
    ReleaseAnalysis;
    raise;
  end;
end;

procedure TDeDeAnalysisSession.AttachAnalysis(APEFile: ThePEFile;
  APEHeader: TPEHeader; AClassesDumper: TClassesDumper;
  const ACompilerVersion: string; AAlreadyAnalyzed: Boolean);
begin
  ReleaseAnalysis;
  if (APEFile = nil) or (APEHeader = nil) or (AClassesDumper = nil) then
    raise EArgumentNilException.Create('Analysis state');
  if DeDeCoreContext = nil then
    raise EInvalidOp.Create('No core context is available to attach');
  FContext := DeDeCoreContext;
  FOwnsContext := False;
  if Assigned(FOnProgress) then
    FContext.OnProgress := FOnProgress;
  if Assigned(FOnWarning) then
    FContext.OnWarning := FOnWarning;
  FPEFile := APEFile;
  FPEHeader := APEHeader;
  FIsELF := bELF;
  FContext.PEFile := APEFile;
  FContext.PEHeader := APEHeader;
  FClassesDumper := AClassesDumper;
  FAnalysisResult.InputFile := DeDeCoreContext.FileName;
  FAnalysisResult.ProjectName := DeDeCoreContext.ProjectName;
  FAnalysisResult.CompilerVersion := ACompilerVersion;
  FAnalysisResult.ClassCount := AClassesDumper.Classes.Count;
  FAnalysisResult.FormCount := DeDeCoreContext.DFMNameList.Count;
  FAnalysisResult.UnitCount := DeDeCoreContext.UnitList.Count;
  FFinalized := AAlreadyAnalyzed;
  DeDeCoreContext.ClassesDumper := AClassesDumper;
  ConfigureVersion(ACompilerVersion);
end;

procedure TDeDeAnalysisSession.DetachAnalysis;
begin
  if FOwnsAnalysis then
    raise EInvalidOp.Create('An owning analysis session cannot be detached');
  ReleaseAnalysis;
end;

function TDeDeAnalysisSession.ExportProject(
  const AOutputDirectory: string; const AOptions: TDeDeExportOptions;
  AForce: Boolean): TStringList;
var
  OutputDirectory, StageDirectory, FileName, TargetFile, StageFile,
    BackupFile, UnitName, FormName, EventName, EventDeclaration,
    EventImplementation, Text, ClassName, TempName: string;
  MethodDeclaration, EvidenceComment: string;
  PlannedFiles, Backups, EventLines: TStringList;
  I, J, EventPosition, FileCount, WrittenFileCount, ExportPosition: Integer;
  ClassDumper: TClassDumper;
  FormDumper: TClassDumper;
  MethodClass: TClassDumper;
  FieldInfo: TFieldRec;
  MethodInfo: TMethodRec;
  MethodRecord: TMethodRec;
  RoutineEvidence: TDeDeRoutineEvidence;
  FrameAccess: TDeDeFrameAccess;
  Input: TMemoryStream;
  DasmList: TStringList;
  BackupMoved, FileInstalled: array of Boolean;
  PreserveStage: Boolean;
  PreviousDisasmErrors: string;
  PreviousState: TDeDeSessionActivation;
  ExportSymbolList: TList;
  PreviousSymbolsList: TList;
  BuiltInSymbol: TDeDeSymbol;
  SymbolCatalogName: string;
  SymbolCatalogStatus: string;
  SymbolCatalogJSONFile: string;
  SymbolCatalogJSONCount: string;
  SymbolCatalogCount: Integer;
  PreviousStrictXRefSymbolMatches: Boolean;

  procedure AddPlannedFile(const AName: string);
  begin
    if (AName = '') or (ExtractFileName(AName) <> AName) then
      raise EConvertError.CreateFmt('Invalid output filename: %s', [AName]);
    if PlannedFiles.IndexOf(AName) >= 0 then
      raise EConvertError.CreateFmt('Duplicate output filename: %s', [AName]);
    PlannedFiles.Add(AName);
  end;

  function SafeFileName(const AName: string): string;
  var
    K: Integer;
  begin
    Result := AName;
    for K := 1 to Length(Result) do
      if CharInSet(Result[K], ['<', '>', ':', '"', '/', '\', '|', '?', '*']) then
        Result[K] := '_';
    while (Result <> '') and
      CharInSet(Result[Length(Result)], [' ', '.']) do
      Delete(Result, Length(Result), 1);
    if Result = '' then
      Result := 'unnamed';
  end;

  procedure ReportExportProgress(const AFileName: string);
  begin
    Inc(ExportPosition);
    DeDeCoreContext.ReportProgress('Exporting ', AFileName, ExportPosition,
      PlannedFiles.Count);
  end;

  procedure ResolveKnownMethodReferences;
  var
    K, L: Integer;
  begin
    for K := 0 to FClassesDumper.Classes.Count - 1 do
    begin
      MethodClass := TClassDumper(FClassesDumper.Classes[K]);
      for L := 0 to MethodClass.MethodData.Methods.Count - 1 do
      begin
        MethodRecord := TMethodRec(MethodClass.MethodData.Methods[L]);
        DeDeCoreContext.CrossReferences.ResolveKnownMethod(
          MethodRecord.dwRVA,
          MethodClass.FsClassName + '.' + MethodRecord.sName);
      end;
    end;
  end;

  procedure LoadBuiltInDSFCatalog;
  var
    SymbolDirectory, SymbolFileName: string;
    Symbol: TDeDeSymbol;
    Search: TSearchRec;
    CandidateCount: Integer;
  begin
    SymbolCatalogName := GetVersionedDSFName(FAnalysisResult.CompilerVersion);
    SymbolCatalogStatus := 'unsupported_compiler_version';
    SymbolCatalogCount := 0;
    if SymbolCatalogName = '' then
      Exit;
    if FIsELF then
    begin
      SymbolCatalogStatus := 'unsupported_image';
      Exit;
    end;

    SymbolDirectory := IncludeTrailingPathDelimiter(
      ExtractFilePath(ParamStr(0))) + 'DSF';
    SymbolFileName := IncludeTrailingPathDelimiter(SymbolDirectory) +
      SymbolCatalogName;
    if not FileExists(SymbolFileName) then
    begin
      CandidateCount := 0;
      if FindFirst(IncludeTrailingPathDelimiter(SymbolDirectory) + '*',
        faAnyFile, Search) = 0 then
      begin
        try
          repeat
            if ((Search.Attr and faDirectory) = 0) and
              SameText(Search.Name, SymbolCatalogName) then
            begin
              Inc(CandidateCount);
              SymbolFileName := IncludeTrailingPathDelimiter(SymbolDirectory) +
                Search.Name;
            end;
          until FindNext(Search) <> 0;
        finally
          FindClose(Search);
        end;
      end;
      if CandidateCount = 0 then
      begin
        SymbolCatalogStatus := 'not_found';
        Exit;
      end;
      if CandidateCount > 1 then
      begin
        SymbolCatalogStatus := 'ambiguous_catalog_file';
        Exit;
      end;
    end;

    Symbol := TDeDeSymbol.Create;
    try
      if not Symbol.LoadSymbol(SymbolFileName) then
      begin
        SymbolCatalogStatus := 'load_failed';
        Exit;
      end;
      if Symbol.PatternSize <> _PatternSize then
      begin
        SymbolCatalogStatus := 'unsupported_pattern_size';
        DeDeCoreContext.ReportWarning(Format(
          'DSF symbol catalog %s has pattern size %d; expected %d',
          [SymbolCatalogName, Symbol.PatternSize, _PatternSize]));
        Exit;
      end;
      SymbolCatalogCount := Symbol.Count;
      if (Symbol.Mode and
        DeDeCoreContext.DelphiVersionCompatibility) = 0 then
      begin
        SymbolCatalogStatus := 'version_incompatible';
        Exit;
      end;
      ExportSymbolList.Add(Symbol);
      BuiltInSymbol := Symbol;
      Symbol := nil;
      SymbolCatalogStatus := 'loaded';
    finally
      Symbol.Free;
    end;
  end;

  procedure ResolveDSFSymbols;
  var
    K, L, CodeSectionIndex: Integer;
    Routine: TDeDeRoutineEvidence;
    Symbol: TDeDeSymbol;
    Matches: TStringList;
    Buffer: TSymBuffer;
    TargetRVA, SectionOffset, PhysicalOffset: DWORD;
    StreamPosition: Int64;
    PreviousMakeCRC: Boolean;
    PreviousB5, PreviousB6, PreviousB7, PreviousB10: Cardinal;
    IsPatternValid: Boolean;
  begin
    if (ExportSymbolList = nil) or (ExportSymbolList.Count = 0) then
      Exit;
    CodeSectionIndex := 1;
    if (CodeSectionIndex < 1) or
      (CodeSectionIndex > FPEHeader.ObjectNum) or
      (FPEHeader.Objects[CodeSectionIndex].PHYSICAL_SIZE < _PatternSize) then
      Exit;
    Matches := TStringList.Create;
    try
      PreviousMakeCRC := DeDeSym.bMakeCRC;
      PreviousB5 := DeDeSym.Glob_B5;
      PreviousB6 := DeDeSym.Glob_B6;
      PreviousB7 := DeDeSym.Glob_B7;
      PreviousB10 := DeDeSym.Glob_B10;
      DeDeSym.bMakeCRC := False;
      try
        for K := 0 to DeDeCoreContext.CrossReferences.RoutineCount - 1 do
        begin
          Routine := DeDeCoreContext.CrossReferences.Routines[K];
          if not (Routine.HasDisassemblyBody or Routine.IsDirectCallTarget) then
            Continue;
          if Routine.RoutineVA < FPEHeader.IMAGE_BASE then
            Continue;
          TargetRVA := Routine.RoutineVA - FPEHeader.IMAGE_BASE;
          if TargetRVA < FPEHeader.Objects[CodeSectionIndex].RVA then
            Continue;
          SectionOffset := TargetRVA -
            FPEHeader.Objects[CodeSectionIndex].RVA;
          if SectionOffset > FPEHeader.Objects[CodeSectionIndex].PHYSICAL_SIZE -
            _PatternSize then
            Continue;
          PhysicalOffset := FPEHeader.Objects[CodeSectionIndex].PHYSICAL_OFFSET +
            SectionOffset;
          if Int64(PhysicalOffset) + _PatternSize >
            DeDeCoreContext.PEFile.PEStream.Size then
            Continue;

          StreamPosition := DeDeCoreContext.PEFile.PEStream.Position;
          try
            DeDeCoreContext.PEFile.PEStream.Seek(
              PhysicalOffset, soFromBeginning);
            DeDeCoreContext.PEFile.PEStream.ReadBuffer(
              Buffer[1], _PatternSize);
          finally
            DeDeCoreContext.PEFile.PEStream.Seek(
              StreamPosition, soFromBeginning);
          end;

          try
            IsPatternValid := DeDeSym.UnlinkCalls(Buffer, 0,
              Routine.RoutineVA);
          except
            on E: EDisAsmError do
            begin
              DeDeCoreContext.ReportWarning(Format(
                'Unable to normalize DSF pattern at VA %s: %s',
                [IntToHex(Routine.RoutineVA, 8), E.Message]));
              Continue;
            end;
          end;
          if not IsPatternValid then
            Continue;
          Matches.Clear;
          for L := 0 to ExportSymbolList.Count - 1 do
          begin
            Symbol := TDeDeSymbol(ExportSymbolList[L]);
            Symbol.FindMatches(Buffer,
              DeDeCoreContext.DelphiVersionCompatibility, Matches);
          end;
          if Matches.Count = 1 then
            DeDeCoreContext.CrossReferences.ResolveDSFSymbol(
              Routine.RoutineVA, Matches[0])
          else if Matches.Count > 1 then
            DeDeCoreContext.CrossReferences.MarkDSFSymbolAmbiguous(
              Routine.RoutineVA);
        end;
      finally
        DeDeSym.bMakeCRC := PreviousMakeCRC;
        DeDeSym.Glob_B5 := PreviousB5;
        DeDeSym.Glob_B6 := PreviousB6;
        DeDeSym.Glob_B7 := PreviousB7;
        DeDeSym.Glob_B10 := PreviousB10;
      end;
    finally
      Matches.Free;
    end;
  end;

  procedure ResolveIndirectImportNames;
  var
    K: Integer;
    Reference: TDeDeXRef;
    ImportName: string;
    StreamPosition: Int64;
    ImportSectionIndex: Integer;
    IATRVA, SectionOffset, IATOffset: DWORD;
  begin
    if (FPEHeader.IAT_RVA = 0) or (FPEHeader.IAT_Size < 4) then
      Exit;
    if FPEHeader.IMPORT_TABLE_RVA = 0 then
      Exit;
    ImportSectionIndex := FPEHeader.GetSectionIndexEx('.idata');
    if (ImportSectionIndex < 1) or
      (ImportSectionIndex > FPEHeader.ObjectNum) then
      ImportSectionIndex :=
        FPEHeader.GetSectionIndexByRVA(FPEHeader.IMPORT_TABLE_RVA);
    if (ImportSectionIndex < 1) or
      (ImportSectionIndex > FPEHeader.ObjectNum) or
      (FPEHeader.Objects[ImportSectionIndex].PHYSICAL_SIZE < 4) then
      Exit;
    for K := 0 to DeDeCoreContext.CrossReferences.Count - 1 do
    begin
      Reference := DeDeCoreContext.CrossReferences[K];
      if (Reference.Kind <> dxkIndirectCall) or
        not Reference.HasIndirectOperandVA then
        Continue;
      if Reference.IndirectOperandVA < FPEHeader.IMAGE_BASE then
        Continue;
      IATRVA := Reference.IndirectOperandVA - FPEHeader.IMAGE_BASE;
      if IATRVA < FPEHeader.IAT_RVA then
        Continue;
      IATOffset := IATRVA - FPEHeader.IAT_RVA;
      if (IATOffset > FPEHeader.IAT_Size - 4) or
        ((IATOffset mod 4) <> 0) then
        Continue;
      if IATRVA < FPEHeader.Objects[ImportSectionIndex].RVA then
        Continue;
      SectionOffset := IATRVA -
        FPEHeader.Objects[ImportSectionIndex].RVA;
      if SectionOffset >
        FPEHeader.Objects[ImportSectionIndex].PHYSICAL_SIZE - 4 then
        Continue;
      StreamPosition := FPEFile.PEStream.Position;
      try
        ImportName := DeDeDisAsm.GetImportReference(
          IntToHex(Reference.IndirectOperandVA, 8), True);
      finally
        FPEFile.PEStream.Seek(StreamPosition, soFromBeginning);
      end;
      if ImportName <> '' then
        DeDeCoreContext.CrossReferences.ResolveImportIATCall(
          Reference.SourceRoutineVA, Reference.SourceInstructionVA,
          Reference.IndirectOperandVA, ImportName);
    end;
  end;

  procedure CollectDirectCallees;
  var
    I, CodeSectionIndex: Integer;
    Reference: TDeDeXRef;
    RoutineInfo: TDeDeRoutineEvidence;
    PreviousClassDumper: TClassDumper;
    TargetRVA, SectionOffset, PhysicalOffset: DWORD;
    RoutineDisassembly: TStringList;
  begin
    if not AOptions.IncludeCrossReferenceReport then
      Exit;
    if FIsELF then
      CodeSectionIndex := FPEHeader.GetSectionIndexEx('.text')
    else
      CodeSectionIndex := 1;
    if (CodeSectionIndex < 1) or
      (CodeSectionIndex > FPEHeader.ObjectNum) then
      Exit;
    PreviousClassDumper := DeDeDisAsm.ClsDmp;
    try
      DeDeDisAsm.ClsDmp := nil;
      I := 0;
      while I < DeDeCoreContext.CrossReferences.Count do
      begin
        Reference := DeDeCoreContext.CrossReferences[I];
        Inc(I);
        if (Reference.Kind <> dxkDirectCall) or not Reference.HasTarget then
          Continue;
        RoutineInfo := DeDeCoreContext.CrossReferences.FindRoutineEvidence(
          Reference.TargetVA);
        if (RoutineInfo <> nil) and
          (RoutineInfo.HasDisassemblyBody or
           RoutineInfo.IsDirectCallTarget) then
          Continue;
        if Reference.TargetVA < FPEHeader.IMAGE_BASE then
          Continue;
        TargetRVA := Reference.TargetVA - FPEHeader.IMAGE_BASE;
        if TargetRVA < FPEHeader.Objects[CodeSectionIndex].RVA then
          Continue;
        SectionOffset := TargetRVA -
          FPEHeader.Objects[CodeSectionIndex].RVA;
        if SectionOffset >=
          FPEHeader.Objects[CodeSectionIndex].PHYSICAL_SIZE then
          Continue;
        PhysicalOffset := FPEHeader.Objects[CodeSectionIndex].PHYSICAL_OFFSET +
          SectionOffset;
        if Int64(PhysicalOffset) + 16 >
          DeDeCoreContext.PEFile.PEStream.Size then
          Continue;
        DeDeCoreContext.CrossReferences.MarkDirectCallTarget(
          Reference.TargetVA);
        DeDeCoreContext.PEFile.PEStream.Seek(
          PhysicalOffset, soFromBeginning);
        RoutineDisassembly := nil;
        try
          DisassembleProc('xref', IntToHex(Reference.TargetVA, 8),
            RoutineDisassembly, True, True);
        finally
          RoutineDisassembly.Free;
        end;
      end;
    finally
      DeDeDisAsm.ClsDmp := PreviousClassDumper;
    end;
  end;

  function StackParameterEvidenceComment(ARoutineRVA: DWORD): string;
  var
    K: Integer;
  begin
    Result := '';
    if not AOptions.IncludeCrossReferenceReport then
      Exit;
    RoutineEvidence :=
      DeDeCoreContext.CrossReferences.FindRoutineEvidence(ARoutineRVA);
    if RoutineEvidence = nil then
      Exit;
    for K := 0 to RoutineEvidence.FrameAccesses.Count - 1 do
    begin
      FrameAccess :=
        TDeDeFrameAccess(RoutineEvidence.FrameAccesses[K]);
      Result := Result + '    // Stack access evidence only: [EBP+$' +
        IntToHex(FrameAccess.StackOffset, 2) + '], operand width ' +
        IntToStr(FrameAccess.OperandSize);
      if FrameAccess.StackWordSlotIndex >= 0 then
        Result := Result + ', stack-word slot ' +
          IntToStr(FrameAccess.StackWordSlotIndex);
      Result := Result + ', observed at ' + IntToStr(FrameAccess.AccessCount) +
        ' instruction(s); see cross-references.json for corroboration' +
        #13#10;
    end;
    if RoutineEvidence.HasCalleeCleanup and
      ((RoutineEvidence.CalleeCleanupBytes > 0) or
       RoutineEvidence.CalleeCleanupConflict) then
    begin
      Result := Result + '    // Callee cleanup evidence only: ';
      if RoutineEvidence.CalleeCleanupConflict then
        Result := Result + 'conflicting ret cleanup values'
      else
        Result := Result + 'ret ' +
          IntToStr(RoutineEvidence.CalleeCleanupBytes) + ' bytes';
      Result := Result + '; see cross-references.json for corroboration' +
        #13#10;
    end;
  end;

  procedure AnnotatePASWithDSFSymbolNames;
  var
    I, LineStart, LineEnd, LineBreakLength: Integer;
    Reference: TDeDeXRef;
    NameByInstruction: TStringList;
    PASFileName, AddressKey, TargetName: string;
    Stream: TFileStream;
    UpdatedStream: TMemoryStream;
    Content, Line, AnnotatedLine, CommentBytes: AnsiString;
    Changed: Boolean;

    procedure WriteAnsi(const AValue: AnsiString);
    begin
      if AValue <> '' then
        UpdatedStream.WriteBuffer(AValue[1], Length(AValue));
    end;

  begin
    NameByInstruction := TStringList.Create;
    try
      NameByInstruction.CaseSensitive := False;
      for I := 0 to DeDeCoreContext.CrossReferences.Count - 1 do
      begin
        Reference := DeDeCoreContext.CrossReferences[I];
        if (Reference.Kind = dxkDirectCall) and
          (Reference.TargetResolution = 'known_dsf_symbol') and
          (Reference.TargetName <> '') then
          NameByInstruction.Values[IntToHex(
            Reference.SourceInstructionVA, 8)] := Reference.TargetName;
      end;

      if NameByInstruction.Count = 0 then
        Exit;
      for I := 0 to PlannedFiles.Count - 1 do
      begin
        if not SameText(ExtractFileExt(PlannedFiles[I]), '.pas') then
          Continue;
        PASFileName := IncludeTrailingPathDelimiter(StageDirectory) +
          PlannedFiles[I];
        if not FileExists(PASFileName) then
          Continue;

        Stream := TFileStream.Create(PASFileName,
          fmOpenReadWrite or fmShareExclusive);
        UpdatedStream := TMemoryStream.Create;
        try
          if Stream.Size > MaxInt then
            raise EStreamError.CreateFmt(
              'PAS output is too large to annotate: %s', [PASFileName]);
          SetLength(Content, Integer(Stream.Size));
          if Content <> '' then
          begin
            Stream.ReadBuffer(Content[1], Length(Content));
            LineStart := 1;
            Changed := False;
            while LineStart <= Length(Content) do
            begin
              LineEnd := LineStart;
              while (LineEnd <= Length(Content)) and
                not (Content[LineEnd] in [#10, #13]) do
                Inc(LineEnd);
              Line := Copy(Content, LineStart, LineEnd - LineStart);
              AnnotatedLine := Line;
              if Length(Line) >= 8 then
              begin
                AddressKey := Copy(string(Line), 1, 8);
                TargetName := NameByInstruction.Values[AddressKey];
                if (TargetName <> '') and
                  (Pos('call', LowerCase(string(Line))) > 0) and
                  (Pos(TargetName, string(Line)) = 0) then
                begin
                  CommentBytes := AnsiString(' // DSF: ' + TargetName);
                  AnnotatedLine := Line + CommentBytes;
                  Changed := True;
                end;
              end;
              WriteAnsi(AnnotatedLine);
              LineBreakLength := 0;
              if LineEnd <= Length(Content) then
              begin
                if (Content[LineEnd] = #13) and
                  (LineEnd < Length(Content)) and
                  (Content[LineEnd + 1] = #10) then
                  LineBreakLength := 2
                else
                  LineBreakLength := 1;
                UpdatedStream.WriteBuffer(Content[LineEnd],
                  LineBreakLength);
              end;
              LineStart := LineEnd + LineBreakLength;
            end;
            if Changed then
            begin
              Stream.Size := 0;
              Stream.Position := 0;
              UpdatedStream.Position := 0;
              Stream.CopyFrom(UpdatedStream, 0);
            end;
          end;
        finally
          UpdatedStream.Free;
          Stream.Free;
        end;
      end;
    finally
      NameByInstruction.Free;
    end;
  end;

  procedure CleanupStage;
  var
    K: Integer;
  begin
    for K := 0 to PlannedFiles.Count - 1 do
    begin
      TempName := IncludeTrailingPathDelimiter(StageDirectory) +
        PlannedFiles[K];
      if FileExists(TempName) then
        DeleteCoreFile(TempName);
      TempName := IncludeTrailingPathDelimiter(StageDirectory) +
        'backup_' + IntToStr(K) + '.bak';
      if FileExists(TempName) then
        DeleteCoreFile(TempName);
    end;
    RemoveCoreDirectory(StageDirectory);
  end;

begin
  if FContext = nil then
    raise EInvalidOp.Create('Analysis session has no core context');
  Result := TStringList.Create;
  PlannedFiles := TStringList.Create;
  Backups := TStringList.Create;
  EventLines := TStringList.Create;
  PreviousDisasmErrors := DeDeDisAsm.sDisAsmErrors;
  ActivateLegacyState(PreviousState);
  ExportSymbolList := nil;
  PreviousSymbolsList := DeDeDisAsm.SymbolsList;
  BuiltInSymbol := nil;
  SymbolCatalogName := '';
  SymbolCatalogStatus := 'not_requested';
  SymbolCatalogCount := 0;
  PreviousStrictXRefSymbolMatches :=
    DeDeCoreContext.StrictXRefSymbolMatches;
  DeDeCoreContext.StrictXRefSymbolMatches :=
    AOptions.IncludeCrossReferenceReport;
  DeDeDisAsm.sDisAsmErrors := '';
  try
    try
      if FClassesDumper = nil then
        raise EInvalidOp.Create('Analyze a binary before exporting a project');
    if AOutputDirectory = '' then
      raise EArgumentException.Create('An output directory is required');
    PlannedFiles.CaseSensitive := False;
    ExportPosition := 0;

    DeDeDisAsm.PASNameList := DeDeCoreContext.PASNameList;
    DeDeDisAsm.DFMNameList := DeDeCoreContext.DFMNameList;
    DeDeDisAsm.UnitList.Assign(DeDeCoreContext.UnitList);
    if FOpcodeList <> nil then
      DeDeDisAsm.FOpCodeList := FOpcodeList;
    if AOptions.IncludeDPR or AOptions.IncludePAS then
    begin
      if FIsELF then
        J := FPEHeader.GetSectionIndexEx('.text')
      else
        J := 1;
      if (J < 1) or (J > FPEHeader.ObjectNum) then
        raise EInvalidOp.Create('Executable code section was not found');
    end;

    OutputDirectory := ExcludeTrailingPathDelimiter(AOutputDirectory);
    if FileExists(OutputDirectory) then
      raise EInOutError.CreateFmt('Output path is not a directory: %s',
        [OutputDirectory]);

    if AOptions.IncludeDPR then
      AddPlannedFile(SafeFileName(DeDeCoreContext.ProjectName) + '.dpr');
    if AOptions.IncludeEventRVA then
      AddPlannedFile('events.txt');
    if DeDeDisAsm.sDisAsmErrors <> '' then
      DeDeCoreContext.Warnings.Add(
        'Disassembler errors:' + #13#10 + DeDeDisAsm.sDisAsmErrors);

    if AOptions.IncludeAnalysisReport then
      AddPlannedFile('analysis.json');
    if AOptions.IncludeCrossReferenceReport then
      AddPlannedFile('cross-references.json');

    if AOptions.IncludeDFM then
      for I := 0 to DeDeCoreContext.DFMFormList.Count - 1 do
      begin
        FormName := DeDeCoreContext.DFMFormList[I];
        J := DeDeCoreContext.DFMNameList.IndexOf(FormName);
        if J >= 0 then
          FileName := SafeFileName(DeDeCoreContext.PASNameList[J]) + '.dfm'
        else
          FileName := SafeFileName(FormName) + '.dfm';
        AddPlannedFile(FileName);
      end;

    if AOptions.IncludePAS then
    begin
      if DeDeCoreContext.DFMNameList.Count <>
        DeDeCoreContext.PASNameList.Count then
        raise EInvalidOp.Create('Form and unit lists are inconsistent');
      for I := 0 to DeDeCoreContext.PASNameList.Count - 1 do
        AddPlannedFile(SafeFileName(DeDeCoreContext.PASNameList[I]) + '.pas');
    end;

    if not AForce then
      for I := 0 to PlannedFiles.Count - 1 do
      begin
        TargetFile := IncludeTrailingPathDelimiter(OutputDirectory) +
          PlannedFiles[I];
        if FileExists(TargetFile) then
          raise EDeDeOutputExists.CreateFmt(
            'Output file already exists (use --force to replace): %s',
            [TargetFile]);
      end;

    if not ForceDirectories(OutputDirectory) then
      raise EInOutError.CreateFmt('Unable to create output directory: %s',
        [OutputDirectory]);

    I := 0;
    repeat
      StageDirectory := IncludeTrailingPathDelimiter(OutputDirectory) +
        '.dede-stage-' + IntToHex(GetCoreTickCount, 8) + '-' + IntToStr(I);
      Inc(I);
    until not DirectoryExists(StageDirectory);
    if not ForceDirectories(StageDirectory) then
      raise EInOutError.CreateFmt('Unable to create staging directory: %s',
        [StageDirectory]);
    PreserveStage := False;

    try
      if AOptions.IncludeCrossReferenceReport then
      begin
        DeDeCoreContext.CrossReferences.Clear;
        ExportSymbolList := TList.Create;
        DeDeDisAsm.SymbolsList := ExportSymbolList;
        LoadBuiltInDSFCatalog;
      end;
      if AOptions.IncludeEventRVA then
      begin
        EventLines.Add(txt_copyright);
        EventLines.Add('');
        for I := 0 to FClassesDumper.Classes.Count - 1 do
        begin
          ClassDumper := TClassDumper(FClassesDumper.Classes[I]);
          if ClassDumper.MethodData.Count = 0 then
            Continue;
          EventLines.Add(ClassDumper.FsUnitName);
          for J := 0 to ClassDumper.MethodData.Count - 1 do
          begin
            FormDumper := ClassDumper;
            EventName := TMethodRec(FormDumper.MethodData.Methods[J]).sName;
            if TMethodRec(FormDumper.MethodData.Methods[J]).wFlag = 0 then
              Continue;
            Text := ClassDumper.FsClassName + '.' + EventName;
            while Length(Text) < 65 do
              Text := Text + ' ';
            EventLines.Add(Text + IntToHex(
              TMethodRec(FormDumper.MethodData.Methods[J]).dwRVA, 8));
          end;
          EventLines.Add('');
          EventLines.Add('');
        end;
        EventLines.SaveToFile(
          IncludeTrailingPathDelimiter(StageDirectory) + 'events.txt');
        ReportExportProgress('events.txt');
      end;

      if AOptions.IncludeDPR then
      begin
        InitNewEmulation('', '', '', '');
        DeDePAS.GenerateDPR(DeDeCoreContext.ProjectName,
          IncludeTrailingPathDelimiter(StageDirectory) +
            SafeFileName(DeDeCoreContext.ProjectName) + '.dpr',
          DeDeCoreContext.UnitList, DeDeCoreContext.DFMNameList,
          FPEHeader.RVA_ENTRYPOINT - FPEHeader.Objects[1].RVA +
            FPEHeader.Objects[1].PHYSICAL_OFFSET,
          FPEHeader.RVA_ENTRYPOINT + FPEHeader.IMAGE_BASE);
        ReportExportProgress(SafeFileName(DeDeCoreContext.ProjectName) +
          '.dpr');
      end;

      if AOptions.IncludeDFM then
        for I := 0 to DeDeCoreContext.DFMFormList.Count - 1 do
        begin
          FormName := DeDeCoreContext.DFMFormList[I];
          J := DeDeCoreContext.DFMNameList.IndexOf(FormName);
          if J >= 0 then
            FileName := SafeFileName(DeDeCoreContext.PASNameList[J]) + '.dfm'
          else
            FileName := SafeFileName(FormName) + '.dfm';
          Input := DeDeCoreContext.ExtractDFM(FormName);
          try
            Input.SaveToFile(
              IncludeTrailingPathDelimiter(StageDirectory) + FileName);
          finally
            Input.Free;
          end;
          ReportExportProgress(FileName);
        end;

      if AOptions.IncludePAS then
      begin
        DeDeDisAsm.PASNameList := DeDeCoreContext.PASNameList;
        if FOpcodeList <> nil then
          DeDeDisAsm.FOpCodeList := FOpcodeList;
        DeDeDisAsm.DFMNameList := DeDeCoreContext.DFMNameList;
        for I := 0 to DeDeCoreContext.DFMNameList.Count - 1 do
        begin
          FormName := DeDeCoreContext.DFMNameList[I];
          UnitName := DeDeCoreContext.PASNameList[I];
          FormDumper := FClassesDumper.GetClass(FormName);
          if FormDumper = nil then
            Continue;

          DeDeDisAsm.ClsDmp := FormDumper;
          DeDeDisAsm.ControlNames.Clear;
          DeDeDisAsm.ControlIDs.Clear;
          for J := 0 to FormDumper.FieldData.Count - 1 do
          begin
            DeDeDisAsm.ControlNames.Add(
              TFieldRec(FormDumper.FieldData.Fields[J]).sName);
            DeDeDisAsm.ControlIDs.Add(IntToHex(
              TFieldRec(FormDumper.FieldData.Fields[J]).dwID, 8));
          end;

          DeDePAS.StartNewPas(Input, UnitName);
          try
            EventDeclaration := 'type' + #13#10 + '  ' + FormName +
              '=class(TForm)' + #13#10;
            EventImplementation := '  private' + #13#10 +
              '    { Private declarations }' + #13#10 + '  public' + #13#10 +
              '    { Public declarations }' + #13#10 + '  end ;' + #13#10 +
              #13#10 + 'var' + #13#10 + '  ' +
              Copy(FormName, 2, Length(FormName) - 1) + ': ' + FormName +
              ';' + #13#10 + #13#10 +
              '{This file is generated by DeDe Copyright (c) 1999-2002 DaFixer}' +
              #13#10 + #13#10 + 'implementation' + #13#10 + #13#10 +
              '{$R *.DFM}' + #13#10 + #13#10;

            for J := 0 to FormDumper.FieldData.Count - 1 do
            begin
              FieldInfo := TFieldRec(FormDumper.FieldData.Fields[J]);
              EventName := FieldInfo.sName;
              EventDeclaration := EventDeclaration + '    ' + EventName +
                ': ' + GetControlClassEx(FormName, EventName) +
                ';//f' + IntToHex(FieldInfo.dwID, 1) + #13#10;
            end;

            for J := 0 to FormDumper.MethodData.Count - 1 do
            begin
              MethodInfo := TMethodRec(FormDumper.MethodData.Methods[J]);
              EventName := MethodInfo.sName;
              Text := GetEventPrototype(FormName, EventName);
              EventPosition := Pos('(', Text);
              if EventPosition = 0 then
                raise EConvertError.CreateFmt(
                  'Invalid event prototype for %s.%s',
                  [FormName, EventName]);
              MethodDeclaration := '    ' +
                Copy(Text, 1, EventPosition - 1) + ' ' + EventName +
                Copy(Text, EventPosition, MaxInt);
              if MethodInfo.dwVMTOffset <> METHOD_VMT_OFFSET_NONE then
                MethodDeclaration := MethodDeclaration + '//v' +
                  IntToHex(MethodInfo.dwVMTOffset, 1) +
                  '//'
              else
                MethodDeclaration := MethodDeclaration + '//';
              MethodDeclaration := MethodDeclaration + IntToHex(
                MethodInfo.dwRVA, 8);
              DasmList := nil;
              try
                DisassembleProc(UnitName, EventName, DasmList, False);
                EvidenceComment :=
                  StackParameterEvidenceComment(MethodInfo.dwRVA);
                EventDeclaration := EventDeclaration + MethodDeclaration +
                  #13#10 + EvidenceComment;
                EventImplementation := EventImplementation +
                  Copy(Text, 1, EventPosition - 1) + ' ' + FormName + '.' +
                  EventName + Copy(Text, EventPosition, MaxInt) + #13#10 +
                  'begin' + #13#10 + '(*' + #13#10 + DasmList.Text + '*)' +
                  #13#10 + 'end;' + #13#10#13#10;
              finally
                DasmList.Free;
              end;
            end;

            EventImplementation := EventImplementation + 'end.';
            WriteAnsiText(Input, EventDeclaration);
            WriteAnsiText(Input, EventImplementation);
            Input.SaveToFile(IncludeTrailingPathDelimiter(StageDirectory) +
              SafeFileName(UnitName) + '.pas');
            ReportExportProgress(SafeFileName(UnitName) + '.pas');
          finally
            Input.Free;
          end;
        end;
      end;

      if AOptions.IncludeAnalysisReport then
      begin
        FileCount := 0;
        for I := 0 to PlannedFiles.Count - 1 do
          if not SameText(PlannedFiles[I], 'analysis.json') and
            not SameText(PlannedFiles[I], 'cross-references.json') then
            Inc(FileCount);
        Text := '{' + #13#10 +
          '  "input": ' + JSONString(FAnalysisResult.InputFile) + ',' +
          #13#10 +
          '  "project": ' + JSONString(FAnalysisResult.ProjectName) + ',' +
          #13#10 +
          '  "compilerVersion": ' +
            JSONString(FAnalysisResult.CompilerVersion) + ',' + #13#10 +
          '  "classCount": ' + IntToStr(FAnalysisResult.ClassCount) + ',' +
          #13#10 +
          '  "formCount": ' + IntToStr(FAnalysisResult.FormCount) + ',' +
          #13#10 +
          '  "unitCount": ' + IntToStr(FAnalysisResult.UnitCount) + ',' +
          #13#10 +
          '  "files": [';
        WrittenFileCount := 0;
        for I := 0 to PlannedFiles.Count - 1 do
        begin
          if SameText(PlannedFiles[I], 'analysis.json') then
            Continue;
          if SameText(PlannedFiles[I], 'cross-references.json') then
            Continue;
          if WrittenFileCount > 0 then
            Text := Text + ',';
          if FileCount > 0 then
            Text := Text + #13#10;
          Text := Text + '    ' + JSONString(PlannedFiles[I]);
          Inc(WrittenFileCount);
        end;
        Text := Text + #13#10 + '  ],' + #13#10 + '  "warnings": [';
        for I := 0 to DeDeCoreContext.Warnings.Count - 1 do
        begin
          if I > 0 then
            Text := Text + ',';
          Text := Text + #13#10 + '    ' +
            JSONString(DeDeCoreContext.Warnings[I]);
        end;
        Text := Text + #13#10 + '  ]' + #13#10 + '}' + #13#10;
        SaveUTF8Text(IncludeTrailingPathDelimiter(StageDirectory) +
          'analysis.json', Text);
        ReportExportProgress('analysis.json');
      end;

      if AOptions.IncludeCrossReferenceReport then
      begin
        CollectDirectCallees;
        ResolveIndirectImportNames;
        ResolveKnownMethodReferences;
        ResolveDSFSymbols;
        AnnotatePASWithDSFSymbolNames;
        if SymbolCatalogName <> '' then
          SymbolCatalogJSONFile := JSONString('DSF/' + SymbolCatalogName)
        else
          SymbolCatalogJSONFile := 'null';
        if SymbolCatalogStatus = 'loaded' then
          SymbolCatalogJSONCount := IntToStr(SymbolCatalogCount)
        else
          SymbolCatalogJSONCount := 'null';
        Text := '{' + #13#10 +
          '  "format": "dede-xref-v1",' + #13#10 +
          '  "architecture": "x86-pe32",' + #13#10 +
          '  "routineDiscovery": ' +
            JSONString('exported_disassembly_plus_reachable_direct_call_targets') +
            ',' + #13#10 +
          '  "symbolCatalog": {' + #13#10 +
          '    "source": "application_dsf",' + #13#10 +
          '    "file": ' + SymbolCatalogJSONFile + ',' + #13#10 +
          '    "status": ' + JSONString(SymbolCatalogStatus) + ',' + #13#10 +
          '    "compilerVersion": ' +
            JSONString(FAnalysisResult.CompilerVersion) + ',' + #13#10 +
          '    "symbolCount": ' + SymbolCatalogJSONCount + #13#10 +
          '  },' + #13#10 +
          '  "references": ' +
            DeDeCoreContext.CrossReferences.ToJSON + ',' + #13#10 +
          '  "routines": ' +
            DeDeCoreContext.CrossReferences.RoutinesToJSON + ',' + #13#10 +
          '  "disassemblyErrors": ' +
            JSONString(DeDeDisAsm.sDisAsmErrors) + #13#10 +
          '}' + #13#10;
        SaveUTF8Text(IncludeTrailingPathDelimiter(StageDirectory) +
          'cross-references.json', Text);
        ReportExportProgress('cross-references.json');
      end;

      SetLength(BackupMoved, PlannedFiles.Count);
      SetLength(FileInstalled, PlannedFiles.Count);
      Backups.Clear;
      for I := 0 to PlannedFiles.Count - 1 do
        Backups.Add('');
      try
        for I := 0 to PlannedFiles.Count - 1 do
        begin
          TargetFile := IncludeTrailingPathDelimiter(OutputDirectory) +
            PlannedFiles[I];
          if FileExists(TargetFile) then
          begin
            if not AForce then
              raise EDeDeOutputExists.CreateFmt('Output file appeared during export: %s',
                [TargetFile]);
            BackupFile := IncludeTrailingPathDelimiter(StageDirectory) +
              'backup_' + IntToStr(I) + '.bak';
            if not RenameCoreFile(TargetFile, BackupFile) then
              raise EInOutError.CreateFmt('Unable to back up output file: %s',
                [TargetFile]);
            BackupMoved[I] := True;
            Backups[I] := BackupFile;
          end;
        end;

        for I := 0 to PlannedFiles.Count - 1 do
        begin
          TargetFile := IncludeTrailingPathDelimiter(OutputDirectory) +
            PlannedFiles[I];
          StageFile := IncludeTrailingPathDelimiter(StageDirectory) +
            PlannedFiles[I];
          if not RenameCoreFile(StageFile, TargetFile) then
            raise EInOutError.CreateFmt('Unable to install output file: %s',
              [TargetFile]);
          FileInstalled[I] := True;
        end;
      except
        for I := PlannedFiles.Count - 1 downto 0 do
        begin
          if FileInstalled[I] then
          begin
            TargetFile := IncludeTrailingPathDelimiter(OutputDirectory) +
              PlannedFiles[I];
            StageFile := IncludeTrailingPathDelimiter(StageDirectory) +
              PlannedFiles[I];
            if not RenameCoreFile(TargetFile, StageFile) then
              PreserveStage := True;
          end;
        end;
        for I := PlannedFiles.Count - 1 downto 0 do
          if BackupMoved[I] then
          begin
            TargetFile := IncludeTrailingPathDelimiter(OutputDirectory) +
              PlannedFiles[I];
            BackupFile := Backups[I];
            if not RenameCoreFile(BackupFile, TargetFile) then
              PreserveStage := True;
          end;
        raise;
      end;

      for I := 0 to PlannedFiles.Count - 1 do
        Result.Add(IncludeTrailingPathDelimiter(OutputDirectory) +
          PlannedFiles[I]);
    finally
      if not PreserveStage then
        CleanupStage;
    end;
    except
      Result.Free;
      Result := nil;
      raise;
    end;
  finally
    DeDeDisAsm.sDisAsmErrors := PreviousDisasmErrors;
    DeDeDisAsm.sDisAsmErrors := PreviousDisasmErrors;
    DeDeDisAsm.SymbolsList := PreviousSymbolsList;
    DeDeCoreContext.StrictXRefSymbolMatches :=
      PreviousStrictXRefSymbolMatches;
    if BuiltInSymbol <> nil then
      BuiltInSymbol.Free;
    ExportSymbolList.Free;
    RestoreLegacyState(PreviousState);
    EventLines.Free;
    Backups.Free;
    PlannedFiles.Free;
  end;
end;

end.
