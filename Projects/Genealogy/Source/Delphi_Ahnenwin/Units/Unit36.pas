unit Unit36;

{-------------------------------------------------------------------------------
  Unit36 - TForm36, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit36.pas and the original resource
  Source\Projects_AhnenWin\Form36.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, Buttons, StdCtrls, Forms, Controls, Grids, DB;

type
  TForm36 = class(TForm)
  published
    Shape1: TShape; //2F0
    BitBtn1: TBitBtn; //2F4
    Button1: TButton; //2F8
    CheckBox1: TCheckBox; //2FC
    ListBox1: TListBox; //300
    Button2: TButton; //304
    procedure ListBox1Click(Sender: TObject); //005758D8
    procedure FormActivate(Sender: TObject); //005758F0
    procedure Button2Click(Sender: TObject); //00575A04
    procedure BitBtn1Click(Sender: TObject); //0057522C
    procedure Button1Click(Sender: TObject); //00575254
    procedure ListBox1DblClick(Sender: TObject); //005757F4
  end;

var
  Form36: TForm36;

implementation

uses
  AHNGlobals, Unit1, Unit2, Unit37;

{$R ..\Forms\Form36.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm36.ListBox1Click(Sender: TObject);
begin
  { The number of the marked occupation is remembered. }
  gvar_025363B8 := ListBox1.ItemIndex;
end;

procedure TForm36.FormActivate(Sender: TObject);
begin
  { The list of the occupations is filled; the occupation that was marked
    is marked again. }
  if ListBox1.ItemIndex + 1 > 0 then
    gvar_025363B8 := ListBox1.ItemIndex;
  ListBox1.Clear;
  DataModule2.Table35.IndexName := 'ber';
  DataModule2.Table35.First;
  while not DataModule2.Table35.Eof do
  begin
    ListBox1.Items.Add(DataModule2.Table35Occ.AsString);
    DataModule2.Table35.Next;
  end;
  ListBox1.ItemIndex := gvar_025363B8;
  { The original uses SetActiveControl, which is private in Delphi 9. }
  ListBox1.SetFocus;
end;

procedure TForm36.Button2Click(Sender: TObject);
begin
  { The list of the occupations is written into a text file. }
  Form1.Lb_speich(Form36);
end;

procedure TForm36.BitBtn1Click(Sender: TObject);
begin
  { The list is closed; no occupation is marked any more. }
  gvar_025363B8 := 0;
  ListBox1.ItemIndex := 0;
  ModalResult := mrCancel;
end;

procedure TForm36.Button1Click(Sender: TObject);
var
  personennummer, zeile, anzahl, i: Integer;
  beruf, oben: string;
  gefunden: Boolean;
begin
  { The persons whose occupation is the same as the marked entry of the
    list are collected in the grid of the main form. }
  personennummer := DataModule2.Table1Nummer.AsInteger;
  beruf := Copy(ListBox1.Items[ListBox1.ItemIndex], 1, 32);
  if beruf <> '' then
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
      Form1.ucase(DataModule2.Table1Beruf.AsString, oben);
      gefunden := Pos(oben, beruf) > 0;
      if CheckBox1.Checked then
        gefunden := beruf = DataModule2.Table1Beruf.AsString;
      if gefunden then
      begin
        Form1.StringGrid5.Cells[1, zeile] := 'Beruf: ' + beruf;
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

procedure TForm36.ListBox1DblClick(Sender: TObject);
begin
  { The occupation that was clicked is taken over; the dialog for the
    occupation is shown. }
  gvar_025363B4 := ListBox1.Items[ListBox1.ItemIndex];
  Form37.Label3.Caption := 'Aktueller Beruf :    ' + gvar_025363B4;
  Form37.Edit1.Text := gvar_025363B4;
  Form37.Show;
end;


end.
