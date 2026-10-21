program YesNoTest;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_YesNo;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmYesNoMain, frmYesNoMain);
  Application.CreateForm(TfrmYesNoDlg, frmYesNoDlg);
  Application.Run;
end.
