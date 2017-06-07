program OpenC2Pas_mini;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_c2pasMiniMain {Form1},
  cls_Translator in '..\Source\C2Pas\cls_Translator.pas';

{.$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmC2PasMiniMain, frmC2PasMiniMain);
  Application.Run;
end.
