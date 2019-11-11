unit tst_GedComHelper;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil,fpcunit, testutils, testregistry, Cmp_GedComFile, cls_GedComHelper;

type

    { TTestGedComHelper }

    TTestGedComHelper = class(TTestCase)
    private
        FGedComFile: TGedComFile;
        FGedComHelper: TGedComHelper;
        FDataPath: string;
        procedure FSFileFound(FileIterator: TFileIterator);
        procedure FSFileFoundComb(FileIterator: TFileIterator);
        procedure ReplayExpResult(st: TStrings);
        procedure TestFilesInt(aFilename: String; OnFileFound: TFileFoundEvent);
    protected
        procedure SetUp; override;
        procedure TearDown; override;
    published
        procedure TestSetUp;
        procedure TestParserOutp3b;
        procedure TestParserOutp1b;
        Procedure TestDateModifRepl;
        Procedure TestFiles;
        Procedure TestFile50;
        Procedure TestFile51;
        Procedure TestFilesComb;
        Procedure TestFile50_51;
        Procedure TestFile51_52;
        Procedure TestFile52_54;
        Procedure TestFile52_51_50;
        PRocedure TestFiles5939ff;
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
    lStr: TStringList;
begin
    with FGedComHelper do
      begin
        CreateNewHeader('dummy.ged');
        CitTitle := 'Pg. 1';

        lStr := TStringList.Create;
        Citation := lStr;
          try
            Citation.Text :=
                '3 Adam, Johann Georg, lu. <Adam, Georg, lu.>, * (err) 09.07.1734 in Obrigheim. † ... in Obrigheim, = 12.07.1734 in Obrigheim.'
                +
                LineEnding + 'PN = 49671 ';
            StartFamily(self,'3', '', 0);
            IndiName(self,'Adam', 'I3U', 1);
            FamilyIndiv(self,'I3U', '3', 1);
            IndiName(self,'Johann Georg', 'I3U', 2);
            IndiData(self,'lu.', 'I3U', 8);
            StartFamily(self,'3U', '', 0);
            FamilyIndiv(self,'I3U', '3U', 3);
            IndiName(self,'Adam', 'I3UM', 1);
            FamilyIndiv(self,'I3UM', '3U', 1);
            IndiName(self,'Georg', 'I3UM', 2);
            IndiData(self,'lu.', 'I3UM', 8);
            IndiDate(self,'(err) 09.07.1734', 'I3U', 1);
            IndiPlace(self,'Obrigheim', 'I3U', 1);
            IndiDate(self,'12.07.1734', 'I3U', 5);
            IndiPlace(self,'Obrigheim', 'I3U', 5);
            IndiRef(self,'49671', 'I3U', 0);
            SaveToFile(FDataPath + DirectorySeparator + 'FBObr0003b.ged');
          finally
            FreeAndNil(lStr)
          end;

      end;
end;

procedure TTestGedComHelper.TestParserOutp1b;
var
  lSt,lRs: TStrings;

const FileName='EntryGC0001.entTxt';
begin
      lst:=TStringList.Create;
      lRs:=TStringList.Create;
      try
      lSt.LoadFromFile(FDataPath+DirectorySeparator+FileName);
      if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName,'.entExp')) then
        lRs.LoadFromFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName,'.entExp'));
      FGedComHelper.FGedComFile.Clear;
      FGedComHelper.Citation:=lSt;
      FGedComHelper.CitTitle:='Pg. 1';
      FGedComHelper.CreateNewHeader('Dummy');
      ReplayExpResult(lRs);
      finally
        FreeAndNil(lSt);
        FreeAndNil(lRs);
      end;
end;

procedure TTestGedComHelper.TestDateModifRepl;
begin
  CheckEquals('EST 1980',FGedComHelper.RplGedTags('(s) 1980'),'(s) 1980');
  CheckEquals('CAL 1980',FGedComHelper.RplGedTags('(err) 1980'),'(err) 1980');
  CheckEquals('BEF 1980',FGedComHelper.RplGedTags('vor 1980'),'vor 1980');
  CheckEquals('AFT 1980',FGedComHelper.RplGedTags('nach 1980'),'nach 1980');
  CheckEquals('AFT 1980',FGedComHelper.RplGedTags('seit 1980'),'seit 1980');
  CheckEquals('ABT 1980',FGedComHelper.RplGedTags('ca 1980'),'ca 1980');
  CheckEquals('ABT. 1980',FGedComHelper.RplGedTags('ca. 1980'),'ca. 1980');
