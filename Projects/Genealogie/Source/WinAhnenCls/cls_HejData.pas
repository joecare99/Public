unit cls_HejData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, variants, DB, Unt_IData, cls_HejBase, cls_HejIndData,
    cls_HejMarrData, cls_HejAdopData,
    cls_HejPlaceData, cls_HejSourceData;

type
    TEnumHejIndRedir =
        (hIRd_Meta = -1,   // e.G. Counts, Timeline-Data
        hIRd_Ind = 0,   // Individual Data
        hIRd_Spouse = 1,  // Data of Main(Last) Spouse
        hIRd_AnySpouse = 2,  // Data of any Spouse
        hIRd_AllSpouse = 3,  // Data of all Spousees
        hIRd_Father = 4,  // Data of Father
        hIRd_Mother = 5,  // Data of Mother
        hIRd_AnyParent = 6,  // Data of any Parent
        hIRd_AllParent = 7,  // Data of all Parents
        hIRd_Child = 8,     // Data of Child
        hIRd_AnyChild = 9,  // Data of any Child
        hIRd_AllChild = 10); // Data of all Childs

    TenumIndMetaData =
        (hInMeD_ParentCount = 0,
        hInMeD_SpouseCount = 1,
        hInMeD_ChildCount = 2,
        hInMeD_SiblingCount = 3,
        hInMeD_SourceCount = 4,
        hInMeD_PlaceCount = 5,
        hInMeD_AdoptCount = 6,
        hInMeD_AnyPlace = 7,
        hInMeD_AnySource = 8,
        hInMeD_AnyData = 9,
        hInMeD_AgeOfBapt = 10,
        hInMeD_AgeOfNextSibl = 11,
        hInMeD_AgeOfConf = 12,
        hInMeD_AgeOfFMarriage = 13,
        hInMeD_AgeOfFirstChild = 14,
        hInMeD_AgeOfLMarriage = 15,
        hInMeD_AgeOfLChild = 16,
        hInMeD_AgeOfDeath = 17,
        hInMeD_AgeDiffToSpouse = 18);

    { TClsHejGenealogy }

    TClsHejGenealogy = class(TClsHejBase, IData)
    private
        FIndi: TClsHejIndividuals;
        FMarr: TClsHejMarriages;
        FAdop: TClsHejAdoptions;
        FOnDataChange: TNotifyEvent;
        FOnStateChange: TNotifyEvent;
        FOnUpdate: TNotifyEvent;
        FPlac: TClsHejPlaces;
        FSour: TClsHejSources;
        function GetActualInd: THejIndData;
        function GetActualMarriage: THejMarrData;
        function GetChild(idx: integer): THejIndData;
        function GetChildCount: integer;
        function GetFather: THejIndData;
        function GetIndividual(index: integer): THejIndData;
        function GetIndividualCount: integer;
        function GetMarriageData(idx: integer): THejMarrData;
        function GetMarriage(idMarr: integer): THejMarrData;
        function GetMarriagesCount: integer;
        function GetMother: THejIndData;
        function GetPlaceCount: integer;
        function GetSourceCount: integer;
        function GetSpouse(idx: integer): THejIndData;
        function GetSpouseCount: integer;
        procedure SetActualInd(AValue: THejIndData);
        procedure SetActualMarriage(AValue: THejMarrData);
        procedure SetData(index: integer; Field: TEnumHejIndDatafields;
            AValue: variant); overload;
        procedure SetData(ind, index: integer; Field: TEnumHejMarrDatafields;
            AValue: variant); overload;
        procedure SetMarriage(idMarr: integer; AValue: THejMarrData); overload;
        procedure SetMarriageData(idx: integer; AValue: THejMarrData);
        procedure SetOnDataChange(AValue: TNotifyEvent);
        procedure SetOnStateChange(AValue: TNotifyEvent);
        procedure SetOnUpdate(AValue: TNotifyEvent);
    protected
        function GetCount: integer; override;
    public
        function TestStreamHeader(st: Tstream): boolean; override;
        function IndexOf(Krit: variant): integer; override;
        function GetData(index: integer; Field: TEnumHejIndDatafields): variant; overload;
        function GetData(ind, index: integer; Field: TEnumHejMarrDatafields): variant;
            overload;
        function GetData(index: integer; Redir: TEnumHejIndRedir;
            Field: integer): variant; overload;
        Procedure SetDate(index: integer; Field: TEnumHejIndDatafields;aValue:String);
        function PeekInd(index: integer): THejIndData;
        property Individual[index: integer]: THejIndData read GetIndividual;
        property ActualInd: THejIndData read GetActualInd write SetActualInd;
        property ActualMarriage: THejMarrData read GetActualMarriage write SetActualMarriage;
        property Father: THejIndData read GetFather;
        property Mother: THejIndData read GetMother;
        property iData[index: integer;Field: TEnumHejIndDatafields]: variant
            read GetData write SetData;
        property mData[ind, index: integer;Field: TEnumHejMarrDatafields]: variant
            read GetData write SetData;
        property Spouse[idx: integer]: THejIndData read GetSpouse;
        property MarriageData[idx: integer]: THejMarrData
            read GetMarriageData write SetMarriageData;
        property SpouseCount: integer read GetSpouseCount;
        property PlaceCount: integer read GetPlaceCount;
        property SourceCount: integer read GetSourceCount;
        property Child[idx: integer]: THejIndData read GetChild;
        property ChildCount: integer read GetChildCount;
        property IndividualCount: integer read GetIndividualCount;
        property MarriagesCount: integer read GetMarriagesCount;
        property Marriages:TClsHejMarriages read FMarr;
        property Marriage[idMarr: integer]: THejMarrData read GetMarriage write SetMarriage;
        property OnStateChange: TNotifyEvent read FOnStateChange write SetOnStateChange;
        property OnDataChange: TNotifyEvent read FOnDataChange write SetOnDataChange;
        property OnUpdate: TNotifyEvent read FOnUpdate write SetOnUpdate;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Clear; override;
        procedure ReadfromStream(st: Tstream;{%H-}cls: TClsHejBase = nil); override;
        procedure LoadFromFile(Filename: string);
        procedure WriteToStream(st: TStream); override;
        procedure First(Sender: TObject = nil);
        procedure Last(Sender: TObject = nil);
        procedure Next(Sender: TObject = nil);
        procedure Previous(Sender: TObject = nil);
        procedure Append(Sender: TObject = nil);
        procedure AppendLinkChild(idInd, idChild: integer);
        procedure AppendSpouse(Sender: TObject = nil);
        procedure AppendParent(Knd: TEnumHejIndDatafields; Sender: TObject = nil);
        procedure AppendAdoption(idAdopter: integer);
        Procedure MergePerson(lFirst,lSecond:integer);
        procedure SetMarriage(idInd, idSpouse: integer); overload;
        procedure SetPlace(aPlace: THejPlaceData);
        procedure SetSource(aSource: THejSourData);
        procedure Edit(Sender: TObject = nil);
        procedure Post(Sender: TObject = nil);
        procedure Seek(NewID: integer);
        procedure GotoChild(IDCh: integer = 1);
        procedure GotoParent(Knd: TEnumHejIndDatafields);
        procedure GotoSpouse(IDSp: integer = 1);
        procedure Cancel(Sender: TObject = nil);
        procedure Delete(Sender: TObject = nil);
        function EOF: boolean;
        function BOF: boolean;
        function GetData: variant;
        procedure SetData(NewVal: variant); overload;
        function GetActID: integer;
        function GetOnUpdate: TNotifyEvent;

    end;

