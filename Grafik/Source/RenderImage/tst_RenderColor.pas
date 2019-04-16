unit tst_RenderColor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, cls_RenderColor;

type

  { TTestRenderColor }

  TTestRenderColor= class(TTestCase)
  private
    FRenderColor:TRenderColor;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestBasicDisplay;
    Procedure TestInit;
    Procedure TestInitHue;
  end;

implementation

uses Forms,frm_DisplTestColor;

procedure TTestRenderColor.TestSetUp;
begin
  CheckNotNull(FrmDisplayTestColor,'Test-Form is Visible');
  CheckEquals(true,FrmDisplayTestColor.Visible,'TestForm is Visible');
  FrmDisplayTestColor.UpdateDisplay;
  sleep(1000);
end;

procedure TTestRenderColor.TestBasicDisplay;
var
  i: Integer;
begin
  FrmDisplayTestColor.Color1 := RenderColor(1,0,0);
  FrmDisplayTestColor.Color2 := RenderColor(0,1,0);
  FrmDisplayTestColor.Color3 := RenderColor(0,0,1);
  for i := 0 to 100 do
    begin
      FrmDisplayTestColor.Faktor:=i/100;
      FrmDisplayTestColor.UpdateDisplay;
      sleep(10);
    end;
end;

procedure TTestRenderColor.TestInit;
var
  i: Integer;
  lRed, lGreen, lBlue: Extended;
begin
  FRenderColor.Init(1,0,0);
  FrmDisplayTestColor.Color1 := FRenderColor;
  CheckEquals(1.0,FRenderColor.Red,1e-15,'Red Property of Color');
  CheckEquals(0.0,FRenderColor.Green,1e-15,'Green Property of Color');
  CheckEquals(0.0,FRenderColor.Blue,1e-15,'Blue Property of Color');
  FRenderColor.Init(0,1,0);
  FrmDisplayTestColor.Color2 := FRenderColor;
  CheckEquals(0.0,FRenderColor.Red,1e-15,'Red Property of Color2');
  CheckEquals(1.0,FRenderColor.Green,1e-15,'Green Property of Color2');
  CheckEquals(0.0,FRenderColor.Blue,1e-15,'Blue Property of Color2');
  FRenderColor.Init(0,0,1);
  FrmDisplayTestColor.Color3 := FRenderColor;
  CheckEquals(0.0,FRenderColor.Red,1e-15,'Red Property of Color3');
  CheckEquals(0.0,FRenderColor.Green,1e-15,'Green Property of Color3');
  CheckEquals(1.0,FRenderColor.Blue,1e-15,'Blue Property of Color3');
  FrmDisplayTestColor.UpdateDisplay;
  sleep(100);
  for i := 0 to 1000 do
    begin
      lRed:=(1000-i) / 1000;
      case i mod 3 of
      0:FRenderColor.Init(lRed,0.0,0.0);
      1:FRenderColor.Init(0.0,lRed,0.0);
      2:FRenderColor.Init(0.0,0.0,lRed);
      end;
      case i mod 3 of
      0:  FrmDisplayTestColor.Color2 := FRenderColor;
      1:  FrmDisplayTestColor.Color3 := FRenderColor;
      2:  FrmDisplayTestColor.Color1 := FRenderColor;
      End;
      if i mod 10 = 0 then
         begin
      FrmDisplayTestColor.Faktor:=lRed;
      FrmDisplayTestColor.UpdateDisplay;
      sleep(1)
         end;
    end;
  for i := 0 to 10000 do
    begin
      lRed:=random;
      lGreen:=random;
      lBlue:=random;
      FRenderColor.Init(lRed,lGreen,lBlue);
      case i mod 3 of
      0:  FrmDisplayTestColor.Color2 := FRenderColor;
      1:  FrmDisplayTestColor.Color3 := FRenderColor;
      2:  FrmDisplayTestColor.Color1 := FRenderColor;
      End;
      CheckEquals(lRed,FRenderColor.Red,1e-15,format('Red Property of Color[%u]',[i]));
      CheckEquals(lGreen,FRenderColor.Green,1e-15,format('Red Property of Color[%u]',[i]));
      CheckEquals(lBlue,FRenderColor.Blue,1e-15,format('Red Property of Color[%u]',[i]));
      if i mod 100 = 0 then
         begin
      FrmDisplayTestColor.Faktor:=i/10000;
      FrmDisplayTestColor.UpdateDisplay;
      sleep(1)
         end;
    end;
