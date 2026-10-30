unit TelnameModel;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  ETelnameError = class(Exception);

  TTelnameModel = class
  private
    function LettersForDigit(ADigit: Char): string;
    procedure AddNames(const ANumber: string; APosition: Integer;
      var ACurrent: string; AResults: TStrings; AMaxResults: Integer);
  public
    function NameToNumber(const AName: string): string;
    procedure NumberToNames(const ANumber: string; AResults: TStrings;
      AMaxResults: Integer = 256);
  end;

implementation

function TTelnameModel.LettersForDigit(ADigit: Char): string;
begin
  case ADigit of
    '0', '1': Result := ' ';
    '2': Result := 'ABC';
    '3': Result := 'DEF';
    '4': Result := 'GHI';
    '5': Result := 'JKL';
    '6': Result := 'MNO';
    '7': Result := 'PRS';
    '8': Result := 'TUV';
    '9': Result := 'WXY';
  else
    raise ETelnameError.Create('Ungueltige Ziffer: ' + ADigit);
  end;
end;

function TTelnameModel.NameToNumber(const AName: string): string;
var
  I, Digit, LetterIndex: Integer;
  C: Char;
  Letters: string;
  Mapped: Boolean;
begin
  Result := '';
  for I := 1 to Length(AName) do
  begin
    C := UpCase(AName[I]);
    Mapped := False;
    if (C >= 'A') and (C <= 'Z') then
      for Digit := 2 to 9 do
      begin
        Letters := LettersForDigit(Char(Ord('0') + Digit));
        for LetterIndex := 1 to Length(Letters) do
          if C = Letters[LetterIndex] then
          begin
            Result := Result + Char(Ord('0') + Digit);
            Mapped := True;
            Break;
          end;
        if Mapped then
          Break;
      end;
    if not Mapped then
      Result := Result + AName[I];
  end;
end;

procedure TTelnameModel.AddNames(const ANumber: string; APosition: Integer;
  var ACurrent: string; AResults: TStrings; AMaxResults: Integer);
var
  Choices: string;
  I: Integer;
begin
  if AResults.Count >= AMaxResults then
    Exit;
  if APosition > Length(ANumber) then
  begin
    AResults.Add(ACurrent);
    Exit;
  end;
  Choices := LettersForDigit(ANumber[APosition]);
  for I := 1 to Length(Choices) do
  begin
    ACurrent[APosition] := Choices[I];
    AddNames(ANumber, APosition + 1, ACurrent, AResults, AMaxResults);
    if AResults.Count >= AMaxResults then
      Exit;
  end;
end;

procedure TTelnameModel.NumberToNames(const ANumber: string;
  AResults: TStrings; AMaxResults: Integer);
var
  I: Integer;
  Current: string;
begin
  if AResults = nil then
    raise ETelnameError.Create('Die Ergebnisliste fehlt.');
  AResults.Clear;
  if AMaxResults < 1 then
    Exit;
  for I := 1 to Length(ANumber) do
    if not (ANumber[I] in ['0'..'9']) then
      raise ETelnameError.CreateFmt('Ungueltige Ziffer: %s', [ANumber[I]]);
  if ANumber = '' then
    Exit;
  Current := ANumber;
  AddNames(ANumber, 1, Current, AResults, AMaxResults);
end;

end.
