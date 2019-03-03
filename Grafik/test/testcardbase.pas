unit testCardBase;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

{$ifndef DEBUG}
   {$hint 'Program has to be compiled in DEBUG-Mode'}
{$endif}
interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,ClsCardGameBase;

type

  { TTestCardBase }

  TTestCardBase= class(TTestCase)
  private
    FDeck: TCardDeck;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    Procedure TestCard;
    Procedure TestRolPermut;
    Procedure TestMSPermut;
    Procedure TestTrippleSwap;
    Procedure TestCardDeck;
    Procedure TestCardDeckShuffle;
    Procedure TestCardSlot;
    Procedure TestCardPile;
  end;

  { TCardTestGameEngine }

  TCardTestGameEngine= Class(TCardEngineBase)
    SuccessCount:integer;
    FailCount:integer;
    FDeck:TCardDeck;
    FSourcePile:TCardPile;
    FBinPile:TcardPile;
    FGamePiles:array of TCardPile;
    FDestPiles:array of TCardPile;
    constructor Create;
    Destructor Destroy; override;
    Procedure NewGame(GameNo:integer);
    Function TestGameMoveRule(aCard: TCard; aSlot: TCardSlot;out IsAllowed: boolean):integer; override;
    Function TestGameTurnRule(aCard: TCard;out IsAllowed: boolean):Integer; override;
  end;

  { TTestCardEngine }

  TTestCardEngine= class(TTestCase)
  private
    FTestEngine: TCardTestGameEngine;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    Procedure TestSetup;
    Procedure TestNewGame;
    Procedure TestTurncard;
  end;

implementation

{ TCardTestGameEngine }

constructor TCardTestGameEngine.Create;
var
  i: Integer;
begin
  Inherited;
  Fdeck := TCardDeck.Create(4,cvl2,cvlAss);
  FSourcePile:= TCardPile.Create(FDeck,0);
  FBinPile:= TCardPile.Create(FDeck,1);
  setlength(FGamePiles,8);
  for i := 0 to High(FGamePiles) do
    FGamePiles[i]:= TCardPile.Create(FDeck,i+2);
  setlength(FDestPiles,4);
  for i := 0 to High(FDestPiles) do
    FDestPiles[i]:= TCardPile.Create(FDeck,i+10);
end;

destructor TCardTestGameEngine.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(FDestPiles) do
    freeandnil(FDestPiles[i]);
  setlength(FDestPiles,0);
  for i := 0 to High(FGamePiles) do
    freeandnil(FGamePiles[i]);
  setlength(FGamePiles,0);
  FreeandNil(FBinPile);
  Freeandnil(FSourcePile);
  FreeAndNil(Fdeck) ;
  inherited Destroy;
end;

procedure TCardTestGameEngine.NewGame(GameNo: integer);
var
  LCard: Integer;
  I,J: Integer;
begin
  Fdeck.MSShuffle(GameNo);
  LCard:=1;
{$ifdef false}
  for I := 0 to 7 do
    FGamePiles[I].CleanUp(true);
  for I := 0 to 3 do
    FDestPiles[i].CleanUp(true);
  FSourcePile.CleanUp(true);
  FBinPile.CleanUp(true);
{$endif}
  for I := 0 to 7 do
    for J := i to 7 do
      begin
        FGamePiles[J].AppendCard(Fdeck[LCard],I<>J) ;
        inc(LCard);
      end;

  while LCard <= FDeck.CardCount do
    begin
      FSourcePile.AppendCard(Fdeck[LCard],true);
inc(LCard);
    end;
end;

function TCardTestGameEngine.TestGameMoveRule(aCard: TCard; aSlot: TCardSlot;
  out IsAllowed: boolean): integer;
begin
  IsAllowed := false;
  if not assigned(aCard) then
    exit(1);
  if not assigned(aSlot) then
    exit(1);
  if not assigned(aCard.Slot) then
    exit(2);

  Result:=inherited TestGameMoveRule(aCard, aSlot, IsAllowed);
end;

function TCardTestGameEngine.TestGameTurnRule(aCard: TCard; out
  IsAllowed: boolean): Integer;
begin
  IsAllowed := false;
  if not assigned(aCard) then
    exit(1);
  if not assigned(aCard.Slot) then
    exit(2);

  if not Assigned(acard.Slot.Pile) then
    exit(10);
  if not aCard.turned then
    exit(11);


  Result:=inherited TestGameTurnRule(aCard, IsAllowed);
