unit tst_CapsLock;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFDEF FPC} , fpcunit, testutils, testregistry {$ELSE} , testsuite {$ENDIF};

type

  { TTestCapsLock }

  TTestCapsLock= class(TTestCase)
  private
    FIdleCnt: Integer;
    procedure AppUserInput(Sender: TObject; Msg: Cardinal);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
     Procedure TestMainForm;
  end;

implementation

uses Forms, Frm_CapslockMAIN;

procedure TTestCapsLock.TestSetUp;
begin
  CheckNotNull(frmCapsLockMain,'CapsLockMain ist assigned');
  CheckTrue(frmCapsLockMain.Visible);
end;

procedure TTestCapsLock.TestMainForm;
var
  lOrgCaption: string;
begin
  lOrgCaption:= frmCapsLockMain.Caption;
  Application.OnUserInput:=@AppUserInput;
  while frmCapsLockMain.Visible do
  begin
        Application.Idle(false);
        Application.ProcessMessages;
        inc(fIdleCnt);
        sleep(10);
        if fIdleCnt> 300 then
          frmCapsLockMain.Hide
        else
          frmCapsLockMain.Caption := 'CapsLock ['+StringOfChar('|',30-fIdleCnt div 10)+StringOfChar(' ',fIdleCnt div 10)+']';
     end;
  frmCapsLockMain.Caption:=lOrgCaption;
end;

procedure TTestCapsLock.AppUserInput(Sender: TObject; Msg: Cardinal);
begin
  FIdleCnt:=0;
end;

procedure TTestCapsLock.SetUp;
begin
   if not assigned(frmCapsLockMain) then
    Application.CreateForm(TfrmCapsLockMain,frmCapsLockMain);
  frmCapsLockMain.show;

end;

procedure TTestCapsLock.TearDown;
begin
   frmCapsLockMain.Hide;
end;

initialization

  RegisterTest({$IFDEF FPC} TTestCapsLock {$ELSE} TTestCapsLock.suite {$ENDIF});
end.

