unit cmp_SQLTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB;

type

  TSQLTable = class;

  { TSQLTableIndex }

  TSQLTableIndex = class(TCollectionItem)
  private
    FName: string;
    FFields: string;
    FDescFields: string;
    procedure SetName(const AValue: string);
    procedure SetFields(const AValue: string);
    procedure SetDescFields(const AValue: string);
  published
    property Name: string read FName write SetName;
    property Fields: string read FFields write SetFields;
    property DescFields: string read FDescFields write SetDescFields;
  end;

  { TSQLTableIndexes }

  TSQLTableIndexes = class(TCollection)
  private
    FTable: TSQLTable;
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(ATable: TSQLTable);
    function Add(const AName, AFields: string;
      const ADescFields: string = ''): TSQLTableIndex; reintroduce; overload;
    function Find(const AName: string): TSQLTableIndex;
  end;

  { TSQLTable }

  TSQLTable = class(TCustomSQLQuery)
    property SchemaType;
    Property StatementType;
  private
    FMasterFields: String;
    FMasterSource: TDataSource;
    FTableName: string;
    FIndexName: string;
    FIndexes: TSQLTableIndexes;
    procedure SetMasterFields(AValue: String);
    procedure SetMasterSource(AValue: TDataSource);
    procedure SetTableName(AValue: string);
    procedure SetIndexName(const AValue: string);
    function BuildTableSQL: string;
    procedure ApplyIndexOrder;
    procedure IndexDefinitionsChanged(Item: TCollectionItem);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  Published
    property MaxIndexesCount;
   // TDataset stuff
    property FieldDefs;
    Property Active;
    Property AutoCalcFields;
    Property Filter;
    Property Filtered;
    Property FilterOptions;
    Property AfterCancel;
    Property AfterClose;
    Property AfterDelete;
    Property AfterEdit;
    Property AfterInsert;
    Property AfterOpen;
    Property AfterPost;
    Property AfterScroll;
    Property BeforeCancel;
    Property BeforeClose;
    Property BeforeDelete;
    Property BeforeEdit;
    Property BeforeInsert;
    Property BeforeOpen;
    Property BeforePost;
    Property BeforeScroll;
    Property OnCalcFields;
    Property OnDeleteError;
    Property OnEditError;
    Property OnFilterRecord;
    Property OnNewRecord;
    Property OnPostError;

    //    property SchemaInfo default stNoSchema;
    property MasterFields:String read FMasterFields write SetMasterFields;
    property MasterSource:TDataSource read FMasterSource write SetMasterSource;
    property Database;
    property Transaction;
    property ReadOnly;
    property TableName:string read FTableName write SetTableName;
    property IndexName: string read FIndexName write SetIndexName;
    property Indexes: TSQLTableIndexes read FIndexes;
    property IndexDefs;
    property ParseSQL;
    property UpdateMode;
    property UsePrimaryKeyAsKey;
    Property DataSource;
    property ServerFilter;
    property ServerFiltered;
    property ServerIndexDefs;
  end;

procedure Register;

implementation

procedure TSQLTableIndex.SetName(const AValue: string);
var
  Existing: TSQLTableIndex;
begin
  if FName = AValue then
    Exit;
  if (AValue <> '') and (Collection is TSQLTableIndexes) then
  begin
    Existing := TSQLTableIndexes(Collection).Find(AValue);
    if Assigned(Existing) and (Existing <> Self) then
      raise EDatabaseError.CreateFmt(
        'An index named "%s" is already defined.', [AValue]);
  end;
  FName := AValue;
  Changed(False);
end;

procedure TSQLTableIndex.SetFields(const AValue: string);
begin
  if FFields = AValue then
    Exit;
  FFields := AValue;
  Changed(False);
end;

procedure TSQLTableIndex.SetDescFields(const AValue: string);
begin
  if FDescFields = AValue then
    Exit;
  FDescFields := AValue;
  Changed(False);
end;

constructor TSQLTableIndexes.Create(ATable: TSQLTable);
begin
  inherited Create(TSQLTableIndex);
  FTable := ATable;
end;

function TSQLTableIndexes.GetOwner: TPersistent;
begin
  Result := FTable;
end;

