unit DeDeCoreServices;

interface

uses
  Classes, SysUtils, DeDeClasses, DeDeConstants, DeDeBinaryTypes;

type
  TDeDeCoreProgressEvent = procedure(const APhase, ADetail: string;
    APosition, AMaximum: Integer) of object;
  TDeDeCoreWarningEvent = procedure(const AMessage: string) of object;
  TDeDeCoreDebugEvent = procedure(const AMessage: string) of object;
  TDeDeCoreConfirmEvent = function(const ATitle, AMessage: string): Boolean of object;

  TDeDeCoreContext = class
  private
    FPEFile: ThePEFile;
    FPEHeader: TPEHeader;
    function GetPEFile: ThePEFile;
    function GetPEHeader: TPEHeader;
  public
    ProjectName: string;
    FileName: string;
    ExecutableName: string;
    ClassCount: Integer;
    DelphiVersionCompatibility: Byte;
    ClassesDumper: TObject;
    ClassInfoList: TStringList;
    DFMFormList: TStringList;
    DFMNameList: TStringList;
    PASNameList: TStringList;
    UnitList: TStringList;
    Warnings: TStringList;
    OnProgress: TDeDeCoreProgressEvent;
    OnWarning: TDeDeCoreWarningEvent;
    OnDebug: TDeDeCoreDebugEvent;
    OnConfirm: TDeDeCoreConfirmEvent;
    property PEFile: ThePEFile read GetPEFile write FPEFile;
    property PEHeader: TPEHeader read GetPEHeader write FPEHeader;
    constructor Create;
    destructor Destroy; override;
    procedure ReportProgress(const APhase, ADetail: string;
      APosition, AMaximum: Integer);
    procedure ReportWarning(const AMessage: string);
    procedure ReportDebug(const AMessage: string);
    function Confirm(const ATitle, AMessage: string): Boolean;
    function LoadDFMText(const AClassName: string): TStringList;
    function ExtractDFM(const AClassName: string): TMemoryStream;
    procedure DumpDFMNames;
    procedure ClearDFMForms;
    procedure AddDFMForm(const AClassName: string;
      AFileOffset: TPE32FileOffset);
    function GetDFMFileOffset(AIndex: Integer): TPE32FileOffset;
    function ClassRefInCode(Offs: DWORD; var AClassName: string): Boolean;
    function GetByte(VirtualAddress: DWORD): Byte;
    function GetWord(VirtualAddress: DWORD): Word;
    function GetDWord(VirtualAddress: DWORD): DWORD;
  end;

procedure LoadPEBinary(const AFileName: string; out APEFile: ThePEFile;
  out APEHeader: TPEHeader; out AIsELF: Boolean);
function GetCoreTickCount: LongWord;
function DeleteCoreFile(const AFileName: string): Boolean;
function RenameCoreFile(const AOldName, ANewName: string): Boolean;
function RemoveCoreDirectory(const ADirectory: string): Boolean;

var
  DeDeCoreContext: TDeDeCoreContext;

implementation

uses
  DeDeELFClasses
{$IFDEF MSWINDOWS}
  , Windows
{$ENDIF}
  ;

function TDeDeCoreContext.GetPEFile: ThePEFile;
begin
  if FPEFile <> nil then
    Result := FPEFile
  else
    Result := DeDeClasses.PEFile;
end;

function TDeDeCoreContext.GetPEHeader: TPEHeader;
begin
  if FPEHeader <> nil then
    Result := FPEHeader
  else
    Result := DeDeClasses.PEHeader;
end;

function GetCoreTickCount: LongWord;
begin
{$IFDEF FPC}
  Result := LongWord(GetTickCount64);
{$ELSE}
  Result := Windows.GetTickCount;
{$ENDIF}
end;

function DeleteCoreFile(const AFileName: string): Boolean;
begin
  Result := SysUtils.DeleteFile(AFileName);
end;

function RenameCoreFile(const AOldName, ANewName: string): Boolean;
begin
  Result := SysUtils.RenameFile(AOldName, ANewName);
