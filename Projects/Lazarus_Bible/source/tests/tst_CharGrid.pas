unit tst_CharGrid;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFDEF FPC} , fpcunit, testutils, testregistry {$ELSE} , testsuite {$ENDIF};

type

  TTestCharGrid= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
  end;

implementation

uses Forms, Frm_CharGridABOUT,Frm_CharGridMAIN;

procedure TTestCharGrid.TestSetUp;
begin
  CheckNotNull(frmCharGridMain,'CharGridMain ist assigned');
  CheckNotNull(frmAboutForm,'AboutForm ist assigned');
  CheckTrue(frmCharGridMain.Visible);
end;

procedure TTestCharGrid.SetUp;
begin
  if not assigned(frmCharGridMain) then
    Application.CreateForm(TfrmCharGridMain,frmCharGridMain);
  if not assigned(frmCharGridMain) then
    Application.CreateForm(TfrmAboutForm,frmAboutForm);
  frmCharGridMain.show;
end;

procedure TTestCharGrid.TearDown;
begin
  frmCharGridMain.hide;
end;

initialization

  RegisterTest(TTestCharGrid);
end.

