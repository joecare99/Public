unit frm_EditWitness;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, Buttons, Spin, ExtCtrls, FMUtils;

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
  j, lidWitness, lidEvent: integer;
  lRole, lName, lPhrase: String;
  lidInd: LongInt;
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
  dmGenData.FillTypeRolesList(cbxRole.Items, ptrint(
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
    lidEvent:=0;
    P.Text := '';
    lblDefault.Visible := True;
   end
  else
   begin

    lidWitness:=edtWitnessNo.Value;
    dmGenData.GetWitnessData(lidWitness,  lidInd,lName, lidEvent,lPhrase, lRole,
     lPrefered );
    for j := 0 to cbxRole.Items.Count - 1 do
      if cbxRole.Items[j] = lRole then
        cbxRole.ItemIndex := j;
    //     edtWitnessNo.Value:=Query1.Fields[0].AsInteger;
    edtIdInd.Value := lidInd;
    chbPrefered.Checked := lPrefered;
    edtIdEvent.Value := lidEvent;
    edtName.Text := DecodeName(lName, 1);
    P.Text := lPhrase;
   end;
  // aller chercher la phrase par défaut

  P1.Text:=dmGenData.GetEventDefaultPhrase(lidEvent);
  if length(P.Text) = 0 then
   begin
    P.Text := P1.Text;
    lblDefault.Visible := True;
   end;
  P2.Text := DecodePhrase(edtIdInd.Value, cbxRole.Text, P.Text, 'E', edtIdEvent.Value);
end;

procedure TfrmEditWitness.btnOKClick(Sender: TObject);
var
  lidInd, lidWitness: integer;
  lDate, lEvType, lPhrase, lRole: string;
  lPrefered: boolean;

begin
  lidInd := edtIdInd.Value;
  if lblDefault.Visible then
    lPhrase:=''
  else
    lPhrase:=trim(P.Text);
  lidWitness:=edtWitnessNo.Value;
  lRole:=cbxRole.Items[cbxRole.ItemIndex];

  if lidWitness = 0 then
      edtWitnessNo.Value :=dmGenData.AppendWitness(lRole, lPhrase, lidInd,
      edtIdEvent.Value, true)
  else
     dmGenData.UpdateWitnessData(lidWitness, lidInd, lRole, lPhrase);
  // fr: Sauvegarder les modifications pour tout les témoins de l'événements
  // en: Save the changes for all the witnesses to the events
  dmGenData.UpdateIndModificationTimesByEvent(edtIdEvent.Value);
  // fr: Modifier la ligne de l'explorateur si naissance frmStemmaMainForm ou décès principal
  // en: Change the line of Explorer if birth frmStemmaMainForm or main death
  dmGenData.GetEventExtData(edtIdEvent.Value,lEvType,lDate,lPrefered);

  if (lEvType = 'B') then
    dmGenData.UpdateNameI3(lDate, lidInd)
  else if (lEvType = 'D') then
    dmGenData.UpdateNameI4(lDate, lidInd);

  if frmStemmaMainForm.actWinExplorer.Checked and
    ((lEvType = 'B') or ((lEvType = 'D'))) and
    (lPrefered) and (chbPrefered.Checked) then

    frmExplorer.UpdateIndexDates(lEvType, lDate, lidInd);

end;

procedure TfrmEditWitness.edtIdIndEditingDone(Sender: TObject);
begin
  if edtIdInd.Value > 0 then
   begin
      edtName.Text := DecodeName(dmGenData.GetIndividuumName(edtIdInd.Value), 1);
      P2.Text := DecodePhrase(edtIdInd.Value, cbxRole.Text, P.Text, 'E', edtIdEvent.Value);
      frmStemmaMainForm.AppendHistoryData('I', edtIdInd.Value);
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
