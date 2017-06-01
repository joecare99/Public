unit Cls_ColCub;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type
  TTileType = integer;

  { TColCubEngine }

  TColCubEngine = class
  private
    FCols: integer;
    FEditMode: boolean;
    FMoves: integer;
    FRows: integer;
    FPlayField: array of TTileType;
    function GetTile(x, y: integer): TTileType;
    procedure SetCols(AValue: integer);
    procedure SetEditMode(AValue: boolean);
    procedure SetMoves(AValue: integer);
    procedure SetRows(AValue: integer);
    procedure SetTile(x, y: integer; AValue: TTileType);
  public
    procedure Initialize;
    procedure Shuffle;
    procedure MoveCol(idx: integer; Fwd: boolean);
    procedure MoveRow(idx: integer; Fwd: boolean);
    Function IsComplete:boolean;
    property Rows: integer read FRows write SetRows;
    property Cols: integer read FCols write SetCols;
    property Tile[x, y: integer]: TTileType read GetTile write SetTile; default;
    property Moves: integer read FMoves write SetMoves;
    property EditMode: boolean read FEditMode write SetEditMode;
  end;

implementation

const
  MaxShuffle = 20;

{ TColCubEngine }

procedure TColCubEngine.SetCols(AValue: integer);
begin
  if FCols = AValue then
    Exit;
  FCols := AValue;
end;

function TColCubEngine.GetTile(x, y: integer): TTileType;
begin
  Result := FPlayField[x + y * FCols];
end;

procedure TColCubEngine.SetEditMode(AValue: boolean);
begin
  if FEditMode = AValue then
    Exit;
  FEditMode := AValue;
end;

procedure TColCubEngine.SetMoves(AValue: integer);
begin
  if FMoves = AValue then
    Exit;
  FMoves := AValue;
end;

procedure TColCubEngine.SetRows(AValue: integer);
begin
  if FRows = AValue then
    Exit;
  FRows := AValue;
end;

procedure TColCubEngine.SetTile(x, y: integer; AValue: TTileType);
begin
  if FEditMode then
    FPlayField[x + y * FCols] := AValue;
end;

procedure TColCubEngine.Initialize;
var
  Y, X: integer;
begin
  setlength(FPlayField, FRows * FCols);
  for Y := 0 to FRows - 1 do
    for X := 0 to FCols - 1 do
      FPlayField[X + Y * FCols] := TTileType(Y + 1);
end;

procedure TColCubEngine.Shuffle;
var
  i: integer;
begin
  for i := 0 to MaxShuffle do
    case Random(4) of
      0: MoveCol(Random(FCols), True);
      1: MoveCol(Random(FCols), False);
      2: MoveRow(Random(FRows), True);
      3: MoveRow(Random(FRows), False);
    end;
  FMoves := 0;
  FEditMode:=false;
end;

procedure TColCubEngine.MoveCol(idx: integer; Fwd: boolean);
var
  tt: TTileType;
  i: integer;
begin
  if Fwd then
  begin
    tt := FPlayField[idx + (0) * FCols];
    for i := 1 to FRows - 1 do
      FPlayField[idx + (i - 1) * FCols] := FPlayField[idx + i * FCols];
    FPlayField[idx + (FRows - 1) * FCols] := tt;
  end
  else
  begin
    tt := FPlayField[idx + (FRows - 1) * FCols];
    for i := 1 to FRows - 1 do
      FPlayField[idx + (FRows - i) * FCols] := FPlayField[idx + (FRows - i - 1) * FCols];
    FPlayField[idx + (0) * FCols] := tt;
  end;

  FMoves := FMoves + 1;
end;

procedure TColCubEngine.MoveRow(idx: integer; Fwd: boolean);
var
  tt: TTileType;
  i: integer;
begin
  if Fwd then
  begin
    tt := FPlayField[0 + idx * FCols];
    for i := 1 to FCols - 1 do
      FPlayField[(i - 1) + idx * FCols] := FPlayField[i + idx * FCols];
    FPlayField[FCols - 1 + idx * FCols] := tt;
  end
  else
  begin
    tt := FPlayField[FCols - 1 + idx * FCols];
    for i := 1 to FCols - 1 do
      FPlayField[(FCols - i) + idx * FCols] := FPlayField[(Fcols - i - 1) + idx * FCols];
    FPlayField[0 + idx * FCols] := tt;
  end;

  FMoves := FMoves + 1;
end;

function TColCubEngine.IsComplete: boolean;
var
  Y, X: Integer;
begin
    for Y := 0 to FRows - 1 do
    for X := 0 to FCols - 1 do
      if FPlayField[X + Y * FCols] <> TTileType(Y + 1) then
      exit(false);
  result := true;
end;

end.
