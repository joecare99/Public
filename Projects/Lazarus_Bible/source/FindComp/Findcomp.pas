procedure TForm1.Button1Click(Sender: TObject);
var
  C: TComponent;
  I, J, K: Integer;
begin
  K := 0;
  for I := 0 to Form1.ComponentCount - 1 do
  begin
    C := FindComponent('CheckBox' + IntToStr(I + 1));
    if C is TCheckBox then
      with C as TCheckBox do
        Checked := not Checked;
  end;
end;
