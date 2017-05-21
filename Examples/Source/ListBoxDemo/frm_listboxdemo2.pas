unit frm_listboxdemo2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    lbFamily: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmMain: TfrmMain;

implementation
{.$define Debug}

{$R *.lfm}

procedure TfrmMain.FormCreate(Sender: TObject);


begin
  // populate cbcharset
end;

procedure TfrmMain.FormShow(Sender: TObject);
const
Silibls: array[0..24] of string =
('pro', 'ce', 'du', 're', 'fun',
'tion', 'cre', 'ate', 'im', 'ple',
'men', 'ta', 'de', 'cla', 'ra',
'hand', 'ler', 'call', 'ed', 'the',
'form', 'has', 'been', 'clo', 'sed');

  procedure FillListDebug(const Listbox:TListBox);

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
      ListBox.Items.Assign(L);
    finally
      FreeAndNil(L);
    end;
  end;

begin
 // LoadFontlist;
 FillListDebug(lbFamily);
end;


end.

