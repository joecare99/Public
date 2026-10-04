unit AHW52UIExperiment;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  SysUtils, AHW52UIProfile;

const
  UIExperimentDialogWaitTimeoutMs = 30000;

type
  TUIExperimentCategory = (
    uecKnownHit,
    uecSurnameOnlyPrefix,
    uecAbsentSurname,
    uecAbsentGivenName
  );

  TUIVisibleObservation = record
    PersonSearchDialogVisible: Boolean;
    VisibleTopLevelWindowCount: LongInt;
    TargetProcessIsForeground: Boolean;
    ForegroundWindowHandle: QWord;
    ForegroundWindowClass: UTF8String;
    ForegroundWindowCaption: UTF8String;
    GridSelectionRead: Boolean;
    LookupOutcomeInferred: Boolean;
  end;

  TUIActionStatus = record
    Phase: UTF8String;
    TimedOut: Boolean;
    TimeoutStage: UTF8String;
    TimeoutLimitMilliseconds: QWord;
  end;

  TUIExperimentManifest = record
    ManifestId: UTF8String;
    SnapshotReference: UTF8String;
    ProfileReference: UTF8String;
    ProfileSha256: UTF8String;
    ProcessId: LongWord;
    ExecutablePath: UTF8String;
    ExecutableSha256: UTF8String;
    Category: TUIExperimentCategory;
    Surname: UTF8String;
    GivenName: UTF8String;
    LiveExecutionAuthorized: Boolean;
    ManualSnapshotVerificationRequired: Boolean;
  end;

  EUIExperimentError = class(Exception);

function ParseUIExperimentCategory(
  const Value: UTF8String): TUIExperimentCategory;
function UIExperimentCategoryName(
  Category: TUIExperimentCategory): UTF8String;
function CaptureVisibleObservation(
  const Profile: TWindowProfile): TUIVisibleObservation;
function CaptureUIActionStatus(const Phase: UTF8String): TUIActionStatus;
function UIVisibleObservationToJSON(
  const Observation: TUIVisibleObservation): UTF8String;
function UIActionStatusToJSON(
  const ActionStatus: TUIActionStatus): UTF8String;
function CreateUIExperimentManifest(const ManifestId, SnapshotReference,
  ProfileReference, ProfileSha256: UTF8String;
  const Profile: TWindowProfile; Category: TUIExperimentCategory;
  const Surname, GivenName: UTF8String): TUIExperimentManifest;
procedure ValidateUIExperimentManifest(
  const Manifest: TUIExperimentManifest);
function UIExperimentManifestToJSON(
  const Manifest: TUIExperimentManifest): UTF8String;
function UIExperimentManifestFromJSON(
  const JSON: UTF8String): TUIExperimentManifest;

implementation

uses
  fpjson, jsonparser;

const
  MaximumExperimentText = 4096;

function ParseUIExperimentCategory(
  const Value: UTF8String): TUIExperimentCategory;
begin
  if Value = 'known-hit' then
    Exit(uecKnownHit);
  if Value = 'surname-only-prefix' then
    Exit(uecSurnameOnlyPrefix);
  if Value = 'absent-surname' then
    Exit(uecAbsentSurname);
  if Value = 'absent-given-name' then
    Exit(uecAbsentGivenName);
  raise EUIExperimentError.CreateFmt('Unsupported experiment category "%s".',
    [Value]);
end;

function UIExperimentCategoryName(
  Category: TUIExperimentCategory): UTF8String;
begin
  case Category of
    uecKnownHit:
      Result := 'known-hit';
    uecSurnameOnlyPrefix:
      Result := 'surname-only-prefix';
    uecAbsentSurname:
      Result := 'absent-surname';
    uecAbsentGivenName:
      Result := 'absent-given-name';
  else
    raise EUIExperimentError.Create('The experiment category is invalid.');
  end;
end;

