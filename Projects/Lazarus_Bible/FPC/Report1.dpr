program Report1;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_Report1Main in '..\Source\Report1\Frm_Report1Main.pas' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'PrnInfo - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
