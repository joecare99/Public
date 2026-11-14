program Palette;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_PaletteMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Palette - Demo';
  Application.CreateForm(TfrmPaletteMain, frmPaletteMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmPaletteMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmPaletteMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
