program Prj_testeventlog;

uses
  Forms,
  frm_TestELMain in '..\test\frm_TestELMain.PAS' {SDIAppForm},
  unt_cdate in 'C:\unt_cdate.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.Run;
end.
 
