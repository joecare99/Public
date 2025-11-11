unit cls_HejIndData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,variants,db,Unt_IData,unt_IGenBase2,cls_HejBase;

type
  /// <summary>
  /// Enumeration of fields for individual data in the genealogy system.
  /// Each field represents a specific attribute of a person's record.
  /// </summary>
  TEnumHejIndDatafields=(
    /// <summary>ID of the individual (unique identifier).</summary>
    hind_ID = -1,
    /// <summary>ID of the father.</summary>
    hind_idFather =0,
    /// <summary>ID of the mother.</summary>
    hind_idMother =1,
    /// <summary>Family name (surname).</summary>
    hind_FamilyName=2,
    /// <summary>Given name (first name).</summary>
    hind_GivenName=3,
    /// <summary>Sex of the individual.</summary>
    hind_Sex=4,
    /// <summary>Religion.</summary>
    hind_Religion=5,
    /// <summary>Occupation.</summary>
    hind_Occupation=6,
    /// <summary>Day of birth.</summary>
    hind_BirthDay=7,
    /// <summary>Month of birth.</summary>
    hind_BirthMonth=8,
    /// <summary>Year of birth.</summary>
    hind_BirthYear=9,
    /// <summary>Place of birth.</summary>
    hind_Birthplace=10,
    /// <summary>Day of baptism.</summary>
    hind_BaptDay=11,
    /// <summary>Month of baptism.</summary>
    hind_BaptMonth=12,
    /// <summary>Year of baptism.</summary>
    hind_BaptYear=13,
    /// <summary>Place of baptism.</summary>
    hind_BaptPlace=14,
    /// <summary>Godparents.</summary>
    hind_Godparents=15,
    /// <summary>Residence.</summary>
    hind_Residence=16,
    /// <summary>Day of death.</summary>
    hind_DeathDay=17,
    /// <summary>Month of death.</summary>
    hind_DeathMonth=18,
    /// <summary>Year of death.</summary>
    hind_DeathYear=19,
    /// <summary>Place of death.</summary>
    hind_DeathPlace=20,
    /// <summary>Reason of death.</summary>
    hind_DeathReason=21,
    /// <summary>Day of burial.</summary>
    hind_BurialDay=22,
    /// <summary>Month of burial.</summary>
    hind_BurialMonth=23,
    /// <summary>Year of burial.</summary>
    hind_BurialYear=24,
    /// <summary>Place of burial.</summary>
    hind_BurialPlace=25,
    /// <summary>Source for birth information.</summary>
    hind_BirthSource=26,
    /// <summary>Source for baptism information.</summary>
    hind_BaptSource=27,
    /// <summary>Source for death information.</summary>
    hind_DeathSource=28,
    /// <summary>Source for burial information.</summary>
    hind_BurialSource=29,
    /// <summary>Additional text/notes.</summary>
    hind_Text=30,
    /// <summary>Living status.</summary>
    hind_Living=31,
    /// <summary>Also known as (AKA).</summary>
    hind_AKA=32,
    /// <summary>Index/reference ID.</summary>
    hind_Index=33,
    /// <summary>Adopted status.</summary>
    hind_Adopted=34,
    /// <summary>Farm name.</summary>
    hind_FarmName=35,
    /// <summary>Address street.</summary>
    hind_AdrStreet=36,
    /// <summary>Address additional info.</summary>
    hind_AdrAddit=37,
    /// <summary>Address postal code.</summary>
    hind_AdrPLZ=38,
    /// <summary>Address place.</summary>
    hind_AdrPlace=39,
    /// <summary>Address place additional.</summary>
    hind_AdrPlaceAdd=40,
    /// <summary>Free field 1.</summary>
    hind_Free1=41,
    /// <summary>Free field 2.</summary>
    hind_Free2=42,
    /// <summary>Free field 3.</summary>
    hind_Free3=43,
    /// <summary>Age.</summary>
    hind_Age=44,
    /// <summary>Phone number.</summary>
    hind_Phone=45,
    /// <summary>Email address.</summary>
    hind_eMail=46,
    /// <summary>Website address.</summary>
    hind_WebAdr=47,
    /// <summary>Source for name information.</summary>
    hind_NameSource=48,
    /// <summary>Call name.</summary>
    hind_CallName=49);

  /// <summary>
  /// Set type for individual data fields.
  /// </summary>
  TIndFieldSet=set of byte;

const
  /// <summary>
  /// Array of descriptions for each individual data field.
  /// </summary>
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

  /// <summary>
  /// Set of fields related to sources for individual data.
  /// </summary>
  CIndSourceData  =
    [hind_BaptSource, hind_BirthSource, hind_BurialSource, hind_DeathSource, hind_NameSource];

  /// <summary>
  /// Set of fields related to places for individual data.
  /// </summary>
  CIndPlacedata  =
    [hind_AdrPlace, hind_BaptPlace, hind_Birthplace, hind_DeathPlace, hind_BurialPlace, hind_Residence];

  /// <summary>
  /// Set of fields related to dates for individual data.
  /// </summary>
  CIndDatedata  =
    [hind_BirthDay, hind_BaptDay,  hind_DeathDay, hind_BurialDay];

  /// <summary>
  /// Set of non-singleton fields (can have multiple values or special handling).
  /// </summary>
  CNonSingleton =
    [hind_text, hind_AKA, hind_FarmName]  + CIndSourceData;

