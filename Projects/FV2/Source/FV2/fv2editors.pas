unit fv2editors;

{$i platform.inc}

interface

uses
  Classes, SysUtils, fv2Drivers, fv2Views, fv2Dialogs, FV2Common, FV2Consts;

const
  { Length constants. }
  Tab_Stop_Length = 74;

{$ifdef PPC_BP}
  MaxLineLength = 1024;
  MinBufLength = $1000;
  MaxBufLength = $ff00;
  NotFoundValue = $ffff;
  LineInfoGrow = 256;
  MaxLines = 16000;
{$else}
  MaxLineLength = 4096;
  MinBufLength = $1000;
  MaxBufLength = $7fffff00;
  NotFoundValue = $ffffffff;
  LineInfoGrow = 1024;
  MaxLines = $7ffffff;
{$endif}


  { Editor constants for dialog boxes. }
  edOutOfMemory = 0;
  edReadError = 1;
  edWriteError = 2;
  edCreateError = 3;
  edSaveModify = 4;
  edSaveUntitled = 5;
  edSaveAs = 6;
  edFind = 7;
  edSearchFailed = 8;
  edReplace = 9;
  edReplacePrompt = 10;

  edJumpToLine = 11;
  edPasteNotPossible = 12;
  edReformatDocument = 13;
  edReformatNotAllowed = 14;
  edReformNotPossible = 15;
  edReplaceNotPossible = 16;
  edRightMargin = 17;
  edSetTabStops = 18;
  edWrapNotPossible = 19;

  { Editor flag constants for dialog options. }
  efCaseSensitive = $0001;
  efWholeWordsOnly = $0002;
  efPromptOnReplace = $0004;
  efReplaceAll = $0008;
  efDoReplace = $0010;
  efBackupFiles = $0100;

  { Constants for object palettes. }
  CIndicator = #2#3;
  CEditor = #6#7;
  CMemo = #26#27;

type
  TEditorDialog = function(Dialog: integer; Info: string): word;

  PIndicator = ^TIndicator deprecated 'use TIndicator';

  TIndicator = class(TView)
  public
    Location: TPoint;
    Modified: boolean;
    AutoIndent: boolean;          { Added boolean for AutoIndent mode. }
    WordWrap: boolean;          { Added boolean for WordWrap mode.   }
    constructor Create(aOwner: TGroup; var Bounds: TRect);
    procedure Draw; override;
    function GetPalette: PPalette; override;
    procedure SetState(AState: word; Enable: boolean); override;
    procedure SetValue(ALocation: TPoint; IsAutoIndent: boolean;
      IsModified: boolean; IsWordWrap: boolean);
  end;

  TLineInfoRec = record
    Len, Attr: Sw_word;
  end;

  TLineInfoArr = array of TLineInfoRec;
  PLineInfoArr = ^TLineInfoArr deprecated 'use TString.Object';

  PLineInfo = ^TLineInfo deprecated 'use TString.Object';

  TLineInfo = class
  public
    Info: PLineInfoArr{%H-};
    MaxPos: Sw_Word;
    constructor Init;
    destructor Destroy; override;
    procedure Grow(pos: Sw_word);
    procedure SetLen(pos, val: Sw_Word);
    procedure SetAttr(pos, val: Sw_Word);
    function GetLen(pos: Sw_Word): Sw_Word;
    function GetAttr(pos: Sw_Word): Sw_Word;
  end deprecated 'use TString.Object';


  PEditBuffer = ^TEditBuffer deprecated 'use TStrings';
  TEditBuffer = array[0..MaxBufLength] of char  deprecated 'use TStrings';

  PEditor = ^TEditor deprecated 'use TEditor';

  { TEditor }

  TEditor = class(TView)
  public
    HScrollBar: TScrollBar;
    VScrollBar: TScrollBar;
    Indicator: TIndicator;
    Lines: TStrings;
//    BufSize: Sw_Word deprecated 'handled by Lines';
    BufLen: Sw_Word deprecated 'handled by Lines';
//    GapLen: Sw_Word deprecated 'use CurPos';
    SelStart: TPoint;
    SelEnd: TPoint;
//    CurPtr: Sw_Word deprecated 'use CurPos';
    CurPos: TPoint;
    CursorPos: TPoint;
    Delta: TPoint;
    Limit: TPoint;
    DrawLine: Sw_Integer;
    DrawPtr: TPoint;
    DelCount: Sw_Word;
    InsCount: Sw_Word;
    Flags: longint;
    IsReadOnly: boolean;
    IsValid: boolean;
    CanUndo: boolean;
    Modified: boolean;
    Selecting: boolean;
    Overwrite: boolean;
    AutoIndent: boolean;
    NoSelect: boolean;
    TabSize: Sw_Word; { tabsize for displaying }
    BlankLine: Tpoint; { First blank line after a paragraph. }
    Word_Wrap: boolean; { Added boolean to toggle wordwrap on/off. }
    Line_Number: string[8]; { Holds line number to jump to. }
    Right_Margin: Sw_Integer; { Added integer to set right margin. }
    Tab_Settings: string[Tab_Stop_Length]; { Added string to hold tab stops. }

    constructor Create(aOwner: TGroup; var Bounds: TRect;
      AHScrollBar, AVScrollBar: TScrollBar; AIndicator: TIndicator; ABufSize: Sw_Word);
    constructor Load(aOwner: TGroup; var S: TStream);
    destructor Destroy; override;
    function BufChar(P: TPoint): char;
    function BufPtr(P: Sw_Word): Sw_Word;
    procedure ChangeBounds(var Bounds: TRect); override;
    procedure ConvertEvent(var Event: TEvent); virtual;
    function CursorVisible: boolean;
    procedure DeleteSelect;
    procedure DoneBuffer; virtual;
    procedure Draw; override;
    procedure FormatLine(out DrawBuf; LinePtr: Tpoint; aWidth: Sw_Integer;
      Colors: word); virtual;
    function GetPalette: PPalette; override;
    procedure HandleEvent(var Event: TEvent); override;
    procedure InitBuffer; virtual;
    function InsertBuffer(var Source: TStrings; Offset: TPoint;
      SLength: integer; AllowUndo, SelectText: boolean): boolean;
    function InsertFrom(Editor: TEditor): boolean; virtual;
    function InsertText(Text: string; SelectText: boolean): boolean;
    procedure ScrollTo(X, Y: Sw_Integer);
    function Search(const FindStr: string; Opts: word): boolean;
    function SetBufSize(NewSize: Sw_Word): boolean;
      virtual; deprecated 'Handled by Lines';
    procedure SetCmdState(Command: word; Enable: boolean);
    procedure SetSelect(NewStart, NewEnd: TPoint; CurStart: boolean);
    procedure SetCurPos(P: TPoint; SelectMode: byte);
    function GetLength(aStart, aEnd: Tpoint): integer;
    function MoveCharpos(P: TPoint; Count: integer): TPoint;
    procedure SetState(AState: word; Enable: boolean); override;
    procedure Store(var S: TStream); override;
    procedure TrackCursor(Center: boolean);
    procedure Undo;
    procedure UpdateCommands; virtual;
    function Valid(Command: word): boolean; override;

  private
    KeyState: integer;
    LockCount: byte;
    UpdateFlags: byte;
    Place_Marker: array [1..10] of TPoint; { Inserted array to hold place markers. }
    Search_Replace: boolean;
    { Added boolean to test for Search and Replace insertions. }

    procedure Center_Text(Select_Mode: byte);
    function CharPos(Target: TPoint): integer;
    function CharPtr(P: TPoint; Target: Sw_Integer): TPoint;
    procedure Check_For_Word_Wrap(Select_Mode: byte; Center_Cursor: boolean);
    function ClipCopy: boolean;
    procedure ClipCut;
    procedure ClipPaste;
    procedure DeleteRange(StartPtr, EndPtr: TPoint; DelSelect: boolean);
    procedure DoSearchReplace;
    procedure DoUpdate;
    function Do_Word_Wrap(Select_Mode: byte; Center_Cursor: boolean): boolean;
    procedure DrawLines(Y, Count: Sw_Integer; LinePtr: Tpoint);
    procedure Find;
    function GetMousePtr(Mouse: TPoint): TPoint;
    function HasSelection: boolean;
    procedure HideSelect;
    procedure Insert_Line(Select_Mode: byte);
    function IsClipboard: boolean;
    procedure Jump_Place_Marker(Element: byte; Select_Mode: byte);
    procedure Jump_To_Line(Select_Mode: byte);
    function LineEnd(P: TPoint): TPoint;
    function LineMove(P: TPoint; Count: Sw_Integer): TPoint;
    function LineStart(P: TPoint): TPoint;
    function LineNr(P: TPoint): integer;
    procedure Lock;
    function NewLine(Select_Mode: byte): boolean;
    function NextChar(P: TPoint): TPoint;
    function NextLine(P: TPoint): TPoint;
    function NextWord(P: TPoint): TPoint;
    procedure OnBufferChange(Sender: TObject);
    function PrevChar(P: TPoint): TPoint;
    function PrevLine(P: TPoint): TPoint;
    function PrevWord(P: TPoint): TPoint;
    procedure Reformat_Document(Select_Mode: byte; Center_Cursor: boolean);
    function Reformat_Paragraph(Select_Mode: byte; Center_Cursor: boolean): boolean;
    procedure Remove_EOL_Spaces(Select_Mode: byte);
    procedure Replace;
    procedure Scroll_Down;
    procedure Scroll_Up;
    procedure Select_Word;
    procedure SetBufLen(Length: Sw_Word);
    procedure Set_Place_Marker(Element: byte);
    procedure Set_Right_Margin;
    procedure Set_Tabs;
    procedure StartSelect;
    procedure Tab_Key(Select_Mode: byte);
    procedure ToggleInsMode;
    procedure Unlock;
    procedure Update(AFlags: byte);
    procedure Update_Place_Markers(AddCount: word; KillCount: word;
      StartPtr, EndPtr: TPoint);
  end;

  TMemoData = record
    Length: Sw_Word;
    Lines: TStrings;
  end;

  PMemo = ^TMemo deprecated 'use TMemo';

  TMemo = class(TEditor)
    constructor Load(aOwner: TGroup; var S: TStream);
    function DataSize: Sw_Word; override;
    procedure GetData(const Rec: TStream); override;
    function GetPalette: PPalette; override;
    procedure HandleEvent(var Event: TEvent); override;
    procedure SetData(const Rec: TStream); override;
    procedure Store(var S: TStream); override;
  end;

  PFileEditor = ^TFileEditor deprecated 'use TFileEditor';

  TFileEditor = class(TEditor)
  public
    FileName: string;
    constructor Create(aOwner: TGroup; var Bounds: TRect;
      AHScrollBar, AVScrollBar: TScrollBar; AIndicator: TIndicator; AFileName: string);
    constructor Load(aOwner: TGroup; var S: TStream);
    procedure DoneBuffer; override;
    procedure HandleEvent(var Event: TEvent); override;
    procedure InitBuffer; override;
    function LoadFile: boolean;
    function Save: boolean;
    function SaveAs: boolean;
    function SaveFile: boolean;
    function SetBufSize(NewSize: Sw_Word): boolean;
      override; deprecated 'Handled by Lines';
    procedure Store(var S: TStream); override;
    procedure UpdateCommands; override;
    function Valid(Command: word): boolean; override;
  end;

  PEditWindow = ^TEditWindow deprecated 'use TEditWindow';

  { TEditWindow }

  TEditWindow = class(TWindow)
    Editor: TFileEditor;
    constructor Create(aOwner: TGroup; var Bounds: TRect; FileName: string;
      ANumber: integer);
    constructor Load(aOwner: TGroup; var S: TStream);
    procedure Close; override;
    function GetTitle(MaxSize: Sw_Integer): TTitleStr; override;
    procedure HandleEvent(var Event: TEvent); override;
    procedure SizeLimits(out Min, Max: TPoint); override;
    procedure Store(var S: TStream); override;
  end;


function DefEditorDialog({%H-}Dialog: integer; {%H-}Info: string): word;
function CreateFindDialog: TDialog;
function CreateReplaceDialog: TDialog;
function JumpLineDialog: TDialog;
function ReformDocDialog: TDialog;
function RightMarginDialog: TDialog;
function TabStopDialog: TDialog;
function StdEditorDialog(Dialog: integer; Info: string): word;

const
  WordChars: set of char = ['!'..#255];


{$ifdef UNIXLF}
  LineBreak: string[2] = #10;
{$else}
  LineBreak: string[2] = #13#10;
{$endif}


  { The Allow_Reformat boolean is a programmer hook.  }
  { I've placed this here to allow programmers to     }
  { determine whether or not paragraph and document   }
  { reformatting are allowed if Word_Wrap is not      }
  { active.  Some people say don't allow, and others  }
  { say allow it.  I've left it up to the programmer. }
  { Set to FALSE if not allowed, or TRUE if allowed.  }
  Allow_Reformat: boolean = True;

  EditorDialog: TEditorDialog = {$ifdef fpc} @{$endif}DefEditorDialog;
  EditorFlags: word = efBackupFiles + efPromptOnReplace;
  FindStr: string[80] = '';
  ReplaceStr: string[80] = '';
  Clipboard: TEditor = nil;

  ToClipCmds: TCommandSet = ([cmCut, cmCopy, cmClear]);
  FromClipCmds: TCommandSet = ([cmPaste]);
  UndoCmds: TCommandSet = ([cmUndo, cmRedo]);

type
  TFindDialogRec =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
    packed
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}  record
    Find: string[80];
    Options: word;
  end;

  TReplaceDialogRec =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
    packed
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}  record
    Find: string[80];
    Replace: string[80];
    Options: word;
  end;

  TRightMarginRec =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
    packed
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}  record
    Margin_Position: string[3];
  end;

  TTabStopRec =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
    packed
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}  record
    Tab_String: string [Tab_Stop_Length];
  end;



procedure RegisterEditors;


{****************************************************************************
                              Implementation
****************************************************************************}

implementation

uses
  fv2App, fv2StdDlg, fv2MsgBox, fv2RectHelper, fv2dos{, Resource};

type
  pword = ^word;

resourcestring
  sClipboard = 'Clipboard';
  sFileCreateError = 'Error creating file %s';
  sFileReadError = 'Error reading file %s';
  sFileUntitled = 'Save untitled file?';
  sFileWriteError = 'Error writing to file %s';
  sFind = 'Find';
  sJumpTo = 'Jump To';
  sModified = ''#3'%s'#13#10#13#3'has been modified.  Save?';
  sOutOfMemory = 'Not enough memory for this operation.';
  sPasteNotPossible =
    'Wordwrap on:  Paste not possible in current margins when at end of line.';
  sReformatDocument = 'Reformat Document';
  sReformatNotPossible =
    'Paragraph reformat not possible while trying to wrap current line with current margins.';
  sReformattingTheDocument = 'Reformatting the document:';
  sReplaceNotPossible =
    'Wordwrap on:  Replace not possible in current margins when at end of line.';
  sReplaceThisOccurence = 'Replace this occurence?';
  sRightMargin = 'Right Margin';
  sSearchStringNotFound = 'Search string not found.';
  sSelectWhereToBegin = 'Please select where to begin.';
  sSetting = 'Setting:';
  sTabSettings = 'Tab Settings';
  sUnknownDialog = 'Unknown dialog requested!';
  sUntitled = 'Untitled';
  sWordWrapNotPossible =
    'Wordwrap on:  Wordwrap not possible in current margins with continuous line.';
  sWordWrapOff = 'You must turn on wordwrap before you can reformat.';

  slCaseSensitive = '~C~ase sensitive';
  slCurrentLine = '~C~urrent line';
  slEntireDocument = '~E~ntire document';
  slLineNumber = '~L~ine number';
  slNewText = '~N~ew text';
  slPromptOnReplace = '~P~rompt on replace';
  slReplace = '~R~eplace';
  slReplaceAll = '~R~eplace all';
  slTextToFind = '~T~ext to find';
  slWholeWordsOnly = '~W~hole words only';