end;

{ TTestCardEngine }

procedure TTestCardEngine.SetUp;
begin
  FTestEngine := TCardTestGameEngine.Create;
end;

procedure TTestCardEngine.TearDown;
begin
  FreeAndNil(FTestEngine);
end;

procedure TTestCardEngine.TestSetup;
var
  i: Integer;
begin
  CheckNotNull(FTestEngine,'Engine is Assigned');
  CheckNotNull(FTestEngine.FDeck,'Engine.Deck is Assigned');
  CheckEquals(
    'TCardDeck:(?,2d,2h,2s,2c,3d,3h,3s,3c,4d,4h,4s,4c,5d,5h,5s,5c,'+
    '6d,6h,6s,6c,7d,7h,7s,7c,8d,8h,8s,8c,9d,9h,9s,9c,Td,Th,Ts,Tc,Jd,'+
    'Jh,Js,Jc,Qd,Qh,Qs,Qc,Kd,Kh,Ks,Kc,Ad,Ah,As,Ac)',FTestEngine.FDeck.ToString,
    'FTestEngine.FDeck.ToString');
  CheckNotNull(FTestEngine.FSourcePile,'Engine.SourcePile is Assigned');
  CheckEquals('TCardPile(0):(--)',FTestEngine.FSourcePile.ToString,'Engine.SourcePile.ToString');
  CheckNotNull(FTestEngine.FBinPile,'Engine.BinPile is Assigned');
  CheckEquals('TCardPile(1):(--)',FTestEngine.FBinPile.ToString,'Engine.BinPile.ToString');
  CheckEquals(7,high(FTestEngine.FGamePiles),'high(FTestEngine.FGamePiles)');
  for i := 0 to high(FTestEngine.FGamePiles) do
    begin
      CheckNotNull(FTestEngine.FGamePiles[i],'Assigned: FTestEngine.FGamePiles['+inttostr(i)+']');
      CheckEquals('TCardPile('+inttostr(i+2)+'):(--)',FTestEngine.FGamePiles[i].ToString,'FTestEngine.FGamePiles['+inttostr(i)+'].ToString');
    end;
  CheckEquals(3,high(FTestEngine.FDestPiles),'high(FTestEngine.FDestPiles)');
  for i := 0 to high(FTestEngine.FDestPiles) do
    begin
      CheckNotNull(FTestEngine.FDestPiles[i],'Assigned: FTestEngine.FDestPiles['+inttostr(i)+']');
      CheckEquals('TCardPile('+inttostr(i+10)+'):(--)',FTestEngine.FDestPiles[i].ToString,'FTestEngine.FDestPiles['+inttostr(i)+'].ToString');
    end;
end;

procedure TTestCardEngine.TestNewGame;

  function RepString(aStr:String;count:integer):String;
  var
    i: Integer;
  begin
    result := '';
    for i := 0 to count -1 do
      result := result + aStr;
  end;

var
  i: Integer;

const
  TopCard1:array[0..7] of string=('Qc','9c','5c','5d','Kh','Tc','Ah','9s');
  TopCard2:array[0..7] of string=('5c','7h','Tc','Ks','8s','5s','8c','Td');
