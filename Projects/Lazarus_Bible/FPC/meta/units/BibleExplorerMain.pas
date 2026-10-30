{ BibleExplorer - Hauptfenster der Meta-App.

  Links ein Baum mit den Demos nach Themen geordnet, rechts die Reiter mit
  Ueberblick, Code, Verhalten, Dateien und Notizen. }

unit BibleExplorerMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, Dialogs, Menus,
  Buttons, ExtCtrls, Graphics, LCLIntf, LCLType, Process,
  BibleDemoInfo, BibleIndex, BibleCodeView, BibleShowcase, BibleShowcaseRegistry,
  BibleResources, FormShot;

type
  { TBibleExplorerForm }
  TBibleExplorerForm = class(TForm)
    Splitter1: TSplitter;
    TreeView: TTreeView;
    PageControl: TPageControl;
    tabOverview: TTabSheet;
    tabCode: TTabSheet;
    tabBehavior: TTabSheet;
    tabFiles: TTabSheet;
    tabNotes: TTabSheet;
    lblTitle: TLabel;
    lblSummary: TLabel;
    lblLearning: TLabel;
    lblStatus: TLabel;
    memoOverview: TMemo;
    memoNotes: TMemo;
    listFiles: TListBox;
    codeView: TBibleCodeView;
    pnlBehavior: TPanel;
    imgBehavior: TImage;
    memoBehavior: TMemo;
    btnStart: TButton;
    btnShot: TButton;
    btnStartIntern: TButton;
    btnShotIntern: TButton;
    btnPrevious: TButton;
    btnNext: TButton;
    btnPrev: TButton;
    btnNextPage: TButton;
    lblPage: TLabel;
    pnlNav: TPanel;
    pnlTop: TPanel;
    splBehavior: TSplitter;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuOpen: TMenuItem;
    mnuReload: TMenuItem;
    mnuQuit: TMenuItem;
    mnuDemo: TMenuItem;
    mnuStart: TMenuItem;
    mnuShot: TMenuItem;
    mnuAbout: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeViewNodeClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnShotClick(Sender: TObject);
    procedure btnStartInternClick(Sender: TObject);
    procedure btnShotInternClick(Sender: TObject);
    procedure splMouseDown(Sender: TObject; Button: TMouseButton; X, Y: Integer);
    procedure splMouseMove(Sender: TObject; X, Y: Integer);
    procedure BehaviorFormClosing(Sender: TObject; var CloseAction: TCloseAction);
    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure UpdatePageInfo;
    procedure EmbedBehaviorForm;
    procedure PrepareBehaviorForm(AForm: TForm);
    procedure PrepareBehaviorMenu(AForm: TForm);
    procedure ClearBehaviorMenu;
    procedure BehaviorMenuClick(Sender: TObject);
    procedure BehaviorCloseClick(Sender: TObject);
    procedure MainFormCloseQuery(Sender: TObject; var CloseAction: TCloseAction);
    procedure mnuQuitClick(Sender: TObject);
    procedure mnuReloadClick(Sender: TObject);
    procedure mnuStartClick(Sender: TObject);
    procedure mnuShotClick(Sender: TObject);
    procedure listFilesDblClick(Sender: TObject);
  private
    FIndex: TBibleIndex;
    FRegistry: TShowcaseRegistry;
    FRootPath: string;
    FCurrentDemo: TBibleDemo;
    FBehaviorForm: TForm;
    FBehaviorClosed: Boolean;
    FDragging: Boolean;
    FCloseFromDemo: Boolean;
    { Spiegelung der Demo-Menuzeile im Menue des BibleExplorers:
      Original-Eintraege je gespiegeltem Eintrag. }
    FBehaviorMenuSources: array of TMenuItem;
    FBehaviorMenuClones: array of TMenuItem;
    FDragStartY: Integer;
    FProcess: TProcess;
    function FindRoot: string;
    procedure LoadManifest;
    procedure FillTree;
    procedure ShowDemo(ADemo: TBibleDemo);
    procedure ShowBehavior;
    procedure ClearBehavior;
    procedure StartDemo;
    procedure MakeScreenshot;
    function DemoBinaryPath(ADemo: TBibleDemo): string;
  public
    property Index: TBibleIndex read FIndex;
    { Wechselt auf die Seite mit dem angegebenen Namen. }
    procedure ShowPage(const APageName: string);
    { Das aktuell eingebettete Demo-Formular (fuer Screenshots). }
    property BehaviorForm: TForm read FBehaviorForm;
  end;

