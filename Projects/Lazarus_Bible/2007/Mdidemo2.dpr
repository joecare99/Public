program Mdidemo2;

uses
  Forms,
  Frm_MDIDemo2MAIN in '..\Mdidemo2\Frm_MDIDemo2MAIN.pas' {MainForm},
  CHILD2 in '..\Mdidemo2\CHILD2.pas' {ChildForm},
  frm_MDIDemo2ABOUT in '..\Mdidemo2\frm_MDIDemo2ABOUT.pas' {AboutForm},
  Childbmp in '..\Mdidemo2\Childbmp.pas' {ChildBmpForm};

{$E EXE}

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'MDI Demonstration 2';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
