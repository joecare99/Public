unit SymbolUnit;
{}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type TSchematicObjectType = (Polygon, Rectangle, Circle, Arc, Text);

TSchematicObject = Class(TObject)
  public
    location : TPoint;
    SchematicObjectType : TSchematicObjectType;
     width  : Integer;
     height : Integer;
    class procedure setHeightAndWidth( objwidth, objheight : Integer; SchematicObject : TSchematicObject);
end;


implementation
class procedure TSchematicObject.setHeightAndWidth( objwidth, objheight : Integer;  SchematicObject : TSchematicObject);
begin
    SchematicObject.width  := objwidth;
    SchematicObject.height := objheight;
end;

end.

