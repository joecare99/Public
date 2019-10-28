unit Cls_GedComExt;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Cmp_GedComFile;

type
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
        function getPlaceName: string;
        procedure SetDate(AValue: string);
        procedure SetPlace(AValue: TGedPlace);
        procedure SetPlaceName(AValue: string);
        procedure SetSource(AValue: TGedComObj);
    published
        property Date: string read GetDate write SetDate;
        property Place: TGedPlace read FPlace write SetPlace;
        property PlaceName: string read getPlaceName write SetPlaceName;
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

        function GetFullName: string;
        procedure SetCallName(AValue: string);
        procedure SetFSource(AValue: TGedComObj);
        procedure SetFullname(AValue: string);
        procedure SetGivenName(AValue: string);
        procedure SetNameSuffix(AValue: string);
        procedure SetSurname(AValue: string);
        procedure SetTitle(AValue: string);
    protected
        procedure SetData(AValue: string); override;
    published
        property FullName: string read GetFullName write SetFullname;
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

    TGedIndividual = class;

    { TGedIndEnumerator }
    TGedIndEnumerator = class
    protected
        FBaseNode: TGedIndividual;
        FIter: integer;
    protected
        function getCurrent: TGedIndividual; virtual; abstract;
    public
        constructor Create(ATree: TGedIndividual); virtual;
        function MoveNext: boolean; virtual; abstract;
        property Current: TGedIndividual read getCurrent;
        function GetEnumerator: TGedIndEnumerator;
    end;

    TGedFamily = class;

    { TGedIndChildEnumerator }

    TGedIndChildEnumerator = class(TGedIndEnumerator)
    protected
        function getCurrent: TGedIndividual; override;
    public
        function MoveNext: boolean; override;
    end;

    { TGedIndSpouseEnumerator }

    TGedIndSpouseEnumerator = class(TGedIndEnumerator)
    protected
        function getCurrent: TGedIndividual; override;
    public
        function MoveNext: boolean; override;
    end;


    { TGedIndFamEnumerator }

    TGedIndFamEnumerator = class(TGedIndEnumerator)
    protected
        function getCurrent: TGedFamily; reintroduce;
    public
        function MoveNext: boolean; override;
        property Current: TGedFamily read getCurrent;
        function GetEnumerator: TGedIndFamEnumerator;
    end;

    { TGedIndividual }

    TGedIndividual = class(TGedComDefault)
    private
        FBaptised: TGedEvent;
        FBirth: TGedEvent;
        FBurial: TGedEvent;
        FDeath: TGedEvent;
        FOccupation: TGedEvent;
        FFather: TGedIndividual;
        FMother: TGedIndividual;
        FName: TIndName;
        FRefNr: TGedComObj;
        FReligion: TGedEvent;
        FSex: TGedEvent;
        Fspouses: array of TGedIndividual;
        FFamilys: array of TGedFamily;
        FChilds: array of TGedIndividual;
        function GetBaptDate: string;
        function GetBirthDate: string;
        function GetBirthPlace: string;
        function GetBurialDate: string;
        function GetChildrenCount: integer;
        function GetChildren(Idx: variant): TGedIndividual;
        function GetDeathDate: string;
        function GetDeathPlace: string;
        function GetFamCount: integer;
        function GetFamilys(Idx: variant): TGedFamily;
        function GetFather: TGedIndividual;
        function GetMother: TGedIndividual;
        function GetName: string;
        function GetOccupation: string;
        function GetPersonID: string;
        function GetReligion: string;
        function GetSex: string;
        function GetSpouseCount: integer;
        function GetSpouses(Idx: variant): TGedIndividual;
        procedure SetBaptDate(AValue: string);
        procedure SetBaptised(AValue: TGedEvent);
        procedure SetBirth(AValue: TGedEvent);
        procedure SetBirthDate(AValue: string);
        procedure SetBirthPlace(AValue: string);
        procedure SetBurial(AValue: TGedEvent);
        procedure SetBurialDate(AValue: string);
        procedure SetChildren(Idx: variant; AValue: TGedIndividual);
        procedure SetDeath(AValue: TGedEvent);
        procedure SetDeathDate(AValue: string);
        procedure SetDeathPlace(AValue: string);
        procedure SetFamilys(Idx: variant; AValue: TGedFamily);
        procedure SetFather(AValue: TGedIndividual);
        procedure SetMother(AValue: TGedIndividual);
        procedure SetName(AValue: TIndName); overload;
        procedure SetName(AValue: string); overload;
        procedure SetOccupation(AValue: string);overload;
        procedure SetOccupation(AValue: TGedEvent);overload;
        procedure SetPersonID(AValue: string);
        procedure SetRefNr(AValue: TGedComObj);
        procedure SetReligion(AValue: string);overload;
        procedure SetReligion(AValue: TGedEvent);overload;
        procedure SetSex(AValue: string); overload;
        procedure SetSex(AValue: TGedEvent); overload;
        procedure SetShortcutChild(const AValue: TGedEvent;
            var aShortcut: TGedEvent; const aNodeType: string); overload;
        procedure SetShortcutChild(const AValue: TGedIndividual;
            var aShortcut: TGedIndividual; const aNodeType: string); overload;
        procedure SetShortcutChild(const AValue: TIndName;
            var aShortcut: TIndName; const aNodeType: string); overload;
        procedure SetSpouses(Idx: variant; AValue: TGedIndividual);
    published
        property NameNode: TIndName read FName write SetName;
        property Birth: TGedEvent read FBirth write SetBirth;
        property Baptised: TGedEvent read FBaptised write SetBaptised;
        property Death: TGedEvent read FDeath write SetDeath;
        property Burial: TGedEvent read FBurial write SetBurial;
        property RefNrNode: TGedComObj read FRefNr write SetRefNr;
        property Gender: TGedEvent read FSex write SetSex;
        property Mother: TGedIndividual read GetMother write SetMother;
        property Father: TGedIndividual read GetFather write SetFather;
        property SpouseCount: integer read GetSpouseCount;
        property ChildrenCount: integer read GetChildrenCount;
        property FamCount: integer read GetFamCount;

        {---- vital - Information ---- }
        property Name: string read GetName write SetName;
        property Sex: string read GetSex write SetSex;
        property PersonID: string read GetPersonID write SetPersonID;
        property BirthDate: string read GetBirthDate write SetBirthDate;
        property BirthPlace: string read GetBirthPlace write SetBirthPlace;
        property BaptDate: string read GetBaptDate write SetBaptDate;
        property DeathDate: string read GetDeathDate write SetDeathDate;
        property DeathPlace: string read GetDeathPlace write SetDeathPlace;
        property BurialDate: string read GetBurialDate write SetBurialDate;
        property Occupation: string read GetOccupation write SetOccupation;
        property Religion: string read GetReligion write SetReligion;

    protected
        procedure ChildUpdate(aChild: TGedComObj); override;
        procedure AppendChildren(aChild: TGedComObj);
        procedure AppendSpouse(aChild: TGedComObj);
        procedure AppendFam(aFam: TGedFamily);
        procedure RemoveChildren(aChild: TGedComObj);
        procedure RemoveSpouse(aSpouse: TGedIndividual);
        procedure RemoveFam(aFam: TGedFamily);
    public
        constructor Create(const aID, aType: string; const aInfo: string); override;
        destructor Destroy; override;
        function ToString: ansistring; override;
        function Description: string; override;
        function Equals(aObj: TGedComObj): boolean;override; overload;
        class function AssNodeType: string; override;
        class function HandlesNodeType(aType: string): boolean; override;
        function EnumerateChildren: TGedIndEnumerator;
        function EnumerateSpouses: TGedIndEnumerator;
        function EnumerateFamiliy: TGedIndFamEnumerator;

        property Spouses[Idx: variant]: TGedIndividual read GetSpouses write SetSpouses;
        property Children[Idx: variant]: TGedIndividual
           read GetChildren write SetChildren;
        property Familys[Idx: variant]: TGedFamily read GetFamilys write SetFamilys;
    end;

    { TGedFamChildrenEnumerator }

    TGedFamChildrenEnumerator = class(TGedIndEnumerator)
    private
        FBaseFam: TGedFamily;
    protected
        function getCurrent: TGedIndividual; override;
    public
        constructor Create(ATree: TGedFamily); reintroduce;
        function MoveNext: boolean; override;
    end;

    TGedLink = class;
    { TGedFamily }

    TGedFamily = class(TGedComDefault)
    private
        FHusband: TGedIndividual;
        FHusblink: TGedLink;
        FWife: TGedIndividual;
        FWifeLink: TGedLink;
        FMarriageNode:TGedEvent;
        FChilds:array of TGedIndividual;
        function GetMarriageDate: string;
        function GetMarriagePlace: string;
        procedure SetMarriage(AValue: TGedEvent);
        procedure SetMarriageDate(AValue: string);
        procedure SetMarriagePlace(AValue: string);
        procedure SetUpdFamParentLink(Const aLink: TGedLink;
            var lParenLink: TgedLink; var lParent,lParent2: TGedIndividual);
        procedure UpdSetChildLink(var aLink: TGedLink);
    protected
        procedure ChildUpdate(aChild: TGedComObj); override;
        procedure SetShortcutChild(const AValue: TGedEvent;
            var aShortcut: TGedEvent; const aNodeType: string); overload;
    public
      procedure AppendFamChild(const aInd: TGedIndividual);
      procedure RemoveFamChild(const aInd: TGedIndividual);
        Property Marriage:TGedEvent read FMarriageNode write SetMarriage;
        property MarriageDate: string read GetMarriageDate write SetMarriageDate;
        property MarriagePlace: string read GetMarriagePlace write SetMarriagePlace;
        property Husband:TGedIndividual read FHusband;
        property Wife:TGedIndividual read FWife;
    public
        constructor Create(const aID, aType: string; const aInfo: string); override;
        class function AssNodeType: string; override;
        class function HandlesNodeType(aType: string): boolean; override;
        function EnumerateChildren: TGedIndEnumerator;
    end;

    { TGedLink }

    TGedLink = class(TGedComDefault)
    private
        FLink: TGedComObj;
      FRemoving: boolean;
    protected
        function GetLink: TGedComObj; override;
        procedure SetLink(AValue: TGedComObj); override;
        procedure SetData(AValue: string); override;
        procedure SetRoot(AValue: IGedParent); override;
    public
        constructor Create(const aID, aType: string; const aInfo: string); override;
        class function AssNodeType: string; override;
        class function HandlesNodeType(aType: string): boolean; override;
        property Removing:boolean read FRemoving ;
    end;

