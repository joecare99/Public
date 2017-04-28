unit dialeditDefaults;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  dialogs,

  DialEditBase, Str_DialogData, str_statictextdata,
  str_InputLineData,str_ParamTextData,str_ButtonData,
  str_ListBoxData, str_OutOptData;

{ Default / Paste object-edit data buffers }

type
    TEditBuffer = record
        DDialog:        TDialogData;
        DStaticText:    TStaticTextData;
        DParamText:     TParamTextData;
        DButton:        TButtonData;
        DInputLine:     TInputLineData;
        DRadioButtons:  TClusterData;
        DCheckBoxes:    TClusterData;
        DMultiCheckBoxes: TClusterData;
        DListBox:       TListBoxData;
        DOutOpt:        TOutOptData;
    end;

const
    Default: TEditBuffer = (
        DDialog: (
            RTitle: 'Test Dialog';
            ROptions: $0E;
            RBaseName: 'Test';
            RTypeName: 'Dialog'
        );
        DStaticText: (
            RText: ''
        );
        DParamText: (
            RFormat: '';
            RNames: ''
        );
        DButton: (
            RTitle: '~N~o';
            RCmdName: 'cmNo';
            RFlags: bfNormal
        );
        DInputLine: (
            RLabel: '~N~ame';
            RDataName: 'Name';
            RMaxLen: 80;
            RHistStr: '';
            RValidate: 0;
            RValPars: ''
        );
        DRadioButtons: (
            RLabel: '~M~ode';
            RDataName: 'Mode';
            RStrings: nil;
            RFocused: 0;
            RItemNames: nil;
            RNFocused: 0;
            RStates: '';
            RShortName: 'RB'
        );
        DCheckBoxes: (
            RLabel: '~O~ptions';
            RDataName: 'Options';
            RStrings: nil;
            RFocused: 0;
            RItemNames: nil;
            RNFocused: 0;
            RStates: '';
            RShortName: 'CB'
        );
        DMultiCheckBoxes: (
            RLabel: '~C~hoices';
            RDataName: 'Choices';
            RStrings: nil;
            RFocused: 0;
            RItemNames: nil;
            RNFocused: 0;
            RStates: '<=>';
            RShortName: 'MB'
        );
        DListBox: (
            RLabel: '~S~election';
            RListName: 'List';
            RSelectName: 'Selection';
            RNumCols: 1
        );
        DOutOpt: (
            RSave: 0;
            RInclude: 1;
            RShow: 0;
            RShades: $32;
            GenFormat: 1;
            RIndent: 0
        )
    );

var
      Paste:          TEditBuffer;        {paste buffer for edits}

implementation

end.

