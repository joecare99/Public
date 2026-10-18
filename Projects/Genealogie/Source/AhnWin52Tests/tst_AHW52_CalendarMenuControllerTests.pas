unit tst_AHW52_CalendarMenuControllerTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms, frmAhnenWinMain, GregorianCalendar,
  FrenchRepublicanCalendarForm;

type
  TTestAHW52CalendarMenuController = class(TTestCase)
  private
    FMainForm: TForm1;
    FPreviousForm7: TFrenchRepublicanCalendarForm;
    procedure PrepareMainForm;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMenuOpensOwnedCalendarInModalLifecycle;
    procedure TestModalFailureStillReleasesAndClearsGlobalReference;
    procedure TestGregorianMenuPreservesOwnedViewModelLifecycle;
    procedure TestGregorianModalFailureStillFreesForm;
    procedure TestSaveFailurePropagatesBeforeCreatingCalendar;
    procedure TestMenuForwardsSenderToSaveAction;
  end;

implementation

uses
  Classes, ComCtrls, SysUtils;

type
  EInjectedCalendarDialogFailure = class(Exception);

  TRecordingMainForm = class(TForm1)
  private
    FCalls: TStringList;
    FDialog: TFrenchRepublicanCalendarForm;
    FGregorianDialog: TGregorianCalendarForm;
    FFailDuringShow: Boolean;
    FFailDuringGregorianShow: Boolean;
    FFailDuringSave: Boolean;
    FGlobalReferenceWasSet: Boolean;
    FGregorianViewModelWasAssigned: Boolean;
    FOwnerWasMainForm: Boolean;
    FExpectedSender: TObject;
    FSenderWasPreserved: Boolean;
    FTabWasActiveAtSave: Boolean;
  protected
    procedure ActivateCalendarEditTab; override;
    procedure SaveBeforeCalendar(Sender: TObject); override;
    function CreateGregorianCalendarForm: TGregorianCalendarForm; override;
    procedure ConfigureGregorianCalendarForm(
      CalendarForm: TGregorianCalendarForm); override;
    procedure ShowGregorianCalendarForm(
      CalendarForm: TGregorianCalendarForm); override;
    procedure DisposeGregorianCalendarForm(
      CalendarForm: TGregorianCalendarForm); override;
    function CreateFrenchRepublicanCalendarForm:
      TFrenchRepublicanCalendarForm; override;
    procedure AssignFrenchCalendarFormReference(
      CalendarForm: TFrenchRepublicanCalendarForm); override;
    procedure ShowFrenchRepublicanCalendarForm(
      CalendarForm: TFrenchRepublicanCalendarForm); override;
    procedure ReleaseFrenchRepublicanCalendarForm(
      CalendarForm: TFrenchRepublicanCalendarForm); override;
    procedure ClearFrenchCalendarFormReference; override;
  public
    destructor Destroy; override;
    procedure InitializeRecorder;
    property Calls: TStringList read FCalls;
    property Dialog: TFrenchRepublicanCalendarForm read FDialog;
    property GregorianDialog: TGregorianCalendarForm read FGregorianDialog;
    property FailDuringShow: Boolean
      read FFailDuringShow write FFailDuringShow;
    property FailDuringGregorianShow: Boolean
      read FFailDuringGregorianShow write FFailDuringGregorianShow;
    property FailDuringSave: Boolean
      read FFailDuringSave write FFailDuringSave;
    property GlobalReferenceWasSet: Boolean read FGlobalReferenceWasSet;
    property GregorianViewModelWasAssigned: Boolean
      read FGregorianViewModelWasAssigned;
    property OwnerWasMainForm: Boolean read FOwnerWasMainForm;
    property ExpectedSender: TObject
      read FExpectedSender write FExpectedSender;
    property SenderWasPreserved: Boolean read FSenderWasPreserved;
    property TabWasActiveAtSave: Boolean read FTabWasActiveAtSave;
  end;

destructor TRecordingMainForm.Destroy;
begin
  FCalls.Free;
  inherited Destroy;
end;

procedure TRecordingMainForm.InitializeRecorder;
begin
  FCalls := TStringList.Create;
end;

procedure TRecordingMainForm.ActivateCalendarEditTab;
begin
  inherited ActivateCalendarEditTab;
  FCalls.Add('activate');
end;

procedure TRecordingMainForm.SaveBeforeCalendar(Sender: TObject);
begin
  FCalls.Add('save');
  FTabWasActiveAtSave := PageControl1.ActivePage = TabSheet2;
  FSenderWasPreserved := Sender = FExpectedSender;
  if FFailDuringSave then
    raise EInjectedCalendarDialogFailure.Create('Injected save failure.');
