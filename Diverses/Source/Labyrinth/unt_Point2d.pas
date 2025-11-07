Unit unt_Point2d;

{$IFDEF FPC}
 {$MODE Delphi}{$H+}
{$ENDIF}
{------------------------------------------------------------------------------
 Einheit: unt_Point2d
 Zweck:
 - Stellt die Klasse `T2DPoint` zur Verfügung, die einen2D-Vektor/Punkt mit
 Ganzzahlkoordinaten (x, y) kapselt.
 - Bietet elementare Vektorrechnung (Addieren, Subtrahieren, Negieren,
 Skalar-/Vektorprodukt, komplexes Multiplizieren) sowie Länge-/Norm-
 Hilfsfunktionen.
 - Enthält Hilfsfunktionen und global initialisierte Richtungsvektoren
 (`dir4`, `dir8`, `dir12`) für Nachbarschafts- und Bewegungsberechnungen
 in Gittern (4er-,8er- und12er-Nachbarschaften).

 Besondere Hinweise:
 - Die Klasse nutzt eine unkonventionelle Namensgebung der Konstruktoren/
 Destruktoren (`init`/`done`) – dies ist syntaktisch gültig. Die
 Instanziierung funktioniert analog zu `Create`-Konstruktoren.
 - Viele Methoden liefern `self` zurück, sodass Methoden verkettet werden
 können (Fluent Interface).
 - `dir4`, `dir8`, `dir12` werden in `initialization` erzeugt und in
 `finalization` wieder freigegeben. Die Vektoren bilden kanonische
 Richtungs-Mengen (rechts/oben/links/unten; plus Diagonalen; und
2er-Schritte für12er-Richtungssatz).
 - `getDirNo` ordnet einen Vektor einer Richtungsnummer zu (abhängig von
 der Norm) und `getInvDir` liefert zu einer Direction deren inverse
 Richtung (abhängig vom verwendeten Richtungsradius/Normfall).
------------------------------------------------------------------------------}
{ $Author$ : Joe Care }
/// <Author>Joe Care</Author>

Interface

uses Types;

Type 
 { T2DPoint
 Repräsentiert einen2D-Punkt bzw. -Vektor mit integer-Koordinaten.

 Anwendungsfälle:
 - Geometrische Berechnungen auf Gitterrastern (z. B. Spiele, Labyrinthe)
 - Nachbarschaftsberechnungen, Pfadfindung, Richtungsableitung

 Design-Hinweise:
 - Die Methoden geben häufig `self` zurück, um Kettenaufrufe zu erlauben.
 - Operatoren sind als Kommentar vorbereitet, aber nicht aktiviert.
 }
 T2DPoint = Class
 x, y: longint; // Karten-/Gitter-Koordinaten
 { Konstruktoren }
 Constructor init(nx, ny: longint); overload; // Erstellt Punkt (nx, ny)
 Constructor init(Vect: T2DPoint); overload; // Kopierkonstruktor
 Constructor init(Pnt: TPoint); overload; // Erzeugt aus `TPoint`
 { Destruktor }
 Destructor done; virtual; // Setzt Felder zurück

 { Kopier-APIs }
 Function Copy(nx, ny: longint): T2DPoint; overload; virtual; // Überschreibt x,y und gibt self
 Function Copy(Vect: T2DPoint): T2DPoint; overload; virtual; // Kopiert aus anderem2DPoint (nil-sicher)
 function Copy(const Pnt: TPoint): T2DPoint; overload; virtual;// Kopiert aus TPoint
 Function Copy: T2DPoint; overload; virtual; // Liefert neue Instanz als Kopie

 { Arithmetik / Vektoroperationen }
 Function Add(vect: T2DPoint): T2DPoint; virtual;overload; // x,y += vect.x,y (nil-sicher)
 Function Add(vect: TPoint): T2DPoint; virtual;overload; // x,y += vect.x,y
 Function Negate: T2DPoint; virtual; // x,y := -x,-y
 Function Subtr(Vect: T2DPoint): T2DPoint; virtual;overload; // x,y -= vect.x,y (nil-sicher)
 Function Subtr(Vect: TPoint): T2DPoint; virtual;overload; // x,y -= vect.x,y
 Function XMult(vect: T2DPoint): T2DPoint; virtual; // Komplexe Multiplikation: (x+iy)*(vx+ivy)
 Function VMult(vect: T2DPoint): integer; virtual; // Skalarprodukt (Dot): x*vx + y*vy
 Function SMult(vect: T2DPoint): longint; overload; virtual; // Skalarprodukt (Dot), longint-Variante
 function SMult(Scalar:integer;Divisor: integer=1): T2DPoint; overload; virtual; // Skalarmultiplikation mit optionalem Divisor

 { Gleichheit / Lage }
 function Equals(Obj: TObject): boolean; override; // Prüft Koordinatengleichheit (bei T2DPoint), sonst inherited
 Function IsIn(rect:TRect):boolean; // Punkt in Rechteck (inkl. Rand)?

 { Debug/Hilfen }
 function ToString: string; override; // Ergänzt Parent-String um "<x,y>"
 function Len: single; virtual; // Euklidische Länge sqrt(x^2+y^2)
 function GLen: longint; virtual; // Manhattan-Länge |x|+|y|
 function MLen: longint; virtual; // Maximum-Norm max(|x|,|y|)
 function AsPoint:TPoint; // Konvertierung nach `TPoint`
