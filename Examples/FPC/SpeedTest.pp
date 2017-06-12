program SpeedTest;

uses Interfaces,Forms, Frm_SpeedTestMain,LazLogger;

begin
   debugln('------ INIT ------- ');
   Application.Initialize; { calls InitProcedure which starts up GTK }
   debugln('------ CREATE ------- ');
   Application.CreateForm(TFrmSpeedTestMain, FrmSpeedTestMain);
   debugln('------ RUN ------- ');
   Application.Run;
   DebugLn('------ DONE ------- ');
end.

