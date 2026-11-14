program Listtext;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_ListTextMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'List Text Files';
  Application.CreateForm(TfrmListTextMain, frmListTextMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmListTextMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmListTextMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
