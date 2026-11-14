program StaticDemo;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_StaticDemoMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'StaticDemo - Demo';
  Application.CreateForm(TStaticDemoForm, StaticDemoForm);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    StaticDemoForm.Show;
    Application.ProcessMessages;
    SaveFormToImage(StaticDemoForm, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
