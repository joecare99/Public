unit cls_Translator;
// Project Full Name: OpenC2Pas
// CVS Server:        cvs.c2pas.sourceforge.net
// Home page:         http:/c2pas.sourceforge.net
// -----------------------------------------------------------------------------
// OpenC2Pas - Translator class
// -----------------------------------------------------------------------------
// Who whishes to contribute to this unit, should be good both in C/C++ and in
// Object Pascal. The purpose of OpenC2Pas is to save time in converting C/C++
// code to Object Pascal (Delphi) code.
// -----------------------------------------------------------------------------
//
// Copyright (C) 2002 Alberto Berardi
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

// =============================================================================
// Generic Programming Rules
// =============================================================================
// 1) //[...] = Something to do
// 2) Anything that TC2Pas doesn't translate (for now), and that can produce
//    wrong behaviours without generating error (e.g. an untranslated escape
//    sequence in astring), should be preceded by a remark like this:
//    (* C2PAS: WarningCode *)
//    This helps the user in finding these peculiar untranslated portion of
//    code.
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}
interface

const

   C2PAS_MAX_OUTPUTPOS = 512000;
   C2PAS_MAX_ERROR = 30;

   // Translator unit copyright and acknowledgements
   C2PAS_CONTRIBUTORS =
         'Copyright (c) 2002 Alberto Berardi'
 // + #10'Copyright (c) year contibutor 2'
 // + #10'Copyright (c) year contibutor 3'
 // + #10'Copyright (c) year contibutor 4'
 //...
 // + #10'Copyright (c) year contibutor n'
      ;

   //Special Characters
   apo = '''';  // Apostrophe
   crTAB = #9;  // Used in AddString().
   crCR  = #13;
   crLF  = #10;
   crEL  = #10; // End of line (please see translation of remarks).
                // DOS/Windows textfiles uses #13#10, so #10 is a good end of
                // line character for them

   //Escape Sequence Replacers
   StrCrBEL = apo + '#7'  + apo;  // \a Audible bell
   StrCrBS  = apo + '#8'  + apo;  // \b Backspace
   StrCrFF 	= apo + '#12' + apo;  // \f Formfeed
   StrCrLF  = apo + '#10' + apo;  // \n Newline (linefeed)
   StrCrCR  = apo + '#13' + apo;  // \r Carriage return
   StrCrHT  = apo + '#9'  + apo;  // \t Tab (horizontal)
   StrCrVT  = apo + '#11' + apo;  // \v Vertical tab

   //Error and warning codes
   C2PAS_ERRORS = 1000;     // if .Code is < C2PAS_ERRORS, it is a critical error
   C2PAS_WARNINGS = 2000;   // else if .Code is < C2PAS_WARNINGS, it is a warning
                            // else it is an Hint
   // WARNING: if you add another message code, please update the MsgString
   // function too.
   //----- Critical Errors ---------------
   //Translation stops if there is a critical error
   C2PAS_ERR_TOOMANY      = 1;         // Too many errors
   C2PAS_ERR_SRCTOOLONG   = 2;         // Source is too long
   C2PAS_ERR_TRANSTOOLONG = 3;         // Translation is too long
   C2PAS_ERR_ADDCHAR      = 4;         // Exception in AddChar procedure
   C2PAS_ERR_EXCEPTION    = 999;       // Internal error
   //----- Warnings ----------------------
   C2PAS_WRN_NOEND        = 1000;      // end of statement not found
   C2PAS_WRN_REFORBIT     = 1001;      // it is a bit operator or a reference operator?
   C2PAS_WRN_RETURN       = 1002;      // translation of "return" is incomplete. Please add "Exit"
   C2PAS_WRN_HEX          = 1003;      // hexadecimal translation not yet implemented
   C2PAS_WRN_OCTAL        = 1004;      // octal conversion not yet implemented
   //----- Hints -------------------------

   //AddString() modes
   asNoSpaces   = 0;
   asWantLSpace = 1;
   asWantRSpace = 2;
   asWantSpaces = 3;

   // Simple Replacements
   SimpleReplCount = 6;
   SimpleRepl : array [0..SimpleReplCount-1, 0..1] of string = (
   ('catch'  , 'except'), //[...] not great, but...
   ('NULL'   , 'nil'),    //[...] not always
   ('strcat' , 'StrCat'),
   ('strcpy' , 'StrCopy'),
   ('strcmp' , 'StrComp'),
   ('strcmpi', 'StrIComp')
   //[...]
   );

   DataTypesCount = 16;
   DataType : array [0..DataTypesCount-1, 0..1] of string = (
   //C/C++/BCB type    Delphi type
   ('DWORD'          , 'Longword'),
   ('signed char'    , 'Shortint'),
   ('short'          , 'SmallInt'),
   ('int'            , 'Integer'),
   ('unsigned char*' , 'PChar'),
   ('unsigned char'  , 'Byte'),
   ('unsigned short' , 'Word'),
   ('unsigned int'   , 'Cardinal'),
   ('bool'           , 'Boolean'),
   ('BOOL'           , 'LongBool'),
   ('wchar_t'        , 'WideChar'),
   ('AnsiString'     , 'AnsiString'),
   ('float'          , 'Single'),
   ('double'         , 'Double'),
   ('long double'    , 'Extended'),
   ('void*'          , 'Pointer')
   //[...]
   );

 type DebugMsgStruct = record //errors and warnings
   Code : Integer;
   Location : Integer;
 end;

 type

   { TC2Pas }

   TC2Pas = class
   private
      c:string;
      SLen,                            // Source Length
      p_i,                             // Position in input
      p_o:Integer;                     // Position in output
      o:string ;//output (result)
      //procedures and functions (sorted alphabetically)
      procedure AddChar(cr : Char; p_iAdvancement: Integer);
      procedure AddCurrentChar;
      procedure AddString(s:string; mode, p_iAdvancement: Integer);
      procedure DelChar(p_CharToDelete: Integer);
      procedure JumpToChar(cr : Char);
      procedure LogMsg(MsgCode, MsgLocation: Integer);
   public
      MsgCount : Integer; //Errors, Warnings, ...
      CriticalErrorFound : boolean; //it stops the execution
      Msg : array[0..C2PAS_MAX_ERROR] of DebugMsgStruct;
      function MsgString(MsgIndex:Integer):string;
      function Translate(Source:string):string;
   end;

implementation
uses
   SysUtils  //IntToStr
{$IFDEF WIN32}
   ,Windows  //ZeroMemory
{$ENDIF}
;
resourcestring
  rsTooManyError = 'Too many errors';
  rsSourceIsTooL = 'Source is too long';
  rsTranslationI = 'Translation is too long';
  rsExceptionInA = 'Exception in AddChar procedure';
  rsEndOfStateme = 'End of statement not found';
  rsItIsABitOper = 'It is a bit operator or a reference operator? (not yet '
    +'implemented)';
  rsCompleteTran = 'Complete translation of "return" not yet implemented ("'
    +'Exit" after "Result", and "begin".."end" if it is necessary)';
  rsHexadecimalT = 'Hexadecimal translation not yet implemented';
  rsOctalConvers = 'Octal conversion not yet implemented';
  rsCode = 'Code %s';
  rsError = '[Error] %s';
  rsWarning = '[Warning] %s';
  rsHint = '[Hint] %s';

//------------------------------------------------------------------------------
function TC2Pas.MsgString(MsgIndex: Integer): string;
var
   MsgStr:AnsiString;
begin
   case Msg[MsgIndex].Code of
      C2PAS_ERR_TOOMANY      : MsgStr := rsTooManyError;
      C2PAS_ERR_SRCTOOLONG   : MsgStr := rsSourceIsTooL;
      C2PAS_ERR_TRANSTOOLONG : MsgStr := rsTranslationI;
      C2PAS_ERR_ADDCHAR      : MsgStr := rsExceptionInA;

      C2PAS_WRN_NOEND        : MsgStr := rsEndOfStateme;
      C2PAS_WRN_REFORBIT     : MsgStr := rsItIsABitOper;
      C2PAS_WRN_RETURN       : MsgStr := rsCompleteTran;
      C2PAS_WRN_HEX          : MsgStr := rsHexadecimalT;
      C2PAS_WRN_OCTAL        : MsgStr := rsOctalConvers;

      else                     MsgStr := Format(rsCode, [IntToStr(Msg[MsgIndex
        ].Code)]);
   end;

   if Msg[MsgIndex].Code < C2PAS_ERRORS then
      MsgStr := Format(rsError, [MsgStr])
   else
   if Msg[MsgIndex].Code < C2PAS_WARNINGS then
      MsgStr := Format(rsWarning, [MsgStr])
   else                       //HINTS
      MsgStr := Format(rsHint, [MsgStr]);

   Result := MsgStr;
end;
//------------------------------------------------------------------------------
function isNonWhitespace(c:Char):boolean;
begin
   if (c = ' ') or (c = crLF) or (c = crCR) or (c = crTAB) then
      Result := false
   else
      Result := true;
end;
//------------------------------------------------------------------------------
// Add a message to the warning list
procedure TC2Pas.LogMsg(MsgCode, MsgLocation: Integer);
begin
   if MsgCount < C2PAS_MAX_ERROR then
   begin
      if MsgCode < C2PAS_ERRORS then CriticalErrorFound := true;
      Msg[MsgCount].Code := MsgCode;
      Msg[MsgCount].Location := MsgLocation;
      MsgCount := MsgCount + 1;
   end else
      Msg[C2PAS_MAX_ERROR].Code := C2PAS_ERR_TOOMANY;
end;
//------------------------------------------------------------------------------
procedure TC2Pas.DelChar(p_CharToDelete: Integer);
var
   n:integer;
begin
   if (p_CharToDelete >=0) and (p_CharToDelete<p_o) then
   begin
      // p_o is the position in the array o[], where
      // the next character will be written. So the
      // last char. written was o[p_o - 1]
      for n:=p_CharToDelete to p_o - 1 do
         o[n] := o[n + 1];
      p_o := p_o - 1;
   end;
end;
//------------------------------------------------------------------------------
procedure TC2Pas.AddChar(cr : Char; p_iAdvancement: Integer);
begin
   if not CriticalErrorFound then
   begin
      if p_o > C2PAS_MAX_OUTPUTPOS then
         LogMsg(C2PAS_ERR_TRANSTOOLONG, 0)
      else begin
         try
            o := o+cr;
            inc(p_o);
            p_i := p_i + p_iAdvancement;
         except
            LogMsg(C2PAS_ERR_ADDCHAR, p_o);
         end;
      end;
   end;
end;
//------------------------------------------------------------------------------
procedure TC2Pas.AddCurrentChar;
begin
   AddChar(c[p_i], 1);
end;
//------------------------------------------------------------------------------
procedure TC2Pas.JumpToChar(cr : Char);
begin
   while c[p_i] <> cr do
      p_i := p_i + 1;
end;
//------------------------------------------------------------------------------
procedure TC2Pas.AddString(s: string; mode, p_iAdvancement: Integer);
var
   i:Integer;
begin
   if (p_o > 0) and ((mode = asWantSpaces) or (mode = asWantLSpace)) then
      if (o[p_o-1] <> ' ') and (o[p_o-1] <> crEL) and (o[p_o-1] <> crTAB) then
         AddChar(' ', 0);
   for i := 1 to Length(s) do
      AddChar(char(s[i]), 0);
   p_i := p_i + p_iAdvancement;
   if (mode = asWantSpaces) or (mode = asWantRSpace) then
      if (c[p_i] <> ' ') and (o[p_i] <> crEL) and (o[p_i] <> crTAB) then
         AddChar(' ', 0);
end;
//------------------------------------------------------------------------------
function TC2Pas.Translate(Source: string): string;
var
   Identifier       : String;

   Found_SR_or_DT   , // "Simple replacement" or "data type" found: in the
                      // translate\identifiers section there are 3 "checks":
                      // - it is a simple replacement?
                      // - else it is a data type?
                      // - else it is a peculiar statement?
   AStringJustEnded , // detects adjacent string literals
   CaseEndExpected  ,
   IfEndExpected    ,
   IsInsideBlock    ,
   WhileEndExpected ,
   ReturnEndExpected,
   IfFor1Expected, ForEndExpected, AdditionalClosingBracket: boolean;

   LastRem_Start, LastRem_End,
   p_oTmp           ,
   IsDataType       , // index of the DataType array
   n                , // generic counter (for)
   ParCount         : Integer; // Parenthesis count.  '(' = +1   ')' = -1

begin



   try
   //==================================== Initialization
   {$IFDEF WIN32}
   ZeroMemory(@o, SizeOf(o));
   {$ELSE}
   o:='';
   {$ENDIF}
   c := source;
   p_o := 1;
   p_i := 1;
   LastRem_End := -1;
   LastRem_Start := -1;
   CriticalErrorFound := false;
   MsgCount := 0;
   ParCount := 0;
   CaseEndExpected := false;
   IfEndExpected := false;
   WhileEndExpected := false;
   AStringJustEnded := false;

   //==================================== Length check
   SLen := Length(Source);             // This avoids further calls to this function
   if SLen > C2PAS_MAX_OUTPUTPOS then  // We suppose that source and output size
   begin                               // are almost identical, but it is not the sole check...
      LogMsg(C2PAS_ERR_SRCTOOLONG, 0);
      Exit;
   end else if SLen = 0 then
      Exit;                            // No source: exit. It's ok (output = '')

   //==================================== Translate
   while(p_i < SLen) and (not CriticalErrorFound) do
   begin

      if AStringJustEnded and (c[p_i] <> ' ')  and (c[p_i] <> crCR)
      and (c[p_i] <> crLF) and (c[p_i] <> '"') then
         AStringJustEnded := false;

      case c[p_i] of
      //========================================================================
      'A'..'Z', 'a'..'z', '_':// Identifiers
      //========================================================================
      // 1) C/C++ identifiers begin with a letter (a to z and A to Z) or with an underscore character "_"
      // 2) The next characters, other than letters and "_", can be also digits 0 to 9
      // 3) C/C++ is case sensitive
      begin

         // Memorize the identifier, and move p_i at the end of it
         Identifier := '';
         while not CriticalErrorFound do
         begin
            case c[p_i] of
            'A'..'Z', 'a'..'z', '_', '0'..'9':
               begin
                  Identifier := Identifier + c[p_i];
                  p_i := p_i + 1;
                  if p_i >= SLen then
                  begin
                     LogMSG(C2PAS_WRN_NOEND, p_o);
                     AddString('{$message ''C2PAS: NoEnd?''}' + Identifier, asNoSpaces, 0);
                     break;
                  end;
               end;
            else
               //[...] this get an identifier, but it isn't enough to translate,
               // for example, unsigned char * (two words and a simbol).
               // It should continue instead of break, if it found a modifier
               // or a data type, ingoring extra spaces, so that it can assing
               // 'unsigned char*' to the Identifier variable
               break;
            end;//cases
         end;//while

         if (not CriticalErrorFound) and (p_i < SLen) then
         begin

            // Now that we have the identifier stored in the Identifier variable,
            // we should know what is it:

            // *** CHECK 1:  It is something that can be easily replaced?
            //               Examples: NULL --> nil, strcpy --> StrCopy
            //               These are temporary solutions (in our example,
            //               not always nil can replace NULL, and other things
            //               could require a more complex translation, in order
            //               to be complete)
            Found_SR_or_DT := false;
            for n:=0 to SimpleReplCount-1 do
               if Identifier = SimpleRepl[n,0] then begin
                  AddString(SimpleRepl[n,1], asNoSpaces, 0);
                  Found_SR_or_DT := true;
               end;

            // *** CHECK 2: It is a data type?
            //              While data types conversion is a simple matter
            //              (e.g. 'int' to 'Integer')...
            //              1 - ... in c/c++ these identifier can also starts
            //                  functions and procedures.
            //              2 - ... functions/procedures and parameters
            //                  declaration is quite different from Delphi.
            //              3 - ... in c++ new variables can be defined
            //                  everywhere and the translator cannot simply move
            //                  them under the var declarations...
            if not Found_SR_or_DT then begin
               for n:=0 to DataTypesCount-1 do
                  if Identifier = DataType[n,0] then begin
                     AddString(DataType[n,1], asNoSpaces, 0);
                     Found_SR_or_DT := true;
                     //[...]
                  end;
            end;

            // *** CHECK 3: It is a peculiar statement?
            //              Please, try to mantain the alphabetical order
            if not Found_SR_or_DT then

               // case
               if Identifier = 'case' then
                  p_i := p_i + 1 //e.g.: 'case 12:' -> '12:'
               else

               // default
               if Identifier = 'default' then
               begin
                  AddString('else', asWantSpaces , 0);
                  JumpToChar(':');
                  p_i := p_i + 1;
               end else

               // do
               if Identifier = 'do' then
               begin
                  //convert it to "repeat" and the following while(expression) in
                  AddString('repeat', asWantSpaces , 0);
               end;
               //until not (expression)

               // else
               if Identifier = 'else' then
               begin
                  // Make sure that there is not a ';' before the "else": if
                  // the last non-whitespace character was ';', it is removed
                  p_oTmp := p_o - 1;
                  while p_oTmp >= 0 do
                  begin
                     if (p_oTmp > LastRem_End) or (p_oTmp < LastRem_Start) then
                        if isNonWhitespace(o[p_oTmp]) then
                        begin
                           DelChar(p_oTmp);
                           p_oTmp := 0; //Exit
                        end;
                        p_oTmp := p_oTmp - 1;
                  end;//while
                  AddString('else', asWantRSpace, 0);
                  ParCount := 0;
               end else

               //[...] if Identifier = 'fopen'
               //[...] if Identifier = 'fclose'
               if Identifier = 'for' then
               begin
                //  if not IsInsideBlock then
                  AddString('while {for}'+LineEnding, asWantSpaces, 0);
                  IfFor1Expected := true;
                  ForEndExpected := true;
                  ParCount := 0;
               end else
               //[...] if Identifier = 'fwrite'
               //[...] if Identifier = 'fread'

               // if
               if Identifier = 'if' then
               begin
                  AddString('if', asWantRSpace, 0);
                  IfEndExpected := true;
                  ParCount := 0;
               end else

               //[...] if Identifier = 'open'

               // return
               if Identifier = 'return' then
               begin
                  LogMSG(C2PAS_WRN_RETURN, p_o);
                  AddString('{$message ''C2PAS: Exit''} Exit(', asNoSpaces, 0);
                  AdditionalClosingBracket := true;
               end else

               // switch
               if Identifier = 'switch' then
               begin
                  AddString('case', asWantRSpace, 0);
                  CaseEndExpected := true;
                  ParCount := 0;
               end else

               // while
               if Identifier = 'while' then
               begin
                  AddString('while', asWantRSpace, 0);
                  WhileEndExpected := true;
                  ParCount := 0;
               end else

                // rand()
               if Identifier = 'rand' then
               begin
                 AddString('random(MaxInt)', asWantRSpace, 2);
               end else
               //[...] ...

               // *** None of them: add the identifier as it is
                  AddString(Identifier, asNoSpaces, 0);
               end;

         end;
      //========================================================================
      // Symbols
      //========================================================================
      '%':
         if c[p_i + 1] = '=' then
         begin// %=
            AddString(':= '+ Identifier + ' mod (', asWantSpaces, 2);
            AdditionalClosingBracket := true;
         end else
            AddString('mod', asWantSpaces, 1);
      '=':
         if c[p_i + 1] = '=' then
            AddChar('=', 2)
         else
            // [...] result-Value-Transfer for double assignment (a=b=0)
            AddString(':=', asWantSpaces, 1);
      '!':
         if c[p_i + 1] = '=' then
            AddString('<>', asWantSpaces, 2)
         else
            AddString('not', asWantSpaces, 1);
      '&':
         if c[p_i + 1]='&' then
            AddString('and', asWantSpaces, 2)
         else if not (c[p_i + 1]='=') and
           not (CharInSet(c[p_i + 1], ['_','A'..'Z','a'..'z']))  then
            AddString('and', asWantSpaces, 1)
         else if c[p_i + 1] = '=' then
         begin// &=
           AddString(':= '+ Identifier + ' and (', asWantSpaces, 2);
           AdditionalClosingBracket := true;
          end
         else begin
            // [...] Referencing operator (&pluto)?
            LogMsg(C2PAS_WRN_REFORBIT, p_o);
            AddString('{$message ''C2PAS: Ref''}@', asNoSpaces, 1);
         end;
      '|':
         if c[p_i + 1] = '|' then
            AddString('or', asWantSpaces, 2)
         else if c[p_i + 1] = '=' then
            begin// |=
               AddString(':= '+ Identifier + ' or (', asWantSpaces, 2);
               AdditionalClosingBracket := true;
            end
         else
            AddString('or', asWantSpaces, 1);
      '-': // -> Indirect member selector
         if c[p_i + 1] = '>' then
            AddChar('.', 2)
         else if c[p_i + 1] = '=' then
            begin// -=
               AddString(':= '+ Identifier + ' - (', asWantSpaces, 2);
               AdditionalClosingBracket := true;
            end
         else
            AddCurrentChar;
      '+': if c[p_i + 1] = '=' then
            begin// +=
               AddString(':= '+ Identifier + ' + (', asWantSpaces, 2);
               AdditionalClosingBracket := true;
            end
         else
            AddCurrentChar;
      ':': // :: Scope resolution operator
         if c[p_i + 1] = ':' then
            AddChar('.', 2) //[...] not good for ::identifier
         else
            AddCurrentChar;
      ']': // ][ Array "sub-element" separator
         if c[p_i + 1] = '[' then //[...] there could be some spaces between ] and [
            AddChar(',', 2) //[...] not always true. For example: if you have
                            // s: array [0..10] of String, and you want to access
                            // to the character 2 of the string 7, you write
                            // s[7][2], not s[7,2] (of course in this case Delphi
                            // reports an error).
         else
            AddCurrentChar;
      '>': // Bit-shift- operator
         if c[p_i + 1] = '>' then
            AddString('{$message ''C2PAS: >>-op''}shr',asWantSpaces, 2)
         else if c[p_i + 1] = '=' then
            AddString('>=',asWantSpaces, 2)
         else
            AddCurrentChar;
      '<': // Bit-shift- operator
         if c[p_i + 1] = '<' then
             AddString('{$message ''C2PAS: <<-op''}shl',asWantSpaces, 2)
         else if c[p_i + 1] = '=' then
            AddString('<=',asWantSpaces, 2)
         else
            AddCurrentChar;
      //[...] Other symbols

      //========================================================================
      // Parenthesis and end of statements (case..of, if..then, while..do)
      //========================================================================
      '(':
      begin
         ParCount := ParCount + 1;
         AddCurrentChar;
         if c[p_i+1] ='*' then
            AddChar(' ',0);
      end;
      ')':
      begin
         ParCount := ParCount - 1;
         AddCurrentChar;
         if ParCount = 0 then begin
            if CaseEndExpected then begin
               AddString('of'+LineEnding, asWantSpaces, 0);
               CaseEndExpected := false;
            end else
            if IfEndExpected then begin
               AddString('then'+LineEnding, asWantSpaces, 0);
               IfEndExpected := false;
            end else
            if WhileEndExpected then begin
               AddString('do'+LineEnding, asWantSpaces, 0);
               WhileEndExpected := false;
            end else
            if ForEndExpected then begin
               AddString('do begin'+LineEnding, asWantSpaces, 0);
               ForEndExpected := false;
         end;
      end;
      //========================================================================
      //'#':// Preprocessor
      //========================================================================
      // [...]# (null directive) - ignored
      // [...]#define   {$define ..} can also be converted to "const ..." when
      //                the replaced value is a single number;
      // [...]#elif     {$ELSE}{$IF ...} ... {$ENDIF}{$ENDIF}
      // [...]#else     {$ELSE}
      // [...]#endif    {$ENDIF}
      // [...]#error    stops the compile  {$error }
      // [...]#if       {$IF ... [add an "}" at the end]
      // [...]#ifdef    {$IFDEF ... [add an "}" at the end]
      // [...]#ifndef   {$IFNDEF ... [add an "}" at the end]
      // [...]#include  uses. But if the first non-whitespace character
      //                following #include is neither < nor ", there is a marco.
      // [...]#line     "is primarily used by utilities that produce C code as
      //                output, and not in human-written code"...
      // [...]#pragma   Various directives...
      // [...]#undef    {$UNDEF ... [add an "}" at the end]
      //========================================================================
      end;

      '/':// Remark or division
      //========================================================================
      begin
         if p_i < SLen then
            if c[p_i + 1] = '/' then begin

               // It is a //... remark: search for line-feed character
               LastRem_Start := p_o + 1;
               while(c[p_i] <> crEL) and (not CriticalErrorFound) do
                  AddCurrentChar;
               LastRem_End := p_o;

            end else if c[p_i + 1] = '*' then begin

               // It is a /* ... */ remark: search for the */
               LastRem_Start := p_o + 1;
               AddChar('(',1);
               AddChar('*',1);
               while(not CriticalErrorFound) do begin
                  if c[p_i] = '*' then begin
                     if c[p_i + 1] = '/' then begin
                        AddCurrentChar; // '*'
                        AddChar(')',1);
                        break;
                     end else
                        AddCurrentChar;
                  end else
                     AddCurrentChar;
               end;//while
               LastRem_End := p_o;

            end else

               // It is a division
               AddCurrentChar;

      end;//case '/'
      //========================================================================
      '"':// String
      //========================================================================
      begin

         // In C++Builder, if adjacent string literals are separated only by
         // whitespace, they are concatenated during the parsing phase.
         if AStringJustEnded then
            AddString('+' + apo, asNoSpaces, 1) // concatenate adjacent strings
         else
            AddChar(apo, 1);

         while(not CriticalErrorFound) do begin

            // *** ESCAPE SEQUENCES ***
            // Special and nongraphic characters, that are
            // used in C strings. N.B.: they are case sensitive.
            if(c[p_i] = '\') then begin
               case c[p_i + 1] of
               '0'..'9': //character code
                  begin
                     AddString(apo + '#', asNoSpaces, 1);
                     //searches for the end of the code
                     while (c[p_i] >= '0')
                     and   (c[p_i] <= '9') do
                        AddCurrentChar;
                     AddChar(apo, 0);
                  end;
               'a': AddString(StrCrBEL, asNoSpaces, 2);
               'b': AddString(StrCrBS, asNoSpaces, 2);
               'f': AddString(StrCrFF, asNoSpaces, 2);
               'n': AddString(StrCrLF, asNoSpaces, 2);
               'r': AddString(StrCrCR, asNoSpaces, 2);
               't': AddString(StrCrHT, asNoSpaces, 2);
               'v': AddString(StrCrVT, asNoSpaces, 2);
               '\': AddChar('\', 2);
               apo: AddString(apo + apo, asNoSpaces, 2);
               '"': AddChar('"', 2);
               '?': AddChar('?', 2);
               'x', 'X': // string of hex digits
                  begin
                     // "The first nonhexadecimal character encountered in an
                     // hexadecimal escape sequence marks the end of the
                     // sequence." From - Using C++Builder
                     LogMSG(C2PAS_WRN_HEX, p_o);
                     AddString(''' + {$Hint ''C2PAS: Hex''} #$', asNoSpaces, 2) //[...] to do (quite easy)
                  end;
               'O': // string of up to three octal digits
                  begin
                     // Similar to hexadecimal escape sequences, but Object
                     // Pascal doesn't have octals (at least not in Delphi 5),
                     // so we must convert the value in decimal or hexadecimal
                     LogMSG(C2PAS_WRN_OCTAL, p_o);
                     AddString(''' + {$Message ''C2PAS: Octal''} ''', asNoSpaces, 2) //[...] disabled for now
                  end;
               else
                  // In other cases \ is ignored. Backslash can be used as
                  // continuation character
                  AddCurrentChar;
               end;
            end else

            // *** APOSTROPHE ***
            // ' --> ''
            if(c[p_i] = apo) then begin
               AddString(apo + apo, asNoSpaces, 1);
            end else

            // *** END OF THE STRING ***
            if(c[p_i] = '"') then begin
               AddChar('''',1);
               break; // end of sting reached
            end else

            // *** OTHER CHARACTERS ***
               AddCurrentChar;

         end;//while
         AStringJustEnded := true;

      end;//case '"'
      ';': begin
         if AdditionalClosingBracket then
            begin
               AddString(')', asWantLSpace, 0);
               AdditionalClosingBracket:=false;
            end;
         AddString(';'+LineEnding, asWantLSpace, 1);
      end;
      //========================================================================
      // begin .. end (compound statement)
      //========================================================================
      '{'://[...] Handling of preinitialisation-data
         begin
           AddString('begin'+LineEnding, asWantSpaces, 1);
           // Push IsInsideBlock
           IsInsideBlock:=true;;
         end;

      '}'://[...] Handling of preinitialisation-data
         begin
            if AdditionalClosingBracket then
               begin
                  AddString(')', asWantSpaces, 0);
                  AdditionalClosingBracket:=false;
               end;
            AddString('end;'+LineEnding, asWantSpaces, 1);
            IsInsideblock:= false;
            // Pop IsInsideBlock;
         end
      //========================================================================
      else// Other stuff
      //========================================================================
         AddCurrentChar;
      end;
   end;
    Result := o;
   except
      LogMsg(C2PAS_ERR_EXCEPTION, 0);
   end;

end;

end.



