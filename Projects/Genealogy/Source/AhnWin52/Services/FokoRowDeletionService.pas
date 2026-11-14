unit FokoRowDeletionService;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  DB;

/// Deletes the current dataset row only after the caller confirms the request.
/// Keeps the UI prompt in the view while making the mutation independently testable.
/// <param name="DataSet">Active dataset positioned on the row to delete.</param>
/// <param name="IsConfirmed">True only when the user selected the affirmative response.</param>
/// <returns>True when Delete was called; False when the request was cancelled.</returns>
/// <exception cref="EArgumentNilException">DataSet is nil.</exception>
function DeleteCurrentRowIfConfirmed(const DataSet: TDataSet;
  const IsConfirmed: Boolean): Boolean;

implementation

uses
  SysUtils;

function DeleteCurrentRowIfConfirmed(const DataSet: TDataSet;
  const IsConfirmed: Boolean): Boolean;
begin
  if DataSet = nil then
    raise EArgumentNilException.Create('DataSet');

  Result := False;
  if not IsConfirmed then
    Exit;

  DataSet.Delete;
  Result := True;
end;

end.
