unit Frm_DockingMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus, ExtCtrls, ActnList, StdActns, Frm_Aboutbox, DOM, XMLConf;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    AboutBox1: TAboutBox;
    CoolBar1: TCoolBar;
    HelpAbout1: TAction;
    lblVersion: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    tlb_Exit: TToolButton;
    tlb_New: TToolButton;
    tlb_OInspector: TToolButton;
    tlb_Open: TToolButton;
    tlb_ProExplorer: TToolButton;
    tlb_Save: TToolButton;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ViewLibrary1: TAction;
    mnuObjectExp: TMenuItem;
    mnuDetails: TMenuItem;
    mnuLibrary: TMenuItem;
    mnuSpl1: TMenuItem;
    mnuHelp: TMenuItem;
    mnuAbout: TMenuItem;
    ViewDetails1: TAction;
    ViewObjectInspector1: TAction;
    mnuFileExit: TMenuItem;
    mnuProjectExp: TMenuItem;
    mnuFileNew: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuFileOpenWith: TMenuItem;
    mnuSave: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuFileSpl1: TMenuItem;
    ViewProjectInspector1: TAction;
    FileExit1: TFileExit;
    FileSave1: TAction;
    FileNew1: TAction;
    ActionList1: TActionList;
    FileOpen1: TFileOpen;
    FileOpenWith1: TFileOpenWith;
    FileSaveAs1: TFileSaveAs;
    ImageList1: TImageList;
    mmnMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuEdit: TMenuItem;
    mnuView: TMenuItem;
    XMLConfig1: TXMLConfig;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Accept(Sender: TObject);
    procedure FileOpen1BeforeExecute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileSave1Update(Sender: TObject);
    procedure FileSaveAs1Accept(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure lblVersionResize(Sender: TObject);
    procedure ViewDetails1Execute(Sender: TObject);
    procedure ViewDetails1Update(Sender: TObject);
    procedure ViewLibrary1Execute(Sender: TObject);
    procedure ViewLibrary1Update(Sender: TObject);
    procedure ViewObjectInspector1Execute(Sender: TObject);
    procedure ViewObjectInspector1Update(Sender: TObject);
    procedure ViewProjectInspector1Execute(Sender: TObject);
    procedure ViewProjectInspector1Update(Sender: TObject);
  private
    FProjectFile: TXMLDocument;
    FPFilename: string;
    FChanged: boolean;
    FStatusBar1: TStatusBar;
    procedure DockMasterCreateControl(Sender: TObject; aName: string;
      var AControl: TControl; DoDisableAutoSizing: boolean);
    procedure SetStatusBar1(AValue: TStatusBar);
    { private declarations }

  public
    { public declarations }
    property StatusBar1: TStatusBar read FStatusBar1 write SetStatusBar1;
  end;

var
  frmMain: TfrmMain;

implementation

uses AnchorDocking, AnchorDockOptionsDlg, frm_ProjektExplorer,
  frm_ObjectInspector, frm_StatusBar, frm_ViewDetails, frm_Library, unt_cdate,
  XMLRead, XMLWrite, Int_NeedsStatusbar;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}

{$ENDIF}

resourcestring
  SFileChangedSavedCaption ='Datei geändert';
  SFileChangedSavedQuestion = 'Datei %s wurde verändert. Änderungen speichern ?';
{ TfrmMain }

function GetApplicationName: string;
begin
  Result := 'VisiPro';
end;

