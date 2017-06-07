program Prj_TstVarProcs;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}



uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_TstVarProcs in '..\source\Frm_TstVarProcs.pas' {Form1};

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
