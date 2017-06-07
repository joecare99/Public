program Prj_TstFileUnt;

uses
  Forms,
  Frm_TstFileUnt in '..\source\Frm_TstFileUnt.pas' {Form1},
  begin;

uses
  Forms,
  Tst_FileUnt in '..\source\Tst_FileUnt.pas' {Form1},

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Testapplication für Unt_FileProcs';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
