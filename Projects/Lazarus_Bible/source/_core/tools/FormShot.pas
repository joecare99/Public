{ FormShot - rendert ein Formular in eine Bilddatei.

  Wird von den Demos ueber die Kommandozeilenoption '--screenshot' benutzt,
  um den Zustand einer Oberflaeche ohne X11-Screenshot zu dokumentieren. }

unit FormShot;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Graphics, Controls, Forms;

{ Zeichnet das Formular in ein Bitmap und speichert es (BMP oder PNG). }
procedure SaveFormToImage(AForm: TForm; const AFileName: string);

{ True, wenn das Programm im Screenshot-Modus laeuft. In diesem Fall
  sollten die Demos keine modalen Dialoge zeigen. }
function IsScreenshotMode: Boolean;

implementation

procedure SaveFormToImage(AForm: TForm; const AFileName: string);
var
  Bmp: TBitmap;
begin
  if AForm = nil then
    Exit;
  Bmp := TBitmap.Create;
  try
    Bmp.Width := AForm.Width;
    Bmp.Height := AForm.Height;
    AForm.PaintTo(Bmp.Canvas, 0, 0);
    Bmp.SaveToFile(AFileName);
  finally
    Bmp.Free;
  end;
end;

function IsScreenshotMode: Boolean;
begin
  Result := (ParamCount > 1) and (ParamStr(1) = '--screenshot');
end;

end.
