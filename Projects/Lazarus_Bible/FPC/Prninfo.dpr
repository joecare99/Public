program Prninfo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_PrnInfoMAIN in '..\Source\PRNINFO\Frm_PrnInfoMAIN.PAS' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'PrnInfo - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
