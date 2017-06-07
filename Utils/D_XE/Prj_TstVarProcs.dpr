program Prj_TstVarProcs;

{%File 'ModelSupport\Unt_TstVarProcs\Unt_TstVarProcs.txvpck'}
{%File 'ModelSupport\Vorgabe.txvpck'}

uses
  Forms,
  Unt_TstVarProcs in '..\source\Unt_TstVarProcs.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
