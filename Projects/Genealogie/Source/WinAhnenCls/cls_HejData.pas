unit cls_HejData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,variants,db, Unt_IData, cls_HejBase,cls_HejIndData,cls_HejMarrData,cls_HejAdopData,
  cls_HejPlaceData,cls_HejSourceData;

type
   TEnumHejIndRedir=
    ( hIRd_Meta = -1,   // e.G. Counts, Timeline-Data
      hIRd_Ind = 0,   // Individual Data
      hIRd_Spouse = 1,  // Data of Main(Last) Spouse
      hIRd_AnySpouse = 2,  // Data of any Spouse
      hIRd_AllSpouse = 3,  // Data of all Spousees
      hIRd_Father = 4,  // Data of Father
      hIRd_Mother = 5,  // Data of Mother
      hIRd_AnyParent = 6,  // Data of any Parent
      hIRd_AllParent = 7,  // Data of all Parents
      hIRd_Child = 8,     // Data of Child
      hIRd_AnyChild =9,  // Data of any Child
      hIRd_AllChild =10); // Data of all Childs

    TenumIndMetaData=
   ( hInMeD_ParentCount = 0,
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

 TClsHejGenealogy=class(TClsHejBase,IData)
 private
    FIndi:TClsHejIndividuals;
    FMarr:TClsHejMarriages;
    FAdop:TClsHejAdoptions;
    FOnDataChange: TNotifyEvent;
    FOnStateChange: TNotifyEvent;
    FOnUpdate: TNotifyEvent;
    FPlac:TClsHejPlaces;
    FSour:TClsHejSources;
    function GetActualInd: THejIndData;
    function GetActualMarriage: THejMarrData;
    function GetChild(idx: integer): THejIndData;
    function GetChildCount: integer;
    function GetFather: THejIndData;
    function GetIndividual(index: integer): THejIndData;
    function GetIndividualCount: integer;
    function GetMarriageData(idx: Integer): THejMarrData;
    function GetMarriagesCount: integer;
    function GetMother: THejIndData;
    function GetPlaceCount: integer;
    function GetSourceCount: integer;
    function GetSpouse(idx: integer): THejIndData;
    function GetSpouseCount: integer;
    procedure SetActualInd(AValue: THejIndData);
    procedure SetActualMarriage(AValue: THejMarrData);
    procedure SetData(index: integer; Field: TEnumHejIndDatafields;
      AValue: variant);overload;
    procedure SetData(ind, index: integer; Field: TEnumHejMarrDatafields;
      AValue: variant);overload;
    procedure SetMarriageData(idx: Integer; AValue: THejMarrData);
    procedure SetOnDataChange(AValue: TNotifyEvent);
    procedure SetOnStateChange(AValue: TNotifyEvent);
    procedure SetOnUpdate(AValue: TNotifyEvent);
 protected
    function GetCount: integer; override;
 public
    function TestStreamHeader(st: Tstream): boolean; override;
    function IndexOf(Krit: variant): integer; override;
    function GetData(index: integer; Field: TEnumHejIndDatafields): variant;overload;
    function GetData(ind, index: integer; Field: TEnumHejMarrDatafields): variant;
      overload;
    function GetData(index: integer;Redir:TEnumHejIndRedir; Field: integer): variant;overload;
    function PeekInd(index:integer):THejIndData;
    Property Individual[index:integer]:THejIndData read GetIndividual;
    Property ActualInd:THejIndData read GetActualInd write SetActualInd;
    Property ActualMarriage:THejMarrData read GetActualMarriage write SetActualMarriage;
    Property Father:THejIndData read GetFather;
    Property Mother:THejIndData read GetMother;
    Property iData[index:integer;Field:TEnumHejIndDatafields]:variant read GetData write SetData;
    Property mData[ind,index:integer;Field:TEnumHejMarrDatafields]:variant read GetData write SetData;
    Property Spouse[idx:integer]:THejIndData read GetSpouse ;
    Property MarriageData[idx:Integer]:THejMarrData read GetMarriageData write SetMarriageData;
    Property SpouseCount:integer read GetSpouseCount;
    Property PlaceCount:integer read GetPlaceCount;
    Property SourceCount:integer read GetSourceCount;
    Property Child[idx:integer]:THejIndData read GetChild ;
    Property ChildCount:integer read GetChildCount;
    Property IndividualCount:integer read GetIndividualCount;
    Property MarriagesCount:integer read GetMarriagesCount;
    Property OnStateChange:TNotifyEvent read FOnStateChange write SetOnStateChange;
    Property OnDataChange:TNotifyEvent read FOnDataChange write SetOnDataChange;
    PRoperty OnUpdate:TNotifyEvent read FOnUpdate write SetOnUpdate;
 public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Clear;override;
    procedure ReadfromStream(st:Tstream;{%H-}cls:TClsHejBase=nil);override;
    Procedure LoadFromFile(Filename:String);
    Procedure WriteToStream(st:TStream);override;
    Procedure First(Sender:TObject=nil);
    Procedure Last(Sender:TObject=nil);
    Procedure Next(Sender:TObject=nil);
    Procedure Previous(Sender:TObject=nil);
    Procedure Append(Sender:TObject=nil);
    procedure AppendLinkChild(idInd, idChild: integer);
    Procedure AppendSpouse(Sender:TObject=nil);
    Procedure AppendParent(Knd:TEnumHejIndDatafields;Sender:TObject=nil);
    Procedure AppendAdoption(idAdopter:integer);
    Procedure SetMarriage(idInd,idSpouse:integer);
    Procedure SetPlace(aPlace:THejPlaceData);
    Procedure SetSource(aSource:THejSourData);
    Procedure Edit(Sender:TObject=nil);
    Procedure Post(Sender:TObject=nil);
    Procedure Seek(NewID:integer);
    Procedure GotoChild(IDCh:integer=1);
    Procedure GotoParent(Knd:TEnumHejIndDatafields);
    Procedure GotoSpouse(IDSp:integer=1);
    Procedure Cancel(Sender:TObject=nil);
    procedure Delete(Sender: Tobject=nil);
    function EOF: boolean;
    Function BOF: boolean;
    Function GetData:Variant;
    procedure SetData(NewVal: Variant);overload;
    Function GetActID: integer;
 end;

 Const
      CindRedir:array[TEnumHejIndRedir] of string=(
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

implementation

uses dateutils,LConvEncoding,dm_GenData2;

{ TClsHejGenealogy }

function TClsHejGenealogy.GetActualInd: THejIndData;
begin
 result:= FIndi.ActualInd;
end;

function TClsHejGenealogy.GetActualMarriage: THejMarrData;
begin
  result := Fmarr.ActualMarr;
end;

function TClsHejGenealogy.GetChild(idx: integer): THejIndData;
begin
  result:=Findi.PeekInd[FIndi.ActualChild[idx]];
end;

function TClsHejGenealogy.GetChildCount: integer;
begin
  result:=FIndi.ActualChildCount;
end;

function TClsHejGenealogy.GetData(index: integer; Field: TEnumHejIndDatafields
  ): variant;
begin
  result:=Findi.Data[index,Field];
end;

function TClsHejGenealogy.GetData(ind, index: integer; Field: TEnumHejMarrDatafields
  ): variant;
begin
  if ind=-1 then
     ind := GetActID;
  if index < length(Findi.PeekInd[ind].Marriages) then
  result:=FMarr.Data[Findi.PeekInd[ind].Marriages[index],Field]
  else
    Result:= null;
end;

function TClsHejGenealogy.GetData(index: integer; Redir: TEnumHejIndRedir;
  Field: integer): variant;

var
  lInd_Pr:THejIndData;
  lInd:array of  THejIndData;
  lIdf:TEnumHejIndDatafields;
  lMdf:TEnumHejMarrDatafields;
  i, lResCnt: Integer;
  lBirth, lSecond, laDate: TDateTime;


begin

   setlength(lind,1);
   lInd_Pr := FIndi.PeekInd[index];
  case Redir of
    hIRd_Meta: lInd[0] := lInd_Pr;
    hIRd_Ind: lInd[0] := lInd_Pr;
    hIRd_Spouse: if length(lInd_Pr.Marriages)>0 then lInd[0] := PeekInd(Fmarr.Marriage[lInd_Pr.Marriages[0]].idSpouse) else SetLength(lInd,0);
    hIRd_AnySpouse: begin
        setlength(lind,lInd_Pr.SpouseCount);
        for i := 0 to lInd_Pr.SpouseCount-1 do
          lInd[i] := peekind(fmarr.Data[lInd_Pr.Marriages[i],hmar_idSpouse]);
      end;
    hIRd_AllSpouse: begin
    setlength(lind,lInd_Pr.SpouseCount);
    for i := 0 to lInd_Pr.SpouseCount-1 do
      lInd[i] := peekind(fmarr.Data[lInd_Pr.Marriages[i],hmar_idSpouse]);
end;
    hIRd_Father: if lInd_Pr.idFather>0 then lInd[0] := FIndi.PeekInd[lInd_Pr.idFather] else setlength(lind,0);
    hIRd_Mother: if lInd_Pr.idMother>0 then lInd[0] := FIndi.PeekInd[lInd_Pr.idMother] else setlength(lind,0);
    hIRd_AnyParent: begin
       setlength(lind,lInd_Pr.ParentCount);
       i := 0;
       if lInd_Pr.idFather > 0 then
          begin
          lInd[i] := PeekInd( lInd_Pr.idFather);
          inc(i)
          end;
       if lInd_Pr.idMother > 0 then
          lInd[i] := PeekInd( lInd_Pr.idMother);
end;
    hIRd_AllParent: begin
       setlength(lind,lInd_Pr.ParentCount);
       i := 0;
       if lInd_Pr.idFather > 0 then
          begin
          lInd[i] := PeekInd( lInd_Pr.idFather);
          inc(i)
          end;
       if lInd_Pr.idMother > 0 then
          lInd[i] := PeekInd( lInd_Pr.idMother);
 end;
    hIRd_Child: if length(lInd_Pr.Children)>0 then lInd[0] := FIndi.PeekInd[lInd_Pr.Children[0]] else setlength(lind,0);
    hIRd_AnyChild: begin
    setlength(lind,lInd_Pr.ChildCount);
      for i := 0 to lInd_Pr.ChildCount-1 do
        lind[i]:= PeekInd(lInd_Pr.Children[i]);
    end;
    hIRd_AllChild: begin
    setlength(lind,lInd_Pr.ChildCount);
      for i := 0 to lInd_Pr.ChildCount-1 do
        lind[i]:= PeekInd(lInd_Pr.Children[i]);
    end;
  end;
  if length(lind) = 0 then
    if field <> 99 then result := null else result := 0
  else if (length(lind) = 1) and (field >=99) and (field <199) then
    result := lind[0].Data[TEnumHejIndDatafields(field-100)]
  else if (length(lind) = 1) and (field >=199) and (field <299)  then
    if length(lind[0].Marriages) >0 then
      result := Fmarr.Data[lInd[0].Marriages[0],TEnumHejMarrDatafields(field-200)]
    else
      result := null
  else if (length(lind) = 1)  and (field <99)  then
     case TenumIndMetaData(Field) of
       hInMeD_ParentCount:
         result := lInd[0].ParentCount;
       hInMeD_SpouseCount: result := lInd[0].SpouseCount;
       hInMeD_ChildCount: result := lInd[0].ChildCount;
       hInMeD_SiblingCount: begin
           if lInd[0].idFather <> 0 then
            result := length(PeekInd(lInd[0].idFather).Children)-1
           else
             result := 0;
           if lInd[0].idMother <> 0 then
          if result = 0 then
            result := length(PeekInd(lInd[0].idMother).Children)-1
          else
            for i := 0 to length(PeekInd(lInd[0].idMother).Children)-1 do
              if (lind[0].id <> PeekInd(lInd[0].idMother).Children[i]) and
                (lind[0].idFather <> PeekInd(PeekInd(lInd[0].idMother).Children[i]).idFather) then
                  Result:=result +1;
       end;
       hInMeD_SourceCount:
         begin
           result := lInd[0].SourceCount;
           for i := 0 to high(lind[0].Marriages) do
             for lMdf in CMarrSourceData do
if Fmarr[lind[0].Marriages[i],lMdf] <> '' then
   result := result+ 1;

         end;
       hInMeD_PlaceCount:
       begin
           result :=lind[0].PlaceCount;
       for i := 0 to high(lind[0].Marriages) do
       for lMdf in CMarrPlaceData do
         if Fmarr[lind[0].Marriages[i],lMdf] <> '' then
            result := result+ 1;

       end;
       hInMeD_AdoptCount: result:=null;
       hInMeD_AnyPlace:
       begin
       result :=VarArrayCreate([0,50],varVariant);
       lResCnt := 0;
       for lIdf in CIndPlacedata do
         if lind[0].Data[lIdf] <> '' then
            begin
            result[lResCnt] := lind[0].Data[lIdf];
            inc(lResCnt);
            end;
       for i := 0 to high(lind[0].Marriages) do
       for lMdf in CMarrPlaceData do
         if Fmarr[lind[0].Marriages[i],lMdf] <> '' then
            begin
            result[lResCnt] := Fmarr[lind[0].Marriages[i],lMdf];
            inc(lResCnt);
            end;
        VarArrayRedim(result,lResCnt-1);
       end;
       hInMeD_AnySource:
       begin
          result :=VarArrayCreate([0,50],varVariant);
          lResCnt := 0;
       for lIdf in CIndSourceData do
         if lind[0].Data[lIdf] <> '' then
            begin
            result[lResCnt] := lind[0].Data[lIdf];
            inc(lResCnt);
            end;

       for i := 0 to high(lind[0].Marriages) do
       for lMdf in CMarrSourceData do
         if Fmarr[lind[0].Marriages[i],lMdf] <> '' then
            begin
            result[lResCnt] := Fmarr[lind[0].Marriages[i],lMdf];
            inc(lResCnt);
            end;
         VarArrayRedim(result,lResCnt-1);
       end;
       hInMeD_AnyData:
       begin
       result :=VarArrayCreate([0,150],varVariant);
       lResCnt := 0;
       for lIdf in TEnumHejIndDatafields do
         if  not VarIsEmpty( lind[0].Data[lIdf]) then
            begin
            result[lResCnt] := lind[0].Data[lIdf];
            inc(lResCnt);
            end;
       for i := 0 to high(lind[0].Marriages) do
       for lMdf in TEnumHejMarrDatafields do
         if not VarIsEmpty(Fmarr[lind[0].Marriages[i],lMdf] ) then
            begin
            result[lResCnt] := Fmarr[lind[0].Marriages[i],lMdf];
            inc(lResCnt);
            end;
        VarArrayRedim(result,lResCnt-1);
       end;
       hInMeD_AgeOfBapt: begin
          TryStrToDate(lind[0].GetDateData(hind_BirthDay),lBirth);
          TryStrToDate(lind[0].GetDateData(hind_BaptDay),lSecond);
          result := YearSpan(lBirth,lSecond);

       end;
       hInMeD_AgeOfNextSibl: ;
       hInMeD_AgeOfConf:result := null ;
       hInMeD_AgeOfFMarriage:begin
          if lind[0].SourceCount=0 then exit(null);
          if not TryStrToDate(lind[0].GetDateData(hind_BirthDay),lBirth) then exit(null);
          laDate := lBirth;
          for i := 0 to lInd[0].SpouseCount-1 do
            begin
              if TryStrToDate(fmarr.GetDateData(lInd[0].Marriages[i],hmar_MarrChrchDay),lSecond) then
                if (laDate=lBirth) or (laDate> lSecond) then
                   laDate:=lSecond;
              if TryStrToDate(fmarr.GetDateData(lInd[0].Marriages[i],hmar_MarrStateDay),lSecond) then
                if (laDate=lBirth) or (laDate> lSecond) then
                   laDate:=lSecond;
            end;
          if laDate > lBirth then
            result := YearsBetween(lBirth,lSecond)
          else
            result := null;

       end;
       hInMeD_AgeOfFirstChild: begin
          if lind[0].ChildCount=0 then exit(null);
          if not TryStrToDate(lind[0].GetDateData(hind_BirthDay),lBirth) then exit(null);
          laDate := lBirth;
          for i := 0 to lInd[0].ChildCount-1 do
            begin
              if TryStrToDate(FIndi.GetDateData(lInd[0].Children[i],hind_BirthDay),lSecond) then
                if (laDate=lBirth) or (laDate> lSecond) then
                   laDate:=lSecond;
              if TryStrToDate(FIndi.GetDateData(lInd[0].Children[i],hind_BaptDay),lSecond) then
                if (laDate=lBirth) or (laDate> lSecond) then
                   laDate:=lSecond;
            end;
          if laDate > lBirth then
            result := YearsBetween(lBirth,lSecond)
          else
            result := null;
       end;
       hInMeD_AgeOfLMarriage: begin
          if lind[0].SourceCount=0 then exit(null);
          if not TryStrToDate(lind[0].GetDateData(hind_BirthDay),lBirth) then exit(null);
          laDate := lBirth;
          for i := 0 to lInd[0].SpouseCount-1 do
            begin
              if TryStrToDate(fmarr.GetDateData(lInd[0].Marriages[i],hmar_MarrChrchDay),lSecond) then
                if  (laDate< lSecond) then
                   laDate:=lSecond;
              if TryStrToDate(fmarr.GetDateData(lInd[0].Marriages[i],hmar_MarrStateDay),lSecond) then
                if  (laDate< lSecond) then
                   laDate:=lSecond;
            end;
          if laDate > lBirth then
            result := YearsBetween(lBirth,lSecond)
          else
            result := null;
       end;
       hInMeD_AgeOfLChild: begin
          if lind[0].ChildCount=0 then exit(null);
          if not TryStrToDate(lind[0].GetDateData(hind_BirthDay),lBirth) then exit(null);
          laDate := lBirth;
          for i := 0 to lInd[0].ChildCount-1 do
            begin
              if TryStrToDate(FIndi.GetDateData(lInd[0].Children[i],hind_BirthDay),lSecond) then
                if  (laDate< lSecond) then
                   laDate:=lSecond;
              if TryStrToDate(FIndi.GetDateData(lInd[0].Children[i],hind_BaptDay),lSecond) then
                if  (laDate< lSecond) then
                   laDate:=lSecond;
            end;
          if laDate > lBirth then
            result := YearsBetween(lBirth,lSecond)
          else
            result := null;
       end;
       hInMeD_AgeOfDeath: begin
       if not TryStrToDate(lind[0].GetDateData(hind_BirthDay),lBirth) then exit(null);
       TryStrToDate(lind[0].GetDateData(hind_DeathDay),lSecond);
       result := YearsBetween(lBirth,lSecond);
       end;
       hInMeD_AgeDiffToSpouse: ;
     end
   else if (length(lind) > 1) and (field >=99) and (field <199)  then
      begin
          result :=VarArrayCreate([0,high(lInd)],varVariant);
          for i:=0 to high(lInd) do
             result[i] := lInd[i].Data[TEnumHejIndDatafields(field-100)];
      end
    else
      result := null

end;

function TClsHejGenealogy.PeekInd(index: integer): THejIndData;
begin
  result:=findi.PeekInd[index];
end;

function TClsHejGenealogy.GetFather: THejIndData;
begin
  result:=Findi.PeekInd[FIndi.ActualInd.idFather];
end;

function TClsHejGenealogy.GetIndividual(index: integer): THejIndData;
begin
  result := FIndi.Individual[index];
end;

function TClsHejGenealogy.GetIndividualCount: integer;
begin
  result := FIndi.Count;
end;

function TClsHejGenealogy.GetMarriageData(idx: Integer): THejMarrData;
begin
  result := FMarr.Marriage[FIndi.ActualMarriage[idx]];
end;

function TClsHejGenealogy.GetMarriagesCount: integer;
begin
  result := FMarr.count;
end;

function TClsHejGenealogy.GetMother: THejIndData;
begin
  result:=Findi.PeekInd[FIndi.ActualInd.idMother];
end;

function TClsHejGenealogy.GetPlaceCount: integer;
begin
  result:=FPlac.Count;
end;

function TClsHejGenealogy.GetSourceCount: integer;
begin
   result:=FSour.Count;
end;

function TClsHejGenealogy.GetSpouse(idx: integer): THejIndData;
begin
  result:=Findi.PeekInd[FMarr.Marriage[FIndi.ActualMarriage[idx]].idSpouse];
end;

function TClsHejGenealogy.GetSpouseCount: integer;
begin
  result:=FIndi.ActualMarriageCount;
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

procedure TClsHejGenealogy.SetData(index: integer;
  Field: TEnumHejIndDatafields; AValue: variant);
begin
  Findi.SetData(index,Field,AValue);
end;

procedure TClsHejGenealogy.SetData(ind, index: integer;
  Field: TEnumHejMarrDatafields; AValue: variant);
begin
  if ind = -1 then
   ind:=GetActID;
  if index<length(FIndi.PeekInd[Ind].Marriages) then
      FMarr.SetData(FIndi.PeekInd[Ind].Marriages[index],Field,AValue);
end;

procedure TClsHejGenealogy.SetMarriageData(idx: Integer; AValue: THejMarrData);
begin
  FMarr.Marriage[FIndi.ActualMarriage[idx]]:=AValue;
end;

procedure TClsHejGenealogy.SetOnDataChange(AValue: TNotifyEvent);
begin
  if @FOnDataChange=@AValue then Exit;
  FOnDataChange:=AValue;
end;

procedure TClsHejGenealogy.SetOnStateChange(AValue: TNotifyEvent);
begin
  if @FOnStateChange=@AValue then Exit;
  FOnStateChange:=AValue;
end;

procedure TClsHejGenealogy.SetOnUpdate(AValue: TNotifyEvent);
begin
  if @FOnUpdate=@AValue then Exit;
  FOnUpdate:=AValue;
end;

function TClsHejGenealogy.GetCount: integer;
begin
  result := FIndi.Count;
end;

function TClsHejGenealogy.TestStreamHeader(st: Tstream): boolean;
begin
  result := FIndi.TestStreamHeader(st);
end;

function TClsHejGenealogy.IndexOf(Krit: variant): integer;
begin
  result := Findi.IndexOf(Krit);
end;

constructor TClsHejGenealogy.Create;
begin
  FIndi:= TClsHejIndividuals.Create;
  FMarr:= TClsHejMarriages.Create;
  FAdop:= TClsHejAdoptions.Create;
  FPlac:= TClsHejPlaces.Create;
  FSour:= TClsHejSources.Create;
end;

destructor TClsHejGenealogy.Destroy;
begin
  freeandnil(FSour);
  freeandnil(FPlac);
  freeandnil(FAdop);
  freeandnil(FMarr);
  freeandnil(FIndi);
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
  FMarr.ReadfromStream(st,FIndi);
  FAdop.ReadfromStream(st);
  FPlac.ReadfromStream(st);
  FSour.ReadfromStream(st);
  if Assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TClsHejGenealogy.LoadFromFile(Filename: String);
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
  lLastID: Integer;
begin
  lLastID := Findi.GetActID;
  FIndi.First;
  if Assigned(FOnUpdate) and (lLastID <> Findi.GetActID) then
    FOnUpdate(Self);
end;

procedure TClsHejGenealogy.Last(Sender: TObject);
var
  lLastID: Integer;
begin
  lLastID := Findi.GetActID;
  Findi.Last;
  if Assigned(FOnUpdate) and (lLastID <> Findi.GetActID) then
    FOnUpdate(Self);
end;

procedure TClsHejGenealogy.Next(Sender: TObject);
var
  lLastID: Integer;
begin
  lLastID := Findi.GetActID;
  Findi.next;
  if Assigned(FOnUpdate) and (lLastID <> Findi.GetActID) then
    FOnUpdate(Self);
end;

procedure TClsHejGenealogy.Previous(Sender: TObject);
var
  lLastID: Integer;
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
  if Assigned(FOnStateChange)  then
    FOnStateChange(Self);
end;

procedure TClsHejGenealogy.AppendLinkChild(idInd,idChild:integer);
begin
  FIndi.AppendLinkChild(idInd,idChild);
end;

procedure TClsHejGenealogy.AppendSpouse(Sender: TObject);
var
  lInd, lSpouse, lMarr1, lMarr2: Integer;
begin
  lInd:=Findi.GetActID;
  Findi.Append(Sender);
  lSpouse:=Findi.GetActID;
  Fmarr.Append(Sender);
  lMarr1:=Fmarr.GetActID;
  Fmarr.ActualMarrSetLink(lind,lSpouse);
  FIndi.AppendMarriage(Lind,FMarr.getActID);
  Fmarr.Append(Sender);
  Fmarr.ActualMarrSetLink(lSpouse,lInd);
  Fmarr.SetRevIdx(Lmarr1);
  FIndi.AppendMarriage(lSpouse,FMarr.getActID);
  if Assigned(FOnUpdate) then
     FOnUpdate(Self);
  if Assigned(FOnStateChange)  then
    FOnStateChange(Self);
end;

procedure TClsHejGenealogy.AppendParent(Knd: TEnumHejIndDatafields;
  Sender: TObject);
var
  lInd: Integer;
begin
  lInd:=Findi.GetActID;
  Findi.Append(Sender);
  case Knd of
    hind_idFather:
      begin
        Findi.SetData(lind,Knd,FIndi.GetActID);
        Findi.SetData(FIndi.GetActID,hind_Sex,'m');
        Findi.AppendLinkChild(Findi.GetActID,Lind);
      end;
    hind_idMother: begin
      Findi.SetData(lind,Knd,FIndi.GetActID);
      Findi.SetData(FIndi.GetActID,hind_Sex,'w');
      Findi.AppendLinkChild(Findi.GetActID,Lind);
      end
  else
  end;
  if Assigned(FOnUpdate) then
     FOnUpdate(Self);
  if Assigned(FOnStateChange)  then
    FOnStateChange(Self);
end;

procedure TClsHejGenealogy.AppendAdoption(idAdopter: integer);
begin
  FAdop.append;
  Fadop.Data[-1,hadop_idPerson]:=Findi.GetActID;
  if Findi.PeekInd[idAdopter].Sex='w' then
    Fadop.Data[-1,hadop_idMother]:=idAdopter
  else
    Fadop.Data[-1,hadop_idFather]:=idAdopter;
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
  if Assigned(FOnStateChange)  then
    FOnStateChange(Self);
end;

procedure TClsHejGenealogy.Post(Sender: TObject);
begin
  Findi.Post(Sender);
  if Assigned(FOnStateChange)  then
    FOnStateChange(Self);
end;

procedure TClsHejGenealogy.Seek(NewID: integer);
var
  lLastID: Integer;
begin
  lLastID := Findi.GetActID;
  if NewID>=0 then
    Findi.Seek(NewID)
  else
    case NewID of
      -1:Findi.seek(Findi.ActualInd.idFather);
      -2:Findi.seek(Findi.ActualInd.idMother);

    end;
  if Assigned(FOnUpdate) and (lLastID <> Findi.GetActID) then
    FOnUpdate(Self);
end;

procedure TClsHejGenealogy.GotoChild(IDCh: integer);
begin
  Seek(ActualInd.Children[idch-1]);
end;

procedure TClsHejGenealogy.GotoParent(Knd: TEnumHejIndDatafields);
begin
  case Knd of
    hind_idFather:seek(-1);
    hind_idMother:Seek(-2);
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
  if Assigned(FOnStateChange)  then
    FOnStateChange(Self);
end;

procedure TClsHejGenealogy.Delete(Sender: Tobject);
begin
  Findi.Delete(Sender);
  if Assigned(FOnUpdate) then
     FOnUpdate(Self);
end;

function TClsHejGenealogy.EOF: boolean;
begin
  result := FIndi.eof;
end;

function TClsHejGenealogy.BOF: boolean;
begin
  result := FIndi.bof;

end;

function TClsHejGenealogy.GetData: Variant;
begin

end;

procedure TClsHejGenealogy.SetData(NewVal: Variant);
begin

end;

function TClsHejGenealogy.GetActID: integer;
begin
  result := FIndi.GetActID;
end;

end.

