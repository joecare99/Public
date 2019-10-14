unit unt_FBParser;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Cmp_Parser;

type
    TenumEventType = (
        evt_ID = 0,
        evt_Birth = 1,
        evt_Baptism = 2,
        evt_Marriage = 3,
        evt_Death = 4,
        evt_Burial = 5,
        evt_Sex = 6,
        evt_Occupation = 7,
        evt_Religion = 8,
        evt_Residence = 9,
        evt_GivenName = 10,
        evt_AKA = 11,
        evt_AddOccupation = 12,
        evt_AddResidence = 13,
        evt_AddEmigration = 14,
        evt_Last
        );
    TParseEvent = procedure(Sender: TObject; aText: string; Ref: string;
        dsubtype: integer) of object;

    { TFBEntryParser }

    TFBEntryParser = class(TBaseParser)
    private
        FGNameFile: string;
        FGNameListChanged: boolean;
        FLastErr: string;
        FMainRef: string;

        FUmlauts: array of string;

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

        FGNameList: TStringList;
        FMode: integer;
        function GetEntryType(lSubString: string;
            out Date: string): TenumEventType;
        function HandleGCNonPersonEntry(const aSubString: string;
            const ActChar: char; const lIndID: string): boolean;
        function HandleNonPersonEntry(const aSubString, lIndID: string): TenumEventType;
        function HandleGCDateEntry(const aText: string;
            var ppos: int64; lIndID: string; var lMode, lRetMode: integer;
            var aEntrytype: TenumEventType): boolean;
        function ParseAdditional(const aText: string; var pPos: int64;
            out aOutput: string): boolean;
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
        procedure SetonStartFamily(AValue: TParseEvent);
        function TestEntry(lSubString, TestStr: string;
            out Date: string): boolean;
        function TestFor(const aText:string; pPos: int64;const aTest: string): boolean; inline;
            overload;
        function TestFor(const aText: string; pPos: int64;
            const aTest: array of string): boolean; inline; overload;
        function TestFor(const aText: string; pPos: int64;
            const aTest: array of string;out Found:integer): boolean; inline; overload;
    public
        constructor Create;
        destructor Destroy; override;
        procedure LoadGNameList(aFilename: string);
        procedure SaveGNameList(aFilename: string = '');
        procedure Parse(Data: string); deprecated;
        procedure Feed(aText: string); override;
        procedure Error(sender: TObject; NewMessage: string); override;
        procedure LearnSexOfGivnName(aName: string; aSex: char);
        function GuessSexOfGivnName(aName: string): char;
        property onStartFamily: TParseEvent read FonStartFamily write SetonStartFamily;
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
        property LastErr: string read FLastErr;
        property LastMode: integer read FMode;
    end;

implementation

uses strutils, Unt_StringProcs;

const
    csMarriageEntr = '⚭';
    csMarriageEntr2 = 'oo';
    csMarriageEntr3 = '∞';
    csMarriageGC = 'Ehe:';
    csSeparatorGC = '●';
    csSeparator = ',';
    csDeathEntr = '†';
    csDeathEntr2 = '+';
    csDeathGefEntr = 'gefallen';
    csDeathVermEntr = 'vermisst';
    csIllegChild = 'o-o';
    csIllegChild2 = 'U';
    csProtectSpace = ' ';
    csDivorce = 'o/o';
    csBirth = '*';
    csBaptism = '*)';
    csBaptism2 = '~';
    csBurial = '†)';
    csBurial2 = '=';
    csSpouseKn = 'u.';
    csReferenceGC = 'PN =';
    csAdditional = 'Lebensphasen';
    csResidence = 'lebte';
    csEmigration = 'ausgewandert';
    csPlaceKenn = 'in';
    csKath = 'rk.';
    csKath2 = 'kath.';
    csEvang = 'ev.';
    csReform = 'ref.';
    csLuth = 'luth.';
    csUnknown = '…';

    cfgLearnUnknown = True;

    CUmLauts: array[0..7] of string = ('ä', 'ö', 'ü', 'Ä', 'Ö', 'Ü', 'ß', 'é');
    CTitel: array[0..8] of string =
        ('Graf', 'Erbgraf',
        'Gräfin',
        'Baron',
        'Baronin',
        'Prinz',
        'Prinzessin',
        'Freiherr',
        'Freiin');

    CDateModif: array[0..6] of string =
        ('ca','um','vor','nach','seit','frühestens','spätestens');

{ TFBEntryParser }

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

function TFBEntryParser.ParseAdditional(const aText: string; var pPos: int64;
  out aOutput: string): boolean;

begin
    Result := (length(aText) > ppos + 1) and
        ((aText[pPos + 1] in Charset + ['"']) or Testfor(aText, pPos + 1, FUmlauts));
    if Result then
      begin   // Additional Info
        aOutput := '';
        Inc(pPos);
        while (length(aText) > ppos) and (aText[pPos] <> ')') and
            (length(aOutput) < 90) do
          begin
            aOutput := aOutput + aText[pPos];
            Inc(pPos);
          end;
      end;
end;

function TFBEntryParser.HandleNonPersonEntry(const aSubString, lIndID: string):
TenumEventType;
var
    lEntryType: TenumEventType;
    lpp: integer;
    lPos: integer;
    lDate: string;
    lPlace, lSubString: string;

begin
    lSubString := trim(aSubString);
    if (lSubString = '') or (lSubString = '.') then
        exit;
    lpp := pos(' ' + csPlaceKenn + ' ', lSubString);
    // 1. Platz Kennung
    if lpp <> 0 then
      begin
        lPlace := copy(lSubString, lpp + 4, 255);
        lSubString := copy(lSubString, 1, lpp - 1);
      end
    else
        lPlace := '';
    lEntryType := GetEntryType(lSubString, lDate);

    if (lEntryType in [evt_Birth..evt_Burial]) and (length(lDate) > 1) and
        (lDate[1] in ['A'..'Z']) then
      begin  // 2. Platz Angabe
        lpos := ldate.IndexOf(' ');
        if lpos > 0 then
          begin
            lPlace := Leftstr(lDate, lpos);
            lDate := copy(lDate, lpos + 2);
          end;
      end;

  {                        if (length(ldate) > 3) and (lDate[length(ldate)] = '.') then
                              ldate := copy(lDate, 1, length(ldate) - 1);    }
    if (lEntryType > evt_ID) and (lEntryType <> evt_last) then
      begin
        if assigned(FonIndiDate) then
            FonIndiDate(self, lDate, lIndID,
                Ord(lEntryType));
        if assigned(FonIndiPlace) and (lPlace <> '') then
            FonIndiPlace(self, lPlace, lIndID, Ord(lEntryType));
      end
    else
      begin
        lEntryType := evt_Occupation;
        if (RightStr(lSubString, 1) = '.') and (lPlace = '') then
          begin
            // Todo: Prüfe ob Religionseintrag weiter
            lEntryType := evt_Religion;
            if assigned(FonIndiData) then
                FonIndiData(self, trim(lSubString),
                    lIndID, Ord(lEntryType));
          end
        else
        if Testfor(trim(lSubString), 1, CTitel) then
            if Assigned(FonIndiName) then
                FonIndiname(self, trim(lSubString), lIndID, 4)
            else
        else
        if assigned(FonIndiOccu) and (lSubString <> '') then
            FonIndiOccu(self, trim(lSubString), lIndID,
                Ord(lEntryType));
        if assigned(FonIndiPlace) and (lPlace <> '') then
            FonIndiPlace(self, lPlace, lIndID, Ord(lEntryType));
      end;
    Result := lEntryType;
end;

