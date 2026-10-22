program Sketch;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_SketchMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Sketch - Demo';
  Application.CreateForm(TfrmSketchMain, frmSketchMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmSketchMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmSketchMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