procedure TSQLTableIndexes.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FTable) then
    FTable.IndexDefinitionsChanged(Item);
end;

function TSQLTableIndexes.Add(const AName, AFields: string;
  const ADescFields: string): TSQLTableIndex;
begin
  if Trim(AName) = '' then
    raise EDatabaseError.Create('An SQL table index name is required.');
  if Trim(AFields) = '' then
    raise EDatabaseError.CreateFmt(
      'Index "%s" must define at least one field.', [AName]);
  if Assigned(Find(AName)) then
    raise EDatabaseError.CreateFmt(
      'An index named "%s" is already defined.', [AName]);

  Result := inherited Add as TSQLTableIndex;
  Result.Name := AName;
  Result.Fields := AFields;
  Result.DescFields := ADescFields;
end;

function TSQLTableIndexes.Find(const AName: string): TSQLTableIndex;
var
  Index: Integer;
  Item: TSQLTableIndex;
begin
  for Index := 0 to Count - 1 do
  begin
    Item := Items[Index] as TSQLTableIndex;
    if SameText(Item.Name, AName) then
      Exit(Item);
  end;
  Result := nil;
end;

procedure Register;
begin
  RegisterComponents('SQLDB',[TSQLTable]);
end;

{ TSQLTable }

constructor TSQLTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIndexes := TSQLTableIndexes.Create(Self);
end;

destructor TSQLTable.Destroy;
begin
  FreeAndNil(FIndexes);
  inherited Destroy;
end;

procedure TSQLTable.Loaded;
begin
  inherited Loaded;
  if (FIndexName <> '') and not Assigned(FIndexes.Find(FIndexName)) then
    raise EDatabaseError.CreateFmt(
      'Index "%s" is not defined for table "%s".',
      [FIndexName, FTableName]);
  ApplyIndexOrder;
end;

procedure TSQLTable.SetTableName(AValue: string);
begin
  if FTableName=AValue then Exit;
  if Active then
    raise EDatabaseError.Create(
      'Cannot change TableName while the dataset is active.');
  FTableName:=AValue;
  ApplyIndexOrder;
end;

procedure TSQLTable.SetIndexName(const AValue: string);
var
  WasActive: Boolean;
  PreviousIndexName: string;
  ValidatedSQL: string;
begin
  if FIndexName = AValue then
    Exit;
  if (AValue <> '') and not (csLoading in ComponentState) and
    not Assigned(FIndexes.Find(AValue)) then
    raise EDatabaseError.CreateFmt(
      'Index "%s" is not defined for table "%s".',
      [AValue, FTableName]);
  if csLoading in ComponentState then
  begin
    FIndexName := AValue;
    Exit;
  end;
  PreviousIndexName := FIndexName;
  FIndexName := AValue;
  try
    ValidatedSQL := BuildTableSQL;
  except
    FIndexName := PreviousIndexName;
    raise;
  end;
  FIndexName := PreviousIndexName;
  WasActive := Active;
  if WasActive then
    Close;
  FIndexName := AValue;
  if ValidatedSQL <> '' then
    SQL.Text := ValidatedSQL;
  if WasActive then
    Open;
end;

