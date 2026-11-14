program OdfCreate;

{$mode delphi}{$H+}

uses
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_OdfCreateMain in '../source/ODFCREATE/Frm_OdfCreateMain.pas',
  odf_types in '/mnt/c/Projekte/Lazarus/fpOdf/odf_types.pas';

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: ODF-Dokument erzeugen';
  Application.CreateForm(TfrmOdfCreateMain, frmOdfCreateMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmOdfCreateMain.Show;
    Application.ProcessMessages;
    { Screenshot zeigt gleich das Ergebnis: Dokument einmal erzeugen. }
    frmOdfCreateMain.btnCreateClick(nil);
    Application.ProcessMessages;
    SaveFormToImage(frmOdfCreateMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
