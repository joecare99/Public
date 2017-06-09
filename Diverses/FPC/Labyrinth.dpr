program Labyrinth;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Labydemo in '..\source\Labydemo.pas' {Form1},
  ProgressBarU in '..\source\ProgressBarU.pas' {ProgessForm},
  unt_Lists in '..\source\unt_Lists.pas',
  unt_Point2d in '..\source\unt_Point2d.pas',
  LabyU2 in '..\source\LabyU2.pas' {Laby};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TProgessForm, ProgessForm);
  Application.CreateForm(TLaby, Laby);
  Application.Run;
end.