const
    CindRedir: array[TEnumHejIndRedir] of string = (
        'hIRd_Meta',   // e.G. Counts, Timeline-Data
        'hIRd_Ind',   // Individual Data
        'hIRd_Spouse',  // Data of Main(Last) Spouse
        'hIRd_AnySpouse',  // Data of any Spouse
        'hIRd_AllSpouse',  // Data of all Spousees
        'hIRd_Father',  // Data of Father
        'hIRd_Mother',  // Data of Mother
        'hIRd_AnyParent',  // Data of any Parent
        'hIRd_AllParent',  // Data of all Parents
        'hIRd_Child',     // Data of Child
        'hIRd_AnyChild',  // Data of any Child
        'hIRd_AllChild'); // Data of all Childs

resourcestring
    rsGeburt = 'Geburt';
    rshIRd_Meta = 'Metadaten';   // e.G. Counts, Timeline-Data
    rshIRd_Ind = 'Person';   // Individual Data
    rshIRd_Spouse = 'Ehepartner';  // Data of Main(Last) Spouse
    rshIRd_AnySpouse = 'ein Ehepartner';  // Data of any Spouse
    rshIRd_AllSpouse = 'alle Ehepartner';  // Data of all Spousees
    rshIRd_Father = 'Vater';  // Data of Father
    rshIRd_Mother = 'Mutter';  // Data of Mother
    rshIRd_AnyParent = 'ein Elternteil';  // Data of any Parent
    rshIRd_AllParent = 'Eltern';  // Data of all Parents
    rshIRd_Child = 'Kind';     // Data of Child
    rshIRd_AnyChild = 'ein Kind';  // Data of any Child
    rshIRd_AllChild = 'alle Kinder'; // Data of all Childs

var
    rshIRd: array[TEnumHejIndRedir] of string;

implementation

uses dateutils, LConvEncoding, dm_GenData2;

{ TClsHejGenealogy }

