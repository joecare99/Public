program PicDialogs;

uses
  Forms,
  Main in '..\PicDialogs\Frm_PicDialogsMain.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PicDialogs - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
