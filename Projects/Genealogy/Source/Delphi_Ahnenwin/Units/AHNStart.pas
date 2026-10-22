unit AHNStart;

{-------------------------------------------------------------------------------
  AHNStart - finds the directory that holds the data of the program.

  The program works with relative paths - the BDE alias, the picture
  directory "Bilder", par.cfg, style.css - so the data has to be found at
  run time. The original program expects the program file to lie in the
  directory of the data. The reconstruction looks for the data in this
  order:

    1. the parameter of the program ("AHNWIN51 <Verzeichnis>"),
    2. the file AHNWIN51.ini next to the program file,
    3. the directory of the program file, if it holds AWD.DB,
    4. the current directory, if it holds AWD.DB,
    5. the directory of the program file.

  The result always ends with a backslash. Note that GetCurrentDir of
  Delphi 9 does *not* add one, so every path that is built from the
  current directory has to be closed with IncludeTrailingPathDelimiter.
-------------------------------------------------------------------------------}

interface

{ The directory of the data, with a trailing backslash. }
function DatenVerzeichnis: string;

{ Sets the current directory to the directory of the data and returns it. }
function DatenVerzeichnisSetzen: string;

{ Shows the splash screen. The original program creates it before the main
  form and lets the main form close it again. The order matters: the
  reader of the resources resolves the references to the data module
  while the form is streamed, and that only works when the splash
  screen has been created before. }
procedure SplashZeigen;

implementation

uses
  SysUtils, Classes, IniFiles, Windows, Forms, Unit8;

function DatenVerzeichnisAusIni: string;
var
  ini: TIniFile;
begin
  Result := '';
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'AHNWIN51.ini');
  try
    Result := Trim(ini.ReadString('Daten', 'Verzeichnis', ''));
  finally
    ini.Free;
  end;
  if Result <> '' then
    Result := IncludeTrailingPathDelimiter(ExpandFileName(Result));
end;

function DatenVerzeichnis: string;
var
  p: string;
begin
  p := '';
  if ParamCount > 0 then
    p := IncludeTrailingPathDelimiter(ExpandFileName(ParamStr(1)))
  else if DatenVerzeichnisAusIni <> '' then
    p := DatenVerzeichnisAusIni
  else if FileExists(ExtractFilePath(ParamStr(0)) + 'AWD.DB') then
    p := ExtractFilePath(ParamStr(0))
  else if FileExists('AWD.DB') then
    p := IncludeTrailingPathDelimiter(GetCurrentDir)
  else
    p := ExtractFilePath(ParamStr(0));
  Result := p;
end;

function DatenVerzeichnisSetzen: string;
begin
  Result := DatenVerzeichnis;
  SetCurrentDir(Result);
end;

procedure SplashZeigen;
begin
  Form8 := TForm8.Create(nil);
  Form8.Show;
  Form8.Update;
end;

end.
