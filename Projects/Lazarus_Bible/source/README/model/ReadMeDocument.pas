{ Dokument des Readme-Demos.

  Enthaelt den Pfad und den Inhalt der angezeigten Datei. Die Datei selbst
  wird ueber den Dateidienst gelesen, das Model bleibt rein. }

unit ReadMeDocument;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  { TReadMeDocument }
  TReadMeDocument = class
  private
    FFileName: string;
    FContent: string;
    procedure SetContent(const AValue: string);
  public
    constructor Create(const AFileName: string);
    { Inhalt der Datei (UTF-8). }
    property Content: string read FContent write SetContent;
    { Vollstaendiger Pfad der Datei. }
    property FileName: string read FFileName write FFileName;
    { Kurzname der Datei. }
    function BaseName: string;
  end;

implementation

constructor TReadMeDocument.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
end;

procedure TReadMeDocument.SetContent(const AValue: string);
begin
  FContent := AValue;
end;

function TReadMeDocument.BaseName: string;
begin
  Result := ExtractFileName(FFileName);
end;

end.
