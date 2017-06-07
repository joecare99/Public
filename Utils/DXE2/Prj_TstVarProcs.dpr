program Prj_TstVarProcs;



uses
  Forms,
  Frm_TstVarProcs in '..\source\Frm_TstVarProcs.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
