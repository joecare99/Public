unit tst_FileMoveUnt;

{$mode objfpc}{$H+}

interface

uses
  Classes,  {$IFDEF FPC} fpcunit,{%H-}testutils, testregistry,{$else}windows, TestFramework, {$ENDIF}
  SysUtils,unt_FileMove;

type

  { TTestFileMove }

  TTestFileMove= class(TTestCase)
  private
    FDataDir:String;
    FFileMoveApp:TFileMoveApp;
    FOutStrings:TStrings;
    Procedure TestTextOut(aStr:String);
    procedure CreateTestData(aFilename: string);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestFileMove1;
    Procedure TestFileMove2;
    Procedure TestFileMove3;
    procedure TestFileMove4_ext;
    procedure TestFileMove5_Conf;
  end;

implementation

const
{$IFNDEF FPC}
   DirectorySeparator = DirSep;
 {$ENDIF}
   CDataDir = 'Data';

procedure TTestFileMove.TestTextOut(aStr: String);
begin
   FOutStrings.Add(aStr);
end;

procedure TTestFileMove.CreateTestData(aFilename: string);
var
  lOrgFileExt, lOrgFilename, lExpFileName: String;

  procedure CopyFile(aSourceFile,aDestFile: string);
  var
    lFSDestFile: TFileStream;
    lFSSourceFile: TFileStream;
  begin
    lFSSourceFile:=TFilestream.Create(aSourceFile,fmOpenRead);
     try
     lFSDestFile:=TFilestream.Create(aDestFile,fmCreate+fmOpenWrite);
     lFSDestFile.CopyFrom(lFSSourceFile,lFSSourceFile.Size);
     finally
       FreeAndNil(lFSDestFile);
       FreeAndNil(lFSSourceFile);
     end;
  end;

begin
  lOrgFileExt:=ExtractFileExt(aFilename);
  if fileexists(FDataDir+DirectorySeparator+aFilename) then
     DeleteFile(FDataDir+DirectorySeparator+aFilename);
  lOrgFilename:=changeFileExt(aFilename,lOrgFileExt+'_Org');
  lExpFileName:=changeFileExt(aFilename,lOrgFileExt+'_Exp');
  CopyFile(FDataDir+DirectorySeparator+lOrgFilename,FDataDir+DirectorySeparator+aFilename);
end;

procedure TTestFileMove.SetUp;
var
  i: Integer;
begin
  if FDataDir='' then
     begin
       FDataDir := CDataDir;
       for i := 0 to 2 do
         if not DirectoryExists(FDataDir) then
            FDataDir:='..'+DirectorySeparator+FDataDir
         else
           break;
        if DirectoryExists(FDataDir) then
           FDataDir:=FDataDir+DirectorySeparator+'FileTest';
     end;
  FOutStrings := TStringlist.Create;
  FFileMoveApp := TFileMoveApp.Create(nil);
end;

procedure TTestFileMove.TearDown;
begin
  if fileexists(FDataDir+DirectorySeparator+'ENUMMSGALLGEMEIN.EXP') then
    DeleteFile(FDataDir+DirectorySeparator+'ENUMMSGALLGEMEIN.EXP');
  FreeAndNil(FFileMoveApp);
  FreeAndNil(FOutStrings);
end;

procedure TTestFileMove.TestSetUp;
begin
  CheckNotNull(FFileMoveApp,'FileMoveApp is assigned');
  CheckNotNull(FOutStrings,'OutStrings is assigned');
  CheckEquals('',FOutStrings.text,'OutStrings are Empty');
  TestTextOut('Dies ist ein Test');
  CheckEquals('Dies ist ein Test'+LineEnding,FOutStrings.text,'OutStrings is not Empty');
  FOutStrings.Clear;
  CheckEquals('',FOutStrings.text,'OutStrings are Empty');
  CreateTestData('ENUMMSGALLGEMEIN.EXP');
  CheckTrue(Fileexists(FDataDir+DirectorySeparator+'ENUMMSGALLGEMEIN.EXP'),'Testfile exists');
  DeleteFile(FDataDir+DirectorySeparator+'ENUMMSGALLGEMEIN.EXP');
  Checkfalse(Fileexists(FDataDir+DirectorySeparator+'ENUMMSGALLGEMEIN.EXP'),'Testfile does not exist');
