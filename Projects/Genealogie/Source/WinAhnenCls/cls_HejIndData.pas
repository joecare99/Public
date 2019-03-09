unit cls_HejIndData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,variants,db,Unt_IData,cls_HejBase;

type
  TEnumHejIndDatafields=(
    hind_ID = -1,
    hind_idFather =0,
    hind_idMother =1,
    hind_FamilyName=2,
    hind_GivenName=3,
    hind_Sex=4,
    hind_Religion=5,
    hind_Occupation=6,
    hind_BirthDay=7,
    hind_BirthMonth=8,
    hind_BirthYear=9,
    hind_Birthplace=10,
    hind_BaptDay=11,
    hind_BaptMonth=12,
    hind_BaptYear=13,
    hind_BaptPlace=14,
    hind_Godparents=15,
    hind_Residence=16,
    hind_DeathDay=17,
    hind_DeathMonth=18,
    hind_DeathYear=19,
    hind_DeathPlace=20,
    hind_DeathReason=21,
    hind_BurialDay=22,
    hind_BurialMonth=23,
    hind_BurialYear=24,
    hind_BurialPlace=25,
    hind_BirthSource=26,
    hind_BaptSource=27,
    hind_DeathSource=28,
    hind_BurialSource=29,
    hind_Text=30,
    hind_Living=31,
    hind_AKA=32,
    hind_Index=33,
    hind_Adopted=34,
    hind_FarmName=35,
    hind_AdrStreet=36,
    hind_AdrAddit=37,
    hind_AdrPLZ=38,
    hind_AdrPlace=39,
    hind_AdrPlaceAdd=40,
    hind_Free1=41,
    hind_Free2=42,
    hind_Free3=43,
    hind_Age=44,
    hind_Phone=45,
    hind_eMail=46,
    hind_WebAdr=47,
    hind_NameSource=48,
    hind_CallName=49);

  TIndFieldSet=set of byte;

const
  CHejIndDataDesc:array[TEnumHejIndDatafields]of string=
    ('ID',
    'idFather',
    'idMother',
    'FamilyName',
    'GivenName',
    'Sex',
    'Religion',
    'Occupation',
    'BirthDay',
    'BirthMonth',
    'BirthYear',
    'Birthplace',
    'BaptDay',
    'BaptMonth',
    'BaptYear',
    'BaptPlace',
    'Godparents',
    'Residence',
    'DeathDay',
    'DeathMonth',
    'DeathYear',
    'DeathPlace',
    'DeathReason',
    'BurialDay',
    'BurialMonth',
    'BurialYear',
    'BurialPlace',
    'BirthSource',
    'BaptSource',
    'DeathSource',
    'BurialSource',
    'Text',
    'Living',
    'AKA',
    'Index',
    'Adopted',
    'FarmName',
    'AdrStreet',
    'AdrAddit',
    'AdrPLZ',
    'AdrPlace',
    'AdrPlaceAdd',
    'Free1',
    'Free2',
    'Free3',
    'Age',
    'Phone',
    'eMail',
    'WebAdr',
    'NameSource',
    'CallName');

  CIndSourceData  =
    [hind_BaptSource, hind_BirthSource, hind_BurialSource, hind_DeathSource, hind_NameSource];

  CIndPlacedata  =
    [hind_AdrPlace, hind_BaptPlace, hind_Birthplace, hind_DeathPlace, hind_BurialPlace, hind_Residence];

  CIndDatedata  =
    [hind_BirthDay, hind_BaptDay,  hind_DeathDay, hind_BurialDay];
type


 PHejIndData = ^THejIndData;

 { THejIndData }

 THejIndData = packed record
private
  function GetData(idx: TEnumHejIndDatafields): Variant;
  procedure ReadFromStream0(const st: TStream);
  procedure SetData(idx: TEnumHejIndDatafields; AValue: Variant);
