program WinCub;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ELSE}
{$E EXE}
{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$IFDEF FPC}
  Interfaces, // this includes the LCL widgetset
  DefaultTranslator,
  {$ENDIF}
  Forms,
  frm_WinCub in '..\Source\WinCub\frm_WinCub.pas', 
  Cls_ColCub  in '..\Source\WinCub\Cls_ColCub.pas';

{$R *.res}

begin
 {$IFDEF FPC}
  RequireDerivedFormResource:=True;
  {$ENDIF}
  Application.Initialize;
  Application.Title := 'WinCub: Color moving Game';
  Application.CreateForm(TfrmWinCub, frmWinCub);
  Application.Run;
end.

