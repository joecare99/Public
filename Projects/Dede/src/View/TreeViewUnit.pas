unit TreeViewUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Menus, Buttons, DeDeDFMModel, EditPropUnit;

type
  TTreeViewForm = class(TForm)
    ControlsTV: TTreeView;
    Splitter1: TSplitter;
    ObjectsLV: TListView;
    ImageList1: TImageList;
    ImageList2: TImageList;
    PropPopUp: TPopupMenu;
    InsertPropert1: TMenuItem;
    DeleteProperty1: TMenuItem;
    EditProperty1: TMenuItem;
    ObjPopUp: TPopupMenu;
    InsertObject1: TMenuItem;
    DeleteObject1: TMenuItem;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    N1: TMenuItem;
    FullExpand1: TMenuItem;
    FullCollapse1: TMenuItem;
    N2: TMenuItem;
    FindComponentValue1: TMenuItem;
    FindNext1: TMenuItem;
    SpeedButton4: TSpeedButton;
    BlinkTimer: TTimer;
    N3: TMenuItem;
    DisAsmMI: TMenuItem;
    procedure ControlsTVChange(Sender: TObject; Node: TTreeNode);
    procedure ObjectsLVDblClick(Sender: TObject);
    procedure FullExpand1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FullCollapse1Click(Sender: TObject);
    procedure SpeedButton4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BlinkTimerTimer(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  public
    CurrentControl: TWinControl;
    HasBeenShown: Byte;
    SearchFound: Byte;
    procedure LoadRoot(Root: TDFMObject);
    function FindObject(const AObjectName: string): Boolean;
  private
    FRoot: TDFMObject;
    destructor Destroy; override;
    function AddObjectNode(ParentNode: TTreeNode;
      AObject: TDFMObject): TTreeNode;
    function FindNode(ParentNode: TTreeNode;
      const AObjectName: string): TTreeNode;
    procedure ShowProperties(AObject: TDFMObject);
    procedure ResetPreviewBlink;
  end;

var
  TreeViewForm: TTreeViewForm;

implementation

{$R *.dfm}

function TTreeViewForm.AddObjectNode(ParentNode: TTreeNode;
  AObject: TDFMObject): TTreeNode;
var
  I: Integer;
  CaptionText: string;
begin
  if AObject.ObjectName = '' then
    CaptionText := AObject.ClassName
  else
    CaptionText := AObject.ObjectName + ':' + AObject.ClassName;
  if ParentNode = nil then
    Result := ControlsTV.Items.Add(nil, CaptionText)
  else
    Result := ControlsTV.Items.AddChild(ParentNode, CaptionText);
  Result.Data := AObject;
  for I := 0 to AObject.Children.Count - 1 do
    AddObjectNode(Result, TDFMObject(AObject.Children[I]));
end;

procedure TTreeViewForm.LoadRoot(Root: TDFMObject);
var
  OldRoot: TDFMObject;
begin
  OldRoot := FRoot;
  ControlsTV.Items.BeginUpdate;
  try
    try
      ControlsTV.Items.Clear;
      ObjectsLV.Items.Clear;
      if Root <> nil then
      begin
        AddObjectNode(nil, Root);
        ControlsTV.Selected := ControlsTV.Items.GetFirstNode;
      end;
    except
      ControlsTV.Items.Clear;
      raise;
    end;
    FRoot := Root;
    if OldRoot <> Root then
      OldRoot.Free;
  finally
    ControlsTV.Items.EndUpdate;
  end;
end;

destructor TTreeViewForm.Destroy;
begin
  ControlsTV.Items.Clear;
  FRoot.Free;
  inherited Destroy;
end;

procedure TTreeViewForm.ShowProperties(AObject: TDFMObject);
var
  I: Integer;
  PropertyItem: TDFMProperty;
  ListItem: TListItem;
begin
  ObjectsLV.Items.BeginUpdate;
  try
    ObjectsLV.Items.Clear;
    if AObject = nil then
      Exit;
    for I := 0 to AObject.Properties.Count - 1 do
    begin
      PropertyItem := TDFMProperty(AObject.Properties[I]);
      ListItem := ObjectsLV.Items.Add;
      ListItem.Caption := PropertyItem.Name;
      ListItem.SubItems.Add(PropertyItem.Value);
      ListItem.Data := PropertyItem;
    end;
  finally
    ObjectsLV.Items.EndUpdate;
  end;
end;

procedure TTreeViewForm.ControlsTVChange(Sender: TObject; Node: TTreeNode);
var
  AObject: TDFMObject;
begin
  if (Node = nil) or (Node.Data = nil) then
  begin
    ShowProperties(nil);
    Exit;
  end;
  AObject := TDFMObject(Node.Data);
  ShowProperties(AObject);
  ResetPreviewBlink;
end;

procedure TTreeViewForm.ObjectsLVDblClick(Sender: TObject);
var
  Selected: TListItem;
  PropertyItem: TDFMProperty;
begin
  Selected := ObjectsLV.Selected;
  if (Selected = nil) or (Selected.Data = nil) then
    Exit;
  PropertyItem := TDFMProperty(Selected.Data);
  EditPropForm.EditProperty(PropertyItem);
  if EditPropForm.ShowModal = mrOk then
  begin
    if (ControlsTV.Selected <> nil) and (ControlsTV.Selected.Data <> nil) then
      ShowProperties(TDFMObject(ControlsTV.Selected.Data));
  end;
end;

procedure TTreeViewForm.FullExpand1Click(Sender: TObject);
begin
  ControlsTV.FullExpand;
end;

procedure TTreeViewForm.FullCollapse1Click(Sender: TObject);
begin
  ControlsTV.FullCollapse;
end;

procedure TTreeViewForm.FormShow(Sender: TObject);
begin
  HasBeenShown := 1;
end;

function TTreeViewForm.FindNode(ParentNode: TTreeNode;
  const AObjectName: string): TTreeNode;
var
  Node: TTreeNode;
  AObject: TDFMObject;
begin
  Result := nil;
  Node := ParentNode;
  while Node <> nil do
  begin
    if Node.Data <> nil then
    begin
      AObject := TDFMObject(Node.Data);
      if SameText(AObject.ObjectName, AObjectName) then
        Exit(Node);
    end;
    Result := FindNode(Node.getFirstChild, AObjectName);
    if Result <> nil then
      Exit;
    Node := Node.getNextSibling;
  end;
end;

function TTreeViewForm.FindObject(const AObjectName: string): Boolean;
var
  Node: TTreeNode;
begin
  Node := FindNode(ControlsTV.Items.GetFirstNode, AObjectName);
  Result := Node <> nil;
  SearchFound := Ord(Result);
  if Result then
    ControlsTV.Selected := Node;
end;

procedure TTreeViewForm.ResetPreviewBlink;
begin
  if (BlinkTimer.Enabled) and (CurrentControl <> nil) then
    CurrentControl.Visible := True;
  CurrentControl := nil;
  BlinkTimer.Tag := 0;
  BlinkTimer.Enabled := False;
  if (ControlsTV.Selected <> nil) and (ControlsTV.Selected.Data <> nil) then
  begin
    if TDFMObject(ControlsTV.Selected.Data).Component is TWinControl then
      CurrentControl := TWinControl(TDFMObject(ControlsTV.Selected.Data).Component);
    if (CurrentControl <> nil) and (CurrentControl <> Application.MainForm) then
      BlinkTimer.Enabled := True;
  end;
end;

procedure TTreeViewForm.SpeedButton4MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (CurrentControl <> nil) and (CurrentControl is TForm) then
    CurrentControl.Show
  else
    Close;
end;

procedure TTreeViewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (CurrentControl <> nil) and (CurrentControl is TForm) then
    TForm(CurrentControl).Close;
end;

procedure TTreeViewForm.BlinkTimerTimer(Sender: TObject);
begin
  if CurrentControl = nil then
  begin
    BlinkTimer.Enabled := False;
    Exit;
  end;
  if CurrentControl = Application.MainForm then
  begin
    BlinkTimer.Enabled := False;
    Exit;
  end;
  CurrentControl.Visible := not CurrentControl.Visible;
  BlinkTimer.Tag := BlinkTimer.Tag + 1;
  if BlinkTimer.Tag >= 10 then
    BlinkTimer.Enabled := False;
end;

procedure TTreeViewForm.SpeedButton3Click(Sender: TObject);
begin
  ShowMessage('not implemented yet!');
end;

procedure TTreeViewForm.SpeedButton1Click(Sender: TObject);
begin
  ShowMessage('not implemented yet!');
end;

procedure TTreeViewForm.SpeedButton2Click(Sender: TObject);
begin
  ShowMessage('not implemented yet!');
end;

end.
