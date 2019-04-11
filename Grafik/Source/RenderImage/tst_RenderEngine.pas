unit tst_RenderEngine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils {$IFDEF FPC}, fpcunit, testregistry {$ELSE}, testframework {$ENDIF},
  cls_RenderSimpleObjects,
  cls_RenderEngine;

type

  TTestRenderImage= class(TTestCase)
  Private
    FRenderEngine:T
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestRenderImage.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TTestRenderImage.SetUp;
begin

end;

procedure TTestRenderImage.TearDown;
begin

end;

initialization

  RegisterTest(TTestRenderImage);
end.

