unit tst_AHW52_MainFormKeyPressTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52MainFormKeyPress = class(TTestCase)
  published
    procedure TestEnterKeyIsConsumed;
    procedure TestEscapeVirtualKeyIsRecognized;
    procedure TestEscapeSetsCancelModalResult;
    procedure TestNonEscapePreservesModalResult;
    procedure TestAlreadyFoundButtonCancelsGlobalDialogExceptVerwMode;
    procedure TestFormCreateScalesGlobalSearchFormFromScreen;
    procedure TestEnterMovesFocusAndIsConsumed;
    procedure TestNonEnterKeyIsPreserved;
  end;

implementation

uses
  SysUtils, Controls, Forms, StdCtrls, FormKeyPressBehavior,
  PersonSearchForm, Unit12;

type
  // Simulates visible focus targets without showing a test window.
  TTestPersonSearchForm = class(TPersonSearchForm)
  public
    function IsVisible: Boolean; override;
    procedure SetFocus; override;
  end;

procedure AssertKey(const Description: string; const Expected: Char;
  const Actual: Char);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected key code %d, got %d.',
      [Description, Ord(Expected), Ord(Actual)]);
end;

var
  key: Char;

function CreateSearchFormWithControls: TPersonSearchForm;
begin
  Result := TTestPersonSearchForm.CreateNew(nil);
  try
    Result.Edit1 := TEdit.Create(Result);
    Result.Edit1.Parent := Result;
    Result.Edit1.TabOrder := 0;

    Result.Edit2 := TEdit.Create(Result);
    Result.Edit2.Parent := Result;
    Result.Edit2.TabOrder := 1;

    Result.Button1 := TButton.Create(Result);
    Result.Button1.Parent := Result;
    Result.Button1.TabOrder := 2;
  except
    Result.Free;
    raise;
  end;
end;

function TTestPersonSearchForm.IsVisible: Boolean;
begin
  Result := True;
end;

procedure TTestPersonSearchForm.SetFocus;
begin
end;

