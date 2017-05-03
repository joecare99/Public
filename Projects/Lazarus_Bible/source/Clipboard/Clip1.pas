procedure TForm1.CopyButtonClick(Sender: TObject);
begin
  with Memo1 do
  begin
    if SelLength = 0 then   // If no text selected,
      SelectAll;            // select all lines of Memo1.
    if SelLength = 0 then   // If still no text selected,
      Exit;                 // Memo1 is empty--exit now.
    Clipboard.Clear;
    Clipboard.AsText := Memo1.Text;
  end;
end;

procedure TForm1.PasteButtonClick(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_TEXT) then
    Memo1.Text := Clipboard.AsText;
end;
