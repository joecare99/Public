unit frm_MsProdKeyMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses unt_MSProdKey;
{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j: Integer;
  key, decoded: String;
  binkey: TBinKey;
  s, c, z: LOngWord;
  v: byte;
  t, m: word;
begin
  ListBox1.Clear;
  ListBox2.Clear;
  ListBox3.clear;
  for i := 0 to Memo1.lines.count-1 do
    try
      if length(memo1.lines[i]) < 24 then
        begin
          ListBox1.AddItem(memo1.lines[i],nil);
          ListBox2.AddItem('',nil);
          listbox3.AddItem(memo1.lines[i],nil);
          Continue;
        end;
      key:= normalize(memo1.lines[i]);

      decode(key, binkey);
      decoded:='';
      for J := 0 to BINARY_LENGTH-1 do
         decoded += inttohex(binkey[j],2);
      ListBox1.AddItem(decoded,nil);
      VerifyCrc(binkey,t,m);
      ListBox2.AddItem(format('m:%3.3u t:%3.3u',[m,t]),nil);
      listbox3.AddItem(Getcomposite(binkey,s,c,v,z),nil);
    except

    end;
end;

end.

