{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}

{   System independent GRAPHICAL clone of APP.PAS          }

{   Interface Copyright (c) 1992 Borland International     }

{   Copyright (c) 1996, 1997, 1998, 1999 by Leon de Boer   }
{   ldeboer@attglobal.net  - primary e-mail addr           }
{   ldeboer@starwon.com.au - backup e-mail addr            }

{****************[ THIS CODE IS FREEWARE ]*****************}

{     This sourcecode is released for the purpose to       }
{   promote the pascal language on all platforms. You may  }
{   redistribute it and/or modify with the following       }
{   DISCLAIMER.                                            }

{     This SOURCE CODE is distributed "AS IS" WITHOUT      }
{   WARRANTIES AS TO PERFORMANCE OF MERCHANTABILITY OR     }
{   ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED.     }

{*****************[ SUPPORTED PLATFORMS ]******************}

{ Only Free Pascal Compiler supported                      }

{**********************************************************}

unit fv2app;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
interface

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$X+}{ Extended syntax is ok }
{ $R-}{ Disable range checking }
{ $S-}{ Disable Stack Checking }
{ $I-}{ Disable IO Checking }
{ $Q-}{ Disable Overflow Checking }
{ $V-}{ Turn off strict VAR strings }
{====================================================================}

uses Classes, SysUtils,
   {$IFDEF OS_WINDOWS}{ WIN/NT CODE }
  //      Windows,                                       { Standard units }
   {$ENDIF}

   {$IFDEF OS_OS2}{ OS2 CODE }
     {$IFDEF PPC_FPC}
  Os2Def, DosCalls, PmWin,                       { Standard units }
     {$ELSE}
  Os2Def, Os2Base, OS2PmApi,                       { Standard units }
     {$ENDIF}
   {$ENDIF}
  //   Dos,
  //   Video,  {?}
  FV2Common, {Memory,}                                { GFV standard units }
  fv2Drivers, fv2Views, fv2Menus, fv2HistList, fv2Dialogs,
  fv2msgbox, fv2consts;

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                  STANDARD APPLICATION COMMAND CONSTANTS                   }
{---------------------------------------------------------------------------}
const
  cmNew = 30;                                  { Open new file }
  cmOpen = 31;                                  { Open a file }
  cmSave = 32;                                  { Save current }
  cmSaveAs = 33;                                  { Save current as }
  cmSaveAll = 34;                                  { Save all files }
  cmChangeDir = 35;                                  { Change directories }
  cmDosShell = 36;                                  { Dos shell }
  cmCloseAll = 37;                                  { Close all windows }

{---------------------------------------------------------------------------}
{                       TApplication PALETTE ENTRIES                        }
{---------------------------------------------------------------------------}
const
  apColor = 0;                                  { Coloured app }
  apBlackWhite = 1;                                  { B&W application }
  apMonochrome = 2;                                  { Monochrome app }

{---------------------------------------------------------------------------}
{                           TBackGround PALETTES                            }
{---------------------------------------------------------------------------}
const
  CBackground = #1;                                  { Background colour }

{---------------------------------------------------------------------------}
{                           TApplication PALETTES                           }
{---------------------------------------------------------------------------}
const
  { Turbo Vision 1.0 Color Palettes }

  CColor =
    #$81#$70#$78#$74#$20#$28#$24#$17#$1F#$1A#$31#$31#$1E#$71#$1F +
    #$37#$3F#$3A#$13#$13#$3E#$21#$3F#$70#$7F#$7A#$13#$13#$70#$7F#$7E +
    #$70#$7F#$7A#$13#$13#$70#$70#$7F#$7E#$20#$2B#$2F#$78#$2E#$70#$30 +
    #$3F#$3E#$1F#$2F#$1A#$20#$72#$31#$31#$30#$2F#$3E#$31#$13#$38#$00;

  CBlackWhite =
    #$70#$70#$78#$7F#$07#$07#$0F#$07#$0F#$07#$70#$70#$07#$70#$0F +
    #$07#$0F#$07#$70#$70#$07#$70#$0F#$70#$7F#$7F#$70#$07#$70#$07#$0F +
    #$70#$7F#$7F#$70#$07#$70#$70#$7F#$7F#$07#$0F#$0F#$78#$0F#$78#$07 +
    #$0F#$0F#$0F#$70#$0F#$07#$70#$70#$70#$07#$70#$0F#$07#$07#$78#$00;

  CMonochrome =
    #$70#$07#$07#$0F#$70#$70#$70#$07#$0F#$07#$70#$70#$07#$70#$00 +
    #$07#$0F#$07#$70#$70#$07#$70#$00#$70#$70#$70#$07#$07#$70#$07#$00 +
    #$70#$70#$70#$07#$07#$70#$70#$70#$0F#$07#$07#$0F#$70#$0F#$70#$07 +
    #$0F#$0F#$07#$70#$07#$07#$70#$07#$07#$07#$70#$0F#$07#$07#$70#$00;

  { Turbo Vision 2.0 Color Palettes }

  CAppColor =
    #$71#$70#$78#$74#$20#$28#$24#$17#$1F#$1A#$31#$31#$1E#$71#$1F +
    #$37#$3F#$3A#$13#$13#$3E#$21#$3F#$70#$7F#$7A#$13#$13#$70#$7F#$7E +
    #$70#$7F#$7A#$13#$13#$70#$70#$7F#$7E#$20#$2B#$2F#$78#$2E#$70#$30 +
    #$3F#$3E#$1F#$2F#$1A#$20#$72#$31#$31#$30#$2F#$3E#$31#$13#$38#$00 +
    #$17#$1F#$1A#$71#$71#$1E#$17#$1F#$1E#$20#$2B#$2F#$78#$2E#$10#$30 +
    #$3F#$3E#$70#$2F#$7A#$20#$12#$31#$31#$30#$2F#$3E#$31#$13#$38#$00 +
    #$37#$3F#$3A#$13#$13#$3E#$30#$3F#$3E#$20#$2B#$2F#$78#$2E#$30#$70 +
    #$7F#$7E#$1F#$2F#$1A#$20#$32#$31#$71#$70#$2F#$7E#$71#$13#$38#$00;

  CAppBlackWhite =
    #$70#$70#$78#$7F#$07#$07#$0F#$07#$0F#$07#$70#$70#$07#$70#$0F +
    #$07#$0F#$07#$70#$70#$07#$70#$0F#$70#$7F#$7F#$70#$07#$70#$07#$0F +
    #$70#$7F#$7F#$70#$07#$70#$70#$7F#$7F#$07#$0F#$0F#$78#$0F#$78#$07 +
    #$0F#$0F#$0F#$70#$0F#$07#$70#$70#$70#$07#$70#$0F#$07#$07#$78#$00 +
    #$07#$0F#$0F#$07#$70#$07#$07#$0F#$0F#$70#$78#$7F#$08#$7F#$08#$70 +
    #$7F#$7F#$7F#$0F#$70#$70#$07#$70#$70#$70#$07#$7F#$70#$07#$78#$00 +
    #$70#$7F#$7F#$70#$07#$70#$70#$7F#$7F#$07#$0F#$0F#$78#$0F#$78#$07 +
    #$0F#$0F#$0F#$70#$0F#$07#$70#$70#$70#$07#$70#$0F#$07#$07#$78#$00;

  CAppMonochrome =
    #$70#$07#$07#$0F#$70#$70#$70#$07#$0F#$07#$70#$70#$07#$70#$00 +
    #$07#$0F#$07#$70#$70#$07#$70#$00#$70#$70#$70#$07#$07#$70#$07#$00 +
    #$70#$70#$70#$07#$07#$70#$70#$70#$0F#$07#$07#$0F#$70#$0F#$70#$07 +
    #$0F#$0F#$07#$70#$07#$07#$70#$07#$07#$07#$70#$0F#$07#$07#$70#$00 +
    #$70#$70#$70#$07#$07#$70#$70#$70#$0F#$07#$07#$0F#$70#$0F#$70#$07 +
    #$0F#$0F#$07#$70#$07#$07#$70#$07#$07#$07#$70#$0F#$07#$07#$70#$00 +
    #$70#$70#$70#$07#$07#$70#$70#$70#$0F#$07#$07#$0F#$70#$0F#$70#$07 +
    #$0F#$0F#$07#$70#$07#$07#$70#$07#$07#$07#$70#$0F#$07#$07#$70#$00;

