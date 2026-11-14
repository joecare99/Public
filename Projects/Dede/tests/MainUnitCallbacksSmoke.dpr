program MainUnitCallbacksSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, MainUnit;

procedure Require(Value: Boolean; const MessageText: string);
begin
  if not Value then
    raise Exception.Create(MessageText);
end;

var
  Reference: string;
  ReferenceType: Byte;
begin
  Reference := 'unchanged';
  ReferenceType := $A5;
  Require(not GetCallReference(0, Reference, ReferenceType),
    'A zero call offset reported a reference');
  Require(Reference = 'unchanged',
    'A zero call offset changed the reference output');
  Require(ReferenceType = $A5,
    'A zero call offset changed the reference type');
  WriteLn('MainUnit callback smoke test passed');
end.
