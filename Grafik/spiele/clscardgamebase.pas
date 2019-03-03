unit ClsCardGameBase;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  TCardColor = (cclKaro, cclHerz, cclPik, cclKreuz);
  TCardValue = (
    cvlUnknown = 0, // Value for a unknown Card
    cvl2 = 2,
    cvl3 = 3,
    cvl4 = 4,
    cvl5 = 5,
    cvl6 = 6,
    cvl7 = 7,
    cvl8 = 8,
    cvl9 = 9,
    cvl10 = 10,
    cvlBube = 11,
    cvlDame = 12,
    cvlKoenig = 13,
    cvlAss = 14);

const
  // some basic card definitions
  cclRed=[cclKaro,cclHerz];
  cclBlack=[cclPik,cclKreuz];
  cvlNumber=[cvl2,cvl3,cvl4,cvl5,cvl6,cvl7,cvl8,cvl9,cvl10];
  cvlPicture=[cvlBube,cvlDame,cvlKoenig,cvlAss];

type
  { TCard }
  TCardSlot = class;

  TCard = class
  private
    FValue: TCardValue;
    FColor: TCardColor;
    FSlot: TCardSlot;
    FIsJoker:boolean;
    procedure SetColor(AValue: TCardColor);
    procedure SetIsJoker(AValue: boolean);
    procedure SetValue(AValue: TCardValue);
    procedure SetSlot(AValue: TCardSlot);
  public
    constructor Create(c: TCardColor; v: TCardValue; Joker:Boolean=false);
    property Color: TCardColor read FColor write SetColor;
    property Value: TCardValue read FValue write SetValue;
    property Slot: TCardSlot read FSlot write SetSlot;
    property IsJoker: boolean read FIsJoker write SetIsJoker;
    function isRed:boolean;
    function isBlack:boolean;
    function turned:boolean;
    Function ToString: ansistring; override;
    Function ShortDesc: string;virtual;
  end;

  { TCardDeck }

  TCardDeck = class
    // Definition of each Card
  private
    FCards: array of TCard;
    FColors:Integer;
    FMinValue:TCardValue;
    FMaxValue:TCardValue;
    function GetCard(index: integer): TCard;
    function GetUnknownCard: TCard;
    procedure InitCards(LowAce:boolean);
  public
    constructor Create(Colors: integer; MinValue, MaxValue: TCardValue);
    Destructor Destroy; override;
    procedure Shuffle(ShValue: longint);
    procedure MSShuffle(ShValue: longint);
    property UnknownCard: TCard read GetUnknownCard;
    property Card[index: integer]: TCard read GetCard; default;
    Function ToString: ansistring; override;
    Function CardCount:integer;
  end;

  { TCardSlot }
  TCardPile = class;

  TCardSlot = class
  private
    FCard: TCard;
    FDeck: TCardDeck;
    FPile: TCardPile;
    FTurned: boolean;
    function GetCard: TCard;
    function GetPile: TCardPile;
    procedure SetCard(AValue: TCard);
  public
    // Definition of each Card
    constructor Create(ACard: TCard; ADeck: TCardDeck; APile: TCardPile);
    property Card: TCard read GetCard write SetCard;
    property Pile: TCardPile read FPile;
    Function ToString: ansistring; override;
    Function ShortDesc: string;virtual;
    procedure RemoveCard;
    Procedure Turn;
  end;

  { TCardPile }

  TCardPile = class
    // Definition of each Card
    FSlots: array of TCardSlot;
    FDeck: TCardDeck;
    FPileIndex: integer;
  private
    function GetCard(index: integer): TCard;
    function GetTopCard: TCard;
    function GetTopSlot: TCardSlot;
  public
    constructor Create(aDeck: TCardDeck; pIndex: integer);
    Destructor Destroy; override;
    property Card[index: integer]: TCard read GetCard; default;
    property TopCard: TCard read GetTopCard;
    property TopSlot: TCardSlot read GetTopSlot;
    Function IndexOf(aSlot:TCardSlot):integer;
    procedure CleanUp(CleanHoles: boolean);
    procedure AppendCard(aCard: TCard;turned:boolean=false);
    Function ToString: ansistring; override;
    Function ShortDesc: string;virtual;
  end;

  { TCardEngineBase }

  TCardEngineBase = class
  protected
    FReason:integer;
  public
    function TestGameMoveRule({%H-}aCard: TCard; {%H-}aSlot: TCardSlot;out IsAllowed: boolean ):integer; virtual;
    function TestGameTurnRule({%H-}aCard: TCard;out IsAllowed: boolean): integer; virtual;
    function MoveCard(aCard: TCard; aSlot: TCardSlot): boolean; overload;
    function MoveCard(aCard: TCard; aPile: TCardPile): boolean; overload;
    function TurnCard(aCard: TCard): boolean; overload;
    property Reason:integer read FReason;
  end;

