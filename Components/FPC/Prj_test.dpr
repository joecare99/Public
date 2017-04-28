program Prj_test;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  unt_cdate in 'c:\unt_cdate.pas',
  Frm_test in '..\test\Frm_test.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
{$IFNDEF FPC}
  Application.MainFormOnTaskbar := True;
{$ENDIF}
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
