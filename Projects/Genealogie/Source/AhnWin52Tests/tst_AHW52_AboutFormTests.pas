unit tst_AHW52_AboutFormTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry, Forms;

type
  TTestAHW52AboutForm = class(TTestCase)
  private
    FCloseEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
  published
    procedure TestAboutMetadataLifecycle;
    procedure TestTimerCallbackClosesForm;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  SysUtils, Classes, Interfaces, StdCtrls, AboutForm,
  AboutFormMessageServiceIntf;

type
  TRecordingAboutFormMessageService = class(TInterfacedObject,
    IAboutFormMessageService)
  private
    FErrorCount: Integer;
    FLastError: string;
  public
    procedure ShowError(const Message: string);
    property ErrorCount: Integer read FErrorCount;
    property LastError: string read FLastError;
  end;

procedure TRecordingAboutFormMessageService.ShowError(const Message: string);
begin
  Inc(FErrorCount);
  FLastError := Message;
end;

procedure TTestAHW52AboutForm.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure AssertText(const Description, Expected, Actual: string);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected "%s", got "%s".',
      [Description, Expected, Actual]);
end;

procedure CreateSyntheticFile(const FileName: string; const ModifiedAt: TDateTime);
var
  fileStream: TFileStream;
begin
  fileStream := TFileStream.Create(FileName, fmCreate);
  fileStream.Free;
  if FileSetDate(FileName, DateTimeToFileDate(ModifiedAt)) <> 0 then
    raise EFOpenError.CreateFmt('Could not set test file date for "%s".', [FileName]);
end;

procedure AddSyntheticAboutLabels(aboutDialog: TAboutForm);
begin
  aboutDialog.Label2 := TLabel.Create(aboutDialog);
  aboutDialog.Label2.Parent := aboutDialog;
  aboutDialog.Label8 := TLabel.Create(aboutDialog);
  aboutDialog.Label8.Parent := aboutDialog;
  aboutDialog.Label9 := TLabel.Create(aboutDialog);
  aboutDialog.Label9.Parent := aboutDialog;
end;

var
  aboutDialog, missingMetadataDialog: TAboutForm;
  recordingMessageService: TRecordingAboutFormMessageService;
  messageService: IAboutFormMessageService;
  originalDirectory, testDirectory: string;
  executableDate, databaseDate: TDateTime;

