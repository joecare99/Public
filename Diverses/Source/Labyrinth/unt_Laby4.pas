unit unt_Laby4;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils;

type

    TUpdateCellEvent = procedure(Sender: TObject; Cell: TPoint) of object;
    { THeightLaby }

    THeightLaby = class // (TBaseLaby)

    private
        FOnUpdate: TNotifyEvent;
        FOnUpdateCell: TUpdateCellEvent;
        type
        TPosArray = array[0..3] of TPoint;
    const
        FPrest: string =
            '111102010111101001020301102100010001112201210011103101010010211112';
        FPrest2: string = '4465452.7575331.6566211.' +
            '213265103021342243312434';
    var
        sstr: string;
        FDimension: TRect;
        FZValues: array of array of integer;

        function GetLabyHeight(x, y: integer): integer; overload; inline;
        function GetLabyHeight(pnt: TPoint): integer; overload; inline;
        procedure SetDimension(const AValue: TRect);
        procedure SetOnUpdate(const AValue: TNotifyEvent);
        procedure SetOnUpdateCell(const AValue: TUpdateCellEvent);
    {$ifdef DEBUG}
     public
    {$endif}
        procedure Clear;
        function CalcPStepHeight(ActPlace, NextPlace: TPoint;
            out Height: integer): boolean;
        function GetRnd(cnt: integer): integer;
        procedure SetLData(Sdat: string; xm, ym, Offset: integer);
        procedure SetLabyHeight(x, y,val: integer); overload; inline;
    public
        procedure Generate;
        function Baselevel(x, y: integer): integer;
        property OnUpdate: TNotifyEvent read FOnUpdate write SetOnUpdate;
        property OnUpdateCell: TUpdateCellEvent read FOnUpdateCell write SetOnUpdateCell;
        property Dimension: TRect read FDimension write SetDimension;
        property LabyHeight[x, y: integer]: integer read GetLabyHeight; default;
        property LabyHeightp[pnt: TPoint]: integer read GetLabyHeight;
    end;

implementation

(*
         4465452.
         7575331.
         6566211.
         21326510
         30213422
         43312434

*)
uses unt_Point2d;

{ THeightLaby }

function THeightLaby.GetRnd(cnt: integer): integer;

var
    st: byte;

begin
    if length(sstr) = 0 then
        exit(random(cnt))
    else
      begin
        st := Ord(sstr[1]) - Ord('0');
        Delete(sstr, 1, 1);
      end;
    if (st <= cnt) then
        exit(st)
    else
        exit(random(cnt));
end;

procedure THeightLaby.SetLData(Sdat: string; xm, ym, Offset: integer);
var
    x, y: integer;
begin
    for x := 0 to xm - 1 do
        for y := 0 to ym - 1 do
            FZValues[x, y] := Ord(Sdat[(xm * ym) - y * xm - x]) - 48 + Offset;
end;

procedure THeightLaby.SetLabyHeight(x, y, val: integer);
begin
    if FDimension.Contains(Point(x, y)) and (FZValues[x, y]<>val)then
       FZValues[x, y]:=val;
end;

function THeightLaby.Baselevel(x, y: integer): integer;
begin
    Result := trunc((x / 1.3) + (y / 1.3)) + 1;
end;

function THeightLaby.GetLabyHeight(x, y: integer): integer;
begin
    if FDimension.Contains(Point(x, y)) then
        Result := FZValues[x, y]
    else
        Result := 0;
end;

function THeightLaby.GetLabyHeight(pnt: TPoint): integer;
begin
    if FDimension.Contains(pnt) then
        Result := FZValues[pnt.x, pnt.y]
    else
        Result := 0;
end;

procedure THeightLaby.SetDimension(const AValue: TRect);
begin
    if FDimension = AValue then
        Exit;
    FDimension := AValue;
    setlength(FZValues, AValue.Width, Avalue.Height);
end;

procedure THeightLaby.SetOnUpdate(const AValue: TNotifyEvent);
begin
    if FOnUpdate = AValue then
        Exit;
    FOnUpdate := AValue;
