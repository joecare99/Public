{*******************************************************}
{ Free Vision Runtime Library                           }
{ StdDlg Unit                                           }
{ Version: 0.1.0                                        }
{ Release Date: July 23, 1998                           }
{                                                       }
{*******************************************************}
{                                                       }
{ This unit is a port of Borland International's        }
{ StdDlg.pas unit.  It is for distribution with the     }
{ Free Pascal (FPK) Compiler as part of the 32-bit      }
{ Free Vision library.                                  }
{                                                       }
{*******************************************************}

{ Revision History

1.1a   (97/12/29)
  - fixed bug in TFileDialog.HandleEvent that prevented the user from being
    able to have an action taken automatically when the FileList was
    selected and kbEnter pressed

1.1
  - modified OpenNewFile to take a history list ID
  - implemented OpenNewFile

1.0   (1992)
  - original implementation }

unit fv2stddlg;

{
  This unit has been modified to make some functions global, apply patches
  from version 3.1 of the TVBUGS list, added TEditChDirDialog, and added
  several new global functions and procedures.
}

{$i platform.inc}

interface

uses
  classes, sysutils,  FV2Consts, fv2Common, fv2Drivers, fv2Views, fv2Dialogs, fv2Validate;

const
  MaxDir   = 255;   { Maximum length of a DirStr. }
  MaxFName = 255; { Maximum length of a FNameStr. }

  DirSeparator : Char = system.DirectorySeparator;

{$ifdef Unix}
  AllFiles = '*';
{$else}
  {$ifdef OS_AMIGA}
    AllFiles = '*';
  {$else}
    AllFiles = '*.*';
  {$endif}
{$endif}

type
  TSearchRecC = Class(TCollectionItem)
     public
     S:TSearchRec;
  end;

  { TFileInputLine is a special input line that is used by      }
  { TFileDialog that will update its contents in response to a  }
  { cmFileFocused command from a TFileList.          }

   PFileInputLine = ^TFileInputLine deprecated 'use TFileInputLine';
  TFileInputLine = Class(TInputLine)
public
    constructor Create(aOwner:TGroup;var Bounds: TRect; AMaxLen: Sw_Integer);
    procedure HandleEvent(var Event: TEvent); override;
  end;

  { TFileCollection is a collection of TSearchRec's. }

   PFileCollection = ^TFileCollection deprecated 'use TFileCollection';
  TFileCollection = Class(TCollection)
public
    function Compare(Key1, Key2: TCollectionItem): integer; virtual;
    function GetItem(var S: TStream): Pointer; virtual;
    procedure PutItem(var S: TStream; Item: Pointer); virtual;
  end;

  {#Z+}
   PFileValidator = ^TFileValidator deprecated 'use TFileValidator';
  {#Z-}
  TFileValidator = Class(TValidator)
public
  end;  { of TFileValidator }

  { TSortedListBox is a TListBox that assumes it has a     }
  { TStoredCollection instead of just a TCollection.  It will   }
  { perform an incremental search on the contents.       }

   PSortedListBox = ^TSortedListBox deprecated 'use TSortedListBox';
  TSortedListBox = Class(TListBox)
public
    SearchPos: Byte;
    {ShiftState: Byte;}
    HandleDir : boolean;
    constructor Create(aOwner:TGroup;var Bounds: TRect; ANumCols: Sw_Word;
      AScrollBar: TScrollBar);
    procedure HandleEvent(var Event: TEvent); override;
    function GetKey(var S: String): Pointer; virtual;
    procedure NewCollList(AList: TCollection); virtual;
  end;

  { TFileList is a TSortedList box that assumes it contains     }
  { a TFileCollection as its collection.  It also communicates  }
  { through broadcast messages to TFileInput and TInfoPane      }
  { what file is currently selected.             }

   PFileList = ^TFileList deprecated 'use TFileList';
  TFileList = Class(TSortedListBox)
public
    constructor Create(aOwner: TGroup; var Bounds: TRect; AScrollBar: TScrollBar);
    destructor Done; virtual;
    function DataSize: Sw_Word; override;
    procedure FocusItem(Item: Sw_Integer); override;
    procedure GetData(const Rec:TStream); override;
    function GetText(Item,MaxLen: Sw_Integer): String; override;
    function GetKey(var S: String): Pointer; override;
    procedure HandleEvent(var Event: TEvent); override;
    procedure ReadDirectory(AWildCard: string);
    procedure SetData(const Rec:TStream); override;
  end;

  { TFileInfoPane is a TView that displays the information      }
  { about the currently selected file in the TFileList     }
  { of a TFileDialog.                  }

   PFileInfoPane = ^TFileInfoPane deprecated 'use TFileInfoPane';
  TFileInfoPane = Class(TView)
public
    S: TSearchRec;
    constructor Create(aOwner:TGroup;var Bounds: TRect);
    procedure Draw; override;
    function GetPalette: PPalette; override;
    procedure HandleEvent(var Event: TEvent); override;
  end;

  { TFileDialog is a standard file name input dialog      }

  TWildStr = string;

const
  fdOkButton      = $0001;      { Put an OK button in the dialog }
  fdOpenButton    = $0002;      { Put an Open button in the dialog }
  fdReplaceButton = $0004;      { Put a Replace button in the dialog }
  fdClearButton   = $0008;      { Put a Clear button in the dialog }
  fdHelpButton    = $0010;      { Put a Help button in the dialog }
  fdNoLoadDir     = $0100;      { Do not load the current directory }
            { contents into the dialog at Init. }
            { This means you intend to change the }
            { WildCard by using SetData or store }
            { the dialog on a stream. }

type

   PFileHistory = ^TFileHistory deprecated 'use TFileHistory';
  TFileHistory = Class(THistory)
public
    CurDir : PString;
    procedure HandleEvent(var Event: TEvent);override;
    destructor Destroy; override;
    procedure AdaptHistoryToDir(Dir : string);
  end;

   PFileDialog = ^TFileDialog deprecated 'use TFileDialog';
  TFileDialog = Class(TDialog)
  private
    function GetHistoryID: Word;
    procedure SetHistoryID(AValue: Word);
public
    ilFileName: TFileInputLine;
    lvFileList: TFileList;
    FileHistory: TFileHistory;
    WildCard: TWildStr;
    DirectoryName: String;
    property HistoryID:Word read GetHistoryID Write SetHistoryID;
    constructor Create(aOwner:TGroup;AWildCard: String; const ATitle,
      InputName: String; AOptions: Word; aHistoryId: Byte);
    constructor Load(var S: TStream);
    destructor Destroy; override;
    procedure GetData(Const Rec:TStream); override;
    procedure GetFileName(var S: string);
    procedure HandleEvent(var Event: TEvent); override;
    procedure SetData(Const Rec:TStream); override;
    procedure Store(var S: TStream);override;
    function Valid(Command: Word): Boolean; override;
  private
    procedure ReadDirectory;
  end;

  { TDirEntry }

   PDirEntry = ^TDirEntry deprecated 'use TDirEntry';
  TDirEntry = class(TCollectionItem)
    public
    DisplayText: String;
    Directory: String;
  end;  { of TDirEntry }

  { TDirCollection is a collection of TDirEntry's used by       }
  { TDirListBox.                 }

   PDirCollection = ^TDirCollection deprecated 'use TDirCollection';
  TDirCollection = Class(TCollection)
public
    function GetItem(var S: TStream): Pointer; virtual;
    procedure FreeItem(Item: Pointer); virtual;
    procedure PutItem(var S: TStream; Item: Pointer); virtual;
  end;

  { TDirListBox displays a tree of directories for use in the }
  { TChDirDialog.                    }

   PDirListBox = ^TDirListBox deprecated 'use TDirListBox';
  TDirListBox = Class(TListBox)
public
    Dir: string;
    Cur: Word;
    constructor Create(aOwner: TGroup; var Bounds: TRect; AScrollBar: TScrollBar);
    destructor Destroy; override;
    function GetText(Item,MaxLen: Sw_Integer): String; override;
    procedure HandleEvent(var Event: TEvent); override;
    function IsSelected(Item: Sw_Integer): Boolean; override;
    procedure NewDirectory(var ADir: string);
    procedure NewCollList(AList: TCollection); virtual;
    procedure SetState(AState: Word; Enable: Boolean); override;
  end;

  { TChDirDialog is a standard change directory dialog. }

const
  cdNormal     = $0000; { Option to use dialog immediately }
  cdNoLoadDir  = $0001; { Option to init the dialog to store on a stream }
  cdHelpButton = $0002; { Put a help button in the dialog }

type

   PChDirDialog = ^TChDirDialog deprecated 'use TChDirDialog';
  TChDirDialog = Class(TDialog)
public
    DirInput: TInputLine;
    DirList: TDirListBox;
    OkButton: TButton;
    ChDirButton: TButton;
    constructor Create(aOwner:TGroup;AOptions: Word; HistoryId: Sw_Word);
    constructor Load(var S: TStream);
    function DataSize: Sw_Word; override;
    procedure GetData(const Rec:TStream); override;
    procedure HandleEvent(var Event: TEvent); override;
    procedure SetData(const Rec:TStream); override;
    procedure Store(var S: TStream);override;
    function Valid(Command: Word): Boolean; override;
  private
    procedure SetUpDialog;
  end;

   PEditChDirDialog = ^TEditChDirDialog deprecated 'use TEditChDirDialog';
  TEditChDirDialog = Class(TChDirDialog)
public
    { TEditChDirDialog allows setting/getting the starting directory.  The
      transfer record is a DirStr. }
    function DataSize : Sw_Word; override;
    procedure GetData (const Rec:TStream); override;
    procedure SetData (const Rec:TStream); override;
  end;  { of TEditChDirDialog }


  {#Z+}
   PDirValidator = ^TDirValidator deprecated 'use TDirValidator';
  {#Z-}
  TDirValidator = Class(TFilterValidator)
public
    constructor Init;
    function IsValid(const S: string): Boolean; override;
    function IsValidInput(var S: string; SuppressFill: Boolean): Boolean;
      override;
  end;  { of TDirValidator }


  FileConfirmFunc = function (AFile : string) : Boolean;
    { Functions of type FileConfirmFunc's are used to prompt the end user for
      confirmation of an operation.

      FileConfirmFunc's should ask the user whether to perform the desired
      action on the file named AFile.  If the user elects to perform the
      function FileConfirmFunc's return True, otherwise they return False.

      Using FileConfirmFunc's allows routines to be coded independant of the
      user interface implemented.  OWL and TurboVision are supported through
      conditional defines.  If you do not use either user interface you must
      compile this unit with the conditional define cdNoMessages and set all
      FileConfirmFunc variables to a valid function prior to calling any
      routines in this unit. }
    {#X ReplaceFile DeleteFile }


var

  ConfirmReplaceFile : FileConfirmFunc;
    { ReplaceFile returns True if the end user elects to replace the existing
      file with the new file, otherwise it returns False.

      ReplaceFile is only called when #CheckOnReplace# is True. }
    {#X DeleteFile }

  ConfirmDeleteFile : FileConfirmFunc;
    { DeleteFile returns True if the end user elects to delete the file,
      otherwise it returns False.

       DeleteFile is only called when #CheckOnDelete# is True. }
    {#X ReplaceFile }


const

  CInfoPane = #30;

  { TStream registration records }

function Contains(S1, S2: String): Boolean;
  { Contains returns true if S1 contains any characters in S2. }

function DriveValid(Drive: Char): Boolean;
  { DriveValid returns True if Drive is a valid DOS drive.  Drive valid works
    by attempting to change the current directory to Drive, then restoring
    the original directory. }

function Equal(const S1, S2: String; Count: Sw_word): Boolean;
  { Equal returns True if S1 equals S2 for up to Count characters.  Equal is
    case-insensitive. }

function GetCurDir: string;
  { GetCurDir returns the current directory.  The directory returned always
    ends with a trailing backslash '\'. }

function GetCurDrive: Char;
  { GetCurDrive returns the letter of the current drive as reported by the
    operating system. }

function IsWild(const S: String): Boolean;
  { IsWild returns True if S contains a question mark (?) or asterix (*). }

function IsList(const S: String): Boolean;
  { IsList returns True if S contains list separator (;) char }

function IsDir(const S: String): Boolean;
  { IsDir returns True if S is a valid DOS directory. }

{procedure MakeResources;}
  { MakeResources places a language specific version of all resources
    needed for the StdDlg unit to function on the RezFile using the string
    constants and variables in the Resource unit.  The Resource unit and the
    appropriate string lists must be initialized prior to calling this
    procedure. }

function NoWildChars(S: String): String;
  { NoWildChars deletes the wild card characters ? and * from the string S
    and returns the result. }

function OpenFile (var AFile : string; HistoryID : Byte) : Boolean;
  { OpenFile prompts the user to select a file using the file specifications
    in AFile as the starting file and path.  Wildcards are accepted.  If the
    user accepts a file OpenFile returns True, otherwise OpenFile returns
    False.

    Note: The file returned may or may not exist. }

function OpenNewFile (var AFile: string; HistoryID: Byte): Boolean;
  { OpenNewFile allows the user to select a directory from disk and enter a
    new file name.  If the file name entered is an existing file the user is
    optionally prompted for confirmation of replacing the file based on the
    value in #CheckOnReplace#.  If a file name is successfully entered,
    OpenNewFile returns True. }
  {#X OpenFile }

function PathValid(var Path: string): Boolean;
  { PathValid returns True if Path is a valid DOS path name.  Path may be a
    file or directory name.  Trailing '\'s are removed. }

procedure RegisterStdDlg;
  { RegisterStdDlg registers all objects in the StdDlg unit for stream
    usage. }

function SaveAs (var AFile : string; HistoryID : Word) : Boolean;
  { SaveAs prompts the user for a file name using AFile as a template.  If
    AFile already exists and CheckOnReplace is True, the user is prompted
    to replace the file.

    If a valid file name is entered SaveAs returns True, other SaveAs returns
    False. }

function SelectDir (var ADir : string; HistoryID : Byte) : Boolean;
  { SelectDir prompts the user to select a directory using ADir as the
    starting directory.  If a directory is selected, SelectDir returns True.
    The directory returned is gauranteed to exist. }

function ShrinkPath (AFile : string; MaxLen : Byte) : string;
  { ShrinkPath returns a file name with a maximu length of MaxLen.
    Internal directories are removed and replaced with elipses as needed to
    make the file name fit in MaxLen.

    AFile must be a valid path name. }

function StdDeleteFile (AFile : string) : Boolean;
  { StdDeleteFile returns True if the end user elects to delete the file,
    otherwise it returns False.

    DeleteFile is only called when CheckOnDelete is True. }

function StdReplaceFile (AFile : string) : Boolean;
  { StdReplaceFile returns True if the end user elects to replace the existing
    AFile with the new AFile, otherwise it returns False.

    ReplaceFile is only called when CheckOnReplace is True. }

function ValidFileName(var FileName: string): Boolean;
  { ValidFileName returns True if FileName is a valid DOS file name. }


const
  CheckOnReplace : Boolean = True;
    { CheckOnReplace is used by file functions.  If a file exists, it is
      optionally replaced based on the value of CheckOnReplace.

      If CheckOnReplace is False the file is replaced without asking the
      user.  If CheckOnReplace is True, the end user is asked to replace the
      file using a call to ReplaceFile.

      CheckOnReplace is set to True by default. }

  CheckOnDelete : Boolean = True;
    { CheckOnDelete is used by file and directory functions.  If a file
      exists, it is optionally deleted based on the value of CheckOnDelete.

      If CheckOnDelete is False the file or directory is deleted without
      asking the user.  If CheckOnDelete is True, the end user is asked to
      delete the file/directory using a call to DeleteFile.

      CheckOnDelete is set to True by default. }


implementation

{****************************************************************************}
{            Local Declarations              }
{****************************************************************************}

uses
  dateutils, fv2App, {Memory,} fv2HistList, fv2MsgBox, fv2RectHelper, fv2dos{, Resource};

type

  PStringRec = record
    { PStringRec is needed for properly displaying PStrings using
      MessageBox. }
    AString : PString;
  end;

resourcestring  sChangeDirectory='Change Directory';
                sDeleteFile='Delete file?'#13#10#13#3'%s';
                sDirectory='Directory';
                sDrives='Drives';
                sInvalidDirectory='Invalid directory.';
                sInvalidDriveOrDir='Invalid drive or directory.';
                sInvalidFileName='Invalid file name.';
                sOpen='Open';
                sReplaceFile='Replace file?'#13#10#13#3'%s';
                sSaveAs='Save As';
                sTooManyFiles='Too many files.';

                smApr='Apr';
                smAug='Aug';
                smDec='Dec';
                smFeb='Feb';
                smJan='Jan';
                smJul='Jul';
                smJun='Jun';
                smMar='Mar';
                smMay='May';
                smNov='Nov';
                smOct='Oct';
                smSep='Sep';

                slChDir='~C~hdir';
                slClear='C~l~ear';
                slDirectoryName='Directory ~n~ame';
                slDirectoryTree='Directory ~t~ree';
                slFiles='~F~iles';
                slReplace='~R~eplace';
                slRevert='~R~evert';

{****************************************************************************}
{ PathValid                        }
{****************************************************************************}
{$ifdef go32v2}
{$define NetDrive}
{$endif go32v2}
{$ifdef OS_WINDOWS}
{$define NetDrive}
{$endif OS_WINDOWS}

procedure RemoveDoubleDirSep(var ExpPath : String);
var
  p: longint;
{$ifdef NetDrive}
  OneDirSepRemoved: boolean;
{$endif NetDrive}
begin
  p:=pos(DirSeparator+DirSeparator,ExpPath);
{$ifdef NetDrive}
  if p=1 then
    begin
      ExpPath:=Copy(ExpPath,1,high(ExpPath));
      OneDirSepRemoved:=true;
      p:=pos(DirSeparator+DirSeparator,ExpPath);
    end
  else
    OneDirSepRemoved:=false;
{$endif NetDrive}
  while p>0 do
    begin
      ExpPath:=Copy(ExpPath,1,p)+Copy(ExpPath,p+2,high(ExpPath));
      p:=pos(DirSeparator+DirSeparator,ExpPath);
    end;
{$ifdef NetDrive}
  if OneDirSepRemoved then
    ExpPath:=DirSeparator+ExpPath;
{$endif NetDrive}
end;

function PathValid(var Path: string): Boolean;
var
  ExpPath: String;
  SR: TSearchRec;
  Doserror: LongInt;
begin
  RemoveDoubleDirSep(Path);
  ExpPath := ExpandFileName(Path);
{$ifdef HAS_DOS_DRIVES}
  if (Length(ExpPath) <= 3) then
    PathValid := DriveValid(ExpPath[1])
  else
{$endif}
  begin
    { do not change '/' into '' }
    if (Length(ExpPath)>1) and (ExpPath[Length(ExpPath)] = DirSeparator) then
      Dec(ExpPath[0]);
    // This function is called on current directories.
    // If the current dir starts with a . on Linux it is is hidden.
    // That's why we allow hidden dirs below (bug 6173)
    Doserror := FindFirst(ExpPath, faDirectory+fahidden, SR);
    PathValid := (SR.Attr and faDirectory <> 0);
{$ifdef NetDrive}
    if (DosError<>0) and (length(ExpPath)>2) and
       (ExpPath[1]='\') and (ExpPath[2]='\')then
      begin
        { Checking '\\machine\sharedfolder' directly always fails..
          rather try '\\machine\sharedfolder\*' PM }
      {$ifdef fpc}
        FindClose(SR);
      {$endif}
        Doserror := FindFirst(ExpPath+'\*',faAnyFile,SR);
        PathValid:=(DosError = 0);
      end;
{$endif NetDrive}
    {$ifdef fpc}
    FindClose(SR);
   {$endif}
  end;
end;

{****************************************************************************}
{ TDirValidator Object                        }
{****************************************************************************}
{****************************************************************************}
{ TDirValidator.Init                    }
{****************************************************************************}
constructor TDirValidator.Init;
const   { What should this list be?  The commented one doesn't allow home,
  end, right arrow, left arrow, Ctrl+XXXX, etc. }
  Chars: TCharSet = ['A'..'Z','a'..'z','.','~',':','_','-'];
{  Chars: TCharSet = [#0..#255]; }
begin
  Chars := Chars + [DirSeparator];
  if not assigned( inherited Create(Chars)) then
    Fail;
end;

{****************************************************************************}
{ TDirValidator.IsValid                      }
{****************************************************************************}
function TDirValidator.IsValid(const S: string): Boolean;
begin
{  IsValid := False; }
  IsValid := True;
end;

{****************************************************************************}
{ TDirValidator.IsValidInput                  }
{****************************************************************************}
function TDirValidator.IsValidInput(var S: string; SuppressFill: Boolean): Boolean;
begin
{  IsValid := False; }
  IsValidInput := True;
end;

{****************************************************************************}
{ TFileInputLine Object                      }
{****************************************************************************}
{****************************************************************************}
{ TFileInputLine.Init                     }
{****************************************************************************}
constructor TFileInputLine.Create(aOwner:TGroup;var Bounds: TRect; AMaxLen: Sw_Integer);
begin
  inherited Create(aOwner,Bounds, AMaxLen);
  EventMask := EventMask or evBroadcast;
end;

{****************************************************************************}
{ TFileInputLine.HandleEvent                  }
{****************************************************************************}
procedure TFileInputLine.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evBroadcast) and (Event.Command = cmFileFocused) and
    (State and sfSelected = 0) then
  with TSearchRecC(Event.InfoPtr) do begin
     if s.Attr and faDirectory <> 0 then
       begin
          Data := s.Name + DirSeparator +
            TFileDialog(Owner).WildCard;
          { PFileDialog(Owner)^.FileHistory^.AdaptHistoryToDir(
              PSearchRec(Event.InfoPtr)^.Name+DirSeparator);}
       end
     else Data := s.Name;
     DrawView;
  end;
end;

{****************************************************************************}
{ TFileCollection Object                       }
{****************************************************************************}
{****************************************************************************}
{ TFileCollection.Compare                     }
{****************************************************************************}
  function uppername(const s : string) : string;
  var
    i  : Sw_integer;
    in_name : boolean;
  begin
     in_name:=true;
     for i:=length(s) downto 1 do
      if in_name and (s[i] in ['a'..'z']) then
        uppername[i]:=char(byte(s[i])-32)
      else
       begin
          uppername[i]:=s[i];
          if s[i] = DirSeparator then
            in_name:=false;
       end;
     uppername[0]:=s[0];
  end;

function TFileCollection.Compare(Key1, Key2: TCollectionItem): integer;
begin
  if TSearchrecC(Key1).s.Name = TSearchrecC(Key2).s.Name then Compare := 0
  else if TSearchrecC(Key1).s.Name = '..' then Compare := 1
  else if TSearchrecC(Key2).s.Name = '..' then Compare := -1
  else if (TSearchrecC(Key1).s.Attr and faDirectory <> 0) and
     (TSearchrecC(Key2).s.Attr and faDirectory = 0) then Compare := 1
  else if (TSearchrecC(Key2).s.Attr and faDirectory <> 0) and
     (TSearchrecC(Key1).s.Attr and faDirectory = 0) then Compare := -1
  else if UpperName(TSearchrecC(Key1).s.Name) > UpperName(TSearchrecC(Key2).s.Name) then
    Compare := 1
{$ifdef unix}
  else if UpperName(TSearchrecC(Key1).s.Name) < UpperName(TSearchrecC(Key2).s.Name) then
    Compare := -1
  else if TSearchrecC(Key1).s.Name > TSearchrecC(Key2).s.Name then
    Compare := 1
{$endif def unix}
  else
    Compare := -1;
end;

{****************************************************************************}
{ TFileCollection.FreeItem                   }
{****************************************************************************}


{****************************************************************************}
{ TFileCollection.GetItem                     }
{****************************************************************************}
function TFileCollection.GetItem(var S: TStream): Pointer;
var
  Item: TSearchRecC;
begin
  Item:= TSearchRecC.Create(self);
  S.Read(Item.s, SizeOf(TSearchRec));
  GetItem := Item;
end;

{****************************************************************************}
{ TFileCollection.PutItem                     }
{****************************************************************************}
procedure TFileCollection.PutItem(var S: TStream; Item: Pointer);
begin
  S.Write(Item^, SizeOf(TSearchRec));
end;


{*****************************************************************************
               TFileList
*****************************************************************************}

const
  ListSeparator=';';

function MatchesMask(What, Mask: string): boolean;

  function upper(const s : string) : string;
  var
    i  : Sw_integer;
  begin
     for i:=1 to length(s) do
      if s[i] in ['a'..'z'] then
       upper[i]:=char(byte(s[i])-32)
      else
       upper[i]:=s[i];
     upper[0]:=s[0];
  end;

  Function CmpStr(const hstr1,hstr2:string):boolean;
  var
    found : boolean;
    i1,i2 : Sw_integer;
  begin
    i1:=0;
    i2:=0;
    if hstr1='' then
      begin
        CmpStr:=(hstr2='');
        exit;
      end;
    found:=true;
    repeat
      inc(i1);
      if (i1>length(hstr1)) then
        break;
      inc(i2);
      if (i2>length(hstr2)) then
        break;
      case hstr1[i1] of
        '?' :
          found:=true;
        '*' :
          begin
            found:=true;
            if (i1=length(hstr1)) then
             i2:=length(hstr2)
            else
             if (i1<length(hstr1)) and (hstr1[i1+1]<>hstr2[i2]) then
              begin
                if i2<length(hstr2) then
                 dec(i1)
              end
            else
             if i2>1 then
              dec(i2);
          end;
        else
          found:=(hstr1[i1]=hstr2[i2]) or (hstr2[i2]='?');
      end;
    until not found;
    if found then
      begin
        found:=(i2>=length(hstr2)) and
               (
                (i1>length(hstr1)) or
                ((i1=length(hstr1)) and
                 (hstr1[i1]='*'))
               );
      end;
    CmpStr:=found;
  end;


begin
  MatchesMask:=CmpStr(ExtractFileName(what),ExtractFileName(mask));
end;

function MatchesMaskList(What, MaskList: string): boolean;
var P: integer;
    Match: boolean;
begin
  Match:=false;
  if What<>'' then
  repeat
    P:=Pos(ListSeparator, MaskList);
    if P=0 then P:=length(MaskList)+1;
    Match:=MatchesMask(What,copy(MaskList,1,P-1));
    Delete(MaskList,1,P);
  until Match or (MaskList='');
  MatchesMaskList:=Match;
end;

constructor TFileList.Create(aOwner: TGroup; var Bounds: TRect;
  AScrollBar: TScrollBar);
begin
  inherited create(aOwner,Bounds, 2, AScrollBar);
end;

destructor TFileList.Done;
begin
  if List <> nil then FreeAndNil(List);
  Inherited;
end;

function TFileList.DataSize: Sw_Word;
begin
  DataSize := 0;
end;

procedure TFileList.FocusItem(Item: Sw_Integer);
begin
  inherited FocusItem(Item);
  if (List.Count > 0) then
    Message(Tview(Owner), evBroadcast, cmFileFocused, List[Item]);
end;

procedure TFileList.GetData(const Rec: TStream);
begin
  assert(assigned(rec),'Stream must be assigned')
end;

function TFileList.GetKey(var S: String): Pointer;
const
  SR: TSearchRec = ({%H-});

procedure UpStr(var S: String);
var
  I: Sw_Integer;
begin
  for I := 1 to Length(S) do S[I] := UpCase(S[I]);
end;

begin
  if (HandleDir{ShiftState and $03 <> 0}) or ((S <> '') and (S[1]='.')) then
    SR.Attr := faDirectory
  else SR.Attr := 0;
  SR.Name := S;
{$ifndef Unix}
  UpperCase(SR.Name);
{$endif Unix}
  GetKey := @SR;
end;

function TFileList.GetText(Item,MaxLen: Sw_Integer): String;
var
  S: String;
  SR: TSearchRec;
begin
  SR := TSearchRecC(List[Item]).s;
  S := SR.Name;
  if SR.Attr and faDirectory <> 0 then
  begin
    S[Length(S)+1] := DirSeparator;
    Inc(S[0]);
  end;
  GetText := S;
end;

procedure TFileList.HandleEvent(var Event: TEvent);
var
  S : String;
  Value : Sw_integer;
begin
  if (Event.What = evMouseDown) and (Event.Double) then
  begin
    Event.What := evCommand;
    Event.Command := cmOK;
    PutEvent(Event);
    ClearEvent(Event);
  end
  else if (Event.What = evKeyDown) and (Event.CharCode='<') then
  begin
    { select '..' }
      S := '..';
      Value := List.indexof(S);
      if value>-1 then
        FocusItem(Value);
  end
  else inherited HandleEvent(Event);
end;

procedure TFileList.ReadDirectory(AWildCard: string);
const
  FindAttr = faReadOnly + faArchive;
  PrevDir  = '..';
var
  S: TSearchRec;
  P: TSearchRecC;
  FileList: TFileCollection;
  NumFiles: Word;
  FindStr,
  WildName : string;
  Dir: string;
  Ext: string deprecated;
  FileName: string;
  Event : TEvent;
  Tmp: string;
begin
  NumFiles := 0;
  FileList := TFileCollection.Create(TSearchRecC);
  AWildCard := ExpandFileName(AWildCard);
  Dir := ExtractFilePath(AWildCard);
  if pos(ListSeparator,AWildCard)>0 then
   begin
     WildName:=Copy(AWildCard,length(Dir)+1,255);
     FindStr:=Dir+AllFiles;
   end
  else
   begin
     WildName:=extractFilename(AWildCard);
     FindStr:=AWildCard;
   end;
  FindFirst(FindStr, FindAttr, S);
//  P := ;
  while (DosError = 0) do
   begin
     if (S.Attr and faDirectory = 0) and
        MatchesMaskList(S.Name,WildName) then
     begin
{       P := MemAlloc(SizeOf(P^));
       if assigned(P) then
       begin}
         p:=TSearchRecC.Create(FileList);
         P.s:=S;
{       end;}
     end;
     DosError:=FindNext(S);
   end;
 {$ifdef fpc}
  FindClose(S);
 {$endif}

  Tmp := Dir + AllFiles;
  FindFirst(Tmp, faDirectory, S);
  while (P <> nil) and (DosError = 0) do
  begin
    if (S.Attr and faDirectory <> 0) and (S.Name <> '.') and (S.Name <> '..') then
    begin
{      P := MemAlloc(SizeOf(P^));
      if P <> nil then
      begin}
        P:=TSearchRecC.Create(FileList);
        P.s:=S;
  //      FileList.Insert(P);
{      end;}
    end;
    FindNext(S);
  end;
 {$ifdef fpc}
  FindClose(S);
 {$endif}
 {$ifndef Unix}
  if Length(Dir) > 4 then
 {$endif not Unix}
  begin
{
    P := MemAlloc(SizeOf(P^));
    if P <> nil then
    begin}
      p:=TSearchRecC.Create(FileList);
      FindFirst(Tmp, faDirectory, S);
      FindNext(S);
      if (DosError = 0) and (S.Name = PrevDir) then
       begin
         P.s:=S;
       end
      else
       begin
         P.s.Name := PrevDir;
         P.s.Size := 0;
         P.s.Time := $210000;
         P.s.Attr := faDirectory;
       end;
  //    FileList.Insert(P);
     {$ifdef fpc}
      FindClose(S);
     {$endif}
{    end;}
  end;
  if P = nil then
    MessageBox(sTooManyFiles, [], mfOkButton + mfWarning);
  NewCollList(FileList);
  if List.Count > 0 then
  begin
    Event.What := evBroadcast;
    Event.Command := cmFileFocused;
    event.Data:=0;
    Event.InfoPtr := List.Objects[0];
    TView(Owner).HandleEvent(Event);
  end;
end;

procedure TFileList.SetData(const Rec: TStream);
begin
  assert(assigned(rec),'Stream must be assigned');
  with TFileDialog(Owner) do
    Self.ReadDirectory(DirectoryName + WildCard);
end;

{****************************************************************************}
{ TFileInfoPane Object                        }
{****************************************************************************}
{****************************************************************************}
{ TFileInfoPane.Init                    }
{****************************************************************************}
constructor TFileInfoPane.Create(aOwner:TGroup;var Bounds: TRect);
begin
  inherited Create(aOwner,Bounds);
  FillChar(S,SizeOf(S),#0);
  EventMask := EventMask or evBroadcast;
end;

{****************************************************************************}
{ TFileInfoPane.Draw                    }
{****************************************************************************}
procedure TFileInfoPane.Draw;
var
  B: TDrawBuffer;
  D: String[9];
  M: String[3];
  PM: Boolean;
  Color: Word;
  Time: TDateTime;
  Path: string;
  FmtId: String;
  Params: array[0..8] of TVarRec;
  Str: String[80];
const
  sDirectoryLine = ' %-12s %-9s %3s %2d, %4d  %2d:%02d%cm';
  sFileLine      = ' %-12s %-9d %3s %2d, %4d  %2d:%02d%cm';
  InValidFiles : array[0..2] of string[12] = ('','.','..');
var
  Month: array[1..12] of String[3];
begin
  Month[1] := smJan;
  Month[2] := smFeb;
  Month[3] := smMar;
  Month[4] := smApr;
  Month[5] := smMay;
  Month[6] := smJun;
  Month[7] := smJul;
  Month[8] := smAug;
  Month[9] := smSep;
  Month[10] := smOct;
  Month[11] := smNov;
  Month[12] := smDec;
  { Display path }

  if (TFileDialog(Owner).DirectoryName <> '') then
    Path := TFileDialog(Owner).DirectoryName
  else Path := '';
  Path := ExpandFileName(Path+TFileDialog(Owner).WildCard);
  { avoid B Buffer overflow PM }
  Path := ShrinkPath(Path, Size.X - 1);
  Color := GetColor($01);
  MoveChar(B, ' ', Color, Size.X); { fill with empty spaces }
  WriteLine(0, 0, Size.X, Size.Y, B);
  MoveStr(B[1], Path, Color);
  WriteLine(0, 0, Size.X, 1, B);
  if (S.Name = InValidFiles[0]) or (S.Name = InValidFiles[1]) or
     (S.Name = InValidFiles[2]) then
    Exit;

  { Display file }
  Params[0].VAnsiString := PAnsiString(@S.Name);
  if S.Attr and faDirectory <> 0 then
  begin
    FmtId := sDirectoryLine;
    D := sDirectory;
    Params[1].VString := PShortString(@D);
  end else
  begin
    FmtId := sFileLine;
    Params[1].VInteger := S.Size;
  end;
  Time:=FileDateToDateTime(S.Time);
  M := Month[ MonthOf(Time)];
  Params[2].VString := PShortString(@M);
  Params[3].VInteger := dayof(Time);
  Params[4].VInteger := yearof(Time);
  Params[5].VInteger := hourof(Time);
  Params[6].VInteger := minuteof(Time);
  if hourof(Time)>=12 then
    Params[7].VChar := 'p'
  else
    Params[7].VChar := 'a';
  Params[8].VInteger := (hourof(Time)+11) mod 12 +1 ;
  Str :=Format( FmtId, Params);
  MoveStr(B, Str, Color);
  WriteLine(0, 1, Size.X, 1, B);

  { Fill in rest of rectangle }
  MoveChar(B, ' ', Color, Size.X);
  WriteLine(0, 2, Size.X, Size.Y-2, B);
end;

function TFileInfoPane.GetPalette: PPalette;
const
  P: String[Length(CInfoPane)] = CInfoPane;
begin
  GetPalette := PPalette(@P);
end;

procedure TFileInfoPane.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evBroadcast) and (Event.Command = cmFileFocused) then
  begin
    S := TSearchRecC(Event.InfoPtr).s;
    DrawView;
  end;
end;

{****************************************************************************
              TFileHistory
****************************************************************************}

  function LTrim(const S: String): String;
  var
    I: Sw_Integer;
  begin
    I := 1;
    while (I < Length(S)) and (S[I] = ' ') do Inc(I);
    LTrim := Copy(S, I, 255);
  end;

  function RTrim(const S: String): String;
  var
    I: Sw_Integer;
  begin
    I := Length(S);
    while S[I] = ' ' do Dec(I);
    RTrim := Copy(S, 1, I);
  end;

  function isRelativePath(var S: string): Boolean;
  begin
    S := LTrim(RTrim(S));
    {$ifdef HASAMIGA}
    Result := Pos(DriveSeparator, S) = 0;
    {$ELSE}
    Result := not ((S <> '') and ((S[1] = DirSeparator) or (S[2] = ':')));
    {$ENDIF}
  end;

{ try to reduce the length of S+dir as a file path+pattern }

  function Simplify (var S,Dir : string) : string;
    var i : sw_integer;
  begin
   if isRelativePath(Dir) then
     begin
        if (S<>'') and (Copy(Dir,1,3)='..'+DirSeparator) then
          begin
             i:=Length(S);
             for i:=Length(S)-1 downto 1 do
               if S[i]=DirSeparator then
                 break;
             if S[i]=DirSeparator then
               Simplify:=Copy(S,1,i)+Copy(Dir,4,255)
             else
               Simplify:=S+Dir;
          end
        else
          Simplify:=S+Dir;
     end
   else
      Simplify:=Dir;
  end;

{****************************************************************************}
{ TFileHistory.HandleEvent                                                       }
{****************************************************************************}

procedure TFileHistory.HandleEvent(var Event: TEvent);
var
  HistoryWindow: THistoryWindow;
  R,P: TRect;
  C: Word;
  Rslt: String;
begin
  inherited HandleEvent(Event);
  if (Event.What = evMouseDown) or
     ((Event.What = evKeyDown) and (CtrlToArrow(Event.KeyCode) = kbDown) and
      (Link.State and sfFocused <> 0)) then
  begin
    if not Link.Focus then
    begin
      ClearEvent(Event);
      Exit;
    end;
    if assigned(CurDir) then
     Rslt:=CurDir^
    else
     Rslt:='';
    Rslt:=Simplify(Rslt,Link.Data);
    RemoveDoubleDirSep(Rslt);
    If IsWild(Rslt) then
      RecordHistory(Rslt);
    Link.GetBounds(R);
    Dec(R.A.X); Inc(R.B.X); Inc(R.B.Y,7); Dec(R.A.Y,1);
    TView(Owner).GetExtent(P);
    R.Intersect(P);
    Dec(R.B.Y,1);
    HistoryWindow := InitHistoryWindow(R);
    if HistoryWindow <> nil then
    begin
      C := TGroup(Owner).ExecView(HistoryWindow);
      if C = cmOk then
      begin
        Rslt := HistoryWindow.GetSelection;
        if Length(Rslt) > Link.MaxLen then Rslt[0] := Char(Link.MaxLen);
        Link.Data := Rslt;
        Link.SelectAll(True);
        Link.DrawView;
      end;
      FreeAndNil(HistoryWindow);
    end;
    ClearEvent(Event);
  end
  else if (Event.What = evBroadcast) then
    if ((Event.Command = cmReleasedFocus) and (Event.InfoPtr = Link))
      or (Event.Command = cmRecordHistory) then
    begin
      if assigned(CurDir) then
       Rslt:=CurDir^
      else
       Rslt:='';
      Rslt:=Simplify(Rslt,Link.Data);
      RemoveDoubleDirSep(Rslt);
      If IsWild(Rslt) then
        RecordHistory(Rslt);
    end;
end;

procedure TFileHistory.AdaptHistoryToDir(Dir : string);
  var S,S2 : String;
      i,Count : Sw_word;
begin
   if assigned(CurDir) then
     begin
        S:=CurDir^;
        if S=Dir then
          exit;
        DisposeStr(CurDir);
     end
   else
     S:='';
   CurDir:=NewStr(Simplify(S,Dir));

   Count:=HistoryCount(HistoryId);
   for i:=1 to count do
     begin
        S2:=HistoryStr(HistoryId,1);
        HistoryRemove(HistoryId,1);
        if isRelativePath(S2) then
          if S<>'' then
            S2:=S+S2
          else
            S2:=ExpandFileName(S2);
        { simply full path
          we should simplify relative to Dir ! }
        HistoryAdd(HistoryId,S2);
     end;

end;

destructor TFileHistory.Destroy;
begin
  If assigned(CurDir) then
    DisposeStr(CurDir);
  Inherited;
end;

{****************************************************************************
              TFileDialog
****************************************************************************}

function TFileDialog.GetHistoryID: Word;
begin
  result := FileHistory.HistoryId;
end;

procedure TFileDialog.SetHistoryID(AValue: Word);
begin
  FileHistory.HistoryId:=AValue;
end;

constructor TFileDialog.Create(aOwner: TGroup; AWildCard: TWildStr;
  const ATitle, InputName: String; AOptions: Word; aHistoryId: Byte);
var
  lbControl: TView;
  R: TRect;
  Opt: Word;
begin
  R.Assign(15,1,64,20);
  inherited Create(aOwner, R, ATitle);
  Options := Options or ofCentered;
  WildCard := AWildCard;

  R.Assign(3,3,31,4);
  ilFileName := TFileInputLine.Create(self, R, 79);
  ilFileName.Data := WildCard;
  Insert(ilFileName);
  R.Assign(2,2,3+CStrLen(InputName),3);
  lbControl := TLabel.Create(self,R, InputName, ilFileName);
  Insert(lbControl);
  R.Assign(31,3,34,4);
  FileHistory := TFileHistory.Create(self,R, ilFileName, aHistoryId);
  Insert(FileHistory);

  R.Assign(3,14,34,15);
  lbControl := TScrollBar.Create(self,R);
  Insert(lbControl);
  R.Assign(3,6,34,14);
  lvFileList := TFileList.Create(self,R, TScrollBar(lbControl));
  Insert(lvFileList);
  R.Assign(2,5,8,6);
  lbControl := TLabel.Create(self,R, slFiles, lvFileList);
  Insert(lbControl);

  R.Assign(35,3,46,5);
  Opt := bfDefault;
  if AOptions and fdOpenButton <> 0 then
  begin
    Insert(TButton.Create(self,R,slOpen, cmFileOpen, Opt));
    Opt := bfNormal;
    Inc(R.A.Y,3); Inc(R.B.Y,3);
  end;
  if AOptions and fdOkButton <> 0 then
  begin
    Insert(TButton.Create(self,R,slOk, cmFileOpen, Opt));
    Opt := bfNormal;
    Inc(R.A.Y,3); Inc(R.B.Y,3);
  end;
  if AOptions and fdReplaceButton <> 0 then
  begin
    Insert(TButton.Create(self,R, slReplace,cmFileReplace, Opt));
    Opt := bfNormal;
    Inc(R.A.Y,3); Inc(R.B.Y,3);
  end;
  if AOptions and fdClearButton <> 0 then
  begin
    Insert(TButton.Create(self,R, slClear,cmFileClear, Opt));
    Opt := bfNormal;
    Inc(R.A.Y,3); Inc(R.B.Y,3);
  end;
  Insert(TButton.Create(self,R, slCancel, cmCancel, bfNormal));
  Inc(R.A.Y,3); Inc(R.B.Y,3);
  if AOptions and fdHelpButton <> 0 then
  begin
    //Insert(TButton.Create(R,slHelp,cmHelp, bfNormal));
    //Inc(R.A.Y,3); Inc(R.B.Y,3);
  end;

  R.Assign(1,16,48,18);
  lbControl := TFileInfoPane.Create(self,R);
  Insert(lbControl);

  SelectNext(False);

  if AOptions and fdNoLoadDir = 0 then ReadDirectory;
end;

constructor TFileDialog.Load(var S: TStream);
begin
  if not assigned( TDialog.Load(nil,S)) then
    Fail;
  WildCard := S.ReadAnsiString;
  GetSubViewPtr(S, TView(ilFileName));
  GetSubViewPtr(S, TView(lvFileList));
  GetSubViewPtr(S, TView(FileHistory));
  ReadDirectory;
  if (DosError <> 0) then
  begin
     Inherited Destroy;
    Fail;
  end;
end;

destructor TFileDialog.Destroy;
begin
  inherited;
end;

procedure TFileDialog.GetData(const Rec: TStream);
var
  s: String;
begin
  s := Rec.ReadAnsiString;
  GetFilename(s);
end;

procedure TFileDialog.GetFileName(var S: string);

var
  Path: string;
  FileName: string;
  Ext: string;
  TWild : string;
  TPath: string;
  TName: string;
  TExt: string;
  i : Sw_integer;
begin
  S := ilFileName.Data;
  if isRelativePath(S) then
    begin
      if (DirectoryName <> '') then
   S := ExpandFileName(DirectoryName + S);
    end
  else
    S := ExpandFileName(S);
  Path := ExtractFilePath(S);
  FileName:=ExtractFileName(S);;
  if Pos(ListSeparator,S)=0 then
   begin
     If FileExists(S) then
       exit;
     if (ExtractFileName(S) = '')  and not IsDir(S) then
     begin
       TWild:=WildCard;
       repeat
        i:=Pos(ListSeparator,TWild);
        if i=0 then
         i:=length(TWild)+1;
        Tname := ExtractFileName(Copy(TWild,1,i-1));
        if (FileName = '') then
          S := ExtractFilePath(S) + TName
        else
          if FileName = '' then
            S := Path + TName
          else
            S := Path + FileName;
        if FileExists(S) then
         break;
        System.Delete(TWild,1,i);
       until TWild='';
       if TWild='' then
         S := Path + FileName;
     end;
   end;
end;

procedure TFileDialog.HandleEvent(var Event: TEvent);
begin
  if (Event.What and evBroadcast <> 0) and
     (Event.Command = cmListItemSelected) then
  begin
    EndModal(cmFileOpen);
    ClearEvent(Event);
  end;
  inherited HandleEvent(Event);
  if Event.What = evCommand then
    case Event.Command of
      cmFileOpen, cmFileReplace, cmFileClear:
   begin
     EndModal(Event.Command);
     ClearEvent(Event);
   end;
    end;
end;

procedure TFileDialog.SetData(const Rec: TStream);
var
  s: String;
begin
  inherited SetData(Rec);
  s := rec.ReadAnsiString;
  if (s <> '') and (IsWild(s)) then
  begin
    Valid(cmFileInit);
    ilFileName.Select;
  end;
end;

procedure TFileDialog.ReadDirectory;
begin
  lvFileList.ReadDirectory(WildCard);
  FileHistory.AdaptHistoryToDir(GetCurDir);
  DirectoryName := GetCurDir;
end;

procedure TFileDialog.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(WildCard, SizeOf(WildCard));
  PutSubViewPtr(S, ilFileName);
  PutSubViewPtr(S, lvFileList);
  PutSubViewPtr(S, FileHistory);
end;

function TFileDialog.Valid(Command: Word): Boolean;
var
  FName: string;
  Dir: string;
  FileName: string;
  Ext: string;

  function CheckDirectory(var S: string): Boolean;
  begin
    if not PathValid(S) then
    begin
      MessageBox(sInvalidDriveOrDir, [], mfError + mfOkButton);
      ilFileName.Select;
      CheckDirectory := False;
    end else CheckDirectory := True;
  end;

  function CompleteDir(const Path: string): string;
  begin
    { keep c: untouched PM }
    if (Path<>'') and (Path[Length(Path)]<>DirSeparator) and
       (Path[Length(Path)]<>':') then
     CompleteDir:=Path+DirSeparator
    else
     CompleteDir:=Path;
  end;

  function NormalizeDir(const Path: string): string;
  var Root: boolean;
  begin
    Root:=false;
    {$ifdef Unix}
    if Path=DirSeparator then Root:=true;
    {$else}
    {$ifdef HASAMIGA}
    if Length(Path) > 0 then Root := Path[Length(Path)] = DriveSeparator;
    {$else}
    if (length(Path)=3) and (Upcase(Path[1]) in['A'..'Z']) and
       (Path[2]=':') and (Path[3]=DirSeparator) then
         Root:=true;
    {$endif}
    {$endif}
    if (Root=false) and (copy(Path,length(Path),1)=DirSeparator) then
      NormalizeDir:=copy(Path,1,length(Path)-1)
    else
      NormalizeDir:=Path;
  end;
function NormalizeDirF(var S: openstring): boolean;
begin
  S:=NormalizeDir(S);
  NormalizeDirF:=true;
end;

begin
  if Command = 0 then
  begin
    Valid := True;
    Exit;
  end
  else Valid := False;
  if inherited Valid(Command) then
  begin
    GetFileName(FName);
    if (Command <> cmCancel) and (Command <> cmFileClear) then
    begin
      if IsWild(FName) or IsList(FName) then
      begin
        FileName := ExtractFileName(Fname);
        Dir := sysutils.ExtractFilePath(FName);
        if CheckDirectory(Dir) then
        begin
          FileHistory.AdaptHistoryToDir(Dir);
          DirectoryName := Dir;
          if Pos(ListSeparator,FName)>0 then
           WildCard:=Copy(FName,length(Dir)+1,255)
          else
           WildCard := FileName;
          if Command <> cmFileInit then
            lvFileList.Select;
          lvFileList.ReadDirectory(DirectoryName+WildCard);
        end;
      end
    else
      if NormalizeDirF(FName) then
      { ^^ this is just a dummy if construct (the func always returns true,
        it's just there, 'coz I don't want to rearrange the following "if"s... }
      if IsDir(FName) then
        begin
          if CheckDirectory(FName) then
          begin
            FileHistory.AdaptHistoryToDir(CompleteDir(FName));
//            DisposeStr(DirectoryName);
            DirectoryName := CompleteDir(FName);
            if Command <> cmFileInit then lvFileList.Select;
            lvFileList.ReadDirectory(DirectoryName+WildCard);
          end
        end
      else
        if ValidFileName(FName) then
          Valid := True
        else
          begin
            MessageBox(^C + sInvalidFileName, [], mfError + mfOkButton);
            Valid := False;
          end;
    end
    else Valid := True;
  end;
end;

{ TDirCollection }

function TDirCollection.GetItem(var S: TStream): Pointer;
var
  DirItem: TDirEntry;
begin
  DirItem:=TDirEntry.create(self);
  DirItem.DisplayText := S.ReadAnsiString;
  DirItem.Directory := S.ReadAnsiString;
  GetItem := DirItem;
end;

procedure TDirCollection.FreeItem(Item: Pointer);
var
  DirItem: TDirEntry absolute Item;
begin
//  DisposeStr(DirItem^.DisplayText);
//  DisposeStr(DirItem^.Directory);
  freeandnil(DirItem);
end;

procedure TDirCollection.PutItem(var S: TStream; Item: Pointer);
var
  DirItem: TDirEntry absolute Item;
begin
  S.WriteAnsiString(DirItem.DisplayText);
  S.WriteAnsiString(DirItem.Directory);
end;

{ TDirListBox }

const
  Drives: String = '';

constructor TDirListBox.Create(aOwner:TGroup;var Bounds: TRect; AScrollBar:
  TScrollBar);
begin
  Drives := sDrives;
  inherited create(aowner, Bounds, 1, AScrollBar);
  Dir := '';
end;

destructor TDirListBox.Destroy;
begin
  if (List <> nil) then
    freeandnil(List);
  inherited;
end;

function TDirListBox.GetText(Item,MaxLen: Sw_Integer): String;
begin
  GetText := TDirEntry(List[Item]).DisplayText;
end;

procedure TDirListBox.HandleEvent(var Event: TEvent);
var
  NewDirName: string;
begin
  case Event.What of
    evMouseDown:
      if Event.Double then
      begin
   Event.What := evCommand;
   Event.Command := cmChangeDir;
   PutEvent(Event);
   ClearEvent(Event);
      end;
    evKeyboard:
      if (Event.CharCode = ' ') and
    (TSearchRecC(List[Focused]).s.Name = '..') then
      begin
        NewDirName := TSearchRecC(List[Focused]).s.Name;
   NewDirectory(NewDirName);
      end;
  end;
  inherited HandleEvent(Event);
end;

function TDirListBox.IsSelected(Item: Sw_Integer): Boolean;
begin
{  IsSelected := Item = Cur; }
  IsSelected := Inherited IsSelected(Item);
end;

procedure TDirListBox.NewDirectory(var ADir: string);
const
  PathDir       = 'ÀÄÂ';
  FirstDir     =   'ÀÂÄ';
  MiddleDir   =   ' ÃÄ';
  LastDir       =   ' ÀÄ';
  IndentSize    = '  ';
var
  AList: TDirCollection;
  NewDir, Dirct: string;
  C, OldC: Char;
  S, Indent: String[80];
  P: String;
  NewCur: Word;
  isFirst: Boolean;
  SR: TSearchRec;
  I: Sw_Integer;

  function NewDirEntry(const DisplayText, DirectoryName: String): TDirEntry;{$ifdef PPC_BP}near;{$endif}
  var
    DirEntry: TDirEntry;
  begin
    DirEntry:=TDirEntry.Create(AList);
    DirEntry.DisplayText := DisplayText;
    If DirectoryName='' then
      DirEntry.Directory := DirSeparator
    else
      DirEntry.Directory := DirectoryName;
    NewDirEntry := DirEntry;
  end;

begin
  Dir := ADir;
  AList := TDirCollection.Create(TDirEntry);
{$ifdef HAS_DOS_DRIVES}
  AList^.Insert(NewDirEntry(Drives^,Drives^));
  if Dir = Drives^ then
  begin
    isFirst := True;
    OldC := ' ';
    for C := 'A' to 'Z' do
    begin
      if (C < 'C') or DriveValid(C) then
      begin
   if OldC <> ' ' then
   begin
     if isFirst then
     begin
       S := FirstDir + OldC;
       isFirst := False;
     end
     else S := MiddleDir + OldC;
     AList^.Insert(NewDirEntry(S, OldC + ':' + DirSeparator));
   end;
   if C = GetCurDrive then NewCur := AList^.Count;
   OldC := C;
      end;
    end;
    if OldC <> ' ' then
      AList^.Insert(NewDirEntry(LastDir + OldC, OldC + ':' + DirSeparator));
  end
  else
{$endif HAS_DOS_DRIVES}
  begin
    Indent := IndentSize;
    NewDir := Dir;
{$ifdef HAS_DOS_DRIVES}
    Dirct := Copy(NewDir,1,3);
    AList^.Insert(NewDirEntry(PathDir + Dirct, Dirct));
    NewDir := Copy(NewDir,4,255);
{$else HAS_DOS_DRIVES}
    Dirct := '';
{$endif HAS_DOS_DRIVES}
    while NewDir <> '' do
    begin
      I := Pos(DirSeparator,NewDir);
      if I <> 0 then
      begin
   S := Copy(NewDir,1,I-1);
   Dirct := Dirct + S;
//   AList.Insert(
     NewDirEntry(Indent + PathDir + S, Dirct)
//)
;
   NewDir := Copy(NewDir,I+1,255);
      end
      else
      begin
   Dirct := Dirct + NewDir;
//   AList.Insert(
NewDirEntry(Indent + PathDir + NewDir, Dirct)
//)
;
   NewDir := '';
      end;
      Indent := Indent + IndentSize;
      Dirct := Dirct + DirSeparator;
    end;
    NewCur := AList.Count-1;
    isFirst := True;
    NewDir := Dirct + AllFiles;
    FindFirst(NewDir, faDirectory, SR);
    while DosError = 0 do
    begin
      if (SR.Attr and faDirectory <> 0) and
         (SR.Name <> '.') and (SR.Name <> '..') then
      begin
   if isFirst then
   begin
     S := FirstDir;
     isFirst := False;
   end else S := MiddleDir;
//   AList.Insert(
   NewDirEntry(Indent + S + SR.Name, Dirct + SR.Name)
//   )
   ;
      end;
      FindNext(SR);
    end;
  FindClose(SR);
    P := TDirEntry(AList.Items[AList.Count-1]).DisplayText;
    I := Pos('À',P);
    if I = 0 then
    begin
      I := Pos('Ã',P);
      if I <> 0 then P[I] := 'À';
    end else
    begin
      P[I+1] := 'Ä';
      P[I+2] := 'Ä';
    end;
  end;
  NewCollList(AList);
  FocusItem(NewCur);
  Cur:=NewCur;
end;

procedure TDirListBox.NewCollList(AList: TCollection);
begin

end;

procedure TDirListBox.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState, Enable);
  if AState and sfFocused <> 0 then
    TChDirDialog(Owner).ChDirButton.MakeDefault(Enable);
end;

{****************************************************************************}
{ TChDirDialog Object                     }
{****************************************************************************}
{****************************************************************************}
{ TChDirDialog.Init                      }
{****************************************************************************}
constructor TChDirDialog.Create(aOwner: TGroup; AOptions: Word;
  HistoryId: Sw_Word);
var
  R: TRect;
  Control: TView;
begin
  R.Assign(16, 2, 64, 20);
  inherited create(aOwner, R,sChangeDirectory);

  Options := Options or ofCentered;

  R.Assign(3, 3, 30, 4);
  DirInput := TInputLine.Create(self, R, 255+4);
  Insert(DirInput);
  R.Assign(2, 2, 17, 3);
  Control := TLabel.Create(self, R,slDirectoryName, DirInput);
  Insert(Control);
  R.Assign(30, 3, 33, 4);
  Control := THistory.Create(self, R, DirInput, HistoryId);
  Insert(Control);

  R.Assign(32, 6, 33, 16);
  Control := TScrollBar.Create(self, R);
  Insert(Control);
  R.Assign(3, 6, 32, 16);
  DirList := TDirListBox.Create(self, R, TScrollBar(Control));
  Insert(DirList);
  R.Assign(2, 5, 17, 6);
  Control := TLabel.Create(self, R, slDirectoryTree, DirList);
  Insert(Control);

  R.Assign(35, 6, 45, 8);
  OkButton := TButton.Create(self, R, slOk, cmOK, bfDefault);
  Insert(OkButton);
  Inc(R.A.Y,3); Inc(R.B.Y,3);
  ChDirButton := TButton.Create(self, R,slChDir,cmChangeDir,
           bfNormal);
  Insert(ChDirButton);
  Inc(R.A.Y,3); Inc(R.B.Y,3);
  Insert(TButton.Create(self, R,slRevert, cmRevert, bfNormal));
  if AOptions and cdHelpButton <> 0 then
  begin
    //Inc(R.A.Y,3); Inc(R.B.Y,3);
    //Insert(TButton.Create(R,slHelp, cmHelp, bfNormal));
  end;

  if AOptions and cdNoLoadDir = 0 then SetUpDialog;

  SelectNext(False);
end;

{****************************************************************************}
{ TChDirDialog.Load                      }
{****************************************************************************}
constructor TChDirDialog.Load(var S: TStream);
begin
  inherited Load(nil, S);
  GetSubViewPtr(S, TView(DirList));
  GetSubViewPtr(S, TView(DirInput));
  GetSubViewPtr(S, TView(OkButton));
  GetSubViewPtr(S, TView(ChDirbutton));
  SetUpDialog;
end;

{****************************************************************************}
{ TChDirDialog.DataSize                      }
{****************************************************************************}
function TChDirDialog.DataSize: Sw_Word;
begin
  DataSize := 0;
end;

{****************************************************************************}
{ TChDirDialog.GetData                        }
{****************************************************************************}
procedure TChDirDialog.GetData(const Rec: TStream);
begin
end;

{****************************************************************************}
{ TChDirDialog.HandleEvent                   }
{****************************************************************************}
procedure TChDirDialog.HandleEvent(var Event: TEvent);
var
  CurDir: string;
  P: TDirEntry;
begin
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
      begin
   case Event.Command of
     cmRevert: GetDir(0,CurDir);
     cmChangeDir:
       begin
         P := TDirEntry( DirList.List.Objects[DirList.Focused]);
         if (P.Directory = Drives)
            or DriveValid(P.Directory[1]) then
           CurDir := P.Directory
         else Exit;
       end;
   else
     Exit;
   end;
   if (Length(CurDir) > 3) and
      (CurDir[Length(CurDir)] = DirSeparator) then
     CurDir := Copy(CurDir,1,Length(CurDir)-1);
   DirList.NewDirectory(CurDir);
   DirInput.Data := CurDir;
   DirInput.DrawView;
   DirList.Select;
   ClearEvent(Event);
      end;
  end;
end;

{****************************************************************************}
{ TChDirDialog.SetData                        }
{****************************************************************************}
procedure TChDirDialog.SetData(const Rec: TStream);
begin
end;

{****************************************************************************}
{ TChDirDialog.SetUpDialog                   }
{****************************************************************************}
procedure TChDirDialog.SetUpDialog;
var
  CurDir: string;
begin
  if DirList <> nil then
  begin
    CurDir := GetCurDir;
    DirList.NewDirectory(CurDir);
    if (Length(CurDir) > 3) and (CurDir[Length(CurDir)] = DirSeparator) then
      CurDir := Copy(CurDir,1,Length(CurDir)-1);
    if DirInput <> nil then
    begin
      DirInput.Data := CurDir;
      DirInput.DrawView;
    end;
  end;
end;

{****************************************************************************}
{ TChDirDialog.Store                    }
{****************************************************************************}
procedure TChDirDialog.Store(var S: TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S, DirList);
  PutSubViewPtr(S, DirInput);
  PutSubViewPtr(S, OkButton);
  PutSubViewPtr(S, ChDirButton);
end;

{****************************************************************************}
{ TChDirDialog.Valid                    }
{****************************************************************************}
function TChDirDialog.Valid(Command: Word): Boolean;
var
  P: string;
begin
  Valid := True;
  if Command = cmOk then
  begin
    P := ExpandFileName(DirInput.Data);
    if (Length(P) > 3) and (P[Length(P)] = DirSeparator) then
      Dec(P[0]);
    {$push}{$I-}
    ChDir(P);
    if (IOResult <> 0) then
    begin
      MessageBox(sInvalidDirectory, [], mfError + mfOkButton);
      Valid := False;
    end;
    {$pop}
  end;
end;

{****************************************************************************}
{ TEditChDirDialog Object                     }
{****************************************************************************}
{****************************************************************************}
{ TEditChDirDialog.DataSize                    }
{****************************************************************************}
function TEditChDirDialog.DataSize : Sw_Word;
begin
  DataSize := SizeOf(string);
end;

{****************************************************************************}
{ TEditChDirDialog.GetData                   }
{****************************************************************************}
procedure TEditChDirDialog.GetData (const Rec:TStream);
var
  CurDir : string ;
begin
  if (DirInput = nil) then
    CurDir := ''
  else begin
    CurDir := DirInput.Data;
    
    if (CurDir[Length(CurDir)] <> DirSeparator) 
    {$IFDEF HASAMIGA}
      and (CurDir[Length(CurDir)] <> DriveSeparator) 
    {$endif}
    then
      CurDir := CurDir + DirSeparator;
  end;
  rec.WriteAnsiString(CurDir);
end;

{****************************************************************************}
{ TEditChDirDialog.SetData                   }
{****************************************************************************}
procedure TEditChDirDialog.SetData (const Rec:TStream);
var
  CurDir : string;
begin
  CurDir:= Rec.ReadAnsiString;
  if DirList <> nil then
  begin
    DirList.NewDirectory(CurDir);
    if DirInput <> nil then
    begin
      if (Length(CurDir) > 3) and (CurDir[Length(CurDir)] = DirSeparator) then
   DirInput.Data := Copy(CurDir,1,Length(CurDir)-1)
      else DirInput.Data := CurDir;
      DirInput.DrawView;
    end;
  end;
end;

{****************************************************************************}
{ TSortedListBox Object                      }
{****************************************************************************}
{****************************************************************************}
{ TSortedListBox.Init                     }
{****************************************************************************}
constructor TSortedListBox.Create(aOwner: TGroup; var Bounds: TRect;
  ANumCols: Sw_Word; AScrollBar: TScrollBar);
begin
  inherited Create(aOwner,Bounds, ANumCols, AScrollBar);
  SearchPos := 0;
  ShowCursor;
  SetCursor(1,0);
end;

{****************************************************************************}
{ TSortedListBox.HandleEvent                  }
{****************************************************************************}
procedure TSortedListBox.HandleEvent(var Event: TEvent);
const
  SpecialChars: set of Char = [#0,#9,#27];
var
  CurString, NewString: String;
  Value : Sw_integer;
  OldPos, OldValue: Sw_Integer;

begin
  OldValue := Focused;
  inherited HandleEvent(Event);
  if (OldValue <> Focused) or
     ((Event.What = evBroadcast) and (Event.InfoPtr = Self) and
      (Event.Command = cmReleasedFocus)) then
    SearchPos := 0;
  if Event.What = evKeyDown then
  begin
    { patched to prevent error when no or empty list or Escape pressed }
    if (not (Event.CharCode in SpecialChars)) and
       (List <> nil) and (List.Count > 0) then
    begin
      Value := Focused;
      if Value < Range then
        CurString := GetText(Value, 255)
      else
        CurString := '';
      OldPos := SearchPos;
      if Event.KeyCode = kbBack then
      begin
   if SearchPos = 0 then Exit;
   Dec(SearchPos);
          if SearchPos = 0 then
            HandleDir:= ((GetShiftState and $3) <> 0) or (Event.CharCode in ['A'..'Z']);
   CurString[0] := Char(SearchPos);
      end
      else if (Event.CharCode = '.') then
        SearchPos := Pos('.',CurString)
      else
      begin
   Inc(SearchPos);
          if SearchPos = 1 then
            HandleDir := ((GetShiftState and 3) <> 0) or (Event.CharCode in ['A'..'Z']);
   CurString[0] := Char(SearchPos);
   CurString[SearchPos] := Event.CharCode;
      end;
      Value := List.indexof(CurString);
  //    T := Value>-1;
      if Value < Range then
      begin
          if Value < Range then
            NewString := GetText(Value, 255)
          else
            NewString := '';
   if Equal(NewString, CurString, SearchPos) then
   begin
     if Value <> OldValue then
     begin
       FocusItem(Value);
       { Assumes ListControl will set the cursor to the first character }
       { of the sfFocused item }
       SetCursor(Cursor.X+SearchPos, Cursor.Y);
     end
              else
                SetCursor(Cursor.X+(SearchPos-OldPos), Cursor.Y);
   end
          else
            SearchPos := OldPos;
      end
      else SearchPos := OldPos;
      if (SearchPos <> OldPos) or (Event.CharCode in ['A'..'Z','a'..'z']) then
   ClearEvent(Event);
    end;
  end;
end;

function TSortedListBox.GetKey(var S: String): Pointer;
begin
  GetKey := @S;
end;

procedure TSortedListBox.NewCollList(AList: TCollection);
var sl:TStrings;
  e: TCollectionItem;
begin
  sl:=TStringList.Create;
  for e in alist do
    begin
      sl.AddObject(e.ToString,e);
    end;
  inherited NewList(sl);
  freeandnil(sl);
  SearchPos := 0;
end;

{****************************************************************************}
{            Global Procedures and Functions          }
{****************************************************************************}

{****************************************************************************}
{ Contains                          }
{****************************************************************************}
function Contains(S1, S2: String): Boolean;
  { Contains returns true if S1 contains any characters in S2. }
var
  i : Byte;
begin
  Contains := True;
  i := 1;
  while ((i < Length(S2)) and (i < Length(S1))) do
    if (Upcase(S1[i]) = Upcase(S2[i])) then
      Exit
    else Inc(i);
  Contains := False;
end;

{****************************************************************************}
{ StdDeleteFile                           }
{****************************************************************************}
function StdDeleteFile (AFile : string) : Boolean;
var
  Rec : array[0..0] of TVarRec;
begin
  if CheckOnDelete then
  begin
    AFile := ShrinkPath(AFile,33);
    Rec[0].VString := PShortString(@AFile);
    StdDeleteFile := (MessageBox(^C + sDeleteFile,
               Rec,mfConfirmation or mfOkCancel) = cmOk);
  end
  else StdDeleteFile := False;
end;

{****************************************************************************}
{ DriveValid                         }
{****************************************************************************}
function DriveValid(Drive: Char): Boolean;
{$ifdef HAS_DOS_DRIVES}
var
  D: Char;
begin
  D := GetCurDrive;
  {$push}{$I-}
  ChDir(Drive+':');
  if (IOResult = 0) then
  begin
    DriveValid := True;
    ChDir(D+':')
  end
  else DriveValid := False;
  {$pop}
end;
{$else HAS_DOS_DRIVES}
begin
  DriveValid:=true;
end;
{$endif HAS_DOS_DRIVES}

{****************************************************************************}
{ Equal                             }
{****************************************************************************}
function Equal(const S1, S2: String; Count: Sw_word): Boolean;
var
  i: Sw_Word;
begin
  Equal := False;
  if (Length(S1) < Count) or (Length(S2) < Count) then
    Exit;
  for i := 1 to Count do
    if UpCase(S1[I]) <> UpCase(S2[I]) then
      Exit;
  Equal := True;
end;

{****************************************************************************}
{ ExtractDir                         }
{****************************************************************************}
function ExtractDir(AFile: string): string;deprecated 'use ExtractFileDir';
  { ExtractDir returns the path of AFile terminated with a trailing '\'.  If
    AFile contains no directory information, an empty string is returned. }
//var
//  D: string;
//  N: string;
//  E: String;
begin
  //FSplit(AFile,D,N,E);
  //if D = '' then
  //begin
  //  ExtractDir := '';
  //  Exit;
  //end;
  //if (D[Byte(D[0])] <> DirSeparator)
  //{$ifdef HASAMIGA}
  //  and (D[Byte(D[0])] <> DriveSeparator)
  //{$endif}
  //then
  //  D := D + DirSeparator;
  //ExtractDir := D;
  result := ExtractFileDir(AFile);
end;

{****************************************************************************}
{ ExtractFileName                       }
{****************************************************************************}
function ExtractFileName(AFile: string): NameStr;deprecated 'use sysutils.ExtractFileName';
//var
//  D: string;
//  N: NameStr;
//  E: ExtStr;
begin
  ExtractFileName := sysutils.ExtractFileName(AFile);
end;

{****************************************************************************}
{ FileExists                         }
{****************************************************************************}
function FileExists (AFile : string) : Boolean;deprecated 'use sysutils.FileExists';
begin
  FileExists := sysutils.FileExists(AFile);
end;

{****************************************************************************}
{ GetCurDir                        }
{****************************************************************************}
function GetCurDir: string;
var
  CurDir: string;
begin
  GetDir(0, CurDir);
  if (Length(CurDir) > 3) then
  begin
    Inc(CurDir[0]);
    CurDir[Length(CurDir)] := DirSeparator;
  end;
  GetCurDir := CurDir;
end;

{****************************************************************************}
{ GetCurDrive                       }
{****************************************************************************}
function GetCurDrive: Char;
{$ifdef go32v2}
var
  Regs : Registers;
begin
  Regs.AH := $19;
  Intr($21,Regs);
  GetCurDrive := Char(Regs.AL + Byte('A'));
end;
{$else not go32v2}
var
  D : string;
begin
  D:=GetCurDir;
  if (Length(D)>1) and (D[2]=':') then
    begin
      if (D[1]>='a') and (D[1]<='z') then
        GetCurDrive:=Char(Byte(D[1])+Byte('A')-Byte('a'))
      else
        GetCurDrive:=D[1];
    end
  else
    GetCurDrive:='C';
end;
{$endif not go32v2}

{****************************************************************************}
{ IsDir                             }
{****************************************************************************}
function IsDir(const S: String): Boolean;
var
  SR: TSearchRec;
  Is_: boolean;
begin
  Is_:=false;
{$ifdef Unix}
  Is_:=(S=DirSeparator); { handle root }
{$else}
  {$ifdef HASAMIGA}
  Is_ := (Length(S) > 0) and (S[Length(S)] = DriveSeparator);
  {$else}
  Is_:=(length(S)=3) and (Upcase(S[1]) in['A'..'Z']) and (S[2]=':') and (S[3]=DirSeparator);
  {$endif}
  { handle root dirs }
{$endif}
  if Is_=false then
  begin
    FindFirst(S, faDirectory, SR);
    if DosError = 0 then
      Is_ := (SR.Attr and faDirectory) <> 0
    else
      Is_ := False;
   {$ifdef fpc}
    FindClose(SR);
   {$endif}
  end;
  IsDir:=Is_;
end;

{****************************************************************************}
{ IsWild                           }
{****************************************************************************}
function IsWild(const S: String): Boolean;
begin
  IsWild := (Pos('?',S) > 0) or (Pos('*',S) > 0);
end;

{****************************************************************************}
{ IsList                           }
{****************************************************************************}
function IsList(const S: String): Boolean;
begin
  IsList := (Pos(ListSeparator,S) > 0);
end;

{****************************************************************************}
{ MakeResources                           }
{****************************************************************************}
(*
procedure MakeResources;
var
  Dlg : PDialog;
  Key : String;
  i : Word;
begin
  for i := 0 to 1 do
  begin
    case i of
      0 : begin
       Key := reOpenDlg;
       Dlg := New(PFileDialog,Init('*.*',sOpen,slName,
             fdOkButton or fdHelpButton or fdNoLoadDir,0));
     end;
      1 : begin
       Key := reSaveAsDlg;
       Dlg := New(PFileDialog,Init('*.*',sSaveAs,slName,
             fdOkButton or fdHelpButton or fdNoLoadDir,0));
     end;
      2 : begin
       Key := reEditChDirDialog;
       Dlg := New(PEditChDirDialog,Init(cdHelpButton,
             hiCurrentDirectories));
     end;
    end;
    if Dlg = nil then
    begin
       PrintStr('Error initializing dialog ' + Key);
       Halt;
    end
    else begin
      RezFile^.Put(Dlg,Key);
      if (RezFile^.Stream^.Status <> stOk) then
      begin
   PrintStr('Error writing dialog ' + Key + ' to the resource file.');
   Halt;
      end;
    end;
  end;
end;
*)
{****************************************************************************}
{ NoWildChars                       }
{****************************************************************************}
function NoWildChars(S: String): String;
const
  WildChars : array[0..1] of Char = ('?','*');
var
  i : Sw_Word;
begin
  repeat
    i := Pos(WildChars[0],S);
    if (i > 0) then
      System.Delete(S,i,1);
  until (i = 0);
  repeat
    i := Pos(WildChars[1],S);
    if (i > 0) then
      System.Delete(S,i,1);
  until (i = 0);
  NoWildChars:=S;
end;

{****************************************************************************}
{ OpenFile                          }
{****************************************************************************}
function OpenFile (var AFile : string; HistoryID : Byte) : Boolean;
var
  Dlg : TFileDialog;
  st: TStream;
begin
  {$ifdef cdResource}
  Dlg := PFileDialog(RezFile^.Get(reOpenDlg));
  {$else}
  Dlg := TFileDialog.Create(nil,'*.*',sOpen,slName,
        fdOkButton or fdHelpButton,0);
  {$endif cdResource}
    { this works }
  Dlg.HistoryID := HistoryID;
  st:=TMemoryStream.Create;
  OpenFile := (Application.ExecuteDialog(Dlg,AFile) = cmFileOpen);
end;

{****************************************************************************}
{ OpenNewFile                       }
{****************************************************************************}
function OpenNewFile (var AFile: string; HistoryID: Byte): Boolean;
  { OpenNewFile allows the user to select a directory from disk and enter a
    new file name.  If the file name entered is an existing file the user is
    optionally prompted for confirmation of replacing the file based on the
    value in #CheckOnReplace#.  If a file name is successfully entered,
    OpenNewFile returns True. }
  {#X OpenFile }
begin
  OpenNewFile := False;
  if OpenFile(AFile,HistoryID) then
  begin
    if not ValidFileName(AFile) then
      Exit;
    if sysutils.FileExists(AFile) then
      if (not CheckOnReplace) or (not ConfirmReplaceFile(AFile)) then
   Exit;
    OpenNewFile := True;
  end;
end;

{****************************************************************************}
{ RegisterStdDlg                         }
{****************************************************************************}
procedure RegisterStdDlg;
begin
  //RegisterType(RFileInputLine);
  //RegisterType(RFileCollection);
  //RegisterType(RFileList);
  //RegisterType(RFileInfoPane);
  //RegisterType(RFileDialog);
  //RegisterType(RDirCollection);
  //RegisterType(RDirListBox);
  //RegisterType(RSortedListBox);
  //RegisterType(RChDirDialog);
end;

{****************************************************************************}
{ StdReplaceFile                         }
{****************************************************************************}
function StdReplaceFile (AFile : string) : Boolean;
var
  Rec : array[0..0] of TVarRec;
begin
  if CheckOnReplace then
  begin
    AFile := ShrinkPath(AFile,33);
    Rec[0].VString := PShortString(@AFile);
    StdReplaceFile :=
       (MessageBox(^C + sReplaceFile,
         Rec,mfConfirmation or mfOkCancel) = cmOk);
  end
  else StdReplaceFile := True;
end;

{****************************************************************************}
{ SaveAs                           }
{****************************************************************************}
function SaveAs (var AFile : string; HistoryID : Word) : Boolean;
var
  Dlg : TFileDialog;
begin
  SaveAs := False;
  Dlg := TFileDialog.Create(nil,'*.*',sSaveAs,slSaveAs,
        fdOkButton or fdHelpButton,0);
    { this might not work }
  Dlg.HistoryID := HistoryID;
  Dlg.HelpCtx := hcSaveAs;
  if (Application.ExecuteDialog(Dlg,AFile) = cmFileOpen) and
     ((not sysutils.FileExists(AFile)) or ConfirmReplaceFile(AFile)) then
    SaveAs := True;
end;

{****************************************************************************}
{ SelectDir                        }
{****************************************************************************}
function SelectDir (var ADir : string; HistoryID : Byte) : Boolean;
var
  Dir: string;
  Dlg : TEditChDirDialog;
  Rec : string;
begin
  {$push}{$I-}
  GetDir(0,Dir);
  {$pop}
  Rec := ExpandFileName(ADir);
  Dlg := TEditChDirDialog.create(nil,cdHelpButton,HistoryID);
  if (Application.ExecuteDialog(Dlg,Rec) = cmOk) then
  begin
    SelectDir := True;
    ADir := Rec;
  end
  else SelectDir := False;
  {$push}{$I-}
  ChDir(Dir);
  {$pop}
end;

{****************************************************************************}
{ ShrinkPath                         }
{****************************************************************************}
function ShrinkPath (AFile : string; MaxLen : Byte) : string;
var
  Filler: string;
  D1 : string;
  N1 : string;

  i  : Sw_Word;

begin
  if Length(AFile) > MaxLen then
  begin
    AFile:=ExpandFileName(AFile);
    N1:=sysutils.ExtractFileName(AFile);
    D1:=ExtractFilePath(AFile);
    AFile := Copy(D1,1,3) + '..' + DirSeparator;
    i := Pred(Length(D1));
    while (i > 0) and (D1[i] <> DirSeparator) do
      Dec(i);
    if (i = 0) then
      AFile := AFile + D1
    else AFile := AFile + Copy(D1,Succ(i),Length(D1)-i);
    if (AFile[Length(AFile)] <> DirSeparator)
    {$ifdef HASAMIGA}
      and (AFile[Length(AFile)] <> DriveSeparator)
    {$endif}
    then
      AFile := AFile + DirSeparator;
    if Length(AFile)+Length(N1) <= MaxLen then
      AFile := AFile + N1
    else
      begin
        Filler := '...' + DirSeparator;
        AFile:=Copy(Afile,1,MaxLen-Length(Filler)-Length(N1))
                +Filler+N1;
      end;
  end;
  ShrinkPath := AFile;
end;

{****************************************************************************}
{ ValidFileName                           }
{****************************************************************************}
function ValidFileName(var FileName: string): Boolean;
var
  IllegalChars: string[12];
  Dir: string;
  Name: String;

begin
{$ifdef PPC_FPC}
{$ifdef go32v2}
  { spaces are allowed if LFN is supported }
  if LFNSupport then
    IllegalChars := ';,=+<>|"[]'+DirSeparator
  else
    IllegalChars := ';,=+<>|"[] '+DirSeparator;
{$else not go32v2}
{$ifdef OS_WINDOWS}
    IllegalChars := ';,=+<>|"[]'+DirSeparator;
{$else not go32v2 and not OS_WINDOWS }
    IllegalChars := ';,=+<>|"[] '+DirSeparator;
{$endif not OS_WINDOWS}
{$endif not go32v2}
{$else not PPC_FPC}
  IllegalChars := ';,=+<>|"[] '+DirSeparator;
{$endif PPC_FPC}
  ValidFileName := True;
  dir := ExtractFilePath(FileName);
  Name := sysutils.ExtractFileName(FileName);
  if  ((Dir <> '') and not PathValid(Dir)) or
     Contains(Name, IllegalChars) or
     Contains(Dir, IllegalChars) then
    ValidFileName := False;
end;

{****************************************************************************}
{        Unit Initialization Section                                         }
{****************************************************************************}
begin
{$ifdef PPC_BP}
  ConfirmReplaceFile := StdReplaceFile;
  ConfirmDeleteFile := StdDeleteFile;
{$else}
  ConfirmReplaceFile := @StdReplaceFile;
  ConfirmDeleteFile := @StdDeleteFile;
{$endif PPC_BP}
end.
