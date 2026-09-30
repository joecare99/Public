unit tst_AHW52_RevolutionCalendarFormTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52RevolutionCalendarForm = class(TTestCase)
  private
    FCloseEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
  published
    procedure TestFormCreateScalesForLargeScreen;
    procedure TestEmptyCalendarComboChangesPreserveOutput;
    procedure TestFinishButtonClosesForm;
    procedure TestUnboundButtonHandlerClosesReceiver;
    procedure TestEscapeClosesForm;
    procedure TestOtherKeyDoesNotCloseForm;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Classes, StdCtrls, SysUtils, Unit7;

procedure TTestAHW52RevolutionCalendarForm.
  TestFormCreateScalesForLargeScreen;
var
  calendarForm: TForm7;
  screenWidth: Integer;
  screenHeight: Integer;
begin
  Application.Initialize;
  screenWidth := Screen.Width;
  screenHeight := Screen.Height;
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.SetBounds(0, 0, 640, 480);
    calendarForm.FormCreate(calendarForm);

    if (screenWidth > 640) and (screenHeight > 480) then
      AssertEquals('Large screens scale the calendar to screen width.',
        screenWidth, calendarForm.Width)
    else
      AssertEquals('Smaller screens retain the original form width.',
        640, calendarForm.Width);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.
  TestEmptyCalendarComboChangesPreserveOutput;
var
  calendarForm: TForm7;
begin
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.ComboBox1 := TComboBox.Create(calendarForm);
    calendarForm.ComboBox2 := TComboBox.Create(calendarForm);
    calendarForm.ComboBox3 := TComboBox.Create(calendarForm);
    calendarForm.Edit1 := TEdit.Create(calendarForm);
    calendarForm.Edit1.Text := 'Existing synthetic output';

    calendarForm.ComboBox1Change(calendarForm.ComboBox1);
    calendarForm.ComboBox2Change(calendarForm.ComboBox2);
    calendarForm.ComboBox3Change(calendarForm.ComboBox3);

    AssertEquals('Existing synthetic output', calendarForm.Edit1.Text);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52RevolutionCalendarForm.TestFinishButtonClosesForm;
var
  calendarForm: TForm7;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  calendarForm := TForm7.CreateNew(nil);
  Unit7.Form7 := calendarForm;
  try
    calendarForm.OnClose := @RecordFormClose;
    calendarForm.BitBtn1Click(calendarForm.BitBtn1);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit7.Form7 := nil;
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.
  TestUnboundButtonHandlerClosesReceiver;
var
  calendarForm: TForm7;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.OnClose := @RecordFormClose;
    calendarForm.Button1Click(nil);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestEscapeClosesForm;
var
  calendarForm: TForm7;
  key: Word;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.OnClose := @RecordFormClose;
    key := $1B;
    calendarForm.FormKeyDown(calendarForm, key, []);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestOtherKeyDoesNotCloseForm;
var
  calendarForm: TForm7;
  key: Word;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.OnClose := @RecordFormClose;
    key := $41;
    calendarForm.FormKeyDown(calendarForm, key, []);

    if FCloseEventCount <> 0 then
      raise Exception.CreateFmt('Expected no close event, got %d.',
        [FCloseEventCount]);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestUnboundCounterIncrement;
var
  calendarForm: TForm7;
begin
  calendarForm := TForm7.CreateNew(nil);
  try
    GlobalVar_025358F4 := 41;
    calendarForm._PROC_005CF32C(calendarForm);
    AssertEquals('Increment callback should add one.', 42,
      GlobalVar_025358F4);
  finally
    GlobalVar_025358F4 := 0;
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestUnboundCounterDecrement;
var
  calendarForm: TForm7;
begin
  calendarForm := TForm7.CreateNew(nil);
  try
    GlobalVar_025358F4 := 41;
    calendarForm._PROC_005CF35C(calendarForm);
    AssertEquals('Decrement callback should subtract one.', 40,
      GlobalVar_025358F4);
  finally
    GlobalVar_025358F4 := 0;
    calendarForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52RevolutionCalendarForm);

end.
