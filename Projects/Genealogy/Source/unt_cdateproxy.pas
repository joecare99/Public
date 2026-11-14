unit unt_CDateProxy;

{$mode delphi}

interface

function CName:String;
function CDate:String;
function ADate:String;

implementation

uses
  unt_CDate;

function CName: String;
begin
  result := unt_CDate.CName;
end;

function CDate: String;
begin
  result := unt_CDate.CDate;
end;

function ADate: String;
begin
  result := unt_CDate.ADate;
end;

end.

