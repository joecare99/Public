{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}

{   System independent GRAPHICAL clone of HISTLIST.PAS     }

{   Interface Copyright (c) 1992 Borland International     }

{   Copyright (c) 1996, 1997, 1998, 1999 by Leon de Boer   }
{   ldeboer@attglobal.net  - primary e-mail address        }
{   ldeboer@starwon.com.au - backup e-mail address         }

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
{  1.00     11 Nov 96   First DOS/DPMI platform release.   }
{  1.10     13 Jul 97   Windows platform code added.       }
{  1.20     29 Aug 97   Platform.inc sort added.           }
{  1.30     13 Oct 97   Delphi 2 32 bit code added.        }
{  1.40     05 May 98   Virtual pascal 2.0 code added.     }
{  1.50     30 Sep 99   Complete recheck preformed         }
{  1.51     03 Nov 99   FPC windows support added          }
{**********************************************************}

unit HistList;

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

uses Objects;                                 { Standard GFV units }

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
procedure InitHistory;

{-DoneHistory--------------------------------------------------------
Destroys the history system usually called from Application.Done
30Sep99 LdB
---------------------------------------------------------------------}
procedure DoneHistory;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          HISTORY ITEM ROUTINES                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-HistoryCount-------------------------------------------------------
Returns the number of strings in the history list with ID number Id.
30Sep99 LdB
---------------------------------------------------------------------}
function HistoryCount(Id: byte): word;

{-HistoryStr---------------------------------------------------------
Returns the Index'th string in the history list with ID number Id.
30Sep99 LdB
---------------------------------------------------------------------}
function HistoryStr(Id: byte; Index: Sw_Integer): string;

{-ClearHistory-------------------------------------------------------
Removes all strings from all history lists.
30Sep99 LdB
---------------------------------------------------------------------}
procedure ClearHistory;

{-HistoryAdd---------------------------------------------------------
Adds the string Str to the history list indicated by Id.
30Sep99 LdB
---------------------------------------------------------------------}
procedure HistoryAdd(Id: byte; const Str: string);

function HistoryRemove(Id: byte; Index: Sw_Integer): boolean;

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
procedure LoadHistory(var S: TStream);

{-StoreHistory--------------------------------------------------------
Writes the currently used portion of the history block to the stream
S, first writing the length of the block then the block itself. Use
the LoadHistory procedure to restore the history block.
30Sep99 LdB
---------------------------------------------------------------------}
procedure StoreHistory(var S: TStream);

{***************************************************************************}
{                        INITIALIZED PUBLIC VARIABLES                       }
{***************************************************************************}
{---------------------------------------------------------------------------}
{                 INITIALIZED DOS/DPMI/WIN/NT/OS2 VARIABLES                 }
{---------------------------------------------------------------------------}
const
  HistorySize: sw_integer = 64 * 1024;                    { Maximum history size }
  HistoryUsed: sw_integer = 0;                          { History used }
  HistoryBlock: Pointer = nil;                       { Storage block }

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
implementation

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

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
var
  CurId: byte;                                       { Current history id }
  CurString: PString;                                { Current string }

{***************************************************************************}
{                          PRIVATE UNIT ROUTINES                            }
{***************************************************************************}

{---------------------------------------------------------------------------}
{  StartId -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB           }
{---------------------------------------------------------------------------}
procedure StartId(Id: byte);
begin
  CurId := Id;                                       { Set current id }
  CurString := HistoryBlock;                         { Set current string }
end;

