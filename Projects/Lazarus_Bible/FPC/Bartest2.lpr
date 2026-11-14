program Bartest2;

{$mode delphi}{$H+}

uses
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_BartestMain2;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Bartest2';
  Application.CreateForm(TfrmBarTestMain2, frmBarTestMain2);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmBarTestMain2.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmBarTestMain2, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
