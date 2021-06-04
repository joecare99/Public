program Prj_TstGDate;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_TestGDate in '..\source\Test_Gen\Frm_TestGDate.pas' {Form1},
  GBaseClasses in '..\source\Components\GBaseClasses.pas';

{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Test-Anwendung für TGDate-Classe';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
