{************************************************}
{                                                }
{     Win32Crt Delphi Runtime Library            }
{     32-bit implementation of Crt Unit          }
{     Version 1.2 Freeware not Public Domain     }
{     Designed for Delphi 7                      }
{                                                }
{     Copyright (C) 2002-2003 MacroSoftware      }
{     Zaimplementowa³ Wojciech Pawe³czyk         }
{                                                }
{************************************************}

{*H Unit Forms nicht mehr benötigt.}
{*H Anpassung an Widestring (Delphi 2k9)}
{
 Cursor Tasten -Codes

}
UNIT Win32Crt;

{$I jedi.inc}
INTERFACE

{ $WARNINGS Off}

USES
{$IFnDEF FPC}
  Windows, Messages,
{$ELSE}
Video,
{$IFDEF MSWINDOWS}
Windows,
{$ELSE}
BaseUnix ,
unix,
termio,
crt,
LMessages,
{$ENDIF}
{$ENDIF}
  classes,
  controls,
  SysUtils;

TYPE
  THz   = 37 .. 32767;
  TCols = 1 .. HIGH(Byte);
  TRows = 1 .. HIGH(Word);
  // TAlignment = (alLeft, alRight, alCenter);
  TCGAColor = integer;
{$if declared(_CHAR_INFO)}
  TCHAR_INFO=_CHAR_INFO;
{$endIf}


CONST
  /// <author>C.Rosewich</author>
  /// <info>CGA Colors (16 Basic colors)</info>
  Black: TCGAColor        = 0;
  Blue: TCGAColor         = 1;
  Green: TCGAColor        = 2;
  Cyan: TCGAColor         = 3;
  Red: TCGAColor          = 4;
  Magenta: TCGAColor      = 5;
  Brown: TCGAColor        = 6;
  LightGray: TCGAColor    = 7;
  DarkGray: TCGAColor     = 8;
  LightBlue: TCGAColor    = 9;
  LightGreen: TCGAColor   = 10;
  LightCyan: TCGAColor    = 11;
  LightRed: TCGAColor     = 12;
  LightMagenta: TCGAColor = 13;
  Yellow: TCGAColor       = 14;
  White: TCGAColor        = 15;
  // Fenster-Methoden
  /// <author>C.Rosewich</author>
  /// <info>Sets the Title of the Console Window</info>
PROCEDURE SetTitle(CONST Title: STRING);
/// <author>C.Rosewich</author>
/// <info>Sets the color of the console</info>
PROCEDURE ConsoleColor(CONST Color: TCGAColor);
/// <author>C.Rosewich</author>
/// <info>Fills Console with Character</info>
PROCEDURE FillConsole(CONST Character: Char);
PROCEDURE ClearConsole;
PROCEDURE ClrScr;
PROCEDURE ClrEol;
PROCEDURE TextColor(CONST Color: TCGAColor);
PROCEDURE TextBackground(CONST Color: TCGAColor);
// Text-Methoden
PROCEDURE TextOut(CONST Text: STRING = '';
  Alignment: TAlignment = taLeftJustify; InsertLine: Boolean = False);
PROCEDURE UnrollText(CONST Text: STRING; Wait: Cardinal;
  Alignment: TAlignment = taLeftJustify; InsertLine: Boolean = False);
PROCEDURE InsertText(X, Y: Byte; CONST Text: STRING);
PROCEDURE InsertTextOEM(X, Y: Byte; Text: ShortSTRING);
PROCEDURE InsertChar(X, Y: Byte; CONST Character: Char);
PROCEDURE OverwriteText(X, Y: Byte; CONST Text: STRING); OVERLOAD;
PROCEDURE OverwriteText(FromX, ToX, Y: Byte; CONST Text: STRING); OVERLOAD;
PROCEDURE OverwriteChar(X, Y: Byte; CONST Character: Char);
PROCEDURE Window(X, Y, x2, y2: integer);

/// <author>C. Rosewich</author>
FUNCTION AssignTextFile(CONST Path: STRING; EndLine: Boolean): Boolean;
  OVERLOAD;
FUNCTION AssignTextFile(CONST Path: STRING; OUT TextFromFile: STRING;
  EndLine: Boolean): Boolean; OVERLOAD;
// Cursor
PROCEDURE GotoXY(X: TCols; Y: TRows);
PROCEDURE GotoX(X: TCols);
PROCEDURE GotoY(Y: TRows);
FUNCTION WhereX: Byte;
FUNCTION WhereY: Word;
PROCEDURE SetCursorSize(Size: integer; visible: Boolean);

// Sound utils
PROCEDURE Sound(CONST Hz: THz; Duration: Cardinal); OVERLOAD;
{$IFNDEF win64}
PROCEDURE Sound(Freq: Word); OVERLOAD;
PROCEDURE NoSound;
{$ENDIF}
PROCEDURE SoundInformation;
PROCEDURE SoundWarning;
PROCEDURE SoundError;

// Eingabe
PROCEDURE Delay(CONST Miliseconds: Cardinal);
FUNCTION KeyPressed: Boolean;
FUNCTION ReadKey: Char;
PROCEDURE FullScreen;
// Codepage(Zeichensatz)
FUNCTION GetCodePage: Cardinal;
FUNCTION SetCodePage(CONST CodePage: Cardinal): Boolean;
PROCEDURE TextMode(mode: integer);

// Environment-Methoden
FUNCTION GetEnvironmentVariable(CONST Name: STRING = 'COMSPEC')
  : STRING; OVERLOAD;
FUNCTION SetEnvironmentVariable(CONST Name, Value: STRING): Boolean; OVERLOAD;

// Time-Date-Methoden
PROCEDURE gettime(VAR hu, mi, h1, h2: Word);
// Procedure getDate(Var hu, mi, h1, h2: word);

// Direct-Screen-Methods
FUNCTION getmemb800(adr: integer): Byte; OVERLOAD;
PROCEDURE SetMemB800(adr: integer; Val: Byte); OVERLOAD;

FUNCTION getmemb800(adr: integer; count: Word): ShortSTRING; OVERLOAD;
PROCEDURE SetMemB800(adr: integer; Line: ShortSTRING; count: Word); OVERLOAD;

// Save and restore screenpart
FUNCTION timagesize(x1, y1, x2, y2: integer): Word;
PROCEDURE getTimage(x1, y1, x2, y2: integer; VAR puffer);
PROCEDURE putTimage(X, Y: integer; VAR puffer);

CONST
  Blink    = 128;
  c40      = 1;
  c80      = 2;
  co80     = 2;
  Mono     = 3;
  VK_SCAN = #0;
  LastMode = c80;
  windmin  = $0101;
  font8x8  = 256;

