unit cls_RenderColor;

{$mode objfpc}{$H+}
{$ModeSwitch autoderef}
{$ModeSwitch advancedrecords}
{$interfaces CORBA}


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
    Function Minus(aCol:TRenderColor) :TRenderColor;
    Function Mult(aFak:Extended) :TRenderColor;
    Function Mix(aCol:TRenderColor;aFak:Extended) :TRenderColor;
    Function Filter(aCol:TRenderColor):TRenderColor;
    Function Equals(aCol:TRenderColor):Boolean;
   case Boolean of
    true:(Red,Green,Blue:Extended);
    false:(V:array[0..2] of Extended);
  end;

Function RenderColor(aRed,aGreen,aBlue:Extended):TRenderColor;

type iHasColor=interface
['{1F2FC516-23CE-4439-B8D7-75E29F618C00}']
       function GetColorAt(aPOint:TRenderpoint):TRenderColor;
       property ColorAt[aPOint:TRenderpoint]:TRenderColor read GetColorAt;
     end;

 operator := (aRight: variant) aLeft:TRenderColor;
 operator := (aRight: TColor) aLeft:TRenderColor;
 operator := (aRight: TRenderColor) aLeft:TColor;
 operator = (aPar1,aPar2:TRenderColor) aLeft:boolean;
 operator + (aPar1,aPar2:TRenderColor) aLeft:TRenderColor;
 operator - (aPar1,aPar2:TRenderColor) aLeft:TRenderColor;
 operator * (aPar1,aPar2:TRenderColor) aLeft:TRenderColor;overload;
 operator * (aPar1:TRenderColor; aFak:extended) aLeft:TRenderColor;overload;
 operator * (aFak:extended; aPar2:TRenderColor) aLeft:TRenderColor;overload;


implementation

uses math,variants;

function RenderColor(aRed, aGreen, aBlue: Extended): TRenderColor;inline;
begin
  result.Init(aRed, aGreen, aBlue);
end;

operator:=(aRight: variant)aLeft: TRenderColor;
begin
  assert(VarArrayHighBound(aRight,0)=2,'Variant array must have 3 entries');
  aLeft.init(aRight[0],aRight[1],aRight[2]);
end;

operator:=(aRight: TColor)aLeft: TRenderColor;
begin
  ALeft.color := aRight;
end;

operator:=(aRight: TRenderColor)aLeft: TColor;
begin
  aLeft := aRight.Color;
end;

operator=(aPar1, aPar2: TRenderColor)aLeft: boolean;
begin
  aleft := aPar1.Equals(aPar2);
end;

operator+(aPar1, aPar2: TRenderColor)aLeft: TRenderColor;
begin
  aLeft := aPar1.Plus(aPar2);
end;

operator-(aPar1, aPar2: TRenderColor)aLeft: TRenderColor;
begin
  aLeft := aPar1.Minus(aPar2);
end;

operator*(aPar1, aPar2: TRenderColor)aLeft: TRenderColor;
begin
  aLeft := aPar1.Filter(aPar2);
end;

operator*(aPar1: TRenderColor; aFak: extended)aLeft: TRenderColor;
begin
  aLeft := aPar1.Mult(aFak);
end;

operator*(aFak: extended; aPar2: TRenderColor)aLeft: TRenderColor;
begin
  aLeft := aPar2.Mult(aFak);
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

function TRenderColor.Minus(aCol: TRenderColor): TRenderColor;
begin
  result.Red:=max(Red - aCol.Red,0.0);
  result.Green:=max(Green - aCol.Green,0.0);
  result.Blue:=max(Blue - aCol.Blue,0.0);
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

function TRenderColor.Filter(aCol: TRenderColor): TRenderColor;
begin
  Result.Red:= Red * aCol.Red;
  Result.Green:= Green * aCol.Green;
  Result.Blue:= Blue * aCol.Blue;
end;

function TRenderColor.Equals(aCol: TRenderColor): Boolean;

const cEps=1e-4; // Color-differences lower than 0.1% are considered equal;

begin
  result :=
    (abs(Red-aCol.red) < 1e-4) and
    (abs(Green-aCol.Green) < 1e-4) and
    (abs(Blue-aCol.Blue) < 1e-4);
end;

end.