function TFBEntryParser.HandleGCDateEntry(const aText: string; var ppos: int64;
  lIndID: string; var lMode, lRetMode: integer; var aEntrytype: TenumEventType
  ): boolean;

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
    Result := False;
    if TestDate(csBirth, evt_Birth) or TestDate(csBaptism2, evt_Baptism) or
        TestDate(csDeathEntr, evt_Death) or TestDate(csBurial2, evt_Burial) then
        exit(True)
    else if lowercase(copy(aText, pPos, length(csDeathGefEntr))) = csDeathGefEntr then
      begin
        lRetMode := lMode;
        lMode := 101;
        Inc(pPos, length(csDeathGefEntr) - 1);
        if Assigned(FonIndiData) then
            FonIndiData(self, csDeathGefEntr, lIndID, Ord(evt_Death));
        aEntryType := evt_Death;
        Result := True;
      end
    else if lowercase(copy(aText, pPos, length(csDeathVermEntr))) =
        csDeathVermEntr then
      begin
        lRetMode := lMode;
        lMode := 101;
        Inc(pPos, length(csDeathVermEntr) - 1);
        if Assigned(FonIndiData) then
            FonIndiData(self, csDeathVermEntr, lIndID, Ord(evt_Death));
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

procedure TFBEntryParser.SetonStartFamily(AValue: TParseEvent);
begin
    if FonStartFamily = AValue then
        Exit;
    FonStartFamily := AValue;
end;

function TFBEntryParser.TestFor(const aText: string; pPos: int64;
  const aTest: string): boolean;
begin
    Result := copy(aText, pPos, length(aTest)) = aTest;
end;


function TFBEntryParser.TestFor(const aText: string; pPos: int64;
  const aTest: array of string; out Found: integer): boolean;
var i :integer;
begin
    Found := -1;
    Result := False;
    for i := 0 to high(Atest) do
        if TestFor(aText,ppos,atest[i]) then
          begin
             Found:=i;
             exit(true);
          end;
end;

function TFBEntryParser.TestFor(const aText: string; pPos: int64;
    const aTest: array of string): boolean;
var
  lFound: integer;
begin
  result := TestFor(aText,ppos,atest,lFound);
end;

constructor TFBEntryParser.Create;
begin
    FGNameList := TStringList.Create;
    FGNameList.Sorted := True;
    FUmlauts := CUmlauts;
end;

destructor TFBEntryParser.Destroy;
begin
    if FGNameListChanged and (FGNameFile <> '') then
      begin
        if FileExists(FGNameFile) then
            DeleteFile(FGNameFile);
        FGNameList.SaveToFile(FGNameFile);
      end;
    FreeAndNil(FGNameList);
    inherited Destroy;
end;

procedure TFBEntryParser.LoadGNameList(aFilename: string);
begin
    if FileExists(aFilename) then
        FGNameList.LoadFromFile(aFilename)
    else
        FGNameList.Clear; // Todo: Load Defaults
    FGNameFile := aFilename;
    FGNameListChanged := False;
end;

procedure TFBEntryParser.SaveGNameList(aFilename: string);
var
    lNewFile, lBakFile: string;
begin
    if (aFilename = '') and (FGNameFile = '') then
        exit;
    if aFilename <> '' then
        FGNameFile := aFilename;
    lNewFile := ChangeFileExt(FGNameFile, '.New');
    lBakFile := ChangeFileExt(FGNameFile, '.bak');
    if FileExists(lNewFile) then
        if FGNameFile = lNewFile then
          begin
            if FileExists(lBakFile) then
                DeleteFile(lBakFile);
            RenameFile(FGNameFile, lBakFile);
          end
        else
            DeleteFile(lNewFile);
    FGNameList.SaveToFile(lNewFile);
    if (FGNameFile <> lNewFile) then
      begin
        if FileExists(FGNameFile) then
          begin
            if FileExists(lBakFile) then
                DeleteFile(lBakFile);
            if (FGNameFile <> lBakFile) then
                RenameFile(FGNameFile, lBakFile);
          end;
        RenameFile(lNewFile, FGNameFile);
      end;
end;

function TFBEntryParser.TestEntry(lSubString, TestStr: string;
    out Date: string): boolean;

begin
    Result := copy(lSubString, 1, length(TestStr)) = TestStr;
    if Result then
        if copy(lSubString, length(TestStr) + 1, length(csProtectSpace)) =
            csProtectSpace then
            Date := trim(copy(lSubString, length(TestStr) +
                length(csProtectSpace) + 1, 255))
        else
            Date := trim(copy(lSubString, length(TestStr) + 1, 255));
end;

function TFBEntryParser.GetEntryType(lSubString: string;
    out Date: string): TenumEventType;

begin
    Result := evt_Last;
    if TestEntry(lSubString, csBaptism, Date) then
        Result := evt_Baptism
    else
    if TestEntry(lSubString, csBaptism2, Date) then
        Result := evt_Baptism
    else
    if TestEntry(lSubString, csBirth, Date) then
        Result := evt_Birth
    else
    if TestEntry(lSubString, csDeathEntr2, Date) then
        Result := evt_Death
    else
    if TestEntry(lSubString, csBurial, Date) then
        Result := evt_Burial
    else
    if TestEntry(lSubString, csDeathEntr, Date) then
        Result := evt_Death
    else
    if TestEntry(lSubString, csBurial2, Date) then
        Result := evt_Burial;
end;

function TFBEntryParser.HandleGCNonPersonEntry(const aSubString: string;
    const ActChar: char; const lIndID: string): boolean;

var
    lpp: integer;
    lPlace, lData, lSubString: string;

begin
    Result := False;
    lSubString := aSubString;
    if ((length(lSubString) < 4) and lSubString.EndsWith('.') and (lsubstring[1]in['a'..'z'])) or
        (length(trim(lSubString)) = 2) then
      begin // Religions-eintrag
        if (ActChar = '.') then
            lSubstring := lSubString + '.';
        if Assigned(FonIndiData) then
            FonIndiData(self, trim(lSubString), lIndID,
                Ord(evt_Religion));
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
            lPlace := '';
        for lData in lSubString.Split([',']) do
            if trim(lData) = 'Bürger' then
              begin
                if Assigned(FonIndiData) then
                    FonIndiData(self, trim(lData), lIndID,
                        Ord(evt_Residence));
                if Assigned(FonIndiPlace) and (lPlace <> '') then
                    FonIndiPlace(self, trim(lPlace),
                        lIndID, Ord(evt_Residence));
              end
            else if trim(lData) = csEmigration then
              begin
                if Assigned(FonIndiData) then
                    FonIndiData(self, '', lIndID,
                        Ord(evt_AddEmigration));
                if Assigned(FonIndiPlace) and (lPlace <> '') then
                    FonIndiPlace(self, trim(lPlace),
                        lIndID, Ord(evt_AddEmigration));
              end
            else if TestFor(trim(lData), 1, CTitel) then
              begin
                if Assigned(FonIndiName) then
                    FonIndiName(self, trim(lData), lIndID,4);
                if Assigned(FonIndiPlace) and (lPlace <> '') then
                    FonIndiPlace(self, trim(lPlace),
                        lIndID, Ord(evt_Occupation));
              end
            else
              begin

                if Assigned(FonIndiOccu) then
                    FonIndiOccu(self, trim(lData), lIndID,
                        Ord(evt_Occupation));
                if Assigned(FonIndiPlace) and (lPlace <> '') then
                    FonIndiPlace(self, trim(lPlace),
                        lIndID, Ord(evt_Occupation));
              end;
        Result := True;
      end;
end;

