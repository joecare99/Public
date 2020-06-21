unit cls_TestParseFBEntry;

{$mode objfpc}{$H+}


interface

uses
    Classes, SysUtils, FileUtil, fpcunit, testutils, testregistry, unt_FBParser,
    unt_TestFBData;

type

    { TTestFBEntryParserBase }

    TTestFBEntryParserBase = class(TTestCase)
    protected
        fParser: TFBEntryParser;
        FDataPath: string;
        FResult, ExpResults: array of TResultType;
        FRCounter: integer;
        FTestName: string;
        procedure SetUp; override;
        procedure TearDown; override;
        procedure TestOneFile(aFilename: String; ff: TFileFoundEvent=nil);
    private
      FlastDeb: String;
        procedure AddExpResult(Data: array of variant);
        procedure FSFileFound(FileIterator: TFileIterator);virtual;
        procedure CreateExpResult(st: TStrings; out Expct: TResultTypeArray);
        procedure ExpResultToTStr(const Exp: array of TResultType; st: TStrings);
        procedure ParserError(Sender: TObject);
        procedure ParserMessage(Sender: TObject; aType: TEventType;
        aText: string; Ref: string; aMode: integer);
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
          procedure TestHandleAKPersonEntry;
          procedure TestHandleAKPersonEntry_55;
          procedure TestHandleAKPersonEntry_56;
          Procedure TestHandleNonPersonEntry;
           Procedure TestHandleNonPersonEntry_6;
         procedure TestHandleNonPersonEntry_Res;
         procedure TestHandleNonPersonEntry_div;
         procedure TestHandleNonPersonEntry_marr;
          procedure TestHandleNonPersonEntry_57;
          procedure TestGetEntryType;
          procedure TestGetEntryType_Rel;
          procedure TestGuessSexOfGivnName;
          procedure TestHandleGCDateEntry;
          procedure TesttestEntry;
          procedure TestTestFor;
          procedure TestTestFor2;
          procedure TestTestFor3;
          procedure TestParseAdditional;
        private
        end;


{ TTestFBEntryParser }

    { TTestFBEntryParserAll }

    TTestFBEntryParserAll = class(TTestFBEntryParserBase)
    protected
      procedure FSFileFound(FileIterator: TFileIterator);override;
    published
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
        Procedure SetUp; override;
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
        procedure TestFileM0026;
        procedure TestFileM0030;
        procedure TestFileM0037;
        procedure TestFileM0061;
        procedure TestFileM0119;
        procedure TestFileM0193;
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
        procedure TestFileM0832;
        procedure TestFileM0854;
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
        procedure TestFileM1353;
    private
     end;

implementation

uses LConvEncoding,unt_IGenBase2;

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
    lResult.SetAll(['', 'WWW', 'XXX', 13]);
    fparser.DebugSetMsg('WWW','XXX',13);
    ParserError(fParser);
    CheckEquals(14, FRCounter, 'FRcounter');
    ParserMessage(fParser,etWarning,'YYY','YYY2',14);
    CheckEquals(15, FRCounter, 'FRcounter');
    ParserMessage(fParser,etDebug,'ZZZ','ZZZ2',15);
    CheckEquals(16, FRCounter, 'FRcounter');
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
    fParser.DefaultPlace:='Meißenheim';
    fParser.Feed(cTestEntryAK2421);
    CheckEquals(length(ExpResults), FRCounter, 'Counter');
end;

procedure TTestFBEntryParser.TesttestEntry;

begin

end;

procedure TTestFBEntryParser.TestTestFor;

begin

end;

procedure TTestFBEntryParser.TestTestFor2;

begin

end;

procedure TTestFBEntryParser.TestTestFor3;

begin

end;

procedure TTestFBEntryParser.TestParseAdditional;
var
  Offset: Int64;
  lOutput: string;
