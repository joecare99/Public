unit fra_AWHejView;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, ComCtrls, DbCtrls, StdCtrls,
  DBGrids, ExtCtrls, DBExtCtrls, Menus, ActnList, DBActns, StdActns, Buttons,
  Grids, EditBtn, ButtonPanel, cls_HejData;

type

  { TfraAWHejView }

  TfraAWHejView = class(TFrame)
    actFileNew: TAction;
    actFilePrintSetup: TAction;
    actFilePrint: TAction;
    actFileSave1: TAction;
    actLoadGedcom: TAction;
    actSaveGedCom: TAction;
    Action6: TAction;
    Action7: TAction;
    ActionList1: TActionList;
    cbxAdopted: TComboBox;
    cbxBaptMod: TComboBox;
    cbxBaptMod1: TComboBox;
    cbxBirthMod: TComboBox;
    cbxBirthMod1: TComboBox;
    cbxBurMod: TComboBox;
    cbxBurMod1: TComboBox;
    cbxDeathMod: TComboBox;
    cbxDeathMod1: TComboBox;
    cbxReligion: TComboBox;
    cbxReligion1: TComboBox;
    cbxSex: TComboBox;
    cbxSex1: TComboBox;
    chbLiving: TCheckBox;
    actDataSetDelete1: TDataSetDelete;
    actDataSetFirst1: TDataSetFirst;
    actDataSetInsert1: TDataSetInsert;
    actDataSetLast1: TDataSetLast;
    actDataSetNext1: TDataSetNext;
    actDataSetPrior1: TDataSetPrior;
    chbLiving1: TCheckBox;
    cbxPlace: TComboBox;
    edtGodParents: TEdit;
    edtCauseOfDeath: TEdit;
    edtPhone: TEdit;
    edtEMail: TEdit;
    edtUrl: TEdit;
    edtStreet: TEdit;
    edtAdrSup: TEdit;
    edtZIP: TEdit;
    edtPlaceSup: TEdit;
    DBNavigator2: TPanel;
    edtBaptDate1: TDateEdit;
    edtBaptPlace1: TEdit;
    edtBirthDate1: TDateEdit;
    edtBirthPlace1: TEdit;
    edtBurDate1: TDateEdit;
    edtBurPlace1: TEdit;
    edtCallname: TEdit;
    edtDeathDate1: TDateEdit;
    edtDeathPlace1: TEdit;
    edtGivenname1: TEdit;
    edtName1: TEdit;
    edtNameVariants: TEdit;
    edtOccupation1: TEdit;
    edtResidence: TEdit;
    edtSource: TEdit;
    edtSource1: TEdit;
    edtSource2: TEdit;
    edtSource3: TEdit;
    edtSource4: TEdit;
    lblBaptised2: TLabel;
    lblBaptised3: TLabel;
    lblStreet: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    lblStreetBsp: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    lblID: TLabel;
    Panel2: TPanel;
    Shape10: TShape;
    Shape11: TShape;
    Shape9: TShape;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Splitter1: TSplitter;
    tblSelectPerson: TStringGrid;
    DBNavigator1: TPanel;
    edtAge: TEdit;
    edtBaptDate: TDateEdit;
    edtBaptPlace: TEdit;
    edtBirthDate: TDateEdit;
    edtBirthPlace: TEdit;
    edtBurDate: TDateEdit;
    edtBurPlace: TEdit;
    edtDeathDate: TDateEdit;
    edtDeathPlace: TEdit;
    mniOpenFile: TMenuItem;
    mniSaveFile: TMenuItem;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    tblSpouses: TStringGrid;
    tblChildren: TStringGrid;
    edtFarmname: TEdit;
    edtFather: TEdit;
    edtGivenname: TEdit;
    edtMother: TEdit;
    edtName: TEdit;
    edtOccupation: TEdit;
    CoolBar1: TCoolBar;
    DBComboBox1: TDBComboBox;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBMemo1: TDBMemo;
    actFileExit1: TFileExit;
    actFileOpen1: TFileOpen;
    actFileOpenWith1: TFileOpenWith;
    actFileSaveAs1: TFileSaveAs;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblNameVariants: TLabel;
    lblSource: TLabel;
    lblBaptised1: TLabel;
    lblBirth1: TLabel;
    lblBuried1: TLabel;
    lblConnection: TLabel;
    lblChildren: TLabel;
    lblBaptised: TLabel;
    lblDeath: TLabel;
    lblBuried: TLabel;
    lblDeath1: TLabel;
    lblResidence: TLabel;
    lblGivenname1: TLabel;
    lblMother: TLabel;
    lblName: TLabel;
    lblGivenname: TLabel;
    lblFarmname: TLabel;
    lblBirth: TLabel;
    lblFather: TLabel;
    lblName1: TLabel;
    lblOccupation1: TLabel;
    lblReligion1: TLabel;
    lblSex: TLabel;
    lblOccupation: TLabel;
    lblReligion: TLabel;
    lblAdopted: TLabel;
    lblSex1: TLabel;
    lblCallname: TLabel;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    mniDataexchangeFokoSave: TMenuItem;
    mniDatasetFirst: TMenuItem;
    mniDatasetPrior: TMenuItem;
    mniDatasetNext: TMenuItem;
    mniDatasetLast: TMenuItem;
    mniDatasetInsert: TMenuItem;
    mniDatasetDelete: TMenuItem;
    mniDatasetSep1: TMenuItem;
    mniDatasetSep2: TMenuItem;
    mniFile: TMenuItem;
    mniChecks: TMenuItem;
    mniFilter: TMenuItem;
    mniInfo: TMenuItem;
    mniBackup: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    mniDataexchangeSaveGedcom: TMenuItem;
    mniDataexchangeSep1: TMenuItem;
    mniFileExit: TMenuItem;
    mniFileSortMarrChild: TMenuItem;
    mniFileExport2Exl: TMenuItem;
    MenuItem15: TMenuItem;
    mniFileNew: TMenuItem;
    mniFilePrintSetup: TMenuItem;
    mniFileISisDSno: TMenuItem;
    mniFileDeleteIDs: TMenuItem;
    mniFilePrivacyOn: TMenuItem;
    mniFilePrivacyOff: TMenuItem;
    mniDataexchange: TMenuItem;
    mniFileSep1: TMenuItem;
    MenuItem21: TMenuItem;
    mniFilePrint: TMenuItem;
    MenuItem23: TMenuItem;
    mniDataset: TMenuItem;
    mniSearch: TMenuItem;
    mniLists: TMenuItem;
    mniAncestors: TMenuItem;
    mniDescendens: TMenuItem;
    mniCalender: TMenuItem;
    mniImages: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    pnlP3BaseData: TPanel;
    pnlP2TopClient: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    pnlP3Top: TPanel;
    Panel18: TPanel;
    pnlP2Top: TPanel;
    pnlP2Bottom: TPanel;
    pnlP2BottomLeft: TPanel;
    pnlP2BottomClient: TPanel;
    pnlP2BaseData: TPanel;
    pnlP2Image: TPanel;
    pnlP2VitalData: TPanel;
    pnlP2TopRight: TPanel;
    pnlP3VitalData: TPanel;
    SearchFind1: TSearchFind;
    SearchFindFirst1: TSearchFindFirst;
    SearchFindNext1: TSearchFindNext;
    SearchReplace1: TSearchReplace;
    StatusBar1: TStatusBar;
    tbs8Bilder: TTabSheet;
    tbs7Address: TTabSheet;
    tbs6Text: TTabSheet;
    tbs5Siblings: TTabSheet;
    tbs4Marriages: TTabSheet;
    tbs3Details: TTabSheet;
    tbs2Edit: TTabSheet;
    tbs1Select: TTabSheet;
    tlbMenu: TToolBar;
    UpDown1: TUpDown;
    procedure actDataSetFirst1Execute(Sender: TObject);
    procedure actDataSetLast1Execute(Sender: TObject);
    procedure actDataSetNext1Execute(Sender: TObject);
    procedure actDataSetPrior1Execute(Sender: TObject);
    procedure actFileOpen1Accept(Sender: TObject);
    procedure lblFatherClick(Sender: TObject);
    procedure mniOpenFileClick(Sender: TObject);
    procedure mniFilePrivacyOnClick(Sender: TObject);
    procedure mniFileClick(Sender: TObject);
  private
    FMenuPopUp:TPopupMenu;
    procedure AfterConstruction; override;
    procedure GenOnDataChange(Sender: TObject);
    procedure GenOnUpdate(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);
    procedure MenuButtonMEnter(Sender: TObject);
  private
     FGenealogy:TClsHejGenealogy;
     procedure SetGenealogy(AValue: TClsHejGenealogy);
  public
     Property Genealogy:TClsHejGenealogy read FGenealogy write SetGenealogy;
  public

  end;

