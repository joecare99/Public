unit Obj_EditControlDlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
// fv-Units
  Objects, drivers,  Views, Dialogs, TVinput,
// DE-Units
  DialEditBase;

type
{ ControlEditDialog }

    PControlEditDialog = ^TControlEditDialog;
    TControlEditDialog = object(TDialog)
        private
        FTrialDialog :PGroup;
        public
        constructor Init(aDialog: PGroup; var Bounds: TRect; ATitle: TTitleStr);
        destructor Done; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure MakeDialogNames(SX: integer);
        procedure MakeDialogButtons(X1, X2, SY: integer;
                            Change: boolean; OkMode: word);
    end;

implementation

{*******************************************************}

{ ControlEditDialog }

constructor TControlEditDialog.Init(aDialog:PGroup; var Bounds: TRect;
                                ATitle: TTitleStr);
begin
    FTrialDialog := aDialog;
    Bounds.Move(DLim.B.X - Bounds.B.X, DLim.B.Y - Bounds.B.Y);
    if aDialog <> nil
    then aDialog^.SetState(sfActive, false);
    inherited Init(Bounds, ATitle);
{$IFDEF ScreenCapture}
    EnableCommands([cmScreenCapture]);
{$ENDIF}
end;

destructor TControlEditDialog.Done;
begin
    inherited Done;
    if FTrialDialog <> nil
    then FTrialDialog^.SetState(sfActive, true);
end;

procedure TControlEditDialog.HandleEvent(var Event: TEvent);
    {$IFDEF ScreenCapture}
var
    R: TRect;
    {$ENDIF}

begin
{$IFDEF ScreenCapture}
    if (Event.What and evMouseDown <> 0) and Event.Double
    then begin
        GetExtent(R);
        MakeGlobal(R.A, R.A);
        MakeGlobal(R.B, R.B);
        ScreenCapture(R);
        ClearEvent(Event);
    end;
{$ENDIF}

    inherited HandleEvent(Event);

    case Event.What of
     evCommand:
        case Event.Command of
         cmSetDefault:          {Save}
            begin
                EndModal(cmSetDefault);
                ModeToken^.SetState(sfPaste, false);
            end;
         cmSetPaste:            {Copy}
            begin
                EndModal(cmSetPaste);
                ModeToken^.SetState(sfPaste, true);
            end;
         else
            exit;
        end; {case}

     else
        exit;
    end; {case}
    ModeToken^.Draw;
    ClearEvent(Event);
end; {TControlEditDialog.HandleEvent}

procedure TControlEditDialog.MakeDialogNames(SX: integer);
var
    R: TRect;
    IL: PInputLine;
begin
    R.Assign(3, 4, SX-6, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, 10, 4);
    Insert(New(PLabel, Init(R, '~L~abel', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiLabelText)));

    R.Assign(3, 7, SX-6, 8);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(3, 6, 14, 7);
    Insert(New(PLabel, Init(R, '~D~ata Name', IL)));
    R.Assign(SX-6, 7, SX-3, 8);
    Insert(New(PHistory, Init(R, IL, hiDataName)));
end; {TControlEditDialog.MakeDialogNames}

{ Change is true for editing, false for init'zn. }
{ also centers dialog }
procedure TControlEditDialog.MakeDialogButtons(X1, X2, SY: integer;
                            Change: boolean; OkMode: word);
var
    R: TRect;
begin
    if Change then begin
        R.Assign(X1-5, SY-10, X1+5, SY-8);
        Insert(New(PButton, Init(R, 'D~e~lete', cmDelete, bfNormal)));
        R.Assign(X2-5, SY-10, X2+5, SY-8);
        Insert(New(PButton, Init(R, 'On ~T~op', cmPutOnTop, bfNormal)));
    end;

    R.Assign(X1-5, SY-7, X1+5, SY-5);
    Insert(New(PButton, Init(R, 'Sa~v~e', cmSetDefault, bfNormal)));
    R.Assign(X2-5, SY-7, X2+5, SY-5);
    Insert(New(PButton, Init(R, 'Cop~y~', cmSetPaste, bfNormal)));

    R.Assign(X1-5, SY-4, X1+5, SY-2);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));
    R.Assign(X2-5, SY-4, X2+5, SY-2);
    Insert(New(PButton, Init(R, '~O~k', cmOk, OkMode)));
end; {TControlEditDialog.MakeDialogButtons}


end.

