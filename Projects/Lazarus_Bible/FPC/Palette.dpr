program Palette;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_PaletteMain in '..\Source\PALETTE\Frm_PaletteMain.PAS' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'Palette - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
