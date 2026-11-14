program Bitview;

uses
  Forms,
  Frm_BitViewMAIN in '..\Bitview\Frm_BitViewMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Bitview';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

