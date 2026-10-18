unit AHW52PersonEditFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52PersonEditFrame, AHW52LegacySharedState, Classes, Controls, DB, DBGrids,
  DBCtrls, ComCtrls, fpcunit, testregistry;

type
  TTestAHW52PersonEditFrame = class(TTestCase)
  private
    FHostActionCount: Integer;
    FLastAction: Integer;
    FLastSender: TObject;
    procedure RecordHostAction(Sender: TObject;
      Action: TPersonEditTabHostAction);
    procedure RecordSaveRequest(Sender: TObject);
  published
    procedure TestMainFormStreamsEditFrameAndRetainsBoundControls;
    procedure TestFrameForwardsOnlyHostOwnedActions;
    procedure TestGridEscapeAndExitBehaviorStaysInsideFrame;
    procedure TestEditTabShowAndFormActivationFocusPrimaryField;
    procedure TestUnparentedFocusRaisesExplicitError;
    procedure TestDBCheckBoxExitRefreshesDatasetThroughInterface;
    procedure TestDBCheckBoxExitRequiresInitializedInterface;
    procedure TestDBCheckBoxExitPropagatesRefreshErrors;
    procedure TestDataModuleAdapterDelegatesTable1;
    procedure TestDataModuleAdapterDelegatesTransactionLifecycle;
    procedure TestDataModuleAdapterRequiresConfiguredTransaction;
    procedure TestDataModuleAdapterRejectsMissingForm;
    procedure TestTemporaryDataModuleCanBeSubstituted;
    procedure TestTemporaryDataModuleRequiresInitialization;
    procedure TestDBEdit69ChangeResetsSharedStateWithoutHostDispatch;
    procedure TestUnit32CleanupUsesSharedStateCells;
  end;

implementation

uses
  BufDataset, Forms, GenealogyDataModule, LCLType, SQLite3Conn, SQLDB,
  SysUtils, Unit32,
  GenealogyDataModuleAccess, frmAhnenWinMain;

type
  ERefreshTestFailure = class(Exception);

  TRecordingRefreshDataSet = class(TBufDataset)
  protected
    procedure InternalRefresh; override;
  public
    RefreshCount: Integer;
    RaiseOnRefresh: Boolean;
  end;

  TFakeGenealogyDataModule = class(TInterfacedObject, IGenealogyDataModule)
  private
    FTable1: TDataSet;
    procedure BeginTransaction;
    procedure CommitTransaction;
    procedure RollbackTransaction;
    procedure AppendMarriageRecord(const PersonNumber, PartnerNumber: Integer;
      const Details: TMarriageDetails);
    function GetTable1: TDataSet;
    function GetTable3: TDataSet;
    function GetTable1Nummer: TField;
    function GetTable1Vater: TField;
    function GetTable1Mutter: TField;
    function GetTable1Name: TField;
    function GetTable1Vornamen: TField;
    function GetTable1Religion: TField;
    function GetTable5: TDataSet;
    function GetTable5Numr: TField;
    function GetTable5Epnum: TField;
    function GetTable17: TDataSet;
    function GetTable18: TDataSet;
    function GetTable7: TDataSet;
    function GetTable8: TDataSet;
    function GetTable9: TDataSet;
    function GetTable13: TDataSet;
    function GetTable13Ort: TField;
    procedure SetTable13Index(const IndexName: string);
  public
    constructor Create(ATable1: TDataSet);
  end;

  TFakeTemporaryDataModule = class(TInterfacedObject, ITemporaryDataModule)
  end;

procedure TRecordingRefreshDataSet.InternalRefresh;
begin
  Inc(RefreshCount);
  if RaiseOnRefresh then
    raise ERefreshTestFailure.Create('Synthetic refresh failure.');
end;

constructor TFakeGenealogyDataModule.Create(ATable1: TDataSet);
begin
  inherited Create;
  FTable1 := ATable1;
end;

function TFakeGenealogyDataModule.GetTable1: TDataSet;
begin
  Result := FTable1;
end;

