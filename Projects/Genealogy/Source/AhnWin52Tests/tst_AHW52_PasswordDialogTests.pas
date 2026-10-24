unit tst_AHW52_PasswordDialogTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52PasswordDialog = class(TTestCase)
  published
    procedure TestEditChangeUpdatesButtonStates;
    procedure TestAddButtonDelegatesPasswordAndResetsEdit;
    procedure TestRemoveButtonDelegatesPasswordAndResetsEdit;
    procedure TestRemoveAllDelegatesAndFocusesEdit;
    procedure TestOKButtonDelegatesWithoutResettingEdit;
    procedure TestSessionExceptionPreservesEditText;
    procedure TestMissingSessionRaisesExplicitError;
  end;

implementation

uses
  AHW52PasswordDialog, AHW52PasswordSessionIntf, Classes, Forms, StdCtrls,
  SysUtils;

type
  EPasswordSessionTestFailure = class(Exception);

  TRecordingPasswordSession = class(TInterfacedObject,
    IAHW52PasswordSession)
  public
    AddCallCount: Integer;
    RemoveCallCount: Integer;
    RemoveAllCallCount: Integer;
    AddedPasswords: TStringList;
    RemovedPasswords: TStringList;
    RaiseOnRemove: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure AddPassword(const Password: string);
    procedure RemovePassword(const Password: string);
    procedure RemoveAllPasswords;
  end;

procedure InitializeDialog(passwordDialog: TPasswordDialog;
  const passwordSession: IAHW52PasswordSession);
begin
  passwordDialog.Edit := TEdit.Create(passwordDialog);
  passwordDialog.Edit.Parent := passwordDialog;
  passwordDialog.Edit.TabStop := True;
  passwordDialog.AddButton := TButton.Create(passwordDialog);
  passwordDialog.AddButton.Parent := passwordDialog;
  passwordDialog.RemoveButton := TButton.Create(passwordDialog);
  passwordDialog.RemoveButton.Parent := passwordDialog;
  passwordDialog.RemoveAllButton := TButton.Create(passwordDialog);
  passwordDialog.RemoveAllButton.Parent := passwordDialog;
  passwordDialog.OKButton := TButton.Create(passwordDialog);
  passwordDialog.OKButton.Parent := passwordDialog;
  passwordDialog.PasswordSession := passwordSession;
end;

constructor TRecordingPasswordSession.Create;
begin
  inherited Create;
  AddedPasswords := TStringList.Create;
  RemovedPasswords := TStringList.Create;
end;

destructor TRecordingPasswordSession.Destroy;
begin
  RemovedPasswords.Free;
  AddedPasswords.Free;
  inherited Destroy;
end;

procedure TRecordingPasswordSession.AddPassword(const Password: string);
begin
  Inc(AddCallCount);
  AddedPasswords.Add(Password);
end;

procedure TRecordingPasswordSession.RemovePassword(const Password: string);
begin
  Inc(RemoveCallCount);
  RemovedPasswords.Add(Password);
  if RaiseOnRemove then
    raise EPasswordSessionTestFailure.Create('Synthetic session failure.');
end;

procedure TRecordingPasswordSession.RemoveAllPasswords;
begin
  Inc(RemoveAllCallCount);
end;

procedure TTestAHW52PasswordDialog.TestEditChangeUpdatesButtonStates;
var
  passwordDialog: TPasswordDialog;
begin
  Application.Initialize;
  passwordDialog := TPasswordDialog.CreateNew(nil);
  try
    passwordDialog.Edit := TEdit.Create(passwordDialog);
    passwordDialog.AddButton := TButton.Create(passwordDialog);
    passwordDialog.RemoveButton := TButton.Create(passwordDialog);
    passwordDialog.OKButton := TButton.Create(passwordDialog);

    passwordDialog.Edit.Text := '';
    passwordDialog.EditChange(nil);
    AssertFalse('An empty password disables AddButton.',
      passwordDialog.AddButton.Enabled);
    AssertFalse('An empty password disables RemoveButton.',
      passwordDialog.RemoveButton.Enabled);
    AssertFalse('The default state disables OKButton.',
      passwordDialog.OKButton.Enabled);

    passwordDialog.Edit.Text := 'synthetic-password';
    passwordDialog.EditChange(nil);
    AssertTrue('A password enables AddButton.',
      passwordDialog.AddButton.Enabled);
    AssertTrue('A password enables RemoveButton.',
      passwordDialog.RemoveButton.Enabled);
    AssertTrue('A password enables OKButton.',
      passwordDialog.OKButton.Enabled);

    passwordDialog.Edit.Text := '';
    passwordDialog.EditChange(nil);
    AssertFalse('Clearing the password disables AddButton.',
      passwordDialog.AddButton.Enabled);
    AssertFalse('Clearing the password disables RemoveButton.',
      passwordDialog.RemoveButton.Enabled);
    AssertFalse('The zero dialog state disables OKButton again.',
      passwordDialog.OKButton.Enabled);
  finally
    passwordDialog.Free;
  end;
end;

procedure TTestAHW52PasswordDialog.
  TestAddButtonDelegatesPasswordAndResetsEdit;
var
  passwordDialog: TPasswordDialog;
  sessionObject: TRecordingPasswordSession;
  passwordSession: IAHW52PasswordSession;
