unit SokoEngine;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  TPartType = (ptWall, ptNone, ptPlayer, ptCrate, ptEmpty); //, ptReachable
  TSkinType = (stBackground, stEmpty, stPlayerUp, stPlayerUpStore,
      stPlayerRight, stPlayerRightStore, stPlayerDown, stPlayerDownStore,
      stPlayerLeft, stPlayerLeftStore, stStore, stCrate, stCrateStore,
      stWall, stWallRight, stWallLeftRight,  stWallLeft,
      stWallDown,stWallDownRight,stWallDownLeftRight, stWallDownLeft,
      stWallUpDown, stWallUpDownRight,  stWallUpDownLeftRight,  stWallUpDownLeft,
      stWallUp, stWallUpRight, stWallUpLeftRight, stWallUpLeft);

  TPuzzlePart = record
    FPartType: TPartType;
    FSkinType: TSkinType;{HMI}
    FIsCrateTarget: boolean;
    FCrateID: integer; {?? }
  end;

  TPuzzleField = array of array of TPuzzlePart;

  { TPuzzleCollectionData }

  TPuzzleCollectionData = class
  private
    FTitle, FDescription, FEmail, FCopyright: string;
    FMaxWidth, FMaxHeight: integer;
    function GetNumberOfLevels: integer;
    procedure SetCopyright(AValue: string);
    procedure SetDescription(AValue: string);
    procedure SetEMail(AValue: string);
    procedure SetMaxHeight(AValue: integer);
    procedure SetMaxWidth(AValue: integer);
    procedure SetNumberOfLevels(AValue: integer);
    procedure SetTitle(AValue: string);
  public
    FPuzzleFields: array of TPuzzleField;
    destructor Destroy; override;
    property Title: string read FTitle write SetTitle;
    property Description: string read FDescription write SetDescription;
    property EMail: string read FEMail write SetEMail;
    property Copyright: string read FCopyright write SetCopyright;
    property MaxWidth: integer read FMaxWidth write SetMaxWidth;
    property MaxHeight: integer read FMaxHeight write SetMaxHeight;
    property NumberOfLevels: integer read GetNumberOfLevels write SetNumberOfLevels;
  end;

  TGameData = record
    FPlayerPos :TPoint;
    FMoves, FPushes, FCratesStoredCount, FAktLevel,
    FCrateTargetCount, FLevelWidth, FLevelHeight: smallint;
    FCratesPos: array of Tpoint;
  end;

  { TSokobanEngine }

  TSokobanEngine = class
  private
    {Archive}
    FPuzzleCollection: TPuzzleCollectionData;
    {Actual}
    FGameData: TGameData;
    FPuzzleField: TPuzzleField;
    {History}
    FHistoryCount: integer;
    FRedoCount: integer;
    FHistory: array of TPuzzleField;
    FGameHistory: array of TGameData;
    {Methods}
    function GetEnableRedo: boolean;
    function GetEnableUndo: boolean;
    function GetLastLevel: integer;
    function GetLevelSolved: boolean;
    function GetPuzzleHeight: integer;
    function GetPuzzlewidth: integer;
    procedure SetGameData(AValue: TGameData);
    procedure SetPuzzleCollection(const AValue: TPuzzleCollectionData);
    function CopyPuzzleField(ASource: TPuzzleField): TPuzzleField;
    function CopyGameData(ASource: TGameData): TGameData;
    procedure TryMovementCrate(ANewX, ANewY: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitLevel(ALevel: integer);
    procedure ResetLevel;
    procedure Undo;
    procedure Redo;
    // This procedure corresponds to the delegate TMovePlayerProc
    procedure MovePlayer(ANew: TPoint);
    property LevelSolved: boolean read GetLevelSolved;
    property PuzzleField: TPuzzleField read FPuzzleField;
    property PuzzleWidth: integer read GetPuzzlewidth;
    property PuzzleHeight: integer read GetPuzzleHeight;
    property LastLevel: integer read GetLastLevel;
    property PuzzleCollection: TPuzzleCollectionData
      read FPuzzleCollection write SetPuzzleCollection;
    property GameData: TGameData read FGameData write SetGameData;
    property EnableUndo: boolean read GetEnableUndo;
    property EnableRedo: boolean read GetEnableRedo;
  end;

const Dir4:array[0..4] of TPoint=
   ((x:0;Y:0),
    (x:0;Y:-1),
    (x:+1;Y:0),
    (x:0;Y:+1),
    (x:-1;Y:0));

implementation

{ TPuzzleCollectionData }

procedure TPuzzleCollectionData.SetTitle(AValue: string);
begin
  if FTitle = AValue then
    Exit;
  FTitle := AValue;
end;

destructor TPuzzleCollectionData.Destroy;
begin
  setlength(FPuzzleFields,0);
  inherited Destroy;
end;

procedure TPuzzleCollectionData.SetDescription(AValue: string);
begin
  if FDescription = AValue then
    Exit;
  FDescription := AValue;
end;

procedure TPuzzleCollectionData.SetCopyright(AValue: string);
begin
  if FCopyright = AValue then
    Exit;
  FCopyright := AValue;
end;

function TPuzzleCollectionData.GetNumberOfLevels: integer;
begin
  Result := Succ(high(FPuzzleFields));
end;

procedure TPuzzleCollectionData.SetEMail(AValue: string);
begin
  if FEMail = AValue then
    Exit;
  FEMail := AValue;
end;

procedure TPuzzleCollectionData.SetMaxHeight(AValue: integer);
begin
  if FMaxHeight = AValue then
    Exit;
  FMaxHeight := AValue;
end;

procedure TPuzzleCollectionData.SetMaxWidth(AValue: integer);
begin
  if FMaxWidth = AValue then
    Exit;
  FMaxWidth := AValue;
end;

procedure TPuzzleCollectionData.SetNumberOfLevels(AValue: integer);
begin
  Setlength(FPuzzleFields, AValue);
end;

{ TSokobanEngine }

procedure TSokobanEngine.SetGameData(AValue: TGameData);
begin
  //  if FGameData=AValue then Exit;
  FGameData := AValue;
end;

function TSokobanEngine.GetPuzzleHeight: integer;
begin
  if assigned(FPuzzleField) then
    Result := succ(high(FPuzzleField[0]))
  else
    Result := 0;
end;

function TSokobanEngine.GetLastLevel: integer;
begin
  Result := succ(high(FPuzzleCollection.FPuzzleFields));
end;

function TSokobanEngine.GetEnableUndo: boolean;
begin
  Result := ((FGameData.FMoves > 0) or (FGameData.FPushes > 0)) and
    (FHistoryCount > 1);
end;

function TSokobanEngine.GetEnableRedo: boolean;
begin
  Result := FRedoCount > 0;
end;

function TSokobanEngine.GetLevelSolved: boolean;
begin
  Result := FGameData.FCratesStoredCount = FGameData.FCrateTargetCount;
end;

function TSokobanEngine.GetPuzzlewidth: integer;
begin
  Result := succ(high(FPuzzleField));
end;

procedure TSokobanEngine.SetPuzzleCollection(const AValue: TPuzzleCollectionData);
begin
  // if FPuzzleCollection=AValue then Exit;
  FPuzzleCollection := AValue;
end;

procedure TSokobanEngine.Undo;
begin
  if FHistoryCount > 0 then
  begin
    Dec(FHistoryCount);
    FPuzzleField := CopyPuzzleField(FHistory[FHistoryCount]);
    FGameData := CopyGameData(FGameHistory[FHistoryCount]);
    Inc(FRedoCount);
  end;
end;

procedure TSokobanEngine.Redo;
begin
  if FHistoryCount < high(FHistory) then
  begin
    Inc(FHistoryCount);
    FPuzzleField := CopyPuzzleField(FHistory[FHistoryCount]);
    FGameData := CopyGameData(FGameHistory[FHistoryCount]);
    Dec(FRedoCount);
  end;
end;

constructor TSokobanEngine.Create;
begin
  FHistoryCount := 0;
  FRedoCount := 0;
  FPuzzleCollection := TPuzzleCollectionData.Create;
  setlength(FHistory, 0);
  setlength(FGameHistory, 0);
end;

destructor TSokobanEngine.Destroy;
begin
  FreeAndNil(FPuzzleCollection);
  inherited Destroy;
end;

procedure TSokobanEngine.InitLevel(ALevel: integer);
var
  AXPos, AYPos, ArrayPos: integer;
begin

  FGamedata.FAktLevel := ALevel;
  ResetLevel;

  // Statistics
  FGamedata.FAktLevel := ALevel; // Will sometimes be overwritten by Resetlevel
  FGamedata.FMoves := 0;
  FGamedata.FPushes := 0;
  FGameData.FCratesStoredCount := 0;
  FGameData.FCrateTargetCount := 0;
  FGameData.FLevelWidth := succ(high(FPuzzleField));
  if FGameData.FLevelWidth > 0 then
    FGameData.FLevelHeight := succ(high(FPuzzleField[0]))
  else
    FGameData.FLevelHeight := 0;
  Arraypos := 0;

  for AXpos := 0 to high(FPuzzleField) do
    for AYpos := 0 to high(FPuzzleField[AXPos]) do
    begin
      // Search Player
      if FPuzzleField[AXPos, AYPos].FPartType = ptPlayer then
      begin
        FGameData.FPlayerPos.X := AXPos;
        FGameData.FPlayerPos.Y := AYPos;
      end;
      // Init Crates
      if FPuzzleField[AXPos, AYPos].FPartType = ptCrate then
      begin
        SetLength(FGameData.FCratesPos, ArrayPos + 1);
        FGameData.FCratesPos[ArrayPos].X := AXPos;
        FGameData.FCratesPos[ArrayPos].Y := AYPos;
        FPuzzleField[AXPos, AYPos].FCrateID := ArrayPos;
        if FPuzzleField[AXPos, AYPos].FIsCrateTarget then
          Inc(FGameData.FCratesStoredCount);
      end;
      // Cratetargets
      if FPuzzleField[AXPos, AYPos].FIsCrateTarget then
        Inc(FGameData.FCrateTargetCount);
    end; {e FOR y,x }

  // History
  FHistoryCount := 1;
  SetLength(FHistory, Succ(FHistoryCount));
  SetLength(FGameHistory, Succ(FHistoryCount));
  FHistory[FHistoryCount] := CopyPuzzleField(FPuzzleField);
  FGameHistory[FHistoryCount] := CopyGameData(FGamedata);

end;

//------------------------------------------------------------------------------

function TSokobanEngine.CopyGameData(ASource: TGameData): TGameData;
var
  LCrateID: integer;
begin
  with Result do
  begin
    FPlayerPos.X := ASource.FPlayerPos.X;
    FPlayerPos.Y := ASource.FPlayerPos.Y;
    FMoves := ASource.FMoves;
    FPushes := ASource.FPushes;
    FAktLevel:=ASource.FAktLevel;
    FCratesStoredCount := ASource.FCratesStoredCount;
    FCrateTargetCount := ASource.FCrateTargetCount;
    FLevelWidth := ASource.FLevelWidth;
    FLevelHeight := ASource.FLevelHeight;

    SetLength(FCratesPos, Length(ASource.FCratesPos));
    for LCrateID := Low(FCratesPos) to High(FCratesPos) do
    begin
      FCratesPos[LCrateID] := ASource.FCratesPos[LCrateID];
    end;
  end;
end;

//------------------------------------------------------------------------------

function TSokobanEngine.CopyPuzzleField(ASource: TPuzzleField): TPuzzleField;
var
  XPos, YPos: smallint;
begin
  if not assigned(ASource) then
  begin
    Result := nil;
    exit;
  end;
  SetLength(Result, Length(ASource), Length(ASource[0]));
  for XPos := 0 to Pred(Length(ASource)) do
  begin
    for YPos := 0 to Pred(Length(ASource[XPos])) do
    begin
      Result[XPos, YPos].FPartType := ASource[XPos, YPos].FPartType;
      Result[XPos, YPos].FSkinType := ASource[XPos, YPos].FSkinType;
      Result[XPos, YPos].FIsCrateTarget := ASource[XPos, YPos].FIsCrateTarget;
      Result[XPos, YPos].FCrateID := ASource[XPos, YPos].FCrateID;
    end;
  end;
end;

procedure TSokobanEngine.ResetLevel;
begin
  FRedoCount := FHistoryCount - 1;
  FHistoryCount := 1;
  if not assigned(FPuzzleCollection.FPuzzleFields) or
    (FGamedata.FAktLevel = 0) or (FGamedata.FAktLevel - 1 >
    high(FPuzzleCollection.FPuzzleFields)) then
    exit;
  FPuzzleField := CopyPuzzleField(
    FPuzzleCollection.FPuzzleFields[FGamedata.FAktLevel - 1]);
  if high(FGameHistory) > 0 then
    FGameData := CopyGameData(FGameHistory[1]);
end;

procedure TSokobanEngine.TryMovementCrate(ANewX, ANewY: integer);
var
  ANewCratePosX, ANewCratePosY: smallint;
  LCrateID: integer;

begin
  if (ANewX >= 0) and (ANewX < GetPuzzlewidth) and (ANewY >= 0) and
    (ANewY < GetPuzzleHeight) then
  begin
    ANewCratePosX := ANewX + (ANewX - FGameData.FPlayerPos.X);
    ANewCratePosY := ANewY + (ANewY - FGameData.FPlayerPos.Y);

    LCrateID := FPuzzleField[ANewX, ANewY].FCrateID;

    if (ANewCratePosX >= 0) and (ANewCratePosX < GetPuzzlewidth) and
      (ANewCratePosY >= 0) and (ANewCratePosY < GetPuzzleHeight) and
      (FPuzzleField[ANewCratePosX, ANewCratePosY].FPartType in [ptNone, ptEmpty]) then
    begin
      FPuzzleField[ANewCratePosX, ANewCratePosY].FPartType := ptCrate;

      if LCrateID >= 0 then
      begin
        FGameData.FCratesPos[LCrateID].X := ANewCratePosX;
        FGameData.FCratesPos[LCrateID].Y := ANewCratePosY;
        FPuzzleField[ANewCratePosX, ANewCratePosY].FCrateID := LCrateID;
      end;

      FPuzzleField[ANewX, ANewY].FCrateID := -1;
      FPuzzleField[ANewX, ANewY].FPartType := ptNone;

      // Statistics
      if FPuzzleField[ANewX, ANewY].FIsCrateTarget then
        Dec(FGameData.FCratesStoredCount);
      if FPuzzleField[ANewCratePosX, ANewCratePosY].FIsCrateTarget then
        Inc(FGameData.FCratesStoredCount);
      Inc(FGameData.FPushes);
    end;
  end;

end;

procedure TSokobanEngine.MovePlayer(ANew: TPoint);
begin
  if (ANew.X >= 0) and (ANew.X < GetPuzzlewidth) and (ANew.Y >= 0) and
    (ANew.Y < GetPuzzleheight) then
  begin
    if FPuzzleField[ANew.X, ANew.Y].FPartType = ptCrate then
      TryMovementCrate(ANew.X, ANew.Y);

    if FPuzzleField[ANew.X, ANew.Y].FPartType in [ptEmpty, ptNone] then
    begin
      Inc(FGameData.FMoves);

      FPuzzleField[FGameData.FPlayerPos.X,
        FGameData.FPlayerPos.Y].FPartType := ptNone;

      FPuzzleField[ANew.X, ANew.Y].FPartType := ptPlayer;

      if FPuzzleField[FGameData.FPlayerPos.X, FGameData.FPlayerPos.Y].FIsCrateTarget then
        FPuzzleField[FGameData.FPlayerPos.X,
          FGameData.FPlayerPos.Y].FSkinType := stStore
      else
        FPuzzleField[FGameData.FPlayerPos.X,
          FGameData.FPlayerPos.Y].FSkinType := stEmpty;

      if ANew.Y < FGameData.FPlayerPos.Y then
      begin
        if FPuzzleField[ANew.X, ANew.Y].FIsCrateTarget then
          FPuzzleField[ANew.X, ANew.Y].FSkinType := stPlayerUpStore
        else
          FPuzzleField[ANew.X, ANew.Y].FSkinType := stPlayerUp;
      end;
      if ANew.X > FGameData.FPlayerPos.X then
      begin
        if FPuzzleField[ANew.X, ANew.Y].FIsCrateTarget then
          FPuzzleField[ANew.X, ANew.Y].FSkinType :=
            stPlayerRightStore
        else
          FPuzzleField[ANew.X, ANew.Y].FSkinType := stPlayerRight;
      end;
      if ANew.Y > FGameData.FPlayerPos.Y then
      begin
        if FPuzzleField[ANew.X, ANew.Y].FIsCrateTarget then
          FPuzzleField[ANew.X, ANew.Y].FSkinType :=
            stPlayerDownStore
        else
          FPuzzleField[ANew.X, ANew.Y].FSkinType := stPlayerDown;
      end;
      if ANew.X < FGameData.FPlayerPos.X then
      begin
        if FPuzzleField[ANew.X, ANew.Y].FIsCrateTarget then
          FPuzzleField[ANew.X, ANew.Y].FSkinType :=
            stPlayerLeftStore
        else
          FPuzzleField[ANew.X, ANew.Y].FSkinType := stPlayerLeft;
      end;

      FGameData.FPlayerPos := ANew;

      // History
      FRedoCount := 0;
      Inc(FHistoryCount);
      SetLength(FHistory, Succ(FHistoryCount));
      SetLength(FGameHistory, Succ(FHistoryCount));
      FHistory[FHistoryCount] := CopyPuzzleField(FPuzzleField);
      FGameHistory[FHistoryCount] := CopyGameData(FGameData);
    end;
  end;
end;

end.
