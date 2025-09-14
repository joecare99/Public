unit Frm_BoxFlight;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  {$IFNDEF FPC}
  Winapi.Windows, Winapi.Messages, Windows,
  {$ELSE}
  LCLIntf, LCLType, GraphMath,
  {$ENDIF}
  {SYSTEM}
  SysUtils, Variants, Math,
  ExtCtrls, Classes,
  {VCL}
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TEnumObjType=(eot_Cylinder, eot_Box);

  TRenderEntry = record
    light, Height,shad ,oo1: integer;
    Color: TColor;
    light2, Height2, Color2,oo2: integer;
    light3, Height3, Color3: integer;
  end;

  TidxArray = array of integer;
  { TObstacles }

  TObstacles = class
    pos:TPoint;
    size,rot: integer;
    vp: TFloatPoint;
    Visible, hit: boolean;
    color: TColor;
    ObjType:TEnumObjType;
    function ComputeVisibility(const fCPoint, fCView, lCV2: TFloatPoint;
      const lCV1: TFloatPoint): boolean;
    function Hittest(fCPoint, rendir: TFloatPoint; out rdistq, r: single): boolean;virtual; abstract;
    Function Reflect(rendir:TFloatPoint;rr:single;out xx:single):TFloatPoint;virtual; abstract;
  end;


  { TCylinder }

  TCylinder = class(TObstacles)
    function Hittest(fCPoint, rendir: TFloatPoint; out rdistq, r: single): boolean;override;
    Function Reflect(rendir: TFloatPoint; rr: single;out xx:single): TFloatPoint; override;
  end;

  { TBox }

  TBox = class(TObstacles)
    function Hittest(fCPoint, rendir: TFloatPoint; out rdistq, r: single): boolean;Override;
    Function Reflect(rendir: TFloatPoint; rr: single;out xx:single): TFloatPoint; override;
  end;

  { TForm6 }

  TForm6 = class(TForm)
    BitBtn2: TBitBtn;
    chbPause: TCheckBox;
    chbStereo: TCheckBox;
    Label1: TLabel;
    Timer1: TTimer;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    TrackBar1: TTrackBar;
    BitBtn1: TBitBtn;
    ScrollBar1: TScrollBar;
    chbShowObjects: TCheckBox;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PaintBox2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject);
  private
    fObjects: array of TObstacles;
    fObjIdx: array of array of TidxArray;
    fRendercache: array of TRenderEntry;
    fRendermap: tBitmap;
    FActiveObj1,
    FActiveObj2,
    fxx:integer;
    fCPoint: TFloatPoint;
    fCPoint2: TFloatPoint;
    fCPoint3: TFloatPoint;
    fCView: TFloatPoint;
    fCMove: TFloatPoint;
    fTime: integer;
    procedure AppendIndex(pp: Tpoint; i: integer);
    function GetIndex(pp: tpoint): TidxArray;
    function ObjHit(const fCPoint, RenDir: TFloatPoint; IgnObj: integer;
      var obj: integer; var rDist, rr: extended): boolean;
    function PathFunction(Omega: extended): TFloatPoint;
    function Trace(const MaxHeight: integer; const lSPnt: TFloatPoint;
      ll: extended; obj: integer; const RenDir: TFloatPoint; Hit: boolean;
  var rDistq: single; var r: single): TRenderEntry;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form6: TForm6;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

uses unt_Cdate;

Function TForm6.ObjHit(const fCPoint, RenDir:TFloatPoint;IgnObj:integer;var obj:integer;var rDist,rr:extended):boolean ;inline;
var
  pp: tpoint;
  lIdxObj: TidxArray;
  i,dd: integer;
  rDistq, r: single;
begin
  result := false;
  for dd := 0 to 50 do
   begin
     pp.x := trunc(600 - fCPoint.x - RenDir.x * dd * 9);
     pp.x := (pp.x + 800) mod 400;
     pp.y := trunc(600 - fCPoint.y - RenDir.y * dd * 9);
     pp.y := (pp.y + 800) mod 400;
     lIdxObj := GetIndex(pp);
     for I := 0 to High(lIdxObj) do
       begin
         fObjects[lIdxObj[I]].Visible:=true;
         if (lIdxObj[I] <> IgnObj) and  fObjects[lIdxObj[I]].Hittest(fCPoint, RenDir, rDistq, r) and (rDistq > 0.01) and
           (rDistq < rDist) then
         begin
             result := true;
           obj := lIdxObj[I];
           rDist := rDistq;
           rr := r;
         end;
       end;
     if trunc(rDist) < (dd - 1) * 8 then
       break;
   end;
