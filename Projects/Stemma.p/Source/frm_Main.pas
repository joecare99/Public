unit frm_Main;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, ExtCtrls, StdCtrls, FMUtils, frm_ConnectDB,
  IniFiles, frm_Names, dbf, StrUtils, Math, DateUtils, frm_Explorer,
  frm_Parents, frm_History, frm_Children, frm_Siblings, frm_Events, frm_Documents, frm_Ancestors,
  frm_Descendants, frm_Images, frm_Places, frm_Sources, frm_Repositories, frm_Types, LCLType, Grids,
  ActnList, StdActns, Buttons, DBActns, Spin, frm_About, frm_EditName,
  frm_SelectPerson, frm_EditEvents;

type

  { TfrmStemmaMainForm }

  TfrmStemmaMainForm = class(TForm)
    actAdd: TAction;
    actFileConnDB: TAction;
    actFileCreateProject: TAction;
    actFileCloseProject: TAction;
    actEditCopyName: TAction;
    actEditCopyEvent: TAction;
    actEditCopyParent: TAction;
    actEditCopyChild: TAction;
    actEditCopyPerson: TAction;
    actEditDeletePerson: TAction;
    actHelpShowDebug: TAction;
    actFileImportProject: TAction;
    actFileDeleteProject: TAction;
    actAddSpouse: TAction;
    actAddFather: TAction;
    actAddMother: TAction;
    actAddBrother: TAction;
    actAddSister: TAction;
    actAddSon: TAction;
    actAddDaughter: TAction;
    actAddUnrelated: TAction;
    actAddEvBirth: TAction;
    actAddEvBaptism: TAction;
    actAddEvDeath: TAction;
    actAddEvBurial: TAction;
    actHelpAbout: TAction;
    actFileExportProject: TAction;
    actFileExportToWebsite: TAction;
    actFileImportFromTMG: TAction;
    actWinDescendens: TAction;
    actWinAncesters: TAction;
    actWinImages: TAction;
    actWinSiblings: TAction;
    actWinChildren: TAction;
    actUtilsCompression: TAction;
    actUtilsEventTypes: TAction;
    actUtilsPlaces: TAction;
    actUtilsSources: TAction;
    actUtilsRepository: TAction;
    actNavShowHistory: TAction;
    actNavNumber: TAction;
    actUtils: TAction;
    actWinDocuments: TAction;
    actWinParents: TAction;
    actWinEvents: TAction;
    actWinNameAndAttr: TAction;
    actWinExplorer: TAction;
    actWindows: TAction;
    actNavigation: TAction;
    actFileOpenProject: TAction;
    ActionList1: TActionList;
    CheckBox1: TCheckBox;
    CoolBar1: TCoolBar;
    actFileExit: TFileExit;
    actEditCopy: TEditCopy;
    actEditCut: TEditCut;
    actEditPaste: TEditPaste;
    DataHist: TStringGrid;
    actNavDataSetFirst: TDataSetFirst;
    actNavDataSetLast: TDataSetLast;
    actNavDataSetNext: TDataSetNext;
    actNavDataSetPrior: TDataSetPrior;
    imlStandardImages15: TImageList;
    imlStandardImages: TImageList;
    imlStandardImages20: TImageList;
    Individu: TSpinEdit;
    MenuItem1: TMenuItem;
    mndHelpDiv1: TMenuItem;
    mndFileDivider54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem59: TMenuItem;
    MenuItem60: TMenuItem;
    mniFileCloseProject: TMenuItem;
    mniFileExportProject: TMenuItem;
    mniFileExportToWebsite: TMenuItem;
    mndUtilsDivider64: TMenuItem;
    mniUtilItem65: TMenuItem;
    mniUtilItem66: TMenuItem;
    mniUtilItem67: TMenuItem;
    mniUtilItem68: TMenuItem;
    mniUtilItem69: TMenuItem;
    mniUtils: TMenuItem;
    mniUtilItem28: TMenuItem;
    mniUtilItem29: TMenuItem;
    mniUtilItem30: TMenuItem;
    mniUtilItem31: TMenuItem;
    mniAdd: TMenuItem;
    mniAddFather33: TMenuItem;
    mniAddMother34: TMenuItem;
    mniAddBrother35: TMenuItem;
    mniAddSister36: TMenuItem;
    mniAddSon37: TMenuItem;
    mniAddItem38: TMenuItem;
    mndAppendDivider39: TMenuItem;
    mniAddItem40: TMenuItem;
    mniAddItem41: TMenuItem;
    mniAddItem42: TMenuItem;
    mniAddItem43: TMenuItem;
    mniAddItem44: TMenuItem;
    mndEditDivider45: TMenuItem;
    mniEditCopyName: TMenuItem;
    MenuItem47: TMenuItem;
    mniHelp: TMenuItem;
    MenuItem49: TMenuItem;
    mniAddItem50: TMenuItem;
    mniFileImportFromTMG: TMenuItem;
    mndEditDivider52: TMenuItem;
    MenuItem53: TMenuItem;
    mndNavDivider20: TMenuItem;
    mniNavHistory21: TMenuItem;
    mndWindowDivider22: TMenuItem;
    mniDescendants: TMenuItem;
    mniNavPrevious24: TMenuItem;
    mniNavNext25: TMenuItem;
    mniImage: TMenuItem;
    mniNavOld1: TMenuItem;
    mniNavOld2: TMenuItem;
    mniNavOld3: TMenuItem;
    mniNavOld4: TMenuItem;
    mniNavOld5: TMenuItem;
    mniAncetres: TMenuItem;
    mniNavigation: TMenuItem;
    mniNavNumber18: TMenuItem;
    mndDivItem19: TMenuItem;
    OldIndividu: TListBox;
    OpenDialog1: TOpenDialog;
    pnlDocksite: TPanel;
    pnlDebug: TPanel;
    StatusBar: TStatusBar;
    Timer1: TTimer;
    MainMenu: TMainMenu;
    mniFile: TMenuItem;
    mniCreateProject: TMenuItem;
    mniFileConnect: TMenuItem;
    mniEdit: TMenuItem;
    mniParents: TMenuItem;
    mniExhibits: TMenuItem;
    mndWindowDivider12: TMenuItem;
    mniExplorateur: TMenuItem;
    mniEnfants: TMenuItem;
    mniWinSiblings: TMenuItem;
    mniFileDeleteProject: TMenuItem;
    mndFileDivider1: TMenuItem;
    mniEditCopy: TMenuItem;
    mniEditCut: TMenuItem;
    mniEditPaste: TMenuItem;
    mniWindows: TMenuItem;
    mniNoms: TMenuItem;
    mniEvenements: TMenuItem;
    mniOpenProject: TMenuItem;
    Importer_projet: TMenuItem;
    mndFileDivider4: TMenuItem;
    Quitter: TMenuItem;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    ToolBar1: TToolBar;
    tbtFileConnectDB: TToolButton;
    tbtFileExit: TToolButton;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    btnWinExplorer: TToolButton;
    btnWinParents: TToolButton;
    btnWinNameandAttr: TToolButton;
    btnWinEvents: TToolButton;
    btnWinDocuments: TToolButton;
    btnWinChildren: TToolButton;
    btnWinSiblings: TToolButton;
    btnWinImages: TToolButton;
    btnSeparator2: TToolButton;
    btnWinDescendens: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    tbtEditCopy: TToolButton;
    tbtEditCut: TToolButton;
    tbtEditPaste: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    tbtEditCopyName: TToolButton;
    btnSeparator1: TToolButton;
    btnWinAncesters: TToolButton;
    procedure actAddFatherUpdate(Sender: TObject);
    procedure actAddSpouseUpdate(Sender: TObject);
    procedure actAddUpdate(Sender: TObject);
    procedure actFileCreateProjectUpdate(Sender: TObject);
    procedure actFileCloseProjectUpdate(Sender: TObject);
    procedure actFileDeleteProjectUpdate(Sender: TObject);
    procedure actFileExportProjectUpdate(Sender: TObject);
    procedure actFileImportFromTMGUpdate(Sender: TObject);
    procedure actHelpShowDebugExecute(Sender: TObject);
    procedure actFileImportProjectUpdate(Sender: TObject);
    procedure actUtilsUpdate(Sender: TObject);
    procedure actWinDocumentsExecute(Sender: TObject);
    procedure actWinEventsUpdate(Sender: TObject);
    procedure actWinNameAndAttrUpdate(Sender: TObject);
    procedure actNavDataSetNextUpdate(Sender: TObject);
    procedure actNavDataSetPriorUpdate(Sender: TObject);
    procedure actNavigationUpdate(Sender: TObject);
    procedure actFileOpenProjectUpdate(Sender: TObject);
    procedure actWindowsUpdate(Sender: TObject);
    procedure actWinExplorerExecute(Sender: TObject);
    procedure actWinExtraUpdate(Sender: TObject);
    procedure actWinParentsExecute(Sender: TObject);
    procedure btnWinImagesClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ConnexionClick(Sender: TObject);
    procedure CoolBar1Change(Sender: TObject);
    procedure actFileCreateProjectExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormShowHint(Sender: TObject; HintInfo: PHintInfo);
    procedure actFileImportFromTMGExecute(Sender: TObject);
    procedure IndividuChange(Sender: TObject);
    procedure JvXPStyleManager1ThemeChanged(Sender: TObject);
    procedure mniParentsClick(Sender: TObject);
    procedure mniExhibitsClick(Sender: TObject);
    procedure mniExplorateurClick(Sender: TObject);
    procedure actWinChildrenExecute(Sender: TObject);
    procedure actWinSiblingsExecute(Sender: TObject);
    procedure actWinAncestersExecute(Sender: TObject);
    procedure mniNavNumber18Click(Sender: TObject);
    procedure actNavShowHistoryExecute(Sender: TObject);
    procedure actWinDescendensExecute(Sender: TObject);
    procedure mniNavItem24Click(Sender: TObject);
    procedure mniNavItem25Click(Sender: TObject);
    procedure actWinImagesExecute(Sender: TObject);
    procedure mniUtilItem28Click(Sender: TObject);
    procedure mniUtilItem29Click(Sender: TObject);
    procedure mniUtilItem30Click(Sender: TObject);
    procedure mniUtilItem31Click(Sender: TObject);
    procedure actAddFatherExecute(Sender: TObject);
    procedure actAddMotherExecute(Sender: TObject);
    procedure actAddBrotherExecute(Sender: TObject);
    procedure actAddSisterExecute(Sender: TObject);
    procedure actAddSonExecute(Sender: TObject);
    procedure mniAddItem38Click(Sender: TObject);
    procedure mniAddItem40Click(Sender: TObject);
    procedure mniAddItem41Click(Sender: TObject);
    procedure mniAddItem42Click(Sender: TObject);
    procedure mniAddItem43Click(Sender: TObject);
    procedure actAddSpouseExecute(Sender: TObject);
    procedure mniEditCopyNameClick(Sender: TObject);
    procedure MenuItem47Click(Sender: TObject);
    procedure actHelpAboutExecute(Sender: TObject);
    procedure mniAddItem50Click(Sender: TObject);
    procedure MenuItem53Click(Sender: TObject);
    procedure MenuItem55Click(Sender: TObject);
    procedure MenuItem58Click(Sender: TObject);
    procedure MenuItem57Click(Sender: TObject);
    procedure MenuItem59Click(Sender: TObject);
    procedure actFileCloseProjectExecute(Sender: TObject);
    procedure MenuItem61Click(Sender: TObject);
    procedure actFileExportToWebsiteExecute(Sender: TObject);
    procedure mniUtilItem65Click(Sender: TObject);
    procedure mniUtilItem66Click(Sender: TObject);
    procedure mniUtilItem67Click(Sender: TObject);
    procedure mniUtilItem68Click(Sender: TObject);
    procedure mniUtilItem69Click(Sender: TObject);
    procedure mniEvenementsClick(Sender: TObject);
    procedure OldClick(Sender: TObject);
    procedure actFileDeleteProjectExecute(Sender: TObject);
    procedure mniNomsClick(Sender: TObject);
    procedure actFileOpenExecute(Sender: TObject);
    procedure QuitterClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolBar1Paint(Sender: TObject);
  private
    FExtraWindows: array of TCustomForm;
    FMenuHistory: array of TMenuItem;
    FBitmap: TBitmap;
    procedure DockMasterCreateControl(Sender: TObject; aName: string;
      var AControl: TControl; DoDisableAutoSizing: boolean);
    function GetIDStr: string;
    function GetiID: longint;
    procedure OnCloseSite(Sender: TObject; var CloseAction: TCloseAction);
    procedure RepairProgress(Sender: TObject); deprecated 'use UpdateProgressBar';
    procedure SetiID(AValue: longint);
    procedure SetiIDStr(AValue: string); deprecated 'Use Integer variant';
    procedure ToggleVisExtraWindow(Sender: TObject;
      const lExtrawindow: TCustomForm);
    { private declarations }
  protected
    procedure UpdateMenuHistory;
  public
    ProgressBar: TProgressBar;
    procedure UpdateProgressBar(Sender: TObject);
    property iID: longint read GetiID write SetiID;
    property sID: string read GetIDStr write SetiIDStr;
    { public declarations }
  end;

