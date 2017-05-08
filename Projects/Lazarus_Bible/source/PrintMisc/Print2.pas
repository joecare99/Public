procedure TForm1.Button1Click(Sender: TObject);
var
  ScaleX, ScaleY: Integer;
  R: TRect;
begin
  Printer.BeginDoc;
  with Printer do
  try
    ScaleX := 
      GetDeviceCaps(Handle, logPixelsX) div PixelsPerInch;
    ScaleY := 
      GetDeviceCaps(Handle, logPixelsY) div PixelsPerInch;
    R := Rect(0, 0, Image1.Picture.Width * ScaleX,
      Image1.Picture.Height * ScaleY);
    Canvas.StretchDraw(R, Image1.Picture.Graphic);
  finally
    EndDoc;
  end;
end;