begin
  FTestEngine.NewGame(12345);
  CheckEquals(
    'TCardDeck:(?,Qc,Ts,Qd,7h,6c,Qh,4s,4d,9c,4c,2s,Jc,As,3d,9h,5c,'+
    '2h,8s,Td,6h,3h,5d,5h,Ad,2c,Th,Kh,Ks,3c,Ac,Tc,Jh,8c,Ah,Js,9s,8h,'+
    '7c,6d,6s,8d,Jd,Kc,Kd,4h,9d,7s,3s,2d,5s,7d,Qs)',FTestEngine.FDeck.ToString,
    'FTestEngine.FDeck.ToString');
  CheckEquals('TCardPile(0):(??,??,??,??,??,??,??,??,??,??,??,??,??,??,??,??,--)',FTestEngine.FSourcePile.ToString,'Engine.SourcePile.ToString');
  CheckEquals('TCardPile(1):(--)',FTestEngine.FBinPile.ToString,'Engine.BinPile.ToString');
  for i := 0 to high(FTestEngine.FGamePiles) do
    CheckEquals('TCardPile('+inttostr(i+2)+'):('+RepString('??,',i)+TopCard1[i]+',--)',FTestEngine.FGamePiles[i].ToString,'FTestEngine.FGamePiles['+inttostr(i)+'].ToString');
  for i := 0 to high(FTestEngine.FDestPiles) do
    CheckEquals('TCardPile('+inttostr(i+10)+'):(--)',FTestEngine.FDestPiles[i].ToString,'FTestEngine.FDestPiles['+inttostr(i)+'].ToString');

  FTestEngine.NewGame(54321);
  CheckEquals(
    'TCardDeck:(?,5c,Kh,Qc,Qs,2c,4h,9h,Jh,7h,7s,8h,9s,3d,Qh,Ah,Tc,'+
    '9d,Ac,2h,3s,As,Ks,Th,9c,7c,Ad,8s,6s,6h,Jc,5s,6c,Qd,8c,3h,Td,3c,'+
    '7d,Js,Kd,Jd,Kc,4c,4d,5h,6d,8d,Ts,5d,2d,2s,4s)',FTestEngine.FDeck.ToString,
    'FTestEngine.FDeck.ToString (2)');
  CheckEquals('TCardPile(0):(??,??,??,??,??,??,??,??,??,??,??,??,??,??,??,??,--)',FTestEngine.FSourcePile.ToString,'Engine.SourcePile.ToString  (2)');
  CheckEquals('TCardPile(1):(--)',FTestEngine.FBinPile.ToString,'Engine.BinPile.ToString  (2)');
  for i := 0 to high(FTestEngine.FGamePiles) do
    CheckEquals('TCardPile('+inttostr(i+2)+'):('+RepString('??,',i)+TopCard2[i]+',--)',FTestEngine.FGamePiles[i].ToString,'FTestEngine.FGamePiles['+inttostr(i)+'].ToString (2)');
  for i := 0 to high(FTestEngine.FDestPiles) do
    CheckEquals('TCardPile('+inttostr(i+10)+'):(--)',FTestEngine.FDestPiles[i].ToString,'FTestEngine.FDestPiles['+inttostr(i)+'].ToString');
end;

procedure TTestCardEngine.TestTurncard;
begin
  FTestEngine.NewGame(12345);
  try
    FTestEngine.TurnCard(nil);
    Fail('No exception happend');
  except

  end;
  checkFalse(FTestEngine.TurnCard(FTestEngine.Fdeck.Card[1]),'Not Allowed');
  CheckEquals(11,FTestEngine.Reason,'Card already turned');
end;

{ TTestCardBase }

procedure TTestCardBase.TestCard;
var
  Card: TCard;
begin
  Card := TCard.Create(cclKaro,cvl2);
  CheckNotNull(Card,'Card is Assigned');
  CheckEquals(Ord(Card.Color),Ord(cclKaro),'Card is Karo');
  CheckEquals(Ord(Card.Value),ord(cvl2),'Card is 2');
  CheckNull(card.Slot,'Slot is not Assigned');
  Checktrue(card.isRed,'Card is Red');
  Checkfalse(card.isBlack,'Card is Black');
  CheckEquals('TCard:(2d)',card.ToString,'ToString');
  CheckEquals('2d',card.ShortDesc,'Short Desciption');
  Freeandnil(Card);
  CheckNull(Card,'Card is not Assigned');
  Card := TCard.Create(cclHerz,cvlUnknown);
  CheckNotNull(Card,'Card is Assigned');
  CheckEquals(Ord(cclKaro),Ord(Card.Color),'Card is Karo');
  CheckEquals(0,Ord(Card.Value),'Card is 0');
  CheckNull(card.Slot,'Slot is not Assigned');
  CheckFalse(card.isRed,'Card is Red');
  Checkfalse(card.isBlack,'Card is Black');
  CheckEquals('TCard:(?)',card.ToString,'ToString');
  CheckEquals('?',card.ShortDesc,'Short Desciption');
  Freeandnil(Card);
end;

procedure TTestCardBase.TestRolPermut;
var
  i,j: Integer;
  Start: Int64;
  rr: Int64;
begin
  for i := 0 to 10 do
    begin
      Start :=Random($7ffffffffffff);
      rr:= Start;
      for j := 0 to 100000 do
        begin
          rr := RolPermut(rr);
          CheckFalse(start=rr,'Short!: S:'+inttostr(Start)+' R:'+inttostr(J));
        end;
    end;
