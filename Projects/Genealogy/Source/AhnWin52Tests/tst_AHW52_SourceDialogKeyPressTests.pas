unit tst_AHW52_SourceDialogKeyPressTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52SourceDialogKeyPress = class(TTestCase)
  published
    procedure TestEnterPostsNextDialogControlAndIsConsumed;
    procedure TestOtherKeyIsPreserved;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Windows, Forms, Messages, SysUtils, Unit30;

procedure TTestAHW52SourceDialogKeyPress.TestEnterPostsNextDialogControlAndIsConsumed;
var
  sourceForm: TForm30;
  key: Char;
  message: TMsg;
begin
  Application.Initialize;
  sourceForm := TForm30.CreateNew(nil);
  try
    message := Default(TMsg);
    key := #13;
    sourceForm.FormKeyPress(sourceForm, key);

    if key <> #0 then
      raise Exception.Create('Enter should be consumed.');
    if not PeekMessage(message, sourceForm.Handle, WM_NEXTDLGCTL,
      WM_NEXTDLGCTL, PM_REMOVE) then
      raise Exception.Create('Enter should post WM_NEXTDLGCTL.');
  finally
    sourceForm.Free;
  end;
end;

procedure TTestAHW52SourceDialogKeyPress.TestOtherKeyIsPreserved;
var
  sourceForm: TForm30;
  key: Char;
  message: TMsg;
begin
  Application.Initialize;
  sourceForm := TForm30.CreateNew(nil);
  try
    message := Default(TMsg);
    key := 'X';
    sourceForm.FormKeyPress(sourceForm, key);

    if key <> 'X' then
      raise Exception.CreateFmt('Expected key X to remain unchanged, got %s.',
        [key]);
    if PeekMessage(message, sourceForm.Handle, WM_NEXTDLGCTL, WM_NEXTDLGCTL,
      PM_REMOVE) then
      raise Exception.Create('A non-Enter key must not post WM_NEXTDLGCTL.');
  finally
    sourceForm.Free;
  end;
end;

procedure TTestAHW52SourceDialogKeyPress.TestUnboundCounterIncrement;
var
  sourceForm: TForm30;
begin
  sourceForm := TForm30.CreateNew(nil);
  try
    GlobalVar_0061E0E4 := 12;
    sourceForm._PROC_005611A1(sourceForm);
    AssertEquals('Increment callback should add one.', 13,
      GlobalVar_0061E0E4);
  finally
    GlobalVar_0061E0E4 := 0;
    sourceForm.Free;
  end;
end;

procedure TTestAHW52SourceDialogKeyPress.TestUnboundCounterDecrement;
var
  sourceForm: TForm30;
begin
  sourceForm := TForm30.CreateNew(nil);
  try
    GlobalVar_0061E0E4 := 12;
    sourceForm._PROC_005611D0(sourceForm);
    AssertEquals('Decrement callback should subtract one.', 11,
      GlobalVar_0061E0E4);
  finally
    GlobalVar_0061E0E4 := 0;
    sourceForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52SourceDialogKeyPress);

end.