type
  /// <summary>
  /// Forward declaration for TClsIIndivid.
  /// </summary>
  TClsIIndivid = class;

  /// <summary>
  /// Pointer to THejIndData record.
  /// </summary>
  PHejIndData = ^THejIndData;

  /// <summary>
  /// Record representing individual data in the genealogy system.
  /// Contains all personal information and relationships.
  /// </summary>
  THejIndData = packed Record
  private
    /// <summary>
    /// Gets the birth date as a formatted string.
    /// </summary>
    /// <returns>Birth date in DD.MM.YYYY format or empty string.</returns>
    function GetBirthDate: String;
    /// <summary>
    /// Gets the data for a specific field.
    /// </summary>
    /// <param name="idx">The field index.</param>
    /// <returns>The value of the field as Variant.</returns>
    function GetData(idx: TEnumHejIndDatafields): Variant;
    /// <summary>
    /// Gets the death date as a formatted string.
    /// </summary>
    /// <returns>Death date in DD.MM.YYYY format or empty string.</returns>
    function GetDeathDate: String;
    /// <summary>
    /// Gets the associated IGenIndividual interface (deprecated).
    /// </summary>
    /// <returns>The IGenIndividual instance.</returns>
    function GetiIndi: IGenIndividual;
    /// <summary>
    /// Reads data from stream (buffered version).
    /// </summary>
    /// <param name="st">The stream to read from.</param>
    procedure ReadFromStream0(const st: TStream);
    /// <summary>
    /// Sets the birth date from a string.
    /// </summary>
    /// <param name="AValue">The birth date string.</param>
    procedure SetBirthDate(AValue: String);
    /// <summary>
    /// Sets the data for a specific field.
    /// </summary>
    /// <param name="idx">The field index.</param>
    /// <param name="AValue">The value to set.</param>
    procedure SetData(idx: TEnumHejIndDatafields; AValue: Variant);
    /// <summary>
    /// Sets the associated TClsIIndivid instance.
    /// </summary>
    /// <param name="AValue">The TClsIIndivid instance.</param>
    procedure SetIndivid(AValue: TClsIIndivid);
  public
    /// <summary>
    /// Converts the record to a string representation.
    /// </summary>
    /// <returns>String representation of the individual.</returns>
    function ToString:String;
    /// <summary>
    /// Converts the record to a Pascal struct string.
    /// </summary>
    /// <returns>Pascal struct representation.</returns>
    function ToPasStruct:String;
    /// <summary>
    /// Gets the number of parents.
    /// </summary>
    /// <returns>Number of parents (0, 1, or 2).</returns>
    function ParentCount:integer;
    /// <summary>
    /// Gets the number of children.
    /// </summary>
    /// <returns>Number of children.</returns>
    function ChildCount:integer;
    /// <summary>
    /// Removes a parent by ID.
    /// </summary>
    /// <param name="aID">The parent ID to remove.</param>
    Procedure RemoveParent(aID:integer);
    /// <summary>
    /// Replaces a parent ID with another.
    /// </summary>
    /// <param name="aID">The old parent ID.</param>
    /// <param name="aID2">The new parent ID.</param>
    Procedure ReplaceParent(aID,aID2:integer);
    /// <summary>
    /// Appends a child ID.
    /// </summary>
    /// <param name="aID">The child ID to append.</param>
    Procedure AppendChild(aID:integer);
    /// <summary>
    /// Removes a child by ID.
    /// </summary>
    /// <param name="aID">The child ID to remove.</param>
    Procedure RemoveChild(aID:integer);
    /// <summary>
    /// Deletes a child at a specific index.
    /// </summary>
    /// <param name="idx">The index of the child to delete.</param>
    Procedure DeleteChild(idx:integer);
    /// <summary>
    /// Appends a marriage ID.
    /// </summary>
    /// <param name="amID">The marriage ID to append.</param>
    Procedure AppendMarriage(amID:integer);
    /// <summary>
    /// Removes a marriage by ID.
    /// </summary>
    /// <param name="amID">The marriage ID to remove.</param>
    Procedure RemoveMarriage(amID:integer);
    /// <summary>
    /// Deletes a marriage at a specific index.
    /// </summary>
    /// <param name="Idx">The index of the marriage to delete.</param>
    Procedure DeleteMarriage(Idx:integer);
    /// <summary>
    /// Gets the number of spouses.
    /// </summary>
    /// <returns>Number of spouses.</returns>
    function SpouseCount:integer;
    /// <summary>
    /// Gets the number of places associated.
    /// </summary>
    /// <returns>Number of places.</returns>
    function PlaceCount:integer;
    /// <summary>
    /// Gets the number of sources associated.
    /// </summary>
    /// <returns>Number of sources.</returns>
    function SourceCount:integer;
    /// <summary>
    /// Gets a value representing the individual's date (for sorting).
    /// </summary>
    /// <returns>Double value of birth or baptism date.</returns>
    Function GetValue:double;
    /// <summary>
    /// Gets date data for a specific field.
    /// </summary>
    /// <param name="idx">The date field index.</param>
    /// <param name="dtOnly">If true, returns date only without time.</param>
    /// <returns>Formatted date string.</returns>
    function GetDateData(idx: TEnumHejIndDatafields;dtOnly:boolean=false): string;
    /// <summary>
    /// Sets date data for a specific field.
    /// </summary>
    /// <param name="idx">The date field index.</param>
    /// <param name="aValue">The date string to set.</param>
    Procedure SetDateData(idx: TEnumHejIndDatafields;aValue: string);
    /// <summary>
    /// Clears all data in the record.
    /// </summary>
    Procedure Clear;

    /// <summary>
    /// Reads data from a stream.
    /// </summary>
    /// <param name="st">The stream to read from.</param>
    Procedure ReadFromStream(const st:TStream);
    /// <summary>
    /// Writes data to a stream.
    /// </summary>
    /// <param name="st">The stream to write to.</param>
    Procedure WriteToStream(const st:TStream);
    /// <summary>
    /// Reads data from a dataset at a specific index.
    /// </summary>
    /// <param name="idx">The index in the dataset.</param>
    /// <param name="ds">The dataset to read from.</param>
    Procedure ReadFromDataset(idx:integer;const ds:TDataSet);
    /// <summary>
    /// Updates the dataset with current data.
    /// </summary>
    /// <param name="ds">The dataset to update.</param>
    Procedure UpdateDataset(const ds:TDataSet);
    /// <summary>
    /// Checks if this record equals another.
    /// </summary>
    /// <param name="aValue">The other record to compare.</param>
    /// <param name="OnlyData">If true, compares only data fields.</param>
    /// <returns>True if equal.</returns>
    function Equals(aValue:THejIndData;OnlyData:boolean=False):boolean;
    /// <summary>
    /// Default property to access data fields.
    /// </summary>
    /// <param name="idx">The field index.</param>
    /// <returns>The field value.</returns>
    property Data[idx:TEnumHejIndDatafields]:Variant read GetData write SetData;default;
    /// <summary>
    /// Property for birth date.
    /// </summary>
    property BirthDate: String read GetBirthDate write SetBirthDate;
    /// <summary>
    /// Property for death date.
    /// </summary>
    property DeathDate: String read GetDeathDate;
    /// <summary>
    /// Property for associated IGenIndividual (deprecated).
    /// </summary>
    property Indi:IGenIndividual read GetiIndi;
  public
    /// <summary>Unique ID of the individual.</summary>
    ID,
    /// <summary>ID of the father.</summary>
    idFather,
    /// <summary>ID of the mother.</summary>
    idMother:integer;
    /// <summary>Family name.</summary>
    FamilyName,
    /// <summary>Given name.</summary>
    GivenName,
    /// <summary>Sex.</summary>
    Sex,
    /// <summary>Religion.</summary>
    Religion,
    /// <summary>Occupation.</summary>
    Occupation,
    /// <summary>Birth day.</summary>
    BirthDay,
    /// <summary>Birth month.</summary>
    BirthMonth,
    /// <summary>Birth year.</summary>
    BirthYear,
    /// <summary>Birth place.</summary>
    Birthplace,
    /// <summary>Baptism day.</summary>
    BaptDay,
    /// <summary>Baptism month.</summary>
    BaptMonth,
    /// <summary>Baptism year.</summary>
    BaptYear,
    /// <summary>Baptism place.</summary>
    BaptPlace,
    /// <summary>Godparents.</summary>
    Godparents,
    /// <summary>Residence.</summary>
    Residence,
    /// <summary>Death day.</summary>
    DeathDay,
    /// <summary>Death month.</summary>
    DeathMonth,
    /// <summary>Death year.</summary>
    DeathYear,
    /// <summary>Death place.</summary>
    DeathPlace,
    /// <summary>Death reason.</summary>
    DeathReason,
    /// <summary>Burial day.</summary>
    BurialDay,
    /// <summary>Burial month.</summary>
    BurialMonth,
    /// <summary>Burial year.</summary>
    BurialYear,
    /// <summary>Burial place.</summary>
    BurialPlace,
    /// <summary>Birth source.</summary>
    BirthSource,
    /// <summary>Baptism source.</summary>
    BaptSource,
    /// <summary>Death source.</summary>
    DeathSource,
    /// <summary>Burial source.</summary>
    BurialSource,
    /// <summary>Text/notes.</summary>
    Text,
    /// <summary>Living status.</summary>
    Living,
    /// <summary>Also known as.</summary>
    AKA,
    /// <summary>Index.</summary>
    Index,
    /// <summary>Adopted.</summary>
    Adopted,
    /// <summary>Farm name.</summary>
    FarmName,
    /// <summary>Address street.</summary>
    AdrStreet,
    /// <summary>Address additional.</summary>
    AdrAddit,
    /// <summary>Address postal code.</summary>
    AdrPLZ,
    /// <summary>Address place.</summary>
    AdrPlace,
    /// <summary>Address place additional.</summary>
    AdrPlaceAdd,
    /// <summary>Free field 1.</summary>
    Free1,
    /// <summary>Free field 2.</summary>
    Free2,
    /// <summary>Free field 3.</summary>
    Free3,
    /// <summary>Age.</summary>
    Age,
    /// <summary>Phone.</summary>
    Phone,
    /// <summary>Email.</summary>
    eMail,
    /// <summary>Website.</summary>
    WebAdr,
    /// <summary>Name source.</summary>
    NameSource,
    /// <summary>Call name.</summary>
    CallName:string;
    /// <summary>Array of marriage IDs.</summary>
    Marriages:array of Integer;
    /// <summary>Array of children IDs.</summary>
    Children:array of Integer;
  private
    /// <summary>Associated TClsIIndivid instance.</summary>
    FInd:TClsIIndivid;
  public
    /// <summary>Property for associated TClsIIndivid.</summary>
    property Individ:TClsIIndivid read FInd write SetIndivid;
  end;

  /// <summary>
  /// Class implementing IGenIndividual interface for genealogy individuals.
  /// Wraps THejIndData and provides interface methods.
  /// </summary>
  TClsIIndivid=class(Tobject{,IGenIndividual})
  private
    /// <summary>Pointer to the underlying THejIndData.</summary>
    FTHejIndData : PHejIndData;
  public
    /// <summary>
    /// Constructor creating an instance with a pointer to THejIndData.
    /// </summary>
    /// <param name="aInd">Pointer to the individual data.</param>
    constructor Create(aInd:PHejIndData);
    /// <summary>
    /// Destructor.
    /// </summary>
    destructor Destroy; override;
  public
    /// <summary>Gets the baptism date.</summary>
    /// <returns>Baptism date string.</returns>
    function GetBaptDate: string;
    /// <summary>Gets the baptism event (not implemented).</summary>
    /// <returns>IGenEvent for baptism.</returns>
    function GetBaptism: IGenEvent;
    /// <summary>Gets the baptism place.</summary>
    /// <returns>Baptism place string.</returns>
    function GetBaptPlace: string;
    /// <summary>Gets the birth event (not implemented).</summary>
    /// <returns>IGenEvent for birth.</returns>
    function GetBirth: IGenEvent;
    /// <summary>Gets the birth date.</summary>
    /// <returns>Birth date string.</returns>
    function GetBirthDate: string;
    /// <summary>Gets the birth place.</summary>
    /// <returns>Birth place string.</returns>
    function GetBirthPlace: string;
    /// <summary>Gets the burial event (not implemented).</summary>
    /// <returns>IGenEvent for burial.</returns>
    function GetBurial: IGenEvent;
    /// <summary>Gets the burial date.</summary>
    /// <returns>Burial date string.</returns>
    function GetBurialDate: string;
    /// <summary>Gets the burial place.</summary>
    /// <returns>Burial place string.</returns>
    function GetBurialPlace: string;
    /// <summary>Gets the number of children.</summary>
    /// <returns>Number of children.</returns>
    function GetChildrenCount: integer;
    /// <summary>Gets a child by index.</summary>
    /// <param name="Idx">The index.</param>
    /// <returns>IGenIndividual child.</returns>
    function GetChildren(Idx: Variant): IGenIndividual;
    /// <summary>Gets the death event (not implemented).</summary>
    /// <returns>IGenEvent for death.</returns>
    function GetDeath: IGenEvent;
    /// <summary>Gets the death date.</summary>
    /// <returns>Death date string.</returns>
    function GetDeathDate: string;
    /// <summary>Gets the death place.</summary>
    /// <returns>Death place string.</returns>
    function GetDeathPlace: string;
    /// <summary>Gets a family by index (not implemented).</summary>
    /// <param name="Idx">The index.</param>
    /// <returns>IGenFamily.</returns>
    function GetFamilies(Idx: Variant): IGenFamily;
    /// <summary>Gets the number of families.</summary>
    /// <returns>Number of families.</returns>
    function GetFamilyCount: integer;
    /// <summary>Gets the father (not implemented).</summary>
    /// <returns>IGenIndividual father.</returns>
    function GetFather: IGenIndividual;
    /// <summary>Gets the given name.</summary>
    /// <returns>Given name string.</returns>
    function GetGivenName: string;
    /// <summary>Gets the individual reference ID.</summary>
    /// <returns>Reference ID string.</returns>
    function GetIndRefID: string;
    /// <summary>Gets the mother (not implemented).</summary>
    /// <returns>IGenIndividual mother.</returns>
    function GetMother: IGenIndividual;
    /// <summary>Gets the full name (not implemented).</summary>
    /// <returns>Name string.</returns>
    function GetName: string;
    /// <summary>Gets the occupation.</summary>
    /// <returns>Occupation string.</returns>
    function GetOccupation: string;
    /// <summary>Gets the occupation place (not implemented).</summary>
    /// <returns>Occupation place string.</returns>
    function GetOccuPlace: string;
    /// <summary>Gets the parent family (not implemented).</summary>
    /// <returns>IGenFamily parent family.</returns>
    function GetParentFamily: IGenFamily;
    /// <summary>Gets the religion.</summary>
    /// <returns>Religion string.</returns>
    function GetReligion: string;
    /// <summary>Gets the residence.</summary>
    /// <returns>Residence string.</returns>
    function GetResidence: string;
    /// <summary>Gets the sex.</summary>
    /// <returns>Sex string.</returns>
    function GetSex: string;
    /// <summary>Gets the number of spouses (not implemented).</summary>
    /// <returns>Number of spouses.</returns>
    function GetSpouseCount: integer;
    /// <summary>Gets a spouse by index (not implemented).</summary>
    /// <param name="Idx">The index.</param>
    /// <returns>IGenIndividual spouse.</returns>
    function GetSpouses(Idx: Variant): IGenIndividual;
    /// <summary>Gets the surname.</summary>
    /// <returns>Surname string.</returns>
    function GetSurname: string;
    /// <summary>Gets the timestamp (not implemented).</summary>
    /// <returns>TDateTime timestamp.</returns>
    function GetTimeStamp: TDateTime;
    /// <summary>Gets the title (not implemented).</summary>
    /// <returns>Title string.</returns>
    function GetTitle: string;
    /// <summary>Sets the baptism date (not implemented).</summary>
    /// <param name="AValue">The date string.</param>
    procedure SetBaptDate(AValue: string);
    /// <summary>Sets the baptism event (not implemented).</summary>
    /// <param name="AValue">The IGenEvent.</param>
    procedure SetBaptism(AValue: IGenEvent);
    /// <summary>Sets the baptism place (not implemented).</summary>
    /// <param name="AValue">The place string.</param>
    procedure SetBaptPlace(AValue: string);
    /// <summary>Sets the birth event (not implemented).</summary>
    /// <param name="AValue">The IGenEvent.</param>
    procedure SetBirth(AValue: IGenEvent);
    /// <summary>Sets the birth date (not implemented).</summary>
    /// <param name="AValue">The date string.</param>
    procedure SetBirthDate(AValue: string);
    /// <summary>Sets the birth place (not implemented).</summary>
    /// <param name="AValue">The place string.</param>
    procedure SetBirthPlace(AValue: string);
    /// <summary>Sets the burial event (not implemented).</summary>
    /// <param name="AValue">The IGenEvent.</param>
    procedure SetBurial(AValue: IGenEvent);
    /// <summary>Sets the burial date (not implemented).</summary>
    /// <param name="AValue">The date string.</param>
    procedure SetBurialDate(AValue: string);
    /// <summary>Sets the burial place (not implemented).</summary>
    /// <param name="AValue">The place string.</param>
    procedure SetBurialPlace(AValue: string);
    /// <summary>Sets a child (not implemented).</summary>
    /// <param name="Idx">The index.</param>
    /// <param name="AValue">The IGenIndividual.</param>
    procedure SetChildren(Idx: Variant; AValue: IGenIndividual);
    /// <summary>Sets the death event (not implemented).</summary>
    /// <param name="AValue">The IGenEvent.</param>
    procedure SetDeath(AValue: IGenEvent);
    /// <summary>Sets the death date (not implemented).</summary>
    /// <param name="AValue">The date string.</param>
    procedure SetDeathDate(AValue: string);
    /// <summary>Sets the death place (not implemented).</summary>
    /// <param name="AValue">The place string.</param>
    procedure SetDeathPlace(AValue: string);
    /// <summary>Sets a family (not implemented).</summary>
    /// <param name="Idx">The index.</param>
    /// <param name="AValue">The IGenFamily.</param>
    procedure SetFamilies(Idx: Variant; AValue: IGenFamily);
    /// <summary>Sets the father (not implemented).</summary>
    /// <param name="AValue">The IGenIndividual.</param>
    procedure SetFather(AValue: IGenIndividual);
    /// <summary>Sets the given name (not implemented).</summary>
    /// <param name="AValue">The name string.</param>
    procedure SetGivenName(AValue: string);
    /// <summary>Sets the individual reference ID (not implemented).</summary>
    /// <param name="AValue">The ID string.</param>
    procedure SetIndRefID(AValue: string);
    /// <summary>Sets the mother (not implemented).</summary>
    /// <param name="AValue">The IGenIndividual.</param>
    procedure SetMother(AValue: IGenIndividual);
    /// <summary>Sets the name (not implemented).</summary>
    /// <param name="AValue">The name string.</param>
    procedure SetName(AValue: string);
    /// <summary>Sets the occupation (not implemented).</summary>
    /// <param name="AValue">The occupation string.</param>
    procedure SetOccupation(AValue: string);
    /// <summary>Sets the occupation place (not implemented).</summary>
    /// <param name="AValue">The place string.</param>
    procedure SetOccuPlace(AValue: string);
    /// <summary>Sets the parent family (not implemented).</summary>
    /// <param name="AValue">The IGenFamily.</param>
    procedure SetParentFamily(AValue: IGenFamily);
    /// <summary>Sets the religion (not implemented).</summary>
    /// <param name="AValue">The religion string.</param>
    procedure SetReligion(AValue: string);
    /// <summary>Sets the residence (not implemented).</summary>
    /// <param name="AValue">The residence string.</param>
    procedure SetResidence(AValue: string);
    /// <summary>Sets the sex (not implemented).</summary>
    /// <param name="AValue">The sex string.</param>
    procedure SetSex(AValue: string);
    /// <summary>Sets a spouse (not implemented).</summary>
    /// <param name="Idx">The index.</param>
    /// <param name="AValue">The IGenIndividual.</param>
    procedure SetSpouses(Idx: Variant; AValue: IGenIndividual);
    /// <summary>Sets the surname (not implemented).</summary>
    /// <param name="AValue">The surname string.</param>
    procedure SetSurname(AValue: string);
    /// <summary>Sets the timestamp (not implemented).</summary>
    /// <param name="AValue">The TDateTime.</param>
    procedure SetTimeStamp(AValue: TDateTime);
    /// <summary>Sets the title (not implemented).</summary>
    /// <param name="AValue">The title string.</param>
    procedure SetTitle(AValue: string);
  end;

