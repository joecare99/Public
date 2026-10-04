unit tst_AHW52_FrenchRepublicanCalendarMenuTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms, frmAhnenWinMain,
  FrenchRepublicanCalendarForm;

type
  TTestAHW52FrenchRepublicanCalendarMenu = class(TTestCase)
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
    FFailDuringShow: Boolean;
    FGlobalReferenceWasSet: Boolean;
    FOwnerWasMainForm: Boolean;
    FTabWasActiveAtSave: Boolean;
  protected
    procedure SaveBeforeFrenchRepublicanCalendar(Sender: TObject); override;
    function CreateFrenchRepublicanCalendarForm:
      TFrenchRepublicanCalendarForm; override;
    procedure ShowFrenchRepublicanCalendarForm(
      CalendarForm: TFrenchRepublicanCalendarForm); override;
    procedure ReleaseFrenchRepublicanCalendarForm(
      CalendarForm: TFrenchRepublicanCalendarForm); override;
  public
    destructor Destroy; override;
    procedure InitializeRecorder;
    property Calls: TStringList read FCalls;
    property Dialog: TFrenchRepublicanCalendarForm read FDialog;
    property FailDuringShow: Boolean
      read FFailDuringShow write FFailDuringShow;
    property GlobalReferenceWasSet: Boolean read FGlobalReferenceWasSet;
    property OwnerWasMainForm: Boolean read FOwnerWasMainForm;
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

procedure TRecordingMainForm.SaveBeforeFrenchRepublicanCalendar(
  Sender: TObject);
begin
  FCalls.Add('save');
  FTabWasActiveAtSave := PageControl1.ActivePage = TabSheet2;
end;

function TRecordingMainForm.CreateFrenchRepublicanCalendarForm:
  TFrenchRepublicanCalendarForm;
begin
  FCalls.Add('create');
  FDialog := TFrenchRepublicanCalendarForm.CreateNew(Self);
  Result := FDialog;
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

procedure TTestAHW52FrenchRepublicanCalendarMenu.SetUp;
begin
  inherited SetUp;
  Application.Initialize;
  FPreviousForm7 := FrenchRepublicanCalendarForm.Form7;
  FrenchRepublicanCalendarForm.Form7 := nil;
  FMainForm := TRecordingMainForm.CreateNew(nil);
  TRecordingMainForm(FMainForm).InitializeRecorder;
  PrepareMainForm;
end;

procedure TTestAHW52FrenchRepublicanCalendarMenu.TearDown;
begin
  FMainForm.Free;
  FrenchRepublicanCalendarForm.Form7 := TFrenchRepublicanCalendarForm(
    FPreviousForm7);
  inherited TearDown;
end;

procedure TTestAHW52FrenchRepublicanCalendarMenu.PrepareMainForm;
begin
  FMainForm.PageControl1 := TPageControl.Create(FMainForm);
  FMainForm.PageControl1.Parent := FMainForm;

  FMainForm.TabSheet1 := TTabSheet.Create(FMainForm);
  FMainForm.TabSheet1.PageControl := FMainForm.PageControl1;
  FMainForm.TabSheet2 := TTabSheet.Create(FMainForm);
  FMainForm.TabSheet2.PageControl := FMainForm.PageControl1;
  FMainForm.PageControl1.ActivePage := FMainForm.TabSheet1;
end;

procedure TTestAHW52FrenchRepublicanCalendarMenu.
  TestMenuOpensOwnedCalendarInModalLifecycle;
var
  recordingForm: TRecordingMainForm;
begin
  recordingForm := TRecordingMainForm(FMainForm);
  FMainForm.FrzRevolutionskalender1Click(nil);

  AssertEquals('The handler preserves save/create/show/release order.',
    'save,create,show,release', recordingForm.Calls.CommaText);
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

procedure TTestAHW52FrenchRepublicanCalendarMenu.
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
    'save,create,show,release', recordingForm.Calls.CommaText);
  AssertFalse('The dialog is released after the failure.',
    Assigned(recordingForm.Dialog));
  AssertFalse('The global form reference is cleared after failure.',
    Assigned(FrenchRepublicanCalendarForm.Form7));
end;

initialization
  RegisterTest(TTestAHW52FrenchRepublicanCalendarMenu);

end.
