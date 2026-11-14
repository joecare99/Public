program Objlist;

uses
  Forms,
  Frm_ObjListMAIN in '..\OBJLIST\Frm_ObjListMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Objlist';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
