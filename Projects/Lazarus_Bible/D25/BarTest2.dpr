program BarTest2;

uses
  Forms,
  Frm_BartestMain2 in '..\source\Barchart\Frm_BartestMain2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Demo: BarChart-Componente';
  Application.CreateForm(TfrmBarTestMain2, frmBarTestMain2);
  Application.Run;
end.
