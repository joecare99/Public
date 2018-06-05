unit unt_testcrt3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
    Windows,
{$ELSE}
{$ENDIF}
    SysUtils,
    Win32Crt;

procedure Execute;

const
    CComp: array[1..4, -2 .. 2] of word =
        ((42, 23, 0, 63, 127),
        (85, 42, 0, 42, 85),
        (127, 63, 0, 23, 42),
        (170, 85, 0, 0, 0));

implementation

uses
 {$IFnDEF FPC}     Windows,   {$ENDIF}
    types,
    Graphics;

const
    maxanim = 500;
    Filler = #$b0#$b1#$b2#$db;

type
    TColorKmpn = record
        case boolean of
            False: (c: TColor);
            True: (r, g, b, a: byte);
    end;

    TColIndex = record
        ci: TCHAR_INFO;
        cc: TColorKmpn;
    end;

var
    i, j, k, l, found: integer;
    cc: TColorKmpn;
    chi: TCHAR_INFO;
    ColIdx: array of TColIndex;


function CalcTPxColor(const i, j: integer; const lComp_2, lComp_1, lComp2, lComp1: word): TColorKmpn;
    inline;
begin
    Result.r := (i and $4) shr $2 * lComp_2 + (i and $8) shr $3 * lComp_1 +
        (j and $4) shr $2 * lComp2 + (J and $8) shr $3 * lComp1;
    Result.g := (i and $2) shr $1 * lComp_2 + (i and $8) shr $3 * lComp_1 +
        (j and $2) shr $1 * lComp2 + (J and $8) shr $3 * lComp1;
    Result.b := (i and $1) shr $0 * lComp_2 + (i and $8) shr $3 * lComp_1 +
        (j and $1) shr $0 * lComp2 + (J and $8) shr $3 * lComp1;
end;


function max(n1, n2: integer): integer; inline;
begin
    Result := n1;
    if n2 > n1 then
        Result := n2;
end;

function ColorComp(c1, c2: TColorKmpn): extended;
    inline;

var
    r, b, g: integer;
begin
    r := abs(c1.r - c2.r);
    g := abs(c1.g - c2.g);
    b := abs(c1.b - c2.b);
    Result := 1024 - (r + b + g + max(r, max(b, g))) / 1024;
end;

function ColorHash(const c: TColorKmpn): word;
    inline;

begin
    Result := (c.r and $F8) shr 3 or (c.g and $F8) shl 2 or (c.b and $F8) shl 7;
end;

function hashcolor(const h: word): TColorKmpn;
    inline;
begin
    Result.r := (h and $1F) shl 3;
    Result.g := (h and $3E0) shr 2;
    Result.b := (h and $7C00) shr 7;
end;

function ColorSubtr(const c1, c2: TColorKmpn): TColorKmpn;

    function begr(r, mi, mx: integer): integer;
    inline;

    begin
        if r <= mi then
            Result := mi
        else if r > mx then
            Result := mx
        else
            Result := r;
    end;

var
    r, b, g: integer;

begin
    r := c1.r;
    g := c1.g;
    b := c1.b;
    r := r - c2.r;
    g := g - c2.g;
    b := b - c2.b;
    r := c1.r + r div 4;
    G := c1.G + G div 4;
    b := c1.b + b div 4;
    Result.r := begr(r, 0, 255);
    Result.g := begr(g, 0, 255);
    Result.b := begr(b, 0, 255);
end;

type
    TchinfArr = array of TCHAR_INFO;

procedure FlushScreen(const sb: TchinfArr);

var
    srctReadRect: TRect;
    coordBufSize, coordBufCoord: TPoint;
begin
    srctReadRect.Top := 0; // top left: row 0, col 0
    srctReadRect.Left := 0;
    srctReadRect.Bottom := 49; // bot. right: row 1, col 79
    srctReadRect.Right := 79;

    coordBufSize.x := 80;
    coordBufSize.y := 50;

    coordBufCoord.x := 0;
    coordBufCoord.y := 0;

    console.WriteConsoleOutput(
        sb[0], // buffer to copy into
        coordbufSize, // col-row size of chiBuffer
        coordBufCoord, // top left dest. cell in chiBuffer
        srctReadRect); // screen buffer source rectangle
end;

procedure Execute;

var
    mb, bew: extended;
    rc: TColorKmpn;
    istcol: array[0..79, 0..49] of TColorKmpn;
    hashtab: array[0..32768] of word;
    sb: TchinfArr;
    bmp: TPortableNetworkGraphic;

begin
    bmp := TPortableNetworkGraphic.Create;
    bmp.LoadFromResourceName(HINSTANCE, 'JOE_CARE_H48');
      try
        TextMode(co80 + font8x8);
        // init
        for I := 0 to 15 do
            for J := 0 to 15 do
                for K := 4 downto 1 do
                  begin
                    chi.AsciiChar := filler[K];
                    chi.Attributes := i + J * 16;
                    cc := CalcTPxColor(i, j, CComp[K, -2], CComp[K, -1], CComp[K, 2], CComp[K, 1]);

                    // append Coloridx
                    found := -1;
                    for L := 0 to high(ColIdx) do
                        if cc.c = colIdx[L].cc.c then
                          begin
                            found := L;
                            break;
                          end;
                    if found = -1 then
                      begin
                        setlength(colIdx, high(colidx) + 2);
                        colidx[high(colidx)].ci := chi;
                        colidx[high(colidx)].cc := cc;
                      end;

                  end;

        for I := 0 to 32767 do
          begin
            cc := hashcolor(i);
            mb := ColorComp(cc, ColIdx[0].cc);
            found := 0;
            for l := 1 to high(ColIdx) do
              begin

                bew := ColorComp(cc, ColIdx[l].cc);
                if bew > mb then
                  begin
                    mb := bew;
                    chi := ColIdx[l].ci;
                    found := l;
                  end;
              end;
            hashtab[I] := found;
          end;
        fillchar(istcol{%H-}, sizeof(istcol), byte(0));
        writeln('Press Enter to Start');
        readln;
        GotoY(49);
        setlength(sb, 80 * 50);
        //          For I := 0 To maxanim Do
          begin
            for J := 0 to 79 do
                for K := 0 to 49 do
                  begin
                    rc.c := bmp.Canvas.Pixels[J div 2 + 6, K];
                    if (J > 0) and (k > 0) then
                        rc := ColorSubtr(rc, istcol[j - 1, k - 1]);
                    if K > 0 then
                        rc := ColorSubtr(rc, istcol[j, k - 1]);
                    if J > 0 then
                        cc := ColorSubtr(rc, istcol[j - 1, k])
                    else
                        cc := rc;
                    // cc := ColorSubtr(rc, istcol[j , k]);
                    chi := colidx[hashtab[colorhash(cc)]].ci;
                    sb[j + k * 80] := chi;
                    istcol[j, k] := colidx[hashtab[colorhash(cc)]].cc;
                  end;
            FlushScreen(sb);
            delay(10);
          end;
        writeln('Press Enter ...');
        readln;
        FreeAndNil(bmp);

      except
        On E: Exception do
            Writeln(E.ClassName, ': ', E.Message);
      end;
end;

end.
