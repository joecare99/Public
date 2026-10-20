unit tst_AHW52_PlaceSearchSelectionTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms, Unit14;

type
  TTestAHW52PlaceSearchSelection = class(TTestCase)
  private
    FCloseEventCount: Integer;
    FGlobalValueAtClose: LongInt;
    FItemIndexAtClose: Integer;
    FPlaceSearchForm: TForm14;
    procedure MakeTestFormInvisible(form: TCustomForm);
    procedure RecordGlobalFormClose(Sender: TObject;
      var CloseAction: TCloseAction);
  published
    procedure TestListClickCopiesSelectedAndUnselectedIndices;
    procedure TestFinishResetsSelectionBeforeClosingGlobalForm;
    procedure TestFormActivateSetsPlaceIndexRefillsAndRestoresSelection;
    procedure TestButtonSearchFindsPersonAndMultipleMarriagePlaces;
    procedure TestButtonSearchUsesExactCaseSensitivePlaceMatching;
    procedure TestUnboundCounterIncrementPreservesStrings;
    procedure TestUnboundCounterIncrementClearsStringsAtZero;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  BufDataset, DB, GenealogyDataModuleAccess, StdCtrls, SysUtils,
  frmAhnenWinMain;

type
  TPlaceSearchDataSet = class(TBufDataset)
  protected
    procedure LoadBlobIntoBuffer(FieldDef: TFieldDef;
      ABlobBuf: PBufBlobField); override;
  end;

  TFakePlaceSearchDataModule = class(TInterfacedObject,
    IGenealogyDataModule)
  private
    FTable1: TDataSet;
    FTable18: TDataSet;
    FTable13: TDataSet;
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
    LastTable13Index: string;
    constructor Create(ATable1, ATable18: TDataSet;
      ATable13: TDataSet = nil);
  end;

procedure TPlaceSearchDataSet.LoadBlobIntoBuffer(FieldDef: TFieldDef;
  ABlobBuf: PBufBlobField);
begin
  if ABlobBuf = nil then
    raise Exception.Create('The place-search blob buffer is missing.');
  raise Exception.CreateFmt('The place-search fixture cannot load %s.',
    [FieldDef.Name]);
end;

function CreateSyntheticPeople: TPlaceSearchDataSet;
begin
  Result := TPlaceSearchDataSet.Create(nil);
  Result.FieldDefs.Add('Nummer', ftInteger);
  Result.FieldDefs.Add('Name', ftString, 40);
  Result.FieldDefs.Add('Vornamen', ftString, 40);
  Result.FieldDefs.Add('Gebort', ftString, 40);
  Result.FieldDefs.Add('Taufort', ftString, 40);
  Result.FieldDefs.Add('Stort', ftString, 40);
  Result.FieldDefs.Add('Begort', ftString, 40);
  Result.FieldDefs.Add('Gebjahr', ftString, 4);
  Result.FieldDefs.Add('Taufjahr', ftString, 4);
  Result.FieldDefs.Add('Stjahr', ftString, 4);
  Result.CreateDataset;
end;

function CreateSyntheticMarriageEvents: TPlaceSearchDataSet;
begin
  Result := TPlaceSearchDataSet.Create(nil);
  Result.FieldDefs.Add('Nummer', ftInteger);
  Result.FieldDefs.Add('Saort', ftString, 40);
  Result.FieldDefs.Add('Schort', ftString, 40);
  Result.CreateDataset;
end;

function CreateSyntheticPlaces: TPlaceSearchDataSet;
begin
  Result := TPlaceSearchDataSet.Create(nil);
  Result.FieldDefs.Add('Ort', ftString, 40);
  Result.CreateDataset;
end;

function MissingDataSet(const MemberName: string): TDataSet;
begin
  Result := nil;
  raise Exception.CreateFmt(
    'The synthetic module does not provide %s.', [MemberName]);
end;

function MissingField(const MemberName: string): TField;
begin
  Result := nil;
  raise Exception.CreateFmt(
    'The synthetic module does not provide %s.', [MemberName]);
