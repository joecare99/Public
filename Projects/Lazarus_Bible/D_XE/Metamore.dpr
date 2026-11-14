program Metamore;

uses
  Forms,
  Frm_MetaMoreMAIN in '..\source\METAMORE\Frm_MetaMoreMAIN.pas' {MainForm};

{$E exe}

{$R *.RES}

begin
  Application.Title := 'MetaMore';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
