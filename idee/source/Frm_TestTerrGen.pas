UNIT Frm_TestTerrGen;

INTERFACE

USES
  { Winapi. } Windows,
  { Winapi. } Messages,
  { System. } SysUtils,
  { System. } Variants,
  { System. } Classes,
  { Vcl. } Graphics,
  { Vcl. } Controls,
  { Vcl. } Forms,
  { Vcl. } Dialogs,
  { Vcl. } ExtCtrls,
  { Vcl. } StdCtrls,
  GraphUtil,
  unt_TerraGen;

TYPE
  TForm5 = CLASS(TForm)
    Button1: TButton;
    Image1: TImage;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    PROCEDURE Button1Click(Sender: TObject);
    PROCEDURE Button2Click(Sender: TObject);
    PROCEDURE Button3Click(Sender: TObject);
    PROCEDURE Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  PRIVATE
    procedure RenderIsoLandscape(TG: TTerraGenFkt);
    procedure RenderFlatLandscape(TG: TTerraGenFkt);
    { Private-Deklarationen }
  PUBLIC
    { Public-Deklarationen }
  END;

VAR
  Form5: TForm5;

IMPLEMENTATION

{$R *.dfm}

FUNCTION ColorFkt(Height: extended): TColor;

BEGIN
  CASE trunc(Height * 20) OF
    0 .. 2:
      result := clBlue;
    3:
      result := clYellow;
    4 .. 9:
      result := clLime;
    10 .. 14:
      result := clGreen;
    15 .. 16:
      result := clgray;
    17:
      result := clDkGray;
    18 .. 20:
      result := clWhite;
  END;
END;

procedure TForm5.RenderFlatLandscape(TG: TTerraGenFkt);
var
  Y: Integer;
  X: Integer;
  H, H2: extended;
  C: TColor;
begin
  FOR Y := 0 TO Image1.Height - 1 DO
    FOR X := 0 TO Image1.Width - 1 DO
    begin
      H := sqr(TG(X / Image1.Width, Y / Image1.Height));
      H2 := sqr(TG((X - 1) / Image1.Width, (Y - 1) / Image1.Height));
      C := ColorAdjustLuma(ColorFkt(H), round((H - H2) * 512), false);
      Image1.Canvas.Pixels[X, Y] := C;
    end;
end;

procedure TForm5.RenderIsoLandscape(TG: TTerraGenFkt);
var
  Y: Integer;
  X: Integer;
  Height: extended;
  H2: extended;
begin
  FOR Y := 0 to Image1.Height - 1 DO
    FOR X := 0 TO Image1.Width - 1 DO
    BEGIN
      Height := sqr(TG(X / Image1.Width, Y * 3 / Image1.Height));
      H2 := sqr(TG((X) / Image1.Width, (Y * 3 - 0.1) / Image1.Height));
      Image1.Canvas.Pen.Color := ColorFkt(Height);
      if Height - H2 > 0.00 then
        Image1.Canvas.Pixels[X, Y - trunc(sqr(sqr(Height)) * 20) - 1] :=
          ColorAdjustLuma
          (Image1.Canvas.Pixels[X, Y - trunc(sqr(sqr(Height)) * 20) - 1], -10,
          false);
      Image1.Canvas.Moveto(X, Y - trunc(sqr(sqr(Height)) * 20));
      Image1.Canvas.Lineto(X, Y + 1);
    END;
end;

PROCEDURE TForm5.Button1Click(Sender: TObject);
VAR
  X, Y: Integer;
BEGIN
  FOR Y := 0 TO Image1.Height - 1 DO
    FOR X := 0 TO Image1.Width - 1 DO
      Image1.Canvas.Pixels[X, Y] := ColorFkt
        (tg1(X / Image1.Width, Y / Image1.Height));
END;

PROCEDURE TForm5.Button2Click(Sender: TObject);

BEGIN
  RenderFlatLandscape(tg1);
END;

PROCEDURE TForm5.Button3Click(Sender: TObject);
VAR
  X, Y: Integer;
BEGIN
  FOR Y := 0 TO Image1.Height - 1 DO
    FOR X := 0 TO Image1.Width - 1 DO
      Image1.Canvas.Pixels[X, Y] := ColorFkt
        (tg2(X / Image1.Width, Y / Image1.Height));
END;

PROCEDURE TForm5.Button4Click(Sender: TObject);

BEGIN
  RenderIsoLandscape(tg2);
END;

procedure TForm5.Button5Click(Sender: TObject);

BEGIN
  RenderFlatLandscape(tg2);
end;

procedure TForm5.Button6Click(Sender: TObject);
begin
  SetUpGenData;
end;

procedure TForm5.Button7Click(Sender: TObject);
begin
  RenderFlatLandscape(tg3);
end;

procedure TForm5.Button8Click(Sender: TObject);
begin
  RenderIsoLandscape(tg3);
end;

procedure TForm5.Button9Click(Sender: TObject);
begin
  RenderFlatLandscape(tg4);
end;

procedure TForm5.Button10Click(Sender: TObject);
begin
  RenderIsoLandscape(tg4);
end;

procedure TForm5.FormResize(Sender: TObject);
begin
  Image1.Height := Height - 60;
  Image1.Width := Width - 200;
end;

END.
