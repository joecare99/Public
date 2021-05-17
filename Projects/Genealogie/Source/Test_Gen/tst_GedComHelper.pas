unit tst_GedComHelper;

{$mode objfpc}{$H+}

{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}

interface

uses
    Classes, SysUtils, FileUtil, fpcunit, testutils, testregistry,
    Cmp_GedComFile, cls_GedComHelper, unt_IGenBase2;

type

    { TTestGedComHelper }

    TTestGedComHelper = class(TTestCase)
    private
        FGedComFile   :TGedComFile;
        FGedComHelper :TGedComHelper;
        FDataPath     :string;
        procedure FSFileFound(FileIterator :TFileIterator);
        procedure FSFileFoundComb(FileIterator :TFileIterator);
        procedure HelperMessage(Sender: TObject; aType: TEventType;
          aText: string; Ref: string; aMode: integer);
        procedure ReplayExpResult(st :TStrings);
        procedure TestFilesInt(aFilename :string; OnFileFound :TFileFoundEvent);
        Procedure
    protected;
        procedure SetUp; override;
        procedure TearDown; override;
    published
        procedure TestSetUp;
        procedure TestParserOutp3b;
        procedure TestParserOutp1b;
        procedure TestDateModifRepl;
        procedure TestFiles;
        procedure TestFile50;
        procedure TestFileM407;
        procedure TestFile51;
        procedure TestFileM2420;
        procedure TestFilesComb;
        procedure TestFile50_51;
        procedure TestFile51_52;
        procedure TestFile52_54;
        procedure TestFile52_51_50;
        procedure TestFile411_1193;
        procedure TestFiles5939ff;
    public
        constructor Create; override;
    end;

implementation


uses unt_GenTestBase;

procedure TTestGedComHelper.TestSetUp;
begin
    CheckNotNull(FGedComFile, 'FGedComFile is assigned');
    CheckNotNull(FGedComHelper, 'FGedComHelper is assigned');
    CheckNotNull(FGedComHelper.GedComFile, 'FGedComHelper.GedComFile is assigned');
    checktrue(DirectoryExists(FDataPath), 'DataPath exists');
end;

procedure TTestGedComHelper.TestParserOutp3b;
var
    lStr :TStringList;
begin
    with FGedComHelper do
      begin
        CreateNewHeader('dummy.ged');
        CitTitle := 'Pg. 1';

        lStr     := TStringList.Create;
        Citation := lStr;
          try
            Citation.Text :=
                '3 Adam, Johann Georg, lu. <Adam, Georg, lu.>, * (err) 09.07.1734 in Obrigheim. † ... in Obrigheim, = 12.07.1734 in Obrigheim.' + LineEnding + 'PN = 49671 ';
            StartFamily(self, '3', '', 0);
            IndiName(self, 'Adam', 'I3U', 1);
            FamilyIndiv(self, 'I3U', '3', 1);
            IndiName(self, 'Johann Georg', 'I3U', 2);
            IndiData(self, 'lu.', 'I3U', 8);
            StartFamily(self, '3U', '', 0);
            FamilyIndiv(self, 'I3U', '3U', 3);
            IndiName(self, 'Adam', 'I3UM', 1);
            FamilyIndiv(self, 'I3UM', '3U', 1);
            IndiName(self, 'Georg', 'I3UM', 2);
            IndiData(self, 'lu.', 'I3UM', 8);
            IndiDate(self, '(err) 09.07.1734', 'I3U', 1);
            IndiPlace(self, 'Obrigheim', 'I3U', 1);
            IndiDate(self, '12.07.1734', 'I3U', 5);
            IndiPlace(self, 'Obrigheim', 'I3U', 5);
            IndiRef(self, '49671', 'I3U', 0);
            SaveToFile(FDataPath + DirectorySeparator + 'FBObr0003b.ged');
          finally
            FreeAndNil(lStr)
          end;

      end;
end;

procedure TTestGedComHelper.TestParserOutp1b;
var
    lSt, lRs :TStrings;

const
    FileName = 'EntryGC0001.entTxt';
begin
    lst := TStringList.Create;
    lRs := TStringList.Create;
      try
        lSt.LoadFromFile(FDataPath + DirectorySeparator + FileName);
        if FileExists(FDataPath + DirectorySeparator + ChangeFileExt(FileName, '.entExp')) then
            lRs.LoadFromFile(FDataPath + DirectorySeparator + ChangeFileExt(FileName, '.entExp'));
        FGedComHelper.FGedComFile.Clear;
        FGedComHelper.Citation := lSt;
        FGedComHelper.CitTitle := 'Pg. 1';
        FGedComHelper.CreateNewHeader('Dummy');
        ReplayExpResult(lRs);
      finally
        FreeAndNil(lSt);
        FreeAndNil(lRs);
      end;
end;

