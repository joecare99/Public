program Sqlplay;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  Open in 'OPEN.PAS' {OpenForm};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOpenForm, OpenForm);
  Application.Run;
end.
