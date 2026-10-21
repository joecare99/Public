unit Unit37;

{-------------------------------------------------------------------------------
  Unit37 - TForm37, the "Berufe-Verwaltung" (occupation management) dialog.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit37.pas and the original resource
  Source\Projects_AhnenWin\Form37.dfm.

  The dialog is the counterpart of Unit34 ("Namens-Verwaltung"): it renames
  an occupation throughout the database.

    * the occupation list (Table35) gets the new entry, the old one is
      removed,
    * all persons with the old occupation are renamed as well,
    * the person list is repositioned on the person that was displayed
      before the rename.

  Method addresses (original binary):
    00574D20  BitBtn1Click   (abort)
    00574D2C  BitBtn2Click   (apply)
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls;

type
  TForm37 = class(TForm)
  published
    Label1: TLabel; //2F0
    Shape1: TShape; //2F4
    Shape2: TShape; //2F8
    Label2: TLabel; //2FC
    Edit1: TEdit; //300
    BitBtn1: TBitBtn; //304
    BitBtn2: TBitBtn; //308
    Label3: TLabel; //30C
    procedure BitBtn2Click(Sender: TObject); //00574D2C
    procedure BitBtn1Click(Sender: TObject); //00574D20
  end;

var
  Form37: TForm37;

implementation

uses
  AHNGlobals, Unit1, Unit2;

{$R ..\Forms\Form37.DFM}

// 00574D20
procedure TForm37.BitBtn1Click(Sender: TObject);
begin
  { The abort button only closes the dialog. }
  Close;
end;

// 00574D2C
procedure TForm37.BitBtn2Click(Sender: TObject);
var
  OldJob, NewJob: string;
  PersonNr: Integer;
begin
  { The number of the person that is currently displayed is read first, so
    that the person list can be positioned on it again at the end. The
    listing reads it through the field Table1Nummer (offset $534) and
    keeps it in edi. }
  PersonNr := DataModule2.Table1Nummer.AsInteger;

  { The old occupation is taken from the global string gvar_025363B4, the
    new one from the edit field. }
  OldJob := gvar_025363B4;
  NewJob := Edit1.Text;

  { The occupation list is maintained under the index "ber": the old entry
    is removed and the new one is added if it does not exist yet. An empty
    new occupation is not added - the listing trims the text and skips the
    append when the result is empty. }
  DataModule2.Table35.Open;
  DataModule2.Table35.IndexName := 'ber';
  if DataModule2.Table35.FindKey([OldJob]) then
    DataModule2.Table35.Delete;
  if not DataModule2.Table35.FindKey([NewJob]) then
  begin
    if Trim(NewJob) <> '' then
    begin
      DataModule2.Table35.Append;
      DataModule2.Table35Occ.AsString := NewJob;
      DataModule2.Table35.Post;
    end;
  end;

  { All persons with the old occupation are renamed as well. }
  if Edit1.Text <> OldJob then
  begin
    DataModule2.Table1.Open;
    DataModule2.Table1.DisableControls;
    DataModule2.Table1.First;
    while not DataModule2.Table1.Eof do
    begin
      if DataModule2.Table1Beruf.AsString = OldJob then
      begin
        DataModule2.Table1.Edit;
        DataModule2.Table1Beruf.AsString := Edit1.Text;
        DataModule2.Table1.Post;
      end;
      DataModule2.Table1.Next;
    end;
    { The person list is positioned on the person that was displayed
      before the rename - the listing looks the number up with FindKey. }
    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.FindKey([PersonNr]);
    DataModule2.Table1.EnableControls;
  end;

  { All tables that show occupations are refreshed. }
  DataModule2.Table3.Refresh;
  DataModule2.Table6.Refresh;
  DataModule2.Table7.Refresh;
  DataModule2.Table8.Refresh;
  DataModule2.Table9.Refresh;

  Close;
  Form1.anzeigen;
end;

end.
