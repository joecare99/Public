unit tst_AHW52_PlaceDialogKeyPressTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52PlaceDialogKeyPress = class(TTestCase)
  published
    procedure TestEnterPostsNextDialogControlAndIsConsumed;
    procedure TestOtherKeyIsPreserved;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Windows, Forms, Messages, SysUtils, Unit33;

procedure TTestAHW52PlaceDialogKeyPress.
  TestEnterPostsNextDialogControlAndIsConsumed;
var
  placeForm: TForm33;
  key: Char;
  message: TMsg;
begin
  Application.Initialize;
  placeForm := TForm33.CreateNew(nil);
  try
    message := Default(TMsg);
    key := #13;
    placeForm.FormKeyPress(placeForm, key);

    if key <> #0 then
      raise Exception.Create('Enter should be consumed.');
    if not PeekMessage(message, placeForm.Handle, WM_NEXTDLGCTL,
      WM_NEXTDLGCTL, PM_REMOVE) then
      raise Exception.Create('Enter should post WM_NEXTDLGCTL.');
  finally
    placeForm.Free;
  end;
end;

procedure TTestAHW52PlaceDialogKeyPress.TestOtherKeyIsPreserved;
var
  placeForm: TForm33;
  key: Char;
  message: TMsg;
begin
  Application.Initialize;
  placeForm := TForm33.CreateNew(nil);
  try
    message := Default(TMsg);
    key := 'X';
    placeForm.FormKeyPress(placeForm, key);

    if key <> 'X' then
      raise Exception.CreateFmt('Expected key X to remain unchanged, got %s.',
        [key]);
    if PeekMessage(message, placeForm.Handle, WM_NEXTDLGCTL, WM_NEXTDLGCTL,
      PM_REMOVE) then
      raise Exception.Create('A non-Enter key must not post WM_NEXTDLGCTL.');
  finally
    placeForm.Free;
  end;
end;

procedure TTestAHW52PlaceDialogKeyPress.TestUnboundCounterIncrement;
var
  placeForm: TForm33;
begin
  placeForm := TForm33.CreateNew(nil);
  try
    GlobalVar_0061DFB0 := 31;
    placeForm._PROC_0053B6C4(placeForm);
    AssertEquals('Increment callback should add one.', 32,
      GlobalVar_0061DFB0);
  finally
    GlobalVar_0061DFB0 := 0;
    placeForm.Free;
  end;
end;

procedure TTestAHW52PlaceDialogKeyPress.TestUnboundCounterDecrement;
var
  placeForm: TForm33;
begin
  placeForm := TForm33.CreateNew(nil);
  try
    GlobalVar_0061DFB0 := 31;
    placeForm._PROC_0053B6F4(placeForm);
    AssertEquals('Decrement callback should subtract one.', 30,
      GlobalVar_0061DFB0);
  finally
    GlobalVar_0061DFB0 := 0;
    placeForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PlaceDialogKeyPress);

end.
