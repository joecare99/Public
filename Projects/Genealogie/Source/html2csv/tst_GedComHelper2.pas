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
        procedure TestVieser2Ged_I50;
        procedure TestVieser2Ged_I61;
        procedure TestVieser2Ged_I80;
        procedure TestVieser2Ged_I134;
        procedure TestVieser2Ged_I255;
        procedure TestVieser2Ged_I12577;
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
      CexpTag = 12;
      CExpIndi = '@I5@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I12;
const CFilename = 'vieser\I12.IntExp';
      CexpTag = 16;
      CExpIndi = '@I12@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I23;
const CFilename = 'vieser\I23.IntExp';
      CexpTag = 14;
      CExpIndi = '@I23@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I31;
const CFilename = 'vieser\I31.IntExp';
      CexpTag = 18;
      CExpIndi = '@I31@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I42;
const CFilename = 'vieser\I42.IntExp';
      CexpTag = 19;
      CExpIndi = '@I42@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I50;
const CFilename = 'vieser\I50.IntExp';
      CexpTag = 8;
      CExpIndi = '@I50@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I61;
const CFilename = 'vieser\I61.IntExp';
      CexpTag = 14;
      CExpIndi = '@I61@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I80;
const CFilename = 'vieser\I80.IntExp';
      CexpTag = 11;
      CExpIndi = '@I80@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I134;
const CFilename = 'vieser\I134.IntExp';
      CexpTag = 14;
      CExpIndi = '@I134@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I255;
const CFilename = 'vieser\I255.IntExp';
      CexpTag = 16;
      CExpIndi = '@I255@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;

procedure TTestGedComHelper2.TestVieser2Ged_I12577;
const CFilename = 'vieser\I12577.IntExp';
      CexpTag = 8;
      CExpIndi = '@I12577@ INDI';

begin
  TestFilesInt(CFilename,@FSFileFound);
  CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
  CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
end;


procedure TTestGedComHelper2.TestFilesComb;

const CFilename = '*.IntExp';
      CexpTag = 108;
      CExpIndi = '@I12@ INDI';

  begin
    FGedComHelper.FGedComFile.Clear;
    FGedComHelper.CreateNewHeader('Dummy');

    TestFilesInt(CFilename,@FSFileFoundComb,True);

    SaveFile(@FGedComHelper.SaveToFile,FDataPath+DirectorySeparator+'Vieser0001xff.New.Ged');

    CheckEquals(CexpTag,FGedComFile.Count,'Tags after '+string(ExtractFileName(CFilename)).QuotedString('"'));
    CheckEquals('@SUBM@ SUBM',FGedComFile.Child[1].ToString,'[1].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
    CheckEquals(CExpIndi,FGedComFile.Child[2].ToString,'[2].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));
    CheckEquals('@S1@ SOUR',FGedComFile.Child[3].ToString,'[3].ToString '+string(ExtractFileName(CFilename)).QuotedString('"'));

  end;


constructor TTestGedComHelper2.Create;

begin
    inherited Create;
    FDataPath:=GetDataPath('GenData');
end;

procedure TTestGedComHelper2.ReplayExpResult(st: TStrings);
var
  i,li: Integer;
begin
  if st.Count=0 then
    exit;
  for i := 1 to st.Count-1 do
     begin
        FGedComHelper.FireEvent(self,st[i].Split([#9]));
        if FGedComHelper.FgedComFile.Child[2].ToString = '@@ INDI' then
          begin
            li := i;
            break;
          end;
     end;
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