var
  BibleExplorerForm: TBibleExplorerForm;

implementation

{$R *.lfm}

procedure TBibleExplorerForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FRootPath := FindRoot;
  FIndex := TBibleIndex.Create;
  FRegistry := TShowcaseRegistry.Create;
  FRegistry.RegisterAll;
  LoadManifest;
  FillTree;
  TreeView.Items[0].Expanded := True;
end;

procedure TBibleExplorerForm.FormDestroy(Sender: TObject);
begin
  ClearBehavior;
  FreeAndNil(FRegistry);
  FreeAndNil(FIndex);
end;

{ Nach dem Anzeigen des Fensters das eingebettete Demo noch einmal
  einbetten - vorher hatte es noch keine Groesse und keinen Fensterhandle. }
procedure TBibleExplorerForm.FormShow(Sender: TObject);
begin
  if FBehaviorForm = nil then
    Exit;
  EmbedBehaviorForm;
  lblStatus.Caption := 'Demo: ' + IntToStr(FBehaviorForm.Width) + 'x' +
    IntToStr(FBehaviorForm.Height) + ' sichtbar=' +
    BoolToStr(FBehaviorForm.Visible, True) + ' handle=' +
    BoolToStr(FBehaviorForm.Handle <> 0, True);
end;

{ Sucht das Wurzelverzeichnis des Projektes (mit source/ und FPC/). }
function TBibleExplorerForm.FindRoot: string;
var
  Dir: string;
  I: Integer;
begin
  { 1) Parameter }
  if (ParamCount >= 1) and DirectoryExists(ParamStr(1)) then
  begin
    Result := IncludeTrailingPathDelimiter(ParamStr(1));
    Exit;
  end;
  { 2) relativ zum Programm }
  Dir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  for I := 1 to 5 do
  begin
    if DirectoryExists(IncludeTrailingPathDelimiter(Dir) + 'source') and
       FileExists(IncludeTrailingPathDelimiter(Dir) + 'FPC/meta/bible.manifest.json') then
    begin
      Result := Dir;
      Exit;
    end;
    Dir := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Dir) + '..');
  end;
  { 3) aktuelles Verzeichnis }
  Result := IncludeTrailingPathDelimiter(GetCurrentDir);
end;

procedure TBibleExplorerForm.LoadManifest;
var
  FileName: string;
  ManifestText: string;
begin
  if TryLoadBibleResourceText('bible.manifest.json', ManifestText) and
    FIndex.LoadFromString(ManifestText) then
  begin
    lblStatus.Caption := 'Index: eingebettete Ressource';
    Exit;
  end;

  FileName := IncludeTrailingPathDelimiter(FRootPath) + 'FPC/meta/bible.manifest.json';
  if not FileExists(FileName) then
    FileName := IncludeTrailingPathDelimiter(GetCurrentDir) + 'bible.manifest.json';
  if not FIndex.LoadFromFile(FileName) then
    lblStatus.Caption := 'Index weder eingebettet noch als Datei gefunden: ' + FileName
  else
    lblStatus.Caption := 'Index: ' + FileName;
end;

{ Baut den Baum: Kategorie -> Demo. }
procedure TBibleExplorerForm.FillTree;
var
  I, J: Integer;
  CategoryNode, DemoNode: TTreeNode;
  Demo: TBibleDemo;
