unit tst_AHW52_PersonEntryChoiceTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52PersonEntryChoice = class(TTestCase)
  published
    procedure TestChoiceDialogContract;
  end;

implementation

uses
  SysUtils, Classes, Interfaces, Forms, PersonEntryChoiceForm;

type
  TCloseQueryRecorder = class
  private
    FCount: Integer;
  public
    procedure RecordCloseQuery(Sender: TObject; var CanClose: Boolean);
    property Count: Integer read FCount;
  end;

var
  choiceForm: TPersonEntryChoiceForm;
  closeQueryRecorder: TCloseQueryRecorder;

procedure AssertModalResult(const Description: string; Expected, Actual: Integer);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected modal result %d, got %d.',
      [Description, Expected, Actual]);
end;

procedure AssertUnchecked(const Description: string; Checked: Boolean);
begin
  if Checked then
    raise Exception.CreateFmt('%s should be unchecked after activation.',
      [Description]);
end;

procedure AssertChecked(const Description: string; Checked: Boolean);
begin
  if not Checked then
    raise Exception.CreateFmt('%s should remain checked after selection.',
      [Description]);
end;

procedure AssertEventBound(const Description: string; Event: TNotifyEvent);
begin
  if not Assigned(Event) then
    raise Exception.CreateFmt('%s has no click handler.', [Description]);
end;

procedure TCloseQueryRecorder.RecordCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Inc(FCount);
  CanClose := False;
end;

procedure TTestAHW52PersonEntryChoice.TestChoiceDialogContract;
begin
  Application.Initialize;
    closeQueryRecorder := TCloseQueryRecorder.Create;
    try
      choiceForm := TPersonEntryChoiceForm.Create(nil);
      try
        AssertEventBound('Create-new option',
          choiceForm.CreateNewRadioButton.OnClick);
        choiceForm.CreateNewRadioButton.Checked := True;
        choiceForm.CreateNewRadioButtonClick(choiceForm.CreateNewRadioButton);
        AssertModalResult('Create-new choice', 1, choiceForm.ModalResult);
        AssertChecked('Create-new option after modal selection',
          choiceForm.CreateNewRadioButton.Checked);

        choiceForm.ModalResult := 0;
        AssertEventBound('Select-existing option',
          choiceForm.SelectExistingRadioButton.OnClick);
        choiceForm.SelectExistingRadioButton.Checked := True;
        choiceForm.SelectExistingRadioButtonClick(
          choiceForm.SelectExistingRadioButton);
        AssertModalResult('Select-existing choice', 2, choiceForm.ModalResult);
        AssertChecked('Select-existing option after modal selection',
          choiceForm.SelectExistingRadioButton.Checked);
        AssertUnchecked('Create-new option after selecting existing',
          choiceForm.CreateNewRadioButton.Checked);

        choiceForm.ModalResult := 0;
        choiceForm.CancelRadioButton.Checked := True;
        choiceForm.OnCloseQuery := @closeQueryRecorder.RecordCloseQuery;
        AssertEventBound('Cancel option', choiceForm.CancelRadioButton.OnClick);
        choiceForm.CancelRadioButtonClick(choiceForm.CancelRadioButton);
        if closeQueryRecorder.Count <> 1 then
          raise Exception.CreateFmt('Expected one close query, got %d.',
            [closeQueryRecorder.Count]);
        AssertChecked('Cancel option after closing',
          choiceForm.CancelRadioButton.Checked);
        AssertUnchecked('Create-new option after canceling',
          choiceForm.CreateNewRadioButton.Checked);
        AssertUnchecked('Select-existing option after canceling',
          choiceForm.SelectExistingRadioButton.Checked);

        choiceForm.CreateNewRadioButton.Checked := True;
        choiceForm.SelectExistingRadioButton.Checked := True;
        choiceForm.CancelRadioButton.Checked := True;
        choiceForm.FormActivate(choiceForm);
        AssertUnchecked('Create-new option',
          choiceForm.CreateNewRadioButton.Checked);
        AssertUnchecked('Select-existing option',
          choiceForm.SelectExistingRadioButton.Checked);
        AssertUnchecked('Cancel option', choiceForm.CancelRadioButton.Checked);
      finally
        choiceForm.Free;
      end;
    finally
      closeQueryRecorder.Free;
    end;
end;

initialization
  RegisterTest(TTestAHW52PersonEntryChoice);

end.
