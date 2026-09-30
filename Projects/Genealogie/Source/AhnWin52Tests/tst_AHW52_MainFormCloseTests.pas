unit tst_AHW52_MainFormCloseTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52MainFormClose = class(TTestCase)
  published
    procedure TestCaseConfirmedCloseSequence;
    procedure TestCaseCancelledCloseSequence;
    procedure TestCaseActionFailureStopsSequence;
    procedure TestCaseCaptionConfigurationFile;
    procedure TestCaseNilActionsRejected;
  end;

implementation

uses
  Classes, SysUtils, MainFormCloseBehavior;

type
  TRecordingCloseActions = class(TInterfacedObject, IMainFormCloseActions)
  private
    FCalls: TStringList;
    FConfirmed: Boolean;
    FFailAt: string;
    procedure RecordCall(const Name: string);
  public
    constructor Create(const Confirmed: Boolean; const FailAt: string = '');
    destructor Destroy; override;
    procedure ActivateDataPage;
    procedure SaveCurrentPerson;
    procedure DeleteGeneratedReportFiles;
    function ConfirmApplicationExit: Boolean;
    procedure PostPendingPerson;
    procedure PostPendingMarriage;
    procedure CreateBackupWhenPersonExists;
    procedure CloseApplicationDataSets;
    procedure DeleteAuxiliaryTextFiles;
    procedure WriteCaptionConfiguration;
    procedure ClearCachedPasswords;
    procedure TerminateApplication;
    procedure CancelClose;
    property Calls: TStringList read FCalls;
  end;

constructor TRecordingCloseActions.Create(const Confirmed: Boolean;
  const FailAt: string);
begin
  inherited Create;
  FCalls := TStringList.Create;
  FConfirmed := Confirmed;
  FFailAt := FailAt;
end;

destructor TRecordingCloseActions.Destroy;
begin
  FCalls.Free;
  inherited Destroy;
end;

procedure TRecordingCloseActions.RecordCall(const Name: string);
begin
  FCalls.Add(Name);
  if Name = FFailAt then
    raise Exception.CreateFmt('Injected failure at %s.', [Name]);
end;

procedure TRecordingCloseActions.ActivateDataPage;
begin
  RecordCall('ActivateDataPage');
end;

procedure TRecordingCloseActions.SaveCurrentPerson;
begin
  RecordCall('SaveCurrentPerson');
end;

procedure TRecordingCloseActions.DeleteGeneratedReportFiles;
begin
  RecordCall('DeleteGeneratedReportFiles');
end;

function TRecordingCloseActions.ConfirmApplicationExit: Boolean;
begin
  RecordCall('ConfirmApplicationExit');
  Result := FConfirmed;
end;

procedure TRecordingCloseActions.PostPendingPerson;
begin
  RecordCall('PostPendingPerson');
end;

procedure TRecordingCloseActions.PostPendingMarriage;
begin
  RecordCall('PostPendingMarriage');
end;

procedure TRecordingCloseActions.CreateBackupWhenPersonExists;
begin
  RecordCall('CreateBackupWhenPersonExists');
end;

procedure TRecordingCloseActions.CloseApplicationDataSets;
begin
  RecordCall('CloseApplicationDataSets');
end;

procedure TRecordingCloseActions.DeleteAuxiliaryTextFiles;
begin
  RecordCall('DeleteAuxiliaryTextFiles');
end;

procedure TRecordingCloseActions.WriteCaptionConfiguration;
begin
  RecordCall('WriteCaptionConfiguration');
end;

procedure TRecordingCloseActions.ClearCachedPasswords;
begin
  RecordCall('ClearCachedPasswords');
end;

procedure TRecordingCloseActions.TerminateApplication;
begin
  RecordCall('TerminateApplication');
end;

procedure TRecordingCloseActions.CancelClose;
begin
  RecordCall('CancelClose');
end;

procedure AssertEqual(const Description: string;
  const Expected, Actual: string);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected "%s", got "%s".',
      [Description, Expected, Actual]);
end;

procedure AssertCallSequence(Actions: TRecordingCloseActions;
  const Expected: array of string);
var
  Index: Integer;
begin
  if Actions.Calls.Count <> Length(Expected) then
    raise Exception.CreateFmt('Expected %d calls, got %d.',
      [Length(Expected), Actions.Calls.Count]);

  for Index := 0 to High(Expected) do
    AssertEqual(Format('Call %d', [Index]), Expected[Index],
      Actions.Calls[Index]);
end;

procedure TestConfirmedCloseSequence;
var
  ActionsObject: TRecordingCloseActions;
  Actions: IMainFormCloseActions;
begin
  ActionsObject := TRecordingCloseActions.Create(True);
  Actions := ActionsObject;
  if not ExecuteMainFormClose(Actions) then
    raise Exception.Create('Confirmed close was rejected.');

  AssertCallSequence(ActionsObject, [
    'ActivateDataPage',
    'SaveCurrentPerson',
    'DeleteGeneratedReportFiles',
    'ConfirmApplicationExit',
    'PostPendingPerson',
    'PostPendingMarriage',
    'CreateBackupWhenPersonExists',
    'CloseApplicationDataSets',
    'DeleteAuxiliaryTextFiles',
    'WriteCaptionConfiguration',
    'ClearCachedPasswords',
    'TerminateApplication'
  ]);
  Actions := nil;
