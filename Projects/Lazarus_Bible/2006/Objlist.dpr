program Objlist;

uses
  Forms,
  Frm_ObjListMAIN in 'Frm_ObjListMAIN.PAS' {MainForm};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
