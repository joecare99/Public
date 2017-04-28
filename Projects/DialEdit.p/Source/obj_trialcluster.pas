unit obj_TrialCluster;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  Objects, Views, dialogs, Drivers,App,

  DialEditBase, DialEditBFctn,
  Obj_EditControlDlg, TVinput,dialeditDefaults, obj_TrialLabel;

type
     { TrialCluster }  { shared by 3 descendant trial objects }

      PItemData = ^TItemData;
      TItemData = packed record
          Name: TTitleStr;    {optional name for item value}
          Strg: TTitleStr;    {dialog text for cluster item}
      end;

      PItemDialog = ^TItemDialog;
      TItemDialog = object(TDialog)
          constructor Init(T: TTitleStr; FocusName: boolean);
      end;

      PClusterDialog = ^TClusterDialog;
      TClusterDialog = object(TControlEditDialog)
          StrgList: PListBox;
          NameList: PListBox;
          FocusName: boolean;
          constructor Init(aDialog: PGroup; Change: boolean; ShortName: TShortName);
          procedure HandleEvent(var Event: TEvent); virtual;
      end;
      { ClusterDialog.StrgList^.List = @Cluster.Strings }
      { ClusterDialog.NameList^.List = names for item values }


      { TTrialCluster }

      PTrialCluster = ^TTrialCluster;
      TTrialCluster = object(TView)
          DataName: PString;
          ShortName: TShortName;
          ItemNames: TStringCollection;
          constructor Init(AData: PClusterData; var CL: TCluster);
          constructor Load(var S: TStream);
          constructor Load01(var S: TStream);
          destructor Done; virtual;

          procedure Resize(var CL: TCluster; LabelP: PTrialLabel);
                              virtual;
          procedure GenCode(var CL: TCluster; out zLink: PView); virtual;
          procedure HandleEvent(var Event: TEvent; CL: PCluster;
                              LabelP: PTrialLabel); virtual;overload;
          procedure Convert01(var CL: TCluster);
          procedure Store(var S: TStream); virtual;
      end;

implementation

{ Cluster-related objects }

{ ItemDialog }

constructor TItemDialog.Init(T: TTitleStr; FocusName: boolean);
var
    R: TRect;
    ILN, ILT: PInputLine;
begin
    R.Assign(21, 24, 47, 38);
    inherited Init(R, T+' Item');

    R.Assign(3, 4, 20, 5);
    ILN:= New(PInputLine, Init(R, 80));  Insert(ILN);
    R.Assign(3, 3, 15, 4);
    Insert(New(PLabel, Init(R, 'Value ~N~ame', ILN)));
    R.Assign(20, 4, 23, 5);
    Insert(New(PHistory, Init(R, ILN, hiDataName)));

    R.Assign(3, 7, 20, 8);
    ILT:= New(PInputLine, Init(R, 80));  Insert(ILT);
    R.Assign(3, 6, 14, 7);
    Insert(New(PLabel, Init(R, 'Item ~T~ext', ILT)));
    R.Assign(20, 7, 23, 8);
    Insert(New(PHistory, Init(R, ILT, hiLabelText)));

    R.Assign(2, 10, 12, 12);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

    R.Assign(13, 10, 23, 12);
    Insert(New(PButton, Init(R, '~O~k', cmOK, bfDefault)));

    if FocusName then ILN^.Focus else ILT^.Focus;
end; {TItemDialog.Init}

{ ClusterDialog }

constructor TClusterDialog.Init(aDialog:PGroup; Change: boolean; ShortName: TShortName);
var
    R: TRect;
    SB: PScrollBar;
    IL: PInputLine;
    DT: TTitleStr;
    SY: integer;
const
    SX = 36;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