begin
  TreeView.Items.Clear;
  for I := 0 to FIndex.Categories.Count - 1 do
  begin
    CategoryNode := TreeView.Items.Add(nil,
      TBibleCategory(FIndex.Categories[I]).Title);
    for J := 0 to TBibleCategory(FIndex.Categories[I]).Demos.Count - 1 do
    begin
      Demo := FIndex.DemoByKey(TBibleCategory(FIndex.Categories[I]).Demos[J]);
      if Demo = nil then
        Continue;
      DemoNode := TreeView.Items.AddChild(CategoryNode, Demo.Title);
      DemoNode.Data := Demo;
    end;
    CategoryNode.Expanded := True;
  end;
  { Die erste Demo auswaehlen, damit sofort etwas zu sehen ist. }
  if TreeView.Items.Count > 0 then
  begin
    TreeView.Selected := TreeView.Items[0];
    if (TreeView.Items[0].Count > 0) and (TreeView.Items[0].GetFirstChild <> nil) then
      TreeView.Selected := TreeView.Items[0].GetFirstChild;
    TreeViewNodeClick(Self);
  end;
end;

procedure TBibleExplorerForm.TreeViewNodeClick(Sender: TObject);
var
  Node: TTreeNode;
  Demo: TBibleDemo;
begin
  Node := TreeView.Selected;
  if Node = nil then
    Exit;
  Demo := TBibleDemo(Node.Data);
  if Demo = nil then
    Exit;
  ShowDemo(Demo);
end;

{ Zeigt eine Demo in allen Reitern. }
procedure TBibleExplorerForm.ShowDemo(ADemo: TBibleDemo);
var
  SourcePath: string;
begin
  FCurrentDemo := ADemo;
  lblTitle.Caption := ADemo.Title;
  lblSummary.Caption := ADemo.Summary;
  lblLearning.Caption := ADemo.Learning;
  memoOverview.Lines.Text := ADemo.Summary + #13#10 + #13#10 +
    'Lernziel:' + #13#10 + ADemo.Learning + #13#10 + #13#10 +
    'Ordner: ' + ADemo.Folder + #13#10 +
    'Projekt: ' + ADemo.Project;
  SourcePath := ADemo.LocateSourcePath(
    IncludeTrailingPathDelimiter(FRootPath) + 'source');
  codeView.ShowDemo(ADemo, SourcePath);
  lblStatus.Caption := 'Code: ' + IntToStr(codeView.CodeLength) + ' Zeichen';
  listFiles.Clear;
  listFiles.Items.AddStrings(ADemo.Units);
  memoNotes.Lines.Text := ADemo.Notes;
  ShowBehavior;
end;

{ Wechselt in den Reiter "Verhalten". }
procedure TBibleExplorerForm.PageControlChange(Sender: TObject);
begin
  if PageControl.ActivePage = tabBehavior then
    ShowBehavior;
  UpdatePageInfo;
end;

procedure TBibleExplorerForm.ClearBehavior;
begin
  ClearBehaviorMenu;
  if FBehaviorForm <> nil then
  begin
    FBehaviorForm.OnClose := nil;
    FBehaviorForm.Parent := nil;
    { Das Freigeben geschah frueher hart - ein ۓbles Demo wartet die
      App mitreissen. Jetzt gefangen, der Fehler wird im Memo notiert. }
    try
      FreeAndNil(FBehaviorForm);
    except
      on E: Exception do
        memoBehavior.Lines.Add('Freigebe-Fehler: ' + E.Message);
    end;
  end;
  FBehaviorClosed := False;
  if Assigned(btnStartIntern) then
    btnStartIntern.Enabled := False;
  if Assigned(btnShotIntern) then
    btnShotIntern.Enabled := False;
  if FProcess <> nil then
  begin
    if FProcess.Running then
      FProcess.Terminate(0);
    FreeAndNil(FProcess);
  end;
end;

