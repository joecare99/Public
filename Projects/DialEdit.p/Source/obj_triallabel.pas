unit obj_TrialLabel;

interface

uses
  Objects, SysUtils, Dialogs, Views, Drivers, DialEditBase, DialEditBFctn, TVinput;

type
  { TrialLabel }

    PTrialLabel = ^TTrialLabel;

    { TTrialLabel }

    TTrialLabel = object(TTrackTargetLabel)
        constructor Init(var Bounds: TRect; AText: TTitleStr;
                    ALink: PView);
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint); Virtual;
        procedure GenCode(const LinkName: string;aLink:PView);
        procedure ChangeText(const ALabel: string);
        procedure TrackTarget(const OldR: TRect);virtual;
    end;
    { NOTE: No label is indicated EITHER by setting the label }
    { pointer to nil, OR by setting the label text to ''. }

const
      RTrialLabel: TStreamRec = (
        ObjType: 1100;
        VmtLink: Ofs(TypeOf(TTrialLabel)^);
        Load: @TLabel.Load;             {using ancestor's load}
        Store: @TLabel.Store{%H-}            {using ancestor's store}
    );

function NewLabel(const aOwner:PGroup;const Obj: TView; const ALabel: TTitleStr):
                          PTrialLabel;

implementation

function NewLabel(const aOwner: PGroup; const Obj: TView;
  const ALabel: TTitleStr): PTrialLabel;
var
    R: TRect;
    LP: PTrialLabel;
begin
    Obj.GetBounds(R);
    R.Move(0, -1);
    LP:= New(PTrialLabel, Init(R, ALabel, @Obj));
    LP^.GrowTo(CStrLen(ALabel)+2, 1);
    aOwner^.Insert(LP);
    NewLabel:= LP;
end; {NewLabel}

{ TTrialLabel }

{*******************************************************}

{ TrialLabel }

constructor TTrialLabel.Init(var Bounds: TRect; AText: TTitleStr; ALink: PView);
begin
    inherited Init(Bounds, AText, ALink);
    if AText = '' then Hide;                                {+}
    DragMode:= dmLimitAll;
end; {TTrialLabel.Init}

procedure TTrialLabel.HandleEvent(var Event: TEvent);

begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then begin
            if Link <> nil then Link^.HandleEvent(Event);
        end else begin
            { move / re-size Label by dragging: }
            if Link <> nil then PutInFrontOf(Link);
            DragIt(Self, Event, Changed);

        end;
    end;
end; {TTrialLabel.HandleEvent}

procedure TTrialLabel.SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint);
var
    L: word;
begin
    inherited SizeLimits(MinSz, MaxSz);
    L:= CStrLen(Text^);
    MinSz.X:= L+1;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  MaxSz.Y:= 1;
end; {TTrialLabel.SizeLimits}

procedure TTrialLabel.GenCode(const LinkName: string; aLink: PView);
var
    R: TRect;
begin
    if Text <> nil then begin
        case CodeGen.GenPart of
         gpControls:
            begin
                CodeBounds(Self);
                writeln(Tab+'Insert(New(PLabel, Init(R, ''',
                    EscQuot(Text^), ''', ', LinkName, ')));'
                );
            end;

         gpClone:
            begin
                GetBounds(R);
                CodeGen.RealDialog^.Insert(New(PLabel, Init(R, Text^, aLink)));
            end;
        end; {case}
    end;
end; {TTrialLabel.GenCode}

procedure TTrialLabel.ChangeText(const ALabel: string);
var
    L: integer;
begin
    if ALabel <> '' then begin
        if Text = nil then begin        {add label}
            L:= 0;
            Origin.X:= Link^.Origin.X;
            Origin.Y:= Link^.Origin.Y-1;
            Text:= objects.NewStr(ALabel);
            Show;
        end else begin                  {change label}
            L:= CStrLen(GetStr(Text));
            ChangeStr(Text, ALabel);
            Draw;
        end;
        Dec(L, CStrLen(ALabel));
        if L <> 0 then GrowTo(Size.X-L, 1);
    end else begin                      {"delete" label}
        DisposeStr(Text);
        Hide;
    end;
end; {TTrialLabel.ChangeText}

{ Move label after target (Link^) is dragged: }
{ (OldX,OldY is Link^.Origin before dragging) }
procedure TTrialLabel.TrackTarget(const OldR: TRect);
var
    SX, SY: integer;
begin
    { is Label at right of target? }
    if Origin.X + (Size.X div 2) > (OldR.A.X + OldR.B.X) div 2
    then SX:= Link^.Size.X + OldR.A.X - OldR.B.X else SX:= 0;
    { is Label below target? }
    if Origin.Y > (OldR.A.Y + OldR.B.Y) div 2
    then SY:= Link^.Size.Y + OldR.A.Y - OldR.B.Y else SY:= 0;
    MoveTo(Origin.X + Link^.Origin.X + SX - OldR.A.X,
           Origin.Y + Link^.Origin.Y + SY - OldR.A.Y);
end; {TTrialLabel.TrackTarget}




end.