end;

procedure TTestFileMove.TestFileMove1;

const CFilename = 'ENUMMSGALLGEMEIN.EXP';
      CDestPath = 'Projekt\Störungen & Meldungen\Type';
var
  rmDirs: String;

begin
  try
  CreateTestData(CFilename);
  FFileMoveApp.DoFileProcessing(FDataDir+DirectorySeparator+CFilename,FDataDir+'$p'+DirectorySeparator+'$t'+DirectorySeparator,true,true,@TestTextOut);
  Checkfalse(Fileexists(FDataDir+DirectorySeparator+CFilename),'Testfile does not exists on old Place');
  CheckTrue(Fileexists(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename),'Testfile exists on new place');
  CheckTrue(Fileexists(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+'ENUMMSGALLGEMEIN.movelog'),'Movelog-file exists');
  CheckEquals(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename+LineEnding,FOutStrings.text,'Ausgabe');
// Todo: Weitere Tests
  finally
    // Aufräumen nach dem Test
     if Fileexists(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename) then
       deletefile(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename);
     if Fileexists(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+'ENUMMSGALLGEMEIN.movelog') then
       deletefile(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+'ENUMMSGALLGEMEIN.movelog');
     if DirectoryExists(FDataDir+DirectorySeparator+'.movelog') then
       rmdir(FDataDir+DirectorySeparator+'.movelog');
     rmDirs := CDestPath;
     while (rmDirs <>'') and DirectoryExists(FDataDir+DirectorySeparator+rmDirs)  do
       begin
          RemoveDir(FDataDir+DirectorySeparator+rmDirs);
          rmDirs:=ExtractFilePath(ExcludeTrailingPathDelimiter(rmdirs));
       end;
  end;
end;

procedure TTestFileMove.TestFileMove2;
const CFilename = '_SYSTEMVARIABLES.EXP';
      CDestPath = 'Ressource';
var
  rmDirs: String;

