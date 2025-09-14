unit fra_IndIndex;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls, Buttons,
  ComCtrls, Grids, Graphics, cls_HejData, cls_HejIndData, cls_HejDataFilter,
  Types;

type
  TIndCompareFkt=function(const aArray: TIntegerDynArray;aLow,aHigh:integer):ShortInt of object;

  { TfraIndIndex }

  TfraIndIndex = class(TFrame)
    chbFilterActive: TCheckBox;
    ComboBox1: TComboBox;
    cbxSortBy: TComboBox;
    edtFind: TEdit;
    Label1: TLabel;
    lblFind: TLabel;
    lblSort: TLabel;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StringGrid1: TStringGrid;
    TabControl1: TTabControl;
    procedure cbxSortByChange(Sender: TObject);
    procedure edtFindChange(Sender: TObject);
    procedure edtFindKeyPress(Sender: TObject; var Key: char);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure pnlTopClick(Sender: TObject);
    procedure StringGrid1ButtonClick(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1GetCellHint(Sender: TObject; ACol, ARow: Integer;
      var HintText: String);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure DoIndexSort(var aArray: TIntegerDynArray;
      aSortFkt: TIndCompareFkt; aLb: integer=-1; aHb: integer=-1);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    Procedure Sort(aCol,aType:integer);
  private
    FGenealogy: TClsHejGenealogy;
    FoldGenOnUpdate: TNotifyEvent;
    FIndexArray:TArrayOfInteger;
    FSortCol,
    FSortType,
    FSelectedInd,
    FIndCount: Integer;
    FFilter:TGenFilter;
    function fktDeathSort(const List: TIntegerDynArray; Index1, Index2: Integer
      ): ShortInt;
    function fktBirthSort(const List: TIntegerDynArray; Index1, Index2: Integer
      ): ShortInt;
    function fktFamilynameSort(const List: TIntegerDynArray; Index1,
      Index2: Integer): ShortInt;
    function fktGivenNameSort(const List: TIntegerDynArray; Index1, Index2: Integer
      ): ShortInt;
    function fktIDSort(const List: TIntegerDynArray; Index1, Index2: Integer
      ): ShortInt;
    procedure GenOnUpdate(Sender: TObject);
    procedure SetGenealogy(AValue: TClsHejGenealogy);
    Procedure UpdateList(sender:TObject);
  public
    Property Genealogy:TClsHejGenealogy read FGenealogy write SetGenealogy;
  end;


implementation

{$R *.lfm}
uses ExtendedStrings;
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
  if Length(FIndexArray)>0 then
    StringGrid1.RowCount:= length(FIndexArray)+1
  else
    StringGrid1.RowCount:= FGenealogy.Count+1;
  StringGrid1.Invalidate;
end;

procedure TfraIndIndex.pnlTopClick(Sender: TObject);
begin

end;

procedure TfraIndIndex.StringGrid1ButtonClick(Sender: TObject; aCol,
  aRow: Integer);
begin
  if aRow>0 then exit;
    begin
      if FSortCol<>aCol then
         Sort(aCol,1)
      else
        Sort(aCol,succ(FSortType));
    end;
end;

procedure TfraIndIndex.StringGrid1DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);

const cTS:TTextStyle=(
     Alignment:taLeftJustify;
     layout:tlCenter;
     SingleLine:true;
     Clipping:true;
     ExpandTabs:true;
     ShowPrefix:true);

var
  aStr: string;
  aCanvas: TCanvas;
  aBrush: TBrush;
begin
   aCanvas := StringGrid1.Canvas;
   aStr := '';
   aBrush:=StringGrid1.Brush;
  if gdFixed in aState then
    begin
      aBrush.Color:=StringGrid1.FixedColor;
      if aCol< StringGrid1.ColCount then
      aStr := StringGrid1.Columns[aCol].Title.Caption;
    end
  else
    begin
         StringGrid1GetEditText(StringGrid1,aCol,aRow,aStr);
   if gdSelected in aState then
     begin
       aBrush.Color:=clHighlight;
       aCanvas.font.Color:=clHighlightText;
     end
   else
   if ARow mod 2 = 0 then
     aBrush.Color := StringGrid1.AlternateColor
   else
     aBrush.Color := StringGrid1.Color;
    end;
   aCanvas.Brush.Assign(aBrush);
   aCanvas.FillRect(aRect);
   if gdFocused in aState then
     aCanvas.DrawFocusRect(aRect);

   aCanvas.TextRect(aRect,aRect.left,0,aStr,cTS);