//    X3 = SX div 2;
begin
    if Change then begin
        SY:= 32;  DT:= 'Change';
    end else begin
        SY:= 29;  DT:= 'New';
    end;

    if ShortName = 'CB' then begin
        DT:= DT + ' CheckBoxes';
    end else if ShortName = 'MB' then begin
        DT:= DT + ' MultiCheckBoxes';
        inc(SY, 3);
    end else begin  {= 'RB'}
        DT:= DT + ' RadioButtons';
    end;

    R.Assign(0, 0, SX, SY);
    inherited Init(aDialog, R, DT);
    FocusName:= false;

    {MakeDialogNames(SX);}                                  {+++++}

    R.Assign(3, 4, 14, 5);
    IL:= New(PInputLine, Init(R, 80));  Insert(IL);
    R.Assign(3, 3, 10, 4);
    Insert(New(PLabel, Init(R, '~L~abel', IL)));
    R.Assign(14, 4, 17, 5);
    Insert(New(PHistory, Init(R, IL, hiLabelText)));

    R.Assign(19, 4, 30, 5);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(19, 3, 30, 4);
    Insert(New(PLabel, Init(R, 'Data ~N~ame', IL)));
    R.Assign(30, 4, 33, 5);
    Insert(New(PHistory, Init(R, IL, hiDataName)));

    R.Assign(18, 7, 19, 17);
    SB:= New(PScrollBar, Init(R));  Insert(SB);
    R.Assign(3, 7, 18, 17);
    StrgList:= New(PListBox, Init(R, 1, SB));  Insert(StrgList);
    R.Assign(3, 6, 14, 7);
    Insert(New(PLabel, Init(R, 'Item ~T~ext', StrgList)));

    R.Assign(32, 7, 33, 17);
    SB:= New(PScrollBar, Init(R));  Insert(SB);
    R.Assign(20, 7, 32, 17);
    NameList:= New(PListBox, Init(R, 1, SB));  Insert(NameList);
    R.Assign(20, 6, 33, 7);
    Insert(New(PLabel, Init(R, 'Value ~N~ames', NameList)));

    R.Assign(3, 18, 17, 20);
    Insert(New(PButton, Init(R, '~ ~Edit Item', cmEditItem, bfNormal)));

    R.Assign(19, 18, 33, 20);
    Insert(New(PButton, Init(R, '~N~ew Item', cmNewItem, bfDefault)));

    if ShortName = 'MB' then begin
        R.Assign(3, 21, 23, 22);
        IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
        R.Assign(3, 20, 16, 21);
        Insert(New(PLabel, Init(R, 'State ~C~odes', IL)));
        R.Assign(23, 21, 26, 22);
        Insert(New(PHistory, Init(R, IL, hiStates)));
    end;

    MakeDialogButtons(X1, X2, SY, Change, bfNormal);
    StrgList^.Focus;
end; {TClusterDialog.Init}

procedure TClusterDialog.HandleEvent(var Event: TEvent);
var
    ItemData: TItemData;
    Foc: integer;

    procedure NewName;
    begin
        with StrgList^ do begin
            if (ItemData.Strg <> '') and (ItemData.Strg[1] <> ' ') then
            List^.AtInsert(Focused, NewStr(ItemData.Strg));
            SetRange(List^.Count);
            Foc:= Focused;
            FocusItem(Succ(Focused));
            Draw;
        end;
        with NameList^ do begin
            if (ItemData.Strg <> '') and (ItemData.Strg[1] <> ' ') then
            List^.AtInsert(Foc, NewStr(ItemData.Name));
            SetRange(List^.Count);
            FocusItem(Succ(Foc));
            Draw;
        end;
    end; {NewName}

    procedure EditName;
    begin
        ItemData.Strg:= PString(StrgList^.List^.At(StrgList^.Focused))^;
        if ItemData.Strg <> ' ' then begin
            ItemData.Name:= GetStr(NameList^.List^.At(StrgList^.Focused));
            if Application^.ExecuteDialog(New(PItemDialog,
                    Init('Change', FocusName)), @ItemData) = cmOK
            then begin
                Foc:= StrgList^.Focused;
                StrgList^.List^.AtFree(Foc);
                NameList^.List^.AtFree(Foc);
                NewName;
            end;
        end;
    end; {EditName}

begin
    inherited HandleEvent(Event);
    case Event.What of
     evCommand:
        case Event.Command of
         cmNewItem:
            begin
                ItemData.Strg:= '';
                ItemData.Name:= '';
                if Application^.ExecuteDialog(New(PItemDialog,
                        Init('New', FocusName)), @ItemData) = cmOK
                then NewName;
            end;

         cmEditItem: EditName;

         else exit;
        end; {case}

     evBroadcast:
        case Event.Command of
         cmListItemSelected:
            if Event.InfoPtr = StrgList then begin
                FocusName:= false;
                EditName;
            end else if Event.InfoPtr = NameList then begin
                FocusName:= true;
                EditName;
            end else exit;

        end; {case}

     else exit;
    end; {case}
    ClearEvent(Event);