var
  frmStemmaMainForm: TfrmStemmaMainForm;

implementation

{$R *.lfm}

uses AnchorDocking, AnchorDockOptionsDlg, dm_GenData, cls_Translation,
  frm_SelectDialog, untWebexport;

procedure UpdateHistoryChInd(const Items:TStrings;const lNewInd: LongInt);
var
  i: integer;
begin
  if Items.Count > 1 then
     for i := 1 to Items.Count - 1 do
       if Items[i] = inttostr(lNewInd) then
       begin
         Items.Delete(i);
         break;
       end;
   Items.InsertObject(0, inttostr(lNewInd),TObject(Ptrint(lNewInd)));
end;

{ TfrmStemmaMainForm }

procedure TfrmStemmaMainForm.QuitterClick(Sender: TObject);
begin
  if MessageDlg(SConfirmation,SAreYouSureToQuit,mtConfirmation,mbYesNo,0) = mrYes then
    frmStemmaMainForm.Close;
end;

procedure TfrmStemmaMainForm.Timer1Timer(Sender: TObject);
begin
  frmStemmaMainForm.StatusBar.Panels[1].Text := DateTimeToStr(Now);
end;

procedure TfrmStemmaMainForm.ToolBar1Paint(Sender: TObject);
var
  i, light: integer;
begin
  for i := 0 to TToolBar(Sender).Height - 1 do
    with
      TToolBar(Sender).Canvas do
    begin
      light := 255 - TToolBar(Sender).top - i;
      pen.Color := RGBToColor(light, light, light);
      Line(0, i, Width, i);
    end;
end;

procedure TfrmStemmaMainForm.UpdateProgressBar(Sender: TObject);
begin
  if Sender is TComponent then
  begin
    if TComponent(Sender).Tag >= 0 then
      ProgressBar.Position := TComponent(Sender).Tag
    else
      ProgressBar.Max := -TComponent(Sender).Tag;
  end;
  Application.ProcessMessages;
end;

procedure TfrmStemmaMainForm.RepairProgress(Sender: TObject);
begin
  if Sender.InheritsFrom(TComponent) then
    ProgressBar.Position := TComponent(Sender).Tag;
  Application.ProcessMessages;
end;

procedure TfrmStemmaMainForm.SetiID(AValue: longint);
begin
  if Individu.Value = AValue then
    exit;
  Individu.Value := AValue;

  frmStemmaMainForm.Caption :=
    format('%s - %s - %s [%d]', [ApplicationName, dmGenData.GetDBSchema, DecodeName(
    ANSItoUTF8(dmGenData.GetIndividuumName(AValue)), 1), AValue]);
  dmGenData.NamesChanged(self);
  dmGenData.EventChanged(self);
end;

procedure TfrmStemmaMainForm.SetiIDStr(AValue: string);
begin
  Individu.Value := StrToInt(AValue);
end;

procedure TfrmStemmaMainForm.ToggleVisExtraWindow(Sender: TObject;
  const lExtrawindow: TCustomForm);
var
  Checked: boolean;

begin
  if Sender is TAction then
    Checked := (Sender as TAction).Checked
  else if Sender is TMenuItem then
    Checked := (Sender as TMenuItem).Checked
  else
    exit;
  if not Checked then
  begin
    lExtrawindow.Visible := False;
    DockMaster.MakeDockable(lExtrawindow, True, True);
    if lExtrawindow.Parent is TAnchorDockHostSite then
         TAnchorDockHostSite(lExtrawindow.Parent).OnClose := lExtrawindow.OnClose;
  end
  else
  begin
    if lExtrawindow.Parent is TAnchorDockHostSite then
    begin
      DockMaster.ManualFloat(lExtrawindow);
      TAnchorDockHostSite(lExtrawindow.Parent).Close;
    end
    else
      lExtrawindow.Close;
  end;
end;

procedure TfrmStemmaMainForm.UpdateMenuHistory;
var
  nr: integer;
  lVisName: string;
  lName: string;
begin
  for nr := 0 to 4 do
  begin
    if OldIndividu.Items.Count > nr then
      with FMenuHistory[nr] do
      begin
        Visible := True;
        tag := ptrint(OldIndividu.Items.Objects[nr]);
        lName := dmGenData.GetIndividuumName(tag);
        lVisName := DecodeName(lName, 1);
        Caption := Format(rsMenuHistoryCaption, [nr + 1, lVisName, tag]);
        Hint := Format(SDispNameAndLiveDate, [lVisName, '', '']);
      end
    else
    begin
      FMenuHistory[nr].Visible := False;
      FMenuHistory[nr].Hint := '';
      FMenuHistory[nr].Tag := 0;
      FMenuHistory[nr].Caption := '';
    end;
  end;
end;

function TfrmStemmaMainForm.GetiID: longint;
begin
  Result := Individu.Value;
end;

procedure TfrmStemmaMainForm.OnCloseSite(Sender: TObject;
  var CloseAction: TCloseAction);
var
  acontrol: TControl;
  i: integer;
begin
  if Sender is TAnchorDockHostSite then
    for i := TAnchorDockHostSite(Sender).ControlCount - 1 downto 0 do
    begin
      acontrol := TAnchorDockHostSite(Sender).Controls[i];
      if acontrol is TCustomForm then
        TCustomForm(acontrol).Close
      else
        acontrol.hide;
    end;
end;

function TfrmStemmaMainForm.GetIDStr: string;
begin
  Result := Individu.Caption;
end;

procedure TfrmStemmaMainForm.DockMasterCreateControl(Sender: TObject;
  aName: string; var AControl: TControl; DoDisableAutoSizing: boolean);

  procedure CreateForm(Caption: string; {%H-}NewBounds: TRect);
  begin
    //  AControl:=CreateSimpleForm(aName,Caption,NewBounds,DoDisableAutoSizing);
  end;

begin
  // first check if the form already exists
  // the LCL Screen has a list of all existing forms.
  // Note: Remember that the LCL allows as form names only standard
  // pascal identifiers and compares them case insensitive
  AControl := Screen.FindForm(aName);
  if AControl <> nil then
  begin
    // if it already exists, just disable autosizing if requested
    if DoDisableAutoSizing then
      AControl.DisableAutoSizing;
    exit;
  end;
  // if the form does not yet exist, create it
  if aName = 'ObjectInspector' then
    CreateForm('Object Inspector', Bounds(700, 230, 100, 250))
  else if aName = 'DebugOutput' then
    CreateForm('Debug Output', Bounds(400, 400, 350, 150));
end;

procedure TfrmStemmaMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  i: integer;
begin
  dmGenData.WriteCfgFormPosition(self);
  dmGenData.WriteCfgProject(dmGenData.GetDBSchema, dmGenData.ProjectIsOpen);
  if (dmGenData.DB_Connected) and dmGenData.ProjectIsOpen then
  begin
    dmGenData.WriteCfgLastPerson(frmStemmaMainForm.iID);

    for i := 0 to high(FExtraWindows) do
    begin
      dmGenData.WritecfgInteger(CIniKeyWindow, FExtraWindows[i].Name,
        integer(FExtraWindows[i].Visible));
      if FExtraWindows[i].Parent is TAnchorDockHostSite then
        TAnchorDockHostSite(FExtraWindows[i].Parent).Close
      else
        FExtraWindows[i].Close;
    end;
  end;
  // Sauvegarde l'historique de données
  if DataHist.RowCount > 1000 then
    DataHist.RowCount := 1000;
  DataHist.SaveToFile('HistD.data');
  // Sauvegarde l'historique d'individu
  if OldIndividu.Items.Count > 1000 then
    for i := OldIndividu.Items.Count - 1 downto 1000 do
      OldIndividu.Items.Delete(i);
  OldIndividu.Items.SaveToFile('HistP.data');
end;

procedure TfrmStemmaMainForm.FormCreate(Sender: TObject);

var
  i, light: integer;
begin
  DockMaster.MakeDockSite(Self, [akBottom, akLeft], admrpChild);
  DockMaster.OnShowOptions := @ShowAnchorDockOptions;
  DockMaster.OnCreateControl := @DockMasterCreateControl;
  ProgressBar := TProgressBar.Create(StatusBar);
  with ProgressBar do
  begin
    Parent := StatusBar;
    Left := 0;
    Visible := False;
    Height := 8;
    Width := frmStemmaMainForm.Width;
    Max := 100;
    Position := 0;
  end;
  setlength(FExtraWindows, 10);
  setlength(FMenuHistory, 5);
  FBitmap := TBitmap.Create;
  CoolBar1.Bitmap := FBitmap;
  CoolBar1.Bitmap.PixelFormat := pf24bit;
  CoolBar1.Bitmap.Width := 5;
  CoolBar1.Bitmap.Height := scaley(CoolBar1.Height, DesignTimeDPI);
  with CoolBar1.Bitmap.Canvas do
    for i := 0 to CoolBar1.Bitmap.Height - 1 do
    begin
      light := 255 - i;
      pen.Color := RGBToColor(light, light, light);
      Line(0, i, CoolBar1.Bitmap.Width, i);
    end;

end;

procedure TfrmStemmaMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fBitmap);
  FreeAndNil(ProgressBar);
end;

procedure TfrmStemmaMainForm.ConnexionClick(Sender: TObject);
var
  Success: boolean;
  lServer, lUserName, lPassword: string;
begin
  dmGenData.ReadCfgConnection(lServer, lUserName, lPassword);
  frmConnectDB.setdata(lServer, lUserName, lPassword);

  if frmConnectDb.Showmodal = mrOk then
  begin
    frmConnectDb.GetData(lServer, lUserName, lPassword);
    dmGenData.WriteCfgConnection(lServer, lUserName, lPassword);

    dmGenData.SetDBHostUserPass(
      lServer,
      lUserName,
      lPassword,
      Success);
    if not Success then
      ShowMessage(format(SUnableToConnectToDB,[lServer]));
  end;
end;

procedure TfrmStemmaMainForm.CoolBar1Change(Sender: TObject);
begin

end;

procedure TfrmStemmaMainForm.CheckBox1Change(Sender: TObject);
begin
  // Test-
  ProgressBar.Visible := CheckBox1.Checked;
end;

procedure TfrmStemmaMainForm.actFileOpenProjectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected;
end;

procedure TfrmStemmaMainForm.actWindowsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actWinExplorerExecute(Sender: TObject);

begin
  ToggleVisExtraWindow(Sender, frmExplorer);
end;

procedure TfrmStemmaMainForm.actWinExtraUpdate(Sender: TObject);
begin
  with Sender as TAction do
  begin
    Checked := FExtraWindows[tag].Visible and
      (not assigned(FExtraWindows[tag].parent) or FExtraWindows[tag].parent.Visible);
    Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
  end;
end;

procedure TfrmStemmaMainForm.actWinParentsExecute(Sender: TObject);
begin
  ToggleVisExtraWindow(Sender, frmParents);
end;

procedure TfrmStemmaMainForm.btnWinImagesClick(Sender: TObject);
begin

end;

procedure TfrmStemmaMainForm.actFileCreateProjectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected;
end;

procedure TfrmStemmaMainForm.actFileCloseProjectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actFileDeleteProjectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected;
end;

procedure TfrmStemmaMainForm.actFileExportProjectUpdate(Sender: TObject);
begin
  actFileExportProject.Enabled:=dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actFileImportFromTMGUpdate(Sender: TObject);
begin
  actFileImportFromTMG.Enabled:=dmGenData.DB_Connected;
end;

procedure TfrmStemmaMainForm.actHelpShowDebugExecute(Sender: TObject);
begin
  pnlDebug.Visible := TAction(Sender).Checked;
end;

procedure TfrmStemmaMainForm.actFileImportProjectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected;
end;

procedure TfrmStemmaMainForm.actUtilsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actWinDocumentsExecute(Sender: TObject);
begin
  ToggleVisExtraWindow(Sender, frmDocuments);
end;

procedure TfrmStemmaMainForm.actWinEventsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actWinNameAndAttrUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actNavDataSetNextUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen and
    frmExplorer.Visible;
end;

procedure TfrmStemmaMainForm.actNavDataSetPriorUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen and
    frmExplorer.Visible;
end;

procedure TfrmStemmaMainForm.actNavigationUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actAddUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actAddSpouseUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actAddFatherUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := dmGenData.DB_Connected and dmGenData.ProjectIsOpen;
end;

procedure TfrmStemmaMainForm.actFileCreateProjectExecute(Sender: TObject);
var
  db: string;
  i: integer;
  success, lConnected: boolean;
