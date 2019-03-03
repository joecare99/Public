unit GBaseClasses;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Classes, SysUtils;

type
    TenumAccuracy = (Unknown = -1,
        Accurate_Date = 0, Accurate_MonthYear = 4, Accurate_Year =
        8, Accurate_Decade = 12,
        About_Date = 1, About_MonthYear = 5, About_Year = 9, About_Decade = 13,
        Est_Date = 2, Est_MonthYear = 6, Est_Year = 10, Est_Decade = 14,
        Calc_Date = 3, Calc_MonthYear = 7, Calc_Year = 11, Calc_Decade = 15);
    /// <author>C. Rosewich</author>
    /// <info>TDateSpan beschreibt wie der eigentliche Zeitpunkt zur Datumsangabe steht.</info>
    TenumDateSpan = (
        /// <info>Einfache Datumsangabe</info>
        ds_SingleDate = 0,
        /// <info>Zeipunkt liegt vor Datumsangabe</info>
        ds_BeforeDate = 1,
        /// <info>Zeipunkt liegt nach Datumsangabe</info>
        ds_AfterDate = 2,
        /// <info>Zeitpunkt ist entweder das eine oder das andere Datum</info>
        ds_AlterNate = 3,
        /// <info>Zeipunkt liegt zwischen Datumsangaben</info>
        ds_Between = 4,
        /// <info>Beschreibt Dauer von bis</info>
        ds_Duration = 5);

const
    AccuracyStr: array[TenumAccuracy] of string =
        ('Unknown',
        'Accurate_Date',
        'About_Date',
        'Estimated_Date',
        'Calc_Date',
        'Accurate_MonthYear',
        'About_MonthYear',
        'Estimated_MonthYear',
        'Calc_MonthYear',
        'Accurate_Year',
        'About_Year',
        'Estimated_Year',
        'Calc_Year',
        'Accurate_Decade',
        'About_Decade',
        'Estimated_Decade',
        'Calc_Decade');

    DateSpannStr: array[TenumDateSpan] of string =
        ('SingleDate',
        /// <info>Zeipunkt liegt vor Datumsangabe</info>
        'BeforeDate',
        /// <info>Zeipunkt liegt nach Datumsangabe</info>
        'AfterDate',
        /// <info>Zeitpunkt ist entweder das eine oder das andere Datum</info>
        'AlterNate',
        /// <info>Zeipunkt liegt zwischen Datumsangaben</info>
        'Between',
        /// <info>Beschreibt Dauer von bis</info>
        'Duration');

{ TGDate }
type
    /// <Info>Basisclasse für Genealogiedaten</info>
    TGedObject = class(TObject)
    protected
        procedure SetValue(NewVal: string); virtual; abstract;
    public
        property Value: ansistring read ToString write SetValue;
    end;

    TGedObjectExt = class(TGedObject)
    protected
        function GetItems: TList; virtual; abstract;
    public
        property Items: TList read GetItems;
    end;


    TGDate = class(TGedObject)
    private
        Fdate1, FDate2: TDateTime;
        FOnChange: TNotifyEvent;
        FString: string;
        FDateAccuracy: TenumAccuracy;
        FDateSpan: TenumDateSpan;
        FParseOK: boolean;
        FChanged: boolean;
        function GetParseOK: boolean;
        function GetDisplayText: string;
        procedure SetDateAccuracy(AValue: TenumAccuracy);
        procedure SetDateSpan(AValue: TenumDateSpan);
        procedure SetDisplayText(val: string);
        procedure SetOnChange(AValue: TNotifyEvent);
    public
        constructor Create; overload;
        constructor Create(ADateAccuracy: TenumAccuracy; ADateSpan: TenumDateSpan;
            ADate1, ADate2: TDateTime); overload;
        property ParseOK: boolean read GetParseOK;
        property DisplayText: string read GetDisplayText write SetDisplayText;
        property DateAccuracy: TenumAccuracy read FDateAccuracy write SetDateAccuracy;
        property DateSpan: TenumDateSpan read FDateSpan write SetDateSpan;
        property MainDate: TDatetime read FDate1;
        property Changed: boolean read FChanged;
        property OnChange: TNotifyEvent read FOnChange write SetOnChange;
        function CalcDateDif: integer;
        function ToString: ansistring; override;
        procedure ResetChanged;
    protected
        procedure SetValue(NewVal: string); override;
    end;

    { TBasePlace }

    TBasePlace = class(TGedObjectExt)
    private
        FString: string;
        function GetDisplayText: string;
        procedure SetDisplayText(AValue: string);
    public
        property DisplayText: string read GetDisplayText write SetDisplayText;
    end;

