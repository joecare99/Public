unit DeDeCore;

interface

uses
  Classes, SysUtils, DeDeClasses, DeDeClassHandle;

type
  EDeDeOutputExists = class(EInOutError);

  TDeDeExportOptions = record
    IncludeDFM: Boolean;
    IncludePAS: Boolean;
    IncludeDPR: Boolean;
    IncludeEventRVA: Boolean;
    IncludeAnalysisReport: Boolean;
  end;

  TDeDeAnalysisResult = record
    InputFile: string;
    ProjectName: string;
    CompilerVersion: string;
    ClassCount: Integer;
    FormCount: Integer;
    UnitCount: Integer;
  end;

  TDeDeAnalysisSession = class
  private
    FPEFile: ThePEFile;
    FPEHeader: TPEHeader;
    FClassesDumper: TClassesDumper;
    FOpcodeList: TList;
    FSymbolsList: TList;
    FAnalysisResult: TDeDeAnalysisResult;
    FOwnsAnalysis: Boolean;
    FFinalized: Boolean;
    procedure ReleaseAnalysis;
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
  end;

function HasDelphi2BooleanMarker(AFile: ThePEFile; AHeader: TPEHeader;
  AOffset: DWORD): Boolean;

implementation

uses
  DeDeCoreServices, DeDeConstants, DeDeDisAsm,
  DeDeClassEmulator, DeDeSym, DeDeELFClasses, DeDePAS, DeDeRes,
  DeDeAnsiStream
{$IFDEF MSWINDOWS}
  , Windows
{$ENDIF}
  ;

function HostTickCount: LongWord;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetTickCount;
{$ELSE}
  Result := LongWord(GetTickCount64);
{$ENDIF}
end;

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

procedure TDeDeAnalysisSession.ReleaseAnalysis;
begin
  FFinalized := False;
  if FOwnsAnalysis then
  begin
    DeDeCoreContext.ClassesDumper := nil;
    DeDeDisAsm.PEStream := nil;
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
    DeDeClasses.PEHeader := nil;
    DeDeClasses.PEFile := nil;
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
  FOwnsAnalysis := False;
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
  DeDeDisAsm.PEStream := FPEFile.PEStream;
  DeDeDisAsm.DFMNameList := DeDeCoreContext.DFMNameList;
  DeDeDisAsm.PASNameList := DeDeCoreContext.PASNameList;
  DeDeDisAsm.UnitList.Clear;
  DeDeDisAsm.ControlNames.Clear;
  DeDeDisAsm.ControlIDs.Clear;
  DeDeDisAsm.GlobBEmulation := bBSS;
  DeDeDisAsm.GlobCustomEmulInit := False;

  if bELF then
    CodeIndex := FPEHeader.GetSectionIndexEx('.text')
  else
    CodeIndex := 1;
  if (CodeIndex < 1) or (CodeIndex > FPEHeader.ObjectNum) then
    raise Exception.Create('Executable code section was not found');

  DeDeDisAsm.RVAConverter.ImageBase := FPEHeader.IMAGE_BASE;
  DeDeDisAsm.RVAConverter.PhysOffset :=
    FPEHeader.Objects[CodeIndex].PHYSICAL_OFFSET;
  DeDeDisAsm.RVAConverter.CodeRVA := FPEHeader.Objects[CodeIndex].RVA;
  if FOwnsAnalysis then
  begin
    FOpcodeList := TList.Create;
    DeDeDisAsm.FOpCodeList := FOpcodeList;
    FSymbolsList := TList.Create;
    DeDeDisAsm.SymbolsList := FSymbolsList;
  end;
end;

procedure TDeDeAnalysisSession.DumpClasses(AUserProcs, ABSS: Boolean);
begin
  if (FPEFile = nil) or (FPEHeader = nil) or (FClassesDumper = nil) then
    raise EInvalidOp.Create('Analysis session is not attached to a binary');
  DeDeClasses.PEFile := FPEFile;
  DeDeClasses.PEHeader := FPEHeader;
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
begin
  if FClassesDumper = nil then
    raise EInvalidOp.Create('No class dump is available to finalize');
  if FFinalized then
    Exit;
  FClassesDumper.FinilizeDump;
  FFinalized := True;
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
begin
  ReleaseAnalysis;
  DeDeCoreContext.ReportProgress('Loading ', ExtractFileName(AFileName),
    0, 100);
  LoadPEBinary(AFileName, FPEFile, FPEHeader, bELF);
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
  RecFile := ExtractFilePath(DeDeCoreContext.ExecutableName) + 'classes.lst';
  if FileExists(RecFile) then
    DeDeCoreContext.ClassInfoList.LoadFromFile(RecFile);

  Version := GetDelphiVersion(FPEFile);
  if (Version = '') or (Version = '<unknown version>') or
    (Version = '<check failed>') then
    raise EConvertError.CreateFmt('Unable to identify a supported Delphi target: %s',
      [AFileName]);
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
end;

procedure TDeDeAnalysisSession.AttachAnalysis(APEFile: ThePEFile;
  APEHeader: TPEHeader; AClassesDumper: TClassesDumper;
  const ACompilerVersion: string; AAlreadyAnalyzed: Boolean);