{$ifdef Debug}
function RolPermut(vv: int64): int64;
function MSPermut(vv: int64): int64;
procedure TrippleSwap(var S1, S2, S3: TCard);
{$endif}

var CardColorName: array[TCardColor] of String;
  CardValueName: array[cvlUnknown..cvlAss] of String;

implementation

// Default Values:
const
  DefCardColorName:array[TCardColor] of String =('Diamond','Heart','Spade','Club');
  DefCardValueName:array[cvlUnknown..cvlAss] of String =('Unknown','','2','3','4',
  '5','6','7','8','9','Ten','Jack','Queen','King','Ace');
{ TCardEngineBase }

function TCardEngineBase.TestGameMoveRule(aCard: TCard; aSlot: TCardSlot; out
  Isallowed: boolean): integer;
begin
  Isallowed := True;
  result := 0;
end;

function TCardEngineBase.TestGameTurnRule(aCard: TCard; out Isallowed: boolean
  ): integer;
begin
  Isallowed := True;
  result := 0;
end;

function TCardEngineBase.MoveCard(aCard: TCard; aSlot: TCardSlot): boolean;
var
  lReason: Integer;
begin
  assert(assigned(aCard), 'a Card should be assigned');
  assert(assigned(aSlot), 'a destination-Slot should be assigned');
  if aCard.slot = aSlot then
    // Schon am Ziel
  begin
    Result := True;
    exit;
  end;
  if assigned(aSlot.Card) then
    // Slot belegt !
  begin
    Result := False;
    exit;
  end;
  lReason := TestGameMoveRule(aCard, aSlot, Result);
  if result then
  begin
  if Assigned(aCard.slot) then
    aCard.slot.removeCard;
  aSlot.Card := aCard;
  end
  else
  FReason := lReason;
end;

function TCardEngineBase.MoveCard(aCard: TCard; aPile: TCardPile): boolean;
var
  lReason: Integer;
begin
  assert(assigned(aCard), 'a Card should be assigned');
  assert(assigned(aPile), 'a destination-Pile should be assigned');
  if assigned(aCard.slot) and (aCard.slot.pile = aPile) then
    // Schon am Ziel
  begin
    Result := (aCard = aCard.slot.pile.TopCard);
    exit;
  end;
  lReason := TestGameMoveRule(aCard, aPile.TopSlot, result);
  if result then
  begin
  if Assigned(aCard.slot) then
    aCard.slot.removeCard;
  aPile.AppendCard(aCard);
  end
  else
  FReason:=lReason;
end;


function TCardEngineBase.TurnCard(aCard: TCard): boolean;
var
  lReason: Integer;
begin
  assert(assigned(aCard), 'a Card should be assigned');
  if not assigned(aCard.Slot) then // Card not in Game
  begin
    Result := False;
    exit;
  end;
  lReason := TestGameTurnRule(aCard,result);
  if result then
  begin
  aCard.Slot.turn;
  end
  else
  FReason:=lReason;
end;

{ TCardPile }
function TCardPile.GetCard(index: integer): TCard;
begin
  Result := FSlots[index].Card;
