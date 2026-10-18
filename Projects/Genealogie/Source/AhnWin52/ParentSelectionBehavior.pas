unit ParentSelectionBehavior;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  DB;

/// Applies the selected candidate's parent reference when its gender is M or W.
/// Leaves posting and subsequent navigation to the calling workflow.
function ApplySelectedParent(const CurrentPerson: TDataSet;
  const CandidateGender: string; const CandidateNumber: Integer): Boolean;

implementation

uses
  SysUtils;

function ApplySelectedParent(const CurrentPerson: TDataSet;
  const CandidateGender: string; const CandidateNumber: Integer): Boolean;
begin
  if CurrentPerson = nil then
    raise EArgumentNilException.Create('CurrentPerson');

  CurrentPerson.Edit;
  if CandidateGender = 'M' then
  begin
    CurrentPerson.FieldByName('Vater').AsInteger := CandidateNumber;
    Result := True;
  end
  else if CandidateGender = 'W' then
  begin
    CurrentPerson.FieldByName('Mutter').AsInteger := CandidateNumber;
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

end.
