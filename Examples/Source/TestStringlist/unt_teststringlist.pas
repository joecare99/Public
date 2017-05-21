unit Unt_testStringlist;
{$IFDEF FPC}
{$MODE objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils;

procedure Execute;

implementation

procedure TryFind(const S: string; const sl: TStringList);
var
  no: integer;
begin
  Write('Test "' + S);
  if sl.find(S, no) then
    writeln('" found: ' + IntToStr(no))
  else if no < sl.Count then
    writeln('" not found: ' + IntToStr(no) + ' --> ' + sl.Names[no])
  else
    writeln('" not found: ' + IntToStr(no) + ' --! XXX ');
end;

procedure Execute;

var
  sl: TStringList;

begin
  sl := TStringList.Create;
  try
    sl.add('1=Test1');
    sl.add('3=Test3');
    sl.add('2=Test2');
    TryFind('2=Test2', sl);
    sl.Sorted := True;
    TryFind('2=Test2', sl);
    TryFind('2', sl);
    TryFind('0', sl);
    TryFind('1', sl);
    TryFind('2', sl);
    TryFind('3', sl);
    TryFind('4', sl);
  finally
    FreeAndNil(sl);
  end;
  readln;
end;

end.
