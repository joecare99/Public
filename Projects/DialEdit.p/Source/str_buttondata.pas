unit str_ButtonData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, views;

type
    PButtonData = ^TButtonData;
    TButtonData = packed record
        RTitle: TTitleStr;
        RCmdName: TTitleStr;    {cmXXX name}
        RFlags: byte;           {bfXXX values}
    end;

implementation

end.

