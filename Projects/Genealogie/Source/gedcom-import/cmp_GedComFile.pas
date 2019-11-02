unit Cmp_GedComFile;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
{$Interfaces CORBA}

interface

uses Classes, SysUtils, Unt_FileProcs;

type
    TGedComObj = class;
    TGedComObjEnumerator = class;

    { IGedParent }

    IGedParent = interface
        ['{AFA6D380-06CD-41D8-B195-DF54C7308E7E}']
        function appendChild(aChild: TGedComObj): integer;
        procedure RemoveChild(aChild: TGedComObj);
        function GetChildIdx(aChild: TGedComObj): integer;
        function GetChild(Idx: variant): TGedComObj;
        function GetParent: IGedParent;
        function Find(aID: string): TGedComObj;
        function ChildCount: integer;
        function GetEnumerator: TGedComObjEnumerator;
        Procedure EndUpdate;
        procedure ChildUpdate(aChild: TGedComObj);
    end;

    { TGedComObjEnumerator }

    TGedComObjEnumerator = class
    private
        FBaseNode: IGedParent;
        FIter: integer;
        function getCurrent: TGedComObj;
    public
        constructor Create(ATree: IGedParent);
        function MoveNext: boolean;
        property Current: TGedComObj read getCurrent;
    end;


    { TGedComObj }

    TGedComObj = class(IGedParent)
    private
      Fchanged: Boolean;
        FID: integer;
        FNodeID: string;
        FParent: IGedParent;
        FNodeType: string;
        FType:integer;
        FRoot: IGedParent;
        FUpdating:boolean;
        function GetLink: TGedComObj;
        procedure SetID(AValue: integer);
        procedure SetLink(AValue: TGedComObj);
        procedure SetNodeID(AValue: string);
        procedure SetParent(AValue: IGedParent);
        procedure SetRoot(AValue: IGedParent);
    protected
        function GetFtype:integer;
        procedure SetFType(AValue: integer);virtual;
        function GetData: string; virtual;
        procedure SetData(AValue: string); virtual;
        function appendChild(aChild: TGedComObj): integer; virtual;
        procedure RemoveChild(aChild: TGedComObj); virtual;
        function GetChildIdx(aChild: TGedComObj): integer; virtual;
        function GetChild(Idx: variant): TGedComObj; virtual;
        function GetParent: IGedParent;
        function ChildCount: integer; virtual;
        Procedure BeginUpdate;virtual;
        Procedure EndUpdate;virtual;
        procedure ChildUpdate(aChild: TGedComObj); virtual;
    public
        procedure Clear; virtual; abstract;
        destructor Destroy; override;
        constructor Create(const aID, aType: string; const aInfo: string = ''); virtual;
        function ToString: ansistring; override;
        function Description: string; virtual;
        function CreateChild(const aID, aType: string;
            const aInfo: string = ''): TGedComObj; virtual;
        function Find(aType: string): TGedComObj;
        function Equals(aObj: TGedComObj): boolean; overload;
        function Equals(aObj: TGedComObj; const aCompTags: array of string): boolean; overload;
        function GetEnumerator: TGedComObjEnumerator;
        procedure Merge(var aObj: TGedComObj);
        property ID: integer read FID write SetID;
        property Parent: IGedParent read FParent write SetParent;
        property Root: IGedParent read FRoot write SetRoot;
        property Data: string read GetData write SetData;
        property Link: TGedComObj read GetLink write SetLink;
        property NodeType: string read FNodeType write FNodeType;
        property NodeID: string read FNodeID write SetNodeID;
        property Count: integer read ChildCount;
        property Child[Index: variant]: TGedComObj read GetChild; default;
        property TType:integer read Ftype write SetFType;
    public
        class function AssNodeType: string; virtual;
        class function HandlesNodeType({%H-}aType: string): boolean; virtual;
    end;

    TGedObjClass = class of TGedComObj;

    { TGedComDefault }
    TGedComDefault = class(TGedComObj)
        FChildren: array of TGedComObj;
        FInformation: string;
    protected
        function GetData: string; override;
        procedure SetData(AValue: string); override;
        function appendChild(aChild: TGedComObj): integer; override;
        procedure RemoveChild(aChild: TGedComObj); override;
        function GetChildIdx(aChild: TGedComObj): integer; override;
        function GetChild(Idx: variant): TGedComObj; override;
        function ChildCount: integer; override;
    public
        procedure Clear; override;
        constructor Create(const aID, aType: string; const aInfo: string); override;
        class function HandlesNodeType({%H-}aType: string): boolean; override;
    end;

    { TGedComFile }

    TGedComFile = class(CFileInfo, IGedParent)
    private
        FChanged: boolean;
        FChildren: array of TGedComObj;
        FEncoding: string;
        FIdx: TStringList;
        FOnChildUpdate: TNotifyEvent;
        FOnUpdate: TNotifyEvent;
        FonLongOp:TNotifyEvent;
        FOnWriteUpdate: TNotifyEvent;
        procedure OnReadUpdate(Sender: TObject);
        class function ParseLine(const Line: string;
            out NodeID, NodeType, Information: string): integer;
        class var FGedComObjects: array of TGedObjClass;
        procedure SetEncoding(AValue: string);
        procedure SetOnChildUpdate(AValue: TNotifyEvent);
        procedure SetOnLongOp(AValue: TNotifyEvent);
        procedure SetOnUpdate(AValue: TNotifyEvent);
        procedure SetOnWriteUpdate(AValue: TNotifyEvent);
    protected
        function appendChild(aChild: TGedComObj): integer; virtual;
        procedure RemoveChild(aChild: TGedComObj); virtual;
        function GetChildIdx(aChild: TGedComObj): integer; virtual;
        function GetChild(Idx: variant): TGedComObj;
        function GetParent: IGedParent;
        function ChildCount: integer;
        procedure ChildUpdate(aChild: TGedComObj); virtual;
        Procedure EndUpdate;
    public
        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        constructor Create;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        destructor Destroy; override;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        class function GetFileInfoStr(Path: string; Force: boolean = False): string;
            override;
        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        class function DisplayName: string;
            override;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
{$ifdef SUPPORTS_GENERICS}
        class function Extensions: Tarray<string>;
{$else}
        class function Extensions: TStringArray;
{$endif}
            override;
        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        class procedure RegisterGedComClass(aGCClass: TGedObjClass);

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        class function ParseGed(const Lines: TStrings; gcBase: IGedParent; OnUpd,
          OnLongOp: TNotifyEvent): IGedParent;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        class procedure PutGed(const Lines: TStrings; gcBase: IGedParent; OnUpd,
          OnLongOp: TNotifyEvent);

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        class function NewNode(aNodeID, aNodeType: string; aValue: string = ''): TGedComObj;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        procedure LoadFromStream(st: TStream);

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        procedure WriteToStream(st: TStream);

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        procedure Clear;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        procedure AppendIndex(const aIdx: string; const aGedObj: TGedComObj);
        function GetEnumerator: TGedComObjEnumerator;
        function CreateChild(const aID, aType: string; const aInfo: string = ''): TGedComObj;
        function Find(aID: string): TGedComObj;
        procedure Merge(aObj1: TGedComObj; var aObj2: TGedComObj);
        property Count: integer read ChildCount;
        property Child[idx: variant]: TGedComObj read GetChild; default;
        property OnUpdate: TNotifyEvent read FOnUpdate write SetOnUpdate;
        property OnLongOp: TNotifyEvent read FOnLongOp write SetOnLongOp ;
        property OnWriteUpdate: TNotifyEvent read FOnWriteUpdate write SetOnWriteUpdate;
        property Encoding: string read FEncoding write SetEncoding;
        property OnChildUpdate: TNotifyEvent read FOnChildUpdate write SetOnChildUpdate;
    end;

    {---------------------------------------------------------------------}
    // Special Classes as Container of GedCom-Objects
    { TMultiGedObj }
    TGedMulti = class(TGedComDefault)
        // Todo: GedObject, Dessen Informationen an mehreren Stellen verwendet wird
    end;

    { TGedPlace }

    TGedPlace = class(TGedMulti)
    private
        FLatitude: string;
        FLongitude: string;
        FName: string;
        FMap: TGedComObj;
        procedure SetLatitude(AValue: string);
        procedure SetLongitude(AValue: string);
        procedure SetName(AValue: string);
    published
        property Name: string read FName write SetName;
        property FullName: string read GetData write SetData;
        property Longitude: string read FLongitude write SetLongitude;
        property Latitude: string read FLatitude write SetLatitude;
    protected
        procedure ChildUpdate(aChild: TGedComObj); override;
    public
        function ToString: ansistring; override;
        function Description: string; override;
        class function AssNodeType: string; override;
        class function HandlesNodeType(aType: string): boolean; override;
    end;

    { TGedEvent }

    TGedEvent = class(TGedComDefault)
    private
        FDate: TGedComObj;
        FPlace: TGedPlace;
        FSource: TGedComObj;
        function GetDate: string;
        procedure SetDate(AValue: string);
        procedure SetPlace(AValue: TGedPlace);
        procedure SetSource(AValue: TGedComObj);
    published
        property Date: string read GetDate write SetDate;
        property Place: TGedPlace read FPlace write SetPlace;
        property Source: TGedComObj read FSource write SetSource;
    protected
        procedure ChildUpdate(aChild: TGedComObj); override;
    public
        function ToString: ansistring; override;
        function Description: string; override;
        class function AssNodeType: string; override;
        class function HandlesNodeType(aType: string): boolean; override;
    end;

    { TIndName }

    TIndName = class(TGedComDefault)
    private
        FCallName: string;
        FGivenName: string;
        FNameSuffix: string;
        Fnext: TGedComObj;
        FSurname: string;
        FTitle: string;
        Fsource: TGedComObj;

        procedure SetCallName(AValue: string);
        procedure SetFSource(AValue: TGedComObj);
        procedure SetGivenName(AValue: string);
        procedure SetNameSuffix(AValue: string);
        procedure SetSurname(AValue: string);
        procedure SetTitle(AValue: string);
    protected
        procedure SetData(AValue: string); override;
    published
        property FullName: string read GetData write SetData;
        property Surname: string read FSurname write SetSurname;
        property GivenName: string read FGivenName write SetGivenName;
        property CallName: string read FCallName write SetCallName;
        property NameSuffix: string read FNameSuffix write SetNameSuffix;
        property Title: string read FTitle write SetTitle;
        property Source: TGedComObj read FSource write SetFSource;
    public
        constructor Create(const aID, aType: string; const aInfo: string); override;
        function ToString: ansistring; override;
        function Description: string; override;
        procedure HandleAdditional(aPartner: TGedComObj);
        class function AssNodeType: string; override;
        class function HandlesNodeType(aType: string): boolean; override;
    end;

    { TGedIndividual }

    TGedIndividual = class(TGedComDefault)
    private
        FBaptised: TGedEvent;
        FBirth: TGedEvent;
        FBurial: TGedEvent;
        FDeath: TGedEvent;
        FFather: TGedIndividual;
        FMother: TGedIndividual;
        FName: TIndName;
        FReligion: TGedEvent;
        FSex: TGedEvent;
        Fspouses:array of TGedComObj;
        FChilds:array of TGedComObj;
        function GetChildCount: integer;
        function GetChildren(Idx: variant): TGedIndividual;
        function GetSpouseCount: integer;
        function GetSpouses(Idx: variant): TGedIndividual;
        procedure SetBaptised(AValue: TGedEvent);
        procedure SetBirth(AValue: TGedEvent);
        procedure SetBurial(AValue: TGedEvent);
        procedure SetChildren(Idx: variant; AValue: TGedIndividual);
        procedure SetDeath(AValue: TGedEvent);
        procedure SetFather(AValue: TGedIndividual);
        procedure SetMother(AValue: TGedIndividual);
        procedure SetName(AValue: TIndName);
        procedure SetSpouses(Idx: variant; AValue: TGedIndividual);
    published
        property Name: TIndName read FName write SetName;
        property Birth: TGedEvent read FBirth write SetBirth;
        property Baptised: TGedEvent read FBaptised write SetBaptised;
        property Death: TGedEvent read FDeath write SetDeath;
        property Burial: TGedEvent read FBurial write SetBurial;
        property Father: TGedIndividual read FFather write SetFather;
        property Mother: TGedIndividual read FMother write SetMother;
        property Spouses[Idx: variant]: TGedIndividual read GetSpouses write SetSpouses;
        property SpouseCount:integer read GetSpouseCount;
        property Children[Idx: variant]: TGedIndividual read GetChildren write SetChildren;
        property ChildCount:integer read GetChildCount;
    protected
        procedure ChildUpdate(aChild: TGedComObj); override;
    public
        constructor Create(const aID, aType: string; const aInfo: string); override;
        function ToString: ansistring; override;
        function Description: string; override;
        class function AssNodeType: string; override;
        class function HandlesNodeType(aType: string): boolean; override;
    end;


