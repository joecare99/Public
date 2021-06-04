program PrjLaby4;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_laby4 in '..\source\labyrinth\frm_laby4.pas' {Form2};

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmLaby4, FrmLaby4);
  Application.Run;
end.