end;

function TCardPile.GetTopCard: TCard;
begin
  if high(FSlots) > 0 then
    Result := FSlots[high(FSlots)-1].Card
  else
    Result := nil;
end;

function TCardPile.GetTopSlot: TCardSlot;
begin
   Result := FSlots[high(FSlots)];
end;

constructor TCardPile.Create(aDeck: TCardDeck; pIndex: integer);
begin
  FDeck := aDeck;
  FPileIndex := pIndex;
  SetLength(FSlots, 1);
  FSlots[0] := TCardSlot.Create(nil, aDeck, self);
end;

destructor TCardPile.Destroy;
var
  i: Integer;
begin
  for i := 0 to high(FSlots) do
    freeandnil(FSlots[i]);
  setlength(FSlots,0);
  inherited Destroy;
end;

function TCardPile.IndexOf(aSlot: TCardSlot): integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to high(FSlots) do
    if aSlot=FSlots[i] then
    begin
      result := i;
      break;
    end;
end;

procedure TCardPile.CleanUp(CleanHoles: boolean);
var
  StSl: integer;
  NxSl: integer;
  SL: TCardSlot;
begin
  if CleanHoles then
  begin
    StSl := 0;
    NxSl := 1;
    while (StSl <= high(FSlots)) and (NxSl<= high(FSlots)) do
    begin
      while (StSl <= high(FSlots)) and assigned(FSlots[StSl].Card) do
        Inc(StSl);
      NxSl := StSl + 1;
      while (NxSl <= high(FSlots)) and not assigned(FSlots[NxSl].Card) do
        Inc(NxSl);
      if NxSl <= high(FSlots) then
      begin
        SL := FSlots[StSl];
        FSlots[StSl] := FSlots[NxSl];
        FSlots[nxSl] := SL;
      end;
    end;
  end;
  if assigned(FSlots[high(FSlots)].Card) then
  begin
    setlength(FSlots, high(FSlots) + 2);
    FSlots[high(FSlots)] := TCardSlot.Create(nil, FDeck, self);
  end
  else
  begin
    StSl := high(FSlots) - 1;
    while (StSl >= 0) and not assigned(FSlots[StSl].Card) and not
      assigned(FSlots[StSl + 1].Card) do
    begin
      FreeAndNil(FSlots[StSl + 1]);
      Dec(StSl);
    end;
    if StSl < high(FSlots) - 1 then
      setlength(FSlots, StSl + 2);
  end;
end;

procedure TCardPile.AppendCard(aCard: TCard; turned: boolean);
begin
  // Done: Tests
  assert(assigned(aCard),'Card must be assigned to be appended');
  if assigned(aCard.Slot) then
    acard.slot.RemoveCard;
  FSlots[high(FSlots)].Fcard := aCard;
  FSlots[high(FSlots)].FTurned := turned;
  aCard.slot := FSlots[high(FSlots)];
  CleanUp(False);
end;

function TCardPile.ToString: ansistring;
begin
  Result:=inherited ToString;
  result :=result+'('+inttostr(FPileIndex)+'):('+ShortDesc+')';
end;

function TCardPile.ShortDesc: string;
var
  i: Integer;
begin
  result := '';
  for i := 0 to high(FSlots) do
    if i = 0 then
      result := FSlots[i].ShortDesc
    else
      result := result + ','+FSlots[i].ShortDesc;
end;

{ TCardSlot }

function TCardSlot.GetCard: TCard;
begin
  if assigned(FCard) and FTurned then
    Result := FDeck.UnknownCard
  else
    Result := FCard;
end;

function TCardSlot.GetPile: TCardPile;
begin
  Result := FPile;
end;

procedure TCardSlot.SetCard(AValue: TCard);
begin
  if FCard = AValue then
    exit;
  FCard := AValue;
  if assigned(FCard) then
    FCard.slot := self;
  if Assigned(FPile) then
    Fpile.CleanUp(False);
end;