end;

procedure THeightLaby.SetOnUpdateCell(const AValue: TUpdateCellEvent);
begin
    if FOnUpdateCell = AValue then
        Exit;
    FOnUpdateCell := AValue;
end;

function THeightLaby.CalcPStepHeight(ActPlace, NextPlace: TPoint;
    out Height: integer): boolean;

var
    bFlCanm1, bFlCanz, bFlCanp1: boolean;
    iLbht, bl, ph, i: integer;
    t, dd, dr: TPoint;
begin
    ph := GetLabyHeight(ActPlace);
    if (ph=0) or (GetLabyHeight(NextPlace)<>0)   then
        exit(false);
    bFlCanm1 := True;
    bFlCanz := True;
    bFlCanp1 := True;
    for i := 1 to 4 do
      begin
        t := NextPlace.Add(dir4[i].AsPoint);
        if not (t = ActPlace) then
          begin
            iLbht := GetLabyHeight(t);
            bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht<ph-2) or (iLbht>ph));
            bFlCanz := bFlCanz and ((iLbht = 0) or (iLbht<ph-1) or (iLbht>ph+1));
            bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht<ph) or (iLbht>ph+2));
          end
        else
            dd := dir4[i].AsPoint;
      end;
    dr := point(-dd.Y, dd.x); // rotate dd by 90°
    if (GetLabyHeight(NextPlace.Subtract(dr)) = 0) then
      begin
        iLbht := GetLabyHeight(NextPlace.Subtract(dr).add(dd));
        bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht <> ph - 1));
        bFlCanz := bFlCanz and ((iLbht = 0) or (iLbht <> ph));
        bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht <> ph + 1));
        iLbht := GetLabyHeight(NextPlace.Subtract(dr).Subtract(dd));
        bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht <> ph - 1));
        bFlCanz := bFlCanz and ((iLbht = 0) or (iLbht <> ph));
        bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht <> ph + 1));
      end;
    if (GetLabyHeight(NextPlace.add(dr)) = 0) then
      begin
        iLbht := GetLabyHeight(NextPlace.add(dr).add(dd));
        bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht <> ph - 1));
        bFlCanz := bFlCanz and ((iLbht = 0) or (iLbht <> ph));
        bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht <> ph + 1));
        iLbht := GetLabyHeight(NextPlace.add(dr).subtract(dd));
        bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht <> ph - 1));
        bFlCanz := bFlCanz and ((iLbht = 0) or (iLbht <> ph));
        bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht <> ph + 1));
      end;
    bl := Baselevel(NextPlace.x, NextPlace.y);
    Height := 0;
    // 24 Options
    if not (bFlCanm1 or bFlCanp1 or bFlCanz) then
        exit(False);
    // 21 Options
    // optimal Choice
    if bFlCanp1 and ((bl > ph){-4} or (not bFlCanz) and (not bFlCanm1 or (bl = ph))) then
      begin
        Height := ph + 1;
        exit(True);
      end;
    if bFlCanm1 and ((bl < ph){-4} or (not bFlCanz) and (not bFlCanp1 or (bl = ph))) then
      begin
        Height := ph - 1;
        exit(True);
      end;
    if bFlCanz then
      begin
        Height := ph;
        exit(True);
      end;
    exit(False); // Should never be reached
end;

procedure THeightLaby.Clear;
var
    x, y: integer;
begin
    for x := 0 to FDimension.Width - 1 do
        for y := 0 to FDimension.Height - 1 do
            FZValues[x, y] := 0;
end;

procedure THeightLaby.Generate;
var
    x, y, DirCount, FifoPushIdx, FifoPopIdx, I, zz, zm: integer;
    ActCell, Accu: TPoint;
    StoredCell, t: TPoint;
    Fifo: array of TPoint;
    HH: array[0..3] of integer;
    PosibDir: TPosArray;
    ActDirP, cn, zx, cx: integer;
    First: boolean;
    pp, Next: TPoint;
    ActDir: T2DPoint;

