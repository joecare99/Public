program StartTest;

{-------------------------------------------------------------------------------
  StartTest - starts the application step by step and reports which form
  fails, so that a startup problem can be localised without a debugger.
-------------------------------------------------------------------------------}

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Forms, Controls,
  Unit1  in '..\Units\Unit1.pas',
  Unit2  in '..\Units\Unit2.pas',
  Unit3  in '..\Units\Unit3.pas',
  Unit4  in '..\Units\Unit4.pas',
  Unit5  in '..\Units\Unit5.pas',
  Unit6  in '..\Units\Unit6.pas',
  Unit7  in '..\Units\Unit7.pas',
  Unit8  in '..\Units\Unit8.pas',
  Unit9  in '..\Units\Unit9.pas',
  Unit10 in '..\Units\Unit10.pas',
  Unit11 in '..\Units\Unit11.pas',
  Unit12 in '..\Units\Unit12.pas',
  Unit13 in '..\Units\Unit13.pas',
  Unit14 in '..\Units\Unit14.pas',
  Unit15 in '..\Units\Unit15.pas',
  Unit16 in '..\Units\Unit16.pas',
  Unit17 in '..\Units\Unit17.pas',
  Unit18 in '..\Units\Unit18.pas',
  Unit19 in '..\Units\Unit19.pas',
  Unit20 in '..\Units\Unit20.pas',
  Unit21 in '..\Units\Unit21.pas',
  Unit22 in '..\Units\Unit22.pas',
  Unit23 in '..\Units\Unit23.pas',
  Unit24 in '..\Units\Unit24.pas',
  Unit25 in '..\Units\Unit25.pas',
  Unit26 in '..\Units\Unit26.pas',
  Unit27 in '..\Units\Unit27.pas',
  Unit28 in '..\Units\Unit28.pas',
  Unit29 in '..\Units\Unit29.pas',
  Unit30 in '..\Units\Unit30.pas',
  Unit31 in '..\Units\Unit31.pas',
  Unit32 in '..\Units\Unit32.pas',
  Unit33 in '..\Units\Unit33.pas',
  Unit34 in '..\Units\Unit34.pas',
  Unit35 in '..\Units\Unit35.pas',
  Unit36 in '..\Units\Unit36.pas',
  Unit37 in '..\Units\Unit37.pas',
  Unit38 in '..\Units\Unit38.pas',
  Unit39 in '..\Units\Unit39.pas',
  Unit40 in '..\Units\Unit40.pas';

var
  Step: string;

procedure Step1(const AName: string);
begin
  Step := AName;
  WriteLn('... ', AName);
  Flush(Output);
end;

begin
  Application.Initialize;
  Application.Title := 'AHNENWIN 5.1';

  try
    Step1('Form8 (Splash)');
    Form8 := TForm8.Create(nil);
    Form8.Show;
    Form8.Update;

    Step1('DataModule2');   Application.CreateForm(TDataModule2, DataModule2);
    Step1('Form1');         Application.CreateForm(TForm1, Form1);
    Step1('Form3');         Application.CreateForm(TForm3, Form3);
    Step1('Form4');         Application.CreateForm(TForm4, Form4);
    Step1('Form5');         Application.CreateForm(TForm5, Form5);
    Step1('Form9');         Application.CreateForm(TForm9, Form9);
    Step1('Form10');        Application.CreateForm(TForm10, Form10);
    Step1('Form11');        Application.CreateForm(TForm11, Form11);
    Step1('Form12');        Application.CreateForm(TForm12, Form12);
    Step1('Form13');        Application.CreateForm(TForm13, Form13);
    Step1('Form15');        Application.CreateForm(TForm15, Form15);
    Step1('Form16');        Application.CreateForm(TForm16, Form16);
    Step1('Form17');        Application.CreateForm(TForm17, Form17);
    Step1('Form20');        Application.CreateForm(TForm20, Form20);
    Step1('Form21');        Application.CreateForm(TForm21, Form21);
    Step1('Form22');        Application.CreateForm(TOKBottomDlg, Form22);
    Step1('Form23');        Application.CreateForm(TForm23, Form23);
    Step1('Form24');        Application.CreateForm(TForm24, Form24);
    Step1('Form25');        Application.CreateForm(TForm25, Form25);
    Step1('Form26');        Application.CreateForm(TForm26, Form26);
    Step1('Form27');        Application.CreateForm(TOKBottomDlg1, Form27);
    Step1('Form31');        Application.CreateForm(TForm31, Form31);
    Step1('Form32');        Application.CreateForm(TForm32, Form32);
    Step1('Form14');        Application.CreateForm(TForm14, Form14);
    Step1('Form28');        Application.CreateForm(TForm28, Form28);
    Step1('Form29');        Application.CreateForm(TForm29, Form29);
    Step1('Form33');        Application.CreateForm(TForm33, Form33);
    Step1('Form34');        Application.CreateForm(TForm34, Form34);
    Step1('Form35');        Application.CreateForm(TForm35, Form35);
    Step1('Form36');        Application.CreateForm(TForm36, Form36);
    Step1('Form37');        Application.CreateForm(TForm37, Form37);
    Step1('Form30');        Application.CreateForm(TForm30, Form30);
    Step1('Form38');        Application.CreateForm(TForm38, Form38);
    Step1('Form39');        Application.CreateForm(TForm39, Form39);
    Step1('Form40');        Application.CreateForm(TForm40, Form40);
  except
    on E: Exception do
    begin
      WriteLn('FEHLER in ', Step, ': ', E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;

  WriteLn('alle Formulare erzeugt');
  if Application.MainForm <> nil then
    WriteLn('MainForm = ', Application.MainForm.ClassName)
  else
    WriteLn('MainForm = nil');
  WriteLn('Terminated = ', Application.Terminated);
end.
