program OleWord2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_OLEWord2Main in '..\Source\OleWord2\Frm_OLEWord2Main.pas' {MainForm}; 
{$R *.res}
begin 
  Application.Initialize; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