const
    CPaceMap = 'MAP';
    CPlaceMapLong = 'LONG';
    CPlaceMapLati = 'LATI';
    CIndividual = 'INDI';
    CFamily = 'FAM';
    CFamHusband = 'HUSB';
    CFamWife = 'WIFE';
    CFamChildren = 'CHIL';
    CEventBirth = 'BIRT';
    CEventBaptism = 'BAPM';
    CEventConfirm = 'CONF';
    CEventDeath = 'DEAT';
    CEventBurial = 'BURI';
    CEventMarriage = 'MARR';
    CFactOccupation = 'OCCU';
    CFactName = 'NAME';
    CFactSex = 'SEX';
    CFactRefNr = 'REFN';
    CFactReligion = 'RELI';
    CLinkFamSpouse = 'FAMS';
    CLinkFamChild = 'FAMC';
    CLinkAssosiation = 'ASSO';

    CTagToNatur: array[0..17] of string =
        (CEventBirth, 'born', 'Birth',
        CEventBaptism, 'baptised', 'Baptism',
        CEventDeath, 'died', 'Death',
        CEventBurial, 'burried', 'Burrial',
        CEventMarriage, 'married', 'Marriage',
        CEventConfirm, 'confirmed', 'Confirmation');

function TagToNatur(aTag: string; kind: integer = 0): string;