begin
  try
  CreateTestData(CFilename);
  FFileMoveApp.DoFileProcessing(FDataDir+DirectorySeparator+CFilename,FDataDir+'$p'+DirectorySeparator+'$t'+DirectorySeparator,true,true,@TestTextOut);
  Checkfalse(Fileexists(FDataDir+DirectorySeparator+CFilename),'Testfile does not exists on old Place');
  CheckTrue(Fileexists(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename),'Testfile exists on new place');
  CheckTrue(Fileexists(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog')),'Movelog-file exists');
  CheckEquals(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename+LineEnding,FOutStrings.text,'Ausgabe');
// Todo: Weitere Tests
  finally
    // Aufräumen nach dem Test
     if Fileexists(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename) then
       deletefile(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename);
     if Fileexists(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog')) then
       deletefile(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog'));
     if DirectoryExists(FDataDir+DirectorySeparator+'.movelog') then
       rmdir(FDataDir+DirectorySeparator+'.movelog');
     rmDirs := CDestPath;
     while (rmDirs <>'') and DirectoryExists(FDataDir+DirectorySeparator+rmDirs)  do
       begin
          RemoveDir(FDataDir+DirectorySeparator+rmDirs);
          rmDirs:=ExtractFilePath(ExcludeTrailingPathDelimiter(rmdirs));
       end;
  end;
end;

procedure TTestFileMove.TestFileMove3;
const CFilename = 'DB_GLOBAL.EXP';
      CDestPath = 'Projekt\Ressource';
var
  rmDirs, lMoveLogFile: String;
  lTt :Text;

begin
  try
  CreateTestData(CFilename);
  lMoveLogFile := FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog');
  mkdir(FDataDir+DirectorySeparator+'.movelog');
  AssignFile(lTt,lMoveLogFile );
  rewrite(lTt);
  writeln(lTt, FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename);
  CloseFile(lTt);

  FFileMoveApp.DoFileProcessing(FDataDir+DirectorySeparator+CFilename,FDataDir+'$p'+DirectorySeparator+'$t'+DirectorySeparator,true,true,@TestTextOut);
  Checkfalse(Fileexists(FDataDir+DirectorySeparator+CFilename),'Testfile does not exists on old Place');
  CheckTrue(Fileexists(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename),'Testfile exists on new place');
  CheckTrue(Fileexists(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog')),'Movelog-file exists');
  CheckEquals(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename+LineEnding,FOutStrings.text,'Ausgabe');
// Todo: Weitere Tests
  finally
    // Aufräumen nach dem Test
     if Fileexists(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename) then
       deletefile(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename);
     if Fileexists(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog')) then
       deletefile(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog'));
     if DirectoryExists(FDataDir+DirectorySeparator+'.movelog') then
       rmdir(FDataDir+DirectorySeparator+'.movelog');
     rmDirs := CDestPath;
     while (rmDirs <>'') and DirectoryExists(FDataDir+DirectorySeparator+rmDirs)  do
       begin
          RemoveDir(FDataDir+DirectorySeparator+rmDirs);
          rmDirs:=ExtractFilePath(ExcludeTrailingPathDelimiter(rmdirs));
       end;
  end;
end;

procedure TTestFileMove.TestFileMove4_ext;

const CDir = 'C:\Projekte\2017\1170338_MPS1150_Sauer\software\Quellen\SEW';
      CFilename = 'DB_GLOBAL.EXP';
      CDestPath = 'Projekt\Ressource';
var
  lCurrDur: String;

begin
  lCurrDur := GetCurrentDir;
  try
  chdir(CDir);
  Checktrue(Fileexists(CFilename),'Testfile exists');
  FFileMoveApp.DoFileProcessing(CFilename,'.'+DirectorySeparator+'$p'+DirectorySeparator+'$t'+DirectorySeparator,true,true,@TestTextOut);
  finally
  chdir(lCurrDur);
  end;
end;

procedure TTestFileMove.TestFileMove5_Conf;

const CFilename = 'STEUERUNGSKONFIGURATION.EXP';
      CDestPath = 'Ressource';
var
  rmDirs, lMoveLogFile: String;
  lTt :Text;

begin
  try
  CreateTestData(CFilename);
  (*
  lMoveLogFile := FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog');
  mkdir(FDataDir+DirectorySeparator+'.movelog');
  AssignFile(lTt,lMoveLogFile );
  rewrite(lTt);
  writeln(lTt, FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename);
  CloseFile(lTt);
  *)
  Checktrue(Fileexists(FDataDir+DirectorySeparator+CFilename),'Testfile exists');
  FFileMoveApp.DoFileProcessing(FDataDir+DirectorySeparator+CFilename,FDataDir+'$p'+DirectorySeparator+'$t'+DirectorySeparator,true,true,@TestTextOut);
  Checkfalse(Fileexists(FDataDir+DirectorySeparator+CFilename),'Testfile does not exists on old Place');
  CheckTrue(Fileexists(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename),'Testfile exists on new place');
  CheckTrue(Fileexists(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog')),'Movelog-file exists');
  CheckEquals(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename+LineEnding,FOutStrings.text,'Ausgabe');
// Todo: Weitere Tests
  finally
    // Aufräumen nach dem Test
     if Fileexists(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename) then
       deletefile(FDataDir+DirectorySeparator+CDestPath+DirectorySeparator+CFilename);
     if Fileexists(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog')) then
       deletefile(FDataDir+DirectorySeparator+'.movelog'+DirectorySeparator+changefileext(CFilename,'.movelog'));
     if DirectoryExists(FDataDir+DirectorySeparator+'.movelog') then
       rmdir(FDataDir+DirectorySeparator+'.movelog');
     rmDirs := CDestPath;
     while (rmDirs <>'') and DirectoryExists(FDataDir+DirectorySeparator+rmDirs)  do
       begin
          RemoveDir(FDataDir+DirectorySeparator+rmDirs);
          rmDirs:=ExtractFilePath(ExcludeTrailingPathDelimiter(rmdirs));
       end;
  end;
end;


initialization

  RegisterTest(TTestFileMove);
end.

