unit tst_GedComHelper2;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil,fpcunit, testregistry, Cmp_GedComFile,
     cls_GedComHelper;

type

    { TTestGedComHelper2 }

    TTestGedComHelper2 = class(TTestCase)
    private
        FGedComFile: TGedComFile;
        FGedComHelper: TGedComHelper;
        FDataPath: string;
        procedure FSFileFound(FileIterator: TFileIterator);
        procedure FSFileFoundComb(FileIterator: TFileIterator);
        procedure ReplayExpResult(st: TStrings);
        procedure TestFilesInt(aFilename: String; OnFileFound: TFileFoundEvent;SubDir:Boolean=false);
    protected
        procedure SetUp; override;
        procedure TearDown; override;
    published
        procedure TestSetUp;
        Procedure TestDateModifRepl;
        procedure TestVieser2Ged_I5;
        procedure TestVieser2Ged_I12;
        procedure TestVieser2Ged_I23;
        procedure TestVieser2Ged_I31;
        procedure TestVieser2Ged_I42;
        procedure TestVieser3_I50;
        procedure TestVieser3_I61;
        procedure TestVieser3_I80;
        procedure TestVieser3_I134;
        procedure TestVieser3_I255;
        Procedure TestFile50_51;
        Procedure TestFile51_52;
        Procedure TestFile52_54;
        Procedure TestFile52_51_50;
        PRocedure TestFiles5939ff;
        Procedure TestAllFiles;
        Procedure TestFilesComb;
    public
        constructor Create; override;
    end;

implementation

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

uses unt_GenTestBase,Unt_FileProcs;

procedure TTestGedComHelper2.TestSetUp;
begin
    CheckNotNull(FGedComFile, 'FGedComFile is assigned');
    CheckNotNull(FGedComHelper, 'FGedComHelper is assigned');
    CheckNotNull(FGedComHelper.GedComFile, 'FGedComHelper.GedComFile is assigned');
    checktrue(DirectoryExists(FDataPath), 'DataPath exists');
end;

procedure TTestGedComHelper2.TestDateModifRepl;
begin
  CheckEquals('EST 1980',FGedComHelper.RplGedTags('(s) 1980'),'(s) 1980');
  CheckEquals('CAL 1980',FGedComHelper.RplGedTags('(err) 1980'),'(err) 1980');
  CheckEquals('BEF 1980',FGedComHelper.RplGedTags('vor 1980'),'vor 1980');
  CheckEquals('AFT 1980',FGedComHelper.RplGedTags('nach 1980'),'nach 1980');
  CheckEquals('AFT 1980',FGedComHelper.RplGedTags('seit 1980'),'seit 1980');
  CheckEquals('ABT 1980',FGedComHelper.RplGedTags('ca 1980'),'ca 1980');
  CheckEquals('ABT. 1980',FGedComHelper.RplGedTags('ca. 1980'),'ca. 1980');
end;

procedure TTestGedComHelper2.TestAllFiles;
  begin
    TestFilesInt('*.IntExp',@FSFileFound,true);
  end;