function TSQLTable.BuildTableSQL: string;
var
  IndexDef: TSQLTableIndex;
  FieldList: TStringList;
  DescFields: TStringList;
  FieldIndex: Integer;
  FieldName: string;
  UpperFieldName: string;
  IsDescending: Boolean;
  OrderBy: string;

  function IsIdentifier(const Value: string): Boolean;
  var
    CharIndex: Integer;
    Ch: Char;
  begin
    Result := Value <> '';
    for CharIndex := 1 to Length(Value) do
    begin
      Ch := Value[CharIndex];
      if not (Ch in ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
        Exit(False);
    end;
    Result := not (Value[1] in ['0'..'9']);
  end;

begin
  Result := '';
  if FTableName = '' then
    Exit;
  Result := 'select * from ' + FTableName;
  if FIndexName = '' then
  begin
    Result := Result + ';';
    Exit;
  end;

  IndexDef := FIndexes.Find(FIndexName);
  if not Assigned(IndexDef) then
    raise EDatabaseError.CreateFmt(
      'Index "%s" is not defined for table "%s".',
      [FIndexName, FTableName]);

  FieldList := TStringList.Create;
  DescFields := TStringList.Create;
  try
    FieldList.CaseSensitive := False;
    DescFields.CaseSensitive := False;
    DescFields.Sorted := False;
    DescFields.Duplicates := dupIgnore;
    ExtractStrings([';'], [], PChar(IndexDef.Fields), FieldList);
    ExtractStrings([';'], [], PChar(IndexDef.DescFields), DescFields);
    if FieldList.Count = 0 then
      raise EDatabaseError.CreateFmt(
        'Index "%s" must define at least one field.', [IndexDef.Name]);

    OrderBy := '';
    for FieldIndex := 0 to FieldList.Count - 1 do
    begin
      FieldName := Trim(FieldList[FieldIndex]);
      UpperFieldName := UpperCase(FieldName);
      IsDescending := False;
      if (Length(UpperFieldName) > 5) and
        (Copy(UpperFieldName, Length(UpperFieldName) - 4, 5) = ' DESC') then
      begin
        FieldName := Copy(FieldName, 1, Length(FieldName) - 5);
        FieldName := Trim(FieldName);
        IsDescending := True;
      end
      else if (Length(UpperFieldName) > 4) and
        (Copy(UpperFieldName, Length(UpperFieldName) - 3, 4) = ' ASC') then
      begin
        FieldName := Copy(FieldName, 1, Length(FieldName) - 4);
        FieldName := Trim(FieldName);
      end;

      if not IsIdentifier(FieldName) then
        raise EDatabaseError.CreateFmt(
          'Invalid field "%s" in index "%s".',
          [FieldName, IndexDef.Name]);
      if FieldList.IndexOf(FieldName) < FieldIndex then
        raise EDatabaseError.CreateFmt(
          'Field "%s" occurs more than once in index "%s".',
          [FieldName, IndexDef.Name]);
      FieldList[FieldIndex] := FieldName;
      if DescFields.IndexOf(FieldName) >= 0 then
        IsDescending := True;

      if OrderBy <> '' then
        OrderBy := OrderBy + ', ';
      OrderBy := OrderBy + FieldName;
      if IsDescending then
        OrderBy := OrderBy + ' DESC';
    end;
    for FieldIndex := 0 to DescFields.Count - 1 do
    begin
      if not IsIdentifier(Trim(DescFields[FieldIndex])) then
        raise EDatabaseError.CreateFmt(
          'Invalid descending field "%s" in index "%s".',
          [DescFields[FieldIndex], IndexDef.Name]);
      DescFields[FieldIndex] := Trim(DescFields[FieldIndex]);
      if FieldList.IndexOf(DescFields[FieldIndex]) < 0 then
        raise EDatabaseError.CreateFmt(
          'Descending field "%s" is not part of index "%s".',
          [DescFields[FieldIndex], IndexDef.Name]);
    end;
    Result := Result + ' order by ' + OrderBy + ';';
  finally
    DescFields.Free;
    FieldList.Free;
  end;
end;

procedure TSQLTable.ApplyIndexOrder;
var
  WasActive: Boolean;
  QueryText: string;
begin
  if csLoading in ComponentState then
    Exit;
  QueryText := BuildTableSQL;
  if QueryText = '' then
    Exit;
  WasActive := Active;
  if WasActive then
    Close;
  SQL.Text := QueryText;
  if WasActive then
    Open;
end;

procedure TSQLTable.IndexDefinitionsChanged(Item: TCollectionItem);
var
  SelectedIndex: TSQLTableIndex;
begin
  if csLoading in ComponentState then
    Exit;
  if FIndexName = '' then
    Exit;
  SelectedIndex := FIndexes.Find(FIndexName);
  if not Assigned(SelectedIndex) or (SelectedIndex = Item) then
    ApplyIndexOrder;
end;

procedure TSQLTable.SetMasterFields(AValue: String);
begin
  if FMasterFields=AValue then Exit;
  FMasterFields:=AValue;
end;

procedure TSQLTable.SetMasterSource(AValue: TDataSource);
begin
  if FMasterSource=AValue then Exit;
  FMasterSource:=AValue;
end;

end.
