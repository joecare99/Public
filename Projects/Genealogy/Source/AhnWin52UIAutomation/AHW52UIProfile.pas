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
  TUIHandleArray = array of QWord;

  TWindowProfile = record
    ProcessId: LongWord;
    ExecutablePath: UTF8String;
    ExecutableSha256: UTF8String;
    ForegroundWindowHandle: QWord;
    Controls: TUIControlInfoArray;
  end;

  TPersonSearchTargets = record
    DialogHandle: QWord;
    NameEditHandle: QWord;
    GivenNameEditHandle: QWord;
    SearchButtonHandle: QWord;
  end;

  TMainWindowTargets = record
    MainWindowHandle: QWord;
    PageControlHandle: QWord;
  end;

  EUIProfileError = class(Exception);

function SameWindowsPath(const LeftPath, RightPath: UTF8String): Boolean;
function HasVisiblePersonSearchDialog(
  const Profile: TWindowProfile): Boolean;
procedure ValidateExecutableIdentity(
  const ActualPath, ActualSha256: UTF8String);
procedure ValidatePersonSearchProfile(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  out Targets: TPersonSearchTargets);
procedure ValidateMetadataOnlyProfile(const Profile: TWindowProfile);
procedure ValidateMainWindowProfile(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  out Targets: TMainWindowTargets);
procedure ValidateCloseMainWindowProfile(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  out Targets: TMainWindowTargets);
procedure ValidateNextTabProfile(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  out Targets: TMainWindowTargets);
function NextNativeTabIndex(
  CurrentTabIndex, TabCount: LongInt): LongInt;
procedure ValidateReadableFieldTargets(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  const Handles: array of QWord);
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

function HasVisiblePersonSearchDialog(
  const Profile: TWindowProfile): Boolean;
var
  I: LongInt;
begin
  for I := 0 to High(Profile.Controls) do
    if Profile.Controls[I].IsTopLevel and
       Profile.Controls[I].Visible and
       SameText(Trim(Profile.Controls[I].Text), PersonSearchCaption) then
      Exit(True);
  Result := False;
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

procedure ValidateMatchingMetadataProfiles(
  const CurrentProfile, ExpectedProfile: TWindowProfile);
var
  CurrentIndex: LongInt;
  I: LongInt;
begin
  ValidateMetadataOnlyProfile(ExpectedProfile);
  ValidateMetadataOnlyProfile(CurrentProfile);
  if CurrentProfile.ProcessId <> ExpectedProfile.ProcessId then
    raise EUIProfileError.Create(
      'The current process differs from the approved metadata profile.');
  if Length(CurrentProfile.Controls) <> Length(ExpectedProfile.Controls) then
    raise EUIProfileError.Create(
      'The current window hierarchy differs from the approved metadata profile.');
  for I := 0 to High(ExpectedProfile.Controls) do
  begin
    CurrentIndex := FindByHandle(CurrentProfile,
      ExpectedProfile.Controls[I].Handle);
    if (CurrentIndex < 0) or
       not SameControlStructure(CurrentProfile.Controls[CurrentIndex],
         ExpectedProfile.Controls[I], False) then
      raise EUIProfileError.Create(
        'The current window hierarchy differs from the approved metadata profile.');
  end;
end;

procedure ValidateMainWindowProfile(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  out Targets: TMainWindowTargets);
var
  I: LongInt;
  MainIndex: LongInt;
  Matches: LongInt;
begin
  ValidateMatchingMetadataProfiles(CurrentProfile, ExpectedProfile);
  MainIndex := -1;
  Matches := 0;
  for I := 0 to High(CurrentProfile.Controls) do
    if CurrentProfile.Controls[I].IsTopLevel and
       CurrentProfile.Controls[I].Visible and
       SameText(CurrentProfile.Controls[I].ClassName, MainWindowClass) then
    begin
      MainIndex := I;
      Inc(Matches);
    end;
  if Matches <> 1 then
    raise EUIProfileError.Create(
      'Exactly one visible AHNENWIN main window is required.');
  if not CurrentProfile.Controls[MainIndex].Enabled then
    raise EUIProfileError.Create('The AHNENWIN main window is disabled.');
  Targets.MainWindowHandle := CurrentProfile.Controls[MainIndex].Handle;
  Targets.PageControlHandle := 0;
