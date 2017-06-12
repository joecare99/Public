
program NotebookTest;

uses Interfaces, Classes, Controls, Forms,frm_NotebookTestMain,LCLProc;

begin
   DebugLN('------ INIT ------- ');
  Application.Initialize;
  DebugLN('------ CREATE ------- ');
  Application.CreateForm(TFrmNoteBookTestMain, FrmNoteBookTestMain);
  DebugLN('------ RUN ------- ');
  Application.Run;
  DebugLN('------ DONE ------- ');
end.
