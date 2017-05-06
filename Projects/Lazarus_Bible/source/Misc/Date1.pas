procedure TForm1.Button1Click(Sender: TObject);
var
  D1, D2: TDateTime;  // Date variables
  I: Integer;         // for-loop variable
begin
  D1 := StrToDate('1/31/98');
  for I := -12 to 12 do
  begin
    D2 := IncMonth(D1, I);
    ListBox1.Items.Add(DateToStr(D2));
  end;
end;
