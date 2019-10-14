unit cls_TestParseFBEntry;

{$mode objfpc}{$H+}


interface

uses
    Classes, SysUtils, FileUtil, fpcunit, testutils, testregistry, unt_FBParser,
    unt_TestFBData;

type
    TTestFBEntryParserBase = class(TTestCase)
    protected
        fParser: TFBEntryParser;
        FDataPath: string;
        FResult, ExpResults: array of TResultType;
        FRCounter: integer;
        FTestName: string;
        procedure SetUp; override;
        procedure TearDown; override;
        procedure TestOneFile(aFilename: String);
    private
        procedure FSFileFound(FileIterator: TFileIterator);
        procedure CreateExpResult(st: TStrings; out Expct: TResultTypeArray);
        procedure ExpResultToTStr(const Exp: array of TResultType; st: TStrings);
        procedure ParserError(Sender: TObject);
        procedure ParserStartFamily(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserFamilyDate(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserFamilyData(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserFamilyIndiv(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserFamilyPlace(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserFamilyType(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserIndiData(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserIndiDate(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserIndiName(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserIndiOccu(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserIndiPlace(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserIndiRef(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserIndiRel(Sender: TObject; aText, Ref: string; dsubtype: integer);
        procedure ParserTestEvent(Sender: TObject; eType, aText, Ref: string;
            dsubtype: integer);
    public
        constructor Create; override;
    end;

    { TTestFBEntryParser }
        TTestFBEntryParser = class(TTestFBEntryParserBase)
          procedure TestSetUp;
          procedure TestResult;
          procedure TestParseGC5065;
          procedure TestParseAK2421;
        end;


{ TTestFBEntryParser }
    TTestFBEntryParserAll = class(TTestFBEntryParserBase)
        procedure TestFiles;
    end;

    { TTestFBEntryParserGC }

    TTestFBEntryParserGC = class(TTestFBEntryParserBase)
        procedure TestFile03;
        procedure TestFileO0006;
        procedure TestFileO0011;
        procedure TestFileO0035;
        procedure TestFile45;
        procedure TestFile50;
        procedure TestFile51;
        procedure TestFile52;
        procedure TestFile53;
        procedure TestFile54;
        procedure TestFile63;
        procedure TestFileO0077;
        procedure TestFileO120;
        procedure TestFileO156;
        procedure TestFileO189;
        procedure TestFileO197;
        procedure TestFileO451;
        procedure TestFileO1304;
        procedure TestFileO1886;
        procedure TestFileO2201;
        procedure TestFileO2298;
        procedure TestFileO2578;
        procedure TestFileO2658;
        procedure TestFileO3135;
        procedure TestFileO3222;
        procedure TestFileO3503;
        procedure TestFileO3892;
        procedure TestFileO3899;
        procedure TestFileO4528;
        procedure TestFileO4551;
        procedure TestFileO6299;
        procedure TestFileO6302;
    end;

    TTestFBEntryParserAK = class(TTestFBEntryParserBase)
        procedure TestFileM0001;
        procedure TestFileM0002;
        procedure TestFileM0003;
        procedure TestFileM0004;
        procedure TestFileM0005;
        procedure TestFileM0006;
        procedure TestFileM0007;
        procedure TestFileM0008;
        procedure TestFileM0009;
        procedure TestFileM0409;
        procedure TestFileM0429;
        procedure TestFileM0443;
        procedure TestFileM0462;
        procedure TestFileM0470;
        procedure TestFileM0486;
     end;

implementation

uses LConvEncoding;

procedure TTestFBEntryParser.TestSetUp;
begin
    CheckNotNull(fParser);
end;

procedure TTestFBEntryParser.TestResult;
var
    lResult: TResultType;
begin
    lResult.SetAll(['', '', '', 6]);
    CheckEquals('(eType:'''';Data:'''';Ref:'''';SubType:6)', lResult.ToString,
        'lResult.Tostring');
    lResult.eType := 'eType';
    lResult.Data := 'Data';
    lResult.ref := 'Ref';
    lResult.SubType := 123;
    CheckEquals('(eType:''eType'';Data:''Data'';Ref:''Ref'';SubType:123)',
        lResult.ToString, 'lResult.Tostring');
    ExpResults := cResultTest;
    FRCounter := 0;
    ParserTestEvent(fparser, 'eType', 'Data', 'Ref', 123);
    CheckEquals(1, FRCounter, 'FRcounter');
    ParserStartFamily(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(2, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'AAA', 'BBB', 2]);
    ParserFamilyType(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(3, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'CCC', 'DDD', 3]);
    ParserFamilyDate(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(4, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'EEE', 'FFF', 4]);
    ParserFamilyIndiv(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(5, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'GGG', 'HHH', 5]);
    ParserFamilyPlace(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(6, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'III', 'JJJ', 6]);
    ParserIndiName(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(7, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'KKK', 'LLL', 7]);
    ParserIndiDate(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(8, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'MMM', 'NNN', 8]);
    ParserIndiPlace(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(9, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'OOO', 'PPP', 9]);
    ParserIndiRef(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(10, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'QQQ', 'RRR', 10]);
    ParserIndiRel(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(11, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'SSS', 'TTT', 11]);
    ParserIndiOccu(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(12, FRCounter, 'FRcounter');
    lResult.SetAll(['', 'UUU', 'VVV', 12]);
    ParserIndiData(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(13, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestParseGC5065;
begin
    ExpResults := cResultEntryGC5065;
    FRCounter := 0;
    fParser.Feed(cTestEntryGC5065);
    CheckEquals(length(ExpResults), FRCounter, 'Counter');
end;

procedure TTestFBEntryParser.TestParseAK2421;
begin
    ExpResults := cResultEntryAK2421;
    FRCounter := 0;
    fParser.Feed(cTestEntryAK2421);
    CheckEquals(length(ExpResults), FRCounter, 'Counter');
end;


procedure TTestFBEntryParserBase.ParserStartFamily(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserStartFamily', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.FSFileFound(FileIterator: TFileIterator);
var
    lSt, lRs: TStrings;
begin
    lst := TStringList.Create;
    lRs := TStringList.Create;
      try
        setlength(FResult, 0);
        lSt.LoadFromFile(FileIterator.FileName);
        if FileExists(ChangeFileExt(FileIterator.FileName, '.entExp')) then
            lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName, '.entExp'));
        CreateExpResult(lRs, ExpResults);
        FRCounter := 0;
        fParser.LoadGNameList(FDataPath + DirectorySeparator + 'GNameFile.txt');
        fparser.SaveGNameList(ChangeFileExt(FileIterator.FileName, '.Name.New'));
        FTestName := ExtractFileName(FileIterator.FileName);
        fParser.Feed(lSt.Text);
        CheckEquals(length(ExpResults), FRCounter, 'Counter');
        if not FileExists(ChangeFileExt(FileIterator.FileName, '.entExp')) then
          begin
            if FileExists(ChangeFileExt(FileIterator.FileName, '.entNew')) then
                DeleteFile(ChangeFileExt(FileIterator.FileName, '.entNew'));
            ExpResultToTStr(FResult, lRs);
            lRs.SaveToFile(ChangeFileExt(FileIterator.FileName, '.entNew'));
          end;
      finally
        FreeAndNil(lRs);
        FreeAndNil(lSt);
      end;
end;

procedure TTestFBEntryParserBase.CreateExpResult(st: TStrings; out Expct: TResultTypeArray);
var
    i: integer;
begin
    if st.Count = 0 then
        setlength(Expct, 0)
    else
        setlength(Expct, st.Count - 1);
    for i := 1 to st.Count - 1 do
        Expct[i - 1].SetAll(st[i].Split([#9]));
end;

procedure TTestFBEntryParserBase.ExpResultToTStr(const Exp: array of TResultType;
    st: TStrings);
var
    le: TResultType;
begin
    st.Clear;
    st.append('eType'#9'Data'#9'Ref'#9'SubType');
    for le in Exp do
        st.append(le.toCsv(#9));
end;

procedure TTestFBEntryParserBase.ParserError(Sender: TObject);
begin
    ParserTestEvent(Sender, 'ParserError!', TFBEntryParser(Sender).LastErr, '', TFBEntryParser(Sender).LastMode);
end;

procedure TTestFBEntryParserBase.ParserFamilyType(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyType', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiData(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserIndiData', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiDate(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserIndiDate', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiName(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserIndiName', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiOccu(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserIndiOccu', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiPlace(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserIndiPlace', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiRef(Sender: TObject; aText, Ref: string;
    dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserIndiRef', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiRel(Sender: TObject; aText, Ref: string;
    dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserIndiRel', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserTestEvent(Sender: TObject;
    eType, aText, Ref: string; dsubtype: integer);
var
    lr: TResultType;
    lDebEv: string;
begin
    CheckTrue(fParser.Equals(Sender), 'Teste Sender');
    lr.setall([etype, atext, Ref, dsubtype]);
    lDebEv := lr.ToString;
    if Length(ExpResults) = 0 then
      begin
        setlength(FResult, length(FResult) + 1);
        Fresult[high(FResult)] := lr;
        exit;
      end;
    CheckTrue(high(ExpResults) >= FRCounter, 'Result Exists[' + IntToStr(
        FRCounter) + '],' + FTestName);
    checkTrue(ExpResults[FRCounter].eType = eType, 'Teste eType[' + IntToStr(
        FRCounter) + ']=' + eType + ',' + FTestName);
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

procedure TTestFBEntryParserBase.TestOneFile(aFilename:String);
var
  lFileSearcher: TFileSearcher;
begin
  lFileSearcher := TFileSearcher.Create;
       try
         lFileSearcher.OnFileFound := @FSFileFound;
         lFileSearcher.Search(FDataPath, aFilename, False, False);
       finally
         FreeAndNil(lFileSearcher);
       end;
end;

constructor TTestFBEntryParserBase.Create;
var
    i: integer;
begin
    inherited Create;
    FDataPath := 'Data';
    for i := 0 to 2 do
        if DirectoryExists(FDataPath) then
            break
        else
            FDataPath := '..' + DirectorySeparator + FDataPath;
    if not DirectoryExists(FDataPath) then
        FDataPath := GetAppConfigDir(True)
    else
        FDataPath := FDataPath + DirectorySeparator + 'ParseFB';
    if not DirectoryExists(FDataPath) then
        ForceDirectories(FDataPath);
end;

procedure TTestFBEntryParserBase.ParserFamilyDate(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyDate', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserFamilyData(Sender: TObject; aText,
  Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyData', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserFamilyIndiv(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyIndiv', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserFamilyPlace(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyPlace', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.SetUp;
begin
    fParser := TFBEntryParser.Create;
    fParser.LoadGNameList(FDataPath + DirectorySeparator + 'GNameFile.txt');
    fParser.SaveGNameList(FDataPath + DirectorySeparator + 'GNameFile.Nxt');
    fParser.onStartFamily := @ParserStartFamily;
    fParser.onFamilyType := @ParserFamilyType;
    fParser.onFamilyData := @ParserFamilyData;
    fParser.onFamilyDate := @ParserFamilyDate;
    fParser.onFamilyPlace := @ParserFamilyPlace;
    fParser.onFamilyIndiv := @ParserFamilyIndiv;
    fParser.onIndiName := @ParserIndiName;
    fParser.onIndiDate := @ParserIndiDate;
    fParser.onIndiPlace := @ParserIndiPlace;
    fParser.onIndiOccu := @ParserIndiOccu;
    fParser.onIndiRel := @ParserIndiRel;
    fParser.onIndiRef := @ParserIndiRef;
    fParser.onIndiData := @ParserIndiData;
    fParser.onParseError:=@ParserError;
    FTestName := '';
end;

procedure TTestFBEntryParserBase.TearDown;
begin
    FreeAndNil(fParser);
    setlength(FResult, 0);
end;



procedure TTestFBEntryParserAll.TestFiles;

begin
    TestOneFile('*.entTxt');
end;


procedure TTestFBEntryParserGC.TestFile03;
const
    cFilename = 'EntryGC0003.entTxt';

begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFileO0006;
begin
    TestOneFile('OsBObr0006.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO0011;
begin
    TestOneFile('OsBObr0011.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO0035;
begin
    TestOneFile('OsBObr0035.entTxt');
end;

procedure TTestFBEntryParserGC.TestFile45;
const
    cFilename = 'EntryGC0045.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFile50;
const
    cFilename = 'EntryGC0050.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFile51;
const
    cFilename = 'EntryGC0051.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFile52;
const
    cFilename = 'EntryGC0052.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFile53;
const
    cFilename = 'EntryGC0053.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFile54;
const
    cFilename = 'EntryGC0054.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFile63;
const
    cFilename = 'EntryGC0063.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFileO0077;
begin
    TestOneFile('OsBObr0077.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO120;
const
    cFilename = 'OsBObr0120.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFileO156;
const
    cFilename = 'OsBObr0156.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFileO189;
const
    cFilename = 'OsBObr0189.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFileO197;
const
    cFilename = 'OsBObr0197.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFileO451;
begin
    TestOneFile('OsBObr0451.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO1304;
begin
    TestOneFile('OsBObr1304.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO1886;
begin
    TestOneFile('OsBObr1886.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO2201;
begin
    TestOneFile('OsBObr2201.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO2298;
begin
    TestOneFile('OsBObr2298.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO2578;
begin
    TestOneFile('OsBObr2578.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO2658;
begin
    TestOneFile('OsBObr2658.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO3135;
begin
    TestOneFile('OsBObr3135.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO3222;
begin
    TestOneFile('OsBObr3222.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO3503;
const
    cFilename = 'OsBObr3503.entTxt';
begin
    TestOneFile(cFilename);
end;

procedure TTestFBEntryParserGC.TestFileO3892;
begin
    TestOneFile('OsBObr3892.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO3899;
begin
    TestOneFile('OsBObr3899.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO4528;
begin
    TestOneFile('OsBObr4528.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO4551;
begin
    TestOneFile('OsBObr4551.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO6299;
begin
    TestOneFile('OsBObr6299.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO6302;
begin
    TestOneFile('OsBObr6302.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0001;
begin
    TestOneFile('OsBM0001.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0002;
begin
    TestOneFile('OsBM0002.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0003;
begin
    TestOneFile('OsBM0003.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0004;
begin
    TestOneFile('OsBM0004.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0005;
begin
    TestOneFile('OsBM0005.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0006;
begin
    TestOneFile('OsBM0006.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0007;
begin
    TestOneFile('OsBM0007.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0008;
begin
    TestOneFile('OsBM0008.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0009;
begin
    TestOneFile('OsBM0009.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0409;
begin
    TestOneFile('OsBM0409.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0429;
begin
    TestOneFile('OsBM0429.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0443;
begin
    TestOneFile('OsBM0443.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0462;
begin
    TestOneFile('OsBM0462.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0470;
begin
    TestOneFile('OsBM0470.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0486;
begin
    TestOneFile('OsBM0486.entTxt');
end;


initialization

    RegisterTest(TTestFBEntryParser);
    RegisterTest(TTestFBEntryParserAK);
    RegisterTest(TTestFBEntryParserGC);
    RegisterTest(TTestFBEntryParserAll);

end.
