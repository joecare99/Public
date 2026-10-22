program Strlist;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_StrlistMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Strlist - Demo';
  Application.CreateForm(TfrmStrlistMain, frmStrlistMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmStrlistMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmStrlistMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
