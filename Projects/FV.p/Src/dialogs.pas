{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}
{                                                          }
{   System independent GRAPHICAL clone of DIALOGS.PAS      }
{                                                          }
{   Interface Copyright (c) 1992 Borland International     }
{                                                          }
{   Copyright (c) 1996, 1997, 1998, 1999 by Leon de Boer   }
{   ldeboer@attglobal.net  - primary e-mail addr           }
{   ldeboer@starwon.com.au - backup e-mail addr            }
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

unit Dialogs;

{ $CODEPAGE cp437}

{2.0 compatibility}
{$ifdef VER2_0}
  {$macro on}
  {$define resourcestring := const}
{$endif}

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                  INTERFACE
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
   {$IFDEF OS_WINDOWS}{ WIN/NT CODE }
 // Windows,                                       { Standard units }
   {$ENDIF}

   {$IFDEF OS_OS2}                                    { OS2 CODE }
  OS2Def, DosCalls, PMWIN,                       { Standard units }
   {$ENDIF}

  FVCommon, FVConsts, Objects, Drivers, Views, Validate;         { Standard GFV units }

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                        COLOUR PALETTE DEFINITIONS                         }
{---------------------------------------------------------------------------}
const
  CGrayDialog = #32#33#34#35#36#37#38#39#40#41#42#43#44#45#46#47 +
    #48#49#50#51#52#53#54#55#56#57#58#59#60#61#62#63;
  CBlueDialog = #64#65#66#67#68#69#70#71#72#73#74#75#76#77#78#79 +
    #80#81#82#83#84#85#86#87#88#89#90#91#92#92#94#95;
  CCyanDialog = #96#97#98#99#100#101#102#103#104#105#106#107#108 +
    #109#110#111#112#113#114#115#116#117#118#119#120 +
    #121#122#123#124#125#126#127;
  CStaticText = #6#7#8#9;
  CLabel = #7#8#9#9;
  CButton = #10#11#12#13#14#14#14#15;
  CCluster = #16#17#18#18#31#6;
  CInputLine = #19#19#20#21#14;
  CHistory = #22#23;
  CHistoryWindow = #19#19#21#24#25#19#20;
  CHistoryViewer = #6#6#7#6#6;

  CDialog = CGrayDialog;                             { Default palette }

const
  { ldXXXX constants  }
  ldNone = $0000;
  ldNew = $0001;
  ldEdit = $0002;
  ldDelete = $0004;
  ldNewEditDelete = ldNew or ldEdit or ldDelete;
  ldHelp = $0008;
  ldAllButtons = ldNew or ldEdit or ldDelete or ldHelp;
  ldNewIcon = $0010;
  ldEditIcon = $0020;
  ldDeleteIcon = $0040;
  ldAllIcons = ldNewIcon or ldEditIcon or ldDeleteIcon;
  ldAll = ldAllIcons or ldAllButtons;
  ldNoFrame = $0080;
  ldNoScrollBar = $0100;

  { ofXXXX constants  }
  ofNew = $0001;
  ofDelete = $0002;
  ofEdit = $0004;
  ofNewEditDelete = ofNew or ofDelete or ofEdit;

{---------------------------------------------------------------------------}
{                     TDialog PALETTE COLOUR CONSTANTS                      }
{---------------------------------------------------------------------------}
const
  dpBlueDialog = 0;                                  { Blue dialog colour }
  dpCyanDialog = 1;                                  { Cyan dialog colour }
  dpGrayDialog = 2;                                  { Gray dialog colour }

{---------------------------------------------------------------------------}
{                           TButton FLAGS MASKS                             }
{---------------------------------------------------------------------------}
const
  bfNormal = $00;                                 { Normal displayed }
  bfDefault = $01;                                 { Default command }
  bfLeftJust = $02;                                 { Left just text }
  bfBroadcast = $04;                                 { Broadcast command }
  bfGrabFocus = $08;                                 { Grab focus }

{---------------------------------------------------------------------------}
{          TMultiCheckBoxes FLAGS - (HiByte = Bits LoByte = Mask)           }
{---------------------------------------------------------------------------}
const
  cfOneBit = $0101;                               { One bit masks }
  cfTwoBits = $0203;                               { Two bit masks }
  cfFourBits = $040F;                               { Four bit masks }
  cfEightBits = $08FF;                               { Eight bit masks }

{---------------------------------------------------------------------------}
{                        DIALOG BROADCAST COMMANDS                          }
{---------------------------------------------------------------------------}
const
  cmRecordHistory = 60;                              { Record history cmd }

{***************************************************************************}
{                            RECORD DEFINITIONS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                          ITEM RECORD DEFINITION                           }
{---------------------------------------------------------------------------}
type
  PSItem = ^TSItem;
  TSItem = record
    Value: PString;                                  { Item string }
    Next: PSItem;                                    { Next item }
  end;

{***************************************************************************}
{                            OBJECT DEFINITIONS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                   TInputLine OBJECT - INPUT LINE OBJECT                   }
{---------------------------------------------------------------------------}
type
   TInputLine = OBJECT (TView)
    MaxLen: Sw_Integer;                             { Max input length }
    CurPos: Sw_Integer;                             { Cursor position }
    FirstPos: Sw_Integer;                           { First position }
    SelStart: Sw_Integer;                           { Selected start }
    SelEnd: Sw_Integer;                             { Selected end }
         Data: ^String; {!}                         { Input line data }
    Validator: PValidator;                          { Validator of view }
    constructor Init(Const Bounds: TRect; AMaxLen: Sw_Integer {$ifdef FPC_OBJFPC}= 256{$endif});
      CONSTRUCTOR Load (Var S: TStream);
    destructor Done; virtual;
    function DataSize: Sw_Word; virtual;
    function GetPalette: PPalette; virtual;
      FUNCTION Valid (Command: Word): Boolean; Virtual;
    procedure Draw; virtual;
    procedure DrawCursor; virtual;
      PROCEDURE SelectAll (Enable: Boolean);
      PROCEDURE SetValidator (AValid: PValidator);
      PROCEDURE SetState (AState: Word; Enable: Boolean); Virtual;
      PROCEDURE GetData (Var Rec); Virtual;
      PROCEDURE SetData (Const Rec); Virtual;
      PROCEDURE Store (Var S: TStream);
      PROCEDURE HandleEvent (Var Event: TEvent); Virtual;
  private
      FUNCTION CanScroll (Delta: Sw_Integer): Boolean;
  end;
  PInputLine = ^TInputLine;

{---------------------------------------------------------------------------}
{                  TButton OBJECT - BUTTON ANCESTOR OBJECT                  }
{---------------------------------------------------------------------------}
type
  TButton = object(TView)
    AmDefault: boolean;                          { If default button }
    Flags: byte;                             { Button flags }
    Command: word;                             { Button command }
    Title: PString;                          { Button title }
    constructor Init(var Bounds: TRect; ATitle: TTitleStr;
      ACommand: word; AFlags: word);
    constructor Load(var S: TStream);
    destructor Done; virtual;
    function GetPalette: PPalette; virtual;
    procedure Press; virtual;
    procedure Draw; virtual;
    procedure DrawState(Down: boolean);
    procedure MakeDefault(Enable: boolean);
    procedure SetState(AState: word; Enable: boolean); virtual;
    procedure Store(var S: TStream);
    procedure HandleEvent(var Event: TEvent); virtual;
  private
    DownFlag: boolean;
  end;
  PButton = ^TButton;

{---------------------------------------------------------------------------}
{                 TCluster OBJECT - CLUSTER ANCESTOR OBJECT                 }
{---------------------------------------------------------------------------}
type
  { Palette layout }
  { 1 = Normal text }
  { 2 = Selected text }
  { 3 = Normal shortcut }
  { 4 = Selected shortcut }
  { 5 = Disabled text }

  TCluster = object(TView)
    Id: Sw_Integer;                         { New communicate id }
    Sel: Sw_Integer;                         { Selected item }
    Value: longint;                         { Bit value }
    EnableMask: longint;                         { Mask enable bits }
    Strings: TStringCollection;               { String collection }
    constructor Init(var Bounds: TRect; AStrings: PSItem);
    constructor Load(var S: TStream);
    destructor Done; virtual;
    function DataSize: Sw_Word; virtual;
    function GetHelpCtx: word; virtual;
    function GetPalette: PPalette; virtual;
    function Mark(Item: Sw_Integer): boolean; virtual;
    function MultiMark(Item: Sw_Integer): byte; virtual;
    function ButtonState(Item: Sw_Integer): boolean;
    procedure Draw; virtual;
    procedure Press(Item: Sw_Integer); virtual;
    procedure MovedTo(Item: Sw_Integer); virtual;
    procedure SetState(AState: word; Enable: boolean); virtual;
    procedure DrawMultiBox(const Icon, Marker: string);
    procedure DrawBox(const Icon: string; Marker: char);
    procedure SetButtonState(AMask: longint; Enable: boolean);
    procedure GetData(var Rec); virtual;
        procedure SetData(const Rec); virtual;
    procedure Store(var S: TStream);
    procedure HandleEvent(var Event: TEvent); virtual;
  private
    function FindSel(P: TPoint): Sw_Integer;
    function Row(Item: Sw_Integer): Sw_Integer;
    function Column(Item: Sw_Integer): Sw_Integer;
  end;
  PCluster = ^TCluster;

{---------------------------------------------------------------------------}
{                TRadioButtons OBJECT - RADIO BUTTON OBJECT                 }
{---------------------------------------------------------------------------}

{ Palette layout }
{ 1 = Normal text }
{ 2 = Selected text }
{ 3 = Normal shortcut }
{ 4 = Selected shortcut }


type
  TRadioButtons = object(TCluster)
    function Mark(Item: Sw_Integer): boolean; virtual;
    procedure Draw; virtual;
    procedure Press(Item: Sw_Integer); virtual;
    procedure MovedTo(Item: Sw_Integer); virtual;
      PROCEDURE SetData (Const Rec); Virtual;
  end;
  PRadioButtons = ^TRadioButtons;

{---------------------------------------------------------------------------}
{                  TCheckBoxes OBJECT - CHECK BOXES OBJECT                  }
{---------------------------------------------------------------------------}

{ Palette layout }
{ 1 = Normal text }
{ 2 = Selected text }
{ 3 = Normal shortcut }
{ 4 = Selected shortcut }

type
  TCheckBoxes = object(TCluster)
    function Mark(Item: Sw_Integer): boolean; virtual;
    procedure Draw; virtual;
    procedure Press(Item: Sw_Integer); virtual;
  end;
  PCheckBoxes = ^TCheckBoxes;

{---------------------------------------------------------------------------}
{               TMultiCheckBoxes OBJECT - CHECK BOXES OBJECT                }
{---------------------------------------------------------------------------}

{ Palette layout }
{ 1 = Normal text }
{ 2 = Selected text }
{ 3 = Normal shortcut }
{ 4 = Selected shortcut }

type
  TMultiCheckBoxes = object(TCluster)
    SelRange: byte;                              { Select item range }
    Flags: word;                              { Select flags }
    States: PString;                           { Strings }
    constructor Init(var Bounds: TRect; AStrings: PSItem;
      ASelRange: byte; AFlags: word; const AStates: string);
    constructor Load(var S: TStream);
    destructor Done; virtual;
    function DataSize: Sw_Word; virtual;
    function MultiMark(Item: Sw_Integer): byte; virtual;
    procedure Draw; virtual;
    procedure Press(Item: Sw_Integer); virtual;
    procedure GetData(var Rec); virtual;
      PROCEDURE SetData (Const Rec); Virtual;
    procedure Store(var S: TStream);
  end;
  PMultiCheckBoxes = ^TMultiCheckBoxes;

{---------------------------------------------------------------------------}
{                     TListBox OBJECT - LIST BOX OBJECT                     }
{---------------------------------------------------------------------------}

{ Palette layout }
{ 1 = Active }
{ 2 = Inactive }
{ 3 = Focused }
{ 4 = Selected }
{ 5 = Divider }

