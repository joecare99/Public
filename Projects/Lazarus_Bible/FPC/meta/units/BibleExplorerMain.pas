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
  ExtCtrls, Graphics, LCLIntf, LCLType, Process,
  BibleDemoInfo, BibleIndex, BibleCodeView, BibleShowcase, BibleShowcaseRegistry;

type
  { TBibleExplorerForm }
  TBibleExplorerForm = class(TForm)
    Splitter1: TSplitter;
    TreeView: TTreeView;
    TabControl: TTabControl;
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
    btnPrevious: TButton;
    btnNext: TButton;
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
    procedure FormDestroy(Sender: TObject);
    procedure TreeViewNodeClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnShotClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
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
  end;

var
  BibleExplorerForm: TBibleExplorerForm;

implementation

{$R *.lfm}

procedure TBibleExplorerForm.FormCreate(Sender: TObject);
begin
  FRootPath := FindRoot;
  FIndex := TBibleIndex.Create;
  FRegistry := TShowcaseRegistry.Create;
  FRegistry.RegisterAll;
  LoadManifest;
  FillTree;
end;

procedure TBibleExplorerForm.FormDestroy(Sender: TObject);
begin
  ClearBehavior;
  FreeAndNil(FRegistry);
  FreeAndNil(FIndex);
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
begin
  FileName := IncludeTrailingPathDelimiter(FRootPath) + 'FPC/meta/bible.manifest.json';
  if not FileExists(FileName) then
    FileName := IncludeTrailingPathDelimiter(GetCurrentDir) + 'bible.manifest.json';
  if not FIndex.LoadFromFile(FileName) then
    lblStatus.Caption := 'Index nicht gefunden: ' + FileName
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
begin
  FCurrentDemo := ADemo;
  lblTitle.Caption := ADemo.Title;
  lblSummary.Caption := ADemo.Summary;
  lblLearning.Caption := ADemo.Learning;
  memoOverview.Lines.Text := ADemo.Summary + #13#10 + #13#10 +
    'Lernziel:' + #13#10 + ADemo.Learning + #13#10 + #13#10 +
    'Ordner: ' + ADemo.Folder + #13#10 +
    'Projekt: ' + ADemo.Project;
  codeView.ShowDemo(ADemo, ADemo.LocateSourcePath(
    IncludeTrailingPathDelimiter(FRootPath) + 'source'));
  listFiles.Clear;
  listFiles.Items.AddStrings(ADemo.Units);
  memoNotes.Lines.Text := ADemo.Notes;
  ShowBehavior;
end;

{ Wechselt in den Reiter "Verhalten". }
procedure TBibleExplorerForm.TabControlChange(Sender: TObject);
begin
  if TabControl.TabIndex = 2 then
    ShowBehavior;
end;

procedure TBibleExplorerForm.ClearBehavior;
begin
  if FBehaviorForm <> nil then
  begin
    FBehaviorForm.Parent := nil;
    FreeAndNil(FBehaviorForm);
  end;
  if FProcess <> nil then
  begin
    if FProcess.Running then
      FProcess.Terminate(0);
    FreeAndNil(FProcess);
  end;
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
    Form := FRegistry.Showcase.CreateForm(FCurrentDemo.Key);
    if Form <> nil then
    begin
      FBehaviorForm := Form;
      FBehaviorForm.Parent := pnlBehavior;
      FBehaviorForm.Align := alClient;
      FBehaviorForm.Show;
    end;
  end;
  btnStart.Enabled := True;
  btnShot.Enabled := True;
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
  TabControl.TabIndex := 1;
end;

end.