procedure TFakeGenealogyDataModule.BeginTransaction;
begin
  raise EDataModuleTransactionUnavailable.Create(
    'The synthetic module does not provide transactions.');
end;

procedure TFakeGenealogyDataModule.CommitTransaction;
begin
  raise EDataModuleTransactionUnavailable.Create(
    'The synthetic module does not provide transactions.');
end;

procedure TFakeGenealogyDataModule.RollbackTransaction;
begin
  raise EDataModuleTransactionUnavailable.Create(
    'The synthetic module does not provide transactions.');
end;

procedure TFakeGenealogyDataModule.AppendMarriageRecord(
  const PersonNumber, PartnerNumber: Integer; const Details: TMarriageDetails);
begin
  raise EDataModuleWriteUnavailable.Create(
    'The synthetic module does not provide marriage writes.');
end;

function TFakeGenealogyDataModule.GetTable3: TDataSet;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table3.');
end;

function TFakeGenealogyDataModule.GetTable1Nummer: TField;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table1Nummer.');
end;

function TFakeGenealogyDataModule.GetTable1Vater: TField;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table1Vater.');
end;

function TFakeGenealogyDataModule.GetTable1Mutter: TField;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table1Mutter.');
end;

function TFakeGenealogyDataModule.GetTable1Name: TField;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table1Name.');
end;

function TFakeGenealogyDataModule.GetTable1Vornamen: TField;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table1Vornamen.');
end;

function TFakeGenealogyDataModule.GetTable1Religion: TField;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table1Religion.');
end;

function TFakeGenealogyDataModule.GetTable5: TDataSet;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table5.');
end;

function TFakeGenealogyDataModule.GetTable5Numr: TField;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table5Numr.');
end;

function TFakeGenealogyDataModule.GetTable5Epnum: TField;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table5Epnum.');
end;

function TFakeGenealogyDataModule.GetTable17: TDataSet;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table17.');
end;

function TFakeGenealogyDataModule.GetTable18: TDataSet;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table18.');
end;

function TFakeGenealogyDataModule.GetTable7: TDataSet;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table7.');
end;

function TFakeGenealogyDataModule.GetTable8: TDataSet;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table8.');
end;

function TFakeGenealogyDataModule.GetTable9: TDataSet;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table9.');
end;

function TFakeGenealogyDataModule.GetTable13: TDataSet;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table13.');
end;

function TFakeGenealogyDataModule.GetTable13Ort: TField;
begin
  Result := nil;
  raise EInvalidOperation.Create('The synthetic module has no Table13Ort.');
end;

procedure TFakeGenealogyDataModule.SetTable13Index(const IndexName: string);
begin
  raise EInvalidOperation.Create(
    'The synthetic module does not provide Table13 index operations.');
end;

procedure TTestAHW52PersonEditFrame.
  TestDBCheckBoxExitRefreshesDatasetThroughInterface;
var
  editFrame: TAHW52PersonEditFrame;
  dataSet: TRecordingRefreshDataSet;
  fakeDataModule: IGenealogyDataModule;
  previousDataModule: IGenealogyDataModule;
begin
  Application.Initialize;
  previousDataModule := GenealogyDataModuleAccess.GenealogyDataModule;
  editFrame := TAHW52PersonEditFrame.Create(nil);
  dataSet := TRecordingRefreshDataSet.Create(nil);
  dataSet.FieldDefs.Add('VALUE', ftString, 1);
  dataSet.CreateDataset;
  fakeDataModule := TFakeGenealogyDataModule.Create(dataSet);
  try
    GenealogyDataModuleAccess.GenealogyDataModule := fakeDataModule;

    editFrame.DBCheckBox1Exit(editFrame.DBCheckBox1);

    AssertEquals('One checkbox exit should refresh the active dataset once.',
      1, dataSet.RefreshCount);
  finally
    GenealogyDataModuleAccess.GenealogyDataModule := previousDataModule;
    fakeDataModule := nil;
    dataSet.Free;
    editFrame.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestDBCheckBoxExitRequiresInitializedInterface;
