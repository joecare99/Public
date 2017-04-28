{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}
{                                                          }
{   System independent GRAPHICAL clone of HISTLIST.PAS     }
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
{  1.00     11 Nov 96   First DOS/DPMI platform release.   }
{  1.10     13 Jul 97   Windows platform code added.       }
{  1.20     29 Aug 97   Platform.inc sort added.           }
{  1.30     13 Oct 97   Delphi 2 32 bit code added.        }
{  1.40     05 May 98   Virtual pascal 2.0 code added.     }
{  1.50     30 Sep 99   Complete recheck preformed         }
{  1.51     03 Nov 99   FPC windows support added          }
{**********************************************************}

UNIT fv2histlist;

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

USES FV2Common, classes;                                 { Standard GFV units }

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     HISTORY SYSTEM CONTROL ROUTINES                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-InitHistory--------------------------------------------------------
Initializes the history system usually called from Application.Init
30Sep99 LdB
---------------------------------------------------------------------}
PROCEDURE InitHistory;

{-DoneHistory--------------------------------------------------------
Destroys the history system usually called from Application.Done
30Sep99 LdB
---------------------------------------------------------------------}
PROCEDURE DoneHistory;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          HISTORY ITEM ROUTINES                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-HistoryCount-------------------------------------------------------
Returns the number of strings in the history list with ID number Id.
30Sep99 LdB
---------------------------------------------------------------------}
FUNCTION HistoryCount (Id: integer): Integer;

{-HistoryStr---------------------------------------------------------
Returns the Index'th string in the history list with ID number Id.
30Sep99 LdB
---------------------------------------------------------------------}
FUNCTION HistoryStr (Id: integer; Index: Sw_Integer): String;

{-HistoryList---------------------------------------------------------
Fills the List with strings of the history by ID.
04Apr16 JC99
---------------------------------------------------------------------}
Procedure HistoryList (Id: integer; const str: TStrings);

{-ClearHistory-------------------------------------------------------
Removes all strings from all history lists.
30Sep99 LdB
---------------------------------------------------------------------}
PROCEDURE ClearHistory;

{-HistoryAdd---------------------------------------------------------
Adds the string Str to the history list indicated by Id.
30Sep99 LdB
---------------------------------------------------------------------}
function HistoryAdd (Id: integer; Const Str: String):Sw_Integer;

function HistoryRemove(Id: integer; Index: Sw_Integer): boolean;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{              HISTORY STREAM STORAGE AND RETREIVAL ROUTINES                }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-LoadHistory--------------------------------------------------------
Reads the application's history block from the stream S by reading the
size of the block, then the block itself. Sets HistoryUsed to the end
of the block read. Use LoadHistory to restore a history block saved
with StoreHistory
30Sep99 LdB
---------------------------------------------------------------------}
PROCEDURE LoadHistory (Var S: TStream);

{-StoreHistory--------------------------------------------------------
Writes the currently used portion of the history block to the stream
S, first writing the length of the block then the block itself. Use
the LoadHistory procedure to restore the history block.
30Sep99 LdB
---------------------------------------------------------------------}
PROCEDURE StoreHistory (Var S: TStream);

{***************************************************************************}
{                        INITIALIZED PUBLIC VARIABLES                       }
{***************************************************************************}
{---------------------------------------------------------------------------}
{                 INITIALIZED DOS/DPMI/WIN/NT/OS2 VARIABLES                 }
{---------------------------------------------------------------------------}
CONST
   HistorySize: sw_integer = 64*1024;                    { Maximum history size }
var
   HistoryUsed: sw_integer = 0;                          { History used }

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
type
  THistoryEntry=record
    id:integer;
    s:String;
  end;

{***************************************************************************}
{                      PRIVATE RECORD DEFINITIONS                           }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                       THistRec RECORD DEFINITION

   Zero  1 byte, start marker
   Id    1 byte, History id
   <shortstring>   1 byte length+string data, Contents
}

{***************************************************************************}
{                      UNINITIALIZED PRIVATE VARIABLES                      }
{***************************************************************************}
{---------------------------------------------------------------------------}
{                UNINITIALIZED DOS/DPMI/WIN/NT/OS2 VARIABLES                }
{---------------------------------------------------------------------------}
VAR
   CurrHistory: array of THistoryEntry;

{***************************************************************************}
{                          PRIVATE UNIT ROUTINES                            }
{***************************************************************************}

