unit Unit29;

{-------------------------------------------------------------------------------
  Unit29 - TForm29, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit29.pas and the original resource
  Source\Projects_AhnenWin\Form29.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, StdCtrls, ExtCtrls, Buttons, Forms, Controls, Grids, DB;

type
  TForm29 = class(TForm)
  published
    Button2: TButton; //2F0
    CheckBox1: TCheckBox; //2F4
    ListBox1: TListBox; //2F8
    Shape1: TShape; //2FC
    SpeedButton1: TSpeedButton; //300
    Button1: TButton; //304
    procedure ListBox1Click(Sender: TObject); //0056223C
    procedure SpeedButton1Click(Sender: TObject); //00562254
    procedure Button1Click(Sender: TObject); //0056227C
    procedure Button2Click(Sender: TObject); //00561434
    procedure ListBox1DblClick(Sender: TObject); //00562060
    procedure FormActivate(Sender: TObject); //00562128
  end;

var
  Form29: TForm29;

implementation

uses
  AHNGlobals, Unit1, Unit2, Unit30;

{$R ..\Forms\Form29.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm29.ListBox1Click(Sender: TObject);
begin
  { The number of the marked source is remembered. }
  gvar_0061F0F0 := ListBox1.ItemIndex;
end;

procedure TForm29.SpeedButton1Click(Sender: TObject);
begin
  { The list is closed; no source is marked any more. }
  gvar_0061F0F0 := 0;
  ListBox1.ItemIndex := 0;
  ModalResult := mrCancel;
end;

procedure TForm29.Button1Click(Sender: TObject);
begin
  { The list of the sources is written into a text file. }
  Form1.Lb_speich(Form29);
end;

procedure TForm29.Button2Click(Sender: TObject);
begin
  { Die Liste der Quellen in eine Datei schreiben. }
  Form1.Lb_speich(Form29);
end;

procedure TForm29.ListBox1DblClick(Sender: TObject);
begin
  { The source that was clicked is taken over; the dialog for the source
    is shown. }
  gvar_0061F0EC := ListBox1.Items[ListBox1.ItemIndex];
  Form30.Label3.Caption := 'Aktuelle Quelle: ' + gvar_0061F0EC;
  Form30.Show;
end;

procedure TForm29.FormActivate(Sender: TObject);
begin
  { The list of the sources is filled; the source that was marked is
    marked again. }
  if ListBox1.ItemIndex + 1 > 0 then
    gvar_0061F0F0 := ListBox1.ItemIndex;
  ListBox1.Clear;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
  while not DataModule2.Table38.Eof do
  begin
    ListBox1.Items.Add(DataModule2.Table38Titel.AsString);
    DataModule2.Table38.Next;
  end;
  ListBox1.ItemIndex := gvar_0061F0F0;
  { The original uses SetActiveControl, which is private in Delphi 9. }
  ListBox1.SetFocus;
end;


end.
