unit tst_GrueStew;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$EndIF}


interface

uses
  Classes, SysUtils, {$IFNDEF FPC}TestFramework, {$Else} fpcunit, testutils, testregistry, {$endif}unt_GrueStewBase, cls_GrueStewEng;

type
  TGrueStewTestEng=Class(TGrueStewEng)
    public
      Property Room[index:integer]:TRoom read GetRoom;
      Property RoomCount:integer read GetRoomCount;
      Property rExit;
      Property rGrue;
      Property rBat1;
      Property rBat2;
      Property rPit1;
      Property rPit2;
  end;

  { TTestGrueStew }

  TTestGrueStew= class(TTestCase)
  private
    FGrueStew: TGrueStewTestEng;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    PRocedure CheckEquals(exp,Act:TMoveResult;Msg:String);overload;
    PRocedure CheckEquals(exp,Act:TShootResult;Msg:String);overload;
  published
    procedure TestSetUp;
    Procedure TestInits;
    procedure TestInitPlayer;
    procedure TestNewGame;
    procedure TestFirstMove;
    procedure TestFirstShoot;
  end;

implementation

procedure TTestGrueStew.TestSetUp;
begin
  CheckNotNull(FGrueStew,'FGrueStew has to be Assigned');
  CheckEquals(true,FGrueStew.HasEnded,'FGrueStew.HasEnded');
  CheckEquals(false,FGrueStew.KilledMonster,'FGrueStew.KilledMonster');
  CheckEquals(0,FGrueStew.RoomCount,'FGrueStew.RoomCount');
  CheckEquals(0,FGrueStew.ActRoom,'FGrueStew.ActRoom');
  CheckEquals(0,FGrueStew.Step,'FGrueStew.ActRoom');
  ChecknotEquals('',FGrueStew.GetDescription,'FGrueStew.GetDescription');
end;

procedure TTestGrueStew.TestInits;
var
  i, lMax, j: Integer;
  dir: TDir;
begin
  RandSeed:=0;
  FGrueStew.InitLaby;
  CheckEquals(false,FGrueStew.HasEnded,'FGrueStew.HasEnded');
  CheckEquals(false,FGrueStew.KilledMonster,'FGrueStew.KilledMonster');
  CheckEquals(20,FGrueStew.RoomCount,'FGrueStew.RoomCount');
  CheckEquals(0,FGrueStew.ActRoom,'FGrueStew.ActRoom');
  CheckEquals(0,FGrueStew.Step,'FGrueStew.ActRoom');
  lMax:=0;
  for i := 1 to 20 do
    begin
      CheckEquals(i,FGrueStew.Room[i].ID,'Room['+inttostr(i)+'].ID');
      CheckNotEquals(0,FGrueStew.Room[i].Reachable,'Room['+inttostr(i)+'].reachable <> 0');
      if lMax<FGrueStew.Room[i].Reachable then
        lMax:=FGrueStew.Room[i].Reachable;
      CheckNotEquals('',FGrueStew.Room[i].Desc,'Room['+inttostr(i)+'].description not empty');
      CheckEquals(false,FGrueStew.Room[i].MappedR,'Room['+inttostr(i)+'].MappedR');
      for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
        begin
          CheckEquals(false,FGrueStew.Room[i].MappedT[dir],'Room['+inttostr(i)+'].MappedT['+CDirDesc[dir]+']');
          CheckNotEquals(i,FGrueStew.Room[i].Transition[dir],'Room['+inttostr(i)+'].Transition['+CDirDesc[dir]+']');
        end;
    end;
  Check(lMax>3,'Maximale Erreibarkeit > 3');
  for j := 1 to 5000 do
    begin
      RandSeed:=j;
      FGrueStew.InitLaby;
      CheckEquals(false,FGrueStew.HasEnded,'['+inttostr(j)+']FGrueStew.HasEnded');
      CheckEquals(false,FGrueStew.KilledMonster,'['+inttostr(j)+']FGrueStew.KilledMonster');
      CheckEquals(20,FGrueStew.RoomCount,'['+inttostr(j)+']FGrueStew.RoomCount');
      CheckEquals(0,FGrueStew.ActRoom,'['+inttostr(j)+']FGrueStew.ActRoom');
      CheckEquals(0,FGrueStew.Step,'['+inttostr(j)+']FGrueStew.ActRoom');
      lMax:=0;
      for i := 1 to 20 do
        begin
          CheckEquals(i,FGrueStew.Room[i].ID,'['+inttostr(j)+']Room['+inttostr(i)+'].ID');
          CheckNotEquals(0,FGrueStew.Room[i].Reachable,'['+inttostr(j)+']Room['+inttostr(i)+'].reachable <> 0');
          if lMax<FGrueStew.Room[i].Reachable then
            lMax:=FGrueStew.Room[i].Reachable;
          CheckNotEquals('',FGrueStew.Room[i].Desc,'['+inttostr(j)+']Room['+inttostr(i)+'].description not empty');
          CheckEquals(false,FGrueStew.Room[i].MappedR,'['+inttostr(j)+']Room['+inttostr(i)+'].MappedR');
          for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
            begin
              CheckEquals(false,FGrueStew.Room[i].MappedT[dir],'['+inttostr(j)+']Room['+inttostr(i)+'].MappedT['+CDirDesc[dir]+']');
              CheckNotEquals(i,FGrueStew.Room[i].Transition[dir],'['+inttostr(j)+']Room['+inttostr(i)+'].Transition['+CDirDesc[dir]+']');
            end;
        end;
      Check(lMax>3,'['+inttostr(j)+']Maximale Erreibarkeit > 3');
    end;