procedure TTestGedComHelper2.TestVieser2Ged_I5;
const CFilename = 'vieser\I5.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(12,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I5@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I12;
const CFilename = 'vieser\I12.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(16,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I12@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I23;
const CFilename = 'vieser\I23.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(14,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I23@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I31;
const CFilename = 'vieser\I31.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(18,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I31@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I42;
const CFilename = 'vieser\I42.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(19,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I42@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser3_I50;
const CFilename = 'vieser\I50.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(8,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I50@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser3_I61;
const CFilename = 'vieser\I61.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(14,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I61@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser3_I80;
const CFilename = 'vieser\I80.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(11,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I80@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser3_I134;
const CFilename = 'vieser\I134.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(14,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I134@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser3_I255;
const CFilename = 'vieser\I255.IntExp';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(16,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@I255@ INDI',FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestFilesComb;

  begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt('*.intExp',@FSFileFoundComb,True);

    SaveFile(@FGedComHelper.SaveToFile,FDataPath+DirectorySeparator+'Vieser0001xff.New.Ged');

  end;

procedure TTestGedComHelper2.TestFile50_51;

  const FileName1 = 'EntryGC0050.enttxt';
        FileName2 = 'EntryGC0051.enttxt';

  begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt(FileName1,@FSFileFoundComb);
      CheckEquals(7,FGedComFile.Count,'Tags after '+FileName1.QuotedString('"'));
    TestFilesInt(FileName2,@FSFileFoundComb);
      CheckEquals(20,FGedComFile.Count,'Tags after '+FileName2.QuotedString('"'));

    SaveFile(@FGedComHelper.SaveToFile,FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.Ged'));

  end;

procedure TTestGedComHelper2.TestFile51_52;

const FileName1 = 'EntryGC0051.enttxt';
      FileName2 = 'EntryGC0052.enttxt';

begin
  FGedComHelper.FGedComFile.Clear;
  FGedComHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
    CheckEquals(17,FGedComFile.Count,'Tags after '+FileName1.QuotedString('"'));

  TestFilesInt(FileName2,@FSFileFoundComb);
  CheckEquals(22,FGedComFile.Count,'Tags after '+FileName2.QuotedString('"'));

  SaveFile(@FGedComHelper.SaveToFile,FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.Ged'));

end;

procedure TTestGedComHelper2.TestFile52_54;

const FileName1 = 'EntryGC0052.enttxt';
      FileName2 = 'EntryGC0054.enttxt';

begin
  FGedComHelper.FGedComFile.Clear;
  FGedComHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
  CheckEquals(9,FGedComFile.Count,'Tags after '+FileName1.QuotedString('"'));
  TestFilesInt(FileName2,@FSFileFoundComb);
  CheckEquals(13,FGedComFile.Count,'Tags after '+FileName2.QuotedString('"'));

  SaveFile(@FGedComHelper.SaveToFile,FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.Ged'));
end;

procedure TTestGedComHelper2.TestFile52_51_50;
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

  SaveFile(@FGedComHelper.SaveToFile,FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'rr.New.Ged'));

end;

procedure TTestGedComHelper2.TestFiles5939ff;
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

  SaveFile(@FGedComHelper.SaveToFile,FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.Ged'));

end;

constructor TTestGedComHelper2.Create;

begin
    inherited Create;
    FDataPath:=GetDataPath('GenData');
end;

procedure TTestGedComHelper2.ReplayExpResult(st: TStrings);
var
  i: Integer;
begin
  if st.Count=0 then
    exit;
  for i := 1 to st.Count-1 do
     FGedComHelper.FireEvent(self,st[i].Split([#9]));
end;

procedure TTestGedComHelper2.TestFilesInt(aFilename: String;
  OnFileFound: TFileFoundEvent; SubDir: Boolean);
var
  lFileSearcher: TFileSearcher;
begin
  lFileSearcher:= TFileSearcher.Create ;
  try
  lFileSearcher.OnFileFound:=OnFileFound;
  lFileSearcher.Search(FDataPath+DirectorySeparator+ExtractFilePath(aFilename),
  ExtractFileName(aFilename), SubDir, false);
  finally
    freeandnil(lFileSearcher);
  end;
end;

procedure TTestGedComHelper2.FSFileFound(FileIterator: TFileIterator);
var
  lSt,lRs: TStrings;
begin
      lst:=TStringList.Create;
      lRs:=TStringList.Create;
      try
      lSt.LoadFromFile(FileIterator.FileName);
      if FileExists(ChangeFileExt(FileIterator.FileName,'.entExp')) then
        lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName,'.entExp'))
      else if FileExists(ChangeFileExt(FileIterator.FileName,'.entNew')) then
        lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName,'.entNew'));
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

procedure TTestGedComHelper2.FSFileFoundComb(FileIterator: TFileIterator);
var
  lSt,lRs: TStrings;
begin
      lst:=TStringList.Create;
      lRs:=TStringList.Create;
      try
      lSt.LoadFromFile(FileIterator.FileName);
      if FileExists(ChangeFileExt(FileIterator.FileName,'.entExp')) then
        lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName,'.entExp'))
      else if FileExists(ChangeFileExt(FileIterator.FileName,'.entNew')) then
        lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName,'.entNew'));
      FGedComHelper.Citation:=lSt;
      FGedComHelper.CitTitle:='Pg.';
      ReplayExpResult(lRs);

      finally
        Freeandnil(lRs);
        FreeandNil(lSt);
      end;
end;

procedure TTestGedComHelper2.SetUp;
begin
    FGedComFile := TGedComFile.Create;
    FGedComHelper := TGedComHelper.Create;
    FGedComHelper.GedComFile := FGedComFile;
end;

procedure TTestGedComHelper2.TearDown;
begin
    FreeAndNil(FGedComFile);
    FreeAndNil(FGedComHelper);
end;

initialization

    RegisterTest(TTestGedComHelper2);
end.
