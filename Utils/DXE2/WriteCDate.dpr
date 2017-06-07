program WriteCDate;

{$APPTYPE CONSOLE}

uses
  Unt_WriteCDDate in '..\source\Unt_WriteCDDate.pas';

begin
   if ParamCount = 1 then
     begin
       Run(Paramstr(1));
     end
   else
     begin
       writeln(ShowHelp);
     end;
end.