implementation

uses dateutils,LConvEncoding,dm_GenData2;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

{ TClsIIndivid }

/// <summary>
/// Constructor for TClsIIndivid.
/// </summary>
constructor TClsIIndivid.Create(aInd: PHejIndData);
begin
  FTHejIndData := aInd;
end;

/// <summary>
/// Destructor for TClsIIndivid.
/// </summary>
destructor TClsIIndivid.Destroy;
begin

end;

/// <summary>
/// Gets the baptism date.
/// </summary>
function TClsIIndivid.GetBaptDate: string;
begin
  result := '';
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetDateData(hind_BaptDay);
end;

/// <summary>
/// Gets the baptism event (not implemented).
/// </summary>
function TClsIIndivid.GetBaptism: IGenEvent;
begin
  result := nil; //Owner.GetBaptism;
end;

/// <summary>
/// Gets the baptism place.
/// </summary>
function TClsIIndivid.GetBaptPlace: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_BaptPlace);
end;

/// <summary>
/// Gets the birth event (not implemented).
/// </summary>
function TClsIIndivid.GetBirth: IGenEvent;
begin
  result := nil; //Owner.GetBirth;
end;

/// <summary>
/// Gets the birth date.
/// </summary>
function TClsIIndivid.GetBirthDate: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetDateData(hind_BirthDay);
end;

