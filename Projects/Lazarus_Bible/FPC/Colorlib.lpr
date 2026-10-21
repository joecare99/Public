program Colorlib;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_CLRFORM;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Run;
end.
