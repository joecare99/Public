function GetInt: Integer;
var
  I, J, K: Integer;
begin
  I := 0;
  J := 10;
  try
    K := J div I;  // Raises an exception
    Result := K;   // Assign function result (doesn't execute)
    ShowMessage('Results: K=' + IntToStr(K));
  except
    Result := 0;   // Assign function result on error
    ShowMessage('Divide error! ' +
     ' I=' + IntToStr(I) +
     ' J=' + IntToStr(J) );
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  K: Integer;
  P: Pointer;
begin
  GetMem(P, 4098);  // Allocate memory resource
  try
    K := GetInt;    // Might cause an exception
  finally
    FreeMem(P, 4098);  // Guaranteed to execute
    ShowMessage('Memory was freed');
  end;
end;
