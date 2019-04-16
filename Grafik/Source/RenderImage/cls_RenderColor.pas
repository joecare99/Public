unit cls_RenderColor;

{$mode objfpc}{$H+}
{$ModeSwitch autoderef}
{$ModeSwitch advancedrecords}


interface

uses
  Classes, SysUtils,cls_RenderBase,Graphics;

type

{ TRenderColor }

 TRenderColor=record
 private
   function GetColor: TColor;
   procedure SetColor(AValue: TColor);
 public
    property Color:TColor read GetColor write SetColor;
    Procedure Init(aRed,aGreen,aBlue:Extended);
    Procedure InitHSB(Hue,Satur,Bright:Extended);
    Function Plus(aCol:TRenderColor) :TRenderColor;
    Function Add(aCol:TRenderColor) :TRenderColor;
    Function Mult(aFak:Extended) :TRenderColor;
    Function Mix(aCol:TRenderColor;aFak:Extended) :TRenderColor;
   case Boolean of
    true:(Red,Green,Blue:Extended);
    false:(V:array[0..2] of Extended);
  end;

Function RenderColor(aRed,aGreen,aBlue:Extended):TRenderColor;

implementation

uses math;

function RenderColor(aRed, aGreen, aBlue: Extended): TRenderColor;inline;
begin
  result.Init(aRed, aGreen, aBlue);
end;

{ TRenderColor }

function TRenderColor.GetColor: TColor;
begin
  result := RGBToColor(
    trunc(min(red,1.0)*255),
    trunc(min(Green,1.0)*255),
    trunc(min(Blue,1.0)*255) );
end;

procedure TRenderColor.SetColor(AValue: TColor);
var
  lRed, lGreen, lBlue: Byte;

const cColFak= 1/255;
begin
  RedGreenBlue(ColorToRGB(AValue),lRed,lGreen,lBlue);
  Red := lRed * cColFak;
  Green := lGreen * cColFak;
  Blue := lBlue * cColFak;
end;

procedure TRenderColor.Init(aRed, aGreen, aBlue: Extended);inline;
begin
  Red := aRed;
  Green := aGreen;
  Blue := aBlue;
end;

procedure TRenderColor.InitHSB(Hue, Satur, Bright: Extended);
var
  lSat: Extended;
begin
  lSat := min(1.0-abs(1.0-Bright*2.0),Satur)*0.5;
  Red:= cos(2*pi*hue)*lsat+Bright;
  Green:= cos(2*pi*(hue-1/3))*lsat+Bright;
  Blue:= cos(2*pi*(hue-2/3))*lsat+Bright;
end;

function TRenderColor.Plus(aCol: TRenderColor): TRenderColor;
begin
  result.Red:=Red + aCol.Red;
  result.Green:=Green + aCol.Green;
  result.Blue:=Blue + aCol.Blue;
end;

function TRenderColor.Add(aCol: TRenderColor): TRenderColor;
begin
  self := Plus(aCol);
  Result := Self;
end;

function TRenderColor.Mult(aFak: Extended): TRenderColor;
begin
  result.Red:=Red * aFak;
  result.Green:=Green * aFak;
  result.Blue:=Blue * aFak;
end;

function TRenderColor.Mix(aCol: TRenderColor; aFak: Extended): TRenderColor;
begin
  result.Red:=Red *(1-aFak) + aCol.Red*aFak;
  result.Green:=Green*(1-aFak) + aCol.Green*aFak;
  result.Blue:=Blue*(1-aFak) + aCol.Blue*aFak;
end;

end.

