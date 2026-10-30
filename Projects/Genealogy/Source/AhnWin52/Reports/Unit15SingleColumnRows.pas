unit Unit15SingleColumnRows;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  DB, BufDataset;

/// Copies Table14 Zeile values into the single-column Unit15 report schema.
/// The source must be active and in browse state; the caller owns both datasets.
function CreateUnit15SingleColumnRows(ASource: TDataSet): TBufDataset;

implementation

uses
  SysUtils;

const
  RequiredReportFieldCount = 15;

procedure ValidateSingleColumnSource(ASource: TDataSet);
var
  zeileField: TField;
begin
  if ASource = nil then
    raise EArgumentNilException.Create('ASource');
  if not ASource.Active then
    raise EDatabaseError.Create(
      'The Unit15 single-column projection requires an active dataset.');
  if ASource.State <> dsBrowse then
    raise EDatabaseError.Create(
      'The Unit15 single-column projection requires a dataset in browse state.');

  zeileField := ASource.FindField('Zeile');
  if zeileField = nil then
    raise EDatabaseError.Create(
      'The Table14 single-column dataset is missing field "Zeile".');
  if zeileField.DataType <> ftMemo then
    raise EDatabaseError.Create(
      'The Table14 single-column field "Zeile" must be a memo field.');
end;

function CreateUnit15SingleColumnRows(ASource: TDataSet): TBufDataset;
var
  fieldIndex: Integer;
  bookmark: TBookmark;
  zeileField: TField;
begin
  ValidateSingleColumnSource(ASource);
  zeileField := ASource.FindField('Zeile');

  Result := TBufDataset.Create(nil);
  try
    Result.Name := 'Unit15SingleColumnRows';
    Result.FieldDefs.Add('QRDBText1', ftMemo);
    for fieldIndex := 2 to RequiredReportFieldCount do
      Result.FieldDefs.Add(Format('QRDBText%d', [fieldIndex]), ftString, 255);
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
          Result.FieldByName('QRDBText1').AsString := zeileField.AsString;
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