implementation

uses Unt_StringProcs, LConvEncoding, variants;

resourcestring
    rsGenealogieExchangeFile = 'Genealogie-Exchange-File';

{ TGedPlace }
const
    CPlace = 'PLAC';
    CPaceMap = 'MAP';
    CPlaceMapLong = 'LONG';
    CPlaceMapLati = 'LATI';
    CIndividual = 'INDI';
    CEventDate = 'DATE';
    CEventSource = 'SOUR';
    CEventBirth = 'BIRT';
    CEventBaptism = 'BAPM';
    CEventDeath = 'DEAT';
    CEventBurial = 'BURI';
    CEventMarriage = 'MARR';
    CFactOccupation = 'OCCU';
    CFactName = 'NAME';
    CFactSex = 'SEX';
    CFactReligion = 'RELI';

{ TIndName }

procedure TIndName.SetCallName(AValue: string);
begin
    if FCallName = AValue then
        Exit;
    FCallName := AValue;
end;

procedure TIndName.SetFSource(AValue: TGedComObj);
begin
    if FSource = AValue then
        Exit;
    FSource := AValue;
end;

procedure TIndName.SetGivenName(AValue: string);
begin
    if FGivenName = AValue then
        Exit;
    FGivenName := AValue;
end;

procedure TIndName.SetNameSuffix(AValue: string);
begin
    if FNameSuffix = AValue then
        Exit;
    FNameSuffix := AValue;
