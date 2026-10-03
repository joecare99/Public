unit tst_AHW52_Unit10BrowserCommandTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit10BrowserCommands = class(TTestCase)
  published
    procedure TestBitBtn1DispatchesPrintCommand;
    procedure TestSpeedButton2DispatchesPrintCommand;
    procedure TestBitBtn2DispatchesSaveAsWhenDialogAccepted;
    procedure TestBitBtn2DoesNotDispatchWhenDialogCancelled;
    procedure TestSpeedButton3DispatchesSaveAsCommand;
    procedure TestDefaultProviderRejectsBrowserCommandExplicitly;
  end;

implementation

uses
  Classes, Dialogs, Forms, SysUtils, Unit10, BrowserCommandCompat;

type
  TRecordedBrowserCommand = record
    CommandId: Integer;
    CommandOptions: Integer;
  end;

  TRecordingBrowserCommandProvider = class(TInterfacedObject,
    IBrowserCommandProvider)
  public
    Commands: array of TRecordedBrowserCommand;
    procedure ExecuteBrowserCommand(CommandId, CommandOptions: Integer);
  end;

  TFixedSaveDialog = class(TSaveDialog)
  public
    Accepted: Boolean;
    function Execute: Boolean; override;
  end;

procedure TRecordingBrowserCommandProvider.ExecuteBrowserCommand(
  CommandId, CommandOptions: Integer);
var
  commandIndex: Integer;
begin
  commandIndex := Length(Commands);
  SetLength(Commands, commandIndex + 1);
  Commands[commandIndex].CommandId := CommandId;
  Commands[commandIndex].CommandOptions := CommandOptions;
end;

function TFixedSaveDialog.Execute: Boolean;
begin
  Result := Accepted;
end;

procedure AssertRecordedCommand(const Provider: TRecordingBrowserCommandProvider;
  ExpectedCommandId: Integer);
begin
  if Length(Provider.Commands) <> 1 then
    raise Exception.CreateFmt('Expected one command, got %d.',
      [Length(Provider.Commands)]);
  if Provider.Commands[0].CommandId <> ExpectedCommandId then
    raise Exception.CreateFmt('Expected command %d, got %d.',
      [ExpectedCommandId, Provider.Commands[0].CommandId]);
  if Provider.Commands[0].CommandOptions <> BrowserCommandOptionDoDefault then
    raise Exception.CreateFmt('Expected command options %d, got %d.',
      [BrowserCommandOptionDoDefault, Provider.Commands[0].CommandOptions]);
end;

procedure TTestAHW52Unit10BrowserCommands.TestBitBtn1DispatchesPrintCommand;
var
  browserForm: TForm10;
  recorder: TRecordingBrowserCommandProvider;
begin
  browserForm := TForm10.CreateNew(nil);
  recorder := TRecordingBrowserCommandProvider.Create;
  browserForm.BrowserCommandProvider := recorder;
  try
    browserForm.BitBtn1Click(nil);
    AssertRecordedCommand(recorder, BrowserCommandIdPrint);
  finally
    browserForm.Free;
  end;
end;

procedure TTestAHW52Unit10BrowserCommands.
  TestSpeedButton2DispatchesPrintCommand;
var
  browserForm: TForm10;
  recorder: TRecordingBrowserCommandProvider;
begin
  browserForm := TForm10.CreateNew(nil);
  recorder := TRecordingBrowserCommandProvider.Create;
  browserForm.BrowserCommandProvider := recorder;
  try
    browserForm.SpeedButton2Click(nil);
    AssertRecordedCommand(recorder, BrowserCommandIdPrint);
  finally
    browserForm.Free;
  end;
end;

procedure TTestAHW52Unit10BrowserCommands.
  TestBitBtn2DispatchesSaveAsWhenDialogAccepted;
var
  browserForm: TForm10;
  recorder: TRecordingBrowserCommandProvider;
  saveDialog: TFixedSaveDialog;
begin
  browserForm := TForm10.CreateNew(nil);
  recorder := TRecordingBrowserCommandProvider.Create;
  saveDialog := TFixedSaveDialog.Create(browserForm);
  saveDialog.Accepted := True;
  browserForm.BrowserCommandProvider := recorder;
  browserForm.SaveDialog1 := saveDialog;
  try
    browserForm.BitBtn2Click(nil);
    AssertRecordedCommand(recorder, BrowserCommandIdSaveAs);
  finally
    browserForm.Free;
  end;
end;

procedure TTestAHW52Unit10BrowserCommands.
  TestBitBtn2DoesNotDispatchWhenDialogCancelled;
var
  browserForm: TForm10;
  recorder: TRecordingBrowserCommandProvider;
  saveDialog: TFixedSaveDialog;
begin
  browserForm := TForm10.CreateNew(nil);
  recorder := TRecordingBrowserCommandProvider.Create;
  saveDialog := TFixedSaveDialog.Create(browserForm);
  saveDialog.Accepted := False;
  browserForm.BrowserCommandProvider := recorder;
  browserForm.SaveDialog1 := saveDialog;
  try
    browserForm.BitBtn2Click(nil);
    AssertEquals(0, Length(recorder.Commands));
  finally
    browserForm.Free;
  end;
end;

procedure TTestAHW52Unit10BrowserCommands.
  TestSpeedButton3DispatchesSaveAsCommand;
var
  browserForm: TForm10;
  recorder: TRecordingBrowserCommandProvider;
begin
  browserForm := TForm10.CreateNew(nil);
  recorder := TRecordingBrowserCommandProvider.Create;
  browserForm.BrowserCommandProvider := recorder;
  try
    browserForm.SpeedButton3Click(nil);
    AssertRecordedCommand(recorder, BrowserCommandIdSaveAs);
  finally
    browserForm.Free;
  end;
end;

procedure TTestAHW52Unit10BrowserCommands.
  TestDefaultProviderRejectsBrowserCommandExplicitly;
var
  browserForm: TForm10;
  rejected: Boolean;
begin
  browserForm := TForm10.CreateNew(nil);
  try
    rejected := False;
    try
      browserForm.SpeedButton2Click(nil);
    except
      on E: EBrowserCommandCompatibilityUnsupported do
      begin
        rejected := True;
        AssertEquals(BrowserCommandIdPrint, E.CommandId);
        AssertEquals(BrowserCommandOptionDoDefault, E.CommandOptions);
        AssertEquals('TWebBrowser.ExecWB(6, 0)', E.Operation);
      end;
    end;

    AssertTrue('The default provider must reject unported commands.', rejected);
  finally
    browserForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit10BrowserCommands);

end.
