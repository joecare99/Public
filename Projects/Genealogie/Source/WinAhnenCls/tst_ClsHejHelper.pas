unit tst_ClsHejHelper;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, FileUtil,testutils, testregistry,cls_HejHelper,cls_HejData;

type

  { TTestHejHelper }

  TTestHejHelper= class(TTestCase)
  private
    FhejHelper:THejHelper;
    FHejObj:TClsHejGenealogy;
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
    Procedure TestIIndex;
    Procedure TestIIndex2;
    Procedure TestIIndex3;
    Procedure TestFIndex;
    Procedure TestFIndex2;
    Procedure TestFIndex3;
    procedure TestParserOutp3b;
    procedure TestParserOutp1b;
    Procedure TestFiles;
    Procedure TestFile06;
    Procedure TestFile50;
    Procedure TestFile51;
    Procedure TestFilesComb;
    Procedure TestFile50_51;
    Procedure TestFile51_52;
    procedure TestFile52_54;
    procedure TestFile52_51_50;
    procedure TestFiles5939ff;
public
    constructor Create; override;
  end;

implementation

uses cls_HejIndData;

procedure TTestHejHelper.TestSetUp;
begin
  CheckNotNull(FHejObj,'FHejObj is Assigned');
  CheckNotNull(FhejHelper,'FhejHelper is Assigned');
  CheckTrue(DirectoryExists(FDataPath),'FDataPath exists');
end;

procedure TTestHejHelper.TestIIndex;
var
  i: Integer;
begin
  FhejHelper.clear;
  FhejHelper.IndiName(self,'Peter Mustermann','I1M',0);
  FHejObj.iData[-1,hind_sex]:='M';
  for i := 2 to 9999 do
     FhejHelper.IndiRel(self,inttostr(i),'I1M',2);
  for i := 0 to 10000 do
     CheckEquals('Peter',FhejHelper.Indi['I2M'].GivenName,'Suche nach Peter');

end;

procedure TTestHejHelper.TestIIndex2;
var
  i: Integer;
begin
  FhejHelper.clear;
  FhejHelper.IndiName(self,'Peter Mustermann','I1M',0);
  FHejObj.iData[-1,hind_sex]:='M';
  for i := 2 to 9999 do
     FhejHelper.IndiRel(self,inttostr(i),'I1M',2);
  for i := 0 to 10000 do
     CheckEquals('Peter',FhejHelper.Indi['I9999M'].GivenName,'Suche nach Peter');
end;

procedure TTestHejHelper.TestIIndex3;
var
  i: Integer;
  lr: String;
begin
  FhejHelper.clear;
  FhejHelper.IndiName(self,'Peter Mustermann','I1M',0);
  FHejObj.iData[-1,hind_sex]:='M';
  for i := 2 to 9999 do
     FhejHelper.IndiRel(self,inttostr(i),'I1M',2);
  for i := 0 to 10000 do
     begin
       lr:='I'+inttostr(random(9999)+1)+'M';
       CheckEquals('Peter',FhejHelper.Indi[lr].GivenName,'Suche nach Peter ['+lr+']');

     end;
end;

procedure TTestHejHelper.TestFIndex;
var
  i: Integer;
begin
  FhejHelper.clear;
  FhejHelper.IndiName(self,'Peter Mustermann','I1M',0);
  FHejObj.iData[-1,hind_sex]:='M';
  for i := 9999 downto 1 do
     FhejHelper.StartFamily(self,inttostr(i),'',0);
  for i := 0 to 10000 do
     CheckNotNull(FhejHelper.Fami['F1'],'Suche nach Familie');
end;

procedure TTestHejHelper.TestFIndex2;
var
  i: Integer;
begin
  FhejHelper.clear;
  FhejHelper.IndiName(self,'Peter Mustermann','I1M',0);
  FHejObj.iData[-1,hind_sex]:='M';
  for i := 1 to 9999 do
     FhejHelper.StartFamily(self,inttostr(i),'',0);
  for i := 0 to 10000 do
     CheckNotNull(FhejHelper.Fami['F9999'],'Suche nach Familie');
end;

procedure TTestHejHelper.TestFIndex3;
var
  i: Integer;
  lr: String;
