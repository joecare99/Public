{ Rechenmodell des Calculator-Demos.

  Enthaelt die gesamte Rechenlogik des Taschenrechners: Akkumulator,
  Zwischenspeicher, Operator, Eingabezahlensystem und die Umwandlung
  zwischen dezimaerer, hexadezimaerer und binaerer Darstellung.

  Das Model kennt keine Oberflaeche - es wird vom ViewModel benutzt. }

unit CalculatorModel;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  { Fehler des Rechenmodells (z. B. Division durch Null). }
  ECalcError = class(Exception);

  { Eingabezahlensystem des Taschenrechners. }
  TCalcRadix = (radixDecimal, radixHex, radixBinary);

  { Rechenoperation des Taschenrechners. }
  TCalcOperation = (opcNone, opcMultiply, opcDivide, opcAdd, opcSubtract,
    opcAnd, opcOr, opcXor);

  { TCalculatorModel }
  TCalculatorModel = class
  private
    FAccumulator: Integer;
    FMemory: Integer;
    FOperator: TCalcOperation;
    FRadix: TCalcRadix;
    FNegFlag: Boolean;
    FDecString: string;
    FHexString: string;
    FBinString: string;
    function IntToBinString(AValue: Integer; ADigits: Integer): string;
    function StringToIntValue(const AText: string): Integer;
    function StringToHexValue(const AText: string): Integer;
    function StringToBinValue(const AText: string): Integer;
    procedure UpdateAccumulator;
    procedure UpdateDisplay;
  public
    constructor Create;
    { Fuegt eine Ziffer (oder Hex-Ziffer) der Eingabe hinzu. }
    procedure InputDigit(ADigit: Integer);
    { Setzt die Rechenoperation; eine laufende Operation wird vorher
      abgeschlossen. }
    procedure SetOperator(AOperation: TCalcOperation);
    { Fuehrt die Operation aus. }
    procedure Equals;
    { Loescht die aktuelle Eingabe. }
    procedure ClearEntry;
    { Loescht Eingabe und Zwischenspeicher. }
    procedure ClearAll;
    { Loescht die letzte Ziffer. }
    procedure Backspace;
    { Wechselt das Vorzeichen. }
    procedure Negate;
    { Bitweise Negation. }
    procedure BitwiseNot;
    { Wechselt das Eingabezahlensystem. }
    procedure SetRadix(ARadix: TCalcRadix);
    { Uebernimmt einen Text (z. B. aus der Zwischenablage) als Eingabe. }
    procedure SetEntryText(const AText: string);
    { Anzeigetext mit Tausendertrennern (dezimal). }
    function DecimalDisplay: string;
    { Anzeigetext mit Leerstellen (hexadezimal). }
    function HexDisplay: string;
    { Anzeigetext mit Leerstellen (binaer). }
    function BinaryDisplay: string;
    property Accumulator: Integer read FAccumulator;
    property Memory: Integer read FMemory;
    property Operator: TCalcOperation read FOperator;
    property Radix: TCalcRadix read FRadix;
    property DecimalText: string read FDecString;
    property HexText: string read FHexString;
    property BinaryText: string read FBinString;
  end;

implementation

const
  maxHexDigits = 8;
  maxBinDigits = 32;

constructor TCalculatorModel.Create;
begin
  inherited Create;
  ClearAll;
end;

