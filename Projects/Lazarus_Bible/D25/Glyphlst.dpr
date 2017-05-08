program Glyphlst; 
uses 
  Forms, 
  Frm_GlyphListMain in '..\Source\GLYPHLST\Frm_GlyphListMain.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize; 
  Application.Title := 'Demo: Glyphlst'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
