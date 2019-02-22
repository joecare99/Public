program Client2;

uses
  Forms,
  Frm_CLIENT2 in '..\Frm_CLIENT2.PAS' {ClientForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Client2';
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
