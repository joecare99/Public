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
  Labydemo3d in '..\source\Labydemo3d.pas' {Form1},
  ProgressBarU in '..\source\ProgressBarU.pas' {ProgessForm},
  LabyU3D in '..\source\LabyU3D.pas' {Laby},
  unt_Lists in '..\source\unt_Lists.pas',
  unt_Point3d in '..\source\unt_Point3d.pas',
  Fra_WindRose in '..\Source\Fra_WindRose.pas' {FraWindRose: TFrame};

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TProgessForm, ProgessForm);
  Application.CreateForm(TLaby, Laby);
  Application.Run;
end.
