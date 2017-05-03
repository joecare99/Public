{ Copy null-terminated text buffer to clipboard }
procedure TForm1.CopyButtonClick(Sender: TObject);
var
  P: PChar;  { Pointer to character buffer }
begin
  with Memo1 do
  begin
    if SelLength = 0 then   // If no text selected,
      SelectAll;            // select all lines of Memo1.
    if SelLength = 0 then   // If still no text selected,
      Exit;                 // Memo1 is empty--exit now.
    P := StrAlloc(SelLength + 1); // Allocate char buffer
    try
      GetTextBuf(P, SelLength + 1); // Copy text to buffer
      Clipboard.SetTextBuf(P); //Copy text buffer to clipboard
    finally
      StrDispose(P);  // Dispose of character buffer
    end;
  end;
end;

{ Copy null-terminated text buffer from clipboard }
procedure TForm1.PasteButtonClick(Sender: TObject);
var
  Data: THandle;
  DataPtr: PChar;
  P: PChar;
begin
  Clipboard.Open;
  try
    Data := GetClipboardData(cf_Text);
    if Data = 0 then Exit;
    DataPtr := GlobalLock(Data);
    try
      P := StrNew(DataPtr);
      Memo1.SetTextBuf(P);
    finally
      GlobalUnlock(Data);
      StrDispose(P);
    end;
  finally
    Clipboard.Close;
  end;
end;
