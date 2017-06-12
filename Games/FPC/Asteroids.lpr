Program	Asteroids;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

uses
  Forms,
  {$IFDEF FPC}
  Interfaces,
  {$ENDIF}
  uGame in '..\source\asteroids\uGame.pas',
  uMain in '..\source\asteroids\uMain.pas' {Main},
  uSettings in '..\source\asteroids\uSettings.pas' {Settings},
  uKeys in '..\source\asteroids\uKeys.pas' {Keys},
  uInfo in '..\source\asteroids\uInfo.pas' {Info},
  uDlg_EnterName in '..\source\asteroids\uDlg_EnterName.pas' {Dlg_EnterName},
  uHighscores in '..\source\asteroids\uHighscores.pas' {Highscores};


{$R *.res}

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