(* public
 operator equal (const apt1, apt2 : T2DPoint) : Boolean;
 operator equal (const apt1: T2DPoint;const apt2:Tpoint) : Boolean;
 operator equal (const apt1: TPoint;const apt2:T2DPoint) : Boolean;
 operator unequal (const apt1, apt2 : T2DPoint): Boolean;
 operator add (var apt1 : TPoint2d;const apt2 : TPoint2d): T2DPoint;
 operator add (var apt1 : TPoint2d;const apt2 : TPoint): T2DPoint;
 operator subtract (var apt1 : TPoint2d;const apt2 : T2DPoint): T2DPoint;
 operator subtract (var apt1 : TPoint2d;const apt2 : TPoint): T2DPoint;
 operator subtract (const apt1 : TPointF): T2DPoint;
 operator multiply (var apt1: T2DPoint;const afactor: integer): T2DPoint;
 operator power (var apt1: T2DPoint; afactor: integer): T2DPoint;
 operator multiply (const apt1, apt2: TPointF): integer; *)
 End;


 { Sammlungen von Richtungspunkten für Nachbarschaftsbewegungen }
 TArrayOF2DPoint = array Of T2DPoint ;

Var 
 { Standard-Richtungen }
 dir4, //4-Nachbarschaft: [0]=(0,0), [1]=(1,0), [2]=(0,1), [3]=(-1,0), [4]=(0,-1)
 dir8, //8-Nachbarschaft: dir4 + Diagonalen
 dir12: TArrayOF2DPoint; //12-Richtungen (Schrittweiten2 in Kombi)

{------------------------------------------------------------------------------
 Liefert einen Richtungsvektor für einen Kreisradius und eine Richtungsnummer.
 - radius: bestimmt die Anzahl möglicher diskreter Richtungen (abhängig von
 der Berechnungsformel;10,15,22 sind im Code relevant)
 - direction: Index der Richtung (wird intern moduliert)
 Rückgabe: Richtungsvektor als neue `T2DPoint`-Instanz.
------------------------------------------------------------------------------}
Function getdir(radius: integer; direction: integer): T2DPoint;

{------------------------------------------------------------------------------
 Ermittelt die Richtungsnummer (Index) eines gegebenen Vektors
 innerhalb der vordefinierten Richtungsmengen:
 - GLen=0:0
 - MLen=1: Suche in `dir8`
 - MLen=2: Suche in `dir12`
 Rückgabe: Index >=0 oder -1 wenn nicht gefunden/ungültig.
------------------------------------------------------------------------------}
function getDirNo(Vect: T2DPoint): integer;

{------------------------------------------------------------------------------
 Bestimmt die inverse Richtungsnummer für die gegebene Richtung `dir` und
 den angegebenen Radius-Fall:
 - radius =10 ? einfache zyklische Umkehr
 - radius =15 ? Inversion basierend auf `dir8`
 - radius =22 ? Inversion basierend auf `dir12`
 Rückgabe: Richtungsindex der Gegenrichtung (gleiches Indexing wie Eingabe).
------------------------------------------------------------------------------}
function getInvDir(dir, radius: integer): integer;

