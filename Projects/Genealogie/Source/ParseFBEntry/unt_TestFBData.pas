unit unt_TestFBData;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}

interface

uses
    Classes, SysUtils;

const
    cTestEntryGC5065 =
        '5065 Ehe: 20.09.1855 in Mörtelstein' + lineEnding +
        '● Reinmuth, Johann Adam, rf., Bürger, Landwirt in Mörtelstein <5044>, * ' +
        '01.03.1820 in Mörtelstein, ~ 03.03.1820 in Mörtelstein. † 28.04.1892 ' +
        'in Mörtelstein, = 01.05.1892 in Mörtelstein. ' + lineEnding +
        'PN = 14597' + lineEnding +
        '● Kraft (Krafft), Karolina, ev. <Kraft, Georg Adam, Bürger, Bauer in ' +
        'Nüstenbach und †Auerbach, Anna Katharina Barbara>, * 11.07.1833 in ' +
        'Nüstenbach, ~ 15.07.1833 in Nüstenbach. † 13.05.1896 in Mörtelstein, = ' +
        '15.05.1896.' + lineEnding + 'PN = 14598 ' + lineEnding +
        '● Kinder: ' + lineEnding +
        '1) August	* 06.08.1856 in Mörtelstein. † 11.04.1935 in Mörtelstein, Landwirt in Mörtelstein [5102]'
        +
        lineEnding + '2) Sophia	* 11.03.1859 in Mörtelstein. † 22.03.1938 in Mörtelstein [6757]'
        +
        lineEnding + '3) Anna Rosina	* 24.04.1861 in Mörtelstein. † 09.10.1899 in Guttenbach [6286]'
        +
        lineEnding + '4) Wilhelm	* 1863 in Mörtelstein.' + lineEnding;

    cTestEntryAK2421 =
        '2421	⚭ 28.12.1823: Andreas Rosewich <aus 2420>, Taglöhner, Tag­wächter,' +
        ' * 29.10.1796, † 6.4.1878,' + lineEnding +
        'u. Ursula Kobi <aus 1711>, * 19.7.1801, † 27.2.1859, 29 Jahre lang Hebamme.' +
        lineEnding
        + '9 Kdr: Andreas 3.7.1824.' + lineEnding +
        '- Theobald 14.5.1826, + 7.6. 1827,' + lineEnding +
        '- Theobald 10.4.1828, + 2.5.1829.' + lineEnding +
        '- Johannes <2422>.' + lineEnding +
        '- Theobald 7.9.1832, † 21.10.1832.' + lineEnding +
        '- Ursula 18.12.1833, + 29.4.1836.' + lineEnding +
        '- David <2424>.' + lineEnding +
        '- Johann Theobald <2423>.' + lineEnding +
        '- Matthias 23.5.1841.';


type

    { TResultType }

    TResultType = record
        eType,
        Data,
        Ref: string;
        SubType: integer;
        function ToString: string;
        procedure SetAll(const aValue: array of variant); overload;
        procedure SetAll(const aValue: TStringArray); overload;
        function ToCSV(delim: string): string;
        //     property All:array of Variant write SetAll
    end;
    TResultTypeArray = array of TResultType;