/// <summary>
/// Gets the birth place.
/// </summary>
function TClsIIndivid.GetBirthPlace: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Birthplace);
end;

/// <summary>
/// Gets the burial event (not implemented).
/// </summary>
function TClsIIndivid.GetBurial: IGenEvent;
begin
  result := nil; //Owner.Burial;
end;

/// <summary>
/// Gets the burial date.
/// </summary>
function TClsIIndivid.GetBurialDate: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetDateData(hind_BirthDay);
end;

/// <summary>
/// Gets the burial place.
/// </summary>
function TClsIIndivid.GetBurialPlace: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_BurialPlace);
end;

/// <summary>
/// Gets the number of children (not implemented).
/// </summary>
function TClsIIndivid.GetChildrenCount: integer;
begin

end;

/// <summary>
/// Gets a child by index (not implemented).
/// </summary>
function TClsIIndivid.GetChildren(Idx: Variant): IGenIndividual;
begin

end;

/// <summary>
/// Gets the death event (not implemented).
/// </summary>
function TClsIIndivid.GetDeath: IGenEvent;
begin
  result := nil; //Owner.Death;
end;

/// <summary>
/// Gets the death date.
/// </summary>
function TClsIIndivid.GetDeathDate: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetDateData(hind_BirthDay);
end;

