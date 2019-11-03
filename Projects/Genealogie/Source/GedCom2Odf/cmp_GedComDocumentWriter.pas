unit cmp_GedComDocumentWriter;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, odf_types, Cmp_GedComFile, unt_IGenBase2;

type
    { TGenDocumentWriter }

    TGenDocumentWriter = class(TComponent)
    private
        FDocument: TOdfTextDocument;
        FGenealogy: TGedComFile;
        FLanguage: string;
        FlastFamName: string;
        FOnLongOp: TNotifyEvent;
        FSection2: TOdfSection;
        FSelfOwned: boolean;
        FFamilyList: TStrings;
        FIndiList: TStrings;
        FPlaceList: TStrings;
        procedure SetDocument(AValue: TOdfTextDocument);
        procedure SetGenealogy(AValue: TGedComFile);
        procedure SetLanguage(AValue: string);
        procedure SetOnLongOp(AValue: TNotifyEvent);
        function Shortplace(aPlace: string; aFam: iGenFamily): string;
    protected
        FSection: TOdfSection;

    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure PrepareDocument;
        procedure WriteFamily(aFam: iGenFamily);
        procedure WriteIndIndex;
        procedure WritePlaceIndex;
        procedure AppendFamily(aFam: iGenFamily);
        procedure AppendInd(aInd: IGenIndividual);
        function YearOf(aDate: string): string;
        function SortDate(aDate: string): string;
        function SortName(aName: string): string;
        function LifeSpan(aInd: IGenIndividual): string;
        function EventDateToReadable(aDate: string): string;
        procedure SortAndRenumberFamiliies;
    published
        property Document: TOdfTextDocument read FDocument write SetDocument;
        property Genealogy: TGedComFile read FGenealogy write SetGenealogy;
        property Language: string read FLanguage write SetLanguage;
        property OnLongOp: TNotifyEvent read FOnLongOp write SetOnLongOp;
        property FamList: TStrings read FFamilyList;
        property indList: TStrings read FIndiList;
        property PlacList: TStrings read FPlaceList;
    end;

implementation

uses Graphics;

const
    CMonthNames: array[0..23] of string =
        ('JAN', '01.',
        'FEB', '02.',
        'MAR', '03.',
        'APR', '04.',
        'MAY', '05.',
        'JUN', '06.',
        'JUL', '07.',
        'AUG', '08.',
        'SEP', '09.',
        'OCT', '10.',
        'NOV', '11.',
        'DEC', '12.');

    CGedDateModif: array[0..15] of string =
        ('(s)', 'EST', // Geschätztes datum
        'um', 'ABT', // ungefähres Datum
        '(err)', 'CAL', // erreichnetes Datum
        'nach', 'AFT',  // Ereigniss hat (kurz) danach stattgefunden
        'seit', 'AFT',
        'frühestens', 'AFT',
        'vor', 'BEF',  // Ereigniss hatt (kurz) davor stattgefunden
        'ca', 'ABT');

{ TGenDocumentWriter }

procedure TGenDocumentWriter.SetDocument(AValue: TOdfTextDocument);
begin
    if FDocument = AValue then
        Exit;
    if assigned(FDocument) and FSelfOwned then
        FreeAndNil(FDocument);
    FSelfOwned := False;
    FDocument := AValue;
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

function TGenDocumentWriter.Shortplace(aPlace: string; aFam: iGenFamily): string;

var
    lplIx, lpp: integer;
    lList: TList;
    lObj: IGenFamily;
begin

    lplIx := FPlaceList.IndexOf(aPlace);
    lpp := aPlace.IndexOf(',');
    Result := aPlace;
    if aPlace = '' then
        exit;
    if lpp > 0 then
        Result := copy(aPlace, 1, lpp);
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

