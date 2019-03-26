unit frm_KingdomMain;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  ExtCtrls, ExtDlgs, cls_KingdomEng;

type

  { TfrmKingdomMain }

  TfrmKingdomMain = class(TForm)
    Bevel1: TBevel;
    btnBuy: TButton;
    btnSell: TButton;
    btnDistrFood: TButton;
    btnProduce: TButton;
    btnNext: TButton;
    btnNew: TButton;
    CalculatorDialog1: TCalculatorDialog;
    edtAmountOfLand: TSpinEdit;
    edtAmountOfLand2: TSpinEdit;
    edtArea: TLabeledEdit;
    edtDistrFood: TSpinEdit;
    edtPopulation: TLabeledEdit;
    edtStorage: TLabeledEdit;
    edtPriceOfLand: TLabeledEdit;
    Label1: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure btnBuyClick(Sender: TObject);
    procedure btnDistrFoodClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnProduceClick(Sender: TObject);
    procedure btnSellClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     FKingdom:TKingdomEngine;
     Procedure DisplayMessage(Msg:string;Clear:boolean=false);
     Procedure UpdateValues;
  protected
     property Kingdom:TKingdomEngine read FKingdom;
  public

  end;

var
  frmKingdomMain: TfrmKingdomMain;

implementation

uses unt_KingdomBase;
{$R *.lfm}

{ TfrmKingdomMain }

procedure TfrmKingdomMain.btnBuyClick(Sender: TObject);
begin
  if not FKingdom.BuySellLand(edtAmountOfLand.Value) then
     DisplayMessage(FKingdom.BuySellMsg(edtAmountOfLand.Value))
  else
     DisplayMessage(rsOK);
  UpdateValues;
end;

procedure TfrmKingdomMain.btnDistrFoodClick(Sender: TObject);
begin
  if not FKingdom.Distribute(edtDistrFood.Value) then
     DisplayMessage(FKingdom.DistrMsg(edtDistrFood.Value))
  else
     DisplayMessage(rsOK);
  UpdateValues;
end;

procedure TfrmKingdomMain.btnNewClick(Sender: TObject);
begin
  FKingdom.NewGame;
  DisplayMessage(FKingdom.YearDescription,true);
  UpdateValues;
end;

procedure TfrmKingdomMain.btnNextClick(Sender: TObject);
begin
  if not FKingdom.NewYear(false) then
    begin
      DisplayMessage(FKingdom.NewYearMsg);
      exit;
    end;
  DisplayMessage(FKingdom.YearDescription,true);
  UpdateValues;
end;

procedure TfrmKingdomMain.btnProduceClick(Sender: TObject);
begin
  if not FKingdom.Production(edtAmountOfLand2.Value) then
     DisplayMessage(FKingdom.ProdMsg(edtAmountOfLand2.Value))
  else
     DisplayMessage(rsOK);
  UpdateValues;
end;

procedure TfrmKingdomMain.btnSellClick(Sender: TObject);
begin
  if not FKingdom.BuySellLand(-edtAmountOfLand.Value) then
     DisplayMessage(FKingdom.BuySellMsg(-edtAmountOfLand.Value))
  else
     DisplayMessage(rsOK);
  UpdateValues;
end;

procedure TfrmKingdomMain.FormCreate(Sender: TObject);
begin
  FKingdom:=TKingdomEngine.Create;
end;

procedure TfrmKingdomMain.FormDestroy(Sender: TObject);
begin
  freeandnil(FKingdom);
end;

procedure TfrmKingdomMain.FormShow(Sender: TObject);
begin
  DisplayMessage(FKingdom.GameDescription,True);
end;

procedure TfrmKingdomMain.DisplayMessage(Msg: string; Clear: boolean);
begin
  if Clear then
    Memo1.clear;
  memo1.Append(Msg);
end;

procedure TfrmKingdomMain.UpdateValues;
var
  lMaxProd: Integer;
begin
  edtPopulation.Text := inttostr(FKingdom.Population);
  edtStorage.Text := inttostr(FKingdom.Storage);
  edtArea.Text := inttostr(FKingdom.Area);
  edtPriceOfLand.Text := inttostr(FKingdom.LandPrice);
// HintLabel
  lMaxProd:=FKingdom.Area;
  edtDistrFood.MinValue:=-FKingdom.Distributed;
  if FKingdom.Population*10<lMaxProd then lMaxProd:=FKingdom.Population*10;

  Label1.Caption:=
      'Vor:            '#9+edtStorage.Text+LineEnding+
      'Bev: '+edtPopulation.Text+' *20 ='#9+inttostr(-FKingdom.Population*20+
            FKingdom.Distributed)+#9+'('+inttostr(FKingdom.Distributed)+')'+LineEnding+
      'Prod: '+inttostr(lMaxProd)+' /2 ='#9+inttostr(-lMaxProd div 2)+#9+'('+
            inttostr(FKingdom.LandInProd div 2)+')'+LineEnding+
      '-----------------------------'+LineEnding+
      'Summ:           '#9+inttostr(FKingdom.Storage-FKingdom.Population*20-lMaxProd div 2+FKingdom.Distributed);
end;

end.

