unit Frm_ListBoxDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

const
  Silibls: array[0..24] of string =
    ('pro', 'ce', 'du', 're', 'fun',
    'tion', 'cre', 'ate', 'im', 'ple',
    'men', 'ta', 'de', 'cla', 'ra',
    'hand', 'ler', 'call', 'ed', 'the',
    'form', 'has', 'been', 'clo', 'sed');

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.FormShow(Sender: TObject);

var
  i: integer;
  ww: string;
  j: integer;
  L: TStringList;
begin
  Randomize;
  L := TStringList.Create;
  try
    for i := 0 to 900 do
    begin
      ww := '';
      for j := 1 to random(18) + 2 do
        ww := ww + Silibls[random(high(Silibls) + 1)];
      L.add(ww);
    end;
    ListBox1.Items.Assign(L);
  finally
    FreeAndNil(L);
  end;
end;

end.