{---------------------------------------------------------------------------}
{                     STANDRARD HELP CONTEXT CONSTANTS                      }
{---------------------------------------------------------------------------}
const
  { Note: range $FF00 - $FFFF of help contexts are reserved by Borland }
  hcNew = $FF01;                               { New file help }
  hcOpen = $FF02;                               { Open file help }
  hcSave = $FF03;                               { Save file help }
  hcSaveAs = $FF04;                               { Save file as help }
  hcSaveAll = $FF05;                               { Save all files help }
  hcChangeDir = $FF06;                               { Change dir help }
  hcDosShell = $FF07;                               { Dos shell help }
  hcExit = $FF08;                               { Exit program help }

  hcUndo = $FF10;                               { Clipboard undo help }
  hcCut = $FF11;                               { Clipboard cut help }
  hcCopy = $FF12;                               { Clipboard copy help }
  hcPaste = $FF13;                               { Clipboard paste help }
  hcClear = $FF14;                               { Clipboard clear help }

  hcTile = $FF20;                               { Desktop tile help }
  hcCascade = $FF21;                               { Desktop cascade help }
  hcCloseAll = $FF22;                               { Desktop close all }
  hcResize = $FF23;                               { Window resize help }
  hcZoom = $FF24;                               { Window zoom help }
  hcNext = $FF25;                               { Window next help }
  hcPrev = $FF26;                               { Window previous help }
  hcClose = $FF27;                               { Window close help }


{***************************************************************************}
{                        PUBLIC CLASS DEFINITIONS                          }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                  TBackGround class - BACKGROUND class                   }
{---------------------------------------------------------------------------}
type
  TBackGround = class(TView)
  public
    Pattern: char;                               { Background pattern }
    constructor Create(aOwner: TGroup; var Bounds: TRect; APattern: char);
    constructor Load(var S: TStream);
    function GetPalette: PPalette; override;
    procedure Draw; override;
    procedure Store(var S: TStream); override;
  end;

  PBackGround = ^TBackGround;

{---------------------------------------------------------------------------}
{                     TDeskTop class - DESKTOP class                      }
{---------------------------------------------------------------------------}
type
  TDeskTop = class(TGroup)
  public
    Background: TBackground;               { Background view }
    TileColumnsFirst: boolean;                   { Tile direction }
    constructor Create(aOwner: TGroup;Bounds: TRect);
    constructor Load(aOwner: TGroup; var S: TStream);
    procedure TileError; virtual;
    procedure InitBackGround; virtual;
    procedure Tile(var R: TRect);
    procedure Store(var S: TStream); override;
    procedure Cascade(var R: TRect);
    procedure HandleEvent(var Event: TEvent); override;
  end;

  PDeskTop = ^TDeskTop;