end;

procedure TTestCardBase.TestMSPermut;
var
  i,j: Integer;
  Start: Int64;
  rr: Int64;
  rc: Integer;
begin
  for i := 0 to 10 do
    begin
      Start :=Random($7fffffff);
      rr:= Start;
      rc:=start;
      for j := 0 to 100000 do
        begin
          rc := integer((int64(rc) * 214013 + 2531011) and $ffffffff);
          rr := MSPermut(rr);
          CheckNotEquals(longint(start),longint(rr),'Short!: S:'+inttostr(Start)+' R:'+inttostr(J));
          CheckEquals(longint(rc),longint(rr),'Eq!: S:'+inttostr(Start)+' R:'+inttostr(J));
        end;
    end;
end;

procedure TTestCardBase.TestTrippleSwap;
var
  card1: TCard;
  card2: TCard;
  card3: TCard;
  card4: TCard;
begin
  card1:=TCard.Create(cclKaro,cvl2);
  card2:=TCard.Create(cclHerz,cvl3);
  card3:=TCard.Create(cclPik,cvl4);
  card4:=TCard.Create(cclKreuz,cvl5);
  try
    TrippleSwap(card1,card2,card3);
    CheckEquals('4s',card1.ShortDesc,'1.1');
    CheckEquals('2d',card2.ShortDesc,'1.2');
    CheckEquals('3h',card3.ShortDesc,'1.3');
    TrippleSwap(card1,card4,card4);
    CheckEquals('5c',card1.ShortDesc,'2.1');
    CheckEquals('2d',card2.ShortDesc,'2.2');
    CheckEquals('3h',card3.ShortDesc,'2.3');
    CheckEquals('4s',card4.ShortDesc,'2.4');
  finally
    freeandnil(card1);
    freeandnil(card2);
    freeandnil(card3);
    freeandnil(card4);
  end;
end;

procedure TTestCardBase.TestCardDeck;
var
  Deck: TCardDeck;
  i: Integer;
begin
  Deck := TCardDeck.Create(4,cvl2,cvlAss);
  try
  CheckNotNull(Deck,'Deck is Assigned');
  CheckEquals(52,FDeck.CardCount,'CardCount is 52');
  for i := 0 to 52 do
    begin
      CheckNotNull(deck.card[i],'Card is Assigned');
      CheckNotNull(deck[i],'Default is Assigned');
      if i = 0 then
        CheckEquals(0,ord(deck[i].Value),'Card[0] is unknown')
      else
        begin
          CheckEquals((i-1) mod 4,ord(deck[i].Color),'Test Card[i].color');
          CheckEquals((i-1) div 4 +2,ord(deck[i].value),'Test Card[i].value');
        end
    end;
// Unknown Card
  CheckNotNull(deck.UnknownCard,'UnknownCard is Assigned');
  CheckEquals(0,ord(deck.UnknownCard.Value),'UnknownCard is unknown');
// ToString
  CheckEquals(
    'TCardDeck:(?,2d,2h,2s,2c,3d,3h,3s,3c,4d,4h,4s,4c,5d,5h,5s,5c,'+
    '6d,6h,6s,6c,7d,7h,7s,7c,8d,8h,8s,8c,9d,9h,9s,9c,Td,Th,Ts,Tc,Jd,'+
    'Jh,Js,Jc,Qd,Qh,Qs,Qc,Kd,Kh,Ks,Kc,Ad,Ah,As,Ac)',deck.ToString,'ToString');
  FreeAndNil(Deck);
  CheckNull(Deck,'Deck is not Assigned');
  Deck := TCardDeck.Create(4,cvl7,cvlAss);
  CheckNotNull(Deck,'Deck is Assigned');
  for i := 0 to 32 do
    begin
      CheckNotNull(deck.card[i],'Card is Assigned');
      CheckNotNull(deck[i],'Default is Assigned');
      if i = 0 then
        CheckEquals(0,ord(deck[i].Value),'Card[0] is unknown')
      else
        begin
          CheckEquals((i-1) mod 4,ord(deck[i].Color),'Test Card[i].color');
          CheckEquals((i-1) div 4 +7,ord(deck[i].value),'Test Card[i].value');
        end
    end;
// Unknown Card
  CheckNotNull(deck.UnknownCard,'UnknownCard is Assigned');
  CheckEquals(0,ord(deck.UnknownCard.Value),'UnknownCard is unknown');
