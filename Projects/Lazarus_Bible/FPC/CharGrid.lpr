program CharGrid;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_CharGridABOUT;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Chargrid';
  Application.CreateForm(TfrmCharGridMain, frmCharGridMain);
  Application.CreateForm(TfrmAboutForm, frmAboutForm);
  Application.Run;
end.
