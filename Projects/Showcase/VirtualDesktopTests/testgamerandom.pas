unit testgamerandom;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, GameRandom;

type
  TSequenceRandom = class(TInterfacedObject, IGameRandom)
  private
    FValues: array of Integer;
    FPosition: Integer;
  public
    constructor Create(const AValues: array of Integer);
    function NextInteger(const AExclusiveUpperBound: Integer): Integer;
  end;

implementation

constructor TSequenceRandom.Create(const AValues: array of Integer);
var
  Index: Integer;
begin
  inherited Create;
  if Length(AValues) = 0 then
    raise Exception.Create('At least one random value is required.');
  SetLength(FValues, Length(AValues));
  for Index := 0 to High(AValues) do
    FValues[Index] := AValues[Index];
end;

function TSequenceRandom.NextInteger(
  const AExclusiveUpperBound: Integer): Integer;
begin
  Result := FValues[FPosition mod Length(FValues)];
  Inc(FPosition);
end;

end.
