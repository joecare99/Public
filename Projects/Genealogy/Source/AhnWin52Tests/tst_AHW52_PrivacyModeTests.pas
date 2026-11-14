unit tst_AHW52_PrivacyModeTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52PrivacyMode = class(TTestCase)
  published
    procedure TestCaseEnablePrivacyMode;
    procedure TestCaseCancelledEnableLeavesModeDisabled;
    procedure TestCaseDisableRestoresCaptionAndNumber;
    procedure TestCaseDisableWithoutCaptionMarker;
    procedure TestCaseInvalidActionsAreRejected;
  end;

implementation

uses
  Classes, SysUtils, PrivacyModeBehavior, PrivacyModeState;

type
  TRecordingPrivacyActions = class(TInterfacedObject, IPrivacyModeActions)
  private
    FCalls: TStringList;
    FCaption: string;
    FCurrentPersonNumber: Integer;
    FRequestedBirthYear: Integer;
    FFilters: array[TPrivacyDataSet] of string;
    FFiltered: array[TPrivacyDataSet] of Boolean;
    FHighlightEnabled: Boolean;
    FFailAt: string;
    procedure RecordCall(const Name: string);
    function GetFilter(const DataSet: TPrivacyDataSet): string;
    function GetFiltered(const DataSet: TPrivacyDataSet): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClickDisablePrivacyCommand;
    procedure ActivateDataPage;
    function RequestMaximumBirthYear: Integer;
    procedure SetPrivacyHighlight(const Enabled: Boolean);
    procedure SetDataSetFilter(const DataSet: TPrivacyDataSet;
      const FilterText: string);
    procedure SetDataSetFiltered(const DataSet: TPrivacyDataSet;
      const Filtered: Boolean);
    procedure SetPrivacyBirthYearLimit(const Year: Integer);
    function GetWindowCaption: string;
    procedure SetWindowCaption(const Caption: string);
    function GetCurrentPersonNumber: Integer;
    procedure LocatePersonNumber(const Number: Integer);
    procedure RefreshMainView;
    property Calls: TStringList read FCalls;
    property Caption: string read FCaption write FCaption;
    property CurrentPersonNumber: Integer read FCurrentPersonNumber
      write FCurrentPersonNumber;
    property RequestedBirthYear: Integer read FRequestedBirthYear
      write FRequestedBirthYear;
    property Filters[DataSet: TPrivacyDataSet]: string read GetFilter;
    property Filtered[DataSet: TPrivacyDataSet]: Boolean read GetFiltered;
    property HighlightEnabled: Boolean read FHighlightEnabled;
    property FailAt: string read FFailAt write FFailAt;
  end;

constructor TRecordingPrivacyActions.Create;
begin
  inherited Create;
  FCalls := TStringList.Create;
  FCaption := 'AHNENWIN 5.1';
  FCurrentPersonNumber := 42;
  FRequestedBirthYear := 1950;
end;

destructor TRecordingPrivacyActions.Destroy;
begin
  FCalls.Free;
  inherited Destroy;
end;

procedure TRecordingPrivacyActions.RecordCall(const Name: string);
begin
  FCalls.Add(Name);
  if Name = FFailAt then
    raise Exception.CreateFmt('Injected failure at %s.', [Name]);
end;

function TRecordingPrivacyActions.GetFilter(
  const DataSet: TPrivacyDataSet): string;
begin
  Result := FFilters[DataSet];
end;

function TRecordingPrivacyActions.GetFiltered(
  const DataSet: TPrivacyDataSet): Boolean;
begin
  Result := FFiltered[DataSet];
end;

procedure TRecordingPrivacyActions.ClickDisablePrivacyCommand;
begin
  RecordCall('disable-command');
  ExecutePrivacyModeDisable(Self);
end;

procedure TRecordingPrivacyActions.ActivateDataPage;
begin
  RecordCall('activate-page');
end;

function TRecordingPrivacyActions.RequestMaximumBirthYear: Integer;
begin
  RecordCall('request-year');
  Result := FRequestedBirthYear;
end;

procedure TRecordingPrivacyActions.SetPrivacyHighlight(const Enabled: Boolean);
begin
  FHighlightEnabled := Enabled;
  RecordCall('highlight=' + BoolToStr(Enabled, True));
end;

procedure TRecordingPrivacyActions.SetDataSetFilter(
  const DataSet: TPrivacyDataSet; const FilterText: string);
