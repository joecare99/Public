program OpenC2Pas;

uses
  Forms,
  main in 'main.pas' {Form1},
  translator in 'translator.pas',
  colors in 'colors.pas' {Form_SynColors};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm_SynColors, Form_SynColors);
  Application.Run;
end.