end;

constructor TFakePlaceSearchDataModule.Create(ATable1, ATable18,
  ATable13: TDataSet);
begin
  inherited Create;
  FTable1 := ATable1;
  FTable18 := ATable18;
  FTable13 := ATable13;
end;

procedure TFakePlaceSearchDataModule.BeginTransaction;
begin
  raise EDataModuleTransactionUnavailable.Create(
    'The place-search fixture does not provide transactions.');
end;

procedure TFakePlaceSearchDataModule.CommitTransaction;
begin
  raise EDataModuleTransactionUnavailable.Create(
    'The place-search fixture does not provide transactions.');
end;

procedure TFakePlaceSearchDataModule.RollbackTransaction;
begin
  raise EDataModuleTransactionUnavailable.Create(
    'The place-search fixture does not provide transactions.');
end;

procedure TFakePlaceSearchDataModule.AppendMarriageRecord(
  const PersonNumber, PartnerNumber: Integer; const Details: TMarriageDetails);
begin
  raise EDataModuleWriteUnavailable.Create(
    'The place-search fixture does not provide marriage writes.');
end;

function TFakePlaceSearchDataModule.GetTable1: TDataSet;
begin
  Result := FTable1;
end;

function TFakePlaceSearchDataModule.GetTable18: TDataSet;
begin
  Result := FTable18;
end;

function TFakePlaceSearchDataModule.GetTable1Nummer: TField;
begin
  Result := FTable1.FieldByName('Nummer');
end;

function TFakePlaceSearchDataModule.GetTable3: TDataSet;
begin
  Result := MissingDataSet('Table3');
end;

function TFakePlaceSearchDataModule.GetTable1Vater: TField;
begin
  Result := MissingField('Table1Vater');
end;

function TFakePlaceSearchDataModule.GetTable1Mutter: TField;
begin
  Result := MissingField('Table1Mutter');
end;

function TFakePlaceSearchDataModule.GetTable1Name: TField;
begin
  Result := MissingField('Table1Name');
end;

function TFakePlaceSearchDataModule.GetTable1Vornamen: TField;
begin
  Result := MissingField('Table1Vornamen');
end;

function TFakePlaceSearchDataModule.GetTable1Religion: TField;
begin
  Result := MissingField('Table1Religion');
end;

function TFakePlaceSearchDataModule.GetTable5: TDataSet;
begin
  Result := MissingDataSet('Table5');
end;

function TFakePlaceSearchDataModule.GetTable5Numr: TField;
begin
  Result := MissingField('Table5Numr');
end;

function TFakePlaceSearchDataModule.GetTable5Epnum: TField;
begin
  Result := MissingField('Table5Epnum');
end;

function TFakePlaceSearchDataModule.GetTable17: TDataSet;
begin
  Result := MissingDataSet('Table17');
end;

function TFakePlaceSearchDataModule.GetTable7: TDataSet;
begin
  Result := MissingDataSet('Table7');
end;

function TFakePlaceSearchDataModule.GetTable8: TDataSet;
begin
  Result := MissingDataSet('Table8');
end;

function TFakePlaceSearchDataModule.GetTable9: TDataSet;
begin
  Result := MissingDataSet('Table9');
end;

function TFakePlaceSearchDataModule.GetTable13: TDataSet;
begin
  if not Assigned(FTable13) then
    Result := MissingDataSet('Table13')
  else
    Result := FTable13;
end;

function TFakePlaceSearchDataModule.GetTable13Ort: TField;
begin
  if not Assigned(FTable13) then
    Result := MissingField('Table13Ort')
  else
    Result := FTable13.FieldByName('Ort');
end;

procedure TFakePlaceSearchDataModule.SetTable13Index(
  const IndexName: string);
