Program	Asteroids;
uses
  Forms,
  uGame in '..\..\Grafik\spiele\asteroids_src\uGame.pas',
  uMain in '..\..\Grafik\spiele\asteroids_src\uMain.pas' {Main},
  uSettings in '..\..\Grafik\spiele\asteroids_src\uSettings.pas' {Settings},
  uKeys in '..\..\Grafik\spiele\asteroids_src\uKeys.pas' {Keys},
  uInfo in '..\..\Grafik\spiele\asteroids_src\uInfo.pas' {Info},
  uDlg_EnterName in '..\..\Grafik\spiele\asteroids_src\uDlg_EnterName.pas' {Dlg_EnterName},
  uHighscores in '..\..\Grafik\spiele\asteroids_src\uHighscores.pas' {Highscores};

{$R *.RES}


Begin
Randomize;
Application.Initialize;
Application.Title := 'Asteroids';
Application.CreateForm(TMain, Main);
  Application.CreateForm(TSettings, Settings);
  Application.CreateForm(TKeys, Keys);
  Application.CreateForm(TInfo, Info);
  Application.CreateForm(TDlg_EnterName, Dlg_EnterName);
  Application.CreateForm(THighscores, Highscores);
  Application.Run;
End.