procedure TFBEntryParser.Feed(aText: string);
var
    lMode, lRetMode: integer;
    lSubString, // Aktueller Unterstring
    lDebug,  //DEBUG: String ab aktueller Position (20 Char)
    lMainFamRef, // Haupt-Familienreferenz
    lIndID, // Aktuelle Personen-ID
    lParentRef, lFamName, lLastName, lChRef, lPersonName, lIndID2,
    lFamCEntry, lData, lPlace, lDate, lEventDate, lChildFam, lFamRef,
    lPersonGName, lTitel, lAdditional: string;
    lPos, lChildCount, lGCEntry, lFamType, lpp, lRetMode2, lRefMode2,
    lTest, lZiffCount, lLastZiffCount, lRetMode3, lFound: integer;
    Names: TStringArray;
    lFirstEntry, lPlaceFlag, lSecondEntry, lParDeathFlag, lSuccess: boolean;
    lEntryType, lEntryType2: TenumEventType;
    lPersonType, lPersonSex, lPersonSex2, lPersonType2: char;
    lInt: longint;

begin
    Offset := 1;
    lMode := 0;
    lGCEntry := 0;
    while Offset <= length(atext) do
      begin
        case lMode of
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
                if aText[Offset] in Whitespace then
                  begin
                    lMode := 2;
                    lpp := lSubString.LastIndexOfAny(
                        ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a']);
                    if lpp > 0 then
                      begin
                        Dec(Offset, length(lSubString) - lpp);
                        lsubstring := left(lSubString, lpp + 1);
                      end;
                    if Assigned(FonStartFamily) then
                        FonStartFamily(self, lSubString, '', 0);
                    lMainFamRef := lSubString;
                    FMainRef := lMainFamRef;
                  end
                else
                    lSubString := lSubstring + aText[Offset];
              end;
            2:
                if (aText[Offset - 1] = ' ') and not
                    TestFor(aText, Offset, 'Ehe:') then
                  begin
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
                        Dec(Offset);
                      end;
                  end;
            3:
              begin  // Entry Type
                if (aText[Offset] in Whitespace + ['.', ':']) or
                    (length(lSubString) > 3) then
                  begin
                    if (copy(lSubString, 1, length(csMarriageEntr)) = csMarriageEntr) or
                        (copy(lSubString, 1, length(csMarriageEntr3)) =
                        csMarriageEntr3) or (lSubString = csMarriageEntr2) then
                      begin
                        lMode := 10;
                        if Assigned(FonFamilyType) then
                            FonFamilyType(self, '', lMainFamRef, 1);
                        lSubString := '';
                        if aText[Offset] = '.' then
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
                        lGCEntry := 1;
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
                        if Assigned(FonFamilyType) then
                            FonFamilyType(self, lFamCEntry, lMainFamRef, lfamtype);
                        lSubString := '';
                      end
                    else
                    if TestFor(lSubString, 1, [csDeathEntr, csDeathEntr2]) then
                      begin
                        lMode := 20;
                        lEntryType := evt_Death;
                        if Assigned(FonFamilyType) then
                            FonFamilyType(self, '', lMainFamRef, 2);
                        lSubString := '';
                      end
                    else
                    if (left(lSubString, length(csIllegChild)) = csIllegChild) then
                      begin
                        lMode := 30;
                        lEntryType := evt_Birth;
                        if Assigned(FonFamilyType) then
                            FonFamilyType(self, '', lMainFamRef, 3);
                        Dec(Offset);
                        lSubString := '';
                      end
                    else
                      begin
                        lEntryType := evt_Residence;
                        lMode := 40;
                      end;
                  end
                else
                    lSubString := lSubstring + aText[Offset];
              end;
            5, 7:
              begin
                if aText[Offset] in Charset + [' '] then
                    lSubString := lSubstring + aText[Offset]
                else if copy(aText, Offset, length(csUnknown)) = csUnknown then
                  begin
                    lSubString := lSubstring + csUnknown;
                    Inc(Offset, Length(csUnknown) - 1);
                  end
                else
                if (aText[Offset] = '.') and (aText[Offset + 1] = ' ') then
                    lSubString := lSubstring + aText[Offset]
                else if testfor(aText, Offset, FUmlauts) then
                  begin
                    lSubString :=
                        lSubstring + aText[Offset] + atext[Offset + 1];
                    Inc(Offset);
                  end
                else if length(trim(lSubString)) > 0 then
                  begin
                    lPersonName := trim(lSubString);
                    Names := lPersonName.Split([' ']);
                    lTitel := '';
                    if Names[0] = 'Dr.' then // Todo: weitere Titel
                      begin
                        lTitel := 'Dr.';
                        lPersonName := copy(lPersonName, length(lTitel) + 2);
                      end;
                    lLastName := Names[high(Names)];

                    if lPersonType = 'U' then
                        lPersonSex :=
                            GuessSexOfGivnName(copy(lPersonName, 1,
                            length(lPersonName) - length(lLastName) - 1))
                    else
                        lPersonSex := lPersonType;

                    lIndID := 'I' + lMainFamRef + lPersonSex;

                    if lMode = 5 then
                        lFamName := lLastName;
                    if Assigned(FonIndiName) then
                        FonIndiName(self, lPersonName, lIndID, 0);
                    if Assigned(FonIndiName) and (lTitel <> '') then
                        FonIndiName(self, lTitel, lIndID, 4);
                    if Assigned(FonFamilyIndiv) then
                        FonFamilyIndiv(self, lIndID, lMainFamRef, lMode div 2 - 1);
                    if Assigned(FonIndiData) then
                        FonIndiData(self, lPersonSex, lIndID, Ord(evt_Sex));
                    if lpersonsex in ['M', 'F'] then
                        LearnSexOfGivnName(
                            copy(lPersonName, 1, length(lPersonName) -
                            length(lLastName) - 1), lPersonType);
                    if (lmode = 5) and (lEntryType <> evt_Marriage)
                    then
                      begin
                        if Assigned(FonIndiData) and (lData <> '') then
                            FonIndiData(self, lData, lIndID, Ord(lEntryType));
                        if Assigned(FonIndiData) and (lPlace <> '') then
                            FonIndiData(self, lPlace, lIndID, Ord(lEntryType));
                        if Assigned(FonIndiData) and (lEventDate <> '') then
                            FonIndiData(self, lEventDate, lIndID, Ord(lEntryType));
                      end;
                    lSubString := '';
                    if (aText[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID, 3); //AKA
                        Inc(Offset);
                      end;
                    if aText[Offset] = '<' then
                      begin
                        lRetMode := lMode + 1;
                        lMode := 50;
                      end
                    else
                      begin
                        lMode := lMode + 1;
                        lSubString := '';
                        lAdditional := '';
                      end;
                    Dec(Offset);
                  end;
              end;
            6:
              begin // Person-Info
                if aText[Offset] in Ziffern then
                    Inc(lZiffCount)
                else
                  begin
                    if lZiffCount > 0 then
                        lLastZiffCount := lZiffCount;
                    lZiffCount := 0;
                  end;
                if not (aText[Offset] in ['<', ';', '.', ',', '(', #10,
                    #13, csDeathEntr[1]])
                then
                    lSubString := lSubstring + aText[Offset]
                else if (Offset < Length(aText)) and
                    (aText[Offset] = '.') and
                    ((atext[Offset + 1] in Ziffern) or
                    ((atext[Offset + 1] = ' ') and (lLastZiffCount < 3))) then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset] = csDeathEntr[1]) and (length(lSubString) < 5) then
                    lSubString := lSubstring + aText[Offset]

                else if length(lSubString) > 1 then
                  begin
                    // Verarbeite Eintrag
                    if (right(trim(lSubString), 4) = ' alt') and
                        (trim(lSubString)[1] in Ziffern) and
                        (lEntryType = evt_Death) then
                      begin
                        if Assigned(FonIndiData) then
                            FonIndiData(self, trim(lSubString), lIndID, Ord(lEntryType));
                        lSubString := '';
                        Continue;
                      end;
                    lEntryType := HandleNonPersonEntry(lSubString, lIndID);
                    lSubString := '';
                    if (aText[Offset] = '(') and ParseAdditional(aText,
                        Offset, lAdditional) then
                      begin
                        if (lEntryType <> evt_Marriage) and Assigned(FonIndiData) then
                            FonIndiData(self, trim(lAdditional),
                                lIndID, Ord(lEntryType));
                        lSubString := '';
                      end;
                  end;
                if aText[Offset] = '<' then
                  begin
                    lRetMode := lMode;
                    lMode := 50;
                    Dec(Offset);
                  end
                else
                if (aText[Offset] in whitespace) and
                    (copy(atext, Offset + 1, 3) = 'u. ') then
                  begin
                    lSubString := trim(lSubString);
                    lEntryType := GetEntryType(lSubString, lDate);
                    if (lEntryType > evt_ID) and (lEntryType <> evt_last) then
                      begin
                        if assigned(FonIndiDate) then
                            FonIndiDate(self, lDate, lIndID, Ord(lEntryType));
                      end
                    else
                    ;

                    lmode := 7;
                    lPersonType := 'F';
                    Inc(Offset, 2);
                    lSubString := '';
                  end;
              end;
            8:
              begin // Person-Info
                if aText[Offset] in Ziffern then
                    Inc(lZiffCount)
                else
                  begin
                    if lZiffCount > 0 then
                        lLastZiffCount := lZiffCount;
                    lZiffCount := 0;
                  end;
                if not (aText[Offset] in [';', '.', ',', '(', #10, #13,
                    csDeathEntr[1]]) then
                    lSubString := lSubstring + aText[Offset]
                else if (Offset < Length(aText)) and
                    (aText[Offset] = '.') and
                    ((atext[Offset + 1] in Ziffern) or
                    ((atext[Offset + 1] = ' ') and (lLastZiffCount < 3))) then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset] = csDeathEntr[1]) and (length(lSubString) < 5) then
                    lSubString := lSubstring + aText[Offset]
                else if length(lSubString) > 1 then
                  begin
                    lEntryType := HandleNonPersonEntry(lSubString, lIndID);
                    lSubString := '';
                    if (aText[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin   // Additional Info
                        lSubString := '';
                        if (lEntryType <> evt_Marriage) and Assigned(FonIndiData) then
                            FonIndiData(self, trim(lAdditional),
                                lIndID, Ord(lEntryType));
                      end
                    else if (aText[Offset] = csDeathEntr[1]) then
                        Dec(Offset);
                  end;
                if (aText[Offset] in Ziffern) and (copy(atext, Offset + 1, 3) = ' Kd') then
                  begin
                    lSubString := trim(lSubString);
                    lEntryType := GetEntryType(lSubString, lDate);
                    if (lEntryType > evt_ID) and (lEntryType <> evt_last) then
                      begin
                        if assigned(FonIndiDate) then
                            FonIndiDate(self, lDate, lIndID, Ord(lEntryType));
                      end
                    else
                    ;
                    lmode := 9;
                    lPersontype := 'U';
                    lSubString := '';
                    lAdditional := '';
                    Inc(Offset, 4);
                    while aText[Offset] in ['.', ':', 'r'] do
                        Inc(Offset);
                    lChildcount := 1;
                    lFirstEntry := True;
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
                if lFirstEntry and (aText[Offset] in Charset + [' ', '.']) then
                    lSubString := lSubstring + aText[Offset]
                else if not lFirstEntry and not
                    (aText[Offset] in [';', '.', ',', '(', '<', '-', #10, #13]) then
                    lSubString := lSubstring + aText[Offset]
                else if not lFirstEntry and (Offset < Length(aText)) and
                    (aText[Offset] = '.') and ((atext[Offset + 1] in Ziffern) or
                    ((atext[Offset + 1] = ' ') and (lLastZiffCount < 3))) then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset] = '(') and
                    ParseAdditional(aText, Offset, lAdditional) then
                  begin
                    if Assigned(FonIndiData) and not lFirstEntry then
                      begin
                        FonIndiData(self, lAdditional, lIndID, Ord(lEntryType));
                        lAdditional := '';
                      end;
                    lSubString := '';
                  end
                else
                  begin
                    if lFirstEntry and (lSubString <> '') then
                      begin
                        lPersonGName := trim(lSubString);
                        lPersonName := trim(lSubString) + ' ' + lFamName;
                        lPersonSex := GuessSexOfGivnName(trim(lSubString));
                      end;
                    if aText[Offset] = '<' then
                      begin
                        lRetmode := lMode;
                        lMode := 50;
                        lChRef := '';
                        lPos := Offset + 1;
                        lPersonSex := GuessSexOfGivnName(lPersonGName);
                        while (lPos < length(aText)) and
                            (aText[lPos] in Ziffern + ['a']) do
                          begin
                            lChRef := lChRef + aText[lPos];
                            Inc(lpos);
                          end;
                        if lPersonSex in ['M', 'F'] then
                            lIndID := 'I' + lChRef + lPersonSex
                        else
                            lIndID := 'I' + lChRef + '_';
                      end
                    else
                    if lFirstEntry then
                        lIndID := 'I' + lMainFamRef + 'C' + trim(IntToStr(lChildCount));
                    if lFirstEntry and (lSubString <> '') then
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lPersonName, lIndID, 0);
                        if Assigned(FonFamilyIndiv) then
                            FonFamilyIndiv(self, lIndID, lMainFamRef, 2 + lChildcount);
                        if Assigned(FonIndiData) and (lPersonSex in ['M', 'F']) then
                            FonIndiData(self, lPersonSex, lIndID, Ord(evt_Sex));
                        if Assigned(FonIndiName) and (lAdditional <> '') then
                            FonIndiName(self, lAdditional, lIndID, 3); //AKA
                        lAdditional := '';
                        lChildCount := lChildcount + 1;
                        lSubString := '';
                        if aText[Offset] in Ziffern then
                            lSubString := csBirth + ' ' + aText[Offset];
                        lFirstEntry := False;
                      end
                    else
                    if (lSubString <> '') then
                      begin
                        lEntryType := HandleNonPersonEntry(lSubString, lIndID);
                        lSubString := '';

                      end;
                    if aText[Offset] = '-' then
                      begin  // Neuer Eintrage GGF. über Mode 8
                        lSubString := '';
                        lAdditional := '';
                        lFirstEntry := True;
                      end;
                  end;
              end;
            10:
              begin // Ehe Datum & Ort ?
                if aText[Offset] in Ziffern + ['.'] then
                    lSubString := lSubstring + aText[Offset]
                else
                if copy(aText, Offset, length(csUnknown)) = csUnknown then
                  begin
                    lSubString := lSubstring + csUnknown;
                    Inc(Offset, Length(csUnknown) - 1);
                  end
                else
                  begin
                    if length(lSubString) > 1 then
                      begin
                        lEventDate := lSubString;
                        if Assigned(FonFamilyDate) then
                            FonFamilyDate(self, lSubString, lMainFamRef,
                                Ord(evt_Marriage));
                        lSubString := '';
                        lMode := 11;
                      end;
                    if aText[Offset] = ':' then
                        lMOde := 5;
                  end;
              end;
            11: // ort
              begin
                if aText[Offset] in Charset + ['.'] + whitespace then
                    lSubString := lSubstring + aText[Offset]
                else
                  begin
                    if Assigned(FonFamilyPlace) and (lEntryType = evt_Marriage) then
                        FonFamilyPlace(self, lSubString, lMainFamRef, 3)
                    else
                        lPlace := lSubString;
                    lSubString := '';
                    if aText[Offset] = ':' then
                        lMOde := 5
                    else
                    if (aText[Offset] = '(') and
                        ParseAdditional(aText, Offset, lAdditional) then
                      begin   // Additional Info
                        if (lEntryType = evt_Marriage) and Assigned(FonFamilyData) then
                            FonFamilyData(self, trim(lAdditional),
                                lMainFamRef, Ord(lEntryType))
                        else
                            lData := trim(lAdditional);
                        lSubString := '';
                      end;

                  end;
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
                        lPlace := '';
                        lMode := 11;
                      end;
                    if aText[Offset] = ':' then
                        lMOde := 5;
                  end;
              end;
            30:
              begin // Tod Datum & Ort ?
                if aText[Offset] in Ziffern + ['.'] then
                    lSubString := lSubstring + aText[Offset]
                else
                  begin
                    if length(lSubString) > 2 then
                      begin
                        lEventDate := lSubString;
                        lSubString := '';
                        lPlace := '';
                        lMode := 11;
                      end;
                    if aText[Offset] = ':' then
                        lMOde := 5;
                  end;
              end;
            50:
              begin // Referenzen
                lSubString := '';
                if copy(aText, Offset, 3) = 'aus' then
                    lMode := 51
                else if TestFor(aText, Offset, ['S.d.', 'T.d.', 'S.d,', 'T.d,']) then
                    lMode := 54
                else if (copy(aText, Offset, 4) = 's.a.') then
                    lMode := 52
                else if (copy(aText, Offset, length(csMarriageEntr)) = csMarriageEntr) then
                    lMode := 53
                else if (copy(aText, Offset, length(csMarriageEntr3)) =
                    csMarriageEntr3) then
                    lMode := 53
                else if aText[Offset] = '>' then
                    lMode := lRetMode;
              end;
            51:
              begin
                if (aText[Offset] in Ziffern) or
                    ((length(lSubString) > 0) and (aText[Offset] = 'a')) then
                    lSubString := lSubString + aText[Offset]
                else if length(lSubString) > 0 then
                  begin
                    if assigned(FonIndiRel) then
                        FonIndiRel(self, lSubString, lIndID, 1);
                    if aText[Offset] = '>' then
                        Dec(Offset);
                    lMode := 50;
                  end;
              end;
            52:
              begin
                if (aText[Offset] in Ziffern) or
                    ((length(lSubString) > 0) and (aText[Offset] = 'a')) then
                    lSubString := lSubString + aText[Offset]
                else if length(lSubString) > 0 then
                  begin
                    if assigned(FonIndiRel) then
                        FonIndiRel(self, lSubString, lIndID, 2);
                    lMode := 50;
                    if aText[Offset] = '>' then
                        Dec(Offset)
                    else
                    if aText[Offset] = ',' then
                        lMode := 52;
                  end;
              end;
            53:
              begin
                if (aText[Offset] in Ziffern) or
                    ((length(lSubString) > 0) and (aText[Offset] = 'a')) then
                    lSubString := lSubString + aText[Offset]
                else if testfor(atext, Offset, ' mit ') then
                  begin
                    if lFamRef = '' then
                        lFamRef := lMainFamRef;
                    lpp := atext.IndexOf('>', Offset);
                    if lpp > 0 then
                      begin
                        lPersonName := copy(atext, Offset + 5, lpp - Offset - 4);
                        if lPersonSex = 'M' then
                            lPersonSex2 := 'F'
                        else
                            lPersonSex2 := 'M';
                        lIndID2 := 'I' + lFamRef + lPersonSex2;
                        if assigned(FonIndiName) then
                            FonIndiName(self, lPersonName, lIndID2, 0);
                        if assigned(FonFamilyType) then
                            FonFamilyType(self, '', lFamRef, 1);
                        if assigned(FonFamilyIndiv) and (lPersonSex2 = 'F') then
                            FonFamilyIndiv(self, lIndID2, lFamRef, 2)
                        else
                        if assigned(FonFamilyIndiv) then
                            FonFamilyIndiv(self, lIndID2, lFamRef, 1);
                        if assigned(FonIndiData) then
                            FonIndiData(self, lPersonSex2, lIndID2, Ord(evt_Sex));
                        Offset := lpp - 1;
                        lMode := 50;
                      end;
                  end
                else if length(lSubString) > 0 then
                  begin
                    if assigned(FonIndiRel) then
                        FonIndiRel(self, lSubString, lIndID, 2);
                    lMode := 50;
                    if aText[Offset] = '>' then
                        Dec(Offset)
                    else
                    if aText[Offset] = ',' then
                        lMode := 53;
                  end;
              end;
            54:
              begin
                Inc(Offset, 3);
                lParentRef := copy(lIndID, 2, 20);
                if Assigned(FonStartFamily) then
                    FonStartFamily(self, lParentRef, '', 0);
                if Assigned(FonFamilyIndiv) then
                    FonFamilyIndiv(self, lIndID, lParentRef, 3);
                lMode := 55;
                lSubString := '';
                lFirstEntry := True;
              end;
            55, 56:
              begin // Eltern-Name
                if not (aText[Offset] in [';', ',', '>', '(']) then
                    lSubString := lSubString + aText[Offset]
                else
                if lFirstEntry and (lSubString <> '') then
                  begin
                    lPersonName := trim(lSubString);
                    if copy(lPersonName, 1, length(csDeathEntr)) = csDeathEntr then
                      begin
                        lPersonName := copy(lPersonName, length(csDeathEntr) + 1, 200);
                        if copy(lPersonName, 1, length(csProtectSpace)) =
                            csProtectSpace then
                            lPersonName :=
                                copy(lPersonName, length(csProtectSpace) + 1, 200);
                        lParDeathFlag := True;
                      end
                    else
                        lParDeathFlag := False;
                    if lmode = 55 then
                        lPersonSex2 :=
                            GuessSexOfGivnName(left(lPersonName,
                            length(lPersonName) - 2))
                    else
                        lPersonSex2 := 'F';
                    lIndID2 := 'I' + lParentRef + lPersonSex2;

                    if right(lPersonName, 2) = left(lLastName, 1) + '.' then
                        lPersonName :=
                            left(lPersonName, length(lPersonName) - 2) + lLastName;

                    if lmode = 56 then
                      begin
                        lpos := lPersonName.IndexOf(' geb.');
                        if lpos > 0 then
                          begin
                            lPersonName :=
                                left(lPersonName, lpos) + copy(lPersonName, lPos + 6);
                            if Assigned(FonFamilyType) then
                                FonFamilyType(self, '', lParentRef, 1);
                          end;
                      end;
                    if Assigned(FonIndiName) then
                        FonIndiName(self, lPersonName, lIndID2, 0);
                    if lParDeathFlag and Assigned(FonIndiDate) then
                        FonIndiDate(self, 'vor ' + lEventDate,
                            lIndID2, Ord(evt_Death));
                    if Assigned(FonFamilyIndiv) then
                        FonFamilyIndiv(self, lIndID2, lParentRef, lmode - 54);
                    if (lPersonSex2 in ['M', 'F']) and Assigned(FonIndiData) then
                        FonIndiData(self, lPersonSex2, lIndID2, Ord(evt_Sex));

                    lSubString := '';
                    lFirstEntry := False;
                  end
                else
                if (lSubString <> '') then
                  begin
                    lEntryType2 := evt_Occupation;
                    lSubString := trim(lSubString);
                    lpp := pos(' ' + csPlaceKenn + ' ', lSubString);
                    if lpp <> 0 then
                      begin
                        lPlace := copy(lSubString, lpp + 4, 255);
                        lSubString := copy(lSubString, 1, lpp - 1);
                      end
                    else
                    if left(lSubString, 3) = csPlaceKenn + ' ' then
                      begin
                        lPlace := copy(lSubString, 4);
                        lEntryType2 := evt_Residence;
                      end
                    else
                        lPlace := '';
                    if lEntryType2 = evt_Occupation then
                        if assigned(FonIndiOccu) then
                            FonIndiOccu(self, trim(lSubString), lIndID2,
                                Ord(lEntryType2));
                    if assigned(FonIndiPlace) and (lPlace <> '') then
                        FonIndiPlace(self, lPlace, lIndID2, Ord(lEntryType2));
                    lSubString := '';
                  end;
                if (lMode = 55) and
                    ((copy(aText, Offset + 1, 4) = 'u.d.') or
                    (copy(aText, Offset + 1, 4) = 'u.d,')) then
                  begin
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
                  end;

              end;
{            56:
              begin
                if not (aText[Offset] in [',', '>', '(']) then
                    lSubString := lSubString + aText[Offset]
                else
                if lFirstEntry and (lSubString <> '') then
                  begin

                    lIndID2 := 'I' + lParentRef + 'F';

                    if copy(lSubString, length(lSubString) - 1, 2) =
                        copy(lLastName, 1, 1) + '.' then
                        lSubString :=
                            Copy(lSubString, 1, length(lSubString) - 2) + lLastName;
                    lPersonName := trim(lSubString);
                    if Assigned(FonIndiName) then
                        FonIndiName(self, lPersonName, lIndID2, 1);
                    if Assigned(FonFamilyIndiv) then
                        FonFamilyIndiv(self, lIndID2, lParentRef, 2);
                    lSubString := '';
                    lFirstEntry := False;
                  end;
                if aText[Offset] = '>' then
                  begin
                    Dec(Offset);
                    lMode := 50;
                  end;
              end;  }
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
                if (lsubstring='') and testfor(atext,Offset,CDateModif,lFound) then
                begin
                      inc(Offset,length(CDateModif[lFound]));
                      lSubString := lSubstring+CDateModif[lFound];
                      if atext[Offset] in [' ','.'] then
                        lSubString := lSubstring+atext[Offset]
                      else
                        dec(Offset);
                 end
                else
                  begin
                    if length(lSubString) > 2 then
                      begin
                        if (lEntryType = evt_Marriage) then
                          begin
                            lEventDate := lSubString;
                            if Assigned(FonFamilyDate) then
                                FonFamilyDate(self, lSubString, lFamRef,
                                    Ord(lEntryType));
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
                    not TestFor(aText, Offset,[csSeparatorGC, vbNewLine, ' mit ']) then
                    lSubString := lSubstring + aText[Offset]
                else if (aText[Offset] = '.') and (not testfor(aText, Offset+1, [' ',#9,vbNewLine,'PN']) or
                     ((length(lSubString)<4) and (lSubstring<>'') and (lSubstring[1] in ['A'..'Z']))) then
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
                        FonIndiPlace(self, trim(lSubString), lIndID, Ord(lEntryType));
                    lSubString := '';
                  end;
                  if (aText[Offset] = '(') and ParseAdditional(aText, Offset, lAdditional) then
                  begin
                    if (lEntryType <> evt_Marriage) and
                        Assigned(FonIndiData) then
                        FonIndiData(self, trim(lAdditional), lIndID, Ord(lEntryType));
                    lSubString := '';
                  end
                else
                if (aText[Offset] in [csSeparator, '<', '[', '.']) or
                    TestFor(aText, Offset, [csSeparatorGC,vbNewLine,' mit ']) then
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
                if aText[Offset] in Charset + ['.',  '-'] then
                    lSubString := lSubstring + aText[Offset]
                else if (atext[Offset]=' ') and not
                  testfor(aText, Offset+1,
                    [csMarriageEntr2,csIllegChild]) then
                  lSubString := lSubstring + aText[Offset]
                else if Testfor(aText, Offset, FUmlauts,lFound) then
                  begin
                    lSubString := lSubstring + FUmlauts[lFound];
                    Inc(Offset,length(FUmlauts[lFound])-1);
                  end
                else if lFirstEntry and (lSubString <> '') then
                  begin
                    lIndID := 'I' + lMainFamRef + lPersonType;
                    if Assigned(FonIndiName) then
                        FonIndiName(self, trim(lSubString), lIndID, 1);
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
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID, 3); //AKA
                      end;
                  end
                else if lSubString <> '' then
                  begin
                    if lEntryType = evt_GivenName then
                      begin
                        lPersonGName := trim(lSubString);
                        if (length(lPersonGName) < 4) and
                            (lPersonGName.EndsWith('.') or (length(lPersonGName) = 2)) and
                            (lPersonGName[1] in ['a'..'z']) then
                          begin
                            if Assigned(FonIndiName) then
                                FonIndiName(self, 'NN', lIndID, 2);
                            if Assigned(FonIndiData) then
                                FonIndiData(self, lPersonGName,
                                    lIndID, Ord(evt_Religion));
                            lMode := 112;
                          end
                        else
                          begin
                            if Assigned(FonIndiName) then
                                FonIndiName(self, trim(lSubString), lIndID, 2);
                            if lPersonType in ['M', 'F'] then
                              begin
                                lPersonSex := lPersonType;
                                if Assigned(FonIndiData) then
                                    FonIndiData(self, lPersonType, lIndID, Ord(evt_Sex));
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
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID, 3); //AKA
                      end;
                    if (aText[Offset] = '"') and (lEntryType = evt_GivenName) then
                      begin
                        lEntryType := evt_AKA;
                      end
                    else
                        lMode := 112;
                    if testfor(aText, Offset, [' ' + csMarriageEntr2 + ' ',
                        ' ' + csIllegChild + ' ']) then
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
                else if (aText[Offset] = '.') and ((copy(aText, Offset + 1, 1) <> ' ') or
                 ((right(lSubString,4).IndexOf(' ')<>-1)
                   and (right(lSubString,4)[right(lSubString,4).IndexOf(' ')+2] in ['A'..'Z']))) then
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
                else if testfor(aText, Offset, [' ' + csMarriageEntr2 + ' ',
                    ' ' + csIllegChild + ' ']) then
                  begin
                    lMode := 114;
                    lSubString := '';
                  end
                else if HandleGCDateEntry(aText, Offset, lIndID, lMode,
                    lRetMode, lEntryType) then
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
                if testfor(atext, Offset, [csResidence+' ']) then
                  begin
                    lEntryType := evt_AddResidence;
                    Inc(Offset, length(csResidence));
                    if Assigned(FonIndiData) then
                        FonIndiData(self, '', lIndID, Ord(lEntryType));
                    if Assigned(FonIndiDate) and (ldate <> '') then
                        FonIndiDate(self, lDate, lIndID, Ord(lEntryType));
                    lSubString := '';
                    ldate := '';
                  end
                else
                if testfor(atext, Offset, [csEmigration+ ' ']) then
                  begin
                    lEntryType := evt_AddEmigration;
                    Inc(Offset, length(csEmigration));
                    if Assigned(FonIndiData) then
                        FonIndiData(self, '', lIndID, Ord(lEntryType));
                    if Assigned(FonIndiDate) and (ldate <> '') then
                        FonIndiDate(self, lDate, lIndID, Ord(lEntryType));
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
                else if (lDate='') and ((testfor(atext,Offset,CDateModif,lFound) or
                     (atext[Offset] in Ziffern))) then
                      begin
                        if lfound >=0 then
                           begin
                             inc(Offset,length(CDateModif[lFound]));
                             lDate := CDateModif[lFound];
                             if atext[Offset] in ['.',' ']then
                                begin
                                  lDate := lDate+atext[Offset];
                                  inc(Offset);
                                end;
                           end;
                        while (offset+1 < length(atext)) and
                           (( atext[Offset] in Ziffern+[' ']) or
                            ((atext[Offset]='.') and (atext[Offset+1] in Ziffern))) do
                             begin
                              lDate := lDate+atext[Offset];
                              inc(offset);
                             end;
                        dec(offset);
                      end
                else
                if not (atext[Offset] in Whitespace + ['.']) then
                    lSubString := lSubString + atext[Offset]
                else if (atext[Offset] = '.') and ((atext[Offset + 1] in Ziffern) or
                    (length(lSubString) = 2)) then
                    lSubString := lSubString + atext[Offset]
                else if (atext[Offset] = ' ') and
                    (((atext[Offset - 1] in ['.', ',', ')']) and (lSubString <> '')) or
                    testfor(lSubString,1,CDateModif) or lPlaceFlag) then
                    lSubString := lSubString + atext[Offset]
                else if lSubString <> '' then
                  begin
                    if lPlaceFlag then
                      begin
                        if lDate<>'' then
                           begin
                             lEntryType:=evt_AddResidence;
                             if Assigned(FonIndiDate) and (lDate <> '') then
                                 FonIndiDate(self, trim(lDate), lIndID, Ord(lEntryType));
                             lDate:='';
                           end;
                        if Assigned(FonIndiPlace) then
                            FonIndiPlace(self, lSubString, lIndID, Ord(lEntryType));
                        lSubString := '';
                        lPlaceFlag := False;
                        lEntryType := evt_AddOccupation;
                      end
                    else
                      begin
                        if Assigned(FonIndiData) then
                            FonIndiData(self, lSubString, lIndID, Ord(lEntryType));
                        if Assigned(FonIndiDate) and (lDate <> '') then
                            FonIndiDate(self, trim(lDate), lIndID, Ord(lEntryType));
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
                if Assigned(FonFamilyType) then
                    FonFamilyType(self, lFamCEntry, lChildFam, lFamType);
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
                if (copy(aText, Offset, length('mit')) = 'mit') then
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
                    if Assigned(FonIndiName) then
                        FonIndiName(self, trim(lSubString), lIndID2, 1);
                    if Assigned(FonFamilyIndiv) then
                        if lPersonType2 = 'M' then
                            FonFamilyIndiv(self, lIndID2, lFamRef, 1)
                        else
                            FonFamilyIndiv(self, lIndID2, lFamRef, 2);

                    lLastName := trim(lSubString);
                    lFirstEntry := False;
                    lEntrytype := evt_Last;
                    lSubString := '';
                    if (atext[Offset] = '(') and ParseAdditional(aText,
                        Offset, lAdditional) then
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID, 3); //AKA
                      end;
                  end
                else
                  begin
                    if Assigned(FonIndiName) then
                        FonIndiName(self, trim(lSubString), lIndID2, 2);
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
                    if (atext[Offset] = '(') and ParseAdditional(aText,
                        Offset, lAdditional) then
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID, 3); //AKA
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
                    if Assigned(FonIndiName) then
                        FonIndiName(self, lFamName, lIndID, 1);
                    if Assigned(FonFamilyIndiv) then
                        FonFamilyIndiv(self, lIndID, lMainFamRef, 2 + lChildCount);
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
                    if Assigned(FonIndiName) then
                        FonIndiName(self, lFamName, lIndID, 1);
                    if Assigned(FonFamilyIndiv) then
                        FonFamilyIndiv(self, lIndID, lMainFamRef, 2 + lChildCount);
                    lSubString := '';
                  end
                else
                if testfor(aText, Offset, [csMarriageEntr2 + ' ',
                    csIllegChild + ' ']) then
                  begin
                    lRetMode3 := lMode+2;
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
                    if Assigned(FonIndiName) then
                        FonIndiName(self, trim(lSubString), lIndID, 1);
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
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lPersonGName, lIndID, 2);
                        lPersonSex := GuessSexOfGivnName(trim(lSubString));
                        if (lPersonSex in ['M', 'F']) and Assigned(FonIndiData) then
                            FonIndiData(self, lPersonSex, lIndID, 6);
                        lFirstEntry := False;
                        lMode := 123;
                      end;
                    lSubString := '';
                    if (atext[Offset] = '(') and ParseAdditional(aText,
                        Offset, lAdditional) then
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID, 3); //AKA
                      end;
                    if lMode = 123 then
                        Dec(Offset);
                  end;

              end;
            123:
              begin // Todo: Merge with 112
                if not (aText[Offset] in ['.', ',', '<', '[', #10, #13]) and
                    not Testfor(aText, Offset, [' ' + csMarriageEntr2 +
                    ' ', ' ' + csIllegChild + ' ']) then
                    lSubString := lSubstring + aText[Offset]
                    else if (aText[Offset] = '.') and ((copy(aText, Offset + 1, 1) <> ' ') or
                     ((right(lSubString,4).IndexOf(' ')<>-1)
                       and (right(lSubString,4)[right(lSubString,4).IndexOf(' ')+2] in ['A'..'Z']))) then
                  begin
                    lSubstring := lSubString + '.';
                  end
                else if (aText[Offset] = ',') and (trim(lSubstring) = 'Bürger') then
                  begin
                    lSubstring := lSubString + ',';
                  end
                else if HandleGCNonPersonEntry(lSubString,atext[Offset],lIndID) then
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
                if testfor(aText, Offset, [' ' + csMarriageEntr2 + ' ',
                    ' ' + csIllegChild + ' ']) then
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
                else if HandleGCDateEntry(aText, Offset, lIndID, lMode,
                    lRetMode, lEntryType) then
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
                lFamCEntry:='';
                lFamRef := copy(lIndID, 2, 20);
                if (copy(aText, Offset, length(csIllegChild)) = csIllegChild) then
                    lFamType := 2
                else
                  begin
                    lFamType := 1;
                    if aText[Offset + 4] = '/' then
                      begin
                        lFamCEntry := copy(aText, Offset + 3, 3);
                        lFamRef:=lFamRef+'S'+Char(ord(lFamCEntry[1])+ord(lFamCEntry[3])-ord('1'));
                        Inc(Offset, 4);
                      end;
                  end;
                if Assigned(FonStartFamily) then
                    FonStartFamily(self, lFamRef, '', 0);
                if Assigned(FonFamilyType) then
                    FonFamilyType(self, lFamCEntry, lFamRef, lFamType);
                if Assigned(FonFamilyIndiv) then
                    if lPersonSex = 'M' then
                        FonFamilyIndiv(self, lIndID, lFamRef, 1)
                    else
                        FonFamilyIndiv(self, lIndID, lFamRef, 2);
                Inc(Offset, lFamType+1);
                lRetMode := 125;
                lMode := 101;
              end;
            125:
              begin
                if (copy(aText, Offset, length('mit')) = 'mit') then
                  begin
                    lMode := 126;
                    lFirstEntry := True;
                    if lPersonSex = 'M' then
                        lPersonType2 := 'F'
                    else
                        lPersonType2 := 'M';
                    Inc(Offset, 3);
                  end
                else if atext[Offset]<>' ' then
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
                    if Assigned(FonIndiName) then
                        FonIndiName(self, trim(lSubString), lIndID2, 1);
                    if Assigned(FonFamilyIndiv) then
                        if lPersonType2 = 'M' then
                            FonFamilyIndiv(self, lIndID2, lFamRef, 1)
                        else
                            FonFamilyIndiv(self, lIndID2, lFamRef, 2);

                    lLastName := trim(lSubString);
                    lFirstEntry := False;
                    lEntrytype := evt_Last;
                    lSubString := '';
                    if (atext[Offset] = '(') and ParseAdditional(aText,
                        Offset, lAdditional) then
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID, 3); //AKA
                      end;
                  end
                else
                  begin
                    if Assigned(FonIndiName) then
                        FonIndiName(self, trim(lSubString), lIndID2, 2);
                    if Assigned(FonIndiData) then
                        if lPersonType2 in ['M', 'F'] then
                            FonIndiData(self, lPersonType2, lIndID2, Ord(evt_Sex));
                    if not (lPersonType2 in ['M', 'F']) then
                      begin
                        lPersonSex2 := GuessSexOfGivnName(trim(lSubString));
                        if Assigned(FonIndiData) then
                            if Assigned(FonIndiData) and (lPersonSex2 in ['M', 'F']) then
                                FonIndiData(self, lPersonSex2, lIndID2, Ord(evt_Sex));
                      end
                    else
                        LearnSexOfGivnName(trim(lSubString), lPersonType2);
                    lSubString := '';
                    if (atext[Offset] = '(') and ParseAdditional(aText,
                        Offset, lAdditional) then
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID, 3); //AKA
                      end;
                    lMode := lRetMode3;
                    Dec(Offset);
                    if (lmode <150) and  (aText[Offset] in ['<', '[']) then
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
                        if assigned(FonIndiRel) then
                            FonIndiRel(self, trim(lSubString), lIndID, lRefMode2);
                    lSubString := '';
                  end
                else
                if aText[Offset] in [#10, #13, '*', '~'] then
                  begin  // Defekter Eintrag
                    lMode := lRetMode2;
                    Error(self,FMainref + ': Unclosed Reference');
                    if (lSubString <> '') and (lSubString[1] in Ziffern) then
                        if assigned(FonIndiRel) then
                            FonIndiRel(self, trim(lSubString), lIndID, lRefMode2);
                    Dec(Offset);
                    lSubString := '';
                  end
                else if (aText[Offset] = '<') then
                    lRefMode2 := 1
                else if (aText[Offset] = '[') then
                    lRefMode2 := 2
                else if (lRefMode2 =2) and (lSubString='') and
                  testfor(atext,Offset,csMarriageEntr2) then
                  begin
                    lRetMode3 := lMode;
                    lmode := 124;
                    dec(Offset);
                  end
                else if (aText[Offset] in Charset) or
                   testfor(atext, Offset, csDeathEntr) then
                  begin
                    lSubString := atext[Offset];
                    lParentRef := copy(lIndID, 2, 20);
                    if Assigned(FonStartFamily) then
                        FonStartFamily(self, lParentRef, '', 0);
                    if Assigned(FonFamilyIndiv) then
                        FonFamilyIndiv(self, lIndID, lParentRef, 3);
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
                        if assigned(FonIndiRel) then
                            FonIndiRel(self, trim(lSubString), lIndID, lRefMode2);
                        lSubString := '';
                      end;
                  end;
              end;
            155, 156:
              begin
                if not (aText[Offset] in [' ', ',','<', '>', ']', '(']) or
                    ((aText[Offset] = ' ') and
                    ((copy(aText, Offset, 5) <> ' und ') and
                    (lSubString <> ''))) then
                    lSubString := lSubString + aText[Offset]
                else if aText[Offset] ='<' then
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
                        if Assigned(FonIndiName) then
                            FonIndiName(self,
                                copy(trim(lSubString), length(csDeathEntr) + 1, 200),
                                lIndID2, 1);
                        if Assigned(FonIndiDate) then
                            FonIndiDate(self, 'vor ' + lEventDate,
                                lIndID2, Ord(evt_Death));
                      end
                    else
                    if Assigned(FonIndiName) then
                        FonIndiName(self, trim(lSubString), lIndID2, 1);
                    if Assigned(FonFamilyIndiv) then
                        FonFamilyIndiv(self, lIndID2, lParentRef, lMode - 154);
                    lSubString := '';
                    if (atext[Offset] = '(') and ParseAdditional(aText,
                        Offset, lAdditional) then
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID2, 3); //AKA
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
                        if Assigned(FonIndiName) then
                            FonIndiName(self, 'NN', lIndID2, 2);
                        if Assigned(FonIndiData) then
                            FonIndiData(self, lPersonGName, lIndID2, Ord(evt_Religion));
                        lSecondEntry := False;
                      end
                    else
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lPersonGName, lIndID2, 2);
                        if Assigned(FonIndiData) then
                            if lmode = 156 then
                                FonIndiData(self, 'F', lIndID2, 6)
                            else
                              begin
                                lPersonSex2 := GuessSexOfGivnName(lPersonGName);
                                FonIndiData(self, lPersonSex2, lIndID2, 6);
                              end;

                      end;
                    lSubString := '';
                    if (atext[Offset] = '(') and ParseAdditional(aText,
                        Offset, lAdditional) then
                      begin
                        if Assigned(FonIndiName) then
                            FonIndiName(self, lAdditional, lIndID2, 3); //AKA
                      end;
                    lSecondEntry := False;
                  end
                else if (aText[Offset] = ',') and (trim(lSubstring) = 'Bürger') then
                  begin
                    lSubstring := lSubString + ',';
                  end
                else if HandleGCNonPersonEntry(lSubString,atext[Offset],lIndID2) then
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
            else
                Lmode := 0
          end;
        Fmode := lMode;
        Inc(Offset);
        {$IFDEF DEBUG}
        lDebug := copy(atext, Offset, 20);
        {$ENDIF}
      end;
