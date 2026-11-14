unit Unit15VorlistRows;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  DB, BufDataset;

/// Copies the Table14 Vorlist fields into Unit15 report field names.
/// The source must be active and in browse state; the caller owns both datasets.
function CreateUnit15VorlistRows(ASource: TDataSet): TBufDataset;

implementation

uses
  SysUtils;

const
  RequiredReportFieldCount = 15;

procedure ValidateVorlistSource(ASource: TDataSet);
var
  zeileField: TField;
  nmField: TField;
begin
  if ASource = nil then
    raise EArgumentNilException.Create('ASource');
  if not ASource.Active then
    raise EDatabaseError.Create(
      'The Unit15 Vorlist projection requires an active dataset.');
  if ASource.State <> dsBrowse then
    raise EDatabaseError.Create(
      'The Unit15 Vorlist projection requires a dataset in browse state.');

  zeileField := ASource.FindField('Zeile');
  if zeileField = nil then
    raise EDatabaseError.Create(
      'The Table14 Vorlist dataset is missing field "Zeile".');
  if zeileField.DataType <> ftMemo then
    raise EDatabaseError.Create(
      'The Table14 Vorlist field "Zeile" must be a memo field.');

  nmField := ASource.FindField('Nm');
  if nmField = nil then
    raise EDatabaseError.Create(
      'The Table14 Vorlist dataset is missing field "Nm".');
  if nmField.DataType <> ftString then
    raise EDatabaseError.Create(
      'The Table14 Vorlist field "Nm" must be a string field.');
end;

function CreateUnit15VorlistRows(ASource: TDataSet): TBufDataset;
var
  fieldIndex: Integer;
  bookmark: TBookmark;
  zeileField: TField;
  nmField: TField;
begin
  ValidateVorlistSource(ASource);
  zeileField := ASource.FindField('Zeile');
  nmField := ASource.FindField('Nm');

  Result := TBufDataset.Create(nil);
  try
    Result.Name := 'Unit15VorlistRows';
    Result.FieldDefs.Add('QRDBText1', ftMemo);
    Result.FieldDefs.Add('QRDBText2', ftString, 255);
    for fieldIndex := 3 to RequiredReportFieldCount do
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
          Result.FieldByName('QRDBText2').AsString := nmField.DisplayText;
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
