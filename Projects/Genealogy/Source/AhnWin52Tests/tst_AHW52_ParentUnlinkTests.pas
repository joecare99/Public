unit tst_AHW52_ParentUnlinkTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52ParentUnlink = class(TTestCase)
  published
    procedure TestCaseConfirmedFatherUnlink;
    procedure TestCaseConfirmedMotherUnlink;
    procedure TestCaseCancellationDoesNotMutatePerson;
    procedure TestCaseMutationFailurePropagates;
    procedure TestCaseInvalidActionsAreRejected;
  end;

implementation

uses
  Classes, SysUtils, DB, MemDS, ParentUnlinkBehavior;

type
  TRecordingParentUnlinkActions = class(TInterfacedObject,
    IParentUnlinkActions)
  private
    FCalls: TStringList;
    FConfirmed: Boolean;
    FDataSet: TMemDataset;
    FFailAt: string;
    FLastParent: TParentRole;
    FLastDisplayText: string;
    procedure RecordCall(const Name: string);
  public
    constructor Create(const DataSet: TMemDataset; const Confirmed: Boolean;
      const FailAt: string = '');
    destructor Destroy; override;
    function ConfirmParentUnlink(const Parent: TParentRole;
      const DisplayText: string): Boolean;
    procedure EditCurrentPerson;
    procedure ClearParentReference(const Parent: TParentRole);
    procedure PostCurrentPerson;
    procedure RefreshMainView;
    property Calls: TStringList read FCalls;
    property LastParent: TParentRole read FLastParent;
    property LastDisplayText: string read FLastDisplayText;
  end;

constructor TRecordingParentUnlinkActions.Create(const DataSet: TMemDataset;
  const Confirmed: Boolean; const FailAt: string);
begin
  inherited Create;
  if DataSet = nil then
    raise EArgumentNilException.Create('DataSet');
  FCalls := TStringList.Create;
  FDataSet := DataSet;
  FConfirmed := Confirmed;
  FFailAt := FailAt;
end;

destructor TRecordingParentUnlinkActions.Destroy;
begin
  FCalls.Free;
  inherited Destroy;
end;

procedure TRecordingParentUnlinkActions.RecordCall(const Name: string);
begin
  FCalls.Add(Name);
  if Name = FFailAt then
    raise Exception.CreateFmt('Injected failure at %s.', [Name]);
end;

function TRecordingParentUnlinkActions.ConfirmParentUnlink(
  const Parent: TParentRole; const DisplayText: string): Boolean;
begin
  FLastParent := Parent;
  FLastDisplayText := DisplayText;
  case Parent of
    prFather: RecordCall('confirm-father');
    prMother: RecordCall('confirm-mother');
  end;
  Result := FConfirmed;
end;

procedure TRecordingParentUnlinkActions.EditCurrentPerson;
begin
  RecordCall('edit-current-person');
  FDataSet.Edit;
end;

procedure TRecordingParentUnlinkActions.ClearParentReference(
  const Parent: TParentRole);
begin
  case Parent of
    prFather:
      begin
        RecordCall('clear-father');
        FDataSet.FieldByName('VATER').AsInteger := 0;
      end;
    prMother:
      begin
        RecordCall('clear-mother');
        FDataSet.FieldByName('MUTTER').AsInteger := 0;
      end;
  end;
end;

procedure TRecordingParentUnlinkActions.PostCurrentPerson;
begin
  RecordCall('post-current-person');
  FDataSet.Post;
end;

procedure TRecordingParentUnlinkActions.RefreshMainView;
begin
  RecordCall('refresh-main-view');
end;

procedure AssertEqual(const Description, Expected, Actual: string);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected "%s", got "%s".',
      [Description, Expected, Actual]);
end;

