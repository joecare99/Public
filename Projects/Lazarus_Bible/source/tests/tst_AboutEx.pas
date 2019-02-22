unit tst_AboutEx;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$EndIF}

interface

uses
  Classes,Forms, SysUtils, {$IFNDEF FPC}TestFramework, {$Else} fpcunit, testutils, testregistry, {$endif} Frm_AboutExMAIN,frm_About;

type

  { TTestAboutex }

  TTestAboutex= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestMainForm;
    procedure TestAboutForm;
    procedure TestAboutClick;
  end;

implementation

procedure TTestAboutex.TestSetUp;
begin
  CheckNotNull(frmAboutMain,'AboutEx Mainform is initialized');
  CheckNotNull(frmAbout,'AboutEx Aboutform is initialized');
  CheckFalse(frmAbout.Visible,'About-Form is not visible at the moment');
  CheckFalse(frmAboutMain.Visible,'MainForm is not visible at the moment');
end;

procedure TTestAboutex.TestMainForm;
begin
  CheckFalse(frmAboutMain.Visible,'MainForm is not visible at the moment');
  frmAboutMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAboutMain.Visible,'MainForm is visible now');
  frmAboutMain.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAboutMain.Visible,'MainForm is visible now');
  frmAboutMain.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAboutMain.Visible,'MainForm is visible now');
  frmAboutMain.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmAboutMain.Visible,'MainForm is visible now');
end;

procedure TTestAboutex.TestAboutForm;
begin
  CheckFalse(frmAbout.Visible,'MainForm is not visible at the moment');
  frmAbout.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAbout.Visible,'MainForm is visible now');
  frmAbout.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAbout.Visible,'MainForm is visible now');
  frmAbout.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAbout.Visible,'MainForm is visible now');
  frmAbout.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmAbout.Visible,'MainForm is visible now');
end;

procedure TTestAboutex.TestAboutClick;
begin
  CheckFalse(frmAboutMain.Visible,'MainForm is not visible at the moment');
  frmAboutMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAboutMain.Visible,'MainForm is visible now');
  frmAboutMain.btnClickMeClick(frmAboutMain.btnClickMe);
  Application.ProcessMessages;
  sleep(100);
  frmAboutMain.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmAboutMain.Visible,'MainForm is visible now');
end;

procedure TTestAboutex.SetUp;
begin
  if not assigned(frmAboutMain) then
  Application.CreateForm(TfrmAboutMain,frmAboutMain);
  if not assigned(frmAbout) then
  Application.CreateForm(TfrmAbout,frmAbout);
end;

procedure TTestAboutex.TearDown;
begin
  frmAbout.hide;
  frmAboutMain.hide;
end;

initialization

  RegisterTest(TTestAboutex{$IFNDEF FPC}.Suite{$endif});
end.

