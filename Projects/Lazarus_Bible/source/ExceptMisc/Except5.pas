procedure TForm1.Button1Click(Sender: TObject);
var
  I, J, K: Integer;
  P: Pointer;
begin
  I := 0;
  J := 10;
  GetMem(P, 4098);
  try
    try
      K := J div I;
      ShowMessage('Results: K=' + IntToStr(K));
    except
      ShowMessage('Divide error! ' +
       ' I=' + IntToStr(I) +
       ' J=' + IntToStr(J) );
    end;
  finally
    FreeMem(P, 4098);
    ShowMessage('Memory was freed');
  end;
end;
