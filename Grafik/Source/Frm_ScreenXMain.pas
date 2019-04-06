unit Frm_ScreenXMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
    Windows,
{$ELSE}
    LCLIntf, LCLType,
{$ENDIF}
    SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, Fra_Graph, Spin, Unt_RenderTask;

type

    { TFrmScreenXMain }

    TFrmScreenXMain = class(TForm)
        btnExecute: TButton;
        CheckBox4: TCheckBox;
        CheckGroup1: TCheckGroup;
        FraGraph1: TFraGraph;
        LabeledEdit1: TLabeledEdit;
        LabeledEdit2: TLabeledEdit;
        LabeledEdit3: TLabeledEdit;
        ListBox1: TListBox;
        pnlLeft: TPanel;
        pnlLeftBottom4: TPanel;
        RadioGroup1: TRadioGroup;
        SpinEdit1: TSpinEdit;
        procedure ChbAppRemFktn(Sender: TObject);
        procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
        procedure FormCreate(Sender: TObject);
        procedure btnExecuteClick(Sender: TObject);
        procedure LabeledEdit3KeyPress(Sender: TObject; var Key: char);
        procedure LabeledEdit3Exit(Sender: TObject);
        procedure FraGraph1MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: integer);
    private
        FXoffs: extended;
        FYoffs: extended;
        FXWidth: extended;
        Fline: integer;
        FktArray: array of TDFunktion;
        CFktn: TCFunktion;
        FRenderTasks: array of TRenderThread;
        FBXoffs: extended;
        FBYoffs: extended;
        FRunmode, FRunning: boolean;
        FmaxRec: integer;
        procedure RenderSqare(rp:Tpoint;subSqare: integer; ZeroPnt:TExPoint;delt: extended;
           lInverse: boolean; var Resultarray: TResultArray; var bm: TBitmap);
        { Private-Deklarationen }
    public
        { Public-Deklarationen }
    end;

var
    FrmScreenXMain: TFrmScreenXMain;

implementation

uses graph, Math;

