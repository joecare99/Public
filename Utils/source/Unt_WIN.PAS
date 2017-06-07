
{*******************************************************}
{                                                       }
{       Turbo Pascal Version 5.5                        }
{       Window Interface Unit                           }
{                                                       }
{       Copyright (C) 1989 Borland International        }
{       Updatet to Use Win32Crt & Delphi                }
{*******************************************************}

unit Unt_WIN;

{$D-,S-}

interface

uses win32Crt;

type

{ Window title string }

  TitleStr = string[63];

{ Window frame characters }

  FrameChars = array[1..8] of Char;

{ Window state record }

  WinState = record
    WindMin, WindMax: Word;
    WhereX, WhereY: Byte;
    TextAttr: Byte;
  end;

var

{ Standard frame character sets }

  SingleFrame: FrameChars = 'ÚÄ¿³³ÀÄÙ';
  DoubleFrame: FrameChars = 'ÉÍ»ººÈÍ¼';

{ Direct write routines }

procedure WriteStr(X, Y: Byte; S: String; Attr: Byte);
procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);

{ Window handling routines }

Procedure Window(X1,y1,x2,y2:Integer);
procedure FillWin(Ch: Char; Attr: Byte);
procedure ReadWin(var Buf);
procedure WriteWin(var Buf);
function WinSize: Word;
procedure SaveWin(var W: WinState);
procedure RestoreWin(var W: WinState);
procedure FrameWin(Title: TitleStr; var Frame: FrameChars;
  TitleAttr, FrameAttr: Byte);
procedure UnFrameWin;

implementation

var WindMin,WindMax:word;
    textattr:byte;

Procedure Window(X1,y1,x2,y2:Integer);
begin
  WindMin:= y1*256+x1;
  WindMax:=y2*256+x2;
end;

procedure WriteStr(X, Y: Byte; S: String; Attr: Byte);

begin
  TextColor(attr mod 16);
  TextBackground(attr div 16);
  win32Crt.OverwriteText(x,y,S);
end;

procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);
begin
  TextColor(attr mod 16);
  TextBackground(attr div 16);
  win32Crt.OverwriteChar (x,y,ch);
end;

procedure FillWin(Ch: Char; Attr: Byte);
begin
  TextColor(attr mod 16);
  TextBackground(attr div 16);
  FillConsole(CH)
end;
procedure WriteWin(var Buf);
begin

end;
procedure ReadWin(var Buf);
begin

end;
function WinSize: Word;
begin
  result:= WindMax-WindMin;
end;

procedure SaveWin(var W: WinState);
begin
  W.WindMin := WindMin;
  W.WindMax := WindMax;
  W.WhereX := WhereX;
  W.WhereY := WhereY;
  W.TextAttr := TextAttr;
end;

procedure RestoreWin(var W: WinState);
begin
  WindMin := W.WindMin;
  WindMax := W.WindMax;
  GotoXY(W.WhereX, W.WhereY);
  TextAttr := W.TextAttr;
end;

procedure FrameWin(Title: TitleStr; var Frame: FrameChars;
  TitleAttr, FrameAttr: Byte);
var
  W, H, Y: Word;
begin
  W := Lo(WindMax) - Lo(WindMin) + 1;
  H := Hi(WindMax) - Hi(WindMin) + 1;
  WriteChar(1, 1, 1, Frame[1], FrameAttr);
  WriteChar(2, 1, W - 2, Frame[2], FrameAttr);
  WriteChar(W, 1, 1, Frame[3], FrameAttr);
  if Length(Title) > W - 2 then Title[0] := Chr(W - 2);
  WriteStr((W - Length(Title)) shr 1 + 1, 1, Title, TitleAttr);
  for Y := 2 to H - 1 do
  begin
    WriteChar(1, Y, 1, Frame[4], FrameAttr);
    WriteChar(W, Y, 1, Frame[5], FrameAttr);
  end;
  WriteChar(1, H, 1, Frame[6], FrameAttr);
  WriteChar(2, H, W - 2, Frame[7], FrameAttr);
  WriteChar(W, H, 1, Frame[8], FrameAttr);
  Inc(WindMin, $0101);
  Dec(WindMax, $0101);
end;

procedure UnFrameWin;
begin
  Dec(WindMin, $0101);
  Inc(WindMax, $0101);
end;

end.