procedure TGenDocumentWriter.WriteFamily(aFam: iGenFamily);
var
    lPara: TOdfParagraph;
    lID, lSortedFname: string;

    // Aufbau:
  {   <b><u><Nummer:FamRef></u></b> <Event:Marr>:<br>
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
        lEvtIdent, lrDate, lPlace: string;
    begin
        lPlace := Shortplace(aEvent.Place, aFam);
        if aEvent.Eventtype = evt_Birth then
            lEvtIdent := '*'
        else
        if aEvent.Eventtype = evt_Baptism then
            lEvtIdent := '~'
        else
        if aEvent.Eventtype = evt_Marriage then
            lEvtIdent := '⚭'
        else
        if aEvent.Eventtype = evt_Death then
            lEvtIdent := '†'
        else
        if aEvent.Eventtype = evt_Burial then
            lEvtIdent := '='
        else
        if aEvent.Eventtype = evt_AddEmigration then
            lEvtIdent := 'ausgewandert'
        else
        if aEvent.Eventtype = evt_Occupation then
            lEvtIdent := ''
        else
        if aEvent.Eventtype = evt_Member then
            if aEvent.Date <> '' then
                lEvtIdent := 'Mitglied seit'
            else
                lEvtIdent := 'Mitglied des'
        else
        if aEvent.Eventtype = evt_Residence then
            if aEvent.Data <> '' then
                lEvtIdent := aEvent.Data
            else
                lEvtIdent := 'lebte'
        else
            lEvtIdent := '';
        if lEvtIdent <> '' then
            lEvtIdent += ' ';  // NBSpace
        lrDate := EventDateToReadable(aEvent.Date);
        if (aEvent.Data = '') and (lPlace = '') then
            aPara.AddSpan(lEvtIdent + lrDate, [])
        else if (aEvent.Data = '') and (lPlace <> '') then
            aPara.AddSpan(lEvtIdent + lrDate + ' in ' + lPlace, [])
        else if aEvent.EventType in [evt_Birth, evt_Baptism,
            evt_Marriage, evt_Death, evt_Burial] then
            aPara.AddSpan(lEvtIdent + lrDate + ' in ' + lPlace +
                ' (' + aEvent.Data + ')', [])
        else if (aEvent.EventType = evt_Member) and (aEvent.date <> '') and
            (lPlace <> '') then
            aPara.AddSpan(lEvtIdent + lrDate + ' im ' + aEvent.Data +
                ' in ' + lPlace, [])
        else if (aEvent.EventType = evt_Member) and (aEvent.date <> '') then
            aPara.AddSpan(lEvtIdent + lrDate + ' im ' + aEvent.Data, [])
        else if (aEvent.EventType = evt_Member) and (lPlace <> '') then
            aPara.AddSpan(lEvtIdent + lrDate + ' in ' + lPlace, [])
        else if (aEvent.EventType = evt_AddEmigration) and (lPlace <> '') then
            aPara.AddSpan(lEvtIdent + lrDate + ' nach ' + lPlace, [])
        else
          begin
            if aEvent.Date <> '' then
                lEvtIdent += lrDate;
            if (aEvent.Eventtype = evt_Occupation) then
                lEvtIdent += ' ' + aEvent.Data;
            //            else
            //  Todo:              lEvtIdent += ' ' + aEvent.EventType;
            if lPlace <> '' then
                lEvtIdent += ' in ' + lPlace;
            if (aEvent.Eventtype <> evt_Occupation) then
                lEvtIdent += ' (' + aEvent.Data + ')';
            aPara.AddSpan(trim(lEvtIdent), []);
          end;

    end;

    procedure AppendIndiShort(aPara: TOdfParagraph; aInd: IGenIndividual);

    begin
        aPara.AddSpan(aInd.Surname, [fsBold, fsItalic]);
        // AKA Surname
        aPara.AddSpan(', ' + aInd.GivenName, [fsItalic]);
        // AKA Givenname
        if aInd.Title <> '' then
            aPara.AddSpan(', ' + aInd.Title, [fsItalic]);
        if aInd.Religion <> '' then
            aPara.AddSpan(', ' + aInd.Religion, [fsItalic]);
        if aInd.Occupation <> '' then
          begin
            aPara.AddSpan(', ' + aInd.Occupation, [fsItalic]);
            if trim(aInd.OccuPlace) <> '' then
                aPara.AddSpan(' in ' + aInd.OccuPlace, [fsItalic]);
          end;
    end;

    procedure AppendIndi(aPara: TOdfParagraph; aSep: string; aInd: iGenIndividual);

    var
        lRef, lText: string;
        FNeedComma: boolean;
        i: integer;
    begin
        aPara.AddSpan(aSep, []);
        aPara.AddTab([]);
        aPara.AddSpan(aInd.Surname, [fsBold]);
        // AKA Surname
        aPara.AddSpan(', ' + aInd.GivenName, []);
        // AKA Givenname
        if aInd.Title <> '' then
            aPara.AddSpan(', ' + aInd.Title, []);
        if aInd.Religion <> '' then
            aPara.AddSpan(', ' + aInd.Religion, []);
        // Parent References
        FNeedComma := False;
        if assigned(aind.Father) and (aInd.Father.GetChildrenCount > 1) then
          begin
            aPara.AddSpan(', ', []);
            lRef := aInd.ParentFamily.FamilyRefID;
            aPara.AddLink('<' + lRef + '>', [fsItalic], 'F' + lRef);
            FNeedComma := True;
          end
        else
        if assigned(aind.Mother) and (aInd.Mother.GetChildrenCount > 1) then
          begin
            aPara.AddSpan(', ', []);
            lRef := aInd.ParentFamily.FamilyRefID;
            aPara.AddLink('<' + lRef + '>', [fsItalic], 'F' + lRef);
            FNeedComma := True;
          end
        else
        if assigned(aind.Father) and assigned(aInd.Father.ParentFamily) then
          begin
            aPara.AddSpan(', ', []);
            lRef := aInd.ParentFamily.FamilyRefID;
            aPara.AddLink('<' + lRef + '>', [fsItalic], 'F' + lRef);
            FNeedComma := True;
          end
        else
        if assigned(aind.Mother) and assigned(aInd.Mother.ParentFamily) then
          begin
            aPara.AddSpan(', ', []);
            lRef := aInd.ParentFamily.FamilyRefID;
            aPara.AddLink('<' + lRef + '>', [fsItalic], 'F' + lRef);
            FNeedComma := True;
          end
        else
        if assigned(aind.Father) or assigned(aind.Mother) then
          begin
            aPara.AddSpan(', <', [fsItalic]);
            if assigned(aInd.Father) then
                AppendIndiShort(aPara, aInd.Father);
            if assigned(aind.Father) and assigned(aind.mother) then
                aPara.AddSpan(' u. ', [fsItalic]);
            if assigned(aInd.Mother) then
                AppendIndiShort(aPara, aInd.Mother);
            aPara.AddSpan('>', [fsItalic]);
            FNeedComma := True;
          end;
        // Spouse ref
        if aInd.FamilyCount > 1 then
          begin
            if not FNeedComma then;
            aPara.AddSpan(', ', []);
            FNeedComma := False;
            aPara.AddSpan('[', [fsItalic]);
            for i := 0 to aInd.FamilyCount - 1 do
                if aInd.Families[i] <> aFam then
                  begin
                    if FNeedComma then
                        aPara.AddSpan(', ', [fsItalic]);
                    aPara.AddLink(trim(aInd.Families[i].FamilyRefID), [fsItalic],
                        'F' + aInd.Families[i].FamilyRefID);
                    FNeedComma := True;
                  end;
            aPara.AddSpan(']', [fsItalic]);
          end;
        //Occupation
        if aInd.Occupation <> '' then
          begin
            aPara.AddSpan(', ' + aInd.Occupation, []);
            if trim(aInd.OccuPlace) <> '' then
                aPara.AddSpan(' in ' + aInd.OccuPlace, []);
            FNeedComma := True;
          end;
        if aind.Residence <> '' then
            aPara.AddSpan(', lebte in ' + aInd.Residence, []);

        // Vital Info
        FNeedComma := True;
        if assigned(aind.Birth) then
          begin
            if FNeedComma then
                aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Birth);
            FNeedComma := True;
          end;
        if assigned(aind.Baptism) then
          begin
            if FNeedComma then
                aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Baptism);
            FNeedComma := True;
          end;
        if assigned(aind.Death) then
          begin
            if FNeedComma then
                aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Death);
            FNeedComma := True;
          end;
        if assigned(aind.Burial) then
          begin
            if FNeedComma then
                aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Burial);
            FNeedComma := True;
          end;
        // Lebensphasen (
        if aind.EventCount > 0 then
          begin
            aPara.AddLineBreak;
            aPara.AppendText('Lebensphasen von ');
            aPara.AddSpan(aind.Name, [fsItalic]);
            aPara.AppendText(':');
            for i := 0 to aind.EventCount - 1 do
              begin
                aPara.AddLineBreak;
                AppendEvent(apara, aind.Events[i]);
              end;
          end;
        // Ref
        if aind.IndRefID <> '' then
          begin
            aPara.AddLineBreak;
            aPara.AppendText('PN = ');
            aPara.AddSpan(aind.IndRefID, [fsItalic]);
          end;
    end;

    procedure AppendIndiAsChildShort(aPara: TOdfParagraph; aFamName: string;
        aInd: iGenIndividual);

    var
        lRef, lText: string;
        j: integer;
    begin
        aPara.AddTab([]);
        if aind.Surname <> aFamname then
          begin
            aPara.AddSpan(aInd.Surname, [fsBold]);
            // AKA Surname
            aPara.AddSpan(', ', []);
          end;
        // AKA Givenname
        aPara.AddSpan(aInd.GivenName, []);
        if aInd.Title <> '' then
            aPara.AddSpan(', ' + aInd.Title, []);
        aPara.AddTab([]);
        if aInd.Religion <> '' then
            aPara.AddSpan(', ' + aInd.Religion, []);
        // Ref
        aPara.AddSpan('[', [fsItalic]);
        for j := 0 to aInd.FamilyCount - 1 do
          begin
            if J > 0 then
                aPara.AddSpan(', ', [fsItalic]);
            aPara.AddLink(aInd.Families[j].FamilyRefID, [fsItalic],
                'F' + aInd.Families[j].FamilyRefID);
          end;
        // Vital Info
        aPara.AddSpan(']', [fsItalic]);
        if assigned(aind.Birth) then
          begin
            aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Birth);
          end
        else if assigned(aind.Baptism) then
          begin
            aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Baptism);

          end;
        if assigned(aind.Death) then
          begin
            aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Death);
          end
        else if assigned(aind.Burial) then
          begin
            aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Burial);
          end;
    end;

    procedure AppendIndiAsChild(aPara: TOdfParagraph; aFamName: string;
        aInd: iGenIndividual);

    var
        lRef, lText: string;
        FNeedComma: boolean;
    begin
        aPara.AddTab([]);
        if aind.Surname <> aFamname then
          begin
            aPara.AddSpan(aInd.Surname, [fsBold]);
            // AKA Surname
            aPara.AddSpan(', ', []);
          end;
        // AKA Givenname
        aPara.AddSpan(aInd.GivenName, []);
        if aInd.Title <> '' then
            aPara.AddSpan(', ' + aInd.Title, []);
        aPara.AddTab([]);
        FNeedComma := False;
        if aInd.Religion <> '' then
          begin
            aPara.AddSpan(aInd.Religion, []);
            FNeedComma := True;
          end;
        // Vital Info
        if assigned(aind.Birth) then
          begin
            if FNeedComma then
                aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Birth);
            FNeedComma := True;
          end;
        if assigned(aind.Baptism) then
          begin
            if FNeedComma then
                aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Baptism);
            FNeedComma := True;
          end;
        if assigned(aind.Death) then
          begin
            if FNeedComma then
                aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Death);
            FNeedComma := True;
          end;
        if assigned(aind.Burial) then
          begin
            if FNeedComma then
                aPara.AddSpan(', ', []);
            AppendEvent(aPara, aind.Burial);
            FNeedComma := True;
          end;
        //Occupation
        if aInd.Occupation <> '' then
          begin
            aPara.AddSpan(', ' + aInd.Occupation, []);
            if trim(aInd.OccuPlace) <> '' then
                aPara.AddSpan(' in ' + aInd.OccuPlace, []);
          end;
        if aind.Residence <> '' then
            aPara.AddSpan(', lebte in ' + aInd.Residence, []);
    end;

    procedure AppendChildren(aDocument: TOdfSection; aParaStyle, aSep: string;
        aFam: IGenFamily);

    var
        i: integer;
    begin
        lPara := aDocument.AddParagraph(aParaStyle);
        if aFam.ChildCount = 1 then
            lpara.AppendText(asep + ' 1 Kind:')
        else
            lPara.AppendText(aSep + ' ' + IntToStr(aFam.ChildCount) + ' Kinder:');
        for i := 0 to aFam.ChildCount - 1 do
          begin
            lPara := aDocument.AddParagraph(aParaStyle);
            lpara.AppendText(IntToStr(i + 1) + ')');
            if aFam.Children[i].FamilyCount > 0 then
                AppendIndiAsChildShort(lPara, afam.FamilyName, afam.Children[i])
            else
                AppendIndiAsChild(lPara, afam.FamilyName, afam.Children[i]);
          end;
    end;

