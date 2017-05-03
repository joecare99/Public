procedure TForm1.Button1Click(Sender: TObject);
var
  I, J, K: Integer;
  P: Pointer;
begin
  I := 0;
  J := 10;
  GetMem(P, 4098);  // Allocate memory resource
  try
    K := J div I;   // Raises an exception!
    ShowMessage('Results: ' +
     ' I=' + IntToStr(I) +
     ' J=' + IntToStr(J) +
     ' K=' + IntToStr(K) );
  finally
    FreeMem(P, 4098);  // Guaranteed to execute
    ShowMessage('Memory was freed');
  end;
end;
