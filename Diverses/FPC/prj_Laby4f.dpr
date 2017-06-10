program prj_Laby4f;

uses
  FMX.Forms,
  Frx_Laby4MainForm in '..\source\Frx_Laby4MainForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
