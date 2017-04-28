unit str_ParamTextData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Views;

type
    PParamTextData = ^TParamTextData;
    TParamTextData = packed record
        RFormat: TTitleStr;
        RNames: TTitleStr;
    end;


implementation

end.

