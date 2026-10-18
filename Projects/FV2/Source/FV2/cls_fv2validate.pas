unit cls_fv2validate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TValidator = class(TComponent)
  public
    function Validate(const AValue: string): Boolean; virtual;
  end;

  TRangeValidator = class(TValidator)
  private
    FMinimum: Int64;
    FMaximum: Int64;
  public
    constructor Create(AOwner: TComponent; AMinimum, AMaximum: Int64); reintroduce;
    function Validate(const AValue: string): Boolean; override;
    property Minimum: Int64 read FMinimum write FMinimum;
    property Maximum: Int64 read FMaximum write FMaximum;
  end;

implementation

function TValidator.Validate(const AValue: string): Boolean;
begin
  Result := True;
end;

constructor TRangeValidator.Create(AOwner: TComponent; AMinimum,
  AMaximum: Int64);
begin
  inherited Create(AOwner);
  if AMinimum > AMaximum then
    raise ERangeError.Create('Minimum exceeds maximum.');
  FMinimum := AMinimum;
  FMaximum := AMaximum;
end;

function TRangeValidator.Validate(const AValue: string): Boolean;
var
  Value: Int64;
begin
  Result := TryStrToInt64(AValue, Value) and
    (Value >= FMinimum) and (Value <= FMaximum);
end;

end.
