unit DialEditBFctn;

{$mode objfpc}{$H+}

interface

uses Objects,Drivers,Views,DialEditBase;

procedure DragIt(var View: TView; var Event: TEvent;var Changed:boolean);
procedure DragBoth(var View: TView; LabelP: PTrackTargetLabel;
                    var Event: TEvent;var Changed:boolean);
procedure CodeBounds(const View: TView);
procedure InitBounds(const aDialog:PGroup; out R: TRect; SX, SY: integer);

procedure CopyStrings(Dest, Src: PStringCollection);
procedure SplitStrings(DestL, DestR, Src: PStringCollection);
procedure JoinStrings(Dest, SrcL, SrcR: PStringCollection);
procedure InitStrings(var ClusterData: TClusterData);

function EscQuot(S: string): string;

function GetVal(SP: PString): word;

implementation

uses TVinput;
{ move / re-size trial object by dragging: }
{ also clear Event }
procedure DragIt(var View: TView; var Event: TEvent;var Changed:boolean);
var
    Lims: TRect;
    MinSz, MaxSz: TPoint;
    D: byte;
begin
    with View do begin
        Owner^.GetExtent(Lims);
        Lims.Grow(-1,-1);
        SizeLimits(MinSz{%H-}, MaxSz{%H-});
        case Event.Buttons of
         mbLeftButton: D:= dmDragMove;
         mbRightButton: D:= dmDragGrow;
        end;
        DragView(Event, D or DragMode, Lims, MinSz, MaxSz);
        Changed:= true;
        ClearEvent(Event);
    end;
end; {DragIt}

{ move / re-size trial object by dragging: }
{ also move its label and clear Event }
procedure DragBoth(var View: TView; LabelP: PTrackTargetLabel; var Event: TEvent;
  var Changed: boolean);
var
    OldR: TRect;
begin
    View.GetBounds(OldR);  {save old bounds}
    DragIt(View, Event,changed);
    if assigned(LabelP) then LabelP^.TrackTarget(OldR);
end; {DragBoth}

procedure CodeBounds(const View: TView);
begin
    with View do begin
        writeln(Tab+'R.Assign(',
            Origin.X, ', ',
            Origin.Y, ', ',
            Origin.X + Size.X, ', ',
            Origin.Y + Size.Y, ');'
        );
    end;
end; {CodeBounds}

procedure InitBounds(const aDialog:PGroup; out R: TRect; SX, SY: integer);
var
    PX, PY: integer;
begin
    PX:= aDialog^.Size.X - 2;
    PY:= aDialog^.Size.Y - 2;
    R.Assign(PX-SX, PY-SY, PX, PY);
end; {InitBounds}


procedure CopyStrings(Dest, Src: PStringCollection);
var
    I: integer;
    S: objects.Pstring;
begin
    if Dest = nil then New(Dest, Init(16, 16));         {++}
    Dest^.FreeAll;
    if Src <> nil then begin
        for I:= 0 to Src^.Count-1 do begin
            S:= Src^.At(I);
            Dest^.AtInsert(I, NewStr(S^));
        end;
    end;
end; {CopyStrings}

procedure SplitStrings(DestL, DestR, Src: PStringCollection);
var
    I, J: integer;
    S: string;
begin
    if DestL = nil then exit;   {++ then error! ++}
    if DestR = nil then exit;
    DestL^.FreeAll;
    DestR^.FreeAll;
    if Src <> nil then begin
        for I:= 0 to Src^.Count-1 do begin
            S:= GetStr(Src^.At(I));
            J:= Pos('`', S);
            if J > 0 then begin
                DestL^.AtInsert(I, NewStr(Copy(S,1,J-1)));
                DestR^.AtInsert(I, NewStr(Copy(S,J+1,255)));
            end else begin
                DestL^.AtInsert(I, NewStr(S));
                DestR^.AtInsert(I, NewStr(''));
            end;
        end;
    end;
end; {SplitStrings}

procedure JoinStrings(Dest, SrcL, SrcR: PStringCollection);
var
    I: integer;
    SL, SR: string;
begin
    if Dest = nil then exit;    {++ then error! ++}
    Dest^.FreeAll;
    if (SrcL <> nil) and (SrcR <> nil) then begin
        for I:= 0 to SrcL^.Count-1 do begin
            SL:= GetStr(SrcL^.At(I));
            SR:= GetStr(SrcR^.At(I));
            if Length(SR) > 0 then begin
                Dest^.AtInsert(I, NewStr(SL+'`'+SR));
            end else begin
                Dest^.AtInsert(I, NewStr(SL));
            end;
        end;
    end;
end; {JoinStrings}

procedure InitStrings(var ClusterData: TClusterData);
begin
    with ClusterData do begin
        RStrings:= New(PStringCollection, Init(16, 16));
        RItemNames:= New(PStringCollection, Init(16, 16));
        if ModeToken^.State and sfPaste <> 0 then begin
            CopyStrings(RStrings, PasteStrings);
            CopyStrings(RItemNames, PasteNames);
        end else begin
            { insert edit position: }
            with RStrings^ do AtInsert(Count, NewStr(' '));
        end;
    end;
end; {InitStrings}

{ escape any single-quotes in a string: }
{ need to use this when putting literal }
{ strings into Pascal code output       }

function EscQuot(S: string): string;
var
    I: integer;
begin
    for I:= Length(S) downto 1 do begin
        if S[I] = ''''
        then System.Insert('''', S, I);
    end;
    EscQuot:= S;
end; {EscQuot}

function GetVal(SP: PString): word;
var
    S: string;
begin
    S:= upcase(GetStr(SP));
    if      S = 'CMOK'      then GetVal:= cmOk
    else if S = 'CMCANCEL'  then GetVal:= cmCancel
    else if S = 'CMYES'     then GetVal:= cmYes
    else if S = 'CMNO'      then GetVal:= cmNo
    else if S = 'CMHELP'      then GetVal:= cmHelp
    else GetVal:= cmError;
end; {GetVal}


end.

