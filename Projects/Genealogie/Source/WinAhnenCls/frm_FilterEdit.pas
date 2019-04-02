unit frm_FilterEdit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  cls_HejData, cls_HejDataFilter;

type

  { TFrmFilterEdit }

  TFrmFilterEdit = class(TForm)
    cbxHejConcType: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit1: TEdit;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FFilter: TGenFilter;
    Procedure FillHejConcTypeList(const aSt:TStrings);
    Procedure FillHejCompareTypeList(const aSt:TStrings);
    procedure SetFilter(AValue: TGenFilter);
  public
    property Filter:TGenFilter read FFilter write SetFilter;
  end;

var
  FrmFilterEdit: TFrmFilterEdit;

implementation

{$R *.lfm}

uses LResources;
{ TFrmFilterEdit }

function setResStr(Name, Value: AnsiString; Hash: Longint; arg: pointer
  ): AnsiString;
begin
  TStrings(arg).Add(Name+'='+Value);
end;

procedure TFrmFilterEdit.FormCreate(Sender: TObject);
begin
  FillHejConcTypeList(cbxHejConcType.Items);
end;

procedure TFrmFilterEdit.FormShow(Sender: TObject);
begin
  memo1.Clear;
  if rshCcT_or <>'' then
  SetResourceStrings(@setResStr,Memo1.Lines);
//  FillHejConcTypeList(Memo1.Lines);
end;

procedure TFrmFilterEdit.FillHejConcTypeList(const aSt: TStrings);
var
  i: TEnumHejConcType;
  j: Integer;
begin
  aSt.Clear;
//  for i in TEnumHejConcType do
//    ast.AddObject(LazarusResources.Find('cls_HejDataFilter.rs'+CConcat[i]).Value,TObject(ptrint(ord(i))));
   for j := 0 to LazarusResources.Count-1 do
     ast.AddObject(LazarusResources.Items[j].Name+'='+LazarusResources.Items[j].Value,nil);
end;

procedure TFrmFilterEdit.FillHejCompareTypeList(const aSt: TStrings);
var
  i: TEnumHejCompareType;
begin
  aSt.Clear;
//  for i in TEnumHejCompareType do
//    ast.AddObject(LazarusResources.Find('rs'+CCompType[i]).Value,TObject(ptrint(ord(i))));
end;

procedure TFrmFilterEdit.SetFilter(AValue: TGenFilter);
begin
  if FFilter=AValue then Exit;
  FFilter:=AValue;
end;

end.

