{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}

{   System independent GRAPHICAL clone of MSGBOX.PAS       }

{   Interface Copyright (c) 1992 Borland International     }

{   Copyright (c) 1996, 1997, 1998, 1999 by Leon de Boer   }
{   ldeboer@attglobal.net  - primary e-mail addr           }
{   ldeboer@starwon.com.au - backup e-mail addr            }

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
{        OS2      - Virtual Pascal 1.0+     (32 Bit)       }
{                 - Speedsoft Sybil 2.0+    (32 Bit)       }

{******************[ REVISION HISTORY ]********************}
{  Version  Date        Fix                                }
{  -------  ---------   ---------------------------------  }
{  1.00     12 Jun 96   Initial DOS/DPMI code released.    }
{  1.10     18 Oct 97   Code converted to GUI & TEXT mode. }
{  1.20     18 Jul 97   Windows conversion added.          }
{  1.30     29 Aug 97   Platform.inc sort added.           }
{  1.40     22 Oct 97   Delphi3 32 bit code added.         }
{  1.50     05 May 98   Virtual pascal 2.0 code added.     }
{  1.60     30 Sep 99   Complete recheck preformed         }
{**********************************************************}

unit MsgBox;

{2.0 compatibility}
{$ifdef VER2_0}
  {$macro on}
  {$define resourcestring := const}
{$endif}

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
interface

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$IFNDEF PPC_FPC}{ FPC doesn't support these switches }
  {$F-}{ Near calls are okay }
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

uses objects, Dialogs;                                 { Standard GFV units }

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                             MESSAGE BOX CLASSES                           }
{---------------------------------------------------------------------------}
const
  mfWarning = $0000;                            { Display a Warning box }
  mfError = $0001;                            { Dispaly a Error box }
  mfInformation = $0002;                            { Display an Information Box }
  mfConfirmation = $0003;                            { Display a Confirmation Box }

  mfInsertInApp = $0080;                            { Insert message box into }
{ app instead of the Desktop }
{---------------------------------------------------------------------------}
{                          MESSAGE BOX BUTTON FLAGS                         }
{---------------------------------------------------------------------------}
const
  mfYesButton = $0100;                            { Yes button into the dialog }
  mfNoButton = $0200;                            { No button into the dialog }
  mfOKButton = $0400;                            { OK button into the dialog }
  mfCancelButton = $0800;                            { Cancel button into the dialog }

  mfYesNoCancel = mfYesButton + mfNoButton + mfCancelButton;
  { Yes, No, Cancel dialog }
  mfOKCancel = mfOKButton + mfCancelButton;
{ Standard OK, Cancel dialog }

var
  MsgBoxTitles: array[0..3] of string[40];


