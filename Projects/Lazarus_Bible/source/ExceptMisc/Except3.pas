procedure TForm1.Button1Click(Sender: TObject);
var
  I, J, K, Q, R, S, T: Integer;
  { Sub-procedure for displaying error message }
  procedure ReportError;
  begin
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
begin
  I := 20; J := 10; Q := 123; T := 456;
  if J = 0 then ReportError else
  begin
    K := (I div J) - 2;
    if K = 0 then ReportError else
    begin
      R := Q div K;
      if R = 0 then ReportError else
      begin
        S := T div R;
      end;
    end;
  end;
end;