{$IFnDEF FPC}
  {$R *.dfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

var
    bmp: TPortableNetworkGraphic;

procedure TFrmScreenXMain.FormCreate(Sender: TObject);
begin
    FraGraph1.df := 4;
    Graph.iGraph := fraGraph1;
    setlength(FRenderTasks, 8);
    FXoffs := 0;
    FYoffs := 0;
    FXWidth := 32;

    bmp := TPortableNetworkGraphic.Create;
    bmp.LoadFromResourceName(HINSTANCE, 'LAZARUS_LG');

end;

procedure TFrmScreenXMain.ChbAppRemFktn(Sender: TObject);

begin

end;

procedure TFrmScreenXMain.CheckGroup1ItemClick(Sender: TObject; Index: integer);
var
    ix: integer;
begin
    if Sender.InheritsFrom(TCheckGroup) then
        with TCheckGroup(Sender).Controls[index] as TCheckBox do
          begin
            if Checked then
                ListBox1.Items.AddObject(Caption, TObject(ptrint(index)))
            else
              begin
                ix := ListBox1.Items.IndexOf(Caption);
                if ix >= 0 then
                    ListBox1.Items.Delete(ix);
              end;
          end;
end;

procedure TFrmScreenXMain.FraGraph1MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
    FXoffs := FBXoffs + (x / FraGraph1.Width - 0.5) * FXWidth;
    LabeledEdit1.Text := FloatToStr(FXoffs);
    FYoffs := FBYoffs + (y - FraGraph1.Height div 2) / FraGraph1.Width * FXWidth;
    LabeledEdit2.Text := FloatToStr(FYoffs);
end;

function ExPoint(x, y: extended): Texpoint;
    inline;
begin
    Result.x := x;
    Result.y := y;
end;

procedure TFrmScreenXMain.RenderSqare(rp: Tpoint; subSqare: integer;
  ZeroPnt: TExPoint; delt: extended; lInverse: boolean;
  var Resultarray: TResultArray; var bm: TBitmap);
var
  LBrake: boolean;
  vx: extended;
  p0: TExPoint;
  p1: TExPoint;
  y: integer;
  x: integer;
  k: integer;
begin
  for x := 0 to subSqare-1 do
                      begin
                        vx := (rp.x*subSqare+x)*delt-ZeroPnt.x ;
                      for y := 0 to subSqare-1 do
                         begin
                    p0 := ExPoint(vx, (rp.y*subSqare+y) * delt - ZeroPnt.y);
                    P1 := p0;
                    LBrake:=false;
                    for k := 0 to high(FktArray) do
                        p1 := FktArray[k](p1, p0, LBrake);

                    if not lInverse then
                        bm.Canvas.Pixels[x, y]:= CFktn(p1)
                    else
                      with Resultarray[x*subSqare+y] do
                       begin
                         p.X:= (p1.x + ZeroPnt.x) / delt;
                         p.y:= (p1.y + ZeroPnt.y) / delt;
                         col := CFktn(p0)
                       end
                       end
                     end;
end;

procedure TFrmScreenXMain.LabeledEdit3Exit(Sender: TObject);
var
    LF: extended;
begin
    if Sender.InheritsFrom(TLabeledEdit) then
        if TryStrToFloat(TLabeledEdit(Sender).Text, LF) then
            if Sender = LabeledEdit1 then
                FXoffs := LF
            else if Sender = LabeledEdit2 then
                FYoffs := LF
            else if Sender = LabeledEdit3 then
                FXWidth := LF;
end;

procedure TFrmScreenXMain.LabeledEdit3KeyPress(Sender: TObject; var Key: char);
begin
    if key = #13 then
      begin
        LabeledEdit3Exit(Sender);
        key := #0;
      end
    else
      begin
        if not (key in ['0'..'9', ',', '-', 'e', #8, #9]) then
          begin
            key := #0;
            beep;
          end;
      end;
end;

function PQLength(p: TExPoint): extended;
    inline;
begin
    Result := sqr(p.x) + sqr(p.y);
end;

function PLength(p: TExPoint): extended;
    inline;
begin
    Result := sqrt(PQLength(p));
end;

function arcsin_xp(p: TExpoint): extended;
    Inline;

    //Var wi, s, c, d: extended;

begin
    if p.x > 0 then
        Result := ArcTan(p.y / p.x)
    else if p.x < 0 then
        if p.y >= 0 then
            Result := ArcTan(p.y / p.x) + pi
        else
            Result := ArcTan(p.y / p.x) - pi
    else if p.y > 0 then
        Result := 0.5 * pi
    else if p.y < 0 then
        Result := -0.5 * pi
    else
        Result := 0;
end;

function ExMod(const w,m: Extended): Extended; inline;

begin
  Result := frac(w / m) * m;
end;


function farbm(p: TExPoint): Tcolor;

var
    m, n: extended;

const
    farbtab: array[0..4] of integer = (yellow, red, cllime, blue, white);

begin
    m := exmod(p.x , 4);
    n := ExMod(p.y , 4);
    if m < 0 then
        m := 1 - m;
    if n < 0 then
        n := 1 - n;
    if m >= 3 then
        m := 5 - m;
    if n >= 3 then
        n := 5 - n;
    farbm := farbtab[trunc(int(n) + int(m))];
end;

function farbm2(p: TExPoint): Tcolor;

var
   m, n, k: extended;

begin
    n:=ExMod(p.y, 4.0);
    m := ExMod(p.x + p.y * 0.5, 4.0);
    k := ExMod(p.x - p.y * 0.5, 4.0);
    if m < 0 then
        m := -m;
    if n < 0 then
        n := -n;
    if k < 0 then
        k := -k;
    if m >= 2 then
        m := 4 - m;
    if n >= 2 then
        n := 4 - n;
    if k >= 2 then
        k := 4 - k;
    assert (n>0);
    assert (m>0);
    assert (k>0);
    assert (n<2.0);
    assert (m<2.0);
    assert (k<2.0);
    Result := rgb(trunc(1.0+n * 127), trunc(0.5+m * 127), trunc(0.5+k * 127));
end;



function farbm3(p: TExPoint): Tcolor;

Var xm, ym: extended;


begin
    if not assigned(bmp) then
      begin
        bmp := TPortableNetworkGraphic.Create;
        bmp.LoadFromResourceName(HINSTANCE, 'LAZARUS_LG');
      end;
    xm :=ExMod(p.x / 4,1 );
    if xm <0 then xm := 1.0+xm;
    ym :=exmod(p.y / 4 ,1);
    if ym < 0 then ym := 1.0 +ym;
    Result := bmp.Canvas.Pixels[trunc(xm * bmp.Width),
        trunc(ym * bmp.Height)];
end;

function farbm4(p: TExPoint): Tcolor;
    inline;

var
    m: extended;
    H, c, b: extended;

begin
    M := arcsin_xp(p);
    H := 511 / (1 + PLength(p));
    if h > 256 then
      begin
        C := 256 - H * 0.5;
        B := 255 - C;

        Result := rgb(trunc((b + cos(m) * c)), trunc(
            (b + cos(m + pi * 0.6666666) * c)), trunc((b + cos(m + pi * 1.33333333) * c)));
      end
    else
        Result := rgb(trunc((0.5 + cos(m) * 0.5) * H), trunc(
            (0.5 + cos(m + pi * 0.6666666) * 0.5) * H), trunc(
            (0.5 + cos(m + pi * 1.33333333) * 0.5) * H));
end;

function NullFktn(p, p0: TExPoint; var PBrake: boolean): TExPoint;

begin
    Result := p;
end;

function strflucht(p, p0: TExPoint; var PBrake: boolean): TExPoint;

begin
    if p.y = 0 then
      begin
        Result := ExPoint(0, 0);
        exit;
      end;
    if p.y > 0 then
        Result := expoint(p.x * 4 / p.y, 12 - (32 / p.y))
    else
        Result := expoint(p.x * 4 / p.y, -12 - (32 / p.y));
end;

function ballon(p, p0: TExPoint; var PBrake: boolean): TExPoint;
var
    Lforce: extended;

begin
    if (p.x = 0) and (p.y = 0) then
      begin
        Result := ExPoint(0, 0);
        exit;
      end;
    Lforce := (1 - 0.3 / ((PQLength(p)) / 100 + 0.3));
    Result := ExPoint(p.x * LForce, p.y * Lforce);
end;

function sauger(p, p0: TExPoint; var PBrake: boolean): TExPoint;

var
    force: extended;
begin
    if (p.x = 0) and (p.y = 0) then
      begin
        Result := ExPoint(0, 0);
        exit;
      end;
    force := (1 + 0.3 / ((PQLength(p)) / 100 + 0.1));
    Result := ExPoint(p.x * force, p.y * force);
end;

function Tunnel(p, p0: TExPoint; var PBrake: boolean): TExPoint;

var
    x, y: extended;

begin
    y := PLength(p);
    if y = 0 then
      begin
        Result := ExPoint(0, 0);
        exit;
      end;
    x := arcsin_xp(p) / pi;
    if y > 0 then
        Result := expoint(x * 16, 10 - 32 / y)
    else
        Result := expoint(x * 16, 0);
end;

function schnecke2(p, p0: TExPoint; var PBrake: boolean): TExPoint;

var
    x, y: extended;

begin
    y := PLength(p);
    if y = 0 then
      begin
        Result := ExPoint(0, 0);
        exit;
      end;
    x := arcsin_xp(expoint(p.x, p.y));
    Result := expoint(x * 32 / pi, y + (x * 4 / pi) - 6);
end;

function strudel(p, p0: TExPoint; var PBrake: boolean): TExPoint;

var
    x, y: extended;

begin
    y := PLength(p);
    if y = 0 then
      begin
        Result := ExPoint(0, 0);
        exit;
      end;
    x := arcsin_xp(p);
    Result := ExPoint(sin(x + pi - pi * sqr((y - 1) / y)) * y,
        cos(x + pi - pi * sqr((y - 1) / y)) * y);
end;

function strudel2(p, p0: TExPoint; var PBrake: boolean): TExPoint;

var
    y, r: extended;

const
    rm = 12;
begin
    r := PLength(p);
    if abs(r) < rm then
        Y := (1 + cos(r * pi / rm)) * pi * 0.25
    else
        Y := 0;
    if r = 0 then
      begin
        Result.x := 0;
        Result.y := 0;
        exit;
      end;
    //  x := arcsin(xa, ya, y);
    Result.y := cos(y) * p.y - sin(y) * p.x;
    Result.x := sin(y) * p.y + cos(y) * p.x;
end;

procedure Wobble(var xe, ye, xa, ya: extended);

//Var x, y: extended;

begin
    ye := Ya + cos(XA * pi / 3) * 1.6;
    xe := Xa + sin(Ya * pi / 3) * 1.6;
end;

function Wobble2(p, p0: TExPoint; var PBrake: boolean): TExPoint;

var
    y: extended;

begin
    y := PLength(p);
    Result.y := p.Y + cos(p.X * pi / 3) * 0.2 * y;
    Result.x := p.X + sin(p.Y * pi / 3) * 0.2 * y;
end;

function Wobble3(P, p0: TExPoint; var PBrake: boolean): TExPoint;

var
    x, r: extended;

const
    rm = 12;
begin
    r := PLength(p);
    if abs(r) < rm then
        x := (1 + cos(r * pi / rm)) * 10
    else
        x := 0;
    Result := ExPoint(p.x + sin(p.y * pi / 3) * 0.2 * x, p.y +
        cos(p.x * pi / 3) * 0.2 * x);
end;

function Juliastep(P, p0: TExPoint; var PBrake: boolean): TExPoint;
    inline;

begin
    if (sqr(p.x * p.y)) > 8000 then
        Result := p
    else
        Result := ExPoint(sqr(p.x * 0.2 - 0.7) * 5 - sqr(p.y * 0.2 + 0.3) *
            5, (p.y * 0.2 + 0.3) * (p.x * 0.2 - 0.7));
end;

function Mandelbrstep(P, p0: TExPoint; var PBrake: boolean): TExPoint;
    inline;

var

    lsqx: extended;
    lsqy: extended;

const
    fakt = 0.1;
    mfakt = 1 / fakt;

begin
    lsqx := sqr(p.x);
    lsqy := sqr(p.y);
    if (lsqx + 3 * p.x + lsqy > 6 * mfakt * mfakt) then
      begin
        Result := p;
        PBrake := True;
      end
    else
        Result := ExPoint((lsqx - lsqy) * fakt + p0.x, 2 * p.y * p.x * fakt + p0.y);
end;

function MandelbrstepN(P, p0: TExPoint; var PBrake: boolean): TExPoint;
    inline;

var
    k: integer;
begin
    k := 1;
    Result := p;
    while (k < FrmScreenXMain.FmaxRec) and (not PBrake) do
      begin
        Result := Mandelbrstep(Result, p0, PBrake);
        Inc(k);
      end;
end;

function Mandelbrfull(P, p0: TExPoint; var PBrake: boolean): TExPoint;
    //Inline;

var

    lsqx: extended;
    lsqy, dlc: extended;
    Lc: integer;
    p1: TExPoint;

const
    fakt = 0.1;
    mfakt = 1 / fakt;

begin
    Lc := 0;
    lsqx := 0;
    Lsqy := 0;
    p1 := expoint(0, 0);
    while (lsqx + 3 * p1.x + lsqy < 6 * mfakt * mfakt) and (Lc < FrmScreenXMain.FmaxRec) do
      begin
        p1 := ExPoint((lsqx - lsqy) * fakt + p0.x, 2 * p1.y * p1.x * fakt + p0.y);
        lsqx := sqr(p1.x);
        lsqy := sqr(p1.y);
        Inc(lc);
      end;

    if Lc < FrmScreenXMain.FmaxRec then
      begin
        dlc := 1 / FrmScreenXMain.FmaxRec;
        Result := expoint(sin(lc * 0.1) * (FrmScreenXMain.FmaxRec - lc) * dlc, cos(lc * 0.1) *
            (FrmScreenXMain.FmaxRec - lc) * dlc);
      end
    else
        Result := p1;
end;



function Rotat(p: TExPoint; r: extended): TExPoint;
    inline;

begin
    Result := expoint(sin(r) * p.y + cos(r) * p.x, -sin(r) * p.x + cos(r) * p.y);
end;

function Kugel(p, p0: TExPoint; var PBrake: boolean): TExPoint;

var
    r, zm, z: extended;
    p2, p3: Texpoint;

const
    Kipp = -30;
    Dreh = -40;
    DegrPart = 0.0055555555555555555555555555555556;
    rm = 12;

begin

    r := PLength(p);
    if True then
        if abs(r) > rm then
            Result := p
        else
          begin
            p := rotat(p, pi * kipp * degrpart);
            zm := sqrt(sqr(rm) - sqr(p.y));
            if abs(zm) >= abs(p.x) then
                z := sqrt(sqr(zm) - sqr(p.x))
            else
                z := 0;
            p2 := rotat(expoint(p.y, z), pi * dreh * degrpart);
            p3 := expoint(arcsin_xp(expoint(p.x, p2.y)),
                arcsin_xp(expoint(p2.x, sqrt(sqr(p2.y) + sqr(p.x)))));
            Result := expoint(10 - 4 * p3.x / pi * int(rm * 0.5), p3.x /
                pi * 4 - 4 * p3.y / pi * int(rm * 0.5) + 12);

          end;
end;

const
    Menu: array[0..21] of string =
        ('S', 'Strudel',
        'B', 'Ballon',
        'N', 'schNecke',
        'M', 'Schnecke V2',
        'A', 'Sauger',
        'F', 'StassenFlucht',
        'W', 'Wobble',
        'K', 'Kugel',
        '1', 'FarbMuster 1',
        '2', 'FarbMuster 2',
        '3', 'Bitmap');

procedure TFrmScreenXMain.btnExecuteClick(Sender: TObject);

var
    grk, grm: integer;
    i, j, subSqare, ii, xMax, iMax, XX: integer;
    delt, x0, y0: extended;
    lInverse: boolean;
    LLastTick: cardinal;
    Lakttick: cardinal;
    bm: TBitmap;
    Resultarray:array of TResultRec;
    lResRec: TResultRec;
    rp: TPoint;

begin
    if FRunmode or FRunning then
      begin
        Frunmode := False;
        exit;
      end;
    //Menue
    FRunmode := True;
    FRunning := True;
    bm:=nil;
      try

        initgraph(grk, grm, bgipath);
        FmaxRec := SpinEdit1.Value;
        delt := FXWidth / getmaxx;
        LLastTick := GetTickCount;

        setlength(FktArray, ListBox1.Items.Count);
        for I := 0 to ListBox1.Items.Count do
            case ptrint(ListBox1.Items.Objects[I]) of
                0: FktArray[i] := NullFktn;
                1: FktArray[i] := Wobble3;
                2: FktArray[i] := strudel2;
                3: FktArray[i] := ballon;
                4: FktArray[i] := sauger;
                5: FktArray[i] := schnecke2;
                6: FktArray[i] := strflucht;
                7: FktArray[i] := kugel;
                8: FktArray[i] := Tunnel;
                9: FktArray[i] := Mandelbrstepn;
                10: FktArray[i] := Mandelbrfull;
              end;
        //  FLine := 0;
        //  For I := 0 To high(FRenderTasks) Do
        //    Begin
        //      FRenderTasks[i] := TRenderThread.create(false, I);
        //      setlength(FRenderTasks[i].source, getmaxx + 1);
        //      Case RadioGroup1.ItemIndex Of
        //        0: FRenderTasks[i].cfkt := farbm;
        //        1: FRenderTasks[i].cfkt := farbm2;
        //        2: FRenderTasks[i].cfkt := farbm3;
        //        3: FRenderTasks[i].cfkt := farbm4
        //        Else
        //          FRenderTasks[i].cfkt := farbm;
        //      End

        //    End;
        FBXoffs := FXoffs;
        fbyoffs := FYoffs;
        x0 := getmaxx * delt * 0.5 - fxoffs;
        y0 := getmaxy * delt * 0.5 - fyoffs;
        case RadioGroup1.ItemIndex of
            0: CFktn := farbm;
            1: CFktn := farbm2;
            2: CFktn := farbm3;
            3: CFktn := farbm4
            else
                CFktn := farbm;
          end;

        subSqare := 256;
        lInverse:=checkbox4.Checked;
         if not lInverse then
           begin
        bm:=TBitmap.Create;
        bm.Width:=subSqare;
        bm.Height:=subSqare;
        bm.PixelFormat:=pf32bit;
           end
        else
        setlength(Resultarray,subSqare*subSqare);
        try
        xMax := (getmaxx div subSqare)+1;
        iMax := (getmaxy div subSqare +1) * xMax;
        XX := (iMax-1) and $5555;
        for ii := 0 to (iMax-1) do
               begin

                 i := ((ii * 17 mod iMax) ) xor XX ;
                 rp := point(i mod xMax,i div xMax );
                 // wait for free Rendertask

                  try
                   // Render the Sqare
                    RenderSqare(rp,subSqare,expoint(x0,y0),delt, lInverse,Resultarray, bm);

                   // Result Verarbeiten
                    if lInverse then
                      for lResRec in Resultarray do
                        fragraph1.putpixela(lResRec.p.x,lResRec.p.y,lResRec.col)
                     else
                       PutImage(point(rp.x*subSqare,rp.y*subSqare),bm,cmSrcCopy);

                    // Screenupdate
                    Lakttick := GetTickCount;
                    if Lakttick - LLastTick > 500 then
                      begin
                        LLastTick := Lakttick;
                        FraGraph1.Aktualisieren1Click(Sender);
                        Application.ProcessMessages;
                        if not Frunmode then
                            exit;
                      end;

                  except
                  end;
               end;

        finally
        freeandnil(bm);
         setlength(Resultarray,0);
        end;

      finally
        FRunmode := False;
        FRunning := False;
      end;
    //        if graph.keypressed then exit;
end;

end.


