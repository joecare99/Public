unit fra_IndIndex;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls, Buttons,
  ComCtrls,cls_HejData, cls_HejIndData, cls_HejDataFilter;

type

  { TfraIndIndex }

  TfraIndIndex = class(TFrame)
    chbFilterActive: TCheckBox;
    ComboBox1: TComboBox;
    cbxSortBy: TComboBox;
    edtFind: TEdit;
    Label1: TLabel;
    lblFind: TLabel;
    lblSort: TLabel;
    ListBox1: TListBox;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    TabControl1: TTabControl;
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure pnlTopClick(Sender: TObject);
  private
    FGenealogy: TClsHejGenealogy;
    FoldGenOnUpdate: TNotifyEvent;
    FSelectedInd,
    FIndCount: Integer;
    FFilter:TGenFilter;
    procedure GenOnUpdate(Sender: TObject);
    procedure SetGenealogy(AValue: TClsHejGenealogy);
    Procedure UpdateList(sender:TObject);
  public
    Property Genealogy:TClsHejGenealogy read FGenealogy write SetGenealogy;
  end;

implementation

{$R *.lfm}

{ TfraIndIndex }

procedure TfraIndIndex.SetGenealogy(AValue: TClsHejGenealogy);
begin
  if FGenealogy=AValue then Exit;
  FGenealogy:=AValue;
  if assigned(FGenealogy) then
    begin
      FoldGenOnUpdate := FGenealogy.OnUpdate;
      if FoldGenOnUpdate = @GenOnUpdate then
        FoldGenOnUpdate:=nil
      else
        FGenealogy.OnUpdate:=@GenOnUpdate;
      UpdateList(self);
    end;
end;

procedure TfraIndIndex.UpdateList(sender: TObject);
var
  lInd: THejIndData;
  i: Integer;
begin
  ListBox1.Clear;
  FIndCount:=0;
  if not assigned(FGenealogy) then exit;
  for i := 1 to FGenealogy.Count do
    begin
      lInd:=FGenealogy.PeekInd(i);
      //filter
      ListBox1.AddItem(lind.ToString,TObject(ptrint(i)));
    end;
  FIndCount:= FGenealogy.Count;
end;

procedure TfraIndIndex.pnlTopClick(Sender: TObject);
begin

end;

procedure TfraIndIndex.ListBox1SelectionChange(Sender: TObject; User: boolean);
var
  lIdx: Integer;
  lidInd: integer;
begin
   // Do The Selection
  lIdx := ListBox1.ItemIndex;
  if not User or (lIdx <0) then
    exit;

  FSelectedInd := ptrint(ListBox1.Items.Objects[lIdx]);
  if assigned(FGenealogy) then
    FGenealogy.Seek(FSelectedInd);
end;

procedure TfraIndIndex.GenOnUpdate(Sender: TObject);
var
  lIdx: Integer;
begin
  if FIndCount <> FGenealogy.Count then
    begin
      UpdateList(sender);
    end;
  if FSelectedInd <> FGenealogy.GetActID then
    begin
      FSelectedInd := FGenealogy.GetActID;
      lIdx :=ListBox1.Items.IndexOfObject(TObject(ptrint(FSelectedInd)));
      if lIdx>=0 then
        ListBox1.ItemIndex:=lIdx
      else
        FSelectedInd:=-1;
    end;
  if assigned(FoldGenOnUpdate) then
    FoldGenOnUpdate(Sender);
end;

end.

