{$APPTYPE CONSOLE}
(*
 * This simple program demonstrates CRT I/O. Compile the
 * program from a DOS prompt window using the command:
 *
 * dcc32 -cc keytest
 *
 * Type KEYTEST and press Enter to run the program from
 * a DOS-prompt.
 *)
program KeyTest;
var
 Ch: Char;
begin
  Writeln('Keyboard tester. Press <key>+Enter.');
  Writeln('To quit, press Ctrl+C,');
  Writeln('or close the window.');
  Writeln;  { Output a blank line }
  repeat
    Read(Ch);             { Read from keyboard }
    Writeln(Ord(Ch):4);   { Show its value }
  until False;  { That is, "forever." }
end.

