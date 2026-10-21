program AboutEx;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  DefaultTranslator,
  Frm_ABOUT,
  Frm_AboutExMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: AboutEx';
  Application.CreateForm(TfrmAboutMain, frmAboutMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
