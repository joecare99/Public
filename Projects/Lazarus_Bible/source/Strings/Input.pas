procedure TForm1.Button1Click(Sender: TObject);
var
  S: String;
begin
  S := InputBox('Test', 'Enter a string', '');
  if Length(S) > 0 then
    ShowMessage('You entered: ' + S);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  S: String;
begin
  S := '';
  if InputQuery('Test', 'Type QUIT to end', S) then
    if Uppercase(S) = 'QUIT' then
      Close;
end;
