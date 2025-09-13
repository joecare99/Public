unit unt_FBParser;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Cmp_Parser, unt_IGenBase2, Unt_GNameHandler;

type
    TParseEvent = procedure(Sender: TObject; aText: string; Ref: string;
        dsubtype: integer) of object;

    TParseMsgEvent = TTMessageEvent;

    { TFBEntryParser }

    TFBEntryParser = class(TBaseParser)
    private
        FDefaultPlace: string;

        FLastErr: string;
        FMainRef: string;
        FonEntryEnd: TParseEvent;

        FUmlauts: array of string;
        FAkkaTitel: array of string;

        FonStartFamily: TParseEvent;
        FonFamilyData: TParseEvent;
        FonFamilyDate: TParseEvent;
        FonFamilyIndiv: TParseEvent;
        FonFamilyPlace: TParseEvent;
        FonFamilyType: TParseEvent;
        FonIndiData: TParseEvent;
        FonIndiDate: TParseEvent;
        FonIndiName: TParseEvent;
        FonIndiOccu: TParseEvent;
        FonIndiPlace: TParseEvent;
        FonIndiRef: TParseEvent;
        FonIndiRel: TParseEvent;

        FonParseError: TNotifyEvent;
        FonParseMessage: TParseMsgEvent;

        FMode: integer;
        procedure Debug(Sender: TObject; NewMessage: string);
        procedure GNameError(Msg: String; aType: integer);
        procedure SetDefaultPlace(AValue: string);
        procedure SetFamilyData(lFamRef: string; lEvType: TenumEventType;
            lData: string);
        procedure SetFamilyDate(lFamRef: string; lEvType: TenumEventType;
            lDate: string);
        procedure SetFamilyPlace(lFamRef: string; lEvType: TenumEventType;
            lPlace: string);
        procedure SetIndiName(lIndID: string; lNameType: integer;
            lName: string);
        procedure SetIndiOccu(lIndID: string; lEvType: TenumEventType;
            lOccu: string);
        procedure SetIndiRelat(lIndID, lFamRef: string; lRelType: integer);
        procedure SetonEntryEnd(const AValue: TParseEvent);
        Procedure EndOfEntry(const lFamRef:String);

        procedure SetonFamilyData(AValue: TParseEvent);
        procedure SetonFamilyDate(AValue: TParseEvent);
        procedure SetonFamilyIndiv(AValue: TParseEvent);
        procedure SetonFamilyPlace(AValue: TParseEvent);
        procedure SetonFamilyType(AValue: TParseEvent);
        procedure SetonIndiData(AValue: TParseEvent);
        procedure SetonIndiDate(AValue: TParseEvent);
        procedure SetonIndiName(AValue: TParseEvent);
        procedure SetonIndiOccu(AValue: TParseEvent);
        procedure SetonIndiPlace(AValue: TParseEvent);
        procedure SetonIndiRef(AValue: TParseEvent);
        procedure SetonIndiRel(AValue: TParseEvent);
        procedure SetonParseError(AValue: TNotifyEvent);
        procedure SetonParseMessage(AValue: TParseMsgEvent);
        procedure SetonStartFamily(AValue: TParseEvent);

        procedure StartFamily(var lFamRef: string);
        procedure SetFamilyType(lMainFamRef: string; lFamType: integer;
            lData: string = '');
        procedure SetFamilyMember(lFamRef, lIndID: string; const lFamMember: integer);
        procedure SetIndiData(lIndID: string; lEvType: TenumEventType; lData: string);
        procedure SetIndiDate(lIndID: string; lEvType: TenumEventType; lDate: string);
        procedure SetIndiPlace(lIndID: string; lEvType: TenumEventType; lPlace: string);

        class function TestForC(const aText: string; pPos: int64; const aTest: string
          ): boolean;
     {$ifdef debug}
    public
     {$endif}
        function TestReferenz(const aRef:string):boolean;
        function TestEntry(lSubString, TestStr: string; out Data: string): boolean;
          overload;
        function TestEntry(lSubString: string; const TestStra: array of string; out
          Data: string): boolean; overload;

        class function TestFor(const aText: string; pPos: int64;
            const aTest: string): boolean; inline;
            overload;
        class function TestFor(const aText: string; pPos: int64;
            const aTest: array of string): boolean; inline; overload;
        class function TestFor(const aText: string; pPos: int64;
            const aTest: array of string; out Found: integer): boolean; inline; overload;

        function GetEntryType(lSubString: string;
            out Date, Data: string): TenumEventType;
        procedure TrimPlaceByMonth(var lPlace: string);
        procedure TrimPlaceByModif(var lPlace: string);
        procedure AnalyseEntry(var lSubString: string; out lEntryType: TenumEventType; out
          lData, lPlace, lDate: string);

        function HandleGCNonPersonEntry(const aSubString: string;
            const ActChar: char; const lIndID: string): boolean;
        function HandleNonPersonEntry(const aSubString, lIndID: string; FamRef:string=''): TenumEventType;
        function HandleGCDateEntry(const aText: string; var ppos: int64;
            lIndID: string; var lMode, lRetMode: integer;
            var aEntrytype: TenumEventType): boolean;
        function ParseAdditional(const aText: string; var pPos: int64;
            out aOutput: string): boolean;
        function HandleAKPersonEntry(const lPersonEntry: string;
            const lMainFamRef: string; lPersonType: char; lMode: integer;
            out lLastName: string; out lPersonSex: char; const aAKA: string = '';
            const lFamName: string = ''): string;
        procedure HandleFamilyFact(const lMainFamRef: string; const lFamEntry: string);

        function BuildName2(const aText: string; var aOffset: int64;
          var lCharCount: integer; var lSubString: string; out
          lAdditional: string): boolean;

        procedure DebugSetMsg(Message, Ref: string; Mode: integer);

        function IsValidDate(aDate: string): boolean;
        function IsValidPlace(aPlace: string): boolean;
    public
        (* GNameHandler *)
        GNameHandler: TGNameHandler;

        constructor Create;
        destructor Destroy; override;

        procedure LearnSexOfGivnName(aName: string; aSex: char);
        function GuessSexOfGivnName(aName: string; bLearn: boolean = True): char;

        procedure Parse(Data: string); deprecated;
        procedure Feed(aText: string); override;
        procedure Error(Sender: TObject; NewMessage: string); override;
        procedure Warning(Sender: TObject; NewMessage: string); override;
        function ScanForEvDate(const aText: string; lOffset: int64): string;
        property onStartFamily: TParseEvent read FonStartFamily write SetonStartFamily;
        property onEntryEnd:  TParseEvent read FonEntryEnd write SetonEntryEnd;
        property onFamilyDate: TParseEvent read FonFamilyDate write SetonFamilyDate;
        property onFamilyType: TParseEvent read FonFamilyType write SetonFamilyType;
        property onFamilyData: TParseEvent read FonFamilyData write SetonFamilyData;
        property onFamilyPlace: TParseEvent read FonFamilyPlace write SetonFamilyPlace;
        property onFamilyIndiv: TParseEvent read FonFamilyIndiv write SetonFamilyIndiv;
        property onIndiName: TParseEvent read FonIndiName write SetonIndiName;
        property onIndiDate: TParseEvent read FonIndiDate write SetonIndiDate;
        property onIndiPlace: TParseEvent read FonIndiPlace write SetonIndiPlace;
        property onIndiOccu: TParseEvent read FonIndiOccu write SetonIndiOccu;
        property onIndiRel: TParseEvent read FonIndiRel write SetonIndiRel;
        property onIndiRef: TParseEvent read FonIndiRef write SetonIndiRef;
        property onIndiData: TParseEvent read FonIndiData write SetonIndiData;
        property onParseError: TNotifyEvent read FonParseError write SetonParseError;
        property onParseMessage: TParseMsgEvent
            read FonParseMessage write SetonParseMessage;
        property LastErr: string read FLastErr;
        property LastMode: integer read FMode;
        property MainRef: string read FMainRef;
        property DefaultPlace: string read FDefaultPlace write SetDefaultPlace;
    end;

implementation

uses strutils, Unt_StringProcs;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

const
    csMarriageEntr = '⚭';
    csMarriageEntr2 = 'oo';
    csMarriageEntr3 = '∞';
    csMarriageGC = 'Ehe:';
    csSeparatorGC = '●';
    csSeparator = ',';
    csSeparator2 = '‚';
    csDeathEntr = '†';
    csDeathEntr2 = '+';
    csDeathGefEntr = 'gefallen';
    csDeathVermEntr = 'vermisst';
    csDeathVermEntr2 = 'vermißt';
    csIllegChild = 'o-o';
    csIllegChild2 = 'U';
    csIllegChild3 = 'o~o';
    csProtectSpace = ' ';
    csDivorce = 'o/o';
    csBirth = '*';
    csBaptism = '*)';
    csBaptism2 = '~';
    csBurial = '†)';
    csBurial2 = '=';
    csSpouseKn = 'u.';
    csSpouseKn2 = 'und';
    csMaidenNameKN = 'geb.';
    csMarrPartKN = 'mit';
    csReferenceGC = 'PN =';
    csAdditional = 'Lebensphasen';
    csResidence = 'lebte';
    csResidence2 = 'leb';
    csResidence3 = 'wohnte';
    csResidence4 = 'wohnhaft';
    csResidence5 = 'wohnt';
    csResidence6 = 'Herkunft';
    csEmigration = 'ausgewandert';
    csEmigration2 = 'wanderte';
    csAge = 'alt';
    csPlaceKenn = 'in';
    csPlaceKenn2 = 'aus';
    csPlaceKenn3 = 'nach';
    csPlaceKenn4 = 'am';
    csPlaceKenn5 = 'bei';
    csPlaceKenn6 = 'im';
    csPlaceKenn7 = 'auf der';
    csKath = 'rk.';
    csKath2 = 'kath.';
    csEvang = 'ev.';
    csEvang2 = 'evang.';
    csReform = 'ref.';
    csReform2 = 'reform.';
    csLuth = 'luth.';
    csUnknown = '…';
    csUnknown2 = '...';
    csUnknown3 = '..';
    csTwin = 'Zw';
    csDoktor = 'Dr.';
    csPfarrer = 'Pfarrer';
    csDoktorTheol = 'Dr. theol.';
    csDoktorMed = 'Dr. med.';
    csDoktorRN = 'Dr. rer. nat.';
    csProf = 'Prof. Dr.';
    csProfDoktor = 'Prof.';
    csGehRat = 'Geheimrat';
    csDateModif4 = 'seit';
    csBaute = 'baute';
    csKaufte = 'kaufte';
    csErwarb = 'erwarb';
    csStrAbb = 'str.';
    csSiedlAbb = 'siedl';
    csStrasse = 'straße';
    csGasse = 'gasse';
    csWeg = 'weg';
    csAllee = 'allee';
    csPlatz = 'platz';
    csPfad = 'pfad';
    csLedig = 'ledig';
    csLedigAbb = 'led.';
    csWitwe = 'Witwe';
    csWitwer = 'Witwer';
    csTypeQuota = '„';
    csTypeQuota2 = '“';
    csGenannt = 'genannt';
    csWurde = 'wurde';
    csArtikelB1 = 'der';
    csArtikelB2 = 'die';
    csArtikelB3 = 'das';
    csArtikelU1 = 'ein';
    csArtikelU2 = 'eine';

    cfgLearnUnknown = True;

    CUmLauts: array[0..7] of string = ('ä', 'ö', 'ü', 'Ä', 'Ö', 'Ü', 'ß', 'é');
    CUmLautsU: array[0..2] of string = ('Ä', 'Ö', 'Ü');

    CHyphens : array[0..2] of string =
        ('-', '­','‑');

    CTitel: array[0..9] of string =
        ('Graf',
        'Erbgraf',
        'Gräfin',
        'Baron',
        'Baronin',
        'Prinz',
        'Prinzessin',
        'Junker',
        'Freiherr',
        'Freiin');

    CDateModif: array[0..10] of string =
        ('ca',
        'um',
        'ab',
        'von',
        'vor',
        'nach',
        'err.',
        csDateModif4,
        'zwischen',
        'frühestens',
        'spätestens');

    CAkkaTitle: array[0..7] of string =
        (csDoktorMed,
        csDoktorRN,
        csDoktorTheol,
        csPfarrer,
        csGehRat,
        csProfDoktor,
        csProf,
        csDoktor);

    CReligions: array[0..6] of string =
        (csKath,
        csKath2,
        csEvang,
        csEvang2,
        csReform,
        csReform2,
        csLuth);

    CMarriageKN: array[0..2] of string =
        (csMarriageEntr,
         csMarriageEntr2,
         csMarriageEntr3);

    CResidenceKN: array[0..5] of string =
        (csResidence,
        csResidence2,
        csResidence3,
        csResidence4,
        csResidence5,
        csResidence6);

    CPlaceKN: array[0..6] of string =
        (csPlaceKenn,
        csPlaceKenn2,
        csPlaceKenn3,
        csPlaceKenn4,
        csPlaceKenn5,
        csPlaceKenn6,
        csPlaceKenn7);

    CUnknownKN: array[0..2] of string =
        (csUnknown,
        csUnknown2,
        csUnknown3);

    CEmmigratKN: array[0..1] of string =
        (csEmigration,
        csEmigration2);

    CPropertyKN: array[0..2] of string =
        (csBaute,
        csKaufte,
        csErwarb);

    CAddressKN: array[0..6] of string =
        (csStrAbb,
        csSiedlAbb,
        csStrasse,
        csGasse,
        csWeg,
        csPlatz,
        csPfad);

    CDescriptKN: array[0..2] of string =
        (csLedig,
         csWitwer,
         csWitwe);

    CMonthKN: array[1..12] of string =
        ('Januar',
        'Februar',
        'März',
        'April',
        'Mai',
        'Juni',
        'Juli',
        'August',
        'September',
        'Oktober',
        'November',
        'Dezember');

    csZiffern: array[0..9] of char = '0123456789';

    CArtikelB: array[0..2] of string =
        (csArtikelB1,
         csArtikelB2,
         csArtikelB3);

    CLedigKN: array[0..2] of string =
        (csLedig+'er',
         csLedig+'e',
         csLedigAbb);

    CArtikelU: array[0..1] of string =
        (csArtikelU2,
         csArtikelU1);

{ TFBEntryParser }

procedure TFBEntryParser.GNameError(Msg: String; aType: integer);
begin
  Error(self, FMainref + ': '+Msg);
end;

procedure TFBEntryParser.SetonFamilyDate(AValue: TParseEvent);
begin
    if FonFamilyDate = AValue then
        Exit;
    FonFamilyDate := AValue;
end;

procedure TFBEntryParser.SetonFamilyData(AValue: TParseEvent);
begin
    if FonFamilyData = AValue then
        Exit;
    FonFamilyData := AValue;
end;

procedure TFBEntryParser.SetDefaultPlace(AValue: string);
begin
    if FDefaultPlace = AValue then
        Exit;
    FDefaultPlace := AValue;
end;

procedure TFBEntryParser.SetFamilyMember(lFamRef, lIndID: string;
    const lFamMember: integer);
begin
    if Assigned(FonFamilyIndiv) then
        FonFamilyIndiv(self, lIndID, lFamRef, lFamMember);
end;

procedure TFBEntryParser.SetFamilyDate(lFamRef: string; lEvType: TenumEventType;
    lDate: string);
begin
    if not IsValidDate(lDate) then
        Error(self, ldate.QuotedString + ' is no valid Date')
    else
    if Assigned(FonFamilyDate) then
        FonFamilyDate(self, lDate, lFamRef, Ord(lEvType));
end;

procedure TFBEntryParser.SetFamilyPlace(lFamRef: string; lEvType: TenumEventType;
    lPlace: string);

begin
    if not IsValidPlace(lPlace) then
        Error(self, lPlace.QuotedString + ' is no valid Place');
    if Assigned(FonFamilyPlace) then
        FonFamilyPlace(self, lPlace, lFamRef, Ord(lEvType));
end;

procedure TFBEntryParser.SetFamilyData(lFamRef: string; lEvType: TenumEventType;
    lData: string);

begin
    if Assigned(FonFamilyData) then
        FonFamilyData(self, lData, lFamRef, Ord(lEvType));
end;

procedure TFBEntryParser.SetIndiName(lIndID: string; lNameType: integer; lName: string);
begin
    if Assigned(FonIndiName) then
        FonIndiName(Self, lName, lIndID, lNameType);
end;

procedure TFBEntryParser.SetIndiData(lIndID: string; lEvType: TenumEventType;
    lData: string);
begin
    if Assigned(FonIndiData) then
        FonIndiData(self, lData, lIndID, Ord(lEvType));
end;

procedure TFBEntryParser.SetIndiDate(lIndID: string; lEvType: TenumEventType;
    lDate: string);
begin
    if not IsValidDate(lDate) then
        Error(self, ldate.QuotedString + ' is no valid Date')
    else
    if Assigned(FonIndiDate) then
        FonIndiDate(self, lDate, lIndID, Ord(lEvType));
end;

procedure TFBEntryParser.SetIndiPlace(lIndID: string; lEvType: TenumEventType;
    lPlace: string);
begin
    if not IsValidPlace(lPlace) then
        Error(self, lPlace.QuotedString + ' is no valid Place');
    if Assigned(FonIndiPlace) then
        FonIndiPlace(self, lPlace, lIndID, Ord(lEvType));
end;

procedure TFBEntryParser.SetIndiRelat(lIndID, lFamRef: string; lRelType: integer);
begin
    if (lFamRef = '0') and (FMainRef <> '0') then
        Error(self, lFamRef.QuotedString + ' is no valid Ref');
    if Assigned(FonIndiRel) then
        FonIndiRel(self, lFamRef, lIndID, lRelType);
