procedure TForm1.Button1Click(Sender: TObject);
var
  I, J, K, Q, R, S, T: Integer;
begin
  I := 20; J := 10; Q := 123; T := 456;
  try
    K := (I div J) - 2;
    R := Q div K;  // ???
    S := T div R;
  except
    ShowMessage(
     'Divide error! '+
     ' I=' + IntToStr(I) +
     ' J=' + IntToStr(J) +
     ' K=' + IntToStr(K) +
     ' Q=' + IntToStr(Q) +
     ' R=' + IntToStr(R) +
     ' S=' + IntToStr(S) +
     ' T=' + IntToStr(T) );
  end;
end;