end;

procedure TFBEntryParser.Error(sender: TObject; NewMessage: string);
begin
    FLastErr := NewMessage;
    if assigned(FonParseError) then
        FonParseError(self);
end;

procedure TFBEntryParser.Parse(Data: string);
begin
  Feed(Data)
end;

procedure TFBEntryParser.LearnSexOfGivnName(aName: string; aSex: char);
var
    lName: string;
begin
    for lName in aName.split([' ']) do
        if (length(lName) = 2) and lname.EndsWith('.') and (lName[1] in ['A'..'Z']) then
            Continue // Ignoriere abgekürzte Namen
        else
        if ((length(lName) < 3) and (uppercase(lName) <> 'NN')) or
            lname.EndsWith('.') or lname.EndsWith('=') then
          begin
            Error(self,FMainref + ': "' + lName + '" is not a valid Name');
          end
        else
        if (lName <> '') and (copy(lName, 1, 1) <> '(') and
            (copy(lName, 1, 1) <> '"') and
            ((FGNameList.Values[lName] = '') or
            (FGNameList.Values[lName] = '_')) then
          begin
            FGNameList.Sorted := False;
            FGNameList.Values[lName] := aSex;
            FGNameList.Sorted := True;
            FGNameListChanged := True;
          end
        else
        if (copy(lName, 1, 1) <> '(') then
            break;

end;

function TFBEntryParser.GuessSexOfGivnName(aName: string): char;
var
    lName: string;
begin
    Result := 'U';
    for lName in aName.split([' ']) do
      begin
        if (length(lName) = 2) and lname.EndsWith('.') and (lName[1] in ['A'..'Z']) then
            Continue  // Ignoriere abgekürzte Namen
        else
        if ((length(lName) < 3) and (uppercase(lName) <> 'NN')) or
            lname.EndsWith('.') or lname.EndsWith('=') then
          begin
            Error(self,FMainref + ': "' + lName + '" is not a valid Name');
          end
        else
        if (copy(lName, 1, 1) <> '(') and (copy(lName, 1, 1) <> '"') and
            (FGNameList.Values[lName] <> '') and
            (FGNameList.Values[lName] <> '_') then
            exit(FGNameList.Values[lName][1])
        else
        if cfgLearnUnknown then
            LearnSexOfGivnName(lName, '_');
      end;
end;

end.