implementation

uses variants;

function TagToNatur(aTag: string; kind: integer = 0): string;
var
    i: integer;
begin
    Result := aTag;
    for i := 0 to high(CTagToNatur) div 3 do
        if atag = CTagToNatur[i * 3] then
            exit(CTagToNatur[i * 3 + 1 + kind]);
end;

{ TGedIndFamEnumerator }

function TGedIndFamEnumerator.getCurrent: TGedFamily;
begin
   result := nil;
   if assigned(FBaseNode) then
     Result := FBaseNode.Familys[FIter];
end;

function TGedIndFamEnumerator.MoveNext: boolean;
begin
  Inc(FIter);
  Result := Fiter < FBaseNode.FamCount;
end;

function TGedIndFamEnumerator.GetEnumerator: TGedIndFamEnumerator;
begin
  result := self;
end;

{ TGedLink }

function TGedLink.GetLink: TGedComObj;
begin
    if assigned(FLink)
       and (FLink.NodeID = Data) then
        exit(FLink);
    Result := inherited GetLink;
    Flink := Result;
end;

procedure TGedLink.SetLink(AValue: TGedComObj);
begin
    if Flink = AValue then
        exit;
    inherited SetLink(AValue);
    Flink := AValue;
end;

procedure TGedLink.SetData(AValue: string);
begin
    if assigned(FLink) then
        begin
          FRemoving := true;
          Parent.ChildUpdate(self);
        end;
    FRemoving := false;
    inherited SetData(AValue);
    FLink := inherited GetLink;
end;

procedure TGedLink.SetRoot(AValue: IGedParent);
begin
    inherited SetRoot(AValue);
    if Assigned(AValue) then
        Flink := AValue.Find(Data);
end;

constructor TGedLink.Create(const aID, aType: string; const aInfo: string);
begin
    inherited Create(aID, aType, aInfo);
    FLink := nil;
end;

class function TGedLink.AssNodeType: string;
begin
    Result := '';
end;

class function TGedLink.HandlesNodeType(aType: string): boolean;
begin
    Result :=
        (aType = 'FAMS') or (aType = 'FAMC') or (aType = 'HUSB') or
        (aType = 'WIFE') or (aType = 'CHIL') or (aType = 'ASSO');
end;

{ TGedFamChildrenEnumerator }

function TGedFamChildrenEnumerator.getCurrent: TGedIndividual;
begin
    Result := TGedIndividual(FBaseFam[FIter].Link);
end;

constructor TGedFamChildrenEnumerator.Create(ATree: TGedFamily);
begin
    inherited Create(nil);
    FBaseFam := ATree;
end;

function TGedFamChildrenEnumerator.MoveNext: boolean;
begin
    while (Fiter < 0) or ((FBaseFam[Fiter].NodeType <> 'CHIL') and
            (Fiter < FBaseFam.Count)) do
        Inc(FIter);
    Result := Fiter < FBaseFam.Count;
end;

{ TGedFamily }

function TGedFamily.GetMarriageDate: string;
begin
  result := '';
    if Assigned(FMarriageNode) and (FMarriageNode.id>=0) then
      result := FMarriageNode.Date;
end;

function TGedFamily.GetMarriagePlace: string;
begin
    result := '';
      if Assigned(FMarriageNode) and (FMarriageNode.id>=0) then
        result := FMarriageNode.PlaceName;
end;

procedure TGedFamily.SetMarriage(AValue: TGedEvent);

begin
  SetShortcutChild(AValue,FMarriageNode,CEventMarriage);
end;

procedure TGedFamily.SetMarriageDate(AValue: string);
begin
    if aValue = GetMarriageDate then
        exit;
    if Assigned(FMarriageNode) then
        FMarriageNode.Date := AValue
    else
      begin
        SetMarriage(TGedEvent.Create('', '', ''));
        FMarriageNode.Date := AValue;
      end;
end;

procedure TGedFamily.SetMarriagePlace(AValue: string);
begin
    if aValue = GetMarriagePlace then
           exit;
       if Assigned(FMarriageNode) then
           FMarriageNode.PlaceName := AValue
       else
         begin
           SetMarriage(TGedEvent.Create('', '', ''));
           FMarriageNode.PlaceName := AValue;
         end;
end;

