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
    procedure TestEnterMovesFocusAndIsConsumed;
    procedure TestNonEnterKeyIsPreserved;
  end;

implementation

uses
  SysUtils, Controls, StdCtrls, FormKeyPressBehavior, PersonSearchForm;

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