TYPE
  TMessageEvent =
    {$IFDEF MSWINDOWS} PROCEDURE(VAR Msg: TMsg; VAR Handled: Boolean) OF OBJECT;
    {$ELSE} PROCEDURE(VAR Msg: TLMessage; VAR Handled: Boolean) OF OBJECT;
       TCharInfo=record
         Ch:Char;
         attr:Byte;
       end;

       TMouseEventRecord=record

       end;

    _COORD = record
          X : ShortInt;
          Y : ShortInt;
       end;
     TCOORD = _COORD;
     PCOORD = ^_COORD;

     _SMALL_RECT = record
          Left : ShortInt;
          Top : ShortInt;
          Right : ShortInt;
          Bottom : ShortInt;
       end;
     TSMALL_RECT = _SMALL_RECT;
     TSMALLRECT = _SMALL_RECT;
     PSMALL_RECT = ^_SMALL_RECT;


     _CONSOLE_SCREEN_BUFFER_INFO = packed record
          dwSize : _COORD;
          dwCursorPosition : _COORD;
          wAttributes : WORD;
          srWindow : _SMALL_RECT;
          dwMaximumWindowSize : _COORD;
       end;
     PCONSOLE_SCREEN_BUFFER_INFO = ^_CONSOLE_SCREEN_BUFFER_INFO;
     TCONSOLESCREENBUFFERINFO = _CONSOLE_SCREEN_BUFFER_INFO;
     PCONSOLESCREENBUFFERINFO = ^_CONSOLE_SCREEN_BUFFER_INFO;

    {$ENDIF}

  { TConsole }

  TConsole = CLASS(TComponent)
  PRIVATE
 {$IFDEF MSWINDOWS}
    FConsoleInfo:       TConsoleScreenBufferInfo;
 {$ELSE}
    //FConsoleInfo:       TConsoleScreenBufferInfo;
 {$ENDIF}
    FConsoleScreenRect: TRect;
    FOnKeyDown: TKeyEvent;
    FOnKeyPressed: TKeyPressEvent;
    FOnKeyUp: TKeyEvent;
    FOnMessage:         TMessageEvent;
    FOnMouseMoveEvent: TMouseMoveEvent;
    FOnMouseButton: TMouseEvent;
    FTerminate:         Boolean;
    FKeyBuffer : array[0..49] of Char;
    FKeyBufferInptr,
    FKeyBufferOutptr:integer;
    procedure SetOnKeyDown(AValue: TKeyEvent);
    procedure SetOnKeyPressed(AValue: TKeyPressEvent);
    procedure SetOnKeyUp(AValue: TKeyEvent);
    procedure SetOnMouseMove(AValue: TMouseMoveEvent);
    procedure SetOnMouseButton(AValue: TMouseEvent);
    procedure SetOnMessage(AValue: TMessageEvent);

  PUBLIC

    InHandle, OutHandle: Cardinal;
    MaxX:                Word;
    MaxY:                Word;
    DirectVideo:         Boolean;
    TextAttr:            Byte;
    textmaxy:            Byte;

    CONSTRUCTOR Create(AOwner: TComponent); OVERRIDE;
    /// <postconditions>Console filled with Character</postconditions>
    PROCEDURE FillConsole(CONST Character: Char);
    /// <postconditions>Console-rect filled with Character</postconditions>
    PROCEDURE FillRect(CONST R: TRect; CONST Character: Char);
    /// <postconditions>Textcolor set to Color</postconditions>
    PROCEDURE TextColor(CONST Color: TCGAColor);
    /// <postconditions>Background-Color set to Color Characters will be written with this Background)</postconditions>
    PROCEDURE TextBackground(CONST Color: TCGAColor);
    /// <author>C.Rosewich</author>
    PROCEDURE Window(x1, y1, x2, y2: integer);
    /// <author>C.Rosewich</author>
    FUNCTION WhereX: Byte;
    /// <author>C.Rosewich</author>
    FUNCTION WhereY: Word;
    /// <author>C.Rosewich</author>
    PROCEDURE GotoXY(X: TCols; Y: TRows);
    /// <author>C.Rosewich</author>
    FUNCTION timagesize(ir: TRect): integer;
    /// <author>C.Rosewich</author>
    FUNCTION getscreen(X, Y: integer): TCharInfo; OVERLOAD;
    /// <author>C.Rosewich</author>
    PROCEDURE Setscreen(X, Y: integer; Val: TCharInfo); OVERLOAD;
    /// <author>C.Rosewich</author>
    function KeyPressed: Boolean;
    /// <author>C.Rosewich</author>
    FUNCTION ReadKey: Char;
    /// <author>C.Rosewich</author>
    PROPERTY ClientRect: TRect READ FConsoleScreenRect WRITE FConsoleScreenRect;
    /// <author>C.Rosewich</author>
    PROPERTY screen[X, Y: integer]: TCharInfo READ getscreen WRITE Setscreen;
    /// <author>C.Rosewich</author>
    PROPERTY Terminated: Boolean READ FTerminate;
    /// <author>C.Rosewich</author>
    PROPERTY OnKeyDown: TKeyEvent READ FOnKeyDown WRITE SetOnKeyDown;
    /// <author>C.Rosewich</author>
    PROPERTY OnKeyup: TKeyEvent READ FOnKeyUp WRITE SetOnKeyUp;
    /// <author>C.Rosewich</author>
    PROPERTY OnKeyPressed: TKeyPressEvent READ FOnKeyPressed WRITE SetOnKeyPressed;
    /// <author>C.Rosewich</author>
    PROPERTY OnMessage: TMessageEvent READ FOnMessage WRITE SetOnMessage;
  PRIVATE
      {$IFDEF MSWINDOWS}     function ProcessMessage(out Msg: TMsg): Boolean;
    {$ELSE} function ProcessMessage(out Msg: TLMessage): Boolean;
    {$EndIf}

    Function KeyBufferCount:integer;
    procedure AppendKeyBuffer(aChar:Char);
  PUBLIC
    /// <author>C.Rosewich</author>
    PROCEDURE GetScreenRect(R: TRect; VAR puffer);
    /// <author>C.Rosewich</author>
    PROCEDURE PutScreenRect(R: TRect; CONST puffer);
    /// <author>C.Rosewich</author>
    PROCEDURE AppIdle(Sender: TObject; VAR Done: Boolean);
    /// <author>C.Rosewich</author>
    FUNCTION MousePos: TPoint;
    /// <author>J.Care</author>
    procedure WriteConsoleOutput(var buf; const coordbufSize,
      coordBufCoord: tpoint; scrrect: TRect); // screen buffer source rectangle
  END;

VAR
  Console:    TConsole;
  LastMEvent: TMouseEventRecord;

IMPLEMENTATION

USES
  types;

VAR
  Double:           DWORD;
  Coord:            TCoord;
  AlignmentPos:     Byte;
  OldTextAttribute: Byte;
  LastX, LastY:     Word;

  ConsoleInfo:       TConsoleScreenBufferInfo;
  ConsoleScreenRect: TSmallRect;

{$IFNDEF Compiler12p}

FUNCTION RectWidth(R: TRect): integer; INLINE;
BEGIN
  result := abs(R.Right - R.Left) + 1;
END;

FUNCTION RectHeight(R: TRect): integer; INLINE;
BEGIN
  result := abs(R.bottom - R.top) + 1;
END;
{$ENDIF}

