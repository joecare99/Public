unit Frm_TestActionForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  GraphUtil,
  unt_Gamebase,
  unt_TerraGen, Buttons;

type
  TForm7 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Button2: TButton;
    Button3: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Procedure RenderFlatLandscape(TG: TTerraGenFkt);
    procedure DoAutoUpdate;
  public
    { Public-Deklarationen }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

uses Frm_TestGameBase;

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
    else
      result := clblack;

  END;
END;

procedure TForm7.Button2Click(Sender: TObject);
begin
  Init;
end;

procedure TForm7.Button3Click(Sender: TObject);
begin
  game.UpDateScreen;
end;

procedure TForm7.FormHide(Sender: TObject);
begin
  if MessageDlg('Wollen Sie das Programm beenden ?',mtConfirmation,mbYesNoCancel,0)=mrYes then
    FrmTestGamebaseMain.Close;
end;

procedure TForm7.FormShow(Sender: TObject);
begin
  RenderFlatLandscape(TG4);
end;

procedure TForm7.RenderFlatLandscape(TG: TTerraGenFkt);
var
  Y: Integer;
  X: Integer;
  H,H2:Extended;
  C:TCOlor;
begin
  FOR Y := 0 TO Image1.Height - 1 DO
    FOR X := 0 TO Image1.Width - 1 DO
      begin
        H := sqr(TG(X / Image1.Width, Y / Image1.Height));
        H2 := sqr(tg((X-1) / Image1.Width, (Y - 1) / Image1.Height));
        C := ColorAdjustLuma(ColorFkt(H),round((H-H2)*512) ,false);
        Image1.Canvas.Pixels[X, Y] := C;
      end;
end;

procedure TForm7.DoAutoUpdate;
begin
  if CheckBox1.Checked then
  begin
    game.Board.PreMove;
    game.Board.ExecMove;
    game.UpDateScreen;
  end;
end;

procedure TForm7.BitBtn1Click(Sender: TObject);
begin
  Game.player.MoveN;
  DoAutoUpdate;
end;

procedure TForm7.BitBtn2Click(Sender: TObject);
begin
    Game.player.MoveW;
  DoAutoUpdate;
end;

procedure TForm7.BitBtn3Click(Sender: TObject);
begin
  Game.player.MoveE;
  DoAutoUpdate;
end;

procedure TForm7.BitBtn4Click(Sender: TObject);
begin
    Game.player.MoveS;
  DoAutoUpdate;
end;

procedure TForm7.BitBtn5Click(Sender: TObject);
begin
  game.board.PreMove;
end;

procedure TForm7.BitBtn6Click(Sender: TObject);
begin
  game.Board.ExecMove;
end;

procedure TForm7.Button1Click(Sender: TObject);
begin
  SetUpGenData;
  RenderFlatLandscape(TG4);
end;

end.
