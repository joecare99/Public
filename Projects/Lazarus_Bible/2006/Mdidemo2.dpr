program Mdidemo2;

uses
  Forms,
  Frm_MDIDemo2MAIN in 'Frm_MDIDemo2MAIN.PAS' {MainForm},
  CHILD2 in 'CHILD2.PAS' {ChildForm},
  frm_MDIDemo2ABOUT in 'frm_MDIDemo2ABOUT.PAS' {AboutForm},
  Childbmp in 'Childbmp.pas' {ChildBmpForm};

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'MDI Demonstration 2';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