end;

procedure TfraIndIndex.StringGrid1GetCellHint(Sender: TObject; ACol,
  ARow: Integer; var HintText: String);
begin
  if length(FIndexArray)=0 then
    HintText:=FGenealogy.PeekInd(ARow).ToString
  else
    HintText:=FGenealogy.peekInd(FIndexArray[ARow]).ToString;
end;

procedure TfraIndIndex.StringGrid1GetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  nIndex: Integer;
begin
  if length(FIndexArray) >0 then
     nIndex := FIndexArray[ARow]
  else
    nIndex := ARow;
  case Acol of
    0: begin
      if cbxSortBy.ItemIndex <> 1 then
  value := FGenealogy.peekInd(nIndex).FamilyName +', '+
       FGenealogy.PeekInd(nIndex).GivenName
     else
       value := FGenealogy.peekInd(nIndex).GivenName +', '+
            FGenealogy.peekInd(nIndex).FamilyName;
      end;
    1: // Todo: Marker
      value :=inttostr(nIndex);
    2: case cbxSortBy.ItemIndex of
      -1,0,1,2,5: value :=FGenealogy.peekInd(nIndex).BirthDate;
      3:;
        4:value :=FGenealogy.peekInd(nIndex).DeathDate;
       end
    end;
// Dates
end;

procedure TfraIndIndex.ListBox1SelectionChange(Sender: TObject; User: boolean);
var
  lIdx: Integer;
  lidInd: integer;
begin
   // Do The Selection
  lIdx := StringGrid1.row-1;
  if not User or (lIdx <0) then
    exit;

  if length(FIndexArray)>0 then
    FSelectedInd := FIndexArray[lIdx]
  else
    FSelectedInd := lIdx;

  if assigned(FGenealogy) then
    FGenealogy.Seek(FSelectedInd);


end;

procedure TfraIndIndex.edtFindChange(Sender: TObject);
var
  I, lTestIdx: Integer;
begin
  if length(edtFind.text) >0 then
    if length(FIndexArray) > 0 then

  for I := 0 to length(FIndexArray)-1 do
    begin
      lTestIdx:= (StringGrid1.Row-1+I) mod length(FIndexArray);
      if lTestIdx< 0 then
        lTestIdx:=0;
      if pos(uppercase(edtFind.text),uppercase(FGenealogy.Individual[FIndexArray[lTestIdx]].ToString)) <> 0 then
        begin
          StringGrid1.Row := lTestIdx+1;
          FSelectedInd := FIndexArray[lTestIdx];
          if assigned(FGenealogy) then
            FGenealogy.Seek(FSelectedInd);
          break;
        end;
    end;
end;

function TfraIndIndex.fktFamilynameSort(const List: TIntegerDynArray; Index1, Index2: Integer): ShortInt;
var
  lStr1, lStr2: String;
begin
  lStr1 :=uppercase(FGenealogy.PeekInd(List[index1]).FamilyName+', '+
     FGenealogy.PeekInd(List[index1]).GivenName);
  lStr2 :=uppercase(FGenealogy.PeekInd(List[index2]).FamilyName+', '+
     FGenealogy.PeekInd(List[index2]).GivenName);
  if lstr1 < lstr2 then
    result := -1
  else
    if lstr1 > lstr2 then
      result := 1
  else
    result := 0;
end;

function TfraIndIndex.fktGivenNameSort(const List: TIntegerDynArray; Index1, Index2: Integer): ShortInt;
var
  lStr1, lStr2: String;
begin
  lStr1 :=uppercase(FGenealogy.PeekInd(List[index1]).GivenName+' '+
     FGenealogy.PeekInd(List[index1]).FamilyName);
  lStr2 :=uppercase(FGenealogy.PeekInd(List[index2]).GivenName+' '+
     FGenealogy.PeekInd(List[index2]).FamilyName);
  if lstr1 < lstr2 then
    result := -1
  else
    if lstr1 > lstr2 then
      result := 1
  else
    result := 0;
