program PrjDetectVMware;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Unt_DetectVMWare in '..\source\Unt_DetectVMWare.pas';

begin
  try
    { TODO -oUser -cConsole Main : Code hier einfügen }
    Execute;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