/// <summary>
/// Gets the death place.
/// </summary>
function TClsIIndivid.GetDeathPlace: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_DeathPlace);
end;

/// <summary>
/// Gets a family by index (not implemented).
/// </summary>
function TClsIIndivid.GetFamilies(Idx: Variant): IGenFamily;
begin

end;

/// <summary>
/// Gets the number of families (not implemented).
/// </summary>
function TClsIIndivid.GetFamilyCount: integer;
begin

end;

/// <summary>
/// Gets the father (not implemented).
/// </summary>
function TClsIIndivid.GetFather: IGenIndividual;
begin

end;

/// <summary>
/// Gets the given name.
/// </summary>
function TClsIIndivid.GetGivenName: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_GivenName);
end;

/// <summary>
/// Gets the individual reference ID.
/// </summary>
function TClsIIndivid.GetIndRefID: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Index);
end;

/// <summary>
/// Gets the mother (not implemented).
/// </summary>
function TClsIIndivid.GetMother: IGenIndividual;
begin

end;

/// <summary>
/// Gets the name (not implemented).
/// </summary>
function TClsIIndivid.GetName: string;
begin

end;

/// <summary>
/// Gets the occupation.
/// </summary>
function TClsIIndivid.GetOccupation: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Occupation);
end;

/// <summary>
/// Gets the occupation place (not implemented).
/// </summary>
function TClsIIndivid.GetOccuPlace: string;
begin

end;

/// <summary>
/// Gets the parent family (not implemented).
/// </summary>
function TClsIIndivid.GetParentFamily: IGenFamily;
begin

end;

/// <summary>
/// Gets the religion.
/// </summary>
function TClsIIndivid.GetReligion: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Religion);
end;

/// <summary>
/// Gets the residence.
/// </summary>
function TClsIIndivid.GetResidence: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Residence);
end;

/// <summary>
/// Gets the sex.
/// </summary>
function TClsIIndivid.GetSex: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_Sex);
end;

/// <summary>
/// Gets the spouse count (not implemented).
/// </summary>
function TClsIIndivid.GetSpouseCount: integer;
begin

end;

/// <summary>
/// Gets a spouse by index (not implemented).
/// </summary>
function TClsIIndivid.GetSpouses(Idx: Variant): IGenIndividual;
begin

end;

/// <summary>
/// Gets the surname.
/// </summary>
function TClsIIndivid.GetSurname: string;
begin
  if assigned(FTHejIndData) then
    result := FTHejIndData.GetData(hind_FamilyName);
