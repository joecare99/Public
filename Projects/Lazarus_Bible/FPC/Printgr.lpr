program Printgr;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_PrintgrMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Printgr - Demo';
  Application.CreateForm(TfrmPrintgrMain, frmPrintgrMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmPrintgrMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmPrintgrMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
