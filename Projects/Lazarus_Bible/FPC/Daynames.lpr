program Daynames;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  ArrayP;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Run;
end.