end;

procedure TIndName.SetSurname(AValue: string);
begin
    if FSurname = AValue then
        Exit;
    FSurname := AValue;
end;

procedure TIndName.SetTitle(AValue: string);
begin
    if FTitle = AValue then
        Exit;
    FTitle := AValue;
end;

procedure TIndName.SetData(AValue: string);
var
    lpp: integer;
begin
    lpp := AValue.IndexOf('/');
    if lpp >= 0 then
      begin
        FGivenName := LeftStr(AValue, lpp);
        FSurname := Copy(avalue, lpp + 1).DeQuotedString('/');
      end;
    inherited SetData(AValue);
end;

constructor TIndName.Create(const aID, aType: string; const aInfo: string);
begin
    inherited Create(aID, aType, aInfo);
    Fsource := nil;
    Fnext := nil;
end;

function TIndName.ToString: ansistring;
begin
    Result := 'N: ' + Data;
end;

function TIndName.Description: string;
begin
    Result := 'Name: ' + Data;
    if assigned(FSource) then
        Result := Result + ' Q:(' + FSource['PAGE'].Data + ')';
end;

procedure TIndName.HandleAdditional(aPartner: TGedComObj);
begin
    if aPartner = self then
        exit;
    if not assigned(Fnext) then
        Fnext := aPartner
    else if aPartner <> self then
        TIndName(Fnext).HandleAdditional(aPartner);
end;

class function TIndName.AssNodeType: string;
begin
    Result := CFactName;
end;

class function TIndName.HandlesNodeType(aType: string): boolean;
begin
    Result := aType = CFactName;
end;

{ TGedComDefault }

function TGedComDefault.GetData: string;
begin
    Result := FInformation;
end;

procedure TGedComDefault.SetData(AValue: string);
begin
    if FInformation = AValue then
        exit;
    FInformation := AValue;
    if Assigned(Parent) then
        Parent.ChildUpdate(self);
end;

function TGedComDefault.appendChild(aChild: TGedComObj): integer;
var
    i: integer;
begin
    if not assigned(aChild) then
        exit(-1);
    i := GetChildIdx(aChild);
    if i >= 0 then
        exit(i);
    setlength(FChildren, high(FChildren) + 2);
    Result := high(FChildren);
    FChildren[Result] := aChild;
    aChild.ID := Result;
    if aChild.Parent <> iGedparent(self) then
        aChild.Parent := self;
    aChild.Root := froot;
end;

procedure TGedComDefault.RemoveChild(aChild: TGedComObj);
var
    i, lidx: integer;
    Flag: boolean;
begin
    lidx := GetChildIdx(aChild);
    Flag := lidx >= 0;
    if flag then
      begin
        // This keeps the order;
        BeginUpdate;
        for i := lidx + 1 to high(FChildren) do
          begin
            FChildren[i - 1] := FChildren[i];
            FChildren[i - 1].ID := i - 1;
          end;
        // Faster but shuffeling:
        //  FChildren[lIdx] := FChildren[high(FChildren)];
        //   FChildren[lidx].ID := lidx;
        setlength(FChildren, high(FChildren));
        aChild.Parent := nil;
        EndUpdate;
      end;
end;

function TGedComDefault.GetChildIdx(aChild: TGedComObj): integer;
var
    i: integer;
begin
    Result := -1;
    if not assigned(aChild) then
        exit;
    if aChild.Parent <> IGedParent(self) then
        exit;
    if (achild.id >= 0) and (aChild.id <= high(FChildren)) and
        (FChildren[achild.id] = aChild) then
        exit(aChild.id);
    for i := 0 to high(FChildren) do
        if FChildren[i] = aChild then
            exit(i);
end;

function TGedComDefault.GetChild(Idx: variant): TGedComObj;
begin
    if VarIsOrdinal(Idx) then
        Result := FChildren[idx]
    else if VarIsStr(Idx) then
      begin
        Result := Find(Idx);
        if not Assigned(Result) then
            Result := CreateChild('', Idx, '');
      end;
end;

constructor TGedComDefault.Create(const aID, aType: string; const aInfo: string);
begin
    inherited;
    FInformation := aInfo;
