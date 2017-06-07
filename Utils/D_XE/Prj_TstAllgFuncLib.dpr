program Prj_TstAllgFuncLib;

uses
  Forms,
  frm_TstAllgFuncLib in '..\source\frm_TstAllgFuncLib.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