{---------------------------------------------------------------------------}
{                  TProgram class - PROGRAM ANCESTOR class                }
{---------------------------------------------------------------------------}
type
  TProgram = class(TGroup)
  public
    constructor Create;
    destructor Destroy; override;
    function GetPalette: PPalette; override;
    function CanMoveFocus: boolean;
    function ValidView(P: TView): TView;
    function InsertWindow(P: TWindow): TWindow;
    function ExecuteDialog(P: TDialog; Data: TStream): word; overload;
    function ExecuteDialog(P: TDialog; var Data: string): word; overload;
    procedure Run; virtual;
    procedure Idle; virtual;
    procedure InitScreen; virtual;
    {      procedure DoneScreen; virtual;}
    procedure InitDeskTop; virtual;
    procedure OutOfMemory; virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure SetScreenMode(Mode: word);
    procedure SetScreenVideoMode(const Mode: TVideoMode);
    procedure PutEvent(var Event: TEvent); override;
    procedure GetEvent(out Event: TEvent); override;
    procedure HandleEvent(var Event: TEvent); override;
  end;

  PProgram = ^TProgram;

{---------------------------------------------------------------------------}
{                  TApplication class - APPLICATION class                 }
{---------------------------------------------------------------------------}
type
  TApplication = class(TProgram)
  public
    constructor Create;
    destructor Destroy; override;
    procedure Tile;
    procedure Cascade;
    procedure DosShell;
    procedure GetTileRect(out R: TRect); virtual;
    procedure HandleEvent(var Event: TEvent); override;
    procedure WriteShellMsg; virtual;
  end;

  PApplication = ^TApplication;                      { Application ptr }

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                STANDARD MENU AND STATUS LINES ROUTINES                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-StdStatusKeys------------------------------------------------------
Returns a pointer to a linked list of commonly used status line keys.
The default status line for TApplication uses StdStatusKeys as its
complete list of status keys.
22Oct99 LdB
---------------------------------------------------------------------}
function StdStatusKeys(Next: PStatusItem): PStatusItem;

{-StdFileMenuItems---------------------------------------------------
Returns a pointer to a list of menu items for a standard File menu.
The standard File menu items are New, Open, Save, Save As, Save All,
Change Dir, OS Shell, and Exit.
22Oct99 LdB
---------------------------------------------------------------------}
function StdFileMenuItems(Next: TMenuItem=nil): TMenuItem;

{-StdEditMenuItems---------------------------------------------------
Returns a pointer to a list of menu items for a standard Edit menu.
The standard Edit menu items are Undo, Cut, Copy, Paste, and Clear.
22Oct99 LdB
---------------------------------------------------------------------}
function StdEditMenuItems(Next: TMenuItem): TMenuItem;

{-StdWindowMenuItems-------------------------------------------------
Returns a pointer to a list of menu items for a standard Window menu.
The standard Window menu items are Tile, Cascade, Close All,
Size/Move, Zoom, Next, Previous, and Close.
22Oct99 LdB
---------------------------------------------------------------------}
function StdWindowMenuItems(Next: TMenuItem): TMenuItem;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           class REGISTER ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{-RegisterApp--------------------------------------------------------
Calls RegisterType for each of the class types defined in this unit.
22oct99 LdB
---------------------------------------------------------------------}
procedure RegisterApp;

{***************************************************************************}
{                           class REGISTRATION                             }
{***************************************************************************}


{***************************************************************************}
{                        INITIALIZED PUBLIC VARIABLES                       }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                       INITIALIZED PUBLIC VARIABLES                        }
{---------------------------------------------------------------------------}
const
  AppPalette: integer = apColor;                     { Application colour }
  Desktop: TDeskTop = nil;                           { Desktop class }
  MenuBar: TMenuView = nil;                          { Application menu }
  StatusLine: TStatusLine = nil;                     { App status line }
  Application: TApplication = nil;                  { Application class }

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
implementation

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

uses  Video, Mouse{,Resource},fv2VisConsts, fv2RectHelper;

resourcestring
  sVideoFailed = 'Video initialization failed.';
  sTypeExitOnReturn = 'Type EXIT to return...';


{***************************************************************************}
{                        PRIVATE DEFINED CONSTANTS                          }
{***************************************************************************}

{***************************************************************************}
{                      PRIVATE INITIALIZED VARIABLES                        }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                      INITIALIZED PRIVATE VARIABLES                        }
{---------------------------------------------------------------------------}
const
  Pending: TEvent = (What: evNothing{%H-});            { Pending event }

{---------------------------------------------------------------------------}
{  Tileable -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB          }
{---------------------------------------------------------------------------}
function Tileable(P: TView): boolean;
begin
  Result := (P.Options and ofTileable <> 0) and   { View is tileable }
    (P.State and sfVisible <> 0);                   { View is visible }
end;

