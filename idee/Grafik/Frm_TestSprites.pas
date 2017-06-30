Unit Frm_TestSprites;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

Const
  anz = 40;

Type
  TSprite = Record
    a: array[0..23] of  TBitmap;
    spos: TPoint;
    Step,
    dx, dy,ds: integer;
  End;

  TTestSpritesForm = Class(TForm)
    Timer1: TTimer;

    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure FormResize(Sender: TObject);
    Procedure Timer1Timer(Sender: TObject);
  private
    Sprite: Array[1..anz] Of TSprite;
    FDataPath: String;
    HGBit: TFPImageBitmap;
    ShadowBit: TBitmap;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  End;

Var
  TestSpritesForm: TTestSpritesForm;

Implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

resourcestring
  SDataBase= 'Data';
Procedure TTestSpritesForm.FormCreate(Sender: TObject);
Var
  i, x, y: Integer;
  J: Integer;
  tt: Int64;

Begin
  FDataPath:= SDataBase;
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      break
    else
      FDataPath:='..'+DirectorySeparator+FDataPath;
  Timer1.Interval := 40;
  HGBit := tbitmap(TPortableNetworkGraphic.Create);
  ShadowBit := TBitmap.Create;
  For i := 1 To anz Do
    with Sprite[i] do
    Begin
      spos.X := Random(ClientWidth);
      spos.Y := Random(ClientHeight);
      dX := Random(5)-2;
      dY := Random(5)-2;
      step :=Random(8);
      ds := Random(2)*2-1;
      tt := random(4);
      for J := 0 to 23 do
        begin
      a[j] := TBitmap.Create;
      a[j].Width := 32;
      a[j].Height := 32;
      a[j].Canvas.Brush.Color := $00;
      a[j].Canvas.FillRect(Rect(0, 0, 32, 32));

       case tt of
      0:For x := 1 To 7 Do
        Begin // Pseudo Sprites erzeugen
          a[j].Canvas.Pen.Color := $FFFFFF and ($BF0000BF Shr ((x*3+j) mod 24));
          a[j].Canvas.Rectangle(x * 2, x * 2, 32 - x * 2, 32 - x * 2);
        End;
      1:For x := 1 To 7 Do
        Begin // Pseudo Sprites erzeugen
          a[j].Canvas.Pen.Color := $FFFFFF and ($D30000D3 Shr ((x*2+j*2) mod 24));
          a[j].Canvas.Ellipse(x * 2, x * 2, 32 - x * 2, 32 - x * 2);
        End;
      2:For x := 1 To 7 Do
        Begin // Pseudo Sprites erzeugen
          a[j].Canvas.Pen.Color := $FFFFFF and ($D30000D3 Shr ((x*2+j*2) mod 24));
          a[j].Canvas.Rectangle(x * 2, x * 2, 32 - x * 2, 32 - x * 2);
        End;
      3:For x := 1 To 7 Do
        Begin // Pseudo Sprites erzeugen
          a[j].Canvas.Pen.Color := $FFFFFF and ($BF0000BF Shr ((x*3+j) mod 24));
          a[j].Canvas.Ellipse(x * 2, x * 2, 32 - x * 2, 32 - x * 2);
        End;
      end;
      a[j].TransparentColor:=clBlack;
      a[j].Transparent:=true;
        end;
    End;
  HGBit.LoadFromFile(FDatapath+'\texture3.png');
End;

Procedure TTestSpritesForm.FormDestroy(Sender: TObject);
Var
  i,j: Integer;
Begin
  For i := 1 To anz Do
    for j := 0 to 23 do
    Begin
      Sprite[i].a[j].Free;
    End;
  HGBit.Free;
  ShadowBit.Free;
End;

Procedure TTestSpritesForm.FormResize(Sender: TObject);
Begin
  ReFresh;
  ShadowBit.Width := ClientWidth;
  ShadowBit.Height := ClientHeight;
End;

Procedure TTestSpritesForm.Timer1Timer(Sender: TObject);
Var
  i: Integer;
Begin
  ShadowBit.Canvas.StretchDraw(Rect(0, 0, ClientWidth, ClientHeight), HGBit);
//  ShadowBit.Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));
  For i := 1 To anz Do
    with Sprite[i] do
    Begin
      If (spos.x+dx > ClientWidth-32) Then
        begin
        dx := -dx div 2 -1;
        dy:= dy+(random(3)-1);
        ds:= -ds;
         spos.x:= ClientWidth-32;
        end;
      If (spos.x+dx < 0) Then
        begin
        dx := -dx div 2 +1;
        dy:= dy+(random(3)-1);
        ds:= -ds;
        end;
      spos.X:=spos.X+dx;
      If (spos.y+dy > Clientheight-32) Then
        begin
        dy := -dy div 2 -1;
        dx:= dx+(random(3)-1);
        ds:= -ds;
        spos.y:= Clientheight-32;
        end;
      If (spos.y+dy < 0) Then
        begin
        dy := -dy div 2 +1;
        dx:= dx+(random(3)-1);
        ds:= -ds;
        end;
      spos.y:=spos.y+dy;
      step := (step + ds+24) mod 24;
      ShadowBit.canvas.Draw(spos.x, spos.y,a[step]);
      // ShadowBit.Canvas.BrushCopy(rect(spos.x, spos.y, spos.x+32, spos.y+32),a,rect( 0, 0, 32, 32),clblack );
      //StretchBlt(ShadowBit.Canvas.Handle, spos.x, spos.y, 32, 32,
      //  b.Canvas.Handle, 0, 0, 32, 32, SRCAND);
      //StretchBlt(ShadowBit.Canvas.Handle, spos.x, spos.y, 32, 32,
      //  a.Canvas.Handle, 0, 0, 32, 32, SRCPAINT);
    End;
  canvas.stretchDraw(Rect(0, 0, ClientWidth, ClientHeight), ShadowBit);
  sleep(0);
End;

End.