procedure AssertSequence(Actions: TRecordingParentUnlinkActions;
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

function CreateSyntheticPerson: TMemDataset;
begin
  Result := TMemDataset.Create(nil);
  Result.FieldDefs.Add('NUMMER', ftInteger);
  Result.FieldDefs.Add('VATER', ftInteger);
  Result.FieldDefs.Add('MUTTER', ftInteger);
  Result.CreateTable;
  Result.Open;
  Result.AppendRecord([1001, 2001, 3001]);
  Result.First;
end;

procedure TestConfirmedFatherUnlink;
var
  DataSet: TMemDataset;
  ActionObject: TRecordingParentUnlinkActions;
  Actions: IParentUnlinkActions;
begin
  DataSet := CreateSyntheticPerson;
  try
    ActionObject := TRecordingParentUnlinkActions.Create(DataSet, True);
    Actions := ActionObject;
    if not ExecuteParentUnlink(Actions, prFather, 'Vater: Synthetic Father') then
      raise Exception.Create('Confirmed father unlink returned False.');

    AssertEqual('Father reference was cleared', '0',
      DataSet.FieldByName('VATER').AsString);
    AssertEqual('Mother reference was preserved', '3001',
      DataSet.FieldByName('MUTTER').AsString);
    if ActionObject.LastParent <> prFather then
      raise Exception.Create('Father removal confirmed the wrong parent role.');
    AssertEqual('Displayed parent text forwarded', 'Vater: Synthetic Father',
      ActionObject.LastDisplayText);
    AssertSequence(ActionObject, [
      'confirm-father',
      'edit-current-person',
      'clear-father',
      'post-current-person',
      'refresh-main-view'
    ]);
    Actions := nil;
  finally
    DataSet.Free;
  end;
end;

procedure TestConfirmedMotherUnlink;
var
  DataSet: TMemDataset;
  ActionObject: TRecordingParentUnlinkActions;
  Actions: IParentUnlinkActions;
begin
  DataSet := CreateSyntheticPerson;
  try
    ActionObject := TRecordingParentUnlinkActions.Create(DataSet, True);
    Actions := ActionObject;
    if not ExecuteParentUnlink(Actions, prMother, 'Mutter: Synthetic Mother') then
      raise Exception.Create('Confirmed mother unlink returned False.');

    AssertEqual('Father reference was preserved', '2001',
      DataSet.FieldByName('VATER').AsString);
    AssertEqual('Mother reference was cleared', '0',
      DataSet.FieldByName('MUTTER').AsString);
    if ActionObject.LastParent <> prMother then
      raise Exception.Create('Mother removal confirmed the wrong parent role.');
    AssertEqual('Displayed parent text forwarded', 'Mutter: Synthetic Mother',
      ActionObject.LastDisplayText);
    AssertSequence(ActionObject, [
      'confirm-mother',
      'edit-current-person',
      'clear-mother',
      'post-current-person',
      'refresh-main-view'
    ]);
    Actions := nil;
  finally
    DataSet.Free;
  end;
end;

procedure TestCancellationDoesNotMutatePerson;
var
  DataSet: TMemDataset;
  ActionObject: TRecordingParentUnlinkActions;
  Actions: IParentUnlinkActions;
begin
  DataSet := CreateSyntheticPerson;
  try
    ActionObject := TRecordingParentUnlinkActions.Create(DataSet, False);
    Actions := ActionObject;
    if ExecuteParentUnlink(Actions, prFather, 'Vater: Synthetic Father') then
      raise Exception.Create('Cancelled father unlink returned True.');

    AssertEqual('Father reference after cancellation', '2001',
      DataSet.FieldByName('VATER').AsString);
    AssertEqual('Mother reference after cancellation', '3001',
      DataSet.FieldByName('MUTTER').AsString);
    AssertSequence(ActionObject, [
      'confirm-father',
      'refresh-main-view'
    ]);
    Actions := nil;
  finally
    DataSet.Free;
  end;
end;

procedure TestMutationFailurePropagates;
var
  DataSet: TMemDataset;
  ActionObject: TRecordingParentUnlinkActions;
  Actions: IParentUnlinkActions;
  Raised: Boolean;
begin
  DataSet := CreateSyntheticPerson;
  try
    ActionObject := TRecordingParentUnlinkActions.Create(DataSet, True,
      'clear-mother');
    Actions := ActionObject;
    Raised := False;
    try
      ExecuteParentUnlink(Actions, prMother, 'Mutter: Synthetic Mother');
    except
      on E: Exception do
        Raised := True;
    end;

    if not Raised then
      raise Exception.Create('Parent-field mutation failure was swallowed.');
    AssertEqual('Mother reference before failed clear', '3001',
      DataSet.FieldByName('MUTTER').AsString);
    AssertSequence(ActionObject, [
      'confirm-mother',
      'edit-current-person',
      'clear-mother'
    ]);
    Actions := nil;
  finally
    DataSet.Free;
  end;
end;

procedure TestInvalidActionsAreRejected;
var
  Raised: Boolean;
begin
  Raised := False;
  try
    ExecuteParentUnlink(nil, prFather, '');
  except
    on E: EArgumentNilException do
      Raised := True;
  end;

  if not Raised then
    raise Exception.Create('Nil parent-unlink actions were accepted.');
end;

procedure TTestAHW52ParentUnlink.TestCaseConfirmedFatherUnlink;
begin
    TestConfirmedFatherUnlink;
end;

procedure TTestAHW52ParentUnlink.TestCaseConfirmedMotherUnlink;
begin
    TestConfirmedMotherUnlink;
end;

procedure TTestAHW52ParentUnlink.TestCaseCancellationDoesNotMutatePerson;
begin
    TestCancellationDoesNotMutatePerson;
end;

procedure TTestAHW52ParentUnlink.TestCaseMutationFailurePropagates;
begin
    TestMutationFailurePropagates;
end;

procedure TTestAHW52ParentUnlink.TestCaseInvalidActionsAreRejected;
begin
    TestInvalidActionsAreRejected;
end;

initialization
  RegisterTest(TTestAHW52ParentUnlink);

end.
