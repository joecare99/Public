unit frw_Kingdom;

{$mode objfpc}

interface

uses
  JS, Classes, SysUtils, Web, cls_KingdomEng;

type

{ TFrwKingdom }

 TFrwKingdom=Class
  private
    FKingdomEng:TKingdomEngine;
    function btnBuyClick(aEvent: TJSMouseEvent): boolean;
    function btnSellClick(aEvent: TJSMouseEvent): boolean;
  public
    edtTextOutValue: TJSNode;
    pnlMain,
    pnlInput,
    pnlStatus:TJSElement;

    edtTextOut : TJSHTMLElement;

    edtBuySellLand : TJSHTMLInputElement;
    edtDistribute : TJSHTMLInputElement;
    edtProduce : TJSHTMLInputElement;

    btnBuy: TJSHTMLButtonElement;
    btnSell: TJSHTMLButtonElement;
    btnDistribute: TJSHTMLButtonElement;
    btnProduce: TJSHTMLButtonElement;
    btnNew: TJSHTMLButtonElement;
    btnNext: TJSHTMLButtonElement;

    function btnNewClick(Event{%H-}: TJSMouseEvent): boolean;
    function btnNextClick(Event{%H-}: TJSMouseEvent): boolean;

    constructor Create;reintroduce;
  end;

implementation

uses unt_KingdomBase;

{ TFrwKingdom }

function TFrwKingdom.btnBuyClick(aEvent: TJSMouseEvent): boolean;
var
  aVal: NativeInt;
begin
  if tryStrToint(edtBuySellLand.value,aVal) then
     if  FKingdomEng.BuySellLand(abs(aVal)) then
  edtTextOutValue.textContent:=edtTextOutValue.textContent+LineEnding+
   rsOK
   else
     edtTextOutValue.textContent:=edtTextOutValue.textContent+LineEnding+
      FKingdomEng.BuySellMsg(abs(aVal))
end;

function TFrwKingdom.btnSellClick(aEvent: TJSMouseEvent): boolean;
var
  aVal: NativeInt;
begin
  if tryStrToint(edtBuySellLand.value,aVal) then
     if  FKingdomEng.BuySellLand(-abs(aVal)) then
  edtTextOutValue.textContent:=edtTextOutValue.textContent+LineEnding+
   rsOK
   else
     edtTextOutValue.textContent:=edtTextOutValue.textContent+LineEnding+
      FKingdomEng.BuySellMsg(-abs(aVal))
end;

function TFrwKingdom.btnNewClick(Event: TJSMouseEvent): boolean;
begin
  FKingdomEng.NewGame;
  edtTextOutValue.textContent:=FKingdomEng.YearDescription;
end;

function TFrwKingdom.btnNextClick(Event: TJSMouseEvent): boolean;
begin
  if FKingdomEng.NewYear(false) then
     edtTextOutValue.textContent:=FKingdomEng.YearDescription
  else
    edtTextOutValue.textContent:=edtTextOutValue.textContent+LineEnding +
      FKingdomEng.NewYearMsg;
end;

constructor TFrwKingdom.Create;

Function CreateNumberEdit (aName : String) : TJSHTMLInputElement;

begin
  Result:=TJSHTMLInputElement(document.createElement('input'));
  Result['type']:='text';
  Result.value:='0';
  Result.name:=aName;
  Result['style']:='width: 80px;';
end;

Function CreateMemoEdit (aName : String) : TJSHTMLElement;

begin
  Result:=TJSHTMLElement(document.createElement('div'));
  Result.name:=aName;
  Result['style']:='width: 640px; height: 480px;';
end;

Function CreateButton (aName,aCaption : String) : TJSHTMLButtonElement;

begin
  Result:=TJSHTMLButtonElement(document.createElement('input'));
  Result['id']:=aName;
  Result['type']:='submit';
  Result['value']:=aCaption;
  Result.name:=aName;
  Result['style']:='width: 160px;';
  Result['class']:='btn btn-default';
end;

var
  lPre: TJSElement;
begin
  FKingdomEng:= TKingdomEngine.create;

pnlMain:=document.createElement('div');
// attrs are default array property...
pnlMain['class']:='panel panel-default';

pnlInput:=document.createElement('div');
pnlInput['class']:='panel-body';

pnlStatus:=document.createElement('div');
pnlStatus['class']:='panel-body';

edtBuySellLand:=CreateNumberEdit('edtBuySellLand');
edtDistribute:=CreateNumberEdit('edtDistribute');
edtProduce:=CreateNumberEdit('edtProduce');

btnBuy:=CreateButton('btnBuy','Kaufen');
btnBuy.onclick:=@btnBuyClick;

btnSell:=CreateButton('btnSell','Verkaufen');
btnSell.onclick:=@btnSellClick;

btnNew:=CreateButton('btnNew','Neues Spiel');
btnNew.style.setProperty('height','40px');
btnNew.onclick:=@btnNewClick;

btnNext:=CreateButton('btnNext','Nächstes Jahr');
btnNext.style.setProperty('height','40px');
btnNext.onclick:=@btnNextClick;

edtTextOut:=CreateMemoEdit('edtTextOut');
edtTextOutValue:= document.createTextNode('...');

lPre:=document.createElement('pre');
lPre.appendChild(edtTextOutValue);
edtTextOut.appendChild(lPre);
document.body.appendChild(pnlMain);
pnlMain.appendChild(pnlStatus);
pnlMain.appendChild(pnlInput);

pnlInput.appendChild(document.createElement('BR'));
pnlInput.appendChild(edtTextOut);
pnlInput.appendChild(document.createElement('BR'));
pnlInput.appendChild(document.createTextNode('Land in Tagwerk:'));
pnlInput.appendChild(document.createElement('BR'));
pnlInput.appendChild(edtBuySellLand);
pnlInput.appendChild(btnBuy);
pnlInput.appendChild(btnSell);
pnlInput.appendChild(document.createElement('BR'));
pnlInput.appendChild(document.createTextNode('Getreide in Büschel:'));
pnlInput.appendChild(document.createElement('BR'));
pnlInput.appendChild(edtDistribute);
pnlInput.appendChild(document.createElement('BR'));
pnlInput.appendChild(document.createTextNode('Land in Tagwerk:'));
pnlInput.appendChild(document.createElement('BR'));
pnlInput.appendChild(edtProduce);
pnlInput.appendChild(document.createElement('BR'));

pnlInput.appendChild(btnNew);
pnlInput.appendChild(document.createTextNode('   '));
pnlInput.appendChild(btnNext);
edtTextOutvalue.textContent:=FKingdomEng.GameDescription;
end;

end.