procedure TGedFamily.SetUpdFamParentLink(const aLink: TGedLink;
  var lParenLink: TgedLink; var lParent, lParent2: TGedIndividual);


  procedure RemoveParent(var lParent: TGedIndividual);
  var
    lCh: TGedIndividual;
  begin
    if Assigned(lParent) then
      begin
        if Assigned(lParent2) then
          begin
            lParent.RemoveSpouse(lParent2);
            lParent2.RemoveSpouse(lParent);
          end;
        lParent.RemoveFam(self);
        for lCh in FChilds do
          lParent.RemoveChildren(lCh);
        lParent:=nil;
      end;
  end;

var
  lCh: TGedIndividual;

begin
  if aLink.Removing or not Assigned(aLink.Parent) then
     begin
        if lParenLink=aLink then
          lParenLink:= TGedLink(find(aLink.NodeType));
        if (lParent=aLink.Link) then
          RemoveParent(lParent);
        if Assigned(lParenLink) and assigned(lParenLink.Link) then
          lParent := TGedIndividual(lParenLink.Link);
        exit;
     end;
  if (lParenLink=aLink) and not assigned(alink.Link) then
    begin
      RemoveParent(lParent);
      exit;
    end;
  if not assigned(lParenLink) or (lParenLink.ID >= aLink.ID) then
      lParenLink := aLink;
  if assigned(lParenLink) and assigned(lParenLink.Link) then
    begin
      if (lParent <> TGedIndividual(lParenLink.Link)) then
        begin
          RemoveParent(lParent);
          lParent := TGedIndividual(lParenLink.Link);
          lParent.appendFam(Self);

            if assigned(lParent2) then
              begin
                lParent2.appendSpouse(lParent);
                lParent.appendSpouse(lParent2);
              end;
            for lCh in FChilds do
              lParent.AppendChildren(lCh);

        end;
    end;
end;

procedure TGedFamily.RemoveFamChild(const aInd:TGedIndividual);

var
  i: Integer;
begin
  for i := high(FChilds) downto 0 do
      if FChilds[i]=aInd then
          begin
            FChilds[i] := FChilds[high(FChilds)];
            setlength(FChilds,high(FChilds));
            if Assigned(FHusband) then
                FHusband.RemoveChildren(aInd);
            if Assigned(FWife) then
                FWife.RemoveChildren(aInd);
            break;
          end;
end;

procedure TGedFamily.UpdSetChildLink(var aLink: TGedLink);

var
  lDest: TGedIndividual;
begin
// Todo:  TGedIndividual(aLink.Link).UpdateChildLink;
  lDest:=TGedIndividual(aLink.Link);
  if aLink.Removing or not assigned(aLink.parent) then
     begin
       RemoveFamChild(lDest);
     end
  else
    begin
       AppendFamChild(lDest);
    end;
end;

procedure TGedFamily.ChildUpdate(aChild: TGedComObj);

begin
    if (aChild.NodeType = CFamHusband) then
        SetUpdFamParentLink(tgedlink(aChild),FHusblink,FHusband, FWife);
    if (aChild.NodeType = CFamWife) then
      SetUpdFamParentLink(tgedlink(aChild),FWifeLink,FWife, FHusband);
    if (aChild.NodeType = CFamChildren) and assigned(aChild.Link) then
       UpdSetChildLink(TGedLink(aChild));
    if (aChild.NodeType = CEventMarriage) then
      if not assigned(FMarriageNode)
        or (FMarriageNode.id > aChild.id) then
        if (FMarriageNode <> aChild) then
        FMarriageNode := TGedEvent(aChild)
      else
        if not assigned(aChild.Parent) then
          FMarriageNode:=nil;

    inherited ChildUpdate(aChild);
end;

procedure TGedFamily.SetShortcutChild(const AValue: TGedEvent;
  var aShortcut: TGedEvent; const aNodeType: string);
var
  lNode: TGedComObj;
begin
  lNode := aShortcut;
  inherited SetShortcutChild(AValue,lNode,aNodeType);
  aShortcut := TGedEvent(lNode);
end;

procedure TGedFamily.AppendFamChild(const aInd: TGedIndividual);
var
  lInd: TGedIndividual;
begin
   for lInd in FChilds do
       if lind = aind then exit;
   SetLength(FChilds,high(FChilds)+2);
   FChilds[high(FChilds)] := aInd;
    if Assigned(FHusband) then
        FHusband.appendChildren(aInd);
    if Assigned(FWife) then
        FWife.appendChildren(aInd);
end;

constructor TGedFamily.Create(const aID, aType: string; const aInfo: string);
begin
    inherited Create(aID, aType, aInfo);
    FHusband := nil;
    FHusblink := nil;
    FWife := nil;
    FWifeLink := nil;
    FMarriageNode:=nil;
end;

class function TGedFamily.AssNodeType: string;
begin
    Result := 'FAM';
end;

class function TGedFamily.HandlesNodeType(aType: string): boolean;
begin
    Result := aType = 'FAM';
end;

function TGedFamily.EnumerateChildren: TGedIndEnumerator;
begin
    Result := TGedFamChildrenEnumerator.Create(self);
end;

{ TGedIndSpouseEnumerator }

function TGedIndSpouseEnumerator.getCurrent: TGedIndividual;

begin
    Result := nil;
    if Assigned(FBaseNode) then
        Result := FBaseNode.Spouses[FIter];
end;

function TGedIndSpouseEnumerator.MoveNext: boolean;
begin
    Inc(FIter);
    Result := FIter < FBaseNode.SpouseCount;
end;

{ TGedIndEnumerator }

constructor TGedIndEnumerator.Create(ATree: TGedIndividual);
begin
    FBaseNode := Atree;
    FIter := -1;
end;

function TGedIndEnumerator.GetEnumerator: TGedIndEnumerator;
begin
    Result := Self;
