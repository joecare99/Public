program OleWord1;

uses
  Forms,
  Frm_OLEWord1Main in '..\OleWord1\Frm_OLEWord1Main.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: OleWord1';
  Application.Title := 'OLE Object Demonstration for Word 95 and Earlier';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
