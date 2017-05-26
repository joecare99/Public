Unit frm_clock_2;
{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
Interface

Uses
  {$IFNDEF FPC} Windows, Messages,  {$ELSE}  LMessages, {$ENDIF}SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, math, DateUtils, Buttons{$IFDEF FPC}   ,LCLType{$ENDIF};

Type
  TExtPoint = Record
    x, y: extended;
  End;
  TZeigerData = Record
    p1, p2,
      n: Textpoint;
    width, length: integer;
  End;
  TFrmClock = Class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    Image2: TImage;
    Button1: TBitBtn;
    Procedure FormCreate(Sender: TObject);
    Procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    Procedure FormActivate(Sender: TObject);
    Procedure FormMouseEnter(Sender: TObject);
    Procedure FormMouseLeave(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure Timer1Timer(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FShape,
    FMasterShape : TBitmap;
    FPreCalc:TBitmap;
    Zeiger: Array[0..2] Of TZeigerdata;
    Tmr: Integer;
    Finitialized: Boolean;
    {$IFNDEF FPC}
    Procedure WMNCHitTest(Var M: TWMNCHitTest); message wm_NCHitTest;
    {$ELSE}
    Procedure WMNCHitTest(Var M: TLMNCHITTEST); message LM_NCHITTEST;
    {$ENDIF}
    procedure PaintWindow(DC: HDC); override;
    Procedure PutColorPixel(x, y: Integer; Light: Extended; cv: TCanvas;
      BaseColor: TColor);
    Procedure RenderLightofScheibe(nv: TExtPoint; Var hh: Extended; bg: Integer;
      I: Integer);
    Procedure VNormalize(dd: Extended; Var n: TExtPoint; nv: TExtPoint);
    { Private-Deklarationen }
  protected
    Procedure CreateParams(Var Params: TCreateParams); override;
  public
    { Public-Deklarationen }
  End;

Var
  FrmClock: TFrmClock;
  frmClock2: TFrmClock;

Implementation

{$IFDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.dfm}
{$ENDIF}

Procedure TFrmClock.Button1Click(Sender: TObject);
Begin
  close;
End;

Procedure TFrmClock.FormActivate(Sender: TObject);
Var
  x, y, mx, my: integer;
  dd, dd2, h: extended;
  kv, nn, n: TExtPoint;
  C: Tcolor;
  flag: Boolean;
Begin
  {$IFNDEF FPC}
  showWindow(Self.Handle, sw_hide);
  {$ENDIF}
  if Finitialized  then
    exit
  else
    Finitialized := true;
  if self<>frmClock2 then
    begin
  frmClock2.Top:=  3;
  frmClock2.Left := Screen.Width - width +3;
  frmClock2.Visible := false;
    end;
 // self.Activate;
  FMasterShape.Height:=image1.height ;
  FMasterShape.Width := image1.width;
  FPreCalc.Height:=image1.height ;
  FPreCalc.Width := image1.width;

  top := 0;
  left := Screen.Width - width;
  mx := image1.width Div 2;
  mY := image1.height Div 2;
  For Y := 0 To image1.Height - 1 Do
    For X := 0 To image1.width - 1 Do
      Begin
        flag := true;
        // Rand
        kv.x := mx - x;
        kv.y := mY - y;
        dd := sqrt(sqr(kv.y) + sqr(kv.x));
        VNormalize(dd, n, kv);
        If (dd < mx) And (dd > mx - 20) Then
          Begin
            C := clLime; //Stanadardcolor
            If (dd < mx) And (dd >= mx - 1) Then
              c := round(196 - (mx - dd) * 196) * $10101;
            If (dd <= mx - 19) And (dd >= mx - 20) Then
              c := round(((mx - 19) - dd) * 196) * $10101;
            If (dd < mx - 1) And (dd >= mx - 19) Then
              Begin
                dd2 := (mx - dd - 10) / 9;

                dd2 := dd2 * dd2 * dd2;

                nn.x := (n.x * dd2) + (random * 0.1 - 0.05);
                nn.y := (n.y * dd2) + (random * 0.1 - 0.05);

                h := 1 - sqrt(sqr(nn.x + 0.1) + sqr((nn.y) + 0.25));
                If sqrt(sqr((nn.x) + 0.2) + sqr((nn.y) + 0.4)) < 0.1 Then
                  h := 2;


                PutColorPixel(x, y, h, image2.canvas, $100);
              End
            Else
              begin
                image2.Canvas.pixels[x, y] := c;

              end;
            flag := false;
          End;
        // Ziffernblatt

        // Background
        If flag Then
          begin
            image2.Canvas.pixels[x, y] := clFuchsia;
            FMasterShape.Canvas.Pixels[x,y] := clBlack;
          end
        else
        FMasterShape.Canvas.Pixels[x,y] := clWhite;
      End;

End;

Procedure TFrmClock.FormCreate(Sender: TObject);
Var
  h: THandle;
Begin
  {$IFNDEF FPC}
  h := CreateEllipticRgn(7, 6, 177, 175);
  SetWindowRgn(Handle, h, TRUE);
  {$else}
  FMasterShape:= TBitmap.Create;
  FPreCalc:=TBitmap.create;
  FShape:= TBitmap.create;
  {$endif}
  if assigned(Owner) and not Owner.InheritsFrom(TFrmClock) then
    begin
      frmClock2:= TFrmClock.Create(self);
      frmClock2.OnActivate :=nil;
      frmClock2.OnMouseEnter := nil;
      frmClock2.OnMouseLeave:= nil;
      frmClock2.OnMouseMove:= nil;
      frmClock2.Timer1.Enabled:= false;
      frmClock2.Button1.Visible := false;
      frmClock2.Show;
    end;
End;

Procedure TFrmClock.FormMouseEnter(Sender: TObject);
Begin
  Button1.Visible := true;
  AlphaBlendValue := 255;
  Tmr := 10;
End;

Procedure TFrmClock.FormMouseLeave(Sender: TObject);
Begin
  Button1.Visible := true;
End;

procedure TFrmClock.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if shift <> [] then
    frmClock2.Position := FrmClock.Position;
end;

procedure TFrmClock.FormPaint(Sender: TObject);
begin
  if self = FrmClock then
    begin
      frmClock2.Top:=  top +3;
      frmClock2.Left :=  left +3;
    end;
end;

procedure TFrmClock.FormResize(Sender: TObject);
begin
   if self = FrmClock then
    begin
      frmClock2.Top:=  top +3;
      frmClock2.Left :=  left +3;
    end;
end;

Procedure TFrmClock.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Begin
  Tmr := 10;
  Button1.Visible := true;
  AlphaBlendValue := 255;
End;

Procedure TFrmClock.Timer1Timer(Sender: TObject);
Var
  nn: TDateTime;
  mx, my, I, c: integer;
  r, s1, s2, dd, hh: extended;
  kt, nv: TExtPoint;
  Y, x: integer;
  bg: integer;
  BaseColor: TColor;
  cv: Tcanvas;
  h: THandle;

Begin
  NN := now();
  If tmr > 0 Then
    Begin
      dec(tmr);
      Button1.Visible := true;
      AlphaBlendValue := 128 + tmr * 12;
      frmClock2.AlphaBlendValue:= AlphaBlendValue div 2;
    End
  Else
    begin
    Button1.Visible := false;
          image1.top:=2;
      image1.left:=8;
   {$IFNDEF FPC}
   h := CreateEllipticRgn(7, 6, 177, 175);
  SetWindowRgn(Handle, h, TRUE);
   {$ENDIF}

    end;
  mx := image1.clientwidth Div 2;
  my := image1.clientHeight Div 2;
{$IFDEF FPC}
    FShape.Width := width;
    FShape.Height := height;
{$ENDIF}
  cv := FPreCalc.Canvas;
{$IFDEF FPC}
    cv.LockCanvas;
{$ENDIF}
 With cv Do
    Begin
      // Clear Dials
      Draw(0, 0, image2.Picture.Bitmap);
{$IFDEF FPC}
      Fshape.canvas.Draw(image1.left,image1.top,FMasterShape);
{$ENDIF}    //  Shape.TransparentColor := clFuchsia;
    End;
  // Calc new Dials
  For I := 0 To high(zeiger) Do
    Begin
      Case i Of
        0:
          Begin
            r := hourof(NN) / 12 + Minuteof(NN) / 720;
            s1 := 0.3;
            s2 := 0.05;
            zeiger[i].length := round((s1 + s2) * mx);
            zeiger[i].width := 13;
          End;
        1:
          Begin
            r := Minuteof(NN) / 60 + Secondof(NN) / 3600;
            s1 := 0.5;
            s2 := 0.1;
            zeiger[i].length := round((s1 + s2) * mx);
            zeiger[i].width := 9;
          End;
        2:
          Begin
            r := Secondof(NN) / 60 + MilliSecondOf(NN) / 60000;
            //    r := r - sin(r * 120 * pi) / 320;
            s1 := 0.78;
            s2 := 0.15;
            zeiger[i].length := round((s1 + s2) * mx);
            zeiger[i].width := 7;
          End;
      End;
      zeiger[i].n.X := sin(r * 2 * pi);
      zeiger[i].n.Y := -cos(r * 2 * pi);
      zeiger[i].p1.x := mx + zeiger[i].n.X * (mx * s1);
      zeiger[i].p1.Y := my + zeiger[i].n.Y * (mx * s1);
      zeiger[i].P2.X := mx - zeiger[i].n.X * (mx * s2);
      zeiger[i].p2.Y := my - zeiger[i].n.Y * (mx * s2);
    End;

  // Draw Dials
  For I := 0 To high(zeiger) Do
    Begin
      For Y := round(min(zeiger[i].p1.Y, zeiger[i].p2.y) - zeiger[i].width - 1)
        To round(max(zeiger[i].p1.Y, zeiger[i].p2.y) + zeiger[i].width + 1) Do
        For X := round(min(zeiger[i].p1.x, zeiger[i].p2.X) - zeiger[i].width - 1)
          To round(max(zeiger[i].p1.x, zeiger[i].p2.x) + zeiger[i].width + 1) Do
          Begin
            c := cv.pixels[x, y];
            //            If ((c And 255) = 0) And ((c And $FF00) <> 0) Then
            //            Else
            Begin
              If c = clfuchsia Then
                bg := 196
              Else
                bg := ((c And 255) + (c And $FF00) Div 256) Div 2;
              // Koordinatentransformation;
              kt.y := (x - zeiger[i].p1.x) * zeiger[i].n.y - (y - zeiger[i].p1.y)
                * zeiger[i].n.x;
              kt.x := -(x - zeiger[i].p1.x) * zeiger[i].n.x - (y -
                zeiger[i].p1.y) * zeiger[i].n.y;
              hh := -1.1;
              If {false and}(kt.x > 0) And (kt.x < zeiger[i].length) Then
                Begin
                  // Linearteil des zeigers
                  If (abs(kt.y) <= zeiger[i].width Div 2) Then
                    Begin
                      dd := kt.y * 2 / zeiger[i].width;
                      dd := dd * dd * dd;

                      nv.x := (zeiger[i].n.y * dd) + (random * 0.1 - 0.05);
                      nv.y := (-zeiger[i].n.x * dd) + (random * 0.1 - 0.05);

                      hh := 0.5 * (1 - sqrt(sqr(nv.x + 0.1) + sqr((nv.y) +
                        0.25)));
                      If sqrt(sqr((nv.x) + 0.2) + sqr((nv.y) + 0.4)) < 0.1 Then
                        hh := 2;

                      If (abs(kt.y) > (zeiger[i].width Div 2) - 1) Then
                        Begin
                          // antiailaising
                          dd := (zeiger[i].width Div 2 - abs(kt.y));
                          hh := (1 - dd) * (bg / 256) + (dd * hh);
                        End;

                    End;

                  PutColorPixel(x, Y, hh, cv, $10101);
{$IFDEF FPC}

                  if hh> -1 then
                    Fshape.canvas.Pixels[image1.left+x,image1.top+y]:=clWhite;
{$endif}
                End
              Else If (kt.x >= -zeiger[i].width) And (kt.x <= zeiger[i].width)
                Then
                Begin
                  // Endstück um p1
                  nv.x := x - zeiger[i].p1.x;
                  nv.y := y - zeiger[i].p1.y;
                  RenderLightofScheibe(nv, hh, bg, I);

                  PutColorPixel(x, Y, hh, cv, $10101);
{$IFDEF FPC}
                   if hh> -1 then
                  Fshape.canvas.Pixels[image1.left+x,image1.top+y]:=clWhite;
{$endif}
                End
              Else If kt.x < (zeiger[i].width + zeiger[i].length) Then
                Begin
                  // Endstück um p2
                  nv.x := x - zeiger[i].p2.x;
                  nv.y := y - zeiger[i].p2.y;

                  RenderLightofScheibe(nv, hh, bg, I);

                  PutColorPixel(x, Y, hh, cv, $10101);
{$IFDEF FPC}
                   if hh> -1 then
                  Fshape.canvas.Pixels[image1.left+x,image1.top+y]:=clWhite;
{$endif}
                End;
            End;
          End;
    End;
{$IFDEF FPC}
  cv.UnlockCanvas;
  //   if windowstate = wsMinimized then
  //     Application.Icon:=
  Image1.Canvas.Draw(0,0,FPreCalc);
  SetShape(Fshape);
{ $endIF}
  //  frmClock2.SetShape(shape);
{$endif}
//        frmClock2.Top:=  top +3;
//      frmClock2.Left :=  left +3;

End;

procedure TFrmClock.PaintWindow(DC: HDC);
begin
  inherited;
   if self = FrmClock then
    begin
      frmClock2.Top:=  top +3;
      frmClock2.Left :=  left +3;
    end;
end;

Procedure TFrmClock.PutColorPixel(x: Integer; Y: Integer; Light: Extended; cv:
  TCanvas; BaseColor: TColor);
Var
  c: Integer;
Begin
  If Light > 1 Then
    c := clwhite
  Else
    c := trunc(max(Light, 0) * 255) * Basecolor;
  If Light > -1 Then
    cv.pixels[x, y] := c;
End;

Procedure TFrmClock.RenderLightofScheibe(nv: TExtPoint; Var hh: Extended; bg:
  Integer; I: Integer);
Var
  ll: Extended;
  dd: Extended;
  n: TExtPoint;

Begin
  dd := sqrt(sqr(nv.y) + sqr(nv.x));
  VNormalize(dd, n, nv);

  If (dd <= zeiger[i].width Div 2) Then
    Begin
      ll := dd * 2 / zeiger[i].width;
      ll := ll * ll * ll;

      n.x := (n.x * ll) + (random * 0.1 - 0.05);
      n.y := (n.y * ll) + (random * 0.1 - 0.05);

      hh := 0.5 * (1 - sqrt(sqr(n.x + 0.1) + sqr(n.y + 0.25)));
      If sqrt(sqr(n.x + 0.2) + sqr(n.y + 0.4)) < 0.2 Then
        hh := 2; // Highlight

      If (dd > zeiger[i].width Div 2 - 1) Then
        Begin
          // Antiailaising
          ll := (zeiger[i].width Div 2 - dd);
          hh := (1 - ll) * (bg / 256) + (ll * hh);
        End;
    End;
End;

Procedure TFrmClock.VNormalize(dd: Extended; Var n: TExtPoint; nv: TExtPoint);
Begin
  If nv.x = 0 Then
    Begin
      n.x := 0;
      n.y := sign(nv.y);
    End
  Else If nv.y = 0 Then
    Begin
      n.y := 0;
      n.x := sign(nv.x);
    End
  Else
    Begin
      n.y := nv.y / dd;
      n.x := nv.x / dd;
    End;
End;

{$IFDEF FPC}
Procedure TFrmClock.WMNCHitTest(Var M: TLMNCHITTEST);
{$ELSE}
Procedure TFrmClock.WMNCHitTest(Var M: TWMNCHitTest);
{$ENDIF}
 Var
  h: THandle;
Begin
  If (M.Result = htClient) Or (m.result = 0) Then
    M.Result := htCaption;
  if self = FrmClock2 then
    begin
      FrmClock.WMNCHitTest(M);
      m.result := HTNOWHERE;
    end
  else
    begin
      AlphaBlendValue := 255;
      tmr := 11;
      frmClock2.Top:=  top +3;
      frmClock2.Left :=  left +3;
      if image1.top >0 then
        begin
          {$IFNDEF FPC}
          h := CreateEllipticRgn(5, 4, 175, 173);
          SetWindowRgn(Handle, h, TRUE);
          {$ENDIF}

 //     image1.top:=0;
 //     image1.left:=6;
        end;
    end;
End;

Procedure TFrmClock.CreateParams(Var Params: TCreateParams);
Const
  CS_DROPSHADOW = $00020000;

Begin
  Inherited;
//  if assigned(Owner) and Owner.InheritsFrom(TFrmClock) then
  Try
    Params.WindowClass.Style := Params.WindowClass.Style Or CS_DROPSHADOW;
  Finally

  End;
End;

End.