public
  function ToString:String;
  function ToPasStruct:String;
  function ParentCount:integer;
  function ChildCount:integer;
  Procedure RemoveParent(aID:integer);
  Procedure AppendChild(aID:integer);
  Procedure RemoveChild(aID:integer);
  Procedure DeleteChild(idx:integer);
  Procedure AppendMarriage(amID:integer);
  Procedure RemoveMarriage(amID:integer);
  Procedure DeleteMarriage(Idx:integer);
  function SpouseCount:integer;
  function PlaceCount:integer;
  function SourceCount:integer;
  Function GetValue:double;
  function GetDateData(idx: TEnumHejIndDatafields): string;
  Procedure Clear;
  Procedure ReadFromStream(const st:TStream);
  Procedure WriteToStream(const st:TStream);
  Procedure ReadFromDataset(idx:integer;const ds:TDataSet);
  Procedure UpdateDataset(const ds:TDataSet);
  function Equals(aValue:THejIndData;OnlyData:boolean=False):boolean;
    property Data[idx:TEnumHejIndDatafields]:Variant read GetData write SetData;
 public
       ID,
       idFather,
       idMother:integer;
       FamilyName,
       GivenName,
       Sex,
       Religion,
       Occupation,
       BirthDay,
       BirthMonth,
       BirthYear,
       Birthplace,
       BaptDay,
       BaptMonth,
       BaptYear,
       BaptPlace,
       Godparents,
       Residence,
       DeathDay,
       DeathMonth,
       DeathYear,
       DeathPlace,
       DeathReason,
       BurialDay,
       BurialMonth,
       BurialYear,
       BurialPlace,
       BirthSource,
       BaptSource,
       DeathSource,
       BurialSource,
       Text,
       Living,
       AKA,
       Index,
       Adopted,
       FarmName,
       AdrStreet,
       AdrAddit,
       AdrPLZ,
       AdrPlace,
       AdrPlaceAdd,
       Free1,
       Free2,
       Free3,
       Age,
       Phone,
       eMail,
       WebAdr,
       NameSource,
       CallName:string;
       Marriages:array of Integer;
       Children:array of Integer;
 end;

 { TClsHejIndividuals }

 TClsHejIndividuals=class(TClsHejBase,IData)
 private
    FIndArray:array of THejIndData;
    FActIndex:integer;
    function GetActualChild(index: integer): integer;
    function GetActualChildCount: integer;
    function GetActualInd: THejIndData;
    function GetActualMarriage(index: integer): integer;
    function GetActualMarriageCount: integer;
    function GetData(ind: integer; idx: TEnumHejIndDatafields): variant;
    function GetIndividual(index: integer): THejIndData;
    function GetPeekIndi(index: integer): THejIndData;
    procedure SetActualChild(index: integer; AValue: integer);
    procedure SetActualInd(AValue: THejIndData);
    procedure SetActualMarriage(index: integer; AValue: integer);
 protected
    function GetCount: integer;override;
 public
   procedure AppendLinkChild( const idInd: Integer;const idChild: Integer);
   procedure SetData(ind: integer; idx: TEnumHejIndDatafields; AValue: variant
     );overload;
   Function GetDateData(ind:integer; idx: TEnumHejIndDatafields):string;
    Property Individual[index:integer]:THejIndData read GetIndividual;
    Property PeekInd[index:integer]:THejIndData read GetPeekIndi;
    Property ActualInd:THejIndData read GetActualInd write SetActualInd;
    Property ActualChild[index:integer]:integer read GetActualChild write SetActualChild;
    Property ActualChildCount:integer read GetActualChildCount;
    Property ActualMarriage[index:integer]:integer read GetActualMarriage write SetActualMarriage;
    Property ActualMarriageCount:integer read GetActualMarriageCount;
    Property Data[ind:integer;idx:TEnumHejIndDatafields]:variant read GetData write SetData;default;
 public  // inherited Methods
    Function TestStreamHeader(st:Tstream):boolean;override;
    function IndexOf(Krit: variant): integer; override;
    Procedure Clear;override;
    procedure ReadfromStream(st:Tstream;{%H-}cls:TClsHejBase=nil);override;
    PRocedure WriteToStream(st:TStream);override;
    Procedure ReadFromDataset(const ds:TDataSet;{%H-}cls:TClsHejBase=nil);override;
    Procedure UpdateDataset(const ds:TDataSet);override;
    Procedure AppendMarriage(Ind,marr:integer);
    Destructor Destroy; override;
 public // IData
    Procedure First(Sender:TObject=nil);
    Procedure Last(Sender:TObject=nil);
    Procedure Next(Sender:TObject=nil);
    Procedure Previous(Sender:TObject=nil);
    Procedure Append(Sender:TObject=nil);
    Procedure Edit(Sender:TObject=nil);
    Procedure Post(Sender:TObject=nil);
    Procedure Seek(idInd:integer);
    Procedure Cancel(Sender:TObject=nil);
    procedure Delete(Sender: Tobject);
    Function GetData:Variant;overload;
    procedure SetData(NewVal: Variant);overload;
    function EOF: boolean;
    Function BOF: boolean;
    Function GetActID: integer;
 end;

implementation

uses dateutils,LConvEncoding,dm_GenData2;

{ TClsHejIndividuals }

procedure TClsHejIndividuals.SetActualInd(AValue: THejIndData);
begin
  if FIndArray[FActIndex].Equals(AValue) then Exit;
  AValue.id:=FIndArray[FActIndex].id;
  AValue.idFather:=FIndArray[FActIndex].idFather;
  AValue.idMother:=FIndArray[FActIndex].idMother;
  AValue.Marriages:=FIndArray[FActIndex].Marriages;
  AValue.Children:=FIndArray[FActIndex].Children;
    FIndArray[FActIndex]:=AValue;
end;

procedure TClsHejIndividuals.SetActualMarriage(index: integer; AValue: integer);
begin
   //Todo: Has to be implemented
  if index = -1 then // Append
    FIndArray[FActIndex].AppendMarriage(AValue)
  else if (index<=high(FIndArray[FActIndex].Marriages)) and (AValue  >-1) then // Set
    FIndArray[FActIndex].Marriages[index]:=AValue
  else // Delete
    FIndArray[FActIndex].RemoveMarriage(index);
end;

procedure TClsHejIndividuals.SetData(ind: integer; idx: TEnumHejIndDatafields;
  AValue: variant);

begin
  if Ind = -1 then
    ind := FActIndex;
  if (ind >0) and (ind <= high(FIndArray)) then
    FIndArray[ind].Data[idx] := AValue;
end;

function TClsHejIndividuals.GetDateData(ind: integer; idx: TEnumHejIndDatafields
  ): string;
begin
  if Ind = -1 then
    ind := FActIndex;
  if (ind >0) and (ind <= high(FIndArray)) then
    result := FIndArray[ind].GetDateData(idx);
end;

procedure TClsHejIndividuals.AppendMarriage(Ind, marr: integer);
begin
  if (ind > 0)
        and (ind <= high(FIndArray)) then
          begin
  setlength(FIndArray[Ind].Marriages,high(FIndArray[Ind].Marriages)+2);
  FIndArray[Ind].Marriages[high(FIndArray[Ind].Marriages)]:=marr;
          end;
end;

procedure TClsHejIndividuals.Clear;
begin
  setlength(FIndArray,0);
  FActIndex:=-1;
end;

procedure TClsHejIndividuals.ReadfromStream(st: Tstream; cls: TClsHejBase);

const cDSIncr=100;
var
  by: Byte;
  lIndCount, lPID, i: Integer;
  lInd:THejIndData;

