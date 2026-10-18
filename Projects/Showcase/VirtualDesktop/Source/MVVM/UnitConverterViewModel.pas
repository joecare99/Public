unit UnitConverterViewModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Mvvm;

type
  TUnitCategory = (ucLength, ucMass, ucTemperature);

  TUnitConverterViewModel = class(TNotifyPropertyChangedObject)
  private
    class function NormalizeUnit(const AUnit: string): string; static;
    class function LengthFactor(const AUnit: string): Double; static;
    class function MassFactor(const AUnit: string): Double; static;
    class function TemperatureToCelsius(const AValue: Double;
      const AUnit: string): Double; static;
    class function CelsiusToTemperature(const AValue: Double;
      const AUnit: string): Double; static;
  public
    class function Convert(const ACategory: TUnitCategory;
      const AValue: Double; const AFromUnit, AToUnit: string): Double; static;
    class function ConvertLength(const AValue: Double;
      const AFromUnit, AToUnit: string): Double; static;
    class function ConvertMass(const AValue: Double;
      const AFromUnit, AToUnit: string): Double; static;
    class function ConvertTemperature(const AValue: Double;
      const AFromUnit, AToUnit: string): Double; static;
    class function TryConvert(const ACategory: TUnitCategory;
      const AValue: Double; const AFromUnit, AToUnit: string;
      out AResult: Double; out AError: string): Boolean; static;
  end;

implementation

class function TUnitConverterViewModel.NormalizeUnit(const AUnit: string): string;
begin
  Result := LowerCase(Trim(AUnit));
  Result := StringReplace(Result, '°', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
end;

class function TUnitConverterViewModel.LengthFactor(const AUnit: string): Double;
var
  LUnit: string;
begin
  LUnit := NormalizeUnit(AUnit);
  if (LUnit = 'm') or (LUnit = 'meter') or (LUnit = 'meters') then
    Exit(1.0);
  if (LUnit = 'cm') or (LUnit = 'centimeter') or
     (LUnit = 'centimeters') then
    Exit(0.01);
  if (LUnit = 'mm') or (LUnit = 'millimeter') or
     (LUnit = 'millimeters') then
    Exit(0.001);
  if (LUnit = 'km') or (LUnit = 'kilometer') or
     (LUnit = 'kilometers') then
    Exit(1000.0);
  if (LUnit = 'in') or (LUnit = 'inch') or (LUnit = 'inches') then
    Exit(0.0254);
  if (LUnit = 'ft') or (LUnit = 'foot') or (LUnit = 'feet') then
    Exit(0.3048);
  if (LUnit = 'yd') or (LUnit = 'yard') or (LUnit = 'yards') then
    Exit(0.9144);
  if (LUnit = 'mi') or (LUnit = 'mile') or (LUnit = 'miles') then
    Exit(1609.344);
  raise EConvertError.CreateFmt('Unsupported length unit "%s".', [AUnit]);
end;

class function TUnitConverterViewModel.MassFactor(const AUnit: string): Double;
var
  LUnit: string;
begin
  LUnit := NormalizeUnit(AUnit);
  if (LUnit = 'kg') or (LUnit = 'kilogram') or
     (LUnit = 'kilograms') then
    Exit(1.0);
  if (LUnit = 'g') or (LUnit = 'gram') or (LUnit = 'grams') then
    Exit(0.001);
  if (LUnit = 'mg') or (LUnit = 'milligram') or
     (LUnit = 'milligrams') then
    Exit(0.000001);
  if (LUnit = 'lb') or (LUnit = 'lbs') or (LUnit = 'pound') or
     (LUnit = 'pounds') then
    Exit(0.45359237);
  if (LUnit = 'oz') or (LUnit = 'ounce') or (LUnit = 'ounces') then
    Exit(0.028349523125);
  raise EConvertError.CreateFmt('Unsupported mass unit "%s".', [AUnit]);
end;

class function TUnitConverterViewModel.TemperatureToCelsius(
  const AValue: Double; const AUnit: string): Double;
var
  LUnit: string;
begin
  LUnit := NormalizeUnit(AUnit);
  if (LUnit = 'c') or (LUnit = 'celsius') then
    Exit(AValue);
  if (LUnit = 'f') or (LUnit = 'fahrenheit') then
    Exit((AValue - 32.0) * 5.0 / 9.0);
  if (LUnit = 'k') or (LUnit = 'kelvin') then
    Exit(AValue - 273.15);
  raise EConvertError.CreateFmt('Unsupported temperature unit "%s".', [AUnit]);
end;

class function TUnitConverterViewModel.CelsiusToTemperature(
  const AValue: Double; const AUnit: string): Double;
var
  LUnit: string;
begin
  LUnit := NormalizeUnit(AUnit);
  if (LUnit = 'c') or (LUnit = 'celsius') then
    Exit(AValue);
  if (LUnit = 'f') or (LUnit = 'fahrenheit') then
    Exit(AValue * 9.0 / 5.0 + 32.0);
  if (LUnit = 'k') or (LUnit = 'kelvin') then
    Exit(AValue + 273.15);
  raise EConvertError.CreateFmt('Unsupported temperature unit "%s".', [AUnit]);
end;

class function TUnitConverterViewModel.Convert(const ACategory: TUnitCategory;
  const AValue: Double; const AFromUnit, AToUnit: string): Double;
begin
  case ACategory of
    ucLength:
      Result := AValue * LengthFactor(AFromUnit) / LengthFactor(AToUnit);
    ucMass:
      Result := AValue * MassFactor(AFromUnit) / MassFactor(AToUnit);
    ucTemperature:
      Result := CelsiusToTemperature(TemperatureToCelsius(AValue, AFromUnit),
        AToUnit);
  else
    raise EConvertError.Create('Unsupported unit category.');
  end;
end;

class function TUnitConverterViewModel.ConvertLength(const AValue: Double;
  const AFromUnit, AToUnit: string): Double;
begin
  Result := Convert(ucLength, AValue, AFromUnit, AToUnit);
end;

class function TUnitConverterViewModel.ConvertMass(const AValue: Double;
  const AFromUnit, AToUnit: string): Double;
begin
  Result := Convert(ucMass, AValue, AFromUnit, AToUnit);
end;

class function TUnitConverterViewModel.ConvertTemperature(const AValue: Double;
  const AFromUnit, AToUnit: string): Double;
begin
  Result := Convert(ucTemperature, AValue, AFromUnit, AToUnit);
end;

class function TUnitConverterViewModel.TryConvert(const ACategory: TUnitCategory;
  const AValue: Double; const AFromUnit, AToUnit: string;
  out AResult: Double; out AError: string): Boolean;
begin
  try
    AResult := Convert(ACategory, AValue, AFromUnit, AToUnit);
    AError := '';
    Result := True;
  except
    on E: Exception do
    begin
      AResult := 0.0;
      AError := E.Message;
      Result := False;
    end;
  end;
end;

end.
