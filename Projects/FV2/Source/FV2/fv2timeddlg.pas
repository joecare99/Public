{

   Timed dialogs for Free Vision

   Copyright (c) 2004 by Free Pascal core team

   See the file COPYING.FPC, included in this distribution,
   for details about the copyright.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.

 ****************************************************************************}
UNIT fv2timeddlg;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                  INTERFACE
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$X+}
{====================================================================}

USES classes, fv2dialogs, fv2drivers, fv2views; { Standard GFV unit }

type

  { TTimedDialog }

  TTimedDialog = Class(TDialog)
public
    Secs: longint;
    constructor Create(aOwner:TGroup;var Bounds: TRect; ATitle: TTitleStr; ASecs: word);
    constructor Load (aOwner:TGroup;var S: TStream);
    procedure   GetEvent (out Event: TEvent); override;
    procedure   Store (var S: TStream); override;
  private
    Secs0: TDateTime;
    Secs2: TDateTime;
    DayWrap: boolean;
  end;
   PTimedDialog = ^TTimedDialog deprecated 'use TTimedDialog';

(* Must be always included in TTimeDialog! *)

  { TTimedDialogText }

  TTimedDialogText = Class(TStaticText)
public
    constructor Create(aOwner:TGroup;var Bounds: TRect);
    procedure   GetText (out S: string); override;
  end;
   PTimedDialogText = ^TTimedDialogText deprecated 'use TTimedDialogText';

procedure RegisterTimedDialog;

FUNCTION TimedMessageBox (Const Msg: String; Params: array of const;
  AOptions: Word; ASecs: Word): Word;

{-TimedMessageBoxRect------------------------------------------------
TimedMessageBoxRect allows the specification of a TRect for the message box
to occupy.
---------------------------------------------------------------------}
FUNCTION TimedMessageBoxRect (Var R: TRect; Const Msg: String; Params: array of const;
  AOptions: Word; ASecs: Word): Word;


{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

USES
  sysutils, fv2dos,
  fv2app, {resource,} fv2msgbox,fv2RectHelper;   { Standard GFV units }


{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

constructor TTimedDialogText.Create(aOwner:TGroup;var Bounds: TRect);
begin
  inherited Create(aOwner,Bounds, '');
end;


procedure TTimedDialogText.GetText(out S: string);
begin
  if Owner <> nil
(* and (TypeOf (Owner^) = TypeOf (TTimedDialog)) *)
                  then
   begin
    Str (TTimedDialog(Owner).Secs, S);
    S := #3 + S;
   end
  else
   S := '';
end;



constructor TTimedDialog.Create(aOwner:TGroup;var Bounds: TRect; ATitle: TTitleStr;
  ASecs: word);

begin
  inherited Create(aOwner,Bounds, ATitle);
  Secs0 := Now;
  Secs2 := Secs0 + ASecs/86400;
  Secs := ASecs;
end;


procedure TTimedDialog.GetEvent(out Event: TEvent);
var
  Secs1: TDateTime;
begin
  inherited GetEvent (Event);
  Secs1 := Now;
  if trunc((Secs2 - Secs1)*86400) <> Secs then
   begin
    Secs := trunc((Secs2 - Secs1)*86400);
    if Secs < 0 then
     Secs := 0;
(* If remaining seconds are displayed in one of included views, update them. *)
    Redraw;
   end;
  with Event do
   if (Secs = 0) and (What = evNothing) then
    begin
     What := evCommand;
     Command := cmCancel;
    end;
end;


constructor TTimedDialog.Load(aOwner: TGroup; var S: TStream);
begin
  inherited Load (aOwner,S);
  S.Read (Secs, SizeOf (Secs));
  S.Read (Secs0, SizeOf (Secs0));
  S.Read (Secs2, SizeOf (Secs2));
  S.Read (DayWrap, SizeOf (DayWrap));
end;


procedure TTimedDialog.Store (var S: TStream);
begin
  inherited Store (S);
  S.Write (Secs, SizeOf (Secs));
  S.Write (Secs0, SizeOf (Secs0));
  S.Write (Secs2, SizeOf (Secs2));
  S.Write (DayWrap, SizeOf (DayWrap));
end;



function TimedMessageBox(const Msg: String; Params: array of const; AOptions: Word;
  ASecs: Word): Word;
var
  R: TRect;
begin
  R.Assign(0, 0, 40, 10);                            { Assign area }
  if (AOptions AND mfInsertInApp = 0) then           { Non app insert }
   R.Move((Desktop.Size.X - R.B.X) div 2,
      (Desktop.Size.Y - R.B.Y) div 2)               { Calculate position }
  else
   R.Move((Application.Size.X - R.B.X) div 2,
      (Application.Size.Y - R.B.Y) div 2);          { Calculate position }
  TimedMessageBox := TimedMessageBoxRect (R, Msg, Params,
    AOptions, ASecs);                                { Create message box }
end;


function TimedMessageBoxRect(var R: TRect; const Msg: String;
  Params: array of const; AOptions: Word; ASecs: Word): Word;
var
  Dlg: TTimedDialog;
  {%H-}TimedText: TTimedDialogText;
begin
  Dlg := TTimedDialog.Create(nil,R, MsgBoxTitles [AOptions
    and $3], ASecs);                                { Create dialog }
  with Dlg do
   begin
    R.Assign (3, Size.Y - 5, Size.X - 2, Size.Y - 4);
    TimedText:=TTimedDialogText.Create(Dlg,R);
    R.Assign (3, 2, Size.X - 2, Size.Y - 5);         { Assign area for text }
   end;
  TimedMessageBoxRect := MessageBoxRectDlg (Dlg, R, Msg, Params, AOptions);
  freeandnil(Dlg);                               { Dispose of dialog }
end;



procedure RegisterTimedDialog;
begin
  //RegisterType (RTimedDialog);
  //RegisterType (RTimedDialogText);
end;


begin
  RegisterTimedDialog;
end.
