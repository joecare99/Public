unit XMLDoc;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils,XMLIntf;


type
 {
 TXMLChildNodes=Class(TCollectionItem, IXMLNode);

 end;

TXMLChildNodes=Class(TCollection, IXMLNodes);

end;
}

{ TXMLDocument }

 TXMLDocument=class(TComponent, IXMLNode)
private
  FActive: boolean;
  FXMLFileText:TStrings;
  FDocumentElement: IXMLNode;
  FAttributes:TStringList;
  FText:String;
  FChildNodes: IXMLNodes;
  procedure SetActive(AValue: boolean);
  procedure SetDocumentElement(AValue: IXMLNode);
  function GetAttributes(AParam: String): string;
    function GetChildNodes: IXMLNodes;
    function GetText: string;
    procedure SetAttributes(AParam: String; AValue: string);
    procedure SetAttributeNS(AParam: String;Def,  AValue: string);
    procedure SetChildNodes(AValue: IXMLNodes);
    procedure SetText(AValue: string);
published
    Property Active:boolean read FActive write SetActive;
    Property DocumentElement:IXMLNode read FDocumentElement write SetDocumentElement;
    property Attributes[AParam:String]:string read GetAttributes write SetAttributes;
    property ChildNodes:IXMLNodes read GetChildNodes write SetChildNodes;
    property Text:string read GetText write SetText;
  public
    constructor Create(AOwner:TComponent);
    procedure LoadFromFile(AFileName:string);
    Procedure SaveToFile(AFileName:string);
    procedure AddChild(AChildName:String);
  end;




implementation

{ TXMLDocument }

procedure TXMLDocument.SetActive(AValue: boolean);
begin
  if FActive=AValue then Exit;
  FActive:=AValue;
end;

procedure TXMLDocument.SetDocumentElement(AValue: IXMLNode);
begin
  if FDocumentElement=AValue then Exit;
  FDocumentElement:=AValue;
end;

function TXMLDocument.GetAttributes(AParam: String): string;
begin
  result := FAttributes.Values[AParam];
end;

function TXMLDocument.GetChildNodes: IXMLNodes;
begin
  Result := FChildNodes;
end;

function TXMLDocument.GetText: string;
begin
  result := FText;
end;

procedure TXMLDocument.SetAttributes(AParam: String; AValue: string);
begin
  FAttributes.Values[Aparam]:= AValue;
end;

procedure TXMLDocument.SetAttributeNS(AParam: String; Def, AValue: string);
begin
  FAttributes.Values[Aparam]:= AValue;
end;

procedure TXMLDocument.SetChildNodes(AValue: IXMLNodes);

begin
  FChildNodes:=AValue;
end;

procedure TXMLDocument.SetText(AValue: string);
begin
  Ftext:=AValue;
end;

constructor TXMLDocument.Create(AOwner: TComponent);
begin
  inherited;
  FXMLFileText := TStringList.Create;
end;

procedure TXMLDocument.LoadFromFile(AFileName: string);
begin
  FXMLFileText.LoadFromFile(AFilename);

end;

procedure TXMLDocument.SaveToFile(AFileName: string);
begin
  // ToDo:
end;

procedure TXMLDocument.AddChild(AChildName: String);
begin
 // Setlength(FChildren,succ(succ(high(FChildren))));
 // FChildren[high(FChildren)]:=TXMLDocNode.Create(self,AChildName);
end;

end.

