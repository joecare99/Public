unit Unit40;

{-------------------------------------------------------------------------------
  Unit40 - TForm40, the "Hofnamen-Verwaltung" (farm name management) dialog.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit40.pas and the original resource
  Source\Projects_AhnenWin\Form40.dfm.

  The dialog is the third of the three name management forms and works
  exactly like Unit34 (names) and Unit37 (occupations):

    * the farm name list (Table37 = ndh.db) gets the new entry, the old one
      is removed,
    * all persons with the old farm name are renamed as well - the listing
      compares the field Table1Hausname (offset $5C8) of Table1,
    * the person list is positioned on the person that was displayed before
      the rename.

  Method addresses (original binary):
    00575C7C  BitBtn1Click   (abort)
    00575C88  BitBtn2Click   (apply)
    00575F0C  FormActivate
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls;

type
  TForm40 = class(TForm)
  published
    Label1: TLabel; //2F0
    Shape1: TShape; //2F4
    Shape2: TShape; //2F8
    Label2: TLabel; //2FC
    Edit1: TEdit; //300
    BitBtn1: TBitBtn; //304
    BitBtn2: TBitBtn; //308
    Label3: TLabel; //30C
    procedure FormActivate(Sender: TObject); //00575F0C
    procedure BitBtn2Click(Sender: TObject); //00575C88
    procedure BitBtn1Click(Sender: TObject); //00575C7C
  end;

var
  Form40: TForm40;

implementation

uses
  AHNGlobals, Unit1, Unit2;

{$R ..\Forms\Form40.DFM}

// 00575C7C
procedure TForm40.BitBtn1Click(Sender: TObject);
begin
  { The abort button only closes the dialog. }
  Close;
end;

// 00575C88
procedure TForm40.BitBtn2Click(Sender: TObject);
var
  OldName, NewName: string;
  PersonNr: Integer;
begin
  { The number of the person that is currently displayed is read first, so
    that the person list can be positioned on it again at the end. }
  PersonNr := DataModule2.Table1Nummer.AsInteger;

  { The old farm name is taken from the global string gvar_025363CC, the
    new one from the edit field. }
  OldName := gvar_025363CC;
  NewName := Edit1.Text;

  { The farm name list is maintained under the primary index: the old entry
    is removed and the new one is added if it does not exist yet. An empty
    new name is not added - the listing trims the text and skips the append
    when the result is empty. }
  DataModule2.Table37.Open;
  DataModule2.Table37.IndexName := '';
  if DataModule2.Table37.FindKey([OldName]) then
    DataModule2.Table37.Delete;
  if not DataModule2.Table37.FindKey([NewName]) then
  begin
    if Trim(NewName) <> '' then
    begin
      DataModule2.Table37.Append;
      DataModule2.Table37Hofname.AsString := NewName;
      DataModule2.Table37.Post;
    end;
  end;

  { All persons with the old farm name are renamed as well. }
  if Edit1.Text <> OldName then
  begin
    DataModule2.Table1.Open;
    DataModule2.Table1.DisableControls;
    DataModule2.Table1.First;
    while not DataModule2.Table1.Eof do
    begin
      if DataModule2.Table1Hausname.AsString = OldName then
      begin
        DataModule2.Table1.Edit;
        DataModule2.Table1Hausname.AsString := Edit1.Text;
        DataModule2.Table1.Post;
      end;
      DataModule2.Table1.Next;
    end;
    { The person list is positioned on the person that was displayed
      before the rename. }
    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.FindKey([PersonNr]);
    DataModule2.Table1.EnableControls;
  end;

  { All tables that show farm names are refreshed. }
  DataModule2.Table17.Open;
  DataModule2.Table17.Refresh;
  DataModule2.Table3.Refresh;
  DataModule2.Table6.Refresh;
  DataModule2.Table7.Refresh;
  DataModule2.Table8.Refresh;
  DataModule2.Table9.Refresh;

  Close;
  Form1.anzeigen;
end;

// 00575F0C
procedure TForm40.FormActivate(Sender: TObject);
begin
  { The farm name that is to be changed is taken from the global string
    gvar_025363CC, which the calling form has filled. }
  Edit1.Text := gvar_025363CC;
end;

end.