{ Bettet das Demo-Formular in den Verhaltens-Frame ein. }
procedure TBibleExplorerForm.EmbedBehaviorForm;
begin
  if FBehaviorForm = nil then
    Exit;
  FBehaviorForm.Parent := pnlBehavior;
  { Die Groesse explizit setzen - beim Einbetten hat der Frame noch
    keine endgueltige Groesse, sonst bleibt das Formular bei 0 Pixeln. }
  FBehaviorForm.SetBounds(0, 0, pnlBehavior.Width, pnlBehavior.Height);
  FBehaviorForm.Align := alClient;
  FBehaviorForm.Visible := True;
  FBehaviorForm.BringToFront;
end;

{ Der "Schliessen"-Knopf eines eingebetteten Demos (TBitBtn mit
  Kind = bkClose) wuerde im LCL das oberste nicht eingebettete Formular
  schliessen - also die Meta-App. Er wird deshalb auf das Demo-Formular
  umgebogen. }
procedure TBibleExplorerForm.PrepareBehaviorForm(AForm: TForm);
var
  I: Integer;
begin
  for I := 0 to AForm.ComponentCount - 1 do
  begin
    { TBitBtn (Kind = bkClose) schliesst sonst die Meta-App. }
    if (AForm.Components[I] is TBitBtn) and
       (TBitBtn(AForm.Components[I]).Kind = bkClose) then
    begin
      TBitBtn(AForm.Components[I]).Kind := bkCustom;
      TBitBtn(AForm.Components[I]).OnClick := BehaviorCloseClick;
    end;
  end;
end;

{ Die Menuzeile einer Demo wird im eingebetteten Zustand nicht gerendert -
  Menueleisten erscheinen nur bei Formularen auf oberster Ebene. Die
  Demo-Menustruktur wird deshalb dynamisch in die Menueleiste des
  BibleExplorers gespiegelt; die Klicks laufen auf die Original-Eintraege
  der Demo, so dass die Demo-Ereignisbehandlung unveraendert arbeitet. }
procedure TBibleExplorerForm.BehaviorMenuClick(Sender: TObject);
var
  I: Integer;
  Src: TMenuItem;
begin
  if not (Sender is TMenuItem) then
    Exit;
  for I := 0 to High(FBehaviorMenuClones) do
    if FBehaviorMenuClones[I] = Sender then
    begin
      Src := FBehaviorMenuSources[I];
      if (Src <> nil) and Assigned(Src.OnClick) then
        try
          Src.OnClick(Src);
        except
          on E: Exception do
            memoBehavior.Lines.Add('Demo-Menu-Fehler: ' + E.Message);
        end;
      Exit;
    end;
end;

procedure TBibleExplorerForm.ClearBehaviorMenu;
var
  I: Integer;
begin
  for I := High(FBehaviorMenuClones) downto 0 do
    if FBehaviorMenuClones[I] <> nil then
      FBehaviorMenuClones[I].Free;
  SetLength(FBehaviorMenuClones, 0);
  SetLength(FBehaviorMenuSources, 0);
end;

procedure TBibleExplorerForm.PrepareBehaviorMenu(AForm: TForm);

  procedure MirrorItem(AParent: TMenuItem; ASrc: TMenuItem);
  var
    J: Integer;
    Src, NewItem: TMenuItem;
  begin
    for J := 0 to ASrc.Count - 1 do
    begin
      Src := ASrc.Items[J];
      NewItem := TMenuItem.Create(nil);
      NewItem.Caption := Src.Caption;
      NewItem.Enabled := Src.Enabled;
      NewItem.Visible := Src.Visible;
      NewItem.Checked := Src.Checked;
      NewItem.ShortCut := Src.ShortCut;
      NewItem.OnClick := BehaviorMenuClick;
      AParent.Add(NewItem);
      SetLength(FBehaviorMenuClones, Length(FBehaviorMenuClones) + 1);
      FBehaviorMenuClones[High(FBehaviorMenuClones)] := NewItem;
      SetLength(FBehaviorMenuSources, Length(FBehaviorMenuSources) + 1);
      FBehaviorMenuSources[High(FBehaviorMenuSources)] := Src;
      MirrorItem(NewItem, Src);
    end;
  end;

var
  I: Integer;
  Root, NewItem: TMenuItem;