end;

procedure TFBEntryParser.SetonEntryEnd(const AValue: TParseEvent);
begin
  if FonEntryEnd=AValue then Exit;
     FonEntryEnd:=AValue;
end;

procedure TFBEntryParser.EndOfEntry(const lFamRef: String);
begin
  if Assigned(FonEntryEnd) then
      FonEntryEnd(Self, '', lFamRef, -1);
end;

procedure TFBEntryParser.SetIndiOccu(lIndID: string; lEvType: TenumEventType;
    lOccu: string);
begin
    if Assigned(FonIndiOccu) then
        FonIndiOccu(Self, lOccu, lIndID, Ord(lEvType));
end;


procedure TFBEntryParser.SetFamilyType(lMainFamRef: string; lFamType: integer;
    lData: string);
begin
    if Assigned(FonFamilyType) then
        FonFamilyType(self, lData, lMainFamRef, lfamtype);
end;


function TFBEntryParser.ParseAdditional(const aText: string; var pPos: int64;
    out aOutput: string): boolean;

var
    lMaxLen: integer;

begin
    Result := (length(aText) > ppos + 1) and
        ((aText[pPos + 1] in AlphaNum + [' ','"', '?', '*','!'])
        or Testfor(aText, pPos + 1, [csDeathEntr,csTypeQuota,csMarriageEntr])
        or Testfor(aText, pPos + 1, FUmlauts) );
    if Result then
      begin   // Additional Info
        aOutput := '';
        if ((aText[pPos + 1] = '"') and aText.Contains('")')) or
          (Testfor(aText, pPos + 1, csTypeQuota) and aText.Contains(csTypeQuota2+')'))  then
            lMaxLen := 1024
        else
            lMaxLen := 200;
        if not copy(aText, ppos).Contains(')') or
            (aText.IndexOf(')', pPos + 1) > ppos + lMaxLen) then
            Error(self, 'Misspelled additional Entry');
        Inc(pPos);
        while (length(aText) >= ppos) and (aText[pPos] <> ')') and
            (length(aOutput) < lMaxLen) do
          begin
            aOutput := aOutput + aText[pPos];
            Inc(pPos);
          end;
      end;
end;

procedure TFBEntryParser.DebugSetMsg(Message, Ref: string; Mode: integer);
begin
    FLastErr := Message;
    FMainRef := Ref;
    FMode := Mode;
end;

