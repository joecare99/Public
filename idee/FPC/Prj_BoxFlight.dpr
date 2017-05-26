program Prj_BoxFlight;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  uScaleDPI,
  unt_cdate in 'c:\unt_Cdate.pas',
  Frm_BoxFlight in '..\source\Frm_BoxFlight.pas' {Form6};


{.$R *.res}

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm6, Form6);
  HighDPI(-1);
  Application.Run;
end.
