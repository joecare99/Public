unit Frm_TestSprites;

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
    Dialogs, ExtCtrls;

const
    anz = 40;

type

    { TSprite }

    TSprite = record
        a: array[0..23] of TBitmap;
        spos: TPoint;
        Step,
        dx, dy, ds: integer;
        procedure Init(apos: TPoint; tt: integer);
        procedure DoStep(ClientWidth, Clientheight: integer);
        procedure Paint(const Canvas: TCanvas);
        procedure Free;
    end;

    TTestSpritesForm = class(TForm)
        Timer1: TTimer;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure FormResize(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
    private
        Sprite: array[1..anz] of TSprite;
        FDataPath: string;
        HGBit: TFPImageBitmap;
        ShadowBit: TBitmap;
        { Private-Deklarationen }
    public
        { Public-Deklarationen }
    end;

var
    TestSpritesForm: TTestSpritesForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

resourcestring
    SDataBase = 'Data';

{ TSprite }

procedure TSprite.Init(apos: TPoint; tt: integer);
var
    J, x: integer;
begin

      begin
        spos := apos;
        dX := Random(5) - 2;
        dY := Random(5) - 2;
        step := Random(8);
        ds := Random(2) * 2 - 1;
        for J := 0 to 23 do
          begin
            a[j] := TBitmap.Create;
            a[j].Width := 32;
            a[j].Height := 32;
            a[j].Canvas.Brush.Color := $00;
            a[j].Canvas.FillRect(Rect(0, 0, 32, 32));

            case tt of
                0: for x := 1 to 7 do
                      begin // Pseudo Sprites erzeugen
                        a[j].Canvas.Pen.Color :=
                            $FFFFFF and ($BF0000BF shr ((x * 3 + j) mod 24));
                        a[j].Canvas.Rectangle(x * 2, x * 2, 32 - x * 2, 32 - x * 2);
                      end;
                1: for x := 1 to 7 do
                      begin // Pseudo Sprites erzeugen
                        a[j].Canvas.Pen.Color :=
                            $FFFFFF and ($D30000D3 shr ((x * 2 + j * 2) mod 24));
                        a[j].Canvas.Ellipse(x * 2, x * 2, 32 - x * 2, 32 - x * 2);
                      end;
                2: for x := 1 to 7 do
                      begin // Pseudo Sprites erzeugen
                        a[j].Canvas.Pen.Color :=
                            $FFFFFF and ($D30000D3 shr ((x * 2 + j * 2) mod 24));
                        a[j].Canvas.Rectangle(x * 2, x * 2, 32 - x * 2, 32 - x * 2);
                      end;
                3: for x := 1 to 7 do
                      begin // Pseudo Sprites erzeugen
                        a[j].Canvas.Pen.Color :=
                            $FFFFFF and ($BF0000BF shr ((x * 3 + j) mod 24));
                        a[j].Canvas.Ellipse(x * 2, x * 2, 32 - x * 2, 32 - x * 2);
                      end;
              end;
            a[j].TransparentColor := clBlack;
            a[j].Transparent := True;
          end;
      end;

end;

procedure TSprite.DoStep(ClientWidth, Clientheight: integer);
begin
    if (spos.x + dx > ClientWidth - 32) then
      begin
        dx := -dx div 2 - 1;
        dy := dy + (random(3) - 1);
        ds := -ds;
        spos.x := ClientWidth - 32;
      end;
    if (spos.x + dx < 0) then
      begin
        dx := -dx div 2 + 1;
        dy := dy + (random(3) - 1);
        ds := -ds;
      end;
    spos.X := spos.X + dx;
    if (spos.y + dy > Clientheight - 32) then
      begin
        dy := -dy div 2 - 1;
        dx := dx + (random(3) - 1);
        ds := -ds;
        spos.y := Clientheight - 32;
      end;
    if (spos.y + dy < 0) then
      begin
        dy := -dy div 2 + 1;
        dx := dx + (random(3) - 1);
        ds := -ds;
      end;
    spos.y := spos.y + dy;
    step := (step + ds + 24) mod 24;
end;

procedure TSprite.Paint(const Canvas: TCanvas);
begin
    canvas.Draw(spos.x, spos.y, a[step]);
end;

procedure TSprite.Free;
var
    j: integer;
begin
    for j := 0 to 23 do
        a[j].Free;
end;

procedure TTestSpritesForm.FormCreate(Sender: TObject);
var
    i: integer;

begin
    FDataPath := SDataBase;
    for i := 0 to 2 do
        if DirectoryExists(FDataPath) then
            break
        else
            FDataPath := '..' + DirectorySeparator + FDataPath;
    Timer1.Interval := 40;
    HGBit := tbitmap(TPortableNetworkGraphic.Create);
    ShadowBit := TBitmap.Create;
    for i := 1 to anz do
        Sprite[i].INit(point(Random(ClientWidth), Random(ClientHeight)), random(4));
    HGBit.LoadFromFile(FDatapath + '\texture3.png');
end;

procedure TTestSpritesForm.FormDestroy(Sender: TObject);
var
    i, j: integer;
begin
    for i := 1 to anz do
        Sprite[i].Free;
    HGBit.Free;
    ShadowBit.Free;
end;

procedure TTestSpritesForm.FormResize(Sender: TObject);
begin
    ReFresh;
    ShadowBit.Width := ClientWidth;
    ShadowBit.Height := ClientHeight;
end;

procedure TTestSpritesForm.Timer1Timer(Sender: TObject);
var
    i: integer;
begin
    ShadowBit.Canvas.StretchDraw(Rect(0, 0, ClientWidth, ClientHeight), HGBit);
    //  ShadowBit.Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));
    for i := 1 to anz do
        with Sprite[i] do
          begin
            DoStep(ClientWidth, ClientHeight);
            Paint(ShadowBit.canvas);
            // ShadowBit.Canvas.BrushCopy(rect(spos.x, spos.y, spos.x+32, spos.y+32),a,rect( 0, 0, 32, 32),clblack );
            //StretchBlt(ShadowBit.Canvas.Handle, spos.x, spos.y, 32, 32,
            //  b.Canvas.Handle, 0, 0, 32, 32, SRCAND);
            //StretchBlt(ShadowBit.Canvas.Handle, spos.x, spos.y, 32, 32,
            //  a.Canvas.Handle, 0, 0, 32, 32, SRCPAINT);
          end;
    canvas.stretchDraw(Rect(0, 0, ClientWidth, ClientHeight), ShadowBit);
    sleep(0);
end;

end.
