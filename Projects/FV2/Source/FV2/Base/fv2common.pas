{********************[ COMMON UNIT ]***********************}
{                                                          }
{    System independent COMMON TYPES & DEFINITIONS         }
{                                                          }
{    Parts Copyright (c) 1997 by Balazs Scheidler          }
{    bazsi@balabit.hu                                      }
{                                                          }
{    Parts Copyright (c) 1999, 2000 by Leon de Boer        }
{    ldeboer@attglobal.net  - primary e-mail address       }
{    ldeboer@projectent.com.au - backup e-mail address     }
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
{                 - Speed Pascal 1.0+       (32 Bit)       }
{                 - C'T patch to BP         (16 Bit)       }
{                                                          }
{******************[ REVISION HISTORY ]********************}
{  Version  Date      Who    Fix                           }
{  -------  --------  ---    ----------------------------  }
{  0.1     12 Jul 97  Bazsi  Initial implementation        }
{  0.2     18 Jul 97  Bazsi  Linux specific error codes    }
{  0.2.2   28 Jul 97  Bazsi  Base error code for Video     }
{  0.2.3   29 Jul 97  Bazsi  Basic types added (PByte etc) }
{  0.2.5   08 Aug 97  Bazsi  Error handling code added     }
{  0.2.6   06 Sep 97  Bazsi  Base code for keyboard        }
{  0.2.7   06 Nov 97  Bazsi  Base error code for filectrl  }
{  0.2.8   21 Jan 99  LdB    Max data sizes added.         }
{  0.2.9   22 Jan 99  LdB    General array types added.    }
{  0.3.0   27 Oct 99  LdB    Delphi3+ MaxAvail, MemAvail   }
{  0.4.0   14 Nov 00  LdB    Revamp of whole unit          }
{**********************************************************}

UNIT fv2common;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                  INTERFACE
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}
                                  {$Modeswitch result+}

{$ifdef OS_WINDOWS}
//  uses
//    Windows;
{$endif}

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        SYSTEM ERROR BASE CONSTANTS                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  The following ranges have been defined for error codes:                  }
{---------------------------------------------------------------------------}
{        0 -  1000    OS dependant error codes                              }
{     1000 - 10000    API reserved error codes                              }
{    10000 -          Add-On unit error codes                               }
{---------------------------------------------------------------------------}

{---------------------------------------------------------------------------}
{                         DEFINED BASE ERROR CONSTANTS                      }
{---------------------------------------------------------------------------}
CONST
   errOk                = 0;                          { No error }
   errVioBase           = 1000;                       { Video base offset }
   errKbdBase           = 1010;                       { Keyboard base offset }
   errFileCtrlBase      = 1020;                       { File IO base offset }
   errMouseBase         = 1030;                       { Mouse base offset }

{---------------------------------------------------------------------------}
{                            MAXIUM DATA SIZES                              }
{---------------------------------------------------------------------------}
CONST
{$IFDEF BIT_16}                                       { 16 BIT DEFINITION }
   MaxBytes = 65520;                                  { Maximum data size }
{$ENDIF}
{$IFDEF BIT_32_OR_MORE}                                       { 32 BIT DEFINITION }
   _MaxBytes = 128*1024*1024;                          { Maximum data size }
   MaxBytes = _MaxBytes  deprecated 'Try a Dynamic approach';                          { Maximum data size }
{$ENDIF}
   MaxWords = _MaxBytes DIV SizeOf(Word) deprecated 'Try a Dynamic approach';              { Max words }
   MaxInts  = _MaxBytes DIV SizeOf(Integer)deprecated 'Try a Dynamic approach';           { Max integers }
   MaxLongs = _MaxBytes DIV SizeOf(LongInt)deprecated 'Try a Dynamic approach';           { Max longints }
   MaxPtrs  = _MaxBytes DIV SizeOf(Pointer)deprecated 'Try a Dynamic approach';           { Max pointers }
   MaxReals = _MaxBytes DIV SizeOf(Real)deprecated 'Try a Dynamic approach';              { Max reals }
   MaxStr   = _MaxBytes DIV SizeOf(String)deprecated 'Try a Dynamic approach';            { Max strings }

