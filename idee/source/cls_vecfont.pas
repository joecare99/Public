unit cls_VecFont;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
 types,
{$ENDIF}
  Classes, SysUtils, Graphics;

type


  TdAob = array of byte;
  TFontFileType = (fft_Compressed, fft_Normal, fft_Textfile);

  TScribeInst = record
    xkk,ykk,
    x0, y0,
    xk0, yk0: integer;
    size:integer;
    nr: integer;
  end;

  { TVectorFont }
  TVectorFont = class
  private
    FFileDescription: string;
    offset1: integer; // Header
    b: TdAob;
    FChanged: boolean;
    index: array[0..255] of integer;
    Characters: array[0..255] of TdAob;
    function GetCharacter(index: byte): TdAob;
    function GetBinIndex(nr: byte): word;
    function getnextxy(out xk, yk: integer; out cnt: Boolean;
      var ScribeInst: TScribeinst; ch: char): boolean;
    function getsvec(nr: word): byte;
    procedure Setchanged(AValue: boolean);
    procedure SetCharacter(index: byte; const AValue: TdAob);
    procedure SetFileDescription(AValue: string);
    procedure Setvec(nr: word; c0, c1, c2: byte);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromStream(aStream: TStream);
    procedure SaveToStream(aStream: TStream; FontFiletype: TFontFileType);
    Procedure Write(Canvas:TCanvas;x,y:integer;text:String;csize:integer=1);
    property changed: boolean read Fchanged write Setchanged;
    property FileDescription: string read FFileDescription write SetFileDescription;
    property Character[index: byte]: TdAob read GetCharacter write SetCharacter;
  end;

const
   dir: array[1..8] of TSmallPoint =
    ((x: 1; y: 0),
    (x: 1; y: -1),
    (x: 0; y: -1),
    (x: -1; y: -1),
    (x: -1; y: 0),
    (x: -1; y: 1),
    (x: 0; y: 1),
    (x: 1; y: 1));

implementation


const
  offset2 = 512; // Index




function TVectorFont.getsvec(nr: word): byte;

var
  art: byte;
  offs3, offs4, offs5{,offs6}: word;

begin
  offs3 := offset1 + offset2 + (nr div 12) * 5;
  offs4 := (nr div 3) mod 4;
  art := nr mod 3;
  offs5 := b[offs3 + offs4] * 256 + b[offs3 + offs4 + 1];
  //   offs6:=offs5;
  offs5 := offs5 shr ((3 - offs4) * 2);
  offs5 := offs5 and 1023;
  case art of
    0: Result := (offs5 div 100) mod 10;
    1: Result := (offs5 div 10) mod 10;
    2: Result := offs5 mod 10;
    else
      Result := 0;
  end;
end;

procedure TVectorFont.Setvec(nr: word; c0, c1, c2: byte);

var
  offs3, offs4, offs5, Mask, Data: word;

begin
  offs3 := offset1 + offset2 + (nr div 12) * 5;
  offs4 := (nr div 3) mod 4;

  offs5 := b[offs3 + offs4] * 256 + b[offs3 + offs4 + 1];

  Mask := 1023 shl ((3 - offs4) * 2);
  Data := ((c0 mod 10) * 100) + ((c1 mod 10) * 10) + (c2 mod 10);
  Data := Data shl ((3 - offs4) * 2);
  offs5 := offs5 and not Mask or Data;

  b[offs3 + offs4] := (offs5 and $ff00) shr 8;
  b[offs3 + offs4 + 1] := (offs5 and $ff);
end;


procedure TVectorFont.Setchanged(AValue: boolean);
begin
  if Fchanged = AValue then
    Exit;
  Fchanged := AValue;
end;

procedure TVectorFont.SetCharacter(index: byte; const AValue: TdAob);
begin
  Characters[index] := AValue;
  Fchanged := True;
end;

procedure TVectorFont.SetFileDescription(AValue: string);
begin
  if FFileDescription = AValue then
    Exit;
  FFileDescription := AValue;
end;

//Suche Charakter
function TVectorFont.GetBinIndex(nr: byte): word;

begin
  Result := b[offset1 + nr * 2] * 256 + b[offset1 + nr * 2 + 1];
end;

function TVectorFont.GetCharacter(index: byte): TdAob;
begin
  Result := Characters[index];
end;

constructor TVectorFont.Create;
begin
  inherited;
  Clear;
