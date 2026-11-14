program Client1;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_CLIENT;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Client1';
  Application.CreateForm(TClientForm, ClientForm);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    ClientForm.Show;
    Application.ProcessMessages;
    SaveFormToImage(ClientForm, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
