unit tst_CharGrid;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, Controls{$IFDEF FPC},  fpcunit, testutils, testregistry {$ELSE} , testsuite {$ENDIF};

type

  { TTestCharGrid }

  TTestCharGrid= class(TTestCase)
  private
    FIdleCnt: Integer;
    procedure AppUserInput(Sender: TObject; Msg: Cardinal);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestMainForm;
    Procedure TestAboutForm;
  end;

implementation

uses Forms, Frm_CharGridABOUT,Frm_CharGridMAIN;

procedure TTestCharGrid.TestSetUp;
begin
  CheckNotNull(frmCharGridMain,'CharGridMain ist assigned');
  CheckNotNull(frmAboutForm,'AboutForm ist assigned');
  CheckTrue(frmCharGridMain.Visible);
end;

procedure TTestCharGrid.TestMainForm;
var
  lOrgCaption: TCaption;
begin
  lOrgCaption:= frmCharGridMain.Caption;
  Application.OnUserInput:=@AppUserInput;
  while frmCharGridMain.Visible do
  begin
        Application.Idle(false);
        Application.ProcessMessages;
        inc(fIdleCnt);
        sleep(10);
        if fIdleCnt> 300 then
          frmCharGridMain.Hide
        else
          frmCharGridMain.Caption := 'CharGrid ['+StringOfChar('|',30-fIdleCnt div 10)+StringOfChar(' ',fIdleCnt div 10)+']';
     end;
  frmCharGridMain.Caption:=lOrgCaption;
end;

procedure TTestCharGrid.TestAboutForm;
var
  lOrgCaption: TCaption;
begin
  frmCharGridMain.Hide;
  frmAboutForm.Show;
  lOrgCaption:= frmAboutForm.Caption;
  Application.OnUserInput:=@AppUserInput;
  while frmAboutForm.Visible do
  begin
        Application.Idle(false);
        Application.ProcessMessages;
        inc(fIdleCnt);
        sleep(10);
        if fIdleCnt> 300 then
          frmAboutForm.Hide
        else
          frmAboutForm.Caption := 'About ['+StringOfChar('|',30-fIdleCnt div 10)+StringOfChar(' ',fIdleCnt div 10)+']';
     end;
  frmAboutForm.Caption:=lOrgCaption;
end;

procedure TTestCharGrid.AppUserInput(Sender: TObject; Msg: Cardinal);
begin
   FIdleCnt:=0;
end;

procedure TTestCharGrid.SetUp;
begin
  if not assigned(frmCharGridMain) then
    Application.CreateForm(TfrmCharGridMain,frmCharGridMain);
  if not assigned(frmAboutForm) then
    Application.CreateForm(TfrmAboutForm,frmAboutForm);
  frmCharGridMain.show;
end;

procedure TTestCharGrid.TearDown;
begin
  frmCharGridMain.hide;
end;

initialization

  RegisterTest({$IFDEF FPC} TTestCharGrid {$ELSE} TTestCharGrid.suite {$ENDIF});
end.

