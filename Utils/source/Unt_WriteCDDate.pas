unit Unt_WriteCDDate;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

Procedure Run(Filename:string);
Function ShowHelp:string;

implementation

uses Sysutils;

const Newline:String = #10#13;

resourcestring
  rsConstADateS = 'Const ADate = ''%s'';';
  rsHelp = 'Dieses Programm schreibt eine Pascal/Delphi include-Datei mit'+ NewLine +
        'dem Aktuellen Datum in die angegebene Datei.'+Newline+
       Newline+
       'Diese wird mit {$I <Datei>} eingebunden.'+Newline+
       Newline+
       'Das Compile-Datum steht als String in der Konstanten: ADate'+Newline+
       Newline+
       'Aufruf: %s <Datei>'+Newline;

Procedure Run;

var t:text;
  aFS: TFormatSettings;

begin
       AssignFile(t,Filename);
       rewrite(t);
       aFS.DateSeparator := '.';
       aFS.ShortDateFormat := 'dd/mm/yyyy';
       writeln(t, format(rsConstADateS, [DateToStr(Date, aFS)]);
       CloseFile(t);
end;

Function ShowHelp:string;
begin
  result:=format(rsHelp,[paramstr(0)]);
end;

end.