procedure TTestGedComHelper.TestDateModifRepl;
begin
    CheckEquals('EST 1980', FGedComHelper.RplGedTags('(s) 1980'), '(s) 1980');
    CheckEquals('CAL 1980', FGedComHelper.RplGedTags('(err) 1980'), '(err) 1980');
    CheckEquals('BEF 1980', FGedComHelper.RplGedTags('vor 1980'), 'vor 1980');
    CheckEquals('AFT 1980', FGedComHelper.RplGedTags('nach 1980'), 'nach 1980');
    CheckEquals('AFT 1980', FGedComHelper.RplGedTags('seit 1980'), 'seit 1980');
    CheckEquals('ABT 1980', FGedComHelper.RplGedTags('ca 1980'), 'ca 1980');
    CheckEquals('ABT. 1980', FGedComHelper.RplGedTags('ca. 1980'), 'ca. 1980');
end;

procedure TTestGedComHelper.TestFiles;
begin
    TestFilesInt('*.enttxt', @FSFileFound);
end;

procedure TTestGedComHelper.TestFile50;
const
    CEntTxtFile = 'EntryGC0050.enttxt';
    CExpTags    = 8;
    CExpFam    = '@F50@ FAM';
    CExpInode  =  '@I50M@';
    CExpIndi    = 'I: Anton Assel, M, E: born: ABT. 1780';

