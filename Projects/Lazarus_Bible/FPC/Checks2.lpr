program Checks2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_Checks2Main;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Checks2';
  Application.CreateForm(TfrmChecks2Main, frmChecks2Main);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmChecks2Main.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmChecks2Main, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
