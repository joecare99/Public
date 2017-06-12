program ScrollBar;


uses Interfaces,Forms, Frm_ScrollBarTestMain;

begin
  Application.Initialize; { calls InitProcedure which starts up GTK }
  Application.CreateForm(TFrmScrollBarTest, FrmScrollBarTest);
  Application.Run;
end.

