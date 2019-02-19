unit tst_Calc32;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  { TTestCalc32 }

  TTestCalc32= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestMainForm;
    procedure TestAboutForm;

  end;

implementation

uses Forms,Frm_CALC,Frm_CalcABOUT;

procedure TTestCalc32.SetUp;
begin
  if not assigned(frmCalcMain) then
  Application.CreateForm(TfrmCalcMain,frmCalcMain);
  if not assigned(frmCalcAbout) then
  Application.CreateForm(TfrmCalcAbout,frmCalcAbout);
end;

procedure TTestCalc32.TearDown;
begin
  frmCalcMain.btnClearClick(nil);
  frmCalcMain.hide;
  frmCalcAbout.hide;
end;

procedure TTestCalc32.TestSetUp;
begin
  CheckNotNull(frmCalcMain,'Calc32 Mainform is initialized');
  CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
  CheckNotNull(frmCalcAbout,'Calc About-form is initialized');
  CheckFalse(frmCalcAbout.Visible,'About is not visible at the moment');
end;

procedure TTestCalc32.TestMainForm;
begin
  CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
  frmCalcMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
  frmCalcMain.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
  frmCalcMain.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
  frmCalcMain.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmCalcMain.Visible,'MainForm is visible now');
end;

procedure TTestCalc32.TestAboutForm;
begin
  CheckFalse(frmCalcAbout.Visible,'MainForm is not visible at the moment');
  frmCalcAbout.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcAbout.Visible,'MainForm is visible now');
  frmCalcAbout.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcAbout.Visible,'MainForm is visible now');
  frmCalcAbout.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcAbout.Visible,'MainForm is visible now');
  frmCalcAbout.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmCalcAbout.Visible,'MainForm is visible now');
end;

initialization

  RegisterTest(TTestCalc32);
end.

