unit cls_HejIndData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,variants,db,Unt_IData,unt_IGenBase2,cls_HejBase;

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

  CNonSingleton =
    [hind_text, hind_AKA, hind_FarmName]  + CIndSourceData;

type
 TClsIIndivid = class;

 PHejIndData = ^THejIndData;

 { THejIndData }

 THejIndData = packed Record
private
//  FOwner:TCl
  function GetBirthDate: String;
  function GetData(idx: TEnumHejIndDatafields): Variant;
  function GetDeathDate: String;
  function GetiIndi: IGenIndividual;
  procedure ReadFromStream0(const st: TStream);
  procedure SetBirthDate(AValue: String);
  procedure SetData(idx: TEnumHejIndDatafields; AValue: Variant);
  procedure SetIndivid(AValue: TClsIIndivid);
public
  function ToString:String;
  function ToPasStruct:String;
  function ParentCount:integer;
  function ChildCount:integer;
  Procedure RemoveParent(aID:integer);
  Procedure ReplaceParent(aID,aID2:integer);
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
  Procedure SetDateData(idx: TEnumHejIndDatafields;aValue: string);
  Procedure Clear;

  Procedure ReadFromStream(const st:TStream);
  Procedure WriteToStream(const st:TStream);
  Procedure ReadFromDataset(idx:integer;const ds:TDataSet);
  Procedure UpdateDataset(const ds:TDataSet);
  function Equals(aValue:THejIndData;OnlyData:boolean=False):boolean;
    property Data[idx:TEnumHejIndDatafields]:Variant read GetData write SetData;default;
    property BirthDate: String read GetBirthDate write SetBirthDate;
    property DeathDate: String read GetDeathDate;
    property Indi:IGenIndividual read GetiIndi;
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
 private
     FInd:TClsIIndivid;
 public
 //    property IndividI:IGenIndividual read FInd;
    property Individ:TClsIIndivid read FInd write SetIndivid;
 end;

 { TClsIIndivid }

 TClsIIndivid=class(Tobject{,IGenIndividual})
   private
       FTHejIndData : PHejIndData;
   public
        constructor Create(aInd:PHejIndData);
        destructor Destroy; override;
  public
        function GetBaptDate: string;
        function GetBaptism: IGenEvent;
        function GetBaptPlace: string;
        function GetBirth: IGenEvent;
        function GetBirthDate: string;
        function GetBirthPlace: string;
        function GetBurial: IGenEvent;
        function GetBurialDate: string;
        function GetBurialPlace: string;
        function GetChildrenCount: integer;
        function GetChildren(Idx: Variant): IGenIndividual;
        function GetDeath: IGenEvent;
        function GetDeathDate: string;
        function GetDeathPlace: string;
        function GetFamilies(Idx: Variant): IGenFamily;
        function GetFamilyCount: integer;
        function GetFather: IGenIndividual;
        function GetGivenName: string;
        function GetIndRefID: string;
        function GetMother: IGenIndividual;
        function GetName: string;
        function GetOccupation: string;
        function GetOccuPlace: string;
        function GetParentFamily: IGenFamily;
        function GetReligion: string;
        function GetResidence: string;
        function GetSex: string;
        function GetSpouseCount: integer;
        function GetSpouses(Idx: Variant): IGenIndividual;
        function GetSurname: string;
        function GetTimeStamp: TDateTime;
        function GetTitle: string;
{    Todo:   Mathoden Implementieren                            }
{       function EnumSpouses:IGenIndEnumerator;
        function EnumChildren:IGenIndEnumerator;
        function EnumFamilies:IGenFamEnumerator;       }
        procedure SetBaptDate(AValue: string);
        procedure SetBaptism(AValue: IGenEvent);
        procedure SetBaptPlace(AValue: string);
        procedure SetBirth(AValue: IGenEvent);
        procedure SetBirthDate(AValue: string);
        procedure SetBirthPlace(AValue: string);
        procedure SetBurial(AValue: IGenEvent);
        procedure SetBurialDate(AValue: string);
        procedure SetBurialPlace(AValue: string);
        procedure SetChildren(Idx: Variant; AValue: IGenIndividual);
        procedure SetDeath(AValue: IGenEvent);
        procedure SetDeathDate(AValue: string);
        procedure SetDeathPlace(AValue: string);
        procedure SetFamilies(Idx: Variant; AValue: IGenFamily);
        procedure SetFather(AValue: IGenIndividual);
        procedure SetGivenName(AValue: string);
        procedure SetIndRefID(AValue: string);
        procedure SetMother(AValue: IGenIndividual);
        procedure SetName(AValue: string);
        procedure SetOccupation(AValue: string);
        procedure SetOccuPlace(AValue: string);
        procedure SetParentFamily(AValue: IGenFamily);
        procedure SetReligion(AValue: string);
        procedure SetResidence(AValue: string);
        procedure SetSex(AValue: string);
        procedure SetSpouses(Idx: Variant; AValue: IGenIndividual);
        procedure SetSurname(AValue: string);
        procedure SetTimeStamp(AValue: TDateTime);
        procedure SetTitle(AValue: string);

        // Basic-Properies
        property Name: string read GetName write SetName;
        property GivenName: string read GetGivenName write SetGivenName;
        property Surname: string read GetSurname write SetSurname;
        property Title: string read GetTitle write SetTitle;
        property Sex: string read GetSex write SetSex;
        property IndRefID: string read GetIndRefID write SetIndRefID;
        // Relationship-Properties
        property Father: IGenIndividual read GetFather write SetFather;
        property Mother: IGenIndividual read GetMother write SetMother;
        property ChildCount: integer read GetChildrenCount;
        property Children[Idx: Variant]: IGenIndividual read GetChildren write SetChildren;
        property ParentFamily: IGenFamily read GetParentFamily write SetParentFamily;
        property FamilyCount: integer read GetFamilyCount;
        property Families[Idx: Variant]: IGenFamily read GetFamilies write SetFamilies;
        property SpouseCount: integer read GetSpouseCount;
        property Spouses[Idx: Variant]: IGenIndividual read GetSpouses write SetSpouses;
        // Vital-Properties
        property BirthDate: string read GetBirthDate write SetBirthDate;
        property BirthPlace: string read GetBirthPlace write SetBirthPlace;
        property Birth: IGenEvent read GetBirth write SetBirth;
        property BaptDate: string read GetBaptDate write SetBaptDate;
        property BaptPlace: string read GetBaptPlace write SetBaptPlace;
        property Baptism: IGenEvent read GetBaptism write SetBaptism;
        property DeathDate: string read GetDeathDate write SetDeathDate;
        property DeathPlace: string read GetDeathPlace write SetDeathPlace;
        property Death: IGenEvent read GetDeath write SetDeath;
        property BurialDate: string read GetBurialDate write SetBurialDate;
        property BurialPlace: string read GetBurialPlace write SetBurialPlace;
        property Burial: IGenEvent read GetBurial write SetBurial;
        property Religion: string read GetReligion write SetReligion;
        property Occupation: string read GetOccupation write SetOccupation;
        property OccuPlace: string read GetOccuPlace write SetOccuPlace;
        property Residence: string read GetResidence write SetResidence;
        // Management-Properies
        property LastChange: TDateTime read GetTimeStamp write SetTimeStamp;

 end;

 { TClsHejIndividuals }

 TClsHejIndividuals=class(TClsHejBase,IData)
 private
    FIndArray:array of THejIndData;
    FActIndex:integer;
    FOnUpdate: TNotifyEvent;
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
   procedure RemovePerson(const lActIndex: Integer);
   procedure SetData(ind: integer; idx: TEnumHejIndDatafields; AValue: variant
     );overload;
   Function GetDateData(ind:integer; idx: TEnumHejIndDatafields):string;
   Procedure SetDateData(ind:Integer; Idx:TEnumHejIndDatafields;aValue:String);
   Procedure Merge(aInd,aInd2:integer);
   Class Function GetSource(idx: TEnumHejIndDatafields): TEnumHejIndDatafields;
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
    function GetOnUpdate: TNotifyEvent;
    procedure SetOnUpdate(AValue: TNotifyEvent);
 end;

