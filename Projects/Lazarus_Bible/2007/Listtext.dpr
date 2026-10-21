program Listtext;

uses
  Forms,
  Frm_ListTextMAIN in '..\LISTTEXT\Frm_ListTextMAIN.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
Application.Initialize;
  Application.Title := 'List Text Files';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

