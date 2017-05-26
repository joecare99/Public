program Prj_Clock;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_clock_2 in '..\Source\frm_clock_2.pas' {FrmClock};

{.$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Uhr';
  Application.CreateForm(TFrmClock, FrmClock);
  Application.Run;
end.