end;

function TRecordingMainForm.CreateGregorianCalendarForm:
  TGregorianCalendarForm;
begin
  FCalls.Add('create-gregorian');
  FGregorianDialog := TGregorianCalendarForm.CreateNew(Self);
  Result := FGregorianDialog;
end;

procedure TRecordingMainForm.ConfigureGregorianCalendarForm(
  CalendarForm: TGregorianCalendarForm);
begin
  inherited ConfigureGregorianCalendarForm(CalendarForm);
  FCalls.Add('configure-gregorian');
  FGregorianViewModelWasAssigned := CalendarForm.ViewModel <> nil;
  FOwnerWasMainForm := CalendarForm.Owner = Self;
end;

procedure TRecordingMainForm.ShowGregorianCalendarForm(
  CalendarForm: TGregorianCalendarForm);
begin
  FCalls.Add('show-gregorian');
  if FFailDuringGregorianShow then
    raise EInjectedCalendarDialogFailure.Create('Injected modal failure.');
end;

procedure TRecordingMainForm.DisposeGregorianCalendarForm(
  CalendarForm: TGregorianCalendarForm);
begin
  FCalls.Add('free-gregorian');
  inherited DisposeGregorianCalendarForm(CalendarForm);
  FGregorianDialog := nil;
end;

function TRecordingMainForm.CreateFrenchRepublicanCalendarForm:
  TFrenchRepublicanCalendarForm;
begin
  FCalls.Add('create');
  FDialog := TFrenchRepublicanCalendarForm.CreateNew(Self);
  Result := FDialog;
end;

procedure TRecordingMainForm.AssignFrenchCalendarFormReference(
  CalendarForm: TFrenchRepublicanCalendarForm);
begin
  FCalls.Add('assign-reference');
  inherited AssignFrenchCalendarFormReference(CalendarForm);
end;

procedure TRecordingMainForm.ShowFrenchRepublicanCalendarForm(
  CalendarForm: TFrenchRepublicanCalendarForm);
begin
  FCalls.Add('show');
  FGlobalReferenceWasSet :=
    FrenchRepublicanCalendarForm.Form7 = CalendarForm;
  FOwnerWasMainForm := CalendarForm.Owner = Self;
  if FFailDuringShow then
    raise EInjectedCalendarDialogFailure.Create('Injected modal failure.');
end;

procedure TRecordingMainForm.ReleaseFrenchRepublicanCalendarForm(
  CalendarForm: TFrenchRepublicanCalendarForm);
begin
  FCalls.Add('release');
  CalendarForm.Free;
  FDialog := nil;
end;

procedure TRecordingMainForm.ClearFrenchCalendarFormReference;
begin
  FCalls.Add('clear-reference');
  inherited ClearFrenchCalendarFormReference;
end;

procedure TTestAHW52CalendarMenuController.SetUp;
begin
  inherited SetUp;
  Application.Initialize;
  FPreviousForm7 := FrenchRepublicanCalendarForm.Form7;
  FrenchRepublicanCalendarForm.Form7 := nil;
  FMainForm := TRecordingMainForm.CreateNew(nil);
  TRecordingMainForm(FMainForm).InitializeRecorder;
  PrepareMainForm;
end;

procedure TTestAHW52CalendarMenuController.TearDown;
begin
  FMainForm.Free;
  FrenchRepublicanCalendarForm.Form7 := TFrenchRepublicanCalendarForm(
    FPreviousForm7);
  inherited TearDown;
end;

procedure TTestAHW52CalendarMenuController.PrepareMainForm;
begin
  FMainForm.PageControl1 := TPageControl.Create(FMainForm);
  FMainForm.PageControl1.Parent := FMainForm;

  FMainForm.TabSheet1 := TTabSheet.Create(FMainForm);
  FMainForm.TabSheet1.PageControl := FMainForm.PageControl1;
  FMainForm.TabSheet2 := TTabSheet.Create(FMainForm);
  FMainForm.TabSheet2.PageControl := FMainForm.PageControl1;
  FMainForm.PageControl1.ActivePage := FMainForm.TabSheet1;
end;

procedure TTestAHW52CalendarMenuController.
  TestMenuOpensOwnedCalendarInModalLifecycle;
var
  recordingForm: TRecordingMainForm;