implementation

uses cls_HejIndData;
{$R *.lfm}

{ TfraAWHejView }

procedure TfraAWHejView.mniFileClick(Sender: TObject);
begin

end;

procedure TfraAWHejView.AfterConstruction;
var
  XX, i: Integer;
  newBtn: TSpeedButton;
begin
  inherited AfterConstruction;
  XX:= 0;
  FMenuPopUp:=TPopupMenu.Create(self);
  FMenuPopUp.Parent := self;
  FMenuPopUp.Images := MainMenu1.Images;
  for i := 0 to MainMenu1.Items.Count-1 do
    begin
      newBtn := TSpeedButton.Create(self);
      newBtn.Parent := tlbMenu;
      newBtn.AutoSize:=true;
      newBtn.Name:='btn'+MainMenu1.Items[i].Name;
      if assigned(MainMenu1.Items[i].Action) then
        Newbtn.Action:= MainMenu1.Items[i].Action
      else
        begin
//          newbtn.Glyph := MainMenu1.Items[i].i
        end;
      Newbtn.OnClick:=MenuButtonClick;
      NewBtn.OnMouseEnter:=MenuButtonMEnter;
      newbtn.Caption:=' '+MainMenu1.Items[i].Caption+' ';
      newbtn.Tag:=i;
      newbtn.Flat:=true;
      newbtn.Top := 0;
      newbtn.left := xx;
      newbtn.Font.Height:=(tlbMenu.Height * 7)div 10;
      xx := xx + newbtn.Width+newbtn.Font.Height;
    end;

