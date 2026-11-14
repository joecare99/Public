unit Unit14;

{-------------------------------------------------------------------------------
  Unit14 - TForm14, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit14.pas and the original resource
  Source\Projects_AhnenWin\Form14.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, Buttons, ExtCtrls, StdCtrls, Forms, Controls, Grids, DB, Dialogs;

type
  TForm14 = class(TForm)
  published
    BitBtn1: TBitBtn; //2F0
    Shape1: TShape; //2F4
    Button1: TButton; //2F8
    CheckBox1: TCheckBox; //2FC
    ListBox1: TListBox; //300
    Button2: TButton; //304
    procedure FormActivate(Sender: TObject); //0053C738
    procedure ListBox1Click(Sender: TObject); //0053C850
    procedure Button2Click(Sender: TObject); //0053C868
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char); //0053C5C0
    procedure Button1Click(Sender: TObject); //0053B964
    procedure BitBtn1Click(Sender: TObject); //0053C430
    procedure ListBox1DblClick(Sender: TObject); //0053C454
  end;

var
  Form14: TForm14;

implementation

uses
  AHNGlobals, Unit1, Unit2, Unit33;

{$R ..\Forms\Form14.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm14.FormActivate(Sender: TObject);
begin
  { The list of the places is filled; the place that was marked is
    marked again. }
  if ListBox1.ItemIndex + 1 > 0 then
    gvar_0061EFC0 := ListBox1.ItemIndex;
  ListBox1.Clear;
  DataModule2.Table13.IndexName := 'ort_';
  DataModule2.Table13.First;
  while not DataModule2.Table13.Eof do
  begin
    ListBox1.Items.Add(DataModule2.Table13Ort.AsString);
    DataModule2.Table13.Next;
  end;
  ListBox1.ItemIndex := gvar_0061EFC0;
  { The original uses SetActiveControl, which is private in Delphi 9. }
  ListBox1.SetFocus;
end;

procedure TForm14.ListBox1Click(Sender: TObject);
begin
  { The number of the marked place is remembered. }
  gvar_0061EFC0 := ListBox1.ItemIndex;
end;

procedure TForm14.Button2Click(Sender: TObject);
begin
  { The list of the places is written into a text file. }
  Form1.Lb_speich(Form14);
end;

procedure TForm14.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  { The return key has the same effect as a double click. }
  if Key = #13 then
  begin
    gvar_0061EFB8 := ListBox1.Items[ListBox1.ItemIndex];
    if Trim(gvar_0061EFB8) <> '' then
      DataModule2.Table13.FindKey([gvar_0061EFB8]);
    if Trim(gvar_0061EFB8) = '' then
    begin
      ShowMessage('Der leere Eintrag kann nicht ge' + #228 + 'ndert werden.');
      Exit;
    end;
    Form33.Label12.Caption := 'Aktueller Orts-Name: ' + gvar_0061EFB8;
    Form33.Show;
  end;
end;

procedure TForm14.Button1Click(Sender: TObject);
begin
  { Die Liste der Orte in eine Datei schreiben. }
  Form1.Lb_speich(Form14);
end;

procedure TForm14.BitBtn1Click(Sender: TObject);
begin
  { The list is closed; no place is marked any more. }
  gvar_0061EFC0 := 0;
  ListBox1.ItemIndex := 0;
  Close;
end;

procedure TForm14.ListBox1DblClick(Sender: TObject);
begin
  { The place that was clicked is taken over into the list of the
    places and the dialog for the place is shown. }
  gvar_0061EFB8 := ListBox1.Items[ListBox1.ItemIndex];
  if Trim(gvar_0061EFB8) <> '' then
    DataModule2.Table13.FindKey([gvar_0061EFB8]);
  if Trim(gvar_0061EFB8) = '' then
  begin
    ShowMessage('Der leere Eintrag kann nicht ge' + #228 + 'ndert werden.');
    Exit;
  end;
  Form33.Label12.Caption := 'Aktueller Orts-Name: ' + gvar_0061EFB8;
  Form33.Show;
end;


end.
