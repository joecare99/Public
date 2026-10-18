unit Unit3RegisterRows;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, DB, BufDataset;

type
  TUnit3RegisterKind = (urkNameRegister, urkPlaceRegister);

/// Builds the in-memory Table22 rows from the supplied register strings.
/// This does not run the legacy provider-backed list producers.
function CreateUnit3RegisterRows(AEntries: TStrings;
  AKind: TUnit3RegisterKind): TBufDataset;

implementation

uses
  SysUtils;

const
  RegisterSeparator = #15;

function CreateUnit3RegisterRows(AEntries: TStrings;
  AKind: TUnit3RegisterKind): TBufDataset;
var
  entryIndex: Integer;
  separatorIndex: SizeInt;
  entryText: string;
  entryKey: string;
  entryValue: string;
  previousKey: string;
  currentValue: string;
begin
  if AEntries = nil then
    raise EArgumentNilException.Create('AEntries');

  Result := TBufDataset.Create(nil);
  try
    Result.Name := 'Unit3RegisterRows';
    Result.FieldDefs.Add('No', ftString, 50);
    Result.FieldDefs.Add('Zus', ftMemo);
    Result.CreateDataset;
    Result.Open;

    previousKey := '';
    for entryIndex := 0 to AEntries.Count - 1 do
    begin
      entryText := AEntries[entryIndex];
      separatorIndex := Pos(RegisterSeparator, entryText);
      if separatorIndex = 0 then
        Continue;

      entryKey := Copy(entryText, 1, separatorIndex - 1);
      if Trim(entryKey) = '' then
        Continue;
      if (AKind = urkNameRegister) and (entryKey = 'NN') then
        Continue;

      entryValue := Trim(Copy(entryText, separatorIndex + 1, MaxInt));
      if entryValue = '' then
        Continue;

      if (Result.RecordCount > 0) and (entryKey = previousKey) then
      begin
        currentValue := Result.FieldByName('Zus').AsString;
        Result.Edit;
        Result.FieldByName('Zus').AsString := currentValue + ', ' + entryValue;
        Result.Post;
      end
      else
      begin
        Result.Append;
        Result.FieldByName('No').AsString := entryKey;
        Result.FieldByName('Zus').AsString := entryValue;
        Result.Post;
        previousKey := entryKey;
      end;
    end;
    Result.First;
  except
    Result.Free;
    raise;
  end;
end;

end.
