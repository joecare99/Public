unit tst_AHW52_FokoDialogCancelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52FokoDialog = class(TTestCase)
  published
    procedure TestLookupClickFocusesMemberNumberEdit;
    procedure TestActivationAssignsFokoAssociationListSource;
    procedure TestCancelButtonSetsCancelModalResult;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  SysUtils, Controls, DB, DBCtrls, StdCtrls, Unit2, Unit20;

procedure TTestAHW52FokoDialog.TestLookupClickFocusesMemberNumberEdit;
var
  fokoDialog: TForm20;
begin
  fokoDialog := TForm20.CreateNew(nil);
  try
    fokoDialog.Edit1 := TEdit.Create(fokoDialog);
    fokoDialog.Edit1.Parent := fokoDialog;

    fokoDialog.dblookupcombobox1Click(nil);

    AssertTrue('Lookup selection should move active control to Edit1.',
      fokoDialog.ActiveControl = fokoDialog.Edit1);
  finally
    fokoDialog.Free;
  end;
end;

procedure TTestAHW52FokoDialog.
  TestActivationAssignsFokoAssociationListSource;
var
  fokoDialog: TForm20;
  dataModule: TDataModule2;
  previousDataModule: TDataModule2;
begin
  Application.Initialize;
  previousDataModule := Unit2.DataModule2;
  dataModule := nil;
  fokoDialog := nil;
  try
    dataModule := TDataModule2.CreateNew(nil);
    Unit2.DataModule2 := dataModule;
    dataModule.DataSource19 := TDataSource.Create(dataModule);

    fokoDialog := TForm20.CreateNew(nil);
    fokoDialog.dblookupcombobox1 := TDBLookupComboBox.Create(fokoDialog);
    fokoDialog.dblookupcombobox1.Parent := fokoDialog;

    fokoDialog.FormActivate(fokoDialog);

    AssertTrue('Activation should use the FOKO association data source.',
      fokoDialog.dblookupcombobox1.ListSource = dataModule.DataSource19);
  finally
    Unit2.DataModule2 := previousDataModule;
    fokoDialog.Free;
    dataModule.Free;
  end;
end;

procedure TTestAHW52FokoDialog.TestCancelButtonSetsCancelModalResult;
var
  fokoDialog: TForm20;
begin
  Application.Initialize;
  fokoDialog := TForm20.CreateNew(nil);
  Unit20.Form20 := fokoDialog;
  try
    fokoDialog.ModalResult := mrNone;
    fokoDialog.BitBtn2Click(fokoDialog.BitBtn2);

    if fokoDialog.ModalResult <> mrCancel then
      raise Exception.CreateFmt('Expected mrCancel, got %d.',
        [fokoDialog.ModalResult]);
  finally
    Unit20.Form20 := nil;
    fokoDialog.Free;
  end;
end;

procedure TTestAHW52FokoDialog.TestUnboundCounterIncrement;
var
  fokoDialog: TForm20;
begin
  fokoDialog := TForm20.CreateNew(nil);
  try
    GlobalVar_025358E0 := 3;
    fokoDialog._PROC_005CD7E9(fokoDialog);
    AssertEquals('Increment callback should add one.', 4,
      GlobalVar_025358E0);
  finally
    GlobalVar_025358E0 := 0;
    fokoDialog.Free;
  end;
end;

procedure TTestAHW52FokoDialog.TestUnboundCounterDecrement;
var
  fokoDialog: TForm20;
begin
  fokoDialog := TForm20.CreateNew(nil);
  try
    GlobalVar_025358E0 := 3;
    fokoDialog._PROC_005CD818(fokoDialog);
    AssertEquals('Decrement callback should subtract one.', 2,
      GlobalVar_025358E0);
  finally
    GlobalVar_025358E0 := 0;
    fokoDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52FokoDialog);

end.