end;


function TForm6.Trace(const MaxHeight: integer; const lSPnt: TFloatPoint;
  ll: extended; obj: integer; const RenDir: TFloatPoint;Hit:boolean; var rDistq: single;
  var r: single): TRenderEntry;

var
  lsobj: integer;
  RenDir3: TFloatPoint;
  lCPoint3: TFloatPoint;
  rDist2: extended;
  obj2: integer;
  RenDir2: TFloatPoint;
  lCPoint2: TFloatPoint;
  ll2: ValReal;
  rr: extended;
  rDist: extended;
  xxa: single;

begin
  if (obj >= 0) and fObjects[obj].Hittest(fCPoint, RenDir, rDistq, r) and
    (rDistq > 2) and (rDistq < 300.0) then
  begin
    rDist := rDistq;
    rr := r;
  end
  else
  begin
    obj := -1;
    rDist := 300.0;
  end;
  ObjHit(fCPoint, RenDir,-1,obj, rDist, rr);
  if obj >= 0 then
  begin
    fObjects[obj].hit := True;

    RenDir2 := fObjects[obj].Reflect(RenDir,rr,xxa);

    {--Ambient--}

    ll := 96.0 + 96 * xxa;
    ll2 := sqr(sqr(4.0 - 4.0 * RenDir2.y)) - 4096.5 + 256.0;
    ll := Math.max(ll, ll2);
    result.oo1 := obj;
    result.light := trunc(ll);
    result.Height := trunc(MaxHeight / (rDist + 1));
    if (ll > 192.0) or (obj = FactiveObj1)  then
      result.Color := clwhite
    else
      if (obj = FactiveObj2) then
      result.Color := clYellow
      else
      result.Color := fObjects[obj].color;
    {---------------}
    lCPoint2.x:=fCPoint.x+RenDir.x*rdist;
    lCPoint2.y:=fCPoint.y+RenDir.y*rdist;
    if Hit then fCPoint2 := lCPoint2;
    if ll<=192.0 then
      begin
    rdist2:=300-rdist;
    obj2:= -1;
    ObjHit(lCPoint2, RenDir2,obj,obj2, rDist2, rr);
    if obj2 >= 0 then
    begin
      fObjects[obj2].hit := True;

      { Reftection-Omega (-pi .. pi)}
      RenDir3 := fObjects[obj].Reflect(RenDir2,rr,xxa);
      {--Ambient--}

      ll := 32.0 + 32 * xxa+ll;
      ll2 := sqr(sqr(4.0 - 4.0 * RenDir3.y)) - 4096.5 + 256.0;
      ll := Math.max(ll, ll2);
      result.oo2 := obj2;
      result.light2 := trunc(ll) ;
      result.Height2 := trunc(MaxHeight / (rDist+rDist2 + 1));
      if (ll > 192.0) or (FActiveObj1 = obj2) then
        result.Color2 := result.Color
      else
       if (obj2 = FactiveObj2) then
         result.Color2 := clYellow
       else
         result.Color2 := fObjects[obj2].color;

      {---------------}
      lCPoint3.x:=lCPoint2.x+RenDir2.x*math.max(rdist2,5.0);
      lCPoint3.y:=lCPoint2.y+RenDir2.y*math.max(rdist2,5.0);
      if Hit then fCPoint3 := lCPoint3;
    end
     else
  begin
    result.light2 := 0;
    result.Height2 := 0;
  end
  END
  else
  begin
    result.light2 := 0;
    result.Height2 := 0;
    result.oo2 := -1;
    if hit then
      begin
   fCPoint3.x:=lCPoint2.x+RenDir2.x*40;
   fCPoint3.y:=fCPoint2.y+RenDir2.y*40;
      end
  end
  end
  else
  begin
    result.light := 0;
    result.Height := 0;
    result.light2 := 0;
    result.Height2 := 0;
    result.oo1 := -1;
    result.oo2 := -1;
     if hit then
       begin
    fCPoint2.x:=fCPoint.x+RenDir.x*200;
    fCPoint2.y:=fCPoint.y+RenDir.y*200;
       end
  end;
  lsobj := obj;
  ObjHit(lSPnt, RenDir,-1,lsobj, rDist, rr);
  if lsobj >= 0 then
    result.shad := trunc(MaxHeight / (rDist + 1));;
