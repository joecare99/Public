Unit Frm_TstException;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

Type
  TForm3 = Class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Procedure Button1Click(Sender: TObject);
  Private
    { Private-Deklarationen }
  Public
    { Public-Deklarationen }
  End;

Var
  Form3: TForm3;

Implementation

{$R *.dfm}

Procedure TForm3.Button1Click(Sender: TObject);
  Var
    a, b, c, d: single;

  Begin
    a := 10;
    b := 0;
    c := 25;

    b := b / a;        // Hier wird der Fehler erzeugt
    d := Trunc(a * c); // Hier wird der Fehler ausgegeben
    Label1.caption := floattostr(b) + ':' + floattostr(d);
  End;

End.
