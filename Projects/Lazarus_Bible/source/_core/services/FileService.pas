{ Dateidienst: Lesen und Schreiben von Textdateien, portabel fuer Delphi
  und Free Pascal. }

unit FileService;

interface

uses
  Classes, SysUtils, ServiceBase;

type
  { TFileService }
  TFileService = class(TServiceBase)
  public
    constructor Create;
    { Liest eine Textdatei zeilenweise. Wirft TServiceError, wenn die Datei
      nicht lesbar ist. }
    function ReadLines(const AFileName: string): TStringList;
    { Schreibt die Zeilen in eine Textdatei (Atomar: erst in eine
      Temp-Datei, dann umbenannt). }
    procedure WriteLines(const AFileName: string; ALines: TStrings);
    function FileExists(const AFileName: string): Boolean;
    { Liefert den Namen der Datei ohne Verzeichnis. }
    function BaseName(const AFileName: string): string;
  end;

implementation

constructor TFileService.Create;
begin
  inherited Create('Datei');
end;

function TFileService.ReadLines(const AFileName: string): TStringList;
begin
  Result := TStringList.Create;
  try
    if not FileExists(AFileName) then
      Fail('Datei nicht gefunden: ' + AFileName);
    Result.LoadFromFile(AFileName);
    Log('gelesen: ' + AFileName);
  except
    Result.Free;
    raise;
  end;
end;

procedure TFileService.WriteLines(const AFileName: string; ALines: TStrings);
var
  TempName: string;
begin
  TempName := AFileName + '.tmp';
  try
    ALines.SaveToFile(TempName);
    if FileExists(AFileName) then
      DeleteFile(AFileName);
    RenameFile(TempName, AFileName);
    Log('geschrieben: ' + AFileName);
  except
    on E: Exception do
    begin
      if FileExists(TempName) then
        DeleteFile(TempName);
      Fail('Schreiben fehlgeschlagen: ' + E.Message);
    end;
  end;
end;

function TFileService.FileExists(const AFileName: string): Boolean;
begin
  Result := SysUtils.FileExists(AFileName);
end;

function TFileService.BaseName(const AFileName: string): string;
begin
  Result := ExtractFileName(AFileName);
end;

end.
