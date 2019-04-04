unit tst_CharGrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  TTestCharGrid= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestCharGrid.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TTestCharGrid.SetUp;
begin

end;

procedure TTestCharGrid.TearDown;
begin

end;

initialization

  RegisterTest(TTestCharGrid);
end.