end;

procedure ValidateCloseMainWindowProfile(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  out Targets: TMainWindowTargets);
var
  CurrentMainIndex: LongInt;
  ExpectedMainIndex: LongInt;
  Matches: LongInt;
  I: LongInt;
  CurrentMain: TUIControlInfo;
  ExpectedMain: TUIControlInfo;
begin
  ValidateMetadataOnlyProfile(CurrentProfile);
  ValidateMetadataOnlyProfile(ExpectedProfile);
  if CurrentProfile.ProcessId <> ExpectedProfile.ProcessId then
    raise EUIProfileError.Create(
      'The current process differs from the approved metadata profile.');
  CurrentMainIndex := -1;
  ExpectedMainIndex := -1;
  Matches := 0;
  for I := 0 to High(CurrentProfile.Controls) do
    if CurrentProfile.Controls[I].IsTopLevel and
       CurrentProfile.Controls[I].Visible and
       SameText(CurrentProfile.Controls[I].ClassName, MainWindowClass) then
    begin
      CurrentMainIndex := I;
      Inc(Matches);
    end;
  if Matches <> 1 then
    raise EUIProfileError.Create(
      'Exactly one visible AHNENWIN main window is required for close.');
  Matches := 0;
  for I := 0 to High(ExpectedProfile.Controls) do
    if ExpectedProfile.Controls[I].Handle =
       CurrentProfile.Controls[CurrentMainIndex].Handle then
    begin
      ExpectedMainIndex := I;
      Inc(Matches);
    end;
  if (Matches <> 1) or
     not ExpectedProfile.Controls[ExpectedMainIndex].IsTopLevel or
     not ExpectedProfile.Controls[ExpectedMainIndex].Visible or
     not SameText(ExpectedProfile.Controls[ExpectedMainIndex].ClassName,
       MainWindowClass) then
    raise EUIProfileError.Create(
      'The current main window differs from the approved metadata profile.');

  CurrentMain := CurrentProfile.Controls[CurrentMainIndex];
  ExpectedMain := ExpectedProfile.Controls[ExpectedMainIndex];
  CurrentMain.Enabled := ExpectedMain.Enabled;
  if not SameControlStructure(CurrentMain, ExpectedMain, True) then
    raise EUIProfileError.Create(
      'The current main window differs from the approved metadata profile.');
  Targets.MainWindowHandle := CurrentMain.Handle;
  Targets.PageControlHandle := 0;
end;

procedure ValidateNextTabProfile(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  out Targets: TMainWindowTargets);
var
  I: LongInt;
  MainIndex: LongInt;
  PageControlIndex: LongInt;
  MainCount: LongInt;
  PageControlCount: LongInt;
  TabSheetCount: LongInt;
  VisibleTabCount: LongInt;
begin
  ValidateMainWindowProfile(CurrentProfile, ExpectedProfile, Targets);
  MainIndex := FindByHandle(CurrentProfile, Targets.MainWindowHandle);
  PageControlIndex := -1;
  MainCount := 0;
  PageControlCount := 0;
  for I := 0 to High(CurrentProfile.Controls) do
  begin
    if CurrentProfile.Controls[I].IsTopLevel and
       CurrentProfile.Controls[I].Visible and
       SameText(CurrentProfile.Controls[I].ClassName, MainWindowClass) then
      Inc(MainCount);
    if (CurrentProfile.Controls[I].ParentHandle =
        CurrentProfile.Controls[MainIndex].Handle) and
       CurrentProfile.Controls[I].Visible and
       SameText(CurrentProfile.Controls[I].ClassName, 'TPageControl') then
    begin
      PageControlIndex := I;
      Inc(PageControlCount);
    end;
  end;
  if (MainCount <> 1) or (PageControlCount <> 1) then
    raise EUIProfileError.Create(
      'The expected main form and its single visible page control are required.');

  TabSheetCount := 0;
  VisibleTabCount := 0;
  for I := 0 to High(CurrentProfile.Controls) do
    if (CurrentProfile.Controls[I].ParentHandle =
        CurrentProfile.Controls[PageControlIndex].Handle) and
       SameText(CurrentProfile.Controls[I].ClassName, 'TTabSheet') then
    begin
      Inc(TabSheetCount);
      if CurrentProfile.Controls[I].Visible then
        Inc(VisibleTabCount);
    end;
  if TabSheetCount < 2 then
    raise EUIProfileError.Create(
      'At least two page sheets are required for a next-tab transition.');

  if VisibleTabCount <> 1 then
    raise EUIProfileError.Create(
      'The next-tab action requires exactly one active page sheet.');
  if not CurrentProfile.Controls[PageControlIndex].Enabled then
    raise EUIProfileError.Create('The main page control is disabled.');

  Targets.PageControlHandle :=
    CurrentProfile.Controls[PageControlIndex].Handle;