begin
    // Todo: Language-support
    if not assigned(Fsection) then
        FSection := FDocument.AddSection('FamilyList', 'FamilyList');
    lSortedFname := uppercase(SortName(afam.FamilyName));
    if lSortedFname <> FlastFamName then
      begin
        if copy(lSortedFname, 1, 1) <> copy(FlastFamName, 1, 1) then
            if copy(lSortedFname, 1, 1) <> 'Ä'[1] then
                FSection.AddHeadline(2).AppendText(copy(lSortedFname, 1, 1))
            else
                FSection.AddHeadline(2).AppendText(copy(lSortedFname, 1, 2));
        FSection.AddHeadline(4).AppendText(aFam.FamilyName);
        FlastFamName := lSortedFname;
      end;
    lPara := FSection.AddParagraph('FamHeader');
    lID := aFam.FamilyRefID;
    lPara.AddBookmark(lID, [fsBold, fsUnderline], 'F' + lID);
    lpara.AddTab([]);
    if assigned(aFam.Marriage) then
        AppendEvent(lPara, aFam.Marriage);
    if assigned(aFam.Husband) then
        AppendIndi(FSection.AddParagraph('FamIndividual'), '●', aFam.Husband);
    if assigned(aFam.Wife) then
        AppendIndi(FSection.AddParagraph('FamIndividual'), '●', aFam.Wife);
    if aFam.ChildCount > 0 then
        AppendChildren(FSection, 'FamChildren', '●', aFam);
    FSection.AddParagraph('Standard');
