program GameBase;

{$ifdef FPC}
{$mode delphi}{$H+}
{$ENDIF ~FPC}
{$APPTYPE CONSOLE}

uses
  SysUtils,
  {$ifdef FPC}
interfaces,
{$ENDIF ~FPC}
  Cls_GameBase in '..\source\Cls_GameBase.pas',
  Unt_GameBase in '..\source\Unt_GameBase.pas',
  Unt_TerraGen in '..\source\Unt_TerraGen.pas',
  int_GameHMI in '..\source\int_GameHMI.pas',
  cls_CrtBaseGameHMI in '..\source\cls_CrtBaseGameHMI.pas';

begin
  try
    Init;
    Execute;
    Done;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
