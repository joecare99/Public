program Prj_TestSprites;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_TestSprites in '..\grafik\Frm_TestSprites.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTestSpritesForm, TestSpritesForm);
  Application.Run;
end.
