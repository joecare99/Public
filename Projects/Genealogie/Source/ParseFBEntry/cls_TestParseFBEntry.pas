unit cls_TestParseFBEntry;

{$mode objfpc}{$H+}


interface

uses
    Classes, SysUtils, FileUtil, fpcunit, testregistry, unt_FBParser,
    unt_TestFBData;

type
    { TTestFBEntryParserBase }

    TTestFBEntryParserBase = class(TTestCase)
    protected
        fParser   :TFBEntryParser;
        FDataPath :string;
        FResult, ExpResults :array of TResultType;
        FRCounter :integer;
        FTestName :string;
        procedure SetUp; override;
        procedure TearDown; override;
        procedure TestOneFile(aFilename :string; ff :TFileFoundEvent = nil);
    private
        FlastDeb :string;
        procedure AddExpResult(Data :array of variant);
        procedure FSFileFound(FileIterator :TFileIterator); virtual;
        procedure CreateExpResult(st :TStrings; out Expct :TResultTypeArray);
        procedure ExpResultToTStr(const Exp :array of TResultType; st :TStrings);
        procedure ParserError(Sender :TObject);
        procedure ParserMessage(Sender :TObject; aType :TEventType;
            aText :string; Ref :string; aMode :integer);
        procedure ParserStartFamily(Sender :TObject; aText, Ref :string;
            dsubtype :integer);
        procedure ParserFamilyDate(Sender :TObject; aText, Ref :string;
            dsubtype :integer);
        procedure ParserFamilyData(Sender :TObject; aText, Ref :string;
            dsubtype :integer);
        procedure ParserFamilyIndiv(Sender :TObject; aText, Ref :string;
            dsubtype :integer);
        procedure ParserFamilyPlace(Sender :TObject; aText, Ref :string;
            dsubtype :integer);
        procedure ParserFamilyType(Sender :TObject; aText, Ref :string;
            dsubtype :integer);
        procedure ParserIndiData(Sender :TObject; aText, Ref :string; dsubtype :integer);
        procedure ParserIndiDate(Sender :TObject; aText, Ref :string; dsubtype :integer);
        procedure ParserIndiName(Sender :TObject; aText, Ref :string; dsubtype :integer);
        procedure ParserIndiOccu(Sender :TObject; aText, Ref :string; dsubtype :integer);
        procedure ParserIndiPlace(Sender :TObject; aText, Ref :string;
            dsubtype :integer);
        procedure ParserIndiRef(Sender :TObject; aText, Ref :string; dsubtype :integer);
        procedure ParserIndiRel(Sender :TObject; aText, Ref :string; dsubtype :integer);
        procedure ParserTestEvent(Sender :TObject; eType, aText, Ref :string;
            dsubtype :integer);
    public
        constructor Create; override;
    end;

    { TTestFBEntryParser }
    TTestFBEntryParser = class(TTestFBEntryParserBase)
        procedure TestSetUp;
        procedure TestResult;
        procedure TestParseGC5065;
        procedure TestParseAK2421;
        procedure TestHandleAKPersonEntry;
        procedure TestHandleAKPersonEntry_55;
        procedure TestHandleAKPersonEntry_56;

        procedure TestHandleNonPersonEntry;
        procedure TestHandleNonPersonEntry_occ;
        procedure TestHandleNonPersonEntry_4;
        procedure TestHandleNonPersonEntry_4_2;
        procedure TestHandleNonPersonEntry_5;
        procedure TestHandleNonPersonEntry_6;
        procedure TestHandleNonPersonEntry_Birth_Plac2;
        procedure TestHandleNonPersonEntry_Birth_Plac3;
        procedure TestHandleNonPersonEntry_Birth_Plac4;
        procedure TestHandleNonPersonEntry_Res;
        procedure TestHandleNonPersonEntry_div;
        procedure TestHandleNonPersonEntry_marr;
        procedure TestHandleNonPersonEntry_57;
        procedure TestHandleNonPersonEntry_Gef;

        procedure TestHandleFamilyFact_Str;
        procedure TestHandleFamilyFact_Div;
        procedure TestHandleFamilyFact_emig;
        procedure TestHandleFamilyFact_marr1;
        procedure TestHandleFamilyFact_marr2;

        procedure TestGetEntryType;
        procedure TestGetEntryType_Rel;
        procedure TestGuessSexOfGivnName;
        procedure TestHandleGCDateEntry;
        procedure TesttestEntry;
        procedure TesttestEntry2;
        procedure TestTestFor;
        procedure TestTestFor2;
        procedure TestTestFor3;
        procedure TestParseAdditional;
        procedure TestTestReferenz;
        procedure TestIsValidDate;
        procedure TestIsValidPlace;
    private
    end;


    { TTestFBEntryParser }

    { TTestFBEntryParserAll }

    TTestFBEntryParserAll = class(TTestFBEntryParserBase)
    public
        constructor Create; override;
        destructor Destroy; override;
    protected
        FChildren :array of TTestcase;
        procedure FSAddFound(FileIterator :TFileIterator);
    public
        procedure FSFileFound(FileIterator :TFileIterator); override;

        function GetChildTestCount :integer; override;
        function GetChildTest(AIndex :integer) :TTest; override;
    published
        procedure TestFiles;
    end;

    { TChildTest }

    TChildTest = class(TTestCase)
    public
        constructor Create(aParent :TTestFBEntryParserAll; aTestFile :string); reintroduce;
    private
        fParent   :TTestFBEntryParserAll;
        FTestFile :string;
    protected
        procedure RunTest; override;
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
        procedure TestFileO0338;
        procedure TestFileO0451;
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
    private
    end;

    { TTestFBEntryParserAK }

    TTestFBEntryParserAK = class(TTestFBEntryParserBase)
    protected
        procedure SetUp; override;
    published
        procedure TestFileM0001;
        procedure TestFileM0002;
        procedure TestFileM0003;
        procedure TestFileM0004;
        procedure TestFileM0005;
        procedure TestFileM0006;
        procedure TestFileM0007;
        procedure TestFileM0008;
        procedure TestFileM0009;
        procedure TestFileM0011;
        procedure TestFileM0020;
        procedure TestFileM0026;
        procedure TestFileM0030;
        procedure TestFileM0037;
        procedure TestFileM0054;
        procedure TestFileM0061;
        procedure TestFileM0119;
        procedure TestFileM0193;
        procedure TestFileM0211;
        procedure TestFileM0263;
        procedure TestFileM0330;
        procedure TestFileM0337;
        procedure TestFileM0405;
        procedure TestFileM0407;
        procedure TestFileM0409;
        procedure TestFileM0411;
        procedure TestFileM0424;
        procedure TestFileM0427;
        procedure TestFileM0429;
        procedure TestFileM0443;
        procedure TestFileM0462;
        procedure TestFileM0470;
        procedure TestFileM0476;
        procedure TestFileM0485;
        procedure TestFileM0486;
        procedure TestFileM0549;
        procedure TestFileM0746;
        procedure TestFileM0832;
        procedure TestFileM0854;
        procedure TestFileM0889;
        procedure TestFileM0918;
        procedure TestFileM1026;
        procedure TestFileM1078;
        procedure TestFileM1093;
        procedure TestFileM1138;
        procedure TestFileM1149;
        procedure TestFileM1220;
        procedure TestFileM1221;
        procedure TestFileM1227;
        procedure TestFileM1240;
        procedure TestFileM1242;
        procedure TestFileM1251;
        procedure TestFileM1252;
        procedure TestFileM1262;
        procedure TestFileM1268;
        procedure TestFileM1274;
        procedure TestFileM1276;
        procedure TestFileM1319;
        procedure TestFileM1321;
        procedure TestFileM1353;
        procedure TestFileM1353a;
        procedure TestFileM1354;
        procedure TestFileM1387;
        procedure TestFileM1436;
        procedure TestFileM2420;
        procedure TestFileM2421;
    private
    end;

implementation

uses LConvEncoding, unt_IGenBase2;

{ TChildTest }

constructor TChildTest.Create(aParent :TTestFBEntryParserAll; aTestFile :string);
begin
    fParent   := aParent;
    FTestFile := aTestFile;
    TestName  := 'Test_' + ExtractFileNameWithoutExt(FTestFile);
end;

procedure TChildTest.RunTest;
begin
    if assigned(fParent) then
      begin
        fParent.SetUp;
          try
            fParent.TestOneFile(FTestFile);
          finally
            fParent.TearDown;
          end;
      end;
end;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

procedure TTestFBEntryParser.TestSetUp;
begin
    CheckNotNull(fParser);
end;

procedure TTestFBEntryParser.TestResult;
var
    lResult :TResultType;
