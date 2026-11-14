program Mdidemo2;

uses
  Forms,
  Frm_MDIDemo2MAIN in '..\source\Mdidemo2\Frm_MDIDemo2MAIN.pas' {MainForm},
  CHILD2 in '..\source\Mdidemo2\CHILD2.pas' {ChildForm},
  frm_MDIDemo2ABOUT in '..\source\Mdidemo2\frm_MDIDemo2ABOUT.pas' {AboutForm},
  Childbmp in '..\source\Mdidemo2\Childbmp.pas' {ChildBmpForm};

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'MDI Demonstration 2';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
