unit tst_AHW52UIExperimentTests;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  AHW52UIExperiment, AHW52UIProfile, fpcunit, testregistry;

type
  TTestAHW52UIExperiment = class(TTestCase)
  private
    function CreateValidProfile: TWindowProfile;
    function CreateValidManifest: TUIExperimentManifest;
  published
    procedure TestPreparedManifestCannotAuthorizeExecution;
    procedure TestManifestRoundTripPreservesApprovedLookupCategory;
    procedure TestReadsManifestWithVersionOneResultSchema;
    procedure TestRejectsIncompleteCategoryInputs;
    procedure TestRejectsExecutionEnabledManifest;
    procedure TestRejectsUnverifiedSnapshot;
    procedure TestRejectsUnexpectedExecutableIdentity;
    procedure TestCapturesVisibleWindowsWithoutInferringSearchResult;
    procedure TestCapturesTargetForegroundWindowWithoutReadingGrid;
    procedure TestCapturesDialogWaitTimeoutSeparatelyFromLookupOutcome;
  end;

implementation

uses
  SysUtils;

const
  TestExecutablePath = 'C:\ProgramData\AHNENWIN Test\AHNWIN51.exe';
  TestExecutableHash =
    '817C1B1BB23469CD628C52E4A5EA26CB4DB26275B5EC84952717B218605F0AFF';

function TTestAHW52UIExperiment.CreateValidProfile: TWindowProfile;
begin
  Result.ProcessId := 4711;
  Result.ExecutablePath := TestExecutablePath;
  Result.ExecutableSha256 := TestExecutableHash;
  Result.ForegroundWindowHandle := 0;
  SetLength(Result.Controls, 1);
  Result.Controls[0].Handle := 200;
  Result.Controls[0].ProcessId := 4711;
  Result.Controls[0].ClassName := 'TForm3';
  Result.Controls[0].Text := 'Auswahl';
  Result.Controls[0].Visible := True;
  Result.Controls[0].Enabled := True;
  Result.Controls[0].IsTopLevel := True;
end;

function TTestAHW52UIExperiment.CreateValidManifest:
  TUIExperimentManifest;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  Result := CreateUIExperimentManifest(
    'test-manifest-1', 'snapshot-2026-10-03',
    'C:\Users\Mir\.copilot\session-state\profile.json',
    StringOfChar('A', 64), Profile, uecKnownHit, 'Schmidt', 'Anna');
end;

procedure TTestAHW52UIExperiment.
  TestPreparedManifestCannotAuthorizeExecution;
var
  Manifest: TUIExperimentManifest;
  JSON: UTF8String;
begin
  Manifest := CreateValidManifest;
  JSON := UIExperimentManifestToJSON(Manifest);
  CheckFalse(Manifest.LiveExecutionAuthorized);
  CheckTrue(Manifest.ManualSnapshotVerificationRequired);
  CheckTrue(Pos('"liveExecutionAuthorized"', JSON) > 0);
  CheckTrue(Pos('"manualVerificationRequired"', JSON) > 0);
  CheckFalse(Pos('"liveExecutionAuthorized":true', JSON) > 0);
end;

procedure TTestAHW52UIExperiment.
  TestManifestRoundTripPreservesApprovedLookupCategory;
var
  Original, Parsed: TUIExperimentManifest;
begin
  Original := CreateValidManifest;
  Parsed := UIExperimentManifestFromJSON(
    UIExperimentManifestToJSON(Original));
  AssertEquals(Original.ManifestId, Parsed.ManifestId);
  AssertEquals(Original.SnapshotReference, Parsed.SnapshotReference);
  AssertEquals(Original.ProcessId, Parsed.ProcessId);
  AssertEquals('known-hit', UIExperimentCategoryName(Parsed.Category));
  AssertEquals(Original.Surname, Parsed.Surname);
  AssertEquals(Original.GivenName, Parsed.GivenName);
  CheckFalse(Parsed.LiveExecutionAuthorized);
  CheckTrue(Parsed.ManualSnapshotVerificationRequired);
end;

procedure TTestAHW52UIExperiment.
  TestReadsManifestWithVersionOneResultSchema;
var
  Manifest: TUIExperimentManifest;
  JSON: UTF8String;
  Parsed: TUIExperimentManifest;
begin
  Manifest := CreateValidManifest;
  JSON := StringReplace(UIExperimentManifestToJSON(Manifest),
    '"resultSchemaVersion": 2', '"resultSchemaVersion": 1', []);

  Parsed := UIExperimentManifestFromJSON(JSON);

  AssertEquals(Manifest.ManifestId, Parsed.ManifestId);
  AssertEquals('known-hit', UIExperimentCategoryName(Parsed.Category));
end;

procedure TTestAHW52UIExperiment.TestRejectsIncompleteCategoryInputs;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  try
    CreateUIExperimentManifest('id', 'snapshot', 'profile',
      StringOfChar('A', 64), Profile, uecKnownHit, 'Schmidt', '');
    Fail('A known-hit test must provide both key values.');
  except
    on E: EUIExperimentError do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52UIExperiment.TestRejectsExecutionEnabledManifest;