end;

function TGedComDefault.ChildCount: integer;
begin
    Result := Length(FChildren);
end;

procedure TGedComDefault.Clear;
var
    i: integer;
begin
    for i := high(FChildren) downto 0 do
        FreeAndNil(FChildren[i]);
    setlength(FChildren, 0);
end;

class function TGedComDefault.HandlesNodeType(aType: string): boolean;
begin
    Result := True; // Can handle all kind of Nodes
end;

{ TGedEvent }

procedure TGedEvent.SetDate(AValue: string);
begin
    if assigned(FDate) then
        FDate.Data := AValue
    else
        Child[CEventDate].Data := AValue;
end;

function TGedEvent.GetDate: string;
begin
    if assigned(FDate) then
        Result := FDate.Data
    else
        Result := '';
end;

procedure TGedEvent.SetPlace(AValue: TGedPlace);
begin
    if FPlace = AValue then
        Exit;
    FPlace := AValue;
end;

procedure TGedEvent.SetSource(AValue: TGedComObj);
begin
    if FSource = AValue then
        Exit;
    FSource := AValue;
end;

procedure TGedEvent.ChildUpdate(aChild: TGedComObj);
begin
    if aChild.NodeType = CEventDate then
        FDate := aChild
    else if aChild.NodeType = CPlace then
        FPlace := TGedPlace(aChild)
    else if aChild.NodeType = CEventSource then
        FSource := aChild;
    inherited;
end;

function TGedEvent.ToString: ansistring;
begin
    Result := 'E: ' + NodeType;
    if assigned(FDate) then
        Result := Result + ': ' + FDate.Data;
    if assigned(FPlace) then
        Result := Result + ' in ' + FPlace.Data;
end;

function TGedEvent.Description: string;
begin
    Result := 'Event: ' + NodeType;
    if assigned(FDate) then
        Result := Result + ' am ' + FDate.Data;
    if assigned(FPlace) then
        Result := Result + ' in ' + FPlace.Data;
    if Data <> '' then
        Result := Result + ' (' + Data + ')';
    if assigned(FSource) then
        Result := Result + ' Q:(' + FSource['PAGE'].Data + ')';
end;

class function TGedEvent.AssNodeType: string;
begin
    Result := '';
end;

class function TGedEvent.HandlesNodeType(aType: string): boolean;
begin
    Result := (atype = CEventBirth) or (atype = CEventBaptism) or
        (atype = CEventDeath) or (atype = CEventBurial);
end;

{ TGedIndividual }

function TGedIndividual.GetChildren(Idx: variant): TGedIndividual;
begin
    // Todo:
    Result := nil;
end;

function TGedIndividual.GetChildCount: integer;
begin
  result := Length(FChilds);
end;

function TGedIndividual.GetSpouseCount: integer;
begin
    result := Length(FSpouses);
end;

function TGedIndividual.GetSpouses(Idx: variant): TGedIndividual;
begin
    // Todo:
    Result := nil;
end;

procedure TGedIndividual.SetBaptised(AValue: TGedEvent);
begin
    if FBaptised = AValue then
        Exit;
    FBaptised := AValue;
end;

procedure TGedIndividual.SetBirth(AValue: TGedEvent);
begin
    if FBirth = AValue then
        Exit;
    FBirth := AValue;
end;

procedure TGedIndividual.SetBurial(AValue: TGedEvent);
begin
    if FBurial = AValue then
        Exit;
    FBurial := AValue;
end;

procedure TGedIndividual.SetChildren(Idx: variant; AValue: TGedIndividual);
begin

end;

procedure TGedIndividual.SetDeath(AValue: TGedEvent);
begin
    if FDeath = AValue then
        Exit;
    FDeath := AValue;
end;

procedure TGedIndividual.SetFather(AValue: TGedIndividual);
begin
    if FFather = AValue then
        Exit;
    FFather := AValue;
end;

procedure TGedIndividual.SetMother(AValue: TGedIndividual);
begin
    if FMother = AValue then
        Exit;
    FMother := AValue;
end;

procedure TGedIndividual.SetName(AValue: TIndName);
begin
    if FName = AValue then
        Exit;
    FName := AValue;
end;

procedure TGedIndividual.SetSpouses(Idx: variant; AValue: TGedIndividual);
begin

end;

procedure TGedIndividual.ChildUpdate(aChild: TGedComObj);
begin
    if (aChild.NodeType = CFactName) and not assigned(aChild.find('TYPE')) then
        if assigned(Fname) and (Fname.Parent = IGedParent(self)) then
            FName.HandleAdditional(aChild)
        else
            Fname := TIndName(aChild)
    else if aChild.NodeType = CFactSex then
        FSex := TGedEvent(aChild)
    else if aChild.NodeType = CFactReligion then
        FReligion := TGedEvent(aChild)
    else if aChild.NodeType = CEventBirth then
        FBirth := TGedEvent(aChild)
    else if aChild.NodeType = CEventBaptism then
        FBaptised := TGedEvent(aChild)
    else if aChild.NodeType = CEventDeath then
        FDeath := TGedEvent(aChild)
    else if aChild.NodeType = CEventBurial then
        FBurial := TGedEvent(aChild);
    inherited;
end;

constructor TGedIndividual.Create(const aID, aType: string; const aInfo: string);
begin
    inherited Create(aID, aType, aInfo);
    FName := nil;
    FFather := nil;
    FMother := nil;
    FBirth := nil;
    FBaptised := nil;
    FSex := nil;
    FReligion := nil;
    FDeath := nil;
    FBurial := nil;
end;

function TGedIndividual.ToString: ansistring;
begin
    Result := 'I: ';
    if assigned(FName) then
        Result := Result + FName.Data
    else
        Result := Result + NodeID;
    if assigned(Fsex) then
        Result := Result + ', ' + Fsex.Data;
    if assigned(FBirth) then
        Result := Result + ', ' + FBirth.ToString
    else
    if assigned(FBaptised) then
        Result := Result + ', ' + FBaptised.ToString;
end;

