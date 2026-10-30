program Animator;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  cmpAnimator,
  Frm_AnimatorMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Animator';
  Application.CreateForm(TfrmAnimatorMain, frmAnimatorMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmAnimatorMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmAnimatorMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
