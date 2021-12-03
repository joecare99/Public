unit cmp_GedComDocumentWriter;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface
// Done -ojc: Familien-Clustering
// Todo -ojc: Familien-Datum korrigieren
// Todo -ojc: Einzel-Individuen
// Todo -ojc: Auftrennung in Datenklasse und DokumentWriter

uses
    Classes, SysUtils, odf_types, Cmp_GedComFile, unt_IGenBase2, laz2_dom;

type
    TVirtFamily = class;
    { TGenDocumentWriter }

    TGenDocumentWriter = class(TComponent)
    private
        FDocument: TOdfTextDocument;
        FGenealogy: TGedComFile;
        FLanguage: string;
        FlastFamName: string;
        FMainPlace: String;
        FLastIndex: String;
        FOnLongOp: TNotifyEvent;
        FPropList: TStrings;
        FReligList: TStrings;
//        FSection2: TOdfSection;
        FSelfOwned: boolean;
        FFamilyList: TStrings;
        FFamilyClusterList: TStrings;
        FIndiList: TStrings;
        FPlaceList: TStrings;
        FOccuList: TStrings;
        FPlace2List: TStrings;
        FVirtFamilies: Array of TVirtFamily;
        function IsFullFamily(aFam: iGenFamily): Boolean;
        procedure SetDocument(AValue: TOdfTextDocument);
        procedure SetGenealogy(AValue: TGedComFile);
        procedure SetLanguage(AValue: string);
        procedure SetOnLongOp(AValue: TNotifyEvent);
        function Shortplace(aPlace: string; aFam: IGenEntity; out aPlaceRef: string
          ): string;
    protected
        FSection: TOdfSection;
        function GetFamilyDate(var aFam: iGenFamily): string;

    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure ClearLists;
        procedure PrepareDocument;
        procedure WritePreamble;
        procedure WriteFamily(aEnt: IGenEntity);
        procedure WriteIndIndex;
        procedure WriteOccIndex;
        procedure WritePropIndex;
        procedure WritePlaceIndex;
        procedure WritePlace2Index;
        procedure BuildFamCluster(aFam: iGenFamily);
        procedure AppendFamily(aFam: iGenFamily);
        procedure AppendSingleInd(aInd: IGenIndividual);
        procedure AppendInd(aInd: IGenIndividual);
        procedure AppendIndOcc(aInd: IGenIndividual);
        procedure AppendIndRel(aInd: IGenIndividual);
        procedure AppendIndProp(aInd: IGenIndividual);
        function GetClusterFamilyEntry(FEntry:String):String;
        function GetFamClusterList(FEntry:String):String;
        function GetFamClusterCount(FEntry:String):integer;
        function NormizeStr(aStr: string): string;
        function YearOf(aDate: string): string;
        function SortDate(aDate: string): string;
        function SortName(aName: string): string;
        function LifeSpan(aInd: IGenIndividual): string;
        function EventDateToReadable(aDate: string): string;
        procedure SortAndRenumberFamiliies;
        Procedure AppendText(lCont:TOdfContent;aText:String);
        Procedure AppendMarkupText(lCont:TOdfContent;aText:String);
        procedure SaveToSingleXml(const AFilename: string);
        procedure SaveToZipFile(const AFilename: string);
        Procedure FamClusterList_SaveToFile(AFilename: string);
    published
        property Document: TOdfTextDocument read FDocument write SetDocument;
        property Genealogy: TGedComFile read FGenealogy write SetGenealogy;
        property Language: string read FLanguage write SetLanguage;
        property OnLongOp: TNotifyEvent read FOnLongOp write SetOnLongOp;
        property FamList: TStrings read FFamilyList;
        property indList: TStrings read FIndiList;
        property PlacList: TStrings read FPlaceList;
        property OccuList: TStrings read FOccuList;
        property PropList: TStrings read FPropList;
        property ReligList: TStrings read FReligList;
        property Plac2List: TStrings read FPlace2List;
    end;

    { TVirtFamily }

    TVirtFamily=class(TObject,IGenFamily)
      FGenInd:IGenIndividual;
      FRefID:String;
    public
      Constructor create(aInd:IGenIndividual);
      function EnumChildren: IGenIndEnumerator;
      function GetChildCount: integer;
      function GetChildren({%H-}Idx: Variant): IGenIndividual;
      function GetFamilyName: string;
      function GetFamilyRefID: string;
      function GetHusband: IGenIndividual;
      function GetMarriage: IGenEvent;
      function GetMarriageDate: string;
      function GetMarriagePlace: string;
      function GetWife: IGenIndividual;
      procedure SetChildren({%H-}Idx: Variant; {%H-}AValue: IGenIndividual);
      procedure SetFamilyName({%H-}AValue: string);
      procedure SetFamilyRefID(AValue: string);
      procedure SetHusband({%H-}AValue: IGenIndividual);
      procedure SetMarriage({%H-}AValue: IGenEvent);
      procedure SetMarriageDate({%H-}AValue: string);
      procedure SetMarriagePlace({%H-}AValue: string);
      procedure SetWife({%H-}AValue: IGenIndividual);
      function GetEventCount: integer;
      function GetEvents({%H-}Idx: Variant): IGenEvent;
      procedure SetEvents({%H-}Idx: variant; {%H-}AValue: IGenEvent);
      function GetData: string;
      function GetFType: integer;
      function GetObject: TObject;
      procedure SetData({%H-}AValue: string);
      procedure SetFType({%H-}AValue: integer);
    end;

procedure MyWriteXmlToFile(ADoc: TXMLDocument; AFilename: string);


implementation

uses Graphics, odf_xmlutils, laz2_XMLWrite2, Cls_GedComExt, Unt_StringProcs;

const
    CGedDateModif: array[0..19] of string =
        ('(s)', 'EST', // Geschätztes datum
        'um', 'ABT', // ungefähres Datum
        '(err)', 'CAL', // erreichnetes Datum
        'nach', 'AFT',  // Ereigniss hat (kurz) danach stattgefunden
        'seit', 'AFT',
        'frühestens', 'AFT',
        'vor', 'BEF',  // Ereigniss hatt (kurz) davor stattgefunden
        'ca', 'ABT',  // Ereigniss hatt (kurz) davor stattgefunden
        'zw.', 'BET',  // Ereigniss hatt zwischen zwei Datums-grenzen stattgefunden
        '-', 'AND');

    csFamilyList = 'FamilyList';
    csList3 = 'List3';
    CStCenter = 'StCenter';
    csFamHeader = 'FamHeader';
    csFamilyBook = 'FamilyBook';
    csListEntry = 'FamListEntry';
    csListEntryBreak = 'FamListEntryBreak';
    csTitle ='Title';
    csSubTitle ='Subtitle';
    csTextBlock = 'Text_20_body';
    csTextEnumEntry = 'EnumEntry';
    csGlossar = 'Glossar';
    csGlosEntry = 'GlossarEntry';
    csNumList = 'NumList';

