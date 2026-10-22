program Palette;

uses
  Forms,
  Frm_PaletteMain in '..\source\PALETTE\Frm_PaletteMain.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Palette - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