begin
  ClearBehaviorMenu;
  if (AForm = nil) or (AForm.Menu = nil) then
    Exit;
  for I := 0 to AForm.Menu.Items.Count - 1 do
  begin
    Root := AForm.Menu.Items.Items[I];
    NewItem := TMenuItem.Create(nil);
    NewItem.Caption := Root.Caption;
    NewItem.OnClick := BehaviorMenuClick;
    MainMenu1.Items.Add(NewItem);
    SetLength(FBehaviorMenuClones, Length(FBehaviorMenuClones) + 1);
    FBehaviorMenuClones[High(FBehaviorMenuClones)] := NewItem;
    SetLength(FBehaviorMenuSources, Length(FBehaviorMenuSources) + 1);
    FBehaviorMenuSources[High(FBehaviorMenuSources)] := Root;
    MirrorItem(NewItem, Root);
  end;
end;{ Der Schliessen-Knopf des Demos schliesst das Demo-Formular - nicht die
  Meta-App. }
procedure TBibleExplorerForm.BehaviorCloseClick(Sender: TObject);
begin
  FCloseFromDemo := True;
  if FBehaviorForm <> nil then
    FBehaviorForm.Close;
  FCloseFromDemo := False;
end;

{ Sicherheitsnetz: Kommt der Schliess-Befehl aus einem eingebetteten Demo,
  bleibt die Meta-App offen. Sonst wird beim Beenden der Meta-App zuerst
  das eingebettete Demo freigegeben. }
