unit cls_CrtBaseGameHMI;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
  Classes,
  SysUtils,
  Cls_GameBase,
  int_GameHMI,
  Win32crt;

type

{ CrtBaseGameHMI }

  CrtBaseGameHMI=class(TComponent,iHMI)
    private
    FPlayerActionEvent : TPlayerActionEvent;
    protected
    PROCEDURE SetOnPlayerAction(val: TPlayerActionEvent);
    FUNCTION GetOnPlayerAction(): TPlayerActionEvent;
    /// <associates>TPlayerAction</associates>
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>04.10.2012</since>
    PROPERTY OnPlayerAction: TPlayerActionEvent READ GetOnPlayerAction WRITE SetOnPlayerAction;
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>17.12.2014</since>
    /// <info>Initialisiert HMI</info>
    PROCEDURE InitHMI;
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>04.10.2012</since>
    /// <info>Zeichnet das Spielfeld (neu) </info>
    PROCEDURE UpdatePlayfield(Board: TBoardBase; Player: TPlayerBase);
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>04.10.2012</since>
    /// <info>Schreibt Spieler-Status </info>
    PROCEDURE UpdateStatus(Player:TPlayerBase);
  end;

implementation

uses Unt_GameBase;

{ CrtBaseGameHMI }

procedure CrtBaseGameHMI.SetOnPlayerAction(val: TPlayerActionEvent);
begin
//  if val=FPlayerActionEvent then exit
  FPlayerActionEvent := val;
end;

function CrtBaseGameHMI.GetOnPlayerAction: TPlayerActionEvent;
begin
  result := FPlayerActionEvent;
end;

procedure CrtBaseGameHMI.InitHMI;
var
  i: Integer;
begin
  SetTitle('Demo: Game-HMI-Crt');
  TextMode(co80+font8x8);
  Console.FillConsole(' ');
  // Header
  console.GotoXY(1,1);
  Write('#'+StringOfChar('=',78)+'#');
   console.GotoXY(1,2);
  Write('['+StringOfChar(' ',78)+']');
   console.GotoXY(1,3);
  Write('#'+StringOfChar('=',78)+'#');
  // playfield & Extra
  console.GotoXY(1,4);
  Write('#'+StringOfChar('=',58)+'#'+StringOfChar('=',19)+'#');
  for i := 4 to 41 do
   begin
     console.GotoXY(1,i+1);
   if i mod 2=0 then
   Write('['+StringOfChar(' ',58)+'!'+StringOfChar(' ',19)+']') else
   Write(']'+StringOfChar(' ',58)+'$'+StringOfChar(' ',19)+'[');

   end;
  console.GotoXY(1,43);
  Write('#'+StringOfChar('=',58)+'#'+StringOfChar('=',19)+'#');
   // Status
  for i := 43 to 48 do
   begin
   console.GotoXY(1,i+1);
   Write('!'+StringOfChar(' ',78)+'!');

   end;
  console.GotoXY(1,50);
  Write('+'+StringOfChar('-',78)+'+');
end;

procedure CrtBaseGameHMI.UpdatePlayfield(Board: TBoardBase; Player: TPlayerBase
  );
begin
  console.GotoXY(2,4);
end;

procedure CrtBaseGameHMI.UpdateStatus(Player: TPlayerBase);
begin
  console.GotoXY(2,43);
  write(format(' (%d;%d)',[Player.GetXKoor,Player.GetYKoor]));
end;

var HMIClass:CrtBaseGameHMI;

initialization
  HMIClass := CrtBaseGameHMI.Create(nil);
  Unt_GameBase.HMI:=HMIClass;
finalization;
  Unt_GameBase.hmi := nil;
  freeandnil(HMIClass);
end.

