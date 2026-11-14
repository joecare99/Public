program PrnInfo;

uses
  Forms,
  Frm_PrnInfoMAIN in '..\PRNINFO\Frm_PrnInfoMAIN.pas' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PrnInfo - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