begin
    Randomize;
    {$ifdef DEBUG}
    RandSeed := 123;
    {$endif }
    sstr := '';// FPrest;
    // rohdaten -Init
    Clear;
    SetLData(FPrest2, 8, 6, 2);
    // Laby-Algoritmus
    ActCell := Point(1, 6);
    StoredCell := ActCell;
    Accu := Point(0, 0);
      try
        FZValues[ActCell.x, ActCell.y] :=
            Baselevel(ActCell.x, ActCell.y) - 1;
        FifoPushIdx := 0;
        FifoPopIdx := 0;
        SetLength(Fifo{%H-}, FDimension.Width * FDimension.Height);
        Dircount := 1;
        while (DirCount <> 0) or (FifoPushIdx >= FifoPopIdx) do
          begin
            // Switch
            t := ActCell;
            ActCell := StoredCell;
            StoredCell := t;
            // Calculate Valid directions and store them in PosibDir
            if assigned(FOnUpdateCell) then
                FOnUpdateCell(Self, actcell);
            Dircount := 0;
            for ActDir in dir4 do
              begin
                PosibDir[DirCount] := ActDir.asPoint;
                Next := ActCell.Subtract(PosibDir[DirCount]);
                // Teste ob Richtung möglich
                if FDimension.Contains(Next) and
                   CalcPStepHeight(actcell, Next, HH[Dircount]) and
                    (abs(HH[Dircount]-Baselevel(Next.x,Next.y)-1)<3) then
                  begin
                    Inc(Dircount);
                  end;
              end;
            if Dircount > 0 then
                ActDirP := GetRnd(Dircount);
            if (DirCount > 0) and (ActDirP < Dircount) then
              begin
                // Push Cell to the Fifo
                if dircount > 1 then
                  begin
                    Fifo[FifoPushIdx] := ActCell;
                    Inc(FifoPushIdx);
                  end;
                next := ActCell.Subtract(PosibDir[ActDirP]);
                ActCell:=next;
                FZValues[next.x, next.y] := HH[ActDirP]
              end
            else
              begin
                // Pop Cell from the Fifo
                if FifoPushIdx >= FifoPopIdx then
                  begin
                    ActCell:=Fifo[FifoPopIdx];
                    Inc(FifoPopIdx);
                  end;
              end;
{$ifdef ShowLabyCreation}
          if (FifoPushIdx mod FDimension.Width = 0) {or (length(sstr)>0)} then
            begin
              for x := 0 to FDimension.Width - 1 do
                  for y := 0 to FDimension.Height - 1 do
                    begin
                      PaintField(x, y);
                    end;
              Application.ProcessMessages;
              sleep(1);
            end;
{$endIf}
          end;
      finally
        SetLength(Fifo, 0);
      end;
    //  exit;
    // nicht besetzte Zellen
    for x := (FDimension.Width - 1) or 1 downto 0 do
        for y := (FDimension.Height - 1) or 1 downto 0 do
          begin
            pp := point(x xor 1, y xor 1);
            if FDimension.Contains(pp) and (GetLabyHeight(pp) = 0) then
              begin
                First := True;
                zm := 0;
                cn := 0;
                zx := 0;
                cx := 0;
                for I := 1 to 4 do
                  begin
                    zz := GetLabyHeight(pp.Add(dir4[i].AsPoint));
                    if (zz > 0) and ((First) or (zz <= zm)) then
                      begin
                        if zz < zm then
                            cn := 0;
                        zm := zz;
                        if cn < 2 then
                            Inc(cn);
                      end;
                    if (zz > 0) and ((First) or (zz >= zx)) then
                      begin
                        if zz > zx then
                            cx := 0;
                        zx := zz;
                        if cx < 2 then
                            Inc(cx);
                        First := False;
                      end;
                  end;
                if zm > 0 then
                   if (cx=1) and (zx-zm<6)  then
                     FZValues[pp.x, pp.y] := zx + cx
                   else
                     FZValues[pp.x, pp.y] := zm - cn
                 else
                     FZValues[pp.x, pp.y] := Baselevel(pp.x,pp.y);
              end;
          end;
end;

end.
