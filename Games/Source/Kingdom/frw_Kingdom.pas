UNIT frw_Kingdom;

{$mode objfpc}

INTERFACE

USES
  JS, Classes, SysUtils, Web, cls_KingdomEng;

TYPE

  { TFrwKingdom }

  TFrwKingdom = CLASS
  private
    FKingdomEng: TKingdomEngine;
    FUNCTION btnBuyClick(aEvent: TJSMouseEvent): Boolean;
    FUNCTION btnDistributeClick(aEvent: TJSMouseEvent): Boolean;
    FUNCTION btnProduceClick(aEvent: TJSMouseEvent): Boolean;
    FUNCTION btnSellClick(aEvent: TJSMouseEvent): Boolean;
    Procedure DisplayMessage(Msg:string;Clear:boolean=false);
    Procedure UpdateValues;
  public
//    edtTextOutValue: TJSNode;
    pnlMain, pnlInput, pnlStatus: TJSElement;

    edtTextOut: TJSHTMLElement;

    edtBuySellLand: TJSHTMLInputElement;
    edtDistribute:  TJSHTMLInputElement;
    edtProduce:     TJSHTMLInputElement;

    edtPopulation: TJSHTMLInputElement;
    edtArea:    TJSHTMLInputElement;
    edtStorage: TJSHTMLInputElement;
    edtPrice:   TJSHTMLInputElement;
    lblHint:    TJSNode;

    btnBuy:     TJSHTMLButtonElement;
    btnSell:    TJSHTMLButtonElement;
    btnDistribute: TJSHTMLButtonElement;
    btnProduce: TJSHTMLButtonElement;
    btnNew:     TJSHTMLButtonElement;
    btnNext:    TJSHTMLButtonElement;

    FUNCTION btnNewClick(Event{%H-}: TJSMouseEvent): Boolean;
    FUNCTION btnNextClick(Event{%H-}: TJSMouseEvent): Boolean;

    CONSTRUCTOR Create; reintroduce;
  END;

IMPLEMENTATION

USES unt_KingdomBase;

{ TFrwKingdom }

function TFrwKingdom.btnBuyClick(aEvent: TJSMouseEvent): Boolean;
VAR
  aVal: NativeInt;
BEGIN
  IF tryStrToint(edtBuySellLand.Value, aVal) THEN
    IF FKingdomEng.BuySellLand(abs(aVal)) THEN
      DisplayMessage(rsOK)
    ELSE
      DisplayMessage(FKingdomEng.BuySellMsg(abs(aVal)));
  UpdateValues;
END;

function TFrwKingdom.btnDistributeClick(aEvent: TJSMouseEvent): Boolean;
VAR
  aVal: NativeInt;
BEGIN
  IF tryStrToint(edtDistribute.Value, aVal) THEN
    IF FKingdomEng.Distribute(aVal) THEN
      DisplayMessage(rsOK)
    ELSE
     DisplayMessage(FKingdomEng.DistrMsg(aVal));
    UpdateValues;
END;

function TFrwKingdom.btnProduceClick(aEvent: TJSMouseEvent): Boolean;
VAR
  aVal: NativeInt;
BEGIN
  IF tryStrToint(edtProduce.Value, aVal) THEN
    IF FKingdomEng.Production(aVal) THEN
      DisplayMessage(rsOK)
    ELSE
      DisplayMessage(FKingdomEng.ProdMsg(aVal));
    UpdateValues;
END;

function TFrwKingdom.btnSellClick(aEvent: TJSMouseEvent): Boolean;
VAR
  aVal: NativeInt;
BEGIN
  IF tryStrToint(edtBuySellLand.Value, aVal) THEN
    IF FKingdomEng.BuySellLand(-abs(aVal)) THEN
      DisplayMessage(rsOK)
    ELSE
      DisplayMessage(FKingdomEng.BuySellMsg(-abs(aVal)));
    UpdateValues;
END;

procedure TFrwKingdom.DisplayMessage(Msg: string; Clear: boolean);
begin
  if Clear then
    edtTextOut.textContent := Msg
  ELSE
    edtTextOut.textContent := edtTextOut.textContent + LineEnding + Msg
end;

procedure TFrwKingdom.UpdateValues;
var
  lMaxProd: Integer;
begin
  edtPopulation.value := inttostr(FKingdomEng.Population);
  edtStorage.value := inttostr(FKingdomEng.Storage);
  edtArea.value := inttostr(FKingdomEng.Area);
  edtPrice.value := inttostr(FKingdomEng.LandPrice);
// HintLabel
  lMaxProd:=FKingdomEng.Area;
//  edtDistrFood.MinValue:=-FKingdomEng.Distributed;
  if FKingdomEng.Population*10<lMaxProd then lMaxProd:=FKingdomEng.Population*10;

  lblHint.textContent :=
      'Vor:            '#9+edtStorage.value+LineEnding+
      'Bev: '+edtPopulation.value+' *20 ='#9+inttostr(-FKingdomEng.Population*20+
            FKingdomEng.Distributed)+#9+'('+inttostr(FKingdomEng.Distributed)+')'+LineEnding+
      'Prod: '+inttostr(lMaxProd)+' /2 ='#9+inttostr(-lMaxProd div 2)+#9+'('+
            inttostr(FKingdomEng.LandInProd div 2)+')'+LineEnding+
      '-----------------------------'+LineEnding+
      'Summ:           '#9+inttostr(FKingdomEng.Storage-FKingdomEng.Population*20-lMaxProd div 2+FKingdomEng.Distributed);

end;