end;

/// <summary>
/// Gets the timestamp (not implemented).
/// </summary>
function TClsIIndivid.GetTimeStamp: TDateTime;
begin

end;

/// <summary>
/// Gets the title (not implemented).
/// </summary>
function TClsIIndivid.GetTitle: string;
begin

end;

/// <summary>
/// Sets the baptism date (not implemented).
/// </summary>
procedure TClsIIndivid.SetBaptDate(AValue: string);
begin

end;

/// <summary>
/// Sets the baptism event (not implemented).
/// </summary>
procedure TClsIIndivid.SetBaptism(AValue: IGenEvent);
begin

end;

/// <summary>
/// Sets the baptism place (not implemented).
/// </summary>
procedure TClsIIndivid.SetBaptPlace(AValue: string);
begin

end;

/// <summary>
/// Sets the birth event (not implemented).
/// </summary>
procedure TClsIIndivid.SetBirth(AValue: IGenEvent);
begin

end;

/// <summary>
/// Sets the birth date (not implemented).
/// </summary>
procedure TClsIIndivid.SetBirthDate(AValue: string);
begin

end;

/// <summary>
/// Sets the birth place (not implemented).
/// </summary>
procedure TClsIIndivid.SetBirthPlace(AValue: string);
begin

end;

/// <summary>
/// Sets the burial event (not implemented).
/// </summary>
procedure TClsIIndivid.SetBurial(AValue: IGenEvent);
begin

end;

/// <summary>
/// Sets the burial date (not implemented).
/// </summary>
procedure TClsIIndivid.SetBurialDate(AValue: string);
begin

end;

/// <summary>
/// Sets the burial place (not implemented).
/// </summary>
procedure TClsIIndivid.SetBurialPlace(AValue: string);
begin

end;

/// <summary>
/// Sets a child (not implemented).
/// </summary>
procedure TClsIIndivid.SetChildren(Idx: Variant; AValue: IGenIndividual);
begin

end;

/// <summary>
/// Sets the death event (not implemented).
/// </summary>
procedure TClsIIndivid.SetDeath(AValue: IGenEvent);
begin

end;

/// <summary>
/// Sets the death date (not implemented).
/// </summary>
procedure TClsIIndivid.SetDeathDate(AValue: string);
begin

end;

/// <summary>
/// Sets the death place (not implemented).
/// </summary>
procedure TClsIIndivid.SetDeathPlace(AValue: string);
begin

end;

/// <summary>
/// Sets a family (not implemented).
/// </summary>
procedure TClsIIndivid.SetFamilies(Idx: Variant; AValue: IGenFamily);
begin

end;

/// <summary>
/// Sets the father (not implemented).
/// </summary>
procedure TClsIIndivid.SetFather(AValue: IGenIndividual);
begin

end;

/// <summary>
/// Sets the given name (not implemented).
/// </summary>
procedure TClsIIndivid.SetGivenName(AValue: string);
begin

end;

/// <summary>
/// Sets the individual reference ID (not implemented).
/// </summary>
procedure TClsIIndivid.SetIndRefID(AValue: string);
begin

end;

/// <summary>
/// Sets the mother (not implemented).
/// </summary>
procedure TClsIIndivid.SetMother(AValue: IGenIndividual);
begin

end;

/// <summary>
/// Sets the name (not implemented).
/// </summary>
procedure TClsIIndivid.SetName(AValue: string);
begin

end;

/// <summary>
/// Sets the occupation (not implemented).
/// </summary>
procedure TClsIIndivid.SetOccupation(AValue: string);
begin

end;

/// <summary>
/// Sets the occupation place (not implemented).
/// </summary>
procedure TClsIIndivid.SetOccuPlace(AValue: string);
begin

end;

/// <summary>
/// Sets the parent family (not implemented).
/// </summary>
procedure TClsIIndivid.SetParentFamily(AValue: IGenFamily);
begin

end;

/// <summary>
/// Sets the religion (not implemented).
/// </summary>
procedure TClsIIndivid.SetReligion(AValue: string);
begin

end;

/// <summary>
/// Sets the residence (not implemented).
/// </summary>
procedure TClsIIndivid.SetResidence(AValue: string);
begin

end;

/// <summary>
/// Sets the sex (not implemented).
/// </summary>
procedure TClsIIndivid.SetSex(AValue: string);
begin

end;

/// <summary>
/// Sets a spouse (not implemented).
/// </summary>
procedure TClsIIndivid.SetSpouses(Idx: Variant; AValue: IGenIndividual);
begin

end;

/// <summary>
/// Sets the surname (not implemented).
/// </summary>
procedure TClsIIndivid.SetSurname(AValue: string);
begin

end;

/// <summary>
/// Sets the timestamp (not implemented).
/// </summary>
procedure TClsIIndivid.SetTimeStamp(AValue: TDateTime);
begin

end;

/// <summary>
/// Sets the title (not implemented).
/// </summary>
procedure TClsIIndivid.SetTitle(AValue: string);
begin

end;

{ TClsHejIndividuals }

/// <summary>
/// Sets the active individual data.
/// </summary>
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

/// <summary>
/// Sets the marriage ID at index for the active individual.
/// </summary>
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

/// <summary>
/// Sets data for an individual and field.
/// </summary>
procedure TClsHejIndividuals.SetData(ind: integer; idx: TEnumHejIndDatafields;
  AValue: variant);

begin
  if Ind = -1 then
    ind := FActIndex;
  if (ind >0) and (ind <= high(FIndArray)) then
    FIndArray[ind].Data[idx] := AValue;
end;

/// <summary>
/// Gets date data for an individual and field.
/// </summary>
function TClsHejIndividuals.GetDateData(ind: integer;
  idx: TEnumHejIndDatafields; dtOnly: boolean): string;
begin
  if Ind = -1 then
    ind := FActIndex;
  if (ind >0) and (ind <= high(FIndArray)) then
    result := FIndArray[ind].GetDateData(idx,dtOnly);
end;

/// <summary>
/// Sets date data for an individual and field.
/// </summary>
procedure TClsHejIndividuals.SetDateData(ind: Integer;
  Idx: TEnumHejIndDatafields; aValue: String);
