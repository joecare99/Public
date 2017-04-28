unit Str_DialogData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  objects,views;

type
    PDialogData = ^TDialogData;
    TDialogData = packed record
        RTitle: TTitleStr;
        ROptions: sw_word;
        RBaseName: TTitleStr;
        RTypeName: TTitleStr;
    end;
    { Base and Type names are used as in: }
    { TBaseType = object(TType)           }
    { TBaseData = record    (etc.)        }
    { Type is generally Window or Dialog. }

{ values for TDialogData.ROptions: }
const
    doGenDefaults   = $01;
    doCentered      = $02;
    doOkButton      = $04;
    doCancelButton  = $08;

implementation

end.