function TFBEntryParser.IsValidDate(aDate: string): boolean;
begin
    if adate = '' then
        exit(True);
    if aDate.Contains(#10) or aDate.Contains(#13) or
        aDate.Contains(#9) or aDate.Contains(',') or
        aDate.Contains(':') or aDate.Contains(';') or
        aDate.Contains('<') or aDate.Contains('>') or
        aDate.Contains('+') or //aDate.Contains('/') or
        aDate.Contains('*') or aDate.Contains('|') then
        exit(False);
    Result := True;
end;

function TFBEntryParser.IsValidPlace(aPlace: string): boolean;
begin
   if aPlace = '' then
     exit(true);
   result := (aPlace = csUnknown2)
     or (aPlace[1] in UpperCharset + ['"', '“'[1]])
     or TestFor(aPlace,1,CUmLautsU);
end;

function TFBEntryParser.HandleNonPersonEntry(const aSubString, lIndID: string;
  FamRef: string): TenumEventType;
var
    lEntryType: TenumEventType;
    ldPos, i, lfound: integer;
    lDate, lFamRef: string;
    lPlace, lSubString, lData, lLastname, lIndID2, lRest: string;
    lSex: char;

begin
    Debug(self, 'HNPE: "' + aSubString + '"');
    lSubString := trim(aSubString);
    lFamRef:=FamRef;
    if (lSubString = '') or (lSubString = '.') then
        exit(evt_aNull);

    AnalyseEntry( lSubString, lEntryType, lData, lPlace, lDate);

    //========  Set Data
    if (lEntryType = evt_Stillborn) then
      begin
        SetIndiDate(lIndID, evt_Birth, lDate);
        SetIndiData(lIndID, evt_Birth, 'totgeboren');
        if (lPlace <> '') then
            SetIndiPlace(lIndID, evt_Birth, lPlace);
        SetIndiDate(lIndID, evt_Death, lDate);
        if (lPlace <> '') then
            SetIndiPlace(lIndID, evt_Death, lPlace);
      end
    else
    if (lEntryType in [evt_Marriage, evt_Divorce]) then
      begin
        if lFamRef = '' then
          if lIndID[length(lIndID)] in Ziffern then
            lFamRef := lIndID.Remove(0, 1)+'P0'
          else
            lFamRef := lIndID.Remove(0, 1)+'0';
        StartFamily(lFamRef);
        if lSubstring.StartsWith(csMarrPartKN+' ') then
          begin
            lIndID2 := HandleAKPersonEntry(copy(lSubString,4),lFamref,'U',57,lLastname,lSex);
          end
        else lSex:= 'F';
        if lSex='M' then
          SetFamilyMember(lFamRef, lIndID, 2)
        else
          SetFamilyMember(lFamRef, lIndID, 1);
        if (lDate <> '') then
            SetFamilyDate(lFamRef, lEntryType, lDate);
        if (lPlace <> '') then
            SetFamilyPlace(lFamRef, lEntryType, lPlace);
        if (lData <> '') or ((lDate = '') and (lPlace = '')) then
            SetFamilyData(lFamRef, lEntryType, lData);
      end
    else
    if (lEntryType > evt_ID) and (lEntryType <> evt_last) and (lEntryType <> evt_Occupation) then
      begin
        if (lDate <> '') then
            SetIndiDate(lIndID, lEntryType, lDate);
        if (lPlace <> '') then
            SetIndiPlace(lIndID, lEntryType, lPlace);
        if (lData <> '') then
            SetIndiData(lIndID, lEntryType, lData);
      end
    else
      begin
        if TestEntry(lSubString,CLedigKN,lRest) then
          begin
            lSubString:=lRest;
            SetIndiData(lIndID, evt_Description, csLedig);
          end;
        lEntryType := evt_Occupation;
        if Testfor(trim(lSubString), 1, CTitel) then
            SetIndiName(lIndID, 4, trim(lSubString))
        else
        if (lSubString <> '') then
            SetIndiOccu(lIndID, lEntryType, trim(lSubString))
        else if (lDate <> '') then
            warning(self,'Entry contains no Marker, only a Date');
        if (lDate <> '') then
            SetIndiDate(lIndID, lEntryType, lDate);
        if (lPlace <> '') then
            SetIndiPlace(lIndID, lEntryType, lPlace);
      end;
    Result := lEntryType;
end;

procedure TFBEntryParser.HandleFamilyFact(
  const lMainFamRef: string;const lFamEntry: string);
var
  lEntryType: TenumEventType;
  lPlace, lSubString, lDate, lData: String;
  ldPos, lpp, lpp2, lpos: SizeInt;
  lPlacBesch: Boolean;
  lpl, lFound: Integer;
begin
   Debug(self, 'HFF: "' + lFamEntry + '"');
    lSubString := trim(lFamEntry);
    if (lSubString = '') or (lSubString = '.') then
        exit;

    AnalyseEntry(lSubString,lEntryType,lData,lPlace,lDate);

  if lDate <>'' then
    SetFamilyDate(lMainFamRef,lEntryType,lDate);
  if (lPlace <>'') and (lEntryType<>evt_last) then
    SetFamilyPlace(lMainFamRef,lEntryType,lPlace);
  if (lData <>'') or ((lDate='')and (lPlace='') and (lEntryType<>evt_last)) then
     SetFamilyData(lMainFamRef,lEntryType,lData)
  else if (lSubString<>'') and (lEntryType=evt_last) then
    begin
      if (lPlace <>'') then
        SetFamilyPlace(lMainFamRef,evt_Residence,lPlace);
      SetFamilyData(lMainFamRef,evt_Residence,lSubString)
    end
end;

function TFBEntryParser.HandleGCDateEntry(const aText: string;
    var ppos: int64; lIndID: string; var lMode, lRetMode: integer;
    var aEntrytype: TenumEventType): boolean;

    function TestDate(const lTestStr: string; const lSetEvent: TenumEventType): boolean;

    begin
        Result := testfor(aText, pPos, lTestStr);
        if Result then
          begin
            lRetMode := lMode;
            lMode := 101;
            aEntryType := lSetEvent;
          end;
    end;

begin
    {$ifdef DEBUG}
    Debug(self, 'HGDE: "' + copy(atext, ppos, 30) + '"');
    {$endif}
    Result := False;
    if TestDate(csBirth, evt_Birth) or
        TestDate(csBaptism2, evt_Baptism) or
        TestDate(csDeathEntr, evt_Death) or
        TestDate(csBurial2, evt_Burial) then
        exit(True)
    else if TestForC(aText, pPos, csDeathGefEntr) then
      begin
        lRetMode := lMode;
        lMode := 101;
        Inc(pPos, length(csDeathGefEntr) - 1);
        SetIndiData(lIndID, evt_Death, csDeathGefEntr);
        aEntryType := evt_Death;
        Result := True;
      end
    else if TestForC(aText, pPos, csDeathVermEntr) then
      begin
        lRetMode := lMode;
        lMode := 101;
        Inc(pPos, length(csDeathVermEntr) - 1);
        SetIndiData(lIndID, evt_Death, csDeathVermEntr);
        aEntryType := evt_Death;
        Result := True;
      end;
end;

procedure TFBEntryParser.SetonFamilyIndiv(AValue: TParseEvent);
begin
    if FonFamilyIndiv = AValue then
        Exit;
    FonFamilyIndiv := AValue;
end;

procedure TFBEntryParser.SetonFamilyPlace(AValue: TParseEvent);
begin
    if FonFamilyPlace = AValue then
        Exit;
    FonFamilyPlace := AValue;
end;

procedure TFBEntryParser.SetonFamilyType(AValue: TParseEvent);
begin
    if FonFamilyType = AValue then
        Exit;
    FonFamilyType := AValue;
end;

procedure TFBEntryParser.SetonIndiData(AValue: TParseEvent);
begin
    if FonIndiData = AValue then
        Exit;
    FonIndiData := AValue;
end;

procedure TFBEntryParser.SetonIndiDate(AValue: TParseEvent);
begin
    if FonIndiDate = AValue then
        Exit;
    FonIndiDate := AValue;
end;

procedure TFBEntryParser.SetonIndiName(AValue: TParseEvent);
begin
    if FonIndiName = AValue then
        Exit;
    FonIndiName := AValue;
end;

procedure TFBEntryParser.SetonIndiOccu(AValue: TParseEvent);
begin
    if FonIndiOccu = AValue then
        Exit;
    FonIndiOccu := AValue;
end;

procedure TFBEntryParser.SetonIndiPlace(AValue: TParseEvent);
begin
    if FonIndiPlace = AValue then
        Exit;
    FonIndiPlace := AValue;
end;

procedure TFBEntryParser.SetonIndiRef(AValue: TParseEvent);
begin
    if FonIndiRef = AValue then
        Exit;
    FonIndiRef := AValue;
end;

procedure TFBEntryParser.SetonIndiRel(AValue: TParseEvent);
begin
    if FonIndiRel = AValue then
        Exit;
    FonIndiRel := AValue;
end;

procedure TFBEntryParser.SetonParseError(AValue: TNotifyEvent);
begin
    if FonParseError = AValue then
        Exit;
    FonParseError := AValue;
end;

procedure TFBEntryParser.SetonParseMessage(AValue: TParseMsgEvent);
begin
    if FonParseMessage = AValue then
        Exit;
    FonParseMessage := AValue;
end;

procedure TFBEntryParser.SetonStartFamily(AValue: TParseEvent);
begin
    if FonStartFamily = AValue then
        Exit;
    FonStartFamily := AValue;
end;

procedure TFBEntryParser.StartFamily(var lFamRef: string);
begin
    if Assigned(FonStartFamily) then
        FonStartFamily(self, lFamRef, '', 0);
end;

class function TFBEntryParser.TestFor(const aText: string; pPos: int64;
  const aTest: string): boolean;
begin
    Result := copy(aText, pPos, length(aTest)) = aTest;
end;

class function TFBEntryParser.TestForC(const aText: string; pPos: int64;
    const aTest: string): boolean;
begin
    Result := LowerCase(copy(aText, pPos, length(aTest))) = LowerCase(aTest);
end;

procedure TFBEntryParser.AnalyseEntry(var lSubString: string; out
  lEntryType: TenumEventType; out lData, lPlace, lDate: string);
var
  lPlacBesch: boolean;
  lpl: integer;
  lFound: integer;
  lpp2: integer;
  lPos: integer;
  lpp, lfound2: integer;
  ldPos, lpp3: SizeInt;
  lPlace0, lRest: String;
begin
  lEntryType := evt_Anull;
  lDate:='';

  ldPos := lSubString.LastIndexOfAny(csZiffern);
    if ldpos >= 0 then
        Inc(ldPos);

  lPlacBesch := False;
  lpp2:=-1;
  if Testfor(lSubString, ldPos + 2, CPlaceKN, lFound) then
    begin
      lPlace := trim(copy(lSubString, ldPos + 2 + length(CPlaceKN[lFound])));
      lPlacBesch := (lPlace='') or (lPlace[1] in LowerCharset);
      if lPlacBesch then
        begin
          lPlace := '';
          lData := lSubString;
          if ldPos < 0 then
              lEntryType := evt_Residence;
        end
      else if ldPos < 0 then
        begin
          lEntryType := evt_Residence;
          lSubString := '';
        end
      else
          lSubString := trim(copy(lSubString, 1, ldPos + 1));
    end
  else
    begin
      lpp := (' ' + lSubString).IndexOf(' ' + csPlaceKenn + ' ');
      if lpp<0 then
        begin
          lpp := (' ' + lSubString).IndexOf(' ' + csPlaceKenn6 + ' ');
          lfound := 5;
          if lpp > 5 then lpp:=-1;
        end
      else
        lfound := 0;

      lpl := 1;
      if lpp < 0 then
        begin
          lpp := (csProtectSpace + lSubString).IndexOf(csProtectSpace +
              csPlaceKenn + ' ');
          if lpp>=0 then
            begin
              lpl := length(csProtectSpace);
              lfound := 0;
            end;
        end;
      lpp2 := lSubString.IndexOfAny(csZiffern);
      // 1. Platz Kennung
      if (lpp >= 0) and (lpp2 < lpp)
          and  ((length(lsubstring) < lpp + length(csPlaceKenn) + 3) or
          (lsubstring[lpp + length(csPlaceKenn) + 3] <> 'd')) then
        begin
          lPlace := copy(lSubString, lpp + 4);
          lSubString := copy(lSubString, 1, lpp - lpl);
          if lSubString = '' then
            lEntryType := evt_Residence;
        end
      else if (lpp >= 0) and (lpp2 > lpp) then
        begin
          lPlace := trim(copy(lSubString, lpp+ 4, lpp2 - lpp - 4));
          if length(lSubString)-lpp2 < 7 then
            TrimPlaceByMonth(lPlace);
          TrimPlaceByModif(lPlace);
          lSubString := copy(lSubString, 1, lpp) + copy(lSubString, lpp
            + 4+ length(lPlace));
          lpp2 := lSubString.IndexOfAny(csZiffern);
        end
      else
        begin
          lpp := pos(' ' + csPlaceKenn2 + ' ', ' ' + lSubString);
          // 2. Platz Kennung
          if lpp <> 0 then
            begin
              lfound := 1;
              lPlace := copy(lSubString, lpp + 4);
              lSubString := copy(lSubString, 1, lpp - 1);
              if lSubString = '' then
                  lEntryType := evt_Residence;
            end
          else
              lPlace := '';
        end;
    end;

  if lEntryType <> evt_Residence then
      lEntryType := GetEntryType(lSubString, lDate, lData);
  if (lEntryType = evt_Last) and (lFound >= 0) then
      lEntryType := GetEntryType(lSubString + ' ' + CPlaceKN[lFound] + ' ' +
        lPlace, lDate, lData);

  if (lEntryType = evt_Description) and (lplace<>'') and testfor(lsubstring,1,CArtikelU,lfound2) then
    // ein Hirt aus Dada
    begin
      lEntryType:=evt_Occupation;
      lsubstring:=trim(copy(lSubString,length(CArtikelU[lfound2])+1));
    end;

  lpp := lData.IndexOf(csPlaceKenn3);
  if (lpp >= 0) and (lEntryType = evt_AddEmigration) then
    begin
      lpp2 := lData.IndexOfAny(csZiffern);
      lPlace := trim(copy(lData, lpp + length(csPlaceKenn3) + 1));
      if lpp2 < 0 then
         ldate := ''
      else
         begin
            lRest := trim(copy(ldata, 1, lpp2));
            TrimPlaceByMonth(lRest);
            TrimPlaceByModif(lrest);
            lDate := trim(copy(ldata, length(lRest)+1, lpp - length(lRest)));
         end;
      if Length(ldata) < Length(lSubString) then
          lData := lSubString
      else
          ldata := lData + ' ' + csEmigration;
    end;

  if (lEntryType= evt_Property) and not IsValidPlace(lPlace) then
    begin
      lData := lData+ ' ' + CPlaceKN[lFound] + ' '+lPlace;
      lPlace := '';
    end;

  if ((trim(lPlace) = '') or not IsValidDate(ldate) or (length(ldate)>14)) and (lEntryType in [evt_Birth..evt_Burial,
    evt_Stillborn, evt_fallen,
      evt_missing]) and (length(lDate) > 1)
      and ((lDate[1] in ['A'..'Z']) or TestFor(lDate,1,CUmLautsU)or TestFor(lDate,1,CUnknownKN)) then
    begin  // 2. Platz Angabe

      if (trim(lPlace) <> '') then
        lPlace0 :=  lPlace
      else
        lPlace0:='';
      lpp2 := ldate.IndexOfAny(csZiffern);
      if TestFor(lDate,1,CUnknownKN,lfound2) then
        begin
          lPlace := CUnknownKN[lfound2];
          lDate := trim(copy(lDate, length(lPlace) + 1));
        end
      else if (lpp2>1) and (ldPos>length(lDate)) then
        begin
          lPlace := trim(Leftstr(lDate, lpp2));
          if length(lDate)-lpp2 < 7 then
            TrimPlaceByMonth(lPlace);
          TrimPlaceByModif(lPlace);
          lDate := trim(copy(lDate, length(lPlace) + 1));
          if (lPlace ='') then
             lPlace :=  lPlace0
          else if trim(lplace0)<>'' then
            lPlace := lPlace+' '+CPlaceKN[lFound] + ' ' +lPlace0;
        end
      else if (lpp2=-1) and (lPlace0='') then // keine Ziffer -> kein datum
         begin
           lplace:=ldate;
           ldate:='';
         end
      else
        begin // ??
      if length(ldate) > 12 then
          lpos := ldate.IndexOf(' ', length(ldate) - 12)
      else
          lpos := ldate.lastIndexOf(' ');
      if lpos > 0 then
        begin
          lPlace := Leftstr(lDate, lpos);
          lDate := copy(lDate, lpos + 2);
        end;
        end;
    end
  else  if (lpp2 >=0) and (lData='') and (lDate='') then
    begin
      lpp3 := lSubString.LastIndexOfAny(csZiffern);
      if (lpp3=lpp2) or (lpp3=lpp2+1)or (lpp3=lpp2+2) then
      else if not (lSubString[lpp3-2] in Ziffern)
          or not (lSubString[lpp3-1] in Ziffern)
          or not (lSubString[lpp3] in Ziffern) then
      else if copy(lSubString,lpp2+3,lpp3-lpp2-9).Contains(' ') then
      else if (lpp2 = 0) and lsubstring.Contains('Jahre') then
      else begin
      lRest := trim(Leftstr(lSubString, lpp2));
      if length(lRest)-lpp2 < 7 then
         TrimPlaceByMonth(lRest);
      TrimPlaceByModif(lRest);
      lDate := trim(copy(lSubstring, length(lRest) + 1,lpp3-length(lRest)+1));
      lSubString:=trim(lRest+copy(lSubString,lpp3+2));
      end;
    end;

  if lEntryType = evt_Marriage then
    begin
      if ldate.StartsWith(csMarrPartKN+' ') and (lpp2<0) then
        begin
          lsubstring:= lDate;
          ldate:= '';
        end;
      if lDate.contains(' '+csMarrPartKN+' ') and (lpp2>=0) then
        begin
          lSubString:=copy(lDate,lDate.IndexOf(csMarrPartKN)+1);
          lDate := trim(copy(lDate,1,length(ldate)-length(lsubstring)));
        end;

    end;

  // trim "im" und "am" bei Datum
  if ldate.StartsWith(csPlaceKenn6+' ') or ldate.StartsWith(csPlaceKenn4+' ') then
    ldate := copy(ldate,length(csPlaceKenn4)+2);

  if (trim(lPlace) = '')
      and not (Fmode in [55, 56, 57])
      and not lPlacBesch
      and (lEntryType<>evt_Divorce) then
      lPlace := FDefaultPlace;

  if not IsValidPlace(lPlace) then
    begin
      warning(self, 'Misspelled Place "' + lPlace + '"');
      while (lPlace <> '') and not (lPlace[1] in Charset) do
          lPlace := lPlace.Remove(0, 1);
    end;
  {                        if (length(ldate) > 3) and (lDate[length(ldate)] = '.') then
                            ldate := copy(lDate, 1, length(ldate) - 1);    }
  if lEntryType in [evt_fallen, evt_missing] then
      lEntryType := evt_Death;
end;

procedure TFBEntryParser.TrimPlaceByMonth(var lPlace: string);

var i: integer;
  lflag: Boolean;

begin
  lflag := false;
  for i := 1 to high(CMonthKN) do
     if lplace.EndsWith(CMonthKN[i]) then
       begin
         lPlace := trim(copy(lPlace, 1, length(lPlace)-length(CMonthKN[i])));
         lflag := true;
         break;
       end
     else if lplace.EndsWith(copy(CMonthKN[i],1, 3)+'.') then
       begin
         lPlace := trim(copy(lPlace, 1, length(lPlace)-4));
         lflag := true;
         break;
       end;
  if lFlag and (' '+lplace).EndsWith(' '+csPlaceKenn6) then
     lPlace := trim(copy(lPlace, 1, length(lPlace)-3));
end;

procedure TFBEntryParser.TrimPlaceByModif(var lPlace: string);
var
  i: Integer;
begin
    for i := 1 to high(CDateModif) do
       if (' '+lplace).EndsWith(' '+CDateModif[i]) then
         begin
           lPlace := trim(copy(lPlace, 1, length(lPlace)-length(CDateModif[i])));
           break;
         end
end;

function TFBEntryParser.TestReferenz(const aRef: string): boolean;
var
  i: Integer;
begin
  //Referent ist nicht leer
  if aRef='' then exit(false);
  //Referenz Beginnt mit Zahlen
  result := aRef[1] in Ziffern;
  //Referenz enthält nur Zahlen
  for i := 2 to length(aRef)-1 do
      result := result and (aRef[i] in Ziffern);
  //letzte Stelle kann außer Zahlen noch a oder b enthalten
  result := result and (aRef[length(aRef)] in Ziffern+['a','b']);
end;


class function TFBEntryParser.TestFor(const aText: string; pPos: int64;
    const aTest: array of string; out Found: integer): boolean;
var
    i: integer;
begin
    Found := -1;
    Result := False;
    for i := 0 to high(Atest) do
        if TestFor(aText, ppos, atest[i]) then
          begin
            Found := i;
            exit(True);
          end;
end;

class function TFBEntryParser.TestFor(const aText: string; pPos: int64;
    const aTest: array of string): boolean;
var
    lFound: integer;
begin
    Result := TestFor(aText, ppos, atest, lFound);
end;

constructor TFBEntryParser.Create;
begin
    GNameHandler.Init;
    GNameHandler.onError:=@GNameError;

    FUmlauts := CUmlauts;
    FAkkaTitel := CAkkaTitle;
end;

destructor TFBEntryParser.Destroy;
begin
    GNameHandler.Done;
    inherited Destroy;
end;

function TFBEntryParser.TestEntry(lSubString, TestStr: string;
    out Data: string): boolean;

begin
    Result := copy(lSubString, 1, length(TestStr)) = TestStr;
    if Result then
        if lSubString=TestStr then
          Data:= ''
        else if testfor(lSubString, length(TestStr) + 1, csProtectSpace) then
            Data := trim(copy(lSubString, length(TestStr) +
                length(csProtectSpace) + 1))
        else if testfor(lSubString, length(TestStr) + 1, ' ') then
            Data := trim(copy(lSubString, length(TestStr) + 2))
        else if not ((TestStr+' ')[length(TestStr)] in AlphaNum)
            and (((copy(lSubString, length(TestStr)+1)+' ')[1] in AlphaNum) or
            testfor(lSubString,length(TestStr),CUmLautsU)) then
             Data := trim(copy(lSubString, length(TestStr)+1))
        else
           result := false; //??
end;

function TFBEntryParser.TestEntry(lSubString:string;const TestStra: array of string;
    out Data: string): boolean;overload;

var
  lTestStr: String;
begin
    for lTestStr in TestStra do
        begin
    Result := testfor(lSubString, 1, lTestStr);
    if Result then
        if lSubString=lTestStr then
          Data:= ''
        else if testfor(lSubString, length(lTestStr) + 1, csProtectSpace) then
            Data := trim(copy(lSubString, length(lTestStr) +
                length(csProtectSpace) + 1))
        else if testfor(lSubString, length(lTestStr) + 1,' ') then
            Data := trim(copy(lSubString, length(lTestStr) + 2))
        else if not ((lTestStr+' ')[length(lTestStr)] in AlphaNum)
            and (((copy(lSubString, length(lTestStr)+1)+' ')[1] in AlphaNum) or
            testfor(lSubString,length(lTestStr),CUmLautsU)) then
             Data := trim(copy(lSubString, length(lTestStr)+1))
        else
            Result := false;
        if result then break;
        end;

end;

function TFBEntryParser.GetEntryType(lSubString: string;
    out Date, Data: string): TenumEventType;

var
    lSubString2: string;
    lFound: integer;
    lpp: SizeInt;
begin
    Result := evt_Last;
    Data := '';
    Date := '';
    if TestEntry(lSubString, [csBaptism,csBaptism2], Date) then
        Result := evt_Baptism
    else
    if TestEntry(lSubString, csBirth, Date) then
        Result := evt_Birth
    else
    if TestEntry(lSubString, [csBurial,csBurial2], Date) then
        Result := evt_Burial
    else
    if TestEntry(lSubString, CMarriageKN, Date) then
        Result := evt_Marriage
    else
    if TestEntry(lSubString, [csDeathEntr,csDeathEntr2], Date) then
      begin
        Result := evt_Death;
      end
    else if TestEntry(lSubString, [csDeathEntr+csBirth,csDeathEntr2+csBirth], Date) then
          begin
            Result := evt_Stillborn;
            Data := 'totgeboren';
          end
    else if TestEntry(lSubString, csDeathGefEntr, Date) then
      begin
        Result := evt_fallen;
        Data := csDeathGefEntr;
      end
    else if TestEntry(lSubString, csDivorce, Date) then
      begin
        Result := evt_Divorce;
      end
    else if TestEntry(lSubString, [csDeathVermEntr, csDeathVermEntr2], Date) then
      begin
        Result := evt_missing;
        Data := csDeathVermEntr;
      end
    else if lSubString.Contains(csEmigration) or
       lSubString.Contains(csEmigration2) then
      begin
        Result := evt_AddEmigration;
        if lSubString.StartsWith('ist') then
            lSubString2 := lSubString.Remove(0, 4)
        else
            lSubString2 := lSubString;
        Data := left(lSubString2, length(lSubString2) - length(csEmigration) - 1);
      end
    else if lSubString.EndsWith(' '+csAge) then
      begin
        Result := evt_Age;
        Data := lSubstring;
      end
    else if TestEntry(lSubString,CArtikelU,Data) then
      begin
        Result := evt_Description;
        Data:=lSubString;
      end
    else if lSubString.Contains(csGenannt) then
      begin
        Result := evt_AKA;
        if lSubString.StartsWith(csWurde) then
            lSubString2 := trim(lSubString.Remove(0, length(csWurde)))
        else
            lSubString2 := lSubString;
        lpp := lSubString2.IndexOf(csGenannt);
        Data := trim(trim(left(lSubString2, lpp))+' '+trim(copy(lSubString2,lpp+length(csGenannt)+1)));
      end
    else if TestEntry(lSubString,CArtikelB,Data) then
      begin
        Result := evt_AKA;
        Data:=lSubString;
      end
    else if testfor(lSubString,1,CDescriptKN,lFound)
       and (CDescriptKN[lFound]=lSubString) then
      begin
        Result := evt_Description;
        Data := lSubString;
      end
    else if TestFor(lSubString, 1, CResidenceKN, lFound) then
      begin
        Result := evt_Residence;
        Data := CResidenceKN[lFound];
        Date := trim(lSubString.Substring(length(Data)));
        if (Date <> '') and not Date.StartsWith(csPlaceKenn+' ') and not
            (Date.StartsWith(csDateModif4+' ')) and not (Date[1] in Ziffern) then
          begin
            Data := Data + ' ' + Date;
            Date := '';
//            Result := evt_Residence;
          end;
      end
    else if lSubString.IndexOfAny(CPropertyKN)>0 then
      begin
        Result := evt_Property;
        Data := lSubString;
      end
    else if (lSubString.indexofAny(CAddressKN)>0)
       and ((lSubString[1] in UpperCharset) or testfor(lSubString,1,CUmLautsU))
       and (lSubString.CountChar(' ') <2) then
      begin
        Result := evt_Residence;
        Data := lSubString;
      end
    else if TestFor(lSubString+'.', 1, CReligions, lFound) then
      begin
        Result := evt_Religion;
        Data := CReligions[lFound];
      end;
end;

function TFBEntryParser.HandleGCNonPersonEntry(const aSubString: string;
    const ActChar: char; const lIndID: string): boolean;

var
    lpp: integer;
    lPlace, lData, lSubString: string;

begin
    Result := False;
    lSubString := aSubString;
    if ((length(lSubString) < 4) and lSubString.EndsWith('.') and
        (lsubstring[1] in ['a'..'z'])) or (length(trim(lSubString)) = 2) then
      begin // Religions-eintrag
        if (ActChar = '.') then
            lSubstring := lSubString + '.';
        SetIndiData(lIndID, evt_Religion, trim(lSubString));
        exit(True);
      end
    else if length(lSubString) > 2 then
      begin
        lpp := pos(' in ', lSubString);
        if lpp <> 0 then
          begin
            lPlace := copy(lSubString, lpp + 4, 255);
            lSubString := copy(lSubString, 1, lpp - 1);
          end
        else
            lPlace := FDefaultPlace;

        for lData in lSubString.Split([',']) do
            if trim(lData) = 'Bürger' then
              begin
                SetIndiData(lIndID, evt_Residence, trim(lData));
                if lPlace <> '' then
                    SetIndiPlace(
                        lIndID, evt_Residence, trim(lPlace));
              end
            else if trim(lData) = csEmigration then
              begin
                SetIndiData(lIndID, evt_AddEmigration, '');
                if lPlace <> '' then
                    SetIndiPlace(
                        lIndID, evt_AddEmigration, trim(lPlace));
              end
            else if TestFor(trim(lData), 1, CTitel) then
              begin
                SetIndiName(lIndID, 4, trim(lData));
                if lPlace <> '' then
                    SetIndiPlace(
                        lIndID, evt_Occupation, trim(lPlace));
              end
            else
              begin
                SetIndiOccu(lIndID, evt_Occupation, trim(lData));
                if lPlace <> '' then
                    SetIndiPlace(
                        lIndID, evt_Occupation, trim(lPlace));
              end;
        Result := True;
      end;
end;

function TFBEntryParser.BuildName2(const aText: string; var aOffset: int64;var lCharCount:integer;
  var lSubString:string;out lAdditional: string): boolean;

var lFound:integer;

begin
        Result := true;
        lAdditional := '';
        if aText[aOffset] in Charset then
          begin
            lSubString := lSubstring + aText[aOffset];
            Inc(lCharCount);
          end
        else if aText[aOffset] = ' ' then
          begin
            lSubString := lSubstring + aText[aOffset];
            lCharCount := 0;
          end
        else if testfor(aText, aOffset, csProtectSpace) then
          begin
            lSubString := lSubstring + csProtectSpace;
            Inc(aoffset, length(csProtectSpace) - 1);
            lCharCount := 0;
          end
        else if copy(aText, aOffset, length(csUnknown)) = csUnknown then
          begin
            lSubString := lSubstring + csUnknown;
            Inc(aOffset, Length(csUnknown) - 1);
            lCharCount := 0;
          end
        else if (aText[aOffset] = '.') and
            ((aText[aOffset + 1] in [csSeparator,'.',' ','>']) or
              TestFor(aText,aOffset + 1,csSeparator2) or
            ((aText[aOffset - 1] in Charset+['.']) and
            ((lCharCount <= 3) or (aText[aOffset + 1] in UpperCharset)))) then
            lSubString := lSubstring + aText[aOffset]
        else if Testfor(aText, aOffset, ['-'], lFound) and
            (aText[aOffset - 1] in LowerCharset) and
            (aText[aOffset + 1 + lFound] in UpperCharset) then
          begin
            // Namen wie 'Hans-Peter'
            lSubString := lSubstring + aText[aOffset];
            lCharCount := 0;
          end
        else if Testfor(aText, aOffset, ['-', '­'], lFound) and
            (aText[aOffset - 1] in LowerCharset) and
            (aText[aOffset + 1 + lFound] in LowerCharset) then
          begin
            // Warnung nur bei "normalem" Bindestrich
            if lfound = 0 then
                Warning(self, 'Hyphen in Name Ignored');
            lCharCount := 0;
            Inc(aoffset, lFound);
          end
        else if testfor(aText, aOffset, FUmlauts) then
          begin
            lSubString :=
                lSubstring + aText[aOffset] + atext[aOffset + 1];
            Inc(lCharCount);
            Inc(aOffset);
          end
        else if testfor(aText, aOffset, csSeparator2) then
           begin
             Result := false;
             inc(Offset,length(csSeparator2)-1);
           end
        else Result:= Testfor(aText, aOffset, '(') and ParseAdditional(aText,
            aOffset, lAdditional);
end;

procedure TFBEntryParser.Feed(aText: string);

var
    lCharCount: integer;
    lAKA: string;
    lAddEvent: TenumEventType;

    function BuildName(const aText: string; var Offset: int64;
    var lSubString,lData: string): boolean;

    var
        lAdditional: string;

    begin
        Result := False;

        if BuildName2(aText,Offset,lCharCount,lSubString,lAdditional) then
          begin
            if (lAdditional = csTwin) then
              begin
                if ldata = '' then
                    lData := 'Zwilling'
                else
                    lData := lData + '; Zwilling';
              end
            else if (lAdditional <>'') then
              begin
                lAKA := lAdditional;
                lAddEvent := evt_AKA;
                lCharCount := 0;
              end;
          end
        else
            Result := length(trim(lSubString)) > 0;
    end;

var
    lLastZiffCount:integer;
    lFamDatFlag: boolean;
    lEntryEndFlag: boolean;
    lMainFamRef: string;  // Haupt-Familienreferenz
    lEntryType: TenumEventType;

    function BuildData(const lIndID, aText: string; var Offset: int64;
    var lSubString:string;var lData: string): boolean;

    var
        lFound: integer;
        lAdditional: string;

    begin
        Result := False;
        if not (aText[Offset] in ['<', ';', ':', '.', csSeparator, '(', '>',
            #10, #13,csBirth, csDeathEntr[1], '­'[1]]) then
            lSubString := lSubstring + aText[Offset]
        else if (Offset < Length(aText) - 1) and (aText[Offset] = '.') and
           // Behandle "."
            (((lSubstring <> '')
              and ((atext[Offset + 1] in Ziffern))
            or ((lSubstring <> '')
              and not (lSubstring[length(lsubstring)] in Ziffern)
              and (atext[Offset + 1] = ' ')
              and (atext[Offset + 2] in Charset))
            or (atext[Offset + 1] in ['-',csSeparator, '/'])
            or TestFor(atext,Offset + 1, csSeparator2)
            or (atext[Offset + 1] in Charset)
            or ((atext[Offset + 1] = ' ') and lSubstring.endswith('Dr'))
            or ((atext[Offset + 1] = ' ') and lSubstring.endswith('rl'))
            or ((atext[Offset + 1] = ' ') and lSubstring.endswith('Nr'))
            or ((atext[Offset + 1] = ' ') and lSubstring.endswith('gl'))
            or ((atext[Offset + 1] = ' ') and lSubstring.endswith('tr'))
            or ((atext[Offset + 1] = ' ') and lSubstring.endswith('Kr'))
            or ((atext[Offset + 1] = ' ') and lSubstring.endswith('Kt'))
            or (atext[Offset + 1] = '.')
            or lSubString.EndsWith('.')
            or ((atext[Offset + 1] = ' ')
              and not (atext[Offset + 2] in [#10,#13])
              and (lLastZiffCount < 3)))) then
            lSubString := lSubstring + aText[Offset]
        else if testfor(aText,offset,CUnknownKN,lFound) then
           begin
             lSubString := lSubstring + CUnknownKN[lFound];
             inc(offset,length(CUnknownKN[lFound])-1);
           end
        else if (aText[Offset] = ',')
           // falsch geschriebenes Datum (, anstatt .)
           and (aText[Offset-1] in Ziffern)
           and (((aText[Offset+1] in Ziffern)
               and (aText[Offset+2] in Ziffern))
             or ((aText[Offset+1] =' ')
               and (aText[Offset+2] in Ziffern)
               and (lLastZiffCount<3)))  then
            begin
              lSubString := lSubstring + '.' ;// Korrektur
              Warning(self,'Misspelled Date');
            end
        else if testfor(aText,Offset,[csSeparator2,csSeparator],lFound)
           and (not lSubstring.Contains(' ')) // Einzelnes Wort
           and (TestFor(aText,Offset+1,[' Kr.',' Kreis',' Kt.',' Kanton'])) then // Ergänzend: Kreis
            begin
              lSubString := lSubstring + csSeparator ;
              if lfound =0 then
                  inc(offset,length(csSeparator2)-1);
            end
        else if testfor(aText,Offset,[csSeparator2,csSeparator],lFound)
           and (aText[Offset-1] in Ziffern)
           and (aText[Offset+1] in Ziffern) then
            begin
              lSubString := lSubstring + csSeparator ;
              if lfound =0 then
                  inc(offset,length(csSeparator2)-1);
            end
        else if Testfor(aText, Offset, ['-'], lFound) and
            (aText[Offset - 1] in LowerCharset) and
            (aText[Offset + 1 + lFound] in UpperCharset) then
          begin
            // Einträge wie 'Mattenwag-Siedlung'
            lSubString := lSubstring + aText[Offset];
          end
        else if Testfor(aText, Offset, CHyphens, lFound) and
            (aText[Offset - 1] in LowerCharset) and
            (aText[Offset + length(CHyphens[lFound])] in (LowerCharset+['ß'[1]])) then
          begin
            // Warnung nur bei "normalem" Bindestrich
            if lFound = 0 then
                Warning(self, 'Hyphen in Data Ignored');
            Inc(offset, length(CHyphens[lFound])-1);
          end
        else if TestFor(aText, offset, FUmlauts, lFound) then
          begin
            lSubString := lSubstring + FUmlauts[lFound];
            Inc(Offset, length(FUmlauts[lFound]) - 1);
          end
        else if TestFor(aText, offset, '“') then
          begin
            lSubString := lSubstring + '“';
            Inc(Offset, length('“') - 1);
          end
        else if Testfor(aText, Offset, [csBirth, csDeathEntr, csDeathEntr2]) then
          if ((length(trim(lSubString)) < 2)
            or ((length(trim(lSubString)) < 4) and Testfor(lSubstring, 1, [csBirth, csDeathEntr, csDeathEntr2]) )) then
              begin
                lSubString := lSubstring + aText[Offset]
              end
          else
          begin
            lEntryType := HandleNonPersonEntry(lSubString, lIndID);
            Error(self, ', Expected (End of Entry)');
            lSubString := '';
            Dec(offset);
          end
        else if (aText[Offset] = csProtectSpace[1]) and (length(lSubString) < 5) then
           // Sonderzeichen like
            lSubString := lSubstring + aText[Offset]
        else if Testfor(aText, Offset, '(')
           and ParseAdditional(aText, Offset, lAdditional) then
          begin
            // inc(Offset);
            ldata := lAdditional;
            lAdditional := '';
            if ldata.StartsWith(csDivorce) then
              begin
                lData := lData.Remove(0, 3);
                if not lFamDatFlag and (Fmode = 8) then
                   Error(self, 'Wife entry not ended with .');

                SetFamilyPlace(lMainFamRef, evt_Divorce, FDefaultPlace);
                if lData <> '' then
                    SetFamilyData(lMainFamRef, evt_Divorce, lData);
                lData := '';
              end
            else if lData.EndsWith(' alt') then
               begin
                 SetIndiData(lIndID,evt_Age,ldata);
                 ldata:='';
               end;
          end
        else if (aText[Offset] = '.')
           or ((aText[Offset] in [#10, #13])
             and (aText[Offset - 1] = '.'))
           or ((aText[Offset] in [#10, #13])
             and (aText[Offset - 1] = ' ')
             and (aText[Offset - 2] = '.')) then
          begin
            if FMode <> 9 then
              begin
                //                    lMode := 12;
                lFamDatFlag := True;
                Result := length(lSubString) > 1;
              end
            else
              begin
                lEntryEndFlag := True;
                Result := length(lSubString) > 1;
              end;
          end
        else
            Result := length(lSubString) > 1;
    end;

var
    lMode, lRetMode: integer;
    lData,
    lSubString, // Aktueller Unterstring
    {%H-}lDebug,  //DEBUG: String ab aktueller Position (20 Char)

    lIndID, // Aktuelle Personen-ID
    lParentRef, lFamName, lLastName, lChRef, lPersonName, lIndID2,
    lFamCEntry, lPlace, lDate, lEventDate, lChildFam, lFamRef,
    lPersonGName, lAdditional, lDefaultBirthplace, d, d2, lLastName2,
    lEntry: string;
    lPos, lChildCount, lFamType, lpp, lRetMode2, lRefMode2, lTest,
    lZiffCount, lRetMode3, lFound, lsPos, lSpouseCount: integer;
    lFirstEntry, lPlaceFlag, lSecondEntry, lParDeathFlag, lFirstCycle,
    lOtherMarrFlag, lVerwFlag, lMotherName: boolean;
    lEntryType2: TenumEventType;
    lPersonType, lPersonSex, lPersonSex2, lPersonType2: char;
    lInt, iDummy: longint;
    lStartOffset: int64;

begin
    Offset := 1;
    lMode := 0;
    fMode := 0;
    lMainFamRef := '';
    FMainRef := '';
    lPlace := '';
    lData := '';
    lEventDate := '';
    lSubString := '';
    lFamName := '';

    lZiffCount := 0;
    lCharCount := 0;
    lChildCount := 0;
    lRetMode2 := 0;

    lFirstCycle := True;
    lFirstEntry := True;
    while Offset <= length(atext) do
      begin
        case lMode of
            -1:
                if aText[Offset] in [#10, #13] then
                  begin
                    //                    lMode := 0;
                  end;
            0:
              begin
                lSubString := '';
                if aText[Offset] in AlphaNum then
                  begin
                    lMode := 1;
                    lSubString := lSubstring + aText[Offset];
                  end;
              end;
            1:
              begin  // EntryNumber
                if aText[Offset] in Whitespace+[':'] then
                  begin
                    lMode := 2;
                    lpp := lSubString.LastIndexOfAny(
                        ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a','b']);
                    if lpp > 0 then
                      begin
                        Dec(Offset, length(lSubString) - lpp);
                        lsubstring := left(lSubString, lpp + 1);
                      end;
                    if (lSubString = '') or not
                        (lSubString[1] in Ziffern) or lSubString.Contains('.') then
                      begin
                        error(self, 'Wrong Family reference, "' +
                            copy(atext, 1, 20) + '"');
                        lMainFamRef := '';
                        lMode := -1;
                      end
                    else if FMainRef = '' then
                      begin
                        StartFamily(lSubString);
                        lMainFamRef := lSubString;
                        FMainRef := lMainFamRef;
                      end;
                  end
                else
                    lSubString := lSubstring + aText[Offset];
              end;
            2:
                if (aText[Offset - 1] = ' ')
                   and (aText[Offset - 2] in Ziffern)
                   and not TestFor(aText, Offset, csMarriageGC)
                   and not TestFor(aText, Offset, csIllegChild)
                   and ((CharInSet(aText[Offset], UpperCharsetErw)
                       and (atext.IndexOf(' ',Offset) > atext.IndexOf(',',Offset)))
                   or
                       (CharInSet(aText[Offset], ['v'])
                       and (atext.IndexOf(' ',Offset+4) > atext.IndexOf(',',Offset+4))))
                   then
                  begin
                    // Einsprung zu GC
                    lMode := 110;
                    lSubString := '';
                    Dec(Offset);
                    lFamName := '';
                  end
                else
                  begin
                    lSubString := '';
                    if not (aText[Offset] in Whitespace) then
                      begin
                        lMode := 3;
                        lFamName := '';
                        lPersonType := 'U';
                        Dec(Offset);
                      end;
                  end;
            3:
              begin  // Entry Type
                lMotherName := false;
                if ((aText[Offset] in UpperCharset) or
                    TestFor(aText, Offset, FUmlauts)) and not
                    TestFor(aText, Offset, csMarriageGC) then
                  begin
                    SetFamilyType(lMainFamRef, 2);
                    lEntryType := evt_Residence;
                    lMode := 5; // Residence
                    Dec(Offset);
                  end
                else if (aText[Offset] in Whitespace + ['.', ':']) or
                    (length(lSubString) > 3) then
                  begin
                    if Testfor(lSubString, 1,
                        [csMarriageEntr, csMarriageEntr3, csMarriageEntr2]) then
                      begin
                        lMode := 10;
                        SetFamilyType(lMainFamRef, 1);
                        lSubString := '';
                        if aText[Offset] in[ '.' ,':'] then
                            Dec(Offset);
                        lEntryType := evt_Marriage;
                        lPersonType := 'M';
                      end
                    else
                    if (lSubString + aText[Offset] = csMarriageGC) then
                      begin
                        lMode := 101; // Datum evtl. Mit Ort
                        lRetMode := 100; // GC-Eintrag
                        lEntryType := evt_Marriage; // Marriage
                        lFamRef := lMainFamRef;
                        lFamCEntry := '';
                        lFamType := 1;
                        if length(atext) > Offset + 4 then
                          begin
                            if aText[Offset + 2] = csIllegChild2 then
                              begin
                                lFamType := 2;
                                Inc(Offset, 2);
                              end
                            else
                            if aText[Offset + 3] = '/' then
                              begin
                                lFamCEntry := copy(aText, Offset + 2, 3);
                                Inc(Offset, 4);
                              end;
                          end;
                        SetFamilyType(lMainFamRef, lFamType, lFamCEntry);
                        lSubString := '';
                      end
                    else
                    if TestFor(lSubString, 1, [csDeathEntr, csDeathEntr2]) then
                      begin
                        lMode := 20;
                        lEntryType := evt_Death;
                        SetFamilyType(lMainFamRef, 2);
                        lSubString := '';
                      end
                    else
                    if TestFor(lSubString, 1, csBirth) then
                      begin
                        lMode := 25;
                        lEntryType := evt_Birth;
                        SetFamilyType(lMainFamRef, 2);
                        lSubString := '';
                      end
                    else
                    if TestFor(lSubString, 1, csIllegChild) then
                    // Außereheliche(s) Kind(er), mit Namen des Vaters, wenn angegeben.
                      begin
                        lMode := 30;
                        lEntryType := evt_Birth;
                        SetFamilyType(lMainFamRef, 3);
                        Dec(Offset);
                        lSubString := '';
                      end
                    else
                    if TestFor(lSubString, 1, csIllegChild3) then
                    // Außereheliche(s) Kind(er), mit Namen der Mutter
                      begin
                        lMode := 30;
                        lEntryType := evt_Birth;
                        lMotherName := true;
                        SetFamilyType(lMainFamRef, 3);
                        Dec(Offset);
                        lSubString := '';
                      end
                    else
                      begin
                        lEntryType := evt_Residence;
                        dec(offset);
                        lMode := 40;
                      end;
                  end
                else if testfor(atext,offset,'fehlt') then
                  lMode := 4 //ende
                else
                    lSubString := lSubstring + aText[Offset];
              end;
            4: begin
                 if testfor(atext,offset,LineEnding) then
                   begin
                      EndOfEntry(lMainFamRef);
                      lMode := 0 //ende
                   end;
              end;
            5, 7:
              begin // Person
                // Init
                if lFirstCycle then
                  begin
                    lAKA := '';
                  end;

                if BuildName(aText, Offset, lSubString,lData) then
                  begin
                    lIndID := HandleAKPersonEntry(trim(lSubString),
                        lMainFamRef, lPersonType, lMode, lLastName, lPersonSex, lAKA);

                    if (lMode = 5) xor lMotherName then
                        lFamName := lLastName;

                    if (lmode = 5) and (lEntryType <> evt_Marriage) and
                        (lEntryType <> evt_Partner) then
                      begin
                        if lPlace = '' then
                            lPlace := FDefaultPlace;
                        if lData <> '' then
                            SetIndiData(lIndID, lEntryType, lData);
                        if lEventDate <> '' then
                            SetIndiDate(lIndID, lEntryType, lEventDate);
                        if lPlace <> '' then
                            SetIndiPlace(lIndID, lEntryType, lPlace);
                      end;

                    lSubString := '';
                    if aText[Offset] = '<' then
                      begin
                        lRetMode := lMode + 1;
                        lFamDatFlag := False;
                        lMode := 50;
                      end
                    else
                      begin
                        lMode := lMode + 1;
                        lSubString := '';
                        lAdditional := '';
                        lFamDatFlag := (atext[offset] <> ',');
                        lData := '';
                      end;
                    Dec(Offset);
                  end;
              end;
            6, 8:
              begin // Person-Info
                if aText[Offset] in Ziffern then
                    Inc(lZiffCount)
                else
                  begin
                    if lZiffCount > 0 then
                        lLastZiffCount := lZiffCount;
                    lZiffCount := 0;
                  end;

                if BuildData(lIndID, aText, Offset, lSubString,lData) then
                  begin
                    // Verarbeite Eintrag
                    if (right(trim(lSubString), 4) = ' alt') and
                        (trim(lSubString)[1] in Ziffern) and
                        (lEntryType = evt_Death) then
                      begin
                        SetIndiData(lIndID, lEntryType, trim(lSubString));
                        lSubString := '';
                        Continue;
                      end;

                    lEntryType := HandleNonPersonEntry(lSubString, lIndID);
                    lSubString := '';
                    lLastZiffCount :=0;
                    if lData <> '' then
                      begin
                        SetIndiData(lIndID, lEntryType, trim(lData));
                        lData := '';
                      end;
                    if not (aText[Offset] in ['.', ',', #10, #13, '<','('] ) then
                      begin
                        error(self, ', missing (End of Entry)');
                        dec(offset);
                      end;
                  end;

                if aText[Offset] = '<' then
                  begin
                    lRetMode := lMode;
                    lMode := 50;
                    Dec(Offset);
                  end
                else
                if (FMode = 6) and (aText[Offset] in whitespace) and
                    TestFor(atext, Offset + 1, [csSpouseKn + ' ', csSpouseKn2 + ' ','u, '],
                    lFound) and
                    ((aText[Offset - 1] in [',', #10, #13]) or (lFound = 0)) then
                  begin
                    if lFound = 1 then
                        warning(self, '"und" as Wife-Flag');
                    if lFound = 2 then
                        warning(self, '"u," as Wife-Flag');
                    lSubString := trim(lSubString);
                    if lSubString <> '' then
                      begin
                        HandleNonPersonEntry(lSubString, lIndID);
                        error(self, ', missing (last entry)');
                      end;
                    lmode := 7;
                    lPersonType := 'F';
                    Inc(Offset, 2 + lFound);
                    lSubString := '';
                  end
                else if (lSubString='')
                    and  (aText[offset] ='.') then
                  begin
                    if (FMode =6) and atext.Substring(offset,6).Contains('u.') then
                       Warning(self,'Husband entry ends with "."')
                     else if atext.Substring(offset,6).Contains(csBirth)
                        or atext.Substring(offset,6).Contains(csDeathEntr) then
                          Warning(self,'Entry ends with "." instead of ","')
                     else if (lMode = 6)
                        and (not atext.Substring(offset,5).Contains(LineEnding))
                          then
                            begin
                              Warning(self,'Entry ends with "." without Linefeed');

                            end
                    else
                      lMode := 12;
                  end
                else
                if (aText[Offset] in Ziffern + ['l', ')']) and
                    TestFor(atext, Offset + 1, [' Kd', 'Kd'], lFound) then
                  begin
                    //   Space is omittet by extractor (ToDo)
                    //                    if lFound = 1 then
                    //                        warning(self, 'Space missing');
                    if not lFamDatFlag then
                        if Fmode = 8 then
                            Error(self, 'Wife entry not ended with .')
                        else
                            Error(self, 'Person entry not ended with .');
                    if lData <> '' then
                      begin

                      end;
                    if aText[Offset] = 'l' then
                        Error(self, 'l misplaced as 1');
                    lSubString := trim(lSubString);
                    if GetEntryType(lSubString, d, d2) <> evt_last then
                        HandleNonPersonEntry(lSubString, lIndID);
                    lmode := 15;
                  end;
              end;
            9:
              begin  // Kinder
                if aText[Offset] in Ziffern then
                    Inc(lZiffCount)
                else
                  begin
                    if lZiffCount > 0 then
                        lLastZiffCount := lZiffCount;
                    lZiffCount := 0;
                  end;

                if (lSubString = '') and lFirstEntry then
                  begin
                    lAKA := '';
                    lLastZiffCount := 0;
                  end;

                if lFirstEntry
                    and Buildname(aText, Offset, lSubString,lData) then
                  begin
                    lPersonGName := trim(lSubString);
                    lPersonName := trim(lSubString) + ' ' + lFamName;
                    lPersonSex := GuessSexOfGivnName(trim(lSubString));

                    if aText[Offset] = '<' then
                      begin
                        lRetmode := lMode;
                        lMode := 50;
                        lChRef := '';
                        lPos := Offset + 1;
                        lPersonSex := GuessSexOfGivnName(lPersonGName);
                        if not TestFor(atext,Offset+1,['vgl','s.a']) then
                        begin
                          while (lPos < length(aText)) and
                              (aText[lPos] in Ziffern + ['a','b']) do
                            begin
                              lChRef := lChRef + aText[lPos];
                              Inc(lpos);
                            end;
                          if not TestReferenz(lchRef) then
                            lIndID := 'I' + lMainFamRef + 'C' + trim(IntToStr(lChildCount))
                          else if lPersonSex in ['M', 'F'] then
                              lIndID := 'I' + lChRef + lPersonSex
                          else
                              lIndID := 'I' + lChRef + '_';
                          end
                        else
                            lIndID := 'I' + lMainFamRef + 'C' + trim(IntToStr(lChildCount));
                      end
                    else
                        lIndID := 'I' + lMainFamRef + 'C' + trim(IntToStr(lChildCount));

                    SetIndiName(lIndID, 0, lPersonName);
                    SetFamilyMember(lMainFamRef, lIndID, 2 + lChildcount);
                    if lPersonSex in ['M', 'F'] then
                        SetIndiData(lIndID, evt_Sex, lPersonSex);
                    if lAKA <> '' then
                        SetIndiName(lIndID, 3, lAKA); //AKA
                    lAdditional := '';
                    lChildCount := lChildcount + 1;
                    lSubString := '';
                    if aText[Offset] in Ziffern then
                        if lDefaultBirthplace <> '' then
                            lSubString :=
                                csBirth + ' ' + lDefaultBirthplace +
                                ' ' + aText[Offset]
                        else
                            lSubString := csBirth + ' ' + aText[Offset]
                    else
                    if not (aText[Offset] in Whitespace + SatzZeichen) then
                        Dec(Offset);
                    lFirstEntry := False;
                  end
                // ------------- BuildData ---------------
                else if not lFirstEntry
                    and BuildData(lIndID, atext, Offset, lSubString,lData) then
                  begin
                    lEntryType := HandleNonPersonEntry(lSubString, lIndID);
                    if lData <> '' then
                      begin
                        SetIndiData(lIndID, lEntryType, lData);
                        lData := '';
                      end;
                    lSubString := '';
                    lLastZiffCount := 0;
                  end;
                if aText[Offset] = '<' then
                  begin
                    lRetmode := lMode;
                    lMode := 50;
                  end;
                if (aText[Offset] = '-') and (aText[Offset - 1] in Whitespace) then
                  begin  // Neuer Eintrage GGF. über Mode 8
                    if lData <> '' then
                      begin
                        SetIndiData(lIndID, evt_FreeFact, lData);
                        lData := '';
                      end;
                    if not lEntryEndFlag then
                        Error(self, 'Child ('+IntToStr(lChildCount -1 )+') entry not ended with .');
                    lSubString := '';
                    lAdditional := '';
                    lAKA := '';
                    lFirstEntry := True;
                    lEntryEndFlag := False;
                  end;
              end;

            10:
              begin // Ehe Datum & Ort ?
                if aText[Offset] in Ziffern + ['.','/'] then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset]=' ')
                    and (((aText[Offset+1] in Ziffern)
                    and (testfor(lSubString,1,CUnknownKN)
                      or TestFor(lSubString, 1, CDateModif))))
                      or (TestFor(aText, Offset+1, CDateModif,lFound)) then
                  begin
                    lSubString := lSubstring +' ';
                  end
                else if TestFor(aText, Offset, CDateModif,lFound) then
                  begin
                    lplace := trim(lsubstring);
                    lSubString := CDateModif[lFound];
                    Inc(Offset, Length(CDateModif[lFound]) - 1);
                  end
               else if TestFor(aText, Offset, CDateModif,lFound) then
                  begin
                    lSubString := lSubstring + CDateModif[lFound];
                    Inc(Offset, Length(CDateModif[lFound]) - 1);
                  end
                else if TestFor(aText, Offset, CUnknownKN,lFound) then
                  begin
                    lSubString := lSubstring + cUnknownKN[lFound];
                    Inc(Offset, Length(cUnknownKN[lFound]) - 1);
                  end
                else
                  begin
                    if length(lSubString) > 1 then
                      begin
                        lEventDate := lSubString;
                        SetFamilyDate(lMainFamRef, evt_Marriage, lSubString);
                        lSubString := '';
                        if lplace <> '' then
                          SetFamilyPlace(lMainFamRef, evt_Marriage, lPlace)
                        else
                          lMode := 11;
                      end;
                    if aText[Offset] = ':' then
                      begin
                        if (FDefaultPlace <> '') and (lplace='') then
                            SetFamilyPlace(lMainFamRef, evt_Marriage, FDefaultPlace);
                        lMode := 5;
                      end;
                  end;
              end;
            11: // ort
              begin
                if (lSubString = '') and ((not atext.Contains(':')) or
                    (atext.Contains('Kd') and (atext.indexof(':') >
                    atext.indexof('Kd')))) then
                  begin
                    Error(self, ': missing');
                    lMode := 5;
                    continue;
                  end;

                if BuildData(lIndID, aText, Offset, lSubString,lData) then
                  begin
                    if (lEntryType = evt_Marriage) then
                       SetFamilyPlace(lMainFamRef,lEntryType,lSubString)
                    else
                       lPlace := lSubString;
                    lSubString := '';
                    if (lData <> '') then
                      begin   // Additional Info
                        if (lEntryType = evt_Marriage) then
                          begin
                            SetFamilyData(lMainFamRef, lEntryType, trim(lData));
                            lData := '';
                          end
                        else
                            lAddEvent := lEntryType;
                        lAdditional := '';
                        lSubString := '';
                      end;
                  end;
                if aText[Offset] = ':' then
                  begin
                    lSubString := '';
                    lMOde := 5;
                  end;

              end;
            12: // Family-Entry (after Wife)
              begin
                if lFirstCycle then
                    lSubString := '';

                if ((aText[Offset] in Ziffern + ['l', ')']) or
                  (trystrtoint(lData,iDummy))) and
                    ((copy(atext, Offset + 1, 3) = ' Kd') or
                    (copy(atext, Offset + 1, 2) = 'Kd')) then
                  begin
                    lMode := 15;

                  end
                else
                if not (aText[Offset] in ['(','.', #10, #13]) then
                    lSubString += aText[Offset]
                else
                  if (aText[Offset]='.') and
                      not (aText[Offset+1] in [#10,#13] )then
                    lSubString += aText[Offset]
                      else if Testfor(aText, Offset, '(') and ParseAdditional(aText,
                            Offset, lAdditional) then
                               begin
                                 // inc(Offset);
                                 ldata := lAdditional;
                                 lAdditional := '';
                                 if ldata.StartsWith(csDivorce) then
                                   begin
                                     lData := lData.Remove(0, 3);

                                     SetFamilyPlace(lMainFamRef, evt_Divorce, FDefaultPlace);
                                     if lData <> '' then
                                         SetFamilyData(lMainFamRef, evt_Divorce, lData);
                                     lData := '';
                                   end;
                               end
                else
                  begin
                    if trim(lsubstring) <>'' then
                      HandleFamilyFact(lMainFamRef,lSubstring);
                    lSubString := '';
                  end;
              end;
            15:  // Pre-Child
              begin
                lPersontype := 'U';
                lSubString := '';
                lDefaultBirthplace := '';
                Inc(Offset, 3);
                while aText[Offset] in ['.', ':', 'r'] do
                    Inc(Offset);
                if (aText[Offset + 1] = '(') then
                    Inc(offset);
                if (aText[Offset] = '(') and
                    ParseAdditional(aText, Offset, lAdditional) then
                  begin
                    if lAdditional.StartsWith(csBirth) then
                      begin
                        lAdditional := lAdditional.Remove(0, 1);
                        lAdditional := trim(lAdditional);
                        if lAdditional.StartsWith(csPlaceKenn + ' ') then
                            lAdditional := lAdditional.Remove(0, 3);
                        lDefaultBirthplace := lAdditional;
                        lAdditional := '';
                      end;
                    inc(offset,2);
                  end;
                if (aText[Offset - 1] <> ':') then
                  warning(self,'Children Header does not end with ":"');
                lChildcount := 1;
                lEntryEndFlag := False;
                lFirstEntry := True;
                lmode := 9;
              end;
            20:
              begin // Tod Datum & Ort ?
                if aText[Offset] in Ziffern + ['.'] then
                    lSubString := lSubstring + aText[Offset]
                else
                  begin
                    if length(lSubString) > 2 then
                      begin
                        lEventDate := lSubString;
                        lSubString := '';
                        lPlace := FDefaultPlace;
                        lMode := 11;
                      end;
                    if aText[Offset] = ':' then
                      begin
                        lPlace := FDefaultPlace;
                        lMode := 5;
                      end;
                  end;
              end;
            25:
              begin // birth Datum & Ort ?
                if aText[Offset] in Ziffern + ['.'] then
                    lSubString := lSubstring + aText[Offset]
                else
                  begin
                    if length(lSubString) > 2 then
                      begin
                        lEventDate := lSubString;
                        lSubString := '';
                        lPlace := FDefaultPlace;
                        lMode := 11;
                      end;
                    if aText[Offset] = ':' then
                      begin
                        lPlace := FDefaultPlace;
                        lMode := 5;
                      end;
                  end;
              end;
            30:
              begin // Illegal Child
                if aText[Offset] in Ziffern + ['.'] then
                    lSubString := lSubstring + aText[Offset]
                else
                  begin
                    if length(lSubString) > 2 then
                      begin
                        lEventDate := lSubString;
                        lSubString := '';
                        lEntryType := evt_Partner;
                        lPlace := '';
                        lMode := 11;
                      end;
                    if aText[Offset] = ':' then
                      begin
                        lMOde := 5;
                        lEntryType := evt_Partner;
                        if lEventDate = '' then
                            lEventDate := ScanForEvDate(aText, Offset);
                        if Assigned(FonFamilyDate) and (lEventDate <> '') then
                            FonFamilyDate(self, lEventDate, lMainFamRef,
                                Ord(lEntryType));
                      end;
                  end;
              end;
            40:begin // Illegal Child
                 if aText[Offset] = ':' then
                      begin
                        lMOde := 5;
                        lEntryType := evt_Residence;
                      end;
                  if aText[Offset] in AlphaNum then
                       begin
                         dec(offset);
                         lMOde := 5;
                         lEntryType := evt_Residence;
                       end;
              end;
            50:
              begin // Referenzen
                lVerwFlag := False;
                lSubString := '';
                if TestFor(aText, Offset, csPlaceKenn2 + ' ') and
                    (atext[Offset + 4] in Ziffern+['l']) then
                  begin
                    lVerwFlag := True;
                    lMode := 51;
                  end
                else if (lRetMode = 9) and (aText[Offset] in Ziffern+['l']) then
                  begin
                    lVerwFlag := True;
                    lMode := 52;
                    Dec(offset);
                  end
                else if TestFor(aText, Offset,
                    ['S.d.', 'T.d.', 'S.d,', 'T.d,', 'Kd.d.','S(T).d.'],lFound) then
                      begin
                        Inc(Offset, 2);
                        if lFound>3 then
                          inc(offset,lFound-3);
                        lMode := 54
                      end
                else if TestFor(aText, Offset, ['s.a.','vgl.']) then
                  begin
                    if lRetMode = 9 then
                       lMode := 51
                    else
                        lMode := 52;
                    lVerwFlag := True;
                    inc(Offset,3);
                  end
                else if TestFor(aText, Offset,
                    [csMarriageEntr, csMarriageEntr2, csMarriageEntr3], lFound) then
                  begin
                    lMode := 53;
                    if lFound = 1 then
                        Inc(offset, 1)
                    else
                        Inc(offset, 2);
                    lOtherMarrFlag := lRetMode <> 9;
                  end
                else if aText[Offset] = '>' then
                   begin
                     if (aText[Offset+1] =';')
                       and not aText.Substring(offset+2,30).contains('<')
                       and aText.Substring(offset+2,30).contains('>') then
                      Warning(self,'Double-closed reference ('+inttostr(lRetMode)+')')
                    else
                      lMode := lRetMode
                   end
                else  if Testfor(aText,Offset,'),') then
                   begin
                     lMode := lRetMode;
                     error(self, 'Reference Entry ends with "),"');
                   end
                else if aText[Offset] in [#10, #13]  then
                  begin
                    error(self, 'unclosed reference');
                    lMode := lRetMode;
                    Dec(offset, 2);
                  end;
              end;
            51:
              begin // aus XXX
                if (aText[Offset] in Ziffern+['l']) or
                    ((length(lSubString) > 0) and (aText[Offset] in ['a','b'])) then
                    lSubString := lSubString + aText[Offset]
                else if length(lSubString) > 0 then
                  begin
                    If not TestReferenz(lSubString) then
                      error(self,'"'+lSubString+'" invalid reference')
                    else
                      SetIndiRelat(lIndID, lSubString, 1);
                    if aText[Offset] = '>' then
                        Dec(Offset);
                    lMode := 50;
                  end;
              end;
            52:
              begin   // s.a. ###
                lfound:=0;
                if (aText[Offset] in Ziffern+['l']) or
                    ((length(lSubString) > 0) and (aText[Offset] in ['a','b'])) then
                    lSubString := lSubString + aText[Offset]
                else if length(lSubString) > 0 then
                  begin
                    if not (aText[Offset] in ['>', ';', ',']) and
                        not Testfor(aText, Offset, [' und',' korr.' ],lFound) then
                          error(self,'"'+lSubString+ aText[Offset]+'" invalid reference')
                        else if lFound = 0 then
                            If not TestReferenz(lSubString) then
                              error(self,'"'+lSubString+'" invalid reference')
                          else
                        SetIndiRelat(lIndID, lSubString, 2);
                    lSubString := '';
                    lMode := 50;
                    if aText[Offset] = '>' then
                        Dec(Offset)
                    else
                    if (aText[Offset] = ',') or
                        Testfor(aText, Offset, [' und',' korr.'],lFound) then
                        lMode := 52;
                  end;
              end;
            53:
              begin   // ooI s.
                if lFirstCycle then
                  lSpouseCount:=0;

                if (aText[Offset] in Ziffern) or
                    ((length(lSubString) > 0) and (aText[Offset] in ['a','b'])) then
                    lSubString := lSubString + aText[Offset]
                else if testfor(atext, Offset, [' s ', ' s. ',' s, ',' S ',' S. ',' S, '], lFound) then
                  begin
                    if lFound in [0,2,3,5] then
                        Warning(self, '. missing after s');
                    lVerwFlag := True;
                    Inc(offset, length(' s'));
                    if lFound in [1,2,4,5] then
                      Inc(offset);
                  end
                else if testfor(atext, Offset,
                    [' '+csMarrPartKN+' ', csPlaceKenn, csPlaceKenn6, csUnknown, csUnknown2], lfound) or
                    testfor(atext, Offset,CMonthKN) or
                    ((atext[Offset] = ' ') and
                     ((atext[Offset + 1] in  Ziffern+['A'..'H','J'..'Z']) or
                     //Todo: Umlaute
                      ((atext[Offset + 1] = 'I') and not (atext[Offset + 2] in ['I',' '])) or
                      (lRetMode=9 )) and
                     not lVerwFlag) then
                  begin
                    lFamRef := '';
                    lMode := 57;
                    if lFound > 0 then
                        Dec(offset);
                  end
                else if (lSubstring = '') and (atext[offset] in ['I', 'l']) then
                  begin
                    lOtherMarrFlag := True;
                    inc(lSpouseCount);
                  end
                else if (length(lSubString) > 0) then
                  begin
                    lfound := 0;
                    if not lVerwFlag then
                        Warning(self, 's. missing')
                    else if not (aText[Offset] in ['>', ';', ',']) and
                        not Testfor(aText, Offset, [' und', ' korr.'], lFound) then
                        error(self, 'invalid reference')
                    else if lFound = 0 then
                        If not TestReferenz(lSubString) then
                          error(self,'"'+lSubString+'" invalid reference')
                     else
                        SetIndiRelat(lIndID, lSubString, 2);
                    lSubString := '';
                    if (aText[Offset] <> ',') and (lFound = 0) then
                      begin
                        lMode := 50;
                        if aText[Offset] = '>' then
                            Dec(Offset);
                      end;

                  end;
              end;
            54:
              begin  // S.d. T.d. Start Parent Family
                if atext[Offset] = ',' then
                    error(self, '. inst. of , expected');
                if atext[Offset] = 'd' then
                    Inc(offset);
                lParentRef := copy(lIndID, 2, 20);
                StartFamily(lParentRef);
                SetFamilyMember(lParentRef, lIndID, 3);
                lMode := 55;
                lSubString := '';
                lFirstEntry := True;
                if atext[Offset+1] = ' ' then
                  Inc(Offset);
              end;
            55, 56:
              begin // Eltern-Name
                if lSubString = '' then
                  begin
                    lAKA := '';
                  end;

                if lFirstEntry and TestFor(atext, Offset,
                    [csDeathEntr2, csDeathEntr], lFound) then
                  begin
                    lSubString := lSubString + copy(aText, Offset, lFound * 2 + 1);
                    Inc(Offset, lFound * 2);
                  end
                else if lFirstEntry
                    and BuildName(atext, offset, lSubString,lData) then
                  begin
                    lPersonName := trim(lSubString);
                    if testfor(lPersonName, 1, [csDeathEntr2, csDeathEntr], lFound) then
                      begin
                        lPersonName :=
                            trim(copy(lPersonName, length(csDeathEntr2) +
                            lFound * 2 + 1, 200));
                        if lPersonName.StartsWith(csProtectSpace) then
                            lPersonName :=
                                trim(copy(lPersonName, length(csProtectSpace) + 1, 200));
                        lParDeathFlag := True;
                      end
                    else
                        lParDeathFlag := False;

                    lIndID2 :=
                        HandleAKPersonEntry(lPersonName, lParentRef,
                        IfThen(lmode = 55, 'U', 'F')[1], Fmode, lLastName2,
                        lPersonSex2, lAKA, lLastName);

                    if lParDeathFlag then
                        SetIndiDate(lIndID2, evt_Death, 'vor ' + lEventDate);

                    lSubString := '';
                    lFirstEntry := False;
                  end
                else if not lFirstEntry
                    and BuildData(lIndID2, atext, Offset, lSubString,lData) then
                  begin
                    lEntryType2 := HandleNonPersonEntry(trim(lSubString), lIndID2);
                    if lData<>'' then
                      begin
                        SetIndiData(lIndID2,lEntryType2,lData);
                        lData:='';
                      end;
                    lSubString := '';
                  end;

                if (lMode = 55) and
                    ((copy(aText, Offset + 1, 4) = 'u.d.') or
                    (copy(aText, Offset + 1, 4) = 'u.d,')) then
                  begin
                    if (copy(aText, Offset + 1, 4) = 'u.d,') then
                        error(self, 'Mother Startflag u.d, <=> u.d.');
                    lMode := 56;
                    lPersonSex2 := 'U';
                    Inc(Offset, 4);
                    lSubString := '';
                    lFirstEntry := True;
                  end
                else if aText[Offset] in ['>', ';'] then
                  begin
                    Dec(Offset);
                    lMode := 50;
                  end
                else if (aText[Offset] in [',']) and
                    testfor(aText,offset+2,CMarriageKN,lFound) and
                    (aText[offset+2+length(CMarriageKN[lFound])]='I') then
                      begin
                        Warning(self, '; as End of entry expected');
                        Dec(Offset);
                        lMode := 50;
                      end
                else if Testfor(aText,Offset,[#10,#13]) then
                  begin
                    Dec(Offset);
                    lMode := 50;
                  end;
              end;
            57:
              begin // oo mit /in
                if lFamRef = '' then
                    if lOtherMarrFlag  then
                        lFamRef := copy(lIndID, 2) + inttostr(lSpouseCount)
                    else if (lRetMode = 9) then
                        lFamRef := copy(lIndID, 2) +'P'+ inttostr(lSpouseCount)
                    else
                        lFamRef := lMainFamRef;

                lpp := atext.IndexOfAny(['>', ';'], Offset);

                // Todo: Genealog. Dates (vor , nach, um ...)
                if (lpp > 0) and
                    copy(aText, offset, lpp - Offset + 1).Contains(' '+csMarrPartKN+' ') then
                    lsPos := atext.IndexOf(' '+csMarrPartKN+' ', Offset) + 2
                else if aText[offset] in Ziffern then
                    lsPos := atext.IndexOf(' ', Offset) + 2
                else
                    lsPos := Offset;

                if (lpp > 0) and (lsPos < lpp) and testfor(atext, lsPos,
                    [csMarrPartKN, csUnknown, csUnknown2], lFound) then
                  begin
                    ldata := lSubstring;
                    lSubString := '';
                    if (lspos > Offset) and (lspos < lpp) then
                        lDate := copy(atext, Offset, lsPos - offset)
                    else
                        lDate := '';

                    if (lfound = 0) then
                        lPersonName := copy(atext, lspos + 4, lpp - lsPos - 3)
                    else
                        lPersonName := copy(atext, lsPos, lpp - lsPos + 1);

                    if lPersonName.Contains(',') then
                      begin
                        lPos := lPersonName.IndexOf(',');
                        lSubString := trim(lPersonName.Substring(lPos + 1));
                        lPersonName := lPersonName.Substring(0, lPos);
                      end
                    else
                    if lPersonName.Contains('('+csDivorce) then
                      begin
                        warning(self,', after Name expected');
                        lPos := lPersonName.IndexOf('('+csDivorce);
                        lSubString := lPersonName.Substring(lPos);
                        lPersonName := trim(lPersonName.Substring(0, lPos));
                      end;

                    if testfor(lPersonName, 1, [csDeathEntr2, csDeathEntr], lFound) then
                      begin
                        lPersonName :=
                            trim(copy(lPersonName, length(csDeathEntr2) +
                            lFound * 2 + 1, 200));
                        if lPersonName.StartsWith(csProtectSpace) then
                            lPersonName :=
                                trim(copy(lPersonName, length(csProtectSpace) + 1, 200));
                        lParDeathFlag := True;
                      end
                    else
                        lParDeathFlag := False;

                    if lPersonSex = 'M' then
                        lPersonSex2 := 'F'
                    else
                        lPersonSex2 := 'M';
                    lIndID2 := 'I' + lFamRef + lPersonSex2;
                    if lFamRef <> lMainFamRef then
                        StartFamily(lFamRef);
                    SetIndiName(lIndID2, 0, lPersonName);
                    SetFamilyType(lFamRef, 1);

                    if lParDeathFlag then
                        SetIndiDate(lIndID2, evt_Death, 'vor ' + lEventDate);

                    if lDate <> '' then
                        begin
                          HandleFamilyFact(lFamRef,csMarriageEntr +' '+ldate );
                        end;
                    if (lPersonSex2 = 'F') then
                      begin
                        SetFamilyMember(lFamRef, lIndID2, 2);
                        if lFamRef <> lMainFamRef then
                            SetFamilyMember(lFamRef, lIndID, 1);
                      end
                    else
                      begin
                        SetFamilyMember(lFamRef, lIndID2, 1);
                        if lFamRef <> lMainFamRef then
                            SetFamilyMember(lFamRef, lIndID, 2);
                      end;
                    SetIndiData(lIndID2, evt_Sex, lPersonSex2);
                    if lSubString <> '' then
                      begin
                        if TestFor(lSubString, 1, [csDivorce, '(' + csDivorce],
                            lFound) then
                          begin
                            lSubString :=
                                lSubString.remove(length(lSubString) -
                                1, lFound).Remove(0, 3 + lFound);
                            SetFamilyDate(lFamRef, evt_Divorce, 'vor ' + lEventDate);
                            if lSubString <> '' then
                                SetFamilyData(lFamRef, evt_Divorce, lSubString);
                          end
                        else if not lSubString.Contains(',') then
                            HandleNonPersonEntry(lSubString, lIndID2)
                        else for lEntry in lSubString.Split(',') do
                            HandleNonPersonEntry(lEntry, lIndID2)
                      end;
                    if atext[lpp + 1] in ['>', ';'] then
                        Offset := lpp;
                    if (atext[lpp + 1] = ';') and
                        testfor(atext, offset + 2, ['(' + csDivorce + ')',
                        ' (' + csDivorce + ')'], lfound) then
                      begin
                        SetFamilyData(lFamRef, evt_Divorce, '');
                        Inc(offset, length(csDivorce) + 3 + lFound);
                      end;
                    lMode := 50;
                  end
                else if (lpp > 0) then
                  begin

                    lSubString :=
                        csMarriageEntr + lSubString +
                        IfThen(atext[Offset] in whitespace, '', ' ') +
                        copy(atext, Offset, lpp - Offset + 1);
                    if lSubString.Contains(',') then
                      begin
                        lPos := lSubString.IndexOf(',');
                        if (length(lSubString) > lpos + 3) and
                            (lSubString[lpos + 3] in LowerCharset) then
                          begin
                            HandleNonPersonEntry(lSubString.Substring(0, lPos), lIndID);
                            lSubString := lSubString.Remove(0, lPos + 1);
                          end;
                      end;
                    HandleNonPersonEntry(lSubString, lIndID, lFamRef);
                    Offset := lpp;
                    lMode := 50;
                  end;
              end;
 {$REGION GC}
            100:
              begin // GC-Eintrag
                if (copy(aText, Offset, length(csSeparatorGC)) = csSeparatorGC) then
                  begin
                    Inc(Offset, length(csSeparatorGC) - 1);
                    lSubString := '';
                    lFirstEntry := True;
                    if lEntryType = evt_Marriage then
                      begin
                        lTest := aText.CountChar(csSeparatorGC[2]);
                        if (lFamType = 1) or (lTest = 3) then
                            lPersonType := 'M'
                        else
                            lPersonType := 'F';
                        lMode := 110;
                      end
                    else if (copy(atext, Offset + 2, 7) = 'Kinder:') or
                        (copy(atext, Offset + 2, 5) = 'Kind:') then
                      begin
                        lPersonType := 'C';
                        lChildCount := 0;
                        lMode := 120;
                      end
                    else
                      begin
                        lPersonType := 'F';
                        lMode := 110;
                      end;
                  end;
              end;
            101:
              begin
                // Ehe Datum & Ort ?
                if aText[Offset] in Ziffern then
                    lSubString := lSubstring + aText[Offset]
                else
                if (aText[Offset] = ' ') and (lSubString <> '') and
                    (aText[Offset + 1] in Ziffern) then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset] = '.') and
                    ((aText[Offset + 1] in Ziffern + ['.']) or
                    (aText[Offset - 1] in Charset + ['.'])) then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset] = '(') and
                    ParseAdditional(aText, Offset, lAdditional) then
                  begin
                    if trim(lSubString) = '' then
                        lSubString := '(' + lAdditional + ')'
                    else
                      begin
                        if (lEntryType = evt_Marriage) and Assigned(FonFamilyData) then
                            FonFamilyData(self, lAdditional, lFamRef, Ord(lEntryType))
                        else if (lEntryType <> evt_Marriage) and
                            Assigned(FonIndiData) then
                            FonIndiData(self, lAdditional, lIndID, Ord(lEntryType));
                      end;
                  end
                else
                if (lsubstring = '') and testfor(atext, Offset, CDateModif, lFound) then
                  begin
                    Inc(Offset, length(CDateModif[lFound]));
                    lSubString := lSubstring + CDateModif[lFound];
                    if atext[Offset] in [' ', '.'] then
                        lSubString := lSubstring + atext[Offset]
                    else
                        Dec(Offset);
                  end
                else
                  begin
                    if length(lSubString) > 2 then
                      begin
                        if (lEntryType = evt_Marriage) then
                          begin
                            lEventDate := lSubString;
                            SetFamilyDate(lFamRef, lEntryType, lSubString);
                          end
                        else if Assigned(FonIndiDate) then
                            FonIndiDate(self, lSubString, lIndID, Ord(lEntryType));
                        lSubString := '';
                        lMode := 102;
                        lPlaceFlag := False;
                      end
                    else if aText[Offset] in Charset then
                        lSubString := lSubstring + aText[Offset];
                  end;
                if TestFor(aText, Offset, csSeparatorGC) or
                    (aText[Offset] = csSeparator) or
                    ((aText[Offset] = '.') and (lMode = 102)) then
                  begin
                    lMode := lRetMode;
                    Dec(Offset);
                  end;
              end;
            102:
              begin // GC-Eintrag
                // Place
                if not (aText[Offset] in ['<', '[', '.', '(', csSeparator]) and
                    not TestFor(aText, Offset, [csSeparatorGC, vbNewLine, ' '+csMarrPartKN+' ']) then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset] = '.') and
                    (not testfor(aText, Offset + 1, [' ', #9, vbNewLine, 'PN']) or
                    ((length(lSubString) < 4) and (lSubstring <> '') and
                    (lSubstring[1] in ['A'..'Z']))) then
                  begin
                    lSubstring := lSubString + '.';
                  end
                else
                  begin
                    if lPlaceFlag and (length(lSubString) > 2) then
                      begin
                        if (lEntryType = evt_Marriage) and Assigned(FonFamilyPlace) then
                            FonFamilyPlace(self, trim(lSubString),
                                lFamRef, Ord(lEntryType))
                        else if (lEntryType <> evt_Marriage) and
                            Assigned(FonIndiPlace) then
                            FonIndiPlace(self, trim(lSubString),
                                lIndID, Ord(lEntryType));
                        lSubString := '';
                      end;
                    if (aText[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        if (lEntryType <> evt_Marriage) and
                            Assigned(FonIndiData) then
                            FonIndiData(self, trim(lAdditional),
                                lIndID, Ord(lEntryType));
                        lSubString := '';
                      end
                    else
                    if (aText[Offset] in [csSeparator, '<', '[', '.']) or
                        TestFor(aText, Offset, [csSeparatorGC, vbNewLine, ' '+csMarrPartKN+' ']) then
                      begin
                        lMode := lRetMode;
                        lSubString := '';
                        Dec(Offset);
                      end;

                  end;
                if lSubString = 'in ' then
                  begin
                    lSubString := '';
                    lPlaceFlag := True;
                  end;
              end;
            103:
              begin
                // a Number
                if aText[Offset] in Ziffern + ['.'] then
                    lSubString := lSubstring + aText[Offset]
                else
                  begin
                    if length(lSubString) > 2 then
                      begin
                        if (lEntryType = evt_ID) and Assigned(FonIndiRef) then
                            FonIndiRef(self, lSubString, lIndID, Ord(lEntryType));
                        lSubString := '';
                        lMode := lRetMode;
                      end;
                  end;
                if testfor(aText, Offset, csSeparatorGC) or
                    (aText[Offset] = csSeparator) then
                  begin
                    lMode := lRetMode;
                    Dec(Offset);
                  end;
              end;
            110:
              begin // PersonenEintrag s.a. 126 & 155
                if aText[Offset] in Charset + ['.', '-'] then
                    lSubString := lSubstring + aText[Offset]
                else if (atext[Offset] = ' ') and not
                    testfor(aText, Offset + 1,
                    [csMarriageEntr2, csIllegChild]) then
                    lSubString := lSubstring + aText[Offset]
                else if Testfor(aText, Offset, FUmlauts, lFound) then
                  begin
                    lSubString := lSubstring + FUmlauts[lFound];
                    Inc(Offset, length(FUmlauts[lFound]) - 1);
                  end
                else if lFirstEntry and (lSubString <> '') then
                  begin
                    lIndID := 'I' + lMainFamRef + lPersonType;
                    SetIndiName(lIndID, 1, trim(lSubString));
                    if Assigned(FonFamilyIndiv) then
                        if lPersonType = 'M' then
                            FonFamilyIndiv(self, lIndID, lMainFamRef, 1)
                        else
                            FonFamilyIndiv(self, lIndID, lMainFamRef, 2);

                    lLastName := trim(lSubString);
                    if (lPersonType <> 'F') or (lFamName = '') then
                        lFamName := lLastName;
                    lFirstEntry := False;
                    lEntrytype := evt_GivenName;
                    lSubString := '';
                    if (aText[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        SetIndiName(lIndID, 3, lAdditional); //AKA
                      end;
                  end
                else if lSubString <> '' then
                  begin
                    if lEntryType = evt_GivenName then
                      begin
                        lPersonGName := trim(lSubString);
                        if (length(lPersonGName) < 4) and
                            (lPersonGName.EndsWith('.') or
                            (length(lPersonGName) = 2)) and
                            (lPersonGName[1] in ['a'..'z']) then
                          begin
                            SetIndiName(lIndID, 2, 'NN');
                            SetIndiData(lIndID, evt_Religion, lPersonGName);
                            lMode := 112;
                          end
                        else
                          begin
                            SetIndiName(lIndID, 2, trim(lSubString));
                            if lPersonType in ['M', 'F'] then
                              begin
                                lPersonSex := lPersonType;
                                SetIndiData(lIndID, evt_Sex, lPersonType);
                                LearnSexOfGivnName(trim(lSubString), lPersonType);
                              end
                            else
                              begin
                                lPersonSex := GuessSexOfGivnName(trim(lSubString));
                                if Assigned(FonIndiData) then
                                    if Assigned(FonIndiData) and
                                        (lPersonSex in ['M', 'F']) then
                                        FonIndiData(self, lPersonSex,
                                            lIndID, Ord(evt_Sex));
                              end;

                          end;
                      end
                    else
                    if (lEntryType = evt_AKA) and Assigned(FonIndiName) then
                        FonIndiName(self, trim(lSubString), lIndID, 3);
                    lSubString := '';
                    if (aText[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        SetIndiName(lIndID, 3, lAdditional); //AKA
                      end;
                    if (aText[Offset] = '"') and (lEntryType = evt_GivenName) then
                      begin
                        lEntryType := evt_AKA;
                      end
                    else
                        lMode := 112;
                    if testfor(aText, Offset, [' ' + csMarriageEntr2 +
                        ' ', ' ' + csIllegChild + ' ']) then
                      begin
                        lMode := 114;
                        lSubString := '';
                      end
                    else
                    if aText[Offset] in ['<', '['] then
                      begin
                        lMode := 150;
                        lRetMode2 := 112;
                        Dec(Offset);
                      end;
                  end;
              end;
            112:  // Zusatzinformation zur Person
              begin
                if not (aText[Offset] in ['.', ',', '<', '['] + Whitespace) then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset] in Whitespace) and
                    (lSubString <> '') and not testfor(aText, Offset,
                    [' ' + csMarriageEntr2 + ' ', ' ' + csIllegChild + ' ']) then
                  begin
                    lSubstring := lSubString + aText[Offset];
                  end
                else if (aText[Offset] = '.') and
                    ((copy(aText, Offset + 1, 1) <> ' ') or
                    ((right(lSubString, 4).IndexOf(' ') <> -1) and
                    (right(lSubString, 4)[right(lSubString, 4).IndexOf(' ') + 2] in
                    ['A'..'Z']))) then
                  begin
                    lSubstring := lSubString + '.';
                  end
                else if (aText[Offset] = ',') and (trim(lSubstring) = 'Bürger') then
                  begin
                    lSubstring := lSubString + ',';
                  end
                else if HandleGCNonPersonEntry(lSubString, atext[Offset], lIndID) then
                  begin
                    lSubString := '';
                    if aText[Offset] in ['<', '['] then
                      begin
                        lRetMode2 := lMode;
                        lMode := 150;
                        Dec(Offset);
                      end;
                  end
                else
                if aText[Offset] in ['<', '['] then
                  begin
                    lSubString := '';
                    lRetMode2 := lMode;
                    lMode := 150;
                    Dec(Offset);
                  end;
                if (copy(aText, Offset, length(csAdditional)) = csAdditional) then
                  begin
                    lMode := lMode + 1;
                    lDate := '';
                    lsubstring := '';
                    lPos := atext.IndexOf(':', Offset);
                    lPlaceFlag := False;
                    lEntryType := evt_AddOccupation;
                    if lpos <> -1 then
                        Offset := lpos + 1
                    else
                        Inc(Offset, length(csAdditional) + length(lLastName) + 5);
                  end
                else
                if (copy(aText, Offset, length(csSeparatorGC)) = csSeparatorGC) then
                  begin
                    lMode := 100;
                    Dec(Offset);
                  end
                else if testfor(aText, Offset,
                    [' ' + csMarriageEntr2 + ' ', ' ' + csIllegChild + ' ']) then
                  begin
                    lMode := 114;
                    lSubString := '';
                  end
                else if HandleGCDateEntry(aText, Offset, lIndID,
                    lMode, lRetMode, lEntryType) then
                    lSubString := ''
                else if (copy(aText, Offset, length(csReferenceGC)) = csReferenceGC) then
                  begin
                    lRetMode := lMode;
                    lMode := 103;
                    lEntryType := evt_ID;
                    lSubString := '';
                  end;
              end;
            113:
              begin
                // Lebensphasenaufbau: <Datum> <Eingenschaft> in <Ort>.
                // Endet mit PN = oder csSeparatorGC;
                if (copy(atext, Offset, length(csSeparatorGC)) = csSeparatorGC) or
                    (copy(atext, Offset, length(csReferenceGC)) = csReferenceGC) or
                    (copy(atext, Offset, length('PN=')) = 'PN=') then
                  begin
                    lMode := 112;
                    Continue;
                  end;
                if testfor(atext, Offset, [csResidence + ' ']) then
                  begin
                    lEntryType := evt_AddResidence;
                    Inc(Offset, length(csResidence));
                    SetIndiData(lIndID, lEntryType, '');
                    if ldate <> '' then
                        SetIndiDate(lIndID, lEntryType, lDate);
                    lSubString := '';
                    ldate := '';
                  end
                else
                if testfor(atext, Offset, [csEmigration + ' ']) then
                  begin
                    lEntryType := evt_AddEmigration;
                    Inc(Offset, length(csEmigration));
                    SetIndiData(lIndID, lEntryType, '');
                    if ldate <> '' then
                        SetIndiDate(lIndID, lEntryType, lDate);
                    lSubString := '';
                    ldate := '';
                  end
                else
                if (copy(atext, Offset - 1, length(csPlaceKenn) + 2) =
                    ' ' + csPlaceKenn + ' ') then
                  begin
                    lPlaceFlag := True;
                    //                    lSubString := lSubString +' '+ csPlaceKenn+' ';
                    Inc(Offset, length(csPlaceKenn));
                  end
                else if (lDate = '') and
                    ((testfor(atext, Offset, CDateModif, lFound) or
                    (atext[Offset] in Ziffern))) then
                  begin
                    if lfound >= 0 then
                      begin
                        Inc(Offset, length(CDateModif[lFound]));
                        lDate := CDateModif[lFound];
                        if atext[Offset] in ['.', ' '] then
                          begin
                            lDate := lDate + atext[Offset];
                            Inc(Offset);
                          end;
                      end;
                    while (offset + 1 < length(atext)) and
                        ((atext[Offset] in Ziffern + [' ']) or
                            ((atext[Offset] = '.') and
                            (atext[Offset + 1] in Ziffern))) do
                      begin
                        lDate := lDate + atext[Offset];
                        Inc(offset);
                      end;
                    Dec(offset);
                  end
                else
                if not (atext[Offset] in Whitespace + ['.']) then
                    lSubString := lSubString + atext[Offset]
                else if (atext[Offset] = '.') and
                    ((atext[Offset + 1] in Ziffern) or (length(lSubString) = 2)) then
                    lSubString := lSubString + atext[Offset]
                else if (atext[Offset] = ' ') and
                    (((atext[Offset - 1] in ['.', ',', ')']) and (lSubString <> '')) or
                    testfor(lSubString, 1, CDateModif) or lPlaceFlag) then
                    lSubString := lSubString + atext[Offset]
                else if lSubString <> '' then
                  begin
                    if lPlaceFlag then
                      begin
                        if lDate <> '' then
                          begin
                            lEntryType := evt_AddResidence;
                            if lDate <> '' then
                                SetIndiDate(lIndID, lEntryType, trim(lDate));
                            lDate := '';
                          end;
                        SetIndiPlace(lIndID, lEntryType, lSubString);
                        lSubString := '';
                        lPlaceFlag := False;
                        lEntryType := evt_AddOccupation;
                      end
                    else
                      begin
                        SetIndiData(lIndID, lEntryType, lSubString);
                        if lDate <> '' then
                            SetIndiDate(lIndID, lEntryType, trim(lDate));
                        if FDefaultPlace <> '' then
                            SetIndiPlace(lIndID, lEntryType, FDefaultPlace);
                        lSubString := '';
                        lDate := '';
                      end;
                  end;
              end;
            114:
              begin // Other Marriage
                lEntryType := evt_Marriage;
                lSubstring := '';
                lFamCEntry := '';
                if (copy(aText, Offset, length(csIllegChild)) = csIllegChild) then
                    lFamType := 2
                else
                  begin
                    lFamType := 1;
                    if aText[Offset + 4] = '/' then
                      begin
                        lFamCEntry := copy(aText, Offset + 3, 3);
                        Inc(Offset, 4);
                      end;
                  end;
                lChildFam := copy(lIndID, 2, 20);
                if Assigned(FonStartFamily) then
                    FonStartFamily(self, lChildFam, '', 0);
                SetFamilyType(lChildFam, lFamType, lFamCEntry);
                if Assigned(FonFamilyIndiv) then
                    if lPersonSex = 'M' then
                        FonFamilyIndiv(self, lIndID, lChildFam, 1)
                    else
                        FonFamilyIndiv(self, lIndID, lChildFam, 2);
                Inc(Offset, 2);
                lFamRef := lChildFam;
                lRetMode := lMode + 1;
                lMode := 101;
              end;
            115:
              begin
                if Testfor(aText, Offset, csMarrPartKN) then
                  begin
                    lMode := lMode + 1;
                    lFamRef := lChildFam;
                    lFirstEntry := True;
                    if lPersonSex = 'M' then
                        lPersonType2 := 'F'
                    else
                        lPersonType2 := 'M';
                    Inc(Offset, 3);
                  end
                else
                  begin
                    lMode := 112; {!}
                    Dec(Offset);
                  end;
              end;
            116:
              begin // PersonenEintrag
                if aText[Offset] in Charset + ['.', '-'] +
                    whitespace - [#10, #13] then
                    lSubString := lSubstring + aText[Offset]
                else if Testfor(aText, Offset, FUmlauts) then
                  begin
                    lSubString := lSubstring + aText[Offset] + atext[Offset + 1];
                    Inc(Offset);
                  end
                else if lFirstEntry then
                  begin
                    lIndID2 := 'I' + lFamRef + lPersonType2;
                    SetIndiName(lIndID2, 1, trim(lSubString));
                    if Assigned(FonFamilyIndiv) then
                        if lPersonType2 = 'M' then
                            FonFamilyIndiv(self, lIndID2, lFamRef, 1)
                        else
                            FonFamilyIndiv(self, lIndID2, lFamRef, 2);

                    lLastName := trim(lSubString);
                    lFirstEntry := False;
                    lEntrytype := evt_Last;
                    lSubString := '';
                    if (atext[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        SetIndiName(lIndID, 3, lAdditional); //AKA
                      end;
                  end
                else
                  begin
                    SetIndiName(lIndID2, 2, trim(lSubString));
                    if Assigned(FonIndiData) then
                        if lPersonType2 in ['M', 'F'] then
                            FonIndiData(self, lPersonType2, lIndID2, Ord(evt_Sex));
                    if not (lPersonType2 in ['M', 'F']) then
                      begin
                        lPersonSex2 := GuessSexOfGivnName(trim(lSubString));
                        if Assigned(FonIndiData) then
                            if Assigned(FonIndiData) and
                                (lPersonSex2 in ['M', 'F']) then
                                FonIndiData(self, lPersonSex2, lIndID2, Ord(evt_Sex));
                      end
                    else
                        LearnSexOfGivnName(trim(lSubString), lPersonType2);
                    lSubString := '';
                    if (atext[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        SetIndiName(lIndID, 3, lAdditional); //AKA
                      end;
                    lMode := 112; {!}
                    Dec(Offset);
                    if aText[Offset] in ['<', '['] then
                      begin
                        lMode := 150;
                        lRetMode2 := 112;
                      end;
                  end;
              end;
            120:
              begin // Kinder-Eintrag
                if (copy(atext, Offset + 1, 7) = 'Kinder:') then
                  begin
                    lMode := 121;
                    Inc(Offset, 8);
                  end
                else if (copy(atext, Offset + 1, 5) = 'Kind:') then
                  begin
                    lMode := 122;
                    lIndID := 'I' + lMainFamRef + 'C1';
                    lChildCount := 1;
                    Inc(Offset, 6);
                    lFirstEntry := True;
                    SetIndiName(lIndID, 1, lFamName);
                    SetFamilyMember(lMainFamRef, lIndID, 2 + lChildCount);
                  end
                else
                    lMode := 0;
              end;
            121:
              begin
                if atext[Offset] in Ziffern then
                    lSubString := lSubString + atext[Offset]
                else if (lSubString <> '') and (atext[Offset] = ')') and
                    TryStrToInt(lSubString, lChildCount) then
                  begin
                    lMode := 122;
                    lIndID := 'I' + lMainFamRef + 'C' + IntToStr(lChildCount);
                    lFirstEntry := True;
                    SetIndiName(lIndID, 1, lFamName);
                    SetFamilyMember(lMainFamRef, lIndID, 2 + lChildCount);
                    lSubString := '';
                  end
                else
                if testfor(aText, Offset, [csMarriageEntr2 + ' ',
                    csIllegChild + ' ']) then
                  begin
                    lRetMode3 := lMode + 2;
                    lMode := 124;
                    lSubString := '';
                  end
                else
                if lsubstring <> '' then
                  begin
                    lMode := 2;
                    Dec(Offset);
                  end;
              end;
            122:  // Name des Kindes
              begin
                if aText[Offset] in Charset + ['.', ' ', '-'] then
                    lSubString := lSubstring + aText[Offset]
                else if Testfor(aText, Offset, FUmlauts) then
                  begin
                    lSubString := lSubstring + aText[Offset] + atext[Offset + 1];
                    Inc(Offset);
                  end
                else if lFirstEntry and (aText[Offset] = ',') then
                  begin
                    SetIndiName(lIndID, 1, trim(lSubString));
                    lSubString := '';
                  end
                else if lFirstEntry then
                  begin
                    lPersonGName := trim(lSubstring);
                    if (lPersonGName = '') and
                        ((atext[Offset] = #9) or
                        (atext[Offset] = '+') or
                        (atext[Offset] = '*')) then
                        lPersonGName := 'NN';
                    if lPersonGName <> '' then
                      begin
                        SetIndiName(lIndID, 2, lPersonGName);
                        lPersonSex := GuessSexOfGivnName(trim(lSubString));
                        if (lPersonSex in ['M', 'F']) and Assigned(FonIndiData) then
                            FonIndiData(self, lPersonSex, lIndID, 6);
                        lFirstEntry := False;
                        lMode := 123;
                      end;
                    lSubString := '';
                    if (atext[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        SetIndiName(lIndID, 3, lAdditional); //AKA
                      end;
                    if lMode = 123 then
                        Dec(Offset);
                  end;

              end;
            123:
              begin // Todo: Merge with 112
                if not (aText[Offset] in ['.', ',', '<', '[', #10, #13]) and
                    not Testfor(aText, Offset,
                    [' ' + csMarriageEntr2 + ' ', ' ' + csIllegChild + ' ']) then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset] = '.') and
                    ((copy(aText, Offset + 1, 1) <> ' ') or
                    ((right(lSubString, 4).IndexOf(' ') <> -1) and
                    (right(lSubString, 4)[right(lSubString, 4).IndexOf(' ') + 2] in
                    ['A'..'Z']))) then
                  begin
                    lSubstring := lSubString + '.';
                  end
                else if (aText[Offset] = ',') and (trim(lSubstring) = 'Bürger') then
                  begin
                    lSubstring := lSubString + ',';
                  end
                else if HandleGCNonPersonEntry(lSubString, atext[Offset], lIndID) then
                  begin
                    lSubString := '';
                    if aText[Offset] in ['<', '['] then
                      begin
                        lRetMode2 := lMode;
                        lMode := 150;
                        Dec(Offset);
                      end;

                  end
                else
                if aText[Offset] in ['<', '['] then
                  begin
                    lSubString := '';
                    lRetMode2 := lMode;
                    lMode := 150;
                    Dec(Offset);
                  end;
                if testfor(aText, Offset, [' ' + csMarriageEntr2 +
                    ' ', ' ' + csIllegChild + ' ']) then
                  begin
                    lRetMode3 := lMode;
                    lMode := 124;
                    lSubString := '';
                  end
                else
                if (copy(aText, Offset, length(csSeparatorGC)) = csSeparatorGC) then
                  begin
                    lMode := 100;
                    Dec(Offset);
                  end
                else
                if testfor(aText, Offset, vbNewLine) or
                    ((aText[Offset] in Ziffern) and testfor(aText, Offset, ')')) then
                  begin
                    lMode := 121;
                    lSubString := '';
                    if (aText[Offset] in Ziffern) then
                        Dec(Offset);
                  end
                else if HandleGCDateEntry(aText, Offset, lIndID,
                    lMode, lRetMode, lEntryType) then
                    lSubString := ''
                else if copy(aText, Offset, length(csReferenceGC)) = csReferenceGC then
                  begin
                    lRetMode := lMode;
                    lMode := 103;
                    lEntryType := evt_ID;
                    lSubString := '';
                  end;
              end;
            124:
              begin // Child Marriage
                lEntryType := evt_Marriage;
                lSubstring := '';
                lFamCEntry := '';
                lFamRef := copy(lIndID, 2, 20);
                if (copy(aText, Offset, length(csIllegChild)) = csIllegChild) then
                    lFamType := 2
                else
                  begin
                    lFamType := 1;
                    if aText[Offset + 4] = '/' then
                      begin
                        lFamCEntry := copy(aText, Offset + 3, 3);
                        lFamRef :=
                            lFamRef + 'S' + char(Ord(lFamCEntry[1]) +
                            Ord(lFamCEntry[3]) - Ord('1'));
                        Inc(Offset, 4);
                      end;
                  end;
                if Assigned(FonStartFamily) then
                    FonStartFamily(self, lFamRef, '', 0);
                SetFamilyType(lFamRef, lFamType, lFamCEntry);
                if Assigned(FonFamilyIndiv) then
                    if lPersonSex = 'M' then
                        FonFamilyIndiv(self, lIndID, lFamRef, 1)
                    else
                        FonFamilyIndiv(self, lIndID, lFamRef, 2);
                Inc(Offset, lFamType + 1);
                lRetMode := 125;
                lMode := 101;
              end;
            125:
              begin
                if Testfor(aText, Offset, csMarrPartKN) then
                  begin
                    lMode := 126;
                    lFirstEntry := True;
                    if lPersonSex = 'M' then
                        lPersonType2 := 'F'
                    else
                        lPersonType2 := 'M';
                    Inc(Offset, 3);
                  end
                else if atext[Offset] <> ' ' then
                  begin
                    lMode := lRetMode3;
                    Dec(Offset);
                  end;
              end;
            126:
              begin // PersonenEintrag
                if aText[Offset] in Charset + ['.', '-'] +
                    whitespace - [#10, #13] then
                    lSubString := lSubstring + aText[Offset]
                else if Testfor(aText, Offset, FUmlauts) then
                  begin
                    lSubString := lSubstring + aText[Offset] + atext[Offset + 1];
                    Inc(Offset);
                  end
                else if lFirstEntry then
                  begin
                    lIndID2 := 'I' + lFamRef + lPersonType2;
                    SetIndiName(lIndID2, 1, trim(lSubString));
                    if Assigned(FonFamilyIndiv) then
                        if lPersonType2 = 'M' then
                            FonFamilyIndiv(self, lIndID2, lFamRef, 1)
                        else
                            FonFamilyIndiv(self, lIndID2, lFamRef, 2);

                    lLastName := trim(lSubString);
                    lFirstEntry := False;
                    lEntrytype := evt_Last;
                    lSubString := '';
                    if (atext[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        SetIndiName(lIndID, 3, lAdditional); //AKA
                      end;
                  end
                else
                  begin
                    SetIndiName(lIndID2, 2, trim(lSubString));
                    if lPersonType2 in ['M', 'F'] then
                        SetIndiData(lIndID2, evt_Sex, lPersonType2);
                    if not (lPersonType2 in ['M', 'F']) then
                      begin
                        lPersonSex2 := GuessSexOfGivnName(trim(lSubString));
                        if lPersonSex2 in ['M', 'F'] then
                            SetIndiData(lIndID2, evt_Sex, lPersonSex2);
                      end
                    else
                        LearnSexOfGivnName(trim(lSubString), lPersonType2);
                    lSubString := '';
                    if (atext[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        SetIndiName(lIndID, 3, lAdditional); //AKA
                      end;
                    lMode := lRetMode3;
                    Dec(Offset);
                    if (lmode < 150) and (aText[Offset] in ['<', '[']) then
                      begin
                        lRetMode2 := lMode;
                        lMode := 150;
                      end;
                  end;
              end;
            150:
              begin // Verweiss
                if aText[Offset] in ['>', ']'] then
                  begin
                    lMode := lRetMode2;
                    if (lSubString <> '') and trystrtoint(lSubString, lInt) then
                        SetIndiRelat(lIndID, trim(lSubString), lRefMode2);
                    lSubString := '';
                  end
                else
                if aText[Offset] in [#10, #13, '*', '~'] then
                  begin  // Defekter Eintrag
                    lMode := lRetMode2;
                    Error(self, FMainref + ': Unclosed Reference');
                    if (lSubString <> '') and (lSubString[1] in Ziffern) then
                        SetIndiRelat(lIndID, trim(lSubString), lRefMode2);
                    Dec(Offset);
                    lSubString := '';
                  end
                else if (aText[Offset] = '<') then
                    lRefMode2 := 1
                else if (aText[Offset] = '[') then
                    lRefMode2 := 2
                else if (lRefMode2 = 2) and (lSubString = '') and
                    testfor(atext, Offset, csMarriageEntr2) then
                  begin
                    lRetMode3 := lMode;
                    lmode := 124;
                    Dec(Offset);
                  end
                else if (aText[Offset] in Charset) or
                    testfor(atext, Offset, csDeathEntr) then
                  begin
                    lSubString := atext[Offset];
                    lParentRef := copy(lIndID, 2, 20);
                    if Assigned(FonStartFamily) then
                        FonStartFamily(self, lParentRef, '', 0);
                    SetFamilyMember(lParentRef, lIndID, 3);
                    lFirstEntry := True;
                    lSecondEntry := True;
                    lMode := 155;
                  end
                else if not (aText[Offset] in [',']) then
                    lSubString := lSubString + atext[Offset]
                else
                  begin
                    if trystrtoint(lSubString, lInt) then
                      begin
                        SetIndiRelat(lIndID, trim(lSubString), lRefMode2);
                        lSubString := '';
                      end;
                  end;
              end;
            155, 156:
              begin
                if not (aText[Offset] in [' ', ',', '<', '>', ']', '(']) or
                    ((aText[Offset] = ' ') and
                    ((copy(aText, Offset, 5) <> ' und ') and
                    (lSubString <> ''))) then
                    lSubString := lSubString + aText[Offset]
                else if aText[Offset] = '<' then
                  begin // Doppelte Referenz ?!
                    // ToDo:
                  end
                else
                if lFirstEntry and (lSubString <> '') then
                  begin
                    if lMode = 155 then
                        lIndID2 := 'I' + lParentRef + 'M'
                    else
                        lIndID2 := 'I' + lParentRef + 'F';
                    if testfor(lSubString, 1, csDeathEntr) then
                      begin
                        SetIndiName(lIndID2, 1,
                            copy(trim(lSubString), length(csDeathEntr) + 1, 200));
                        SetIndiDate(lIndID2, evt_Death, 'vor ' + lEventDate);
                      end
                    else
                        SetIndiName(lIndID2, 1, trim(lSubString));
                    SetFamilyMember(lParentRef, lIndID2, lMode - 154);
                    lSubString := '';
                    if (atext[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        SetIndiName(lIndID2, 3, lAdditional); //AKA
                      end;
                    lFirstEntry := False;
                  end
                else if lSecondEntry and (lSubString <> '') then
                  begin
                    lPersonGName := trim(lSubString);
                    if (length(lPersonGName) < 4) and
                        (lPersonGName.EndsWith('.') or (length(lPersonGName) = 2)) and
                        (lPersonGName[1] in ['a'..'z']) then
                      begin
                        SetIndiName(lIndID2, 2, 'NN');
                        SetIndiData(lIndID2, evt_Religion, lPersonGName);
                        lSecondEntry := False;
                      end
                    else
                      begin
                        SetIndiName(lIndID2, 2, lPersonGName);
                        if lmode = 156 then
                            SetIndiData(lIndID2, evt_Sex, 'F')
                        else
                          begin
                            lPersonSex2 := GuessSexOfGivnName(lPersonGName);
                            SetIndiData(lIndID2, evt_Sex, lPersonSex2);
                          end;

                      end;
                    lSubString := '';
                    if (atext[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        SetIndiName(lIndID2, 3, lAdditional); //AKA
                      end;
                    lSecondEntry := False;
                  end
                else if (aText[Offset] = ',') and (trim(lSubstring) = 'Bürger') then
                  begin
                    lSubstring := lSubString + ',';
                  end
                else if HandleGCNonPersonEntry(lSubString, atext[Offset], lIndID2) then
                  begin
                    lSubString := '';
                  end;
                if (lmode = 155) and (copy(aText, Offset, 5) = ' und ') then
                  begin
                    lMode := 156;
                    Inc(Offset, 4);
                    lSubString := '';
                    lFirstEntry := True;
                    lSecondEntry := True;
                  end
                else if aText[Offset] in ['>', ']'] then
                  begin
                    Dec(Offset);
                    lSubstring := '';
                    lMode := 150;
                  end;

              end;

            199:
              begin
              end
 {$ENDREGION GC}
            else
                Lmode := 0
          end;
        Inc(Offset);
        {$IFDEF DEBUG}
        lDebug := copy(atext, Offset, 20);
        {$ENDIF}
        lFirstCycle := (Fmode <> lMode);
        if lFirstCycle then
          begin
            Fmode := lMode;
            lStartOffset := Offset;
            {$IFDEF DEBUG}
            // New Mode
            if (lDebug.Substring(19)+' ')[1] in [#$c2..#$ff] then
              delete(lDebug,length(lDebug),1);
            if (lDebug.Substring(18)+' ')[1] in [#$e0..#$ff] then
              delete(lDebug,length(lDebug)-1,2);
            Debug(self, 'NM:'+inttostr(FMode)+' (' + IntToStr(lStartOffset) + ')' + lDebug);
            {$ENDIF}
          end;
      end;
end;

procedure TFBEntryParser.Error(Sender: TObject; NewMessage: string);
begin
    FLastErr := NewMessage;
    if assigned(FonParseMessage) then
        FonParseMessage(self, etError, NewMessage, FMainRef, FMode)
    else if assigned(FonParseError) then
        FonParseError(self);
end;

procedure TFBEntryParser.Warning(Sender: TObject; NewMessage: string);
begin
    FLastErr := NewMessage;
    if assigned(FonParseMessage) then
        FonParseMessage(self, etWarning, NewMessage, FMainRef, FMode)
    else if assigned(FonParseError) then
        FonParseError(self);
end;

procedure TFBEntryParser.Debug(Sender: TObject; NewMessage: string);
begin
    FLastErr := NewMessage;
    if assigned(FonParseMessage) then
        FonParseMessage(self, etDebug, NewMessage, FMainRef, FMode);
end;

function TFBEntryParser.HandleAKPersonEntry(const lPersonEntry: string;
    const lMainFamRef: string; lPersonType: char; lMode: integer;
    out lLastName: string; out lPersonSex: char; const aAKA: string = '';
    const lFamName: string = ''): string;

var
    Names: TStringArray;
    lTitel: string;
    lPersonName, lSpouseLName, lAKA: string;
    lFound, i: integer;
    lMarriageFlag: boolean;

begin
    Debug(self, 'HANE: "' + lPersonEntry + '"');
    lAKA := aAKA;

    // Normalisieren: Sicherstellen, daß nach einem '.' ein Leerzeichen folgt.
    if not lPersonEntry.Contains(csUnknown2) then
        lPersonName := lPersonEntry.Replace('  ', ' ').Replace('. ',
            '.').Replace('.', '. ')
    else
        lPersonName := (lPersonEntry+' ').Replace('  ', ' ');


    // Namen nach Leerzeichen aufteilen
    {$if FPC_FULLVERSION = 30200 }
    {$Warning 'Split produces wrong results in 3.2.0' }
    {$ENDIF}
    Names := trim(lPersonName).Split([' ']);



    // Hole Titel
    lTitel := '';
    if testfor(lPersonName, 1, FAkkaTitel, lFound) then // Todo: weitere Titel
      begin
        lTitel := FAkkaTitel[lFound];
        lPersonName := copy(lPersonName, length(lTitel) + 2);
            {$if FPC_FULLVERSION = 30200 }
    {$Warning 'Split produces wrong results in 3.2.0' }
    {$ENDIF}
        Names := trim(lPersonName).Split([' ']);
      end;

    // ? <Name> in AKA
    if not Names[high(Names)].EndsWith('.') and
        (GuessSexOfGivnName(Names[high(Names)], False) <> '_') and
        lAKA.StartsWith('?') and (length(laka) > 3) then
      begin
        lLastName := trim(copy(lAKA, 2)).Replace('.', '. ');
        if (lLastName = copy(lFamName, 1, length(lLastName) - 2) + '. ') then
            lLastName := lFamName;
        lPersonName := lPersonName + ' ' + lLastName;
        lAKA := '? ' + lLastName;
            {$if FPC_FULLVERSION = 30200 }
    {$Warning 'Split produces wrong results in 3.2.0' }
    {$ENDIF}

        Names := lPersonName.Split([' ']);
      end;

    // Geburtsname u. ggf. Name des Ehegatten
    lSpouseLName := '';
    lMarriageFlag := False;
    for i := 1 to high(Names) - 1 do
        if Names[i] = csMaidenNameKn then
          begin
            // Nur wenn Hauptperson
            if (i > 1) and (lMode <> 56) then
              begin
                lSpouseLName := Names[i - 1];
                lPersonName := lPersonName.Replace(' ' + lSpouseLName, '');
              end;
            lPersonName := lPersonName.Replace(' ' + csMaidenNameKN, '');
            Names := lPersonName.Split([' ']);
            lMarriageFlag := True;
            break;
          end;

    lLastName := Names[high(Names)];

    if (high(Names) > 2) and (Names[high(Names) - 1] <> '') and
        (Names[high(Names) - 1][1] in LowerCharset) then
        lLastName := Names[high(Names) - 1] + ' ' + lLastName;

    // Name Abbrev in AKA
    if not lLastName.EndsWith('.') and (GuessSexOfGivnName(lLastName, False) <> '_') and
        lAKA.EndsWith('.') and (length(laka) < 4) and
        (laka = copy(lFamName, 1, length(laka) - 1) + '.') then
      begin
        lLastName := lFamName;
        lPersonName := lPersonName + ' ' + lLastName;
        lAKA := '? ' + lLastName;

      end;

    if (lLastName <> '') and (llastname[1] in UpperCharset + ['Ü'[1]]) and
        lLastName.EndsWith('.') and (length(lLastName) <= 4) and
        (copy(lFamName, 1, length(lLastName) - 1) + '.' = lLastName) then
      begin
        lPersonName := lPersonName.Replace(lLastName + ' ', lFamName);
        lLastName := lFamName;
      end
    else
      lPersonName := trim(lPersonName);

    if (lPersonType = 'U') and
        (copy(lPersonName, 1, length(lPersonName) - length(lLastName) - 1) <>
        csUnknown2) then
        lPersonSex :=
            GuessSexOfGivnName(copy(lPersonName, 1, length(lPersonName) -
            length(lLastName) - 1))
    else
        lPersonSex := lPersonType;

    if lpersonsex in ['M', 'F'] then
        LearnSexOfGivnName(
            copy(lPersonName, 1, length(lPersonName) - length(lLastName) - 1),
            lPersonType);

    Result := 'I' + lMainFamRef + lPersonSex;

    // Fire Events
    if lMarriageFlag then
      begin
        SetFamilyType(lMainFamRef, 1);
        // Todo: Spouse name
      end;

    SetIndiName(Result, 0, lPersonName);

    if lTitel <> '' then
        SetIndiName(Result, 4, lTitel);

    if lPersonSex = 'F' then
        SetFamilyMember(lMainFamRef, Result, 2)
    else
        SetFamilyMember(lMainFamRef, Result, 1);


    SetIndiData(Result, evt_Sex, lPersonSex);

    if lAKA <> '' then
        SetIndiName(Result, 3, trim(lAKA));
end;

procedure TFBEntryParser.Parse(Data: string);
begin
    Feed(Data);
end;

procedure TFBEntryParser.LearnSexOfGivnName(aName: string; aSex: char);

begin
    GNameHandler.LearnSexOfGivnName(aName,aSex);
end;

function TFBEntryParser.GuessSexOfGivnName(aName: string; bLearn: boolean): char;

begin
  GNameHandler.cfgLearnUnknown:=cfgLearnUnknown;
  Result := GNameHandler.GuessSexOfGivnName(aName,bLearn);
end;

function TFBEntryParser.ScanForEvDate(const aText: string; lOffset: int64): string;

var
    lOffs, lPos: int64;
    lFound: integer;
    lLastZiffCount: integer;
    lZiffCount: integer;
    {%H-}lDebug: string;

begin
    Result := '';

    // Scan for Event-Date
    lPos := pos('Kd:', aText, lOffset);
    if lpos > 0 then
        Dec(lPos, 1)
    else
        lpos := pos('Kdr:', aText, lOffset);

    if lPos > 0 then
      begin
        Inc(lPos, 4);
        lOffs := lPos;
        lFound := -1;
        lZiffCount := 0;
        while (lOffs < Length(atext)) and
            ((atext[lOffs] in Charset + Whitespace + [',']) or
                (TestFor(aText, lOffs, FUmlauts, lFound))) do
          begin
            if lFound >= 0 then
                Inc(lOffs);
            Inc(lOffs);
            lFound := -1;
          end;

         {$IFDEF DEBUG}
        lDebug := copy(atext, lOffs, 20);
        {$ENDIF}

        // Start of event
        if TestFor(aText, lOffs, csDeathEntr) then
            Inc(lOffs, Length(csDeathEntr));
        if TestFor(aText, lOffs, csBirth) then
            Inc(lOffs);

         {$IFDEF DEBUG}
        lDebug := copy(atext, lOffs, 20);
        {$ENDIF}
        // Start of Event-Date
        while (lOffs < Length(atext)) and
            ((atext[lOffs] in Ziffern + [' ', 'u', 'm', 'v', 'o', 'r']) or
                ((atext[lOffs] = '.') and (lZiffCount < 4))) do
          begin

            if aText[lOffs] in Ziffern then
                Inc(lZiffCount)
            else
              begin
                if lZiffCount > 0 then
                    lLastZiffCount := lZiffCount;
                lZiffCount := 0;
              end;

            Result := Result + atext[lOffs];
            Inc(loffs);
             {$IFDEF DEBUG}
            lDebug := copy(atext, lOffs, 20);
             {$ENDIF}
          end;
      end;
end;

end.
