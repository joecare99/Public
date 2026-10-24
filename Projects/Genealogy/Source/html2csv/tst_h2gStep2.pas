unit tst_h2gStep2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit,FileUtil, testregistry, cls_h2gStep2, unt_TestFBData;

type

  { TTesth2gStep2 }

  TTesth2gStep2= class(TTestCase)
  private
    FActLine:integer;
    FInput: TStringList;
    FExpOutput:TStringlist;
    FH2gStep2: TH2gStep2;
    FDataPath,
    FFilename:String;
    procedure HtmlComputeOutput(CType: byte; Text: String);
    procedure TestFile3(aFilename: String);
    procedure TestProcessData(Sender: TObject; const aText, aRef, aKat,
      aData: String);
    procedure TestStartFamily(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestFamilyDate(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestFamilyData(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestFamilyIndiv(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestFamilyPlace(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestFamilyType(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestIndiData(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestIndiDate(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestIndiName(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestIndiOccu(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestIndiPlace(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestIndiRef(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure TestIndiRel(Sender: TObject; aText, Ref: string; dsubtype: integer);
    procedure ParserTestEvent(Sender: TObject; eType, aText, Ref: string;
        dsubtype: integer);
    procedure TestStartIndiv(Sender: TObject; aText: string; Ref: string;
      dsubtype: integer);
private
    FlastDeb: String;
        procedure AddExpResult(Data: array of variant);
        procedure CreateExpResult(st: TStrings; out Expct: TResultTypeArray);
        procedure ExpResultToTStr(const Exp: array of TResultType; st: TStrings);

  protected
    FResult, ExpResults: array of TResultType;
    FRCounter: integer;
    FTestName: string;

    procedure SetUp; override;
    procedure TearDown; override;
    procedure TestFile1(aFilename: String);
    procedure TestFile2(aFilename: String);
  published
    procedure TestSetUp;
    Procedure TestVieser_I5;
    Procedure TestVieser_I12;
    Procedure TestVieser_I23;
    Procedure TestVieser_I31;
    Procedure TestVieser_I42;
    Procedure TestVieser_I50;
    Procedure TestVieser_I61;
    Procedure TestVieser_I80;
    Procedure TestVieser_I134;
    Procedure TestVieser_I255;
    Procedure TestVieser2_I5;
    Procedure TestVieser2_I12;
    Procedure TestVieser2_I23;
    Procedure TestVieser2_I31;
    Procedure TestVieser2_I42;
    Procedure TestVieser2_I50;
    Procedure TestVieser2_I61;
    Procedure TestVieser2_I80;
    Procedure TestVieser2_I134;
    Procedure TestVieser2_I255;
    Procedure TestVieser3_I5;
    procedure TestVieser3_I12;
    procedure TestVieser3_I23;
    procedure TestVieser3_I31;
    procedure TestVieser3_I42;
    procedure TestVieser3_I50;
    procedure TestVieser3_I61;
    procedure TestVieser3_I80;
    procedure TestVieser3_I134;
    procedure TestVieser3_I255;
    Procedure TestVieser_I12577;
    Procedure TestVieser2_I12577;
    procedure TestVieser3_I12577;
    public
      Constructor Create; override;
  end;

implementation

uses Unt_FileProcs;

procedure TTesth2gStep2.HtmlComputeOutput(CType: byte; Text: String);
var
  Line: String;
begin
   Line := format('%d: %s',[Ctype,Text.Replace('\','\\').Replace(#10,'\n').replace(#13,'\r')]);
   if FExpOutput.Count >0 then
     begin
       CheckEquals(FExpOutput[FActLIne],Line,FFilename+'.Line['+inttostr(FActLIne)+']');
       inc(FActLine);
     end;
end;

procedure TTesth2gStep2.TestProcessData(Sender: TObject; const aText, aRef,
  aKat, aData: String);
begin
  ParserTestEvent(Sender, 'PD: '+aText, aRef+'.'+aKat, aData, 0);
end;

procedure TTesth2gStep2.TestStartFamily(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
  ParserTestEvent(Sender, 'ParserStartFamily', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestFamilyDate(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
     ParserTestEvent(Sender, 'ParserFamilyDate', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestFamilyData(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
  ParserTestEvent(Sender, 'ParserFamilyData', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestFamilyIndiv(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
   ParserTestEvent(Sender, 'ParserFamilyIndiv', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestFamilyPlace(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyPlace', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestFamilyType(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
      ParserTestEvent(Sender, 'ParserFamilyType', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestIndiData(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
  ParserTestEvent(Sender, 'ParserIndiData', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestIndiDate(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
   ParserTestEvent(Sender, 'ParserIndiDate', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestIndiName(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
     ParserTestEvent(Sender, 'ParserIndiName', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestIndiOccu(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
  ParserTestEvent(Sender, 'ParserIndiOccu', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestIndiPlace(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserIndiPlace', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestIndiRef(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserIndiRef', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.TestIndiRel(Sender: TObject; aText, Ref: string;
  dsubtype: integer);
begin
   ParserTestEvent(Sender, 'ParserIndiRel', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.ParserTestEvent(Sender: TObject; eType, aText, Ref: string;
  dsubtype: integer);
var
    lr: TResultType;
    lDebEv, {%H-}lLastDeb: string;
begin
    CheckTrue(FH2gStep2.Equals(Sender), 'Teste Sender');
    lr.setall([etype, atext, Ref, dsubtype.toString]);
    lDebEv := lr.ToString;
    if Length(ExpResults) = 0 then
      begin
        setlength(FResult, length(FResult) + 1);
        Fresult[high(FResult)] := lr;
        exit;
      end;
    if (eType='ParserDebugMsg') then
      begin
        FlastDeb := lDebEv;
        if ((high(ExpResults) < FRCounter) or (ExpResults[FRCounter].eType<> eType))
          then exit;  // Ignore optional Element
      end;
    lLastDeb:= FlastDeb;
    CheckTrue(high(ExpResults) >= FRCounter, 'Result Exists[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].eType, eType, 'Teste eType[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].Data, aText, 'Teste aText[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].Ref, Ref, 'Teste Ref[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].SubType, dsubtype, 'Teste SubType[' +
        IntToStr(FRCounter) + '],' + FTestName);
    Inc(FRCounter);
end;

procedure TTesth2gStep2.TestStartIndiv(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
  ParserTestEvent(Sender, 'ParserStartIndiv', aText, Ref, dSubType);
end;

procedure TTesth2gStep2.AddExpResult(Data: array of variant);
begin
    setlength(ExpResults, high(ExpResults)+2);
    ExpResults[high(ExpResults)].SetAll(Data);
end;

procedure TTesth2gStep2.CreateExpResult(st: TStrings; out
  Expct: TResultTypeArray);
var
    i: integer;
begin
    if st.Count = 0 then
        setlength(Expct{%H-}, 0)
    else
        setlength(Expct, st.Count - 1);
    for i := 1 to st.Count - 1 do
        Expct[i - 1].SetAll(st[i].Split([#9]));
end;

procedure TTesth2gStep2.ExpResultToTStr(const Exp: array of TResultType;
  st: TStrings);
var
    le: TResultType;
begin
    st.Clear;
    st.append('eType'#9'Data'#9'Ref'#9'SubType');
    for le in Exp do
        st.append(le.toCsv(#9));
end;


procedure TTesth2gStep2.TestFile1(aFilename: String);
var
  CType: Longint;
  s,Line:String;
  sf: TFileStream;
begin
    Checktrue(FileExists(FDatapath + DirectorySeparator + aFilename), 'File Exists:'
    +FDatapath + DirectorySeparator+aFilename);
  sf := TFileStream.Create(FDatapath + DirectorySeparator+aFilename, fmOpenRead
    );
  try
    setlength(s, sf.Size);
    sf.ReadBuffer(s[1], sf.Size);

  finally
    FreeAndNil(sf);
  end;
  FFilename := aFilename;
  Finput.Text := s;
  FExpOutput.Text:= s;
  for Line in FInput do
    begin
      if (Line<>'') and TryStrToInt(Line[1],CType) then
        HtmlComputeOutput(Ctype,Line.Substring(3).Replace('\n',#10).Replace('\r',#13).Replace('\\','\'));
    end;
end;

const Test2ExpExt = '.IntExp';
      Test2ENewExt = '.IntNew';

procedure TTesth2gStep2.TestFile2(aFilename: String);
var
  CType: Longint;
  s,Line:String;
  sf: TFileStream;
  lRs: TStringList;
begin
  Checktrue(FileExists(FDatapath + DirectorySeparator + aFilename), 'File Exists:'
    +FDatapath + DirectorySeparator+aFilename);
  sf := TFileStream.Create(FDatapath + DirectorySeparator+aFilename, fmOpenRead
    );
  try
    setlength(s, sf.Size);
    sf.ReadBuffer(s[1], sf.Size);

  finally
    FreeAndNil(sf);
  end;
  FFilename := aFilename;
  Finput.Text := s;

     lRs := TStringList.Create;
    try
      if FileExists(ChangeFileExt(FDatapath + DirectorySeparator +aFileName, Test2ExpExt)) then
          lRs.LoadFromFile(ChangeFileExt(FDatapath + DirectorySeparator +aFileName, Test2ExpExt));
      CreateExpResult(lRs, ExpResults);
      FRCounter := 0;
      FH2gStep2.GNameHandler.LoadGNameList(FDataPath + DirectorySeparator + 'GNameFile.txt');
      FH2gStep2.GNameHandler.SaveGNameList(ChangeFileExt(FDatapath + DirectorySeparator + aFileName, '.Name.New'));
      FTestName := ExtractFileName(aFileName);

    for Line in FInput do
      begin
        if (Line<>'') and TryStrToInt(Line[1],CType) then
          FH2gStep2.ComputeOutput(Ctype,Line.Substring(3).Replace('\n',#10).Replace('\r',#13).Replace('\\','\'));
      end;

      CheckEquals(length(ExpResults), FRCounter, 'Counter');
    if not FileExists(ChangeFileExt(FDatapath + DirectorySeparator + aFileName, Test2ExpExt)) then
      begin
        ExpResultToTStr(FResult,lRs);
        SaveFile(@lRs.SaveToFile,ChangeFileExt(FDatapath + DirectorySeparator + aFileName, Test2ENewExt));
      end;
    finally
      FreeAndNil(lRs);
    end;
end;

const Test3ExpExt = '.EntExp';
      Test3ENewExt = '.EntNew';

procedure TTesth2gStep2.TestFile3(aFilename: String);
var
  s, sRef, sKat:String;
  sf: TFileStream;
  lRs: TStringList;
  InpResults: TResultTypeArray;
  lRes: TResultType;
  lp: Integer;
begin
  Checktrue(FileExists(FDatapath + DirectorySeparator + aFilename), 'File Exists:'
    +FDatapath + DirectorySeparator+aFilename);
  sf := TFileStream.Create(FDatapath + DirectorySeparator+aFilename, fmOpenRead
    );
  try
    setlength(s, sf.Size);
    sf.ReadBuffer(s[1], sf.Size);

  finally
    FreeAndNil(sf);
  end;
  FFilename := aFilename;
  Finput.Text := s;

     lRs := TStringList.Create;
    try
      if FileExists(ChangeFileExt(FDatapath + DirectorySeparator +aFileName, Test3ExpExt)) then
          lRs.LoadFromFile(ChangeFileExt(FDatapath + DirectorySeparator +aFileName, Test3ExpExt));
      CreateExpResult(lRs, ExpResults);
      FRCounter := 0;
      FH2gStep2.GNameHandler.LoadGNameList(FDataPath + DirectorySeparator + 'GNameFile.txt');
      FH2gStep2.GNameHandler.SaveGNameList(ChangeFileExt(FDatapath + DirectorySeparator + aFileName, '.Name.New2'));
      FTestName := ExtractFileName(aFileName);
//
    CreateExpResult(FInput, InpResults);

    for lRes in InpResults do
      begin
        if (lRes.eType<>'')  then
          begin
            lp:=lres.Data.LastIndexOf('.');
            sRef:=lres.Data.Substring(0,lp);
            sKat:=lres.Data.Substring(lp+1);
            FH2gStep2.ProcessGenData2(self,lres.eType.Substring(4),sRef,sKat,lres.Ref);
          end;
      end;

      CheckEquals(length(ExpResults), FRCounter, 'Counter');
    if not FileExists(ChangeFileExt(FDatapath + DirectorySeparator + aFileName, Test3ExpExt)) then
      begin
        ExpResultToTStr(FResult,lRs);
        SaveFile(@lRs.SaveToFile,ChangeFileExt(FDatapath + DirectorySeparator + aFileName, Test3ENewExt));
      end;
    finally
      FreeAndNil(lRs);
    end;
end;

procedure TTesth2gStep2.SetUp;
begin
  FInput := TStringList.Create;
  FExpOutput := TStringList.Create;
  FH2gStep2 := TH2gStep2.Create;
  FH2gStep2.GNameHandler.LoadGNameList(FDataPath + DirectorySeparator + 'GNameFile.txt');
  FH2gStep2.GNameHandler.SaveGNameList(FDataPath + DirectorySeparator + 'GNameFile.Nxt');

  FH2gStep2.onProcessData:=@TestProcessData;

  FH2gStep2.onStartIndiv:=@TestStartIndiv;
  FH2gStep2.onStartFamily:=@TestStartFamily;
     FH2gStep2.onFamilyType := @TestFamilyType;
    FH2gStep2.onFamilyData := @TestFamilyData;
    FH2gStep2.onFamilyDate := @TestFamilyDate;
    FH2gStep2.onFamilyPlace := @TestFamilyPlace;
    FH2gStep2.onFamilyIndiv := @TestFamilyIndiv;
    FH2gStep2.onIndiName := @TestIndiName;
    FH2gStep2.onIndiDate := @TestIndiDate;
    FH2gStep2.onIndiPlace := @TestIndiPlace;
    FH2gStep2.onIndiOccu := @TestIndiOccu;
    FH2gStep2.onIndiRel := @TestIndiRel;
    FH2gStep2.onIndiRef := @TestIndiRef;
    FH2gStep2.onIndiData := @TestIndiData;

   setlength(FResult,0);
   setlength(ExpResults,0);
  FActLine:= 0;
end;

procedure TTesth2gStep2.TearDown;
begin
   setlength(FResult,0);
   setlength(ExpResults,0);
   freeandnil(FH2gStep2);
   freeandnil(FExpOutput);
   freeandnil(FInput);
end;

procedure TTesth2gStep2.TestSetUp;
begin
  CheckNotNull(FInput,'Input is assigned');
  CheckNotNull(FExpOutput,'ExpOutput is assigned');
  CheckNotNull(FH2gStep2,'ExpOutput is assigned');
  CheckNotNull(FH2gStep2,'ExpOutput is assigned');
end;

procedure TTesth2gStep2.TestVieser_I5;

const CFilename = 'vieser\I5.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I12;
const CFilename = 'vieser\I12.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I23;
const CFilename = 'vieser\I23.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I31;
const CFilename = 'vieser\I31.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I42;
const CFilename = 'vieser\I42.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I50;
const CFilename = 'vieser\I50.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I61;
const CFilename = 'vieser\I61.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I80;
const CFilename = 'vieser\I80.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I134;
const CFilename = 'vieser\I134.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I255;
const CFilename = 'vieser\I255.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I5;
const CFilename = 'vieser\I5.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I12;
const CFilename = 'vieser\I12.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I23;
const CFilename = 'vieser\I23.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I31;
const CFilename = 'vieser\I31.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I42;
const CFilename = 'vieser\I42.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I50;
const CFilename = 'vieser\I50.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I61;
const CFilename = 'vieser\I61.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I80;
const CFilename = 'vieser\I80.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I134;
const CFilename = 'vieser\I134.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I255;
const CFilename = 'vieser\I255.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I5;
const CFilename = 'vieser\I5.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I12;
const CFilename = 'vieser\I12.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I23;
const CFilename = 'vieser\I23.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I31;
const CFilename = 'vieser\I31.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I42;
const CFilename = 'vieser\I42.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I50;
const CFilename = 'vieser\I50.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I61;
const CFilename = 'vieser\I61.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I80;
const CFilename = 'vieser\I80.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I134;
const CFilename = 'vieser\I134.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I255;
const CFilename = 'vieser\I255.IntExp';

begin
  TestFile3(CFilename);
end;

procedure TTesth2gStep2.TestVieser_I12577;
const CFilename = 'vieser\I12577.exp';

begin
  TestFile1(CFilename);
end;

procedure TTesth2gStep2.TestVieser2_I12577;
const CFilename = 'vieser\I12577.exp';

begin
  TestFile2(CFilename);
end;

procedure TTesth2gStep2.TestVieser3_I12577;
const CFilename = 'vieser\I12577'+Test2ExpExt;

begin
  TestFile3(CFilename);
end;

constructor TTesth2gStep2.Create;
var
  i: Integer;
begin
  inherited Create;
  FDatapath := 'Data';
   for i := 0 to 2 do
     if DirectoryExists(FDataPath) then
       Break
     else
       FDataPath:='..'+DirectorySeparator+FDataPath;
   FDataPath:=FDataPath+DirectorySeparator+'GenData';
end;

initialization

  RegisterTest(TTesth2gStep2);
end.

