unit tst_AHW52UIProfileTests;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  AHW52UIProfile, fpcunit, testregistry;

type
  TTestAHW52UIProfile = class(TTestCase)
  private
    function CreateValidProfile: TWindowProfile;
    function CloneProfile(const Source: TWindowProfile): TWindowProfile;
    procedure AssertProfileRejected(
      const CurrentProfile, ExpectedProfile: TWindowProfile);
  published
    procedure TestValidatesPersonSearchAndOrdersEditsByPosition;
    procedure TestRejectsUnexpectedExecutablePath;
    procedure TestRejectsUnexpectedExecutableHash;
    procedure TestRejectsExtraEditControl;
    procedure TestRejectsMissingSearchButton;
    procedure TestRejectsDisabledSearchButton;
    procedure TestRejectsProfileGeometryChange;
    procedure TestRejectsUnenumeratedOwnerWindow;
    procedure TestAcceptsStableApplicationWindowOwner;
    procedure TestDisambiguatesVisibleApplicationWindow;
    procedure TestDetectsVisiblePersonSearchDialog;
    procedure TestDetectsClosedPersonSearchDialog;
    procedure TestRejectsPasswordStyleEditAsSearchInput;
    procedure TestRejectsAmbiguousSearchDialog;
    procedure TestRejectsUnexpectedDialogControl;
    procedure TestRejectsChangedDialogControl;
    procedure TestRejectsUnexpectedTopLevelWindow;
    procedure TestRoundTripsJSONProfile;
    procedure TestRejectsMalformedJSONProfile;
  end;

implementation

uses
  SysUtils;

const
  TestExecutablePath = 'C:\ProgramData\AHNENWIN Test\AHNWIN51.exe';
  TestExecutableHash =
    '817C1B1BB23469CD628C52E4A5EA26CB4DB26275B5EC84952717B218605F0AFF';
  TestProcessId = 4172;
  MainWindowHandle = QWord(100);
  SearchDialogHandle = QWord(200);

function TTestAHW52UIProfile.CreateValidProfile: TWindowProfile;
begin
  Result.ProcessId := TestProcessId;
  Result.ExecutablePath := TestExecutablePath;
  Result.ExecutableSha256 := TestExecutableHash;
  SetLength(Result.Controls, 6);

  Result.Controls[0].Handle := MainWindowHandle;
  Result.Controls[0].ProcessId := TestProcessId;
  Result.Controls[0].ClassName := 'TForm1';
  Result.Controls[0].Text := 'AHNENWIN 5.1';
  Result.Controls[0].Width := 792;
  Result.Controls[0].Height := 546;
  Result.Controls[0].Visible := True;
  Result.Controls[0].Enabled := True;
  Result.Controls[0].IsTopLevel := True;

  Result.Controls[1].Handle := SearchDialogHandle;
  Result.Controls[1].OwnerHandle := MainWindowHandle;
  Result.Controls[1].ProcessId := TestProcessId;
  Result.Controls[1].ClassName := 'TForm3';
  Result.Controls[1].Text := 'Auswahl';
  Result.Controls[1].Width := 386;
  Result.Controls[1].Height := 147;
  Result.Controls[1].Visible := True;
  Result.Controls[1].Enabled := True;
  Result.Controls[1].IsTopLevel := True;

  Result.Controls[2].Handle := 202;
  Result.Controls[2].ParentHandle := SearchDialogHandle;
  Result.Controls[2].ProcessId := TestProcessId;
  Result.Controls[2].ClassName := 'TEdit';
  Result.Controls[2].Text := '';
  Result.Controls[2].Top := 29;
  Result.Controls[2].Left := 112;
  Result.Controls[2].Width := 241;
  Result.Controls[2].Height := 21;
  Result.Controls[2].ControlId := 101;
  Result.Controls[2].Visible := True;
  Result.Controls[2].Enabled := True;
  Result.Controls[2].Ordinal := 1;

  Result.Controls[3].Handle := 203;
  Result.Controls[3].ParentHandle := SearchDialogHandle;
  Result.Controls[3].ProcessId := TestProcessId;
  Result.Controls[3].ClassName := 'TEdit';
  Result.Controls[3].Text := '';
  Result.Controls[3].Top := 60;
  Result.Controls[3].Left := 112;
  Result.Controls[3].Width := 241;
  Result.Controls[3].Height := 21;
  Result.Controls[3].ControlId := 102;
  Result.Controls[3].Visible := True;
  Result.Controls[3].Enabled := True;
  Result.Controls[3].Ordinal := 2;

  Result.Controls[4].Handle := 204;
  Result.Controls[4].ParentHandle := SearchDialogHandle;
  Result.Controls[4].ProcessId := TestProcessId;
  Result.Controls[4].ClassName := 'TButton';
  Result.Controls[4].Text := 'suchen';
  Result.Controls[4].Top := 96;
  Result.Controls[4].Left := 112;
  Result.Controls[4].Width := 75;
  Result.Controls[4].Height := 25;
  Result.Controls[4].ControlId := 103;
  Result.Controls[4].Visible := True;
  Result.Controls[4].Enabled := True;
  Result.Controls[4].Ordinal := 3;

  Result.Controls[5].Handle := 205;
  Result.Controls[5].ParentHandle := SearchDialogHandle;
  Result.Controls[5].ProcessId := TestProcessId;
  Result.Controls[5].ClassName := 'TBitBtn';
  Result.Controls[5].Text := 'schon gefunden';
  Result.Controls[5].Top := 96;
  Result.Controls[5].Left := 219;
  Result.Controls[5].Width := 135;
  Result.Controls[5].Height := 25;
  Result.Controls[5].ControlId := 104;
  Result.Controls[5].Visible := True;
  Result.Controls[5].Enabled := True;
  Result.Controls[5].Ordinal := 4;