var
  Manifest: TUIExperimentManifest;
begin
  Manifest := CreateValidManifest;
  Manifest.LiveExecutionAuthorized := True;
  try
    ValidateUIExperimentManifest(Manifest);
    Fail('Prepared manifests must never authorize input.');
  except
    on E: EUIExperimentError do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52UIExperiment.TestRejectsUnverifiedSnapshot;
var
  Manifest: TUIExperimentManifest;
begin
  Manifest := CreateValidManifest;
  Manifest.ManualSnapshotVerificationRequired := False;
  try
    ValidateUIExperimentManifest(Manifest);
    Fail('Manual backup verification must remain a precondition.');
  except
    on E: EUIExperimentError do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52UIExperiment.TestRejectsUnexpectedExecutableIdentity;
var
  Manifest: TUIExperimentManifest;
begin
  Manifest := CreateValidManifest;
  Manifest.ExecutableSha256 := StringOfChar('0', 64);
  try
    ValidateUIExperimentManifest(Manifest);
    Fail('The manifest must stay pinned to the approved executable.');
  except
    on E: EUIProfileError do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52UIExperiment.
  TestCapturesVisibleWindowsWithoutInferringSearchResult;
var
  Profile: TWindowProfile;
  Observation: TUIVisibleObservation;
  JSON: UTF8String;
begin
  Profile := CreateValidProfile;
  SetLength(Profile.Controls, 2);
  Profile.Controls[1].Handle := 201;
  Profile.Controls[1].ProcessId := 4711;
  Profile.Controls[1].ClassName := 'TForm';
  Profile.Controls[1].Text := 'Other visible window';
  Profile.Controls[1].Visible := True;
  Profile.Controls[1].Enabled := True;
  Profile.Controls[1].IsTopLevel := True;

  Observation := CaptureVisibleObservation(Profile);

  CheckTrue(Observation.PersonSearchDialogVisible);
  AssertEquals(2, Observation.VisibleTopLevelWindowCount);
  CheckFalse(Observation.GridSelectionRead);
  CheckFalse(Observation.LookupOutcomeInferred);
  JSON := UIVisibleObservationToJSON(Observation);
  CheckTrue(Pos('"foregroundWindowCaption"', JSON) > 0);
  CheckTrue(Pos('"gridSelectionRead"', JSON) > 0);
  CheckFalse(Pos('"gridRows"', JSON) > 0);
end;

procedure TTestAHW52UIExperiment.
  TestCapturesTargetForegroundWindowWithoutReadingGrid;
var
  Profile: TWindowProfile;
  Observation: TUIVisibleObservation;
begin
  Profile := CreateValidProfile;
  Profile.ForegroundWindowHandle := Profile.Controls[0].Handle;

  Observation := CaptureVisibleObservation(Profile);

  CheckTrue(Observation.TargetProcessIsForeground);
  AssertEquals(QWord(200), Observation.ForegroundWindowHandle);
  AssertEquals('TForm3', Observation.ForegroundWindowClass);
  AssertEquals('Auswahl', Observation.ForegroundWindowCaption);
  CheckFalse(Observation.GridSelectionRead);
  CheckFalse(Observation.LookupOutcomeInferred);

  Profile.ForegroundWindowHandle := 0;
  Observation := CaptureVisibleObservation(Profile);
  CheckFalse(Observation.TargetProcessIsForeground);
  AssertEquals(QWord(0), Observation.ForegroundWindowHandle);
  AssertEquals('', Observation.ForegroundWindowClass);
  AssertEquals('', Observation.ForegroundWindowCaption);
end;

procedure TTestAHW52UIExperiment.
  TestCapturesDialogWaitTimeoutSeparatelyFromLookupOutcome;
var
  ActionStatus: TUIActionStatus;
  JSON: UTF8String;
begin
  ActionStatus := CaptureUIActionStatus('timeout-waiting-for-dialog');

  CheckTrue(ActionStatus.TimedOut);
  AssertEquals('timeout-waiting-for-dialog', ActionStatus.Phase);
  AssertEquals('person-search-dialog', ActionStatus.TimeoutStage);
  AssertEquals(QWord(30000), ActionStatus.TimeoutLimitMilliseconds);
  JSON := UIActionStatusToJSON(ActionStatus);
  CheckTrue(Pos('"timedOut"', JSON) > 0);
  CheckTrue(Pos('"timeoutStage"', JSON) > 0);
  CheckTrue(Pos('"timeoutLimitMilliseconds"', JSON) > 0);

  ActionStatus := CaptureUIActionStatus(
    'search-triggered-by-edit2-exit-dialog-closed');
  CheckFalse(ActionStatus.TimedOut);
  AssertEquals('', ActionStatus.TimeoutStage);
  AssertEquals(QWord(0), ActionStatus.TimeoutLimitMilliseconds);
end;

initialization
  RegisterTest(TTestAHW52UIExperiment);

end.