var
  editFrame: TAHW52PersonEditFrame;
  previousDataModule: IGenealogyDataModule;
  raisedExpectedError: Boolean;
begin
  Application.Initialize;
  previousDataModule := GenealogyDataModuleAccess.GenealogyDataModule;
  editFrame := TAHW52PersonEditFrame.Create(nil);
  try
    GenealogyDataModuleAccess.GenealogyDataModule := nil;
    raisedExpectedError := False;
    try
      editFrame.DBCheckBox1Exit(editFrame.DBCheckBox1);
    except
      on EDataModuleInterfaceUnavailable do
        raisedExpectedError := True;
    end;
    AssertTrue('A missing data-module interface must fail explicitly.',
      raisedExpectedError);
  finally
    GenealogyDataModuleAccess.GenealogyDataModule := previousDataModule;
    editFrame.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestDBCheckBoxExitPropagatesRefreshErrors;
var
  editFrame: TAHW52PersonEditFrame;
  dataSet: TRecordingRefreshDataSet;
  fakeDataModule: IGenealogyDataModule;
  previousDataModule: IGenealogyDataModule;
  raisedExpectedError: Boolean;
begin
  Application.Initialize;
  previousDataModule := GenealogyDataModuleAccess.GenealogyDataModule;
  editFrame := TAHW52PersonEditFrame.Create(nil);
  dataSet := TRecordingRefreshDataSet.Create(nil);
  dataSet.FieldDefs.Add('VALUE', ftString, 1);
  dataSet.CreateDataset;
  dataSet.RaiseOnRefresh := True;
  fakeDataModule := TFakeGenealogyDataModule.Create(dataSet);
  try
    GenealogyDataModuleAccess.GenealogyDataModule := fakeDataModule;
    raisedExpectedError := False;
    try
      editFrame.DBCheckBox1Exit(editFrame.DBCheckBox1);
    except
      on ERefreshTestFailure do
        raisedExpectedError := True;
    end;

    AssertTrue('The checkbox handler must propagate refresh failures.',
      raisedExpectedError);
    AssertEquals('The failing refresh should still be dispatched once.',
      1, dataSet.RefreshCount);
  finally
    GenealogyDataModuleAccess.GenealogyDataModule := previousDataModule;
    fakeDataModule := nil;
    dataSet.Free;
    editFrame.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestDataModuleAdapterDelegatesTable1;
var
  dataModule: TGenealogyDataModule;
  adapter: IGenealogyDataModule;
  temporaryAdapter: ITemporaryDataModule;
  raisedExpectedError: Boolean;