begin
  dmGenData.ReadCfgProject(db, lConnected);
  if InputQuery(Translation.Items[3], Translation.Items[4], db) then
  begin
    // Avant de créer le projet, fermer le project actif
    // Créer la base de données          CREATE DATABASE `stemma_data`
    try
      frmStemmaMainForm.Caption := 'Stemma';
      // Fermer toutes les fenêtres ouvertes
      for i := 0 to high(FExtraWindows) do
        if FExtraWindows[i].Parent is TAnchorDockHostSite then
          TAnchorDockHostSite(FExtraWindows[i].Parent).Close
        else
          FExtraWindows[i].Close;


      frmStemmaMainForm.iID := 0;

      dmGendata.CreateDBProject(db, @RepairProgress);
      // Créer un individu
      frmStemmaMainForm.iID := 0;
      mniAddItem50Click(Sender);
    except
      //        Showmessage('Base de données déjà existante.');
      ShowMessage(Translation.Items[5]);
      dmGenData.SetDBSchema(db, success);
      { TODO 12 : Doit vérifier si c'est le bon format... - fonction car utilisée à plus d'un endroi }
    end;
    frmStemmaMainForm.iId := dmGenData.GetFirstIndividuum;
    dmGenData.WriteCfgProject(db, dmgendata.ProjectIsOpen);
  end;
end;

procedure TfrmStemmaMainForm.FormShow(Sender: TObject);
var
  lDBHostName, lDBUser, lDBSchema, lDBPassword: string;
  bSuccess, lConnected: boolean;
  i, lLastPerson: integer;
  DPIFak: single;
  lid: Longint;
begin
  DPIFak := ScreenInfo.PixelsPerInchY / DesignTimeDPI * 1.1;
  if DPIFak < 1.4 then
  begin
    MainMenu.Images := imlStandardImages;
    ToolBar1.Images := imlStandardImages;
    ToolBar2.Images := imlStandardImages;
    ToolBar3.Images := imlStandardImages;
  end
  else if DPIFak < 1.9 then
  begin
    MainMenu.Images := imlStandardImages15;
    ToolBar1.Images := imlStandardImages15;
    ToolBar2.Images := imlStandardImages15;
    ToolBar3.Images := imlStandardImages15;
  end
  else
  begin
    MainMenu.Images := imlStandardImages20;
    ToolBar1.Images := imlStandardImages20;
    ToolBar2.Images := imlStandardImages20;
    ToolBar3.Images := imlStandardImages20;
  end;

  { TODO 20 : Ajouter Splash Screen }
  // TODO -p20 : Add a Splash Screen }
  FExtraWindows[0] := frmExplorer;
  FExtraWindows[1] := frmNames;
  FExtraWindows[2] := frmEvents;
  FExtraWindows[3] := frmParents;
  FExtraWindows[4] := frmDocuments;
  FExtraWindows[5] := frmChildren;
  FExtraWindows[6] := frmSiblings;
  FExtraWindows[7] := frmAncestors;
  FExtraWindows[8] := frmDescendants;
  FExtraWindows[9] := FormImage;

  FMenuHistory[0] := mniNavOld1;
  FMenuHistory[1] := mniNavOld2;
  FMenuHistory[2] := mniNavOld3;
  FMenuHistory[3] := mniNavOld4;
  FMenuHistory[4] := mniNavOld5;

  // Récupère l'historique de données
  DataHist.Clear;
  DataHist.SaveOptions := soAll;
  if fileexists('HistD.data') then // Todo: Save History in another place
    DataHist.LoadFromFile('HistD.data');
  if DataHist.RowCount = 0 then
    DataHist.RowCount := 1;
  // Récupère l'historique d'individu
  OldIndividu.Items.Clear;
  OldIndividu.Items.LoadFromFile('HistP.data');
  for i := 0 to OldIndividu.Items.Count-1 do
    if tryStrToint(OldIndividu.Items[i],lid) then
      OldIndividu.Items.Objects[i]:=TObject(PtrInt(lid));
  Translation.LoadFromFile(dmgendata.ReadCfgString('Parametres', 'Langue', 'francais'));
  CoolBar1.AutosizeBands;
  mniFile.Caption := Translation.Items[248];
  mniFileConnect.Caption := Translation.Items[249];
  mniCreateProject.Caption := Translation.Items[250];
  mniOpenProject.Caption := Translation.Items[251];
  Importer_projet.Caption := Translation.Items[252];
  mniFileDeleteProject.Caption := Translation.Items[254];
  Quitter.Caption := Translation.Items[256];
  mniEdit.Caption := Translation.Items[257];
  mniEditCopy.Caption := Translation.Items[258];
  mniEditCut.Caption := Translation.Items[259];
  mniEditPaste.Caption := Translation.Items[260];
  mniWindows.Caption := Translation.Items[285];
  mniNoms.Caption := Translation.Items[287];
  mniEvenements.Caption := Translation.Items[288];
  mniParents.Caption := Translation.Items[289];
  mniExhibits.Caption := Translation.Items[290];
  mniExplorateur.Caption := Translation.Items[286];
  mniEnfants.Caption := Translation.Items[291];
  mniWinSiblings.Caption := Translation.Items[292];
  mniAncetres.Caption := Translation.Items[294];
  mniNavigation.Caption := Translation.Items[276];
  mniNavNumber18.Caption := Translation.Items[277];
  mniNavHistory21.Caption := Translation.Items[280];
  mniDescendants.Caption := Translation.Items[295];
  mniNavPrevious24.Caption := Translation.Items[278];
  mniNavNext25.Caption := Translation.Items[279];
  mniImage.Caption := Translation.Items[293];
  mniUtils.Caption := Translation.Items[281];
  mniUtilItem28.Caption := Translation.Items[282];
  mniUtilItem29.Caption := Translation.Items[283];
  mniUtilItem30.Caption := Translation.Items[233];
  mniUtilItem31.Caption := Translation.Items[284];
  mniAdd.Caption := Translation.Items[224];
  mniAddFather33.Caption := Translation.Items[264];
  mniAddMother34.Caption := Translation.Items[265];
  mniAddBrother35.Caption := Translation.Items[266];
  mniAddSister36.Caption := Translation.Items[267];
  mniAddSon37.Caption := Translation.Items[268];
  mniAddItem38.Caption := Translation.Items[269];
  mniAddItem40.Caption := Translation.Items[272];
  mniAddItem41.Caption := Translation.Items[273];
  mniAddItem42.Caption := Translation.Items[274];
  mniAddItem43.Caption := Translation.Items[275];
  mniAddItem44.Caption := Translation.Items[270];
  mniEditCopyName.Caption := Translation.Items[261];
  MenuItem47.Caption := Translation.Items[262];
  mniHelp.Caption := Translation.Items[296];
  MenuItem49.Caption := Translation.Items[297];
  mniAddItem50.Caption := Translation.Items[271];
  mniFileImportFromTMG.Caption := Translation.Items[253];
  MenuItem53.Caption := Translation.Items[263];
  MenuItem55.Caption := Translation.Items[308];
  MenuItem56.Caption := Translation.Items[302];
  MenuItem57.Caption := Translation.Items[303];
  MenuItem58.Caption := Translation.Items[255];
  MenuItem59.Caption := Translation.Items[309];
  MenuItem60.Caption := Translation.Items[310];
  mniFileExportProject.Caption := Translation.Items[321];
  mniFileExportToWebsite.Caption := Translation.Items[322];
  mniUtilItem65.Caption := Translation.Items[335];
  mniUtilItem66.Caption := Translation.Items[336];
  mniUtilItem67.Caption := Translation.Items[338];
  mniUtilItem68.Caption := Translation.Items[339];
  mniUtilItem69.Caption := Translation.Items[340];

  dmGenData.ReadCfgFormPosition(Sender as TForm, 0, 0, 70, 1000);
  dmgendata.ReadCfgProject(lDBSchema, lConnected);
  if lConnected then
  begin
    dmGenData.ReadCfgConnection(lDBHostName, lDBUser, lDBPassword);
    dmGenData.SetDBHostUserPass(lDBHostName, lDBUser, lDBPassword, bSuccess);
    if not bSuccess then
      ShowMessage(Translation.Items[2])
    else
    begin
      dmGenData.SetDBSchema(lDBSchema, bSuccess);
    end;
    if not bSuccess then
      ShowMessage(Translation.Items[2])
    else
    begin
      frmStemmaMainForm.Caption := 'Stemma - ' + lDBSchema;
      dmGenData.ReadCfgLastPerson(lLastPerson);
      Individu.Value := lLastPerson;
      Application.ProcessMessages;
      for i := 0 to high(FExtraWindows) do
        if dmGenData.ReadCfgInteger(CIniKeyWindow, FExtraWindows[i].Name, 0) = 1 then
          ToggleVisExtraWindow(self, FExtraWindows[i]);

      UpdateMenuHistory;
    end;
  end;
end;

procedure TfrmStemmaMainForm.FormShowHint(Sender: TObject; HintInfo: PHintInfo);
begin

end;