function TGedIndividual.Description: string;
begin
    Result := 'Person: ';
    if assigned(FName) then
        Result := Result + FName.Data
    else
        Result := Result + NodeID;
    if assigned(Fsex) then
        Result := Result + LineEnding + 'Sex: ' + Fsex.Data;
    if assigned(FBirth) then
        Result := Result + LineEnding + FBirth.Description;
    if assigned(FBaptised) then
        Result := Result + LineEnding + FBaptised.Description;
    if assigned(FReligion) then
        Result := Result + LineEnding + 'Religion: ' + FReligion.Data;
    if assigned(FDeath) then
        Result := Result + LineEnding + FDeath.Description;
    if assigned(FBurial) then
        Result := Result + LineEnding + FBurial.Description;
end;

class function TGedIndividual.AssNodeType: string;
begin
    Result := CIndividual;
end;

class function TGedIndividual.HandlesNodeType(aType: string): boolean;
begin
    Result := aType = CIndividual;
end;

procedure TGedPlace.SetName(AValue: string);
var
    lRest: string;
    lpp: integer;
begin
    if FName = AValue then
        Exit;
    if FName = Leftstr(Data, length(FName)) then
        lRest := copy(Data, length(FName) + 1)
    else
      begin
        lpp := Data.indexof(',');
        if lpp >= 0 then
            lRest := copy(Data, lpp + 1)
        else
            lRest := '';
      end;
    FName := AValue;
    Data := Fname + lRest;
end;

procedure TGedPlace.ChildUpdate(aChild: TGedComObj);
begin
    FMap := Find(CPaceMap);
    if assigned(Fmap) and assigned(Fmap.Find(CPlaceMapLati)) then
        FLatitude := FMap[CPlaceMapLati].Data;
    if assigned(Fmap) and assigned(Fmap.Find(CPlaceMapLong)) then
        FLongitude := FMap[CPlaceMapLong].Data;
    inherited;
end;

function TGedPlace.ToString: ansistring;
begin
    Result := 'Place: ' + Data;
end;

function TGedPlace.Description: string;
begin
    Result := 'Place: ' + Data;
    if Latitude <> '' then
        Result := Result + ' (' + Latitude + '; ' + Longitude + ')';
end;

class function TGedPlace.AssNodeType: string;
begin
    Result := CPlace;
end;

class function TGedPlace.HandlesNodeType(aType: string): boolean;
begin
    Result := aType = CPlace;
end;

procedure TGedPlace.SetLatitude(AValue: string);
begin
    if FLatitude = AValue then
        Exit;
    FLatitude := AValue;
    if assigned(Fmap) then
        FMap[CPlaceMapLati].Data := AValue
    else
        self[CPaceMap][CPlaceMapLati].Data := Avalue;
end;

procedure TGedPlace.SetLongitude(AValue: string);
begin
    if FLongitude = AValue then
        Exit;
    FLongitude := AValue;
    if assigned(Fmap) then
        FMap[CPlaceMapLong].Data := AValue
    else
        self[CPaceMap][CPlaceMapLong].Data := Avalue;
end;

{ TGedComObjEnumerator }

function TGedComObjEnumerator.getCurrent: TGedComObj;
begin
    Result := FBaseNode.GetChild(FIter);
end;

constructor TGedComObjEnumerator.Create(ATree: IGedParent);
begin
    FBaseNode := Atree;
    FIter := -1;
end;

function TGedComObjEnumerator.MoveNext: boolean;
begin
    Result := Fiter < FBaseNode.ChildCount - 1;
    if Result then
        Inc(Fiter);
end;

{ TGedComObj }

procedure TGedComObj.SetParent(AValue: IGedParent);
begin
    if FParent = AValue then
        Exit;
    if assigned(FParent) then
        FParent.RemoveChild(self);
    FParent := AValue;
    if assigned(FParent) then
      begin
        FID := FParent.appendChild(self);
        FParent.ChildUpdate(self);
      end;
end;

function TGedComObj.GetFtype: integer;
begin
  result:= FType;
end;

procedure TGedComObj.SetRoot(AValue: IGedParent);
begin
    if @FRoot = @AValue then
        Exit;
    FRoot := AValue;
end;

procedure TGedComObj.SetNodeID(AValue: string);
begin
    if FNodeID = AValue then
        Exit;
    FNodeID := AValue;
end;

function TGedComObj.GetData: string;
begin
    Result := '';
end;

function TGedComObj.GetLink: TGedComObj;
begin
    if copy(GetData, 1, 1) = '@' then
        Result := FRoot.Find(GetData)
    else
        Result := nil;
end;

procedure TGedComObj.SetData(AValue: string);
begin

end;

procedure TGedComObj.SetID(AValue: integer);
begin
    if FID = AValue then
        Exit;
    if not assigned(parent) then
        FiD := -1
    else if parent.GetChild(AValue) = self then
        FID := AValue;
end;

procedure TGedComObj.SetFType(AValue: integer);
begin
  if Ftype=AValue then Exit;
  Ftype:=AValue;
end;

procedure TGedComObj.SetLink(AValue: TGedComObj);
begin
    if assigned(AValue) and (AValue.Parent = fRoot) then
        SetData(AValue.NodeID);
end;

function TGedComObj.appendChild(aChild: TGedComObj): integer;
begin
    Result := -1;
end;

procedure TGedComObj.RemoveChild(aChild: TGedComObj);
begin
end;

function TGedComObj.GetChildIdx(aChild: TGedComObj): integer;
begin
    Result := -1;
end;

function TGedComObj.GetChild(Idx: variant): TGedComObj;
begin
    Result := nil;
end;

function TGedComObj.GetParent: IGedParent;
begin
    Result := FParent;
end;

function TGedComObj.ChildCount: integer;
begin
    Result := 0;
end;

procedure TGedComObj.BeginUpdate;
begin
  FUpdating:=true;
end;

procedure TGedComObj.EndUpdate;
var
  lChlds: TGedComObj;
begin
  if not FUpdating then Exit;
  for lChlds in self do
    lChlds.EndUpdate;
  FUpdating:=false;
  if Fchanged and  Assigned(parent) then
    Parent.ChildUpdate(self);
  FChanged:=False;
end;

procedure TGedComObj.ChildUpdate(aChild: TGedComObj);
begin
    if Assigned(parent)and not FUpdating then
      begin
        FChanged:=False;
        Parent.ChildUpdate(self)
      end
    else
      Fchanged:=true;
