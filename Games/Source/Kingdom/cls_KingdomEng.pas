UNIT cls_KingdomEng;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

INTERFACE

USES
  Classes, SysUtils{$IFDEF FPC}, LCLTranslator{$ENDIF};

TYPE

  { TKingdomEngine }

  TKingdomEngine = CLASS
  private
    FPlague:   Boolean; // A Plague happend this year
    FExpelled: Boolean; // You were expelled from the Land
    FYearOfReighn, // YearOfReigh
    FPopulation, // Population
    FStorage,    // Storage
    FHarvest,    // Harvested
    FArea:     Integer; // Area

    // Decitions
    FLandInProduction, // ProductionLand
    FDistributedFood: Integer;  //Distributed Food

    // Results
    FRatts, // Ratts
    FImmigrants, // Immigrants
    FDeath, // Death
    FCostOfLand, // CostOfLand
    FProductivity:      Integer; // Productivity
    //Score
    FPopSum, FDeathSum: Integer;
    FUNCTION GetGameEnded: Boolean;
    FUNCTION getLandPerPopPerc: Integer;
  public
    CONSTRUCTOR Create;
    FUNCTION BuySellLand(aValue: Integer): Boolean;
    FUNCTION Distribute(aValue: Integer): Boolean;
    FUNCTION Production(aValue: Integer): Boolean;
    FUNCTION GameDescription: String;
    FUNCTION YearDescription: String;
    FUNCTION BuySellMsg(aValue: Integer): String;
    FUNCTION DistrMsg(aValue: Integer): String;
    FUNCTION ProdMsg(aValue: Integer): String;
    FUNCTION NewYearMsg: String;
    PROCEDURE NewGame;
    FUNCTION NewYear(keep: Boolean): Boolean;
    PROPERTY Year: Integer read FYearOfReighn;
    PROPERTY LandPrice: Integer read FCostOfLand;
    PROPERTY Area: Integer read FArea;
    PROPERTY Population: Integer read FPopulation;
    PROPERTY Death: Integer read FDeath;
    PROPERTY DeathSum: Integer read FDeathSum;
    PROPERTY DeathPerc: Integer read FPopSum;
    PROPERTY LandPerPopPerc: Integer read getLandPerPopPerc;
    PROPERTY Storage: Integer read FStorage;
    PROPERTY LandInProd: Integer read FLandInProduction;
    PROPERTY Distributed: Integer read FDistributedFood;
    PROPERTY GameEnded: Boolean read GetGameEnded;

  END;

IMPLEMENTATION

USES unt_KingdomBase;

{ TKingdomEngine }

FUNCTION TKingdomEngine.GetGameEnded: Boolean;
BEGIN
  Result := (FYearOfReighn > 10) or FExpelled;
END;

FUNCTION TKingdomEngine.getLandPerPopPerc: Integer;
BEGIN
  IF FPopulation > 0 THEN
    Result := (FArea * 100) div FPopulation
  ELSE
    Result := -1;// Ungültig
END;

CONSTRUCTOR TKingdomEngine.Create;
BEGIN
  FExpelled := True;
END;

FUNCTION TKingdomEngine.BuySellLand(aValue: Integer): Boolean;
BEGIN
  IF aValue * FCostOfLand > (FStorage - FLandInProduction div 2) THEN
    exit(False)
  ELSE IF -aValue > FArea THEN
    exit(False)
  ELSE
  BEGIN
    FArea    := FArea + aValue;
    FStorage := FStorage - aValue * FCostOfLand;
    Result   := True;
  END;
END;

FUNCTION TKingdomEngine.Distribute(aValue: Integer): Boolean;
BEGIN
  IF (FDistributedFood + aValue < 0) or (aValue > FStorage - FLandInProduction div 2) THEN
    exit(False);
  FDistributedFood := FDistributedFood + aValue;
  FStorage := FStorage - aValue;
  Result   := True;
END;

FUNCTION TKingdomEngine.Production(aValue: Integer): Boolean;
BEGIN
  IF (aValue > FArea) or (aValue < 1) or (aValue > FStorage * 2) or
    (aValue > 10 * FPopulation) THEN
    exit(False);
  FLandInProduction := Avalue;
  Result := True;
END;

FUNCTION TKingdomEngine.GameDescription: String;
BEGIN
  Result := rsGameDescription;
END;

FUNCTION TKingdomEngine.YearDescription: String;
VAR
  lLandPerPop: Integer;
