unit Unt_Filter;

interface

procedure Execute;

implementation

uses sysutils,
  unt_cdate;

  Resourcestring
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>15.04.2008</since>
  ///  <version>1.00.03</version>
  ///  <info>Hilfetext zum Anzeigen</info>
  StrHelpStr = '%s ist ein Programm um das Carridge-Returns (chr(13)) aus einem '#10#13 +
    'Text-stream herausfiltert, so das der gesamte Text in einer Zeile steht '#10#13 +
    'und somit einem 2. Programm als Parameter uebergeben werden kann.'#10#13 +
    #10#13 + 'Aufruf: type <textdatei> |%s   '#10#13 +
    #10#13 + 'Compiliert am %s';

Procedure Execute;
Var ch: char;
  fn: String;

Begin
  If (ParamCount = 1) And (uppercase(paramstr(1)[2]) = 'H') Then
    Begin
      fn := extractfilename(paramstr(0));
      writeln(format(StrHelpStr, [FN, FN, CDate]));
      readln
    End
  Else
    Begin
      assign(output, '');
      assign(input, '');
      reset(input);
      rewrite(output);
      Repeat
        read(ch);
        If ch <> #13 Then
          write(ch)

      Until eof(input)
    End;
end;

end.
