program Objlist;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_ObjListMAIN in '..\Source\OBJLIST\Frm_ObjListMAIN.PAS' {MainForm}; 
{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
