program Multimen;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_MultiWayMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Multi-Way - Menus';
  Application.CreateForm(TfrmMultiWayMain, frmMultiWayMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmMultiWayMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmMultiWayMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
