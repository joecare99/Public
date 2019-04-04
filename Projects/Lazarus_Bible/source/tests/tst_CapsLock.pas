unit tst_CapsLock;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFDEF FPC} , fpcunit, testutils, testregistry {$ELSE} , testsuite {$ENDIF};

type

  TTestCapsLock= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestCapsLock.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TTestCapsLock.SetUp;
begin

end;

procedure TTestCapsLock.TearDown;
begin

end;

initialization

  RegisterTest({$IFDEF FPC} TTestCapsLock {$ELSE} TTestCapsLock.suite {$ENDIF});
end.

