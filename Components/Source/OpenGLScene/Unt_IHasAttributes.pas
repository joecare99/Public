unit Unt_IHasAttributes;

{$mode delphi}

interface

uses
  variants;

type

{ IHasAttributes }

 IHasAttributes=interface
        ['{50CDF743-3ACE-438E-B797-843148610163}']
        function AttrCount:integer;
        function GetAttributes(idx: variant): variant;
        procedure SetAttributes(idx: variant; AValue: variant);
        Function ListAttr:variant;
        property Attributes[idx:variant]:variant read GetAttributes write SetAttributes;
     end;

implementation

end.

