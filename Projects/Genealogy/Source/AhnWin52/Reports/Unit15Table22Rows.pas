unit Unit15Table22Rows;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  DB, BufDataset;

/// Copies the Table22 register fields into Unit15 report field names.
/// The source must be active and in browse state; the caller owns both datasets.
function CreateUnit15Table22Rows(ASource: TDataSet): TBufDataset;

implementation

uses
  SysUtils;

const
  RequiredReportFieldCount = 15;

procedure ValidateTable22Source(ASource: TDataSet);
var
  zusField: TField;
  noField: TField;
begin
  if ASource = nil then
    raise EArgumentNilException.Create('ASource');
  if not ASource.Active then
    raise EDatabaseError.Create(
      'The Unit15 Table22 projection requires an active dataset.');
  if ASource.State <> dsBrowse then
    raise EDatabaseError.Create(
      'The Unit15 Table22 projection requires a dataset in browse state.');

  zusField := ASource.FindField('Zus');
  if zusField = nil then
    raise EDatabaseError.Create(
      'The Table22 dataset is missing field "Zus".');
  if zusField.DataType <> ftMemo then
    raise EDatabaseError.Create(
      'The Table22 field "Zus" must be a memo field.');

  noField := ASource.FindField('No');
  if noField = nil then
    raise EDatabaseError.Create(
      'The Table22 dataset is missing field "No".');
  if noField.DataType <> ftString then
    raise EDatabaseError.Create(
      'The Table22 field "No" must be a string field.');
end;

function CreateUnit15Table22Rows(ASource: TDataSet): TBufDataset;
var
  fieldIndex: Integer;
  bookmark: TBookmark;
  zusField: TField;
  noField: TField;
begin
  ValidateTable22Source(ASource);
  zusField := ASource.FindField('Zus');
  noField := ASource.FindField('No');

  Result := TBufDataset.Create(nil);
  try
    Result.Name := 'Unit15Table22Rows';
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
          Result.FieldByName('QRDBText1').AsString := zusField.AsString;
          Result.FieldByName('QRDBText2').AsString := noField.DisplayText;
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
