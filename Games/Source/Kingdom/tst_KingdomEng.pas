unit tst_KingdomEng;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  TTestKingdomEng= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestKingdomEng.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TTestKingdomEng.SetUp;
begin

end;

procedure TTestKingdomEng.TearDown;
begin

end;

initialization

  RegisterTest(TTestKingdomEng);
end.

