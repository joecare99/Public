program AHW52_Main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, frmAhnenWinMain, GenealogyDataModule, AboutForm, frm_Splash,
  PersonSearchForm
  { you can add units after this };

{$R *.res}

begin
  Application.Scaled := True;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmSplash, frmSplash);
  frmSplash.Show;
  frmSplash.Update;
  Application.Title := 'AHNENWIN 5.1';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TGenealogyDataModule, DataModule2);
  Application.CreateForm(TAboutForm, AboutDialog);
  Application.Run;
end.
