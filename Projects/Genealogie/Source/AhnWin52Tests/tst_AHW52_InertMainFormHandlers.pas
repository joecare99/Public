unit tst_AHW52_InertMainFormHandlers;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52InertMainFormHandlers = class(TTestCase)
  published
    procedure TestListingProvenNoOpHandlersLeaveFormStateUnchanged;
  end;

  TTestAHW52MainFormStringReset = class(TTestCase)
  published
    procedure TestDBEdit69ChangeClearsAddressBackedStrings;
  end;

  TTestAHW52MainFormProgressLabelReset = class(TTestCase)
  published
    procedure TestLab18einResetsAndShowsProgressLabels;
  end;

implementation

uses
  AHW52PersonEditFrame, AHW52RelationshipsFrame, Controls, Forms, StdCtrls,
  SysUtils, frmAhnenWinMain;

procedure TTestAHW52InertMainFormHandlers.
  TestListingProvenNoOpHandlersLeaveFormStateUnchanged;
var
  mainForm: TForm1;
  relationshipsFrame: TAHW52RelationshipsFrame;
begin
  Application.Initialize;
  mainForm := TForm1.CreateNew(nil);
  relationshipsFrame := nil;
  try
    relationshipsFrame := TAHW52RelationshipsFrame.Create(nil);
    mainForm.Caption := 'Synthetic main form';
    mainForm.ModalResult := 0;

    relationshipsFrame.TabSheet4Show(nil);
    mainForm.ComboBox4DblClick(nil);
    mainForm.DBEdit8Change(nil);
    mainForm.DBEdit9Change(nil);
    mainForm.DBEdit10Change(nil);
    mainForm.DBEdit5MouseDown(mainForm, mbLeft, [], 0, 0);
    mainForm.DBLookupComboBox1Enter(nil);
    mainForm.DBLookupComboBox2Enter(nil);
    mainForm.DBLookupComboBox3Enter(nil);
    mainForm.DBLookupComboBox4Enter(nil);
    mainForm.DBLookupComboBox5Enter(nil);
    mainForm.DBLookupComboBox6Enter(nil);
    mainForm.DBLookupComboBox7Enter(nil);
    mainForm.DBLookupComboBox8Enter(nil);
    mainForm.DBLookupComboBox9Enter(nil);
    mainForm.DBLookupComboBox10Enter(nil);
    mainForm.DBLookupComboBox11Enter(nil);
    mainForm.drucken2Click(nil);

    if mainForm.Caption <> 'Synthetic main form' then
      raise Exception.Create('No-op handlers must preserve the form caption.');
    if mainForm.ModalResult <> 0 then
      raise Exception.Create('No-op handlers must preserve the modal result.');
  finally
    relationshipsFrame.Free;
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormStringReset.
  TestDBEdit69ChangeClearsAddressBackedStrings;
var
  mainForm: TForm1;
  previousFirstValue: string;
  previousSecondValue: string;
  previousThirdValue: string;
begin
  Application.Initialize;
  previousFirstValue := GlobalVar_0061E0A0;
  previousSecondValue := GlobalVar_0061E0A4;
  previousThirdValue := GlobalVar_02535B58;
  mainForm := TForm1.CreateNew(nil);
  try
    GlobalVar_0061E0A0 := 'first synthetic value';
    GlobalVar_0061E0A4 := 'second synthetic value';
    GlobalVar_02535B58 := 'third synthetic value';

    mainForm.DBEdit69Change(nil);

    if GlobalVar_0061E0A0 <> '' then
      raise Exception.Create('DBEdit69Change must clear GlobalVar_0061E0A0.');
    if GlobalVar_0061E0A4 <> '' then
      raise Exception.Create('DBEdit69Change must clear GlobalVar_0061E0A4.');
    if GlobalVar_02535B58 <> '' then
      raise Exception.Create('DBEdit69Change must clear GlobalVar_02535B58.');
  finally
    GlobalVar_0061E0A0 := previousFirstValue;
    GlobalVar_0061E0A4 := previousSecondValue;
    GlobalVar_02535B58 := previousThirdValue;
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormProgressLabelReset.
  TestLab18einResetsAndShowsProgressLabels;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.PersonEditFrame := TAHW52PersonEditFrame.Create(mainForm);
    mainForm.PersonEditFrame.Parent := mainForm;
    mainForm.PersonEditFrame.Label18.Caption := 'stale progress';
    mainForm.PersonEditFrame.Label18.Visible := False;
    mainForm.PersonEditFrame.Label19.Caption := 'unchanged';
    mainForm.PersonEditFrame.Label19.Visible := False;

    mainForm.lab18ein(mainForm);

    AssertTrue(mainForm.PersonEditFrame.Label18.Visible);
    AssertEquals('0 %', mainForm.PersonEditFrame.Label18.Caption);
    AssertTrue(mainForm.PersonEditFrame.Label19.Visible);
    AssertEquals('unchanged', mainForm.PersonEditFrame.Label19.Caption);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52InertMainFormHandlers);
  RegisterTest(TTestAHW52MainFormStringReset);
  RegisterTest(TTestAHW52MainFormProgressLabelReset);

end.