begin
  lIndCount := 0;
  repeat
  by:=st.ReadByte;
  st.Seek(-1,soCurrent);
  if by in [49..57] then
    begin
      lInd.ReadFromStream(st);
      while lIndCount<lind.ID do
        begin
          inc (lIndcount);
          if lIndCount>=length(FIndArray) then
            setlength(FIndArray,length(FIndArray)+cDSIncr);
        end;
      FIndArray[lIndCount]:=lInd;
    end;
  until not(by in [49..57]);
  FActIndex:=1;
  setlength(FIndArray,lIndCount+1);
  // Build - Child-Index
  for i := 1 to lIndCount do
    begin
      if (FIndArray[i].idFather > 0)
        and (FIndArray[i].idFather <= lIndCount)
        and (FIndArray[i].idFather <> i) then
        begin
          lPID:=FIndArray[i].idFather;
          AppendLinkChild(lPID, i);
        end;
      if (FIndArray[i].idMother > 0)
        and (FIndArray[i].idMother <= lIndCount)
        and (FIndArray[i].idMother <> i) then
        begin
          lPID:=FIndArray[i].idMother;
          AppendLinkChild(lPID, i);
        end;

    end;
end;

procedure TClsHejIndividuals.WriteToStream(st: TStream);
var
  i: Integer;
begin
  for i := 1 to high(FIndArray) do
    FIndArray[i].WriteToStream(st);
end;

procedure TClsHejIndividuals.ReadFromDataset(const ds: TDataSet;
  cls: TClsHejBase);
begin
  ds.First;
  while not ds.EOF do
     begin
       Append;
       FIndArray[FActIndex].ReadFromDataset(FActIndex,ds);
       next;
     end;
end;

procedure TClsHejIndividuals.UpdateDataset(const ds: TDataSet);
begin

end;

destructor TClsHejIndividuals.Destroy;
begin
  setlength(FIndArray,0);
  inherited Destroy;
end;

procedure TClsHejIndividuals.First(Sender: TObject);
begin
  FActIndex:=1;
end;

procedure TClsHejIndividuals.Last(Sender: TObject);
begin
  FActIndex:=high(FIndArray);
end;

procedure TClsHejIndividuals.Next(Sender: TObject);
begin
  if FActIndex < high(FIndArray) then
    inc(FActIndex);
end;

procedure TClsHejIndividuals.Previous(Sender: TObject);
begin
  if FActIndex > 1 then
    dec(FActIndex);
end;

procedure TClsHejIndividuals.Append(Sender: TObject);
begin
  if High(FIndArray) = -1 then
    Setlength(FIndArray,High(FIndArray)+3) // !!
    else
  Setlength(FIndArray,High(FIndArray)+2);
  FActIndex := high(FIndArray);
  FIndArray[FActIndex].ID:=FActIndex;
end;

procedure TClsHejIndividuals.Edit(Sender: TObject);
begin

end;

procedure TClsHejIndividuals.Post(Sender: TObject);
begin

end;

procedure TClsHejIndividuals.Seek(idInd: integer);
begin
  if (idInd <> FActIndex) and (idInd >=0) and (idInd <= high(FIndArray)) then
    FActIndex:=idInd;
end;

procedure TClsHejIndividuals.Cancel(Sender: TObject);
begin

end;

procedure TClsHejIndividuals.Delete(Sender: Tobject);
var
  i: Integer;
begin
  FIndArray[FActIndex].id := 0;
// Löse verbindungen zu Vater und Mutter
  if FIndArray[FActIndex].idFather >0 then
    FIndArray[FIndArray[FActIndex].idFather].RemoveChild(FActIndex);
  if FIndArray[FActIndex].idMother >0 then
    FIndArray[FIndArray[FActIndex].idMother].RemoveChild(FActIndex);
// Löse Verbindungen zu evtl.Kindern
  for i := 0 to high(FIndArray[FActIndex].Children) do
    FIndArray[FIndArray[FActIndex].Children[i]].RemoveParent(FActIndex);
// Lösche Daten
  FIndArray[FActIndex].Clear;
end;

function TClsHejIndividuals.EOF: boolean;
begin
  result := FactIndex>High(FIndArray)
end;

function TClsHejIndividuals.BOF: boolean;
begin
  result := FActIndex<=1;
end;

function TClsHejIndividuals.GetData: Variant;overload;
begin
  result := null // Todo: Sinnvoll ergänzen
end;

procedure TClsHejIndividuals.SetData(NewVal: Variant);overload;
begin

end;

function TClsHejIndividuals.GetActID: integer;
begin
  result := FActIndex;
end;

function TClsHejIndividuals.GetActualInd: THejIndData;
begin
  result := FIndArray[FActIndex];
end;

function TClsHejIndividuals.GetActualChild(index: integer): integer;
begin
  result:= ActualInd.Children[index];
end;

function TClsHejIndividuals.GetActualChildCount: integer;
begin
  result := length( ActualInd.Children)
end;

function TClsHejIndividuals.GetActualMarriage(index: integer): integer;
begin
  result:= ActualInd.Marriages[index];
end;

function TClsHejIndividuals.GetActualMarriageCount: integer;
begin
  result := length( ActualInd.Marriages)
end;

function TClsHejIndividuals.GetData(ind: integer; idx: TEnumHejIndDatafields
  ): variant;
begin
  if ind=-1 then
    ind := FActIndex;
  if (ind >= 0) and (ind <= high(FIndArray)) then
    result := FIndArray[ind].Data[idx];
end;

function TClsHejIndividuals.GetIndividual(index: integer): THejIndData;
begin
  Seek(index);
  if FActIndex = index then
    result := FIndArray[index];
end;

function TClsHejIndividuals.GetCount: integer;
begin
  result := high(FIndArray);//!! 0 wird nicht gezählt.
  if result <0 then result :=0;