end;

procedure TGenDocumentWriter.WriteIndIndex;
var
    lSection: TOdfSection;
    lSortedFname, llastFamName, lRef, lSurname: string;
    lCut: TStringArray;
    lInd: IGenIndividual;
    lpara: TOdfParagraph;
    lNeedComma: boolean;
    i, j: integer;
begin
    lSection := FDocument.AddSection('IndiList', 'FamilyList');
    lSection.AddHeadline(2).AppendText('Personenverzeichniss');
    llastFamName := '';
    for i := 0 to FIndiList.Count - 1 do
      begin
        lCut := FIndiList[i].Split(',');
        lInd := IGenIndividual(ptrint(FIndiList.Objects[i]));
        lSortedFname := uppercase(lCut[0]);
        if lSortedFname <> llastFamName then
          begin
            if copy(lSortedFname, 1, 1) <> copy(llastFamName, 1, 1) then
                if copy(lSortedFname, 1, 1) <> 'Ä'[1] then
                    lSection.AddHeadline(3).AppendText(copy(lSortedFname, 1, 1))
                else
                    lSection.AddHeadline(3).AppendText(copy(lSortedFname, 1, 2));
            lSurname := trim(lInd.Surname);
            if (lsurname<>'') and (lsurname[1] = '(') then
                lSurname := copy(lsurname, 2, length(lsurname) - 2);
            if (lsurname<>'') and (lsurname[1] = '<') then
                lSurname := copy(lsurname, 2, length(lsurname) - 2);
            lSection.AddHeadline(4).AppendText(lSurname);
            llastFamName := lSortedFname;
          end;
        lpara := lSection.AddParagraph('FamHeader');
        if lSurname <> trim(lInd.Surname) then
            lpara.AddSpan('^', []);
        lpara.AddSpan(lCut[1], []);
        lpara.AddTab([]);
        lNeedComma := False;
        if assigned(lInd.ParentFamily) then
          begin
            lRef := trim(lInd.ParentFamily.FamilyRefID);
            lPara.AddLink('<' + lRef + '>', [fsItalic], 'F' + lRef);
          end;
        // Spouse ref
        if lInd.FamilyCount > 0 then
          begin
            lNeedComma := False;
            lPara.AddSpan('[', [fsItalic]);
            for j := 0 to lInd.FamilyCount - 1 do
              begin
                if lNeedComma then
                    lPara.AddSpan(', ', [fsItalic]);
                lRef := trim(lInd.Families[j].FamilyRefID);
                lPara.AddLink(lRef, [fsItalic],
                    'F' + lRef);
                lNeedComma := True;
              end;
            lPara.AddSpan(']', [fsItalic]);
          end;
      end;