constructor TCardSlot.Create(ACard: TCard; ADeck: TCardDeck; APile: TCardPile);
begin
  FCard := ACard;
  if assigned(FCard) then
    FCard.slot := self;
  FDeck := ADeck;
  FPile := APile;
end;

function TCardSlot.ToString: ansistring;
begin
  Result:=inherited ToString;
  if assigned(FPile) then
    result := result + '('+inttostr(Fpile.indexof(self))+')';
  result := result + ':('+shortDesc+')';
end;

function TCardSlot.ShortDesc: string;
begin
  if Assigned(Fcard) then
    if FTurned then
      result := '??'
    else
      result := FCard.ShortDesc
  else
    result := '--'
end;

procedure TCardSlot.RemoveCard;
begin
  if Assigned(FCard) then
    FCard.Slot := nil;
  FCard := nil;
  if assigned(Fpile) then
    Fpile.Cleanup(False);
end;

procedure TCardSlot.Turn;
begin
  FTurned:=not (FTurned = true);
end;

{ TCardDeck }

function TCardDeck.GetUnknownCard: TCard;
begin
  Result := FCards[0];
end;

procedure TCardDeck.InitCards(LowAce: boolean);
var
  j: integer;
  i: TCardValue;
  ii: TCardValue;
begin
  for i := FMinValue to FMaxValue do
    begin
      if LowAce then
        if i = FMinValue then
          ii := FMaxValue
        else
          ii := TCardValue(ord(i)-1)
      else
        ii := i;
    for j := 1 to FColors do
      if not assigned(FCards[(ord(i) - ord(FMinValue)) * FColors + j]) then
      FCards[(ord(i) - ord(FMinValue)) * FColors + j] :=
        TCard.Create(TCardColor((j - 1) mod 4), ii)
      else
        with FCards[(ord(i) - ord(FMinValue)) * FColors + j] do
        begin
          if assigned(Fslot) then
            fslot.RemoveCard;
          Fslot := nil;
          FValue := ii;
          FColor:=TCardColor((j - 1) mod 4);
        end;
  end;
end;

function TCardDeck.GetCard(index: integer): TCard;
begin
  if (index >= 0) and (index <= high(FCards)) then
    Result := FCards[index]
  else
    Result := nil;
end;

constructor TCardDeck.Create(Colors:integer; MinValue, MaxValue: TCardValue);
begin
  setlength(FCards, Colors * (ord(MaxValue) - ord(MinValue) + 1) + 1);
  FCards[0] := TCard.Create(TCardColor(0), TCardValue(0));
  FColors := Colors;
  FMinValue :=MinValue;
  FMaxValue :=MaxValue;
  InitCards(false);
end;

destructor TCardDeck.Destroy;
var
  i: Integer;
begin
  for i := 0 to high(FCards) do
    Freeandnil(FCards[i]);
  SetLength(FCards,0);
  inherited Destroy;
end;

procedure TrippleSwap(var S1, S2, S3: TCard);
var
  S0: TCard;
begin
  S0 := S3;
  S3 := S2;
  S2 := S1;
  S1 := s0;
end;

{$IFNDEF DEBUG}
procedure TCardDeck.Shuffle(ShValue: longint);
{$ENDIF}

  function RolPermut(vv: int64): int64;
  begin
    if (vv and 1) = 0 then
      Result := (vv shr 1) xor $8000000000082088
    else
      Result := (vv shr 1) xor $20820;
  end;


{$IFDEF DEBUG}
procedure TCardDeck.Shuffle(ShValue: longint);
{$ENDIF}

var
  StartValue: int64;
  i, j: integer;
  hcd2: integer;

const
  MaxShuffle = 16;

begin
  StartValue := ShValue;
  hcd2 := High(FCards) div 2;
  for i := 0 to MaxShuffle do
    for j := 0 to High(FCards) - 1 do
    begin
      StartValue := RolPermut(StartValue);
      if (StartValue and 1) = 0 then
        TrippleSwap(FCards[j + 1], FCards[j + 2],
          FCards[(j + hcd2) mod High(FCards) + 1])
      else
        TrippleSwap(FCards[j + 2], FCards[j + 1],
          FCards[(j + hcd2) mod High(FCards) + 1]);

    end;
