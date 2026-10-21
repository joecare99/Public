program Bitview2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_BitView2MAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Bitview2';
  Application.CreateForm(TfrmBitmapViewer2Main, frmBitmapViewer2Main);
  Application.Run;
end.
