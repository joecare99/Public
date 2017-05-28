unit test_StringTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, cmp_StringTable;

type

  { TTestStringTable }

  TTestStringTable= class(TTestCase)
  Private
    FDataPath:String;
    FStringTable:TStringTable;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestLoadFonts;
    Procedure TestLoadLanguage;
  end;

implementation

procedure TTestStringTable.TestSetUp;
begin
  Check(DirectoryExists(FDataPath),'Data-Directory exists');
  CheckNotNull(FStringTable,'Stringtable is assigned');
  Check(FileExists(FDataPath+DirectorySeparator+'fonts.txt'),'Fonts.txt exists');
  Check(FileExists(FDataPath+DirectorySeparator+'language.txt'),'language.txt exists');
  Check(FileExists(FDataPath+DirectorySeparator+'language2.txt'),'language2.txt exists');
end;

procedure TTestStringTable.TestLoadFonts;
var
  i: Integer;
  pp: SizeInt;
begin
  FStringTable.LoadFromCEvoFile(FDataPath+DirectorySeparator+'fonts.txt');
  CheckEquals(0,FStringTable.GetHandle('NORMAL'),'Index of Normalfont -> 0');
  CheckEquals(3,FStringTable.GetHandle('SMALL'),'Index of Normalfont -> 3');
  for i := 0 to FStringTable.Count-1 do
    if copy(FStringTable.Strings[i],1,1)='#' then
      begin
        pp := pos(FStringTable.Strings[i],' ');
        if pp = 0 then
          CheckEquals(i,FStringTable.GetHandle(copy(FStringTable.Strings[i],2,length(FStringTable.Strings[i])-1)),'Index of '+FStringTable.Strings[i])
        else
          CheckEquals(i,FStringTable.GetHandle(copy(FStringTable.Strings[i],2,pp-1)),'Index of '+FStringTable.Strings[i]);
      end;
end;

procedure TTestStringTable.TestLoadLanguage;
var
  i: Integer;
  pp: SizeInt;
begin
  FStringTable.LoadFromCEvoFile(FDataPath+DirectorySeparator+'language.txt');
  for i := 0 to FStringTable.Count-1 do
    if copy(FStringTable.Strings[i],1,1)='#' then
      begin
        pp := pos(FStringTable.Strings[i],' ');
        if pp = 0 then
          CheckEquals(i,FStringTable.GetHandle(copy(FStringTable.Strings[i],2,length(FStringTable.Strings[i])-1)),'Index of '+FStringTable.Strings[i])
        else
          CheckEquals(i,FStringTable.GetHandle(copy(FStringTable.Strings[i],2,pp-1)),'Index of '+FStringTable.Strings[i]);
      end;
end;

procedure TTestStringTable.SetUp;
Const
 cDPTempl='Data';
 cDPSubTempl='C-Evo';
var
  i: Integer;
begin
  if (FDataPath='') or (not DirectoryExists(FDataPath)) then
    begin
      FDataPath:=cDPTempl;
    for i := 0 to 2 do
      if not DirectoryExists(FDataPath) then
        FDataPath:= '..'+DirectorySeparator+ FDataPath
      else
        break;

    if not DirectoryExists(FDataPath) then
      {$IFDEF MSWINDOWS}
        FDataPath:=GetEnvironmentVariable('APPDATA')+DirectorySeparator+VendorName+DirectorySeparator+cDPSubTempl
      {$ENDIF}
      {$IFDEF UNIX}
        FDataPath:='~'+DirectorySeparator+'.'+cDPSubTempl
      {$ENDIF}
      else
        FDataPath:=FDataPath+DirectorySeparator+cDPSubTempl;
    end;
  FStringTable := TstringTable.create;
end;

procedure TTestStringTable.TearDown;
begin
  freeandnil(FStringTable)
end;

initialization

  RegisterTest(TTestStringTable);
end.

