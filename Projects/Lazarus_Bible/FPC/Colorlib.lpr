program Colorlib;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  Frm_CLRFORM;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Run;
end.