// Todo: in eine Config-Struktur verpacken
var
    CAbout: string = 'um';
    CEst: string = 'Ges.';
    CCalc: string = 'Ber.';
    CBetween: string = 'Zw.';
    CAnd: string = 'u.';
    CFrom: string = 'von';
    CUntil: string = 'bis';
    CAfter: string = 'nach';
    CBefore: string = 'vor';
    CAboutStr: array of string;
    CEstStr: array of string;
    CCalcStr: array of string;
    CBeforeStr: array of string;
    CAfterStr: array of string;
    CBetwStStr: array of string;
    CBetwEndStr: array of string;
    CDurStStr: array of string;
    CDurEndStr: array of string;

implementation

uses dateutils;

const
    aboutstr: array[0..7] of string =
        ('ca.',
        'c',
        'circa',
        'ungefähr',
        'abt.',
        'a',
        'about',
        'um');

    Eststr: array[0..3] of string =
        ('ges.',
        'est.',
        'e',
        'g');

    Calcstr: array[0..4] of string =
        ('cal.',
        'calc',
        'ber.',
        'berechnet',
        'b');

    BeforeStr: array[0..4] of string =
        ('vor',
        'v',
        'bf',
        'bef',
        'before');

    AfterStr: array[0..5] of string =
        ('nach',
        'nch',
        'n',
        'af',
        'aft',
        'after');

    BetwStString: array[0..5] of string =
        ('zwsch.',
        'zw.',
        'z',
        'bt',
        'btw',
        'betw');

    BetwEndString: array[0..3] of string =
        ('und',
        'u',
        'a',
        'and');

    DurStString: array[0..5] of string =
        ('von',
        'vn',
        'v',
        'f',
        'frm',
        'from');

    DurEndString: array[0..3] of string =
        ('bis',
        '-',
        'tl',
        'till');


function tee(i: integer; out o: integer): integer; inline;
begin
    Result := i;
    o := Result;
end;

{ TPlace }

function TBasePlace.GetDisplayText: string;
begin
    Result := FString;
end;

procedure TBasePlace.SetDisplayText(AValue: string);
begin
    FString := AValue;
end;

{ TGDate }
function TGDate.GetDisplayText: string;

var
    SecondDate: string;
begin
    if not FParseOK then
        Result := FString
    else if (FDateAccuracy in [Accurate_Date, About_Date, Est_Date, Calc_Date]) then
      begin
        Result := FormatDateTime('D. MMM YYYY', Fdate1);
        SecondDate := FormatDateTime('D. MMM YYYY', Fdate2);
      end
    else if (FDateAccuracy in [Accurate_MonthYear, About_MonthYear,
        Est_MonthYear, Calc_MonthYear]) and (FDateSpan in
        [ds_SingleDate, ds_AfterDate, ds_BeforeDate]) then
      begin
        Result := FormatDateTime('MMM YYYY', Fdate1);
        SecondDate := FormatDateTime('MMM YYYY', Fdate2);
      end
    else if (FDateAccuracy in [Accurate_Year, About_Year, Est_Year, Calc_Year]) and
        (FDateSpan in [ds_SingleDate, ds_AfterDate, ds_BeforeDate]) then
      begin
        Result := FormatDateTime('YYYY', Fdate1);
        SecondDate := FormatDateTime('YYYY', Fdate2);
      end;
    if (FDateAccuracy in [About_Date, About_MonthYear, About_Year]) and
        (FDateSpan = ds_SingleDate) then
        Result := CAbout + ' ' + Result
    else if (FDateAccuracy in [Est_Date, Est_MonthYear, Est_Year]) and
        (FDateSpan = ds_SingleDate) then
        Result := CEst + ' ' + Result
    else if (FDateAccuracy in [Calc_Date, Calc_MonthYear, Calc_Year]) and
        (FDateSpan = ds_SingleDate) then
        Result := CCalc + ' ' + Result;
    if (FDateSpan = ds_BeforeDate) then
        Result := CBefore + ' ' + Result
    else if (FDateSpan = ds_AfterDate) then
        Result := CAfter + ' ' + Result
    else if (FDateSpan = ds_Between) then
        Result := CBetween + ' ' + Result + ' ' + CAnd + ' ' + SecondDate
    else if (FDateSpan = ds_Duration) then
        Result := CFrom + ' ' + Result + ' ' + CUntil + ' ' + SecondDate;
end;

procedure TGDate.SetDateAccuracy(AValue: TenumAccuracy);
begin
    if FDateAccuracy = AValue then
        Exit;
    FDateAccuracy := AValue;
    FChanged := True;
    if assigned(FOnChange) then
        FOnChange(self);
end;

procedure TGDate.SetDateSpan(AValue: TenumDateSpan);
begin
    if FDateSpan = AValue then
        Exit;
    FDateSpan := AValue;
    FChanged := True;
    if assigned(FOnChange) then
        FOnChange(self);
end;