function TClsHejGenealogy.GetActualInd: THejIndData;
begin
    Result := FIndi.ActualInd;
end;

function TClsHejGenealogy.GetActualMarriage: THejMarrData;
begin
    Result := Fmarr.ActualMarr;
end;

function TClsHejGenealogy.GetChild(idx: integer): THejIndData;
begin
    Result := Findi.PeekInd[FIndi.ActualChild[idx]];
end;

function TClsHejGenealogy.GetChildCount: integer;
begin
    Result := FIndi.ActualChildCount;
end;

function TClsHejGenealogy.GetData(index: integer;
    Field: TEnumHejIndDatafields): variant;
begin
    Result := Findi.Data[index, Field];
end;

function TClsHejGenealogy.GetData(ind, index: integer;
    Field: TEnumHejMarrDatafields): variant;
begin
    if ind = -1 then
        ind := GetActID;
    if index < length(Findi.PeekInd[ind].Marriages) then
        Result := FMarr.Data[Findi.PeekInd[ind].Marriages[index], Field]
    else
        Result := null;
end;

function TClsHejGenealogy.GetData(index: integer; Redir: TEnumHejIndRedir;
    Field: integer): variant;

var
    lInd_Pr: THejIndData;
    lInd: array of THejIndData;
    lIdf: TEnumHejIndDatafields;
    lMdf: TEnumHejMarrDatafields;
    i, lResCnt: integer;
    lBirth, lSecond, laDate: TDateTime;

