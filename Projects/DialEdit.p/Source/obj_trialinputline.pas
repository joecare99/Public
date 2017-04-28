unit obj_TrialInputLine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  Objects, Views, dialogs, Drivers,App,

  DialEditBase, DialEditBFctn,
  Obj_EditControlDlg, TVinput,dialeditDefaults, obj_TrialLabel, str_InputLineData;

type


  { TrialInputLine }

      PInputLineDialog = ^TInputLineDialog;
      TInputLineDialog = object(TControlEditDialog)
          MRButtons: PMRadioButtons;
          Advice: PStaticText;
          constructor Init(aDialog: PGroup; Change: boolean);
          procedure HandleEvent(var Event: TEvent); virtual;
      end;

      { TrialHistory }

      PTrialHistory = ^TTrialHistory;
      TTrialHistory = object(THistory)
          procedure HandleEvent(var {%H-}Event: TEvent); virtual;
          procedure TrackTarget(const OldR: TRect);
      end;

      PTrialInputLine = ^TTrialInputLine;

      { TTrialInputLine }

      TTrialInputLine = object(TInputLine)
          LabelP: PTrialLabel;
          DataName: String;
          History: PTrialHistory;
          HistStr: String;
          Validate: word;
          ValPars: String;
          constructor Init(aOwner: Pgroup; AData: PInputLineData);
          destructor Done; virtual;
          procedure MakeHistory(AHistStr: TTitleStr); virtual;
          function Execute: word; virtual;
          procedure HandleEvent(var Event: TEvent); virtual;
          procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
          constructor Load01(var S: TStream);
          constructor Load02(var S: TStream);
          procedure Convert02;
          constructor Load(var S: TStream);
          procedure Store(var S: TStream); virtual;
      end;


implementation

{ InputLineDialog }

constructor TInputLineDialog.Init(aDialog:PGroup; Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    DT: TTitleStr;
    SY: integer;
const
    SX = 29;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
//    X3 = SX div 2;
begin
    if Change then begin
        SY:= 34;  DT:= 'Change';
    end else begin
        SY:= 31;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' InputLine';
    inherited Init(aDialog, R, DT);

    MakeDialogNames(SX);

    R.Assign(3, 9, 9, 10);
    IL:= New(PRangeInputLine, Init(R, 4, 1, 255));  Insert(IL);
    R.Assign(9, 9, SX-3, 10);
    Insert(New(PLabel, Init(R, '~M~ax. Line Length', IL)));

    R.Assign(3, 11, 12, 12);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(15, 11, SX-3, 12);
    Insert(New(PLabel, Init(R, '~H~istory ID', IL)));
    R.Assign(12, 11, 15, 12);
    Insert(New(PHistory, Init(R, IL, hiHistID)));

    R.Assign(3, 14, SX-3, 19);
    MRButtons:= New(PMRadioButtons, Init(R,
        NewSItem('~N~one',
        NewSItem('~F~ilter',
        NewSItem('~R~ange (longint)',
        NewSItem('~S~tringLookup',
        NewSItem('P~X~Picture',
        nil)))))
    ));  Insert(MRButtons);
    R.Assign(3, 13, 14, 14);
    Insert(New(PLabel, Init(R, 'Val~i~dator', MRButtons)));

    R.Assign(3, 21, SX-6, 22);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 20, SX-3, 21);
    Insert(New(PLabel, Init(R, 'Validation ~P~arameters', IL)));
    R.Assign(SX-6, 21, SX-3, 22);
    Insert(New(PHistory, Init(R, IL, hiValPars)));

    R.Assign(3, 22, SX-2, 23);
    Advice:= New(PStaticText, Init(R, ''));
    Insert(Advice);

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
end; {TInputLineDialog.Init}

procedure TInputLineDialog.HandleEvent(var Event: TEvent);
var
    S: PString;

const
    S0: string = ' (no parameters needed)';
    S1: string = ' ValidChars: TCharSet';
    S2: string = ' Min, Max: longint';
    S3: string = ' S: PStringCollection';
    S4: string = 'Pic:String; Fill:Boolean';

begin
    inherited HandleEvent(Event);
    with Event do begin
        if (What = evBroadcast)
            and (InfoPtr = MRButtons)
            and ((Command = cmListItemSelected) or
                (Command = cmReceivedFocus))
        then begin
            case MRButtons^.Value of
             0: S:= @S0;
             1: S:= @S1;
             2: S:= @S2;
             3: S:= @S3;
             4: S:= @S4;
            end; {case}
            ChangeStr(Advice^.Text, S^);
            Advice^.DrawView;
        end;
    end;
end; {TInputLineDialog.HandleEvent}

{ TrialHistory }

procedure TTrialHistory.HandleEvent(var Event: TEvent);

begin
    { disable normal actions }