implementation

uses dateutils,LConvEncoding,dm_GenData2;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

{ TClsIIndivid }

constructor TClsIIndivid.Create(aInd: PHejIndData);
begin
  FTHejIndData := aInd;
end;

destructor TClsIIndivid.Destroy;
begin

end;

function TClsIIndivid.GetBaptDate: string;
begin
  result := '';
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetDateData(hind_BaptDay);
end;

function TClsIIndivid.GetBaptism: IGenEvent;
begin
  result := nil; //Owner.GetBaptism;
end;

function TClsIIndivid.GetBaptPlace: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_BaptPlace);
end;

function TClsIIndivid.GetBirth: IGenEvent;
begin
  result := nil; //Owner.GetBirth;
end;

function TClsIIndivid.GetBirthDate: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetDateData(hind_BirthDay);
end;

function TClsIIndivid.GetBirthPlace: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Birthplace);
end;

function TClsIIndivid.GetBurial: IGenEvent;
begin
  result := nil; //Owner.Burial;
end;

function TClsIIndivid.GetBurialDate: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetDateData(hind_BirthDay);
end;

function TClsIIndivid.GetBurialPlace: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_BurialPlace);
end;

function TClsIIndivid.GetChildrenCount: integer;
begin

end;

function TClsIIndivid.GetChildren(Idx: Variant): IGenIndividual;
begin

