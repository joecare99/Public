program OleWord1;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_OLEWord1Main in '..\Source\OleWord1\Frm_OLEWord1Main.pas' {MainForm}; 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'OLE Object Demonstration for Word 95 and Earlier'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
