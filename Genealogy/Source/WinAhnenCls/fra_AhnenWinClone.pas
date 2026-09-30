unit fra_AhnenWinClone;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, ComCtrls, DbCtrls, StdCtrls,
  DBGrids, ExtCtrls, DBExtCtrls, Menus, ActnList, DBActns, StdActns, Buttons;

type

  { TfraAhnenWinClone }

  TfraAhnenWinClone = class(TFrame)
    actFileNew: TAction;
    actFilePrintSetup: TAction;
    actFilePrint: TAction;
    actLoadGedcom: TAction;
    actSaveGedCom: TAction;
    Action6: TAction;
    Action7: TAction;
    ActionList1: TActionList;
    DataSetDelete1: TDataSetDelete;
    DataSetFirst1: TDataSetFirst;
    DataSetInsert1: TDataSetInsert;
    DataSetLast1: TDataSetLast;
    DataSetNext1: TDataSetNext;
    DataSetPrior1: TDataSetPrior;
    edtSource: TDBEdit;
    cbxBaptMod: TDBComboBox;
    cbxBaptMod1: TDBComboBox;
    cbxBirthMod1: TDBComboBox;
    cbxBurMod1: TDBComboBox;
    cbxDeathMod: TDBComboBox;
    cbxBurMod: TDBComboBox;
    cbxDeathMod1: TDBComboBox;
    cbxReligion1: TDBComboBox;
    cbxSex: TDBComboBox;
    cbxReligion: TDBComboBox;
    cbxAdopted: TDBComboBox;
    cbxSex1: TDBComboBox;
    chbLiving1: TDBCheckBox;
    CoolBar1: TCoolBar;
    DataSource1: TDataSource;
    chbLiving: TDBCheckBox;
    DBComboBox1: TDBComboBox;
    cbxBirthMod: TDBComboBox;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    edtAge: TDBEdit;
    edtBaptDate1: TDBDateEdit;
    edtBaptPlace1: TDBEdit;
    edtBirthDate1: TDBDateEdit;
    edtBirthPlace1: TDBEdit;
    edtBurDate1: TDBDateEdit;
    edtBurPlace1: TDBEdit;
    edtDeathDate: TDBDateEdit;
    edtBurDate: TDBDateEdit;
    edtDeathDate1: TDBDateEdit;
    edtDeathPlace: TDBEdit;
    edtBurPlace: TDBEdit;
    edtBirthDate: TDBDateEdit;
    edtBaptDate: TDBDateEdit;
    edtBaptPlace: TDBEdit;
    edtDeathPlace1: TDBEdit;
    edtResidence: TDBEdit;
    edtGivenname1: TDBEdit;
    edtMother: TDBEdit;
    edtName: TDBEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBMemo1: TDBMemo;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    edtGivenname: TDBEdit;
    edtFarmname: TDBEdit;
    edtBirthPlace: TDBEdit;
    edtFather: TDBEdit;
    edtName1: TDBEdit;
    edtOccupation: TDBEdit;
    edtOccupation1: TDBEdit;
    edtSource1: TDBEdit;
    edtSource2: TDBEdit;
    edtSource3: TDBEdit;
    edtSource4: TDBEdit;
    edtNameVariants: TDBEdit;
    edtCallname: TDBEdit;
    FileExit1: TFileExit;
    FileOpen1: TFileOpen;
    FileOpenWith1: TFileOpenWith;
    FileSaveAs1: TFileSaveAs;
    GroupBox1: TGroupBox;
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
    Panel11: TPanel;
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
    SpeedButton1: TSpeedButton;
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
    procedure mniFilePrivacyOnClick(Sender: TObject);
    procedure mniFileClick(Sender: TObject);
  private
    FMenuPopUp:TPopupMenu;
    procedure AfterConstruction; override;
    procedure MenuButtonClick(Sender: TObject);
    procedure MenuButtonMEnter(Sender: TObject);
  public

  end;

implementation

{$R *.lfm}

{ TfraAhnenWinClone }

procedure TfraAhnenWinClone.mniFileClick(Sender: TObject);
begin

end;

procedure TfraAhnenWinClone.AfterConstruction;
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

procedure TfraAhnenWinClone.MenuButtonClick(Sender: TObject);
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

procedure TfraAhnenWinClone.MenuButtonMEnter(Sender: TObject);
begin
  if sender.InheritsFrom(TControl) then
  begin
    if assigned( FMenuPopUp.PopupComponent) and TControl(FMenuPopUp.PopupComponent).Visible then
      MenuButtonClick(sender);
  end;
end;

procedure TfraAhnenWinClone.mniFilePrivacyOnClick(Sender: TObject);
begin

end;

end.

