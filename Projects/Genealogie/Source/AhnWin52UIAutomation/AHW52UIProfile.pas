unit AHW52UIProfile;

{$mode objfpc}{$H+}

interface

uses
  Classes, fpjson, jsonparser, SysUtils;

type
  TUIControlInfo = record
    Handle: QWord;
    ParentHandle: QWord;
    OwnerHandle: QWord;
    ProcessId: LongWord;
    ClassName: UTF8String;
    Text: UTF8String;
    Left: LongInt;
    Top: LongInt;
    Width: LongInt;
    Height: LongInt;
    ControlId: LongInt;
    Visible: Boolean;
    Enabled: Boolean;
    IsPassword: Boolean;
    IsTopLevel: Boolean;
    Ordinal: LongInt;
  end;

  TUIControlInfoArray = array of TUIControlInfo;

  TWindowProfile = record
    ProcessId: LongWord;
    ExecutablePath: UTF8String;
    ExecutableSha256: UTF8String;
    Controls: TUIControlInfoArray;
  end;

  TPersonSearchTargets = record
    DialogHandle: QWord;
    NameEditHandle: QWord;
    GivenNameEditHandle: QWord;
    SearchButtonHandle: QWord;
  end;

  EUIProfileError = class(Exception);

function SameWindowsPath(const LeftPath, RightPath: UTF8String): Boolean;
procedure ValidateExecutableIdentity(
  const ActualPath, ActualSha256: UTF8String);
procedure ValidatePersonSearchProfile(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  out Targets: TPersonSearchTargets);
function ProfileToJSON(const Profile: TWindowProfile): UTF8String;
function ProfileFromJSON(const JSON: UTF8String): TWindowProfile;

implementation

const
  ExpectedExecutablePath = 'C:\ProgramData\AHNENWIN Test\AHNWIN51.exe';
  ExpectedExecutableSha256 =
    '817C1B1BB23469CD628C52E4A5EA26CB4DB26275B5EC84952717B218605F0AFF';
  MainWindowCaption = 'AHNENWIN 5.1';
  MainWindowClass = 'TForm1';
  PersonSearchCaption = 'Auswahl';
  SearchButtonCaption = 'suchen';
  EditWindowClass = 'TEdit';
  SearchButtonWindowClass = 'TButton';

