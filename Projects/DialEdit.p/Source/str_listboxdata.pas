unit str_ListBoxData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, views;

type
    PListBoxData = ^TListBoxData;
    TListBoxData = record
        RLabel: TTitleStr;
        RListName: TTitleStr;
        RSelectName: TTitleStr;
        RNumCols: longint;
    end;

implementation

end.