resourcestring
    rsBorn = '*';
    rsBapt = '~';
    rsMarr = '⚭';
    rsDeath = '†';
    rsBurr = '=';
    rsIlleg = 'o-o';
    rsIlleg2 = 'o~o';
    rsDivo = 'o/o';
    rsAusgewandert = 'ausgewandert';
    rsBerufsverzei = 'Berufsverzeichnis';
    rsEigentumsverzei = 'Eigentumsverzeichnis';
    rsBesa = 'besaß';
    rsFamilienverzeichnis = 'Familienverzeichnis';
    rsEinleitung = 'Einleitung';
    rsKam = 'kam';
    rsMitgliedDes = 'Mitglied des';
    rsMitgliedSeit = 'Mitglied seit';
    rsOrtsverzeich = 'Ortsverzeichnis';
    rsOrtsverzeich2 = 'Ortsverzeichnis (hierarchisch)';
    rsPersonenverz = 'Personenverzeichnis';
    rsWar = 'war';
    rsGeboren= 'geboren';
    rsGetauft= 'getauft';
    rsGeheiratet= 'geheiratet';
    rsGestorben= 'gestorben';
    rsBegraben= 'begraben';
    rsUnehelich= 'unehelich';
    rsGeschieden= 'geschieden';
    rsTitle = 'Familienbuch %s';
    rsSubtitle = 'Untertitel';
    rsTOC = 'Inhaltsverzeichnis';
    rsHeadline = 'Anleitung für die Leser des Familienbuches';
    rsChapter1 = 'Die Anordnung des Stoffes';
    rsChapter1Text1 = 'So verwickelt auch die Darstellung verwandtschaftlicher '+
    'Zusammenhänge erscheinen mag, so lässt sich der zeitliche Ablauf der '+
    'Geschlechter und ganzer Bevölkerungen doch auf ein stets gleichbleibendes '+
    'Grundelement zurückführen: _auf die aus einem Elternpaar und seinen Kindern '+
    'bestehende Familie_, die sogenannte _Kleinfamilie_. Jede Familie entsteht '+
    'in der Regel durch die Eheschließung, wächst mit der Geburt der Kinder, '+
    'schwindet wieder mit deren Heranwachsen und Ausscheiden aus dem Elternhaus, '+
    'und erlischt schließlich mit dem Tod der beiden Ehegatten, um so im Wechsel '+
    'der Zeit immer wieder neuen Familien Platz zu machen.';
    rsChapter1Text2 = 'Der gesamte Stoff des Buches ist daher grundsätzlich nach '+
    'Familien geordnet. Jede Familie ist mit einer laufenden Nummer versehen, '+
    'das ist die Familiennummer. Auch Einzelfälle, vereinzelte Geburten, '+
    'Sterbefälle oder Verheiratungen von sonst ortsfremden Personen werden '+
    'mitgezählt, sie werden eben als Bestandteile oder Bruchstücke von '+
    'Kleinfamilien angesehen, die sich irgendwie an anderen Orten ergänzen lassen.';
    rsChapter1Text3 = 'Alle Familien gleichen Namens sind zusammengefasst und in '+
    'sich zeitlich geordnet, #ohne# Rücksicht darauf, ob sie miteinander in einem '+
    'verwandtschaftlichen Zusammenhang stehen oder nicht. Eine Darstellung und '+
    'Trennung nach "Stämmen" erfolgt also nicht.';
    rsChapter1Text4 = 'Da die Schreibweise der Familiennamen zum Teil noch fast '+
    'bis ins 19.Jahrhundert starken Schwankungen unterworfen war, wurde die '+
    'Einordnung der Familien dieses Namens in der Regel nach der heute üblichen '+
    'Schreibweise vorgenommen. Die abweichenden oder in früherer Zeit '+
    'gebräuchlichen Formen eines Namens sind bei den einzelnen Familien oder am '+
    'Anfang des Abschnitts so aufgeführt, wie sie in den Quellen vorkommen. Im '+
    'Familiennamensverzeichnis am Schluss des Buches sind mit allen Familiennamen '+
    'auch deren abweichende Formen aufgenommen.';
    rsChapter1Text5 = 'Für die zeitliche Einordnung einer Familie war stets der '+
    'Zeitpunkt ihrer Entstehung maßgebend, also in der Regel das Traudatum. '+
    'War aber das Traudatum nicht zu ermitteln, so z.B. bei Beginn der '+
    'Kirchenbücher, ferner wenn eine Familie von außerhalb zuzog und die Trauung '+
    'an einem anderen Ort stattfand, dann ist die betreffende Familie zeitlich '+
    'nach dem Geburtsdatum des ersten bekannten Kindes eingeordnet.';
    rsChapter2 = 'Die Familienzusammenhänge';
    rsChapter2Text1 = 'Der verwandtschaftliche Zusammenhang zwischen den '+
    'einzelnen Familien ist mit Hilfe der Familiennummern ersichtlich gemacht. '+
    'Bei jeder Familie ist sowohl beim Mann als auch bei der Frau in eckigen '+
    'Klammern (z.B. |<5550>|) durch die Familiennummer angegeben, '+
    'aus welchen Familien sie stammen. Ebenso wird auch in großen eckigen '+
    'Klammern auf andere Ehen oder auf uneheliche Verbindungen der betreffenden '+
    'Person hingewiesen (z.B. |[4321]|).';
    rsChapter2Text2 = 'In gleicher Weise wird bei den Kindern jeder Familie durch '+
    'Zusatz, der entsprechenden Familiennummern in grpßen eckigen Klammern '+
    'angegeben, welche ehelichen oder unehelichen Verbindungen die Kinder später '+
    'selbst eingegangen sind.';
    rsChapter2Text3 = 'Durch dieses System sind sämtliche aufgeführten Familien und '+
    'Einzelpersonen, die mit anderen hier aufgeführten Familien in irgend einem '+
    'verwandtschaftlichen Zusammenhang stehen, in einfacher Form miteinander in '+
    'Verbindung gesetzt.';
    rsChapter2Text4 = 'Bei Personen, die von außerhalb stammen, die in den Ort '+
    'einheirateten oder von auswärts zugezogen sind, und also auch keine '+
    'verwandtschaftliche Beziehung im Ort haben, wird jeweils in den eckigen '+
    'Klammern an Stelle der Familiennummern alles das angegeben, was, über ihre '+
    'Herkunft, ihre Eltern, deren Beruf und Wohnort oder was über weitere '+
    'auswärtige Verbindungen bekannt ist.';
    rsChapter3 = 'Zeichen und Abkürzungen';
    rsChapter3Text1 = 'Die Wiedergabe des Gesamtinhaltes der Kirchenbücher und '+
    'der Standesamtsregister auf so engem Raume war nur möglich durch die '+
    'weitgehende Verwendung von Zeichen und Abkürzungen und durch die größte '+
    'Kürze und Knappheit des Ausdrucks. Folgende Zeichen und Abkürzungen wurden '+
    'daher im Familientext verwendet:';
    rsChapter4 = 'Die Angaben bei jeder Familie';
    rsChapter4Text1 = 'Die Angaben bei jeder Kleinfamilie sind in zwei Hauptteile '+
    'gegliedert, von denen der erste die Eheleute (die Eltern) selbst, der zweite '+
    'die Kinder betrifft. Alle Angaben stehen im Regelfalle stets in dieser '+
    'Reihenfolge:';
    rsChapter4Text2 = '1.'#9'Trauungsdatum und Trauungsort.';
    rsChapter4Text3 = '2.'#9'Die Angaben über den Ehemann: _seinen oder seine Vornamen_, '+
    'wobei hier wie sonst der Rufname, wenn er bekannt ist, durch Unterstreichung '+
    'hervorgehoben ist, Beruf, Wohnort, Bekenntnis, in eckigen Klammern hinter '+
    'dem Bekenntnis Herkunft oder andere eheliche oder uneheliche Verbindungen; '+
    'Lebensdaten.';
    rsChapter4Text4 = '3.'#9'Die Angaben über die Ehefrau in gleicher Reihenfolge.';
    rsChapter4Text5 = '4.'#9'Die Angaben über die Kinder:';
    rsChapter4Text6 = 'Die Kinder sind, soweit die Geburtsdaten bekannt sind, '+
    'nach dem Alter geordnet. Bei den im Ort verheirateten Kindern folgen nach '+
    'dem oder den Vornamen in eckigen Klammern die Familiennummern, unter denen '+
    'ihre ehelichen oder unehelichen Verbindungen zu finden sind. Bei '+
    'unverheirateten Kindern folgen nach den Vornamen unmittelbar Geburtszeit '+
    'und -ort, Berufe, evtl. auswärtige Verheiratungen oder die Angabe der '+
    'Abwanderung. Da das Ortssippenbuch nur den Inhalt der örtlichen Quellen '+
    'wiedergibt, so besteht bei den zu- und abgewanderten Familien stets die '+
    'Möglichkeit, dass außer den angegebenen Kindern noch weitere zur Familie '+
    'gehören, die nicht am Ort geboren bzw. gestorben sind. Wie denn in vielen '+
    'Fällen Familien unvollständig bleiben müssen, die am Ort selbst nicht von '+
    'ihrer Gründung bis zu ihrer Auflösung wohnhaft geblieben sind.';
    rsChapter4Text7 = 'Auf fehlende Lebensdaten wird nicht besonders hingewiesen; '+
    'ist also bei einer Person aus den örtlichen Quellen nichts über Geburt, '+
    'Heirat oder Tod, Beruf, Wohn- oder Herkunftsort usw. zu erfahren, so sind '+
    'diese Angaben im Text einfach übergangen.';
    rsChapter5 = 'Uneheliche Verbindungen';
    rsChapter5Text1 = 'Uneheliche Verbindungen stellen "biologische Ehen" dar '+
    'und werden wie Kleinfamilien behandelt. Sie erhalten wie die ehelichen '+
    'Verbindungen eine Familiennummer, ihre zeitliche Einordnung erfolgt nach '+
    'dem Geburtstag des (ersten) Kindes.';
    rsChapter5Text2 = 'Uneheliche Kinder stehen in der Regel unter dem '+
    'Familiennamen der Mutter, da sie diesen in den meisten Fällen im späteren '+
    'Leben führten. Der Vater des unehelichen Kindes ist nur dann angegeben, '+
    'wenn eine ausdrückliche Vaterschaftsanerkennung erfolgte. Hatte eine Frau '+
    'mehrere uneheliche Kinder, ohne dass der Vater oder die Väter bekannt oder '+
    'genannt sind, so sind diese Kinder der Einfachheit halber unter einer '+
    'gemeinsamen Familiennummer zusammengefasst; damit ist jedoch nicht, gesagt, '+
    'dass es sich um Vollgeschwister von dem gleichen Vater handelt.';
    rsChapter5Text3 = 'Uneheliche Kinder, deren Eltern später miteinander '+
    'heirateten, sogenannte "voreheliche" Kinder, sind daher nicht als uneheliche '+
    'Kinder behandelt, sondern sind gemeinsam mit den .ehelich geborenen '+
    'Geschwistern unter der elterlichen Familiennummer zusammengefasst.';
    rsChapter6 = 'Die Verzeichnisse';
    rsChapter6Text1 = 'Alle vorkommenden Personen sind am Schluss des Buches in '+
    'einem alphabetisch geordneten Verzeichnis zusammengestellt; dabei wird auch '+
    'auf die verschiedenen Schreibweisen eines Namens durch gegenseitige Verweise '+
    'eingegangen. Ebenso sind alle vorkommenden Ortsnamen und Berufe in einem '+
    'Register aufgeführt; bei der näheren Bestimmung der Orte, die zwar nicht in '+
    'allen Fällen möglich war, wurde die Angabe der geographischen Lage für '+
    'wichtiger angesehen als die der vielfach wechselnden politischen '+
    'Zugehörigkeit. Die Zahlen hinter den Familien- und Ortsnamen verweisen auf '+
    'die Familiennummern, unter denen sie zu finden sind.';
    rsChapter7 = 'Wie findet man Anschluss an den Familientext';
    rsChapter7Text1 = 'Der Ortsansässige findet wohl im Familientext des Buches '+
    'infolge der strengen alphabetischen und zeitlichen Ordnung des gesamten '+
    'Stoffes leicht seine eigene Familie oder sich selbst sowie seine weiteren '+
    'Verwandten. An Hand der übersichtlichen Nummerierung wird jeder nach einiger '+
    'Übung gar bald die mannigfaltigen Verbindungen des weitverzweigten '+
    'Verwandtschaftsgefüges seines Ortes zu entwirren vermögen. Demjenigen aber, '+
    'der nur eine einzelne Familie oder Person sucht, ohne nähere Zusammenhänge '+
    'zu kennen, helfen in den meisten Fällen die ausführlichen Namens- und '+
    'Ortsverzeichnisse weiter.';
    rsChapter8 = 'Einträge von auswärts';
    rsChapter8Text1 = 'Es sei besonders darauf hingewiesen, dass alle Zeit- und '+
    'Ortsangaben außerhalb unseres Ortes in den meisten Fällen aus den örtlichen '+
    'Quellen selbst stammen, also aus den Kirchenbüchern und Standesamtsregistern '+
    'des eigenen Ortes. Von auswärts konnten keinerlei Nachrichten eingeholt '+
    'werden, das würde den Rahmen wie auch das Thema dieses Buches überschritten '+
    'haben.';
    rsChapter8Text2 = 'Außerdem war es in all den Fällen nicht möglich, eine Quelle '+
    'mit Urkundenwert heranzuziehen, wo es sich um die Darstellung der Familien '+
    'der Neubürger und Heimatvertriebenen handelt. Alle Nachrichten über sie '+
    'beruhen fast ausschließlich auf mündliche Mitteilungen oder auf ihren '+
    'eigenen Angaben bei Verwaltungserhebungen (Haushaltslisten u.ä.) und sind '+
    'deswegen von allen übrigen streng quellenmäßig belegten Angaben des Buches '+
    'zu unterscheiden, Doch erhöht die Aufnahme dieses neuen Bevölkerungsteiles '+
    'mit den Angaben über dessen Herkunft den historischen Wert des Buches gerade '+
    'für spätere Zeiten so ungemein, dass diese Nachteile nicht so entscheidend '+
    'ins Gewicht fallen dürften.';
    rsChapter8Text3 = 'Sehr nachteilig für die Vollständigkeit wirken sich die '+
    'von den Pfarr- und Standesämtern nur sehr mangelhaft erfassten und erfassbaren '+
    'Mitteilungen über die teilweise sehr zahlreichen auswärts erfolgten Geburten '+
    'und Sterbefälle von Ortseinwohnern aus. Es waren daher oft empfindliche '+
    'Lücken nicht zu vermeiden.';
    rsChapter9 = 'Berichtigungen und Ergänzungen';
    rsChapter9Text1 = 'Die mit der Bearbeitung des umfangreichen Quellenmaterials '+
    'und der Einordnung der zahlreichen Familienzusammenhänge verbundene '+
    'Kleinarbeit lässt auch bei größter Genauigkeit und Sorgfalt das Unterlaufen '+
    'von Versehen nicht in allen Fällen vermeiden. Allein schon die Quellen sind '+
    'nicht frei von Unrichtigkeiten und Irrtümern, auch decken sich manchmal die '+
    'Angaben der Standesamtsregister und die der Kirchenbücher nicht, ganz '+
    'abgesehen von den Angaben der in Zweifelsfällen persönlich befragten. Für '+
    'alle Hinweise und Vorschläge zur Berichtigung und Verbesserung, die in '+
    'einem Korrekturverzeichnis später zusammengefasst werden sollen,ist daher '+
    'der Verfasser stets dankbar.';

function GetUtf8SingleChar(const lSortedplace: string;offset:Integer): string;

begin
  if ord(copy(lSortedplace, offset, 1)[1]) < $c0 then
      Result :=copy(lSortedplace, offset, 1)
  else if ord(copy(lSortedplace, offset, 1)[1]) < $e0 then
      Result :=copy(lSortedplace, offset, 2)
  else if ord(copy(lSortedplace, offset, 1)[1]) < $f0 then
     Result := copy(lSortedplace, offset, 3)
  else
      Result:=copy(lSortedplace, offset, 4);
end;

function TrimUTF8(const aText: String): String;
var
  i: Integer;
begin
  result := aText;
  i := 1;
  while i<=length(Result) do
    if ord(Result[i])<$80 then  // Normal char
      inc(i)
    else if ord(Result[i])<$c0 then // illegal Char
      delete(Result,i,1)
    else if ord(Result[i])<$e0 then
      begin
        if (length(Result)<=i)
          or (ord(Result[i+1])<$80) then
            delete(Result,i,1)
        else
          inc(i,2)
      end
    else if ord(Result[i])<$f0 then
        if (length(Result)<=i)
          or (ord(Result[i+1])<$80) then
            delete(Result,i,1)
        else if (length(Result)<=i+1)
          or (ord(Result[i+2])<$80) then
            delete(Result,i,2)
        else
          inc(i,3)
    else if (length(Result)<=i)
      or (ord(Result[i+1])<$80) then
            delete(Result,i,1)
        else if (length(Result)<=i+1) or
          (ord(Result[i+2])<$80) then
            delete(Result,i,2)
        else if (length(Result)<=i+2) or
          (ord(Result[i+3])<$80) then
            delete(Result,i,3)
        else
          inc(i,4);
