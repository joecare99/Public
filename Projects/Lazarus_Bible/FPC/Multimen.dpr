program Multimen;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_MultiWayMAIN in '..\Source\MULTIMEN\Frm_MultiWayMAIN.PAS' {MainForm}; 
{$E exe} 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'Multi-Way - Menus'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
