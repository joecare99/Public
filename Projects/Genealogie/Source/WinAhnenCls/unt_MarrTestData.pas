unit unt_MarrTestData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_HejMarrData;

const
   cMarr: array[0..4] of THejMarrData =
        ((ID: -1; idPerson: 1; idSpouse: 2; MarrChrchDay: '1'; MarrChrchMonth: '2';
        MarrChrchYear: '1993'; MarrChrchplace: 'Neckarbischofsheim';
        MarrChrchWitness: 'Walter Götz, Richard Laber'; MarrStateDay: '3';
        MarrStateMonth: '4'; MarrStateYear: '1994'; MarrStatePlace: 'Adelsheim';
        MarrStateWitness: 'Walter Götz,'; Kind: 'Lebensgemeinschaft'; DivorceDay: '5';
        DivorceMonth: '6'; DivorceYear: '2099'; DivorcePlace: 'Nimmerland';
        MarrChrchSource: 'Quelle1'; MarrStateSource: 'Quelle2'; DivorceSource: 'Quelle3';
        Indj: '3'; Indm: '4'{%H-}),
        (ID: 2; idPerson: 6; idSpouse: 7; MarrChrchDay: '11'; MarrChrchMonth: '05';
        MarrChrchYear: '1978';
        MarrChrchplace: 'Hamburg-Altona';
        MarrChrchWitness: 'Lehrer, Küster, Bürgermeister';
        MarrStateDay: '10'; MarrStateMonth: '05'; MarrStateYear: '1978';
        MarrStatePlace: 'Hamburg';
        MarrStateWitness: 'Lehrer, Bürgermeister, '; Kind: 'Ehe';
        DivorceDay: ''; DivorceMonth:
        ''; DivorceYear: ''; DivorcePlace: ''; MarrChrchSource: 'Kirchenbuch';
        MarrStateSource:
        'Standesregister'; DivorceSource: ''{%H-}),
        (ID: 3; idPerson: 7; idSpouse: 6; MarrChrchDay: '11'; MarrChrchMonth: '05';
        MarrChrchYear: '1978';
        MarrChrchplace: 'Hamburg-Altona';
        MarrChrchWitness: 'Lehrer, Küster, Bürgermeister';
        MarrStateDay: '10'; MarrStateMonth: '05'; MarrStateYear: '1978';
        MarrStatePlace: 'Hamburg';
        MarrStateWitness: 'Lehrer, Bürgermeister, '; Kind: 'Ehe';
        DivorceDay: ''; DivorceMonth:
        ''; DivorceYear: ''; DivorcePlace: ''; MarrChrchSource: 'Kirchenbuch';
        MarrStateSource:
        'Standesregister'; DivorceSource: ''{%H-}),
        (ID: 4; idPerson: 3; idSpouse: 4{%H-}),
        (ID: 5; idPerson: 4; idSpouse: 3{%H-}));


implementation

end.