end;

function TrimAlphaNum(const aText: String): String;
var
  i: Integer;
begin
  result := aText;
  i := 1;
  while i<=length(Result) do
    if Result[i] in ['A'..'Z','a'..'z','0'..'9'] then  // Normal char
      inc(i)
    else  // illegal Char
      delete(Result,i,1)
end;

procedure MyWriteXmlToFile(ADoc: TXMLDocument; AFilename: string);
begin
    WriteXMLFile(ADoc, AFilename, [xwfPreserveWhiteSpace, xwfSpIndent]);
end;

{ TVirtFamily }

constructor TVirtFamily.create(aInd: IGenIndividual);
begin
  FGenInd := aInd;
end;

function TVirtFamily.EnumChildren: IGenIndEnumerator;
begin
   result := nil;
end;

function TVirtFamily.GetChildCount: integer;
begin
  result := 0;
end;

function TVirtFamily.GetChildren(Idx: Variant): IGenIndividual;
begin
  result := nil;
end;

function TVirtFamily.GetFamilyName: string;
begin
  result := FGenInd.Surname;
end;

function TVirtFamily.GetFamilyRefID: string;
begin
  result := FRefID;
end;

function TVirtFamily.GetHusband: IGenIndividual;
begin
  if FGenInd.Sex <> 'F' then
     result := FGenInd
  else
    result := nil;
end;

function TVirtFamily.GetMarriage: IGenEvent;
begin
  result := nil;
end;

function TVirtFamily.GetMarriageDate: string;
begin
   result := '';
end;

function TVirtFamily.GetMarriagePlace: string;
begin
  result := '';
end;

function TVirtFamily.GetWife: IGenIndividual;
begin
  if FGenInd.Sex = 'F' then
     result := FGenInd
  else
    result := nil;
end;

procedure TVirtFamily.SetChildren(Idx: Variant; AValue: IGenIndividual);
begin

end;

procedure TVirtFamily.SetFamilyName(AValue: string);
begin

end;

procedure TVirtFamily.SetFamilyRefID(AValue: string);
begin
  if AValue = FRefID then exit;
  FRefID := AValue;
end;

procedure TVirtFamily.SetHusband(AValue: IGenIndividual);
begin

end;

procedure TVirtFamily.SetMarriage(AValue: IGenEvent);
begin

end;

procedure TVirtFamily.SetMarriageDate(AValue: string);
begin

end;

procedure TVirtFamily.SetMarriagePlace(AValue: string);
begin

end;

procedure TVirtFamily.SetWife(AValue: IGenIndividual);
begin

end;

function TVirtFamily.GetEventCount: integer;
begin
  result := 0;
end;

function TVirtFamily.GetEvents(Idx: Variant): IGenEvent;
begin
  result := nil;
end;

procedure TVirtFamily.SetEvents(Idx: variant; AValue: IGenEvent);
begin

end;

function TVirtFamily.GetData: string;
begin
  result := ''
end;

function TVirtFamily.GetFType: integer;
begin
  result :=-1
end;

function TVirtFamily.GetObject: TObject;
begin
   result := self;
end;

procedure TVirtFamily.SetData(AValue: string);
begin

end;

procedure TVirtFamily.SetFType(AValue: integer);
begin

end;


{ TGenDocumentWriter }

constructor TGenDocumentWriter.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FDocument := TOdfTextDocument.Create;
    FSelfOwned := True;
    FFamilyList := TStringList.Create;
    FFamilyClusterList := TStringList.Create;
    FIndiList := TStringList.Create;
    FOccuList := TStringList.Create;
    FPropList := TStringList.Create;
    FReligList := TStringList.Create;
    FPlaceList := TStringList.Create;
    FPlace2List := TStringList.Create;
end;

destructor TGenDocumentWriter.Destroy;
begin
    if FSelfOwned then
        FreeAndNil(FDocument);
    ClearLists;
    freeandnil(FFamilyList);
    freeandnil(FFamilyClusterList);
    freeandnil(FIndiList);
    freeandnil(FOccuList);
    freeandnil(FPropList);
    freeandnil(FReligList);
    freeandnil(FPlaceList);
    freeandnil(FPlace2List);

    inherited Destroy;
end;



procedure TGenDocumentWriter.SetDocument(AValue: TOdfTextDocument);
begin
    if FDocument = AValue then
        Exit;
    if assigned(FDocument) and FSelfOwned then
        FreeAndNil(FDocument);
    FSelfOwned := False;
    FDocument := AValue;
end;

procedure TGenDocumentWriter.ClearLists;
var
  i: integer;
begin
  for i := high(FVirtFamilies) downto 0 do
     freeandnil(FVirtFamilies[i]);
  setlength(FVirtFamilies,0);

  for i := 0 to FPlaceList.Count - 1 do
    begin
      TList(FPlaceList.Objects[i]).Free;
      FPlaceList.Objects[i] := nil;
    end;
  TStringList(FPlaceList).Sorted :=  false;
  FPlaceList.Clear;

  for i := 0 to FPlace2List.Count - 1 do
    begin
      TList(FPlace2List.Objects[i]).Free;
      FPlace2List.Objects[i] := nil;
    end;
  TStringList(FPlace2List).Sorted :=  false;
  FPlace2List.Clear;

  for i := 0 to FOccuList.Count - 1 do
    begin
      TList(FOccuList.Objects[i]).Free;
      FOccuList.Objects[i] := nil;
    end;
  TStringList(FOccuList).Sorted :=  false;
  FOccuList.Clear;

  for i := 0 to FReligList.Count - 1 do
    begin
      TList(FReligList.Objects[i]).Free;
      FReligList.Objects[i] := nil;
    end;
  TStringList(FReligList).Sorted :=  false;
  FReligList.Clear;

  for i := 0 to FPropList.Count - 1 do
    begin
      TList(FPropList.Objects[i]).Free;
      FPropList.Objects[i] := nil;
    end;
  TStringList(FPropList).Sorted :=  false;
  FPropList.Clear;

  TStringList(FIndiList).Sorted :=  false;
  FIndiList.Clear;

  TStringList(FFamilyList).Sorted :=  false;
  FFamilyList.Clear;

  for i := 0 to FFamilyClusterList.Count - 1 do
    begin
      TStringList(FFamilyClusterList.Objects[i]).Free;
      FFamilyClusterList.Objects[i] := nil;
    end;
  TStringList(FFamilyClusterList).Sorted :=  false;
  FFamilyClusterList.Clear;
end;

function TGenDocumentWriter.IsFullFamily(aFam: iGenFamily): Boolean;
var
  lIsFullFAm: Boolean;
begin
  lIsFullFAm := (assigned(aFam.Husband) and (aFam.Husband.GetChildrenCount > 1))
        or (assigned(afam.Wife) and (afam.Wife.GetChildrenCount > 1))
        or (assigned(aFam.Husband) and assigned(aFam.Husband.ParentFamily))
        or (assigned(afam.Wife) and assigned(afam.Wife.ParentFamily))
        or (afam.ChildCount = 0)
        or (afam.Children[0].ChildCount>0)
        or (afam.Children[0].SpouseCount>0);
  Result:=lIsFullFAm;
end;

procedure TGenDocumentWriter.SetGenealogy(AValue: TGedComFile);
begin
    if FGenealogy = AValue then
        Exit;
    FGenealogy := AValue;
end;

procedure TGenDocumentWriter.SetLanguage(AValue: string);
begin
    if FLanguage = AValue then
        Exit;
    FLanguage := AValue;
end;

procedure TGenDocumentWriter.SetOnLongOp(AValue: TNotifyEvent);
begin
    if FOnLongOp = AValue then
        Exit;
    FOnLongOp := AValue;
end;

function TGenDocumentWriter.Shortplace(aPlace: string; aFam: IGenEntity;
    out aPlaceRef: string): string;

var
    lpp: integer;

    procedure AddUpdPlace1(aPlace: string);
    var
        lList: TList;
        lplIx: integer;
    begin
        lplIx := FPlaceList.IndexOf(aPlace);
        if lplIx < 0 then
          begin
            lList := TList.Create;
            lList.Add(afam);
            FPlaceList.AddObject(aPlace, TObject(lList));
          end
        else
          begin
            lList := TList(FPlaceList.Objects[lplIx]);
            if lList.IndexOf(aFam) >= 0 then
                exit; //!!
            lList.Add(afam);
          end;
    end;

    procedure AddUpdPlace2(aPlace: string);
    var
        lList: TList;
        lplIx, i: integer;
        lPlace: string;
        llPlace: TStringArray;
    begin
        llPlace := aPlace.Split(',');
        lPlace := '';
        for i := high(llPlace) downto 0 do
            lplace += trim(llPlace[i]) + ', ';
        lplIx := FPlace2List.IndexOf(lPlace);
        if lplIx < 0 then
          begin
            lList := TList.Create;
            lList.Add(afam);
            FPlace2List.AddObject(lPlace, TObject(lList));
          end
        else
          begin
            lList := TList(FPlace2List.Objects[lplIx]);
            if lList.IndexOf(aFam) >= 0 then
                exit; //!!
            lList.Add(afam);
          end;
    end;

begin
  // Workaround um FTM-Bug
    if aplace.StartsWith('/') then
       aPlace := copy(aPlace,2);
    Result := aPlace;
    lpp := aPlace.IndexOf(',');
    aPlaceRef := '';
    if aPlace = '' then
        exit;
    if lpp > 0 then
        Result := trimutf8(trim(copy(aPlace, 1, lpp)));
    aPlaceRef := TrimAlphaNum(Result) + IntToStr(copy(aPlace,lpp+2).GetHashCode);
    AddUpdPlace1(aPlace);
    AddUpdPlace2(aPlace);
    if (result <>'') and (result = FMainPlace) then
       result := GetUtf8SingleChar(result,1)+'.';
end;

function TGenDocumentWriter.GetFamilyDate(var aFam: iGenFamily): string;
var
    lYear: longint;
    lFamDate: string;
begin
    if not assigned(afam) then
        exit('');
    lFamDate := afam.MarriageDate;
    if (lFamDate = '') and (afam.ChildCount > 0) then
        lFamDate := aFam.Children[0].BirthDate;
    if (lfamDate = '') and (afam.ChildCount > 0) then
        lFamDate := aFam.Children[0].BaptDate;
    if (lfamDate = '') and assigned(afam.Husband) and Assigned(aFam.Wife) then
      begin
        lFamDate := yearof(afam.Wife.BirthDate);
        if (lFamDate = '') then
            lFamDate := yearof(afam.Wife.BaptDate);
        if (lFamDate <> '') and trystrtoint(lFamDate, lYear) then
            lFamDate := IntToStr(lYear - 5);
        if (lFamDate = '') then
            lFamDate := yearof(afam.Husband.BirthDate);
        if (lFamDate = '') then
            lFamDate := yearof(afam.Husband.BaptDate);
        if (lFamDate <> '') and trystrtoint(lFamDate, lYear) then
            lFamDate := 'EST ' + IntToStr(lYear + 30);
      end
    else if (lfamDate = '') and (afam.ChildCount = 0) then
      begin
        if assigned(afam.Husband) then
          begin
            lFamDate := afam.Husband.BirthDate;
            if (lFamDate = '') then
                lFamDate := afam.Husband.BaptDate;
          end
        else if (lfamDate = '') and Assigned(aFam.Wife) then
          begin
            lFamDate := afam.Wife.BirthDate;
            if (lFamDate = '') then
                lFamDate := afam.Wife.BaptDate;
          end;
      end;
    Result := lFamDate;
end;

