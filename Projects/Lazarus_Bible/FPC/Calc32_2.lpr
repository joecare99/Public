program Calc32_2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_CALC2,
  Frm_Calc2ABOUT;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Taschenrechner';
  Application.CreateForm(TfrmCalcMain2, frmCalcMain2);
  Application.CreateForm(TfrmCalcAbout2, frmCalcAbout2);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmCalcMain2.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmCalcMain2, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
