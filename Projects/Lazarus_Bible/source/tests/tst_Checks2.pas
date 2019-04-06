unit tst_Checks2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,Forms;

type

  { TTestChecks }

  TTestChecks= class(TTestCase)
  private
    FTestForm:TForm;
    FIdleCnt: Integer;
    procedure AppUserInput(Sender: TObject; Msg: Cardinal);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestMainForm;
  end;

implementation

uses Frm_Checks2MAIN;

procedure TTestChecks.TestSetUp;
begin
 CheckNotNull(FTestForm,'Form ist assigned');
 CheckTrue(FTestForm.Visible);
end;

procedure TTestChecks.AppUserInput(Sender: TObject; Msg: Cardinal);
begin
 FIdleCnt:=0;
end;

procedure TTestChecks.SetUp;
begin
  if not assigned(frmChecks2Main) then
    Application.CreateForm(TfrmChecks2Main,frmChecks2Main);
  FTestForm:=frmChecks2Main;
  frmChecks2Main.show;
end;

procedure TTestChecks.TearDown;
begin
  FTestForm.hide;
end;

procedure TTestChecks.TestMainForm;
var
  lOrgCaption: string;
begin
  lOrgCaption:= FTestForm.Caption;
  Application.OnUserInput:=@AppUserInput;
  while FTestForm.Visible do
  begin
        Application.Idle(false);
        Application.ProcessMessages;
        inc(fIdleCnt);
        sleep(10);
        if fIdleCnt> 300 then
          FTestForm.Hide
        else
          FTestForm.Caption := lOrgCaption+' ['+StringOfChar('|',30-fIdleCnt div 10)+StringOfChar(' ',fIdleCnt div 10)+']';
     end;
  FTestForm.Caption:=lOrgCaption;
end;

initialization

  RegisterTest(TTestChecks);
end.