end;

function TfraIndIndex.fktBirthSort(const List: TIntegerDynArray; Index1, Index2: Integer): ShortInt;
var
  lStr1, lStr2: String;
begin
  lStr1 :=uppercase(FGenealogy.PeekInd(List[index1]).BirthYear+
     FGenealogy.PeekInd(List[index1]).BirthMonth+
     FGenealogy.PeekInd(List[index1]).BirthDay);
  lStr2 :=uppercase(FGenealogy.PeekInd(List[index2]).BirthYear+
     FGenealogy.PeekInd(List[index2]).BirthMonth+
     FGenealogy.PeekInd(List[index2]).BirthDay);
  if lstr1 < lstr2 then
    result := -1
  else
    if lstr1 > lstr2 then
      result := 1
  else
    result := 0;
end;

function TfraIndIndex.fktIDSort(const List: TIntegerDynArray; Index1, Index2: Integer): ShortInt;
begin
  if list[Index1] < List[Index2] then
    result := -1
  else
    if List[Index1] > List[Index2] then
      result := 1
  else
    result := 0
end;

procedure TfraIndIndex.DoIndexSort(var aArray: TIntegerDynArray;
  aSortFkt: TIndCompareFkt; aLb: integer; aHb: integer);

Procedure Swap(var aArray:TIntegerDynArray;ind1,ind2:integer);inline;

var
  lDt: Integer;
begin
  lDt:=aArray[ind1];
  aArray[ind1]:=aArray[ind2];
  aArray[ind2]:=lDt;
end;

var
  lBoarder, lLbi, lHbi: Integer;
begin
  if aLb=-1 then
    begin
      aLb := 1;
      aHb := length(aArray)-1;
      lBoarder := (aHb+1) div 2;
    end
  else
    lBoarder:=(aLb+aHb) div 2;
  if aHb-aLb < 1 then
    exit; // Abbruchkriterium
  lLbi := aLb;
  lHbi:=aHb;
  while (lLbi<lHbi) do
    begin
      while (lLbi<lBoarder) and (aSortFkt(aArray,lLbi,lBoarder)<1) do
        inc(lLbi);
      While (lBoarder<lHbi) and (aSortFkt(aArray,lBoarder,lHbi)<1) do
        dec(lHbi);
      if (lLbi<lHbi) then
        begin
          Swap(aArray,lLbi,lHbi);
          if lLbi >= lBoarder then
            lBoarder:=lHbi
          else if lHbi <= lBoarder then
            lBoarder:=lLbi;
        end;
    end;
  DoIndexSort(aArray,aSortFkt,aLb,lBoarder-1);
  DoIndexSort(aArray,aSortFkt,lBoarder+1,aHb);
end;

procedure TfraIndIndex.StringGrid1SelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin

end;

procedure TfraIndIndex.StringGrid1Selection(Sender: TObject; aCol, aRow: Integer
  );
var
  lIdx: Integer;
begin
   lIdx := StringGrid1.row;
   if  (lIdx <0) then
     exit;

   if length(FIndexArray)>0 then
     FSelectedInd := FIndexArray[lIdx]
   else
     FSelectedInd := lIdx;

   if assigned(FGenealogy) and (FSelectedInd <> FGenealogy.GetActID) then
     FGenealogy.Seek(FSelectedInd);

end;

procedure TfraIndIndex.Sort(aCol, aType: integer);
begin
  if (acol =0) and (aType = 0) then
    cbxSortBy.ItemIndex:=0
  else   if (acol =0) and (aType = 1) then
    cbxSortBy.ItemIndex:=1
  else   if (acol =0) and (aType = 2) then
    cbxSortBy.ItemIndex:=0
  else   if (acol =2) and (aType = 0) then
    cbxSortBy.ItemIndex:=2
  else   if (acol =2) and (aType = 1) then
    cbxSortBy.ItemIndex:=3
  else   if (acol =2) and (aType = 2) then
    cbxSortBy.ItemIndex:=4
  else   if (acol =2) and (aType = 3) then
    cbxSortBy.ItemIndex:=2
  else
    cbxSortBy.ItemIndex:=5 ;

end;

function TfraIndIndex.fktDeathSort(const List: TIntegerDynArray; Index1,
  Index2: Integer): ShortInt;
