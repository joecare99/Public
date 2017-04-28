unit str_statictextdata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  views;

type
    PStaticTextData = ^TStaticTextData;
    TStaticTextData = packed record
        RText: TTitleStr;
    end;

implementation

end.

