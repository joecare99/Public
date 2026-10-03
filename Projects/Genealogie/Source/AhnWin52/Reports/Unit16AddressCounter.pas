unit Unit16AddressCounter;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

var
  GlobalVar_0061E0C4: LongInt;

procedure IncrementUnit16AddressCounter;
procedure DecrementUnit16AddressCounter;

implementation

procedure IncrementUnit16AddressCounter;
begin
  Inc(GlobalVar_0061E0C4);
end;

procedure DecrementUnit16AddressCounter;
begin
  Dec(GlobalVar_0061E0C4);
end;

end.
