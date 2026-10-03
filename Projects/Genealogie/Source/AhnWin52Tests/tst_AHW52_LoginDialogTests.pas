unit tst_AHW52_LoginDialogTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52LoginDialog = class(TTestCase)
  published
    procedure TestFormShowPreservesLabelWhenItFits;
    procedure TestFormShowShrinksLabelAtBoundary;
    procedure TestFormShowShrinksLabelWhenPanelIsNarrow;
  end;

implementation

uses
  Forms, ExtCtrls, StdCtrls,
  DBLogDlg in '..\Source\AhnWin52\Sys\DBLogDlg.pas';

procedure TTestAHW52LoginDialog.TestFormShowPreservesLabelWhenItFits;
var
  loginDialog: TLoginDialog;
begin
  Application.Initialize;
  loginDialog := TLoginDialog.CreateNew(nil);
  try
    loginDialog.Panel := TPanel.Create(loginDialog);
    loginDialog.DatabaseName := TLabel.Create(loginDialog);
    loginDialog.Panel.ClientWidth := 200;
    loginDialog.DatabaseName.Left := 20;
    loginDialog.DatabaseName.Width := 160;

    loginDialog.FormShow(nil);

    AssertEquals('A label that fits keeps its current width.', 160,
      loginDialog.DatabaseName.Width);
  finally
    loginDialog.Free;
  end;
end;

procedure TTestAHW52LoginDialog.TestFormShowShrinksLabelAtBoundary;
var
  loginDialog: TLoginDialog;
begin
  loginDialog := TLoginDialog.CreateNew(nil);
  try
    loginDialog.Panel := TPanel.Create(loginDialog);
    loginDialog.DatabaseName := TLabel.Create(loginDialog);
    loginDialog.Panel.ClientWidth := 180;
    loginDialog.DatabaseName.Left := 20;
    loginDialog.DatabaseName.Width := 160;

    loginDialog.FormShow(nil);

    AssertEquals('At the boundary the label gets a five-pixel margin.', 155,
      loginDialog.DatabaseName.Width);
  finally
    loginDialog.Free;
  end;
end;

procedure TTestAHW52LoginDialog.TestFormShowShrinksLabelWhenPanelIsNarrow;
var
  loginDialog: TLoginDialog;
begin
  loginDialog := TLoginDialog.CreateNew(nil);
  try
    loginDialog.Panel := TPanel.Create(loginDialog);
    loginDialog.DatabaseName := TLabel.Create(loginDialog);
    loginDialog.Panel.ClientWidth := 150;
    loginDialog.DatabaseName.Left := 20;
    loginDialog.DatabaseName.Width := 160;

    loginDialog.FormShow(nil);

    AssertEquals('A narrow panel reduces the label to the remaining width.',
      125, loginDialog.DatabaseName.Width);
  finally
    loginDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52LoginDialog);

end.
