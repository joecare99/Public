unit ClsFreecellEng;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ClsCardGameBase;

type

  { TFreecellEngine }

  TFreecellEngine=class(TCardEngineBase)
// A FreeCell-Game engine
    FDeck:TCardDeck; //Done: Definition of each Card
    FSlots:array of TCardSlot; // Todo: A Slot can contain only 1 card
    FPile:array of TCardPile; // Todo: A Pile can contain Multible Cards
    FDestPile:array of TCardPile; // Todo: s.o. (Destination Pile)
  private
    function GetDestCard(index: integer): TCard;
    function GetPileCard(index1, index2: integer): TCard;
    function GetSlot(index: integer): TCard;
  public
    Constructor Create;
    Property Slot[index:integer]:TCard read GetSlot;
    Property PileCard[index1,index2:integer]:TCard read GetPileCard;
    Property Dest[index:integer]:TCard read GetDestCard;
    function TestGameMoveRule({%H-}aCard: TCard; {%H-}aSlot: TCardSlot;out IsAllowed: boolean ):integer;override;
  end;

implementation

{ TFreecellEngine }

function TFreecellEngine.GetDestCard(index: integer): TCard;
begin
  if (index >=0) and (index <= high(FDestPile)) then
  Result := FDestPile[index].TopCard
  else
    result := nil;
end;

function TFreecellEngine.GetPileCard(index1, index2: integer): TCard;
begin
  if (index1 >=0) and (index1 <= high(FPile)) then
  result := FPile[index1][index2]
  else
    result := nil;
end;

function TFreecellEngine.GetSlot(index: integer): TCard;
begin
  if (index >=0) and (index <= high(FSlots)) then
    result := FSlots[index].Card
  else
    result := nil; // Empty
end;


constructor TFreecellEngine.Create;
var
  i: Integer;
begin
  FDeck := TCardDeck.create(4,cvl2,cvlAss);
  Setlength(FSlots,4);
  for i := 0 to high(FSlots) do
    FSlots[i] := TCardSlot.Create(nil,FDeck,nil);
  Setlength(FPile,8);
  for i := 0 to high(FPile) do
    FPile[i] := TCardPile.Create(FDeck,i);
  Setlength(FDestPile,4);
  for i := 0 to high(FDestPile) do
    FDestPile[i] := TCardPile.Create(FDeck,i+8);
end;

function TFreecellEngine.TestGameMoveRule(aCard: TCard; aSlot: TCardSlot; out
  IsAllowed: boolean): integer;
begin
  Result:=inherited TestGameMoveRule(aCard, aSlot,IsAllowed);
end;



end.

