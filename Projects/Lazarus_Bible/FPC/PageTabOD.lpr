program PageTabOD;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_PagetabODMain;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'PageTab-OwnerDraw Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