end;

function RemoveCoreDirectory(const ADirectory: string): Boolean;
begin
  Result := SysUtils.RemoveDir(ADirectory);
end;

procedure LoadPEBinary(const AFileName: string; out APEFile: ThePEFile;
  out APEHeader: TPEHeader; out AIsELF: Boolean);
var
  LoadedFile: ThePEFile;
  LoadedHeader: TPEHeader;
  Signature: DWORD;
begin
  APEFile := nil;
  APEHeader := nil;
  AIsELF := False;
  if not FileExists(AFileName) then
    raise EFOpenError.CreateFmt('Input binary does not exist: %s',
      [AFileName]);

  LoadedFile := nil;
  LoadedHeader := nil;
  try
    LoadedFile := ThePEFile.Create(AFileName);
    LoadedFile.PEStream.Seek(0, soFromBeginning);
    LoadedFile.PEStream.ReadBuffer(Signature, SizeOf(Signature));
    AIsELF := Signature = ELF_MAGIC;

    LoadedHeader := TPEHeader.Create;
    LoadedHeader.Dump(LoadedFile);
    APEFile := LoadedFile;
    APEHeader := LoadedHeader;
  except
    LoadedHeader.Free;
    LoadedFile.Free;
    APEFile := nil;
    APEHeader := nil;
    raise;
  end;
end;

constructor TDeDeCoreContext.Create;
begin
  inherited Create;
  DFMFormList := TStringList.Create;
  DFMNameList := TStringList.Create;
  PASNameList := TStringList.Create;
  UnitList := TStringList.Create;
  ClassInfoList := TStringList.Create;
  Warnings := TStringList.Create;
end;

destructor TDeDeCoreContext.Destroy;
begin
  ClearDFMForms;
  UnitList.Free;
  Warnings.Free;
  PASNameList.Free;
  DFMNameList.Free;
  ClassInfoList.Free;
  DFMFormList.Free;
  inherited Destroy;
end;

procedure TDeDeCoreContext.ClearDFMForms;
var
  I: Integer;
begin
  for I := 0 to DFMFormList.Count - 1 do
    TPE32FileOffsetBox(DFMFormList.Objects[I]).Free;
  DFMFormList.Clear;
end;

procedure TDeDeCoreContext.AddDFMForm(const AClassName: string;
  AFileOffset: TPE32FileOffset);
var
  OffsetBox: TPE32FileOffsetBox;
begin
  OffsetBox := TPE32FileOffsetBox.Create(AFileOffset);
  try
    DFMFormList.AddObject(AClassName, OffsetBox);
  except
    OffsetBox.Free;
    raise;
  end;
end;

function TDeDeCoreContext.GetDFMFileOffset(
  AIndex: Integer): TPE32FileOffset;
var
  OffsetBox: TPE32FileOffsetBox;
begin
  if (AIndex < 0) or (AIndex >= DFMFormList.Count) then
    raise EArgumentOutOfRangeException.Create('AIndex');
  OffsetBox := TPE32FileOffsetBox(DFMFormList.Objects[AIndex]);
  if OffsetBox = nil then
    raise EInvalidOp.CreateFmt('DFM resource offset is missing at index %d',
      [AIndex]);
  Result := OffsetBox.Value;
end;

procedure TDeDeCoreContext.ReportProgress(const APhase, ADetail: string;
  APosition, AMaximum: Integer);
begin
  if Assigned(OnProgress) then
    OnProgress(APhase, ADetail, APosition, AMaximum);
end;

procedure TDeDeCoreContext.ReportWarning(const AMessage: string);
begin
  Warnings.Add(AMessage);
  if Assigned(OnWarning) then
    OnWarning(AMessage);
end;

procedure TDeDeCoreContext.ReportDebug(const AMessage: string);
begin
  if Assigned(OnDebug) then
    OnDebug(AMessage);
end;

function TDeDeCoreContext.Confirm(const ATitle, AMessage: string): Boolean;
begin
  Result := Assigned(OnConfirm) and OnConfirm(ATitle, AMessage);