{------------------------------------------------------------------------------
 Fabrikfunktionen zum bequemen Erzeugen von `T2DPoint`-Instanzen
------------------------------------------------------------------------------}
function Point2D(x,y:integer):T2DPoint;overload;
function Point2D(p:TPoint):T2DPoint;overload;


Implementation

uses math, sysutils;

{
 type
 TBase2dPoint = record
 x, y: integer;
 end;
}

var
 { Lookup-Tabellen zur schnellen Inversionssuche in `getInvDir` }
 InvDir2D15, InvDir2d22: array of SmallInt;

function getDirNo(Vect: T2DPoint): integer;
var
 i: integer;
begin
 result := -1;
 if not assigned(Vect) then
 exit; // Kein Vektor ? ungültig

 // Nullvektor ? Richtung0
 if Vect.GLen =0 then
 result :=0
 // Maximum-Norm1 ?8er-Richtungen
 else if Vect.MLen =1 then
 begin
 for i :=1 to high(Dir8) do
 if Vect.Equals(Dir8[i]) then
 begin
 result := i;
 break;
 end;
 end
 // Maximum-Norm2 ?12er-Richtungen
 else if Vect.MLen =2 then
 begin
 for i :=1 to high(Dir12) do
 if Vect.Equals(Dir12[i]) then
 begin
 result := i;
 break;
 end;
 end
end;

function getInvDir(dir, radius: integer): integer;
begin
 // Für nicht-positive Richtungen identisch zurückgeben
 if dir <1 then
 result := dir
 // Fester Spezialfall für radius10
 else if radius =10 then
 result := ((dir +2) mod6) +1
 // Inversion aus vorberechneter Tabelle für8-Nachbarschaft
 else if radius =15 then
 result := InvDir2D15[dir]
 // Inversion aus vorberechneter Tabelle für12-Nachbarschaft
 else if radius =22 then
 result := InvDir2D22[dir];
end;

function Point2D(x, y: integer): T2DPoint;
begin
 // Komfort: "Konstruktor-Aufruf" in Funktionsform
 result := T2DPoint.init(x,y);
end;

function Point2D(p: TPoint): T2DPoint;
begin
 result := T2DPoint.init(p);
end;

{ T2DPoint – Konstruktoren/Destruktor }
constructor T2DPoint.init(Vect: T2DPoint);

Begin
 // Kopiert Zustand aus übergebenem Vektor (nil ? (0,0))
 Copy(Vect);
End;

constructor T2DPoint.init(Pnt: TPoint);
begin
 // Initialisiert Koordinaten aus `TPoint`
 copy(Pnt);
end;

constructor T2DPoint.init(nx, ny: longint);
begin
 // Initialisiert Koordinaten direkt
 Copy(nx, ny);
end;

destructor T2DPoint.done;

Begin
 // Rücksetzen der Felder (keine Ressourcenhaltung)
 x :=0;
 y :=0;
 inherited;
End;

{ T2DPoint – Kopier-APIs }
function T2DPoint.Copy(nx, ny: longint): T2DPoint;
begin
 x := nx;
 y := ny;
 result := self
end;

function T2DPoint.Copy(Vect: T2DPoint): T2DPoint;

Begin
 // Sicheres Kopieren: nil ? (0,0)
 If Not assigned(vect) Then
 Begin
 x :=0;
 y :=0;
 End
 Else
 Begin
 x := Vect.x;
 y := Vect.y;
 End;
 result := self ;
End;

function T2DPoint.Copy(const Pnt: TPoint): T2DPoint;
begin
 x := Pnt.x;
 y := Pnt.y;
 result := self;
end;

function T2DPoint.Copy: T2DPoint;
begin
 // Gibt eine NEUE Instanz mit gleichem Inhalt zurück
 result := T2DPoint.init(self);
end;

{ T2DPoint – Arithmetik / Vektoroperationen }
function T2DPoint.Add(vect: T2DPoint);