end; {TTrialHistory.HandleEvent}

{ Move History after target (Link^) is dragged: }
{ (OldR is bounds of Link^ before dragging) }
procedure TTrialHistory.TrackTarget(const OldR: TRect);
begin
    { track upper right corner of target: }
    MoveTo(Origin.X + Link^.Origin.X + Link^.Size.X - OldR.B.X,
           Origin.Y + Link^.Origin.Y - OldR.A.Y);
end; {TTrialHistory.TrackTarget}

{ TrialInputLine }

constructor TTrialInputLine.Init(aOwner: Pgroup; AData: PInputLineData);
var
    R: TRect;
    M: integer;
begin
    with AData^ do begin
        M:= CStrLen(RLabel) + 2;
        if M < 10 then M:= 10;
        InitBounds(aowner,R, M, 1);
        inherited Init(R, RMaxLen);
        if (RHistStr <> '') and (RHistStr <> '0')
        and (RHistStr[1] <> ' ') then begin
            MoveTo(Origin.X-3, Origin.Y);
            MakeHistory(RHistStr);
        end else begin
            History:= nil;
            HistStr:= '';
        end;
        DragMode:= dmLimitAll;
        LabelP:= NewLabel(aOwner,Self, RLabel);
        DataName:= RDataName;
        Validate:= RValidate;
        ValPars:= RValPars;
    end;
end; {TTrialInputLine.Init}

destructor TTrialInputLine.Done;
begin
    //DisposeStr(DataName);
    //DisposeStr(HistStr);
    //DisposeStr(ValPars);
    inherited Done;
end; {TTrialInputLine.Done}

procedure TTrialInputLine.MakeHistory(AHistStr: TTitleStr);
var
    R: TRect;
begin
    HistStr:= AHistStr;
    R.Assign(
        Origin.X+Size.X,
        Origin.Y,
        Origin.X+Size.X+3,
        Origin.Y+1
    );
    History:= New(PTrialHistory, Init(R, @Self, hiTestID));
    Owner^.Insert(History);
end; {TTrialInputLine.MakeHistory}

function TTrialInputLine.Execute: word;
var
    S: string;

    function HistName: boolean;
    begin
        HistName:= false;
        if History <> nil then begin
            S:= HistStr;
            if (S <> '') and (S[1] in ['_','A'..'Z','a'..'z'])
            then HistName:= true;
        end;
    end; {HistName}

var
    R: TRect;
    I: longint;
    E: integer;
    zLink:PView;