begin
  recordingForm := TRecordingMainForm(FMainForm);
  FMainForm.FrzRevolutionskalender1Click(nil);

  AssertEquals('The handler preserves save/create/show/release order.',
    'activate,save,create,assign-reference,show,release,clear-reference',
    recordingForm.Calls.CommaText);
  AssertTrue('Tab 2 is active before the save transition.',
    recordingForm.TabWasActiveAtSave);
  AssertTrue('The global Form7 reference is valid while showing.',
    recordingForm.GlobalReferenceWasSet);
  AssertTrue('The calendar form is owned by the main form.',
    recordingForm.OwnerWasMainForm);
  AssertFalse('The dialog is released after the modal call.',
    Assigned(recordingForm.Dialog));
  AssertFalse('The global form reference is cleared after release.',
    Assigned(FrenchRepublicanCalendarForm.Form7));
end;

procedure TTestAHW52CalendarMenuController.
  TestModalFailureStillReleasesAndClearsGlobalReference;
var
  recordingForm: TRecordingMainForm;
  failureRaised: Boolean;
begin
  recordingForm := TRecordingMainForm(FMainForm);
  recordingForm.FailDuringShow := True;
  failureRaised := False;
  try
    FMainForm.FrzRevolutionskalender1Click(nil);
  except
    on EInjectedCalendarDialogFailure do
      failureRaised := True;
  end;

  AssertTrue('The injected modal failure is propagated.', failureRaised);
  AssertEquals('Cleanup still follows the failed show call.',
    'activate,save,create,assign-reference,show,release,clear-reference',
    recordingForm.Calls.CommaText);
  AssertFalse('The dialog is released after the failure.',
    Assigned(recordingForm.Dialog));
  AssertFalse('The global form reference is cleared after failure.',
    Assigned(FrenchRepublicanCalendarForm.Form7));
end;

procedure TTestAHW52CalendarMenuController.
  TestGregorianMenuPreservesOwnedViewModelLifecycle;
var
  recordingForm: TRecordingMainForm;
begin
  recordingForm := TRecordingMainForm(FMainForm);
  FMainForm.GregorianischerKalender1Click(nil);

  AssertEquals('The handler preserves tab/save/form lifecycle order.',
    'activate,save,create-gregorian,configure-gregorian,show-gregorian,' +
    'free-gregorian', recordingForm.Calls.CommaText);
  AssertTrue('Tab 2 is active before the save transition.',
    recordingForm.TabWasActiveAtSave);
  AssertTrue('A ViewModel is configured before showing.',
    recordingForm.GregorianViewModelWasAssigned);
  AssertTrue('The calendar form is owned by the main form.',
    recordingForm.OwnerWasMainForm);
  AssertFalse('The Gregorian form is freed after the modal call.',
    Assigned(recordingForm.GregorianDialog));
end;

procedure TTestAHW52CalendarMenuController.
  TestGregorianModalFailureStillFreesForm;
var
  recordingForm: TRecordingMainForm;
  failureRaised: Boolean;
begin
  recordingForm := TRecordingMainForm(FMainForm);
  recordingForm.FailDuringGregorianShow := True;
  failureRaised := False;
  try
    FMainForm.GregorianischerKalender1Click(nil);
  except
    on EInjectedCalendarDialogFailure do
      failureRaised := True;
  end;

  AssertTrue('The injected modal failure is propagated.', failureRaised);
  AssertEquals('The form is still freed after a failed modal call.',
    'activate,save,create-gregorian,configure-gregorian,show-gregorian,' +
    'free-gregorian', recordingForm.Calls.CommaText);
  AssertFalse('The Gregorian form is freed after the failure.',
    Assigned(recordingForm.GregorianDialog));
end;

procedure TTestAHW52CalendarMenuController.
  TestSaveFailurePropagatesBeforeCreatingCalendar;
var
  recordingForm: TRecordingMainForm;
  failureRaised: Boolean;
begin
  recordingForm := TRecordingMainForm(FMainForm);
  recordingForm.FailDuringSave := True;
  failureRaised := False;
  try
    FMainForm.GregorianischerKalender1Click(nil);
  except
    on EInjectedCalendarDialogFailure do
      failureRaised := True;
  end;

  AssertTrue('The save failure is propagated.', failureRaised);
  AssertEquals('No calendar is created after save fails.',
    'activate,save', recordingForm.Calls.CommaText);
  AssertFalse('No Gregorian form was created.',
    Assigned(recordingForm.GregorianDialog));
end;

procedure TTestAHW52CalendarMenuController.
  TestMenuForwardsSenderToSaveAction;
var
  recordingForm: TRecordingMainForm;
  sender: TObject;
begin
  recordingForm := TRecordingMainForm(FMainForm);
  sender := TObject.Create;
  try
    recordingForm.ExpectedSender := sender;
    FMainForm.GregorianischerKalender1Click(sender);
    AssertTrue('The save action receives the original menu sender.',
      recordingForm.SenderWasPreserved);
  finally
    sender.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52CalendarMenuController);

end.
