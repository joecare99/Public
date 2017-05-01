unit fv2tCanvas;

{$mode delphi}{$H+}{$X+}

interface

uses
  Classes, SysUtils, Video;

type
  TFVColor = byte;
  TFVCell = TVideoCell;

  { TFV2CustomFont }

  TFV2CustomFont = record
    Normal,
    Highlight: TFVColor;
    procedure SetNormal(AAttr: TFVColor);
    procedure SetHighlight(AAttr: TFVColor);
  end;

  TFV2CustomPen = record
    Width: integer;
    Attr: byte;
    LastPenpos: TPoint;
  end;

  { TFV2CustomBrush }

  TFV2CustomBrush = record
    BrushSize: Tpoint;
    BrushData: array of TVideoCell;
  end;

  { TTCanvas }

  TTCanvas = class(TPersistent)
  private
    FBuffer: PVideoBuf;
    FCBuffer: array of TVideoCell;
    FLocks: integer;
    FPenPos: TPoint;
    FClipping:Boolean;
    FClipRect:TRect;
    FBrush: TFV2CustomBrush;
    FPen: TFV2CustomPen;
    FFont: TFV2CustomFont;
    FOrigin: TPoint;
    FSize: TPoint;
    function GetBrush: TFV2CustomBrush;
    function GetBuffer: PVideoBuf;
    function GetClipping: boolean;
    function GetClipRect: TRect;
    function GetColor(x, y: integer): TFVColor;
    function GetFont: TFV2CustomFont;
    function GetHeight: integer;
    function GetPen: TFV2CustomPen;
    function GetPixel(x, y: integer): TFVCell;
    function GetWidth: integer;
    procedure SetBrush(AValue: TFV2CustomBrush);
    procedure SetClipping(AValue: boolean);
    procedure SetClipRect(AValue: TRect);
    procedure SetColor(x, y: integer; AValue: TFVColor);
    procedure SetFont(AValue: TFV2CustomFont);
    procedure SetHeight(AValue: integer);
    procedure SetPen(AValue: TFV2CustomPen);
    procedure SetPenPos(AValue: TPoint);
    procedure SetPixel(x, y: integer; AValue: TFvCell);
    procedure SetWidth(AValue: integer);
  public
    constructor Create(R: TRect);
    destructor Destroy; override;
    procedure Resize(R: TRect);
    procedure Flush(R: TRect; ForceUpdate: boolean);
    // using font
    procedure TextOut(x, y: integer; Text: string); virtual;
    procedure GetTextSize(Text: string; out w, h: integer);
    function GetTextHeight(Text: string): integer;
    function GetTextWidth(Text: string): integer;
    function TextExtent(const Text: string): TPoint; virtual;
    function TextHeight(const Text: string): integer; virtual;
    function TextWidth(const Text: string): integer; virtual;
    // using TBrush
    procedure FillRect(r: TRect); virtual;
    // using TPen
    procedure MoveTo(p: TPoint); virtual;
    procedure Lineto(p: TPoint); virtual;
    // BufferRoutines
    procedure CopyBuffer(x,y,l:integer; var Buf);
    Procedure BrushCopy(r:Trect; out NewBrush:TFV2CustomBrush);
    Procedure DrawBrush(pos:Tpoint;const aBrush:TFV2CustomBrush);
    // properties
    property LockCount: integer read FLocks;
    property Font: TFV2CustomFont read GetFont write SetFont;
    property Pen: TFV2CustomPen read GetPen write SetPen;
    property Brush: TFV2CustomBrush read GetBrush write SetBrush;
    property Colors[x, y: integer]: TFVColor read GetColor write SetColor;
    property Pixels[x, y: integer]: TFvCell read GetPixel write SetPixel;
    property ClipRect: TRect read GetClipRect write SetClipRect;
    property Clipping: boolean read GetClipping write SetClipping;
    property PenPos: TPoint read FPenPos write SetPenPos;
    property Height: integer read GetHeight write SetHeight;
    property Width: integer read GetWidth write SetWidth;
    property CBuffer: PVideoBuf read GetBuffer;
  end;

implementation

uses fv2drivers, fv2RectHelper, fv2VisConsts;

{ TFV2CustomBrush }

function GetDrawCell(const brush: TFV2CustomBrush; p: Tpoint): TVideoCell;
begin
  Result := brush.BrushData[(p.x mod brush.BrushSize.x) +
    (p.y mod brush.BrushSize.y) * brush.BrushSize.x];
end;

{ TFV2CustomFont }

procedure TFV2CustomFont.SetNormal(AAttr: TFVColor); inline;
begin
  Normal := aAttr;
end;

procedure TFV2CustomFont.SetHighlight(AAttr: TFVColor); inline;
begin
  Highlight := aAttr;
end;

{ TTCanvas }

constructor TTCanvas.Create(R: TRect);

begin
  FBuffer := Video.VideoBuf;
  FOrigin := R.TopLeft;
  FSize := R.Size;
  setlength(FCBuffer, FSize.x * FSize.y);
end;