end;

procedure TfraAWHejView.GenOnDataChange(Sender: TObject);
var
  i,lNum: Integer;
  lDText:string;
begin
  for i := 0 to ComponentCount -1 do
    if (Components[i].Tag >98)   then
       begin
         if Components[i].InheritsFrom(TCustomEdit) then
           TCustomEdit(Components[i]).Text :=
             FGenealogy.GetData(-1,TEnumHejIndDatafields(Components[i].Tag-100));
         if Components[i].InheritsFrom(TCheckBox) then
           TCheckBox(Components[i]).Checked :=
             FGenealogy.GetData(-1,TEnumHejIndDatafields(Components[i].Tag-100))='y';
         if Components[i].InheritsFrom(TCustomComboBox) then
           begin
             TCustomComboBox(Components[i]).Text :=
                FGenealogy.GetData(-1,TEnumHejIndDatafields(Components[i].Tag-100));
             if (TCustomComboBox(Components[i]).ItemIndex=-1) and
                (copy(TCustomComboBox(Components[i]).text+' ',1,1)[1] in ['0'..'9'] ) then
                 TCustomComboBox(Components[i]).text := '';
           end;
         if Components[i].InheritsFrom(TDateEdit) then
             TDateEdit(Components[i]).Text :=
                FGenealogy.ActualInd.GetDateData(TEnumHejIndDatafields(Components[i].Tag-100));
       end;
end;

procedure TfraAWHejView.GenOnUpdate(Sender: TObject);
var
  lActDS, i: Integer;
