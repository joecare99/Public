program Prj_ChartTest;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_SDIMAIN in '..\source\ChartTest\Frm_SDIMAIN.PAS' {SDIAppForm},
  frm_About in '..\source\ChartTest\frm_About.PAS' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
 