end;

{ TGedIndChildEnumerator }

function TGedIndChildEnumerator.getCurrent: TGedIndividual;
begin
    Result := nil;
    if Assigned(FBaseNode) then
        Result := FBaseNode.Children[FIter];
end;

function TGedIndChildEnumerator.MoveNext: boolean;
begin
    Inc(Fiter);
    Result := fIter < FBaseNode.ChildrenCount;
end;

{ TIndName }

procedure TIndName.SetCallName(AValue: string);
begin
    if FCallName = AValue then
        Exit;
    FCallName := AValue;
end;

function TIndName.GetFullName: string;

begin
    if True then
        Result := trim(Title + ' ' + GivenName + ' ' + Surname)
    else
      begin
        Result := Surname + ', ' + GivenName;
        if Title <> '' then
            Result := Result + ', ' + Title;
      end;
end;

procedure TIndName.SetFSource(AValue: TGedComObj);
begin
    if FSource = AValue then
        Exit;
    FSource := AValue;
end;

procedure TIndName.SetFullname(AValue: string);
var
    lNames: TStringArray;
    lsurSplit, lTitleSplit, lpp, i: integer;
    ls: string;
begin
    // Test for Comma-Version
    lpp := AValue.IndexOf(',');
    if lpp >= 0 then
      begin
        lNames := AValue.Split(',');
        Surname := lNames[0];
        GivenName := trim(lNames[1]);
        if high(lNames) > 1 then
            Title := Trim(lNames[2]);
        Data := GivenName + ' /' + Surname + '/';
      end
    else
      begin
        lNames := AValue.Split(' ');
        // SUrname only
        if High(lNames) = 0 then
          begin
            Surname := lNames[0];
            GivenName := '';
            Title := '';
          end
        else
          begin
            lsurSplit := High(lNames);
            while (lsurSplit > 0) and ((lNames[lsurSplit - 1] = 'von') or
                    (lNames[lsurSplit - 1] = 'zu') or (lNames[lsurSplit - 1] = 'van') or
                    (lNames[lsurSplit - 1] = 'der') or
                    (lNames[lsurSplit - 1] = 'den')) do
                Dec(lsurSplit);
            lTitleSplit := -1;
            while (lTitleSplit < lsurSplit) and
                (lNames[lTitleSplit + 1].EndsWith('.') and
                    (length(lNames[lTitleSplit + 1]) > 2)) do
                Inc(lTitleSplit);
            ls := lNames[high(lNames)];
            for i := high(lNames) - 1 downto lsurSplit do
                ls := lNames[i] + ' ' + ls;
            Surname := ls;
            ls := '';
            for i := lsurSplit - 1 downto lTitleSplit + 1 do
                ls := lNames[i] + ' ' + ls;
            GivenName := trim(ls);
            ls := '';
            for i := lTitleSplit downto 0 do
                ls := lNames[i] + ' ' + ls;
            Title := trim(ls);
            Data := GivenName + ' /' + Surname + '/';
          end;
      end;

end;

procedure TIndName.SetGivenName(AValue: string);
begin
    if FGivenName = AValue then
        Exit;
    setData(AValue + ' ' + FSurname.QuotedString('/'));
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
    setData(FGivenName + ' ' + AValue.QuotedString('/'));
end;

procedure TIndName.SetTitle(AValue: string);
begin
    if FTitle = AValue then
        Exit;
    FTitle := AValue;
    // erstelle ggf. ein Title-Tag

end;

procedure TIndName.SetData(AValue: string);
var
    lpp: integer;
begin
    lpp := AValue.IndexOf('/');
    if lpp >= 0 then
      begin
        FGivenName := trim(LeftStr(AValue, lpp));
        FSurname := Copy(avalue, lpp + 1).DeQuotedString('/');
      end;
    inherited SetData(AValue);
end;

constructor TIndName.Create(const aID, aType: string; const aInfo: string);
var
    lpp: integer;
begin
    inherited Create(aID, aType, aInfo);
    Fsource := nil;
    Fnext := nil;
    lpp := aInfo.IndexOf('/');
    if lpp >= 0 then
      begin
        FGivenName := trim(LeftStr(aInfo, lpp));
        FSurname := Copy(aInfo, lpp + 1).DeQuotedString('/');
      end;
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

function TGedEvent.getPlaceName: string;
begin
    if assigned(FPlace) then
        Result := FPlace.Data
    else
        Result := '';
end;

procedure TGedEvent.SetPlace(AValue: TGedPlace);
begin
    if FPlace = AValue then
        Exit;
    FPlace := AValue;
end;

procedure TGedEvent.SetPlaceName(AValue: string);
begin
    if assigned(FPlace) then
        FPlace.Data := AValue
    else
        Child[CPlace].Data := AValue;
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
    Result := 'E: ' + TagToNatur(NodeType);
    if assigned(FDate) then
        Result := Result + ': ' + FDate.Data;
    if assigned(FPlace) then
        Result := Result + ' in ' + FPlace.Data;
end;

function TGedEvent.Description: string;
begin
    Result := 'Event: ' + TagToNatur(NodeType, 1);
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
        (atype = CEventDeath) or (atype = CEventBurial) or
        (atype = CEventMarriage) or (atype = CEventConfirm) or
        (atype = CFactOccupation) or
        (atype = CFactSex) or (atype = CFactReligion) ;
end;

{ TGedIndividual }

function TGedIndividual.GetChildren(Idx: variant): TGedIndividual;
begin
    Result := nil;
    if VarIsOrdinal(idx) then
        Result := FChilds[idx];