begin
  Application.Initialize;
  dataModule := TGenealogyDataModule.Create(nil);
  try
    if dataModule.Table1Nummer = nil then
      dataModule.Table1Nummer := TIntegerField.Create(dataModule);
    if dataModule.Table1Vater = nil then
      dataModule.Table1Vater := TIntegerField.Create(dataModule);
    if dataModule.Table1Mutter = nil then
      dataModule.Table1Mutter := TIntegerField.Create(dataModule);
    adapter := CreateGenealogyDataModuleAdapter(dataModule);
    temporaryAdapter := CreateTemporaryDataModuleAdapter(dataModule);
    AssertTrue('The backing form should expose Table1.',
      Assigned(dataModule.Table1));
    AssertTrue('The adapter should expose the streamed Table1 instance.',
      adapter.Table1 = dataModule.Table1);
    AssertTrue('The backing form should expose Table3.',
      Assigned(dataModule.Table3));
    AssertTrue('The adapter should expose the streamed Table3 instance.',
      adapter.Table3 = dataModule.Table3);
    AssertTrue('The backing form should expose Table1Nummer.',
      Assigned(dataModule.Table1Nummer));
    AssertTrue('The adapter should expose the streamed Table1 number field.',
      adapter.Table1Nummer = dataModule.Table1Nummer);
    AssertTrue('The backing form should expose Table1Vater.',
      Assigned(dataModule.Table1Vater));
    AssertTrue('The adapter should expose the streamed Table1 father field.',
      adapter.Table1Vater = dataModule.Table1Vater);
    AssertTrue('The backing form should expose Table1Mutter.',
      Assigned(dataModule.Table1Mutter));
    AssertTrue('The adapter should expose the streamed Table1 mother field.',
      adapter.Table1Mutter = dataModule.Table1Mutter);
    AssertTrue('The backing form should expose Table1Name.',
      Assigned(dataModule.Table1Name));
    AssertTrue('The adapter should expose the streamed Table1 name field.',
      adapter.Table1Name = dataModule.Table1Name);
    AssertTrue('The backing form should expose Table1Vornamen.',
      Assigned(dataModule.Table1Vornamen));
    AssertTrue('The adapter should expose the streamed Table1 given-name field.',
      adapter.Table1Vornamen = dataModule.Table1Vornamen);
    AssertTrue('The backing form should expose Table1Religion.',
      Assigned(dataModule.Table1Religion));
    AssertTrue('The adapter should expose the streamed Table1 religion field.',
      adapter.Table1Religion = dataModule.Table1Religion);
    AssertTrue('The backing form should expose Table5.',
      Assigned(dataModule.Table5));
    AssertTrue('The adapter should expose the streamed Table5 instance.',
      adapter.Table5 = dataModule.Table5);
    AssertTrue('The backing form should expose Table5Numr.',
      Assigned(dataModule.Table5Numr));
    AssertTrue('The adapter should expose the streamed Table5 Numr field.',
      adapter.Table5Numr = dataModule.Table5Numr);
    AssertTrue('The backing form should expose Table5Epnum.',
      Assigned(dataModule.Table5Epnum));
    AssertTrue('The adapter should expose the streamed Table5 Epnum field.',
      adapter.Table5Epnum = dataModule.Table5Epnum);
    AssertTrue('The backing form should expose Table17.',
      Assigned(dataModule.Table17));
    AssertTrue('The adapter should expose the streamed Table17 instance.',
      adapter.Table17 = dataModule.Table17);
    AssertTrue('The backing form should expose Table18.',
      Assigned(dataModule.Table18));
    AssertTrue('The adapter should expose the streamed Table18 instance.',
      adapter.Table18 = dataModule.Table18);
    AssertTrue('The backing form should expose Table7.',
      Assigned(dataModule.Table7));
    AssertTrue('The adapter should expose the streamed Table7 instance.',
      adapter.Table7 = dataModule.Table7);
    AssertTrue('The backing form should expose Table8.',
      Assigned(dataModule.Table8));
    AssertTrue('The adapter should expose the streamed Table8 instance.',
      adapter.Table8 = dataModule.Table8);
    AssertTrue('The backing form should expose Table9.',
      Assigned(dataModule.Table9));
    AssertTrue('The adapter should expose the streamed Table9 instance.',
      adapter.Table9 = dataModule.Table9);
    AssertTrue('The backing form should expose Table13.',
      Assigned(dataModule.Table13));
    AssertTrue('The adapter should expose the streamed Table13 instance.',
      adapter.Table13 = dataModule.Table13);
    AssertTrue('The backing form should expose Table13Ort.',
      Assigned(dataModule.Table13Ort));
    AssertTrue('The adapter should expose the streamed Table13 place field.',
      adapter.Table13Ort = dataModule.Table13Ort);
    AssertFalse('The Table13 index mapping must not open its dataset.',
      dataModule.Table13.Active);
    adapter.SetTable13Index('ort_');
    AssertEquals('Ort', dataModule.Table13.IndexFieldNames);
    AssertFalse('Setting the Table13 index must not open its dataset.',
      dataModule.Table13.Active);
    raisedExpectedError := False;
    try
      adapter.SetTable13Index('unsupported');
    except
      on EUnsupportedGenealogyDataIndex do
        raisedExpectedError := True;
    end;
    AssertTrue('Unknown Table13 indexes must fail explicitly.',
      raisedExpectedError);
    AssertTrue('The form adapter should implement the temporary-data contract.',
      temporaryAdapter <> nil);
  finally
    temporaryAdapter := nil;
    adapter := nil;
    dataModule.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestDataModuleAdapterDelegatesTransactionLifecycle;