begin
     result :=0;
    case CodeGen.GenPart of
     gpDataFields:
        begin
            if Validate = 2 {RangeValidator} then begin
                writeln(Tab+Tab, DataName, ': longint;');
            end else begin
                writeln(Tab+Tab, DataName, ': string[',
                        MaxLen, '];');
            end;
            //GenVars:= GenVars or gvInputLine;
            //ValUsed:= ValUsed or (Validate > 0);
            //if HistName then ListHistConsts:= true;
        end;

     gpDataValues:
        begin
            if CodeGen.Semicolon then writeln(';');
            CodeGen.Semicolon:= true;
            if Validate = 2 {RangeValidator} then begin
                Val(Data^, I, E);
                if E > 0 then I:= 0;
                write(Tab+Tab, (DataName), ': ', I);
            end else begin
                write(Tab+Tab, (DataName), ': ''',
                        EscQuot(GetStr(Data)), '''');
            end;
        end;

     gpHistConsts:
        if HistName then begin
            writeln(Tab, S, ' ='+Tab, CodeGen.HistIdVal, ';');
            inc(CodeGen.HistIdVal);
        end;

     gpControls:
        begin
            writeln;
            CodeBounds(Self);
            write(Tab+'IL:= New(P');
            case Validate of
             1: write('Filter');
             2: write('Range');
             3: write('StringLookup');
             4: write('PXPicture');
            end; {case}
            write('InputLine, Init(R, ', MaxLen);
            if Validate > 0 then begin
                write(', ', (ValPars));
            end;
            writeln('));  Insert(IL);');
            LabelP^.GenCode( 'IL',nil);
            if History <> nil then begin
                Convert02;                                      {+}
                CodeBounds(History^);
                writeln(Tab+'Insert(New(PHistory, Init(R, IL, ',
                    (HistStr), ')));');
            end;
        end;

     gpClone:
        begin
            GetBounds(R);
            {doesn't do Validators}                             {++}
            zLink:= New(PInputLine, Init(R, MaxLen));
            CodeGen.RealDialog^.Insert(zLink);
            LabelP^.GenCode('IL',zLink);
            if History <> nil then begin
                History^.GetBounds(R);
                CodeGen.RealDialog^.Insert(New(PHistory, Init(R,
                    PInputLine(zLink), hiTestID)));
            end;
        end;
    end; {case}
end; {TTrialInputLine.Execute}

procedure TTrialInputLine.HandleEvent(var Event: TEvent);
var
    PD: PDialog;
//    PS: PTrialInputLine;
    InputLineData: TInputLineData;
    OldR: TRect;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with InputLineData do begin
            { edit InputLine with InputLineDialog: }
            RMaxLen:= MaxLen;
            RDataName:= (DataName);
            RLabel:= GetStr(LabelP^.Text);
            if History <> nil then begin
                Convert02;                                      {+}
                RHistStr:= (HistStr);
            end else begin
                RHistStr:= '';
            end;
            RValPars:= (ValPars);
            RValidate:= Validate;

            PD:= PDialog(New(PInputLineDialog, Init(self.owner,true)));
            Cmd:= Application^.ExecuteDialog(PD, @InputLineData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    MaxLen:= RMaxLen;
                    DataName:= RDataName;
                    LabelP^.ChangeText(RLabel);
                    if (RHistStr <> '') and (RHistStr <> '0')
                    and (RHistStr[1] <> ' ') then begin
                        if History <> nil then begin
                            HistStr:= RHistStr;   {changed}
                        end else begin
                            GrowTo(Size.X-3, Size.Y);       {added}
                            MakeHistory(RHistStr);
                        end;
                    end else begin
                        if History <> nil then begin
                            GrowTo(Size.X+3, Size.Y);       {deleted}
                            History^.Free;
                            History:= nil;
                         //   DisposeStr(HistStr);
                        end;
                    end;
                    Validate:= RValidate;
                    if Validate = 0 then RValPars:= '';
                    ValPars:= RValPars;
                    if Cmd = cmPutOnTop then begin
                        MakeFirst;
                        if LabelP <> nil then LabelP^.MakeFirst;
                        if History <> nil then History^.MakeFirst;
                    end;
                    Draw;
                    Changed:= true;
                end;

             cmDelete:
                begin
                    if LabelP <> nil then LabelP^.Free;
                    if History <> nil then History^.Free;
                    Free;
                    Changed:= true;
                end;

             cmSetDefault: Default.DInputLine:= InputLineData;

             cmSetPaste: Paste.DInputLine:= InputLineData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size InputLine, moving also History & Label: }
            GetBounds(OldR);  {save old bounds}
            DragBoth(Self, LabelP, Event, Changed);
            if History <> nil then History^.TrackTarget(OldR);
        end;
    end;
end; {TTrialInputLine.HandleEvent}

procedure TTrialInputLine.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 3;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  MaxSz.Y:= 1;
end; {TTrialInputLine.SizeLimits}

constructor TTrialInputLine.Load01(var S: TStream);             {+}
var
  p: Objects.PString;
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    p := S.ReadStr;
    DataName:= p^;
    DisposeStr(p);
    S.Read(Validate, SizeOf(Validate));
    p := S.ReadStr;
    ValPars:= p^;
    DisposeStr(p);
    { version 01 has no History: }
    History:= nil;
    HistStr:= '';
end; {TTrialInputLine.Load01}

constructor TTrialInputLine.Load02(var S: TStream);             {+}
var
  p: Objects.PString;
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    p := S.ReadStr;
    DataName:= p^;
    DisposeStr(p);
    S.Read(Validate, SizeOf(Validate));
    p := S.ReadStr;
    ValPars:= p^;
    DisposeStr(p);
    { version 02 has History pointer, but no ID string: }
    GetPeerViewPtr(S, History);
    HistStr:= '';  {can't convert now}
    {.. do conversion later, in HandleEvent & Execute}
end; {TTrialInputLine.Load02}

{ convert version 02 InputLine: }
procedure TTrialInputLine.Convert02;                            {+}
var
    IDstr: TTitleStr;
begin
    { assume History <> nil is true: }
    if (HistStr = '') and (History^.HistoryID <> 0)
    then begin
        Str(History^.HistoryID, IDstr);
        HistStr:= IDstr;
        History^.HistoryID:= 0;
    end;
end; {TTrialInputLine.Convert02}

constructor TTrialInputLine.Load(var S: TStream);
var
  p: Objects.PString;
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    p := S.ReadStr;
    DataName:= p^;
    DisposeStr(p);
    S.Read(Validate, SizeOf(Validate));
    p := S.ReadStr;
    ValPars:= p^;
    DisposeStr(p);
    GetPeerViewPtr(S, History);
    p := S.ReadStr;
    HistStr:= p^;
    DisposeStr(p);
end; {TTrialInputLine.Load}

procedure TTrialInputLine.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    S.WriteStr(@DataName);
    S.Write(Validate, SizeOf(Validate));
    S.WriteStr(@ValPars);
    PutPeerViewPtr(S, History);
    S.WriteStr(@HistStr);
end; {TTrialInputLine.Store}

end.

