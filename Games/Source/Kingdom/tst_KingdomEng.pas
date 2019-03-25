unit tst_KingdomEng;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, {$IFNDEF FPC}TestFramework, {$Else} fpcunit, testutils, testregistry, {$endif}
  cls_KingdomEng;

type

  { TTestKingdomEng }

  TTestKingdomEng= class(TTestCase)
  private
    FKingdom: TKingdomEngine;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestGameRun0;
  end;

implementation

procedure TTestKingdomEng.TestSetUp;
begin
  CheckNotNull(FKingdom,'Kingdom-Engine is Initialized');
  CheckTrue(FKingdom.GameEnded,'Game has ended by default');
end;

procedure TTestKingdomEng.TestGameRun0;
begin
  RandSeed:=0;
  FKingdom.NewGame;
  CheckFalse(FKingdom.GameEnded,'Game has not ended yet');
  CheckEquals(1,FKingdom.Year,'Game is in Year 1');
  CheckEquals(1000,FKingdom.Area,'Area');
  CheckEquals(100,FKingdom.Population,'Population');
  CheckEquals(2800,FKingdom.Storage,'Storage');
  CheckEquals(0,FKingdom.LandInProd,'LandInProd');
  CheckEquals(0,FKingdom.Distributed,'Distributed');
  CheckEquals(21,FKingdom.LandPrice,'LandPrice');
end;

procedure TTestKingdomEng.SetUp;
begin
  FKingdom:=TKingdomEngine.Create;
end;

procedure TTestKingdomEng.TearDown;
begin
  FreeAndNil(FKingdom) ;
end;

initialization

  RegisterTest(TTestKingdomEng{$IFNDEF FPC}.Suite {$ENDIF});
end.

