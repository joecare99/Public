unit tst_AHW52_GregorianCalendarPrintTests;

{$mode objfpc}{$H+}

interface

uses
  Controls,
  StdCtrls,
  Buttons,
  Forms,
  fpcunit,
  testregistry;

type
  TTestAHW52GregorianCalendarPrint = class(TTestCase)
  private
    FCalendarForm: TCustomForm;
    FFollowYearButton: TButton;
    FPreviousYearButton: TButton;
    FOkButton: TBitBtn;
    FPrintButton: TSpeedButton;
    FFollowYearVisibleDuringPrint: Boolean;
    FPreviousYearVisibleDuringPrint: Boolean;
    FOkButtonVisibleDuringPrint: Boolean;
    FPrintButtonVisibleDuringPrint: Boolean;
    FPrintActionReceivedForm: Boolean;
    procedure ObservePrint(Sender: TObject);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestUnsupportedPrintRaisesBeforeAccessingControls;
    procedure TestVisibilityMatchesDuringPrintAndIsRestored;
  end;

implementation

uses
  GregorianCalendar,
  GregorianCalendarPrintCompatibilityError,
  GregorianCalendarPrintWorkflow;

procedure TTestAHW52GregorianCalendarPrint.
  TestUnsupportedPrintRaisesBeforeAccessingControls;
var
  calendarForm: TGregorianCalendarForm;
begin
  calendarForm := TGregorianCalendarForm.CreateNew(nil);
  try
    try
      calendarForm.btnPrintKalenderClick(calendarForm);
      Fail('The unsupported native print operation should raise an exception.');
    except
      on error: EGregorianCalendarPrintUnsupported do
        AssertEquals('Form.Print', error.Operation);
    end;
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52GregorianCalendarPrint.SetUp;
begin
  inherited SetUp;
  FCalendarForm := TForm.CreateNew(nil);

  FFollowYearButton := TButton.Create(FCalendarForm);
  FFollowYearButton.Parent := FCalendarForm;
  FFollowYearButton.Visible := True;

  FPreviousYearButton := TButton.Create(FCalendarForm);
  FPreviousYearButton.Parent := FCalendarForm;
  FPreviousYearButton.Visible := True;

  FOkButton := TBitBtn.Create(FCalendarForm);
  FOkButton.Parent := FCalendarForm;
  FOkButton.Visible := True;

  FPrintButton := TSpeedButton.Create(FCalendarForm);
  FPrintButton.Parent := FCalendarForm;
  FPrintButton.Visible := True;
end;

procedure TTestAHW52GregorianCalendarPrint.TearDown;
begin
  FCalendarForm.Free;
  inherited TearDown;
end;

procedure TTestAHW52GregorianCalendarPrint.ObservePrint(Sender: TObject);
begin
  FPrintActionReceivedForm := Sender = FCalendarForm;
  FFollowYearVisibleDuringPrint := FFollowYearButton.Visible;
  FPreviousYearVisibleDuringPrint := FPreviousYearButton.Visible;
  FOkButtonVisibleDuringPrint := FOkButton.Visible;
  FPrintButtonVisibleDuringPrint := FPrintButton.Visible;
end;

procedure TTestAHW52GregorianCalendarPrint.
  TestVisibilityMatchesDuringPrintAndIsRestored;
begin
  RunGregorianCalendarPrintWorkflow(FCalendarForm, FFollowYearButton,
    FPreviousYearButton, FOkButton, FPrintButton, @ObservePrint);

  AssertTrue('The print action should receive the calendar form.',
    FPrintActionReceivedForm);
  AssertFalse('The follow-year button should be hidden while printing.',
    FFollowYearVisibleDuringPrint);
  AssertTrue('The previous-year button should remain visible while printing.',
    FPreviousYearVisibleDuringPrint);
  AssertFalse('The OK button should be hidden while printing.',
    FOkButtonVisibleDuringPrint);
  AssertFalse('The print button should be hidden while printing.',
    FPrintButtonVisibleDuringPrint);
  AssertTrue('The follow-year button should be restored.',
    FFollowYearButton.Visible);
  AssertTrue('The previous-year button should be restored.',
    FPreviousYearButton.Visible);
  AssertTrue('The OK button should be restored.', FOkButton.Visible);
  AssertTrue('The print button should be restored.', FPrintButton.Visible);
end;

initialization
  RegisterTest(TTestAHW52GregorianCalendarPrint);

end.