begin
  FFilters[DataSet] := FilterText;
  RecordCall(Format('filter-%d=%s', [Ord(DataSet), FilterText]));
end;

procedure TRecordingPrivacyActions.SetDataSetFiltered(
  const DataSet: TPrivacyDataSet; const Filtered: Boolean);
begin
  FFiltered[DataSet] := Filtered;
  RecordCall(Format('filtered-%d=%s',
    [Ord(DataSet), BoolToStr(Filtered, True)]));
end;

procedure TRecordingPrivacyActions.SetPrivacyBirthYearLimit(
  const Year: Integer);
begin
  PrivacyModeState.SetPrivacyBirthYearLimit(Year);
  RecordCall('privacy-year=' + IntToStr(Year));
end;

function TRecordingPrivacyActions.GetWindowCaption: string;
begin
  RecordCall('get-caption');
  Result := FCaption;
end;

procedure TRecordingPrivacyActions.SetWindowCaption(const Caption: string);
begin
  FCaption := Caption;
  RecordCall('caption=' + Caption);
end;

function TRecordingPrivacyActions.GetCurrentPersonNumber: Integer;
begin
  RecordCall('get-person-number');
  Result := FCurrentPersonNumber;
end;

procedure TRecordingPrivacyActions.LocatePersonNumber(const Number: Integer);
begin
  FCurrentPersonNumber := Number;
  RecordCall('locate-person=' + IntToStr(Number));
end;

procedure TRecordingPrivacyActions.RefreshMainView;
begin
  RecordCall('refresh');
end;

procedure AssertEqual(const Description, Expected, Actual: string);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected "%s", got "%s".',
      [Description, Expected, Actual]);
end;

