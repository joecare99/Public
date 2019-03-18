unit cls_KingdomEng;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TKingdomEngine }

  TKingdomEngine=Class
     private
       P, // Population
         S, // Storage
         H, // Harvested
         E, // Ratts
         Y, // Productivity
         A, // Area
         I, // Immigrants
         D, // Death
         Z, // YearOfReigh
         Prd, // ProductionLand
         CoL, // CostOfLand
         Q:integer;
      public
        function BuySellLand(aValue:integer):boolean;
        function Distribute(aValue:integer):boolean;
        function Production(aValue:integer):boolean;
        PRocedure NewYear;
         Property LandPrice:integer read CoL ;
         PRoperty Area:integer read A;
         property Population:integer read P;
         Property Storage:integer read S;


  end;

implementation

{ TKingdomEngine }

function TKingdomEngine.BuySellLand(aValue: integer): boolean;
begin
  if aValue * CoL > S then
    exit(false)
  else if -aValue > A then
    exit(false)
  else
    begin
      A:=a+aValue;
      S:= S-aValue*CoL;
      result := true;
    end;
end;

function TKingdomEngine.Distribute(aValue: integer): boolean;
begin
  if aValue<0 or aValue>S then exit(false);
  Q:=Q+aValue;
  S:= S-aValue;
end;

function TKingdomEngine.Production(aValue: integer): boolean;
begin
  if (aValue>A) or (aValue<1) or (aValue>S*2) or (aValue > 10*P) then exit(false)
  PRd:=Avalue;
end;

procedure TKingdomEngine.NewYear;
var
  lv: Integer;
begin
  Z := Z + 1;
  // Produktionskosten
  S := S- Prd div 2;
  // Ertrag pro LAnd
  Y := random(5)+1;
  // Ernte
  H := Prd * Y;
  // Verlust durch Ratten
  lv := random(5)+1;
  if lv mod 2=0 then E:= S div lv;
  // Restspeicher
  S := S - E + H;
  // Immigranten
  lv:= Random(5)+1;
  I := lv * (20*a+S) div (P * 100) +1;
  // Todesfälle
  C = Q div 20;
  lv := trunc(10* (2*Random -0.3));

end;


end.

