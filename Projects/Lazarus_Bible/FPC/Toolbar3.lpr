program Toolbar3;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_Toolbar3MAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Toolbar3';
  Application.CreateForm(TfrmToolbar3Main, frmToolbar3Main);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmToolbar3Main.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmToolbar3Main, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
