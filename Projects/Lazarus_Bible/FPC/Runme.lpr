program Runme;

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
  Frm_RunMeTEST;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Runme - Demo';
  Application.CreateForm(TTestForm, TestForm);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    TestForm.Show;
    Application.ProcessMessages;
    SaveFormToImage(TestForm, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
