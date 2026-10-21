program Server2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_SERVER2;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Server2';
  Application.CreateForm(TServerForm, ServerForm);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    ServerForm.Show;
    Application.ProcessMessages;
    SaveFormToImage(ServerForm, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
