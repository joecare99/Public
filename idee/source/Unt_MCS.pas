unit Unt_MCS;

{$IFDEF FPC}
  {$MODE Delphi}{$H+}
{$ENDIF}

interface

uses Classes;

procedure Execute;

type
  pGedrueckt = ^TGedrueckt;

  TGedrueckt = record
    tast: byte;
    nae: pGedrueckt;
  end;

  { TMCS }

  TMCS = class
  private
    tastz: integer;
  public
    ZGedrueckt: pGedrueckt;
    constructor Create;
    procedure ConsoleKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ConsoleKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure Execute;
    procedure init;
    procedure pull(taste: byte);
    procedure push(taste: byte);
    procedure showst(x, y: byte);
  end;

implementation

uses
  sysutils,types, Win32Crt;

var
  MyMCS: TMCS;


procedure Execute;

begin
  MyMCS.init;
  MyMCs.Execute;
end;

const
  translate: array[0..127] of integer =
 {  0}   (0, 0, 0, 0, 0,         0, 0, 0, 14, 15,
 { 10}    0, 0, 76, 28, 0,         0, 42, 29, 56, 0,
 { 20}    58, 0, 0, 0, 0,         0, 0, 1, 0, 0,
 { 30}    0, 0, 57, 73, 81,         79, 71, 75, 72, 77,
 { 40}    80, 0, 0, 0, 0,         82, 83, 0, 11, 2,
 { 50}   3, 4, 5, 6, 7,          8, 9, 10, 26, 27,
 { 60}   51, 53, 52, 43, 39,         30 , 48, 46, 32, 18,
 { 70}   33, 34, 35, 23, 36,     37, 38, 50, 49, 24,
 { 80}   25, 16, 19, 31, 20,      22, 47, 17, 45, 44,
 { 90}   21, 12, 85, 13, 40,       0, 0, 0, 86, 0,
 {100}   0, 0, 0, 0, 0,          0, 55, 78, 0, 74,
 {110}   0, 124, 59, 60, 61,       62, 63, 64, 65, 66,
 {120}   67, 68, 87, 88, 0,      0, 56, 50);


  was: array[0..127] of WideString =
    ('', 'ESC ', ' 1 ', ' 2 ', ' 3 ',    ' 4 ', ' 5 ', ' 6 ', ' 7 ', ' 8 ',
    ' 9 ', ' 0 ', ' á ', ' '' ', ' <-    ', '->|  ', ' Q ', ' W ', ' E ', ' R ',
    ' T ', ' Z ', ' U ', ' I ', ' O ',   ' P ', ' š ', ' + ', '<-'' ','Strg ',
    ' A ', ' S ', ' D ', ' F ', ' G ',   ' H ', ' J ', ' K ', ' L ', ' ™ ',
    ' Ž ', ' ^ ', #32#30#32#32, ' # ', ' Y ', ' X ', ' C ', ' V ', ' B ', ' N ',
    ' M ', ' , ', ' . ', ' - ', #32#30#32#32#32#32#32, ' * ', ' Alt ', '       ', #32#31#32#32#32#32,
    'F1 ',
    'F2 ', 'F3 ', 'F4 ', 'F5 ', 'F6 ',   'F7 ', 'F8 ', 'F9 ', 'F10', 'Num',
    'Scr', ' 7 ', ' 8 ', ' 9 ', ' - ',   ' 4 ', ' 5 ', ' 6 ', ' + ', ' 1 ',
    ' 2 ', ' 3 ', ' 0     ', ' , ', '',  'Win', '> <', 'F11', 'F12', '',
    '', '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ' ö ',
    '<-''', 'Strg ', 'AltGr');
  wox: array[0..127] of byte =
    (0, 2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50,
    54, 2, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 57, 2, 9, 13,
    17, 21, 25, 29, 33, 37, 41, 45, 49, 2, 2, 53, 11, 15, 19, 23, 27, 31, 35,
    39, 43, 47, 51, 72, 8, 30, 2, 10, 14, 18, 22, 28, 32, 36, 40, 46, 50, 64,
    68, 64, 68, 72, 76, 64, 68, 72, 76, 64, 68, 72, 64, 72, 0, 52, 7, 54, 58,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 68, 76, 56, 46);
  woy: array[0..127] of byte =
    (0, 2, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
    6, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 14, 10, 10, 10, 10,
    10, 10, 10, 10, 10, 10, 10, 6, 12, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12,
    12, 12, 6, 14, 14, 10, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6, 2,
    8, 8, 8, 6, 10, 10, 10, 9, 12, 12, 12, 14, 14, 0, 14, 12, 2, 2, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 13, 14, 14);
  kbdLayout: array[0..14] of string = (
    '+----+  +---+---+---+---+ +---+---+---+---+ +---+---+---+---+ +---+---+---+',
    '|    |  |   |   |   |   | |   |   |   |   | |   |   |   |   | |   |   |   |',
    '+----+  +---+---+---+---+ +---+---+---+---+ +---+---+---+---+ +---+---+---+',
    '',
    '+---+---+---+---+---+---+---+---+---+---+---+---+---+-------+ +---+---+---+---+',
    '|   |   |   |   |   |   |   |   |   |   |   |   |   |       | |   |   |   |   |',
    '+---+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-----+ +---+---+---+---+',
    '|     |   |   |   |   |   |   |   |   |   |   |   |   |     | |   |   |   |   |',
    '+-----++--++--++--++--++--++--++--++--++--++--++--++--++    | +---+---+---+   |',
    '|      |   |   |   |   |   |   |   |   |   |   |   |   |    | |   |   |   |   |',
    '+----+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---+----+ +---+---+---+---+',
    '|    |   |   |   |   |   |   |   |   |   |   |   |          | |   |   |   |   |',
    '+----++--+--++---+---+---+---+---+---+---+--++---++---+-----+ +---+---+---+   |',
    '|     |     |                               |     |   |     | |       |   |   |',
    '+-----+-----+-------------------------------+-----+---+-----+ +-------+---+---+');


