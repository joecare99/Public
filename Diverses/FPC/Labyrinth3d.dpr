program Labyrinth3d;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Labydemo3d in '..\source\Labyrinth\Labydemo3d.pas' {Form1},
  ProgressBarU in '..\source\ProgressBarU.pas' {ProgessForm},
  LabyU3D in '..\source\Labyrinth\LabyU3D.pas' {Laby},
  unt_Lists in '..\source\unt_Lists.pas',
  unt_Point3d in '..\source\Labyrinth\unt_Point3d.pas',
  Fra_WindRose in '..\Source\Fra_WindRose.pas' {FraWindRose: TFrame};

begin
  Application.Initialize;
  Application.CreateForm(TfrmLabyDemo3d, frmLabyDemo3d);
  Application.CreateForm(TProgessForm, ProgessForm);
  Application.CreateForm(TLaby, Laby);
  Application.Run;
end.
