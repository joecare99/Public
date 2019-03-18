unit unt_KingdomBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

resourcestring
// Texte
   rsYearOfReign='Dies ist das %s Jahr deiner Regentschaft';

// Zahlen
   rsFirst='erste';
   rsSecond='zweite';
   rsThird='dritte';
   rsFourth='vierte';
   rsFifth='fünfte';
   rsSixth='sechste';
   rsSeventh='siebente';


const Numbers:array[1..7] of string=
  (rsFirst,rsSecond,rsThird,rsFourth,rsFifth,rsSixth,rsSeventh);

implementation

end.

