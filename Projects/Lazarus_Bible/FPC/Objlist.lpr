program Objlist;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_ObjListMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmObjListMain, frmObjListMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmObjListMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmObjListMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
