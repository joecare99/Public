unit ArrayP;

{ You can compile this program in the Delphi IDE or using the Delphi command
  line compiler.

  To compile this program using the command line compiler, get to a DOS
  prompt, make sure the system path refers to Delphi's bin directory
  (see chapter 21), and enter the following command:

  dcc32 -cc arrayp

  Regardless of how you compile this program, you will probably want to run
  this from a DOS prompt, so you can more easily see the output

  Enter arrayp to run the program. }


{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

Procedure Execute;

implementation

uses SysUtils;

type

  TDayNames = class
  private
    function GetName(N: Integer): String;
  protected
   property DayStr[N: Integer]: String read GetName; default;
  end;

function TDayNames.GetName(N: Integer): String;
begin
  if (N < 0) or (N > 6) then
    raise ERangeError.Create('Array index out of range');
  case N of
    0: Result := 'Sunday';
    1: Result := 'Monday';
    2: Result := 'Tuesday';
    3: Result := 'Wednesday';
    4: Result := 'Thursday';
    5: Result := 'Friday';
    6: Result := 'Saturday';
  end;
end;

Procedure Execute;

var
  DayNames: TDayNames;
  I: Integer;

begin
  DayNames := TDayNames.Create;
  try
    Writeln('Default property (DayNames[I])');
    for I := 0 to 6 do
      Writeln(DayNames[I]);
    Writeln;
    Writeln('Named property (DayNames.DayStr[I])');
    for I := 6 downto 0 do
      Writeln(DayNames.DayStr[I]);
  finally
    DayNames.Free;
  end;
  readln;
end;
end.
