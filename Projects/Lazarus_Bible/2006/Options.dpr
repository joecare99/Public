program Options;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  Inidata in '..\Inidata\Inidata.pas';

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
