program Prj_testeventlog;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  Forms,
  unt_cdate in 'c:\unt_cdate.pas',
  frm_TestELMain in '..\Test\frm_TestELMain.PAS' {SDIAppForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.Run;
end.
 
