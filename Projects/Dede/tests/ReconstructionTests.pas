unit ReconstructionTests;

interface

uses
  Classes, TestFramework, DeDeConstants;

type
  TReconstructionTests = class(TTestCase)
  published
    procedure TestParserWarningBoundaries;
    procedure TestDCUEndMarkerBoundaries;
    procedure TestDelphiVersionMarkers;
    procedure TestProjectUsesWrapping;
    procedure TestDPJCommentSerialization;
    procedure TestMainUnitCallbackFailure;
    procedure TestEditPropValidation;
    procedure TestEditPropListTables;
    procedure TestFileDropDispatch;
    procedure TestDFMTextParserCollections;
    procedure TestAllIDRTextDFMs;
    procedure TestPEHeaderOfTestExecutable;
    procedure TestEmulatorInvalidInputs;
    procedure TestSymbolReferenceOffsetBounds;
    procedure TestSHA1KnownVectors;
    procedure TestBSSAddressRangeAboveSignedLimit;
    procedure TestExpressionHighRVA;
    procedure TestProcessPointerOffsetAboveSignedLimit;
    procedure TestMemLocEnumeratesCurrentProcess;
    procedure TestCoreProgressHost;
    procedure TestCoreSessionProgressBeforeAnalyze;
    procedure TestCoreAttachedAnalysisIsBorrowed;
    procedure TestCoreSessionsUseSeparateContexts;
    procedure TestCoreFailedAnalysisRestoresHostContext;
    procedure TestCoreReportExportAndOverwriteGuard;
    procedure TestCoreExportCaseInsensitiveUnitCollision;
    procedure TestX86CrossReferenceCollection;
    procedure TestDSFSymbolMatching;
    procedure TestXRefDSFSymbolResolution;
    procedure TestCoreVersionConfiguration;
    procedure TestVMTMethodOffsetMapping;
    procedure TestZipFormatConsumers;
  end;

implementation

uses
  SysUtils, DeDePFiles, DeDeDCUDumper, DeDeMemDumps, DeDePProject,
  DeDeEditText, DeDeDPJEng, DeDeAnsiStream, Forms, Windows, Messages,
  Controls, ShellAPI, DeDeDFMModel, DeDeDFMTextParser, EditPropUnit, FileDrop,
  MainUnit, DeDeClasses, Emulator, DeDeClassEmulator, DeDeDisAsm,
  DeDeZAUnit, DeDeBSS, DeDeExpressions, MemLocUnit, DeDeCoreServices,
  DeDeCore, DeDeClassHandle, DeDeBPL, DeDeDUF, DeDeOffsInf,
  DeDeBinaryTypes, DeDeXRef, DeDeSym, DeDeZip;

type
  TParserCallbackRecorder = class
  public
    CallCount: Integer;
    LastBuffer: TSymBuffer;
    LastAdd: Boolean;
    procedure OnNewProcedure(ProcDecl: string; Buffer: TSymBuffer;
      Size: Integer; Progress: Byte; Add: Boolean);
  end;

  TDropRecorder = class
  public
    Calls: Integer;
    Files: TStringList;
    procedure HandleDrop(Sender: TObject);
  end;

  TTestBSS = class(TBSS)
  public
    procedure AddDataValue(Value: DWORD);
  end;

  TCoreProgressRecorder = class
  public
    Calls: Integer;
    Phase: string;
    Detail: string;
    Position: Integer;
    Maximum: Integer;
    FailOnDetail: string;
    procedure OnProgress(const APhase, ADetail: string;
      APosition, AMaximum: Integer);
  end;

procedure TTestBSS.AddDataValue(Value: DWORD);
begin
  Data.Add(Value);
end;

procedure TCoreProgressRecorder.OnProgress(const APhase, ADetail: string;
  APosition, AMaximum: Integer);
begin
  Inc(Calls);
  Phase := APhase;
  Detail := ADetail;
  Position := APosition;
  Maximum := AMaximum;
  if (FailOnDetail <> '') and SameText(ADetail, FailOnDetail) then
    raise EAbort.Create('Injected export progress failure');
end;

procedure TDropRecorder.HandleDrop(Sender: TObject);
begin
  Inc(Calls);
  Files.Assign(TFileDrop(Sender).Files);
end;

function MakeDropHandle(const Paths: array of string): HDROP;
type
  TDropFilesHeader = packed record
    pFiles: DWORD;
    pt: TPoint;
    fNC: BOOL;
    fWide: BOOL;
  end;
var
  Header: TDropFilesHeader;
  MultiString: string;
  Data: array of Byte;
  I, DataSize: Integer;
  Buffer: Pointer;
begin
  MultiString := '';
  for I := Low(Paths) to High(Paths) do
    MultiString := MultiString + Paths[I] + #0;
  MultiString := MultiString + #0;

  FillChar(Header, SizeOf(Header), 0);
  Header.pFiles := SizeOf(Header);
  Header.fWide := True;
  DataSize := SizeOf(Header) + Length(MultiString) * SizeOf(Char);
  SetLength(Data, DataSize);
  Move(Header, Data[0], SizeOf(Header));
  Move(MultiString[1], Data[SizeOf(Header)],
    Length(MultiString) * SizeOf(Char));

  Result := HDROP(GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, DataSize));
  if Result = 0 then
    RaiseLastOSError;
  Buffer := GlobalLock(Result);
  if Buffer = nil then
  begin
    GlobalFree(Result);
    RaiseLastOSError;
  end;
  Move(Data[0], Buffer^, DataSize);
  GlobalUnlock(Result);
end;

function FindChild(AObject: TDFMObject; const AName: string): TDFMObject;
var
  I: Integer;
  Child: TDFMObject;
begin
  Result := nil;
  for I := 0 to AObject.Children.Count - 1 do
  begin
    Child := TDFMObject(AObject.Children[I]);
    if SameText(Child.ObjectName, AName) then
      Exit(Child);
    Result := FindChild(Child, AName);
    if Result <> nil then
      Exit;
  end;
end;

function FindProperty(AObject: TDFMObject;
  const AName: string): TDFMProperty;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to AObject.Properties.Count - 1 do
    if SameText(TDFMProperty(AObject.Properties[I]).Name, AName) then
      Exit(TDFMProperty(AObject.Properties[I]));
end;

procedure TParserCallbackRecorder.OnNewProcedure(ProcDecl: string;
  Buffer: TSymBuffer; Size: Integer; Progress: Byte; Add: Boolean);
begin
  Inc(CallCount);
  LastBuffer := Buffer;
  LastAdd := Add;
end;

procedure TReconstructionTests.TestParserWarningBoundaries;
var
  ParserSmoke: TParserCallbackRecorder;
  Lines: TStringList;
  Parser: TNewDCU2DSFParser;
  ClassParser: TClassParser;
  Defs: array[0..2] of TStringList;
  ClassText, ClassName: string;
  I, J: Integer;
begin
  ParserSmoke := TParserCallbackRecorder.Create;
  Lines := TStringList.Create;
  for I := Low(Defs) to High(Defs) do
    Defs[I] := TStringList.Create;
  try
    Lines.Add('procedure Malformed;');
    Lines.Add('end;');
    Parser.InitParse(Lines, ParserSmoke.OnNewProcedure);
    Parser.ParseIt;
    CheckEquals(0, ParserSmoke.CallCount,
      'A procedure end without a begin was emitted');

    Lines.Clear;
    Lines.Add('procedure EmptyPattern;');
    Lines.Add('begin');
    Lines.Add('end;');
    Parser.InitParse(Lines, ParserSmoke.OnNewProcedure);
    Parser.ParseIt;
    CheckEquals(1, ParserSmoke.CallCount,
      'A valid empty procedure pattern was not emitted');
    CheckFalse(ParserSmoke.LastAdd,
      'An empty procedure pattern was marked for insertion');
    for I := Low(ParserSmoke.LastBuffer) to High(ParserSmoke.LastBuffer) do
      CheckEquals(0, ParserSmoke.LastBuffer[I],
        'An empty procedure pattern contains uninitialized bytes');

    Lines.Clear;
    Lines.Add('procedure FullPattern;');
    Lines.Add('begin');
    for I := 0 to (_PatternSize div 10) - 1 do
    begin
      ClassText := StringOfChar('X', 40);
      for J := 0 to 9 do
      begin
        ClassText[12 + J * 3] := '0';
        ClassText[13 + J * 3] := '1';
      end;
      Lines.Add(ClassText);
    end;
    Lines.Add('end;');
    Parser.InitParse(Lines, ParserSmoke.OnNewProcedure);
    Parser.ParseIt;
    CheckEquals(2, ParserSmoke.CallCount,
      'A full-size procedure pattern was not emitted');
    CheckTrue(ParserSmoke.LastAdd,
      'A full-size procedure pattern was not marked for insertion');
    for I := Low(ParserSmoke.LastBuffer) to High(ParserSmoke.LastBuffer) do
      CheckEquals(1, ParserSmoke.LastBuffer[I],
        'A full-size procedure pattern was changed');

    ClassText := 'TParserSmokeClass = class(TObject)' + sLineBreak + 'end;';
    CheckTrue(ClassParser.ParseClass(ClassText, Defs, ClassName),
      'A valid class declaration reported failure');
    CheckEquals('TParserSmokeClass', ClassName,
      'The parsed class name changed');

    ClassText := 'not a declaration';
    CheckFalse(ClassParser.ParseClass(ClassText, Defs, ClassName),
      'An invalid class declaration reported success');
  finally
    for I := Low(Defs) to High(Defs) do
      Defs[I].Free;
    Lines.Free;
    ParserSmoke.Free;
  end;
end;

procedure TReconstructionTests.TestDCUEndMarkerBoundaries;
var
  Lines: TStringList;
begin
  Lines := TStringList.Create;
  try
    Lines.Add('begin');
    Lines.Add('end;');
    Lines.Add('end;');
    FixDCUEndMarkers(Lines);
    CheckEquals(2, Lines.Count,
      'Adjacent duplicate end markers were not collapsed');
    CheckEquals('begin', Lines[0],
      'The begin/end pair changed while removing a duplicate');
    CheckEquals('end;', Lines[1],
      'The begin/end pair changed while removing a duplicate');

    Lines.Clear;
    Lines.Add('end;');
    Lines.Add('begin');
    Lines.Add('end;');
    FixDCUEndMarkers(Lines);
    CheckEquals(3, Lines.Count,
      'A leading end marker changed the boundary case');
    CheckEquals('end;', Lines[0],
      'The leading end marker was unexpectedly rewritten');
    CheckEquals('begin', Lines[1],
      'The boundary case changed the begin line');
    CheckEquals('end;', Lines[2],
      'The boundary case changed the closing end marker');

    Lines.Clear;
    FixDCUEndMarkers(Lines);
    CheckEquals(0, Lines.Count, 'An empty DCU output list changed');
  finally
    Lines.Free;
  end;
end;

procedure TReconstructionTests.TestDelphiVersionMarkers;
var
  Stream: TMemoryStream;
begin
  CheckEquals(2, MapDelphiVersionMarker($FFF0), 'Delphi 2 marker');
  CheckEquals(3, MapDelphiVersionMarker(0), 'Delphi 3 marker');
  CheckEquals(4, MapDelphiVersionMarker($114), 'Delphi 4 marker');
  CheckEquals(5, MapDelphiVersionMarker($120), 'Delphi 5 marker');
  CheckEquals(6, MapDelphiVersionMarker($15C), 'Delphi 6 marker');
  CheckEquals(6, MapDelphiVersionMarker($160), 'Alternate Delphi 6 marker');
  CheckEquals(0, MapDelphiVersionMarker($FFFF), 'Unknown version marker');
  CheckEquals($FFFF, MemGetDelphiVersionOfAProcess(0),
    'A process-open failure did not return the unknown-version marker');

  Stream := TMemoryStream.Create;
  try
    CheckEquals(0, GetRVAEntryPoint(Stream, $400000, 0, 0, 0, False),
      'Unknown compiler version returned an entry point');
  finally
    Stream.Free;
  end;
