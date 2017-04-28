unit XMLIntf;

{$mode delphi}

interface

uses
  Classes, SysUtils;

Type
  IXMLNodes=interface;

  { IXMLNode }

  IXMLNode=interface
    function GetAttributes(AParam: String): string;
    function GetChildNodes: IXMLNodes;
    function GetText: string;
    procedure SetAttributes(AParam: String; AValue: string);
    Procedure SetAttributeNS(AParam: String;Def, AValue: string);
    procedure SetChildNodes(AValue: IXMLNodes);
    procedure SetText(AValue: string);
    procedure AddChild(AChildName:String);
    property Attributes[AParam:String]:string read GetAttributes write SetAttributes;
    property ChildNodes:IXMLNodes read GetChildNodes write SetChildNodes;
    property Text:string read GetText write SetText;
  end;

 { IXMLNodes }

 IXMLNodes=interface
    function FindNode(AParam:String):IXMLNode;
    function GetChildNode: IXMLNode;
    function GetCount: integer;
    function GetNodes(AParam: String): IXMLNode;overload;
    function GetNodes(AParam: integer): IXMLNode;overload;
    procedure SetChildNode(AValue: IXMLNode);
    procedure SetCount(AValue: integer);
    procedure SetNodes(AParam: String; AValue: IXMLNode);overload;
    procedure SetNodes(AParam: integer; AValue: IXMLNode);overload;
    property ChildNode:IXMLNode read GetChildNode write SetChildNode;
    property Nodes[AParam:String]:IXMLNode read GetNodes write SetNodes;
    property Nodes[AParam:integer]:IXMLNode read GetNodes write SetNodes;
    property Count:integer read GetCount write SetCount;
  end;

implementation

end.

