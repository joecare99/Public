program Multimen;

uses
  Forms,
  Frm_MultiWayMAIN in '..\source\MULTIMEN\Frm_MultiWayMAIN.PAS' {MainForm};

{$E exe}

{$R *.RES}

begin
  Application.Title := 'Multi-Way - Menus';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