procedure TfrmStemmaMainForm.actFileImportFromTMGExecute(Sender: TObject);
var
  ini: TIniFile;
  db, buffer, buffer2, buffer3, buffer5, role, insert, pd,
  sd, filename: string;
  i: integer;
  debut, restant, oldrestant: TDateTime;
  MyCursor: TCursor;
  success: boolean;
  lMaxRecords: longint;

  procedure ImportPlace;
  begin
    // Importer L Lieus (_P)
    dmGenData.Query1.SQL.Text :=
      'INSERT IGNORE INTO L (no, L) VALUES (:idPlace, :Place)';
    dmGenData.TMG.Tablename := filename + 'P.DBF';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 1;
      restant := ((ProgressBar.Max / ProgressBar.Position) - 1) * (now - debut);
      if abs(oldrestant - restant) > 0.00001 then
      begin
        oldrestant := restant;
        StatusBar.Panels[1].Text :=
          Translation.Items[13] + TimeToStr(restant);
        Application.ProcessMessages;
      end;
      if dmGenData.TMG.Fields[1].IsNull then
        buffer := ''
      else
        buffer := '!dmGenData.TMG' + ReplaceStr(
          dmGenData.TMG.Fields[1].Value, '$!&', '|');
      buffer := IntToStr(dmGenData.TMG.Fields[0].Value) + ',''' + buffer + ''');';
      with dmGenData.Query1 do
      begin
        ParamByName('idPlace').AsInteger := dmGenData.TMG.Fields[0].Value;
        ParamByName('Place').AsString := buffer;
        ExecSQL;
      end;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportSourceDepotConnection;
  begin
    // Importer A Association Source-Dépots (_W)
    dmGenData.TMG.Tablename := filename + 'W.DBF';
    dmGenData.Query1.SQL.Text :=
      'INSERT IGNORE INTO A (S, D, M) VALUES (:idSource, :idDepot, :Note)';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    StatusBar.Panels[1].Text := Translation.Items[8];
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 1;
      Application.ProcessMessages;
      if dmGenData.TMG.Fields[2].IsNull then
        buffer := ''
      else
        buffer := dmGenData.TMG.Fields[2].Value;

      with dmGenData.Query1 do
      begin
        ParamByName('idSource').AsInteger := dmGenData.TMG.Fields[0].Value;
        ParamByName('idDepot').AsInteger := dmGenData.TMG.Fields[1].Value;
        ParamByName('Note').AsString := buffer;
        ExecSQL;
      end;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportDepots;
  begin
    // Importer D Dépots (_R)
    dmGenData.TMG.Tablename := filename + 'R.DBF';
    insert := 'INSERT IGNORE INTO D (no, T, M, D, I) VALUES (';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    StatusBar.Panels[1].Text := Translation.Items[9];
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 1;
      Application.ProcessMessages;
      if dmGenData.TMG.Fields[3].IsNull then
        buffer2 := ''
      else
        buffer2 := AnsiReplaceStr(
          AnsiReplaceStr(dmGenData.TMG.Fields[3].Value, '"', '\"'), '''', '\''');
      buffer := IntToStr(dmGenData.TMG.Fields[5].Value) + ',''' +
        dmGenData.TMG.Fields[0].Value + ''',''' + buffer2 + ''',''' +
        dmGenData.TMG.Fields[0].Value + ''',' +
        IntToStr(dmGenData.TMG.Fields[4].Value) + ');';
      dmGenData.Query1.SQL.Text := insert + buffer;
      dmGenData.Query1.ExecSQL;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportEvents;
  begin
    // Importer E Événements (_G)
    dmGenData.TMG.Tablename := filename + 'G.DBF';
    dmGenData.Query1.SQL.Text :=
      'INSERT IGNORE INTO E (no, Y, PD, SD, L, M, X) ' +
      'VALUES (:idEvent, :idType, :PDate, SDate, :idPlace, :Note, :Pref)';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    while not (dmGenData.TMG.EOF) do
    begin
      // Mettre temporairement P1 et P2 dans une base de données pour pouvoir déterminer
      // les témoins principaux
      ProgressBar.Position := ProgressBar.Position + 1;
      restant := ((ProgressBar.Max / ProgressBar.Position) - 1) * (now - debut);
      if abs(oldrestant - restant) > 0.00001 then
      begin
        oldrestant := restant;
        StatusBar.Panels[1].Text :=
          Translation.Items[10] + TimeToStr(restant);
        Application.ProcessMessages;
      end;
      if dmGenData.TMG.Fields[8].IsNull then
        buffer2 := ''
      else
        buffer2 := dmGenData.TMG.Fields[8].Value;

      dmGenData.Query1.ParamByName('idEvent').AsInteger := dmGenData.TMG.Fields[0].Value;
      dmGenData.Query1.ParamByName('idType').AsInteger :=
        dmGenData.TMG.Fields[1].Value + 1000;
      dmGenData.Query1.ParamByName('PDate').AsString := dmGenData.TMG.Fields[6].Value;
      dmGenData.Query1.ParamByName('Sdate').AsString := dmGenData.TMG.Fields[14].Value;
      dmGenData.Query1.ParamByName('idPlace').AsInteger :=
        dmGenData.TMG.Fields[7].Value;
      dmGenData.Query1.ParamByName('Note').AsString := buffer2;
      dmGenData.Query1.ParamByName('Pref').AsInteger := 0;

      dmGenData.Query1.ExecSQL;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportCitations;
  var
    j: integer;
  begin
    // Importer C Citations (_S)
    dmGenData.TMG.Tablename := filename + 'S.DBF';
    dmGenData.Query1.SQL.Text := 'INSERT IGNORE INTO C (Y, N, S, M, Q) VALUES (';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 1;
      restant := ((ProgressBar.Max / ProgressBar.Position) - 1) * (now - debut);
      if abs(oldrestant - restant) > 0.00001 then
      begin
        oldrestant := restant;
        StatusBar.Panels[1].Text :=
          Translation.Items[11] + TimeToStr(restant);
        Application.ProcessMessages;
      end;
      if (dmGenData.TMG.Fields[0].Value = 'F') then
        buffer := 'R'
      else
        buffer := dmGenData.TMG.Fields[0].Value;
      if dmGenData.TMG.Fields[3].IsNull then
        buffer2 := ''
      else
        buffer2 := AnsiReplaceStr(
          AnsiReplaceStr(dmGenData.TMG.Fields[3].Value, '"', '\"'), '''', '\''');
      i := 10;
      for j := 4 to 8 do
        if not dmGenData.TMG.Fields[j].IsNull then
          if (dmGenData.TMG.Fields[j].Value = '-') then
            i := 0
          else
            i := min(i, dmGenData.TMG.Fields[j].Value);
      buffer := '''' + buffer + ''',' + IntToStr(dmGenData.TMG.Fields[1].Value) +
        ',' + IntToStr(dmGenData.TMG.Fields[2].Value) + ',''' +
        buffer2 + ''',' + IntToStr(i) + ');';
      dmGenData.Query1.SQL.Text := insert + buffer;
      dmGenData.Query1.ExecSQL;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportIndividuals(iOffset: integer = 0);
  begin
    // Importer I Individus (_$)
    dmGenData.TMG.Tablename := filename + '$.DBF';
    dmGenData.Query1.SQL.Text :=
      'INSERT IGNORE INTO I (no, S, V, I, date) ' +
      'VALUES (:idInd, :Sex, :Living, :Importance, :Date)';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 1;
      restant := ((ProgressBar.Max / ProgressBar.Position) - 1) * (now - debut);
      if abs(oldrestant - restant) > 0.00001 then
      begin
        oldrestant := restant;
        StatusBar.Panels[1].Text :=
          Translation.Items[12] + TimeToStr(restant);
        Application.ProcessMessages;
      end;
      if dmGenData.TMG.Fields[10].Value = 'Y' then
        buffer := 'O'
      else
        buffer := dmGenData.TMG.Fields[10].Value;
      case dmGenData.TMG.Fields[14].Value of
        0: i := 0;
        1: i := 7;
        2: i := 8;
        3: i := 9;
      end;

      dmGenData.Query1.ParamByName('idInd').AsInteger :=
        dmGenData.TMG.Fields[0].Value + iOffset;
      dmGenData.Query1.ParamByName('Sex').AsString :=
        dmGenData.TMG.Fields[9].Value;
      dmGenData.Query1.ParamByName('Living').AsString := buffer;
      dmGenData.Query1.ParamByName('Importance').AsInteger := i;
      dmGenData.Query1.ParamByName('Date').AsString :=
        Format('%.4d', [yearof(dmGenData.TMG.Fields[3].Value)]) +
        Format('%.2d', [monthof(dmGenData.TMG.Fields[3].Value)]) +
        Format('%.2d', [dayof(dmGenData.TMG.Fields[3].Value)]);
      dmGenData.Query1.ExecSQL;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportWitnesses;
  begin
    // Importer W Témoins (_E)
    dmGenData.TMG.Tablename := filename + 'E.DBF';
    insert := 'INSERT IGNORE INTO W (I, E, X, P, R) VALUES (';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 1;
      restant := ((ProgressBar.Max / ProgressBar.Position) - 1) * (now - debut);
      if abs(oldrestant - restant) > 0.00001 then
      begin
        oldrestant := restant;
        StatusBar.Panels[1].Text :=
          Translation.Items[14] + TimeToStr(restant);
      end;
      Application.ProcessMessages;
      if dmGenData.TMG.Fields[3].IsNull then
        buffer := ''
      else
        buffer := '!dmGenData.TMG' + dmGenData.TMG.Fields[3].Value;
      // Mettre l'information du X dans la base de données des événements
      if dmGenData.TMG.Fields[2].Value then
        with dmGenData.Query1 do
        begin
          SQL.Text := 'UPDATE E SET X=1 WHERE no=:id';
          ParamByName('id').AsInteger := dmGenData.TMG.Fields[1].Value;
          ExecSQL;
        end;
      // Si role = PRINCIPAL, c'est un témoin X=1, sinon X=0
      i := 1;
      role := UpperCase(dmGenData.TMG.Fields[4].AsString);
      if role = 'ASSASSIN' then
        i := 0
      else
      if role = 'CELEBRANT' then
        i := 0
      else
      if role = 'DEPOSITAIRE' then
        i := 0
      else
      if role = 'NOTAIRE' then
        i := 0
      else
      if role = 'EXECUTEUR' then
        i := 0
      else
      if role = 'NOMMEUR' then
        i := 0
      else
      if role = 'ORDONNEUR' then
        i := 0
      else
      if role = 'TEMOIN' then
        i := 0
      else
      if role = 'WITNESS' then
        i := 0
      else
      if role = 'BENEFICIAIRE' then
        i := 0;
      buffer := IntToStr(dmGenData.TMG.Fields[0].AsInteger) +
        ',' + IntToStr(dmGenData.TMG.Fields[1].AsInteger) + ',' +
        IntToStr(i) + ',''' + buffer + ''',''' +
        UpperCase(dmGenData.TMG.Fields[4].AsString) + ''');';
      dmGenData.Query1.SQL.Text := insert + buffer;
      dmGenData.Query1.ExecSQL;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportNames(nOffset: integer = 0; iOffset: integer = 0);
  var
    I4: string;
    I3: string;
    buffer4: string;
  begin
    // Importer N Noms (_N)
    dmGenData.TMG.Tablename := filename + 'N.DBF';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;

    dmGenData.Query1.SQL.Text :=
      'INSERT IGNORE INTO N (no, I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4) ' +
      'VALUES (:idName ,:idInd, :idType, :Name, :Pref, :Note, :Phrase, :PDate, :SDate, :I1, :I2, :I3, :I4)';
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 20;
      restant := ((ProgressBar.Max / ProgressBar.Position) - 1) * (now - debut);
      if abs(oldrestant - restant) > 0.00001 then
      begin
        oldrestant := restant;
        StatusBar.Panels[1].Text :=
          Translation.Items[15] + TimeToStr(restant);
        Application.ProcessMessages;
      end;
      if dmGenData.TMG.Fields[3].IsNull then
        buffer := ''
      else
        buffer := '!dmGenData.TMG|' + AnsiReplaceStr(
          dmGenData.TMG.Fields[3].Value, '$!&', '|');
      buffer4 := RemoveUTF8(ExtractDelimited(
        2, copy(buffer, 5, length(buffer)), ['|']));
      buffer5 := RemoveUTF8(ExtractDelimited(
        4, copy(buffer, 5, length(buffer)), ['|']));
      if dmGenData.TMG.Fields[12].IsNull then
        buffer2 := ''
      else
        buffer2 := '!dmGenData.TMG' + dmGenData.TMG.Fields[12].Value;
      if dmGenData.TMG.Fields[10].IsNull then
        buffer3 := ''
      else
        buffer3 := dmGenData.TMG.Fields[10].Value;
      if dmGenData.TMG.Fields[13].IsNull then
        pd := '100000000030000000000'
      else
        pd := dmGenData.TMG.Fields[13].Value;
      if dmGenData.TMG.Fields[14].IsNull then
        sd := '100000000030000000000'
      else
        sd := dmGenData.TMG.Fields[14].Value;
      if dmGenData.TMG.Fields[6].Value then
        i := 1
      else
        i := 0;
      dmGenData.Query2.SQL.Text :=
        'SELECT E.SD FROM E LEFT JOIN W ON W.E=E.no ' +
        'WHERE (E.Y=1069 or E.Y=2017 OR E.Y=1002 OR E.Y=1012 OR E.Y=1069) AND W.X=1 AND W.I=:id '
        +
        'ORDER BY E.SD';
      dmGenData.Query2.ParamByName('id').AsInteger := dmGenData.TMG.Fields[0].Value;
      dmGenData.Query2.Open;
      I3 := dmGenData.Query2.Fields[0].AsString;
      dmGenData.Query2.SQL.Clear;
      dmGenData.Query2.SQL.add(
        'SELECT E.SD FROM E LEFT JOIN W ON W.E=E.no ' +
        'WHERE (E.Y=1003 or E.Y=1006 OR E.Y=2001 OR E.Y=2004 OR E.Y=2007 OR E.Y=2009 OR E.Y=2010 OR E.Y=2014 OR E.Y=2018 OR E.Y=2020) AND W.X=1 AND W.I=:id ' + 'ORDER BY E.SD');
      dmGenData.Query2.ParamByName('id').AsInteger := dmGenData.TMG.Fields[0].Value;
      dmGenData.Query2.Open;
      I4 := dmGenData.Query2.Fields[0].AsString;

      with dmGenData.Query1 do
      begin
        ParamByName('idName').AsInteger := dmGenData.TMG.Fields[11].Value + nOffset;
        ParamByName('idInd').AsInteger := dmGenData.TMG.Fields[0].Value + iOffset;
        ParamByName('idType').AsInteger := dmGenData.TMG.Fields[1].Value + 1000;
        ParamByName('Name').AsString := buffer;
        ParamByName('Pref').AsInteger := I;
        ParamByName('Note').AsString := buffer3;
        ParamByName('Phrase').AsString := buffer2;
        ParamByName('PDate').AsString := PD;
        ParamByName('SDate').AsString := SD;
        ParamByName('I1').AsString := buffer4;
        ParamByName('I2').AsString := buffer5;
        ParamByName('I3').AsString := I3;
        ParamByName('I4').AsString := I4;
      end;

      dmGenData.Query1.ExecSQL;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportRelations;
  begin
    // Importer R Relations (_F)
    insert := 'INSERT IGNORE INTO R (no, Y, A, B, M, X, SD, P) VALUES (';
    dmGenData.TMG.Tablename := filename + 'F.DBF';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 1;
      restant := ((ProgressBar.Max / ProgressBar.Position) - 1) * (now - debut);
      if abs(oldrestant - restant) > 0.00001 then
      begin
        oldrestant := restant;
        StatusBar.Panels[1].Text :=
          Translation.Items[16] + TimeToStr(restant);
        Application.ProcessMessages;
      end;
      if dmGenData.TMG.Fields[4].IsNull then
        buffer := ''
      else
        buffer := dmGenData.TMG.Fields[4].Value;
      sd := '100000000030000000000';
      if dmGenData.TMG.Fields[0].Value then
        i := 1
      else
        i := 0;
      buffer := IntToStr(dmGenData.TMG.Fields[7].Value) + ',' +
        IntToStr(dmGenData.TMG.Fields[3].Value + 1000) + ',' + IntToStr(
        dmGenData.TMG.Fields[1].Value) + ',' + IntToStr(dmGenData.TMG.Fields[2].Value) +
        ',''' + buffer + ''',' + IntToStr(i) + ',''' + sd + ''','''');';
      dmGenData.Query1.SQL.Text := insert + buffer;
      dmGenData.Query1.ExecSQL;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportSources;
  begin
    // Importer S Sources (_M)
    dmGenData.TMG.Tablename := filename + 'M.DBF';
    insert := 'INSERT IGNORE INTO S (no, T, M, D, A, Q) VALUES (';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 1;
      restant := ((ProgressBar.Max / ProgressBar.Position) - 1) * (now - debut);
      if abs(oldrestant - restant) > 0.00001 then
      begin
        oldrestant := restant;
        StatusBar.Panels[1].Text :=
          Translation.Items[17] + TimeToStr(restant);
        Application.ProcessMessages;
      end;
      if dmGenData.TMG.Fields[2].IsNull then
        buffer := ''
      else
        buffer := AnsiReplaceStr(
          AnsiReplaceStr(dmGenData.TMG.Fields[2].Value, '"', '\"'), '''', '\''');
      if dmGenData.TMG.Fields[4].IsNull then
        buffer2 := ''
      else
        buffer2 := AnsiReplaceStr(
          AnsiReplaceStr(dmGenData.TMG.Fields[4].Value, '"', '\"'), '''', '\''');
      // extraire auteur et e-mail d'auteur de dmGenData.TMG.Fields[22].Value (sd et buffer3)
      if dmGenData.TMG.Fields[23].IsNull then
      begin
        buffer3 := '';
        sd := '';
      end
      else
      begin
        buffer5 := AnsiReplaceStr(dmGenData.TMG.Fields[23].Value, '$!&', '|');
        sd := AnsiReplaceStr(AnsiReplaceStr(
          ExtractDelimited(6, buffer5, ['|']), '"', '\"'), '''', '\''');
        buffer3 := ExtractDelimited(14, buffer5, ['|']);
      end;
      if dmGenData.TMG.Fields[13].Value > 0 then
        sd := IntToStr(dmGenData.TMG.Fields[13].Value);
      if not dmGenData.TMG.Fields[11].IsNull then
        if buffer3 = '' then
          buffer3 := AnsiReplaceStr(
            AnsiReplaceStr(dmGenData.TMG.Fields[11].Value, '"', '\"'), '''', '\''');
      buffer := IntToStr(dmGenData.TMG.Fields[1].Value) + ',''' +
        buffer + ''',''' + buffer3 + ''',''' + buffer2 + ''',''' +
        sd + ''',' + IntToStr(dmGenData.TMG.Fields[3].Value) + ');';
      dmGenData.Query1.SQL.Text := insert + buffer;
      dmGenData.Query1.ExecSQL;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportDocuments;
  begin
    // Importer X Exhibits (_I)
    dmGenData.TMG.Tablename := filename + 'I.DBF';
    insert := 'INSERT IGNORE INTO X (X, T, D, F, Z, A, N) VALUES (';
    dmGenData.TMG.Active := True;
    dmGenData.TMG.Open;
    while not (dmGenData.TMG.EOF) do
    begin
      ProgressBar.Position := ProgressBar.Position + 1;
      restant := ((ProgressBar.Max / ProgressBar.Position) - 1) * (now - debut);
      if abs(oldrestant - restant) > 0.00001 then
      begin
        oldrestant := restant;
        StatusBar.Panels[1].Text :=
          Translation.Items[18] + TimeToStr(restant);
        Application.ProcessMessages;
      end;
      if dmGenData.TMG.Fields[54].IsNull then
        i := 0
      else if dmGenData.TMG.Fields[54].Value then
        i := 1
      else
        i := 0;
      if dmGenData.TMG.Fields[0].IsNull then
        buffer := ''
      else
        buffer := AutoQuote(dmGenData.TMG.Fields[0].Value);
      if dmGenData.TMG.Fields[26].IsNull then
        buffer2 := ''
      else
        buffer2 := AutoQuote(dmGenData.TMG.Fields[26].Value);
      if dmGenData.TMG.Fields[1].IsNull then
        buffer3 := ''
      else
        buffer3 := AutoQuote(dmGenData.TMG.Fields[1].Value);
      if dmGenData.TMG.Fields[23].IsNull then
        sd := ''
      else
        sd := AutoQuote(dmGenData.TMG.Fields[23].Value);
      if dmGenData.TMG.Fields[41].Value = '_' then
        pd := 'I'
      else
      if uppercase(dmGenData.TMG.Fields[41].Value) = 'M' then
        pd := 'S'
      else
        pd := 'E';
      buffer := IntToStr(i) + ',''' + buffer + ''',''' + buffer2 +
        ''',''' + buffer3 + ''',''' + sd + ''',''' + pd + ''',' +
        IntToStr(dmGenData.TMG.Fields[42].Value) + ');';
      dmGenData.Query1.SQL.Text := insert + buffer;
      dmGenData.Query1.ExecSQL;
      dmGenData.TMG.Next;
    end;
    dmGenData.TMG.Active := False;
  end;

  procedure ImportTypes;
  var
    y: string;
    roles: string;
  begin
    // Importer Y Types d'événements (_T)
          // Insert Types
          dmGenData.TMG.Tablename := filename + 'T.DBF';
          dmGenData.TMG.Active := True;
          dmGenData.TMG.Open;
          dmGenData.Query1.SQL.Text := 'INSERT IGNORE INTO Y (no, Y, P, T, R) '+
          'VALUES (:idType, :Type, :Phrase, :Title, :Fields)';
          StatusBar.SimpleText := Translation.Items[7];
          debut := now;
          oldrestant := 0;
          while not (dmGenData.TMG.EOF) do
          begin
            ProgressBar.Position := ProgressBar.Position + 1;
            Application.ProcessMessages;
            if dmGenData.TMG.Fields[1].Value then
            begin
              if dmGenData.TMG.Fields[6].IsNull then
                buffer := ''
              else
              begin
                buffer := dmGenData.TMG.Fields[6].Value;
                buffer := AnsiReplaceStr(buffer, '"', '\"');
                buffer := AnsiReplaceStr(buffer, '''', '\''');
              end;
              case dmGenData.TMG.Fields[3].Value of
                1: y := 'N';
                2..3: y := 'R';
                4: y := 'B';
                5: y := 'D';
                6..7: y := 'M';
                8: y := 'X';
                9: y := 'D';
                10: y := 'X';
                12: y := 'R';
                99: y := 'X';
              end;
              // Need to parse and translate phrase or parse STEMMA and dmGenData.TMG type of phrase when reporting
              // Extract roles
              buffer2 := buffer;
              roles := '';
              while (AnsiPos('[R=', buffer2) > 0) do
              begin
                buffer2 := copy(buffer2, AnsiPos('[R=', buffer2) + 3, length(buffer2));
                role := uppercase(copy(buffer2, 1, AnsiPos(']', buffer2) - 1));
                if AnsiPos(role, roles) < 1 then
                  roles := roles + '|' + role;
              end;
              roles := copy(roles, 2, length(roles));
              buffer := IntToStr(dmGenData.TMG.Fields[2].Value + 1000) +
                ', ''' + y + ''', ''!dmGenData.TMG' + buffer + ''', ''' +
                dmGenData.TMG.Fields[5].Value + ' (dmGenData.TMG)'', ''' + roles + ''');';
              dmGenData.Query1.SQL.Text := insert + buffer;
              dmGenData.Query1.ExecSQL;
            end;
            dmGenData.TMG.Next;
          end;
          dmGenData.TMG.Active := False;
  end;

begin
  Ini := TIniFile.Create(iniFileName);
  db := ini.ReadString('DB', 'DB', 'Stemma_data');
  if InputQuery(Translation.Items[3], Translation.Items[4], db) then
  begin
    // Créer la base de données          CREATE DATABASE `stemma_data`
    try
      // Avant d'importer le projet, fermer le project actif
      frmStemmaMainForm.Caption := 'Stemma';
      // Fermer toutes les fenêtres ouvertes
      for i := 0 to high(FExtraWindows) do
        if FExtraWindows[i].Parent is TAnchorDockHostSite then
          TAnchorDockHostSite(FExtraWindows[i].Parent).Close
        else
          FExtraWindows[i].Close;

      frmStemmaMainForm.iID := 0;
      MyCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      OpenDialog1.InitialDir := 'C:\';
      OpenDialog1.DefaultExt := '*.Dbf';
      OpenDialog1.Filter := 'Base de données (*.dbf)|*.dbf';
      OpenDialog1.Title := Translation.Items[6];
      if OpenDialog1.Execute then
      begin
        ProgressBar.Visible := True;
        ProgressBar.Max := 300;
        ProgressBar.Position := 0;
        dmGenData.CreateDBProject(db, @RepairProgress);
        // Créer une barre de progression..
        dmGenData.TMG.FilePath :=
          ExcludeTrailingPathDelimiter(ExtractFilePath(OpenDialog1.FileName));
        dmGenData.TMG.FilePathFull := dmGenData.TMG.FilePath;
        filename := ExtractFileName(OpenDialog1.FileName);
        filename := Copy(filename, 1, AnsiPos('_', filename));

        lMaxRecords := dmGenData.CountAllRecordsTMG(filename);
        ProgressBar.Max := lMaxRecords;
        ImportTypes;
        ImportSourceDepotConnection;
        ImportDepots;
        ImportEvents;
        ImportCitations;
        ImportIndividuals;
        ImportPlace;
        ImportWitnesses;
        ImportNames;
        ImportRelations;
        ImportSources;
        ImportDocuments;
      end;
    except
      ShowMessage(Translation.Items[19]);
      dmGenData.SetDBSchema(db, success);
    end;
  end;
  ProgressBar.Visible := False;
  StatusBar.Panels[1].Text := '';
  frmStemmaMainForm.Caption := 'Stemma - ' + dmGenData.GetDBSchema;
  frmStemmaMainForm.iId := dmGenData.GetFirstIndividuum;
  Screen.Cursor := MyCursor;
end;

procedure TfrmStemmaMainForm.IndividuChange(Sender: TObject);
var
  lFullName: string;
  lNewInd: LongInt;
begin
  if dmGenData.IsValidIndividuum(iId) then
  begin
    lFullName := dmGenData.GetIndividuumName(iID);
    // Set Caption of Mainform
    Caption := 'Stemma - ' + dmGenData.GetDBSchema + ' - ' +
      (DecodeName(lFullName, 1)) + ' [' + frmStemmaMainForm.sID + ']';

    lNewInd:=iID;
    UpdateHistoryChInd(OldIndividu.Items, lNewInd);
    UpdateMenuHistory;

    frmNames.PopulateNom(Sender);
    if actWinEvents.Checked then
      dmGenData.EventChanged(Sender);
    if actWinParents.Checked then
      dmGenData.PopulateParents(frmParents.tblParents, frmStemmaMainForm.iID);
    if actWinDocuments.Checked then
      dmGenData.PopulateDocuments(frmDocuments.tblDocuments, 'I', frmStemmaMainForm.iID);
    if actWinChildren.Checked then
      frmChildren.PopulateEnfants(Sender);
    if actWinSiblings.Checked then
      frmSiblings.PopulateFratrie(Sender);
    if actWinAncesters.Checked then
      frmAncestors.PopulateAncetres(Sender);
    if actWinExplorer.Checked then
      frmExplorer.FindIndividual;
    if actWinDescendens.Checked then
      frmDescendants.PopulateDescendants(Sender);
    if actWinImages.Checked then
      if frmDocuments.tblDocuments.RowCount > 1 then
        if frmDocuments.tblDocuments.Cells[1,
          frmDocuments.tblDocuments.Row] = '*' then
          PopulateImage(0)
        else
          PopulateImage(
            StrToInt(frmDocuments.tblDocuments.Cells[0,
            frmDocuments.tblDocuments.Row]))
      else
        PopulateImage(0);
  end
  else
  begin
    if frmStemmaMainForm.iID <> 0 then
    begin
      ShowMessage(format(STheIndividualNotFound,[frmStemmaMainForm.iID]));
      frmStemmaMainForm.iID := PtrInt(OldIndividu.Items.Objects[0]);
    end;
  end;
end;

procedure TfrmStemmaMainForm.JvXPStyleManager1ThemeChanged(Sender: TObject);
begin

end;

procedure TfrmStemmaMainForm.mniParentsClick(Sender: TObject);
begin
  if not (Sender as TMenuItem).Checked then
  begin
    DockMaster.MakeDockable(frmParents, True, True);
    (Sender as TMenuItem).Checked := True;
  end
  else
  begin
    frmParents.Close;
    (Sender as TMenuItem).Checked := False;
  end;
end;

procedure TfrmStemmaMainForm.mniExhibitsClick(Sender: TObject);
begin
  if not (Sender as TMenuItem).Checked then
  begin
    DockMaster.MakeDockable(frmDocuments, True, True);
    (Sender as TMenuItem).Checked := True;
  end
  else
  begin
    frmDocuments.Close;
    (Sender as TMenuItem).Checked := False;
  end;
end;

procedure TfrmStemmaMainForm.mniExplorateurClick(Sender: TObject);
begin

end;

procedure TfrmStemmaMainForm.actWinChildrenExecute(Sender: TObject);
begin
  ToggleVisExtraWindow(Sender, frmChildren);
end;

procedure TfrmStemmaMainForm.actWinSiblingsExecute(Sender: TObject);
begin
  ToggleVisExtraWindow(Sender, frmDocuments);
end;

procedure TfrmStemmaMainForm.actWinAncestersExecute(Sender: TObject);
begin
  ToggleVisExtraWindow(Sender, frmAncestors);
end;

procedure TfrmStemmaMainForm.mniNavNumber18Click(Sender: TObject);
var
  i: string;
begin
  i := InputBox(Translation.Items[20], Translation.Items[21], '');
  try
    if length(i) > 0 then
      if StrToInt(i) > 0 then
        iID := StrToInt(i);
  except
    ShowMessage(Translation.Items[22] + i + Translation.Items[23]);
  end;
end;

procedure TfrmStemmaMainForm.actNavShowHistoryExecute(Sender: TObject);
begin
  frmHistory.ShowModal;
end;

procedure TfrmStemmaMainForm.actWinDescendensExecute(Sender: TObject);
begin
  ToggleVisExtraWindow(Sender, frmDescendants);
end;

procedure TfrmStemmaMainForm.mniNavItem24Click(Sender: TObject);
begin
  if (frmExplorer.grdIndex.Row > 1) then
  begin
    frmExplorer.grdIndex.Row := frmExplorer.grdIndex.Row - 1;
    frmStemmaMainForm.iID := PtrInt(frmExplorer.grdIndex.Objects[1, frmExplorer.grdIndex.Row]);
  end;
end;

procedure TfrmStemmaMainForm.mniNavItem25Click(Sender: TObject);
begin
  if (frmExplorer.grdIndex.Row < frmExplorer.grdIndex.RowCount) then
  begin
    frmExplorer.grdIndex.Row := frmExplorer.grdIndex.Row + 1;
    frmStemmaMainForm.iID := ptrint(frmExplorer.grdIndex.objects[1, frmExplorer.grdIndex.Row]);
  end;
end;

procedure TfrmStemmaMainForm.actWinImagesExecute(Sender: TObject);
begin
  ToggleVisExtraWindow(Sender, FormImage);
end;

procedure TfrmStemmaMainForm.mniUtilItem28Click(Sender: TObject);
begin
  FormSources.ShowModal;
end;

procedure TfrmStemmaMainForm.mniUtilItem29Click(Sender: TObject);
begin
  FormLieux.ShowModal;
end;

procedure TfrmStemmaMainForm.mniUtilItem30Click(Sender: TObject);
begin
  frmRepository.ShowModal;
end;

procedure TfrmStemmaMainForm.mniUtilItem31Click(Sender: TObject);
begin
  frmTypes.ShowModal;
end;

procedure TfrmStemmaMainForm.actAddFatherExecute(Sender: TObject);
begin
  // fr: Ajouter un père
  // en: Add a father to person
  frmEditName.EditType := eNET_AddFather;
  // Code('P',0)
  if frmEditName.Showmodal = mrOk then
    frmStemmaMainForm.iID := frmEditName.I.Value;
end;

procedure TfrmStemmaMainForm.actAddMotherExecute(Sender: TObject);
begin
  // fr: Ajouter une mère
  // en: Add a mother to person
  frmEditName.EditType := eNET_AddMother;
  // Code('M',0)
  if frmEditName.Showmodal = mrOk then
    frmStemmaMainForm.iID := frmEditName.I.Value;
end;

procedure TfrmStemmaMainForm.actAddBrotherExecute(Sender: TObject);

begin
  // Avant d'ajouter vérifier si l'individu sélectionné à au moins un parent principal
  if dmGenData.CheckIndParentExists(frmStemmaMainForm.iID) then
  begin
    // Ajouter un frère
    frmEditName.EditType := eNET_AddBrother;
    // Code('F',0)
    if frmEditName.Showmodal = mrOk then
      frmStemmaMainForm.iID := frmEditName.I.Value;
  end;
end;

procedure TfrmStemmaMainForm.actAddSisterExecute(Sender: TObject);
begin
  // Avant d'ajouter vérifier si l'individu sélectionné à au moins un parent principal
  if dmGenData.CheckIndParentExists(frmStemmaMainForm.iID) then
  begin
    // Ajouter une soeur
    frmEditName.EditType := eNET_AddSister;
    // Code('S',0)
    if frmEditName.Showmodal = mrOk then
      frmStemmaMainForm.iID := frmEditName.I.Value;
  end;
end;

procedure TfrmStemmaMainForm.actAddSonExecute(Sender: TObject);

begin
  with FormSelectPersonne.Liste do begin
  RowCount := 2;
    Cells[0, RowCount - 1] := '0';
    Cells[1, RowCount - 1] :=
      Translation.Items[317];
  end;
  dmGenData.AppendSiblings(FormSelectPersonne.Liste, frmStemmaMainForm.iID);
  // fr: Sélectionne toutes les autres personnes en union avec cette personne
  // en: Selects all the other people in union with this person
  dmGenData.AppendSpousesSpouses(FormSelectPersonne.Liste, frmStemmaMainForm.iID);

  if FormSelectPersonne.Showmodal = mrOk then
  begin
    // Ajouter un fils
    //     dmGenData.PutCode('I',FormSelectPersonne.edtNumber.text);
    //     dmGenData.PutCode('A',0);
    frmEditName.EditType := eNET_AddSister;
    if frmEditName.Showmodal = mrOk then
      frmStemmaMainForm.iID := frmEditName.I.Value;
  end;
end;

procedure TfrmStemmaMainForm.mniAddItem38Click(Sender: TObject);

begin
  with FormSelectPersonne.Liste do begin
  RowCount := 2;
    Cells[0, RowCount - 1] := '0';
    Cells[1, RowCount - 1] :=
      Translation.Items[317];
  end;
  // Sélectionne toutes les autres personnes ayant des enfants principaux avec cette personne
  dmGenData.AppendSiblings(FormSelectPersonne.Liste, frmStemmaMainForm.iID);
  // Sélectionne toutes les autres personnes en union avec cette personne
  dmGenData.AppendSpousesSpouses(FormSelectPersonne.Liste, frmStemmaMainForm.iID);

  if FormSelectPersonne.Showmodal = mrOk then
  begin
    // Ajouter un fille
    //     dmGenData.PutCode('L',FormSelectPersonne.edtNumber.text);
    //     dmGenData.PutCode('A',0);
    frmEditName.EditType := eNET_AddDaughter;
    if frmEditName.Showmodal = mrOk then
      frmStemmaMainForm.iID := frmEditName.I.Value;
  end;
end;

procedure TfrmStemmaMainForm.mniAddItem40Click(Sender: TObject);
begin
  // fr: Ajoute la naissance
  //  dmGenData.PutCode('A', 'N');
  frmEditEvents.EditType := eEET_AddBirth;
  if frmEditEvents.Showmodal = mrOk then;
end;

procedure TfrmStemmaMainForm.mniAddItem41Click(Sender: TObject);
begin
  // fr: Ajoute le baptême
  //  dmGenData.PutCode('A', 'B');
  frmEditEvents.EditType := eEET_AddBaptism;
  if frmEditEvents.Showmodal = mrOk then;

end;

procedure TfrmStemmaMainForm.mniAddItem42Click(Sender: TObject);
begin
  // fr: Ajoute le décès
  //  dmGenData.PutCode('A', 'D');
  frmEditEvents.EditType := eEET_AddDeath;
  if frmEditEvents.Showmodal = mrOk then;

end;

procedure TfrmStemmaMainForm.mniAddItem43Click(Sender: TObject);
begin
  // fr: Ajoute la sépulture
  // dmGenData.PutCode('A', 'S');
  frmEditEvents.EditType := eEET_AddBurial;
  if frmEditEvents.Showmodal = mrOk then;

end;

procedure TfrmStemmaMainForm.actAddSpouseExecute(Sender: TObject);

var
  cSex: string;
begin
  // fr: Ajouter un conjoint, le sexe ne doit pas être '?'
  cSex := dmGenData.GetSexOfInd(frmStemmaMainForm.iID);
  if not (cSex = '?') then
  begin
    // fr: Ajouter un conjoint
    //     if (cSex='M') then
    //        dmGenData.PutCode('J','F')
    //     else
    //        dmGenData.PutCode('J','M');
    //     dmGenData.PutCode('A',0);
    frmEditName.EditType := eNET_AddSpouse;
    if frmEditName.Showmodal = mrOk then
      frmStemmaMainForm.iID := frmEditName.I.Value;
  end;
end;

procedure TfrmStemmaMainForm.mniEditCopyNameClick(Sender: TObject);
var
  i1, i2, i3, i4: string;
  LastNID, lidName: longint;

begin
  // Copier nom
  if mniNoms.Checked then
  begin
    lidName:=frmNames.idName;
    LastNID := dmGenData.CopyName(lidName, i4, i3, i2, i1);
    dmGenData.CopyCitation('N', lidName, LastNID);
    // fr: Ajoute le nom dans l'explorateur...
    // en: Add Name to Explorer ...
    if actWinExplorer.Checked then
      frmExplorer.AddNameToExplorer(i1, i2, i3, i4);
    dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
    frmNames.PopulateNom(Sender);
  end;
end;

procedure TfrmStemmaMainForm.MenuItem47Click(Sender: TObject);
var
  i1, i2, i3, i4: string;
  nouveau: integer;
begin
  // Copier individu
  nouveau := dmGenData.CopyIndividual(frmStemmaMainForm.iID);
  // Copie toutes les relations
  dmGenData.Query1.SQL.Text := 'SELECT Y, A, B, M, P, X, SD, no FROM R WHERE A=' +
    frmStemmaMainForm.sID + ' OR B=' + frmStemmaMainForm.SID;
  dmGenData.Query1.Open;
  while not dmGenData.Query1.EOF do
  begin
    dmGenData.Query2.SQL.Clear;
    if dmGenData.Query1.Fields[1].AsInteger = frmStemmaMainForm.iID then
    begin
      dmGenData.Query2.SQL.Add('INSERT IGNORE INTO R (Y, A, B, M, P, X, SD) VALUES (' +
        dmGenData.Query1.Fields[0].AsString + ', ' + IntToStr(nouveau) +
        ', ' + dmGenData.Query1.Fields[2].AsString + ', ''' +
        AutoQuote(dmGenData.Query1.Fields[3].AsString) +
        ''', ''' + AutoQuote(dmGenData.Query1.Fields[4].AsString) + ''', ' + dmGenData.Query1.Fields[5].AsString +
        ', ''' + AutoQuote(dmGenData.Query1.Fields[6].AsString) + ''')');
      dmGenData.Query4.SQL.Clear;
      dmGenData.Query4.SQL.Add('UPDATE I SET date=''' +
        FormatDateTime('YYYYMMDD', now) + ''' WHERE no=' +
        dmGenData.Query1.Fields[2].AsString);
      dmGenData.Query4.ExecSQL;
    end
    else
    begin
      dmGenData.Query2.SQL.Add('INSERT IGNORE INTO R (Y, A, B, M, P, X, SD) VALUES (' +
        dmGenData.Query1.Fields[0].AsString + ', ' +
        dmGenData.Query1.Fields[1].AsString + ', ' + IntToStr(nouveau) +
        ', ''' + AutoQuote(dmGenData.Query1.Fields[3].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[4].AsString) + ''', ' + dmGenData.Query1.Fields[5].AsString +
        ', ''' + AutoQuote(dmGenData.Query1.Fields[6].AsString) + ''')');
      dmGenData.Query4.SQL.Clear;
      dmGenData.Query4.SQL.Add('UPDATE I SET date=''' +
        FormatDateTime('YYYYMMDD', now) + ''' WHERE no=' +
        dmGenData.Query1.Fields[1].AsString);
      dmGenData.Query4.ExecSQL;
    end;
    dmGenData.Query2.ExecSQL;
    dmGenData.Query2.SQL.Text := 'SHOW TABLE STATUS WHERE NAME=''R''';
    dmGenData.Query2.Open;
    dmGenData.Query2.First;
    dmGenData.Query3.SQL.Text := 'SELECT Y, N, S, Q, M FROM C WHERE Y=''R'' AND N=' +
      dmGenData.Query1.Fields[7].AsString;
    dmGenData.Query3.Open;
    while not dmGenData.Query3.EOF do
    begin
      dmGenData.Query4.SQL.Clear;
      dmGenData.Query4.SQL.Add('INSERT IGNORE INTO C (Y, N, S, Q, M) VALUES (''' +
        dmGenData.Query3.Fields[0].AsString + ''', ' +
        IntToStr(dmGenData.Query2.Fields[10].AsInteger - 1) + ', ' +
        dmGenData.Query3.Fields[2].AsString + ', ' +
        dmGenData.Query3.Fields[3].AsString + ', ''' + AutoQuote(dmGenData.Query3.Fields[4].AsString) + ''')');
      dmGenData.Query4.ExecSQL;
      dmGenData.Query3.Next;
    end;
    dmGenData.Query1.Next;
  end;
  // Copie tous les noms
  dmGenData.Query1.SQL.Text :=
    'SELECT I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4, no FROM N WHERE I=' +
    frmStemmaMainForm.sID;
  dmGenData.Query1.Open;
  while not dmGenData.Query1.EOF do
  begin
    i1 := dmGenData.Query1.Fields[8].AsString;
    i2 := dmGenData.Query1.Fields[9].AsString;
    i3 := dmGenData.Query1.Fields[10].AsString;
    i4 := dmGenData.Query1.Fields[11].AsString;
    dmGenData.Query2.SQL.Clear;
    dmGenData.Query2.SQL.Add(
      'INSERT IGNORE INTO N (I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4) VALUES (' +
      IntToStr(nouveau) + ', ' + dmGenData.Query1.Fields[1].AsString +
      ', ''' + AutoQuote(dmGenData.Query1.Fields[2].AsString) + ''', ' + dmGenData.Query1.Fields[3].AsString +
      ', ''' + AutoQuote(dmGenData.Query1.Fields[4].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[5].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[6].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[7].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[8].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[9].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[10].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[11].AsString) + ''')');
    dmGenData.Query2.ExecSQL;
    dmGenData.Query2.SQL.Text := 'SHOW TABLE STATUS WHERE NAME=''N''';
    dmGenData.Query2.Open;
    dmGenData.Query2.First;
    dmGenData.Query3.SQL.Text := 'SELECT Y, N, S, Q, M FROM C WHERE Y=''N'' AND N=' +
      dmGenData.Query1.Fields[12].AsString;
    dmGenData.Query3.Open;
    while not dmGenData.Query3.EOF do
    begin
      dmGenData.Query4.SQL.Clear;
      dmGenData.Query4.SQL.Add('INSERT IGNORE INTO C (Y, N, S, Q, M) VALUES (''' +
        dmGenData.Query3.Fields[0].AsString + ''', ' +
        IntToStr(dmGenData.Query2.Fields[10].AsInteger - 1) + ', ' +
        dmGenData.Query3.Fields[2].AsString + ', ' +
        dmGenData.Query3.Fields[3].AsString + ', ''' + AutoQuote(dmGenData.Query3.Fields[4].AsString) + ''')');
      dmGenData.Query4.ExecSQL;
      dmGenData.Query3.Next;
    end;
    // Ajoute le nom dans l'explorateur...
    if mniExplorateur.Checked then
       frmExplorer.AddNameToExplorer(i1,i2,i3,i4);
    dmGenData.Query1.Next;
  end;
  // Copie tous les documents
  dmGenData.Query1.SQL.Text := 'SELECT X, T, D, F, Z, A, N FROM X WHERE A=''I'' AND N=' +
    frmStemmaMainForm.sID;
  dmGenData.Query1.Open;
  while not dmGenData.Query1.EOF do
  begin
    dmGenData.Query2.SQL.Clear;
    dmGenData.Query2.SQL.Add('INSERT IGNORE INTO X (X, T, D, F, Z, A, N) VALUES (' +
      dmGenData.Query1.Fields[0].AsString + ', ''' + AutoQuote(dmGenData.Query1.Fields[1].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[2].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[3].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[4].AsString) + ''', ''' + 'I' + ''', ' + IntToStr(nouveau) + ')');
    dmGenData.Query2.ExecSQL;
    dmGenData.Query1.Next;
  end;
  // Copie tous les événements
  dmGenData.Query1.SQL.Text :=
    'SELECT E.Y, E.PD, E.SD, E.L, E.M, E.X, E.no FROM E JOIN W on E.no=W.E WHERE W.I=' +
    frmStemmaMainForm.sID;
  dmGenData.Query1.Open;
  while not dmGenData.Query1.EOF do
  begin
    dmGenData.Query2.SQL.Clear;
    dmGenData.Query2.SQL.Add('INSERT IGNORE INTO E (Y, PD, SD, L, M, X) VALUES (' +
      dmGenData.Query1.Fields[0].AsString + ', ''' + AutoQuote(dmGenData.Query1.Fields[1].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[2].AsString) + ''', ' + dmGenData.Query1.Fields[3].AsString +
      ', ''' + AutoQuote(dmGenData.Query1.Fields[4].AsString) + ''', ' + dmGenData.Query1.Fields[5].AsString + ')');
    dmGenData.Query2.ExecSQL;
    dmGenData.Query2.SQL.Text := 'SHOW TABLE STATUS WHERE NAME=''E''';
    dmGenData.Query2.Open;
    dmGenData.Query2.First;
    dmGenData.Query3.SQL.Text := 'SELECT Y, N, S, Q, M FROM C WHERE Y=''E'' AND N=' +
      dmGenData.Query1.Fields[6].AsString;
    dmGenData.Query3.Open;
    while not dmGenData.Query3.EOF do
    begin
      dmGenData.Query4.SQL.Clear;
      dmGenData.Query4.SQL.Add('INSERT IGNORE INTO C (Y, N, S, Q, M) VALUES (''' +
        dmGenData.Query3.Fields[0].AsString + ''', ' +
        IntToStr(dmGenData.Query2.Fields[10].AsInteger - 1) + ', ' +
        dmGenData.Query3.Fields[2].AsString + ', ' +
        dmGenData.Query3.Fields[3].AsString + ', ''' + AutoQuote(dmGenData.Query3.Fields[4].AsString) + ''')');
      dmGenData.Query4.ExecSQL;
      dmGenData.Query3.Next;
    end;
    dmGenData.Query3.SQL.Text := 'SELECT X, T, D, F, Z FROM X WHERE A=''E'' AND N=' +
      dmGenData.Query1.Fields[6].AsString;
    dmGenData.Query3.Open;
    while not dmGenData.Query3.EOF do
    begin
      dmGenData.Query4.SQL.Clear;
      dmGenData.Query4.SQL.Add('INSERT IGNORE INTO X (X, T, D, F, Z, A, N) VALUES (' +
        '0' + ', ''' + AutoQuote(dmGenData.Query3.Fields[1].AsString) + ''', ''' + AutoQuote(dmGenData.Query3.Fields[2].AsString) + ''', ''' + AutoQuote(dmGenData.Query3.Fields[3].AsString) + ''', ''' + AutoQuote(dmGenData.Query1.Fields[4].AsString) + ''', ''E'', ' + IntToStr(
        dmGenData.Query2.Fields[10].AsInteger - 1) + ')');
      dmGenData.Query4.ExecSQL;
      dmGenData.Query3.Next;
    end;
    dmGenData.Query3.SQL.Text := 'SELECT I, E, X, P, R FROM W WHERE E=' +
      dmGenData.Query1.Fields[6].AsString;
    dmGenData.Query3.Open;
    while not dmGenData.Query3.EOF do
    begin
      dmGenData.Query4.SQL.Clear;
      if frmStemmaMainForm.iID = dmGenData.Query3.Fields[0].AsInteger then
        dmGenData.Query4.SQL.Add('INSERT IGNORE INTO W (I, E, X, P, R) VALUES (' +
          IntToStr(nouveau) + ', ' +
          IntToStr(dmGenData.Query2.Fields[10].AsInteger - 1) + ', ' +
          dmGenData.Query3.Fields[2].AsString + ', ''' + AutoQuote(dmGenData.Query3.Fields[3].AsString) + ''', ''' + AutoQuote(dmGenData.Query3.Fields[4].AsString) + ''')')
      else
        dmGenData.Query4.SQL.Add('INSERT IGNORE INTO W (I, E, X, P, R) VALUES (' +
          dmGenData.Query3.Fields[0].AsString + ', ' +
          IntToStr(dmGenData.Query2.Fields[10].AsInteger - 1) + ', ' +
          dmGenData.Query3.Fields[2].AsString + ', ''' + AutoQuote(dmGenData.Query3.Fields[3].AsString) + ''', ''' + AutoQuote(dmGenData.Query3.Fields[4].AsString) + ''')');
      dmGenData.Query4.ExecSQL;
      dmGenData.Query4.SQL.Clear;
      dmGenData.Query4.SQL.Add('UPDATE I SET date=''' +
        FormatDateTime('YYYYMMDD', now) + ''' WHERE no=' +
        dmGenData.Query3.Fields[0].AsString);
      dmGenData.Query4.ExecSQL;
      dmGenData.Query3.Next;
    end;
    dmGenData.Query1.Next;
  end;
  dmGenData.SaveModificationTime(nouveau);
  frmStemmaMainForm.iID := nouveau;
end;

procedure TfrmStemmaMainForm.actHelpAboutExecute(Sender: TObject);
begin
  apropos.Showmodal;
end;

procedure TfrmStemmaMainForm.mniAddItem50Click(Sender: TObject);
begin
  // Ajouter un individu non-relié
  //  dmGenData.PutCode('R',0);
  //  dmGenData.PutCode('A',0);
  frmEditName.EditType := eNET_NewUnrelated;
  if frmEditName.Showmodal = mrOk then
    frmStemmaMainForm.iID := frmEditName.I.Value;
end;

procedure TfrmStemmaMainForm.MenuItem53Click(Sender: TObject);
var
  valide: boolean;
begin
  // fr: Suppression de personne
  // en: Delete Person
  valide := not dmGenData.CheckIndSharedEventExists(frmStemmaMainForm.iID);

  valide := valide and not dmGenData.CheckIndRelationExist(frmStemmaMainForm.iID);

  valide := valide and not dmGenData.CheckIndDepositExist(frmStemmaMainForm.iID);

  valide := valide and not dmGenData.CheckIndSourceExist(frmStemmaMainForm.iID);
  if not valide then
  begin
    Application.MessageBox(PChar(Translation.Items[307]),
      PChar(Translation.Items[124]), MB_OK);
  end
  else
  begin
    dmGenData.Query1.SQL.Text := 'SELECT N.N FROM N WHERE N.X=1 AND N.I=' +
      frmStemmaMainForm.sID;
    dmGenData.Query1.Open;
    if MessageDlg(SConfirmation,format(SAreYouSureToDelete,
     [DecodeName(dmGenData.Query1.Fields[0].AsString, 1)]),mtConfirmation,mbYesNo,0) = mrYes then
    begin
      // Supprime la personne
      dmGenData.Query1.SQL.Text := 'DELETE FROM I WHERE no=' + frmStemmaMainForm.sID;
      dmGenData.Query1.ExecSQL;
      // Supprime ses noms
      dmGenData.Query1.SQL.Text := 'SELECT N.no FROM N WHERE I=' + frmStemmaMainForm.sID;
      dmGenData.Query1.Open;
      while not dmGenData.Query1.EOF do
      begin
        dmGenData.Query2.SQL.Text := 'DELETE FROM C WHERE Y=''N'' AND N=' +
          dmGenData.Query1.Fields[0].AsString;
        dmGenData.Query2.ExecSQL;
        dmGenData.Query1.Next;
      end;
      dmGenData.Query1.SQL.Text := 'DELETE FROM N WHERE I=' + frmStemmaMainForm.sID;
      dmGenData.Query1.ExecSQL;
      // supprime ses événements
      dmGenData.Query1.SQL.Text := 'SELECT E.no FROM E JOIN W ON W.E=E.no WHERE W.I=' +
        frmStemmaMainForm.sID;
      dmGenData.Query1.Open;
      while not dmGenData.Query1.EOF do
      begin
        dmGenData.Query2.SQL.Text := 'DELETE FROM C WHERE Y=''E'' AND N=' +
          dmGenData.Query1.Fields[0].AsString;
        dmGenData.Query2.ExecSQL;
        dmGenData.Query2.SQL.Text := 'DELETE FROM X WHERE A=''E'' AND N=' +
          dmGenData.Query1.Fields[0].AsString;
        dmGenData.Query2.ExecSQL;
        dmGenData.Query2.SQL.Text := 'DELETE FROM W WHERE E=' +
          dmGenData.Query1.Fields[0].AsString;
        dmGenData.Query2.ExecSQL;
        dmGenData.Query2.SQL.Text := 'DELETE FROM E WHERE no=' +
          dmGenData.Query1.Fields[0].AsString;
        dmGenData.Query2.ExecSQL;
        dmGenData.Query1.Next;
      end;
      // Supprime ses documents
      dmGenData.Query1.SQL.Text := 'DELETE FROM X WHERE X.A=''I'' AND X.N=' +
        frmStemmaMainForm.sID;
      dmGenData.Query1.ExecSQL;
      // Supprime ses relations
      dmGenData.Query1.SQL.Clear;
      dmGenData.Query1.SQL.Add('SELECT R.no FROM R WHERE (R.A=' +
        frmStemmaMainForm.sID + ' OR R.B=' + frmStemmaMainForm.sID + ')');
      dmGenData.Query1.Open;
      while not dmGenData.Query1.EOF do
      begin
        dmGenData.Query2.SQL.Text := 'DELETE FROM C WHERE Y=''R'' AND N=' +
          dmGenData.Query1.Fields[0].AsString;
        dmGenData.Query2.ExecSQL;
        dmGenData.Query1.Next;
      end;
      dmGenData.Query1.SQL.Clear;
      dmGenData.Query1.SQL.Add('DELETE FROM R WHERE (R.A=' +
        frmStemmaMainForm.sID + ' OR R.B=' + frmStemmaMainForm.sID + ')');
      dmGenData.Query1.ExecSQL;
      // Change d'individu vers l'avant dernière personne
      if OldIndividu.Items.Count <= 1 then
        frmStemmaMainForm.iId := dmGenData.GetFirstIndividuum
      else
        frmStemmaMainForm.iID := mniNavOld1.tag;
    end;
  end;
end;

procedure TfrmStemmaMainForm.MenuItem55Click(Sender: TObject);

begin
  // fr: Copier Événement
  // en: Copy Event

  if mniEvenements.Checked then
  begin

    dmGenData.CopyEvent(frmEvents.idEvent);
  end;
end;

procedure TfrmStemmaMainForm.MenuItem58Click(Sender: TObject);
var
  ini: TIniFile;
begin
  OpenDialog1.InitialDir := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  OpenDialog1.DefaultExt := '*.data';
  OpenDialog1.Filter := Translation.Items[306] + ' (*.data)|*.data';
  OpenDialog1.Title := Translation.Items[141];
  if OpenDialog1.Execute then
  begin
    Translation.LoadFromFile(OpenDialog1.FileName);
    Ini := TIniFile.Create(iniFileName);
    Ini.WriteString('Parametres', 'Langue', ExtractFileName(OpenDialog1.FileName));
    Ini.Free;
  end;
end;

procedure TfrmStemmaMainForm.MenuItem57Click(Sender: TObject);
var
  ini: TIniFile;
  sExeExt: RawByteString;
begin
  Ini := TIniFile.Create(iniFileName);
  OpenDialog1.InitialDir := ExcludeTrailingPathDelimiter(
    ExtractFilePath(ini.ReadString('Parametres', 'PDF',
    'C:\Program Files (x86)\Adobe\Reader 10.0\Reader\AcroRd32.exe')));
  sExeExt := ExtractFileExt(ParamStr(0));
  OpenDialog1.DefaultExt := sExeExt;
  OpenDialog1.Filter := Translation.Items[305] + ' (*' + sExeExt + ')|*' + sExeExt;
  OpenDialog1.Title := Translation.Items[304];
  if OpenDialog1.Execute then
  begin
    Ini.WriteString('Parametres', 'PDF', OpenDialog1.FileName);
  end;
  Ini.Free;
end;

procedure TfrmStemmaMainForm.MenuItem59Click(Sender: TObject);

begin
  // Copier Parent
  if actWinParents.Checked then
    frmParents.CopyParent(Sender);
end;

procedure TfrmStemmaMainForm.actFileCloseProjectExecute(Sender: TObject);
var
  LastRID: longint;
  lidRelation, lidInd, lidNewInd: integer;
begin
  // Copier Enfant
  if mniEnfants.Checked then
  begin
    lidRelation := frmChildren.idRelation;
    lidInd := frmChildren.idChild;

    lidNewInd := dmGenData.CopyIndividual(lidInd);

    LastRID := dmGenData.CopyRelation(lidRelation, lidNewInd);

    // en: Copy Citation
    dmGenData.CopyCitation('R', lidRelation, LastRID);

    frmChildren.PopulateEnfants(Sender);
    dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
  end;
end;

procedure TfrmStemmaMainForm.MenuItem61Click(Sender: TObject);
var
  i: integer;
begin
  // Fermer projet
  dmGenData.DB_Connected := False;
  frmStemmaMainForm.Caption := 'Stemma';
  // Fermer toutes les fenêtres ouvertes
  for i := 0 to high(FExtraWindows) do
    if FExtraWindows[i].Parent is TAnchorDockHostSite then
      TAnchorDockHostSite(FExtraWindows[i].Parent).Close
    else
      FExtraWindows[i].Close;
  frmStemmaMainForm.iID := 0;
end;

procedure TfrmStemmaMainForm.actFileExportToWebsiteExecute(Sender: TObject);
var
  MyCursor: Tcursor;
  time_delay: integer;
  server, db, user, password, drive: string;
  Ini: Tinifile;
  continue: boolean;
  lOnProgress: TNotifyEvent;
  lSPanel: TStatusPanel;

begin
  Ini := TIniFile.Create(iniFileName);
  time_delay := 1000;
  // Demander ces variables et enregistrer dans IniFiles
  server := ini.ReadString('Webexport', 'server', 'localhost');
  continue := InputQuery(Translation.Items[327], Translation.Items[328], server);
  if continue then
  begin
    db := ini.ReadString('Webexport', 'db', 'genealo_data');
    continue := InputQuery(Translation.Items[329], Translation.Items[330], db);
    if continue then
    begin
      user := ini.ReadString('Webexport', 'user', 'root');
      continue := InputQuery(Translation.Items[331], Translation.Items[332], user);
      if continue then
      begin
        password := ini.ReadString('Webexport', 'password', '');
        continue := InputQuery(Translation.Items[333],
          Translation.Items[334], password);
        if continue then
        begin
          SelectDirectoryDialog1.InitialDir := ini.ReadString('Webexport', 'dir', '');
          SelectDirectoryDialog1.Title := Translation.Items[326];
          continue := SelectDirectoryDialog1.Execute;
        end;
      end;
    end;
  end;
  if continue then
  begin
    ProgressBar.Visible := True;
    ProgressBar.Max := 0;
    ProgressBar.Position := 1;
    lOnProgress:=@UpdateProgressBar;
      drive := SelectDirectoryDialog1.FileName;
  Ini.WriteString('Webexport', 'dir', drive);
  Ini.WriteString('Webexport', 'server', server);
  Ini.WriteString('Webexport', 'db', db);
  Ini.WriteString('Webexport', 'user', user);
  Ini.WriteString('Webexport', 'password', password);
  Ini.Free;
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    lSPanel := StatusBar.Panels[1];
  lSPanel.Text := Translation.Items[323];

    ExportToWebsite(lOnProgress, password, user, db, server,'',lSPanel, time_delay);

  finally
    Screen.Cursor := MyCursor;
    ProgressBar.Visible := False;
  end;
  end;
end;

procedure TfrmStemmaMainForm.mniUtilItem65Click(Sender: TObject);
var
  MyCursor: Tcursor;
begin  //fr: Compression de base de données
  //de: Datenbank comprimieren
  //en: compress database
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ProgressBar.Visible := True;
  ProgressBar.Max := 12;
  ProgressBar.Position := 0;
  dmGenData.RepairProjectDB(@RepairProgress);
  ProgressBar.Visible := False;
  Screen.Cursor := MyCursor;
end;

procedure TfrmStemmaMainForm.mniUtilItem66Click(Sender: TObject);
var
  MyCursor: Tcursor;
begin  // Repair Birth-Death
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ProgressBar.Visible := True;

  dmGenData.RepairIndBirthDeath(@RepairProgress);
  ProgressBar.Visible := False;
  if frmStemmaMainForm.actWinExplorer.Checked then
  begin
    frmExplorer.PopulateIndex(StrToInt(frmExplorer.O.Text));
    frmExplorer.FindIndividual;
  end;
  Screen.Cursor := MyCursor;
end;

procedure TfrmStemmaMainForm.mniUtilItem67Click(Sender: TObject);
begin
  { TODO : Nettoyage des records orphelins }
end;

procedure TfrmStemmaMainForm.mniUtilItem68Click(Sender: TObject);
var
  MyCursor: Tcursor;
  i1, i2: string;
  pos1, pos2: integer;
begin
  // Réparation nom pour tri (I1, I2 + Remove UTF8)
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ProgressBar.Visible := True;
  dmGenData.Query1.SQL.Text := 'SELECT no, I, N FROM N';
  dmGenData.Query1.Open;
  ProgressBar.Position := 0;
  ProgressBar.Max := dmGenData.Query1.RecordCount;
  while not dmGenData.Query1.EOF do
  begin
    if Copy(dmGenData.Query1.Fields[2].AsString, 1, 4) = '!TMG' then
    begin
      i1 := RemoveUTF8(ExtractDelimited(
        2, dmGenData.Query1.Fields[2].AsString, ['|']));
      i2 := RemoveUTF8(ExtractDelimited(
        4, dmGenData.Query1.Fields[2].AsString, ['|']));
    end
    else
    begin
      Pos1 := AnsiPos('<' + CTagNameFamilyName + '>',
        dmGenData.Query1.Fields[2].AsString) + length(CTagNameFamilyName) + 2;
      Pos2 := AnsiPos('</' + CTagNameFamilyName + '>',
        dmGenData.Query1.Fields[2].AsString);
      if (Pos1 + Pos2) > length(CTagNameFamilyName) + 2 then
        i1 := RemoveUTF8(Copy(dmGenData.Query1.Fields[2].AsString,
          Pos1, Pos2 - Pos1));
      Pos1 := AnsiPos('<' + CTagNameGivenName + '>',
        dmGenData.Query1.Fields[2].AsString) + length(CTagNameGivenName) + 2;
      // 9 car le 'é' prends 2 position en ANSI
      Pos2 := AnsiPos('</' + CTagNameGivenName + '>',
        dmGenData.Query1.Fields[2].AsString);
      if (Pos1 + Pos2) > length(CTagNameGivenName) + 2 then
        i2 := RemoveUTF8(Copy(dmGenData.Query1.Fields[2].AsString,
          Pos1, Pos2 - Pos1));
    end;
    dmGenData.Query4.SQL.Clear;
    dmGenData.Query4.SQL.Add('UPDATE N SET I1=''' +
      (AutoQuote(UTF8toANSI(i1))) + ''', I2=''' + (AutoQuote(UTF8toANSI(i2))) + ''' WHERE no=' + dmGenData.Query1.Fields[0].AsString);
    dmGenData.Query4.ExecSQL;
    dmGenData.Query1.Next;
    ProgressBar.Position := ProgressBar.Position + 1;
    Application.ProcessMessages;
  end;
  ProgressBar.Visible := False;
  if frmStemmaMainForm.actWinExplorer.Checked then
  begin
    frmExplorer.PopulateIndex(StrToInt(frmExplorer.O.Text));
    frmExplorer.FindIndividual;
  end;
  Screen.Cursor := MyCursor;
end;

procedure TfrmStemmaMainForm.mniUtilItem69Click(Sender: TObject);
var
  MyCursor: Tcursor;
begin
  // RÉPARE LES DATES DE TRI DE RELATIONS
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ProgressBar.Visible := True;
  ProgressBar.Position := 0;
  dmGenData.RepairRelDateByIndDate(@UpdateProgressBar);
  ProgressBar.Visible := False;
  Screen.Cursor := MyCursor;
end;

procedure TfrmStemmaMainForm.mniEvenementsClick(Sender: TObject);
begin
  ToggleVisExtraWindow(Sender, frmEvents);
end;

procedure TfrmStemmaMainForm.OldClick(Sender: TObject);
begin
  if (Sender as TMenuItem).tag > 0 then
    iID := (Sender as TMenuItem).tag;
end;

procedure TfrmStemmaMainForm.actFileDeleteProjectExecute(Sender: TObject);
var
  db: string;
  i: integer;
begin
  db := '';
  if InputQuery(Translation.Items[3], Translation.Items[24], db) then
  begin
    if (dmGenData.DB_Connected and (AnsiCompareStr(db, dmGenData.GetDBSchema) = 0)) then
    begin
      frmStemmaMainForm.Caption := 'Stemma';
      // Fermer toutes les fenêtres ouvertes
      for i := 0 to high(FExtraWindows) do
        if FExtraWindows[i].Parent is TAnchorDockHostSite then
          TAnchorDockHostSite(FExtraWindows[i].Parent).Close
        else
          FExtraWindows[i].Close;

      frmStemmaMainForm.iID := 0;
      dmGenData.DeleteDBProject(db);
      dmGenData.DB_Connected := False;
    end;
  end;
end;

procedure TfrmStemmaMainForm.mniNomsClick(Sender: TObject);
begin
  ToggleVisExtraWindow(Sender, frmNames);
end;

procedure TfrmStemmaMainForm.actFileOpenExecute(Sender: TObject);
var
  db, odb: string;
  i, liID: integer;
  success, lconnected: boolean;
  sList: TStrings;
begin
  dmGenData.ReadCfgProject(odb,lconnected);
  sList:=TStringList.Create;
  try
  dmGenData.GetDBSchemas(sList);
  db:=odb;
  if SelectDialog(Translation.Items[3], Translation.Items[25],Slist, db) then
  begin
    try
      // Avant d'ouvrir le projet, fermer le project actif
      frmStemmaMainForm.Caption := 'Stemma';
      // Fermer toutes les fenêtres ouvertes
      for i := 0 to high(FExtraWindows) do
        if FExtraWindows[i].Parent is TAnchorDockHostSite then
          TAnchorDockHostSite(FExtraWindows[i].Parent).Close
        else
          FExtraWindows[i].Close;

      frmStemmaMainForm.iID := 0;
      dmGenData.SetDBSchema(db, success);
      if success then
      begin
        { TODO 12 : Doit vérifier si c'est le bon format... - fonction car utilisée à plus d'un endroi }
        frmStemmaMainForm.Caption := 'Stemma - ' + dmGenData.GetDBSchema;

        if odb = db then
          begin
            dmGenData.ReadCfgLastPerson(liID);
            iiD:=liID;
          end
        else
          frmStemmaMainForm.iId := dmGenData.GetFirstIndividuum;

        dmGenData.WriteCfgProject(db,lconnected);

        for i := 0 to high(FExtraWindows) do
          if dmGenData.ReadCfgInteger(CIniKeyWindow, FExtraWindows[i].Name, 0) = 1 then
            ToggleVisExtraWindow(self, FExtraWindows[i]);
      end;
    except
      ShowMessage(Translation.Items[26]);
    end;
  end;
  finally
    freeandnil(sList);
  end;
end;


end.
