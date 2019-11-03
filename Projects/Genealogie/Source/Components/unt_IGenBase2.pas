unit unt_IGenBase2;

{$mode delphi}
{$Interfaces CORBA}

interface

uses
    Classes, SysUtils;

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
        evt_Confirmation = 15,
        evt_Military = 16,
        evt_Divorce = 17,
        evt_Education = 18,
        evt_Degree = 19,
//        evt_ = 19,
        evt_Anull =20,
        evt_BarMitzwah =21,
        evt_BasMitzwah =22,
        evt_Blessing =23,
        evt_Cast=24,
        evt_Cencus=25,
        evt_Member=26,


        evt_Last
        );



    { IGenData }

    IGenData = interface  // Interface zu einem Genealogischen Faktum
        function GetData: string;
        function GetFType: integer;
        function GetObject: TObject;
        procedure SetData(AValue: string);
        procedure SetFType(AValue: integer);
        property Data: string read GetData write SetData;
        property FType: integer read GetFType write SetFType;
        property Self: TObject read GetObject;
    end;


    { IGenFact }

    IGenFact = interface(IGenData)  // Interface zu einem Genealogischen Faktum
        function GetSource: IGenData;
        procedure SetSource(AValue: IGenData);
        property Source: IGenData read GetSource write SetSource;
    end;

    { IGenEvent }

    IGenEvent = interface(IGenFact)  // Interface zu einem Genealogischen Event
        function GetEventType: TenumEventType;
        function GetDate: string;
    //    function GetPlace: IGenData; overload;
        function GetPlace: String; overload;
        procedure SetDate(AValue: string);
        procedure SetEventType(AValue: TenumEventType);
        procedure SetPlace(AValue: IGenFact); overload;
        procedure SetPlace(AValue: string); overload;
        property Date: string read GetDate write SetDate;
        property Place: string read GetPlace write SetPlace;
        property EventType: TenumEventType read GetEventType write SetEventType;
        //    property Place:IGenFact  read GetPlace write SetPlace;
    end;

    IGenName = interface(IGenFact)
    end;

    { IGenEntity }

    IGenEntity = interface(IGenData)
        function GetEventCount: integer;
        function GetEvents(Idx: Variant): IGenEvent;
        procedure SetEvents(Idx: variant; AValue: IGenEvent);
        property EventCount: integer read GetEventCount;
        property Events[Idx: variant]: IGenEvent read GetEvents write SetEvents;
    end;


    IGenFamily = interface;
    { IGenIndividual }

    IGenIndividual = interface(IGenEntity)
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
        function GetTitle: string;
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
    end;

    { IGenFamily }

    IGenFamily = interface(IGenEntity)
        function GetChildCount: integer;
        function GetChildren(Idx: Variant): IGenIndividual;
        function GetFamilyName: string;
        function GetFamilyRefID: string;
        function GetHusband: IGenIndividual;
        function GetMarriage: IGenEvent;
        function GetMarriageDate: string;
        function GetMarriagePlace: string;
        function GetWife: IGenIndividual;
        procedure SetChildren(Idx: Variant; AValue: IGenIndividual);
        procedure SetFamilyName(AValue: string);
        procedure SetFamilyRefID(AValue: string);
        procedure SetHusband(AValue: IGenIndividual);
        procedure SetMarriage(AValue: IGenEvent);
        procedure SetMarriageDate(AValue: string);
        procedure SetMarriagePlace(AValue: string);
        procedure SetWife(AValue: IGenIndividual);
        property Husband: IGenIndividual read GetHusband write SetHusband;
        property Wife: IGenIndividual read GetWife write SetWife;
        property ChildCount: integer read GetChildCount;
        property Children[Idx: Variant]: IGenIndividual read GetChildren write SetChildren;
        property MarriageDate: string read GetMarriageDate write SetMarriageDate;
        property MarriagePlace: string read GetMarriagePlace write SetMarriagePlace;
        property Marriage: IGenEvent read GetMarriage write SetMarriage;
        property FamilyRefID:string read GetFamilyRefID write SetFamilyRefID;
        property FamilyName:string read GetFamilyName write SetFamilyName;
    end;

implementation

end.

