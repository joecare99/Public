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
unit unt_CINPUT ;
{ $define debug}

{*e Allgemeine Definition : {*g
1.)
 Bezeichneranfang        Beispiel                    ErklÑrung
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
 *e ErklÑrung einer Deklarartion
 *z ZusÑtzliche ErklÑrung
 *b Beschreibung der RÅckmeldung bei Funktionen und von Var-Parametern
 *+ Fortsetzung eines vorangegangenen Kommentars, der an dieser Stelle zum
    Programm passt, aber vom Inhalt oder vom Satzbau her zu dem letzten
    Kommentar gehîrt.
 *r Referenzierungen (Auflistung aller globalen Variablen, Funktionen und
    Prozeduren und deren Definition
 *l Laufzeitanalyse
 *v Vorraussetzungen, damit der Programmteil richtig funktioniert
 *k Klammerntiefe bei Begin_End - Konstruktionen
 *n Neue Zeile in der Comment-Strip-Datei
 *g TextGrafik-Modus: FÅhrende und Dazwischenstehende Leerzeichen werden nicht
    entfernt, Zeilen nicht aufgefÅllt u.s.w.
}

{*e Die Unit ~CInput~ stellt eine Procedure zur VerfÅgung, welche die
    System-Procedure ~ReadLn~ - ersetzt, und ein vollstÑndiges,comfortables
    Eingabemaskenfeld darstellt. }

interface

uses win32crt,       {*e Tastatur- und Bildschirmbehandlungs - Unit }
     unt_pasmouse,  {*e Mouse - Unit }
     Sysutils,
     unt_stringprocs   {*e Dort werden die ZeichensÑtze definiert }
     {$ifdef debug}
     ,debugunt
     {$endif};


procedure input (    x,y,            {*e Position, an dem das Eingabe-Feld
                                         dargestellt werden soll }
                     l:integer;      {*e LÑnge des Darstellungsfeldes der
                                         Eingabestring kann lÑnger sein}
                 var orginal:string;    {*e Eingabestring, der die Feldvorgabe
                                         enthÑlt und die Eingabe zurÅckliefert}
                 var abbruch:boolean;{*e liefert zurÅck, ob durch die ESC-taste
                                         abgebrochen wurde }
                 var ch:char );      {*e das Zeichen, das zum Abbruch gefÅhrt
                                         hat. }
type TInputConfig=Record
       Insstat,                      {*e Grundstatus der Insert-Funktion }
       Clip,                         {*e Clipping, ob der Eingabestring lÑnger
                                         als das Feld sein darf (Falls nicht,
                                         wird er am Feldende Abgeschnitten }
       multiline,                    {*e ob bei einem Pfeil hoch-runter-Event
                                         oder bei einem Maus-Klick au·erhalb
                                         des Feldes abgebrochen wird }
       rechts,                       {*e Soll das Eingabefeld rechtsbÅndig
                                         dargestellt werden }
       Num       :boolean;           {*e Spezieller Modus fÅr Zahlen }
       MaxEingLen,                   {*e Maximale LÑnge des Eingabestrings }
       vgr,hgr:byte;                 {*e Farben des Eingabe-Feldes }
       VerweilDauer:word;            {*e Verweildauer in 1/100 Sekunden zur
                                         Verwendung in Multitaskingumgebungen}
     end;

var InputConfig:TInputConfig;

implementation

type PInputVar=^TinputVar;  {*e Damit nicht so viel Stack benutzt wird lege
                                ich fast alle lokalen Variablen auf dem Heap
                                als Record an }
     Tinputvar=record
       cx,                  {*e aktuelle Cursorposition in dem Eingabestring}
       offs,                {*e Offset innerhalb des Strings }
       xoffs:integer;       {*e X - Offset der Darstellung }
       wn,wx:word;
       einglen:integer;     {*e maximale LÑnge des Eingabestr.}
       eing:string;      {*e Zwischenspeicher fÅr den Originalstring }
       hlp:char;            {*e CHAR - Hilfsvariable }
       attr,                {*e Zwischenspeicher fÅr Textatribute }
       ac,ab,oc,ob:byte;
       ins,
       wtr,
       abbr:boolean;
       mx,my,ms:word        {*e Position und Tasten der Maus, welche die
                                Mouseabfrage zurÅckliefert }
     end;

var p:PinputVar;
    TimerAbbruch:boolean;

procedure input;

var i:integer;

begin
  abbruch:=false;
  if not TimerAbbruch then
    begin
      new (p);
      with p^ do
        begin
          SetMultiGoBackTime(InputConfig.Verweildauer);
          abbr:=InputConfig.Multiline;
          {*a Hole aktuellen Color-Attribut-Status }

          abbr:=InputConfig.Multiline;
          ins:=InputConfig.InsStat;
          {*a RechtsbÅndig ? }
          if InputConfig.rechts then
            begin
              cx:=1;
              offs:=length(Orginal)-l;
              xoffs:=1;
              if offs< 0 then
                begin
                  xoffs:=abs(offs);
                  offs:=1;
                end;
              if offs > cx then
                begin
                  xoffs:=1;
                  offs:=1;
                end
            end
          else
            begin
              cx:=1;
              xoffs:=1;
              offs:=1;
            end;
          if InputConfig.clip then
            einglen:=l-1
          else
            einglen:=InputConfig.MaxEingLen;
          {*a Kopie des Original - Eingabestrings ablegen }
          eing:=Orginal;
          if InputConfig.clip then
            if InputConfig.rechts then
              eing:=copy (eing,offs+1,l-1)
            else
              eing:=copy (eing,1,l-1);
        end
    end;
  with p^ do
    begin
      attr:=Console.textattr;
      ac:=(attr and 127) shr 4;
      ab:=attr and 7;
      ob:=ac;
      oc:=attr and 15;
      TimerAbbruch:=false;
      textbackground(InputConfig.hgr);
      textcolor(InputConfig.vgr);
    end;
  if not TimerAbbruch then
    with p^ do
      begin
        gotoxy (x,y);
        {*a Zeichne Leeres Feld }
        for i:= 0 to l do
          write (' ');
      end;
  with p^ do
    repeat
      {*a Clip-Left-Zeichen anzeigen }
      gotoxy (x,y);
      if offs > 1 then
        write('')
      else
        write(' ');

      {*a Clip-Right-Zeichen anzeigen }
      gotoxy (x+l+1,y);
      if length(eing)-offs >= l-1 then
        write('')
      else
        write(' ');

      {*a Eingabe-String anzeigen }
      gotoxy (x+xoffs,y);
      write(copy(eing,offs,l));

      {*a Falls der String kleiner als das Feld ist lîsche letztes
          (Stehengebliebenes Zeichen }
      if length(eing)-offs+xoffs < l then
        write (' ');
      if xoffs > 1 then
        begin
          gotoxy (x+xoffs-1,y);
          write (' ');
        end;
      {*a Cursor Darstellen }
      gotoxy (x+xoffs-offs+cx,y);
      if not ins then
        begin
          {*a Im öberschreibmodus wird der Cursor als Block dasgestellt}
          {*a Hintergrund- und Vordergrundfarbe vertauschen }
          textcolor (InputConfig.hgr);
          textbackground (InputConfig.vgr);

          {*a Schreibe das Zeichen an dieser Stelle }
          if cx <=length(eing) then
            write (eing[cx])
          else
            write(' ');


          textcolor (InputConfig.vgr);
          textbackground (InputConfig.hgr);
          gotoxy (x+xoffs-offs+cx,y);
        end;
      ch:=mreadkey;
        case ch of
          #0 :begin
                ch:=mreadkey;
                case ch of
                  'K':  {*a Pfeil links }
                    if cx >1 then
                      begin
                        dec(cx);
                        if offs > cx then offs:=cx;
                      end;
                  'M':  {*a Pfeil rechts }
                    if cx <=length (eing) then
                      begin
                        inc(cx);
                        if offs+l-1 < cx then
                          offs:=cx-l+1
                      end;
                  's':  {*a Strg-Pfeil-Links }
                    begin
                      wtr:=false;
                        repeat
                          dec(cx);
                          if cx >=1 then
                            hlp:=eing[cx]
                          else
                            hlp:=#0;
                          if charinset(hlp , CharSet) then
                            wtr:= true;
                        until (cx<1) or
                             (not charinset(hlp , CharSet) and wtr);
                        inc(cx);
                        if offs > cx then
                          offs:=cx;
                      end;
                  't':  {*a Strg-Pfeil-Rechts }
                    begin
                      wtr:=false;
                        repeat
                          inc(cx);
                          if (cx <= length(eing)) then
                            hlp:=eing[cx]
                          else
                            hlp:=#0;
                          if not CharInSet(hlp , CharSet) then
                            wtr:= true;
                        until (cx>length(eing)) or
                              (CharInSet(hlp , CharSet) and wtr);
                        if offs+l-1 < cx then
                          offs:=cx - l + 1
                      end;
                  'R': {*a EinfÅgen-Taste }
                    ins:= not ins;
                  'S': {*a Entf - Taste }
                    if (length (eing) >= cx) then
                      begin
                        delete (eing,cx,1);
                        if InputConfig.rechts then
                          begin
                            if offs > 1 then
                              dec (offs)
                            else
                              inc (xoffs);
                          end;
                      end;
                  'O': {*a Ende - Taste }
                    cx:= length (eing)+1;
		  'G': {*a Pos1 - Taste }
                    cx:=1;
		  'H': {*a Pfeil-hoch }
                    abbruch:=abbr;
		  'P': {*a Pfeil -runter }
                    abbruch:=abbr;
                   #0: {*a Maustaste }
                     begin
                       mousepos (ms,mx,my);
                       if (ms and 3) = 0 then
                         begin
                           abbruch := true;
                           TimerAbbruch:=true;
                         end
                       else
                         begin
                           my:=(my div 8+1) -lo(windmin);
                           mx:=(mx div 8+1) -hi(windmin);
                           if my = y then
                             begin
                               if mx = x then
                                 begin
                                   if cx >1 then
                                     dec (cx);
                                   if offs > cx then
                                     offs:=cx;
                                   delay (100);
                                 end
                               else
                                 if mx = x+l+1 then
                                   begin
                                     if cx <= Length(Eing) then
                                       inc (cx);
                                     if offs+l-1 < cx then
                                       offs:=cx-l+1;
                                     delay (100);
                                   end
                                 else
                                   if (mx > x) and (mx < x+l) then
                                     begin
                                       cx:=mx-x-xoffs+offs;
                                       if cx > length(eing)+1 then
                                         cx:=length(eing)+1;
                                       if cx <1 then
                                         cx:=1
                                     end
                                   else
                                     abbruch:=abbr;
                             end
                           else
                             abbruch:=abbr;
                         end
                     end
                end
             end;
          #8 :if cx >1 then
              begin
                delete (eing,cx-1,1);
                dec(cx);
                if InputConfig.rechts then
                  begin
                    if offs > 1 then
                      dec (offs)
                    else
                      inc (xoffs);
                  end;
                if offs > cx then offs:=cx;
              end;
          #9 :
            begin
              if cx+5 > length(eing) then
                cx:=length(eing)+1
              else
                cx:=cx+6;
              if offs+l-1 < cx then
                offs:=cx-l+1
            end;
          #27:begin
              abbruch:=true;
              eing:=orginal;
            end;
          #32..#255:if cx <= EingLen then
            begin
              if (cx <= EingLen) and
                 (ins or (cx > length(eing))) then
                begin
                  insert (ch,eing,cx);
                  if length (eing) > EingLen then
                    delete (eing,EingLen+1,1);
                end
              else eing[cx]:=ch;
              if ( cx <= EingLen ) then
                begin
                  inc(cx);
                  if InputConfig.rechts and ins then
                    begin
                      if xoffs > 1 then
                        dec (Xoffs)
                      else
                        inc (offs);
                    end;
                  if offs+l-1 < cx then
                    offs:=cx-l+1
                end
            end;
        end;
    until (ch=#13) or (ch=#27) or abbruch;
  textbackground (p^.ob);
  textcolor (p^.oc);
  if not TimerAbbruch then
    with p^ do
      begin
        Orginal:=Eing;
        gotoxy (x,y);
        for i:=0 to l+1 do write (' ');
        gotoxy (x+xoffs-1,y);
        write (copy(' '+Orginal,1,l));
        dispose(p);
      end;
end;

begin
  {$ifdef debug}
  writeln(debug,'CInput  .PAS v1.05 eingebunden');
  {$endif}
  Timerabbruch:=false;
  {*a Setze die Grundkonfiguration }
  with InputConfig do
    begin
      Insstat:=true;      {*e EinfÅgemodus ein }
      clip:=false;        {*e Langer Eingabestring }
      multiline:=false;   {*e Kein Abbruch bei Cursorsteuerung }
      Rechts:=False;      {*e Eingabefeld linksbÅndig }
      num:=False;         {*e Text-Modus }
      maxEingLen:=250;    {*e Volle Stringlenge, mit kleinem Puffer }
      vgr:=Yellow;        {*e Vordergrund: Gelb }
      hgr:=Blue;          {*e Hintergrund: Blau }
      VerWeilDauer:=0;     {*e Multitasking - AUS }
    end;
end.
