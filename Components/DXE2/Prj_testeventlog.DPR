program Prj_testeventlog;

uses
  Forms,
  frm_TestELMain in '..\test\frm_TestELMain.PAS' {SDIAppForm},
  frm_testAbout in '..\test\frm_testAbout.PAS' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
 
