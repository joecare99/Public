unit tst_AHW52_ReportLifecycleContractTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52ReportLifecycleContract = class(TTestCase)
  published
    procedure TestRequestPreservesReportIdentityAndCaption;
    procedure TestRejectsBlankReportIdentity;
    procedure TestRejectsBlankReportKind;
    procedure TestPreparationReceivesCallerOwnedSource;
    procedure TestPreparationRejectsMissingSource;
    procedure TestPreparationRejectsMissingPreparer;
    procedure TestPreparationRejectsNilPreparedReport;
    procedure TestPreparationRejectsWrongReportIdentity;
    procedure TestOutputRejectsUnpreparedReport;
    procedure TestOutputRejectsMissingSink;
    procedure TestOutputDispatchesSupportedCapabilityOnly;
    procedure TestOutputRejectsCapabilityNotProducedByReport;
    procedure TestOutputDoesNotFallbackToAnotherCapability;
    procedure TestOutputSinkFailurePropagates;
    procedure TestPreparationFailurePropagates;
  end;

implementation

uses
  SysUtils, ReportLifecycleContract;

type
  TSyntheticReportSource = class(TInterfacedObject, IReportSourceContext)
  end;

  TSyntheticPreparedReport = class(TInterfacedObject, IPreparedReport)
  private
    FReportId: string;
    FCapabilities: TReportOutputCapabilities;
  public
    constructor Create(const AReportId: string;
      const ACapabilities: TReportOutputCapabilities);
    function GetReportId: string;
    function GetCapabilities: TReportOutputCapabilities;
  end;

  TRecordingReportPreparer = class(TInterfacedObject, IReportPreparer)
  private
    FReport: IPreparedReport;
    FReceivedRequest: TReportRequest;
    FReceivedSource: IReportSourceContext;
    FFail: Boolean;
  public
    function Prepare(const Request: TReportRequest;
      const Source: IReportSourceContext): IPreparedReport;
    property Report: IPreparedReport read FReport write FReport;
    property ReceivedRequest: TReportRequest read FReceivedRequest;
    property ReceivedSource: IReportSourceContext read FReceivedSource;
    property Fail: Boolean read FFail write FFail;
  end;

  TRecordingReportSink = class(TInterfacedObject, IReportOutputSink)
  private
    FCapability: TReportOutputCapability;
    FCallCount: Integer;
    FReceivedReport: IPreparedReport;
    FFail: Boolean;
  public
    constructor Create(const ACapability: TReportOutputCapability);
    function GetCapability: TReportOutputCapability;
    procedure Execute(const Report: IPreparedReport);
    property CallCount: Integer read FCallCount;
    property ReceivedReport: IPreparedReport read FReceivedReport;
    property Fail: Boolean read FFail write FFail;
  end;

  EInjectedReportLifecycleFailure = class(Exception);

constructor TSyntheticPreparedReport.Create(const AReportId: string;
  const ACapabilities: TReportOutputCapabilities);
begin
  inherited Create;
  FReportId := AReportId;
  FCapabilities := ACapabilities;
end;

function TSyntheticPreparedReport.GetReportId: string;
begin
  Result := FReportId;
end;

function TSyntheticPreparedReport.GetCapabilities:
  TReportOutputCapabilities;
begin
  Result := FCapabilities;
end;

function TRecordingReportPreparer.Prepare(const Request: TReportRequest;
  const Source: IReportSourceContext): IPreparedReport;
begin
  if FFail then
    raise EInjectedReportLifecycleFailure.Create(
      'Injected report preparation failure.');
  FReceivedRequest := Request;
  FReceivedSource := Source;
  Result := FReport;
end;

constructor TRecordingReportSink.Create(
  const ACapability: TReportOutputCapability);
begin
  inherited Create;
  FCapability := ACapability;
end;

function TRecordingReportSink.GetCapability: TReportOutputCapability;
begin
  Result := FCapability;
end;

procedure TRecordingReportSink.Execute(const Report: IPreparedReport);
begin
  if FFail then
    raise EReportEngineFailure.Create(
      'Injected report output failure.');
  Inc(FCallCount);
  FReceivedReport := Report;
end;

function CreateSyntheticRequest: TReportRequest;
begin
  Result := CreateReportRequest('unit23-foko', 'FOKO', 'Synthetic report');
end;

procedure TTestAHW52ReportLifecycleContract.
  TestRequestPreservesReportIdentityAndCaption;
var
  Request: TReportRequest;
