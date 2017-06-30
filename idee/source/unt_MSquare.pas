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

{#############################################################################
 ###                                                                       ###
 ###                  Deklaration der Unit:                                ###
 ###                                                                       ###
 #############################################################################}
unit unt_MSquare;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

Procedure Execute;

implementation

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

 *+ Fortsetzung eines vorangegangenen Kommentars, der an dieser Stelle zum
    Programm passt, aber vom Inhalt oder vom Satzbau her zu dem letzten
    Kommentar geh”rt.

 *r Referenzierungen (Auflistung aller globalen Variablen, Funktionen und
    Prozeduren und deren Definition

 *l Laufzeitanalyse

 *v Vorraussetzungen, damit der Programmteil richtig funktioniert

 *k Klammerntiefe bei Begin_End - Konstruktionen

 *n Neue Zeile in der Comment-Strip-Datei

 *g TextGrafik-Modus: Fhrende und Dazwischenstehende Leerzeichen werden nicht
    entfernt, Zeilen nicht aufgefllt u.s.w.

}

{*e Diese Unit hat die Aufgabe:

}

{#############################################################################
 ###                                                                       ###
 ###                          Start des Interface                          ###
 ###                                                                       ###
 #############################################################################}


Uses
  Win32Crt;

{#############################################################################
 ###                                                                       ###
 ###           Ende des Interface      -     Start der Implementation      ###
 ###                                                                       ###
 #############################################################################}

(*
Procedure $N();
{*a Die Procedure $N hat die Aufgabe: }

begin
  {*k 1 }
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,Stacktiefe:stacktiefe+1,' $N: Start');
  {$endif}

  {$ifdef debug}
  writeln(debug,Stacktiefe:stacktiefe+1,' $N: Ende');
  dec(Stacktiefe);
  {$endif}
  {*k 1 }
end;
*)

{----------------------------------------------------------------------------}

{#############################################################################
 ###                                                                       ###
 ###                  Initialisierung der Unit:                            ###
 ###                                                                       ###
 #############################################################################}

Const rows = 5;
  maxarray = (rows * rows) Div 2;
  differ = (rows * rows) + 1;
  reslt = (differ * rows) Div 2;

Var M: Array[1..maxarray] Of word;

Procedure show(x, y: byte);

Var i: byte;

Begin
  If rows Mod 2 = 1 Then
    Begin
      gotoxy(x + (maxarray Mod rows) * 4, y + (maxarray) Div rows);
      write(maxarray + 1: 3);
    End;
  For i := maxarray Downto 1 Do
    Begin
      gotoxy(x + ((i - 1) Mod rows) * 4, y + (i - 1) Div rows);
      write(m[i]: 3);
      gotoxy(x + ((differ - i - 1) Mod rows) * 4, y + (differ - i - 1) Div
        rows);
      write(differ - m[i]: 3);
    End;
End;

var  count: Integer;

Function loesung: boolean;

Var i, j: byte;
  summ: longint;


Begin
  loesung := false;
  // Prüfe Zeilensummen
  For i := 0 To pred(rows Div 2) Do
    Begin
      summ := 0;
      For j := 1 To rows Do
        inc(summ, M[i * rows + j]);
   //   gotoxy(65, 3+i); write('=');write(summ: 3);

      If summ <> reslt Then
        exit;
    End;
  // Prüfe Spaltensummen
  For j := 1 To rows Div 2 Do
    Begin
      summ := 0;
      For i := 0 To pred(rows Div 2) Do

        summ := summ + M[i * rows + j] + differ - M[i * rows + (rows - j + 1)];
      If rows Mod 2 = 1 Then
        summ := summ + M[(rows Div 2) * rows + j];
      if (J>1) and (count>50000) or (count>100000) then
        begin
      gotoxy(35+j * 4 + 1, 2); write(summ: 3);
      show (40,3);
         count :=0;
        end
      else
        count := count + 1;
      If summ <> reslt Then
        exit;
    End;
  loesung := true;
End;

Function nextmutation: boolean;

Var i, j, k, start: byte;
  inh, test: word;
  tt: Word;

Begin
  nextmutation := true;
  // Init
  If m[1] = 65535 Then
    For i := 1 To maxarray Do
      m[i] := i
  Else
    Begin
      test := reslt;
      start := 1;
      // Suche ungültige Zeile
      While (test = reslt) And (start < maxarray) Do
        Begin
          test := 0;
          For i := start To start + rows - 1 Do
            test := test + m[i];
          start := start + rows;
        End;

      If start > maxarray Then
        start := maxarray + 1;

      For i := start-1 Downto 1 Do
        Begin
          tt := m[i ];
          If tt <= maxarray Then
            Begin
              // Erhöhe stelle [i] =>
              // niedrigere Stellen zurücksetzen

              m[i ] := differ - tt;

              k := (maxarray + i+1);
              // Setze Stellen auf jew. niedr. wert.
              For j := i+1 To k Div 2 Do
               if m[j] > maxarray then
                 m[j] := differ - m[j];


              k := (start + i);
              // Tausche Stellen wenn größer
              For j := i+1 To k Div 2 Do
              if m[j] > m[k - j] then
                Begin
                  inh := m[j];
                  m[j] := m[k - j];
                  m[k - j] := inh;
                End;
              k:=(start-i-1);
              if (start<maxarray)and (K>0) then
                For j := i+1 To maxarray-k Do
                  Begin
                    inh := m[j];
                    m[j] := m[j+k];
                    m[j+k] := inh;
                  End;

              exit;
            End
          Else If i < maxarray Then
            Begin
              If m[i] > maxarray Then
                 inh := differ - m[i]
              else
                 inh := m[i];
              If m[i+1] > maxarray Then
                 m[i+1] := differ - m[i+1];
              If m[maxarray] > maxarray Then
                 m[maxarray] := differ - m[maxarray];
              If (m[i+1] > inh) Or (m[maxarray] > inh) Then
                Begin
                  test := m[i+1];
                  k := i+1;
                  // Suche kleinstes Element>inh aus rest
                  For j := i + 2 To maxarray Do
                    If (m[j] > inh) And ((m[j] < test) or (test<inh)) Then
                      Begin
                        test := M[j];
                        k := j;
                      End;

                  m[i] := test;
                  m[k] := inh;
                  // Kehre Stellen um wenn nötig
                  k := (start + i);
                  For j := i+1 To k Div 2 Do
                  if m[j] > m[k - j] then
                    Begin
                      inh := m[j];
                      m[j] := m[k - j];
                      m[k - j] := inh;
                    End;
                  exit;
                End;
            End;
        End;
      nextmutation := False;
    End;

End;

Procedure Execute;

Var anz: longint;

Begin
  {*k 1 }
{$IFDEF debug}

{$ENDIF}
  clrscr;
  anz := 0;
  M[1] := 65535;
  While nextmutation Do
    If loesung Then
      Begin

        inc(anz);
        show(5, 3);
        writeln;
        writeln('-> ', anz: 10, ' <-')
      End
    Else
      Begin
      End;
  readln;
  {*k 1 }
End;

end.
{
8549176230

eight
five
four
nine
one
seven
six
two
three
zero

achat
arba
chamesh
efes
shewa
shalosh
shmone
shnayim
shesh
tesha

1 2 3 4 5    0 0 0 0    0
       x
1 2 3 5 4    0 0 0 1    1
     2 1
1 2 4 3 5    0 0 1 0    2
       x
1 2 4 5 3    0 0 1 1    3
     1 2
1 2 5 3 4    0 0 2 0    4
       x
1 2 5 4 3    0 0 2 1    5

1 3          0 1 0 0    6
}
