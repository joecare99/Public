program WriteCDate;

{$APPTYPE CONSOLE}

uses
  Unt_WriteCDate in '..\source\Unt_WriteCDate.pas';

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