var
  adapter: IGenealogyDataModule;
  connection: TSQLite3Connection;
  dataModule: TGenealogyDataModule;
  transaction: TSQLTransaction;
begin
  Application.Initialize;
  dataModule := TGenealogyDataModule.Create(nil);
  connection := TSQLite3Connection.Create(nil);
  transaction := TSQLTransaction.Create(nil);
  try
    connection.DatabaseName := ':memory:';
    connection.OpenFlags := [sofReadWrite, sofCreate, sofMemory];
    connection.Transaction := transaction;
    transaction.Database := connection;
    connection.Connected := True;
    dataModule.Table5.Transaction := transaction;
    adapter := CreateGenealogyDataModuleAdapter(dataModule);

    adapter.BeginTransaction;
    AssertTrue('BeginTransaction should start the Table5 transaction.',
      transaction.Active);
    adapter.RollbackTransaction;
    AssertFalse('RollbackTransaction should end the Table5 transaction.',
      transaction.Active);

    adapter.BeginTransaction;
    AssertTrue('A second transaction should be startable after rollback.',
      transaction.Active);
    adapter.CommitTransaction;
    AssertFalse('CommitTransaction should end the Table5 transaction.',
      transaction.Active);
  finally
    adapter := nil;
    if Assigned(dataModule.Table5) then
      dataModule.Table5.Transaction := nil;
    dataModule.Free;
    if transaction.Active then
      transaction.Rollback;
    connection.Close;
    transaction.Free;
    connection.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestDataModuleAdapterRequiresConfiguredTransaction;
var
  adapter: IGenealogyDataModule;
  dataModule: TGenealogyDataModule;
  raisedExpectedError: Boolean;
begin
  Application.Initialize;
  dataModule := TGenealogyDataModule.Create(nil);
  try
    adapter := CreateGenealogyDataModuleAdapter(dataModule);
    raisedExpectedError := False;
    try
      adapter.BeginTransaction;
    except
      on EDataModuleTransactionUnavailable do
        raisedExpectedError := True;
    end;
    AssertTrue('A missing Table5 transaction must fail explicitly.',
      raisedExpectedError);

    raisedExpectedError := False;
    try
      adapter.CommitTransaction;
    except
      on EDataModuleTransactionUnavailable do
        raisedExpectedError := True;
    end;
    AssertTrue('Commit must report a missing Table5 transaction explicitly.',
      raisedExpectedError);

    raisedExpectedError := False;
    try
      adapter.RollbackTransaction;
    except
      on EDataModuleTransactionUnavailable do
        raisedExpectedError := True;
    end;
    AssertTrue('Rollback must report a missing Table5 transaction explicitly.',
      raisedExpectedError);
  finally
    adapter := nil;
    dataModule.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestDataModuleAdapterRejectsMissingForm;
var
  raisedExpectedError: Boolean;
  adapter: IGenealogyDataModule;
  temporaryAdapter: ITemporaryDataModule;
begin
  raisedExpectedError := False;
  try
    adapter := CreateGenealogyDataModuleAdapter(nil);
  except
    on EDataModuleInterfaceUnavailable do
      raisedExpectedError := True;
  end;
  adapter := nil;
  AssertTrue('The adapter factory must reject an absent backing form.',
    raisedExpectedError);

  raisedExpectedError := False;
  try
    temporaryAdapter := CreateTemporaryDataModuleAdapter(nil);
  except
    on EDataModuleInterfaceUnavailable do
      raisedExpectedError := True;
  end;
  temporaryAdapter := nil;
  AssertTrue('The temporary adapter factory must reject an absent form.',
    raisedExpectedError);
end;

procedure TTestAHW52PersonEditFrame.
  TestTemporaryDataModuleCanBeSubstituted;
var
  fakeDataModule: ITemporaryDataModule;
  previousDataModule: ITemporaryDataModule;