end;

procedure TestCancelledCloseSequence;
var
  ActionsObject: TRecordingCloseActions;
  Actions: IMainFormCloseActions;
begin
  ActionsObject := TRecordingCloseActions.Create(False);
  Actions := ActionsObject;
  if ExecuteMainFormClose(Actions) then
    raise Exception.Create('Cancelled close was accepted.');

  AssertCallSequence(ActionsObject, [
    'ActivateDataPage',
    'SaveCurrentPerson',
    'DeleteGeneratedReportFiles',
    'ConfirmApplicationExit',
    'CancelClose'
  ]);
  Actions := nil;
end;

procedure TestActionFailureStopsSequence;
var
  ActionsObject: TRecordingCloseActions;
  Actions: IMainFormCloseActions;
  Raised: Boolean;
begin
  ActionsObject := TRecordingCloseActions.Create(True, 'CloseApplicationDataSets');
  Actions := ActionsObject;
  Raised := False;
  try
    ExecuteMainFormClose(Actions);
  except
    on E: Exception do
      Raised := E.Message = 'Injected failure at CloseApplicationDataSets.';
  end;

  if not Raised then
    raise Exception.Create('Close action failure was not propagated.');
  AssertCallSequence(ActionsObject, [
    'ActivateDataPage',
    'SaveCurrentPerson',
    'DeleteGeneratedReportFiles',
    'ConfirmApplicationExit',
    'PostPendingPerson',
    'PostPendingMarriage',
    'CreateBackupWhenPersonExists',
    'CloseApplicationDataSets'
  ]);
  Actions := nil;
end;

procedure TestCaptionConfigurationFile;
var
  FileName: string;
  InputStream: TFileStream;
  CaptionRecord: string[50];
  Buffer: array[0..50] of Byte;
  ReadCount: Integer;
  Index: Integer;
  ExpectedByte: Byte;
begin
  FileName := GetTempFileName(GetTempDir(False), 'AFC');
  try
    WriteMainFormCaptionConfiguration(FileName, 'AHNENWIN 5.1');
    InputStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    try
      if InputStream.Size <> 51 then
        raise Exception.CreateFmt('Expected 51 config bytes, got %d.',
          [InputStream.Size]);
      ReadCount := InputStream.Read(Buffer, SizeOf(Buffer));
      if ReadCount <> SizeOf(Buffer) then
        raise Exception.CreateFmt('Expected 51 read bytes, got %d.', [ReadCount]);
    finally
      InputStream.Free;
    end;

    CaptionRecord := 'AHNENWIN 5.1';
    AssertEqual('ShortString length byte', IntToStr(Length(CaptionRecord)),
      IntToStr(Buffer[0]));
    for Index := 1 to High(Buffer) do
    begin
      ExpectedByte := 0;
      if Index <= Length(CaptionRecord) then
        ExpectedByte := Ord(CaptionRecord[Index]);
      if Buffer[Index] <> ExpectedByte then
        raise Exception.CreateFmt('Caption config byte %d does not match.',
          [Index]);
    end;

    WriteMainFormCaptionConfiguration(FileName, StringOfChar('X', 60));
    InputStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    try
      if InputStream.Size <> 51 then
        raise Exception.CreateFmt('Expected 51 truncated config bytes, got %d.',
          [InputStream.Size]);
      ReadCount := InputStream.Read(Buffer, SizeOf(Buffer));
      if (ReadCount <> SizeOf(Buffer)) or (Buffer[0] <> 50) then
        raise Exception.Create('Long caption was not truncated to 50 bytes.');
      for Index := 1 to High(Buffer) do
        if Buffer[Index] <> Ord('X') then
          raise Exception.CreateFmt('Truncated caption byte %d is incorrect.',
            [Index]);
    finally
      InputStream.Free;
    end;
  finally
    if FileExists(FileName) and not DeleteFile(FileName) then
      raise Exception.CreateFmt('Could not remove test file "%s".', [FileName]);
  end;
end;

var
  Raised: Boolean;

procedure TTestAHW52MainFormClose.TestCaseConfirmedCloseSequence;
begin
    TestConfirmedCloseSequence;
end;

procedure TTestAHW52MainFormClose.TestCaseCancelledCloseSequence;
begin
    TestCancelledCloseSequence;
end;

procedure TTestAHW52MainFormClose.TestCaseActionFailureStopsSequence;
begin
    TestActionFailureStopsSequence;
end;

procedure TTestAHW52MainFormClose.TestCaseCaptionConfigurationFile;
begin
    TestCaptionConfigurationFile;
end;

procedure TTestAHW52MainFormClose.TestCaseNilActionsRejected;
var
  rejected: Boolean;
begin
  rejected := False;
  try
    ExecuteMainFormClose(nil);
  except
    on E: EArgumentNilException do
      rejected := True;
  end;
  if not rejected then
    raise Exception.Create('Nil close actions were accepted.');
end;

initialization
  RegisterTest(TTestAHW52MainFormClose);

end.
