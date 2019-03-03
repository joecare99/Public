unit testWernerEng;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, {$IFDEF FPC}fpcunit, testutils, testregistry,{$else}testframework,{$ENDIF}
  WernerEng;

type

  { TTestWernerEng1 }

  TTestWernerEng1= class(TTestCase)
  Private
    FWernerEng:TWernerEng;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestBasics;
    procedure TestFirstLevel;
    procedure Test2ndLevel;
    procedure Test3rdLevel;
    procedure Test4thLevel;
    procedure Test5thLevel;
    procedure Test6thLevel;
  end;

implementation

uses werner_levdefc,Frm_WernerShowGrid;

procedure TTestWernerEng1.TestBasics;

begin
  FWernerEng.InitLevel;
  FrmWernerShowGrid.BildData := FWernerEng.BildData;
  CheckTrue(FWernerEng.AmLeben,'Werner ist am leben');
  CheckFalse(FWernerEng.nxl,'Im Level');
  CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig');
  CheckEquals(99,FWernerEng.TimeLeft,'noch 99s übrig');
  CheckEquals(4,FWernerEng.BildData[1,9],'Werner steht auf pos (1,9)');
  FWernerEng.playerDir:=wpd_Up;
  FWernerEng.GameStep;
  CheckTrue(FWernerEng.AmLeben,'Werner ist am leben');
  CheckFalse(FWernerEng.nxl,'Im Level');
  CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig');
  CheckEquals(4,FWernerEng.BildData[1,8],'Werner steht auf pos (1,8)');
  CheckEquals(0,FWernerEng.BildData[1,9],'pos(1,9) ist jetzt leer');
  FWernerEng.playerDir:=wpd_right;
  FWernerEng.GameStep;
  CheckTrue(FWernerEng.AmLeben,'Werner ist am leben');
  CheckFalse(FWernerEng.nxl,'Im Level');
  CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig');
  CheckEquals(4,FWernerEng.BildData[2,8],'Werner steht auf pos (2,8)');
  CheckEquals(0,FWernerEng.BildData[1,8],'pos(1,8) ist jetzt leer');
  FWernerEng.playerDir:=wpd_down;
  FWernerEng.GameStep;
  CheckTrue(FWernerEng.AmLeben,'Werner ist am leben');
  CheckFalse(FWernerEng.nxl,'Im Level');
  CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig');
  CheckEquals(4,FWernerEng.BildData[2,9],'Werner steht auf pos (2,9)');
  CheckEquals(0,FWernerEng.BildData[2,8],'pos(2,8) ist jetzt leer');
  FWernerEng.playerDir:=wpd_left;
  FWernerEng.GameStep;
  CheckTrue(FWernerEng.AmLeben,'Werner ist am leben');
  CheckFalse(FWernerEng.nxl,'Im Level');
  CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig');
  CheckEquals(4,FWernerEng.BildData[1,9],'Werner steht auf pos (1,9)');
  CheckEquals(0,FWernerEng.BildData[2,9],'pos(2,9) ist jetzt leer');
  FWernerEng.playerDir:=wpd_left;
  FWernerEng.GameStep;
  CheckTrue(FWernerEng.AmLeben,'Werner ist am leben');
  CheckFalse(FWernerEng.nxl,'Im Level');
  CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig');
  CheckEquals(4,FWernerEng.BildData[1,9],'Werner steht noch auf pos (1,9)');
  CheckEquals(2,FWernerEng.BildData[0,9],'pos(0,9) ist eine Wand');
  FrmWernerShowGrid.BildData := FWernerEng.BildData;

end;

procedure TTestWernerEng1.TestFirstLevel;
const Go='kllllijjjjilllikljjjjjjjjllliiilllkiilllllllkklllliiijjjiilllllklkkjkkl'+
  'kkjjjjjjkjjkjjijkilliii';
var
  Step: Integer;