end;

function TClsIIndivid.GetDeath: IGenEvent;
begin
  result := nil; //Owner.Death;
end;

function TClsIIndivid.GetDeathDate: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetDateData(hind_BirthDay);
end;

function TClsIIndivid.GetDeathPlace: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_DeathPlace);
end;

function TClsIIndivid.GetFamilies(Idx: Variant): IGenFamily;
begin

end;

function TClsIIndivid.GetFamilyCount: integer;
begin

end;

function TClsIIndivid.GetFather: IGenIndividual;
begin

end;

function TClsIIndivid.GetGivenName: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_GivenName);
end;

function TClsIIndivid.GetIndRefID: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Index);
end;

function TClsIIndivid.GetMother: IGenIndividual;
begin

end;

function TClsIIndivid.GetName: string;
begin

end;

function TClsIIndivid.GetOccupation: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Occupation);
end;

function TClsIIndivid.GetOccuPlace: string;
begin

end;

function TClsIIndivid.GetParentFamily: IGenFamily;
begin

end;

function TClsIIndivid.GetReligion: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Religion);
end;

function TClsIIndivid.GetResidence: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Residence);
end;

function TClsIIndivid.GetSex: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Sex);
end;

function TClsIIndivid.GetSpouseCount: integer;
begin

end;

function TClsIIndivid.GetSpouses(Idx: Variant): IGenIndividual;
begin

end;

function TClsIIndivid.GetSurname: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_FamilyName);
end;

function TClsIIndivid.GetTimeStamp: TDateTime;
begin

end;

function TClsIIndivid.GetTitle: string;
begin

end;

procedure TClsIIndivid.SetBaptDate(AValue: string);
begin

end;

procedure TClsIIndivid.SetBaptism(AValue: IGenEvent);
begin

end;

procedure TClsIIndivid.SetBaptPlace(AValue: string);
begin

end;

procedure TClsIIndivid.SetBirth(AValue: IGenEvent);
begin

end;

procedure TClsIIndivid.SetBirthDate(AValue: string);
begin

end;

procedure TClsIIndivid.SetBirthPlace(AValue: string);
begin

end;

procedure TClsIIndivid.SetBurial(AValue: IGenEvent);
begin

end;

procedure TClsIIndivid.SetBurialDate(AValue: string);
begin

end;

procedure TClsIIndivid.SetBurialPlace(AValue: string);
begin

end;

procedure TClsIIndivid.SetChildren(Idx: Variant; AValue: IGenIndividual);
begin

end;

procedure TClsIIndivid.SetDeath(AValue: IGenEvent);
begin

end;

procedure TClsIIndivid.SetDeathDate(AValue: string);
begin

end;

procedure TClsIIndivid.SetDeathPlace(AValue: string);
begin

end;

procedure TClsIIndivid.SetFamilies(Idx: Variant; AValue: IGenFamily);
begin

end;

procedure TClsIIndivid.SetFather(AValue: IGenIndividual);
begin

end;

procedure TClsIIndivid.SetGivenName(AValue: string);
begin

end;

procedure TClsIIndivid.SetIndRefID(AValue: string);
begin

end;

