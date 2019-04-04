unit tst_CapsLock2;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFDEF FPC} , fpcunit, testutils, testregistry {$ELSE} , testsuite {$ENDIF};

type

  { TTestCapsLock2 }

  TTestCapsLock2= class(TTestCase)
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

uses Forms, Frm_Capslock2MAIN;

procedure TTestCapsLock2.TestSetUp;
begin
  CheckNotNull(frmCapsLock2Main,'CapsLock2Main ist assigned');
  CheckTrue(frmCapsLock2Main.Visible);
end;

procedure TTestCapsLock2.TestMainForm;
var
  lOrgCaption: String;
begin
  lOrgCaption:= frmCapsLock2Main.Caption;
  Application.OnUserInput:=@AppUserInput;
  while frmCapsLock2Main.Visible do
  begin
        Application.Idle(false);
        Application.ProcessMessages;
        inc(fIdleCnt);
        sleep(10);
        if fIdleCnt> 300 then
          frmCapsLock2Main.Hide
        else
          frmCapsLock2Main.Caption := 'CapsLock ['+StringOfChar('|',30-fIdleCnt div 10)+StringOfChar(' ',fIdleCnt div 10)+']';
     end;
  frmCapsLock2Main.Caption:=lOrgCaption;
end;

procedure TTestCapsLock2.AppUserInput(Sender: TObject; Msg: Cardinal);
begin
  FIdleCnt:=0;
end;

procedure TTestCapsLock2.SetUp;
begin
  if not assigned(frmCapsLock2Main) then
    Application.CreateForm(TfrmCapsLock2Main,frmCapsLock2Main);
  frmCapsLock2Main.show;
end;

procedure TTestCapsLock2.TearDown;
begin
   frmCapsLock2Main.hide;
end;

initialization

  RegisterTest({$IFDEF FPC} TTestCapsLock2 {$ELSE} TTestCapsLock2.suite {$ENDIF});
end.

