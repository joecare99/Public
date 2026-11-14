unit unt_SourceTestData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_HejSourceData;

const
cSource: array[0..16] of THejSourData = ((ID:0{%H-}),
    (ID: 1; Title: 'hörensagen'; Abk: '1'; Ereignisse: '2'; Von: '3'; Bis: '4';
    Standort: '5'; Publ: '6'; Rep: '7'; Bem: '8'; Bestand: '9'; Med: '10'{%H-}),
    (ID: 2; Title: 'Sterbeanzeige'; Abk: 'Strb.Anz.'; Ereignisse: 'Sterbefälle';
    Von: '2015'; Bis: '2018'; Standort: 'Heidelberg'; Publ: 'RNZ'; Rep: 'Druckergasse 15';
    Bem: 'Kann Online abgefragt werden'; Bestand: 'Nur die letzten 14 Tage'; Med: 'online'{%H-}),
    (ID: 3; Title: 'Friedhof Mosbach'; Abk: ''; Ereignisse: ''; Von: '';
    Bis: ''; Standort: ''; Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
    (ID: 4; Title: '2'; Abk: ''; Ereignisse: ''; Von: ''; Bis: ''; Standort: '';
    Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
    (ID: 5; Title: 'Taufbuch'; Abk: ''; Ereignisse: ''; Von: ''; Bis: '';
    Standort: ''; Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
    (ID: 6; Title: 'Geburtsurkunde'; Abk: ''; Ereignisse: ''; Von: '';
    Bis: ''; Standort: ''; Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
    (ID: 7; Title: 'Rechnung'; Abk: ''; Ereignisse: ''; Von: ''; Bis: '';
    Standort: ''; Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
    (ID: 8; Title: '1'; Abk: ''; Ereignisse: ''; Von: ''; Bis: ''; Standort: '';
    Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
    (ID: 9; Title: '3'; Abk: ''; Ereignisse: ''; Von: ''; Bis: ''; Standort: '';
    Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
    (ID: 10; Title: 'Quelle1'; Abk: ''; Ereignisse: ''; Von: ''; Bis: '';
    Standort: ''; Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
    (ID: 11; Title: 'Quelle2'; Abk: ''; Ereignisse: ''; Von: ''; Bis: '';
    Standort: ''; Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
    (ID: 12; Title: 'Quelle3'; Abk: ''; Ereignisse: ''; Von: ''; Bis: '';
    Standort: ''; Publ: ''; Rep: ''; Bem: ''; Bestand: ''; Med: ''{%H-}),
  (ID:13;Title:'Ancestry.com';Abk:'Anc.';Ereignisse:'divers';Von:'1500';Bis:'1930';Standort:'Salt Lake City, Utah, USA';Publ:'';Rep:'';Bem:'ggf. Anmeldung';Bestand:'';Med:'online'{%H-}),
  (ID:14;Title:'Eigenes Wissen';Abk:'e.Ws.';Ereignisse:'diverse';Von:'1980';Bis:'2019';Standort:'BW.';Publ:'-';Rep:'Gehirn';Bem:'u.U. nicht objektiv';Bestand:'';Med:'verbal'{%H-}),
  (ID:15;Title:'OSB Meißenheim';Abk:'OSB-Mh.';Ereignisse:'G,H,T';Von:'1560';Bis:'1969';Standort:'Meißenheim';Publ:'A. Köbele';Rep:'-';Bem:'';Bestand:'';Med:'Buch'{%H-}),
  (ID:16;Title:'Test';Abk:'1';Ereignisse:'2';Von:'3';Bis:'4';Standort:'5';Publ:'6';Rep:'7';Bem:'8';Bestand:'9';Med:'10'{%H-}));


implementation

end.

