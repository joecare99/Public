procedure TForm1.Print1Click(Sender: TObject);
begin
  Printer.BeginDoc;
  try
    Printer.Canvas.Draw(0, 0, Image1.Picture.Graphic);
  finally
    Printer.EndDoc;
  end;
end;