end;

function TDeDeCoreContext.LoadDFMText(
  const AClassName: string): TStringList;
var
  Input: TMemoryStream;
  Output: TStringStream;
begin
  Input := ExtractDFM(AClassName);
  Result := TStringList.Create;
  Output := TStringStream.Create('');
  try
    try
      Input.ReadResHeader;
      ObjectBinaryToText(Input, Output);
      Output.Position := 0;
      Result.LoadFromStream(Output);
    except
      Result.Free;
      Result := nil;
      raise;
    end;
  finally
    Output.Free;
    Input.Free;
  end;
end;

function TDeDeCoreContext.ExtractDFM(
  const AClassName: string): TMemoryStream;
var
  Index, I: Integer;
  BeginOffset, EndOffset: DWORD;
  SectionIndex: Integer;
  FormName: string;
  DFMSize: DWORD;
  HeaderBytes: array of Byte;
  ByteValue: Byte;
begin
  if (PEFile = nil) or (PEHeader = nil) then
    raise Exception.Create('No binary is loaded for DFM extraction');
  Index := DFMFormList.IndexOf(AClassName);
  if Index < 0 then
    raise EArgumentException.CreateFmt('DFM class not found: "%s"',
      [AClassName]);

  BeginOffset := DWORD(GetDFMFileOffset(Index));
  if bELF then
    SectionIndex := PEHeader.GetSectionIndexEx('.rsrc')
  else
  begin
    SectionIndex := PEHeader.GetSectionIndex('.rsrc');
    if SectionIndex = 255 then
      SectionIndex := PEHeader.GetSectionIndexByRVA(
        PEHeader.RESOURCE_TABLE_RVA);
  end;
  if (SectionIndex < 1) or (SectionIndex > PEHeader.ObjectNum) then
    raise Exception.Create('Resource section was not found');
  if (PEHeader.Objects[SectionIndex].PHYSICAL_OFFSET >
      DWORD(PEFile.PEStream.Size)) or
    (PEHeader.Objects[SectionIndex].PHYSICAL_SIZE >
      DWORD(PEFile.PEStream.Size) -
        PEHeader.Objects[SectionIndex].PHYSICAL_OFFSET) then
    raise EReadError.Create('Resource section exceeds the input file');
  EndOffset := PEHeader.Objects[SectionIndex].PHYSICAL_OFFSET +
    PEHeader.Objects[SectionIndex].PHYSICAL_SIZE;
  for I := 0 to DFMFormList.Count - 1 do
    if (I <> Index) and (DWORD(GetDFMFileOffset(I)) > BeginOffset) and
      (DWORD(GetDFMFileOffset(I)) < EndOffset) then
      EndOffset := DWORD(GetDFMFileOffset(I));
  if (EndOffset <= BeginOffset) or
    (EndOffset > DWORD(PEFile.PEStream.Size)) then
    raise EReadError.CreateFmt('Invalid DFM resource bounds for "%s"',
      [AClassName]);

  FormName := UpperCase(AClassName);
  if Length(FormName) > 255 then
    raise EConvertError.CreateFmt('DFM class name is too long: "%s"',
      [AClassName]);
  SetLength(HeaderBytes, Length(FormName) + 10);
  FillChar(HeaderBytes[0], Length(HeaderBytes), 0);
  HeaderBytes[0] := $FF;
  HeaderBytes[1] := $0A;
  HeaderBytes[2] := 0;
  for I := 1 to Length(FormName) do
    HeaderBytes[I + 2] := Byte(FormName[I]);
  HeaderBytes[Length(FormName) + 3] := 0;
  HeaderBytes[Length(FormName) + 4] := $30;
  HeaderBytes[Length(FormName) + 5] := $10;
  DFMSize := EndOffset - BeginOffset - 1;
  HeaderBytes[Length(FormName) + 6] := Byte(DFMSize);
  HeaderBytes[Length(FormName) + 7] := Byte(DFMSize shr 8);

  Result := TMemoryStream.Create;
  try
    Result.WriteBuffer(HeaderBytes[0], Length(HeaderBytes));
    PEFile.PEStream.Seek(BeginOffset, soFromBeginning);
    while PEFile.PEStream.Position < EndOffset do
    begin
      if PEFile.PEStream.Read(ByteValue, SizeOf(ByteValue)) <> 1 then
        raise EReadError.CreateFmt('Truncated DFM resource "%s"',
          [AClassName]);
      Result.WriteBuffer(ByteValue, SizeOf(ByteValue));
    end;
    ByteValue := 0;
    Result.WriteBuffer(ByteValue, SizeOf(ByteValue));
    Result.WriteBuffer(ByteValue, SizeOf(ByteValue));
    Result.Position := 0;
  except
    Result.Free;
    raise;
  end;
