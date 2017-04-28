{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}
{                                                          }
{   System independent GRAPHICAL clone of VALIDATE.PAS     }
{                                                          }
{   Interface Copyright (c) 1992 Borland International     }
{                                                          }
{   Copyright (c) 1996, 1997, 1998, 1999 by Leon de Boer   }
{   ldeboer@ibm.net                                        }
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
{                                                          }
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

UNIT fv2validate;

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

USES classes, sysutils, FV2Common;                      { GFV standard units }

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                         VALIDATOR STATUS CONSTANTS                        }
{---------------------------------------------------------------------------}
CONST
   vsOk     = 0;                                      { Validator ok }
   vsSyntax = 1;                                      { Validator sytax err }

{---------------------------------------------------------------------------}
{                           VALIDATOR OPTION MASKS                          }
{---------------------------------------------------------------------------}
CONST
   voFill     = $0001;                                { Validator fill }
   voTransfer = $0002;                                { Validator transfer }
   voOnAppend = $0004;                                { Validator append }
   voReserved = $00F8;                                { Clear above flags }

{***************************************************************************}
{                            RECORD DEFINITIONS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                        VALIDATOR TRANSFER CONSTANTS                       }
{---------------------------------------------------------------------------}
TYPE
   TVTransfer = (vtDataSize, vtSetData, vtGetData);   { Transfer states }

{---------------------------------------------------------------------------}
{                    PICTURE VALIDATOR RESULT CONSTANTS                     }
{---------------------------------------------------------------------------}
TYPE
   TPicResult = (prComplete, prIncomplete, prEmpty, prError, prSyntax,
     prAmbiguous, prIncompNoFill);

{***************************************************************************}
{                            OBJECT DEFINITIONS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                TValidator OBJECT - VALIDATOR ANCESTOR OBJECT              }
{---------------------------------------------------------------------------}
TYPE
   TValidator = class(TComponent)
      public
         Status : Word;                               { Validator status }
         Options: Word;                               { Validator options }
      CONSTRUCTOR Load (Var S: TStream);
      FUNCTION Valid(CONST S: String): Boolean;
      FUNCTION IsValid (CONST {%H-}S: String): Boolean; Virtual;
      FUNCTION IsValidInput (Var {%H-}S: String;
        SuppressFill: Boolean): Boolean; Virtual;
      FUNCTION Transfer (Var {%H-}S: String;{%H-}Buffer: TStream;
        {%H-}Flag: TVTransfer): Word; Virtual;
      PROCEDURE Error; Virtual;
      PROCEDURE Store (Var S: TStream);
   END;

{---------------------------------------------------------------------------}
{           TPictureValidator OBJECT - PICTURE VALIDATOR OBJECT             }
{---------------------------------------------------------------------------}
TYPE
   TPXPictureValidator = class (TValidator)
      public
         Pic: String;                                { Picture filename }
      CONSTRUCTOR Init (Const APic: String; AutoFill: Boolean);
      CONSTRUCTOR Load (Var S: TStream);
      DESTRUCTOR Done; Virtual;
      FUNCTION IsValid (Const S: String): Boolean; override;
      FUNCTION IsValidInput (Var S: string;
        SuppressFill: Boolean): Boolean; override;
      FUNCTION Picture (Var Input: String;
        AutoFill: Boolean): TPicResult; Virtual;
      PROCEDURE Error; override;
      PROCEDURE Store (Var S: TStream);
   END;

TYPE TCharSet = set of char;

{---------------------------------------------------------------------------}
{            TFilterValidator OBJECT - FILTER VALIDATOR OBJECT              }
{---------------------------------------------------------------------------}
TYPE
   TFilterValidator = class (TValidator)
      public
         ValidChars: TCharSet;                         { Valid char set }
      CONSTRUCTOR Create (AValidChars: TCharSet);reintroduce;
      CONSTRUCTOR Load (Var S: TStream);
      FUNCTION IsValid (CONST S: String): Boolean; override;
      FUNCTION IsValidInput (Var S: string;
        SuppressFill: Boolean): Boolean; override;
      PROCEDURE Error; override;
      PROCEDURE Store (Var S: TStream);
   END;