begin
  Step := 0;
  FWernerEng.InitLevel;
  while step < length(go) do
    begin
      inc(step);
      case go[step] of
      'i':FWernerEng.playerDir:=wpd_Up;
      'j':FWernerEng.playerDir:=wpd_Left;
      'k':FWernerEng.playerDir:=wpd_Down;
      'l':FWernerEng.playerDir:=wpd_right
      else
         FWernerEng.playerDir:=wpd_NoMove;
      end;
      FWernerEng.GameStep;
       FrmWernerShowGrid.BildData := FWernerEng.BildData;
       CheckTrue(FWernerEng.AmLeben,'Werner ist am leben, Level1 Step:'+inttostr(step));
       if step < length(go) then
         CheckFalse(FWernerEng.nxl,'Im Level, Level1 Step:'+inttostr(step));
       CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig, Level1 Step:'+inttostr(step));
    end;
   CheckTrue(FWernerEng.nxl,'Next Level, Level1 Step:'+inttostr(step));
  FrmWernerShowGrid.BildData := FWernerEng.BildData;
end;

procedure TTestWernerEng1.Test2ndLevel;
const Go='iiiliii  iiij';
var
  Step: Integer;
begin
  Step := 0;
  FWernerEng.level := 2;
  FWernerEng.InitLevel;
  while step < length(go) do
    begin
      inc(step);
      case go[step] of
      'i':FWernerEng.playerDir:=wpd_Up;
      'j':FWernerEng.playerDir:=wpd_Left;
      'k':FWernerEng.playerDir:=wpd_Down;
      'l':FWernerEng.playerDir:=wpd_right
      else
         FWernerEng.playerDir:=wpd_NoMove;
      end;
      FWernerEng.GameStep;
       FrmWernerShowGrid.BildData := FWernerEng.BildData;
       CheckTrue(FWernerEng.AmLeben,'Werner ist am leben, Level2 Step:'+inttostr(step));
       if step < length(go) then
         CheckFalse(FWernerEng.nxl,'Im Level, Level2 Step:'+inttostr(step));
       CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig, Level2 Step:'+inttostr(step));
    end;
   CheckTrue(FWernerEng.nxl,'Next Level, Level2 Step:'+inttostr(step));
  FrmWernerShowGrid.BildData := FWernerEng.BildData;
end;

procedure TTestWernerEng1.Test3rdLevel;
const Go='jkklllllllij llllkkkliljjiiiijijjjjljjjkj';
var
  Step: Integer;
begin
  Step := 0;
  FWernerEng.level := 3;
  FWernerEng.InitLevel;
  while step < length(go) do
    begin
      inc(step);
      case go[step] of
      'i':FWernerEng.playerDir:=wpd_Up;
      'j':FWernerEng.playerDir:=wpd_Left;
      'k':FWernerEng.playerDir:=wpd_Down;
      'l':FWernerEng.playerDir:=wpd_right
      else
         FWernerEng.playerDir:=wpd_NoMove;
      end;
      FWernerEng.GameStep;
       FrmWernerShowGrid.BildData := FWernerEng.BildData;
       CheckTrue(FWernerEng.AmLeben,'Werner ist am leben, Level3 Step:'+inttostr(step));
       if step < length(go) then
         CheckFalse(FWernerEng.nxl,'Im Level, Level3 Step:'+inttostr(step));
       CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig, Level3 Step:'+inttostr(step));
    end;
  CheckTrue(FWernerEng.nxl,'Next Level, Level3 Step:'+inttostr(step));
  FrmWernerShowGrid.BildData := FWernerEng.BildData;
end;

procedure TTestWernerEng1.Test4thLevel;
const Go='lllkkkkkk kkklllllllliiiiiiiiilllllklkkjkklkkjjkk';
var
  Step: Integer;