begin
  FhejHelper.clear;
  FhejHelper.IndiName(self,'Peter Mustermann','I1M',0);
  FHejObj.iData[-1,hind_sex]:='M';
  for i := 1 to 9999 do
     FhejHelper.StartFamily(self,inttostr(i),'',0);
  for i := 0 to 10000 do
     begin
       lr:='F'+inttostr(random(9999)+1);
       CheckNotNull(FhejHelper.Fami[lr],'Suche nach Familie');
     end;
end;

procedure TTestHejHelper.TestParserOutp3b;
var
    lStr: TStringList;
begin
    with FhejHelper do
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
            SaveToFile(FDataPath + DirectorySeparator + 'FBObr0003b.hej');
          finally
            FreeAndNil(lStr)
          end;

      end;
end;

procedure TTestHejHelper.TestParserOutp1b;
var
  lSt,lRs: TStrings;

const FileName='EntryGC0001.entTxt';
begin
      lst:=TStringList.Create;
      lRs:=TStringList.Create;
      lSt.LoadFromFile(FDataPath+DirectorySeparator+FileName);
      if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName,'.entExp')) then
        lRs.LoadFromFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName,'.entExp'));
      FhejHelper.Clear;
      FhejHelper.Citation:=lSt;
      FhejHelper.CitTitle:='Pg. 1';
      FhejHelper.CreateNewHeader('Dummy');
      ReplayExpResult(lRs);
end;

procedure TTestHejHelper.TestFiles;
begin
  TestFilesInt('*.enttxt',@FSFileFound);
end;

procedure TTestHejHelper.TestFile06;
begin
  TestFilesInt('OsBObr0006.enttxt',@FSFileFound);
end;

procedure TTestHejHelper.TestFile50;
begin
  TestFilesInt('EntryGC0050.enttxt',@FSFileFound);
end;

procedure TTestHejHelper.TestFile51;
begin
  TestFilesInt('EntryGC0051.enttxt',@FSFileFound);
end;

procedure TTestHejHelper.TestFilesComb;
begin
  FhejHelper.Clear;
  FhejHelper.CreateNewHeader('Dummy');

  TestFilesInt('*.enttxt',@FSFileFoundComb);

  if FileExists(FDataPath+DirectorySeparator+'Entry0001ff.New.hej') then
    DeleteFile(FDataPath+DirectorySeparator+'Entry0001ff.New.hej');
  FhejHelper.SaveToFile(FDataPath+DirectorySeparator+'Entry0001ff.New.hej');
end;


procedure TTestHejHelper.TestFile50_51;
const FileName1 = 'EntryGC0050.enttxt';
      FileName2 = 'EntryGC0051.enttxt';

begin
  FhejHelper.Clear;
  FhejHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
  TestFilesInt(FileName2,@FSFileFoundComb);

  if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.hej')) then
    DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.hej'));
  FhejHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.hej'));
end;

procedure TTestHejHelper.TestFile51_52;
const FileName1 = 'EntryGC0051.enttxt';
      FileName2 = 'EntryGC0052.enttxt';

begin
  FhejHelper.Clear;
  FhejHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
  TestFilesInt(FileName2,@FSFileFoundComb);

  if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.hej')) then
    DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.hej'));
  FhejHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'ff.New.hej'));
end;

procedure TTestHejHelper.TestFile52_54;

const FileName1 = 'EntryGC0052.enttxt';
      FileName2 = 'EntryGC0054.enttxt';

begin
  FhejHelper.Clear;
  FhejHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
  CheckEquals(5,FHejObj.Count,'Tags after '+FileName1.QuotedString('"'));
  TestFilesInt(FileName2,@FSFileFoundComb);
  CheckEquals(8,FHejObj.Count,'Tags after '+FileName2.QuotedString('"'));

  if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.hej')) then
    DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.hej'));
  FhejHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.hej'));
end;

procedure TTestHejHelper.TestFile52_51_50;
const FileName1 = 'EntryGC0052.enttxt';
      FileName2 = 'EntryGC0051.enttxt';
      FileName3 = 'EntryGC0050.enttxt';

begin
  FhejHelper.Clear;
  FhejHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
  CheckEquals(5,FHejObj.Count,'Tags after '+FileName1.QuotedString('"'));
  TestFilesInt(FileName2,@FSFileFoundComb);
  CheckEquals(18,FHejObj.Count,'Tags after '+FileName2.QuotedString('"'));
  TestFilesInt(FileName3,@FSFileFoundComb);
  CheckEquals(21,FHejObj.Count,'Tags after '+FileName3.QuotedString('"'));

  if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'rr.New.hej')) then
    DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'rr.New.hej'));
  FhejHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'rr.New.hej'));