{---------------------------------------------------------------------------}
{             TRangeValidator OBJECT - RANGE VALIDATOR OBJECT               }
{---------------------------------------------------------------------------}
TYPE
   TRangeValidator = class (TFilterValidator)
      public
         Min: LongInt;                                { Min valid value }
         Max: LongInt;                                { Max valid value }
      CONSTRUCTOR Create(AMin, AMax: LongInt);
      CONSTRUCTOR Load (Var S: TStream);
      FUNCTION IsValid (Const S: String): Boolean; override;
      function Transfer(var S: String;Buffer: TStream; Flag: TVTransfer): Word; override;
      PROCEDURE Error; override;
      PROCEDURE Store (Var S: TStream);
   END;

{---------------------------------------------------------------------------}
{            TLookUpValidator OBJECT - LOOKUP VALIDATOR OBJECT              }
{---------------------------------------------------------------------------}
TYPE
   TLookupValidator = Class (TValidator)
     public
      FUNCTION IsValid (Const S: String): Boolean;                   override;
      FUNCTION Lookup (Const {%H-}S: String): Boolean;                    Virtual;
   END;

{---------------------------------------------------------------------------}
{      TStringLookUpValidator OBJECT - STRING LOOKUP VALIDATOR OBJECT       }
{---------------------------------------------------------------------------}
TYPE
   TStringLookupValidator = class (TLookupValidator)
     public
         Strings: TStrings;
      CONSTRUCTOR Create (AStrings: TStrings);reintroduce;
      CONSTRUCTOR Load (Var S: TStream);
      DESTRUCTOR Destroy;                                               override;
      FUNCTION Lookup (Const S: String): Boolean;                    override;
      PROCEDURE Error;                                               override;
      PROCEDURE NewStringList (AStrings: TStrings);
      PROCEDURE Store (Var S: TStream);
   END;
    PStringLookupValidator = ^TStringLookupValidator deprecated 'use TStringLookupValidator';

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
PROCEDURE RegisterValidate;

{***************************************************************************}
{                           OBJECT REGISTRATION                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                 TPXPictureValidator STREAM REGISTRATION                   }
{---------------------------------------------------------------------------}

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

USES fv2MsgBox;                                          { GFV standard unit }

