program AHW52_Main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, frmAhnenWinMain, GenealogyDataModule,
  GenealogyDataModuleAccess, AboutForm, frm_Splash,
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
  DataModule2.InitializeDataAccess;
  Application.CreateForm(TAboutForm, AboutDialog);
  try
    GenealogyDataModuleAccess.GenealogyDataModule :=
      CreateGenealogyDataModuleAdapter(DataModule2);
    GenealogyDataModuleAccess.TemporaryDataModule :=
      CreateTemporaryDataModuleAdapter(DataModule2);
    Application.Run;
  finally
    GenealogyDataModuleAccess.TemporaryDataModule := nil;
    GenealogyDataModuleAccess.GenealogyDataModule := nil;
  end;
end.
