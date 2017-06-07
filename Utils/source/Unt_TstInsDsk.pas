unit Unt_TstInsDsk;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

Procedure Execute;

implementation

uses
  Win32Crt,
  INSDISK;

Procedure Execute;
begin
  repeat
  until InsertDisk(0) or keypressed;
end;

end.
