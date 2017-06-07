unit Unt_WriteCDate2;

{*V 1.00.04}
{*H 1.00.03 Unit-Header und -Footer als Ressourcen-String}
{*H 1.00.02 Einfuegen von Together-Modell-Tags }
{*H 1.00.01 Moeglichkeit auch eine Unit zu erstellen [/u] }

interface

Procedure Execute;

implementation

uses 
  SysUtils,
  unt_Cdate;

const Ver='1.00.04';

Resourcestring
  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>15.04.2008</since>
  /// <version>1.00.03</version>
  /// <info>Hilfetext zum Anzeigen</info>
  StrHilfeText = '%0:s ist ein Programm um das Compilationsdatum in das ' +
    'Compilat'#10#13 +
    'einzufuegen. Dies kann mittels der Konstanten ADate oder CDate abgefragt'#10#13
    + 'bzw. angezeigt werden.'#10#13#10#13 +
    'Binden Sie dazu die erstellte Datei z.B: adate.pas'#10#13 +
    'mit  {$i adate.pas}  in den Quelltext ein.'#10#13#10#13 +
    'Aufruf: %0:s <datei> [/U]'#10#13#10#13 + 'Compiliert am %1:s';

  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>23.10.2012</since>
  /// <version>1.00.04</version>
  /// <info>Unit Header</info>
  StrUHeader = 'unit %0:s;'#10#13 +
    '  /// <author>Rosewich</author>'#10#13 +
    '  ///  <user>%2:s</user>'#10#13 +
    '  ///  <since>%1:s</since>'#10#13 +
    '  ///  <version>%3:s</version>'#10#13 +
    'Interface';

  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>23.12.2012</since>
  /// <version>1.00.04</version>
  /// <info>Unit Footer</info>
  StrUFooter = 'implementation'#10#13 +
    'end.';

  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>15.04.2008</since>
  /// <version>1.00.03</version>
  /// <info>Umwandeltext fuer ADate</info>
  StrADate = '  ///<author>Rosewich</author>'#10#13 +
    '  ///  <user>%1:s</user>'#10#13 +
    '  ///  <since>%0:s</since>'#10#13 +
    '  ///  <version>%2:s</version>'#10#13 +
    '  ///  <info>Aktuelles Datum</info>'#10#13 +
    '  ADate = ''%0:s'';';
  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>15.04.2008</since>
  /// <version>1.00.03</version>
  /// <info>Umwandeltext fuer CDate</info>
  StrCDate = '  ///<author>Rosewich</author>'#10#13 +
    '  ///  <user>%1:s</user>'#10#13 +
    '  ///  <since>%0:s</since>'#10#13 +
    '  ///  <version>%2:s</version>'#10#13 +
    '  ///  <info>Compile-Datum</info>'#10#13 +
    '  CDate = ''%0:s'';';

  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>15.04.2008</since>
  /// <version>1.00.03</version>
  /// <info>Umwandeltext fuer CName</info>
  StrCName = '  ///<author>Rosewich</author>'#10#13 +
    '  ///  <user>%2:s</user>'#10#13 +
    '  ///  <since>%0:s</since>'#10#13 +
    '  ///  <version>%3:s</version>'#10#13 +
    '  ///  <info>Computer-Name</info>'#10#13 +
    '  CName = ''%1:s'';';

  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>15.04.2008</since>
  /// <version>1.00.03</version>
  /// <info>Diese Procedure zeigt einen Hilfetext an</info>
  /// <output>Hilfetext in der gewuenschten Formatierung</output>
Procedure DisplayHelpText;
Var
  fn: String;
Begin
  fn := extractfilename(paramstr(0));
  writeln(format(StrHilfeText, [fn, Cdate, #10#13]));
  readln;
End;

/// <author>Rosewich</author>
/// <user>admin</user>
/// <since>15.04.2008</since>
/// <version>1.00.03</version>
/// <info>Diese Procedure schreibt das aktuelle Datum in die uebergebene Datei</info>
Procedure Execute;

Var
  f: text;
  fn: String;

Begin
  If ParamCount = 0 Then
    Begin
      DisplayHelpText;
    End
  Else
    Begin
      assignfile(f, paramstr(1));
      rewrite(f);
      Formatsettings.DateSeparator := '.';
      Formatsettings.ShortDateFormat := 'dd/mm/yyyy';
      If (paramstr(2) = '/u') Or (paramstr(2) = '/U') Then
        Begin
          fn := extractfilename(paramstr(1));
          writeln(f, format(StrUHeader,[copy(fn,1,length(fn)-length(ExtractFileExt(fn))) ,
            datetostr(now),GetEnvironmentVariable('Username'),Ver] ));
        End;
      writeln(f, 'Resourcestring');
      writeln(f, format(StrADate, [datetostr(now),
        GetEnvironmentVariable('Username'),Ver]));
      writeln(f, format(StrCDate, [datetostr(now),
        GetEnvironmentVariable('Username'),Ver]));
      writeln(f, format(StrCName, [datetostr(now),
        GetEnvironmentVariable('COMPUTERNAME'),
        GetEnvironmentVariable('Username'),Ver]));
      If (paramstr(2) = '/u') Or (paramstr(2) = '/U') Then
        Begin
          writeln(f, StrUFooter );
        End;
      CloseFile(f);
    End;
End;

end.