begin

    setlength(lind, 1);
    lInd_Pr := FIndi.PeekInd[index];
    case Redir of
        hIRd_Meta: lInd[0] := lInd_Pr;
        hIRd_Ind: lInd[0] := lInd_Pr;
        hIRd_Spouse: if length(lInd_Pr.Marriages) > 0 then
                lInd[0] := PeekInd(Fmarr.Marriage[lInd_Pr.Marriages[0]].idSpouse)
            else
                SetLength(lInd, 0);
        hIRd_AnySpouse:
          begin
            setlength(lind, lInd_Pr.SpouseCount);
            for i := 0 to lInd_Pr.SpouseCount - 1 do
                lInd[i] := peekind(fmarr.Data[lInd_Pr.Marriages[i], hmar_idSpouse]);
          end;
        hIRd_AllSpouse:
          begin
            setlength(lind, lInd_Pr.SpouseCount);
            for i := 0 to lInd_Pr.SpouseCount - 1 do
                lInd[i] := peekind(fmarr.Data[lInd_Pr.Marriages[i], hmar_idSpouse]);
          end;
        hIRd_Father: if lInd_Pr.idFather > 0 then
                lInd[0] := FIndi.PeekInd[lInd_Pr.idFather]
            else
                setlength(lind, 0);
        hIRd_Mother: if lInd_Pr.idMother > 0 then
                lInd[0] := FIndi.PeekInd[lInd_Pr.idMother]
            else
                setlength(lind, 0);
        hIRd_AnyParent:
          begin
            setlength(lind, lInd_Pr.ParentCount);
            i := 0;
            if lInd_Pr.idFather > 0 then
              begin
                lInd[i] := PeekInd(lInd_Pr.idFather);
                Inc(i);
              end;
            if lInd_Pr.idMother > 0 then
                lInd[i] := PeekInd(lInd_Pr.idMother);
          end;
        hIRd_AllParent:
          begin
            setlength(lind, lInd_Pr.ParentCount);
            i := 0;
            if lInd_Pr.idFather > 0 then
              begin
                lInd[i] := PeekInd(lInd_Pr.idFather);
                Inc(i);
              end;
            if lInd_Pr.idMother > 0 then
                lInd[i] := PeekInd(lInd_Pr.idMother);
          end;
        hIRd_Child: if length(lInd_Pr.Children) > 0 then
                lInd[0] := FIndi.PeekInd[lInd_Pr.Children[0]]
            else
                setlength(lind, 0);
        hIRd_AnyChild:
          begin
            setlength(lind, lInd_Pr.ChildCount);
            for i := 0 to lInd_Pr.ChildCount - 1 do
                lind[i] := PeekInd(lInd_Pr.Children[i]);
          end;
        hIRd_AllChild:
          begin
            setlength(lind, lInd_Pr.ChildCount);
            for i := 0 to lInd_Pr.ChildCount - 1 do
                lind[i] := PeekInd(lInd_Pr.Children[i]);
          end;
      end;
    if length(lind) = 0 then
        if field <> 99 then
            Result := null
        else
            Result := 0
    else if (length(lind) = 1) and (field >= 99) and (field < 199) then
        Result := lind[0].Data[TEnumHejIndDatafields(field - 100)]
    else if (length(lind) = 1) and (field >= 199) and (field < 299) then
        if length(lind[0].Marriages) > 0 then
            Result := Fmarr.Data[lInd[0].Marriages[0], TEnumHejMarrDatafields(field - 200)]
        else
            Result := null
    else if (length(lind) = 1) and (field < 99) then
        case TenumIndMetaData(Field) of
            hInMeD_ParentCount:
                Result := lInd[0].ParentCount;
            hInMeD_SpouseCount: Result := lInd[0].SpouseCount;
            hInMeD_ChildCount: Result := lInd[0].ChildCount;
            hInMeD_SiblingCount:
              begin
                if lInd[0].idFather <> 0 then
                    Result := length(PeekInd(lInd[0].idFather).Children) - 1
                else
                    Result := 0;
                if lInd[0].idMother <> 0 then
                    if Result = 0 then
                        Result := length(PeekInd(lInd[0].idMother).Children) - 1
                    else
                        for i := 0 to length(PeekInd(lInd[0].idMother).Children) - 1 do
                            if (lind[0].id <> PeekInd(lInd[0].idMother).Children[i]) and
                                (lind[0].idFather <>
                                PeekInd(PeekInd(lInd[0].idMother).Children[i]).idFather) then
                                Result := Result + 1;
              end;
            hInMeD_SourceCount:
              begin
                Result := lInd[0].SourceCount;
                for i := 0 to high(lind[0].Marriages) do
                    for lMdf in CMarrSourceData do
                        if Fmarr[lind[0].Marriages[i], lMdf] <> '' then
                            Result := Result + 1;

              end;
            hInMeD_PlaceCount:
              begin
                Result := lind[0].PlaceCount;
                for i := 0 to high(lind[0].Marriages) do
                    for lMdf in CMarrPlaceData do
                        if Fmarr[lind[0].Marriages[i], lMdf] <> '' then
                            Result := Result + 1;

              end;
            hInMeD_AdoptCount: Result := null;
            hInMeD_AnyPlace:
              begin
                Result := VarArrayCreate([0, 50], varVariant);
                lResCnt := 0;
                for lIdf in CIndPlacedata do
                    if lind[0].Data[lIdf] <> '' then
                      begin
                        Result[lResCnt] := lind[0].Data[lIdf];
                        Inc(lResCnt);
                      end;
                for i := 0 to high(lind[0].Marriages) do
                    for lMdf in CMarrPlaceData do
                        if Fmarr[lind[0].Marriages[i], lMdf] <> '' then
                          begin
                            Result[lResCnt] := Fmarr[lind[0].Marriages[i], lMdf];
                            Inc(lResCnt);
                          end;
                VarArrayRedim(Result, lResCnt - 1);
              end;
            hInMeD_AnySource:
              begin
                Result := VarArrayCreate([0, 50], varVariant);
                lResCnt := 0;
                for lIdf in CIndSourceData do
                    if lind[0].Data[lIdf] <> '' then
                      begin
                        Result[lResCnt] := lind[0].Data[lIdf];
                        Inc(lResCnt);
                      end;

                for i := 0 to high(lind[0].Marriages) do
                    for lMdf in CMarrSourceData do
                        if Fmarr[lind[0].Marriages[i], lMdf] <> '' then
                          begin
                            Result[lResCnt] := Fmarr[lind[0].Marriages[i], lMdf];
                            Inc(lResCnt);
                          end;
                VarArrayRedim(Result, lResCnt - 1);
              end;
            hInMeD_AnyData:
              begin
                Result := VarArrayCreate([0, 150], varVariant);
                lResCnt := 0;
                for lIdf in TEnumHejIndDatafields do
                    if not VarIsEmpty(lind[0].Data[lIdf]) then
                      begin
                        Result[lResCnt] := lind[0].Data[lIdf];
                        Inc(lResCnt);
                      end;
                for i := 0 to high(lind[0].Marriages) do
                    for lMdf in TEnumHejMarrDatafields do
                        if not VarIsEmpty(Fmarr[lind[0].Marriages[i], lMdf]) then
                          begin
                            Result[lResCnt] := Fmarr[lind[0].Marriages[i], lMdf];
                            Inc(lResCnt);
                          end;
                VarArrayRedim(Result, lResCnt - 1);
              end;
            hInMeD_AgeOfBapt:
              begin
                TryStrToDate(lind[0].GetDateData(hind_BirthDay), lBirth);
                TryStrToDate(lind[0].GetDateData(hind_BaptDay), lSecond);
                Result := YearSpan(lBirth, lSecond);

              end;
            hInMeD_AgeOfNextSibl: ;
            hInMeD_AgeOfConf: Result := null;
            hInMeD_AgeOfFMarriage:
              begin
                if lind[0].SourceCount = 0 then
                    exit(null);
                if not TryStrToDate(lind[0].GetDateData(hind_BirthDay), lBirth) then
                    exit(null);
                laDate := lBirth;
                for i := 0 to lInd[0].SpouseCount - 1 do
                  begin
                    if TryStrToDate(fmarr.GetDateData(lInd[0].Marriages[i], hmar_MarrChrchDay),
                        lSecond) then
                        if (laDate = lBirth) or (laDate > lSecond) then
                            laDate := lSecond;
                    if TryStrToDate(fmarr.GetDateData(lInd[0].Marriages[i], hmar_MarrStateDay),
                        lSecond) then
                        if (laDate = lBirth) or (laDate > lSecond) then
                            laDate := lSecond;
                  end;
                if laDate > lBirth then
                    Result := YearsBetween(lBirth, lSecond)
                else
                    Result := null;

              end;
            hInMeD_AgeOfFirstChild:
              begin
                if lind[0].ChildCount = 0 then
                    exit(null);
                if not TryStrToDate(lind[0].GetDateData(hind_BirthDay), lBirth) then
                    exit(null);
                laDate := lBirth;
                for i := 0 to lInd[0].ChildCount - 1 do
                  begin
                    if TryStrToDate(FIndi.GetDateData(lInd[0].Children[i], hind_BirthDay),
                        lSecond) then
                        if (laDate = lBirth) or (laDate > lSecond) then
                            laDate := lSecond;
                    if TryStrToDate(FIndi.GetDateData(lInd[0].Children[i], hind_BaptDay),
                        lSecond) then
                        if (laDate = lBirth) or (laDate > lSecond) then
                            laDate := lSecond;
                  end;
                if laDate > lBirth then
                    Result := YearsBetween(lBirth, lSecond)
                else
                    Result := null;
              end;
            hInMeD_AgeOfLMarriage:
              begin
                if lind[0].SourceCount = 0 then
                    exit(null);
                if not TryStrToDate(lind[0].GetDateData(hind_BirthDay), lBirth) then
                    exit(null);
                laDate := lBirth;
                for i := 0 to lInd[0].SpouseCount - 1 do
                  begin
                    if TryStrToDate(fmarr.GetDateData(lInd[0].Marriages[i], hmar_MarrChrchDay),
                        lSecond) then
                        if (laDate < lSecond) then
                            laDate := lSecond;
                    if TryStrToDate(fmarr.GetDateData(lInd[0].Marriages[i], hmar_MarrStateDay),
                        lSecond) then
                        if (laDate < lSecond) then
                            laDate := lSecond;
                  end;
                if laDate > lBirth then
                    Result := YearsBetween(lBirth, lSecond)
                else
                    Result := null;
              end;
            hInMeD_AgeOfLChild:
              begin
                if lind[0].ChildCount = 0 then
                    exit(null);
                if not TryStrToDate(lind[0].GetDateData(hind_BirthDay), lBirth) then
                    exit(null);
                laDate := lBirth;
                for i := 0 to lInd[0].ChildCount - 1 do
                  begin
                    if TryStrToDate(FIndi.GetDateData(lInd[0].Children[i], hind_BirthDay),
                        lSecond) then
                        if (laDate < lSecond) then
                            laDate := lSecond;
                    if TryStrToDate(FIndi.GetDateData(lInd[0].Children[i], hind_BaptDay),
                        lSecond) then
                        if (laDate < lSecond) then
                            laDate := lSecond;
                  end;
                if laDate > lBirth then
                    Result := YearsBetween(lBirth, lSecond)
                else
                    Result := null;
              end;
            hInMeD_AgeOfDeath:
              begin
                if not TryStrToDate(lind[0].GetDateData(hind_BirthDay), lBirth) then
                    exit(null);
                TryStrToDate(lind[0].GetDateData(hind_DeathDay), lSecond);
                Result := YearsBetween(lBirth, lSecond);
              end;
            hInMeD_AgeDiffToSpouse: ;
          end
    else if (length(lind) > 1) and (field >= 99) and (field < 199) then
      begin
        Result := VarArrayCreate([0, high(lInd)], varVariant);
        for i := 0 to high(lInd) do
            Result[i] := lInd[i].Data[TEnumHejIndDatafields(field - 100)];
      end
    else
        Result := null;