type
  TListBox = object(TListViewer)
    List: PCollection;                           { List of strings }
    constructor Init(var Bounds: TRect; ANumCols: Sw_Word;
      AScrollBar: PScrollBar);
    constructor Load(var S: TStream);
    function DataSize: Sw_Word; virtual;
      {$IFopt H+}
    function GetText(Item: Sw_Integer; MaxLen: Sw_Integer): string; virtual;
      {$ELSE}
    function GetText(Item: Sw_Integer; MaxLen: Sw_Integer): string; virtual;
      {$ENDIF}
    procedure NewList(AList: PCollection); virtual;
    procedure GetData(var Rec); virtual;
        procedure SetData(const Rec); virtual;
    procedure Store(var S: TStream);
    procedure DeleteFocusedItem; virtual;
    { DeleteFocusedItem deletes the focused item and redraws the view. }
    {#X FreeFocusedItem }
    procedure DeleteItem(Item: Sw_Integer); virtual;
    { DeleteItem deletes Item from the associated collection. }
    {#X FreeItem }
    procedure FreeAll; virtual;
        { FreeAll deletes and disposes of all items in the associated
          collection. }
    { FreeFocusedItem FreeItem }
    procedure FreeFocusedItem; virtual;
        { FreeFocusedItem deletes and disposes of the focused item then redraws
          the listbox. }
    {#X FreeAll FreeItem }
    procedure FreeItem(Item: Sw_Integer); virtual;
        { FreeItem deletes Item from the associated collection and disposes of
          it, then redraws the listbox. }
    {#X FreeFocusedItem FreeAll }
    function GetFocusedItem: Pointer; virtual;
        { GetFocusedItem is a more readable method of returning the focused
          item from the listbox.  It is however slightly slower than: }
    {#M+}
  {
  Item := ListBox^.List^.At(ListBox^.Focused); }
    {#M-}
    procedure Insert(Item: Pointer); virtual;
        { Insert inserts Item into the collection, adjusts the listbox's range,
          then redraws the listbox. }
    {#X FreeItem }
    procedure SetFocusedItem(Item: Pointer); virtual;
        { SetFocusedItem changes the focused item to Item then redraws the
          listbox. }
    {# FocusItemNum }
  end;
  PListBox = ^TListBox;

{---------------------------------------------------------------------------}
{                TStaticText OBJECT - STATIC TEXT OBJECT                    }
{---------------------------------------------------------------------------}
type
  TStaticText = object(TView)
    Text: PString;                               { Text string ptr }
    constructor Init(var Bounds: TRect; const AText: string);
    constructor Load(var S: TStream);
    destructor Done; virtual;
    function GetPalette: PPalette; virtual;
    procedure Draw; virtual;
    procedure Store(var S: TStream);
    procedure GetText(var S: string); virtual;
  end;
  PStaticText = ^TStaticText;

{---------------------------------------------------------------------------}
{              TParamText OBJECT - PARMETER STATIC TEXT OBJECT              }
{---------------------------------------------------------------------------}

{ Palette layout }
{ 1 = Text }

type
  TParamText = object(TStaticText)
    ParamCount: Sw_Integer;                         { Parameter count }
    ParamList: Pointer;                         { Parameter list }
    constructor Init(var Bounds: TRect; const AText: string;
      AParamCount: Sw_Integer);
    constructor Load(var S: TStream);
    function DataSize: Sw_Word; virtual;
    procedure GetData(var Rec); virtual;
        procedure SetData(const Rec); virtual;
    procedure Store(var S: TStream);
    procedure GetText(var S: string); virtual;
  end;
  PParamText = ^TParamText;

{---------------------------------------------------------------------------}
{                        TLabel OBJECT - LABEL OBJECT                       }
{---------------------------------------------------------------------------}
type
  TLabel = object(TStaticText)
    Light: boolean;
    Link: PView;                                 { Linked view }
    constructor Init(var Bounds: TRect; const AText: string; ALink: PView);
    constructor Load(var S: TStream);
    function GetPalette: PPalette; virtual;
    procedure Draw; virtual;
    procedure Store(var S: TStream);
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
  PLabel = ^TLabel;

{---------------------------------------------------------------------------}
{             THistoryViewer OBJECT - HISTORY VIEWER OBJECT                 }
{---------------------------------------------------------------------------}

{ Palette layout }
{ 1 = Active }
{ 2 = Inactive }
{ 3 = Focused }
{ 4 = Selected }
{ 5 = Divider }

type
  THistoryViewer = object(TListViewer)
    HistoryId: word;                             { History id }
    constructor Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar;
      AHistoryId: word);
    function HistoryWidth: Sw_Integer;
    function GetPalette: PPalette; virtual;
    function GetText(Item: Sw_Integer; MaxLen: Sw_Integer): string; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
  PHistoryViewer = ^THistoryViewer;

{---------------------------------------------------------------------------}
{             THistoryWindow OBJECT - HISTORY WINDOW OBJECT                 }
{---------------------------------------------------------------------------}

{ Palette layout }
{ 1 = Frame passive }
{ 2 = Frame active }
{ 3 = Frame icon }
{ 4 = ScrollBar page area }
{ 5 = ScrollBar controls }
{ 6 = HistoryViewer normal text }
{ 7 = HistoryViewer selected text }

type
  THistoryWindow = object(TWindow)
    Viewer: PListViewer;                         { List viewer object }
    constructor Init(var Bounds: TRect; HistoryId: word);
    function GetSelection: string; virtual;
    function GetPalette: PPalette; virtual;
    procedure InitViewer(HistoryId: word); virtual;
  end;
  PHistoryWindow = ^THistoryWindow;

{---------------------------------------------------------------------------}
{                   THistory OBJECT - HISTORY OBJECT                        }
{---------------------------------------------------------------------------}

{ Palette layout }
{ 1 = Arrow }
{ 2 = Sides }

type
  THistory = object(TView)
    HistoryId: word;
    Link: PInputLine;
    constructor Init(var Bounds: TRect; ALink: PInputLine; AHistoryId: word);
    constructor Load(var S: TStream);
    function GetPalette: PPalette; virtual;
    function InitHistoryWindow(var Bounds: TRect): PHistoryWindow; virtual;
    procedure Draw; virtual;
    procedure RecordHistory(const S: string); virtual;
    procedure Store(var S: TStream);
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
  PHistory = ^THistory;

  {#Z+}
  PBrowseInputLine = ^TBrowseInputLine;

  { TBrowseInputLine }
  TBrowseInputLine = object(TInputLine)
    History: Sw_Word;
    constructor Init(var Bounds: TRect; AMaxLen: Sw_Integer; AHistory: Sw_Word);
    constructor Load(var S: TStream);
    function DataSize: Sw_Word; virtual;
    procedure GetData(var Rec); virtual;
    procedure SetData(Const Rec); virtual;
    procedure Store(var S: TStream);
  end;  { of TBrowseInputLine }

  TBrowseInputLineRec = record
    Text: string;
    History: Sw_Word;
  end;  { of TBrowseInputLineRec }
  {#Z+}
  PBrowseButton = ^TBrowseButton;
  {#Z-}
  TBrowseButton = object(TButton)
    Link: PBrowseInputLine;
    constructor Init(var Bounds: TRect; ATitle: TTitleStr; ACommand: word;
      AFlags: byte; ALink: PBrowseInputLine);
    constructor Load(var S: TStream);
    procedure Press; virtual;
    procedure Store(var S: TStream);
  end;  { of TBrowseButton }


  {#Z+}
  PCommandIcon = ^TCommandIcon;
  {#Z-}
  TCommandIcon = object(TStaticText)
    { A TCommandIcon sends an evCommand message to its owner with
      Event.Command set to #Command# when it is clicked with a mouse. }
    constructor Init(var Bounds: TRect; AText: string; ACommand: word);
      { Creates an instance of a TCommandIcon and sets #Command# to
        ACommand.  AText is the text which is displayed as the icon.  If an
        error occurs Init fails. }
    procedure HandleEvent(var Event: TEvent); virtual;
      { Captures mouse events within its borders and sends an evCommand to
        its owner in response to the mouse event. }
    {#X Command }
  private
    Command: word;
      { Command is the command sent to the command icon's owner when it is
        clicked. }
  end;  { of TCommandIcon }


  {#Z+}
  PCommandSItem = ^TCommandSItem;
  {#Z-}
  TCommandSItem = record
    { A TCommandSItem is the data structure used to initialize command
      clusters with #NewCommandSItem# rather than the standarad #NewSItem#.
      It is used to associate a command with an individual cluster item. }
    {#X TCommandCheckBoxes TCommandRadioButtons }
    Value: string;
    { Value is the text displayed for the cluster item. }
    {#X Command Next }
    Command: word;
    { Command is the command broadcast when the cluster item is pressed. }
    {#X Value Next }
    Next: PCommandSItem;
    { Next is a pointer to the next item in the cluster. }
    {#X Value Command }
  end;  { of TCommandSItem }


  TCommandArray = array[0..15] of word;
    { TCommandArray holds a list of commands which are associated with a
      cluster. }
  {#X TCommandCheckBoxes TCommandRadioButtons }


  {#Z+}
  PCommandCheckBoxes = ^TCommandCheckBoxes;
  {#Z-}
  TCommandCheckBoxes = object(TCheckBoxes)
    { TCommandCheckBoxes function as normal TCheckBoxes, except that when a
      cluster item is pressed it broadcasts a command associated with the
      cluster item to the cluster's owner.

      TCommandCheckBoxes are useful when other parts of a dialog should be
      enabled or disabled in response to a check box's status. }
    CommandList: TCommandArray;
      { CommandList is the list of commands associated with each check box
        item. }
    {#X Init Load Store }
    constructor Init(var Bounds: TRect; ACommandStrings: PCommandSItem);
      { Init calls the inherited constructor, then sets up the #CommandList#
        with the specified commands.  If an error occurs Init fails. }
    {#X NewCommandSItem }
    constructor Load(var S: TStream);
      { Load calls the inherited constructor, then loads the #CommandList#
        from the stream S.  If an error occurs Load fails. }
    {#X Store Init }
    procedure Press(Item: Sw_Integer); virtual;
      { Press calls the inherited Press then broadcasts the command
        associated with the cluster item that was pressed to the check boxes'
        owner. }
    {#X CommandList }
    procedure Store(var S: TStream); { store should never be virtual;}
      { Store calls the inherited Store method then writes the #CommandList#
        to the stream. }
    {#X Load }
  end;  { of TCommandCheckBoxes }


  {#Z+}
  PCommandRadioButtons = ^TCommandRadioButtons;
  {#Z-}
  TCommandRadioButtons = object(TRadioButtons)
    { TCommandRadioButtons function as normal TRadioButtons, except that when
      a cluster item is pressed it broadcasts a command associated with the
      cluster item to the cluster's owner.

      TCommandRadioButtons are useful when other parts of a dialog should be
      enabled or disabled in response to a radiobutton's status. }
    CommandList: TCommandArray;  { commands for each possible value }
    { The list of commands associated with each radio button item. }
    {#X Init Load Store }
    constructor Init(var Bounds: TRect; ACommandStrings: PCommandSItem);
      { Init calls the inherited constructor and sets up the #CommandList#
        with the specified commands.  If an error occurs Init disposes of the
        command strings then fails. }
    {#X NewCommandSItem }
    constructor Load(var S: TStream);
      { Load calls the inherited constructor then loads the #CommandList#
        from the stream S.  If an error occurs Load fails. }
    {#X Store }
    procedure MovedTo(Item: Sw_Integer); virtual;
      { MovedTo calls the inherited MoveTo, then broadcasts the command of
        the newly selected cluster item to the cluster's owner. }
    {#X Press CommandList }
    procedure Press(Item: Sw_Integer); virtual;
      { Press calls the inherited Press then broadcasts the command
        associated with the cluster item that was pressed to the check boxes
        owner. }
    {#X CommandList MovedTo }
    procedure Store(var S: TStream); { store should never be virtual;}
      { Store calls the inherited Store method then writes the #CommandList#
        to the stream. }
    {#X Load }
  end;  { of TCommandRadioButtons }

  PEditListBox = ^TEditListBox;

  TEditListBox = object(TListBox)
    CurrentField: integer;
    constructor Init(Bounds: TRect; ANumCols: word;
        AVScrollBar: PScrollBar);
    constructor Load(var S: TStream);
    function FieldValidator: PValidator; virtual;
    function FieldWidth: integer; virtual;
    procedure GetField(InputLine: PInputLine); virtual;
    function GetPalette: PPalette; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure SetField(InputLine: PInputLine); virtual;
    function StartColumn: integer; virtual;
  private
    procedure EditField(var Event: TEvent);
  end;  { of TEditListBox }


  PModalInputLine = ^TModalInputLine;

  TModalInputLine = object(TInputLine)
    function Execute: word; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure SetState(AState: word; Enable: boolean); virtual;
  private
    EndState: word;
  end;  { of TModalInputLine }

  {---------------------------------------------------------------------------}
  {                      TDialog OBJECT - DIALOG OBJECT                       }
  {---------------------------------------------------------------------------}

  { Palette layout }
  {  1 = Frame passive }
  {  2 = Frame active }
  {  3 = Frame icon }
  {  4 = ScrollBar page area }
  {  5 = ScrollBar controls }
  {  6 = StaticText }
  {  7 = Label normal }
  {  8 = Label selected }
  {  9 = Label shortcut }
  { 10 = Button normal }
  { 11 = Button default }
  { 12 = Button selected }
  { 13 = Button disabled }
  { 14 = Button shortcut }
  { 15 = Button shadow }
  { 16 = Cluster normal }
  { 17 = Cluster selected }
  { 18 = Cluster shortcut }
  { 19 = InputLine normal text }
  { 20 = InputLine selected text }
  { 21 = InputLine arrows }
  { 22 = History arrow }
  { 23 = History sides }
  { 24 = HistoryWindow scrollbar page area }
  { 25 = HistoryWindow scrollbar controls }
  { 26 = ListViewer normal }
  { 27 = ListViewer focused }
  { 28 = ListViewer selected }
  { 29 = ListViewer divider }
  { 30 = InfoPane }
  { 31 = Cluster disabled }
  { 32 = Reserved }

  PDialog = ^TDialog;

  TDialog = object(TWindow)
    constructor Init(var Bounds: TRect; ATitle: TTitleStr);
    constructor Load(var S: TStream);
    procedure Cancel(ACommand: word); virtual;
      { If the dialog is a modal dialog, Cancel calls EndModal(ACommand).  If
        the dialog is non-modal Cancel calls Close.

        Cancel may be overridden to provide special processing prior to
        destructing the dialog. }
    procedure ChangeTitle(ANewTitle: TTitleStr); virtual;
      { ChangeTitle disposes of the current title, assigns ANewTitle to Title,
        then redraws the dialog. }
    procedure FreeSubView(ASubView: PView); virtual;
    { FreeSubView deletes and disposes ASubView from the dialog. }
    {#X FreeAllSubViews IsSubView }
    procedure FreeAllSubViews; virtual;
    { Deletes then disposes all subviews in the dialog. }
    {#X FreeSubView IsSubView }
    function GetPalette: PPalette; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    function IsSubView(AView: PView): boolean; virtual;
      { IsSubView returns True if AView is non-nil and is a subview of the
        dialog. }
    {#X FreeSubView FreeAllSubViews }
    function NewButton(X, Y, W, H: Sw_Integer; ATitle: TTitleStr;
      ACommand, AHelpCtx: word;
      AFlags: byte): PButton;
      { Creates and inserts into the dialog a new TButton with the
        help context AHelpCtx.

        A pointer to the new button is returned for checking validity of the
        initialization. }
    {#X NewInputLine NewLabel }
    function NewLabel(X, Y: Sw_Integer; AText: string;
      ALink: PView): PLabel;
      { NewLabel creates and inserts into the dialog a new TLabel and
        associates it with ALink. }
    {#X NewButton NewInputLine }
    function NewInputLine(X, Y, W, AMaxLen: Sw_Integer;
      AHelpCtx: word; AValidator: PValidator): PInputLine;
      { NewInputLine creates and inserts into the dialog a new TBSDInputLine
        with the help context to AHelpCtx and the validator AValidator.

        A pointer to the inputline is returned for checking validity of the
        initialization. }
    {#X NewButton NewLabel }
    function Valid(Command: word): boolean; virtual;
  end;

  PListDlg = ^TListDlg;

  TListDlg = object(TDialog)
    { TListDlg displays a listbox of items, with optional New, Edit, and
      Delete buttons displayed according to the options bit set in the
      dialog.  Use the ofXXXX flags declared in this unit OR'd with the
      standard ofXXXX flags to set the appropriate bits in Options.

      If enabled, when the New or Edit buttons are pressed, an evCommand
      message is sent to the application with a Command value of NewCommand
      or EditCommand, respectively.  Using this mechanism in combination with
      the declared Init parameters, a standard TListDlg can be used with any
      type of list displayable in a TListBox or its descendant. }
    NewCommand: word;
    EditCommand: word;
    ListBox: PListBox;
    ldOptions: word;
    constructor Init(ATitle: TTitleStr; Items: string; AButtons: word;
      AListBox: PListBox; AEditCommand, ANewCommand: word);
    constructor Load(var S: TStream);
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure Store(var S: TStream); { store should never be virtual;}
  end;  { of TListDlg }


{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           ITEM STRING ROUTINES                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-NewSItem-----------------------------------------------------------
Allocates memory for a new TSItem record and sets the text field
and chains to the next TSItem. This allows easy construction of
singly-linked lists of strings, to end a chain the next TSItem
should be nil.
28Apr98 LdB
---------------------------------------------------------------------}
function NewSItem(const Str: string; ANext: PSItem): PSItem;

{ NewCommandSItem allocates and returns a pointer to a new #TCommandSItem#
 record.  The Value and Next fields of the record are set to NewStr(Str)
 and ANext, respectively.  The NewSItem function and the TSItem record type
 allow easy construction of singly-linked lists of command strings. }
function NewCommandSItem(Str: string; ACommand: word;
  ANext: PCommandSItem): PCommandSItem;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                   DIALOG OBJECT REGISTRATION PROCEDURE                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-RegisterDialogs----------------------------------------------------
This registers all the view type objects used in this unit.
30Sep99 LdB
---------------------------------------------------------------------}
procedure RegisterDialogs;

{***************************************************************************}
{                        STREAM REGISTRATION RECORDS                        }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                        TDialog STREAM REGISTRATION                        }
{---------------------------------------------------------------------------}
const
  RDialog: TStreamRec = (
    ObjType: idDialog;                               { Register id = 10 }
    VmtLink: TypeOf(TDialog);
    Load: @TDialog.Load;                            { Object load method }
    Store: @TDialog.Store{%H-}                            { Object store method }
    );

{---------------------------------------------------------------------------}
{                      TInputLine STREAM REGISTRATION                       }
{---------------------------------------------------------------------------}
const
  RInputLine: TStreamRec = (
    ObjType: idInputLine;                            { Register id = 11 }
    VmtLink: TypeOf(TInputLine);
    Load: @TInputLine.Load;                         { Object load method }
    Store: @TInputLine.Store{%H-}                         { Object store method }
    );

{---------------------------------------------------------------------------}
{                        TButton STREAM REGISTRATION                        }
{---------------------------------------------------------------------------}
const
  RButton: TStreamRec = (
    ObjType: idButton;                               { Register id = 12 }
    VmtLink: TypeOf(TButton);
    Load: @TButton.Load;                            { Object load method }
    Store: @TButton.Store{%H-}                            { Object store method }
    );

{---------------------------------------------------------------------------}
{                       TCluster STREAM REGISTRATION                        }
{---------------------------------------------------------------------------}
const
  RCluster: TStreamRec = (
    ObjType: idCluster;                              { Register id = 13 }
    VmtLink: TypeOf(TCluster);
    Load: @TCluster.Load;                           { Object load method }
    Store: @TCluster.Store{%H-}                           { Objects store method }
    );

{---------------------------------------------------------------------------}
{                    TRadioButtons STREAM REGISTRATION                      }
{---------------------------------------------------------------------------}
const
  RRadioButtons: TStreamRec = (
    ObjType: idRadioButtons;                         { Register id = 14 }
    VmtLink: TypeOf(TRadioButtons);
    Load: @TRadioButtons.Load;                      { Object load method }
    Store: @TRadioButtons.Store{%H-}                      { Object store method }
    );

{---------------------------------------------------------------------------}
{                     TCheckBoxes STREAM REGISTRATION                       }
{---------------------------------------------------------------------------}
const
  RCheckBoxes: TStreamRec = (
    ObjType: idCheckBoxes;                           { Register id = 15 }
    VmtLink: TypeOf(TCheckBoxes);
    Load: @TCheckBoxes.Load;                        { Object load method }
    Store: @TCheckBoxes.Store{%H-}                        { Object store method }
    );

{---------------------------------------------------------------------------}
{                   TMultiCheckBoxes STREAM REGISTRATION                    }
{---------------------------------------------------------------------------}
const
  RMultiCheckBoxes: TStreamRec = (
    ObjType: idMultiCheckBoxes;                      { Register id = 27 }
    VmtLink: TypeOf(TMultiCheckBoxes);
    Load: @TMultiCheckBoxes.Load;                   { Object load method }
    Store: @TMultiCheckBoxes.Store{%H-}                   { Object store method }
    );

{---------------------------------------------------------------------------}
{                        TListBox STREAM REGISTRATION                       }
{---------------------------------------------------------------------------}
const
  RListBox: TStreamRec = (
    ObjType: idListBox;                              { Register id = 16 }
    VmtLink: TypeOf(TListBox);
    Load: @TListBox.Load;                           { Object load method }
    Store: @TListBox.Store{%H-}                           { Object store method }
    );

{---------------------------------------------------------------------------}
{                      TStaticText STREAM REGISTRATION                      }
{---------------------------------------------------------------------------}
const
  RStaticText: TStreamRec = (
    ObjType: idStaticText;                           { Register id = 17 }
    VmtLink: TypeOf(TStaticText);
    Load: @TStaticText.Load;                        { Object load method }
    Store: @TStaticText.Store{%H-}                        { Object store method }
    );

{---------------------------------------------------------------------------}
{                        TLabel STREAM REGISTRATION                         }
{---------------------------------------------------------------------------}
const
  RLabel: TStreamRec = (
    ObjType: idLabel;                                { Register id = 18 }
    VmtLink: TypeOf(TLabel);
    Load: @TLabel.Load;                             { Object load method }
    Store: @TLabel.Store{%H-}                             { Object store method }
    );

{---------------------------------------------------------------------------}
{                        THistory STREAM REGISTRATION                       }
{---------------------------------------------------------------------------}
const
  RHistory: TStreamRec = (
    ObjType: idHistory;                              { Register id = 19 }
    VmtLink: TypeOf(THistory);
    Load: @THistory.Load;                           { Object load method }
    Store: @THistory.Store{%H-}                           { Object store method }
    );

{---------------------------------------------------------------------------}
{                      TParamText STREAM REGISTRATION                       }
{---------------------------------------------------------------------------}
const
  RParamText: TStreamRec = (
    ObjType: idParamText;                            { Register id = 20 }
    VmtLink: TypeOf(TParamText);
    Load: @TParamText.Load;                         { Object load method }
    Store: @TParamText.Store{%H-}                         { Object store method }
    );

  RCommandCheckBoxes: TStreamRec = (
    ObjType: idCommandCheckBoxes;
    VmtLink: Ofs(TypeOf(TCommandCheckBoxes)^);
    Load: @TCommandCheckBoxes.Load;
    Store: @TCommandCheckBoxes.Store{%H-});

  RCommandRadioButtons: TStreamRec = (
    ObjType: idCommandRadioButtons;
    VmtLink: Ofs(TypeOf(TCommandRadioButtons)^);
    Load: @TCommandRadioButtons.Load;
    Store: @TCommandRadioButtons.Store{%H-});

  RCommandIcon: TStreamRec = (
    ObjType: idCommandIcon;
    VmtLink: Ofs(Typeof(TCommandIcon)^);
    Load: @TCommandIcon.Load;
    Store: @TCommandIcon.Store{%H-});

  RBrowseButton: TStreamRec = (
    ObjType: idBrowseButton;
    VmtLink: Ofs(TypeOf(TBrowseButton)^);
    Load: @TBrowseButton.Load;
    Store: @TBrowseButton.Store{%H-});

  REditListBox: TStreamRec = (
    ObjType: idEditListBox;
    VmtLink: Ofs(TypeOf(TEditListBox)^);
    Load: @TEditListBox.Load;
    Store: @TEditListBox.Store{%H-});

  RListDlg: TStreamRec = (
    ObjType: idListDlg;
    VmtLink: Ofs(TypeOf(TListDlg)^);
    Load: @TListDlg.Load;
    Store: @TListDlg.Store{%H-});

  RModalInputLine: TStreamRec = (
    ObjType: idModalInputLine;
    VmtLink: Ofs(TypeOf(TModalInputLine)^);
    Load: @TModalInputLine.Load;
    Store: @TModalInputLine.Store{%H-});

resourcestring
  slCancel = 'Cancel';
  slOk = 'O~k~';
  slYes = '~Y~es';
  slNo = '~N~o';

  slHelp = '~H~elp';
  slName = '~N~ame';

  slOpen = '~O~pen';
  slClose = '~C~lose';
  slCloseAll = 'Cl~o~se all';

  slSave = '~S~ave';
  slSaveAll = 'Save a~l~l';
  slSaveAs = 'S~a~ve as...';
  slSaveFileAs = '~S~ave file as';

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
implementation

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

uses App, HistList;                               { Standard GFV unit }

{***************************************************************************}
{                         PRIVATE DEFINED CONSTANTS                         }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                 LEFT AND RIGHT ARROW CHARACTER CONSTANTS                  }
{---------------------------------------------------------------------------}
const
  LeftArr = '<';
  RightArr = '>';

{---------------------------------------------------------------------------}
{                               TButton MESSAGES                            }
{---------------------------------------------------------------------------}
const
  cmGrabDefault = 61;                             { Grab default }
  cmReleaseDefault = 62;                             { Release default }

{---------------------------------------------------------------------------}
{  IsBlank -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08Jun98 LdB           }
{---------------------------------------------------------------------------}
function IsBlank(Ch: char): boolean;
begin
  IsBlank := (Ch = ' ') or (Ch = #13) or (Ch = #10); { Check for characters }
end;

{---------------------------------------------------------------------------}
{  HotKey -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08Jun98 LdB            }
{---------------------------------------------------------------------------}
function HotKey(const S: string): char;
var
  I: Sw_Word;
begin
  HotKey := #0;                                      { Preset fail }
  if (S <> '') then                                  { Valid string }
  begin                            
    I := Pos('~', S);                                { Search for tilde }
    if (I <> 0) then
      HotKey := UpCase(S[I + 1]);                    { Return hotkey }
  end;
end;

{***************************************************************************}
{                              OBJECT METHODS                               }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TDialog OBJECT METHODS                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TDialog------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TDialog.Init(var Bounds: TRect; ATitle: TTitleStr);
begin
  inherited Init(Bounds, ATitle, wnNoNumber);        { Call ancestor }
  Options := Options or ofVersion20;                 { Version two dialog }
  GrowMode := 0;                                     { Clear grow mode }
  Flags := wfMove + wfClose;                         { Close/moveable flags }
  Palette := dpGrayDialog;                           { Default gray colours }
end;

{--TDialog------------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TDialog.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  if (Options and ofVersion = ofVersion10) then
  begin
    Palette := dpGrayDialog;                         { Set gray palette }
    Options := Options or ofVersion20;               { Update version flag }
  end;
end;

{--TDialog------------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB        }
{---------------------------------------------------------------------------}
function TDialog.GetPalette: PPalette;
const
  P: array[dpBlueDialog..dpGrayDialog] of string{$ifopt H-}[Length(CBlueDialog)]{$endif} =
    (CBlueDialog, CCyanDialog, CGrayDialog);          { Always normal string }
begin
  GetPalette := PPalette(@P[Palette]);               { Return palette }
end;

{--TDialog------------------------------------------------------------------}
{  Valid -> Platforms DOS/DPMI/WIN/NT/Os2 - Updated 25Apr98 LdB             }
{---------------------------------------------------------------------------}
function TDialog.Valid(Command: word): boolean;
begin
  if (Command = cmCancel) then
    Valid := True                               { Cancel returns true }
  else
    Valid := TGroup.Valid(Command);             { Call group ancestor }
end;

{--TDialog------------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB       }
{---------------------------------------------------------------------------}
procedure TDialog.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);                      { Call ancestor }
  case Event.What of
    evNothing: Exit;                                 { Speed up exit }
    evKeyDown:                                       { Key down event }
      case Event.KeyCode of
        kbEsc, kbCtrlF4:
        begin                                      { Escape key press }
          Event.What := evCommand;                 { Command event }
          Event.Command := cmCancel;               { cancel command }
          Event.InfoPtr := nil;                    { Clear info ptr }
          PutEvent(Event);                         { Put event on queue }
          ClearEvent(Event);                       { Clear the event }
        end;
        kbCtrlF5:
        begin                                      { movement of modal dialogs }
          if (State and sfModal <> 0) then
          begin
            Event.What := evCommand;
            Event.Command := cmResize;
            Event.InfoPtr := nil;
            PutEvent(Event);
            ClearEvent(Event);
          end;
        end;
        kbEnter:
        begin                                      { Enter key press }
          Event.What := evBroadcast;               { Broadcast event }
          Event.Command := cmDefault;              { Default command }
          Event.InfoPtr := nil;                    { Clear info ptr }
          PutEvent(Event);                         { Put event on queue }
          ClearEvent(Event);                       { Clear the event }
        end;
      end;
    evCommand:                                       { Command event }
      case Event.Command of
        cmOk, cmCancel, cmYes, cmNo:                 { End dialog cmds }
          if (State and sfModal <> 0) then
          begin                                      { View is modal }
            EndModal(Event.Command);                 { End modal state }
            ClearEvent(Event);                       { Clear the event }
          end;
      end;
  end;
end;

{****************************************************************************}
{ TDialog.Cancel                                                             }
{****************************************************************************}
procedure TDialog.Cancel(ACommand: word);
begin
  if State and sfModal = sfModal then
    EndModal(ACommand)
  else
    Close;
end;

{****************************************************************************}
{ TDialog.ChangeTitle                                                        }
{****************************************************************************}
procedure TDialog.ChangeTitle(ANewTitle: TTitleStr);
begin
  if (Title <> nil) then
    DisposeStr(Title);
  Title := NewStr(ANewTitle);
  Frame^.DrawView;
end;

{****************************************************************************}
{ TDialog.FreeSubView                                                        }
{****************************************************************************}
procedure TDialog.FreeSubView(ASubView: PView);
begin
  if IsSubView(ASubView) then
  begin
    Delete(ASubView);
    Dispose(ASubView, Done);
    DrawView;
  end;
end;

{****************************************************************************}
{ TDialog.FreeAllSubViews                                                    }
{****************************************************************************}
procedure TDialog.FreeAllSubViews;
var
  P: PView;
begin
  P := First;
  repeat
    P := First;
    if (P <> nil) then
    begin
      Delete(P);
      Dispose(P, Done);
    end;
  until (P = nil);
  DrawView;
end;

{****************************************************************************}
{ TDialog.IsSubView                                                          }
{****************************************************************************}
function TDialog.IsSubView(AView: PView): boolean;
var
  P: PView;
begin
  P := First;
  while (P <> nil) and (P <> AView) do
    P := P^.NextView;
  IsSubView := ((P <> nil) and (P = AView));
end;

{****************************************************************************}
{ TDialog.NewButton                                                          }
{****************************************************************************}
function TDialog.NewButton(X, Y, W, H: Sw_Integer; ATitle: TTitleStr;
    ACommand, AHelpCtx: word; AFlags: byte): PButton;
var
  B: PButton;
  R: TRect;
begin
  R.Assign(X, Y, X + W, Y + H);
  B := New(PButton, Init(R, ATitle, ACommand, AFlags));
  if (B <> nil) then
  begin
    B^.HelpCtx := AHelpCtx;
    Insert(B);
  end;
  NewButton := B;
end;

{****************************************************************************}
{ TDialog.NewInputLine                                                       }
{****************************************************************************}
function TDialog.NewInputLine(X, Y, W, AMaxLen: Sw_Integer;
  AHelpCtx: word; AValidator: PValidator): PInputLine;
var
  P: PInputLine;
  R: TRect;
begin
  R.Assign(X, Y, X + W, Y + 1);
  P := New(PInputLine, Init(R, AMaxLen));
  if (P <> nil) then
  begin
    P^.SetValidator(AValidator);
    P^.HelpCtx := AHelpCtx;
    Insert(P);
  end;
  NewInputLine := P;
end;

{****************************************************************************}
{ TDialog.NewLabel                                                           }
{****************************************************************************}
function TDialog.NewLabel(X, Y: Sw_Integer; AText: string;
  ALink: PView): PLabel;
var
   P: PLabel;
   R: TRect;
begin
  R.Assign(X, Y, X + CStrLen(AText) + 1, Y + 1);
  P := New(PLabel, Init(R, AText, ALink));
  if (P <> nil) then
    Insert(P);
  NewLabel := P;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       TInputLine OBJECT METHODS                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TInputLine---------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TInputLine.Init(const Bounds: TRect; AMaxLen: Sw_Integer);
begin
  inherited Init(Bounds);                            { Call ancestor }
  State := State or sfCursorVis;                     { Cursor visible }
  Options := Options or (ofSelectable + ofFirstClick + ofVersion20);
                                                     { Set options }
  if (MaxAvail > AMaxLen + 1) then
  begin                                              { Check enough memory }
    GetMem(Data, AMaxLen + 1);                       { Allocate memory }
    Data^ := '';                                     { Data = empty string }
  end;
  MaxLen := AMaxLen;                                 { Hold maximum length }
end;

{--TInputLine---------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TInputLine.Load(var S: TStream);
var
  B: byte;
  W: word;
begin
  inherited Load(S);                                 { Call ancestor }
  S.Read(W, sizeof(w));
  MaxLen := W;                                       { Read max length }
  S.Read(W, sizeof(w));
  CurPos := w;                                       { Read cursor position }
  S.Read(W, sizeof(w));
  FirstPos := w;                                     { Read first position }
  S.Read(W, sizeof(w));
  SelStart := w;                                     { Read selected start }
  S.Read(W, sizeof(w));
  SelEnd := w;                                       { Read selected end }
  S.Read(B, SizeOf(B));                              { Read string length }
  GetMem(Data, B + 1);                               { Allocate memory }
  S.Read(Data^[1], B);                               { Read string data }
  SetLength(Data^, B);                               { Xfer string length }
  if (Options and ofVersion >= ofVersion20) then     { Version 2 or above }
    Validator := PValidator(S.Get);                  { Get any validator }
  Options := Options or ofVersion20;                 { Set version 2 flag }
end;

{--TInputLine---------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB              }
{---------------------------------------------------------------------------}
destructor TInputLine.Done;
begin
  if (Data <> nil) then
    FreeMem(Data, MaxLen + 1);                        { Release any memory }
  SetValidator(nil);                                  { Clear any validator }
  inherited Done;                                     { Call ancestor }
end;

{--TInputLine---------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB          }
{---------------------------------------------------------------------------}
function TInputLine.DataSize: Sw_Word;
var
  DSize: Sw_Word;
begin
  DSize := 0;                                        { Preset zero datasize }
  if (Validator <> nil) and (Data <> nil) then
    DSize := Validator^.Transfer(Data^, nil, vtDataSize);
                                                     { Add validator size }
  if (DSize <> 0) then 
    DataSize := DSize                                { Use validtor size }
  else
    DataSize := MaxLen + 1;                          { No validator use size }
end;

{--TInputLine---------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB        }
{---------------------------------------------------------------------------}
function TInputLine.GetPalette: PPalette;
const
  P: string{$ifopt H-}[Length(CInputLine)]{$endif} = CInputLine;     { Always normal string }
begin
  GetPalette := PPalette(@P);                        { Return palette }
end;

{--TInputLine---------------------------------------------------------------}
{  Valid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB             }
{---------------------------------------------------------------------------}
function TInputLine.Valid(Command: Word): Boolean;

  function AppendError(AValidator: PValidator): boolean;
  begin
    AppendError := False;                            { Preset false }
    if (Data <> nil) then
      with AValidator^ do
        if (Options and voOnAppend <> 0) and         { Check options }
          (CurPos <> Length(Data^)) and              { Exceeds max length } 
         not IsValidInput(Data^, True) then
        begin                                        { Check data valid }
          Error;                                     { Call error }
          AppendError := True;                       { Return true }
        end;
  end;

begin
  Valid := inherited Valid(Command);                 { Call ancestor }
  if (Validator <> nil) and (Data <> nil) and        { Validator present }
    (State and sfDisabled = 0) then                    { Not disabled }
    if (Command = cmValid) then                      { Valid command }
      Valid := Validator^.Status = vsOk              { Validator result }
    else if (Command <> cmCancel) then             { Not cancel command }
      if AppendError(Validator) or                 { Append any error } 
        not Validator^.Valid(Data^) then
      begin       { Check validator }
        Select;                                    { Reselect view }
        Valid := False;                            { Return false }
      end;
end;

{--TInputLine---------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB              }
{---------------------------------------------------------------------------}
procedure TInputLine.Draw;
var
  Color: byte;
  L, R: Sw_Integer;
  B: TDrawBuffer;
begin
  if Options and ofSelectable = 0 then
    Color := GetColor(5)
  else
  if (State and sfFocused = 0) then
    Color := GetColor(1)       { Not focused colour }
  else
    Color := GetColor(2);      { Focused colour }
  MoveChar(B, ' ', Color, Size.X);
  MoveStr(B[1], Copy(Data^, FirstPos + 1, Size.X - 2), Color);
  if CanScroll(1) then
    MoveChar(B[Size.X - 1], RightArr, GetColor(4), 1);
  if (State and sfFocused <> 0) and (Options and ofSelectable <> 0) then
  begin
    if CanScroll(-1) then
      MoveChar(B[0], LeftArr, GetColor(4), 1);
    { Highlighted part }
    L := SelStart - FirstPos;
    R := SelEnd - FirstPos;
    if L < 0 then
      L := 0;
    if R > Size.X - 2 then
      R := Size.X - 2;
    if L < R then
      MoveChar(B[L + 1], #0, GetColor(3), R - L);
    SetCursor(CurPos - FirstPos + 1, 0);
  end;
  WriteLine(0, 0, Size.X, Size.Y, B);
end;


{--TInputLine---------------------------------------------------------------}
{  DrawCursor -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Oct99 LdB        }
{---------------------------------------------------------------------------}
procedure TInputLine.DrawCursor;
begin
  if (State and sfFocused <> 0) then
  begin           { Focused window }
    Cursor.Y := 0;
    Cursor.X := CurPos - FirstPos + 1;
    ResetCursor;
  end;
end;

{--TInputLine---------------------------------------------------------------}
{  SelectAll -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB         }
{---------------------------------------------------------------------------}
procedure TInputLine.SelectAll(Enable: Boolean);
begin
  CurPos := 0;                                       { Cursor to start }
  FirstPos := 0;                                     { First pos to start }
  SelStart := 0;                                     { Selected at start }
  if Enable and (Data <> nil) then
    SelEnd := Length(Data^)
  else
    SelEnd := 0;                                     { Selected which end }
  DrawView;                                          { Now redraw the view }
end;

{--TInputLine---------------------------------------------------------------}
{  SetValidator -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB      }
{---------------------------------------------------------------------------}
procedure TInputLine.SetValidator(AValid: PValidator);
begin
  if (Validator <> nil) then
    Validator^.Free;                                 { Release validator }
  Validator := AValid;                               { Set new validator }
end;

{--TInputLine---------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB          }
{---------------------------------------------------------------------------}
procedure TInputLine.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState, Enable);                { Call ancestor }
  if (AState = sfSelected) or ((AState = sfActive) and
    (State and sfSelected <> 0)) then
    SelectAll(Enable)
  else if (AState = sfFocused) then                  { Call select all }
    DrawView;                                        { Redraw for focus }
end;

{--TInputLine---------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB           }
{---------------------------------------------------------------------------}
procedure TInputLine.GetData(var Rec);
begin
  if (Data <> nil) then                              { Data ptr valid }
  begin                       
    if (Validator = nil) 
      or (Validator^.Transfer(Data^, @Rec, vtGetData) = 0) then
    begin                                            { No validator/data }
      FillChar(Rec, DataSize, #0);                   { Clear the data area }
      Move(Data^, Rec, Length(Data^) + 1);           { Transfer our data }
    end;
  end
  else
    FillChar(Rec, DataSize, #0);                     { Clear the data area }
end;

{--TInputLine---------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB           }
{---------------------------------------------------------------------------}
procedure TInputLine.SetData(const Rec);
begin
  if (Data <> nil) then                              { Data ptr valid }
  begin                       
    if (Validator = nil) or (Validator^.Transfer(
      Data^, @Rec, vtSetData) = 0) then
      { No validator/data }
    begin
      setlength(Data^, DataSize);                 { Set our data }
      Move(Rec, Data^[1], DataSize);                 { Set our data }
    end;
  end;
  SelectAll(True);                                   { Now select all }
end;

{--TInputLine---------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB             }
{---------------------------------------------------------------------------}
procedure TInputLine.Store(var S: TStream);
var
  w: word;
begin
  TView.Store(S);                                    { Implict TView.Store }
  w := MaxLen;
  S.Write(w, SizeOf(w));                   { Read max length }
  w := CurPos;
  S.Write(w, SizeOf(w));                   { Read cursor position }
  w := FirstPos;
  S.Write(w, SizeOf(w));                 { Read first position }
  w := SelStart;
  S.Write(w, SizeOf(w));                 { Read selected start }
  w := SelEnd;
  S.Write(w, SizeOf(w));                   { Read selected end }
  S.StrWrite(@Data[1]);                                  { Write the data }
  S.Put(Validator);                                  { Write any validator }
end;

{--TInputLine---------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure TInputLine.HandleEvent(var Event: TEvent);
const
  PadKeys = [$47, $4B, $4D, $4F, $73, $74];
var
  WasAppending: boolean;
  ExtendBlock: boolean;
  OldData: string;
  Delta, Anchor, OldCurPos, OldFirstPos, OldSelStart, OldSelEnd: Sw_Integer;

  function MouseDelta: Sw_Integer;
  var
    Mouse: TPOint;
  begin
    MakeLocal(Event.Where, Mouse);
    if Mouse.X <= 0 then
      MouseDelta := -1
    else if Mouse.X >= Size.X - 1 then
      MouseDelta := 1
    else
      MouseDelta := 0;
  end;

  function MousePos: Sw_Integer;
  var
    Pos: Sw_Integer;
    Mouse: TPoint;
  begin
    MakeLocal(Event.Where, Mouse);
    if Mouse.X < 1 then
      Mouse.X := 1;
    Pos := Mouse.X + FirstPos - 1;
    if Pos < 0 then
      Pos := 0;
    if Pos > Length(Data^) then
      Pos := Length(Data^);
    MousePos := Pos;
  end;

  procedure DeleteSelect;
  begin
    if (SelStart <> SelEnd) then
    begin               { An area selected }
      if (Data <> nil) then
        Delete(Data^, SelStart + 1, SelEnd - SelStart);  { Delete the text }
      CurPos := SelStart;                            { Set cursor position }
    end;
  end;

  procedure AdjustSelectBlock;
  begin
    if (CurPos < Anchor) then
    begin                  { Selection backwards }
      SelStart := CurPos;                            { Start of select }
      SelEnd := Anchor;                              { End of select }
    end
    else
    begin
      SelStart := Anchor;                            { Start of select }
      SelEnd := CurPos;                              { End of select }
    end;
  end;

  procedure SaveState;
  begin
    if (Validator <> nil) then
    begin                 { Check for validator }
      if (Data <> nil) then
        OldData := Data^;        { Hold data }
      OldCurPos := CurPos;                           { Hold cursor position }
      OldFirstPos := FirstPos;                       { Hold first position }
      OldSelStart := SelStart;                       { Hold select start }
      OldSelEnd := SelEnd;                           { Hold select end }
      if (Data = nil) then
        WasAppending := True      { Invalid data ptr }
      else
        WasAppending := Length(Data^) = CurPos; { Hold appending state }
    end;
  end;

  procedure RestoreState;
  begin
    if (Validator <> nil) then
    begin                 { Validator valid }
      if (Data <> nil) then
        Data^ := OldData;        { Restore data }
      CurPos := OldCurPos;                           { Restore cursor pos }
      FirstPos := OldFirstPos;                       { Restore first pos }
      SelStart := OldSelStart;                       { Restore select start }
      SelEnd := OldSelEnd;                           { Restore select end }
    end;
  end;

  function CheckValid(NoAutoFill: boolean): boolean;
  var
    OldLen: Sw_Integer;
    NewData: string;
  begin
    if (Validator <> nil) then
    begin                 { Validator valid }
      CheckValid := False;                           { Preset false return }
      if (Data <> nil) then
        OldLen := Length(Data^); { Hold old length }
      if (Validator^.Options and voOnAppend = 0) or
        (WasAppending and (CurPos = OldLen)) then
      begin
        if (Data <> nil) then
          NewData := Data^       { Hold current data }
        else
          NewData := '';                        { Set empty string }
        if not Validator^.IsValidInput(NewData, NoAutoFill) then
          RestoreState
        else
        begin
          if (Length(NewData) > MaxLen) then         { Exceeds maximum }
            SetLength(NewData, MaxLen);              { Set string length }
          if (Data <> nil) then
            Data^ := NewData;    { Set data value }
          if (Data <> nil) and (CurPos >= OldLen)    { Cursor beyond end } and
            (Length(Data^) > OldLen) then          { Cursor beyond string }
            CurPos := Length(Data^);                 { Set cursor position }
          CheckValid := True;                        { Return true result }
        end;
      end
      else
      begin
        CheckValid := True;                          { Preset true return }
        if (CurPos = OldLen) and (Data <> nil) then  { Lengths match }
          if not Validator^.IsValidInput(Data^, False) then
          begin                          { Check validator }
            Validator^.Error;                        { Call error }
            CheckValid := False;                     { Return false result }
          end;
      end;
    end
    else
      CheckValid := True;                     { No validator }
  end;

begin
  inherited HandleEvent(Event);                      { Call ancestor }
  if (State and sfSelected <> 0) then
  begin          { View is selected }
    case Event.What of
      evNothing: Exit;                               { Speed up exit }
      evMouseDown:
      begin                             { Mouse down event }
        Delta := MouseDelta;                         { Calc scroll value }
        if CanScroll(Delta) then
        begin               { Can scroll }
          repeat
            if CanScroll(Delta) then
            begin           { Still can scroll }
              Inc(FirstPos, Delta);                  { Move start position }
              DrawView;                              { Redraw the view }
            end;
          until not MouseEvent(Event, evMouseAuto);  { Until no mouse auto }
        end
        else if Event.double then                { Double click }
          SelectAll(True)
        else
        begin                 { Select whole text }
          Anchor := MousePos;                      { Start of selection }
          repeat
            if (Event.What = evMouseAuto)
            { Mouse auto event } then
            begin
              Delta := MouseDelta;                 { New position }
              if CanScroll(Delta) then             { If can scroll }
                Inc(FirstPos, Delta);
            end;
            CurPos := MousePos;                    { Set cursor position }
            AdjustSelectBlock;                     { Adjust selected }
            DrawView;                              { Redraw the view }
          until not MouseEvent(Event, evMouseMove + evMouseAuto);
          { Until mouse released }
        end;
        ClearEvent(Event);                           { Clear the event }
      end;
      evKeyDown:
      begin
        SaveState;                                   { Save state of view }
        Event.KeyCode := CtrlToArrow(Event.KeyCode); { Convert keycode }
        if (Event.ScanCode in PadKeys) and (GetShiftState and $03 <> 0) then
        begin      { Mark selection active }
          Event.CharCode := #0;                      { Clear char code }
          if (CurPos = SelEnd) then                  { Find if at end }
            Anchor := SelStart
          else                  { Anchor from start }
            Anchor := SelEnd;                        { Anchor from end }
          ExtendBlock := True;                     { Extended block true }
        end
        else
          ExtendBlock := False;               { No extended block }
        case Event.KeyCode of
          kbLeft: if (CurPos > 0) then
              Dec(CurPos);  { Move cursor left }
          kbRight: if (Data <> nil) and              { Move right cursor }
              (CurPos < Length(Data^)) then
            begin        { Check not at end }
              Inc(CurPos);                             { Move cursor }
              CheckValid(True);                        { Check if valid }
            end;
          kbHome: CurPos := 0;                       { Move to line start }
          kbEnd:
          begin                               { Move to line end }
            if (Data = nil) then
              CurPos := 0         { Invalid data ptr }
            else
              CurPos := Length(Data^);          { Set cursor position }
            CheckValid(True);                        { Check if valid }
          end;
          kbBack: if (Data <> nil) and (CurPos > 0)
            { Not at line start } then
            begin
              Delete(Data^, CurPos, 1);                { Backspace over char }
              Dec(CurPos);                             { Move cursor back one }
              if (FirstPos > 0) then
                Dec(FirstPos);    { Move first position }
              CheckValid(True);                        { Check if valid }
            end;
          kbDel: if (Data <> nil) then
            begin         { Delete character }
              if (SelStart = SelEnd) then              { Select all on }
                if (CurPos < Length(Data^)) then
                begin { Cursor not at end }
                  SelStart := CurPos;                  { Set select start }
                  SelEnd := CurPos + 1;                { Set select end }
                end;
              DeleteSelect;                            { Deselect selection }
              CheckValid(True);                        { Check if valid }
            end;
          kbIns: SetState(sfCursorIns, State and sfCursorIns = 0);
            { Flip insert state }
          else
            case Event.CharCode of
              ' '..#255: if (Data <> nil) then
                begin   { Character key }
                  if (State and sfCursorIns <> 0) then
                    Delete(Data^, CurPos + 1, 1)
                  else    { Overwrite character }
                    DeleteSelect;                        { Deselect selected }
                  if CheckValid(True) then
                  begin         { Check data valid }
                    if (Length(Data^) < MaxLen) then     { Must not exceed maxlen }
                    begin
                      if (FirstPos > CurPos) then
                        FirstPos := CurPos;              { Advance first position }
                      Inc(CurPos);                       { Increment cursor }
                      Insert(Event.CharCode, Data^,
                        CurPos);                         { Insert the character }
                    end;
                    CheckValid(False);                   { Check data valid }
                  end;
                end;
              ^Y: if (Data <> nil) then
                begin          { Clear all data }
                  Data^ := '';                          { Set empty string }
                  CurPos := 0;                          { Cursor to start }
                end;
              else
                Exit;                               { Unused key }
            end
        end;
        if ExtendBlock then
          AdjustSelectBlock        { Extended block }
        else
        begin
          SelStart := CurPos;                        { Set select start }
          SelEnd := CurPos;                          { Set select end }
        end;
        if (FirstPos > CurPos) then
          FirstPos := CurPos;                        { Advance first pos }
        if (Data <> nil) then
          OldData := Copy(Data^, FirstPos + 1, CurPos - FirstPos)
        { Text area string }
        else
          OldData := '';                        { Empty string }
        Delta := 1;                          { Safety = 1 char }
        while (TextWidth(OldData) > (Size.X - Delta) -
            TextWidth(LeftArr) - TextWidth(RightArr))  { Check text fits } do
        begin
          Inc(FirstPos);                             { Advance first pos }
          OldData := Copy(Data^, FirstPos + 1, CurPos - FirstPos);
          { Text area string }
        end;
        DrawView;                                    { Redraw the view }
        ClearEvent(Event);                           { Clear the event }
      end;
    end;
  end;
end;

{***************************************************************************}
{                     TInputLine OBJECT PRIVATE METHODS                     }
{***************************************************************************}
{--TInputLine---------------------------------------------------------------}
{  CanScroll -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB         }
{---------------------------------------------------------------------------}
function TInputLine.CanScroll(Delta: Sw_Integer): Boolean;
var
  S: string;
begin
  if (Delta < 0) then
    CanScroll := FirstPos > 0      { Check scroll left }
  else if (Delta > 0) then
  begin
    if (Data = nil) then
      S := ''
    else              { Data ptr invalid }
      S := Copy(Data^, FirstPos + 1, Length(Data^) - FirstPos);
    { Fetch max string }
    CanScroll := (TextWidth(S)) > (Size.X - TextWidth(LeftArr) -
      TextWidth(RightArr));   { Check scroll right }
  end
  else
    CanScroll := False;                     { Zero so no scroll }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TButton OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TButton------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TButton.Init(var Bounds: TRect; ATitle: TTitleStr;
  ACommand: word; AFlags: word);
begin
  inherited Init(Bounds);                            { Call ancestor }
  EventMask := EventMask or evBroadcast;             { Handle broadcasts }
  Options := Options or (ofSelectable + ofFirstClick + ofPreProcess +
    ofPostProcess);
  { Set option flags }
  if not CommandEnabled(ACommand) then
    State := State or sfDisabled;                    { Check command state }
  Flags := AFlags;                                   { Hold flags }
  if (AFlags and bfDefault <> 0) then
    AmDefault := True
  else
    AmDefault := False;                         { Check if default }
  Title := NewStr(ATitle);                           { Hold title string }
  Command := ACommand;                               { Hold button command }
  TabMask := TabMask or (tmLeft + tmRight + tmTab + tmShiftTab + tmUp + tmDown);
  { Set tab masks }
end;

{--TButton------------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TButton.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  Title := S.ReadStr;                                { Read title }
  S.Read(Command, SizeOf(Command));                  { Read command }
  S.Read(Flags, SizeOf(Flags));                      { Read flags }
  S.Read(AmDefault, SizeOf(AmDefault));              { Read if default }
  if not CommandEnabled(Command) then                { Check command state }
    State := State or sfDisabled
  else                { Command disabled }
    State := State and not sfDisabled;               { Command enabled }
end;

{--TButton------------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
destructor TButton.Done;
begin
  if (Title <> nil) then
    DisposeStr(Title);          { Dispose title }
  inherited Done;                                    { Call ancestor }
end;

{--TButton------------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB        }
{---------------------------------------------------------------------------}
function TButton.GetPalette: PPalette;
const
  P: string{$ifopt H-}[Length(CButton)]{$endif} = CButton;           { Always normal string }
begin
  GetPalette := PPalette(@P);                                  { Get button palette }
end;

{--TButton------------------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 29Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TButton.Press;
var
  E: TEvent;
begin
  Message(Owner, evBroadcast, cmRecordHistory, nil); { Message for history }
  if (Flags and bfBroadcast <> 0) then               { Broadcasting button }
    Message(Owner, evBroadcast, Command, @Self)      { Send message }
  else
  begin
    E.What := evCommand;                           { Command event }
    E.Command := Command;                          { Set command value }
    E.InfoPtr := @Self;                            { Pointer to self }
    PutEvent(E);                                   { Put event on queue }
  end;
end;

{--TButton------------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB         }
{---------------------------------------------------------------------------}
procedure TButton.Draw;
var
  I, J, Pos: Sw_Integer;
  Bc: word;
  Db: TDrawBuffer;
  C: char;
begin
  if (State and sfDisabled <> 0) then                { Button disabled }
    Bc := GetColor($0404)
  else
  begin                 { Disabled colour }
    Bc := GetColor($0501);                         { Set normal colour }
    if (State and sfActive <> 0) then              { Button is active }
      if (State and sfSelected <> 0) then
        Bc := GetColor($0703)
      else                 { Set selected colour }
      if AmDefault then
        Bc := GetColor($0602); { Set is default colour }
  end;
  if title = nil then
  begin
    MoveChar(Db[0], ' ', GetColor(8), 1);
    {No title, draw an empty button.}
    for j := sw_integer(downflag) to size.x - 2 do
      MoveChar(Db[j], ' ', Bc, 1);
  end
  else
    {We have a title.}
  begin
    if (Flags and bfLeftJust = 0) then
    begin         { Not left set title }
      I := CTextWidth(Title^);                        { Fetch title width }
      I := (Size.X - I) div 2;                    { Centre in button }
    end
    else
      I := 1;                         { Left edge of button }
    if DownFlag then
    begin
      MoveChar(Db[0], ' ', GetColor(8), 1);
      Pos := 1;
    end
    else
      pos := 0;
    for j := 0 to I - 1 do
      MoveChar(Db[pos + j], ' ', Bc, 1);
    MoveCStr(Db[I + pos], Title^, Bc);                        { Move title to buffer }
    for j := pos + CStrLen(Title^) + I to size.X - 2 do
      MoveChar(Db[j], ' ', Bc, 1);
  end;
  if not DownFlag then
    Bc := GetColor(8);
  MoveChar(Db[Size.X - 1], ' ', Bc, 1);
  WriteLine(0, 0, Size.X, 1, Db);                  { Write the title }
  if Size.Y > 1 then
  begin
    Bc := GetColor(8);
    if not DownFlag then
    begin
      c := 'Ü';
      MoveChar(Db, c, Bc, 1);
      WriteLine(Size.X - 1, 0, 1, 1, Db);
    end;
    MoveChar(Db, ' ', Bc, 1);
    if DownFlag then
      c := ' '
    else
      c := 'ß';
    MoveChar(Db[1], c, Bc, Size.X - 1);
    WriteLine(0, 1, Size.X, 1, Db);
  end;
end;

{--TButton------------------------------------------------------------------}
{  DrawState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB         }
{---------------------------------------------------------------------------}
procedure TButton.DrawState(Down: boolean);
begin
  DownFlag := Down;                                  { Set down flag }
  DrawView;                                          { Redraw the view }
end;

{--TButton------------------------------------------------------------------}
{  MakeDefault -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure TButton.MakeDefault(Enable: boolean);
var
  C: word;
begin
  if (Flags and bfDefault = 0) then
  begin              { Not default }
    if Enable then
      C := cmGrabDefault
    else
      C := cmReleaseDefault;                    { Change default }
    Message(Owner, evBroadcast, C, @Self);           { Message to owner }
    AmDefault := Enable;                             { Set default flag }
    DrawView;                                        { Now redraw button }
  end;
end;

{--TButton------------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB          }
{---------------------------------------------------------------------------}
procedure TButton.SetState(AState: word; Enable: boolean);
begin
  inherited SetState(AState, Enable);                { Call ancestor }
  if (AState and (sfSelected + sfActive) <> 0)       { Changing select } then
    DrawView;                                   { Redraw required }
  if (AState and sfFocused <> 0) then
    MakeDefault(Enable);                             { Check for default }
end;

{--TButton------------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TButton.Store(var S: TStream);
begin
  TView.Store(S);                                    { Implict TView.Store }
  S.WriteStr(Title);                                 { Store title string }
  S.Write(Command, SizeOf(Command));                 { Store command }
  S.Write(Flags, SizeOf(Flags));                     { Store flags }
  S.Write(AmDefault, SizeOf(AmDefault));             { Store default flag }
end;

{--TButton------------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Sep99 LdB       }
{---------------------------------------------------------------------------}
procedure TButton.HandleEvent(var Event: TEvent);
var
  Down: boolean;
  C: char;
  ButRect: TRect;
  Mouse: TPoint;
begin
  ButRect.A.X := 0;                            { Get origin point }
  ButRect.A.Y := 0;                            { Get origin point }
  ButRect.B.X := Size.X + 2;            { Calc right side }
  ButRect.B.Y := Size.Y + 1;            { Calc bottom }
  if (Event.What = evMouseDown) then
  begin           { Mouse down event }
    MakeLocal(Event.Where, Mouse);
    if not ButRect.Contains(Mouse) then
    begin       { If point not in view }
      ClearEvent(Event);                             { Clear the event }
      Exit;                                          { Speed up exit }
    end;
  end;
  if (Flags and bfGrabFocus <> 0) then               { Check focus grab }
    inherited HandleEvent(Event);                    { Call ancestor }
  case Event.What of
    evNothing: Exit;                                 { Speed up exit }
    evMouseDown:
    begin
      if (State and sfDisabled = 0) then
      begin       { Button not disabled }
        Down := False;                               { Clear down flag }
        repeat
          MakeLocal(Event.Where, Mouse);
          if (Down <> ButRect.Contains(Mouse)) { State has changed } then
          begin
            Down := not Down;                        { Invert down flag }
            DrawState(Down);                         { Redraw button }
          end;
        until not MouseEvent(Event, evMouseMove);    { Wait for mouse move }
        if Down then
        begin                           { Button is down }
          Press;                                     { Send out command }
          DrawState(False);                          { Draw button up }
        end;
      end;
      ClearEvent(Event);                             { Event was handled }
    end;
    evKeyDown:
    begin
      if (Title <> nil) then
        C := HotKey(Title^)     { Key title hotkey }
      else
        C := #0;                                { Invalid title }
      if (Event.KeyCode = GetAltCode(C)) or          { Alt char }
        (Owner^.Phase = phPostProcess) and (C <> #0) and
        (Upcase(Event.CharCode) = C) or            { Matches hotkey }
        (State and sfFocused <> 0) and                 { View focused }
        ((Event.CharCode = ' ') or                     { Space bar }
        (Event.KeyCode = kbEnter)) then
      begin            { Enter key }
        DrawState(True);                             { Draw button down }
        Press;                                       { Send out command }
        ClearEvent(Event);                           { Clear the event }
        DrawState(False);                            { Draw button up }
      end;
    end;
    evBroadcast:
      case Event.Command of
        cmDefault: if AmDefault and                  { Default command }
            (State and sfDisabled = 0) then
          begin        { Button enabled }
            Press;                                   { Send out command }
            ClearEvent(Event);                       { Clear the event }
          end;
        cmGrabDefault, cmReleaseDefault:             { Grab and release cmd }
          if (Flags and bfDefault <> 0) then
          begin   { Change button state }
            AmDefault := Event.Command = cmReleaseDefault;
            DrawView;                                { Redraw the view }
          end;
        cmCommandSetChanged:
        begin                   { Command set changed }
          SetState(sfDisabled, not CommandEnabled(Command));
          { Set button state }
          DrawView;                                 { Redraw the view }
        end;
      end;
  end;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TCluster OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

const
  TvClusterClassName = 'TVCLUSTER';

{--TCluster-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28May98 LdB              }
{---------------------------------------------------------------------------}
constructor TCluster.Init(var Bounds: TRect; AStrings: PSItem);
var
  I: Sw_Integer;
  P: PSItem;
begin
  inherited Init(Bounds);                            { Call ancestor }
  Options := Options or (ofSelectable + ofFirstClick + ofPreProcess +
    ofPostProcess + ofVersion20);   { Set option masks }
  I := 0;                                            { Zero string count }
  P := AStrings;                                     { First item }
  while (P <> nil) do
  begin
    Inc(I);                                          { Count 1 item }
    P := P^.Next;                                    { Move to next item }
  end;
  Strings.Init(I, 0);                                { Create collection }
  while (AStrings <> nil) do
  begin
    P := AStrings;                                   { Transfer item ptr }
    Strings.AtInsert(Strings.Count, AStrings^.Value);{ Insert string }
    AStrings := AStrings^.Next;                      { Move to next item }
    Dispose(P);                                      { Dispose prior item }
  end;
  Sel := 0;
  SetCursor(2, 0);
  ShowCursor;
  EnableMask := Sw_Integer($FFFFFFFF);                           { Enable bit masks }
end;

{--TCluster-----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TCluster.Load(var S: TStream);
var
  w: word;
begin
  inherited Load(S);                                 { Call ancestor }
  if ((Options and ofVersion) >= ofVersion20) then   { Version 2 TV view }
  begin
    S.Read(Value, SizeOf(Value));                  { Read value }
    S.Read(Sel, Sizeof(Sel));                      { Read select item }
    S.Read(EnableMask, SizeOf(EnableMask));         { Read enable masks }
  end
  else
  begin
    w := Value;
    S.Read(w, SizeOf(w));
    Value := w;                  { Read value }
    S.Read(Sel, SizeOf(Sel));                        { Read select item }
    EnableMask := Sw_integer($FFFFFFFF);             { Enable all masks }
    Options := Options or ofVersion20;               { Set version 2 mask }
  end;
  Strings.Load(S);                                   { Load string data }
  SetButtonState(0, True);                           { Set button state }
end;

{--TCluster-----------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB              }
{---------------------------------------------------------------------------}
destructor TCluster.Done;
begin
  Strings.Done;                                      { Dispose of strings }
  inherited Done;                                    { Call ancestor }
end;

{--TCluster-----------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB          }
{---------------------------------------------------------------------------}
function TCluster.DataSize: Sw_Word;
begin
  DataSize := SizeOf(Sw_Word);                          { Exchanges a word }
end;

{--TCluster-----------------------------------------------------------------}
{  GetHelpCtx -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB        }
{---------------------------------------------------------------------------}
function TCluster.GetHelpCtx: word;
begin
  if (HelpCtx = hcNoContext) then                    { View has no help }
    GetHelpCtx := hcNoContext
  else                   { No help context }
    GetHelpCtx := HelpCtx + Sel;                     { Help of selected }
end;

{--TCluster-----------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB        }
{---------------------------------------------------------------------------}
function TCluster.GetPalette: PPalette;
const
  P: string{$ifopt H-}[Length(CCluster)]{$endif} = CCluster;         { Always normal string }
begin
  GetPalette := PPalette(@P);                        { Cluster palette }
end;

{--TCluster-----------------------------------------------------------------}
{  Mark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB              }
{---------------------------------------------------------------------------}
function TCluster.Mark(Item: Sw_Integer): boolean;
begin
  Mark := False;                                     { Default false }
end;

{--TCluster-----------------------------------------------------------------}
{  MultiMark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB         }
{---------------------------------------------------------------------------}
function TCluster.MultiMark(Item: Sw_Integer): byte;
begin
  MultiMark := byte(Mark(Item) = True);              { Return multi mark }
end;

{--TCluster-----------------------------------------------------------------}
{  ButtonState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB       }
{---------------------------------------------------------------------------}
function TCluster.ButtonState(Item: Sw_Integer): boolean;
begin
  if (Item > 31) then
    ButtonState := False
  else      { Impossible item }
    ButtonState := ((1 shl Item) and EnableMask) <> 0; { Return true/false }
end;

{--TCluster-----------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Jul99 LdB         }
{---------------------------------------------------------------------------}
procedure TCluster.Draw;
begin
end;

{--TCluster-----------------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TCluster.Press(Item: Sw_Integer);
var
  P: PView;
begin
  P := TopView;
  if (Id <> 0) and (P <> nil) then
    NewMessage(P,
      evCommand, cmIdCommunicate, Id, Value, @Self);   { Send new message }
end;

{--TCluster-----------------------------------------------------------------}
{  MovedTo -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TCluster.MovedTo(Item: Sw_Integer);
begin                                                 { Abstract method }
end;

{--TCluster-----------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB          }
{---------------------------------------------------------------------------}
procedure TCluster.SetState(AState: word; Enable: boolean);
begin
  inherited SetState(AState, Enable);                { Call ancestor }
  if (AState and sfFocused <> 0) then
  begin
    DrawView;                                        { Redraw masked areas }
  end;
end;

{--TCluster-----------------------------------------------------------------}
{  DrawMultiBox -> Platforms DOS/DPMI/WIN/NT - Updated 05Jun98 LdB          }
{---------------------------------------------------------------------------}
procedure TCluster.DrawMultiBox(const Icon, Marker: string);
var
  I, J, Cur, Col: Sw_Integer;
  CNorm, CSel, CDis, Color: word;
  B: TDrawBuffer;
begin
  CNorm := GetColor($0301);                          { Normal colour }
  CSel := GetColor($0402);                           { Selected colour }
  CDis := GetColor($0505);                           { Disabled colour }
  for I := 0 to Size.Y - 1 do
  begin                { For each line }
    MoveChar(B, ' ', byte(CNorm), Size.X);       { Fill buffer }
    for J := 0 to (Strings.Count - 1) div Size.Y + 1 do
    begin
      Cur := J * Size.Y + I;                           { Current line }
      if (Cur < Strings.Count) then
      begin
        Col := Column(Cur);                          { Calc column }
        if (Col + CStrLen(PString(Strings.At(Cur))^) + 5 <
          Sizeof(TDrawBuffer) div SizeOf(word)) and (Col < Size.X) then
        begin            { Text fits in column }
          if not ButtonState(Cur) then
            Color := CDis
          else if (Cur = Sel) and    { Disabled colour }
            (State and sfFocused <> 0) then
            Color := CSel
          else                     { Selected colour }
            Color := CNorm;                        { Normal colour }
          MoveChar(B[Col], ' ', byte(Color),
            Size.X - Col);                         { Set this colour }
          MoveStr(B[Col], Icon, byte(Color));        { Transfer icon string }
          WordRec(B[Col + 2]).Lo := byte(Marker[MultiMark(Cur) + 1]);
          { Transfer marker }
          MoveCStr(B[Col + 5], PString(Strings.At(Cur))^, Color);
          { Transfer item string }
          if ShowMarkers and (State and sfFocused <> 0) and (Cur = Sel) then
          begin                 { Current is selected }
            WordRec(B[Col]).Lo := byte(SpecialChars[0]);
            WordRec(B[Column(Cur + Size.Y) - 1]).Lo :=
              byte(SpecialChars[1]);             { Set special character }
          end;
        end;
      end;
    end;
    WriteBuf(0, I, Size.X, 1, B);              { Write buffer }
  end;
  SetCursor(Column(Sel) + 2, Row(Sel));
end;

{--TCluster-----------------------------------------------------------------}
{  DrawBox -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TCluster.DrawBox(const Icon: string; Marker: char);
begin
  DrawMultiBox(Icon, ' ' + Marker);                    { Call draw routine }
end;

{--TCluster-----------------------------------------------------------------}
{  SetButtonState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB    }
{---------------------------------------------------------------------------}
procedure TCluster.SetButtonState(AMask: longint; Enable: boolean);
var
  I: Sw_Integer;
  M: longint;
begin
  if Enable then
    EnableMask := EnableMask or AMask   { Set enable bit mask }
  else
    EnableMask := EnableMask and not AMask;     { Disable bit mask }
  if (Strings.Count <= 32) then
  begin                { Valid string number }
    M := 1;                                          { Preset bit masks }
    for I := 1 to Strings.Count do
    begin             { For each item string }
      if ((M and EnableMask) <> 0) then
      begin        { Bit enabled }
        Options := Options or ofSelectable;          { Set selectable option }
        Exit;                                        { Now exit }
      end;
      M := M shl 1;                                  { Create newbit mask }
    end;
    Options := Options and not ofSelectable;         { Make not selectable }
  end;
end;

{--TCluster-----------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB           }
{---------------------------------------------------------------------------}
procedure TCluster.GetData(var Rec);
begin
  sw_Word(Rec) := Value;                             { Return current value }
end;

{--TCluster-----------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB           }
{---------------------------------------------------------------------------}
procedure TCluster.SetData(const Rec);
begin
  Value := sw_Word(Rec);                              { Set current value }
  DrawView;                                          { Redraw masked areas }
end;

{--TCluster-----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TCluster.Store(var S: TStream);
var
  w: word;
begin
  TView.Store(S);                                    { TView.Store called }
  if ((Options and ofVersion) >= ofVersion20)        { Version 2 TV view } then
  begin
    S.Write(Value, SizeOf(Value));                   { Write value }
    S.Write(Sel, SizeOf(Sel));                       { Write select item }
    S.Write(EnableMask, SizeOf(EnableMask));         { Write enable masks }
  end
  else
  begin
    w := Value;
    S.Write(w, SizeOf(word));                        { Write value }
    S.Write(Sel, SizeOf(Sel));                       { Write select item }
  end;
  Strings.Store(S);                                  { Store strings }
end;

{--TCluster-----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Jun98 LdB       }
{---------------------------------------------------------------------------}
procedure TCluster.HandleEvent(var Event: TEvent);
var
  C: char;
  I, S, Vh: Sw_Integer;
  Key: word;
  Mouse: TPoint;
  Ts: PString;

  procedure MoveSel;
  begin
    if (I <= Strings.Count) then
    begin
      Sel := S;                                      { Set selected item }
      MovedTo(Sel);                                  { Move to selected }
      DrawView;                                      { Now draw changes }
    end;
  end;

begin
  inherited HandleEvent(Event);                      { Call ancestor }
  if ((Options and ofSelectable) = 0) then
    Exit;     { Check selectable }
  if (Event.What = evMouseDown) then
  begin           { MOUSE EVENT }
    MakeLocal(Event.Where, Mouse);                   { Make point local }
    I := FindSel(Mouse);                             { Find selected item }
    if (I <> -1) then                                { Check in view }
      if ButtonState(I) then
        Sel := I;               { If enabled select }
    DrawView;                                        { Now draw changes }
    repeat
      MakeLocal(Event.Where, Mouse);                 { Make point local }
    until not MouseEvent(Event, evMouseMove);        { Wait for mouse up }
    MakeLocal(Event.Where, Mouse);                   { Make point local }
    if (FindSel(Mouse) = Sel) and ButtonState(Sel)   { If valid/selected } then
    begin
      Press(Sel);                                    { Call pressed }
      DrawView;                                      { Now draw changes }
    end;
    ClearEvent(Event);                               { Event was handled }
  end
  else if (Event.What = evKeyDown) then
  begin    { KEY EVENT }
    Vh := Size.Y;                            { View height }
    S := Sel;                                        { Hold current item }
    Key := CtrlToArrow(Event.KeyCode);               { Convert keystroke }
    case Key of
      kbUp, kbDown, kbRight, kbLeft:
        if (State and sfFocused <> 0) then
        begin       { Focused key event }
          I := 0;                                      { Zero process count }
          repeat
            Inc(I);                                    { Inc process count }
            case Key of
              kbUp: Dec(S);                            { Next item up }
              kbDown: Inc(S);                          { Next item down }
              kbRight:
              begin                           { Next column across }
                Inc(S, Vh);                            { Move to next column }
                if (S >= Strings.Count) then           { No next column check }
                  S := (S + 1) mod Vh;                   { Move to last column }
              end;
              kbLeft:
              begin                            { Prior column across }
                Dec(S, Vh);                            { Move to prior column }
                if (S < 0) then
                  S := ((Strings.Count + Vh - 1) div Vh) * Vh + S - 1;
                { No prior column check }
              end;
            end;
            if (S >= Strings.Count) then
              S := 0;       { Roll up to top }
            if (S < 0) then
              S := Strings.Count - 1;    { Roll down to bottom }
          until ButtonState(S) or (I > Strings.Count); { Repeat until select }
          MoveSel;                                     { Move to selected }
          ClearEvent(Event);                           { Event was handled }
        end;
      else
      begin                                     { Not an arrow key }
        for I := 0 to Strings.Count - 1 do
        begin       { Scan each item }
          Ts := Strings.At(I);                       { Fetch string pointer }
          if (Ts <> nil) then
            C := HotKey(Ts^)       { Check for hotkey }
          else
            C := #0;                            { No valid string }
          if (GetAltCode(C) = Event.KeyCode) or      { Hot key for item }
            (((Owner^.Phase = phPostProcess) or        { Owner in post process }
            (State and sfFocused <> 0)) and (C <> #0)  { Non zero hotkey } and
            (UpCase(Event.CharCode) = C))          { Matches current key } then
          begin
            if ButtonState(I) then
            begin             { Check mask enabled }
              if Focus then
              begin                    { Check view focus }
                Sel := I;                            { Set selected }
                MovedTo(Sel);                        { Move to selected }
                Press(Sel);                          { Call pressed }
                DrawView;                            { Now draw changes }
              end;
              ClearEvent(Event);                     { Event was handled }
            end;
            Exit;                                    { Now exit }
          end;
        end;
        if (Event.CharCode = ' ') and                { Spacebar key }
          (State and sfFocused <> 0) and               { Check focused view }
          ButtonState(Sel) then
        begin                  { Check item enabled }
          Press(Sel);                                { Call pressed }
          DrawView;                                  { Now draw changes }
          ClearEvent(Event);                         { Event was handled }
        end;
      end;
    end;
  end;
end;

{***************************************************************************}
{                      TCluster OBJECT PRIVATE METHODS                      }
{***************************************************************************}

{--TCluster-----------------------------------------------------------------}
{  FindSel -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB           }
{---------------------------------------------------------------------------}
function TCluster.FindSel(P: TPoint): Sw_Integer;
var
  I, S, Vh: Sw_Integer;
  R: TRect;
begin
  GetExtent(R);                                      { Get view extents }
  if R.Contains(P) then
  begin                        { Point in view }
    Vh := Size.Y;                            { View height }
    I := 0;                                          { Preset zero value }
    while (P.X >= Column(I + Vh)) do
      Inc(I, Vh);       { Inc view size }
    S := I + P.Y;                                { Line to select }
    if ((S >= 0) and (S < Strings.Count))            { Valid selection } then
      FindSel := S
    else
      FindSel := -1;          { Return selected item }
  end
  else
    FindSel := -1;                            { Point outside view }
end;

{--TCluster-----------------------------------------------------------------}
{  Row -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB               }
{---------------------------------------------------------------------------}
function TCluster.Row(Item: Sw_Integer): Sw_Integer;
begin
  Row := Item mod Size.Y;                           { Normal mod value }
end;

{--TCluster-----------------------------------------------------------------}
{  Column -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB            }
{---------------------------------------------------------------------------}
function TCluster.Column(Item: Sw_Integer): Sw_Integer;
var
  I, Col, Width, L, Vh: Sw_Integer;
  Ts: PString;
begin
  Vh := Size.Y;                              { Vertical size }
  if (Item >= Vh) then
  begin                         { Valid selection }
    Width := 0;                                      { Zero width }
    Col := -6;                                       { Start column at -6 }
    for I := 0 to Item do
    begin                      { For each item }
      if (I mod Vh = 0) then
      begin                   { Start next column }
        Inc(Col, Width + 6);                         { Add column width }
        Width := 0;                                  { Zero width }
      end;
      if (I < Strings.Count) then
      begin              { Valid string }
        Ts := Strings.At(I);                         { Transfer string }
        if (Ts <> nil) then
          L := CStrLen(Ts^)        { Length of string }
        else
          L := 0;                               { No string }
      end;
      if (L > Width) then
        Width := L;                { Hold longest string }
    end;
    Column := Col;                                   { Return column }
  end
  else
    Column := 0;                              { Outside select area }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TRadioButtons OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TRadioButtons------------------------------------------------------------}
{  Mark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB              }
{---------------------------------------------------------------------------}
function TRadioButtons.Mark(Item: Sw_Integer): boolean;
begin
  Mark := Item = Value;                              { True if item = value }
end;

{--TRadioButtons------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB              }
{---------------------------------------------------------------------------}
procedure TRadioButtons.Draw;
const
  Button = ' ( ) ';
begin
  inherited Draw;
  DrawMultiBox(Button, ' *');                       { Redraw the text }
end;

{--TRadioButtons------------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TRadioButtons.Press(Item: Sw_Integer);
begin
  Value := Item;                                     { Set value field }
  inherited Press(Item);                             { Call ancestor }
end;

{--TRadioButtons------------------------------------------------------------}
{  MovedTo -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB           }
{---------------------------------------------------------------------------}
procedure TRadioButtons.MovedTo(Item: Sw_Integer);
begin
  Value := Item;                                     { Set value to item }
  if (Id <> 0) then
    NewMessage(Owner, evCommand,
      cmIdCommunicate, Id, Value, @Self);              { Send new message }
end;

{--TRadioButtons------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB           }
{---------------------------------------------------------------------------}
procedure TRadioButtons.SetData(const Rec);
begin
  Sel := Sw_word(Rec);                               { Set selection }
  inherited SetData(Rec);                            { Call ancestor }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TCheckBoxes OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TCheckBoxes--------------------------------------------------------------}
{  Mark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB              }
{---------------------------------------------------------------------------}
function TCheckBoxes.Mark(Item: Sw_Integer): boolean;
begin
  if (Value and (1 shl Item) <> 0) then              { Check if item ticked }
    Mark := True
  else
    Mark := False;                 { Return result }
end;

{--TCheckBoxes--------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB              }
{---------------------------------------------------------------------------}
procedure TCheckBoxes.Draw;
const
  Button = ' [ ] ';
begin
  inherited Draw;
  DrawMultiBox(Button, ' X');                        { Redraw the text }
end;

{--TCheckBoxes--------------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TCheckBoxes.Press(Item: Sw_Integer);
begin
  Value := Value xor (1 shl Item);                   { Flip the item mask }
  inherited Press(Item);                             { Call ancestor }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                      TMultiCheckBoxes OBJECT METHODS                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TMultiCheckBoxes---------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Jun98 LdB              }
{---------------------------------------------------------------------------}
constructor TMultiCheckBoxes.Init(var Bounds: TRect; AStrings: PSItem; ASelRange: byte;
  AFlags: word; const AStates: string);
begin
  inherited Init(Bounds, AStrings);                  { Call ancestor }
  SelRange := ASelRange;                             { Hold select range }
  Flags := AFlags;                                   { Hold flags }
  States := NewStr(AStates);                         { Hold string }
end;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
constructor TMultiCheckBoxes.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  S.Read(SelRange, SizeOf(SelRange));                { Read select range }
  S.Read(Flags, SizeOf(Flags));                      { Read flags }
  States := S.ReadStr;                               { Read strings }
end;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
destructor TMultiCheckBoxes.Done;
begin
  if (States <> nil) then
    DisposeStr(States);        { Dispose strings }
  inherited Done;                                    { Call ancestor }
end;

{--TMultiCheckBoxes---------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB          }
{---------------------------------------------------------------------------}
function TMultiCheckBoxes.DataSize: Sw_Word;
begin
  DataSize := SizeOf(longint);                       { Size to exchange }
end;

{--TMultiCheckBoxes---------------------------------------------------------}
{  MultiMark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB         }
{---------------------------------------------------------------------------}
function TMultiCheckBoxes.MultiMark(Item: Sw_Integer): byte;
begin
  MultiMark := (Value shr (word(Item) * WordRec(Flags).Hi)) and WordRec(Flags).Lo;
  { Return mark state }
end;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.Draw;
const
  Button = ' [ ] ';
begin
  inherited Draw;
  DrawMultiBox(Button, States^);                     { Draw the items }
end;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.Press(Item: Sw_Integer);
var
  CurState: shortint;
begin
  CurState := (Value shr (word(Item) * WordRec(Flags).Hi)) and WordRec(Flags).Lo;
  { Hold current state }
  Dec(CurState);                                     { One down }
  if (CurState >= SelRange) or (CurState < 0) then
    CurState := SelRange - 1;                        { Roll if needed }
  Value := (Value and not (longint(WordRec(Flags).Lo) shl
    (word(Item) * WordRec(Flags).Hi))) or (longint(CurState) shl
    (word(Item) * WordRec(Flags).Hi));               { Calculate value }
  inherited Press(Item);                             { Call ancestor }
end;

{--TMultiCheckBoxes---------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.GetData(var Rec);
begin
  longint(Rec) := Value;                             { Return value }
end;

{--TMultiCheckBoxes---------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.SetData(const Rec);
begin
  Value := longint(Rec);                             { Set value }
  DrawView;                                          { Redraw masked areas }
end;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.Store(var S: TStream);
begin
  TCluster.Store(S);                                 { TCluster store called }
  S.Write(SelRange, SizeOf(SelRange));               { Write select range }
  S.Write(Flags, SizeOf(Flags));                     { Write select flags }
  S.WriteStr(States);                                { Write strings }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TListBox OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

type
  TListBoxRec = packed record
    List: PCollection;                               { List collection ptr }
    Selection: sw_integer;                           { Selected item }
  end;

{--TListBox-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
constructor TListBox.Init(var Bounds: TRect; ANumCols: Sw_Word;
  AScrollBar: PScrollBar);
begin
  inherited Init(Bounds, ANumCols, nil, AScrollBar); { Call ancestor }
  SetRange(0);                                       { Set range to zero }
end;

{--TListBox-----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
constructor TListBox.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  List := PCollection(S.Get);                        { Fetch collection }
end;

{--TListBox-----------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/Os2 - Updated 06Jun98 LdB          }
{---------------------------------------------------------------------------}
function TListBox.DataSize: Sw_Word;
begin
  DataSize := SizeOf(TListBoxRec);                   { Xchg data size }
end;

{--TListBox-----------------------------------------------------------------}
{  GetText -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
function TListBox.GetText(Item: Sw_Integer; MaxLen: Sw_Integer): string;
var
  P: PString;
begin
  GetText := '';                                     { Preset return }
  if (List <> nil) then
  begin                        { A list exists }
    P := PString(List^.At(Item));                    { Get string ptr }
    if (P <> nil) then
      GetText := P^;                { Return string }
  end;
end;

{--TListBox-----------------------------------------------------------------}
{  NewList -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TListBox.NewList(AList: PCollection);
begin
  if (List <> nil) then
    Dispose(List, Done);         { Dispose old list }
  List := AList;                                     { Hold new list }
  if (AList <> nil) then
    SetRange(AList^.Count)      { Set new item range }
  else
    SetRange(0);                                { Set zero range }
  if (Range > 0) then
    FocusItem(0);                  { Focus first item }
  DrawView;                                          { Redraw all view }
end;

{--TListBox-----------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TListBox.GetData(var Rec);
begin
  TListBoxRec(Rec).List := List;                     { Return current list }
  TListBoxRec(Rec).Selection := Focused;             { Return focused item }
end;

{--TListBox-----------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TListBox.SetData(const Rec);
begin
  NewList(TListBoxRec(Rec).List);                    { Hold new list }
  FocusItem(TListBoxRec(Rec).Selection);             { Focus selected item }
  DrawView;                                          { Redraw all view }
end;

{--TListBox-----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TListBox.Store(var S: TStream);
begin
  TListViewer.Store(S);                              { TListViewer store }
  S.Put(List);                                       { Store list to stream }
end;

{****************************************************************************}
{ TListBox.DeleteFocusedItem                                                 }
{****************************************************************************}
procedure TListBox.DeleteFocusedItem;
begin
  DeleteItem(Focused);
end;

{****************************************************************************}
{ TListBox.DeleteItem                                                        }
{****************************************************************************}
procedure TListBox.DeleteItem(Item: Sw_Integer);
begin
  if (List <> nil) and (List^.Count > 0) 
     and ((Item < List^.Count) 
     and (Item > -1)) then
  begin
    if IsSelected(Item) and (Item > 0) then
      FocusItem(Item - 1);
    List^.AtDelete(Item);
    SetRange(List^.Count);
  end;
end;

{****************************************************************************}
{ TListBox.FreeAll                                                           }
{****************************************************************************}
procedure TListBox.FreeAll;
begin
  if (List <> nil) then
  begin
    List^.FreeAll;
    SetRange(List^.Count);
  end;
end;

{****************************************************************************}
{ TListBox.FreeFocusedItem                                                   }
{****************************************************************************}
procedure TListBox.FreeFocusedItem;
begin
  FreeItem(Focused);
end;

{****************************************************************************}
{ TListBox.FreeItem                                                          }
{****************************************************************************}
procedure TListBox.FreeItem(Item: Sw_Integer);
begin
  if (Item > -1) and (Item < Range) then
  begin
    List^.AtFree(Item);
    if (Range > 1) and (Focused >= List^.Count) then
      Dec(Focused);
    SetRange(List^.Count);
  end;
end;

{****************************************************************************}
{ TListBox.SetFocusedItem                                                    }
{****************************************************************************}
procedure TListBox.SetFocusedItem(Item: Pointer);
begin
  FocusItem(List^.IndexOf(Item));
end;

{****************************************************************************}
{ TListBox.GetFocusedItem                                                    }
{****************************************************************************}
function TListBox.GetFocusedItem: Pointer;
begin
  if (List = nil) or (List^.Count = 0) then
    GetFocusedItem := nil
  else
    GetFocusedItem := List^.At(Focused);
end;

{****************************************************************************}
{ TListBox.Insert                                                            }
{****************************************************************************}
procedure TListBox.Insert(Item: Pointer);
begin
  if (List <> nil) then
  begin
    List^.Insert(Item);
    SetRange(List^.Count);
  end;
end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TStaticText OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStaticText--------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TStaticText.Init(var Bounds: TRect; const AText: string);
begin
  inherited Init(Bounds);                            { Call ancestor }
  Text := NewStr(AText);                             { Create string ptr }
end;

{--TStaticText--------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TStaticText.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  Text := S.ReadStr;                                 { Read text string }
end;

{--TStaticText--------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
destructor TStaticText.Done;
begin
  if (Text <> nil) then
    DisposeStr(Text);            { Dispose string }
  inherited Done;                                    { Call ancestor }
end;

{--TStaticText--------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB        }
{---------------------------------------------------------------------------}
function TStaticText.GetPalette: PPalette;
const
  P: string{$ifopt H-}[Length(CStaticText)]{$endif} = CStaticText;   { Always normal string }
begin
  GetPalette := PPalette(@P);                        { Return palette }
end;

{--TStaticText--------------------------------------------------------------}
{  DrawBackGround -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB    }
{---------------------------------------------------------------------------}
procedure TStaticText.Draw;
var
  Just: byte;
  I, J, P, Y, L: Sw_Integer;
  S: string;
  B: TDrawBuffer;
  Color: byte;
begin
  GetText(S);                                        { Fetch text to write }
  Color := GetColor(1);
  P := 1;                                            { X start position }
  Y := 0;                                            { Y start position }
  L := Length(S);                                    { Length of text }
  while (Y < Size.Y) do
  begin
    MoveChar(B, ' ', Color, Size.X);
    if P <= L then
    begin
      Just := 0;                                       { Default left justify }
      if (S[P] = #2) then
      begin                        { Right justify char }
        Just := 2;                                     { Set right justify }
        Inc(P);                                        { Next character }
      end;
      if (S[P] = #3) then
      begin                        { Centre justify char }
        Just := 1;                                     { Set centre justify }
        Inc(P);                                        { Next character }
      end;
      I := P;                                          { Start position }
      repeat
        J := P;
        while (P <= L) and (S[P] = ' ') do
          Inc(P);
        while (P <= L) and (S[P] <> ' ') and (S[P] <> #13) do
          Inc(P);
      until (P > L) or (P >= I + Size.X) or (S[P] = #13);
      if P > I + Size.X then                           { Text to long }
        if J > I then
          P := J
        else
          P := I + Size.X;
      case Just of
        0: J := 0;                           { Left justify }
        1: J := (Size.X - (P - I)) div 2;      { Centre justify }
        2: J := Size.X - (P - I);              { Right justify }
      end;
      MoveBuf(B[J], S[I], Color, P - I);
      while (P <= L) and (P - I <= Size.X) and ((S[P] = #13) or (S[P] = #10)) do
        Inc(P);                                     { Remove CR/LF }
    end;
    WriteLine(0, Y, Size.X, 1, B);
    Inc(Y);                                          { Next line }
  end;
end;

{--TStaticText--------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TStaticText.Store(var S: TStream);
begin
  TView.Store(S);                                    { Call TView store }
  S.WriteStr(Text);                                  { Write text string }
end;

{--TStaticText--------------------------------------------------------------}
{  GetText -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB           }
{---------------------------------------------------------------------------}
procedure TStaticText.GetText(var S: string);
begin
  if (Text <> nil) then
    S := Text^                   { Copy text string }
  else
    S := '';                                    { Return empty string }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TParamText OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TParamText---------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TParamText.Init(var Bounds: TRect; const AText: string;
  AParamCount: Sw_Integer);
begin
  inherited Init(Bounds, AText);                     { Call ancestor }
  ParamCount := AParamCount;                         { Hold param count }
end;

{--TParamText---------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TParamText.Load(var S: TStream);
var
  w: word;
begin
  inherited Load(S);                                 { Call ancestor }
  S.Read(w, SizeOf(w));
  ParamCount := w;               { Read parameter count }
end;

{--TParamText---------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB          }
{---------------------------------------------------------------------------}
function TParamText.DataSize: Sw_Word;
begin
  DataSize := ParamCount * SizeOf(Pointer);          { Return data size }
end;

{--TParamText---------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TParamText.GetData(var Rec);
begin
  Pointer(Rec) := @ParamList;                        { Return parm ptr }
end;

{--TParamText---------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TParamText.SetData(const Rec);
begin
  ParamList := @Rec;                                 { Fetch parameter list }
  DrawView;                                          { Redraw all the view }
end;

{--TParamText---------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TParamText.Store(var S: TStream);
var
  w: word;
begin
  TStaticText.Store(S);                              { Statictext store }
  w := ParamCount;
  S.Write(w, SizeOf(w));           { Store param count }
end;

{--TParamText---------------------------------------------------------------}
{  GetText -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB           }
{---------------------------------------------------------------------------}
procedure TParamText.GetText(var S: string);
begin
  if (Text = nil) then
    S := ''
  else                  { Return empty string }
    FormatStr(S, Text^, ParamList^);                 { Return text string }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TLabel OBJECT METHODS                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TLabel-------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TLabel.Init(var Bounds: TRect; const AText: string; ALink: PView);
begin
  inherited Init(Bounds, AText);                     { Call ancestor }
  Link := ALink;                                     { Hold link }
  Options := Options or (ofPreProcess + ofPostProcess);{ Set pre/post process }
  EventMask := EventMask or evBroadcast;             { Sees broadcast events }
end;

{--TLabel-------------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TLabel.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  GetPeerViewPtr(S, Link);                           { Load link view }
end;

{--TLabel-------------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
function TLabel.GetPalette: PPalette;
const
  P: string{$ifopt H-}[Length(CLabel)]{$endif} = CLabel;             { Always normal string }
begin
  GetPalette := PPalette(@P);                        { Return palette }
end;

{--TLabel-------------------------------------------------------------------}
{  DrawBackGround -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB    }
{---------------------------------------------------------------------------}
procedure TLabel.Draw;
var
  SCOff: byte;
  Color: word;
  B: TDrawBuffer;
begin
  if Light then
  begin                                { Light colour select }
    Color := GetColor($0402);                        { Choose light colour }
    SCOff := 0;                                      { Zero offset }
  end
  else
  begin
    Color := GetColor($0301);                        { Darker colour }
    SCOff := 4;                                      { Set offset }
  end;
  MoveChar(B[0], ' ', byte(Color), Size.X);          { Clear the buffer }
  if (Text <> nil) then
    MoveCStr(B[1], Text^, Color);{ Transfer label text }
  if ShowMarkers then
    WordRec(B[0]).Lo := byte(SpecialChars[SCOff]);
  { Show marker if req }
  WriteLine(0, 0, Size.X, 1, B);                     { Write the text }
end;

{--TLabel-------------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB             }
{---------------------------------------------------------------------------}
procedure TLabel.Store(var S: TStream);
begin
  TStaticText.Store(S);                              { TStaticText.Store }
  PutPeerViewPtr(S, Link);                           { Store link view }
end;

{--TLabel-------------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure TLabel.HandleEvent(var Event: TEvent);
var
  C: char;

  procedure FocusLink;
  begin
    if (Link <> nil) and (Link^.Options and ofSelectable <> 0) then
      Link^.Focus;            { Focus link view }
    ClearEvent(Event);                               { Clear the event }
  end;

begin
  inherited HandleEvent(Event);                      { Call ancestor }
  case Event.What of
    evNothing: Exit;                                 { Speed up exit }
    evMouseDown: FocusLink;                          { Focus link view }
    evKeyDown:
    begin
      if assigned(Text) then
      begin
        C := HotKey(Text^);                            { Check for hotkey }
        if (GetAltCode(C) = Event.KeyCode) or          { Alt plus char }
          ((C <> #0) and (Owner^.Phase = phPostProcess)  { Post process phase }
          and (UpCase(Event.CharCode) = C)) then         { Upper case match }
          FocusLink;                                   { Focus link view }
      end;
    end;
    evBroadcast: if ((Event.Command = cmReceivedFocus) or
        (Event.Command = cmReleasedFocus)) and      { Focus state change }
        (Link <> nil) then
      begin
        Light := Link^.State and sfFocused <> 0;     { Change light state }
        DrawView;                                    { Now redraw change }
      end;
  end;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       THistoryViewer OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--THistoryViewer-----------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor THistoryViewer.Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar;
  AHistoryId: word);
begin
  inherited Init(Bounds, 1, AHScrollBar,
    AVScrollBar);                                    { Call ancestor }
  HistoryId := AHistoryId;                           { Hold history id }
  SetRange(HistoryCount(AHistoryId));                { Set history range }
  if (Range > 1) then
    FocusItem(1);                  { Set to item 1 }
  if (HScrollBar <> nil) then
    HScrollBar^.SetRange(1, HistoryWidth - Size.X + 3);{ Set scrollbar range }
end;

{--THistoryViewer-----------------------------------------------------------}
{  HistoryWidth -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB      }
{---------------------------------------------------------------------------}
function THistoryViewer.HistoryWidth: Sw_Integer;
var
  Width, T, Count, I: Sw_Integer;
begin
  Width := 0;                                        { Zero width variable }
  Count := HistoryCount(HistoryId);                  { Hold count value }
  for I := 0 to Count - 1 do
  begin                     { For each item }
    T := Length(HistoryStr(HistoryId, I));           { Get width of item }
    if (T > Width) then
      Width := T;                  { Set width to max }
  end;
  HistoryWidth := Width;                             { Return max item width }
end;

{--THistoryViewer-----------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
function THistoryViewer.GetPalette: PPalette;
const
  P: string{$ifopt H-}[Length(CHistoryViewer)]{$endif} = CHistoryViewer;{ Always normal string }
begin
  GetPalette := PPalette(@P);                           { Return palette }
end;

{--THistoryViewer-----------------------------------------------------------}
{  GetText -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB           }
{---------------------------------------------------------------------------}
function THistoryViewer.GetText(Item: Sw_Integer; MaxLen: Sw_Integer): string;
begin
  GetText := HistoryStr(HistoryId, Item);            { Return history string }
end;

{--THistoryViewer-----------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure THistoryViewer.HandleEvent(var Event: TEvent);
begin
  if ((Event.What = evMouseDown) and (Event.double)) { Double click mouse } or
    ((Event.What = evKeyDown) and (Event.KeyCode = kbEnter)) then
  begin              { Enter key press }
    EndModal(cmOk);                                  { End with cmOk }
    ClearEvent(Event);                               { Event was handled }
  end
  else if ((Event.What = evKeyDown) and (Event.KeyCode = kbEsc)) or
    { Esc key press }
    ((Event.What = evCommand) and (Event.Command = cmCancel)) then
  begin             { Cancel command }
    EndModal(cmCancel);                              { End with cmCancel }
    ClearEvent(Event);                               { Event was handled }
  end
  else
    inherited HandleEvent(Event);             { Call ancestor }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       THistoryWindow OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--THistoryWindow-----------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor THistoryWindow.Init(var Bounds: TRect; HistoryId: word);
begin
  inherited Init(Bounds, '', wnNoNumber);            { Call ancestor }
  Flags := wfClose;                                  { Close flag only }
  InitViewer(HistoryId);                             { Create list view }
end;

{--THistoryWindow-----------------------------------------------------------}
{  GetSelection -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB      }
{---------------------------------------------------------------------------}
function THistoryWindow.GetSelection: string;
begin
  if (Viewer = nil) then
    GetSelection := ''
  else     { Return empty string }
    GetSelection := Viewer^.GetText(Viewer^.Focused, 255);
  { Get focused string }
end;

{--THistoryWindow-----------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
function THistoryWindow.GetPalette: PPalette;
const
  P: string{$ifopt H-}[Length(CHistoryWindow)]{$endif} = CHistoryWindow;{ Always normal string }
begin
  GetPalette := PPalette(@P);                           { Return the palette }
end;

{--THistoryWindow-----------------------------------------------------------}
{  InitViewer -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
procedure THistoryWindow.InitViewer(HistoryId: word);
var
  R: TRect;
begin
  GetExtent(R);                                      { Get extents }
  R.Grow(-1, -1);                                     { Grow inside }
  Viewer := New(PHistoryViewer,
    Init(R, StandardScrollBar(sbHorizontal + sbHandleKeyboard),
    StandardScrollBar(sbVertical + sbHandleKeyboard), HistoryId));
  { Create the viewer }
  if (Viewer <> nil) then
    Insert(Viewer);            { Insert viewer }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          THistory OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--THistory-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor THistory.Init(var Bounds: TRect; ALink: PInputLine; AHistoryId: word);
begin
  inherited Init(Bounds);                            { Call ancestor }
  Options := Options or ofPostProcess;               { Set post process }
  EventMask := EventMask or evBroadcast;             { See broadcast events }
  Link := ALink;                                     { Hold link view }
  HistoryId := AHistoryId;                           { Hold history id }
end;

{--THistory-----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor THistory.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  GetPeerViewPtr(S, Link);                           { Load link view }
  S.Read(HistoryId, SizeOf(HistoryId));              { Read history id }
end;

{--THistory-----------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
function THistory.GetPalette: PPalette;
const
  P: string{$ifopt H-}[Length(CHistory)]{$endif} = CHistory;         { Always normal string }
begin
  GetPalette := PPalette(@P);                        { Return the palette }
end;

{--THistory-----------------------------------------------------------------}
{  InitHistoryWindow -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB }
{---------------------------------------------------------------------------}
function THistory.InitHistoryWindow(var Bounds: TRect): PHistoryWindow;
var
  P: PHistoryWindow;
begin
  P := New(PHistoryWindow, Init(Bounds, HistoryId)); { Create history window }
  if (Link <> nil) then
    P^.HelpCtx := Link^.HelpCtx;                     { Set help context }
  InitHistoryWindow := P;                            { Return history window }
end;

procedure THistory.Draw;
var
  B: TDrawBuffer;
begin
  MoveCStr(B, #222'~v~'#221, GetColor($0102));   { Set buffer data }
  WriteLine(0, 0, Size.X, Size.Y, B);                { Write buffer }
end;

{--THistory-----------------------------------------------------------------}
{  RecordHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB     }
{---------------------------------------------------------------------------}
procedure THistory.RecordHistory(const S: string);
begin
  HistoryAdd(HistoryId, S);                          { Add to history }
end;

{--THistory-----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB             }
{---------------------------------------------------------------------------}
procedure THistory.Store(var S: TStream);
begin
  TView.Store(S);                                    { TView.Store called }
  PutPeerViewPtr(S, Link);                           { Store link view }
  S.Write(HistoryId, SizeOf(HistoryId));             { Store history id }
end;

{--THistory-----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure THistory.HandleEvent(var Event: TEvent);
var
  C: word;
  Rslt: string;
  R, P: TRect;
  HistoryWindow: PHistoryWindow;
begin
  inherited HandleEvent(Event);                      { Call ancestor }
  if (Link = nil) then
    Exit;                         { No link view exits }
  if (Event.What = evMouseDown) or                   { Mouse down event }
    ((Event.What = evKeyDown) and (CtrlToArrow(Event.KeyCode) = kbDown) and
    { Down arrow key }
    (Link^.State and sfFocused <> 0)) then
  begin      { Link view selected }
    if not Link^.Focus then
    begin
      ClearEvent(Event);                             { Event was handled }
      Exit;                                          { Now exit }
    end;
    RecordHistory(Link^.Data^);                      { Record current data }
    Link^.GetBounds(R);                              { Get view bounds }
    Dec(R.A.X);                                      { One char in from us }
    Inc(R.B.X);                                      { One char short of us }
    Inc(R.B.Y, 7);                                   { Seven lines down }
    Dec(R.A.Y, 1);                                    { One line below us }
    Owner^.GetExtent(P);                             { Get owner extents }
    R.Intersect(P);                                  { Intersect views }
    Dec(R.B.Y, 1);                                    { Shorten length by one }
    HistoryWindow := InitHistoryWindow(R);           { Create history window }
    if (HistoryWindow <> nil) then
    begin             { Window crested okay }
      C := Owner^.ExecView(HistoryWindow);           { Execute this window }
      if (C = cmOk) then
      begin                       { Result was okay }
        Rslt := HistoryWindow^.GetSelection;         { Get history selection }
        if Length(Rslt) > Link^.MaxLen then
          SetLength(Rslt, Link^.MaxLen);            { Hold new length }
        Link^.Data^ := Rslt;                         { Hold new selection }
        Link^.SelectAll(True);                       { Select all string }
        Link^.DrawView;                              { Redraw link view }
      end;
      Dispose(HistoryWindow, Done);                  { Dispose of window }
    end;
    ClearEvent(Event);                               { Event was handled }
  end
  else if (Event.What = evBroadcast) then        { Broadcast event }
    if ((Event.Command = cmReleasedFocus) and (Event.InfoPtr = Link)) or
      (Event.Command = cmRecordHistory) then           { Record command }
      RecordHistory(Link^.Data^);                    { Record the history }
end;

{****************************************************************************}
{ TBrowseButton Object                                                       }
{****************************************************************************}
{****************************************************************************}
{ TBrowseButton.Init                                                         }
{****************************************************************************}
constructor TBrowseButton.Init(var Bounds: TRect; ATitle: TTitleStr;
  ACommand: word; AFlags: byte; ALink: PBrowseInputLine);
begin
  if not inherited Init(Bounds, ATitle, ACommand, AFlags) then
    Fail;
  Link := ALink;
end;

{****************************************************************************}
{ TBrowseButton.Load                                                         }
{****************************************************************************}
constructor TBrowseButton.Load(var S: TStream);
begin
  if not inherited Load(S) then
    Fail;
  GetPeerViewPtr(S, Link);
end;

{****************************************************************************}
{ TBrowseButton.Press                                                        }
{****************************************************************************}
procedure TBrowseButton.Press;
var
  E: TEvent;
begin
  Message(Owner, evBroadcast, cmRecordHistory, nil);
  if Flags and bfBroadcast <> 0 then
    Message(Owner, evBroadcast, Command, Link)
  else
  begin
    E.What := evCommand;
    E.Command := Command;
    E.InfoPtr := Link;
    PutEvent(E);
  end;
end;

{****************************************************************************}
{ TBrowseButton.Store                                                        }
{****************************************************************************}
procedure TBrowseButton.Store(var S: TStream);
begin
  inherited Store(S);
  PutPeerViewPtr(S, Link);
end;


{****************************************************************************}
{ TBrowseInputLine Object                                                    }
{****************************************************************************}
{****************************************************************************}
{ TBrowseInputLine.Init                                                      }
{****************************************************************************}
constructor TBrowseInputLine.Init(var Bounds: TRect; AMaxLen: Sw_Integer;
  AHistory: Sw_Word);
begin
  if not inherited Init(Bounds, AMaxLen) then
    Fail;
  History := AHistory;
end;

{****************************************************************************}
{ TBrowseInputLine.Load                                                      }
{****************************************************************************}
constructor TBrowseInputLine.Load(var S: TStream);
begin
  if not inherited Load(S) then
    Fail;
  S.Read(History, SizeOf(History));
  if (S.Status <> stOk) then
    Fail;
end;

{****************************************************************************}
{ TBrowseInputLine.DataSize                                                  }
{****************************************************************************}
function TBrowseInputLine.DataSize: Sw_Word;
begin
  DataSize := SizeOf(TBrowseInputLineRec);
end;

{****************************************************************************}
{ TBrowseInputLine.GetData                                                   }
{****************************************************************************}
procedure TBrowseInputLine.GetData(var Rec);
var
  LocalRec: TBrowseInputLineRec absolute Rec;
begin
  if (Validator = nil) or (Validator^.Transfer(Data^, @LocalRec.Text,
    vtGetData) = 0) then
  begin
    FillChar(LocalRec.Text, DataSize, #0);
    Move(Data^, LocalRec.Text, Length(Data^) + 1);
  end;
  LocalRec.History := History;
end;

{****************************************************************************}
{ TBrowseInputLine.SetData                                                   }
{****************************************************************************}
procedure TBrowseInputLine.SetData(const Rec);
var
  LocalRec: TBrowseInputLineRec absolute Rec;
begin
  if (Validator = nil) or (Validator^.Transfer(Data^, @LocalRec.Text,
    vtSetData) = 0) then
  begin
    setlength(Data^, MaxLen + 1);
    Move(LocalRec.Text, Data^[1], MaxLen + 1);
  end;
  History := LocalRec.History;
  SelectAll(True);
end;

{****************************************************************************}
{ TBrowseInputLine.Store                                                     }
{****************************************************************************}
procedure TBrowseInputLine.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(History, SizeOf(History));
end;


{****************************************************************************}
{ TCommandCheckBoxes Object                                                  }
{****************************************************************************}
{****************************************************************************}
{ TCommandCheckBoxes.Init                                                    }
{****************************************************************************}
constructor TCommandCheckBoxes.Init(var Bounds: TRect;
  ACommandStrings: PCommandSItem);
var
  StartSItem, S: PSItem;
  CItems: PCommandSItem;
  i: Sw_Integer;
begin
  if ACommandStrings = nil then
    Fail;
  { set up string list }
  StartSItem := NewSItem(ACommandStrings^.Value, nil);
  S := StartSItem;
  CItems := ACommandStrings^.Next;
  while (CItems <> nil) do
  begin
    S^.Next := NewSItem(CItems^.Value, nil);
    S := S^.Next;
    CItems := CItems^.Next;
  end;
  { construct check boxes }
  if not TCheckBoxes.Init(Bounds, StartSItem) then
  begin
    while (StartSItem <> nil) do
    begin
      S := StartSItem;
      StartSItem := StartSItem^.Next;
      if (S^.Value <> nil) then
        DisposeStr(S^.Value);
      Dispose(S);
    end;
    Fail;
  end;
  { set up CommandList and dispose of memory used by ACommandList }
  i := 0;
  while (ACommandStrings <> nil) do
  begin
    CommandList[i] := ACommandStrings^.Command;
    CItems := ACommandStrings;
    ACommandStrings := ACommandStrings^.Next;
    Dispose(CItems);
    Inc(i);
  end;
end;

{****************************************************************************}
{ TCommandCheckBoxes.Load                                                    }
{****************************************************************************}
constructor TCommandCheckBoxes.Load(var S: TStream);
begin
  if not TCheckBoxes.Load(S) then
    Fail;
  S.Read(CommandList, SizeOf(CommandList));
  if (S.Status <> stOk) then
  begin
    TCheckBoxes.Done;
    Fail;
  end;
end;

{****************************************************************************}
{ TCommandCheckBoxes.Press                                                   }
{****************************************************************************}
procedure TCommandCheckBoxes.Press(Item: Sw_Integer);
var
  Temp: Sw_Integer;
begin
  Temp := Value;
  TCheckBoxes.Press(Item);
  if (Value <> Temp) then  { value changed - notify peers }
    Message(Owner, evCommand, CommandList[Item], @Value);
end;

{****************************************************************************}
{ TCommandCheckBoxes.Store                                                   }
{****************************************************************************}
procedure TCommandCheckBoxes.Store(var S: TStream);
begin
  TCheckBoxes.Store(S);
  S.Write(CommandList, SizeOf(CommandList));
end;

{****************************************************************************}
{ TCommandIcon Object                                                        }
{****************************************************************************}
{****************************************************************************}
{ TCommandIcon.Init                                                          }
{****************************************************************************}
constructor TCommandIcon.Init(var Bounds: TRect; AText: string;
  ACommand: word);
begin
  if not TStaticText.Init(Bounds, AText) then
    Fail;
  Options := Options or ofPostProcess;
  Command := ACommand;
end;

{****************************************************************************}
{ TCommandIcon.HandleEvent                                                   }
{****************************************************************************}
procedure TCommandIcon.HandleEvent(var Event: TEvent);
begin
  if ((Event.What = evMouseDown) and MouseInView(MouseWhere)) then
  begin
    ClearEvent(Event);
    Message(Owner, evCommand, Command, nil);
  end;
  TStaticText.HandleEvent(Event);
end;

{****************************************************************************}
{ TCommandInputLine Object                                                   }
{****************************************************************************}
{****************************************************************************}
{ TCommandInputLine.Changed                                                  }
{****************************************************************************}
{procedure TCommandInputLine.Changed;
begin
  Message(Owner,evBroadcast,cmInputLineChanged,@Self);
end;  }

{****************************************************************************}
{ TCommandInputLine.HandleEvent                                              }
{****************************************************************************}
{procedure TCommandInputLine.HandleEvent (var Event : TEvent);
var E : TEvent;
begin
  E := Event;
  TBSDInputLine.HandleEvent(Event);
  if ((E.What and evKeyBoard = evKeyBoard) and (Event.KeyCode = kbEnter))
     then Changed;
end; }

{****************************************************************************}
{ TCommandRadioButtons Object                                                }
{****************************************************************************}

{****************************************************************************}
{ TCommandRadioButtons.Init                                                  }
{****************************************************************************}
constructor TCommandRadioButtons.Init(var Bounds: TRect;
  ACommandStrings: PCommandSItem);
var
  StartSItem, S: PSItem;
  CItems: PCommandSItem;
  i: Sw_Integer;
begin
  if ACommandStrings = nil then
    Fail;
  { set up string list }
  StartSItem := NewSItem(ACommandStrings^.Value, nil);
  S := StartSItem;
  CItems := ACommandStrings^.Next;
  while (CItems <> nil) do
  begin
    S^.Next := NewSItem(CItems^.Value, nil);
    S := S^.Next;
    CItems := CItems^.Next;
  end;
  { construct check boxes }
  if not TRadioButtons.Init(Bounds, StartSItem) then
  begin
    while (StartSItem <> nil) do
    begin
      S := StartSItem;
      StartSItem := StartSItem^.Next;
      if (S^.Value <> nil) then
        DisposeStr(S^.Value);
      Dispose(S);
    end;
    Fail;
  end;
  { set up command list }
  i := 0;
  while (ACommandStrings <> nil) do
  begin
    CommandList[i] := ACommandStrings^.Command;
    CItems := ACommandStrings;
    ACommandStrings := ACommandStrings^.Next;
    Dispose(CItems);
    Inc(i);
  end;
end;

{****************************************************************************}
{ TCommandRadioButtons.Load                                                  }
{****************************************************************************}
constructor TCommandRadioButtons.Load(var S: TStream);
begin
  if not TRadioButtons.Load(S) then
    Fail;
  S.Read(CommandList, SizeOf(CommandList));
  if (S.Status <> stOk) then
  begin
    TRadioButtons.Done;
    Fail;
  end;
end;

{****************************************************************************}
{ TCommandRadioButtons.MoveTo                                                }
{****************************************************************************}
procedure TCommandRadioButtons.MovedTo(Item: Sw_Integer);
var
  Temp: Sw_Integer;
begin
  Temp := Value;
  TRadioButtons.MovedTo(Item);
  if (Value <> Temp) then  { value changed - notify peers }
    Message(Owner, evCommand, CommandList[Item], @Value);
end;

{****************************************************************************}
{ TCommandRadioButtons.Press                                                 }
{****************************************************************************}
procedure TCommandRadioButtons.Press(Item: Sw_Integer);
var
  Temp: Sw_Integer;
begin
  Temp := Value;
  TRadioButtons.Press(Item);
  if (Value <> Temp) then  { value changed - notify peers }
    Message(Owner, evCommand, CommandList[Item], @Value);
end;

{****************************************************************************}
{ TCommandRadioButtons.Store                                                 }
{****************************************************************************}
procedure TCommandRadioButtons.Store(var S: TStream);
begin
  TRadioButtons.Store(S);
  S.Write(CommandList, SizeOf(CommandList));
end;

{****************************************************************************}
{ TEditListBox Object                                                        }
{****************************************************************************}
{****************************************************************************}
{ TEditListBox.Init                                                          }
{****************************************************************************}
constructor TEditListBox.Init(Bounds: TRect; ANumCols: word;
  AVScrollBar: PScrollBar);

begin
  if not inherited Init(Bounds, ANumCols, AVScrollBar) then
    Fail;
  CurrentField := 1;
end;

{****************************************************************************}
{ TEditListBox.Load                                                          }
{****************************************************************************}
constructor TEditListBox.Load(var S: TStream);
begin
  if not inherited Load(S) then
    Fail;
  CurrentField := 1;
end;

{****************************************************************************}
{ TEditListBox.EditField                                                     }
{****************************************************************************}
procedure TEditListBox.EditField(var Event: TEvent);
var
  R: TRect;
  InputLine: PModalInputLine;
begin
  R.Assign(StartColumn, (Origin.Y + Focused - TopItem),
    (StartColumn + FieldWidth + 2), (Origin.Y + Focused - TopItem + 1));
  Owner^.MakeGlobal(R.A, R.A);
  Owner^.MakeGlobal(R.B, R.B);
  InputLine := New(PModalInputLine, Init(R, FieldWidth));
  InputLine^.SetValidator(FieldValidator);
  if InputLine <> nil then
  begin
    { Use TInputLine^.SetData so that data validation occurs }
    { because TInputLine.Data is allocated memory large enough  }
    { to hold a string of MaxLen.  It is also faster.           }
    GetField(InputLine);
    if (Application^.ExecView(InputLine) = cmOk) then
      SetField(InputLine);
    Dispose(InputLine, done);
  end;
end;

{****************************************************************************}
{ TEditListBox.FieldValidator                                                }
{****************************************************************************}
function TEditListBox.FieldValidator: PValidator;
  { In a multiple field listbox FieldWidth should return the width  }
  { appropriate for Field.  The default is an inputline for editing }
  { a string of length large enough to fill the listbox field.      }
begin
  FieldValidator := nil;
end;

{****************************************************************************}
{ TEditListBox.FieldWidth                                                    }
{****************************************************************************}
function TEditListBox.FieldWidth: integer;
  { In a multiple field listbox FieldWidth should return the width }
  { appropriate for CurrentField.                                  }
begin
  FieldWidth := Size.X - 2;
end;

{****************************************************************************}
{ TEditListBox.GetField                                                      }
{****************************************************************************}
procedure TEditListBox.GetField(InputLine: PInputLine);
{ Places a string appropriate to Field and Focused into InputLine that }
{ will be edited.   Override this method for complex data types.       }
begin
  InputLine^.SetData(PString(List^.At(Focused))^);
end;

{****************************************************************************}
{ TEditListBox.GetPalette                                                    }
{****************************************************************************}
function TEditListBox.GetPalette: PPalette;
begin
  GetPalette := inherited GetPalette;
end;

{****************************************************************************}
{ TEditListBox.HandleEvent                                                   }
{****************************************************************************}
procedure TEditListBox.HandleEvent(var Event: TEvent);
begin
  if (Event.What = evKeyboard) and (Event.KeyCode = kbAltE) then
  begin  { edit field }
    EditField(Event);
    DrawView;
    ClearEvent(Event);
  end;
  inherited HandleEvent(Event);
end;

{****************************************************************************}
{ TEditListBox.SetField                                                      }
{****************************************************************************}
procedure TEditListBox.SetField(InputLine: PInputLine);
{ Override this method for field types other than PStrings. }
var
  Item: PString;
begin
  Item := NewStr(InputLine^.Data^);
  if Item <> nil then
  begin
    List^.AtFree(Focused);
    List^.Insert(Item);
    SetFocusedItem(Item);
  end;
end;

{****************************************************************************}
{ TEditListBox.StartColumn                                                   }
{****************************************************************************}
function TEditListBox.StartColumn: integer;
begin
  StartColumn := Origin.X;
end;

{****************************************************************************}
{ TListDlg Object                                                            }
{****************************************************************************}
{****************************************************************************}
{ TListDlg.Init                                                              }
{****************************************************************************}
constructor TListDlg.Init(ATitle: TTitleStr; Items: string;
  AButtons: word; AListBox: PListBox; AEditCommand, ANewCommand: word);
var
  Bounds: TRect;
  b: byte;
  ButtonCount: byte;
  i, j, Gap, Line: integer;
  Scrollbar: PScrollbar;
  HasFrame: boolean;
  HasButtons: boolean;
  HasScrollBar: boolean;
  HasItems: boolean;
begin
  if AListBox = nil then
    Fail
  else
    ListBox := AListBox;
  HasFrame := ((AButtons and ldNoFrame) = 0);
  HasButtons := ((AButtons and ldAllButtons) <> 0);
  HasScrollBar := ((AButtons and ldNoScrollBar) = 0);
  HasItems := (Items <> '');
  ButtonCount := 2;
  for b := 0 to 3 do
    if (AButtons and ($0001 shl 1)) <> 0 then
      Inc(ButtonCount);
  { Make sure dialog is large enough for buttons }
  ListBox^.GetExtent(Bounds);
  Bounds.Move(ListBox^.Origin.X, ListBox^.Origin.Y);
  if HasFrame then
  begin
    Inc(Bounds.B.X, 2);
    Inc(Bounds.B.Y, 2);
  end;
  if HasButtons then
  begin
    Inc(Bounds.B.X, 14);
    if Bounds.B.Y < (ButtonCount * 2) + 4 then
      Bounds.B.Y := (ButtonCount * 2) + 5;
  end;
  if HasItems then
    Inc(Bounds.B.Y, 1);
  if not TDialog.Init(Bounds, ATitle) then
    Fail;
  NewCommand := ANewCommand;
  EditCommand := AEditCommand;
  Options := Options or ofNewEditDelete;
  if (not HasFrame) and (Frame <> nil) then
  begin
    Delete(Frame);
    Dispose(Frame, Done);
    Frame := nil;
    Options := Options and not ofFramed;
  end;
  HelpCtx := hcListDlg;
  { position and insert ListBox }
  ListBox := AListBox;
  Insert(ListBox);
  if HasItems then
    if HasFrame then
      ListBox^.MoveTo(2, 2)
    else
      ListBox^.MoveTo(0, 2)
  else
  if HasFrame then
    ListBox^.MoveTo(1, 1)
  else
    ListBox^.MoveTo(0, 0);
  if HasButtons then
    if ListBox^.Size.Y < (ButtonCount * 2) then
      ListBox^.GrowTo(ListBox^.Size.X, ButtonCount * 2);
  { do Items }
  if HasItems then
  begin
    Bounds.Assign(1, 1, CStrLen(Items) + 2, 2);
    Insert(New(PLabel, Init(Bounds, Items, ListBox)));
  end;
  { do scrollbar }
  if HasScrollBar then
  begin
    Bounds.Assign(ListBox^.Size.X + ListBox^.Origin.X, ListBox^.Origin.Y,
      ListBox^.Size.X + ListBox^.Origin.X + 1,
      ListBox^.Size.Y + ListBox^.Origin.Y { origin });
    ScrollBar := New(PScrollBar, Init(Bounds));
    Bounds.Assign(Origin.X, Origin.Y, Origin.X + Size.X + 1, Origin.Y + Size.Y);
    ChangeBounds(Bounds);
    Insert(Scrollbar);
  end;
  if HasButtons then
  begin  { do buttons }
    j := $0001;
    Gap := 0;
    for i := 0 to 3 do
      if ((j shl i) and AButtons) <> 0 then
        Inc(Gap);
    Gap := ((Size.Y - 2) div (Gap + 2));
    if Gap < 2 then
      Gap := 2;
    { Insert Buttons }
    Line := 2;
    if (AButtons and ldNew) = ldNew then
    begin
      Insert(NewButton(Size.X - 12, Line, 10, 2, '~N~ew', cmNew, hcInsert, bfNormal));
      Inc(Line, Gap);
    end;
    if (AButtons and ldEdit) = ldEdit then
    begin
      Insert(NewButton(Size.X - 12, Line, 10, 2, '~E~dit', cmEdit, hcEdit, bfNormal));
      Inc(Line, Gap);
    end;
    if (AButtons and ldDelete) = ldDelete then
    begin
      Insert(NewButton(Size.X - 12, Line, 10, 2, '~D~elete', cmDelete, hcDelete,
        bfNormal));
      Inc(Line, Gap);
    end;
    Insert(NewButton(Size.X - 12, Line, 10, 2, 'O~k~', cmOK, hcOk, bfDefault or bfNormal));
    Inc(Line, Gap);
    Insert(NewButton(Size.X - 12, Line, 10, 2, 'Cancel', cmCancel, hcCancel, bfNormal));
    if (AButtons and ldHelp) = ldHelp then
    begin
      Inc(Line, Gap);
      Insert(NewButton(Size.X - 12, Line, 10, 2, '~H~elp', cmHelp, hcNoContext,
        bfNormal));
    end;
  end;
  if HasFrame and ((AButtons and ldAllIcons) <> 0) then
  begin
    Line := 2;
    if (AButtons and ldNewIcon) = ldNewIcon then
    begin
      Bounds.Assign(Line, Size.Y - 1, Line + 5, Size.Y);
      Insert(New(PCommandIcon, Init(Bounds, ' Ins ', cmNew)));
      Inc(Line, 5);
      if (AButtons and (ldEditIcon or ldDeleteIcon)) <> 0 then
      begin
        Bounds.Assign(Line, Size.Y - 1, Line + 1, Size.Y);
        Insert(New(PStaticText, Init(Bounds, '/')));
        Inc(Line, 1);
      end;
    end;
    if (AButtons and ldEditIcon) = ldEditIcon then
    begin
      Bounds.Assign(Line, Size.Y - 1, Line + 6, Size.Y);
      Insert(New(PCommandIcon, Init(Bounds, ' Edit ', cmEdit)));
      Inc(Line, 6);
      if (AButtons and ldDeleteIcon) <> 0 then
      begin
        Bounds.Assign(Line, Size.Y - 1, Line + 1, Size.Y);
        Insert(New(PStaticText, Init(Bounds, '/')));
        Inc(Line, 1);
      end;
    end;
    if (AButtons and ldNewIcon) = ldNewIcon then
    begin
      Bounds.Assign(Line, Size.Y - 1, Line + 5, Size.Y);
      Insert(New(PCommandIcon, Init(Bounds, ' Del ', cmDelete)));
    end;
  end;
  { Set focus to list boLine when dialog opens }
  SelectNext(False);
end;

{****************************************************************************}
{ TListDlg.Load                                                              }
{****************************************************************************}
constructor TListDlg.Load(var S: TStream);
begin
  if not TDialog.Load(S) then
    Fail;
  S.Read(NewCommand, SizeOf(NewCommand));
  S.Read(EditCommand, SizeOf(EditCommand));
  GetSubViewPtr(S, ListBox);
end;

{****************************************************************************}
{ TListDlg.HandleEvent                                                       }
{****************************************************************************}
procedure TListDlg.HandleEvent(var Event: TEvent);
const
  TargetCommands: TCommandSet = [cmNew, cmEdit, cmDelete];
begin
  if ((Event.What and evCommand) <> 0) and (Event.Command in TargetCommands) then
    case Event.Command of
      cmDelete:
        if Options and ofDelete = ofDelete then
        begin
          ListBox^.FreeFocusedItem;
          ListBox^.DrawView;
          ClearEvent(Event);
        end;
      cmNew:
        if Options and ofNew = ofNew then
        begin
          Message(Application, evCommand, NewCommand, nil);
          ListBox^.SetRange(ListBox^.List^.Count);
          ListBox^.DrawView;
          ClearEvent(Event);
        end;
      cmEdit:
        if Options and ofEdit = ofEdit then
        begin
          Message(Application, evCommand, EditCommand, ListBox^.GetFocusedItem);
          ListBox^.DrawView;
          ClearEvent(Event);
        end;
    end;
  if (Event.What and evBroadcast > 0) and (Event.Command = cmListItemSelected) then
  begin  { use PutEvent instead of Message so that a window list box works }
    Event.What := evCommand;
    Event.Command := cmOk;
    Event.InfoPtr := nil;
    PutEvent(Event);
  end;
  TDialog.HandleEvent(Event);
end;

{****************************************************************************}
{ TListDlg.Store                                                             }
{****************************************************************************}
procedure TListDlg.Store(var S: TStream);
begin
  TDialog.Store(S);
  S.Write(NewCommand, SizeOf(NewCommand));
  S.Write(EditCommand, SizeOf(EditCommand));
  PutSubViewPtr(S, ListBox);
end;

{****************************************************************************}
{ TModalInputLine Object                                                     }
{****************************************************************************}
{****************************************************************************}
{ TModalInputLine.Execute                                                    }
{****************************************************************************}
function TModalInputLine.Execute: word;
var
  Event: TEvent;
begin
  repeat
    EndState := 0;
    repeat
      GetEvent(Event);
      HandleEvent(Event);
      if Event.What <> evNothing then
        Owner^.EventError(Event);  { may change this to ClearEvent }
    until (EndState <> 0);
  until Valid(EndState);
  Execute := EndState;
end;

{****************************************************************************}
{ TModalInputLine.HandleEvent                                                }
{****************************************************************************}
procedure TModalInputLine.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evKeyboard: case Event.KeyCode of
        kbUp, kbDown: EndModal(cmCancel);
        kbEnter: EndModal(cmOk);
        else
          inherited HandleEvent(Event);
      end;
    evMouse: if MouseInView(Event.Where) then
        inherited HandleEvent(Event)
      else
        EndModal(cmCancel);
    else
      inherited HandleEvent(Event);
  end;
end;

{****************************************************************************}
{ TModalInputLine.SetState                                                   }
{****************************************************************************}
procedure TModalInputLine.SetState(AState: word; Enable: boolean);
var
  Pos: integer;
begin
  if (AState = sfSelected) then
  begin
    Pos := CurPos;
    inherited SetState(AState, Enable);
    CurPos := Pos;
    SelStart := CurPos;
    SelEnd := CurPos;
    BlockCursor;
    DrawView;
  end
  else
    inherited SetState(AState, Enable);
end;


{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           ITEM STRING ROUTINES                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  NewSItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB          }
{---------------------------------------------------------------------------}
function NewSItem(const Str: string; ANext: PSItem): PSItem;
var
  Item: PSItem;
begin
  New(Item);                                         { Allocate item }
  Item^.Value := NewStr(Str);                        { Hold item string }
  Item^.Next := ANext;                               { Chain the ptr }
  NewSItem := Item;                                  { Return item }
end;

{****************************************************************************}
{ NewCommandSItem                                                            }
{****************************************************************************}
function NewCommandSItem(Str: string; ACommand: word;
  ANext: PCommandSItem): PCommandSItem;
var
  Temp: PCommandSItem;
begin
  New(Temp);
  if (Temp <> nil) then
  begin
    Temp^.Value := Str;
    Temp^.Command := ACommand;
    Temp^.Next := ANext;
  end;
  NewCommandSItem := Temp;
end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                    DIALOG OBJECT REGISTRATION ROUTINES                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  RegisterDialogs -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB   }
{---------------------------------------------------------------------------}
procedure RegisterDialogs;
begin
  RegisterType(RDialog);                             { Register dialog }
  RegisterType(RInputLine);                          { Register inputline }
  RegisterType(RButton);                             { Register button }
  RegisterType(RCluster);                            { Register cluster }
  RegisterType(RRadioButtons);                       { Register radiobutton }
  RegisterType(RCheckBoxes);                         { Register check boxes }
  RegisterType(RMultiCheckBoxes);                    { Register multi boxes }
  RegisterType(RListBox);                            { Register list box }
  RegisterType(RStaticText);                         { Register static text }
  RegisterType(RLabel);                              { Register label }
  RegisterType(RHistory);                            { Register history }
  RegisterType(RParamText);                          { Register parm text }
  RegisterType(RCommandCheckBoxes);
  RegisterType(RCommandIcon);
  RegisterType(RCommandRadioButtons);
  RegisterType(REditListBox);
  RegisterType(RModalInputLine);
  RegisterType(RListDlg);
end;

end.
