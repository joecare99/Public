program Calc32;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Calc32ViewModel,
  CalculatorModel,
  Frm_CALC,
  Frm_CalcABOUT;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Calc32';
  Application.CreateForm(TfrmCalcMain, frmCalcMain);
  Application.CreateForm(TfrmCalcAbout, frmCalcAbout);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmCalcMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmCalcMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