end;

procedure TReconstructionTests.TestProjectUsesWrapping;
var
  PascalFile, DFMFile: string;
begin
  PascalFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    'uses-wrap-dunit-fixture.pas';
  DFMFile := ChangeFileExt(PascalFile, '.dfm');
  InitNewProject;
  USES_LIST := 'A,B,C,D,E,F';
  try
    EndProject(PascalFile);
    CheckEquals('A,B,C,D,E,' + #13#10 + 'F', USES_LIST,
      'Uses-list line wrapping did not start after the fifth comma');
  finally
    if FileExists(PascalFile) then
      SysUtils.DeleteFile(PascalFile);
    if FileExists(DFMFile) then
      SysUtils.DeleteFile(DFMFile);
  end;
end;

procedure TReconstructionTests.TestDPJCommentSerialization;
var
  SourceComments, LoadedComments: TCommentArray;
  SourceCount, LoadedCount: Integer;
  StringValue: string;
  AnsiBuffer: TAnsiByteBuffer;
  InvalidCount: Integer;
  InvalidCountRejected: Boolean;
  Stream: TMemoryStream;
begin
  SetLength(SourceComments, 2);
  SourceComments[0].cmtRVA := $12345678;
  SourceComments[0].Comment := 'first comment';
  SourceComments[1].cmtRVA := $ABCDEF01;
  SourceComments[1].Comment := 'second comment';
  SourceCount := Length(SourceComments);
  Stream := TMemoryStream.Create;
  try
    WriteDPJRawString(Stream, 'DPJ!1.003.50');
    CheckEquals(12, Stream.Size,
      'DPJ header was not written as ANSI bytes');
    Stream.Position := 0;
    CheckEquals('DPJ!1.003.50', ReadDPJRawString(Stream, 12),
      'DPJ header ANSI bytes did not roundtrip');

    Stream.Clear;
    WriteDPJStringValue(Stream, 'Legacy');
    CheckEquals(SizeOf(Integer) + Length(AnsiString('Legacy')), Stream.Size,
      'DPJ string length is not measured in ANSI bytes');
    Stream.Position := 0;
    StringValue := ReadDPJStringValue(Stream);
    CheckEquals('Legacy', StringValue,
      'Length-prefixed DPJ string changed');

    SetLength(AnsiBuffer, 0);
    AppendLengthPrefixedAnsiString(AnsiBuffer, 'ClassName');
    CheckEquals(SizeOf(Integer) + AnsiByteLength('ClassName'),
      Length(AnsiBuffer), 'DPJ class-buffer string has an incorrect byte length');
    Stream.Clear;
    Stream.WriteBuffer(AnsiBuffer[0], Length(AnsiBuffer));
    Stream.Position := 0;
    CheckEquals('ClassName', ReadDPJStringValue(Stream),
      'DPJ class-buffer string did not roundtrip');

    Stream.Clear;
    WriteAnsiBytes(Stream, 'LegacyTail', 6);
    CheckEquals(6, Stream.Size, 'ANSI byte-prefix length changed');
    Stream.Position := 0;
    CheckEquals('Legacy', ReadAnsiString(Stream, 6),
      'ANSI byte-prefix content changed');

    Stream.Clear;
    WriteDPJCommentRecords(Stream, SourceComments, SourceCount);
    CheckEquals(SizeOf(SourceCount) + 2 * DPJCommentRecordBytes, Stream.Size,
      'DPJ comments do not use the reference record width');
    Stream.Position := 0;
    ReadDPJCommentRecords(Stream, LoadedComments, LoadedCount);
    CheckEquals(SourceCount, LoadedCount, 'Comment count changed on roundtrip');
    CheckEquals(SourceComments[0].cmtRVA, LoadedComments[0].cmtRVA,
      'First comment RVA changed on roundtrip');
    CheckEquals(SourceComments[0].Comment, LoadedComments[0].Comment,
      'First comment text changed on roundtrip');
    CheckEquals(SourceComments[1].cmtRVA, LoadedComments[1].cmtRVA,
      'Second comment RVA changed on roundtrip');
    CheckEquals(SourceComments[1].Comment, LoadedComments[1].Comment,
      'Second comment text changed on roundtrip');

    Stream.Clear;
    InvalidCount := High(Integer);
    Stream.WriteBuffer(InvalidCount, SizeOf(InvalidCount));
    Stream.Position := 0;
    InvalidCountRejected := False;
    try
      ReadDPJCommentRecords(Stream, LoadedComments, LoadedCount);
    except
      on E: EReadError do
        InvalidCountRejected := True;
    end;
    CheckTrue(InvalidCountRejected,
      'Oversized comment count was not rejected before allocation');
  finally
    Stream.Free;
  end;
end;

procedure TReconstructionTests.TestMainUnitCallbackFailure;
var
  Reference: string;
  ReferenceType: Byte;
begin
  Reference := 'unchanged';
  ReferenceType := $A5;
  CheckFalse(GetCallReference(0, Reference, ReferenceType),
    'A zero call offset reported a reference');
  CheckEquals('unchanged', Reference,
    'A zero call offset changed the reference output');
  CheckEquals($A5, ReferenceType,
    'A zero call offset changed the reference type');
end;

procedure TReconstructionTests.TestEditPropValidation;
var
  Form: TEditPropForm;
  PropertyItem: TDFMProperty;
begin
  Form := TEditPropForm.Create(nil);
  PropertyItem := TDFMProperty.Create;
  try
    Form.CurrentProperty := PropertyItem;

    PropertyItem.ValueType := 8;
    PropertyItem.Value := 'true';
    Form.ValueMemo.Lines.Text := 'true';
    CheckTrue(Form.ValidateAndStore, 'Boolean true was rejected');
    CheckEquals(9, PropertyItem.ValueType,
      'Boolean true did not update the target type code');
    CheckEquals('true', PropertyItem.Value, 'Boolean text was not preserved');

    PropertyItem.ValueType := 9;
    PropertyItem.Value := 'false';
    Form.ValueMemo.Lines.Text := 'false';
    CheckTrue(Form.ValidateAndStore, 'Boolean false was rejected');
    CheckEquals(8, PropertyItem.ValueType,
      'Boolean false did not update the target type code');

    PropertyItem.ValueType := 8;
    PropertyItem.Value := 'unchanged';
    Form.ValueMemo.Lines.Text := 'True';
    CheckFalse(Form.ValidateAndStore, 'Uppercase Boolean text was accepted');
    CheckEquals('unchanged', PropertyItem.Value,
      'Rejected Boolean text changed the property');

    PropertyItem.ValueType := 14;
    PropertyItem.Value := '(Name=02,Value)';
    Form.ValueMemo.Lines.Text := PropertyItem.Value;
    CheckFalse(Form.ValidateAndStore,
      'Unsupported NameValueList save was accepted');
    CheckEquals('(Name=02,Value)', PropertyItem.Value,
      'Rejected NameValueList save changed the property');

    PropertyItem.ValueType := 11;
    PropertyItem.Value := '[First,$Second_2]';
    Form.EditProperty(PropertyItem);
    CheckTrue(Form.ValidateAndStore, 'Valid set items were rejected');
    CheckEquals('[First,$Second_2]', PropertyItem.Value,
      'Valid set items were not serialized');

    PropertyItem.ValueType := 11;
    PropertyItem.Value := '[First,bad-name]';
    Form.EditProperty(PropertyItem);
    CheckFalse(Form.ValidateAndStore, 'Invalid set item was accepted');
    CheckEquals('[First,bad-name]', PropertyItem.Value,
      'Rejected set items changed the property');

    PropertyItem.ValueType := 13;
    Form.ValueMemo.Lines.Text := 'raw';
    CheckFalse(Form.ValidateAndStore, 'Unknown property type was accepted');
  finally
    PropertyItem.Free;
    Form.Free;
  end;
end;

procedure TReconstructionTests.TestEditPropListTables;
var
  Form: TEditPropForm;
  PropertyItem: TDFMProperty;
  EscapesRejected: Boolean;
begin
  Form := TEditPropForm.Create(nil);
  PropertyItem := TDFMProperty.Create;
  try
    PropertyItem.ValueType := 1;
    PropertyItem.Value := '(02,First;04,Second)';
    Form.EditProperty(PropertyItem);
    Form.RxMemoryData.First;
    CheckEquals('Byte', Form.RxMemoryData.FieldByName('sType').AsString,
      'ValueList type label is incorrect');
    CheckEquals('First', Form.RxMemoryData.FieldByName('Value').AsString,
      'ValueList value is incorrect');
    Form.RxMemoryData.Next;
    CheckEquals('Second', Form.RxMemoryData.FieldByName('Value').AsString,
      'Second ValueList value is incorrect');
    CheckEquals('(02,First;04,Second)', PropertyItem.Value,
      'Displaying a ValueList changed the source property');

    PropertyItem.ValueType := 14;
    PropertyItem.Value :=
      '(Name#20One=02,Value#20One|Name#20Two=04,Value#20Two)';
    Form.EditProperty(PropertyItem);
    Form.RxMemoryData.First;
    CheckEquals('Name One', Form.RxMemoryData.FieldByName('Name').AsString,
      'Name/value name escape was not decoded');
    CheckEquals(0, Form.RxMemoryData.FieldByName('Subitem').AsInteger,
      'First name/value group index is incorrect');
    Form.RxMemoryData.Next;
    CheckEquals('Name Two', Form.RxMemoryData.FieldByName('Name').AsString,
      'Second name/value name escape was not decoded');
    CheckEquals(1, Form.RxMemoryData.FieldByName('Subitem').AsInteger,
      'Second name/value group index is incorrect');
    CheckEquals('(Name#20One=02,Value#20One|Name#20Two=04,Value#20Two)',
      PropertyItem.Value,
      'Displaying a NameValueList changed the source property');

    PropertyItem.ValueType := 1;
    PropertyItem.Value := '(02,Invalid#G0)';
    EscapesRejected := False;
    try
      Form.EditProperty(PropertyItem);
    except
      on E: EConvertError do
        EscapesRejected := True;
    end;
    CheckTrue(EscapesRejected,
      'Malformed DFM escape was silently accepted');
  finally
    PropertyItem.Free;
    Form.Free;
  end;
end;

procedure TReconstructionTests.TestFileDropDispatch;
var
  Form: TForm;
  Drop: TFileDrop;
  Recorder: TDropRecorder;
  OriginalWindowProc: TWndMethod;
  DropHandle: HDROP;
begin
  Form := TForm.Create(nil);
  Recorder := TDropRecorder.Create;
  Recorder.Files := TStringList.Create;
  Drop := TFileDrop.Create(Form);
  DropHandle := 0;
  try
    OriginalWindowProc := Form.WindowProc;
    Drop.OnDrop := Recorder.HandleDrop;
    Drop.SetDropControl(Form);
    Drop.SetEnableDrop(True);
    DropHandle := MakeDropHandle(['C:\first.exe', 'D:\zweite.exe']);
    SendMessage(Form.Handle, WM_DROPFILES, WPARAM(DropHandle), 0);
    DropHandle := 0;

    CheckEquals(1, Recorder.Calls, 'Drop event was not dispatched once');
    CheckEquals(2, Drop.FileCount, 'Drop file count was not preserved');
    CheckEquals(2, Recorder.Files.Count, 'Dropped paths were not collected');
    CheckEquals('C:\first.exe', Recorder.Files[0],
      'First dropped path changed');
    CheckEquals('D:\zweite.exe', Recorder.Files[1],
      'Second dropped path changed');

    Drop.SetDropControl(nil);
    CheckTrue(TMethod(Form.WindowProc).Code =
      TMethod(OriginalWindowProc).Code,
      'Original form WindowProc code was not restored');
    CheckTrue(TMethod(Form.WindowProc).Data =
      TMethod(OriginalWindowProc).Data,
      'Original form WindowProc context was not restored');
  finally
    if DropHandle <> 0 then
      GlobalFree(DropHandle);
    Drop.Free;
    Recorder.Files.Free;
    Recorder.Free;
    Form.Free;
  end;
