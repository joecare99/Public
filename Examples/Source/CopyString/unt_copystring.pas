unit unt_CopyString;
{$IFDEF FPC}
{$MODE objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils;

procedure Execute;

implementation

function CopyTonthSpace(aText: string; MaxSpace: integer = 3): string;
const
  Space = ' ';
var
  i: integer;
  PartStr: String;
  spacepos: integer;
  // pc: PChar;
begin
  Result := '';
  // If no spaces to look for, copy string;
  if MaxSpace = 0 then
    begin
      spacepos := 0;
      Result := aText;
    end
  else
    // Build result Word by Word
    for i := 1 to MaxSpace do
      begin
        PartStr := copy(aText,length(Result)+1, length(aText) - length(Result));
        spacepos := pos(Space, PartStr);
        if spacepos <> 0 then
          Result := Result + copy(PartStr, 1, spacepos)
        else
          begin
            Result := aText;
            break;
          end;
      end;
  // Copy the char after the last space
  if spacepos <> 0 then
    Result := Result + copy(PartStr, spacepos + 1, 1);
end;

function TestCode(aText: string; MaxSpace: integer = 3): string;
const
  Space = ' ';
var
  i: integer ;
  spacecount: integer ;
begin
  i := 0;
  spacecount := 0;
  repeat
    if (length(aText) > 0) and (aText[i] = Space) then
      Inc(spacecount);
    Inc(i);
    if (spacecount < MaxSpace) and (i <= length(aText)) then
      begin
        Result := aText;
      end
    else if (spacecount = MaxSpace) and (i <= length(aText)) then
      begin
        Result := copy(aText, 1, i);
        break;
      end;
  until (i > length(aText));
end;

procedure Execute;

begin
  writeln(CopyTonthSpace('In the Name of God'));
  writeln(CopyTonthSpace('In the Name of God, maker of all'));
  writeln(CopyTonthSpace('In my Name'));
  writeln(CopyTonthSpace('In my Name ') + '<');
  writeln(CopyTonthSpace('In my Name  ') + '<');
  writeln(CopyTonthSpace('In my Name', 0));
  writeln(CopyTonthSpace('In  my Name'));
  writeln(CopyTonthSpace('') + '<');
  readln;
  writeln(TestCode('In the Name of God'));
  writeln(TestCode('In the Name of God, maker of all'));
  writeln(TestCode('In my Name'));
  writeln(TestCode('In my Name ') + '<');
  writeln(TestCode('In my Name  ') + '<');
  writeln(TestCode('In my Name', 0));
  writeln(TestCode('In  my Name'));
  writeln(TestCode('') + '<');
  readln
end;

end.
