program Prj_GraphFrame;

uses
  Forms,
  frm_tstGraphFrame in 'frm_tstGraphFrame.pas' {Form7},
  graph in 'graph.pas' {GForm},
  Fra_Graph in 'Fra_Graph.pas' {FraGraph: TFrame},
  int_Graph in 'int_Graph.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TGForm, GForm);
  Application.Run;
end.