procedure TGenDocumentWriter.WriteFamily(aEnt: IGenEntity);
var
    lPara: TOdfParagraph;
    lID, lSortedFname, lUpperFam: string;
    afam: IGenFamily;

    // Aufbau:
  {   <b><u><Nummer:FamRef></u></b> <Event:Marr>: [<Event:Div>]<br>
        <DOT> <Ind:Husband><br>
        <DOT> <Ind:Wife><br>
        <DOT> <List:Children><br>

    <Event>:= <Sign> <Datum> "in" <Ort:Short>

    <Fact>:= <Description> "in" <Ort:Short>

    <Ind>:=<b><Nachname> [<AKA:Nachname>]</b>, <Vorname> [<AKA:VN>], <Religion:Short>,
       <i><-><<FamChldRef>>[<Nummern:FamParent>]</-></i>, <Fact:wohnhaft(Pref)>, <Fact:Beruf(Pref)>,
       <Fact:Member(pref)>, <Event:Geburt>, <Event:Taufe>, <Event:Tod>, <Event:Begräbnis><br>, <Fact:Emigr>
       <Liste:Lebensphasen><br>
       <Liste:Referenzen>

    <FamChldRef>:=<Number:Parents>|<IndRed:Father> u. <IndRed:Mother>

    <Liste> := <Title>:<br>
       <Elements>

     <Elements>:= <Element> | <Element><br><Elements>


    }


    procedure AppendEvent(aPara: TOdfParagraph; aEvent: iGenEvent);

    var
        lEvtIdent, lrDate, lPlace, lPlaceRef: string;
    begin
        lPlace := Shortplace(aEvent.Place, aEnt, lPlaceRef);
        if aEvent.Eventtype = evt_Birth then
            lEvtIdent := rsBorn
        else
        if aEvent.Eventtype = evt_Baptism then
            lEvtIdent := rsBapt
        else
        if aEvent.Eventtype = evt_Marriage then
            lEvtIdent := rsMarr
        else
        if aEvent.Eventtype = evt_Death then
            lEvtIdent := rsDeath
        else
        if aEvent.Eventtype = evt_Burial then
            lEvtIdent := rsBurr
        else
        if aEvent.Eventtype = evt_AddEmigration then
            lEvtIdent := rsAusgewandert
        else
        if aEvent.Eventtype = evt_Immigration then
            lEvtIdent := rsKam
        else
        if aEvent.Eventtype = evt_Property then
            lEvtIdent := rsBesa
        else
        if aEvent.Eventtype = evt_Description then
            lEvtIdent := rsWar
        else
        if aEvent.Eventtype = evt_Occupation then
            lEvtIdent := ''
        else
        if aEvent.Eventtype = evt_Confirmation then
            lEvtIdent := 'Konf.:'
        else
        if aEvent.Eventtype = evt_Education then
            lEvtIdent := 'Ausb.:'
        else
        if aEvent.Eventtype = evt_Member then
            if aEvent.Date <> '' then
                lEvtIdent := rsMitgliedSeit
            else
                lEvtIdent := rsMitgliedDes
        else
            lEvtIdent := '';

        if lEvtIdent <> '' then
            lEvtIdent += ' ';  // NBSpace
        lrDate := EventDateToReadable(aEvent.Date);
        if (aEvent.Data = '') and (lPlace = '') then
            aPara.AddSpan(TrimUTF8(lEvtIdent + lrDate), [])
        else if (aEvent.Data = '') and (lPlace <> '') then
            begin
               aPara.AddSpan(TrimUTF8(lEvtIdent + lrDate + ' in ' ), []);
               aPara.AddLink(lPlace,[],'P'+lPlaceRef);
            end
        else if aEvent.EventType in [evt_Birth, evt_Baptism,
            evt_Marriage, evt_Death, evt_Burial] then
               begin
                aPara.AddSpan(TrimUTF8(lEvtIdent + lrDate + ' in '), []);
                aPara.AddLink(lPlace,[],'P'+lPlaceRef);
                aPara.AddSpan(TrimUTF8(' (' + aEvent.Data + ')'), []);
               end
        else if (aEvent.EventType = evt_Member) and (aEvent.date <> '') and
            (lPlace <> '') then
                begin
                  aPara.AddSpan(TrimUTF8(lEvtIdent + lrDate + ' im ' + aEvent.Data +
                    ' in '), []);
                  aPara.AddLink(lPlace,[],'P'+lPlaceRef);
                end
        else if (aEvent.EventType = evt_Member) and (aEvent.date <> '') then
            aPara.AddSpan(TrimUTF8(lEvtIdent + lrDate + ' im ' + aEvent.Data), [])
        else if (aEvent.EventType = evt_Member) and (lPlace <> '') then
            begin
              aPara.AddSpan(TrimUTF8(lEvtIdent + lrDate + ' in ' ), []);
              aPara.AddLink(lPlace,[],'P'+lPlaceRef);
            end
        else if (aEvent.EventType = evt_AddEmigration) and (lPlace <> '') then
            begin
              aPara.AddSpan(TrimUTF8(lEvtIdent + lrDate + ' nach '), []);
              aPara.AddLink(lPlace,[],'P'+lPlaceRef);
            end
        else if (aEvent.EventType = evt_Immigration) and (lPlace <> '') then
            begin
              aPara.AddSpan(TrimUTF8(lEvtIdent + lrDate + ' aus '), []);
              aPara.AddLink(lPlace,[],'P'+lPlaceRef);
            end
        else
          begin
            if (lEvtIdent = '') and (aEvent.Eventtype <> evt_Occupation) then
                lEvtIdent := EvtToNatur(aEvent.EventType);
            if aEvent.Date <> '' then
                lEvtIdent += lrDate;
            if (aEvent.Eventtype = evt_Occupation) then
                lEvtIdent += ' ' + aEvent.Data;
            if lPlace <> '' then
                lEvtIdent += ' in ';
            aPara.AddSpan(TrimUTF8(lEvtIdent), []);
            aPara.AddLink(lPlace,[],'P'+lPlaceRef);
            if (aEvent.Eventtype <> evt_Occupation) then
               aPara.AddSpan(TrimUTF8(' (' + aEvent.Data + ')'), []);
          end;

    end;

    procedure AppIndIndOccupation(const aInd: IGenIndividual;
    const aPara: TOdfParagraph);
    var
        lPlaceRef: string;
    begin
        if aInd.Occupation <> '' then
          begin
            aPara.AddSpan(TrimUTF8(', ' + aInd.Occupation), [fsItalic]);
            if trim(aInd.OccuPlace) <> '' then
                begin
                   aPara.AddSpan(' in ',[fsItalic]);
                   aPara.AddLink(Shortplace(aInd.OccuPlace, aEnt, lPlaceRef),[fsItalic],'P'+lPlaceRef);
                end;
          end;
    end;

    procedure AppendIndiShort(aPara: TOdfParagraph; aInd: IGenIndividual);

    begin
        aPara.AddSpan(TrimUTF8(aInd.Surname), [fsBold, fsItalic]);
        // AKA Surname
        aPara.AddSpan(TrimUTF8(', ' + aInd.GivenName), [fsItalic]);
        // AKA Givenname
        if aInd.Title <> '' then
            aPara.AddSpan(TrimUTF8(', ' + aInd.Title), [fsItalic]);
        if aInd.Religion <> '' then
            // Todo: Shorten Religion
            aPara.AddSpan(TrimUTF8(', ' + NormizeStr(aInd.Religion)), [fsItalic]);
        AppIndIndOccupation(aInd, aPara);
    end;

    procedure AppendIndi(aPara: TOdfParagraph; aSep: string; aInd: iGenIndividual);

    var
        lRef, lPlaceRef: string;
        FNeedComma: boolean;
        i: integer;
        lStr: TStringList;
    begin
        aPara.AddSpan(TrimUTF8(aSep), []);
        aPara.AddTab([]);
        // Surname
        aPara.AddSpan(TrimUTF8(aInd.Surname), [fsBold]);
        // Givenname
        aPara.AddSpan(TrimUTF8(', ' + aInd.GivenName), []);
        // Givenname

        if aInd.Title <> '' then
            aPara.AddSpan(TrimUTF8(', ' + aInd.Title), []);
        if aInd.Religion <> '' then
            aPara.AddSpan(TrimUTF8(', ' + NormizeStr(aInd.Religion)), []);
        // Parent References
        FNeedComma := False;
        if assigned(aind.ParentFamily) and IsFullFamily(aInd.ParentFamily) then
          begin
            aPara.AddSpan(TrimUTF8(', '), []);
            lRef := aInd.ParentFamily.FamilyRefID;
            aPara.AddLink('<' + lRef + '>', [fsItalic], 'F' + lRef);
            FNeedComma := True;
          end
        else
        if assigned(aind.Father) or assigned(aind.Mother) then
          begin
            aPara.AddSpan(TrimUTF8(', <'), [fsItalic]);
            if assigned(aInd.Father) then
                AppendIndiShort(aPara, aInd.Father);
            if assigned(aind.Father) and assigned(aind.mother) then
                aPara.AddSpan(TrimUTF8(' u. '), [fsItalic]);
            if assigned(aInd.Mother) then
                AppendIndiShort(aPara, aInd.Mother);
            aPara.AddSpan(TrimUTF8('>'), [fsItalic]);
            FNeedComma := True;
          end;
        // Spouse ref
        if aInd.FamilyCount > 1 then
          begin
            if not FNeedComma then;
            aPara.AddSpan(TrimUTF8(', '), []);
            FNeedComma := False;
            aPara.AddSpan(TrimUTF8('['), [fsItalic]);
            for i := 0 to aInd.FamilyCount - 1 do
                if aInd.Families[i] <> aEnt then
                  begin
                    if FNeedComma then
                        aPara.AddSpan(TrimUTF8(', '), [fsItalic]);
                    aPara.AddLink(trim(aInd.Families[i].FamilyRefID), [fsItalic],
                        'F' + aInd.Families[i].FamilyRefID);
                    FNeedComma := True;
                  end;
            aPara.AddSpan(TrimUTF8(']'), [fsItalic]);
          end;
        //Occupation
        AppIndIndOccupation(aind, aPara);
        FNeedComma := True;
        if aind.Residence <> '' then
            begin
              aPara.AddSpan(TrimUTF8(', lebt(e) in '),[]);
              aPara.AddLink(Shortplace(aInd.Residence, aEnt, lPlaceRef),[],'P'+lPlaceRef);
            end;

        // Vital Info
        FNeedComma := True;
        if assigned(aind.Birth) then
          begin
            if FNeedComma then
                aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Birth);
            FNeedComma := True;
          end;
        if assigned(aind.Baptism) then
          begin
            if FNeedComma then
                aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Baptism);
            FNeedComma := True;
          end;
        if assigned(aind.Death) then
          begin
            if FNeedComma then
                aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Death);
            FNeedComma := True;
          end;
        if assigned(aind.Burial) then
          begin
            if FNeedComma then
                aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Burial);
            FNeedComma := True;
          end;
        // Lebensphasen (
        if aind.EventCount > 0 then
          begin
            aPara.AddLineBreak;
            AppendText(aPara,'Lebensphasen von ');
            // Todo: Sortiere Lebensphasen-Events nach Datum
            aPara.AddSpan(TrimUTF8(aind.Name), [fsItalic]);
            AppendText(aPara,':');
            lStr := TStringList.Create;
              try
                for i := 0 to aind.EventCount - 1 do
                    lstr.AddObject(SortDate(aind.Events[i].Date), TObject(ptrint(aind.Events[i])));
                lStr.Sort;
                for i := 0 to lStr.Count - 1 do
                  begin
                    aPara.AddLineBreak;
                    AppendEvent(apara, IGenEvent(ptrint(lStr.Objects[i])));
                  end;
              finally
                FreeAndNil(lStr);
              end;
          end;
        // Ref
        if aind.IndRefID <> '' then
          begin
            aPara.AddLineBreak;
            AppendText(aPara,'PN = ');
            aPara.AddSpan(TrimUTF8(aind.IndRefID), [fsItalic]);
          end;
    end;

    procedure AppendIndiAsChildShort(aPara: TOdfParagraph; aFamName: string;
        aInd: iGenIndividual);

    var
        j: integer;
    begin
        aPara.AddTab([]);
        if aind.Surname <> aFamname then
          begin
            aPara.AddSpan(TrimUTF8(aInd.Surname), [fsBold]);
            // AKA Surname
            aPara.AddSpan(TrimUTF8(', '), []);
          end;
        // AKA Givenname
        aPara.AddSpan(TrimUTF8(aInd.GivenName), []);
        if aInd.Title <> '' then
            aPara.AddSpan(TrimUTF8(', ' + aInd.Title), []);
        aPara.AddTab([]);
        if aInd.Religion <> '' then
            aPara.AddSpan(TrimUTF8(', ' + NormizeStr(aInd.Religion)), []);

        // Ref
        aPara.AddSpan(TrimUTF8('['), [fsItalic]);
        for j := 0 to aInd.FamilyCount - 1 do
          begin
            if J > 0 then
                aPara.AddSpan(TrimUTF8(', '), [fsItalic]);
            aPara.AddLink(aInd.Families[j].FamilyRefID, [fsItalic],
                'F' + aInd.Families[j].FamilyRefID);
          end;
        // Vital Info
        aPara.AddSpan(TrimUTF8(']'), [fsItalic]);

        if assigned(aind.Birth) then
          begin
            aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Birth);
          end
        else if assigned(aind.Baptism) then
          begin
            aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Baptism);

          end;
        if assigned(aind.Death) then
          begin
            aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Death);
          end
        else if assigned(aind.Burial) then
          begin
            aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Burial);
          end;
    end;

    procedure AppendIndiAsChild(aPara: TOdfParagraph; aFamName: string;
        aInd: iGenIndividual);

    var
        lPlaceRef: string;
        FNeedComma: boolean;
    begin
        aPara.AddTab([]);
        if aind.Surname <> aFamname then
          begin
            aPara.AddSpan(TrimUTF8(aInd.Surname), [fsBold]);
            // AKA Surname
            aPara.AddSpan(TrimUTF8(', '), []);
          end;
        // AKA Givenname
        aPara.AddSpan(TrimUTF8(aInd.GivenName), []);
        if aInd.Title <> '' then
            aPara.AddSpan(TrimUTF8(', ' + aInd.Title), []);
        aPara.AddTab([]);
        FNeedComma := False;
        if aInd.Religion <> '' then
          begin
            aPara.AddSpan(TrimUTF8(', ' + NormizeStr(aInd.Religion)), []);
            FNeedComma := True;
          end;
        // Vital Info
        if assigned(aind.Birth) then
          begin
            if FNeedComma then
                aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Birth);
            FNeedComma := True;
          end;
        if assigned(aind.Baptism) then
          begin
            if FNeedComma then
                aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Baptism);
            FNeedComma := True;
          end;
        if assigned(aind.Death) then
          begin
            if FNeedComma then
                aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Death);
            FNeedComma := True;
          end;
        if assigned(aind.Burial) then
          begin
            if FNeedComma then
                aPara.AddSpan(TrimUTF8(', '), []);
            AppendEvent(aPara, aind.Burial);
            FNeedComma := True;
          end;
        //Occupation
        AppIndIndOccupation(aind, aPara);
        if aind.Residence <> '' then
            aPara.AddSpan(TrimUTF8(', lebte in ' + Shortplace(aInd.Residence, aEnt, lPlaceRef)), []);
    end;

    procedure AppendChildren(aDocument: TOdfSection;aParaHdrStyle, aParaStyle, aSep: string;
        aFam: IGenFamily);

    var
        i: integer;
        lStr: TStringList;
        lChild: IGenIndividual;
    begin
        lPara := aDocument.AddParagraph(aParaHdrStyle);
        if aFam.ChildCount = 1 then
            AppendText(lpara,asep + ' 1 Kind:')
        else
            AppendText(lPara,aSep + ' ' + IntToStr(aFam.ChildCount) + ' Kinder:');
        lStr := TStringList.Create;
          try
            for i := 0 to aFam.ChildCount - 1 do
                lStr.AddObject(SortDate(aFam.Children[i].BirthDate),
                    TObject(ptrint(aFam.Children[i])));
            lStr.Sort;
            lStr.Sorted := True;
            for i := 0 to lStr.Count - 1 do
              begin
                lPara := aDocument.AddParagraph(aParaStyle);
                AppendText(lpara,IntToStr(i + 1) + ')');
                lChild := IGenIndividual(ptrint(lstr.Objects[i]));
                if lChild.FamilyCount > 0 then
                    AppendIndiAsChildShort(lPara, afam.FamilyName, lChild)
                else
                    AppendIndiAsChild(lPara, afam.FamilyName, lChild);
              end;
          finally
            FreeAndNil(lStr);
          end;
    end;

