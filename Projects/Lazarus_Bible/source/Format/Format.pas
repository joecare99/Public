procedure TForm1.Button1Click(Sender: TObject);
var
  R1, R2: Double;
  S: string;
begin
  R1 := Frac(Pi);
  R2 := Int(Pi);
  S := Format('Pi= %8.7G,  Frac=%8.6F,  Int=%G',
    [Pi, R1, R2]);
  Label1.Caption := S;
end;
