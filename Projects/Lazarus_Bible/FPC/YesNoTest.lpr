program YesNoTest;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_YesNo,
  Frm_YesNoMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmYesNoMain, frmYesNoMain);
  Application.CreateForm(TfrmYesNoDlg, frmYesNoDlg);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmYesNoMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmYesNoMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