end;

function TGedIndividual.GetDeathDate: string;
begin
    Result := '';
    if Assigned(FDeath) then
        Result := FDeath.Date;
end;

function TGedIndividual.GetDeathPlace: string;
begin
    result := '';
    if Assigned(FDeath) and assigned(FDeath.Place) then
        Result := FDeath.Place.Data;
end;

function TGedIndividual.GetFamCount: integer;
begin
  result := length(FFamilys)
end;

function TGedIndividual.GetFamilys(Idx: variant): TGedFamily;
begin
  result := nil;
  if VarIsOrdinal(Idx) then
    Result := FFamilys[Idx];
end;

function TGedIndividual.GetFather: TGedIndividual;
var
    lFamPar: TGedComObj;
    lfam: TGedFamily;
begin
    if assigned(FFather) and FFather.inheritsfrom(TGedIndividual) then
        exit(FFather);
    lFamPar := Find(CLinkFamChild);
    if assigned(lFamPar) and Assigned(lFamPar.Link) then
      begin
        lfam := TGedFamily(lFamPar.Link);
        FFather := lfam.FHusband;
        FMother := lfam.FWife;
        exit(FFather);
      end;
    Result := nil;
end;

function TGedIndividual.GetMother: TGedIndividual;
var
    lFamPar: TGedComObj;
    lfam: TGedFamily;
begin
    if assigned(FMother) and FMother.inheritsfrom(TGedIndividual) then
        exit(FMother);
    lFamPar := Find(CLinkFamChild);
    if assigned(lFamPar) and Assigned(lFamPar.Link) then
      begin
        lfam := TGedFamily(lFamPar.Link);
        FFather := lfam.FHusband;
        FMother := lfam.FWife;
        exit(FMother);
      end;
    Result := nil;
end;

function TGedIndividual.GetName: string;
begin
    Result := '';
    if Assigned(FName) then
        Result := FName.FullName;
end;

function TGedIndividual.GetOccupation: string;
begin
    Result := '';
    if Assigned(FOccupation) then
        Result := FOccupation.Data;
end;

function TGedIndividual.GetPersonID: string;
begin
    Result := '';
    if Assigned(FRefNr) then
        Result := FRefNr.Data;
end;

function TGedIndividual.GetReligion: string;
begin
    Result := '';
    if Assigned(FReligion) then
        Result := FReligion.Data;
end;

function TGedIndividual.GetSex: string;
begin
    Result := 'U';
    if Assigned(FSex) then
        Result := FSex.Data;
end;

function TGedIndividual.GetChildrenCount: integer;
begin
    Result := length(FChilds);
end;

function TGedIndividual.GetBirthDate: string;
begin
    Result := '';
    if Assigned(FBirth) then
        Result := FBirth.Date;
end;

function TGedIndividual.GetBirthPlace: string;
begin
    result := '';
    if Assigned(FBirth) and assigned(FBirth.Place) then
        Result := FBirth.Place.Data;
end;

function TGedIndividual.GetBaptDate: string;
begin
    Result := '';
    if Assigned(FBaptised) then
        Result := FBaptised.Date;
end;

function TGedIndividual.GetBurialDate: string;
begin
    Result := '';
    if Assigned(FBurial) then
        Result := FBurial.Date;
end;

function TGedIndividual.GetSpouseCount: integer;
begin
    Result := Length(FSpouses);
end;

function TGedIndividual.GetSpouses(Idx: variant): TGedIndividual;
begin
    Result := nil;
    if VarIsOrdinal(Idx) then
        Result := Fspouses[idx];
end;

procedure TGedIndividual.SetBaptDate(AValue: string);
begin
    if aValue = GetBaptDate then
        exit;
    if Assigned(FBaptised) then
        FBaptised.Date := AValue
    else
      begin
        SetBaptised(TGedEvent.Create('', '', ''));
        FBaptised.Date := AValue;
      end;
end;

procedure TGedIndividual.SetBaptised(AValue: TGedEvent);
begin
    SetShortcutChild(AValue, FBaptised, CEventBaptism);
end;

procedure TGedIndividual.SetBirth(AValue: TGedEvent);

begin
    SetShortcutChild(AValue, FBirth, CEventBirth);
end;

procedure TGedIndividual.SetBirthDate(AValue: string);
begin
    if aValue = GetBirthDate then
        exit;
    if Assigned(FBirth) then
        FBirth.Date := AValue
    else
      begin
        SetBirth(TGedEvent.Create('', '', ''));
        FBirth.Date := AValue;
      end;
end;

procedure TGedIndividual.SetBirthPlace(AValue: string);
begin
    if aValue = GetBirthPlace then
        exit;
    if Assigned(FBirth) then
        FBirth.PlaceName := AValue
    else
      begin
        SetBirth(TGedEvent.Create('', '', ''));
        FBirth.PlaceName := AValue;
      end;
end;

procedure TGedIndividual.SetBurial(AValue: TGedEvent);

begin
    SetShortcutChild(AValue, FBurial, CEventBurial);
end;

procedure TGedIndividual.SetBurialDate(AValue: string);
begin
    if aValue = GetBurialDate then
        exit;
    if Assigned(FBurial) then
        FBurial.Date := AValue
    else
      begin
        SetBurial(TGedEvent.Create('', '', ''));
        FBurial.Date := AValue;
      end;
end;

procedure TGedIndividual.SetChildren(Idx: variant; AValue: TGedIndividual);
begin
    if VarIsOrdinal(Idx) and (FChildren[Idx] = Avalue) then
        Exit;
    // Todo:
end;

procedure TGedIndividual.SetDeath(AValue: TGedEvent);

begin
    SetShortcutChild(AValue, FDeath, CEventDeath);
end;

procedure TGedIndividual.SetDeathDate(AValue: string);
begin
    if aValue = GetDeathDate then
        exit;
    if Assigned(FDeath) then
        FDeath.Date := AValue
    else
      begin
        SetDeath(TGedEvent.Create('', '', ''));
        FDeath.Date := AValue;
      end;
end;

procedure TGedIndividual.SetDeathPlace(AValue: string);
begin
    if aValue = GetDeathPlace then
        exit;
    if Assigned(FDeath) then
        FDeath.PlaceName := AValue
    else
      begin
        SetDeath(TGedEvent.Create('', '', ''));
        FDeath.PlaceName := AValue;
      end;
end;

procedure TGedIndividual.SetFamilys(Idx: variant; AValue: TGedFamily);
begin
    if VarIsOrdinal(Idx) and (FFamilys[Idx] = Avalue) then
        Exit;
    // Todo:
end;

procedure TGedIndividual.SetFather(AValue: TGedIndividual);
begin
    SetShortcutChild(AValue, FFather, CIndividual);
end;

procedure TGedIndividual.SetMother(AValue: TGedIndividual);
begin
    SetShortcutChild(AValue, FMother, CIndividual);
end;

procedure TGedIndividual.SetName(AValue: TIndName);
begin
    SetShortcutChild(AValue, FName, CFactName);
end;

procedure TGedIndividual.SetName(AValue: string);
begin
    if aValue = GetName then
        exit;
    if Assigned(FName) then
        FName.FullName := AValue
    else
      begin
        SetName(TIndName.Create('', '', ''));
        FName.FullName := AValue;
      end;
end;

procedure TGedIndividual.SetOccupation(AValue: string);
begin
    if aValue = GetOccupation then
        exit;
    if Assigned(FOccupation) then
        FOccupation.Data := AValue
    else
        SetOccupation(TGedEvent.Create('', '', AValue));
end;

procedure TGedIndividual.SetOccupation(AValue: TGedEvent);
begin
    SetShortcutChild(AValue, FOccupation, CFactOccupation);
end;

procedure TGedIndividual.SetPersonID(AValue: string);
begin
    if aValue = GetPersonID then
        exit;
    if Assigned(FRefNr) then
        FRefNr.Data := AValue
    else
        SetRefNr(TGedEvent.Create('', '', AValue));
end;

procedure TGedIndividual.SetRefNr(AValue: TGedComObj);
begin
    SetShortcutChild(AValue, FRefNr, CFactRefNr);
end;

procedure TGedIndividual.SetReligion(AValue: string);
begin
    if aValue = GetReligion then
        exit;
    if Assigned(FReligion) then
        FReligion.Data := AValue
    else
        SetReligion(TGedEvent.Create('', '', AValue));
end;

procedure TGedIndividual.SetReligion(AValue: TGedEvent);
begin
    SetShortcutChild(AValue, FReligion, CFactReligion);
end;

procedure TGedIndividual.SetSex(AValue: string);
begin
    if AValue = '' then
        AValue := 'U';
    if aValue = GetSex then
        exit;
    if Assigned(FSex) then
        FSex.Data := AValue
    else
        SetSex(TGedEvent.Create('', '', AValue));
end;

procedure TGedIndividual.SetSex(AValue: TGedEvent);
begin
    SetShortcutChild(AValue, Fsex, CFactSex);
end;

procedure TGedIndividual.SetShortcutChild(const AValue: TGedEvent;
    var aShortcut: TGedEvent; const aNodeType: string);
var
    lNode: TGedComObj;

begin
    lNode := aShortcut;
    SetShortcutChild(AValue, lNode, aNodeType);
    aShortcut := TGedEvent(lNode);
end;

procedure TGedIndividual.SetShortcutChild(const AValue: TGedIndividual;
    var aShortcut: TGedIndividual; const aNodeType: string);
var
    lNode: TGedComObj;

begin
    lNode := aShortcut;
    SetShortcutChild(AValue, lNode, aNodeType);
    aShortcut := TGedIndividual(lNode);
end;

procedure TGedIndividual.SetShortcutChild(const AValue: TIndName;
    var aShortcut: TIndName; const aNodeType: string);

var
    lNode: TGedComObj;

begin
    lNode := aShortcut;
    SetShortcutChild(AValue, lNode, aNodeType);
    aShortcut := TIndName(lNode);
end;

procedure TGedIndividual.SetSpouses(Idx: variant; AValue: TGedIndividual);
begin
    // Todo:
end;

procedure TGedIndividual.ChildUpdate(aChild: TGedComObj);
var
  lIndHusband, lIndWife: TGedIndividual;
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
        FBurial := TGedEvent(aChild)
    else if aChild.NodeType = CFactRefNr then
        FRefNr := aChild
    else if aChild.NodeType = CLinkFamSpouse then
       if TGedLink(aChild).Removing or not assigned(aChild.Parent) then
         begin
           RemoveFam(TGedFamily(aChild.link));
           if assigned(aChild.link) then
             begin
               lIndHusband := TGedFamily(aChild.link).Husband;
               lIndWife :=  TGedFamily(aChild.link).Wife;
           RemoveSpouse(lIndHusband);
           RemoveSpouse(lIndWife);
             end;
         end
       else if assigned(aChild.link) then
         begin
           AppendFam(TGedFamily(aChild.link));
           if TGedFamily(aChild.link).Husband = self then
             AppendSpouse(TGedFamily(aChild.link).wife)
           else
             AppendSpouse(TGedFamily(aChild.link).Husband)
         end;
    inherited;
