program Calc64;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_CALC64,
  Frm_CalcABOUT;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Calc64';
  Application.CreateForm(TfrmCalc64Main, frmCalc64Main);
  Application.CreateForm(TfrmCalcAbout, frmCalcAbout);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmCalc64Main.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmCalc64Main, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
