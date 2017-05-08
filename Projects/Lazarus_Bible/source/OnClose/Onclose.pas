procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('End the program?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then CanClose := True
    else CanClose := False;
end;
