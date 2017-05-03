program Mdidemo2;

uses
  Forms,
  Frm_MDIDemo2MAIN in '..\source\Mdidemo2\Frm_MDIDemo2MAIN.PAS' {MainForm},
  CHILD2 in '..\source\Mdidemo2\CHILD2.PAS' {ChildForm},
  frm_MDIDemo2ABOUT in '..\source\Mdidemo2\frm_MDIDemo2ABOUT.PAS' {AboutForm},
  Childbmp in '..\source\Mdidemo2\Childbmp.pas' {ChildBmpForm};

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'MDI Demonstration 2';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