end;

procedure TClsHejGenealogy.SetDate(index: integer;
  Field: TEnumHejIndDatafields; aValue: String);
begin
  FIndi.setDateData(index,Field,aValue);
end;

function TClsHejGenealogy.PeekInd(index: integer): THejIndData;
begin
    Result := findi.PeekInd[index];
end;

function TClsHejGenealogy.GetFather: THejIndData;
begin
    Result := Findi.PeekInd[FIndi.ActualInd.idFather];
end;

function TClsHejGenealogy.GetIndividual(index: integer): THejIndData;
begin
    Result := FIndi.Individual[index];
end;

function TClsHejGenealogy.GetIndividualCount: integer;
begin
    Result := FIndi.Count;
end;

function TClsHejGenealogy.GetMarriageData(idx: integer): THejMarrData;
begin
    Result := FMarr.Marriage[FIndi.ActualMarriage[idx]];
end;

function TClsHejGenealogy.GetMarriage(idMarr: integer): THejMarrData;
begin
    Result := Fmarr.Marriage[idMarr];
end;

function TClsHejGenealogy.GetMarriagesCount: integer;
begin
    Result := FMarr.Count;
end;

function TClsHejGenealogy.GetMother: THejIndData;
begin
    Result := Findi.PeekInd[FIndi.ActualInd.idMother];
