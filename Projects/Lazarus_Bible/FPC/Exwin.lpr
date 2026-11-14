program Exwin;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Run;
end.