{ Wandelt eine Zahl in eine Binaerdarstellung mit fuehrenden Nullen. }
function TCalculatorModel.IntToBinString(AValue: Integer; ADigits: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I := ADigits downto 1 do
  begin
    if (AValue and 1) = 1 then
      Result := Result + '1'
    else
      Result := Result + '0';
    AValue := AValue shr 1;
  end;
end;

{ Liest einen dezimalen Text (mit Vorzeichen). }
function TCalculatorModel.StringToIntValue(const AText: string): Integer;
begin
  if AText = '' then
    Result := 0
  else
    try
      Result := StrToInt(AText);
    except
      on E: Exception do
      begin
        raise ECalcError.Create(E.Message);
      end;
    end;
end;

{ Liest einen hexadezimalen Text. }
function TCalculatorModel.StringToHexValue(const AText: string): Integer;
var
  ErrorCode: Integer;
begin
  Val('$' + AText, Result, ErrorCode);
  if ErrorCode <> 0 then
    raise ECalcError.Create('Ungueltige hexadezimale Eingabe: ' + AText);
end;

{ Liest einen binaeren Text. }
function TCalculatorModel.StringToBinValue(const AText: string): Integer;
var
  V, Q: Integer;
  I, J: Integer;
begin
  V := 0;
  J := Length(AText) - 1;
  for I := 0 to J do
    if AText[I + 1] = '1' then
    begin
      Q := 1;
      V := V or (Q shl (J - I));
    end;
  Result := V;
end;

{ Setzt den Akkumulator aus dem aktuellen Eingabetext. }
procedure TCalculatorModel.UpdateAccumulator;
begin
  try
    case FRadix of
      radixDecimal: FAccumulator := StringToIntValue(FDecString);
      radixHex: FAccumulator := StringToHexValue(FHexString);
      radixBinary: FAccumulator := StringToBinValue(FBinString);
    end;
  except
    on E: ECalcError do
      raise;
    on E: EIntError do
      raise ECalcError.Create(E.Message);
  end;
end;

{ Aktualisiert die Anzeigetexte aus dem Akkumulator. }
procedure TCalculatorModel.UpdateDisplay;
begin
  if (not FNegFlag) or (FAccumulator <> 0) then
    FDecString := IntToStr(FAccumulator)
  else
    FDecString := '-' + IntToStr(FAccumulator);

  FHexString := IntToHex(FAccumulator, maxHexDigits);
  FBinString := IntToBinString(FAccumulator, maxBinDigits);
end;

procedure TCalculatorModel.InputDigit(ADigit: Integer);
begin
  { Eingabe ignorieren, wenn der Akkumulator voll ist. }
  if (FRadix = radixDecimal) and (-Abs(FAccumulator) < -(MaxInt div 10)) then
    Exit;
  if (FRadix = radixHex) and ((FAccumulator and $f0000000) <> 0) then
    Exit;
  if (FRadix = radixBinary) and (FAccumulator < 0) then
    Exit;

  case FRadix of
    radixDecimal:
      begin
        if not FNegFlag then
          FDecString := Trim(FDecString) + IntToStr(ADigit)
        else
        begin
          FDecString := '-' + IntToStr(ADigit);
          if ADigit > 0 then
            FNegFlag := False;
        end;
      end;
    radixHex:
      begin
        Delete(FHexString, 1, 1);
        FHexString := Trim(FHexString) + IntToHex(ADigit, 1);
      end;
    radixBinary:
      begin
        Delete(FBinString, 1, 1);
        FBinString := Trim(FBinString) + IntToBinString(ADigit, 1);
      end;
  end;

  UpdateAccumulator;
  UpdateDisplay;
end;

procedure TCalculatorModel.SetOperator(AOperation: TCalcOperation);
begin
  if FOperator <> opcNone then
    Equals;
  FMemory := FAccumulator;
  FOperator := AOperation;
  FAccumulator := 0;
  UpdateDisplay;
end;

procedure TCalculatorModel.Equals;
begin
  try
    case FOperator of
      opcMultiply: FAccumulator := FMemory * FAccumulator;
      opcDivide:
        if FAccumulator = 0 then
          raise ECalcError.Create('Division durch Null')
        else
          FAccumulator := FMemory div FAccumulator;
      opcAdd: FAccumulator := FMemory + FAccumulator;
      opcSubtract: FAccumulator := FMemory - FAccumulator;
      opcAnd: FAccumulator := FMemory and FAccumulator;
      opcOr: FAccumulator := FMemory or FAccumulator;
      opcXor: FAccumulator := FMemory xor FAccumulator;
      opcNone: ;
    end;
  except
    on E: ECalcError do
      raise;
    on E: EIntError do
      if E is EDivByZero then
        raise ECalcError.Create('Division durch Null')
      else if E is ERangeError then
        raise ECalcError.Create('Wert ausserhalb des Bereichs')
      else if E is EIntOverflow then
        raise ECalcError.Create('Ueberlauf');
  end;
  UpdateDisplay;
  FOperator := opcNone;
  FMemory := 0;
end;

procedure TCalculatorModel.ClearEntry;
begin
  FAccumulator := 0;
  FNegFlag := False;
  UpdateDisplay;
end;

procedure TCalculatorModel.ClearAll;
begin
  ClearEntry;
  FMemory := 0;
end;

procedure TCalculatorModel.Backspace;
begin
  case FRadix of
    radixDecimal: Delete(FDecString, Length(FDecString), 1);
    radixHex: Delete(FHexString, Length(FHexString), 1);
    radixBinary: Delete(FBinString, Length(FBinString), 1);
  end;
  UpdateAccumulator;
  UpdateDisplay;
end;

procedure TCalculatorModel.Negate;
begin
  if FAccumulator <> 0 then
    FAccumulator := -FAccumulator
  else
    FNegFlag := not FNegFlag;
  UpdateDisplay;
end;

procedure TCalculatorModel.BitwiseNot;
begin
  FAccumulator := not FAccumulator;
  UpdateDisplay;
end;

procedure TCalculatorModel.SetRadix(ARadix: TCalcRadix);
begin
  FRadix := ARadix;
end;

procedure TCalculatorModel.SetEntryText(const AText: string);
begin
  case FRadix of
    radixDecimal: FDecString := AText;
    radixHex: FHexString := AText;
    radixBinary: FBinString := AText;
  end;
  UpdateAccumulator;
  UpdateDisplay;
end;

function TCalculatorModel.DecimalDisplay: string;
var
  I: Integer;
  Caption: string;
begin
  Caption := FDecString;
  for I := 1 to (Length(IntToStr(Abs(FAccumulator))) - 1) div 3 do
    Insert('.', Caption, Length(Caption) + 2 - I * 4);
  Result := Caption + ' ';
end;

function TCalculatorModel.HexDisplay: string;
var
  I: Integer;
  Caption: string;
begin
  Caption := FHexString;
  for I := 1 to (Length(FHexString) - 1) div 4 do
    Insert(' ', Caption, Length(Caption) + 2 - I * 5);
  Result := Caption + ' ';
end;

function TCalculatorModel.BinaryDisplay: string;
var
  I: Integer;
  Caption: string;
begin
  Caption := FBinString;
  for I := 1 to (Length(FBinString) - 1) div 4 do
    Insert(' ', Caption, Length(Caption) + 2 - I * 5);
  Result := Caption + ' ';
end;

end.
