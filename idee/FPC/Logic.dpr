program Logic;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_LogicMain in 'Frm_LogicMain.pas' {Form2},
  frm_logicConf in 'frm_logicConf.pas' {FrmLogicConf};

{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Logic Rätsel - Lösehilfe';
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TFrmLogicConf, FrmLogicConf);
  Application.Run;
end.