end;

function Floor(op:TFloatPoint):TFloatPoint;overload;inline;

begin
  result:=FloatPoint(floor(op.x),floor(op.y));
end;

function TObstacles.ComputeVisibility(const fCPoint, fCView, lCV2: TFloatPoint;
  const lCV1: TFloatPoint): boolean;inline;
begin
  vp := pos + fCPoint + point(400,400);
  vp := (vp - floor(vp / 400) * 400) - point(200,200);
  Visible := (size <> 0) and (vp.x * fCView.x + vp.y * fCView.y < -size + 1);
  Visible := Visible and (vp.x * lcv1.x + vp.y * lcv1.y < +size + 1);
  Visible := Visible and (vp.x * lcv1.x + vp.y * lcv1.y > -200);
  Visible := Visible and (vp.x * lcv2.x + vp.y * lcv2.y < +size + 1);
  Result := Visible and (vp.x * lcv2.x + vp.y * lcv2.y > -200);
end;

{ TCylinder }

function TCylinder.Hittest(fCPoint, rendir: TFloatPoint; out rdistq, r: single): boolean;

var
  ld: Extended;
begin

  vp := pos + fCPoint + point(400,400);
  vp := (vp - floor(vp / 400) * 400) - point(200,200);

  r := vp.x * RenDir.y - vp.y * RenDir.x;
  ld := vp.x * RenDir.x + vp.y * RenDir.y;
  Result := (trunc(abs(r)) < size) and (ld<0);
  if Result then
    rDistq := sqrt(sqr(vp.y) + sqr(vp.x)) - sqrt(sqr(size) - sqr(r))
  else
    rdistq := 0;
end;

function TCylinder.Reflect(rendir: TFloatPoint; rr: single; out xx: single
  ): TFloatPoint;
var
  reflOm: float;
begin
  { Reflection-Omega (-pi .. pi)}
  if abs(rr)>size then
     reflOm:=Sign(rr)*pi
  else
    reflOm := ArcSin(rr / size) * 2;
  result.x := -RenDir.x * cos(reflOm) + RenDir.y * sin(reflOm);
  result.y := -RenDir.y * cos(reflOm) - RenDir.x * sin(reflOm);
  xx := -RenDir.x * cos(reflOm*0.5) + RenDir.y * sin(reflOm*0.5);
end;

{ TBox }

function TBox.Hittest(fCPoint, rendir: TFloatPoint; out rdistq, r: single
  ): boolean;

var
  ld,t1,t2: Extended;

  function sgn(x:Extended):extended;inline;
  begin
    if x>=0 then result :=1.0 else result :=-1.0;
  end;

begin

  vp := pos + fCPoint + point(400,400);
  vp := (vp - floor(vp / 400) * 400) - point(200,200);

  r := 0;
  if abs(rendir.x)>1e-30 then
    begin
      rDistq :=(-vp.x-size*sgn(rendir.x))/rendir.x;
      t1:= rendir.y*rDistq;
      result := (abs(t1+vp.y) < Size);
      if result then
        r:= 0.5;
    end ;
  if (not result) and (abs(rendir.y)>1e-30) then
    begin
      rDistq :=(-vp.y-size*sgn(rendir.y))/rendir.y;
      t1:= rendir.x*rdistq;
      result := (abs(t1+vp.x) < Size) ;
      r:= -0.5;
    end;

end;

function TBox.Reflect(rendir: TFloatPoint; rr: single; out xx: single
  ): TFloatPoint;
begin
  result := rendir;
  if rr>0 then
    begin
      result.x := -RenDir.x;
      xx:=-sign(RenDir.x);
    end
  else
    begin
      result.y := -RenDir.y;
      xx:=0.0;
    end;