end;

procedure TTestGedComHelper.TestFiles;
  begin
    TestFilesInt('*.enttxt',@FSFileFound);
  end;

procedure TTestGedComHelper.TestFile50;
begin
  TestFilesInt('EntryGC0050.enttxt',@FSFileFound);
  CheckEquals(8,FGedComFile.Count,'Tags after '+'EntryGC0050.enttxt'.QuotedString('"'));

end;

procedure TTestGedComHelper.TestFile51;
begin
  TestFilesInt('EntryGC0051.enttxt',@FSFileFound);
  CheckEquals(18,FGedComFile.Count,'Tags after '+'EntryGC0051.enttxt'.QuotedString('"'));

end;

procedure TTestGedComHelper.TestFilesComb;

  begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt('*.enttxt',@FSFileFoundComb);

    if FileExists(FDataPath+DirectorySeparator+'Entry0001ff.New.Ged') then
      DeleteFile(FDataPath+DirectorySeparator+'Entry0001ff.New.Ged');
    FGedComHelper.SaveToFile(FDataPath+DirectorySeparator+'Entry0001ff.New.Ged');
  end;

procedure TTestGedComHelper.TestFile50_51;

  const FileName1 = 'EntryGC0050.enttxt';
        FileName2 = 'EntryGC0051.enttxt';

  begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt(FileName1,@FSFileFoundComb);
      CheckEquals(7,FGedComFile.Count,'Tags after '+FileName1.QuotedString('"'));
    TestFilesInt(FileName2,@FSFileFoundComb);
      CheckEquals(20,FGedComFile.Count,'Tags after '+FileName2.QuotedString('"'));

    if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.Ged')) then
      DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.Ged'));
    FGedComHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.Ged'));

  end;

procedure TTestGedComHelper.TestFile51_52;

const FileName1 = 'EntryGC0051.enttxt';
      FileName2 = 'EntryGC0052.enttxt';

begin
  FGedComHelper.FGedComFile.Clear;
  FGedComHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
    CheckEquals(17,FGedComFile.Count,'Tags after '+FileName1.QuotedString('"'));

  TestFilesInt(FileName2,@FSFileFoundComb);
  CheckEquals(22,FGedComFile.Count,'Tags after '+FileName2.QuotedString('"'));

  if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.Ged')) then
    DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.Ged'));
  FGedComHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.Ged'));

end;

procedure TTestGedComHelper.TestFile52_54;

const FileName1 = 'EntryGC0052.enttxt';
      FileName2 = 'EntryGC0054.enttxt';

begin
  FGedComHelper.FGedComFile.Clear;
  FGedComHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
  CheckEquals(9,FGedComFile.Count,'Tags after '+FileName1.QuotedString('"'));
  TestFilesInt(FileName2,@FSFileFoundComb);
  CheckEquals(13,FGedComFile.Count,'Tags after '+FileName2.QuotedString('"'));

  if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.Ged')) then
    DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.Ged'));
  FGedComHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.Ged'));
end;

procedure TTestGedComHelper.TestFile52_51_50;
const FileName1 = 'EntryGC0052.enttxt';
      FileName2 = 'EntryGC0051.enttxt';
      FileName3 = 'EntryGC0050.enttxt';

begin
  FGedComHelper.FGedComFile.Clear;
  FGedComHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
  CheckEquals(9,FGedComFile.Count,'Tags after '+FileName1.QuotedString('"'));
  TestFilesInt(FileName2,@FSFileFoundComb);
  CheckEquals(22,FGedComFile.Count,'Tags after '+FileName2.QuotedString('"'));
  TestFilesInt(FileName3,@FSFileFoundComb);
  CheckEquals(25,FGedComFile.Count,'Tags after '+FileName3.QuotedString('"'));

  if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'rr.New.Ged')) then
    DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'rr.New.Ged'));
  FGedComHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'rr.New.Ged'));

