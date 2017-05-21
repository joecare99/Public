unit unt_TestSingleton;
{$IFDEF FPC}
{$MODE objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, cmp_Singleton1;

procedure Execute;

implementation

procedure Execute;
var
  i: Integer;
begin
  for i := 1 to 10000 do
    begin
      writeln(uSingleton1.ClassName);
      writeln(uSingleton1.ToString);
      uSingleton1.free;
    end;
  readln;
end;

initialization
finalization

writeln('no Error:');
fSingleton1.Free;
writeln('Error:');
write(fSingleton1.ToString);
writeln('end');

end.
