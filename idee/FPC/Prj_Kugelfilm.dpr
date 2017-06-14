program Prj_Kugelfilm;

uses
  Forms,
  graph in 'graph.pas' {GForm},
  unt_KugelFilm in 'unt_KugelFilm.PAS',
  FARBGR in 'FARBGR.PAS',
  Frm_MainKugelF in 'Frm_MainKugelF.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TGForm, GForm);
  Application.Run;
end.
