unit unt_IndTestData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_HejIndData;

const
      cInd: array[0..9] of THejIndData =
        (({%H-}),
         (ID: 1; idFather: 0; idMother: 0; FamilyName: 'Care'; GivenName: 'Joe';
        Sex: 'm'; Religion: 'Be';
        Occupation: 'Beruf'; BirthDay: '21'; BirthMonth: '01'; BirthYear: '1971';
        Birthplace: 'Eppingen';
        BaptDay: 'bf'; BaptMonth: '02'; BaptYear: '1972'; BaptPlace: 'Sulzfeld';
        Godparents: 'Uwe Care';
        Residence: 'Baden'; DeathDay: 'af'; DeathMonth: '03';
        DeathYear: '2069'; DeathPlace: 'Binau';
        DeathReason: 'TU'; BurialDay: 'ca'; BurialMonth: '04'; BurialYear: '2070';
        BurialPlace: 'Mosbach';
        BirthSource: 'Geburtsurkunde'; BaptSource: 'Taufbuch';
        DeathSource: 'Sterbeanzeige';
        BurialSource: 'Friedhof Mosbach';
        Text: 'Dies ist ein Text zu Joe Care' + lineending + '2. Zeile' + lineending;
        Living: 'n'; AKA: 'JaySee'; Index: 'I0001'; Adopted: 'Ad';
        FarmName: 'Hofname'; AdrStreet: 'Baumstr. 42'; AdrAddit: 'Himmelhof';
        AdrPLZ: 'D74821';
        AdrPlace: 'Mörtelstein'; AdrPlaceAdd: 'am Neckar'; Free1: '98';
        Free2: '97'; Free3: '96';
        Age: 'ca. 98 J'; Phone: '0800 330 1000'; eMail: 'test@jc99.de';
        WebAdr: 'www.jc99.de';
        NameSource: 'hörensagen'; CallName: 'Joker'{%H-}),
        (ID: 2; idFather: 3; idMother: 4; FamilyName: 'Ute';
        GivenName: 'Comp'; Sex: 'w'; Religion: 'co';
        Occupation: 'Rechengehilfin'; BirthDay: ''; BirthMonth: '';
        BirthYear: ''; Birthplace: '';
        BaptDay: ''; BaptMonth: ''; BaptYear: ''; BaptPlace: ''; Godparents: '';
        Residence: 'Computerland';
        DeathDay: ''; DeathMonth: ''; DeathYear: ''; DeathPlace: '';
        DeathReason: ''; BurialDay: '';
        BurialMonth: ''; BurialYear: ''; BurialPlace: ''; BirthSource: '';
        BaptSource: ''; DeathSource: '';
        BurialSource: ''; Text: ''; Living: 'j'; AKA: 'Comp J. Uda';
        Index: 'I00002'; Adopted: 'V';
        FarmName: ''; AdrStreet: ''; AdrAddit: ''; AdrPLZ: '';
        AdrPlace: ''; AdrPlaceAdd: ''; Free1: '';
        Free2: ''; Free3: ''; Age: ''; Phone: ''; eMail: ''; WebAdr: '';
        NameSource: 'Rechnung';
        CallName: 'Compy'{%H-}),
        (ID: 3; idFather: 0; idMother: 0; FamilyName: 'Ute';
        GivenName: 'Karl'; Sex: 'm'; Religion: 'co';
        Occupation: 'Rechengehilfin'; BirthDay: ''; BirthMonth: '';
        BirthYear: ''; Birthplace: '';
        BaptDay: ''; BaptMonth: ''; BaptYear: ''; BaptPlace: ''; Godparents: '';
        Residence: 'Computerland';
        DeathDay: ''; DeathMonth: ''; DeathYear: ''; DeathPlace: '';
        DeathReason: ''; BurialDay: '';
        BurialMonth: ''; BurialYear: ''; BurialPlace: ''; BirthSource: '';
        BaptSource: ''; DeathSource: '';
        BurialSource: '1'; Text: ''; Living: 'j'; AKA: 'Comp J. Uda';
        Index: 'I00003'; Adopted: '';
        FarmName: ''; AdrStreet: ''; AdrAddit: ''; AdrPLZ: '';
        AdrPlace: ''; AdrPlaceAdd: ''; Free1: '';
        Free2: ''; Free3: ''; Age: ''; Phone: ''; eMail: ''; WebAdr: '';
        NameSource: 'Rechnung';
        CallName: 'Compy'{%H-}),
        (ID: 4; idFather: 0; idMother: 0; FamilyName: 'Ute';
        GivenName: 'Elsa'; Sex: 'w'; Religion: 'co';
        Occupation: 'Rechengehilfin'; BirthDay: ''; BirthMonth: '';
        BirthYear: ''; Birthplace: '';
        BaptDay: ''; BaptMonth: ''; BaptYear: ''; BaptPlace: ''; Godparents: '';
        Residence: 'Computerland';
        DeathDay: ''; DeathMonth: ''; DeathYear: ''; DeathPlace: '';
        DeathReason: ''; BurialDay: '';
        BurialMonth: ''; BurialYear: ''; BurialPlace: ''; BirthSource: '';
        BaptSource: ''; DeathSource: '1';
        BurialSource: ''; Text: 'D' + lineending; Living: 'j'; AKA: 'Comp J. Uda';
        Index: 'I00004'; Adopted: '';
        FarmName: ''; AdrStreet: ''; AdrAddit: ''; AdrPLZ: '';
        AdrPlace: ''; AdrPlaceAdd: ''; Free1: '';
        Free2: ''; Free3: ''; Age: ''; Phone: ''; eMail: ''; WebAdr: '';
        NameSource: 'Rechnung';
        CallName: 'Compy'{%H-}),
        ({%H-}), // Weiterer Leerer Datensatz
        (ID:6;idFather:3;idMother:4;FamilyName:'Mustermann';GivenName:'Peter';Sex:'m';
      Religion:'ev';Occupation:'Arbeiter';Birthday:'14';Birthmonth:'08';Birthyear:
      '1956';Birthplace:'Hamburg';BaptDay:'21';BaptMonth:'09';BaptYear:'1956';
      BaptPlace:'Hamburg-Altona';Godparents:'The Fary Godmother';Residence:
      'Neunkirchen'{%H-}),
     (ID:7;idFather:0;idMother:0;FamilyName:'Musterfrau';GivenName:'Andrea';Sex:'w';
      Religion:'rk';Occupation:'Sachbearbeiter';Birthday:'22';Birthmonth:'04';Birthyear:
      '1959'{%H-}),
      (ID:8;idFather:3;idMother:4;FamilyName:'Ute';GivenName:'Ext';Sex:'m';
      Religion:'ma';Occupation:'Drücker';Birthday:'28';Birthmonth:'02';Birthyear:
      '1975'{%H-}),
      (ID:9;idFather:6;idMother:7;FamilyName:'Musterkind';GivenName:'Piet';Sex:'m';
      Religion:'na';Occupation:'Schüler';Birthday:'02';Birthmonth:'03';Birthyear:
      '1985'{%H-}));


implementation

end.