begin
  Request := CreateSyntheticRequest;
  AssertEquals('unit23-foko', Request.ReportId);
  AssertEquals('FOKO', Request.ReportKind);
  AssertEquals('Synthetic report', Request.Caption);
end;

procedure TTestAHW52ReportLifecycleContract.TestRejectsBlankReportIdentity;
begin
  try
    CreateReportRequest(' ', 'FOKO', '');
    Fail('A blank report identity must be rejected.');
  except
    on E: EReportRequestInvalid do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52ReportLifecycleContract.TestRejectsBlankReportKind;
begin
  try
    CreateReportRequest('report-1', #9, '');
    Fail('A blank report kind must be rejected.');
  except
    on E: EReportRequestInvalid do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52ReportLifecycleContract.
  TestPreparationReceivesCallerOwnedSource;
var
  Request: TReportRequest;
  SourceObject: TSyntheticReportSource;
  Source: IReportSourceContext;
  PreparerObject: TRecordingReportPreparer;
  Preparer: IReportPreparer;
  PreparedObject: TSyntheticPreparedReport;
  Prepared: IPreparedReport;
  ReturnedReport: IPreparedReport;
begin
  Request := CreateSyntheticRequest;
  SourceObject := TSyntheticReportSource.Create;
  Source := SourceObject;
  PreparerObject := TRecordingReportPreparer.Create;
  PreparedObject := TSyntheticPreparedReport.Create('unit23-foko',
    [rocPreview, rocPdf]);
  Prepared := PreparedObject;
  PreparerObject.Report := Prepared;
  Preparer := PreparerObject;

  ReturnedReport := PrepareReport(Request, Source, Preparer);

  AssertTrue('The exact source boundary is forwarded without ownership transfer.',
    PreparerObject.ReceivedSource = Source);
  AssertEquals('unit23-foko', PreparerObject.ReceivedRequest.ReportId);
  AssertTrue(ReturnedReport = Prepared);
  ReturnedReport := nil;
  Prepared := nil;
  Preparer := nil;
  Source := nil;
end;

procedure TTestAHW52ReportLifecycleContract.TestPreparationRejectsMissingSource;
var
  PreparerObject: TRecordingReportPreparer;
  Preparer: IReportPreparer;
begin
  PreparerObject := TRecordingReportPreparer.Create;
  Preparer := PreparerObject;
  try
    PrepareReport(CreateSyntheticRequest, nil, Preparer);
    Fail('A missing source is unavailable, not an empty report.');
  except
    on E: EReportSourceUnavailable do
      AssertTrue(E.Message <> '');
  end;
  Preparer := nil;
end;

procedure TTestAHW52ReportLifecycleContract.TestPreparationRejectsMissingPreparer;
var
  Source: IReportSourceContext;
begin
  Source := TSyntheticReportSource.Create;
  try
    PrepareReport(CreateSyntheticRequest, Source, nil);
    Fail('A missing preparer must be reported as unavailable.');
  except
    on E: EReportSourceUnavailable do
      AssertTrue(E.Message <> '');
  end;
  Source := nil;
end;

procedure TTestAHW52ReportLifecycleContract.TestPreparationRejectsNilPreparedReport;
var
  Source: IReportSourceContext;
  PreparerObject: TRecordingReportPreparer;
  Preparer: IReportPreparer;
begin
  Source := TSyntheticReportSource.Create;
  PreparerObject := TRecordingReportPreparer.Create;
  Preparer := PreparerObject;
  try
    PrepareReport(CreateSyntheticRequest, Source, Preparer);
    Fail('A nil preparation result must not look successful.');
  except
    on E: EReportNotPrepared do
      AssertTrue(E.Message <> '');
  end;
  Preparer := nil;
  Source := nil;
end;

procedure TTestAHW52ReportLifecycleContract.
  TestPreparationRejectsWrongReportIdentity;
var
  Source: IReportSourceContext;
  PreparerObject: TRecordingReportPreparer;
  Preparer: IReportPreparer;
  Prepared: IPreparedReport;
begin
  Source := TSyntheticReportSource.Create;
  PreparerObject := TRecordingReportPreparer.Create;
  Prepared := TSyntheticPreparedReport.Create('different-report', [rocText]);
  PreparerObject.Report := Prepared;
  Preparer := PreparerObject;
  try
    PrepareReport(CreateSyntheticRequest, Source, Preparer);
    Fail('A preparer cannot return a different report identity.');
  except
    on E: EReportInvalidTransition do
      AssertTrue(E.Message <> '');
  end;
  Preparer := nil;
  Prepared := nil;
  Source := nil;
end;

procedure TTestAHW52ReportLifecycleContract.TestOutputRejectsUnpreparedReport;
var
  Sink: IReportOutputSink;
begin
  Sink := TRecordingReportSink.Create(rocPreview);
  try
    ExecuteReportOutput(nil, Sink);
    Fail('Output requires a prepared report.');
  except
    on E: EReportNotPrepared do
      AssertTrue(E.Message <> '');
  end;
  Sink := nil;
end;

procedure TTestAHW52ReportLifecycleContract.TestOutputRejectsMissingSink;
var
  Report: IPreparedReport;
begin
  Report := TSyntheticPreparedReport.Create('unit23-foko', [rocPreview]);
  try
    ExecuteReportOutput(Report, nil);
    Fail('A missing sink cannot be treated as a successful output.');
  except
    on E: EReportUnsupportedOutput do
      AssertTrue(E.Message <> '');
  end;
  Report := nil;
end;

procedure TTestAHW52ReportLifecycleContract.
  TestOutputDispatchesSupportedCapabilityOnly;
var
  Report: IPreparedReport;
  SinkObject: TRecordingReportSink;
  Sink: IReportOutputSink;
begin
  Report := TSyntheticPreparedReport.Create('unit23-foko', [rocPreview, rocPdf]);
  SinkObject := TRecordingReportSink.Create(rocPdf);
  Sink := SinkObject;

  ExecuteReportOutput(Report, Sink);

  AssertEquals(1, SinkObject.CallCount);
  AssertTrue(SinkObject.ReceivedReport = Report);
  Sink := nil;
  Report := nil;
end;

procedure TTestAHW52ReportLifecycleContract.
  TestOutputRejectsCapabilityNotProducedByReport;
var
  Report: IPreparedReport;
  SinkObject: TRecordingReportSink;
  Sink: IReportOutputSink;
begin
  Report := TSyntheticPreparedReport.Create('unit16-preview', [rocPreview]);
  SinkObject := TRecordingReportSink.Create(rocPdf);
  Sink := SinkObject;
  try
    ExecuteReportOutput(Report, Sink);
    Fail('PDF cannot be inferred from preview capability.');
  except
    on E: EReportUnsupportedOutput do
      AssertEquals(0, SinkObject.CallCount);
  end;
  Sink := nil;
  Report := nil;
end;

procedure TTestAHW52ReportLifecycleContract.
  TestOutputDoesNotFallbackToAnotherCapability;
var
  Report: IPreparedReport;
  SinkObject: TRecordingReportSink;
  Sink: IReportOutputSink;
begin
  Report := TSyntheticPreparedReport.Create('unit16-preview', [rocPreview]);
  SinkObject := TRecordingReportSink.Create(rocPrint);
  Sink := SinkObject;
  try
    ExecuteReportOutput(Report, Sink);
    Fail('Print must not fall back to the available preview capability.');
  except
    on E: EReportUnsupportedOutput do
      AssertEquals(0, SinkObject.CallCount);
  end;
  Sink := nil;
  Report := nil;
end;

procedure TTestAHW52ReportLifecycleContract.TestOutputSinkFailurePropagates;
var
  Report: IPreparedReport;
  SinkObject: TRecordingReportSink;
  Sink: IReportOutputSink;
begin
  Report := TSyntheticPreparedReport.Create('unit23-foko', [rocText]);
  SinkObject := TRecordingReportSink.Create(rocText);
  SinkObject.Fail := True;
  Sink := SinkObject;
  try
    ExecuteReportOutput(Report, Sink);
    Fail('Output errors must be observable by the caller.');
  except
    on E: EReportEngineFailure do
      AssertEquals('Injected report output failure.', E.Message);
  end;
  Sink := nil;
  Report := nil;
end;

procedure TTestAHW52ReportLifecycleContract.TestPreparationFailurePropagates;
var
  Source: IReportSourceContext;
  PreparerObject: TRecordingReportPreparer;
  Preparer: IReportPreparer;
begin
  Source := TSyntheticReportSource.Create;
  PreparerObject := TRecordingReportPreparer.Create;
  PreparerObject.Fail := True;
  Preparer := PreparerObject;
  try
    PrepareReport(CreateSyntheticRequest, Source, Preparer);
    Fail('Preparation errors must not be converted into an unavailable result.');
  except
    on E: EInjectedReportLifecycleFailure do
      AssertEquals('Injected report preparation failure.', E.Message);
  end;
  Preparer := nil;
  Source := nil;
end;

initialization
  RegisterTest(TTestAHW52ReportLifecycleContract);

end.
