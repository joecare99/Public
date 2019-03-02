unit con_GrueStew;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$EndIF}

interface

uses
  Classes, SysUtils,CustApp, cls_GrueStewEng;

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  private
    FGrueStew:TGrueStewEng;
    procedure DoMove(ch:char);
    procedure DoShoot(ch:char);
    procedure InitScreen;
    procedure UpdateScreen(Delay:boolean=true);
    Procedure Writeln(st:string='';Delay:boolean=true);
  protected
    procedure DoRun; override;
    Procedure WriteMinimap;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

var
  Application: TMyApplication;

implementation

uses unt_GrueStewBase{$IFDEF FPC},crt{$ELSE},win32crt{$EndIF};

{ TMyApplication }

procedure TMyApplication.DoMove(ch:char);
var
  lDir: TDir;
  lMResult: TMoveResult;
  i: Integer;
begin
     lDir := TDir(pos(upcase(ch), 'NOSW')-1);
     lMResult:= FGrueStew.move(lDir);
     case lMResult of
       mvOK:  begin
                UpdateScreen;
              end;
       mvWall: begin
                UpdateScreen(false);
                Writeln(ITryMove[lDir]);
                writeln(CantMoveThere);
              end;
       mvExit: begin
                UpdateScreen(false);
                writeln(ReachedExit);
              end;
       mvExitwMonst:  begin
                UpdateScreen(false);
                writeln(ReachedExitwM);
              end;
       mvMonster:  begin
                UpdateScreen(false);
                Beep;
                writeln(CaughtBYMonster);
              end;
       mvPit:  begin
                UpdateScreen(false);
                Beep;
                writeln(FellIntoPit);
              end;
       mvBat:  begin
                writeln(BatCatchYou);
                Beep;
                for i := 1 to 20 do
                  begin
                    write('.');
                    sleep(100);
                  end;
                UpdateScreen;
              end;
       mvEarthquake:begin
                writeln(EQuake);
                Beep;
                for i := 1 to 20 do
                  begin
                    write('.');
                    sleep(100);
                  end;
                UpdateScreen;
              end ;
     end;
end;

procedure TMyApplication.DoShoot(ch: char);
var
  lDir: TDir;
  lSResult: TShootResult;
  i: Integer;
begin
  lDir := TDir(pos(upcase(ch), 'NOSW')-1);
  lSResult:= FGrueStew.Shoot(lDir);
  if lSResult <> shEarthquake then
    UpdateScreen(false);
  Writeln(IShoot[lDir]);
  case lSResult of
    shHit: writeln(HitMonster);
    shWall:writeln(HitWall) ;
    shMiss: writeln(NoHit1);
    shMiss2:writeln(NoHit2) ;
    shMiss3: writeln(NoHit3);
    shEarthquake:begin
                writeln(EQuake);
                Beep;
                for i := 1 to 20 do
                  begin
                    write('.');
                    sleep(100);
                  end;
                UpdateScreen;
              end  ;
  end;
end;

procedure TMyApplication.InitScreen;
var
  {%H-}ch: Char;
begin
  ClrScr;
  writeln(CHeader);
  writeln(FGrueStew.GetDescription);
  writeln;
  writeln(CPressAnyKey);
  {$IFDEF FPC}ch := ReadKey{$ELSE}readln(ch){$ENDIF};
end;

procedure TMyApplication.UpdateScreen(Delay: boolean);
begin
  clrscr;
  writeln(CHeader,false);
  writeln(FGrueStew.RoomDesc,delay);
  writeln('',delay);
  WriteMiniMap;
  writeln('',delay);
end;

procedure TMyApplication.Writeln(st: string;Delay:boolean );
var
  hPos, i: Integer;
  w: String;
begin
  if length(st)>2 then
    st := StringReplace(st,'#','',[rfReplaceAll]);

  hPos := 1;
  w := '';
  for i := 1 to length(st) do
    begin
      w := w + st[i];
      if st[i] in [' ','.',',','!',#10] then
        begin
          if hPos + Length(w) > 79 then
            begin
              system.writeln;
              hPos := 1;
              if delay then sleep (40)
            end;
       //   write(Utf8ToAnsi(w));
          Write(w);
          if st[i]<>#10 then hPos := hPos+length(Utf8ToAnsi(w))
            else hPos := 1;
          w := '';
          if delay then sleep(20);
          if delay and (st[i] in ['.',',','!',#10]) then
            sleep(100);
        end
    end;
  if hPos + Length(w) > 79 then
    begin
      system.writeln;
      hPos := 1;
    end;
//  system.WriteLn(Utf8ToAnsi(w));
  system.WriteLn(w);
end;

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
  ch: Char;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
  FGrueStew.NewGame;
  InitScreen;
  UpdateScreen;
  while not FGrueStew.HasEnded do
    begin
      Writeln(CAnweisung);
      {$IFDEF FPC}ch := ReadKey{$ELSE}readln(ch){$ENDIF};
      if ch in ['N','O','S','W'] then
        DoMove(ch)
      else if ch in ['n','o','s','w'] then
        DoShoot(ch)
      else if upCase(ch) = 'Q' then
        begin
          FGrueStew.GiveUp;
          break;
        end
      else if upCase(ch) = '?' then
        begin
          InitScreen;
          UpdateScreen;
        end;

    end;

  // Ergebniss anzeigen
  Writeln(CPressAnyKey);
  {$IFDEF FPC}ch := ReadKey{$ELSE}readln(ch){$ENDIF};
  // stop program loop
  Terminate;
end;

procedure TMyApplication.WriteMinimap;
begin
  Writeln(CMap,false);
  Write('   ');Writeln(RaumTxt2[FGrueStew.Map[drNorth]],false);
  writeln('',false);
  Write(RaumTxt2[FGrueStew.Map[drWest]]);
  Write(' ');
  Write(RaumTxt2[FGrueStew.ActRoom]);
  Write(' ');
  Writeln(RaumTxt2[FGrueStew.Map[drEast]],false);
  writeln('',false);
  Write('   ');Writeln(RaumTxt2[FGrueStew.Map[drSouth]],false);
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FGrueStew := TGrueStewEng.Create;
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: '+ ExeName  +' -h');
  writeln(FGrueStew.GetDescription);
end;


end.

