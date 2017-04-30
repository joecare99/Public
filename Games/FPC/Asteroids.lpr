Program	Asteroids;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

uses
  Forms,
  {$IFDEF FPC}
  Interfaces,
  {$ENDIF}
  uGame in 'uGame.pas',
  uMain in 'uMain.pas' {Main},
  uSettings in 'uSettings.pas' {Settings},
  uKeys in 'uKeys.pas' {Keys},
  uInfo in 'uInfo.pas' {Info},
  uDlg_EnterName in 'uDlg_EnterName.pas' {Dlg_EnterName},
  uHighscores in 'uHighscores.pas' {Highscores};


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
