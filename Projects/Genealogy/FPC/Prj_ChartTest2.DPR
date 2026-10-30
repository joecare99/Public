program Prj_ChartTest2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_Chart2Main in '..\source\ChartTest\Frm_Chart2Main.PAS' {SDIAppForm},
  frm_About in '..\source\ChartTest\frm_About.PAS' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
 