procedure TClsIIndivid.SetMother(AValue: IGenIndividual);
begin

end;

procedure TClsIIndivid.SetName(AValue: string);
begin

end;

procedure TClsIIndivid.SetOccupation(AValue: string);
begin

end;

procedure TClsIIndivid.SetOccuPlace(AValue: string);
begin

end;

procedure TClsIIndivid.SetParentFamily(AValue: IGenFamily);
begin

end;

procedure TClsIIndivid.SetReligion(AValue: string);
begin

end;

procedure TClsIIndivid.SetResidence(AValue: string);
begin

end;

procedure TClsIIndivid.SetSex(AValue: string);
begin

end;

procedure TClsIIndivid.SetSpouses(Idx: Variant; AValue: IGenIndividual);
begin

end;

procedure TClsIIndivid.SetSurname(AValue: string);
begin

end;

procedure TClsIIndivid.SetTimeStamp(AValue: TDateTime);
begin

end;

procedure TClsIIndivid.SetTitle(AValue: string);
begin

end;

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

procedure TClsHejIndividuals.SetDateData(ind: Integer;
  Idx: TEnumHejIndDatafields; aValue: String);
begin
    if ind = -1 then
    ind:= FActIndex;
    if (ind >=0) and (ind <= high(FIndArray)) then
      FIndArray[ind].SetDateData(idx, AValue);
end;

procedure TClsHejIndividuals.Merge(aInd, aInd2: integer);
var
  i: TEnumHejIndDatafields;
  lseparator: String;
  lChild, j: Integer;
begin
  for i := hind_idFather to hind_idMother do
    if (FIndArray[aInd][i]=0) or
      (FIndArray[aInd][i]=FIndArray[aInd2][i]) then
    begin
      FIndArray[aInd][i]:=FIndArray[aInd2][i];
      if FIndArray[aInd2][i] >0 then
        FIndArray[FIndArray[aInd2][i]].RemoveChild(aind2);
    end
  else
    if FIndArray[aInd2][i] >0 then
      FIndArray[FIndArray[aInd2][i]].RemoveChild(aind2);
  for i := hind_FamilyName to high(TEnumHejIndDatafields) do
    if (FIndArray[aInd][i]='') or
      (FIndArray[aInd][i]=FIndArray[aInd2][i]) then
     begin
       FIndArray[aInd][i]:=FIndArray[aInd2][i];
     end
   else if (FIndArray[aInd2][i]<>'') and (i in CNonSingleton) then
     begin
       lseparator := '; ';
       if i=hind_Text then
         lseparator:=LineEnding;
       FIndArray[aInd][i]:=FIndArray[aInd][i]+lseparator+FIndArray[aInd2][i];
     end;
   for j := high(FIndArray[aind2].Children) downto 0 do
     begin
       lChild :=FIndArray[aind2].Children[j];
       FIndArray[lChild ].ReplaceParent(aInd2,aInd);
       FIndArray[aind ].AppendChild(lchild);
     end;
   FIndArray[aInd2].Clear;
end;

class function TClsHejIndividuals.GetSource(idx: TEnumHejIndDatafields
  ): TEnumHejIndDatafields;
begin
  case idx of
    hind_FamilyName,
    hind_GivenName,
    hind_AKA,
    hind_CallName:result := hind_NameSource;
    hind_BaptDay,
    hind_BaptMonth,
    hind_BaptPlace,
    hind_BaptYear:result :=  hind_BaptSource ;
    hind_BirthDay,
    hind_BirthMonth,
    hind_Birthplace,
    hind_BirthYear:result :=  hind_BirthSource ;
    hind_DeathDay,
    hind_DeathMonth,
    hind_DeathPlace,
    hind_DeathYear,
    hind_DeathReason:result :=  hind_DeathSource ;
    hind_BurialDay,
    hind_BurialMonth,
    hind_BurialPlace,
    hind_BurialYear:result :=  hind_BurialSource ;
  else
    Result:=hind_ID;
  end;
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
  if not Assigned(FIndArray) then exit;
  setlength(FIndArray,0);
  FActIndex:=-1;
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
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
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
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
  if FActIndex= 1 then exit;
  FActIndex:=1;
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TClsHejIndividuals.Last(Sender: TObject);
begin
  if FActIndex=high(FIndArray) then exit;
  FActIndex:=high(FIndArray);
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TClsHejIndividuals.Next(Sender: TObject);
begin
  if FActIndex=high(FIndArray) then exit;
  if FActIndex < high(FIndArray) then
    inc(FActIndex);
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TClsHejIndividuals.Previous(Sender: TObject);
begin
  if FActIndex<= 1 then exit;
  if FActIndex > 1 then
    dec(FActIndex);
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TClsHejIndividuals.Append(Sender: TObject);
begin
  if High(FIndArray) = -1 then
    Setlength(FIndArray,High(FIndArray)+3) // !!
    else
  Setlength(FIndArray,High(FIndArray)+2);
  FActIndex := high(FIndArray);
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
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
  if FActIndex = idInd then exit;
  if (idInd >=0) and (idInd <= high(FIndArray)) then
    begin
      FActIndex:=idInd;
      if assigned(FOnUpdate) then
        FOnUpdate(Self);

    end;