end;

procedure TClsHejIndividuals.AppendLinkChild(const idInd: Integer;
  const idChild: Integer);
begin
  setlength(FIndArray[idInd].Children, high(FIndArray[idInd].Children)+2);
  FIndArray[idInd].Children[high(FIndArray[idInd].Children)]:=idChild;
  if FIndArray[idInd].Sex = 'w' then
    begin
    if FIndArray[idChild].idMother = 0 then
      FIndArray[idChild].idMother:= idInd;
    end
  else
  if FIndArray[idChild].idFather = 0 then
    FIndArray[idChild].idFather:= idInd;
end;

function TClsHejIndividuals.TestStreamHeader(st: Tstream): boolean;
begin
  result := true;
end;

function TClsHejIndividuals.IndexOf(Krit: variant): integer;

var
  lSuchName: String;
  lYear, lMonth, lDay: String;
  i: Integer;
  lCPos: SizeInt;
  lDate: Boolean;
begin
  result :=0;
  if VarIsArray(Krit) then
    begin
      // Todo:
      lSuchName :='';
      lDate:=false;
      lCPos:=0;
      for i := 0 to VarArrayHighBound(krit,1) do
        if VarType(krit[i])=vardate then
          begin
          lYear := inttostr(Yearof(TDateTime(Krit[i])));
          lMonth := inttostr(MonthOf(TDateTime(Krit[i])));
          lDay := inttostr(DayOf(TDateTime(Krit[i])));
          lDate:=true;
          end
        else if VarIsStr(krit[i]) then
          begin
            if lSuchName<>'' then
              lSuchName :=lSuchname+', '+ LowerCase(Krit[i])
            else
              lSuchName :=LowerCase(Krit[i]);
            lCPos := pos(',',lSuchName);
          end;
      if ldate and (lSuchName = '') then
        begin
           if lDay = '1' then
        begin
        for i := 1 to high(FIndArray) do
          if (FIndArray[i].BirthYear = lYear) and
            ((FIndArray[i].BirthMonth = lMonth) or
            (FIndArray[i].BirthMonth = '0'+lMonth)) then
            exit(i)
        end
        else
        for i := 1 to high(FIndArray) do
          if (FIndArray[i].BirthYear = lYear) and
            ((FIndArray[i].BirthMonth = lMonth) or
            (FIndArray[i].BirthMonth = '0'+lMonth)) and
            (FIndArray[i].BirthDay = lDay) then
            exit(i)
      end
      else
      if lcpos=0 then
      begin
      for i := 1 to high(FIndArray) do
        if (lowercase(FIndArray[i].FamilyName) = lSuchName) and
          (not ldate or ((FIndArray[i].BirthYear = lYear) and
            ((FIndArray[i].BirthMonth = lMonth) or
            (FIndArray[i].BirthMonth = '0'+lMonth)) and
            ((FIndArray[i].BirthDay = lDay) or
             (FIndArray[i].BirthDay = '0'+lDay) or
             (lDay = '1')))) then
          exit(i)
      end
      else
      for i := 1 to high(FIndArray) do
        if (lowercase(FIndArray[i].FamilyName + ', '+FIndArray[i].GivenName) = lSuchName) and
          (not ldate or ((FIndArray[i].BirthYear = lYear) and
            ((FIndArray[i].BirthMonth = lMonth) or
            (FIndArray[i].BirthMonth = '0'+lMonth)) and
            ((FIndArray[i].BirthDay = lDay) or
             (FIndArray[i].BirthDay = '0'+lDay) or
             (lDay = '1')))) then
          exit(i)
    end
  else if Vartype(Krit)=vardate then
    begin
      // (Geburts-)Datums-Abfrage
      // Todo: Datums-index
      lYear := inttostr(Yearof(TDateTime(Krit)));
      lMonth := inttostr(MonthOf(TDateTime(Krit)));
      lDay := inttostr(DayOf(TDateTime(Krit)));
      if lDay = '1' then
        begin
        for i := 1 to high(FIndArray) do
          if (FIndArray[i].BirthYear = lYear) and
            ((FIndArray[i].BirthMonth = lMonth) or
            (FIndArray[i].BirthMonth = '0'+lMonth)) then
            exit(i)
        end
        else
        for i := 1 to high(FIndArray) do
          if (FIndArray[i].BirthYear = lYear) and
            ((FIndArray[i].BirthMonth = lMonth) or
            (FIndArray[i].BirthMonth = '0'+lMonth)) and
            (FIndArray[i].BirthDay = lDay) then
            exit(i)
    end
  else if VarIsNumeric(Krit) then
    begin
      if Krit = -1 then
      result := FActIndex
      else
        result := Krit;
    end
  else if VarIsStr(Krit) then
    begin
      // Nachname, Vorname
      // SoundEx ?
      // Todo: Namen-index
      lCPos := pos(',',Krit);
      lSuchName := LowerCase(Krit);
      if lcpos=0 then
      begin
      for i := 1 to high(FIndArray) do
        if lowercase(FIndArray[i].FamilyName) = lSuchName then
          exit(i)
      end
      else
      for i := 1 to high(FIndArray) do
        if lowercase(FIndArray[i].FamilyName + ', '+FIndArray[i].GivenName) = lSuchName then
          exit(i)
    end
end;

function TClsHejIndividuals.GetPeekIndi(index: integer): THejIndData;
begin
  if index=-1 then
    index:= FActIndex;
   if  (index >=0) and (index <= high(FIndArray)) then
     result := FIndArray[index];
end;

procedure TClsHejIndividuals.SetActualChild(index: integer; AValue: integer);
var pActInd:^THejIndData;

begin
  pActInd:=@FIndArray[FActIndex];
  if AValue = 0 then
    begin
