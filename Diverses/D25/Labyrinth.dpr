program Labyrinth;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFnDEF FPC}
  {$ELSE}
  Interfaces,
  {$ENDIF }
  Forms,
  ProgressBarU in '..\source\ProgressBarU.pas' {ProgessForm},
  unt_Lists in '..\source\unt_Lists.pas',
  Labydemo in '..\Source\Labyrinth\Labydemo.pas',
  LabyU2 in '..\Source\Labyrinth\LabyU2.pas',
  unt_Point2d in '..\Source\Labyrinth\unt_Point2d.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TProgessForm, ProgessForm);
  Application.Run;
end.