end;

procedure TGenDocumentWriter.WritePlaceIndex;
var
    lSection: TOdfSection;
    lSortedplace, llastPlace, lRef: string;
    lpara: TOdfParagraph;
    lList: TList;
    lObj: Pointer;
    i: integer;
    lNeedComma: boolean;
begin
    lSection := FDocument.AddSection('PlaceList', 'FamilyList');
    lSection.AddHeadline(2).AppendText('Ortsverzeichniss');
    llastPlace := '';
    for i := 0 to FPlaceList.Count - 1 do
      begin
        lSortedplace := FPlaceList[i];
        if copy(lSortedplace, 1, 1) <> copy(llastPlace, 1, 1) then
            if copy(lSortedplace, 1, 1) <> 'Ä'[1] then
                lSection.AddHeadline(3).AppendText(copy(lSortedplace, 1, 1))
            else
                lSection.AddHeadline(3).AppendText(copy(lSortedplace, 1, 2));
        llastPlace := lSortedplace;
        lpara := lSection.AddParagraph('FamHeader');
        lpara.AddSpan(FPlaceList[i], [fsbold]);
        lpara.AddTab([]);
        lPara.AddSpan('[', [fsItalic]);
        lNeedComma := False;
        lList := TList(FPlaceList.Objects[i]);
        for lObj in llist do
          begin
            if lNeedComma then
                lPara.AddSpan(', ', [fsItalic]);
            lRef := trim(IGenFamily(lObj).FamilyRefID);
            lPara.AddLink(lRef, [fsItalic],
                'F' + lRef);
            lNeedComma := True;
          end;
        lPara.AddSpan(']', [fsItalic]);
      end;
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
  i: Integer;