begin
    TestFilesInt(CEntTxtFile, @FSFileFound);
    CheckEquals(CexpTags, FGedComFile.Count, 'Tags after ' + string(
        ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals('@SUBM@ SUBM', FGedComFile.Child[1].ToString, '[1].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpFam, FGedComFile.Child[2].ToString, '[2].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals('@S1@ SOUR', FGedComFile.Child[3].ToString, '[3].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpInode, FGedComFile.Child[4].NodeID, '[4].NodeID ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpIndi, FGedComFile.Child[4].ToString, '[4].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
end;

procedure TTestGedComHelper.TestFileM407;
const
    CEntTxtFile = 'OsBM0407.enttxt';
    CExpTags    = 11;
    CExpFam    = '@F405@ FAM';
    CExpInode  =  '@I405M@';
    CExpIndi    = 'I: Jakob Finzer, M, E: born: 5.8.1895 in Nußloch bei Heidelberg';

begin
    TestFilesInt(CEntTxtFile, @FSFileFound);
    CheckEquals(CexpTags, FGedComFile.Count, 'Tags after ' + string(
        ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals('@SUBM@ SUBM', FGedComFile.Child[1].ToString, '[1].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpFam, FGedComFile.Child[2].ToString, '[2].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals('@S1@ SOUR', FGedComFile.Child[3].ToString, '[3].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpInode, FGedComFile.Child[4].NodeID, '[4].NodeID ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpIndi, FGedComFile.Child[4].ToString, '[4].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
end;

procedure TTestGedComHelper.TestFile51;
const
    CEntTxtFile = 'EntryGC0051.enttxt';
    CExpTags    = 18;
    CExpFam    = '@F51@ FAM';
    CExpInode  =  '@I51M@';
    CExpIndi    = 'I: Johann Peter Assel, M, E: born: 17.08.1799 in Asbach';

begin
    TestFilesInt(CEntTxtFile, @FSFileFound);
    CheckEquals(CexpTags, FGedComFile.Count, 'Tags after ' + string(
        ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals('@SUBM@ SUBM', FGedComFile.Child[1].ToString,
        '[1].ToString ' + string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpFam, FGedComFile.Child[2].ToString, '[2].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals('@S1@ SOUR', FGedComFile.Child[3].ToString,
        '[3].ToString ' + string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpInode, FGedComFile.Child[4].NodeID, '[4].NodeID ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpIndi, FGedComFile.Child[4].ToString, '[4].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
end;

procedure TTestGedComHelper.TestFileM2420;
const
    CEntTxtFile = 'OsBM2420.enttxt';
    CExpTags    = 8;
    CExpFam    = '@F2420@ FAM';
    CExpInode    = '@I2420M@';
    CExpIndi    = 'I: Bartholomäus Rosewich, M';

begin
    TestFilesInt(CEntTxtFile, @FSFileFound);
    CheckEquals(CexpTags, FGedComFile.Count, 'Tags after ' + string(
        ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals('@SUBM@ SUBM', FGedComFile.Child[1].ToString,
        '[1].ToString ' + string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpFam, FGedComFile.Child[2].ToString, '[2].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals('@S1@ SOUR', FGedComFile.Child[3].ToString,
        '[3].ToString ' + string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpInode, FGedComFile.Child[4].NodeID, '[4].NodeID ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
    CheckEquals(CExpIndi, FGedComFile.Child[4].ToString, '[4].ToString ' +
        string(ExtractFileName(CEntTxtFile)).QuotedString('"'));
end;


procedure TTestGedComHelper.TestFilesComb;

begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt('*.enttxt', @FSFileFoundComb);

    if FileExists(FDataPath + DirectorySeparator + 'Entry0001ff.New.Ged') then
        DeleteFile(FDataPath + DirectorySeparator + 'Entry0001ff.New.Ged');
    FGedComHelper.SaveToFile(FDataPath + DirectorySeparator + 'Entry0001ff.New.Ged');
end;

procedure TTestGedComHelper.TestFile50_51;

const
    FileName1 = 'EntryGC0050.enttxt';
    FileName2 = 'EntryGC0051.enttxt';

begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt(FileName1, @FSFileFoundComb);
    CheckEquals(7, FGedComFile.Count, 'Tags after ' + FileName1.QuotedString('"'));
    TestFilesInt(FileName2, @FSFileFoundComb);
    CheckEquals(20, FGedComFile.Count, 'Tags after ' + FileName2.QuotedString('"'));

    if FileExists(FDataPath + DirectorySeparator + ChangeFileExt(
        FileName1, 'ff.New.Ged')) then
        DeleteFile(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, 'ff.New.Ged'));
    FGedComHelper.SaveToFile(FDataPath + DirectorySeparator + ChangeFileExt(
        FileName1, 'ff.New.Ged'));

end;

procedure TTestGedComHelper.TestFile51_52;

const
    FileName1 = 'EntryGC0051.enttxt';
    FileName2 = 'EntryGC0052.enttxt';

begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt(FileName1, @FSFileFoundComb);
    CheckEquals(17, FGedComFile.Count, 'Tags after ' + FileName1.QuotedString('"'));

    TestFilesInt(FileName2, @FSFileFoundComb);
    CheckEquals(22, FGedComFile.Count, 'Tags after ' + FileName2.QuotedString('"'));

    if FileExists(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, 'ff.New.Ged')) then
        DeleteFile(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, 'ff.New.Ged'));
    FGedComHelper.SaveToFile(FDataPath + DirectorySeparator + ChangeFileExt(
        FileName1, 'ff.New.Ged'));

end;

procedure TTestGedComHelper.TestFile52_54;

const
    FileName1 = 'EntryGC0052.enttxt';
    FileName2 = 'EntryGC0054.enttxt';

begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt(FileName1, @FSFileFoundComb);
    CheckEquals(9, FGedComFile.Count, 'Tags after ' + FileName1.QuotedString('"'));
    TestFilesInt(FileName2, @FSFileFoundComb);
    CheckEquals(13, FGedComFile.Count, 'Tags after ' + FileName2.QuotedString('"'));

    if FileExists(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, '_ff.New.Ged')) then
        DeleteFile(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, '_ff.New.Ged'));
    FGedComHelper.SaveToFile(FDataPath + DirectorySeparator + ChangeFileExt(
        FileName1, '_ff.New.Ged'));
end;

procedure TTestGedComHelper.TestFile52_51_50;
const
    FileName1 = 'EntryGC0052.enttxt';
    FileName2 = 'EntryGC0051.enttxt';
    FileName3 = 'EntryGC0050.enttxt';

begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt(FileName1, @FSFileFoundComb);
    CheckEquals(9, FGedComFile.Count, 'Tags after ' + FileName1.QuotedString('"'));
    TestFilesInt(FileName2, @FSFileFoundComb);
    CheckEquals(22, FGedComFile.Count, 'Tags after ' + FileName2.QuotedString('"'));
    TestFilesInt(FileName3, @FSFileFoundComb);
    CheckEquals(25, FGedComFile.Count, 'Tags after ' + FileName3.QuotedString('"'));

    if FileExists(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, 'rr.New.Ged')) then
        DeleteFile(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, 'rr.New.Ged'));
    FGedComHelper.SaveToFile(FDataPath + DirectorySeparator + ChangeFileExt(
        FileName1, 'rr.New.Ged'));

end;

procedure TTestGedComHelper.TestFile411_1193;
const
    FileName1 = 'OsBM0411.enttxt';
    FileName2 = 'OsBM1193.enttxt';

begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt(FileName1, @FSFileFoundComb);
    CheckEquals(15, FGedComFile.Count, 'Tags after ' + FileName1.QuotedString('"'));
    TestFilesInt(FileName2, @FSFileFoundComb);
    CheckEquals(21, FGedComFile.Count, 'Tags after ' + FileName2.QuotedString('"'));

    if FileExists(FDataPath + DirectorySeparator + ChangeFileExt(
        FileName1, 'ff.New.Ged')) then
        DeleteFile(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, 'ff.New.Ged'));
    FGedComHelper.SaveToFile(FDataPath + DirectorySeparator + ChangeFileExt(
        FileName1, 'ff.New.Ged'));
end;

procedure TTestGedComHelper.TestFiles5939ff;
const
    FileName1 = 'OsbObr5939.enttxt';
    FileName2 = 'OsbObr5942.enttxt';
    FileName3 = 'OsbObr5943.enttxt';

begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt(FileName1, @FSFileFoundComb);
    CheckEquals(10, FGedComFile.Count, 'Tags after ' + FileName1.QuotedString('"'));
    TestFilesInt(FileName2, @FSFileFoundComb);
    CheckEquals(14, FGedComFile.Count, 'Tags after ' + FileName2.QuotedString('"'));
    TestFilesInt(FileName3, @FSFileFoundComb);
    CheckEquals(22, FGedComFile.Count, 'Tags after ' + FileName3.QuotedString('"'));

    if FileExists(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, '_ff.New.Ged')) then
        DeleteFile(FDataPath + DirectorySeparator + ChangeFileExt(FileName1, '_ff.New.Ged'));
    FGedComHelper.SaveToFile(FDataPath + DirectorySeparator + ChangeFileExt(
        FileName1, 'rr.New.Ged'));

end;

constructor TTestGedComHelper.Create;
var
    i :integer;
begin
    inherited Create;
    FDataPath := GetDataPath('GenData');
end;

procedure TTestGedComHelper.ReplayExpResult(st :TStrings);
var
    i :integer;
begin
    if st.Count = 0 then
        exit;
    for i := 1 to st.Count - 1 do
        FGedComHelper.FireEvent(self, st[i].Split([#9]));
end;

procedure TTestGedComHelper.TestFilesInt(aFilename :string; OnFileFound :TFileFoundEvent);
var
    lFileSearcher :TFileSearcher;
begin
    lFileSearcher := TFileSearcher.Create;
      try
        lFileSearcher.OnFileFound := OnFileFound;
        lFileSearcher.Search(FDataPath + DirectorySeparator + '..' + DirectorySeparator +
            'Par' + 'seFB'
            , aFilename, False, False);
      finally
        FreeAndNil(lFileSearcher);
      end;
end;

procedure TTestGedComHelper.protected;
begin

end;

procedure TTestGedComHelper.FSFileFound(FileIterator :TFileIterator);
var
    lSt, lRs :TStrings;
begin
    lst := TStringList.Create;
    lRs := TStringList.Create;
      try
        lSt.LoadFromFile(FileIterator.FileName);
        if FileExists(ChangeFileExt(FileIterator.FileName, '.entExp')) then
            lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName, '.entExp'))
        else if FileExists(ChangeFileExt(FileIterator.FileName, '.entNew')) then
            lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName, '.entNew'));
        FGedComHelper.FGedComFile.Clear;
        FGedComHelper.Citation := lSt;
        FGedComHelper.CitTitle := 'Pg.';
        FGedComHelper.CreateNewHeader('Dummy');
        ReplayExpResult(lRs);
        if FileExists(ChangeFileExt(FileIterator.FileName, '.New.Ged')) then
            DeleteFile(ChangeFileExt(FileIterator.FileName, '.New.Ged'));
        FGedComHelper.SaveToFile(ChangeFileExt(FileIterator.FileName, '.New.Ged'));

      finally
        FreeAndNil(lRs);
        FreeAndNil(lSt);
      end;
end;

procedure TTestGedComHelper.FSFileFoundComb(FileIterator :TFileIterator);
var
    lSt, lRs :TStrings;
begin
    lst := TStringList.Create;
    lRs := TStringList.Create;
      try
        lSt.LoadFromFile(FileIterator.FileName);
        if FileExists(ChangeFileExt(FileIterator.FileName, '.entExp')) then
            lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName, '.entExp'))
        else if FileExists(ChangeFileExt(FileIterator.FileName, '.entNew')) then
            lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName, '.entNew'));
        FGedComHelper.Citation := lSt;
        FGedComHelper.CitTitle := 'Pg.';
        ReplayExpResult(lRs);

      finally
        FreeAndNil(lRs);
        FreeAndNil(lSt);
      end;
end;

procedure TTestGedComHelper.HelperMessage(Sender: TObject; aType: TEventType;
  aText: string; Ref: string; aMode: integer);
begin

end;

procedure TTestGedComHelper.SetUp;
begin
    FGedComFile   := TGedComFile.Create;
    FGedComHelper := TGedComHelper.Create;
    FGedComHelper.GedComFile := FGedComFile;
    FGedComHelper.FDebugDate := EncodeDate(2021,05,02);
    FGedComHelper.onHlpMessage:=@HelperMessage;
end;

procedure TTestGedComHelper.TearDown;
begin
    FreeAndNil(FGedComFile);
    FreeAndNil(FGedComHelper);
end;

initialization

    RegisterTest(TTestGedComHelper);
end.
