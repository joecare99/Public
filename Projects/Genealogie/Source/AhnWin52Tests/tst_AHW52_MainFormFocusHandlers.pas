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
  end;

  TTestAHW52MainFormGridKeyDown = class(TTestCase)
  published
    procedure TestEscapeHidesGridAndOtherKeysPreserveIt;
  end;

implementation

uses
  Controls, DBCtrls, Forms, Grids, frmAhnenWinMain;

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

initialization
  RegisterTest(TTestAHW52MainFormFocusHandlers);
  RegisterTest(TTestAHW52MainFormGridKeyDown);

end.
