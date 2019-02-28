unit unt_GrueStewBase;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils;

type
    TDir = (drNorth, drEast, drSouth, drWest);
    TMoveResult = (mvOK, mvWall, mvExit, mvExitwMonst, mvMonster, mvPit, mvBat, mvEarthquake);
    TShootResult = (shHit, shWall, shMiss, shMiss2, shMiss3, shEarthquake);
    TSens = (snExit, snSnMonster, snBat, snPit);
    TSensSet = set of TSens;

resourcestring
    Anleitung = 'In diesem Spiel sind sie ein tapferer und sehr #hunriger Jäger#. ' +
        'Deshalb beschließen Sie sich einen ungeheuren #Eintopf# zu kochen. Wie jedemann ' +
        'weiß ist jedoch ein #Ungeheuer# die Grundlage dieses Gerichts.' + LineEnding +
        'Auf der Suche nach der Hauptzutat des Eintopfs dringen sie in ein #düsteres ' +
        'Labyrinth# vor.' + LineEnding +
        'Wenn Sie ein Ungeheuer erlegen ist Ihnen ein ausreichender #Eintopf# sicher ' +
        '(und sie haben das Spiel gewonnen).' + LineEnding +
        'Einmal im Irrgarten, können Sie entweder weiter vordringen oder einen Pfeil '+
        'in eine benachberte Höhle abschießen - in der Hoffnung, das Ungeheuer zu '+
        'Treffen.'+LineEnding+
        'Ich werde Sie deshalb fragen was Sie tun wollen.'+LineEnding+
        'Mögliche Anworten sind die 4 Richtungen in Groß- oder Kleinbuchstaben.'+LIneEnding+
        'Großbuchstaben zum Marschieren, Kleinbuchstaben zum schießen, wenn Sie '+
        'das Ungeheuer treffen sollten, teile ich Ihnen das mit. Sie müssen es zum '+
        'Ausgang schleppen.'+LineEnding+
        'Aber... Es gibt auch noch andere Dinge im Höhlenlabyrinth. Riesige Fleder'+
        'mäuse ergreifen Sie, und werfen Sie irgendwo ab. '+lineending+
        'Es gibt alles verschlingende Abgründe, die Sie nie wieder freigeben!'+LineEnding+
        'Und natürlich das Ungeheuer selbst. Diese angriffslustige Bestie wird Sie '+
        'auffressen, bevor sie sich zur Flucht wenden können.'+Lineending+
        'Erdbeben werfen alles durcheinander, Verschütten Ausgänge usw.';

    EQuake = 'Erdbe.b..e...n >>>';
    CantMoveThere = 'Sie versuche es, aber da geht es nicht weiter ...';
    BatCatchYou ='Die Fledermäuße greifen an!!!'+LineEnding+
        'Sie werden hochgehoben !!!'+Lineending+
        '...Wo sind sie gelandet ???';

    CHeader = LineEnding+'        *** Grue Stew ***'+LineEnding;
    CMap = 'Karte:';
    CPressAnyKey = 'Drücken Sie eine beliebige Taste ...';
    CAnweisung = 'Drücken Sie <n>,<o>,<s>,<w> zum schießen in die Richtung'+LineEnding+
       '        <N>,<O>,<S>,<W> zum bewegen in die Richtung'+LineEnding+
       '        <?> für Hilfe und  <Q> zum Beenden';

    HitMonster = '... und erlegt das Monster. Herzlichen Glückwunsch! Jetzt nur '+
        'noch schnell zum Ausgang';
    HitWall = '... und trifft die Wand';
    NoHit1 = '... und trifft ins leere';
    NoHit2 = '... und trifft nichts';
    NoHit3 = '... und trifft daneben';
    ReachedExit = 'Toll, der Ausgang ist erreicht, leider haben Sie kein Monster '+
         'erlegt, so müssen sie weiter hungern ... ';
    ReachedExitwM = 'Hurra, der Ausgang ist erreicht! Mit dem Monster können sie sich '+
          'jetzt einen köstlichen Eintopf kochen  ... ';
    CaughtBYMonster = 'Das Monster hat sie erwischt. Jetzt ist''s aus ... ';
    FellIntoPit = 'AAAAhhh ..  hh . hh ..h ..... '+LineEnding+'Sie fallen, und fallen ...';

    rsRaumTxt01= 'Sie sind in einem kleinen Raum mit überall verstreut liegenden Felsen und ' +
        'Gesteinstrümmern.';
    rsRaumTxt02= 'Sie müssen tief gebückt weitergehen. Riesige Stalagtiten hängen von der Decke ' +
        'und nehmen Ihnen die Sicht';