end;

procedure TDeDeCoreContext.DumpDFMNames;
var
  StartOffset, EndOffset: DWORD;
  SectionIndex: Integer;
  Magic: array[0..3] of Byte;
  Buffer: array[0..3] of Byte;
  NameLength: Byte;
  I: Integer;
  DFMOffset: DWORD;
  ClassName: string;
begin
  if (PEFile = nil) or (PEHeader = nil) then
    raise Exception.Create('No binary is loaded for DFM discovery');

  ClearDFMForms;
  Magic[0] := $54;
  Magic[1] := $50;
  Magic[2] := $46;
  Magic[3] := $30;

  if bELF then
    SectionIndex := PEHeader.GetSectionIndexEx('.rsrc')
  else
  begin
    SectionIndex := PEHeader.GetSectionIndex('.rsrc');
    if SectionIndex = 255 then
      SectionIndex := PEHeader.GetSectionIndexByRVA(
        PEHeader.RESOURCE_TABLE_RVA);
  end;
  if (SectionIndex < 1) or (SectionIndex > PEHeader.ObjectNum) then
    raise Exception.Create('Resource section was not found');

  StartOffset := PEHeader.Objects[SectionIndex].PHYSICAL_OFFSET;
  if (StartOffset > DWORD(PEFile.PEStream.Size)) or
    (PEHeader.Objects[SectionIndex].PHYSICAL_SIZE >
      DWORD(PEFile.PEStream.Size) - StartOffset) then
    raise EReadError.Create('Resource section exceeds the input file');
  EndOffset := StartOffset + PEHeader.Objects[SectionIndex].PHYSICAL_SIZE;
  if EndOffset - StartOffset < SizeOf(Buffer) then
    Exit;
  PEFile.PEStream.Seek(StartOffset, soFromBeginning);
  while PEFile.PEStream.Position < EndOffset - SizeOf(Buffer) do
  begin
    Inc(StartOffset);
    PEFile.PEStream.Seek(StartOffset, soFromBeginning);
    if PEFile.PEStream.Read(Buffer[0], SizeOf(Buffer)) <> SizeOf(Buffer) then
      Break;
    if (StartOffset mod 1000) = 0 then
      ReportProgress('', '', 0, 0);
    if not CompareMem(@Buffer[0], @Magic[0], SizeOf(Buffer)) then
      Continue;

    DFMOffset := DWORD(PEFile.PEStream.Position - SizeOf(Buffer));
    if PEFile.PEStream.Read(NameLength, SizeOf(NameLength)) <> SizeOf(NameLength) then
      Break;
    if NameLength = $F1 then
      if PEFile.PEStream.Read(NameLength, SizeOf(NameLength)) <> SizeOf(NameLength) then
        Break;
    SetLength(ClassName, NameLength);
    for I := 1 to NameLength do
    begin
      if PEFile.PEStream.Read(Buffer[0], 1) <> 1 then
      begin
        SetLength(ClassName, I - 1);
        Break;
      end;
      ClassName[I] := Char(Buffer[0]);
    end;
    if Length(ClassName) = NameLength then
        AddDFMForm(ClassName, TPE32FileOffset(DFMOffset));
  end;
end;

