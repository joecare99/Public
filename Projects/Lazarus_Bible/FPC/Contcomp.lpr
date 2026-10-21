program Contcomp;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  frm_ContCompMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Contcomp';
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