procedure TGDate.SetDisplayText(val: string);
var
    lDate: TDateTime;
    lDateString: string;
    p: integer;
    flag: boolean;
    lAboutFlg, lCalcFlg: boolean;

    function tryMonthYear(val: string; out aDate: TDateTime): boolean;
    var
        Year, Month: longint;
        Day: integer;
        pp: SizeInt;
    begin
        Result := False;
        val := trim(val);
        Day := 1;
        pp := pos(FormatSettings.DateSeparator, val);
        Result := (Pp <> 0) and trystrtoint(copy(val, pp + 1, length(val) - pp),
            Year) and trystrtoint(copy(val, 1, pp - 1), Month);
        if Result then
            aDate := EncodeDate(year, month, day)
        else
            adate := EncodeDate(1, 1, 1);
    end;

    function TryStrToYearOnly(val: string; out aDate: TDateTime): boolean;
    var
        Year, Month: longint;
        Day: integer;
        pp: SizeInt;
    begin
        Result := False;
        val := trim(val);
        Day := 1;
        Month := 1;
        pp := pos(FormatSettings.DateSeparator, val);
        Result := (Pp = 0) and trystrtoint(val, Year);
        if Result then
            aDate := EncodeDate(year, month, day)
        else
            adate := EncodeDate(1, 1, 1);
    end;

    function ParseDatePrefix(var lDateString: string;
    const CSearchStrs: array of string): boolean;
    var
        i: integer;
    begin
        Result := False;
        for i := 0 to high(CSearchStrs) do
            if (copy(lDateString, 1, length(CSearchStrs[i])) =
                UpperCase(CSearchStrs[i])) and charinset(
                copy(lDateString, length(CSearchStrs[i]) + 1, 1)[1],
                ['0'..'9', '.', ' ']) then
              begin
                Result := True;
                Delete(lDateString, 1, length(CSearchStrs[i]));
                while (length(lDateString) > 1) and
                    charinset(lDateString[1], ['.', ' ']) do
                    Delete(lDateString, 1, 1);
                Break;
              end;
    end;

var
    i: integer;
    lBeforeflg, lAfterflg, lEstimateflg: boolean;