begin
  lActDS:= FGenealogy.GetActID;
  if tblSelectPerson.RowCount <> FGenealogy.Count+1 then
    begin
      //Todo: Update Select-Grid
      tblSelectPerson.RowCount := FGenealogy.Count+1
    end;
  tblSelectPerson.Row:=lactDS ;
  edtFather.text := FGenealogy.Father.ToString;
  edtMother.text := FGenealogy.Mother.ToString;
  tblSpouses.RowCount:=FGenealogy.SpouseCount+1;
  for i := 0 to FGenealogy.SpouseCount-1 do
    begin
      tblSpouses.Cells[0,i+1]:= inttostr(i+1);
      tblSpouses.Cells[1,i+1]:= FGenealogy.Spouse[i].ToString;
      tblSpouses.Cells[2,i+1]:= FGenealogy.MarriageData[i].ToString;
    end;
  tblChildren.RowCount:=FGenealogy.ChildCount+1;
  for i := 0 to FGenealogy.ChildCount-1 do
    begin
      tblChildren.Cells[0,i+1]:= inttostr(i+1);
      tblChildren.Cells[1,i+1]:= FGenealogy.Child[i].ToString;
    end;
  lblID.Caption:=inttostr(lActDS);
  GenOnDataChange(Sender);
end;

procedure TfraAWHejView.MenuButtonClick(Sender: TObject);
var
  i: integer;
  lMni, lSmi: TMenuItem;
  p: TPoint;
begin
  if sender.InheritsFrom(TControl) then
  begin
    //Sdr:=TCustomButton(sender)
    FMenuPopUp.Items.Clear;
    lMni:= MainMenu1.Items[TControl(sender).tag];
    for i := 0 to  lMni.Count-1 do
      begin
      lSmi:=TMenuItem.Create(FMenuPopUp);
      lSmi.Action:=lmni[i].Action;
      if not assigned(Action) then
        begin
          lsmi.OnClick:=lmni[i].OnClick;
           lsmi.Checked:=lmni[i].Checked;
           lsmi.Enabled:=lmni[i].Enabled;
           lsmi.ShortCut:=lmni[i].ShortCut;
           lsmi.hint:=lmni[i].hint;
        end;
      lsmi.tag:=lmni[i].tag;
      lsmi.RadioItem:=lmni[i].RadioItem;
      lsmi.Caption:=lmni[i].Caption;
      FMenuPopUp.Items.Add(lSmi);
      end;
    p:=TControl(sender).ClientToScreen(Point(0,TControl(sender).height));
    FMenuPopUp.PopUp( p.x,p.y);
  end
end;

procedure TfraAWHejView.MenuButtonMEnter(Sender: TObject);
begin
  if sender.InheritsFrom(TControl) then
  begin
    if assigned( FMenuPopUp.PopupComponent) and TControl(FMenuPopUp.PopupComponent).Visible then
      MenuButtonClick(sender);
  end;
end;

procedure TfraAWHejView.SetGenealogy(AValue: TClsHejGenealogy);
begin
  if FGenealogy=AValue then Exit;
  FGenealogy:=AValue;
  if assigned(FGenealogy) then
   begin
     FGenealogy.OnUpdate:=GenOnUpdate;
     FGenealogy.OnDataChange:=GenOnDataChange;
   end;
end;

procedure TfraAWHejView.mniFilePrivacyOnClick(Sender: TObject);
begin

end;

procedure TfraAWHejView.lblFatherClick(Sender: TObject);
begin

end;

procedure TfraAWHejView.actFileOpen1Accept(Sender: TObject);
begin

end;

procedure TfraAWHejView.actDataSetFirst1Execute(Sender: TObject);
begin
  FGenealogy.First(sender);
end;

procedure TfraAWHejView.actDataSetLast1Execute(Sender: TObject);
begin
    FGenealogy.Last(sender);
end;

procedure TfraAWHejView.actDataSetNext1Execute(Sender: TObject);
begin
    FGenealogy.Next(sender);
end;

procedure TfraAWHejView.actDataSetPrior1Execute(Sender: TObject);
begin
    FGenealogy.Previous(sender);
end;

procedure TfraAWHejView.mniOpenFileClick(Sender: TObject);
begin

end;

end.