procedure TTestAHW52MainFormKeyPress.TestEnterKeyIsConsumed;
begin
  key := #13;
    if not ConsumeEnterKeyForNavigation(key) then
      raise Exception.Create('Enter was not accepted for focus navigation.');
    AssertKey('Consumed Enter', #0, key);

    key := 'A';
    if ConsumeEnterKeyForNavigation(key) then
      raise Exception.Create('A non-Enter key requested focus navigation.');
    AssertKey('Preserved non-Enter key', 'A', key);

    key := #27;
    if ConsumeEnterKeyForNavigation(key) then
      raise Exception.Create('Escape requested focus navigation.');
    AssertKey('Preserved Escape key', #27, key);
end;

procedure TTestAHW52MainFormKeyPress.TestEscapeVirtualKeyIsRecognized;
begin
  if not IsEscapeKey($1B) then
    raise Exception.Create('Escape virtual key was not recognized.');
  if IsEscapeKey($1A) then
    raise Exception.Create('A non-Escape virtual key was recognized as Escape.');
end;

procedure TTestAHW52MainFormKeyPress.TestEscapeSetsCancelModalResult;
var
  searchForm: TPersonSearchForm;
  key: Word;
begin
  searchForm := TPersonSearchForm.CreateNew(nil);
  try
    key := $1B;
    searchForm.Edit1KeyDown(searchForm.Edit1, key, []);
    if searchForm.ModalResult <> mrCancel then
      raise Exception.Create('Escape in the first edit did not cancel the dialog.');

    searchForm.ModalResult := mrNone;
    key := $1B;
    searchForm.Edit2KeyDown(searchForm.Edit2, key, []);
    if searchForm.ModalResult <> mrCancel then
      raise Exception.Create('Escape in the second edit did not cancel the dialog.');
  finally
    searchForm.Free;
  end;
end;

procedure TTestAHW52MainFormKeyPress.TestNonEscapePreservesModalResult;
var
  searchForm: TPersonSearchForm;
  key: Word;
begin
  searchForm := TPersonSearchForm.CreateNew(nil);
  try
    key := $1A;
    searchForm.Edit1KeyDown(searchForm.Edit1, key, []);
    if searchForm.ModalResult <> mrNone then
      raise Exception.Create('A non-Escape key in the first edit changed the modal result.');

    key := $1A;
    searchForm.Edit2KeyDown(searchForm.Edit2, key, []);
    if searchForm.ModalResult <> mrNone then
      raise Exception.Create('A non-Escape key in the second edit changed the modal result.');
  finally
    searchForm.Free;
  end;
end;

procedure TTestAHW52MainFormKeyPress.
  TestAlreadyFoundButtonCancelsGlobalDialogExceptVerwMode;
var
  receiverForm: TPersonSearchForm;
  globalDialog: TPersonSearchForm;
  previousDialog: TPersonSearchForm;
  previousMode: string;
begin
  Application.Initialize;
  previousDialog := PersonSearchDialog;
  previousMode := Unit12.GlobalVar_0253592C;
  receiverForm := nil;
  globalDialog := nil;
  try
    receiverForm := TPersonSearchForm.CreateNew(nil);
    globalDialog := TPersonSearchForm.CreateNew(nil);
    PersonSearchDialog := globalDialog;
    Unit12.GlobalVar_0253592C := 'Sonstiges';
    receiverForm.BitBtn2Click(nil);

    AssertEquals('Non-Verw mode cancels the global search dialog.',
      mrCancel, globalDialog.ModalResult);
    AssertEquals('The event receiver is not the listing-identified target.',
      mrNone, receiverForm.ModalResult);

    globalDialog.ModalResult := mrOK;
    Unit12.GlobalVar_0253592C := 'Verw';
    receiverForm.BitBtn2Click(nil);

    AssertEquals('Exact Verw mode leaves the global modal result unchanged.',
      mrOK, globalDialog.ModalResult);
  finally
    PersonSearchDialog := previousDialog;
    Unit12.GlobalVar_0253592C := previousMode;
    globalDialog.Free;
    receiverForm.Free;
  end;
end;

procedure ApplyExpectedScreenScale(searchForm: TPersonSearchForm;
  screenWidth, screenHeight: Integer);
begin
  if (screenHeight > 768) or (screenWidth > 1024) then
  begin
    searchForm.Height := searchForm.Height * screenHeight div 768;
    searchForm.Width := searchForm.Width * screenHeight div 768;
    searchForm.ScaleBy(screenHeight, 768);
  end;

  if (screenHeight < 768) or (screenWidth < 1024) then
  begin
    searchForm.Height := searchForm.Height * screenHeight div 768;
    searchForm.Width := searchForm.Width * screenHeight div 768;
    searchForm.ScaleBy(screenWidth, 1024);
  end;
end;

procedure TTestAHW52MainFormKeyPress.
  TestFormCreateScalesGlobalSearchFormFromScreen;
var
  previousDialog: TPersonSearchForm;
  receiverForm: TPersonSearchForm;
  globalDialog: TPersonSearchForm;
  expectedDialog: TPersonSearchForm;
  receiverWidth: Integer;
  receiverHeight: Integer;
begin
  Application.Initialize;
  previousDialog := PersonSearchDialog;
  receiverForm := nil;
  globalDialog := nil;
  expectedDialog := nil;
  try
    receiverForm := TPersonSearchForm.CreateNew(nil);
    globalDialog := TPersonSearchForm.CreateNew(nil);
    expectedDialog := TPersonSearchForm.CreateNew(nil);

    receiverForm.Scaled := False;
    receiverForm.SetBounds(0, 0, 320, 240);
    receiverWidth := receiverForm.Width;
    receiverHeight := receiverForm.Height;
    globalDialog.Scaled := True;
    globalDialog.SetBounds(0, 0, 640, 480);
    expectedDialog.Scaled := True;
    expectedDialog.SetBounds(0, 0, 640, 480);
    PersonSearchDialog := globalDialog;

    ApplyExpectedScreenScale(expectedDialog, Screen.Width, Screen.Height);
    receiverForm.FormCreate(receiverForm);

    AssertTrue('Form creation enables scaling on the global search dialog.',
      globalDialog.Scaled);
    AssertEquals('The global search form receives screen-scaled width.',
      expectedDialog.Width, globalDialog.Width);
    AssertEquals('The global search form receives screen-scaled height.',
      expectedDialog.Height, globalDialog.Height);
    AssertFalse('The event receiver is not the scaled global target.',
      receiverForm.Scaled);
    AssertEquals('The receiver width remains unchanged.',
      receiverWidth, receiverForm.Width);
    AssertEquals('The receiver height remains unchanged.',
      receiverHeight, receiverForm.Height);
  finally
    PersonSearchDialog := previousDialog;
    expectedDialog.Free;
    globalDialog.Free;
    receiverForm.Free;
  end;
end;

procedure TTestAHW52MainFormKeyPress.TestEnterMovesFocusAndIsConsumed;
var
  searchForm: TPersonSearchForm;
  key: Char;
begin
  searchForm := CreateSearchFormWithControls;
  try
    searchForm.ActiveControl := searchForm.Edit1;
    key := #13;
    searchForm.Edit1KeyPress(searchForm.Edit1, key);
    AssertKey('Enter after first edit', #0, key);
    if searchForm.ActiveControl <> searchForm.Edit2 then
      raise Exception.Create('Enter did not advance from the first edit.');

    key := #13;
    searchForm.Edit2KeyPress(searchForm.Edit2, key);
    AssertKey('Enter after second edit', #0, key);
    if searchForm.ActiveControl <> searchForm.Button1 then
      raise Exception.Create('Enter did not advance from the second edit.');
  finally
    searchForm.Free;
  end;
end;

procedure TTestAHW52MainFormKeyPress.TestNonEnterKeyIsPreserved;
var
  searchForm: TPersonSearchForm;
  key: Char;
begin
  searchForm := CreateSearchFormWithControls;
  try
    searchForm.ActiveControl := searchForm.Edit2;
    key := 'A';
    searchForm.Edit2KeyPress(searchForm.Edit2, key);
    AssertKey('Non-Enter after second edit', 'A', key);
    if searchForm.ActiveControl <> searchForm.Edit2 then
      raise Exception.Create('A non-Enter key changed the active control.');
  finally
    searchForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52MainFormKeyPress);

end.
