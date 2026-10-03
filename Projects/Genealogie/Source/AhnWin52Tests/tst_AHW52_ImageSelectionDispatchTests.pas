unit tst_AHW52_ImageSelectionDispatchTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52ImageSelectionDispatch = class(TTestCase)
  private
    FShownForm: TObject;
    FShowCount: Integer;
    procedure RecordImageSelectionShown(Sender: TObject);
  published
    procedure TestSpeedButtonShowsGlobalImageSelectionForm;
  end;

implementation

uses
  Forms, Unit10, Unit32;

procedure TTestAHW52ImageSelectionDispatch.RecordImageSelectionShown(
  Sender: TObject);
begin
  Inc(FShowCount);
  FShownForm := Sender;
end;

procedure TTestAHW52ImageSelectionDispatch.
  TestSpeedButtonShowsGlobalImageSelectionForm;
var
  eventReceiver: TForm10;
  imageSelectionForm: TForm32;
  previousImageSelectionForm: TForm32;
begin
  previousImageSelectionForm := Unit32.Form32;
  eventReceiver := nil;
  imageSelectionForm := nil;
  try
    eventReceiver := TForm10.CreateNew(nil);
    imageSelectionForm := TForm32.CreateNew(nil);
    FShownForm := nil;
    FShowCount := 0;
    imageSelectionForm.OnShow := @RecordImageSelectionShown;
    Unit32.Form32 := imageSelectionForm;

    eventReceiver.SpeedButton5Click(eventReceiver);

    AssertEquals(1, FShowCount);
    AssertSame(imageSelectionForm, FShownForm);
    AssertTrue('The global image-selection form should be visible.',
      imageSelectionForm.Visible);
  finally
    Unit32.Form32 := previousImageSelectionForm;
    if Assigned(imageSelectionForm) then
      imageSelectionForm.Free;
    if Assigned(eventReceiver) then
      eventReceiver.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52ImageSelectionDispatch);

end.
