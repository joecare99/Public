unit obj_TrialParamText;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  Objects, Views, Drivers,dialogs, App,

  DialEditBase, DialEditBFctn,
  Obj_EditControlDlg, TVinput,dialeditDefaults,str_ParamTextData;

type
  { TrialParamText }

      PParamTextDialog = ^TParamTextDialog;
      TParamTextDialog = object(TControlEditDialog)
          constructor Init(aDialog: PGroup; Change: boolean);
      end;


      { TTrialParamText }

      PTrialParamText = ^TTrialParamText;
      TTrialParamText = object(TParamText)
          Names: String;
          constructor Init(aOwner: Pgroup; AData: PParamTextData);
          constructor Load(var S: TStream);
          destructor Done; virtual;
          function Execute: word; virtual;
          { Changed GetText to GetText2 because VP gives error 131: }
          { "Header does not match previous definition" }
          { But it DOES! letter for letter! }
          procedure GetText2(var S: ShortString); virtual;             {+}
          procedure HandleEvent(var Event: TEvent); virtual;
          procedure SizeLimits(var Min, Max: TPoint); virtual;
          procedure Store(var S: TStream);
      end;



implementation

{ ParamTextDialog }

constructor TParamTextDialog.Init(aDialog:PGroup;Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    DT: TTitleStr;
    SY: integer;
const
    SX = 39;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
//    X3 = SX div 2;
begin
    if Change then begin
        SY:= 20;  DT:= 'Change';
    end else begin
        SY:= 17;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' ParamText';
    inherited Init(aDialog, R, DT);

    R.Assign(3, 4, SX-6, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, SX-3, 4);
    Insert(New(PLabel, Init(R, '~F~ormat', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiStaticText)));

    R.Assign(3, 7, SX-6, 8);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 6, SX-3, 7);
    Insert(New(PLabel, Init(R, 'Parameter ~N~ames', IL)));
    R.Assign(SX-6, 7, SX-3, 8);
    Insert(New(PHistory, Init(R, IL, hiDataName)));

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
end; {TParamTextDialog.Init}

{ TrialParamText }

constructor TTrialParamText.Init(aOwner: Pgroup; AData: PParamTextData);
var
    R: TRect;
    I, N: integer;
begin
    with AData^ do begin
        InitBounds(aOwner,R, Length(RFormat), 1);
        N:= 1;
        for I:= 1 to Length(RNames) do begin
            if RNames[I] = ',' then inc(N);
        end;
        inherited Init(R, RFormat, 0);
        Names:= RNames;
        DragMode:= dmLimitAll;
    end;
end; {TTrialParamText.Init}

destructor TTrialParamText.Done;
begin
//    DisposeStr(Names);
    inherited Done;
end; {TTrialParamText.Done}

function TTrialParamText.Execute: word;
var
    SF, SN: string;
    J: integer;
    R: TRect;

begin
  result := 0;
    case CodeGen.GenPart of
     gpDataFields:
        begin
            SN:= Names + ',';
            SF:= Text^;
            repeat
                J:= Pos(',', SN);
                if J > 0 then begin
                    write(Tab+Tab, Copy(SN, 1, J-1), ': ');
                    Delete(SN, 1, J);
                    while SN[1] = ' ' do Delete(SN, 1, 1);
                    J:= Pos('%', SF);
                    if J > 0 then begin
                        Delete(SF, 1, J);
                        while SF[1] in ['-', '0'..'9']
                        do Delete(SF, 1, 1);
                        case SF[1] of
                        's': write('^string');
                        'c': write('longint {lo char}');
                        'd', 'x': write('longint');
                        end;
                        Delete(SF, 1, 1);
                    end;
                    writeln(';');
                end;
            until J = 0;
        end;

     gpDataValues:      { similar to gpDataFields -- merge ? }      {++}
        begin
            SN:= Names + ',';
            SF:= Text^;
            repeat
                J:= Pos(',', SN);
                if J > 0 then begin
                    if CodeGen.Semicolon then writeln(';');
                    CodeGen.Semicolon:= true;
                    write(Tab+Tab, Copy(SN, 1, J-1), ': ');
                    Delete(SN, 1, J);
                    while SN[1] = ' ' do Delete(SN, 1, 1);
                    J:= Pos('%', SF);
                    if J > 0 then begin
                        Delete(SF, 1, J);
                        while SF[1] in ['-', '0'..'9']
                        do Delete(SF, 1, 1);
                        case SF[1] of
                        's': write('nil');
                        'c': write('$20');
                        'd': write('0');
                        'x': write('$0');
                        end;
                        Delete(SF, 1, 1);
                    end;
                end;
            until J = 0;
        end;

     gpControls:
        begin
            writeln;
            CodeBounds(Self);
            writeln(Tab+'Insert(New(PParamText, Init(R, ''',
                EscQuot(GetStr(Text)), ''', ', ParamCount, ')));'
            );
        end;

     gpClone:
        begin
            GetBounds(R);
            CodeGen.RealDialog^.Insert(New(PParamText, Init(R,
                GetStr(Text), ParamCount)));
        end;
    end; {case}
end; {TTrialParamText.Execute}

procedure TTrialParamText.HandleEvent(var Event: TEvent);
var
    PD: PDialog;
//    PS: PTrialParamText;
    ParamTextData: TParamTextData;
    L: integer;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with ParamTextData do begin
            { edit ParamText with ParamTextDialog: }
            RFormat:= Text^;
            L:= Length(RFormat);
            RNames:= Names;

            PD:= PDialog(New(PParamTextDialog, Init(self.Owner,true)));
            Cmd:= application^.ExecuteDialog(PD, @ParamTextData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    if (RFormat <> '') and (RNames <> '') then begin
                        ChangeStr( Text, RFormat);
                        Names:= RNames;
                        Dec(L, Length(RFormat));
                        if L <> 0 then GrowTo(Size.X-L, 1);
                        if Cmd = cmPutOnTop then MakeFirst;
                    end else Free;
                    Draw;
                    Changed:= true;
                end;

             cmDelete:
                begin
                    Free;
                    Changed:= true;
                end;

             cmSetDefault: Default.DParamText:= ParamTextData;

             cmSetPaste: Paste.DParamText:= ParamTextData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size ParamText by dragging: }
            DragIt(Self, Event, Changed);
        end;
    end;
end; {TTrialParamText.HandleEvent}

procedure TTrialParamText.SizeLimits(var Min, Max: TPoint);
begin
    inherited SizeLimits(Min, Max);
    Min.X:= 1;  Dec(Max.X,2);
    Min.Y:= 1;  Dec(Max.Y,2);
end; {TTrialParamText.SizeLimits}

procedure TTrialParamText.GetText2(var S: ShortString);
begin
    { Since the trial ParamText has no real data, }
    { display the format text without data conversion: }
    TStaticText.GetText(S);
end; {TTrialParamText.GetText2}

constructor TTrialParamText.Load(var S: TStream);
var
  P: Objects.PString;
begin
    inherited Load(S);
    P:= S.ReadStr;
    Names:=p^;
    DisposeStr(p);
end; {TTrialParamText.Load}

procedure TTrialParamText.Store(var S: TStream);
begin
    inherited Store(S);
    S.WriteStr(@Names);
end; {TTrialParamText.Store}

{*******************************************************}
end.

