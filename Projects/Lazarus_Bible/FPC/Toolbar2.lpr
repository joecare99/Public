program Toolbar2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_Toolbar2MAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Toolbar2';
  Application.CreateForm(TfrmToolbar2Main, frmToolbar2Main);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmToolbar2Main.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmToolbar2Main, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
