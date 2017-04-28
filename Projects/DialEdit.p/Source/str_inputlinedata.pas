unit str_InputLineData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  objects,views;

type
    PInputLineData = ^TInputLineData;
    TInputLineData = packed record
        RLabel: TTitleStr;
        RDataName: TTitleStr;
        RMaxLen: longint;
        RHistStr: TTitleStr;
        RValidate: sw_word;
        RValPars: TTitleStr;
    end;



implementation

end.

