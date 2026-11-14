unit tst_AHW52_Unit19NoOpCallbackTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit19NoOpCallbacks = class(TTestCase)
  published
    procedure TestUnboundCallbacksPreserveModalResult;
    procedure TestVorchronResetsScreenCursor;
  end;

implementation

uses
  Controls, Forms, Unit19;

procedure TTestAHW52Unit19NoOpCallbacks.
  TestUnboundCallbacksPreserveModalResult;
var
  sourceForm: TForm19;
begin
  sourceForm := TForm19.CreateNew(nil);
  try
    sourceForm.ModalResult := 0;
    sourceForm.vorf(nil);
    AssertEquals(0, Ord(sourceForm.ModalResult));

    sourceForm.voralph(nil);
    AssertEquals(0, Ord(sourceForm.ModalResult));
  finally
    sourceForm.Free;
  end;
end;

procedure TTestAHW52Unit19NoOpCallbacks.TestVorchronResetsScreenCursor;
var
  sourceForm: TForm19;
  previousCursor: TCursor;
begin
  Application.Initialize;
  previousCursor := Screen.Cursor;
  sourceForm := TForm19.CreateNew(nil);
  try
    Screen.Cursor := crHourGlass;
    sourceForm.vorchron(nil);
    AssertEquals(Ord(crDefault), Ord(Screen.Cursor));
  finally
    Screen.Cursor := previousCursor;
    sourceForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit19NoOpCallbacks);

end.
