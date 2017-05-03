program VideoPlayer; 
uses 
  Forms, 
  frm_VideoPlayerMain in '..\Source\VideoPlayer\frm_VideoPlayerMain.pas' {Form1}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: VideoPlayer'; 
  Application.CreateForm(TForm1, Form1); 
  Application.Run; 
end. 
