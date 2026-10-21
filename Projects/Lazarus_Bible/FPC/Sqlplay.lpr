program Sqlplay;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_SQLOPENDB,
  Frm_SqlplayMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Sqlplay - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOpenForm, OpenForm);
  Application.Run;
end.
