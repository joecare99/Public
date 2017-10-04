unit frm_EditName;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, Menus, fra_Citations, fra_Phrase, fra_Date, fra_Memo,
  FMUtils, LCLType, Spin,
  Buttons, ExtCtrls, ComboEx, ActnList;

type
  TEnumNameEditMode = (
    eNET_EditExisting,
    eNET_NewUnrelated,
    eNET_NameVariation,
    eNET_AddFather,
    eNET_AddMother,
    eNET_AddSpouse,
    eNET_AddBrother,
    eNET_AddSister,
    eNET_AddSon,
    eNET_AddDaughter);

  TEnumNameEntry=
  (ene_Title = 1,
   ene_GivenName = 2,
   ene_Surname = 3,
   ene_Suffix = 4,
   ene_AKA = 5);

   { TfrmEditName }

  TfrmEditName = class(TForm)
    ActionList1: TActionList;
    edtPrefered: TCheckBox;
    edtPrefered2: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    cbxSex: TComboBoxEx;
    edtName: TEdit;
    fraDate1: TfraDate;
    fraEdtCitations1: TfraEdtCitations;
    fraMemo1: TfraMemo;
    fraPhrase1: TfraPhrase;
    edtIdInd: TSpinEdit;
    imglSex: TImageList;
    lblIndividuum: TLabel;
    lblName8: TLabel;
    lblType: TLabel;
    mnuNameMain: TMainMenu;
    mnuNameAddTitle: TMenuItem;
    mniNameCitationAdd: TMenuItem;
    mniNameCitationEdit: TMenuItem;
    mniNameCitationDelete: TMenuItem;
    mniNameSurnameAdd: TMenuItem;
    mniNameTitleAdd: TMenuItem;
    mniNameGivenNameAdd: TMenuItem;
    mniNameAddFirstname: TMenuItem;
    mniNameAddSurname: TMenuItem;
    mniNameAddSuffix: TMenuItem;
    mniNameQuit: TMenuItem;
    mniNameRepeat: TMenuItem;
    mniName: TMenuItem;
    mniNameSuffixAdd: TMenuItem;
    mniNameCitations: TMenuItem;
    edtIdName: TSpinEdit;
    pnlNameTop: TPanel;
    pnlBottom: TPanel;
    SpeedButton1: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    PopupMenuNom: TPopupMenu;
    tblNames: TStringGrid;
    cbxEvType: TComboBox;
    procedure btnOKClick(Sender: TObject);
    procedure edtNameEditingDone(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtIdIndEditingDone(Sender: TObject);
    procedure mnuNameAddTitleClick(Sender: TObject);
    procedure mniNameAddFirstnameClick(Sender: TObject);
    procedure mniNameAddSurnameClick(Sender: TObject);
    procedure mniNameAddSuffixClick(Sender: TObject);
    procedure mniNameQuitClick(Sender: TObject);
    procedure mniNameRepeatClick(Sender: TObject);
    procedure NomSaveData(Sender: TObject);
    procedure cbxEvTypeChange(Sender: TObject);
    procedure tblNamesEditingDone(Sender: TObject);
  private
    class var FNameEntryTitle: array[ene_Title..ene_AKA] of ^String;
  private
    FEditMode: TEnumNameEditMode;
    FRelID: integer;
    procedure DecodeFullName(sFullName: string;
      out sSuffix, sFamilyName, sGivenName, sTitle: string);
    procedure FillNameTable(const suffixe: string; const nom: string;
      const prenom: string; const titre: string; const AKA: string='');
    function GetIdInd: integer;
    function GetIdName: integer;
    function GetIndName: string;
    function GetNameEntry(idx: TEnumNameEntry): string;
    procedure SetEditMode(AValue: TEnumNameEditMode);
    procedure SetIdInd(AValue: integer);
    procedure SetIdName(AValue: integer);
    procedure SetIndName(AValue: string);
    procedure SetNameEntry(idx: TEnumNameEntry; AValue: string);
    procedure NameGoto(idx: TEnumNameEntry);
    procedure SetRelID(AValue: integer);
    { private declarations }
  public
    { public declarations }
    property EditMode: TEnumNameEditMode read FEditMode write SetEditMode;
    property IndName: string read GetIndName write SetIndName;
    property RelID: integer read FRelID write SetRelID;
    property idInd: integer read GetIdInd write SetIdInd;
    property IdName: integer read GetIdName write SetIdName;
    property NameEntry[idx:TEnumNameEntry]:string read GetNameEntry write SetNameEntry;
  end;

var
  frmEditName: TfrmEditName;

implementation

uses
  frm_Main, cls_Translation, dm_GenData, frm_Explorer;

{ TFrmEditName }

procedure TfrmEditName.FillNameTable(const suffixe: string; const nom: string;
  const prenom: string; const titre: string; const AKA: string='');

begin
      tblNames.RowCount := 1; // Clear entries
      if length(titre) > 0 then
        NameEntry[ene_Title]:=titre;
      if length(prenom) > 0 then
       NameEntry[ene_GivenName]:= prenom;
      if length(nom) > 0 then
        NameEntry[ene_Surname]:= nom;
      if length(suffixe) > 0 then
        NameEntry[ene_Suffix]:= Suffixe;
      if length(AKA) > 0 then
        NameEntry[ene_AKA]:= aka;

end;

procedure TfrmEditName.DecodeFullName(sFullName: string;
  out sSuffix, sFamilyName, sGivenName, sTitle: string);
var
  Pos2: integer;
  Pos1: integer;
begin
  sSuffix := '';
  sFamilyName := '';
  sGivenName := '';
  sTitle := '';
  if copy(sFullName, 1, 5) = '!TMG|' then
   begin
    sFullName := copy(sFullName, 6, length(sFullName));
    sFamilyName := trim(copy(sFullName, 1, AnsiPos('|', sFullName) - 1));
    sFullName := copy(sFullName, AnsiPos('|', sFullName) + 1, length(sFullName));
    sTitle := trim(copy(sFullName, 1, AnsiPos('|', sFullName) - 1));
    sFullName := copy(sFullName, AnsiPos('|', sFullName) + 1, length(sFullName));
    sGivenName := trim(copy(sFullName, 1, AnsiPos('|', sFullName) - 1));
    sFullName := copy(sFullName, AnsiPos('|', sFullName) + 1, length(sFullName));
    sSuffix := trim(copy(sFullName, 1, AnsiPos('|', sFullName) - 1));
   end
  else
   begin
    // Traiter les noms avec <N=sTitle></N>...
    Pos1 := AnsiPos('<' + CTagNameTitle + '>', sFullName) +
      length(CTagNameTitle) + 2;
    Pos2 := AnsiPos('</' + CTagNameTitle + '>', sFullName);
    if (Pos1 + Pos2) > length(CTagNameTitle) + 2 then
      sTitle := Copy(sFullName, Pos1, Pos2 - Pos1);
    Pos1 := AnsiPos('<' + CTagNameGivenName + '>', sFullName) +
      length(CTagNameGivenName) + 2;
    // 9 car le 'é' prends 2 position en ANSI
    Pos2 := AnsiPos('</' + CTagNameGivenName + '>', sFullName);
    if (Pos1 + Pos2) > length(CTagNameGivenName) + 2 then
      sGivenName := Copy(sFullName, Pos1, Pos2 - Pos1);
    Pos1 := AnsiPos('<' + CTagNameFamilyName + '>', sFullName) +
      length(CTagNameFamilyName) + 2;
    Pos2 := AnsiPos('</' + CTagNameFamilyName + '>', sFullName);
    if (Pos1 + Pos2) > length(CTagNameFamilyName) + 2 then
      sFamilyName := Copy(sFullName, Pos1, Pos2 - Pos1);
    Pos1 := AnsiPos('<' + CTagNameSuffix + '>', sFullName) +
      length(CTagNameSuffix) + 2;
    Pos2 := AnsiPos('</' + CTagNameSuffix + '>', sFullName);
    if (Pos1 + Pos2) > length(CTagNameSuffix) + 2 then
      sSuffix := Copy(sFullName, Pos1, Pos2 - Pos1);
   end;
end;

{$R *.lfm}

{ TfrmEditName }

procedure TfrmEditName.cbxEvTypeChange(Sender: TObject);
begin
  fraPhrase1.TypePhrase := dmGenData.GetTypePhrase(
    PtrInt(cbxEvType.Items.Objects[cbxEvType.ItemIndex]));
  // Todo: Update fraPhrase1 Data
  if fraPhrase1.isDefault then
   begin
    fraPhrase1.WType := 'PRINCIPAL';
    fraPhrase1.idLink := edtIdName.Value;

    fraPhrase1.FullPhrase :=
      DecodePhrase(frmStemmaMainForm.iID, fraPhrase1.WType,
      fraPhrase1.TypePhrase, 'N', edtIdName.Value);
   end
  else
    fraPhrase1.isDefault := (fraPhrase1.Text = fraPhrase1.edtPhrase.Text);
end;

procedure TfrmEditName.tblNamesEditingDone(Sender: TObject);
begin

end;

procedure TfrmEditName.SetEditMode(AValue: TEnumNameEditMode);
begin
  if FEditMode = AValue then
    Exit;
  FEditMode := AValue;
  if FEditMode = eNET_NewUnrelated then
    edtName.Text := '';
end;

procedure TfrmEditName.SetIdInd(AValue: integer);
begin
  if AValue = edtIdInd.Value then
    exit;
  edtIdInd.Value := AValue;
end;

function TfrmEditName.GetIdName: integer;
begin
  Result := edtIdName.Value;
end;

function TfrmEditName.GetIndName: string;
begin
  Result := edtName.Text;
end;

function TfrmEditName.GetNameEntry(idx: TEnumNameEntry): string;
var
  lIdx: Integer;
begin
  lIdx:=tblNames.Cols[1].IndexOfObject(Tobject(ptrint(idx)));
  result := '';
  if lIdx>=0 then
    result := tblNames.Cells[2,lIdx];
end;

function TfrmEditName.GetIdInd: integer;
begin
  Result := edtIdInd.Value;
end;

procedure TfrmEditName.SetIdName(AValue: integer);
begin
  if edtIdName.Value = AValue then
    exit;
  edtIdName.Value := AValue;
end;

procedure TfrmEditName.SetIndName(AValue: string);
begin
  if uppercase(edtName.Text) = (AValue) then
    exit;
  edtName.Text := AValue;
end;

procedure TfrmEditName.SetNameEntry(idx: TEnumNameEntry; AValue: string);
var
  lIdx: Integer;
begin
  lIdx:=tblNames.Cols[1].IndexOfObject(Tobject(ptrint(idx)));
  if lIdx >= 0 then
    tblNames.Cells[2,lIdx] := AValue
  else
    begin
      tblNames.RowCount := tblNames.RowCount + 1;
      lIdx:=tblNames.RowCount-1;
      tblNames.Cells[1, lIdx] := FNameEntryTitle[idx]^;
      tblNames.Objects[1,lIdx] := TObject(ptrint(idx));
      tblNames.Cells[2, lIdx] := AValue;
    end;
end;

procedure TfrmEditName.NameGoto(idx: TEnumNameEntry);
var
  lIdx: Integer;
begin
  lIdx:=tblNames.Cols[1].IndexOfObject(Tobject(ptrint(idx)));
  if lIdx >= 0 then
    begin
      tblNames.Col:=2;
      tblNames.Row:= lIdx;
    end;
end;

procedure TfrmEditName.SetRelID(AValue: integer);
begin
  if FRelID = AValue then
    Exit;
  FRelID := AValue;
end;

procedure TfrmEditName.FormShow(Sender: TObject);
var
  titre, prenom, nom, suffixe, temp, lMemo, lSortDate, lDate, lPhrase: string;
  j, Pos1, Pos2: integer;
  lidInd, lidType: longint;
  lPref: boolean;
begin
  frmEditName.ActiveControl := tblNames;
  frmStemmaMainForm.SetHistoryToActual(Sender);
  Caption := Translation.Items[182];
  //  btnOK.Caption := Traduction.Items[152];
  //  btnCancel.Caption := Traduction.Items[164];
  lblType.Caption := Translation.Items[166];
  lblIndividuum.Caption := Translation.Items[183];
  //lblMemo.Caption := Translation.Items[171];
  //lblPhrase.Caption := Translation.Items[172];
  //lblDate.Caption := Translation.Items[144];
  //lblDefault.Caption := Translation.Items[173];
  lblName8.Caption := Translation.Items[184];
  //lblForPresentation.Caption := Translation.Items[168];
  //lblForSorting.Caption := Translation.Items[169];
  tblNames.RowCount := 1;
  //  tblNames.Columns.c:=3;
  tblNames.Columns[0].Title.Caption := Translation.Items[185];
  tblNames.Columns[1].title.Caption := Translation.Items[155];
  fraEdtCitations1.Clear;
  fraEdtCitations1.CType := 'N';
  fraPhrase1.TypeCode := 'N';
  fraEdtCitations1.OnSaveData := @NomSaveData;
  mnuNameAddTitle.Caption := Translation.Items[229];
  mniNameAddFirstname.Caption := Translation.Items[230];
  mniNameAddSurname.Caption := Translation.Items[231];
  mniNameAddSuffix.Caption := Translation.Items[232];
  mniNameCitations.Caption := Translation.Items[228];
  mniNameCitationAdd.Caption := Translation.Items[224];
  mniNameCitationEdit.Caption := Translation.Items[225];
  mniNameCitationDelete.Caption := Translation.Items[226];
  // Populate le ComboBox
  dmGenData.GetTypeList(cbxEvType.Items, 'N');

  tblNames.RowCount := 5;
  // Populate la form
  edtPrefered2.Text := '0';
  edtIdInd.Value := 0;

  case FEditMode of
    eNET_NameVariation:
     begin
      tblNames.RowCount := 1;
      edtIdInd.Value := frmStemmaMainForm.iID;
      if dmGenData.GetSexOfInd(IdInd) = 'M' then
        cbxSex.ItemIndex := 1
      else
        cbxSex.ItemIndex := 2;
     end;
    eNET_AddSpouse: //New unrelated
     begin
      tblNames.RowCount := 1;
      frmEditName.Caption :=
        Translation.Items[318] + dmGenData.GetIndividuumName(
        frmStemmaMainForm.iID);
      if dmGenData.GetSexOfInd(frmStemmaMainForm.iID) = 'M' then
        cbxSex.ItemIndex := 2
      else
        cbxSex.ItemIndex := 1;
      edtPrefered2.Text := '1';
     end;
    eNET_AddSon:  // fils
      // Ajouter NOM s'il y a lieu
     begin
      edtPrefered2.Text := '1';
      cbxSex.ItemIndex := 1;
      if dmGenData.GetSexOfInd(frmStemmaMainForm.iID) = 'M' then
       begin
        temp := dmGenData.GetIndividuumName(frmStemmaMainForm.iID);
        nom := '';
        if copy(temp, 1, 5) = '!TMG|' then
         begin
          temp := copy(temp, 6, length(temp));
          nom := trim(copy(temp, 1, AnsiPos('|', temp) - 1));
         end
        else
         begin
          // Traiter les noms avec <N=TITRE></N>...
          Pos1 := AnsiPos('<' + CTagNameFamilyName + '>', temp) + 5;
          Pos2 := AnsiPos('</' + CTagNameFamilyName + '>', temp);
          if (Pos1 + Pos2) > 5 then
            nom := Copy(temp, Pos1, Pos2 - Pos1);
         end;
        if length(nom) > 0 then
          NameEntry[ene_Surname]:= nom
        else
          tblNames.RowCount := 1;
       end
      else
        tblNames.RowCount := 1;
      frmEditName.Caption :=
        Translation.Items[315] + dmGenData.GetIndividuumName(
        frmStemmaMainForm.iID);
     end;
    eNET_AddDaughter: // fr: fille
      // en: daughter
      // Ajouter NOM s'il y a lieu }
     begin
      edtPrefered2.Text := '1';
      cbxSex.ItemIndex := 2;
      if dmGenData.GetSexOfInd(frmStemmaMainForm.iID) = 'M' then
       begin
        temp := dmGenData.GetIndividuumName(frmStemmaMainForm.iID);
        nom := '';
        if copy(temp, 1, 5) = '!TMG|' then
         begin
          temp := copy(temp, 6, length(temp));
          nom := trim(copy(temp, 1, AnsiPos('|', temp) - 1));
         end
        else
         begin
          // Traiter les noms avec <N=TITRE></N>...
          Pos1 := AnsiPos('<' + CTagNameFamilyName + '>', temp) +
            length(CTagNameFamilyName) + 2;
          Pos2 := AnsiPos('</' + CTagNameFamilyName + '>', temp);
          if (Pos1 + Pos2) > length(CTagNameFamilyName) + 2 then
            nom := Copy(temp, Pos1, Pos2 - Pos1);
         end;
        if length(nom) > 0 then
          NameEntry[ene_Surname]:= nom
        else
          tblNames.RowCount := 1;
       end
      else
        tblNames.RowCount := 1;
      frmEditName.Caption :=
        Translation.Items[316] + dmGenData.GetIndividuumName(
        frmStemmaMainForm.iID);
     end;
    eNET_AddBrother:  // fr: frère
      // en: Brother
      // Ajouter NOM }
     begin
      cbxSex.ItemIndex := 1;
      temp := dmGenData.GetIndividuumName(frmStemmaMainForm.iID);
      nom := '';
      if copy(temp, 1, 5) = '!TMG|' then
       begin
        temp := copy(temp, 6, length(temp));
        nom := trim(copy(temp, 1, AnsiPos('|', temp) - 1));
       end
      else
       begin
        // Traiter les noms avec <N=TITRE></N>...
        Pos1 := AnsiPos('<' + CTagNameFamilyName + '>', temp) +
          length(CTagNameFamilyName) + 2;
        Pos2 := AnsiPos('</' + CTagNameFamilyName + '>', temp);
        if (Pos1 + Pos2) > length(CTagNameFamilyName) + 2 then
          nom := Copy(temp, Pos1, Pos2 - Pos1);
       end;
      if length(nom) > 0 then
        NameEntry[ene_Surname]:= nom
      else
        tblNames.RowCount := 1;
      frmEditName.Caption :=
        Translation.Items[313] + dmGenData.GetIndividuumName(
        frmStemmaMainForm.iID);
     end;
    eNET_AddSister: // soeur
      // Ajouter NOM }
     begin
      cbxSex.ItemIndex := 2;
      temp := dmGenData.GetIndividuumName(frmStemmaMainForm.iID);
      nom := '';
      if copy(temp, 1, 5) = '!TMG|' then
       begin
        temp := copy(temp, 6, length(temp));
        nom := trim(copy(temp, 1, AnsiPos('|', temp) - 1));
       end
      else
       begin
        // Traiter les noms avec <N=TITRE></N>...
        Pos1 := AnsiPos('<' + CTagNameFamilyName + '>', temp) +
          length(CTagNameFamilyName) + 2;
        Pos2 := AnsiPos('</' + CTagNameFamilyName + '>', temp);
        if (Pos1 + Pos2) > length(CTagNameFamilyName) + 2 then
          nom := Copy(temp, Pos1, Pos2 - Pos1);
       end;
      if length(nom) > 0 then
        NameEntry[ene_Surname]:= nom
      else
        tblNames.RowCount := 1;
      frmEditName.Caption :=
        Translation.Items[337] + dmGenData.GetIndividuumName(
        frmStemmaMainForm.iID);
     end;
    eNET_AddFather:  // fr: Père
      // en: Father
      // Ajouter NOM }
     begin
      cbxSex.ItemIndex := 1;
      temp := dmGenData.GetIndividuumName(frmStemmaMainForm.iID);
      nom := '';
      if copy(temp, 1, 5) = '!TMG|' then
       begin
        temp := copy(temp, 6, length(temp));
        nom := trim(copy(temp, 1, AnsiPos('|', temp) - 1));
       end
      else
       begin
        // Traiter les noms avec <N=TITRE></N>...
        Pos1 := AnsiPos('<' + CTagNameFamilyName + '>', temp) +
          length(CTagNameFamilyName) + 2;
        Pos2 := AnsiPos('</' + CTagNameFamilyName + '>', temp);
        if (Pos1 + Pos2) > length(CTagNameFamilyName) + 2 then
          nom := Copy(temp, Pos1, Pos2 - Pos1);
       end;
      if length(nom) > 0 then
        NameEntry[ene_Surname]:= nom
      else
        tblNames.RowCount := 1;
      frmEditName.Caption :=
        Translation.Items[311] + dmGenData.GetIndividuumName(
        frmStemmaMainForm.iID);
     end;
    eNET_AddMother:  // Mère
     begin
      cbxSex.ItemIndex := 2;
      frmEditName.Caption :=
        Translation.Items[312] + dmGenData.GetIndividuumName(
        frmStemmaMainForm.iID);
      tblNames.RowCount := 1;
     end;
    eNET_NewUnrelated:  // Non-Relié
     begin
      cbxSex.ItemIndex := 0;
      frmEditName.Caption := Translation.Items[35];
      tblNames.RowCount := 1;
      edtPrefered.Checked := true;
     end;
      //        if length(frmEditName.Caption)=0 then
      //           begin
      //           frmEditName.Caption:=Traduction.Items[35];
      //           tblNames.RowCount:=1;
      //        end;
    else
     begin
      tblNames.RowCount := 1;
      frmEditName.Caption := Translation.Items[36];
      edtIdInd.Value := frmStemmaMainForm.iID;
      edtPrefered.Checked := false;
     end;

   end;
  edtIdInd.ReadOnly := True;
  btnOK.Enabled := True;
  if FEditMode <> eNET_EditExisting then
   begin
    fraEdtCitations1.Clear;
    edtIdName.Value := 0;
    fraMemo1.Text := '';
    fraPhrase1.Clear;
    fraPhrase1.isDefault := True;
    fraDate1.Clear;
    edtName.Caption := '';
    cbxEvType.ItemIndex := 0;
   end
  else
   begin
    //dmGenData.
    dmGenData.getNameData(edtIdName.Value, lidInd, lidType, temp,
      lMemo, lPhrase, lDate, lSortDate, lPref);
    edtIdInd.Value := lidInd;

    DecodeFullName(temp, suffixe, nom, prenom, titre);
    edtName.Caption := DecodeName(temp, 1);
    FillNameTable(suffixe, nom, prenom, titre);
    for j := 0 to cbxEvType.Items.Count - 1 do
      if PtrInt(cbxEvType.Items.Objects[j]) = lidType then
        cbxEvType.ItemIndex := j;
    case dmGenData.GetSexOfInd(edtIdInd.Value)[1] of
      'M': cbxSex.ItemIndex := 1;
      'F': cbxSex.ItemIndex := 2
      else
        cbxSex.ItemIndex := 0
     end;
    btnOK.Enabled := True;
    fraEdtCitations1.Enabled := True;
    fraMemo1.Text := lMemo;

    fraPhrase1.Text := lPhrase;
    fraPhrase1.TypePhrase :=
      dmGenData.GetTypePhrase(PtrInt(cbxEvType.Items.Objects[cbxEvType.ItemIndex]));
    if length(fraPhrase1.Text) = 0 then
     begin
      fraPhrase1.Text := fraPhrase1.TypePhrase;
      fraPhrase1.isDefault := True;
     end;
    fraPhrase1.FullPhrase :=
      DecodePhrase(frmStemmaMainForm.iID, 'PRINCIPAL', fraPhrase1.Text, 'N', edtIdName.Value);
    fraDate1.Date := lDate;
    fraDate1.SortDate := lSortDate;
    edtPrefered.Checked := lPref;
    // Populate le tableau de citations
    fraEdtCitations1.LinkID := edtIdName.Value;
   end;
end;

procedure TfrmEditName.edtIdIndEditingDone(Sender: TObject);
begin
  if StrToInt(edtIdInd.Text) > 0 then
   begin
    btnOK.Enabled := True;
    fraEdtCitations1.Enabled := True;
   end
  else
   begin
    btnOK.Enabled := False;
    fraEdtCitations1.Enabled := True;
   end;
  frmStemmaMainForm.AppendHistoryData('I', edtIdInd.Value);
end;

procedure TfrmEditName.NomSaveData(Sender: TObject);
var
  j: integer;
  parent1, parent2, no_eve, lidInd, lidName: longint;
  nom, i1, i2, i3, i4, temp, dateev, tagName, lSex, lMemoText, lPDate,
    lSDate, lPhrase, lPar2Name: string;
  exists: boolean;
  sSex: char;
  lidEvType: PtrInt;
  lPrefered: boolean;

begin
  nom := '';
  i3 := '';
  i4 := '';
  if tblNames.RowCount > 1 then
    for j := ord(ene_Title) to ord(ene_AKA)  do
      begin
       case TEnumNameEntry(J) of
         ene_Title:    tagName := CTagNameTitle;
        ene_SurName:   tagName := CTagNameFamilyName;
        ene_GivenName: tagName := CTagNameGivenName;
        ene_Suffix:    tagName := CTagNameSuffix;
        else           tagName := 'AKA';
        end;

        nom := nom + '<' + tagName + '>' + trim(NameEntry[TEnumNameEntry(J)]) +
          '</' + tagName + '>';
       end;

  i1 := RemoveUTF8(trim(NameEntry[ene_Surname]));
  i2 := RemoveUTF8(trim(NameEntry[ene_GivenName]));

  frmStemmaMainForm.AppendHistoryData('N', nom);

  lidName := edtIdName.Value;
  lidInd := edtIdInd.Value;

  if lidName = 0 then
   begin
    //    dmGenData.GetCode(code, temp);
    case frmEditName.cbxSex.ItemIndex of
      1: sSex := 'M';
      2: sSex := 'F'
      else
        sSex := '?'
     end;

    case frmEditName.EditMode of
      eNET_NewUnrelated:
       begin
        lidInd := dmGenData.AddNewIndividual(sSex, '?', 0);
        edtIdInd.Value := lidInd;
       end;
      eNET_AddFather, eNET_AddMother:
       begin
        lidInd := dmGenData.AddNewIndividual(sSex, '?', 0);
        edtIdInd.Value := lidInd;
        // Valide si principal...

        lSex := BoolToStr(frmEditName.EditMode = eNET_AddFather, 'M', 'F');
        temp := BoolToStr(dmgendata.CheckPrefParentExists(lSex, lidInd), '0', '1');

        dmGenData.RelationInsertData(10, frmStemmaMainForm.iId,
          lidInd, temp, '100000000300000000');
        // Demande si on veut unir les parents
        if (temp = '1') then
         begin
          if frmEditName.EditMode = eNET_AddMother then
            temp := 'M'
          else
            temp := 'F';
          // GetRelationOtherParent
          if dmgendata.GetRelationOtherParent(frmStemmaMainForm.iID,temp,parent2,lPar2Name) then
           begin
            parent1 := lidInd;
            // Vérifier qu'il n'cbxEvType a pas déjà une union entre ces deux parents
            exists:=dmgendata.GetEventMarriageExists(parent1, parent2);
            if not exists then
              // GetName(parent1) montre '???' car le nom n'a pas encore été enregistré, utiliser le nom dans 'nom'
              if Application.MessageBox(
                PChar(Translation.Items[300] + DecodeName(nom, 1) +
                Translation.Items[299] + DecodeName(
                lPar2Name, 1) +
                Translation.Items[28]), PChar(
                SConfirmation), MB_YESNO) = idYes then
               begin
                // Unir les parents
                // Ajouter l'événement mariage
                no_eve := dmGenData.SaveEventData(0,300,1,true);
                dmGenData.AppendWitness('CONJOINT','',parent1,no_eve,true);
                dmGenData.AppendWitness('CONJOINT','',parent2,no_eve,true);
                // Ajouter les témoins
                // Ajouter les références
                // noter que l'on doit ajouter les références (frmStemmaMainForm.Code.Text='edtPrefered')
                // sur l'événement # frmStemmaMainForm.no.Text
                //dmGenData.PutCode('X', no_eve);
                // Sauvegarder les modifications
                dmGenData.SaveModificationTime(parent1);
                dmGenData.SaveModificationTime(parent2);
                // UPDATE DÉCÈS si la date est il cbxEvType a 100 ans !!!
                if (copy(fraDate1.Date, 1, 1) = '1') and
                  not (fraDate1.Date = '100000000030000000000') then
                  dateev := Copy(frmEditName.fraDate1.Date, 2, 4)
                else
                if (copy(fraDate1.SortDate, 1, 1) = '1') and
                  not (fraDate1.SortDate =
                  '100000000030000000000') then
                  dateev := Copy(fraDate1.SortDate, 2, 4)
                else
                  dateev := FormatDateTime('YYYY', now);
                if ((StrToInt(FormatDateTime('YYYY', now)) -
                  StrToInt(dateev)) > 100) then
                 begin
                  dmGenData.UpdateIndLiving(parent1,'N',Sender);
                  dmGenData.UpdateIndLiving(parent2,'N',Sender);
                  dmGenData.NamesChanged(frmEditName);
                 end;
                dmGenData.EventChanged(frmEditName);
               end;
           end;
         end;
       end;
      eNET_AddSpouse:
       begin
        // Trouve le sexe de la personne actuelle dans nocode...
        lidInd := dmGenData.AddNewIndividual(sSex, '?', 0);
        edtIdInd.Value := lidInd;
        no_eve:=dmGenData.SaveEventData(0,300,1,true,'','100000000030000000000','100000000030000000000');
        // ajouter les citations du nom à l'événement
        dmGenData.AppendWitness('CONJOINT','', frmStemmaMainForm.iID,no_eve,true);
        dmGenData.AppendWitness('CONJOINT','', lidInd,no_eve,true);
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
       end;
      eNET_AddBrother, eNET_AddSister:
       begin
        lidInd := dmGenData.AddNewIndividual(sSex, '?', 0);
        dmGenData.CreateRelationParenttoChild(frmStemmaMainForm.iID,edtIdInd.Value);
       end;
      eNET_AddSon, eNET_AddDaughter:
       begin
        lidInd := dmGenData.AddNewIndividual(sSex, '?', 0);
        edtIdInd.Value := lidInd;
        RelID := dmGenData.SaveRelationData(0,'','100000000030000000000',10,true,lidInd,frmStemmaMainForm.iID,'');
        // ajouter les citations du nom à la relation

        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
        if idInd > 0 then
         begin
           dmGenData.SaveRelationData(0,'','100000000030000000000',10,true,lidInd,idind,'');
          // ajouter les citations du nom à la relation
          //   dmGenData.PutCode(code, dmGenData.GetLastIDOfTable('R'));
          dmGenData.SaveModificationTime(idInd);
         end;
       end
      else

     end; (*case *)
    i3 := dmGenData.GetI3(lidInd);
    i4 := dmGenData.GetI4(lidInd);
   end  (* if inttostr(lidName)='0' *)
  else
  if (edtPrefered.Checked) and ((frmStemmaMainForm.iID <> lidInd) and
    not (lidInd = 0) and not (edtPrefered2.Text = '1')) then
    edtPrefered.Checked := false// Si on déplace un nom primaire d'individu, le nom devient secondaire.
  ;
  lidEvType := PtrInt(cbxEvType.Items.Objects[cbxEvType.ItemIndex]);

  lMemoText:=trim(fraMemo1.Text);
  lPDate:=fraDate1.Date;
  lSDate:=fraDate1.SortDate;
  if fraPhrase1.isDefault then
    lPhrase:=''
  else
    lPhrase:=trim(fraPhrase1.Text);
  lPrefered:=edtPrefered.Checked;

  lidName :=dmgendata.SaveNameData(lidName, lPrefered, lidEvType, lPhrase, lSDate, lPDate, lMemoText,
    i4, i3, i2, i1, nom,  lidInd);

  // UPDATE DÉCÈS si la date est il cbxEvType a 100 ans !!!
  if (copy(frmEditName.fraDate1.Date, 1, 1) = '1') and not
    (frmEditName.fraDate1.Date = '100000000030000000000') then
    dateev := Copy(frmEditName.fraDate1.Date, 2, 4)
  else
  if (copy(fraDate1.SortDate, 1, 1) = '1') and not
    (fraDate1.SortDate = '100000000030000000000') then
    dateev := Copy(fraDate1.SortDate, 2, 4)
  else
    dateev := FormatDateTime('YYYY', now);
  if ((StrToInt(FormatDateTime('YYYY', now)) - StrToInt(dateev)) > 100) then
    dmGenData.UpdateIndLiving(lidInd, 'N', frmEditName);
  if not (edtIdInd.Value = frmStemmaMainForm.iID) then
    dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
  // Modifier la ligne de l'explorateur
  if frmStemmaMainForm.actWinExplorer.Checked then
    if lidName <> 0 then
      frmExplorer.UpdateIndex(i2, i1, nom, lidName, lidInd, j)
    else
      frmExplorer.AppendIndex(i2, i1, nom, lidName, lidInd,
        edtPrefered.Checked);
  if lidName = 0 then
    lidName := dmGenData.GetLastIDOfTable('N');
  edtIdName.Value := lidName;
end;

procedure TfrmEditName.btnOKClick(Sender: TObject);

var
  lSourceType, lDestType: string;
  lidSource, lidInd_Dest: integer;
begin
  if frmEditName.ActiveControl is TEdit and assigned(
    (frmEditName.ActiveControl as TEdit).OnEditingDone) then
    (frmEditName.ActiveControl as TEdit).OnEditingDone(frmEditName.ActiveControl);
  NomSaveData(Sender);
  case FEditMode of
    eNET_EditExisting, eNET_AddSpouse:
     begin
      lidSource := edtIdName.Value;
      lSourceType := 'N';
      lidInd_Dest := edtIdInd.Value;
      lDestType := 'E';
      dmGenData.CopyCitationOfIndByType(lidSource, lSourceType,
        lidInd_Dest, lDestType);
      //    dmGenData.GetCode(code, nocode);
     end;
    eNET_AddMother, eNET_AddFather, eNET_AddBrother, eNET_AddSister,
    eNET_AddSon, eNET_AddDaughter:
      //Father or Mother
     begin
      lidSource := edtIdName.Value;
      lSourceType := 'N';
      lidInd_Dest := edtIdInd.Value;
      lDestType := 'R';
      dmGenData.CopyCitationOfIndByType(lidSource, lSourceType,
        lidInd_Dest, lDestType);
     end;
   end;
end;

procedure TfrmEditName.edtNameEditingDone(Sender: TObject);
var
  lFullname, lSurname, lGivenname: String;
  pp: SizeInt;
begin

  lFullname:=edtName.text;
  pp:= pos(lFullname,',');
  if pp >0 then
    begin
      lSurname := copy(lFullname,1,pp-1);
      lGivenname :=trim(copy(lFullname,pp+1,length(lFullname)-pp))
    end
  else
    begin
      lSurname:=lFullname;
      lGivenname:='';
      pp := pos(lSurname,' ');
      while pp>0 do
        begin
          lGivenname:=trim(lGivenname+' '+copy(lSurname,1,pp-1));
          delete(lSurname,1,pp);
          pp := pos(lSurname,' ');
        end
    end;
    // ToDo: Find titles, Callname
  NameEntry[ene_Surname]:=lSurname;
  nameEntry[ene_GivenName]:=lGivenname;
end;

procedure TfrmEditName.mnuNameAddTitleClick(Sender: TObject);

begin
   // Ajouter Titre
   NameEntry[ene_Title]:= NameEntry[ene_Title];
   NameGoto(ene_title);
   frmEditName.ActiveControl := tblNames;
end;

procedure TfrmEditName.mniNameAddFirstnameClick(Sender: TObject);

begin
  // Ajouter Prénom
  NameEntry[ene_GivenName] := NameEntry[ene_GivenName];
  NameGoto(ene_GivenName);
  frmEditName.ActiveControl := tblNames;
end;

procedure TfrmEditName.mniNameAddSurnameClick(Sender: TObject);

begin
  NameEntry[ene_Surname] := NameEntry[ene_Surname];
  NameGoto(ene_Surname);
  frmEditName.ActiveControl := tblNames;
end;

procedure TfrmEditName.mniNameAddSuffixClick(Sender: TObject);

begin
  NameEntry[ene_Suffix] := NameEntry[ene_Suffix];
  NameGoto(ene_Suffix);
  frmEditName.ActiveControl := tblNames;
end;

procedure TfrmEditName.mniNameQuitClick(Sender: TObject);
begin
  btnOKClick(Sender);
  ModalResult := mrOk;
end;

procedure TfrmEditName.mniNameRepeatClick(Sender: TObject);
var
  liResult: integer;
  nom, titre, prenom, suffixe, lsResult: string;
begin
  if ActiveControl.Name = tblNames.Name then
   begin
    lsResult := frmStemmaMainForm.RetreiveFromHistoy('N');
    if lsResult <> '' then
     begin
      // Traitement de F3 pour les noms }
      DecodeFullName(lsResult, suffixe, nom, prenom, titre);
      FillNameTable(suffixe, nom, prenom, titre);
     end;
   end
  else if ActiveControl.Name = fraDate1.edtDateForSorting.Name then
   begin
    lsResult := frmStemmaMainForm.RetreiveFromHistoy('SD');
    if lsResult <> '' then
      fraDate1.SortDate := lsResult;
   end
  else if ActiveControl.Name = fraDate1.edtDateForPresentation.Name then
   begin
    lsResult := frmStemmaMainForm.RetreiveFromHistoy('PD');
    if lsResult <> '' then
      fraDate1.Date := lsResult;
   end
  else if ActiveControl.Name = edtIdInd.Name then
   begin
    liResult := frmStemmaMainForm.RetreiveFromHistoyID('I');
    if liResult > -1 then
     begin
      edtIdInd.Value := liResult;
      edtIdIndEditingDone(Sender);
     end;
   end
  else if ActiveControl.Name = fraPhrase1.edtPhrase.Name then
   begin
    lsResult := frmStemmaMainForm.RetreiveFromHistoy('P');
    if lsResult <> '' then
      fraPhrase1.Text := lsResult;
   end
  else if ActiveControl.Name = fraMemo1.edtMemoText.Name then
   begin
    lsResult := frmStemmaMainForm.RetreiveFromHistoy('M');
    if lsResult <> '' then
      fraMemo1.Text := lsResult;
   end;
end;

initialization
  TfrmEditName.FNameEntryTitle[ene_Title]:=@rsNameTitle;
  TfrmEditName.FNameEntryTitle[ene_GivenName]:=@rsNameGivenName;
  TfrmEditName.FNameEntryTitle[ene_Surname]:=@rsNameSurName;
  TfrmEditName.FNameEntryTitle[ene_Suffix]:=@rsNameSuffix;
  TfrmEditName.FNameEntryTitle[ene_AKA]:=@rsNameAKA;


end.