Begin
 // Addition mit nil-Schutz
 if assigned(Vect) then
 begin
 x := x + Vect.x;
 y := y + Vect.y;
 end;
 result := self
End;

function T2DPoint.Add(vect: TPoint): T2DPoint;
begin
 x := x + Vect.x;
 y := y + Vect.y;
 result := self
end;

function T2DPoint.Negate: T2DPoint;
begin
 // Vorzeichenwechsel beider Koordinaten
 x:= -x;
 y:= -y;
 result := self ;
end;

function T2DPoint.Subtr(Vect: T2DPoint): T2DPoint;

Begin
 if assigned(Vect) then
 begin
 x := x - Vect.x;
 y := y - Vect.y;
 end;
 result := self
End;

function T2DPoint.Subtr(Vect: TPoint): T2DPoint;
begin
 x := x - Vect.x;
 y := y - Vect.y;
 result := self
end;

function T2DPoint.XMult(vect: T2DPoint): T2DPoint;

Var 
 nx, ny: integer; // Zwischenspeicher, da x,y in-place überschrieben werden

Begin
 // Komplexe Multiplikation: (x + i*y) * (vx + i*vy)
 // = (x*vx - y*vy) + i(x*vy + y*vx)
 nx := x * Vect.x - y * Vect.y;
 ny := x * Vect.y + y * Vect.x;
 x := nx;
 y := ny;
 result := self
End;

function T2DPoint.VMult(vect: T2DPoint): integer;
begin
 // Skalarprodukt (Dot): gut für Winkel-/Orthogonalitätsprüfungen
 Result := x * Vect.x + y * Vect.y;
end;

function T2DPoint.SMult(vect: T2DPoint): longint;

Begin
 // Dupliziert VMult mit longint-Resultat (Kompatibilität/Überladung)
 result := x * Vect.x + y * Vect.y;
End;

function T2DPoint.SMult(Scalar: integer; Divisor: integer): T2DPoint;
begin
 // Skalarmultiplikation mit anschließender ganzzahliger Division.
 // Int64 zur Vermeidung von Überlauf bei großem Scalar.
 x := (Scalar * int64(x)) div divisor;
 y := (Scalar * int64(y)) div divisor;
 result := self
end;

{ T2DPoint – Gleichheit/Lage/Debug/Hilfen }
function T2DPoint.Equals(Obj: TObject): boolean;
begin
 // Wenn nicht T2DPoint, dann Standard-Equals
 if not assigned(Obj) then exit(false);
 if not Obj.InheritsFrom(T2DPoint) then
 result := inherited Equals(Obj)
 else
 result := (x = T2DPoint(Obj).x) and (y = T2DPoint(Obj).y);
end;

function T2DPoint.IsIn(rect: TRect): boolean;
begin
 // Delegiert an `TRect.Contains`
 result := rect.Contains(AsPoint);
end;

function T2DPoint.ToString: ansistring;
begin
 // Ergänzt den inherited-String um Koordinaten-Darstellung
 result := inherited ToString;
 result := result + '<' + inttostr(x) + ',' + inttostr(y) + '>';
end;

function T2DPoint.Len: single;
begin
 // Euklidische Länge
 result :=sqrt(sqr(x)+sqr(y));
end;

function T2DPoint.GLen: longint;
begin
 // Manhattan-Metrik (L1): |x| + |y|
 result := abs(x) + abs(y);
end;

function T2DPoint.MLen: longint;
begin
 // Maximum-Metrik (L?): max(|x|, |y|)
 result := max(abs(x), abs(y));
end;

function T2DPoint.AsPoint: TPoint;
begin
 // Umwandlung in `Types.TPoint`
 result := Point(x,y);
end;