end;

function NextNativeTabIndex(
  CurrentTabIndex, TabCount: LongInt): LongInt;
begin
  if (TabCount < 1) or (CurrentTabIndex < 0) or
     (CurrentTabIndex >= TabCount) then
    raise EUIProfileError.Create('The native page-control selection is invalid.');
  if CurrentTabIndex = TabCount - 1 then
    raise EUIProfileError.Create(
      'The active page is already the last tab; wrapping to the first tab is forbidden.');
  Result := CurrentTabIndex + 1;
end;

function IsReadableFieldClass(const ClassName: UTF8String): Boolean;
begin
  Result := SameText(ClassName, 'Edit') or
    SameText(ClassName, 'TEdit') or
    SameText(ClassName, 'TDBEdit') or
    SameText(ClassName, 'TMaskEdit') or
    SameText(ClassName, 'TDBMaskEdit') or
    SameText(ClassName, 'ComboBox') or
    SameText(ClassName, 'TComboBox') or
    SameText(ClassName, 'TDBComboBox');
end;

procedure ValidateMetadataOnlyProfile(const Profile: TWindowProfile);
var
  I: LongInt;
  J: LongInt;
begin
  ValidateExecutableIdentity(Profile.ExecutablePath, Profile.ExecutableSha256);
  if Profile.ProcessId = 0 then
    raise EUIProfileError.Create('The metadata profile has no process ID.');
  if Length(Profile.Controls) = 0 then
    raise EUIProfileError.Create('The metadata profile contains no windows.');
  for I := 0 to High(Profile.Controls) do
  begin
    if Profile.Controls[I].Text <> '' then
      raise EUIProfileError.Create(
        'Field reads require a metadata-only profile with no captured control text.');
    if (Profile.Controls[I].Handle = 0) or
       (Profile.Controls[I].ProcessId <> Profile.ProcessId) then
      raise EUIProfileError.Create(
        'The metadata profile contains an invalid or foreign window handle.');
    for J := I + 1 to High(Profile.Controls) do
      if Profile.Controls[I].Handle = Profile.Controls[J].Handle then
        raise EUIProfileError.Create(
          'The metadata profile contains a duplicate window handle.');
  end;
end;

procedure ValidateReadableFieldTargets(
  const CurrentProfile, ExpectedProfile: TWindowProfile;
  const Handles: array of QWord);
var
  CurrentIndex: LongInt;
  ExpectedIndex: LongInt;
  ParentIndex: LongInt;
  RootIndex: LongInt;
  I: LongInt;