end; {TClusterDialog.HandleEvent}

{ TrialCluster }

constructor TTrialCluster.Init(AData: PClusterData; var CL: TCluster);
begin
    with AData^, CL do begin
        DragMode:= dmLimitAll;
        Value:= 1;  {for demo look}
        DataName:= NewStr(RDataName);
        ShortName:= RShortName;
        with Strings do begin
            Delta:= 16;
            SetLimit(16);
        end;
        ItemNames.Init(16, 16);
        with RStrings^ do AtFree(Count-1);  {delete edit position}
        CopyStrings(@Strings, RStrings);
        CopyStrings(@ItemNames, RItemNames);
    end;
end; {TTrialCluster.Init}

destructor TTrialCluster.Done;
begin
    DisposeStr(DataName);
    ItemNames.Done;
    inherited Done;
end; {TTrialCluster.Done}

procedure TTrialCluster.GenCode(var CL: TCluster; out zLink: PView);
var
    LN: string;
    I: integer;
    J: longint;
    MCB: PMultiCheckBoxes;
//    TD: PGroup;
    R: TRect;
    SI: PSItem;
    S: shortstring;

//type
//    PLong = ^longint;
//    PWord = ^word;

begin {TTrialCluster.GenCode}
  zLink:=nil;
    Convert01(CL);  {update old version if needed}
    case CodeGen.GenPart of
     gpDataFields:
        begin
            write(Tab+Tab, GetStr(DataName));
//            TD:= PGroup(CL.Owner);
            if ShortName = 'CB' then begin
                if CL.Strings.Count > 16 then begin
                    writeln(': longint;');
                    writeln(Tab+Tab+'{+ Need to override DataSize +}');
                                    {.. and GetData and SetData}    {++}
                end else begin
                    writeln(': word;');
                end;
//                with TD^ do
CodeGen.GenVars:= CodeGen.GenVars or gvCheckBoxes;
            end else if ShortName = 'MB' then begin
                writeln(': longint;');
//                with TD^ do
CodeGen.GenVars:= CodeGen.GenVars or gvMultiCheckBoxes;
            end else begin  {= 'RB'}
                writeln(': word;');
