program Splashin;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  Splash in 'SPLASH.PAS' {SplashForm};

{$R *.RES}

begin
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Update;
  Application.CreateForm(TMainForm, MainForm);
  SplashForm.Close;
  Application.Run;
end.