begin
    lName := aName.Split([' ']);
    if (high(lName)<=0) or (lName[high(lName)][1]in['(','<','"']) then exit(aName);
    Result := '';
    for i := high(lName) downto 0 do
        Result += lName[i] + ' ';
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
    if FIndiList.IndexOfObject(Tobject(ptrint(aInd))) = -1 then
      begin
        lSurname := trim(aInd.Surname);
        if (lsurname<>'') and (lsurname[1] = '(') then
          lSurname := copy(lsurname, 2, length(lsurname) - 2);
        if (lsurname<>'') and (lsurname[1] = '<') then
          lSurname := copy(lsurname, 2, length(lsurname) - 2);
        FIndiList.AddObject(SortName(lSurname) + ', ' + aInd.GivenName +
            ' ' + LifeSpan(aInd), tobject(ptrint(aInd)));

      end;
end;

procedure TGenDocumentWriter.AppendFamily(aFam: iGenFamily);
var
    i: integer;
    lFamDate: string;
    lYear: longint;
begin
    lFamDate := afam.MarriageDate;
    if (lFamDate = '') and (afam.ChildCount > 0) then
        lFamDate := aFam.Children[0].BirthDate;
    if (lfamDate = '') and (afam.ChildCount > 0) then
        lFamDate := aFam.Children[0].BaptDate;
    if assigned(afam.Husband) and Assigned(aFam.Wife) then
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
    else if afam.ChildCount = 0 then
      begin
        if assigned(afam.Husband) then
          begin
            lFamDate := afam.Husband.BirthDate;
            if (lFamDate = '') then
                lFamDate := afam.Husband.BaptDate;
          end
        else if Assigned(aFam.Wife) then
          begin
            lFamDate := afam.Wife.BirthDate;
            if (lFamDate = '') then
                lFamDate := afam.Wife.BaptDate;
          end;
      end;

    FFamilyList.AddObject(SortName(aFam.FamilyName) + ', ' +
        SortDate(lFamDate), TObject(ptrint(aFam)));
    AppendInd(afam.Husband);
    AppendInd(afam.Wife);
    for i := 0 to aFam.ChildCount - 1 do
        AppendInd(afam.Children[i]);
