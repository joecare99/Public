program Listfont;

uses
  Forms,
  Frm_ListFontMAIN in '..\LISTFONT\Frm_ListFontMAIN.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
Application.Initialize;
  Application.Title := 'Font-Lister';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

