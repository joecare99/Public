program Multimen;

uses
  Forms,
  Frm_MultiWayMAIN in '..\MULTIMEN\Frm_MultiWayMAIN.pas' {MainForm};

{$E exe}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Multi-Way - Menus';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

