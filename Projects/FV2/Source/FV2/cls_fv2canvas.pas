unit cls_fv2canvas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types;

type
  TFvCell = record
    Character: Char;
    Attribute: Byte;
  end;

  TFvCanvas = class
  private
    FWidth: Integer;
    FHeight: Integer;
    FCells: array of TFvCell;
    FOriginX: Integer;
    FOriginY: Integer;
    FOriginStack: array of TPoint;
    FClipStack: array of TRect;
    FClipRect: TRect;
    function GetCell(X, Y: Integer): TFvCell;
    procedure SetCell(X, Y: Integer; const AValue: TFvCell);
    function GetSize: TPoint;
  public
    constructor Create(AWidth, AHeight: Integer);
    procedure Resize(AWidth, AHeight: Integer);
    procedure Clear(ACharacter: Char = ' '; AAttribute: Byte = 0);
    procedure FillRect(const ARect: TRect; ACharacter: Char; AAttribute: Byte);
    procedure TextOut(X, Y: Integer; const AText: string; AAttribute: Byte = 0);
    procedure PushOrigin(X, Y: Integer; const AClipRect: TRect);
    procedure PopOrigin;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Size: TPoint read GetSize;
    property Cells[X, Y: Integer]: TFvCell read GetCell write SetCell; default;
  end;

implementation

constructor TFvCanvas.Create(AWidth, AHeight: Integer);
begin
  inherited Create;
  Resize(AWidth, AHeight);
end;

function TFvCanvas.GetSize: TPoint;
begin
  Result := Point(FWidth, FHeight);
end;

function TFvCanvas.GetCell(X, Y: Integer): TFvCell;
begin
  X := X + FOriginX;
  Y := Y + FOriginY;
  if (X < 0) or (Y < 0) or (X >= FWidth) or (Y >= FHeight) or
     (X < FClipRect.Left) or (Y < FClipRect.Top) or
     (X >= FClipRect.Right) or (Y >= FClipRect.Bottom) then
    Exit(Default(TFvCell));
  Result := FCells[Y * FWidth + X];
end;

procedure TFvCanvas.SetCell(X, Y: Integer; const AValue: TFvCell);
begin
  X := X + FOriginX;
  Y := Y + FOriginY;
  if (X < 0) or (Y < 0) or (X >= FWidth) or (Y >= FHeight) or
     (X < FClipRect.Left) or (Y < FClipRect.Top) or
     (X >= FClipRect.Right) or (Y >= FClipRect.Bottom) then
    Exit;
  FCells[Y * FWidth + X] := AValue;
end;

procedure TFvCanvas.Resize(AWidth, AHeight: Integer);
begin
  if (AWidth < 0) or (AHeight < 0) then
    raise ERangeError.Create('Canvas dimensions cannot be negative.');
  FWidth := AWidth;
  FHeight := AHeight;
  SetLength(FCells, FWidth * FHeight);
  FOriginX := 0;
  FOriginY := 0;
  SetLength(FOriginStack, 0);
  SetLength(FClipStack, 0);
  FClipRect := Rect(0, 0, FWidth, FHeight);
end;

procedure TFvCanvas.Clear(ACharacter: Char; AAttribute: Byte);
var
  I: Integer;
begin
  for I := 0 to High(FCells) do
  begin
    FCells[I].Character := ACharacter;
    FCells[I].Attribute := AAttribute;
  end;
end;

procedure TFvCanvas.FillRect(const ARect: TRect; ACharacter: Char;
  AAttribute: Byte);
var
  X, Y: Integer;
  LCell: TFvCell;
begin
  LCell.Character := ACharacter;
  LCell.Attribute := AAttribute;
  for Y := ARect.Top to ARect.Bottom - 1 do
    for X := ARect.Left to ARect.Right - 1 do
      Cells[X, Y] := LCell;
end;

procedure TFvCanvas.TextOut(X, Y: Integer; const AText: string;
  AAttribute: Byte);
var
  I: Integer;
  LCell: TFvCell;
begin
  LCell.Attribute := AAttribute;
  for I := 1 to Length(AText) do
  begin
    LCell.Character := AText[I];
    Cells[X + I - 1, Y] := LCell;
  end;
end;

procedure TFvCanvas.PushOrigin(X, Y: Integer; const AClipRect: TRect);
var
  LStackIndex: Integer;
  LClipRect: TRect;
begin
  SetLength(FOriginStack, Length(FOriginStack) + 1);
  LStackIndex := High(FOriginStack);
  FOriginStack[LStackIndex] := Point(FOriginX, FOriginY);
  SetLength(FClipStack, LStackIndex + 1);
  FClipStack[LStackIndex] := FClipRect;
  Inc(FOriginX, X);
  Inc(FOriginY, Y);
  LClipRect := Rect(AClipRect.Left + FOriginX, AClipRect.Top + FOriginY,
    AClipRect.Right + FOriginX, AClipRect.Bottom + FOriginY);
  if LClipRect.Left < FClipRect.Left then
    LClipRect.Left := FClipRect.Left;
  if LClipRect.Top < FClipRect.Top then
    LClipRect.Top := FClipRect.Top;
  if LClipRect.Right > FClipRect.Right then
    LClipRect.Right := FClipRect.Right;
  if LClipRect.Bottom > FClipRect.Bottom then
    LClipRect.Bottom := FClipRect.Bottom;
  FClipRect := LClipRect;
end;

procedure TFvCanvas.PopOrigin;
begin
  if Length(FOriginStack) = 0 then
    raise EInvalidOperation.Create('The canvas origin stack is empty.');
  FOriginX := FOriginStack[High(FOriginStack)].X;
  FOriginY := FOriginStack[High(FOriginStack)].Y;
  FClipRect := FClipStack[High(FClipStack)];
  SetLength(FOriginStack, Length(FOriginStack) - 1);
  SetLength(FClipStack, Length(FClipStack) - 1);
end;

end.
