unit Unit21;

{-------------------------------------------------------------------------------
  Unit21 - TForm21, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit21.pas and the original resource
  Source\Projects_AhnenWin\Form21.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, DBGrids, StdCtrls, Menus, Buttons, Dialogs, Forms, Controls, Grids, DB, Unit2, Unit23;

type
  TForm21 = class(TForm)
  published
    DBGrid1: TDBGrid; //2F0
    Label1: TLabel; //2F4
    PopupMenu1: TPopupMenu; //2F8
    Zeilelschen1: TMenuItem; //2FC
    SpeedButton1: TSpeedButton; //300
    Button2: TButton; //304
    SpeedButton2: TSpeedButton; //308
    SaveDialog1: TSaveDialog; //30C
    procedure SpeedButton2Click(Sender: TObject); //005CBD94
    procedure Button2Click(Sender: TObject); //005CBF14
    procedure SpeedButton1Click(Sender: TObject); //005CBC64
    procedure DBGrid1TitleClick(Sender: TObject; Column: TColumn); //005CBB1C
    procedure Zeilelschen1Click(Sender: TObject); //005CBC10
  end;

var
  Form21: TForm21;

implementation

{$R ..\Forms\Form21.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm21.SpeedButton2Click(Sender: TObject);
begin
  { Die QuickReport-Labels beschriften }
  Form23.QRLabel1.Caption := 'FOKO-Datei:';
  Form23.QRLabel2.Caption := 'Name';
  Form23.QRLabel4.Caption := 'Bek.';
  Form23.QRLabel5.Caption := 'Staat';
  Form23.QRLabel6.Caption := 'PLZ';
  Form23.QRLabel7.Caption := 'Ort';
  Form23.QRLabel8.Caption := 'Terr.';
  Form23.QRLabel9.Caption := 'MK';
  Form23.QRLabel10.Caption := 'von';
  Form23.QRLabel11.Caption := 'bis';
  Form23.QRLabel3.Caption := 'FOKO-Datei';
  { Die Vorschau wird von der QuickReport-Kompatibilitaetsschicht nicht unterstützt. }
  { Form23.QuickRep1.Preview; }
end;

procedure TForm21.Button2Click(Sender: TObject);
var
  f: TextFile;
  s: string;
begin
  { SaveDialog vorbereiten und Dateiwaehlung anzeigen }
  SaveDialog1.DefaultExt := 'txt';
  SaveDialog1.Filter := 'Text-Dateien (*.txt)|*.txt';

  if SaveDialog1.Execute then
  begin
    s := Trim(SaveDialog1.FileName);
    if s <> '' then
    begin
      AssignFile(f, SaveDialog1.FileName);
      Rewrite(f);

      { Tabelle 20 exportieren }
      DataModule2.Table20.DisableControls;
      DataModule2.Table20.Open;
      DataModule2.Table20.First;

      { Kopfzeile }
      Write(f, 'Name' + #9 + 'Bekenntnis' + #9 + 'Staat' + #9 + 'PLZ_KZ' + #9 +
        'Ort' + #9 + 'Territorium' + #9 + 'Beginn' + #9 + 'Ende');
      Writeln(f);

      { Datensaetze }
      while not DataModule2.Table20.Eof do
      begin
        Write(f, DataModule2.Table20NAME.AsString + #9);
        Write(f, DataModule2.Table20BEKENN.AsString + #9);
        Write(f, DataModule2.Table20STAAT.AsString + #9);
        Write(f, DataModule2.Table20PLZ_KZ.AsString + #9);
        Write(f, DataModule2.Table20ORT.AsString + #9);
        Write(f, DataModule2.Table20TER.AsString + #9);
        Write(f, DataModule2.Table20MK.AsString + #9);
        Write(f, DataModule2.Table20VON.AsString);
        Write(f, DataModule2.Table20BIS.AsString);
        Writeln(f);
        DataModule2.Table20.Next;
      end;

      CloseFile(f);

      DataModule2.Table20.First;
      DataModule2.Table20.EnableControls;
    end;
  end;
end;

procedure TForm21.SpeedButton1Click(Sender: TObject);
var
  i: Integer;
begin
  { Die Sätze ohne PLZ_KZ zählen. }
  DataModule2.Table20.DisableControls;
  DataModule2.Table20.First;
  i := 0;
  while not DataModule2.Table20.Eof do
  begin
    if Trim(DataModule2.Table20PLZ_KZ.AsString) = '' then
      Inc(i);
    DataModule2.Table20.Next;
  end;
  DataModule2.Table20.First;
  DataModule2.Table20.EnableControls;
  if i > 0 then
  begin
    if MessageDlg('Es fehlen noch PLZs. Weiter editieren ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      ModalResult := mrCancel;
  end
  else
    ModalResult := mrCancel;
end;

procedure TForm21.DBGrid1TitleClick(Sender: TObject; Column: TColumn);
begin
  { Index nach dem angeklickten Spaltentitel setzen. }
  if Column.Title.Caption = 'NAME' then
    DataModule2.Table20.IndexName := 'nam';
  if Column.Title.Caption = 'ORT' then
    DataModule2.Table20.IndexName := 'ort';
  DataModule2.Table20.First;
  Refresh;
end;

procedure TForm21.Zeilelschen1Click(Sender: TObject);
begin
  if MessageDlg('Diese Zeile l' + #246 + 'schen ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    DataModule2.Table20.Delete;
end;


end.