function NormalizeWindowsPath(const Path: UTF8String): UTF8String;
begin
  Result := UTF8String(LowerCase(StringReplace(ExpandFileName(string(Path)),
    '/', '\', [rfReplaceAll])));
  Result := ExcludeTrailingPathDelimiter(Result);
end;

function SameWindowsPath(const LeftPath, RightPath: UTF8String): Boolean;
begin
  Result := NormalizeWindowsPath(LeftPath) = NormalizeWindowsPath(RightPath);
end;

procedure ValidateExecutableIdentity(
  const ActualPath, ActualSha256: UTF8String);
begin
  if not SameWindowsPath(ActualPath, ExpectedExecutablePath) then
    raise EUIProfileError.Create('Executable path is not the approved test executable.');

  if not SameText(ActualSha256, ExpectedExecutableSha256) then
    raise EUIProfileError.Create('Executable SHA-256 does not match the approved profile.');
end;

function FindSingleDialog(const Profile: TWindowProfile): LongInt;
var
  I: LongInt;
  Matches: LongInt;
begin
  Result := -1;
  Matches := 0;

  for I := 0 to High(Profile.Controls) do
    if Profile.Controls[I].IsTopLevel and
       Profile.Controls[I].Visible and
       SameText(Trim(Profile.Controls[I].Text), PersonSearchCaption) then
    begin
      Result := I;
      Inc(Matches);
    end;

  if Matches = 0 then
    raise EUIProfileError.Create('The visible person-search dialog was not found.');
  if Matches <> 1 then
    raise EUIProfileError.Create('The person-search dialog selector is ambiguous.');
end;

function FindSingleMainWindow(const Profile: TWindowProfile): LongInt;
var
  I: LongInt;
  Matches: LongInt;
begin
  Result := -1;
  Matches := 0;
  for I := 0 to High(Profile.Controls) do
    if Profile.Controls[I].IsTopLevel and
       Profile.Controls[I].Visible and
       SameText(Profile.Controls[I].ClassName, MainWindowClass) and
       SameText(Trim(Profile.Controls[I].Text), MainWindowCaption) then
    begin
      Result := I;
      Inc(Matches);
    end;

  if Matches = 0 then
    raise EUIProfileError.Create('The visible AHNENWIN main window was not found.');
  if Matches <> 1 then
    raise EUIProfileError.Create('The AHNENWIN main-window selector is ambiguous.');
end;

function IsDirectVisibleEdit(
  const Control: TUIControlInfo; DialogHandle: QWord): Boolean;
begin
  Result := (Control.ParentHandle = DialogHandle) and
    Control.Visible and not Control.IsPassword and
    SameText(Control.ClassName, EditWindowClass);
end;

function IsSearchButton(
  const Control: TUIControlInfo; DialogHandle: QWord): Boolean;
begin
  Result := (Control.ParentHandle = DialogHandle) and
    Control.Visible and SameText(Control.ClassName, SearchButtonWindowClass) and
    SameText(Trim(Control.Text), SearchButtonCaption);
end;

function ComesBefore(const LeftControl, RightControl: TUIControlInfo): Boolean;
begin
  if LeftControl.Top <> RightControl.Top then
    Exit(LeftControl.Top < RightControl.Top);
  if LeftControl.Left <> RightControl.Left then
    Exit(LeftControl.Left < RightControl.Left);
  Result := LeftControl.Ordinal < RightControl.Ordinal;
end;

function SameControlStructure(
  const CurrentControl, ExpectedControl: TUIControlInfo;
  AllowTextChange: Boolean): Boolean;
begin
  Result :=
    (CurrentControl.Handle = ExpectedControl.Handle) and
    (CurrentControl.ParentHandle = ExpectedControl.ParentHandle) and
    SameText(CurrentControl.ClassName, ExpectedControl.ClassName) and
    (CurrentControl.Left = ExpectedControl.Left) and
    (CurrentControl.Top = ExpectedControl.Top) and
    (CurrentControl.Width = ExpectedControl.Width) and
    (CurrentControl.Height = ExpectedControl.Height) and
    (CurrentControl.ControlId = ExpectedControl.ControlId) and
    (CurrentControl.Ordinal = ExpectedControl.Ordinal) and
    (CurrentControl.OwnerHandle = ExpectedControl.OwnerHandle) and
    (CurrentControl.ProcessId = ExpectedControl.ProcessId) and
    (CurrentControl.IsTopLevel = ExpectedControl.IsTopLevel) and
    (CurrentControl.IsPassword = ExpectedControl.IsPassword) and
    (CurrentControl.Visible = ExpectedControl.Visible) and
    (CurrentControl.Enabled = ExpectedControl.Enabled);
  if not AllowTextChange then
    Result := Result and (CurrentControl.Text = ExpectedControl.Text);
end;

function FindByHandle(const Profile: TWindowProfile; Handle: QWord): LongInt;
var
  I: LongInt;
begin
  for I := 0 to High(Profile.Controls) do
    if Profile.Controls[I].Handle = Handle then
      Exit(I);
  Result := -1;
end;

procedure ValidatePersonSearchProfile(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  out Targets: TPersonSearchTargets);
var
  CurrentDialogIndex: LongInt;
  ExpectedDialogIndex: LongInt;
  CurrentMainIndex: LongInt;
  ExpectedMainIndex: LongInt;
  CurrentOwnerIndex: LongInt;
  ExpectedOwnerIndex: LongInt;
  CurrentNameIndex: LongInt;
  CurrentGivenIndex: LongInt;
  ExpectedNameIndex: LongInt;
  ExpectedGivenIndex: LongInt;
  CurrentButtonIndex: LongInt;
  ExpectedButtonIndex: LongInt;
  EditCount: LongInt;
  ButtonCount: LongInt;
  CurrentChildCount: LongInt;
  ExpectedChildCount: LongInt;
  CurrentTopLevelCount: LongInt;
  ExpectedTopLevelCount: LongInt;
  MatchingExpectedIndex: LongInt;
  AllowTextChange: Boolean;
  I: LongInt;
  CandidateIndex: LongInt;
begin
  ValidateExecutableIdentity(CurrentProfile.ExecutablePath, CurrentProfile.ExecutableSha256);
  ValidateExecutableIdentity(ExpectedProfile.ExecutablePath, ExpectedProfile.ExecutableSha256);

  if (CurrentProfile.ProcessId = 0) or
     (CurrentProfile.ProcessId <> ExpectedProfile.ProcessId) then
    raise EUIProfileError.Create('The process ID differs from the approved UI profile.');

  CurrentDialogIndex := FindSingleDialog(CurrentProfile);
  ExpectedDialogIndex := FindSingleDialog(ExpectedProfile);
  CurrentMainIndex := FindSingleMainWindow(CurrentProfile);
  ExpectedMainIndex := FindSingleMainWindow(ExpectedProfile);
  CurrentOwnerIndex := FindByHandle(CurrentProfile,
    CurrentProfile.Controls[CurrentDialogIndex].OwnerHandle);
  ExpectedOwnerIndex := FindByHandle(ExpectedProfile,
    ExpectedProfile.Controls[ExpectedDialogIndex].OwnerHandle);

  if CurrentProfile.Controls[CurrentDialogIndex].Handle <>
     ExpectedProfile.Controls[ExpectedDialogIndex].Handle then
    raise EUIProfileError.Create('The dialog window differs from the approved UI profile.');
  if (CurrentOwnerIndex < 0) or
     not CurrentProfile.Controls[CurrentOwnerIndex].IsTopLevel or
     (CurrentProfile.Controls[CurrentOwnerIndex].ProcessId <>
       CurrentProfile.ProcessId) then
    raise EUIProfileError.Create('The person-search dialog owner is not a top-level window in the target process.');
  if (ExpectedOwnerIndex < 0) or
     not ExpectedProfile.Controls[ExpectedOwnerIndex].IsTopLevel or
     (ExpectedProfile.Controls[ExpectedOwnerIndex].ProcessId <>
       ExpectedProfile.ProcessId) then
    raise EUIProfileError.Create('The saved person-search dialog owner is invalid.');
  if not CurrentProfile.Controls[CurrentDialogIndex].Enabled then
    raise EUIProfileError.Create('The person-search dialog is disabled.');
  if CurrentProfile.Controls[CurrentDialogIndex].ProcessId <> CurrentProfile.ProcessId then
    raise EUIProfileError.Create('The person-search dialog belongs to another process.');
  if CurrentProfile.Controls[CurrentMainIndex].ProcessId <> CurrentProfile.ProcessId then
    raise EUIProfileError.Create('The main window belongs to another process.');

  CurrentNameIndex := -1;
  CurrentGivenIndex := -1;
  CurrentButtonIndex := -1;
  EditCount := 0;
  ButtonCount := 0;

  for I := 0 to High(CurrentProfile.Controls) do
  begin
    if IsDirectVisibleEdit(CurrentProfile.Controls[I],
      CurrentProfile.Controls[CurrentDialogIndex].Handle) then
    begin
      Inc(EditCount);
      if CurrentProfile.Controls[I].ProcessId <> CurrentProfile.ProcessId then
        raise EUIProfileError.Create('An edit control belongs to another process.');
      if not CurrentProfile.Controls[I].Enabled then
        raise EUIProfileError.Create('A person-search edit control is disabled.');

      CandidateIndex := I;
      if CurrentNameIndex < 0 then
        CurrentNameIndex := CandidateIndex
      else if ComesBefore(CurrentProfile.Controls[CandidateIndex],
        CurrentProfile.Controls[CurrentNameIndex]) then
      begin
        CurrentGivenIndex := CurrentNameIndex;
        CurrentNameIndex := CandidateIndex;
      end
      else if (CurrentGivenIndex < 0) or
        ComesBefore(CurrentProfile.Controls[CandidateIndex],
          CurrentProfile.Controls[CurrentGivenIndex]) then
        CurrentGivenIndex := CandidateIndex;
    end;

    if IsSearchButton(CurrentProfile.Controls[I],
      CurrentProfile.Controls[CurrentDialogIndex].Handle) then
    begin
      Inc(ButtonCount);
      if CurrentProfile.Controls[I].ProcessId <> CurrentProfile.ProcessId then
        raise EUIProfileError.Create('The search button belongs to another process.');
      CurrentButtonIndex := I;
    end;
  end;

  if EditCount <> 2 then
    raise EUIProfileError.CreateFmt(
      'Expected exactly two visible edit controls; found %d.', [EditCount]);
  if ButtonCount <> 1 then
    raise EUIProfileError.CreateFmt(
      'Expected exactly one visible "suchen" button; found %d.', [ButtonCount]);
  if not CurrentProfile.Controls[CurrentButtonIndex].Enabled then
    raise EUIProfileError.Create('The "suchen" button is disabled.');

  ExpectedNameIndex := -1;
  ExpectedGivenIndex := -1;
  ExpectedButtonIndex := -1;
  EditCount := 0;
  ButtonCount := 0;
  for I := 0 to High(ExpectedProfile.Controls) do
  begin
    if IsDirectVisibleEdit(ExpectedProfile.Controls[I],
      ExpectedProfile.Controls[ExpectedDialogIndex].Handle) then
    begin
      Inc(EditCount);
      CandidateIndex := I;
      if ExpectedNameIndex < 0 then
        ExpectedNameIndex := CandidateIndex
      else if ComesBefore(ExpectedProfile.Controls[CandidateIndex],
        ExpectedProfile.Controls[ExpectedNameIndex]) then
      begin
        ExpectedGivenIndex := ExpectedNameIndex;
        ExpectedNameIndex := CandidateIndex;
      end
      else if (ExpectedGivenIndex < 0) or
        ComesBefore(ExpectedProfile.Controls[CandidateIndex],
          ExpectedProfile.Controls[ExpectedGivenIndex]) then
        ExpectedGivenIndex := CandidateIndex;
    end;

    if IsSearchButton(ExpectedProfile.Controls[I],
      ExpectedProfile.Controls[ExpectedDialogIndex].Handle) then
    begin
      Inc(ButtonCount);
      ExpectedButtonIndex := I;
    end;
  end;

  if (EditCount <> 2) or (ButtonCount <> 1) then
    raise EUIProfileError.Create('The saved profile does not contain a valid person-search layout.');

  if not SameControlStructure(
    CurrentProfile.Controls[CurrentDialogIndex],
    ExpectedProfile.Controls[ExpectedDialogIndex], False) then
    raise EUIProfileError.Create('The person-search window no longer matches its saved profile.');
  if not SameControlStructure(CurrentProfile.Controls[CurrentMainIndex],
    ExpectedProfile.Controls[ExpectedMainIndex], False) then
    raise EUIProfileError.Create('The main window no longer matches its saved profile.');

  if not SameControlStructure(CurrentProfile.Controls[CurrentNameIndex],
    ExpectedProfile.Controls[ExpectedNameIndex], True) then
    raise EUIProfileError.Create('The surname edit control differs from the saved profile.');
  if not SameControlStructure(CurrentProfile.Controls[CurrentGivenIndex],
    ExpectedProfile.Controls[ExpectedGivenIndex], True) then
    raise EUIProfileError.Create('The given-name edit control differs from the saved profile.');
  if not SameControlStructure(CurrentProfile.Controls[CurrentButtonIndex],
    ExpectedProfile.Controls[ExpectedButtonIndex], False) then
    raise EUIProfileError.Create('The search button differs from the saved profile.');

  CurrentChildCount := 0;
  ExpectedChildCount := 0;
  for I := 0 to High(CurrentProfile.Controls) do
    if CurrentProfile.Controls[I].ParentHandle =
       CurrentProfile.Controls[CurrentDialogIndex].Handle then
    begin
      Inc(CurrentChildCount);
      MatchingExpectedIndex := FindByHandle(ExpectedProfile,
        CurrentProfile.Controls[I].Handle);
      if (MatchingExpectedIndex < 0) or
         (ExpectedProfile.Controls[MatchingExpectedIndex].ParentHandle <>
           CurrentProfile.Controls[CurrentDialogIndex].Handle) then
        raise EUIProfileError.Create('The dialog contains a control absent from the approved profile.');

      AllowTextChange := (I = CurrentNameIndex) or (I = CurrentGivenIndex);
      if not SameControlStructure(CurrentProfile.Controls[I],
        ExpectedProfile.Controls[MatchingExpectedIndex], AllowTextChange) then
        raise EUIProfileError.Create('A person-search dialog control differs from the approved profile.');
    end;

  for I := 0 to High(ExpectedProfile.Controls) do
    if ExpectedProfile.Controls[I].ParentHandle =
       ExpectedProfile.Controls[ExpectedDialogIndex].Handle then
    begin
      Inc(ExpectedChildCount);
      if FindByHandle(CurrentProfile, ExpectedProfile.Controls[I].Handle) < 0 then
        raise EUIProfileError.Create('A control from the approved search dialog is missing.');
    end;
  if CurrentChildCount <> ExpectedChildCount then
    raise EUIProfileError.Create('The search dialog control count differs from the approved profile.');

  CurrentTopLevelCount := 0;
  ExpectedTopLevelCount := 0;
  for I := 0 to High(CurrentProfile.Controls) do
    if CurrentProfile.Controls[I].IsTopLevel and CurrentProfile.Controls[I].Visible then
    begin
      Inc(CurrentTopLevelCount);
      MatchingExpectedIndex := FindByHandle(ExpectedProfile,
        CurrentProfile.Controls[I].Handle);
      if (MatchingExpectedIndex < 0) or
         not ExpectedProfile.Controls[MatchingExpectedIndex].IsTopLevel or
         not ExpectedProfile.Controls[MatchingExpectedIndex].Visible or
         not SameControlStructure(CurrentProfile.Controls[I],
           ExpectedProfile.Controls[MatchingExpectedIndex], False) then
        raise EUIProfileError.Create('A visible top-level window differs from the approved profile.');
    end;

  for I := 0 to High(ExpectedProfile.Controls) do
    if ExpectedProfile.Controls[I].IsTopLevel and
       ExpectedProfile.Controls[I].Visible then
    begin
      Inc(ExpectedTopLevelCount);
      if FindByHandle(CurrentProfile, ExpectedProfile.Controls[I].Handle) < 0 then
        raise EUIProfileError.Create('A visible top-level window from the approved profile is missing.');
    end;
  if CurrentTopLevelCount <> ExpectedTopLevelCount then
    raise EUIProfileError.Create('The visible top-level window count differs from the approved profile.');

  Targets.DialogHandle := CurrentProfile.Controls[CurrentDialogIndex].Handle;
  Targets.NameEditHandle := CurrentProfile.Controls[CurrentNameIndex].Handle;
  Targets.GivenNameEditHandle := CurrentProfile.Controls[CurrentGivenIndex].Handle;
  Targets.SearchButtonHandle := CurrentProfile.Controls[CurrentButtonIndex].Handle;
end;

function ProfileToJSON(const Profile: TWindowProfile): UTF8String;
var
  RootObject: TJSONObject;
  ProcessObject: TJSONObject;
  ControlsArray: TJSONArray;
  ControlObject: TJSONObject;
  I: LongInt;
begin
  RootObject := TJSONObject.Create;
  try
    RootObject.Add('schemaVersion', TJSONIntegerNumber.Create(1));

    ProcessObject := TJSONObject.Create;
    ProcessObject.Add('id', TJSONInt64Number.Create(Profile.ProcessId));
    ProcessObject.Add('path', Profile.ExecutablePath);
    ProcessObject.Add('sha256', Profile.ExecutableSha256);
    RootObject.Add('process', ProcessObject);

    ControlsArray := TJSONArray.Create;
    for I := 0 to High(Profile.Controls) do
    begin
      ControlObject := TJSONObject.Create;
      ControlObject.Add('handle', TJSONInt64Number.Create(Int64(Profile.Controls[I].Handle)));
      ControlObject.Add('parent', TJSONInt64Number.Create(Int64(Profile.Controls[I].ParentHandle)));
      ControlObject.Add('owner', TJSONInt64Number.Create(Int64(Profile.Controls[I].OwnerHandle)));
      ControlObject.Add('pid', TJSONInt64Number.Create(Profile.Controls[I].ProcessId));
      ControlObject.Add('class', Profile.Controls[I].ClassName);
      ControlObject.Add('text', Profile.Controls[I].Text);
      ControlObject.Add('left', TJSONIntegerNumber.Create(Profile.Controls[I].Left));
      ControlObject.Add('top', TJSONIntegerNumber.Create(Profile.Controls[I].Top));
      ControlObject.Add('width', TJSONIntegerNumber.Create(Profile.Controls[I].Width));
      ControlObject.Add('height', TJSONIntegerNumber.Create(Profile.Controls[I].Height));
      ControlObject.Add('controlId', TJSONIntegerNumber.Create(Profile.Controls[I].ControlId));
      ControlObject.Add('visible', TJSONBoolean.Create(Profile.Controls[I].Visible));
      ControlObject.Add('enabled', TJSONBoolean.Create(Profile.Controls[I].Enabled));
      ControlObject.Add('password', TJSONBoolean.Create(Profile.Controls[I].IsPassword));
      ControlObject.Add('topLevel', TJSONBoolean.Create(Profile.Controls[I].IsTopLevel));
      ControlObject.Add('ordinal', TJSONIntegerNumber.Create(Profile.Controls[I].Ordinal));
      ControlsArray.Add(ControlObject);
    end;
    RootObject.Add('windows', ControlsArray);
    Result := RootObject.FormatJSON;
  finally
    RootObject.Free;
  end;
end;

function RequiredJSONValue(
  const ParentObject: TJSONObject; const Name: string): TJSONData;
begin
  if not ParentObject.Find(Name, Result) then
    raise EUIProfileError.CreateFmt('UI profile is missing JSON property "%s".', [Name]);
end;

function ProfileFromJSON(const JSON: UTF8String): TWindowProfile;
var
  RootData: TJSONData;
  RootObject: TJSONObject;
  ProcessObject: TJSONObject;
  ControlsArray: TJSONArray;
  ControlObject: TJSONObject;
  Value: TJSONData;
  I: LongInt;
begin
  Result.ProcessId := 0;
  Result.ExecutablePath := '';
  Result.ExecutableSha256 := '';
  Result.Controls := nil;
  RootData := GetJSON(JSON);
  try
    if not (RootData is TJSONObject) then
      raise EUIProfileError.Create('UI profile root must be a JSON object.');
    RootObject := TJSONObject(RootData);
    if RequiredJSONValue(RootObject, 'schemaVersion').AsInteger <> 1 then
      raise EUIProfileError.Create('Unsupported UI profile schema version.');

    Value := RequiredJSONValue(RootObject, 'process');
    if not (Value is TJSONObject) then
      raise EUIProfileError.Create('UI profile process property must be an object.');
    ProcessObject := TJSONObject(Value);
    Result.ProcessId := ProcessObject.Get('id', Int64(0));
    Result.ExecutablePath := ProcessObject.Get('path', '');
    Result.ExecutableSha256 := ProcessObject.Get('sha256', '');
    if (Result.ProcessId = 0) or (Result.ExecutablePath = '') or
       (Result.ExecutableSha256 = '') then
      raise EUIProfileError.Create('UI profile process identity is incomplete.');

    Value := RequiredJSONValue(RootObject, 'windows');
    if not (Value is TJSONArray) then
      raise EUIProfileError.Create('UI profile windows property must be an array.');
    ControlsArray := TJSONArray(Value);
    SetLength(Result.Controls, ControlsArray.Count);

    for I := 0 to ControlsArray.Count - 1 do
    begin
      Value := ControlsArray.Items[I];
      if not (Value is TJSONObject) then
        raise EUIProfileError.CreateFmt('UI profile window %d must be an object.', [I]);
      ControlObject := TJSONObject(Value);

      Result.Controls[I].Handle := ControlObject.Get('handle', Int64(0));
      Result.Controls[I].ParentHandle := ControlObject.Get('parent', Int64(0));
      Result.Controls[I].OwnerHandle := ControlObject.Get('owner', Int64(0));
      Result.Controls[I].ProcessId := ControlObject.Get('pid', LongWord(0));
      Result.Controls[I].ClassName := ControlObject.Get('class', '');
      Result.Controls[I].Text := ControlObject.Get('text', '');
      Result.Controls[I].Left := ControlObject.Get('left', LongInt(0));
      Result.Controls[I].Top := ControlObject.Get('top', LongInt(0));
      Result.Controls[I].Width := ControlObject.Get('width', LongInt(0));
      Result.Controls[I].Height := ControlObject.Get('height', LongInt(0));
      Result.Controls[I].ControlId := ControlObject.Get('controlId', LongInt(0));
      Result.Controls[I].Visible := ControlObject.Get('visible', False);
      Result.Controls[I].Enabled := ControlObject.Get('enabled', False);
      Result.Controls[I].IsPassword := ControlObject.Get('password', False);
      Result.Controls[I].IsTopLevel := ControlObject.Get('topLevel', False);
      Result.Controls[I].Ordinal := ControlObject.Get('ordinal', LongInt(0));
      if (Result.Controls[I].Handle = 0) or
         (Result.Controls[I].ClassName = '') then
        raise EUIProfileError.CreateFmt('UI profile window %d has no handle or class.', [I]);
    end;
  finally
    RootData.Free;
  end;
end;

end.