function CaptureVisibleObservation(
  const Profile: TWindowProfile): TUIVisibleObservation;
var
  Index: LongInt;
begin
  Result.PersonSearchDialogVisible := HasVisiblePersonSearchDialog(Profile);
  Result.VisibleTopLevelWindowCount := 0;
  Result.TargetProcessIsForeground := Profile.ForegroundWindowHandle <> 0;
  Result.ForegroundWindowHandle := Profile.ForegroundWindowHandle;
  Result.ForegroundWindowClass := '';
  Result.ForegroundWindowCaption := '';
  Result.GridSelectionRead := False;
  Result.LookupOutcomeInferred := False;
  for Index := 0 to High(Profile.Controls) do
  begin
    if (Profile.Controls[Index].Handle = Profile.ForegroundWindowHandle) and
       Profile.Controls[Index].IsTopLevel then
    begin
      Result.ForegroundWindowClass := Profile.Controls[Index].ClassName;
      if Profile.Controls[Index].Visible and
         not Profile.Controls[Index].IsPassword then
        Result.ForegroundWindowCaption := Profile.Controls[Index].Text;
    end;
    if Profile.Controls[Index].IsTopLevel and
       Profile.Controls[Index].Visible then
      Inc(Result.VisibleTopLevelWindowCount);
  end;
end;

function CaptureUIActionStatus(const Phase: UTF8String): TUIActionStatus;
begin
  Result.Phase := Phase;
  Result.TimedOut := Phase = 'timeout-waiting-for-dialog';
  Result.TimeoutStage := '';
  Result.TimeoutLimitMilliseconds := 0;
  if Result.TimedOut then
  begin
    Result.TimeoutStage := 'person-search-dialog';
    Result.TimeoutLimitMilliseconds := UIExperimentDialogWaitTimeoutMs;
  end;
end;

function UIVisibleObservationToJSON(
  const Observation: TUIVisibleObservation): UTF8String;
var
  Data: TJSONObject;
begin
  Data := TJSONObject.Create;
  try
    Data.Add('personSearchDialogVisible',
      TJSONBoolean.Create(Observation.PersonSearchDialogVisible));
    Data.Add('visibleTopLevelWindowCount',
      TJSONIntegerNumber.Create(Observation.VisibleTopLevelWindowCount));
    Data.Add('targetProcessIsForeground',
      TJSONBoolean.Create(Observation.TargetProcessIsForeground));
    Data.Add('foregroundWindowHandle',
      TJSONInt64Number.Create(Int64(Observation.ForegroundWindowHandle)));
    Data.Add('foregroundWindowClass', Observation.ForegroundWindowClass);
    Data.Add('foregroundWindowCaption', Observation.ForegroundWindowCaption);
    Data.Add('gridSelectionRead',
      TJSONBoolean.Create(Observation.GridSelectionRead));
    Data.Add('lookupOutcomeInferred',
      TJSONBoolean.Create(Observation.LookupOutcomeInferred));
    Result := Data.FormatJSON;
  finally
    Data.Free;
  end;
end;

function UIActionStatusToJSON(
  const ActionStatus: TUIActionStatus): UTF8String;
var
  Data: TJSONObject;
begin
  Data := TJSONObject.Create;
  try
    Data.Add('phase', ActionStatus.Phase);
    Data.Add('timedOut', TJSONBoolean.Create(ActionStatus.TimedOut));
    Data.Add('timeoutStage', ActionStatus.TimeoutStage);
    Data.Add('timeoutLimitMilliseconds',
      TJSONInt64Number.Create(Int64(ActionStatus.TimeoutLimitMilliseconds)));
    Result := Data.FormatJSON;
  finally
    Data.Free;
  end;
end;

procedure ValidateQueryText(const Value, FieldName: UTF8String);
var
  Index: LongInt;