const
    cResultTest: array[0..15] of TResultType = (
        (eType: 'eType'; Data: 'Data'; Ref: 'Ref'; SubType: 123),
        (eType: 'ParserStartFamily'; Data: 'Data'; Ref: 'Ref'; SubType: 123),
        (eType: 'ParserFamilyType'; Data: 'AAA'; Ref: 'BBB'; SubType: 2),
        (eType: 'ParserFamilyDate'; Data: 'CCC'; Ref: 'DDD'; SubType: 3),
        (eType: 'ParserFamilyIndiv'; Data: 'EEE'; Ref: 'FFF'; SubType: 4),
        (eType: 'ParserFamilyPlace'; Data: 'GGG'; Ref: 'HHH'; SubType: 5),
        (eType: 'ParserIndiName'; Data: 'III'; Ref: 'JJJ'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: 'KKK'; Ref: 'LLL'; SubType: 7),
        (eType: 'ParserIndiPlace'; Data: 'MMM'; Ref: 'NNN'; SubType: 8),
        (eType: 'ParserIndiRef'; Data: 'OOO'; Ref: 'PPP'; SubType: 9),
        (eType: 'ParserIndiRel'; Data: 'QQQ'; Ref: 'RRR'; SubType: 10),
        (eType: 'ParserIndiOccu'; Data: 'SSS'; Ref: 'TTT'; SubType: 11),
        (eType: 'ParserIndiData'; Data: 'UUU'; Ref: 'VVV'; SubType: 12),
        (eType: 'ParserError!'; Data: 'WWW'; Ref: 'XXX'; SubType: 13),
        (eType: 'ParserWarning'; Data: 'YYY'; Ref: 'YYY2'; SubType: 14),
        (eType: 'ParserDebugMsg'; Data: 'ZZZ'; Ref: 'ZZZ2'; SubType: 15)
        );

    cResultEntryGC5065: array[0..86] of TResultType = (
        (eType: 'ParserStartFamily'; Data: '5065'; Ref: ''; SubType: 0),
        (eType: 'ParserFamilyType'; Data: ''; Ref: '5065'; SubType: 1),
        (eType: 'ParserFamilyDate'; Data: '20.09.1855'; Ref: '5065'; SubType: 3),
        (eType: 'ParserFamilyPlace'; Data: 'Mörtelstein'; Ref: '5065'; SubType: 3),
        (eType: 'ParserIndiName'; Data: 'Reinmuth'; Ref: 'I5065M'; SubType: 1),
        (eType: 'ParserFamilyIndiv'; Data: 'I5065M'; Ref: '5065'; SubType: 1),
        (eType: 'ParserIndiName'; Data: 'Johann Adam'; Ref: 'I5065M'; SubType: 2),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I5065M'; SubType: 6),
        (eType: 'ParserIndiData'; Data: 'rf.'; Ref: 'I5065M'; SubType: 8),
        (eType: 'ParserIndiData'; Data: 'Bürger'; Ref: 'I5065M'; SubType: 9),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065M'; SubType: 9),
        (eType: 'ParserIndiOccu'; Data: 'Landwirt'; Ref: 'I5065M'; SubType: 7),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065M'; SubType: 7),
        (eType: 'ParserIndiRel'; Data: '5044'; Ref: 'I5065M'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '01.03.1820'; Ref: 'I5065M'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065M'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '03.03.1820'; Ref: 'I5065M'; SubType: 2),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065M'; SubType: 2),
        (eType: 'ParserIndiDate'; Data: '28.04.1892'; Ref: 'I5065M'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065M'; SubType: 4),
        //20
        (eType: 'ParserIndiDate'; Data: '01.05.1892'; Ref: 'I5065M'; SubType: 5),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065M'; SubType: 5),
        (eType: 'ParserIndiRef'; Data: '14597'; Ref: 'I5065M'; SubType: 0),
        (eType: 'ParserIndiName'; Data: 'Kraft'; Ref: 'I5065F'; SubType: 1),
        (eType: 'ParserFamilyIndiv'; Data: 'I5065F'; Ref: '5065'; SubType: 2),
        (eType: 'ParserIndiName'; Data: 'Krafft'; Ref: 'I5065F'; SubType: 3),
        (eType: 'ParserIndiName'; Data: 'Karolina'; Ref: 'I5065F'; SubType: 2),
        (eType: 'ParserIndiData'; Data: 'F'; Ref: 'I5065F'; SubType: 6),
        (eType: 'ParserIndiData'; Data: 'ev.'; Ref: 'I5065F'; SubType: 8),
        (eType: 'ParserStartFamily'; Data: '5065F'; Ref: ''; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I5065F'; Ref: '5065F'; SubType: 3),
        (eType: 'ParserIndiName'; Data: 'Kraft'; Ref: 'I5065FM'; SubType: 1),
        //30
        (eType: 'ParserFamilyIndiv'; Data: 'I5065FM'; Ref: '5065F'; SubType: 1),
        (eType: 'ParserIndiName'; Data: 'Georg Adam'; Ref: 'I5065FM'; SubType: 2),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I5065FM'; SubType: 6),
        (eType: 'ParserIndiData'; Data: 'Bürger'; Ref: 'I5065FM'; SubType: 9),
        (eType: 'ParserIndiPlace'; Data: 'Nüstenbach'; Ref: 'I5065FM'; SubType: 9),
        (eType: 'ParserIndiOccu'; Data: 'Bauer'; Ref: 'I5065FM'; SubType: 7),
        (eType: 'ParserIndiPlace'; Data: 'Nüstenbach'; Ref: 'I5065FM'; SubType: 7),
        (eType: 'ParserIndiName'; Data: 'Auerbach'; Ref: 'I5065FF'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: 'vor 20.09.1855'; Ref: 'I5065FF'; SubType: 4),
        (eType: 'ParserFamilyIndiv'; Data: 'I5065FF'; Ref: '5065F'; SubType: 2),
        (eType: 'ParserIndiName'; Data: 'Anna Katharina Barbara'; Ref: 'I5065FF'; SubType: 2),
        //40
        (eType: 'ParserIndiData'; Data: 'F'; Ref: 'I5065FF'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '11.07.1833'; Ref: 'I5065F'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Nüstenbach'; Ref: 'I5065F'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '15.07.1833'; Ref: 'I5065F'; SubType: 2),
        (eType: 'ParserIndiPlace'; Data: 'Nüstenbach'; Ref: 'I5065F'; SubType: 2),
        (eType: 'ParserIndiDate'; Data: '13.05.1896'; Ref: 'I5065F'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065F'; SubType: 4),
        (eType: 'ParserIndiDate'; Data: '15.05.1896'; Ref: 'I5065F'; SubType: 5),
        (eType: 'ParserIndiRef'; Data: '14598'; Ref: 'I5065F'; SubType: 0),
        // 49
        (eType: 'ParserIndiName'; Data: 'Reinmuth'; Ref: 'I5065C1'; SubType: 1),
        (eType: 'ParserFamilyIndiv'; Data: 'I5065C1'; Ref: '5065'; SubType: 3),
        (eType: 'ParserIndiName'; Data: 'August'; Ref: 'I5065C1'; SubType: 2),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I5065C1'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '06.08.1856'; Ref: 'I5065C1'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065C1'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '11.04.1935'; Ref: 'I5065C1'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065C1'; SubType: 4),
        (eType: 'ParserIndiOccu'; Data: 'Landwirt'; Ref: 'I5065C1'; SubType: 7),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065C1'; SubType: 7),
        (eType: 'ParserIndiRel'; Data: '5102'; Ref: 'I5065C1'; SubType: 2),
        // 59
        (eType: 'ParserIndiName'; Data: 'Reinmuth'; Ref: 'I5065C2'; SubType: 1),
        (eType: 'ParserFamilyIndiv'; Data: 'I5065C2'; Ref: '5065'; SubType: 4),
        (eType: 'ParserIndiName'; Data: 'Sophia'; Ref: 'I5065C2'; SubType: 2),
        (eType: 'ParserIndiData'; Data: 'F'; Ref: 'I5065C2'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '11.03.1859'; Ref: 'I5065C2'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065C2'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '22.03.1938'; Ref: 'I5065C2'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065C2'; SubType: 4),
        (eType: 'ParserIndiRel'; Data: '6757'; Ref: 'I5065C2'; SubType: 2),
        // 67
        (eType: 'ParserIndiName'; Data: 'Reinmuth'; Ref: 'I5065C3'; SubType: 1),
        (eType: 'ParserFamilyIndiv'; Data: 'I5065C3'; Ref: '5065'; SubType: 5),
        (eType: 'ParserIndiName'; Data: 'Anna Rosina'; Ref: 'I5065C3'; SubType: 2),
        (eType: 'ParserIndiData'; Data: 'F'; Ref: 'I5065C3'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '24.04.1861'; Ref: 'I5065C3'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065C3'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '09.10.1899'; Ref: 'I5065C3'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Guttenbach'; Ref: 'I5065C3'; SubType: 4),
        (eType: 'ParserIndiRel'; Data: '6286'; Ref: 'I5065C3'; SubType: 2),
        // 73
        (eType: 'ParserIndiName'; Data: 'Reinmuth'; Ref: 'I5065C4'; SubType: 1),
        (eType: 'ParserFamilyIndiv'; Data: 'I5065C4'; Ref: '5065'; SubType: 6),
        (eType: 'ParserIndiName'; Data: 'Wilhelm'; Ref: 'I5065C4'; SubType: 2),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I5065C4'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '1863'; Ref: 'I5065C4'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Mörtelstein'; Ref: 'I5065C4'; SubType: 1)
        );

    cResultEntryAK2421: array[0..76] of TResultType = (
        (eType: 'ParserStartFamily'; Data: '2421'; Ref: ''; SubType: 0),
        (eType: 'ParserFamilyType'; Data: ''; Ref: '2421'; SubType: 1),
        (eType: 'ParserFamilyDate'; Data: '28.12.1823'; Ref: '2421'; SubType: 3),
        (eType: 'ParserFamilyPlace'; Data: 'Meißenheim'; Ref: '2421'; SubType: 3),
        (eType: 'ParserIndiName'; Data: 'Andreas Rosewich'; Ref: 'I2421M'; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I2421M'; Ref: '2421'; SubType: 1),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I2421M'; SubType: 6),
        (eType: 'ParserIndiRel'; Data: '2420'; Ref: 'I2421M'; SubType: 1),
        (eType: 'ParserIndiOccu'; Data: 'Taglöhner'; Ref: 'I2421M'; SubType: 7),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421M'; SubType: 7),
        {10}  (eType: 'ParserIndiOccu'; Data: 'Tagwächter'; Ref: 'I2421M'; SubType: 7),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421M'; SubType: 7),
        (eType: 'ParserIndiDate'; Data: '29.10.1796'; Ref: 'I2421M'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421M'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '6.4.1878'; Ref: 'I2421M'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421M'; SubType: 4),
        (eType: 'ParserIndiName'; Data: 'Ursula Kobi'; Ref: 'I2421F'; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I2421F'; Ref: '2421'; SubType: 2),
        (eType: 'ParserIndiData'; Data: 'F'; Ref: 'I2421F'; SubType: 6),
        (eType: 'ParserIndiRel'; Data: '1711'; Ref: 'I2421F'; SubType: 1),
        {20}  (eType: 'ParserIndiDate'; Data: '19.7.1801'; Ref: 'I2421F'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421F'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '27.2.1859'; Ref: 'I2421F'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421F'; SubType: 4),
        (eType: 'ParserIndiOccu'; Data: '29 Jahre lang Hebamme'; Ref: 'I2421F'; SubType: 7),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421F'; SubType: 7),
        (eType: 'ParserIndiName'; Data: 'Andreas Rosewich'; Ref: 'I2421C1'; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I2421C1'; Ref: '2421'; SubType: 3),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I2421C1'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '3.7.1824'; Ref: 'I2421C1'; SubType: 1),
        {30}   (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C1'; SubType: 1),
        //  (eType:'ParserIndiDate';Data:'3.7.1824.';Ref:'I2421C1';SubType:4),
        (eType: 'ParserIndiName'; Data: 'Theobald Rosewich'; Ref: 'I2421C2'; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I2421C2'; Ref: '2421'; SubType: 4),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I2421C2'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '14.5.1826'; Ref: 'I2421C2'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C2'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '7.6. 1827'; Ref: 'I2421C2'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C2'; SubType: 4),
        //{ETYPE = 'ParserError!', DATA = 'Child entry not ended wit###(gdb unparsed remainder:...)###', REF = '2421', SUBTYPE = 9}
        (eType: 'ParserError!'; Data: 'Child entry not ended with .'; Ref: '2421'; SubType: 9),
        (eType: 'ParserIndiName'; Data: 'Theobald Rosewich'; Ref: 'I2421C3'; SubType: 0),
        {40}(eType: 'ParserFamilyIndiv'; Data: 'I2421C3'; Ref: '2421'; SubType: 5),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I2421C3'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '10.4.1828'; Ref: 'I2421C3'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C3'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '2.5.1829'; Ref: 'I2421C3'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C3'; SubType: 4),
        (eType: 'ParserIndiName'; Data: 'Johannes Rosewich'; Ref: 'I2422M'; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I2422M'; Ref: '2421'; SubType: 6),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I2422M'; SubType: 6),
        (eType: 'ParserIndiRel'; Data: '2422'; Ref: 'I2422M'; SubType: 2),
        (eType: 'ParserIndiName'; Data: 'Theobald Rosewich'; Ref: 'I2421C5'; SubType: 0),
        {50}(eType: 'ParserFamilyIndiv'; Data: 'I2421C5'; Ref: '2421'; SubType: 7),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I2421C5'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '7.9.1832'; Ref: 'I2421C5'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C5'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '21.10.1832'; Ref: 'I2421C5'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C5'; SubType: 4),
        (eType: 'ParserIndiName'; Data: 'Ursula Rosewich'; Ref: 'I2421C6'; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I2421C6'; Ref: '2421'; SubType: 8),
        (eType: 'ParserIndiData'; Data: 'F'; Ref: 'I2421C6'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '18.12.1833'; Ref: 'I2421C6'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C6'; SubType: 1),
        (eType: 'ParserIndiDate'; Data: '29.4.1836'; Ref: 'I2421C6'; SubType: 4),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C6'; SubType: 4),
        (eType: 'ParserIndiName'; Data: 'David Rosewich'; Ref: 'I2424M'; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I2424M'; Ref: '2421'; SubType: 9),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I2424M'; SubType: 6),
        (eType: 'ParserIndiRel'; Data: '2424'; Ref: 'I2424M'; SubType: 2),
        (eType: 'ParserIndiName'; Data: 'Johann Theobald Rosewich'; Ref: 'I2423M'; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I2423M'; Ref: '2421'; SubType: 10),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I2423M'; SubType: 6),
        (eType: 'ParserIndiRel'; Data: '2423'; Ref: 'I2423M'; SubType: 2),
        (eType: 'ParserIndiName'; Data: 'Matthias Rosewich'; Ref: 'I2421C9'; SubType: 0),
        (eType: 'ParserFamilyIndiv'; Data: 'I2421C9'; Ref: '2421'; SubType: 11),
        (eType: 'ParserIndiData'; Data: 'M'; Ref: 'I2421C9'; SubType: 6),
        (eType: 'ParserIndiDate'; Data: '23.5.1841'; Ref: 'I2421C9'; SubType: 1),
        (eType: 'ParserIndiPlace'; Data: 'Meißenheim'; Ref: 'I2421C9'; SubType: 1)
        );

implementation

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

{ TResultType }

function TResultType.ToString: string;
begin
    Result := format('(eType:%s;Data:%s;Ref:%s;SubType:%d)',
        [QuotedStr(eType), QuotedStr(Data), QuotedStr(Ref), SubType]);
end;

procedure TResultType.SetAll(const aValue: array of variant);
begin
    if length(aValue) = 4 then
      begin
        eType := aValue[0];
        Data := aValue[1];
        Data := Data.Replace('\r', #13).Replace('\n', #10).Replace('\t', #9).Replace('\\', '\');
        Ref := aValue[2];
        SubType := aValue[3];
      end;
end;

procedure TResultType.SetAll(const aValue: TStringArray);
begin
    if (length(aValue) = 4) and TryStrToInt(aValue[3], SubType) then
      begin
        eType := aValue[0];
        Data := aValue[1].Replace('\r', #13).Replace('\n', #10).Replace('\t', #9).Replace('\\', '\');
        Ref := aValue[2];
      end
    else
        eType := 'NIO';
end;

function TResultType.ToCSV(delim: string): string;
begin
    Result := ''.Join(delim, [eType, Data.Replace('\', '\\').Replace(
        #9, '\t').Replace(#10, '\n').Replace(#13, '\r'), ref, IntToStr(SubType)]);
end;

end.