end;

function TTestAHW52UIProfile.CloneProfile(
  const Source: TWindowProfile): TWindowProfile;
begin
  Result := Source;
  Result.Controls := Copy(Source.Controls, 0, Length(Source.Controls));
end;

procedure TTestAHW52UIProfile.AssertProfileRejected(
  const CurrentProfile, ExpectedProfile: TWindowProfile);
var
  Targets: TPersonSearchTargets;
begin
  try
    ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
    Fail('Expected the profile validator to reject the supplied profile.');
  except
    on E: EUIProfileError do
      CheckNotEquals('', E.Message);
  end;
end;

procedure TTestAHW52UIProfile.TestValidatesPersonSearchAndOrdersEditsByPosition;
var
  CurrentProfile: TWindowProfile;
  ExpectedProfile: TWindowProfile;
  Targets: TPersonSearchTargets;
begin
  ExpectedProfile := CreateValidProfile;
  CurrentProfile := CloneProfile(ExpectedProfile);
  CurrentProfile.Controls[2].Text := 'Mustername';
  CurrentProfile.Controls[3].Text := 'Anna';

  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);

  AssertEquals(QWord(SearchDialogHandle), Targets.DialogHandle);
  AssertEquals(QWord(202), Targets.NameEditHandle);
  AssertEquals(QWord(203), Targets.GivenNameEditHandle);
  AssertEquals(QWord(204), Targets.SearchButtonHandle);
end;

procedure TTestAHW52UIProfile.TestRejectsUnexpectedExecutablePath;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  Profile.ExecutablePath := 'C:\ProgramData\AHNENWIN Test\AHNWIN51_.exe';
  AssertProfileRejected(Profile, CreateValidProfile);
end;

procedure TTestAHW52UIProfile.TestRejectsUnexpectedExecutableHash;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  Profile.ExecutableSha256 := StringOfChar('0', 64);
  AssertProfileRejected(Profile, CreateValidProfile);
end;

procedure TTestAHW52UIProfile.TestRejectsExtraEditControl;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  SetLength(Profile.Controls, Length(Profile.Controls) + 1);
  Profile.Controls[High(Profile.Controls)] := Profile.Controls[2];
  Profile.Controls[High(Profile.Controls)].Handle := 205;
  Profile.Controls[High(Profile.Controls)].Ordinal := 4;
  AssertProfileRejected(Profile, CreateValidProfile);
end;

procedure TTestAHW52UIProfile.TestRejectsMissingSearchButton;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  Profile.Controls[4].Text := 'Abbruch';
  AssertProfileRejected(Profile, Profile);
end;

procedure TTestAHW52UIProfile.TestRejectsDisabledSearchButton;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  Profile.Controls[4].Enabled := False;
  AssertProfileRejected(Profile, Profile);
