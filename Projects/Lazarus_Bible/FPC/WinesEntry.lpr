program WinesEntry;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_WinesEntryMain;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: WinesEntry';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