begin
    if FString = Val then
        Exit;
    FString := Val;
    FParseOK := False;
    lDateString := uppercase(FString);
    lAboutflg := ParseDatePrefix(lDateString, CAboutStr);
    lEstimateflg := ParseDatePrefix(lDateString, CEstStr);
    lCalcflg := ParseDatePrefix(lDateString, CCalcStr);
    lBeforeflg := ParseDatePrefix(lDateString, CBeforeStr);
    lAfterflg := ParseDatePrefix(lDateString, CAfterStr);
    if TryStrToDate(lDateString, lDate) and ((length(trim(lDateString)) > 7) or
        (rightstr(lDateString, 1) = FormatSettings.DateSeparator)) then
      begin
        if lCalcFlg then
            FDateAccuracy := Calc_Date
        else if lEstimateflg then
            FDateAccuracy := Est_Date
        else if not lAboutFlg then
            FDateAccuracy := Accurate_Date
        else
            FDateAccuracy := About_Date;
        if lAfterflg then
            FDatespan := ds_AfterDate
        else if lBeforeflg then
            FDatespan := ds_BeforeDate
        else
            FDatespan := ds_SingleDate;
        Fdate1 := lDate;
        FParseOK := True;
      end
    else
      begin
        flag := False;
        for i := 1 to 12 do
            if tee(pos(uppercase(FormatSettings.ShortMonthNames[i]),
                uppercase(lDateString)), p) <> 0 then
              begin
                Inc(p, length(FormatSettings.ShortMonthNames[i]));
                while charinset(upcase(lDateString[p]),
                        ['A'..'Z', FormatSettings.DateSeparator, ' ', #9]) do
                    Delete(lDateString, p, 1);
                lDateString :=
                    StringReplace(lDateString, FormatSettings.ShortMonthNames[i],
                    RightStr('0' + IntToStr(i), 2) + FormatSettings.DateSeparator,
                    [rfIgnoreCase]);
                flag := True;
                break;
              end;
        if not flag then
            for i := 1 to 12 do
                if tee(pos(uppercase(FormatSettings.LongMonthNames[i]),
                    uppercase(lDateString)), p) <> 0 then
                  begin
                    Inc(p, length(FormatSettings.LongMonthNames[i]));
                    while charinset(upcase(lDateString[p]),
                            ['A'..'Z', FormatSettings.DateSeparator, ' ', #9]) do
                        Delete(lDateString, p, 1);
                    lDateString :=
                        StringReplace(lDateString, FormatSettings.LongMonthNames[i],
                        RightStr('0' + IntToStr(i), 2) +
                        FormatSettings.DateSeparator, [rfIgnoreCase]);
                    flag := True;
                    break;
                  end;
        if TryStrToDate(lDateString, lDate) and
            ((length(trim(lDateString)) > 7) or
            (rightstr(lDateString, 1) = FormatSettings.DateSeparator)) then
          begin
            if lCalcFlg then
                FDateAccuracy := Calc_Date
            else if lEstimateflg then
                FDateAccuracy := Est_Date
            else if not lAboutFlg then
                FDateAccuracy := Accurate_Date
            else
                FDateAccuracy := About_Date;
            if lAfterflg then
                FDatespan := ds_AfterDate
            else if lBeforeflg then
                FDatespan := ds_BeforeDate
            else
                FDatespan := ds_SingleDate;
            Fdate1 := lDate;
            FParseOK := True;
          end
        else if tryMonthYear(lDateString, lDate) then
          begin
            if lCalcFlg then
                FDateAccuracy := Calc_MonthYear
            else if lEstimateflg then
                FDateAccuracy := Est_MonthYear
            else if not lAboutFlg then
                FDateAccuracy := Accurate_MonthYear
            else
                FDateAccuracy := About_MonthYear;
            if lAfterflg then
                FDatespan := ds_AfterDate
            else if lBeforeflg then
                FDatespan := ds_BeforeDate
            else
                FDatespan := ds_SingleDate;
            Fdate1 := lDate;
            FParseOK := True;
          end
        else if TryStrToYearOnly(lDateString, lDate) then
          begin
            if lCalcFlg then
                FDateAccuracy := Calc_Year
            else if lEstimateflg then
                FDateAccuracy := Est_Year
            else if not lAboutFlg then
                FDateAccuracy := Accurate_Year
            else
                FDateAccuracy := About_Year;
            if lAfterflg then
                FDatespan := ds_AfterDate
            else if lBeforeflg then
                FDatespan := ds_BeforeDate
            else
                FDatespan := ds_SingleDate;
            Fdate1 := lDate;
            FParseOK := True;
          end;
      end;
    if parseok then
        FString := GetDisplayText;
    FChanged := True;
    if assigned(FOnChange) then
        FOnChange(self);
end;

procedure TGDate.SetOnChange(AValue: TNotifyEvent);
begin
    if @FOnChange = @AValue then
        Exit;
    FOnChange := AValue;
end;

constructor TGDate.Create;
begin
    FParseOK := False;
    Fdate1 := -693594.0;
    FDate2 := -693594.0;
    FDateSpan := ds_SingleDate;
    FDateAccuracy := Unknown;
    FChanged := False;

end;

constructor TGDate.Create(ADateAccuracy: TenumAccuracy; ADateSpan: TenumDateSpan;
    ADate1, ADate2: TDateTime);
begin
    FParseOK := ADateAccuracy <> Unknown;
    Fdate1 := ADate1;
    FDate2 := ADate2;
    FDateSpan := ADateSpan;
    FDateAccuracy := Unknown;
    FChanged := False;
end;

function TGDate.CalcDateDif: integer;
begin
end;

function TGDate.ToString: ansistring;
begin
    Result := '<' + ClassName + '>' + FString;
end;

procedure TGDate.ResetChanged;
begin
    FChanged := False;
    if assigned(FOnChange) then
        FOnChange(self);
end;

procedure TGDate.SetValue(NewVal: string);
begin

end;

function TGDate.GetParseOK: boolean;
begin
    Result := FParseOK;
end;

var
    i: integer;

initialization
    //  FormatSettings := FormatSettings;
    setlength(CAboutStr, high(aboutstr) + 1);
    for i := 0 to high(aboutstr) do
        CAboutStr[i] := aboutstr[i];
    setlength(CEstStr, high(Eststr) + 1);
    for i := 0 to high(Eststr) do
        CEstStr[i] := Eststr[i];
    setlength(CCalcStr, high(Calcstr) + 1);
    for i := 0 to high(Calcstr) do
        CCalcStr[i] := Calcstr[i];
    setlength(CBeforeStr, high(BeforeStr) + 1);
    for i := 0 to high(BeforeStr) do
        CBeforeStr[i] := BeforeStr[i];
    setlength(CAfterStr, high(AfterStr) + 1);
    for i := 0 to high(AfterStr) do
        CAfterStr[i] := AfterStr[i];
    setlength(CBetwStStr, high(BetwStString) + 1);
    for i := 0 to high(BetwStString) do
        CBetwStStr[i] := BetwStString[i];
    setlength(CBetwEndStr, high(BetwEndString) + 1);
    for i := 0 to high(BetwEndString) do
        CBetwEndStr[i] := BetwEndString[i];
    setlength(CDurStStr, high(DurStString) + 1);
    for i := 0 to high(DurStString) do
        CDurStStr[i] := DurStString[i];
    setlength(CDurEndStr, high(DurEndString) + 1);
    for i := 0 to high(DurEndString) do
        CDurEndStr[i] := DurEndString[i];

end.