begin
    if ind = -1 then
    ind:= FActIndex;
    if (ind >=0) and (ind <= high(FIndArray)) then
      FIndArray[ind].SetDateData(idx, AValue);
end;

/// <summary>
/// Merges two individuals.
/// </summary>
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

/// <summary>
/// Gets the source field for a given field.
/// </summary>
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

/// <summary>
/// Appends a marriage.
/// </summary>
procedure TClsHejIndividuals.AppendMarriage(Ind, marr: integer);
begin
  if (ind > 0)
        and (ind <= high(FIndArray)) then
          begin
  setlength(FIndArray[Ind].Marriages,high(FIndArray[Ind].Marriages)+2);
  FIndArray[Ind].Marriages[high(FIndArray[Ind].Marriages)]:=marr;
          end;
end;

/// <summary>
/// Clears all data.
/// </summary>
procedure TClsHejIndividuals.Clear;
begin
  if not Assigned(FIndArray) then exit;
  setlength(FIndArray,0);
  FActIndex:=-1;
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

/// <summary>
/// Reads data from stream.
/// </summary>
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

/// <summary>
/// Writes data to stream.
/// </summary>
procedure TClsHejIndividuals.WriteToStream(st: TStream);
var
  i: Integer;
begin
  for i := 1 to high(FIndArray) do
    FIndArray[i].WriteToStream(st);
end;

/// <summary>
/// Reads data from dataset.
/// </summary>
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

/// <summary>
/// Updates the dataset.
/// </summary>
procedure TClsHejIndividuals.UpdateDataset(const ds: TDataSet);
begin

end;

/// <summary>
/// Destructor.
/// </summary>
destructor TClsHejIndividuals.Destroy;
begin
  setlength(FIndArray,0);
  inherited Destroy;
end;

/// <summary>
/// Moves to first record.
/// </summary>
procedure TClsHejIndividuals.First(Sender: TObject);
begin
  if FActIndex= 1 then exit;
  FActIndex:=1;
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

/// <summary>
/// Moves to last record.
/// </summary>
procedure TClsHejIndividuals.Last(Sender: TObject);
begin
  if FActIndex=high(FIndArray) then exit;
  FActIndex:=high(FIndArray);
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

/// <summary>
/// Moves to next record.
/// </summary>
procedure TClsHejIndividuals.Next(Sender: TObject);
begin
  if FActIndex=high(FIndArray) then exit;
  if FActIndex < high(FIndArray) then
    inc(FActIndex);
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

/// <summary>
/// Moves to previous record.
/// </summary>
procedure TClsHejIndividuals.Previous(Sender: TObject);
begin
  if FActIndex<= 1 then exit;
  if FActIndex > 1 then
    dec(FActIndex);
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

/// <summary>
/// Appends a new record.
/// </summary>
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

/// <summary>
/// Edits the current record.
/// </summary>
procedure TClsHejIndividuals.Edit(Sender: TObject);
begin

end;

/// <summary>
/// Posts changes.
/// </summary>
procedure TClsHejIndividuals.Post(Sender: TObject);
begin

end;

/// <summary>
/// Seeks to a specific ID.
/// </summary>
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

/// <summary>
/// Cancels changes.
/// </summary>
procedure TClsHejIndividuals.Cancel(Sender: TObject);
begin

end;

/// <summary>
/// Deletes the current record.
/// </summary>
procedure TClsHejIndividuals.Delete(Sender: Tobject);

begin
  RemovePerson(FActIndex);
end;

/// <summary>
/// Checks if at end of data.
/// </summary>
function TClsHejIndividuals.EOF: boolean;
begin
  result := FactIndex>=High(FIndArray)
end;

/// <summary>
/// Checks if at beginning of data.
/// </summary>
function TClsHejIndividuals.BOF: boolean;
begin
  result := FActIndex<=1;
end;

/// <summary>
/// Gets data as variant.
/// </summary>
function TClsHejIndividuals.GetData: Variant;overload;
begin
  result := null // Todo: Sinnvoll ergänzen
end;

/// <summary>
/// Sets data from variant.
/// </summary>
procedure TClsHejIndividuals.SetData(NewVal: Variant);overload;
begin

end;

/// <summary>
/// Gets the active ID.
/// </summary>
function TClsHejIndividuals.GetActID: integer;
begin
  result := FActIndex;
end;

/// <summary>
/// Gets the on update event.
/// </summary>
function TClsHejIndividuals.GetOnUpdate: TNotifyEvent;
begin
  result := FOnUpdate;
end;

/// <summary>
/// Sets the on update event.
/// </summary>
procedure TClsHejIndividuals.SetOnUpdate(AValue: TNotifyEvent);
begin
  if @FOnUpdate=@AValue then exit;
  FOnUpdate := aValue;
end;

/// <summary>
/// Gets the active individual data.
/// </summary>
function TClsHejIndividuals.GetActualInd: THejIndData;
begin
  result := FIndArray[FActIndex];
end;

/// <summary>
/// Gets the child ID at index for the active individual.
/// </summary>
function TClsHejIndividuals.GetActualChild(index: integer): integer;
begin
  result:= ActualInd.Children[index];
end;

/// <summary>
/// Gets the count of children for the active individual.
/// </summary>
function TClsHejIndividuals.GetActualChildCount: integer;
begin
  result := length( ActualInd.Children)
end;

/// <summary>
/// Gets the marriage ID at index for the active individual.
/// </summary>
function TClsHejIndividuals.GetActualMarriage(index: integer): integer;
begin
  result:= ActualInd.Marriages[index];
end;

/// <summary>
/// Gets the count of marriages for the active individual.
/// </summary>
function TClsHejIndividuals.GetActualMarriageCount: integer;
begin
  result := length( ActualInd.Marriages)
end;

/// <summary>
/// Gets data for an individual and field.
/// </summary>
function TClsHejIndividuals.GetData(ind: integer; idx: TEnumHejIndDatafields
  ): variant;
begin
  if ind=-1 then
    ind := FActIndex;
  if (ind >= 0) and (ind <= high(FIndArray)) then
    result := FIndArray[ind].Data[idx];
end;

/// <summary>
/// Gets the individual data at index.
/// </summary>
function TClsHejIndividuals.GetIndividual(index: integer): THejIndData;
begin
  Seek(index);
  if FActIndex = index then
    result := FIndArray[index];
