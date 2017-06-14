{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}

{   System independent GRAPHICAL clone of VALIDATE.PAS     }

{   Interface Copyright (c) 1992 Borland International     }

{   Copyright (c) 1996, 1997, 1998, 1999 by Leon de Boer   }
{   ldeboer@ibm.net                                        }

{****************[ THIS CODE IS FREEWARE ]*****************}

{     This sourcecode is released for the purpose to       }
{   promote the pascal language on all platforms. You may  }
{   redistribute it and/or modify with the following       }
{   DISCLAIMER.                                            }

{     This SOURCE CODE is distributed "AS IS" WITHOUT      }
{   WARRANTIES AS TO PERFORMANCE OF MERCHANTABILITY OR     }
{   ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED.     }

{*****************[ SUPPORTED PLATFORMS ]******************}
{     16 and 32 Bit compilers                              }
{        DOS      - Turbo Pascal 7.0 +      (16 Bit)       }
{        DPMI     - Turbo Pascal 7.0 +      (16 Bit)       }
{                 - FPC 0.9912+ (GO32V2)    (32 Bit)       }
{        WINDOWS  - Turbo Pascal 7.0 +      (16 Bit)       }
{                 - Delphi 1.0+             (16 Bit)       }
{        WIN95/NT - Delphi 2.0+             (32 Bit)       }
{                 - Virtual Pascal 2.0+     (32 Bit)       }
{                 - Speedsoft Sybil 2.0+    (32 Bit)       }
{                 - FPC 0.9912+             (32 Bit)       }
{        OS2      - Virtual Pascal 1.0+     (32 Bit)       }

{******************[ REVISION HISTORY ]********************}
{  Version  Date        Fix                                }
{  -------  ---------   ---------------------------------  }
{  1.00     12 Jun 96   Initial DOS/DPMI code released.    }
{  1.10     29 Aug 97   Platform.inc sort added.           }
{  1.20     13 Oct 97   Delphi3 32 bit code added.         }
{  1.30     11 May 98   Virtual pascal 2.0 code added.     }
{  1.40     10 Jul 99   Sybil 2.0 code added               }
{  1.41     03 Nov 99   FPC windows code added             }
{**********************************************************}

