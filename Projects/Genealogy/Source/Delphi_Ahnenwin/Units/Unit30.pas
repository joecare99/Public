unit Unit30;

{-------------------------------------------------------------------------------
  Unit30 - TForm30, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit30.pas and the original resource
  Source\Projects_AhnenWin\Form30.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, StdCtrls, ExtCtrls, Buttons, DBCtrls, Forms, Controls, Grids, DB, Windows, Messages,
  AHNGlobals, Unit2;

type
  TForm30 = class(TForm)
  published
    Label1: TLabel; //2F0
    Shape1: TShape; //2F4
    Shape2: TShape; //2F8
    Label2: TLabel; //2FC
    Label3: TLabel; //300
    BitBtn1: TBitBtn; //304
    BitBtn2: TBitBtn; //308
    Shape3: TShape; //30C
    DBEdit1: TDBEdit; //310
    Label4: TLabel; //314
    DBEdit2: TDBEdit; //318
    Label5: TLabel; //31C
    DBEdit3: TDBEdit; //320
    Label6: TLabel; //324
    Label7: TLabel; //328
    DBEdit4: TDBEdit; //32C
    DBEdit5: TDBEdit; //330
    Label8: TLabel; //334
    DBEdit6: TDBEdit; //338
    Label9: TLabel; //33C
    DBMemo1: TDBMemo; //340
    Label11: TLabel; //344
    DBEdit7: TDBEdit; //348
    Label12: TLabel; //34C
    DBMemo3: TDBMemo; //350
    Label13: TLabel; //354
    DBEdit8: TDBEdit; //358
    Label14: TLabel; //35C
    DBEdit9: TDBEdit; //360
    Shape4: TShape; //364
    Label15: TLabel; //368
    Label16: TLabel; //36C
    Label17: TLabel; //370
    Label18: TLabel; //374
    Label19: TLabel; //378
    Label20: TLabel; //37C
    Label21: TLabel; //380
    Label23: TLabel; //384
    Label24: TLabel; //388
    Label25: TLabel; //38C
    Label26: TLabel; //390
    Label27: TLabel; //394
    procedure FormKeyPress(Sender: TObject; var Key: Char); //00560EA8
    procedure FormShow(Sender: TObject); //00560EC8
    procedure BitBtn1Click(Sender: TObject); //005601E8
    procedure BitBtn2Click(Sender: TObject); //005601F4
  end;

var
  Form30: TForm30;

implementation

{$R ..\Forms\Form30.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm30.FormKeyPress(Sender: TObject; var Key: Char);
begin
  { The return key is passed on to the form. }
  if Key = #13 then
  begin
    Key := #0;
    PostMessage(Handle, WM_KEYDOWN, VK_RETURN, 0);
  end;
end;

procedure TForm30.FormShow(Sender: TObject);
begin
  { Die gewählte Quelle aus der Liste von Form29 anzeigen. }
  DataModule2.Table38.FindKey([gvar_0061F0EC]);
  Label15.Caption := 'Matrikel Tegernsee';
  Label16.Caption := 'Matr.Tegernsee';
  Label17.Caption := 'Taufen - Trauungen - Sterbef' + #228 + 'lle';
  Label18.Caption := '1756';
  Label19.Caption := '1798';
  Label20.Caption := 'AEM M' + #252 + 'nchen';
  Label21.Caption := 'Erzbistum M' + #252 + 'nchen-Freising';
  Label23.Caption := '[Adresse des Archivs]';
  Label24.Caption := 'kann im Lesesaal eingesehen werden;' + #13 + #10 +
    'fotografieren nicht erlaubt; Mi...';
  Label25.Caption := 'Pfr. Tegernsee Bd. 12';
  Label26.Caption := 'Buch - Microfiche - Microfilm';
end;

procedure TForm30.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm30.BitBtn2Click(Sender: TObject);
begin
  { Wenn im Bearbeite- oder Einfuegemodus: Datensatz speichern }
  if DataModule2.Table38.State in [dsEdit, dsInsert] then
    DataModule2.Table38.Post;

  { Quelle suchen oder neu anlegen }
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';

  if DataModule2.Table38.FindKey([gvar_0061F0EC]) then
  begin
    if DataModule2.Table38Titel.AsString <> DBEdit1.Text then
      DataModule2.Table38.Delete;
    DataModule2.Table38.Edit;
  end
  else
  begin
    DataModule2.Table38.Append;
    DataModule2.Table38Titel.AsString := gvar_0061F0EC;
  end;

  { Leere Textfelder aus DBEdit1 fuellen }
  if DataModule2.Table38Abk.AsString = '' then
    DataModule2.Table38Abk.AsString := DBEdit1.Text;
  if DataModule2.Table38Ereig.AsString = '' then
    DataModule2.Table38Ereig.AsString := DBEdit1.Text;
  if DataModule2.Table38Von.AsString = '' then
    DataModule2.Table38Von.AsString := DBEdit1.Text;
  if DataModule2.Table38Bis.AsString = '' then
    DataModule2.Table38Bis.AsString := DBEdit1.Text;
  if DataModule2.Table38Standort.AsString = '' then
    DataModule2.Table38Standort.AsString := DBEdit1.Text;
  if DataModule2.Table38Publ.AsString = '' then
    DataModule2.Table38Publ.AsString := DBEdit1.Text;
  if DataModule2.Table38Rep.AsString = '' then
    DataModule2.Table38Rep.AsString := DBEdit1.Text;
  if DataModule2.Table38Bem.AsString = '' then
    DataModule2.Table38Bem.AsString := DBEdit1.Text;
  if DataModule2.Table38Bestand.AsString = '' then
    DataModule2.Table38Bestand.AsString := DBEdit1.Text;
  if DataModule2.Table38Med.AsString = '' then
    DataModule2.Table38Med.AsString := DBEdit1.Text;

  DataModule2.Table38.Post;

  { Bei Namensänderung: zugehoerige Datensaetze in Tabelle 20 aktualisieren }
  if DataModule2.Table38Titel.AsString <> gvar_0061F0EC then
  begin
    DataModule2.Table20.Open;
    DataModule2.Table20.DisableControls;
    DataModule2.Table20.First;
    while not DataModule2.Table20.Eof do
    begin
      DataModule2.Table20.Next;
    end;
    DataModule2.Table20.EnableControls;
  end
  else
  begin
    DataModule2.Table20.Close;
    DataModule2.Table20.Open;
  end;

  DataModule2.Table20.IndexName := '';
  DataModule2.Table20.First;
  DataModule2.Table20.FindKey([gvar_0061F0EC]);
  DataModule2.Table20.EnableControls;

  Form30.Close;
end;


end.
