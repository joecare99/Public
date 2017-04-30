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

UNIT fv2dialogs;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                  INTERFACE
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}


{$X+} { Extended syntax is ok }
{ $R-} { Disable range checking }
{ $S-} { Disable Stack Checking }
{ $I-} { Disable IO Checking }
{ $Q-} { Disable Overflow Checking }
{ $V-} { Turn off strict VAR strings }
{====================================================================}

USES
   classes, sysutils,
   {$IFDEF OS_WINDOWS}                                { WIN/NT CODE }
//       Windows,                                       { Standard units }
   {$ENDIF}

   {$IFDEF OS_OS2}                                    { OS2 CODE }
     OS2Def, DosCalls, PMWIN,                       { Standard units }
   {$ENDIF}

   FV2Common, FV2Consts, fv2Drivers, fv2Views, fv2Validate;         { Standard GFV units }

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                        COLOUR PALETTE DEFINITIONS                         }
{---------------------------------------------------------------------------}
CONST
   CGrayDialog    = #32#33#34#35#36#37#38#39#40#41#42#43#44#45#46#47 +
                    #48#49#50#51#52#53#54#55#56#57#58#59#60#61#62#63;
   CBlueDialog    = #64#65#66#67#68#69#70#71#72#73#74#75#76#77#78#79 +
                    #80#81#82#83#84#85#86#87#88#89#90#91#92#92#94#95;
   CCyanDialog    = #96#97#98#99#100#101#102#103#104#105#106#107#108 +
                    #109#110#111#112#113#114#115#116#117#118#119#120 +
                    #121#122#123#124#125#126#127;
   CStaticText    = #6#7#8#9;
   CLabel         = #7#8#9#9;
   CButton        = #10#11#12#13#14#14#14#15;
   CCluster       = #16#17#18#18#31#6;
   CInputLine     = #19#19#20#21#14;
   CHistory       = #22#23;
   CHistoryWindow = #19#19#21#24#25#19#20;
   CHistoryViewer = #6#6#7#6#6;

   CDialog = CGrayDialog;                             { Default palette }

const
    { ldXXXX constants  }
  ldNone        = $0000;
  ldNew         = $0001;
  ldEdit        = $0002;
  ldDelete      = $0004;
  ldNewEditDelete = ldNew or ldEdit or ldDelete;
  ldHelp        = $0008;
  ldAllButtons  = ldNew or ldEdit or ldDelete or ldHelp;
  ldNewIcon     = $0010;
  ldEditIcon    = $0020;
  ldDeleteIcon  = $0040;
  ldAllIcons    = ldNewIcon or ldEditIcon or ldDeleteIcon;
  ldAll         = ldAllIcons or ldAllButtons;
  ldNoFrame     = $0080;
  ldNoScrollBar = $0100;

    { ofXXXX constants  }
  ofNew           = $0001;
  ofDelete        = $0002;
  ofEdit          = $0004;
  ofNewEditDelete = ofNew or ofDelete or ofEdit;

{---------------------------------------------------------------------------}
{                     TDialog PALETTE COLOUR CONSTANTS                      }
{---------------------------------------------------------------------------}
CONST
   dpBlueDialog = 0;                                  { Blue dialog colour }
   dpCyanDialog = 1;                                  { Cyan dialog colour }
   dpGrayDialog = 2;                                  { Gray dialog colour }

{---------------------------------------------------------------------------}
{                           TButton FLAGS MASKS                             }
{---------------------------------------------------------------------------}
CONST
   bfNormal    = $00;                                 { Normal displayed }
   bfDefault   = $01;                                 { Default command }
   bfLeftJust  = $02;                                 { Left just text }
   bfBroadcast = $04;                                 { Broadcast command }
   bfGrabFocus = $08;                                 { Grab focus }

{---------------------------------------------------------------------------}
{          TMultiCheckBoxes FLAGS - (HiByte = Bits LoByte = Mask)           }
{---------------------------------------------------------------------------}
CONST
   cfOneBit    = $0101;                               { One bit masks }
   cfTwoBits   = $0203;                               { Two bit masks }
   cfFourBits  = $040F;                               { Four bit masks }
   cfEightBits = $08FF;                               { Eight bit masks }

{---------------------------------------------------------------------------}
{                        DIALOG BROADCAST COMMANDS                          }
{---------------------------------------------------------------------------}
CONST
   cmRecordHistory = 60;                              { Record history cmd }

{***************************************************************************}
{                            RECORD DEFINITIONS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                          ITEM RECORD DEFINITION                           }
{---------------------------------------------------------------------------}
TYPE
    PSItem = ^TSItem deprecated 'use TStrings';
   TSItem = RECORD
     Value: PString;                                  { Item string }
     Next: PSItem{%H-};                                    { Next item }
   END deprecated 'use TStrings';

{***************************************************************************}
{                            OBJECT DEFINITIONS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                   TInputLine OBJECT - INPUT LINE OBJECT                   }
{---------------------------------------------------------------------------}
TYPE
   TInputLine = class (TView)
     public
         MaxLen: Sw_Integer;                             { Max input length }
         CurPos: Sw_Integer;                             { Cursor position }
         FirstPos: Sw_Integer;                           { First position }
         SelStart: Sw_Integer;                           { Selected start }
         SelEnd: Sw_Integer;                             { Selected end }
         Data: String;                               { Input line data }
         Validator: TValidator;                       { Validator of view }
      CONSTRUCTOR Create (aOwner:Tgroup;Var Bounds: TRect; AMaxLen: Sw_Integer);
      constructor Load(aOwner: TGroup; var S: TStream);
      DESTRUCTOR Destroy; override;
      FUNCTION DataSize: Sw_Word; override;
      FUNCTION GetPalette: PPalette; override;
      FUNCTION Valid (Command: Word): Boolean; override;
      PROCEDURE Draw; override;
      PROCEDURE DrawCursor; override;
      PROCEDURE SelectAll (Enable: Boolean);
      PROCEDURE SetValidator (AValid: TValidator);
      PROCEDURE SetState (AState: Word; Enable: Boolean); override;
      PROCEDURE GetData (const Rec:TStream); override;overload;
      PROCEDURE SetData (const Rec:TStream); override;overload;
      PROCEDURE GetData (out aSt:string); virtual;overload;
      PROCEDURE SetData (const aSt:string); virtual;overload;
      PROCEDURE Store (Var S: TStream);override;
      PROCEDURE HandleEvent (Var Event: TEvent); override;
      PRIVATE
      FUNCTION CanScroll (Delta: Sw_Integer): Boolean;
   END;
    PInputLine = ^TInputLine deprecated 'use TInputLine';

{---------------------------------------------------------------------------}
{                  TButton OBJECT - BUTTON ANCESTOR OBJECT                  }
{---------------------------------------------------------------------------}
TYPE
   TButton = Class (TView)
      public
         AmDefault: Boolean;                          { If default button }
         Flags    : Byte;                             { Button flags }
         Command  : Word;                             { Button command }
         Title    : String;                          { Button title }
      CONSTRUCTOR create (aOwner:TGroup;Var Bounds: TRect; ATitle: TTitleStr; ACommand: Word;
        AFlags: Word);
      constructor Load(aOwner: TGroup; var S: TStream);
      DESTRUCTOR Destroy; override;
      FUNCTION GetPalette: PPalette; override;
      PROCEDURE Press; Virtual;
      PROCEDURE Draw; override;
      PROCEDURE DrawState (Down: Boolean);
      PROCEDURE MakeDefault (Enable: Boolean);
      PROCEDURE SetState (AState: Word; Enable: Boolean); override;
      PROCEDURE Store (Var S: TStream);override;
      PROCEDURE HandleEvent (Var Event: TEvent); override;
      PRIVATE
      DownFlag: Boolean;
   END;
    PButton = ^TButton deprecated 'use TButton';

{---------------------------------------------------------------------------}
{                 TCluster OBJECT - CLUSTER ANCESTOR OBJECT                 }
{---------------------------------------------------------------------------}
TYPE
  { Palette layout }
  { 1 = Normal text }
  { 2 = Selected text }
  { 3 = Normal shortcut }
  { 4 = Selected shortcut }
  { 5 = Disabled text }

   TCluster = Class (TView)
      public
         Id        : Sw_Integer;                         { New communicate id }
         Sel       : Sw_Integer;                         { Selected item }
         Value     : LongInt;                         { Bit value }
         EnableMask: LongInt;                         { Mask enable bits }
         Strings   : TStrings;               { String collection }
      constructor Create(aOwner: TGroup; var Bounds: TRect; AStrings: Tstrings);overload;
      constructor Create(aOwner: TGroup; var Bounds: TRect; AStrings: array of string);
      CONSTRUCTOR Load (aOwner:TGroup;Var S: TStream);
      DESTRUCTOR Destroy; override;
      FUNCTION DataSize: Sw_Word; override;
      FUNCTION GetHelpCtx: Word; override;
      FUNCTION GetPalette: PPalette; override;
      FUNCTION Mark (Item: Sw_Integer): Boolean; Virtual;
      FUNCTION MultiMark (Item: Sw_Integer): Byte; Virtual;
      FUNCTION ButtonState (Item: Sw_Integer): Boolean;
      PROCEDURE Draw;                                           override;
      PROCEDURE Press (Item: Sw_Integer); Virtual;
      PROCEDURE MovedTo (Item: Sw_Integer); Virtual;
      PROCEDURE SetState (AState: Word; Enable: Boolean); override;
      PROCEDURE DrawMultiBox (Const Icon, Marker: String);
      PROCEDURE DrawBox (Const Icon: String; Marker: Char);
      PROCEDURE SetButtonState (AMask: Longint; Enable: Boolean);
      PROCEDURE GetData (Const Rec:TStream); override;
      PROCEDURE SetData (Const Rec:TStream); override;
      PROCEDURE Store (Var S: TStream);override;
      PROCEDURE HandleEvent (Var Event: TEvent);                     override;
      PRIVATE
      FUNCTION FindSel (P: TPoint): Sw_Integer;
      FUNCTION Row (Item: Sw_Integer): Sw_Integer;
      FUNCTION Column (Item: Sw_Integer): Sw_Integer;
   END;
    PCluster = ^TCluster deprecated 'use TCluster';

{---------------------------------------------------------------------------}
{                TRadioButtons OBJECT - RADIO BUTTON OBJECT                 }
{---------------------------------------------------------------------------}

  { Palette layout }
  { 1 = Normal text }
  { 2 = Selected text }
  { 3 = Normal shortcut }
  { 4 = Selected shortcut }


TYPE
   TRadioButtons = Class (TCluster)
     public
      FUNCTION Mark (Item: Sw_Integer): Boolean; override;
      PROCEDURE Draw; override;
      PROCEDURE Press (Item: Sw_Integer); override;
      PROCEDURE MovedTo(Item: Sw_Integer); override;
      procedure SetData(Const Rec: TStream); override;
   END;
    PRadioButtons = ^TRadioButtons deprecated 'use TRadioButtons';

{---------------------------------------------------------------------------}
{                  TCheckBoxes OBJECT - CHECK BOXES OBJECT                  }
{---------------------------------------------------------------------------}

  { Palette layout }
  { 1 = Normal text }
  { 2 = Selected text }
  { 3 = Normal shortcut }
  { 4 = Selected shortcut }

TYPE
   TCheckBoxes = Class (TCluster)
      public
      FUNCTION Mark (Item: Sw_Integer): Boolean; override;
      PROCEDURE Draw; override;
      PROCEDURE Press (Item: Sw_Integer); override;
   END;
    PCheckBoxes = ^TCheckBoxes deprecated 'use TCheckBoxes';

{---------------------------------------------------------------------------}
{               TMultiCheckBoxes OBJECT - CHECK BOXES OBJECT                }
{---------------------------------------------------------------------------}

  { Palette layout }
  { 1 = Normal text }
  { 2 = Selected text }
  { 3 = Normal shortcut }
  { 4 = Selected shortcut }

TYPE
   TMultiCheckBoxes = Class (TCluster)
       public
         SelRange: Byte;                              { Select item range }
         Flags   : Word;                              { Select flags }
         States  : String;                           { Strings }
      constructor Create(aOwner: TGroup; var Bounds: TRect; AStrings: TStrings;
        ASelRange: Byte; AFlags: Word; const AStates: String);
      CONSTRUCTOR Load (aOwner:TGroup;Var S: TStream);
      DESTRUCTOR Destroy; override;
      FUNCTION DataSize: Sw_Word; override;
      FUNCTION MultiMark (Item: Sw_Integer): Byte; override;
      PROCEDURE Draw; override;
      PROCEDURE Press (Item: Sw_Integer); override;
      PROCEDURE GetData (Const Rec:TStream); override;
      PROCEDURE SetData (COnst Rec:TStream); override;
      PROCEDURE Store (Var S: TStream);override;
   END;
    PMultiCheckBoxes = ^TMultiCheckBoxes deprecated 'use TMultiCheckBoxes';

{---------------------------------------------------------------------------}
{                     TListBox OBJECT - LIST BOX OBJECT                     }
{---------------------------------------------------------------------------}

  { Palette layout }
  { 1 = Active }
  { 2 = Inactive }
  { 3 = Focused }
  { 4 = Selected }
  { 5 = Divider }