begin
  LastTable13Index := IndexName;
  if not SameText(IndexName, 'ort_') then
    raise EUnsupportedGenealogyDataIndex.CreateFmt(
      'Unsupported synthetic Table13 index "%s".', [IndexName]);
  if not (FTable13 is TBufDataset) then
    raise Exception.Create(
      'The synthetic Table13 dataset cannot apply field ordering.');
  TBufDataset(FTable13).IndexFieldNames := 'Ort';
end;

procedure TTestAHW52PlaceSearchSelection.MakeTestFormInvisible(
  form: TCustomForm);
begin
  form.AlphaBlend := True;
  form.AlphaBlendValue := 0;
  form.ShowInTaskBar := stNever;
end;

procedure TTestAHW52PlaceSearchSelection.RecordGlobalFormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  FGlobalValueAtClose := GlobalVar_0061DFC0;
  FItemIndexAtClose := FPlaceSearchForm.ListBox1.ItemIndex;
  CloseAction := caHide;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestListClickCopiesSelectedAndUnselectedIndices;
var
  placeSearchForm: TForm14;
begin
  Application.Initialize;
  placeSearchForm := TForm14.CreateNew(nil);
  try
    placeSearchForm.ListBox1 := TListBox.Create(placeSearchForm);
    placeSearchForm.ListBox1.Items.Add('First synthetic place');
    placeSearchForm.ListBox1.Items.Add('Second synthetic place');
    placeSearchForm.ListBox1.ItemIndex := 1;
    GlobalVar_0061DFC0 := -99;
    placeSearchForm.ListBox1Click(placeSearchForm.ListBox1);

    if GlobalVar_0061DFC0 <> 1 then
      raise Exception.CreateFmt('Expected selected index 1, got %d.',
        [GlobalVar_0061DFC0]);

    placeSearchForm.ListBox1.ItemIndex := -1;
    placeSearchForm.ListBox1Click(placeSearchForm.ListBox1);
    if GlobalVar_0061DFC0 <> -1 then
      raise Exception.CreateFmt('Expected no-selection index -1, got %d.',
        [GlobalVar_0061DFC0]);
  finally
    GlobalVar_0061DFC0 := 0;
    placeSearchForm.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestFinishResetsSelectionBeforeClosingGlobalForm;
var
  receiver: TForm14;
  target: TForm14;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  FGlobalValueAtClose := -1;
  FItemIndexAtClose := -1;
  target := TForm14.CreateNew(nil);
  receiver := TForm14.CreateNew(nil);
  FPlaceSearchForm := receiver;
  try
    receiver.ListBox1 := TListBox.Create(receiver);
    receiver.ListBox1.Items.Add('First synthetic place');
    receiver.ListBox1.Items.Add('Second synthetic place');
    receiver.ListBox1.ItemIndex := 1;
    GlobalVar_0061DFC0 := 42;
    Unit14.Form14 := target;
    MakeTestFormInvisible(target);
    MakeTestFormInvisible(receiver);
    target.OnClose := @RecordGlobalFormClose;
    target.Show;
    receiver.Show;

    receiver.BitBtn1Click(receiver);

    AssertEquals('The saved index should be cleared before close.', 0,
      GlobalVar_0061DFC0);
    AssertEquals('The list selection should be reset before close.', 0,
      receiver.ListBox1.ItemIndex);
    AssertEquals('The global target should receive one close event.', 1,
      FCloseEventCount);
    AssertEquals('The saved index should already be cleared at close.', 0,
      FGlobalValueAtClose);
    AssertEquals('The list selection should already be reset at close.', 0,
      FItemIndexAtClose);
    AssertFalse('The global target should be hidden by the test close action.',
      target.Visible);
    AssertTrue('The method receiver should remain visible.', receiver.Visible);
  finally
    Unit14.Form14 := nil;
    FPlaceSearchForm := nil;
    GlobalVar_0061DFC0 := 0;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestFormActivateSetsPlaceIndexRefillsAndRestoresSelection;
var
  places: TPlaceSearchDataSet;
  placeForm: TForm14;
  fakeDataModule: TFakePlaceSearchDataModule;
  fakeDataModuleInterface: IGenealogyDataModule;
  previousDataModule: IGenealogyDataModule;
  previousSavedIndex: LongInt;