//                with TD^ do
CodeGen.GenVars:= CodeGen.GenVars or gvRadioButtons;
            end;

            with ItemNames do begin
                for I:= 0 to Count-1 do begin
                    if At(I) <> nil then CodeGen.ListClustConsts:= true;
                end;
            end;
        end;

     gpDataConsts:
        begin
            if CodeGen.ListClustConsts then
            with ItemNames do begin
                for I:= 0 to Count-1 do begin
                    S:= GetStr(At(I));
                    if S <> '' then begin
                        write(Tab, S, ' ='+Tab);
                        if ShortName = 'CB' then begin
                            J:= 1;  J:= J shl I;
                            FormatStr(S, '$%x;', J);
                        end else if ShortName = 'MB' then begin
                            MCB:= PMultiCheckBoxes(@CL);
                            case MCB^.Flags of
                             cfTwoBits:
                                begin
                                    J:= $3;  J:= J shl (2*I);
                                end;
                             cfFourBits:
                                begin
                                    J:= $F;  J:= J shl (4*I);
                                end;
                             cfEightBits:
                                begin
                                    J:= $FF;  J:= J shl (8*I);
                                end;
                             else
                                begin
                                    J:= $1;  J:= J shl I;
                                end;
                            end; {case}
                            FormatStr(S, '$%x;', J);
                        end else begin {RB}
                            J:= I;
                            FormatStr(S, '%d;', J);
                        end;
                        write(S);
                        if I = 0
                        then write('  {', GetStr(DataName), ' values}');
                        writeln;
                    end;
                end;
            end;
        end;

     gpDataValues:
        begin
            if CodeGen.Semicolon then writeln(';');
            CodeGen.Semicolon:= true;
            write(Tab+Tab, GetStr(DataName), ': ');
 //           TD:= PGroup(CL.Owner);
            if ShortName = 'RB' then begin
                write(CL.Value);
            end else begin
                FormatStr(S, '$%x', CL.Value);
                write(S);
            end;
        end;

     gpControls:
        begin
            writeln;
            CodeBounds(CL);
            if ShortName = 'CB' then begin
                LN:= 'CheckBoxes';
            end else if ShortName = 'MB' then begin
                LN:= 'MultiCheckBoxes';
            end else begin  {= 'RB'}
                LN:= 'RadioButtons';
            end;
            writeln(Tab, ShortName, ':= New(P', LN, ', Init(R,');

            with CL.Strings do begin
                for I:= 0 to Count-1 do begin
                    S:= GetStr(At(I));
                    writeln(Tab+Tab+'NewSItem(''', EscQuot(S), ''',');
                end;

                write(Tab+Tab+'nil');
                for I:= 1 to Count do write(')');
                if ShortName = 'MB' then begin
                    MCB:= PMultiCheckBoxes(@CL);
                    write(', ', MCB^.SelRange);
                    case MCB^.Flags of
                     cfTwoBits:
                        begin
                            LN:= 'cfTwoBits';
                            I:= 2*Count;
                        end;
                     cfFourBits:
                        begin
                            LN:= 'cfFourBits';
                            I:= 4*Count;
                        end;
                     cfEightBits:
                        begin
                            LN:= 'cfEightBits';
                            I:= 8*Count;
                        end;
                     else
                        begin
                            LN:= 'cfOneBit';
                            I:= Count;
                        end;
                    end; {case}
                    write(', ', LN);
                    write(', ''', EscQuot(GetStr(MCB^.States)));
                    writeln('''));');
                    writeln(Tab+'Insert(', ShortName, ');');
                    if I > 32 then begin
                        writeln('{+ WARNING: ', I, ' bits needed! +}');
                    end;

                end else begin
                    writeln;
                    write(Tab+'));');
                    writeln('  Insert(', ShortName, ');');
                end;
            end;
        end;

     gpClone:
        begin
            CL.GetBounds(R);
            with CL.Strings do begin
                SI:= nil;
                for I:= Count-1 downto 0 do begin
                    S:= GetStr(At(I));
                    SI:= NewSItem(S, SI);
                end;
            end;
            if ShortName = 'CB' then begin
                zLink:= New(PCheckBoxes, Init(R, SI));
            end else if ShortName = 'MB' then begin
                MCB:= PMultiCheckBoxes(@CL);
                zLink:= New(PMultiCheckBoxes, Init(R, SI,
                    MCB^.SelRange, MCB^.Flags, GetStr(MCB^.States)));
            end else begin  {= 'RB'}
                zLink:= New(PRadioButtons, Init(R, SI));
            end;
            CodeGen.RealDialog^.Insert(zLink);
        end;
    end; {case}
end; {TTrialCluster.GenCode}

{ Set size to accomodate label and names: }
procedure TTrialCluster.Resize(var CL: TCluster; LabelP: PTrialLabel);
var
    I, J, XS, YS: integer;
//    P: PString;
begin
    with CL.Strings do begin
        XS:= CStrLen(GetStr(LabelP^.Text)) - 4;
        for I:= 0 to Count-1 do begin
            J:= CStrLen(GetStr(PString(At(I))));
            if J > XS then XS:= J;
        end;
        inc(XS, 6);
        YS:= Count;
        if YS = 0 then YS:= 1;
        CL.GrowTo(XS, YS);
        CL.Draw;
    end;
end; {TTrialCluster.ReSize}

procedure TTrialCluster.HandleEvent(var Event: TEvent; CL: PCluster;
                                LabelP: PTrialLabel);
var
    PD: PDialog;
    ClusterData: TClusterData;
    N: integer;
    MCB: PMultiCheckBoxes;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        Convert01(CL^); {update old version if needed}
        if Event.Double then begin
            { save data before editing: }
            with ClusterData, CL^ do begin
                RDataName:= GetStr(DataName);
                RLabel:= GetStr(LabelP^.Text);
                RStrings:= New(PStringCollection, Init(16, 16));
                RItemNames:= New(PStringCollection, Init(16, 16));
                CopyStrings(RStrings, @Strings);
                CopyStrings(RItemNames, @ItemNames);
                RFocused:= Strings.Count;
                RNFocused:= Strings.Count;
                N:= RFocused;
                { insert edit position: }
                with RStrings^ do AtInsert(Count, NewStr(' '));
                if ShortName = 'MB' then begin
                    MCB:= PMultiCheckBoxes(CL);
                    RStates:= GetStr(MCB^.States);
                end;
            end;

            { edit Cluster with ClusterDialog: }
            PD:= PDialog(New(PClusterDialog, Init(self.owner, true, ShortName)));
            Cmd:= application^.ExecuteDialog(PD, @ClusterData);

            case Cmd of
             cmOK, cmPutOnTop:
                with ClusterData, CL^ do begin
                    LabelP^.ChangeText(RLabel);
                    ChangeStr(DataName, RDataName);
                    if ShortName = 'MB' then with MCB^ do begin
                        ChangeStr(States, RStates);
                        SelRange:= Length(RStates);
                        case SelRange of
                          2:        Flags:= cfOneBit;
                          3..4:     Flags:= cfTwoBits;
                          5..16:    Flags:= cfFourBits;
                          17..255:  Flags:= cfEightBits;
                          else begin
                            ChangeStr(States, ' X');
                            SelRange:= 2;
                            Flags:= cfOneBit;
                          end;
                        end; {case}
                    end;
                    with RStrings^ do AtFree(Count-1);  {delete edit pos'n}
                    CopyStrings(@Strings, RStrings);
                    CopyStrings(@ItemNames, RItemNames);
                    if Cmd = cmPutOnTop then begin
                        CL^.MakeFirst;
                        LabelP^.MakeFirst;
                    end;
                    if Strings.Count <> N then Resize(CL^, LabelP);
                    Draw;
                    Changed:= true;
                end;

             cmDelete:
                begin
                    if LabelP <> nil then LabelP^.Free;
                    CL^.Free;
                    Changed:= true;
                end;

             cmSetDefault:
                begin
                    ClusterData.RFocused:= 0;
                    ClusterData.RNFocused:= 0;
                    if ShortName = 'RB'
                    then Default.DRadioButtons:= ClusterData
                    else if ShortName = 'CB'
                    then Default.DCheckBoxes:= ClusterData
                    else if ShortName = 'MB'
                    then Default.DMultiCheckBoxes:= ClusterData;
                end;

             cmSetPaste:
                begin
                    ClusterData.RFocused:= 0;
                    ClusterData.RNFocused:= 0;
                    if ShortName = 'RB'
                    then Paste.DRadioButtons:= ClusterData
                    else if ShortName = 'CB'
                    then Paste.DCheckBoxes:= ClusterData
                    else if ShortName = 'MB'
                    then Paste.DMultiCheckBoxes:= ClusterData;
                    CopyStrings(PasteStrings, ClusterData.RStrings);
                    CopyStrings(PasteNames, ClusterData.RItemNames);
                end;

             {else cmCancel}
            end;

            Dispose(ClusterData.RStrings,done);
            Dispose(ClusterData.RItemNames,Done);
            CL^.ClearEvent(Event);
        end else begin
            { move / re-size Cluster & Label by dragging: }
            DragBoth(CL^, LabelP, Event, Changed);
        end;
    end;
end; {TTrialCluster.HandleEvent}

procedure TTrialCluster.Convert01(var CL: TCluster);
var
    I: integer;
begin
    with CL.Strings do begin
        if Count = ItemNames.Count then exit;
        if (Count = ItemNames.Count+1)
            and (GetStr(At(Count-1)) = ' ') then exit;
        for I:= 0 to Count-1 do begin
            ItemNames.AtInsert(I, NewStr(GetStr(At(I))));
        end;
    end;
end; {TTrialCluster.Convert01}

{ old version; set default ItemNames }
constructor TTrialCluster.Load01(var S: TStream);
begin
    DataName:= S.ReadStr;
    S.Read(ShortName, SizeOf(TShortName));
    ItemNames.Init(16, 16);
end; {TTrialCluster.Load}

constructor TTrialCluster.Load(var S: TStream);
begin
    DataName:= S.ReadStr;
    S.Read(ShortName, SizeOf(TShortName));
    ItemNames.Load(S);
end; {TTrialCluster.Load}

procedure TTrialCluster.Store(var S: TStream);
begin
    S.WriteStr(DataName);
    S.Write(ShortName, SizeOf(TShortName));
    ItemNames.Store(S);
end; {TTrialCluster.Store}

end.

