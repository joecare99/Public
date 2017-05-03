procedure TForm1.Button1Click(Sender: TObject);
var
  I, J, K: Integer;
begin
  I := 0;
  J := 10;
  try
    K := J div I;
  except
    on E: EDivByZero do
    begin
      ShowMessage(
       'Divide error! '+
       ' I=' + IntToStr(I) +
       ' J=' + IntToStr(J) +
       ' K=' + IntToStr(K) );
    end;
  end;
end;
