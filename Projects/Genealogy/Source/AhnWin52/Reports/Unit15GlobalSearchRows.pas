unit Unit15GlobalSearchRows;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  DB, BufDataset;

/// Copies the global-search Table16 view into the fifteen Unit15 field names.
/// The source must be active and in browse state; the caller owns both datasets.
function CreateUnit15GlobalSearchRows(ASource: TDataSet): TBufDataset;

implementation

uses
  SysUtils;

const
  GlobalSearchSourceFields: array[0..14] of string = (
    'Name', 'Nummer', 'Gebtag', 'Gebmonat', 'Gebjahr', 'Gebort',
    'Sttag', 'Stmonat', 'Stjahr', 'Stort', 'Htag', 'Hmonat', 'Hjahr',
    'Hort', 'Hname');

procedure ValidateGlobalSearchSource(ASource: TDataSet);
var
  fieldIndex: Integer;
begin
  if ASource = nil then
    raise EArgumentNilException.Create('ASource');
  if not ASource.Active then
    raise EDatabaseError.Create(
      'The Unit15 global-search projection requires an active dataset.');
  if ASource.State <> dsBrowse then
    raise EDatabaseError.Create(
      'The Unit15 global-search projection requires a dataset in browse state.');

  for fieldIndex := Low(GlobalSearchSourceFields) to
    High(GlobalSearchSourceFields) do
    if ASource.FindField(GlobalSearchSourceFields[fieldIndex]) = nil then
      raise EDatabaseError.CreateFmt(
        'The Table16 global-search dataset is missing field "%s".',
        [GlobalSearchSourceFields[fieldIndex]]);
end;

function CreateUnit15GlobalSearchRows(ASource: TDataSet): TBufDataset;
var
  fieldIndex: Integer;
  bookmark: TBookmark;
  sourceField: TField;
begin
  ValidateGlobalSearchSource(ASource);

  Result := TBufDataset.Create(nil);
  try
    Result.Name := 'Unit15GlobalSearchRows';
    for fieldIndex := Low(GlobalSearchSourceFields) to
      High(GlobalSearchSourceFields) do
      Result.FieldDefs.Add(Format('QRDBText%d', [fieldIndex + 1]),
        ftString, 255);
    Result.CreateDataset;
    Result.Open;

    if not ASource.IsEmpty then
    begin
      bookmark := ASource.GetBookmark;
      try
        ASource.First;
        while not ASource.EOF do
        begin
          Result.Append;
          for fieldIndex := Low(GlobalSearchSourceFields) to
            High(GlobalSearchSourceFields) do
          begin
            sourceField := ASource.FindField(
              GlobalSearchSourceFields[fieldIndex]);
            Result.FieldByName(Format('QRDBText%d', [fieldIndex + 1]))
              .AsString := sourceField.DisplayText;
          end;
          Result.Post;
          ASource.Next;
        end;
      finally
        try
          if ASource.BookmarkValid(bookmark) then
            ASource.GotoBookmark(bookmark);
        finally
          ASource.FreeBookmark(bookmark);
        end;
      end;
    end;
    Result.First;
  except
    Result.Free;
    raise;
  end;
end;

end.
