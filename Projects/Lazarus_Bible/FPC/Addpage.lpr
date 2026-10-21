program Addpage;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_AddpageMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Add Page';
  Application.CreateForm(TfrmAddPageMain, frmAddPageMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmAddPageMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmAddPageMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