destructor TTCanvas.Destroy;
begin
  FBuffer := nil;
  setlength(FCBuffer, 0);
  inherited Destroy;
end;

procedure TTCanvas.Resize(R: TRect);
var
  lTempBuffer: array of TVideoCell;
  oldSize: TPOINT;
  y, x: integer;
begin
  setlength(lTempBuffer, length(FCBuffer));
  lTempBuffer := FCBuffer;
  oldSize := FSize;
  FOrigin := r.TopLeft;
  FSize := r.Size;
  setlength(FCBuffer, FSize.x * FSize.y);
  for y := 0 to FSize.y - 1 do
    for x := 0 to FSize.x - 1 do
    begin
      if (x < oldSize.x) and (y < oldSize.y) then
        FCBuffer[x + y * FSize.y] := lTempBuffer[x + y * oldSize.x]
      else
        FCBuffer[x + y * FSize.y] := GetDrawCell(FBrush, point(x, y));
    end;
  setlength(lTempBuffer, 0);
end;

procedure TTCanvas.Flush(R: TRect; ForceUpdate: boolean);
var
  Fchanged: boolean;
  y, x: longint;
begin
  if (FBuffer = nil) and (Video.VideoBuf = nil) then
    exit;
  if (FBuffer = nil) then
    FBuffer := video.VideoBuf;
  Fchanged := False;
  r.Intersect(ClipRect);
  for y := r.Top to r.Bottom - 1 do
    for x := r.left to r.Right - 1 do
    begin
      Fchanged := ForceUpdate or Fchanged or
        (FBuffer^[x + y * Screenmode.Col] <> FCBuffer[(x - FOrigin.x) + (y - FOrigin.y) * Fsize.x]);
      FBuffer^[x + y * Screenmode.Col] := FCBuffer[(x - FOrigin.x) + (y - FOrigin.y) * Fsize.x];
    end;
  if ForceUpdate or Fchanged then
    video.UpdateScreen(ForceUpdate);
end;

function TTCanvas.GetBrush: TFV2CustomBrush;
begin
  Result := FBrush;
end;

function TTCanvas.GetBuffer: PVideoBuf;
begin
  Result := @FCBuffer[0];
end;

function TTCanvas.GetClipping: boolean;
begin
  result := FClipping
end;

function TTCanvas.GetClipRect: TRect;
begin
  Result.TopLeft := FOrigin;
  Result.BottomRight := FSize.Add(Result.TopLeft);
end;

function TTCanvas.GetColor(x, y: integer): TFVColor;
begin
  if (x < FSize.x) and (y < FSize.y) then
    Result := hi(FCBuffer[x + y * FSize.x])
  else
    Result := $17;
end;

function TTCanvas.GetFont: TFV2CustomFont;
begin
  Result := FFont;
end;

function TTCanvas.GetHeight: integer;
begin
  Result := FSize.y;
end;

function TTCanvas.GetPen: TFV2CustomPen;
begin
  Result := FPen;
end;

function TTCanvas.GetPixel(x, y: integer): TFVCell;
begin
  if (x < FSize.x) and (y < FSize.y) then
    Result := FCBuffer[x + y * FSize.x]
  else
    Result := $1720;
end;

function TTCanvas.GetWidth: integer;
begin
  Result := FSize.x;
end;

procedure TTCanvas.SetBrush(AValue: TFV2CustomBrush);
begin
  FBrush := AValue;
end;

procedure TTCanvas.SetClipping(AValue: boolean);
begin
  FClipping := AValue;
end;

procedure TTCanvas.SetClipRect(AValue: TRect);
begin
  FClipRect := AValue;
end;

procedure TTCanvas.SetColor(x, y: integer; AValue: TFVColor);
begin
  if (x < FSize.x) and (y < FSize.y) then
    WordRec(FCBuffer[x + y * Fsize.x]).hi := AValue;
end;

procedure TTCanvas.SetFont(AValue: TFV2CustomFont);
begin
  FFont := AValue;
end;

procedure TTCanvas.SetHeight(AValue: integer);
begin
  FSize.y := Avalue
end;

procedure TTCanvas.SetPen(AValue: TFV2CustomPen);
begin
  Fpen := AValue;
end;

procedure TTCanvas.SetPenPos(AValue: TPoint);
begin
  if FPenPos.Equals(AValue) then
    Exit;
  FPenPos := AValue;
end;

procedure TTCanvas.SetPixel(x, y: integer; AValue: TFvCell);
begin
  if (x < FSize.x) and (y < FSize.y) then
    FCBuffer[x + y * Fsize.x] := AValue;
end;

procedure TTCanvas.SetWidth(AValue: integer);
begin
  FSize.x := Avalue
end;

procedure TTCanvas.TextOut(x, y: integer; Text: string);
var
  B: byte;
  I, J: integer;
  Attrs: word;