const
  { Update flag constants. }
  ufUpdate = $01;
  ufLine = $02;
  ufView = $04;
  ufStats = $05;

  { SelectMode constants. }
  smExtend = $01;
  smDouble = $02;

  sfSearchFailed = NotFoundValue;

  { Arrays that hold all the command keys and options. }
  FirstKeys: array[0..46 * 2] of word = (46, Ord(^A), cmWordLeft,
    Ord(^B), cmReformPara,
    Ord(^C), cmPageDown,
    Ord(^D), cmCharRight,
    Ord(^E), cmLineUp,
    Ord(^F), cmWordRight,
    Ord(^G), cmDelChar,
    Ord(^H), cmBackSpace,
    Ord(^I), cmTabKey,
    Ord(^J), $FF04,
    Ord(^K), $FF02,
    Ord(^L), cmSearchAgain,
    Ord(^M), cmNewLine,
    Ord(^N), cmInsertLine,
    Ord(^O), $FF03,
    Ord(^Q), $FF01,
    Ord(^R), cmPageUp,
    Ord(^S), cmCharLeft,
    Ord(^T), cmDelWord,
    Ord(^U), cmUndo,
    Ord(^V), cmInsMode,
    Ord(^W), cmScrollUp,
    Ord(^X), cmLineDown,
    Ord(^Y), cmDelLine,
    Ord(^Z), cmScrollDown,
    kbLeft, cmCharLeft,
    kbRight, cmCharRight,
    kbCtrlLeft, cmWordLeft,
    kbCtrlRight, cmWordRight,
    kbHome, cmLineStart,
    kbEnd, cmLineEnd,
    kbCtrlHome, cmHomePage,
    kbCtrlEnd, cmEndPage,
    kbUp, cmLineUp,
    kbDown, cmLineDown,
    kbPgUp, cmPageUp,
    kbPgDn, cmPageDown,
    kbCtrlPgUp, cmTextStart,
    kbCtrlPgDn, cmTextEnd,
    kbIns, cmInsMode,
    kbDel, cmDelChar,
    kbCtrlBack, cmDelStart,
    kbShiftIns, cmPaste,
    kbShiftDel, cmCut,
    kbCtrlIns, cmCopy,
    kbCtrlDel, cmClear);

  { SCRLUP - Stop. }{ Added ^W to scroll screen up.         }
  { SCRLDN - Stop. }{ Added ^Z to scroll screen down.       }
  { REFORM - Stop. }{ Added ^B for paragraph reformatting.  }
  { PRETAB - Stop. }{ Added ^I for preset tabbing.          }
  { JLINE  - Stop. }{ Added ^J to jump to a line number.    }
  { INSLIN - Stop. }{ Added ^N to insert line at cursor.    }
  { INDENT - Stop. }{ Removed ^O and put it into ^QI.       }
  { HOMEND - Stop. }{ Added kbCtrlHome and kbCtrlEnd pages. }
  { CTRLBK - Stop. }{ Added kbCtrlBack same as ^QH.         }

  QuickKeys: array[0..21 * 2] of word = (21, Ord('0'), cmJumpMark0,
    Ord('1'), cmJumpMark1,
    Ord('2'), cmJumpMark2,
    Ord('3'), cmJumpMark3,
    Ord('4'), cmJumpMark4,
    Ord('5'), cmJumpMark5,
    Ord('6'), cmJumpMark6,
    Ord('7'), cmJumpMark7,
    Ord('8'), cmJumpMark8,
    Ord('9'), cmJumpMark9,
    Ord('A'), cmReplace,
    Ord('C'), cmTextEnd,
    Ord('D'), cmLineEnd,
    Ord('F'), cmFind,
    Ord('H'), cmDelStart,
    Ord('I'), cmIndentMode,
    Ord('L'), cmUndo,
    Ord('R'), cmTextStart,
    Ord('S'), cmLineStart,
    Ord('U'), cmReformDoc,
    Ord('Y'), cmDelEnd);

  { UNDO   - Stop. }{ Added IDE undo feature of ^QL.                  }
  { REFDOC - Stop. }{ Added document reformat feature if ^QU pressed. }
  { MARK   - Stop. }{ Added cmJumpMark# to allow place marking.       }
  { INDENT - Stop. }{ Moved IndentMode here from Firstkeys.           }

  BlockKeys: array[0..20 * 2] of word = (20, Ord('0'), cmSetMark0,
    Ord('1'), cmSetMark1,
    Ord('2'), cmSetMark2,
    Ord('3'), cmSetMark3,
    Ord('4'), cmSetMark4,
    Ord('5'), cmSetMark5,
    Ord('6'), cmSetMark6,
    Ord('7'), cmSetMark7,
    Ord('8'), cmSetMark8,
    Ord('9'), cmSetMark9,
    Ord('B'), cmStartSelect,
    Ord('C'), cmPaste,
    Ord('D'), cmSave,
    Ord('F'), cmSaveAs,
    Ord('H'), cmHideSelect,
    Ord('K'), cmCopy,
    Ord('S'), cmSave,
    Ord('T'), cmSelectWord,
    Ord('Y'), cmCut,
    Ord('X'), cmSaveDone);

  { SELWRD - Stop. }{ Added ^KT to select word only. }
  { SAVE   - Stop. }{ Added ^KD, ^KF, ^KS, ^KX key commands.   }
  { MARK   - Stop. }{ Added cmSetMark# to allow place marking. }

  FormatKeys: array[0..5 * 2] of word = (5, Ord('C'), cmCenterText,
    Ord('T'), cmCenterText,
    Ord('I'), cmSetTabs,
    Ord('R'), cmRightMargin,
    Ord('W'), cmWordWrap);

  { WRAP   - Stop. }{ Added Wordwrap feature if ^OW pressed.          }
  { RMSET  - Stop. }{ Added set right margin feature if ^OR pressed.  }
  { PRETAB - Stop. }{ Added preset tab feature if ^OI pressed.        }
  { CENTER - Stop. }{ Added center text option ^OC for a line.        }

  JumpKeys: array[0..1 * 2] of word = (1, Ord('L'), cmJumpLine);

  { JLINE - Stop. }{ Added jump to line number feature if ^JL pressed. }

  KeyMap: array[0..4] of Pointer =
    (@FirstKeys, @QuickKeys, @BlockKeys, @FormatKeys, @JumpKeys);

{ WRAP   - Stop. }{ Added @FormatKeys for new ^O? keys. }
{ PRETAB - Stop. }{ Added @FormatKeys for new ^O? keys. }
{ JLINE  - Stop. }{ Added @JumpKeys for new ^J? keys.   }
{ CENTER - Stop. }{ Added @FormatKeys for new ^O? keys. }


{****************************************************************************
                                 Dialogs
****************************************************************************}

function DefEditorDialog(Dialog: integer; Info: string): word;
begin
  Result := cmCancel;
end; { DefEditorDialog }


function CreateFindDialog: TDialog;
var
  D: TDialog;
  Control: TView;
  R: TRect;
begin
  R.Assign(0, 0, 38, 12);
  D := TDialog.Create(nil, R, sFind);
  with D do
  begin
    Options := Options or ofCentered;

    R.Assign(3, 3, 32, 4);
    Control := TInputLine.Create(D, R, 80);
    Control.HelpCtx := hcDFindText;
    Insert(Control);
    R.Assign(2, 2, 15, 3);
    Insert(TLabel.Create(D, R, slTextToFind, Control));
    R.Assign(32, 3, 35, 4);
    Insert(THistory.Create(D, R, TInputLine(Control), 10));

    R.Assign(3, 5, 35, 7);
    Control := TCheckBoxes.Create(D, R, [slCaseSensitive, slWholeWordsOnly]);
    Control.HelpCtx := hcCCaseSensitive;
    Insert(Control);

    R.Assign(14, 9, 24, 11);
    Control := TButton.Create(D, R, slOK, cmOk, bfDefault);
    Control.HelpCtx := hcDOk;
    Insert(Control);

    Inc(R.A.X, 12);
    Inc(R.B.X, 12);
    Control := TButton.Create(D, R, slCancel, cmCancel, bfNormal);
    Control.HelpCtx := hcDCancel;
    Insert(Control);

    SelectNext(False);
  end;
  Result := D;
end;


function CreateReplaceDialog: TDialog;
var
  D: TDialog;
  Control: TView;
  R: TRect;
begin
  R.Assign(0, 0, 40, 16);
  D := TDialog.Create(nil, R, slReplace);
  with D do
  begin
    Options := Options or ofCentered;

    R.Assign(3, 3, 34, 4);
    Control := TInputLine.Create(D, R, 80);
    Control.HelpCtx := hcDFindText;
    Insert(Control);
    R.Assign(2, 2, 15, 3);
    Insert(TLabel.Create(D, R, slTextToFind, Control));
    R.Assign(34, 3, 37, 4);
    Insert(THistory.Create(D, R, TInputLine(Control), 10));

    R.Assign(3, 6, 34, 7);
    Control := TInputLine.Create(D, R, 80);
    Control.HelpCtx := hcDReplaceText;
    Insert(Control);
    R.Assign(2, 5, 12, 6);
    Insert(TLabel.Create(D, R, slNewText, Control));
    R.Assign(34, 6, 37, 7);
    Insert(THistory.Create(D, R, TInputLine(Control), 11));

    R.Assign(3, 8, 37, 12);
    Control := TCheckBoxes.Create(D, R, [slCasesensitive, slWholewordsonly,
      slPromptonreplace, slReplaceall]);
    Control.HelpCtx := hcCCaseSensitive;
    Insert(Control);

    R.Assign(8, 13, 18, 15);
    Control := TButton.Create(D, R, slOK, cmOk, bfDefault);
    Control.HelpCtx := hcDOk;
    Insert(Control);

    R.Assign(22, 13, 32, 15);
    Control := TButton.Create(D, R, slCancel, cmCancel, bfNormal);
    Control.HelpCtx := hcDCancel;
    Insert(Control);

    SelectNext(False);
  end;
  Result := D;
end;


function JumpLineDialog: TDialog;
var
  D: TDialog;
  R: TRect;
  Control: TView;
begin
  R.Assign(0, 0, 26, 8);
  D := TDialog.Create(nil, R, sJumpTo);
  with D do
  begin
    Options := Options or ofCentered;

    R.Assign(3, 2, 15, 3);
    Control := TStaticText.Create(D, R, slLineNumber);
    Insert(Control);

    R.Assign(15, 2, 21, 3);
    Control := TInputLine.Create(D, R, 4);
    Control.HelpCtx := hcDLineNumber;
    Insert(Control);

    R.Assign(21, 2, 24, 3);
    Insert(THistory.Create(D, R, TInputLine(Control), 12));

    R.Assign(2, 5, 12, 7);
    Control := TButton.Create(D, R, slOK, cmOK, bfDefault);
    Control.HelpCtx := hcDOk;
    Insert(Control);

    R.Assign(14, 5, 24, 7);
    Control := TButton.Create(D, R, slCancel, cmCancel, bfNormal);
    Control.HelpCtx := hcDCancel;
    Insert(Control);

    SelectNext(False);
  end;
  Result := D;
end; { JumpLineDialog }


function ReformDocDialog: TDialog;
  { This is a local function that brings up a dialog box  }
  { that asks where to start reformatting the document.   }
var
  R: TRect;
  D: TDialog;
  Control: TView;
begin
  R.Assign(0, 0, 32, 11);
  D := TDialog.Create(nil, R, sReformatDocument);
  with D do
  begin
    Options := Options or ofCentered;

    R.Assign(2, 2, 30, 3);
    Control := TStaticText.Create(D, R, sSelectWhereToBegin);
    Insert(Control);

    R.Assign(3, 3, 29, 4);
    Control := TStaticText.Create(D, R, sReformattingTheDocument);
    Insert(Control);

    R.Assign(50, 5, 68, 6);
    Control := TLabel.Create(D, R, sReformatDocument, Control);
    Insert(Control);

    R.Assign(5, 5, 26, 7);
    Control := TRadioButtons.Create(D, R, [slCurrentLine, slEntireDocument]);
    Control.HelpCtx := hcDReformDoc;
    Insert(Control);

    R.Assign(4, 8, 14, 10);
    Control := TButton.Create(D, R, slOK, cmOK, bfDefault);
    Control.HelpCtx := hcDOk;
    Insert(Control);

    R.Assign(17, 8, 27, 10);
    Control := TButton.Create(D, R, slCancel, cmCancel, bfNormal);
    Control.HelpCtx := hcDCancel;
    Insert(Control);

    SelectNext(False);
  end;
  Result := D;
end; { ReformDocDialog }


function RightMarginDialog: TDialog;
  { This is a local function that brings up a dialog box }
  { that allows the user to change the Right_Margin.     }
var
  R: TRect;
  D: TDialog;
  Control: TView;
begin
  R.Assign(0, 0, 26, 8);
  D := TDialog.Create(nil, R, sRightMargin);
  with D do
  begin
    Options := Options or ofCentered;

    R.Assign(5, 2, 13, 3);
    Control := TStaticText.Create(D, R, sSetting);
    Insert(Control);

    R.Assign(13, 2, 18, 3);
    Control := TInputLine.Create(D, R, 3);
    Control.HelpCtx := hcDRightMargin;
    Insert(Control);

    R.Assign(18, 2, 21, 3);
    Insert(THistory.Create(D, R, TInputLine(Control), 13));

    R.Assign(2, 5, 12, 7);
    Control := TButton.Create(D, R, slOK, cmOK, bfDefault);
    Control.HelpCtx := hcDOk;
    Insert(Control);

    R.Assign(14, 5, 24, 7);
    Control := TButton.Create(D, R, slCancel, cmCancel, bfNormal);
    Control.HelpCtx := hcDCancel;
    Insert(Control);

    SelectNext(False);
  end;
  Result := D;
end; { RightMarginDialog; }


function TabStopDialog: TDialog;
  { This is a local function that brings up a dialog box }
  { that allows the user to set their own tab stops.     }
var
  Index: Sw_Integer;       { Local Indexing variable.                 }
  R: TRect;
  D: TDialog;
  Control: TView;
  Tab_Stop: string[2];        { Local string to print tab column number. }
begin
  R.Assign(0, 0, 80, 8);
  D := TDialog.Create(nil, R, sTabSettings);
  with D do
  begin
    Options := Options or ofCentered;

    R.Assign(2, 2, 77, 3);
    Control := TStaticText.Create(D, R,
      ' ....|....|....|....|....|....|....|....|....|....|....|....|....|....|....');
    Insert(Control);

    for Index := 1 to 7 do
    begin
      R.Assign(Index * 10 + 1, 1, Index * 10 + 3, 2);
      Str(Index * 10, Tab_Stop);
      Control := TStaticText.Create(D, R, Tab_Stop);
      Insert(Control);
    end;

    R.Assign(2, 3, 78, 4);
    Control := TInputLine.Create(D, R, 74);
    Control.HelpCtx := hcDTabStops;
    Insert(Control);

    R.Assign(38, 5, 41, 6);
    Insert(THistory.Create(D, R, TInputLine(Control), 14));

    R.Assign(27, 5, 37, 7);
    Control := TButton.Create(D, R, slOK, cmOK, bfDefault);
    Control.HelpCtx := hcDOk;
    Insert(Control);

    R.Assign(42, 5, 52, 7);
    Control := TButton.Create(D, R, slCancel, cmCancel, bfNormal);
    Control.HelpCtx := hcDCancel;
    Insert(Control);
    SelectNext(False);
  end;
  Result := D;
end { TabStopDialog };


function StdEditorDialog(Dialog: integer; Info: string): word;
var
  R: TRect;
  T: TPoint;
  Value: longint;
begin
  case Dialog of
    edOutOfMemory:
      Result := MessageBox(sOutOfMemory, [], mfError + mfOkButton);
    edReadError:
      Result := MessageBox(sFileReadError, [Info], mfError + mfOkButton);
    edWriteError:
      Result := MessageBox(sFileWriteError, [Info], mfError + mfOkButton);
    edCreateError:
      Result := MessageBox(sFileCreateError, [Info], mfError + mfOkButton);
    edSaveModify:
      Result := MessageBox(sModified, [Info], mfInformation + mfYesNoCancel);
    edSaveUntitled:
      Result := MessageBox(sFileUntitled, [], mfInformation + mfYesNoCancel);
    edSaveAs:
      Result := Application.ExecuteDialog(
        TFileDialog.Create(nil, '*.*', slSaveFileAs, slName, fdOkButton, 101), Info);
    edFind:
      Result := Application.ExecuteDialog(CreateFindDialog, Info);
    edSearchFailed:
      Result := MessageBox(sSearchStringNotFound, [], mfError + mfOkButton);
    edReplace:
      Result := Application.ExecuteDialog(CreateReplaceDialog, Info);
    edReplacePrompt:
    begin
      { Avoid placing the dialog on the same line as the cursor }
      R.Assign(0, 1, 40, 8);
      R.Move((Desktop.Size.X - R.B.X) div 2, 0);
      Desktop.MakeGlobal(R.B, T);
      Inc(T.Y);

      if TryStrToInt(Info, Value) and (Value <= T.Y) then
        R.Move(0, Desktop.Size.Y - R.B.Y - 2);
      Result := MessageBoxRect(R, sReplaceThisOccurence, [],
        mfYesNoCancel + mfInformation);
    end;
    edJumpToLine:
      Result := Application.ExecuteDialog(JumpLineDialog, Info);
    edSetTabStops:
      Result := Application.ExecuteDialog(TabStopDialog, Info);
    edPasteNotPossible:
      Result := MessageBox(sPasteNotPossible, [], mfError + mfOkButton);
    edReformatDocument:
      Result := Application.ExecuteDialog(ReformDocDialog, Info);
    edReformatNotAllowed:
      Result := MessageBox(sWordWrapOff, [], mfError + mfOkButton);
    edReformNotPossible:
      Result := MessageBox(sReformatNotPossible, [], mfError + mfOkButton);
    edReplaceNotPossible:
      Result := MessageBox(sReplaceNotPossible, [], mfError + mfOkButton);
    edRightMargin:
      Result := Application.ExecuteDialog(RightMarginDialog, Info);
    edWrapNotPossible:
      Result := MessageBox(sWordWrapNotPossible, [], mfError + mfOKButton);
    else
      Result := MessageBox(sUnknownDialog, [], mfError + mfOkButton);
  end;
end;


{****************************************************************************
                                 Helpers
****************************************************************************}

function CountLines(var Buf; Count: sw_Word): sw_Integer;
var
  p: PChar;
  Lines: sw_word;
begin
  p := PChar(@buf);
  Lines := 0;
  while (Count > 0) do
  begin
    if p^ in [#10, #13] then
    begin
      Inc(Lines);
      if Ord((p + 1)^) + Ord(p^) = 23 then
      begin
        Inc(p);
        Dec(Count);
        if Count = 0 then
          break;
      end;
    end;
    Inc(p);
    Dec(Count);
  end;
  Result := Lines;
end;


procedure GetLimits(var Buf; Count: sw_Word; var lim: TPoint);
{ Get the limits needed for Buf, its an extended version of countlines (lim.y),
  which also gets the maximum line length in lim.x }
var
  p: PChar;
  len: sw_word;
begin
  lim.x := 0;
  lim.y := 0;
  len := 0;
  p := PChar(@buf);
  while (Count > 0) do
  begin
    if p^ in [#10, #13] then
    begin
      if len > lim.x then
        lim.x := len;
      Inc(lim.y);
      if Ord((p + 1)^) + Ord(p^) = 23 then
      begin
        Inc(p);
        Dec(Count);
      end;
      len := 0;
    end
    else
      Inc(len);
    Inc(p);
    Dec(Count);
  end;
end;


function ScanKeyMap(KeyMap: Pointer; KeyCode: word): word;
var
  p: pword;
  Count: sw_word;
begin
  p := keymap;
  Count := p^;
  Inc(p);
  while (Count > 0) do
  begin
    if (lo(p^) = lo(keycode)) and ((hi(p^) = 0) or (hi(p^) = hi(keycode))) then
    begin
      Inc(p);
      Result := p^;
      exit;
    end;
    Inc(p, 2);
    Dec(Count);
  end;
  Result := 0;
end;


type
  Btable = array[byte] of byte;

procedure BMMakeTable(const s: string; out t: Btable);
{ Makes a Boyer-Moore search table. s = the search String t = the table }
var
  x: sw_integer;
begin
  FillChar(t{%H-}, sizeof(t), length(s));
  for x := length(s) downto 1 do
    if (t[Ord(s[x])] = length(s)) then
      t[Ord(s[x])] := length(s) - x;
end;


function Scan(var Block; Size: Sw_Word; const Str: string): Sw_Word;
var
  buffer: array[0..MaxBufLength - 1] of byte Absolute block;
  s2: string;
  len, numb: Sw_Word;
  found: boolean;
  bt: Btable;
begin
  BMMakeTable(str, bt);
  len := length(str);
  s2[0] := chr(len);       { sets the length to that of the search String }
  found := False;
  numb := pred(len);
  while (not found) and (numb < (size - len)) do
  begin
    { partial match }
    if buffer[numb] = Ord(str[len]) then
    begin
      { less partial! }
      if buffer[numb - pred(len)] = Ord(str[1]) then
      begin
        move(buffer[numb - pred(len)], s2[1], len);
        if (str = s2) then
        begin
          found := True;
          break;
        end;
      end;
      Inc(numb);
    end
    else
      Inc(numb, Bt[buffer[numb]]);
  end;
  if not found then
    Result := NotFoundValue
  else
    Result := numb - pred(len);
end;


function IScan(var Block; Size: Sw_Word; const Str: string): Sw_Word;
var
  buffer: array[0..MaxBufLength - 1] of char Absolute block;
  s: string;
  len, numb, x: Sw_Word;
  found: boolean;
  bt: Btable;
  p: PChar;
  c: char;
begin
  len := length(str);
  if (len = 0) or (len > size) then
  begin
    Result := NotFoundValue;
    exit;
  end;
  { create uppercased string }
  s[0] := chr(len);
  for x := 1 to len do
  begin
    if str[x] in ['a'..'z'] then
      s[x] := chr(Ord(str[x]) - 32)
    else
      s[x] := str[x];
  end;
  BMMakeTable(s, bt);
  found := False;
  numb := pred(len);
  while (not found) and (numb < (size - len)) do
  begin
    { partial match }
    c := buffer[numb];
    if c in ['a'..'z'] then
      c := chr(Ord(c) - 32);
    if (c = s[len]) then
    begin
      { less partial! }
      p := @buffer[numb - pred(len)];
      x := 1;
      while (x <= len) do
      begin
        if not (((p^ in ['a'..'z']) and (chr(Ord(p^) - 32) = s[x])) or
          (p^ = s[x])) then
          break;
        Inc(p);
        Inc(x);
      end;
      if (x > len) then
      begin
        found := True;
        break;
      end;
      Inc(numb);
    end
    else
      Inc(numb, Bt[Ord(c)]);
  end;
  if not found then
    Result := NotFoundValue
  else
    Result := numb - pred(len);
end;


{****************************************************************************
                                 TIndicator
****************************************************************************}

constructor TIndicator.Create(aOwner: TGroup; var Bounds: TRect);
begin
  inherited Create(aOwner, Bounds);
  GrowMode := gfGrowLoY + gfGrowHiY;
end; { TIndicator.Init }


procedure TIndicator.Draw;
var
  Color: byte;
  Frame: char;
  L: array[0..1] of TVarRec;
  S: string[15];
  B: TDrawBuffer;
begin
  if State and sfDragging = 0 then
  begin
    Color := GetColor(1);
    Frame := #205;
  end
  else
  begin
    Color := GetColor(2);
    Frame := #196;
  end;
  MoveChar(B, Frame, Color, Size.X);
  { If the text has been modified, put an 'M' in the TIndicator display. }
  if Modified then
    WordRec(B[1]).Lo := 77;
  { If WordWrap is active put a 'W' in the TIndicator display. }
  if WordWrap then
    WordRec(B[2]).Lo := 87
  else
    WordRec(B[2]).Lo := byte(Frame);
  { If AutoIndent is active put an 'I' in TIndicator display. }
  if AutoIndent then
    WordRec(B[0]).Lo := 73
  else
    WordRec(B[0]).Lo := byte(Frame);
  L[0].VInteger := Location.Y + 1;
  L[1].VInteger := Location.X + 1;
  s := Format(' %d:%d ', L);
  MoveStr(B[9 - Pos(':', S)], S, Color);       { Changed original 8 to 9. }
  WriteBuf(0, 0, Size.X, 1, B);
end; { TIndicator.Draw }


function TIndicator.GetPalette: PPalette;
const
  P: string[Length(CIndicator)] = CIndicator;
begin
  Result := PPalette(@P);
end; { TIndicator.GetPalette }


procedure TIndicator.SetState(AState: word; Enable: boolean);
begin
  inherited SetState(AState, Enable);
  if AState = sfDragging then
    DrawView;
end; { TIndicator.SetState }


procedure TIndicator.SetValue(ALocation: TPoint; IsAutoIndent: boolean;
  IsModified: boolean; IsWordWrap: boolean);
begin
  if (Location.X <> ALocation.X) or (Location.Y <> ALocation.Y) or
    (AutoIndent <> IsAutoIndent) or (Modified <> IsModified) or
    (WordWrap <> IsWordWrap) then
  begin
    Location := ALocation;
    AutoIndent := IsAutoIndent;    { Added provisions to show AutoIndent. }
    Modified := IsModified;
    WordWrap := IsWordWrap;      { Added provisions to show WordWrap.   }
    DrawView;
  end;
end; { TIndicator.SetValue }


{****************************************************************************
                                 TLineInfo
****************************************************************************}

constructor TLineInfo.Init;
begin
  MaxPos := 0;
  Grow(1);
end;


destructor TLineInfo.Destroy;
begin
  FreeMem(Info, MaxPos * sizeof(TLineInfoRec));
  Info := nil;
end;


procedure TLineInfo.Grow(pos: Sw_word);
var
  NewSize: Sw_word;
  P: pointer;
begin
  NewSize := (Pos + LineInfoGrow - (Pos mod LineInfoGrow));
  GetMem(P, NewSize * sizeof(TLineInfoRec));
  FillChar(P^, NewSize * sizeof(TLineInfoRec), 0);
  Move(Info^, P^, MaxPos * sizeof(TLineInfoRec));
  Freemem(Info, MaxPos * sizeof(TLineInfoRec));
  Info := P;
end;


procedure TLineInfo.SetLen(pos, val: Sw_Word);
begin
  if pos >= MaxPos then
    Grow(Pos);
  Info^[Pos].Len := val;
end;


procedure TLineInfo.SetAttr(pos, val: Sw_Word);
begin
  if pos >= MaxPos then
    Grow(Pos);
  Info^[Pos].Attr := val;
end;


function TLineInfo.GetLen(pos: Sw_Word): Sw_Word;
begin
  Result := Info^[Pos].Len;
end;


function TLineInfo.GetAttr(pos: Sw_Word): Sw_Word;
begin
  Result := Info^[Pos].Attr;
end;



{****************************************************************************
                                 TEditor
****************************************************************************}

constructor TEditor.Create(aOwner: TGroup; var Bounds: TRect;
  AHScrollBar, AVScrollBar: TScrollBar; AIndicator: TIndicator; ABufSize: Sw_Word);
var
  Element: byte;      { Place_Marker array element to initialize array with. }
begin
  inherited Create(aOwner, Bounds);
  GrowMode := gfGrowHiX + gfGrowHiY;
  Options := Options or ofSelectable;
  Flags := EditorFlags;
  EventMask := evMouseDown + evKeyDown + evCommand + evBroadcast;
  ShowCursor;

  HScrollBar := AHScrollBar;
  VScrollBar := AVScrollBar;

  Indicator := AIndicator;
  //  BufSize := ABufSize;
  CanUndo := True;
  InitBuffer;

  if assigned(Lines) then
    IsValid := True
  else
  begin
    EditorDialog(edOutOfMemory, '');
    //      BufSize := 0;
  end;

  SetBufLen(0);

  for Element := 1 to 10 do
    Place_Marker[Element] := point(0, 0);

  Element := 1;
  while Element <= 70 do
  begin
    if Element mod 5 = 0 then
      Insert('x', Tab_Settings, Element)
    else
      Insert(#32, Tab_Settings, Element);
    Inc(Element);
  end;
  { Default Right_Margin value.  Change it if you want another. }
  Right_Margin := 76;
  TabSize := 8;
end; { TEditor.Init }


constructor TEditor.Load(aOwner: TGroup; var S: TStream);
begin
  inherited Load(aOwner, S);
  GetPeerViewPtr(S, HScrollBar);
  GetPeerViewPtr(S, VScrollBar);
  GetPeerViewPtr(S, Indicator);
  //  S.Read (BufSize, SizeOf (BufSize));
  S.Read(CanUndo, SizeOf(CanUndo));
  S.Read(AutoIndent, SizeOf(AutoIndent));
  S.Read(Line_Number, SizeOf(Line_Number));
  S.Read(Place_Marker, SizeOf(Place_Marker));
  S.Read(Right_Margin, SizeOf(Right_Margin));
  S.Read(Tab_Settings, SizeOf(Tab_Settings));
  S.Read(Word_Wrap, SizeOf(Word_Wrap));
  InitBuffer;
  if Assigned(Lines) then
    IsValid := True
  else
  begin
    EditorDialog(edOutOfMemory, '');
//    BufSize := 0;
  end;
  Lock;
//  SetBufLen(0);
end; { TEditor.Load }


destructor TEditor.Destroy;
begin
  DoneBuffer;
  inherited Destroy;
end; { TEditor.Destroy }


function TEditor.BufChar(P: TPoint): char;
begin
  Result := Lines[P.y - 1][P.x];
end;


function TEditor.BufPtr(P: Sw_Word): Sw_Word;
begin

    Result := P;
end;


procedure TEditor.Center_Text(Select_Mode: byte);
{ This procedure will center the current line of text. }
{ Centering is based on the current Right_Margin.      }
{ If the Line_Length exceeds the Right_Margin, or the  }
{ line is just a blank line, we exit and do nothing.   }
var
  //  Spaces      : array of Char;          { Array to hold spaces we'll insert. }
  //  Index       : Byte;                   { Index into Spaces array.           }
  //  Line_Length : Sw_Integer;             { Holds the length of the line.      }
  //  E,S : Sw_Word;                        { End of the current line.           }
  ActLine: string;
begin
  ActLine := Lines[CurPos.y + 1];
  { If the line is blank (only a CR/LF on it) then do noting. }
  if ActLine = '' then
    Exit;

  ActLine := Trim(ActLine);
  if length(actline) < Right_Margin then
  begin
    Lines[CurPos.y + 1] := StringOfChar(' ', (Right_Margin - Length(actline)) div
      2) + ActLine;
  end;
end; { TEditor.Center_Text }


procedure TEditor.ChangeBounds(var Bounds: TRect);
begin
  SetBounds(Bounds);
  Delta.X := Max(0, Min(Delta.X, Limit.X - Size.X));
  Delta.Y := Max(0, Min(Delta.Y, Limit.Y - Size.Y));
  Update(ufView);
end; { TEditor.ChangeBounds }


function TEditor.CharPos(Target: TPoint): integer;
var
  P, Pos: integer;
  line: string;
begin
  Pos := 0;
  line := Lines[Target.y - 1];
  P := 1;
  while P < Target.x do
  begin
    if LIne[P] = #9 then
      //Todo: Variable Tabs
      //Find next Tab
      Pos := Pos or 7;
    Inc(Pos);
    Inc(P);
  end;
  Result := Pos;
end; { TEditor.CharPos }


function TEditor.CharPtr(P: TPoint; Target: Sw_Integer): TPoint;
var
  Pos: Sw_Integer;
  line: string;
  px: integer;
begin
  Pos := 0;
  Result.y := p.y;
  line := Lines[Result.y - 1];
  px := 1;
  while (Pos < Target) and (Px < Length(line)) do
  begin
    if line[Px] = #9 then
      //Todo: Variable Tabs
      //Find next Tab
      Pos := Pos or 7;
    Inc(Pos);
    Inc(Px);
  end;
  if Pos > Target then
    Dec(Px);
  Result := P;
end; { TEditor.CharPtr }


procedure TEditor.Check_For_Word_Wrap(Select_Mode: byte; Center_Cursor: boolean);
{ This procedure checks if CurPos.X > Right_Margin. }
{ If it is, then we Do_Word_Wrap.  Simple, eh?      }
begin
  if CurPos.X > Right_Margin then
    Do_Word_Wrap(Select_Mode, Center_Cursor);
end; {Check_For_Word_Wrap}


function TEditor.ClipCopy: boolean;
begin
  Result := False;
  if Assigned(Clipboard) and (Clipboard <> Self) then
  begin
    Result := Clipboard.InsertFrom(Self);
    Selecting := False;
    Update(ufUpdate);
  end;
end; { TEditor.ClipCopy }


procedure TEditor.ClipCut;
begin
  if ClipCopy then
  begin
    DeleteRange(Self.SelStart, Self.SelEnd, True);
  end;
end; { TEditor.ClipCut }

procedure TEditor.ClipPaste;
begin
  if Assigned(Clipboard) and (Clipboard <> Self) then
  begin
    { Do not allow paste operations that will exceed }
    { the Right_Margin when Word_Wrap is active and  }
    { cursor is at EOL.                              }
    if Word_Wrap and (CurPos.X > Right_Margin) then
    begin
      EditorDialog(edPasteNotPossible, '');
      Exit;
    end;
    { The editor will not copy selected text if the CurPos }
    { is not the same value as the SelStart.  However, it  }
    { does return an InsCount.  This may, or may not, be a }
    { bug.  We don't want to update the Place_Marker if    }
    { there's no text copied.                              }
    if (CurPos.y = SelStart.y) and (CurPos.x = SelStart.x) then
      Update_Place_Markers(Clipboard.GetLength(Clipboard.SelStart, Clipboard.SelEnd),
        0,
        Clipboard.SelStart,
        Clipboard.SelEnd);
    InsertFrom(Clipboard);
  end;
end; { TEditor.ClipPaste }


procedure TEditor.ConvertEvent(var Event: TEvent);
var
  ShiftState: byte;
  Key: word;
begin
  ShiftState := GetShiftState;
  if Event.What = evKeyDown then
  begin
    if (ShiftState and $03 <> 0) and (Event.ScanCode >= $47) and
      (Event.ScanCode <= $51) then
      Event.CharCode := #0;
    Key := Event.KeyCode;
    if KeyState <> 0 then
    begin
      if (Lo(Key) >= $01) and (Lo(Key) <= $1A) then
        Inc(Key, $40);
      if (Lo(Key) >= $61) and (Lo(Key) <= $7A) then
        Dec(Key, $20);
    end;
    Key := ScanKeyMap(KeyMap[KeyState], Key);
    KeyState := 0;
    if Key <> 0 then
      if Hi(Key) = $FF then
      begin
        KeyState := Lo(Key);
        ClearEvent(Event);
      end
      else
      begin
        Event.What := evCommand;
        Event.Command := Key;
      end;
  end;
end; { TEditor.ConvertEvent }


function TEditor.CursorVisible: boolean;
begin
  Result := (CurPos.Y >= Delta.Y) and (CurPos.Y < Delta.Y + Size.Y);
end; { TEditor.CursorVisible }


procedure TEditor.DeleteRange(StartPtr, EndPtr: TPoint; DelSelect: boolean);
begin
  { This will update Place_Marker for all deletions. }
  { EXCEPT the Remove_EOL_Spaces deletion.           }
  Update_Place_Markers(0, getLength(StartPtr, EndPtr), StartPtr, EndPtr);
  if HasSelection and DelSelect then
  //  DeleteSelect
  else
  begin
    SetSelect(CurPOs, EndPtr, True);
    DeleteSelect;
    SetSelect(StartPtr, CurPos, False);
    DeleteSelect;
  end;
end; { TEditor.DeleteRange }


procedure TEditor.DeleteSelect;
begin
  InsertText('', False);
end; { TEditor.DeleteSelect }


procedure TEditor.DoneBuffer;
begin
  FreeAndNil(Lines);
end; { TEditor.DoneBuffer }


procedure TEditor.DoSearchReplace;
var
  I: Sw_Word;
  C: TPoint;
begin
  repeat
    I := cmCancel;
    if not Search(FindStr, Flags) then
    begin
      if Flags and (efReplaceAll + efDoReplace) <> (efReplaceAll + efDoReplace) then
        EditorDialog(edSearchFailed, '');
    end
    else
    if Flags and efDoReplace <> 0 then
    begin
      I := cmYes;
      if Flags and efPromptOnReplace <> 0 then
      begin
        MakeGlobal(Cursor, C);
        I := EditorDialog(edReplacePrompt, inttostr(C.x)+','+inttostr(C.y));
      end;
      if I = cmYes then
      begin
        { If Word_Wrap is active and we are at EOL }
        { disallow replace by bringing up a dialog }
        { stating that replace is not possible.    }
        if Word_Wrap and ((CurPos.X + (Length(ReplaceStr) - Length(FindStr))) >
          Right_Margin) then
          EditorDialog(edReplaceNotPossible, '')
        else
        begin
          Lock;
          Search_Replace := True;
          if length(ReplaceStr) < length(FindStr) then
            Update_Place_Markers(0,
              Length(FindStr) - Length(ReplaceStr),
              MoveCharPos(CurPos, -Length(FindStr) + Length(ReplaceStr)),
              CurPos)
          else
          if length(ReplaceStr) > length(FindStr) then
            Update_Place_Markers(Length(ReplaceStr) - Length(FindStr),
              0,
              CurPos,
              MoveCharPos(CurPos, +Length(ReplaceStr) - Length(FindStr)));
          InsertText(ReplaceStr, False);
          Search_Replace := False;
          TrackCursor(False);
          Unlock;
        end;
      end;
    end;
  until (I = cmCancel) or (Flags and efReplaceAll = 0);
end; { TEditor.DoSearchReplace }


procedure TEditor.DoUpdate;
begin
  if UpdateFlags <> 0 then
  begin
    SetCursor(CurPos.X - Delta.X, CurPos.Y - Delta.Y);
    if UpdateFlags and ufView <> 0 then
      DrawView
    else
    if UpdateFlags and ufLine <> 0 then
      DrawLines(CurPos.Y - Delta.Y, 1, LineStart(CurPos));
    if assigned(HScrollBar) then
      HScrollBar.SetParams(Delta.X, 0, Limit.X - Size.X, Size.X div 2, 1);
    if assigned(VScrollBar) then
      VScrollBar.SetParams(Delta.Y, 0, Limit.Y - Size.Y, Size.Y - 1, 1);
    if assigned(Indicator) then
      Indicator.SetValue(CurPos, AutoIndent, Modified, Word_Wrap);
    if State and sfActive <> 0 then
      UpdateCommands;
    UpdateFlags := 0;
  end;
end; { TEditor.DoUpdate }


function TEditor.Do_Word_Wrap(Select_Mode: byte; Center_Cursor: boolean): boolean;
  { This procedure does the actual wordwrap.  It always assumes the CurPos }
  { is at Right_Margin + 1.  It makes several tests for special conditions }
  { and processes those first.  If they all fail, it does a normal wrap.   }
var
  A: TPoint;          { Distance between line start and first word on line. }
  C: TPoint;          { Current pointer when we come into procedure.        }
  L: Sw_Word;          { BufLen when we come into procedure.                 }
  P: TPoint;          { Position of pointer at any given moment.            }
  S: TPoint;          { Start of a line.                                    }
begin
  Result := False;
  Select_Mode := 0;
  //if BufLen >= (BufSize - 1) then
  //  exit;
  C := CurPos;
//  L := BufLen;
  S := LineStart(CurPos);
  { If first character in the line is a space and autoindent mode is on  }
  { then we check to see if NextWord(S) exceeds the CurPos.  If it does, }
  { we set CurPos as the AutoIndent marker.  If it doesn't, we will set  }
  { NextWord(S) as the AutoIndent marker.  If neither, we set it to S.   }
  if AutoIndent and (BufChar(S) = ' ') then
  begin
    if NextWord(S).X > CurPOs.x then
      A := CurPos
    else
      A := NextWord(S);
  end
  else
    A := NextWord(S);
  { Though NewLine will remove EOL spaces, we do it here too. }
  { This catches the instance where a user may try to space   }
  { completely across the line, in which case CurPos.X = 0.   }
  Remove_EOL_Spaces(Select_Mode);
  if CurPos.X = 0 then
  begin
    NewLine(Select_Mode);
    Result := True;
    Exit;
  end;
  { At this point we have one of five situations:                               }

  { 1)  AutoIndent is on and this line is all spaces before CurPos.             }
  { 2)  AutoIndent is off and this line is all spaces before CurPos.            }
  { 3)  AutoIndent is on and this line is continuous characters before CurPos.  }
  { 4)  AutoIndent is off and this line is continuous characters before CurPos. }
  { 5)  This is just a normal line of text.                                     }

  { Conditions 1 through 4 have to be taken into account before condition 5.    }
  { First, we see if there are all spaces and/or all characters. }
  { Then we determine which one it really is.  Finally, we take  }
  { a course of action based on the state of AutoIndent.         }
  if PrevWord(CurPos).x <= S.x then
  begin
    P := PrevChar(CurPos);
    while ((BufChar(P) <> ' ') and (P.x > S.x)) do
      P := PrevChar(P);
    { We found NO SPACES.  Conditions 4 and 5 are treated the same.  }
    { We can NOT do word wrap and put up a dialog box stating such.  }
    { Delete character just entered so we don't exceed Right_Margin. }
    if P.x = S.x then
    begin
      EditorDialog(edWrapNotPossible, '');
      DeleteRange(PrevChar(Curpos), CurPos, True);
      Exit;
    end
    else
    begin
      { There are spaces.  Now find out if they are all spaces. }
      { If so, see if AutoIndent is on.  If it is, turn it off, }
      { do a NewLine, and turn it back on.  Otherwise, just do  }
      { the NewLine.  We go through all of these gyrations for  }
      { AutoIndent.  Being way out here with a preceding line   }
      { of spaces and wrapping with AutoIndent on is real dumb! }
      { However, the user expects something.  The wrap will NOT }
      { autoindent, but they had no business being here anyway! }
      P := PrevChar(CurPos);
      while ((Bufchar(P) = ' ') and (P.x > S.x)) do
        P := PrevChar(P);
      if (P.x = S.x) and (P.y = S.y) then
      begin
        if Autoindent then
        begin
          AutoIndent := False;
          NewLine(Select_Mode);
          AutoIndent := True;
        end
        else
          NewLine(Select_Mode);
      end; { AutoIndent }
    end; { P = S for spaces }
  end { P = S for no spaces }
  else { PrevWord (CurPos) <= S }
  begin
    { Hooray!  We actually had a plain old line of text to wrap!       }
    { Regardless if we are pushing out a line beyond the Right_Margin, }
    { or at the end of a line itself, the following will determine     }
    { exactly where to do the wrap and re-set the cursor accordingly.  }
    { However, if P = A then we can't wrap.  Show dialog and exit.     }
    P := Curpos;
    while getLength(S, P) > Right_Margin do
      P := PrevWord(P);
    if (P.x = A.x) and (P.y = A.y) then
    begin
      EditorDialog(edReformNotPossible, '');
      SetCurPos(P, Select_Mode);
      Exit;
    end;
    SetCurPos(P, Select_Mode);
    NewLine(Select_Mode);
  end; { PrevWord (CurPos <= S }
  { Track the cursor here (it is at CurPos.X = 0) so the view  }
  { will redraw itself at column 0.  This eliminates having it }
  { redraw starting at the current cursor and not being able   }
  { to see text before the cursor.  Of course, we also end up  }
  { redrawing the view twice, here and back in HandleEvent.    }

  { Reposition cursor so user can pick up where they left off. }
  TrackCursor(Center_Cursor);
  SetCurPos(MoveCharpos(C, -(L - BufLen)), Select_Mode);
  Result := True;
end; { TEditor.Do_Word_Wrap }


procedure TEditor.Draw;
begin
  if DrawLine <> Delta.Y then
  begin
    DrawPtr := LineMove(DrawPtr, Delta.Y - DrawLine);
    DrawLine := Delta.Y;
  end;
  DrawLines(0, Size.Y, DrawPtr);
end; { TEditor.Draw }


procedure TEditor.DrawLines(Y, Count: Sw_Integer; LinePtr: Tpoint);
var
  Color: word;
  B: array[0..MaxLineLength - 1] of Sw_Word;
begin
  Color := GetColor($0201);
  while Count > 0 do
  begin
    FormatLine(B, LinePtr, Delta.X + Size.X, Color);
    WriteBuf(0, Y, Size.X, 1, B[Delta.X]);
    LinePtr := NextLine(LinePtr);
    Inc(Y);
    Dec(Count);
  end;
end; { TEditor.DrawLines }


procedure TEditor.Find;
var
  FindRec: TFindDialogRec;
begin
  with FindRec do
  begin
    Find := FindStr;
    Options := Flags;
    if EditorDialog(edFind, FindRec.Find) <> cmCancel then
    begin
      FindStr := Find;
      Flags := Options and not efDoReplace;
      DoSearchReplace;
    end;
  end;
end; { TEditor.Find }


procedure TEditor.FormatLine(out DrawBuf; LinePtr: Tpoint; aWidth: Sw_Integer;
  Colors: word);
var
  outptr: pword;
  outcnt: integer;
  idxpos: Tpoint;
  attr: word;

  procedure FillSpace(i: Sw_Word);
  var
    w: word;
  begin
    Inc(OutCnt, i);
    w := 32 or attr;
    while (i > 0) do
    begin
      OutPtr^ := w;
      Inc(OutPtr);
      Dec(i);
    end;
  end;

  function FormatUntil(endpos: Tpoint): boolean;
  var
    p: char;
  begin
    Result := False;
    p := BufChar(idxpos);
    while endpos.x > idxpos.x do
    begin
      if OutCnt >= Width then
        exit;
      case p of
        #9:
          FillSpace(Tabsize - (outcnt mod Tabsize));
        #10, #13:
        begin
          FillSpace(Width - OutCnt);
          Result := True;
          exit;
        end;
        else
        begin
          Inc(OutCnt);
          OutPtr^ := Ord(p) or attr;
          Inc(OutPtr);
        end;
      end; { case }
      idxpos := nextChar(idxpos);
      p := BufChar(idxpos);
    end;
  end;

begin
  OutCnt := 0;
  OutPtr := @DrawBuf;
  idxPos := LinePtr;
  attr := lo(Colors) shl 8;
  // The Cursor is always between Selstart and Selend
  if FormatUntil(SelStart) then
    exit;
  // Selection from Selstart to SelEnd
  attr := hi(Colors) shl 8;
  if FormatUntil(SelEnd) then
    exit;
  // Selection from SelEnd to EOF
  attr := lo(Colors) shl 8;
  if FormatUntil(point(length(Lines[Lines.Count - 1]), Lines.Count)) then
    exit;
  { fill up until width }
  FillSpace(aWidth - OutCnt);
end; {TEditor.FormatLine}


function TEditor.GetMousePtr(Mouse: TPoint): TPoint;
begin
  MakeLocal(Mouse, Mouse);
  Mouse.X := Max(0, Min(Mouse.X, Size.X - 1));
  Mouse.Y := Max(0, Min(Mouse.Y, Size.Y - 1));
  Result := CharPtr(LineMove(DrawPtr, Mouse.Y + Delta.Y - DrawLine),
    Mouse.X + Delta.X);
end; { TEditor.GetMousePtr }


function TEditor.GetPalette: PPalette;
const
  P: string[Length(CEditor)] = CEditor;
begin
  Result := PPalette(@P);
end; { TEditor.GetPalette }


procedure TEditor.HandleEvent(var Event: TEvent);
var
  ShiftState: byte;
  CenterCursor: boolean;
  SelectMode: byte;
  D: TPoint;
  Mouse: TPoint;

  function CheckScrollBar(P: TScrollBar; var D: Sw_Integer): boolean;
  begin
    Result := False;
    if (Event.InfoPtr = P) and (P.Value <> D) then
    begin
      D := P.Value;
      Update(ufView);
      Result := True;
    end;
  end; {CheckScrollBar}

begin
  inherited HandleEvent(Event);
  ConvertEvent(Event);
  CenterCursor := not CursorVisible;
  SelectMode := 0;
  ShiftState := GetShiftState;
  if Selecting or (ShiftState and $03 <> 0) then
    SelectMode := smExtend;
  case Event.What of
    evMouseDown:
    begin
      if Event.double then
        SelectMode := SelectMode or smDouble;
      repeat
        Lock;
        if Event.What = evMouseAuto then
        begin
          MakeLocal(Event.Where, Mouse);
          D := Delta;
          if Mouse.X < 0 then
            Dec(D.X);
          if Mouse.X >= Size.X then
            Inc(D.X);
          if Mouse.Y < 0 then
            Dec(D.Y);
          if Mouse.Y >= Size.Y then
            Inc(D.Y);
          ScrollTo(D.X, D.Y);
        end;
        SetCurPos(GetMousePtr(Event.Where), SelectMode);
        SelectMode := SelectMode or smExtend;
        Unlock;
      until not MouseEvent(Event, evMouseMove + evMouseAuto);
    end; { evMouseDown }

    evKeyDown:
      case Event.CharCode of
        #32..#255:
        begin
          Lock;
          if Overwrite and not HasSelection then
            if CurPos.x < LineEnd(CurPos).x then
              SelEnd := NextChar(CurPos);
          InsertText(Event.CharCode, False);
          if Word_Wrap then
            Check_For_Word_Wrap(SelectMode, CenterCursor);
          TrackCursor(CenterCursor);
          Unlock;
        end;

        else
          Exit;
      end; { evKeyDown }

    evCommand:
      case Event.Command of
        cmFind: Find;
        cmReplace: Replace;
        cmSearchAgain: DoSearchReplace;
        else
        begin
          Lock;
          case Event.Command of
            cmCut: ClipCut;
            cmCopy: ClipCopy;
            cmPaste: ClipPaste;
            cmUndo: Undo;
            cmClear: DeleteSelect;
            cmCharLeft: SetCurPos(PrevChar(CurPos), SelectMode);
            cmCharRight: SetCurPos(NextChar(CurPos), SelectMode);
            cmWordLeft: SetCurPos(PrevWord(CurPos), SelectMode);
            cmWordRight: SetCurPos(NextWord(CurPos), SelectMode);
            cmLineStart: SetCurPos(LineStart(CurPos), SelectMode);
            cmLineEnd: SetCurPos(LineEnd(CurPos), SelectMode);
            cmLineUp: SetCurPos(LineMove(CurPos, -1), SelectMode);
            cmLineDown: SetCurPos(LineMove(CurPos, 1), SelectMode);
            cmPageUp: SetCurPos(LineMove(CurPos, -(Size.Y - 1)), SelectMode);
            cmPageDown: SetCurPos(LineMove(CurPos, Size.Y - 1), SelectMode);
            cmTextStart: SetCurPos(point(1, 1), SelectMode);
            cmTextEnd: SetCurPos(Point(length(Lines[Lines.Count - 1]), Lines.Count),
                SelectMode);
            cmNewLine: NewLine(SelectMode);
            cmBackSpace: DeleteRange(PrevChar(CurPos), CurPos, True);
            cmDelChar: DeleteRange(CurPos, NextChar(CurPos), True);
            cmDelWord: DeleteRange(CurPos, NextWord(CurPos), False);
            cmDelStart: DeleteRange(LineStart(CurPos), CurPos, False);
            cmDelEnd: DeleteRange(CurPos, LineEnd(CurPos), False);
            cmDelLine: DeleteRange(LineStart(CurPos), NextLine(CurPos), False);
            cmInsMode: ToggleInsMode;
            cmStartSelect: StartSelect;
            cmHideSelect: HideSelect;
            cmIndentMode:
            begin
              AutoIndent := not AutoIndent;
              Update(ufStats);
            end; { Added provision to update TIndicator if ^QI pressed. }
            cmCenterText: Center_Text(SelectMode);
            cmEndPage: SetCurPos(LineMove(CurPos, Delta.Y -
                CurPos.Y + Size.Y - 1), SelectMode);
            cmHomePage: SetCurPos(LineMove(CurPos, -(CurPos.Y - Delta.Y)),
                SelectMode);
            cmInsertLine: Insert_Line(SelectMode);
            cmJumpLine: Jump_To_Line(SelectMode);
            cmReformDoc: Reformat_Document(SelectMode, CenterCursor);
            cmReformPara: Reformat_Paragraph(SelectMode, CenterCursor);
            cmRightMargin: Set_Right_Margin;
            cmScrollDown: Scroll_Down;
            cmScrollUp: Scroll_Up;
            cmSelectWord: Select_Word;
            cmSetTabs: Set_Tabs;
            cmTabKey: Tab_Key(SelectMode);
            cmWordWrap:
            begin
              Word_Wrap := not Word_Wrap;
              Update(ufStats);
            end; { Added provision to update TIndicator if ^OW pressed. }
            cmSetMark0: Set_Place_Marker(10);
            cmSetMark1: Set_Place_Marker(1);
            cmSetMark2: Set_Place_Marker(2);
            cmSetMark3: Set_Place_Marker(3);
            cmSetMark4: Set_Place_Marker(4);
            cmSetMark5: Set_Place_Marker(5);
            cmSetMark6: Set_Place_Marker(6);
            cmSetMark7: Set_Place_Marker(7);
            cmSetMark8: Set_Place_Marker(8);
            cmSetMark9: Set_Place_Marker(9);
            cmJumpMark0: Jump_Place_Marker(10, SelectMode);
            cmJumpMark1: Jump_Place_Marker(1, SelectMode);
            cmJumpMark2: Jump_Place_Marker(2, SelectMode);
            cmJumpMark3: Jump_Place_Marker(3, SelectMode);
            cmJumpMark4: Jump_Place_Marker(4, SelectMode);
            cmJumpMark5: Jump_Place_Marker(5, SelectMode);
            cmJumpMark6: Jump_Place_Marker(6, SelectMode);
            cmJumpMark7: Jump_Place_Marker(7, SelectMode);
            cmJumpMark8: Jump_Place_Marker(8, SelectMode);
            cmJumpMark9: Jump_Place_Marker(9, SelectMode);
            else
              Unlock;
              Exit;
          end; { Event.Command (Inner) }
          TrackCursor(CenterCursor);
          { If the user presses any key except cmNewline or cmBackspace  }
          { we need to check if the file has been modified yet.  There   }
          { can be no spaces at the end of a line, or wordwrap doesn't   }
          { work properly.  We don't want to do this if the file hasn't  }
          { been modified because the user could be bringing in an ASCII }
          { file from an editor that allows spaces at the EOL.  If we    }
          { took them out in that scenario the "M" would appear on the   }
          { TIndicator line and the user would get upset or confused.    }
          if (Event.Command <> cmNewLine) and
            (Event.Command <> cmBackSpace) and (Event.Command <> cmTabKey) and
            Modified then
            Remove_EOL_Spaces(SelectMode);
          Unlock;
        end; { Event.Command (Outer) }
      end; { evCommand }

    evBroadcast:
      case Event.Command of
        cmScrollBarChanged:
          if (Event.InfoPtr = HScrollBar) or (Event.InfoPtr = VScrollBar) then
          begin
            CheckScrollBar(HScrollBar, Delta.X);
            CheckScrollBar(VScrollBar, Delta.Y);
          end
          else
            exit;
        else
          Exit;
      end; { evBroadcast }
    else
      exit
  end;
  ClearEvent(Event);
end; { TEditor.HandleEvent }


function TEditor.HasSelection: boolean;
begin
  Result := (SelStart.x <> SelEnd.x) or (SelStart.y <> SelEnd.y);
end; { TEditor.HasSelection }


procedure TEditor.HideSelect;
begin
  Selecting := False;
  SetSelect(CurPOs, CurPos, False);
end; { TEditor.HideSelect }


procedure TEditor.InitBuffer;
begin
  Assert(not assigned(Lines), 'TEditor.InitBuffer: Buffer is not nil');
  Lines := TStringList.Create;
  TStringList(Lines).OnChange := @OnBufferChange;
end; { TEditor.InitBuffer }


function TEditor.InsertBuffer(var Source: TStrings; Offset: TPoint;
  SLength: integer; AllowUndo, SelectText: boolean): boolean;
var
  SelLen: Sw_Word;
  DelLen: Sw_Word;
  SelLines: Sw_Word;
  lLines: Sw_Word;
//NewSize: longint;
  Line1, Line2, SourLine: string;
  Dend: TPoint;
  DChangeLine, SCopyLine, rLength: integer;
begin
  Result := True;

  Selecting := False;
  // Get SLength of actual selection
  SelLen := GetLength(SelStart, SelEnd);
  if (SelLen = 0) and (SLength = 0) then
    Exit;
  DelLen := 0;
  if AllowUndo then
  begin
  end;
  // Delete selection
  // Count selected Lines

  SelLines := SelStart.y - SelEnd.y;
  Line1 := copy(Lines[SelStart.y - 1], 1, SelStart.x - 1);
  Line2 := copy(Lines[Selend.y - 1], Selend.x, maxint);
  Dend := Selend;

  if (CurPos.x = SelEnd.x) and (CurPos.y = SelEnd.y) then
  begin
    if AllowUndo then
    begin
      // Todo: Fill Undo Buffer
      //    With Control, Selection,
    end;
    CurPos := SelStart;
    Dec(CurPos.Y, SelLines);
  end;
  if Delta.Y > CurPos.Y then
  begin
    Dec(Delta.Y, SelLines);
    if Delta.Y < CurPos.Y then
      Delta.Y := CurPos.Y;
  end;

  DChangeLine := SelStart.y;
  SCopyLine := Offset.y;
  SourLine := copy(Source[Offset.y - 1], Offset.x, SLength);
  rLength := SLength - Length(SourLine);
  while (rLength > 0) and (DChangeLine < Dend.y) do
  begin
    Lines[DChangeLine - 1] := Line1 + SourLine;
    Line1 := '';
    Inc(DChangeLine);
    Inc(SCopyLine);
    SourLine := copy(Source[SCopyLine - 1], 1, SLength - length(format('\n', [])));
    rLength := SLength - Length(SourLine);
  end;
  while (rLength > 0) do
  begin
    Lines.Insert(DChangeLine, SourLine);
    Inc(SCopyLine);
    Inc(DChangeLine);
    Inc(dend.y);
    SourLine := copy(Source[SCopyLine - 1], 1, SLength - length(format('\n', [])));
    rLength := SLength - Length(SourLine);
  end;
  while (DChangeLine < dend.y) do
  begin
    Lines.Delete(Dchangeline);
    Dec(Dend.y);
  end;

  Lines[DChangeLine] := Line1 + SourLine + Line2;

  // Update
  if (SelLines = 0) and (lLines = 0) then
    Update(ufLine)
  else
    Update(ufView);
end; { TEditor.InsertBuffer }

function TEditor.InsertFrom(Editor: TEditor): boolean;
begin
  Result := InsertBuffer(Editor.Lines, Editor.SelStart,
    Editor.Getlength(Editor.SelStart, Editor.SelEnd), CanUndo, IsClipboard);
end;  { TEditor.InsertFrom }


procedure TEditor.Insert_Line(Select_Mode: byte);
{ This procedure inserts a newline at the current cursor position }
{ if a ^N is pressed.  Unlike cmNewLine, the cursor will return   }
{ to its original position.  If the cursor was at the end of a    }
{ line, and its spaces were removed, the cursor returns to the    }
{ end of the line instead.                                        }
begin
  NewLine(Select_Mode);
  SetCurPos(LineEnd(LineMove(CurPos, -1)), Select_Mode);
end; { TEditor.Insert_Line }


function TEditor.InsertText(Text: string; SelectText: boolean): boolean;
var
  sl: TStrings;
begin
  if not Search_Replace then
    Update_Place_Markers(Length(Text), 0, Self.SelStart, Self.SelEnd);
  sl := TStringList.Create;
  sl.Text := Text;
  Result := InsertBuffer(sl, point(1, 1), Length(Text), CanUndo, SelectText);
  FreeAndNil(sl);
end; { TEditor.InsertText }


function TEditor.IsClipboard: boolean;
begin
  Result := Clipboard = Self;
end; { TEditor.IsClipboard }


procedure TEditor.Jump_Place_Marker(Element: byte; Select_Mode: byte);
{ This procedure jumps to a place marker if ^Q# is pressed.  }
{ We don't go anywhere if Place_Marker[Element] is not zero. }
begin
  if (not IsClipboard) and (Place_Marker[Element].x <> 0) and
    (Place_Marker[Element].y <> 0) then
    SetCurPos(Place_Marker[Element], Select_Mode);
end; { TEditor.Jump_Place_Marker }


procedure TEditor.Jump_To_Line(Select_Mode: byte);
{ This function brings up a dialog box that allows }
{ the user to select a line number to jump to.     }
var
//  Code: integer;         { Used for Val conversion.      }
  Temp_Value: longint;         { Holds converted dialog value. }
begin
  if EditorDialog(edJumpToLine, Line_Number) <> cmCancel then
  begin
    { Convert the Line_Number string to an interger. }
    { Put it into Temp_Value.  If the number is not  }
    { in the range 1..9999 abort.  If the number is  }
    { our current Y position, abort.  Otherwise,     }
    { go to top of document, and jump to the line.   }
    { There are faster methods.  This one's easy.    }
    { Note that CurPos.Y is always 1 less than what  }
    { the TIndicator line says.                      }
    if trystrtoint(Line_Number, Temp_Value) then
    if (Temp_Value < 1) or (Temp_Value > 9999999) then
      Exit;
    if Temp_Value = CurPos.Y + 1 then
      Exit;
    SetCurPos(point(1, 1), Select_Mode);
    SetCurPos(LineMove(CurPos, Temp_Value - 1), Select_Mode);
  end;
end; {TEditor.Jump_To_Line}


function TEditor.LineEnd(P: TPoint): TPoint;
//var
//  start, i: Sw_word;
//  pc: PChar;
begin
  Result.y := p.y;
  Result.x := length(Lines[Result.y - 1]) + 1;
end; { TEditor.LineEnd }


function TEditor.LineMove(P: TPoint; Count: Sw_Integer): TPoint;
var
  Pos: Sw_Integer;
  I: TPoint;
begin
  I := P;
  P := LineStart(P);
  Pos := CharPos(P);
  while Count <> 0 do
  begin
    I := P;
    if Count < 0 then
    begin
      P := PrevLine(P);
      Inc(Count);
    end
    else
    begin
      P := NextLine(P);
      Dec(Count);
    end;
  end;
  if (P.y <> I.y) or (P.x <> I.x) then
    P := CharPtr(P, Pos);
  Result := P;
end; { TEditor.LineMove }


function TEditor.LineStart(P: TPoint): TPoint;

begin
  Result.y := p.y;
  Result.x := 1;
end; { TEditor.LineStart }


function TEditor.LineNr(P: TPoint): integer;

begin
  Result := p.y;
end;


procedure TEditor.Lock;
begin
  Inc(LockCount);
  TStringList(Lines).BeginUpdate;
end; { TEditor.Lock }


function TEditor.NewLine(Select_Mode: byte): boolean;
var
  I: Sw_Word;          { Used to track spaces for AutoIndent.                 }
  //P: Sw_Word;          { Position of Cursor when we arrive and after Newline. }
begin
  i := 0;
  //  Remove_EOL_Spaces (Select_Mode);
  while (I < Curpos.x) and (Lines[curpos.y - 1][I] in [#9, ' ']) do
    Inc(I);
  Lines.Insert(curpos.y - 1, '');
  if AutoIndent then
    Lines[curpos.y] := copy(Lines[curpos.y - 1], 1, I);
  Inc(curpos.y);
  Curpos := LineEnd(Curpos);
  Result := True;
end; { TEditor.NewLine }


function TEditor.NextChar(P: TPoint): TPoint;
//var
//  pc: PChar;
begin
  Result := p;
  if Result.x < length(Lines[Result.y - 1]) then
    Inc(Result.x)
  else
  if Result.y < Lines.Count - 1 then
  begin
    Inc(Result.y);
    Result.x := 1;
  end;
end; { TEditor.NextChar }


function TEditor.NextLine(P: TPoint): TPoint;
begin
  Result := NextChar(LineEnd(P));
end; { TEditor.NextLine }


function TEditor.NextWord(P: TPoint): TPoint;
begin
  { skip word }
  Result := p;
  while ((Result.y < Lines.Count - 1) or (Result.x < length(Lines[P.y - 1]))) and
    (BufChar(Result) in WordChars) do
    Result := NextChar(Result);
  { skip spaces }
  while ((Result.y < Lines.Count - 1) or (Result.x < length(Lines[P.y - 1]))) and
    not (BufChar(Result) in WordChars) do
    Result := NextChar(Result);
end; { TEditor.NextWord }

procedure TEditor.OnBufferChange(Sender: TObject);
begin

end;


function TEditor.PrevChar(P: TPoint): TPoint;
//var
//  pc: PChar;
begin
  Result := p;
  if Result.x > 1 then
    Dec(Result.x)
  else
  if Result.y > 1 then
  begin
    Dec(Result.y);
    Result.x := length(Lines[Result.y - 1]);
  end;
end; { TEditor.PrevChar }


function TEditor.PrevLine(P: TPoint): TPoint;
begin
  Result := LineStart(PrevChar(P));
end; { TEditor.PrevLine }


function TEditor.PrevWord(P: TPoint): TPoint;
begin
  { skip spaces }
  Result := p;
  while ((Result.x > 1) or (Result.y > 1)) and not
    (BufChar(PrevChar(Result)) in WordChars) do
    Result := PrevChar(Result);
  { skip word }
  while ((Result.x > 1) or (Result.y > 1)) and
    (BufChar(PrevChar(Result)) in WordChars) do
    Result := PrevChar(Result);
end; { TEditor.PrevWord }


procedure TEditor.Reformat_Document(Select_Mode: byte; Center_Cursor: boolean);
{ This procedure will do a reformat of the entire document, or just    }
{ from the current line to the end of the document, if ^QU is pressed. }
{ It simply brings up the correct dialog box, and then calls the       }
{ TEditor.Reformat_Paragraph procedure to do the actual reformatting.  }
const
  efCurrentLine = $0000;  { Radio button #1 selection for dialog box.  }
  efWholeDocument = $0001;  { Radio button #2 selection for dialog box.  }
var
  Reformat_Options: word;  { Holds the dialog options for reformatting. }
begin
  { Check if Word_Wrap is toggled on.  If NOT on, check if programmer }
  { allows reformatting of document and if not show user dialog that  }
  { says reformatting is not permissable.                             }
  if not Word_Wrap then
  begin
    if not Allow_Reformat then
    begin
      EditorDialog(edReformatNotAllowed, '');
      Exit;
    end;
    Word_Wrap := True;
    Update(ufStats);
  end;
  { Default radio button option to 1st one.  Bring up dialog box. }
  Reformat_Options := efCurrentLine;
  if EditorDialog(edReformatDocument, inttostr(Reformat_Options)) <> cmCancel then
  begin
    { If the option to reformat the whole document was selected   }
    { we need to go back to start of document.  Otherwise we stay }
    { on the current line.  Call Reformat_Paragraph until we get  }
    { to the end of the document to do the reformatting.          }
    if Reformat_Options and efWholeDocument <> 0 then
      SetCurPos(point(1, 1), Select_Mode);
    Unlock;
    repeat
      Lock;
      if not Reformat_Paragraph(Select_Mode, Center_Cursor) then
        Exit;
      TrackCursor(False);
      Unlock;
    until (CurPos.y = Lines.Count - 1) and (CurPos.x >= length(Lines[CurPos.y]));
  end;
end; { TEditor.Reformat_Document }


function TEditor.Reformat_Paragraph(Select_Mode: byte; Center_Cursor: boolean): boolean;
  { This procedure will do a reformat of the current paragraph if ^B pressed. }
  { The feature works regardless if wordrap is on or off.  It also supports   }
  { the AutoIndent feature.  Reformat is not possible if the CurPos exceeds   }
  { the Right_Margin.  Right_Margin is where the EOL is considered to be.     }
//const
//  Space: array [1..2] of char = #32#32;
var
  C: TPoint;  { Position of CurPos when we come into procedure. }
  E: TPoint;  { End of a line.                                  }
  S: TPoint;  { Start of a line.                                }
begin
  Result := False;
  { Check if Word_Wrap is toggled on.  If NOT on, check if programmer }
  { allows reformatting of paragraph and if not show user dialog that }
  { says reformatting is not permissable.                             }
  if not Word_Wrap then
  begin
    if not Allow_Reformat then
    begin
      EditorDialog(edReformatNotAllowed, '');
      Exit;
    end;
    Word_Wrap := True;
    Update(ufStats);
  end;
  C := CurPos;
  E := LineEnd(CurPos);
  S := LineStart(CurPos);
  { Reformat possible only if current line is NOT blank! }
  if (E.x <> S.x) or (E.y <> S.y) then
  begin
    { Reformat is NOT possible if the first word }
    { on the line is beyond the Right_Margin.    }
    S := LineStart(CurPos);
    if NextWord(S).x - S.x >= Right_Margin - 1 then
    begin
      EditorDialog(edReformNotPossible, '');
      Exit;
    end;
    { First objective is to find the first blank line }
    { after this paragraph so we know when to stop.   }
    { That could be the end of the document.          }
    repeat
      SetCurPos(LineMove(CurPos, 1), Select_Mode);
      E := LineEnd(CurPos);
      S := LineStart(CurPos);
      BlankLine := E;
    until (((CurPos.y = Lines.Count - 1) and (CurPos.x >= length(Lines[CurPos.y]))) or
        ((E.x = S.x) and (E.y = S.y)));
    SetCurPos(C, Select_Mode);
    repeat
      { Set CurPos to LineEnd and remove the EOL spaces. }
      { Pull up the next line and remove its EOL space.  }
      { First make sure the next line is not BlankLine!  }
      { Insert spaces as required between the two lines. }
      SetCurPos(LineEnd(CurPos), Select_Mode);
      Remove_EOL_Spaces(Select_Mode);
      if (CurPos.y <> Blankline.y - 1) or
        (CurPos.x < length(Lines[Blankline.y - 2])) then
        DeleteRange(CurPos, Nextword(CurPos), True);
      Remove_EOL_Spaces(Select_Mode);
      case Lines[CurPos.Y - 1][CurPos.X - 1] of
        '!': InsertText(StringOfChar(' ', 2), False);
        '.': InsertText(StringOfChar(' ', 2), False);
        ':': InsertText(StringOfChar(' ', 2), False);
        '?': InsertText(StringOfChar(' ', 2), False);
        else
          InsertText(' ', False);
      end;
      { Reset CurPos to EOL.  While line length is > Right_Margin }
      { go Do_Word_Wrap.  If wordrap failed, exit routine.        }
      SetCurPos(LineEnd(CurPos), Select_Mode);
      while length(Lines[CurPos.y - 1]) > Right_Margin do
        if not Do_Word_Wrap(Select_Mode, Center_Cursor) then
          Exit;
      { If LineEnd - LineStart > Right_Margin then set CurPos    }
      { to Right_Margin on current line.  Otherwise we set the   }
      { CurPos to LineEnd.  This gyration sets up the conditions }
      { to test for time of loop exit.                           }
      if length(Lines[CurPos.y - 1]) > Right_Margin then
        SetCurPos(point(1 + Right_Margin, Curpos.y), Select_Mode)
      else
        SetCurPos(LineEnd(CurPos), Select_Mode);
    until (((CurPos.y = Lines.Count - 1) and (CurPos.x >= length(Lines[CurPos.y]))) or
        (CurPos.y >= BlankLine.y) or ((CurPos.y = BlankLine.y - 1) and
        (CurPos.x = length(Lines[CurPos.y]))));
  end;
  { If not at the end of the document reset CurPos to start of next line. }
  { This should be a blank line between paragraphs.                       }
  if (CurPos.y < Lines.Count - 1) or (CurPos.x < length(Lines[CurPos.y])) then
    SetCurPos(LineMove(CurPos, 1), Select_Mode);
  Result := True;
end; { TEditor.Reformat_Paragraph }


procedure TEditor.Remove_EOL_Spaces(Select_Mode: byte);
{ This procedure tests to see if there are consecutive spaces }
{ at the end of a line (EOL).  If so, we delete all spaces    }
{ after the last non-space character to the end of line.      }
{ We then reset the CurPos to where we ended up at.           }
begin
  Lines[curpos.y - 1] := TrimRight(Lines[curpos.y - 1]);
end; { TEditor.Remove_EOL_Spaces }


procedure TEditor.Replace;
var
  ReplaceRec: TReplaceDialogRec;
begin
  with ReplaceRec do
  begin
    Find := FindStr;
    Replace := ReplaceStr;
    Options := Flags;
    if EditorDialog(edReplace, ReplaceRec.Find) <> cmCancel then
    begin
      FindStr := Find;
      ReplaceStr := Replace;
      Flags := Options or efDoReplace;
      DoSearchReplace;
    end;
  end;
end; { TEditor.Replace }


procedure TEditor.Scroll_Down;
{ This procedure will scroll the screen up, and always keep      }
{ the cursor on the CurPos.Y position, but not necessarily on    }
{ the CurPos.X.  If CurPos.Y scrolls off the screen, the cursor  }
{ will stay in the upper left corner of the screen.  This will   }
{ simulate the same process in the IDE.  The CurPos.X coordinate }
{ only messes up if we are on long lines and we then encounter   }
{ a shorter or blank line beneath the current one as we scroll.  }
{ In that case, it goes to the end of the new line.              }
var
  C: TPoint;           { Position of CurPos when we enter procedure. }
  P: TPoint;           { Position of CurPos at any given time.       }
  W: TPoint; { CurPos.Y of CurPos and P ('.X and '.Y).     }
begin
  { Remember current cursor position.  Remember current CurPos.Y position. }
  { Now issue the equivalent of a [Ctrl]-[End] command so the cursor will  }
  { go to the bottom of the current screen.  Reset the cursor to this new  }
  { position and then send FALSE to TrackCursor so we fool it into         }
  { incrementing Delta.Y by only +1.  If we didn't do this it would try    }
  { to center the cursor on the screen by fiddling with Delta.Y.           }
  C := CurPos;
  W.X := CursorPos.Y;
  P := LineMove(CurPos, Delta.Y - CurPos.Y + Size.Y);
  SetCurPos(P, 0);
  TrackCursor(False);
  { Now remember where the new CursorPos.Y is.  See if distance between new }
  { CursorPos.Y and old CursorPos.Y are greater than the current screen size.  }
  { If they are, we need to move cursor position itself down by one.     }
  { Otherwise, send the cursor back to our original CurPos.              }
  W.Y := CurPos.Y;
  if W.Y - W.X > Size.Y - 1 then
    SetCurPos(LineMove(C, 1), 0)
  else
    SetCurPos(C, 0);
end; { TEditor.Scroll_Down }


procedure TEditor.Scroll_Up;
{ This procedure will scroll the screen down, and always keep    }
{ the cursor on the CurPos.Y position, but not necessarily on    }
{ the CurPos.X.  If CurPos.Y scrolls off the screen, the cursor  }
{ will stay in the bottom left corner of the screen.  This will  }
{ simulate the same process in the IDE.  The CurPos.X coordinate }
{ only messes up if we are on long lines and we then encounter   }
{ a shorter or blank line beneath the current one as we scroll.  }
{ In that case, it goes to the end of the new line.              }
var
  C: TPoint;           { Position of CurPos when we enter procedure. }
  P: TPoint;           { Position of CurPos at any given time.       }
  W: TPoint; { CurPos.Y of CurPos and P ('.X and '.Y).     }
begin
  { Remember current cursor position.  Remember current CurPos.Y position. }
  { Now issue the equivalent of a [Ctrl]-[Home] command so the cursor will }
  { go to the top of the current screen.  Reset the cursor to this new     }
  { position and then send FALSE to TrackCursor so we fool it into         }
  { decrementing Delta.Y by only -1.  If we didn't do this it would try    }
  { to center the cursor on the screen by fiddling with Delta.Y.           }
  C := CurPos;
  W.Y := CurPos.Y;
  P := LineMove(CurPos, -(CursorPos.Y - Delta.Y + 1));
  SetCurPos(P, 0);
  TrackCursor(False);
  { Now remember where the new CursorPos.Y is.  See if distance between new }
  { CursorPos.Y and old CursorPos.Y are greater than the current screen size.  }
  { If they are, we need to move the cursor position itself up by one.   }
  { Otherwise, send the cursor back to our original CurPos.              }
  W.X := CursorPos.Y;
  if W.Y - W.X > Size.Y - 1 then
    SetCurPos(LineMove(C, -1), 0)
  else
    SetCurPos(C, 0);
end; { TEditor.Scroll_Up }


procedure TEditor.ScrollTo(X, Y: Sw_Integer);
begin
  X := Max(0, Min(X, Limit.X - Size.X));
  Y := Max(0, Min(Y, Limit.Y - Size.Y));
  if (X <> Delta.X) or (Y <> Delta.Y) then
  begin
    Delta.X := X;
    Delta.Y := Y;
    Update(ufView);
  end;
end; { TEditor.ScrollTo }


function TEditor.Search(const FindStr: string; Opts: word): boolean;
var
  I: Sw_Word;
  sPos: Tpoint;
  rflags: TReplaceFlags;
  line, aFindStr: string;
begin
  Result := False;
  sPos := CurPos;
  I := 0;

  if Opts and efCaseSensitive <> 0 then
    aFindStr := uppercase(FindStr);

  repeat
    while (I = 0) and ((sPos.y < Lines.Count) or
        ((sPos.y = Lines.Count) and (sPos.x < length(Lines[sPos.y - 1])))) do
    begin
      line := Lines[sPos.y - 1];
      if Opts and efCaseSensitive <> 0 then
        I := Pos(FindStr, copy(line, spos.x, maxint))
      else
        I := Pos(aFindStr, uppercase(copy(line, spos.x, maxint)));

      if I = 0 then
      begin
        Inc(sPos.y);
        sPos.x := 1;
      end;

    end;

    // Check
    if (I <> 0) then
    begin
      if (Opts and efWholeWordsOnly = 0) or
        (((i = 1) or not (copy(line, (I - 1), 1)[1] in WordChars)) and
        ((I + Length(FindStr) = length(line)) or not
        (copy(line, (I + Length(FindStr) + 1), 1)[1] in WordChars))) then
      begin
        Lock;
        SetSelect(movecharpos(spos, I), movecharpos(spos, I + Length(FindStr)), False);
        TrackCursor(not CursorVisible);
        Unlock;
        Result := True;
        Exit;
      end
      else
        sPos.x := sPos.x + I;
    end;
  until I = 0;
end; { TEditor.Search }


procedure TEditor.Select_Word;
{ This procedure will select the a word to put into the clipboard.   }
{ I've added it just to maintain compatibility with the IDE editor.  }
{ Note that selection starts at the current cursor position and ends }
{ when a space or the end of line is encountered.                    }
var
  E: TPoint;         { End of the current line.                           }
  Select_Mode: byte;  { Allows us to turn select mode on inside procedure. }
begin
  E := LineEnd(CurPos);
  { If the cursor is on a space or at the end of a line, abort. }
  { Stupid action on users part for you can't select blanks!    }
  if (BufChar(CurPos) = #32) or ((CurPos.x = E.x) and (CurPos.y = E.y)) then
    Exit;
  { Turn on select mode and tell editor to start selecting text. }
  { As long as we have a character > a space (this is done to    }
  { exclude CR/LF pairs at end of a line) and we are NOT at the  }
  { end of a line, set the CurPos to the next character.         }
  { Once we find a space or CR/LF, selection is done and we      }
  { automatically put the selected word into the Clipboard.      }
  Select_Mode := smExtend;
  StartSelect;
  while (BufChar(NextChar(CurPos)) > #32) and (CurPos.x < E.x) do
    SetCurPos(NextChar(CurPos), Select_Mode);
  SetCurPos(NextChar(CurPos), Select_Mode);
  ClipCopy;
end; {TEditor.Select_Word }


procedure TEditor.SetBufLen(Length: Sw_Word);
begin
//  BufLen := Length;
//  GapLen := BufSize - Length;
  SelStart := point(1, 1);
  SelEnd := point(1, 1);
  CurPos := point(1, 1);
  CursorPos := point(1, 1);
  Delta := point(0, 0);
  //  GetLimits(Buffer^[GapLen], BufLen,Limit);
  Inc(Limit.X);
  Inc(Limit.Y);
  DrawLine := 0;
  DrawPtr := point(1, 1);
  DelCount := 0;
  InsCount := 0;
  Modified := False;
  Update(ufView);
end; { TEditor.SetBufLen }


function TEditor.SetBufSize(NewSize: Sw_Word): boolean;
begin
  //ReAllocMem(Buffer, NewSize);
  //BufSize := NewSize;
  Result := True;
end; { TEditor.SetBufSize }


procedure TEditor.SetCmdState(Command: word; Enable: boolean);
var
  S: TCommandSet;
begin
  S := [Command];
  if Enable and (State and sfActive <> 0) then
    EnableCommands(S)
  else
    DisableCommands(S);
end; { TEditor.SetCmdState }


function TEditor.GetLength(aStart, aEnd: Tpoint): integer;
var
  Anchor: TPoint;
begin
  Anchor := aStart;
  Result := 0;

  while Anchor.y > aEnd.y do
  begin
    Dec(Result, length(Lines[Anchor.y - 1]));
    Dec(Anchor.y);
  end;
  while Anchor.y < aEnd.y do
  begin
    Inc(Result, length(Lines[Anchor.y - 1]));
    Inc(Anchor.y);
  end;
  Result := Result + aEnd.x - aStart.x;
end; { TEditor.SetCurPos }

function TEditor.MoveCharpos(P: TPoint; Count: integer): TPoint;
var
  cc, ll: Integer;
  pp: TPoint;
begin
  cc := count;
  pp := p;
  while cc<>0 do
    if cc>0 then
    begin
      ll := length(lines[pp.y-1])+2; // Todo: Sizeof(Linefeed);
      if ll-pp.x < cc then
        begin
          pp.x := pp.x+cc;
          cc :=0;
        end
      else
        if (pp.x< ll) then
          begin
            cc := cc-ll+pp.x;
            pp.x:=ll;
          end
      else
        if (pp.x= ll) and (pp.y<lines.Count) then
          begin
            inc(pp.y);
            pp.x:=1; // Todo: Sizeof(Linefeed);
            dec(cc);
          end

    end
    else
      begin
        if pp.x > -cc then
          begin
            pp.x := pp.x+cc;
            cc :=0;
          end
        else
        if (pp.x> 1) then
          begin
            cc := cc+pp.x-1;
            pp.x:=1;
          end
        else
          if (pp.x= 1) and (pp.y>1) then
            begin
              dec(pp.y);
              pp.x:=length(lines[pp.y-1])+2; // Todo: Sizeof(Linefeed);
              inc(cc);
            end;
      end;
      result := pp;
end;


procedure TEditor.Set_Place_Marker(Element: byte);
{ This procedure sets a place marker for the CurPos if ^K# is pressed. }
begin
  if not IsClipboard then
    Place_Marker[Element] := CurPos;
end; { TEditor.Set_Place_Marker }


procedure TEditor.Set_Right_Margin;
{ This procedure will bring up a dialog box }
{ that allows the user to set Right_Margin. }
{ Values must be < MaxLineLength and > 9.   }
var
//  Code: integer;          { Used for Val conversion.      }
  Margin_Data: TRightMarginRec;  { Holds dialog results.         }
  Temp_Value: Sw_Integer;       { Holds converted dialog value. }
begin
  with Margin_Data do
  begin
    Str(Right_Margin, Margin_Position);
    if EditorDialog(edRightMargin, Margin_Position) <> cmCancel then
    begin
      if trystrtoint(Margin_Position, Temp_Value) then
      if (Temp_Value <= MaxLineLength) and (Temp_Value > 9) then
        Right_Margin := Temp_Value;
    end;
  end;
end; { TEditor.Set_Right_Margin }


procedure TEditor.SetSelect(NewStart, NewEnd: TPoint; CurStart: boolean);
var
  UFlags: byte;
  P: TPoint;

begin
  if CurStart then
    P := NewStart
  else
    P := NewEnd;
  UFlags := ufUpdate;
  if not ((NewStart.x = SelStart.x) and (NewStart.y = SelStart.y)) or
    not ((NewEnd.x = SelEnd.x) and (NewEnd.y = SelEnd.y)) then
    if not ((NewStart.x = NewEnd.x) and (NewStart.y = NewEnd.y)) or
      not ((SelStart.x = SelEnd.x) and (SelStart.y = SelEnd.y)) then
      UFlags := ufView;
  if not ((P.x = CurPos.x) and (P.y = CurPos.y)) then
  begin
    if (P.y > CurPos.y) or ((P.x = CurPos.y) and (P.x > CurPos.x)) then
    begin
      //L := getlength( CurPos, P);
      //Move (Lines[CursorPos.Y-1][CursorPos.X + GapLen], Lines[CursorPos.Y-1][CursorPos.X], L);
      //Inc (CursorPos.Y, CountLines (Lines[CursorPos.Y-1][CursorPos.X], L));
      CurPos := P;
    end
    else
    begin
      //        L := getlength(P,CurPos);
      CurPos := P;
      //Dec (CursorPos.Y, CountLines (Lines[CursorPos.Y-1][CursorPos.X], L));
      //Move (Lines[CursorPos.Y-1][CursorPos.X], Lines[CursorPos.Y-1][CursorPos.X + GapLen], L);
    end;
    DrawLine := CursorPos.Y;
    DrawPtr := LineStart(P);
    CursorPos.X := CharPos(P);
    DelCount := 0;
    InsCount := 0;
  end;
  SelStart := NewStart;
  SelEnd := NewEnd;
  Update(UFlags);
end; { TEditor.Select }

procedure TEditor.SetCurPos(P: TPoint; SelectMode: byte);
begin
  CurPos := P;
end;


procedure TEditor.SetState(AState: word; Enable: boolean);
begin
  inherited SetState(AState, Enable);
  case AState of
    sfActive:
    begin
      if assigned(HScrollBar) then
        HScrollBar.SetState(sfVisible, Enable);
      if assigned(VScrollBar) then
        VScrollBar.SetState(sfVisible, Enable);
      if assigned(Indicator) then
        Indicator.SetState(sfVisible, Enable);
      UpdateCommands;
    end;
    sfExposed: if Enable then
        Unlock;
    else
      {$IFDEF DEBUG}
      RunError(211);
      {$ELSE}
      exit
      {$ENDIF}
  end;
end; { TEditor.SetState }


procedure TEditor.Set_Tabs;
{ This procedure will bring up a dialog box }
{ that allows the user to set tab stops.    }
var
  Index: Sw_Integer;   { Index into string array. }
  Tab_Data: TTabStopRec;  { Holds dialog results.    }
begin
  with Tab_Data do
  begin
    { Assign current Tab_Settings to Tab_String.    }
    { Bring up the tab dialog so user can set tabs. }
    Tab_String := Copy(Tab_Settings, 1, Tab_Stop_Length);
    if EditorDialog(edSetTabStops, Tab_String) <> cmCancel then
    begin
      { If Tab_String comes back as empty then set Tab_Settings to nil. }
      { Otherwise, find the last character in Tab_String that is not    }
      { a space and copy Tab_String into Tab_Settings up to that spot.  }
      if Length(Tab_String) = 0 then
      begin
        FillChar(Tab_Settings, SizeOf(Tab_Settings), #0);
        Tab_Settings[0] := #0;
        Exit;
      end
      else
      begin
        Index := Length(Tab_String);
        while Tab_String[Index] <= #32 do
          Dec(Index);
        Tab_Settings := Copy(Tab_String, 1, Index);
      end;
    end;
  end;
end; { TEditor.Set_Tabs }


procedure TEditor.StartSelect;
begin
  HideSelect;
  Selecting := True;
end; { TEditor.StartSelect }


procedure TEditor.Store(var S: TStream);
begin
  inherited Store(S);
  PutPeerViewPtr(S, HScrollBar);
  PutPeerViewPtr(S, VScrollBar);
  PutPeerViewPtr(S, Indicator);
//  S.Write(BufSize, SizeOf(BufSize));
  S.Write(Canundo, SizeOf(Canundo));
  S.Write(AutoIndent, SizeOf(AutoIndent));
  S.Write(Line_Number, SizeOf(Line_Number));
  S.Write(Place_Marker, SizeOf(Place_Marker));
  S.Write(Right_Margin, SizeOf(Right_Margin));
  S.Write(Tab_Settings, SizeOf(Tab_Settings));
  S.Write(Word_Wrap, SizeOf(Word_Wrap));
end; { Editor.Store }


procedure TEditor.Tab_Key(Select_Mode: byte);
{ This function determines if we are in overstrike or insert mode,   }
{ and then moves the cursor if overstrike, or adds spaces if insert. }
var
  E: integer;                { End of current line.                }
  Index: Sw_Integer;             { Loop counter.                       }
  Position: Sw_Integer;             { CursorPos.X position.                  }
  S: integer;                { Start of current line.              }
//  Spaces: array [1..80] of char;  { Array to hold spaces for insertion. }
begin
  E := LineEnd(CurPos).x;
  S := 1;
  { Find the current horizontal cursor position. }
  { Now loop through the Tab_Settings string and }
  { find the next available tab stop.            }
  Position := CursorPos.X + 1;
  repeat
    Inc(Position);
  until (Tab_Settings[Position] <> #32) or (Position >= Ord(Tab_Settings[0]));
  E := CursorPos.X;
  Index := 1;
  { Now we enter a loop to go to the next tab position.  }
  { If we are in overwrite mode, we just move the cursor }
  { through the text to the next tab stop.  If we are in }
  { insert mode, we add spaces to the Spaces array for   }
  { the number of times we loop.                         }
  while Index < Position - E do
  begin
    if Overwrite then
    begin
      if (Position > Length(Lines[curpos.y - 1])) or
        (Position > Ord(Tab_Settings[0])) then
      begin
        SetCurPos(LineStart(LineMove(CurPos, 1)), Select_Mode);
        Exit;
      end
      else
      if (CurPos.y < Lines.Count) or (CurPos.x < length(Lines[curpos.y - 1])) then
        SetCurPos(NextChar(CurPos), Select_Mode);
    end
    else
    begin
      if (Position > Right_Margin) or (Position > Ord(Tab_Settings[0])) then
      begin
        SetCurPos(LineStart(LineMove(CurPos, 1)), Select_Mode);
        Exit;
      end
//      else
//        Spaces[Index] := #32;
    end;
    Inc(Index);
  end;
  { If we are insert mode, we insert spaces to the next tab stop.        }
  { When we're all done, the cursor will be sitting on the new tab stop. }
  if not OverWrite then
    InsertText(stringofchar(' ', Index - 1), False);
end; { TEditor.Tab_Key }


procedure TEditor.ToggleInsMode;
begin
  Overwrite := not Overwrite;
  SetState(sfCursorIns, not GetState(sfCursorIns));
end; { TEditor.ToggleInsMode }


procedure TEditor.TrackCursor(Center: boolean);
begin
  if Center then
    ScrollTo(CursorPos.X - Size.X + 1, CursorPos.Y - Size.Y div 2)
  else
    ScrollTo(Max(CursorPos.X - Size.X + 1, Min(Delta.X, CursorPos.X)),
      Max(CursorPos.Y - Size.Y + 1, Min(Delta.Y, CursorPos.Y)));
end; { TEditor.TrackCursor }


procedure TEditor.Undo;
//var
//  Length: Sw_Word;
begin
  if (DelCount <> 0) or (InsCount <> 0) then
  begin
    // ToDo: ...
    //Update_Place_Markers (DelCount, 0, CurPos, CurPos + DelCount);
    //SelStart := CurPos - InsCount;
    //SelEnd := CurPos;
    //Length := DelCount;
    //DelCount := 0;
    //InsCount := 0;
    //InsertBuffer (lines, CurPos + GapLen - Length, Length, False, True);
  end;
end; { TEditor.Undo }


procedure TEditor.Unlock;
begin
  if LockCount > 0 then
  begin
    Dec(LockCount);
    if LockCount = 0 then
    begin
      TStringList(Lines).EndUpdate;
      DoUpdate;
    end;
  end;
end; { TEditor.Unlock }


procedure TEditor.Update(AFlags: byte);
begin
  UpdateFlags := UpdateFlags or AFlags;
  if LockCount = 0 then
    DoUpdate;
end; { TEditor.Update }


procedure TEditor.UpdateCommands;
begin
  SetCmdState(cmUndo, (DelCount <> 0) or (InsCount <> 0));
  if not IsClipboard then
  begin
    SetCmdState(cmCut, HasSelection);
    SetCmdState(cmCopy, HasSelection);
    SetCmdState(cmPaste, assigned(Clipboard) and (Clipboard.HasSelection));
  end;
  SetCmdState(cmClear, HasSelection);
  SetCmdState(cmFind, True);
  SetCmdState(cmReplace, True);
  SetCmdState(cmSearchAgain, True);
end; { TEditor.UpdateCommands }


procedure TEditor.Update_Place_Markers(AddCount: word; KillCount: word;
  StartPtr, EndPtr: TPoint);
{ This procedure updates the position of the place markers }
{ as the user inserts and deletes text in the document.    }
var
  Element: byte;     { Place_Marker array element to traverse array with. }
begin
  for Element := 1 to 10 do
  begin
    if AddCount > 0 then
    begin
      if ((Place_Marker[Element].y > CurPos.y) or
        ((Place_Marker[Element].y = CurPos.y) and
        (Place_Marker[Element].x >= CurPos.x))) and (Place_Marker[Element].y > 0) then
        Place_Marker[Element] := movecharpos(Place_Marker[Element], AddCount);
    end
    else
    begin
      if (Place_Marker[Element].y > StartPtr.y) or
        ((Place_Marker[Element].y = StartPtr.y) and
        (Place_Marker[Element].x >= StartPtr.x)) then
      begin
        if ((Place_Marker[Element].y > StartPtr.y) or
          ((Place_Marker[Element].y = StartPtr.y) and
          (Place_Marker[Element].x >= StartPtr.x))) and
          ((Place_Marker[Element].y < EndPtr.y) or
          ((Place_Marker[Element].y = EndPtr.y) and
          (Place_Marker[Element].x < EndPtr.x))) then
          Place_marker[Element] := point(0, 0)
        else
        begin
          Place_Marker[Element] :=
            movecharpos(Place_Marker[Element], -KillCount + 1);
          if (Place_Marker[Element].x > 1) or (Place_Marker[Element].y > 1) then
            Place_Marker[Element] := PrevChar(Place_Marker[Element])
          else
            Place_Marker[Element] := point(0, 0);
        end;
      end;
    end;
  end;
  if AddCount > 0 then
    BlankLine := movecharpos(BlankLine, +AddCount)
  else
  begin
    BlankLine := movecharpos(BlankLine, -KillCount + 1);

    if (BlankLine.x > 1) or (BlankLine.y > 1) then
      BlankLine := PrevChar(BlankLine)
    else
      BlankLine := point(0, 0);
  end;
end; { TEditor.Update_Place_Markers }


function TEditor.Valid(Command: word): boolean;
begin
  Result := IsValid;
end; { TEditor.Valid }


{****************************************************************************
                                   TMEMO
****************************************************************************}

constructor TMemo.Load(aOwner: TGroup; var S: TStream);

begin
  inherited Load(aOwner, S);
  Lines := TStringList.Create;
  Lines.Text := s.ReadAnsiString;
end; { TMemo.Load }


function TMemo.DataSize: Sw_Word;
begin
  Result := length(Lines.text)+4 + SizeOf(Sw_Word);
end; { TMemo.DataSize }


procedure TMemo.GetData(const Rec: Tstream);

begin
  rec.WriteAnsiString(Lines.Text);
end; { TMemo.GetData }


function TMemo.GetPalette: PPalette;
const
  P: string[Length(CMemo)] = CMemo;
begin
  Result := PPalette(@P);
end; { TMemo.GetPalette }


procedure TMemo.HandleEvent(var Event: TEvent);
begin
  if (Event.What <> evKeyDown) or (Event.KeyCode <> kbTab) then
    inherited HandleEvent(Event);
end; { TMemo.HandleEvent }


procedure TMemo.SetData(const Rec: Tstream);

begin
  Lines.Text := rec.ReadAnsiString;
end; { TMemo.SetData }


procedure TMemo.Store(var S: TStream);
begin
  inherited Store(S);
  S.WriteAnsiString(Lines.Text);
end; { TMemo.Store }


{****************************************************************************
                               TFILEEDITOR
****************************************************************************}


constructor TFileEditor.Create(aOwner: TGroup; var Bounds: TRect;
  AHScrollBar, AVScrollBar: TScrollBar; AIndicator: TIndicator; AFileName: string);















begin
  inherited Create(aOwner, Bounds, AHScrollBar, AVScrollBar, AIndicator, 0);
  if AFileName <> '' then
  begin
    FileName := ExpandFileName(AFileName);
    if IsValid then
      IsValid := LoadFile;
  end;
end; { TFileEditor.Init }


constructor TFileEditor.Load(aOwner: TGroup; var S: TStream);
var
  SStart, SEnd, Curs: Tpoint;
begin
  inherited Load(aOwner, S);
//  BufSize := 0;
  FileName := S.ReadAnsiString;
  if IsValid then
    IsValid := LoadFile;
  S.Read(SStart, SizeOf(SStart));
  S.Read(SEnd, SizeOf(SEnd));
  S.Read(Curs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     , SizeOf(Curs));
  if IsValid and ((SEnd.y < Lines.Count) or ((SEnd.y = Lines.Count) and
    (SEnd.x <= length(Lines[Send.y])))) then
  begin
    SetSelect(SStart, SEnd, (Curs.x = SStart.x) and (Curs.y = SStart.y));
    TrackCursor(True);
  end;
end; { TFileEditor.Load }


procedure TFileEditor.DoneBuffer;
begin
  FreeAndNil(Lines);
end; { TFileEditor.DoneBuffer }


procedure TFileEditor.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
      case Event.Command of
        cmSave: Save;
        cmSaveAs: SaveAs;
        cmSaveDone: if Save then
            Message(TView(Owner), evCommand, cmClose, '');
        else
          Exit;
      end;
    else
      Exit;
  end;
  ClearEvent(Event);
end; { TFileEditor.HandleEvent }


procedure TFileEditor.InitBuffer;
begin
  Assert(not assigned(Lines), 'TFileEditor.InitBuffer: Buffer is not nil');
  Lines := TStringList.Create;
end; { TFileEditor.InitBuffer }


function TFileEditor.LoadFile: boolean;

begin
  Result := False;
  Lines.LoadFromFile(FileName);
end; { TFileEditor.LoadFile }


function TFileEditor.Save: boolean;
begin
  if FileName = '' then
    Result := SaveAs
  else
    Result := SaveFile;
end; { TFileEditor.Save }


function TFileEditor.SaveAs: boolean;
begin
  Result := False;
  if EditorDialog(edSaveAs, FileName) <> cmCancel then
  begin
    FileName := ExpandFileName(FileName);
    Message(tView(Owner), evBroadcast, cmUpdateTitle, '');
    Result := SaveFile;
    if IsClipboard then
      FileName := '';
  end;
end; { TFileEditor.SaveAs }


function TFileEditor.SaveFile: boolean;
var
  BackupName: string;



begin
  Result := False;
  if Flags and efBackupFiles <> 0 then
  begin
    BackupName := ChangeFileExt(FileName, '.bak');
    if FileExists(BackupName) then
      DeleteFile(BackupName);
    RenameFile(FileName, BackupName);
    InOutRes := 0;
  end;
  Lines.SaveToFile(Filename);
end; { TFileEditor.SaveFile }


function TFileEditor.SetBufSize(NewSize: Sw_Word): boolean;
//var
//  N: Sw_Word;
begin
  //SetBufSize := False;
  //if NewSize = 0 then
  //  NewSize := MinBufLength
  //else
  //  if NewSize > (MaxBufLength-MinBufLength) then
  //    NewSize := MaxBufLength
  //  else
  //    NewSize := (NewSize + (MinBufLength-1)) and (MaxBufLength and (not (MinBufLength-1)));
  //if NewSize <> BufSize then
  // begin
  //   if NewSize > BufSize then ReAllocMem(Buffer, NewSize);
  //   N := BufLen - CurPos + DelCount;
  //   Move(Buffer^[BufSize - N], Buffer^[NewSize - N], N);
  //   if NewSize < BufSize then ReAllocMem(Buffer, NewSize);
  //   BufSize := NewSize;
  //   GapLen := BufSize - BufLen;
  // end;
  Result := True;
end; { TFileEditor.SetBufSize }


procedure TFileEditor.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(FileName, Length(FileName) + 1);
  S.Write(SelStart, SizeOf(SelStart));
  S.Write(SelEnd, SizeOf(SelEnd));
  S.Write(CurPos, SizeOf(CurPos));
end; { TFileEditor.Store }


procedure TFileEditor.UpdateCommands;
begin
  inherited UpdateCommands;
  SetCmdState(cmSave, True);
  SetCmdState(cmSaveAs, True);
  SetCmdState(cmSaveDone, True);
end; { TFileEditor.UpdateCommands }


function TFileEditor.Valid(Command: word): boolean;
var
  D: integer;
begin
  if Command = cmValid then
    Result := IsValid
  else
  begin
    Result := True;
    if Modified then
    begin
      if FileName = '' then
        D := edSaveUntitled
      else
        D := edSaveModify;
      case EditorDialog(D, FileName) of
        cmYes: Result := Save;
        cmNo: Modified := False;
        cmCancel: Result := False;
        else
          Result := False;
      end;
    end;
  end;
end; { TFileEditor.Valid }


{****************************************************************************
                             TEDITWINDOW
****************************************************************************}

constructor TEditWindow.Create(aOwner: TGroup; var Bounds: TRect;
  FileName: string; ANumber: integer);
var
  HScrollBar: TScrollBar;
  VScrollBar: TScrollBar;
  Indicator: TIndicator;
  R: TRect;
begin
  inherited Create(aOwner, Bounds, '', ANumber);
  Options := Options or ofTileable;

  R.Assign(18, Size.Y - 1, Size.X - 2, Size.Y);
  HScrollBar := TScrollBar.Create(self, R);
  HScrollBar.Hide;
  Insert(HScrollBar);

  R.Assign(Size.X - 1, 1, Size.X, Size.Y - 1);
  VScrollBar := TScrollBar.Create(self, R);
  VScrollBar.Hide;
  Insert(VScrollBar);

  R.Assign(2, Size.Y - 1, 16, Size.Y);
  Indicator := TIndicator.Create(self, R);
  Indicator.Hide;
  Insert(Indicator);

  GetExtent(R);
  R.Grow(-1, -1);
  Editor := TFileEditor.Create(self, R, HScrollBar, VScrollBar, Indicator, FileName);
  Insert(Editor);
end; { TEditWindow.Init }


constructor TEditWindow.Load(aOwner: TGroup; var S: TStream);
begin
  inherited Load(aOwner, S);
  GetSubViewPtr(S, Editor);
end; { TEditWindow.Load }


procedure TEditWindow.Close;
begin
  if Editor.IsClipboard then
    Hide
  else
    inherited Close;
end; { TEditWindow.Close }


function TEditWindow.GetTitle(MaxSize: Sw_Integer): TTitleStr;
begin
  if Editor.IsClipboard then
    Result := sClipboard
  else
  if Editor.FileName = '' then
    Result := sUntitled
  else
    Result := Editor.FileName;
end; { TEditWindow.GetTile }


procedure TEditWindow.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evBroadcast) then
    { and (Event.Command = cmUpdateTitle) then }
    { Changed if statement above so I could test for cmBlugeonStats.       }
    { Stats would not show up when loading a file until a key was pressed. }
    case Event.Command of
      cmUpdateTitle:
      begin
        Frame.DrawView;
        ClearEvent(Event);
      end;
      cmBludgeonStats:
      begin
        Editor.Update(ufStats);
        ClearEvent(Event);
      end;
      else
      {$IFDEF DEBUG}
      RunError(211);
      {$ELSE}
      exit;
      {$ENDIF}
    end;
end; { TEditWindow.HandleEvent }


procedure TEditWindow.SizeLimits(out Min, Max: TPoint);
begin
  inherited SizeLimits(Min, Max);
  Min.X := 23;
end;


procedure TEditWindow.Store(var S: TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S, Editor);
end; { TEditWindow.Store }


procedure RegisterEditors;
begin
  //RegisterType (REditor);
  //RegisterType (RMemo);
  //RegisterType (RFileEditor);
  //RegisterType (RIndicator);
  //RegisterType (REditWindow);
end; { RegisterEditors }


end. { Unit NewEdit }
