program Hello;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_HelloMAIN,
  HelloViewModel;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Hello';
  Application.CreateForm(TForm1, Form1);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    Form1.Show;
    Application.ProcessMessages;
    SaveFormToImage(Form1, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
