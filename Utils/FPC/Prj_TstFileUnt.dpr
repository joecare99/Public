program Prj_TstFileUnt;

{$ifdef FPC}
{$mode delphi}
{$endif}

uses
  Forms,
  {$ifdef FPC}
  Interfaces,
  {$endif}
  Frm_TstFileUnt in '..\source\Frm_TstFileUnt.pas'; {Form1}

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Testapplication für Unt_FileProcs';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
