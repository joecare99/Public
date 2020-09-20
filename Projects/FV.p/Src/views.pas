{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}
{                                                          }
{   System independent GRAPHICAL clone of VIEWS.PAS        }
{                                                          }
{   Interface Copyright (c) 1992 Borland International     }
{                                                          }
{   Copyright (c) 1996, 1997, 1998, 1999 by Leon de Boer   }
{   ldeboer@attglobal.net  - primary e-mail address        }
{   ldeboer@starwon.com.au - backup e-mail address         }
{                                                          }
{****************[ THIS CODE IS FREEWARE ]*****************}
{                                                          }
{     This sourcecode is released for the purpose to       }
{   promote the pascal language on all platforms. You may  }
{   redistribute it and/or modify with the following       }
{   DISCLAIMER.                                            }
{                                                          }
{     This SOURCE CODE is distributed "AS IS" WITHOUT      }
{   WARRANTIES AS TO PERFORMANCE OF MERCHANTABILITY OR     }
{   ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED.     }
{                                                          }
{*****************[ SUPPORTED PLATFORMS ]******************}
{                                                          }
{ Only Free Pascal Compiler supported                      }
{                                                          }
{**********************************************************}

unit Views;

{ $CODEPAGE cp437}

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
interface

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$X+}{ Extended syntax is ok }
{$R-}{ Disable range checking }
{$S-}{ Disable Stack Checking }
{$I-}{ Disable IO Checking }
{$Q-}{ Disable Overflow Checking }
{$V-}{ Turn off strict VAR strings }
{====================================================================}

uses
   {$IFDEF OS_WINDOWS}                                { WIN/NT CODE }
 //        Windows,                                     { Standard unit }
   {$ENDIF}

   {$IFDEF OS_OS2}                                    { OS2 CODE }
     Os2Def, DosCalls, PmWin,
   {$ENDIF}

    Objects, FVCommon, Drivers, fvconsts;              { GFV standard units }

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                              TView STATE MASKS                            }
{---------------------------------------------------------------------------}
const
    sfVisible = $0001;                               { View visible mask }
    sfCursorVis = $0002;                               { Cursor visible }
    sfCursorIns = $0004;                               { Cursor insert mode }
    sfShadow = $0008;                               { View has shadow }
    sfActive = $0010;                               { View is active }
    sfSelected = $0020;                               { View is selected }
    sfFocused = $0040;                               { View is focused }
    sfDragging = $0080;                               { View is dragging }
    sfDisabled = $0100;                               { View is disabled }
    sfModal = $0200;                               { View is modal }
    sfDefault = $0400;                               { View is default }
    sfExposed = $0800;                               { View is exposed }
    sfIconised = $1000;                               { View is iconised }

{---------------------------------------------------------------------------}
{                             TView OPTION MASKS                            }
{---------------------------------------------------------------------------}
const
    ofSelectable = $0001;                             { View selectable }
    ofTopSelect = $0002;                             { Top selectable }
    ofFirstClick = $0004;                             { First click react }
    ofFramed = $0008;                             { View is framed }
    ofPreProcess = $0010;                             { Pre processes }
    ofPostProcess = $0020;                             { Post processes }
    ofBuffered = $0040;                             { View is buffered }
    ofTileable = $0080;                             { View is tileable }
    ofCenterX = $0100;                             { View centred on x }
    ofCenterY = $0200;                             { View centred on y }
    ofCentered = $0300;                             { View x,y centred }
    ofValidate = $0400;                             { View validates }
    ofVersion = $3000;                             { View TV version }
    ofVersion10 = $0000;                             { TV version 1 view }
    ofVersion20 = $1000;                             { TV version 2 view }

{---------------------------------------------------------------------------}
{                            TView GROW MODE MASKS                          }
{---------------------------------------------------------------------------}
const
    gfGrowLoX = $01;                                   { Left side grow }
    gfGrowLoY = $02;                                   { Top side grow  }
    gfGrowHiX = $04;                                   { Right side grow }
    gfGrowHiY = $08;                                   { Bottom side grow }
    gfGrowAll = $0F;                                   { Grow on all sides }
    gfGrowRel = $10;                                   { Grow relative }

{---------------------------------------------------------------------------}
{                           TView DRAG MODE MASKS                           }
{---------------------------------------------------------------------------}
const
    dmDragMove = $01;                                  { Move view }
    dmDragGrow = $02;                                  { Grow view }
    dmLimitLoX = $10;                                  { Limit left side }
    dmLimitLoY = $20;                                  { Limit top side }
    dmLimitHiX = $40;                                  { Limit right side }
    dmLimitHiY = $80;                                  { Limit bottom side }
    dmLimitAll = $F0;                                  { Limit all sides }

{---------------------------------------------------------------------------}
{                       >> NEW << TAB OPTION MASKS                          }
{---------------------------------------------------------------------------}
const
    tmTab = $01;                                  { Tab move mask }
    tmShiftTab = $02;                                  { Shift+tab move mask }
    tmEnter = $04;                                  { Enter move mask }
    tmLeft = $08;                                  { Left arrow move mask }
    tmRight = $10;                                  { Right arrow move mask }
    tmUp = $20;                                  { Up arrow move mask }
    tmDown = $40;                                  { Down arrow move mask }

{---------------------------------------------------------------------------}
{                        >> NEW << VIEW DRAW MASKS                          }
{---------------------------------------------------------------------------}
const
    vdBackGnd = $01;                                   { Draw backgound }
    vdInner = $02;                                   { Draw inner detail }
    vdCursor = $04;                                   { Draw cursor }
    vdBorder = $08;                                   { Draw view border }
    vdFocus = $10;                                   { Draw focus state }
    vdNoChild = $20;                                   { Draw no children }
    vdShadow = $40;
    vdAll = vdBackGnd + vdInner + vdCursor + vdBorder + vdFocus + vdShadow;

{---------------------------------------------------------------------------}
{                            TView HELP CONTEXTS                            }
{---------------------------------------------------------------------------}
const
    hcNoContext = 0;                                   { No view context }
    hcDragging = 1;                                   { No drag context }

{---------------------------------------------------------------------------}
{                             TWindow FLAG MASKS                            }
{---------------------------------------------------------------------------}
const
    wfMove = $01;                                     { Window can move }
    wfGrow = $02;                                     { Window can grow }
    wfClose = $04;                                     { Window can close }
    wfZoom = $08;                                     { Window can zoom }

{---------------------------------------------------------------------------}
{                              TWindow PALETTES                             }
{---------------------------------------------------------------------------}
const
    wpBlueWindow = 0;                                  { Blue palette }
    wpCyanWindow = 1;                                  { Cyan palette }
    wpGrayWindow = 2;                                  { Gray palette }

{---------------------------------------------------------------------------}
{                              COLOUR PALETTES                              }
{---------------------------------------------------------------------------}
const
    CFrame = #1#1#2#2#3;                          { Frame palette }
    CScrollBar = #4#5#5;                              { Scrollbar palette }
    CScroller = #6#7;                                { Scroller palette }
    CListViewer = #26#26#27#28#29;                     { Listviewer palette }

    CBlueWindow = #8#9#10#11#12#13#14#15;              { Blue window palette }
    CCyanWindow = #16#17#18#19#20#21#22#23;            { Cyan window palette }
    CGrayWindow = #24#25#26#27#28#29#30#31;            { Grey window palette }

{---------------------------------------------------------------------------}
{                           TScrollBar PART CODES                           }
{---------------------------------------------------------------------------}
const
    sbLeftArrow = 0;                                  { Left arrow part }
    sbRightArrow = 1;                                  { Right arrow part }
    sbPageLeft = 2;                                  { Page left part }
    sbPageRight = 3;                                  { Page right part }
    sbUpArrow = 4;                                  { Up arrow part }
    sbDownArrow = 5;                                  { Down arrow part }
    sbPageUp = 6;                                  { Page up part }
    sbPageDown = 7;                                  { Page down part }
    sbIndicator = 8;                                  { Indicator part }

{---------------------------------------------------------------------------}
{              TScrollBar OPTIONS FOR TWindow.StandardScrollBar             }
{---------------------------------------------------------------------------}
const
    sbHorizontal = $0000;                          { Horz scrollbar }
    sbVertical = $0001;                          { Vert scrollbar }
    sbHandleKeyboard = $0002;                          { Handle keyboard }

{---------------------------------------------------------------------------}
{                            STANDARD COMMAND CODES                         }
{---------------------------------------------------------------------------}
const
    cmValid = 0;                                     { Valid command }
    cmQuit = 1;                                     { Quit command }
    cmError = 2;                                     { Error command }
    cmMenu = 3;                                     { Menu command }
    cmClose = 4;                                     { Close command }
    cmZoom = 5;                                     { Zoom command }
    cmResize = 6;                                     { Resize command }
    cmNext = 7;                                     { Next view command }
    cmPrev = 8;                                     { Prev view command }
    cmHelp = 9;                                     { Help command }
    cmOK = 10;                                    { Okay command }
    cmCancel = 11;                                    { Cancel command }
    cmYes = 12;                                    { Yes command }
    cmNo = 13;                                    { No command }
    cmDefault = 14;                                    { Default command }
    cmCut = 20;                                    { Clipboard cut cmd }
    cmCopy = 21;                                    { Clipboard copy cmd }
    cmPaste = 22;                                    { Clipboard paste cmd }
    cmUndo = 23;                                    { Clipboard undo cmd }
    cmClear = 24;                                    { Clipboard clear cmd }
    cmTile = 25;                                    { Tile subviews cmd }
    cmCascade = 26;                                    { Cascade subviews cmd }
    cmReceivedFocus = 50;                          { Received focus }
    cmReleasedFocus = 51;                          { Released focus }
    cmCommandSetChanged = 52;                          { Commands changed }
    cmScrollBarChanged = 53;                          { Scrollbar changed }
    cmScrollBarClicked = 54;                          { Scrollbar clicked on }
    cmSelectWindowNum = 55;                          { Select window }
    cmListItemSelected = 56;                          { Listview item select }

    cmNotify = 27;
    cmIdCommunicate = 28;                          { Communicate via id }
    cmIdSelect = 29;                          { Select via id }

{---------------------------------------------------------------------------}
{                          TWindow NUMBER CONSTANTS                         }
{---------------------------------------------------------------------------}
const
    wnNoNumber = 0;                                    { Window has no num }
    MaxViewWidth = 255;                                { Max view width }


{***************************************************************************}
{                          PUBLIC TYPE DEFINITIONS                          }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                            TWindow Title string                           }
{---------------------------------------------------------------------------}
type
    TTitleStr = string

        [80];                            { Window title string }

{---------------------------------------------------------------------------}
{                            COMMAND SET RECORD                             }
{---------------------------------------------------------------------------}
type
    TCommandSet = set of byte;                         { Command set record }
    PCommandSet = ^TCommandSet;                        { Ptr to command set }

{---------------------------------------------------------------------------}
{                              PALETTE RECORD                               }
{---------------------------------------------------------------------------}
type
    TPalette = string;                                 { Palette record }
    PPalette = ^TPalette;                              { Pointer to palette }

{---------------------------------------------------------------------------}
{                            TDrawBuffer RECORD                             }
{---------------------------------------------------------------------------}
type
    TDrawBuffer = array [0..MaxViewWidth - 1] of word; { Draw buffer record }
    PDrawBuffer = ^TDrawBuffer;                        { Ptr to draw buffer }

{---------------------------------------------------------------------------}
{                           TVideoBuffer RECORD                             }
{---------------------------------------------------------------------------}
type
    TVideoBuf = array [0..3999] of word;               { Video buffer }
    PVideoBuf = ^TVideoBuf;                            { Pointer to buffer }

{---------------------------------------------------------------------------}
{                            TComplexArea RECORD                            }
{---------------------------------------------------------------------------}
type
    PComplexArea = ^TComplexArea;                      { Complex area }

    TComplexArea =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
        packed
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}   record
        X1, Y1: Sw_Integer;                              { Top left corner }
        X2, Y2: Sw_Integer;                              { Lower right corner }
        NextArea: PComplexArea;                         { Next area pointer }
    end;

{***************************************************************************}
{                        PUBLIC OBJECT DEFINITIONS                          }
{***************************************************************************}

type
    PGroup = ^TGroup;                                  { Pointer to group }

    {---------------------------------------------------------------------------}
    {                    TView OBJECT - ANCESTOR VIEW OBJECT                    }
    {---------------------------------------------------------------------------}
    PView = ^TView;

    TView = object(TObject)
        GrowMode: byte;                             { View grow mode }
        DragMode: byte;                             { View drag mode }
        TabMask: byte;                             { Tab move masks }
        ColourOfs: Sw_Integer;                          { View palette offset }
        HelpCtx: word;                             { View help context }
        State: word;                             { View state masks }
        Options: word;                             { View options masks }
        EventMask: word;                             { View event masks }
        Origin: TPoint;                           { View origin }
        Size: TPoint;                           { View size }
        Cursor: TPoint;                           { Cursor position }
        Next: PView;                            { Next peerview }
        Owner: PGroup;                           { Owner group }
        HoldLimit: PComplexArea;                     { Hold limit values }

        RevCol: boolean;
        BackgroundChar: char;

        constructor Init(const Bounds: TRect);
        constructor Load(var S: TStream);
        destructor Done; virtual;
        function Prev: PView;
        function Execute: word; virtual;
        function Focus: boolean;
        function DataSize: Sw_Word; virtual;
        function TopView: PView;
        function PrevView: PView;
        function NextView: PView;
        function GetHelpCtx: word; virtual;
        function EventAvail: boolean;
        function GetPalette: PPalette; virtual;
        function MapColor(color: byte): byte;
        function GetColor(Color: word): word;
        function Valid(Command: word): boolean; virtual;
        function GetState(AState: word): boolean;
        function TextWidth(const Txt: string): Sw_Integer;
        function CTextWidth(const Txt: string): Sw_Integer;
        function MouseInView(Point: TPoint): boolean;
        function CommandEnabled(Command: word): boolean;
        function OverLapsArea(X1, Y1, X2, Y2: Sw_Integer): boolean;
        function MouseEvent(var Event: TEvent; Mask: word): boolean;
        procedure Hide;
        procedure Show;
        procedure Draw; virtual;
        procedure ResetCursor; virtual;
        procedure Select;
        procedure Awaken; virtual;
        procedure DrawView;
        procedure MakeFirst;
        procedure DrawCursor; virtual;
        procedure HideCursor;
        procedure ShowCursor;
        procedure BlockCursor;
        procedure NormalCursor;
        procedure FocusFromTop; virtual;
        procedure MoveTo(X, Y: Sw_Integer);
        procedure GrowTo(X, Y: Sw_Integer);
        procedure EndModal(Command: word); virtual;
        procedure SetCursor(X, Y: Sw_Integer);
        procedure PutInFrontOf(Target: PView);
        procedure SetCommands(Commands: TCommandSet);
        procedure EnableCommands(Commands: TCommandSet);
        procedure DisableCommands(Commands: TCommandSet);
        procedure SetState(AState: word; Enable: boolean); virtual;
        procedure SetCmdState(Commands: TCommandSet; Enable: boolean);
        procedure GetData(var Rec); virtual;
        procedure SetData(const Rec); virtual;
        procedure Store(var S: TStream);
        procedure Locate(var Bounds: TRect);
        procedure KeyEvent(var Event: TEvent);
        procedure GetEvent(var Event: TEvent); virtual;
        procedure PutEvent(var Event: TEvent); virtual;
        procedure GetExtent({$IfDef FPC_OBJFPC}out{$else}var{$endif} Extent: TRect);
        procedure GetBounds({$IfDef FPC_OBJFPC}out{$else}var{$endif} Bounds: TRect);
        procedure SetBounds(const Bounds: TRect);
        procedure GetClipRect(var Clip: TRect);
        procedure ClearEvent(var Event: TEvent);
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure ChangeBounds(const Bounds: TRect); virtual;
        procedure SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} Min, Max: TPoint); virtual;
        procedure GetCommands({$IfDef FPC_OBJFPC}out{$else}var{$endif} Commands: TCommandSet);
        procedure GetPeerViewPtr(var S: TStream; var P);
        procedure PutPeerViewPtr(var S: TStream; P: PView);
        procedure CalcBounds(var Bounds: TRect; Delta: TPoint); virtual;

        function Exposed: boolean;   { This needs help!!!!! }
        procedure WriteBuf(X, Y, W, H: Sw_Integer; var Buf);
        procedure WriteLine(X, Y, W, H: Sw_Integer; var Buf);
        procedure MakeLocal(Source: TPoint;
 {$IfDef FPC_OBJFPC}out{$else}var{$endif} Dest: TPoint);
        procedure MakeGlobal(Source: TPoint;
 {$IfDef FPC_OBJFPC}out{$else}var{$endif} Dest: TPoint);
        procedure WriteStr(X, Y: Sw_Integer; Str: string; Color: byte);
        procedure WriteChar(X, Y: Sw_Integer; C: char; Color: byte;
            Count: Sw_Integer);
        procedure DragView(Event: TEvent; Mode: byte; var Limits: TRect;
            MinSize, MaxSize: TPoint);
    private
        procedure CursorChanged;
        procedure DrawHide(LastView: PView);
        procedure DrawShow(LastView: PView);
        procedure DrawUnderRect(var R: TRect; LastView: PView);
        procedure DrawUnderView(DoShadow: boolean; LastView: PView);
        procedure do_WriteView(x1, x2, y: Sw_Integer; var Buf);
        procedure do_WriteViewRec1(x1, x2: Sw_integer; p: PView; shadowCounter: Sw_integer);
        procedure do_WriteViewRec2(x1, x2: Sw_integer; p: PView; shadowCounter: Sw_integer);
        function do_ExposedRec1(x1, x2: Sw_integer; p: PView): boolean;
        function do_ExposedRec2(x1, x2: Sw_integer; p: PView): boolean;
    end;

    SelectMode = (NormalSelect, EnterSelect, LeaveSelect);

    {---------------------------------------------------------------------------}
    {                  TGroup OBJECT - GROUP OBJECT ANCESTOR                    }
    {---------------------------------------------------------------------------}
{$ifndef TYPED_LOCAL_CALLBACKS}
    TGroupFirstThatCallback = CodePointer;
{$else}
   TGroupFirstThatCallback = Function(View: PView): Boolean is nested;
{$endif}

    TGroup = object(TView)
        Phase: (phFocused, phPreProcess, phPostProcess);
        EndState: word;                              { Modal result }
        Current: PView;                             { Selected subview }
        Last: PView;                             { 1st view inserted }
        Buffer: PVideoBuf;                         { Speed up buffer }
        constructor Init(const Bounds: TRect);
        constructor Load(var S: TStream);
        destructor Done; virtual;
        function First: PView;
        function Execute: word; virtual;
        function GetHelpCtx: word; virtual;
        function DataSize: Sw_Word; virtual;
        function ExecView(P: PView): word; virtual;
        function FirstThat(P: TGroupFirstThatCallback): PView;
        function Valid(Command: word): boolean; virtual;
        function FocusNext(Forwards: boolean): boolean;
        procedure Draw; virtual;
        procedure Lock;
        procedure UnLock;
        procedure ResetCursor; virtual;
        procedure Awaken; virtual;
        procedure ReDraw;
        procedure SelectDefaultView;
        procedure Insert(P: PView);
        procedure Delete(P: PView);
        procedure ForEach(P: TCallbackProcParam);
        { ForEach can't be virtual because it generates SIGSEGV }
        procedure EndModal(Command: word); virtual;
        procedure SelectNext(Forwards: boolean);
        procedure InsertBefore(P, Target: PView);
        procedure SetState(AState: word; Enable: boolean); virtual;
        procedure GetData(var Rec); virtual;
        procedure SetData(const Rec); virtual;
        procedure Store(var S: TStream);
        procedure EventError(var Event: TEvent); virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure ChangeBounds(const Bounds: TRect); virtual;
        procedure GetSubViewPtr(var S: TStream; var P);
        procedure PutSubViewPtr(var S: TStream; P: PView);
        function ClipChilds: boolean; virtual;
        procedure BeforeInsert(P: PView); virtual;
        procedure AfterInsert(P: PView); virtual;
        procedure BeforeDelete(P: PView); virtual;
        procedure AfterDelete(P: PView); virtual;

    private
        LockFlag: byte;
        Clip: TRect;
        function IndexOf(P: PView): Sw_Integer;
        function FindNext(Forwards: boolean): PView;
        function FirstMatch(AState: word; AOptions: word): PView;
        procedure ResetCurrent;
        procedure RemoveView(P: PView);
        procedure InsertView(P, Target: PView);
        procedure SetCurrent(P: PView; Mode: SelectMode);
        procedure DrawSubViews(P, Bottom: PView);
    end;

{---------------------------------------------------------------------------}
{                    TFrame OBJECT - FRAME VIEW OBJECT                      }
{---------------------------------------------------------------------------}
type
    TFrame = object(TView)
        constructor Init(var Bounds: TRect);
        function GetPalette: PPalette; virtual;
        procedure Draw; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SetState(AState: word; Enable: boolean); virtual;
    private
        FrameMode: word;
        procedure FrameLine(var FrameBuf; Y, N: Sw_Integer; Color: byte);
    end;
    PFrame = ^TFrame;

{---------------------------------------------------------------------------}
{                   TScrollBar OBJECT - SCROLL BAR OBJECT                   }
{---------------------------------------------------------------------------}
type
    TScrollChars = array [0..4] of char;

    TScrollBar = object(TView)
        Value: Sw_Integer;                             { Scrollbar value }
        Min: Sw_Integer;                             { Scrollbar minimum }
        Max: Sw_Integer;                             { Scrollbar maximum }
        PgStep: Sw_Integer;                             { One page step }
        ArStep: Sw_Integer;                             { One range step }
        Id: Sw_Integer;                             { Scrollbar ID }
        constructor Init(var Bounds: TRect);
        constructor Load(var S: TStream);
        function GetPalette: PPalette; virtual;
        function ScrollStep(Part: Sw_Integer): Sw_Integer; virtual;
        procedure Draw; virtual;
        procedure ScrollDraw; virtual;
        procedure SetValue(AValue: Sw_Integer);
        procedure SetRange(AMin, AMax: Sw_Integer);
        procedure SetStep(APgStep, AArStep: Sw_Integer);
        procedure SetParams(AValue, AMin, AMax, APgStep, AArStep: Sw_Integer);
        procedure Store(var S: TStream);
        procedure HandleEvent(var Event: TEvent); virtual;
    private
        Chars: TScrollChars;                         { Scrollbar chars }
        function GetPos: Sw_Integer;
        function GetSize: Sw_Integer;
        procedure DrawPos(Pos: Sw_Integer);
    end;
    PScrollBar = ^TScrollBar;

{---------------------------------------------------------------------------}
{                 TScroller OBJECT - SCROLLING VIEW ANCESTOR                }
{---------------------------------------------------------------------------}
type
    TScroller = object(TView)
        Delta: TPoint;
        Limit: TPoint;
        HScrollBar: PScrollBar;                      { Horz scroll bar }
        VScrollBar: PScrollBar;                      { Vert scroll bar }
        constructor Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar);
        constructor Load(var S: TStream);
        function GetPalette: PPalette; virtual;
        procedure ScrollDraw; virtual;
        procedure SetLimit(X, Y: Sw_Integer);
        procedure ScrollTo(X, Y: Sw_Integer);
        procedure SetState(AState: word; Enable: boolean); virtual;
        procedure Store(var S: TStream);
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure ChangeBounds(const Bounds: TRect); virtual;
    private
        DrawFlag: boolean;
        DrawLock: byte;
        procedure CheckDraw;
    end;
    PScroller = ^TScroller;