{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

procedure InitMsgBox;
procedure DoneMsgBox;
  { Init initializes the message box display system's text strings.  Init is
    called by TApplication.Init after a successful call to Resource.Init or
    Resource.Load. }

{-MessageBox---------------------------------------------------------
MessageBox displays the given string in a standard sized dialog box.
Before the dialog is displayed the Msg and Params are passed to FormatStr.
The resulting string is displayed as a TStaticText view in the dialog.
30Sep99 LdB
---------------------------------------------------------------------}
function MessageBox(const Msg: string; Params: Pointer; AOptions: word): word;

{-MessageBoxRect-----------------------------------------------------
MessageBoxRec allows the specification of a TRect for the message box
to occupy.
30Sep99 LdB
---------------------------------------------------------------------}
function MessageBoxRect(var R: TRect; const Msg: string; Params: Pointer;
  AOptions: word): word;

{-MessageBoxRectDlg--------------------------------------------------
MessageBoxRecDlg allows the specification of a TRect for the message box
to occupy plus the dialog window (to allow different dialog window types).
---------------------------------------------------------------------}
function MessageBoxRectDlg(Dlg: PDialog; var R: TRect; const Msg: string;
  Params: Pointer; AOptions: word): word;

{-InputBox-----------------------------------------------------------
InputBox displays a simple dialog that allows user to type in a string
30Sep99 LdB
---------------------------------------------------------------------}
function InputBox(const Title, ALabel: string; var S: string; Limit: byte): word;

{-InputBoxRect-------------------------------------------------------
InputBoxRect is like InputBox but allows the specification of a rectangle.
30Sep99 LdB
---------------------------------------------------------------------}
function InputBoxRect(var Bounds: TRect; const Title, ALabel: string;
  var S: string; Limit: byte): word;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
implementation

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

uses Drivers, Views, App{, Resource};                    { Standard GFV units }

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

const
  Commands: array[0..3] of word =
    (cmYes, cmNo, cmOK, cmCancel);

var
  ButtonName: array[0..3] of string[40];

resourcestring
  sConfirm = 'Confirm';
  sError = 'Error';
  sInformation = 'Information';
  sWarning = 'Warning';


{---------------------------------------------------------------------------}
{  MessageBox -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB        }
{---------------------------------------------------------------------------}
function MessageBox(const Msg: string; Params: Pointer; AOptions: word): word;
var
  R: TRect;
begin
  R.Assign(0, 0, 40, 9);                             { Assign area }
  if (AOptions and mfInsertInApp = 0) then           { Non app insert }
    R.Move((Desktop^.Size.X - R.B.X) div 2,
      (Desktop^.Size.Y - R.B.Y) div 2)
  else          { Calculate position }
    R.Move((Application^.Size.X - R.B.X) div 2,
      (Application^.Size.Y - R.B.Y) div 2);          { Calculate position }
  MessageBox := MessageBoxRect(R, Msg, Params, AOptions);
  { Create message box }
end;

function MessageBoxRectDlg(Dlg: PDialog; var R: TRect; const Msg: string;
  Params: Pointer; AOptions: word): word;
var
  I, X, ButtonCount: integer;
  S: string;
  Control: PView;
  ButtonList: array[0..4] of PView;
begin
  with Dlg^ do
  begin
    FormatStr(S, Msg, Params^);                      { Format the message }
    Control := New(PStaticText, Init(R, S));         { Create static text }
    Insert(Control);                                 { Insert the text }
    X := -2;                                         { Set initial value }
    ButtonCount := 0;                                { Clear button count }
    for I := 0 to 3 do
      if (AOptions and ($0100 shl I) <> 0) then
      begin
        R.Assign(0, 0, 10, 2);                       { Assign screen area }
        Control := New(PButton, Init(R, ButtonName[I], Commands[i],
          bfNormal));
        { Create button }
        Inc(X, Control^.Size.X + 2);                 { Adjust position }
        ButtonList[ButtonCount] := Control;          { Add to button list }
        Inc(ButtonCount);                            { Inc button count }
      end;
    X := (Size.X - X) shr 1;                         { Calc x position }
    if (ButtonCount > 0) then
      for I := 0 to ButtonCount - 1 do
      begin         { For each button }
        Control := ButtonList[I];                     { Transfer button }
        Insert(Control);                              { Insert button }
        Control^.MoveTo(X, Size.Y - 3);               { Position button }
        Inc(X, Control^.Size.X + 2);                  { Adjust position }
      end;
    SelectNext(False);                               { Select first button }
  end;
  if (AOptions and mfInsertInApp = 0) then
    MessageBoxRectDlg := DeskTop^.ExecView(Dlg)
  else { Execute dialog }
    MessageBoxRectDlg := Application^.ExecView(Dlg); { Execute dialog }
end;


{---------------------------------------------------------------------------}
{  MessageBoxRect -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB    }
{---------------------------------------------------------------------------}
function MessageBoxRect(var R: TRect; const Msg: string; Params: Pointer;
  AOptions: word): word;
var
  Dialog: PDialog;
begin
  Dialog := New(PDialog, Init(R, MsgBoxTitles[AOptions and $3]));
  { Create dialog }
  with Dialog^ do
    R.Assign(3, 2, Size.X - 2, Size.Y - 3);          { Assign area for text }
  MessageBoxRect := MessageBoxRectDlg(Dialog, R, Msg, Params, AOptions);
  Dispose(Dialog, Done);                            { Dispose of dialog }
end;

{---------------------------------------------------------------------------}
{  InputBox -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB          }
{---------------------------------------------------------------------------}
function InputBox(const Title, ALabel: string; var S: string; Limit: byte): word;
var
  R: TRect;
begin
  R.Assign(0, 0, 60, 8);                             { Assign screen area }
  R.Move((Desktop^.Size.X - R.B.X) div 2,
    (Desktop^.Size.Y - R.B.Y) div 2);                { Position area }
  InputBox := InputBoxRect(R, Title, ALabel, S, Limit);
  { Create input box }
end;

{---------------------------------------------------------------------------}
{  InputBoxRect -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB      }
{---------------------------------------------------------------------------}
function InputBoxRect(var Bounds: TRect; const Title, ALabel: string;
  var S: string; Limit: byte): word;
var
  C: word;
  R: TRect;
  Control: PView;
  Dialog: PDialog;
begin
  Dialog := New(PDialog, Init(Bounds, Title));       { Create dialog }
  with Dialog^ do
  begin
    R.Assign(4 + CStrLen(ALabel), 2, Size.X - 3, 3); { Assign screen area }
    Control := New(PInputLine, Init(R,Limit));             { Create input line }
    Insert(Control);                                 { Insert input line }
    R.Assign(2, 2, 3 + CStrLen(ALabel), 3);          { Assign screen area }
    Insert(New(PLabel, Init(R, ALabel, Control)));   { Insert label }
    R.Assign(Size.X - 24, Size.Y - 4, Size.X - 14,
      Size.Y - 2);                                   { Assign screen area }
    Insert(New(PButton, Init(R, 'O~K~', cmOk, bfDefault)));
    { Insert okay button }
    Inc(R.A.X, 12);                                  { New start x position }
    Inc(R.B.X, 12);                                  { New end x position }
    Insert(New(PButton, Init(R, 'Cancel', cmCancel, bfNormal)));
    { Insert cancel button }
    Inc(R.A.X, 12);                                  { New start x position }
    Inc(R.B.X, 12);                                  { New end x position }
    SelectNext(False);                               { Select first button }
  end;
  Dialog^.SetData(S);                                { Set data in dialog }
  C := DeskTop^.ExecView(Dialog);                    { Execute the dialog }
  if (C <> cmCancel) then
    Dialog^.GetData(S);        { Get data from dialog }
  Dispose(Dialog, Done);                             { Dispose of dialog }
  InputBoxRect := C;                                 { Return execute result }
end;


procedure InitMsgBox;
begin
  ButtonName[0] := slYes;
  ButtonName[1] := slNo;
  ButtonName[2] := slOk;
  ButtonName[3] := slCancel;
  MsgBoxTitles[0] := sWarning;
  MsgBoxTitles[1] := sError;
  MsgBoxTitles[2] := sInformation;
  MsgBoxTitles[3] := sConfirm;
end;

procedure DoneMsgBox;
begin
end;

end.
