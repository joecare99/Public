unit tst_CapsLock2;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFDEF FPC} , fpcunit, testutils, testregistry {$ELSE} , testsuite {$ENDIF};

type

  TTestCapsLock2= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestCapsLock2.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TTestCapsLock2.SetUp;
begin

end;

procedure TTestCapsLock2.TearDown;
begin

end;

initialization

  RegisterTest({$IFDEF FPC} TTestCapsLock2 {$ELSE} TTestCapsLock2.suite {$ENDIF});
end.