{---------------------------------------------------------------------------}
{                  TListViewer OBJECT - LIST VIEWER OBJECT                  }
{---------------------------------------------------------------------------}
type
    TListViewer = object(TView)
        NumCols: Sw_Integer;                         { Number of columns }
        TopItem: Sw_Integer;                         { Top most item }
        Focused: Sw_Integer;                         { Focused item }
        Range: Sw_Integer;                         { Range of listview }
        HScrollBar: PScrollBar;                      { Horz scrollbar }
        VScrollBar: PScrollBar;                      { Vert scrollbar }
        constructor Init(var Bounds: TRect; ANumCols: Sw_Word;
            AHScrollBar, AVScrollBar: PScrollBar);
        constructor Load(var S: TStream);
        function GetPalette: PPalette; virtual;
        function IsSelected(Item: Sw_Integer): boolean; virtual;
        function GetText(Item: Sw_Integer; MaxLen: Sw_Integer): string; virtual;
        procedure Draw; virtual;
        procedure FocusItem(Item: Sw_Integer); virtual;
        procedure SetTopItem(Item: Sw_Integer);
        procedure SetRange(ARange: Sw_Integer);
        procedure SelectItem(Item: Sw_Integer); virtual;
        procedure SetState(AState: word; Enable: boolean); virtual;
        procedure Store(var S: TStream);
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure ChangeBounds(const Bounds: TRect); virtual;
        procedure FocusItemNum(Item: Sw_Integer); virtual;
    end;
    PListViewer = ^TListViewer;

{---------------------------------------------------------------------------}
{                  TWindow OBJECT - WINDOW OBJECT ANCESTOR                  }
{---------------------------------------------------------------------------}
type
    TWindow = object(TGroup)
        Flags: byte;                              { Window flags }
        Number: Sw_Integer;                           { Window number }
        Palette: Sw_Integer;                           { Window palette }
        ZoomRect: TRect;                             { Zoom rectangle }
        Frame: PFrame;                            { Frame view object }
        Title: PString;                           { Title string }
        constructor Init(var Bounds: TRect; ATitle: TTitleStr; ANumber: Sw_Integer);
        constructor Load(var S: TStream);
        destructor Done; virtual;
        function GetPalette: PPalette; virtual;
        function GetTitle(MaxSize: Sw_Integer): TTitleStr; virtual;
        function StandardScrollBar(AOptions: word): PScrollBar;
        procedure Zoom; virtual;
        procedure Close; virtual;
        procedure InitFrame; virtual;
        procedure SetState(AState: word; Enable: boolean); virtual;
        procedure Store(var S: TStream);
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} Min, Max: TPoint); virtual;
    end;
    PWindow = ^TWindow;

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         WINDOW MESSAGE ROUTINES                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-Message------------------------------------------------------------
Message sets up an event record and calls Receiver^.HandleEvent to
handle the event. Message returns nil if Receiver is nil, or if
the event is not handled successfully.
12Sep97 LdB
---------------------------------------------------------------------}
function Message(Receiver: PView; What, Command: word; InfoPtr: Pointer): Pointer;

{-NewMessage---------------------------------------------------------
NewMessage sets up an event record including the new fields and calls
Receiver^.HandleEvent to handle the event. Message returns nil if
Receiver is nil, or if the event is not handled successfully.
19Sep97 LdB
---------------------------------------------------------------------}
function NewMessage(P: PView; What, Command: word; Id: Sw_Integer;
    Data: real; InfoPtr: Pointer): Pointer;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     VIEW OBJECT REGISTRATION ROUTINES                     }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{-RegisterViews------------------------------------------------------
This registers all the view type objects used in this unit.
11Aug99 LdB
---------------------------------------------------------------------}
procedure RegisterViews;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                            NEW VIEW ROUTINES                              }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-CreateIdScrollBar--------------------------------------------------
Creates and scrollbar object of the given size and direction and sets
the scrollbar id number.
22Sep97 LdB
---------------------------------------------------------------------}
function CreateIdScrollBar(X, Y, Size, Id: Sw_Integer; Horz: boolean): PScrollBar;

{***************************************************************************}
{                        INITIALIZED PUBLIC VARIABLES                       }
{***************************************************************************}


{---------------------------------------------------------------------------}
{                 INITIALIZED DOS/DPMI/WIN/NT/OS2 VARIABLES                 }
{---------------------------------------------------------------------------}
const
    UseNativeClasses: boolean = True;                  { Native class modes }
    CommandSetChanged: boolean = False;                { Command change flag }
    ShowMarkers: boolean = False;                      { Show marker state }
    ErrorAttr: byte = $CF;                             { Error colours }
    PositionalEvents: word = evMouse;                  { Positional defined }
    FocusedEvents: word = evKeyboard + evCommand;      { Focus defined }
    MinWinSize: TPoint = (X: 16; Y: 6);                { Minimum window size }
    ShadowSize: TPoint = (X: 2; Y: 1);                 { Shadow sizes }
    ShadowAttr: byte = $08;                            { Shadow attribute }

    { Characters used for drawing selected and default items in  }
    { monochrome color sets                                      }
    SpecialChars: array [0..5] of char = (#175, #174, #26, #27, ' ', ' ');

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        STREAM REGISTRATION RECORDS                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{                         TView STREAM REGISTRATION                         }
{---------------------------------------------------------------------------}
const
    RView: TStreamRec = (
        ObjType: idView;                                 { Register id = 1 }
        VmtLink: TypeOf(TView);                          { Alt style VMT link }
        Load: @TView.Load;                            { Object load method }
        Store: @TView.Store{%H-}                            { Object store method }
        );

{---------------------------------------------------------------------------}
{                        TFrame STREAM REGISTRATION                         }
{---------------------------------------------------------------------------}
const
    RFrame: TStreamRec = (
        ObjType: idFrame;                                { Register id = 2 }
        VmtLink: TypeOf(TFrame);                         { Alt style VMT link }
        Load: @TFrame.Load;                           { Frame load method }
        Store: @TFrame.Store{%H-}                           { Frame store method }
        );

{---------------------------------------------------------------------------}
{                      TScrollBar STREAM REGISTRATION                       }
{---------------------------------------------------------------------------}
const
    RScrollBar: TStreamRec = (
        ObjType: idScrollBar;                            { Register id = 3 }
        VmtLink: TypeOf(TScrollBar);                     { Alt style VMT link }
        Load: @TScrollBar.Load;                       { Object load method }
        Store: @TScrollBar.Store{%H-}                       { Object store method }
        );

{---------------------------------------------------------------------------}
{                       TScroller STREAM REGISTRATION                       }
{---------------------------------------------------------------------------}
const
    RScroller: TStreamRec = (
        ObjType: idScroller;                             { Register id = 4 }
        VmtLink: TypeOf(TScroller);                      { Alt style VMT link }
        Load: @TScroller.Load;                        { Object load method }
        Store: @TScroller.Store{%H-}                        { Object store method }
        );

{---------------------------------------------------------------------------}
{                      TListViewer STREAM REGISTRATION                      }
{---------------------------------------------------------------------------}
const
    RListViewer: TStreamRec = (
        ObjType: idListViewer;                           { Register id = 5 }
        VmtLink: TypeOf(TListViewer);                    { Alt style VMT link }
        Load: @TListViewer.Load;                      { Object load method }
        Store: @TLIstViewer.Store{%H-}                      { Object store method }
        );

{---------------------------------------------------------------------------}
{                        TGroup STREAM REGISTRATION                         }
{---------------------------------------------------------------------------}
const
    RGroup: TStreamRec = (
        ObjType: idGroup;                                { Register id = 6 }
        VmtLink: TypeOf(TGroup);                         { Alt style VMT link }
        Load: @TGroup.Load;                           { Object load method }
        Store: @TGroup.Store{%H-}                           { Object store method }
        );

{---------------------------------------------------------------------------}
{                        TWindow STREAM REGISTRATION                        }
{---------------------------------------------------------------------------}
const
    RWindow: TStreamRec = (
        ObjType: idWindow;                               { Register id = 7 }
        VmtLink: TypeOf(TWindow);                        { Alt style VMT link }
        Load: @TWindow.Load;                          { Object load method }
        Store: @TWindow.Store{%H-}                          { Object store method }
        );


{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
implementation

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

uses
    Video;

{***************************************************************************}
{                       PRIVATE TYPE DEFINITIONS                            }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                         TFixupList DEFINITION                             }
{---------------------------------------------------------------------------}
type
    TFixupList = array [1..4096] of Pointer;           { Fix up ptr array }
    PFixupList = ^TFixupList;                          { Ptr to fix up list }

{***************************************************************************}
{                      PRIVATE INITIALIZED VARIABLES                        }
{***************************************************************************}

{---------------------------------------------------------------------------}
{            INITIALIZED DOS/DPMI/WIN/NT/OS2 PRIVATE VARIABLES              }
{---------------------------------------------------------------------------}
const
    TheTopView: PView = nil;                         { Top focused view }
    LimitsLocked: PView = nil;                         { View locking limits }
    OwnerGroup: PGroup = nil;                        { Used for loading }
    FixupList: PFixupList = nil;                    { Used for loading }
    CurCommandSet: TCommandSet =
        ([0..255] - [cmZoom, cmClose, cmResize, cmNext, cmPrev]);
    { All active but these }

    vdInSetCursor = $80;                               { AVOID RECURSION IN SetCursor }

    { Flags for TFrame }
    fmCloseClicked = $01;
    fmZoomClicked = $02;


type
    TstatVar2 = record
        target: PView;
        offset, y: integer;
    end;

var
    staticVar1: PDrawBuffer;
    staticVar2: TstatVar2;


{***************************************************************************}
{                          PRIVATE INTERNAL ROUTINES                        }
{***************************************************************************}

function posidx(const substr, s: string; idx: sw_integer): sw_integer;
var
    i, j: sw_integer;
    e: boolean;
begin
    i := idx;
    j := 0;
    e := (length(SubStr) > 0);
    while e and (i <= Length(s) - Length(SubStr)) do
      begin
        if (SubStr[1] = s[i]) and (Substr = Copy(s, i, Length(SubStr))) then
          begin
            j := i;
            e := False;
          end;
        Inc(i);
      end;
    PosIdx := j;
end;


{$ifdef UNIX}
const
  MouseUsesVideoBuf = true;
{$else not UNIX}

const
    MouseUsesVideoBuf = False;

{$endif not UNIX}

procedure DrawScreenBuf(force: boolean);
begin
    if (GetLockScreenCount = 0) then
      begin
{     If MouseUsesVideoBuf then
       begin
         LockScreenUpdate;
         HideMouse;
         ShowMouse;
         UnlockScreenUpdate;
       end
     else
       HideMouse;}
        UpdateScreen(force);
{     If not MouseUsesVideoBuf then
       ShowMouse;}
      end;
end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         VIEW PORT CONTROL ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

type
    ViewPortType = record
        X1, Y1, X2, Y2: integer;                         { Corners of viewport }
        Clip: boolean;                         { Clip status }
    end;

var
    ViewPort: ViewPortType;

{---------------------------------------------------------------------------}
{  GetViewSettings -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Dec2000 LdB }
{---------------------------------------------------------------------------}
procedure GetViewSettings(var CurrentViewPort: ViewPortType);
begin
    CurrentViewPort := ViewPort;                       { Textmode viewport }
end;

{---------------------------------------------------------------------------}
{  SetViewPort -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Dec2000 LdB     }
{---------------------------------------------------------------------------}
procedure SetViewPort(X1, Y1, X2, Y2: integer; Clip: boolean);
begin
    if (X1 < 0) then
        X1 := 0;                        { X1 negative fix }
    if (X1 > ScreenWidth) then
        X1 := ScreenWidth;                             { X1 off screen fix }
    if (Y1 < 0) then
        Y1 := 0;                        { Y1 negative fix }
    if (Y1 > ScreenHeight) then
        Y1 := ScreenHeight;                            { Y1 off screen fix }
    if (X2 < 0) then
        X2 := 0;                        { X2 negative fix }
    if (X2 > ScreenWidth) then
        X2 := ScreenWidth;                             { X2 off screen fix }
    if (Y2 < 0) then
        Y2 := 0;                        { Y2 negative fix }
    if (Y2 > ScreenHeight) then
        Y2 := ScreenHeight;                            { Y2 off screen fix }
    ViewPort.X1 := X1;                               { Set X1 port value }
    ViewPort.Y1 := Y1;                               { Set Y1 port value }
    ViewPort.X2 := X2;                               { Set X2 port value }
    ViewPort.Y2 := Y2;                               { Set Y2 port value }
    ViewPort.Clip := Clip;                           { Set port clip value }
{ $ifdef DEBUG
     If WriteDebugInfo then
       Writeln(stderr,'New ViewPort(',X1,',',Y1,',',X2,',',Y2,')');
 $endif DEBUG}
end;

{***************************************************************************}
{                              OBJECT METHODS                               }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                            TView OBJECT METHODS                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TView--------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 20Jun96 LdB              }
{---------------------------------------------------------------------------}
constructor TView.Init(const Bounds: TRect);
begin
    inherited Init;                                    { Call ancestor }
    DragMode := dmLimitLoY;                            { Default drag mode }
    HelpCtx := hcNoContext;                            { Clear help context }
    State := sfVisible;                                { Default state }
    EventMask := evMouseDown + evKeyDown + evCommand;  { Default event masks }
    BackgroundChar := ' ';
    SetBounds(Bounds);                                 { Set view bounds }
end;

{--TView--------------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06May98 LdB              }
{---------------------------------------------------------------------------}
{   This load method will read old original TV data from a stream but the   }
{  new options and tabmasks are not set so some NEW functionality is not    }
{  supported but it should work as per original TV code.                    }
{---------------------------------------------------------------------------}
constructor TView.Load(var S: TStream);
var
    i: integer = 0;
begin
    inherited Init;                                    { Call ancestor }
    S.Read(i, SizeOf(i));
    Origin.X := i;                 { Read origin x value }
    S.Read(i, SizeOf(i));
    Origin.Y := i;                 { Read origin y value }
    S.Read(i, SizeOf(i));
    Size.X := i;                   { Read view x size }
    S.Read(i, SizeOf(i));
    Size.Y := i;                   { Read view y size }
    S.Read(i, SizeOf(i));
    Cursor.X := i;                 { Read cursor x size }
    S.Read(i, SizeOf(i));
    Cursor.Y := i;                 { Read cursor y size }
    S.Read(GrowMode, SizeOf(GrowMode));                { Read growmode flags }
    S.Read(DragMode, SizeOf(DragMode));                { Read dragmode flags }
    S.Read(HelpCtx, SizeOf(HelpCtx));                  { Read help context }
    S.Read(State, SizeOf(State));                      { Read state masks }
    S.Read(Options, SizeOf(Options));                  { Read options masks }
    S.Read(Eventmask, SizeOf(Eventmask));              { Read event masks }
end;

{--TView--------------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Nov99 LdB              }
{---------------------------------------------------------------------------}
destructor TView.Done;
var
    P: PComplexArea;
begin
    Hide;                                              { Hide the view }
    if (Owner <> nil) then
        Owner^.Delete(@Self);       { Delete from owner }
    while (HoldLimit <> nil) do
      begin                  { Free limit memory }
        P := HoldLimit^.NextArea;                        { Hold next pointer }
        FreeMem(HoldLimit, SizeOf(TComplexArea));        { Release memory }
        HoldLimit := P;                                  { Shuffle to next }
      end;
end;