end;

procedure TTestHejHelper.TestFiles5939ff;
const FileName1 = 'OsbObr5939.enttxt';
      FileName2 = 'OsbObr5942.enttxt';
      FileName3 = 'OsbObr5943.enttxt';

begin
  FhejHelper.Clear;
  FhejHelper.CreateNewHeader('Dummy');

  TestFilesInt(FileName1,@FSFileFoundComb);
    CheckEquals(5,FHejObj.Count,'Tags after '+FileName1.QuotedString('"'));
  TestFilesInt(FileName2,@FSFileFoundComb);
  CheckEquals(10,FHejObj.Count,'Tags after '+FileName2.QuotedString('"'));
  TestFilesInt(FileName3,@FSFileFoundComb);
  CheckEquals(18,FHejObj.Count,'Tags after '+FileName3.QuotedString('"'));

  if FileExists(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.hej')) then
    DeleteFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'_ff.New.hej'));
  FhejHelper.SaveToFile(FDataPath+DirectorySeparator+ChangeFileExt(FileName1,'rr.New.hej'));

end;

constructor TTestHejHelper.Create;
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
        FDataPath := FDataPath + DirectorySeparator + 'GenData';
    if not DirectoryExists(FDataPath) then
        ForceDirectories(FDataPath);
end;

procedure TTestHejHelper.FSFileFound(FileIterator: TFileIterator);
var
  lSt,lRs: TStrings;

begin
      lst:=TStringList.Create;
      lRs:=TStringList.Create;
      try
      lSt.LoadFromFile(FileIterator.FileName);
      if FileExists(ChangeFileExt(FileIterator.FileName,'.entExp')) then
        lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName,'.entExp'));
      FHejHelper.Clear;
      FHejHelper.Citation:=lSt;
      FHejHelper.CitTitle:='Pg.';
      FHejHelper.CreateNewHeader('Dummy');
      ReplayExpResult(lRs);
      if FileExists(ChangeFileExt(FileIterator.FileName,'.New.hej')) then
        DeleteFile(ChangeFileExt(FileIterator.FileName,'.New.hej'));
      FHejHelper.SaveToFile(ChangeFileExt(FileIterator.FileName,'.New.hej'));

      finally
        Freeandnil(lRs);
        FreeandNil(lSt);
      end;
end;

procedure TTestHejHelper.FSFileFoundComb(FileIterator: TFileIterator);
var
  lSt,lRs: TStrings;
begin
      lst:=TStringList.Create;
      lRs:=TStringList.Create;
      try
      lSt.LoadFromFile(FileIterator.FileName);
      if FileExists(ChangeFileExt(FileIterator.FileName,'.entExp')) then
        lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName,'.entExp'));
      FHejHelper.Citation:=lSt;
      FHejHelper.CitTitle:='Pg.';
      ReplayExpResult(lRs);

      finally
        Freeandnil(lRs);
        FreeandNil(lSt);
      end;
end;

procedure TTestHejHelper.ReplayExpResult(st: TStrings);
var
  i: Integer;
begin
  if st.Count=0 then
    exit;
  for i := 1 to st.Count-1 do
     FhejHelper.FireEvent(self,st[i].Split([#9]));
end;

procedure TTestHejHelper.TestFilesInt(aFilename: String;
  OnFileFound: TFileFoundEvent);
var
  lFileSearcher: TFileSearcher;
begin
  lFileSearcher:= TFileSearcher.Create ;
  try
  lFileSearcher.OnFileFound:=OnFileFound;
  lFileSearcher.Search(FDataPath+DirectorySeparator+'..'+DirectorySeparator+'Par'
    +'seFB', aFilename, false, false);
  finally
    freeandnil(lFileSearcher);
  end;
end;

procedure TTestHejHelper.SetUp;
begin
     FHejObj := TClsHejGenealogy.Create;
    FhejHelper := THejHelper.Create;
    FhejHelper.HejObj := FHejObj;
end;

procedure TTestHejHelper.TearDown;
begin
    FreeAndNil(FHejObj);
    FreeAndNil(FhejHelper);
end;

initialization

  RegisterTest(TTestHejHelper);
end.

