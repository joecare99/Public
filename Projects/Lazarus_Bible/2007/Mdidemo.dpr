program Mdidemo;

uses
  Forms,
  Frm_MDIDemoMAIN in '..\MDIDEMO\Frm_MDIDemoMAIN.pas' {MainForm},
  CHILD1 in '..\CHILD1.PAS' {ChildForm},
  Frm_MDIDemoABOUT in '..\MDIDEMO\Frm_MDIDemoABOUT.pas' {AboutForm};

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'MDI Demonstration';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