end;

/// <summary>
/// Gets the total count of individuals.
/// </summary>
function TClsHejIndividuals.GetCount: integer;
begin
  result := high(FIndArray);//!! 0 wird nicht gezählt.
  if result <0 then result :=0;
end;

/// <summary>
/// Appends a child link between individuals.
/// </summary>
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

/// <summary>
/// Removes a person by index.
/// </summary>
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

/// <summary>
/// Tests if the stream header is valid.
/// </summary>
function TClsHejIndividuals.TestStreamHeader(st: Tstream): boolean;
begin
  result := true;
end;

/// <summary>
/// Finds the index of an individual by criteria.
/// </summary>
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

/// <summary>
/// Gets a peek at individual data at index.
/// </summary>
function TClsHejIndividuals.GetPeekIndi(index: integer): THejIndData;
begin
  if index=-1 then
    index:= FActIndex;
   if  (index >=0) and (index <= high(FIndArray)) then
     result := FIndArray[index];
end;

/// <summary>
/// Sets the child ID at index for the active individual.
/// </summary>
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

/// <summary>
/// Gets the birth date as a formatted string.
/// </summary>
function THejIndData.GetBirthDate: String;
begin
  if BirthDay+BirthMonth+BirthYear <> '' then
    result := BirthDay+'.'+BirthMonth+'.'+BirthYear
  else
    result := ''
end;

/// <summary>
/// Gets the data for a specific field.
/// </summary>
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

/// <summary>
/// Gets the death date as a formatted string.
/// </summary>
function THejIndData.GetDeathDate: String;
begin
  if DeathDay+DeathMonth+DeathYear <> '' then
    result := DeathDay+'.'+DeathMonth+'.'+DeathYear
  else
    result := '';
end;

/// <summary>
/// Gets the associated IGenIndividual interface (deprecated).
/// </summary>
function THejIndData.GetiIndi: IGenIndividual; deprecated;
begin
//  if assigned(FIIndi) then
//    result := FIIndi
//  else
    begin

    end;
end;

/// <summary>
/// Reads data from stream (buffered version).
/// </summary>
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

/// <summary>
/// Sets the birth date from a string.
/// </summary>
procedure THejIndData.SetBirthDate(AValue: String);
begin
  // Todo: Implement SetBirthDate
end;

/// <summary>
/// Sets the data for a specific field.
/// </summary>
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

/// <summary>
/// Sets the associated TClsIIndivid instance.
/// </summary>
procedure THejIndData.SetIndivid(AValue: TClsIIndivid);
begin
  if FInd=AValue then Exit;
  FInd:=AValue;
end;

/// <summary>
/// Converts the record to a string representation.
/// </summary>
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

/// <summary>
/// Converts the record to a Pascal struct string.
/// </summary>
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

/// <summary>
/// Gets the number of parents.
/// </summary>
function THejIndData.ParentCount: integer;
begin
    if (abs(idFather)+abs(idMother) = 0)
             then result :=0
             else if (idFather > 0) and (idMother > 0)
             then result := 2
             else result := 1;
end;

/// <summary>
/// Gets the number of children.
/// </summary>
function THejIndData.ChildCount: integer;
begin
  result := length(Children);
end;

/// <summary>
/// Removes a parent by ID.
/// </summary>
procedure THejIndData.RemoveParent(aID: integer);
begin
  if idFather = aID then
    idFather:=0;
  if idMother = aID then
    idMother:=0;
end;

/// <summary>
/// Replaces a parent ID with another.
/// </summary>
procedure THejIndData.ReplaceParent(aID, aID2: integer);
begin
  if idFather = aID then
    idFather:=aID2;
  if idMother = aID then
    idMother:=aID2;
end;

/// <summary>
/// Appends a child ID.
/// </summary>
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

/// <summary>
/// Removes a child by ID.
/// </summary>
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

/// <summary>
/// Deletes a child at a specific index.
/// </summary>
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

/// <summary>
/// Appends a marriage ID.
/// </summary>
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

/// <summary>
/// Removes a marriage by ID.
/// </summary>
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

/// <summary>
/// Deletes a marriage at a specific index.
/// </summary>
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

/// <summary>
/// Gets the number of spouses.
/// </summary>
function THejIndData.SpouseCount: integer;
begin
  result := length(Marriages);
end;

/// <summary>
/// Gets the number of places associated.
/// </summary>
function THejIndData.PlaceCount: integer;
var lIdf :TEnumHejIndDatafields;
begin
  result :=0;
for lIdf in CIndPlacedata do
if Data[lIdf] <> '' then
   result := result+ 1;
end;

/// <summary>
/// Gets the number of sources associated.
/// </summary>
function THejIndData.SourceCount: integer;
var lIdf :TEnumHejIndDatafields;
begin
  result :=0;
for lIdf in CIndSourceData do
if Data[lIdf] <> '' then
   result := result+ 1;
end;

/// <summary>
/// Gets a value representing the individual's date (for sorting).
/// </summary>
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

/// <summary>
/// Gets date data for a specific field.
/// </summary>
function THejIndData.GetDateData(idx: TEnumHejIndDatafields; dtOnly: boolean
  ): string;
begin
  result := HejDate2DateStr(data[idx],
  Data[TEnumHejIndDatafields(ord(idx)+1)],
  Data[TEnumHejIndDatafields(ord(idx)+2)],dtOnly);
end;

/// <summary>
/// Sets date data for a specific field.
/// </summary>
procedure THejIndData.SetDateData(idx: TEnumHejIndDatafields; aValue: string);
var
  lDay, lMonth, lYear: string;
begin
  DateStr2HeyDate(aValue,lDay,lMonth,lYear);
  data[idx]:=lDay;
  Data[TEnumHejIndDatafields(ord(idx)+1)]:=lMonth;
  Data[TEnumHejIndDatafields(ord(idx)+2)]:=lYear;
end;

/// <summary>
/// Clears all data in the record.
/// </summary>
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

/// <summary>
/// Reads data from a stream.
/// </summary>
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

/// <summary>
/// Writes data to a stream.
/// </summary>
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

/// <summary>
/// Reads data from a dataset at a specific index.
/// </summary>
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

/// <summary>
/// Updates the dataset with current data.
/// </summary>
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

/// <summary>
/// Checks if this record equals another.
/// </summary>
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

