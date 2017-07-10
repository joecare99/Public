unit unt_iupcc_bsp;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils;

const
    CntCnt = 10;
    CntData: array[1..CntCnt - 1] of single = (1,2,3,4,5,6,7,8.9,10);

implementation


function hash(Value:integer):integer;

begin
  result := abs(Value) mod 23;
end;

end.

