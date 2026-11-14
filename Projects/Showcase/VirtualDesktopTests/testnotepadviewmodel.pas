unit testnotepadviewmodel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, NotepadViewModel, Services;

type
  TFakeNoteStorage = class(TInterfacedObject, INoteStorage)
  private
    FText: string;
    FSaveCount: Integer;
  public
    constructor Create(const AInitialText: string);
    function LoadText: string;
    procedure SaveText(const AText: string);
    property SaveCount: Integer read FSaveCount;
    property StoredText: string read FText;
  end;

  TNotepadViewModelTest = class(TTestCase)
  published
    procedure LoadsTextFromStorage;
    procedure UpdatingTextMarksTheViewModelDirty;
    procedure SavePersistsTextAndClearsDirtyState;
  end;

implementation

constructor TFakeNoteStorage.Create(const AInitialText: string);
begin
  FText := AInitialText;
end;

function TFakeNoteStorage.LoadText: string;
begin
  Result := FText;
end;

procedure TFakeNoteStorage.SaveText(const AText: string);
begin
  FText := AText;
  Inc(FSaveCount);
end;

procedure TNotepadViewModelTest.LoadsTextFromStorage;
var
  Storage: INoteStorage;
  ViewModel: TNotepadViewModel;
begin
  Storage := TFakeNoteStorage.Create('Existing note');
  ViewModel := TNotepadViewModel.Create(Storage);
  try
    AssertEquals('Existing note', ViewModel.Text);
    AssertFalse(ViewModel.Dirty);
  finally
    ViewModel.Free;
  end;
end;

procedure TNotepadViewModelTest.UpdatingTextMarksTheViewModelDirty;
var
  Storage: INoteStorage;
  ViewModel: TNotepadViewModel;
begin
  Storage := TFakeNoteStorage.Create('Before');
  ViewModel := TNotepadViewModel.Create(Storage);
  try
    ViewModel.UpdateText('After');

    AssertEquals('After', ViewModel.Text);
    AssertTrue(ViewModel.Dirty);
  finally
    ViewModel.Free;
  end;
end;

procedure TNotepadViewModelTest.SavePersistsTextAndClearsDirtyState;
var
  StorageObject: TFakeNoteStorage;
  Storage: INoteStorage;
  ViewModel: TNotepadViewModel;
begin
  StorageObject := TFakeNoteStorage.Create('Before');
  Storage := StorageObject;
  ViewModel := TNotepadViewModel.Create(Storage);
  try
    ViewModel.UpdateText('Saved note');
    ViewModel.Save;

    AssertFalse(ViewModel.Dirty);
    AssertEquals('Saved note', StorageObject.StoredText);
    AssertEquals(1, StorageObject.SaveCount);
  finally
    ViewModel.Free;
  end;
end;

initialization
  RegisterTest(TNotepadViewModelTest);

end.
