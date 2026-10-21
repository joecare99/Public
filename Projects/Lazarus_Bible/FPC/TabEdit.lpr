program TabEdit;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_AboutTabedit,
  Frm_TabeditMain;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Tabedit';
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.CreateForm(TfrmAboutForm, frmAboutForm);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmMainForm.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmMainForm, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
