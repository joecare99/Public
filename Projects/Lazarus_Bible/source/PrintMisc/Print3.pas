procedure TForm1.Button1Click(Sender: TObject);
var
  P: TPicture;
  ScaleX, ScaleY: Integer;
  R: TRect;
begin
  P := TPicture.Create;
  try
  // Modify the pathname string in the following statement
  // to load any .bmp, .ico, or metafile:
    P.LoadFromFile('D:\Delphi 4 Bible\Source\Data\Sample.bmp');
    Printer.BeginDoc;
    with Printer do
    try
      ScaleX :=
        GetDeviceCaps(Handle, logPixelsX) div PixelsPerInch;
      ScaleY :=
        GetDeviceCaps(Handle, logPixelsY) div PixelsPerInch;
      R := Rect(0, 0, P.Width * ScaleX, P.Height * ScaleY);
      Canvas.StretchDraw(R, P.Graphic);
    finally
      Printer.EndDoc;
    end;
  finally
    P.Free;
  end;
end;