// Delete Child
        if pActInd.Sex = 'm' then
          Data[pActInd.Children[index],hind_idFather]:=0
        else
          Data[pActInd.Children[index],hind_idMother]:=0;
      pActInd.Children[index]:=pActInd.Children[High(pActInd.Children)];
      setlength(pActInd.Children,High(pActInd.Children));
    end
  else
// Append/Set Child
    if index = -1 then
      begin
      //Todo:
      end
    else
      begin
        //Remove old Child
        if pActInd.Sex = 'm' then
          Data[pActInd.Children[index],hind_idFather]:=0
        else
          Data[pActInd.Children[index],hind_idMother]:=0;
        pActInd.Children[index] := AValue;
        if pActInd.Sex = 'm' then
          Data[AValue,hind_idFather] :=pActInd^.ID
        else
          Data[AValue,hind_idMother] :=pActInd^.ID;
      end;
end;

{ TClsHejIndData }

function THejIndData.GetData(idx: TEnumHejIndDatafields): Variant;
begin

  case idx of
    hind_ID: Result := ID ;
    hind_idFather: Result := idFather ;
    hind_idMother: Result := idMother ;
    hind_FamilyName: Result := FamilyName ;
    hind_GivenName: Result := GivenName ;
    hind_Sex: Result := Sex ;
    hind_Religion: Result := Religion ;
    hind_Occupation: Result := Occupation ;
    hind_BirthDay: Result := BirthDay ;
    hind_BirthMonth: Result := BirthMonth ;
    hind_BirthYear: Result := BirthYear ;
    hind_Birthplace: Result := Birthplace ;
    hind_BaptDay: Result := BaptDay ;
    hind_BaptMonth: Result := BaptMonth ;
    hind_BaptYear: Result := BaptYear ;
    hind_BaptPlace: Result := BaptPlace ;
    hind_Godparents: Result := Godparents ;
    hind_Residence: Result := Residence ;
    hind_DeathDay: Result := DeathDay ;
    hind_DeathMonth: Result := DeathMonth ;
    hind_DeathYear: Result := DeathYear ;
    hind_DeathPlace: Result := DeathPlace ;
    hind_DeathReason: Result := DeathReason ;
    hind_BurialDay: Result := BurialDay ;
    hind_BurialMonth: Result := BurialMonth ;
    hind_BurialYear: Result := BurialYear ;
    hind_BurialPlace: Result := BurialPlace ;
    hind_BirthSource: Result := BirthSource ;
    hind_BaptSource: Result := BaptSource ;
    hind_DeathSource: Result := DeathSource ;
    hind_BurialSource: Result := BurialSource ;
    hind_Text: Result := Text ;
    hind_Living: Result := Living ;
    hind_AKA: Result := AKA ;
    hind_Index: Result := Index ;
    hind_Adopted: Result := Adopted ;
    hind_FarmName: Result := FarmName ;
    hind_AdrStreet: Result := AdrStreet ;
    hind_AdrAddit: Result := AdrAddit ;
    hind_AdrPLZ: Result := AdrPLZ ;
    hind_AdrPlace: Result := AdrPlace ;
    hind_AdrPlaceAdd: Result := AdrPlaceAdd ;
    hind_Free1: Result :=Free1;
    hind_Free2: Result :=Free2;
    hind_Free3: Result :=Free3;
    hind_Age: Result := Age ;
    hind_Phone: Result := Phone ;
    hind_eMail: Result := eMail ;
    hind_WebAdr: Result := WebAdr ;
    hind_NameSource: Result := NameSource ;
    hind_CallName: Result := CallName ;
  else
    result := Null;
  end;
end;

procedure THejIndData.SetData(idx: TEnumHejIndDatafields; AValue: Variant);
begin
    case idx of
      hind_ID: ID := AValue ;
      hind_idFather: idFather := AValue ;
      hind_idMother: idMother := AValue ;
      hind_FamilyName: FamilyName := AValue ;
      hind_GivenName: GivenName := AValue ;
      hind_Sex: Sex := AValue ;
      hind_Religion: Religion := AValue ;
      hind_Occupation: Occupation := AValue ;
      hind_BirthDay: BirthDay := AValue ;
      hind_BirthMonth: BirthMonth := AValue ;
      hind_BirthYear: BirthYear := AValue ;
      hind_Birthplace: Birthplace := AValue ;
      hind_BaptDay: BaptDay := AValue ;
      hind_BaptMonth: BaptMonth := AValue ;
      hind_BaptYear: BaptYear := AValue ;
      hind_BaptPlace: BaptPlace := AValue ;
      hind_Godparents: Godparents := AValue ;
      hind_Residence: Residence := AValue ;
      hind_DeathDay: DeathDay := AValue ;
      hind_DeathMonth: DeathMonth := AValue ;
      hind_DeathYear: DeathYear := AValue ;
      hind_DeathPlace: DeathPlace := AValue ;
      hind_DeathReason: DeathReason := AValue ;
      hind_BurialDay: BurialDay := AValue ;
      hind_BurialMonth: BurialMonth := AValue ;
      hind_BurialYear: BurialYear := AValue ;
      hind_BurialPlace: BurialPlace := AValue ;
      hind_BirthSource: BirthSource := AValue ;
      hind_BaptSource: BaptSource := AValue ;
      hind_DeathSource: DeathSource := AValue ;
      hind_BurialSource: BurialSource := AValue ;
      hind_Text: Text := AValue ;
      hind_Living: Living := AValue ;
      hind_AKA: AKA := AValue ;
      hind_Index: Index := AValue ;
      hind_Adopted: Adopted := AValue ;
      hind_FarmName: FarmName := AValue ;
      hind_AdrStreet: AdrStreet := AValue ;
      hind_AdrAddit: AdrAddit := AValue ;
      hind_AdrPLZ: AdrPLZ := AValue ;
      hind_AdrPlace: AdrPlace := AValue ;
      hind_AdrPlaceAdd: AdrPlaceAdd := AValue ;
      hind_Free1: Free1:=AValue;
      hind_Free2: Free2:=AValue;
      hind_Free3: Free3:=AValue;
      hind_Age: Age := AValue ;
      hind_Phone: Phone := AValue ;
      hind_eMail: eMail := AValue ;
      hind_WebAdr: WebAdr := AValue ;
      hind_NameSource: NameSource := AValue ;
      hind_CallName: CallName := AValue ;
    end;
