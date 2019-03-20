unit unt_KingdomBase;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, LCLTranslator;

resourcestring
// Texte
   rsGameDescription = 'Dies ist das Königreich Sumeria, und Sie wurden für 10 '+
     'Jahre zum Herrscher gewählt.'+LineEnding+LineEnding+
     'Ihre Herrschaft entscheidet über Leben und Tod von hunderten ihrer '+
     'Untertanen. Ihre diktatorischen Fähigkeiten werden am Ende der Amtsperiode'+
     ', nach 10 Jahren geprüft.'+LineEnding+LineEnding+
     'Jedes Jahr müssen Sie Ihre Entscheidungen überdenken und ausführen.'+Lineending+
     'Bedenke, zur Ernährung braucht jeder Bewohner pro Jahr 20 Büschel Getreide, '+
     'und die Bewirtschaftung von 2 Tagwerk Land kostet 1 Büschel Getreide.';
   rsAdress='Hamurabi, ich habe Dir folgendes zu berichten:';
   rsYearOfReign='Dies ist das %s Jahr deiner Regentschaft sind %d Leute '+
     'gestorben; %d Leute sind nach Sumeria zugezogen.';
   rsPlague='Eine schreckliche Plage hat dein Land heimgesucht und die Hälfte '+
     'der Bevölkerung dahingerafft...';
   rsExpelled='Durch deine misserable Herrschaft sind in einem Jahr %d Leute '+
     'gestorben'+LineEnding+'Dadurch hast Du einen Volksaufstand ausgelöst.'+LineEnding+
     'Du bist gestürzt und aus dem Land gejagt worden !!!';
   rsStorage= 'Die Stadt zählt nun %d Einwohner. Du besitzt jetzt %d Tagwerk '+
     'Land, von denen pro Tagwerk %d Büschel Getreide geernted wurden.'+LineEnding+
     'Die Ratten frassen %d Büschel, du hast %d Büschel in deine Lagerhäusern.';
   rsCostOfLand='Land wird derzeit für %d Büschel Getreide gehandelt.';
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

