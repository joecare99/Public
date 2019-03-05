unit testGPlace;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  TTestGPlace= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestGPlace.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TTestGPlace.SetUp;
begin

end;

procedure TTestGPlace.TearDown;
begin

end;

initialization

  RegisterTest(TTestGPlace);
end.

