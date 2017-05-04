procedure TForm1.Button1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  s : string;
begin
  if Sender = Button1 then
    s := 'Button1'
  else if Sender = Button2 then
    s := 'Button2'
  else if Sender = Button3 then
    s := 'Button3'
  else s := 'Unknown Object';
  ShowMessage('You clicked ' + s);
end;
