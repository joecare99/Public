program PrjLaby4b;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_laby4b in '..\source\Labyrinth\frm_laby4b.pas' {Form2};

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmLaby4, FrmLaby4);
  Application.Run;
end.
