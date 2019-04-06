unit unt_RenderObjects;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, unt_Pointf3d;

type
    { TRenderList }
    TRenderList=class(TCollection)
        procedure FindObject(start,direction:T3DPointF);
    end;

implementation

{ TRenderList }

procedure TRenderList.FindObject(start, direction: T3DPointF);

begin

end;

end.