{***************************************************************************}
{                              PRIVATE ROUTINES                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{  IsLetter -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB          }
{---------------------------------------------------------------------------}
FUNCTION IsLetter (Chr: Char): Boolean;
BEGIN
   Chr := Char(Ord(Chr) AND $DF);                     { Lower to upper case }
   If (Chr >= 'A') AND (Chr <='Z') Then               { Check if A..Z }
     IsLetter := True Else IsLetter := False;         { Return result }
END;

{---------------------------------------------------------------------------}
{  IsComplete -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB        }
{---------------------------------------------------------------------------}
FUNCTION IsComplete (Rslt: TPicResult): Boolean;
BEGIN
   IsComplete := Rslt IN [prComplete, prAmbiguous];   { Return if complete }
END;

{---------------------------------------------------------------------------}
{  IsInComplete -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB      }
{---------------------------------------------------------------------------}
FUNCTION IsIncomplete (Rslt: TPicResult): Boolean;
BEGIN
   IsIncomplete := Rslt IN
     [prIncomplete, prIncompNoFill];                  { Return if incomplete }
END;

{---------------------------------------------------------------------------}
{  NumChar -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
FUNCTION NumChar (Chr: Char; Const S: String): Byte;
VAR I, Total: Byte;
BEGIN
   Total := 0;                                        { Zero total }
   For I := 1 To Length(S) Do                         { For entire string }
     If (S[I] = Chr) Then Inc(Total);                 { Count matches of Chr }
   NumChar := Total;                                  { Return char count }
END;

{---------------------------------------------------------------------------}
{  IsSpecial -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB         }
{---------------------------------------------------------------------------}
FUNCTION IsSpecial (Chr: Char; Const Special: String): Boolean;
VAR Rslt: Boolean; I: Byte;
BEGIN
   Rslt := False;                                     { Preset false result }
   For I := 1 To Length(Special) Do
     If (Special[I] = Chr) Then Rslt := True;         { Character found }
   IsSpecial := Rslt;                                 { Return result }
END;

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
BEGIN
   Inherited Create(nil);                                    { Call ancestor }
   S.Read(Options, SizeOf(Options));                  { Read option masks }
END;

{--TValidator---------------------------------------------------------------}
{  Valid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
function TValidator.Valid(const S: String): Boolean;
BEGIN
   Valid := False;                                    { Preset false result }
   If Not IsValid(S) Then Error                       { Check for error }
     Else Valid := True;                              { Return valid result }
END;

{--TValidator---------------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function TValidator.IsValid(const S: String): Boolean;
BEGIN
   IsValid := True;                                   { Default return valid }
END;

{--TValidator---------------------------------------------------------------}
{  IsValidInput -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB      }
{---------------------------------------------------------------------------}
function TValidator.IsValidInput(var S: String; SuppressFill: Boolean): Boolean;
BEGIN
   IsValidInput := True;                              { Default return true }
END;

{--TValidator---------------------------------------------------------------}
{  Transfer -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB          }
{---------------------------------------------------------------------------}
function TValidator.Transfer(var S: String; Buffer: TStream; Flag: TVTransfer
  ): Word;
BEGIN
   Transfer := 0;                                     { Default return zero }
END;

{--TValidator---------------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TValidator.Error;
BEGIN                                                 { Abstract method }
END;

{--TValidator---------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TValidator.Store(var S: TStream);
BEGIN
   S.Write(Options, SizeOf(Options));                 { Write options }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                    TPXPictureValidator OBJECT METHODS                     }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TPXPictureValidator------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TPXPictureValidator.Init (Const APic: String; AutoFill: Boolean);
VAR S: String;
BEGIN
   Inherited Create(nil);                                    { Call ancestor }
   Pic := APic;                               { Hold filename }
   Options := voOnAppend;                             { Preset option mask }
   If AutoFill Then Options := Options OR voFill;     { Check/set fill mask }
   S := '';                                           { Create empty string }
   If (Picture(S, False) <> prEmpty) Then             { Check for empty }
     Status := vsSyntax;                              { Set error mask }
END;

{--TPXPictureValidator------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TPXPictureValidator.Load (Var S: TStream);
BEGIN
   Inherited Load(S);                                 { Call ancestor }
   Pic := S.ReadAnsiString;                                  { Read filename }
END;

{--TPXPictureValidator------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TPXPictureValidator.Done;
BEGIN
   If (Pic <> '') Then Pic:='';              { Dispose of filename }
   Inherited ;                                    { Call ancestor }
END;

{--TPXPictureValidator------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TPXPictureValidator.IsValid (Const S: String): Boolean;
VAR Str: String; Rslt: TPicResult;
BEGIN
   Str := S;                                          { Transfer string }
   Rslt := Picture(Str, False);                       { Check for picture }
   IsValid := (Pic = '') OR (Rslt = prComplete) OR
     (Rslt = prEmpty);                                { Return result }
END;

{--TPXPictureValidator------------------------------------------------------}
{  IsValidInput -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB      }
{---------------------------------------------------------------------------}
FUNCTION TPXPictureValidator.IsValidInput (Var S: String;
  SuppressFill: Boolean): Boolean;
BEGIN
   IsValidInput := (Pic = '') OR (Picture(S,
    (Options AND voFill <> 0)  AND NOT SuppressFill)
     <> prError);                                     { Return input result }
END;

{--TPXPictureValidator------------------------------------------------------}
{  Picture -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TPXPictureValidator.Picture (Var Input: String; AutoFill: Boolean): TPicResult;
VAR I, J: Byte; Rslt: TPicResult; Reprocess: Boolean;

   FUNCTION Process (TermCh: Byte): TPicResult;
   VAR Rslt: TPicResult; Incomp: Boolean; OldI, OldJ, IncompJ, IncompI: Byte;

     PROCEDURE Consume (Ch: Char);
     BEGIN
       Input[J] := Ch;                                { Return character }
       Inc(J);                                        { Inc count J }
       Inc(I);                                        { Inc count I }
     END;

     PROCEDURE ToGroupEnd (Var I: Byte);
     VAR BrkLevel, BrcLevel: Integer;
     BEGIN
       BrkLevel := 0;                                 { Zero bracket level }
       BrcLevel := 0;                                 { Zero bracket level }
       Repeat
         If (I <> TermCh) Then Begin                  { Not end }
           Case Pic[I] Of
             '[': Inc(BrkLevel);                      { Inc bracket level }
             ']': Dec(BrkLevel);                      { Dec bracket level }
             '{': Inc(BrcLevel);                      { Inc bracket level }
             '}': Dec(BrcLevel);                      { Dec bracket level }
             ';': Inc(I);                             { Next character }
             '*': Begin
                 Inc(I);                              { Next character }
                 While Pic[I] in ['0'..'9'] Do Inc(I);   { Search for text }
                 ToGroupEnd(I);                       { Move to group end }
                 Continue;                            { Now continue }
               End;
           End;
           Inc(I);                                    { Next character }
         End;
       Until ((BrkLevel = 0) AND (BrcLevel = 0)) OR   { Both levels must be 0 }
       (I = TermCh);                                  { Terminal character }
     END;

     FUNCTION SkipToComma: Boolean;
     BEGIN
       Repeat
         ToGroupEnd(I);                               { Find group end }
       Until (I = TermCh) OR (Pic[I] = ',');         { Terminator found }
       If (Pic[I] = ',') Then Inc(I);                { Comma so continue }
       SkipToComma := (I < TermCh);                   { Return result }
     END;

     FUNCTION CalcTerm: Byte;
     VAR K: Byte;
     BEGIN
       K := I;                                        { Hold count }
       ToGroupEnd(K);                                 { Find group end }
       CalcTerm := K;                                 { Return count }
     END;

     FUNCTION Iteration: TPicResult;
     VAR Itr, K, L: Byte; Rslt: TPicResult; NewTermCh: Byte;
     BEGIN
       Itr := 0;                                      { Zero iteration }
       Iteration := prError;                          { Preset error result }
       Inc(I);                                        { Skip '*' character }
       While Pic[I] in ['0'..'9'] Do Begin           { Entry is a number }
         Itr := Itr * 10 + Byte(Pic[I]) - Byte('0'); { Convert to number }
         Inc(I);                                      { Next character }
       End;
       If (I <= TermCh) Then Begin                    { Not end of name }
         K := I;                                      { Hold count }
         NewTermCh := CalcTerm;                       { Calc next terminator }
         If (Itr <> 0) Then Begin
           For L := 1 To Itr Do Begin                 { For each character }
             I := K;                                  { Reset count }
             Rslt := Process(NewTermCh);              { Process new entry }
             If (NOT IsComplete(Rslt)) Then Begin     { Not empty }
               If (Rslt = prEmpty) Then               { Check result }
                 Rslt := prIncomplete;                { Return incomplete }
               Iteration := Rslt;                     { Return result }
               Exit;                                  { Now exit }
             End;
           End;
         End Else Begin
           Repeat
             I := K;                                  { Hold count }
             Rslt := Process(NewTermCh);              { Process new entry }
           Until (NOT IsComplete(Rslt));              { Until complete }
           If (Rslt = prEmpty) OR (Rslt = prError)    { Check for any error }
           Then Begin
             Inc(I);                                  { Next character }
             Rslt := prAmbiguous;                     { Return result }
           End;
         End;
         I := NewTermCh;                              { Find next name }
       End Else Rslt := prSyntax;                     { Completed }
       Iteration := Rslt;                             { Return result }
     END;

     FUNCTION Group: TPicResult;
     VAR Rslt: TPicResult; TermCh: Byte;
     BEGIN
       TermCh := CalcTerm;                            { Calc new term }
       Inc(I);                                        { Next character }
       Rslt := Process(TermCh - 1);                   { Process the name }
       If (NOT IsIncomplete(Rslt)) Then I := TermCh;  { Did not complete }
       Group := Rslt;                                 { Return result }
     END;

     FUNCTION CheckComplete (Rslt: TPicResult): TPicResult;
     VAR J: Byte;
     BEGIN
       J := I;                                        { Hold count }
       If IsIncomplete(Rslt) Then Begin               { Check if complete }
         While True Do
           Case Pic[J] Of
             '[': ToGroupEnd(J);                      { Find name end }
             '*': If not(Pic[J + 1] in ['0'..'9'])
               Then Begin
                 Inc(J);                              { Next name }
                 ToGroupEnd(J);                       { Find name end }
               End Else Break;
             Else Break;
           End;
         If (J = TermCh) Then Rslt := prAmbiguous;    { End of name }
       End;
       CheckComplete := Rslt;                         { Return result }
     END;

     FUNCTION Scan: TPicResult;
     VAR Ch: Char; Rslt: TPicResult;
     BEGIN
       Scan := prError;                               { Preset return error }
       Rslt := prEmpty;                               { Preset empty result }
       While (I <> TermCh) AND (Pic[I] <> ',')       { For each entry }
       Do Begin
         If (J > Length(Input)) Then Begin            { Move beyond length }
           Scan := CheckComplete(Rslt);               { Return result }
           Exit;                                      { Now exit }
         End;
         Ch := Input[J];                              { Fetch character }
         Case Pic[I] of
           '#': If NOT (Ch in ['0'..'9']) Then Exit   { Check is a number }
               Else Consume(Ch);                      { Transfer number }
           '?': If (NOT IsLetter(Ch)) Then Exit       { Check is a letter }
               Else Consume(Ch);                      { Transfer character }
           '&': If (NOT IsLetter(Ch)) Then Exit       { Check is a letter }
               Else Consume(UpCase(Ch));              { Transfer character }
           '!': Consume(UpCase(Ch));                  { Transfer character }
           '@': Consume(Ch);                          { Transfer character }
           '*': Begin
             Rslt := Iteration;                       { Now re-iterate }
             If (NOT IsComplete(Rslt)) Then Begin     { Check not complete }
               Scan := Rslt;                          { Return result }
               Exit;                                  { Now exit }
             End;
             If (Rslt = prError) Then                 { Check for error }
               Rslt := prAmbiguous;                   { Return ambiguous }
           End;
           '{': Begin
             Rslt := Group;                           { Return group }
             If (NOT IsComplete(Rslt)) Then Begin     { Not incomplete check }
               Scan := Rslt;                          { Return result }
               Exit;                                  { Now exit }
             End;
           End;
           '[': Begin
             Rslt := Group;                           { Return group }
             If IsIncomplete(Rslt) Then Begin         { Incomplete check }
               Scan := Rslt;                          { Return result }
               Exit;                                  { Now exit }
             End;
             If (Rslt = prError) Then                 { Check for error }
               Rslt := prAmbiguous;                   { Return ambiguous }
           End;
           Else If Pic[I] = ';' Then Inc(I);         { Move fwd for follow }
           If (UpCase(Pic[I]) <> UpCase(Ch)) Then    { Characters differ }
             If (Ch = ' ') Then Ch := Pic[I]         { Ignore space }
             Else Exit;
           Consume(Pic[I]);                          { Consume character }
         End; { Case }
         If (Rslt = prAmbiguous) Then                 { If ambiguous result }
           Rslt := prIncompNoFill                     { Set incomplete fill }
           Else Rslt := prIncomplete;                 { Set incomplete }
       End;{ While}
       If (Rslt = prIncompNoFill) Then                { Check incomp fill }
         Scan := prAmbiguous Else                     { Return ambiguous }
         Scan := prComplete;                          { Return completed }
     END;

   BEGIN
     Incomp := False;                                 { Clear incomplete }
     InCompJ:=0;                                      { set to avoid a warning }
     OldI := I;                                       { Hold I count }
     OldJ := J;                                       { Hold J count }
     Repeat
       Rslt := Scan;                                  { Scan names }
       If (Rslt IN [prComplete, prAmbiguous]) AND
       Incomp AND (J < IncompJ) Then Begin            { Check if complete }
         Rslt := prIncomplete;                        { Return result }
         J := IncompJ;                                { Return position }
       End;
       If ((Rslt = prError) OR (Rslt = prIncomplete)) { Check no errors }
       Then Begin
         Process := Rslt;                             { Hold result }
         If ((NOT Incomp) AND (Rslt = prIncomplete))  { Check complete }
         Then Begin
           Incomp := True;                            { Set incomplete }
           IncompI := I;                              { Set current position }
           IncompJ := J;                              { Set current position }
         End;
         I := OldI;                                   { Restore held value }
         J := OldJ;                                   { Restore held value }
         If (NOT SkipToComma) Then Begin              { Check not comma }
           If Incomp Then Begin                       { Check incomplete }
             Process := prIncomplete;                 { Set incomplete mask }
             I := IncompI;                            { Hold incomp position }
             J := IncompJ;                            { Hold incomp position }
           End;
           Exit;                                      { Now exit }
         End;
         OldI := I;                                   { Hold position }
       End;
     Until (Rslt <> prError) AND                      { Check for error }
       (Rslt <> prIncomplete);                        { Incomplete load }
     If (Rslt = prComplete) AND Incomp Then           { Complete load }
       Process := prAmbiguous Else                    { Return completed }
       Process := Rslt;                               { Return result }
   END;

   FUNCTION SyntaxCheck: Boolean;
   VAR I, BrkLevel, BrcLevel: Integer;
   Begin
     SyntaxCheck := False;                            { Preset false result }
     If (Pic <> '') AND (Pic[Length(Pic)] <> ';')  { Name is valid }
     AND ((Pic[Length(Pic)] = '*') AND
     (Pic[Length(Pic) - 1] <> ';') = False)         { Not wildcard list }
     Then Begin
       I := 1;                                        { Set count to 1 }
       BrkLevel := 0;                                 { Zero bracket level }
       BrcLevel := 0;                                 { Zero bracket level }
       While (I <= Length(Pic)) Do Begin             { For each character }
         Case Pic[I] Of
           '[': Inc(BrkLevel);                        { Inc bracket level }
           ']': Dec(BrkLevel);                        { Dec bracket level }
           '{': Inc(BrcLevel);                        { Inc bracket level }
           '}': Dec(BrcLevel);                        { Dec bracket level }
           ';': Inc(I);                               { Next character }
         End;
         Inc(I);                                      { Next character }
       End;
       If (BrkLevel = 0) AND (BrcLevel = 0) Then      { Check both levels 0 }
         SyntaxCheck := True;                         { Return true syntax }
     End;
   End;

BEGIN
   Picture := prSyntax;                               { Preset error default }
   If SyntaxCheck Then Begin                          { Check syntax }
     Picture := prEmpty;                              { Preset picture empty }
     If (Input <> '') Then Begin                      { We have an input }
       J := 1;                                        { Set J count to 1 }
       I := 1;                                        { Set I count to 1 }
       Rslt := Process(Length(Pic) + 1);             { Set end of name }
       If (Rslt <> prError) AND (Rslt <> prSyntax) AND
        (J <= Length(Input)) Then Rslt := prError;    { Check for any error }
       If (Rslt = prIncomplete) AND AutoFill          { Check autofill flags }
       Then Begin
         Reprocess := False;                          { Set reprocess false }
         while (I <= Length(Pic)) AND (NOT           { Not at end of name }
         IsSpecial(Pic[I], '#?&!@*{}[],'#0))         { No special chars }
         DO Begin
           If Pic[I] = ';' Then Inc(I);              { Check for next mark }
           Input := Input + Pic[I];                  { Move to that name }
           Inc(I);                                    { Inc count }
           Reprocess := True;                         { Set reprocess flag }
         End;
         J := 1;                                      { Set J count to 1 }
         I := 1;                                      { Set I count to 1 }
         If Reprocess Then                            { Check for reprocess }
           Rslt := Process(Length(Pic) + 1);         { Move to next name }
       End;
       If (Rslt = prAmbiguous) Then                   { Result ambiguous }
         Picture := prComplete Else                   { Return completed }
         If (Rslt = prInCompNoFill) Then              { Result incomplete }
           Picture := prIncomplete Else               { Return incomplete }
             Picture := Rslt;                         { Return result }
     End;
   End;
END;

{--TPXPictureValidator------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TPXPictureValidator.Error;
CONST PXErrMsg = 'Input does not conform to picture:';
VAR S: String;
BEGIN
   If (Pic <> '') Then S := Pic Else S := 'No name';{ Transfer filename }
   MessageBox(PxErrMsg + #13' %s', [S],  mfError OR
     mfOKButton);                                     { Message box }
END;

{--TPXPictureValidator------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TPXPictureValidator.Store (Var S: TStream);
BEGIN
  inherited Store(S);                                { TValidator.store call }
  S.WriteAnsiString(Pic);                                    { Write filename }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     TFilterValidator OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TFilterValidator---------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TFilterValidator.Create(AValidChars: TCharSet);
BEGIN
   Inherited create(nil);                                    { Call ancestor }
   ValidChars := AValidChars;                         { Hold valid char set }
END;

{--TFilterValidator---------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TFilterValidator.Load(var S: TStream);
BEGIN
   Inherited Load(S);                                 { Call ancestor }
   S.Read(ValidChars, SizeOf(ValidChars));            { Read valid char set }
END;

{--TFilterValidator---------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function TFilterValidator.IsValid(const S: String): Boolean;
VAR I: Integer;
BEGIN
   I := 1;                                            { Start at position 1 }
   While S[I] In ValidChars Do Inc(I);                { Check each char }
   If (I > Length(S)) Then IsValid := True Else       { All characters valid }
     IsValid := False;                                { Invalid characters }
END;

{--TFilterValidator---------------------------------------------------------}
{  IsValidInput -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB      }
{---------------------------------------------------------------------------}
function TFilterValidator.IsValidInput(var S: string; SuppressFill: Boolean
  ): Boolean;
VAR I: Integer;
BEGIN
   I := 1;                                            { Start at position 1 }
   While S[I] In ValidChars Do Inc(I);                { Check each char }
   If (I > Length(S)) Then IsValidInput := True       { All characters valid }
     Else IsValidInput := False;                      { Invalid characters }
END;

{--TFilterValidator---------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TFilterValidator.Error;
CONST PXErrMsg = 'Invalid character in input';
BEGIN
   MessageBox(PXErrMsg, [], mfError OR mfOKButton);  { Show error message }
END;

{--TFilterValidator---------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TFilterValidator.Store(var S: TStream);
BEGIN
   inherited Store(S);                               { TValidator.Store call }
   S.Write(ValidChars, SizeOf(ValidChars));           { Write valid char set }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                      TRangeValidator OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TRangeValidator----------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TRangeValidator.Create(AMin, AMax: LongInt);
BEGIN
   Inherited create(['0'..'9','+','-']);                { Call ancestor }
   If (AMin >= 0) Then                                { Check min value > 0 }
     ValidChars := ValidChars - ['-'];                { Is so no negatives }
   Min := AMin;                                       { Hold min value }
   Max := AMax;                                       { Hold max value }
END;

{--TRangeValidator----------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TRangeValidator.Load(var S: TStream);
BEGIN
   Inherited Load(S);                                 { Call ancestor }
   S.Read(Min, SizeOf(Min));                          { Read min value }
   S.Read(Max, SizeOf(Max));                          { Read max value }
END;

{--TRangeValidator----------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
function TRangeValidator.IsValid(const S: String): Boolean;
VAR Value: LongInt;
BEGIN
   IsValid :=
      Inherited IsValid(S) and                     { Call ancestor }
     tryStrtoint(S,Value) and                      { No illegal chars }
      (Value >= Min) AND (Value <= Max);          { With valid range }
END;

{--TRangeValidator----------------------------------------------------------}
{  Transfer -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB          }
{---------------------------------------------------------------------------}
function TRangeValidator.Transfer(var S: String;Buffer :TStream;
  Flag: TVTransfer): Word;

VAR Value: LongInt;
BEGIN
   If (Options AND voTransfer <> 0) and
     assigned(Buffer)  Then Begin        { Tranfer mask set }
     Transfer := SizeOf(Value);                       { Transfer a longint }
     Case Flag Of
       vtGetData: Begin
         if TryStrToInt(S,Value) then                 { Convert s to number }
         Buffer.WriteDWord(Value);                   { Transfer result }
       End;
       vtSetData:
         S := IntToStr(Buffer.ReadDWord);                   { Transfer result }
     End;
   End Else Transfer := 0;                            { No transfer = zero }
END;

{--TRangeValidator----------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TRangeValidator.Error;
CONST PXErrMsg = 'Value not in the range';
VAR Params: Array[0..1] Of TVarRec;
BEGIN
   Params[0].VInteger := Min;                                  { Transfer min value }
   Params[1].VInteger := Max;                                  { Transfer max value }
   MessageBox(PXErrMsg+' %d to %d', Params,
     mfError OR mfOKButton);                          { Display message }
END;

{--TRangeValidator----------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TRangeValidator.Store(var S: TStream);
BEGIN
   inherited Store(S);                         { TFilterValidator.Store }
   S.Write(Min, SizeOf(Min));                         { Write min value }
   S.Write(Max, SizeOf(Max));                         { Write max value }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                      TLookUpValidator OBJECT METHODS                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TLookUpValidator---------------------------------------------------------}
{  IsValid -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TLookUpValidator.IsValid (Const S: String): Boolean;
BEGIN
   IsValid := LookUp(S);                              { Check for string }
END;

{--TLookUpValidator---------------------------------------------------------}
{  LookUp -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB            }
{---------------------------------------------------------------------------}
FUNCTION TLookupValidator.Lookup (Const S: String): Boolean;
BEGIN
   Lookup := (s <> '');                                    { Default return true }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                   TStringLookUpValidator OBJECT METHODS                   }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStringLookUpValidator---------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TStringLookupValidator.Create(AStrings: TStrings);
BEGIN
   Inherited create(nil);                                    { Call ancestor }
   Strings := AStrings;                               { Hold string list }
END;

{--TStringLookUpValidator---------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
constructor TStringLookupValidator.Load(var S: TStream);
BEGIN
   Inherited Load(S);
   strings:=TStringList.Create;                          { Call ancestor }
   Strings.loadfromstream(S);               { Fecth string list }
END;

{--TStringLookUpValidator---------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB              }
{---------------------------------------------------------------------------}
destructor TStringLookupValidator.Destroy;
BEGIN
   NewStringList(Nil);                                { Dispsoe string list }
   Inherited ;                                    { Call ancestor }
END;

{--TStringLookUpValidator---------------------------------------------------}
{  Lookup -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB            }
{---------------------------------------------------------------------------}
function TStringLookupValidator.Lookup(const S: String): Boolean;

BEGIN
   Result := False;                                   { Preset false return }
   If (Strings <> Nil) Then
     Result := Strings.IndexOf(S)>-1;            { Search for string }
END;

{--TStringLookUpValidator---------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TStringLookupValidator.Error;
CONST PXErrMsg = 'Input not in valid-list';
BEGIN
   MessageBox(PXErrMsg, [], mfError OR mfOKButton);  { Display message }
END;

{--TStringLookUpValidator---------------------------------------------------}
{  NewStringList -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB     }
{---------------------------------------------------------------------------}
procedure TStringLookupValidator.NewStringList(AStrings: TStrings);
BEGIN
//   If (Strings <> Nil) Then Dispose(Strings, Done);   { Free old string list }
   Strings.assign( AStrings);                               { Hold new string list }
END;

{--TStringLookUpValidator---------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB             }
{---------------------------------------------------------------------------}
procedure TStringLookupValidator.Store(var S: TStream);
BEGIN
   inherited Store(S);                         { TlookupValidator call }
   Strings.SaveToStream(S);                                    { Now store strings }
END;

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           OBJECT REGISTER ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  RegisterValidate -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18May98 LdB  }
{---------------------------------------------------------------------------}
PROCEDURE RegisterValidate;
BEGIN
   //RegisterType(RPXPictureValidator);                 { Register viewer }
   //RegisterType(RFilterValidator);                    { Register filter }
   //RegisterType(RRangeValidator);                     { Register validator }
   //RegisterType(RStringLookupValidator);              { Register str lookup }
END;

END.