function TFrwKingdom.btnNewClick(Event: TJSMouseEvent): Boolean;
BEGIN
  FKingdomEng.NewGame;
  DisplayMessage( FKingdomEng.YearDescription,true);
  UpdateValues;
END;

function TFrwKingdom.btnNextClick(Event: TJSMouseEvent): Boolean;
BEGIN
  IF FKingdomEng.NewYear(False) THEN
    DisplayMessage( FKingdomEng.YearDescription,true)
  ELSE
    DisplayMessage( FKingdomEng.NewYearMsg);
    UpdateValues;
END;

constructor TFrwKingdom.Create;

  FUNCTION CreateNumberEdit(aName: String): TJSHTMLInputElement;

  BEGIN
    Result      := TJSHTMLInputElement(document.createElement('input'));
    Result['type'] := 'text';
    Result.Value := '0';
    Result.Name := aName;
    Result['style'] := 'width: 80px;';
  END;

  FUNCTION CreateMemoEdit(aName: String): TJSHTMLElement;

  BEGIN
    Result      := TJSHTMLElement(document.createElement('textarea'));
    Result.Name := aName;
    Result['id']:= 'memo';
    Result['rows']:= '25';
    Result['cols']:= '80';
//    Result['style'] := 'width: 640px; height: 480px;';
  END;

  FUNCTION CreateButton(aName, aCaption: String): TJSHTMLButtonElement;

  BEGIN
    Result      := TJSHTMLButtonElement(document.createElement('input'));
    Result['id'] := aName;
    Result['type'] := 'submit';
    Result['value'] := aCaption;
    Result.Name := aName;
    Result['style'] := 'width: 160px;';
    Result['class'] := 'btn btn-default';
  END;

VAR
  lPre, ltableCell, ltableRow, ltable: TJSElement;
BEGIN
  FKingdomEng := TKingdomEngine.Create;

  pnlMain := document.createElement('div');
  // attrs are default array property...
  pnlMain['class'] := 'panel panel-default';

  pnlInput := document.createElement('div');
  pnlInput['class'] := 'panel-body';

  pnlStatus := document.createElement('div');
  pnlStatus['class'] := 'panel-body';

  edtBuySellLand := CreateNumberEdit('edtBuySellLand');
  edtDistribute  := CreateNumberEdit('edtDistribute');
  edtProduce     := CreateNumberEdit('edtProduce');

  edtPopulation := CreateNumberEdit('edtPopulation');
  edtArea  := CreateNumberEdit('edtArea');
  edtStorage     := CreateNumberEdit('edtStorage');
  edtPrice     := CreateNumberEdit('edtPrice');

  lblHint := document.createTextNode('...');

  btnBuy := CreateButton('btnBuy', 'Kaufen');
  btnBuy.onclick := @btnBuyClick;

  btnSell := CreateButton('btnSell', 'Verkaufen');
  btnSell.onclick := @btnSellClick;

  btnDistribute := CreateButton('btnDistribute', 'Verteilen');
  btnDistribute.onclick := @btnDistributeClick;

  btnProduce := CreateButton('btnProduce', 'Anbauen');
  btnProduce.onclick := @btnProduceClick;


  btnNew := CreateButton('btnNew', 'Neues Spiel');
  btnNew.style.setProperty('height', '40px');
  btnNew.onclick := @btnNewClick;

  btnNext := CreateButton('btnNext', 'Nächstes Jahr');
  btnNext.style.setProperty('height', '40px');
  btnNext.onclick := @btnNextClick;

  edtTextOut      := CreateMemoEdit('edtTextOut');
  //lPre := document.createElement('pre');
  //edtTextOutValue := document.createTextNode('...');
  //lPre.appendChild(edtTextOutValue);
  //edtTextOut.appendChild(lPre);

  document.body.appendChild(pnlMain);

  ltable:=document.createElement('table');
  ltable['style'] := 'width: 100%';
  ltableRow:=document.createElement('tr');
  ltableCell:=document.createElement('td');
  ltableCell['style'] := 'width: 70%';
  pnlMain.appendChild(ltable);
  ltable.appendChild(ltableRow);
  ltableRow.appendChild(ltableCell);
  ltableCell.appendChild(pnlInput);
  ltableCell:=document.createElement('td');
  ltableCell['style'] := 'width: 30%';
  ltableRow.appendChild(ltableCell);
  ltableCell.appendChild(pnlStatus);


//  pnlInput.appendChild(document.createElement('BR'));
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
  pnlInput.appendChild(btnDistribute);
  pnlInput.appendChild(document.createElement('BR'));
  pnlInput.appendChild(document.createTextNode('Land in Tagwerk:'));
  pnlInput.appendChild(document.createElement('BR'));
  pnlInput.appendChild(edtProduce);
  pnlInput.appendChild(btnProduce);
  pnlInput.appendChild(document.createElement('BR'));

  pnlInput.appendChild(btnNew);
  pnlInput.appendChild(document.createTextNode('   '));
  pnlInput.appendChild(btnNext);

  pnlStatus.appendChild(document.createTextNode('Bevölkerung'));
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(edtPopulation);
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(document.createTextNode('Land'));
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(edtArea);
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(document.createTextNode('Vorrat:'));
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(edtStorage);
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(document.createTextNode('Preis pro Land'));
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(edtPrice);
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(document.createElement('BR'));

  lPre := document.createElement('pre');
  lPre.appendChild(lblHint);
  pnlStatus.appendChild(lPre);

  DisplayMessage( FKingdomEng.GameDescription,true);

END;

END.



