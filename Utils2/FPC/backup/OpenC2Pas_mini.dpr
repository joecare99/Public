program OpenC2Pas_mini;

uses
  Forms,
  main_mini in '..\Source\C2Pas\main_mini.pas' {Form1},
  translator in '..\Source\C2Pas\translator.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
