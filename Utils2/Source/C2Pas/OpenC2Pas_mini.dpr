program OpenC2Pas_mini;

uses
  Forms,
  main_mini in 'main_mini.pas' {Form1},
  translator in 'translator.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