begin
  ValidateMetadataOnlyProfile(ExpectedProfile);
  ValidateExecutableIdentity(CurrentProfile.ExecutablePath,
    CurrentProfile.ExecutableSha256);
  if (CurrentProfile.ProcessId = 0) or
     (CurrentProfile.ProcessId <> ExpectedProfile.ProcessId) then
    raise EUIProfileError.Create(
      'The current process differs from the metadata profile.');
  if Length(Handles) = 0 then
    raise EUIProfileError.Create('At least one field handle must be selected.');
  if Length(Handles) > 16 then
    raise EUIProfileError.Create('At most 16 field handles may be read at once.');

  for I := Low(Handles) to High(Handles) do
  begin
    if Handles[I] = 0 then
      raise EUIProfileError.Create('A selected field handle is invalid.');
    if FindByHandle(CurrentProfile, Handles[I]) < 0 then
      raise EUIProfileError.Create(
        'A selected field is not present in the current target process.');
    if FindByHandle(ExpectedProfile, Handles[I]) < 0 then
      raise EUIProfileError.Create(
        'A selected field is not present in the saved metadata profile.');
    for RootIndex := Low(Handles) to I - 1 do
      if Handles[RootIndex] = Handles[I] then
        raise EUIProfileError.Create(
          'A field handle was selected more than once.');

    CurrentIndex := FindByHandle(CurrentProfile, Handles[I]);
    ExpectedIndex := FindByHandle(ExpectedProfile, Handles[I]);
    if CurrentProfile.Controls[CurrentIndex].ProcessId <>
       CurrentProfile.ProcessId then
      raise EUIProfileError.Create(
        'A selected field belongs to another process.');
    if not CurrentProfile.Controls[CurrentIndex].Visible or
       not ExpectedProfile.Controls[ExpectedIndex].Visible then
      raise EUIProfileError.Create('A selected field is not visible.');
    if CurrentProfile.Controls[CurrentIndex].IsPassword or
       ExpectedProfile.Controls[ExpectedIndex].IsPassword then
      raise EUIProfileError.Create('Password controls cannot be read.');
    if CurrentProfile.Controls[CurrentIndex].IsTopLevel or
       ExpectedProfile.Controls[ExpectedIndex].IsTopLevel then
      raise EUIProfileError.Create(
        'Only explicit text-field controls may be read.');
    if not IsReadableFieldClass(CurrentProfile.Controls[CurrentIndex].ClassName) or
       not IsReadableFieldClass(ExpectedProfile.Controls[ExpectedIndex].ClassName) then
      raise EUIProfileError.CreateFmt(
        'Window class "%s" is not an approved field control.',
        [CurrentProfile.Controls[CurrentIndex].ClassName]);
    if not SameControlStructure(CurrentProfile.Controls[CurrentIndex],
      ExpectedProfile.Controls[ExpectedIndex], True) then
      raise EUIProfileError.Create(
        'A selected field no longer matches the saved metadata profile.');

    ParentIndex := FindByHandle(CurrentProfile,
      CurrentProfile.Controls[CurrentIndex].ParentHandle);
    if (ParentIndex < 0) or
       (CurrentProfile.Controls[ParentIndex].ProcessId <>
        CurrentProfile.ProcessId) then
      raise EUIProfileError.Create(
        'A selected field has no validated parent in the target process.');
    RootIndex := ParentIndex;
    while not CurrentProfile.Controls[RootIndex].IsTopLevel do
    begin
      RootIndex := FindByHandle(CurrentProfile,
        CurrentProfile.Controls[RootIndex].ParentHandle);
      if RootIndex < 0 then
        raise EUIProfileError.Create(
          'A selected field is not beneath a validated target window.');
    end;
  end;
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
    RootObject.Add('schemaVersion', TJSONIntegerNumber.Create(2));

    ProcessObject := TJSONObject.Create;
    ProcessObject.Add('id', TJSONInt64Number.Create(Profile.ProcessId));
    ProcessObject.Add('path', Profile.ExecutablePath);
    ProcessObject.Add('sha256', Profile.ExecutableSha256);
    ProcessObject.Add('foregroundWindowHandle',
      TJSONInt64Number.Create(Int64(Profile.ForegroundWindowHandle)));
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
    Value := RequiredJSONValue(RootObject, 'schemaVersion');
    if (Value.JSONType <> jtNumber) or not (Value.AsInteger in [1, 2]) then
      raise EUIProfileError.Create('Unsupported UI profile schema version.');

    Value := RequiredJSONValue(RootObject, 'process');
    if not (Value is TJSONObject) then
      raise EUIProfileError.Create('UI profile process property must be an object.');
    ProcessObject := TJSONObject(Value);
    Result.ProcessId := ProcessObject.Get('id', Int64(0));
    Result.ExecutablePath := ProcessObject.Get('path', '');
    Result.ExecutableSha256 := ProcessObject.Get('sha256', '');
    Result.ForegroundWindowHandle := ProcessObject.Get(
      'foregroundWindowHandle', Int64(0));
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
