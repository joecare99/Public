program Server2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_SERVER2;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Server2';
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