end;

procedure TGedIndividual.AppendChildren(aChild: TGedComObj);
var
    lCh: TGedComObj;
begin
    if not assigned(aChild) or not aChild.inheritsfrom(TGedIndividual) then
        exit;
    for lCh in FChilds do
        if lch = aChild then
            exit;
    SetLength(FChilds, high(FChilds) + 2);
    FChilds[high(FChilds)] := TGedIndividual(aChild);
end;

procedure TGedIndividual.AppendSpouse(aChild: TGedComObj);
var
    lSp: TGedComObj;
begin
    if not assigned(aChild) or not aChild.inheritsfrom(TGedIndividual) then
        exit;
    for lSp in Fspouses do
        if lSp = aChild then
            exit
        else if lsp.id <=0 then
          exit;
    SetLength(Fspouses, high(Fspouses) + 2);
    Fspouses[high(Fspouses)] := TGedIndividual(aChild);
end;

procedure TGedIndividual.AppendFam(aFam: TGedFamily);
var
    lFm: TGedFamily;
begin
    if not assigned(aFam) then
        exit;
    for lFm in FFamilys do
        if lFm = aFam then
            exit;
    SetLength(FFamilys, high(FFamilys) + 2);
    FFamilys[high(FFamilys)] := aFam;
end;

procedure TGedIndividual.RemoveChildren(aChild: TGedComObj);
var
    i: integer;
begin
    for i := 0 to high(FChilds) do
        if FChilds[i] = aChild then
          begin
            FChilds[i] := FChilds[high(FChilds)];
            setlength(FChilds, high(FChilds));
            break;
          end;
end;

procedure TGedIndividual.RemoveSpouse(aSpouse: TGedIndividual);
var
    i: integer;
begin
    for i := 0 to high(Fspouses) do
        if FSpouses[i] = aSpouse then
          begin
            Fspouses[i] := Fspouses[high(Fspouses)];
            setlength(Fspouses, high(Fspouses));
            aSpouse.RemoveSpouse(self);
            break;
          end;
end;

procedure TGedIndividual.RemoveFam(aFam: TGedFamily);
    var
        i: integer;
    begin
        for i := 0 to high(FFamilys) do
            if FFamilys[i] = aFam then
              begin
                FFamilys[i] := FFamilys[high(FFamilys)];
                setlength(FFamilys, high(FFamilys));
                break;
              end;

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

destructor TGedIndividual.Destroy;
begin
    SetLength(Fspouses, 0);
    SetLength(FChilds, 0);
    inherited Destroy;
end;

function TGedIndividual.ToString: ansistring;
begin
    Result := 'I: ';
    if assigned(FName) then
        Result := Result + FName.FullName
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
        Result := Result + FName.FullName
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

function TGedIndividual.Equals(aObj: TGedComObj): boolean;
begin
  if not assigned(aObj) or not aobj.inheritsfrom(TGedIndividual) then exit(false);
  result := (Name = TGedIndividual(aobj).Name) and (Sex = TGedIndividual(aobj).sex);
  result := result and (BirthDate = TGedIndividual(aobj).BirthDate)
      and( not assigned(birth) or  (birth.Equals(TGedIndividual(aobj).Birth)));
  result := result and (BaptDate = TGedIndividual(aobj).BaptDate)
      and( not assigned(Baptised) or  (Baptised.Equals(TGedIndividual(aobj).Baptised)));
  result := result and (DeathDate = TGedIndividual(aobj).DeathDate)
      and( not assigned(Death) or  (Death.Equals(TGedIndividual(aobj).Death)));
  result := result and (BurialDate = TGedIndividual(aobj).BurialDate)
      and( not assigned(Burial) or  (birth.Equals(TGedIndividual(aobj).Burial)));
  result := result and (PersonID = TGedIndividual(aobj).PersonID);
  result := result and (FamCount = TGedIndividual(aobj).FamCount);
  if result and (FamCount>0) then
    try
    result := result and (TGedIndividual(aobj).FamCount>0) and
      (Familys[0].MarriageDate=TGedIndividual(aobj).Familys[0].MarriageDate);
    except
      result := false;
    end;
end;

class function TGedIndividual.AssNodeType: string;
begin
    Result := CIndividual;
end;

class function TGedIndividual.HandlesNodeType(aType: string): boolean;
begin
    Result := aType = CIndividual;
end;

function TGedIndividual.EnumerateChildren: TGedIndEnumerator;
begin
    Result := TGedIndChildEnumerator.Create(self);
end;

function TGedIndividual.EnumerateSpouses: TGedIndEnumerator;
begin
    Result := TGedIndSpouseEnumerator.Create(self);
end;

function TGedIndividual.EnumerateFamiliy: TGedIndFamEnumerator;
begin
  result := TGedIndFamEnumerator.Create(self);
end;


{TGedPlace}

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

initialization

    TGedComFile.RegisterGedComClass(TGedPlace);
    TGedComFile.RegisterGedComClass(TGedLink);
    TGedComFile.RegisterGedComClass(TGedEvent);
    TGedComFile.RegisterGedComClass(TIndName);
    TGedComFile.RegisterGedComClass(TGedIndividual);
    TGedComFile.RegisterGedComClass(TGedFamily);

end.
