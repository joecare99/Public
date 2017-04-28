{**********[ SOURCE FILE OF FREE VISION II ]***************}
{                                                          }
{    System independent clone of objects.pas               }
{                                                          }
{    Interface Copyright (c) 1992 Borland International    }
{                                                          }
{    Parts Copyright (c) 1999-2000 by Florian Klaempfl     }
{    fnklaemp@cip.ft.uni-erlangen.de                       }
{                                                          }
{    Parts Copyright (c) 1999-2000 by Frank ZAGO           }
{    zago@ecoledoc.ipc.fr                                  }
{                                                          }
{    Parts Copyright (c) 1999-2000 by MH Spiegel           }
{                                                          }
{    Parts Copyright (c) 1996, 1999-2000 by Leon de Boer   }
{    ldeboer@ibm.net                                       }
{                                                          }
{    Free Vision project coordinator Balazs Scheidler      }
{    bazsi@tas.vein.hu                                     }
{                                                          }
{**********************************************************}
unit fv2RectHelper;

{$mode delphi}{$H+}


interface

uses
  Classes, windows;

type
 { TPointHelper }

 TPointHelper = record helper for TPoint
   function IsEmpty:Boolean;
   function Equals(P1:TPoint):Boolean;
   Function Add(P1:TPoint):TPoint;
   Function SubStract(P1:TPoint):TPoint;
   Procedure LoadFromStream(const S:TStream);
   Procedure SaveToStream(const S:TStream);
 end;

{ TRectHelper }

 TRectHelper = record helper for TRect
   function A: TPoint;                                { Corner points }
   function B: TPoint;                                { Corner points }
   FUNCTION IsEmpty: Boolean;
   FUNCTION Equals (R: TRect): Boolean;
   FUNCTION Contains (P: TPoint): Boolean;
   PROCEDURE Copy (R: TRect);
   PROCEDURE Union (R: TRect);
   PROCEDURE Intersect (R: TRect);
   PROCEDURE Move (ADX, ADY: Integer);
   PROCEDURE Grow (ADX, ADY: Integer);
   Function Size:TPoint;
   PROCEDURE Assign (XA, YA, XB, YB: Integer);
   Procedure LoadFromStream(const S:TStream);
   Procedure SaveToStream(const S:TStream);
  end;


PROCEDURE CheckEmpty (Var Rect: TRect);


implementation



{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++)
                            TRect OBJECT METHODS
(+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
PROCEDURE CheckEmpty (Var Rect: TRect);
BEGIN
   With Rect Do Begin
     If (A.X >= B.X) OR (A.Y >= B.Y) Then Begin       { Zero or reversed }
       A.X := 0;                                      { Clear a.x }
       A.Y := 0;                                      { Clear a.y }
       B.X := 0;                                      { Clear b.x }
       B.Y := 0;                                      { Clear b.y }
     End;
   End;
END;

{ TPointHelper }

function TPointHelper.IsEmpty: Boolean;inline;
begin
  result :=(x=0) and (y=0)
end;

function TPointHelper.Equals(P1: TPoint): Boolean;
begin
  result := (x=P1.x) and (y=P1.y);
end;

function TPointHelper.Add(P1: TPoint): TPoint;
begin
  result.x:=x+P1.x;
  result.y:=y+P1.y;
end;

function TPointHelper.SubStract(P1: TPoint): TPoint;
begin
  result.x:=x-P1.x;
  result.y:=y-P1.y;
end;

procedure TPointHelper.LoadFromStream(const S: TStream);
begin
  x := S.ReadDWord;
  y := S.ReadDWord;
end;

procedure TPointHelper.SaveToStream(const S: TStream);
begin
  s.WriteDWord(X);
  s.WriteDWord(Y);
end;


{ TRectHelper }

function TRectHelper.A: TPoint;
begin
  result := TopLeft;
end;

function TRectHelper.B: TPoint;
begin
  result := BottomRight
end;

function TRectHelper.IsEmpty: Boolean;
begin
     Result := (Left >= Right) OR (Top >= Bottom);      { Empty result }
end;

function TRectHelper.Equals(R: TRect): Boolean;
begin
     Result := (Left = R.Left) AND (Top = R.Top) AND
     (Right = R.Right) AND (Bottom = R.Bottom);         { Equals result }
end;

function TRectHelper.Contains(P: TPoint): Boolean;
begin
     result := (P.X >= Left) AND (P.X < Right) AND
     (P.Y >= Top) AND (P.Y < Bottom);                   { Contains result }

end;

procedure TRectHelper.Copy(R: TRect);
begin
     TopLeft := R.Topleft;                                          { Copy point a }
     Bottomright := R.BottomRight;                                          { Copy point b }
end;

procedure TRectHelper.Union(R: TRect);
begin
  If (R.Left < Left) Then Left := R.Left;               { Take if smaller }
  If (R.Top < Top) Then Top := R.Top;                   { Take if smaller }
  If (R.Right > Right) Then Right := R.Right;           { Take if larger }
  If (R.Bottom > Bottom) Then Bottom := R.Bottom;       { Take if larger }
end;

procedure TRectHelper.Intersect(R: TRect);
begin
  If (R.Left > Left) Then Left := R.Left;               { Take if larger }
  If (R.Top > Top) Then Top := R.Top;                   { Take if larger }
  If (R.Right < Right) Then Right := R.Right;           { Take if smaller }
  If (R.Bottom < Bottom) Then Bottom := R.Bottom;       { Take if smaller }
  CheckEmpty(Self);                                     { Check if empty }
end;

procedure TRectHelper.Move(ADX, ADY: Integer);
begin
  Inc(Left, ADX);                                       { Adjust Left }
  Inc(Top, ADY);                                        { Adjust Top }
  Inc(Right, ADX);                                      { Adjust Right }
  Inc(Bottom, ADY);                                     { Adjust Bottom }
end;

{--TRect--------------------------------------------------------------------)
   Grow -> Platforms DOS/DPMI/WIN/OS2 - Checked 10May96 LdB
(---------------------------------------------------------------------------}
procedure TRectHelper.Grow(ADX, ADY: Integer);
begin
  Dec(Left, ADX);                                       { Adjust Left }
  Dec(Top, ADY);                                        { Adjust Top }
  Inc(Right, ADX);                                      { Adjust Right }
  Inc(Bottom, ADY);                                     { Adjust Bottom }
  CheckEmpty(Self);                                     { Check if empty }
end;

function TRectHelper.Size: TPoint;
begin
  Result := BottomRight.Substract(TopLeft);
end;

{--TRect--------------------------------------------------------------------)
  Assign -> Platforms All - Checked 10May96 LdB
(---------------------------------------------------------------------------}
procedure TRectHelper.Assign(XA, YA, XB, YB: Integer);
begin
  Left := XA;                                           { Hold Left value }
  Top := YA;                                            { Hold Top value }
  Right := XB;                                          { Hold Right value }
  Bottom := YB;                                         { Hold Bottom value }
end;

procedure TRectHelper.LoadFromStream(const S: TStream);

begin
  TopLeft.LoadFromStream(S);
  BottomRight.LoadFromStream(S);
  BottomRight.Add(TopLeft);
end;

procedure TRectHelper.SaveToStream(const S: TStream);

begin
  TopLeft.SaveToStream(s);
  Size.SaveToStream(s);
end;

end.

