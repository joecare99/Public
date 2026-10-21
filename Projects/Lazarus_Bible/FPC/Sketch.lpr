program Sketch;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_SketchMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Sketch - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
