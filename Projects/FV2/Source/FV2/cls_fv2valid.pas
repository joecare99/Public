unit cls_fv2valid;

{$mode objfpc}{$H+}

interface

uses
  cls_fv2validate;

type
  TValidatable = class
  public
    class function IsValid(const AValue: string; AValidator: TValidator): Boolean;
  end;

implementation

class function TValidatable.IsValid(const AValue: string;
  AValidator: TValidator): Boolean;
begin
  Result := not Assigned(AValidator) or AValidator.Validate(AValue);
end;

end.
