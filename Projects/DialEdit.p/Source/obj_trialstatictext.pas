unit obj_TrialStaticText;

interface

uses
  SysUtils, Dialogs,

  Objects, Views, Drivers,App,

  DialEditBase, DialEditBFctn,
  Obj_EditControlDlg, TVinput,dialeditDefaults,str_statictextdata;

type
    PStaticTextDialog = ^TStaticTextDialog;
    TStaticTextDialog = object(TControlEditDialog)
        constructor Init(aDialog: PGroup; Change: boolean);
    end;


    { TTrialStaticText }

    PTrialStaticText = ^TTrialStaticText;
    TTrialStaticText = object(TStaticText)
        FOnClone:TDelegate;
        constructor Init(aOwner: Pgroup; AData: PStaticTextData; OnClone:TDelegate);
        function Execute: word; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint); virtual;
    end;


implementation

constructor TStaticTextDialog.Init(aDialog:PGroup;Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    DT: string;
    SY: integer;
const
    SX = 27;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
//    X3 = SX div 2;
begin
    if Change then begin
        SY:= 17;  DT:= 'Change';
    end else begin
        SY:= 14;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' StaticText';
    inherited Init(aDialog, R, DT);

    R.Assign(3, 4, SX-6, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, SX-3, 4);
    Insert(New(PLabel, Init(R, 'Te~x~t', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiStaticText)));

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
    IL^.Select;
end; {TStaticTextDialog.Init}


{ TrialStaticText }

constructor TTrialStaticText.Init(aOwner: Pgroup; AData: PStaticTextData;
  OnClone: TDelegate);
var
    R: TRect;
begin
    FOnClone:=OnClone;
    with AData^ do begin
        InitBounds(aOwner,R, CStrLen(RText), 1);
        inherited Init(R, RText);
        DragMode:= dmLimitAll;
    end;
end; {TTrialStaticText.Init}

function TTrialStaticText.Execute: word;
var
    R: TRect;
begin
  {$IfDef FPC_OBJFPC}result{$else}Execute{$endif}
   :=0;
    case CodeGen.GenPart of
     gpControls:
        begin
            writeln;
            CodeBounds(Self);
            writeln(Tab+'Insert(New(PStaticText, Init(R, ''',
                EscQuot(GetStr(Text)), ''')));'
            );
        end;

     gpClone:
        begin
            if assigned(FonClone) then
              FonClone(@self)
            else
              begin
                GetBounds(R);
                CodeGen.RealDialog^.Insert(New(PStaticText, Init(R, GetStr(Text))));
              end;
        end;
    end; {case}
end; {TTrialStaticText.Execute}

procedure TTrialStaticText.HandleEvent(var Event: TEvent);
var
    PD: PDialog;
//    PS: PTrialStaticText;
    StaticTextData: TStaticTextData;
    L: integer;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with StaticTextData do begin
            { edit StaticText with StaticTextDialog: }
            RText:= GetStr(Text);
            L:= Length(RText);

            PD:= PDialog(New(PStaticTextDialog, Init(self.Owner, true)));
            Cmd:= Application^.ExecuteDialog(PD, @StaticTextData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    if RText <> '' then begin
                        ChangeStr(Text, RText);
                        Dec(L, Length(RText));
                        if L <> 0 then GrowTo(Size.X-L, 1);
                        if Cmd = cmPutOnTop then MakeFirst;
                    end else begin
                        Free;
                    end;
                    Draw;
                    Changed:= true;
                end;

             cmDelete:
                begin
                    Free;
                    Changed:= true;
                end;

             cmSetDefault: Default.DStaticText:= StaticTextData;

             cmSetPaste: Paste.DStaticText:= StaticTextData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size StaticText by dragging: }
            DragIt( Self, Event, Changed);
        end;
    end;
end; {TTrialStaticText.HandleEvent}

procedure TTrialStaticText.SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 1;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  Dec(MaxSz.Y,2);
end; {TTrialStaticText.SizeLimits}

{*******************************************************}


end.