procedure TMCS.Execute;

var
  t: byte;
  ts: boolean;
  mouseel: Integer;
  mp: TPoint;
  mouseelnew: Integer;
  i: Integer;

begin
  mouseel := 0;
  repeat
    //    repeat
    while not keypressed do
    begin
    end;
    //    until tastpuf[tastz] <> 224;
    t := byte(readkey);
    if (t = 0) and keypressed then {scan}
      begin
        t:= byte(readkey);
        if (t = 0) and ((mp.x <> console.MousePos.x)or (mp.y <> console.MousePos.y)) then {2. Scan -> Mouse}
          begin
            mp := console.MousePos;
            mouseelnew := mouseel;
            if  (mouseel>0) and
                ((mp.y < woy[mouseel]-2) or
                (mp.y > woy[mouseel]) or
                (mp.x < wox[mouseel]-2) or
                (mp.x > wox[mouseel]+length(was[mouseel]))) then
               mouseelnew := 0;
            if mouseelnew = 0 then
            for i := 0 to 127 do
              if  (mp.y = woy[i]-1) and
                  (mp.x>=wox[i]-2) and
                  (mp.x<=wox[i]+length(was[i])-2) then
                  begin
                  mouseelnew := i;
                  break;
                  end;
            if mouseelnew <> mouseel then
              begin
                if mouseel > 0 then
                  begin
                  console.TextBackground(1);
                  console.TextColor(14);
                  Console.GotoXY(wox[mouseel],woy[mouseel]);
                  write(was[mouseel]);
                  end;
                mouseel := mouseelnew;
                if mouseel > 0 then
                begin
                console.TextBackground(2);
                console.TextColor(15);
                Console.GotoXY(wox[mouseel],woy[mouseel]);
                write(was[mouseel]);
                end;

              end;
                console.TextBackground(2);
                console.TextColor(15);
                Console.GotoXY(1,21);
                write('MP:('+inttostr(mp.x)+','+inttostr(mp.y)+') ,'+inttostr(mouseel)+' ,'+was[mouseel]);

          end;
      end;
   {
   DEC (tastz);
   ts:=false;
   if keypressed then
    if t= 224 then
     begin
      ts:=true;
      dec(tastz);
      case t mod 128 of
       56:t:=(t and 128) or 127;
       29:t:=(t and 128) or 126;
       28:t:=(t and 128) or 125;
       53:t:=(t and 128) or 124;
       end;
     end;
   if t >127 then
    begin
    pull (t mod 128);
     textcolor (14);
     textbackground (1)
    end
   else
      begin
       push (t mod 128);
       textcolor (14);
       textbackground (4);
      end;
      }

    textbackground(1);
    showst(1, 23);
    clreol;
    gotoxy(1, 1);
  until t = 129;
  exit;
  while keypressed do
    if readkey = '' then;
