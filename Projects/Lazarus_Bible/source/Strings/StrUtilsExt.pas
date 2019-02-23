unit StrUtilsExt;

interface

function IntToBin(Value: Longint; Digits: Integer): String;overload;
function IntToBin(Value: int64; Digits: Integer): String;overload;

implementation

{ Convert integer Value to binary string limited to Digits }
function IntToBin(Value: Longint; Digits: Integer): String;
var
  S: String;
begin
  S := '';               { Initialize string to null }
  while Digits > 0 do
  begin
    if Odd(Value) then S := '1' + S else S := '0' + S;
    Value := Value shr 1;
    Dec(Digits);
  end;
  Result := S;         { Return S as function result }
end;

function IntToBin(Value: Int64; Digits: Integer): String;
var
  S: String;
begin
  S := '';               { Initialize string to null }
  while Digits > 0 do
  begin
    if Odd(Value) then S := '1' + S else S := '0' + S;
    Value := Value shr 1;
    Dec(Digits);
  end;
  Result := S;         { Return S as function result }
end;


end.