begin
  if Length(Value) > MaximumExperimentText then
    raise EUIExperimentError.CreateFmt('%s exceeds the text safety limit.',
      [FieldName]);
  for Index := 1 to Length(Value) do
    if (Ord(Value[Index]) < 32) or (Ord(Value[Index]) = 127) then
      raise EUIExperimentError.CreateFmt('%s cannot contain control characters.',
        [FieldName]);
end;

procedure ValidateCategoryInputs(Category: TUIExperimentCategory;
  const Surname, GivenName: UTF8String);
begin
  case Category of
    uecKnownHit,
    uecAbsentSurname,
    uecAbsentGivenName:
      if (Trim(string(Surname)) = '') or (Trim(string(GivenName)) = '') then
        raise EUIExperimentError.Create(
          'This experiment category requires both surname and given name.');
    uecSurnameOnlyPrefix:
      if (Trim(string(Surname)) = '') or (Trim(string(GivenName)) <> '') then
        raise EUIExperimentError.Create(
          'A surname-only prefix requires a surname and an empty given name.');
  else
    raise EUIExperimentError.Create('The experiment category is invalid.');
  end;
end;

function IsSha256Hex(const Value: UTF8String): Boolean;
var
  Index: LongInt;
begin
  Result := Length(Value) = 64;
  if not Result then
    Exit;
  for Index := 1 to Length(Value) do
    if not (Value[Index] in ['0'..'9', 'A'..'F', 'a'..'f']) then
      Exit(False);
end;

function CreateUIExperimentManifest(const ManifestId, SnapshotReference,
  ProfileReference, ProfileSha256: UTF8String;
  const Profile: TWindowProfile; Category: TUIExperimentCategory;
  const Surname, GivenName: UTF8String): TUIExperimentManifest;
begin
  Result.ManifestId := ManifestId;
  Result.SnapshotReference := SnapshotReference;
  Result.ProfileReference := ProfileReference;
  Result.ProfileSha256 := ProfileSha256;
  Result.ProcessId := Profile.ProcessId;
  Result.ExecutablePath := Profile.ExecutablePath;
  Result.ExecutableSha256 := Profile.ExecutableSha256;
  Result.Category := Category;
  Result.Surname := Surname;
  Result.GivenName := GivenName;
  Result.LiveExecutionAuthorized := False;
  Result.ManualSnapshotVerificationRequired := True;
  ValidateUIExperimentManifest(Result);
  if not HasVisiblePersonSearchDialog(Profile) then
    raise EUIExperimentError.Create(
      'The referenced profile does not show the person-search dialog.');
end;

procedure ValidateUIExperimentManifest(
  const Manifest: TUIExperimentManifest);
begin
  if Trim(string(Manifest.ManifestId)) = '' then
    raise EUIExperimentError.Create('A manifest ID is required.');
  if Trim(string(Manifest.SnapshotReference)) = '' then
    raise EUIExperimentError.Create('A snapshot reference is required.');
  if Trim(string(Manifest.ProfileReference)) = '' then
    raise EUIExperimentError.Create('A profile reference is required.');
  if not IsSha256Hex(Manifest.ProfileSha256) then
    raise EUIExperimentError.Create('A valid profile SHA-256 is required.');
  if Manifest.ProcessId = 0 then
    raise EUIExperimentError.Create('A target process ID is required.');
  ValidateExecutableIdentity(Manifest.ExecutablePath,
    Manifest.ExecutableSha256);
  ValidateQueryText(Manifest.Surname, 'Surname');
  ValidateQueryText(Manifest.GivenName, 'Given name');
  ValidateCategoryInputs(Manifest.Category, Manifest.Surname,
    Manifest.GivenName);
  if Manifest.LiveExecutionAuthorized then
    raise EUIExperimentError.Create(
      'Prepared manifests cannot authorize live execution.');
  if not Manifest.ManualSnapshotVerificationRequired then
    raise EUIExperimentError.Create(
      'Manual snapshot verification must remain required.');