end;

function THejIndData.ToString: String;
begin
   Result := FamilyName +', '+ GivenName+ ' (';
   if  BirthDay+BirthMonth+BirthYear <> '' then
     Result := result +' *'+BirthDay+'.'+BirthMonth+'.'+BirthYear;
   if  DeathDay+DeathMonth+DeathYear <> '' then
     Result := result +' +'+DeathDay+'.'+DeathMonth+'.'+DeathYear;
   Result := result + ')';
   if Residence <> '' then
     Result := result +' in '+Residence;
end;

function THejIndData.ToPasStruct: String;
var
  lFld: TEnumHejIndDatafields;
begin
  result := '(';
  for lFld in TEnumHejIndDatafields do
    begin
      if  lFld <> hind_ID then
        result := result+';';
     if lFld <=hind_idMother then
       result :=result+ CHejIndDataDesc[lFld]+':'+inttostr(Data[lFld])
     else
       result :=result+ CHejIndDataDesc[lFld]+':'''+Data[lFld]+''''
    end;
  result := result+'{%H-})';
end;

function THejIndData.ParentCount: integer;
begin
    if (abs(idFather)+abs(idMother) = 0)
             then result :=0
             else if (idFather > 0) and (idMother > 0)
             then result := 2
             else result := 1;
end;

function THejIndData.ChildCount: integer;
begin
  result := length(Children);
end;

procedure THejIndData.RemoveParent(aID: integer);
begin
  if idFather = aID then
    idFather:=0;
  if idMother = aID then
    idMother:=0;
end;

procedure THejIndData.AppendChild(aID: integer);
var
  i: Integer;
begin
  for i := 0 to high(Children) do
    if (Children[i] = aID)  then
      exit;
  setlength(Children,high(Children)+2);
  Children[high(Children)]:=aID;
end;

procedure THejIndData.RemoveChild(aID: integer);
var
  lCIx, i: Integer;
begin
  lCIx:=-1;
  for i := 0 to high(Children) do
    if (Children[i] = aID) or (lCIx>-1) then
      begin
        lCIx:=i;
        if i < high(Children) then
            Children[i] := Children[i+1];
      end;
  if lCIx >-1 then
    setlength(Children,high(Children));
end;

procedure THejIndData.DeleteChild(idx: integer);
var
  i: Integer;
begin
  for i := idx to high(Children) do
     if i < high(Children) then
        Children[i] := Children[i+1];
  if idx <= High(Children) then
    setlength(Children,high(Children));
end;

procedure THejIndData.AppendMarriage(amID: integer);
var
  i: Integer;
begin
  for i := 0 to high(Marriages) do
    if (Marriages[i] = amID)  then
      exit;
  setlength(Marriages,Length(Marriages)+1);
  Marriages[high(Marriages)]:=amID;
end;

procedure THejIndData.RemoveMarriage(amID: integer);
var
  lMIx, i: Integer;
begin
  lMIx:=-1;
  for i := 0 to high(Marriages) do
    if (Marriages[i] = amID) or (lMIx>-1) then
      begin
        lMIx:=i;
        if i < high(Marriages) then
            Marriages[i] := Marriages[i+1];
      end;
  if lMIx >-1 then
    setlength(Marriages,high(Marriages));
end;

procedure THejIndData.DeleteMarriage(Idx: integer);
var
  i: Integer;
begin
  for i := idx to high(Marriages) do
     if i < high(Marriages) then
        Marriages[i] := Marriages[i+1];
  if idx <= High(Marriages) then
    setlength(Marriages,high(Marriages));
end;

function THejIndData.SpouseCount: integer;
begin
  result := length(Marriages);
end;

function THejIndData.PlaceCount: integer;
var lIdf :TEnumHejIndDatafields;
begin
  result :=0;
for lIdf in CIndPlacedata do
if Data[lIdf] <> '' then
   result := result+ 1;
end;

function THejIndData.SourceCount: integer;
var lIdf :TEnumHejIndDatafields;
begin
  result :=0;
for lIdf in CIndSourceData do
if Data[lIdf] <> '' then
   result := result+ 1;
end;

function THejIndData.GetValue: double;
var
  lDate: TDateTime;
begin
  result := -1e-10;
  if TryStrToDate(GetDateData(hind_BirthDay),lDate) then
    exit(lDate)
  else
    if TryStrToDate(GetDateData(hind_BaptDay),lDate) then
      exit(lDate)
end;

function THejIndData.GetDateData(idx: TEnumHejIndDatafields): string;
begin
  result := HejDate2DateStr(data[idx],
  Data[TEnumHejIndDatafields(ord(idx)+1)],
  Data[TEnumHejIndDatafields(ord(idx)+2)]);
end;

procedure THejIndData.Clear;
var
  I: TEnumHejIndDatafields;
begin
    for I in TEnumHejIndDatafields do
      if ord(I) <=  ord(hind_idMother) then
        Data[I]:=0
      else
        Data[I]:='';
    setlength(Children,0);
    SetLength(Marriages,0);
end;


// Buffered Read from Stream
procedure THejIndData.ReadFromStream0(const st: TStream);
var
  by: Byte;
  lAktField, lBtr: Integer;
  lLine,lActStr: String;
  ep: SizeInt;
begin
  by := 0 ;
  lAktField :=-1;
  lActStr := '';
  lBtr := 512;
  if  st.Size-st.Position < lBtr then
    lbtr := st.Size-st.Position;
  setlength(lLine,lBtr);
  st.ReadBuffer(lLine[1],lBtr);
  if st.Size<=st.Position then
    ep:= lbtr+1
  else
    ep:= pos(#13#10,lLine);
  if ep<>0 then
    begin
      setlength(lLine,ep-1);
      st.Seek(ep+1-lBtr,soCurrent);
    end
  else
    exit;
  while (by <> 10) and (st.Position <st.Size) do
     begin
       by := st.ReadByte;
       if by >=32 then
          lActStr := lActStr+char(by)
       else
         if by in [10,15] then
           begin
             data[TEnumHejIndDatafields(lAktField)] := ConvertEncoding(lActStr,EncodingAnsi,EncodingUTF8);
             if by = 15 then
               begin
                 inc(lAktField);
                 // Sonderfall textfeld
                 if lAktField = ord(hind_Text) then
                   begin
                     data[TEnumHejIndDatafields(lAktField)] :='';
                     inc(lAktField);
                   end;
               end;
             lActStr:='';
           end
        else if by=16 then
          if (Length(lActStr)=0) and ( lAktField = ord(hind_Living)) then
            dec(lAktField)
          else
            lActStr:=lActStr+LineEnding;

     end;
end;

procedure THejIndData.ReadFromStream(const st: TStream);
var
  by: Byte;
  lAktField: Integer;
  lActStr: String;

begin
  by := 0 ;
  lAktField :=-1;
  lActStr := '';
  while (by <> 10) and (st.Position <st.Size) do
     begin
       by := st.ReadByte;
       if by >=32 then
          lActStr := lActStr+char(by)
       else
         if by in [10,15] then
           begin
             data[TEnumHejIndDatafields(lAktField)] := ConvertEncoding(lActStr,EncodingAnsi,EncodingUTF8);
             if by = 15 then
               begin
                 inc(lAktField);
                 // Sonderfall textfeld
                 if lAktField = ord(hind_Text) then
                   begin
                     data[TEnumHejIndDatafields(lAktField)] :='';
                     inc(lAktField);
                   end;
               end;
             lActStr:='';
           end
        else if by=16 then
          if (Length(lActStr)=0) and ( lAktField = ord(hind_Living)) then
            dec(lAktField)
          else
            lActStr:=lActStr+LineEnding;

     end;
end;

procedure THejIndData.WriteToStream(const st: TStream);
var
  lActStr: String;
  lAktfield: TEnumHejIndDatafields;

begin
  if ID=0 then
    exit; // Leerer Datensatz wird nicht geschrieben
  for lAktfield in TEnumHejIndDatafields do
     begin
       lActStr := ConvertEncoding(data[lAktField],EncodingUTF8,EncodingAnsi);
       lActStr :=StringReplace(lActStr,#15,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,#16,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,LineEnding,#16,[rfReplaceAll]);
       if (lAktField <> hind_ID) and
         ((lAktField <> hind_Text) Or (lActStr <>'')) then
           st.WriteByte(15);
       if (lAktField = hind_Text) and (lActStr <>'') then
           st.WriteByte(16);
       if length(lActStr) >0 then
         st.WriteBuffer(lActStr[1],length(lActStr));
     end;
  st.WriteBuffer(LineEnding[1],length(LineEnding));
end;

procedure THejIndData.ReadFromDataset(idx: integer; const ds: TDataSet);

  function ConvertSex(aValue:String):String;

  var
    i: Integer;
  begin
    result := aValue;
    for i := 0 to high(SR_Array_Sex) div 2 do
      if SR_Array_Sex[i*2+1]=aValue then
        exit(SR_Array_Sex[i*2])
  end;

  function Convertjn(aValue:String):String;

  var
    i: Integer;
  begin
    result := aValue;
    for i := 0 to high(SR_Array_jn) div 2 do
      if SR_Array_jn[i*2+1]=aValue then
        exit(SR_Array_jn[i*2])
  end;

  function ConvertDModif(aValue:String):String;

  var
    i: Integer;
  begin
    result := aValue;
    for i := 0 to high(SR_Array_DModif) div 2 do
      if SR_Array_DModif[i*2+1]=aValue then
        exit(SR_Array_DModif[i*2])
  end;

var
  lDate: TDateTime;
  lDateModif: String;
  lDst, i: Integer;
begin
  if ds.Active then
    begin
      ds.Locate(ds.Fields[0].Name,idx,[]);
      for i := 0 to ds.FieldCount-1 do
        case i of
          0..4,6,7 : Data[TEnumHejIndDatafields(i-1)]:=ds.Fields[i].AsVariant;
          5 : Data[TEnumHejIndDatafields(i-1)]:=convertSex(ds.Fields[i].AsString);
          8,12,18,23: // Birthdate
             begin
               case i of
                 8:lDst := ord(hind_BirthDay);
                 12:lDst := ord(hind_BaptDay);
                 18:lDst := ord(hind_DeathDay);
                 23:lDst := ord(hind_BurialDay);
                 else
                   lDst := -2;
               end;
               lDateModif := ConvertDModif(ds.Fields[i+1].AsString);
               if ds.Fields[i].IsNull then
                 begin
                   if lDateModif ='' then
                     data[TEnumHejIndDatafields(lDst)]:=''
                   else
                data[TEnumHejIndDatafields(lDst)]:=lDateModif;
               data[TEnumHejIndDatafields(lDst+1)]:='';
               data[TEnumHejIndDatafields(lDst+2)]:='';
                 end
               else
               lDate:=ds.Fields[i].AsDateTime;
               if lDateModif ='' then
                 data[TEnumHejIndDatafields(lDst)]:=DayOf(lDate)
               else
                 data[TEnumHejIndDatafields(lDst)]:=lDateModif;
               data[TEnumHejIndDatafields(lDst+1)]:=MonthOf(lDate);
               data[TEnumHejIndDatafields(lDst+2)]:=YearOf(lDate);
             end;
          9,13,19,24:; // Wird in i-1 behandelt
          10: data[hind_Birthplace] := ds.Fields[i].AsString;
          11: data[hind_BirthSource] := ds.Fields[i].AsString;
          14: data[hind_BaptPlace] := ds.Fields[i].AsString;
          15: data[hind_Godparents] := ds.Fields[i].AsString;
          16: data[hind_BaptSource] := ds.Fields[i].AsString;
          17: data[hind_Residence] := ds.Fields[i].AsString;
          20: data[hind_DeathPlace] := ds.Fields[i].AsString;
          21: data[hind_DeathReason] := ds.Fields[i].AsString;
          22: data[hind_DeathSource] := ds.Fields[i].AsString;
          25: data[hind_BurialPlace] := ds.Fields[i].AsString;
          26: data[hind_BurialSource] := ds.Fields[i].AsString;
          27,29..37:Data[TEnumHejIndDatafields(ord(hind_Text)+i-27)] :=ds.Fields[i].AsString;
          28:Data[TEnumHejIndDatafields(ord(hind_Text)+i-27)] :=convertjn(ds.Fields[i].AsString);
          38..43:Data[TEnumHejIndDatafields(ord(hind_Age)+i-38)] :=ds.Fields[i].AsString;
        else
        end;
    end;
end;

procedure THejIndData.UpdateDataset(const ds: TDataSet);
var
  i, lDst: Integer;
  FChanged: Boolean;
  lDateModif: String;
  lYear,lMonth,lDay:string;
  lDate: TDateTime;
  lYearn,lMonthn,lDayn: integer;

  function CheckAndUpdate(const vDest:TField;const vSource:variant):boolean;

  begin
    result := vDest.AsVariant <> vSource;
    if result then
      vDest.AsVariant:= vSource;
  end;

begin
  if ds.Active then
    begin
      FChanged := false;
      if ds.Locate(ds.Fields[0].Name,ID,[]) then
        ds.Edit
      else
        begin
        ds.Append;
         Fchanged :=true;
         ds.Fields[0].AsInteger := ID;
        end;
      for i := 1 to ds.FieldCount-1 do
        case i of
          1..7 : Fchanged := CheckandUpdate(ds.Fields[i],Data[TEnumHejIndDatafields(i-1)]) or Fchanged ;

          8,12,18,23: // Birthdate
             begin
               case i of
                 8:lDst := ord(hind_BirthDay);
                 12:lDst := ord(hind_BaptDay);
                 18:lDst := ord(hind_DeathDay);
                 23:lDst := ord(hind_BurialDay);
                 else
                   lDst := -2;
               end;
               lDateModif := '';
               lYear :=  data[TEnumHejIndDatafields(lDst+2)];
               lMonth:=data[TEnumHejIndDatafields(lDst+1)];
               lDay:=data[TEnumHejIndDatafields(lDst)];
               if (lYear='') or not trystrtoint(lYear,lYearn) then
                 Fchanged := CheckAndUpdate(ds.Fields[i],null) or FChanged
               else begin
                 if (copy(lDay,1,1)>='0') and (copy(lDay,1,1)<='9') and tryStrtoint(lDay,lDayn) and TryStrToInt(lMonth,lMonthn) and
                   TryEncodeDate(lYearn,lMonthn,lDayn,lDate) then
               else
                 begin
                   lDateModif := data[TEnumHejIndDatafields(lDst)];
                   if TryStrToInt(lMonth,lMonthn) and TryEncodeDate(lYearn,lMonthn,1,lDate) then
                   else
                     tryEncodeDate(lYearn,1,1,lDate);
                 end;
                                Fchanged := CheckAndUpdate(ds.Fields[i],lDate) or FChanged;
                 end;
               Fchanged := CheckAndUpdate(ds.Fields[i+1],lDateModif) or FChanged;
             end;
          9,13,19,24:; // Wird in i-1 behandelt
          10: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_Birthplace]) or FChanged;
          11: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_BirthSource]) or FChanged;
          14: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_BaptPlace]) or FChanged;
          15: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_Godparents]) or FChanged;
          16: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_BaptSource]) or FChanged;
          17: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_Residence]) or FChanged;
          20: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_DeathPlace]) or FChanged;
          21: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_DeathReason]) or FChanged;
          22: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_DeathSource]) or FChanged;
          25: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_BurialPlace]) or FChanged;
          26: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hind_BurialSource]) or FChanged;
          27..37:Fchanged := CheckAndUpdate(ds.Fields[i] , Data[TEnumHejIndDatafields(ord(hind_Text)+i-27)]) or FChanged;
          38..43:Fchanged := CheckAndUpdate(ds.Fields[i] , Data[TEnumHejIndDatafields(ord(hind_Age)+i-38)]) or FChanged;
        else
        end;
      if FChanged then
        ds.Post
      else
        ds.Cancel;
    end;
end;

function THejIndData.Equals(aValue: THejIndData; OnlyData: boolean): boolean;
var
  I: TEnumHejIndDatafields;
begin
   Result := true;
   for I in TEnumHejIndDatafields do
     if (ord(I) >  ord(hind_id)) and (not OnlyData or (ord(I) >  ord(hind_idMother)))  then
       Result := Result and (Data[I] = aValue.Data[I]);
end;


end.