end;

{ TMCS }

procedure TMCS.ConsoleKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  t: Integer;
{$IFDEF FPC}
    sh: TShiftStateEnum;
{$ELSE}
   sh:TShiftState;

{$ENDIF}
begin
  t := translate[key mod 128];
  push(t);

  textcolor(14);
  textbackground(4);

  console.gotoxy(wox[t ], woy[t ]);
  Write(was[t]);

  console.gotoxy(2, 17);
  Write(key mod 128 );Write(key:4);Write(' ');
 {$IFNDEF FPC}   {$ELSE} for sh in Shift do
    write(inttostr(ord(sh))+' '); Write('  '); {$ENDIF}
   showst(1, 23);
end;

procedure TMCS.ConsoleKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
var
  t: Integer;
begin
   t := translate[key mod 128];
  pull(t);
  textcolor(14);
  textbackground(1);

  console.gotoxy(wox[t], woy[t]);
  Write(was[t]);

  showst(1, 23);ClrEol;
end;

constructor TMCS.Create;
begin
  inherited;
  Console.OnKeyDown := ConsoleKeyDown;
  Console.OnKeyUp := ConsoleKeyUp;

end;

procedure TMCS.init;

var
  i: byte;

begin
  textbackground(0);
  clrscr;
  textcolor(7);
  ZGedrueckt := nil;
  for I := 0 to High(kbdLayout) do
    writeln(kbdLayout[i]);
  writeln;
  textbackground(1);
  textcolor(14);
  for i := 0 to 127 do
    if wox[i] <> 0 then
    begin
      gotoxy(wox[i], woy[i]);
      Write(was[i]);
    end;
  tastz := 0;
end;

procedure TMCS.push(taste: byte);

var
  p: pGedrueckt;
  v: boolean;

begin
  v := True;
  p := ZGedrueckt;
  while p <> nil do
    if p^.tast = taste then
    begin
      p := nil;
      v := False;
    end
    else
      p := p^.nae;
  if v then
  begin
    new(p);
    p^.nae := ZGedrueckt;
    p^.tast := taste;
    ZGedrueckt := p;
  end;
end;

procedure TMCS.pull(taste: byte);

var
  p, v: pGedrueckt;

begin
  p := ZGedrueckt;
  v := nil;
  if p = nil then
    exit;
  while p <> nil do
    if p^.tast <> taste then
    begin
      v := p;
      p := p^.nae;
    end
    else
      p := nil;
  if v = nil then
  begin
    p := ZGedrueckt;
    ZGedrueckt := p^.nae;
    dispose(p);
  end
  else
  if v^.nae <> p then
  begin
    p := v^.nae;
    v^.nae := p^.nae;
    dispose(p);
  end;
end;

procedure TMCS.showst(x, y: byte);

var
  p: pGedrueckt;

begin
  gotoxy(x, y);
  p := ZGedrueckt;
  while p <> nil do
  begin
    Write(was[p^.tast], '|');
    p := p^.nae;
  end;
end;

initialization
  MyMCS := TMCS.Create;

finalization
  FreeAndNil(MyMCS);
end.