{***************************************************************************}
{                          PUBLIC TYPE DEFINITIONS                          }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                           CPU TYPE DEFINITIONS                            }
{---------------------------------------------------------------------------}
TYPE
{$IFDEF BIT_32_OR_MORE}                               { 32 BIT CODE }
   CPUWord = Longint;                                 { CPUWord is 32 bit }
   CPUInt = Longint;                                  { CPUInt is 32 bit }
{$ELSE}                                               { 16 BIT CODE }
   CPUWord = Word;                                    { CPUWord is 16 bit }
   CPUInt = Integer;                                  { CPUInt is 16 bit }
{$ENDIF}

{---------------------------------------------------------------------------}
{                     16/32 BIT SWITCHED TYPE CONSTANTS                     }
{---------------------------------------------------------------------------}
TYPE
{$IFDEF BIT_16}                                       { 16 BIT DEFINITIONS }
   Sw_Word    = Word;                                 { Standard word }
   Sw_Integer = Integer;                              { Standard integer }
{$ENDIF}
{$IFDEF BIT_32_OR_MORE}                               { 32 BIT DEFINITIONS }
   Sw_Word    = Cardinal;                             { Long integer now }
   Sw_Integer = LongInt;                              { Long integer now }
{$ENDIF}

{---------------------------------------------------------------------------}
{                               GENERAL ARRAYS                              }
{---------------------------------------------------------------------------}
TYPE
   TByteArray = ARRAY [0..MaxBytes{%H-}-1] Of Byte;        { Byte array }
   PByteArray = ^TByteArray deprecated 'Try a Dynamic approach';                          { Byte array pointer }

   TWordArray = ARRAY [0..MaxWords{%H-}-1] Of Word;        { Word array }
   PWordArray = ^TWordArray deprecated 'Try a Dynamic approach';                          { Word array pointer }

   TIntegerArray = ARRAY [0..MaxInts{%H-}-1] Of Integer;   { Integer array }
   PIntegerArray = ^TIntegerArray deprecated 'Try a Dynamic approach';                    { Integer array pointer }

   TLongIntArray = ARRAY [0..MaxLongs{%H-}-1] Of LongInt;  { LongInt array }
   PLongIntArray = ^TLongIntArray deprecated 'Try a Dynamic approach';                    { LongInt array pointer }

   TRealArray = Array [0..MaxReals{%H-}-1] Of Real;        { Real array }
   PRealarray = ^TRealArray deprecated 'Try a Dynamic approach';                          { Real array pointer }

   TPointerArray = Array [0..MaxPtrs{%H-}-1] Of Pointer;   { Pointer array }
   PPointerArray = ^TPointerArray deprecated 'Try a Dynamic approach';                    { Pointer array ptr }

   TStrArray = Array [0..MaxStr{%H-}-1] Of String;         { String array }
   PStrArray = ^TStrArray;                            { String array ptr }

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{-GetErrorCode-------------------------------------------------------
Returns the last error code and resets ErrorCode to errOk.
07/12/97 Bazsi
---------------------------------------------------------------------}
FUNCTION GetErrorCode: LongInt;

{-GetErrorInfo-------------------------------------------------------
Returns the info assigned to the previous error, doesn't reset the
value to nil. Would usually only be called if ErrorCode <> errOk.
07/12/97 Bazsi
---------------------------------------------------------------------}
FUNCTION GetErrorInfo: Pointer;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        MINIMUM AND MAXIMUM ROUTINES                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

FUNCTION Min (I, J: Sw_Integer): Sw_Integer;overload;inline;
FUNCTION Min (A, B: Real): Real;overload;inline;
FUNCTION Min (A, B: int64): int64;overload;inline;

