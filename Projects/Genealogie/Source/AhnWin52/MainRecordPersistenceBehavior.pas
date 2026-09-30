unit MainRecordPersistenceBehavior;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  DB, SysUtils;

type
  TPersonInsertOutcome = (pioNoAction, pioDuplicateNumber, pioPosted);

/// Posts then deletes a person row when its legacy pre-key state has no names.
function DeleteEmptyPersonRecordIfNeeded(DataSet: TDataSet;
  const LastName, GivenNames: string): Boolean;

/// Looks up a person number through the active dataset using the evidenced key field.
function PersonNumberExists(DataSet: TDataSet; const Number: Integer): Boolean;

/// Posts an inserted person only when its number is not already present.
function PostPersonIfNumberAvailable(PersonDataSet, NumberLookupDataSet: TDataSet;
  const Number: Integer): TPersonInsertOutcome;

implementation

function DeleteEmptyPersonRecordIfNeeded(DataSet: TDataSet;
  const LastName, GivenNames: string): Boolean;
begin
  if DataSet = nil then
    raise EArgumentNilException.Create('DataSet');

  Result := (Ord(DataSet.State) < Ord(dsSetKey)) and (LastName = '') and
    (GivenNames = '');
  if Result then
  begin
    // FPC raises for Post in browse mode; the original Delphi call is a no-op there.
    if DataSet.State in dsEditModes then
      DataSet.Post;
    DataSet.Delete;
  end;
end;

function PersonNumberExists(DataSet: TDataSet; const Number: Integer): Boolean;
begin
  if DataSet = nil then
    raise EArgumentNilException.Create('DataSet');

  Result := DataSet.Locate('Nummer', Number, []);
end;

function PostPersonIfNumberAvailable(PersonDataSet,
  NumberLookupDataSet: TDataSet; const Number: Integer): TPersonInsertOutcome;
begin
  if PersonDataSet = nil then
    raise EArgumentNilException.Create('PersonDataSet');
  if PersonDataSet.State <> dsInsert then
    Exit(pioNoAction);

  if PersonNumberExists(NumberLookupDataSet, Number) then
    Exit(pioDuplicateNumber);

  PersonDataSet.Post;
  Result := pioPosted;
end;

end.