end;

function UIExperimentManifestToJSON(
  const Manifest: TUIExperimentManifest): UTF8String;
var
  Root: TJSONObject;
  Target: TJSONObject;
  Snapshot: TJSONObject;
  Query: TJSONObject;
  Outcomes: TJSONArray;
begin
  ValidateUIExperimentManifest(Manifest);
  Root := TJSONObject.Create;
  try
    Root.Add('schemaVersion', TJSONIntegerNumber.Create(1));
    Root.Add('resultSchemaVersion', TJSONIntegerNumber.Create(2));
    Root.Add('manifestId', Manifest.ManifestId);

    Snapshot := TJSONObject.Create;
    Snapshot.Add('reference', Manifest.SnapshotReference);
    Snapshot.Add('manualVerificationRequired',
      TJSONBoolean.Create(Manifest.ManualSnapshotVerificationRequired));
    Root.Add('snapshot', Snapshot);

    Target := TJSONObject.Create;
    Target.Add('processId', TJSONInt64Number.Create(Manifest.ProcessId));
    Target.Add('executablePath', Manifest.ExecutablePath);
    Target.Add('executableSha256', Manifest.ExecutableSha256);
    Target.Add('profileReference', Manifest.ProfileReference);
    Target.Add('profileSha256', Manifest.ProfileSha256);
    Root.Add('target', Target);

    Query := TJSONObject.Create;
    Query.Add('category', UIExperimentCategoryName(Manifest.Category));
    Query.Add('surname', Manifest.Surname);
    Query.Add('givenName', Manifest.GivenName);
    Root.Add('query', Query);

    Outcomes := TJSONArray.Create;
    Outcomes.Add('not-found');
    Outcomes.Add('single-candidate');
    Outcomes.Add('candidate-list');
    Root.Add('allowedLookupOutcomes', Outcomes);
    Root.Add('liveExecutionAuthorized',
      TJSONBoolean.Create(Manifest.LiveExecutionAuthorized));
    Result := Root.FormatJSON;
  finally
    Root.Free;
  end;
end;

function RequiredObject(const Parent: TJSONObject;
  const Name: string): TJSONObject;
var
  Value: TJSONData;
begin
  if not Parent.Find(Name, Value) or not (Value is TJSONObject) then
    raise EUIExperimentError.CreateFmt(
      'Manifest property "%s" must be an object.', [Name]);
  Result := TJSONObject(Value);
end;

function RequiredValue(const Parent: TJSONObject;
  const Name: string): TJSONData;
begin
  if not Parent.Find(Name, Result) then
    raise EUIExperimentError.CreateFmt(
      'Manifest property "%s" is required.', [Name]);
end;

function TryReadJSONInteger(const Value: TJSONData; Minimum,
  Maximum: Int64; out Number: Int64): Boolean;
var
  NumericValue: Extended;
begin
  Result := False;
  if Value.JSONType <> jtNumber then
    Exit;
  NumericValue := Value.AsFloat;
  if (NumericValue < Minimum) or (NumericValue > Maximum) or
     (Frac(NumericValue) <> 0) then
    Exit;
  Number := Trunc(NumericValue);
  Result := True;
end;

function RequiredString(const Parent: TJSONObject;
  const Name: string): UTF8String;
var
  Value: TJSONData;
begin
  Value := RequiredValue(Parent, Name);
  if Value.JSONType <> jtString then
    raise EUIExperimentError.CreateFmt(
      'Manifest property "%s" must be a string.', [Name]);
  Result := UTF8String(Value.AsString);
end;

procedure ValidateAllowedLookupOutcomes(const Root: TJSONObject;
  ResultSchemaVersion: LongInt);
const
  ExpectedOutcomes: array[0..2] of UTF8String = (
    'not-found', 'single-candidate', 'candidate-list');
var
  Value: TJSONData;
  Outcomes: TJSONArray;
  Index: LongInt;
