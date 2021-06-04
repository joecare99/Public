unit Frm_VirtTreeViewEx;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, VirtualTrees;

type

  { TFrmVirtTreeViewEx }

  TFrmVirtTreeViewEx = class(TForm)
    btnAddRoot: TButton;
    btnAddChild: TButton;
    btnDelete: TButton;
    VST: TVirtualStringTree;
    procedure btnAddChildClick(Sender: TObject);
    procedure btnAddRootClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure VSTChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VSTFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VSTGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure VSTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; const NewText: String);
  private

  public

  end;

var
  FrmVirtTreeViewEx: TFrmVirtTreeViewEx;

implementation

{$R *.lfm}

type
  PTreeData = ^TTreeData;
  TTreeData = record
    Column0: String;
    Column1: String;
    Column2: String;
  end;

{ TFrmVirtTreeViewEx }

procedure TFrmVirtTreeViewEx.VSTChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  VST.Refresh;
end;

procedure TFrmVirtTreeViewEx.btnAddRootClick(Sender: TObject);
var
  Data: PTreeData;
  XNode: PVirtualNode;
  Rand: Integer;
begin
  Randomize;
  Rand := Random(99);
  XNode := VST.AddChild(nil);
  if VST.AbsoluteIndex(XNode) > -1 then
  begin
    Data := VST.GetNodeData(Xnode);
    Data^.Column0 := 'One ' + IntToStr(Rand);
    Data^.Column1 := 'Two ' + IntToStr(Rand + 10);
    Data^.Column2 := 'Three ' + IntToStr(Rand - 10);
  end;
end;

procedure TFrmVirtTreeViewEx.btnDeleteClick(Sender: TObject);
begin
  VST.DeleteSelectedNodes;
end;

procedure TFrmVirtTreeViewEx.btnAddChildClick(Sender: TObject);
var
  XNode: PVirtualNode;
  Data: PTreeData;
begin
  if not Assigned(VST.FocusedNode) then
    Exit;

  XNode := VST.AddChild(VST.FocusedNode);
  Data := VST.GetNodeData(Xnode);

  Data^.Column0 := 'Ch 1';
  Data^.Column1 := 'Ch 2';
  Data^.Column2 := 'Ch 3';

  VST.Expanded[VST.FocusedNode] := True;
end;

procedure TFrmVirtTreeViewEx.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeData;
begin
  Data := VST.GetNodeData(Node);
  if Assigned(Data) then begin
    Data^.Column0 := '';
    Data^.Column1 := '';
    Data^.Column2 := '';
  end;
end;

procedure TFrmVirtTreeViewEx.VSTGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
   NodeDataSize := SizeOf(TTreeData);
end;

procedure TFrmVirtTreeViewEx.VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PTreeData;
begin
  Data := VST.GetNodeData(Node);
  case Column of
    0: CellText := Data^.Column0;
    1: CellText := Data^.Column1;
    2: CellText := Data^.Column2;
  end;
end;

procedure TFrmVirtTreeViewEx.VSTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; const NewText: String);
var
  Data: PTreeData;
begin
  Data := VST.GetNodeData(Node);
  case Column of
    0: Data^.Column0 := NewText;
    1: Data^.Column1 := NewText;
    2: Data^.Column2 := NewText;
  end;
end;

end.

