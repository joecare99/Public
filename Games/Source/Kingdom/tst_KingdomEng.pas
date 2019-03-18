unit tst_KingdomEng;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, {$IFNDEF FPC}TestFramework, {$Else} fpcunit, testutils, testregistry, {$endif}
  cls_KingdomEng;

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
  FKingdom:=TKin
end;

procedure TTestKingdomEng.TearDown;
begin

end;

initialization

  RegisterTest(TTestKingdomEng{$IFNDEF FPC}.Suite {$ENDIF});
end.