end;

procedure TClsHejIndividuals.Cancel(Sender: TObject);
begin

end;

procedure TClsHejIndividuals.Delete(Sender: Tobject);

begin
  RemovePerson(FActIndex);
end;

function TClsHejIndividuals.EOF: boolean;
begin
  result := FactIndex>=High(FIndArray)
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

function TClsHejIndividuals.GetOnUpdate: TNotifyEvent;
begin
  result := FOnUpdate;
end;

procedure TClsHejIndividuals.SetOnUpdate(AValue: TNotifyEvent);
begin
  if @FOnUpdate=@AValue then exit;
  FOnUpdate := aValue;
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
  if lowercase(FIndArray[idInd].Sex) <> 'm' then
    begin
    if FIndArray[idChild].idMother = 0 then
      FIndArray[idChild].idMother:= idInd;
    end
  else
  if FIndArray[idChild].idFather = 0 then
    FIndArray[idChild].idFather:= idInd;
end;

procedure TClsHejIndividuals.RemovePerson(const lActIndex: Integer);
var
  i: Integer;
begin
    FIndArray[lActIndex].id := 0;
  // Löse verbindungen zu Vater und Mutter
    if FIndArray[lActIndex].idFather >0 then
      FIndArray[FIndArray[lActIndex].idFather].RemoveChild(lActIndex);
    if FIndArray[lActIndex].idMother >0 then
      FIndArray[FIndArray[lActIndex].idMother].RemoveChild(lActIndex);
  // Löse Verbindungen zu evtl.Kindern
    for i := 0 to high(FIndArray[lActIndex].Children) do
      FIndArray[FIndArray[lActIndex].Children[i]].RemoveParent(lActIndex);
  // Lösche Daten
    FIndArray[lActIndex].Clear;
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

function THejIndData.GetBirthDate: String;
begin
  if BirthDay+BirthMonth+BirthYear <> '' then
    result := BirthDay+'.'+BirthMonth+'.'+BirthYear
  else
    result := ''
end;

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

function THejIndData.GetDeathDate: String;
begin
  if DeathDay+DeathMonth+DeathYear <> '' then
    result := DeathDay+'.'+DeathMonth+'.'+DeathYear
  else
    result := '';
end;

function THejIndData.GetiIndi: IGenIndividual; deprecated;
begin
//  if assigned(FIIndi) then
//    result := FIIndi
//  else
    begin

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

procedure THejIndData.SetIndivid(AValue: TClsIIndivid);
begin
  if FInd=AValue then Exit;
  FInd:=AValue;
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

procedure THejIndData.ReplaceParent(aID, aID2: integer);
begin
  if idFather = aID then
    idFather:=aID2;
  if idMother = aID then
    idMother:=aID2;
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

procedure THejIndData.SetDateData(idx: TEnumHejIndDatafields; aValue: string);
var
  lDay, lMonth, lYear: string;
begin
  DateStr2HeyDate(aValue,lDay,lMonth,lYear);
  data[idx]:=lDay;
  Data[TEnumHejIndDatafields(ord(idx)+1)]:=lMonth;
  Data[TEnumHejIndDatafields(ord(idx)+2)]:=lYear;
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

procedure THejIndData.SetBirthDate(AValue: String);
begin
  // Todo: Implement SetBirthDate
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

