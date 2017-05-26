{*g
Copyright by :
______________________________________________________________________________
_________________/~~\__/~~\______________/~~\_________________________________
_________________/~~~~~~\______________/~~\___________________________________
___________________/~~\___/~~~~~~\___/~~\__/~~\___/~~~~~~\___/~~\__/~~\_______
_________________/~~\__/~~~\/~~~\__/~~\/~~\____/~~\__/~~\__/~~\/~~\___________
_________/~~\__/~~\__/~~\__/~~\__/~~~~\______/~~~~~~~~\__/~~~~\_______________
_______/~~~\/~~~\__/~~~\/~~~\__/~~\/~~\____/~~~\_______/~~\___________________
_______/~~~~\_____/~~~~~~\___/~~\__/~~\___/~~~~~~\___/~~\_____________________
______________________________________________________________________________

}
unit Unt_PasMouse;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{ $define debug}

{*e Allgemeine Definition : {*g
1.)
 Bezeichneranfang        Beispiel                    Erkl„rung
 -------------------------------------------------------------------------
   T               TYPE TBlaBla             Der eigentliche TYPE BlaBla
                               =record
                                  I:Integer
                                end;
   P               TYPE PBlaBla             typisierter Pointer auf TBlaBla
                               = ^TBlaBla;
   Z               VAR  ZBlaBla             variabler Zeiger auf TBalBla
                               : PBlaBla;

2.) Kommentare:
 *a Kommentar zum Allgemeinen Ablauf
 *e Erkl„rung einer Deklarartion
 *z Zus„tzliche Erkl„rung
 *b Beschreibung der Rckmeldung bei Funktionen und von Var-Parametern
 *+ Fortsetzung eines vorangegangenen Kommentars, der an dieser Stelle zum
    Programm passt, aber vom Inhalt oder vom Satzbau her zu dem letzten
    Kommentar geh”rt.
 *r Referenzierungen (Auflistung aller globalen Variablen, Funktionen und
    Prozeduren und deren Definition
 *l Laufzeitanalyse
 *v Vorraussetzungen, damit der Programmteil richtig funktioniert
 *k Klammerntiefe bei Begin_End - Konstruktionen
 *n Neue Zeile in der Comment-Strip-Datei
 *g TextGrafik-Modus: Fhrende und Dazwischenstehende Leerzeichen werden nicht
    entfernt, Zeilen nicht aufgefllt u.s.w.
}//}

{*e Die Unit ~PasMouse~ behandelt alles, was mit der Maus zu tun hat,
    besitzt aber auch die M”glichkeit der "Schnellen" Einbindung in schon
    vorhandene Programme, durch die Funktionen ~MKeyPressed~ und ~MReadKey~ }

{$o+}
interface

uses  sysutils,
     classes,
      graph,
     win32crt;  {*e Verwaltung der Tastatur und des Bildschirms }
              {*e Verwaltung von Zeitpunkten }
              {*e Feststellen der Text-Bildschirm-Maximalwerte}

const mouseok=true;  {*e Maus vorhanden ? }

procedure mousepos (var tast,xpos,ypos:word);
{*e Allgemeine Procedur zum abfragen des Mauszustandes (Tasten & Position) }

Function mtast(nr:word):boolean;
{*e Prft ob eine bestimmte Maustaste gedrckt ist }

procedure initmouse;
{*e Initialisiert die Mausunit }
{*z Setzt die ~MouseOk~-Variable }

procedure put_mx (xmin,xmax:word);
{*e Setzt den X-Bereich, in dem sich die Maus bewegen darf }

procedure put_my (ymin,ymax:word);
{*e Setzt den Y-Bereich, in dem sich die Maus bewegen darf }

procedure mouseaus;
{*e Inaktiviert den Mauszeiger }

procedure mouseein;
{*e Aktiviert den Mauszeiger }

procedure putmouse (x,y:word);
{*e Setzt die Maus an einen bestimmte Stelle auf dem Bildschirm }

procedure Mousemas (x_verh,y_verh:word);
{*e Setzt die Mausbeschleunigung }

Procedure SetMultiGoBackTime(w:Word);

Function mkeypressed:boolean;
{*e Prft auf Tastatur und Maustasten-Druck }
{*z Ersetzt die ~CRT~-Function ~Keypressed~ }

function mreadkey:char;
{*e Liest ein Zeichen von der Tastatur, und behandelt auch die Maustasten }
{*z Ersetzt die ~CRT~-Function ~ReadKey~ }
{*b Liefert exact die Zeichen zurck die auch Readkey zurckliefert. Wobei
    ein Maustasten-Event mit dem Tastaturcode #0#0 zurckgeliefert wird. }


implementation

var malttast:boolean; {*e Speichert den aktuellen Zustand der Maustasten }
                      {*e Speichert den Zeitpunkt des letzten Maus-Events }

procedure mousepos (var tast,xpos,ypos:word);
begin
  IF assigned(graph.GraphForm) and graph.GraphForm.Active THEN
    BEGIN
      xpos := graph.GraphForm.LmousePos.X;
      ypos := graph.GraphForm.LmousePos.y;
      tast := 0;
      IF ssleft IN graph.GraphForm.LShift THEN
        tast := 1;
      IF ssright IN graph.GraphForm.LShift THEN
        tast := tast OR 2;
      IF ssmiddle IN graph.GraphForm.LShift THEN
        tast := tast OR 4;
    END
  ELSE
    BEGIN
      xpos := LastMEvent.dwMousePosition.X;
      Ypos := LastMEvent.dwMousePosition.y;
      tast:=LastMEvent.dwButtonState;
    END;
END;

FUNCTION mtast(nr: word): boolean;
begin
  case nr of
    1:result :=ssleft in graph.GraphForm.LShift;
    2:result :=ssright in graph.GraphForm.LShift;
    3:result :=ssmiddle in graph.GraphForm.LShift;
    else
      result :=false;
  end;
end;

procedure initmouse;
begin

end;

procedure put_mx (xmin,xmax:word);
{*e Setzt den X-Bereich, in dem sich die Maus bewegen darf }
begin

end;
procedure put_my (ymin,ymax:word);
{*e Setzt den Y-Bereich, in dem sich die Maus bewegen darf }
begin

end;
procedure mouseaus;
{*e Inaktiviert den Mauszeiger }
begin

end;
procedure mouseein;
{*e Aktiviert den Mauszeiger }
begin

end;
procedure putmouse (x,y:word);
{*e Setzt die Maus an einen bestimmte Stelle auf dem Bildschirm }
begin

end;
procedure Mousemas (x_verh,y_verh:word);
{*e Setzt die Mausbeschleunigung }
begin

end;
Procedure SetMultiGoBackTime(w:Word);
begin

end;
Function mkeypressed:boolean;
{*e Prft auf Tastatur und Maustasten-Druck }
{*z Ersetzt die ~CRT~-Function ~Keypressed~ }
begin
  if assigned(graph.GraphForm) and graph.GraphForm.Active  then
  result:=graph.keypressed
  else
  win32crt.keypressed;
end;
function mreadkey:char;
{*e Liest ein Zeichen von der Tastatur, und behandelt auch die Maustasten }
{*z Ersetzt die ~CRT~-Function ~ReadKey~ }
{*b Liefert exact die Zeichen zurck die auch Readkey zurckliefert. Wobei
    ein Maustasten-Event mit dem Tastaturcode #0#0 zurckgeliefert wird. }
begin
  IF assigned(graph.GraphForm) and graph.GraphForm.Active THEN
  result:=graph.readkey
  else
  result:=win32crt.readkey
  ;
end;



end.
