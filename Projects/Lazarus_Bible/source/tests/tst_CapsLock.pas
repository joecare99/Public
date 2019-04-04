unit tst_CapsLock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

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

  RegisterTest(TTestCapsLock);
end.