end;

destructor TGedComObj.Destroy;
begin
    Clear;
end;

constructor TGedComObj.Create(const aID, aType: string; const aInfo: string);
begin
    inherited Create;
    FNodeType := aType;
    FNodeID := aID;
    FID := -1;
    FParent := nil;
end;

function TGedComObj.ToString: ansistring;
begin
    Result := FNodeType;
    if FNodeID <> '' then
        Result := FNodeID + ' ' + Result;
    if GetData <> '' then
        Result := Result + ' ' + GetData;
end;

function TGedComObj.Description: string;
begin
    Result := toString;
end;

function TGedComObj.CreateChild(const aID, aType: string;
    const aInfo: string): TGedComObj;
begin
    Result := TGedComFile.NewNode(aid, atype, ainfo);
    appendChild(Result);
end;

function TGedComObj.Find(aType: string): TGedComObj;
var
    lobj: TGedComObj;
begin
    Result := nil;
    for lobj in self do
        if lobj.FNodeType = atype then
            exit(lobj);
end;

function TGedComObj.Equals(aObj: TGedComObj): boolean;
var
    lChild: TGedComObj;
begin
    Result := assigned(aObj) and (NodeType = aObj.NodeType) and (getdata = aobj.Data);
    if Result then
        // if lChild.Count>length(FChildren)
        for lChild in aObj do
            if lChild.NodeType <> CEventSource then
                Result := Result and lChild.Equals(find(lChild.NodeType));
end;

function TGedComObj.Equals(aObj: TGedComObj;
    const aCompTags: array of string): boolean;

var
    aTag: string;
    lTestOrg, lTestCmp: TGedComObj;
begin
    Result := assigned(aObj) and (NodeType = aObj.NodeType) and (GetData = aobj.Data);
    if Result then  // if length(aCompTags) <= length(FChildren)
        for aTag in aCompTags do
          begin
            lTestOrg := find(aTag);
            lTestCmp := aObj.Find(aTag);
            if assigned(lTestOrg) then
                Result := lTestOrg.equals(lTestCmp)
            else
                Result := not assigned(lTestCmp);
            if not Result then
                break;
          end;
end;

procedure TGedComObj.Merge(var aObj: TGedComObj);
var
    i: integer;
    lCild: TGedComObj;
    lLink, lOrgCh: TGedComObj;
begin
    // Prüfe, daß beide Objekte den selben Root, Parent und Typ haben
    if assigned(aObj) and (aobj.root = FRoot) and (self <> aobj) and
        (FNodeType = aobj.NodeType) then
      begin
        // Lösche gleiche Nodes in aObj2
        for i := aobj.ChildCount - 1 downto 0 do
          begin
            lCild := aObj[i];
            lOrgCh := Find(lCild.FNodeType);
            if not lCild.Data.StartsWith('@') and
                assigned(lOrgCh) and lOrgCh.Equals(lCild) then
                lOrgCh.merge(lCild);
            if assigned(lCild) then
                lCild.Parent := self;
          end;
        aObj.parent.RemoveChild(aobj);
        FreeAndNil(aobj);
      end;
end;

function TGedComObj.GetEnumerator: TGedComObjEnumerator;
begin
    Result := TGedComObjEnumerator.Create(self);
end;

class function TGedComObj.AssNodeType: string;
begin
    Result := '';
end;

class function TGedComObj.HandlesNodeType(aType: string): boolean;
begin
    Result := False;
end;

{ TGedComFile }

class function TGedComFile.ParseLine(const Line: string;
    out NodeID, NodeType, Information: string): integer;
var
    ep: SizeInt;
    sp: integer;
begin
    NodeID := '';
    NodeType := '';
    Information := '';
    Result := -1;
    if trystrtoint(trim(copy(Line, 1, 2)), Result) then
      begin
        sp := 3;
        if copy(line, 3, 1) = '@' then
          begin
            ep := pos(' ', line, sp + 1);
            NodeID := copy(line, sp, ep - sp);
            sp := ep + 1;
          end
        else if Result > 9 then
            Inc(sp);
        ep := pos(' ', line, sp + 1);
        if ep = 0 then
            ep := length(line) + 1;
        NodeType := copy(line, sp, ep - sp);
        Information := copy(Line, ep + 1, length(Line));
      end;
end;

procedure TGedComFile.SetOnUpdate(AValue: TNotifyEvent);
begin
    if @FOnUpdate = @AValue then
        Exit;
    FOnUpdate := AValue;
end;

procedure TGedComFile.SetEncoding(AValue: string);
var
    lCharNode: TGedComObj;
begin
    if FEncoding = AValue then
        Exit;
    FEncoding := AValue;
    if (high(FChildren) >= 0) then
        FChildren[0]['CHAR'].Data := AValue;
end;

procedure TGedComFile.SetOnChildUpdate(AValue: TNotifyEvent);
begin
    if @FOnChildUpdate = @AValue then
        Exit;
    FOnChildUpdate := AValue;
end;

procedure TGedComFile.SetOnLongOp(AValue: TNotifyEvent);
begin
  if @FOnLongOp=@AValue then Exit;
  FOnLongOp:=AValue;
end;

procedure TGedComFile.SetOnWriteUpdate(AValue: TNotifyEvent);
begin
    if @FOnWriteUpdate = @AValue then
        Exit;
    FOnWriteUpdate := AValue;
end;

procedure TGedComFile.OnReadUpdate(Sender: TObject);
begin
    if Sender.InheritsFrom(TGedComObj) then
        with Sender as TGedComObj do
          begin
            if NodeID <> '' then
                AppendIndex(NodeID, Sender as TGedComObj);
          end;
    if assigned(FOnUpdate) then
        FOnUpdate(Sender);
end;

class function TGedComFile.NewNode(aNodeID, aNodeType: string;
    aValue: string): TGedComObj;

var
    i, lGedObj: integer;
begin
    lGedObj := -1;
    for i := high(FGedComObjects) downto 0 do
        if FGedComObjects[i].HandlesNodeType(aNodeType) then
          begin
            lGedObj := i;
            break;
          end;
    if lGedObj >= 0 then
        Result := FGedComObjects[lGedObj].Create(aNodeId, aNodeType, aValue)
    else
        Result := TGedComDefault.Create(aNodeId, aNodeType, aValue);