end;


procedure TForm6.FormCreate(Sender: TObject);
var
  I, j: integer;
  c: integer;
  pp: TFloatPoint;
begin
  // initialize
  Label1.Caption:=Format('Compiled: %s'+lineending+'on: %s',[cdate,cname]);

  setlength(fObjects, 1600);
  setlength(fRendercache, PaintBox2.Width);
  fxx := PaintBox2.Width div 2;
  fTime:=3440;
  for I := 0 to high(fObjects) do
  begin
    case Random(2) of
     0: fObjects[i] := Tcylinder.Create;
    1: fObjects[i] := TBox.Create;
    end;
    with fObjects[I] do
    begin
      pos := point((I div 40) * 10 + Random(16),
       (I mod 40) * 10 + Random(16));
      size := Random(4) + 3 ;
      c := (pos.x xor pos.y) mod 50;
      color := rgb(100 + c*3, 250 -abs(25-c)*3, 250 - c*3);
    end;
  end;
  fCPoint := PathFunction(0);

  fRendermap := tBitmap.Create;
  fRendermap.Height := PaintBox2.Height;
  fRendermap.Width := PaintBox2.Width;
  for I := 0 to 2000 do
  begin
    pp := PathFunction(I * pi / 500);
    for j := 0 to High(fObjects) do
      with fObjects[j] do
      begin
        vp := pos + pp + point(400,400);
        vp := vp - floor(vp / 400) * 400 - point(200,200);
        if abs(vp.x) + abs(vp.y) < 5 + size * 2 then
          size := 0;
      end;
  end;

  for j := 0 to High(fObjects) do
    if fObjects[j].size > 0 then
      with fObjects[j] do
      begin
        AppendIndex(pos, j);
        AppendIndex(Classes.point((pos.x + size) mod 400, (pos.y + size) mod 400), j);
        AppendIndex(Classes.point( pos.x , (pos.y + size) mod 400), j);
        AppendIndex(Classes.point((pos.x - size + 400) mod 400, (pos.y + size) mod 400), j);
        AppendIndex(Classes.point((pos.x - size + 400) mod 400, pos.y ), j);
        AppendIndex(Classes.point((pos.x - size + 400) mod 400, (pos.y - size + 400) mod 400), j);
        AppendIndex(Classes.point( pos.x , (pos.y - size + 400) mod 400), j);
        AppendIndex(Classes.point((pos.x + size) mod 400, (pos.y - size + 400) mod 400), j);
        AppendIndex(Classes.point((pos.x + size) mod 400, pos.y ), j);
      end;

end;

procedure TForm6.PaintBox1Paint(Sender: TObject);
var
  I: integer;
begin
  if not chbShowObjects.Checked then
    exit;
  with PaintBox1.Canvas do
    try
      Lock;
      // clear
      Brush.color := clBtnFace;
      FillRect(ClipRect);
      // background
      // objects
      for I := 0 to high(fObjects) do
        if (fObjects[i].size > 0) and fObjects[I].Visible then
        begin
          if not fObjects[I].Visible then
            Brush.color := cllime
          else if not fObjects[I].hit then
            Brush.color := DecColor(fObjects[I].color, 128)
          else if i = FActiveObj1 then
            Brush.color := clred
          else if i = FActiveObj2 then
            Brush.color := clYellow
          else
            Brush.color := fObjects[I].color;
          FillRect(Classes.Rect(fObjects[I].pos.x - fObjects[I].size, fObjects[I].pos.y -
            fObjects[I].size, fObjects[I].pos.x + fObjects[I].size, fObjects[I].pos.y +
            fObjects[I].size));
        end;
      // path
      pen.color := clblue;
      moveto(trunc(600 - fCPoint.x) mod 400, trunc(600 - fCPoint.y) mod 400);
      lineto(trunc(PenPos.x - fCMove.x * 20), trunc(penpos.y - fCMove.y * 20));
      // camera
      pen.color := clLime;
      moveto(trunc(600 - fCPoint.x) mod 400, trunc(600 - fCPoint.y) mod 400);
      lineto(trunc(PenPos.x - fCView.x * 100), trunc(penpos.y - fCView.y * 100));
      // deb
      pen.color := clBlack;
      moveto(trunc(600 - fCPoint.x) mod 400, trunc(600 - fCPoint.y) mod 400);
      lineto(trunc(600 - fCPoint2.x) mod 400, trunc(600 - fCPoint2.y) mod 400);
      if FActiveObj1>0 then
        Lineto(trunc(600 - fCPoint3.x) mod 400, trunc(600 - fCPoint3.y) mod 400);

      // viewangle
    finally
      Unlock;
    end;