// ToString
  CheckEquals(
    'TCardDeck:(?,7d,7h,7s,7c,8d,8h,8s,8c,9d,9h,9s,9c,Td,Th,Ts,Tc,Jd,'+
    'Jh,Js,Jc,Qd,Qh,Qs,Qc,Kd,Kh,Ks,Kc,Ad,Ah,As,Ac)',deck.ToString,'ToString');
  finally
    FreeAndNil(Deck);
  end;
end;

procedure TTestCardBase.TestCardDeckShuffle;
var
  Deck: TCardDeck;
  Deck2: TCardDeck;
  dDeck:array[0..51] of integer;
  i: Integer;
  holdseed: Integer;
  card: TCard;
  c: Integer;

begin
  Deck := TCardDeck.Create(4,cvl2,cvlAss);
  Deck2 := TCardDeck.Create(4,cvl2,cvlAss);
  try
  CheckNotNull(Deck,'Deck is Assigned');
  CheckNotNull(Deck2,'Deck is Assigned');

  for i := 0 to 51 do
    ddeck[i] := i div 4 * 4 + (i+3) mod 4;

  holdseed := 11982;
  for i := 0 to 51 do
    begin
      // Pick a card, any card.
      holdseed := integer((int64(holdseed) * 214013 + 2531011) and $ffffffff);
      c := ((holdseed shr 16) and $7fff) mod (52-i);
      // Place it in the deck
      card := Deck2[i+1];
      card.value := TCardValue(((ddeck[c] div 4 + 12) mod 13) +2);
      card.color := TCardcolor(ddeck[c] mod 4);

      // Move the last card in the deck into the vacant position.
      ddeck[c] := ddeck[ (52-i-1)];
    end;
  CheckEquals(
    'TCardDeck:(?,Ah,As,4h,Ac,2d,6s,Ts,Js,'+
                 '3d,3h,Qs,Qc,8s,7h,Ad,Ks,'+
                 'Kd,6h,5s,4d,9h,Jh,9s,3c,'+
                 'Jc,5d,5c,8c,9d,Td,Kh,7c,'+
                 '6c,2c,Th,Qh,6d,Tc,4s,7s,'+
                 'Jd,7d,8h,9c,2h,Qd,4c,5h,'+
                 'Kc,8d,2s,3s)',deck2.ToString,'ToString (referenz)');

  Deck.MSShuffle(11982);
  CheckEquals(
    'TCardDeck:(?,Ah,As,4h,Ac,2d,6s,Ts,Js,'+
                 '3d,3h,Qs,Qc,8s,7h,Ad,Ks,'+
                 'Kd,6h,5s,4d,9h,Jh,9s,3c,'+
                 'Jc,5d,5c,8c,9d,Td,Kh,7c,'+
                 '6c,2c,Th,Qh,6d,Tc,4s,7s,'+
                 'Jd,7d,8h,9c,2h,Qd,4c,5h,'+
                 'Kc,8d,2s,3s)',deck.ToString,'ToString (shuffle)');

  for i := 0 to 51 do
    ddeck[i] := i div 4 * 4 + (i+3) mod 4;

  holdseed := 0;
  for i := 0 to 51 do
    begin
      // Pick a card, any card.
      holdseed := integer((int64(holdseed) * 214013 + 2531011) and $ffffffff);
      c := ((holdseed shr 16) and $7fff) mod (52-i);
      // Place it on the table.
      card := Deck2[i+1];
      card.value := TCardValue(((ddeck[c] div 4 + 12) mod 13) +2);
      card.color := TCardcolor(ddeck[c] mod 4);
      // Move the last card in the deck into the vacant position.
      ddeck[c] := ddeck[52-i-1];
    end;
  CheckEquals(
    'TCardDeck:(?,Th,5h,Ks,Tc,6s,Ac,Ts,6c,'+
                 '6h,Qd,4s,Jd,Js,3c,5d,3s,'+
                 'Td,Qh,2d,8c,5c,Qs,7d,3d,'+
                 '9d,9h,6d,Jc,7s,9c,2c,Ah,'+
                 '7h,8h,Kh,8d,Kc,Qc,3h,Jh,'+
                 'Ad,As,4d,8s,9s,Kd,4h,7c,'+
                 '2s,4c,2h,5s)',deck2.ToString,'ToString referenz(0)');

  deck.MSShuffle(0);
  CheckEquals(
    'TCardDeck:(?,Th,5h,Ks,Tc,6s,Ac,Ts,6c,'+
                 '6h,Qd,4s,Jd,Js,3c,5d,3s,'+
                 'Td,Qh,2d,8c,5c,Qs,7d,3d,'+
                 '9d,9h,6d,Jc,7s,9c,2c,Ah,'+
                 '7h,8h,Kh,8d,Kc,Qc,3h,Jh,'+
                 'Ad,As,4d,8s,9s,Kd,4h,7c,'+
                 '2s,4c,2h,5s)',deck.ToString,'ToString Shuffle0');
  finally
    FreeAndNil(Deck2);
    FreeAndNil(Deck);
  end;
