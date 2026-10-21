program PicDialogs;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_PicDialogsMain;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'PicDialogs - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
