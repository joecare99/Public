unit Unit34;

{-------------------------------------------------------------------------------
  Unit34 - TForm34, the "Namens-Verwaltung" (name management) dialog.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit34.pas and the original resource
  Source\Projects_AhnenWin\Form34.dfm.

  The dialog renames a name throughout the database:

    * the name list (Table12 = NM.db) gets the new entry, the old one is
      removed,
    * the person that is currently displayed is renamed if it carries the
      old name,
    * all persons with the same name (index "namgeb" of Table17) are
      renamed as well.

  TForm28 opens the dialog: it puts the selected name into the global
  string gvar_0253639C and shows the form.

  Method addresses (original binary):
    00573B88  BitBtn1Click   (abort)
    00573B94  FormActivate
    00573BA8  BitBtn2Click   (apply)
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls;

type
  TForm34 = class(TForm)
  published
    Edit1: TEdit; //2F0
    Label1: TLabel; //2F4
    Shape1: TShape; //2F8
    Shape2: TShape; //2FC
    Label2: TLabel; //300
    BitBtn1: TBitBtn; //304
    BitBtn2: TBitBtn; //308
    Label3: TLabel; //30C
    procedure BitBtn2Click(Sender: TObject); //00573BA8
    procedure FormActivate(Sender: TObject); //00573B94
    procedure BitBtn1Click(Sender: TObject); //00573B88
  end;

var
  Form34: TForm34;

implementation

uses
  AHNGlobals, Unit1, Unit2;

{$R ..\Forms\Form34.DFM}

// 00573B88
procedure TForm34.BitBtn1Click(Sender: TObject);
begin
  { The abort button only closes the dialog. }
  Close;
end;

// 00573B94
procedure TForm34.FormActivate(Sender: TObject);
begin
  { The name that is to be changed is taken from the global string
    gvar_0253639C, which TForm28 has filled with the selected list entry. }
  Edit1.Text := gvar_0253639C;
end;

// 00573BA8
procedure TForm34.BitBtn2Click(Sender: TObject);
var
  OldName, NewName: string;
begin
  { The old name is the one that was selected in TForm28, the new name is
    what the user typed into the edit field. }
  OldName := gvar_0253639C;
  NewName := Edit1.Text;

  { The name list (NM.db) is maintained under the index "nam_": the old
    entry is removed and the new one is added if it does not exist yet. }
  DataModule2.Table12.Open;
  DataModule2.Table12.IndexName := 'nam_';
  if DataModule2.Table12.FindKey([OldName]) then
    DataModule2.Table12.Delete;
  if not DataModule2.Table12.FindKey([NewName]) then
  begin
    DataModule2.Table12.Append;
    DataModule2.Table12Name.AsString := NewName;
    DataModule2.Table12.Post;
  end;

  { The person that is currently shown in the main form is renamed when it
    carries the old name. The listing reads the name field of the current
    record of Table1 - the record is the one the main form displays. }
  if Edit1.Text <> OldName then
  begin
    if DataModule2.Table1Name.AsString = OldName then
    begin
      DataModule2.Table1.Edit;
      DataModule2.Table1Name.AsString := Edit1.Text;
      DataModule2.Table1.Post;
    end;
  end;

  { All persons with the same name are renamed as well. The index "namgeb"
    of Table17 contains the name together with the year of birth, so that
    the persons with the same name are found in one pass. }
  DataModule2.Table17.Open;
  DataModule2.Table17.IndexName := 'namgeb';
  DataModule2.Table17.First;
  while DataModule2.Table17.FindKey([OldName]) do
  begin
    DataModule2.Table17.Edit;
    DataModule2.Table17Name.AsString := NewName;
    DataModule2.Table17.Post;
  end;
  DataModule2.Table17.IndexName := '';

  { All tables that show names are refreshed. }
  DataModule2.Table1.Refresh;
  DataModule2.Table3.Refresh;
  DataModule2.Table6.Refresh;
  DataModule2.Table7.Refresh;
  DataModule2.Table8.Refresh;
  DataModule2.Table9.Refresh;

  Close;
  Form1.anzeigen;
end;

end.
