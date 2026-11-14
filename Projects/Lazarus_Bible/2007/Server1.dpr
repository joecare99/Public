program Server1;

uses
  Forms,
  Frm_SERVER in '..\DDE1\Frm_SERVER.pas' {ServerForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Server1';
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