end;

procedure TTestAHW52UIProfile.TestRejectsProfileGeometryChange;
var
  CurrentProfile: TWindowProfile;
  ExpectedProfile: TWindowProfile;
begin
  ExpectedProfile := CreateValidProfile;
  CurrentProfile := CloneProfile(ExpectedProfile);
  Inc(CurrentProfile.Controls[2].Left);
  AssertProfileRejected(CurrentProfile, ExpectedProfile);
end;

procedure TTestAHW52UIProfile.TestRejectsUnenumeratedOwnerWindow;
var
  Profile: TWindowProfile;
  Targets: TPersonSearchTargets;
begin
  Profile := CreateValidProfile;
  Profile.Controls[1].OwnerHandle := 999;
  try
    ValidatePersonSearchProfile(Profile, Profile, Targets);
    Fail('Expected an unenumerated owner window to be rejected.');
  except
    on E: EUIProfileError do
      CheckNotEquals('', E.Message);
  end;
end;

procedure TTestAHW52UIProfile.TestAcceptsStableApplicationWindowOwner;
var
  Profile: TWindowProfile;
  Targets: TPersonSearchTargets;
begin
  Profile := CreateValidProfile;
  Profile.Controls[1].OwnerHandle := 300;
  SetLength(Profile.Controls, Length(Profile.Controls) + 1);
  Profile.Controls[High(Profile.Controls)].Handle := 300;
  Profile.Controls[High(Profile.Controls)].ProcessId := TestProcessId;
  Profile.Controls[High(Profile.Controls)].ClassName := 'TApplication';
  Profile.Controls[High(Profile.Controls)].Visible := False;
  Profile.Controls[High(Profile.Controls)].Enabled := True;
  Profile.Controls[High(Profile.Controls)].IsTopLevel := True;

  ValidatePersonSearchProfile(Profile, Profile, Targets);
  AssertEquals(QWord(202), Targets.NameEditHandle);
end;

procedure TTestAHW52UIProfile.TestDisambiguatesVisibleApplicationWindow;
var
  Profile: TWindowProfile;
  Targets: TPersonSearchTargets;
begin
  Profile := CreateValidProfile;
  SetLength(Profile.Controls, Length(Profile.Controls) + 1);
  Profile.Controls[High(Profile.Controls)].Handle := 300;
  Profile.Controls[High(Profile.Controls)].ProcessId := TestProcessId;
  Profile.Controls[High(Profile.Controls)].ClassName := 'TApplication';
  Profile.Controls[High(Profile.Controls)].Text := 'AHNENWIN 5.1';
  Profile.Controls[High(Profile.Controls)].Visible := True;
  Profile.Controls[High(Profile.Controls)].Enabled := True;
  Profile.Controls[High(Profile.Controls)].IsTopLevel := True;

  ValidatePersonSearchProfile(Profile, Profile, Targets);
  AssertEquals(QWord(SearchDialogHandle), Targets.DialogHandle);
  AssertEquals(QWord(202), Targets.NameEditHandle);
end;

procedure TTestAHW52UIProfile.TestDetectsVisiblePersonSearchDialog;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  CheckTrue(HasVisiblePersonSearchDialog(Profile));
end;

procedure TTestAHW52UIProfile.TestDetectsClosedPersonSearchDialog;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  Profile.Controls[1].Visible := False;
  CheckFalse(HasVisiblePersonSearchDialog(Profile));
end;

procedure TTestAHW52UIProfile.TestRejectsPasswordStyleEditAsSearchInput;
var
  Profile: TWindowProfile;
begin
  Profile := CreateValidProfile;
  Profile.Controls[2].IsPassword := True;
  AssertProfileRejected(Profile, Profile);
end;

procedure TTestAHW52UIProfile.TestRejectsAmbiguousSearchDialog;
var
  Profile: TWindowProfile;
  DialogControl: TUIControlInfo;
begin
  Profile := CreateValidProfile;
  DialogControl := Profile.Controls[1];
  DialogControl.Handle := 300;
  SetLength(Profile.Controls, Length(Profile.Controls) + 1);
  Profile.Controls[High(Profile.Controls)] := DialogControl;
  AssertProfileRejected(Profile, Profile);
end;

