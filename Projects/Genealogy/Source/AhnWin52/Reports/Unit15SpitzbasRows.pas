unit Unit15SpitzbasRows;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  DB, BufDataset;

/// Copies the Table27 spitzbas fields into Unit15 report field names.
/// The source must be active and in browse state; the caller owns both datasets.
function CreateUnit15SpitzbasRows(ASource: TDataSet): TBufDataset;

implementation

uses
  SysUtils;

const
  RequiredReportFieldCount = 15;

procedure ValidateSpitzbasSource(ASource: TDataSet);
var
  field: TField;
begin
  if ASource = nil then
    raise EArgumentNilException.Create('ASource');
  if not ASource.Active then
    raise EDatabaseError.Create(
      'The Unit15 spitzbas projection requires an active dataset.');
  if ASource.State <> dsBrowse then
    raise EDatabaseError.Create(
      'The Unit15 spitzbas projection requires a dataset in browse state.');

  field := ASource.FindField('Namvorn');
  if field = nil then
    raise EDatabaseError.Create(
      'The Table27 spitzbas dataset is missing field "Namvorn".');
  if field.DataType <> ftString then
    raise EDatabaseError.Create(
      'The Table27 spitzbas field "Namvorn" must be a string field.');

  field := ASource.FindField('Kn');
  if field = nil then
    raise EDatabaseError.Create(
      'The Table27 spitzbas dataset is missing field "Kn".');
  if field.DataType <> ftString then
    raise EDatabaseError.Create(
      'The Table27 spitzbas field "Kn" must be a string field.');
end;

function CreateUnit15SpitzbasRows(ASource: TDataSet): TBufDataset;
var
  fieldIndex: Integer;
  bookmark: TBookmark;
  namvornField: TField;
  knField: TField;
begin
  ValidateSpitzbasSource(ASource);
  namvornField := ASource.FindField('Namvorn');
  knField := ASource.FindField('Kn');

  Result := TBufDataset.Create(nil);
  try
    Result.Name := 'Unit15SpitzbasRows';
    Result.FieldDefs.Add('QRDBText1', ftString, 255);
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
          Result.FieldByName('QRDBText1').AsString :=
            namvornField.DisplayText;
          Result.FieldByName('QRDBText2').AsString := knField.DisplayText;
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
