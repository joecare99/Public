program GlyphLst;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_GlyphListMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Glyphlst';
  Application.CreateForm(TfrmGlyphListMain, frmGlyphListMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmGlyphListMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmGlyphListMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
