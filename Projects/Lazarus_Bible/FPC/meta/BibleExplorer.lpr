program BibleExplorer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils,
  Interfaces,
  Forms,
  BibleExplorerMain, FormShot;

{$R BibleExplorerData.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.Title := 'Delphi-Bible Explorer';
  try
    Application.CreateForm(TBibleExplorerForm, BibleExplorerForm);
  except
    on E: Exception do
    begin
      WriteLn('FEHLER: ', E.Message);
      Application.Terminate;
    end;
  end;
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    { Im Screenshot-Modus keine modalen Fehlermeldungen - der Fehler
      soll auf der Konsole erscheinen. }
    Application.CaptureExceptions := False;
    if ParamCount > 2 then
      BibleExplorerForm.ShowPage(ParamStr(3));
    BibleExplorerForm.Show;
    Application.ProcessMessages;
    SaveFormToImage(BibleExplorerForm, ChangeFileExt(ParamStr(2), '.bmp'));
    if BibleExplorerForm.BehaviorForm <> nil then
      SaveFormToImage(BibleExplorerForm.BehaviorForm,
        ChangeFileExt(ParamStr(2), '.demo.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