(*
class operator T2DPoint.equal(const apt1, apt2: T2DPoint): Boolean;
begin

end;

class operator T2DPoint.equal(const apt1: T2DPoint; const apt2: Tpoint
 ): Boolean;
begin

end;

class operator T2DPoint.equal(const apt1: TPoint; const apt2: T2DPoint
 ): Boolean;
begin

end;

class operator T2DPoint.=(const apt1, apt2: T2DPoint): Boolean;
begin
 if not assigned(apt1) or not assigned(apt2) then
 exit(assigned(apt1)= assigned(apt2));
 result := (apt1.x=apt2.x) and (apt1.y=apt2.y);
end;

class operator T2DPoint.=(const apt1: T2DPoint; const apt2: Tpoint): Boolean;
begin
 if not assigned(apt1) then
 exit(false);
 result := (apt1.x=apt2.x) and (apt1.y=apt2.y);
end;

class operator T2DPoint.=(const apt1: TPoint; const apt2: T2DPoint): Boolean;
begin
 if not assigned(apt2) then
 exit(false);
 result := (apt1.x=apt2.x) and (apt1.y=apt2.y);
end;

class operator T2DPoint.<>(const apt1, apt2: T2DPoint): Boolean;
begin
 result not (apt1 = apt2);
end;

class operator T2DPoint.+(var apt1: TPoint2d; const apt2: TPoint2d): T2DPoint;
begin
 result := apt1.add(apt2);
end;

class operator T2DPoint.+(var apt1: TPoint2d; const apt2: TPoint): T2DPoint;
begin
 result := apt1.add(apt2);
end;

class operator T2DPoint.-(var apt1: TPoint2d; const apt2: T2DPoint): T2DPoint;
begin
 result := apt1.sub(apt2);
end;

class operator T2DPoint.-(var apt1: TPoint2d; const apt2: TPoint): T2DPoint;
begin
 result := apt1.sub(apt2);
end;

class operator T2DPoint.-(const apt1: TPointF): T2DPoint;
begin
 result := apt1.Neg;
end;

class operator T2DPoint.*(var apt1: T2DPoint; const apt2): integer;
begin

end;

class operator T2DPoint.*(const apt1, apt2: TPointF): integer;
begin
 result := apt1.Mult(apt2);
end;

class operator T2DPoint.*(var apt1: T2DPoint; const afactor: integer): T2DPoint;
begin
 result := apt1.SMult(afactor);
end;

class operator T2DPoint.**(var apt1: T2DPoint; afactor: integer): T2DPoint;
begin

end;

class operator T2DPoint.**(var apt1: T2DPoint;const apt2: T2DPoint): T2DPoint;
begin
 result := apt1.XMult(apt2);
end;
*)

Var 
 Sqrt2: extended; // Konstante zur Kreis-/Richtungsberechnung

{------------------------------------------------------------------------------
 Erzeugt einen Richtungspunkt auf dem diskreten Kreis mit Radius `radius` für
 die gegebene `direction` (wird intern auf ein Intervall abgebildet).
 Die Berechnung nutzt symmetrische Oktanten und eine Wurzel-Funktion, um
 integer-Koordinaten auf dem Gitter zu bestimmen.
------------------------------------------------------------------------------}
function getdir(radius: integer; direction: integer): T2DPoint;

Var 
 imax: longint; // Skalenfaktor für Richtungsaufteilung

Var 
 hp: T2DPoint; // Hilfspunkt (Rückgabewert)
Var 
 nr: integer; // normierter Richtungsindex je Oktant

Begin
 imax := round(radius * sqrt2 *4);
 If (round(radius * sqrt2) Mod2) =0 Then
 imax := imax +4; // Anpassung für gerade Rundungsfälle

 // Richtung in Grundintervall falten
 nr := direction Mod (imax Div2);
 nr := nr Mod (imax Div4);
 If nr > imax Div8 Then
 nr := (imax Div4) - nr; // Spiegelung aufgrund Achsensymmetrie

 // Spezialfall Richtung0 ? Nullvektor
 If direction =0 Then
 hp := T2DPoint.init(dir4[0])
 Else
 // Auswahl Oktant und Berechnung integer-Koordinaten
 Case ((direction -1) *8 Div imax) Of
0:
 Begin
 hp := T2DPoint.init(round(sqrt(radius * radius - nr * nr)), nr);
 End;
1:
 Begin
 hp := T2DPoint.init(nr, round(sqrt(radius * radius - nr * nr)));
 End;
2:
 Begin
 hp := T2DPoint.init(-nr, round(sqrt(radius * radius - nr * nr)));
 End;