end;

class function TGedComFile.ParseGed(const Lines: TStrings; gcBase: IGedParent;
    OnUpd,OnLongOp: TNotifyEvent): IGedParent;

var
    ActLevel: integer;
    actVar: array of IGedParent;
    lTime: QWord;

    procedure AppendLine(const Line: string);

    var
        LineLevel, i, LGedObj: integer;
        newvar: TGedComObj;
        lNodeID, lNodeType, lInformation: string;

    begin
        LineLevel := ParseLine(Line, lNodeID, lNodeType, lInformation);
        if (LineLevel >= 0) and (LineLevel <= ActLevel + 1) then
          begin
            if LineLevel = ActLevel + 1 then
                setlength(actVar, LineLevel + 2);
            newvar := NewNode(lNodeId, lNodeType, lInformation);
            newvar.BeginUpdate;
            newvar.Parent := actVar[LineLevel];
            if (lNodeID <> '') and assigned(OnUpd) then
                OnUpd(newvar);
            if  assigned(OnLongOp) and (GetTickCount64-lTime>100) then
                begin
                  onLongOp(NewVar);
                  lTime := GetTickCount64;
                end;
            while ActLevel>LineLevel do
              begin
                actVar[ActLevel+1].EndUpdate;
                dec(ActLevel)
              end;
            actVar[LineLevel + 1] := newvar;
            ActLevel := LineLevel;
          end;
    end;

var

    I: integer;

begin
    ActLevel := -1;
    setlength(actVar, 1);
    if assigned(gcBase) then
        actVar[0] := gcBase
    else
        actvar[0] := TGedComDefault.Create('', '_BASE', '');
    lTime := GetTickCount64;
    for I := 0 to Lines.Count - 1 do
        AppendLine(Lines[i]);
    Result := actVar[0];
end;

class function BuildgedcomLine(Level: integer; const lActChild: TGedComObj): string;
begin
    Result := IntToStr(Level);
    if lActChild.NodeID <> '' then
        Result := Result + ' ' + lActChild.NodeID;
    Result := Result + ' ' + lActChild.NodeType;
    if lActChild.Data <> '' then
        Result := Result + ' ' + lActChild.Data;
end;

class procedure TGedComFile.PutGed(const Lines: TStrings; gcBase: IGedParent;
    OnUpd,OnLongOp: TNotifyEvent);

var
  lTime: QWord;

    procedure IterateParent(const Lines: TStrings; gcParent: IGedParent; Level: integer);

    var
        lActChild: TGedComObj;
        i: integer;
    begin
        for i := 0 to gcParent.ChildCount - 1 do
          begin
            lActChild := gcParent.GetChild(i);
            Lines.Append(BuildgedcomLine(Level, lActChild));
            IterateParent(Lines, lActChild, Level + 1);
            if assigned(OnUpd) and (Level = 0) then
                OnUpd(lActChild);
            if assigned(onLongOp) and (GetTickCount64-ltime>100) then
              begin
                onLongOp(lActChild);
                lTime:=GetTickCount64;
              end
          end;
    end;

begin
  lTime:=GetTickCount64;
    IterateParent(Lines, gcBase, 0);
end;

procedure TGedComFile.LoadFromStream(st: TStream);
var
    lst: string;
    lsl: TStringList;
    lbEncoded: boolean;
begin
    Clear;
    setlength(lst, st.Size);
    st.ReadBuffer(lst[1], st.Size);
    FEncoding := GuessEncoding(lst);
    lsl := TStringList.Create;
      try
        lsl.Text := ConvertEncodingToUTF8(lst, FEncoding, lbEncoded);
        ParseGed(lsl, self, OnReadUpdate,FonLongOp);
      finally
        FreeAndNil(lsl)
      end;
    FChanged := False;
end;

procedure TGedComFile.WriteToStream(st: TStream);

var
    lsl: TStringList;
    lst: string;
    lbEncoded: boolean;
begin
    lsl := TStringList.Create;
      try
        PutGed(lsl, self, FOnWriteUpdate,FonLongOp);
        if FEncoding <> '' then
            lst := ConvertEncodingFromUTF8(lsl.Text, FEncoding, lbEncoded)
        else
            lst := lsl.Text;
        st.WriteBuffer(lst[1], length(lst));
      finally
        FreeAndNil(lsl);
      end;
end;

procedure TGedComFile.Clear;
var
    i: integer;
begin
    for i := high(FChildren) downto 0 do
        FreeAndNil(FChildren[i]);
    setlength(FChildren, 0);
    Fidx.Clear;
end;

procedure TGedComFile.AppendIndex(const aIdx: string; const aGedObj: TGedComObj);
begin
    Fidx.AddObject(aIdx, aGedObj);
end;

function TGedComFile.CreateChild(const aID, aType: string;
    const aInfo: string): TGedComObj;
begin
    Result := NewNode(aid, atype, ainfo);
    AppendIndex(aID, Result);
    appendChild(Result);
end;

function TGedComFile.Find(aID: string): TGedComObj;
var
    lIDx: integer;
begin
    if aID = 'HEAD' then
        exit(FChildren[0]);
    lIDx := FIdx.IndexOf(aID);
    if lIDx >= 0 then
        Result := TGedComObj(FIdx.Objects[lIDx])
    else
        Result := nil;
end;

procedure TGedComFile.Merge(aObj1: TGedComObj; var aObj2: TGedComObj);
var
    i: integer;
    lCild: TGedComObj;
    lLink, lOrgCh: TGedComObj;
