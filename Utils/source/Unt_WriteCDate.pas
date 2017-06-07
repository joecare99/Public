unit Unt_WriteCDate;

interface

Procedure Run(Filename:string);
Function ShowHelp:string;

implementation

uses Sysutils;

const Newline:String = #10#13;

Procedure Run;

var t:text;

begin
       AssignFile(t,Filename);
       rewrite(t);
       Formatsettings.DateSeparator := '.';
       Formatsettings.ShortDateFormat := 'dd/mm/yyyy';
       writeln(t,'Const ADate = '''+DateToStr(Date)+''';');
       CloseFile(t);
end;

Function ShowHelp:string;
begin
  result:='Dieses Programm schreibt eine Pascal/Delphi include-Datei mit'+ NewLine +
        'dem Aktuellen Datum in die angegebene Datei.'+Newline+
       Newline+
       'Diese wird mit {$I <Datei>} eingebunden.'+Newline+
       Newline+
       'Das Compile-Datum steht als String in der Konstanten: ADate'+Newline+
       Newline+
       'Aufruf: '+paramstr(0)+' <Datei>'+Newline;
end;

end.