end;

function TGenDocumentWriter.EventDateToReadable(aDate: string): string;
var
    lDatepart: TStringArray;
    i: integer;
begin
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
    TStringList(FFamilyList).Sorted := True;
    TStringList(FIndiList).Sorted := True;
    TStringList(FPlaceList).Sorted := True;
    for i := 0 to FFamilyList.Count - 1 do
        IGenFamily(ptrint(FFamilyList.Objects[i])).FamilyRefID := IntToStr(i + 1);
    FlastFamName := '-';
    for i := 0 to FFamilyList.Count - 1 do
        WriteFamily(IGenFamily(ptrint(FFamilyList.Objects[i])));
end;

constructor TGenDocumentWriter.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FDocument := TOdfTextDocument.Create;
    FSelfOwned := True;
    FFamilyList := TStringList.Create;
    FIndiList := TStringList.Create;
    FPlaceList := TStringList.Create;
end;

destructor TGenDocumentWriter.Destroy;
var
    i: integer;
begin
    if FSelfOwned then
        FreeAndNil(FDocument);
    for i := 0 to FPlaceList.Count - 1 do
      begin
        TList(FPlaceList.Objects[i]).Free;
        FPlaceList.Objects[i] := nil;
      end;
    FreeAndNil(FPlaceList);
    FreeAndNil(FIndiList);
    FreeAndNil(FFamilyList);
    inherited Destroy;
end;

procedure TGenDocumentWriter.PrepareDocument;
var
    lStyle: TOdfStyleStyle;
    lSpp, lssp, lscl: TOdfElement;
    i: integer;
begin
    FDocument.Clear;
    lStyle := FDocument.AddStyle('FamilyBook', sfvParagraph);
    lstyle.OdfStyleParentStyleName := 'Standard';
    lstyle.OdfStyleClass := 'text';

    lStyle := FDocument.AddStyle('FamHeader', sfvParagraph);
    lstyle.OdfStyleParentStyleName := 'FamilyBook';
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
        oatStyleAutoTextIndent],
        ['1cm', '0cm', '-1cm', 'false']);
    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties, oatFoFontSize, '10pt');
    lStyle := FDocument.AddStyle('FamIndividual', sfvParagraph);
    lstyle.OdfStyleParentStyleName := 'FamilyBook';
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
        oatStyleAutoTextIndent],
        ['1cm', '0cm', '-0.5cm', 'false']);
    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties, oatFoFontSize, '10pt');
    lStyle := FDocument.AddStyle('FamChildren', sfvParagraph);
    lstyle.OdfStyleParentStyleName := 'FamilyBook';
    lstyle.OdfStyleClass := 'text';
    lSpp := lStyle.AppendOdfElement(oetStyleParagraphProperties);
    lSpp.SetAttributes([oatFoMarginLeft, oatFoMarginRight, oatFoTextIndent,
        oatStyleAutoTextIndent],
        ['1cm', '0cm', '-0.5cm', 'false']);
    lSpp := lStyle.AppendOdfElement(oetStyleTextProperties, oatFoFontSize, '9pt');

    lStyle := FDocument.AddAutomaticStyle('FamilyList', sfvSection);
    lssp := lStyle.AppendOdfElement(oetStyleSectionProperties,
        oatTextDontBalanceTextColumns, 'false');
    lscl := lssp.AppendOdfElement(oetStyleColumns, oatFoColumnCount, '2');
    lscl.SetAttribute(oatFoColumnGap, '0.5cm');
    lscl.AppendOdfElement(oetStyleColumn, oatStyleRelWidth, '1000*');
    lscl.AppendOdfElement(oetStyleColumn, oatStyleRelWidth, '1000*');

    for i := 0 to FPlaceList.Count - 1 do
      begin
        TList(FPlaceList.Objects[i]).Free;
        FPlaceList.Objects[i] := nil;
      end;
    FPlaceList.Clear;
    FIndiList.Clear;
    FFamilyList.Clear;
end;

end.