end;

destructor TVectorFont.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TVectorFont.Clear;
var
  i: integer;
begin
  setlength(b, 0);
  {$IFDEF FPC}
  FillByte(index, sizeof(index), 0);
  {$ELSE}
  FillChar(index, sizeof(index), 0);
  {$ENDIF}
 FFileDescription := '';
   FChanged := False;
  for i := 0 to 255 do
    setlength(Characters[i], 0);
end;

procedure TVectorFont.LoadFromStream(aStream: TStream);
var
  i: integer;
  j: longint;
  sZe: int64;
  calcSize: integer;
  compressed: boolean;
  lStrList: TStringList;
  lc: integer;
  line: string;
  aktchar: byte;
begin
  Sze := aStream.Size;
  SetLength(b, sZe);
  aStream.ReadBuffer(b[0], aStream.Size);
  FFileDescription := '';
  // Bestimme Description & Offset 1
  if b[0] < 64 then
  begin
    for i := 1 to b[0] do
      if b[i] = 26 then
      begin
        offset1 := i + 1;
        break;
      end
      else
        FFileDescription := FFileDescription + char(b[i]);
    index[0] := GetBinIndex(0);
    compressed := ((integer(index[0]) + offset1 + offset2) {%H-}> aStream.Size);
    for i := 1 to 256 do
    begin
      if i < 256 then
        index[i] := GetBinIndex(i);
 //     if (i > 0) then
        calcSize := index[i mod 256] - index[i - 1];
      if (i > 1) and (calcSize >= 0) and (calcSize < 128) then
        try
          aktchar := i - 1;
          setlength(Characters[aktchar], calcSize);
          for j := index[aktchar] to index[i mod 256] - 1 do
            if compressed then
              Characters[aktchar, j - index[aktchar]] := getsvec(j)
            else
              Characters[aktchar, j - index[aktchar]] := b[offset1 + offset2 + j] mod 16;

        except

        end;

    end;
  end
  else
  begin
    aStream.Position := 0;
    lStrList := TStringList.Create;
    try
      lStrList.LoadFromStream(aStream);
      FFileDescription := lStrList[0];
      lc := 1;
      while lc < lStrList.Count do
      begin
        line := lStrList[lc];
        if length(line) > 2 then
        begin
          aktchar := Ord(line[1]);
          for j := 3 to length(Line) do
            if Ord(line[J]) in [48..57] then
            begin
              setlength(Characters[aktchar], high(Characters[aktchar]) + 2);
              Characters[aktchar, high(Characters[aktchar])] :=
                Ord(line[J]) mod 48;
            end;
        end;
        Inc(lc);
      end;
    finally
      FreeAndNil(lStrList);
    end;
  end;
end;

procedure TVectorFont.SaveToStream(aStream: TStream; FontFiletype: TFontFileType);
var
  i, j, lFileSize: integer;
  raw: TdAob;
  lst: TStringList;
  line: string;