procedure TTestAHW52AboutForm.TestAboutMetadataLifecycle;
begin
  originalDirectory := GetCurrentDir;
    DefaultFormatSettings.ShortDateFormat := 'dd.mm.yyyy';
    DefaultFormatSettings.DateSeparator := '.';
    testDirectory := IncludeTrailingPathDelimiter(GetTempDir(False)) +
      'AboutFormTests-' + IntToStr(GetTickCount64);
    if not CreateDir(testDirectory) then
      raise EFCreateError.CreateFmt('Could not create test directory "%s".', [testDirectory]);

    try
      if not SetCurrentDir(testDirectory) then
        raise EInOutError.CreateFmt('Could not enter test directory "%s".',
          [testDirectory]);
      executableDate := EncodeDate(2019, 1, 11) + EncodeTime(12, 0, 0, 0);
      databaseDate := EncodeDate(2024, 6, 15) + EncodeTime(9, 30, 0, 0);
      CreateSyntheticFile('AHNWIN51.exe', executableDate);
      CreateSyntheticFile('awd.db', databaseDate);

      Application.Initialize;
      aboutDialog := TAboutForm.CreateNew(nil);
      AddSyntheticAboutLabels(aboutDialog);
      try
        AboutForm.AboutDialog := aboutDialog;
        aboutDialog.ClientWidth := 321;
        aboutDialog.ClientHeight := 123;
        aboutDialog.FormCreate(aboutDialog);
        if GlobalVar_02535884 <> aboutDialog.ClientWidth then
          raise Exception.CreateFmt(
            'Expected client-width state %d, got %d.',
            [aboutDialog.ClientWidth, GlobalVar_02535884]);
        if GlobalVar_02535888 <> aboutDialog.ClientHeight then
          raise Exception.CreateFmt(
            'Expected client-height state %d, got %d.',
            [aboutDialog.ClientHeight, GlobalVar_02535888]);

        if not DeleteFile('AHNWIN51.exe') or not DeleteFile('awd.db') then
          raise EFOpenError.Create('Could not remove synthetic input files.');
        aboutDialog.FormActivate(aboutDialog);

        AssertText('Copyright caption', '© 1998-2014', aboutDialog.Label2.Caption);
        AssertText('Cached issue-date caption', '(Ausgabe vom 11.01.2019)',
          aboutDialog.Label8.Caption);
        AssertText('Cached database modification caption',
          'Letzte Bearbeitung am 15.06.2024', aboutDialog.Label9.Caption);
      finally
        AboutForm.AboutDialog := nil;
        aboutDialog.Free;
      end;

      CreateSyntheticFile('AHNWIN51.exe', executableDate);
      recordingMessageService := TRecordingAboutFormMessageService.Create;
      messageService := recordingMessageService;
      missingMetadataDialog := TAboutForm.CreateNew(nil);
      AddSyntheticAboutLabels(missingMetadataDialog);
      try
        missingMetadataDialog.MessageService := messageService;
        AboutForm.AboutDialog := missingMetadataDialog;
        missingMetadataDialog.FormCreate(missingMetadataDialog);
        missingMetadataDialog.FormActivate(missingMetadataDialog);
        if GlobalVar_02535884 <> missingMetadataDialog.ClientWidth then
          raise Exception.CreateFmt(
            'Expected client-width state %d after metadata failure, got %d.',
            [missingMetadataDialog.ClientWidth, GlobalVar_02535884]);
        if GlobalVar_02535888 <> missingMetadataDialog.ClientHeight then
          raise Exception.CreateFmt(
            'Expected client-height state %d after metadata failure, got %d.',
            [missingMetadataDialog.ClientHeight, GlobalVar_02535888]);

        if recordingMessageService.ErrorCount <> 1 then
          raise Exception.CreateFmt(
            'Expected one metadata error notification, got %d.',
            [recordingMessageService.ErrorCount]);
        if Pos('awd.db', recordingMessageService.LastError) = 0 then
          raise Exception.CreateFmt(
            'Expected the missing database filename in the error, got "%s".',
            [recordingMessageService.LastError]);
      finally
        AboutForm.AboutDialog := nil;
        missingMetadataDialog.Free;
        messageService := nil;
      end;

      if not DeleteFile('AHNWIN51.exe') then
        raise EFOpenError.Create('Could not remove the synthetic executable file.');
      recordingMessageService := TRecordingAboutFormMessageService.Create;
      messageService := recordingMessageService;
      missingMetadataDialog := TAboutForm.CreateNew(nil);
      AddSyntheticAboutLabels(missingMetadataDialog);
      try
        missingMetadataDialog.MessageService := messageService;
        AboutForm.AboutDialog := missingMetadataDialog;
        missingMetadataDialog.FormCreate(missingMetadataDialog);
        missingMetadataDialog.FormActivate(missingMetadataDialog);
        if GlobalVar_02535884 <> missingMetadataDialog.ClientWidth then
          raise Exception.CreateFmt(
            'Expected client-width state %d when the executable is missing, got %d.',
            [missingMetadataDialog.ClientWidth, GlobalVar_02535884]);
        if GlobalVar_02535888 <> missingMetadataDialog.ClientHeight then
          raise Exception.CreateFmt(
            'Expected client-height state %d when the executable is missing, got %d.',
            [missingMetadataDialog.ClientHeight, GlobalVar_02535888]);
        if recordingMessageService.ErrorCount <> 1 then
          raise Exception.CreateFmt(
            'Expected one missing-executable notification, got %d.',
            [recordingMessageService.ErrorCount]);
        if Pos('AHNWIN51.exe', recordingMessageService.LastError) = 0 then
          raise Exception.CreateFmt(
            'Expected the missing executable filename in the error, got "%s".',
            [recordingMessageService.LastError]);
      finally
        AboutForm.AboutDialog := nil;
        missingMetadataDialog.Free;
        messageService := nil;
      end;
    finally
      SetCurrentDir(originalDirectory);
      DeleteFile(IncludeTrailingPathDelimiter(testDirectory) + 'AHNWIN51.exe');
      DeleteFile(IncludeTrailingPathDelimiter(testDirectory) + 'awd.db');
      RemoveDir(testDirectory);
    end;
end;

procedure TTestAHW52AboutForm.TestTimerCallbackClosesForm;
var
  aboutDialog: TAboutForm;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  aboutDialog := TAboutForm.CreateNew(nil);
  try
    aboutDialog.OnClose := @RecordFormClose;
    aboutDialog.Timer1Timer(aboutDialog);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    aboutDialog.Free;
  end;
end;

procedure TTestAHW52AboutForm.TestUnboundCounterIncrement;
var
  aboutDialog: TAboutForm;
begin
  aboutDialog := TAboutForm.CreateNew(nil);
  try
    GlobalVar_0253588C := 41;
    aboutDialog._PROC_005C6E80(aboutDialog);
    AssertEquals('The unbound callback should increment the counter.',
      42, GlobalVar_0253588C);
  finally
    aboutDialog.Free;
  end;
end;

procedure TTestAHW52AboutForm.TestUnboundCounterDecrement;
var
  aboutDialog: TAboutForm;
begin
  aboutDialog := TAboutForm.CreateNew(nil);
  try
    GlobalVar_0253588C := 41;
    aboutDialog._PROC_005C6EB0(aboutDialog);
    AssertEquals('The unbound callback should decrement the counter.',
      40, GlobalVar_0253588C);
  finally
    aboutDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52AboutForm);

end.
