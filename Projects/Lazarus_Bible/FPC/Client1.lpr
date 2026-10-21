program Client1;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_CLIENT;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Client1';
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