FUNCTION StrToPChar(CONST S: STRING; CONST {%H-}D: STRING = #0): Pchar; INLINE;
{$IFDEF FPC}
{$IF not defined(FPC_FULLVERSION) or (FPC_FULLVERSION<30000)}
TYPE
  TCharArray = ARRAY [Word] OF Char;
  {$ENDIF}
{$ENDIF}
BEGIN
{$IFNdef FPC}
  result := Pchar(S);
{$ELSE}
{$IF defined(FPC_FULLVERSION) and (FPC_FULLVERSION>=30000)}
  result := Pchar(S);
{$ELSE}
  result := Pchar(@S[1]);
  IF TCharArray(result^)[Length(S) + 1] <> #0 THEN
    TCharArray(result^)[Length(S) + 1] := #0
    {$IFEND}
{$ENDIF}
END;

PROCEDURE SetTitle(CONST Title: STRING);
BEGIN
  {$ifdef MSWINDOWS}
  SetConsoleTitle(StrToPChar(Title));
  {$ENDIF}
END;

PROCEDURE FillConsole(CONST Character: Char);
BEGIN
  Console.FillConsole(Character);
END;

PROCEDURE ConsoleColor(CONST Color: TCGAColor);
VAR
  I: integer;
BEGIN
  FOR I := 0 TO ConsoleScreenRect.bottom DO
    BEGIN
      TextBackground(Color);
      FillConsole(#32);
    END;
  GotoXY(1, 1);
END;

PROCEDURE ClearConsole;
BEGIN
  FillConsole(#32);
END;

PROCEDURE ClrScr;
BEGIN
  FillConsole(#32);
END;

PROCEDURE TextColor(CONST Color: TCGAColor);
BEGIN
  Console.TextColor(Color);

END;

PROCEDURE TextBackground(CONST Color: TCGAColor);
BEGIN
  Console.TextBackground(Color)
END;

// Drukowanie tekstu na konsoli; równie¿ polskie ogonki s¹ obs³ugiwane

PROCEDURE TextOut(CONST Text: STRING = '';
  Alignment: TAlignment = taLeftJustify; InsertLine: Boolean = False);
{$IFNDEF DEFAULTS_WIDESTRING}
VAR
  ansi: PAnsiChar;
  S:    STRING;
{$ENDIF}
BEGIN
  IF Length(Text) <> 0 THEN
    BEGIN
{$IFNDEF DEFAULTS_WIDESTRING}
      S := Text;
      S := S + #0;
      ansi := stralloc(Length(S) + 2);
      TRY
        CharToOem(StrToPChar(S), ansi);
{$ENDIF}
        CASE Alignment OF
          taRightJustify:
            AlignmentPos := Console.MaxX - Length(Text);
          taCenter:
            AlignmentPos := (Console.MaxX - Length(Text)) DIV 2;
        END;
        IF Alignment <> taLeftJustify THEN
          GotoXY(AlignmentPos, WhereY);
        SetConsoleTextAttribute(Console.OutHandle, Console.TextAttr);
{$IFDEF DEFAULTS_WIDESTRING}
        IF InsertLine THEN
          Writeln(Text)
        ELSE
          WRITE(Text);
{$ELSE}
        IF InsertLine THEN
          Writeln(ansi)
        ELSE
          WRITE(ansi);
      FINALLY
        strdispose(ansi)
      END;
{$ENDIF}
    END
  ELSE
    WRITE;
END;

// Skrolowanie tekstu

PROCEDURE UnrollText(CONST Text: STRING; Wait: Cardinal;
  Alignment: TAlignment = taLeftJustify; InsertLine: Boolean = False);
VAR
  I: Cardinal;
{$IFNDEF DEFAULTS_WIDESTRING}
  ansi: PAnsiChar;
  S:    STRING;
{$ENDIF}
TYPE
  TAoC = ARRAY [0 .. MAXWORD] OF AnsiChar;
  PAoC = ^TAoC;

BEGIN
{$IFNDEF DEFAULTS_WIDESTRING}
  S := Text;
  TRY
    ansi := stralloc(Length(S) + 2);
    CharToOem(StrToPChar(S), ansi);
{$ENDIF}
    CASE Alignment OF
      taRightJustify:
        AlignmentPos := Console.MaxX - Length(Text) + 2;
      taCenter:
        AlignmentPos := (Console.MaxX - Length(Text) + 2) DIV 2;
    END;
    IF Alignment <> taLeftJustify THEN
      GotoXY(AlignmentPos, WhereY);
    FOR I := 1 TO Length(Text) DO
      BEGIN
        IF Text[I] = #13 THEN
          BEGIN
            Writeln;
            Continue;
          END
        ELSE
          BEGIN
{$IFDEF DEFAULTS_WIDESTRING}
            WRITE(Text[I - 1]);
{$ELSE}
            WRITE(PAoC(ansi)^[I - 1]);
{$ENDIF}
            Delay(Wait);
          END;
      END;
{$IFNDEF DEFAULTS_WIDESTRING}
  FINALLY
    freemem(ansi);
  END;
{$ENDIF}
  IF InsertLine THEN
    Writeln;
END;

PROCEDURE InsertText(X, Y: Byte; CONST Text: STRING);
BEGIN
  GotoXY(X, Y);
  TextOut(Text);
END;

PROCEDURE InsertTextOEM(X, Y: Byte; Text: ShortSTRING);
BEGIN
  GotoXY(X, Y);
  SetConsoleTextAttribute(Console.OutHandle, Console.TextAttr);
  WRITE(Text);
END;

PROCEDURE InsertChar(X, Y: Byte; CONST Character: Char);
BEGIN
  LastX := WhereX;
  LastY := WhereY;
  GotoXY(X, Y);
  TextOut(Character);
  GotoXY(LastX, LastY);
END;

PROCEDURE OverwriteText(X, Y: Byte; CONST Text: STRING);
VAR
  Size: DWORD;
  I:    integer;
BEGIN
  Size := 1;
  LastX := WhereX;
  LastY := WhereY;
  Coord.Y := Y - 1;
  FOR I := 1 TO Length(Text) DO
    BEGIN
      Coord.X := X + I - 2;
      FillConsoleOutputCharacter(Console.OutHandle, Text[I], Size,
        Coord, Double);
    END;
  GotoXY(LastX, LastY);
END;

PROCEDURE ClrEol;
CONST
  textwidth = 80;
VAR
  Coord: TCoord;
  I:     integer;
BEGIN
  GetConsoleScreenBufferInfo(Console.OutHandle, ConsoleInfo);
  Coord := TCoord(ConsoleInfo.dwCursorPosition);
  FOR I := Coord.X + 1 TO textwidth DO
    WRITE(' ');
  SetConsoleCursorPosition(Console.OutHandle, Coord)

END;

PROCEDURE OverwriteText(FromX, ToX, Y: Byte; CONST Text: STRING);
VAR
  Size: DWORD;
  I:    integer;
BEGIN
  Size := 1;
  LastX := WhereX;
  LastY := WhereY;
  Coord.Y := Y - 1;
  FOR I := 1 TO Length(Text) DO
    BEGIN
      Coord.X := FromX + I - 2;
      FillConsoleOutputCharacter(Console.OutHandle, Text[I], Size,
        Coord, Double);
      IF Coord.X > ToX THEN
        Break
      ELSE
        Continue;
    END;
  GotoXY(LastX, LastY);
END;

PROCEDURE OverwriteChar(X, Y: Byte; CONST Character: Char);
VAR
  Size: DWORD;
BEGIN
  Size := 1;
  LastX := WhereX;
  LastY := WhereY;
  Coord.X := X - 1;
  Coord.Y := Y - 1;
  SetConsoleTextAttribute(Console.OutHandle, Console.TextAttr);
  FillConsoleOutputCharacter(Console.OutHandle, Character, Size, Coord, Double);
  GotoXY(LastX, LastY);
END;

FUNCTION AssignTextFile(CONST Path: STRING; EndLine: Boolean): Boolean;
VAR
  TF:   TextFile;
  Text: STRING;
BEGIN
  result := False;
  AssignFile(TF, Path);
  TRY
    TRY
      IF FileExists(Path) THEN
        BEGIN
          Reset(TF);
          WHILE NOT Eof(TF) DO
            BEGIN
              Readln(TF, Text);
              IF EndLine THEN
                Writeln(Text)
              ELSE
                WRITE(Text);
            END;
          result := True;
        END;
    EXCEPT
      result := False;
    END;
  FINALLY
    IF FileExists(Path) THEN
      CloseFile(TF);
  END;
END;

FUNCTION AssignTextFile(CONST Path: STRING; OUT TextFromFile: STRING;
  EndLine: Boolean): Boolean;
VAR
  TF:   TextFile;
  Text: STRING;
BEGIN
  result := False;
  AssignFile(TF, Path);
  TRY
    TRY
      IF FileExists(Path) THEN
        BEGIN
          Reset(TF);
          WHILE NOT Eof(TF) DO
            BEGIN
              Readln(TF, Text);
              IF EndLine THEN
                Text := Text + #13
              ELSE
                Text := Text;
              TextFromFile := TextFromFile + Text;
            END;
          GotoX(WhereX - 2);
          result := True;
        END;
    EXCEPT
      result := False;
    END;
  FINALLY
    IF FileExists(Path) THEN
      CloseFile(TF);
  END;
END;

PROCEDURE GotoXY(X: TCols; Y: TRows);
BEGIN
  Coord.X := X - 1;
  Coord.Y := Y - 1;
  SetConsoleCursorPosition(Console.OutHandle, Coord);
END;

PROCEDURE GotoX(X: TCols);
BEGIN
  Coord.X := X - 1;
  Coord.Y := 0;
  SetConsoleCursorPosition(Console.OutHandle, Coord);
END;

PROCEDURE GotoY(Y: TRows);
BEGIN
  Coord.X := 0;
  Coord.Y := Y - 1;
  SetConsoleCursorPosition(Console.OutHandle, Coord);
END;

FUNCTION WhereX: Byte;
BEGIN
  GetConsoleScreenBufferInfo(Console.OutHandle, ConsoleInfo);
  result := TCoord(ConsoleInfo.dwCursorPosition).X + 1;
END;

FUNCTION WhereY: Word;
BEGIN
  GetConsoleScreenBufferInfo(Console.OutHandle, ConsoleInfo);
  result := TCoord(ConsoleInfo.dwCursorPosition).Y + 1;
END;

PROCEDURE SetCursorSize(Size: integer; visible: Boolean);
VAR
  CsI: _CONSOLE_CURSOR_INFO;
BEGIN
  CsI.dwSize := Size;
  CsI.bVisible := visible;
  SetConsoleCursorInfo(Console.InHandle, CsI)
END;

// Kod nieznanego programisty;
{$IFNDEF win64}

PROCEDURE SetPort(Address, Value: Word);
VAR
  bValue: Byte;
BEGIN
{$IFNDEF FPC}
  bValue := Trunc(Value AND 255);
  ASM
    mov DX, address
    mov AL, bValue
    out DX, AL
  END;
{$ENDIF}
END;

FUNCTION GetPort(Address: Word): Word;
VAR
  bValue: Byte;
BEGIN
{$IFNDEF FPC}
  ASM
    mov DX, address
    in  AL, DX
    mov bValue, AL
  END;
  result := bValue;
{$ELSE}
  result := 0;
{$ENDIF}
END;
{$ENDIF}
{$IFNDEF win64}

PROCEDURE Sound(Freq: Word); OVERLOAD;
VAR
  B: Word;
BEGIN
  IF Freq > 18 THEN
    BEGIN
      Freq := Word(1193181 DIV LongInt(Freq));
      B := GetPort($61);
      IF (B AND 3) = 0 THEN
        BEGIN
          SetPort($61, B OR 3);
          { SetPort($43, $B6); }
        END;
      SetPort($42, Freq);
      SetPort($42, (Freq SHR 8));
    END;
END;

PROCEDURE NoSound;
VAR
  wValue: Word;
BEGIN
  wValue := GetPort($61);
  wValue := wValue AND $FC;
  SetPort($61, wValue);
END;
{$ENDIF}

FUNCTION IsWinNT: Boolean;
VAR
  OS: TOsVersionInfo;
BEGIN
  OS.dwOSVersionInfoSize := SizeOf(OS);
  GetVersionEx(OS);
  IF OS.dwPlatformId = VER_PLATFORM_WIN32_NT THEN
    result := True
  ELSE
    result := False;
END;

PROCEDURE Sound(CONST Hz: THz; Duration: Cardinal); OVERLOAD;
BEGIN
{$IFNDEF win64}
  IF NOT IsWinNT THEN
    BEGIN
      Sound(Hz);
      Delay(Duration);
      NoSound;
    END
  ELSE
{$ENDIF}
    Windows.Beep(Hz, Duration);
END;

PROCEDURE SoundInformation;
BEGIN
  Sound(1047, 100);
  Sound(1109, 100);
  Sound(1175, 100);
END;

PROCEDURE SoundWarning;
BEGIN
  Sound(2093, 100);
  Sound(1976, 100);
  Sound(1857, 100);
END;

PROCEDURE SoundError;
BEGIN
  Sound(40, 500);
END;

PROCEDURE Delay(CONST Miliseconds: Cardinal);
VAR
{$if declared(GetTickCount64)}
  Tick, ms: int64;
{$else}
  Tick, ms: integer;
{$endif}
  Event:    THandle;
  Msg:      TMsg;

BEGIN
  ms := Miliseconds;
  Event := CreateEvent(NIL, False, False, NIL);
  TRY
   {$if declared(GetTickCount64)}
    Tick := GetTickCount64 + int64(Miliseconds);
   {$else}
   Tick := GetTickCount + DWORD(Miliseconds);
   {$endif}
    WHILE (ms > 0)  DO
      BEGIN
        Console.ProcessMessage(Msg);
        sleep(5);
        IF Console.Terminated THEN
          Exit;
        {$if declared(GetTickCount64)}
        ms := Tick - GetTickCount64;
        {$else}
        ms := Tick - GetTickCount;
        {$endif}
      END;
  FINALLY
    FileClose(Event); { *Converted from CloseHandle* }
    Console.ProcessMessage(Msg);
  END;
END;

FUNCTION KeyPressed: Boolean;

begin
  result := False;
  TRY
    IF Assigned(Console) AND NOT Console.FTerminate THEN
      result := Console.KeyPressed;
  EXCEPT
  END;
end;

FUNCTION ReadKey: Char;

BEGIN
  result := #0;
   TRY
    IF Assigned(Console) AND NOT Console.FTerminate THEN
      result := Console.ReadKey;
  EXCEPT
  end;
END;

PROCEDURE FullScreen;
BEGIN
  {$IFDEF MSWINDOWS}
  keybd_event(VK_MENU, MapVirtualKey(VK_MENU, 0), 0, 0);
  keybd_event(VK_RETURN, MapVirtualKey(VK_RETURN, 0), 0, 0);
  keybd_event(VK_RETURN, MapVirtualKey(VK_RETURN, 0), KEYEVENTF_KEYUP, 0);
  keybd_event(VK_MENU, MapVirtualKey(VK_MENU, 0), KEYEVENTF_KEYUP, 0);
  {$ENDIF}
END;

FUNCTION GetCodePage: Cardinal;
BEGIN
  result := GetConsoleOutputCP;
END;

FUNCTION SetCodePage(CONST CodePage: Cardinal): Boolean;
BEGIN
  result := SetConsoleOutputCP(CodePage);
END;

PROCEDURE TextMode(mode: integer);
VAR
  smr: TSmallRect;
BEGIN
  IF mode AND font8x8 > 0 THEN
    BEGIN
      smr.top := 1;
      smr.Left := 1;
      smr.Right := 80;
      smr.bottom := 50;
      SetConsoleWindowInfo(Console.OutHandle, True, smr);
      Console.textmaxy := 50;
      GotoXY(1, 1);
    END
  ELSE
    BEGIN
      smr.top := 1;
      smr.Left := 1;
      smr.Right := 80;
      smr.bottom := 25;
      SetConsoleWindowInfo(Console.OutHandle, True, smr);
      Console.textmaxy := 25;
      GotoXY(1, 1);
    END;
END;

FUNCTION GetEnvironmentVariable(CONST Name: STRING = 'COMSPEC')
  : STRING; OVERLOAD;

BEGIN
  result :=SysUtils.GetEnvironmentVariable(Name);
END;

FUNCTION SetEnvironmentVariable(CONST Name, Value: STRING): Boolean; OVERLOAD;
BEGIN
  result := Windows.SetEnvironmentVariable(StrToPChar(NAME), StrToPChar(Value));
END;

PROCEDURE gettime(VAR hu, mi, h1, h2: Word);
VAR
  SystemTime: TSystemTime;
BEGIN
  GetLocalTime(SystemTime);
  WITH SystemTime DO
    BEGIN
      hu := SystemTime.wHour;
      mi := SystemTime.wMinute;
      h1 := SystemTime.wSecond;
      h2 := SystemTime.wMilliseconds;
    END;
END;

FUNCTION getmemb800(adr: integer): Byte;
VAR
  srctReadRect:                TSmallRect;
  chinfo:                      TCharInfo;
  coordBufSize, coordBufCoord: TCoord;

BEGIN
  srctReadRect.top := adr DIV 160; // top left: row 0, col 0
  srctReadRect.Left := (adr DIV 2) MOD 80;
  srctReadRect.bottom := srctReadRect.top; // bot. right: row 1, col 79
  srctReadRect.Right := srctReadRect.Left;

  coordBufSize.Y := 1;
  coordBufSize.X := 1;

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  ReadConsoleOutputA(Console.OutHandle, // screen buffer to read from
    @chinfo, // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

  IF adr MOD 2 = 0 THEN
    result := Byte(chinfo.AsciiChar)
  ELSE
    result := chinfo.Attributes;
END;

PROCEDURE SetMemB800(adr: integer; Val: Byte);
VAR
  srctReadRect:                TSmallRect;
  chinfo:                      TCharInfo;
  coordBufSize, coordBufCoord: TCoord;

BEGIN
  srctReadRect.top := adr DIV 160; // top left: row 0, col 0
  srctReadRect.Left := (adr DIV 2) MOD 80;
  srctReadRect.bottom := srctReadRect.top; // bot. right: row 1, col 79
  srctReadRect.Right := srctReadRect.Left;

  coordBufSize.Y := 1;
  coordBufSize.X := 1;

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  ReadConsoleOutputA(Console.OutHandle, // screen buffer to read from
    @chinfo, // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

  IF adr MOD 2 = 0 THEN
{$IFDEF SUPPORTS_UNICODE}
    chinfo.AsciiChar := AnsiChar(Val)
{$ELSE}
    chinfo.AsciiChar := Char(Val)
{$ENDIF}
  ELSE
    chinfo.Attributes := Val;

  WriteConsoleOutputA(Console.OutHandle, // screen buffer to read from
    @chinfo, // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

END;

FUNCTION getmemb800(adr: integer; count: Word): ShortSTRING;
VAR
  srctReadRect:                TSmallRect;
  chinfo:                      ARRAY OF TCharInfo;
  coordBufSize, coordBufCoord: TCoord;
  I:                           integer;

BEGIN
  srctReadRect.top := adr DIV 160; // top left: row 0, col 0
  srctReadRect.Left := (adr DIV 2) MOD 80;
  srctReadRect.bottom := srctReadRect.top; // bot. right: row 1, col 79
  srctReadRect.Right := srctReadRect.Left + (count - 1) DIV 2;

  setlength(chinfo, (count + 1) DIV 2);
  setlength(result, count);

  coordBufSize.Y := 1;
  coordBufSize.X := (count + 1) DIV 2;

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  ReadConsoleOutput(Console.OutHandle, // screen buffer to read from
    @chinfo[0], // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

  FOR I := 0 TO count - 1 DO
    IF (adr + I) MOD 2 = 0 THEN
      result[I + 1] := chinfo[I DIV 2].AsciiChar
    ELSE
{$IFDEF SUPPORTS_UNICODE}
      result[I + 1] := AnsiChar(chinfo[I DIV 2].Attributes);
{$ELSE}
      result[I + 1] := Char(chinfo[I DIV 2].Attributes);
{$ENDIF}
END;

PROCEDURE SetMemB800(adr: integer; Line: ShortSTRING; count: Word);
VAR
  srctReadRect:                TSmallRect;
  chinfo:                      ARRAY OF TCharInfo;
  coordBufSize, coordBufCoord: TCoord;
  I:                           integer;
BEGIN
  srctReadRect.top := adr DIV 160; // top left: row 0, col 0
  srctReadRect.Left := (adr DIV 2) MOD 80;
  srctReadRect.bottom := srctReadRect.top; // bot. right: row 1, col 79
  srctReadRect.Right := srctReadRect.Left + (count - 1) DIV 2;

  setlength(chinfo, (count + 1) DIV 2);

  coordBufSize.Y := 1;
  coordBufSize.X := (count + 1) DIV 2;

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  FOR I := 0 TO count - 1 DO
    IF (adr + I) MOD 2 = 0 THEN
      chinfo[I DIV 2].AsciiChar := Line[I + 1]
    ELSE
      chinfo[I DIV 2].Attributes := Byte(Line[I + 1]);

  WriteConsoleOutput(Console.OutHandle, // screen buffer to read from
    @chinfo[0], // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

END;

FUNCTION ctrlHandler(ctrlType: DWORD):
{$IFDEF FPC}longbool{$ELSE}Boolean{$ENDIF}; STDCALL;
BEGIN
  CASE ctrlType OF
    CTRL_C_Event:
      Writeln('Please type "quit" to exit');
    ctrl_close_event:
      BEGIN
        Writeln('Exiting Console With Close event.');
        Delay(2000);
        halt;
      END;
    ctrl_break_event:
      BEGIN
        Writeln('Exiting Console With ctrl - break event.');
        Delay(2000);
        halt;
      END;
    ctrl_logoff_event:
      BEGIN
        Writeln('User is logging Out, aborting');
        Delay(2000);
        halt;
      END;
    ctrl_shutdown_event:
      BEGIN
        Writeln('Computer is shutting down, aborting');
        Delay(2000);
        halt;
      END
  ELSE
    BEGIN
      Writeln('Unknown Event');
    END;
  END;
  result := True;
END;

FUNCTION timagesize(x1, y1, x2, y2: integer): Word;

BEGIN
  result := (abs(x2 - x1) + 1) * (abs(y1 - y2) + 1) * 2 + 2;
END;

TYPE
  PAoB = ^TAoB;
  TAoB = ARRAY [0 .. 32000] OF Byte;

PROCEDURE getTimage(x1, y1, x2, y2: integer; VAR puffer);

VAR
  X, Y:                        integer;
  ar:                          PAoB;
  srctReadRect:                TSmallRect;
  chinfo:                      ARRAY OF TCharInfo;
  coordBufSize, coordBufCoord: TCoord;
  I:                           integer;

BEGIN
  IF x2 < x1 THEN
    BEGIN
      X := x2;
      x2 := x1;
      x1 := X
    END;
  IF y2 < y1 THEN
    BEGIN
      Y := y2;
      y2 := y1;
      y1 := Y
    END;
  ar := @puffer;
  ar^[0] := x2 - x1;
  ar^[1] := y2 - y1;

  (*
   for y:=y1-1 to y2-1 do
   for x:=x1*2-2 to x2*2-1 do
   begin
   inc (z);
   ar^[z]:=getmemb800(x+y*160);
   end;
  *)
  srctReadRect.top := y1 - 1; // top left: row 0, col 0
  srctReadRect.Left := x1 - 1;
  srctReadRect.bottom := y2 - 1; // bot. right: row 1, col 79
  srctReadRect.Right := x2 - 1;

  setlength(chinfo, (abs(x2 - x1) + 1) * (abs(y1 - y2) + 1));

  coordBufSize.Y := abs(y1 - y2) + 1;
  coordBufSize.X := abs(x2 - x1) + 1;

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  ReadConsoleOutputA(Console.OutHandle, // screen buffer to read from
    @chinfo[0], // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

  FOR I := 0 TO HIGH(chinfo) DO
    BEGIN
      ar^[I * 2 + 2] := Byte(chinfo[I].AsciiChar);
      ar^[I * 2 + 3] := chinfo[I].Attributes;
    END

END;

PROCEDURE putTimage(X, Y: integer; VAR puffer);

VAR // xi,yi,z:integer;
  ar:                          PAoB;
  srctReadRect:                TSmallRect;
  chinfo:                      ARRAY OF TCharInfo;
  coordBufSize, coordBufCoord: TCoord;
  I:                           integer;

BEGIN
  ar := @puffer;
  (*
   for yi:=y-1 to y+ar^[1]-1 do
   for xi:=x*2-2 to (x+ar^[0])*2-1 do
   begin
   inc (z);
   if (xi>=0) and (xi<=159) and
   (yi>=0) and (yi<=textmaxy-1) then
   setmemb800(xi+yi*160,ar^[z]);
   end;
  *)
  srctReadRect.top := Y - 1; // top left: row 0, col 0
  srctReadRect.Left := X - 1;
  srctReadRect.bottom := Y + ar^[1] - 1; // bot. right: row 1, col 79
  srctReadRect.Right := X + ar^[0] - 1;

  setlength(chinfo, (ar^[0] + 1) * (ar^[1] + 1));

  coordBufSize.Y := ar^[1] + 1;
  coordBufSize.X := ar^[0] + 1;

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  FOR I := 0 TO HIGH(chinfo) DO
    BEGIN
      Byte(chinfo[I].AsciiChar) := ar^[I * 2 + 2];
      chinfo[I].Attributes := ar^[I * 2 + 3];
    END;

  WriteConsoleOutputA(Console.OutHandle, // screen buffer to read from
    @chinfo[0], // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

END;

PROCEDURE Window(X, Y, x2, y2: integer);

BEGIN
  Console.Window(X, Y, x2, y2);
END;

{TConsole}

constructor TConsole.Create(AOwner: TComponent);

BEGIN
  INHERITED;
  OutHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  InHandle := GetStdHandle(STD_INPUT_HANDLE);
  SetFileApisToOEM;
  FlushConsoleInputBuffer(InHandle);
  FOnMessage:=nil;
  GetConsoleScreenBufferInfo(OutHandle, FConsoleInfo);
  TextAttr := FConsoleInfo.wAttributes; // $07
  OldTextAttribute := TextAttr;
  MaxX := FConsoleInfo.dwSize.X;
  MaxY := FConsoleInfo.dwSize.Y;
  ConsoleScreenRect.Top:=0;
  ConsoleScreenRect.left:=0;
  ConsoleScreenRect.bottom:=MaxY;
  ConsoleScreenRect.right:=MaxX;

  if Maxy>255 then
    textmaxy := 255
  else
    textmaxy := Maxy;
END;

function TConsole.ProcessMessage(out Msg: TMsg): Boolean;
VAR
  Unicode:   Boolean;
  Handled:   Boolean;
  MsgExists: Boolean;
   InEvents:  ARRAY OF TInputRecord;
   dw: DWORD;
   count: DWORD;
   I: Integer;
  lShiftstate: TShiftState;
BEGIN
  result := False;
  IF PeekMessage(Msg, 0, 0, $ffffffff, PM_NOREMOVE) THEN
    BEGIN
      Unicode := (Msg.hwnd <> 0) AND IsWindowUnicode(Msg.hwnd);
      IF Unicode THEN
        MsgExists := PeekMessageW(Msg, 0, 0, 0, PM_REMOVE)
      ELSE
        MsgExists := PeekMessage(Msg, 0, 0, 0, PM_REMOVE);
      IF NOT MsgExists THEN
        Exit;
      result := True;
      IF Msg.Message <> WM_QUIT THEN
        BEGIN
          Handled := False;
          IF Assigned(FOnMessage) THEN
            FOnMessage(Msg, Handled);
          if not handled  then
            begin

            end;
          IF {not IsPreProcessMessage(Msg) and
           not IsHintMsg(Msg) and }
            NOT Handled { and
            not IsMDIMsg(Msg) and
           not IsKeyMsg(Msg) and
           not IsDlgMsg(Msg) }
          THEN
            BEGIN
              TranslateMessage(Msg);
              IF Unicode THEN
                DispatchMessageW(Msg)
              ELSE
                DispatchMessage(Msg);
            END;
        END
      ELSE
        FTerminate := True;
    END
  else
    begin
      dw:=0;
      IF not FTerminate THEN
        begin
        if not GetNumberOfConsoleInputEvents(InHandle, count)  then
           count :=0;end
      else
        count :=0;
      setlength(InEvents, count);
       IF count > 0 THEN
         begin
         ReadConsoleInput(InHandle, InEvents[0], count, dw);
         for I := 0 to count -1 do;
         IF (InEvents[I].EventType = KEY_EVENT) THEN
           IF (InEvents[I].Event.KeyEvent.bKeyDown) THEN
             begin
               move(InEvents[I].Event.KeyEvent.dwControlKeyState,lShiftstate,
                 sizeof(cardinal));
               if assigned(FOnKeyDown) then
                 FOnKeyDown(self,InEvents[I].Event.KeyEvent.wVirtualKeyCode,
                  lShiftState);
               if (InEvents[I].Event.KeyEvent.AsciiChar = #0) and
                  (InEvents[I].Event.KeyEvent.wVirtualKeyCode > 0) THEN
                 begin
                   AppendKeyBuffer(VK_SCAN);
                   AppendKeyBuffer(  Char(InEvents[I].Event.KeyEvent.wVirtualKeyCode AND $FF));
                 end
               else
               if (InEvents[I].Event.KeyEvent.AsciiChar <> #0) then
{$IFNDEF SUPPORTS_UNICODE}
  AppendKeyBuffer(InEvents[I].Event.KeyEvent.AsciiChar);
{$ELSE}
  AppendKeyBuffer(InEvents[I].Event.KeyEvent.UnicodeChar);
{$ENDIF}
             end
           ELSE
           begin
             move(InEvents[I].Event.KeyEvent.dwControlKeyState,lShiftstate,
                 sizeof(cardinal));
             if assigned(FOnKeyUp) then
               FOnKeyUp(self,InEvents[I].Event.KeyEvent.wVirtualKeyCode,
                  lShiftstate )
           end
          else IF (InEvents[I].EventType = _MOUSE_EVENT) and (KeyBufferCount<10) THEN
      BEGIN
        LastMEvent := InEvents[I].Event.MouseEvent;
        appendkeyBuffer(VK_Scan);
        appendkeyBuffer(VK_Scan);
      END;
    end;
   end;
end;


function TConsole.KeyBufferCount: integer;
begin
  result := (FKeyBufferInptr-FKeyBufferOutptr+(high(FKeyBuffer)+1)) mod (high(FKeyBuffer)+1);
end;

procedure TConsole.AppendKeyBuffer(aChar: Char);
var
  lNewP: Integer;
begin
  lNewP := (FKeyBufferInptr+1) mod (high(FKeyBuffer)+1);
  if lNewP = FKeyBufferOutptr then
    FKeyBufferOutptr:=(FKeyBufferOutptr+1) mod (high(FKeyBuffer)+1);
  FKeyBuffer[lNewP] := aChar;
  FKeyBufferInptr := lNewP;
end;


function TConsole.KeyPressed: Boolean;

var msg:TMsg;
BEGIN
  result := false;
  IF NOT FTerminate THEN
    begin
      ProcessMessage(Msg);
      result := KeyBufferCount>0;
      if not result then
        sleep(0);
    end;
END;

function TConsole.ReadKey: Char;
var msg:TMsg;
  //buff:array[0..19] of char;
  //dw: DWORD;
begin
  while (KeyBufferCount=0) and not Fterminate do
    ProcessMessage(Msg);
  if FkeyBufferinptr <> FkeyBufferoutptr then
    begin
     FkeyBufferOutPtr := (fKeyBufferOutPtr +1) mod (high(FKeyBuffer)+1);
      result := FKeyBuffer[fKeyBufferOutPtr];
    end
  else
    result := #0;
end;

function TConsole.timagesize(ir: TRect): integer;
BEGIN
  result := RectWidth(ir) * RectHeight(ir) * 2 + 2;
END;

procedure TConsole.SetOnKeyDown(AValue: TKeyEvent);
begin
//  if FOnKeyDown=AValue then Exit;
  FOnKeyDown:=AValue;
end;

procedure TConsole.SetOnKeyPressed(AValue: TKeyPressEvent);
begin
 // if FOnKeyPressed=AValue then Exit;
  FOnKeyPressed:=AValue;
end;

procedure TConsole.SetOnKeyUp(AValue: TKeyEvent);
begin
 // if FOnKeyUp=AValue then Exit;
  FOnKeyUp:=AValue;
end;

procedure TConsole.SetOnMouseMove(AValue: TMouseMoveEvent);
begin
  FOnMouseMoveEvent:=AValue;
end;

procedure TConsole.SetOnMouseButton(AValue: TMouseEvent);

begin
  FOnMouseButton := AValue;
end;

procedure TConsole.SetOnMessage(AValue: TMessageEvent);
begin
 // if FOnMessage=AValue then Exit;
  FOnMessage:=AValue;
end;

procedure TConsole.FillConsole(const Character: Char);

BEGIN
  Coord.X := 0;
  Coord.Y := 0;
  FillConsoleOutputAttribute(OutHandle, TextAttr, FConsoleInfo.dwSize.X *
    FConsoleInfo.dwSize.Y, Coord, Double);
  FillConsoleOutputCharacter(OutHandle, Character, FConsoleInfo.dwSize.X *
    FConsoleInfo.dwSize.Y, Coord, Double);
  SetConsoleCursorPosition(OutHandle, Coord);
END;

procedure TConsole.FillRect(const R: TRect; const Character: Char);
VAR
  J: integer;

BEGIN
  FOR J := R.bottom DOWNTO R.top DO
    BEGIN
      Coord.X := R.Left;
      Coord.Y := J;
      FillConsoleOutputAttribute(OutHandle, TextAttr, RectWidth(R),
        Coord, Double);
      FillConsoleOutputCharacter(OutHandle, Character, RectWidth(R),
        Coord, Double);
    END;
  SetConsoleCursorPosition(OutHandle, Coord);
END;

procedure TConsole.TextColor(const Color: TCGAColor);
BEGIN
  TextAttr := (ord(Color) AND $0F) OR (TextAttr AND $F0);
  SetConsoleTextAttribute(OutHandle, TextAttr);
END;

procedure TConsole.TextBackground(const Color: TCGAColor);
BEGIN
  TextAttr := (ord(Color) SHL 4) OR (TextAttr AND $0F);
  SetConsoleTextAttribute(OutHandle, TextAttr);
END;

procedure TConsole.Window(x1, y1, x2, y2: integer);
VAR
  cr: TRect;
BEGIN
  cr.TopLeft := point(x1, y1);
  cr.BottomRight := point(x2 - x1 + 1, y2 - y1 + 1);
  ClientRect := cr;
END;

function TConsole.WhereX: Byte;
BEGIN
  GetConsoleScreenBufferInfo(OutHandle, FConsoleInfo);
  result := FConsoleInfo.dwCursorPosition.X + 1;
END;

function TConsole.WhereY: Word;
BEGIN
  GetConsoleScreenBufferInfo(OutHandle, FConsoleInfo);
  result := FConsoleInfo.dwCursorPosition.Y + 1;
END;

procedure TConsole.GotoXY(X: TCols; Y: TRows);
BEGIN
  Coord.X := X - 1;
  Coord.Y := Y - 1;
  SetConsoleCursorPosition(OutHandle, Coord);
END;

procedure TConsole.AppIdle(Sender: TObject; var Done: Boolean);
VAR
  Tick: ShortSTRING;
BEGIN
  {$if declared(GetTickCount64)}
  Tick := ShortSTRING(inttostr(GetTickCount64 MOD 1000));
  {$else}
  Tick := ShortSTRING(inttostr(GetTickCount MOD 1000));
  {$endif}
  SetMemB800(150, Tick, 4);
  Done := True;
END;

function TConsole.getscreen(X, Y: integer): TCharInfo;
VAR
  srctReadRect:                TSmallRect;
  coordBufSize, coordBufCoord: TCoord;

BEGIN
  srctReadRect.top := Y; // top left: row 0, col 0
  srctReadRect.Left := X;
  srctReadRect.bottom := srctReadRect.top; // bot. right: row 1, col 79
  srctReadRect.Right := srctReadRect.Left;

  coordBufSize.Y := 1;
  coordBufSize.X := 1;

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  ReadConsoleOutput(Console.OutHandle, // screen buffer to read from
    @result, // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle
END;

procedure TConsole.Setscreen(X, Y: integer; Val: TCharInfo);
VAR
  srctReadRect:                TSmallRect;
  coordBufSize, coordBufCoord: TCoord;

BEGIN
  srctReadRect.top := Y; // top left: row 0, col 0
  srctReadRect.Left := X;
  srctReadRect.bottom := srctReadRect.top; // bot. right: row 1, col 79
  srctReadRect.Right := srctReadRect.Left;

  coordBufSize.Y := 1;
  coordBufSize.X := 1;

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  WriteConsoleOutputA(Console.OutHandle, // screen buffer to read from
    @Val, // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

END;

procedure TConsole.GetScreenRect(R: TRect; var puffer);

VAR
  X, Y:                        integer;
  ar:                          PAoB;
  srctReadRect:                TSmallRect;
  chinfo:                      ARRAY OF TCharInfo;
  coordBufSize, coordBufCoord: TCoord;
  I:                           integer;

BEGIN
  IF R.Right < R.Left THEN
    BEGIN
      X := R.Right;
      R.Right := R.Left;
      R.Left := X
    END;
  IF R.bottom < R.top THEN
    BEGIN
      Y := R.bottom;
      R.bottom := R.top;
      R.top := Y
    END;
  ar := @puffer;
  ar^[0] := RectWidth(R);
  ar^[1] := RectHeight(R);

  (*
   for y:=r.Top-1 to r.Bottom-1 do
   for x:=r.Left*2-2 to r.Right*2-1 do
   begin
   inc (z);
   ar^[z]:=getmemb800(x+y*160);
   end;
  *)
  srctReadRect.Left := R.Left;
  srctReadRect.top := R.top;
  srctReadRect.Right := R.Right;
  srctReadRect.bottom := R.bottom; // top left: row 0, col 0

  setlength(chinfo, RectWidth(R) * RectHeight(R) + 1);

  coordBufSize.X := RectWidth(R);
  coordBufSize.Y := RectHeight(R);

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  ReadConsoleOutputA(Console.OutHandle, // screen buffer to read from
    @chinfo[0], // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

  FOR I := 0 TO HIGH(chinfo) DO
    BEGIN
      ar^[I * 2 + 2] := Byte(chinfo[I].AsciiChar);
      ar^[I * 2 + 3] := chinfo[I].Attributes;
    END

END;

procedure TConsole.PutScreenRect(R: TRect; const puffer);

VAR // xi,yi,z:integer;
  ar:                          PAoB;
  srctReadRect:                TSmallRect;
  chinfo:                      ARRAY OF TCharInfo;
  coordBufSize, coordBufCoord: TCoord;
  I:                           integer;

BEGIN
  ar := @puffer;
  (*
   for yi:=r.left-1 to r.left+ar^[1]-1 do
   for xi:=r.Top*2-2 to (r.Top+ar^[0])*2-1 do
   begin
   inc (z);
   if (xi>=0) and (xi<=159) and
   (yi>=0) and (yi<=textmaxy-1) then
   setmemb800(xi+yi*160,ar^[z]);
   end;
  *)
  srctReadRect.top := R.Left - 1; // top left: row 0, col 0
  srctReadRect.Left := R.top - 1;
  srctReadRect.bottom := R.bottom; // bot. right: row 1, col 79
  srctReadRect.Right := R.Right;

  setlength(chinfo, (ar^[0] + 1) * (ar^[1] + 1));

  coordBufSize.X := ar^[1] + 1;
  coordBufSize.Y := ar^[0] + 1;

  // The top left destination cell of the temporary buffer is
  // row 0, col 0.

  coordBufCoord.X := 0;
  coordBufCoord.Y := 0;

  FOR I := 0 TO HIGH(chinfo) DO
    BEGIN
      Byte(chinfo[I].AsciiChar) := ar^[I * 2 + 2];
      chinfo[I].Attributes := ar^[I * 2 + 3];
    END;

  WriteConsoleOutputA(Console.OutHandle, // screen buffer to read from
    @chinfo[0], // buffer to copy into
    coordBufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle

END;

function TConsole.MousePos: TPoint;

BEGIN
  result := point(LastMEvent.dwMousePosition.X, LastMEvent.dwMousePosition.Y);
END;

procedure TConsole.WriteConsoleOutput( var buf;const coordbufSize,
  coordBufCoord: tpoint;scrrect:TRect);

function recttoSmallrect(r:TRect):TSmallRect;
begin
  result.Top := r.Top;
  result.Left := r.Left;
  result.Bottom := r.Bottom;
  result.Right := r.Right;
end;

var
  smr: TSmallRect;
begin
  smr := recttoSmallrect(scrrect);
  WriteConsoleOutputA(Console.OutHandle, // screen buffer to read from
    @buf, // buffer to copy into
    TCoord( PointToSmallPoint(coordbufSize)), // col-row size of chiBuffer
    TCoord(PointToSmallPoint(coordBufCoord)), // top left dest. cell in chiBuffer
    smr);
end;

INITIALIZATION

Console := TConsole.Create(NIL);
SetConsoleCtrlHandler(@ctrlHandler, True);

// WindMin := $0101;
// WindMax := $1950;

FINALIZATION

SetConsoleTextAttribute(Console.OutHandle, OldTextAttribute);
Console.Free;

END.
