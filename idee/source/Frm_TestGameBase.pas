UNIT Frm_TestGameBase;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  StdCtrls,
  Menus,
  ExtCtrls,
  cls_GameBase,
  int_GameHMI;

TYPE
  TFrmTestGamebaseMain = CLASS(TForm, iHMI)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    Image1: TImage;
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
  PRIVATE
    FOnPlayerAction: TPlayerActionEvent;
    XTiles:          Integer;
    YTiles:          Integer;
    PROCEDURE DrawField(field: TField; x, y: Integer);
    { Private-Deklarationen }
  PUBLIC
    { Public-Deklarationen }
    PROCEDURE SetOnPlayerAction(val: TPlayerActionEvent);
    FUNCTION GetOnPlayerAction(): TPlayerActionEvent;
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>04.10.2012</since>
    /// <info>Zeichnet das Spielfeld (neu) </info>
    PROCEDURE UpdatePlayfield(Board: TBoardBase; Player: TPlayerBase);
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>04.10.2012</since>
    /// <info>Schreibt Spieler-Status </info>
    PROCEDURE UpdateStatus(Player: TPlayerBase);
     /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>16.12.2014</since>
    /// <info>Initialisiert HMI </info>
    PROCEDURE InitHMI;
  END;

VAR
  FrmTestGamebaseMain: TFrmTestGamebaseMain;

IMPLEMENTATION

{$R *.dfm}

USES Frm_TestActionForm,
  unt_GameBase;

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
      result := clWhite
  ELSE
    result := clblack;
  END;
END;

PROCEDURE TFrmTestGamebaseMain.FormCreate(Sender: TObject);
BEGIN
  HMI := self;
  XTiles := 30;
  YTiles := 25;
END;

PROCEDURE TFrmTestGamebaseMain.FormShow(Sender: TObject);
BEGIN
  IF NOT assigned(Form7) THEN
    Application.CreateForm(TForm7, Form7);
  Form7.show;
END;

PROCEDURE TFrmTestGamebaseMain.SetOnPlayerAction(val: TPlayerActionEvent);
BEGIN
  FOnPlayerAction := val;
END;

FUNCTION TFrmTestGamebaseMain.GetOnPlayerAction: TPlayerActionEvent;
BEGIN
  result := FOnPlayerAction;
END;

procedure TFrmTestGamebaseMain.InitHMI;
begin
  // Show Game init-Things
end;

PROCEDURE TFrmTestGamebaseMain.UpdatePlayfield(Board: TBoardBase;
  Player: TPlayerBase);
VAR
  px, py, ox, oy: Integer;
  x:              Integer;
  y:              Integer;
  field:          TField;
BEGIN
  px := Player.GetXKoor;
  py := Player.GetYKoor;
  ox := px - XTiles DIV 2;
  oy := py - YTiles DIV 2;
  IF ox < 0 THEN
    ox := 0;
  IF ox >= Board.SizeX - XTiles THEN
    ox := Board.SizeX - XTiles-1;
  IF oy < 0 THEN
    oy := 0;
  IF oy >= Board.Sizey - YTiles THEN
    oy := Board.Sizey - YTiles-1;

  FOR x := ox TO ox + XTiles DO
    FOR y := oy TO oy + YTiles DO
      BEGIN
        field := Board.field[x, y];
        DrawField(field, x - ox, y - oy);
      END;
END;

PROCEDURE TFrmTestGamebaseMain.UpdateStatus(Player: TPlayerBase);
VAR
  pi:   Integer;
  Prop: STRING;
BEGIN
  Memo1.Clear;
  Memo1.Lines.Add('Status :');
  pi := 0;
  WHILE True DO
    BEGIN
      Prop := Player.GetProperty(pi);
      IF Prop <> '' THEN
        BEGIN
          Memo1.Lines.Add(Prop);
          inc(pi);
        END
      ELSE
        break
    END;
END;

PROCEDURE TFrmTestGamebaseMain.DrawField(field: TField; x, y: Integer);
VAR
  xh, yh:    Integer;
  FieldData: iFieldData;
  s:String;
BEGIN
  xh := Image1.Width DIV XTiles;
  yh := Image1.Height DIV YTiles;
  IF assigned(field) THEN
    BEGIN
      Image1.Canvas.Brush.Color := ColorFkt(field.FieldType / 20);
      Image1.Canvas.FillRect(rect(x * xh, y * yh, (x + 1) * xh, (y + 1) * yh));
      FOR FieldData IN field.Data DO
        IF FieldData.isEntity THEN
          with iEntity(FieldData) do
          BEGIN
            s := Tobject(FieldData).classname;
            if s = 'TPlayer' then
            Image1.Canvas.pen.Color := clred
            else
            Image1.Canvas.pen.Color := clblack;

            Image1.Canvas.moveTo(x * xh + 1, y * yh + 1);
            Image1.Canvas.lineto((x + 1) * xh - 1, (y + 1) * yh - 1);
            Image1.Canvas.moveTo((x + 1) * xh - 1, y * yh + 1);
            Image1.Canvas.lineto((x) * xh + 1, (y + 1) * yh - 1);
            Image1.Canvas.Brush.Color := Image1.Canvas.pen.Color;
            image1.canvas.Ellipse(x * xh+xh div 2-5, y * yh-5,x * xh+xh div 2+5, y * yh+5);
          END;
    END;
END;

END.
