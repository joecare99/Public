unit ReportLifecycleContract;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

type
  TReportOutputCapability = (
    rocPreview,
    rocPrint,
    rocPdf,
    rocText
  );
  TReportOutputCapabilities = set of TReportOutputCapability;

  TReportRequest = record
    ReportId: string;
    ReportKind: string;
    Caption: string;
  end;

  /// Marker for caller-owned source context; the contract never owns it.
  IReportSourceContext = interface
    ['{BDF29171-B460-4846-861D-49475A64A531}']
  end;

  /// Represents a report after preparation, not its source or rendered pages.
  IPreparedReport = interface
    ['{965D40F4-A4B8-4F56-9538-98263D81850B}']
    function GetReportId: string;
    function GetCapabilities: TReportOutputCapabilities;
    property ReportId: string read GetReportId;
    property Capabilities: TReportOutputCapabilities read GetCapabilities;
  end;

  IReportPreparer = interface
    ['{1E6AF982-BF3A-4387-91F6-8CA09CB0FBB7}']
    function Prepare(const Request: TReportRequest;
      const Source: IReportSourceContext): IPreparedReport;
  end;

  /// A sink handles exactly one output capability; no implicit fallback exists.
  IReportOutputSink = interface
    ['{5B62A714-C9AF-463E-99A8-3C5A9D71F3EA}']
    function GetCapability: TReportOutputCapability;
    procedure Execute(const Report: IPreparedReport);
    property Capability: TReportOutputCapability read GetCapability;
  end;

  EReportLifecycleError = class(Exception);
  EReportRequestInvalid = class(EReportLifecycleError);
  EReportSourceUnavailable = class(EReportLifecycleError);
  EReportNotPrepared = class(EReportLifecycleError);
  EReportUnsupportedOutput = class(EReportLifecycleError);
  EReportInvalidTransition = class(EReportLifecycleError);
  EReportEngineFailure = class(EReportLifecycleError);

function CreateReportRequest(const ReportId, ReportKind, Caption: string):
  TReportRequest;
procedure ValidateReportRequest(const Request: TReportRequest);
procedure ValidateReportOutputCapability(
  const Capability: TReportOutputCapability);
function PrepareReport(const Request: TReportRequest;
  const Source: IReportSourceContext;
  const Preparer: IReportPreparer): IPreparedReport;
procedure ExecuteReportOutput(const Report: IPreparedReport;
  const Sink: IReportOutputSink);

implementation

function CreateReportRequest(const ReportId, ReportKind, Caption: string):
  TReportRequest;
begin
  Result.ReportId := ReportId;
  Result.ReportKind := ReportKind;
  Result.Caption := Caption;
  ValidateReportRequest(Result);
end;

procedure ValidateReportRequest(const Request: TReportRequest);
begin
  if Trim(Request.ReportId) = '' then
    raise EReportRequestInvalid.Create('A report identity is required.');
  if Trim(Request.ReportKind) = '' then
    raise EReportRequestInvalid.Create('A report kind is required.');
end;

procedure ValidateReportOutputCapability(
  const Capability: TReportOutputCapability);
begin
  case Capability of
    rocPreview, rocPrint, rocPdf, rocText:
      Exit;
  else
    raise EReportUnsupportedOutput.Create(
      'The requested report output capability is invalid.');
  end;
end;

function PrepareReport(const Request: TReportRequest;
  const Source: IReportSourceContext;
  const Preparer: IReportPreparer): IPreparedReport;
begin
  ValidateReportRequest(Request);
  if Source = nil then
    raise EReportSourceUnavailable.Create(
      'The caller did not provide a report source context.');
  if Preparer = nil then
    raise EReportSourceUnavailable.Create(
      'No report preparer is available for this request.');

  Result := Preparer.Prepare(Request, Source);
  if Result = nil then
    raise EReportNotPrepared.Create(
      'The report preparer returned no prepared report.');
  if Result.ReportId <> Request.ReportId then
    raise EReportInvalidTransition.CreateFmt(
      'The preparer returned report "%s" for request "%s".',
      [Result.ReportId, Request.ReportId]);
end;

procedure ExecuteReportOutput(const Report: IPreparedReport;
  const Sink: IReportOutputSink);
var
  Capability: TReportOutputCapability;
begin
  if Report = nil then
    raise EReportNotPrepared.Create(
      'An output operation requires a prepared report.');
  if Sink = nil then
    raise EReportUnsupportedOutput.Create(
      'No output sink is available.');

  Capability := Sink.Capability;
  ValidateReportOutputCapability(Capability);
  if not (Capability in Report.Capabilities) then
    raise EReportUnsupportedOutput.CreateFmt(
      'Report "%s" does not support output capability %d.',
      [Report.ReportId, Ord(Capability)]);

  Sink.Execute(Report);
end;

end.
