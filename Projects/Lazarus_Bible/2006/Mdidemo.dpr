program Mdidemo;

uses
  Forms,
  Frm_MDIDemoMAIN in 'Frm_MDIDemoMAIN.PAS' {MainForm},
  CHILD1 in 'CHILD1.PAS' {ChildForm},
  Frm_MDIDemoABOUT in 'Frm_MDIDemoABOUT.PAS' {AboutForm};

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'MDI Demonstration';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
