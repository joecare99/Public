program Sqlplay;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_SQLOPENDB,
  Frm_SqlplayMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Sqlplay - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOpenForm, OpenForm);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    MainForm.Show;
    Application.ProcessMessages;
    SaveFormToImage(MainForm, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
