unit Unit39;

{-------------------------------------------------------------------------------
  Unit39 - TForm39, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit39.pas and the original resource
  Source\Projects_AhnenWin\Form39.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, StdCtrls, Buttons, ExtCtrls, Forms, Controls, Grids, DB;

type
  TForm39 = class(TForm)
  published
    Button1: TButton; //2F0
    CheckBox1: TCheckBox; //2F4
    BitBtn1: TBitBtn; //2F8
    Shape1: TShape; //2FC
    ListBox1: TListBox; //300
    Button2: TButton; //304
    procedure FormActivate(Sender: TObject); //00576840
    procedure ListBox1Click(Sender: TObject); //00576944
    procedure Button2Click(Sender: TObject); //0057695C
    procedure Button1Click(Sender: TObject); //005761A8
    procedure BitBtn1Click(Sender: TObject); //0057674C
    procedure ListBox1DblClick(Sender: TObject); //00576774
  end;

var
  Form39: TForm39;

implementation

uses
  AHNGlobals, Unit1, Unit2, Unit40;

{$R ..\Forms\Form39.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm39.FormActivate(Sender: TObject);
begin
  { The list of the estates is filled; the estate that was marked is
    marked again. }
  if ListBox1.ItemIndex + 1 > 0 then
    gvar_025363D0 := ListBox1.ItemIndex;
  ListBox1.Clear;
  DataModule2.Table37.IndexName := '';
  DataModule2.Table37.First;
  while not DataModule2.Table37.Eof do
  begin
    ListBox1.Items.Add(DataModule2.Table37Hofname.AsString);
    DataModule2.Table37.Next;
  end;
  ListBox1.ItemIndex := gvar_025363D0;
  { The original uses SetActiveControl, which is private in Delphi 9. }
  ListBox1.SetFocus;
end;

procedure TForm39.ListBox1Click(Sender: TObject);
begin
  { The number of the marked estate is remembered. }
  gvar_025363D0 := ListBox1.ItemIndex;
end;

procedure TForm39.Button2Click(Sender: TObject);
begin
  { The list of the estates is written into a text file. }
  Form1.Lb_speich(Form39);
end;

procedure TForm39.Button1Click(Sender: TObject);
var
  personennummer, zeile, anzahl, i: Integer;
  hofname, oben: string;
  gefunden: Boolean;
begin
  { The persons whose estate is the same as the marked entry of the list
    are collected in the grid of the main form. }
  personennummer := DataModule2.Table1Nummer.AsInteger;
  hofname := Copy(ListBox1.Items[ListBox1.ItemIndex], 1, 32);
  if hofname <> '' then
  begin
    DataModule2.Table1.DisableControls;

    anzahl := Form1.StringGrid5.RowCount - 1;
    if anzahl >= 0 then
    begin
      Inc(anzahl);
      for i := 0 to anzahl - 1 do
      begin
        Form1.StringGrid5.Cells[0, i] := '';
        Form1.StringGrid5.Cells[1, i] := '';
        Form1.StringGrid5.Cells[2, i] := '';
        Form1.StringGrid5.Cells[3, i] := '';
      end;
    end;
    Form1.StringGrid5.RowCount := 1;

    DataModule2.Table1.IndexName := 'namgeb';
    DataModule2.Table1.First;
    zeile := 0;
    while not DataModule2.Table1.Eof do
    begin
      Form1.ucase(DataModule2.Table1Hausname.AsString, oben);
      gefunden := Pos(oben, hofname) > 0;
      if CheckBox1.Checked then
        gefunden := hofname = DataModule2.Table1Hausname.AsString;
      if gefunden then
      begin
        Form1.StringGrid5.Cells[1, zeile] := 'Hofname: ' + hofname;
        Inc(zeile);
        Form1.StringGrid5.Visible := True;
        Form1.StringGrid5.RowCount := Form1.StringGrid5.RowCount + 1;
        Form1.StringGrid5.Cells[0, zeile] := IntToStr(DataModule2.Table1Nummer.AsInteger);
        Form1.StringGrid5.Cells[1, zeile] := DataModule2.Table1Name.AsString + ' ' +
          DataModule2.Table1Vornamen.AsString;
        if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then
          Form1.StringGrid5.Cells[2, zeile] := '* ' + DataModule2.Table1Gebjahr.AsString
        else if Trim(DataModule2.Table1Taufjahr.AsString) <> '' then
          Form1.StringGrid5.Cells[2, zeile] := '~ ' + DataModule2.Table1Taufjahr.AsString;
        if Trim(DataModule2.Table1Stjahr.AsString) <> '' then
          Form1.StringGrid5.Cells[3, zeile] := '+ ' + DataModule2.Table1Stjahr.AsString;
      end;
      DataModule2.Table1.Next;
    end;

    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.FindKey([personennummer]);
    DataModule2.Table1.EnableControls;
    Close;
  end;
end;

procedure TForm39.BitBtn1Click(Sender: TObject);
begin
  { The list is closed; no estate is marked any more. }
  gvar_025363D0 := 0;
  ListBox1.ItemIndex := 0;
  ModalResult := mrCancel;
end;

procedure TForm39.ListBox1DblClick(Sender: TObject);
begin
  { The estate that was clicked is taken over; the dialog for the estate
    is shown. }
  gvar_025363CC := ListBox1.Items[ListBox1.ItemIndex];
  Form40.Label3.Caption := 'Aktueller Hofname:    ' + gvar_025363CC;
  Form40.Show;
end;


end.
