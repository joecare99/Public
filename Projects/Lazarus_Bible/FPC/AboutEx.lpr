program AboutEx;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  DefaultTranslator,
  AboutEx_Frm_ABOUT,
  Frm_AboutExMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: AboutEx';
  Application.CreateForm(TfrmAboutMain, frmAboutMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmAboutMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmAboutMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
