unit obj_trialbutton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  Objects, Views, dialogs, Drivers,App,

  DialEditBase, DialEditBFctn,
  Obj_EditControlDlg, TVinput,dialeditDefaults, str_ButtonData;

type
  { TrialButton }

    PButtonDialog = ^TButtonDialog;
    TButtonDialog = object(TControlEditDialog)
        constructor Init(aDialog: Pgroup; Change: boolean);
    end;

    PTrialButton = ^TTrialButton;

    { TTrialButton }

    TTrialButton = object(TButton)
        CmdName: String;
        constructor Init(aOwner: PGroup; AData: PButtonData);
        destructor Done; virtual;
        function Execute: word; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;


implementation

{ ButtonDialog }

constructor TButtonDialog.Init(aDialog:PGroup; Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    V: PView;
    DT: TTitleStr;
    SY: integer;
const
    SX = 27;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
//    X3 = SX div 2;
begin
    if Change then begin
        SY:= 26;  DT:= 'Change';
    end else begin
        SY:= 23;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' Button';
    inherited Init(aDialog, R, DT);

    R.Assign(3, 4, SX-6, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, SX-3, 4);
    Insert(New(PLabel, Init(R, 'Button ~T~ext', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiLabelText)));

    R.Assign(3, 7, SX-6, 8);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(3, 6, SX-3, 7);
    Insert(New(PLabel, Init(R, 'Command ~N~ame', IL)));
    R.Assign(SX-6, 7, SX-3, 8);
    Insert(New(PHistory, Init(R, IL, hiCmdName)));

    R.Assign(3, 10, 22, 14);
    V:= New(PCheckBoxes, Init(R,
        NewSItem('bf~D~efault',
        NewSItem('bf~L~eftJustify',
        NewSItem('bf~B~roadcast',
        NewSItem('bf~G~rabFocus',
        nil))))
    ));  Insert(V);
    R.Assign(3,  9, 20, 10);
    Insert(New(PLabel, Init(R, 'Button ~F~lags', V)));

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
end; {TButtonDialog.Init}

{ TrialButton }

constructor TTrialButton.Init(aOwner:PGroup;AData: PButtonData);
var
    R: TRect;
    L: integer;
begin
    with AData^ do begin
        L:= CStrLen(RTitle) + 4;
        if L < 10 then L:= 10;
        InitBounds(aOwner,R, L, 2);
        inherited Init(R, RTitle, cmNo, RFlags);
        CmdName:= RCmdName;
        DragMode:= dmLimitAll;
    end;
end; {TTrialButton.Init}

destructor TTrialButton.Done;
begin
//    DisposeStr(CmdName);
    inherited Done;
end; {TTrialButton.Done}


function TTrialButton.Execute: word;
var
    S: string;
    R: TRect;
begin
  result :=0;
    case CodeGen.GenPart of
     gpControls:
        begin
            writeln;
            CodeBounds(Self);
            if Flags = 0 then begin
                S:= 'bfNormal';
            end else begin
                S:= '';
                if Flags and bfDefault   <> 0
                then S:= S + '+bfDefault';
                if Flags and bfLeftJust  <> 0
                then S:= S + '+bfLeftJust';
                if Flags and bfBroadcast <> 0
                then S:= S + '+bfBroadcast';
                if Flags and bfGrabFocus <> 0
                then S:= S + '+bfGrabFocus';
                Delete(S, 1,1);
            end;

            writeln(Tab+'Insert(New(PButton, Init(R, ''',
                EscQuot(GetStr(Title)), ''', ',
                CmdName, ', ',
                S, ')));'
            );
        end;

     gpClone:
        begin
            GetBounds(R);
            CodeGen.RealDialog^.Insert(New(PButton, Init(R,
                GetStr(Title),GetVal( @CmdName), Flags)));
        end;
    end; {case}
end; {TTrialButton.Execute}

procedure TTrialButton.HandleEvent(var Event: TEvent);
var
    PD: PDialog;
//    PS: PTrialButton;
    ButtonData: TButtonData;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with ButtonData do begin
            { edit Button with ButtonDialog: }
            RFlags:= Flags;
            RCmdName:= CmdName;
            RTitle:= GetStr(Title);

            PD:= PDialog(New(PButtonDialog, Init(self.owner,true)));
            Cmd:= application^.ExecuteDialog(PD, @ButtonData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    Flags:= RFlags;
                    AmDefault:= RFlags and bfDefault <> 0;
                    CmdName:= RCmdName;
                    ChangeStr(Title, RTitle);
                    if Cmd = cmPutOnTop then MakeFirst;
                    Draw;
                    Changed:= true;
                end;

             cmDelete:
                begin
                    Free;
                    Changed:= true;
                end;

             cmSetDefault: Default.DButton:= ButtonData;

             cmSetPaste: Paste.DButton:= ButtonData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size Button by dragging: }
            DragIt(Self, Event, Changed);
        end;
    end;
end; {TTrialButton.HandleEvent}

procedure TTrialButton.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 5;  Dec(MaxSz.X,2);
    MinSz.Y:= 2;  Dec(MaxSz.Y,2);
end; {TTrialButton.SizeLimits}

constructor TTrialButton.Load(var S: TStream);
var
  p: Objects.PString;
begin
    inherited Load(S);
    p := S.ReadStr;
    CmdName:= p^;
    DisposeStr(p);
end; {TTrialButton.Load}

procedure TTrialButton.Store(var S: TStream);
begin
    inherited Store(S);
    S.WriteStr(@CmdName);
end; {TTrialButton.Store}



end.