begin
  case fontfiletype of
    fft_Normal:
    begin
      // calc size
      index[0] := 0;
      for i := 0 to 254 do
        index[i + 1] := index[i] + high(Characters[i]) + 1;
      index[0] := index[255] + high(Characters[255])+1;
      lFileSize := length(FFileDescription) + 2 + {index} +offset2 + index[0];
      setlength(b, lFilesize);
      // Description
      b[0] := length(FFileDescription) + 1;
      for i := 1 to b[0] - 1 do
        b[i] := Ord(FFileDescription[i]) and $ff;
      // #26
      b[b[0]] := 26;
      // Index
      for i := 0 to 255 do
      begin
        b[b[0] + 1 + i * 2] := (index[i] and $ff00) shr 8;
        b[b[0] + 2 + i * 2] := (index[i] and $ff);
      end;
      // Data
      for i := 0 to 255 do
        for j := 0 to high(Characters[i]) do
          b[b[0] + 1 + offset2 + index[i] + j] := Characters[i, j] + 48;
      aStream.WriteBuffer(b[0], lFileSize-1);
    end;
    fft_Compressed:
    begin
      // calc size
      index[0] := 0;
      for i := 0 to 254 do
        index[i + 1] := index[i] + high(Characters[i]) + 1;
      index[0] := index[255] + high(Characters[255])+1;
      lFileSize := length(FFileDescription) + 2 + {index} +offset2 +
        ((index[0] + 11) div 12) * 5;
      setlength(b, lFilesize);
      // Description
      b[0] := length(FFileDescription) + 1;
      for i := 1 to b[0] - 1 do
        b[i] := Ord(FFileDescription[i]) and $ff;
      // #26
      b[b[0]] := 26;
      // Index
      for i := 0 to 255 do
      begin
        b[b[0] + 1 + i * 2] := (index[i] and $ff00) shr 8;
        b[b[0] + 2 + i * 2] := (index[i] and $ff);
      end;
      // Data
      setlength(raw, ((index[0]) div 3)*3+3);
      for i := 0 to 255 do
        for j := 0 to high(Characters[i]) do
          raw[index[i] + j] := Characters[i, j];
      // Compress
      offset1 := b[0] + 1;
      for i := 0 to high(raw) div 3 do
        Setvec(i * 3, raw[i * 3], raw[i * 3 + 1], raw[i * 3 + 2]);
      aStream.WriteBuffer(b[0], lFileSize-1);
    end;
    fft_Textfile:
    begin
      lst := TStringList.Create;
      try
        lst.Add(FFileDescription);
        for i := 0 to 255 do
          if high(Characters[i]) >= 0 then
          begin
            line := char(i) + ':'#9;
            for j := 0 to high(Characters[i]) do
              line := line + char(Characters[i, j] + 48);
            lst.Add(line);
          end;
        lst.SaveToStream(aStream);
      finally
        FreeAndNil(lst);
      end;
    end;
  end; {Case}
  FChanged:=false;
end;

function TVectorFont.getnextxy(out xk, yk: integer;out cnt:Boolean;
  var ScribeInst: TScribeinst; ch: char): boolean;

var
  v: byte;
  oy: Integer;
  ox: Integer;

begin
  result := True;
  cnt:=false;
  with ScribeInst do
    case ch of
      #10:
      begin
        nr := 0;
        yk0 := yk0 + 12*size;
        xkk:=xk0;
        ykk:=yk0;
        result := False;
      end;
      #13:
      begin
        nr := 0;
        xk0 := x0;
        xkk:=xk0;
        ykk:=yk0;
        result := False;
      end
      else
        if high(Characters[Ord(ch)])>=0 then
      begin
        v := Characters[Ord(ch), nr];
        case v of
          0:
          begin //EOC
            result := False;
            v := 0;
            while (v = 0) and (high(Characters[Ord(ch)]) >=nr) do
            begin
              nr := nr + 1;
              if xk0<xkk then
                xk0 := xkk + size
              else
                xk0 := xk0 + size;
              if high(Characters[Ord(ch)]) >=nr then
                v := Characters[Ord(ch), nr];
            end;
            nr := 0;
          end;
          9:
          begin //Goto
            oy:=ykk;
            ox:=xkk;
            xkk := Characters[Ord(ch), nr + 1]* size + xk0;
            ykk := Characters[Ord(ch), nr + 2]* size + yk0;
            cnt:= (nr=0) and (abs(ox-xkk)<=size) and (abs(oy-ykk-size)<=size*2);
            nr := nr + 3;
          end
          else
          begin
            xkk := xkk + dir[v].x* size;
            ykk := yKk + dir[v].y* size;
            nr := nr + 1;
            cnt := true;
          end
        end {case};
      end
        else
          result := false;
    end {case};
  xk:= ScribeInst.xkk;
  yk:= ScribeInst.ykk;
end;

procedure TVectorFont.Write(Canvas: TCanvas; x, y: integer; text: String;
  csize: integer);

var lScribeInst:TScribeInst;
    xk,yk:integer;
    as0: Integer;
    cnt: Boolean;
begin
  with lScribeInst do
    begin
  xk0:=x;
  xkk:=x-2;
  ykk:=y-2;
  x0:=x;
  yk0:=y;
  nr:=0;
  size:=csize;
  for as0:=1 to length(text) do
    while getnextxy(xk,yk,cnt,lScribeInst,text[as0]) do
      begin
        if cnt then
          begin
          canvas.lineto(xk,yk);
          canvas.Pixels[xk,yk]:=canvas.pen.color;
          end
        else
        begin
          canvas.moveto(xk,yk);
          canvas.Pixels[xk,yk]:=canvas.pen.color;
        end
      end;
    end;
end;

end.
