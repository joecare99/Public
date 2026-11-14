program Daynames;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  ArrayP;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Run;
end.
