program OpenC2Pas;

uses
  {$IFDEF FPC} Interfaces, {$ENDIF} Forms,
  frm_C2PasMain {Form1},
  translator in '..\Source\C2Pas\translator.pas',
  frm_SynColors {Form_SynColors};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmC2PasMain, frmC2PasMain);
  Application.CreateForm(TForm_SynColors, Form_SynColors);
  Application.Run;
end.
