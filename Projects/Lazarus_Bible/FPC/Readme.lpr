program Readme;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_ReadMeMain,
  ReadMeDocument,
  ReadMeViewModel;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Readme - Demo';
  Application.CreateForm(TMainForm, MainForm);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    MainForm.Show;
    Application.ProcessMessages;
    SaveFormToImage(MainForm, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
