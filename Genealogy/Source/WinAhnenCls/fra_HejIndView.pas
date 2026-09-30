unit fra_HejIndView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Grids,
  cls_HejData;

type

  { TFrame1 }

  TFrame1 = class(TFrame)
    StringGrid1: TStringGrid;
    procedure StringGrid1CellProcess(Sender: TObject; aCol, aRow: Integer;
      processType: TCellProcessType; var aValue: string);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
  private
     FGenealogy:TClsHejGenealogy;
     procedure GenOnDataChange(Sender: TObject);
     procedure GenOnUpdate(Sender: TObject);
     procedure SetGenealogy(AValue: TClsHejGenealogy);
  public
     Property Genealogy:TClsHejGenealogy read FGenealogy write SetGenealogy;
  end;

implementation

{$R *.lfm}

uses cls_HejIndData;

{ TFrame1 }

procedure TFrame1.StringGrid1CellProcess(Sender: TObject; aCol, aRow: Integer;
  processType: TCellProcessType; var aValue: string);
begin

end;

procedure TFrame1.StringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  if assigned(FGenealogy) then
   begin
     if arow >0 then
        Value := FGenealogy.GetData(ARow-1,TEnumHejIndDatafields(ACol-1))
     else
       Value := CHejIndDataDesc[TEnumHejIndDatafields(ACol)];
   end;
end;

procedure TFrame1.SetGenealogy(AValue: TClsHejGenealogy);
begin
  if FGenealogy=AValue then Exit;
  FGenealogy:=AValue;
  if assigned(FGenealogy) then
   begin
     FGenealogy.OnUpdate:=@GenOnUpdate;
     FGenealogy.OnDataChange:=@GenOnDataChange;
   end;
end;

procedure TFrame1.GenOnUpdate(Sender: TObject);
var
  lActDS: Integer;
begin
  lActDS:= FGenealogy.GetActID;
  StringGrid1.Row:=lactDS +1;
  GenOnDataChange(Sender);
end;

procedure TFrame1.GenOnDataChange(Sender: TObject);
var
  aFld: TEnumHejIndDatafields;
  lActDS: Integer;
begin
  for aFld in TEnumHejIndDatafields do
    Begin
      lActDS:= FGenealogy.GetActID;
      StringGrid1.Cells[ord(aFld)+1,lActDS+1];
    end;
end;

end.

