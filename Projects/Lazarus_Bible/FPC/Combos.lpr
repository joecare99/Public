program Combos;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_CombosMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Combos';
  Application.CreateForm(TfrmCombosMain, frmCombosMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmCombosMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmCombosMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