begin
    lResult.SetAll([variant(''), '', '', 6]);
    CheckEquals('(eType:'''';Data:'''';Ref:'''';SubType:6)', lResult.ToString,
        'lResult.Tostring');
    lResult.eType   := 'eType';
    lResult.Data    := 'Data';
    lResult.ref     := 'Ref';
    lResult.SubType := 123;
    CheckEquals('(eType:''eType'';Data:''Data'';Ref:''Ref'';SubType:123)',
        lResult.ToString, 'lResult.Tostring');
    ExpResults := cResultTest;
    FRCounter  := 0;
    ParserTestEvent(fparser, 'eType', 'Data', 'Ref', 123);
    CheckEquals(1, FRCounter, 'FRcounter');
    ParserStartFamily(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(2, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'AAA', 'BBB', 2]);
    ParserFamilyType(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(3, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'CCC', 'DDD', 3]);
    ParserFamilyDate(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(4, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'EEE', 'FFF', 4]);
    ParserFamilyIndiv(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(5, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'GGG', 'HHH', 5]);
    ParserFamilyPlace(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(6, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'III', 'JJJ', 6]);
    ParserIndiName(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(7, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'KKK', 'LLL', 7]);
    ParserIndiDate(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(8, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'MMM', 'NNN', 8]);
    ParserIndiPlace(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(9, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'OOO', 'PPP', 9]);
    ParserIndiRef(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(10, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'QQQ', 'RRR', 10]);
    ParserIndiRel(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(11, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'SSS', 'TTT', 11]);
    ParserIndiOccu(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(12, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'UUU', 'VVV', 12]);
    ParserIndiData(fParser, lResult.Data, lResult.Ref, lResult.SubType);
    CheckEquals(13, FRCounter, 'FRcounter');
    lResult.SetAll([variant(''), 'WWW', 'XXX', 13]);
    {$ifdef debug}
    fparser.DebugSetMsg('WWW','XXX',13);
    {$else}
      {$warning 'This works only in DEBUG-Mode'}
    {$endif}
    ParserError(fParser);
    CheckEquals(14, FRCounter, 'FRcounter');
    ParserMessage(fParser, etWarning, 'YYY', 'YYY2', 14);
    CheckEquals(15, FRCounter, 'FRcounter');
    ParserMessage(fParser, etDebug, 'ZZZ', 'ZZZ2', 15);
    CheckEquals(16, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestParseGC5065;
begin
    ExpResults := cResultEntryGC5065;
    FRCounter  := 0;
    fParser.Feed(cTestEntryGC5065);
    CheckEquals(length(ExpResults), FRCounter, 'Counter');
end;

procedure TTestFBEntryParser.TestParseAK2421;
begin
    ExpResults := cResultEntryAK2421;
    FRCounter  := 0;
    fParser.DefaultPlace := 'Meißenheim';
    fParser.Feed(cTestEntryAK2421);
    CheckEquals(length(ExpResults), FRCounter, 'Counter');
end;

procedure TTestFBEntryParser.TesttestEntry;

type
    TTestData = record
        Entry   :string;
        Test    :string;
        ExpData :string;
        ExpResult:Boolean;
      end;

const
    TestData :array[0..9] of TTestData =
        ((Entry :'* 01.02.'; Test :'*' ; ExpData :'01.02.';ExpResult :True),
        (Entry :'* in Bern'; Test :'*' ; ExpData :'in Bern'; ExpResult :True),
        (Entry :' * nach Amerika'; Test :'*' ; ExpData :''; ExpResult :False),
        (Entry :'* in Bern'; Test :'*' ; ExpData :'in Bern'; ExpResult :True),
        (Entry :'* Willstä'; Test :'*' ; ExpData :'Willstä'; ExpResult :True),
        (Entry :'** 1.1.19'; Test :'*' ; ExpData :''; ExpResult :False),
        (Entry :'†19'; Test :'†' ; ExpData :'19'; ExpResult :True),
        (Entry :'*W'; Test :'*' ; ExpData :'W'; ExpResult :True),
        (Entry :'*1'; Test :'*' ; ExpData :'1'; ExpResult :True),
        (Entry :'*'; Test :'*' ; ExpData :''; ExpResult :True));

var
    i :integer;
    lDate, lData :string;
begin
    for i := 0 to high(TestData) do
      begin
        CheckEquals(TestData[i].ExpResult, fparser.TestEntry(
            TestData[i].Entry, TestData[i].Test, lDate), 'Test[' + IntToStr(i) + ']: ' + TestData[i].Entry);
        CheckEquals(TestData[i].ExpData, lDate, 'Test[' + IntToStr(i) +
            '].Date: ' + TestData[i].Entry);
      end;
end;

procedure TTestFBEntryParser.TesttestEntry2;
type
    TTestData = record
        Entry   :string;
        Test    :array of string;
        ExpData :string;
        ExpResult:Boolean;
      end;

const
    TestData :array[0..20] of TTestData =
        ((Entry :'* 01.02.'; Test :('*') ; ExpData :'01.02.';ExpResult :True),
        (Entry :'* in Bern'; Test :('+','*') ; ExpData :'in Bern'; ExpResult :True),
        (Entry :' * nach Amerika'; Test :('*') ; ExpData :''; ExpResult :False),
        (Entry :'* in Bern'; Test :('#','*') ; ExpData :'in Bern'; ExpResult :True),
        (Entry :'* Willstä'; Test :('~','*') ; ExpData :'Willstä'; ExpResult :True),
        (Entry :'** 1.1.19'; Test :('!!','*') ; ExpData :''; ExpResult :False),
        (Entry :'†19'; Test :('†','+') ; ExpData :'19'; ExpResult :True),
        (Entry :'*W'; Test :('?','*') ; ExpData :'W'; ExpResult :True),
        (Entry :'*1'; Test :('*') ; ExpData :'1'; ExpResult :True),
        (Entry :'*'; Test :('?','*') ; ExpData :''; ExpResult :True),
        (Entry :'o 01.02.'; Test :('o') ; ExpData :'01.02.';ExpResult :True),
        (Entry :'o in Bern'; Test :('a','o') ; ExpData :'in Bern'; ExpResult :True),
        (Entry :' o nach Amerika'; Test :('o') ; ExpData :''; ExpResult :False),
        (Entry :'A in Bern'; Test :('#','A') ; ExpData :'in Bern'; ExpResult :True),
        (Entry :'A Willstä'; Test :('~','A') ; ExpData :'Willstä'; ExpResult :True),
        (Entry :'Ae 1.1.19'; Test :('e','A') ; ExpData :''; ExpResult :False),
        (Entry :'T19'; Test :('T','t') ; ExpData :''; ExpResult :False),
        (Entry :'#W'; Test :('?','#') ; ExpData :'W'; ExpResult :True),
        (Entry :'1 1'; Test :('1') ; ExpData :'1'; ExpResult :True),
        (Entry :'11'; Test :('1') ; ExpData :''; ExpResult :False),
        (Entry :'1'; Test :('?','1') ; ExpData :''; ExpResult :True));

var
    i :integer;
    lDate, lData :string;
begin
    for i := 0 to high(TestData) do
      begin
        CheckEquals(TestData[i].ExpResult, fparser.TestEntry(
            TestData[i].Entry, TestData[i].Test, lDate), 'Test[' + IntToStr(i) + ']: ' + TestData[i].Entry);
        CheckEquals(TestData[i].ExpData, lDate, 'Test[' + IntToStr(i) +
            '].Date: ' + TestData[i].Entry);
      end;
end;

procedure TTestFBEntryParser.TestTestFor;

const
    cTest :array[0..10] of string =
        ('111', '11', '121', '212', '21', '2', '1', '3456', '456', '345', 'Test');
    cTStr = '1 11 111 1212 3456 test';
var
    lFnd :integer;

begin
    CheckEquals(True, fParser.Testfor(cTStr, 1, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(6, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(False, fParser.Testfor(cTStr, 2, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(-1, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 3, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(1, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 4, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(6, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(False, fParser.Testfor(cTStr, 5, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(-1, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 6, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(0, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 7, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(1, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 8, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(6, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(False, fParser.Testfor(cTStr, 9, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(-1, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 10, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(2, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 11, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(3, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 12, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(6, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 13, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(5, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(False, fParser.Testfor(cTStr, 14, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(-1, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 15, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(7, lFnd, 'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor(cTStr, 16, cTest, lFnd), 'an Stelle nicht gefunden');
    CheckEquals(8, lFnd, 'an Stelle nicht gefunden');

end;

procedure TTestFBEntryParser.TestTestFor2;

var
    lFnd :integer;
begin
    CheckEquals(True, fParser.Testfor('123 ', 1, ['123', '23', '3']),
        'an Stelle nicht gefunden');
    CheckEquals(True, fParser.Testfor('123 ', 2, ['123', '23', '3']),
        'an Stelle nicht gefunden');
    CheckEquals(True, fParser.Testfor('123 ', 3, ['123', '23', '3']),
        'an Stelle nicht gefunden');

    CheckEquals(False, fParser.Testfor('123 ', 1, ['124', '23', '3']),
        'an Stelle nicht gefunden');
    CheckEquals(False, fParser.Testfor('123 ', 2, ['123', '33', '3']),
        'an Stelle nicht gefunden');
    CheckEquals(False, fParser.Testfor('123', 3, ['123', '23', '1']),
        'an Stelle nicht gefunden');

    CheckEquals(True, fParser.Testfor('über lößt, daß es regnet', 1,
        ['daß', 'über', 'lößt'], lFnd), 'an Stelle nicht gefunden');
    CheckEquals(1, lFnd, 'über');
    CheckEquals(True, fParser.Testfor('über lößt, daß es regnet', 7,
        ['daß', 'über', 'lößt'], lFnd), 'an Stelle nicht gefunden');
    CheckEquals(2, lFnd, 'lößt');
    CheckEquals(True, fParser.Testfor('über lößt, daß es regnet',
        15, ['daß', 'über', 'lößt'], lFnd), 'an Stelle nicht gefunden');
    CheckEquals(0, lFnd, 'daß');

end;

procedure TTestFBEntryParser.TestTestFor3;

begin
    CheckEquals(True, fParser.Testfor('über lößt, daß es regnet', 1, 'über'),
        'an Stelle nicht gefunden');
    CheckEquals(True, fParser.Testfor('über lößt, daß es regnet', 7, 'lößt'),
        'an Stelle nicht gefunden');
    CheckEquals(True, fParser.Testfor('über lößt, daß es regnet', 15, 'daß'),
        'an Stelle nicht gefunden');

    CheckEquals(False, fParser.Testfor('über lößt, daß es regnet', 3, 'über'),
        'an Stelle nicht gefunden');
    CheckEquals(False, fParser.Testfor('über lößt, daß es regnet', 6, 'lößt'),
        'an Stelle nicht gefunden');
    CheckEquals(False, fParser.Testfor('über lößt, daß es regnet', 13, 'daß'),
        'an Stelle nicht gefunden');

    CheckEquals(False, fParser.Testfor('über lößt, daß es regnet', 1, 'lößt'),
        'an Stelle nicht gefunden');
    CheckEquals(False, fParser.Testfor('über lößt, daß es regnet', 7, 'daß'),
        'an Stelle nicht gefunden');
    CheckEquals(False, fParser.Testfor('über lößt, daß es regnet', 15, 'über'),
        'an Stelle nicht gefunden');

    CheckEquals(False, fParser.Testfor('über lößt, daß es regnet', 7, 'lÖßt'),
        'an Stelle nicht gefunden');
    CheckEquals(False, fParser.Testfor('über lößt, daß es regnet', 15, 'dAß'),
        'an Stelle nicht gefunden');
    CheckEquals(False, fParser.Testfor('über lößt, daß es regnet', 1, 'übeR'),
        'an Stelle nicht gefunden');
end;

procedure TTestFBEntryParser.TestParseAdditional;
var
    Offset  :int64;
    lOutput :string;
begin
    Offset := 1;
    CheckTrue(fParser.ParseAdditional('(Dies ist ein Test)', Offset, lOutput),
        '(Dies ist ein Test)');
    CheckEquals('Dies ist ein Test', lOutput);
    CheckEquals(19, Offset, 'Offset: Dies ist ein Test');

    AddExpResult(['ParserError!', 'Misspelled additional Entry', '', 0]);
    Offset := 1;
    CheckTrue(fParser.ParseAdditional('(Dies ist ein Fehler', Offset, lOutput),
        '(Dies ist ein Fehler');
    CheckEquals('Dies ist ein Fehler', lOutput);
    CheckEquals(21, Offset, 'Offset: Dies ist ein Fehler');

    Offset := 1;
    CheckTrue(fParser.ParseAdditional('(an den Folgen einer Granatsplitterverwundung' +
        ' am 10.4.1945 daheim im Keller bei einem Beschuß)', Offset, lOutput), 'Dies ist OK');
    CheckEquals(95, Offset, 'Offset: an den Folgen einer ...');
    CheckEquals('an den Folgen einer Granatsplitterverwundung' +
        ' am 10.4.1945 daheim im Keller bei einem Beschuß', lOutput);

    Offset := 1;
    CheckTrue(fParser.ParseAdditional('("an den Folgen einer Granatsplitterverwundung' +
        ' am 10.4.1945 daheim im Keller bei einem Beschuß, an den Folgen einer' +
        ' Granatsplitterverwundung am 10.4.1945 daheim im Keller bei einem Beschuß,' +
        ' an den Folgen einer Granatsplitterverwundung am 10.4.1945 daheim im Keller' +
        ' bei einem Beschuß, an den Folgen einer Granatsplitterverwundung am 10.4.1945' +
        ' daheim im Keller bei einem Beschuß.")', Offset, lOutput), 'Dies ist OK');
    CheckEquals(383, Offset, 'Offset: Dies ist ein Fehler');
    CheckEquals('"an den Folgen einer Granatsplitterverwundung' +
        ' am 10.4.1945 daheim im Keller bei einem Beschuß, an den Folgen einer' +
        ' Granatsplitterverwundung am 10.4.1945 daheim im Keller bei einem Beschuß,' +
        ' an den Folgen einer Granatsplitterverwundung am 10.4.1945 daheim im Keller' +
        ' bei einem Beschuß, an den Folgen einer Granatsplitterverwundung am 10.4.1945' +
        ' daheim im Keller bei einem Beschuß."', lOutput);

end;

procedure TTestFBEntryParser.TestTestReferenz;
begin
    CheckTrue(fParser.TestReferenz('1234'), '1234 ist gültige Referenz');
    CheckTrue(fParser.TestReferenz('1'), '1 ist gültige Referenz');
    CheckTrue(fParser.TestReferenz('2a'), '2a ist gültige Referenz');
    CheckFalse(fParser.TestReferenz('l234'), 'l234 ist keine gültige Referenz');
    CheckFalse(fParser.TestReferenz('1O14'), '1O14 ist keine gültige Referenz');
    Checkfalse(fParser.TestReferenz('1234d'), '1234d ist keine gültige Referenz');
    Checkfalse(fParser.TestReferenz('123a4'), '123a4 ist keine gültige Referenz');
end;

procedure TTestFBEntryParser.TestIsValidDate;

type
    TTestData = record
        Date  :string;
        valid :boolean;
      end;

const
    TestData :array[0..1] of TTestData =
        ((Date :'1.1.1980'; Valid :True),
        (Date :'Aug. 1980'; Valid :True));
var
    i :integer;

begin
    CheckEquals(TestData[0].valid, fParser.IsValidDate(TestData[0].Date),
        TestData[0].Date + ' ist ' + booltostr(TestData[0].valid, '', 'un') + 'gültiges Datum');
    for i := 0 to high(TestData) do
        CheckEquals(TestData[i].valid, fParser.IsValidDate(TestData[i].Date),
            TestData[i].Date + ' ist ' + booltostr(TestData[i].valid, '', 'un') + 'gültiges Datum');
end;

procedure TTestFBEntryParser.TestIsValidPlace;
type
    TTestData = record
        Place :string;
        valid :boolean;
      end;

const
    TestData :array[0..2] of TTestData =
        ((Place :'Rot'; Valid :True),
        (Place :'Plobsheim/Elsass'; Valid :True),
        (Place :'der Wäschefabrik'; Valid :False));
var
    i :integer;

begin
    CheckEquals(TestData[0].valid, fParser.IsValidPlace(TestData[0].Place),
        TestData[0].Place + ' ist ' + booltostr(TestData[0].valid, '', 'un') + 'gültiger Platz');
    CheckEquals(TestData[1].valid, fParser.IsValidPlace(TestData[1].Place),
        TestData[1].Place + ' ist ' + booltostr(TestData[1].valid, '', 'un') + 'gültiger Platz');
    for i := 0 to high(TestData) do
        CheckEquals(TestData[i].valid, fParser.IsValidPlace(TestData[i].Place),
            TestData[i].Place + ' ist ' + booltostr(TestData[i].valid, '', 'un') + 'gültiger Platz');
end;

procedure TTestFBEntryParser.TestHandleGCDateEntry;

begin
    //  fParser.HandleGCDateEntry();
end;

procedure TTestFBEntryParser.TestGuessSexOfGivnName;
type
    TTestData = record
        Name   :string;
        ResSex :char;
      end;

const
    TestData :array[0..3] of TTestData =
        ((Name :'Peter'; ResSex :'M'),
        (Name :'Petra'; ResSex :'F'),
        (Name :'Jerg'; ResSex :'M'),
        (Name :'Maria'; ResSex :'F'));
var
    i :integer;

begin
    for i := 0 to high(TestData) do
        CheckEquals(TestData[i].ResSex, fParser.GuessSexOfGivnName(TestData[i].Name));
end;

procedure TTestFBEntryParser.TestGetEntryType;
type
    TTestData = record
        Entry   :string;
        evType  :TenumEventType;
        ExpDate,
        ExpData :string
      end;

const
    TestData :array[0..24] of TTestData =
        ((Entry :'* 01.02.1734 in Bern'; evType :evt_Birth; ExpDate :'01.02.1734 in Bern';
        ExpData :''),
        (Entry :'* in Bern 01.02.1734'; evType :evt_Birth; ExpDate :'in Bern 01.02.1734';
        ExpData :''),
        (Entry :'†19.3.1915'; evType :evt_Death; ExpDate :'19.3.1915';
        ExpData :''),
        (Entry :'ist nach Amerika ausgewandert'; evType :evt_AddEmigration;
        ExpDate :''; ExpData :'nach Amerika'),
        (Entry :'gefallen 1.1.1945 in Polen'; evType :evt_fallen;
        ExpDate :'1.1.1945 in Polen'; ExpData :'gefallen'),
        (Entry :'vermisst in Frankreich 1.1.1943'; evType :evt_missing;
        ExpDate :'in Frankreich 1.1.1943'; ExpData :'vermisst'),
        (Entry :'wohnhaft in Kürzell'; evType :evt_Residence; ExpDate :'in Kürzell';
        ExpData :'wohnhaft'),
        (Entry :'wohnt Mattenhag-Siedlung'; evType :evt_Residence; ExpDate :'';
        ExpData :'wohnt Mattenhag-Siedlung'),
        (Entry :'lebte einge Monate in Amerika'; evType :evt_Residence;
        ExpDate :''; ExpData :'lebte einge Monate in Amerika'),
        (Entry :'+* 6.11.1846'; evType :evt_Stillborn; ExpDate :'6.11.1846';
        ExpData :'totgeboren'),
        (Entry :'o/o 1.1.1765'; evType :evt_Divorce; ExpDate :'1.1.1765'; ExpData :''),
        (Entry :'Hauptstr. 22'; evType :evt_Residence; ExpDate :''; ExpData :'Hauptstr. 22'),
        (Entry :'Hauptstraße 22'; evType :evt_Residence; ExpDate :''; ExpData :'Hauptstraße 22'),
        (Entry :'Winkelgasse 1'; evType :evt_Residence; ExpDate :''; ExpData :'Winkelgasse 1'),
        (Entry :'Er baute das Haus in der Razeputzallee'; evType :evt_Property; ExpDate :''; ExpData :'Er baute das Haus in der Razeputzallee'),
        (Entry :'Er kaufte das Haus in der Razeputzallee'; evType :evt_Property; ExpDate :''; ExpData :'Er kaufte das Haus in der Razeputzallee'),
        (Entry :'ledig'; evType :evt_Description; ExpDate :'';ExpData :'ledig'),
        (Entry :'Witwe'; evType :evt_Description; ExpDate :'';ExpData :'Witwe'),
        (Entry :'Witwer'; evType :evt_Description; ExpDate :'';ExpData :'Witwer'),
        (Entry :'2 Jahre 5 Monate alt'; evType :evt_Age; ExpDate :'';
        ExpData :'2 Jahre 5 Monate alt'),
        (Entry :'* Willstätt im August 1775'; evType :evt_Birth;
        ExpDate :'Willstätt im August 1775'; ExpData :''),
        (Entry :'wurde "Schmittjockel" genannt'; evType :evt_AKA; ExpDate :'';
        ExpData :'"Schmittjockel"'),
        (Entry :'genannt die Alte'; evType :evt_AKA; ExpDate :'';
        ExpData :'die Alte'),
        (Entry :'der Alte'; evType :evt_AKA; ExpDate :''; ExpData :'der Alte'),
        (Entry :'ein Blinder'; evType :evt_Description; ExpDate :''; ExpData :'ein Blinder'));

    //'o/o 1.1.1765'
    // * Willstätt im August 1775

var
    i :integer;
    lDate, lData :string;
begin
    for i := 0 to high(TestData) do
      begin
        CheckEquals(Ord(TestData[i].evType), Ord(fparser.GetEntryType(
            TestData[i].Entry, lDate, lData)), 'Test[' + IntToStr(i) + ']: ' + TestData[i].Entry);
        CheckEquals(TestData[i].ExpDate, lDate, 'Test[' + IntToStr(i) +
            '].Date: ' + TestData[i].Entry);
        CheckEquals(TestData[i].ExpData, lData, 'Test[' + IntToStr(i) +
            '].Data: ' + TestData[i].Entry);
      end;
end;

procedure TTestFBEntryParser.TestGetEntryType_Rel;
type
    TTestData = record
        Entry   :string;
        evType  :TenumEventType;
        ExpDate,
        ExpData :string
      end;
const
    TestData :array[0..13] of TTestData =
        ((Entry :'rk.'; evType :evt_Religion; ExpDate :'';ExpData :'rk.'),
        (Entry :'kath.'; evType :evt_Religion; ExpDate :'';ExpData :'kath.'),
        (Entry :'ev.'; evType :evt_Religion; ExpDate :'';ExpData :'ev.'),
        (Entry :'ref.'; evType :evt_Religion; ExpDate :'';ExpData :'ref.'),
        (Entry :'reform.'; evType :evt_Religion; ExpDate :'';ExpData :'reform.'),
        (Entry :'luth.'; evType :evt_Religion; ExpDate :'';ExpData :'luth.'),
        (Entry :'evang.'; evType :evt_Religion; ExpDate :'';ExpData :'evang.'),
        (Entry :'rk'; evType :evt_Religion; ExpDate :'';ExpData :'rk.'),
        (Entry :'kath'; evType :evt_Religion; ExpDate :'';ExpData :'kath.'),
        (Entry :'ev'; evType :evt_Religion; ExpDate :'';ExpData :'ev.'),
        (Entry :'ref'; evType :evt_Religion; ExpDate :'';ExpData :'ref.'),
        (Entry :'reform'; evType :evt_Religion; ExpDate :'';ExpData :'reform.'),
        (Entry :'luth'; evType :evt_Religion; ExpDate :'';ExpData :'luth.'),
        (Entry :'evang'; evType :evt_Religion; ExpDate :'';ExpData :'evang.'));
var
    lDate, lData :string;
    i :integer;

begin
    for i := 0 to high(TestData) do
      begin
        CheckEquals(Ord(TestData[i].evType), Ord(fparser.GetEntryType(
            TestData[i].Entry, lDate, lData)), 'Test[' + IntToStr(i) + ']: ' + TestData[i].Entry);
        CheckEquals(TestData[i].ExpDate, lDate, 'Test[' + IntToStr(i) +
            '].Date: ' + TestData[i].Entry);
        CheckEquals(TestData[i].ExpData, lData, 'Test[' + IntToStr(i) +
            '].Data: ' + TestData[i].Entry);
      end;
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry;
const TestStr1 = '* 01.02.1734 in Bern';
    TestStr2 = '* in Bern 01.02.1734';
    TestStr3 = 'ist nach Amerika ausgewandert';
    TestStr4 = ' Die Familie ist am 17.November 1851 nach Amerika ausgewandert';
    TestStr5 = '†19.3.1915';

begin
    AddExpResult(['ParserIndiDate', '01.02.1734', 'I3705C2', Ord(evt_Birth)]);
    AddExpResult(['ParserIndiPlace', 'Bern', 'I3705C2', Ord(evt_Birth)]);
    fparser.HandleNonPersonEntry(TestStr1, 'I3705C2');
    CheckEquals(2, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiDate', '01.02.1734', 'I3705C3', Ord(evt_Birth)]);
    AddExpResult(['ParserIndiPlace', 'Bern', 'I3705C3', Ord(evt_Birth)]);
    fparser.HandleNonPersonEntry(TestStr2, 'I3705C3');
    CheckEquals(4, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiPlace', 'Amerika', 'I3705C1', Ord(evt_AddEmigration)]);
    AddExpResult(['ParserIndiData', 'ist nach Amerika ausgewandert',
        'I3705C1', Ord(evt_AddEmigration)]);
    fparser.HandleNonPersonEntry(TestStr3, 'I3705C1');
    CheckEquals(6, FRCounter, 'FRcounter');

    fParser.DebugSetMsg('', '1', 8);
    AddExpResult(['ParserIndiDate', '17.November 1851', 'I1', Ord(evt_AddEmigration)]);
    AddExpResult(['ParserIndiPlace', 'Amerika', 'I1', Ord(evt_AddEmigration)]);
    AddExpResult(['ParserIndiData',
        'Die Familie ist am 17.November 1851 nach Amerika ausgewandert', 'I1',
        Ord(evt_AddEmigration)]);
    fparser.HandleNonPersonEntry(TestStr4, 'I1');
    CheckEquals(9, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiDate', '19.3.1915', 'I3705C1', Ord(evt_Death)]);
    fparser.HandleNonPersonEntry(TestStr5, 'I3705C1');
    CheckEquals(10, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_occ;

    const
        TestEntry1 =  'Pfarrer';
        TestEntry2 =  'Arbeiter in Köln';
        TestEntry3 =  'Müller in Weil ab 1910';
        TestEntry4 =  'seit 1910 Lehrer in Baden-Baden';
        TestEntry5 = ' 29 Jahre lang Hebamme';
        TestEntry6 = 'ein Hirt aus Dada';
        TestEntry7 = 'led. Knecht';
        TestEntry8 = 'ledige Magd';

begin
    AddExpResult(['ParserIndiOccu', 'Pfarrer', 'I3705C2', Ord(evt_Occupation)]);
    fparser.HandleNonPersonEntry(TestEntry1, 'I3705C2');
    CheckEquals(1, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiOccu', 'Arbeiter', 'I3705C2', Ord(evt_Occupation)]);
    AddExpResult(['ParserIndiPlace', 'Köln', 'I3705C2', Ord(evt_Occupation)]);
    fparser.HandleNonPersonEntry(TestEntry2, 'I3705C2');
    CheckEquals(3, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiOccu', 'Müller', 'I3705C2', Ord(evt_Occupation)]);
    AddExpResult(['ParserIndiDate', 'ab 1910', 'I3705C2', Ord(evt_Occupation)]);
    AddExpResult(['ParserIndiPlace', 'Weil', 'I3705C2', Ord(evt_Occupation)]);
    fparser.HandleNonPersonEntry(TestEntry3, 'I3705C2');
    CheckEquals(6, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiOccu', '29 Jahre lang Hebamme', 'I3705C2', Ord(evt_Occupation)]);
    fparser.HandleNonPersonEntry(TestEntry5, 'I3705C2');
    CheckEquals(7, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiOccu', 'Lehrer', 'I3705C2', Ord(evt_Occupation)]);
    AddExpResult(['ParserIndiDate', 'seit 1910', 'I3705C2', Ord(evt_Occupation)]);
    AddExpResult(['ParserIndiPlace', 'Baden-Baden', 'I3705C2', Ord(evt_Occupation)]);
    fparser.HandleNonPersonEntry(TestEntry4, 'I3705C2');
    CheckEquals(10, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiOccu', 'Hirt', 'I3705C2', Ord(evt_Occupation)]);
    AddExpResult(['ParserIndiPlace', 'Dada', 'I3705C2', Ord(evt_Occupation)]);
    fparser.HandleNonPersonEntry(TestEntry6, 'I3705C2');
    CheckEquals(12, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiData', 'ledig', 'I3705C2', Ord(evt_Description)]);
    AddExpResult(['ParserIndiOccu', 'Knecht', 'I3705C2', Ord(evt_Occupation)]);
    fparser.HandleNonPersonEntry(TestEntry7, 'I3705C2');
    CheckEquals(14, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiData', 'ledig', 'I3705C2', Ord(evt_Description)]);
    AddExpResult(['ParserIndiOccu', 'Magd', 'I3705C2', Ord(evt_Occupation)]);
    fparser.HandleNonPersonEntry(TestEntry8, 'I3705C2');
    CheckEquals(16, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_4;
begin
    AddExpResult(['ParserIndiDate', '1734', 'I3705C2', Ord(evt_Death)]);
    AddExpResult(['ParserIndiPlace', 'Bern', 'I3705C2', Ord(evt_Death)]);
    fparser.HandleNonPersonEntry('+ Bern 1734', 'I3705C2');
    CheckEquals(2, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiDate', 'Juni 1734', 'I3705C2', Ord(evt_Death)]);
    //   AddExpResult(['ParserIndiPlace','Bern','I3705C2',ord(evt_Death)]);
    fparser.HandleNonPersonEntry('+ im Juni 1734', 'I3705C2');
    CheckEquals(3, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_4_2;
begin
    AddExpResult(['ParserIndiPlace', 'Bern', 'I3705C2', Ord(evt_Death)]);
    fparser.HandleNonPersonEntry('+ Bern', 'I3705C2');
    CheckEquals(1, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiDate', 'um 1900', 'I3705C2', Ord(evt_Death)]);
    AddExpResult(['ParserIndiPlace', 'Bern', 'I3705C2', Ord(evt_Death)]);
    fparser.HandleNonPersonEntry('+ Bern um 1900', 'I3705C2');
    CheckEquals(3, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_5;
begin
    AddExpResult(['ParserIndiDate', '1734', 'I3705C2', Ord(evt_Death)]);
    AddExpResult(['ParserIndiPlace', '...', 'I3705C2', Ord(evt_Death)]);
    fparser.HandleNonPersonEntry('+ ... 1734', 'I3705C2');
    CheckEquals(2, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiDate', 'Juni 1734', 'I3705C2', Ord(evt_Death)]);
    AddExpResult(['ParserIndiPlace','…','I3705C2',ord(evt_Death)]);
    fparser.HandleNonPersonEntry('+ … im Juni 1734', 'I3705C2');
    CheckEquals(4, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_6;
begin
    AddExpResult(['ParserIndiDate', '24.12.1893', 'I30F', Ord(evt_Birth)]);
    AddExpResult(['ParserIndiPlace', 'Lauck Kr. Preuß. Holland/Ostpreußen',
        'I30F', Ord(evt_Birth)]);
    fparser.HandleNonPersonEntry(
        '  * in Lauck Kr. Preuß. Holland/Ostpreußen 24.12.1893', 'I30F');
    CheckEquals(2, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_Birth_Plac2;

const
    TestEntry = '* Freiburg im Breisgau 1900';

begin
    AddExpResult(['ParserIndiDate', '1900', 'I30F', Ord(evt_Birth)]);
    AddExpResult(['ParserIndiPlace', 'Freiburg im Breisgau', 'I30F', Ord(evt_Birth)]);
    fparser.HandleNonPersonEntry(TestEntry, 'I30F');
    CheckEquals(2, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_Birth_Plac4;

const
    TestEntry = '* Önsbach 1.12.1900';

begin
    AddExpResult(['ParserIndiDate', '1.12.1900', 'I30F', Ord(evt_Birth)]);
    AddExpResult(['ParserIndiPlace', 'Önsbach', 'I30F', Ord(evt_Birth)]);
    fparser.HandleNonPersonEntry(TestEntry, 'I30F');
    CheckEquals(2, FRCounter, 'FRcounter');
end;


procedure TTestFBEntryParser.TestHandleNonPersonEntry_Birth_Plac3;

const
    TestEntry = '* Mosbach in Baden Aug. 1900';
    TestEntry2 = ' * in Straßburg';
begin
    AddExpResult(['ParserIndiDate', 'Aug. 1900', 'I30F', Ord(evt_Birth)]);
    AddExpResult(['ParserIndiPlace', 'Mosbach in Baden', 'I30F', Ord(evt_Birth)]);
    fparser.HandleNonPersonEntry(TestEntry, 'I30F');
    CheckEquals(2, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiPlace', 'Straßburg', 'I30F', Ord(evt_Birth)]);
    fparser.HandleNonPersonEntry(TestEntry2, 'I30F');
    CheckEquals(3, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_div;
begin
    AddExpResult(['ParserStartFamily', '30F0', '', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I30F', '30F0', 1]);
    AddExpResult(['ParserFamilyData', '', '30F0', Ord(evt_Divorce)]);
    fparser.HandleNonPersonEntry('o/o', 'I30F');
    CheckEquals(3, FRCounter, 'FRcounter');

    AddExpResult(['ParserStartFamily', '30F0', '', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I30F', '30F0', 1]);
    AddExpResult(['ParserFamilyDate', '3.2.1765', '30F0', Ord(evt_Divorce)]);
    fparser.HandleNonPersonEntry('o/o 3.2.1765', 'I30F');
    CheckEquals(6, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_marr;
begin
    AddExpResult(['ParserStartFamily', '30F0', '', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I30F', '30F0', 1]);
    AddExpResult(['ParserFamilyPlace', 'Plobsheim/Elsaß', '30F0', Ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭ in Plobsheim/Elsaß', 'I30F');
    CheckEquals(3, FRCounter, 'FRcounter');

    AddExpResult(['ParserStartFamily', '30F0', '', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I30F', '30F0', 1]);
    AddExpResult(['ParserFamilyDate', '1948', '30F0', Ord(evt_Marriage)]);
    AddExpResult(['ParserFamilyPlace', 'Nonnenweier', '30F0', Ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭ 1948 in Nonnenweier', 'I30F');
    CheckEquals(7, FRCounter, 'FRcounter');

    AddExpResult(['ParserStartFamily', '30F0', '', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I30F', '30F0', 1]);
    AddExpResult(['ParserFamilyData', '', '30F0', Ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭', 'I30F');
    CheckEquals(10, FRCounter, 'FRcounter');

    AddExpResult(['ParserStartFamily', '30F0', '', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I30F', '30F0', 1]);
    AddExpResult(['ParserFamilyDate', 'Aug. 1900', '30F0', Ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭ Aug. 1900', 'I30F');
    CheckEquals(13, FRCounter, 'FRcounter');

    // ⚭ im Elsaß
    AddExpResult(['ParserStartFamily', '30F0', '', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I30F', '30F0', 1]);
    AddExpResult(['ParserFamilyPlace', 'Elsaß', '30F0', Ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭ im Elsaß', 'I30F');
    CheckEquals(16, FRCounter, 'FRcounter');

    // ⚭ mit Peter Wolf
    fparser.DebugSetMsg('Some Message','30',56);
    AddExpResult(['ParserStartFamily', '30F0', '', 0]);
    AddExpResult(['ParserIndiName', 'Peter Wolf', 'I30F0M', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I30F0M', '30F0', 1]);
    AddExpResult(['ParserIndiData', 'M', 'I30F0M',  Ord(evt_Sex)]);
    AddExpResult(['ParserFamilyIndiv', 'I30F', '30F0', 2]);
    AddExpResult(['ParserFamilyData', '', '30F0', Ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭ mit Peter Wolf', 'I30F');
    CheckEquals(22, FRCounter, 'FRcounter');

    // ⚭ 1950 mit Peter Wolf in Dada
    fparser.DebugSetMsg('Some Message','30',56);
    AddExpResult(['ParserStartFamily', '30M0', '', 0]);
    AddExpResult(['ParserIndiName', 'Sabine Fuchs', 'I30M0F', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I30M0F', '30M0', 2]);
    AddExpResult(['ParserIndiData', 'F', 'I30M0F',  Ord(evt_Sex)]);
    AddExpResult(['ParserFamilyIndiv', 'I30M', '30M0', 1]);
    AddExpResult(['ParserFamilyDate', '1950', '30M0', Ord(evt_Marriage)]);
    AddExpResult(['ParserFamilyPlace', 'Dada', '30M0', Ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭ 1950 mit Sabine Fuchs in Dada', 'I30M');
    CheckEquals(29, FRCounter, 'FRcounter');
end;



procedure TTestFBEntryParser.TestHandleNonPersonEntry_Res;
begin
    AddExpResult(['ParserIndiPlace', 'Dundenheim', 'I11', Ord(evt_Residence)]);
    fparser.HandleNonPersonEntry('in Dundenheim', 'I11');
    CheckEquals(1, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiPlace', 'Dundenheim', 'I11', Ord(evt_Residence)]);
    fparser.HandleNonPersonEntry('aus Dundenheim', 'I11');
    CheckEquals(2, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiPlace', '"Spieng in der Herrschaft Bern/Schweiz"',
        'I11', Ord(evt_Residence)]);
    fparser.HandleNonPersonEntry('aus "Spieng in der Herrschaft Bern/Schweiz"', 'I11');
    CheckEquals(3, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiPlace', 'Illkirch', 'I30F', Ord(evt_Residence)]);
    AddExpResult(['ParserIndiData', 'wohnhaft', 'I30F', Ord(evt_Residence)]);
    fparser.HandleNonPersonEntry(' wohnhaft in Illkirch', 'I30F');
    CheckEquals(5, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiData', 'in der Hessen-Hanau-Lichtenbergschen Herrschaft',
        'I11', Ord(evt_Residence)]);
    fparser.HandleNonPersonEntry(
        'in der Hessen-Hanau-Lichtenbergschen Herrschaft', 'I11');
    CheckEquals(6, FRCounter, 'FRcounter');

end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_Gef;
begin
    AddExpResult(['ParserIndiDate', '21.6.1917', 'I211M', Ord(evt_Death)]);
    AddExpResult(['ParserIndiPlace', 'Winterberg/Frankreich', 'I211M', Ord(evt_Death)]);
    AddExpResult(['ParserIndiData', 'gefallen', 'I211M', Ord(evt_Death)]);
    fparser.HandleNonPersonEntry('gefallen 21.6.1917 am Winterberg/Frankreich', 'I211M');
    CheckEquals(3, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleFamilyFact_Str;

const
    TestFact = 'Hauptstr. 42';

begin
    AddExpResult(['ParserFamilyData', 'Hauptstr. 42', '211M', Ord(evt_Residence)]);
    fparser.HandleFamilyFact('211M', Testfact);
    CheckEquals(1, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleFamilyFact_Div;

const
    TestFact = 'o/o 01.02.1943';

begin
    AddExpResult(['ParserFamilyDate', '01.02.1943', '211M', Ord(evt_Divorce)]);
    fparser.HandleFamilyFact('211M', Testfact);
    CheckEquals(1, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleFamilyFact_emig;

const
    TestFact = 'Die Familie ist am 17.November 1851 nach Amerika ausgewandert';

begin
    AddExpResult(['ParserFamilyDate', '17.November 1851', '1', Ord(evt_AddEmigration)]);
    AddExpResult(['ParserFamilyPlace', 'Amerika', '1', Ord(evt_AddEmigration)]);
    AddExpResult(['ParserFamilyData',
        'Die Familie ist am 17.November 1851 nach Amerika ausgewandert', '1',
        Ord(evt_AddEmigration)]);
    fparser.HandleFamilyFact('1', Testfact);
    CheckEquals(3, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleFamilyFact_marr1;

const
    TestFact = 'oo Köln 1956';

begin
    AddExpResult(['ParserFamilyDate', '1956', '1', Ord(evt_Marriage)]);
    AddExpResult(['ParserFamilyPlace', 'Köln', '1', Ord(evt_Marriage)]);
    fparser.HandleFamilyFact('1', Testfact);
    CheckEquals(2, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleFamilyFact_marr2;

const
    TestFact1 = '⚭ in Plobsheim/Elsaß';

begin
    AddExpResult(['ParserFamilyPlace', 'Plobsheim/Elsaß', '30', Ord(evt_Marriage)]);
    fparser.HandleFamilyFact('30', TestFact1);
    CheckEquals(1, FRCounter, 'FRcounter');

    AddExpResult(['ParserFamilyDate', '1948', '30', Ord(evt_Marriage)]);
    AddExpResult(['ParserFamilyPlace', 'Nonnenweier', '30', Ord(evt_Marriage)]);
    fparser.HandleFamilyFact('30', '⚭ 1948 in Nonnenweier');
    CheckEquals(3, FRCounter, 'FRcounter');

    AddExpResult(['ParserFamilyData', '', '30', Ord(evt_Marriage)]);
    fparser.HandleFamilyFact('30', '⚭');
    CheckEquals(4, FRCounter, 'FRcounter');

    AddExpResult(['ParserFamilyDate', 'Aug. 1900', '30', Ord(evt_Marriage)]);
    fparser.HandleFamilyFact('30', '⚭ Aug. 1900');
    CheckEquals(5, FRCounter, 'FRcounter');

    // ⚭ im Elsaß
    AddExpResult(['ParserFamilyPlace', 'Elsaß', '30', Ord(evt_Marriage)]);
    fparser.HandleFamilyFact('30', '⚭ im Elsaß');
    CheckEquals(6, FRCounter, 'FRcounter');
end;


procedure TTestFBEntryParser.TestHandleAKPersonEntry;
var
    oLastname :string;
    oPSex     :char;
begin
    AddExpResult(['ParserFamilyType', '', '123', 1]);
    AddExpResult(['ParserIndiName', 'Hilda Wasmer', 'I123F', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123F', '123', 2]);
    // {ETYPE = 'ParserFamilyIndiv', DATA = 'I123F', REF = '123', SUBTYPE = 1}
    AddExpResult(['ParserIndiData', 'F', 'I123F', Ord(evt_Sex)]);
    CheckEquals('I123F', fparser.HandleAKPersonEntry(
        'Hilda Röder geb.Wasmer', '123', 'U', 5, oLastname, oPSex), 'Hilda Röder 1');
    CheckEquals('Wasmer', oLastname, 'LastName1');
    CheckEquals('F', oPSex, 'pSex1');
    CheckEquals(4, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Peter Mayer', 'I123M', 0]);
    AddExpResult(['ParserIndiName', 'Dr. theol.', 'I123M', 4]);
    AddExpResult(['ParserFamilyIndiv', 'I123M', '123', 1]);
    AddExpResult(['ParserIndiData', 'M', 'I123M', Ord(evt_Sex)]);
    CheckEquals('I123M', fparser.HandleAKPersonEntry(
        'Dr. theol.Peter Mayer', '123', 'U', 5, oLastname, oPSex), 'Dr. theol.Peter Mayer 2');
    CheckEquals('Mayer', oLastname, 'LastName2');
    CheckEquals('M', oPSex, 'pSex2');
    CheckEquals(8, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Hans-Peter Schulze', 'I123M', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123M', '123', 1]);
    AddExpResult(['ParserIndiData', 'M', 'I123M', Ord(evt_Sex)]);
    CheckEquals('I123M', fparser.HandleAKPersonEntry(
        'Hans-Peter Schulze', '123', 'U', 5, oLastname, oPSex), 'Hans-Peter Schulze 3');
    CheckEquals('Schulze', oLastname, 'LastName3');
    CheckEquals('M', oPSex, 'pSex3');
    CheckEquals(11, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', '... Zarau', 'I123U', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123U', '123', 1]);
    AddExpResult(['ParserIndiData', 'U', 'I123U', Ord(evt_Sex)]);
    CheckEquals('I123U', fparser.HandleAKPersonEntry(
        '... Zarau', '123', 'U', 5, oLastname, oPSex), '... Zarau 4');
    CheckEquals('Zarau', oLastname, 'LastName4');
    CheckEquals('U', oPSex, 'pSex3');
    CheckEquals(14, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Kind Arni', 'I123U', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123U', '123', 1]);
    AddExpResult(['ParserIndiData', 'U', 'I123U', Ord(evt_Sex)]);
    CheckEquals('I123U', fparser.HandleAKPersonEntry(
        'Kind Arni', '123', 'U', 5, oLastname, oPSex), 'Kind Arni 5');
    CheckEquals('Arni', oLastname, 'LastName5');
    CheckEquals('U', oPSex, 'pSex3');
    CheckEquals(17, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Dorothea Locher', 'I58F', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I58F', '58', 2]);
    AddExpResult(['ParserIndiData', 'F', 'I58F', Ord(evt_Sex)]);
    AddExpResult(['ParserIndiName', '?', 'I58F', 3]);
    CheckEquals('I58F', fparser.HandleAKPersonEntry(
        'Dorothea Locher', '58', 'F', 7, oLastname, oPSex, '?'), 'Dorothea Locher 6');
    CheckEquals('Locher', oLastname, 'LastName6');
    CheckEquals('F', oPSex, 'pSex6');
    CheckEquals(21, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Hans Friedrich Roth', 'I321M', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I321M', '321', 1]);
    AddExpResult(['ParserIndiData', 'M', 'I321M', Ord(evt_Sex)]);
    CheckEquals('I321M', fparser.HandleAKPersonEntry(
        'Hans Friedrich  Roth', '321', 'U', 5, oLastname, oPSex), 'Hans Friedrich  Roth 6');
    CheckEquals('Roth', oLastname, 'LastName6');
    CheckEquals('M', oPSex, 'pSex6');
    CheckEquals(24, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleAKPersonEntry_55;
var
    oLastname :string;
    oPSex     :char;
begin
    AddExpResult(['ParserIndiName', 'Andres Acherer', 'I123M', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123M', '123', 1]);
    // {ETYPE = 'ParserFamilyIndiv', DATA = 'I123F', REF = '123', SUBTYPE = 1}
    AddExpResult(['ParserIndiData', 'M', 'I123M', Ord(evt_Sex)]);
    CheckEquals('I123M', fparser.HandleAKPersonEntry(
        'Andres A. ', '123', 'U', 55, oLastname, oPSex, '', 'Acherer'), 'Andres A. 1');
    CheckEquals('Acherer', oLastname, 'LastName1');
    CheckEquals('M', oPSex, 'pSex1');
    CheckEquals(3, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Peter Mayer', 'I123M', 0]);
    AddExpResult(['ParserIndiName', 'Dr. theol.', 'I123M', 4]);
    AddExpResult(['ParserFamilyIndiv', 'I123M', '123', 1]);
    AddExpResult(['ParserIndiData', 'M', 'I123M', Ord(evt_Sex)]);
    CheckEquals('I123M', fparser.HandleAKPersonEntry(
        'Dr. theol.Peter M.', '123', 'U', 55, oLastname, oPSex, '', 'Mayer'),
        'Dr. theol.Peter Mayer 2');
    CheckEquals('Mayer', oLastname, 'LastName2');
    CheckEquals('M', oPSex, 'pSex2');
    CheckEquals(7, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Hans-Peter Schulze', 'I123M', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123M', '123', 1]);
    AddExpResult(['ParserIndiData', 'M', 'I123M', Ord(evt_Sex)]);
    CheckEquals('I123M', fparser.HandleAKPersonEntry('Hans-Peter Sch.',
        '123', 'U', 55, oLastname, oPSex, '', 'Schulze'), 'Hans-Peter Schulze 3');
    CheckEquals('Schulze', oLastname, 'LastName3');
    CheckEquals('M', oPSex, 'pSex3');
    CheckEquals(10, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Erna Martha Geriger', 'I123F', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123F', '123', 2]);
    AddExpResult(['ParserIndiData', 'F', 'I123F', Ord(evt_Sex)]);
    AddExpResult(['ParserIndiName', '? Geriger', 'I123F', 3]);
    CheckEquals('I123F', fparser.HandleAKPersonEntry(
        'Erna Martha', '123', 'U', 55, oLastname, oPSex, '? G.', 'Geriger'), 'Erna Martha Geriger 4');
    CheckEquals('Geriger', oLastname, 'LastName4');
    CheckEquals('F', oPSex, 'pSex4');
    CheckEquals(14, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Martin Eich', 'I123M', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123M', '123', 1]);
    AddExpResult(['ParserIndiData', 'M', 'I123M', Ord(evt_Sex)]);
    AddExpResult(['ParserIndiName', '? Eich', 'I123M', 3]);
    CheckEquals('I123M', fparser.HandleAKPersonEntry(
        'Martin', '123', 'U', 55, oLastname, oPSex, 'E.', 'Eich'), 'Martin Eich 5');
    CheckEquals('Eich', oLastname, 'LastName5');
    CheckEquals('M', oPSex, 'pSex5');
    CheckEquals(18, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', '... Bohrer', 'I123U', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123U', '123', 1]);
    AddExpResult(['ParserIndiData', 'U', 'I123U', Ord(evt_Sex)]);
    CheckEquals('I123U', fparser.HandleAKPersonEntry(
        '... B.', '123', 'U', 55, oLastname, oPSex, '', 'Bohrer'), '... B. 6');
    CheckEquals('Bohrer', oLastname, 'LastName6');
    CheckEquals('U', oPSex, 'pSex6');
    CheckEquals(21, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', '...', 'I123U', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123U', '123', 1]);
    AddExpResult(['ParserIndiData', 'U', 'I123U', Ord(evt_Sex)]);
    CheckEquals('I123U', fparser.HandleAKPersonEntry(
        '...', '123', 'U', 55, oLastname, oPSex, '', 'Bohrer'), '... 7');
    CheckEquals('...', oLastname, 'LastName7');
    CheckEquals('U', oPSex, 'pSex7');
    CheckEquals(24, FRCounter, 'FRcounter');


end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_57;

begin
    // {ETYPE = 'ParserStartFamily', DATA = '3C1', REF = 0x0, SUBTYPE = 0}
    AddExpResult(['ParserStartFamily', '3C1P0', '', 0]);

    AddExpResult(['ParserFamilyIndiv', 'I3C1', '3C1P0', 1]);
    // {ETYPE = 'ParserFamilyIndiv', DATA = 'I123F', REF = '123', SUBTYPE = 1}
    AddExpResult(['ParserFamilyPlace', 'Neureuth', '3C1P0', Ord(evt_Marriage)]);
    CheckEquals(Ord(evt_Marriage), Ord(fparser.HandleNonPersonEntry(
        'oo in Neureuth', 'I3C1')), 'oo in Neureuth');
    CheckEquals(3, FRCounter, 'FRcounter');

    // {ETYPE = 'ParserStartFamily', DATA = '3C1', REF = 0x0, SUBTYPE = 0}
    AddExpResult(['ParserStartFamily', '3C1P3', '', 0]);

    AddExpResult(['ParserFamilyIndiv', 'I3C1', '3C1P3', 1]);
    // {ETYPE = 'ParserFamilyIndiv', DATA = 'I123F', REF = '123', SUBTYPE = 1}
    AddExpResult(['ParserFamilyPlace', 'Neureuth', '3C1P3', Ord(evt_Marriage)]);
    CheckEquals(Ord(evt_Marriage), Ord(fparser.HandleNonPersonEntry(
        'oo in Neureuth', 'I3C1','3C1P3')), 'oo in Neureuth');
    CheckEquals(6, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleAKPersonEntry_56;
var
    oLastname :string;
    oPSex     :char;
begin
    AddExpResult(['ParserFamilyType', '', '123', 1]);
    AddExpResult(['ParserIndiName', 'Andrea Acherer', 'I123F', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123F', '123', 2]);
    // {ETYPE = 'ParserFamilyIndiv', DATA = 'I123F', REF = '123', SUBTYPE = 2}
    AddExpResult(['ParserIndiData', 'F', 'I123F', Ord(evt_Sex)]);
    CheckEquals('I123F', fparser.HandleAKPersonEntry(
        'Andrea geb.Acherer', '123', 'F', 56, oLastname, oPSex, '', 'Acherer'), 'Andres A. 2');
    CheckEquals('Acherer', oLastname, 'LastName1');
    CheckEquals('F', oPSex, 'pSex1');
    CheckEquals(4, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName', 'Petra Mayer', 'I123F', 0]);
    AddExpResult(['ParserIndiName', 'Dr. theol.', 'I123F', 4]);
    AddExpResult(['ParserFamilyIndiv', 'I123F', '123', 2]);
    AddExpResult(['ParserIndiData', 'F', 'I123F', Ord(evt_Sex)]);
    CheckEquals('I123F', fparser.HandleAKPersonEntry(
        'Dr. theol.Petra Mayer', '123', 'F', 56, oLastname, oPSex, '', 'Mayer'),
        'Dr. theol.Peter Mayer 2');
    CheckEquals('Mayer', oLastname, 'LastName2');
    CheckEquals('F', oPSex, 'pSex2');
    CheckEquals(8, FRCounter, 'FRcounter');

    AddExpResult(['ParserFamilyType', '', '123', 1]);
    AddExpResult(['ParserIndiName', 'Marie-Luise Schulze', 'I123F', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123F', '123', 2]);
    AddExpResult(['ParserIndiData', 'F', 'I123F', Ord(evt_Sex)]);
    CheckEquals('I123F', fparser.HandleAKPersonEntry(
        'Marie-Luise geb.Schulze', '123', 'F', 56, oLastname, oPSex, '', 'Schulze'),
        'Hans-Peter Schulze 3');
    CheckEquals('Schulze', oLastname, 'LastName3');
    CheckEquals('F', oPSex, 'pSex3');
    CheckEquals(12, FRCounter, 'FRcounter');

    AddExpResult(['ParserFamilyType', '', '123', 1]);
    AddExpResult(['ParserIndiName', 'Erna Martha Duda', 'I123F', 0]);
    AddExpResult(['ParserFamilyIndiv', 'I123F', '123', 2]);
    AddExpResult(['ParserIndiData', 'F', 'I123F', Ord(evt_Sex)]);
    AddExpResult(['ParserIndiName', '? geb. Duda', 'I123F', 3]);
    CheckEquals('I123F', fparser.HandleAKPersonEntry(
        'Erna Martha', '123', 'F', 56, oLastname, oPSex, '? geb.Duda', 'Geriger'),
        'Hans-Peter Schulze 3');
    CheckEquals('Duda', oLastname, 'LastName4');
    CheckEquals('F', oPSex, 'pSex4');
    CheckEquals(17, FRCounter, 'FRcounter');

end;


procedure TTestFBEntryParserBase.FSFileFound(FileIterator :TFileIterator);
var
    lSt, lRs :TStrings;
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
        fParser.GNameHandler.LoadGNameList(FDataPath + DirectorySeparator +
            'GNameFile.txt');
        fparser.GNameHandler.SetGNLFilename(ChangeFileExt(FileIterator.FileName,
            '.Name.New'));
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

procedure TTestFBEntryParserBase.CreateExpResult(st :TStrings;
    out Expct :TResultTypeArray);
var
    i :integer;
begin
    if st.Count = 0 then
        setlength(Expct, 0)
    else
        setlength(Expct, st.Count - 1);
    for i := 1 to st.Count - 1 do
        Expct[i - 1].SetAll(st[i].Split([#9]));
end;

procedure TTestFBEntryParserBase.AddExpResult(Data :array of variant);

begin
    setlength(ExpResults, high(ExpResults) + 2);
    ExpResults[high(ExpResults)].SetAll(Data);
end;


procedure TTestFBEntryParserBase.ExpResultToTStr(const Exp :array of TResultType;
    st :TStrings);
var
    le :TResultType;
begin
    st.Clear;
    st.append('eType'#9'Data'#9'Ref'#9'SubType');
    for le in Exp do
        st.append(le.toCsv(#9));
end;

procedure TTestFBEntryParserBase.ParserStartFamily(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserStartFamily', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserError(Sender :TObject);
begin
    ParserTestEvent(Sender, 'ParserError!', TFBEntryParser(Sender).LastErr,
        TFBEntryParser(Sender).MainRef, TFBEntryParser(Sender).LastMode);
end;

procedure TTestFBEntryParserBase.ParserMessage(Sender :TObject;
    aType :TEventType; aText :string; Ref :string; aMode :integer);
begin
    case aType of
        etCustom:
            ParserTestEvent(Sender, 'ParserCustom', aText, Ref, aMode);
        etInfo:
            ParserTestEvent(Sender, 'ParserInfo', aText, Ref, aMode);
        etWarning:
            ParserTestEvent(Sender, 'ParserWarning', aText, Ref, aMode);
        etError:
            ParserTestEvent(Sender, 'ParserError!', aText, Ref, aMode);
        etDebug:
            ParserTestEvent(Sender, 'ParserDebugMsg', aText, Ref, aMode);
      end;
end;

procedure TTestFBEntryParserBase.ParserFamilyType(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyType', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiData(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserIndiData', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiDate(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserIndiDate', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiName(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserIndiName', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiOccu(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserIndiOccu', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiPlace(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserIndiPlace', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiRef(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserIndiRef', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserIndiRel(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserIndiRel', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserTestEvent(Sender :TObject;
    eType, aText, Ref :string; dsubtype :integer);
var
    lr :TResultType;
    lDebEv, {%H-}lLastDeb :string;
begin
    CheckTrue(fParser.Equals(Sender), 'Teste Sender');
    lr.setall([variant(etype), atext, Ref, dsubtype]);
    lDebEv := lr.ToString;
    if Length(ExpResults) = 0 then
      begin
        setlength(FResult, length(FResult) + 1);
        Fresult[high(FResult)] := lr;
        exit;
      end;
    if (eType = 'ParserDebugMsg') then
      begin
        FlastDeb := lDebEv;
        if ((high(ExpResults) < FRCounter) or (ExpResults[FRCounter].eType <> eType))
        then
            exit;  // Ignore optional Element
      end;
    lLastDeb := FlastDeb;
    lDebEv   := lr.ToCSV(#9);
    CheckTrue(high(ExpResults) >= FRCounter, 'Result Exists[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].toCsv(#9), lDebEv, 'Teste Evt[' +
        IntToStr(FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].Data, aText, 'Teste aText[' +
        IntToStr(FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].eType, eType, 'Teste eType[' +
        IntToStr(FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].Ref, Ref, 'Teste Ref[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].SubType, dsubtype, 'Teste SubType[' +
        IntToStr(FRCounter) + '],' + FTestName);
    Inc(FRCounter);
end;

procedure TTestFBEntryParserBase.TestOneFile(aFilename :string; ff :TFileFoundEvent);
var
    lFileSearcher :TFileSearcher;
begin
    lFileSearcher := TFileSearcher.Create;
    if ff = nil then
        ff := @FSFileFound;
      try
        lFileSearcher.OnFileFound := ff;
        lFileSearcher.Search(FDataPath, aFilename, False, False);
      finally
        FreeAndNil(lFileSearcher);
      end;
end;

constructor TTestFBEntryParserBase.Create;
var
    i :integer;
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

procedure TTestFBEntryParserBase.ParserFamilyDate(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyDate', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserFamilyData(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyData', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserFamilyIndiv(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyIndiv', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserFamilyPlace(Sender :TObject;
    aText, Ref :string; dsubtype :integer);
begin
    ParserTestEvent(Sender, 'ParserFamilyPlace', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.SetUp;
begin
    fParser := TFBEntryParser.Create;
    fParser.GNameHandler.LoadGNameList(FDataPath + DirectorySeparator + 'GNameFile.txt');
    fParser.GNameHandler.SetGNLFilename(FDataPath + DirectorySeparator +
        'GNameFile.Nxt');
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
    fParser.onParseError := @ParserError;
    fParser.onParseMessage := @ParserMessage;
    FTestName := '';
    setlength(ExpResults, 0);
    FRCounter := 0;
end;

procedure TTestFBEntryParserBase.TearDown;
begin
    FreeAndNil(fParser);
    setlength(FResult, 0);
end;


procedure TTestFBEntryParserAll.FSFileFound(FileIterator :TFileIterator);
var
    st :string;
begin
    st := ExtractFileName(FileIterator.Filename);
    if st.StartsWith('OsBM') then
        fParser.DefaultPlace := 'Meißenheim'
    else
        fParser.DefaultPlace := '';
    inherited FSFileFound(FileIterator);
end;

procedure TTestFBEntryParserAll.FSAddFound(FileIterator :TFileIterator);
var
    st :string;

begin
    st := ExtractFileName(FileIterator.Filename);
    RegisterTest(ClassName + '\test', TChildTest.Create(self, st));
end;


constructor TTestFBEntryParserAll.Create;
var
    lFileSearcher :TFileSearcher;

begin
    inherited Create;
    if TestName = '' then
      begin
        lFileSearcher := TFileSearcher.Create;
          try
            lFileSearcher.OnFileFound := @FSAddFound;
            lFileSearcher.Search(FDataPath, '*.entTxt', False, False);
          finally
            FreeAndNil(lFileSearcher);
          end;
      end;
end;

destructor TTestFBEntryParserAll.Destroy;

begin

end;

function TTestFBEntryParserAll.GetChildTestCount :integer;
begin
    Result := length(FChildren);
end;

function TTestFBEntryParserAll.GetChildTest(AIndex :integer) :TTest;
begin
    Result := FChildren[Aindex];
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

procedure TTestFBEntryParserGC.TestFileO0338;
begin
    // Unclosed Reference
    TestOneFile('OsBObr0338.entTxt');
end;

procedure TTestFBEntryParserGC.TestFileO0451;
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

procedure TTestFBEntryParserAK.SetUp;
begin
    inherited SetUp;
    fParser.DefaultPlace := 'Meißenheim';
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
    // Husband Name with -
    // , missing after reference
    // , Missing after Occupation
    // Wife name : ...
    // Child Entry ends with , ==> Error
    TestOneFile('OsBM0008.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0009;
begin
    TestOneFile('OsBM0009.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0011;
begin
    // Family emigration
    TestOneFile('OsBM0011.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0020;
begin
    // Entry with Adress.
    TestOneFile('OsB' + RightStr(TestName, 5) + '.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0026;
begin
    // Birth-Record
    TestOneFile('OsBM0026.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0030;
begin
    // Birth-Place
    TestOneFile('OsBM0030.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0037;
begin
    // Parent mit "aus ..."
    TestOneFile('OsBM0037.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0054;
begin
    // Wife Ref concat with "und"
    TestOneFile('OsBM0054.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0061;
begin
    // Residence Entry
    TestOneFile('OsBM0061.entTxt');
end;


procedure TTestFBEntryParserAK.TestFileM0119;
begin
    // : missing
    TestOneFile('OsBM0119.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0193;
begin
    // Couple were each married and divorced before.
    TestOneFile('OsBM0193.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0211;
begin
    // Place start with 'am'.
    TestOneFile('OsBM0211.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0263;
const
    CFileName = 'OsBM0263.entTxt';
begin
    // Unreadable-Marriag-Date with '..'
    TestOneFile(CFileName);
end;

procedure TTestFBEntryParserAK.TestFileM0330;
begin
    // Child-Marriages with 'oo'
    TestOneFile('OsBM0330.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0337;
begin
    // Residence Entry 2
    TestOneFile('OsBM0337.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0405;
begin
    // Space missing after Childnumber
    TestOneFile('OsBM0405.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0407;
begin
    // Husband Mother ?
    TestOneFile('OsBM0407.entTxt');
end;


procedure TTestFBEntryParserAK.TestFileM0409;
begin
    TestOneFile('OsBM0409.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0411;
begin
    // Comma missing after Occupation
    // Logical Error: Ursula has wrong reference 1188 ins. of 1768
    TestOneFile('OsBM0411.entTxt');
end;


procedure TTestFBEntryParserAK.TestFileM0424;
begin
    // Wife ... as Surname
    TestOneFile('OsBM0424.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0427;
begin
    // und Flag for Wife-Entry
    TestOneFile('OsBM0427.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0429;
begin
    // Husband first Marriage (. missing in s.)
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

procedure TTestFBEntryParserAK.TestFileM0476;
begin
    // Wife with 3 marrige-types
    TestOneFile('OsBM0476.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0486;
begin
    TestOneFile('OsBM0486.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0485;
begin
    // Wife with unsafe Surname (? Eich)
    // Death of Father of Wife (late Binding)
    TestOneFile('OsBM0485.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0549;
begin
    // Place start with 'bei'
    TestOneFile('OsBM0549.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0746;
begin
    // Reference ends with ),
    TestOneFile('OsB' + RightStr(TestName, 5) + '.entTxt');
end;


procedure TTestFBEntryParserAK.TestFileM0832;
begin
    // complex Chidren-Data
    TestOneFile('OsBM0832.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0854;
begin
    // Wrong entrysign
    TestOneFile('OsBM0854.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0889;
begin
    // Husband korr. reference
    // Father of wife, complex Place
    TestOneFile('OsBM0889.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM0918;
begin
    // Married Child with Person
    TestOneFile('OsB' + RightStr(TestName, 5) + '.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1026;
begin
    // Child Marriage with Children
    TestOneFile('OsBM1026.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1078;
begin
    // , Missing before birth
    TestOneFile('OsBM1078.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1093;
begin
    // korrected Child-reference
    TestOneFile('OsBM1093.entTxt');
end;


procedure TTestFBEntryParserAK.TestFileM1138;
begin
    // Dr.theol.O ...
    TestOneFile('OsBM1138.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1149;
begin
    // Wife Entry started with "und"
    TestOneFile('OsBM1149.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1220;
begin
    TestOneFile('OsBM1220.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1221;
begin
    TestOneFile('OsBM1221.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1227;
begin
    TestOneFile('OsBM1227.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1240;
begin

    TestOneFile('OsBM1240.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1242;
begin
    // Divorce
    TestOneFile('OsBM1242.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1251;
begin
    // Places with "bei"
    // Default-Birthplaces
    TestOneFile('OsBM1251.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1252;
begin
    // Childcount in Brackets
    // ... as Givenname
    TestOneFile('OsBM1252.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1262;
begin
    // Error in Entry
    TestOneFile('OsBM1262.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1268;
begin
    // Comma after date missing (Error but recovering)
    TestOneFile('OsBM1268.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1274;
begin
    // ??
    TestOneFile('OsBM1274.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1276;
begin
    // ??
    TestOneFile('OsBM1276.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1319;
begin
    // Single Person
    TestOneFile('OsB' + RightStr(TestName, 5) + '.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1321;
begin
    // Couple each was married first
    TestOneFile('OsB' + RightStr(TestName, 5) + '.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1353;
begin
    // Children with discrete Marriages
    TestOneFile('OsBM1353.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1353a;
begin
    // ??
    TestOneFile('OsBM1353a.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1354;
begin
    // Complex Child (wrong) ref
    TestOneFile('OsBM1354.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1387;
begin
    // Child ref not closed.
    TestOneFile('OsBM1387.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM1436;
begin
    // Main-Person ?
    TestOneFile('OsBM1436.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM2420;
begin
    // Main-Person ?
    TestOneFile('OsBM2420.entTxt');
end;

procedure TTestFBEntryParserAK.TestFileM2421;
begin
    // Main-Person ?
    TestOneFile('OsBM2421.entTxt');
end;



initialization

    RegisterTest(TTestFBEntryParser);
    RegisterTest(TTestFBEntryParserAK);
    RegisterTest(TTestFBEntryParserGC);
    RegisterTest(TTestFBEntryParserAll);

end.