BEGIN
  IF not FExpelled THEN
    Result := rsAdress + LineEnding + format(rsYearOfReign,
      [Numbers[FYearOfReighn], FDeath, FImmigrants]);
  IF FPlague THEN
    Result := Result + LineEnding + LineEnding + rsPlague;
  Result   := Result + LineEnding + LineEnding +
    format(rsStorage, [FPopulation, FArea, FProductivity, FRatts, FStorage]);
  IF FExpelled THEN
    Result := Result + LineEnding + LineEnding + rsExpelled;
  IF not GameEnded THEN
    Result := Result + LineEnding + LineEnding + format(rsCostOfLand, [FCostOfLand])
  ELSE
  BEGIN
    Result      := Result + LineEnding + LineEnding +
      format(rsResultPeople, [FPopSum, FDeathSum]);
    lLandPerPop := FArea div FPopulation;
    Result      := Result + LineEnding + format(rsResultLand, [lLandPerPop]);
    IF (FPopSum > 33) or (lLandPerPop < 7) THEN
      Result := Result + LineEnding + format(rsEvalBad, [])
    ELSE IF (FPopSum > 10) or (lLandPerPop < 9) THEN
      Result := Result + LineEnding + format(rsEvalPoor, [])
    ELSE IF (FPopSum > 3) or (lLandPerPop < 10) THEN
      Result := Result + LineEnding +
        format(rsEvalAverg, [trunc(FPopulation * random * 0.8)])
    ELSE
      Result := Result + LineEnding + format(rsEvalGood, []);
  END;
END;

FUNCTION TKingdomEngine.BuySellMsg(aValue: Integer): String;
BEGIN
  IF avalue < 0 THEN
    Result := format(rsNotEnoughLand, [FArea])
  ELSE
    Result := format(rsNotEnoughRes, [FStorage - FLandInProduction div 2]);
  // Done: no BuySell-Message
END;

FUNCTION TKingdomEngine.DistrMsg(aValue: Integer): String;
BEGIN
  Result := format(rsNotEnoughRes, [FStorage]); // Done: no Distr-Message
END;

FUNCTION TKingdomEngine.ProdMsg(aValue: Integer): String;
BEGIN
  IF aValue > FArea THEN
    Result := format(rsNotEnoughLand, [FArea])
  ELSE IF aValue > FPopulation * 10 THEN
    Result := format(rsNotEnoughPeople, [FPopulation])
  ELSE IF aValue > FStorage * 2 THEN
    Result := format(rsNotEnoughRes2, [FStorage]); // Done: no Prod-Message
END;

FUNCTION TKingdomEngine.NewYearMsg: String;
BEGIN
  // Done: no NewYear-Message
  Result := '';
  IF FDistributedFood = 0 THEN
    Result := rsNoDistr + LineEnding;
  IF FLandInProduction = 0 THEN
    Result := Result + rsNoProd;
END;

PROCEDURE TKingdomEngine.NewGame;
BEGIN
  FPopulation := 100;
  FStorage  := 2800;
  FArea     := 1000;
  FProductivity := 3;
  FLandInProduction := 0;
  FDistributedFood := 0;
  FHarvest  := 3000;
  FRatts    := 200;
  FImmigrants := 5;
  FDeath    := 0;
  FYearOfReighn := 1;
  FPlague   := False;
  FExpelled := False;
  FPopSum   := 0;
  FDeathSum := 0;
  FCostOfLand := random(10) + 16;
END;

FUNCTION TKingdomEngine.NewYear(keep: Boolean): Boolean;
VAR
  lv: Integer;
  lFullySupportedPeop: Integer;
BEGIN
  IF (FLandInProduction = 0) or (FDistributedFood = 0) THEN
    exit(False);
  Result := True;
  IF (FYearOfReighn > 10) or FExpelled THEN
    exit;
  // Produktionskosten
  FStorage := FStorage - FLandInProduction div 2;
  // Ertrag pro LAnd
  FProductivity := random(5) + 1;
  // Ernte
  FHarvest := FLandInProduction * FProductivity;
  // Verlust durch Ratten
  lv := random(5) + 1;
  IF lv mod 2 = 0 THEN
    FRatts := FStorage div lv
  ELSE
    FRatts := 0;
  // Restspeicher
  FStorage := FStorage - FRatts + FHarvest;
  // Immigranten
  lv      := Random(5) + 1;
  FImmigrants := lv * (20 * FArea + FStorage) div (FPopulation * 100) + 1;
  // Ist dieses Jahr eine Seuche aufgetreten ?
  FPlague := random(20) = 0;

  // Todesfälle durch Hunger
  // unter der Annahme, daß Geburten und altersbedingte Todesfälle die Waage halten
  lFullySupportedPeop := (FDistributedFood div 20);

  lv := trunc(10 * (2 * Random - 0.3));
  IF lFullySupportedPeop > FPopulation THEN
    FDeath := 0
  ELSE
  BEGIN
    FDeath      := FPopulation - lFullySupportedPeop;
    FPopulation := lFullySupportedPeop;
    FExpelled   := (FDeath * 2) > (FPopulation + FDeath);
  END;
  IF FPopulation + FDeath > 0 THEN
    FPopSum := ((FYearOfReighn - 1) * FPopSum + (FDeath * 100) div (FPopulation + FDeath)) div
      FYearOfReighn
  ELSE
    FPopSum := 100;
  FDeathSum := FDeathSum + FDeath;

  FPopulation := FPopulation + FImmigrants;
  IF FPlague THEN
    FPopulation := FPopulation div 2;

  //Reset Values
  IF not Keep THEN
  BEGIN
    FLandInProduction := 0;
    FDistributedFood  := 0;
  END;
  // Werte für nächstes Jahr
  FYearOfReighn := FYearOfReighn + 1;
  FCostOfLand   := random(10) + 16;
END;


END.
