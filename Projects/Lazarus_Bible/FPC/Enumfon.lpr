program Enumfon;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_EnumFonMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Enumfon';
  Application.CreateForm(TfrmEnumFontsMain, frmEnumFontsMain);
  Application.Run;
end.
