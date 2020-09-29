unit tst_PicPasFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, unt_PicPasFile;

type

  { TTestPicPasFile }

  TTestPicPasFile= class(TTestCase)
  private
    FPicPasFile:TPicPasFile;
    FDataPath:string;
    Procedure GenerateTestData;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestTestData;
    procedure TestParseTestData;
    procedure TestParseLineForString;
    procedure TestQuotation;
    procedure TestSetData;
  public
    constructor Create; override;
  end;

implementation

const CDataPath = 'Data';
      CPicPasDir = 'PicPasTest';

      CTestData = '// TestData'+LineEnding+
        'Test := trans(''English'',''Spain'',''Quinero'','+LineEnding+
        '              ''Deutsch'', ''Ukrainian'',''Russian'', ''French'',''Chinese'');'+LineEnding+
        'chkVerMarPle.Caption := trans(''Show folding marks''     , ''Ver Marc.de plegado''         ,'''','+ LineEnding +
        '                    ''Klappbare Marken zeigen'', ''Показувати згортаючі мітки'',''Показывать сворачивающие метки'', ''Balises de'' + #13#10 + ''regroupement'',''显示折叠标记'');'+LineEnding+
        'HardTest := trans(''apostroph''''s'', ''komma, might'',''(Brackets) Test'',''Multiline '' + '+ LineEnding +
        '                    ''Texts'', ''Показувати згортаючі мітки'',''Показывать сворачивающие метки'', ''Balises de'' + #13#10 + ''regroupement'',''显示折叠标记'');'+LineEnding;

procedure TTestPicPasFile.TestSetUp;
begin
  CheckNotNull(FPicPasFile,'TestObject is assigned');
  CheckTrue(DirectoryExists(FDataPath),'Data-Directory exists');
end;

procedure TTestPicPasFile.TestTestData;
begin
  GenerateTestData;
  CheckEquals(CTestData,FPicPasFile.Lines.Text,'Test-Data (komplett)');
  CheckEquals(7,FPicPasFile.LineCount,'7 Lines');
  CheckEquals('// TestData',FPicPasFile.Line[0],'First Line');
  CheckEquals('Test := trans(''English'',''Spain'',''Quinero'',',FPicPasFile.Line[1],'Second Line');
  CheckEquals('              ''Deutsch'', ''Ukrainian'',''Russian'', ''French'',''Chinese'');',FPicPasFile.Line[2],'Third Line');
  CheckEquals('chkVerMarPle.Caption := trans(''Show folding marks''     , ''Ver Marc.de plegado''         ,'''',',FPicPasFile.Line[3],'Fourth Line');
  CheckEquals('                    ''Klappbare Marken zeigen'', ''Показувати згортаючі мітки'',''Показывать сворачивающие метки'', ''Balises de'' + #13#10 + ''regroupement'',''显示折叠标记'');',FPicPasFile.Line[4],'Fifth Line');
  CheckEquals('HardTest := trans(''apostroph''''s'', ''komma, might'',''(Brackets) Test'',''Multiline '' + ',FPicPasFile.Line[5],'Sixth Line');
  CheckEquals('                    ''Texts'', ''Показувати згортаючі мітки'',''Показывать сворачивающие метки'', ''Balises de'' + #13#10 + ''regroupement'',''显示折叠标记'');',FPicPasFile.Line[6],'Seventh Line');
end;

