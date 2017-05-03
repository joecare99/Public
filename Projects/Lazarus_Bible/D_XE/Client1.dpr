program Client1;

uses
  Forms,
  Frm_CLIENT in '..\source\DDE1\Frm_CLIENT.PAS' {ClientForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Client1';
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