begin
  previousDataModule := GenealogyDataModuleAccess.TemporaryDataModule;
  fakeDataModule := TFakeTemporaryDataModule.Create;
  try
    GenealogyDataModuleAccess.TemporaryDataModule := fakeDataModule;
    AssertTrue('The temporary-data interface should be independently replaceable.',
      RequireTemporaryDataModule = fakeDataModule);
  finally
    GenealogyDataModuleAccess.TemporaryDataModule := previousDataModule;
    fakeDataModule := nil;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestTemporaryDataModuleRequiresInitialization;
var
  previousDataModule: ITemporaryDataModule;
  raisedExpectedError: Boolean;
begin
  previousDataModule := GenealogyDataModuleAccess.TemporaryDataModule;
  try
    GenealogyDataModuleAccess.TemporaryDataModule := nil;
    raisedExpectedError := False;
    try
      RequireTemporaryDataModule;
    except
      on EDataModuleInterfaceUnavailable do
        raisedExpectedError := True;
    end;
    AssertTrue('An unset temporary-data contract must fail explicitly.',
      raisedExpectedError);
  finally
    GenealogyDataModuleAccess.TemporaryDataModule := previousDataModule;
  end;
end;

procedure TTestAHW52PersonEditFrame.RecordHostAction(Sender: TObject;
  Action: TPersonEditTabHostAction);
begin
  Inc(FHostActionCount);
  FLastAction := Ord(Action);
  FLastSender := Sender;
end;

procedure TTestAHW52PersonEditFrame.RecordSaveRequest(Sender: TObject);
begin
  FLastSender := Sender;
end;

procedure TTestAHW52PersonEditFrame.
  TestMainFormStreamsEditFrameAndRetainsBoundControls;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    AssertTrue('TabSheet2 should stream its production edit frame.',
      Assigned(mainForm.PersonEditFrame));
    AssertTrue('The edit frame should be parented by TabSheet2.',
      mainForm.PersonEditFrame.Parent = mainForm.TabSheet2);
    AssertEquals('The edit tab caption should remain unchanged.',
      'Bearbeiten', mainForm.TabSheet2.Caption);
    AssertEquals('The edit frame should own the original 70 controls.',
      70, mainForm.PersonEditFrame.ComponentCount);
    AssertEquals('DBEdit2 should retain its original data field.',
      'Vornamen', mainForm.PersonEditFrame.DBEdit2.DataField);
    AssertEquals('DBComboBox3 should retain its original data field.',
      'Kistat', mainForm.PersonEditFrame.DBComboBox3.DataField);
    AssertTrue('DBEdit69 should retain its frame-owned reset binding.',
      mainForm.PersonEditFrame.DBEdit69.OnChange =
        @mainForm.PersonEditFrame.DBEdit69Change);
    AssertTrue('DBCheckBox1 should retain its frame-owned refresh binding.',
      mainForm.PersonEditFrame.DBCheckBox1.OnExit =
        @mainForm.PersonEditFrame.DBCheckBox1Exit);
    AssertTrue('DBGrid3 should retain its double-click binding.',
      Assigned(mainForm.PersonEditFrame.DBGrid3.OnDblClick));
    AssertTrue('DBGrid3 should retain its key-down binding.',
      Assigned(mainForm.PersonEditFrame.DBGrid3.OnKeyDown));
    AssertTrue('The grid should retain its lifecycle event bindings.',
      Assigned(mainForm.PersonEditFrame.DBGrid3.OnExit));
    AssertTrue('The navigator should retain its before-action binding.',
      mainForm.PersonEditFrame.DBNavigator1.BeforeAction =
        @mainForm.PersonEditFrame.DBNavigator1BeforeAction);
    AssertTrue('The navigator save request should use the shared save workflow.',
      mainForm.PersonEditFrame.OnSaveRequested = @mainForm.speich1);
    AssertTrue('Tab enter should dispatch through the frame.',
      mainForm.TabSheet2.OnEnter = @mainForm.PersonEditFrame.TabSheet2Enter);
    AssertTrue('Tab exit should dispatch through the frame.',
      mainForm.TabSheet2.OnExit = @mainForm.PersonEditFrame.TabSheet2Exit);
    AssertTrue('Tab show should dispatch through the frame.',
      mainForm.TabSheet2.OnShow = @mainForm.PersonEditFrame.TabSheet2Show);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.TestFrameForwardsOnlyHostOwnedActions;
