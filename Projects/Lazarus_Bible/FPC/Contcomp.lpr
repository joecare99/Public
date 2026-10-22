program Contcomp;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  frm_ContCompMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Contcomp';
  Application.CreateForm(TfrmContCompMain, frmContCompMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmContCompMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmContCompMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