end;

procedure TTestRenderColor.TestInitHue;
var
  i: Integer;
  lHue, lSatur, lBright: Extended;
begin
  FRenderColor.InitHSB(0,1,0.5);
  FrmDisplayTestColor.Color1 := FRenderColor;
  CheckEquals(1.0,FRenderColor.Red,1e-15,'Red Property of Color');
  CheckEquals(0.25,FRenderColor.Green,1e-15,'Green Property of Color');
  CheckEquals(0.25,FRenderColor.Blue,1e-15,'Blue Property of Color');
  FRenderColor.InitHSB(1/3,1,0.5);
  FrmDisplayTestColor.Color2 := FRenderColor;
  CheckEquals(0.25,FRenderColor.Red,1e-15,'Red Property of Color2');
  CheckEquals(1.0,FRenderColor.Green,1e-15,'Green Property of Color2');
  CheckEquals(0.25,FRenderColor.Blue,1e-15,'Blue Property of Color2');
  FRenderColor.InitHSB(2/3,1,0.5);
  FrmDisplayTestColor.Color3 := FRenderColor;
  CheckEquals(0.25,FRenderColor.Red,1e-15,'Red Property of Color3');
  CheckEquals(0.25,FRenderColor.Green,1e-15,'Green Property of Color3');
  CheckEquals(1.0,FRenderColor.Blue,1e-15,'Blue Property of Color3');
  FrmDisplayTestColor.UpdateDisplay;
  sleep(100);
  for i := 0 to 10000 do
    begin
      lHue:=(10000-i) / 10000;
      case i mod 3 of
      0:FRenderColor.InitHSB(lHue,1.0,0.5);
      1:FRenderColor.InitHSB(0.5,lHue,0.5);
      2:FRenderColor.InitHSB(0.0,0.0,lHue);
      end;
      case i mod 3 of
      0:  FrmDisplayTestColor.Color2 := FRenderColor;
      1:  FrmDisplayTestColor.Color3 := FRenderColor;
      2:  FrmDisplayTestColor.Color1 := FRenderColor;
      End;
      if i mod 10 = 0 then
         begin
      FrmDisplayTestColor.Faktor:=lHue;
      FrmDisplayTestColor.UpdateDisplay;
      sleep(1)
         end;
    end;
  for i := 0 to 10000 do
    begin
      lHue:=sin(i*pi/300)*0.5+0.5;
      lSatur:=sin(i*pi/1000)*0.5+0.5;
      lBright:=sin(i*pi/5000)*0.5+0.5;
      FRenderColor.InitHSB(lHue,lSatur,lBright);
      case i mod 3 of
      0:  FrmDisplayTestColor.Color2 := FRenderColor;
      1:  FrmDisplayTestColor.Color3 := FRenderColor;
      2:  FrmDisplayTestColor.Color1 := FRenderColor;
      End;
      {
      CheckEquals(lHue,FRenderColor.Red,1e-15,format('Red Property of Color[%u]',[i]));
      CheckEquals(lSatur,FRenderColor.Green,1e-15,format('Red Property of Color[%u]',[i]));
      CheckEquals(lBright,FRenderColor.Blue,1e-15,format('Red Property of Color[%u]',[i]));}
      if i mod 10 = 0 then
         begin
      FrmDisplayTestColor.Faktor:=i/10000;
      FrmDisplayTestColor.UpdateDisplay;
      sleep(1)
         end;
    end;
end;

procedure TTestRenderColor.SetUp;
begin
  if not assigned(FrmDisplayTestColor) then
     Application.CreateForm(TFrmDisplayTestColor,FrmDisplayTestColor);
  FrmDisplayTestColor.show;
  FrmDisplayTestColor.Title:= TestName;
end;

procedure TTestRenderColor.TearDown;
begin
  FrmDisplayTestColor.hide;
end;

initialization

  RegisterTest(TTestRenderColor);
end.

