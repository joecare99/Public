procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  S: string;
begin
  if Key = vk_Tab then
  begin
    S := 'Tab Key Pressed';
    if ssShift in Shift then
      S := 'Shift-' + S;
    ShowMessage(S);
  end;
end;