end;

procedure TForm6.PaintBox2Paint(Sender: TObject);
var
  I: integer;
  bd2: integer;
  c: integer;
begin
  with fRendermap.Canvas do
  begin
    // BackGround
    bd2 := ClipRect.bottom div 2;
    for I := 0 to bd2 do
    begin
      // Himmel
      c := 128 + (I * 127) div bd2;
      pen.color := rgb(c, c, 255);
      moveto(0, I);
      lineto(ClipRect.Right, I);

      // Erde
      c := 128 - (I * 127) div bd2;
      pen.color := rgb(c div 2, c, c div 2);
      moveto(0, ClipRect.bottom - I);
      lineto(ClipRect.Right, ClipRect.bottom - I);
    end;
    // render
    for I := 0 to high(fRendercache) do
    begin
      if  fRendercache[I].Height >  fRendercache[I].shad div 2 then
        begin
      pen.color := clBlack;
      moveto(I, bd2 + fRendercache[I].shad);
      lineto(I, bd2 + fRendercache[I].shad div 2);
        end;
      c := min(max(fRendercache[I].light,0),255);

      pen.color := DecColor(fRendercache[I].color, 255 - c);
      moveto(I, bd2 - fRendercache[I].Height);
      lineto(I, bd2 + fRendercache[I].Height);

      c := min(max(fRendercache[I].light2,0),255);
      pen.color := DecColor(fRendercache[I].color2, 255 - c);
      moveto(I, bd2 - fRendercache[I].Height2);
      lineto(I, bd2 + fRendercache[I].Height2);
    end;
  end;
  PaintBox2.Canvas.Draw(0, 0, fRendermap
{$IFNDEF FPC}
    , ScrollBar1.Position
{$ENDIF}
    );
end;

procedure TForm6.AppendIndex(pp: Tpoint; i: integer);
var

  jj: integer;
  xx: integer;
  yy: integer;
begin
  xx := pp.x div 10;
  yy := pp.y div 10;
  if xx > high(fObjIdx) then
    setlength(fObjIdx, xx + 1);
  if yy > high(fObjIdx[xx]) then
    setlength(fObjIdx[xx], yy + 1);
  for jj := 0 to high(fObjIdx[xx, yy]) do
    if fObjIdx[xx, yy, jj] = i then
      exit;
  setlength(fObjIdx[xx, yy], high(fObjIdx[xx, yy]) + 2);
  fObjIdx[xx, yy, high(fObjIdx[xx, yy])] := i;
end;

function TForm6.GetIndex(pp: tpoint): TidxArray;
var
  xx: integer;
  yy: integer;
begin
  xx := pp.x div 10;
  yy := pp.y div 10;
  if (xx < 0) or (xx > high(fObjIdx)) or (yy < 0) or (yy > high(fObjIdx[xx])) then
    Result := nil
  else
    Result := fObjIdx[xx, yy];

end;

function TForm6.PathFunction(Omega: extended): TFloatPoint;
begin
  Result.x := -cos(Omega) * 200;
  Result.y := (sin(Omega) * sin(-cos(omega) * pi * 0.5) * 5.5 + Omega) / pi / 2 * 200;
end;

procedure TForm6.Timer1Timer(Sender: TObject);
var
  I: integer;
  j: integer;
  Hrc2: integer;
  r: single;
  rDistq: single;
  Omega, s, c: extended;
  lCV1, lCV2: TFloatPoint;
  obj: integer;
  RenDir: TFloatPoint;
  ll: extended;
  lSPnt: TFloatPoint;

   MaxHeight: integer;


const
  Freq = 4.0;
  sqrt2 = 0.70710678118654752440084436210485;