{---------------------------------------------------------------------------}
{  ISqr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
function ISqr(X: Sw_Integer): Sw_Integer;
var
  I: Sw_Integer;
begin
  I := 1;                                            { Set value to zero }
  repeat
    if 4*i*i <= X then
      I:= I * 2
    else
      Inc(I);                                          { Inc value }
  until (I * I > X);                                 { Repeat till Sqr > X }
  Result := I - 1;                                     { Return result }
end;

{---------------------------------------------------------------------------}
{  MostEqualDivisors -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB }
{---------------------------------------------------------------------------}
procedure MostEqualDivisors(N: integer; var X, Y: integer; FavorY: boolean);
var
  I: integer;
begin
  I := ISqr(N);                                      { Int square of N }
  if ((N mod I) <> 0) then                           { Initial guess }
    if ((N mod (I + 1)) = 0) then
      Inc(I);              { Add one row/column }
  if (I < (N div I)) then
    I := N div I;              { In first page }
  if FavorY then
  begin                               { Horz preferred }
    X := N div I;                                    { Calc x position }
    Y := I;                                          { Set y position  }
  end
  else
  begin                                     { Vert preferred }
    Y := N div I;                                    { Calc y position }
    X := I;                                          { Set x position }
  end;
end;

{***************************************************************************}
{                               class METHODS                              }
{***************************************************************************}

{--TBackGround--------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
constructor TBackGround.Create(aOwner: TGroup; var Bounds: TRect; APattern: char);
begin
  inherited Create(aOwner, Bounds);                            { Call ancestor }
  GrowMode := gfGrowHiX + gfGrowHiY;                 { Set grow modes }
  Pattern := APattern;                               { Hold pattern }
end;

{--TBackGround--------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
constructor TBackGround.Load(var S: TStream);
begin
  inherited Load(nil, S);                                 { Call ancestor }
  S.Read(Pattern, SizeOf(Pattern));                  { Read pattern data }
end;

{--TBackGround--------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
function TBackGround.GetPalette: PPalette;
const
  P: string[Length(CBackGround)] = CbackGround;   { Always normal string }
begin
  Result := PPalette(@P);                        { Return palette }
end;

{--TBackGround--------------------------------------------------------------}
{  DrawBackground -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB    }
{---------------------------------------------------------------------------}
procedure TBackGround.Draw;
var
  B: TDrawBuffer;
begin
  MoveChar(B, Pattern, GetColor($01), Size.X);       { Fill draw buffer }
  WriteLine(0, 0, Size.X, Size.Y, B);                { Draw to area }
end;

{--TBackGround--------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB             }
{---------------------------------------------------------------------------}
procedure TBackGround.Store(var S: TStream);
begin
  inherited Store(S);                                    { TView store called }
  S.Write(Pattern, SizeOf(Pattern));                 { Write pattern data }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TDesktop class METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TDesktop-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
constructor TDeskTop.Create(aOwner: TGroup; Bounds: TRect);
begin
  inherited Create(aOwner, Bounds);                            { Call ancestor }
  GrowMode := gfGrowHiX + gfGrowHiY;                 { Set growmode }
  InitBackground;                                    { Create background }
  if (Background <> nil) then
    Insert(Background);    { Insert background }
end;

{--TDesktop-----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
constructor TDeskTop.Load(aOwner: TGroup; var S: TStream);
begin
  inherited Load(aOwner, S);                                 { Call ancestor }
  GetSubViewPtr(S, Background);                      { Load background }
  S.Read(TileColumnsFirst, SizeOf(TileColumnsFirst));{ Read data }
end;

{--TDesktop-----------------------------------------------------------------}
{  TileError -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB         }
{---------------------------------------------------------------------------}
procedure TDeskTop.TileError;
begin
 // { Abstract method }
end;

{--TDesktop-----------------------------------------------------------------}
{  InitBackGround -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB    }
{---------------------------------------------------------------------------}
procedure TDeskTop.InitBackGround;
var
  R: TRect;
begin
  GetExtent(R);                                      { Get desktop extents }
  BackGround := TBackground.Create(self, R, chMiddleFill);       { Insert a background }
end;

{--TDesktop-----------------------------------------------------------------}
{  Tile -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
procedure TDeskTop.Tile(var R: TRect);
var
  NumCols, NumRows, NumTileable, LeftOver, TileNum: integer;
  zView: TComponent;

  function DividerLoc(Lo, Hi, Num, Pos: integer): integer;
  begin
    Result := longint(longint(Hi - Lo) * Pos) div Num + Lo;
    { Calc position }
  end;

  procedure DoCountTileable(P: TView);
{$IFNDEF PPC_FPC}
  far;
{$ENDIF}
  begin
    if Tileable(P) then
      Inc(NumTileable);            { Count tileable views }
  end;

  procedure CalcTileRect(Pos: integer; out NR: TRect);
  var
    X, Y, D: integer;
  begin
    D := (NumCols - LeftOver) * NumRows;             { Calc d value }
    if (Pos < D) then
    begin
      X := Pos div NumRows;
      Y := Pos mod NumRows;    { Calc positions }
    end
    else
    begin
      X := (Pos - D) div (NumRows + 1) + (NumCols - LeftOver);
      { Calc x position }
      Y := (Pos - D) mod (NumRows + 1);              { Calc y position }
    end;
    NR.A.X := DividerLoc(R.A.X, R.B.X, NumCols, X);  { Top left x position }
    NR.B.X := DividerLoc(R.A.X, R.B.X, NumCols, X + 1);{ Right x position }
    if (Pos >= D) then
    begin
      NR.A.Y := DividerLoc(R.A.Y, R.B.Y, NumRows + 1, Y);{ Top y position }
      NR.B.Y := DividerLoc(R.A.Y, R.B.Y, NumRows + 1, Y + 1);
      { Bottom y position }
    end
    else
    begin
      NR.A.Y := DividerLoc(R.A.Y, R.B.Y, NumRows, Y);  { Top y position }
      NR.B.Y := DividerLoc(R.A.Y, R.B.Y, NumRows, Y + 1);
      { Bottom y position }
    end;
  end;

  procedure DoTile(P: TView);
{$IFNDEF PPC_FPC}
  far;
{$ENDIF}
  var
    PState: word;
    R: TRect;
  begin
    if Tileable(P) then
    begin
      CalcTileRect(TileNum, R);                      { Calc tileable area }
      PState := P.State;                            { Hold view state }
      P.State := P.State and not sfVisible;        { Temp not visible }
      P.Locate(R);                                  { Locate view }
      P.State := PState;                            { Restore view state }
      Dec(TileNum);                                  { One less to tile }
    end;
  end;

begin
  NumTileable := 0;                                  { Zero tileable count }
  for zView in self do
    DoCountTileable(TView(zView));                         { Count tileable views }
  if (NumTileable > 0) then
  begin
    MostEqualDivisors(NumTileable, NumCols, NumRows, not TileColumnsFirst);
    { Do pre calcs }
    if ((R.B.X - R.A.X) div NumCols = 0) or ((R.B.Y - R.A.Y) div NumRows = 0) then
      TileError { Can't tile }
    else
    begin
      LeftOver := NumTileable mod NumCols;           { Left over count }
      TileNum := NumTileable - 1;                      { Tileable views }
      for zView in self do
        DoTile(TView(zView));                              { Tile each view }
      DrawView;                                      { Now redraw }
    end;
  end;
end;

{--TDesktop-----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB             }
{---------------------------------------------------------------------------}
procedure TDeskTop.Store(var S: TStream);
begin
  inherited Store(S);                                   { Call group store }
  PutSubViewPtr(S, Background);                      { Store background }
  S.Write(TileColumnsFirst, SizeOf(TileColumnsFirst));{ Write data }
end;

{--TDesktop-----------------------------------------------------------------}
{  Cascade -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB           }
{---------------------------------------------------------------------------}
procedure TDeskTop.Cascade(var R: TRect);
var
  CascadeNum: integer;
  LastView: TView;
  Min, Max: TPoint;
  zView: TComponent;

  procedure DoCount(P: TView);
  begin
    if Tileable(P) then
    begin
      Inc(CascadeNum);
      LastView := P;                { Count cascadable }
    end;
  end;

  procedure DoCascade(P: TView);
  var
    PState: word;
    NR: TRect;
  begin
    if Tileable(P) and (CascadeNum >= 0) then
    begin  { View cascadable }
      NR.Copy(R);                                    { Copy rect area }
      Inc(NR.A.X, CascadeNum);                       { Inc x position }
      Inc(NR.A.Y, CascadeNum);                       { Inc y position }
      PState := P.State;                            { Hold view state }
      P.State := P.State and not sfVisible;        { Temp stop draw }
      P.Locate(NR);                                 { Locate the view }
      P.State := PState;                            { Now allow draws }
      Dec(CascadeNum);                               { Dec count }
    end;
  end;

begin
  CascadeNum := 0;                                   { Zero cascade count }
  for zView in self do
    DoCount(TView(zView));                                 { Count cascadable }
  if (CascadeNum > 0) then
  begin
    LastView.SizeLimits(Min, Max);                  { Check size limits }
    if (Min.X > R.B.X - R.A.X - CascadeNum) or
      (Min.Y > R.B.Y - R.A.Y - CascadeNum) then
      TileError
    else
    begin                             { Check for error }
      Dec(CascadeNum);                               { One less view }
      for zView in self do
        DoCascade(TView(zView));                           { Cascade view }
      DrawView;                                      { Redraw now }
    end;
  end;
end;

{--TDesktop-----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB       }
{---------------------------------------------------------------------------}
procedure TDeskTop.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);                      { Call ancestor }
  if (Event.What = evCommand) then
  begin
    case Event.Command of                            { Command event }
      cmNext: FocusNext(False);                      { Focus next view }
      cmPrev: if (BackGround <> nil) then
        begin
          if Valid(cmReleasedFocus) then
            Current.PutInFrontOf(Background);          { Focus last view }
        end
        else
          FocusNext(True);                      { Focus prior view }
      else
        Exit;
    end;
    ClearEvent(Event);                               { Clear the event }
  end;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TProgram class METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}


{--TProgram-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TProgram.Create;
var
  R: TRect;
begin
  R.Assign(0, 0, ScreenWidth, ScreenHeight);         { Full screen area }
  inherited Create(nil, R);                           { Call ancestor }
  Application := TApplication(Self);
  { Set application ptr }
  InitScreen;                                        { Initialize screen }
  State := sfVisible + sfSelected + sfFocused + sfModal + sfExposed;
  { Deafult states }
  Options := 0;                                      { No options set }
  Size := point(ScreenWidth, ScreenHeight);                            { Set y size value }
  InitStatusLine;                                    { Create status line }
  InitMenuBar;                                       { Create a bar menu }
  InitDesktop;                                       { Create desktop }
  if (Desktop <> nil) then
    Insert(Desktop);          { Insert desktop }
  if (StatusLine <> nil) then
    Insert(StatusLine);    { Insert status line }
  if (MenuBar <> nil) then
    Insert(MenuBar);          { Insert menu bar }
end;

{--TProgram-----------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
destructor TProgram.Destroy;
begin
  { Do not free the Buffer of Video Unit }
  //If Buffer = fv2Views.PVideoBuf(VideoBuf) then
  //  Buffer:=nil;
  //If (Desktop <> Nil) Then Dispose(Desktop, Done);   { Destroy desktop }
  //If (MenuBar <> Nil) Then Dispose(MenuBar, Done);   { Destroy menu bar }
  //If (StatusLine <> Nil) Then
  //  Dispose(StatusLine, Done);                       { Destroy status line }
  Application := nil;                                { Clear application }
  inherited;                                    { Call ancestor }
end;

{--TProgram-----------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
function TProgram.GetPalette: PPalette;
const
  P: array[apColor..apMonochrome] of string = (CAppColor, CAppBlackWhite,
    CAppMonochrome);
begin
  Result := @P[AppPalette];                      { Return palette }
end;

{--TProgram-----------------------------------------------------------------}
{  CanMoveFocus -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23Sep97 LdB      }
{---------------------------------------------------------------------------}
function TProgram.CanMoveFocus: boolean;
begin
  if (Desktop <> nil) then                           { Valid desktop view }
    Result := DeskTop.Valid(cmReleasedFocus)  { Check focus move }
  else
    Result := True;                       { No desktop who cares! }
end;

{--TProgram-----------------------------------------------------------------}
{  ValidView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB         }
{---------------------------------------------------------------------------}
function TProgram.ValidView(P: TView): TView;
begin
  Result := nil;                                  { Preset failure }
  if (P <> nil) then
  begin
(*
     If LowMemory Then Begin                          { Check memroy }
       Dispose(P, Done);                              { Dispose view }
       OutOfMemory;                                   { Call out of memory }
       Exit;                                          { Now exit }
     End;
*)
    if not P.Valid(cmValid) then
    begin              { Check view valid }
      FreeAndNil(P);                              { Dispose view }
      Exit;                                          { Now exit }
    end;
    Result := P;                                  { Return view }
  end;
end;

{--TProgram-----------------------------------------------------------------}
{  InsertWindow -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB      }
{---------------------------------------------------------------------------}
function TProgram.InsertWindow(P: TWindow): TWindow;
begin
  Result := nil;                               { Preset failure }
  if (ValidView(P) <> nil) then                      { Check view valid }
    if (CanMoveFocus) and (Desktop <> nil)           { Can we move focus } then
    begin
      Desktop.Insert(P);                            { Insert window }
      Result := P;                             { Return view ptr }
    end
    else
      FreeAndNil(P);                       { Dispose view }
end;

{--TProgram-----------------------------------------------------------------}
{  ExecuteDialog -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB     }
{---------------------------------------------------------------------------}
function TProgram.ExecuteDialog(P: TDialog; Data: TStream): word;
var
  ExecResult: word;
  StPos: int64;
begin
  Result := cmCancel;                         { Preset cancel }
  if (ValidView(P) <> nil) then
  begin                { Check view valid }
    StPos := Data.Position;
    if (Data <> nil) then
      P.SetData(Data);         { Set data }
    if (P <> nil) then
      P.SelectDefaultView;         { Select default }
    ExecResult := Desktop.ExecView(P);              { Execute view }
    Data.Seek(StPos, soBeginning);
    if (ExecResult <> cmCancel) and (Data <> nil) then
      P.GetData(Data);                        { Get data back }
    FreeAndNil(P);                                { Dispose of dialog }
    Result := ExecResult;                     { Return result }
  end;
end;

function TProgram.ExecuteDialog(P: TDialog; var Data: string): word;
var
  ExecResult: word;
  st: TStream;
begin
  Result := cmCancel;                         { Preset cancel }
  if (ValidView(P) <> nil) then
  begin                { Check view valid }
    st := TMemoryStream.Create;
    try
      st.WriteAnsiString(Data);
      st.Seek(0, soBeginning);
      P.SetData(st);         { Set data }
      if (P <> nil) then
        P.SelectDefaultView;         { Select default }
      ExecResult := Desktop.ExecView(P);              { Execute view }
      st.Seek(0, soBeginning);
      if (ExecResult <> cmCancel) then
        P.GetData(st);                        { Get data back }
      st.Seek(0, soBeginning);
      Data := st.ReadAnsiString;
    finally
      FreeAndNil(st);
      FreeAndNil(P);                                { Dispose of dialog }
    end;
    Result := ExecResult;                     { Return result }
  end;
end;

{--TProgram-----------------------------------------------------------------}
{  Run -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB               }
{---------------------------------------------------------------------------}
procedure TProgram.Run;
begin
  Execute;                                           { Call execute }
end;

{--TProgram-----------------------------------------------------------------}
{  Idle -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Oct99 LdB              }
{---------------------------------------------------------------------------}
procedure TProgram.Idle;
begin
  if (StatusLine <> nil) then
    StatusLine.Update;    { Update statusline }
  if CommandSetChanged then
  begin                    { Check command change }
    MessageP(Self, evBroadcast, cmCommandSetChanged,
      nil);                                          { Send message }
    CommandSetChanged := False;                      { Clear flag }
  end;
  GiveUpTimeSlice;
end;

{--TProgram-----------------------------------------------------------------}
{  InitScreen -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TProgram.InitScreen;

{Initscreen is passive only, i.e. it detects the video size and capabilities
 after initalization. Active video initalization is the task of Tapplication.}

begin
  { the orginal code can't be used here because of the limited
    video unit capabilities, the mono modus can't be handled
  }
  fv2Drivers.DetectVideo;
  { ScreenMode.Row may be 0 if there's no console on startup }
  if ScreenMode.Row = 0 then
  begin
    ShadowSize.X := 2;
    AppPalette := apColor;
  end
  else
  begin
    if (ScreenMode.Col div ScreenMode.Row < 2) then
      ShadowSize.X := 1
    else
      ShadowSize.X := 2;
    if ScreenMode.color then
      AppPalette := apColor
    else
      AppPalette := apBlackWhite;
  end;
  ShadowSize.Y := 1;
  ShowMarkers := False;
end;


{procedure TProgram.DoneScreen;
begin
  Drivers.DoneVideo;
  Buffer:=nil;
end;}


{--TProgram-----------------------------------------------------------------}
{  InitDeskTop -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TProgram.InitDeskTop;
var
  R: TRect;
begin
  GetExtent(R);                                      { Get view extent }
  if (MenuBar <> nil) then
    Inc(R.A.Y);               { Adjust top down }
  if (StatusLine <> nil) then
    Dec(R.B.Y);            { Adjust bottom up }
  DeskTop := TDesktop.Create(self, R);                 { Create desktop }
end;

{--TProgram-----------------------------------------------------------------}
{  OutOfMemory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB       }
{---------------------------------------------------------------------------}
procedure TProgram.OutOfMemory;
begin
  // { Abstract method }
end;

{--TProgram-----------------------------------------------------------------}
{  InitMenuBar -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TProgram.InitMenuBar;
var
  R: TRect;
begin
  GetExtent(R);                                      { Get view extents }
  R.B.Y := R.A.Y + 1;                                { One line high  }
  MenuBar := TMenuBar.Create(self, R, nil);            { Create menu bar }
end;

{--TProgram-----------------------------------------------------------------}
{  InitStatusLine -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB    }
{---------------------------------------------------------------------------}
procedure TProgram.InitStatusLine;
var
  R: TRect;
begin
  GetExtent(R);                                      { Get view extents }
  R.A.Y := R.B.Y - 1;                                { One line high }
  StatusLine := TStatusLine.Create(self, R, NewStatusDef(0, $FFFF,
    NewStatusKey('~Alt-X~ Exit', kbAltX, cmQuit, StdStatusKeys(nil)), nil));
  { Default status line }
end;

{--TProgram-----------------------------------------------------------------}
{  SetScreenMode -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Oct99 LdB     }
{---------------------------------------------------------------------------}
procedure TProgram.SetScreenMode(Mode: word);
var
  R: TRect;
begin
  HideMouse;
  {  DoneMemory;}
  {  InitMemory;}
  InitScreen;
  R.Assign(0, 0, ScreenWidth, ScreenHeight);
  ChangeBounds(R);
  ShowMouse;
end;

procedure TProgram.SetScreenVideoMode(const Mode: TVideoMode);
var
  R: TRect;
begin
  hidemouse;
{  DoneMouse;
  DoneMemory;}
  ScreenMode := Mode;
{  InitMouse;
  InitMemory;}
{  InitScreen;
   Warning: InitScreen calls DetectVideo which
    resets ScreenMode to old value, call it after
    video mode was changed instead of before }
  Video.SetVideoMode(Mode);

  { Update ScreenMode to new value }
  InitScreen;
  ScreenWidth := Video.ScreenWidth;
  ScreenHeight := Video.ScreenHeight;
  R.Assign(0, 0, ScreenWidth, ScreenHeight);
  ChangeBounds(R);
  ShowMouse;
end;

{--TProgram-----------------------------------------------------------------}
{  PutEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
procedure TProgram.PutEvent(var Event: TEvent);
begin
  Pending := Event;                                  { Set pending event }
end;

{--TProgram-----------------------------------------------------------------}
{  GetEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May98 LdB          }
{---------------------------------------------------------------------------}
procedure TProgram.GetEvent(out Event: TEvent);
begin
  Event.What := evNothing;
  if (Event.What = evNothing) then
  begin
    if (Pending.What <> evNothing) then
    begin        { Pending event }
      Event := Pending;                              { Load pending event }
      Pending.What := evNothing;                     { Clear pending event }
    end
    else
    begin
      NextQueuedEvent(Event);                        { Next queued event }
      if (Event.What = evNothing) then
      begin
        GetKeyEvent(Event);                          { Fetch key event }
        if (Event.What = evKeyDown) then
        begin
          if Event.keyCode = kbAltF12 then
            ReDraw;
        end;
        if (Event.What = evNothing) then
        begin       { No mouse event }
          fv2Drivers.GetMouseEvent(Event);              { Load mouse event }
          if (Event.What = evNothing) then
          begin
{$IFNDEF HASAMIGA}
               { due to isses with the event handling in FV itself,
                 we skip this here, and let the IDE to handle it
                 directly on Amiga-like systems. The FV itself cannot
                 handle the System Events anyway. (KB) }
            fv2Drivers.GetSystemEvent(Event);         { Load system event }
            if (Event.What = evNothing) then
{$ENDIF}
              Idle;     { Idle if no event }
          end;
        end;
      end;
    end;
  end;
end;

{--TProgram-----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TProgram.HandleEvent(var Event: TEvent);
var
  C: char;
begin
  if (Event.What = evKeyDown) then
  begin             { Key press event }
    C := GetAltChar(Event.KeyCode);                  { Get alt char code }
    if (C >= '1') and (C <= '9') then
      if (MessageR(Desktop, evBroadCast, cmSelectWindowNum, (byte(C) - $30)) <>
        nil)              { Select window } then
        ClearEvent(Event);                      { Clear event }
  end;
  inherited HandleEvent(Event);                      { Call ancestor }
  if (Event.What = evCommand) and                    { Command event }
    (Event.Command = cmQuit) then
  begin                { Quit command }
    EndModal(cmQuit);                               { Endmodal operation }
    ClearEvent(Event);                              { Clear event }
  end;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TApplication class METHODS                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TApplication-------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TApplication.Create;

begin
  {   InitMemory;}{ Start memory up }
{   if not(InitResource) then
     begin
       writeln('Fatal: Can''t init resources');
       halt(1);
     end;}
  initkeyboard;
  if not fv2Drivers.InitVideo then                              { Start video up }
  begin
    donekeyboard;
    writeln(sVideoFailed);
    halt(1);
  end;
  fv2Drivers.InitEvents;                                        { Start event drive }
  fv2Drivers.InitSysError;                                      { Start system error }
  InitHistory;                                               { Start history up }
  inherited Create;                                            { Call ancestor }
  InitMsgBox;
  { init mouse and cursor }
  Video.SetCursorType(crHidden);
  Mouse.SetMouseXY(1, 1);
end;

{--TApplication-------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
destructor TApplication.Destroy;
begin
  inherited;                                    { Call ancestor }
  DoneHistory;                                       { Close history }
  fv2Drivers.DoneSysError;                                      { Close system error }
  fv2Drivers.DoneEvents;                                        { Close event drive }
  fv2Drivers.donevideo;
  {   DoneMemory;}{ Close memory }
  donekeyboard;
  {   DoneResource;}
end;

{--TApplication-------------------------------------------------------------}
{  Tile -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
procedure TApplication.Tile;
var
  R: TRect;
begin
  GetTileRect(R);                                    { Tileable area }
  if (Desktop <> nil) then
    Desktop.Tile(R);         { Tile desktop }
end;

{--TApplication-------------------------------------------------------------}
{  Cascade -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB           }
{---------------------------------------------------------------------------}
procedure TApplication.Cascade;
var
  R: TRect;
begin
  GetTileRect(R);                                    { Cascade area }
  if (Desktop <> nil) then
    Desktop.Cascade(R);      { Cascade desktop }
end;

{--TApplication-------------------------------------------------------------}
{  DosShell -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Oct99 LdB          }
{---------------------------------------------------------------------------}
procedure TApplication.DosShell;

{$ifdef unix}
var
  s: string;
{$endif}

begin                                                 { Compatability only }
  DoneSysError;
  DoneEvents;
  fv2Drivers.donevideo;
  fv2Drivers.donekeyboard;
  {  DoneDosMem;}
  WriteShellMsg;
{$ifdef Unix}
  s := getenv('SHELL');
  if s = '' then
    s := '/bin/sh';
  exec(s, '');
{$else}
  //  SwapVectors;
  SysUtils.ExecuteProcess('.', GetEnvironmentVariable('COMSPEC'));
  //  SwapVectors;
{$endif}
  {  InitDosMem;}
  fv2Drivers.initkeyboard;
  fv2Drivers.initvideo;
  Video.SetCursorType(crHidden);
  InitScreen;
  InitEvents;
  InitSysError;
  Redraw;
end;

{--TApplication-------------------------------------------------------------}
{  GetTileRect -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure TApplication.GetTileRect(out R: TRect);
begin
  if (DeskTop <> nil) then
    Desktop.GetExtent(R)     { Desktop extents }
  else
    GetExtent(R);                               { Our extents }
end;

{--TApplication-------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure TApplication.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);                      { Call ancestor }
  if (Event.What = evCommand) then
  begin
    case Event.Command of
      cmTile: Tile;                                  { Tile request }
      cmCascade: Cascade;                            { Cascade request }
      cmDosShell: DosShell;                          { DOS shell request }
      else
        Exit;                                     { Unhandled exit }
    end;
    ClearEvent(Event);                               { Clear the event }
  end;
end;

procedure TApplication.WriteShellMsg;

begin
  writeln(sTypeExitOnReturn);
end;


{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                STANDARD MENU AND STATUS LINES ROUTINES                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  StdStatusKeys -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB     }
{---------------------------------------------------------------------------}
function StdStatusKeys(Next: PStatusItem): PStatusItem;
begin
  Result :=
    NewStatusKey('', kbAltX, cmQuit,
    NewStatusKey('', kbF10, cmMenu,
    NewStatusKey('', kbAltF3, cmClose,
    NewStatusKey('', kbF5, cmZoom,
    NewStatusKey('', kbCtrlF5, cmResize,
    NewStatusKey('', kbF6, cmNext,
    NewStatusKey('', kbShiftF6, cmPrev, Next)))))));

end;

{---------------------------------------------------------------------------}
{  StdFileMenuItems -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB  }
{---------------------------------------------------------------------------}
function StdFileMenuItems(Next: TMenuItem): TMenuItem;
begin
   result := NewItem('~N~ew', '', kbNoKey, cmNew, hcNew,
    NewItem('~O~pen...', 'F3', kbF3, cmOpen, hcOpen,
    NewItem('~S~ave', 'F2', kbF2, cmSave, hcSave,
    NewItem('S~a~ve as...', '', kbNoKey, cmSaveAs, hcSaveAs,
    NewItem('Save a~l~l', '', kbNoKey, cmSaveAll, hcSaveAll,
    NewLine(
    NewItem('~C~hange dir...', '', kbNoKey, cmChangeDir,hcChangeDir,
    NewItem('OS shell', '', kbNoKey, cmDosShell, hcDosShell,
    NewItem('E~x~it', 'Alt+X', kbAltX, cmQuit, hcExit)))))))));
end;

{---------------------------------------------------------------------------}
{  StdEditMenuItems -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB  }
{---------------------------------------------------------------------------}
function StdEditMenuItems(Next: TMenuItem): TMenuItem;
begin
  StdEditMenuItems :=
    NewItem('~U~ndo', '', kbAltBack, cmUndo, hcUndo,
    NewLine(
    NewItem('Cu~t~', 'Shift+Del', kbShiftDel, cmCut, hcCut,
    NewItem('~C~opy', 'Ctrl+Ins', kbCtrlIns, cmCopy, hcCopy,
    NewItem('~P~aste', 'Shift+Ins', kbShiftIns, cmPaste, hcPaste,
    NewItem('C~l~ear', 'Ctrl+Del', kbCtrlDel, cmClear, hcClear,Next))))));
end;

{---------------------------------------------------------------------------}
{ StdWindowMenuItems -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB }
{---------------------------------------------------------------------------}
function StdWindowMenuItems(Next: TMenuItem): TMenuItem;
begin
  StdWindowMenuItems :=
    NewItem('~T~ile', '', kbNoKey, cmTile, hcTile,
    NewItem('C~a~scade', '', kbNoKey, cmCascade, hcCascade,
    NewItem('Cl~o~se all', '', kbNoKey, cmCloseAll, hcCloseAll,
    NewLine(
    NewItem('~S~ize/Move', 'Ctrl+F5', kbCtrlF5, cmResize, hcResize,
    NewItem('~Z~oom', 'F5', kbF5, cmZoom, hcZoom,
    NewItem('~N~ext', 'F6', kbF6, cmNext, hcNext,
    NewItem('~P~revious', 'Shift+F6', kbShiftF6, cmPrev, hcPrev,
    NewItem('~C~lose', 'Alt+F3', kbAltF3, cmClose, hcClose, Next)))))))));
end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           OBJECT REGISTER ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  RegisterApp -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure RegisterApp;
begin
  //RegisterType(RBackground);                         { Register background }
  //RegisterType(RDesktop);                            { Register desktop }
end;

end.