begin
    // Todo: Language-support
    if not assigned(Fsection) then
      begin
        AppendText(FDocument.AddHeadline(2),rsFamilienverzeichnis);
        FSection := FDocument.AddSection('FamilyList', 'FamilyList');
      end;
    if aEnt.GetObject is  IGenFamily then
      begin
        afam := aEnt.GetObject as IGenFamily;
        lSortedFname := GetClusterFamilyEntry(SortName(afam.FamilyName));
        lUpperFam := uppercase(lSortedFname)+' ';
        if lUpperFam <> FlastFamName then
          begin
            if (copy(lUpperFam, 1, 1) <> FLastIndex) and (lUpperFam[1] in UpperCharset) then
               begin
                 AppendText(FSection.AddHeadline(3),copy(lUpperFam, 1, 1));
                 FLastIndex := copy(lUpperFam, 1, 1)
               end;
            // Cluster-Main-Name

            AppendText(FSection.AddHeadline(4),lSortedFname);
            if GetFamClusterCount(lSortedFname) >= 2 then
              AppendText(FSection.AddParagraph('Standard'),'('+GetFamClusterList(lSortedFname)+')');
            FlastFamName := lUpperFam;
          end;
        lPara := FSection.AddParagraph(csFamHeader);
        lID := aFam.FamilyRefID;
        lPara.AddBookmark(lID, [fsBold, fsUnderline], 'F' + lID);
        lpara.AddTab([]);
        if assigned(aFam.Marriage) then
            AppendEvent(lPara, aFam.Marriage)
        else
          begin
            lPara.AddSpan(trim(EventDateToReadable(GetFamilyDate(aFam))), []);
          end;
        if assigned(aFam.Husband) then
            AppendIndi(FSection.AddParagraph('FamIndividual'), '●', aFam.Husband);
        if assigned(aFam.Wife) then
            AppendIndi(FSection.AddParagraph('FamIndividual'), '●', aFam.Wife);
        if aFam.ChildCount > 0 then
            AppendChildren(FSection, 'FamChildHeader', 'FamChildren', '●', aFam);
      end
    else    if aEnt.GetObject is IGenIndividual then
      begin
        lPara := FSection.AddParagraph(csFamHeader);
        lID := inttostr(FFamilyList.IndexOfObject(aEnt.GetObject)+1);
        lPara.AddBookmark(lID, [fsBold, fsUnderline], 'F' + lID);
        lpara.AddTab([]);
        AppendIndi(FSection.AddParagraph('FamIndividual'), '', aEnt.GetObject as IGenIndividual);
      end;
//    FSection.AddParagraph('Standard');
end;

procedure TGenDocumentWriter.WriteIndIndex;
var
    lSection: TOdfSection;
    lSortedFname, llastFamName, lRef, lSurname: string;
    lCut, lCut2: TStringArray;
    lInd: IGenIndividual;
    lpara: TOdfParagraph;
    lNeedComma: boolean;
    i, j: integer;
begin
    AppendText(FDocument.AddHeadline(2), rsPersonenverz);
    lSection := FDocument.AddSection('IndiList', 'List3');
    llastFamName := '';
    for i := 0 to FIndiList.Count - 1 do
      begin
        lCut := FIndiList[i].Split(',');
        lInd := IGenIndividual(ptrint(FIndiList.Objects[i]));
        lSortedFname := GetClusterFamilyEntry(uppercase(lCut[0])+' ');
        if lSortedFname <> llastFamName then
          begin
            if (copy(lSortedFname, 1, 1) <> copy(llastFamName, 1, 1)) and (lSortedFname[1] in UpperCharset) then
              begin
                 AppendText(lSection.AddHeadline(3),copy(lSortedFname, 1, 1))
              end;
            lSurname := trim(lInd.Surname);
            if (lsurname <> '') and (lsurname[1] = '(') then
                lSurname := copy(lsurname, 2, length(lsurname) - 2);
            if (lsurname <> '') and (lsurname[1] = '<') then
                lSurname := copy(lsurname, 2, length(lsurname) - 2);
            AppendText(lSection.AddHeadline(6),lSurname);
            if GetFamClusterCount(lSortedFname) >= 2 then
              AppendText(lSection.AddParagraph('Standard'),'('+GetFamClusterList(lSortedFname)+')');
            llastFamName := lSortedFname;
          end;

        lpara := lSection.AddParagraph(csListEntry);
        if lSurname <> trim(lInd.Surname) then
            lpara.AddSpan(TrimUTF8('^'), []);
        if lCut[1].Contains('(') then
          begin
             lCut2 := lCut[1].Split('(');
             lpara.AddSpan(TrimUTF8(lCut2[0]), [fsBold]);
             lpara.AddTab([]);
             lpara.AddSpan(' ('+TrimUTF8(lCut2[1]), []);
          end
        else
           lpara.AddSpan(TrimUTF8(lCut[1]), [fsBold]);
        lpara.AddTab([]);
        lpara.AddSpan(' ', []);
        lNeedComma := False;
        if assigned(lInd.ParentFamily) then
          begin
            lRef := trim(lInd.ParentFamily.FamilyRefID);
            lPara.AddLink('<' + lRef + '>', [fsItalic], 'F' + lRef);
          end
        else if lInd.FamilyCount =0 then
          begin
            lPara.AddSpan(TrimUTF8('['), [fsItalic]);
                lRef := inttostr(FFamilyList.IndexOfObject(lind.GetObject)+1);
                lPara.AddLink(lRef, [fsItalic],
                    'F' + lRef);
            lPara.AddSpan(TrimUTF8(']'), [fsItalic]);
          end;
        // Spouse ref
        if lInd.FamilyCount > 0 then
          begin
            lNeedComma := False;
            lPara.AddSpan(TrimUTF8('['), [fsItalic]);
            for j := 0 to lInd.FamilyCount - 1 do
              begin
                if lNeedComma then
                    lPara.AddSpan(TrimUTF8(', '), [fsItalic]);
                lRef := trim(lInd.Families[j].FamilyRefID);
                lPara.AddLink(lRef, [fsItalic],
                    'F' + lRef);
                lNeedComma := True;
              end;
            lPara.AddSpan(TrimUTF8(']'), [fsItalic]);
          end;
      end;
end;

procedure TGenDocumentWriter.WriteOccIndex;
var
    lSection: TOdfSection;
    lSortedOccu, llastOccu, lRef, lOccupation: string;
    lInd: IGenIndividual;
    lpara: TOdfParagraph;
    lNeedComma: boolean;
    i, j: integer;
    llist: TList;
    lObj: Pointer;

