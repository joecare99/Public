program Prj_GetComImp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_ShowGedCom in '..\Source\Frm_ShowGedCom.pas' {Form1},
  Cmp_gedObject in '..\Source\Cmp_gedObject.pas';

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
