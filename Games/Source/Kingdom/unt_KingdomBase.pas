unit unt_KingdomBase;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils;

resourcestring
// Texte
   rsGameDescription = 'Dies ist das Königreich Sumeria, und Sie wurden für 10 '+
     'Jahre zum Herscher gewählt.'+LineEnding+LineEnding+
     'Ihre Herrschaft entscheidet über Leben und Tod von hunderten ihrer '+
     'Untertanen. Ihre diktatorischen Fähigkeiten werden am Ende der Ampsperiode'+
     ', nach 10 Jahren geprüft.'+LineEnding+LineEnding+
     'Jedes Jahr müssen Sie Ihre Entscheidungen überdenken und ausführen.';
   rsAdress='Hamurabi, ich habe Dir folgendes zu berichten:';
   rsYearOfReign='Dies ist das %s Jahr deiner Regentschaft sind %d Leute '+
     'gestorben; %d Leute sind nach Sumeria zugezogen.';
   rsPlague='Eine schreckliche Plage hat dein Land heimgesucht und die Hälfte '+
     'der Bevölkerung dahingerafft...';
   rsOK='Erledigt ...';


// Zahlen
   rsFirst='erste';
   rsSecond='zweite';
   rsThird='dritte';
   rsFourth='vierte';
   rsFifth='fünfte';
   rsSixth='sechste';
   rsSeventh='siebente';
   rsEighth='achte';
   rsNineth='neunte';
   rsTenth='zehnte';
   rsEleventh='elfte';


const Numbers:array[1..11] of string=
  (rsFirst,rsSecond,rsThird,rsFourth,rsFifth,rsSixth,rsSeventh,rsEighth,rsNineth,rsTenth,rsEleventh);

implementation

end.