begin
  Offset := 1;
  CheckTrue(fParser.ParseAdditional('(Dies ist ein Test)',Offset,lOutput),'(Dies ist ein Test)');
  CheckEquals('Dies ist ein Test',lOutput);
  CheckEquals(19,Offset,'Offset: Dies ist ein Test');

  AddExpResult(['ParserError!','Misspelled additional Entry','',0]);
  Offset := 1;
  CheckTrue(fParser.ParseAdditional('(Dies ist ein Fehler',Offset,lOutput),'(Dies ist ein Fehler');
  CheckEquals('Dies ist ein Fehler',lOutput);
  CheckEquals(21,Offset,'Offset: Dies ist ein Fehler');

  Offset := 1;
  CheckTrue(fParser.ParseAdditional('(an den Folgen einer Granatsplitterverwundung'+
    ' am 10.4.1945 daheim im Keller bei einem Beschuß)',Offset,lOutput),'Dies ist OK');
  CheckEquals(95,Offset,'Offset: an den Folgen einer ...');
  CheckEquals('an den Folgen einer Granatsplitterverwundung'+
    ' am 10.4.1945 daheim im Keller bei einem Beschuß',lOutput);

  Offset := 1;
  CheckTrue(fParser.ParseAdditional('("an den Folgen einer Granatsplitterverwundung'+
    ' am 10.4.1945 daheim im Keller bei einem Beschuß, an den Folgen einer'+
    ' Granatsplitterverwundung am 10.4.1945 daheim im Keller bei einem Beschuß,'+
    ' an den Folgen einer Granatsplitterverwundung am 10.4.1945 daheim im Keller'+
    ' bei einem Beschuß, an den Folgen einer Granatsplitterverwundung am 10.4.1945'+
    ' daheim im Keller bei einem Beschuß.")',Offset,lOutput),'Dies ist OK');
  CheckEquals(383,Offset,'Offset: Dies ist ein Fehler');
  CheckEquals('"an den Folgen einer Granatsplitterverwundung'+
    ' am 10.4.1945 daheim im Keller bei einem Beschuß, an den Folgen einer'+
    ' Granatsplitterverwundung am 10.4.1945 daheim im Keller bei einem Beschuß,'+
    ' an den Folgen einer Granatsplitterverwundung am 10.4.1945 daheim im Keller'+
    ' bei einem Beschuß, an den Folgen einer Granatsplitterverwundung am 10.4.1945'+
    ' daheim im Keller bei einem Beschuß."',lOutput);


end;

procedure TTestFBEntryParser.TestHandleGCDateEntry;

begin

end;

procedure TTestFBEntryParser.TestGuessSexOfGivnName;

begin

end;

procedure TTestFBEntryParser.TestGetEntryType;
var
  lDate, lData: string;
begin
    CheckEquals(ord(evt_Birth),ord(fparser.GetEntryType('* 01.02.1734 in Bern',lDate,lData)),'* 01.02.1734 in Bern');
    CheckEquals('01.02.1734 in Bern',lDate,'Geboren in Bern');
    CheckEquals('',lData,'Geboren in Bern');

    CheckEquals(ord(evt_Birth),ord(fparser.GetEntryType('* in Bern 01.02.1734',lDate,lData)),'* in Bern 01.02.1734');
    CheckEquals('in Bern 01.02.1734',lDate,'Geboren in Bern 2');
    CheckEquals('',lData,'Geboren in Bern 2');

    CheckEquals(ord(evt_AddEmigration),ord(fparser.getEntryType('ist nach Amerika ausgewandert',lDate,lData)),'ist nach Amerika ausgewandert');
    CheckEquals('',lDate,'nach Amerika ausgewandert');
    CheckEquals('nach Amerika',lData,'nach Amerika ausgewandert');

    CheckEquals(ord(evt_fallen),ord(fparser.getEntryType('gefallen 1.1.1945 in Polen',lDate,lData)),'gefallen 1.1.1945 in Polen');
    CheckEquals('1.1.1945 in Polen',lDate,'Gefallen in Polen');
    CheckEquals('gefallen',lData,'Gefallen in Polen');

    CheckEquals(ord(evt_missing),ord(fparser.getEntryType('vermisst in Frankreich 1.1.1943',lDate,lData)),'vermisst in Frankreich 1.1.1943');
    CheckEquals('in Frankreich 1.1.1943',lDate,'Vermisst in Frankreich');
    CheckEquals('vermisst',lData,'Vermisst in Frankreich');

    CheckEquals(ord(evt_Residence),ord(fparser.getEntryType('wohnhaft in Kürzell',lDate,lData)),'wohnhaft in Kürzell');
    CheckEquals('in Kürzell',lDate,'wohnhaft in Kürzell');
    CheckEquals('wohnhaft',lData,'wohnhaft in Kürzell');

    CheckEquals(ord(evt_Residence),ord(fparser.getEntryType('wohnt Mattenhag-Siedlung',lDate,lData)),'wohnhaft in Kürzell');
    CheckEquals('',lDate,'wohnt Mattenhag-Siedlung');
    CheckEquals('wohnt Mattenhag-Siedlung',lData,'wohnt Mattenhag-Siedlung');

