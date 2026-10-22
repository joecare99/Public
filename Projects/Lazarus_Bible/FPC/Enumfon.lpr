program Enumfon;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_EnumFonMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Enumfon';
  Application.CreateForm(TfrmEnumFontsMain, frmEnumFontsMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmEnumFontsMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmEnumFontsMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