begin
  Application.Initialize;
  previousDataModule := GenealogyDataModuleAccess.GenealogyDataModule;
  previousSavedIndex := GlobalVar_0061DFC0;
  places := CreateSyntheticPlaces;
  places.AppendRecord(['Zwickau']);
  places.AppendRecord(['Berlin']);
  places.AppendRecord(['Aachen']);
  placeForm := TForm14.CreateNew(nil);
  fakeDataModule := TFakePlaceSearchDataModule.Create(nil, nil, places);
  fakeDataModuleInterface := fakeDataModule;
  try
    placeForm.ListBox1 := TListBox.Create(placeForm);
    placeForm.ListBox1.Parent := placeForm;
    placeForm.ListBox1.Items.Add('Old place');
    placeForm.ListBox1.Items.Add('Old selection');
    placeForm.ListBox1.ItemIndex := 1;
    GlobalVar_0061DFC0 := -1;
    GenealogyDataModuleAccess.GenealogyDataModule := fakeDataModuleInterface;

    placeForm.FormActivate(placeForm);

    AssertEquals('The legacy secondary-index request is preserved.',
      'ort_', fakeDataModule.LastTable13Index);
    AssertEquals('Old place entries are replaced by Table13 values.',
      3, placeForm.ListBox1.Items.Count);
    AssertEquals('The Table13 field ordering is applied before traversal.',
      'Aachen', placeForm.ListBox1.Items[0]);
    AssertEquals('The indexed sequence continues in ascending place order.',
      'Berlin', placeForm.ListBox1.Items[1]);
    AssertEquals('The selected list index is remembered before clearing.',
      1, GlobalVar_0061DFC0);
    AssertEquals('The saved selection is restored after list refill.',
      1, placeForm.ListBox1.ItemIndex);
    AssertSame('ListBox1 receives focus after list refill.',
      placeForm.ListBox1, placeForm.ActiveControl);
  finally
    GenealogyDataModuleAccess.GenealogyDataModule := previousDataModule;
    GlobalVar_0061DFC0 := previousSavedIndex;
    fakeDataModuleInterface := nil;
    placeForm.Free;
    places.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestButtonSearchFindsPersonAndMultipleMarriagePlaces;
var
  people: TPlaceSearchDataSet;
  marriageEvents: TPlaceSearchDataSet;
  places: TPlaceSearchDataSet;
  mainForm: TForm1;
  searchForm: TForm14;
  fakeDataModule: IGenealogyDataModule;
  previousDataModule: IGenealogyDataModule;
  previousMainForm: TForm1;
  previousSearchForm: TForm14;