end;

procedure TTestFBEntryParser.TestGetEntryType_Rel;
var
  lDate, lData: string;
begin
    CheckEquals(ord(evt_Religion),ord(fparser.GetEntryType('rk.',lDate,lData)),'rk.');
    CheckEquals('rk.',lData,'rk.');
    CheckEquals('',lDate,'rk.');

    CheckEquals(ord(evt_Religion),ord(fparser.GetEntryType('kath.',lDate,lData)),'kath.');
    CheckEquals('kath.',lData,'kath.');
    CheckEquals('',lDate,'kath.');

    CheckEquals(ord(evt_Religion),ord(fparser.GetEntryType('ev.',lDate,lData)),'ev.');
    CheckEquals('ev.',lData,'ev.');
    CheckEquals('',lDate,'ev.');

    CheckEquals(ord(evt_Religion),ord(fparser.GetEntryType('ref.',lDate,lData)),'ref.');
    CheckEquals('ref.',lData,'ref.');
    CheckEquals('',lDate,'ref.');

    CheckEquals(ord(evt_Religion),ord(fparser.GetEntryType('luth.',lDate,lData)),'luth.');
    CheckEquals('luth.',lData,'luth.');
    CheckEquals('',lDate,'luth.');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry;
begin
    AddExpResult(['ParserIndiDate','01.02.1734','I3705C2',ord(evt_Birth)]);
    AddExpResult(['ParserIndiPlace','Bern','I3705C2',ord(evt_Birth)]);
    fparser.HandleNonPersonEntry('* 01.02.1734 in Bern','I3705C2');
    CheckEquals(2, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiDate','01.02.1734','I3705C3',ord(evt_Birth)]);
    AddExpResult(['ParserIndiPlace','Bern','I3705C3',ord(evt_Birth)]);
    fparser.HandleNonPersonEntry('* in Bern 01.02.1734','I3705C3');
    CheckEquals(4, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiPlace','Amerika','I3705C1',ord(evt_AddEmigration)]);
    AddExpResult(['ParserIndiData','ist nach Amerika ausgewandert','I3705C1',ord(evt_AddEmigration)]);
    fparser.HandleNonPersonEntry('ist nach Amerika ausgewandert','I3705C1');
    CheckEquals(6, FRCounter, 'FRcounter');

    fParser.DebugSetMsg('','1',8);
    AddExpResult(['ParserIndiDate','17.November 1851','I1',ord(evt_AddEmigration)]);
    AddExpResult(['ParserIndiPlace','Amerika','I1',ord(evt_AddEmigration)]);
    AddExpResult(['ParserIndiData','Die Familie ist am 17.November 1851 nach Amerika ausgewandert','I1',ord(evt_AddEmigration)]);
    fparser.HandleNonPersonEntry(' Die Familie ist am 17.November 1851 nach Amerika ausgewandert','I1');
    CheckEquals(9, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_6;
begin
    AddExpResult(['ParserIndiDate','24.12.1893','I30F',ord(evt_Birth)]);
    AddExpResult(['ParserIndiPlace','Lauck Kr. Preuß. Holland/Ostpreußen','I30F',ord(evt_Birth)]);
    fparser.HandleNonPersonEntry('  * in Lauck Kr. Preuß. Holland/Ostpreußen 24.12.1893','I30F');
    CheckEquals(2, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_div;
begin
    AddExpResult(['ParserIndiDate','','I30F',ord(evt_Divorce)]);
    fparser.HandleNonPersonEntry('o/o','I30F');
    CheckEquals(2, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_marr;
begin
    AddExpResult(['ParserStartFamily','30F','',0]);
    AddExpResult(['ParserFamilyIndiv','I30F','30F',1]);
    AddExpResult(['ParserFamilyPlace','Plobsheim/Elsaß','30F',ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭ in Plobsheim/Elsaß','I30F');
    CheckEquals(3, FRCounter, 'FRcounter');

    AddExpResult(['ParserStartFamily','30F','',0]);
    AddExpResult(['ParserFamilyIndiv','I30F','30F',1]);
    AddExpResult(['ParserFamilyDate','1948','30F',ord(evt_Marriage)]);
    AddExpResult(['ParserFamilyPlace','Nonnenweier','30F',ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭ 1948 in Nonnenweier','I30F');
    CheckEquals(7, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiDate','','I30F',ord(evt_Marriage)]);
    fparser.HandleNonPersonEntry('⚭in Plobsheim/Elsaß','I30F');
    CheckEquals(9, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_Res;
begin
    AddExpResult(['ParserIndiPlace','Dundenheim','I11',ord(evt_Residence)]);
    fparser.HandleNonPersonEntry('in Dundenheim','I11');
    CheckEquals(1, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiPlace','Dundenheim','I11',ord(evt_Residence)]);
    fparser.HandleNonPersonEntry('aus Dundenheim','I11');
    CheckEquals(2, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiPlace','"Spieng in der Herrschaft Bern/Schweiz"','I11',ord(evt_Residence)]);
    fparser.HandleNonPersonEntry('aus "Spieng in der Herrschaft Bern/Schweiz"','I11');
    CheckEquals(3, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiPlace','Illkirch','I30F',ord(evt_Residence)]);
    AddExpResult(['ParserIndiData','wohnhaft','I30F',ord(evt_Residence)]);
    fparser.HandleNonPersonEntry(' wohnhaft in Illkirch','I30F');
    CheckEquals(5, FRCounter, 'FRcounter');

end;

procedure TTestFBEntryParser.TestHandleAKPersonEntry;
var
  oLastname: string;
  oPSex: char;
begin
    AddExpResult(['ParserFamilyType','','123',1]);
    AddExpResult(['ParserIndiName','Hilda Wasmer','I123F',0]);
    AddExpResult(['ParserFamilyIndiv','I123F','123',2]);
    // {ETYPE = 'ParserFamilyIndiv', DATA = 'I123F', REF = '123', SUBTYPE = 1}
    AddExpResult(['ParserIndiData','F','I123F',ord(evt_Sex)]);
    CheckEquals('I123F',fparser.HandleAKPersonEntry('Hilda Röder geb.Wasmer','123','U',5,oLastname,oPSex),'Hilda Röder 1');
    CheckEquals('Wasmer', oLastname, 'LastName1');
    CheckEquals('F', oPSex, 'pSex1');
    CheckEquals(4, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName','Peter Mayer','I123M',0]);
    AddExpResult(['ParserIndiName','Dr. theol.','I123M',4]);
    AddExpResult(['ParserFamilyIndiv','I123M','123',1]);
    AddExpResult(['ParserIndiData','M','I123M',ord(evt_Sex)]);
    CheckEquals('I123M',fparser.HandleAKPersonEntry('Dr. theol.Peter Mayer','123','U',5,oLastname,oPSex),'Dr. theol.Peter Mayer 2');
    CheckEquals('Mayer', oLastname, 'LastName2');
    CheckEquals('M', oPSex, 'pSex2');
    CheckEquals(8, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName','Hans-Peter Schulze','I123M',0]);
    AddExpResult(['ParserFamilyIndiv','I123M','123',1]);
    AddExpResult(['ParserIndiData','M','I123M',ord(evt_Sex)]);
    CheckEquals('I123M',fparser.HandleAKPersonEntry('Hans-Peter Schulze','123','U',5,oLastname,oPSex),'Hans-Peter Schulze 3');
    CheckEquals('Schulze', oLastname, 'LastName3');
    CheckEquals('M', oPSex, 'pSex3');
    CheckEquals(11, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName','... Zarau','I123U',0]);
    AddExpResult(['ParserFamilyIndiv','I123U','123',1]);
    AddExpResult(['ParserIndiData','U','I123U',ord(evt_Sex)]);
    CheckEquals('I123U',fparser.HandleAKPersonEntry('... Zarau','123','U',5,oLastname,oPSex),'... Zarau 4');
    CheckEquals('Zarau', oLastname, 'LastName4');
    CheckEquals('U', oPSex, 'pSex3');
    CheckEquals(14, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName','Kind Arni','I123U',0]);
    AddExpResult(['ParserFamilyIndiv','I123U','123',1]);
    AddExpResult(['ParserIndiData','U','I123U',ord(evt_Sex)]);
    CheckEquals('I123U',fparser.HandleAKPersonEntry('Kind Arni','123','U',5,oLastname,oPSex),'Kind Arni 5');
    CheckEquals('Arni', oLastname, 'LastName5');
    CheckEquals('U', oPSex, 'pSex3');
    CheckEquals(17, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName','Dorothea Locher','I58F',0]);
    AddExpResult(['ParserFamilyIndiv','I58F','58',2]);
    AddExpResult(['ParserIndiData','F','I58F',ord(evt_Sex)]);
    AddExpResult(['ParserIndiName','?','I58F',3]);
    CheckEquals('I58F',fparser.HandleAKPersonEntry('Dorothea Locher','58','F',7,oLastname,oPSex,'?'),'Dorothea Locher 6');
    CheckEquals('Locher', oLastname, 'LastName6');
    CheckEquals('F', oPSex, 'pSex6');
    CheckEquals(21, FRCounter, 'FRcounter');

    AddExpResult(['ParserIndiName','Hans Friedrich Roth','I321M',0]);
    AddExpResult(['ParserFamilyIndiv','I321M','321',1]);
    AddExpResult(['ParserIndiData','M','I321M',ord(evt_Sex)]);
    CheckEquals('I321M',fparser.HandleAKPersonEntry('Hans Friedrich  Roth','321','U',5,oLastname,oPSex),'Hans Friedrich  Roth 6');
    CheckEquals('Roth', oLastname, 'LastName6');
    CheckEquals('M', oPSex, 'pSex6');
    CheckEquals(24, FRCounter, 'FRcounter');
end;

procedure TTestFBEntryParser.TestHandleAKPersonEntry_55;
var
  oLastname: string;
  oPSex: char;
begin
  AddExpResult(['ParserIndiName','Andres Acherer','I123M',0]);
  AddExpResult(['ParserFamilyIndiv','I123M','123',1]);
  // {ETYPE = 'ParserFamilyIndiv', DATA = 'I123F', REF = '123', SUBTYPE = 1}
  AddExpResult(['ParserIndiData','M','I123M',ord(evt_Sex)]);
  CheckEquals('I123M',fparser.HandleAKPersonEntry('Andres A. ','123','U',55,oLastname,oPSex,'','Acherer'),'Andres A. 1');
  CheckEquals('Acherer', oLastname, 'LastName1');
  CheckEquals('M', oPSex, 'pSex1');
  CheckEquals(3, FRCounter, 'FRcounter');

  AddExpResult(['ParserIndiName','Peter Mayer','I123M',0]);
  AddExpResult(['ParserIndiName','Dr. theol.','I123M',4]);
  AddExpResult(['ParserFamilyIndiv','I123M','123',1]);
  AddExpResult(['ParserIndiData','M','I123M',ord(evt_Sex)]);
  CheckEquals('I123M',fparser.HandleAKPersonEntry('Dr. theol.Peter M.','123','U',55,oLastname,oPSex, '', 'Mayer'),'Dr. theol.Peter Mayer 2');
  CheckEquals('Mayer', oLastname, 'LastName2');
  CheckEquals('M', oPSex, 'pSex2');
  CheckEquals(7, FRCounter, 'FRcounter');

  AddExpResult(['ParserIndiName','Hans-Peter Schulze','I123M',0]);
  AddExpResult(['ParserFamilyIndiv','I123M','123',1]);
  AddExpResult(['ParserIndiData','M','I123M',ord(evt_Sex)]);
  CheckEquals('I123M',fparser.HandleAKPersonEntry('Hans-Peter Sch.','123','U',55,oLastname,oPSex,'','Schulze'),'Hans-Peter Schulze 3');
  CheckEquals('Schulze', oLastname, 'LastName3');
  CheckEquals('M', oPSex, 'pSex3');
  CheckEquals(10, FRCounter, 'FRcounter');

  AddExpResult(['ParserIndiName','Erna Martha Geriger','I123F',0]);
  AddExpResult(['ParserFamilyIndiv','I123F','123',2]);
  AddExpResult(['ParserIndiData','F','I123F',ord(evt_Sex)]);
  AddExpResult(['ParserIndiName','? Geriger','I123F',3]);
  CheckEquals('I123F',fparser.HandleAKPersonEntry('Erna Martha','123','U',55,oLastname,oPSex,'? G.','Geriger'),'Erna Martha Geriger 4');
  CheckEquals('Geriger', oLastname, 'LastName4');
  CheckEquals('F', oPSex, 'pSex4');
  CheckEquals(14, FRCounter, 'FRcounter');

  AddExpResult(['ParserIndiName','Martin Eich','I123M',0]);
  AddExpResult(['ParserFamilyIndiv','I123M','123',1]);
  AddExpResult(['ParserIndiData','M','I123M',ord(evt_Sex)]);
  AddExpResult(['ParserIndiName','? Eich','I123M',3]);
  CheckEquals('I123M',fparser.HandleAKPersonEntry('Martin','123','U',55,oLastname,oPSex,'E.','Eich'),'Martin Eich 5');
  CheckEquals('Eich', oLastname, 'LastName5');
  CheckEquals('M', oPSex, 'pSex5');
  CheckEquals(18, FRCounter, 'FRcounter');

end;

procedure TTestFBEntryParser.TestHandleNonPersonEntry_57;

begin
  // {ETYPE = 'ParserStartFamily', DATA = '3C1', REF = 0x0, SUBTYPE = 0}
  AddExpResult(['ParserStartFamily', '3C1', '',  0]);
  //
  AddExpResult(['ParserFamilyIndiv','I3C1','3C1',1]);
  // {ETYPE = 'ParserFamilyIndiv', DATA = 'I123F', REF = '123', SUBTYPE = 1}
  AddExpResult(['ParserFamilyPlace','Neureuth','3C1',ord(evt_Marriage)]);
  CheckEquals(ord(evt_Marriage),ord(fparser.HandleNonPersonEntry('oo in Neureuth','I3C1')),'oo in Neureuth');
  CheckEquals(3, FRCounter, 'FRcounter');
end;
procedure TTestFBEntryParser.TestHandleAKPersonEntry_56;
var
  oLastname: string;
  oPSex: char;
begin
  AddExpResult(['ParserFamilyType','',  '123', 1]);
  AddExpResult(['ParserIndiName','Andrea Acherer','I123F',0]);
  AddExpResult(['ParserFamilyIndiv','I123F','123',2]);
  // {ETYPE = 'ParserFamilyIndiv', DATA = 'I123F', REF = '123', SUBTYPE = 2}
  AddExpResult(['ParserIndiData','F','I123F',ord(evt_Sex)]);
  CheckEquals('I123F',fparser.HandleAKPersonEntry('Andrea geb.Acherer','123','F',56,oLastname,oPSex,'','Acherer'),'Andres A. 2');
  CheckEquals('Acherer', oLastname, 'LastName1');
  CheckEquals('F', oPSex, 'pSex1');
  CheckEquals(4, FRCounter, 'FRcounter');

  AddExpResult(['ParserIndiName','Petra Mayer','I123F',0]);
  AddExpResult(['ParserIndiName','Dr. theol.','I123F',4]);
  AddExpResult(['ParserFamilyIndiv','I123F','123',2]);
  AddExpResult(['ParserIndiData','F','I123F',ord(evt_Sex)]);
  CheckEquals('I123F',fparser.HandleAKPersonEntry('Dr. theol.Petra Mayer','123','F',56,oLastname,oPSex, '', 'Mayer'),'Dr. theol.Peter Mayer 2');
  CheckEquals('Mayer', oLastname, 'LastName2');
  CheckEquals('F', oPSex, 'pSex2');
  CheckEquals(8, FRCounter, 'FRcounter');

  AddExpResult(['ParserFamilyType','',  '123', 1]);
  AddExpResult(['ParserIndiName','Marie-Luise Schulze','I123F',0]);
  AddExpResult(['ParserFamilyIndiv','I123F','123',2]);
  AddExpResult(['ParserIndiData','F','I123F',ord(evt_Sex)]);
  CheckEquals('I123F',fparser.HandleAKPersonEntry('Marie-Luise geb.Schulze','123','F',56,oLastname,oPSex,'','Schulze'),'Hans-Peter Schulze 3');
  CheckEquals('Schulze', oLastname, 'LastName3');
  CheckEquals('F', oPSex, 'pSex3');
  CheckEquals(12, FRCounter, 'FRcounter');

  AddExpResult(['ParserFamilyType','',  '123', 1]);
  AddExpResult(['ParserIndiName','Erna Martha Duda','I123F',0]);
  AddExpResult(['ParserFamilyIndiv','I123F','123',2]);
  AddExpResult(['ParserIndiData','F','I123F',ord(evt_Sex)]);
  AddExpResult(['ParserIndiName','? geb. Duda','I123F',3]);
  CheckEquals('I123F',fparser.HandleAKPersonEntry('Erna Martha','123','F',56,oLastname,oPSex,'? geb.Duda','Geriger'),'Hans-Peter Schulze 3');
  CheckEquals('Duda', oLastname, 'LastName4');
  CheckEquals('F', oPSex, 'pSex4');
  CheckEquals(17, FRCounter, 'FRcounter');

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

procedure TTestFBEntryParserBase.AddExpResult(Data: array of variant);

begin
    setlength(ExpResults, high(ExpResults)+2);
    ExpResults[high(ExpResults)].SetAll(Data);
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

procedure TTestFBEntryParserBase.ParserStartFamily(Sender: TObject;
    aText, Ref: string; dsubtype: integer);
begin
    ParserTestEvent(Sender, 'ParserStartFamily', aText, Ref, dSubType);
end;

procedure TTestFBEntryParserBase.ParserError(Sender: TObject);
begin
    ParserTestEvent(Sender, 'ParserError!', TFBEntryParser(Sender).LastErr, TFBEntryParser(Sender).MainRef, TFBEntryParser(Sender).LastMode);
end;

procedure TTestFBEntryParserBase.ParserMessage(Sender: TObject;
  aType: TEventType; aText: string; Ref: string; aMode: integer);
begin
  case aType of
    etCustom: ParserTestEvent(Sender, 'ParserCustom', aText, Ref, aMode);
    etInfo: ParserTestEvent(Sender, 'ParserInfo', aText, Ref, aMode);
    etWarning: ParserTestEvent(Sender, 'ParserWarning', aText, Ref, aMode);
    etError: ParserTestEvent(Sender, 'ParserError!', aText, Ref, aMode);
    etDebug: ParserTestEvent(Sender, 'ParserDebugMsg', aText, Ref, aMode);
  end;
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
    lDebEv, {%H-}lLastDeb: string;
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

procedure TTestFBEntryParserBase.TestOneFile(aFilename:String;ff:TFileFoundEvent);
var
  lFileSearcher: TFileSearcher;
begin
  lFileSearcher := TFileSearcher.Create;
  if ff=nil then
    ff:=@FSFileFound;
   try
     lFileSearcher.OnFileFound := ff;
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
    fParser.onParseMessage:=@ParserMessage;
    FTestName := '';
    setlength(ExpResults,0);
    FRCounter := 0;
end;

procedure TTestFBEntryParserBase.TearDown;
begin
    FreeAndNil(fParser);
    setlength(FResult, 0);
end;


procedure TTestFBEntryParserAll.FSFileFound(FileIterator: TFileIterator);
var
  st: String;
begin
  st := ExtractFileName(FileIterator.Filename);
  if st.StartsWith('OsBM') then
    fParser.DefaultPlace:='Meißenheim'
  else
    fParser.DefaultPlace:='';
  inherited FSFileFound(FileIterator);
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
  fParser.DefaultPlace:='Meißenheim';
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

procedure TTestFBEntryParserAK.TestFileM1353;
begin
  // Children with discrete Marriages
  TestOneFile('OsBM1353.entTxt');
end;


initialization

    RegisterTest(TTestFBEntryParser);
    RegisterTest(TTestFBEntryParserAK);
    RegisterTest(TTestFBEntryParserGC);
    RegisterTest(TTestFBEntryParserAll);

end.
