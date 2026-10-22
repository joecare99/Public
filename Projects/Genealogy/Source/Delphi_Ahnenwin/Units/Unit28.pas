unit Unit28;

{-------------------------------------------------------------------------------
  Unit28 - TForm28, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit28.pas and the original resource
  Source\Projects_AhnenWin\Form28.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, Buttons, ExtCtrls, StdCtrls, Forms, Controls, Grids, DB;

type
  TForm28 = class(TForm)
  published
    BitBtn1: TBitBtn; //2F0
    Shape1: TShape; //2F4
    Button1: TButton; //2F8
    CheckBox1: TCheckBox; //2FC
    ListBox1: TListBox; //300
    Button2: TButton; //304
    procedure FormActivate(Sender: TObject); //005749AC
    procedure ListBox1Click(Sender: TObject); //00574AA0
    procedure Button2Click(Sender: TObject); //00574AB8
    procedure ListBox1DblClick(Sender: TObject); //005748EC
    procedure BitBtn1Click(Sender: TObject); //00574124
    procedure Button1Click(Sender: TObject); //00574220
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char); //005747C0
  end;

var
  Form28: TForm28;

implementation

uses
  Dialogs, AHNGlobals, Unit1, Unit2, Unit34;

{$R ..\Forms\Form28.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm28.FormActivate(Sender: TObject);
begin
  { The list of the names is filled; the name that was marked is marked
    again. }
  if ListBox1.ItemIndex + 1 > 0 then
    gvar_025363A0 := ListBox1.ItemIndex;
  ListBox1.Clear;
  DataModule2.Table12.First;
  while not DataModule2.Table12.Eof do
  begin
    ListBox1.Items.Add(DataModule2.Table12Name.AsString);
    DataModule2.Table12.Next;
  end;
  ListBox1.ItemIndex := gvar_025363A0;
  { The original uses SetActiveControl, which is private in Delphi 9. }
  ListBox1.SetFocus;
end;

procedure TForm28.ListBox1Click(Sender: TObject);
begin
  { The number of the marked name is remembered. }
  gvar_025363A0 := ListBox1.ItemIndex;
end;

procedure TForm28.Button2Click(Sender: TObject);
begin
  { The list of the names is written into a text file. }
  Form1.Lb_speich(Form28);
end;

procedure TForm28.ListBox1DblClick(Sender: TObject);
begin
  { The name that was clicked is taken over; the dialog for the name is
    shown. }
  gvar_0253639C := ListBox1.Items[gvar_025363A0];
  Form34.Label3.Caption := 'Aktueller Name: ' + gvar_0253639C;
  Form34.Show;
end;

procedure TForm28.BitBtn1Click(Sender: TObject);
begin
  { A new name is created: the list gets a blank entry at the end. }
  DataModule2.Table12.Last;
  DataModule2.Table12.First;
  if Trim(DataModule2.Table12Name.AsString) <> '' then
  begin
    DataModule2.Table12.Append;
    DataModule2.Table12Name.AsString := ' ';
    DataModule2.Table12.Post;
  end;
  gvar_025363A0 := 0;
  ListBox1.ItemIndex := 0;
  ModalResult := mrCancel;
end;

procedure TForm28.Button1Click(Sender: TObject);
var
  personennummer, zeile, anzahl, i: Integer;
  name, oben: string;
  gefunden: Boolean;
begin
  { The persons whose name is the same as the marked entry of the list are
    collected in the grid of the main form.  The first row of the grid
    shows the name that was searched for. }
  personennummer := DataModule2.Table1Nummer.AsInteger;
  name := Copy(ListBox1.Items[ListBox1.ItemIndex], 1, 32);
  if name <> '' then
  begin
    DataModule2.Table1.DisableControls;

    { The grid is cleared. }
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
      Form1.ucase(DataModule2.Table1Name.AsString, oben);
      gefunden := Pos(oben, name) > 0;
      if CheckBox1.Checked then
        gefunden := name = DataModule2.Table1Name.AsString;
      if gefunden then
      begin
        Form1.StringGrid5.Cells[1, zeile] := 'Name: ' + name;
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

procedure TForm28.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  { The return key has the same effect as a double click. }
  if Key = #13 then
  begin
    gvar_0253639C := ListBox1.Items[ListBox1.ItemIndex];
    if Trim(gvar_0253639C) = '' then
    begin
      ShowMessage('Der leere Eintrag kann nicht ge' + #228 + 'ndert werden.');
      Exit;
    end;
    Form34.Label3.Caption := 'Aktueller Name: ' + gvar_0253639C;
    Form34.Show;
  end;
end;


end.
