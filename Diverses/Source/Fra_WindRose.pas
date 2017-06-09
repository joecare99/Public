unit Fra_WindRose;

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

type
///<author>Rosewich</author>
TFraWindRose = class(TFrame)
    Image1: TImage;
    procedure FrameResize(Sender: TObject);
  private
    { Private-Deklarationen }
    FZeigerdir:integer; (*Grad*)
    FZeiger2dir:integer; (*Grad*)
    FRadius:integer;
    procedure DrawBackGround;
    procedure DrawZeiger;
    procedure HideZeiger;
  strict private
    function GetDirection : Integer;
    procedure SetDirection(val : Integer);
    function GetDirection2 : Integer;
    procedure SetDirection2(val : Integer);
  public
  ///<author>Rosewich</author>
  property Direction : Integer read GetDirection write SetDirection;
  property Direction2 : Integer read GetDirection2 write SetDirection2;
  { Public-Deklarationen }
  end;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TFraWindRose.DrawBackGround;
var i:integer;
begin
  image1.Canvas.Brush.Color := Color;
  image1.canvas.fillrect(image1.canvas.cliprect);
  for I := 0 to 35 do
    begin
      image1.Canvas.Brush.Color := clblack;

      image1.canvas.MoveTo(
         Fradius+trunc(sin((i*10+0)*pi/180)*FRadius*1.0),
         Fradius+trunc(-cos((i*10+0)*pi/180)*FRadius*1.0));
      image1.canvas.LineTo(
         Fradius+trunc(sin((i*10+0)*pi/180)*FRadius*1.05),
         Fradius+trunc(-cos((i*10+0)*pi/180)*FRadius*1.05));

    end;

end;

procedure TFraWindRose.DrawZeiger;

var pts:array of TPoint;
begin
  setlength(pts,4);

  pts[0].X:=Fradius+trunc(sin((FZeiger2dir+0)*pi/180)*FRadius*1.0);
  pts[0].y:=Fradius+trunc(-cos((FZeiger2dir+0)*pi/180)*FRadius*1.0);
  pts[1].X:=Fradius+trunc(sin((FZeiger2dir+160)*pi/180)*FRadius*0.6);
  pts[1].y:=Fradius+trunc(-cos((FZeiger2dir+160)*pi/180)*FRadius*0.6);
  pts[2].X:=Fradius+trunc(sin((FZeiger2dir+180)*pi/180)*FRadius*0.4);
  pts[2].y:=Fradius+trunc(-cos((FZeiger2dir+180)*pi/180)*FRadius*0.4);
  pts[3].X:=Fradius+trunc(sin((FZeiger2dir+200)*pi/180)*FRadius*0.6);
  pts[3].y:=Fradius+trunc(-cos((FZeiger2dir+200)*pi/180)*FRadius*0.6);

  image1.Canvas.Brush.Color := clYellow;
  image1.Canvas.pen.Color := clWhite;
  image1.Canvas.Polygon(pts);

  pts[0].X:=Fradius+trunc(sin((FZeigerdir+0)*pi/180)*FRadius*1.0)+2;
  pts[0].y:=Fradius+trunc(-cos((FZeigerdir+0)*pi/180)*FRadius*1.0)+2;
  pts[1].X:=Fradius+trunc(sin((FZeigerdir+160)*pi/180)*FRadius*0.6)+2;
  pts[1].y:=Fradius+trunc(-cos((FZeigerdir+160)*pi/180)*FRadius*0.6)+2;
  pts[2].X:=Fradius+trunc(sin((FZeigerdir+180)*pi/180)*FRadius*0.4)+2;
  pts[2].y:=Fradius+trunc(-cos((FZeigerdir+180)*pi/180)*FRadius*0.4)+2;
  pts[3].X:=Fradius+trunc(sin((FZeigerdir+200)*pi/180)*FRadius*0.6)+2;
  pts[3].y:=Fradius+trunc(-cos((FZeigerdir+200)*pi/180)*FRadius*0.6)+2;

  image1.Canvas.Brush.Color := clgray;
  image1.Canvas.pen.Color := clGray;
  image1.Canvas.Polygon(pts);

  pts[0].X:=Fradius+trunc(sin((FZeigerdir+0)*pi/180)*FRadius*1.0);
  pts[0].y:=Fradius+trunc(-cos((FZeigerdir+0)*pi/180)*FRadius*1.0);
  pts[1].X:=Fradius+trunc(sin((FZeigerdir+160)*pi/180)*FRadius*0.6);
  pts[1].y:=Fradius+trunc(-cos((FZeigerdir+160)*pi/180)*FRadius*0.6);
  pts[2].X:=Fradius+trunc(sin((FZeigerdir+180)*pi/180)*FRadius*0.4);
  pts[2].y:=Fradius+trunc(-cos((FZeigerdir+180)*pi/180)*FRadius*0.4);
  pts[3].X:=Fradius+trunc(sin((FZeigerdir+200)*pi/180)*FRadius*0.6);
  pts[3].y:=Fradius+trunc(-cos((FZeigerdir+200)*pi/180)*FRadius*0.6);

  image1.Canvas.Brush.Color := clRed;
  image1.Canvas.pen.Color := clMaroon;
  image1.Canvas.Polygon(pts);
