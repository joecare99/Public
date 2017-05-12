procedure TForm1.Button1Click(Sender: TObject);
var
  Filename: String;
begin
  Filename := '\Delphi 4 Bible\Source\Readme.Txt';
  if InputQuery('Test', 'File?', Filename) then
    Memo1.Lines.LoadFromFile(Filename);
end;