begin
    // Prüfe, daß beide Objekte den selben Root, Parent und Typ haben
    if assigned(aObj1) and assigned(aobj2) and (aobj1.root = aobj2.root) and
        (aobj1.parent = aobj2.parent) and (aobj1 <> aobj2) and
        (aobj1.NodeType = aobj2.NodeType) then
      begin
        // Lösche gleiche Nodes in aObj2
        for i := aobj2.ChildCount - 1 downto 0 do
          begin
            lCild := aObj2[i];
            // done: Merge Equal Tags
            lOrgCh := aobj1.Find(lCild.FNodeType);
            if lCild.Data.StartsWith('@') and assigned(aObj2.Root.Find(lCild.Data)) and
                (not assigned(lOrgCh) or (lCild.Data <> lOrgCh.Data)) then
                for lLink in aObj2.Root.Find(lCild.Data) do
                    if lLink.Data = aobj2.NodeID then
                        lLink.Data := aobj1.NodeID
                    else
            else
            if assigned(lOrgCh) and lOrgCh.Equals(
                lCild, [CEventDate, CPlace, 'TYPE']) then
                lOrgCh.merge(lCild);
            if assigned(lCild) then
                lCild.Parent := aobj1;
          end;
        aObj1.parent.RemoveChild(aobj2);
        if aObj1.Parent = IGedParent(self) then
            for i := 0 to FIdx.Count - 1 do
                if Fidx.Objects[i] = aObj2 then
                    Fidx.Objects[i] := aObj1;
        FreeAndNil(aobj2);
      end;
end;

function TGedComFile.appendChild(aChild: TGedComObj): integer;
var
    i: integer;
begin
    if not assigned(aChild) then
        exit(-1);
    for i := 0 to high(FChildren) do
        if FChildren[i] = aChild then
            exit(i);
    setlength(FChildren, high(FChildren) + 2);
    AppendIndex(aChild.NodeID, aChild);
    Result := high(FChildren);
    FChildren[Result] := aChild;
    aChild.Parent := self;
    aChild.Root := self;
end;

procedure TGedComFile.RemoveChild(aChild: TGedComObj);
var
    i: integer;
    Flag: boolean;
begin
    Flag := False;
    for i := 0 to high(FChildren) do
        if FChildren[i] = aChild then
            flag := True
        else if Flag then
            FChildren[i - 1] := FChildren[i];
    if flag then
      begin
        setlength(FChildren, high(FChildren));
        aChild.Parent := nil;
      end;
end;

function TGedComFile.GetChildIdx(aChild: TGedComObj): integer;
var
    i: integer;
begin
    Result := -1;
    if not assigned(aChild) then
        exit;
    if aChild.Parent <> IGedParent(self) then
        exit;
    if (achild.id >= 0) and (aChild.id <= high(FChildren)) and
        (FChildren[achild.id] = aChild) then
        exit(aChild.id);
    for i := 0 to high(FChildren) do
        if FChildren[i] = aChild then
            exit(i);
end;

function TGedComFile.GetEnumerator: TGedComObjEnumerator;
begin
    Result := TGedComObjEnumerator.Create(self);
end;

function TGedComFile.GetChild(Idx: variant): TGedComObj;
begin
    if VarIsOrdinal(Idx) then
        Result := FChildren[Idx]
    else if VarIsStr(Idx) then
        Result := Find(Idx)
    else
        Result := nil;
end;

function TGedComFile.GetParent: IGedParent;
begin
    Result := nil;
end;

function TGedComFile.ChildCount: integer;
begin
    Result := length(FChildren);
end;

procedure TGedComFile.ChildUpdate(aChild: TGedComObj);
begin
    if assigned(FonChildUpdate) then
        FonChildUpdate(aChild);
end;

procedure TGedComFile.EndUpdate;
var
  lChlds: TGedComObj;
begin
  for lChlds in self do
    lChlds.EndUpdate;
end;

constructor TGedComFile.Create;
begin
    inherited;
    FIdx := TStringList.Create;
    Fidx.Sorted := True;
    FEncoding := 'UTF-8';
end;

destructor TGedComFile.Destroy;
begin
    Clear;
    FreeAndNil(Fidx);
    inherited Destroy;
end;

class function TGedComFile.GetFileInfoStr(Path: string; Force: boolean): string;
var
    lStream: TStream;
    lLines: TStrings;
    I: integer;
    lsHeader, lsHEncoding, lresult2: string;
    lbEncoded: boolean;
    lGC: IGedParent;

const
    cSWildCardFill = 'WildCardFill';
    csSection = 'Header';
    cHeaderSize = 4096;

begin
    lLines := TStringList.Create;
    lStream := TfileStream.Create(Path, fmOpenRead);
      try
        setlength(lsHeader, cHeaderSize);
        setlength(lsHeader, lStream.Read(lsHeader[1], cHeaderSize));
        lsHEncoding := GuessEncoding(lsHeader);
        lLines.Text := ConvertEncodingToUTF8(lsHeader, lsHEncoding, lbEncoded);
      finally
        FreeAndNil(lStream);
      end;
    lGC := ParseGed(lLines,nil,nil,nil);
    lLines.Free;
    Result := '[' + csSection + ']' + LineEnding;
    lresult2 := '[' + cSWildCardFill + ']' + LineEnding;
    for i := 0 to lGC.ChildCount - 1 do
      begin
        Result := Result + lowercase(lGC.GetChild(i).NodeType) + '=' +
            lGC.GetChild(i).Data + LineEnding;
        lresult2 := lresult2 + lowercase(lGC.GetChild(i).NodeType)[1] +
            '=' + lGC.GetChild(i).Data + LineEnding;
      end;
    Result := Result + LineEnding + lresult2;
    FreeAndNil(lGC);
end;

class function TGedComFile.DisplayName: string;
begin
    Result := rsGenealogieExchangeFile;
end;

{$ifdef SUPPORTS_GENERICS}
//class function TGedComFile.Extensions: TArray<String>;
{$ELSE}
class function TGedComFile.Extensions: TStringArray;
{$ENDIF}
begin
    setlength(Result, 1);
    Result[0] := '.GED';
end;

class procedure TGedComFile.RegisterGedComClass(aGCClass: TGedObjClass);
begin
    setlength(FGedComObjects, length(FGedComObjects) + 1);
    FGedComObjects[high(FGedComObjects)] := aGCClass;
end;

initialization
    RegisterGetInfoProc(TGedComFile);
    TGedComFile.RegisterGedComClass(TGedComDefault);
    TGedComFile.RegisterGedComClass(TGedPlace);
    TGedComFile.RegisterGedComClass(TGedEvent);
    TGedComFile.RegisterGedComClass(TIndName);
    TGedComFile.RegisterGedComClass(TGedIndividual);
end.