end;

procedure TFraWindRose.FrameResize(Sender: TObject);
begin
  HideZeiger;
  FRadius := ClientWidth div 2;
  if ClientHeight <ClientWidth then
    FRadius := Clientheight div 2;
  drawbackground;
  drawzeiger;
end;

procedure TFraWindRose.HideZeiger;
var pts:array of TPoint;
begin

  setlength(pts,4);

  pts[0].X:=Fradius+trunc(sin((FZeigerdir+0)*pi/180)*FRadius*1.0);
  pts[0].y:=Fradius+trunc(-cos((FZeigerdir+0)*pi/180)*FRadius*1.0);
  pts[1].X:=Fradius+trunc(sin((FZeigerdir+160)*pi/180)*FRadius*0.6);
  pts[1].y:=Fradius+trunc(-cos((FZeigerdir+160)*pi/180)*FRadius*0.6);
  pts[2].X:=Fradius+trunc(sin((FZeigerdir+180)*pi/180)*FRadius*0.4);
  pts[2].y:=Fradius+trunc(-cos((FZeigerdir+180)*pi/180)*FRadius*0.4);
  pts[3].X:=Fradius+trunc(sin((FZeigerdir+200)*pi/180)*FRadius*0.6);
  pts[3].y:=Fradius+trunc(-cos((FZeigerdir+200)*pi/180)*FRadius*0.6);

  image1.Canvas.Brush.Color := Color;
  image1.Canvas.pen.Color := Color;
  image1.Canvas.Polygon(pts);

  pts[0].X:=Fradius+trunc(sin((FZeigerdir+0)*pi/180)*FRadius*1.0)+2;
  pts[0].y:=Fradius+trunc(-cos((FZeigerdir+0)*pi/180)*FRadius*1.0)+2;
  pts[1].X:=Fradius+trunc(sin((FZeigerdir+160)*pi/180)*FRadius*0.6)+2;
  pts[1].y:=Fradius+trunc(-cos((FZeigerdir+160)*pi/180)*FRadius*0.6)+2;
  pts[2].X:=Fradius+trunc(sin((FZeigerdir+180)*pi/180)*FRadius*0.4)+2;
  pts[2].y:=Fradius+trunc(-cos((FZeigerdir+180)*pi/180)*FRadius*0.4)+2;
  pts[3].X:=Fradius+trunc(sin((FZeigerdir+200)*pi/180)*FRadius*0.6)+2;
  pts[3].y:=Fradius+trunc(-cos((FZeigerdir+200)*pi/180)*FRadius*0.6)+2;

  image1.Canvas.Polygon(pts);

  pts[0].X:=Fradius+trunc(sin((FZeiger2dir+0)*pi/180)*FRadius*1.0);
  pts[0].y:=Fradius+trunc(-cos((FZeiger2dir+0)*pi/180)*FRadius*1.0);
  pts[1].X:=Fradius+trunc(sin((FZeiger2dir+160)*pi/180)*FRadius*0.6);
  pts[1].y:=Fradius+trunc(-cos((FZeiger2dir+160)*pi/180)*FRadius*0.6);
  pts[2].X:=Fradius+trunc(sin((FZeiger2dir+180)*pi/180)*FRadius*0.4);
  pts[2].y:=Fradius+trunc(-cos((FZeiger2dir+180)*pi/180)*FRadius*0.4);
  pts[3].X:=Fradius+trunc(sin((FZeiger2dir+200)*pi/180)*FRadius*0.6);
  pts[3].y:=Fradius+trunc(-cos((FZeiger2dir+200)*pi/180)*FRadius*0.6);

  image1.Canvas.Polygon(pts);

end;

function TFraWindRose.GetDirection: Integer;
begin
  result:=FZeigerdir;
end;

procedure TFraWindRose.SetDirection(val : Integer);
begin
  if (FZeigerdir <> val) then
    begin
      HideZeiger;
      FZeigerdir :=val;
      DrawZeiger;
    end;
end;

function TFraWindRose.GetDirection2: Integer;
begin
  result:=FZeiger2dir;
end;

procedure TFraWindRose.SetDirection2(val : Integer);
begin
  if (FZeiger2dir <> val) then
    begin
      DrawBackGround;
      FZeiger2dir :=val;
      DrawZeiger;
    end;
end;

end.