begin
  if (y < 0) or (y >= FSize.y) then
    exit;
  J := 0;                                            { Start position }
  Attrs := word(FFont);
  for I := 1 to Length(Text) do
  begin                 { For each character }
    if (Text[I] <> '~') then
    begin                                           { Not tilde character }
      if (J + X >= 0) and (J + X < FSize.x) then
      begin
        if (Lo(Attrs) <> 0) then
          WordRec(FCBuffer[J + X + y * FSize.x]).Hi := Lo(Attrs);
        { Copy attribute }
        WordRec(FCBuffer[J + X + y * FSize.x]).Lo := byte(Text[I]);
        { Copy string char }
      end;
      Inc(J);                                        { Next position }
    end
    else
    begin
      B := Hi(Attrs);                                { Hold attribute }
      WordRec(Attrs).Hi := Lo(Attrs);                { Copy low to high }
      WordRec(Attrs).Lo := B;                        { Complete exchange }
    end;
  end;
end;

procedure TTCanvas.GetTextSize(Text: string; out w, h: integer);
begin
  H := 1;
  w := CStrLen(Text);
end;

function TTCanvas.GetTextHeight(Text: string): integer;
begin
  Result := 1;
end;

function TTCanvas.GetTextWidth(Text: string): integer;
begin
  Result := CStrLen(Text);
end;

function TTCanvas.TextExtent(const Text: string): TPoint;
begin
  Result := point(CStrLen(Text), 1);
end;

function TTCanvas.TextHeight(const Text: string): integer;
begin
  Result := 1;
end;

function TTCanvas.TextWidth(const Text: string): integer;
begin
  Result := CStrLen(Text);
end;

procedure TTCanvas.FillRect(r: TRect);
var
  y, x: longint;
begin
  r.Intersect(Rect(0, 0, FSize.x, FSize.y));
  for y := r.top to r.Bottom - 1 do
    for x := r.Left to r.Right - 1 do
      FCBuffer[x + y * FSize.x] := GetDrawCell(FBrush, point(x, y));
end;

procedure TTCanvas.MoveTo(p: TPoint);
begin
  Fpen.LastPenpos := FPenpos;
  FPenpos := p;
end;

procedure TTCanvas.Lineto(p: TPoint);
var
  i: integer;
begin
  if abs(p.x - FPenPos.x) > abs(p.y - FPenPos.y) then
  begin
    if (FPen.LastPenpos.y > FPenPos.y) and (P.x > FPenPos.x) then
      Pixels[FPenPos.x, FPenPos.y] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[0]]);
    if (FPen.LastPenpos.y > FPenPos.y) and (P.x < FPenPos.x) then
      Pixels[FPenPos.x, FPenPos.y] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[2]]);
    if (FPen.LastPenpos.y < FPenPos.y) and (P.x > FPenPos.x) then
      Pixels[FPenPos.x, FPenPos.y] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[6]]);
    if (FPen.LastPenpos.y < FPenPos.y) and (P.x < FPenPos.x) then
      Pixels[FPenPos.x, FPenPos.y] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[8]]);

    for i := FPenPos.x + 1 to p.x do
    begin
      Pixels[I, FPenPos.y + (I - FPenPos.x) * (p.y - FPenPos.y) div (p.x - FPenPos.x)] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[1]]);
    end;
    for i := FPenPos.x - 1 downto p.x do
    begin
      Pixels[I, FPenPos.y + (I - FPenPos.x) * (p.y - FPenPos.y) div (p.x - FPenPos.x)] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[1]]);
    end;
  end
  else
  begin
    if (FPen.LastPenpos.x > FPenPos.x) and (P.y > FPenPos.y) then
      Pixels[FPenPos.x, FPenPos.y] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[0]]);
    if (FPen.LastPenpos.x < FPenPos.x) and (P.y > FPenPos.y) then
      Pixels[FPenPos.x, FPenPos.y] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[2]]);
    if (FPen.LastPenpos.x > FPenPos.x) and (P.y < FPenPos.y) then
      Pixels[FPenPos.x, FPenPos.y] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[6]]);
    if (FPen.LastPenpos.x < FPenPos.x) and (P.y < FPenPos.y) then
      Pixels[FPenPos.x, FPenPos.y] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[8]]);
    for i := FPenPos.y + 1 to p.y do
    begin
      Pixels[FPenPos.x + (I - FPenPos.y) * (p.x - FPenPos.x) div (p.y - FPenPos.y), i] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[3]]);
    end;
    for i := FPenPos.y - 1 downto p.y do
    begin
      Pixels[FPenPos.x + (I - FPenPos.y) * (p.x - FPenPos.x) div (p.y - FPenPos.y), i] :=
        word(Fpen.Attr) shl 8 or word(FrameChars_437[InitFrame[3]]);
    end;
  end;
  Fpen.LastPenpos := FPenpos;
  FPenpos := p;
end;

procedure TTCanvas.CopyBuffer(x, y, l: integer; var Buf);
begin

end;

procedure TTCanvas.BrushCopy(r: Trect; out NewBrush: TFV2CustomBrush);
begin

end;

procedure TTCanvas.DrawBrush(pos: Tpoint; const aBrush: TFV2CustomBrush);
begin

end;

end.
