unit cls_KingdomEng;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type

  { TKingdomEngine }

  TKingdomEngine=Class
     private
       FPlague: Boolean; // A Plague happend this year
       FExpelled: Boolean; // You were expelled from the Land
       FYearOfReighn, // YearOfReigh
       FPopulation, // Population
       FStorage, // Storage
       FHarvest, // Harvested
       FArea:integer; // Area

         // Decitions
         FLandInProduction, // ProductionLand
         FDistributedFood:integer;  //Distributed Food

         // Results
         FRatts, // Ratts
         FImmigrants, // Immigrants
         FDeath, // Death
       FCostOfLand, // CostOfLand
       FProductivity:Integer; // Productivity
         //Score
        FPopSum,
        FDeathSum:integer;
        function GetGameEnded: Boolean;
      public
        function BuySellLand(aValue:integer):boolean;
        function Distribute(aValue:integer):boolean;
        function Production(aValue:integer):boolean;
        function GameDescription:String;
        function YearDescription:String;
        function BuySellMsg(aValue:integer):String;
        function DistrMsg(aValue:integer):String;
        function ProdMsg(aValue:integer):String;
        Procedure NewGame;
        procedure NewYear(keep: boolean);
         Property LandPrice:integer read FCostOfLand ;
         PRoperty Area:integer read FArea;
         property Population:integer read FPopulation;
         Property Storage:integer read FStorage;
         property LandInProd:integer read FLandInProduction;
         Property Distributed:integer read FDistributedFood;
         Property GameEnded:Boolean read GetGameEnded;

  end;

implementation

uses unt_KingdomBase;

{ TKingdomEngine }

function TKingdomEngine.GetGameEnded: Boolean;
begin
  result := (FYearOfReighn > 10) or FExpelled ;
end;

function TKingdomEngine.BuySellLand(aValue: integer): boolean;
begin
  if aValue * FCostOfLand > (FStorage - FLandInProduction div 2) then
    exit(false)
  else if -aValue > FArea then
    exit(false)
  else
    begin
      FArea:=FArea+aValue;
      FStorage:= FStorage-aValue*FCostOfLand;
      result := true;
    end;
end;

function TKingdomEngine.Distribute(aValue: integer): boolean;
begin
  if (aValue<0) or (aValue>FStorage - FLandInProduction div 2) then exit(false);
  FDistributedFood:=FDistributedFood+aValue;
  FStorage:= FStorage-aValue;
  result:=true;
end;

function TKingdomEngine.Production(aValue: integer): boolean;
begin
  if (aValue>FArea) or (aValue<1) or (aValue>FStorage*2) or (aValue > 10*FPopulation) then
      exit(false);
  FLandInProduction:=Avalue;
  result:=true;
end;

function TKingdomEngine.GameDescription: String;
begin
  result := rsGameDescription;
end;

function TKingdomEngine.YearDescription: String;
begin
  if not FExpelled then
  result:=rsAdress +LineEnding+
    format(rsYearOfReign, [Numbers[FYearOfReighn],FDeath,FImmigrants]);
  if FPlague then
    result:=result +LineEnding+LineEnding+ rsPlague;
  result:=result +LineEnding+LineEnding+
    format(rsStorage,[FPopulation,FArea,FProductivity,FRatts,FStorage]) ;
  if FExpelled then
    result:=result +LineEnding+LineEnding+rsExpelled;
  if not GameEnded then
    result:=result +LineEnding+LineEnding+
      format(rsCostOfLand,[FCostOfLand])
  else
    begin
  // Todo: Endresults
    end;
end;

function TKingdomEngine.BuySellMsg(aValue: integer): String;
begin
  result:='Geht nicht ...'; // Todo: no BuySell-Message
end;

function TKingdomEngine.DistrMsg(aValue: integer): String;
begin
  result:='Geht nicht ...'; // Todo: no Distr-Message
end;

function TKingdomEngine.ProdMsg(aValue: integer): String;
begin
  result:='Geht nicht ...'; // Todo: no Prod-Message
end;

procedure TKingdomEngine.NewGame;
begin
  FPopulation:=100;
  FStorage:=2800;
  FArea:=1000;
  FProductivity:=3;
  FLandInProduction:=1000;
  FHarvest:=3000;
  FRatts:=200;
  FImmigrants:=5;
  FDeath:=0;
  FYearOfReighn:=1;
  FPlague:=false;
  FExpelled:=false;
  FCostOfLand:=random(10)+16;
end;

procedure TKingdomEngine.NewYear(keep:boolean);
var
  lv: Integer;
  lFullySupportedPeop:integer;
begin
  if (FYearOfReighn>10) or FExpelled then exit;
  // Produktionskosten
  FStorage := FStorage- FLandInProduction div 2;
  // Ertrag pro LAnd
  FProductivity := random(5)+1;
  // Ernte
  FHarvest := FLandInProduction * FProductivity;
  // Verlust durch Ratten
  lv := random(5)+1;
  if lv mod 2=0 then FRatts:= FStorage div lv;
  // Restspeicher
  FStorage := FStorage - FRatts + FHarvest;
  // Immigranten
  lv:= Random(5)+1;
  FImmigrants := lv * (20*FArea+FStorage) div (FPopulation * 100) +1;
  // Ist dieses Jahr eine Seuche aufgetreten ?
  FPlague:=random(20)=0;

  // Todesfälle durch Hunger
  // unter der Annahme, daß Geburten und altersbedingte Todesfälle die Waage halten
  lFullySupportedPeop  := (FDistributedFood div 20);

  lv := trunc(10* (2*Random -0.3));
  if lFullySupportedPeop > FPopulation then
    FDeath:=0
  else
    begin
      FDeath := FPopulation-lFullySupportedPeop;
      FPopulation:=lFullySupportedPeop;
      FExpelled:=(FDeath*2)>FPopulation;
    end;

  FPopSum:=((FYearOfReighn-1)* FPopSum+(FDeath*100) div FPopulation) div FYearOfReighn;
  FDeathSum := FDeathSum+FDeath;

  FPopulation:=FPopulation + FImmigrants;
  if FPlague then
    FPopulation:=FPopulation div 2;

  //Reset Values
  if not Keep then
    begin
      FLandInProduction:=0;
      FDistributedFood:=0;
    end;
  // Werte für nächstes Jahr
  FYearOfReighn := FYearOfReighn + 1;
  FCostOfLand:=random(10)+16;
end;


end.

