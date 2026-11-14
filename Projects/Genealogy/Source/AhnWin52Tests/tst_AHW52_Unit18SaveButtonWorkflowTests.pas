unit tst_AHW52_Unit18SaveButtonWorkflowTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit18SaveButtonWorkflow = class(TTestCase)
  private
    FActionOrder: string;
    FMessageText: string;
    FSaveSender: TObject;
    procedure RecordSave(Sender: TObject);
    procedure RaiseOnSave(Sender: TObject);
    procedure RecordMessage(const MessageText: string);
  published
    procedure TestSavingPrecedesExcelInstruction;
    procedure TestSaveFailurePreventsExcelInstruction;
    procedure TestFormResourceStreamsSaveButtonsAsTButton;
  end;

implementation

uses
  SysUtils, Unit18, Unit18SaveButtonWorkflow;

procedure TTestAHW52Unit18SaveButtonWorkflow.RecordSave(Sender: TObject);
begin
  FActionOrder := FActionOrder + 'S';
  FSaveSender := Sender;
end;

procedure TTestAHW52Unit18SaveButtonWorkflow.RaiseOnSave(Sender: TObject);
begin
  FActionOrder := FActionOrder + 'S';
  raise Exception.Create('save failure');
end;

procedure TTestAHW52Unit18SaveButtonWorkflow.RecordMessage(
  const MessageText: string);
begin
  FActionOrder := FActionOrder + 'M';
  FMessageText := MessageText;
end;

procedure TTestAHW52Unit18SaveButtonWorkflow.
  TestSavingPrecedesExcelInstruction;
var
  sender: TObject;
begin
  sender := TObject.Create;
  try
    FActionOrder := '';
    FMessageText := '';
    FSaveSender := nil;

    RunUnit18SaveButtonWorkflow(sender, @RecordSave, @RecordMessage);

    AssertEquals('SM', FActionOrder);
    AssertTrue('The save method receives the button event sender.',
      FSaveSender = sender);
    AssertEquals('Zum Drucken diese Datei in MS-Excel einlesen.',
      FMessageText);
  finally
    sender.Free;
  end;
end;

procedure TTestAHW52Unit18SaveButtonWorkflow.
  TestSaveFailurePreventsExcelInstruction;
var
  sender: TObject;
begin
  sender := TObject.Create;
  try
    FActionOrder := '';
    FMessageText := '';
    FSaveSender := nil;

    try
      RunUnit18SaveButtonWorkflow(sender, @RaiseOnSave, @RecordMessage);
      Fail('The save exception should propagate.');
    except
      on E: Exception do
        AssertEquals('save failure', E.Message);
    end;

    AssertEquals('S', FActionOrder);
    AssertEquals('', FMessageText);
  finally
    sender.Free;
  end;
end;

procedure TTestAHW52Unit18SaveButtonWorkflow.
  TestFormResourceStreamsSaveButtonsAsTButton;
var
  sourceForm: TForm18;
begin
  sourceForm := TForm18.Create(nil);
  try
    AssertNotNull('The streamed save button exists.', sourceForm.Button7);
    AssertNotNull('The streamed cancel button exists.', sourceForm.Button1);
    AssertTrue('The save button has its DFM/LFM click binding.',
      Assigned(sourceForm.Button7.OnClick));
  finally
    sourceForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit18SaveButtonWorkflow);

end.