begin
  if not chbPause.Checked then
    begin
      fTime := (fTime + 1) mod 6000;
      timer1.Interval:=20;
    end
  else
    timer1.Interval:=250;

  Omega := fTime * Freq * pi * 2 / 6000;

  fCMove := fCPoint;
  fCPoint := PathFunction(Omega);
  lCv1  := PathFunction(Omega+ScrollBar1.Position/1000);
  lCv2  := PathFunction(Omega+ScrollBar1.Position/1000+0.01);
  fCView.x := lcv2.x-lcv1.x;
  fCView.y := lcv2.y-lcv1.y;
  ll:= sqrt(sqr(fCView.x)+sqr(fCView.y));
  if ll >0 then
    begin
      fCView.x := fCView.x/ll;
      fCView.y := fCView.y/ll;
    end;

  lCv1.x := fCView.x * sqrt2 - fCView.y * sqrt2;
  lCv1.y := fCView.y * sqrt2 + fCView.x * sqrt2;
  lCv2.x := lCv1.y;
  lCv2.y := -lCv1.x;

  fCPoint.x := fCPoint.x - trunc(fCPoint.x / 400) * 400;
  fCPoint.y := fCPoint.y - trunc(fCPoint.y / 400) * 400;
  fCMove.x := (fCPoint.x - fCMove.x) * 1;
  fCMove.y := (fCPoint.y - fCMove.y) * 1;

  lSPnt := fCPoint;

  if chbStereo.Checked then
    begin
      fCPoint.x += fCView.y*0.4;
      fCPoint.y += -fCView.x*0.4;
    end
  else
    begin
      fCPoint.x += -fCView.y*0.4;
      fCPoint.y += fCView.x*0.4;
    end;

  lSPnt.x +=   fCView.x;
  lSPnt.y +=   fcView.y;

  PaintBox1.Invalidate;
  Hrc2 := high(fRendercache) div 4;
  MaxHeight := PaintBox2.height *4;
  obj := -1;
  for I := 0 to High(fObjects) do
    with fObjects[I] do
    begin
      Visible := False;
      hit := False;
    end;

  for j := 0 to high(fRendercache) div 2 do
  begin
    s := sin((Hrc2 - j) * 0.6 / Hrc2);
    c := cos((Hrc2 - j) * 0.6 / Hrc2);
    RenDir.x := fCView.x * c + fCView.y * s;
    RenDir.y := -fCView.x * s + fCView.y * c;
    fRendercache[j]:=Trace(MaxHeight, lSPnt, ll, obj, RenDir,fxx=j, rDistq, r);
  end;

  if chbStereo.Checked then
    begin
      fCPoint.x += -fCView.y*0.8;
      fCPoint.y += fCView.x*0.8;
    end
  else
    begin
      fCPoint.x += fCView.y*0.8;
      fCPoint.y += -fCView.x*0.8;
    end;

  for j := high(fRendercache) div 2+1 to high(fRendercache)  do
  begin
    s := sin(( -j+Hrc2*3) * 0.6 / Hrc2);
    c := cos(( -j+Hrc2*3) * 0.6 / Hrc2);
    RenDir.x := fCView.x * c + fCView.y * s;
    RenDir.y := -fCView.x * s + fCView.y * c;
    fRendercache[j]:=Trace(MaxHeight, lSPnt, ll, obj, RenDir,fxx=j, rDistq, r);
  end;
  FActiveObj1 := fRendercache[fxx].oo1;
  FActiveObj2 := fRendercache[fxx].oo2;
  PaintBox2Paint(self);

end;

procedure TForm6.PaintBox2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Fxx:= x;
end;

procedure TForm6.BitBtn2Click(Sender: TObject);
begin
  timer1.Enabled:=false;
  close;
end;

procedure TForm6.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to high(fObjects) do
    freeandnil(fObjects[i]);
    setlength(fObjects, 0);
  setlength(fRendercache, 0);

  freeandnil(fRendermap);

end;

procedure TForm6.FormResize(Sender: TObject);
begin
  setlength(fRendercache, PaintBox2.Width);
  fxx := PaintBox2.Width div 2;
  fRendermap.Height := PaintBox2.Height;
  fRendermap.Width := PaintBox2.Width;
end;

end.