begin
  Application.Initialize;
  previousDataModule := GenealogyDataModuleAccess.GenealogyDataModule;
  previousMainForm := frmAhnenWinMain.Form1;
  previousSearchForm := Unit14.Form14;
  people := CreateSyntheticPeople;
  marriageEvents := CreateSyntheticMarriageEvents;
  places := CreateSyntheticPlaces;
  places.AppendRecord(['Dresden']);
  people.AppendRecord([101, 'Alpha', 'One', 'Dresden', '', '', '',
    '1800', '1802', '1850']);
  people.AppendRecord([102, 'Beta', 'Two', '', '', '', '',
    '', '1770', '']);
  people.AppendRecord([103, 'Gamma', 'Three', '', '', '', '',
    '', '', '']);
  marriageEvents.AppendRecord([102, 'Near Dresden', '']);
  marriageEvents.AppendRecord([999, 'Somewhere else', '']);
  marriageEvents.AppendRecord([102, '', 'Dresden']);
  mainForm := TForm1.Create(nil);
  searchForm := TForm14.Create(nil);
  fakeDataModule := TFakePlaceSearchDataModule.Create(people, marriageEvents,
    places);
  try
    GenealogyDataModuleAccess.GenealogyDataModule := fakeDataModule;
    frmAhnenWinMain.Form1 := mainForm;
    Unit14.Form14 := searchForm;
    people.Locate('Nummer', 103, []);
    searchForm.ListBox1.Items.Add('Dresden');
    searchForm.ListBox1.ItemIndex := 0;
    searchForm.CheckBox1.Checked := False;
    FCloseEventCount := 0;
    FPlaceSearchForm := searchForm;
    searchForm.OnClose := @RecordGlobalFormClose;
    MakeTestFormInvisible(searchForm);
    searchForm.Show;

    searchForm.Button1Click(searchForm);

    AssertEquals('The place search should clear old rows and append two hits.',
      3, mainForm.PersonEditFrame.StringGrid5.RowCount);
    AssertEquals('The selected place should be shown in the result header.',
      'Ort: Dresden', mainForm.PersonEditFrame.StringGrid5.Cells[1, 0]);
    AssertEquals('The first person should match a personal place field.',
      '101', mainForm.PersonEditFrame.StringGrid5.Cells[0, 1]);
    AssertEquals('The first row should preserve the person display name.',
      'Alpha One', mainForm.PersonEditFrame.StringGrid5.Cells[1, 1]);
    AssertEquals('Birth and death years should retain their markers.',
      '* 1800', mainForm.PersonEditFrame.StringGrid5.Cells[2, 1]);
    AssertEquals('+ 1850',
      mainForm.PersonEditFrame.StringGrid5.Cells[3, 1]);
    AssertEquals('The second person should match a noncontiguous marriage row.',
      '102', mainForm.PersonEditFrame.StringGrid5.Cells[0, 2]);
    AssertEquals('A baptism year should be used when no birth year is present.',
      '~ 1770', mainForm.PersonEditFrame.StringGrid5.Cells[2, 2]);
    AssertTrue('A matching search should display the result grid.',
      mainForm.PersonEditFrame.StringGrid5.Visible);
    AssertEquals('The selected Table1 record should be restored through Locate.',
      103, people.FieldByName('Nummer').AsInteger);
    AssertFalse('The global place-search form should be closed.',
      searchForm.Visible);
  finally
    GenealogyDataModuleAccess.GenealogyDataModule := previousDataModule;
    frmAhnenWinMain.Form1 := previousMainForm;
    Unit14.Form14 := previousSearchForm;
    fakeDataModule := nil;
    FPlaceSearchForm := nil;
    searchForm.Free;
    mainForm.Free;
    places.Free;
    marriageEvents.Free;
    people.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestButtonSearchUsesExactCaseSensitivePlaceMatching;
var
  people: TPlaceSearchDataSet;
  marriageEvents: TPlaceSearchDataSet;
  places: TPlaceSearchDataSet;
  mainForm: TForm1;
  searchForm: TForm14;
  fakeDataModule: IGenealogyDataModule;
  previousDataModule: IGenealogyDataModule;
  previousMainForm: TForm1;
  previousSearchForm: TForm14;
