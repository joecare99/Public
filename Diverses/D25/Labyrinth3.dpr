program Labyrinth3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFDEF UNIX}
  {$IFDEF UseCThreads}
  cthreads,
  {$ENDIF }
  {$ENDIF }
  {$IFnDEF FPC}
  {$ELSE}
  Interfaces,
  {$ENDIF }
  Forms,
  ProgressBarU in '..\source\ProgressBarU.pas' {ProgessForm},
  unt_Lists in '..\source\unt_Lists.pas',
  unt_Point2d in '..\source\Labyrinth\unt_Point2d.pas',
  Fra_WindRose in '..\Source\Fra_WindRose.pas' {FraWindRose: TFrame},
  LabyU3 in '..\Source\Labyrinth\LabyU3.pas',
  Labydemo3 in '..\Source\Labyrinth\Labydemo3.pas';

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TLaby, Laby);
  Application.CreateForm(TProgessForm, ProgessForm);
  Application.Run;
end.
