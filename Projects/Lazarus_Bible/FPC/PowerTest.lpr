program PowerTest;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  unt_PowerTest;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Run;
end.
