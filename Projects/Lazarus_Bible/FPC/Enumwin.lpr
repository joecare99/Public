program Enumwin;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_EnumWinMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Enumwin';
  Application.CreateForm(TfrmEnumWinMain, frmEnumWinMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmEnumWinMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmEnumWinMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