begin
  ReleaseAnalysis;
  if (APEFile = nil) or (APEHeader = nil) or (AClassesDumper = nil) then
    raise EArgumentNilException.Create('Analysis state');
  FPEFile := APEFile;
  FPEHeader := APEHeader;
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
  PlannedFiles, Backups, EventLines: TStringList;
  I, J, EventPosition, FileCount, WrittenFileCount, ExportPosition: Integer;
  ClassDumper: TClassDumper;
  FormDumper: TClassDumper;
  Input: TMemoryStream;
  DasmList: TStringList;
  BackupMoved, FileInstalled: array of Boolean;
  PreserveStage: Boolean;
  PreviousDisasmErrors: string;

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

  procedure CleanupStage;
  var
    K: Integer;
  begin
    for K := 0 to PlannedFiles.Count - 1 do
    begin
      TempName := IncludeTrailingPathDelimiter(StageDirectory) +
        PlannedFiles[K];
      if FileExists(TempName) then
        SysUtils.DeleteFile(TempName);
      TempName := IncludeTrailingPathDelimiter(StageDirectory) +
        'backup_' + IntToStr(K) + '.bak';
      if FileExists(TempName) then
        SysUtils.DeleteFile(TempName);
    end;
    RemoveDir(StageDirectory);
  end;

begin
  Result := TStringList.Create;
  PlannedFiles := TStringList.Create;
  Backups := TStringList.Create;
  EventLines := TStringList.Create;
  PreviousDisasmErrors := DeDeDisAsm.sDisAsmErrors;
  DeDeDisAsm.sDisAsmErrors := '';
  try
    try
      if FClassesDumper = nil then
        raise EInvalidOp.Create('Analyze a binary before exporting a project');
    if AOutputDirectory = '' then
      raise EArgumentException.Create('An output directory is required');
    PlannedFiles.CaseSensitive := False;
    ExportPosition := 0;

    DeDeClasses.PEFile := FPEFile;
    DeDeClasses.PEHeader := FPEHeader;
    DeDeDisAsm.PEStream := FPEFile.PEStream;
    DeDeDisAsm.PASNameList := DeDeCoreContext.PASNameList;
    DeDeDisAsm.DFMNameList := DeDeCoreContext.DFMNameList;
    DeDeDisAsm.UnitList.Assign(DeDeCoreContext.UnitList);
    if FOpcodeList <> nil then
      DeDeDisAsm.FOpCodeList := FOpcodeList;
    if AOptions.IncludeDPR or AOptions.IncludePAS then
    begin
      if bELF then
        J := FPEHeader.GetSectionIndexEx('.text')
      else
        J := 1;
      if (J < 1) or (J > FPEHeader.ObjectNum) then
        raise EInvalidOp.Create('Executable code section was not found');
      DeDeDisAsm.RVAConverter.ImageBase := FPEHeader.IMAGE_BASE;
      DeDeDisAsm.RVAConverter.PhysOffset :=
        FPEHeader.Objects[J].PHYSICAL_OFFSET;
      DeDeDisAsm.RVAConverter.CodeRVA := FPEHeader.Objects[J].RVA;
    end;

    OutputDirectory := ExcludeTrailingPathDelimiter(AOutputDirectory);
    if FileExists(OutputDirectory) then
      raise EInOutError.CreateFmt('Output path is not a directory: %s',
        [OutputDirectory]);
    if not ForceDirectories(OutputDirectory) then
      raise EInOutError.CreateFmt('Unable to create output directory: %s',
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

    I := 0;
    repeat
      StageDirectory := IncludeTrailingPathDelimiter(OutputDirectory) +
        '.dede-stage-' + IntToHex(HostTickCount, 8) + '-' + IntToStr(I);
      Inc(I);
    until not DirectoryExists(StageDirectory);
    if not ForceDirectories(StageDirectory) then
      raise EInOutError.CreateFmt('Unable to create staging directory: %s',
        [StageDirectory]);
    PreserveStage := False;

    try
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
        DeDeDisAsm.PEStream := FPEFile.PEStream;
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
        DeDeDisAsm.PEStream := FPEFile.PEStream;
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
              EventName := TFieldRec(FormDumper.FieldData.Fields[J]).sName;
              EventDeclaration := EventDeclaration + '    ' + EventName +
                ': ' + GetControlClassEx(FormName, EventName) + ';' + #13#10;
            end;

            for J := 0 to FormDumper.MethodData.Count - 1 do
            begin
              EventName := TMethodRec(FormDumper.MethodData.Methods[J]).sName;
              Text := GetEventPrototype(FormName, EventName);
              EventPosition := Pos('(', Text);
              if EventPosition = 0 then
                raise EConvertError.CreateFmt(
                  'Invalid event prototype for %s.%s',
                  [FormName, EventName]);
              EventDeclaration := EventDeclaration + '    ' +
                Copy(Text, 1, EventPosition - 1) + ' ' + EventName +
                Copy(Text, EventPosition, MaxInt) + #13#10;
              DasmList := nil;
              try
                DisassembleProc(UnitName, EventName, DasmList, False);
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
          if not SameText(PlannedFiles[I], 'analysis.json') then
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
            if not RenameFile(TargetFile, BackupFile) then
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
          if not RenameFile(StageFile, TargetFile) then
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
            if not RenameFile(TargetFile, StageFile) then
              PreserveStage := True;
          end;
        end;
        for I := PlannedFiles.Count - 1 downto 0 do
          if BackupMoved[I] then
          begin
            TargetFile := IncludeTrailingPathDelimiter(OutputDirectory) +
              PlannedFiles[I];
            BackupFile := Backups[I];
            if not RenameFile(BackupFile, TargetFile) then
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
    EventLines.Free;
    Backups.Free;
    PlannedFiles.Free;
  end;
end;

end.
