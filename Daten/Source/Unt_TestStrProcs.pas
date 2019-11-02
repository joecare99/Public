unit Unt_TestStrProcs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,unt_stringprocs, Buttons;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    btn_Open: TBitBtn;
    btn_Save: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Button9: TButton;
    Label4: TLabel;
    Button10: TButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btn_OpenClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormShow(Sender: TObject);

var isep:TSeparators;
begin
  label1.Caption := 'test'+vbNewLine+'test2';
  combobox1.Items.Clear ;
  for isep := low(Tseparators) to high(Tseparators) do
    if LineSeparators[isep,1] = '' then
      combobox1.Items.AddObject (LineSeparators[isep,0],Tobject(isep))
    else
      combobox1.Items.addObject(LineSeparators[isep,0]+' ... '+LineSeparators[isep,1],TObject(Isep));

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  close
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.btn_OpenClick(Sender: TObject);
begin
   OpenDialog1.FileName := '*.txt' ;
   if OpenDialog1.Execute then
     begin
       memo1.Lines.LoadFromFile (OpenDialog1.FileName);
       edit1.text:=extractfilename(OpenDialog1.FileName);
     end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  label1.Caption := Filename2text(memo1.lines.text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   memo1.Lines.text:=label1.Caption;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  label1.Caption := memo1.lines.text;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  label1.Caption := Text2Filename(memo1.lines.text);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  label1.Caption := Ascii2ansi(memo1.lines.text);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  label1.Caption := Ansi2ascii (memo1.lines.text);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  label2.Caption :=inttostr( wordcount(memo1.LineS.text,edit2.Text));
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  if combobox1.ItemIndex >= 0 then
    begin
      if testLinesep(memo1.lines.text,Tseparators(combobox1.items.Objects[combobox1.ItemIndex])) then
        label3.Caption := 'TRUE'
      else
        label3.Caption := 'False'
    end;
end;

procedure TForm1.Button9Click(Sender: TObject);

var rest,separ:string;

begin
  if combobox1.ItemIndex >= 0 then
    begin
      if testLinesep(memo1.lines.text,Tseparators(combobox1.items.Objects[combobox1.ItemIndex]),rest,separ) then
        begin
          label3.caption:=rest;
          label4.caption:=separ;
        end;
    end;

end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  label1.Caption := strsort(Memo1.Lines.Text,Tseparators(combobox1.items.Objects[combobox1.ItemIndex]),alphanum);
end;

end.
