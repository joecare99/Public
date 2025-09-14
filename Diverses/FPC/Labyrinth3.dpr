program Labyrinth3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Labydemo3 in '..\source\Labyrinth\Labydemo3.pas' {Form1},
  ProgressBarU in '..\source\ProgressBarU.pas' {ProgessForm},
  LabyU3 in '..\source\Labyrinth\LabyU3.pas' {Laby},
  unt_Lists in '..\source\unt_Lists.pas',
  unt_Point2d in '..\source\Labyrinth\unt_Point2d.pas',
  Fra_WindRose in '..\Source\Fra_WindRose.pas' {FraWindRose: TFrame};

begin
  Application.Initialize;
  Application.CreateForm(TfrmLabyDemo3, frmLabyDemo3);
  Application.CreateForm(TProgessForm, ProgessForm);
  Application.CreateForm(TLaby, Laby);
  Application.Run;
end.