{---------------------------------------------------------------------------}
{  DeleteString -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
procedure DeleteString;
var
  Len: Sw_Integer;
  P, P2: PChar;
begin
  P := PChar(CurString);                             { Current string }
  P2 := PChar(CurString);                            { Current string }
  Len := PByte(P2)^ + 3;                               { Length of data }
  Dec(P, 2);                                         { Correct position }
  Inc(P2, PByte(P2)^ + 1);                             { Next hist record }
  { Shuffle history }
  Move(P2^, P^, Pointer(HistoryBlock) + HistoryUsed - Pointer(P2));
  Dec(HistoryUsed, Len);                             { Adjust history used }
end;

{---------------------------------------------------------------------------}
{  AdvanceStringPtr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB  }
{---------------------------------------------------------------------------}
procedure AdvanceStringPtr;
var
  P: PChar;
begin
  while (CurString <> nil) do
  begin
    if (Pointer(CurString) >= Pointer(HistoryBlock) + HistoryUsed) then
    begin{ Last string check }
      CurString := nil;                              { Clear current string }
      Exit;                                          { Now exit }
    end;
    Inc(PChar(CurString), PByte(CurString)^ + 1);      { Move to next string }
    if (Pointer(CurString) >= Pointer(HistoryBlock) + HistoryUsed) then
    begin{ Last string check }
      CurString := nil;                              { Clear current string }
      Exit;                                          { Now exit }
    end;
    P := PChar(CurString);                        { Transfer record ptr }
    Inc(PChar(CurString), 2);                        { Move to string }
    if (P^ <> #0) then
      RunError(215);
    Inc(P);
    if (P^ = Chr(CurId)) then
      Exit;                    { Found the string }
  end;
end;

{---------------------------------------------------------------------------}
{  InsertString -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
procedure InsertString(Id: byte; const Str: string);
var
  P, P1, P2: PChar;
begin
  while (HistoryUsed + Length(Str) + 3 > HistorySize) do
  begin
    P := PChar(HistoryBlock);
    while Pointer(P) < Pointer(HistoryBlock) + HistorySize do
    begin
      if Pointer(P) + Length(PShortString(P + 2)^) + 6 + Length(Str) >
        Pointer(HistoryBlock) + HistorySize then
      begin
        Dec(HistoryUsed, Length(PShortString(P + 2)^) + 3);
        FillChar(P^, Pointer(HistoryBlock) + HistorySize - Pointer(P), #0);
        break;
      end;
      Inc(P, Length(PShortString(P + 2)^) + 3);
    end;
  end;
  P1 := PChar(HistoryBlock) + 1;                     { First history record }
  P2 := P1 + Length(Str) + 3;                          { History record after }
  Move(P1^, P2^, HistoryUsed - 1);                 { Shuffle history data }
  P1^ := #0;                         { Set marker byte }
  Inc(P1);
  P1^ := Chr(Id);                          { Set history id }
  Inc(P1);
  Move(Str[1], P1^, Length(Str) + 1);  { Set history string }
  Inc(HistoryUsed, Length(Str) + 3);                 { Inc history used }
end;

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
begin
  if HistorySize > 0 then
    GetMem(HistoryBlock, HistorySize);                 { Allocate block }
  ClearHistory;                                      { Clear the history }
end;

{---------------------------------------------------------------------------}
{  DoneHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB       }
{---------------------------------------------------------------------------}
procedure DoneHistory;
begin
  if (HistoryBlock <> nil) then                      { History block valid }
  begin
    FreeMem(HistoryBlock);              { Release history block }
    HistoryBlock := nil;
  end;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          HISTORY ITEM ROUTINES                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  HistoryCount -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
function HistoryCount(Id: byte): word;
var
  Count: word;
begin
  StartId(Id);                                       { Set to first record }
  Count := 0;                                        { Clear count }
  if (HistoryBlock <> nil) then
  begin                { History initalized }
    AdvanceStringPtr;                                { Move to first string }
    while (CurString <> nil) do
    begin
      Inc(Count);                                    { Add one to count }
      AdvanceStringPtr;                              { Move to next string }
    end;
  end;
  HistoryCount := Count;                              { Return history count }
end;

{---------------------------------------------------------------------------}
{  HistoryStr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB        }
{---------------------------------------------------------------------------}
function HistoryStr(Id: byte; Index: Sw_Integer): string;
var
  I: Sw_Integer;
begin
  StartId(Id);                                       { Set to first record }
  if (HistoryBlock <> nil) then
  begin                { History initalized }
    for I := 0 to Index do
      AdvanceStringPtr;         { Find indexed string }
    if (CurString <> nil) then
      HistoryStr := CurString^
    else                  { Return string }
      HistoryStr := '';                              { Index not found }
  end
  else
    HistoryStr := '';                         { History uninitialized }
end;

{---------------------------------------------------------------------------}
{  ClearHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
procedure ClearHistory;
begin
  if (HistoryBlock <> nil) then
  begin                { History initiated }
    PChar(HistoryBlock)^ := #0;                      { Clear first byte }
    HistoryUsed := 1;        { Set position }
  end;
end;

{---------------------------------------------------------------------------}
{  HistoryAdd -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB        }
{---------------------------------------------------------------------------}
procedure HistoryAdd(Id: byte; const Str: string);
begin
  if (Str = '') then
    Exit;                           { Empty string exit }
  if (HistoryBlock = nil) then
    Exit;                 { History uninitialized }
  StartId(Id);                                       { Set current data }
  AdvanceStringPtr;                                  { Find the string }
  while (CurString <> nil) do
  begin
    if (Str = CurString^) then
      DeleteString;         { Delete duplicates }
    AdvanceStringPtr;                                { Find next string }
  end;
  InsertString(Id, Str);                             { Add new history item }
end;

function HistoryRemove(Id: byte; Index: Sw_Integer): boolean;
var
  I: Sw_Integer;
begin
  StartId(Id);
  for I := 0 to Index do
    AdvanceStringPtr;                                  { Find the string }
  if CurString <> nil then
  begin
    DeleteString;
    HistoryRemove := True;
  end
  else
    HistoryRemove := False;
end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{              HISTORY STREAM STORAGE AND RETREIVAL ROUTINES                }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  LoadHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB       }
{---------------------------------------------------------------------------}
procedure LoadHistory(var S: TStream);
var
  Size: sw_integer;
begin
  S.Read(Size, sizeof(Size));                        { Read history size }
  if (HistoryBlock <> nil) then
  begin                { History initialized }
    if (Size <= HistorySize) then
    begin
      S.Read(HistoryBlock^, Size);                   { Read the history }
      HistoryUsed := Size;                           { History used }
    end
    else
      S.Seek(S.GetPos + Size);                { Move stream position }
  end
  else
    S.Seek(S.GetPos + Size);                  { Move stream position }
end;

{---------------------------------------------------------------------------}
{  StoreHistory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
procedure StoreHistory(var S: TStream);
var
  Size: sw_integer;
begin
  if (HistoryBlock = nil) then
    Size := 0
  else        { No history data }
    Size := HistoryUsed;                             { Size of history data }
  S.Write(Size, sizeof(Size));                       { Write history size }
  if (Size > 0) then
    S.Write(HistoryBlock^, Size);   { Write history data }
end;

end.