begin
    AppendText(FDocument.AddHeadline(2), rsBerufsverzei);
    lSection := FDocument.AddSection('IndiList', 'List3');
    llastOccu := '';
    for i := 0 to FOccuList.Count - 1 do
      begin
        lSortedOccu := uppercase(FOccuList[i])+' ';
        llist := TList(FOccuList.Objects[i]);
        if (copy(lSortedOccu, 1, 1) <> copy(llastOccu, 1, 1)) and (lSortedOccu[1] in UpperCharset) then
            AppendText(lSection.AddHeadline(3),copy(lSortedOccu, 1, 1));
        lOccupation := trim(FOccuList[i]);
        llastOccu := lSortedOccu;
        lpara := lSection.AddParagraph(csListEntry);
        lpara.AddSpan(TrimUTF8(lOccupation), []);
        lpara.AddTab([]);
        lNeedComma := False;
        for lObj in llist do
          begin
            // Split big Lists by Place
            if lNeedComma then
                lPara.AddSpan(TrimUTF8(', '), [fsItalic]);
            lNeedComma := False;
            lInd := IGenIndividual(lObj);
            if assigned(lInd.ParentFamily) and (lInd.FamilyCount = 0) then
              begin
                lRef := trim(lInd.ParentFamily.FamilyRefID);
                lPara.AddLink('<' + lRef + '>', [fsItalic], 'F' + lRef);
                lNeedComma := True;
              end
            else
            // Spouse ref
            if lInd.FamilyCount > 0 then
              begin
                if lNeedComma then
                    lPara.AddSpan(TrimUTF8(', '), [fsItalic]);
                lNeedComma := False;
                lPara.AddSpan(TrimUTF8('['), [fsItalic]);
                for j := 0 to lInd.FamilyCount - 1 do
                  begin
                    if lNeedComma then
                        lPara.AddSpan(TrimUTF8(', '), [fsItalic]);
                    lRef := trim(lInd.Families[j].FamilyRefID);
                    lPara.AddLink(lRef, [fsItalic],
                        'F' + lRef);
                    lNeedComma := True;
                  end;
                lPara.AddSpan(TrimUTF8(']'), [fsItalic]);
              end;
          end;
      end;
end;

procedure TGenDocumentWriter.WritePropIndex;


  Procedure WriteIndEntry(lpara:TOdfParagraph; aind:IGenIndividual);

  var
    idx, j: Integer;
    lCut: TStringArray;
    lNeedComma: Boolean;
    lRef: String;
  begin
    idx := FIndiList.IndexOfObject(TObject(ptrint(aind)));
    if idx>=0 then
       begin
         lCut := FIndiList[idx].Split(',');
         lpara.AddSpan(TrimUTF8(aInd.Surname), [fsBold]);
         lpara.AddTab([]);
         lpara.AddSpan(TrimUTF8(lCut[1]), []);
         lpara.AddTab([]);
         lpara.AddSpan(' ', []);
         lNeedComma := False;
         if assigned(aInd.ParentFamily) then
           begin
             lRef := trim(aInd.ParentFamily.FamilyRefID);
             lPara.AddLink('<' + lRef + '>', [fsItalic], 'F' + lRef);
           end
         else if aInd.FamilyCount =0 then
           begin
             lPara.AddSpan(TrimUTF8('['), [fsItalic]);
                 lRef := inttostr(FFamilyList.IndexOfObject(aind.GetObject)+1);
                 lPara.AddLink(lRef, [fsItalic],
                     'F' + lRef);
             lPara.AddSpan(TrimUTF8(']'), [fsItalic]);
           end;
         // Spouse ref
         if aInd.FamilyCount > 0 then
           begin
             lNeedComma := False;
             lPara.AddSpan(TrimUTF8('['), [fsItalic]);
             for j := 0 to aInd.FamilyCount - 1 do
               begin
                 if lNeedComma then
                     lPara.AddSpan(TrimUTF8(', '), [fsItalic]);
                 lRef := trim(aInd.Families[j].FamilyRefID);
                 lPara.AddLink(lRef, [fsItalic],
                     'F' + lRef);
                 lNeedComma := True;
               end;
             lPara.AddSpan(TrimUTF8(']'), [fsItalic]);
           end;
       end;
  end;

var
    lSection: TOdfSection;
    lProperty: string;
    lInd: IGenIndividual;
    lpara: TOdfParagraph;
    i: integer;
    llist: TList;
    lObj: Pointer;

begin
    AppendText(FDocument.AddHeadline(2), rsEigentumsverzei);
    lSection := FDocument.AddSection('IndiList', 'List3');
    for i := 0 to FPropList.Count - 1 do
      begin
        llist := TList(FPropList.Objects[i]);
        lProperty := trim(FPropList[i]);
        AppendText(lSection.AddHeadline(6),TrimUTF8(lProperty));
        for lObj in llist do
          begin
            lpara := lSection.AddParagraph(csListEntry);
            lInd := IGenIndividual(lObj);
            WriteIndEntry(lpara,lInd);
          end;
      end;
end;

procedure TGenDocumentWriter.WritePlaceIndex;
   procedure SplitPLace(const aPLace:String;out aShName,aRest,aRef:string);

   var
     lpos: SizeInt;
   begin
     lpos:= aPlace.IndexOf(',');
     aShName:=TrimUTF8(trim(copy(aPlace,1,lPos)));
     aRest := copy(aPlace,lpos+2);
     aRef := TrimAlphaNum(aShName)+IntToStr(aRest.GetHashCode);
   end;

var
    lSection: TOdfSection;
    lRef, lSortedplace, lSingleUTFChar, lShortName, lRest,
      lLastChar: string;
    lpara: TOdfParagraph;
    lList: TList;
    lObj: Pointer;
    i: integer;
    lNeedComma: boolean;

begin
    AppendText(FDocument.AddHeadline(2), rsOrtsverzeich);
    lSection := FDocument.AddSection('PlaceList', 'FamilyList');
    lLastChar := '#';
    for i := 0 to FPlaceList.Count - 1 do
      begin
        lSortedplace := uppercase(FPlaceList[i])+' ';
        lSingleUTFChar := GetUtf8SingleChar(lSortedplace,1);
        if (lSingleUTFChar <> lLastChar) and (lSingleUTFChar[1] in AlphaNum) then
           begin
             AppendText(lSection.AddHeadline(3),lSingleUTFChar);
             lLastChar := lSingleUTFChar;
           end;
        lpara := lSection.AddParagraph(csListEntry);
        if FPlaceList[i].Contains(',') then
          begin
            SplitPLace(FPlaceList[i],lShortName,lRest,lRef);
            lpara.AddBookmark(lShortName, [fsBold],'P'+lRef);
            lpara.AddTab([]);
            lpara.AddSpan(TrimUTF8(lRest), []);
          end
        else
          lpara.AddSpan(TrimUTF8(FPlaceList[i]), [fsBold]);
        lpara.AddTab([]);
        lPara.AddSpan(TrimUTF8('['), [fsItalic]);
        lNeedComma := False;
        lList := TList(FPlaceList.Objects[i]);
        for lObj in llist do
          begin
            // Split big Lists by Names
            if lNeedComma then
                lPara.AddSpan(TrimUTF8(', '), [fsItalic]);
            lRef := trim(IGenFamily(lObj).FamilyRefID);
            lPara.AddLink(lRef, [fsItalic],
                'F' + lRef);
            lNeedComma := True;
          end;
        lPara.AddSpan(TrimUTF8(']'), [fsItalic]);
      end;
end;

procedure TGenDocumentWriter.WritePlace2Index;
var
    lSection: TOdfSection;
    lRef, lNextPlace: string;
    lSortedplace, llastPlace: TStringArray;
    lpara: TOdfParagraph;
    lList: TList;
    lObj: Pointer;
    i, j: integer;
    lNeedComma: boolean;

begin
    FDocument.AddHeadline(2).AppendText(rsOrtsverzeich2);
    lSection := FDocument.AddSection('Place2List', 'List3');
    llastPlace := nil;
    for i := 0 to FPlace2List.Count - 1 do
      begin
        lSortedplace := FPlace2List[i].split(',');
        lNextPlace := '';
        if i < FPlace2List.Count - 1 then
            lNextPlace := FPlace2List[i + 1];
        for j := 0 to high(lSortedplace) - 2 do
            if ((high(llastPlace) > j) and (llastPlace[j] = lSortedplace[j])) or
                (trim(lSortedplace[j]) = '') then
                Continue
            else
                AppendText(lSection.AddHeadline(3 + j),StringOfChar(' ',j*2)+trim(lSortedplace[j]));
        llastPlace := lSortedplace;
        if FPlace2List[i] = copy(lnextplace, 1, Length(FPlace2List[i])) then
            AppendText(lSection.AddHeadline(3 + high(lSortedplace) - 1),
                StringOfChar(' ',(high(lSortedplace) - 1)*2)+trim(lSortedplace[high(lSortedplace) - 1]));
        if (high(lSortedplace)>1)
          and (not lNextPlace.Contains(',') or (not lNextPlace.Contains(lSortedplace[high(lSortedplace) - 2]))) then
           lpara := lSection.AddParagraph(csListEntryBreak)
        else
           lpara := lSection.AddParagraph(csListEntry);
        if FPlace2List[i] <> copy(lnextplace, 1, Length(FPlace2List[i])) then
          lpara.AddSpan(trim(lSortedplace[high(lSortedplace) - 1]), []);
        lpara.AddTab([]);
        lPara.AddSpan(TrimUTF8('['), [fsItalic]);
        lNeedComma := False;
        lList := TList(FPlace2List.Objects[i]);
        for lObj in llist do
          begin
            // Split big Lists by Names
            if lNeedComma then
                lPara.AddSpan(TrimUTF8(', '), [fsItalic]);
            lRef := trim(IGenFamily(lObj).FamilyRefID);
            lPara.AddLink(lRef, [fsItalic],
                'F' + lRef);
            lNeedComma := True;
          end;
        lPara.AddSpan(TrimUTF8(']'), [fsItalic]);
      end;
end;

procedure TGenDocumentWriter.BuildFamCluster(aFam: iGenFamily);

  procedure AppendClusterInd(FamName,ParName:String);

  var
           lplIx: integer;
           lList: TStringList;

       begin
           lplIx := FFamilyClusterList.IndexOf(FamName);
           if lplIx < 0 then
             begin
               lList := TStringList.Create;
               lList.AddObject('',TObject(ptrInt(1)));
               lList.Add(Parname);
               FFamilyClusterList.AddObject(FamName, TObject(lList));
             end
           else
             begin
               lList := TstringList(FFamilyClusterList.Objects[lplIx]);
               lList.Objects[0] := tObject(PtrInt(lList.Objects [0])+1);
               if lList.IndexOf(ParName) < 0 then
                 lList.Add(ParName);
             end;
         lplIx := FFamilyClusterList.IndexOf(ParName);
           if lplIx < 0 then
             begin
               lList := TstringList.Create;
               lList.AddObject('',tobject(ptrint(0)));
               lList.Add(FamName);
               FFamilyClusterList.AddObject(ParName, TObject(lList));
             end
           else
             begin
               lList := TStringList(FFamilyClusterList.Objects[lplIx]);
               if lList.IndexOf(FamName) < 0 then
                 lList.Add(FamName);
             end;
  end;

var
  i: Integer;
  sn, hn, wn: String;
begin
    sn := Sortname(afam.FamilyName);
    if assigned(afam.Husband) and assigned(afam.Wife) then
      begin
        hn := Sortname(afam.Husband.Surname);
        wn := Sortname(afam.Wife.Surname);
        if sn = hn then
          AppendClusterInd(sn, sortname(afam.Husband.Surname))
        else if sn = wn then
          AppendClusterInd(sn, sortname(afam.Wife.Surname))
        else if assigned(afam.GetMarriage) then
          AppendClusterInd(sn, sortname(afam.Husband.Surname))
        // Todo:
      end
    else if assigned(afam.Husband) then
      AppendClusterInd(sn, sortname(afam.Husband.Surname))
    else if assigned(afam.Wife) then
      AppendClusterInd(sn,sortname(afam.Wife.Surname));
    for i := 0 to aFam.ChildCount - 1 do
        AppendClusterInd(sortname(afam.Children[i].Surname),sn);
end;


function TGenDocumentWriter.YearOf(aDate: string): string;

begin
    exit(copy(aDate, aDate.LastIndexOfAny([' ', '.']) + 2));
end;

function TGenDocumentWriter.SortDate(aDate: string): string;
var
    lDate: TStringArray;
    i: integer;
begin
    lDate := aDate.Split([' ', '.']);
    Result := '';
    for i := high(lDate) downto 0 do
        Result += lDate[i] + ' ';
end;

function TGenDocumentWriter.SortName(aName: string): string;
var
    lName: TStringArray;
    i: integer;