FUNCTION Max (I, J: Sw_Integer): Sw_Integer;overload;inline;
FUNCTION Max (A, B: Real): Real;overload;inline;
FUNCTION Max (A, B: int64):int64;overload;inline;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          MISSING DELPHI3 ROUTINES                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{ ******************************* REMARK ****************************** }
{  Delphi 3+ does not define these standard routines so I have made     }
{  some public functions here to complete compatability.                }
{ ****************************** END REMARK *** Leon de Boer, 14Aug98 * }

{-MemAvail-----------------------------------------------------------
Returns the free memory available under Delphi 3+.
14Aug98 LdB
---------------------------------------------------------------------}
FUNCTION MemAvail: LongInt;

{-MaxAvail-----------------------------------------------------------
Returns the max free memory block size available under Delphi 3+.
14Aug98 LdB
---------------------------------------------------------------------}
FUNCTION MaxAvail: LongInt;

{***************************************************************************}
{                        INITIALIZED PUBLIC VARIABLES                       }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                INITIALIZED DOS/DPMI/WIN/NT/OS2 VARIABLES                  }
{---------------------------------------------------------------------------}
CONST
   ErrorCode: Longint = errOk;                        { Last error code }
   ErrorInfo: TObject = Nil;                          { Last error info }

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                               IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{$IFDEF PPC_DELPHI3}                                  { DELPHI 3+ COMPILER }
USES WinTypes, WinProcs;                              { Stardard units }
{$ENDIF}

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{  GetErrorCode -> Platforms ALL - Updated 12Jul97 Bazsi                    }
{---------------------------------------------------------------------------}
FUNCTION GetErrorCode: LongInt;
BEGIN
   GetErrorCode := ErrorCode;                         { Return last error }
   ErrorCode := 0;                                    { Now clear errorcode }
END;

{---------------------------------------------------------------------------}
{  GetErrorInfo -> Platforms ALL - Updated 12Jul97 Bazsi                    }
{---------------------------------------------------------------------------}
FUNCTION GetErrorInfo: Pointer;
BEGIN
   GetErrorInfo := ErrorInfo;                         { Return errorinfo ptr }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        MINIMUM AND MAXIMUM ROUTINES                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

FUNCTION Min (I, J: Sw_Integer): Sw_Integer; overload;inline;
BEGIN
  If (I < J) Then Result := I Else Result := J;          { Select minimum }
END;

FUNCTION Max (I, J: Sw_Integer): Sw_Integer; overload;inline;
BEGIN
  If (I > J) Then Result := I Else Result := J;          { Select maximum }
END;


{---------------------------------------------------------------------------}
{  MinimumOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB         }
{---------------------------------------------------------------------------}
FUNCTION Min (A, B: Real): Real; overload;inline;
BEGIN
   If (B < A) Then Result := B                     { B smaller take it }
     Else Result := A;                             { Else take A }
END;

{---------------------------------------------------------------------------}
{  MaximumOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB         }
{---------------------------------------------------------------------------}
FUNCTION Max (A, B: Real): Real; overload;
BEGIN
   If (B > A) Then result := B                     { B bigger take it }
     Else result := A;                             { Else take A }
END;

{---------------------------------------------------------------------------}
{  MinLongIntOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB      }
{---------------------------------------------------------------------------}
FUNCTION Min (A, B: int64): int64;overload;inline;
BEGIN
   If (B < A) Then result := B                  { B smaller take it }
     Else result := A;                          { Else take A }
END;

{---------------------------------------------------------------------------}
{  MaxLongIntOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 04Oct99 LdB      }
{---------------------------------------------------------------------------}
FUNCTION Max (A, B: int64): int64;overload;inline;
BEGIN
   If (B > A) Then result := B                  { B bigger take it }
     Else result := A;                          { Else take A }
END;

FUNCTION MemAvail: LongInt;
BEGIN
  { Unlimited }
  MemAvail:=high(LongInt);
END;

{---------------------------------------------------------------------------}
{  MaxAvail -> Platforms WIN/NT - Updated 14Aug98 LdB                       }
{---------------------------------------------------------------------------}
FUNCTION MaxAvail: LongInt;
BEGIN
  { Unlimited }
  MaxAvail:=high(longint);
END;

END.
