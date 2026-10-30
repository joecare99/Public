unit cls_GenHelperBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, unt_IGenBase2 ;

type
    TTHlprMsgEvent=TTMessageEvent;

{ TGenHelperBase }

 TGenHelperBase=class
    private
        FonHlpMessage: TTHlprMsgEvent;
        procedure SetCitation(const AValue: TStrings);
        procedure SetCitTitle(const AValue: string);
        procedure SetonHlpMessage(const AValue: TTHlprMsgEvent);
        procedure SetOsbHdr(const AValue: string);

    protected
        FCitation: TStrings;
        FCitRefn: string;
        FCitTitle: string;
        FOsbHdr: string;


        function NormalCitRef(const aText: string): String;
        Procedure Warning(aText:String ; Ref: string; aMode: integer);
        Procedure Error(aText:String ; Ref: string; aMode: integer);
    public
        procedure Clear;virtual;abstract;
        procedure StartFamily(Sender: TObject; aText, {%H-}aRef: string;
        {%H-}SubType: integer);virtual;abstract;
        procedure StartIndiv(Sender: TObject; aText, aRef: string;
          SubType: integer);virtual;abstract;
        procedure FamilyIndiv(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure FamilyType(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure FamilyDate(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure FamilyData(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure FamilyPlace(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure IndiData(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure IndiDate(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure IndiName(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure IndiPlace(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure IndiRef(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure IndiOccu(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure IndiRel(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure EndOfEntry(Sender: TObject; aText, aRef: string; SubType: integer);virtual;abstract;
        procedure CreateNewHeader(Filename: string);virtual;abstract;
        procedure SaveToFile(const Filename: string);virtual;abstract;
        procedure FireEvent(Sender: TObject; aSTa: TStringArray);
        property Citation: TStrings read FCitation write SetCitation;
        property CitTitle: string read FCitTitle write SetCitTitle;
        property OsbHdr: string read FOsbHdr write SetOsbHdr;
        property onHlpMessage:TTHlprMsgEvent read FonHlpMessage write SetonHlpMessage;
    end;

implementation

uses Unt_StringProcs;
{ TGenHelperBase }

procedure TGenHelperBase.SetCitation(const AValue: TStrings);
begin
  if @FCitation=@AValue then Exit;
  FCitation:=AValue;
  FCitRefn:='';
end;

procedure TGenHelperBase.SetCitTitle(const AValue: string);
begin
  if FCitTitle=AValue then Exit;
  FCitTitle:=AValue;
end;

procedure TGenHelperBase.SetonHlpMessage(const AValue: TTHlprMsgEvent);
begin
  if @FonHlpMessage=@AValue then Exit;
  FonHlpMessage:=AValue;
end;

procedure TGenHelperBase.SetOsbHdr(const AValue: string);
begin
  if FOsbHdr=AValue then Exit;
  FOsbHdr:=AValue;
end;

function TGenHelperBase.NormalCitRef(const aText: string): String;
var
  lText: String;
  lp1, i: Integer;
begin
  if aText.StartsWith('F') or aText.StartsWith('I') then
    lText := atext.Substring(1)
  else
    lText:=aText;

  // 1. Ziffernfolge wird
  lp1 :=lText.IndexOfAny('0123456789');
  if lp1 <0 then exit(lText);

  i := lp1 +1;
  while (i<length(lText)) and (lText.Chars[i] in Ziffern) do
    inc(i);
  result := lText.Insert(lp1,StringOfChar('0',4-(i-lp1)));
end;

procedure TGenHelperBase.Warning(aText: String; Ref: string; aMode: integer);
begin
  if assigned(FonHlpMessage) then
    FonHlpMessage(self,etWarning,aText,Ref,aMode);
end;

procedure TGenHelperBase.Error(aText: String; Ref: string; aMode: integer);
begin
  if assigned(FonHlpMessage) then
      FonHlpMessage(self,etError,aText,Ref,aMode);
end;

procedure TGenHelperBase.FireEvent(Sender: TObject; aSTa: TStringArray);
var
  lInt: Longint;
begin
  if (length(aSTa) = 4) and trystrtoint(asta[3], lInt) then
      case aSTa[0] of
          'ParserStartIndiv': StartIndiv(Sender, aSTa[1], aSTa[2], lInt);
          'ParserStartFamily': StartFamily(Sender, aSTa[1], aSTa[2], lInt);
          'ParserFamilyType': FamilyType(Sender, aSTa[1], aSTa[2], lInt);
          'ParserFamilyDate': FamilyDate(Sender, aSTa[1], aSTa[2], lInt);
          'ParserFamilyData': FamilyData(Sender, aSTa[1], aSTa[2], lInt);
          'ParserFamilyIndiv': FamilyIndiv(Sender, aSTa[1], aSTa[2], lInt);
          'ParserFamilyPlace': FamilyPlace(Sender, aSTa[1], aSTa[2], lInt);
          'ParserIndiData': IndiData(Sender, aSTa[1], aSTa[2], lInt);
          'ParserIndiDate': IndiDate(Sender, aSTa[1], aSTa[2], lInt);
          'ParserIndiName': IndiName(Sender, aSTa[1], aSTa[2], lInt);
          'ParserIndiOccu': IndiOccu(Sender, aSTa[1], aSTa[2], lInt);
          'ParserIndiPlace': IndiPlace(Sender, aSTa[1], aSTa[2], lInt);
          'ParserIndiRef': IndiRef(Sender, aSTa[1], aSTa[2], lInt);
          'ParserIndiRel': IndiRel(Sender, aSTa[1], aSTa[2], lInt);
        end;
end;

end.

