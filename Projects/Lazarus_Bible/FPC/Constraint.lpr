program Constraint;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  frm_ConstraintMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Constraint';
  Application.CreateForm(TfrmConstraintMain, frmConstraintMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmConstraintMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmConstraintMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
