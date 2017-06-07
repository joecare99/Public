program FileMove;

{$APPTYPE CONSOLE}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

uses
  SysUtils,
  unt_cdate in 'C:\unt_cdate.pas',
  Unt_FileMove in '..\Source\Unt_FileMove.pas',
  Cmp_SEWFile in '..\..\daten\Source\Cmp_SEWFile.pas';

begin
    Application.Init;
    Application.title := 'FileMove';
    Application.run;
end.