end;

function TClsHejGenealogy.GetPlaceCount: integer;
begin
    Result := FPlac.Count;
end;

function TClsHejGenealogy.GetSourceCount: integer;
begin
    Result := FSour.Count;
end;

function TClsHejGenealogy.GetSpouse(idx: integer): THejIndData;
begin
    Result := Findi.PeekInd[FMarr.Marriage[FIndi.ActualMarriage[idx]].idSpouse];
end;

function TClsHejGenealogy.GetSpouseCount: integer;
begin
    Result := FIndi.ActualMarriageCount;
end;

procedure TClsHejGenealogy.SetActualInd(AValue: THejIndData);
begin
    FIndi.ActualInd := AValue;
    if Assigned(FOnDataChange) then
        FOnDataChange(Findi);
end;

procedure TClsHejGenealogy.SetActualMarriage(AValue: THejMarrData);
begin
    FMarr.ActualMarr := AValue;
    if Assigned(FOnDataChange) then
        FOnDataChange(FMarr);
end;

procedure TClsHejGenealogy.SetData(index: integer; Field: TEnumHejIndDatafields;
    AValue: variant);
begin
    Findi.SetData(index, Field, AValue);
    if field in CIndPlacedata then
      begin
        if FPlac.IndexOf(AValue)=-1 then
          FPlac.NewPlace(AValue);
      end
    else if field in CIndSourceData then
      begin
        if FSour.IndexOf(AValue)= -1 then
          Fsour.NewSource(aValue);
      end;
end;

procedure TClsHejGenealogy.SetData(ind, index: integer;
    Field: TEnumHejMarrDatafields; AValue: variant);
begin
    if ind = -1 then
        ind := GetActID;
    if index < length(FIndi.PeekInd[Ind].Marriages) then
        FMarr.SetData(FIndi.PeekInd[Ind].Marriages[index], Field, AValue);
end;

procedure TClsHejGenealogy.SetMarriage(idMarr: integer; AValue: THejMarrData);
begin
    if FMarr.Marriage[idMarr].Equals(AValue) then
        exit;
    FMarr.Marriage[idMarr] := AValue;
end;

procedure TClsHejGenealogy.SetMarriageData(idx: integer; AValue: THejMarrData);
begin
    if FMarr.Marriage[FIndi.ActualMarriage[idx]].Equals(AValue) then
        exit;
    FMarr.Marriage[FIndi.ActualMarriage[idx]] := AValue;
end;

procedure TClsHejGenealogy.SetOnDataChange(AValue: TNotifyEvent);
begin
    if @FOnDataChange = @AValue then
        Exit;
    FOnDataChange := AValue;
end;

procedure TClsHejGenealogy.SetOnStateChange(AValue: TNotifyEvent);
begin
    if @FOnStateChange = @AValue then
        Exit;
    FOnStateChange := AValue;
end;

procedure TClsHejGenealogy.SetOnUpdate(AValue: TNotifyEvent);
begin
    if @FOnUpdate = @AValue then
        Exit;
    FOnUpdate := AValue;
end;

function TClsHejGenealogy.GetCount: integer;
begin
    Result := FIndi.Count;
end;

function TClsHejGenealogy.TestStreamHeader(st: Tstream): boolean;
begin
    Result := FIndi.TestStreamHeader(st);
end;

function TClsHejGenealogy.IndexOf(Krit: variant): integer;
begin
    Result := Findi.IndexOf(Krit);
end;

constructor TClsHejGenealogy.Create;
begin
    FIndi := TClsHejIndividuals.Create;
    FMarr := TClsHejMarriages.Create;
    FAdop := TClsHejAdoptions.Create;
    FPlac := TClsHejPlaces.Create;
    FSour := TClsHejSources.Create;
end;

destructor TClsHejGenealogy.Destroy;
begin
    FreeAndNil(FSour);
    FreeAndNil(FPlac);
    FreeAndNil(FAdop);
    FreeAndNil(FMarr);
    FreeAndNil(FIndi);
    inherited Destroy;
end;

procedure TClsHejGenealogy.Clear;
begin
    FSour.Clear;
    FPlac.Clear;
    FAdop.Clear;
    FMarr.Clear;
    FIndi.Clear;
