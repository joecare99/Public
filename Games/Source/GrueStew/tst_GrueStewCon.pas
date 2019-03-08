unit tst_GrueStewCon;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$EndIF}

interface

uses
  Classes, SysUtils,{$IFNDEF FPC}TestFramework, {$Else} fpcunit, testutils, testregistry, {$endif}con_GrueStew;

type

  TTestGrueStewCon= class(TTestCase)
  private
    FGrueStewCon:TMyApplication;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestGrueStewCon.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TTestGrueStewCon.SetUp;
begin
  FGrueStewCon:= TMyApplication.Create(nil);
end;

procedure TTestGrueStewCon.TearDown;
begin
  freeandnil(FGrueStewCon);
end;

initialization

  RegisterTest(TTestGrueStewCon);
end.

