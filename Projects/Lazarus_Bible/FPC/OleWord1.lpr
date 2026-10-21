program OleWord1;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_OLEWord1Main;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'OLE Object Demonstration for Word 95 and Earlier';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
