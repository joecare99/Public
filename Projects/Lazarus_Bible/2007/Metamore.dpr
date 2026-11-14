program Metamore;

uses
  Forms,
  Frm_MetaMoreMAIN in '..\METAMORE\Frm_MetaMoreMAIN.pas' {MainForm};

{$E exe}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Demo: Metamore';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
