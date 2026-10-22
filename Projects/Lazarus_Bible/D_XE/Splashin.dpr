program Splashin;

uses
  Forms,
  Frm_SplashinMAIN in '..\SPLASHIN\Frm_SplashinMAIN.pas' {MainForm},
  Frm_SPLASH in '..\SPLASHIN\Frm_SPLASH.pas' {SplashForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Splashin - Demo';
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Update;
  Application.CreateForm(TMainForm, MainForm);
  SplashForm.Close;
  Application.Run;
end.

