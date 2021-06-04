unit DialEditBase;

{$mode objfpc}{$H+}

interface

uses objects,Views,dialogs;

type
    String5 = string[5];

    TShortName = string[2];

    PString=objects.PString;
{ command codes }

const
    cmNewDialog         = 111;
    cmNewStaticText     = 112;
    cmNewParamText      = 113;
    cmNewButton         = 114;
    cmNewInputLine      = 115;
    cmNewRadioButtons   = 116;
    cmNewCheckBoxes     = 117;
    cmNewMultiCheckBoxes =118;
    cmNewListBox        = 119;

    cmDelete            = cmNo;
    cmPutOnTop          = cmYes;
    cmEditItem          = 120;
    cmNewItem           = 121;

    cmSaveDialog        = 122;
    cmDeleteDialog      = 123;
    cmFetchDialog       = 124;
    cmGenCode           = 125;
    cmSnapPicture       = 126;
    cmSetFiles          = 127;
    cmSetDefault        = 128;
    cmSetPaste          = 129;
    cmOutput            = 130;
    cmSwapDialogs       = 131;
    cmTestDialog        = 132;
{$IFDEF ScreenCapture}
    cmScreenCapture     = 150;  {Alt-Z}
{$ENDIF}

    cmsNewControls = [
        cmNewStaticText, cmNewParamText, cmNewButton, cmNewInputLine,
        cmNewRadioButtons, cmNewCheckBoxes, cmNewMultiCheckBoxes,
        cmNewListBox, cmSaveDialog, cmDeleteDialog, cmGenCode,
        cmSnapPicture, cmTestDialog
    ];

    TitleLen = SizeOf(TTitleStr)-1;

    IDChars = ['a'..'z', 'A'..'Z', '0'..'9', '_'];
    ShadeChars: String5 = ' '#177#178#179#219;
    chLightHatch=#$B0;
    chMedHatch=#$B1;
    chTrippleBar=#$F0;

{ history ID codes }

    hiDialogName = 102;
    hiStaticText = 103;
    hiDataName   = 104;
    hiCmdName    = 105;
    hiLabelText  = 106;
    hiValPars    = 107;
    hiStates     = 108;
    hiHistID     = 109;
    hiCollFile   = 110;
    hiHistFile   = 111;
    hiCodeFile   = 112;
    hiTestID     = 113;  {for 'real' history objects}

{ values for GenVars, indicating dialog variables needed: }

    gvInputLine     = $0001;  {IL}
    gvRadioButtons  = $0002;  {RB}
    gvCheckBoxes    = $0004;  {CB}
    gvMultiCheckBoxes=$0008;  {MB}
    gvScrollBar     = $0010;  {SB}
    gvListBox       = $0020;  {LB}

    { Token }
    sfPaste = $4000;    {special}

{ parts of generated code, in outline form: }
type
    TGenPart = (
        gpDisabled,  {others imply enabled}

        { for generating TV code output: }
        gpFileHeader,
        gpInterface,            {not used}
            gpDialogHeader,
                gpDataFields,
                gpDataConsts,
            gpDataHeader,
                gpDataValues,
        gpImplementation,       {not used}
            gpHistConsts,
            gpDialogInit,
                gpControls,
            gpDialogFooter,
        gpFileFooter,

        { for generating picture output: }
        gpPicture,              {not used}

        { for creating real dialog from trial dialog: }
        gpClone
    );


    PClusterData = ^TClusterData;
    TClusterData = packed record
        RLabel: TTitleStr;
        RDataName: TTitleStr;
        RStrings: PStringCollection;
        RFocused: integer;
        RItemNames: PStringCollection;
        RNFocused: integer;
        RStates: TTitleStr; {for MultiCheckBoxes only}
        RShortName: TShortName;
    end;

    PTrackTargetLabel= ^TTrackTargetLabel;
    TTrackTargetLabel=object(dialogs.TLabel)
         procedure TrackTarget(const OldR: TRect);virtual;abstract;
    end;

    TDelegate=procedure(ZView:PView) of object;

    TCodeGenerator=record
        GenPart:        TGenPart;   {code generation phase}  //Todo -JC: deglobalize
        GenVars: word;
        RealDialog:     PDialog;        {current test dialog}
        Semicolon: boolean;
        LLink: PView deprecated 'use local zLink';
        ListHistConsts: boolean;    {history ID names used}
        ListClustConsts: boolean;    {cluster ID names used}
        HistIdVal: word;
    end;

var Changed:boolean; //Todo -oJC: Globale variablen reduzieren
    CodeGen:TCodeGenerator;

     Tab:            string5;    {for indenting output code}

     DLim:           TRect;      {for dialog placement}

    PasteStrings:   PStringCollection;  {  "     "  for item strings}
    PasteNames:     PStringCollection;  {  "     "  for item names}
    ModeToken:      PView;             {paste / default indicator}

implementation

end.

