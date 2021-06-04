unit Labydemo;

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
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TfrmLabyDemo = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmLabyDemo: TfrmLabyDemo;

implementation

uses ProgressBarU, LabyU2,unt_Point2d,variants;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmLabyDemo.Button1Click(Sender: TObject);
var i:integer;
begin
   {ProgessForm.Caption := 'Testfortschritt';
   ProgessForm.show;
   for i := 1 to 100 do
     begin
        ProgessForm.SetPercentage(i);
     end;
   ProgessForm.hide;
   }
   Laby.show;
   Laby.CreateLaby;
end;


procedure TfrmLabyDemo.Button2Click(Sender: TObject);
var path:variant;
    x,y:integer;
  i,d: integer;
begin
  path:=vararrayof([2,1,12,4,4,4,6,5,2,11,
  12,10,10,12,2,6,4,2,12,10,10,2,
  12,2,5,7,4,1,1,12,
  10,10,11,12,2,6,5,4,3,
  1,11,10,12,2,6,4,2,12,10,10,2,4,3,
//  1,11,10,12,4,4,2,10,10,12,2,
  12,10,10,2,
  12,2,5,7,4,1,1]);
  x:=50;
  y:=50;
  with Image1.Canvas do
    begin
      moveto(x,y);

  for i  := 0 to Vararrayhighbound(path,1) do
    begin
      d:=((path[i]+11) mod 12)+1;
      x:=x+dir12[d].x*2;
      y:=Y+dir12[d].y*2;
      lineto(x,y);
    end;
    end;
end;

procedure TfrmLabyDemo.Image1Click(Sender: TObject);

var i,j,imax:integer;
    hp:T2DPoint;

begin

 // hp.init(0,0);
  for i :=  30 to 80 do
    begin
    imax:=round(i*2*pi);
    for j:= 1 to imax do
      begin
        hp:=unt_Point2d.getdir(i,j);
        image1.Canvas.Pixels[hp.x+40,hp.y+40]:=rgb(i*3,i*2{%H-}+round(j/imax*90) ,round(j/imax*250));
        image1.Canvas.Pixels[j,hp.x+120]:=rgb(i*3,i*2{%H-}+round(j/imax*90) ,round(j/imax*250));
        image1.Canvas.Pixels[j,hp.y+200]:=rgb(i*3,i*2{%H-}+round(j/imax*90) ,round(j/imax*250));
        hp.free;

      end;
        image1.update;
  end;
end;

end.