begin
  if not Root.Find('allowedLookupOutcomes', Value) then
  begin
    if ResultSchemaVersion >= 2 then
      raise EUIExperimentError.Create(
        'Manifest lookup outcome list is required.');
    Exit;
  end;
  if not (Value is TJSONArray) then
    raise EUIExperimentError.Create(
      'Manifest lookup outcomes must be an array.');
  Outcomes := TJSONArray(Value);
  if Outcomes.Count <> Length(ExpectedOutcomes) then
    raise EUIExperimentError.Create(
      'Manifest lookup outcome list does not match the supported contract.');
  for Index := 0 to High(ExpectedOutcomes) do
  begin
    if Outcomes.Items[Index].JSONType <> jtString then
      raise EUIExperimentError.Create(
        'Manifest lookup outcome list does not match the supported contract.');
    if UTF8String(Outcomes.Items[Index].AsString) <> ExpectedOutcomes[Index] then
      raise EUIExperimentError.Create(
        'Manifest lookup outcome list does not match the supported contract.');
  end;
end;

function UIExperimentManifestFromJSON(
  const JSON: UTF8String): TUIExperimentManifest;
var
  RootData: TJSONData;
  Root, Snapshot, Target, Query: TJSONObject;
  Value: TJSONData;
  IntegerValue, ResultSchemaVersion: Int64;
begin
  RootData := GetJSON(JSON);
  try
    if not (RootData is TJSONObject) then
      raise EUIExperimentError.Create('Manifest root must be an object.');
    Root := TJSONObject(RootData);
    Value := RequiredValue(Root, 'schemaVersion');
    if not TryReadJSONInteger(Value, 1, 1, IntegerValue) then
      raise EUIExperimentError.Create('Unsupported experiment manifest schema.');
    Value := RequiredValue(Root, 'resultSchemaVersion');
    if not TryReadJSONInteger(Value, 1, 2, ResultSchemaVersion) then
      raise EUIExperimentError.Create('Unsupported experiment result schema.');
    ValidateAllowedLookupOutcomes(Root, ResultSchemaVersion);

    Result.ManifestId := RequiredString(Root, 'manifestId');
    Snapshot := RequiredObject(Root, 'snapshot');
    Result.SnapshotReference := RequiredString(Snapshot, 'reference');
    Value := RequiredValue(Snapshot, 'manualVerificationRequired');
    if Value.JSONType <> jtBoolean then
      raise EUIExperimentError.Create(
        'Snapshot verification status must be a boolean.');
    Result.ManualSnapshotVerificationRequired := Value.AsBoolean;

    Target := RequiredObject(Root, 'target');
    Value := RequiredValue(Target, 'processId');
    if not TryReadJSONInteger(Value, 1, High(LongWord), IntegerValue) then
      raise EUIExperimentError.Create(
        'Target process ID must be a positive 32-bit integer.');
    Result.ProcessId := IntegerValue;
    Result.ExecutablePath := RequiredString(Target, 'executablePath');
    Result.ExecutableSha256 := RequiredString(Target, 'executableSha256');
    Result.ProfileReference := RequiredString(Target, 'profileReference');
    Result.ProfileSha256 := RequiredString(Target, 'profileSha256');

    Query := RequiredObject(Root, 'query');
    Result.Category := ParseUIExperimentCategory(
      RequiredString(Query, 'category'));
    Result.Surname := RequiredString(Query, 'surname');
    Result.GivenName := RequiredString(Query, 'givenName');
    Value := RequiredValue(Root, 'liveExecutionAuthorized');
    if Value.JSONType <> jtBoolean then
      raise EUIExperimentError.Create(
        'Live execution authorization must be a boolean.');
    Result.LiveExecutionAuthorized := Value.AsBoolean;
    ValidateUIExperimentManifest(Result);
  finally
    RootData.Free;
  end;
end;

end.
