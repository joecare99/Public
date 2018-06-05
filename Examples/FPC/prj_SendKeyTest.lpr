program prj_SendKeyTest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, frm_MouseAndKeyExMain, LazMouseAndKeyInput;

begin
  Application.Initialize;
  Application.CreateForm(TfrmMouseAndKeyExMain, frmMouseAndKeyExMain);
  Application.Run;
end.

