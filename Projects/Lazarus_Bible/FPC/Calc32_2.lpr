program Calc32_2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_CALC2,
  Frm_Calc2ABOUT;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Taschenrechner';
  Application.CreateForm(TfrmCalcMain2, frmCalcMain2);
  Application.CreateForm(TfrmCalcAbout2, frmCalcAbout2);
  Application.Run;
end.