begin
    lName := trim(aName).Split([' ']);
    if (high(lName) <= 0) or (lName[high(lName)][1] in ['(', '<', '"']) then
        exit(aName);
    Result := '';
    for i := 0 to high(lName) do
        if (lName[i] = 'verh.') or (lname[i] = 'verw.') or (lname[i] = 'gesch.') then
          begin
            setlength(lName, i);
            break;
          end;
    for i := high(lName) downto 0 do
        Result += lName[i] + ' ';
    result := aName.Replace(',','_');
end;

function TGenDocumentWriter.LifeSpan(aInd: IGenIndividual): string;

begin
    Result := '(';
    Result += YearOf(aind.BirthDate);
    Result += '-';
    Result += YearOf(aind.DeathDate);
    Result += ')';
end;

procedure TGenDocumentWriter.AppendInd(aInd: IGenIndividual);

var
    lSurname: string;
begin
    if not assigned(aind) then
        exit;
    AppendIndOcc(aind);
    AppendIndRel(aind);
    AppendIndProp(aind);
    if FIndiList.IndexOfObject(TObject(ptrint(aInd))) = -1 then
      begin
        lSurname := trim(aInd.Surname);
        if (lsurname <> '') and (lsurname[1] = '(') then
            lSurname := copy(lsurname, 2, length(lsurname) - 2);
        if (lsurname <> '') and (lsurname[1] = '<') then
            lSurname := copy(lsurname, 2, length(lsurname) - 2);
        FIndiList.AddObject(SortName(lSurname) + ', ' + aInd.GivenName +
            ' ' + LifeSpan(aInd), TObject(ptrint(aInd)));

      end;
end;

procedure TGenDocumentWriter.AppendIndOcc(aInd: IGenIndividual);

    procedure AppendSingleOccupation(aOccupation: string);
    var
        lplIx: integer;
        lList: TList;
    begin
        lplIx := FOccuList.IndexOf(aOccupation);
        if lplIx < 0 then
          begin
            lList := TList.Create;
            lList.Add(aInd);
            FOccuList.AddObject(aOccupation, TObject(lList));
          end
        else
          begin
            lList := TList(FOccuList.Objects[lplIx]);
            if lList.IndexOf(aInd) >= 0 then
                exit; //!!
            lList.Add(aInd);
          end;
    end;

var
    lOccupation: string;
    lOccupations: TStringArray;
    i: integer;

const Splitter:array[0..3] of string = (',',' und',' u.','&');
begin
    if not assigned(aind) or (trim(aind.Occupation) = '') then
        exit;

    for i := 0 to pred(aInd.EventCount) do
        if aind.Events[i].EventType = evt_Occupation then
          begin
            lOccupations := aind.Events[i].Data.Split(Splitter);
            for lOccupation in lOccupations do
                AppendSingleOccupation(trim(lOccupation));
          end;
end;

procedure TGenDocumentWriter.AppendIndRel(aInd: IGenIndividual);

    procedure AppendSingleReligion(aReligion: string);
    var
        lplIx: integer;
        lList: TList;
    begin
        lplIx := FReligList.IndexOf(aReligion);
        if lplIx < 0 then
          begin
            lList := TList.Create;
            lList.Add(aInd);
            FReligList.AddObject(aReligion, TObject(lList));
          end
        else
          begin
            lList := TList(FReligList.Objects[lplIx]);
            if lList.IndexOf(aInd) >= 0 then
                exit; //!!
            lList.Add(aInd);
          end;
    end;

var
    i: integer;

begin
    if not assigned(aind) or (trim(aind.Religion) = '') then
        exit;

    for i := 0 to pred(aInd.EventCount) do
        if aind.Events[i].EventType = evt_Religion then
          begin
             AppendSingleReligion(trim(aind.Events[i].Data));
          end;
end;

procedure TGenDocumentWriter.AppendIndProp(aInd: IGenIndividual);

    procedure AppendSingleProp(aProperty: string);
    var
        lplIx: integer;
        lList: TList;
    begin
        lplIx := FPropList.IndexOf(aProperty);
        if lplIx < 0 then
          begin
            lList := TList.Create;
            lList.Add(aInd);
            FPropList.AddObject(aProperty, TObject(lList));
          end
        else
          begin
            lList := TList(FPropList.Objects[lplIx]);
            if lList.IndexOf(aInd) >= 0 then
                exit; //!!
            lList.Add(aInd);
          end;
    end;

var
    i: integer;

begin
    if not assigned(aind) then
        exit;

    for i := 0 to pred(aInd.EventCount) do
        if aind.Events[i].EventType = evt_Property then
          begin
             AppendSingleProp(trim(aind.Events[i].Data));
          end;
end;

function TGenDocumentWriter.GetClusterFamilyEntry(FEntry: String): String;
var
  lFam: TStringArray;
  lList: TStringList;
  lCnt,lCnt2: PtrInt;
  lidx,lidx2, i: Integer;
begin
  lFam := Fentry.Split(',');
  lidx:=FFamilyClusterList.indexof(lFam[0]);
  if lidx>=0 then
     begin
       // Durchsuche Clusterliste nach höchstem Eintrag
       lList := TStringList(FFamilyClusterList.Objects[lidx]);
       lCnt := ptrint(lList.Objects[0]);
       for i := 1 to llist.Count-1 do
       if lList[i]<>lFam[0] then
         begin
            lidx2:=FFamilyClusterList.indexof(lList[i]);
            lCnt2:=PtrInt(TstringList(FFamilyClusterList.Objects[lidx2]).Objects[0]);
            if (lCnt<lCnt2) or ((lCnt=lCnt2) and (lList[i]<lFam[0])) then
               begin
                 lCnt := lCnt2;
                 lFam[0]:=lList[i];
               end;
         end;
     end;
  result := string.Join(',',lFam);
end;

function TGenDocumentWriter.GetFamClusterList(FEntry: String): String;
var
  lidx: Integer;
  lList: TStringList;
begin
  lidx:=FFamilyClusterList.indexof(sortname(FEntry));
  result := '';
  if lidx>=0 then
     begin
       // Durchsuche Clusterliste nach höchstem Eintrag
       lList := TStringList(FFamilyClusterList.Objects[lidx]);
       result := lList.text.Replace(LineEnding,', ');
       result := copy(result,3,length(result)-4);
     end;
end;

function TGenDocumentWriter.GetFamClusterCount(FEntry: String): integer;
var
  lidx: Integer;
begin
  lidx:=FFamilyClusterList.indexof(sortname(FEntry));
  result := 1;
  if lidx>=0 then
       result := TStringList(FFamilyClusterList.Objects[lidx]).Count-1;
end;

function TGenDocumentWriter.NormizeStr(aStr: string): string;
begin
    Result := astr.Replace(#$FC, 'ü');
    Result := Result.Replace(#$DF, 'ß');
end;

procedure TGenDocumentWriter.AppendFamily(aFam: iGenFamily);
var
    i: integer;
    lFamDate: string;

begin
    if IsFullFamily(aFam) then
       begin
    lFamDate := GetFamilyDate(aFam);
    BuildFamCluster(aFam);
    FFamilyList.AddObject( SortName(aFam.FamilyName) + ', ' +
        SortDate(lFamDate), TObject(ptrint(aFam)));
    AppendInd(afam.Husband);
    AppendInd(afam.Wife);
    for i := 0 to aFam.ChildCount - 1 do
        AppendInd(afam.Children[i]);
       end;
end;

procedure TGenDocumentWriter.AppendSingleInd(aInd: IGenIndividual);
var
  lFam: TVirtFamily;
begin
   lFam := TVirtFamily.Create(aInd);
   Setlength(FVirtFamilies,high(FVirtFamilies)+2);
   FVirtFamilies[high(FVirtFamilies)] := lfam;
   AppendFamily(lFam);
end;

function TGenDocumentWriter.EventDateToReadable(aDate: string): string;
var
    lDatepart: TStringArray;
    i: integer;
begin
    aDate := NormizeStr(aDate);
    lDatepart := aDate.Split(' ');
    if length(ldatepart) <= 1 then
        exit(aDate);
    for i := 0 to high(CGedDateModif) div 2 do
        if UpperCase(lDatepart[0]) = CGedDateModif[i * 2 + 1] then
          begin
            lDatepart[0] := CGedDateModif[i * 2] + ' ';
            break;
          end;
    for i := 0 to high(CMonthNames) div 2 do
        if UpperCase(lDatepart[High(lDatepart) - 1]) = CMonthNames[i * 2] then
          begin
            lDatepart[high(lDatepart) - 1] := CMonthNames[i * 2 + 1];
            if (high(lDatepart) - 2 >= 0) and
                (lDatepart[high(lDatepart) - 2][1] in ['0'..'9']) then
                lDatepart[high(lDatepart) - 2] += '.';
            break;
          end;
    Result := ''.Join('', lDatepart);
end;

procedure TGenDocumentWriter.SortAndRenumberFamiliies;

var
    i: integer;
begin
    TStringList(FFamilyClusterList).Sorted := True;
    for i := 0 to FFamilyList.Count - 1 do
        FFamilyList[i] := GetClusterFamilyEntry(FFamilyList[i]);
    TStringList(FFamilyList).Sorted := True;
    TStringList(FIndiList).Sorted := True;
    TStringList(FPlaceList).Sorted := True;
    TStringList(FOccuList).Sorted := True;
    TStringList(FPropList).Sorted := True;
    TStringList(FPlace2List).Sorted := True;
    for i := 0 to FFamilyList.Count - 1 do
        IGenFamily(ptrint(FFamilyList.Objects[i])).FamilyRefID := IntToStr(i + 1);

    FlastFamName := '-';
    FLastIndex  := '-';
    for i := 0 to FFamilyList.Count - 1 do
        WriteFamily(IGenFamily(ptrint(FFamilyList.Objects[i])));
end;

procedure TGenDocumentWriter.AppendText(lCont: TOdfContent; aText: String);

begin
   lCont.AppendText(TrimUTF8(aText));
end;

procedure TGenDocumentWriter.AppendMarkupText(lCont: TOdfContent; aText: String
  );

var
  lSetting: TFontstyles = [];
  lText: String;
  lpp: SizeInt;
begin
  lText:=aText;
  while lText<>'' do
    begin
      lpp := ltext.IndexOfAny('_#|');
      if lpp >=0 then
        begin
          lCont.AddSpan(copy(ltext,1,lpp),lSetting);
          case ltext[lpp+1] of
            '_' : if fsUnderline in lsetting then
                lsetting -= [fsUnderline]
              else
                lsetting += [fsUnderline];
            '#' : if fsbold in lsetting then
                  lsetting -=  [fsbold]
                  else
                  lsetting +=  [fsbold];
            '|' : if fsItalic in lsetting then
              lsetting-=  [fsItalic] else lsetting+=  [fsItalic];
          end;
          lText := copy(ltext,lpp+2);
        end
      else
        begin
          lCont.AddSpan(ltext,lSetting);
          lText := '';
        end;
    end;
end;

procedure TGenDocumentWriter.SaveToSingleXml(const AFilename: string);
begin
    XmlWriterProc := @MyWriteXmlToFile;
    Document.SaveToSingleXml(AFilename);
end;

procedure TGenDocumentWriter.SaveToZipFile(const AFilename: string);
begin
    XmlWriterProc := @MyWriteXmlToFile;
    Document.SaveToZipFile(AFilename);
end;

procedure TGenDocumentWriter.FamClusterList_SaveToFile(AFilename: string);
var
  lsl, lStr: TStringList;
  ls: String;
  i: Integer;
begin
  lStr := TStringlist.Create();
  try
  for i := 0 to FFamilyClusterList.Count-1 do
    begin
       ls:= FFamilyClusterList[i];
       if assigned(FFamilyClusterList.Objects[i]) then
         begin
           lsl := Tstringlist(FFamilyClusterList.Objects[i]);
           ls+=', '+inttostr(ptrint(lsl.Objects[0]))+', ('+lsl.text.Replace(LineEnding,', ')+')';
         end;
       lstr.Add(ls);
    end;
  lStr.saveToFile(AFilename);
  finally
    freeandnil(lStr);
  end;
end;

procedure TGenDocumentWriter.PrepareDocument;
var
    lStyle, lMStyle: TOdfStyleStyle;
    lSpp, lssp, lscl, lHeader, lField, lp0: TOdfElement;
    i: integer;
    lPara: TOdfParagraph;
begin
  FDocument.Language:='de';
  FDocument.Country:='DE';
   FDocument.Clear;
   FDocument.MasterPageProp.SetAttributes([oatFoPageWidth,oatFoPageHeight,oatStylePrintOrientation,
       oatFoMarginTop,oatFoMarginBottom,oatFoMarginLeft,oatFoMarginRight],
       ['21cm','29.7cm','portrait','1.5cm','1.5cm','1cm','1cm']);  ;

   FDocument.AddFontFace('BlackLetter686 BT','''BlackLetter686 BT''','script','variable');
//    lStyle := FDocument.MasterStyles.FindNode();

    lStyle := FDocument.AddAutomaticStyle(CStCenter, sfvParagraph);
    lstyle.OdfStyleParentStyleName := 'Standard';
    lstyle.OdfStyleClass := 'text';
    lStyle.AppendOdfElement(oetStyleParagraphProperties, oatFoTextAlign, 'center');

// Titel
    lStyle := FDocument.AddStyle(csTitle, sfvParagraph);
    lstyle.OdfStyleParentStyleName := 'Heading';
    lstyle.OdfStyleClass := 'chapter';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
        oatStyleAutoTextIndent,oatFoMarginTop,oatFoMarginBottom,oatFoTextAlign],
        ['1cm', '1cm', '0cm', 'false', '4cm', '3cm', 'center']);
    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties);
    lSpp.SetAttributes([oatFoFontSize,oatStyleFontName,oatFoFontFamily],
        ['44pt', 'Blackletter686 BT','''Blackletter686 BT''']);

    // SubTitel
      lStyle := FDocument.AddStyle(csSubTitle, sfvParagraph);
      lstyle.OdfStyleParentStyleName := 'Heading';
      lstyle.OdfStyleClass := 'chapter';
      lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
      lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
          oatStyleAutoTextIndent,oatFoMarginTop,oatFoMarginBottom,oatFoTextAlign],
          ['1cm', '1cm', '0cm', 'false', '2cm', '2cm', 'center']);
      lSpp := lStyle.AppendOdfElement(oetStyleTextProperties);
      lSpp.SetAttributes([oatFoFontSize],
          ['20pt']);

    // TextBlock
      lStyle := FDocument.AddStyle(csTextBlock, sfvParagraph);
      lstyle.OdfStyleParentStyleName := 'Standard';
      lstyle.OdfStyleClass := 'paragraph';
      lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
      lSpp.SetAttributes([oatFoTextAlign],
          [ 'justify']);

    // SubTitel
      lStyle := FDocument.AddStyle(csTextEnumEntry, sfvParagraph);
      lstyle.OdfStyleParentStyleName := csTextBlock;
      lstyle.OdfStyleClass := 'paragraph';
      lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
      lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
          oatStyleAutoTextIndent],
          ['1.5cm', '1cm', '-0.5cm', 'false']);