end;

procedure TReconstructionTests.TestDFMTextParserCollections;
var
  Lines: TStringList;
  Root, ColumnsNode, ItemNode: TDFMObject;
  PropertyItem: TDFMProperty;
begin
  Lines := TStringList.Create;
  try
    Lines.Text :=
      'object Root: TForm' + sLineBreak +
      '  EmptyItems = <>' + sLineBreak +
      '  Lines.Strings = (' + sLineBreak +
      '    ''first''' + sLineBreak +
      '    ''value with ) and (''' + sLineBreak +
      '    ''last'')' + sLineBreak +
      '  Picture.Data = {' + sLineBreak +
      '    0102' + sLineBreak +
      '    03}' + sLineBreak +
      '  Columns = <' + sLineBreak +
      '    item' + sLineBreak +
      '      FieldName = ''Outer''' + sLineBreak +
      '      Nested = <' + sLineBreak +
      '        item' + sLineBreak +
      '          Value = 1' + sLineBreak +
      '        end>' + sLineBreak +
      '    end' + sLineBreak +
      '  >' + sLineBreak +
      'end';
    Root := ParseDFMText(Lines);
    try
      ColumnsNode := FindChild(Root, 'Columns');
      CheckTrue((ColumnsNode <> nil) and
        (ColumnsNode.ClassName = 'TDFMCollection') and
        (ColumnsNode.Children.Count = 1),
        'Nested collection structure was not parsed');
      ItemNode := TDFMObject(ColumnsNode.Children[0]);
      ColumnsNode := FindChild(ItemNode, 'Nested');
      CheckTrue((ColumnsNode <> nil) and
        (ColumnsNode.ClassName = 'TDFMCollection') and
        (ColumnsNode.Children.Count = 1),
        'Nested collection item was not parsed');
      ItemNode := TDFMObject(ColumnsNode.Children[0]);
      PropertyItem := FindProperty(ItemNode, 'Value');
      CheckTrue(PropertyItem <> nil, 'Nested collection value was lost');
      CheckEquals('1', PropertyItem.Value,
        'Nested collection value changed');

      ColumnsNode := FindChild(Root, 'EmptyItems');
      CheckTrue((ColumnsNode <> nil) and
        (ColumnsNode.ClassName = 'TDFMCollection') and
        (ColumnsNode.Children.Count = 0),
        'Empty collection was not parsed');

      PropertyItem := FindProperty(Root, 'Lines.Strings');
      CheckTrue(PropertyItem <> nil,
        'Multiline string-list property was lost');
      CheckEquals(1, PropertyItem.ValueType,
        'Multiline string-list property type changed');
      CheckTrue(Pos('value with ) and (', PropertyItem.Value) <> 0,
        'Multiline string list was not preserved');

      PropertyItem := FindProperty(Root, 'Picture.Data');
      CheckTrue(PropertyItem <> nil, 'Multiline binary property was lost');
      CheckEquals(10, PropertyItem.ValueType,
        'Multiline binary property type changed');
      CheckTrue(Pos('03}', PropertyItem.Value) <> 0,
        'Multiline binary data was not preserved');
    finally
      Root.Free;
    end;
  finally
    Lines.Free;
  end;
end;

procedure TReconstructionTests.TestAllIDRTextDFMs;
var
  DFMDirectory, DFMPath: string;
  Search: TSearchRec;
  Lines: TStringList;
  Root, Child, GridNode, ColumnsNode, ItemNode: TDFMObject;
  PropertyItem: TDFMProperty;
  DFMCount: Integer;
  FoundCaption, FoundFieldName: Boolean;
  I, SearchResult: Integer;
begin
  DFMDirectory := ExpandFileName(IncludeTrailingPathDelimiter(
    ExtractFilePath(ParamStr(0)) + '..\..\..\Decomp\IDR'));
  Lines := TStringList.Create;
  DFMCount := 0;
  try
    SearchResult := SysUtils.FindFirst(IncludeTrailingPathDelimiter(DFMDirectory) +
      '*.dfm', faAnyFile, Search);
    if SearchResult <> 0 then
    begin
      Check(False, 'Could not enumerate IDR text DFMs');
      Exit;
    end;
    try
      repeat
        if (Search.Attr and faDirectory) = 0 then
        begin
          Inc(DFMCount);
          DFMPath := IncludeTrailingPathDelimiter(DFMDirectory) + Search.Name;
          Lines.LoadFromFile(DFMPath);
          Root := ParseDFMText(Lines);
          try
            if Root = nil then
            begin
              Check(False, 'DFM root was not parsed: ' + Search.Name);
              Exit;
            end;
            CheckTrue((Root.ObjectName <> '') and (Root.ClassName <> ''),
              'DFM root name or class was empty: ' + Search.Name);

            if SameText(Root.ObjectName, 'TreeViewForm') then
            begin
              CheckEquals('TTreeViewForm', Root.ClassName,
                'TreeView DFM root class changed');
              CheckTrue(Root.Children.Count > 0,
                'TreeView DFM children were not parsed');
              Child := FindChild(Root, 'ControlsTV');
              CheckTrue((Child <> nil) and (Child.ClassName = 'TTreeView'),
                'Nested tree control was not parsed');

              FoundCaption := False;
              for I := 0 to Root.Properties.Count - 1 do
                if TDFMProperty(Root.Properties[I]).Name = 'Caption' then
                begin
                  FoundCaption :=
                    TDFMProperty(Root.Properties[I]).Value = '''DFM Inspector''';
                  Break;
                end;
              CheckTrue(FoundCaption, 'TreeView root caption was not parsed');
            end;

            if SameText(Search.Name, 'EditPropForm.dfm') then
            begin
              GridNode := FindChild(Root, 'DBGrid1');
              CheckTrue(GridNode <> nil, 'EditProp grid was not parsed');
              if GridNode <> nil then
              begin
                ColumnsNode := FindChild(GridNode, 'Columns');
                CheckTrue((ColumnsNode <> nil) and
                  (ColumnsNode.ClassName = 'TDFMCollection') and
                  (ColumnsNode.Children.Count > 0),
                  'DBGrid column collection was not parsed');
                if (ColumnsNode <> nil) and
                   (ColumnsNode.Children.Count > 0) then
                begin
                  ItemNode := TDFMObject(ColumnsNode.Children[0]);
                  CheckEquals('TDFMCollectionItem', ItemNode.ClassName,
                    'DBGrid collection item was not parsed');
                  PropertyItem := FindProperty(ItemNode, 'FieldName');
                  FoundFieldName := (PropertyItem <> nil) and
                    (PropertyItem.Value = '''sType''');
                  CheckTrue(FoundFieldName,
                    'DBGrid collection item property was lost');
                end;
              end;
            end;
          finally
            Root.Free;
            Lines.Clear;
          end;
        end;
      until SysUtils.FindNext(Search) <> 0;
    finally
      SysUtils.FindClose(Search);
    end;
    CheckTrue(DFMCount > 0, 'No IDR text DFM fixtures were found');
  finally
    Lines.Free;
  end;
end;

procedure TReconstructionTests.TestPEHeaderOfTestExecutable;
var
  Input: ThePEFile;
  Header: TPEHeader;
  PreviousPEFile: ThePEFile;
  PreviousPEHeader: TPEHeader;
  PreviousELF, IsELF: Boolean;
begin
  PreviousPEFile := DeDeClasses.PEFile;
  PreviousPEHeader := DeDeClasses.PEHeader;
  PreviousELF := bELF;
  Input := nil;
  Header := nil;
  try
    LoadPEBinary(ParamStr(0), Input, Header, IsELF);
    CheckFalse(IsELF, 'The DUnit runner was incorrectly identified as ELF');
    CheckEquals('PE', Copy(Header.Signature, 1, 2),
      'PE signature was not decoded from ANSI bytes');
    CheckTrue(Header.ObjectNum > 0, 'PE section table was not parsed');
    CheckTrue((Header.Objects[1].OBJECT_NAME = '.text') or
      (Header.Objects[1].OBJECT_NAME = 'CODE'),
      'Unexpected first PE section name: ' + Header.Objects[1].OBJECT_NAME);
    CheckTrue(DeDeClasses.PEFile = PreviousPEFile,
      'PE loading changed the global PE file binding');
    CheckTrue(DeDeClasses.PEHeader = PreviousPEHeader,
      'PE loading changed the global PE header binding');
    CheckTrue(bELF = PreviousELF,
      'PE loading changed the global target-format flag');
  finally
    DeDeClasses.PEFile := PreviousPEFile;
    DeDeClasses.PEHeader := PreviousPEHeader;
    bELF := PreviousELF;
    Header.Free;
    Input.Free;
  end;
end;

procedure TReconstructionTests.TestEmulatorInvalidInputs;
var
  CPU: TCPUEmulator;
  Raised: Boolean;
  SavedEAX: string;
begin
  CPU := TCPUEmulator.Create;
  try
    CPU.SetRegValue('eax', $11223344);
    CheckEquals($11223344, CPU.GetRegValue('eax'),
      'Full-width register value changed');
    CheckEquals($44, CPU.GetRegValue('al'),
      'Low-byte register value changed');
    CheckEquals($33, CPU.GetRegValue('ah'),
      'High-byte register value changed');

    Raised := False;
    try
      CPU.GetRegValue('unknown');
    except
      on E: EConvertError do
        Raised := True;
    end;
    CheckTrue(Raised, 'Unknown register read was not rejected');

    Raised := False;
    try
      CPU.SetRegValue('unknown', 1);
    except
      on E: EConvertError do
        Raised := True;
    end;
    CheckTrue(Raised, 'Unknown register write was not rejected');

    Raised := False;
    try
      CPU.Emulate('mov eax, [ebp+4]');
    except
      on E: EConvertError do
        Raised := True;
    end;
    CheckTrue(Raised, 'Unsupported EBP-relative operand was not rejected');
  finally
    CPU.Free;
  end;

  SavedEAX := DeDeClassEmulator.EAX;
  try
    DeDeClassEmulator.EAX := 'TFixture';
    CheckEquals(Ord(rgEAX), Ord(Str2TRegister('eax')),
      'EAX register name was mapped incorrectly');
    CheckEquals('TFixture', GetRegVal(rgEAX),
      'Register string state changed');

    Raised := False;
    try
      Str2TRegister('invalid');
    except
      on E: EConvertError do
        Raised := True;
    end;
    CheckTrue(Raised, 'Unknown class-emulator register was not rejected');
  finally
    DeDeClassEmulator.EAX := SavedEAX;
  end;
end;

procedure TReconstructionTests.TestSymbolReferenceOffsetBounds;
var
  Stream: TPEStream;
  PreviousStream: TPEStream;
  PreviousConverter: TRVAConverter;
begin
  Stream := TPEStream.Create;
  PreviousStream := DeDeDisAsm.PEStream;
  PreviousConverter := DeDeDisAsm.RVAConverter;
  try
    Stream.Size := 4096;
    DeDeDisAsm.PEStream := Stream;
    DeDeDisAsm.RVAConverter.ImageBase := $400000;
    DeDeDisAsm.RVAConverter.CodeRVA := 0;
    DeDeDisAsm.RVAConverter.PhysOffset := 0;
    CheckEquals('', GetSymbolReference($3FFFFF),
      'An RVA below the image base wrapped into a stream offset');
  finally
    DeDeDisAsm.PEStream := PreviousStream;
    DeDeDisAsm.RVAConverter := PreviousConverter;
    Stream.Free;
  end;
end;

procedure TReconstructionTests.TestSHA1KnownVectors;
  procedure CheckHash(const Input, Expected: string);
  var
    Hash: TDCP_sha1;
    Digest: array[0..19] of Byte;
    AnsiInput: AnsiString;
    Actual: string;
    I: Integer;
  begin
    Hash := TDCP_sha1.Create(nil);
    try
      Hash.Init;
      AnsiInput := AnsiString(Input);
      if AnsiInput <> '' then
        Hash.Update(AnsiInput[1], Length(AnsiInput));
      Hash.Final(Digest);
      Actual := '';
      for I := Low(Digest) to High(Digest) do
        Actual := Actual + IntToHex(Digest[I], 2);
      CheckEquals(Expected, Actual, 'SHA-1 digest mismatch');
    finally
      Hash.Free;
    end;
  end;