{--TView--------------------------------------------------------------------}
{  Prev -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
function TView.Prev: PView;
var
    NP: PView;
begin
    Prev := @Self;
    NP := Next;
    while (NP <> nil) and (NP <> @Self) do
      begin
        Prev := NP;                                       { Locate next view }
        NP := NP^.Next;
      end;
end;

{--TView--------------------------------------------------------------------}
{  Execute -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB           }
{---------------------------------------------------------------------------}
function TView.Execute: word;
begin
    Execute := cmCancel;                               { Return cancel }
end;

{--TView--------------------------------------------------------------------}
{  Focus -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05May98 LdB             }
{---------------------------------------------------------------------------}
function TView.Focus: boolean;
var
    Res: boolean;
begin
    Res := True;                                       { Preset result }
    if (State and (sfSelected + sfModal) = 0) then
      begin { Not modal/selected }
        if (Owner <> nil) then
          begin                     { View has an owner }
            Res := Owner^.Focus;                           { Return focus state }
            if Res then                                    { Owner has focus }
                if ((Owner^.Current = nil) or                { No current view }
                    (Owner^.Current^.Options and ofValidate = 0) { Non validating view } or
                    (Owner^.Current^.Valid(cmReleasedFocus))) { Okay to drop focus } then
                    Select
                else
                    Res := False;             { Then select us }
          end;
      end;
    Focus := Res;                                      { Return focus result }
end;

{--TView--------------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
function TView.DataSize: Sw_Word;
begin
    DataSize := 0;                                     { Transfer size }
end;

{--TView--------------------------------------------------------------------}
{  TopView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB           }
{---------------------------------------------------------------------------}
function TView.TopView: PView;
var
    P: PView;
begin
    if (TheTopView = nil) then
      begin                   { Check topmost view }
        P := @Self;                                      { Start with us }
        while (P <> nil) and (P^.State and sfModal = 0)  { Check if modal } do
            P := P^.Owner;                              { Search each owner }
        TopView := P;                                    { Return result }
      end
    else
        TopView := TheTopView;                    { Return topview }
end;

{--TView--------------------------------------------------------------------}
{  PrevView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
function TView.PrevView: PView;
begin
    if (@Self = Owner^.First) then
        PrevView := nil     { We are first view }
    else
        PrevView := Prev;                           { Return our prior }
end;

{--TView--------------------------------------------------------------------}
{  NextView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
function TView.NextView: PView;
begin
    if (@Self = Owner^.Last) then
        NextView := nil      { This is last view }
    else
        NextView := Next;                           { Return our next }
end;

{--TView--------------------------------------------------------------------}
{  GetHelpCtx -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
function TView.GetHelpCtx: word;
begin
    if (State and sfDragging <> 0) then                { Dragging state check }
        GetHelpCtx := hcDragging
    else                    { Return dragging }
        GetHelpCtx := HelpCtx;                           { Return help context }
end;

{--TView--------------------------------------------------------------------}
{  EventAvail -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
function TView.EventAvail: boolean;
var
    Event: TEvent;
begin
    GetEvent(Event);                                   { Get next event }
    if (Event.What <> evNothing) then
        PutEvent(Event); { Put it back }
    EventAvail := (Event.What <> evNothing);           { Return result }
end;

{--TView--------------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
function TView.GetPalette: PPalette;
begin
    GetPalette := nil;                                 { Return nil ptr }
end;

{--TView--------------------------------------------------------------------}
{  MapColor -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Jul99 LdB          }
{---------------------------------------------------------------------------}
function TView.MapColor(color: byte): byte;
var
    cur: PView;
    p: PPalette;
begin
    if color = 0 then
        MapColor := errorAttr
    else
      begin
        cur := @Self;
        repeat
            p := cur^.GetPalette;
            if (p <> nil) then
                if length(p^) <> 0 then
                  begin
                    if color > length(p^) then
                      begin
                        MapColor := errorAttr;
                        Exit;
                      end;
                    color := Ord(p^[color]);
                    if color = 0 then
                      begin
                        MapColor := errorAttr;
                        Exit;
                      end;
                  end;
            cur := cur^.Owner;
        until (cur = nil);
        MapColor := color;
      end;
end;


{--TView--------------------------------------------------------------------}
{  GetColor -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Jul99 LdB          }
{---------------------------------------------------------------------------}
function TView.GetColor(Color: word): word;
var
    Col: byte;
    W: word;
    P: PPalette;
    Q: PView;
begin
    W := 0;                                            { Clear colour Sw_Word }
    if (Hi(Color) > 0) then
      begin                      { High colour req }
        Col := Hi(Color) + ColourOfs;                    { Initial offset }
        Q := @Self;                                      { Pointer to self }
        repeat
            P := Q^.GetPalette;                            { Get our palette }
            if (P <> nil) then
              begin                       { Palette is valid }
                if (Col <= Length(P^)) then
                    Col := Ord(P^[Col])
                else                   { Return colour }
                    Col := ErrorAttr;                          { Error attribute }
              end;
            Q := Q^.Owner;                                 { Move up to owner }
        until (Q = nil);                                 { Until no owner }
        W := Col shl 8;                                  { Translate colour }
      end;
    if (Lo(Color) > 0) then
      begin
        Col := Lo(Color) + ColourOfs;                    { Initial offset }
        Q := @Self;                                      { Pointer to self }
        repeat
            P := Q^.GetPalette;                            { Get our palette }
            if (P <> nil) then
              begin                       { Palette is valid }
                if (Col <= Length(P^)) then
                    Col := Ord(P^[Col])
                else                   { Return colour }
                    Col := ErrorAttr;                          { Error attribute }
              end;
            Q := Q^.Owner;                                 { Move up to owner }
        until (Q = nil);                                 { Until no owner }
      end
    else
        Col := ErrorAttr;                         { No colour found }
    GetColor := W or Col;                              { Return color }
end;

{--TView--------------------------------------------------------------------}
{  Valid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB             }
{---------------------------------------------------------------------------}
function TView.Valid(Command: word): boolean;
begin
    Valid := True;                                     { Simply return true }
end;

{--TView--------------------------------------------------------------------}
{  GetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
function TView.GetState(AState: word): boolean;
begin
    GetState := State and AState = AState;             { Check states equal }
end;

{--TView--------------------------------------------------------------------}
{  TextWidth -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Nov99 LdB         }
{---------------------------------------------------------------------------}
function TView.TextWidth(const Txt: string): Sw_Integer;
begin
    TextWidth := Length(Txt);             { Calc text length }
end;

function TView.CTextWidth(const Txt: string): Sw_Integer;
var
    I: Sw_Integer;
    S: string;
begin
    S := Txt;                                          { Transfer text }
    repeat
        I := Pos('~', S);                                { Check for tilde }
        if (I <> 0) then
            System.Delete(S, I, 1);        { Remove the tilde }
    until (I = 0);                                     { Remove all tildes }
    CTextWidth := Length(S);             { Calc text length }
end;

{--TView--------------------------------------------------------------------}
{  MouseInView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
function TView.MouseInView(Point: TPoint): boolean;
begin
    MakeLocal(Point, Point);
    MouseInView := (Point.X >= 0) and (Point.Y >= 0) and
        (Point.X < Size.X) and (Point.Y < Size.Y);
end;

{--TView--------------------------------------------------------------------}
{  CommandEnabled -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB    }
{---------------------------------------------------------------------------}
function TView.CommandEnabled(Command: word): boolean;
begin
    CommandEnabled := (Command > 255) or (Command in CurCommandSet);
    { Check command }
end;

{--TView--------------------------------------------------------------------}
{  OverLapsArea -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Sep97 LdB      }
{---------------------------------------------------------------------------}
function TView.OverLapsArea(X1, Y1, X2, Y2: Sw_Integer): boolean;
begin
    OverLapsArea := False;                             { Preset false }
    if (Origin.X > X2) then
        Exit;                   { Area to the left }
    if ((Origin.X + Size.X) < X1) then
        Exit;     { Area to the right }
    if (Origin.Y > Y2) then
        Exit;                   { Area is above }
    if ((Origin.Y + Size.Y) < Y1) then
        Exit;     { Area is below }
    OverLapsArea := True;                              { Return true }
end;

{--TView--------------------------------------------------------------------}
{  MouseEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
function TView.MouseEvent(var Event: TEvent; Mask: word): boolean;
begin
    repeat
        GetEvent(Event);                                 { Get next event }
    until (Event.What and (Mask or evMouseUp) <> 0);   { Wait till valid }
    MouseEvent := Event.What <> evMouseUp;             { Return result }
end;

{--TView--------------------------------------------------------------------}
{  Hide -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
procedure TView.Hide;
begin
    if (State and sfVisible <> 0) then                 { View is visible }
        SetState(sfVisible, False);                      { Hide the view }
end;

{--TView--------------------------------------------------------------------}
{  Show -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
procedure TView.Show;
begin
    if (State and sfVisible = 0) then                  { View not visible }
        SetState(sfVisible, True);                       { Show the view }
end;

{--TView--------------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Sep97 LdB              }
{---------------------------------------------------------------------------}
procedure TView.Draw;
var
    B: TDrawBuffer;
begin
    MoveChar(B, ' ', GetColor(1), Size.X);
    WriteLine(0, 0, Size.X, Size.Y, B);
end;


procedure TView.ResetCursor;
const
    sfV_CV_F: word = sfVisible + sfCursorVis + sfFocused;
var
    p, p2: PView;
    G: PGroup;
    cur: TPoint;

    function Check0: boolean;
    var
        res: byte;
    begin
        res := 0;
        while res = 0 do
          begin
            p := p^.Next;
            if p = p2 then
              begin
                p := P^.owner;
                res := 1;
              end
            else
            if ((p^.state and sfVisible) <> 0) and (cur.x >= p^.origin.x) and
                (cur.x < p^.size.x + p^.origin.x) and (cur.y >= p^.origin.y) and
                (cur.y < p^.size.y + p^.origin.y) then
                res := 2;
          end;
        Check0 := res = 2;
    end;

begin
    if ((state and sfV_CV_F) = sfV_CV_F) then
      begin
        p := @Self;
        cur := cursor;
        while True do
          begin
            if (cur.x < 0) or (cur.x >= p^.size.x) or (cur.y < 0) or
                (cur.y >= p^.size.y) then
                break;
            Inc(cur.X, p^.origin.X);
            Inc(cur.Y, p^.origin.Y);
            p2 := p;
            G := p^.owner;
            if G = nil then { top view }
              begin
                Video.SetCursorPos(cur.x, cur.y);
                if (state and sfCursorIns) <> 0 then
                    Video.SetCursorType(crBlock)
                else
                    Video.SetCursorType(crUnderline);
                exit;
              end;
            if (G^.state and sfVisible) = 0 then
                break;
            p := G^.Last;
            if Check0 then
                break;
          end; { while }
      end; { if }
    Video.SetCursorType(crHidden);
end;


{--TView--------------------------------------------------------------------}
{  Select -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05May98 LdB            }
{---------------------------------------------------------------------------}
procedure TView.Select;
begin
    if (Options and ofSelectable <> 0) then            { View is selectable }
        if (Options and ofTopSelect <> 0) then
            MakeFirst { Top selectable }
        else if (Owner <> nil) then                      { Valid owner }
            Owner^.SetCurrent(@Self, NormalSelect);        { Make owners current }
end;

{--TView--------------------------------------------------------------------}
{  Awaken -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB            }
{---------------------------------------------------------------------------}
procedure TView.Awaken;
begin                                                 { Abstract method }
end;


{--TView--------------------------------------------------------------------}
{  MakeFirst -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 29Sep99 LdB         }
{---------------------------------------------------------------------------}
procedure TView.MakeFirst;
begin
    if (Owner <> nil) then
      begin                       { Must have owner }
        PutInFrontOf(Owner^.First);                      { Float to the top }
      end;
end;

{--TView--------------------------------------------------------------------}
{  DrawCursor -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TView.DrawCursor;
begin                                                 { Abstract method }
    if State and sfFocused <> 0 then
        ResetCursor;
end;


procedure TView.DrawHide(LastView: PView);
begin
    TView.DrawCursor;
    DrawUnderView(State and sfShadow <> 0, LastView);
end;


procedure TView.DrawShow(LastView: PView);
begin
    DrawView;
    if State and sfShadow <> 0 then
        DrawUnderView(True, LastView);
end;


procedure TView.DrawUnderRect(var R: TRect; LastView: PView);
begin
    Owner^.Clip.Intersect(R);
    Owner^.DrawSubViews(NextView, LastView);
    Owner^.GetExtent(Owner^.Clip);
end;


procedure TView.DrawUnderView(DoShadow: boolean; LastView: PView);
var
    R: TRect;
begin
    GetBounds(R);
    if DoShadow then
      begin
        Inc(R.B.X, ShadowSize.X);
        Inc(R.B.Y, ShadowSize.Y);
      end;
    DrawUnderRect(R, LastView);
end;


procedure TView.DrawView;
begin
    if Exposed then
      begin
        LockScreenUpdate; { don't update the screen yet }
        Draw;
        UnLockScreenUpdate;
        DrawScreenBuf(False);
        TView.DrawCursor;
      end;
end;


{--TView--------------------------------------------------------------------}
{  HideCursor -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TView.HideCursor;
begin
    SetState(sfCursorVis, False);                     { Hide the cursor }
end;

{--TView--------------------------------------------------------------------}
{  ShowCursor -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TView.ShowCursor;
begin
    SetState(sfCursorVis, True);                      { Show the cursor }
end;

{--TView--------------------------------------------------------------------}
{  BlockCursor -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TView.BlockCursor;
begin
    SetState(sfCursorIns, True);                       { Set insert mode }
end;

{--TView--------------------------------------------------------------------}
{  NormalCursor -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB      }
{---------------------------------------------------------------------------}
procedure TView.NormalCursor;
begin
    SetState(sfCursorIns, False);                      { Clear insert mode }
end;

{--TView--------------------------------------------------------------------}
{  FocusFromTop -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11Aug99 LdB      }
{---------------------------------------------------------------------------}
procedure TView.FocusFromTop;
begin
    if (Owner <> nil) and (Owner^.State and sfSelected = 0) then
        Owner^.Select;
    if (State and sfFocused = 0) then
        Focus;
    if (State and sfSelected = 0) then
        Select;
end;

{--TView--------------------------------------------------------------------}
{  MoveTo -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB            }
{---------------------------------------------------------------------------}
procedure TView.MoveTo(X, Y: Sw_Integer);
var
    R: TRect;
begin
    R.Assign(X, Y, X + Size.X, Y + Size.Y);            { Assign area }
    Locate(R);                                         { Locate the view }
end;

{--TView--------------------------------------------------------------------}
{  GrowTo -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB            }
{---------------------------------------------------------------------------}
procedure TView.GrowTo(X, Y: Sw_Integer);
var
    R: TRect;
begin
    R.Assign(Origin.X, Origin.Y, Origin.X + X,
        Origin.Y + Y);                                   { Assign area }
    Locate(R);                                         { Locate the view }
end;

{--TView--------------------------------------------------------------------}
{  EndModal -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
procedure TView.EndModal(Command: word);
var
    P: PView;
begin
    P := TopView;                                      { Get top view }
    if (P <> nil) then
        P^.EndModal(Command);           { End modal operation }
end;

{--TView--------------------------------------------------------------------}
{  SetCursor -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB         }
{---------------------------------------------------------------------------}
procedure TView.SetCursor(X, Y: Sw_Integer);
begin
    if (Cursor.X <> X) or (Cursor.Y <> Y) then
      begin
        Cursor.X := X;
        Cursor.Y := Y;
        CursorChanged;
      end;
    TView.DrawCursor;
end;


procedure TView.CursorChanged;
begin
    Message(Owner, evBroadcast, cmCursorChanged, @Self);
end;


{--TView--------------------------------------------------------------------}
{  PutInFrontOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 29Sep99 LdB      }
{---------------------------------------------------------------------------}
procedure TView.PutInFrontOf(Target: PView);
var
    P, LastView: PView;
begin
    if (Owner <> nil) and (Target <> @Self) and (Target <> NextView) and
        ((Target = nil) or (Target^.Owner = Owner)) then
        { Check validity }
        if (State and sfVisible = 0) then
          begin          { View not visible }
            Owner^.RemoveView(@Self);                      { Remove from list }
            Owner^.InsertView(@Self, Target);              { Insert into list }
          end
        else
          begin
            LastView := NextView;                          { Hold next view }
            if (LastView <> nil) then
              begin                { Lastview is valid }
                P := Target;                                 { P is target }
                while (P <> nil) and (P <> LastView) do
                    P := P^.NextView;                       { Find our next view }
                if (P = nil) then
                    LastView := Target;        { Lastview is target }
              end;
            State := State and not sfVisible;              { Temp stop drawing }
            if (LastView = Target) then
                DrawHide(LastView);
            Owner^.Lock;
            Owner^.RemoveView(@Self);                      { Remove from list }
            Owner^.InsertView(@Self, Target);              { Insert into list }
            State := State or sfVisible;                   { Allow drawing again }
            if (LastView <> Target) then
                DrawShow(LastView);
            if (Options and ofSelectable <> 0) then        { View is selectable }
              begin
                Owner^.ResetCurrent;  { Reset current }
                Owner^.ResetCursor;
              end;
            Owner^.Unlock;
          end;
end;

{--TView--------------------------------------------------------------------}
{  SetCommands -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TView.SetCommands(Commands: TCommandSet);
begin
    CommandSetChanged := CommandSetChanged or (CurCommandSet <> Commands);
    { Set change flag }
    CurCommandSet := Commands;                         { Set command set }
end;

{--TView--------------------------------------------------------------------}
{  EnableCommands -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB    }
{---------------------------------------------------------------------------}
procedure TView.EnableCommands(Commands: TCommandSet);
begin
    CommandSetChanged := CommandSetChanged or (CurCommandSet * Commands <> Commands);
    { Set changed flag }
    CurCommandSet := CurCommandSet + Commands;         { Update command set }
end;

{--TView--------------------------------------------------------------------}
{  DisableCommands -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB   }
{---------------------------------------------------------------------------}
procedure TView.DisableCommands(Commands: TCommandSet);
begin
    CommandSetChanged := CommandSetChanged or (CurCommandSet * Commands <> []);
    { Set changed flag }
    CurCommandSet := CurCommandSet - Commands;         { Update command set }
end;

{--TView--------------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23Sep99 LdB          }
{---------------------------------------------------------------------------}
procedure TView.SetState(AState: word; Enable: boolean);
var
    Command: word;
    OState: word;
begin
    OState := State;
    if Enable then
        State := State or AState
    else
        State := State and not AState;
    if Owner <> nil then
        case AState of
            sfVisible:
              begin
                if Owner^.State and sfExposed <> 0 then
                    SetState(sfExposed, Enable);
                if Enable then
                    DrawShow(nil)
                else
                    DrawHide(nil);
                if Options and ofSelectable <> 0 then
                    Owner^.ResetCurrent;
              end;
            sfCursorVis,
            sfCursorIns:
                TView.DrawCursor;
            sfShadow:
                DrawUnderView(True, nil);
            sfFocused:
              begin
                ResetCursor;
                if Enable then
                    Command := cmReceivedFocus
                else
                    Command := cmReleasedFocus;
                Message(Owner, evBroadcast, Command, @Self);
              end;
          end;
    if ((OState xor State) and (sfCursorVis + sfCursorIns + sfFocused)) <> 0 then
        CursorChanged;
end;


{--TView--------------------------------------------------------------------}
{  SetCmdState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TView.SetCmdState(Commands: TCommandSet; Enable: boolean);
begin
    if Enable then
        EnableCommands(Commands)            { Enable commands }
    else
        DisableCommands(Commands);                  { Disable commands }
end;

{--TView--------------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB           }
{---------------------------------------------------------------------------}
procedure TView.GetData(var Rec);
begin                                                 { Abstract method }
end;

{--TView--------------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB           }
{---------------------------------------------------------------------------}
procedure TView.SetData(const Rec);
begin                                                 { Abstract method }
end;

{--TView--------------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06May98 LdB             }
{---------------------------------------------------------------------------}
procedure TView.Store(var S: TStream);
var
    SaveState: word;
    i: integer;
begin
    SaveState := State;                                { Hold current state }
    State := State and not (sfActive or sfSelected or sfFocused or sfExposed);
    { Clear flags }
    i := Origin.X;
    S.Write(i, SizeOf(i));                 { Write view x origin }
    i := Origin.Y;
    S.Write(i, SizeOf(i));                 { Write view y origin }
    i := Size.X;
    S.Write(i, SizeOf(i));                   { Write view x size }
    i := Size.Y;
    S.Write(i, SizeOf(i));                   { Write view y size }
    i := Cursor.X;
    S.Write(i, SizeOf(i));                 { Write cursor x size }
    i := Cursor.Y;
    S.Write(i, SizeOf(i));                 { Write cursor y size }
    S.Write(GrowMode, SizeOf(GrowMode));               { Write growmode flags }
    S.Write(DragMode, SizeOf(DragMode));               { Write dragmode flags }
    S.Write(HelpCtx, SizeOf(HelpCtx));                 { Write help context }
    S.Write(State, SizeOf(State));                     { Write state masks }
    S.Write(Options, SizeOf(Options));                 { Write options masks }
    S.Write(Eventmask, SizeOf(Eventmask));             { Write event masks }
    State := SaveState;                                { Reset state masks }
end;

{--TView--------------------------------------------------------------------}
{  Locate -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 24Sep99 LdB            }
{---------------------------------------------------------------------------}
procedure TView.Locate(var Bounds: TRect);
var
    Min, Max: TPoint;
    R: TRect;

    function Range(Val, Min, Max: Sw_Integer): Sw_Integer;
    begin
        if (Val < Min) then
            Range := Min
        else            { Value to small }
        if (Val > Max) then
            Range := Max
        else          { Value to large }
            Range := Val;                                { Value is okay }
    end;

begin
    SizeLimits(Min, Max);                              { Get size limits }
    Bounds.B.X := Bounds.A.X + Range(Bounds.B.X - Bounds.A.X, Min.X, Max.X);
    { X bound limit }
    Bounds.B.Y := Bounds.A.Y + Range(Bounds.B.Y - Bounds.A.Y, Min.Y, Max.Y);
    { Y bound limit }
    GetBounds(R);                                      { Current bounds }
    if not Bounds.Equals(R) then
      begin                 { Size has changed }
        ChangeBounds(Bounds);                            { Change bounds }
        if (State and sfVisible <> 0) and                { View is visible }
            (State and sfExposed <> 0) and (Owner <> nil)    { Check view exposed } then
          begin
            if State and sfShadow <> 0 then
              begin
                R.Union(Bounds);
                Inc(R.B.X, ShadowSize.X);
                Inc(R.B.Y, ShadowSize.Y);
              end;
            DrawUnderRect(R, nil);
          end;
      end;
end;

{--TView--------------------------------------------------------------------}
{  KeyEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
procedure TView.KeyEvent(var Event: TEvent);
begin
    repeat
        GetEvent(Event);                                 { Get next event }
    until (Event.What = evKeyDown);                    { Wait till keydown }
end;

{--TView--------------------------------------------------------------------}
{  GetEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
procedure TView.GetEvent(var Event: TEvent);
begin
    if (Owner <> nil) then
        Owner^.GetEvent(Event);      { Event from owner }
end;

{--TView--------------------------------------------------------------------}
{  PutEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
procedure TView.PutEvent(var Event: TEvent);
begin
    if (Owner <> nil) then
        Owner^.PutEvent(Event);     { Put in owner }
end;

{--TView--------------------------------------------------------------------}
{  GetExtent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB         }
{---------------------------------------------------------------------------}
procedure TView.GetExtent({$IfDef FPC_OBJFPC}out{$else}var{$endif} Extent: TRect);
begin
    Extent.A.X := 0;                                   { Zero x field }
    Extent.A.Y := 0;                                   { Zero y field }
    Extent.B.X := Size.X;                              { Return x size }
    Extent.B.Y := Size.Y;                              { Return y size }
end;

{--TView--------------------------------------------------------------------}
{  GetBounds -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB         }
{---------------------------------------------------------------------------}
procedure TView.GetBounds({$IfDef FPC_OBJFPC}out{$else}var{$endif} Bounds: TRect);
begin
    Bounds.A := Origin;                                { Get first corner }
    Bounds.B.X := Origin.X + Size.X;                   { Calc corner x value }
    Bounds.B.Y := Origin.Y + Size.Y;                   { Calc corner y value }
end;

{--TView--------------------------------------------------------------------}
{  SetBounds -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 24Sep99 LdB         }
{---------------------------------------------------------------------------}
procedure TView.SetBounds(const Bounds: TRect);
begin
    Origin := Bounds.A;                                { Get first corner }
    Size := Bounds.B;                                 { Get second corner }
    Dec(Size.X, Origin.X);
    Dec(Size.Y, Origin.Y);
end;

{--TView--------------------------------------------------------------------}
{  GetClipRect -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TView.GetClipRect(var Clip: TRect);
begin
    GetBounds(Clip);                                   { Get current bounds }
    if (Owner <> nil) then
        Clip.Intersect(Owner^.Clip);{ Intersect with owner }
    Clip.Move(-Origin.X, -Origin.Y);                   { Sub owner origin }
end;

{--TView--------------------------------------------------------------------}
{  ClearEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TView.ClearEvent(var Event: TEvent);
begin
    Event.What := evNothing;                           { Clear the event }
    Event.InfoPtr := @Self;                            { Set us as handler }
end;

{--TView--------------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TView.HandleEvent(var Event: TEvent);
begin
    if (Event.What = evMouseDown) then                 { Mouse down event }
        if (State and (sfSelected or sfDisabled) = 0)    { Not selected/disabled } and
            (Options and ofSelectable <> 0) then       { View is selectable }
            if (Focus = False) or                          { Not view with focus }
                (Options and ofFirstClick = 0)               { Not 1st click select }
            then
                ClearEvent(Event);                    { Handle the event }
end;

{--TView--------------------------------------------------------------------}
{  ChangeBounds -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB      }
{---------------------------------------------------------------------------}
procedure TView.ChangeBounds(const Bounds: TRect);
begin
    SetBounds(Bounds);                                 { Set new bounds }
    DrawView;                                          { Draw the view }
end;

{--TView--------------------------------------------------------------------}
{  SizeLimits -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TView.SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} Min, Max: TPoint);
begin
    Min.X := 0;                                        { Zero x minimum }
    Min.Y := 0;                                        { Zero y minimum }
    if (Owner <> nil) and (Owner^.ClipChilds) then
        Max := Owner^.Size
    else                         { Max owner size }
      begin
        Max.X := high(sw_integer);                      { Max possible x size }
        Max.Y := high(sw_integer);                        { Max possible y size }
      end;
end;

{--TView--------------------------------------------------------------------}
{  GetCommands -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TView.GetCommands({$IfDef FPC_OBJFPC}out{$else}var{$endif} Commands: TCommandSet);
begin
    Commands := CurCommandSet;                         { Return command set }
end;

{--TView--------------------------------------------------------------------}
{  GetPeerViewPtr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB    }
{---------------------------------------------------------------------------}
procedure TView.GetPeerViewPtr(var S: TStream; var P);
var
    Index: integer;
begin
    Index := 0;                                        { Zero index value }
    S.Read(Index, SizeOf(Index));                      { Read view index }
    if (Index = 0) or (OwnerGroup = nil) then          { Check for peer views }
        Pointer(P) := nil
    else
      begin                     { Return nil }
        Pointer(P) := FixupList^[Index];               { New view ptr }
        FixupList^[Index] := @P;                       { Patch this pointer }
      end;
end;

{--TView--------------------------------------------------------------------}
{  PutPeerViewPtr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB    }
{---------------------------------------------------------------------------}
procedure TView.PutPeerViewPtr(var S: TStream; P: PView);
var
    Index: integer;
begin
    if (P = nil) or (OwnerGroup = nil) then
        Index := 0 { Return zero index }
    else
        Index := OwnerGroup^.IndexOf(P);            { Return view index }
    S.Write(Index, SizeOf(Index));                     { Write the index }
end;

{--TView--------------------------------------------------------------------}
{  CalcBounds -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TView.CalcBounds(var Bounds: TRect; Delta: TPoint);
var
    S, D: Sw_Integer;
    Min, Max: TPoint;

    function Range(Val, Min, Max: Sw_Integer): Sw_Integer;
    begin
        if (Val < Min) then
            Range := Min
        else            { Value below min }
        if (Val > Max) then
            Range := Max
        else            { Value above max }
            Range := Val;                                  { Accept value }
    end;

    procedure GrowI(var I: Sw_Integer);
    begin
        if (GrowMode and gfGrowRel = 0) then
            Inc(I, D)
        else
            I := (I * S + (S - D) shr 1) div (S - D); { Calc grow value }
    end;

begin
    GetBounds(Bounds);                                 { Get bounds }
    if (GrowMode = 0) then
        Exit;                       { No grow flags exits }
    S := Owner^.Size.X;                                { Set initial size }
    D := Delta.X;                                      { Set initial delta }
    if (GrowMode and gfGrowLoX <> 0) then
        GrowI(Bounds.A.X);                                { Grow left side }
    if (GrowMode and gfGrowHiX <> 0) then
        GrowI(Bounds.B.X);                                { Grow right side }
    if (Bounds.B.X - Bounds.A.X > MaxViewWidth) then
        Bounds.B.X := Bounds.A.X + MaxViewWidth;         { Check values }
    S := Owner^.Size.Y;
    D := Delta.Y;                  { set initial values }
    if (GrowMode and gfGrowLoY <> 0) then
        GrowI(Bounds.A.Y);                                { Grow top side }
    if (GrowMode and gfGrowHiY <> 0) then
        GrowI(Bounds.B.Y);                                { grow lower side }
    SizeLimits(Min, Max);                              { Check sizes }
    Bounds.B.X := Bounds.A.X + Range(Bounds.B.X - Bounds.A.X, Min.X, Max.X);
    { Set right side }
    Bounds.B.Y := Bounds.A.Y + Range(Bounds.B.Y - Bounds.A.Y, Min.Y, Max.Y);
    { Set lower side }
end;

{***************************************************************************}
{                       TView OBJECT PRIVATE METHODS                        }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TGroup OBJECT METHODS                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TGroup-------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Jul99 LdB              }
{---------------------------------------------------------------------------}
constructor TGroup.Init(const Bounds: TRect);
begin
    inherited Init(Bounds);                            { Call ancestor }
    Options := Options or (ofSelectable + ofBuffered); { Set options }
    GetExtent(Clip);                                   { Get clip extents }
    EventMask := $FFFF;                                { See all events }
end;

{--TGroup-------------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB              }
{---------------------------------------------------------------------------}
constructor TGroup.Load(var S: TStream);
var
    I: Sw_Word;
    Count: word;
    P, Q: ^Pointer;
    V: PView;
    OwnerSave: PGroup;
    FixupSave: PFixupList;
begin
    inherited Load(S);                                 { Call ancestor }
    GetExtent(Clip);                                   { Get view extents }
    OwnerSave := OwnerGroup;                           { Save current group }
    OwnerGroup := @Self;                               { We are current group }
    FixupSave := FixupList;                            { Save current list }
    Count := 0;                                        { Zero count value }
    S.Read(Count, SizeOf(Count));                      { Read entry count }
    if (MaxAvail >= Count * SizeOf(Pointer)) then
      begin  { Memory available }
        GetMem(FixupList, Count * SizeOf(Pointer));        { List size needed }
        FillChar(FixUpList^, Count * SizeOf(Pointer), #0); { Zero all entries }
        for I := 1 to Count do
          begin
            V := PView(S.Get);                             { Get view off stream }
            if (V <> nil) then
                InsertView(V, nil);         { Insert valid views }
          end;
        V := Last;                                       { Start on last view }
        for I := 1 to Count do
          begin
            V := V^.Next;                                  { Fetch next view }
            P := FixupList^[I];                            { Transfer pointer }
            while (P <> nil) do
              begin                      { If valid view }
                Q := P;                                      { Copy pointer }
                P := P^;                                     { Fetch pointer }
                Q^ := V;                                     { Transfer view ptr }
              end;
          end;
        FreeMem(FixupList, Count * SizeOf(Pointer));       { Release fixup list }
      end;
    OwnerGroup := OwnerSave;                           { Reload current group }
    FixupList := FixupSave;                            { Reload current list }
    GetSubViewPtr(S, V);                               { Load any subviews }
    SetCurrent(V, NormalSelect);                       { Select current view }
    if (OwnerGroup = nil) then
        Awaken;                 { If topview activate }
end;

{--TGroup-------------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
destructor TGroup.Done;
var
    P, T: PView;
begin
    Hide;                                              { Hide the view }
    P := Last;                                         { Start on last }
    if (P <> nil) then
      begin                           { Subviews exist }
        repeat
            P^.Hide;                                       { Hide each view }
            P := P^.Prev;                                  { Prior view }
        until (P = Last);                                { Loop complete }
        repeat
            T := P^.Prev;                                  { Hold prior pointer }
            Dispose(P, Done);                              { Dispose subview }
            P := T;                                        { Transfer pointer }
        until (Last = nil);                              { Loop complete }
      end;
    inherited Done;                                    { Call ancestor }
end;

{--TGroup-------------------------------------------------------------------}
{  First -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB             }
{---------------------------------------------------------------------------}
function TGroup.First: PView;
begin
    if (Last = nil) then
        First := nil                  { No first view }
    else
        First := Last^.Next;                        { Return first view }
end;

{--TGroup-------------------------------------------------------------------}
{  Execute -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB           }
{---------------------------------------------------------------------------}
function TGroup.Execute: word;
var
    Event: TEvent;
begin
    repeat
        EndState := 0;                                   { Clear end state }
        repeat
            GetEvent(Event);                               { Get next event }
            HandleEvent(Event);                            { Handle the event }
            if (Event.What <> evNothing) then
                EventError(Event);                           { Event not handled }
        until (EndState <> 0);                           { Until command set }
    until Valid(EndState);                             { Repeat until valid }
    Execute := EndState;                               { Return result }
    EndState := 0;                                     { Clear end state }
end;

{--TGroup-------------------------------------------------------------------}
{  GetHelpCtx -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
function TGroup.GetHelpCtx: word;
var
    H: word;
begin
    H := hcNoContext;                                  { Preset no context }
    if (Current <> nil) then
        H := Current^.GetHelpCtx; { Current context }
    if (H = hcNoContext) then
        H := inherited GetHelpCtx; { Call ancestor }
    GetHelpCtx := H;                                   { Return result }
end;

{--TGroup-------------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Jul98 LdB          }
{---------------------------------------------------------------------------}
function TGroup.DataSize: Sw_Word;
var
    Total: word;
    P: PView;
begin
    Total := 0;                                        { Zero totals count }
    P := Last;                                         { Start on last view }
    if (P <> nil) then
      begin                           { Subviews exist }
        repeat
            P := P^.Next;                                  { Move to next view }
            Total := Total + P^.DataSize;                  { Add view size }
        until (P = Last);                                { Until last view }
      end;
    DataSize := Total;                                 { Return data size }
end;

{--TGroup-------------------------------------------------------------------}
{  ExecView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Jul99 LdB          }
{---------------------------------------------------------------------------}
function TGroup.ExecView(P: PView): word;
var
    SaveOptions: word;
    SaveTopView, SaveCurrent: PView;
    SaveOwner: PGroup;
    SaveCommands: TCommandSet;
begin
    if (P <> nil) then
      begin
        SaveOptions := P^.Options;                       { Hold options }
        SaveOwner := P^.Owner;                           { Hold owner }
        SaveTopView := TheTopView;                       { Save topmost view }
        SaveCurrent := Current;                          { Save current view }
        GetCommands(SaveCommands);                       { Save commands }
        TheTopView := P;                                 { Set top view }
        P^.Options := P^.Options and not ofSelectable;   { Not selectable }
        P^.SetState(sfModal, True);                      { Make modal }
        SetCurrent(P, EnterSelect);                      { Select next }
        if (SaveOwner = nil) then
            Insert(P);             { Insert view }
        ExecView := P^.Execute;                          { Execute view }
        if (SaveOwner = nil) then
            Delete(P);             { Remove view }
        SetCurrent(SaveCurrent, LeaveSelect);            { Unselect current }
        P^.SetState(sfModal, False);                     { Clear modal state }
        P^.Options := SaveOptions;                       { Restore options }
        TheTopView := SaveTopView;                       { Restore topview }
        SetCommands(SaveCommands);                       { Restore commands }
      end
    else
        ExecView := cmCancel;                     { Return cancel }
end;

{ ********************************* REMARK ******************************** }
{    This call really is very COMPILER SPECIFIC and really can't be done    }
{    effectively any other way but assembler code as SELF & FRAMES need     }
{    to be put down in exact order and OPTIMIZERS make a mess of it.        }
{ ******************************** END REMARK *** Leon de Boer, 17Jul99 *** }

{--TGroup-------------------------------------------------------------------}
{  FirstThat -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Jul99 LdB         }
{---------------------------------------------------------------------------}
function TGroup.FirstThat(P: TGroupFirstThatCallback): PView;
var
    Tp: PView;
begin
    if (Last <> nil) then
      begin
        Tp := Last;                                      { Set temporary ptr }
        repeat
            Tp := Tp^.Next;                                { Get next view }
            if byte(PtrUInt(CallPointerMethodLocal(P,
         { On most systems, locals are accessed relative to base pointer,
           but for MIPS cpu, they are accessed relative to stack pointer.
           This needs adaptation for so low level routines,
           like MethodPointerLocal and related objects unit functions. }
{$ifndef FPC_LOCALS_ARE_STACK_REG_RELATIVE}
                get_caller_frame(get_frame, get_pc_addr)
{$else}
         get_frame
{$endif}
                , @self, Tp))) <> 0 then
              begin       { Test each view }
                FirstThat := Tp;                             { View returned true }
                Exit;                                        { Now exit }
              end;
        until (Tp = Last);                                 { Until last }
        FirstThat := nil;                                { None passed test }
      end
    else
        FirstThat := nil;                         { Return nil }
end;

{--TGroup-------------------------------------------------------------------}
{  Valid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB             }
{---------------------------------------------------------------------------}
function TGroup.Valid(Command: word): boolean;

    function IsInvalid(P: PView): boolean;
    begin
        IsInvalid := not P^.Valid(Command);              { Check if valid }
    end;

begin
    Valid := True;                                     { Preset valid }
    if (Command = cmReleasedFocus) then
      begin          { Release focus cmd }
        if (Current <> nil) and                          { Current view exists }
            (Current^.Options and ofValidate <> 0) then    { Validating view }
            Valid := Current^.Valid(Command);            { Validate command }
      end
    else
        Valid := FirstThat(@IsInvalid) = nil;     { Check first valid }
end;

{--TGroup-------------------------------------------------------------------}
{  FocusNext -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB         }
{---------------------------------------------------------------------------}
function TGroup.FocusNext(Forwards: boolean): boolean;
var
    P: PView;
begin
    P := FindNext(Forwards);                           { Find next view }
    FocusNext := True;                                 { Preset true }
    if (P <> nil) then
        FocusNext := P^.Focus;          { Check next focus }
end;


procedure TGroup.DrawSubViews(P, Bottom: PView);
begin
    if P <> nil then
        while P <> Bottom do
          begin
            P^.DrawView;
            P := P^.NextView;
          end;
end;


{--TGroup-------------------------------------------------------------------}
{  ReDraw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 2Jun06 DM              }
{---------------------------------------------------------------------------}
procedure TGroup.ReDraw;
begin
    {Lock to prevent screen update.}
    lockscreenupdate;
    DrawSubViews(First, nil);
    unlockscreenupdate;
    {Draw all views at once, forced update.}
    drawscreenbuf(True);
end;


procedure TGroup.ResetCursor;
begin
    if (Current <> nil) then
        Current^.ResetCursor;
end;


{--TGroup-------------------------------------------------------------------}
{  Awaken -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB            }
{---------------------------------------------------------------------------}
procedure TGroup.Awaken;

    procedure DoAwaken(P: PView);
    begin
        if (P <> nil) then
            P^.Awaken;                    { Awaken view }
    end;

begin
    ForEach(TCallbackProcParam(@DoAwaken));            { Awaken each view }
end;

{--TGroup-------------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Sep97 LdB              }
{---------------------------------------------------------------------------}
procedure TGroup.Draw;
begin
    if Buffer = nil then
        DrawSubViews(First, nil)
    else
        WriteBuf(0, 0, Size.X, Size.Y, Buffer);
end;


{--TGroup-------------------------------------------------------------------}
{  SelectDefaultView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB }
{---------------------------------------------------------------------------}
procedure TGroup.SelectDefaultView;
var
    P: PView;
begin
    P := Last;                                         { Start at last }
    while (P <> nil) do
      begin
        if P^.GetState(sfDefault) then
          begin             { Search 1st default }
            P^.Select;                                     { Select default view }
            P := nil;                                      { Force kick out }
          end
        else
            P := P^.PrevView;                       { Prior subview }
      end;
end;


function TGroup.ClipChilds: boolean;
begin
    ClipChilds := True;
end;


procedure TGroup.BeforeInsert(P: PView);
begin
    { abstract }
end;

procedure TGroup.AfterInsert(P: PView);
begin
    { abstract }
end;

procedure TGroup.BeforeDelete(P: PView);
begin
    { abstract }
end;

procedure TGroup.AfterDelete(P: PView);
begin
    { abstract }
end;

{--TGroup-------------------------------------------------------------------}
{  Insert -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 29Sep99 LdB            }
{---------------------------------------------------------------------------}
procedure TGroup.Insert(P: PView);
begin
    BeforeInsert(P);
    InsertBefore(P, First);
    AfterInsert(P);
end;

{--TGroup-------------------------------------------------------------------}
{  Delete -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB            }
{---------------------------------------------------------------------------}
procedure TGroup.Delete(P: PView);
var
    SaveState: word;
begin
    BeforeDelete(P);
    SaveState := P^.State;                             { Save state }
    P^.Hide;                                           { Hide the view }
    RemoveView(P);                                     { Remove the view }
    P^.Owner := nil;                                   { Clear owner ptr }
    P^.Next := nil;                                    { Clear next ptr }
    if SaveState and sfVisible <> 0 then
        P^.Show;
    AfterDelete(P);
end;

{ ********************************* REMARK ******************************** }
{    This call really is very COMPILER SPECIFIC and really can't be done    }
{    effectively any other way but assembler code as SELF & FRAMES need     }
{    to be put down in exact order and OPTIMIZERS make a mess of it.        }
{ ******************************** END REMARK *** Leon de Boer, 17Jul99 *** }

{--TGroup-------------------------------------------------------------------}
{  ForEach -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Jul99 LdB           }
{---------------------------------------------------------------------------}
procedure TGroup.ForEach(P: TCallbackProcParam);
var
    Tp, Hp, L0: PView;
    { Vars Hp and L0 are necessary to hold original pointers in case   }
    { when some view closes himself as a result of broadcast message ! }
begin
    if (Last <> nil) then
      begin
        Tp := Last;
        Hp := Tp^.Next;
        L0 := Last;              { Set temporary ptr }
        repeat
            Tp := Hp;
            if tp = nil then
                exit;
            Hp := Tp^.Next;                        { Get next view }
            CallPointerMethodLocal(P,
         { On most systems, locals are accessed relative to base pointer,
           but for MIPS cpu, they are accessed relative to stack pointer.
           This needs adaptation for so low level routines,
           like MethodPointerLocal and related objects unit functions. }
{$ifndef FPC_LOCALS_ARE_STACK_REG_RELATIVE}
                get_caller_frame(get_frame, get_pc_addr)
{$else}
         get_frame
{$endif}
                , @self, Tp);
        until (Tp = L0);                                   { Until last }
      end;
end;



{--TGroup-------------------------------------------------------------------}
{  EndModal -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
procedure TGroup.EndModal(Command: word);
begin
    if (State and sfModal <> 0) then                   { This view is modal }
        EndState := Command
    else                         { Set endstate }
        inherited EndModal(Command);                     { Call ancestor }
end;

{--TGroup-------------------------------------------------------------------}
{  SelectNext -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TGroup.SelectNext(Forwards: boolean);
var
    P: PView;
begin
    P := FindNext(Forwards);                           { Find next view }
    if (P <> nil) then
        P^.Select;                      { Select view }
end;

{--TGroup-------------------------------------------------------------------}
{  InsertBefore -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 29Sep99 LdB      }
{---------------------------------------------------------------------------}
procedure TGroup.InsertBefore(P, Target: PView);
var
    SaveState: word;
begin
    if (P <> nil) and (P^.Owner = nil) and             { View valid }
        ((Target = nil) or (Target^.Owner = @Self))        { Target valid } then
      begin
        if (P^.Options and ofCenterX <> 0) then     { Centre on x axis }
            P^.Origin.X := (Size.X - P^.Size.X) div 2;
        if (P^.Options and ofCenterY <> 0) then     { Centre on y axis }
            P^.Origin.Y := (Size.Y - P^.Size.Y) div 2;
        SaveState := P^.State;                           { Save view state }
        P^.Hide;                                         { Make sure hidden }
        InsertView(P, Target);                           { Insert into list }
        if (SaveState and sfVisible <> 0) then
            P^.Show;  { Show the view }
        if (State and sfActive <> 0) then                { Was active before }
            P^.SetState(sfActive, True);                  { Make active again }
      end;
end;

{--TGroup-------------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
procedure TGroup.SetState(AState: word; Enable: boolean);

    procedure DoSetState(P: PView);
    begin
        if (P <> nil) then
            P^.SetState(AState, Enable); { Set subview state }
    end;

    procedure DoExpose(P: PView);
    begin
        if (P <> nil) then
          begin
            if (P^.State and sfVisible <> 0) then         { Check view visible }
                P^.SetState(sfExposed, Enable);             { Set exposed flag }
          end;
    end;

begin
    inherited SetState(AState, Enable);                { Call ancestor }
    case AState of
        sfActive, sfDragging:
          begin
            Lock;                                        { Lock the view }
            ForEach(TCallbackProcParam(@DoSetState));    { Set each subview }
            UnLock;                                      { Unlock the view }
          end;
        sfFocused:
          begin
            if (Current <> nil) then
                Current^.SetState(sfFocused, Enable);          { Focus current view }
          end;
        sfExposed:
          begin
            ForEach(TCallbackProcParam(@DoExpose));      { Expose each subview }
          end;
      end;
end;

{--TGroup-------------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 29Mar98 LdB           }
{---------------------------------------------------------------------------}
procedure TGroup.GetData(var Rec);
var
    Total: Sw_Word;
    P: PView;
begin
    Total := 0;                                        { Clear total }
    P := Last;                                         { Start at last }
    while (P <> nil) do
      begin                          { Subviews exist }
        P^.GetData(TByteArray(Rec)[Total]);              { Get data }
        Inc(Total, P^.DataSize);                         { Increase total }
        P := P^.PrevView;                                { Previous view }
      end;
end;

{--TGroup-------------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 29Mar98 LdB           }
{---------------------------------------------------------------------------}
procedure TGroup.SetData(const Rec);
var
    Total: Sw_Word;
    P: PView;
begin
    Total := 0;                                        { Clear total }
    P := Last;                                         { Start at last }
    while (P <> nil) do
      begin                          { Subviews exist }
        P^.SetData(TByteArray(Rec)[Total]);              { Get data }
        Inc(Total, P^.DataSize);                         { Increase total }
        P := P^.PrevView;                                { Previous view }
      end;
end;

{--TGroup-------------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Mar98 LdB             }
{---------------------------------------------------------------------------}
procedure TGroup.Store(var S: TStream);
var
    Count: word;
    OwnerSave: PGroup;

    procedure DoPut(P: PView);
    begin
        S.Put(P);                                        { Put view on stream }
    end;

begin
    TView.Store(S);                                    { Call view store }
    OwnerSave := OwnerGroup;                           { Save ownergroup }
    OwnerGroup := @Self;                               { Set as owner group }
    Count := IndexOf(Last);                            { Subview count }
    S.Write(Count, SizeOf(Count));                     { Write the count }
    ForEach(TCallbackProcParam(@DoPut));               { Put each in stream }
    PutSubViewPtr(S, Current);                         { Current on stream }
    OwnerGroup := OwnerSave;                           { Restore ownergroup }
end;

{--TGroup-------------------------------------------------------------------}
{  EventError -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TGroup.EventError(var Event: TEvent);
begin
    if (Owner <> nil) then
        Owner^.EventError(Event);   { Event error }
end;

{--TGroup-------------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
procedure TGroup.HandleEvent(var Event: TEvent);

    function ContainsMouse(P: PView): boolean;
    begin
        ContainsMouse := (P^.State and sfVisible <> 0)   { Is view visible } and
            P^.MouseInView(Event.Where);               { Is point in view }
    end;

    procedure DoHandleEvent(P: PView);
    begin
        if (P = nil) or ((P^.State and sfDisabled <> 0) and
            (Event.What and (PositionalEvents or FocusedEvents) <> 0)) then
            Exit;                                     { Invalid/disabled }
        case Phase of
            phPreProcess: if (P^.Options and ofPreProcess = 0) then
                    Exit;                                   { Not pre processing }
            phPostProcess: if (P^.Options and ofPostProcess = 0) then
                    Exit;                                   { Not post processing }
          end;
        if (Event.What and P^.EventMask <> 0) then       { View handles event }
            P^.HandleEvent(Event);                         { Pass to view }
    end;

begin
    inherited HandleEvent(Event);                      { Call ancestor }
    if (Event.What = evNothing) then
        Exit;             { No valid event exit }
    if (Event.What and FocusedEvents <> 0) then
      begin  { Focused event }
        Phase := phPreProcess;                           { Set pre process }
        ForEach(TCallbackProcParam(@DoHandleEvent));     { Pass to each view }
        Phase := phFocused;                              { Set focused }
        DoHandleEvent(Current);                          { Pass to current }
        Phase := phPostProcess;                          { Set post process }
        ForEach(TCallbackProcParam(@DoHandleEvent));     { Pass to each }
      end
    else
      begin
        Phase := phFocused;                              { Set focused }
        if (Event.What and PositionalEvents <> 0) then   { Positional event }
            DoHandleEvent(FirstThat(@ContainsMouse))       { Pass to first }
        else
            ForEach(TCallbackProcParam(@DoHandleEvent)); { Pass to all }
      end;
end;

{--TGroup-------------------------------------------------------------------}
{  ChangeBounds -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB      }
{---------------------------------------------------------------------------}
procedure TGroup.ChangeBounds(const Bounds: TRect);
var
    D: TPoint;

    procedure DoCalcChange(P: PView);
    var
        R: TRect;
    begin
        P^.CalcBounds(R, D);                             { Calc view bounds }
        P^.ChangeBounds(R);                              { Change view bounds }
    end;

begin
    D.X := Bounds.B.X - Bounds.A.X - Size.X;           { Delta x value }
    D.Y := Bounds.B.Y - Bounds.A.Y - Size.Y;           { Delta y value }
    if ((D.X = 0) and (D.Y = 0)) then
      begin
        SetBounds(Bounds);                               { Set new bounds }
        { Force redraw }
        ReDraw;                                        { Draw the view }
      end
    else
      begin
        SetBounds(Bounds);                               { Set new bounds }
        GetExtent(Clip);                                 { Get new clip extents }
        Lock;                                            { Lock drawing }
        ForEach(TCallbackProcParam(@DoCalcChange));      { Change each view }
        UnLock;                                          { Unlock drawing }
      end;
end;

{--TGroup-------------------------------------------------------------------}
{  GetSubViewPtr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 20May98 LdB     }
{---------------------------------------------------------------------------}
procedure TGroup.GetSubViewPtr(var S: TStream; var P);
var
    Index, I: Sw_Word;
    Q: PView;
begin
    Index := 0;                                        { Zero index value }
    S.Read(Index, SizeOf(Index));                      { Read view index }
    if (Index > 0) then
      begin                          { Valid index }
        Q := Last;                                       { Start on last }
        for I := 1 to Index do
            Q := Q^.Next;             { Loop for count }
        Pointer(P) := Q;                                 { Return the view }
      end
    else
        Pointer(P) := nil;                        { Return nil }
end;

{--TGroup-------------------------------------------------------------------}
{  PutSubViewPtr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 20May98 LdB     }
{---------------------------------------------------------------------------}
procedure TGroup.PutSubViewPtr(var S: TStream; P: PView);
var
    Index: Sw_Word;
begin
    if (P = nil) then
        Index := 0
    else                  { Nil view, Index = 0 }
        Index := IndexOf(P);                             { Calc view index }
    S.Write(Index, SizeOf(Index));                     { Write the index }
end;


{***************************************************************************}
{                       TGroup OBJECT PRIVATE METHODS                       }
{***************************************************************************}

{--TGroup-------------------------------------------------------------------}
{  IndexOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB           }
{---------------------------------------------------------------------------}
function TGroup.IndexOf(P: PView): Sw_Integer;
var
    I: Sw_Integer;
    Q: PView;
begin
    Q := Last;                                         { Start on last view }
    if (Q <> nil) then
      begin                           { Subviews exist }
        I := 1;                                          { Preset value }
        while (Q <> P) and (Q^.Next <> Last) do
          begin
            Q := Q^.Next;                                  { Load next view }
            Inc(I);                                        { Increment count }
          end;
        if (Q <> P) then
            IndexOf := 0
        else
            IndexOf := I; { Return index }
      end
    else
        IndexOf := 0;                             { Return zero }
end;

{--TGroup-------------------------------------------------------------------}
{  FindNext -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23Sep99 LdB          }
{---------------------------------------------------------------------------}
function TGroup.FindNext(Forwards: boolean): PView;
var
    P: PView;
begin
    FindNext := nil;                                   { Preset nil return }
    if (Current <> nil) then
      begin                     { Has current view }
        P := Current;                                    { Start on current }
        repeat
            if Forwards then
                P := P^.Next                  { Get next view }
            else
                P := P^.Prev;                           { Get prev view }
        until ((P^.State and (sfVisible + sfDisabled) = sfVisible) and
                (P^.Options and ofSelectable <> 0)) or          { Tab selectable }
            (P = Current);                                   { Not singular select }
        if (P <> Current) then
            FindNext := P;            { Return result }
      end;
end;

{--TGroup-------------------------------------------------------------------}
{  FirstMatch -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
function TGroup.FirstMatch(AState: word; AOptions: word): PView;

    function Matches(P: PView): boolean;
    begin
        Matches := (P^.State and AState = AState) and
            (P^.Options and AOptions = AOptions);          { Return match state }
    end;

begin
    FirstMatch := FirstThat(@Matches);                 { Return first match }
end;

{--TGroup-------------------------------------------------------------------}
{  ResetCurrent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB      }
{---------------------------------------------------------------------------}
procedure TGroup.ResetCurrent;
begin
    SetCurrent(FirstMatch(sfVisible, ofSelectable),
        NormalSelect);                                   { Reset current view }
end;

{--TGroup-------------------------------------------------------------------}
{  RemoveView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TGroup.RemoveView(P: PView);
var
    Q: PView;
begin
    if (P <> nil) and (Last <> nil) then
      begin         { Check view is valid }
        Q := Last;                                       { Start on last view }
        while (Q^.Next <> P) and (Q^.Next <> Last) do
            Q := Q^.Next;                                  { Find prior view }
        if (Q^.Next = P) then
          begin                      { View found }
            if (Q^.Next <> Q) then
              begin                   { Not only view }
                Q^.Next := P^.Next;                          { Rechain views }
                if (P = Last) then
                    Last := P^.Next;          { Fix if last removed }
              end
            else
                Last := nil;                          { Only view }
          end;
      end;
end;

{--TGroup-------------------------------------------------------------------}
{  InsertView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TGroup.InsertView(P, Target: PView);
begin
    if (P <> nil) then
      begin                           { Check view is valid }
        P^.Owner := @Self;                               { Views owner is us }
        if (Target <> nil) then
          begin                    { Valid target }
            Target := Target^.Prev;                        { 1st part of chain }
            P^.Next := Target^.Next;                       { 2nd part of chain }
            Target^.Next := P;                             { Chain completed }
          end
        else
          begin
            if (Last <> nil) then
              begin                    { Not first view }
                P^.Next := Last^.Next;                       { 1st part of chain }
                Last^.Next := P;                             { Completed chain }
              end
            else
                P^.Next := P;                         { 1st chain to self }
            Last := P;                                     { P is now last }
          end;
      end;
end;

{--TGroup-------------------------------------------------------------------}
{  SetCurrent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23Sep99 LdB        }
{---------------------------------------------------------------------------}
procedure TGroup.SetCurrent(P: PView; Mode: SelectMode);

    procedure SelectView(P: PView; Enable: boolean);
    begin
        if (P <> nil) then                               { View is valid }
            P^.SetState(sfSelected, Enable);               { Select the view }
    end;

    procedure FocusView(P: PView; Enable: boolean);
    begin
        if (State and sfFocused <> 0) and (P <> nil)     { Check not focused } then
            P^.SetState(sfFocused, Enable);           { Focus the view }
    end;

begin
    if (Current <> P) then
      begin                         { Not already current }
        Lock;                                            { Stop drawing }
        FocusView(Current, False);                       { Defocus current }
        if (Mode <> EnterSelect) then
            SelectView(Current, False);                    { Deselect current }
        if (Mode <> LeaveSelect) then
            SelectView(P, True); { Select view P }
        FocusView(P, True);                              { Focus view P }
        Current := P;                                    { Set as current view }
        UnLock;                                          { Redraw now }
      end;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TFrame OBJECT METHODS                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TFrame-------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB              }
{---------------------------------------------------------------------------}
constructor TFrame.Init(var Bounds: TRect);
begin
    inherited Init(Bounds);                            { Call ancestor }
    GrowMode := gfGrowHiX + gfGrowHiY;                 { Set grow modes }
    EventMask := EventMask or evBroadcast;             { See broadcasts }
end;

procedure TFrame.FrameLine(var FrameBuf; Y, N: Sw_Integer; Color: byte);
const
    InitFrame: array[0..17] of byte =
        ($06, $0A, $0C, $05, $00, $05, $03, $0A, $09,
        $16, $1A, $1C, $15, $00, $15, $13, $1A, $19);
    FrameChars_437: array[0..31] of char =
        '   À ³ÚÃ ÙÄÁ¿´ÂÅ   È ºÉÇ ¼ÍÏ»¶ÑÎ';
    FrameChars_850: array[0..31] of char =
        '   À ³ÚÃ ÙÄÁ¿´ÂÅ   È ºÉº ¼ÍÍ»ºÍÎ';
var
    FrameMask: array[0..MaxViewWidth - 1] of byte;
    ColorMask: word;
    i, j, k: {Sw_  lo and hi are used !! }integer;
    CurrView: PView;
    p: PChar;
begin
    FrameMask[0] := InitFrame[n];
    FillChar(FrameMask[1], Size.X - 2, InitFrame[n + 1]);
    FrameMask[Size.X - 1] := InitFrame[n + 2];
    CurrView := Owner^.Last^.Next;
    while (CurrView <> PView(@Self)) do
      begin
        if ((CurrView^.Options and ofFramed) <> 0) and
            ((CurrView^.State and sfVisible) <> 0) then
          begin
            i := Y - CurrView^.Origin.Y;
            if (i < 0) then
              begin
                Inc(i);
                if i = 0 then
                    i := $0a06
                else
                    i := 0;
              end
            else
              begin
                if i < CurrView^.Size.Y then
                    i := $0005
                else
                if i = CurrView^.Size.Y then
                    i := $0a03
                else
                    i := 0;
              end;
            if (i <> 0) then
              begin
                j := CurrView^.Origin.X;
                k := CurrView^.Size.X + j;
                if j < 1 then
                    j := 1;
                if k > Size.X then
                    k := Size.X;
                if (k > j) then
                  begin
                    FrameMask[j - 1] := FrameMask[j - 1] or lo(i);
                    i := (lo(i) xor hi(i)) or (i and $ff00);
                    FrameMask[k] := FrameMask[k] or lo(i);
                    if hi(i) <> 0 then
                      begin
                        Dec(k, j);
                        repeat
                            FrameMask[j] := FrameMask[j] or hi(i);
                            Inc(j);
                            Dec(k);
                        until k = 0;
                      end;
                  end;
              end;
          end;
        CurrView := CurrView^.Next;
      end;
    ColorMask := Color shl 8;
    p := framechars_437;
  {$ifdef unix}
  {Codepage variables are currently Unix only.}
  if internal_codepage<>cp437 then
    p:=framechars_850;
  {$endif}
    for i := 0 to Size.X - 1 do
        TVideoBuf(FrameBuf)[i] := Ord(p[FrameMask[i]]) or ColorMask;
end;


procedure TFrame.Draw;
const
    LargeC: array[boolean] of char = ('^', #24);
    RestoreC: array[boolean] of char = ('|', #18);
    ClickC: array[boolean] of char = ('*', #15);
var
    CFrame, CTitle: word;
    F, I, L, Width: Sw_Integer;
    B: TDrawBuffer;
    Title: TTitleStr;
    Min, Max: TPoint;
begin
    if State and sfDragging <> 0 then
      begin
        CFrame := $0505;
        CTitle := $0005;
        F := 0;
      end
    else if State and sfActive = 0 then
      begin
        CFrame := $0101;
        CTitle := $0002;
        F := 0;
      end
    else
      begin
        CFrame := $0503;
        CTitle := $0004;
        F := 9;
      end;
    CFrame := GetColor(CFrame);
    CTitle := GetColor(CTitle);
    Width := Size.X;
    L := Width - 10;
    if PWindow(Owner)^.Flags and (wfClose + wfZoom) <> 0 then
        Dec(L, 6);
    FrameLine(B, 0, F, byte(CFrame));
    if (PWindow(Owner)^.Number <> wnNoNumber) and (PWindow(Owner)^.Number < 10) then
      begin
        Dec(L, 4);
        if PWindow(Owner)^.Flags and wfZoom <> 0 then
            I := 7
        else
            I := 3;
        WordRec(B[Width - I]).Lo := PWindow(Owner)^.Number + $30;
      end;
    if Owner <> nil then
        Title := PWindow(Owner)^.GetTitle(L)
    else
        Title := '';
    if Title <> '' then
      begin
        L := Length(Title);
        if L > Width - 10 then
            L := Width - 10;
        if L < 0 then
            L := 0;
        I := (Width - L) shr 1;
        MoveChar(B[I - 1], ' ', CTitle, 1);
        MoveBuf(B[I], Title[1], CTitle, L);
        MoveChar(B[I + L], ' ', CTitle, 1);
      end;
    if State and sfActive <> 0 then
      begin
        if PWindow(Owner)^.Flags and wfClose <> 0 then
            if FrameMode and fmCloseClicked = 0 then
                MoveCStr(B[2], '[~þ~]', CFrame)
            else
                MoveCStr(B[2], '[~' + ClickC[LowAscii] + '~]', CFrame);
        if PWindow(Owner)^.Flags and wfZoom <> 0 then
          begin
            MoveCStr(B[Width - 5], '[~' + LargeC[LowAscii] + '~]', CFrame);
            Owner^.SizeLimits(Min, Max);
            if FrameMode and fmZoomClicked <> 0 then
                WordRec(B[Width - 4]).Lo := Ord(ClickC[LowAscii])
            else
            if (Owner^.Size.X = Max.X) and (Owner^.Size.Y = Max.Y) then
                WordRec(B[Width - 4]).Lo := Ord(RestoreC[LowAscii]);
          end;
      end;
    WriteLine(0, 0, Size.X, 1, B);
    for I := 1 to Size.Y - 2 do
      begin
        FrameLine(B, I, F + 3, byte(CFrame));
        WriteLine(0, I, Size.X, 1, B);
      end;
    FrameLine(B, Size.Y - 1, F + 6, byte(CFrame));
    if State and sfActive <> 0 then
        if PWindow(Owner)^.Flags and wfGrow <> 0 then
            MoveCStr(B[Width - 2], '~ÄÙ~', CFrame);
    WriteLine(0, Size.Y - 1, Size.X, 1, B);
end;

{--TFrame-------------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB        }
{---------------------------------------------------------------------------}
function TFrame.GetPalette: PPalette;
const
    P: string
{$ifopt H-}[Length(CFrame)]{$endif}
    = CFrame;             { Always normal string }
begin
    GetPalette := PPalette(@P);                        { Return palette }
end;

procedure TFrame.HandleEvent(var Event: TEvent);
var
    Mouse: TPoint;

    procedure DragWindow(Mode: byte);
    var
        Limits: TRect;
        Min, Max: TPoint;
    begin
        Owner^.Owner^.GetExtent(Limits);
        Owner^.SizeLimits(Min, Max);
        Owner^.DragView(Event, Owner^.DragMode or Mode, Limits, Min, Max);
        ClearEvent(Event);
    end;

begin
    TView.HandleEvent(Event);
    if Event.What = evMouseDown then
      begin
        MakeLocal(Event.Where, Mouse);
        if Mouse.Y = 0 then
          begin
            if (PWindow(Owner)^.Flags and wfClose <> 0) and
                (State and sfActive <> 0) and (Mouse.X >= 2) and (Mouse.X <= 4) then
              begin
                {Close button clicked.}
                repeat
                    MakeLocal(Event.Where, Mouse);
                    if (Mouse.X >= 2) and (Mouse.X <= 4) and (Mouse.Y = 0) then
                        FrameMode := fmCloseClicked
                    else
                        FrameMode := 0;
                    DrawView;
                until not MouseEvent(Event, evMouseMove + evMouseAuto);
                FrameMode := 0;
                if (Mouse.X >= 2) and (Mouse.X <= 4) and (Mouse.Y = 0) then
                  begin
                    Event.What := evCommand;
                    Event.Command := cmClose;
                    Event.InfoPtr := Owner;
                    PutEvent(Event);
                  end;
                ClearEvent(Event);
                DrawView;
              end
            else
            if (PWindow(Owner)^.Flags and wfZoom <> 0) and
                (State and sfActive <> 0) and (Event.double or
                (Mouse.X >= Size.X - 5) and (Mouse.X <= Size.X - 3)) then
              begin
                {Zoom button clicked.}
                if not Event.double then
                    repeat
                        MakeLocal(Event.Where, Mouse);
                        if (Mouse.X >= Size.X - 5) and (Mouse.X <= Size.X - 3) and
                            (Mouse.Y = 0) then
                            FrameMode := fmZoomClicked
                        else
                            FrameMode := 0;
                        DrawView;
                    until not MouseEvent(Event, evMouseMove + evMouseAuto);
                FrameMode := 0;
                if ((Mouse.X >= Size.X - 5) and (Mouse.X <= Size.X - 3) and
                    (Mouse.Y = 0)) or Event.double then
                  begin
                    Event.What := evCommand;
                    Event.Command := cmZoom;
                    Event.InfoPtr := Owner;
                    PutEvent(Event);
                  end;
                ClearEvent(Event);
                DrawView;
              end
            else
            if PWindow(Owner)^.Flags and wfMove <> 0 then
                DragWindow(dmDragMove);
          end
        else
        if (State and sfActive <> 0) and (Mouse.X >= Size.X - 2) and
            (Mouse.Y >= Size.Y - 1) then
            if PWindow(Owner)^.Flags and wfGrow <> 0 then
                DragWindow(dmDragGrow);
      end;
end;


procedure TFrame.SetState(AState: word; Enable: boolean);
begin
    TView.SetState(AState, Enable);
    if AState and (sfActive + sfDragging) <> 0 then
        DrawView;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TScrollBar OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}


{--TScrollBar---------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May98 LdB              }
{---------------------------------------------------------------------------}
constructor TScrollBar.Init(var Bounds: TRect);
const
    VChars: array[boolean] of TScrollChars =
        (('^', 'V', #177, #254, #178), (#30, #31, #177, #254, #178));
    HChars: array[boolean] of TScrollChars =
        (('<', '>', #177, #254, #178), (#17, #16, #177, #254, #178));
begin
    inherited Init(Bounds);                            { Call ancestor }
    PgStep := 1;                                       { Page step size = 1 }
    ArStep := 1;                                       { Arrow step sizes = 1 }
    if (Size.X = 1) then
      begin                         { Vertical scrollbar }
        GrowMode := gfGrowLoX + gfGrowHiX + gfGrowHiY;   { Grow vertically }
        Chars := VChars[LowAscii];                       { Vertical chars }
      end
    else
      begin                                     { Horizontal scrollbar }
        GrowMode := gfGrowLoY + gfGrowHiX + gfGrowHiY;   { Grow horizontal }
        Chars := HChars[LowAscii];                       { Horizontal chars }
      end;
end;

{--TScrollBar---------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May98 LdB              }
{---------------------------------------------------------------------------}
{   This load method will read old original TV data from a stream with the  }
{   scrollbar id set to zero.                                               }
{---------------------------------------------------------------------------}
constructor TScrollBar.Load(var S: TStream);
var
    i: integer;
begin
    inherited Load(S);                                 { Call ancestor }
    S.Read(i, SizeOf(i));
    Value := i;                    { Read current value }
    S.Read(i, SizeOf(i));
    Min := i;                      { Read min value }
    S.Read(i, SizeOf(i));
    Max := i;                     { Read max value }
    S.Read(i, SizeOf(i));
    PgStep := i;                   { Read page step size }
    S.Read(i, SizeOf(i));
    ArStep := i;                   { Read arrow step size }
    S.Read(Chars, SizeOf(Chars));                      { Read scroll chars }
end;

{--TScrollBar---------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May98 LdB        }
{---------------------------------------------------------------------------}
function TScrollBar.GetPalette: PPalette;
const
    P: string
{$ifopt H-}[Length(CScrollBar)]{$endif}
    = CScrollBar;     { Always normal string }
begin
    GetPalette := PPalette(@P);                        { Return palette }
end;

{--TScrollBar---------------------------------------------------------------}
{  ScrollStep -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May98 LdB        }
{---------------------------------------------------------------------------}
function TScrollBar.ScrollStep(Part: Sw_Integer): Sw_Integer;
var
    Step: Sw_Integer;
begin
    if (Part and $0002 = 0) then
        Step := ArStep        { Range step size }
    else
        Step := PgStep;                             { Page step size }
    if (Part and $0001 = 0) then
        ScrollStep := -Step   { Upwards move }
    else
        ScrollStep := Step;                         { Downwards move }
end;

{--TScrollBar---------------------------------------------------------------}
{  ScrollDraw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May98 LdB        }
{---------------------------------------------------------------------------}
procedure TScrollBar.ScrollDraw;
var
    P: PView;
begin
    if (Id <> 0) then
      begin
        P := TopView;                                    { Get topmost view }
        NewMessage(P, evCommand, cmIdCommunicate, Id,
            Value, @Self);                                 { New Id style message }
      end;
    NewMessage(Owner, evBroadcast, cmScrollBarChanged,
        Id, Value, @Self);                               { Old TV style message }
end;


{--TScrollBar---------------------------------------------------------------}
{  SetValue -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19May98 LdB          }
{---------------------------------------------------------------------------}
procedure TScrollBar.SetValue(AValue: Sw_Integer);
begin
    SetParams(AValue, Min, Max, PgStep, ArStep);       { Set value }
end;

{--TScrollBar---------------------------------------------------------------}
{  SetRange -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19May98 LdB          }
{---------------------------------------------------------------------------}
procedure TScrollBar.SetRange(AMin, AMax: Sw_Integer);
begin
    SetParams(Value, AMin, AMax, PgStep, ArStep);      { Set range }
end;

{--TScrollBar---------------------------------------------------------------}
{  SetStep -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19May98 LdB           }
{---------------------------------------------------------------------------}
procedure TScrollBar.SetStep(APgStep, AArStep: Sw_Integer);
begin
    SetParams(Value, Min, Max, APgStep, AArStep);      { Set step sizes }
end;

{--TScrollBar---------------------------------------------------------------}
{  SetParams -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 21Jul99 LdB         }
{---------------------------------------------------------------------------}
procedure TScrollBar.SetParams(AValue, AMin, AMax, APgStep, AArStep: Sw_Integer);
var
    OldValue: Sw_Integer;
begin
    if (AMax < AMin) then
        AMax := AMin;                { Max below min fix up }
    if (AValue < AMin) then
        AValue := AMin;            { Value below min fix }
    if (AValue > AMax) then
        AValue := AMax;            { Value above max fix }
    OldValue := Value;
    if (Value <> AValue) or (Min <> AMin) or (Max <> AMax) then
      begin                           { Something changed }
        Min := AMin;                                   { Set new minimum }
        Max := AMax;                                   { Set new maximum }
        Value := AValue;                               { Set new value }
        DrawView;
        if OldValue <> AValue then
            ScrollDraw;
      end;
    PgStep := APgStep;                                 { Hold page step }
    ArStep := AArStep;                                 { Hold arrow step }
end;

{--TScrollBar---------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May98 LdB             }
{---------------------------------------------------------------------------}
{  You can save data to the stream compatable with the old original TV by   }
{  temporarily turning off the ofGrafVersion making the call to this store  }
{  routine and resetting the ofGrafVersion flag after the call.             }
{---------------------------------------------------------------------------}
procedure TScrollBar.Store(var S: TStream);
var
    i: integer;
begin
    TView.Store(S);                                    { TView.Store called }
    i := Value;
    S.Write(i, SizeOf(i));                    { Write current value }
    i := Min;
    S.Write(i, SizeOf(i));                      { Write min value }
    i := Max;
    S.Write(i, SizeOf(i));                      { Write max value }
    i := PgStep;
    S.Write(i, SizeOf(i));                   { Write page step size }
    i := ArStep;
    S.Write(i, SizeOf(i));                   { Write arrow step size }
    S.Write(Chars, SizeOf(Chars));                     { Write scroll chars }
end;

{--TScrollBar---------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May98 LdB       }
{---------------------------------------------------------------------------}
procedure TScrollBar.HandleEvent(var Event: TEvent);
var
    Tracking: boolean;
    I, P, S, ClickPart, Iv: Sw_Integer;
    Mouse: TPoint;
    Extent: TRect;

    function GetPartCode: Sw_Integer;
    var
        Mark, Part: Sw_Integer;
    begin
        Part := -1;                                      { Preset failure }
        if Extent.Contains(Mouse) then
          begin             { Contains mouse }
            if (Size.X = 1) then
              begin                     { Vertical scrollbar }
                Mark := Mouse.Y;                             { Calc position }
              end
            else
              begin                                 { Horizontal bar }
                Mark := Mouse.X;                             { Calc position }
              end;
            if (Mark >= P) and (Mark < P + 1) then           { Within thumbnail }
                Part := sbIndicator;                         { Indicator part }
            if (Part <> sbIndicator) then
              begin            { Not indicator part }
                if (Mark < 1) then
                    Part := sbLeftArrow
                else  { Left arrow part }
                if (Mark < P) then
                    Part := sbPageLeft
                else   { Page left part }
                if (Mark < S - 1) then
                    Part := sbPageRight
                else  { Page right part }
                    Part := sbRightArrow;                      { Right arrow part }
                if (Size.X = 1) then
                    Inc(Part, 4);           { Correct for vertical }
              end;
          end;
        GetPartCode := Part;                             { Return part code }
    end;

    procedure Clicked;
    begin
        NewMessage(Owner, evBroadcast, cmScrollBarClicked,
            Id, Value, @Self);                             { Old TV style message }
    end;

begin
    inherited HandleEvent(Event);                      { Call ancestor }
    case Event.What of
        evNothing: Exit;                                 { Speed up exit }
        evCommand:
          begin                                 { Command event }
            if (Event.Command = cmIdCommunicate) and       { Id communication }
                (Event.Id = Id) and (Event.InfoPtr <> @Self)   { Targeted to us } then
              begin
                SetValue(Round(Event.Data));                 { Set scrollbar value }
                ClearEvent(Event);                           { Event was handled }
              end;
          end;
        evKeyDown:
            if (State and sfVisible <> 0) then
              begin       { Scrollbar visible }
                ClickPart := sbIndicator;                    { Preset result }
                if (Size.Y = 1) then                         { Horizontal bar }
                    case CtrlToArrow(Event.KeyCode) of
                        kbLeft: ClickPart := sbLeftArrow;        { Left one item }
                        kbRight: ClickPart := sbRightArrow;      { Right one item }
                        kbCtrlLeft: ClickPart := sbPageLeft;     { One page left }
                        kbCtrlRight: ClickPart := sbPageRight;   { One page right }
                        kbHome: I := Min;                        { Move to start }
                        kbEnd: I := Max;                         { Move to end }
                        else
                            Exit;                               { Not a valid key }
                      end
                else                                         { Vertical bar }
                    case CtrlToArrow(Event.KeyCode) of
                        kbUp: ClickPart := sbUpArrow;            { One item up }
                        kbDown: ClickPart := sbDownArrow;        { On item down }
                        kbPgUp: ClickPart := sbPageUp;           { One page up }
                        kbPgDn: ClickPart := sbPageDown;         { One page down }
                        kbCtrlPgUp: I := Min;                    { Move to top }
                        kbCtrlPgDn: I := Max;                    { Move to bottom }
                        else
                            Exit;                               { Not a valid key }
                      end;
                Clicked;                                     { Send out message }
                if (ClickPart <> sbIndicator) then
                    I := Value + ScrollStep(ClickPart);        { Calculate position }
                SetValue(I);                                 { Set new item }
                ClearEvent(Event);                           { Event now handled }
              end;
        evMouseDown:
          begin                               { Mouse press event }
            Clicked;                                     { Scrollbar clicked }
            MakeLocal(Event.Where, Mouse);                 { Localize mouse }
            Extent.A.X := 0;                             { Zero x extent value }
            Extent.A.Y := 0;                             { Zero y extent value }
            Extent.B.X := Size.X;                        { Set extent x value }
            Extent.B.Y := Size.Y;                        { set extent y value }
            P := GetPos;                                 { Current position }
            S := GetSize;                                { Initial size }
            ClickPart := GetPartCode;                    { Get part code }
            if (ClickPart <> sbIndicator) then
              begin     { Not thumb nail }
                repeat
                    MakeLocal(Event.Where, Mouse);           { Localize mouse }
                    if GetPartCode = ClickPart then
                        SetValue(Value + ScrollStep(ClickPart)); { Same part repeat }
                until not MouseEvent(Event, evMouseAuto);  { Until auto done }
                Clicked;                                   { Scrollbar clicked }
              end
            else
              begin                               { Thumb nail move }
                Iv := Value;                               { Initial value }
                repeat
                    MakeLocal(Event.Where, Mouse);           { Localize mouse }
                    Tracking := Extent.Contains(Mouse);      { Check contains }
                    if Tracking then
                      begin                   { Tracking mouse }
                        if (Size.X = 1) then
                            I := Mouse.Y
                        else                    { Calc vert position }
                            I := Mouse.X;                        { Calc horz position }
                        if (I < 0) then
                            I := 0;                { Check underflow }
                        if (I > S) then
                            I := S;                { Check overflow }
                      end
                    else
                        I := GetPos;                    { Get position }
                    if (I <> P) then
                      begin
                        SetValue(longint((longint(I) * (Max - Min)) + (S shr 1)) div
                            S + Min);            { Set new value }
                        P := I;                                { Hold new position }
                      end;
                until not MouseEvent(Event, evMouseMove);  { Until not moving }
                if Tracking and (S > 0) then               { Tracking mouse }
                    SetValue(longint((longint(P) * (Max - Min)) + (S shr 1)) div
                        S + Min);
                { Set new value }
                if (Iv <> Value) then
                    Clicked;             { Scroll has moved }
              end;
            ClearEvent(Event);                           { Clear the event }
          end;
      end;
end;

{***************************************************************************}
{                 TScrollBar OBJECT PRIVATE METHODS                         }
{***************************************************************************}

{--TScrollBar---------------------------------------------------------------}
{  GetPos -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23May98 LdB            }
{---------------------------------------------------------------------------}
function TScrollBar.GetPos: Sw_Integer;
var
    R: Sw_Integer;
begin
    R := Max - Min;                                    { Get full range }
    if (R = 0) then
        GetPos := 1
    else                   { Return zero }
        GetPos := longint((longint(Value - Min) * (GetSize - 3)) + (R shr 1)) div R + 1;
    { Calc position }
end;

{--TScrollBar---------------------------------------------------------------}
{  GetSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23May98 LdB           }
{---------------------------------------------------------------------------}
function TScrollBar.GetSize: Sw_Integer;
var
    S: Sw_Integer;
begin
    if Size.X = 1 then
        S := Size.Y
    else
        S := Size.X;
    if (S < 3) then
        S := 3;                            { Fix minimum size }
    GetSize := S;                                      { Return size }
end;


{--TScrollBar---------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 27Oct99 LdB              }
{---------------------------------------------------------------------------}
procedure TScrollBar.Draw;
begin
    DrawPos(GetPos);                                 { Draw position }
end;


procedure TScrollBar.DrawPos(Pos: Sw_Integer);
var
    S: Sw_Integer;
    B: TDrawBuffer;
begin
    S := GetSize - 1;
    MoveChar(B[0], Chars[0], GetColor(2), 1);
    if Max = Min then
        MoveChar(B[1], Chars[4], GetColor(1), S - 1)
    else
      begin
        MoveChar(B[1], Chars[2], GetColor(1), S - 1);
        MoveChar(B[Pos], Chars[3], GetColor(3), 1);
      end;
    MoveChar(B[S], Chars[1], GetColor(2), 1);
    WriteBuf(0, 0, Size.X, Size.Y, B);
end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TScroller OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TScroller----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB              }
{---------------------------------------------------------------------------}
constructor TScroller.Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar);
begin
    inherited Init(Bounds);                            { Call ancestor }
    Options := Options or ofSelectable;                { View is selectable }
    EventMask := EventMask or evBroadcast;             { See broadcasts }
    HScrollBar := AHScrollBar;                         { Hold horz scrollbar }
    VScrollBar := AVScrollBar;                         { Hold vert scrollbar }
end;

{--TScroller----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB              }
{---------------------------------------------------------------------------}
{   This load method will read old original TV data from a stream as well   }
{   as the new graphical scroller views.                                    }
{---------------------------------------------------------------------------}
constructor TScroller.Load(var S: TStream);
var
    i: integer;
begin
    inherited Load(S);                                 { Call ancestor }
    GetPeerViewPtr(S, HScrollBar);                     { Load horz scrollbar }
    GetPeerViewPtr(S, VScrollBar);                     { Load vert scrollbar }
    S.Read(i, SizeOf(i));
    Delta.X := i;                  { Read delta x value }
    S.Read(i, SizeOf(i));
    Delta.Y := i;                  { Read delta y value }
    S.Read(i, SizeOf(i));
    Limit.X := i;                  { Read limit x value }
    S.Read(i, SizeOf(i));
    Limit.Y := i;                  { Read limit y value }
end;

{--TScroller----------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB        }
{---------------------------------------------------------------------------}
function TScroller.GetPalette: PPalette;
const
    P: string
{$ifopt H-}[Length(CScroller)]{$endif}
    = CScroller;       { Always normal string }
begin
    GetPalette := PPalette(@P);                        { Scroller palette }
end;

{--TScroller----------------------------------------------------------------}
{  ScrollTo -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB          }
{---------------------------------------------------------------------------}
procedure TScroller.ScrollTo(X, Y: Sw_Integer);
begin
    Inc(DrawLock);                                     { Set draw lock }
    if (HScrollBar <> nil) then
        HScrollBar^.SetValue(X); { Set horz scrollbar }
    if (VScrollBar <> nil) then
        VScrollBar^.SetValue(Y); { Set vert scrollbar }
    Dec(DrawLock);                                     { Release draw lock }
    CheckDraw;                                         { Check need to draw }
end;

{--TScroller----------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB          }
{---------------------------------------------------------------------------}
procedure TScroller.SetState(AState: word; Enable: boolean);

    procedure ShowSBar(SBar: PScrollBar);
    begin
        if (SBar <> nil) then                            { Scroll bar valid }
            if GetState(sfActive + sfSelected) then        { Check state masks }
                SBar^.Show
            else
                SBar^.Hide;                  { Draw appropriately }
    end;

begin
    inherited SetState(AState, Enable);                { Call ancestor }
    if (AState and (sfActive + sfSelected) <> 0)       { Active/select change } then
      begin
        ShowSBar(HScrollBar);                            { Redraw horz scrollbar }
        ShowSBar(VScrollBar);                            { Redraw vert scrollbar }
      end;
end;

{--TScroller----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB             }
{---------------------------------------------------------------------------}
{  The scroller is saved to the stream compatable with the old TV object.   }
{---------------------------------------------------------------------------}
procedure TScroller.Store(var S: TStream);
var
    i: integer;
begin
    TView.Store(S);                                    { Call TView explicitly }
    PutPeerViewPtr(S, HScrollBar);                     { Store horz bar }
    PutPeerViewPtr(S, VScrollBar);                     { Store vert bar }
    i := Delta.X;
    S.Write(i, SizeOf(i));                  { Write delta x value }
    i := Delta.Y;
    S.Write(i, SizeOf(i));                  { Write delta y value }
    i := Limit.X;
    S.Write(i, SizeOf(i));                  { Write limit x value }
    i := Limit.Y;
    S.Write(i, SizeOf(i));                  { Write limit y value }
end;

{--TScroller----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB       }
{---------------------------------------------------------------------------}
procedure TScroller.HandleEvent(var Event: TEvent);
begin
    inherited HandleEvent(Event);                      { Call ancestor }
    if (Event.What = evBroadcast) and (Event.Command = cmScrollBarChanged) and
        { Scroll bar change }
        ((Event.InfoPtr = HScrollBar) or                 { Our scrollbar? }
        (Event.InfoPtr = VScrollBar)) then
        ScrollDraw;  { Redraw scroller }
end;

{--TScroller----------------------------------------------------------------}
{  ChangeBounds -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB      }
{---------------------------------------------------------------------------}
procedure TScroller.ChangeBounds(const Bounds: TRect);
begin
    SetBounds(Bounds);                                 { Set new bounds }
    Inc(DrawLock);                                     { Set draw lock }
    SetLimit(Limit.X, Limit.Y);                        { Adjust limits }
    Dec(DrawLock);                                     { Release draw lock }
    DrawFlag := False;                                 { Clear draw flag }
    DrawView;                                          { Redraw now }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TListViewer OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

const
    TvListViewerName = 'LISTBOX';                   { Native name }

{--TListViewer--------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28May98 LdB              }
{---------------------------------------------------------------------------}
constructor TListViewer.Init(var Bounds: TRect; ANumCols: Sw_Word;
    AHScrollBar, AVScrollBar: PScrollBar);
var
    ArStep, PgStep: Sw_Integer;
begin
    inherited Init(Bounds);                            { Call ancestor }
    Options := Options or (ofFirstClick + ofSelectable); { Set options }
    EventMask := EventMask or evBroadcast;             { Set event mask }
    NumCols := ANumCols;                               { Hold column number }
    if (AVScrollBar <> nil) then
      begin                 { Chk vert scrollbar }
        if (NumCols = 1) then
          begin                      { Only one column }
            PgStep := Size.Y - 1;                           { Set page size }
            ArStep := 1;                                   { Set step size }
          end
        else
          begin                                   { Multiple columns }
            PgStep := Size.Y * NumCols;                    { Set page size }
            ArStep := Size.Y;                              { Set step size }
          end;
        AVScrollBar^.SetStep(PgStep, ArStep);            { Set scroll values }
      end;
    if (AHScrollBar <> nil) then
        AHScrollBar^.SetStep(Size.X div NumCols, 1);     { Set step size }
    HScrollBar := AHScrollBar;                         { Horz scrollbar held }
    VScrollBar := AVScrollBar;                         { Vert scrollbar held }
end;

{--TListViewer--------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28May98 LdB              }
{---------------------------------------------------------------------------}
constructor TListViewer.Load(var S: TStream);
var
    w: word;
begin
    inherited Load(S);                                 { Call ancestor }
    GetPeerViewPtr(S, HScrollBar);                     { Get horz scrollbar }
    GetPeerViewPtr(S, VScrollBar);                     { Get vert scrollbar }
    S.Read(w, SizeOf(w));
    NumCols := w;                  { Read column number }
    S.Read(w, SizeOf(w));
    TopItem := w;                  { Read top most item }
    S.Read(w, SizeOf(w));
    Focused := w;                  { Read focused item }
    S.Read(w, SizeOf(w));
    Range := w;                    { Read listview range }
end;

{--TListViewer--------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28May98 LdB        }
{---------------------------------------------------------------------------}
function TListViewer.GetPalette: PPalette;
const
    P: string
{$ifopt H-}[Length(CListViewer)]{$endif}
    = CListViewer;   { Always normal string }
begin
    GetPalette := PPalette(@P);                        { Return palette }
end;

{--TListViewer--------------------------------------------------------------}
{  IsSelected -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28May98 LdB        }
{---------------------------------------------------------------------------}
function TListViewer.IsSelected(Item: Sw_Integer): boolean;
begin
    if (Item = Focused) then
        IsSelected := True
    else
        IsSelected := False;                             { Selected item }
end;

{--TListViewer--------------------------------------------------------------}
{  GetText -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28May98 LdB           }
{---------------------------------------------------------------------------}
function TListViewer.GetText(Item: Sw_Integer; MaxLen: Sw_Integer): string;
begin                                                 { Abstract method }
    GetText := '';                                     { Return empty }
end;

{--TListViewer--------------------------------------------------------------}
{  DrawBackGround -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 27Oct99 LdB    }
{---------------------------------------------------------------------------}
procedure TListViewer.Draw;
var
    I, J, ColWidth, Item, Indent, CurCol: Sw_Integer;
    Color: word;
    SCOff: byte;
    Text: string;
    B: TDrawBuffer;
begin
    ColWidth := Size.X div NumCols + 1;                { Calc column width }
    if (HScrollBar = nil) then
        Indent := 0
    else        { Set indent to zero }
        Indent := HScrollBar^.Value;                     { Fetch any indent }
    for I := 0 to Size.Y - 1 do
      begin                  { For each line }
        for J := 0 to NumCols - 1 do
          begin                 { For each column }
            Item := J * Size.Y + I + TopItem;                { Process this item }
            CurCol := J * ColWidth;                          { Current column }
            if (State and (sfSelected + sfActive) = (sfSelected + sfActive)) and
                (Focused = Item)  { Focused item } and (Range > 0) then
              begin
                Color := GetColor(3);                        { Focused colour }
                SetCursor(CurCol + 1, I);                       { Set the cursor }
                SCOff := 0;                                  { Zero colour offset }
              end
            else if (Item < Range) and IsSelected(Item){ Selected item } then
              begin
                Color := GetColor(4);                        { Selected color }
                SCOff := 2;                                  { Colour offset=2 }
              end
            else
              begin
                Color := GetColor(2);                        { Normal Color }
                SCOff := 4;                                  { Colour offset=4 }
              end;
            MoveChar(B[CurCol], ' ', Color, ColWidth);     { Clear buffer }
            if (Item < Range) then
              begin                   { Within text range }
                Text := GetText(Item, ColWidth + Indent);    { Fetch text }
                Text := Copy(Text, Indent, ColWidth);        { Select right bit }
                MoveStr(B[CurCol + 1], Text, Color);           { Transfer to buffer }
                if ShowMarkers then
                  begin
                    WordRec(B[CurCol]).Lo := byte(SpecialChars[SCOff]);
                    { Set marker character }
                    WordRec(B[CurCol + ColWidth - 2]).Lo := byte(SpecialChars[SCOff + 1]);
                    { Set marker character }
                  end;
              end;
            MoveChar(B[CurCol + ColWidth - 1], #179,
                GetColor(5), 1);                             { Put centre line marker }
          end;
        WriteLine(0, I, Size.X, 1, B);                 { Write line to screen }
      end;
end;


{--TListViewer--------------------------------------------------------------}
{  FocusItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB         }
{---------------------------------------------------------------------------}
procedure TListViewer.FocusItem(Item: Sw_Integer);
begin
    Focused := Item;                                   { Set focus to item }
    if (VScrollBar <> nil) then
        VScrollBar^.SetValue(Item);                      { Scrollbar to value }
    if (Item < TopItem) then                           { Item above top item }
        if (NumCols = 1) then
            TopItem := Item            { Set top item }
        else
            TopItem := Item - Item mod Size.Y         { Set top item }
    else if (Item >= TopItem + (Size.Y * NumCols)) then  { Item below bottom }
        if (NumCols = 1) then
            TopItem := Item - Size.Y + 1   { Set new top item }
        else
            TopItem := Item - Item mod Size.Y - (Size.Y * (NumCols - 1));
    { Set new top item }
end;

{--TListViewer--------------------------------------------------------------}
{  SetTopItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Aug99 LdB        }
{---------------------------------------------------------------------------}
procedure TListViewer.SetTopItem(Item: Sw_Integer);
begin
    TopItem := Item;                                   { Set the top item }
end;

{--TListViewer--------------------------------------------------------------}
{  SetRange -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB          }
{---------------------------------------------------------------------------}
procedure TListViewer.SetRange(ARange: Sw_Integer);
begin
    Range := ARange;                                   { Set new range }
    if (VScrollBar <> nil) then
      begin                  { Vertical scrollbar }
        if (Focused > ARange) then
            Focused := 0;         { Clear focused }
        VScrollBar^.SetParams(Focused, 0, ARange - 1,
            VScrollBar^.PgStep, VScrollBar^.ArStep);       { Set parameters }
      end;
end;

{--TListViewer--------------------------------------------------------------}
{  SelectItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB        }
{---------------------------------------------------------------------------}
procedure TListViewer.SelectItem(Item: Sw_Integer);
begin
    Message(Owner, evBroadcast, cmListItemSelected, @Self);
    { Send message }
end;

{--TListViewer--------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 27Oct99 LdB          }
{---------------------------------------------------------------------------}
procedure TListViewer.SetState(AState: word; Enable: boolean);

    procedure ShowSBar(SBar: PScrollBar);
    begin
        if (SBar <> nil) then                            { Valid scrollbar }
            if GetState(sfActive) and GetState(sfVisible)  { Check states } then
                SBar^.Show
            else
                SBar^.Hide;             { Show or hide }
    end;

begin
    inherited SetState(AState, Enable);                { Call ancestor }
    if (AState and (sfSelected + sfActive + sfVisible) <> 0) then
      begin                                         { Check states }
        DrawView;                                        { Draw the view }
        ShowSBar(HScrollBar);                            { Show horz scrollbar }
        ShowSBar(VScrollBar);                            { Show vert scrollbar }
      end;
end;

{--TListViewer--------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB             }
{---------------------------------------------------------------------------}
procedure TListViewer.Store(var S: TStream);
var
    w: word;
begin
    TView.Store(S);                                    { Call TView explicitly }
    PutPeerViewPtr(S, HScrollBar);                     { Put horz scrollbar }
    PutPeerViewPtr(S, VScrollBar);                     { Put vert scrollbar }
    w := NumCols;
    S.Write(w, SizeOf(w));                  { Write column number }
    w := TopItem;
    S.Write(w, SizeOf(w));                  { Write top most item }
    w := Focused;
    S.Write(w, SizeOf(w));                  { Write focused item }
    w := Range;
    S.Write(w, SizeOf(w));                    { Write listview range }
end;

{--TListViewer--------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 27Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure TListViewer.HandleEvent(var Event: TEvent);
const
    MouseAutosToSkip = 4;
var
    Oi, Ni: Sw_Integer;
    Ct, Cw: word;
    Mouse: TPoint;

    procedure MoveFocus(Req: Sw_Integer);
    begin
        FocusItemNum(Req);                               { Focus req item }
        DrawView;                                      { Redraw focus box }
    end;

begin
    inherited HandleEvent(Event);                      { Call ancestor }
    case Event.What of
        evNothing: Exit;                                 { Speed up exit }
        evKeyDown:
          begin                                 { Key down event }
            if (Event.CharCode = ' ') and (Focused < Range){ Spacebar select } then
              begin
                SelectItem(Focused);                         { Select focused item }
                Ni := Focused;                               { Hold new item }
              end
            else
                case CtrlToArrow(Event.KeyCode) of
                    kbUp: Ni := Focused - 1;                     { One item up }
                    kbDown: Ni := Focused + 1;                   { One item down }
                    kbRight: if (NumCols > 1) then
                            Ni := Focused + Size.Y
                        else
                            Exit;          { One column right }
                    kbLeft: if (NumCols > 1) then
                            Ni := Focused - Size.Y
                        else
                            Exit;          { One column left }
                    kbPgDn: Ni := Focused + Size.Y * NumCols;    { One page down }
                    kbPgUp: Ni := Focused - Size.Y * NumCols;    { One page up }
                    kbHome: Ni := TopItem;                       { Move to top }
                    kbEnd: Ni := TopItem + (Size.Y * NumCols) - 1;   { Move to bottom }
                    kbCtrlPgDn: Ni := Range - 1;                 { Move to last item }
                    kbCtrlPgUp: Ni := 0;                         { Move to first item }
                    else
                        Exit;
                  end;
            MoveFocus(Ni);                                 { Move the focus }
            ClearEvent(Event);                             { Event was handled }
          end;
        evBroadcast:
          begin                               { Broadcast event }
            if (Options and ofSelectable <> 0) then        { View is selectable }
                if (Event.Command = cmScrollBarClicked) and  { Scrollbar click }
                    ((Event.InfoPtr = HScrollBar) or (Event.InfoPtr = VScrollBar)) then
                    Select    { Scrollbar selects us }
                else if (Event.Command = cmScrollBarChanged) { Scrollbar changed } then
                  begin
                    if (VScrollBar = Event.InfoPtr) then
                      begin
                        MoveFocus(VScrollBar^.Value);            { Focus us to item }
                      end
                    else if (HScrollBar = Event.InfoPtr) then
                        DrawView;                           { Redraw the view }
                  end;
          end;
        evMouseDown:
          begin                               { Mouse down event }
            Cw := Size.X div NumCols + 1;                  { Column width }
            Oi := Focused;                                 { Hold focused item }
            MakeLocal(Event.Where, Mouse);                 { Localize mouse }
            if MouseInView(Event.Where) then
                Ni := Mouse.Y + (Size.Y * (Mouse.X div Cw)) + TopItem          { Calc item to focus }
            else
                Ni := Oi;                               { Focus old item }
            Ct := 0;                                       { Clear count value }
            repeat
                if (Ni <> Oi) then
                  begin                     { Item is different }
                    MoveFocus(Ni);                             { Move the focus }
                    Oi := Focused;                             { Hold as focused item }
                  end;
                MakeLocal(Event.Where, Mouse);               { Localize mouse }
                if not MouseInView(Event.Where) then
                  begin
                    if (Event.What = evMouseAuto) then
                        Inc(Ct);{ Inc auto count }
                    if (Ct = MouseAutosToSkip) then
                      begin
                        Ct := 0;                                 { Reset count }
                        if (NumCols = 1) then
                          begin              { Only one column }
                            if (Mouse.Y < 0) then
                                Ni := Focused - 1; { Move up one item  }
                            if (Mouse.Y >= Size.Y) then
                                Ni := Focused + 1;                     { Move down one item }
                          end
                        else
                          begin                           { Multiple columns }
                            if (Mouse.X < 0) then                  { Mouse x below zero }
                                Ni := Focused - Size.Y;                { Move down 1 column }
                            if (Mouse.X >= Size.X) then            { Mouse x above width }
                                Ni := Focused + Size.Y;                { Move up 1 column }
                            if (Mouse.Y < 0) then                  { Mouse y below zero }
                                Ni := Focused - Focused mod Size.Y;    { Move up one item }
                            if (Mouse.Y > Size.Y) then             { Mouse y above height }
                                Ni := Focused - Focused mod Size.Y + Size.Y - 1;
                            { Move down one item }
                          end;
                      end;
                  end
                else
                    Ni := Mouse.Y + (Size.Y * (Mouse.X div Cw)) + TopItem;
                { New item to focus }
            until not MouseEvent(Event, evMouseMove + evMouseAuto);
            { Mouse stopped }
            if (Oi <> Ni) then
                MoveFocus(Ni);              { Focus moved again }
            if (Event.double and (Range > Focused)) then
                SelectItem(Focused);                         { Select the item }
            ClearEvent(Event);                             { Event was handled }
          end;
      end;
end;

{--TListViewer--------------------------------------------------------------}
{  ChangeBounds -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB      }
{---------------------------------------------------------------------------}
procedure TListViewer.ChangeBounds(const Bounds: TRect);
begin
    inherited ChangeBounds(Bounds);                    { Call ancestor }
    if (HScrollBar <> nil) then                        { Valid horz scrollbar }
        HScrollBar^.SetStep(Size.X div NumCols,
            HScrollBar^.ArStep);                           { Update horz bar }
    if (VScrollBar <> nil) then                        { Valid vert scrollbar }
        VScrollBar^.SetStep(Size.Y * NumCols,
            VScrollBar^.ArStep);                           { Update vert bar }
end;

{***************************************************************************}
{                     TListViewer OBJECT PRIVATE METHODS                    }
{***************************************************************************}

{--TListViewer--------------------------------------------------------------}
{  FocusItemNum -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB      }
{---------------------------------------------------------------------------}
procedure TListViewer.FocusItemNum(Item: Sw_Integer);
begin
    if (Item < 0) then
        Item := 0
    else                  { Restrain underflow }
    if (Item >= Range) and (Range > 0) then
        Item := Range - 1;                               { Restrain overflow }
    if (Range <> 0) then
        FocusItem(Item);              { Set focus value }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TWindow OBJECT METHODS                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TWindow------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB              }
{---------------------------------------------------------------------------}
constructor TWindow.Init(var Bounds: TRect; ATitle: TTitleStr; ANumber: Sw_Integer);
begin
    inherited Init(Bounds);                            { Call ancestor }
    State := State or sfShadow;                        { View is shadowed }
    Options := Options or (ofSelectable + ofTopSelect);  { Select options set }
    GrowMode := gfGrowAll + gfGrowRel;                 { Set growmodes }
    Flags := wfMove + wfGrow + wfClose + wfZoom;       { Set flags }
    Title := NewStr(ATitle);                           { Hold title }
    Number := ANumber;                                 { Hold number }
    Palette := wpBlueWindow;                           { Default palette }
    InitFrame;                                         { Initialize frame }
    if (Frame <> nil) then
        Insert(Frame);              { Insert any frame }
    GetBounds(ZoomRect);                               { Default zoom rect }
end;

{--TWindow------------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB              }
{---------------------------------------------------------------------------}
{   This load method will read old original TV data from a stream however   }
{   although a frame view is read for compatability it is disposed of.      }
{---------------------------------------------------------------------------}
constructor TWindow.Load(var S: TStream);
var
    I: integer;
begin
    inherited Load(S);                                 { Call ancestor }
    S.Read(Flags, SizeOf(Flags));                      { Read window flags }
    S.Read(i, SizeOf(i));
    Number := i;                                { Read window number }
    S.Read(i, SizeOf(i));
    Palette := i;                               { Read window palette }
    S.Read(i, SizeOf(i));
    ZoomRect.A.X := i;                          { Read zoom area x1 }
    S.Read(i, SizeOf(i));
    ZoomRect.A.Y := i;                          { Read zoom area y1 }
    S.Read(i, SizeOf(i));
    ZoomRect.B.X := i;                          { Read zoom area x2 }
    S.Read(i, SizeOf(i));
    ZoomRect.B.Y := i;                          { Read zoom area y2 }
    GetSubViewPtr(S, Frame);                           { Now read frame object }
    Title := S.ReadStr;                                { Read title }
end;

{--TWindow------------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
destructor TWindow.Done;
begin
    inherited Done;                                    { Call ancestor }
    if (Title <> nil) then
        DisposeStr(Title);          { Dispose title }
end;

{--TWindow------------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
function TWindow.GetPalette: PPalette;
const
    P: array [wpBlueWindow..wpGrayWindow] of string
{$ifopt H-}[Length(CBlueWindow)]{$endif}
    =
        (CBlueWindow, CCyanWindow, CGrayWindow);            { Always normal string }
begin
    GetPalette := PPalette(@P[Palette]);               { Return palette }
end;

{--TWindow------------------------------------------------------------------}
{  GetTitle -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{  Modified 31may2002 PM  (No number included anymore)                      }
{---------------------------------------------------------------------------}
function TWindow.GetTitle(MaxSize: Sw_Integer): TTitleStr;
var
    S: string;
begin
    if (Title <> nil) then
        S := Title^
    else
        S := '';
    if Length(S) > MaxSize then
        GetTitle := Copy(S, 1, MaxSize)
    else
        GetTitle := S;
end;

{--TWindow------------------------------------------------------------------}
{  StandardScrollBar -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB }
{---------------------------------------------------------------------------}
function TWindow.StandardScrollBar(AOptions: word): PScrollBar;
var
    R: TRect;
    S: PScrollBar;
begin
    GetExtent(R);                                      { View extents }
    if (AOptions and sbVertical = 0) then
        R.Assign(R.A.X + 2, R.B.Y - 1, R.B.X - 2, R.B.Y)       { Horizontal scrollbar }
    else
        R.Assign(R.B.X - 1, R.A.Y + 1, R.B.X, R.B.Y - 1); { Vertical scrollbar }
    S := New(PScrollBar, Init(R));                     { Create scrollbar }
    Insert(S);                                         { Insert scrollbar }
    if (AOptions and sbHandleKeyboard <> 0) then
        S^.Options := S^.Options or ofPostProcess;       { Post process }
    StandardScrollBar := S;                            { Return scrollbar }
end;

{--TWindow------------------------------------------------------------------}
{  Zoom -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23Sep97 LdB              }
{---------------------------------------------------------------------------}
procedure TWindow.Zoom;
var
    R: TRect;
    Max, Min: TPoint;
begin
    SizeLimits(Min, Max);                              { Return size limits }
    if ((Size.X <> Max.X) or (Size.Y <> Max.Y))        { Larger size possible } then
      begin
        GetBounds(ZoomRect);                             { Get zoom bounds }
        R.A.X := 0;                                      { Zero x origin }
        R.A.Y := 0;                                      { Zero y origin }
        R.B := Max;                                      { Bounds to max size }
        Locate(R);                                       { Locate the view }
      end
    else
        Locate(ZoomRect);                         { Move to zoom rect }
end;

{--TWindow------------------------------------------------------------------}
{  Close -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23Sep97 LdB             }
{---------------------------------------------------------------------------}
procedure TWindow.Close;
begin
    if Valid(cmClose) then
        Free;                       { Dispose of self }
end;

{--TWindow------------------------------------------------------------------}
{  InitFrame -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jul99 LdB         }
{---------------------------------------------------------------------------}
procedure TWindow.InitFrame;
var
    R: TRect;
begin
    GetExtent(R);
    Frame := New(PFrame, Init(R));
end;

{--TWindow------------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Mar98 LdB          }
{---------------------------------------------------------------------------}
procedure TWindow.SetState(AState: word; Enable: boolean);
var
    WindowCommands: TCommandSet;
begin
    inherited SetState(AState, Enable);                { Call ancestor }
    if (AState = sfSelected) then
        SetState(sfActive, Enable);                      { Set active state }
    if (AState = sfSelected) or ((AState = sfExposed) and
        (State and sfSelected <> 0)) then
      begin        { View is selected }
        WindowCommands := [cmNext, cmPrev];              { Set window commands }
        if (Flags and (wfGrow + wfMove) <> 0) then
            WindowCommands := WindowCommands + [cmResize]; { Add resize command }
        if (Flags and wfClose <> 0) then
            WindowCommands := WindowCommands + [cmClose];  { Add close command }
        if (Flags and wfZoom <> 0) then
            WindowCommands := WindowCommands + [cmZoom];   { Add zoom command }
        if Enable then
            EnableCommands(WindowCommands)    { Enable commands }
        else
            DisableCommands(WindowCommands);          { Disable commands }
      end;
end;

{--TWindow------------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Mar98 LdB             }
{---------------------------------------------------------------------------}
{  You can save data to the stream compatable with the old original TV by   }
{  temporarily turning off the ofGrafVersion making the call to this store  }
{  routine and resetting the ofGrafVersion flag after the call.             }
{---------------------------------------------------------------------------}
procedure TWindow.Store(var S: TStream);
var
    i: integer;
begin
    TGroup.Store(S);                                   { Call group store }
    S.Write(Flags, SizeOf(Flags));                     { Write window flags }
    i := Number;
    S.Write(i, SizeOf(i));                   { Write window number }
    i := Palette;
    S.Write(i, SizeOf(i));                  { Write window palette }
    i := ZoomRect.A.X;
    S.Write(i, SizeOf(i));             { Write zoom area x1 }
    i := ZoomRect.A.Y;
    S.Write(i, SizeOf(i));             { Write zoom area y1 }
    i := ZoomRect.B.X;
    S.Write(i, SizeOf(i));             { Write zoom area x2 }
    i := ZoomRect.B.Y;
    S.Write(i, SizeOf(i));             { Write zoom area y2 }
    PutSubViewPtr(S, Frame);                           { Write any frame }
    S.WriteStr(Title);                                 { Write title string }
end;

{--TWindow------------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11Aug99 LdB       }
{---------------------------------------------------------------------------}
procedure TWindow.HandleEvent(var Event: TEvent);
var
    Min, Max: TPoint;
    Limits: TRect;

    procedure DragWindow(Mode: byte);
    var
        Limits: TRect;
        Min, Max: TPoint;
    begin
        Owner^.GetExtent(Limits);                        { Get owner extents }
        SizeLimits(Min, Max);                            { Restrict size }
        DragView(Event, DragMode or Mode, Limits, Min,
            Max);                                          { Drag the view }
        ClearEvent(Event);                               { Clear the event }
    end;

begin
    inherited HandleEvent(Event);                      { Call ancestor }
    case Event.What of
        evNothing: Exit;                                 { Speeds up exit }
        evCommand:                                       { COMMAND EVENT }
            case Event.Command of                          { Command type case }
                cmResize:                                    { RESIZE COMMAND }
                    if (Flags and (wfMove + wfGrow) <> 0)      { Window can resize } and
                        (Owner <> nil) then
                      begin              { Valid owner }
                        Owner^.GetExtent(Limits);                { Owners extents }
                        SizeLimits(Min, Max);                    { Check size limits }
                        DragView(Event, DragMode or (Flags and (wfMove + wfGrow)),
                            Limits, Min, Max); { Drag the view }
                        ClearEvent(Event);                       { Clear the event }
                      end;
                cmClose:                                     { CLOSE COMMAND }
                    if (Flags and wfClose <> 0) and            { Close flag set }
                        ((Event.InfoPtr = nil) or                  { None specific close }
                        (Event.InfoPtr = @Self)) then
                      begin        { Close to us }
                        ClearEvent(Event);                       { Clear the event }
                        if (State and sfModal = 0) then
                            Close    { Non modal so close }
                        else
                          begin                               { Modal window }
                            Event.What := evCommand;               { Command event }
                            Event.Command := cmCancel;             { Cancel command }
                            PutEvent(Event);                       { Place on queue }
                            ClearEvent(Event);                     { Clear the event }
                          end;
                      end;
                cmZoom:                                      { ZOOM COMMAND }
                    if (Flags and wfZoom <> 0) and             { Zoom flag set }
                        ((Event.InfoPtr = nil) or                  { No specific zoom }
                        (Event.InfoPtr = @Self)) then
                      begin
                        Zoom;                                    { Zoom our window }
                        ClearEvent(Event);                       { Clear the event }
                      end;
              end;
        evBroadcast:                                     { BROADCAST EVENT }
            if (Event.Command = cmSelectWindowNum) and (Event.InfoInt = Number) and
                { Select our number }
                (Options and ofSelectable <> 0) then
              begin     { Is view selectable }
                Select;                                      { Select our view }
                ClearEvent(Event);                           { Clear the event }
              end;
        evKeyDown:
          begin                                 { KEYDOWN EVENT }
            case Event.KeyCode of
                kbTab:
                  begin                                 { TAB KEY }
                    FocusNext(False);                          { Select next view }
                    ClearEvent(Event);                         { Clear the event }
                  end;
                kbShiftTab:
                  begin                            { SHIFT TAB KEY }
                    FocusNext(True);                           { Select prior view }
                    ClearEvent(Event);                         { Clear the event }
                  end;
              end;
          end;
      end;                                               { Event.What case end }
end;

{--TWindow------------------------------------------------------------------}
{  SizeLimits -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15Sep97 LdB        }
{---------------------------------------------------------------------------}
procedure TWindow.SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} Min, Max: TPoint);
begin
    inherited SizeLimits(Min, Max);                    { View size limits }
    Min.X := MinWinSize.X;                             { Set min x size }
    Min.Y := MinWinSize.Y;                             { Set min y size }
end;



{--TView--------------------------------------------------------------------}
{  Exposed -> Platforms DOS/DPMI/WIN/OS2 - Checked 17Sep97 LdB              }
{---------------------------------------------------------------------------}
function TView.do_ExposedRec1(x1, x2: Sw_integer; p: PView): boolean;
var
    G: PGroup;
    dy, dx: sw_integer;
begin
    while True do
      begin
        p := p^.Next;
        G := p^.Owner;
        if p = staticVar2.target then
          begin
            do_exposedRec1 := do_exposedRec2(x1, x2, G);
            Exit;
          end;
        dy := p^.origin.y;
        dx := p^.origin.x;
        if ((p^.state and sfVisible) <> 0) and (staticVar2.y >= dy) then
          begin
            if staticVar2.y < dy + p^.size.y then
              begin
                if x1 < dx then
                  begin
                    if x2 <= dx then
                        continue;
                    if x2 > dx + p^.size.x then
                      begin
                        if do_exposedRec1(x1, dx, p) then
                          begin
                            do_exposedRec1 := True;
                            Exit;
                          end;
                        x1 := dx + p^.size.x;
                      end
                    else
                        x2 := dx;
                  end
                else
                  begin
                    if x1 < dx + p^.size.x then
                        x1 := dx + p^.size.x;
                    if x1 >= x2 then
                      begin
                        do_exposedRec1 := False;
                        Exit;
                      end;
                  end;
              end;
          end;
      end;
end;


function TView.do_ExposedRec2(x1, x2: Sw_integer; p: PView): boolean;
var
    G: PGroup;
    savedStat: TStatVar2;
begin
    if (p^.state and sfVisible) = 0 then
        do_ExposedRec2 := False
    else
      begin
        G := p^.Owner;
        if (G = nil) or (G^.Buffer <> nil) then
            do_ExposedRec2 := True
        else
          begin
            savedStat := staticVar2;
            Inc(staticVar2.y, p^.origin.y);
            Inc(x1, p^.origin.x);
            Inc(x2, p^.origin.x);
            staticVar2.target := p;
            if (staticVar2.y < G^.clip.a.y) or (staticVar2.y >= G^.clip.b.y) then
                do_ExposedRec2 := False
            else
              begin
                if (x1 < G^.clip.a.x) then
                    x1 := G^.clip.a.x;
                if (x2 > G^.clip.b.x) then
                    x2 := G^.clip.b.x;
                if (x1 >= x2) then
                    do_ExposedRec2 := False
                else
                    do_ExposedRec2 := do_exposedRec1(x1, x2, G^.Last);
              end;
            staticVar2 := savedStat;
          end;
      end;
end;


function TView.Exposed: boolean;
var
    OK: boolean;
    y: sw_integer;
begin
    if ((State and sfExposed) <> 0) and (Size.X > 0) and (Size.Y > 0) then
      begin
        OK := False;
        y := 0;
        while (y < Size.Y) and (not OK) do
          begin
            staticVar2.y := y;
            OK := do_ExposedRec2(0, Size.X, @Self);
            Inc(y);
          end;
        Exposed := OK;
      end
    else
        Exposed := False;
end;


{--TView--------------------------------------------------------------------}
{  MakeLocal -> Platforms DOS/DPMI/WIN/OS2 - Checked 12Sep97 LdB            }
{---------------------------------------------------------------------------}
procedure TView.MakeLocal(Source: TPoint;
 {$IfDef FPC_OBJFPC}out{$else}var{$endif} Dest: TPoint);
var
    cur: PView;
begin
    cur := @Self;
    Dest := Source;
    repeat
        Dec(Dest.X, cur^.Origin.X);
        if dest.x < 0 then
            break;
        Dec(Dest.Y, cur^.Origin.Y);
        if dest.y < 0 then
            break;
        cur := cur^.Owner;
    until cur = nil;
end;


{--TView--------------------------------------------------------------------}
{  MakeGlobal -> Platforms DOS/DPMI/WIN/OS2 - Checked 12Sep97 LdB           }
{---------------------------------------------------------------------------}
procedure TView.MakeGlobal(Source: TPoint;
 {$IfDef FPC_OBJFPC}out{$else}var{$endif} Dest: TPoint);
var
    cur: PView;
begin
    cur := @Self;
    Dest := Source;
    repeat
        Inc(Dest.X, cur^.Origin.X);
        Inc(Dest.Y, cur^.Origin.Y);
        cur := cur^.Owner;
    until cur = nil;
end;


procedure TView.do_WriteViewRec1(x1, x2: Sw_integer; p: PView;
    shadowCounter: Sw_integer);
var
    G: PGroup;
    c: word;
    BufPos, SrcPos, l, dx: Sw_integer;
begin
    repeat
        p := p^.Next;
        if (p = staticVar2.target) then
          begin
            G := p^.Owner;
            if (G^.buffer <> nil) then
              begin
                BufPos := G^.size.x * staticVar2.y + x1;
                SrcPos := x1 - staticVar2.offset;
                l := x2 - x1;
                if (shadowCounter = 0) then
                    move(staticVar1^[SrcPos], PVideoBuf(G^.buffer)^[BufPos], l shl 1)
                else
                  begin { paint with shadowAttr }
                    while (l > 0) do
                      begin
                        c := staticVar1^[SrcPos];
                        WordRec(c).hi := shadowAttr;
                        PVideoBuf(G^.buffer)^[BufPos] := c;
                        Inc(BufPos);
                        Inc(SrcPos);
                        Dec(l);
                      end;
                  end;
              end;
            if G^.lockFlag = 0 then
                do_writeViewRec2(x1, x2, G, shadowCounter);
            exit;
          end; { p=staticVar2.target }

        if ((p^.state and sfVisible) <> 0) and (staticVar2.y >= p^.Origin.Y) then
          begin
            if staticVar2.y < p^.Origin.Y + p^.size.Y then
              begin
                if x1 < p^.origin.x then
                  begin
                    if x2 <= p^.origin.x then
                        continue;
                    do_writeViewRec1(x1, p^.origin.x, p, shadowCounter);
                    x1 := p^.origin.x;
                  end;
                dx := p^.origin.x + p^.size.x;
                if (x2 <= dx) then
                    exit;
                if (x1 < dx) then
                    x1 := dx;
                Inc(dx, shadowSize.x);
                if ((p^.state and sfShadow) <> 0) and
                    (staticVar2.y >= p^.origin.y + shadowSize.y) then
                    if (x1 > dx) then
                        continue
                    else
                      begin
                        Inc(shadowCounter);
                        if (x2 <= dx) then
                            continue
                        else
                          begin
                            do_writeViewRec1(x1, dx, p, shadowCounter);
                            x1 := dx;
                            Dec(shadowCounter);
                            continue;
                          end;
                      end
                else
                    continue;
              end;

            if ((p^.state and sfShadow) <> 0) and
                (staticVar2.y < p^.origin.y + p^.size.y + shadowSize.y) then
              begin
                dx := p^.origin.x + shadowSize.x;
                if x1 < dx then
                  begin
                    if x2 <= dx then
                        continue;
                    do_writeViewRec1(x1, dx, p, shadowCounter);
                    x1 := dx;
                  end;
                Inc(dx, p^.size.x);
                if x1 >= dx then
                    continue;
                Inc(shadowCounter);
                if x2 <= dx then
                    continue
                else
                  begin
                    do_writeViewRec1(x1, dx, p, shadowCounter);
                    x1 := dx;
                    Dec(shadowCounter);
                  end;
              end;
          end;
    until False;
end;


procedure TView.do_WriteViewRec2(x1, x2: Sw_integer; p: PView;
    shadowCounter: Sw_integer);
var
    savedStatics: TstatVar2;
    dx: Sw_integer;
    G: PGroup;
begin
    G := P^.Owner;
    if ((p^.State and sfVisible) <> 0) and (G <> nil) then
      begin
        savedStatics := staticVar2;
        Inc(staticVar2.y, p^.Origin.Y);
        dx := p^.Origin.X;
        Inc(x1, dx);
        Inc(x2, dx);
        Inc(staticVar2.offset, dx);
        staticVar2.target := p;
        if (staticVar2.y >= G^.clip.a.y) and (staticVar2.y < G^.clip.b.y) then
          begin
            if (x1 < g^.clip.a.x) then
                x1 := g^.clip.a.x;
            if (x2 > g^.clip.b.x) then
                x2 := g^.clip.b.x;
            if x1 < x2 then
                do_writeViewRec1(x1, x2, G^.Last, shadowCounter);
          end;
        staticVar2 := savedStatics;
      end;
end;


procedure TView.do_WriteView(x1, x2, y: Sw_Integer; var Buf);
begin
    if (y >= 0) and (y < Size.Y) then
      begin
        if x1 < 0 then
            x1 := 0;
        if x2 > Size.X then
            x2 := Size.X;
        if x1 < x2 then
          begin
            staticVar2.offset := x1;
            staticVar2.y := y;
            staticVar1 := @Buf;
            do_writeViewRec2(x1, x2, @Self, 0);
          end;
      end;
end;


procedure TView.WriteBuf(X, Y, W, H: Sw_Integer; var Buf);
var
    i: Sw_integer;
begin
    if h > 0 then
        for i := 0 to h - 1 do
            do_writeView(X, X + W, Y + i, TVideoBuf(Buf)[W * i]);
end;


procedure TView.WriteChar(X, Y: Sw_Integer; C: char; Color: byte; Count: Sw_Integer);
var
    B: TDrawBuffer;
    myChar: word;
    i: Sw_integer;
begin
    myChar := MapColor(Color);
    myChar := (myChar shl 8) + Ord(C);
    if Count > 0 then
      begin
        if Count > maxViewWidth then
            Count := maxViewWidth;
        for i := 0 to Count - 1 do
            B[i] := myChar;
        do_writeView(X, X + Count, Y, B);
      end;
    DrawScreenBuf(False);
end;


procedure TView.WriteLine(X, Y, W, H: Sw_Integer; var Buf);
var
    i: Sw_integer;
begin
    if h > 0 then
        for i := 0 to h - 1 do
            do_writeView(x, x + w, y + i, buf);
    DrawScreenBuf(False);
end;


procedure TView.WriteStr(X, Y: Sw_Integer; Str: string; Color: byte);
var
    l, i: Sw_word;
    B: TDrawBuffer;
    myColor: word;
begin
    l := length(Str);
    if l > 0 then
      begin
        if l > maxViewWidth then
            l := maxViewWidth;
        MyColor := MapColor(Color);
        MyColor := MyColor shl 8;
        for i := 0 to l - 1 do
            B[i] := MyColor + Ord(Str[i + 1]);
        do_writeView(x, x + l, y, b);
      end;
    DrawScreenBuf(False);
end;


procedure TView.DragView(Event: TEvent; Mode: byte; var Limits: TRect;
    MinSize, MaxSize: TPoint);
var
    P, S: TPoint;
    SaveBounds: TRect;

    procedure MoveGrow(P, S: TPoint);
    var
        R: TRect;
    begin
        S.X := Min(Max(S.X, MinSize.X), MaxSize.X);
        S.Y := Min(Max(S.Y, MinSize.Y), MaxSize.Y);
        P.X := Min(Max(P.X, Limits.A.X - S.X + 1), Limits.B.X - 1);
        P.Y := Min(Max(P.Y, Limits.A.Y - S.Y + 1), Limits.B.Y - 1);
        if Mode and dmLimitLoX <> 0 then
            P.X := Max(P.X, Limits.A.X);
        if Mode and dmLimitLoY <> 0 then
            P.Y := Max(P.Y, Limits.A.Y);
        if Mode and dmLimitHiX <> 0 then
            P.X := Min(P.X, Limits.B.X - S.X);
        if Mode and dmLimitHiY <> 0 then
            P.Y := Min(P.Y, Limits.B.Y - S.Y);
        R.Assign(P.X, P.Y, P.X + S.X, P.Y + S.Y);
        Locate(R);
    end;

    procedure Change(DX, DY: Sw_Integer);
    begin
        if (Mode and dmDragMove <> 0) and (Event.KeyShift{GetShiftState} and $03 = 0) then
          begin
            Inc(P.X, DX);
            Inc(P.Y, DY);
          end
        else
        if (Mode and dmDragGrow <> 0) and (Event.KeyShift{GetShiftState} and $03 <> 0) then
          begin
            Inc(S.X, DX);
            Inc(S.Y, DY);
          end;
    end;

    procedure Update(X, Y: Sw_Integer);
    begin
        if Mode and dmDragMove <> 0 then
          begin
            P.X := X;
            P.Y := Y;
          end;
    end;

begin
    SetState(sfDragging, True);
    if Event.What = evMouseDown then
      begin
        if Mode and dmDragMove <> 0 then
          begin
            P.X := Origin.X - Event.Where.X;
            P.Y := Origin.Y - Event.Where.Y;
            repeat
                Inc(Event.Where.X, P.X);
                Inc(Event.Where.Y, P.Y);
                MoveGrow(Event.Where, Size);
            until not MouseEvent(Event, evMouseMove);
      {We need to process the mouse-up event, since not all terminals
       send drag events.}
            Inc(Event.Where.X, P.X);
            Inc(Event.Where.Y, P.Y);
            MoveGrow(Event.Where, Size);
          end
        else
          begin
            P.X := Size.X - Event.Where.X;
            P.Y := Size.Y - Event.Where.Y;
            repeat
                Inc(Event.Where.X, P.X);
                Inc(Event.Where.Y, P.Y);
                MoveGrow(Origin, Event.Where);
            until not MouseEvent(Event, evMouseMove);
      {We need to process the mouse-up event, since not all terminals
       send drag events.}
            Inc(Event.Where.X, P.X);
            Inc(Event.Where.Y, P.Y);
            MoveGrow(Origin, Event.Where);
          end;
      end
    else
      begin
        GetBounds(SaveBounds);
        repeat
            P := Origin;
            S := Size;
            KeyEvent(Event);
            case Event.KeyCode and $FF00 of
                kbLeft: Change(-1, 0);
                kbRight: Change(1, 0);
                kbUp: Change(0, -1);
                kbDown: Change(0, 1);
                kbCtrlLeft: Change(-8, 0);
                kbCtrlRight: Change(8, 0);
                kbHome: Update(Limits.A.X, P.Y);
                kbEnd: Update(Limits.B.X - S.X, P.Y);
                kbPgUp: Update(P.X, Limits.A.Y);
                kbPgDn: Update(P.X, Limits.B.Y - S.Y);
              end;
            MoveGrow(P, S);
        until (Event.KeyCode = kbEnter) or (Event.KeyCode = kbEsc);
        if Event.KeyCode = kbEsc then
            Locate(SaveBounds);
      end;
    SetState(sfDragging, False);
end;


{***************************************************************************}
{                         TScroller OBJECT METHODS                          }
{***************************************************************************}

procedure TScroller.ScrollDraw;
var
    D: TPoint;
begin
    if (HScrollBar <> nil) then
        D.X := HScrollBar^.Value
    else
        D.X := 0;                                   { Horz scroll value }
    if (VScrollBar <> nil) then
        D.Y := VScrollBar^.Value
    else
        D.Y := 0;                                   { Vert scroll value }
    if (D.X <> Delta.X) or (D.Y <> Delta.Y) then
      begin     { View has moved }
        SetCursor(Cursor.X + Delta.X - D.X,
            Cursor.Y + Delta.Y - D.Y);                         { Move the cursor }
        Delta := D;                                      { Set new delta }
        if (DrawLock <> 0) then
            DrawFlag := True           { Draw will need draw }
        else
            DrawView;                                 { Redraw the view }
      end;
end;

procedure TScroller.SetLimit(X, Y: Sw_Integer);
var
    PState: word;
begin
    Limit.X := X;                                      { Hold x limit }
    Limit.Y := Y;                                      { Hold y limit }
    Inc(DrawLock);                                     { Set draw lock }
    if (HScrollBar <> nil) then
      begin
        PState := HScrollBar^.State;                     { Hold bar state }
        HScrollBar^.State := PState and not sfVisible;   { Temp not visible }
        HScrollBar^.SetParams(HScrollBar^.Value, 0,
            X - Size.X, Size.X - 1, HScrollBar^.ArStep);       { Set horz scrollbar }
        HScrollBar^.State := PState;                     { Restore bar state }
      end;
    if (VScrollBar <> nil) then
      begin
        PState := VScrollBar^.State;                     { Hold bar state }
        VScrollBar^.State := PState and not sfVisible;   { Temp not visible }
        VScrollBar^.SetParams(VScrollBar^.Value, 0,
            Y - Size.Y, Size.Y - 1, VScrollBar^.ArStep);       { Set vert scrollbar }
        VScrollBar^.State := PState;                     { Restore bar state }
      end;
    Dec(DrawLock);                                     { Release draw lock }
    CheckDraw;                                         { Check need to draw }
end;

{***************************************************************************}
{                      TScroller OBJECT PRIVATE METHODS                     }
{***************************************************************************}
procedure TScroller.CheckDraw;
begin
    if (DrawLock = 0) and DrawFlag then
      begin          { Clear & draw needed }
        DrawFlag := False;                               { Clear draw flag }
        DrawView;                                        { Draw now }
      end;
end;



{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TGroup OBJECT METHODS                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}




{--TGroup-------------------------------------------------------------------}
{  Lock -> Platforms DOS/DPMI/WIN/OS2 - Checked 23Sep97 LdB                 }
{---------------------------------------------------------------------------}
{$ifndef  NoLock}
{$define UseLock}
{$endif ndef  NoLock}
procedure TGroup.Lock;
begin
{$ifdef UseLock}
   {If (Buffer <> Nil) OR (LockFlag <> 0)
     Then} Inc(LockFlag);                              { Increment count }
{$endif UseLock}
end;

{--TGroup-------------------------------------------------------------------}
{  UnLock -> Platforms DOS/DPMI/WIN/OS2 - Checked 23Sep97 LdB               }
{---------------------------------------------------------------------------}
procedure TGroup.UnLock;
begin
{$ifdef UseLock}
    if (LockFlag <> 0) then
      begin
        Dec(LockFlag);                                   { Decrement count }
        if (LockFlag = 0) then
            DrawView;                 { Lock release draw }
      end;
{$endif UseLock}
end;


{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         WINDOW MESSAGE ROUTINES                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  Message -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB           }
{---------------------------------------------------------------------------}
function Message(Receiver: PView; What, Command: word; InfoPtr: Pointer): Pointer;
var
    Event: TEvent;
begin
    Message := nil;                                    { Preset nil }
    if (Receiver <> nil) then
      begin                    { Valid receiver }
        Event.What := What;                              { Set what }
        Event.Command := Command;                        { Set command }
        Event.Id := 0;                                   { Zero id field }
        Event.Data := 0;                                 { Zero data field }
        Event.InfoPtr := InfoPtr;                        { Set info ptr }
        Receiver^.HandleEvent(Event);                    { Pass to handler }
        if (Event.What = evNothing) then
            Message := Event.InfoPtr;                      { Return handler }
      end;
end;

{---------------------------------------------------------------------------}
{  NewMessage -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19Sep97 LdB        }
{---------------------------------------------------------------------------}
function NewMessage(P: PView; What, Command: word; Id: Sw_Integer;
    Data: real; InfoPtr: Pointer): Pointer;
var
    Event: TEvent;
begin
    NewMessage := nil;                                 { Preset failure }
    if (P <> nil) then
      begin
        Event.What := What;                              { Set what }
        Event.Command := Command;                        { Set event command }
        Event.Id := Id;                                  { Set up Id }
        Event.Data := Data;                              { Set up data }
        Event.InfoPtr := InfoPtr;                        { Set up event ptr }
        P^.HandleEvent(Event);                           { Send to view }
        if (Event.What = evNothing) then
            NewMessage := Event.InfoPtr;                   { Return handler }
      end;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                            NEW VIEW ROUTINES                              }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  CreateIdScrollBar -> Platforms DOS/DPMI/WIN/NT/OS2 - Checked 22May97 LdB }
{---------------------------------------------------------------------------}
function CreateIdScrollBar(X, Y, Size, Id: Sw_Integer; Horz: boolean): PScrollBar;
var
    R: TRect;
    P: PScrollBar;
begin
    if Horz then
        R.Assign(X, Y, X + Size, Y + 1)
    else      { Horizontal bar }
        R.Assign(X, Y, X + 1, Y + Size);                     { Vertical bar }
    P := New(PScrollBar, Init(R));                     { Create scrollbar }
    if (P <> nil) then
      begin
        P^.Id := Id;                                     { Set scrollbar id }
        P^.Options := P^.Options or ofPostProcess;       { Set post processing }
      end;
    CreateIdScrollBar := P;                            { Return scrollbar }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                      OBJECT REGISTRATION PROCEDURES                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  RegisterViews -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28May97 LdB     }
{---------------------------------------------------------------------------}
procedure RegisterViews;
begin
    RegisterType(RView);                               { Register views }
    RegisterType(RFrame);                              { Register frame }
    RegisterType(RScrollBar);                          { Register scrollbar }
    RegisterType(RScroller);                           { Register scroller }
    RegisterType(RListViewer);                         { Register listview }
    RegisterType(RGroup);                              { Register group }
    RegisterType(RWindow);                             { Register window }
end;

end.
