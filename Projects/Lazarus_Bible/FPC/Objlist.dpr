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
  Frm_ObjListMAIN in '..\source\OBJLIST\Frm_ObjListMAIN.pas' {MainForm}; 
{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
