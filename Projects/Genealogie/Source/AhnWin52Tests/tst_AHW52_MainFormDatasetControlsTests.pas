unit tst_AHW52_MainFormDatasetControlsTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52MainFormDatasetControls = class(TTestCase)
  published
    procedure TestControlSuppressionAndReenableForBothDatasets;
  end;

implementation

uses
  Cmp_SQLTable, Forms, frmAhnenWinMain, GenealogyDataModule;

procedure TTestAHW52MainFormDatasetControls.
  TestControlSuppressionAndReenableForBothDatasets;
var
  dataModule: TGenealogyDataModule;
  mainForm: TForm1;
  previousDataModule: TGenealogyDataModule;
begin
  Application.Initialize;
  previousDataModule := GenealogyDataModule.DataModule2;
  dataModule := TGenealogyDataModule.CreateNew(nil);
  mainForm := nil;
  try
    mainForm := TForm1.CreateNew(nil);
    dataModule.Table1 := TSQLTable.Create(dataModule);
    dataModule.Table5 := TSQLTable.Create(dataModule);
    GenealogyDataModule.DataModule2 := dataModule;

    AssertFalse('Table1 must remain inactive.', dataModule.Table1.Active);
    AssertFalse('Table5 must remain inactive.', dataModule.Table5.Active);
    AssertFalse('Table1 controls start enabled.',
      dataModule.Table1.ControlsDisabled);
    AssertFalse('Table5 controls start enabled.',
      dataModule.Table5.ControlsDisabled);

    mainForm.tabdisab(nil);

    AssertTrue('tabdisab disables Table1 controls.',
      dataModule.Table1.ControlsDisabled);
    AssertTrue('tabdisab disables Table5 controls.',
      dataModule.Table5.ControlsDisabled);

    mainForm.tabenab(nil);

    AssertFalse('tabenab enables Table1 controls.',
      dataModule.Table1.ControlsDisabled);
    AssertFalse('tabenab enables Table5 controls.',
      dataModule.Table5.ControlsDisabled);
    AssertFalse('Table1 remains inactive.', dataModule.Table1.Active);
    AssertFalse('Table5 remains inactive.', dataModule.Table5.Active);
  finally
    GenealogyDataModule.DataModule2 := previousDataModule;
    mainForm.Free;
    dataModule.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52MainFormDatasetControls);

end.
