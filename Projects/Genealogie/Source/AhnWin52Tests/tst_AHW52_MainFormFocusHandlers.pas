unit tst_AHW52_MainFormFocusHandlers;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52MainFormFocusHandlers = class(TTestCase)
  published
    procedure TestFormActivateFocusesGlobalDBEdit2;
    procedure TestTabSheet2ShowFocusesDBEdit2;
    procedure TestDBGrid3ExitHidesGridAndLabelAndFocusesDBComboBox3;
  end;

  TTestAHW52MainFormGridKeyDown = class(TTestCase)
  published
    procedure TestEscapeHidesGridAndOtherKeysPreserveIt;
    procedure TestDBGrid3EscapeClearsAndHidesWithoutConsumingKey;
  end;

implementation

uses
  Controls, DBCtrls, DBGrids, Forms, Grids, StdCtrls, frmAhnenWinMain;

procedure TTestAHW52MainFormFocusHandlers.TestFormActivateFocusesGlobalDBEdit2;
var
  mainForm: TForm1;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.DBEdit2 := TDBEdit.Create(mainForm);
    mainForm.DBEdit2.Parent := mainForm;
    Form1 := mainForm;
    try
      mainForm.FormActivate(mainForm);

      AssertTrue('Activating the main form should focus its global DBEdit2.',
        mainForm.ActiveControl = mainForm.DBEdit2);
    finally
      Form1 := nil;
    end;
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormFocusHandlers.TestTabSheet2ShowFocusesDBEdit2;
var
  mainForm: TForm1;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.DBEdit2 := TDBEdit.Create(mainForm);
    mainForm.DBEdit2.Parent := mainForm;

    mainForm.TabSheet2Show(nil);

    AssertTrue('Showing the edit tab should focus DBEdit2.',
      mainForm.ActiveControl = mainForm.DBEdit2);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormFocusHandlers.
  TestDBGrid3ExitHidesGridAndLabelAndFocusesDBComboBox3;
var
  mainForm: TForm1;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.DBGrid3 := TDBGrid.Create(mainForm);
    mainForm.DBGrid3.Parent := mainForm;
    mainForm.DBGrid3.Visible := True;
    mainForm.Label81 := TLabel.Create(mainForm);
    mainForm.Label81.Parent := mainForm;
    mainForm.Label81.Visible := True;
    mainForm.DBComboBox3 := TDBComboBox.Create(mainForm);
    mainForm.DBComboBox3.Parent := mainForm;

    mainForm.DBGrid3Exit(mainForm.DBGrid3);

    AssertFalse('Leaving DBGrid3 should hide the grid.',
      mainForm.DBGrid3.Visible);
    AssertFalse('Leaving DBGrid3 should hide Label81.',
      mainForm.Label81.Visible);
    AssertTrue('Leaving DBGrid3 should focus DBComboBox3.',
      mainForm.ActiveControl = mainForm.DBComboBox3);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormGridKeyDown.
  TestEscapeHidesGridAndOtherKeysPreserveIt;
var
  mainForm: TForm1;
  key: Word;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.StringGrid5 := TStringGrid.Create(mainForm);
    mainForm.StringGrid5.Parent := mainForm;
    mainForm.StringGrid5.Visible := True;

    key := $001B;
    mainForm.StringGrid5KeyDown(mainForm.StringGrid5, key, []);

    AssertFalse('Escape should hide StringGrid5.',
      mainForm.StringGrid5.Visible);
    AssertEquals('The handler should leave the key unchanged.',
      $001B, key);

    mainForm.StringGrid5.Visible := True;
    key := Ord('A');
    mainForm.StringGrid5KeyDown(mainForm.StringGrid5, key, []);

    AssertTrue('A non-Escape key should leave StringGrid5 visible.',
      mainForm.StringGrid5.Visible);
    AssertEquals('The handler should leave ordinary keys unchanged.',
      Ord('A'), key);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormGridKeyDown.
  TestDBGrid3EscapeClearsAndHidesWithoutConsumingKey;
var
  mainForm: TForm1;
  key: Word;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.DBGrid3 := TDBGrid.Create(mainForm);
    mainForm.DBGrid3.Parent := mainForm;
    mainForm.DBComboBox3 := TDBComboBox.Create(mainForm);
    mainForm.DBComboBox3.Parent := mainForm;
    mainForm.Label81 := TLabel.Create(mainForm);
    mainForm.Label81.Parent := mainForm;
    mainForm.DBComboBox3.Text := 'synthetic value';
    mainForm.DBGrid3.Visible := True;
    mainForm.Label81.Visible := True;

    key := $001B;
    mainForm.DBGrid3KeyDown(mainForm.DBGrid3, key, []);

    AssertEquals('', mainForm.DBComboBox3.Text);
    AssertFalse(mainForm.DBGrid3.Visible);
    AssertFalse(mainForm.Label81.Visible);
    AssertTrue(mainForm.ActiveControl = mainForm.DBComboBox3);
    AssertEquals($001B, key);

    mainForm.DBGrid3.Visible := True;
    mainForm.Label81.Visible := True;
    mainForm.DBComboBox3.Text := 'preserved value';
    mainForm.ActiveControl := mainForm.DBGrid3;
    key := Ord('A');
    mainForm.DBGrid3KeyDown(mainForm.DBGrid3, key, []);

    AssertEquals('preserved value', mainForm.DBComboBox3.Text);
    AssertTrue(mainForm.DBGrid3.Visible);
    AssertTrue(mainForm.Label81.Visible);
    AssertTrue(mainForm.ActiveControl = mainForm.DBGrid3);
    AssertEquals(Ord('A'), key);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52MainFormFocusHandlers);
  RegisterTest(TTestAHW52MainFormGridKeyDown);

end.
