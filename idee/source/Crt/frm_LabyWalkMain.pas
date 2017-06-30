unit frm_LabyWalkMain;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    ExtCtrls, Buttons;

type

    { TForm1 }

    TForm1 = class(TForm)
        edtCharset: TEdit;
        ListBox1: TListBox;
        edtLognCode: TMemo;
        edtDisplayIO: TMemo;
        SpeedButton1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        Timer1: TTimer;
        ToggleBox1: TToggleBox;
        procedure FormCreate(Sender: TObject);
        procedure ListBox1DblClick(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure SpeedButton2Click(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure ToggleBox1Click(Sender: TObject);
    private

    public

    end;

var
    Form1: TForm1;

implementation

const
   CharSet=' |\_/X-=';
   DefaultStr:array[0..8]  of string=
('|\     /|'+LineEnding+
 '| \___/ |'+LineEnding+
 '| |\_/| |'+LineEnding+
 '| ||X|| |'+LineEnding+
 '| |/_\| |'+LineEnding+
 '| /   \ |'+LineEnding+
 '|/_____\|',
 ' \_____/ '+LineEnding+
 ' |\   /| '+LineEnding+
 ' | \-/ | '+LineEnding+
 ' | |X| | '+LineEnding+
 ' | /-\ | '+LineEnding+
 ' |/___\| '+LineEnding+
 ' /     \ ',
 ' \_____/ '+LineEnding+
 ' |\   /| '+LineEnding+
 ' | \-/ | '+LineEnding+
 ' | |=| | '+LineEnding+
 ' | /-\ | '+LineEnding+
 ' |/___\| '+LineEnding+
 ' /     \ ',
 '|\     /|'+LineEnding+
 '| \___/ |'+LineEnding+
 '| |__/| |'+LineEnding+
 '| |__|| |'+LineEnding+
 '| |__\| |'+LineEnding+
 '| /   \ |'+LineEnding+
 '|/_____\|',
 ' \_____/ '+LineEnding+
 ' |    /| '+LineEnding+
 ' |- -/ | '+LineEnding+
 ' | | | | '+LineEnding+
 ' |- -\ | '+LineEnding+
 ' |____\| '+LineEnding+
 ' /     \ ',
 '|      /|'+LineEnding+
 '|_____/ |'+LineEnding+
 '| |   | |'+LineEnding+
 '| |   | |'+LineEnding+
 '|_|___| |'+LineEnding+
 '|     \ |'+LineEnding+
 '|______\|',
 '_ _____/ '+LineEnding+
 ' |     | '+LineEnding+
 ' |     | '+LineEnding+
 ' |     | '+LineEnding+
 ' |     | '+LineEnding+
 '_|_____| '+LineEnding+
 '       \ ',
 ' /|      '+LineEnding+
 '/ |      '+LineEnding+
 '| |      '+LineEnding+
 '| |      '+LineEnding+
 '| |      '+LineEnding+
 '\ |      '+LineEnding+
 '_\|      ',
 '    /|   '+LineEnding+
 '___/ |   '+LineEnding+
 '\_/| |   '+LineEnding+
 '|X|| |   '+LineEnding+
 '/_\| |   '+LineEnding+
 '   \ |   '+LineEnding+
 '____\|   ');
   Movie: array[0..10]  of integer=
(1,
 0,
 1,
 0,
 2,
 3,
 4,
 5,
 6,
 7,
 8);


var
    pp: array of string;

{$R *.lfm}

{ TForm1 }

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
    lFnd, i: integer;
begin
    // Append Picture
    lFnd := -1;
    for i := 0 to high(pp) do
        if pp[i] = edtDisplayIO.Text then
          begin
            lFnd := i;
            break;
          end;
    if lFnd = -1 then
      begin
        setlength(pp, length(pp) + 1);
        pp[high(pp)] := edtDisplayIO.Text;
        lFnd := high(pp);
      end;
    ListBox1.AddItem(IntToStr(lFnd), TObject(Ptrint(lFnd)));
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  edtCharset.Text:=CharSet;
  for i := 0 to high(Movie) do
      ListBox1.AddItem(IntToStr(Movie[i]),TObject(PtrInt(Movie[i])));
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  edtDisplayIO.text := pp[PtrInt(ListBox1.Items.Objects[ListBox1.ItemIndex])];
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
    i: integer;
begin
    edtLognCode.Clear;
    // Charset
    edtLognCode.Append('const ' + LineEnding + '   CharSet=' + QuotedStr(edtCharset.Text) + ';');
    // Frames
    edtLognCode.Append('   DefaultStr:array[0..' + IntToStr(high(pp)) + ']  of string=');
    for i := 0 to high(pp) do
        edtLognCode.Append(booltostr(I = 0, '(', ' ') + StringReplace(QuotedStr(
             pp[i]),LineEnding,QuotedStr('+LineEnding+'+LineEnding+' '),
             [rfReplaceAll]) + BoolToStr(i < high(pp), ',', ');'));
    // Movie
    edtLognCode.Append('   Movie: array[0..' + IntToStr(ListBox1.Count-1) + ']  of integer=');
    for i := 0 to ListBox1.Count-1 do
        edtLognCode.Append(booltostr(I = 0, '(', ' ') + InttoStr(PtrInt(ListBox1.Items.Objects[i]))+
             BoolToStr(i < ListBox1.Count-1, ',', ');'));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  SpeedButton1.Enabled:=false;
  ListBox1.ItemIndex:=(ListBox1.ItemIndex+1) mod ListBox1.Count;
  edtDisplayIO.text := pp[PtrInt(ListBox1.Items.Objects[ListBox1.ItemIndex])];
end;

procedure TForm1.ToggleBox1Click(Sender: TObject);
begin
  timer1.Enabled:=ToggleBox1.Checked;
  SpeedButton1.Enabled := not ToggleBox1.Checked;
  ToggleBox1.Caption:=BoolToStr(ToggleBox1.Checked,'[X] Edit->[ ]','[ ]<-Anim [X]');
end;

var
    i: integer;

initialization
    setlength(pp, high(DefaultStr) + 1);
    for i := 0 to high(DefaultStr) do
        pp[i] := DefaultStr[i];
end.
