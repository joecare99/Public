program WinCub;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  DefaultTranslator,
  Forms,
  frm_WinCub, Cls_ColCub;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmWinCub, frmWinCub);
  Application.Run;
end.