end;

procedure TTestGedComHelper.TestFiles5939ff;
const FileName1 = 'OsbObr5939.enttxt';
      FileName2 = 'OsbObr5942.enttxt';
      FileName3 = 'OsbObr5943.enttxt';

begin
  FGedComHelper.FGedComFile.Clear;
  FGedComHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
    CheckEquals(10,FGedComFile.Count,'Tags after '+FileName1.QuotedString('"'));
  TestFilesInt(FileName2,@FSFileFoundComb);
  CheckEquals(14,FGedComFile.Count,'Tags after '+FileName2.QuotedString('"'));
  TestFilesInt(FileName3,@FSFileFoundComb);
  CheckEquals(22,FGedComFile.Count,'Tags after '+FileName3.QuotedString('"'));

  if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.Ged')) then
    DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.Ged'));
  FGedComHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'rr.New.Ged'));

end;

constructor TTestGedComHelper.Create;
var
    i: integer;
begin
    inherited Create;
    FDataPath:=GetDataPath('GenData');
end;

procedure TTestGedComHelper.ReplayExpResult(st: TStrings);
var
  i: Integer;
begin
  if st.Count=0 then
    exit;
  for i := 1 to st.Count-1 do
     FGedComHelper.FireEvent(self,st[i].Split([#9]));
end;

procedure TTestGedComHelper.TestFilesInt(aFilename:String;OnFileFound:TFileFoundEvent);
var
  lFileSearcher: TFileSearcher;
begin
  lFileSearcher:= TFileSearcher.Create ;
  try
  lFileSearcher.OnFileFound:=OnFileFound;
  lFileSearcher.Search(FDataPath+DirectorySeparator+'..'+DirectorySeparator+'Par'
    +'seFB'
    , aFilename, false, false);
  finally
    freeandnil(lFileSearcher);
  end;
end;

procedure TTestGedComHelper.FSFileFound(FileIterator: TFileIterator);
var
  lSt,lRs: TStrings;
begin
      lst:=TStringList.Create;
      lRs:=TStringList.Create;
      try
      lSt.LoadFromFile(FileIterator.FileName);
      if FileExists(ChangeFileExt(FileIterator.FileName,'.entExp')) then
        lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName,'.entExp'));
      FGedComHelper.FGedComFile.Clear;
      FGedComHelper.Citation:=lSt;
      FGedComHelper.CitTitle:='Pg.';
      FGedComHelper.CreateNewHeader('Dummy');
      ReplayExpResult(lRs);
      if FileExists(ChangeFileExt(FileIterator.FileName,'.New.Ged')) then
        DeleteFile(ChangeFileExt(FileIterator.FileName,'.New.Ged'));
      FGedComHelper.SaveToFile(ChangeFileExt(FileIterator.FileName,'.New.Ged'));

      finally
        Freeandnil(lRs);
        FreeandNil(lSt);
      end;
end;

procedure TTestGedComHelper.FSFileFoundComb(FileIterator: TFileIterator);
var
  lSt,lRs: TStrings;
begin
      lst:=TStringList.Create;
      lRs:=TStringList.Create;
      try
      lSt.LoadFromFile(FileIterator.FileName);
      if FileExists(ChangeFileExt(FileIterator.FileName,'.entExp')) then
        lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName,'.entExp'));
      FGedComHelper.Citation:=lSt;
      FGedComHelper.CitTitle:='Pg.';
      ReplayExpResult(lRs);

      finally
        Freeandnil(lRs);
        FreeandNil(lSt);
      end;
end;

procedure TTestGedComHelper.SetUp;
begin
    FGedComFile := TGedComFile.Create;
    FGedComHelper := TGedComHelper.Create;
    FGedComHelper.GedComFile := FGedComFile;
end;

procedure TTestGedComHelper.TearDown;
begin
    FreeAndNil(FGedComFile);
    FreeAndNil(FGedComHelper);
end;

initialization

    RegisterTest(TTestGedComHelper);
end.