var
  lStr1, lStr2: String;
begin
  lStr1 :=uppercase(FGenealogy.PeekInd(List[index1]).DeathYear+
     FGenealogy.PeekInd(List[index1]).DeathMonth+
     FGenealogy.PeekInd(List[index1]).DeathDay);
  lStr2 :=uppercase(FGenealogy.PeekInd(List[index2]).DeathYear+
     FGenealogy.PeekInd(List[index2]).DeathMonth+
     FGenealogy.PeekInd(List[index2]).DeathDay);
  if lstr1 < lstr2 then
    result := -1
  else
    if lstr1 > lstr2 then
      result := 1
  else
    result := 0;
end;

procedure TfraIndIndex.cbxSortByChange(Sender: TObject);

var
  ltest: String;
  i: Integer;

begin
  if (cbxSortBy.ItemIndex <>5) and (length(FIndexArray) =0) then
    begin
      setlength(FIndexArray,FGenealogy.IndividualCount+1);
      for i := 0 to length(FIndexArray)-1 do
        FIndexArray[i]:=i;
    end;
  case cbxSortBy.ItemIndex of
    0: begin
          DoIndexSort(FIndexArray,@fktFamilynameSort);
          StringGrid1.Columns[0].Title.Caption:=rsSurname+rsSortKnUp;
          StringGrid1.Columns[1].Title.Caption:=rsID;
          StringGrid1.Columns[2].Title.Caption:=rsGeburt;
        end;
     1: begin
          DoIndexSort(FIndexArray,@fktGivenNameSort);
          StringGrid1.Columns[0].Title.Caption:=rsGivnname+rsSortKnUp;
          StringGrid1.Columns[1].Title.Caption:=rsID;
          StringGrid1.Columns[2].Title.Caption:=rsGeburt;
        end;
    2: begin
          DoIndexSort(FIndexArray,@fktBirthSort);
          StringGrid1.Columns[0].Title.Caption:=rsSurname;
          StringGrid1.Columns[1].Title.Caption:=rsID;
          StringGrid1.Columns[2].Title.Caption:=rsGeburt+rsSortKnUp;
        end;
    4:  begin
          DoIndexSort(FIndexArray,@fktDeathSort);
          StringGrid1.Columns[0].Title.Caption:=rsSurname;
          StringGrid1.Columns[1].Title.Caption:=rsID;
          StringGrid1.Columns[2].Title.Caption:=rsDeath+rsSortKnUp;
        end;
    5:  begin
          DoIndexSort(FIndexArray,@fktIDSort);
          StringGrid1.Columns[0].Title.Caption:=rsSurname;
          StringGrid1.Columns[1].Title.Caption:=rsID+rsSortKnUp;
          StringGrid1.Columns[2].Title.Caption:=rsGeburt;
        end;
  else
  end;
//  else
//    ltest :=  ListBox1.Items.ClassName;
    StringGrid1.Invalidate;
end;

procedure TfraIndIndex.edtFindKeyPress(Sender: TObject; var Key: char);
begin
  //if Key = ;
end;

procedure TfraIndIndex.GenOnUpdate(Sender: TObject);
var
  lIdx, i: Integer;
begin
  if (length(FIndexArray)=0) and (FIndCount <> FGenealogy.Count) then
    begin
      UpdateList(sender);
      FIndCount := FGenealogy.Count
    end
  else if (length(FIndexArray)>0) and (FIndCount <> length(FIndexArray)) then
    begin
      UpdateList(sender);
      FIndCount := length(FIndexArray)
    end;

  if FSelectedInd <> FGenealogy.GetActID then
    begin
      FSelectedInd := FGenealogy.GetActID;
      if length(FIndexArray) =0 then
        lIdx :=FSelectedInd
      else
        begin
          lIdx :=-1;  // Not Found
          for i := 0 to length(FIndexArray)-1 do
            if FIndexArray[i]=FSelectedInd then
              begin
                lIdx := i;
                break;
              end;
        end;
      if lIdx>=0 then
        StringGrid1.Row:=lIdx
      else
        StringGrid1.Row:=0;
    end;
  if assigned(FoldGenOnUpdate) then
    FoldGenOnUpdate(Sender);
end;

end.