procedure TTestPicPasFile.TestParseTestData;
begin
  GenerateTestData;
  FPicPasFile.ParseFile;
  CheckEquals(3,FPicPasFile.TranslCount,'3 Items');
  CheckEquals('TestFile.Test',FPicPasFile.GetIdentifyer(0),'First Identifyer');
  CheckEquals('TestFile.chkVerMarPle.Caption',FPicPasFile.GetIdentifyer(1),'Second Identifyer');
  CheckEquals('TestFile.HardTest',FPicPasFile.GetIdentifyer(2),'Third Identifyer');
  CheckEquals('English',FPicPasFile.Translation[0,0],'First Translation Default Language');
  CheckEquals('English',FPicPasFile.Translation[0,1],'First Translation first Language');
  CheckEquals('Spain',FPicPasFile.Translation[0,2],'First Translation second Language');
  CheckEquals('Quinero',FPicPasFile.Translation[0,3],'First Translation third Language');
  CheckEquals('Deutsch',FPicPasFile.Translation[0,4],'First Translation fourth Language');
  CheckEquals('Ukrainian',FPicPasFile.Translation[0,5],'First Translation fifth Language');
  CheckEquals('Russian',FPicPasFile.Translation[0,6],'First Translation sixth Language');
  CheckEquals('French',FPicPasFile.Translation[0,7],'First Translation 7th Language');
  CheckEquals('Chinese',FPicPasFile.Translation[0,8],'First Translation 8th Language');
  CheckEquals('',FPicPasFile.Translation[0,9],'First Translation 9th Language');
  CheckEquals('Show folding marks',FPicPasFile.Translation[1,0],'Second Translation Default Language');
  CheckEquals('Show folding marks',FPicPasFile.Translation[1,1],'Second Translation First Language');
  CheckEquals('Ver Marc.de plegado',FPicPasFile.Translation[1,2],'Second Translation second Language');
  CheckEquals('',FPicPasFile.Translation[1,3],'Second Translation third Language');
  CheckEquals('Klappbare Marken zeigen',FPicPasFile.Translation[1,4],'Second Translation fourth Language');
  CheckEquals('Показувати згортаючі мітки',FPicPasFile.Translation[1,5],'Second Translation fifth Language');
  CheckEquals('Показывать сворачивающие метки',FPicPasFile.Translation[1,6],'Second Translation sixth Language');
  CheckEquals('Balises de'#13#10'regroupement',FPicPasFile.Translation[1,7],'Second Translation 7th Language');
  CheckEquals('显示折叠标记',FPicPasFile.Translation[1,8],'Second Translation 8th Language');
  CheckEquals('',FPicPasFile.Translation[1,9],'Second Translation 9th Language');
  CheckEquals('apostroph''s',FPicPasFile.Translation[2,0],'Third Translation Default Language');
  CheckEquals('apostroph''s',FPicPasFile.Translation[2,1],'Third Translation First Language');
  CheckEquals('komma, might',FPicPasFile.Translation[2,2],'Third Translation Second Language');
  CheckEquals('(Brackets) Test',FPicPasFile.Translation[2,3],'Third Translation third Language');
  CheckEquals('Multiline Texts',FPicPasFile.Translation[2,4],'Third Translation fourth Language');
  CheckEquals('Показувати згортаючі мітки',FPicPasFile.Translation[2,5],'Third Translation fifth Language');
  CheckEquals('Показывать сворачивающие метки',FPicPasFile.Translation[2,6],'Third Translation sixth Language');
  CheckEquals('Balises de'#13#10'regroupement',FPicPasFile.Translation[2,7],'Third Translation 7th Language');
  CheckEquals('显示折叠标记',FPicPasFile.Translation[2,8],'Third Translation 8th Language');
  CheckEquals('',FPicPasFile.Translation[2,9],'Third Translation 9th Language');
end;

procedure TTestPicPasFile.TestParseLineForString;
var
  Line, idLang: Integer;
  Idnt: string;
  AoI: TIdxArray;
  lIdx: integer;
begin
  GenerateTestData;
  Line := 4;
  lIdx := pos(',',FPicPasFile.Line[4],105)+1;
  idLang := 7;
  CheckEquals(2,FPicPasFile.ParseLineForString(Line,idLang,1,lIdx,AoI,Idnt));
  CHeckEquals('Balises de'#13#10'regroupement',Idnt,'Parsed Ident');
  CHeckEquals(4,Line,'Line1');
  CHeckEquals(202,lIdx,'Index1');
  CHeckEquals(8,idLang,'Lang1');
  CHeckEquals(0,high(AoI),'Aoi1');
  CHeckEquals('Balises de'#13#10'regroupement',AoI[0].iStr,'Aoi[0]');
  CHeckEquals(163,AoI[0].iStartOffset,'Aoi[0].iStartOffset');
  CHeckEquals(201,AoI[0].iEndOffset,'Aoi[0].iEndOffset');

  Line := 5;
  lIdx := pos(',',FPicPasFile.Line[5],50)+1;
  idLang := 3;
  CheckEquals(2,FPicPasFile.ParseLineForString(Line,idLang,1,lIdx,AoI,Idnt));
  CHeckEquals('Multiline Texts',Idnt,'Parsed Ident2');
  CHeckEquals(6,Line,'Line2');
  CHeckEquals(29,lIdx,'Index2');
  CHeckEquals(4,idLang,'lang1');
  CHeckEquals(1,high(AoI),'Aoi2');
  CHeckEquals('Multiline Texts',AoI[1].iStr,'Aoi[1]');
  CHeckEquals(68,AoI[1].iStartOffset,'Aoi[1].iStartOffset');
  CHeckEquals(28,AoI[1].iEndOffset,'Aoi[1].iEndOffset');

  CheckEquals(2,FPicPasFile.ParseLineForString(Line,idLang,1,lIdx,AoI,Idnt));
  CHeckEquals('Показувати згортаючі мітки',Idnt,'Parsed Ident3');
  CHeckEquals(6,Line,'Line3');
  CHeckEquals(83,lIdx,'Index3');
  CHeckEquals(5,idLang,'lang3');
  CHeckEquals(2,high(AoI),'Aoi3');
  CHeckEquals('Показувати згортаючі мітки',AoI[2].iStr,'Aoi[2]');
  CHeckEquals(30,AoI[2].iStartOffset,'Aoi[2].iStartOffset');
  CHeckEquals(82,AoI[2].iEndOffset,'Aoi[2].iEndOffset');

  CheckEquals(2,FPicPasFile.ParseLineForString(Line,idLang,1,lIdx,AoI,Idnt));
  CHeckEquals('Показывать сворачивающие метки',Idnt,'Parsed Ident4');
  CHeckEquals(6,Line,'Line4');
  CHeckEquals(144,lIdx,'Index4');
  CHeckEquals(6,idLang,'lang4');
  CHeckEquals(3,high(AoI),'Aoi4');
  CHeckEquals('Показывать сворачивающие метки',AoI[3].iStr,'Aoi[3]');
  CHeckEquals(83,AoI[3].iStartOffset,'Aoi[3].iStartOffset');
  CHeckEquals(143,AoI[3].iEndOffset,'Aoi[3].iEndOffset');
end;

procedure TTestPicPasFile.TestQuotation;
begin
  CheckEquals('''English''',TPicPasFile.QuotedStr2('English'),'QuotedStr2(''English'')');
  CheckEquals('#13',TPicPasFile.QuotedStr2(#13),'QuotedStr2(#13)');
  CheckEquals('''Eng-''+#13#10+''lish''',TPicPasFile.QuotedStr2('Eng-'#13#10'lish'),'QuotedStr(''Eng-''#13#10''lish'')');
  CheckEquals('''#13+#''+#13#10+''#8+#''',TPicPasFile.QuotedStr2('#13+#'#13#10'#8+#'),'QuotedStr(''Eng-''#13#10''lish'')');
end;

procedure TTestPicPasFile.TestSetData;
begin
  GenerateTestData;
  FPicPasFile.ParseFile;
  CheckFalse(FPicPasFile.Changed,'File is not Changed');
  FPicPasFile.Translation[0,1] := 'This is english';
  CheckEquals('Test := trans(''This is english'',''Spain'',''Quinero'',',FPicPasFile.Lines[1] ,'Set First Translation first Language');
  CheckTrue(FPicPasFile.Changed,'File is Changed');
  FPicPasFile.Translation[0,2] := 'This is spanish';
  CheckEquals('Test := trans(''This is english'',''This is spanish'',''Quinero'',',FPicPasFile.Lines[1] ,'Set First Translation second Language');
  FPicPasFile.Translation[0,3] := 'This is something';
  CheckEquals('Test := trans(''This is english'',''This is spanish'',''This is something'',',FPicPasFile.Lines[1] ,'Set First Translation third Language');
  CheckEquals('              ''Deutsch'', ''Ukrainian'',''Russian'', ''French'',''Chinese'');',FPicPasFile.Lines[2] ,'Set First Translation third Language2');
  FPicPasFile.Translation[0,4] := 'This is german';
  CheckEquals('Test := trans(''This is english'',''This is spanish'',''This is something'',',FPicPasFile.Lines[1] ,'Set First Translation third Language');
  CheckEquals('              ''This is german'', ''Ukrainian'',''Russian'', ''French'',''Chinese'');',FPicPasFile.Lines[2] ,'Set First Translation third Language2');
  FPicPasFile.Translation[0,5] := 'This is ukrainian';
  CheckEquals('              ''This is german'', ''This is ukrainian'',''Russian'', ''French'',''Chinese'');',FPicPasFile.Lines[2] ,'Set First Translation third Language2');
  FPicPasFile.Translation[0,6] := 'This is russian';
  CheckEquals('              ''This is german'', ''This is ukrainian'',''This is russian'', ''French'',''Chinese'');',FPicPasFile.Lines[2] ,'Set First Translation third Language2');
  FPicPasFile.Translation[0,7] := 'This is french';
  CheckEquals('              ''This is german'', ''This is ukrainian'',''This is russian'', ''This is french'',''Chinese'');',FPicPasFile.Lines[2] ,'Set First Translation third Language2');
  FPicPasFile.Translation[0,8] := 'This is chinese';
  CheckEquals('              ''This is german'', ''This is ukrainian'',''This is russian'', ''This is french'',''This is chinese'');',FPicPasFile.Lines[2] ,'Set First Translation third Language2');
  FPicPasFile.Translation[0,9] := 'This is italian';
  CheckEquals('Test := trans(''This is english'',''This is spanish'',''This is something'',',FPicPasFile.Lines[1] ,'Set First Translation third Language');
  CheckEquals('              ''This is german'', ''This is ukrainian'',''This is russian'', ''This is french'',''This is chinese'',''This is italian'');',FPicPasFile.Lines[2] ,'Set First Translation last Language2');
  CheckEquals('chkVerMarPle.Caption := trans(''Show folding marks''     , ''Ver Marc.de plegado''         ,'''',',FPicPasFile.Line[3],'Fourth Line');
  CheckEquals('This is italian',FPicPasFile.Translation[0,9],'First Translation 9th Language');
  FPicPasFile.Translation[0,9] := 'This is not italian';
  CheckEquals('Test := trans(''This is english'',''This is spanish'',''This is something'',',FPicPasFile.Lines[1] ,'Set First Translation third Language');
  CheckEquals('              ''This is german'', ''This is ukrainian'',''This is russian'', ''This is french'',''This is chinese'',''This is not italian'');',FPicPasFile.Lines[2] ,'Set First Translation last Language3');
  CheckEquals('chkVerMarPle.Caption := trans(''Show folding marks''     , ''Ver Marc.de plegado''         ,'''',',FPicPasFile.Line[3],'Fourth Line');
  CheckEquals('This is not italian',FPicPasFile.Translation[0,9],'First Translation 9th Language');
end;

procedure TTestPicPasFile.GenerateTestData;
begin
  FPicPasFile.SetFileName('c:\test\PicPas\language\tra_TestFile.pas');
  FPicPasFile.Lines.Text:=CTestData;
  FPicPasFile.ClearChanged;
end;

procedure TTestPicPasFile.SetUp;
begin
  FPicPasFile := TPicPasFile.Create(nil);
end;

procedure TTestPicPasFile.TearDown;
begin
  Freeandnil(FPicPasFile);
end;

constructor TTestPicPasFile.Create;
  var
    i: Integer;

  begin
    inherited Create;
    FDataPath := CDatapath;
    for i := 0 to 2 do
      if not DirectoryExists(FDataPath) then
        FDataPath := '..' + DirectorySeparator+ FDataPath
      else
        Break;
    FDataPath := FDataPath + DirectorySeparator + 'PicPasTest';
    ForceDirectories(FDataPath);
end;

initialization

  RegisterTest(TTestPicPasFile);
end.