var
  editFrame: TAHW52PersonEditFrame;
begin
  Application.Initialize;
  editFrame := TAHW52PersonEditFrame.Create(nil);
  try
    FHostActionCount := 0;
    FLastAction := -1;
    FLastSender := nil;
    editFrame.OnHostAction := @RecordHostAction;
    editFrame.OnSaveRequested := @RecordSaveRequest;

    editFrame.TabSheet2Enter(editFrame);
    AssertEquals(1, FHostActionCount);
    AssertEquals(Ord(peaTabSheet2Enter), FLastAction);
    AssertTrue('Tab entry should preserve its original sender.',
      FLastSender = editFrame);

    GlobalVar_0061E0A0 := 'first synthetic value';
    GlobalVar_0061E0A4 := 'second synthetic value';
    GlobalVar_02535B58 := 'third synthetic value';
    editFrame.DBEdit69.OnChange(editFrame.DBEdit69);
    AssertEquals('The reset must not dispatch another host action.',
      Ord(peaTabSheet2Enter), FLastAction);
    AssertEquals(1, FHostActionCount);
    AssertTrue('The reset must not replace the active host sender.',
      FLastSender = editFrame);
    AssertEquals('', GlobalVar_0061E0A0);
    AssertEquals('', GlobalVar_0061E0A4);
    AssertEquals('', GlobalVar_02535B58);

    editFrame.DBEdit12Exit(editFrame.DBEdit12);
    editFrame.DBEdit13Exit(editFrame.DBEdit13);
    editFrame.DBEdit20Exit(editFrame.DBEdit20);
    editFrame.DBEdit21Exit(editFrame.DBEdit21);
    AssertEquals('Listing-only field exits should not dispatch to the host.',
      Ord(peaTabSheet2Enter), FLastAction);
    AssertEquals(1, FHostActionCount);
    AssertTrue('Inert exits should not replace the active host sender.',
      FLastSender = editFrame);

    editFrame.DBNavigator1.BeforeAction(editFrame.DBNavigator1, nbPost);
    AssertTrue('Navigator save request should preserve the navigator sender.',
      FLastSender = editFrame.DBNavigator1);
    AssertEquals('Navigator save should not dispatch through the tab host.',
      Ord(peaTabSheet2Enter), FLastAction);
    AssertEquals('Navigator save should not invoke the tab host action.',
      1, FHostActionCount);
  finally
    GlobalVar_0061E0A0 := '';
    GlobalVar_0061E0A4 := '';
    GlobalVar_02535B58 := '';
    editFrame.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestDBEdit69ChangeResetsSharedStateWithoutHostDispatch;
var
  editFrame: TAHW52PersonEditFrame;
begin
  Application.Initialize;
  editFrame := TAHW52PersonEditFrame.Create(nil);
  try
    FLastAction := -1;
    FLastSender := nil;
    editFrame.OnHostAction := @RecordHostAction;
    GlobalVar_0061E0A0 := 'search state one';
    GlobalVar_0061E0A4 := 'search state two';
    GlobalVar_02535B58 := 'shared image state';

    editFrame.DBEdit69Change(editFrame.DBEdit69);

    AssertEquals('DBEdit69Change should not call the host dispatcher.',
      -1, FLastAction);
    AssertEquals('', GlobalVar_0061E0A0);
    AssertEquals('', GlobalVar_0061E0A4);
    AssertEquals('', GlobalVar_02535B58);
  finally
    GlobalVar_0061E0A0 := '';
    GlobalVar_0061E0A4 := '';
    GlobalVar_02535B58 := '';
    editFrame.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.TestUnit32CleanupUsesSharedStateCells;