function GetVendorName: string;
begin
  Result := 'JC-Soft';
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DockMaster.MakeDockSite(self, [akBottom, akLeft], admrpChild);
  DockMaster.OnShowOptions := @ShowAnchorDockOptions;
  DockMaster.OnCreateControl := @DockMasterCreateControl;
  OnGetApplicationName := @GetApplicationName;
  OnGetVendorName := @GetVendorName;
  AboutBox1.Company := VendorName;
  lblVersion.Caption := format('Compiled: %s' + LineEnding + #9'on: %s', [ADate, CName]);
  TCustomcoolbar(CoolBar1).Controls[1].Top := 0;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if assigned(FProjectFile) then
    FreeAndNil(FProjectFile);
end;

procedure TfrmMain.FileNew1Execute(Sender: TObject);
var
  LNode: TDOMElement;
  LAttribute: TDOMAttr;
begin
  if FChanged then
  begin
    //    Ask weather to Save the Changed Project
    FChanged := False;
  end;
  if assigned(FProjectFile) then
    FreeAndNil(FProjectFile);
  FProjectFile := TXMLDocument.Create;
  FProjectFile.AppendChild(FProjectFile.CreateComment(ApplicationName +
    '-Project-File'));
  FProjectFile.AppendChild(FProjectFile.CreateElement(ApplicationName));
  LNode := TDOMElement(FProjectFile.ChildNodes.Item[1]);
  LNode['Version'] := '0.9';
  LNode.AppendChild(FProjectFile.CreateElement('Forms'));
  Lnode.LastChild.AppendChild(FProjectFile.CreateComment('Bereich für Bilder/Masken'));
  LNode.AppendChild(FProjectFile.CreateElement('Communication'));
  Lnode.LastChild.AppendChild(FProjectFile.CreateComment(
    'Bereich für Variablen/PLC-Verbindungen'));
  LNode.AppendChild(FProjectFile.CreateElement('Structures'));
  Lnode.LastChild.AppendChild(FProjectFile.CreateComment(
    'Bereich für Bild-/Var-Strukturen'));
  LNode.AppendChild(FProjectFile.CreateElement('Ressources'));
  Lnode.LastChild.AppendChild(FProjectFile.CreateComment(
    'Bereich für Grafik-/Text-Ressourcen'));
  LNode.AppendChild(FProjectFile.CreateElement('Language'));
  Lnode.LastChild.AppendChild(FProjectFile.CreateComment(
    'Bereich für Sprachen-/Übersetzungs-Details'));
  LNode.AppendChild(FProjectFile.CreateElement('Messages'));
  Lnode.LastChild.AppendChild(FProjectFile.CreateComment(
    'Bereich für Störunen & Meldungen'));
  LNode.AppendChild(FProjectFile.CreateElement('System'));
  Lnode.LastChild.AppendChild(FProjectFile.CreateComment(
    'Bereich für System-Definitionen'));
end;

procedure TfrmMain.FileOpen1Accept(Sender: TObject);
begin
  FPFilename:=Fileopen1.Dialog.FileName;
  XMLRead.ReadXMLFile(FProjectFile,Fileopen1.Dialog.FileName);
end;

procedure TfrmMain.FileOpen1BeforeExecute(Sender: TObject);
var
  Mresult: TModalResult;
begin
  if FChanged then
  begin
    Mresult:= MessageDlg(SFileChangedSavedCaption,format(SFileChangedSavedQuestion,[FPFilename]),mtConfirmation,mbYesNo,0);
    if Mresult=mrYes then
      begin
        if FileSave1.Enabled then
          FileSave1Execute(sender)
        else
          FileSaveAs1.Execute;
        FChanged := False;
      end;
  end;
end;

procedure TfrmMain.FileSave1Execute(Sender: TObject);
begin
  if (FPFilename='') then
    FileSaveAs1.Execute
  else
    begin
      XMLWrite.WriteXML(FProjectFile, FPFilename);
      FChanged:=false;
    end;
end;

procedure TfrmMain.FileSave1Update(Sender: TObject);
begin
  FileSave1.Enabled:=FChanged;
end;

procedure TfrmMain.FileSaveAs1Accept(Sender: TObject);
begin
  FPFilename := FileSaveAs1.Dialog.FileName;
  XMLWrite.WriteXML(FProjectFile, FPFilename);
  FChanged:=false;
end;

procedure TfrmMain.DockMasterCreateControl(Sender: TObject; aName: string;
  var AControl: TControl; DoDisableAutoSizing: boolean);

  procedure CreateForm(Caption: string; NewBounds: TRect);
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

procedure TfrmMain.SetStatusBar1(AValue: TStatusBar);
var
  i: integer;

begin
  if FStatusBar1 = AValue then
    Exit;
  FStatusBar1 := AValue;
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i] is iNeedsStatusbar then
      (Screen.Forms[i] as iNeedsStatusbar).StatusBar := AValue;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  DockMaster.MakeDockable(frmStatusbar, True, True);
  ViewProjectInspector1.Execute;
  ViewObjectInspector1.Execute;
  ViewDetails1.Execute;
  ViewLibrary1.Execute;
  DockMaster.ManualDock(DockMaster.GetAnchorSite(frmViewDetails.parent),
    self, alBottom, nil);
  DockMaster.ManualDock(DockMaster.GetAnchorSite(frmLibrary.parent),
    self, alRight, frmViewDetails);
  DockMaster.ManualDock(DockMaster.GetAnchorSite(frmObjectInspector.parent),
    self, alBottom, frmViewDetails);
  DockMaster.ManualDock(DockMaster.GetAnchorSite(frmProjectExplorer.parent),
    self, alLeft, frmViewDetails);
  DockMaster.ManualDock(DockMaster.GetAnchorSite(frmStatusbar.parent),
    self, alBottom, nil);
end;

procedure TfrmMain.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox1.Show;
end;

procedure TfrmMain.lblVersionResize(Sender: TObject);
begin
  lblVersion.font.Height := lblVersion.Height div 2;
end;

procedure TfrmMain.ViewDetails1Execute(Sender: TObject);
begin
  DockMaster.MakeDockable(frmViewDetails, True, True);
end;

procedure TfrmMain.ViewDetails1Update(Sender: TObject);
begin
  ViewDetails1.Checked := frmViewDetails.Visible;
end;

procedure TfrmMain.ViewLibrary1Execute(Sender: TObject);
begin
  DockMaster.MakeDockable(frmLibrary, True, True);
end;

procedure TfrmMain.ViewLibrary1Update(Sender: TObject);
begin
  ViewLibrary1.Checked := frmLibrary.Visible;
end;

procedure TfrmMain.ViewObjectInspector1Execute(Sender: TObject);
begin
  DockMaster.MakeDockable(frmObjectInspector, True, True);
end;

procedure TfrmMain.ViewObjectInspector1Update(Sender: TObject);
begin
  ViewObjectInspector1.Checked := frmObjectInspector.Visible;
end;

procedure TfrmMain.ViewProjectInspector1Execute(Sender: TObject);
begin
  DockMaster.MakeDockable(frmProjectExplorer, True, True);
end;

procedure TfrmMain.ViewProjectInspector1Update(Sender: TObject);
begin
  ViewProjectInspector1.Checked := frmProjectExplorer.Visible;
end;

end.
