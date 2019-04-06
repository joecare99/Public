unit Unt_BigFontTest;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

Procedure Execute;

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ELSE}
{$ENDIF}
  classes,
  Win32Crt,
  unt_BIGFONT;

resourcestring
  SHelloWorld = 'Hello'+LineEnding+' World !';
  Slauf = 'Dies ist ein Laufschrift, die paralell zu der Schreibschrift läuft. ' +
    'Dies soll ein bißchen paralell - Computerei simulieren (Demomäßig)      ';

var
  lauf: string = Slauf;


Procedure Execute;

var
  x, y, i: byte;
  scribevec: array [0 .. 2000] of byte;
  Stream: TStream;

begin
  {$IFDEF MSWINDOWS}
  if FindResource(hInstance, 'SCRIBE', RT_RCDATA) <> 0 then
    begin // Ist die Ressource verfügbar
      Stream := TResourceStream.Create(hInstance, 'SCRIBE', RT_RCDATA);
      // Stream erstellen
      try
        Stream.ReadBuffer(scribevec, Stream.Size);
      finally
        Stream.free;
      end;
    end;
 {$ENDIF}
 for i := 1 to 3 do
   begin
     bigwrite(5 - i, 4 - i, copy('.+O', i, 1), SHelloWorld, @scribevec);
     bigwrite(5 - i, 5 - i, copy('.+O', i, 1), SHelloWorld, @scribevec);
   end;
 textcolor(15);
 bigwrite(1, 1, #219, SHelloWorld, @scribevec);
 readln;
 clrscr;
  for i := 1 to 3 do
    begin
      bigwrite(5 - i, 4 - i, copy('.+°', i, 1), writestr, @scribevec);
      bigwrite(5 - i, 5 - i, copy('..°', i, 1), writestr, @scribevec);
    end;
  textcolor(15);
  bigwrite(1, 1, #219, writestr, @scribevec);
  readln;
  clrscr;
  textcolor(7);
  getbiginit(1, 1);
  getbigpoint(x, y, @scribevec);
  while (x <> 0) and (y <> 0) and not keypressed do
    begin
      gotoxy(1, 24);
      write(copy(lauf, 1, 79));
      lauf := lauf + lauf[1];
      delete(lauf, 1, 1);
      gotoxy(x, y);
      write('+');
      delaY(50);
      getbigpoint(x, y, @scribevec);
    end;
  getbiginit(1, 1);
  getbigpoint(x, y, @scribevec);
  while ((x <> 0) and (y <> 0)) and not keypressed do
    begin
      gotoxy(1, 24);
      textcolor(7);
      write(copy(lauf, 1, 79));
      lauf := lauf + lauf[1];
      delete(lauf, 1, 1);
      gotoxy(x, y);
      textcolor(14);
      write('#');
      delaY(50);
      getbigpoint(x, y, @scribevec);
    end;
  repeat
    gotoxy(1, 24);
    write(copy(lauf, 1, 79));
    lauf := lauf + lauf[1];
    delete(lauf, 1, 1);
    delaY(50);
  until keypressed and (readkey in [#13, #27, ' ']);
end;

// donewincrt;
end.