unit Validate;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
interface

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$IFNDEF PPC_FPC}{ FPC doesn't support these switches }
  {$F-}{ Short calls are okay }
  {$A+}{ Word Align Data }
  {$B-}{ Allow short circuit boolean evaluations }
  {$O+}{ This unit may be overlaid }
  {$G+}{ 286 Code optimization - if you're on an 8088 get a real computer }
  {$P-}{ Normal string variables }
  {$N-}{ No 80x87 code generation }
  {$E+}{ Emulation is on }
{$ENDIF}

{$X+}{ Extended syntax is ok }
{$R-}{ Disable range checking }
{$S-}{ Disable Stack Checking }
{$I-}{ Disable IO Checking }
{$Q-}{ Disable Overflow Checking }
{$V-}{ Turn off strict VAR strings }
{====================================================================}

uses FVCommon, Objects, fvconsts;                      { GFV standard units }

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                         VALIDATOR STATUS CONSTANTS                        }
{---------------------------------------------------------------------------}
const
  vsOk = 0;                                      { Validator ok }
  vsSyntax = 1;                                      { Validator sytax err }

{---------------------------------------------------------------------------}
{                           VALIDATOR OPTION MASKS                          }
{---------------------------------------------------------------------------}
const
  voFill = $0001;                                { Validator fill }
  voTransfer = $0002;                                { Validator transfer }
  voOnAppend = $0004;                                { Validator append }
  voReserved = $00F8;                                { Clear above flags }

{***************************************************************************}
{                            RECORD DEFINITIONS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                        VALIDATOR TRANSFER CONSTANTS                       }
{---------------------------------------------------------------------------}
type
  TVTransfer = (vtDataSize, vtSetData, vtGetData);   { Transfer states }

{---------------------------------------------------------------------------}
{                    PICTURE VALIDATOR RESULT CONSTANTS                     }
{---------------------------------------------------------------------------}
type
  TPicResult = (prComplete, prIncomplete, prEmpty, prError, prSyntax,
    prAmbiguous, prIncompNoFill);

{***************************************************************************}
{                            OBJECT DEFINITIONS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                TValidator OBJECT - VALIDATOR ANCESTOR OBJECT              }
{---------------------------------------------------------------------------}
type
  TValidator = object(TObject)
    Status: word;                               { Validator status }
    Options: word;                               { Validator options }
    constructor Load(var S: TStream);
    function Valid(const S: system.string): boolean;
    function IsValid(const S: system.string): boolean; virtual;
    function IsValidInput(var S: system.string;
      SuppressFill: boolean): boolean; virtual;
    function Transfer(var S: string; Buffer: Pointer; Flag: TVTransfer): word;
      virtual;
    procedure Error; virtual;
    procedure Store(var S: TStream);
  end;
  PValidator = ^TValidator;

{---------------------------------------------------------------------------}
{           TPictureValidator OBJECT - PICTURE VALIDATOR OBJECT             }
{---------------------------------------------------------------------------}
type
  TPXPictureValidator = object(TValidator)
    Pic: PString;                                { Picture filename }
    constructor Init(const APic: string; AutoFill: boolean);
    constructor Load(var S: TStream);
    destructor Done; virtual;
    function IsValid(const S: string): boolean; virtual;
    function IsValidInput(var S: string; SuppressFill: boolean): boolean;
      virtual;
    function Picture(var Input: string; AutoFill: boolean): TPicResult;
      virtual;
    procedure Error; virtual;
    procedure Store(var S: TStream);
  end;
  PPXPictureValidator = ^TPXPictureValidator;

type
  CharSet = TCharSet;

{---------------------------------------------------------------------------}
{            TFilterValidator OBJECT - FILTER VALIDATOR OBJECT              }
{---------------------------------------------------------------------------}
type
  TFilterValidator = object(TValidator)
    ValidChars: CharSet;                         { Valid char set }
    constructor Init(AValidChars: CharSet);
    constructor Load(var S: TStream);
    function IsValid(const S: system.string): boolean; virtual;
    function IsValidInput(var S: system.string;
      SuppressFill: boolean): boolean; virtual;
    procedure Error; virtual;
    procedure Store(var S: TStream);
  end;
  PFilterValidator = ^TFilterValidator;

{---------------------------------------------------------------------------}
{             TRangeValidator OBJECT - RANGE VALIDATOR OBJECT               }
{---------------------------------------------------------------------------}
type
  TRangeValidator = object(TFilterValidator)
    Min: longint;                                { Min valid value }
    Max: longint;                                { Max valid value }
    constructor Init(AMin, AMax: longint);
    constructor Load(var S: TStream);
    function IsValid(const S: string): boolean; virtual;
    function Transfer(var S: string; Buffer: Pointer; Flag: TVTransfer): word;
      virtual;
    procedure Error; virtual;
    procedure Store(var S: TStream);
  end;
  PRangeValidator = ^TRangeValidator;

{---------------------------------------------------------------------------}
{            TLookUpValidator OBJECT - LOOKUP VALIDATOR OBJECT              }
{---------------------------------------------------------------------------}
type
  TLookupValidator = object(TValidator)
    function IsValid(const S: string): boolean; virtual;
    function Lookup(const S: string): boolean; virtual;
  end;
  PLookupValidator = ^TLookupValidator;

{---------------------------------------------------------------------------}
{      TStringLookUpValidator OBJECT - STRING LOOKUP VALIDATOR OBJECT       }
{---------------------------------------------------------------------------}
type
  TStringLookupValidator = object(TLookupValidator)
    Strings: PStringCollection;
    constructor Init(AStrings: PStringCollection);
    constructor Load(var S: TStream);
    destructor Done; virtual;
    function Lookup(const S: string): boolean; virtual;
    procedure Error; virtual;
    procedure NewStringList(AStrings: PStringCollection);
    procedure Store(var S: TStream);
  end;
  PStringLookupValidator = ^TStringLookupValidator;

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           OBJECT REGISTER ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{-RegisterValidate---------------------------------------------------
Calls RegisterType for each of the object types defined in this unit.
18May98 LdB
---------------------------------------------------------------------}
procedure RegisterValidate;

{***************************************************************************}
{                           OBJECT REGISTRATION                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                 TPXPictureValidator STREAM REGISTRATION                   }
{---------------------------------------------------------------------------}
const
  RPXPictureValidator: TStreamRec = (
    ObjType: idPXPictureValidator;                   { Register id = 80 }
     {$IFDEF BP_VMTLink}{ BP style VMT link }
    VmtLink: Ofs(TypeOf(TPXPictureValidator)^);
     {$ELSE}{ Alt style VMT link }
    VmtLink: TypeOf(TPXPictureValidator);
     {$ENDIF}
    Load: @TPXPictureValidator.Load;                 { Object load method }
    Store: @TPXPictureValidator.Store{%H-}                { Object store method }
    );

{---------------------------------------------------------------------------}
{                  TFilterValidator STREAM REGISTRATION                     }
{---------------------------------------------------------------------------}
const
  RFilterValidator: TStreamRec = (
    ObjType: idFilterValidator;                      { Register id = 81 }
     {$IFDEF BP_VMTLink}{ BP style VMT link }
    VmtLink: Ofs(TypeOf(TFilterValidator)^);
     {$ELSE}{ Alt style VMT link }
    VmtLink: TypeOf(TFilterValidator);
     {$ENDIF}
    Load: @TFilterValidator.Load;                    { Object load method }
    Store: @TFilterValidator.Store                   { Object store method }
    );

{---------------------------------------------------------------------------}
{                   TRangeValidator STREAM REGISTRATION                     }
{---------------------------------------------------------------------------}
const
  RRangeValidator: TStreamRec = (
    ObjType: idRangeValidator;                       { Register id = 82 }
     {$IFDEF BP_VMTLink}{ BP style VMT link }
    VmtLink: Ofs(TypeOf(TRangeValidator)^);
     {$ELSE}{ Alt style VMT link }
    VmtLink: TypeOf(TRangeValidator);
     {$ENDIF}
    Load: @TRangeValidator.Load;                     { Object load method }
    Store: @TRangeValidator.Store                    { Object store method }
    {%H-});

{---------------------------------------------------------------------------}
{                TStringLookupValidator STREAM REGISTRATION                 }
{---------------------------------------------------------------------------}
const
  RStringLookupValidator: TStreamRec = (
    ObjType: idStringLookupValidator;                { Register id = 83 }
     {$IFDEF BP_VMTLink}{ BP style VMT link }
    VmtLink: Ofs(TypeOf(TStringLookupValidator)^);
     {$ELSE}{ Alt style VMT link }
    VmtLink: TypeOf(TStringLookupValidator);
     {$ENDIF}
    Load: @TStringLookupValidator.Load;              { Object load method }
    Store: @TStringLookupValidator.Store             { Object store method }
    );

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
implementation

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

uses MsgBox;                                          { GFV standard unit }

{***************************************************************************}
{                              PRIVATE ROUTINES                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{  IsLetter -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB          }
{---------------------------------------------------------------------------}
function IsLetter(Chr: char): boolean;
begin
  Chr := char(Ord(Chr) and $DF);                     { Lower to upper case }
  if (Chr >= 'A') and (Chr <= 'Z') then               { Check if A..Z }
    IsLetter := True
  else
    IsLetter := False;         { Return result }
end;

{---------------------------------------------------------------------------}
{  IsComplete -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB        }
{---------------------------------------------------------------------------}
function IsComplete(Rslt: TPicResult): boolean;
begin
  IsComplete := Rslt in [prComplete, prAmbiguous];   { Return if complete }
end;

{---------------------------------------------------------------------------}
{  IsInComplete -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB      }
{---------------------------------------------------------------------------}
function IsIncomplete(Rslt: TPicResult): boolean;
begin
  IsIncomplete := Rslt in [prIncomplete, prIncompNoFill];
  { Return if incomplete }
end;

{---------------------------------------------------------------------------}
{  NumChar -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function NumChar(Chr: char; const S: string): byte;
var
  I, Total: byte;
begin
  Total := 0;                                        { Zero total }
  for I := 1 to Length(S) do                         { For entire string }
    if (S[I] = Chr) then
      Inc(Total);                 { Count matches of Chr }
  NumChar := Total;                                  { Return char count }
end;

{---------------------------------------------------------------------------}
{  IsSpecial -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB         }
{---------------------------------------------------------------------------}
function IsSpecial(Chr: char; const Special: string): boolean;
var
  Rslt: boolean;
  I: byte;
begin
  Rslt := False;                                     { Preset false result }
  for I := 1 to Length(Special) do
    if (Special[I] = Chr) then
      Rslt := True;         { Character found }
  IsSpecial := Rslt;                                 { Return result }
end;

{***************************************************************************}
{                               OBJECT METHODS                              }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TValidator OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TValidator---------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TValidator.Load(var S: TStream);
begin
  inherited Init;                                    { Call ancestor }
  S.Read(Options, SizeOf(Options));                  { Read option masks }
end;

{--TValidator---------------------------------------------------------------}
{  Valid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
function TValidator.Valid(const S: string): boolean;
begin
  Valid := False;                                    { Preset false result }
  if not IsValid(S) then
    Error                       { Check for error }
  else
    Valid := True;                              { Return valid result }
end;

{--TValidator---------------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function TValidator.IsValid(const S: string): boolean;
begin
  IsValid := True;                                   { Default return valid }
end;

{--TValidator---------------------------------------------------------------}
{  IsValidInput -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB      }
{---------------------------------------------------------------------------}
function TValidator.IsValidInput(var S: string; SuppressFill: boolean): boolean;
begin
  IsValidInput := True;                              { Default return true }
end;

{--TValidator---------------------------------------------------------------}
{  Transfer -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB          }
{---------------------------------------------------------------------------}
function TValidator.Transfer(var S: string; Buffer: Pointer; Flag: TVTransfer): word;
begin
  Transfer := 0;                                     { Default return zero }
end;

{--TValidator---------------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TValidator.Error;
begin                                                 { Abstract method }
end;

{--TValidator---------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TValidator.Store(var S: TStream);
begin
  S.Write(Options, SizeOf(Options));                 { Write options }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                    TPXPictureValidator OBJECT METHODS                     }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TPXPictureValidator------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TPXPictureValidator.Init(const APic: string; AutoFill: boolean);
var
  S: string;
begin
  inherited Init;                                    { Call ancestor }
  Pic := NewStr(APic);                               { Hold filename }
  Options := voOnAppend;                             { Preset option mask }
  if AutoFill then
    Options := Options or voFill;     { Check/set fill mask }
  S := '';                                           { Create empty string }
  if (Picture(S, False) <> prEmpty) then             { Check for empty }
    Status := vsSyntax;                              { Set error mask }
end;

{--TPXPictureValidator------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TPXPictureValidator.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  Pic := S.ReadStr;                                  { Read filename }
end;

{--TPXPictureValidator------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
destructor TPXPictureValidator.Done;
begin
  if (Pic <> nil) then
    DisposeStr(Pic);              { Dispose of filename }
  inherited Done;                                    { Call ancestor }
end;

{--TPXPictureValidator------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function TPXPictureValidator.IsValid(const S: string): boolean;
var
  Str: string;
  Rslt: TPicResult;
begin
  Str := S;                                          { Transfer string }
  Rslt := Picture(Str, False);                       { Check for picture }
  IsValid := (Pic = nil) or (Rslt = prComplete) or (Rslt = prEmpty);
  { Return result }
end;

{--TPXPictureValidator------------------------------------------------------}
{  IsValidInput -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB      }
{---------------------------------------------------------------------------}
function TPXPictureValidator.IsValidInput(var S: string;
  SuppressFill: boolean): boolean;
begin
  IsValidInput := (Pic = nil) or
    (Picture(S, (Options and voFill <> 0) and not SuppressFill) <> prError);
  { Return input result }
end;

{--TPXPictureValidator------------------------------------------------------}
{  Picture -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function TPXPictureValidator.Picture(var Input: string; AutoFill: boolean): TPicResult;
var
  I, J: byte;
  Rslt: TPicResult;
  Reprocess: boolean;

  function Process(TermCh: byte): TPicResult;
  var
    Rslt: TPicResult;
    Incomp: boolean;
    OldI, OldJ, IncompJ, IncompI: byte;

    procedure Consume(Ch: char);
    begin
      Input[J] := Ch;                                { Return character }
      Inc(J);                                        { Inc count J }
      Inc(I);                                        { Inc count I }
    end;

    procedure ToGroupEnd(var I: byte);
    var
      BrkLevel, BrcLevel: integer;
    begin
      BrkLevel := 0;                                 { Zero bracket level }
      BrcLevel := 0;                                 { Zero bracket level }
      repeat
        if (I <> TermCh) then
        begin                  { Not end }
          case Pic^[I] of
            '[': Inc(BrkLevel);                      { Inc bracket level }
            ']': Dec(BrkLevel);                      { Dec bracket level }
            '{': Inc(BrcLevel);                      { Inc bracket level }
            '}': Dec(BrcLevel);                      { Dec bracket level }
            ';': Inc(I);                             { Next character }
            '*':
            begin
              Inc(I);                              { Next character }
              while Pic^[I] in ['0'..'9'] do
                Inc(I);   { Search for text }
              ToGroupEnd(I);                       { Move to group end }
              Continue;                            { Now continue }
            end;
          end;
          Inc(I);                                    { Next character }
        end;
      until ((BrkLevel = 0) and (BrcLevel = 0)) or   { Both levels must be 0 }
        (I = TermCh);                                  { Terminal character }
    end;

    function SkipToComma: boolean;
    begin
      repeat
        ToGroupEnd(I);                               { Find group end }
      until (I = TermCh) or (Pic^[I] = ',');         { Terminator found }
      if (Pic^[I] = ',') then
        Inc(I);                { Comma so continue }
      SkipToComma := (I < TermCh);                   { Return result }
    end;

    function CalcTerm: byte;
    var
      K: byte;
    begin
      K := I;                                        { Hold count }
      ToGroupEnd(K);                                 { Find group end }
      CalcTerm := K;                                 { Return count }
    end;

    function Iteration: TPicResult;
    var
      Itr, K, L: byte;
      Rslt: TPicResult;
      NewTermCh: byte;
    begin
      Itr := 0;                                      { Zero iteration }
      Iteration := prError;                          { Preset error result }
      Inc(I);                                        { Skip '*' character }
      while Pic^[I] in ['0'..'9'] do
      begin           { Entry is a number }
        Itr := Itr * 10 + byte(Pic^[I]) - byte('0'); { Convert to number }
        Inc(I);                                      { Next character }
      end;
      if (I <= TermCh) then
      begin                    { Not end of name }
        K := I;                                      { Hold count }
        NewTermCh := CalcTerm;                       { Calc next terminator }
        if (Itr <> 0) then
        begin
          for L := 1 to Itr do
          begin                 { For each character }
            I := K;                                  { Reset count }
            Rslt := Process(NewTermCh);              { Process new entry }
            if (not IsComplete(Rslt)) then
            begin     { Not empty }
              if (Rslt = prEmpty) then               { Check result }
                Rslt := prIncomplete;                { Return incomplete }
              Iteration := Rslt;                     { Return result }
              Exit;                                  { Now exit }
            end;
          end;
        end
        else
        begin
          repeat
            I := K;                                  { Hold count }
            Rslt := Process(NewTermCh);              { Process new entry }
          until (not IsComplete(Rslt));              { Until complete }
          if (Rslt = prEmpty) or (Rslt = prError)
          { Check for any error } then
          begin
            Inc(I);                                  { Next character }
            Rslt := prAmbiguous;                     { Return result }
          end;
        end;
        I := NewTermCh;                              { Find next name }
      end
      else
        Rslt := prSyntax;                     { Completed }
      Iteration := Rslt;                             { Return result }
    end;

    function Group: TPicResult;
    var
      Rslt: TPicResult;
      TermCh: byte;
    begin
      TermCh := CalcTerm;                            { Calc new term }
      Inc(I);                                        { Next character }
      Rslt := Process(TermCh - 1);                   { Process the name }
      if (not IsIncomplete(Rslt)) then
        I := TermCh;  { Did not complete }
      Group := Rslt;                                 { Return result }
    end;

    function CheckComplete(Rslt: TPicResult): TPicResult;
    var
      J: byte;
    begin
      J := I;                                        { Hold count }
      if IsIncomplete(Rslt) then
      begin               { Check if complete }
        while True do
          case Pic^[J] of
            '[': ToGroupEnd(J);                      { Find name end }
            '*': if not (Pic^[J + 1] in ['0'..'9']) then
              begin
                Inc(J);                              { Next name }
                ToGroupEnd(J);                       { Find name end }
              end
              else
                Break;
            else
              Break;
          end;
        if (J = TermCh) then
          Rslt := prAmbiguous;    { End of name }
      end;
      CheckComplete := Rslt;                         { Return result }
    end;

    function Scan: TPicResult;
    var
      Ch: char;
      Rslt: TPicResult;
    begin
      Scan := prError;                               { Preset return error }
      Rslt := prEmpty;                               { Preset empty result }
      while (I <> TermCh) and (Pic^[I] <> ',')       { For each entry } do
      begin
        if (J > Length(Input)) then
        begin            { Move beyond length }
          Scan := CheckComplete(Rslt);               { Return result }
          Exit;                                      { Now exit }
        end;
        Ch := Input[J];                              { Fetch character }
        case Pic^[I] of
          '#': if not (Ch in ['0'..'9']) then
              Exit   { Check is a number }
            else
              Consume(Ch);                      { Transfer number }
          '?': if (not IsLetter(Ch)) then
              Exit       { Check is a letter }
            else
              Consume(Ch);                      { Transfer character }
          '&': if (not IsLetter(Ch)) then
              Exit       { Check is a letter }
            else
              Consume(UpCase(Ch));              { Transfer character }
          '!': Consume(UpCase(Ch));                  { Transfer character }
          '@': Consume(Ch);                          { Transfer character }
          '*':
          begin
            Rslt := Iteration;                       { Now re-iterate }
            if (not IsComplete(Rslt)) then
            begin     { Check not complete }
              Scan := Rslt;                          { Return result }
              Exit;                                  { Now exit }
            end;
            if (Rslt = prError) then                 { Check for error }
              Rslt := prAmbiguous;                   { Return ambiguous }
          end;
          '{':
          begin
            Rslt := Group;                           { Return group }
            if (not IsComplete(Rslt)) then
            begin     { Not incomplete check }
              Scan := Rslt;                          { Return result }
              Exit;                                  { Now exit }
            end;
          end;
          '[':
          begin
            Rslt := Group;                           { Return group }
            if IsIncomplete(Rslt) then
            begin         { Incomplete check }
              Scan := Rslt;                          { Return result }
              Exit;                                  { Now exit }
            end;
            if (Rslt = prError) then                 { Check for error }
              Rslt := prAmbiguous;                   { Return ambiguous }
          end;
          else
            if Pic^[I] = ';' then
              Inc(I);         { Move fwd for follow }
            if (UpCase(Pic^[I]) <> UpCase(Ch)) then    { Characters differ }
              if (Ch = ' ') then
                Ch := Pic^[I]         { Ignore space }
              else
                Exit;
            Consume(Pic^[I]);                          { Consume character }
        end; { Case }
        if (Rslt = prAmbiguous) then                 { If ambiguous result }
          Rslt := prIncompNoFill                     { Set incomplete fill }
        else
          Rslt := prIncomplete;                 { Set incomplete }
      end;{ While}
      if (Rslt = prIncompNoFill) then                { Check incomp fill }
        Scan := prAmbiguous
      else                     { Return ambiguous }
        Scan := prComplete;                          { Return completed }
    end;

  begin
    Incomp := False;                                 { Clear incomplete }
    InCompJ := 0;                                      { set to avoid a warning }
    OldI := I;                                       { Hold I count }
    OldJ := J;                                       { Hold J count }
    repeat
      Rslt := Scan;                                  { Scan names }
      if (Rslt in [prComplete, prAmbiguous]) and Incomp and (J < IncompJ) then
      begin            { Check if complete }
        Rslt := prIncomplete;                        { Return result }
        J := IncompJ;                                { Return position }
      end;
      if ((Rslt = prError) or (Rslt = prIncomplete)) { Check no errors } then
      begin
        Process := Rslt;                             { Hold result }
        if ((not Incomp) and (Rslt = prIncomplete))  { Check complete } then
        begin
          Incomp := True;                            { Set incomplete }
          IncompI := I;                              { Set current position }
          IncompJ := J;                              { Set current position }
        end;
        I := OldI;                                   { Restore held value }
        J := OldJ;                                   { Restore held value }
        if (not SkipToComma) then
        begin              { Check not comma }
          if Incomp then
          begin                       { Check incomplete }
            Process := prIncomplete;                 { Set incomplete mask }
            I := IncompI;                            { Hold incomp position }
            J := IncompJ;                            { Hold incomp position }
          end;
          Exit;                                      { Now exit }
        end;
        OldI := I;                                   { Hold position }
      end;
    until (Rslt <> prError) and                      { Check for error }
      (Rslt <> prIncomplete);                        { Incomplete load }
    if (Rslt = prComplete) and Incomp then           { Complete load }
      Process := prAmbiguous
    else                    { Return completed }
      Process := Rslt;                               { Return result }
  end;

  function SyntaxCheck: boolean;
  var
    I, BrkLevel, BrcLevel: integer;
  begin
    SyntaxCheck := False;                            { Preset false result }
    if (Pic^ <> '') and (Pic^[Length(Pic^)] <> ';')  { Name is valid } and
      ((Pic^[Length(Pic^)] = '*') and (Pic^[Length(Pic^) - 1] <> ';') = False)
    { Not wildcard list } then
    begin
      I := 1;                                        { Set count to 1 }
      BrkLevel := 0;                                 { Zero bracket level }
      BrcLevel := 0;                                 { Zero bracket level }
      while (I <= Length(Pic^)) do
      begin             { For each character }
        case Pic^[I] of
          '[': Inc(BrkLevel);                        { Inc bracket level }
          ']': Dec(BrkLevel);                        { Dec bracket level }
          '{': Inc(BrcLevel);                        { Inc bracket level }
          '}': Dec(BrcLevel);                        { Dec bracket level }
          ';': Inc(I);                               { Next character }
        end;
        Inc(I);                                      { Next character }
      end;
      if (BrkLevel = 0) and (BrcLevel = 0) then      { Check both levels 0 }
        SyntaxCheck := True;                         { Return true syntax }
    end;
  end;

begin
  Picture := prSyntax;                               { Preset error default }
  if SyntaxCheck then
  begin                          { Check syntax }
    Picture := prEmpty;                              { Preset picture empty }
    if (Input <> '') then
    begin                      { We have an input }
      J := 1;                                        { Set J count to 1 }
      I := 1;                                        { Set I count to 1 }
      Rslt := Process(Length(Pic^) + 1);             { Set end of name }
      if (Rslt <> prError) and (Rslt <> prSyntax) and (J <= Length(Input)) then
        Rslt := prError;    { Check for any error }
      if (Rslt = prIncomplete) and AutoFill          { Check autofill flags } then
      begin
        Reprocess := False;                          { Set reprocess false }
        while (I <= Length(Pic^)) and (not           { Not at end of name }
            IsSpecial(Pic^[I], '#?&!@*{}[],'#0))         { No special chars } do
        begin
          if Pic^[I] = ';' then
            Inc(I);              { Check for next mark }
          Input := Input + Pic^[I];                  { Move to that name }
          Inc(I);                                    { Inc count }
          Reprocess := True;                         { Set reprocess flag }
        end;
        J := 1;                                      { Set J count to 1 }
        I := 1;                                      { Set I count to 1 }
        if Reprocess then                            { Check for reprocess }
          Rslt := Process(Length(Pic^) + 1);         { Move to next name }
      end;
      if (Rslt = prAmbiguous) then                   { Result ambiguous }
        Picture := prComplete
      else                   { Return completed }
      if (Rslt = prInCompNoFill) then              { Result incomplete }
        Picture := prIncomplete
      else               { Return incomplete }
        Picture := Rslt;                         { Return result }
    end;
  end;
end;

{--TPXPictureValidator------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TPXPictureValidator.Error;
const
  PXErrMsg = 'Input does not conform to picture:';
var
  S: string;
begin
  if (Pic <> nil) then
    S := Pic^
  else
    S := 'No name';{ Transfer filename }
  MessageBox(PxErrMsg + #13' %s', @S, mfError or mfOKButton);
  { Message box }
end;

{--TPXPictureValidator------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TPXPictureValidator.Store(var S: TStream);
begin
  TValidator.Store(S);                                { TValidator.store call }
  S.WriteStr(Pic);                                    { Write filename }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     TFilterValidator OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TFilterValidator---------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TFilterValidator.Init(AValidChars: CharSet);
begin
  inherited Init;                                    { Call ancestor }
  ValidChars := AValidChars;                         { Hold valid char set }
end;

{--TFilterValidator---------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TFilterValidator.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  S.Read(ValidChars, SizeOf(ValidChars));            { Read valid char set }
end;

{--TFilterValidator---------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function TFilterValidator.IsValid(const S: string): boolean;
var
  I: integer;
begin
  I := 1;                                            { Start at position 1 }
  while S[I] in ValidChars do
    Inc(I);                { Check each char }
  if (I > Length(S)) then
    IsValid := True
  else       { All characters valid }
    IsValid := False;                                { Invalid characters }
end;

{--TFilterValidator---------------------------------------------------------}
{  IsValidInput -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB      }
{---------------------------------------------------------------------------}
function TFilterValidator.IsValidInput(var S: string; SuppressFill: boolean): boolean;
var
  I: integer;
begin
  I := 1;                                            { Start at position 1 }
  while S[I] in ValidChars do
    Inc(I);                { Check each char }
  if (I > Length(S)) then
    IsValidInput := True       { All characters valid }
  else
    IsValidInput := False;                      { Invalid characters }
end;

{--TFilterValidator---------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TFilterValidator.Error;
const
  PXErrMsg = 'Invalid character in input';
begin
  MessageBox(PXErrMsg, nil, mfError or mfOKButton);  { Show error message }
end;

{--TFilterValidator---------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TFilterValidator.Store(var S: TStream);
begin
  TValidator.Store(S);                               { TValidator.Store call }
  S.Write(ValidChars, SizeOf(ValidChars));           { Write valid char set }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                      TRangeValidator OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TRangeValidator----------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TRangeValidator.Init(AMin, AMax: longint);
begin
  inherited Init(['0'..'9', '+', '-']);                { Call ancestor }
  if (AMin >= 0) then                                { Check min value > 0 }
    ValidChars := ValidChars - ['-'];                { Is so no negatives }
  Min := AMin;                                       { Hold min value }
  Max := AMax;                                       { Hold max value }
end;

{--TRangeValidator----------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TRangeValidator.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  S.Read(Min, SizeOf(Min));                          { Read min value }
  S.Read(Max, SizeOf(Max));                          { Read max value }
end;

{--TRangeValidator----------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function TRangeValidator.IsValid(const S: string): boolean;
var
  Value: longint;
  Code: Sw_Integer;
begin
  IsValid := False;                                  { Preset false result }
  if inherited IsValid(S) then
  begin                 { Call ancestor }
    Val(S, Value, Code);                             { Convert to number }
    if (Value >= Min) and (Value <= Max)             { With valid range } and
      (Code = 0) then
      IsValid := True;           { No illegal chars }
  end;
end;

{--TRangeValidator----------------------------------------------------------}
{  Transfer -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB          }
{---------------------------------------------------------------------------}
function TRangeValidator.Transfer(var S: string; Buffer: Pointer;
  Flag: TVTransfer): word;
var
  Value: longint;
  Code: Sw_Integer;
begin
  if (Options and voTransfer <> 0) then
  begin        { Tranfer mask set }
    Transfer := SizeOf(Value);                       { Transfer a longint }
    case Flag of
      vtGetData:
      begin
        Val(S, Value, Code);                         { Convert s to number }
        longint(Buffer^) := Value;                   { Transfer result }
      end;
      vtSetData: Str(longint(Buffer^), S);           { Convert to string s }
    end;
  end
  else
    Transfer := 0;                            { No transfer = zero }
end;

{--TRangeValidator----------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TRangeValidator.Error;
const
  PXErrMsg = 'Value not in the range';
var
  Params: array[0..1] of longint;
begin
  Params[0] := Min;                                  { Transfer min value }
  Params[1] := Max;                                  { Transfer max value }
  MessageBox(PXErrMsg + ' %d to %d', @Params,
    mfError or mfOKButton);                          { Display message }
end;

{--TRangeValidator----------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TRangeValidator.Store(var S: TStream);
begin
  TFilterValidator.Store(S);                         { TFilterValidator.Store }
  S.Write(Min, SizeOf(Min));                         { Write min value }
  S.Write(Max, SizeOf(Max));                         { Write max value }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                      TLookUpValidator OBJECT METHODS                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TLookUpValidator---------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function TLookUpValidator.IsValid(const S: string): boolean;
begin
  IsValid := LookUp(S);                              { Check for string }
end;

{--TLookUpValidator---------------------------------------------------------}
{  LookUp -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB            }
{---------------------------------------------------------------------------}
function TLookupValidator.Lookup(const S: string): boolean;
begin
  Lookup := True;                                    { Default return true }
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                   TStringLookUpValidator OBJECT METHODS                   }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStringLookUpValidator---------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TStringLookUpValidator.Init(AStrings: PStringCollection);
begin
  inherited Init;                                    { Call ancestor }
  Strings := AStrings;                               { Hold string list }
end;

{--TStringLookUpValidator---------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TStringLookUpValidator.Load(var S: TStream);
begin
  inherited Load(S);                                 { Call ancestor }
  Strings := PStringCollection(S.Get);               { Fecth string list }
end;

{--TStringLookUpValidator---------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
destructor TStringLookUpValidator.Done;
begin
  NewStringList(nil);                                { Dispsoe string list }
  inherited Done;                                    { Call ancestor }
end;

{--TStringLookUpValidator---------------------------------------------------}
{  Lookup -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB            }
{---------------------------------------------------------------------------}
function TStringLookUpValidator.Lookup(const S: string): boolean;
{$IFDEF PPC_VIRTUAL}
var
  Index: longint;
{$ELSE}
var
  Index: sw_Integer;
{$ENDIF}
begin
  Lookup := False;                                   { Preset false return }
  if (Strings <> nil) then
    Lookup := Strings^.Search(@S, Index);            { Search for string }
end;

{--TStringLookUpValidator---------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TStringLookUpValidator.Error;
const
  PXErrMsg = 'Input not in valid-list';
begin
  MessageBox(PXErrMsg, nil, mfError or mfOKButton);  { Display message }
end;

{--TStringLookUpValidator---------------------------------------------------}
{  NewStringList -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB     }
{---------------------------------------------------------------------------}
procedure TStringLookUpValidator.NewStringList(AStrings: PStringCollection);
begin
  if (Strings <> nil) then
    Dispose(Strings, Done);   { Free old string list }
  Strings := AStrings;                               { Hold new string list }
end;

{--TStringLookUpValidator---------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TStringLookUpValidator.Store(var S: TStream);
begin
  TLookupValidator.Store(S);                         { TlookupValidator call }
  S.Put(Strings);                                    { Now store strings }
end;

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           OBJECT REGISTER ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  RegisterValidate -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB  }
{---------------------------------------------------------------------------}
procedure RegisterValidate;
begin
  RegisterType(RPXPictureValidator);                 { Register viewer }
  RegisterType(RFilterValidator);                    { Register filter }
  RegisterType(RRangeValidator);                     { Register validator }
  RegisterType(RStringLookupValidator);              { Register str lookup }
end;

end.
