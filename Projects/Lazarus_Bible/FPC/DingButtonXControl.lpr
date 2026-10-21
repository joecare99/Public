program DingButtonXControl;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  DingButtonImpl1;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Run;
end.
