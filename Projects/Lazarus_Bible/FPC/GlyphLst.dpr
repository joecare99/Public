program Glyphlst;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_GlyphListMain in '..\Source\GLYPHLST\Frm_GlyphListMain.pas' {MainForm};
{$IFNDEF FPC} {$E EXE}   {$ENDIF}

begin
  Application.Initialize; 
  Application.Title := 'Demo: Glyphlst'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
