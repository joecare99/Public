unit cls_fv2time;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

function FVCurrentTimeText: string;

implementation

function FVCurrentTimeText: string;
begin
  Result := FormatDateTime('hh:nn:ss', Now);
end;

end.
