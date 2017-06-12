program progressbar;


uses Interfaces,forms, frm_ProgressbarTestMain;

begin
   Application.Initialize; { calls InitProcedure which starts up GTK }
   Application.CreateForm(TFrmProgressbarTest,FrmProgressbarTest);
   Application.Run;
end.

