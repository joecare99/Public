program CustomDraw;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  DefaultTranslator,
  Forms,
  CustomDrawTreeView in '..\Source\D7Demod\CustomDraw\CustomDrawTreeView.pas' {CustomDrawForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCustomDrawForm, CustomDrawForm);
  Application.Run;
end.