end;

procedure TTestGrueStew.TestInitPlayer;
var
  dir: TDir;
begin
  RandSeed:=0;
  FGrueStew.InitLaby;
  FGrueStew.InitPlayer;
  CheckNotEquals(0,FGrueStew.ActRoom,'ActRoom <> 0');
  CheckEquals(true,FGrueStew.Room[-1].MappedR,'Room[-1].MappedR');
  CheckEquals(0,FGrueStew.Step,'ActRoom');
  CheckEquals({$IFDEF FPC}8{$ELSE}13{$ENDIF},FGrueStew.ActRoom,'ActRoom');
  for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
    CheckEquals(0,FGrueStew.Map[dir],'Map['+CDirDesc[dir]+']');
end;

procedure TTestGrueStew.TestNewGame;
var
  dir: TDir;
  j: Integer;

const Exp:array[1..10] of integer =
  {$IFDEF FPC}(6,1,6,6,18,5,18,14,18,14)
  {$ELSE}(6,0,0,0,0,0,0,0,0,0)
  {$ENDIF};
begin
  RandSeed:=0;
  FGrueStew.NewGame;
  CheckNotEquals(0,FGrueStew.ActRoom,'ActRoom <> 0');
  CheckEquals(true,FGrueStew.Room[-1].MappedR,'Room[-1].MappedR');
  CheckEquals(0,FGrueStew.Step,'ActRoom');
  CheckEquals({$IFDEF FPC}8{$ELSE}13{$ENDIF},FGrueStew.ActRoom,'ActRoom');
  for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
    CheckEquals(0,FGrueStew.Map[dir],'Map['+CDirDesc[dir]+']');
  CheckNotEquals('',FGrueStew.RoomDesc,'RoomDesc not empty');
  for j := 1 to 10 do
    begin
      RandSeed:=j;
      FGrueStew.NewGame;
      CheckNotEquals(0,FGrueStew.ActRoom,'['+inttostr(j)+']ActRoom <> 0');
      CheckEquals(true,FGrueStew.Room[-1].MappedR,'['+inttostr(j)+']Room[-1].MappedR');
      CheckEquals(0,FGrueStew.Step,'['+inttostr(j)+']ActRoom');
      CheckEquals(Exp[j],FGrueStew.ActRoom,'['+inttostr(j)+']ActRoom');
      for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
        CheckEquals(0,FGrueStew.Map[dir],'['+inttostr(j)+']Map['+CDirDesc[dir]+']');
      CheckNotEquals('',FGrueStew.RoomDesc,'['+inttostr(j)+']RoomDesc not empty');
    end;
end;

procedure TTestGrueStew.TestFirstMove;
begin
 RandSeed:=0;
 FGrueStew.NewGame;
 CheckNotEquals(0,FGrueStew.ActRoom,'ActRoom <> 0');
 CheckEquals({$IFDEF FPC}8{$ELSE}13{$ENDIF},FGrueStew.ActRoom,'ActRoom');
 CheckEquals(mvOK,FGrueStew.Move(drNorth),'Move(drNorth)');
 ChecknotEquals({$IFDEF FPC}8{$ELSE}13{$ENDIF},FGrueStew.ActRoom,'ActRoom');
end;

procedure TTestGrueStew.TestFirstShoot;
begin
 RandSeed:=0;
 FGrueStew.NewGame;
 CheckNotEquals(0,FGrueStew.ActRoom,'ActRoom <> 0');
 CheckEquals({$IFDEF FPC}8{$ELSE}13{$ENDIF},FGrueStew.ActRoom,'ActRoom');
 CheckEquals(shMiss,FGrueStew.Shoot(drNorth),'Shoot(drNorth)');
 CheckEquals(shMiss,FGrueStew.Shoot(drSouth),'Shoot(drSouth)');
end;

procedure TTestGrueStew.SetUp;
begin
  FGrueStew:= TGrueStewTestEng.create;
end;

procedure TTestGrueStew.TearDown;
begin
  FreeandNil(FGrueStew);
 {$IFDEF FPC}CheckNotEquals(0,AssertCount,'Some Tests have to Called');{$ENDIF}
end;

procedure TTestGrueStew.CheckEquals(exp, Act: TMoveResult; Msg: String);
begin
  AssertEquals(Msg,CMoveResult[exp],CMoveResult[Act]);
end;

procedure TTestGrueStew.CheckEquals(exp, Act: TShootResult; Msg: String);
begin
  AssertEquals(Msg,CShootResult[exp],CShootResult[Act]);
end;

initialization

  RegisterTest(TTestGrueStew{$IFNDEF FPC}.Suite{$endif});
end.

