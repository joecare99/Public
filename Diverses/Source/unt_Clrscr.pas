unit unt_Clrscr;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
   windows,
{$ELSE}

{$ENDIF}

  SysUtils;

Procedure Execute;

implementation

Procedure Execute;
{$IFNDEF FPC}
var lASt:AnsiString;
{$ENDIF}
begin
  {$IFnDEF FPC}
  lASt := AnsiString(GetEnvironmentVariable('COMSPEC')+' /ccls');
  winexec(PansiChar(@lASt[1]),0);
  {$ELSE}
  ExecuteProcess(GetEnvironmentVariable('COMSPEC'),' /ccls');
  {$ENDIF}
end;

end.