const
    RaumTxt: array[1..20] of string =
        (rsRaumTxt01,
        rsRaumTxt02,
        'Der Gang ist sehr schmal und niedrig, Sie müssen sich durchzwängen',
        'Der Höhlenboden wird immer steiler und rutschiger. - Vorsicht !',
        'Sie befinden sich in einem riesigen Saal, in der Mitte können Sie einen hohen ' +
        'Felsen erkennen',
        'Sie durchqueren eine enge Passage zwischen zwei Räumen, Geröll rieselt von ' +
        'der Decke',
        'Die Decke senkt sich immer tiefer, schnell Sie müssen darunter durchkriechen',
        'Ein sehr gefährlicher Aufenthalt, die Höhle wurde vom letzten Erdbeben '+
        'betroffen und ist teilweise eingestürzt.',
        'Sie befinden sich in einem Mittelgroßen Raum - angefüllt mit einem fahlen '+
        'Nebel. Achtung! Der Nebel ist gefährlich - er droht Ihnen den Atem zu nehmen.',
        'Ihr Licht ist erloschen, Sie können sich nur noch tastend vorwärtsbewegen',
        'Sie befinden sich in einem gewundenen Stollen, der Boden ist schlüpfrig '+
        'und von breiten Rissen durchzogen',
        'Sie sind in einem steill abfallenden Durchgang.',
        'Der Durchgang wird enger',
        'Sie sind in einem runden Saal mit mehreren Ausgängen.',
        'Sie erreichen einen wassergefüllten Graben und müssen Schwimmen.',
        'Ein kleines Loch über Ihnen lässt einen fahlen Lichtschein durch... aber '+
        'es ist viel zu klein.',
        'Jemand hat eine angezündete Laterne in einer Nische zurückgelassen - '+
        'Ihr Weg wird hell erleuchtet.',
        'Ein Rinnsal sickert aus einer Ritze in der Wand.',
        'Ein winziger Durchbruch erregt Ihre Aufmerksamkeit; Er ist für sie zu schmal.',
        'Der Hunger nagt an ihren Eingeweiden, deshalb sind Sie total erschöpft '+
        'und fallen beim Wassertrinken in den unterirdischen Fluß ' +
        LineEnding + 'Sie werden davongerissen und an einer gänzlich unbekannten '+
        'Gegend auf den Felsen geschleudert.');

        RaumTxt2: array[-2..20] of string =('##','[]','  ',
        'kR',
        'VV',
        'nG',
        'rB',
        'Sa',
        'eP',
        'sD',
        'mR',
        'NN',
        'Dk',
        'gS',
        'aD',
        'eD',
        'rS',
        'wG',
        'fL',
        'aL',
        'RW',
        'wD',
        'uF');

    SensTxt: array[Tsens] of string =
        ('Der Ausgang ist ganz nahe ...',
        'Sie riechen das Ungeheuer !!!',
        'Schlürf...Schlürf...Schlürf...',
        'Sie spüren einen Luftzug !!!');

     ITryMove: array[TDir] of string =
       ('Nach Norden also ...',
        'Es geht also nach Osten ...',
        'Sie versuchen es nach Süden ...',
        'Let''s go West ...');

     IShoot: array[TDir] of string =
       ('Sie zielen nach Norden und der Pfeil schiesst los ...',
        'Sie zielen Richtung Osten und der Pfeil geht ab ...',
        'Der Pfeil schießt Richtung Süden  ...',
        'Er nam den Bogen, den besten, und schoß den Pfeil nach Westen ...');

     CDirDesc: array[TDir] of string =
       ('drNorth', 'drEast', 'drSouth', 'drWest');
implementation


end.