end;

procedure TClsHejGenealogy.ReadfromStream(st: Tstream; cls: TClsHejBase);

begin
    Findi.ReadfromStream(st);
    FMarr.ReadfromStream(st, FIndi);
    FAdop.ReadfromStream(st);
    FPlac.ReadfromStream(st);
    FSour.ReadfromStream(st);
    if Assigned(FOnUpdate) then
        FOnUpdate(Self);
end;

procedure TClsHejGenealogy.LoadFromFile(Filename: string);
var
    lStr: TFileStream;
    lStl: TMemoryStream;
begin
    lStr := TFileStream.Create(Filename, fmOpenRead);
    lStl := TMemoryStream.Create;
      try
        lStl.LoadFromStream(lstr);
        ReadFromStream(lStl);
      finally
        FreeAndNil(lStr);
        FreeAndNil(lStl)
      end;
end;

procedure TClsHejGenealogy.WriteToStream(st: TStream);
begin
    FIndi.WriteToStream(st);
    FMarr.WriteToStream(st);
    FAdop.WriteToStream(st);
    FPlac.WriteToStream(st);
    FSour.WriteToStream(st);
end;

procedure TClsHejGenealogy.First(Sender: TObject);
var
    lLastID: integer;
begin
    lLastID := Findi.GetActID;
    FIndi.First;
    if Assigned(FOnUpdate) and (lLastID <> Findi.GetActID) then
        FOnUpdate(Self);
end;

procedure TClsHejGenealogy.Last(Sender: TObject);
var
    lLastID: integer;
begin
    lLastID := Findi.GetActID;
    Findi.Last;
    if Assigned(FOnUpdate) and (lLastID <> Findi.GetActID) then
        FOnUpdate(Self);
end;

procedure TClsHejGenealogy.Next(Sender: TObject);
var
    lLastID: integer;
begin
    lLastID := Findi.GetActID;
    Findi.Next;
    if Assigned(FOnUpdate) and (lLastID <> Findi.GetActID) then
        FOnUpdate(Self);
end;

procedure TClsHejGenealogy.Previous(Sender: TObject);
var
    lLastID: integer;
begin
    lLastID := Findi.GetActID;
    Findi.Previous(Sender);
    if Assigned(FOnUpdate) and (lLastID <> Findi.GetActID) then
        FOnUpdate(Self);
end;

procedure TClsHejGenealogy.Append(Sender: TObject);
begin
    Findi.Append(Sender);
    if Assigned(FOnUpdate) then
        FOnUpdate(Self);
    if Assigned(FOnStateChange) then
        FOnStateChange(Self);
end;

procedure TClsHejGenealogy.AppendLinkChild(idInd, idChild: integer);
begin
    FIndi.AppendLinkChild(idInd, idChild);
end;

procedure TClsHejGenealogy.AppendSpouse(Sender: TObject);
var
    lInd, lSpouse, lMarr1, lMarr2: integer;
begin
    lInd := Findi.GetActID;
    Findi.Append(Sender);
    lSpouse := Findi.GetActID;
    Fmarr.Append(Sender);
    lMarr1 := Fmarr.GetActID;
    Fmarr.ActualMarrSetLink(lind, lSpouse);
    FIndi.AppendMarriage(Lind, FMarr.getActID);
    Fmarr.Append(Sender);
    Fmarr.ActualMarrSetLink(lSpouse, lInd);
    Fmarr.SetRevIdx(Lmarr1);
    FIndi.AppendMarriage(lSpouse, FMarr.getActID);
    if Assigned(FOnUpdate) then
        FOnUpdate(Self);
    if Assigned(FOnStateChange) then
        FOnStateChange(Self);
end;

procedure TClsHejGenealogy.AppendParent(Knd: TEnumHejIndDatafields; Sender: TObject);
var
    lInd: integer;
begin
    lInd := Findi.GetActID;
    Findi.Append(Sender);
    case Knd of
        hind_idFather:
          begin
            Findi.SetData(lind, Knd, FIndi.GetActID);
            Findi.SetData(FIndi.GetActID, hind_Sex, 'm');
            Findi.AppendLinkChild(Findi.GetActID, Lind);
          end;
        hind_idMother:
          begin
            Findi.SetData(lind, Knd, FIndi.GetActID);
            Findi.SetData(FIndi.GetActID, hind_Sex, 'w');
            Findi.AppendLinkChild(Findi.GetActID, Lind);
          end
        else
      end;
    if Assigned(FOnUpdate) then
        FOnUpdate(Self);
    if Assigned(FOnStateChange) then
        FOnStateChange(Self);
end;