procedure AssertSequence(Actions: TRecordingPrivacyActions;
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

procedure TestEnablePrivacyMode;
var
  ActionObject: TRecordingPrivacyActions;
  Actions: IPrivacyModeActions;
  DataSet: TPrivacyDataSet;
  ExpectedFilter: string;
begin
  ActionObject := TRecordingPrivacyActions.Create;
  Actions := ActionObject;
  PrivacyModeState.SetPrivacyBirthYearLimit(0);

  if not ExecutePrivacyModeEnable(Actions) then
    raise Exception.Create('Positive privacy year was rejected.');

  ExpectedFilter := 'gebjahr<=1950 and taufjahr<=1950';
  for DataSet in [pdsTable1, pdsTable7, pdsTable8, pdsTable9, pdsTable17] do
  begin
    AssertEqual('Enabled dataset filter', ExpectedFilter,
      ActionObject.Filters[DataSet]);
    if not ActionObject.Filtered[DataSet] then
      raise Exception.CreateFmt('Dataset %d was not filtered.', [Ord(DataSet)]);
  end;
  if ActionObject.Filtered[pdsTable5] then
    raise Exception.Create('Table5 is not filtered by the enable listing.');
  if not ActionObject.HighlightEnabled then
    raise Exception.Create('Privacy highlight was not enabled.');
  AssertEqual('Privacy caption',
    'AHNENWIN 5.1    (Datenschutz: geb. max. 1950)',
    ActionObject.Caption);
  AssertEqual('Shared privacy limit', '1950',
    IntToStr(GetPrivacyBirthYearLimit));

  if not ExecutePrivacyModeEnable(Actions) then
    raise Exception.Create('Repeated positive activation was rejected.');
  AssertEqual('Repeated activation does not duplicate caption marker',
    'AHNENWIN 5.1        (Datenschutz: geb. max. 1950)',
    ActionObject.Caption);
  Actions := nil;
end;

procedure TestCancelledEnableLeavesModeDisabled;
var
  ActionObject: TRecordingPrivacyActions;
  Actions: IPrivacyModeActions;
  Index: Integer;
  RefreshCount: Integer;
begin
  ActionObject := TRecordingPrivacyActions.Create;
  ActionObject.Caption := 'AHNENWIN 5.1';
  ActionObject.RequestedBirthYear := 0;
  Actions := ActionObject;
  PrivacyModeState.SetPrivacyBirthYearLimit(1940);

  if ExecutePrivacyModeEnable(Actions) then
    raise Exception.Create('A non-positive privacy year was accepted.');

  if ActionObject.HighlightEnabled then
    raise Exception.Create('Cancelled activation left privacy highlight set.');
  AssertEqual('Cancelled activation caption', 'AHNENWIN 5.1',
    ActionObject.Caption);
  AssertEqual('Cancelled activation global limit', '0',
    IntToStr(GetPrivacyBirthYearLimit));
  RefreshCount := 0;
  for Index := 0 to ActionObject.Calls.Count - 1 do
    if ActionObject.Calls[Index] = 'refresh' then
      Inc(RefreshCount);
  AssertEqual('Cancelled activation refresh count', '2',
    IntToStr(RefreshCount));
  Actions := nil;
end;

procedure TestDisableRestoresCaptionAndNumber;
var
  ActionObject: TRecordingPrivacyActions;
  Actions: IPrivacyModeActions;
  DataSet: TPrivacyDataSet;
begin
  ActionObject := TRecordingPrivacyActions.Create;
  ActionObject.Caption := 'AHNENWIN 5.1    (Datenschutz: geb. max. 1950)';
  ActionObject.CurrentPersonNumber := 17;
  Actions := ActionObject;
  PrivacyModeState.SetPrivacyBirthYearLimit(1950);

  ExecutePrivacyModeDisable(Actions);

  AssertEqual('Normal caption retains separator spaces', 'AHNENWIN 5.1    ',
    ActionObject.Caption);
  AssertEqual('Restored person number', '17',
    IntToStr(ActionObject.CurrentPersonNumber));
  AssertEqual('Disabled privacy limit', '0',
    IntToStr(GetPrivacyBirthYearLimit));
  if ActionObject.HighlightEnabled then
    raise Exception.Create('Privacy highlight remained enabled.');
  for DataSet := Low(TPrivacyDataSet) to High(TPrivacyDataSet) do
  begin
    AssertEqual(Format('Cleared filter for dataset %d', [Ord(DataSet)]), '',
      ActionObject.Filters[DataSet]);
    if ActionObject.Filtered[DataSet] then
      raise Exception.CreateFmt('Dataset %d remained filtered.',
        [Ord(DataSet)]);
  end;
  AssertSequence(ActionObject, [
    'get-person-number',
    'activate-page',
    'highlight=False',
    'filter-0=',
    'filter-1=',
    'filter-2=',
    'filter-3=',
    'filter-4=',
    'filter-5=',
    'filtered-0=False',
    'filtered-1=False',
    'filtered-2=False',
    'filtered-3=False',
    'filtered-4=False',
    'filtered-5=False',
    'privacy-year=0',
    'get-caption',
    'caption=AHNENWIN 5.1    ',
    'locate-person=17',
    'refresh'
  ]);
  Actions := nil;
end;

procedure TestDisableWithoutCaptionMarker;
var
  ActionObject: TRecordingPrivacyActions;
  Actions: IPrivacyModeActions;
begin
  ActionObject := TRecordingPrivacyActions.Create;
  Actions := ActionObject;
  ExecutePrivacyModeDisable(Actions);
  AssertEqual('Unmarked caption remains unchanged', 'AHNENWIN 5.1',
    ActionObject.Caption);
  Actions := nil;
end;

procedure TestInvalidActionsAreRejected;
var
  Raised: Boolean;
begin
  Raised := False;
  try
    ExecutePrivacyModeDisable(nil);
  except
    on E: EArgumentNilException do
      Raised := True;
  end;
  if not Raised then
    raise Exception.Create('Nil privacy actions were accepted.');
end;

procedure TTestAHW52PrivacyMode.TestCaseEnablePrivacyMode;
begin
    TestEnablePrivacyMode;
end;

procedure TTestAHW52PrivacyMode.TestCaseCancelledEnableLeavesModeDisabled;
begin
    TestCancelledEnableLeavesModeDisabled;
end;

procedure TTestAHW52PrivacyMode.TestCaseDisableRestoresCaptionAndNumber;
begin
    TestDisableRestoresCaptionAndNumber;
end;

procedure TTestAHW52PrivacyMode.TestCaseDisableWithoutCaptionMarker;
begin
    TestDisableWithoutCaptionMarker;
end;

procedure TTestAHW52PrivacyMode.TestCaseInvalidActionsAreRejected;
begin
    TestInvalidActionsAreRejected;
end;

initialization
  RegisterTest(TTestAHW52PrivacyMode);

end.