TYPE
   TListBox = class (TListViewer)
      public
         List: TStrings;                           { List of strings }
      CONSTRUCTOR Create (aOwner:TGroup;Var Bounds: TRect; ANumCols: Sw_Word;
        AScrollBar: TScrollBar);
      CONSTRUCTOR Load (aOwner:TGroup;Var S: TStream);
      FUNCTION DataSize: Sw_Word; override;
      FUNCTION GetText (Item: Sw_Integer; MaxLen: Sw_Integer): String; override;
      PROCEDURE NewList(AList: Tstrings); Virtual;
      PROCEDURE GetData (Const Rec:TStream); override;
      PROCEDURE SetData (Const Rec:TStream); override;
      PROCEDURE Store (Var S: TStream);  override;
      procedure DeleteFocusedItem; virtual;
        { DeleteFocusedItem deletes the focused item and redraws the view. }
        {#X FreeFocusedItem }
      procedure DeleteItem (Item : Sw_Integer); virtual;
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
      procedure FreeItem (Item : Sw_Integer); virtual;
        { FreeItem deletes Item from the associated collection and disposes of
          it, then redraws the listbox. }
        {#X FreeFocusedItem FreeAll }
      function GetFocusedItem: string; virtual;
        { GetFocusedItem is a more readable method of returning the focused
          item from the listbox.  It is however slightly slower than: }
  {#M+}
  {
  Item := ListBox^.List^.At(ListBox^.Focused); }
  {#M-}
      procedure InsertString(Item: String); virtual;
        { Insert inserts Item into the collection, adjusts the listbox's range,
          then redraws the listbox. }
        {#X FreeItem }
      procedure SetFocusedItem(Item: String); virtual;
        { SetFocusedItem changes the focused item to Item then redraws the
          listbox. }
        {# FocusItemNum }
   END;
    PListBox = ^TListBox deprecated 'use TListBox';

{---------------------------------------------------------------------------}
{                TStaticText OBJECT - STATIC TEXT OBJECT                    }
{---------------------------------------------------------------------------}
TYPE
   TStaticText = Class (TView)
      public
         Text: String;                               { Text string ptr }
      CONSTRUCTOR Create(aOwner:Tgroup;Var Bounds: TRect; Const AText: String);
      CONSTRUCTOR Load (aOwner:TGroup;Var S: TStream);
      DESTRUCTOR Destroy; override;
      FUNCTION GetPalette: PPalette; override;
      PROCEDURE Draw;                                      override;
      PROCEDURE Store (Var S: TStream);override;
      PROCEDURE GetText (out S: String); Virtual;
   END;
    PStaticText = ^TStaticText deprecated 'use TStaticText';

{---------------------------------------------------------------------------}
{              TParamText OBJECT - PARMETER STATIC TEXT OBJECT              }
{---------------------------------------------------------------------------}

  { Palette layout }
  { 1 = Text }

TYPE
   TParamText = Class (TStaticText)
       public
         ParamCount: Sw_Integer;                         { Parameter count }
         ParamList : TStrings;                         { Parameter list }
      constructor Create(aOwner: TGroup; var Bounds: TRect; const AText: String;
        AParamCount: Sw_Integer);
      constructor Load(aOwner: TGroup; var S: TStream);
      FUNCTION DataSize: Sw_Word; override;
      PROCEDURE GetData (Const Rec:TStream); override;
      PROCEDURE SetData (Const Rec:TStream); override;
      PROCEDURE Store (Var S: TStream);override;
      PROCEDURE GetText (out S: String); override;
   END;
    PParamText = ^TParamText deprecated 'use TParamText';

{---------------------------------------------------------------------------}
{                        TLabel OBJECT - LABEL OBJECT                       }
{---------------------------------------------------------------------------}
TYPE
   TLabel = Class (TStaticText)
      public
         Light: Boolean;
         Link: TView;                                 { Linked view }
      constructor Create(aOwner: TGroup; var Bounds: TRect; const AText: String;
        ALink: TView);
      constructor Load(aOwner: TGroup; var S: TStream);
      FUNCTION GetPalette: PPalette; override;
      PROCEDURE Draw; override;
      PROCEDURE Store (Var S: TStream);override;
      PROCEDURE HandleEvent (Var Event: TEvent); override;
   END;
    PLabel = ^TLabel deprecated 'use TLabel';

{---------------------------------------------------------------------------}
{             THistoryViewer OBJECT - HISTORY VIEWER OBJECT                 }
{---------------------------------------------------------------------------}

  { Palette layout }
  { 1 = Active }
  { 2 = Inactive }
  { 3 = Focused }
  { 4 = Selected }
  { 5 = Divider }

TYPE
   THistoryViewer = Class(TListViewer)
      Public
         HistoryId: Word;                             { History id }
      constructor Create(aOwner: TGroup; var Bounds: TRect; AHScrollBar,
        AVScrollBar: TScrollBar; AHistoryId: Word);
      FUNCTION HistoryWidth: Sw_Integer;
      FUNCTION GetPalette: PPalette; override;
      FUNCTION GetText (Item: Sw_Integer; MaxLen: Sw_Integer): String; override;
      PROCEDURE HandleEvent (Var Event: TEvent); override;
   END;
    PHistoryViewer = ^THistoryViewer deprecated 'use THistoryViewer';

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

TYPE
  THistoryWindow = Class (TWindow)
      public
         Viewer: TListViewer;                         { List viewer object }
      constructor Create(aOwner: TGroup; var Bounds: TRect; HistoryId: Word);
      FUNCTION GetSelection: String; Virtual;
      FUNCTION GetPalette: PPalette; override;
      PROCEDURE InitViewer (HistoryId: Word); Virtual;
   END;
    PHistoryWindow = ^THistoryWindow deprecated 'use THistoryWindow';

{---------------------------------------------------------------------------}
{                   THistory OBJECT - HISTORY OBJECT                        }
{---------------------------------------------------------------------------}

  { Palette layout }
  { 1 = Arrow }
  { 2 = Sides }

TYPE
   THistory = Class(TGroup)
      public
         HistoryId: Word;
         Link: TInputLine;
      constructor Create(aOwner: TGroup; var Bounds: TRect; ALink: TInputLine;
        AHistoryId: Word);
      constructor Load(aOwner: TGroup; var S: TStream);
      FUNCTION GetPalette: PPalette; override;
      function InitHistoryWindow(var Bounds: TRect): THistoryWindow; Virtual;
      PROCEDURE Draw; override;
      PROCEDURE RecordHistory (CONST S: String); Virtual;
      PROCEDURE Store (Var S: TStream);override;
      PROCEDURE HandleEvent (Var Event: TEvent); override;
   END;
    PHistory = ^THistory deprecated 'use THistory';

  {#Z+}
   PBrowseInputLine = ^TBrowseInputLine deprecated 'use TBrowseInputLine';

  { TBrowseInputLine }

  TBrowseInputLine = Class(TInputLine)
    public
    History: Sw_Word;
    constructor Create(aOwner: TGroup; var Bounds: TRect; AMaxLen: Sw_Integer;
      AHistory: Sw_Word);
    constructor Load(aOwner: TGroup; var S: TStream);
    function DataSize: Sw_Word; override;
    procedure GetData(const Rec:TStream); override;
    procedure SetData(const Rec:TStream); override;
    procedure Store(var S: TStream);override;
  end;  { of TBrowseInputLine }

  TBrowseInputLineRec = record
    Text: string;
    History: Sw_Word;
  end;  { of TBrowseInputLineRec }
  {#Z+}
   PBrowseButton = ^TBrowseButton deprecated 'use TBrowseButton';
  {#Z-}

  { TBrowseButton }

  TBrowseButton = class(TButton)
    Link: TBrowseInputLine;
    constructor Create(aOwner: TGroup; var Bounds: TRect; ATitle: TTitleStr;
      ACommand: Word; AFlags: Byte; ALink: TBrowseInputLine);
    constructor Load(aOwner: TGroup; var S: TStream);
    procedure Press; override;
    procedure Store(var S: TStream);override;
  end;  { of TBrowseButton }


  {#Z+}
   PCommandIcon = ^TCommandIcon deprecated 'use TCommandIcon';
  {#Z-}

  { TCommandIcon }

  TCommandIcon = Class(TStaticText)
    { A TCommandIcon sends an evCommand message to its owner with
      Event.Command set to #Command# when it is clicked with a mouse. }
    constructor Create(aOwner: TGroup; var Bounds: TRect; AText: String;
      ACommand: Word);
      { Creates an instance of a TCommandIcon and sets #Command# to
        ACommand.  AText is the text which is displayed as the icon.  If an
        error occurs Init fails. }
    procedure HandleEvent (var Event : TEvent); override;
      { Captures mouse events within its borders and sends an evCommand to
        its owner in response to the mouse event. }
      {#X Command }
      private
    Command : Word;
      { Command is the command sent to the command icon's owner when it is
        clicked. }
  end;  { of TCommandIcon }


  {#Z+}
   PCommandSItem = ^TCommandSItem deprecated 'use TStrings';
  {#Z-}
  TCommandSItem = record
    { A TCommandSItem is the data structure used to initialize command
      clusters with #NewCommandSItem# rather than the standarad #NewSItem#.
      It is used to associate a command with an individual cluster item. }
    {#X TCommandCheckBoxes TCommandRadioButtons }
    Value : String;
      { Value is the text displayed for the cluster item. }
      {#X Command Next }
    Command : Word;
      { Command is the command broadcast when the cluster item is pressed. }
      {#X Value Next }
    Next : PCommandSItem{%H-};
      { Next is a pointer to the next item in the cluster. }
      {#X Value Command }
  end  { of TCommandSItem }   deprecated 'use TStrings';

  TCommandArray = array of sw_Word;
    { TCommandArray holds a list of commands which are associated with a
      cluster. }
    {#X TCommandCheckBoxes TCommandRadioButtons }


  {#Z+}
   PCommandCheckBoxes = ^TCommandCheckBoxes deprecated 'use TCommandCheckBoxes';
  {#Z-}

  { TCommandCheckBoxes }

  TCommandCheckBoxes = Class(TCheckBoxes)
    public
    { TCommandCheckBoxes function as normal TCheckBoxes, except that when a
      cluster item is pressed it broadcasts a command associated with the
      cluster item to the cluster's owner.

      TCommandCheckBoxes are useful when other parts of a dialog should be
      enabled or disabled in response to a check box's status. }
    CommandList : TCommandArray;
      { CommandList is the list of commands associated with each check box
        item. }
      {#X Init Load Store }
    constructor Create(aOwner: TGroup; var Bounds: TRect; ACommandStrings: TStrings
      );
      { Init calls the inherited constructor, then sets up the #CommandList#
        with the specified commands.  If an error occurs Init fails. }
      {#X NewCommandSItem }
    constructor Load(aOwner: TGroup; var S: TStream);
      { Load calls the inherited constructor, then loads the #CommandList#
        from the stream S.  If an error occurs Load fails. }
      {#X Store Init }
    procedure Press (Item : Sw_Integer); override;
      { Press calls the inherited Press then broadcasts the command
        associated with the cluster item that was pressed to the check boxes'
        owner. }
      {#X CommandList }
    procedure Store (var S : TStream);override;   { store should never be virtual;}
      { Store calls the inherited Store method then writes the #CommandList#
        to the stream. }
      {#X Load }
  end;  { of TCommandCheckBoxes }


  {#Z+}
   PCommandRadioButtons = ^TCommandRadioButtons deprecated 'use TCommandRadioButtons';
  {#Z-}

  { TCommandRadioButtons }

  TCommandRadioButtons = Class(TRadioButtons)
    Public
    { TCommandRadioButtons function as normal TRadioButtons, except that when
      a cluster item is pressed it broadcasts a command associated with the
      cluster item to the cluster's owner.

      TCommandRadioButtons are useful when other parts of a dialog should be
      enabled or disabled in response to a radiobutton's status. }
    CommandList : TCommandArray;  { commands for each possible value }
      { The list of commands associated with each radio button item. }
      {#X Init Load Store }
    constructor Create(aOwner: TGroup; var Bounds: TRect; ACommandStrings: TStrings
      );
      { Init calls the inherited constructor and sets up the #CommandList#
        with the specified commands.  If an error occurs Init disposes of the
        command strings then fails. }
      {#X NewCommandSItem }
    constructor Load(aOwner: TGroup; var S: TStream);
      { Load calls the inherited constructor then loads the #CommandList#
        from the stream S.  If an error occurs Load fails. }
      {#X Store }
    procedure MovedTo (Item : Sw_Integer); override;
      { MovedTo calls the inherited MoveTo, then broadcasts the command of
        the newly selected cluster item to the cluster's owner. }
      {#X Press CommandList }
    procedure Press (Item : Sw_Integer); override;
      { Press calls the inherited Press then broadcasts the command
        associated with the cluster item that was pressed to the check boxes
        owner. }
      {#X CommandList MovedTo }
    procedure Store (var S : TStream); override;
      { Store calls the inherited Store method then writes the #CommandList#
        to the stream. }
      {#X Load }
  end;  { of TCommandRadioButtons }

   PEditListBox = ^TEditListBox deprecated 'use TEditListBox';

  { TEditListBox }

  TEditListBox = Class(TListBox)
    public
    CurrentField : Integer;
    constructor Create(aOwner: TGroup; Bounds: TRect; ANumCols: Word;
      AVScrollBar: TScrollBar);
    constructor Load(aOwner: TGroup; var S: TStream);
    function  FieldValidator : TValidator; virtual;
    function  FieldWidth : Integer; virtual;
    procedure GetField (InputLine : TInputLine); virtual;
    function  GetPalette : PPalette; override;
    procedure HandleEvent (var Event : TEvent); override;
    procedure SetField (InputLine : TInputLine); virtual;
    function  StartColumn : Integer; virtual;
      PRIVATE
    procedure EditField (var Event : TEvent);
  end;  { of TEditListBox }


   PModalInputLine = ^TModalInputLine deprecated 'use TModalInputLine';
  TModalInputLine = Class(TInputLine)
    function  Execute : Word; override;
    procedure HandleEvent (var Event : TEvent); override;
    procedure SetState (AState : Word; Enable : Boolean); override;
      private
    EndState : Word;
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

   PDialog = ^TDialog deprecated 'use TDialog';
  TDialog = Class(TWindow)
    public
    constructor Create(aOwner: TGroup; var Bounds: TRect; ATitle: TTitleStr);
    constructor Load(aOwner: TGroup; var S: TStream);
    procedure Cancel (ACommand : Word); virtual;
      { If the dialog is a modal dialog, Cancel calls EndModal(ACommand).  If
        the dialog is non-modal Cancel calls Close.

        Cancel may be overridden to provide special processing prior to
        destructing the dialog. }
    procedure ChangeTitle (ANewTitle : TTitleStr); virtual;
      { ChangeTitle disposes of the current title, assigns ANewTitle to Title,
        then redraws the dialog. }
    procedure FreeSubView(ASubView: TView); virtual;
      { FreeSubView deletes and disposes ASubView from the dialog. }
      {#X FreeAllSubViews IsSubView }
    procedure FreeAllSubViews; virtual;
      { Deletes then disposes all subviews in the dialog. }
      {#X FreeSubView IsSubView }
    function GetPalette: PPalette; override;
    procedure HandleEvent(var Event: TEvent); override;
    function IsSubView (AView : TView) : Boolean; virtual;
      { IsSubView returns True if AView is non-nil and is a subview of the
        dialog. }
      {#X FreeSubView FreeAllSubViews }
    function NewButton(X, Y, W, H: Sw_Integer; ATitle: TTitleStr; ACommand,
      AHelpCtx: Word; AFlags: Byte): TButton;
      { Creates and inserts into the dialog a new TButton with the
        help context AHelpCtx.

        A pointer to the new button is returned for checking validity of the
        initialization. }
      {#X NewInputLine NewLabel }
    function NewLabel(X, Y: Sw_Integer; AText: String; ALink: TView): TLabel;
      { NewLabel creates and inserts into the dialog a new TLabel and
        associates it with ALink. }
      {#X NewButton NewInputLine }
    function NewInputLine(X, Y, W, AMaxLen: Sw_Integer; AHelpCtx: Word;
      AValidator: TValidator): TInputLine;
      { NewInputLine creates and inserts into the dialog a new TBSDInputLine
        with the help context to AHelpCtx and the validator AValidator.

        A pointer to the inputline is returned for checking validity of the
        initialization. }
      {#X NewButton NewLabel }
    function Valid(Command: Word): Boolean; virtual;
  end;

   PListDlg = ^TListDlg deprecated 'use TListDlg';

  { TListDlg }

  TListDlg = Class(TDialog)
    Public
    { TListDlg displays a listbox of items, with optional New, Edit, and
      Delete buttons displayed according to the options bit set in the
      dialog.  Use the ofXXXX flags declared in this unit OR'd with the
      standard ofXXXX flags to set the appropriate bits in Options.

      If enabled, when the New or Edit buttons are pressed, an evCommand
      message is sent to the application with a Command value of NewCommand
      or EditCommand, respectively.  Using this mechanism in combination with
      the declared Init parameters, a standard TListDlg can be used with any
      type of list displayable in a TListBox or its descendant. }
    NewCommand: Word;
    EditCommand: Word;
    ListBox: TListBox;
    ldOptions: Word;
    constructor Create(aOwner: TGroup; ATitle: TTitleStr; Items: string;
      AButtons: Word; AListBox: TListBox; AEditCommand, ANewCommand: Word);
    constructor Load(aOwner: TGroup; var S: TStream);
    procedure HandleEvent(var Event: TEvent); override;
    procedure Store(var S: TStream); override;  { store should never be virtual;}
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
FUNCTION NewSItem (Const Str: String; ANext: PSItem): PSItem;

{ NewCommandSItem allocates and returns a pointer to a new #TCommandSItem#
 record.  The Value and Next fields of the record are set to NewStr(Str)
 and ANext, respectively.  The NewSItem function and the TSItem record type
 allow easy construction of singly-linked lists of command strings. }
function NewCommandSItem (Str : String; ACommand : Word;
                          ANext : PCommandSItem) : PCommandSItem;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                   DIALOG OBJECT REGISTRATION PROCEDURE                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-RegisterDialogs----------------------------------------------------
This registers all the view type objects used in this unit.
30Sep99 LdB
---------------------------------------------------------------------}
PROCEDURE RegisterDialogs;

resourcestring  slCancel='Cancel';
                slOk='O~k~';
                slYes='~Y~es';
                slNo='~N~o';

                slHelp='~H~elp';
                slName='~N~ame';

                slOpen='~O~pen';
                slClose='~C~lose';
                slCloseAll='Cl~o~se all';

                slSave='~S~ave';
                slSaveAll='Save a~l~l';
                slSaveAs='S~a~ve as...';
                slSaveFileAs='~S~ave file as';

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

USES fv2App,fv2HistList,fv2RectHelper;                               { Standard GFV unit }

{***************************************************************************}
{                         PRIVATE DEFINED CONSTANTS                         }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                 LEFT AND RIGHT ARROW CHARACTER CONSTANTS                  }
{---------------------------------------------------------------------------}
CONST LeftArr = '<'; RightArr = '>';

{---------------------------------------------------------------------------}
{                               TButton MESSAGES                            }
{---------------------------------------------------------------------------}
CONST
   cmGrabDefault    = 61;                             { Grab default }
   cmReleaseDefault = 62;                             { Release default }

{---------------------------------------------------------------------------}
{  IsBlank -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08Jun98 LdB           }
{---------------------------------------------------------------------------}
FUNCTION IsBlank (Ch: Char): Boolean;
BEGIN
   IsBlank := (Ch = ' ') OR (Ch = #13) OR (Ch = #10); { Check for characters }
END;

{---------------------------------------------------------------------------}
{  HotKey -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08Jun98 LdB            }
{---------------------------------------------------------------------------}
FUNCTION HotKey (Const S: String): Char;
VAR I: Sw_Word;
BEGIN
   HotKey := #0;                                      { Preset fail }
   If (S <> '') Then Begin                            { Valid string }
     I := Pos('~', S);                                { Search for tilde }
     If (I <> 0) Then HotKey := UpCase(S[I+1]);       { Return hotkey }
   End;
END;

{***************************************************************************}
{                              OBJECT METHODS                               }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TDialog OBJECT METHODS                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TDialog------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TDialog.Create(aOwner: TGroup; var Bounds: TRect; ATitle: TTitleStr
  );
BEGIN
   Inherited Create(aOwner,Bounds, ATitle, wnNoNumber);        { Call ancestor }
   Options := Options OR ofVersion20;                 { Version two dialog }
   GrowMode := 0;                                     { Clear grow mode }
   Flags := wfMove + wfClose;                         { Close/moveable flags }
   Palette := dpGrayDialog;                           { Default gray colours }
END;

{--TDialog------------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TDialog.Load(aOwner:TGroup;var S: TStream);
BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   If (Options AND ofVersion = ofVersion10) Then Begin
     Palette := dpGrayDialog;                         { Set gray palette }
     Options := Options OR ofVersion20;               { Update version flag }
   End;
END;

{--TDialog------------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB        }
{---------------------------------------------------------------------------}
function TDialog.GetPalette: PPalette;
CONST P: Array[dpBlueDialog..dpGrayDialog] Of String[Length(CBlueDialog)] =
    (CBlueDialog, CCyanDialog, CGrayDialog);          { Always normal string }
BEGIN
   GetPalette := PPalette(@P[Palette]);               { Return palette }
END;

{--TDialog------------------------------------------------------------------}
{  Valid -> Platforms DOS/DPMI/WIN/NT/Os2 - Updated 25Apr98 LdB             }
{---------------------------------------------------------------------------}
function TDialog.Valid(Command: Word): Boolean;
BEGIN
   If (Command = cmCancel) Then Valid := True         { Cancel returns true }
     Else Valid := inherited Valid(Command);             { Call group ancestor }
END;

{--TDialog------------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB       }
{---------------------------------------------------------------------------}
procedure TDialog.HandleEvent(var Event: TEvent);
BEGIN
   Inherited HandleEvent(Event);                      { Call ancestor }
   Case Event.What Of
     evNothing: Exit;                                 { Speed up exit }
     evKeyDown:                                       { Key down event }
       Case Event.KeyCode Of
         kbEsc, kbCtrlF4: Begin                       { Escape key press }
             Event.What := evCommand;                 { Command event }
             Event.Command := cmCancel;               { cancel command }
             Event.InfoPtr := Nil;                    { Clear info ptr }
             PutEvent(Event);                         { Put event on queue }
             ClearEvent(Event);                       { Clear the event }
           End;
         kbCtrlF5: Begin                              { movement of modal dialogs }
             If (State AND sfModal <> 0) Then
               begin
                 Event.What := evCommand;
                 Event.Command := cmResize;
                 Event.InfoPtr := Nil;
                 PutEvent(Event);
                 ClearEvent(Event);
               end;
           End;
         kbEnter: Begin                               { Enter key press }
             Event.What := evBroadcast;               { Broadcast event }
             Event.Command := cmDefault;              { Default command }
             Event.InfoPtr := Nil;                    { Clear info ptr }
             PutEvent(Event);                         { Put event on queue }
             ClearEvent(Event);                       { Clear the event }
           End;
       End;
     evCommand:                                       { Command event }
       Case Event.Command Of
         cmOk, cmCancel, cmYes, cmNo:                 { End dialog cmds }
           If (State AND sfModal <> 0) Then Begin     { View is modal }
             EndModal(Event.Command);                 { End modal state }
             ClearEvent(Event);                       { Clear the event }
           End;
       End;
   End;
END;

{****************************************************************************}
{ TDialog.Cancel                                                             }
{****************************************************************************}
procedure TDialog.Cancel (ACommand : Word);
begin
  if State and sfModal = sfModal then
    EndModal(ACommand)
  else Close;
end;

{****************************************************************************}
{ TDialog.ChangeTitle                                                        }
{****************************************************************************}
procedure TDialog.ChangeTitle (ANewTitle : TTitleStr);
begin
  Title := ANewTitle;
  Frame.DrawView;
end;

{****************************************************************************}
{ TDialog.FreeSubView                                                        }
{****************************************************************************}
procedure TDialog.FreeSubView (ASubView : TView);
begin
  if IsSubView(ASubView) then begin
     freeandnil(ASubView);
     DrawView;
     end;
end;

{****************************************************************************}
{ TDialog.FreeAllSubViews                                                    }
{****************************************************************************}
procedure TDialog.FreeAllSubViews;
var
  P : TView;
begin
  P := First;
  repeat
    P := First;
    if (P <> nil) then
      FreeAndNil(P);
  until (P = nil);
  DrawView;
end;

{****************************************************************************}
{ TDialog.IsSubView                                                          }
{****************************************************************************}
function TDialog.IsSubView (AView : TView) : Boolean;
//var P : TView;
begin
  IsSubView :=  (AView.Owner =self);
end;

{****************************************************************************}
{ TDialog.NewButton                                                          }
{****************************************************************************}
function TDialog.NewButton (X, Y, W, H : Sw_Integer; ATitle : TTitleStr;
                               ACommand, AHelpCtx : Word;
                               AFlags : Byte) : TButton;
var
  B : TButton;
  R : TRect;
begin
  R.Assign(X,Y,X+W,Y+H);
  B := TButton.create(self,R,ATitle,ACommand,AFlags);
  if (B <> nil) then begin
     B.HelpCtx := AHelpCtx;
     Insert(B);
     end;
  result := B;
end;

{****************************************************************************}
{ TDialog.NewInputLine                                                       }
{****************************************************************************}
function TDialog.NewInputLine(X, Y, W, AMaxLen: Sw_Integer; AHelpCtx: Word;
  AValidator: TValidator): TInputLine;
var
  P : TInputLine;
  R : TRect;
begin
  R.Assign(X,Y,X+W,Y+1);
  P := TInputLine.Create(self,R,AMaxLen);
  if (P <> nil) then begin
     P.SetValidator(AValidator);
     P.HelpCtx := AHelpCtx;
     Insert(P);
     end;
  Result := P;
end;

{****************************************************************************}
{ TDialog.NewLabel                                                           }
{****************************************************************************}
function TDialog.NewLabel (X, Y : Sw_Integer; AText : String;
                              ALink : TView) : TLabel;
var
  P : TLabel;
  R : TRect;
begin
  R.Assign(X,Y,X+CStrLen(AText)+1,Y+1);
  P := TLabel.Create(nil,R,AText,ALink);
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
constructor TInputLine.Create(aOwner: Tgroup; var Bounds: TRect;
  AMaxLen: Sw_Integer);
BEGIN
   Inherited create(aOwner,Bounds);                            { Call ancestor }
   State := State OR sfCursorVis;                     { Cursor visible }
   Options := Options OR (ofSelectable + ofFirstClick
     + ofVersion20);                                  { Set options }
   Data := '';                                     { Data = empty string }

   MaxLen := AMaxLen;                                 { Hold maximum length }
END;

{--TInputLine---------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TInputLine.Load(aOwner:TGroup;var S: TStream);


BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   MaxLen:=s.ReadWord;                   { Read max length }
   CurPos:=s.ReadWord;                   { Read cursor position }
   FirstPos:=s.ReadWord;                 { Read first position }
   SelStart:=s.ReadWord;                 { Read selected start }
   SelEnd:=s.ReadWord;                   { Read selected end }
   Data:=S.ReadAnsiString;                             { Read string data }
   If (Options AND ofVersion >= ofVersion20) Then     { Version 2 or above }
     Validator := TValidator(S.ReadComponent(self));                  { Get any validator }
   Options := Options OR ofVersion20;                 { Set version 2 flag }
END;

{--TInputLine---------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB              }
{---------------------------------------------------------------------------}
destructor TInputLine.Destroy;
BEGIN
   If (Data <> '') Then
     Data:='';
   SetValidator(Nil);                                  { Clear any validator }
   Inherited ;                                     { Call ancestor }
END;

{--TInputLine---------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB          }
{---------------------------------------------------------------------------}
function TInputLine.DataSize: Sw_Word;
VAR DSize: Sw_Word;
BEGIN
   DSize := 0;                                        { Preset zero datasize }
   If (Validator <> Nil) AND (Data <> '') Then
     DSize := Validator.Transfer(Data, Nil,
       vtDataSize);                                   { Add validator size }
   If (DSize <> 0) Then DataSize := DSize             { Use validtor size }
     Else DataSize := MaxLen + 1;                     { No validator use size }
END;

{--TInputLine---------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB        }
{---------------------------------------------------------------------------}
function TInputLine.GetPalette: PPalette;
CONST P: String[Length(CInputLine)] = CInputLine;     { Always normal string }
BEGIN
   GetPalette := PPalette(@P);                        { Return palette }
END;

{--TInputLine---------------------------------------------------------------}
{  Valid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB             }
{---------------------------------------------------------------------------}
function TInputLine.Valid(Command: Word): Boolean;

   FUNCTION AppendError (AValidator: TValidator): Boolean;
   BEGIN
     AppendError := False;                            { Preset false }
     If (Data <> '') Then
       With AValidator Do
         If (Options AND voOnAppend <> 0) AND         { Check options }
         (CurPos <> Length(Data)) AND                { Exceeds max length }
         NOT IsValidInput(Data, True) Then Begin     { Check data valid }
           Error;                                     { Call error }
           AppendError := True;                       { Return true }
         End;
   END;

BEGIN
   Valid := Inherited Valid(Command);                 { Call ancestor }
   If (Validator <> Nil) AND (Data <> '') AND        { Validator present }
   (State AND sfDisabled = 0) Then                    { Not disabled }
     If (Command = cmValid) Then                      { Valid command }
       Valid := Validator.Status = vsOk              { Validator result }
       Else If (Command <> cmCancel) Then             { Not cancel command }
         If AppendError(Validator) OR                 { Append any error }
         NOT Validator.Valid(Data) Then Begin       { Check validator }
           Select;                                    { Reselect view }
           Valid := False;                            { Return false }
         End;
END;

{--TInputLine---------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB              }
{---------------------------------------------------------------------------}
procedure TInputLine.Draw;
VAR Color: Byte; L, R: Sw_Integer;
  B : TDrawBuffer;
BEGIN
  if Options and ofSelectable = 0 then
    Color := GetColor(5)
  else
    If (State AND sfFocused = 0) Then
      Color := GetColor(1)       { Not focused colour }
    Else
      Color := GetColor(2);      { Focused colour }
  MoveChar(B, ' ',      Color, Size.X);
  MoveStr(B[1], Copy(Data, FirstPos + 1, Size.X - 2), Color);
  if CanScroll(1) then
    MoveChar(B[Size.X - 1], RightArr, GetColor(4), 1);
  if (State and sfFocused <> 0) and
     (Options and ofSelectable <> 0) then
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
BEGIN
  If (State AND sfFocused <> 0) Then
   Begin           { Focused window }
     Cursor.Y:=0;
     Cursor.X:=CurPos-FirstPos+1;
     ResetCursor;
  end;
END;

{--TInputLine---------------------------------------------------------------}
{  SelectAll -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB         }
{---------------------------------------------------------------------------}
procedure TInputLine.SelectAll(Enable: Boolean);
BEGIN
   CurPos := 0;                                       { Cursor to start }
   FirstPos := 0;                                     { First pos to start }
   SelStart := 0;                                     { Selected at start }
   If Enable AND (Data <> '') Then
     SelEnd := Length(Data) Else SelEnd := 0;        { Selected which end }
   DrawView;                                          { Now redraw the view }
END;

{--TInputLine---------------------------------------------------------------}
{  SetValidator -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB      }
{---------------------------------------------------------------------------}
procedure TInputLine.SetValidator(AValid: TValidator);
BEGIN
   If (Validator <> Nil) Then
     freeandNil(Validator);        { Release validator }
   Validator := AValid;                               { Set new validator }
END;

{--TInputLine---------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB          }
{---------------------------------------------------------------------------}
procedure TInputLine.SetState(AState: Word; Enable: Boolean);
BEGIN
   Inherited SetState(AState, Enable);                { Call ancestor }
   If (AState = sfSelected) OR ((AState = sfActive)
   AND (State and sfSelected <> 0)) Then
     SelectAll(Enable) Else                           { Call select all }
     If (AState = sfFocused) Then DrawView;           { Redraw for focus }
END;

{--TInputLine---------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB           }
{---------------------------------------------------------------------------}
procedure TInputLine.GetData(const Rec: TStream);
BEGIN
   If (Data <> '') Then Begin                        { Data ptr valid }
     If (Validator = Nil) Then Begin                 { No validator/data }
       rec.WriteAnsiString(Data);                   { Transfer our data }
     End;
   End Else rec.WriteAnsiString('');              { Clear the data area }
END;

{--TInputLine---------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB           }
{---------------------------------------------------------------------------}
procedure TInputLine.SetData(const Rec: TStream);
BEGIN
                          { Data ptr valid }
     If (Validator = Nil) OR (Validator.Transfer(
       Data, Rec, vtSetData) = 0) Then              { No validator/data }
       data := Rec.ReadAnsiString;                 { Set our data }
   SelectAll(True);                                   { Now select all }
END;

procedure TInputLine.GetData(out aSt: string);
begin
  aSt:=Data;
end;

procedure TInputLine.SetData(const aSt: string);
begin
  data:=aSt;
end;

{--TInputLine---------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB             }
{---------------------------------------------------------------------------}
procedure TInputLine.Store(var S: TStream);
VAR w: Word;
BEGIN
   Inherited Store(S);                                    { Implict TView.Store }
   w:=MaxLen;S.Write(w, SizeOf(w));                   { Read max length }
   w:=CurPos;S.Write(w, SizeOf(w));                   { Read cursor position }
   w:=FirstPos;S.Write(w, SizeOf(w));                 { Read first position }
   w:=SelStart;S.Write(w, SizeOf(w));                 { Read selected start }
   w:=SelEnd;S.Write(w, SizeOf(w));                   { Read selected end }
   S.WriteAnsiString(Data);                                  { Write the data }
// Todo:   S.WriteComponent(Validator);                                  { Write any validator }
END;

{--TInputLine---------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure TInputLine.HandleEvent(var Event: TEvent);
CONST PadKeys = [$47, $4B, $4D, $4F, $73, $74];
VAR WasAppending: Boolean; ExtendBlock: Boolean; OldData: String;
Delta, Anchor, OldCurPos, OldFirstPos, OldSelStart, OldSelEnd: Sw_Integer;

   FUNCTION MouseDelta: Sw_Integer;
   VAR Mouse : TPOint;
   BEGIN
      MakeLocal(Event.Where, Mouse);
      if Mouse.X <= 0 then
        MouseDelta := -1
      else if Mouse.X >= Size.X - 1 then
        MouseDelta := 1
      else
        MouseDelta := 0;
   END;

   FUNCTION MousePos: Sw_Integer;
   VAR Pos: Sw_Integer;
       Mouse : TPoint;
   BEGIN
     MakeLocal(Event.Where, Mouse);
     if Mouse.X < 1 then Mouse.X := 1;
     Pos := Mouse.X + FirstPos - 1;
     if Pos < 0 then Pos := 0;
     if Pos > Length(Data) then Pos := Length(Data);
     MousePos := Pos;
   END;

   PROCEDURE DeleteSelect;
   BEGIN
     If (SelStart <> SelEnd) Then Begin               { An area selected }
       If (Data <> '') Then
         Delete(Data, SelStart+1, SelEnd-SelStart);  { Delete the text }
       CurPos := SelStart;                            { Set cursor position }
     End;
   END;

   PROCEDURE AdjustSelectBlock;
   BEGIN
     If (CurPos < Anchor) Then Begin                  { Selection backwards }
       SelStart := CurPos;                            { Start of select }
       SelEnd := Anchor;                              { End of select }
     End Else Begin
       SelStart := Anchor;                            { Start of select }
       SelEnd := CurPos;                              { End of select }
     End;
   END;

   PROCEDURE SaveState;
   BEGIN
     If (Validator <> Nil) Then Begin                 { Check for validator }
       If (Data <> '') Then OldData := Data;        { Hold data }
       OldCurPos := CurPos;                           { Hold cursor position }
       OldFirstPos := FirstPos;                       { Hold first position }
       OldSelStart := SelStart;                       { Hold select start }
       OldSelEnd := SelEnd;                           { Hold select end }
       If (Data = '') Then WasAppending := True      { Invalid data ptr }
         Else WasAppending := Length(Data) = CurPos; { Hold appending state }
     End;
   END;

   PROCEDURE RestoreState;
   BEGIN
     If (Validator <> Nil) Then Begin                 { Validator valid }
       If (Data <> '') Then Data := OldData;        { Restore data }
       CurPos := OldCurPos;                           { Restore cursor pos }
       FirstPos := OldFirstPos;                       { Restore first pos }
       SelStart := OldSelStart;                       { Restore select start }
       SelEnd := OldSelEnd;                           { Restore select end }
     End;
   END;

   FUNCTION CheckValid (NoAutoFill: Boolean): Boolean;
   VAR OldLen: Sw_Integer; NewData: String;
   BEGIN
     If (Validator <> Nil) Then Begin                 { Validator valid }
       CheckValid := False;                           { Preset false return }
       If (Data <> '') Then OldLen := Length(Data); { Hold old length }
       If (Validator.Options AND voOnAppend = 0) OR
       (WasAppending AND (CurPos = OldLen)) Then Begin
         If (Data <> '') Then NewData := Data       { Hold current data }
           Else NewData := '';                        { Set empty string }
         If NOT Validator.IsValidInput(NewData,
         NoAutoFill) Then RestoreState Else Begin
           If (Length(NewData) > MaxLen) Then         { Exceeds maximum }
             SetLength(NewData, MaxLen);              { Set string length }
           If (Data <> '') Then Data := NewData;    { Set data value }
           If (Data <> '') AND (CurPos >= OldLen)    { Cursor beyond end }
           AND (Length(Data) > OldLen) Then          { Cursor beyond string }
             CurPos := Length(Data);                 { Set cursor position }
           CheckValid := True;                        { Return true result }
         End;
       End Else Begin
         CheckValid := True;                          { Preset true return }
         If (CurPos = OldLen) AND (Data <> '') Then  { Lengths match }
           If NOT Validator.IsValidInput(Data,
           False) Then Begin                          { Check validator }
             Validator.Error;                        { Call error }
             CheckValid := False;                     { Return false result }
           End;
       End;
     End Else CheckValid := True;                     { No validator }
   END;

BEGIN
   Inherited HandleEvent(Event);                      { Call ancestor }
   If (State AND sfSelected <> 0) Then Begin          { View is selected }
     Case Event.What Of
       evNothing: Exit;                               { Speed up exit }
       evMouseDown: Begin                             { Mouse down event }
         Delta := MouseDelta;                         { Calc scroll value }
         If CanScroll(Delta) Then Begin               { Can scroll }
           Repeat
             If CanScroll(Delta) Then Begin           { Still can scroll }
               Inc(FirstPos, Delta);                  { Move start position }
               DrawView;                              { Redraw the view }
             End;
           Until NOT MouseEvent(Event, evMouseAuto);  { Until no mouse auto }
         End Else If Event.Double Then                { Double click }
           SelectAll(True) Else Begin                 { Select whole text }
             Anchor := MousePos;                      { Start of selection }
             Repeat
               If (Event.What = evMouseAuto)          { Mouse auto event }
               Then Begin
                 Delta := MouseDelta;                 { New position }
                 If CanScroll(Delta) Then             { If can scroll }
                   Inc(FirstPos, Delta);
               End;
               CurPos := MousePos;                    { Set cursor position }
               AdjustSelectBlock;                     { Adjust selected }
               DrawView;                              { Redraw the view }
             Until NOT MouseEvent(Event, evMouseMove
               + evMouseAuto);                        { Until mouse released }
           End;
         ClearEvent(Event);                           { Clear the event }
       End;
       evKeyDown: Begin
         SaveState;                                   { Save state of view }
         Event.KeyCode := CtrlToArrow(Event.KeyCode); { Convert keycode }
         If (Event.ScanCode IN PadKeys) AND
         (GetShiftState AND $03 <> 0) Then Begin      { Mark selection active }
           Event.CharCode := #0;                      { Clear char code }
           If (CurPos = SelEnd) Then                  { Find if at end }
             Anchor := SelStart Else                  { Anchor from start }
             Anchor := SelEnd;                        { Anchor from end }
             ExtendBlock := True;                     { Extended block true }
         End Else ExtendBlock := False;               { No extended block }
         Case Event.KeyCode Of
           kbLeft: If (CurPos > 0) Then Dec(CurPos);  { Move cursor left }
           kbRight: If (Data <> '') AND              { Move right cursor }
           (CurPos < Length(Data)) Then Begin        { Check not at end }
             Inc(CurPos);                             { Move cursor }
             CheckValid(True);                        { Check if valid }
           End;
           kbHome: CurPos := 0;                       { Move to line start }
           kbEnd: Begin                               { Move to line end }
             If (Data = '') Then CurPos := 0         { Invalid data ptr }
               Else CurPos := Length(Data);          { Set cursor position }
             CheckValid(True);                        { Check if valid }
           End;
           kbBack: If (Data <> '') AND (CurPos > 0)  { Not at line start }
           Then Begin
             Delete(Data, CurPos, 1);                { Backspace over char }
             Dec(CurPos);                             { Move cursor back one }
             If (FirstPos > 0) Then Dec(FirstPos);    { Move first position }
             CheckValid(True);                        { Check if valid }
           End;
           kbDel: If (Data <> '') Then Begin         { Delete character }
             If (SelStart = SelEnd) Then              { Select all on }
               If (CurPos < Length(Data)) Then Begin { Cursor not at end }
                 SelStart := CurPos;                  { Set select start }
                 SelEnd := CurPos + 1;                { Set select end }
               End;
             DeleteSelect;                            { Deselect selection }
             CheckValid(True);                        { Check if valid }
           End;
           kbIns: SetState(sfCursorIns, State AND
             sfCursorIns = 0);                        { Flip insert state }
           Else Case Event.CharCode Of
             ' '..#255: If (Data <> '') Then Begin   { Character key }
               If (State AND sfCursorIns <> 0) Then
                 Delete(Data, CurPos + 1, 1) Else    { Overwrite character }
                 DeleteSelect;                        { Deselect selected }
               If CheckValid(True) Then Begin         { Check data valid }
                 If (Length(Data) < MaxLen) Then     { Must not exceed maxlen }
                 Begin
                   If (FirstPos > CurPos) Then
                     FirstPos := CurPos;              { Advance first position }
                   Inc(CurPos);                       { Increment cursor }
                   Insert(Event.CharCode, Data,
                     CurPos);                         { InsertString the character }
                 End;
                 CheckValid(False);                   { Check data valid }
               End;
             End;
             ^Y: If (Data <> '') Then Begin          { Clear all data }
                Data := '';                          { Set empty string }
                CurPos := 0;                          { Cursor to start }
             End;
             Else Exit;                               { Unused key }
           End
         End;
         If ExtendBlock Then AdjustSelectBlock        { Extended block }
         Else Begin
           SelStart := CurPos;                        { Set select start }
           SelEnd := CurPos;                          { Set select end }
         End;
         If (FirstPos > CurPos) Then
           FirstPos := CurPos;                        { Advance first pos }
         If (Data <> '') Then OldData := Copy(Data,
           FirstPos+1, CurPos-FirstPos)               { Text area string }
           Else OldData := '';                        { Empty string }
         Delta := 1;                          { Safety = 1 char }
         While (TextWidth(OldData) > (Size.X-Delta)
         - TextWidth(LeftArr) - TextWidth(RightArr))  { Check text fits }
         Do Begin
           Inc(FirstPos);                             { Advance first pos }
           OldData := Copy(Data, FirstPos+1,
             CurPos-FirstPos)                         { Text area string }
         End;
         DrawView;                                    { Redraw the view }
         ClearEvent(Event);                           { Clear the event }
       End;
     End;
   End;
END;

{***************************************************************************}
{                     TInputLine OBJECT PRIVATE METHODS                     }
{***************************************************************************}
{--TInputLine---------------------------------------------------------------}
{  CanScroll -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB         }
{---------------------------------------------------------------------------}
function TInputLine.CanScroll(Delta: Sw_Integer): Boolean;
VAR S: String;
BEGIN
   If (Delta < 0) Then CanScroll := FirstPos > 0      { Check scroll left }
     Else If (Delta > 0) Then Begin
       If (Data = '') Then S := '' Else              { Data ptr invalid }
         S := Copy(Data, FirstPos+1, Length(Data)
          - FirstPos);                                { Fetch max string }
       CanScroll := (TextWidth(S)) > (Size.X -
         TextWidth(LeftArr) - TextWidth(RightArr));   { Check scroll right }
     End Else CanScroll := False;                     { Zero so no scroll }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TButton OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TButton------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TButton.create(aOwner: TGroup; var Bounds: TRect;
  ATitle: TTitleStr; ACommand: Word; AFlags: Word);
BEGIN
   Inherited create(aOwner,Bounds);                            { Call ancestor }
   EventMask := EventMask OR evBroadcast;             { Handle broadcasts }
   Options := Options OR (ofSelectable + ofFirstClick
     + ofPreProcess + ofPostProcess);                 { Set option flags }
   If NOT CommandEnabled(ACommand) Then
     State := State OR sfDisabled;                    { Check command state }
   Flags := AFlags;                                   { Hold flags }
   If (AFlags AND bfDefault <> 0) Then AmDefault := True
     Else AmDefault := False;                         { Check if default }
   Title := ATitle;                           { Hold title string }
   Command := ACommand;                               { Hold button command }
   TabMask := TabMask OR (tmLeft + tmRight +
     tmTab + tmShiftTab + tmUp + tmDown);             { Set tab masks }
END;

{--TButton------------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TButton.Load(aOwner:TGroup;var S: TStream);
BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   Title := S.ReadAnsiString;                                { Read title }
   S.Read(Command, SizeOf(Command));                  { Read command }
   S.Read(Flags, SizeOf(Flags));                      { Read flags }
   S.Read(AmDefault, SizeOf(AmDefault));              { Read if default }
   If NOT CommandEnabled(Command) Then                { Check command state }
     State := State OR sfDisabled Else                { Command disabled }
     State := State AND NOT sfDisabled;               { Command enabled }
END;

{--TButton------------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB              }
{---------------------------------------------------------------------------}
destructor TButton.Destroy;
BEGIN
   If (Title <> '') Then
     Title:='';          { Dispose title }
   Inherited ;                                    { Call ancestor }
END;

{--TButton------------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Apr98 LdB        }
{---------------------------------------------------------------------------}
function TButton.GetPalette: PPalette;
CONST P: String[Length(CButton)] = CButton;           { Always normal string }
BEGIN
   GetPalette := PPalette(@P);                                  { Get button palette }
END;

{--TButton------------------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 29Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TButton.Press;
VAR E: TEvent;
BEGIN
   MessageP(TView(Owner), evBroadcast, cmRecordHistory, Nil); { Message for history }
   If (Flags AND bfBroadcast <> 0) Then               { Broadcasting button }
     MessageP(TView(Owner), evBroadcast, Command, Self)      { Send message }
     Else Begin
       E.What := evCommand;                           { Command event }
       E.Command := Command;                          { Set command value }
       E.InfoPtr := Self;                            { Pointer to self }
       PutEvent(E);                                   { Put event on queue }
     End;
END;

{--TButton------------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB         }
{---------------------------------------------------------------------------}
procedure TButton.Draw;
VAR I, J, Pos: Sw_Integer;
    Bc: Word; Db: TDrawBuffer;
    C : char;
BEGIN
   If (State AND sfDisabled <> 0) Then                { Button disabled }
     Bc := GetColor($0404) Else Begin                 { Disabled colour }
       Bc := GetColor($0501);                         { Set normal colour }
       If (State AND sfActive <> 0) Then              { Button is active }
         If (State AND sfSelected <> 0) Then
           Bc := GetColor($0703) Else                 { Set selected colour }
             If AmDefault Then Bc := GetColor($0602); { Set is default colour }
     End;
   if title='' then
    begin
      MoveChar(Db[0],' ',GetColor(8),1);
      {No title, draw an empty button.}
      for j:=sw_integer(downflag) to size.x-2 do
        MoveChar(Db[j],' ',Bc,1);
    end
   else
    {We have a title.}
    begin
     If (Flags AND bfLeftJust = 0) Then Begin         { Not left set title }
       I := CTextWidth(Title);                        { Fetch title width }
       I := (Size.X - I) DIV 2;                    { Centre in button }
     End
     Else
       I := 1;                         { Left edge of button }
     If DownFlag then
       begin
         MoveChar(Db[0],' ',GetColor(8),1);
         Pos:=1;
       end
     else
       pos:=0;
     For j:=0 to I-1 do
       MoveChar(Db[pos+j],' ',Bc,1);
     MoveCStr(Db[I+pos], Title, Bc);                        { Move title to buffer }
     For j:=pos+CStrLen(Title)+I to size.X-2 do
       MoveChar(Db[j],' ',Bc,1);
    end;
    If not DownFlag then
      Bc:=GetColor(8);
    MoveChar(Db[Size.X-1],' ',Bc,1);
    WriteLine(0, 0, Size.X,1, Db);                  { Write the title }
    If Size.Y>1 then Begin
      Bc:=GetColor(8);
      if not DownFlag then
        begin
          c:='Ü';
          MoveChar(Db,c,Bc,1);
          WriteLine(Size.X-1, 0, 1, 1, Db);
        end;
      MoveChar(Db,' ',Bc,1);
      if DownFlag then c:=' '
      else c:='ß';
      MoveChar(Db[1],c,Bc,Size.X-1);
      WriteLine(0, 1, Size.X, 1, Db);
    End;
END;

{--TButton------------------------------------------------------------------}
{  DrawState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB         }
{---------------------------------------------------------------------------}
procedure TButton.DrawState(Down: Boolean);
BEGIN
   DownFlag := Down;                                  { Set down flag }
   DrawView;                                          { Redraw the view }
END;

{--TButton------------------------------------------------------------------}
{  MakeDefault -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure TButton.MakeDefault(Enable: Boolean);
VAR C: Word;
BEGIN
   If (Flags AND bfDefault=0) Then Begin              { Not default }
     If Enable Then C := cmGrabDefault
       Else C := cmReleaseDefault;                    { Change default }
     MessageP(TView(Owner), evBroadcast, C, Self);           { Message to owner }
     AmDefault := Enable;                             { Set default flag }
     DrawView;                                        { Now redraw button }
   End;
END;

{--TButton------------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB          }
{---------------------------------------------------------------------------}
procedure TButton.SetState(AState: Word; Enable: Boolean);
BEGIN
   Inherited SetState(AState, Enable);                { Call ancestor }
   If (AState AND (sfSelected + sfActive) <> 0)       { Changing select }
     Then DrawView;                                   { Redraw required }
   If (AState AND sfFocused <> 0) Then
     MakeDefault(Enable);                             { Check for default }
END;

{--TButton------------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TButton.Store(var S: TStream);
BEGIN
   inherited Store(S);                                    { Implict TView.Store }
   S.WriteAnsiString(Title);                                 { Store title string }
   S.Write(Command, SizeOf(Command));                 { Store command }
   S.Write(Flags, SizeOf(Flags));                     { Store flags }
   S.Write(AmDefault, SizeOf(AmDefault));             { Store default flag }
END;

{--TButton------------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Sep99 LdB       }
{---------------------------------------------------------------------------}
procedure TButton.HandleEvent(var Event: TEvent);
VAR Down: Boolean; C: Char; ButRect: TRect;
    Mouse : TPoint;
BEGIN
   ButRect.A.X := 0;                            { Get origin point }
   ButRect.A.Y := 0;                            { Get origin point }
   ButRect.B.X := Size.X + 2;            { Calc right side }
   ButRect.B.Y := Size.Y + 1;            { Calc bottom }
   If (Event.What = evMouseDown) Then Begin           { Mouse down event }
     MakeLocal(Event.Where, Mouse);
     If NOT ButRect.Contains(Mouse) Then Begin       { If point not in view }
       ClearEvent(Event);                             { Clear the event }
       Exit;                                          { Speed up exit }
     End;
   End;
   If (Flags AND bfGrabFocus <> 0) Then               { Check focus grab }
     Inherited HandleEvent(Event);                    { Call ancestor }
   Case Event.What Of
     evNothing: Exit;                                 { Speed up exit }
     evMouseDown: Begin
       If (State AND sfDisabled = 0) Then Begin       { Button not disabled }
         Down := False;                               { Clear down flag }
         Repeat
           MakeLocal(Event.Where, Mouse);
           If (Down <> ButRect.Contains(Mouse)) { State has changed }
           Then Begin
             Down := NOT Down;                        { Invert down flag }
             DrawState(Down);                         { Redraw button }
           End;
         Until NOT MouseEvent(Event, evMouseMove);    { Wait for mouse move }
         If Down Then Begin                           { Button is down }
           Press;                                     { Send out command }
           DrawState(False);                          { Draw button up }
         End;
       End;
       ClearEvent(Event);                             { Event was handled }
     End;
     evKeyDown: Begin
       If (Title <> '') Then C := HotKey(Title)     { Key title hotkey }
         Else C := #0;                                { Invalid title }
       If (Event.KeyCode = GetAltCode(C)) OR          { Alt char }
       (TGroup(Owner).Phase = phPostProcess) AND (C <> #0)
       AND (Upcase(Event.CharCode) = C) OR            { Matches hotkey }
       (State AND sfFocused <> 0) AND                 { View focused }
       ((Event.CharCode = ' ') OR                     { Space bar }
       (Event.KeyCode=kbEnter)) Then Begin            { Enter key }
         DrawState(True);                             { Draw button down }
         Press;                                       { Send out command }
         ClearEvent(Event);                           { Clear the event }
         DrawState(False);                            { Draw button up }
       End;
     End;
     evBroadcast:
       Case Event.Command of
         cmDefault: If AmDefault AND                  { Default command }
         (State AND sfDisabled = 0) Then Begin        { Button enabled }
             Press;                                   { Send out command }
             ClearEvent(Event);                       { Clear the event }
         End;
         cmGrabDefault, cmReleaseDefault:             { Grab and release cmd }
           If (Flags AND bfDefault <> 0) Then Begin   { Change button state }
             AmDefault := Event.Command = cmReleaseDefault;
             DrawView;                                { Redraw the view }
           End;
         cmCommandSetChanged: Begin                   { Command set changed }
           SetState(sfDisabled, NOT
             CommandEnabled(Command));                { Set button state }
            DrawView;                                 { Redraw the view }
         End;
       End;
   End;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TCluster OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

//CONST TvClusterClassName = 'TVCLUSTER';

{--TCluster-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28May98 LdB              }
{---------------------------------------------------------------------------}
constructor TCluster.Create(aOwner: TGroup; var Bounds: TRect;
  AStrings: Tstrings);
//VAR I: Sw_Integer;
BEGIN
   Inherited create(aOwner,Bounds);                            { Call ancestor }
   Options := Options OR (ofSelectable + ofFirstClick
     + ofPreProcess + ofPostProcess + ofVersion20);   { Set option masks }
                                      { Zero string count }
   Strings:=TStringList.Create;                                { Create collection }
   if (AStrings <> Nil) then Begin
     Strings.Assign(AStrings);                                   { Transfer item ptr }
   end;
   Sel := 0;
   SetCursor(2,0);
   ShowCursor;
   EnableMask := Sw_Integer($FFFFFFFF);                           { Enable bit masks }
END;

constructor TCluster.Create(aOwner: TGroup; var Bounds: TRect;
  AStrings: array of string);
var
  S: String;
begin
  Inherited create(aOwner,Bounds);                            { Call ancestor }
  Options := Options OR (ofSelectable + ofFirstClick
    + ofPreProcess + ofPostProcess + ofVersion20);   { Set option masks }
  Strings:=TStringList.Create;                                { Create collection }
  For S in AStrings do Begin
    Strings.Append(S);                                   { Transfer item ptr }
  end;
  Sel := 0;
  SetCursor(2,0);
  ShowCursor;
  EnableMask := Sw_Integer($FFFFFFFF);                           { Enable bit masks }
end;

{--TCluster-----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TCluster.Load(aOwner: TGroup; var S: TStream);
VAR w: word;
BEGIN
   Inherited Load(aowner,S);                                 { Call ancestor }
   If ((Options AND ofVersion) >= ofVersion20) Then   { Version 2 TV view }
     Begin
       S.Read(Value, SizeOf(Value));                  { Read value }
       S.Read(Sel, Sizeof(Sel));                      { Read select item }
       S.Read(EnableMask, SizeOf(EnableMask))         { Read enable masks }
     End
   Else
     Begin
     w:=Value;
     S.Read(w, SizeOf(w)); Value:=w;                  { Read value }
     S.Read(Sel, SizeOf(Sel));                        { Read select item }
     EnableMask := Sw_integer($FFFFFFFF);             { Enable all masks }
     Options := Options OR ofVersion20;               { Set version 2 mask }
   End;
   Strings.LoadFromStream(S);                                   { Load string data }
   SetButtonState(0, True);                           { Set button state }
END;

{--TCluster-----------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Jul99 LdB              }
{---------------------------------------------------------------------------}
destructor TCluster.Destroy;
BEGIN
   freeandnil(Strings);                                      { Dispose of strings }
   Inherited ;                                    { Call ancestor }
END;

{--TCluster-----------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB          }
{---------------------------------------------------------------------------}
function TCluster.DataSize: Sw_Word;
BEGIN
   DataSize := SizeOf(Sw_Word);                          { Exchanges a word }
END;

{--TCluster-----------------------------------------------------------------}
{  GetHelpCtx -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB        }
{---------------------------------------------------------------------------}
function TCluster.GetHelpCtx: Word;
BEGIN
   If (HelpCtx = hcNoContext) Then                    { View has no help }
     GetHelpCtx := hcNoContext Else                   { No help context }
     GetHelpCtx := HelpCtx + Sel;                     { Help of selected }
END;

{--TCluster-----------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB        }
{---------------------------------------------------------------------------}
function TCluster.GetPalette: PPalette;
CONST P: String[Length(CCluster)] = CCluster;         { Always normal string }
BEGIN
   GetPalette := PPalette(@P);                        { Cluster palette }
END;

{--TCluster-----------------------------------------------------------------}
{  Mark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB              }
{---------------------------------------------------------------------------}
function TCluster.Mark(Item: Sw_Integer): Boolean;
BEGIN
   Mark := False;                                     { Default false }
END;

{--TCluster-----------------------------------------------------------------}
{  MultiMark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB         }
{---------------------------------------------------------------------------}
function TCluster.MultiMark(Item: Sw_Integer): Byte;
BEGIN
   MultiMark := Byte(Mark(Item) = True);              { Return multi mark }
END;

{--TCluster-----------------------------------------------------------------}
{  ButtonState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB       }
{---------------------------------------------------------------------------}
function TCluster.ButtonState(Item: Sw_Integer): Boolean;
BEGIN
   If (Item > 31) Then ButtonState := False Else      { Impossible item }
     ButtonState := ((1 SHL Item) AND EnableMask)<>0; { Return true/false }
END;

{--TCluster-----------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Jul99 LdB         }
{---------------------------------------------------------------------------}
procedure TCluster.Draw;
BEGIN
END;

{--TCluster-----------------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TCluster.Press(Item: Sw_Integer);
VAR P: TView;
BEGIN
   P := TopView;
   If (Id <> 0) AND (P <> Nil) Then NewMessage(P,
     evCommand, cmIdCommunicate, Id, Value, Self);   { Send new message }
END;

{--TCluster-----------------------------------------------------------------}
{  MovedTo -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TCluster.MovedTo(Item: Sw_Integer);
BEGIN                                                 { Abstract method }
END;

{--TCluster-----------------------------------------------------------------}
{  SetState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB          }
{---------------------------------------------------------------------------}
procedure TCluster.SetState(AState: Word; Enable: Boolean);
BEGIN
   Inherited SetState(AState, Enable);                { Call ancestor }
   If (AState AND sfFocused <> 0) Then Begin
     DrawView;                                        { Redraw masked areas }
   End;
END;

{--TCluster-----------------------------------------------------------------}
{  DrawMultiBox -> Platforms DOS/DPMI/WIN/NT - Updated 05Jun98 LdB          }
{---------------------------------------------------------------------------}
procedure TCluster.DrawMultiBox(const Icon, Marker: String);
VAR I, J, Cur, Col: Sw_Integer; CNorm, CSel, CDis, Color: Word; B: TDrawBuffer;
BEGIN
   CNorm := GetColor($0301);                          { Normal colour }
   CSel := GetColor($0402);                           { Selected colour }
   CDis := GetColor($0505);                           { Disabled colour }
   For I := 0 To Size.Y-1 Do Begin                { For each line }
     MoveChar(B, ' ', Byte(CNorm), Size.X);       { Fill buffer }
     For J := 0 To (Strings.Count - 1) DIV Size.Y + 1
     Do Begin
       Cur := J*Size.Y + I;                           { Current line }
       If (Cur < Strings.Count) Then Begin
         Col := Column(Cur);                          { Calc column }
         If (Col + CStrLen(Strings.Strings[Cur])+
         5 < Sizeof(TDrawBuffer) DIV SizeOf(Word))
         AND (Col < Size.X) Then Begin            { Text fits in column }
           If NOT ButtonState(Cur) Then
             Color := CDis Else If (Cur = Sel) AND    { Disabled colour }
             (State and sfFocused <> 0) Then
               Color := CSel Else                     { Selected colour }
               Color := CNorm;                        { Normal colour }
           MoveChar(B[Col], ' ', Byte(Color),
             Size.X-Col);                         { Set this colour }
           MoveStr(B[Col], Icon, Byte(Color));        { Transfer icon string }
           WordRec(B[Col+2]).Lo := Byte(Marker[
             MultiMark(Cur) + 1]);                    { Transfer marker }
           MoveCStr(B[Col+5], Strings.Strings[
             Cur], Color);                          { Transfer item string }
           If ShowMarkers AND (State AND sfFocused <> 0)
           AND (Cur = Sel) Then Begin                 { Current is selected }
             WordRec(B[Col]).Lo := Byte(SpecialChars[0]);
              WordRec(B[Column(Cur+Size.Y)-1]).Lo
                := Byte(SpecialChars[1]);             { Set special character }
           End;
         End;
       End;
     End;
     WriteBuf(0, I, Size.X, 1, B);              { Write buffer }
   End;
  SetCursor(Column(Sel)+2,Row(Sel));
END;

{--TCluster-----------------------------------------------------------------}
{  DrawBox -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TCluster.DrawBox(const Icon: String; Marker: Char);
BEGIN
   DrawMultiBox(Icon, ' '+Marker);                    { Call draw routine }
END;

{--TCluster-----------------------------------------------------------------}
{  SetButtonState -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB    }
{---------------------------------------------------------------------------}
procedure TCluster.SetButtonState(AMask: Longint; Enable: Boolean);
VAR I: Sw_Integer; M: Longint;
BEGIN
   If Enable Then EnableMask := EnableMask OR AMask   { Set enable bit mask }
     Else EnableMask := EnableMask AND NOT AMask;     { Disable bit mask }
   If (Strings.Count <= 32) Then Begin                { Valid string number }
     M := 1;                                          { Preset bit masks }
     For I := 1 To Strings.Count Do Begin             { For each item string }
       If ((M AND EnableMask) <> 0) Then Begin        { Bit enabled }
         Options := Options OR ofSelectable;          { Set selectable option }
         Exit;                                        { Now exit }
       End;
       M := M SHL 1;                                  { Create newbit mask }
     End;
     Options := Options AND NOT ofSelectable;         { Make not selectable }
   End;
END;

{--TCluster-----------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB           }
{---------------------------------------------------------------------------}
procedure TCluster.GetData(const Rec: TStream);
BEGIN
   Rec.WriteDWord( Value);                             { Return current value }
END;

{--TCluster-----------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB           }
{---------------------------------------------------------------------------}
procedure TCluster.SetData(const Rec: TStream);
BEGIN
   Value :=Rec.ReadDWord;                              { Set current value }
   DrawView;                                          { Redraw masked areas }
END;

{--TCluster-----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TCluster.Store(var S: TStream);
var
  w : word;
BEGIN
   inherited Store(S);                                    { TView.Store called }
   If ((Options AND ofVersion) >= ofVersion20)        { Version 2 TV view }
   Then Begin
     S.Write(Value, SizeOf(Value));                   { Write value }
     S.Write(Sel, SizeOf(Sel));                       { Write select item }
     S.Write(EnableMask, SizeOf(EnableMask));         { Write enable masks }
   End Else Begin
     w:=Value;
     S.Write(w, SizeOf(Word));                        { Write value }
     S.Write(Sel, SizeOf(Sel));                       { Write select item }
   End;
   Strings.SaveToStream(S);                                  { Store strings }
END;

{--TCluster-----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Jun98 LdB       }
{---------------------------------------------------------------------------}
procedure TCluster.HandleEvent(var Event: TEvent);
VAR C: Char; I, S, Vh: Sw_Integer; Key: Word; Mouse: TPoint; Ts: String;

   PROCEDURE MoveSel;
   BEGIN
     If (I <= Strings.Count) Then Begin
       Sel := S;                                      { Set selected item }
       MovedTo(Sel);                                  { Move to selected }
       DrawView;                                      { Now draw changes }
     End;
   END;

BEGIN
   Inherited HandleEvent(Event);                      { Call ancestor }
   If ((Options AND ofSelectable) = 0) Then Exit;     { Check selectable }
   If (Event.What = evMouseDown) Then Begin           { MOUSE EVENT }
     MakeLocal(Event.Where, Mouse);                   { Make point local }
     I := FindSel(Mouse);                             { Find selected item }
     If (I <> -1) Then                                { Check in view }
       If ButtonState(I) Then Sel := I;               { If enabled select }
     DrawView;                                        { Now draw changes }
     Repeat
       MakeLocal(Event.Where, Mouse);                 { Make point local }
     Until NOT MouseEvent(Event, evMouseMove);        { Wait for mouse up }
     MakeLocal(Event.Where, Mouse);                   { Make point local }
     If (FindSel(Mouse) = Sel) AND ButtonState(Sel)   { If valid/selected }
     Then Begin
       Press(Sel);                                    { Call pressed }
       DrawView;                                      { Now draw changes }
     End;
     ClearEvent(Event);                               { Event was handled }
   End Else If (Event.What = evKeyDown) Then Begin    { KEY EVENT }
     Vh := Size.Y;                            { View height }
     S := Sel;                                        { Hold current item }
     Key := CtrlToArrow(Event.KeyCode);               { Convert keystroke }
     Case Key Of
       kbUp, kbDown, kbRight, kbLeft:
       If (State AND sfFocused <> 0) Then Begin       { Focused key event }
         I := 0;                                      { Zero process count }
         Repeat
           Inc(I);                                    { Inc process count }
           Case Key Of
             kbUp: Dec(S);                            { Next item up }
             kbDown: Inc(S);                          { Next item down }
             kbRight: Begin                           { Next column across }
               Inc(S, Vh);                            { Move to next column }
               If (S >= Strings.Count) Then           { No next column check }
                 S := (S+1) MOD Vh;                   { Move to last column }
             End;
             kbLeft: Begin                            { Prior column across }
               Dec(S, Vh);                            { Move to prior column }
               If (S < 0) Then  S := ((Strings.Count +
                 Vh - 1) DIV Vh) * Vh + S - 1;        { No prior column check }
             End;
           End;
           If (S >= Strings.Count) Then S := 0;       { Roll up to top }
           If (S < 0) Then S := Strings.Count - 1;    { Roll down to bottom }
         Until ButtonState(S) OR (I > Strings.Count); { Repeat until select }
         MoveSel;                                     { Move to selected }
         ClearEvent(Event);                           { Event was handled }
       End;
       Else Begin                                     { Not an arrow key }
         For I := 0 To Strings.Count-1 Do Begin       { Scan each item }
           Ts := Strings.strings[I];                       { Fetch string pointer }
           If (Ts <> '') Then C := HotKey(Ts)       { Check for hotkey }
             Else C := #0;                            { No valid string }
           If (GetAltCode(C) = Event.KeyCode) OR      { Hot key for item }
           (((tgroup(Owner).Phase = phPostProcess) OR        { Owner in post process }
           (State AND sfFocused <> 0)) AND (C <> #0)  { Non zero hotkey }
           AND (UpCase(Event.CharCode) = C))          { Matches current key }
           Then Begin
             If ButtonState(I) Then Begin             { Check mask enabled }
               If Focus Then Begin                    { Check view focus }
                 Sel := I;                            { Set selected }
                 MovedTo(Sel);                        { Move to selected }
                 Press(Sel);                          { Call pressed }
                 DrawView;                            { Now draw changes }
               End;
               ClearEvent(Event);                     { Event was handled }
             End;
             Exit;                                    { Now exit }
           End;
         End;
         If (Event.CharCode = ' ') AND                { Spacebar key }
         (State AND sfFocused <> 0) AND               { Check focused view }
         ButtonState(Sel) Then Begin                  { Check item enabled }
           Press(Sel);                                { Call pressed }
           DrawView;                                  { Now draw changes }
           ClearEvent(Event);                         { Event was handled }
         End;
       End;
     End;
   End;
END;

{***************************************************************************}
{                      TCluster OBJECT PRIVATE METHODS                      }
{***************************************************************************}

{--TCluster-----------------------------------------------------------------}
{  FindSel -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB           }
{---------------------------------------------------------------------------}
function TCluster.FindSel(P: TPoint): Sw_Integer;
VAR I, S, Vh: Sw_Integer; R: TRect;
BEGIN
   GetExtent(R);                                      { Get view extents }
   If R.Contains(P) Then Begin                        { Point in view }
     Vh := Size.Y;                            { View height }
     I := 0;                                          { Preset zero value }
     While (P.X >= Column(I+Vh)) Do Inc(I, Vh);       { Inc view size }
     S := I + P.Y;                                { Line to select }
     If ((S >= 0) AND (S < Strings.Count))            { Valid selection }
       Then FindSel := S Else FindSel := -1;          { Return selected item }
   End Else FindSel := -1;                            { Point outside view }
END;

{--TCluster-----------------------------------------------------------------}
{  Row -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB               }
{---------------------------------------------------------------------------}
function TCluster.Row(Item: Sw_Integer): Sw_Integer;
BEGIN
    Row := Item MOD Size.Y;                           { Normal mod value }
END;

{--TCluster-----------------------------------------------------------------}
{  Column -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 03Jun98 LdB            }
{---------------------------------------------------------------------------}
function TCluster.Column(Item: Sw_Integer): Sw_Integer;
VAR I, Col, L, Vh: Sw_Integer; Ts: String;
BEGIN
   Vh := Size.Y;                              { Vertical size }
   If (Item >= Vh) Then Begin                         { Valid selection }
     Width := 0;                                      { Zero width }
     Col := -6;                                       { Start column at -6 }
     For I := 0 To Item Do Begin                      { For each item }
       If (I MOD Vh = 0) Then Begin                   { Start next column }
         Inc(Col, Width + 6);                         { Add column width }
         Width := 0;                                  { Zero width }
       End;
       If (I < Strings.Count) Then Begin              { Valid string }
         Ts := Strings.strings[I];                         { Transfer string }
         If (Ts <> '') Then L := CStrLen(Ts)        { Length of string }
           Else L := 0;                               { No string }
       End;
       If (L > Width) Then Width := L;                { Hold longest string }
     End;
     Column := Col;                                   { Return column }
   End Else Column := 0;                              { Outside select area }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TRadioButtons OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TRadioButtons------------------------------------------------------------}
{  Mark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB              }
{---------------------------------------------------------------------------}
function TRadioButtons.Mark(Item: Sw_Integer): Boolean;
BEGIN
   Mark := Item = Value;                              { True if item = value }
END;

{--TRadioButtons------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB              }
{---------------------------------------------------------------------------}
procedure TRadioButtons.Draw;
CONST Button = ' ( ) ';
BEGIN
   Inherited Draw;
   DrawMultiBox(Button, ' *');                       { Redraw the text }
END;

{--TRadioButtons------------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TRadioButtons.Press(Item: Sw_Integer);
BEGIN
   Value := Item;                                     { Set value field }
   Inherited Press(Item);                             { Call ancestor }
END;

{--TRadioButtons------------------------------------------------------------}
{  MovedTo -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB           }
{---------------------------------------------------------------------------}
procedure TRadioButtons.MovedTo(Item: Sw_Integer);
BEGIN
   Value := Item;                                     { Set value to item }
   If (Id <> 0) Then NewMessage(TView(Owner), evCommand,
     cmIdCommunicate, Id, Value, Self);              { Send new message }
END;

{--TRadioButtons------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB           }
{---------------------------------------------------------------------------}
procedure TRadioButtons.SetData(const Rec: TStream);
BEGIN
   Sel := Rec.ReadDWord;                               { Set selection }
   Inherited SetData(Rec);                            { Call ancestor }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TCheckBoxes OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TCheckBoxes--------------------------------------------------------------}
{  Mark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB              }
{---------------------------------------------------------------------------}
FUNCTION TCheckBoxes.Mark(Item: Sw_Integer): Boolean;
BEGIN
   If (Value AND (1 SHL Item) <> 0) Then              { Check if item ticked }
     Mark := True Else Mark := False;                 { Return result }
END;

{--TCheckBoxes--------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04May98 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TCheckBoxes.Draw;
CONST Button = ' [ ] ';
BEGIN
   Inherited Draw;
   DrawMultiBox(Button, ' X');                        { Redraw the text }
END;

{--TCheckBoxes--------------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Apr98 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TCheckBoxes.Press (Item: Sw_Integer);
BEGIN
   Value := Value XOR (1 SHL Item);                   { Flip the item mask }
   Inherited Press(Item);                             { Call ancestor }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                      TMultiCheckBoxes OBJECT METHODS                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TMultiCheckBoxes---------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Jun98 LdB              }
{---------------------------------------------------------------------------}
constructor TMultiCheckBoxes.Create(aOwner: TGroup; var Bounds: TRect;
  AStrings: TStrings; ASelRange: Byte; AFlags: Word; const AStates: String);
BEGIN
   Inherited Create(aOwner,Bounds, AStrings);                  { Call ancestor }
   SelRange := ASelRange;                             { Hold select range }
   Flags := AFlags;                                   { Hold flags }
   States := AStates;                         { Hold string }
END;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
constructor TMultiCheckBoxes.Load(aOwner: TGroup; var S: TStream);
BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   S.Read(SelRange, SizeOf(SelRange));                { Read select range }
   S.Read(Flags, SizeOf(Flags));                      { Read flags }
   States := S.ReadAnsiString;                               { Read strings }
END;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
destructor TMultiCheckBoxes.Destroy;
BEGIN
   If (States <> '') Then States:='';        { Dispose strings }
   Inherited ;                                    { Call ancestor }
END;

{--TMultiCheckBoxes---------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB          }
{---------------------------------------------------------------------------}
function TMultiCheckBoxes.DataSize: Sw_Word;
BEGIN
   DataSize := SizeOf(LongInt);                       { Size to exchange }
END;

{--TMultiCheckBoxes---------------------------------------------------------}
{  MultiMark -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB         }
{---------------------------------------------------------------------------}
function TMultiCheckBoxes.MultiMark(Item: Sw_Integer): Byte;
BEGIN
   MultiMark := (Value SHR (Word(Item) *
    WordRec(Flags).Hi)) AND WordRec(Flags).Lo;        { Return mark state }
END;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.Draw;
CONST Button = ' [ ] ';
BEGIN
   Inherited Draw;
   DrawMultiBox(Button, States);                     { Draw the items }
END;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Press -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.Press(Item: Sw_Integer);
VAR CurState: ShortInt;
BEGIN
   CurState := (Value SHR (Word(Item) *
     WordRec(Flags).Hi)) AND WordRec(Flags).Lo;       { Hold current state }
   Dec(CurState);                                     { One down }
   If (CurState >= SelRange) OR (CurState < 0) Then
     CurState := SelRange - 1;                        { Roll if needed }
   Value := (Value AND NOT (LongInt(WordRec(Flags).Lo)
     SHL (Word(Item) * WordRec(Flags).Hi))) OR
    (LongInt(CurState) SHL (Word(Item) *
    WordRec(Flags).Hi));                              { Calculate value }
   Inherited Press(Item);                             { Call ancestor }
END;

{--TMultiCheckBoxes---------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.GetData(const Rec: TStream);
BEGIN
   Rec.WriteDWord( Value);                             { Return value }
END;

{--TMultiCheckBoxes---------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.SetData(const Rec: TStream);
BEGIN
   Value := Rec.ReadDWord;                             { Set value }
   DrawView;                                          { Redraw masked areas }
END;

{--TMultiCheckBoxes---------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TMultiCheckBoxes.Store(var S: TStream);
BEGIN
   inherited Store(S);                                 { TCluster store called }
   S.Write(SelRange, SizeOf(SelRange));               { Write select range }
   S.Write(Flags, SizeOf(Flags));                     { Write select flags }
   S.WriteAnsiString(States);                                { Write strings }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TListBox OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

TYPE
   TListBoxRec = PACKED RECORD
     List: TStrings;                               { List collection ptr }
     Selection: sw_integer;                           { Selected item }
   END;

{--TListBox-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
constructor TListBox.Create(aOwner: TGroup; var Bounds: TRect;
  ANumCols: Sw_Word; AScrollBar: TScrollBar);
BEGIN
   Inherited create(aOwner,Bounds, ANumCols, Nil, AScrollBar); { Call ancestor }
   SetRange(0);                                       { Set range to zero }
END;

{--TListBox-----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB              }
{---------------------------------------------------------------------------}
constructor TListBox.Load(aOwner: TGroup; var S: TStream);
BEGIN
   Inherited Load(aOwner,S);{ Call ancestor }
   list:=TStringList.Create;
   List.LoadFromStream(S);                        { Fetch collection }
END;

{--TListBox-----------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/Os2 - Updated 06Jun98 LdB          }
{---------------------------------------------------------------------------}
function TListBox.DataSize: Sw_Word;
BEGIN
   DataSize := SizeOf(TListBoxRec);                   { Xchg data size }
END;

{--TListBox-----------------------------------------------------------------}
{  GetText -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
function TListBox.GetText(Item: Sw_Integer; MaxLen: Sw_Integer): String;
VAR P:  String;
BEGIN
   result := '';                                     { Preset return }
   If (List <> Nil) Then Begin                        { A list exists }
     P := List.Strings[Item];                    { Get string ptr }
     If (P <> '') Then result := P;                { Return string }
   End;
END;

{--TListBox-----------------------------------------------------------------}
{  NewList -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TListBox.NewList(AList: Tstrings);
BEGIN
   If (List <> Nil) Then List.clear;         { Dispose old list }
   List.Assign(AList);                                     { Hold new list }
   If (AList <> Nil) Then SetRange(AList.Count)      { Set new item range }
     Else SetRange(0);                                { Set zero range }
   If (Range > 0) Then FocusItem(0);                  { Focus first item }
   DrawView;                                          { Redraw all view }
END;

{--TListBox-----------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TListBox.GetData(const Rec: TStream);
BEGIN
   List.SaveToStream(rec);                     { Return current list }
   Rec.WriteDWord(Focused);             { Return focused item }
END;

{--TListBox-----------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TListBox.SetData(const Rec: TStream);
BEGIN
   list.LoadFromStream(rec);
   NewList(List);                    { Hold new list }
   FocusItem(Rec.ReadDWord);             { Focus selected item }
   DrawView;                                          { Redraw all view }
END;

{--TListBox-----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB             }
{---------------------------------------------------------------------------}
procedure TListBox.Store(var S: TStream);
BEGIN
   inherited Store(S);                              { TListViewer store }
   List.SaveToStream(s);                                      { Store list to stream }
END;

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
procedure TListBox.DeleteItem (Item : Sw_Integer);
begin
  if (List <> nil) and (List.Count > 0) and
     ((Item < List.Count) and (Item > -1)) then begin
     if IsSelected(Item) and (Item > 0) then
        FocusItem(Item - 1);
     List.Delete(Item);
     SetRange(List.Count);
     end;
end;

{****************************************************************************}
{ TListBox.FreeAll                                                           }
{****************************************************************************}
procedure TListBox.FreeAll;
begin
  if (List <> nil) then
  begin
    List.clear;
    SetRange(List.Count);
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
procedure TListBox.FreeItem (Item : Sw_Integer);
begin
  if (Item > -1) and (Item < Range) then
  begin
    List.delete(Item);
    if (Range > 1) and (Focused >= List.Count) then
      Dec(Focused);
    SetRange(List.Count);
  end;
end;

{****************************************************************************}
{ TListBox.SetFocusedItem                                                    }
{****************************************************************************}
procedure TListBox.SetFocusedItem (Item : String);
begin
  FocusItem(List.IndexOf(Item));
end;

{****************************************************************************}
{ TListBox.GetFocusedItem                                                    }
{****************************************************************************}
function TListBox.GetFocusedItem : string;
begin
  if (List = nil) or (List.Count = 0) then
     GetFocusedItem := ''
  else GetFocusedItem := List.Strings[Focused];
end;

{****************************************************************************}
{ TListBox.InsertString                                                            }
{****************************************************************************}
procedure TListBox.InsertString (Item : String);
begin
  if (List <> nil) then
  begin
    List.Append(Item);
    SetRange(List.Count);
  end;
end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TStaticText OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStaticText--------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TStaticText.Create(aOwner: Tgroup; var Bounds: TRect;
  const AText: String);
BEGIN
   Inherited Create(aOwner,Bounds);                            { Call ancestor }
   Text := AText;                             { Create string ptr }
END;

{--TStaticText--------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TStaticText.Load(aOwner: TGroup; var S: TStream);
BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   Text := S.ReadAnsiString;                                 { Read text string }
END;

{--TStaticText--------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
destructor TStaticText.Destroy;
BEGIN
   If (Text <> '') Then Text:= '';            { Dispose string }
   Inherited ;                                    { Call ancestor }
END;

{--TStaticText--------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB        }
{---------------------------------------------------------------------------}
function TStaticText.GetPalette: PPalette;
CONST P: String[Length(CStaticText)] = CStaticText;   { Always normal string }
BEGIN
   GetPalette := PPalette(@P);                        { Return palette }
END;

{--TStaticText--------------------------------------------------------------}
{  DrawBackGround -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB    }
{---------------------------------------------------------------------------}
procedure TStaticText.Draw;
VAR Just: Byte; I, J, P, Y, L: Sw_Integer; S: String;
  B : TDrawBuffer;
  Color : Byte;
BEGIN
   GetText(S);                                        { Fetch text to write }
   Color := GetColor(1);
   P := 1;                                            { X start position }
   Y := 0;                                            { Y start position }
   L := Length(S);                                    { Length of text }
   While (Y < Size.Y) Do Begin
    MoveChar(B, ' ', Color, Size.X);
    if P <= L then
    begin
      Just := 0;                                       { Default left justify }
      If (S[P] = #2) Then Begin                        { Right justify char }
        Just := 2;                                     { Set right justify }
        Inc(P);                                        { Next character }
      End;
      If (S[P] = #3) Then Begin                        { Centre justify char }
        Just := 1;                                     { Set centre justify }
        Inc(P);                                        { Next character }
      End;
      I := P;                                          { Start position }
      repeat
        J := P;
        while (P <= L) and (S[P] = ' ') do
          Inc(P);
        while (P <= L) and (S[P] <> ' ') and (S[P] <> #13) do
          Inc(P);
      until (P > L) or (P >= I + Size.X) or (S[P] = #13);
      If P > I + Size.X Then                           { Text to long }
        If J > I Then
          P := J
        Else
          P := I + Size.X;
      Case Just Of
        0: J := 0;                           { Left justify }
        1: J := (Size.X - (P-I)) DIV 2;      { Centre justify }
        2: J := Size.X - (P-I);              { Right justify }
      End;
      MoveBuf(B[J], S[I], Color, P - I);
      While (P <= L) AND (P-I <= Size.X) AND ((S[P] = #13) OR (S[P] = #10))
        Do Inc(P);                                     { Remove CR/LF }
    End;
    WriteLine(0, Y, Size.X, 1, B);
    Inc(Y);                                          { Next line }
  End;
END;

{--TStaticText--------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TStaticText.Store(var S: TStream);
BEGIN
   inherited Store(S);                                    { Call TView store }
   S.WriteAnsiString(Text);                                  { Write text string }
END;

{--TStaticText--------------------------------------------------------------}
{  GetText -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB           }
{---------------------------------------------------------------------------}
procedure TStaticText.GetText(out S: String);
BEGIN
   If (Text <> '') Then S := Text                   { Copy text string }
     Else S := '';                                    { Return empty string }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TParamText OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TParamText---------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TParamText.Create(aOwner: TGroup;var Bounds: TRect; const AText: String;
  AParamCount: Sw_Integer);
BEGIN
   Inherited Create(aOwner,Bounds, AText);                     { Call ancestor }
   ParamCount := AParamCount;                         { Hold param count }
END;

{--TParamText---------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB              }
{---------------------------------------------------------------------------}
constructor TParamText.Load(aOwner: TGroup;var S: TStream);

BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   ParamCount:=S.ReadWord;               { Read parameter count }
END;

{--TParamText---------------------------------------------------------------}
{  DataSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB          }
{---------------------------------------------------------------------------}
function TParamText.DataSize: Sw_Word;
BEGIN
   DataSize := ParamCount * SizeOf(Pointer);          { Return data size }
END;

{--TParamText---------------------------------------------------------------}
{  GetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TParamText.GetData(const Rec: TStream);

BEGIN
   paramlist.SaveToStream(rec);
END;

{--TParamText---------------------------------------------------------------}
{  SetData -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 06Jun98 LdB           }
{---------------------------------------------------------------------------}
procedure TParamText.SetData(const Rec: TStream);
BEGIN
   ParamList.LoadFromStream( Rec);                                 { Fetch parameter list }
   DrawView;                                          { Redraw all the view }
END;

{--TParamText---------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB             }
{---------------------------------------------------------------------------}
procedure TParamText.Store(var S: TStream);
VAR w: Word;
BEGIN
   inherited Store(S);                              { Statictext store }
   w:=ParamCount;S.Write(w, SizeOf(w));           { Store param count }
END;

{--TParamText---------------------------------------------------------------}
{  GetText -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Apr98 LdB           }
{---------------------------------------------------------------------------}
procedure TParamText.GetText(out S: String);

var l:array of TvarRec;
  vv:array of variant;
  i: Integer;

BEGIN
   If (Text = '') Then S := '' Else                  { Return empty string }
     begin
       setlength(l,paramList.count);
       setlength(vv,paramList.count);
       for i := 0 to paramList.count-1 do
         begin
          vv[i]:=ParamList[i];
         l[i].VVariant:=@vv[i];
       s := Format(Text, l);                 { Return text string }
     end;
     end;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TLabel OBJECT METHODS                           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TLabel-------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TLabel.Create(aOwner:TGroup;var Bounds: TRect; const AText: String; ALink: TView);
BEGIN
   Inherited Create(aOwner,Bounds, AText);                     { Call ancestor }
   Link := ALink;                                     { Hold link }
   Options := Options OR (ofPreProcess+ofPostProcess);{ Set pre/post process }
   EventMask := EventMask OR evBroadcast;             { Sees broadcast events }
END;

{--TLabel-------------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor TLabel.Load(aOwner:TGroup;var S: TStream);
BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   GetPeerViewPtr(S, Link);                           { Load link view }
END;

{--TLabel-------------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
function TLabel.GetPalette: PPalette;
CONST P: String[Length(CLabel)] = CLabel;             { Always normal string }
BEGIN
   GetPalette := PPalette(@P);                        { Return palette }
END;

{--TLabel-------------------------------------------------------------------}
{  DrawBackGround -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB    }
{---------------------------------------------------------------------------}
procedure TLabel.Draw;
VAR SCOff: Byte; Color: Word; B: TDrawBuffer;
BEGIN
   If Light Then Begin                                { Light colour select }
     Color := GetColor($0402);                        { Choose light colour }
     SCOff := 0;                                      { Zero offset }
   End Else Begin
     Color := GetColor($0301);                        { Darker colour }
     SCOff := 4;                                      { Set offset }
   End;
   MoveChar(B[0], ' ', Byte(Color), Size.X);          { Clear the buffer }
   If (Text <> '') Then MoveCStr(B[1], Text, Color);{ Transfer label text }
   If ShowMarkers Then WordRec(B[0]).Lo := Byte(
     SpecialChars[SCOff]);                            { Show marker if req }
   WriteLine(0, 0, Size.X, 1, B);                     { Write the text }
END;

{--TLabel-------------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB             }
{---------------------------------------------------------------------------}
procedure TLabel.Store(var S: TStream);
BEGIN
   Inherited Store(S);                              { TStaticText.Store }
   PutPeerViewPtr(S, Link);                           { Store link view }
END;

{--TLabel-------------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure TLabel.HandleEvent(var Event: TEvent);
VAR C: Char;

   PROCEDURE FocusLink;
   BEGIN
     If (Link <> Nil) AND (Link.Options AND
      ofSelectable <> 0) Then Link.Focus;            { Focus link view }
     ClearEvent(Event);                               { Clear the event }
   END;

BEGIN
   Inherited HandleEvent(Event);                      { Call ancestor }
   Case Event.What Of
     evNothing: Exit;                                 { Speed up exit }
     evMouseDown: FocusLink;                          { Focus link view }
     evKeyDown:
       Begin
        // if assigned(text) then
           begin
             C := HotKey(Text);                            { Check for hotkey }
             If (GetAltCode(C) = Event.KeyCode) OR          { Alt plus char }
               ((C <> #0) AND (Tgroup(Owner).Phase = phPostProcess)  { Post process phase }
                AND (UpCase(Event.CharCode) = C)) Then         { Upper case match }
               FocusLink;                                   { Focus link view }
           end;
       end;
     evBroadcast: If ((Event.Command = cmReceivedFocus)
       OR (Event.Command = cmReleasedFocus)) AND      { Focus state change }
       (Link <> Nil) Then Begin
         Light := Link.State AND sfFocused <> 0;     { Change light state }
         DrawView;                                    { Now redraw change }
       End;
   End;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       THistoryViewer OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--THistoryViewer-----------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor THistoryViewer.Create(aOwner: TGroup;var Bounds: TRect; AHScrollBar,
  AVScrollBar: TScrollBar; AHistoryId: Word);
BEGIN
   Inherited Create(aOwner,Bounds, 1, AHScrollBar,
     AVScrollBar);                                    { Call ancestor }
   HistoryId := AHistoryId;                           { Hold history id }
   SetRange(HistoryCount(AHistoryId));                { Set history range }
   If (Range > 1) Then FocusItem(1);                  { Set to item 1 }
   If (HScrollBar <> Nil) Then
     HScrollBar.SetRange(1, HistoryWidth-Size.X + 3);{ Set scrollbar range }
END;

{--THistoryViewer-----------------------------------------------------------}
{  HistoryWidth -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB      }
{---------------------------------------------------------------------------}
function THistoryViewer.HistoryWidth: Sw_Integer;
VAR T, Count, I: Sw_Integer;
BEGIN
   Width := 0;                                        { Zero width variable }
   Count := HistoryCount(HistoryId);                  { Hold count value }
   For I := 0 To Count-1 Do Begin                     { For each item }
     T := Length(HistoryStr(HistoryId, I));           { Get width of item }
     If (T > Width) Then Width := T;                  { Set width to max }
   End;
   HistoryWidth := Width;                             { Return max item width }
END;

{--THistoryViewer-----------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
function THistoryViewer.GetPalette: PPalette;
CONST P: String[Length(CHistoryViewer)] = CHistoryViewer;{ Always normal string }
BEGIN
   GetPalette := PPalette(@P);                           { Return palette }
END;

{--THistoryViewer-----------------------------------------------------------}
{  GetText -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB           }
{---------------------------------------------------------------------------}
function THistoryViewer.GetText(Item: Sw_Integer; MaxLen: Sw_Integer): String;
BEGIN
   GetText := HistoryStr(HistoryId, Item);            { Return history string }
END;

{--THistoryViewer-----------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure THistoryViewer.HandleEvent(var Event: TEvent);
BEGIN
   If ((Event.What = evMouseDown) AND (Event.Double)) { Double click mouse }
   OR ((Event.What = evKeyDown) AND
   (Event.KeyCode = kbEnter)) Then Begin              { Enter key press }
     EndModal(cmOk);                                  { End with cmOk }
     ClearEvent(Event);                               { Event was handled }
   End Else If ((Event.What = evKeyDown) AND
   (Event.KeyCode = kbEsc)) OR                        { Esc key press }
   ((Event.What = evCommand) AND
   (Event.Command = cmCancel)) Then Begin             { Cancel command }
     EndModal(cmCancel);                              { End with cmCancel }
     ClearEvent(Event);                               { Event was handled }
   End Else Inherited HandleEvent(Event);             { Call ancestor }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       THistoryWindow OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--THistoryWindow-----------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor THistoryWindow.Create(aOwner: TGroup;var Bounds: TRect; HistoryId: Word);
BEGIN
   Inherited Create(aOwner,Bounds, '', wnNoNumber);            { Call ancestor }
   Flags := wfClose;                                  { Close flag only }
   InitViewer(HistoryId);                             { Create list view }
END;

{--THistoryWindow-----------------------------------------------------------}
{  GetSelection -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB      }
{---------------------------------------------------------------------------}
function THistoryWindow.GetSelection: String;
BEGIN
   If (Viewer = Nil) Then GetSelection := '' Else     { Return empty string }
     GetSelection := Viewer.GetText(Viewer.Focused,
       255);                                          { Get focused string }
END;

{--THistoryWindow-----------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
function THistoryWindow.GetPalette: PPalette;
CONST P: String[Length(CHistoryWindow)] = CHistoryWindow;{ Always normal string }
BEGIN
   GetPalette := PPalette(@P);                           { Return the palette }
END;

{--THistoryWindow-----------------------------------------------------------}
{  InitViewer -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
procedure THistoryWindow.InitViewer(HistoryId: Word);
VAR R: TRect;
BEGIN
   GetExtent(R);                                      { Get extents }
   R.Grow(-1,-1);                                     { Grow inside }
   Viewer := THistoryViewer.Create(self,R,
     StandardScrollBar(sbHorizontal + sbHandleKeyboard),
     StandardScrollBar(sbVertical + sbHandleKeyboard),
     HistoryId);                                     { Create the viewer }
   If (Viewer <> Nil) Then Insert(Viewer);            { Insert viewer }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          THistory OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--THistory-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor THistory.Create(aOwner: TGroup;var Bounds: TRect; ALink: TInputLine;
  AHistoryId: Word);
BEGIN
   Inherited create(aOwner,Bounds);                            { Call ancestor }
   Options := Options OR ofPostProcess;               { Set post process }
   EventMask := EventMask OR evBroadcast;             { See broadcast events }
   Link := ALink;                                     { Hold link view }
   HistoryId := AHistoryId;                           { Hold history id }
END;

{--THistory-----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB              }
{---------------------------------------------------------------------------}
constructor THistory.Load(aOwner: TGroup;var S: TStream);
BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   GetPeerViewPtr(S, Link);                           { Load link view }
   S.Read(HistoryId, SizeOf(HistoryId));              { Read history id }
END;

{--THistory-----------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB        }
{---------------------------------------------------------------------------}
function THistory.GetPalette: PPalette;
CONST P: String[Length(CHistory)] = CHistory;         { Always normal string }
BEGIN
   GetPalette := PPalette(@P);                        { Return the palette }
END;

{--THistory-----------------------------------------------------------------}
{  InitHistoryWindow -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB }
{---------------------------------------------------------------------------}
function THistory.InitHistoryWindow(var Bounds: TRect): THistoryWindow;
VAR P: THistoryWindow;
BEGIN
   P := THistoryWindow.Create(self,Bounds, HistoryId); { Create history window }
   If (Link <> Nil) Then
     P.HelpCtx := Link.HelpCtx;                     { Set help context }
   result := P;                            { Return history window }
END;

procedure THistory.Draw;
VAR B: TDrawBuffer;
BEGIN
   MoveCStr(B,'[~'#25'~]', GetColor($0102));   { Set buffer data }
   WriteLine(0, 0, Size.X, Size.Y, B);                { Write buffer }
END;

{--THistory-----------------------------------------------------------------}
{  RecordHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB     }
{---------------------------------------------------------------------------}
procedure THistory.RecordHistory(const S: String);
BEGIN
   HistoryAdd(HistoryId, S);                          { Add to history }
END;

{--THistory-----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB             }
{---------------------------------------------------------------------------}
procedure THistory.Store(var S: TStream);
BEGIN
   inherited Store(S);                                    { TView.Store called }
   PutPeerViewPtr(S, Link);                           { Store link view }
   S.Write(HistoryId, SizeOf(HistoryId));             { Store history id }
END;

{--THistory-----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Oct99 LdB       }
{---------------------------------------------------------------------------}
procedure THistory.HandleEvent(var Event: TEvent);
VAR C: Word; Rslt: String; R, P: TRect; HistoryWindow: THistoryWindow;
BEGIN
   Inherited HandleEvent(Event);                      { Call ancestor }
   If (Link = Nil) Then Exit;                         { No link view exits }
   If (Event.What = evMouseDown) OR                   { Mouse down event }
   ((Event.What = evKeyDown) AND
    (CtrlToArrow(Event.KeyCode) = kbDown) AND         { Down arrow key }
    (Link.State AND sfFocused <> 0)) Then Begin      { Link view selected }
      If NOT Link.Focus Then Begin
       ClearEvent(Event);                             { Event was handled }
       Exit;                                          { Now exit }
      End;
     RecordHistory(Link.Data);                      { Record current data }
     Link.GetBounds(R);                              { Get view bounds }
     Dec(R.A.X);                                      { One char in from us }
     Inc(R.B.X);                                      { One char short of us }
     Inc(R.B.Y, 7);                                   { Seven lines down }
     Dec(R.A.Y,1);                                    { One line below us }
     TView(Owner).GetExtent(P);                             { Get owner extents }
     R.Intersect(P);                                  { Intersect views }
     Dec(R.B.Y,1);                                    { Shorten length by one }
     HistoryWindow := InitHistoryWindow(R);           { Create history window }
     try
     If (HistoryWindow <> Nil) Then Begin             { Window crested okay }
       C := TGroup(Owner).ExecView(HistoryWindow);           { Execute this window }
       If (C = cmOk) Then Begin                       { Result was okay }
         Rslt := HistoryWindow.GetSelection;         { Get history selection }
         If Length(Rslt) > Link.MaxLen Then
            SetLength(Rslt, Link.MaxLen);            { Hold new length }
         Link.Data := Rslt;                         { Hold new selection }
         Link.SelectAll(True);                       { Select all string }
         Link.DrawView;                              { Redraw link view }
       End;
     End;
       finally
       freeandnil(HistoryWindow);                  { Dispose of window }
       end;
     ClearEvent(Event);                               { Event was handled }
   End Else If (Event.What = evBroadcast) Then        { Broadcast event }
     If ((Event.Command = cmReleasedFocus) AND
     (Event.InfoPtr = Link)) OR
     (Event.Command = cmRecordHistory) Then           { Record command }
       RecordHistory(Link.Data);                    { Record the history }
END;

{****************************************************************************}
{ TBrowseButton Object                                                       }
{****************************************************************************}
{****************************************************************************}
{ TBrowseButton.Init                                                         }
{****************************************************************************}
constructor TBrowseButton.Create(aOwner: TGroup;var Bounds: TRect; ATitle: TTitleStr;
  ACommand: Word; AFlags: Byte; ALink: TBrowseInputLine);
begin
  if not assigned(inherited Create(aOwner,Bounds,ATitle,ACommand,AFlags)) then
    Fail;
  Link := ALink;
end;

{****************************************************************************}
{ TBrowseButton.Load                                                         }
{****************************************************************************}
constructor TBrowseButton.Load(aOwner: TGroup;var S: TStream);
begin
  if not assigned(inherited Load(aOwner,S)) then
    Fail;
  GetPeerViewPtr(S,Link);
end;

{****************************************************************************}
{ TBrowseButton.Press                                                        }
{****************************************************************************}
procedure TBrowseButton.Press;
var
  E: TEvent;
begin
  MessageP(TView(Owner), evBroadcast, cmRecordHistory, nil);
  if Flags and bfBroadcast <> 0 then
    MessageP(TView(Owner), evBroadcast, Command, Link) else
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
  PutPeerViewPtr(S,Link);
end;


{****************************************************************************}
{ TBrowseInputLine Object                                                    }
{****************************************************************************}
{****************************************************************************}
{ TBrowseInputLine.Init                                                      }
{****************************************************************************}
constructor TBrowseInputLine.Create(aOwner: TGroup;var Bounds: TRect; AMaxLen: Sw_Integer;
  AHistory: Sw_Word);
begin
  if not assigned(inherited Create(aOwner,Bounds,AMaxLen)) then
    Fail;
  History := AHistory;
end;

{****************************************************************************}
{ TBrowseInputLine.Load                                                      }
{****************************************************************************}
constructor TBrowseInputLine.Load(aOwner: TGroup;var S: TStream);
begin
  if not assigned(inherited Load(aOwner,S)) then
    Fail;
  S.Read(History,SizeOf(History));
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
procedure TBrowseInputLine.GetData(const Rec: TStream);

begin
  if (Validator = nil) or
    (Validator.Transfer(Data, Rec, vtGetData) = 0) then
  begin
    rec.WriteAnsiString(Data);
  end;
  rec.WriteDWord(History);
end;

{****************************************************************************}
{ TBrowseInputLine.SetData                                                   }
{****************************************************************************}
procedure TBrowseInputLine.SetData(const Rec: TStream);

begin
  if (Validator = nil) or
    (Validator.Transfer(Data, Rec, vtSetData) = 0) then
    Data:=rec.ReadAnsiString;
  History := Rec.ReadDWord;
  SelectAll(True);
end;

{****************************************************************************}
{ TBrowseInputLine.Store                                                     }
{****************************************************************************}
procedure TBrowseInputLine.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(History,SizeOf(History));
end;


{****************************************************************************}
{ TCommandCheckBoxes Object                                                  }
{****************************************************************************}
{****************************************************************************}
{ TCommandCheckBoxes.Init                                                    }
{****************************************************************************}
constructor TCommandCheckBoxes.Create(aOwner: TGroup;var Bounds: TRect;
  ACommandStrings: TStrings);
var  i : Sw_Integer;
begin
  if ACommandStrings = nil then
     Fail;

    { construct check boxes }
  if not assigned(Inherited Create(aOwner,Bounds,ACommandStrings)) then begin

    Fail;
    end;
    { set up CommandList and dispose of memory used by ACommandList }
  setlength(CommandList,ACommandStrings.Count);
  for i := 0 to ACommandStrings.count -1  do begin
    CommandList[i] := PtrInt(ACommandStrings.Objects[i]);
    end;
end;

{****************************************************************************}
{ TCommandCheckBoxes.Load                                                    }
{****************************************************************************}
constructor TCommandCheckBoxes.Load (aOwner: TGroup;var S : TStream);
begin
  if not assigned( TCheckBoxes.Load(aOwner,S)) then
     Fail;
  setlength(commandlist,s.ReadWord);
  S.Read(CommandList,SizeOf(CommandList));
end;

{****************************************************************************}
{ TCommandCheckBoxes.Press                                                   }
{****************************************************************************}
procedure TCommandCheckBoxes.Press (Item : Sw_Integer);
var Temp : ptrint;
begin
  Temp := Value;
  inherited Press(Item);
  if (Value <> Temp) then  { value changed - notify peers }
     MessageR(tView(Owner),evCommand,CommandList[Item],Value);
end;

{****************************************************************************}
{ TCommandCheckBoxes.Store                                                   }
{****************************************************************************}
procedure TCommandCheckBoxes.Store (var S : TStream);
begin
  inherited Store(S);
  s.WriteWord(length(commandlist));
  S.Write(CommandList,SizeOf(CommandList));
end;

{****************************************************************************}
{ TCommandIcon Object                                                        }
{****************************************************************************}
{****************************************************************************}
{ TCommandIcon.Init                                                          }
{****************************************************************************}
constructor TCommandIcon.Create(aOwner: TGroup;var Bounds: TRect; AText: String; ACommand: Word
  );
begin
  if not assigned(inherited Create(aOwner,Bounds,AText)) then
     Fail;
  Options := Options or ofPostProcess;
  Command := ACommand;
end;

{****************************************************************************}
{ TCommandIcon.HandleEvent                                                   }
{****************************************************************************}
procedure TCommandIcon.HandleEvent (var Event : TEvent);
begin
  if ((Event.What = evMouseDown) and MouseInView(MouseWhere)) then begin
     ClearEvent(Event);
     MessageP(TView(Owner),evCommand,Command,nil);
     end;
  inherited HandleEvent(Event);
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
constructor TCommandRadioButtons.Create(aOwner: TGroup;var Bounds: TRect;
  ACommandStrings: TStrings);
var
  i : Sw_Integer;
begin
  if ACommandStrings = nil
     then Fail;

    { construct check boxes }
  if not assigned(inherited Create(aOwner, Bounds,ACommandStrings)) then begin
     Fail;
     end;
    { set up command list }
  setlength(CommandList,ACommandStrings.count);
  for i := 0 to ACommandStrings.count-1 do
    CommandList[i] := ptrint(ACommandStrings.objects[i]);
end;

{****************************************************************************}
{ TCommandRadioButtons.Load                                                  }
{****************************************************************************}
constructor TCommandRadioButtons.Load (aOwner: TGroup;var S : TStream);
begin
  if not assigned(inherited Load(aOwner,S)) then
     Fail;
  setlength(commandlist,s.ReadWord);
  S.Read(CommandList,SizeOf(CommandList));
end;

{****************************************************************************}
{ TCommandRadioButtons.MoveTo                                                }
{****************************************************************************}
procedure TCommandRadioButtons.MovedTo (Item : Sw_Integer);
var Temp : Sw_Integer;
begin
  Temp := Value;
  inherited MovedTo(Item);
  if (Value <> Temp) then  { value changed - notify peers }
     MessageR(TView(Owner),evCommand,CommandList[Item],Value);
end;

{****************************************************************************}
{ TCommandRadioButtons.Press                                                 }
{****************************************************************************}
procedure TCommandRadioButtons.Press (Item : Sw_Integer);
var Temp : Sw_Integer;
begin
  Temp := Value;
  inherited Press(Item);
  if (Value <> Temp) then  { value changed - notify peers }
     MessageR(TView(Owner),evCommand,CommandList[Item],Value);
end;

{****************************************************************************}
{ TCommandRadioButtons.Store                                                 }
{****************************************************************************}
procedure TCommandRadioButtons.Store (var S : TStream);
begin
  inherited Store(S);
  s.WriteWord(length(commandlist));
  S.Write(CommandList,SizeOf(CommandList));
end;

{****************************************************************************}
{ TEditListBox Object                                                        }
{****************************************************************************}
{****************************************************************************}
{ TEditListBox.Init                                                          }
{****************************************************************************}
constructor TEditListBox.Create(aOwner: TGroup;Bounds: TRect; ANumCols: Word;
  AVScrollBar: TScrollBar);

begin
  if not assigned( inherited create(aOwner,Bounds,ANumCols,AVScrollBar))
     then Fail;
  CurrentField := 1;
end;

{****************************************************************************}
{ TEditListBox.Load                                                          }
{****************************************************************************}
constructor TEditListBox.Load (aOwner: TGroup;var S : TStream);
begin
  if not assigned( inherited Load(aOwner,S))
     then Fail;
  CurrentField := 1;
end;

{****************************************************************************}
{ TEditListBox.EditField                                                     }
{****************************************************************************}
procedure TEditListBox.EditField (var Event : TEvent);
var R : TRect;
    InputLine : TModalInputLine;
begin
  R.Assign(StartColumn,(Origin.Y + Focused - TopItem),
           (StartColumn + FieldWidth + 2),(Origin.Y + Focused - TopItem + 1));
  tgroup(Owner).MakeGlobal(R.A,R.TopLeft);
  tgroup(Owner).MakeGlobal(R.B,R.BottomRight);
  InputLine := TModalInputLine.Create(self,R,FieldWidth);
  InputLine.SetValidator(FieldValidator);
  if InputLine <> nil
     then begin
              { Use TInputLine.SetData so that data validation occurs }
              { because TInputLine.Data is allocated memory large enough  }
              { to hold a string of MaxLen.  It is also faster.           }
            GetField(InputLine);
            if (Application.ExecView(InputLine) = cmOk)
               then SetField(InputLine);
            freeandnil(InputLine);
          end;
end;

{****************************************************************************}
{ TEditListBox.FieldValidator                                                }
{****************************************************************************}
function TEditListBox.FieldValidator: TValidator;
  { In a multiple field listbox FieldWidth should return the width  }
  { appropriate for Field.  The default is an inputline for editing }
  { a string of length large enough to fill the listbox field.      }
begin
  FieldValidator := nil;
end;

{****************************************************************************}
{ TEditListBox.FieldWidth                                                    }
{****************************************************************************}
function TEditListBox.FieldWidth : Integer;
  { In a multiple field listbox FieldWidth should return the width }
  { appropriate for CurrentField.                                  }
begin
  FieldWidth := Size.X - 2;
end;

{****************************************************************************}
{ TEditListBox.GetField                                                      }
{****************************************************************************}
procedure TEditListBox.GetField(InputLine: TInputLine);
  { Places a string appropriate to Field and Focused into InputLine that }
  { will be edited.   Override this method for complex data types.       }
begin
  InputLine.SetData(List[Focused]);
end;

{****************************************************************************}
{ TEditListBox.GetPalette                                                    }
{****************************************************************************}
function TEditListBox.GetPalette : PPalette;
begin
  GetPalette := inherited GetPalette;
end;

{****************************************************************************}
{ TEditListBox.HandleEvent                                                   }
{****************************************************************************}
procedure TEditListBox.HandleEvent (var Event : TEvent);
begin
  if (Event.What = evKeyboard) and (Event.KeyCode = kbAltE)
     then begin  { edit field }
            EditField(Event);
            DrawView;
            ClearEvent(Event);
          end;
  inherited HandleEvent(Event);
end;

{****************************************************************************}
{ TEditListBox.SetField                                                      }
{****************************************************************************}
procedure TEditListBox.SetField(InputLine: TInputLine);
  { Override this method for field types other than PStrings. }
//var Item : String;
begin
  List[Focused]:=InputLine.Data;
end;

{****************************************************************************}
{ TEditListBox.StartColumn                                                   }
{****************************************************************************}
function TEditListBox.StartColumn : Integer;
begin
  StartColumn := Origin.X;
end;

{****************************************************************************}
{ TListDlg Object                                                            }
{****************************************************************************}
{****************************************************************************}
{ TListDlg.Init                                                              }
{****************************************************************************}
constructor TListDlg.Create(aOwner: TGroup;ATitle: TTitleStr; Items: string; AButtons: Word;
  AListBox: TListBox; AEditCommand, ANewCommand: Word);
var
  Bounds: TRect;
  b: Byte;
  ButtonCount: Byte;
  i, j, Gap, Line: Integer;
  Scrollbar: TScrollbar;
  HasFrame: Boolean;
  HasButtons: Boolean;
  HasScrollBar: Boolean;
  HasItems: Boolean;
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
  ListBox.GetExtent(Bounds);
  Bounds.Move(ListBox.Origin.X,ListBox.Origin.Y);
  if HasFrame then
  begin
    Inc(Bounds.B.X,2);
    Inc(Bounds.B.Y,2);
  end;
  if HasButtons then
  begin
    Inc(Bounds.B.X,14);
    if Bounds.B.Y < (ButtonCount * 2) + 4 then
      Bounds.B.Y := (ButtonCount * 2) + 5;
  end;
  if HasItems then
    Inc(Bounds.B.Y,1);
  if not assigned( inherited Create(aOwner,Bounds,ATitle)) then
    Fail;
  NewCommand := ANewCommand;
  EditCommand := AEditCommand;
  Options := Options or ofNewEditDelete;
  if (not HasFrame) and (Frame <> nil) then
  begin
    Delete(Frame);
    freeandnil(Frame);
    Options := Options and not ofFramed;
  end;
  HelpCtx := hcListDlg;
    { position and insert ListBox }
  ListBox := AListBox;
  Insert(ListBox);
  if HasItems then
    if HasFrame then
      ListBox.MoveTo(2,2)
    else ListBox.MoveTo(0,2)
  else
    if HasFrame then
      ListBox.MoveTo(1,1)
    else ListBox.MoveTo(0,0);
  if HasButtons then
    if ListBox.Size.Y < (ButtonCount * 2) then
      ListBox.GrowTo(ListBox.Size.X,ButtonCount * 2);
    { do Items }
  if HasItems then
  begin
    Bounds.Assign(1,1,CStrLen(Items)+2,2);
    Insert(TLabel.Create(self,Bounds,Items,ListBox));
  end;
    { do scrollbar }
  if HasScrollBar then
  begin
    Bounds.Assign(ListBox.Size.X+ListBox.Origin.X,ListBox.Origin.Y,
      ListBox.Size.X + ListBox.Origin.X + 1,
      ListBox.Size.Y + ListBox.Origin.Y { origin });
    ScrollBar := TScrollBar.Create(self,Bounds);
    Bounds.Assign(Origin.X,Origin.Y,Origin.X + Size.X + 1, Origin.Y + Size.Y);
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
      Insert(NewButton(Size.X - 12,Line,10,2,'~N~ew',cmNew,hcInsert,bfNormal));
      Inc(Line,Gap);
    end;
    if (AButtons and ldEdit) = ldEdit then
    begin
      Insert(NewButton(Size.X - 12,Line,10,2,'~E~dit',cmEdit,hcEdit,
        bfNormal));
      Inc(Line,Gap);
    end;
    if (AButtons and ldDelete) = ldDelete then
    begin
      Insert(NewButton(Size.X - 12,Line,10,2,'~D~elete',cmDelete,hcDelete,
        bfNormal));
      Inc(Line,Gap);
    end;
    Insert(NewButton(Size.X - 12,Line,10,2,'O~k~',cmOK,hcOk,bfDefault or
      bfNormal));
    Inc(Line,Gap);
    Insert(NewButton(Size.X - 12,Line,10,2,'Cancel',cmCancel,hcCancel,
      bfNormal));
    if (AButtons and ldHelp) = ldHelp then
    begin
      Inc(Line,Gap);
      Insert(NewButton(Size.X - 12,Line,10,2,'~H~elp',cmHelp,hcNoContext,
        bfNormal));
    end;
  end;
  if HasFrame and ((AButtons and ldAllIcons) <> 0) then
  begin
    Line := 2;
    if (AButtons and ldNewIcon) = ldNewIcon then
    begin
      Bounds.Assign(Line,Size.Y-1,Line+5,Size.Y);
      Insert(TCommandIcon.Create(self,Bounds,' Ins ',cmNew));
      Inc(Line,5);
      if (AButtons and (ldEditIcon or ldDeleteIcon)) <> 0 then
      begin
        Bounds.Assign(Line,Size.Y-1,Line+1,Size.Y);
        Insert(TStaticText.Create(self,Bounds,'/'));
        Inc(Line,1);
      end;
    end;
    if (AButtons and ldEditIcon) = ldEditIcon then
    begin
      Bounds.Assign(Line,Size.Y-1,Line+6,Size.Y);
      Insert(TCommandIcon.Create(self,Bounds,' Edit ',cmEdit));
      Inc(Line,6);
      if (AButtons and ldDeleteIcon) <> 0 then
      begin
        Bounds.Assign(Line,Size.Y-1,Line+1,Size.Y);
        Insert(TStaticText.Create(self,Bounds,'/'));
        Inc(Line,1);
      end;
    end;
    if (AButtons and ldNewIcon) = ldNewIcon then
    begin
      Bounds.Assign(Line,Size.Y-1,Line+5,Size.Y);
      Insert(TCommandIcon.Create(self,Bounds,' Del ',cmDelete));
    end;
  end;
    { Set focus to list boLine when dialog opens }
  SelectNext(False);
end;

{****************************************************************************}
{ TListDlg.Load                                                              }
{****************************************************************************}
constructor TListDlg.Load (aOwner: TGroup;var S : TStream);
begin
  if not assigned( TDialog.Load(aOwner,S)) then
    Fail;
  S.Read(NewCommand,SizeOf(NewCommand));
  S.Read(EditCommand,SizeOf(EditCommand));
  GetSubViewPtr(S,TView(ListBox));
end;

{****************************************************************************}
{ TListDlg.HandleEvent                                                       }
{****************************************************************************}
procedure TListDlg.HandleEvent (var Event : TEvent);
const
  TargetCommands: TCommandSet = [cmNew, cmEdit, cmDelete];
begin
  if ((Event.What and evCommand) <> 0) and
     (Event.Command in TargetCommands) then
  case Event.Command of
    cmDelete:
      if Options and ofDelete = ofDelete then
      begin
        ListBox.FreeFocusedItem;
        ListBox.DrawView;
        ClearEvent(Event);
      end;
    cmNew:
      if Options and ofNew = ofNew then
      begin
        MessageP(Application,evCommand,NewCommand,nil);
        ListBox.SetRange(ListBox.List.Count);
        ListBox.DrawView;
        ClearEvent(Event);
      end;
    cmEdit:
      if Options and ofEdit = ofEdit then
      begin

        Message(Application,evCommand,EditCommand,ListBox.GetFocusedItem);
        ListBox.DrawView;
        ClearEvent(Event);
      end;
  end;
  if (Event.What and evBroadcast > 0) and
     (Event.Command = cmListItemSelected) then
  begin  { use PutEvent instead of Message so that a window list box works }
    Event.What := evCommand;
    Event.Command := cmOk;
    Event.InfoPtr := nil;
    PutEvent(Event);
  end;
  inherited HandleEvent(Event);
end;

{****************************************************************************}
{ TListDlg.Store                                                             }
{****************************************************************************}
procedure TListDlg.Store (var S : TStream);
begin
  inherited Store(S);
  S.Write(NewCommand,SizeOf(NewCommand));
  S.Write(EditCommand,SizeOf(EditCommand));
  PutSubViewPtr(S,ListBox);
end;

{****************************************************************************}
{ TModalInputLine Object                                                     }
{****************************************************************************}
{****************************************************************************}
{ TModalInputLine.Execute                                                    }
{****************************************************************************}
function TModalInputLine.Execute : Word;
var Event : TEvent;
begin
  repeat
    EndState := 0;
    repeat
      GetEvent(Event);
      HandleEvent(Event);
      if Event.What <> evNothing
         then TGroup(Owner).EventError(Event);  { may change this to ClearEvent }
    until (EndState <> 0);
  until Valid(EndState);
  Execute := EndState;
end;

{****************************************************************************}
{ TModalInputLine.HandleEvent                                                }
{****************************************************************************}
procedure TModalInputLine.HandleEvent (var Event : TEvent);
begin
  case Event.What of
    evKeyboard : case Event.KeyCode of
                   kbUp, kbDown : EndModal(cmCancel);
                   kbEnter : EndModal(cmOk);
                   else inherited HandleEvent(Event);
                 end;
    evMouse : if MouseInView(Event.Where)
                 then inherited HandleEvent(Event)
                 else EndModal(cmCancel);
    else inherited HandleEvent(Event);
  end;
end;

{****************************************************************************}
{ TModalInputLine.SetState                                                   }
{****************************************************************************}
procedure TModalInputLine.SetState (AState : Word; Enable : Boolean);
var Pos : Integer;
begin
  if (AState = sfSelected)
     then begin
            Pos := CurPos;
            inherited SetState(AState,Enable);
            CurPos := Pos;
            SelStart := CurPos;
            SelEnd := CurPos;
            BlockCursor;
            DrawView;
          end
     else inherited SetState(AState,Enable);
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
FUNCTION NewSItem (Const Str: String; ANext: PSItem): PSItem;
VAR Item: PSItem{%H-};
BEGIN
   New(Item);                                         { Allocate item }
   Item^.Value := NewStr(Str);                        { Hold item string }
   Item^.Next := ANext;                               { Chain the ptr }
   NewSItem := Item;                                  { Return item }
END;

{****************************************************************************}
{ NewCommandSItem                                                            }
{****************************************************************************}
function NewCommandSItem (Str : String; ACommand : Word;
                          ANext : PCommandSItem) : PCommandSItem;
var Temp : PCommandSItem{%H-};
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
PROCEDURE RegisterDialogs;
BEGIN
   //RegisterType(RDialog);                             { Register dialog }
   //RegisterType(RInputLine);                          { Register inputline }
   //RegisterType(RButton);                             { Register button }
   //RegisterType(RCluster);                            { Register cluster }
   //RegisterType(RRadioButtons);                       { Register radiobutton }
   //RegisterType(RCheckBoxes);                         { Register check boxes }
   //RegisterType(RMultiCheckBoxes);                    { Register multi boxes }
   //RegisterType(RListBox);                            { Register list box }
   //RegisterType(RStaticText);                         { Register static text }
   //RegisterType(RLabel);                              { Register label }
   //RegisterType(RHistory);                            { Register history }
   //RegisterType(RParamText);                          { Register parm text }
   //RegisterType(RCommandCheckBoxes);
   //RegisterType(RCommandIcon);
   //RegisterType(RCommandRadioButtons);
   //RegisterType(REditListBox);
   //RegisterType(RModalInputLine);
   //RegisterType(RListDlg);
END;

END.
