program DCUEndMarkersSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeDCUDumper;

procedure Require(Value: Boolean; const MessageText: string);
begin
  if not Value then
    raise Exception.Create(MessageText);
end;

var
  Lines: TStringList;
begin
  Lines := TStringList.Create;
  try
    Lines.Add('begin');
    Lines.Add('end;');
    Lines.Add('end;');
    FixDCUEndMarkers(Lines);
    Require(Lines.Count = 2,
      'Adjacent duplicate end markers were not collapsed');
    Require((Lines[0] = 'begin') and (Lines[1] = 'end;'),
      'The begin/end pair changed while removing a duplicate');

    Lines.Clear;
    Lines.Add('end;');
    Lines.Add('begin');
    Lines.Add('end;');
    FixDCUEndMarkers(Lines);
    Require(Lines.Count = 3,
      'A leading end marker caused an invalid boundary access');
    Require((Lines[0] = 'end;') and (Lines[1] = 'begin') and
      (Lines[2] = 'end;'),
      'The boundary case was unexpectedly rewritten');

    Lines.Clear;
    FixDCUEndMarkers(Lines);
    Require(Lines.Count = 0, 'An empty DCU output list changed');
    WriteLn('DCU end-marker smoke test passed');
  finally
    Lines.Free;
  end;
end.