end;

procedure TTestCardBase.TestCardSlot;
var
  Slot: TCardSlot;
begin
  Slot := TCardSlot.Create(FDeck[27],FDeck,nil);
  try
  CheckNotNull(Slot,'Slot is assigned');
  CheckEquals('TCardSlot:(8s)',slot.ToString,'Slot.ToString');
  CheckEquals('8s',slot.ShortDesc,'Slot.Shortdesc');
  CheckNotNull(Slot.card,'Slot.card is assigned');
  CheckNotNull(FDeck[27].Slot,'Card.Slot is assigned');
  CheckEquals('TCardSlot:(8s)',FDeck[27].slot.ToString,'Slot.ToString');
  CheckEquals('TCard:(8s)',slot.card.ToString,'Slot.card.ToString');
  CheckNull(Slot.Pile,'Slot.pile is not assigned');
  slot.Turn;
  CheckEquals('TCardSlot:(??)',slot.ToString,'Slot.ToString (turned)');
  CheckEquals('??',slot.ShortDesc,'Slot.Shortdesc  (turned)');
  CheckNotNull(Slot.card,'Slot.card is assigned  (turned)');
  CheckEquals('TCard:(?)',slot.card.ToString,'Slot.card.ToString  (turned)');
  CheckNotNull(FDeck[27].Slot,'Card.Slot is assigned');
  CheckEquals('TCardSlot:(??)',FDeck[27].slot.ToString,'Slot.ToString');
  slot.Turn;
  CheckEquals('TCardSlot:(8s)',slot.ToString,'Slot.ToString (2x turned)');
  CheckEquals('8s',slot.ShortDesc,'Slot.Shortdesc (2x turned)');
  CheckNotNull(Slot.card,'Slot.card is assigned (2x turned)');
  CheckEquals('TCard:(8s)',slot.card.ToString,'Slot.card.ToString (2x turned)');
  slot.RemoveCard;
  CheckEquals('TCardSlot:(--)',slot.ToString,'Slot.ToString (removed)');
  CheckEquals('--',slot.ShortDesc,'Slot.Shortdesc (removed)');
  CheckNull(Slot.card,'Slot.card is not assigned (removed)');
  CheckNull(FDeck[27].Slot,'Card.Slot is not assigned');
  slot.Turn;
  CheckEquals('TCardSlot:(--)',slot.ToString,'Slot.ToString (removed & Turned)');
  CheckEquals('--',slot.ShortDesc,'Slot.Shortdesc (removed & Turned)');
  CheckNull(Slot.card,'Slot.card is not assigned (removed & turned)');
  slot.card := Fdeck[4];
  CheckEquals('TCardSlot:(??)',slot.ToString,'Slot.ToString (3x turned)');
  CheckEquals('??',slot.ShortDesc,'Slot.Shortdesc  (3x turned)');
  CheckNotNull(Slot.card,'Slot.card is assigned  (3x turned)');
  CheckEquals('TCard:(?)',slot.card.ToString,'Slot.card.ToString  (3x turned)');
  CheckNotNull(FDeck[4].Slot,'Card[4].Slot is assigned');
  CheckEquals('TCardSlot:(??)',FDeck[4].slot.ToString,'Card[4].Slot.ToString');
  slot.Turn;
  CheckEquals('TCardSlot:(2c)',slot.ToString,'Slot.ToString (4x turned)');
  CheckEquals('2c',slot.ShortDesc,'Slot.Shortdesc (4x turned)');
  CheckNotNull(Slot.card,'Slot.card is assigned (4x turned)');
  CheckEquals('TCard:(2c)',slot.card.ToString,'Slot.card.ToString (4x turned)');
  CheckEquals('TCardSlot:(2c)',FDeck[4].slot.ToString,'Card[4].Slot.ToString (4x turned)');
  finally
    freeandnil(slot);
  end;