procedure TTestAHW52UIProfile.TestRejectsUnexpectedDialogControl;
var
  CurrentProfile: TWindowProfile;
  ExpectedProfile: TWindowProfile;
begin
  ExpectedProfile := CreateValidProfile;
  CurrentProfile := CloneProfile(ExpectedProfile);
  SetLength(CurrentProfile.Controls, Length(CurrentProfile.Controls) + 1);
  CurrentProfile.Controls[High(CurrentProfile.Controls)] :=
    CurrentProfile.Controls[5];
  CurrentProfile.Controls[High(CurrentProfile.Controls)].Handle := 206;
  CurrentProfile.Controls[High(CurrentProfile.Controls)].Text := 'Speichern';
  CurrentProfile.Controls[High(CurrentProfile.Controls)].Ordinal := 5;
  AssertProfileRejected(CurrentProfile, ExpectedProfile);
end;

procedure TTestAHW52UIProfile.TestRejectsChangedDialogControl;
var
  CurrentProfile: TWindowProfile;
  ExpectedProfile: TWindowProfile;
begin
  ExpectedProfile := CreateValidProfile;
  CurrentProfile := CloneProfile(ExpectedProfile);
  CurrentProfile.Controls[5].Text := 'Eintrag loeschen';
  AssertProfileRejected(CurrentProfile, ExpectedProfile);
end;

procedure TTestAHW52UIProfile.TestRejectsUnexpectedTopLevelWindow;
var
  CurrentProfile: TWindowProfile;
  ExpectedProfile: TWindowProfile;
begin
  ExpectedProfile := CreateValidProfile;
  CurrentProfile := CloneProfile(ExpectedProfile);
  SetLength(CurrentProfile.Controls, Length(CurrentProfile.Controls) + 1);
  CurrentProfile.Controls[High(CurrentProfile.Controls)].Handle := 300;
  CurrentProfile.Controls[High(CurrentProfile.Controls)].OwnerHandle := MainWindowHandle;
  CurrentProfile.Controls[High(CurrentProfile.Controls)].ProcessId := TestProcessId;
  CurrentProfile.Controls[High(CurrentProfile.Controls)].ClassName := 'TForm';
  CurrentProfile.Controls[High(CurrentProfile.Controls)].Text := 'Unexpected dialog';
  CurrentProfile.Controls[High(CurrentProfile.Controls)].Visible := True;
  CurrentProfile.Controls[High(CurrentProfile.Controls)].Enabled := True;
  CurrentProfile.Controls[High(CurrentProfile.Controls)].IsTopLevel := True;
  AssertProfileRejected(CurrentProfile, ExpectedProfile);
end;

procedure TTestAHW52UIProfile.TestRoundTripsJSONProfile;
var
  OriginalProfile: TWindowProfile;
  ParsedProfile: TWindowProfile;
begin
  OriginalProfile := CreateValidProfile;
  OriginalProfile.Controls[2].Text := 'München';
  ParsedProfile := ProfileFromJSON(ProfileToJSON(OriginalProfile));

  AssertEquals(OriginalProfile.ProcessId, ParsedProfile.ProcessId);
  AssertEquals(OriginalProfile.ExecutablePath, ParsedProfile.ExecutablePath);
  AssertEquals(OriginalProfile.ExecutableSha256, ParsedProfile.ExecutableSha256);
  AssertEquals(Length(OriginalProfile.Controls), Length(ParsedProfile.Controls));
  AssertEquals(OriginalProfile.Controls[1].OwnerHandle,
    ParsedProfile.Controls[1].OwnerHandle);
  AssertEquals(OriginalProfile.Controls[1].IsTopLevel,
    ParsedProfile.Controls[1].IsTopLevel);
  AssertEquals(OriginalProfile.Controls[2].Text, ParsedProfile.Controls[2].Text);
  AssertEquals(OriginalProfile.Controls[4].Text, ParsedProfile.Controls[4].Text);
end;

procedure TTestAHW52UIProfile.TestRejectsMalformedJSONProfile;
begin
  try
    ProfileFromJSON('{"schemaVersion":1,"process":{},"windows":[]}');
    Fail('Expected incomplete process identity to be rejected.');
  except
    on E: EUIProfileError do
      CheckNotEquals('', E.Message);
  end;
end;

initialization
  RegisterTest(TTestAHW52UIProfile);

end.