function TDeDeCoreContext.ClassRefInCode(Offs: DWORD;
  var AClassName: string): Boolean;
var
  SectionIndex: Integer;
  BeginOffset, EndOffset: DWORD;
  LengthByte: Byte;
  ByteValue: Byte;
  CurrentChar: Char;
  InString: Boolean;
begin
  Result := False;
  AClassName := '';
  if (PEFile = nil) or (PEHeader = nil) then
    Exit;

  if bELF then
    SectionIndex := PEHeader.GetSectionIndexEx('.text')
  else
    SectionIndex := 1;
  if (SectionIndex < 1) or (SectionIndex > PEHeader.ObjectNum) then
    Exit;

  BeginOffset := Offs - PEHeader.IMAGE_BASE -
    PEHeader.Objects[SectionIndex].RVA +
    PEHeader.Objects[SectionIndex].PHYSICAL_OFFSET;
  EndOffset := BeginOffset + iCLASS_REF_IN_CODE_SEEK_LENGTH;
  InString := False;
  LengthByte := 0;
  PEFile.PEStream.BeginSearch;
  try
    PEFile.PEStream.Seek(BeginOffset, soFromBeginning);
    while (PEFile.PEStream.Position < EndOffset) and
      (PEFile.PEStream.Position < PEFile.PEStream.Size) do
    begin
      PEFile.PEStream.ReadBuffer(ByteValue, SizeOf(ByteValue));
      CurrentChar := Char(ByteValue);
      if InString then
      begin
        if CharInSet(CurrentChar, ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
          AClassName := AClassName + CurrentChar
        else
        begin
          InString := False;
          if (LengthByte = Length(AClassName)) and (LengthByte > 2) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;

      if not InString and (Ord(CurrentChar) < $20) and
        (CurrentChar <> #0) then
      begin
        InString := True;
        LengthByte := Ord(CurrentChar);
        AClassName := '';
      end;
    end;
  finally
    PEFile.PEStream.EndSearch;
  end;
end;

function TDeDeCoreContext.GetByte(VirtualAddress: DWORD): Byte;
begin
  if (PEFile = nil) or (PEHeader = nil) then
    raise Exception.Create('No binary is loaded');
  PEFile.PEStream.BeginSearch;
  try
    PEFile.PEStream.Seek(VirtualAddress - PEHeader.IMAGE_BASE -
      PEHeader.Objects[1].RVA + PEHeader.Objects[1].PHYSICAL_OFFSET,
      soFromBeginning);
    PEFile.PEStream.ReadBuffer(Result, SizeOf(Result));
  finally
    PEFile.PEStream.EndSearch;
  end;
end;

function TDeDeCoreContext.GetWord(VirtualAddress: DWORD): Word;
begin
  if (PEFile = nil) or (PEHeader = nil) then
    raise Exception.Create('No binary is loaded');
  PEFile.PEStream.BeginSearch;
  try
    PEFile.PEStream.Seek(VirtualAddress - PEHeader.IMAGE_BASE -
      PEHeader.Objects[1].RVA + PEHeader.Objects[1].PHYSICAL_OFFSET,
      soFromBeginning);
    PEFile.PEStream.ReadBuffer(Result, SizeOf(Result));
  finally
    PEFile.PEStream.EndSearch;
  end;
end;

function TDeDeCoreContext.GetDWord(VirtualAddress: DWORD): DWORD;
begin
  if (PEFile = nil) or (PEHeader = nil) then
    raise Exception.Create('No binary is loaded');
  PEFile.PEStream.BeginSearch;
  try
    PEFile.PEStream.Seek(VirtualAddress - PEHeader.IMAGE_BASE -
      PEHeader.Objects[1].RVA + PEHeader.Objects[1].PHYSICAL_OFFSET,
      soFromBeginning);
    PEFile.PEStream.ReadBuffer(Result, SizeOf(Result));
  finally
    PEFile.PEStream.EndSearch;
  end;
end;

initialization
  DeDeCoreContext := TDeDeCoreContext.Create;

finalization
  DeDeCoreContext.Free;

end.