procedure TClsHejGenealogy.AppendAdoption(idAdopter: integer);
begin
    FAdop.append;
    Fadop.Data[-1, hadop_idPerson] := Findi.GetActID;
    if Findi.PeekInd[idAdopter].Sex = 'w' then
        Fadop.Data[-1, hadop_idMother] := idAdopter
    else
        Fadop.Data[-1, hadop_idFather] := idAdopter;
end;

procedure TClsHejGenealogy.MergePerson(lFirst, lSecond: integer);
begin
  FIndi.Merge(lFirst, lSecond);
  FMarr.ReplacePerson(lSecond,lFirst);
  FAdop.ReplacePerson(lSecond,lFirst);
end;

procedure TClsHejGenealogy.SetMarriage(idInd, idSpouse: integer);
var
    lMarrIdx: integer;
begin
    lMarrIdx := FMarr.IndexOf(vararrayof([idind, idSpouse]));
    if lMarrIdx = -1 then
      begin
        FMarr.Append(self);
        FMarr.ActualMarrSetLink(idInd, idSpouse);
      end
    else
        Fmarr.Seek(lMarrIdx);
end;

procedure TClsHejGenealogy.SetPlace(aPlace: THejPlaceData);
begin
    FPlac.Setplace(aPlace);
    if Assigned(FOnDataChange) then
        FOnDataChange(Self);
end;

procedure TClsHejGenealogy.SetSource(aSource: THejSourData);
begin
    FSour.SetSource(aSource);
    if Assigned(FOnDataChange) then
        FOnDataChange(Self);
end;

procedure TClsHejGenealogy.Edit(Sender: TObject);
begin
    Findi.Edit(Sender);
    if Assigned(FOnStateChange) then
        FOnStateChange(Self);
end;

procedure TClsHejGenealogy.Post(Sender: TObject);
begin
    Findi.Post(Sender);
    if Assigned(FOnStateChange) then
        FOnStateChange(Self);
end;

procedure TClsHejGenealogy.Seek(NewID: integer);
var
    lLastID: integer;
begin
    lLastID := Findi.GetActID;
    if NewID >= 0 then
        Findi.Seek(NewID)
    else
        case NewID of
            -1: Findi.seek(Findi.ActualInd.idFather);
            -2: Findi.seek(Findi.ActualInd.idMother);

          end;
    if Assigned(FOnUpdate) and (lLastID <> Findi.GetActID) then
        FOnUpdate(Self);
end;

procedure TClsHejGenealogy.GotoChild(IDCh: integer);
begin
    Seek(ActualInd.Children[idch - 1]);
end;

procedure TClsHejGenealogy.GotoParent(Knd: TEnumHejIndDatafields);
begin
    case Knd of
        hind_idFather: seek(-1);
        hind_idMother: Seek(-2);
        else
      end;
end;

procedure TClsHejGenealogy.GotoSpouse(IDSp: integer);
begin
    Seek(Spouse[IDSp].ID);
end;

procedure TClsHejGenealogy.Cancel(Sender: TObject);
begin
    Findi.Cancel(Sender);
    if Assigned(FOnUpdate) then
        FOnUpdate(Self);
    if Assigned(FOnStateChange) then
        FOnStateChange(Self);
end;

procedure TClsHejGenealogy.Delete(Sender: TObject);
begin
    Findi.Delete(Sender);
    if Assigned(FOnUpdate) then
        FOnUpdate(Self);
end;

function TClsHejGenealogy.EOF: boolean;
begin
    Result := FIndi.EOF;
end;

function TClsHejGenealogy.BOF: boolean;
begin
    Result := FIndi.bof;

end;

function TClsHejGenealogy.GetData: variant;
begin

end;

procedure TClsHejGenealogy.SetData(NewVal: variant);
begin

end;

function TClsHejGenealogy.GetActID: integer;
begin
    Result := FIndi.GetActID;
end;

function TClsHejGenealogy.GetOnUpdate: TNotifyEvent;
begin
  result := FOnUpdate;
end;

initialization
    rshIRd[hIRd_Meta] := rshIRd_Meta;
    rshIRd[hIRd_Ind] := rshIRd_Ind;
    rshIRd[hIRd_Spouse] := rshIRd_Spouse;
    rshIRd[hIRd_AnySpouse] := rshIRd_AnySpouse;
    rshIRd[hIRd_AllSpouse] := rshIRd_AllSpouse;
    rshIRd[hIRd_Father] := rshIRd_Father;
    rshIRd[hIRd_Mother] := rshIRd_Mother;
    rshIRd[hIRd_AnyParent] := rshIRd_AnyParent;
    rshIRd[hIRd_AllParent] := rshIRd_AllParent;
    rshIRd[hIRd_Child] := rshIRd_Child;
    rshIRd[hIRd_AnyChild] := rshIRd_AnyChild;
    rshIRd[hIRd_AllChild] := rshIRd_AllChild;
end.