var
  familySheet: TForm32;
begin
  familySheet := TForm32.CreateNew(nil);
  try
    GlobalVar_0061E0A0 := 'shared first cell';
    GlobalVar_0061E0A4 := 'shared second cell';
    GlobalVar_02535B58 := 'independent third cell';
    GlobalVar_0061E0A8 := -1;

    familySheet._PROC_00559D3C(familySheet);

    AssertEquals('', GlobalVar_0061E0A0);
    AssertEquals('', GlobalVar_0061E0A4);
    AssertEquals('The Unit32 cleanup does not clear the third cell.',
      'independent third cell', GlobalVar_02535B58);
  finally
    GlobalVar_0061E0A8 := 0;
    GlobalVar_0061E0A0 := '';
    GlobalVar_0061E0A4 := '';
    GlobalVar_02535B58 := '';
    familySheet.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestGridEscapeAndExitBehaviorStaysInsideFrame;
var
  mainForm: TForm1;
  editFrame: TAHW52PersonEditFrame;
  key: Word;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    editFrame := mainForm.PersonEditFrame;

    editFrame.DBGrid3.Visible := True;
    editFrame.Label81.Visible := True;
    editFrame.DBGrid3Exit(editFrame.DBGrid3);
    AssertFalse(editFrame.DBGrid3.Visible);
    AssertFalse(editFrame.Label81.Visible);
    AssertTrue('Leaving the grid should focus DBComboBox3 on the form.',
      mainForm.ActiveControl = editFrame.DBComboBox3);

    editFrame.DBGrid3.Visible := True;
    editFrame.Label81.Visible := True;
    editFrame.DBComboBox3.Text := 'synthetic value';
    key := VK_ESCAPE;
    editFrame.DBGrid3KeyDown(editFrame.DBGrid3, key, []);
    AssertEquals('', editFrame.DBComboBox3.Text);
    AssertFalse(editFrame.DBGrid3.Visible);
    AssertFalse(editFrame.Label81.Visible);
    AssertTrue('Escape should focus DBComboBox3 on the form.',
      mainForm.ActiveControl = editFrame.DBComboBox3);
    AssertEquals('The frame should not consume the Escape key.',
      VK_ESCAPE, key);

    editFrame.StringGrid5.Visible := True;
    key := VK_ESCAPE;
    editFrame.StringGrid5KeyDown(editFrame.StringGrid5, key, []);
    AssertFalse(editFrame.StringGrid5.Visible);
    AssertEquals('The string grid handler should not consume Escape.',
      VK_ESCAPE, key);

    editFrame.StringGrid5.Visible := True;
    key := Ord('A');
    editFrame.StringGrid5KeyDown(editFrame.StringGrid5, key, []);
    AssertTrue('Ordinary keys should leave the string grid visible.',
      editFrame.StringGrid5.Visible);
    AssertEquals(Ord('A'), key);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestEditTabShowAndFormActivationFocusPrimaryField;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    mainForm.TabSheet2.OnShow(mainForm.TabSheet2);
    AssertTrue('Showing the edit tab should focus its primary field locally.',
      mainForm.ActiveControl = mainForm.PersonEditFrame.DBEdit2);
    mainForm.ActiveControl := nil;
    mainForm.FormActivate(mainForm);
    AssertTrue('Form activation should focus the primary field locally.',
      mainForm.ActiveControl = mainForm.PersonEditFrame.DBEdit2);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.TestUnparentedFocusRaisesExplicitError;
var
  editFrame: TAHW52PersonEditFrame;
  raisedExpectedError: Boolean;
begin
  Application.Initialize;
  editFrame := TAHW52PersonEditFrame.Create(nil);
  try
    raisedExpectedError := False;
    try
      editFrame.FocusPrimaryField;
    except
      on EInvalidOperation do
        raisedExpectedError := True;
    end;
    AssertTrue('Focus requests without a containing form must fail explicitly.',
      raisedExpectedError);
  finally
    editFrame.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PersonEditFrame);

end.
