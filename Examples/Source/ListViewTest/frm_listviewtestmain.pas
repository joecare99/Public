unit Frm_ListViewTestMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, Buttons, Controls, ComCtrls, Forms, SysUtils,
  Graphics, StdCtrls;

type
  TFrmListViewMain = class(TForm)
  private
    FItemIndex: Cardinal;
  public
    ListView: TListView;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    constructor Create(AOwner: TComponent); override;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  end;

var
  FrmListViewMain: TFrmListViewMain;

implementation


constructor TFrmListViewMain.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner, 1);

  Caption := 'List View Test';
  Width := 300;
  Height := 200;

  ListView := TListView.Create(Self);
  ListView.Parent := Self;
  ListView.Height := 150;
  ListView.Align := alTop;
  ListView.ViewStyle := vsReport;
  ListView.Show;

  ListView.Columns.Add.Caption := 'Column 1';
  ListView.Columns.Add.Caption := 'Column 2';
  ListView.Columns.Add.Caption := 'Column 3';

  Button1 := TButton.Create(Self);
  with Button1 do
  begin
    Parent := Self;
    Caption := 'Add Item';
    Top := 160;
    Left := 10;
    Height := 25;
    Width := 65;
    OnClick := @Button1Click;
    Show;
  end;

  Button2 := TButton.Create(Self);
  with Button2 do
  begin
    Parent := Self;
    Caption := 'Del Item';
    Top := 160;
    Left := 80;
    Height := 25;
    Width := 65;
    OnClick := @Button2Click;
    Show;
  end;

  Edit1 := TEdit.Create(Self);
  with Edit1 do
  begin
    Parent := Self;
    Top := 160;
    Left := 150;
    Height := 25;
    Width := 65;
    OnChange := @Edit1Change;
    Show;
  end;

  Edit2 := TEdit.Create(Self);
  with Edit2 do
  begin
    Parent := Self;
    Top := 160;
    Left := 220;
    Height := 25;
    Width := 65;
    OnChange := @Edit2Change;
    Show;
  end;

  Show;
end;

procedure TFrmListViewMain.Button1Click(Sender: TObject);
var
  Item: TListItem;
begin
  Inc(FItemIndex);
  Item := ListView.Items.Add;
  Item.Caption := Format('Item %d', [FItemIndex]);
  Item.SubItems.Add(Format('Sub %d.1', [FItemIndex]));
  Item.SubItems.Add(Format('Sub %d.2', [FItemIndex]));
end;

procedure TFrmListViewMain.Button2Click(Sender: TObject);
begin
  ListView.Selected.Free;
end;

procedure TFrmListViewMain.Edit1Change(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  ListView.Selected.Caption := Edit1.Text;
end;

procedure TFrmListViewMain.Edit2Change(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  ListView.Selected.SubItems[0] := Edit2.Text;
end;

end.

