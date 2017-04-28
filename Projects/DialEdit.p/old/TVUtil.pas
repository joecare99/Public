unit TvUtil;
{&Use32+}

{#F ****************************************************}
{                                                       }
{                   TVutil unit                         }
{                                                       }
{       Copyright (C) 11-16-92  James M. Clark          }
{                                                       }
{   General utilities for TurboVision applications      }
{   Includes #simple_input_lines#.                      }
{                                                       }
{#F ****************************************************}

interface
uses Objects, Dialogs;

function ExecDialog(P: PDialog; Data: Pointer): Word;
{#F ****************************************************}
{                                                       }
{   Execute given PDialog with given Data.              }
{   Data is unchanged if dialog is cancelled.           }
{                                                       }
{#F ****************************************************}

type
    PTextArray = ^TTextArray;
    TTextArray = array[byte] of String[10];
    { used by #TIndexedText# }

    PIndexedText = ^TIndexedText;
    TIndexedText = object(TStaticText)
{#F ****************************************************}
{                                                       }
{   This status display object displays one name of     }
{   a given array of names, given by an index of the    }
{   array.  The address of the array and index are      }
{   specified when the object is initialized.           }
{                                                       }
{#F ****************************************************}
        TextArray: PTextArray;
        Index: ^word;
        constructor Init(var Bounds: TRect;
                var AText;          {an array of string[10] names}
                var AIndex: word    {an index of the array}
        );
        procedure GetText(var S: string); virtual;
        function DataSize: word; virtual;
    end;

type
    PNumReport = ^TNumReport;
    TNumReport = object(TStaticText)
{#F ****************************************************}
{                                                       }
{   This numeric report object displays the value       }
{   of a double variable (with format :fmt1:fmt2),      }
{   given the address of the variable.                  }
{                                                       }
{#F ****************************************************}
        Data: ^double;
        Fmt1, Fmt2: byte;
        constructor Init(var Bounds: TRect;
                var AData: double;
                AFmt1, AFmt2: byte
                {Display as in write(AData: AFmt1: AFmt2) }
        );
        procedure GetText(var S: string); virtual;
        function DataSize: word; virtual;
    end;

const
    cmNewSelect = 100;

type
    PMRadioButtons = ^TMRadioButtons;
    TMRadioButtons = object(TRadioButtons)
{#F ****************************************************}
{                                                       }
{   This variant of the Radio Buttons object broad-     }
{   casts a #cmNewSelect# message when the selection    }
{   is changed.                                         }
{                                                       }
{#F ****************************************************}
        procedure MovedTo(Item: integer); virtual;
        procedure Press(Item: integer); virtual;
    end;

{#T simple_input_lines}
{#F ****************************************************

    Objects for inputting numbers, for use in dialogs;
    for all predefined integer and real types:
        shortint, byte, integer, word, longint,
        real, single, double, extended, comp
    All objects are derived from InputLine object.
    All objects have the same syntax.
    Use inFmt1 and inFmt2 to control output format.
    No special editing; invalid input is set to zero.
    String lengths are given names of the form:
        inTypeLen   such as     inShortintLen

 #F ****************************************************}

const
{ string lengths: }
    inShortintLen   = 4;
    inByteLen       = 3;
    inIntegerLen    = 6;
    inWordLen       = 5;
    inLongintLen    = 11;
    inRealLen       = 22;
    inSingleLen     = 18;
    inDoubleLen     = 27;
    inExtendedLen   = 32;
    inCompLen       = 20;

const
{ format options (as in "v:fmt1:fmt2"): }
    inFmt1: word = 0;
    inFmt2: word = 6;

type
    PInputShortint = ^TInputShortint;
    TInputShortint = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

type
    PInputByte = ^TInputByte;
    TInputByte = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

type
    PInputInteger = ^TInputInteger;
    TInputInteger = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

type
    PInputWord = ^TInputWord;
    TInputWord = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

type
    PInputLongint = ^TInputLongint;
    TInputLongint = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

type
    PInputReal = ^TInputReal;
    TInputReal = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

type
    PInputSingle = ^TInputSingle;
    TInputSingle = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

type
    PInputDouble = ^TInputDouble;
    TInputDouble = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

type
    PInputExtended = ^TInputExtended;
    TInputExtended = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

type
    PInputComp = ^TInputComp;
    TInputComp = object(TInputLine)
    {See #simple_input_lines#.}
        NumMode: boolean;
        constructor Init(Bounds: TRect);
        procedure SetData(var AData); virtual;
        procedure GetData(var AData); virtual;
        function DataSize: word; virtual;
    end;

{*******************************************************}

implementation
uses Drivers, Views, App;

{ execute given dialog with given data: }

function ExecDialog(P: PDialog; Data: Pointer): Word;
var
    Cmd: Word;
begin
    Cmd:= cmCancel;
    P:= PDialog(Application^.ValidView(P));
    if P <> nil then begin
        if Data <> nil then P^.SetData(Data^);
        Cmd:= DeskTop^.ExecView(P);
        if (Cmd <> cmCancel) and (Data <> nil)
        then P^.GetData(Data^);
        Dispose(P, Done);
    end;
    ExecDialog:= Cmd;
end; {ExecDialog}

{*******************************************************}

{ TIndexedText }

constructor TIndexedText.Init(var Bounds: TRect; var AText;
        var AIndex: word);
begin
    TStaticText.Init(Bounds, '');
    TextArray:= @AText;
    Index:= @AIndex;
end; {TIndexedText.Init}

procedure TIndexedText.GetText(var S: string);
var
    P: byte;
begin
    S:= TextArray^[Index^];
    repeat
        P:= Pos('~', S);
        if P > 0 then Delete(S, P, 1);
    until P = 0;
end; {TIndexedText.GetText}

function TIndexedText.DataSize: word;
begin
    DataSize:= 0;
end; {TIndexedText.DataSize}

{*******************************************************}

{ TNumReport - numeric report object }

constructor TNumReport.Init(var Bounds: TRect;
                var AData: double;
                AFmt1, AFmt2: byte
);
begin
    TStaticText.Init(Bounds, '');
    Data:= @AData;
    Fmt1:= AFmt1;
    Fmt2:= AFmt2;
end; {TNumReport.Init}

procedure TNumReport.GetText(var S: string);
begin
    Str(Data^: Fmt1: Fmt2, S);
end; {TNumReport.GetText}

function TNumReport.DataSize: word;
begin
    DataSize:= 0;
end; {TNumReport.DataSize}

{*******************************************************}

{ Radio Buttons variant that broadcasts cmNewSelect message: }

{ used to respond to up, down arrow keys: }
procedure TMRadioButtons.MovedTo(Item: integer);
var
    NewSel: longint;
begin
    TRadioButtons.MovedTo(Item);
    NewSel:= Item;
    Message(TopView, evBroadcast, cmNewSelect, Pointer(NewSel));
end; {TMRadioButtons.MovedTo}

{ used to respond to mouse clicks and shortcut keys: }
procedure TMRadioButtons.Press(Item: integer);
var
    NewSel: longint;
begin
    TRadioButtons.Press(Item);
    NewSel:= Item;
    Message(TopView, evBroadcast, cmNewSelect, Pointer(NewSel));
end; {TMRadioButtons.Press}

{*******************************************************}
{                                                       }
{   Objects for inputting numbers, for use in dialogs   }
{                                                       }
{*******************************************************}

{ TInputShortint methods: }

constructor TInputShortint.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inShortintLen);
    NumMode:= true;
end;

procedure TInputShortint.SetData(var AData);
var
    S: string[inShortintLen];
    V: Shortint absolute AData;
begin
    FillChar(S[1], inShortintLen, ' ');
    Str(V: inFmt1, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputShortint.GetData(var AData);
var
    S: string[inShortintLen];
    V: Shortint absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0;
end;

function TInputShortint.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Shortint);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

{ TInputByte methods: }

constructor TInputByte.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inByteLen);
    NumMode:= true;
end;

procedure TInputByte.SetData(var AData);
var
    S: string[inByteLen];
    V: Byte absolute AData;
begin
    FillChar(S[1], inByteLen, ' ');
    Str(V: inFmt1, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputByte.GetData(var AData);
var
    S: string[inByteLen];
    V: Byte absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0;
end;

function TInputByte.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Byte);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

{ TInputInteger methods: }

constructor TInputInteger.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inIntegerLen);
    NumMode:= true;
end;

procedure TInputInteger.SetData(var AData);
var
    S: string[inIntegerLen];
    V: Integer absolute AData;
begin
    FillChar(S[1], inIntegerLen, ' ');
    Str(V: inFmt1, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputInteger.GetData(var AData);
var
    S: string[inIntegerLen];
    V: Integer absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0;
end;

function TInputInteger.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Integer);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

{ TInputWord methods: }

constructor TInputWord.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inWordLen);
    NumMode:= true;
end;

procedure TInputWord.SetData(var AData);
var
    S: string[inWordLen];
    V: Word absolute AData;
begin
    FillChar(S[1], inWordLen, ' ');
    Str(V: inFmt1, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputWord.GetData(var AData);
var
    S: string[inWordLen];
    V: Word absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0;
end;

function TInputWord.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Word);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

{ TInputLongint methods: }

constructor TInputLongint.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inLongintLen);
    NumMode:= true;
end;

procedure TInputLongint.SetData(var AData);
var
    S: string[inLongintLen];
    V: Longint absolute AData;
begin
    FillChar(S[1], inLongintLen, ' ');
    Str(V: inFmt1, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputLongint.GetData(var AData);
var
    S: string[inLongintLen];
    V: Longint absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0;
end;

function TInputLongint.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Longint);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

{ TInputReal methods: }

constructor TInputReal.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inRealLen);
    NumMode:= true;
end;

procedure TInputReal.SetData(var AData);
var
    S: string[inRealLen];
    V: Real absolute AData;
begin
    FillChar(S[1], inRealLen, ' ');
    Str(V: inFmt1: inFmt2, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputReal.GetData(var AData);
var
    S: string[inRealLen];
    V: Real absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0.0;
end;

function TInputReal.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Real);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

{ TInputSingle methods: }

constructor TInputSingle.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inSingleLen);
    NumMode:= true;
end;

procedure TInputSingle.SetData(var AData);
var
    S: string[inSingleLen];
    V: Single absolute AData;
begin
    FillChar(S[1], inSingleLen, ' ');
    Str(V: inFmt1: inFmt2, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputSingle.GetData(var AData);
var
    S: string[inSingleLen];
    V: Single absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0.0;
end;

function TInputSingle.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Single);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

{ TInputDouble methods: }

constructor TInputDouble.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inDoubleLen);
    NumMode:= true;
end;

procedure TInputDouble.SetData(var AData);
var
    S: string[inDoubleLen];
    V: Double absolute AData;
begin
    FillChar(S[1], inDoubleLen, ' ');
    Str(V: inFmt1: inFmt2, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputDouble.GetData(var AData);
var
    S: string[inDoubleLen];
    V: Double absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0.0;
end;

function TInputDouble.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Double);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

{ TInputExtended methods: }

constructor TInputExtended.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inExtendedLen);
    NumMode:= true;
end;

procedure TInputExtended.SetData(var AData);
var
    S: string[inExtendedLen];
    V: Extended absolute AData;
begin
    FillChar(S[1], inExtendedLen, ' ');
    Str(V: inFmt1: inFmt2, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputExtended.GetData(var AData);
var
    S: string[inExtendedLen];
    V: Extended absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0.0;
end;

function TInputExtended.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Extended);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

{ TInputComp methods: }

constructor TInputComp.Init(Bounds: TRect);
begin
    TInputLine.Init(Bounds, inCompLen);
    NumMode:= true;
end;

procedure TInputComp.SetData(var AData);
var
    S: string[inCompLen];
    V: Comp absolute AData;
begin
    FillChar(S[1], inCompLen, ' ');
    Str(V: inFmt1: inFmt2, S);
    NumMode:= false;
    TInputLine.SetData(S);
    NumMode:= true;
end;

procedure TInputComp.GetData(var AData);
var
    S: string[inCompLen];
    V: Comp absolute AData;
    E: integer;
begin
    NumMode:= false;
    TInputLine.GetData(S);
    NumMode:= true;
    while (Length(S) > 0) and (S[1] = ' ') do Delete(S, 1, 1);
    Val(S, V, E);
    if E <> 0 then V:= 0;
end;

function TInputComp.DataSize: word;
begin
    if NumMode then begin
        DataSize:= SizeOf(Comp);
    end else begin
        DataSize:= TInputLine.DataSize;
    end;
end;

end.
