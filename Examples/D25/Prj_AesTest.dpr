program Prj_AesTest;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

uses
  {$IFDEF UNIX}
  {$IFDEF UseCThreads}
  cthreads,
  {$ENDIF }
  {$ENDIF }
 {$IFDEF FPC} Interfaces,{$ENDIF}
  Forms {you can add units after this},
  frm_AesTestMain in '..\Source\AES_Encrypt\frm_AesTestMain.pas' {frmAES};

{$R *.res}

begin
 {$IFDEF FPC} RequireDerivedFormResource:=True;{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TfrmAES, frmAES);
  Application.Run;
end.

