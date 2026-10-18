unit cls_fv2sysmsg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function FVMessageText(const AText: string): string;

implementation

function FVMessageText(const AText: string): string;
begin
  Result := AText;
end;

end.