begin
  CheckHash('abc',
    'A9993E364706816ABA3E25717850C26C9CD0D89D');
  CheckHash('', 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709');
end;

procedure TReconstructionTests.TestBSSAddressRangeAboveSignedLimit;
var
  BSS: TTestBSS;
  PreviousBSSState: Boolean;
begin
  BSS := TTestBSS.Create;
  PreviousBSSState := DeDeClasses.bBSS;
  try
    DeDeClasses.bBSS := True;
    BSS.dwDATAStartRVA := $80000000;
    BSS.dwDATASize := 8;
    BSS.AddDataValue($11111111);
    BSS.AddDataValue($22222222);
    CheckEquals($80000004,
      BSS.GetDataPrtOfBSSData($22222222),
      'BSS range lookup failed above the signed 32-bit boundary');
  finally
    DeDeClasses.bBSS := PreviousBSSState;
    BSS.Free;
  end;
end;

procedure TReconstructionTests.TestExpressionHighRVA;
var
  PreviousExpressions: array of TVar;
  PreviousCount: Integer;
  HighRVA: DWORD;
  I: Integer;
begin
  PreviousCount := ExpressionCount;
  SetLength(PreviousExpressions, Length(Expressions));
  for I := 0 to High(Expressions) do
    PreviousExpressions[I] := Expressions[I];
  try
    ExpressionCount := 0;
    SetLength(Expressions, 0);
    HighRVA := $F0000010;
    AddExpression(HighRVA, 'fixture', 'initial');
    CheckEquals(1, ExpressionCount,
      'A new expression was not added exactly once');
    CheckEquals('initial', GetExpression(HighRVA, 'fixture'),
      'Expression lookup failed for a high-bit RVA');
    EditExpression(HighRVA, 'fixture', 'updated');
    CheckEquals('updated', GetExpression(HighRVA, 'fixture'),
      'Expression update failed for a high-bit RVA');
    CheckEquals('', GetExpression(HighRVA, 'missing'),
      'A missing expression did not return an empty comment');
  finally
    SetLength(Expressions, Length(PreviousExpressions));
    for I := 0 to High(PreviousExpressions) do
      Expressions[I] := PreviousExpressions[I];
    ExpressionCount := PreviousCount;
  end;
end;

procedure TReconstructionTests.TestProcessPointerOffsetAboveSignedLimit;
var
  Address: Pointer;
begin
  Address := AddProcessPointerOffset(Pointer($F0000000), $1234);
  CheckTrue(Address = Pointer($F0001234),
    'Process pointer offset changed above the signed 32-bit boundary');
end;

procedure TReconstructionTests.TestMemLocEnumeratesCurrentProcess;
var
  Form: TChooseMemLocForm;
  ProcessID: DWORD;
  I: Integer;
  Found: Boolean;
begin
  ProcessID := GetCurrentProcessId;
  Form := TChooseMemLocForm.Create(nil);
  try
    Form.ProcsCBDropDown(Form.ProcsCB);
    Found := False;
    for I := 0 to Form.ProcsCB.Items.Count - 1 do
      if DWORD(Form.ProcsCB.Items.Objects[I]) = ProcessID then
      begin
        Found := True;
        Break;
      end;
    CheckTrue(Found, 'Current process was missing from MemLoc process list');
  finally
    Form.Free;
  end;
end;

procedure TReconstructionTests.TestCoreProgressHost;
var
  Context: TDeDeCoreContext;
  Recorder: TCoreProgressRecorder;
begin
  Context := TDeDeCoreContext.Create;
  Recorder := TCoreProgressRecorder.Create;
  try
    Context.OnProgress := Recorder.OnProgress;
    Context.ReportProgress('Parsing', ' sample.exe', 3, 10);
    CheckEquals(1, Recorder.Calls,
      'Core progress was not sent to its host adapter');
    CheckEquals('Parsing', Recorder.Phase,
      'Core progress phase changed');
    CheckEquals(' sample.exe', Recorder.Detail,
      'Core progress detail changed');
    CheckEquals(3, Recorder.Position,
      'Core progress position changed');
    CheckEquals(10, Recorder.Maximum,
      'Core progress maximum changed');
  finally
    Recorder.Free;
    Context.Free;
  end;
end;

procedure TReconstructionTests.TestCoreSessionProgressBeforeAnalyze;
var
  Session: TDeDeAnalysisSession;
  Recorder: TCoreProgressRecorder;
  MissingFile: string;
  Raised: Boolean;
begin
  MissingFile := IncludeTrailingPathDelimiter(FsTEMPDir) +
    'dede-progress-callback-' + IntToStr(GetTickCount) + '.exe';
  while FileExists(MissingFile) do
    MissingFile := MissingFile + '_';
  Session := TDeDeAnalysisSession.Create;
  Recorder := TCoreProgressRecorder.Create;
  try
    Session.OnProgress := Recorder.OnProgress;
    Raised := False;
    try
      Session.Analyze(MissingFile);
    except
      on E: EFOpenError do
        Raised := True;
    end;
    CheckTrue(Raised, 'Missing input did not fail the callback analysis');
    CheckEquals(1, Recorder.Calls,
      'Session progress callback was not active during initial loading');
    CheckEquals('Loading ', Recorder.Phase,
      'Initial session progress used the wrong phase');
    CheckEquals(ExtractFileName(MissingFile), Recorder.Detail,
      'Initial session progress used the wrong input name');
  finally
    Recorder.Free;
    Session.Free;
  end;
end;

procedure TReconstructionTests.TestCoreAttachedAnalysisIsBorrowed;
var
  Session: TDeDeAnalysisSession;
  Input: ThePEFile;
  Header: TPEHeader;
  Dumper: TClassesDumper;
  PreviousDumper: TObject;
begin
  PreviousDumper := DeDeCoreContext.ClassesDumper;
  Input := ThePEFile.Create('');
  Header := TPEHeader.Create;
  Dumper := TClassesDumper.Create;
  Session := TDeDeAnalysisSession.Create;
  try
    Session.AttachAnalysis(Input, Header, Dumper, 'D5');
    Session.Free;
    Session := nil;
    CheckTrue(Input.PEStream <> nil,
      'The attached PE file was freed by the session');
    CheckEquals(0, Header.ObjectNum,
      'The attached PE header was changed by the session');
    CheckTrue(Dumper.Classes <> nil,
      'The attached class dumper was freed by the session');
  finally
    Session.Free;
    DeDeCoreContext.ClassesDumper := PreviousDumper;
    Dumper.Free;
    Header.Free;
    Input.Free;
  end;
end;

procedure TReconstructionTests.TestCoreSessionsUseSeparateContexts;
var
  SessionOne, SessionTwo: TDeDeAnalysisSession;
  ContextOne, ContextTwo, PreviousContext: TDeDeCoreContext;
  Input: ThePEFile;
  Header: TPEHeader;
  Dumper: TClassesDumper;
  Generated: TStringList;
  Report: TStringList;
  Options: TDeDeExportOptions;
  OutputDirectory, ReportFile: string;
  MissingFile: string;
  Raised: Boolean;
  PreviousFile: ThePEFile;
  PreviousHeader: TPEHeader;
  PreviousStream: TPEStream;
  PreviousELF: Boolean;
  PreviousPASNameList, PreviousDFMNameList: TStringList;
  PreviousUnitList: TStringList;
begin
  OutputDirectory := IncludeTrailingPathDelimiter(FsTEMPDir) +
    'dede-session-context-' + IntToStr(GetTickCount);
  while DirectoryExists(OutputDirectory) do
    OutputDirectory := OutputDirectory + '_';
  ReportFile := IncludeTrailingPathDelimiter(OutputDirectory) +
    'analysis.json';

  PreviousContext := DeDeCoreContext;
  PreviousFile := DeDeClasses.PEFile;
  PreviousHeader := DeDeClasses.PEHeader;
  PreviousStream := DeDeDisAsm.PEStream;
  PreviousELF := DeDeClasses.bELF;
  PreviousPASNameList := DeDeDisAsm.PASNameList;
  PreviousDFMNameList := DeDeDisAsm.DFMNameList;
  PreviousUnitList := TStringList.Create;
  PreviousUnitList.Assign(DeDeDisAsm.UnitList);

  ContextOne := TDeDeCoreContext.Create;
  ContextTwo := TDeDeCoreContext.Create;
  ContextOne.FileName := 'first.exe';
  ContextOne.ProjectName := 'First';
  ContextOne.Warnings.Add('warning-from-first-session');
  ContextTwo.FileName := 'second.exe';
  ContextTwo.ProjectName := 'Second';
  ContextTwo.Warnings.Add('warning-from-second-session');
  MissingFile := IncludeTrailingPathDelimiter(FsTEMPDir) +
    'dede-session-invalid-' + IntToStr(GetTickCount) + '.exe';
  while FileExists(MissingFile) do
    MissingFile := MissingFile + '_';

  Input := ThePEFile.Create('');
  Header := TPEHeader.Create;
  Dumper := TClassesDumper.Create;
  SessionOne := TDeDeAnalysisSession.Create;
  SessionTwo := TDeDeAnalysisSession.Create;
  Generated := nil;
  Report := TStringList.Create;
  try
    DeDeCoreContext := ContextOne;
    SessionOne.AttachAnalysis(Input, Header, Dumper, 'D5');
    DeDeCoreContext := ContextTwo;
    SessionTwo.AttachAnalysis(Input, Header, Dumper, 'D5');
    CheckTrue(SessionOne.Context = ContextOne,
      'First session did not retain its attached context');
    CheckTrue(SessionTwo.Context = ContextTwo,
      'Second session did not retain its attached context');
    CheckTrue(ContextOne.PEFile = Input,
      'First context did not retain its explicit PE file');
    CheckTrue(ContextOne.PEHeader = Header,
      'First context did not retain its explicit PE header');
    CheckTrue(ContextTwo.PEFile = Input,
      'Second context did not retain its explicit PE file');

    FillChar(Options, SizeOf(Options), 0);
    Options.IncludeAnalysisReport := True;
    Generated := SessionOne.ExportProject(OutputDirectory, Options, False);
    CheckEquals(1, Generated.Count,
      'Analysis-report-only export returned the wrong file count');
    CheckTrue(DeDeCoreContext = ContextTwo,
      'Export did not restore the previously active context');
    CheckTrue(DeDeClasses.PEFile = PreviousFile,
      'Export did not restore the previous PE file');
    CheckTrue(DeDeClasses.PEHeader = PreviousHeader,
      'Export did not restore the previous PE header');
    CheckTrue(DeDeDisAsm.PEStream = PreviousStream,
      'Export did not restore the previous disassembly stream');
    CheckTrue(DeDeClasses.bELF = PreviousELF,
      'Export did not restore the previous target format');

    Report.LoadFromFile(ReportFile);
    CheckTrue(Pos('"project": "First"', Report.Text) > 0,
      'First session exported the other session''s project name');
    CheckTrue(Pos('warning-from-first-session', Report.Text) > 0,
      'First session did not export its own warnings');
    CheckEquals(0, Pos('warning-from-second-session', Report.Text),
      'First session exported the other session''s warnings');

    Raised := False;
    try
      SessionOne.Analyze(MissingFile);
    except
      on E: EFOpenError do
        Raised := True;
    end;
    CheckTrue(Raised, 'Invalid middle analysis did not fail');
    CheckTrue(DeDeCoreContext = ContextTwo,
      'Invalid middle analysis did not restore the active context');
    CheckTrue(SessionOne.Context = nil,
      'Invalid middle analysis retained its temporary context');

    DeDeCoreContext := ContextOne;
    SessionOne.AttachAnalysis(Input, Header, Dumper, 'D5');
    DeDeCoreContext := ContextTwo;
    Generated.Free;
    Generated := SessionOne.ExportProject(OutputDirectory, Options, True);
    CheckEquals(1, Generated.Count,
      'Recovered session export returned the wrong file count');
    Report.LoadFromFile(ReportFile);
    CheckTrue(Pos('"project": "First"', Report.Text) > 0,
      'Recovered session did not retain its original context');
    CheckTrue(Pos('warning-from-first-session', Report.Text) > 0,
      'Recovered session did not restore its own warning list');
    CheckEquals(0, Pos('warning-from-second-session', Report.Text),
      'Recovered session reused warnings from the active host context');
  finally
    Generated.Free;
    SessionOne.Free;
    SessionTwo.Free;
    DeDeCoreContext := PreviousContext;
    DeDeClasses.PEFile := PreviousFile;
    DeDeClasses.PEHeader := PreviousHeader;
    DeDeDisAsm.PEStream := PreviousStream;
    DeDeClasses.bELF := PreviousELF;
    DeDeDisAsm.PASNameList := PreviousPASNameList;
    DeDeDisAsm.DFMNameList := PreviousDFMNameList;
    DeDeDisAsm.UnitList.Assign(PreviousUnitList);
    PreviousUnitList.Free;
    Report.Free;
    Dumper.Free;
    Header.Free;
    Input.Free;
    ContextTwo.Free;
    ContextOne.Free;
    if FileExists(ReportFile) then
      SysUtils.DeleteFile(ReportFile);
    if DirectoryExists(OutputDirectory) then
      RemoveDir(OutputDirectory);
  end;
end;

procedure TReconstructionTests.TestCoreFailedAnalysisRestoresHostContext;
var
  Session: TDeDeAnalysisSession;
  PreviousContext: TDeDeCoreContext;
  PreviousFile: ThePEFile;
  PreviousHeader: TPEHeader;
  PreviousStream: TPEStream;
  PreviousELF: Boolean;
  MissingFile: string;
  Raised: Boolean;
begin
  MissingFile := IncludeTrailingPathDelimiter(FsTEMPDir) +
    'dede-missing-analysis-' + IntToStr(GetTickCount) + '.exe';
  while FileExists(MissingFile) do
    MissingFile := MissingFile + '_';
  PreviousContext := DeDeCoreContext;
  PreviousFile := DeDeClasses.PEFile;
  PreviousHeader := DeDeClasses.PEHeader;
  PreviousStream := DeDeDisAsm.PEStream;
  PreviousELF := DeDeClasses.bELF;
  Session := TDeDeAnalysisSession.Create;
  try
    Raised := False;
    try
      Session.Analyze(MissingFile);
    except
      on E: EFOpenError do
        Raised := True;
    end;
    CheckTrue(Raised, 'Missing input did not fail analysis');
    CheckTrue(DeDeCoreContext = PreviousContext,
      'Failed analysis did not restore the host context');
    CheckTrue(DeDeClasses.PEFile = PreviousFile,
      'Failed analysis did not restore the host PE file');
    CheckTrue(DeDeClasses.PEHeader = PreviousHeader,
      'Failed analysis did not restore the host PE header');
    CheckTrue(DeDeDisAsm.PEStream = PreviousStream,
      'Failed analysis did not restore the host PE stream');
    CheckTrue(DeDeClasses.bELF = PreviousELF,
      'Failed analysis did not restore the host target format');
    CheckTrue(Session.Context = nil,
      'Failed analysis retained its temporary session context');
  finally
    Session.Free;
    DeDeCoreContext := PreviousContext;
    DeDeClasses.PEFile := PreviousFile;
    DeDeClasses.PEHeader := PreviousHeader;
    DeDeDisAsm.PEStream := PreviousStream;
    DeDeClasses.bELF := PreviousELF;
  end;
end;

procedure TReconstructionTests.TestCoreReportExportAndOverwriteGuard;
var
  Session: TDeDeAnalysisSession;
  Input: ThePEFile;
  Header: TPEHeader;
  Dumper: TClassesDumper;
  Generated: TStringList;
  Report: TStringList;
  ResourceText: TStringStream;
  BinaryDFM: TMemoryStream;
  DFMOutput: TMemoryStream;
  DFMBeforeFailure: TMemoryStream;
  DFMText: TStringStream;
  FailureProgress: TCoreProgressRecorder;
  StageSearch: TSearchRec;
  StageFound: Boolean;
  Options: TDeDeExportOptions;
  OutputDirectory, ReportFile, CrossReferenceFile: string;
  Raised: Boolean;
  PreviousDumper: TObject;
  PreviousFile: ThePEFile;
  PreviousHeader: TPEHeader;
  PreviousStream: TPEStream;
  PreviousUnitList: TStringList;
  PreviousProgress: TDeDeCoreProgressEvent;
  PreviousELF: Boolean;
  PreviousWarnings: TStringList;
  PreviousDFMForms: TStringList;
  PreviousDFMOffsets: array of TPE32FileOffset;
  PreviousFileName, PreviousProjectName: string;
  I: Integer;
begin
  OutputDirectory := IncludeTrailingPathDelimiter(FsTEMPDir) +
    'dede-core-export-' + IntToStr(GetTickCount);
  while DirectoryExists(OutputDirectory) do
    OutputDirectory := OutputDirectory + '_';
  ReportFile := IncludeTrailingPathDelimiter(OutputDirectory) +
    'analysis.json';
  CrossReferenceFile := IncludeTrailingPathDelimiter(OutputDirectory) +
    'cross-references.json';

  PreviousDumper := DeDeCoreContext.ClassesDumper;
  PreviousFile := DeDeClasses.PEFile;
  PreviousHeader := DeDeClasses.PEHeader;
  PreviousStream := DeDeDisAsm.PEStream;
  PreviousProgress := DeDeCoreContext.OnProgress;
  PreviousELF := bELF;
  PreviousFileName := DeDeCoreContext.FileName;
  PreviousProjectName := DeDeCoreContext.ProjectName;
  PreviousWarnings := TStringList.Create;
  PreviousWarnings.Assign(DeDeCoreContext.Warnings);
  PreviousDFMForms := TStringList.Create;
  PreviousDFMForms.Assign(DeDeCoreContext.DFMFormList);
  SetLength(PreviousDFMOffsets, DeDeCoreContext.DFMFormList.Count);
  for I := 0 to High(PreviousDFMOffsets) do
    PreviousDFMOffsets[I] := DeDeCoreContext.GetDFMFileOffset(I);
  PreviousUnitList := TStringList.Create;
  PreviousUnitList.Assign(DeDeDisAsm.UnitList);
  Input := ThePEFile.Create('');
  Header := TPEHeader.Create;
  Dumper := TClassesDumper.Create;
  Session := TDeDeAnalysisSession.Create;
  Generated := nil;
  Report := TStringList.Create;
  ResourceText := TStringStream.Create(
    'object Form1: TForm'#13#10'end'#13#10);
  BinaryDFM := TMemoryStream.Create;
  DFMOutput := TMemoryStream.Create;
  DFMBeforeFailure := nil;
  FailureProgress := nil;
  DFMText := TStringStream.Create('');
  try
    ObjectTextToBinary(ResourceText, BinaryDFM);
    Input.PEStream.LoadFromStream(BinaryDFM);
    Header.ObjectNum := 1;
    Header.Objects[1].OBJECT_NAME := '.rsrc';
    Header.Objects[1].PHYSICAL_OFFSET := 0;
    Header.Objects[1].PHYSICAL_SIZE := Input.PEStream.Size;
    bELF := False;
    DeDeCoreContext.ClearDFMForms;
    DeDeCoreContext.AddDFMForm('Form1', 0);
    DeDeCoreContext.FileName := 'C:\fixture\my"binary.exe';
    DeDeCoreContext.ProjectName := 'Fixture';
    DeDeCoreContext.Warnings.Clear;
    DeDeCoreContext.OnProgress := nil;
    FillChar(Options, SizeOf(Options), 0);
    Options.IncludeDFM := True;
    Options.IncludeAnalysisReport := True;
    Options.IncludeCrossReferenceReport := True;
    Session.AttachAnalysis(Input, Header, Dumper, 'D5');

    Generated := Session.ExportProject(OutputDirectory, Options, False);
    CheckEquals(3, Generated.Count,
      'Synthetic DFM/report/xref export returned the wrong number of files');
    CheckTrue(FileExists(ReportFile),
      'Report-only export did not create analysis.json');
    CheckTrue(FileExists(CrossReferenceFile),
      'Opt-in export did not create cross-references.json');
    Report.LoadFromFile(CrossReferenceFile);
    CheckTrue(Pos('"format": "dede-xref-v1"', Report.Text) > 0,
      'Cross-reference report schema marker is missing');
    CheckTrue(Pos('"references": []', Report.Text) > 0,
      'Empty cross-reference list was not serialized deterministically');
    CheckTrue(FileExists(IncludeTrailingPathDelimiter(OutputDirectory) +
      'Form1.dfm'), 'Synthetic DFM export did not create Form1.dfm');
    Report.LoadFromFile(ReportFile);
    CheckTrue(Pos('C:\\fixture\\my\"binary.exe', Report.Text) > 0,
      'JSON escaping did not preserve Windows separators and quotes');
    DFMOutput.LoadFromFile(
      IncludeTrailingPathDelimiter(OutputDirectory) + 'Form1.dfm');
    DFMOutput.Position := 0;
    DFMOutput.ReadResHeader;
    ObjectBinaryToText(DFMOutput, DFMText);
    CheckTrue(Pos('object Form1: TForm', DFMText.DataString) > 0,
      'Exported DFM did not preserve its root object');
    Generated.Free;
    Generated := nil;

    Report.Clear;
    Report.Add('sentinel');
    Report.SaveToFile(ReportFile);
    Raised := False;
    try
      Generated := Session.ExportProject(OutputDirectory, Options, False);
    except
      on E: EDeDeOutputExists do
        Raised := True;
    end;

    CheckTrue(Raised, 'Existing output was accepted without force');
    Report.LoadFromFile(ReportFile);
    CheckEquals('sentinel', Report[0],
      'The existing report changed after a rejected export');

    Generated := Session.ExportProject(OutputDirectory, Options, True);
    CheckEquals(3, Generated.Count,
      'Forced report/xref export returned the wrong number of files');
    Report.LoadFromFile(ReportFile);
    CheckTrue(Pos('"project": "Fixture"', Report.Text) > 0,
      'Forced export did not replace the existing report');

    DFMBeforeFailure := TMemoryStream.Create;
    DFMBeforeFailure.LoadFromFile(
      IncludeTrailingPathDelimiter(OutputDirectory) + 'Form1.dfm');
    Report.Clear;
    Report.Add('staging-sentinel');
    Report.SaveToFile(ReportFile);
    FailureProgress := TCoreProgressRecorder.Create;
    FailureProgress.FailOnDetail := 'cross-references.json';
    DeDeCoreContext.OnProgress := FailureProgress.OnProgress;
    Generated.Free;
    Generated := nil;
    Raised := False;
    try
      Generated := Session.ExportProject(OutputDirectory, Options, True);
    except
      on E: EAbort do
        Raised := True;
    end;
    DeDeCoreContext.OnProgress := nil;
    CheckTrue(Raised, 'Injected staging failure did not escape export');
    Report.LoadFromFile(ReportFile);
    CheckEquals('staging-sentinel', Report[0],
      'Staging failure changed the existing report');
    Report.LoadFromFile(CrossReferenceFile);
    CheckTrue(Pos('"references": []', Report.Text) > 0,
      'Staging failure changed the existing cross-reference report');
    DFMOutput.LoadFromFile(
      IncludeTrailingPathDelimiter(OutputDirectory) + 'Form1.dfm');
    CheckEquals(DFMBeforeFailure.Size, DFMOutput.Size,
      'Staging failure changed the existing DFM size');
    CheckTrue(CompareMem(DFMBeforeFailure.Memory, DFMOutput.Memory,
      DFMBeforeFailure.Size),
      'Staging failure changed the existing DFM bytes');
    StageFound := SysUtils.FindFirst(
      IncludeTrailingPathDelimiter(OutputDirectory) + '.dede-stage-*',
      faAnyFile, StageSearch) = 0;
    if StageFound then
      SysUtils.FindClose(StageSearch);
    CheckFalse(StageFound,
      'Staging failure left temporary export files behind');
  finally
    Generated.Free;
    DeDeCoreContext.OnProgress := PreviousProgress;
    FailureProgress.Free;
    Session.Free;
    DeDeCoreContext.ClassesDumper := PreviousDumper;
    DeDeCoreContext.OnProgress := PreviousProgress;
    DeDeCoreContext.FileName := PreviousFileName;
    DeDeCoreContext.ProjectName := PreviousProjectName;
    DeDeCoreContext.Warnings.Assign(PreviousWarnings);
    DeDeCoreContext.ClearDFMForms;
    for I := 0 to PreviousDFMForms.Count - 1 do
      DeDeCoreContext.AddDFMForm(PreviousDFMForms[I],
        PreviousDFMOffsets[I]);
    DeDeClasses.PEFile := PreviousFile;
    DeDeClasses.PEHeader := PreviousHeader;
    DeDeDisAsm.PEStream := PreviousStream;
    DeDeDisAsm.UnitList.Assign(PreviousUnitList);
    PreviousUnitList.Free;
    PreviousWarnings.Free;
    PreviousDFMForms.Free;
    Dumper.Free;
    Header.Free;
    Input.Free;
    Report.Free;
    DFMText.Free;
    DFMOutput.Free;
    DFMBeforeFailure.Free;
    BinaryDFM.Free;
    ResourceText.Free;
    if FileExists(ReportFile) then
      SysUtils.DeleteFile(ReportFile);
    if FileExists(CrossReferenceFile) then
      SysUtils.DeleteFile(CrossReferenceFile);
    if FileExists(IncludeTrailingPathDelimiter(OutputDirectory) +
      'Form1.dfm') then
      SysUtils.DeleteFile(IncludeTrailingPathDelimiter(OutputDirectory) +
        'Form1.dfm');
    if DirectoryExists(OutputDirectory) then
      RemoveDir(OutputDirectory);
  end;
end;

procedure TReconstructionTests.TestX86CrossReferenceCollection;
var
  References: TDeDeXRefList;
  DirectCall: array[0..4] of Byte;
  BackwardCall: array[0..4] of Byte;
  ImportCall: array[0..4] of Byte;
  IndirectCall: array[0..1] of Byte;
  IndirectIATCall: array[0..5] of Byte;
  NonCall: array[0..1] of Byte;
  CalleeRet: array[0..2] of Byte;
  PlainRet: array[0..0] of Byte;
  PushEBP: array[0..0] of Byte;
  MoveEBP: array[0..1] of Byte;
  ReferenceIndex: Integer;
  DirectReferenceIndex: Integer;
  JSON: string;
begin
  DirectCall[0] := $E8;
  DirectCall[1] := $10;
  DirectCall[2] := 0;
  DirectCall[3] := 0;
  DirectCall[4] := 0;
  BackwardCall[0] := $E8;
  BackwardCall[1] := $E0;
  BackwardCall[2] := $FF;
  BackwardCall[3] := $FF;
  BackwardCall[4] := $FF;
  ImportCall[0] := $E8;
  ImportCall[1] := $FB;
  ImportCall[2] := $04;
  ImportCall[3] := 0;
  ImportCall[4] := 0;
  IndirectCall[0] := $FF;
  IndirectCall[1] := $D0;
  IndirectIATCall[0] := $FF;
  IndirectIATCall[1] := $15;
  IndirectIATCall[2] := $00;
  IndirectIATCall[3] := $10;
  IndirectIATCall[4] := $40;
  IndirectIATCall[5] := $00;
  NonCall[0] := $FF;
  NonCall[1] := $E0;
  CalleeRet[0] := $C2;
  CalleeRet[1] := 8;
  CalleeRet[2] := 0;
  PlainRet[0] := $C3;
  PushEBP[0] := $55;
  MoveEBP[0] := $8B;
  MoveEBP[1] := $EC;
  References := TDeDeXRefList.Create;
  try
    References.BeginRoutine($1000);
    References.RecordRoutineInstruction($1000, $1000, @CalleeRet[0],
      SizeOf(CalleeRet));
    References.BeginRoutine($2000);
    DirectReferenceIndex := References.AddX86Instruction($1000, $1000,
      @DirectCall[0], SizeOf(DirectCall));
    References.AddX86Instruction($1000, $1000, @DirectCall[0],
      SizeOf(DirectCall));
    References.SetCallerCleanup(DirectReferenceIndex, 8);
    References.SetCallerCleanup(DirectReferenceIndex, 8);
    References.MarkDirectCallTarget($1015);
    References.AddRegisterWriteEvidence(DirectReferenceIndex, 0, $0FF0);
    References.AddRegisterWriteEvidence(DirectReferenceIndex, 2, $0FF4);
    References.AddRegisterWriteEvidence(DirectReferenceIndex, 1, $0FF8);
    References.AddX86Instruction($2000, $2000, @BackwardCall[0],
      SizeOf(BackwardCall));
    ReferenceIndex := References.AddX86Instruction($2000, $2010, @IndirectCall[0],
      SizeOf(IndirectCall));
    References.SetCallerCleanup(ReferenceIndex, 12);
    References.AddX86Instruction($2000, $2020, @NonCall[0],
      SizeOf(NonCall));
    References.AddX86Instruction($3000, $3000, @ImportCall[0],
      SizeOf(ImportCall));
    ReferenceIndex := References.AddX86Instruction($5000, $5000,
      @IndirectIATCall[0], SizeOf(IndirectIATCall));
    References.ResolveImportIATCall($5000, $5000, $00401000,
      'KERNEL32.Sleep');
    References.BeginRoutine($3000);
    References.RecordRoutineInstruction($3000, $3000, @CalleeRet[0],
      SizeOf(CalleeRet));
    References.RecordRoutineInstruction($3000, $3001, @PlainRet[0],
      SizeOf(PlainRet));
    References.BeginRoutine($4000);
    References.RecordFrameAccess($4000, $4002, 8, 4);
    References.RecordRoutineInstruction($4000, $4000, @PushEBP[0],
      SizeOf(PushEBP));
    References.RecordRoutineInstruction($4000, $4001, @MoveEBP[0],
      SizeOf(MoveEBP));
    References.RecordFrameAccess($4000, $4002, 4, 4);
    References.RecordFrameAccess($4000, $4002, 8, 4);
    References.RecordFrameAccess($4000, $4003, 8, 4);
    References.RecordFrameAccess($4000, $4004, 12, 4);
    References.RecordRoutineInstruction($4000, $4003, @CalleeRet[0],
      SizeOf(CalleeRet));
    References.ResolveKnownMethod($1000, 'TSource.Entry');
    References.ResolveKnownMethod($1015, 'TTarget.Run');
    References.ResolveKnownMethod($1015, 'TOtherTarget.Run');
    References.ResolveKnownMethod($1FE5, 'TBackward.Target');
    References.ResolveImportCall($3000, $3000, 'KERNEL32.GetTickCount');

    CheckEquals(5, References.Count,
      'Call references were duplicated or non-call instructions were added');
    CheckEquals(LongInt($1015), LongInt(References[0].TargetVA),
      'Forward relative call target was decoded incorrectly');
    CheckEquals(LongInt($1FE5), LongInt(References[1].TargetVA),
      'Backward relative call target was decoded incorrectly');
    CheckFalse(References[2].HasTarget,
      'Register-indirect call was assigned a guessed target');
    JSON := References.ToJSON;
    CheckTrue(Pos('"kind":"direct_call"', JSON) > 0,
      'Direct call kind was omitted from the JSON representation');
    CheckTrue(Pos('"kind":"indirect_call"', JSON) > 0,
      'Indirect call kind was omitted from the JSON representation');
    CheckTrue(Pos('"targetVa":null', JSON) > 0,
      'Unresolved indirect target was not represented as null');
    CheckTrue(Pos('"sourceRoutineVa":"0x00001000"', JSON) > 0,
      'Call source address was not serialized as a PE32 VA');
    CheckTrue(Pos('"targetResolution":"ambiguous_class_method"', JSON) > 0,
      'Conflicting class method targets were not marked ambiguous');
    CheckTrue(Pos('"targetResolution":"known_class_method"', JSON) > 0,
      'Unique class method target was not resolved');
    CheckTrue(Pos('"targetName":"TBackward.Target"', JSON) > 0,
      'Resolved target name was not serialized');
    CheckTrue(Pos('"targetResolution":"known_import"', JSON) > 0,
      'Known import call was not resolved in the cross-reference graph');
    CheckTrue(Pos('"targetName":"KERNEL32.GetTickCount"', JSON) > 0,
      'Resolved import name was not serialized');
    CheckTrue(Pos('"importIatVa":"0x00401000"', JSON) > 0,
      'Absolute indirect import slot was not decoded');
    CheckTrue(Pos('"targetName":"KERNEL32.Sleep"', JSON) > 0,
      'Indirect import name was not recorded');
    CheckTrue(Pos('"registerWritesBeforeCall":[{"register":"eax","instructionRva":"0x00000FF0"},{"register":"edx","instructionRva":"0x00000FF4"},{"register":"ecx","instructionRva":"0x00000FF8"}]',
      JSON) > 0, 'Register definitions before the call were not retained');
    CheckTrue(Pos('"targetName":null', JSON) > 0,
      'Ambiguous target name was not omitted');
    CheckTrue(Pos('"callerCleanupBytes":12', JSON) > 0,
      'Caller stack-cleanup evidence was not recorded');
    JSON := References.RoutinesToJSON;
    CheckTrue(Pos('"calleeCleanupBytes":8', JSON) > 0,
      'Callee ret-immediate evidence was not recorded');
    CheckTrue(Pos('"isDirectCallTarget":true', JSON) > 0,
      'Directly observed call target was not identified');
    CheckTrue(Pos('"callSiteCleanupBytes":8,"callSiteCleanupConflict":false,"callSiteCleanupCount":1',
      JSON) > 0, 'Call-site cleanup consensus was not aggregated');
    CheckTrue(Pos('"stackCleanupWordCountCandidate":2', JSON) > 0,
      'Cleanup byte counts were not exposed as stack-word-count candidates');
    CheckTrue(Pos('"name":"TSource.Entry"', JSON) > 0,
      'Known source routine name was not serialized');
    CheckTrue(Pos('"calleeCleanupConflict":true', JSON) > 0,
      'Conflicting callee cleanup evidence was not marked');
    CheckTrue(Pos('"hasFramePointerPrologue":true', JSON) > 0,
      'Canonical EBP frame prologue was not recognized');
    CheckTrue(Pos('"stackOffset":"0x00000008","operandSize":4,"stackWordSlotIndex":0,"accessCount":2',
      JSON) > 0, 'Repeated stack parameter access evidence was not aggregated');
    CheckTrue(Pos('"stackOffset":"0x0000000C","operandSize":4,"stackWordSlotIndex":1',
      JSON) > 0, 'Stack word slot candidate was not derived from EBP offset');
    CheckTrue(Pos('"instructionVas":["0x00004002","0x00004003"]', JSON) > 0,
      'Stack access instruction RVAs were not preserved as evidence');
    CheckTrue(Pos('"stackArgumentEvidence":"matched"', JSON) > 0,
      'Matching frame offsets and callee cleanup were not corroborated');
    CheckTrue(Pos('"stackArgumentEvidence":"cleanup_only"', JSON) > 0,
      'Cleanup-only evidence was not represented conservatively');
  finally
    References.Free;
  end;
end;

procedure TReconstructionTests.TestDSFSymbolMatching;
var
  Symbol: TDeDeSymbol;
  Matches: TStringList;
  Pattern, DifferentPattern, Candidate: TSymBuffer;
  NameBytes: AnsiString;
  NameLength: Byte;
  I: Integer;
  NameOffset: Int64;

  procedure AddPattern(const APattern: TSymBuffer; const AName: string);
  begin
    Symbol.Sym.WriteBuffer(APattern[1], _PatternSize);
    NameOffset := Symbol.Str.Position;
    Symbol.Index[I] := NameOffset;
    NameBytes := AnsiString(AName);
    NameLength := Length(NameBytes);
    Symbol.Str.WriteBuffer(NameLength, SizeOf(NameLength));
    if NameLength > 0 then
      Symbol.Str.WriteBuffer(NameBytes[1], NameLength);
    Inc(I);
  end;

begin
  CheckEquals('vcl2.dsf', GetVersionedDSFName('D2'));
  CheckEquals('vcl3.dsf', GetVersionedDSFName('BCB3'));
  CheckEquals('vcl6.dsf', GetVersionedDSFName('D6 CLX'));
  CheckEquals('', GetVersionedDSFName('unknown'));
  FillChar(Pattern, SizeOf(Pattern), 0);
  Pattern[1] := $55;
  Pattern[2] := $8B;
  FillChar(DifferentPattern, SizeOf(DifferentPattern), 0);
  DifferentPattern[1] := $56;
  DifferentPattern[2] := $8B;
  Candidate := Pattern;
  Symbol := TDeDeSymbol.Create;
  Matches := TStringList.Create;
  try
    Symbol.PatternSize := _PatternSize;
    Symbol.Mode := $10;
    Symbol.Count := 3;
    SetLength(Symbol.Index, Symbol.Count);
    I := 0;
    AddPattern(Pattern, 'System.First');
    AddPattern(Pattern, 'System.Second');
    AddPattern(DifferentPattern, 'System.Other');

    CheckEquals(2, Symbol.FindMatches(Candidate, $10, Matches),
      'Matching signatures with distinct names must be ambiguous');
    CheckEquals('System.First', Matches[0]);
    CheckEquals('System.Second', Matches[1]);
    Matches.Clear;
    CheckEquals(1, Symbol.FindMatches(DifferentPattern, $10, Matches),
      'A unique signature should resolve to one name');
    CheckEquals('System.Other', Matches[0]);
    Matches.Clear;
    CheckEquals(0, Symbol.FindMatches(Candidate, $01, Matches),
      'A DSF outside its compiler-version mask must not match');
    Candidate[2] := $90;
    Matches.Clear;
    CheckEquals(0, Symbol.FindMatches(Candidate, $10, Matches),
      'A byte mismatch must not be treated as a wildcard');
  finally
    Matches.Free;
    Symbol.Free;
  end;
end;

procedure TReconstructionTests.TestXRefDSFSymbolResolution;
var
  References: TDeDeXRefList;
  CallToFirst, CallToSecond: array[0..4] of Byte;
  JSON: string;

  procedure SetDirectCall(var ACall: array of Byte; ASourceVA,
    ATargetVA: LongWord);
  var
    Displacement: LongInt;
  begin
    Displacement := LongInt(ATargetVA - (ASourceVA + 5));
    ACall[0] := $E8;
    Move(Displacement, ACall[1], SizeOf(Displacement));
  end;

begin
  References := TDeDeXRefList.Create;
  try
    SetDirectCall(CallToFirst, $5000, $6000);
    SetDirectCall(CallToSecond, $5005, $7000);
    References.BeginRoutine($5000);
    References.AddX86Instruction($5000, $5000, @CallToFirst[0],
      SizeOf(CallToFirst));
    References.AddX86Instruction($5000, $5005, @CallToSecond[0],
      SizeOf(CallToSecond));
    References.ResolveDSFSymbol($6000, 'System.UniqueRoutine');
    JSON := References.ToJSON;
    CheckTrue(Pos('"targetResolution":"known_dsf_symbol"', JSON) > 0,
      'An exact unique DSF match was not applied to its call edge');
    CheckTrue(Pos('"targetNameSource":"built_in_dsf"', JSON) > 0,
      'DSF name provenance was not serialized');
    CheckTrue(Pos('"targetNameConfidence":"exact_pattern"', JSON) > 0,
      'DSF pattern confidence was not serialized');
    References.ResolveKnownMethod($6000, 'TKnownClass.Method');
    References.ResolveDSFSymbol($7000, 'System.FirstCandidate');
    References.ResolveDSFSymbol($7000, 'System.SecondCandidate');
    JSON := References.ToJSON;
    CheckTrue(Pos('"targetResolution":"known_class_method"', JSON) > 0,
      'Class metadata must override a lower-priority DSF label');
    CheckTrue(Pos('"targetName":"TKnownClass.Method"', JSON) > 0,
      'Class-method name did not take priority over the DSF name');
    CheckTrue(Pos('"targetResolution":"ambiguous_dsf_symbol"', JSON) > 0,
      'Multiple matching DSF names were not left ambiguous');
    CheckTrue(Pos('"targetNameSource":"class_metadata"', JSON) > 0,
      'Resolved symbol provenance was not serialized');
    JSON := References.RoutinesToJSON;
    CheckTrue(Pos('"nameResolution":"known_class_method"', JSON) > 0,
      'Routine metadata resolution was not serialized');
    CheckTrue(Pos('"nameResolution":"ambiguous_dsf_symbol"', JSON) > 0,
      'Ambiguous routine symbol resolution was not serialized');
    CheckTrue(Pos('"nameConfidence":"exact_address"', JSON) > 0,
      'Routine name confidence was not serialized');
  finally
    References.Free;
  end;
end;

procedure TReconstructionTests.TestCoreExportCaseInsensitiveUnitCollision;
var
  Session: TDeDeAnalysisSession;
  Context, PreviousContext: TDeDeCoreContext;
  Input: ThePEFile;
  Header: TPEHeader;
  Dumper: TClassesDumper;
  Generated: TStringList;
  Options: TDeDeExportOptions;
  OutputDirectory: string;
  PreviousFile: ThePEFile;
  PreviousHeader: TPEHeader;
  PreviousStream: TPEStream;
  PreviousPASNameList, PreviousDFMNameList: TStringList;
  PreviousUnitList: TStringList;
  PreviousELF: Boolean;
  Raised: Boolean;
begin
  OutputDirectory := IncludeTrailingPathDelimiter(FsTEMPDir) +
    'dede-case-collision-' + IntToStr(GetTickCount);
  while DirectoryExists(OutputDirectory) do
    OutputDirectory := OutputDirectory + '_';
  PreviousContext := DeDeCoreContext;
  PreviousFile := DeDeClasses.PEFile;
  PreviousHeader := DeDeClasses.PEHeader;
  PreviousStream := DeDeDisAsm.PEStream;
  PreviousPASNameList := DeDeDisAsm.PASNameList;
  PreviousDFMNameList := DeDeDisAsm.DFMNameList;
  PreviousELF := DeDeClasses.bELF;
  PreviousUnitList := TStringList.Create;
  PreviousUnitList.Assign(DeDeDisAsm.UnitList);

  Context := TDeDeCoreContext.Create;
  Context.ProjectName := 'Collision';
  Context.DFMNameList.Add('TFormA');
  Context.DFMNameList.Add('TFormB');
  Context.PASNameList.Add('UnitA');
  Context.PASNameList.Add('unita');
  Input := ThePEFile.Create('');
  Header := TPEHeader.Create;
  Header.ObjectNum := 1;
  Header.BaseOfCode := $1000;
  Header.Objects[1].RVA := $1000;
  Header.Objects[1].PHYSICAL_SIZE := 16;
  Dumper := TClassesDumper.Create;
  Session := TDeDeAnalysisSession.Create;
  Generated := nil;
  try
    DeDeCoreContext := Context;
    Session.AttachAnalysis(Input, Header, Dumper, 'D5');
    FillChar(Options, SizeOf(Options), 0);
    Options.IncludePAS := True;

    Raised := False;
    try
      Generated := Session.ExportProject(OutputDirectory, Options, False);
    except
      on E: EConvertError do
        Raised := True;
    end;
    CheckTrue(Raised,
      'Case-insensitive PAS filename collision was not rejected');
    CheckFalse(DirectoryExists(OutputDirectory),
      'Filename collision created an output directory');
  finally
    Generated.Free;
    Session.Free;
    DeDeCoreContext := PreviousContext;
    DeDeClasses.PEFile := PreviousFile;
    DeDeClasses.PEHeader := PreviousHeader;
    DeDeDisAsm.PEStream := PreviousStream;
    DeDeDisAsm.PASNameList := PreviousPASNameList;
    DeDeDisAsm.DFMNameList := PreviousDFMNameList;
    DeDeDisAsm.UnitList.Assign(PreviousUnitList);
    DeDeClasses.bELF := PreviousELF;
    PreviousUnitList.Free;
    Dumper.Free;
    Header.Free;
    Input.Free;
    Context.Free;
    if DirectoryExists(OutputDirectory) then
      RemoveDir(OutputDirectory);
  end;
end;

procedure TReconstructionTests.TestZipFormatConsumers;
var
  OutputDirectory, BPLFileName, ExtendedBPLFileName, DUFFileName,
    DOIFileName: string;
  Bytes, Names, LoadedBytes, LoadedNames, RawBPL: TMemoryStream;
  Pattern: LongWord;
  NameLength, Mode, PatternSize: Byte;
  HeaderMode, HeaderPatternSize: Byte;
  HeaderCount: Word;
  HeaderExtension, HeaderPatternOffset, HeaderNamesOffset: LongWord;
  RecordCount: LongInt;
  Comment: string;
  Indexes: TBoundArray;
  DUFFile, LoadedDUF: TDUFFile;
  DOIFile, LoadedDOI: TOffsInfArchive;
  TempIndex: Integer;
begin
  OutputDirectory := IncludeTrailingPathDelimiter(GetCurrentDir) +
    'dede-zip-consumers-' + IntToHex(GetTickCount, 8);
  TempIndex := 0;
  while DirectoryExists(OutputDirectory) do
  begin
    Inc(TempIndex);
    OutputDirectory := IncludeTrailingPathDelimiter(GetCurrentDir) +
      'dede-zip-consumers-' + IntToHex(GetTickCount, 8) + '-' +
      IntToStr(TempIndex);
  end;
  CheckTrue(ForceDirectories(OutputDirectory),
    'Unable to create ZIP consumer test directory');

  BPLFileName := IncludeTrailingPathDelimiter(OutputDirectory) + 'roundtrip.dsf';
  ExtendedBPLFileName := IncludeTrailingPathDelimiter(OutputDirectory) +
    'roundtrip-extended.dsf';
  DUFFileName := IncludeTrailingPathDelimiter(OutputDirectory) + 'roundtrip.duf';
  DOIFileName := IncludeTrailingPathDelimiter(OutputDirectory) + 'roundtrip.doi';
  Bytes := TMemoryStream.Create;
  Names := TMemoryStream.Create;
  LoadedBytes := TMemoryStream.Create;
  LoadedNames := TMemoryStream.Create;
  RawBPL := TMemoryStream.Create;
  DUFFile := TDUFFile.Create;
  LoadedDUF := TDUFFile.Create;
  DOIFile := TOffsInfArchive.Create;
  LoadedDOI := TOffsInfArchive.Create;
  try
    Pattern := $12345678;
    Bytes.WriteBuffer(Pattern, SizeOf(Pattern));
    NameLength := 4;
    Names.WriteBuffer(NameLength, SizeOf(NameLength));
    WriteAnsiString(Names, 'Test');
    SaveBPLSymbolFile(Bytes, Names, BPLFileName, 4, 4, 1,
      'adapter test');
    Mode := 0;
    PatternSize := 0;
    RecordCount := 0;
    Comment := '';
    CheckTrue(LoadBPLSymbolFile(LoadedBytes, LoadedNames, BPLFileName,
      Mode, PatternSize, RecordCount, Comment, Indexes),
      'BPL consumer could not read its ZIP output');
    CheckEquals(4, Mode, 'BPL mode changed after ZIP round-trip');
    CheckEquals(4, PatternSize, 'BPL pattern size changed after round-trip');
    CheckEquals(1, RecordCount, 'BPL record count changed after round-trip');
    CheckEquals('adapter test', Comment,
      'BPL comment changed after ZIP round-trip');
    CheckEquals(Bytes.Size, LoadedBytes.Size,
      'BPL pattern stream size changed after ZIP round-trip');
    CheckTrue(CompareMem(Bytes.Memory, LoadedBytes.Memory, Bytes.Size),
      'BPL pattern bytes changed after ZIP round-trip');
    CheckEquals(Names.Size, LoadedNames.Size,
      'BPL name stream size changed after ZIP round-trip');
    CheckTrue(CompareMem(Names.Memory, LoadedNames.Memory, Names.Size),
      'BPL name bytes changed after ZIP round-trip');
    CheckEquals(1, Length(Indexes), 'BPL name index count changed');
    CheckEquals(0, Indexes[0], 'BPL name index offset changed');

    SaveBPLSymbolFile(Bytes, Names, ExtendedBPLFileName, $D0, 4, 1,
      'extended header');
    ExtractZipEntryToStream(ExtendedBPLFileName,
      ExtractFileName(ExtendedBPLFileName), RawBPL);
    RawBPL.Seek(4, soFromBeginning);
    RawBPL.ReadBuffer(HeaderMode, SizeOf(HeaderMode));
    RawBPL.ReadBuffer(HeaderExtension, SizeOf(HeaderExtension));
    RawBPL.ReadBuffer(HeaderCount, SizeOf(HeaderCount));
    RawBPL.ReadBuffer(HeaderPatternSize, SizeOf(HeaderPatternSize));
    RawBPL.ReadBuffer(HeaderPatternOffset, SizeOf(HeaderPatternOffset));
    RawBPL.ReadBuffer(HeaderNamesOffset, SizeOf(HeaderNamesOffset));
    CheckEquals($D0, HeaderMode,
      'Extended DSF header mode was not retained');
    CheckEquals(0, HeaderExtension,
      'Extended DSF header DWORD was not written after the mode');
    CheckEquals(1, HeaderCount,
      'Extended DSF record count was written at the wrong offset');
    CheckEquals(4, HeaderPatternSize,
      'Extended DSF pattern length was written at the wrong offset');
    CheckEquals(36, LongInt(HeaderPatternOffset),
      'Extended DSF pattern offset did not account for its header DWORD');
    CheckEquals(40, LongInt(HeaderNamesOffset),
      'Extended DSF names offset did not account for its header DWORD');

    Mode := 0;
    PatternSize := 0;
    RecordCount := 0;
    Comment := '';
    CheckTrue(LoadBPLSymbolFile(LoadedBytes, LoadedNames,
      ExtendedBPLFileName, Mode, PatternSize, RecordCount, Comment, Indexes),
      'BPL consumer could not read the extended DSF header');
    CheckEquals($D0, Mode, 'Extended BPL mode changed after round-trip');
    CheckEquals(4, PatternSize,
      'Extended BPL pattern size changed after round-trip');
    CheckEquals(1, RecordCount,
      'Extended BPL record count changed after round-trip');
    CheckEquals('extended header', Comment,
      'Extended BPL comment changed after round-trip');
    CheckEquals(Bytes.Size, LoadedBytes.Size,
      'Extended BPL pattern bytes changed after round-trip');
    CheckTrue(CompareMem(Bytes.Memory, LoadedBytes.Memory, Bytes.Size),
      'Extended BPL pattern contents changed after round-trip');
    CheckEquals(Names.Size, LoadedNames.Size,
      'Extended BPL name bytes changed after round-trip');
    CheckTrue(CompareMem(Names.Memory, LoadedNames.Memory, Names.Size),
      'Extended BPL name contents changed after round-trip');

    DUFFile.DUFVersion := CURR_DUFF_VERSION;
    DUFFile.SaveToFile(DUFFileName);
    LoadedDUF.LoadFromFile(DUFFileName);
    CheckEquals(CURR_DUFF_VERSION, LoadedDUF.DUFVersion,
      'DUF version changed after ZIP round-trip');
    CheckEquals(0, LoadedDUF.ExpressionCount,
      'Empty DUF variable table changed after round-trip');
    CheckEquals(0, LoadedDUF.CommentsCount,
      'Empty DUF comment table changed after round-trip');
    CheckEquals(0, LoadedDUF.EmulationCount,
      'Empty DUF emulation table changed after round-trip');

    DOIFile.mode := $10;
    DOIFile.reserved := 1;
    DOIFile.Save(DOIFileName);
    LoadedDOI.Extract(DOIFileName);
    CheckEquals(DOIFile.mode, LoadedDOI.mode,
      'DOI mode changed after ZIP round-trip');
    CheckEquals(DOIFile.reserved, LoadedDOI.reserved,
      'DOI version changed after ZIP round-trip');
    CheckEquals(0, LoadedDOI.classes_count,
      'Empty DOI class table changed after round-trip');
  finally
    LoadedDOI.Free;
    DOIFile.Free;
    LoadedDUF.Free;
    DUFFile.Free;
    LoadedNames.Free;
    LoadedBytes.Free;
    RawBPL.Free;
    Names.Free;
    Bytes.Free;
    if FileExists(BPLFileName) then
      SysUtils.DeleteFile(BPLFileName);
    if FileExists(ExtendedBPLFileName) then
      SysUtils.DeleteFile(ExtendedBPLFileName);
    if FileExists(DUFFileName) then
      SysUtils.DeleteFile(DUFFileName);
    if FileExists(DOIFileName) then
      SysUtils.DeleteFile(DOIFileName);
    RemoveDir(OutputDirectory);
  end;
end;

procedure TReconstructionTests.TestCoreVersionConfiguration;
var
  PreviousCompatibility: Byte;
  PreviousVersion: string;
  PreviousReducedVersion: TRedusedDelphiVersion;
  PreviousDelphi2, PreviousCBuilder: Boolean;
begin
  PreviousCompatibility := DeDeCoreContext.DelphiVersionCompatibility;
  PreviousVersion := DelphiVersion;
  PreviousReducedVersion := ReducedDelphiVersion;
  PreviousDelphi2 := GlobDelphi2;
  PreviousCBuilder := GlobCBuilder;
  try
    TDeDeAnalysisSession.ConfigureVersion('D5');
    CheckEquals($04, DeDeCoreContext.DelphiVersionCompatibility,
      'Delphi 5 symbol compatibility mask changed');
    CheckEquals(Ord(dvD5), Ord(ReducedDelphiVersion),
      'Delphi 5 reduced version changed');

    TDeDeAnalysisSession.ConfigureVersion('BCB4');
    CheckEquals($02, DeDeCoreContext.DelphiVersionCompatibility,
      'C++Builder 4 symbol compatibility mask changed');
    CheckEquals(Ord(dvBCB4), Ord(ReducedDelphiVersion),
      'C++Builder 4 reduced version changed');
    CheckTrue(GlobCBuilder, 'C++Builder mode was not selected');
    CheckFalse(GlobDelphi2, 'C++Builder mode retained Delphi 2 state');
  finally
    DeDeCoreContext.DelphiVersionCompatibility := PreviousCompatibility;
    DelphiVersion := PreviousVersion;
    ReducedDelphiVersion := PreviousReducedVersion;
    GlobDelphi2 := PreviousDelphi2;
    GlobCBuilder := PreviousCBuilder;
  end;
end;

procedure TReconstructionTests.TestVMTMethodOffsetMapping;
var
  Stream, PreviousStream: TPEStream;
  Input, PreviousFile: ThePEFile;
  Header, PreviousHeader: TPEHeader;
  Dumper: TClassDumper;
  PreviousProcRefOffsets, PreviousProcRefNames: TStringList;
  SlotAddress: DWORD;
  MethodCount, MethodFlag: Word;
  PaintIndex, ClickIndex: Integer;
  PreviousELF: Boolean;

  procedure WriteMethod(Flag: Word; Address: DWORD;
    const MethodName: AnsiString);
  var
    MethodNameLength: Byte;
  begin
    MethodNameLength := Length(MethodName);
    Stream.WriteBuffer(Flag, SizeOf(Flag));
    Stream.WriteBuffer(Address, SizeOf(Address));
    Stream.WriteBuffer(MethodNameLength, SizeOf(MethodNameLength));
    if MethodNameLength > 0 then
      Stream.WriteBuffer(MethodName[1], MethodNameLength);
  end;

begin
  PreviousFile := DeDeClasses.PEFile;
  PreviousHeader := DeDeClasses.PEHeader;
  PreviousStream := DeDeDisAsm.PEStream;
  PreviousELF := DeDeClasses.bELF;
  PreviousProcRefOffsets := TStringList.Create;
  PreviousProcRefNames := TStringList.Create;
  PreviousProcRefOffsets.Assign(DeDeClasses.ProcRefOffsets);
  PreviousProcRefNames.Assign(DeDeClasses.ProcRefNames);
  Header := nil;
  Input := nil;
  Stream := nil;
  Dumper := nil;
  try
    Header := TPEHeader.Create;
    Input := ThePEFile.Create('');
    Stream := Input.PEStream;
    DeDeClasses.PEFile := Input;
    DeDeClasses.PEHeader := Header;
    Dumper := TClassDumper.Create;
    Dumper.SetImage(Input, Header);
    DeDeDisAsm.PEStream := Stream;
    DeDeClasses.bELF := False;
    DeDeClasses.ProcRefOffsets.Clear;
    DeDeClasses.ProcRefNames.Clear;

    Header.ObjectNum := 1;
    Header.BaseOfCode := $1000;
    Header.Objects[1].OBJECT_NAME := 'CODE';
    Header.Objects[1].RVA := $1000;
    Header.Objects[1].PHYSICAL_OFFSET := 0;
    Header.Objects[1].PHYSICAL_SIZE := 32;

    SlotAddress := $1000;
    Stream.WriteBuffer(SlotAddress, SizeOf(SlotAddress));
    SlotAddress := $1004;
    Stream.WriteBuffer(SlotAddress, SizeOf(SlotAddress));
    SlotAddress := 0;
    Stream.WriteBuffer(SlotAddress, SizeOf(SlotAddress));
    Stream.Position := 16;
    MethodCount := 2;
    Stream.WriteBuffer(MethodCount, SizeOf(MethodCount));
    MethodFlag := 1;
    WriteMethod(MethodFlag, $1004, 'Paint');
    WriteMethod(MethodFlag, $1010, 'Click');

    Dumper.DELTA_PHYS := $1000;
    Dumper.FdwVMTPos := 0;
    Dumper.FdwFieldDefTlbPos := 12;
    Dumper.FdwMethodDefTlbPtr := $1010;
    Dumper.FdwMethodDefTlbPos := 16;
    Dumper.DumpMethods(0);

    PaintIndex := Dumper.MethodData.MethodIndexByRVA($1004);
    ClickIndex := Dumper.MethodData.MethodIndexByRVA($1010);
    CheckTrue(PaintIndex >= 0, 'Virtual method was not read from method table');
    CheckTrue(ClickIndex >= 0, 'Non-virtual method was not read from method table');
    CheckEquals(4, Integer(TMethodRec(
      Dumper.MethodData.Methods[PaintIndex]).dwVMTOffset),
      'Virtual method was assigned the wrong VMT slot offset');
    CheckEquals(Integer(METHOD_VMT_OFFSET_NONE), Integer(TMethodRec(
      Dumper.MethodData.Methods[ClickIndex]).dwVMTOffset),
      'Method absent from the VMT received a slot offset');
  finally
    Dumper.Free;
    Input.Free;
    Header.Free;
    DeDeClasses.PEFile := PreviousFile;
    DeDeClasses.PEHeader := PreviousHeader;
    DeDeDisAsm.PEStream := PreviousStream;
    DeDeClasses.bELF := PreviousELF;
    DeDeClasses.ProcRefOffsets.Assign(PreviousProcRefOffsets);
    DeDeClasses.ProcRefNames.Assign(PreviousProcRefNames);
    PreviousProcRefOffsets.Free;
    PreviousProcRefNames.Free;
  end;
end;

initialization
  RegisterTest(TReconstructionTests.Suite);

end.
