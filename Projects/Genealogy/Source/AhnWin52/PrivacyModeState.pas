unit PrivacyModeState;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

/// Returns the active privacy-mode birth-year limit; zero means disabled.
function GetPrivacyBirthYearLimit: Integer;

/// Updates the shared birth-year limit used by privacy-aware workflows.
procedure SetPrivacyBirthYearLimit(const Value: Integer);

implementation

var
  PrivacyBirthYearLimit: Integer = 0;

function GetPrivacyBirthYearLimit: Integer;
begin
  Result := PrivacyBirthYearLimit;
end;

procedure SetPrivacyBirthYearLimit(const Value: Integer);
begin
  PrivacyBirthYearLimit := Value;
end;

end.
