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

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Delphi-Bible Explorer';
  Application.CreateForm(TBibleExplorerForm, BibleExplorerForm);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    BibleExplorerForm.Show;
    Application.ProcessMessages;
    SaveFormToImage(BibleExplorerForm, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
