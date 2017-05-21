unit cla_DomFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,forms,dom;

type

{ TDomFrame }

 TDomFrame=class(TFrame)
   private
     FDataAnchor:TDOMElement;
     procedure SetDataAnchor(AValue: TDomElement);
   public
     Property DataAnchor:TDomElement read FDataAnchor write SetDataAnchor;
   end;

implementation

{ TDomFrame }

procedure TDomFrame.SetDataAnchor(AValue: TDomElement);
begin
  if FDataAnchor=AValue then Exit;
  FDataAnchor:=AValue;
end;

end.

