program Win2kApp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_W2kMain in '..\Source\Frm_W2kMain.pas' {Win2kAppForm},
  Frm_W2kAbout in '..\source\Frm_W2kAbout.pas' {AboutBox};

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TWin2kAppForm, Win2kAppForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
 