end;

{$IFNDEF DEBUG}
procedure TCardDeck.MSShuffle(ShValue: longint);
{$ENDIF}

  function MSPermut(vv: int64): int64;
  begin
    result := ((vv+11) * 214013 + 176868) and $Ffffffff;
  end;

{$IFDEF DEBUG}
procedure TCardDeck.MSShuffle(ShValue: longint);
{$ENDIF}

var
  StartValue: int64;
   j: integer;
  C,HC: Integer;

begin
  StartValue := ShValue;
  // Initialize Deck
  InitCards(true);
  for J := 0 to High(FCards) div 4 -1 do
    begin
      TrippleSwap(FCards[j*4 + 1], FCards[j*4 + 2],
        FCards[j*4+3]);
      TrippleSwap(FCards[j*4 + 1], FCards[j*4 + 4],
        FCards[j*4+4]);
    end;
  HC := High(FCards);
    for j := 0 to High(FCards) - 2 do
    begin
      StartValue := msPermut(StartValue);
      C :=((StartValue shr 16) and $7fff) {%H-}mod (HC-j);
      TrippleSwap(FCards[ 1+c], FCards[ 1+c],
          FCards[HC-j]);
    end;
  for j := 0 to High(FCards) div 2-1 do
    TrippleSwap(FCards[ j+1], FCards[ j+1],
        FCards[HC-j]);

end;

function TCardDeck.ToString: ansistring;
var
  i: Integer;
begin
  Result:=inherited ToString;
  for i := 0 to High(FCards) do
    if i = 0 then
      result := Result + ':('+FCards[i].ShortDesc
      else
      result := Result + ','+FCards[i].ShortDesc;
  result := Result + ')';
end;

function TCardDeck.CardCount: integer;
begin
  result := high(FCards);
end;

{ TCard }

procedure TCard.SetColor(AValue: TCardColor);
begin
  if FColor = AValue then
    Exit;
  FColor := AValue;
end;

procedure TCard.SetIsJoker(AValue: boolean);
begin
  if FIsJoker=AValue then Exit;
  FIsJoker:=AValue;
end;

procedure TCard.SetValue(AValue: TCardValue);
begin
  if FValue = AValue then
    Exit;
  FValue := AValue;
end;

procedure TCard.SetSlot(AValue: TCardSlot);
begin
  if assigned(AValue) and assigned(AValue.FCard) and not ( Self.Equals(AValue.FCard)) then
    exit;
  if FSlot = AValue then
    Exit;
  FSlot := AValue;
  if assigned(AValue) and not assigned(AValue.Card) then
    AValue.Card := self;
end;

constructor TCard.Create(c: TCardColor; v: TCardValue; Joker: Boolean);
begin
  FValue := v;
  if v = cvlUnknown then
    Fcolor := cclKaro
  else
    FColor := c;
end;

function TCard.isRed: boolean;
begin
  result := (FColor in [cclKaro,cclHerz]) and (FValue<>cvlUnknown)
end;

function TCard.isBlack: boolean;
begin
  result := (FColor in [cclPik,cclKreuz]) and (FValue<>cvlUnknown)
end;

function TCard.turned: boolean;
begin
  result := false;
  if assigned(FSlot) then
    result := FSlot.FTurned;
end;

function TCard.ToString: ansistring;
begin
  Result:=inherited ToString;
  result := result + ':('+ShortDesc+')';
end;

function TCard.ShortDesc: string;
begin
  if FValue=cvlUnknown then
  result := '?'
  else
  result :=CardValueName[FValue][1]+LowerCase(CardColorName[FColor][1]);
end;

initialization
  CardColorName := DefCardColorName;
  CardValueName := DefCardValueName;

end.
