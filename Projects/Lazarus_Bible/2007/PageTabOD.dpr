program PageTabOD;

uses
  Forms,
  Main in '..\PageTabOD\old\Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
