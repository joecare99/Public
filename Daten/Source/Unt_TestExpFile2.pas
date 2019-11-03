UNIT Unt_TestExpFile2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

INTERFACE

PROCEDURE Execute;

IMPLEMENTATION

USES sysutils,
  unt_CDate,
  Cmp_SEWFile;

RESOURCESTRING
  SHelpStr = 'Dieses Programm dient zum formatieren einer SEW-EXP-Datei.' + #10#13#10#13 +
    'Aufruf:' + #10#13 + '%s <filename>' + #10#13#10#13 + 'Compiliert: %s'+#10#13+
    'Weiter mit <ENTER>';

PROCEDURE Execute;
BEGIN
  TRY
    IF paramcount = 0 THEN
      BEGIN
        reset(input);
        IF true THEN
          BEGIN
            writeln(format(SHelpStr, [extractfilename(paramstr(0)), CDate]));
            readln;
          END

      END
    ELSE IF (paramstr(1) <> '') AND FileExists(paramstr(1)) THEN
      BEGIN
        sewfile.loadfromfile(paramstr(1));
        sewfile.autoformat;
        sewfile.Lines.SaveToFile(paramstr(1) + '.NEW');
      END;
  EXCEPT
    ON E: Exception DO
      writeln(E.ClassName, ': ', E.Message);
  END;
END;

END.
