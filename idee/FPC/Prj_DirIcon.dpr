program Prj_DirIcon;

uses
  Forms,
  Frm_DirIconMain in 'Frm_DirIconMain.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