end;

procedure TTestCardBase.TestCardPile;
var
  Pile: TCardPile;
  Pile2: TCardPile;
begin
  Pile:= TCardPile.Create(FDeck,1);
  Pile2:= TCardPile.Create(FDeck,2);
  try
  CheckNotNull(Pile,'Pile is assigned');
  CheckNotNull(Pile.TopSlot,'Pile.TopSlot is assigned');
  CheckEquals('TCardPile(1):(--)',pile.ToString,'pile.ToString');
  CheckEquals('--',pile.ShortDesc,'pile.Shortdesc');
  CheckNull(Pile.TopCard,'Pile.TopCard is not assigned');
  CheckEquals('TCardSlot(0):(--)',Pile.Topslot.ToString,'Pile.Topslot.ToString');
  CheckNotNull(Pile.Topslot.Pile,'Slot.pile is assigned');
  CheckNotNull(Pile2,'Pile2 is assigned');
  CheckNotNull(Pile2.TopSlot,'Pile2.TopSlot is assigned');
  CheckEquals('TCardPile(2):(--)',pile2.ToString,'pile2.ToString');
  CheckEquals('--',pile2.ShortDesc,'pile2.Shortdesc');
  CheckNull(Pile2.TopCard,'Pile2.TopCard is assigned');
  CheckEquals('TCardSlot(0):(--)',Pile2.Topslot.ToString,'Pile2.Topslot.ToString');
  CheckNotNull(Pile2.Topslot.Pile,'Slot.pile is assigned');
  Pile.AppendCard(FDeck[27]);
  CheckNotNull(Pile.TopCard,'Pile.TopCard is assigned');
  CheckEquals('TCardPile(1):(8s,--)',Pile.ToString,'Pile.Topslot.ToString');
  CheckEquals('TCard:(8s)',Pile.TopCard.ToString,'Pile.Topslot.ToString');
  CheckEquals('TCardSlot(1):(--)',Pile.Topslot.ToString,'Pile.Topslot.ToString');
  Pile.AppendCard(FDeck[52]);
  CheckNotNull(Pile.TopCard,'Pile.TopCard is assigned');
  CheckEquals('TCardPile(1):(8s,Ac,--)',Pile.ToString,'Pile.Topslot.ToString');
  CheckEquals('TCard:(Ac)',Pile.TopCard.ToString,'Pile.Topslot.ToString');
  CheckEquals('TCardSlot(2):(--)',Pile.Topslot.ToString,'Pile.Topslot.ToString');
  Pile.AppendCard(FDeck[4]);
  CheckNotNull(Pile.TopCard,'Pile.TopCard is assigned');
  CheckEquals('TCardPile(1):(8s,Ac,2c,--)',Pile.ToString,'Pile.Topslot.ToString');
  CheckEquals('TCard:(2c)',Pile.TopCard.ToString,'Pile.Topslot.ToString');
  CheckEquals('TCardSlot(3):(--)',Pile.Topslot.ToString,'Pile.Topslot.ToString');
  pile2.AppendCard(pile.TopCard);
  CheckEquals('TCardPile(1):(8s,Ac,--)',Pile.ToString,'Pile.Topslot.ToString');
  CheckEquals('TCard:(Ac)',Pile.TopCard.ToString,'Pile.Topslot.ToString');
  CheckEquals('TCardSlot(2):(--)',Pile.Topslot.ToString,'Pile.Topslot.ToString');
  CheckEquals('TCardPile(2):(2c,--)',Pile2.ToString,'Pile2.Topslot.ToString');
  CheckEquals('TCard:(2c)',Pile2.TopCard.ToString,'Pile2.Topslot.ToString');
  CheckEquals('TCardSlot(1):(--)',Pile2.Topslot.ToString,'Pile2.Topslot.ToString');

  finally
    freeandnil(Pile2);
    freeandnil(Pile);
  end;
end;

procedure TTestCardBase.SetUp;
begin
  FDeck := TCardDeck.Create(4,cvl2,cvlAss);
end;

procedure TTestCardBase.TearDown;
begin
  Freeandnil(Fdeck);
end;

initialization

  RegisterTests([TTestCardBase,TTestCardEngine]);

end.