procedure TBibleExplorerForm.MainFormCloseQuery(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if FCloseFromDemo then
  begin
    FCloseFromDemo := False;
    CloseAction := caNone;
  end
  else if FBehaviorForm <> nil then
    ClearBehavior;
end;

{ Zeigt das Verhalten der Demo: eingebettetes Formular oder Screenshot. }
procedure TBibleExplorerForm.ShowBehavior;
var
  Form: TForm;
begin
  ClearBehavior;
  if FCurrentDemo = nil then
    Exit;
  if FRegistry.Showcase.HasEntry(FCurrentDemo.Key) then
  begin
    Form := nil;
    { Ein fehlgebautes Demo darf die App nicht mitreissen - der
      Block laeuft auch bei fehlenden Ressourcen oder AVs weiter. }
    try
      Form := FRegistry.Showcase.CreateForm(FCurrentDemo.Key);
    except
      on E: Exception do
        memoBehavior.Lines.Add('Demo-Fehler (' + FCurrentDemo.Key + '): ' +
          E.Message);
    end;
    if Form <> nil then
    begin
      FBehaviorForm := Form;
      { Der Schliessen-Knopf der Demo darf die Explorer-App nicht beenden,
        sondern leert nur den Frame. }
      FBehaviorForm.OnClose := BehaviorFormClosing;
      try
        PrepareBehaviorForm(FBehaviorForm);
        PrepareBehaviorMenu(FBehaviorForm);
        EmbedBehaviorForm;
        btnStartIntern.Enabled := False;
        btnShotIntern.Enabled := True;
      except
        on E: Exception do
        begin
          memoBehavior.Lines.Add('Demo-Fehler (Verhalten): ' + E.Message);
          ClearBehavior;
        end;
      end;
    end;
  end
  else
  begin
    memoBehavior.Lines.Add('Diese Demo laesst sich nicht intern einbetten.');
    btnStartIntern.Enabled := False;
    btnShotIntern.Enabled := False;
  end;
  btnStart.Enabled := True;
  btnShot.Enabled := True;
  lblStatus.Caption := FCurrentDemo.Key + ': eingebettet=' +
    BoolToStr(FBehaviorForm <> nil, True);
end;

{ Wird aufgerufen, wenn die eingebettete Demo geschlossen wird. }
procedure TBibleExplorerForm.BehaviorFormClosing(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  { Das LCL soll das Formular nicht selbst freigeben - wir nehmen es
    nur aus dem Frame und geben es beim naechsten Start frei. }
  CloseAction := caNone;
  if Sender is TForm then
    (Sender as TForm).Hide;
  FBehaviorClosed := True;
  ClearBehaviorMenu;
  btnStartIntern.Enabled := True;
  btnShotIntern.Enabled := False;
  memoBehavior.Lines.Add('Die Demo wurde geschlossen - der Frame ist leer. ' +
    'Mit "Demo intern starten" laesst sie sich erneut starten.');
end;

{ Startet die Demo intern (eingebettet in den Frame). }
procedure TBibleExplorerForm.btnStartInternClick(Sender: TObject);
begin
  ShowBehavior;
end;

{ Der Greif-Bereich teilt den oberen Bereich und den Verhaltens-Frame.
  Wird die Trenne gezogen, aendert sich nur die Hoehe des oberen Bereichs -
  Greif-Bereich und Frame legt das Layout selbst fest. }
procedure TBibleExplorerForm.splMouseDown(Sender: TObject; Button: TMouseButton;
  X, Y: Integer);
begin
  FDragging := True;
  FDragStartY := Y;
end;

procedure TBibleExplorerForm.splMouseMove(Sender: TObject; X, Y: Integer);
var
  NewHeight: Integer;
  MaxHeight: Integer;
begin
  if not FDragging then
    Exit;
  MaxHeight := pnlTop.Parent.ClientHeight - 80;
  NewHeight := pnlTop.Height + (Y - FDragStartY);
  if NewHeight < 40 then
    NewHeight := 40;
  if NewHeight > MaxHeight then
    NewHeight := MaxHeight;
  pnlTop.Height := NewHeight;
  FDragStartY := Y;
  EmbedBehaviorForm;
end;

{ Rendert das eingebettete Formular in das Bild. }
procedure TBibleExplorerForm.btnShotInternClick(Sender: TObject);
var
  FileName: string;
begin
  if FBehaviorForm = nil then
    Exit;
  FileName := IncludeTrailingPathDelimiter(GetTempDir) + 'bible_internal.bmp';
  SaveFormToImage(FBehaviorForm, FileName);
  if FileExists(FileName) then
  begin
    imgBehavior.Picture.LoadFromFile(FileName);
    memoBehavior.Lines.Add('Screenshot (intern): ' + FileName);
  end;
end;

{ Startet das Demo als eigenes Programm. }
procedure TBibleExplorerForm.StartDemo;
var
  FileName: string;
  Output: TStringList;
begin
  if FCurrentDemo = nil then
    Exit;
  FileName := DemoBinaryPath(FCurrentDemo);
  if FileName = '' then
  begin
    memoBehavior.Lines.Add('Programm nicht gefunden: ' + FCurrentDemo.Project);
    Exit;
  end;
  FreeAndNil(FProcess);
  FProcess := TProcess.Create(nil);
  Output := TStringList.Create;
  try
    FProcess.Executable := FileName;
    FProcess.Options := [poUsePipes];
    FProcess.Execute;
    memoBehavior.Lines.Add('Gestartet: ' + FileName);
  finally
    Output.Free;
  end;
end;

{ Erzeugt einen Screenshot des Demos (die Demos unterstuetzen die Option
  --screenshot). }
procedure TBibleExplorerForm.MakeScreenshot;
var
  FileName: string;
  Binary: string;
  TempFile: string;
  Process_: TProcess;
begin
  if FCurrentDemo = nil then
    Exit;
  Binary := DemoBinaryPath(FCurrentDemo);
  if Binary = '' then
  begin
    memoBehavior.Lines.Add('Programm nicht gefunden: ' + FCurrentDemo.Project);
    Exit;
  end;
  TempFile := IncludeTrailingPathDelimiter(GetTempDir) + FCurrentDemo.Key + '.bmp';
  Process_ := TProcess.Create(nil);
  try
    Process_.Executable := Binary;
    Process_.Parameters.Add('--screenshot');
    Process_.Parameters.Add(TempFile);
    Process_.Execute;
    Process_.WaitOnExit;
    if FileExists(TempFile) then
    begin
      imgBehavior.Picture.LoadFromFile(TempFile);
      memoBehavior.Lines.Add('Screenshot: ' + TempFile);
    end
    else
      memoBehavior.Lines.Add('Kein Screenshot erzeugt.');
  finally
    Process_.Free;
  end;
end;

function TBibleExplorerForm.DemoBinaryPath(ADemo: TBibleDemo): string;
var
  Dir: string;
begin
  Result := '';
  if ADemo = nil then
    Exit;
  Dir := IncludeTrailingPathDelimiter(FRootPath) + 'bin';
  if not DirectoryExists(Dir) then
    Exit;
  { Der Build-Ordner ist <cpu>-<os> }
  if FileExists(IncludeTrailingPathDelimiter(Dir) + 'x86_64-linux/' + ADemo.Project) then
    Result := IncludeTrailingPathDelimiter(Dir) + 'x86_64-linux/' + ADemo.Project
  else
    Result := IncludeTrailingPathDelimiter(Dir) + ADemo.Project;
end;

procedure TBibleExplorerForm.btnStartClick(Sender: TObject);
begin
  StartDemo;
end;

procedure TBibleExplorerForm.btnShotClick(Sender: TObject);
begin
  MakeScreenshot;
end;

procedure TBibleExplorerForm.btnNextClick(Sender: TObject);
begin
  codeView.NextMarker;
end;

{ Wechselt auf die Seite mit dem angegebenen Namen (fuer Screenshots). }
procedure TBibleExplorerForm.ShowPage(const APageName: string);
var
  I: Integer;
begin
  for I := 0 to PageControl.PageCount - 1 do
    if PageControl.Pages[I].Caption = APageName then
    begin
      PageControl.ActivePageIndex := I;
      UpdatePageInfo;
      { Die eingebettete Demo muss wieder sichtbar geschaltet werden,
        wenn ihre Seite zuvor verdeckt war. }
      if FBehaviorForm <> nil then
      begin
        EmbedBehaviorForm;
  lblStatus.Caption := 'Eingebettet: ' + IntToStr(FBehaviorForm.Width) + 'x' +
    IntToStr(FBehaviorForm.Height);
end;
      Exit;
    end;
  lblPage.Caption := 'nicht gefunden: ' + APageName;
end;

{ Wechselt zur vorherigen Seite (wie bei einem Assistenten). }
procedure TBibleExplorerForm.btnPrevClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := PageControl.ActivePageIndex - 1;
  if Index < 0 then
    Index := PageControl.PageCount - 1;
  PageControl.ActivePageIndex := Index;
  UpdatePageInfo;
end;

{ Wechselt zur naechsten Seite. }
procedure TBibleExplorerForm.btnNextPageClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := PageControl.ActivePageIndex + 1;
  if Index >= PageControl.PageCount then
    Index := 0;
  PageControl.ActivePageIndex := Index;
  UpdatePageInfo;
end;

{ Zeigt den Namen der aktuellen Seite in der Navigationsleiste. }
procedure TBibleExplorerForm.UpdatePageInfo;
begin
  if PageControl.ActivePage <> nil then
    lblPage.Caption := PageControl.ActivePage.Caption
  else
    lblPage.Caption := '';
end;

procedure TBibleExplorerForm.btnPreviousClick(Sender: TObject);
begin
  codeView.PreviousMarker;
end;

procedure TBibleExplorerForm.mnuStartClick(Sender: TObject);
begin
  StartDemo;
end;

procedure TBibleExplorerForm.mnuShotClick(Sender: TObject);
begin
  MakeScreenshot;
end;

procedure TBibleExplorerForm.mnuQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TBibleExplorerForm.mnuReloadClick(Sender: TObject);
begin
  FIndex.Demos.Clear;
  FIndex.Categories.Clear;
  LoadManifest;
  FillTree;
end;

procedure TBibleExplorerForm.listFilesDblClick(Sender: TObject);
begin
  PageControl.ActivePage := tabCode;
end;

end.