begin
  Application.Initialize;
  sessionObject := TRecordingPasswordSession.Create;
  passwordSession := sessionObject;
  passwordDialog := TPasswordDialog.CreateNew(nil);
  try
    InitializeDialog(passwordDialog, passwordSession);
    passwordDialog.Edit.Text := 'synthetic-add';
    passwordDialog.Show;

    passwordDialog.AddButtonClick(nil);
    passwordDialog.EditChange(nil);

    AssertEquals(1, sessionObject.AddCallCount);
    AssertEquals('synthetic-add', sessionObject.AddedPasswords[0]);
    AssertEquals('', passwordDialog.Edit.Text);
    AssertFalse(passwordDialog.AddButton.Enabled);
    AssertFalse(passwordDialog.RemoveButton.Enabled);
    AssertTrue(passwordDialog.OKButton.Enabled);
    AssertTrue('The edit control receives focus.',
      passwordDialog.ActiveControl = passwordDialog.Edit);
  finally
    passwordDialog.Free;
    passwordSession := nil;
  end;
end;

procedure TTestAHW52PasswordDialog.
  TestRemoveButtonDelegatesPasswordAndResetsEdit;
var
  passwordDialog: TPasswordDialog;
  sessionObject: TRecordingPasswordSession;
  passwordSession: IAHW52PasswordSession;
begin
  Application.Initialize;
  sessionObject := TRecordingPasswordSession.Create;
  passwordSession := sessionObject;
  passwordDialog := TPasswordDialog.CreateNew(nil);
  try
    InitializeDialog(passwordDialog, passwordSession);
    passwordDialog.Edit.Text := 'synthetic-absent-password';
    passwordDialog.Show;

    passwordDialog.RemoveButtonClick(nil);

    AssertEquals(1, sessionObject.RemoveCallCount);
    AssertEquals('synthetic-absent-password',
      sessionObject.RemovedPasswords[0]);
    AssertEquals('', passwordDialog.Edit.Text);
    AssertTrue('The edit control receives focus.',
      passwordDialog.ActiveControl = passwordDialog.Edit);
  finally
    passwordDialog.Free;
    passwordSession := nil;
  end;
end;

procedure TTestAHW52PasswordDialog.TestRemoveAllDelegatesAndFocusesEdit;
var
  passwordDialog: TPasswordDialog;
  sessionObject: TRecordingPasswordSession;
  passwordSession: IAHW52PasswordSession;
begin
  Application.Initialize;
  sessionObject := TRecordingPasswordSession.Create;
  passwordSession := sessionObject;
  passwordDialog := TPasswordDialog.CreateNew(nil);
  try
    InitializeDialog(passwordDialog, passwordSession);
    passwordDialog.Show;

    passwordDialog.RemoveAllButtonClick(nil);

    AssertEquals(1, sessionObject.RemoveAllCallCount);
    AssertTrue('The edit control receives focus.',
      passwordDialog.ActiveControl = passwordDialog.Edit);
  finally
    passwordDialog.Free;
    passwordSession := nil;
  end;
end;

procedure TTestAHW52PasswordDialog.
  TestOKButtonDelegatesWithoutResettingEdit;
var
  passwordDialog: TPasswordDialog;
  sessionObject: TRecordingPasswordSession;
  passwordSession: IAHW52PasswordSession;
begin
  Application.Initialize;
  sessionObject := TRecordingPasswordSession.Create;
  passwordSession := sessionObject;
  passwordDialog := TPasswordDialog.CreateNew(nil);
  try
    InitializeDialog(passwordDialog, passwordSession);
    passwordDialog.Edit.Text := 'synthetic-confirm';

    passwordDialog.OKButtonClick(nil);

    AssertEquals(1, sessionObject.AddCallCount);
    AssertEquals('synthetic-confirm', sessionObject.AddedPasswords[0]);
    AssertEquals('The OK handler leaves the edit text intact.',
      'synthetic-confirm', passwordDialog.Edit.Text);
  finally
    passwordDialog.Free;
    passwordSession := nil;
  end;
end;

procedure TTestAHW52PasswordDialog.TestSessionExceptionPreservesEditText;
var
  passwordDialog: TPasswordDialog;
  sessionObject: TRecordingPasswordSession;
  passwordSession: IAHW52PasswordSession;
  exceptionRaised: Boolean;
begin
  Application.Initialize;
  sessionObject := TRecordingPasswordSession.Create;
  sessionObject.RaiseOnRemove := True;
  passwordSession := sessionObject;
  passwordDialog := TPasswordDialog.CreateNew(nil);
  try
    InitializeDialog(passwordDialog, passwordSession);
    passwordDialog.Edit.Text := 'synthetic-remove-failure';
    exceptionRaised := False;

    try
      passwordDialog.RemoveButtonClick(nil);
    except
      on EPasswordSessionTestFailure do
        exceptionRaised := True;
    end;

    AssertTrue('The session exception is propagated.', exceptionRaised);
    AssertEquals('The listing clears the edit only after successful removal.',
      'synthetic-remove-failure', passwordDialog.Edit.Text);
  finally
    passwordDialog.Free;
    passwordSession := nil;
  end;
end;

procedure TTestAHW52PasswordDialog.TestMissingSessionRaisesExplicitError;
var
  passwordDialog: TPasswordDialog;
  exceptionRaised: Boolean;
begin
  Application.Initialize;
  passwordDialog := TPasswordDialog.CreateNew(nil);
  try
    passwordDialog.Edit := TEdit.Create(passwordDialog);
    passwordDialog.Edit.Text := 'synthetic-unconfigured';
    exceptionRaised := False;

    try
      passwordDialog.RemoveButtonClick(nil);
    except
      on EInvalidOpException do
        exceptionRaised := True;
    end;

    AssertTrue('A missing session raises a named error.', exceptionRaised);
    AssertEquals('A missing session does not clear the edit.',
      'synthetic-unconfigured', passwordDialog.Edit.Text);
  finally
    passwordDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PasswordDialog);

end.