begin
  Application.Initialize;
  previousDataModule := GenealogyDataModuleAccess.GenealogyDataModule;
  previousMainForm := frmAhnenWinMain.Form1;
  previousSearchForm := Unit14.Form14;
  people := CreateSyntheticPeople;
  marriageEvents := CreateSyntheticMarriageEvents;
  places := CreateSyntheticPlaces;
  places.AppendRecord(['Dresden']);
  people.AppendRecord([201, 'Alpha', 'One', 'DRESDEN', '', '', '',
    '', '', '']);
  people.AppendRecord([202, 'Beta', 'Two', 'Dresden', '', '', '',
    '', '', '']);
  people.AppendRecord([203, 'Gamma', 'Three', '', '', '', '',
    '', '', '']);
  people.AppendRecord([204, 'Delta', 'Four', '', '', '', '',
    '', '', '']);
  marriageEvents.AppendRecord([203, 'Near Dresden', '']);
  marriageEvents.AppendRecord([204, '', 'Dresden']);
  mainForm := TForm1.Create(nil);
  searchForm := TForm14.Create(nil);
  fakeDataModule := TFakePlaceSearchDataModule.Create(people, marriageEvents,
    places);
  try
    GenealogyDataModuleAccess.GenealogyDataModule := fakeDataModule;
    frmAhnenWinMain.Form1 := mainForm;
    Unit14.Form14 := searchForm;
    people.Locate('Nummer', 203, []);
    searchForm.ListBox1.Items.Add('Dresden');
    searchForm.ListBox1.ItemIndex := 0;
    searchForm.CheckBox1.Checked := True;
    FCloseEventCount := 0;
    FPlaceSearchForm := searchForm;
    searchForm.OnClose := @RecordGlobalFormClose;
    MakeTestFormInvisible(searchForm);
    searchForm.Show;

    searchForm.Button1Click(searchForm);

    AssertEquals('Exact matching should retain only the two exact-case hits.',
      3, mainForm.PersonEditFrame.StringGrid5.RowCount);
    AssertEquals('Case differences should not match exact mode.',
      '202', mainForm.PersonEditFrame.StringGrid5.Cells[0, 1]);
    AssertEquals('Substring-only marriage places should not match exact mode.',
      '204', mainForm.PersonEditFrame.StringGrid5.Cells[0, 2]);
    AssertEquals('The selected Table1 record should be restored.',
      203, people.FieldByName('Nummer').AsInteger);
  finally
    GenealogyDataModuleAccess.GenealogyDataModule := previousDataModule;
    frmAhnenWinMain.Form1 := previousMainForm;
    Unit14.Form14 := previousSearchForm;
    fakeDataModule := nil;
    FPlaceSearchForm := nil;
    searchForm.Free;
    mainForm.Free;
    places.Free;
    marriageEvents.Free;
    people.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestUnboundCounterIncrementPreservesStrings;
var
  placeSearchForm: TForm14;
begin
  placeSearchForm := TForm14.CreateNew(nil);
  try
    GlobalVar_0061DFC4 := 7;
    GlobalVar_0061DFBC := 'First synthetic place';
    GlobalVar_0061DFB8 := 'Second synthetic place';

    placeSearchForm._PROC_0053C87C(placeSearchForm);

    AssertEquals(8, GlobalVar_0061DFC4);
    AssertEquals('First synthetic place', GlobalVar_0061DFBC);
    AssertEquals('Second synthetic place', GlobalVar_0061DFB8);
  finally
    GlobalVar_0061DFC4 := 0;
    GlobalVar_0061DFBC := '';
    GlobalVar_0061DFB8 := '';
    placeSearchForm.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestUnboundCounterIncrementClearsStringsAtZero;
var
  placeSearchForm: TForm14;
begin
  placeSearchForm := TForm14.CreateNew(nil);
  try
    GlobalVar_0061DFC4 := -1;
    GlobalVar_0061DFBC := 'First synthetic place';
    GlobalVar_0061DFB8 := 'Second synthetic place';

    placeSearchForm._PROC_0053C87C(placeSearchForm);

    AssertEquals(0, GlobalVar_0061DFC4);
    AssertEquals('', GlobalVar_0061DFBC);
    AssertEquals('', GlobalVar_0061DFB8);
  finally
    GlobalVar_0061DFC4 := 0;
    GlobalVar_0061DFBC := '';
    GlobalVar_0061DFB8 := '';
    placeSearchForm.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.TestUnboundCounterDecrement;
var
  placeSearchForm: TForm14;
begin
  placeSearchForm := TForm14.CreateNew(nil);
  try
    GlobalVar_0061DFC4 := 7;

    placeSearchForm._PROC_0053C8C0(placeSearchForm);

    AssertEquals(6, GlobalVar_0061DFC4);
  finally
    GlobalVar_0061DFC4 := 0;
    GlobalVar_0061DFBC := '';
    GlobalVar_0061DFB8 := '';
    placeSearchForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PlaceSearchSelection);

end.
