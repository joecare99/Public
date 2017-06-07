unit Unt_WriteCDDate2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{ *V 1.00.03 }
{ *H 1.00.02 Einfuegen von Together-Modell-Tags }
{ *H 1.00.01 Moeglichkeit auch eine Unit zu erstellen [/u] }

interface

Procedure Execute;

implementation

uses SysUtils,
  unt_CDate;

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
  /// <since>15.04.2008</since>
  /// <version>1.00.03</version>
  /// <info>Umwandeltext fuer ADate</info>
  StrADate = '  ///<author>Rosewich</author>'#10#13 +
    '  ///  <user>%1:s</user>'#10#13 + '  ///  <since>%0:s</since>'#10#13 +
    '  ///  <version>1.00.03</version>'#10#13 +
    '  ///  <info>Aktuelles Datum</info>'#10#13 + '  ADate = ''%0:s'';';
  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>15.04.2008</since>
  /// <version>1.00.03</version>
  /// <info>Umwandeltext fuer CDate</info>
  StrCDate = '  ///<author>Rosewich</author>'#10#13 +
    '  ///  <user>%1:s</user>'#10#13 + '  ///  <since>%0:s</since>'#10#13 +
    '  ///  <version>1.00.03</version>'#10#13 +
    '  ///  <info>Compile-Datum</info>'#10#13 + '  CDate = ''%0:s'';';

  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>15.04.2008</since>
  /// <version>1.00.03</version>
  /// <info>Umwandeltext fuer CName/info>
  StrCName = '  ///<author>Rosewich</author>'#10#13 +
    '  ///  <user>%2:s</user>'#10#13 + '  ///  <since>%0:s</since>'#10#13 +
    '  ///  <version>1.00.03</version>'#10#13 +
    '  ///  <info>Computer-Name</info>'#10#13 + '  CName = ''%1:s'';';

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

{$IFDEF MSWINDOWS}
CONST
  cEVUsername='Username';
  cEVComputername='COMPUTERNAME';
{$ELSE}
CONST
  cEVUsername='USER';
  cEVComputername='HOSTNAME';
{$ENDIF}


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
          writeln(f, 'unit ' + copy(fn, 1,
            length(fn) - length(ExtractFileext(fn))) + ';');
          writeln(f, '{$ifdef FPC}{$mode delphi}{$endif ~FPC}');
          writeln(f, 'Interface');
        End;
      writeln(f, 'Resourcestring');
      writeln(f, format(StrADate, [datetostr(now),
        GetEnvironmentVariable(cEVUsername)]));
      writeln(f, format(StrCDate, [datetostr(now),
        GetEnvironmentVariable(cEVUsername)]));
      writeln(f, format(StrCName, [datetostr(now),
        GetEnvironmentVariable(cEVComputername),
        GetEnvironmentVariable(cEVUsername)]));
      If (paramstr(2) = '/u') Or (paramstr(2) = '/U') Then
        Begin
          writeln(f, 'Implementation');
          writeln(f, 'end.');
        End;
      CloseFile(f);
    End;
End;

end.
