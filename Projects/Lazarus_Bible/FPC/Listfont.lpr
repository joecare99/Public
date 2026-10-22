program Listfont;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_ListFontMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Font-Lister';
  Application.CreateForm(TfrmListfontMain, frmListfontMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmListfontMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmListfontMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
