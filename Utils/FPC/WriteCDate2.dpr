Program WriteCDate2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$IFNDEF UNIX}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFDEF UNIX}
  Unt_CDate in '$HOME\Unt_CDate.pas',
  {$ELSE}
  unt_cdate in 'C:\unt_cdate.pas',
  {$ENDIF}
  Unt_WriteCDDate2 in '..\source\Unt_WriteCDDate2.pas';

{$R *.res}

Begin
  Execute;
End.
