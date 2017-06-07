unit Unt_a2dType;

{$IFDEF FPC}
   {$MODE Delphi}
{$ENDIF}

interface

Procedure Execute;

implementation

uses sysutils,
  unt_Stringprocs,
  unt_cdate;

Resourcestring
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>15.04.2008</since>
  ///  <version>1.00.03</version>
  ///  <info>Hilfetext zum Anzeigen</info>
  StrHelpStr = '%s ist ein Programm um das ANSI-Sonderzeichen aus einem'+vbnewline +
    'Text-stream wenn möglich durch die Entsprechenden OEM-Zeichen'+vbnewline +
    'ersetzt. Zur Zeit werden folgende Zeichen unterstützt:'+vbnewline +
    #9'"%s"'+vbnewline +
    #10#13 + 'Aufruf 1: type <textdatei> | %s'+vbnewline +
    'Aufruf 2: %s <textdatei>'+vbnewline +
    #10#13 + 'Compiliert am %s';

Var
  ch: char;
  fn: String;

Procedure Execute;

Begin
  If (ParamCount = 1)
    And (charinset(paramstr(1)[1] , ['/', '-']))
    And (uppercase(paramstr(1)[2]) = 'H') Then
    Begin
      fn := extractfilename(paramstr(0));
      writeln(ansi2ascii(format(StrHelpStr, [FN, asciiansi[0], FN, FN, CDate])));
      readln
    End
  Else
    Begin
      If paramcount > 0 Then
        AssignFile(input, ParamStr(1))
      Else
        Assign(input, '');
      assign(output, '');
      reset(input);
      rewrite(output);
      Repeat
        read(ch);
        write(ansi2ascii(ch))
      Until eof(input)
    End;
End;

end.
