program gridcelleditor;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { add your units here }, Frm_GridCellEditor;

begin
  Application.Initialize;
  Application.CreateForm(TFrmGridCellEditor, FrmGridCellEditor);
  Application.Run;
end.

