unit obj_DialEditApp;

interface

uses  sysutils,

  Objects, Drivers, Memory, Views, Menus, Dialogs,
  StdDlg, MsgBox, App, Gadgets, HistList,

  TVinput, Params, obj_TrialLabel, DialEditBase, DialEditBFctn,
  obj_TrialStaticText, Obj_EditControlDlg, dialeditDefaults, str_statictextdata,
  str_InputLineData, Str_DialogData, str_ParamTextData, str_ButtonData,
  str_ListBoxData, str_OutOptData, obj_TrialParamText, obj_trialbutton,
  obj_TrialInputLine, obj_TrialCluster ;

const
    CopyNote = 'DialEdit 8-14-95 (C) J.M.Clark';

type

      PTrialRadioButtons = ^TTrialRadioButtons;

      { TTrialRadioButtons }

      TTrialRadioButtons = object(TRadioButtons)
          LabelP: PTrialLabel;
          TC: TTrialCluster;
          constructor Init(aOwner: Pgroup; AData: PClusterData);
          destructor Done; virtual;
          function Execute: word; virtual;
          procedure HandleEvent(var Event: TEvent); virtual;
          procedure SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint); virtual;
          constructor Load(var S: TStream);
          procedure Store(var S: TStream); virtual;
      end;

      PTrialCheckBoxes = ^TTrialCheckBoxes;

      { TTrialCheckBoxes }

      TTrialCheckBoxes = object(TCheckBoxes)
          LabelP: PTrialLabel;
          TC: TTrialCluster;
          constructor Init(aOwner: Pgroup; AData: PClusterData);
          destructor Done; virtual;
          function Execute: word; virtual;
          procedure HandleEvent(var Event: TEvent); virtual;
          procedure SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint); virtual;
          constructor Load(var S: TStream);
          procedure Store(var S: TStream); virtual;
      end;


      { TTrialMultiCheckBoxes }

      PTrialMultiCheckBoxes = ^TTrialMultiCheckBoxes;
      TTrialMultiCheckBoxes = object(TMultiCheckBoxes)
          LabelP: PTrialLabel;
          TC: TTrialCluster;
          constructor Init(aOwner: Pgroup;AData: PClusterData);
          destructor Done; virtual;
          function Execute: word; virtual;
          procedure HandleEvent(var Event: TEvent); virtual;
          procedure SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint); virtual;
          constructor Load(var S: TStream);
          procedure Store(var S: TStream); virtual;
      end;

  { TrialListBox }

      PListBoxDialog = ^TListBoxDialog;
      TListBoxDialog = object(TControlEditDialog)
          constructor Init(aOwner: Pgroup; Change: boolean);
      end;

      PTrialScrollBar = ^TTrialScrollBar;

      { TTrialScrollBar }

      TTrialScrollBar = object(TScrollBar)
          Link: PView;
          constructor Init(Bounds: TRect; ALink: PView);
          procedure HandleEvent(var Event: TEvent); virtual;
          procedure SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint); virtual;
          procedure GenCode;
          procedure TrackTarget(const OldR: TRect);
          constructor Load(var S: TStream);
          procedure Store(var S: TStream); virtual;
      end;

      PTrialListBox = ^TTrialListBox;

      { TTrialListBox }

      TTrialListBox = object(TListBox)
          LabelP: PTrialLabel;
          ListName: PString;
          SelectName: PString;
          constructor Init(aOwner: PGroup; AData: PListBoxData);
          destructor Done; virtual;
          function Execute: word; virtual;
          procedure HandleEvent(var Event: TEvent); virtual;
          procedure SetState(AState: word; Enable: boolean); virtual;
          procedure SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint); virtual;
          constructor Load(var S: TStream);
          procedure Store(var S: TStream); virtual;
      end;

  { TrialDialog }

      PDialogDialog = ^TDialogDialog;
      TDialogDialog = object(TControlEditDialog)
          constructor Init(aDialog: Pgroup; Change: boolean);
      end;

  type
      PTrialDialogBackground = ^TTrialDialogBackground;
      TTrialDialogBackground = object(TView)
          Patterned: boolean;
          constructor Init(Bounds: TRect);
          procedure Draw; virtual;
          procedure HandleEvent(var Event: TEvent); virtual;
          constructor Load(var S: TStream);
          procedure Store(var S: TStream); virtual;
      end;

      PTrialDialog = ^TTrialDialog;
      TTrialDialog = object(TDialog)
          BaseName: PString;
          TypeName: PString;
          Background: PTrialDialogBackground;
          Centered: boolean;
          GenDefaults: boolean;
          constructor Init(AData: PDialogData);
          destructor Done; virtual;
          procedure Close; virtual;
          procedure GenCode; virtual;
          procedure SnapPicture(AShow, APattern: word); virtual;
          procedure HandleEvent(var Event: TEvent); virtual;
          procedure SetState(AState: word; Enable: boolean); virtual;
          constructor Load01(var S: TStream);
          constructor Load(var S: TStream);
          procedure Store(var S: TStream); virtual;
      end;

  { FetchDialogDialog }

      PFetchDialogDialog = ^TFetchDialogDialog;
      TFetchDialogDialog = object(TDialog)
          ListBox: PListBox;
          Plural: boolean;
          constructor Init(APlural: boolean);
          procedure HandleEvent(var Event: TEvent); virtual;
      end;

  //    PFetchDialogData = ^TFetchDialogData;
      TFetchDialogData = packed record
          RNames: PStringCollection;
          RSelection:  word;      {for single mode}
      end;

  { FileOptDialog }

      PFileOptDialog = ^TFileOptDialog;
      TFileOptDialog = object(TDialog)
          constructor Init;
      end;

  //    PFileOptData = ^TFileOptData;
      TFileOptData = record
          CodeFName: TTitleStr;
          CollFName: TTitleStr;
          HistFName: TTitleStr;
      end;

  { OutOptDialog }

      POutOptDialog = ^TOutOptDialog;
      TOutOptDialog = object(TDialog)
          constructor Init;
      end;

  type
      PToken = ^TToken;
      TToken = object(TView)
          Kind: char;  {m = mode; s = swap}
          constructor Init(Bounds: TRect; AKind: char);
          procedure Draw; virtual;
          procedure SetState(AState: word; Enable: boolean); virtual;
          procedure Update; virtual;
          procedure HandleEvent(var Event: TEvent); virtual;
      end;

  { TDialEditApp }

      { supporting routines linked to Params unit:
          ShowUsage
          SetOpt
          DoFile
          AppDone
      }

  //    PDialEditApp = ^TDialEditApp;
      TDialEditApp = object(TApplication)
          Clock: PClockView;
  {$IFNDEF VPASCAL}
          Heap: PHeapView;
  {$ENDIF}
          constructor Init;
          destructor Done; virtual;
          procedure InitScreen; virtual;
          procedure InitMenuBar; virtual;
          procedure InitStatusLine; virtual;
          { supporting local routines:
              NewDialog
              NewStaticText
              NewParamText
              NewButton
              NewInputLine
              NewRadioButtons
              NewCheckBoxes
              NewMultiChecfkBoxes
              NewListBox
              SnapIt
              SetFiles
          }
          procedure HandleEvent(var Event: TEvent); virtual;
          procedure Idle; virtual;
          procedure OutOfMemory; virtual;
          procedure GenCode(ATrialDialog: PTrialDialog); virtual;
      end;

  {*******************************************************}
  {                                                       }
  {           Stream Registration Records                 }
  {                                                       }
  {*******************************************************}

  const
      RTrialStaticText: TStreamRec = (
          ObjType: 1102;
          VmtLink: Ofs(TypeOf(TTrialStaticText)^);
          Load: @TStaticText.Load;        {using ancestor's load}
          Store: @TStaticText.Store{%H-}       {using ancestor's store}
      );

      RTrialParamText: TStreamRec = (
          ObjType: 1112;
          VmtLink: Ofs(TypeOf(TTrialParamText)^);
          Load: @TTrialParamText.Load;
          Store: @TTrialParamText.Store{%H-}
      );

      RTrialButton: TStreamRec = (
          ObjType: 1101;
          VmtLink: Ofs(TypeOf(TTrialButton)^);
          Load: @TTrialButton.Load;
          Store: @TTrialButton.Store{%H-}
      );

      RTrialHistory: TStreamRec = (
          ObjType: 1113;
          VmtLink: Ofs(TypeOf(TTrialHistory)^);
          Load: @THistory.Load;           {using ancestor's load}
          Store: @THistory.Store{%H-}          {using ancestor's store}
      );

      { old version; no History icon }
      RTrialInputLine01: TStreamRec = (
          ObjType: 1103;
          VmtLink: Ofs(TypeOf(TTrialInputLine)^);
          Load: @TTrialInputLine.Load01;  {convert old to new}
          Store: @Abstract                {can't use}
      {%H-});

      { newer version; has History ID # }
      RTrialInputLine02: TStreamRec = (
          ObjType: 1114;
          VmtLink: Ofs(TypeOf(TTrialInputLine)^);
          Load: @TTrialInputLine.Load02;  {convert old to new}
          Store: @Abstract                {can't use}
      {%H-});

      { newest version; has History ID string }
      RTrialInputLine: TStreamRec = (
          ObjType: 1115;
          VmtLink: Ofs(TypeOf(TTrialInputLine)^);
          Load: @TTrialInputLine.Load;
          Store: @TTrialInputLine.Store{%H-}
      );

      { old version; no ItemNames }
      RTrialCluster01: TStreamRec = (
          ObjType: 1104;
          VmtLink: Ofs(TypeOf(TTrialCluster)^);
          Load: @TTrialCluster.Load01;    {convert old to new}
          Store: @Abstract                {can't use}
      {%H-});

      { new version; has ItemNames }
      RTrialCluster: TStreamRec = (
          ObjType: 1117;
          VmtLink: Ofs(TypeOf(TTrialCluster)^);
          Load: @TTrialCluster.Load;
          Store: @TTrialCluster.Store{%H-}
      );

      RTrialRadioButtons: TStreamRec = (
          ObjType: 1106;
          VmtLink: Ofs(TypeOf(TTrialRadioButtons)^);
          Load: @TTrialRadioButtons.Load;
          Store: @TTrialRadioButtons.Store{%H-}
      );

      RTrialCheckBoxes: TStreamRec = (
          ObjType: 1105;
          VmtLink: Ofs(TypeOf(TTrialCheckBoxes)^);
          Load: @TTrialCheckBoxes.Load;
          Store: @TTrialCheckBoxes.Store{%H-}
      );

      RTrialMultiCheckBoxes: TStreamRec = (
          ObjType: 1111;
          VmtLink: Ofs(TypeOf(TTrialMultiCheckBoxes)^);
          Load: @TTrialMultiCheckBoxes.Load;
          Store: @TTrialMultiCheckBoxes.Store{%H-}
      );

      RTrialScrollBar: TStreamRec = (
          ObjType: 1109;
          VmtLink: Ofs(TypeOf(TTrialScrollBar)^);
          Load: @TTrialScrollBar.Load;
          Store: @TTrialScrollBar.Store{%H-}
      );

      RTrialListBox: TStreamRec = (
          ObjType: 1110;
          VmtLink: Ofs(TypeOf(TTrialListBox)^);
          Load: @TTrialListBox.Load;
          Store: @TTrialListBox.Store{%H-}
      );

      RTrialDialogBackground: TStreamRec = (
          ObjType: 1107;
          VmtLink: Ofs(TypeOf(TTrialDialogBackground)^);
          Load: @TTrialDialogBackground.Load;
          Store: @TTrialDialogBackground.Store{%H-}
      );

      { old version }
      RTrialDialog01: TStreamRec = (
          ObjType: 1108;
          VmtLink: Ofs(TypeOf(TTrialDialog)^);
          Load: @TTrialDialog.Load01; {convert to new}
          Store: @Abstract            {can't use}
      {%H-});

      { new version }
      RTrialDialog: TStreamRec = (
          ObjType: 1116;
          VmtLink: Ofs(TypeOf(TTrialDialog)^);
          Load: @TTrialDialog.Load;
          Store: @TTrialDialog.Store{%H-}
      );

      { ObjType: 1100..1117 }

var     DialEditApp:    TDialEditApp;   {this TApplication}

implementation



{*******************************************************}

{ Trial objects, and associated data and dialog objects:  }
{ The objects are implemented below in the same sequence. }

{ The Execute method of trial objects is overridden and }
{ used to generate code, because it is generic and not  }
{ otherwise used (trial objects are never modal).       }


procedure RegisterTrialObjects;
begin
    RegisterType(RTrialLabel);
    RegisterType(RTrialStaticText);
    RegisterType(RTrialParamText);
    RegisterType(RTrialButton);
    RegisterType(RTrialHistory);
    RegisterType(RTrialInputLine01);
    RegisterType(RTrialInputLine02);
    RegisterType(RTrialInputLine);
    RegisterType(RTrialCluster01);
    RegisterType(RTrialCluster);
    RegisterType(RTrialRadioButtons);
    RegisterType(RTrialCheckBoxes);
    RegisterType(RTrialMultiCheckBoxes);
    RegisterType(RTrialScrollBar);
    RegisterType(RTrialListBox);
    RegisterType(RTrialDialogBackground);
    RegisterType(RTrialDialog01);
    RegisterType(RTrialDialog);
end; {RegisterTrialObjects}

{*******************************************************}

{ Global data and objects }

var
    AutoSave:       boolean;    {save without asking}

    FileOptData:    TFileOptData;   {filename choices}
    OutOptData:     TOutOptData;    {output options}

    TrialDialog:    PTrialDialog;   {current trial dialog}
    CurrDialog:     TTitleStr;      {name of current dialog}
    PrevDialog:     TTitleStr;      {name of previous dialog}

    CollFile:       PResourceFile;  {collection of trial dialogs}
    CollFMode:      word;           {file mode of above}
    { also resource file for real dialogs ? }                       {++}

    SwapToken:      PToken;             {'icon' for swap command}

//     s: Tshortname ;
    { temporary variables for code generation: }
    ValUsed: boolean;       {validator used}
    SBLink: PScrollBar;
    ListClustConsts: boolean;   {Cluster const names used}


{*******************************************************}

procedure GenImplementation;
begin
    if OutOptData.GenFormat <> 0 then begin
        writeln('implementation');
        writeln;
        write('uses Menus');
        { TvInput needed for standard validators: }
        if ValUsed then write(', TvInput');
        writeln(';');
        writeln;
    end;
end; {GenImplementation}


const
    StreamBufSize = 1024;

procedure OpenCollFile;
{$IFNDEF FPC}
var
    F: file;
{$ENDIF}
begin
    {$IFDEF FPC}
      if FileExists(FileOptData.CollFName) then
        CollFMode:= stOpen
      else
        CollFMode:= stCreate;
    {$ELSE}
    Assign(F, FileOptData.CollFName);
    {$I-}
    Reset(F);
    if IoResult = 0 then
      CollFMode:= stOpen
    else
      CollFMode:= stCreate;
    Close(F);
    {$I+}
    {$ENDIF}
    CollFile:= New(PResourceFile, Init(
              New(PBufStream, Init(FileOptData.CollFName, CollFMode,
                    StreamBufSize))));
end; {OpenCollFile}

procedure CloseCollFile;
var
    S: PStream;
begin
    if CollFile = nil then exit;
    CollFile^.Flush;
    if CollFile^.Modified then begin
        { copy & pack to temporary BufStream: }
        S:= CollFile^.SwitchTo(New(
            PBufStream, Init('DialColl.tmp', stCreate, StreamBufSize)
        ), true);
        S^.Free;
        { copy back to original BufStream: }
        S:= CollFile^.SwitchTo(New(
            PBufStream, Init(FileOptData.CollFName, stCreate,
                    StreamBufSize)
        ), false);
        S^.Free;
    end;
    CollFile^.Free;
    CollFile:= nil;
end; {CloseCollFile}

procedure OpenCodeFile;
var
{$IFNDEF FPC}
    Dir:  DirStr;
    Ext:  ExtStr;
    {$ENDIF}
    Name: NameStr;

begin
    if CodeGen.GenPart = gpDisabled then begin
        Assign(Output, FileOptData.CodeFName);
        Rewrite(Output);
        CodeGen.GenPart:= gpFileHeader;
        if OutOptData.GenFormat <> 0 then begin
            {$IFNDEF FPC}
            FSplit(FileOptData.CodeFName, Dir, Name, Ext);
            {$ELSE}
            Name := ExtractFileName(FileOptData.CodeFName);
            {$ENDIF}
            writeln('unit ', Name, ';');
            writeln;
            writeln('interface');
            writeln;
            writeln('uses Objects, Views, Dialogs;');
            writeln;
        end;
    end;
end; {OpenCodeFile}

procedure CloseCodeFile;
begin
    if CodeGen.GenPart <> gpDisabled then begin
        if OutOptData.GenFormat <> 0 then begin
            CodeGen.GenPart:= gpFileFooter;
            writeln('begin end.');
        end;
        Close(Output);
        if FileOptData.CodeFName <> '' then
          begin
              Assign(Output, '');
              Rewrite(Output);
          end;
        CodeGen.GenPart:= gpDisabled;
    end;
end; {CloseCodeFile}

{ remember current and previous dialog names: }
procedure RemDialog(Name: string);
begin
    if Name = '' then begin
        Application^.DisableCommands([cmSwapDialogs]);
    end else if Name <> CurrDialog then begin
        if CurrDialog <> '' then PrevDialog:= CurrDialog;
        if PrevDialog <> ''
        then Application^.EnableCommands([cmSwapDialogs])
        else Application^.DisableCommands([cmSwapDialogs]);
    end;
    CurrDialog:= Name;
    Changed:= false;
end; {RemDialog}

procedure SaveDialog;
var
    S: string;
begin
    if TrialDialog = nil then exit;
    if CollFile = nil then OpenCollFile;
    if CollFile = nil then exit;
    { open resource file also }                                     {++}
    with TrialDialog^ do begin
        S:= GetStr(BaseName) + GetStr(TypeName);
    end;
    if (S = '') or (S[1] = ' ') then begin
        MessageBox('Dialog has no name.', nil, mfError+mfOkButton);
        exit;
    end;
    CollFile^.Put(TrialDialog, S);
    { put RealDialog into resource file }                           {++}
    { if AutoSave, we must avoid calling RemDialog twice: }
    if not AutoSave then RemDialog(S);
end; {SaveDialog}

procedure DeleteDialog;
var
    S: string;
    P: ^string;
begin
    if TrialDialog = nil then exit;
    if CollFile = nil then OpenCollFile;
    if CollFile = nil then exit;
    with TrialDialog^ do begin
        S:= GetStr(BaseName) + GetStr(TypeName);
    end;
    if (S = '') or (S[1] = ' ') then begin
        MessageBox('Dialog has no name.', nil, mfError+mfOkButton);
        exit;
    end;
    P:= @S;
    if MessageBox('Delete "%s"?', @P,
        mfConfirmation + mfYesButton + mfNoButton) = cmYes
    then begin
        CollFile^.Delete(S);
        { also delete from resource file }                          {++}
        RemDialog('');
    end;
end; {DeleteDialog}

procedure GetDialog(const Name: TTitleStr);
var
    PV: PTrialDialog;
begin
    if Name = '' then exit;
    if CollFile = nil then OpenCollFile;
    if CollFile = nil then exit;
    { open resource file also ? }                                   {++}
    with CollFile^ do begin
        Flush;
        PV:= PTrialDialog(Get(Name));
        if PV <> nil then begin
            if TrialDialog <> nil then begin
                TrialDialog^.Close;
                { Close disables commands; re-enable them: }
                Application^.EnableCommands(cmsNewControls);
            end;
            DeskTop^.Insert(PView(PV));
            TrialDialog:= PTrialDialog(PV);
            { also fetch from resource file ? }                     {++}
            RemDialog(Name);
        end;
    end;
end; {GetDialog}

{*******************************************************}
{                                                       }
{                   FetchDialog                         }
{                                                       }
{       'Plural' mode fetches & generates code for      }
{       one or more dialogs.  'Single' mode fetches     }
{       one dialog from CollFile and inserts it as      }
{       new TrialDialog for editing.                    }
{                                                       }
{*******************************************************}

procedure FetchDialog(Plural: boolean);
var
    I, J: integer;
    DD: TFetchDialogData;
    PV: PTrialDialog;
    S: string;
    GV: array[0..99] of word;                               {+}

begin
    if CollFile = nil then OpenCollFile;
    if CollFile = nil then exit;
    with CollFile^ do begin
        Flush;
        { copy strings from CollFile to DD.RNames: }
        if Count = 0 then exit;
        DD.RNames:= New(PStringCollection, Init(16, 16));
        for I:= 0 to Count-1 do begin
            S:= ' ' + KeyAt(I);
            DD.RNames^.AtInsert(I, NewStr(S));
        end;
        DD.RSelection:= 0;

        { pick dialog(s) to do: }
        if DialEditApp.ExecuteDialog(New(PFetchDialogDialog,
                Init(Plural)), @DD) = cmCancel
        then begin
            Dispose(DD.RNames, Done);
            exit;
        end;

        if Plural then begin
            { check if any picked: }
            J:= 0;
            for I:= 0 to DD.RNames^.Count-1 do begin
                S:= GetStr(DD.RNames^.At(I));
                if S[1] <> ' ' then inc(J);
            end;
            if J = 0 then begin
                MessageBox('No output selected.',
                    nil, mfError+mfOkButton);
                Dispose(DD.RNames, Done);
                exit;
            end;

            OpenCodeFile;   {open file if closed}

            { do pictures before code generation: }
            if OutOptData.RInclude and 1 <> 0 then begin
                if OutOptData.RInclude and 2 <> 0 then writeln('(*');
                if TrialDialog <> nil then begin
                    TrialDialog^.Close;
                    { Close disables commands }
                end;
                for I:= 0 to DD.RNames^.Count-1 do begin
                    S:= GetStr(DD.RNames^.At(I));
                    if S[1] <> ' ' then begin
                        System.Delete(S, 1, 1);
                        PV:= PTrialDialog(Get(S));
                        if PV <> nil then begin
                            DeskTop^.Insert(PView(PV));
                            with OutOptData
                            do PV^.SnapPicture(RShow, RShades);
                            { or, PV^.Close; }                      {+}
                            DeskTop^.Delete(PView(PV));
                            PV^.Free;
                        end;
                    end;
                end;
                if OutOptData.RInclude and 2 <> 0 then writeln('*)');
                writeln;
            end;

            if OutOptData.RInclude and 2 <> 0 then begin
                { first pass of code generation: }
                CodeGen.ListHistConsts:= false;
                ValUsed:= false;
                for I:= 0 to DD.RNames^.Count-1 do begin
                    S:= GetStr(DD.RNames^.At(I));
                    if S[1] <> ' ' then begin
                        System.Delete(S, 1, 1);
                        PV:= PTrialDialog(Get(S));
                        if PV <> nil then begin
                            CodeGen.GenPart:= gpDialogHeader;
                            PV^.GenCode;
                            GV[I]:= CodeGen.GenVars;
                            PV^.Free;
                        end;
                    end;
                end;

                GenImplementation;

                { extra pass of code generation: }
                if CodeGen.ListHistConsts then begin
                    writeln('const');
                    CodeGen.HistIdVal:= 1;
                    for I:= 0 to DD.RNames^.Count-1 do begin
                        S:= GetStr(DD.RNames^.At(I));
                        if S[1] <> ' ' then begin
                            System.Delete(S, 1, 1);
                            PV:= PTrialDialog(Get(S));
                            if PV <> nil then begin
                                CodeGen.GenPart:= gpHistConsts;
                                CodeGen.GenVars:= GV[I];
                                PV^.GenCode;
                                PV^.Free;
                            end;
                        end;
                    end;
                    writeln;
                end;

                { second pass of code generation: }
                for I:= 0 to DD.RNames^.Count-1 do begin
                    S:= GetStr(DD.RNames^.At(I));
                    if S[1] <> ' ' then begin
                        System.Delete(S, 1, 1);
                        PV:= PTrialDialog(Get(S));
                        if PV <> nil then begin
                            CodeGen.GenPart:= gpDialogInit;
                            CodeGen.GenVars:= GV[I];
                            PV^.GenCode;
                            PV^.Free;
                        end;
                    end;
                end;
            end; {if}

            { optionally fetch & convert to real dialog resource? } {++}

        { else single mode - just fetch one dialog: }
        end else begin
            S:= GetStr(DD.RNames^.At(DD.RSelection));
            System.Delete(S, 1, 1);
            {PV:= PTrialDialog(Get(S));}                        {?} {+}
            GetDialog(S);
        end;
    end;
    Dispose(DD.RNames, Done);
end; {FetchDialog}

procedure TestDialog;   {++ can use to create default data ++}
var
    TrialData: pointer;
    DSz, Cmd: word;
    SavedGP: TGenPart;
begin
    if TrialDialog = nil then exit;
    SavedGP:= CodeGen.GenPart;
    CodeGen.GenPart:= gpClone;
    TrialDialog^.GenCode;
    CodeGen.GenPart:= SavedGP;
    if CodeGen.RealDialog = nil then exit;
    {TrialDialog^.Close;}

    DSz:= CodeGen.RealDialog^.DataSize;
    if DSz > 0 then begin
        GetMem(TrialData, DSz);
        FillChar(TrialData^, DSz, 0);
        TrialDialog^.GetData(TrialData^);
        { transfer data: TrialDialog -> RealDialog }
        Cmd:= Application^.ExecuteDialog(CodeGen.RealDialog, TrialData);
        { transfer data: RealDialog -> TrialDialog }
        if Cmd <> cmCancel then TrialDialog^.SetData(TrialData^);
        FreeMem(TrialData, DSz);
    end else begin
        Cmd:= Application^.ExecuteDialog(CodeGen.RealDialog, nil);
    end;
    CodeGen.RealDialog:= nil;
end; {TestDialog}

{ read History and Default data: }
procedure ReadHistory;
var
    S: PStream;
    F: file;
const
    M: string = 'Cannot read edit default data.';

begin
    Assign(F, FileOptData.HistFName);
    {$I-}
    Reset(F);
    if IoResult <> 0 then exit;
    Close(F);
    {$I+}
    S:= New(PBufStream, Init(FileOptData.HistFName, stOpen,
            StreamBufSize));
    if S <> nil then begin
        LoadHistory(S^);
        StreamErrMsg:= @M;
        S^.Read(Paste, SizeOf(Paste));
        if S^.Status = stOk
        then Default:= Paste
        else Paste:= Default;
        StreamErrMsg:= nil;
        S^.Free;  {Done ?}                              {+++}
    end;
end; {ReadHistory}

procedure WriteHistory;
var
    S: PStream;
begin
    S:= New(PBufStream, Init(FileOptData.HistFName, stCreate,
            StreamBufSize));
    if S <> nil then begin
        StoreHistory(S^);
        S^.Write(Default, SizeOf(Default));
        S^.Free;  {Done ?}                              {+++}
    end;
end; {WriteHistory}

{$IFDEF ScreenCapture}
procedure ScreenCapture(const Bounds: TRect);
type
    TScreen = array [0..49, 0..79, 0..1] of char;
var
    Screen: TScreen absolute $B800:0;
    X, Y: integer;
    S: string[80];
    Ch: char;
    Attr: byte;
const
    BackGrd = '±'{'°'};
    Shadow = ' '{'±'};
begin
    with Bounds do
    for Y:= A.Y to B.Y do begin
        S[0]:= Chr(B.X-A.X+1);
        for X:= A.X to B.X do begin
            Ch:= Screen[Y, X, 0];
            Attr:= Ord(Screen[Y, X, 1]);
            if (X=A.X) and (Y=B.Y) then begin
                S[X-A.X+1]:= ' ';
            end else if (X=B.X) and (Y=A.Y) then begin
                S[X-A.X+1]:= ' ';
            end else if (X=B.X) or (Y=B.Y) then begin
                S[X-A.X+1]:= Shadow;
            end else if (Ch = ' ') and
              ((Attr and $70) = $70) then begin
                S[X-A.X+1]:= BackGrd;
            end else if Ch = '°' then begin
                S[X-A.X+1]:= BackGrd;
            end else if Ch = 'ð' then begin
                S[X-A.X+1]:= BackGrd;
            end else if Ch = #7 then begin
                S[X-A.X+1]:= 'þ';
            end else begin
                S[X-A.X+1]:= Ch;
            end;
        end;
        writeln(S);
    end;
end; {ScreenCapture}
{$ENDIF}

{*******************************************************}

{*******************************************************}

{*******************************************************}

{ TrialRadioButtons }

{ The radio buttons correspond to values 0..n-1 of the data. }

constructor TTrialRadioButtons.Init(aOwner: Pgroup; AData: PClusterData);
var
    R: TRect;
begin
    InitBounds(aOwner,R, 10, 3);
    inherited Init(R, nil);
    LabelP:= NewLabel(TrialDialog,Self, AData^.RLabel);
    TC.Init(AData, Self);
end; {TTrialRadioButtons.Init}

destructor TTrialRadioButtons.Done;
begin
    TC.Done;
    inherited Done;
end; {TTrialRadioButtons.Done}

function TTrialRadioButtons.Execute: word;
var
  zLink: Pview;
begin
    {$IfDef FPC_OBJFPC}result{$else}Execute{$endif} :=0;
    { these controlled by GenPart: }
    TC.GenCode(Self,zLink);
    LabelP^.GenCode(TC.ShortName,zLink);
end; {TTrialRadioButtons.Execute}

procedure TTrialRadioButtons.HandleEvent(var Event: TEvent);
begin
    TC.HandleEvent(Event, @Self, LabelP);
end; {TTrialRadioButtons.HandleEvent}

procedure TTrialRadioButtons.SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 7;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  Dec(MaxSz.Y,2);
end; {TTrialRadioButtons.SizeLimits}

constructor TTrialRadioButtons.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    TC.Load(S);
    TC.ShortName:= 'RB';
end; {TTrialRadioButtons.Load}

procedure TTrialRadioButtons.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    TC.Store(S);
end; {TTrialRadioButtons.Store}

{*******************************************************}

{ TrialCheckBoxes }

{ The check boxes correspond to bit positions 0..n of the data. }

constructor TTrialCheckBoxes.Init(aOwner: Pgroup; AData: PClusterData);
var
    R: TRect;
begin
    InitBounds(aOwner,R, 10, 3);
    inherited Init(R, nil);
    LabelP:= NewLabel(TrialDialog, Self, AData^.RLabel);
    TC.Init(AData, Self);
end; {TTrialCheckBoxes.Init}

destructor TTrialCheckBoxes.Done;
begin
    TC.Done;
    inherited Done;
end; {TTrialCheckBoxes.Done}

function TTrialCheckBoxes.Execute: word;
var
  zLink: PView;
begin
  {$IfDef FPC_OBJFPC}result{$else}Execute{$endif} :=0;
    { these controlled by GenPart: }
    TC.GenCode(Self,zLink);
    LabelP^.GenCode(TC.ShortName,zLink);
end; {TTrialCheckBoxes.Execute}

procedure TTrialCheckBoxes.HandleEvent(var Event: TEvent);
begin
    TC.HandleEvent(Event, @Self, LabelP);
end; {TTrialCheckBoxes.HandleEvent}

procedure TTrialCheckBoxes.SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 7;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  Dec(MaxSz.Y,2);
end; {TTrialCheckBoxes.SizeLimits}

constructor TTrialCheckBoxes.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    TC.Load(S);
    TC.ShortName:= 'CB';
end; {TTrialCheckBoxes.Load}

procedure TTrialCheckBoxes.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    TC.Store(S);
end; {TTrialCheckBoxes.Store}

{*******************************************************}

{ TrialMultiCheckBoxes }

{ The multi-check boxes correspond to k-bit codes at bit }
{ positions 0*k..(n-1)*k of the data.  The states are scanned }
{ from end to start of States string, and State[i] has value i. }

constructor TTrialMultiCheckBoxes.Init(aOwner: Pgroup; AData: PClusterData);
var
    R: TRect;
    ASelRange: byte;
    AFlags: word;
begin
    InitBounds(aOwner,R, 10, 3);
    ASelRange:= Length(AData^.RStates);
    case ASelRange of
      2:        AFlags:= cfOneBit;
      3..4:     AFlags:= cfTwoBits;
      5..16:    AFlags:= cfFourBits;
      17..255:  AFlags:= cfEightBits;
      else begin
        AData^.RStates:= ' X';
        ASelRange:= 2;
        AFlags:= cfOneBit;
      end;
    end; {case}
    inherited Init(R, nil, ASelRange, AFlags, AData^.RStates);
    LabelP:= NewLabel(TrialDialog, Self, AData^.RLabel);
    TC.Init(AData, Self);
end; {TTrialMultiCheckBoxes.Init}

destructor TTrialMultiCheckBoxes.Done;
begin
    TC.Done;
    inherited Done;
end; {TTrialMultiCheckBoxes.Done}

function TTrialMultiCheckBoxes.Execute: word;
var
  zLink: PView;
begin
    {$IfDef FPC_OBJFPC}result{$else}Execute{$endif} :=0;
    { these controlled by GenPart: }
    TC.GenCode(Self,zLink);
    LabelP^.GenCode(TC.ShortName,zLink);
end; {TTrialMultiCheckBoxes.Execute}

procedure TTrialMultiCheckBoxes.HandleEvent(var Event: TEvent);
begin
    TC.HandleEvent(Event, @Self, LabelP);
end; {TTrialMultiCheckBoxes.HandleEvent}

procedure TTrialMultiCheckBoxes.SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 7;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  Dec(MaxSz.Y,2);
end; {TTrialMultiCheckBoxes.SizeLimits}

constructor TTrialMultiCheckBoxes.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    TC.Load(S);
    TC.ShortName:= 'MB';
end; {TTrialMultiCheckBoxes.Load}

procedure TTrialMultiCheckBoxes.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    TC.Store(S);
end; {TTrialMultiCheckBoxes.Store}

{*******************************************************}

{ ListBoxDialog }

constructor TListBoxDialog.Init(aOwner: Pgroup; Change: boolean);
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
        SY:= 25;  DT:= 'Change';
    end else begin
        SY:= 22;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' ListBox';
    inherited Init(aOwner, R, DT);

    MakeDialogNames(SX);

    R.Assign(3, 10, SX-6, 11);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(3,  9, 19, 10);
    Insert(New(PLabel, Init(R, '~S~elect Name', IL)));
    R.Assign(SX-6, 10, SX-3, 11);
    Insert(New(PHistory, Init(R, IL, hiDataName)));

    R.Assign(3, 12, 7, 13);
    IL:= New(PRangeInputLine, Init(R, 4, 1, 255));  Insert(IL);
    R.Assign(7, 12, 26, 13);
    Insert(New(PLabel, Init(R, 'Number of ~C~olumns', IL)));

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
end; {TListBoxDialog.Init}

{ TrialScrollBar }

constructor TTrialScrollBar.Init(Bounds: TRect; ALink: PView);
begin
    inherited Init(Bounds);
    Link:= ALink;
    DragMode:= dmLimitAll;                  {+}
    GrowMode:= 0;
end; {TTrialScrollBar.Init}

procedure TTrialScrollBar.HandleEvent(var Event: TEvent);
//var
//    Lims: TRect;
//    MinSz, MaxSz: TPoint;
//    D: byte;
begin
    if Event.What and evMouseDown <> 0 then begin
        { move / re-size ScrollBar by dragging: }
        if Link <> nil then PutInFrontOf(Link);
        DragIt(Self, Event,Changed);

    end;
end; {TTrialScrollBar.HandleEvent}

procedure TTrialScrollBar.SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint);
begin
    MinSz.X:= 1;  MaxSz.X:= 1;
    MinSz.Y:= 3;  MaxSz.Y:= Owner^.Size.Y - 2;
end; {TTrialScrollBar.SizeLimits}

procedure TTrialScrollBar.GenCode;
var
    R: TRect;
begin
    case CodeGen.GenPart of
     gpControls:
        begin
            CodeBounds(Self);
            writeln(Tab+'SB:= New(PScrollBar, Init(R));  Insert(SB);');
        end;

     gpClone:
        begin
            GetBounds(R);
            SBLink:= New(PScrollBar, Init(R));
            CodeGen.RealDialog^.Insert(SBLink);
        end;
    end; {case}
end; {TTrialScrollBar.GenCode}

{ Move ScrollBar after target (Link^) is dragged: }
{ (OldR is bounds of Link^ before dragging) }
procedure TTrialScrollBar.TrackTarget(const OldR: TRect);
var
    SX: integer;
begin
    { is ScrollBar on left side of target? }
    if Origin.X < (OldR.A.X + OldR.B.X) div 2
        {track upper left corner of target:}
    then SX:= 0
        {track upper right corner of target:}
    else SX:= Link^.Size.X + OldR.A.X - OldR.B.X;
    MoveTo(Origin.X + Link^.Origin.X + SX - OldR.A.X,
           Origin.Y + Link^.Origin.Y - OldR.A.Y);
    GrowTo(Size.X, Size.Y + Link^.Size.Y - (OldR.B.Y - OldR.A.Y));
end; {TTrialScrollBar.TrackTarget}

constructor TTrialScrollBar.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, Link);
end; {TTrialScrollBar.Load}

procedure TTrialScrollBar.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, Link);
end; {TTrialScrollBar.Store}

{ TrialListBox }

constructor TTrialListBox.Init(aOwner:PGroup;AData: PListBoxData);
var
    R: TRect;
//    M: integer;
    SB: PTrialScrollBar;
begin
    with AData^ do begin
        { init'z the ScrollBar: }
        InitBounds(aOwner,R, 11, 5);
        R.Assign(R.B.X-1, R.A.Y, R.B.X, R.B.Y);
        SB:= New(PTrialScrollBar, Init(R, @Self));
        TrialDialog^.Insert(SB);
        { init'z the ListBox: }
        InitBounds(aOwner,R, 11, 5);
        R.Move(-1, 0);
        inherited Init(R, RNumCols, SB);
        DragMode:= dmLimitAll;
        ListName:= NewStr(RListName);
        SelectName:= NewStr(RSelectName);
        { init'z the Label: }
        LabelP:= NewLabel(TrialDialog, Self, RLabel);
    end;
end; {TTrialListBox.Init}

destructor TTrialListBox.Done;
begin
    DisposeStr(ListName);
    DisposeStr(SelectName);
    inherited Done;
end; {TTrialListBox.Done}

function TTrialListBox.Execute: word;
var
    R: TRect;
    zLink: PView;
begin
  {$IfDef FPC_OBJFPC}result{$else}Execute{$endif} :=0;
    case CodeGen.GenPart of
     gpDataFields:
        begin
            writeln(Tab+Tab, GetStr(ListName), ': PStringCollection;');
            writeln(Tab+Tab, GetStr(SelectName), ': integer;');
            with PTrialDialog(Owner)^
            do CodeGen.GenVars:= CodeGen.GenVars or gvListBox or gvScrollBar;
        end;

     gpDataValues:
        begin
            if CodeGen.Semicolon then writeln(';');
            CodeGen.Semicolon:= true;
            writeln(Tab+Tab, GetStr(ListName), ': nil;');
            write  (Tab+Tab, GetStr(SelectName), ': 0');
        end;

     gpControls:
        begin
            writeln;
            PTrialScrollBar(VScrollBar)^.GenCode;
            CodeBounds(Self);
            write(Tab+'LB:= New(PListBox, Init(R, ', NumCols, ', SB));');
            writeln('  Insert(LB);');
            LabelP^.GenCode('LB',nil);
        end;

     gpClone:
        begin
            PTrialScrollBar(VScrollBar)^.GenCode;
            GetBounds(R);
            { List is set = nil: }                              {++}
            zLink:= New(PListBox, Init(R, NumCols, SBLink));
            CodeGen.RealDialog^.Insert(zLink);
            LabelP^.GenCode('LB',zLink);
        end;
    end; {case}
end; {TTrialListBox.Execute}

procedure TTrialListBox.HandleEvent(var Event: TEvent);
var
    OldR: TRect;
    PD: PDialog;
//    PS: PTrialListBox;
    ListBoxData: TListBoxData;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with ListBoxData do begin
            { edit ListBox with ListBoxDialog: }
            RNumCols:= NumCols;
            RListName:= GetStr(ListName);
            RSelectName:= GetStr(SelectName);
            RLabel:= GetStr(LabelP^.Text);

            PD:= PDialog(New(PListBoxDialog, Init(self.Owner,true)));
            Cmd:= application^.ExecuteDialog(PD, @ListBoxData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    NumCols:= RNumCols;
                    ChangeStr(ListName, RListName);
                    ChangeStr(SelectName, RSelectName);
                    LabelP^.ChangeText(RLabel);
                    if Cmd = cmPutOnTop then begin
                        MakeFirst;
                        if LabelP <> nil then LabelP^.MakeFirst;
                    end;
                    Draw;
                    changed:= true;
                end;

             cmDelete:
                begin
                    if LabelP <> nil then LabelP^.Free;
                    if VScrollBar <> nil then VScrollBar^.Free;
                    Free;
                    Changed:= true;
                end;

             cmSetDefault: Default.DListBox:= ListBoxData;

             cmSetPaste: Paste.DListBox:= ListBoxData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size ListBox, moving also ScrollBar & Label: }
            GetBounds(OldR);  {save old bounds}
            DragBoth(Self, LabelP, Event, Changed);
            PTrialScrollBar(VScrollBar)^.TrackTarget(OldR);
        end;
    end;
end; {TTrialListBox.HandleEvent}

procedure TTrialListBox.SetState(AState: word; Enable: boolean);
begin
    { Bypass TListViewer.SetState so that VScrollBar will }
    { remain visible when the TrialListBox is not active; }
    { that is, when the TrialDialog is not active:        }
    TView.SetState(AState, Enable);
end; {TTrialListBox.SetState}

procedure TTrialListBox.SizeLimits({$IfDef FPC_OBJFPC}out{$else}var{$endif} MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 3;  Dec(MaxSz.X,2);
    MinSz.Y:= 3;  Dec(MaxSz.Y,2);
end; {TTrialListBox.SizeLimits}

constructor TTrialListBox.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    ListName:= S.ReadStr;
    SelectName:= S.ReadStr;
end; {TTrialListBox.Load}

procedure TTrialListBox.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    S.WriteStr(ListName);
    S.WriteStr(SelectName);
end; {TTrialListBox.Store}

{*******************************************************}

{ DialogDialog }

constructor TDialogDialog.Init(aDialog: Pgroup; Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    V: PView;
    SY, Y: integer;
    DT: TTitleStr;
const
    SX = 37;
    X1 = 1*SX div 3;
    X2 = 2*SX div 3;
begin
    if Change then begin
        SY:= 18;  DT:= 'Change';
    end else begin
        SY:= 20;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    R.Move(DLim.B.X - R.B.X, DLim.B.Y - R.B.Y);
    DT:= DT + ' Dialog';
    inherited Init(aDialog,R, DT);
    if not Change then Options:= Options or ofCentered;

    R.Assign(3, 4, 19, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, 22, 4);
    Insert(New(PLabel, Init(R, '~D~ialog Box Title', IL)));
    R.Assign(19, 4, 22, 5);
    Insert(New(PHistory, Init(R, IL, hiDialogName)));

    if Change then Y:= 9 else Y:= 11;
    R.Assign(3, 7, 22, Y);
    V:= New(PCheckBoxes, Init(R,
        NewSItem('~G~en. Defaults',
        NewSItem('C~e~nter Dialog',
        NewSItem('O~k~ Button',
        NewSItem('~C~ancel Button',
        nil))))
    ));  Insert(V);
    R.Assign(3, 6, 22, 7);
    Insert(New(PLabel, Init(R, 'O~p~tions', V)));

    R.Assign(23, 4, SX-6, 5);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(23, 3, SX-3, 4);
    Insert(New(PLabel, Init(R, '~B~ase Name', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiDialogName)));

    R.Assign(23, 7, SX-6, 8);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(23, 6, SX-3, 7);
    Insert(New(PLabel, Init(R, '~T~ype Name', IL)));
    R.Assign(SX-6, 7, SX-3, 8);
    Insert(New(PHistory, Init(R, IL, hiDialogName)));

    MakeDialogButtons(X1, X2, SY, false, bfDefault);
end; {TDialogDialog.Init}

{ TrialDialogBackground }

constructor TTrialDialogBackground.Init(Bounds: TRect);
begin
    inherited Init(Bounds);
    GrowMode:= gfGrowHiX + gfGrowHiY;
    Patterned:= true;
end; {TTrialDialogBackground.Init}

procedure TTrialDialogBackground.Draw;
var
    Bf1, Bf2: TDrawBuffer;      { #$B0 = light hatch ° }
    Ch1, Ch2: char;             { #$B1 = med.  hatch ± }
    I, J, Y: integer;           { #$F0 = triple bar  ð }
begin                           {  $78 = DkGray/LtGray }
    if Patterned then begin     {  $76 = Brown/LtGray  }
        Ch1:= #$B0;  Ch2:= #$B1;                              {++}
    end else begin
        Ch1:= ' ';  Ch2:= ' ';
    end;

    { MoveChar(Bufr, Char, Color, XSize);   }
    { In the DrawBuffer --                  }
    { Lo bytes are Char, Hi bytes are Color }
    MoveChar(Bf1, Ch1, $76, Size.X);
    for I:= 1 to (Size.X div 5) do begin
        J:= 5*I - 1;
        Bf1[J]:= (Bf1[J] and $FF00) or Ord(Ch2);
    end;

    MoveChar(Bf2, Ch2, $76, Size.X);
    for Y:= 0 to Size.Y do begin
        if (Y mod 5) = 4 then begin
            WriteLine(0, Y, Size.X, 1, Bf2);
        end else begin
            WriteLine(0, Y, Size.X, 1, Bf1);
        end;
    end;
end; {TTrialDialogBackground.Draw}

procedure TTrialDialogBackground.HandleEvent(var Event: TEvent);
begin
    inherited HandleEvent(Event);
    if (Event.What and evMouseDown <> 0) and Event.Double
    then begin
        Patterned:= not Patterned;  {toggle}
        Draw;
        Changed:= true;
        ClearEvent(Event);
    end;
end; {TTrialDialogBackground.HandleEvent}

constructor TTrialDialogBackground.Load(var S: TStream);
begin
    inherited Load(S);
    S.Read(Patterned, SizeOf(boolean));
    {Patterned:= true;}                                         {+}
end; {TTrialDialogBackground.Load}

procedure TTrialDialogBackground.Store(var S: TStream);
begin
    inherited Store(S);
    S.Write(Patterned, SizeOf(boolean));
end; {TTrialDialogBackground.Store}

{ TrialDialog }

constructor TTrialDialog.Init(AData: PDialogData);
var
    R: TRect;
    TB: PTrialButton;
    ButtonData: TButtonData;
begin
    with AData^ do begin
        R.Assign(0, 0, 36, 15);
        R.Move(DLim.A.X, DLim.A.Y);
        inherited Init(R, RTitle);
        R.Move(-DLim.A.X, -DLim.A.Y);
        R.Grow(-1, -1);
        Background:= New(PTrialDialogBackground, Init(R));
        Insert(Background);

        SetState(sfModal, false);
        DragMode:= dmLimitAll;
        Flags:= Flags or wfGrow;
        BaseName:= NewStr(RBaseName);
        TypeName:= NewStr(RTypeName);

        if ROptions and doOkButton <> 0 then begin
            with ButtonData do begin
                RTitle:= '~O~k';
                RCmdName:= 'cmOK';
                RFlags:= bfDefault;
            end;
            TB:= New(PTrialButton, Init(@self,@ButtonData));
            TB^.MoveTo(19, 11);
            Insert(TB);
        end;

        if ROptions and doCancelButton <> 0 then begin
            with ButtonData do begin
                RTitle:= 'C~a~ncel';
                RCmdName:= 'cmCancel';
                RFlags:= bfNormal;
            end;
            TB:= New(PTrialButton, Init(@self,@ButtonData));
            TB^.MoveTo(7, 11);
            Insert(TB);
        end;

        Centered:= ROptions and doCentered <> 0;
        GenDefaults:= ROptions and doGenDefaults <> 0;
        Application^.EnableCommands(cmsNewControls);
    end;
end; {TTrialDialog.Init}

destructor TTrialDialog.Done;
begin
    DisposeStr(BaseName);
    DisposeStr(TypeName);
    inherited Done;
end; {TTrialDialog.Done}

procedure TTrialDialog.Close;
begin
    if TrialDialog <> @Self then begin
        inherited Close;
        exit;
    end;
    if Changed then begin
        if AutoSave or (MessageBox('Save current dialog?', nil,
            mfConfirmation + mfYesButton + mfNoButton) = cmYes)
        then SaveDialog;            { also RealDialog ? }           {++}
    end;

    inherited Close;                { also RealDialog ? }           {++}
    TrialDialog:= nil;
    Application^.DisableCommands(cmsNewControls);
end; {TTrialDialog.Close}

procedure TTrialDialog.GenCode;
var
    R: TRect;

    { scans subviews UPward (ForEach goes DOWNward): }
    procedure SubViewGenCode(P: PView);
    begin
        if P <> nil then begin
            if P^.Next <> First then begin
                SubViewGenCode(P^.Next);
            end;
            P^.Execute;
        end;
    end; {SubViewGenCode}

begin
    case CodeGen.GenPart of
     gpDialogHeader:
        begin
            writeln('{ ', GetStr(BaseName), GetStr(TypeName), ' }');
            writeln;
            writeln('type');
            writeln(Tab+'P', GetStr(BaseName), GetStr(TypeName), ' = ^T',
                            GetStr(BaseName), GetStr(TypeName), ';');
            writeln(Tab+'T', GetStr(BaseName), GetStr(TypeName),
                            ' = object(T', GetStr(TypeName), ')');
            writeln(Tab+Tab+'constructor Init;');
            writeln(Tab+'end;');
            writeln;
            writeln(Tab+'P', GetStr(BaseName), 'Data = ^T',
                            GetStr(BaseName), 'Data;');
            writeln(Tab+'T', GetStr(BaseName), 'Data = record');

            CodeGen.GenVars:= 0;    {subviews will set bits}
            ListClustConsts:= false;
            CodeGen.GenPart:= gpDataFields;
            if First <> nil then SubViewGenCode(First);

            writeln(Tab+'end;');
            writeln;

            if ListClustConsts then begin
                writeln('const');
                CodeGen.GenPart:= gpDataConsts;
                if First <> nil then SubViewGenCode(First);
                writeln;
            end;

            if GenDefaults then begin
                writeln('const');
                writeln(Tab, GetStr(BaseName), 'Defaults: T',
                        GetStr(BaseName), 'Data = (');

                CodeGen.GenPart:= gpDataValues;
                CodeGen.Semicolon:= false;
                if First <> nil then SubViewGenCode(First);

                writeln;
                writeln(Tab+');');
                writeln;
            end;
        end;

     gpHistConsts:
        begin
            if First <> nil then SubViewGenCode(First);
        end;

     gpDialogInit:
        begin
            writeln('{ ', GetStr(BaseName), GetStr(TypeName), ' }');
            writeln;
            writeln('constructor T', GetStr(BaseName),
                            GetStr(TypeName), '.Init;');
            writeln('var');
            writeln(Tab+'R: TRect;');

            if CodeGen.GenVars and gvInputLine <> 0
            then writeln(Tab+'IL: PInputLine;');
            if CodeGen.GenVars and gvRadioButtons <> 0
            then writeln(Tab+'RB: PRadioButtons;');
            if CodeGen.GenVars and gvCheckBoxes <> 0
            then writeln(Tab+'CB: PCheckBoxes;');
            if CodeGen.GenVars and gvMultiCheckBoxes <> 0
            then writeln(Tab+'MB: PMultiCheckBoxes;');
            if CodeGen.GenVars and gvScrollBar <> 0
            then writeln(Tab+'SB: PScrollBar;');
            if CodeGen.GenVars and gvListBox <> 0
            then writeln(Tab+'LB: PListBox;');
                {== other variables may be needed ==}

            writeln('begin');
            CodeBounds(Self);
            write(Tab+'inherited Init(R, ''', EscQuot(GetStr(Title)));
            if GetStr(TypeName) = 'Window' then begin
                writeln(''', 0);');     {zero window number}
            end else begin
                writeln(''');');
            end;
            if Centered
            then writeln(Tab+'Options:= Options or ofCentered;');

            CodeGen.GenPart:= gpControls;
            if First <> nil then SubViewGenCode(First);

            writeln('end; {T', GetStr(BaseName),
                               GetStr(TypeName), '.Init}');
            writeln;
            CodeGen.GenPart:= gpDialogFooter;   {done, but output still open}
        end;

     gpClone:
        begin
            if CodeGen.RealDialog <> nil then CodeGen.RealDialog^.Close;
            GetBounds(R);
            if GetStr(TypeName) = 'Window' then begin
                CodeGen.RealDialog:= PDialog(New(PWindow,
                    Init(R, GetStr(Title), 0)));
            end else begin
                CodeGen.RealDialog:= New(PDialog, Init(R, GetStr(Title)));
            end;
            if Centered
            then with CodeGen.RealDialog^ do Options:= Options or ofCentered;
            if First <> nil then SubViewGenCode(First);
        end;
    end; {case}

end; {TTrialDialog.GenCode}

{ The methodology here is not supported by Virtual Pascal. }
procedure TTrialDialog.SnapPicture(AShow, APattern: word);
type
    TScreen = array [0..70, 0..79, 0..1] of char;
var
{$IFNDEF FPC}
{$IFNDEF VPASCAL}
    Screen: TScreen absolute $B800:0;
{$ENDIF}
{$else}
    Screen: TScreen;
{$ENDIF}
    R: TRect;
    X, Y, NoShadow: integer;
    S: string[80];
    Ch, SCh, BackGrd, Shadow: char;
    Attr: byte;
    NoResize: boolean;
begin
{$ifdef FPC_OBJFPC}
   DoScreenShot(screen);
{$endif}
{$IFNDEF VPASCAL}
    NoResize:= ((AShow and $0001) = 0);
    NoShadow:= Ord((AShow and $0002) = 0);
    BackGrd:= ShadeChars[(APattern and $000F) + 1];
    Shadow:= ShadeChars[(APattern shr 4) + 1];
    if Background^.Patterned then SCh:= ' ' else SCh:= BackGrd;     {+}
    GetExtent(R);
    MakeGlobal(R.A, R.A);
    MakeGlobal(R.B, R.B);
    with R do for Y:= A.Y to B.Y-NoShadow do begin
        S[0]:= Chr(B.X-A.X+1-NoShadow);
        for X:= A.X to B.X-NoShadow do begin
            Ch:= Screen[Y, X, 0];
            Attr:= Ord(Screen[Y, X, 1]);
            if (X=A.X) and (Y=B.Y) then begin
                S[X-A.X+1]:= ' ';
            end else if (X=B.X) and (Y=A.Y) then begin
                S[X-A.X+1]:= ' ';
            end else if (X=B.X) or (Y=B.Y) then begin
                S[X-A.X+1]:= Shadow;
            end else if (Ch = ' ') and
              ((Attr and $70) = $70) then begin                     {+}
                S[X-A.X+1]:= SCh;
            end else if NoResize and (Y=B.Y-1) then begin
                if (X=B.X-2) then begin
                    S[X-A.X+1]:= 'Í';
                end else if (X=B.X-1) then begin
                    S[X-A.X+1]:= '¼';
                end else begin
                    S[X-A.X+1]:= Ch;
                end;
            end else if Ch = chLightHatch then begin
                S[X-A.X+1]:= BackGrd;
            end else if Ch = chMedHatch{ð} then begin
                S[X-A.X+1]:= BackGrd;
            end else if Ch = #7 then begin
                S[X-A.X+1]:= 'þ';
            end else begin
                S[X-A.X+1]:= Ch;
            end;
        end;
        writeln(Tab, S);
    end;
{$ENDIF}
    CodeGen.GenPart:= gpDialogFooter;   {done, but output file still open}
    writeln;
end; {TTrialDialog.SnapPicture}

procedure TTrialDialog.HandleEvent(var Event: TEvent);
var
//    PV: PView;
    DialogData: TDialogData;
    Cmd: word;
begin
    inherited HandleEvent(Event);
    if (Event.What and evMouseDown <> 0) and Event.Double
    then begin
        with DialogData do begin
            RTitle:= GetStr(Title);
            RBaseName:= GetStr(BaseName);
            RTypeName:= GetStr(TypeName);
            if Centered then ROptions:= doCentered else ROptions:= 0;
            if GenDefaults then ROptions:= ROptions or doGenDefaults;
        end;

        Cmd:= DialEditApp.ExecuteDialog(New(PDialogDialog, Init(Trialdialog,true)),
            @DialogData);
        case Cmd of
         cmOK:
            with DialogData do begin
                ChangeStr(Title, RTitle);
                ChangeStr(BaseName, RBaseName);
                ChangeStr(TypeName, RTypeName);
                Centered:= ROptions and doCentered <> 0;
                GenDefaults:= ROptions and doGenDefaults <> 0;
                Redraw;
                Changed:= true;
            end;

         cmSetDefault: Default.DDialog:= DialogData;

         cmSetPaste: Paste.DDialog:= DialogData;

         {else cmCancel}
        end; {case}
        ClearEvent(Event);
    end;
end; {TTrialDialog.HandleEvent}

procedure TTrialDialog.SetState(AState: word; Enable: boolean);
begin
    if AState = sfDragging then Changed:= true;
    inherited SetState(AState, Enable);
end; {TTrialDialog.SetState}

constructor TTrialDialog.Load01(var S: TStream);
begin
    inherited Load(S);
    BaseName:= S.ReadStr;
    TypeName:= S.ReadStr;
    GetSubViewPtr(S, BackGround);
    S.Read(Centered, SizeOf(boolean));
    GenDefaults:= false;                    {fix old}
    Application^.EnableCommands(cmsNewControls);
end; {TTrialDialog.Load01}

constructor TTrialDialog.Load(var S: TStream);
begin
    inherited Load(S);
    BaseName:= S.ReadStr;
    TypeName:= S.ReadStr;
    GetSubViewPtr(S, BackGround);
    S.Read(Centered, SizeOf(boolean));
    S.Read(GenDefaults, SizeOf(boolean));   {new}
    Application^.EnableCommands(cmsNewControls);
end; {TTrialDialog.Load}

procedure TTrialDialog.Store(var S: TStream);
begin
    inherited Store(S);
    S.WriteStr(BaseName);
    S.WriteStr(TypeName);
    PutSubViewPtr(S, BackGround);
    S.Write(Centered, SizeOf(boolean));
    S.Write(GenDefaults, SizeOf(boolean));  {new}
end; {TTrialDialog.Store}

{*******************************************************}

{ FetchDialogDialog }

constructor TFetchDialogDialog.Init(APlural: boolean);
var
    R: TRect;
    SB: PScrollBar;
    T: TTitleStr;
    Y, YY: integer;
begin
    if APlural then begin
        T:= 'Select Dialogs';
        Y:= 22;  YY:= 19;
    end else begin
        T:= 'Fetch Dialog';
        Y:= 20;  YY:= 18;
    end;
    R.Assign(0, 0, 30, Y);
    inherited Init(R, T);
    Options:= Options or ofCentered;
    Plural:= APlural;

    R.Assign(26, 4, 27, 15);
    SB:= New(PScrollBar, Init(R));  Insert(SB);
    R.Assign(3, 4, 26, 15);
    ListBox:= New(PListBox, Init(R, 1, SB));

    Insert(ListBox);
    R.Assign(3, 3, 23, 4);
    Insert(New(PLabel, Init(R, 'Dialog/Window ~N~ame', ListBox)));
    if Plural then begin
        R.Assign(7, 15, 29, 16);
        Insert(New(PStaticText, Init(R, 'space toggles û')));
        R.Assign(17, YY, 26, YY+1);
        Insert(New(PStaticText, Init(R, '(go gen.)')));
    end;

    R.Assign(4, YY-2, 14, YY);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

    R.Assign(16, YY-2, 26, YY);
    Insert(New(PButton, Init(R, '~O~k', cmOK, bfDefault)));

    ListBox^.Select;
end; {TFetchDialogDialog.Init}

procedure TFetchDialogDialog.HandleEvent(var Event: TEvent);
var
 //   R: TRect;
    S: String;
begin
    if (Event.What and evMessage <> 0)
    and (Event.Command = cmListItemSelected)
    and (Event.InfoPtr = ListBox) then begin
        if Plural then with ListBox^ do begin
            S:= getstr(List^.At(Focused));
            if S[1] = ' ' then begin   {toggle selection}
                S[1]:= 'û';
            end else begin
                S[1]:= ' ';
            end;
        end else begin
            EndModal(cmOk);
            ClearEvent(Event);
            exit;
        end;
    end;
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
end; {TFetchDialogDialog.HandleEvent}

{*******************************************************}

{ FileOptDialog }

constructor TFileOptDialog.Init;
var
    R: TRect;
    IL: PInputLine;
 //   V: PView;
begin
    R.Assign(4, 4, 37, 22);
    inherited Init(R, 'File Options');
    Options:= Options or ofCentered;

    R.Assign(3, 8, 30, 9);
    Insert(New(PStaticText, Init(R, '(empty for standard output)')));

    R.Assign(3, 7, 27, 8);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 6, 21, 7);
    Insert(New(PLabel, Init(R, 'Code ~O~utput Name', IL)));
    R.Assign(27, 7, 30, 8);
    Insert(New(PHistory, Init(R, IL, hiCodeFile)));

    R.Assign(3, 4, 27, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, 27, 4);
    Insert(New(PLabel, Init(R, '~C~ollection File Name', IL)));
    R.Assign(27, 4, 30, 5);
    Insert(New(PHistory, Init(R, IL, hiCollFile)));

    R.Assign(3, 11, 27, 12);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 10, 23, 11);
    Insert(New(PLabel, Init(R, '~H~istory File Name', IL)));
    R.Assign(27, 11, 30, 12);
    Insert(New(PHistory, Init(R, IL, hiHistFile)));

    R.Assign(5, 14, 15, 16);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

    R.Assign(18, 14, 28, 16);
    Insert(New(PButton, Init(R, 'O~k~', cmOK, bfDefault)));
end; {TFileOptDialog.Init}

{*******************************************************}

{ OutOptDialog }

constructor TOutOptDialog.Init;
var
    R: TRect;
    RB: PRadioButtons;
    CB: PCheckBoxes;
    MB: PMultiCheckBoxes;
begin
    R.Assign(4, 4, 39, 22);
    inherited Init(R, 'Output Options');
    Options:= Options or ofCentered;

    R.Assign(3, 14, 12, 15);
    CB:= New(PCheckBoxes, Init(R,
        NewSItem('Sa~v~e',
        nil)
    ));  Insert(CB);

    R.Assign(3, 4, 32, 5);
    CB:= New(PCheckBoxes, Init(R,
        NewSItem('~P~ictures  ',
        NewSItem('~T~V Code',
        nil))
    ));  Insert(CB);
    R.Assign(3, 3, 22, 4);
    Insert(New(PLabel, Init(R, '~O~utput includes..', CB)));

    R.Assign(3, 7, 17, 9);
    CB:= New(PCheckBoxes, Init(R,
        NewSItem('~R~esize',
        NewSItem('S~h~adow',
        nil))
    ));  Insert(CB);
    R.Assign(3, 6, 11, 7);
    Insert(New(PLabel, Init(R, 'Sho~w~..', CB)));

    R.Assign(3, 11, 17, 13);
    MB:= New(PMultiCheckBoxes, Init(R,
        NewSItem('~B~ackgrnd',
        NewSItem('Shado~w~',
        nil)), 5, cfFourBits, ShadeChars));
    Insert(MB);
    R.Assign(3, 10, 16, 11);
    Insert(New(PLabel, Init(R, 'Patter~n~ of..', MB)));

    R.Assign(19, 7, 32, 9);
    RB:= New(PRadioButtons, Init(R,
        NewSItem('~B~are',
        NewSItem('~U~nit',
        nil))
    ));  Insert(RB);
    R.Assign(19, 6, 31, 7);
    Insert(New(PLabel, Init(R, 'Code ~F~ormat', RB)));

    R.Assign(19, 11, 32, 12);
    MB:= New(PMultiCheckBoxes, Init(R,
        NewSItem('spaces',
        nil), 5, cfFourBits, 'T4321'));
    Insert(MB);
    R.Assign(19, 10, 29, 11);
    Insert(New(PLabel, Init(R, '~I~ndent..', MB)));

    R.Assign(20, 12, 29, 13);
    Insert(New(PStaticText, Init(R, '(T = tab)')));

    R.Assign(12, 14, 22, 16);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

    R.Assign(22, 14, 32, 16);
    Insert(New(PButton, Init(R, 'Pic~k~..', cmOK, bfDefault)));
end; {TOutOptDialog.Init}

{*******************************************************}

{ Token }

{ Kind = 's' for SwapToken, Kind = 'm' for ModeToken }

constructor TToken.Init(Bounds: TRect; AKind: char);
begin
    inherited Init(Bounds);
    Kind:= AKind;
    State:= State or sfActive;
    if Kind = 's' then State:= State or sfDisabled;
    EventMask:= evMouse + evBroadcast;
    Options := Options or ofPostProcess;
end; {TToken.Init}

procedure TToken.Draw;
var
    S: string[9]; {length = Size.X}
    B: TDrawBuffer;
    C: byte;
begin
    if Kind = 's' then S:= ' Swap '
    else if State and sfPaste <> 0
    then S:= '  Paste  '
    else S:= ' Default ';

    if State and sfDisabled <> 0
    then C:= GetColor(3)    {3 = 'disabled' color}
    else if State and sfSelected <> 0
    then C:= GetColor(5)    {5 = 'selected' color}
    else C:= GetColor(4);   {4 = 'shortcut' color}
    MoveStr(B{%H-}, S, C);
    WriteLine(0, 0, Size.X, 1, B);
end; {TToken.Draw}

procedure TToken.SetState(AState: word; Enable: boolean);
begin
    inherited SetState(AState, Enable);
    Draw;
end; {TToken.SetState}

procedure TToken.Update;
var
    E1, E2: boolean;
begin
    if Kind = 'm' then exit;
    E1:= Application^.CommandEnabled(cmSwapDialogs);
    E2:= State and sfDisabled = 0;
    if E1 <> E2 then begin
        SetState(sfDisabled, not E1);
        Draw;
    end;
end; {TToken.Update}

procedure TToken.HandleEvent(var Event: TEvent);
{$IFDEF ScreenCapture}                                      {+}
var
    R: TRect;                                               {+}
    {$ENDIF}
begin
    inherited HandleEvent(Event);
    case Event.What of
     evMouseDown:
        if (State and sfDisabled = 0) then begin
{$IFDEF ScreenCapture}                                      {+}
            GetExtent(R);
            MakeGlobal(R.A, R.A);
            MakeGlobal(R.B, R.B);
            ScreenCapture(R);
{$ENDIF}
            SetState(sfSelected, true);
            Message(Application, evBroadcast, cmReceivedFocus, @Self);
            ClearEvent(Event);
        end;

     evMouseUp:
        if (State and sfDisabled = 0)
        and (State and sfSelected <> 0) then begin
            SetState(sfSelected, false);
            if Kind = 's' then begin    {swap}
                Message(Application, evCommand, cmSwapDialogs, nil);
            end else begin              {mode}
                SetState(sfPaste, (State and sfPaste = 0));  {toggle}
            end;
            Message(Application, evBroadcast, cmReleasedFocus, @Self);
            ClearEvent(Event);
        end;

     evBroadcast:
        case Event.Command of
         cmReceivedFocus, cmReleasedFocus:
            if Event.InfoPtr <> @Self then begin
                SetState(sfSelected, false);
                { don't clear event; let others receive it }
            end;
        end; {case}
    end; {case}
end; {TToken.HandleEvent}

{*******************************************************}

{ Program configuration & Command-line interpretation }

{configuration data; compatable with CONFIG program:}
type
    tConfig = record
        Magic: string[10];
        Data:  string[100]; {max length is 255}
    end;

const
    Config: tConfig = (
        Magic: '!)@(#*$&%^';    {must appear nowhere else in code!}

        {default options:}
        Data:   '/////////////////////////'+
                '/////////////////////////'+
                '/////////////////////////'+
                '/////////////////////////'
        {reserve space for reconfiguration with '/' padding}
    );

var
    LastOption: char;

{ ShowUsage, SetOpt, DoFile, and AppDone use Params unit: }

procedure ShowUsage; register;
var
    OS: string;
    CP: integer;
begin
    writeln(CopyNote);
    writeln('TurboVision Dialog Editor');
    writeln('Usage: DialEdit [ options ]');
    writeln('Options:');
    writeln('/hFileName   History file');
    writeln('             (Default filename is ',
                FileOptData.HistFName, '.)');
    writeln('/oFileName   Output for generated code');
    writeln('             (Uses standard output if none given.)');
    writeln('/dFileName   Dialog collection file');
    writeln('             (Default filename is ',
                FileOptData.CollFName, '.)');

    OS:= GetDefaults(Config.data);
    CP:= Pos('/_', OS)-1;
    if CP >= 0 then {$IFDEF FPC} setlength(OS,CP);  {$ELSE} OS[0]:= char(CP);  {$ENDIF}
    if OS <> '' then writeln('Default options are: ', OS);
end; {ShowUsage}

procedure SetOpt;
begin
    with FileOptData do
    case OptChr of
        'o': CodeFName:= OptStr;

        'h': HistFName:= OptStr;

        'd': CollFName:= OptStr;

        '?':
            begin
                DialEditApp.Done;
                ShowUsage;
                Halt;
            end;

        else RptError('Undefined option', Option, 'u');
    end;
    LastOption:= OptChr;
end; {SetOpt}

procedure DoFile(FName: PathStr; {%H-}Expdd: boolean);
begin
    { in case file name is separate from option code: }
    with FileOptData do
    case LastOption of
        'o': CodeFName:= FName;

        'h': HistFName:= FName;

        'd': CollFName:= FName;
    end; {case}
end; {DoFile}

procedure AppDone; {in case setup fails}
begin
    DialEditApp.Done;
end; {AppDone}


{ TDialEditApp }

constructor TDialEditApp.Init;
var
    R: TRect;

begin
    PShowUsage:= @ShowUsage;
    PSetOpt:= @SetOpt;
    PDoFile:= @DoFile;
    PAppDone:= @AppDone;
    R.assign(0,0,0,0);
    FileOptData.CollFName:= 'Dialogs.res';
    FileOptData.CodeFName:= '';
    FileOptData.HistFName:= 'Dialogs.hst';
    OutOptData:= Default.DOutOpt;
    TrialDialog:= nil;
    CodeGen.RealDialog:= nil;
    CodeGen.GenPart:= gpDisabled;
    Changed:= false;
    CollFile:= nil;
    Tab:= #9;

    LastOption:= ' ';
    ParseOpts(Config.Data);     {set default options}

    inherited Init;

    DisableCommands(cmsNewControls +
        [cmSwapDialogs, cmTile, cmCascade, cmCloseAll]
    );

    LastOption:= ' ';
    if ParamCount > 0 then ScanPars;    {scan the command line}

    GetExtent(DLim);  DLim.Grow(-4, -4);

    GetExtent(R);
    dec(R.B.X);
    R.A.X:= R.B.X-9;  R.A.Y:= R.B.Y-1;
{$IFNDEF VPASCAL}
    Heap:= New(PHeapView, Init(R));
    Insert(Heap);
{$ENDIF}

    GetExtent(R);
    R.A.X:= R.B.X-9;  R.B.Y:= R.A.Y+1;
    Clock:= New(PClockView, Init(R));
    Insert(Clock);

    R.B.X:= R.A.X-1;  R.A.X:= R.B.X-9;
    ModeToken:= New(PToken, Init(R, 'm'));
    Insert(ModeToken);

    R.B.X:= R.A.X;  R.A.X:= R.B.X-6;
    SwapToken:= New(PToken, Init(R, 's'));
    Insert(SwapToken);

    PasteStrings:= New(PStringCollection, Init(16, 16));
    with PasteStrings^ do AtInsert(Count, NewStr(' '));
    PasteNames:= New(PStringCollection, Init(16, 16));

    RegisterObjects;
    RegisterViews;
    RegisterDialogs;
    {RegisterValidate}
    {RegisterStdDlg;}                                           {+}
    {RegisterMenus}
    {RegisterApp}
    RegisterTrialObjects;
    StreamError:= @StreamErrorMsg;
    CollFile:= nil; {open when first needed}
    CurrDialog:= '';
    PrevDialog:= '';
    AutoSave:= false;
    ReadHistory;
end; {TDialEditApp.Init}

destructor TDialEditApp.Done;
var
  z: PObject;
begin
    { if active, make code footer and close code output: }
    CloseCodeFile;

    if TrialDialog <> nil then TrialDialog^.Close;
    if CodeGen.RealDialog <> nil then CodeGen.RealDialog^.Close;
    if assigned(PasteStrings) then
      begin
        z := PasteStrings;
        PasteStrings:=nil;
        Dispose(z,done);
      end;
    if assigned(PasteNames) then
      begin
        z := PasteNames;
        PasteNames:=nil;
        Dispose(z,done);
      end;
    CloseCollFile;
    WriteHistory;
    inherited Done;
end; {TDialEditApp.Done}

procedure TDialEditApp.InitScreen;
var
    R: TRect;
begin
    if HiResScreen then begin
        { This is basicly SetScreenMode(Mode), except  }
        { that Mode is "ScreenMode or smFont8x8" and   }
        { that inherited InitScreen is called (else we }
        { would have a recursive loop). }
        HideMouse;
        SetVideoMode(smCO80 or smFont8x8);
        DoneMemory;
        InitMemory;
        inherited InitScreen;
        Buffer:= ScreenBuffer;
        R.Assign(0, 0, ScreenWidth, ScreenHeight);
        ChangeBounds(R);
        ShowMouse;
    end else begin
        inherited InitScreen;
    end;
end; {TDialEditApp.InitScreen}

procedure TDialEditApp.InitMenuBar;
var
    R: TRect;
begin
    GetExtent(R);
    R.B.Y:= R.A.Y + 1;
    MenuBar:= New(PMenuBar, Init(R, NewMenu(
        NewSubMenu('~F~ile', hcNoContext, NewMenu(
            NewItem('~O~utput options..', '', kbAltO, cmOutput,         {++}
                hcNoContext,
            NewItem('Se~l~ect files..', '', kbAltL, cmSetFiles,         {++}
                hcNoContext,
            NewItem('~C~hange dir..', '', kbNoKey, cmChangeDir,
                hcNoContext,
            NewItem('~D~OS shell', '', kbNoKey, cmDosShell, hcNoContext,
            NewItem('E~x~it', '', kbAltX, cmQuit, hcNoContext,
            nil)))))),

        NewSubMenu('Dial~o~g', hcNoContext, NewMenu(
            NewItem('~S~ave', '', kbAltS, cmSaveDialog,
                hcNoContext,
            NewItem('~D~elete', '', kbAltD, cmDeleteDialog,
                hcNoContext,
            NewItem('F~e~tch..', '', kbAltE, cmFetchDialog,
                hcNoContext,
            NewItem('~G~en code', '', kbAltG, cmGenCode,
                hcNoContext,
            NewItem('~P~icture', '', kbAltP, cmSnapPicture,
                hcNoContext,
            NewItem('~T~est', '', kbAltT, cmTestDialog,
                hcNoContext,
            nil))))))),

        NewSubMenu('~N~ew', hcNoContext, NewMenu(
            NewItem('~D~ialog', '', kbAltD, cmNewDialog, hcNoContext,
            NewItem('~S~taticText', '', kbAltS, cmNewStaticText,
                hcNoContext,
            NewItem('~P~aramText', '', kbAltP, cmNewParamText,
                hcNoContext,
            NewItem('~B~utton', '', kbAltB, cmNewButton, hcNoContext,
            NewItem('~I~nputLine', '', kbAltI, cmNewInputLine, hcNoContext,
            NewItem('~R~adioButtons', '', kbAltR, cmNewRadioButtons,
                hcNoContext,
            NewItem('~C~heckBoxes', '', kbAltC, cmNewCheckBoxes,
                hcNoContext,
            NewItem('~M~ultiCheckBoxes', '', kbAltM, cmNewMultiCheckBoxes,
                hcNoContext,
            NewItem('~L~istBox', '', kbAltL, cmNewListBox,
                hcNoContext,
            nil)))))))))),

        NewSubMenu('Dialog_Editor ', hcNoContext, NewMenu(
            NewItem(CopyNote, '', kbNoKey, cmNo, hcNoContext,
            nil)),


        nil))))
    )));
end; {TDialEditApp.InitMenuBar}

procedure TDialEditApp.InitStatusLine;
var
    R: TRect;
begin
    GetExtent(R);
    R.A.Y:= R.B.Y - 1;
    New(StatusLine, Init(R,
        NewStatusDef(0, $FFFF,
            NewStatusKey('E~x~it', kbAltX, cmQuit,
            NewStatusKey('~D~ilg', kbAltD, cmNewDialog,
            NewStatusKey('~S~tTxt', kbAltS, cmNewStaticText,
            NewStatusKey('~P~arTxt', kbAltP, cmNewParamText,
            NewStatusKey('~B~utn', kbAltB, cmNewButton,
            NewStatusKey('~I~npLn', kbAltI, cmNewInputLine,
            NewStatusKey('~R~dBtns', kbAltR, cmNewRadioButtons,
            NewStatusKey('~C~hkBxs', kbAltC, cmNewCheckBoxes,
            NewStatusKey('~M~ltBxs', kbAltM, cmNewMultiCheckBoxes,
            NewStatusKey('~L~stBx', kbAltL, cmNewListBox,
{$IFDEF ScreenCapture}
            NewStatusKey('', kbAltZ, cmScreenCapture,
{$ENDIF}
            NewStatusKey('', kbF2, cmSwapDialogs,
            NewStatusKey('', kbF10, cmMenu,
            NewStatusKey('', kbCtrlF5, cmResize,
            nil)))))))))))))
{$IFDEF ScreenCapture}
            )
{$ENDIF}
        , nil)
    ));
end; {TDialEditApp.InitStatusLine}


procedure TDialEditApp.GenCode(ATrialDialog: PTrialDialog);
begin
    if ATrialDialog <> nil then begin
        { open code output if not already: }
        OpenCodeFile;
        { then generate code for current dialog: }
        if OutOptData.RInclude and 1 = 1 then
          begin
            writeln('(*');
            with OutOptData do
            TrialDialog^.SnapPicture(RShow, RShades);
            writeln('*)');
          end;
        ValUsed:= false;
        CodeGen.GenPart:= gpDialogHeader;
        ATrialDialog^.GenCode;
        GenImplementation;
        CodeGen.GenPart:= gpDialogInit;
        ATrialDialog^.GenCode;
        CloseCodeFile;
    end;
end; {TDialEditApp.GenCode}

{   NOTE: TApplication handles cmTile, cmCascade, & cmDosShell,
    and its ancestor TProgram handles Alt-1 .. Alt-9 & cmQuit.
}
procedure TDialEditApp.HandleEvent(var Event: TEvent);

    procedure NewDialog;
    var
        PV: PView;
        DialogData: TDialogData;
//        DialogDatasize: Integer;
    begin
        if ModeToken^.State and sfPaste <> 0
        then DialogData:= Paste.DDialog
        else DialogData:= Default.DDialog;
//        DialogDatasize:=Sizeof(DialogData);
        case ExecuteDialog(New(PDialogDialog, Init(Trialdialog,false)),
                @DialogData)
        of
         cmOk:
            begin
                if TrialDialog <> nil then TrialDialog^.Close;
                PV:= ValidView(New(PTrialDialog, Init(@DialogData)));
                DeskTop^.Insert(PV);
                TrialDialog:= PTrialDialog(PV);
                Changed:= true;
            end;

         cmSetDefault: Default.DDialog:= DialogData;

         cmSetPaste: Paste.DDialog:= DialogData;

         {else cmCancel}
        end; {case}
    end; {NewDialog}

    procedure NewStaticText;
    var
        StaticTextData: TStaticTextData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then StaticTextData:= Paste.DStaticText
        else StaticTextData:= Default.DStaticText;

        case ExecuteDialog(New(PStaticTextDialog, Init(TrialDialog,false)),
                @StaticTextData)
        of
         cmOk:
            if StaticTextData.RText <> '' then begin
                TrialDialog^.Insert(ValidView(New(PTrialStaticText,
                    Init(TrialDialog,@StaticTextData,nil))));
                Changed:= true;
            end;

         cmSetDefault: Default.DStaticText:= StaticTextData;

         cmSetPaste: Paste.DStaticText:= StaticTextData;

        end; {case}
    end; {NewStaticText}

    procedure NewParamText;
    var
        ParamTextData: TParamTextData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ParamTextData:= Paste.DParamText
        else ParamTextData:= Default.DParamText;

        case ExecuteDialog(New(PParamTextDialog, Init(Trialdialog,false)),
                @ParamTextData)
        of
         cmOk:
            with ParamTextData do
            if (RFormat <> '') and (RNames <> '') then begin
                TrialDialog^.Insert(ValidView(New(PTrialParamText,
                    Init(TrialDialog,@ParamTextData))));
                Changed:= true;
            end;

         cmSetDefault: Default.DParamText:= ParamTextData;

         cmSetPaste: Paste.DParamText:= ParamTextData;

        end; {case}
    end; {NewParamText}

    procedure NewButton;
    var
        ButtonData: TButtonData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ButtonData:= Paste.DButton
        else ButtonData:= Default.DButton;

        case ExecuteDialog(New(PButtonDialog, Init(self.Owner,false)),
                @ButtonData)
        of
         cmOk:
            begin
                TrialDialog^.Insert(ValidView(New(PTrialButton,
                    Init(TrialDialog,@ButtonData))));
                Changed:= true;
            end;

         cmSetDefault: Default.DButton:= ButtonData;

         cmSetPaste: Paste.DButton:= ButtonData;

        end; {case}
    end; {NewButton}

    procedure NewInputLine;
    var
        InputLineData: TInputLineData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then InputLineData:= Paste.DInputLine
        else InputLineData:= Default.DInputLine;

        case ExecuteDialog(New(PInputLineDialog, Init(Trialdialog,false)),
            @InputLineData)
        of
         cmOk:
            begin
                TrialDialog^.Insert(ValidView(New(PTrialInputLine,
                    Init(TrialDialog,@InputLineData))));
                Changed:= true;
            end;

         cmSetDefault: Default.DInputLine:= InputLineData;

         cmSetPaste: Paste.DInputLine:= InputLineData;

        end; {case}
    end; {NewInputLine}

    procedure NewRadioButtons;
    var
 //       I: integer;
        ClusterData: TClusterData;
        RB: PTrialRadioButtons;
        Cmd: word;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ClusterData:= Paste.DRadioButtons
        else ClusterData:= Default.DRadioButtons;
        InitStrings(ClusterData);

        Cmd:= ExecuteDialog(New(PClusterDialog, Init(TrialDialog,false, 'RB')),
                @ClusterData);

        case Cmd of
         cmOk:
            with ClusterData do begin
                RB:= New(PTrialRadioButtons, Init(TrialDialog,@ClusterData));
                RB^.TC.Resize(RB^, RB^.LabelP);
                TrialDialog^.Insert(ValidView(RB));
                Changed:= true;
            end;

         cmSetDefault: Default.DRadioButtons:= ClusterData;

         cmSetPaste:
            begin
                Paste.DRadioButtons:= ClusterData;
                CopyStrings(PasteStrings, ClusterData.RStrings);
                CopyStrings(PasteNames, ClusterData.RItemNames);
            end;

         {else cmCancel}
        end; {case}
        Dispose(ClusterData.RStrings,done);
        Dispose(ClusterData.RItemNames,Done);
    end; {NewRadioButtons}

    procedure NewCheckBoxes;
    var
//        I: integer;
        ClusterData: TClusterData;
        CB: PTrialCheckBoxes;
        Cmd: word;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ClusterData:= Paste.DCheckBoxes
        else ClusterData:= Default.DCheckBoxes;
        InitStrings(ClusterData);

        Cmd:= ExecuteDialog(New(PClusterDialog, Init(Trialdialog,false, 'CB')),
                @ClusterData);

        case Cmd of
         cmOk:
            with ClusterData do begin
                CB:= New(PTrialCheckBoxes, Init(TrialDialog,@ClusterData));
                CB^.TC.Resize(CB^, CB^.LabelP);
                TrialDialog^.Insert(ValidView(CB));
                Changed:= true;
            end;

         cmSetDefault: Default.DCheckBoxes:= ClusterData;

         cmSetPaste:
            begin
                Paste.DCheckBoxes:= ClusterData;
                CopyStrings(PasteStrings, ClusterData.RStrings);
                CopyStrings(PasteNames, ClusterData.RItemNames);
            end;

         {else cmCancel}
        end; {case}
          Dispose(ClusterData.RStrings,Done);
         Dispose(ClusterData.RItemNames,Done);
    end; {NewCheckBoxes}

    procedure NewMultiCheckBoxes;
    var
        ClusterData: TClusterData;
        CB: PTrialMultiCheckBoxes;
        Cmd: word;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ClusterData:= Paste.DMultiCheckBoxes
        else ClusterData:= Default.DMultiCheckBoxes;
        InitStrings(ClusterData);

        Cmd:= ExecuteDialog(New(PClusterDialog, Init(Trialdialog,false, 'MB')),
                @ClusterData);

        case Cmd of
         cmOk:
            with ClusterData do begin
                CB:= New(PTrialMultiCheckBoxes, Init(TrialDialog,@ClusterData));
                CB^.TC.Resize(CB^, CB^.LabelP);
                TrialDialog^.Insert(ValidView(CB));
                Changed:= true;
            end;

         cmSetDefault: Default.DMultiCheckBoxes:= ClusterData;

         cmSetPaste:
            begin
                Paste.DMultiCheckBoxes:= ClusterData;
                CopyStrings(PasteStrings, ClusterData.RStrings);
                CopyStrings(PasteNames, ClusterData.RItemNames);
            end;

         {else cmCancel}
        end; {case}
         Dispose(ClusterData.RStrings,Done);
         Dispose(ClusterData.RItemNames,Done);
    end; {NewMultiCheckBoxes}

    procedure NewListBox;
    var
        ListBoxData: TListBoxData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ListBoxData:= Paste.DListBox
        else ListBoxData:= Default.DListBox;

        case ExecuteDialog(New(PListBoxDialog, Init(TrialDialog,false)),
            @ListBoxData)
        of
         cmOk:
            begin
                TrialDialog^.Insert(ValidView(New(PTrialListBox,
                    Init(TrialDialog,@ListBoxData))));
                Changed:= true;
            end;

         cmSetDefault: Default.DListBox:= ListBoxData;

         cmSetPaste: Paste.DListBox:= ListBoxData;

        end; {case}
    end; {NewListBox}

    procedure SnapIt;
    begin
        if TrialDialog <> nil then begin
            { open code output if not already: }
            OpenCodeFile;
            writeln('(*');
            with OutOptData do
            TrialDialog^.SnapPicture(RShow, RShades);
            writeln('*)');
            CloseCodeFile;
        end;
    end; {SnapIt}

    procedure SetFiles;
    var
        TempOpts: TFileOptData;
        CollChg, CodeChg, HistChg: boolean;
    begin
        TempOpts:= FileOptData;
        ExecuteDialog(New(PFileOptDialog, Init), @TempOpts);
        CollChg:= FileOptData.CollFName <> TempOpts.CollFName;
        CodeChg:= FileOptData.CodeFName <> TempOpts.CodeFName;
        HistChg:= FileOptData.HistFName <> TempOpts.HistFName;
        if CollChg then CloseCollFile;
        if CodeChg then CloseCodeFile;
        if HistChg then WriteHistory;
        FileOptData:= TempOpts;
        { new Res, Out files opened when first needed }
        if HistChg then ReadHistory;
    end; {SetFiles}

    procedure SetOutput;
    begin
        with OutOptData do begin
            OutOptData:= Default.DOutOpt;
            OutOptData.RSave:= 0;
            { set up output options: }
            if ExecuteDialog(New(POutOptDialog, Init),
                @OutOptData) <> cmCancel
            then begin
                if OutOptData.RInclude = 0 then begin
                    MessageBox('No output selected.',
                        nil, mfError+mfOkButton);
                end else begin
                    case OutOptData.RIndent of
                     0: Tab:= #9;       {T}
                     1: Tab:= '    ';   {4}
                     2: Tab:= '   ';    {3}
                     3: Tab:= '  ';     {2}
                     4: Tab:= ' ';      {1}
                    end; {case}
                    { pick dialogs and output: }
                    FetchDialog(true);
                end;
                if OutOptData.RSave <> 0
                then Default.DOutOpt:= OutOptData;
            end;
        end;
    end; {SetOutput}

begin {TDialEditApp.HandleEvent}
    inherited HandleEvent(Event);
    case Event.What of
     evCommand:
        case Event.Command of
         cmNewDialog: NewDialog;

         cmNewStaticText: NewStaticText;

         cmNewParamText: NewParamText;

         cmNewButton: NewButton;

         cmNewInputLine: NewInputLine;

         cmNewRadioButtons: NewRadioButtons;

         cmNewCheckBoxes: NewCheckBoxes;

         cmNewMultiCheckBoxes: NewMultiCheckBoxes;

         cmNewListBox: NewListBox;

         cmSaveDialog: SaveDialog;

         cmDeleteDialog: DeleteDialog;

         cmFetchDialog: FetchDialog(false);

         cmSwapDialogs:
            begin
                AutoSave:= true;
                GetDialog(PrevDialog);
                AutoSave:= false;
            end;

         cmTestDialog: TestDialog;

         cmGenCode: GenCode(TrialDialog);

         cmOutput: SetOutput;

         cmSnapPicture: SnapIt;

         cmSetFiles: SetFiles;

         cmChangeDir:
            ExecuteDialog(New(PChDirDialog, Init(cdNormal, 0)), nil);
          sfPaste:
{$IFDEF ScreenCapture}
         cmScreenCapture:
            begin
                GetExtent(R);
                ScreenCapture(R);
            end;
{$ENDIF}

         else exit;
        end;
     else exit;
    end;
    ClearEvent(Event);
end; {TDialEditApp.HandleEvent}

procedure TDialEditApp.Idle;
begin
    inherited Idle;
    Clock^.Update;
{$IFNDEF VPASCAL}
    Heap^.Update;
{$ENDIF}
    SwapToken^.Update;
end;

procedure TDialEditApp.OutOfMemory;
begin
    MessageBox('Not enough memory for this operation.',
        nil, mfError + mfOkButton);
end; {TDialEditApp.OutOfMemory}

{*******************************************************}

end.

