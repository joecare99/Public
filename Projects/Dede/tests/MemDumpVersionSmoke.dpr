program MemDumpVersionSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeMemDumps;

procedure Require(Value: Boolean; const MessageText: string);
begin
  if not Value then
    raise Exception.Create(MessageText);
end;

var
  Stream: TMemoryStream;
begin
  Require(MapDelphiVersionMarker($FFF0) = 2,
    'Delphi 2 marker mapped incorrectly');
  Require(MapDelphiVersionMarker(0) = 3,
    'Delphi 3 marker mapped incorrectly');
  Require(MapDelphiVersionMarker($114) = 4,
    'Delphi 4 marker mapped incorrectly');
  Require(MapDelphiVersionMarker($120) = 5,
    'Delphi 5 marker mapped incorrectly');
  Require(MapDelphiVersionMarker($15C) = 6,
    'Delphi 6 marker mapped incorrectly');
  Require(MapDelphiVersionMarker($160) = 6,
    'Alternate Delphi 6 marker mapped incorrectly');
  Require(MapDelphiVersionMarker($FFFF) = 0,
    'Unknown marker selected a Delphi entry-point pattern');
  Require(MemGetDelphiVersionOfAProcess(0) = $FFFF,
    'A process-open failure did not return the unknown-version marker');

  Stream := TMemoryStream.Create;
  try
    Require(GetRVAEntryPoint(Stream, $400000, 0, 0, 0, False) = 0,
      'Unknown compiler version returned an entry point');
  finally
    Stream.Free;
  end;
  WriteLn('Memory dump version smoke test passed');
end.
