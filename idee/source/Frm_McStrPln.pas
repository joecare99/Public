Unit Frm_McStrPln;

Interface

Uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin, frm_ChildWin, frm_Aboutbox, fra_Welcome;

Type
  TFrmMineCAD = Class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileOpen1: TAction;
    FileSave1: TAction;
    FileSaveAs1: TAction;
    FileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    HelpAbout1: TAction;
    StatusBar: TStatusBar;
    MainMenu1: TMainMenu;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    Window1: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    ImageList1: TImageList;
    WindowArrangeAll1: TWindowArrange;
    WindowCascade1: TWindowCascade;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    FileNew2: TAction;
    ToolButton12: TToolButton;
    PopupMenu1: TPopupMenu;
    FormAction1: TControlAction;
    fraWelcome: TFrame1;
    Panel1: TPanel;
    Splitter1: TSplitter;
    N2: TMenuItem;
    Werkzeug1: TMenuItem;
    Datei1: TMenuItem;
    Neu1: TMenuItem;
    Neu2: TMenuItem;
    ffnen1: TMenuItem;
    Speichern1: TMenuItem;
    Speichernunter1: TMenuItem;
    N1: TMenuItem;
    Beenden1: TMenuItem;
    BitBtn1: TBitBtn;
    GenerateAction: TControlAction;
    NewStructureAction: TAction;
    TabControl1: TTabControl;
    N3: TMenuItem;
    File11: TMenuItem;
    File21: TMenuItem;
    File31: TMenuItem;
    File41: TMenuItem;
    File51: TMenuItem;
    File61: TMenuItem;
    File71: TMenuItem;
    File81: TMenuItem;

    Procedure FileNew1Execute(Sender: TObject);
    Procedure FileOpen1Execute(Sender: TObject);
    Procedure FileSave1Execute(Sender: TObject);
    Procedure FileExit1Execute(Sender: TObject);
    Procedure HelpAbout1Execute(Sender: TObject);
    Procedure FormAction1Update(Sender: TObject);
    Procedure FileNew2Execute(Sender: TObject);
    Procedure FileNew2Update(Sender: TObject);
    Procedure GenerateActionExecute(Sender: TObject);
    Procedure NewStructureActionExecute(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
  Private
    { Private-Deklarationen }
    Procedure CreateMDIChild(Const Name: String);
  Public
    { Public-Deklarationen }
  End;

Var
  FrmMineCAD: TFrmMineCAD;

Implementation

Uses sysutils, minecad.planner.model.generator, minecad.planner.model.Sphere;

{$R *.dfm}

Procedure TFrmMineCAD.CreateMDIChild(Const Name: String);
  Var
    Child: TMDIChild;
  Begin
    { ein neues untergeordnetes MDI-Fenster erstellen }
    Child := TMDIChild.Create(Application);
    Child.Caption := Name;
    If FileExists(Name) Then
      // Child.LoadFromFile(Name);
  End;

Procedure TFrmMineCAD.FileNew1Execute(Sender: TObject);
  Var
    Child: TMDIChild;

  Begin
    // Select Type;
    Child := TMDIChild.Create(Application);
    Child.Caption := 'Unnamed';
    Child.PropPanel := Panel1;
    Child.Splitter2 := Splitter1;
    Child.generator := TGenerator.Create(Child);
              if MDIChildCount=1 then
            Child.WindowState := wsMaximized;
  End;

function DeriveDisplayname(gC:TGeneratorClass):String;
  var g:TBaseGenerator;
begin
  g:=gC.Create(nil);
  result := g.DisplayName;
  g.Free;
end;

Procedure TFrmMineCAD.FileNew2Execute(Sender: TObject);

  Var
    c: TMenuItem;
    PControl: TMenuItem;
    Build, Found: boolean;
    i: integer;
    lg: TGeneratorListEntry;

  Begin
    exit;
    If (Sender <> Neu2) Then
      Begin
        PControl := PopupMenu1.Items;
        PopupMenu1.Items.Clear;
        Build := true;
      End
    Else
      Begin
        PControl := Neu2;
        Build := Neu2.Count < Generators.Count;
      End;
    If Build Then
      For lg In Generators Do
        Begin
          Found := false;
          For i := 0 To PControl.Count - 1 Do
            If PControl.Items[i].Tag = integer(lg.Value) Then
              Begin
                Found := true;
                break;
              End;
          If Not Found Then
            Begin
              c := TMenuItem.Create(self);
              // c.Parent := PControl;

              // c.Action := NewStructureAction;
              c.Caption := DeriveDisplayName(lg.Value);
              c.onclick := NewStructureAction.onExecute;
              c.Tag := integer(lg.Value);
              PControl.add(c);
            End;

        End;
    If PControl = PopupMenu1.Items Then
      PopupMenu1.Popup(mouse.CursorPos.X, mouse.CursorPos.y);

  End;

Procedure TFrmMineCAD.FileNew2Update(Sender: TObject);
  Begin
    FileNew2.Visible := Neu2.Count > 1;
  End;

Procedure TFrmMineCAD.FileOpen1Execute(Sender: TObject);
  Begin
    OpenDialog.Execute;
  End;

Procedure TFrmMineCAD.FileSave1Execute(Sender: TObject);
  Begin
    SaveDialog.Execute;
  End;

Procedure TFrmMineCAD.FormAction1Update(Sender: TObject);
var
  i: Integer;
  tcChanged: Boolean;
  Begin
    fraWelcome.Visible := self.MDIChildCount = 0;
    TabControl1.Visible := (self.MDIChildCount>1) and (wsMaximized =
      self.MDIChildren[0].WindowState) ;
    if TabControl1.Visible then
      begin
        tcChanged := TabControl1.Tabs.count <> self.MDIChildCount;
        for i := 0 to self.MDIChildCount -1 do
           tcChanged := tcChanged or (TabControl1.Tabs[i] <> self.MDIChildren[
             i].Caption);
        if tcChanged then
          begin
            TabControl1.tabs.Clear;
    for i := 0 to self.MDIChildCount -1 do
      begin
        TabControl1.Tabs.AddObject(self.MDIChildren[i].Caption,self.MDIChildren[
          i]);
        if self.MDIChildren[i] = ActiveMDIChild then
          TabControl1.TabIndex := i;
      end;

          end;
      end;
  End;

Procedure TFrmMineCAD.FormShow(Sender: TObject);

  Var
    c: TMenuItem;
    Found: boolean;
    i: integer;
    lg: TGeneratorListEntry;
  Begin
    Neu2.Clear;
    For lg In Generators Do
      Begin
        Found := false;
        For i := 0 To Neu2.Count - 1 Do
          If Neu2.Items[i].Tag = integer(lg.Value) Then
            Begin
              Found := true;
              break;
            End;
        If Not Found Then
          Begin
            c := NewItem(DeriveDisplayname(lg.Value),TShortCut(0),false,true,
            NewStructureAction.onExecute,0,'mnu'+lg.Value.ClassName);
            c.Tag := integer(lg.Value);
            neu2.Add(c);
          End;

      End;
    // Todo: Menu updaten.
  End;

Procedure TFrmMineCAD.GenerateActionExecute(Sender: TObject);
  Begin
    If (Panel1.Tag <> 0) Then
      If TObject(Panel1.Tag).InheritsFrom(TMDIChild) Then
        TMDIChild(Panel1.Tag).btnGenerateClick(Sender);
  End;

Procedure TFrmMineCAD.FileExit1Execute(Sender: TObject);
  Begin
    Close;
  End;

Procedure TFrmMineCAD.HelpAbout1Execute(Sender: TObject);
  Begin
    // AboutBox1.ShowModal;
  End;

Procedure TFrmMineCAD.NewStructureActionExecute(Sender: TObject);
  Var
    cn: String;
    genClass: TGeneratorClass;
    Child: TMDIChild;
  Begin
    cn := Sender.className;
    If Sender.InheritsFrom(TMenuItem) Then
      If TMenuItem(Sender).Tag <> 0 Then
        Begin
          genClass := TGeneratorClass(TComponent(Sender).Tag);
          Child := TMDIChild.Create(Application);
          Child.PropPanel := Panel1;
          Child.Splitter2 := Splitter1;
          Child.generator := genClass.Create(Child);
          Child.Caption := 'Unnamed ' +  Child.generator.Displayname;
          if MDIChildCount=1 then
            Child.WindowState := wsMaximized;

        End;
  End;

procedure TFrmMineCAD.TabControl1Change(Sender: TObject);
begin
  if TabControl1.TabIndex>=0 then
    begin
      if TabControl1.Tabs.Objects[TabControl1.TabIndex] <> ActiveMDIChild then
        begin
          TForm(TabControl1.Tabs.Objects[TabControl1.TabIndex]).BringToFront;
        end;
    end;
end;

End.
