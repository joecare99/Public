program Prj_GedcomImp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_ShowGedCom in '..\source\gedcom-import\Frm_ShowGedCom.pas' {Form1},
  Cmp_GedComFile;

{$R *.res}

begin
  Application.Initialize;
  Application.{%H-}MainFormOnTaskbar := True;
  Application.CreateForm(TFrmShowGedCom, FrmShowGedCom);
  Application.Run;
end.
