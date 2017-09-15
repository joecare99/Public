unit frm_EditWitness;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, Buttons, Spin, ExtCtrls, FMUtils, StrUtils;

type
  { TfrmEditWitness }

  TfrmEditWitness = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    edtIdEvent: TSpinEdit;
    edtIdInd: TSpinEdit;
    chbPrefered: TCheckBox;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    lblWitness: TLabel;
    lblRole: TLabel;
    lblPhrase: TLabel;
    lblResult: TLabel;
    lblDefault: TLabel;
    edtWitnessNo: TSpinEdit;
    edtName: TEdit;
    P: TMemo;
    P1: TMemo;
    P2: TMemo;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    cbxRole: TComboBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtIdIndEditingDone(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure PEditingDone(Sender: TObject);
    procedure cbxRoleChange(Sender: TObject);
  private
    function GetidEvent: integer;
    function GetidWitness: integer;
    procedure SetidEvent(AValue: integer);
    procedure SetidWitness(AValue: integer);
    { private declarations }
  public
    { public declarations }
    property idEvent: integer read GetidEvent write SetidEvent;
    property idWitness: integer read GetidWitness write SetidWitness;
  end;

var
  frmEditWitness: TfrmEditWitness;

implementation

uses frm_EditEvents, frm_Main, dm_GenData, cls_Translation, frm_Explorer;

procedure GetWitnessData(const lidWitness: integer;
   out lidInd: LongInt; out lName: String;  out lidEvent: LongInt;
   out lPhrase: String;
  out lRole: String; out lPrefered: Boolean );

begin
  with dmGenData.Query1 do begin
    SQL.Text :=
         'SELECT W.no, W.I, W.E, W.X, W.P, W.R, N.N FROM W JOIN N ON W.I=N.I WHERE N.X=1 AND W.no=:idWitness';
       ParamByName('idWitness').AsInteger := lidWitness;
       Open;
       First;

       lRole:=Fields[5].AsString;
       lidInd:=Fields[1].AsInteger;
       lPrefered:=Fields[3].AsBoolean;
       lidEvent:=Fields[2].AsInteger;
       lName:=Fields[6].AsString;
       lPhrase:=Fields[4].AsString;
       Close;
  end;
end;

procedure FillResourceList(const items: TStrings; const lidType: PtrInt);
var
  temp: string;
begin
  with dmGenData.Query1 do
   begin
    SQL.Text := 'SELECT Y.R FROM Y WHERE Y.no=:idType';
    ParamByName('idType').AsInteger := lidType;
    Open;
    First;
    Items.Clear;
    temp := Fields[0].AsString;
    while AnsiPos('|', temp) > 0 do
     begin
      Items.Add(Copy(temp, 1, AnsiPos('|', temp) - 1));
      temp := Copy(temp, AnsiPos('|', temp) + 1, length(temp));
     end;
    Items.Add(Copy(temp, 1, length(temp)));
   end;
end;

{$R *.lfm}

{ TfrmEditWitness }

procedure TfrmEditWitness.PEditingDone(Sender: TObject);
begin
  if length(P.Text) = 0 then
    P.Text := P1.Text;
  lblDefault.Visible := (P.Text = P1.Text);
  P2.Text := DecodePhrase(edtIdInd.Value, cbxRole.Items[cbxRole.ItemIndex],
    P.Text, 'E', edtIdEvent.Value);
  frmStemmaMainForm.AppendHistoryData('P', P.Text);
end;

procedure TfrmEditWitness.cbxRoleChange(Sender: TObject);
begin
  P2.Text := DecodePhrase(edtIdInd.Value, cbxRole.Text, P.Text, 'E', edtIdEvent.Value);
end;

function TfrmEditWitness.GetidEvent: integer;
begin
  Result := edtIdEvent.Value;
end;

function TfrmEditWitness.GetidWitness: integer;
begin
  Result := edtWitnessNo.Value;
end;

procedure TfrmEditWitness.SetidEvent(AValue: integer);
begin
  if edtIdEvent.Value = AValue then
    Exit;
  edtIdEvent.Value := AValue;
end;

procedure TfrmEditWitness.SetidWitness(AValue: integer);
begin
  if edtWitnessNo.Value = AValue then
    Exit;
  edtWitnessNo.Value := AValue;
end;

procedure TfrmEditWitness.FormShow(Sender: TObject);
var
  j, lidWitness: integer;
  lRole, lName, lPhrase: String;
  lidInd, lidEvent: LongInt;
  lPrefered: Boolean;
  //  code, nocode:string;
begin
  ActiveControl := edtIdInd;
  frmStemmaMainForm.SetHistoryToActual(Sender);
  Caption := Translation.Items[195];
  btnOK.Caption := Translation.Items[152];
  btnCancel.Caption := Translation.Items[164];
  lblWitness.Caption := Translation.Items[196];
  lblRole.Caption := Translation.Items[197];
  lblPhrase.Caption := Translation.Items[172];
  lblResult.Caption := Translation.Items[198];
  lblDefault.Caption := Translation.Items[173];
  // Populate le ComboBox
  FillResourceList(cbxRole.Items, ptrint(
    frmEditEvents.Y.Items.Objects[frmEditEvents.Y.ItemIndex]));
  // Populate la form
  // dmGenData.GetCode(code,nocode);
  if edtWitnessNo.Value = 0 then
   begin
    Caption := Translation.Items[48];
    edtIdInd.Value := -1;
    edtName.Text := '';
    edtWitnessNo.Value := 0;
    //     edtIdEvent.Value:=strtoint(nocode);
    chbPrefered.Checked := true;
    cbxRole.ItemIndex := 0;
    P.Text := '';
    lblDefault.Visible := True;
   end
  else
   begin

    lidWitness:=edtWitnessNo.Value;
    GetWitnessData(lidWitness,  lidInd,lName, lidEvent,lPhrase, lRole,
     lPrefered );
    for j := 0 to cbxRole.Items.Count - 1 do
      if cbxRole.Items[j] = lRole then
        cbxRole.ItemIndex := j;
    //     edtWitnessNo.Value:=dmGenData.Query1.Fields[0].AsInteger;
    edtIdInd.Value := lidInd;
    chbPrefered.Checked := lPrefered;
    edtIdEvent.Value := lidEvent;
    edtName.Text := DecodeName(lName, 1);
    P.Text := lPhrase;
   end;
  // aller chercher la phrase par défaut
  dmGenData.Query1.SQL.Text := 'SELECT Y.P FROM Y JOIN E ON E.Y=Y.no WHERE E.no=' +
    edtIdEvent.Text;
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  P1.Text := dmGenData.Query1.Fields[0].AsString;
  if length(P.Text) = 0 then
   begin
    P.Text := P1.Text;
    lblDefault.Visible := True;
   end;
  P2.Text := DecodePhrase(edtIdInd.Value, cbxRole.Text, P.Text, 'E', edtIdEvent.Value);
end;

procedure TfrmEditWitness.btnOKClick(Sender: TObject);
var
  lidInd: integer;
  lDate, lEvType: string;

begin
  lidInd := edtIdInd.Value;


  dmGenData.Query1.SQL.Clear;
  if edtWitnessNo.Value = 0 then
   begin
    if lblDefault.Visible then
      edtWitnessNo.Value :=dmGenData.AppendWitness(cbxRole.Items[cbxRole.ItemIndex], '',
        lidInd, edtIdEvent.Value, true)
    else
      edtWitnessNo.Value :=dmGenData.AppendWitness(cbxRole.Items[cbxRole.ItemIndex], trim(
        p.Text), lidInd, edtIdEvent.Value, true);
   end
  else
   begin

    if lblDefault.Visible then
      dmGenData.Query1.SQL.Add('UPDATE W SET R=:Role''' + UTF8ToANSI(
        cbxRole.Items[cbxRole.ItemIndex]) + ''','' I=' + edtIdInd.Text +
        ', P='''' WHERE no=' + edtWitnessNo.Text)
    else
      dmGenData.Query1.SQL.Add('UPDATE W SET R=''' + UTF8ToANSI(
        cbxRole.Items[cbxRole.ItemIndex]) + ''', I=' + edtIdInd.Text +
        ', P=''' + AnsiReplaceStr(AnsiReplaceStr(
        AnsiReplaceStr(UTF8toANSI(trim(P.Text)), '\', '\\'), '"', '\"'), '''', '\''') +
        ''' WHERE no=' + edtWitnessNo.Text);
   end;
  // fr: Sauvegarder les modifications pour tout les témoins de l'événements
  // en: Save the changes for all the witnesses to the events
  dmGenData.Query3.SQL.Text := 'SELECT W.I FROM W WHERE W.E=' + edtIdEvent.Text;
  dmGenData.Query3.Open;
  dmGenData.Query3.First;
  while not dmGenData.Query3.EOF do
   begin
    dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
    dmGenData.Query3.Next;
   end;
  // fr: Modifier la ligne de l'explorateur si naissance frmStemmaMainForm ou décès principal
  // en: Change the line of Explorer if birth frmStemmaMainForm or main death
  dmGenData.Query1.SQL.Text :=
    'SELECT Y.Y, E.X, E.PD FROM Y JOIN E on E.Y=Y.no WHERE E.no=' + edtIdEvent.Text;
  dmGenData.Query1.Open;
  lDate := dmGenData.Query1.Fields[2].AsString;
  lEvType := dmGenData.Query1.Fields[0].AsString;

  if (lEvType = 'B') then
    dmGenData.UpdateNameI3(lDate, lidInd)
  else if (lEvType = 'D') then
    dmGenData.UpdateNameI4(lDate, lidInd);

  if frmStemmaMainForm.actWinExplorer.Checked and
    ((lEvType = 'B') or ((lEvType = 'D'))) and
    (dmGenData.Query1.Fields[1].AsInteger = 1) and (chbPrefered.Checked) then

    frmExplorer.UpdateIndexDates(lEvType, lDate, lidInd);

end;

procedure TfrmEditWitness.edtIdIndEditingDone(Sender: TObject);
begin
  if length(edtIdInd.Text) > 0 then
   begin
    dmGenData.Query1.SQL.Text := 'SELECT N.N FROM N WHERE N.X=1 AND N.I=' + edtIdInd.Text;
    dmGenData.Query1.Open;
    dmGenData.Query1.First;
    if not dmGenData.Query1.EOF then
     begin
      edtName.Text := DecodeName(dmGenData.Query1.Fields[0].AsString, 1);
      P2.Text := DecodePhrase(edtIdInd.Value, cbxRole.Text, P.Text, 'E', edtIdEvent.Value);
      frmStemmaMainForm.AppendHistoryData('I', edtIdInd.Value);
     end;
   end;
end;

procedure TfrmEditWitness.MenuItem1Click(Sender: TObject);
begin
  btnOKClick(Sender);
  ModalResult := mrOk;
end;

procedure TfrmEditWitness.MenuItem2Click(Sender: TObject);
var
  liResult: integer;
  lsResult: string;
begin
  if ActiveControl.Name = P.Name then
   begin
    lsResult := frmStemmaMainForm.RetreiveFromHistoy('P');
    if lsResult <> '' then
     begin
      P.Text := lsResult;
      PEditingDone(Sender);
     end;
   end
  else if ActiveControl.Name = edtIdInd.Name then
   begin
    liResult := frmStemmaMainForm.RetreiveFromHistoyID('I');
    if liResult > -1 then
     begin
      edtIdInd.Value := liResult;
      edtIdIndEditingDone(Sender);
     end;
   end;
end;

end.