{---------------------------------------------------------------------------}
{  DeleteString -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
PROCEDURE DeleteString(CurIdx:integer);
VAR
  i: Integer;
BEGIN
   if (CurIdx >=0) and (CurIdx<= high(CurrHistory)) then
     begin
       for i := CurIdx to high(CurrHistory)-1 do
         CurrHistory[i] := CurrHistory[i+1];
       setlength(CurrHistory,high(CurrHistory));
     end;
END;
(* obsolete
{---------------------------------------------------------------------------}
{  AdvanceStringPtr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB  }
{---------------------------------------------------------------------------}
PROCEDURE AdvanceStringPtr;
VAR P: PChar;
BEGIN
   While (CurString <> Nil) Do Begin
     If (Pointer(CurString) >= Pointer(HistoryBlock) + HistoryUsed) Then Begin{ Last string check }
       CurString := Nil;                              { Clear current string }
       Exit;                                          { Now exit }
     End;
     Inc(PChar(CurString), PByte(CurString)^+1);      { Move to next string }
     If (Pointer(CurString) >= Pointer(HistoryBlock) + HistoryUsed) Then Begin{ Last string check }
       CurString := Nil;                              { Clear current string }
       Exit;                                          { Now exit }
     End;
     P := PChar(CurString);                        { Transfer record ptr }
     Inc(PChar(CurString), 2);                        { Move to string }
     if (P^<>#0) then
       RunError(215);
     Inc(P);
     If (P^ = Chr(CurId)) Then Exit;                    { Found the string }
   End;
END;       *)

{---------------------------------------------------------------------------}
{  InsertString -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
PROCEDURE InsertString (Id: integer; Const Str: String);
VAR P1, P2: PChar;
  i: Integer;
BEGIN
  while (HistoryUsed+Length(Str)>HistorySize) do
   begin
// Delete elements until new entry fits.
     HistoryUsed := HistoryUsed -length(CurrHistory[high(CurrHistory)].s);
     if HistoryUsed+Length(Str)>HistorySize then
       setlength(CurrHistory,high(CurrHistory));
   end;
  for i := high(CurrHistory)-1 downto 0 do
    CurrHistory[i+1] := CurrHistory[i];      { Shuffle history data }
  CurrHistory[0].id :=id;
  CurrHistory[0].s :=str;
  Inc(HistoryUsed, Length(Str));                 { Inc history used }
END;

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     HISTORY SYSTEM CONTROL ROUTINES                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  InitHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB       }
{---------------------------------------------------------------------------}
procedure InitHistory;
BEGIN
   ClearHistory;                                      { Clear the history }
END;

{---------------------------------------------------------------------------}
{  DoneHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB       }
{---------------------------------------------------------------------------}
procedure DoneHistory;
BEGIN
  setlength(CurrHistory,0);
  HistoryUsed:=0;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          HISTORY ITEM ROUTINES                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  HistoryCount -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
function HistoryCount(Id: integer): Integer;
VAR Count: Word;
  e: THistoryEntry;
BEGIN
   Count := 0;                                        { Clear count }
   for e in CurrHistory do
     if e.id= id then
       Inc(Count);                                    { Add one to count }
  result := Count;                              { Return history count }
END;

{---------------------------------------------------------------------------}
{  HistoryStr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB        }
{---------------------------------------------------------------------------}
function HistoryStr(Id: integer; Index: Sw_Integer): String;
VAR count: Sw_Integer;
  e: THistoryEntry;
BEGIN
  Count := 0;                                        { Clear count }
  for e in CurrHistory do
    if (e.id= id) and (count < index) then
       inc(count)
    else if e.id= id then
      exit(e.s);
  result := '';
END;

procedure HistoryList(Id: integer; const str: TStrings);
var
  e: THistoryEntry;
begin
  str.Clear;
  for e in CurrHistory do
    if (e.id= id)  then
      str.Add(e.s);
end;

{---------------------------------------------------------------------------}
{  ClearHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
procedure ClearHistory;
BEGIN
  setlength(CurrHistory,0);
  HistoryUsed := 0;        { Set position }
END;

{---------------------------------------------------------------------------}
{  HistoryAdd -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB        }
{---------------------------------------------------------------------------}
function HistoryAdd(Id: integer; const Str: String): Sw_Integer;
var
  i, J: Integer;
BEGIN
   result := -1;
   If (Str = '') Then Exit;                           { Empty string exit }
   for i := 0 to high(CurrHistory) do
     if (CurrHistory[i].id = ID) and (CurrHistory[i].s = Str) then
       begin
         for J :=  i-1 downto 0do
           CurrHistory[J+1]:= CurrHistory[J];
         CurrHistory[0].id:=id;
         CurrHistory[0].s:=str;
         exit(id)
       end;
   InsertString(Id, Str);                             { Add new history item }
   result := id;
END;

function HistoryRemove(Id: integer; Index: Sw_Integer): boolean;
var
  I: Sw_Integer;
  count: Integer;
begin
  count:=0;
  result := false;
  for i := 0 to high(CurrHistory) do
    if (CurrHistory[i].id = ID) and (count=index) then
      begin
      DeleteString(I);
      result := true;
      end
    else
      if (CurrHistory[i].id = ID) then
        inc(count);
end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{              HISTORY STREAM STORAGE AND RETREIVAL ROUTINES                }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  LoadHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB       }
{---------------------------------------------------------------------------}
procedure LoadHistory(var S: TStream);
VAR Size: sw_integer;
  i: Integer;
BEGIN
   Size := S.ReadDWord;                        { Read history size }
   setlength(CurrHistory,Size);
   for i := 0 to size do
     begin
       CurrHistory[i].id:=s.ReadDWord;
       CurrHistory[i].s:=s.ReadAnsiString;
     End;                                  { Move stream position }
END;

{---------------------------------------------------------------------------}
{  StoreHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
procedure StoreHistory(var S: TStream);
VAR i: integer;
BEGIN
   S.WriteDWord(length(CurrHistory));                       { Write history size }
   for i := 0 to high(CurrHistory) do
     begin
       S.WriteDWord(cardinal(CurrHistory[i].id));
       s.WriteAnsiString(CurrHistory[i].s);
     End;
END;

END.
