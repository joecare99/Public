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
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