begin
  Step := 0;
  FWernerEng.level := 4;
  FWernerEng.InitLevel;
  while step < length(go) do
    begin
      inc(step);
      case go[step] of
      'i':FWernerEng.playerDir:=wpd_Up;
      'j':FWernerEng.playerDir:=wpd_Left;
      'k':FWernerEng.playerDir:=wpd_Down;
      'l':FWernerEng.playerDir:=wpd_right
      else
         FWernerEng.playerDir:=wpd_NoMove;
      end;
      FWernerEng.GameStep;
       FrmWernerShowGrid.BildData := FWernerEng.BildData;
       CheckTrue(FWernerEng.AmLeben,'Werner ist am leben, Level4 Step:'+inttostr(step));
       if step < length(go) then
         CheckFalse(FWernerEng.nxl,'Im Level, Level4 Step:'+inttostr(step));
       CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig, Level4 Step:'+inttostr(step));
    end;
  CheckTrue(FWernerEng.nxl,'Next Level, Level4 Step:'+inttostr(step));
  FrmWernerShowGrid.BildData := FWernerEng.BildData;
end;

procedure TTestWernerEng1.Test5thLevel;
const Go='    liijjiillllllllllkkkklllllliiiiiiiiijjjjjjjjjjjjjkkkjjjj';
var
  Step: Integer;
begin
  Step := 0;
  FWernerEng.level := 5;
  FWernerEng.InitLevel;
  while step < length(go) do
    begin
      inc(step);
      case go[step] of
      'i':FWernerEng.playerDir:=wpd_Up;
      'j':FWernerEng.playerDir:=wpd_Left;
      'k':FWernerEng.playerDir:=wpd_Down;
      'l':FWernerEng.playerDir:=wpd_right
      else
         FWernerEng.playerDir:=wpd_NoMove;
      end;
      FWernerEng.GameStep;
       FrmWernerShowGrid.BildData := FWernerEng.BildData;
       CheckTrue(FWernerEng.AmLeben,'Werner ist am leben, Level5 Step:'+inttostr(step));
       if step < length(go) then
         CheckFalse(FWernerEng.nxl,'Im Level, Level5 Step:'+inttostr(step));
       CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig, Level5 Step:'+inttostr(step));
    end;
  CheckTrue(FWernerEng.nxl,'Next Level, Level5 Step:'+inttostr(step));
  FrmWernerShowGrid.BildData := FWernerEng.BildData;
end;

procedure TTestWernerEng1.Test6thLevel;
const Go='iiiiiiiiilllllllllllllllllkkkkkkkkkjjjjjjjj';
var
  Step: Integer;
begin
  Step := 0;
  FWernerEng.level := 6;
  FWernerEng.InitLevel;
  while step < length(go) do
    begin
      inc(step);
      case go[step] of
      'i':FWernerEng.playerDir:=wpd_Up;
      'j':FWernerEng.playerDir:=wpd_Left;
      'k':FWernerEng.playerDir:=wpd_Down;
      'l':FWernerEng.playerDir:=wpd_right
      else
         FWernerEng.playerDir:=wpd_NoMove;
      end;
      FWernerEng.GameStep;
       FrmWernerShowGrid.BildData := FWernerEng.BildData;
       CheckTrue(FWernerEng.AmLeben,'Werner ist am leben, Level6 Step:'+inttostr(step));
       if step < length(go) then
         CheckFalse(FWernerEng.nxl,'Im Level, Level6 Step:'+inttostr(step));
       CheckEquals(10,FWernerEng.leb,'noch 10 Leben übrig, Level6 Step:'+inttostr(step));
    end;
  CheckTrue(FWernerEng.nxl,'Next Level, Level6 Step:'+inttostr(step));
  FrmWernerShowGrid.BildData := FWernerEng.BildData;
end;


procedure TTestWernerEng1.SetUp;
begin
  FWernerEng:= TWernerEng.Create(10,maxbild,GetLevDef);
  if not FrmWernerShowGrid.Visible then
  FrmWernerShowGrid.Show;
end;

procedure TTestWernerEng1.TearDown;
begin
  freeandnil(FWernerEng);
end;

initialization

  RegisterTest(TTestWernerEng1{$ifndef FPC}.Suite{$endif});
end.

