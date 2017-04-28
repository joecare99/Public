unit str_OutOptData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  objects;

type
    POutOptData = ^TOutOptData;
    TOutOptData = packed record
        RSave: sw_word;
        RInclude: sw_word;
        RShow: sw_word;
        RShades: longint;
        GenFormat: sw_word;
        RIndent: longint;
    end;

implementation

end.

