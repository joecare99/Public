program TabEdit;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_AboutTabedit;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Tabedit';
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.CreateForm(TfrmAboutForm, frmAboutForm);
  Application.Run;
end.