3:
 Begin
 hp := T2DPoint.init(-round(sqrt(radius * radius - nr * nr)), nr);
 End;
4:
 Begin
 hp := T2DPoint.init(-round(sqrt(radius * radius - nr * nr)), -nr);
 End;
5:
 Begin
 hp := T2DPoint.init(-nr, -round(sqrt(radius * radius - nr * nr)));
 End;
6:
 Begin
 hp := T2DPoint.init(nr, -round(sqrt(radius * radius - nr * nr)));
 End;
7:
 Begin
 hp := T2DPoint.init(round(sqrt(radius * radius - nr * nr)), -nr);
 End
 Else
 hp := T2DPoint.init(dir4[0]);
 End;
 result := hp;
End;

var
 i: integer;
 tdp: T2DPoint;

initialization

 // Vorbereiten von Richtungsvektoren und deren Invers-Mappings
 sqrt2 := sqrt(2.0);

 //4er-Richtungen (inkl. Nullvektor an Index0)
 setlength(Dir4,5);
 dir4[0] := T2DPoint.init(0,0);
 dir4[1] := T2DPoint.init(1,0);
 dir4[2] := T2DPoint.init(0,1);
 dir4[3] := T2DPoint.init(-1,0);
 dir4[4] := T2DPoint.init(0, -1);

 // Temporäres Arbeitsobjekt, um Kopien/Skalierungen zu bilden
 tdp := T2DPoint.init(nil);

 //8er-Richtungen (inkl. Nullvektor an Index0)
 setlength(Dir8,9);
 dir8[0] := Dir4[0];
 dir8[1] := Dir4[1];
 dir8[2] := T2DPoint.init(1,1);
 dir8[3] := Dir4[2];
 dir8[4] := T2DPoint.init(-1,1);
 dir8[5] := Dir4[3];
 dir8[6] := T2DPoint.init(-1, -1);
 dir8[7] := Dir4[4];
 dir8[8] := T2DPoint.init(1, -1);

 // Invers-Richtungen für "radius=15" (orientiert an dir8)
 setlength(InvDir2D15{%H-}, high(dir8) +1);
 for i :=0 to high(dir8) do
 InvDir2D15[i] := getDirNo(tdp.Copy(Dir8[i]).SMult(-1));

 //12er-Richtungen (inkl. Nullvektor an Index0)
 setlength(Dir12,13);
 dir12[0] := Dir4[0];
 dir12[1] := T2DPoint.init(2,0);
 dir12[2] := T2DPoint.init(2,1);
 dir12[3] := T2DPoint.init(1,2);
 dir12[4] := T2DPoint.init(0,2);
 dir12[5] := T2DPoint.init(-1,2);
 dir12[6] := T2DPoint.init(-2,1);
 dir12[7] := T2DPoint.init(-2,0);
 dir12[8] := T2DPoint.init(-2, -1);
 dir12[9] := T2DPoint.init(-1, -2);
 dir12[10] := T2DPoint.init(0, -2);
 dir12[11] := T2DPoint.init(1, -2);
 dir12[12] := T2DPoint.init(2, -1);

 // Invers-Richtungen für "radius=22" (orientiert an dir12)
 setlength(InvDir2d22{%H-}, high(dir12) +1);
 for i :=0 to high(dir12) do
 InvDir2d22[i] := getDirNo(tdp.Copy(Dir12[i]).SMult(-1));

 // Arbeitsobjekt freigeben
 FreeAndNil(tdp);

finalization
 // Aufräumen: Arrays freigeben.
 // Hinweis: Dir4[1..4] werden nicht explizit freigegeben; hier wird das
 // gesamte Array gelängt. Dir8/Dir12 enthalten teils eigene Instanzen, die
 // explizit freigegeben werden.

 //for i :=0 to high(dir4) do
 // FreeAndNil(dir4);
 SetLength(dir4,0);

 for i :=0 to high(dir8) do
 FreeAndNil(dir8[i]);
 SetLength(dir8,0);

 for i :=1 to high(dir12) do
 FreeAndNil(dir12[i]);
 SetLength(dir12,0);

End.