// Allgemein
    lStyle := FDocument.AddStyle(csFamilyBook, sfvParagraph);
    lstyle.OdfStyleParentStyleName := 'Standard';
    lstyle.OdfStyleClass := 'text';

    lStyle := FDocument.AddStyle(csFamHeader, sfvParagraph);
    lstyle.OdfStyleParentStyleName := csFamilyBook;
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
        oatStyleAutoTextIndent,oatFoMarginTop],
        ['1cm', '0cm', '-1cm', 'false', '0.2cm']);
    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties, oatFoFontSize, '10pt');

    lStyle := FDocument.AddStyle('FamIndividual', sfvParagraph);
    lstyle.OdfStyleParentStyleName := csFamilyBook;
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
        oatStyleAutoTextIndent],
        ['1cm', '0cm', '-0.5cm', 'false']);
    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties, oatFoFontSize, '10pt');

    lStyle := FDocument.AddStyle('FamChildHeader', sfvParagraph);
    lstyle.OdfStyleParentStyleName := csFamilyBook;
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
        oatStyleAutoTextIndent],
        ['1cm', '0cm', '-0.5cm', 'false']);
    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties, oatFoFontSize, '9pt');

    lStyle := FDocument.AddStyle('FamChildren', sfvParagraph);
    lstyle.OdfStyleParentStyleName := csFamilyBook;
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
        oatStyleAutoTextIndent],
        ['1.5cm', '0cm', '-0.5cm', 'false']);
    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties, oatFoFontSize, '9pt');

    lStyle := FDocument.AddAutomaticStyle(csFamilyList, sfvSection);
    lssp := lStyle.AppendOdfElement(oetStyleSectionProperties,
        oatTextDontBalanceTextColumns, 'false');
    lscl := lssp.AppendOdfElement(oetStyleColumns, oatFoColumnCount, '2');
    lscl.SetAttribute(oatFoColumnGap, '0.5cm');
    lscl.AppendOdfElement(oetStyleColumn, oatStyleRelWidth, '1000*');
    lscl.AppendOdfElement(oetStyleColumn, oatStyleRelWidth, '1000*');

    lStyle := FDocument.AddAutomaticStyle(csList3, sfvSection);
    lssp := lStyle.AppendOdfElement(oetStyleSectionProperties,
        oatTextDontBalanceTextColumns, 'false');
    lscl := lssp.AppendOdfElement(oetStyleColumns, oatFoColumnCount, '3');
    lscl.SetAttribute(oatFoColumnGap, '0.5cm');
    lscl.AppendOdfElement(oetStyleColumn, oatStyleRelWidth, '1000*');
    lscl.AppendOdfElement(oetStyleColumn, oatStyleRelWidth, '1000*');
    lscl.AppendOdfElement(oetStyleColumn, oatStyleRelWidth, '1000*');

    lStyle := FDocument.AddStyle(csListEntry, sfvParagraph);
    lstyle.OdfStyleParentStyleName := csFamilyBook;
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
        oatStyleAutoTextIndent,oatFoMarginTop],
        ['0.5cm', '0cm', '-0.5cm', 'false', '0.0cm']);
    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties, oatFoFontSize, '9pt');

    lStyle := FDocument.AddStyle(csListEntryBreak, sfvParagraph);
    lstyle.OdfStyleParentStyleName := csListEntry;
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoBorderBottom],['0.06pt solid #000000']);

    lStyle := FDocument.AddStyle(csGlosEntry, sfvParagraph);
    lstyle.OdfStyleParentStyleName := csTextBlock;
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoTextAlign],
           ['center']);
//    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties, oatFoFontSize, '12pt');

    // Header (Chapter)
    lMStyle := FDocument.AddMasterStyle;
    lHeader := FDocument.CreateOdfElement(oetStyleHeader);
    lMStyle.AppendChild(lHeader);
    lp0 := lHeader.AppendOdfElement(oetTextP, oatTextStyleName, CStCenter, TOdfParagraph);
    lPara := TOdfParagraph(lp0);
    lField := lPara.AppendOdfElement(oetTextChapter, oatTextDisplay, 'name');
    lField.SetAttribute(oatTextOutlineLevel, '3');
    lpara.AppendText(' - ');
    lField := lPara.AppendOdfElement(oetTextChapter, oatTextDisplay, 'name');
    lField.SetAttribute(oatTextOutlineLevel, '4');
    lHeader := lMStyle.AppendOdfElement(oetStyleHeaderFirst);
    lPara := TOdfParagraph(lHeader.AppendOdfElement(
        oetTextP, oatTextStyleName, CStCenter, TOdfParagraph));

    // Footer (Page)
    lHeader := FDocument.CreateOdfElement(oetStyleFooter);
    lMStyle.AppendChild(lHeader);
    lPara := TOdfParagraph(lHeader.AppendOdfElement(
        oetTextP, oatTextStyleName, CStCenter, TOdfParagraph));
    lpara.AppendText('- ');
    lField := lPara.AppendOdfElement(oetTextPageNumber, oatTextSelectPage, 'current');
    lpara.AppendText(' -');
    lHeader := lMStyle.AppendOdfElement(oetStyleFooterFirst);
    lPara := TOdfParagraph(lHeader.AppendOdfElement(
        oetTextP, oatTextStyleName, CStCenter, TOdfParagraph));

    FSection := nil;

    ClearLists;
end;

procedure TGenDocumentWriter.WritePreamble;
var
  lCont: TOdfContent;
  lStyle: TOdfStyleStyle;
  lprop: TOdfElement;
  lGloss: TOdfSection;
begin
  // Write Tile-Page
  // - Write Title
  AppendText(FDocument.AddParagraph(csTitle), rsTitle);
  // - Write Subtitle
  AppendText(FDocument.AddParagraph(csSubTitle), rsSubTitle);
  // - Write Outline
  FDocument.AddTOC(rsToC,2);

  // Write Preamble
  lCont := FDocument.AddHeadline(1);
  AppendText(lCont, rsHeadline);
  lStyle:= lCont.GetStyle();
  if assigned(lStyle) then
    begin
      lprop :=lstyle.FindOdfElement(oetStyleParagraphProperties);
      if assigned(lprop) then
         lprop.SetAttribute(oatFoBreakBefore,'page')
      else
         begin
           lprop :=lstyle.AppendOdfElement(oetStyleParagraphProperties);
           lprop.SetAttribute(oatFoBreakBefore,'page')
         end;
    end;
  // - Write [...]
  AppendText(FDocument.AddHeadline(2), rsChapter1);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter1Text1);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter1Text2);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter1Text3);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter1Text4);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter1Text5);
  AppendText(FDocument.AddHeadline(2), rsChapter2);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter2Text1);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter2Text2);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter2Text3);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter2Text4);
  FDocument.AddParagraph(csTextBlock);
  // - Write Symbol-Glossar
  AppendText(FDocument.AddHeadline(2), rsChapter3);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter3Text1);
  lGloss := FDocument.AddSection(csGlossar,csFamilyList);
  AppendText(lGloss.AddParagraph(csGlosEntry),rsBorn+' = '+ rsGeboren);
  AppendText(lGloss.AddParagraph(csGlosEntry),rsBapt+' = '+ rsGetauft);
  AppendText(lGloss.AddParagraph(csGlosEntry),rsMarr+' = '+ rsGeheiratet);
  AppendText(lGloss.AddParagraph(csGlosEntry),rsDeath+' = '+rsGestorben);
  AppendText(lGloss.AddParagraph(csGlosEntry),rsBurr+' = '+ rsBegraben);
  AppendText(lGloss.AddParagraph(csGlosEntry),rsIlleg+' = '+rsUnehelich);
  AppendText(lGloss.AddParagraph(csGlosEntry),rsDivo+' = '+ rsGeschieden);
  // - Write Entry-Glossar
  AppendText(FDocument.AddHeadline(2), rsChapter4);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter4Text1);
  AppendMarkupText(FDocument.AddParagraph(csTextEnumEntry), rsChapter4Text2);
  AppendMarkupText(FDocument.AddParagraph(csTextEnumEntry), rsChapter4Text3);
  AppendMarkupText(FDocument.AddParagraph(csTextEnumEntry), rsChapter4Text4);
  AppendMarkupText(FDocument.AddParagraph(csTextEnumEntry), rsChapter4Text5);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter4Text6);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter4Text7);
  // - Write Disclamer
  AppendText(FDocument.AddHeadline(2), rsChapter5);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter5Text1);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter5Text2);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter5Text3);
  AppendText(FDocument.AddHeadline(2), rsChapter6);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter6Text1);
  AppendText(FDocument.AddHeadline(2), rsChapter7);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter7Text1);
  AppendText(FDocument.AddHeadline(2), rsChapter8);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter8Text1);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter8Text2);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter8Text3);
  AppendText(FDocument.AddHeadline(2), rsChapter9);
  AppendMarkupText(FDocument.AddParagraph(csTextBlock), rsChapter9Text1);
  // -
end;

end.
