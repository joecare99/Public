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
        function AppendChildNode(aChild: TGedComObj): integer;
        procedure RemoveChild(aChild: TGedComObj);
        function GetChildIdx(aChild: TGedComObj): integer;
        function GetChild(Idx: variant): TGedComObj;
        function GetParent: IGedParent;
        function Find(aID: string): TGedComObj;
        function ChildCount: integer;
        function GetEnumerator: TGedComObjEnumerator;
        procedure EndUpdate;
        procedure ChildUpdate(aChild: TGedComObj);
        function GetObject: TObject;
    end;

    { TGedComObjEnumerator }

    TGedComObjEnumerator = class
    private
        FBaseNode: IGedParent;
        FIter: integer;
        function getCurrent: TGedComObj;
    public
        constructor Create(ATree: IGedParent);virtual;
        function MoveNext: boolean;virtual;
        property Current: TGedComObj read getCurrent;
    end;

    { TGedComRevEnumerator }

    TGedComRevEnumerator = class(TGedComObjEnumerator)
    public
        constructor Create(ATree: IGedParent);override;
        function MoveNext: boolean;override;
        Function GetEnumerator: TGedComRevEnumerator;
    end;

    { TGedComRevEnumerator }

    { TGedComRevFltEnumerator }

    TGedComRevFltEnumerator = class(TGedComRevEnumerator)
    private
        FFltNodeType:string;
    public
        constructor Create(aTree: IGedParent; aFilter: String); reintroduce;
        function MoveNext: boolean;override;
    end;

    { TGedComObj }

    TGedComObj = class(TObject,IGedParent)
    private
        Fchanged: boolean;
        FID: integer;
        FNodeID: string;
        FParent: IGedParent;
        FNodeType: string;
        FType:integer;
        FRoot: IGedParent;
        FUpdating: boolean;
        procedure SetID(AValue: integer);
        procedure SetNodeID(AValue: string);
        procedure SetParent(AValue: IGedParent);
    protected
        function GetFtype:integer;
        procedure SetFType(AValue: integer);virtual;
        function GetData: string; virtual;
        function GetLink: TGedComObj; virtual;
        function AppendChildNode({%H-}aChild: TGedComObj): integer; virtual;
        procedure RemoveChild({%H-}aChild: TGedComObj); virtual;
        function GetChildIdx({%H-}aChild: TGedComObj): integer; virtual;
        function GetChild({%H-}Idx: variant): TGedComObj; virtual;
        function GetParent: IGedParent;
        function ChildCount: integer; virtual;
        procedure SetNodeType(AValue: string); virtual;
        procedure SetRoot(AValue: IGedParent); virtual;
        procedure SetLink(AValue: TGedComObj); virtual;
        procedure SetData({%H-}AValue: string); virtual;
        procedure ChildUpdate({%H-}aChild: TGedComObj); virtual;
        function GetObject: TObject;
    public
        procedure Clear; virtual; abstract;
        destructor Destroy; override;
        constructor Create(const aID, aType: string; const {%H-}aInfo: string = ''); virtual;
        function ToString: ansistring; override;
        function Description: string; virtual;
        function CreateChild(const aID, aType: string;
            const aInfo: string = ''): TGedComObj; virtual;
        function Find(aType: string): TGedComObj;
        function Equals(aObj: TGedComObj): boolean;virtual; overload;
        function Equals(aObj: TGedComObj; const aCompTags: array of string): boolean;
            overload;
        function GetEnumerator: TGedComObjEnumerator;
        function GetRevEnumerator(Filter:String): TGedComRevEnumerator;
        procedure BeginUpdate; virtual;
        procedure EndUpdate; virtual;
        procedure Merge(var aObj: TGedComObj);

        property ID: integer read FID write SetID;
        property Parent: IGedParent read FParent write SetParent;
        property Root: IGedParent read FRoot write SetRoot;
        property Data: string read GetData write SetData;
        property Link: TGedComObj read GetLink write SetLink;
        property NodeType: string read FNodeType write SetNodeType;
        property NodeID: string read FNodeID write SetNodeID;
        property Count: integer read ChildCount;
        property Updateing: boolean read FUpdating;
        property Child[Index: variant]: TGedComObj read GetChild; default;
        property TType:integer read Ftype write SetFType;
    public
        class function AssNodeType: string; virtual; // Class: Assosiated Node Type
        class function HandlesNodeType({%H-}aType: string): boolean;
            virtual; // Class: Handles Node Type
    end;

    TGedObjClass = class of TGedComObj;

    { TGedComDefault }
    TGedComDefault = class(TGedComObj)
        FChildren: array of TGedComObj;
        FInformation: string;
    protected
        function GetData: string; override;
        procedure SetData(AValue: string); override;
        function AppendChildNode(aChild: TGedComObj): integer; override;
        procedure RemoveChild(aChild: TGedComObj); override;
        function GetChildIdx(aChild: TGedComObj): integer; override;
        function GetChild(Idx: variant): TGedComObj; override;
        function ChildCount: integer; override;
        procedure SetShortcutChild(const AValue: TGedComObj;
            var aShortcut: TGedComObj; const aNodeType: string); overload;
    public
        procedure Clear; override;
        constructor Create(const aID, aType: string; const aInfo: string); override;
        class function HandlesNodeType({%H-}aType: string): boolean; override;
    end;

    {TFilterProc}
    TFilterproc=Function(aObj:TGedComObj):Boolean;

    { TGedComFile }

    TGedComFile = class(CFileInfo, IGedParent)
    private
        FChanged: boolean;
        FChildren: array of TGedComObj;
        FEncoding: string;
        FIdx: TStringList;
        FOnChildUpdate: TNotifyEvent;
        FOnUpdate: TNotifyEvent;
        FonLongOp: TNotifyEvent;
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
        function GetChildIdx(aChild: TGedComObj): integer; virtual;
        function GetChild(Idx: variant): TGedComObj;
        function GetParent: IGedParent;
        function ChildCount: integer;
        procedure ChildUpdate(aChild: TGedComObj); virtual;
        function GetObject: TObject;
        procedure EndUpdate;
    public
        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        constructor Create;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        destructor Destroy; override;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        class function GetFileInfoStr(Path: string; {%H-}Force: boolean = False): string;
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
        class function ParseGed(const Lines: TStrings; gcBase: IGedParent;
            OnUpd, OnLongOp: TNotifyEvent): IGedParent;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        class procedure PutGed(const Lines: TStrings; gcBase: IGedParent;
            OnUpd, OnLongOp: TNotifyEvent;aFilter:TFilterProc=nil);

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        class function NewNode(aNodeID, aNodeType: string;
            aValue: string = ''): TGedComObj;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        procedure LoadFromStream(st: TStream);

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        procedure WriteToStream(st: TStream;aFilter:TFilterProc=nil);

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        procedure Clear;

        ///<author>Joe Care</author>
        ///  <version>1.00.02</version>
        function AppendChildNode(aChild: TGedComObj): integer; virtual;
        procedure RemoveChild(aChild: TGedComObj); virtual;

        procedure AppendIndex(const aIdx: string; const aGedObj: TGedComObj);
        function GetEnumerator: TGedComObjEnumerator;
        function RevEnum: TGedComRevEnumerator;
        function CreateChild(const aID, aType: string;
            const aInfo: string = ''): TGedComObj;
        function Find(aID: string): TGedComObj;
        procedure Merge(aObj1: TGedComObj; var aObj2: TGedComObj);
        procedure AppendUnresolvedLink(aLink: string; aObj1: TGedComObj);
        property Count: integer read ChildCount;
        property Child[idx: variant]: TGedComObj read GetChild; default;
        property OnUpdate: TNotifyEvent read FOnUpdate write SetOnUpdate;
        property OnLongOp: TNotifyEvent read FOnLongOp write SetOnLongOp;
        property OnWriteUpdate: TNotifyEvent read FOnWriteUpdate write SetOnWriteUpdate;
        property Encoding: string read FEncoding write SetEncoding;
        property OnChildUpdate: TNotifyEvent read FOnChildUpdate write SetOnChildUpdate;
    end;

const
    CEventSource = 'SOUR';
    CPlace = 'PLAC';
    CEventDate = 'DATE';



implementation

uses Unt_StringProcs, LConvEncoding, variants;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

resourcestring
    rsGenealogieExchangeFile = 'Genealogie-Exchange-File';

{ TGedComRevFltEnumerator }

constructor TGedComRevFltEnumerator.Create(aTree: IGedParent; aFilter: String);
begin
  inherited Create(ATree);
  FFltNodeType:=aFilter;
end;

function TGedComRevFltEnumerator.MoveNext: boolean;
begin
  Result:=inherited MoveNext;
  while result and (Current.NodeType <> FFltNodeType) do
    Result:=inherited MoveNext;
end;

{ TGedComRevEnumerator }

constructor TGedComRevEnumerator.Create(ATree: IGedParent);
begin
  inherited Create(ATree);
  FIter:=FBaseNode.ChildCount;
end;

function TGedComRevEnumerator.MoveNext: boolean;
begin
  dec(Fiter);
  Result:=Fiter >=0;
end;

function TGedComRevEnumerator.GetEnumerator: TGedComRevEnumerator;
begin
  result := self;
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
        FID := FParent.AppendChildNode(self);
        FParent.ChildUpdate(self);
      end;
end;

function TGedComObj.GetFtype: integer;
begin
  result:= FType;
end;

procedure TGedComObj.SetRoot(AValue: IGedParent);
var
    lch: TGedComObj;
begin
    if @FRoot = @AValue then
        Exit;
    FRoot := AValue;
    for lch in self do
        lch.root := AValue;
end;

procedure TGedComObj.SetNodeID(AValue: string);
begin
    if FNodeID = AValue then
        Exit;
    FNodeID := AValue;
end;

procedure TGedComObj.SetNodeType(AValue: string);
begin
  if FNodeType=AValue then Exit;
  FNodeType:=AValue;
end;

function TGedComObj.GetData: string;
begin
    Result := '';
end;

function TGedComObj.GetLink: TGedComObj;
begin
    if Assigned(FRoot) and (copy(GetData, 1, 1) = '@') then
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

function TGedComObj.AppendChildNode(aChild: TGedComObj): integer;
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
    FUpdating := True;
end;

procedure TGedComObj.EndUpdate;
var
    lChlds: TGedComObj;
begin
    if not FUpdating then
        Exit;
    for lChlds in self do
        lChlds.EndUpdate;
    FUpdating := False;
    if Fchanged and Assigned(parent) then
        Parent.ChildUpdate(self);
    FChanged := False;
end;

procedure TGedComObj.ChildUpdate(aChild: TGedComObj);
begin
    if Assigned(parent) and not FUpdating then
      begin
        FChanged := False;
        Parent.ChildUpdate(self);
      end
    else
        Fchanged := True;
end;

function TGedComObj.GetObject: TObject;
begin
    Result := self;
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
    AppendChildNode(Result);
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
    lOrgCh: TGedComObj;
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
            if not lCild.Data.StartsWith('@') and assigned(lOrgCh) and
                lOrgCh.Equals(lCild) then
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

function TGedComObj.GetRevEnumerator(Filter: String): TGedComRevEnumerator;
begin
  result :=TGedComRevFltEnumerator.Create(self,Filter);
end;

class function TGedComObj.AssNodeType: string;
begin
    Result := '';
end;

class function TGedComObj.HandlesNodeType(aType: string): boolean;
begin
    Result := False;
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

function TGedComDefault.AppendChildNode(aChild: TGedComObj): integer;
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
    aChild.Root := FRoot;
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
        ChildUpdate(aChild);
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

procedure TGedComDefault.SetShortcutChild(const AValue: TGedComObj;
  var aShortcut: TGedComObj; const aNodeType: string);

var
        lNode: TGedComObj;

    begin
        if aValue = aShortCut then
            exit;
        BeginUpdate;
        if assigned(aShortcut) then
          begin
            lNode := aShortcut;
            RemoveChild(lNode);
            FreeAndNil(lNode);
          end;
        if assigned(AValue) then
            AValue.NodeType := aNodeType;
        aShortcut := AValue;
        AppendChildNode(AValue);
        EndUpdate;
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
    if @FOnLongOp = @AValue then
        Exit;
    FOnLongOp := AValue;
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
    OnUpd, OnLongOp: TNotifyEvent): IGedParent;

var
    ActLevel: integer;
    actVar: array of IGedParent;
    lTime: QWord;

    procedure AppendLine(const Line: string);

    var
        LineLevel : integer;
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
            if assigned(OnLongOp) and (GetTickCount64 - lTime > 100) then
              begin
                onLongOp(NewVar);
                lTime := GetTickCount64;
              end;
            while ActLevel > LineLevel do
              begin
                actVar[ActLevel + 1].EndUpdate;
                Dec(ActLevel);
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
  OnUpd, OnLongOp: TNotifyEvent; aFilter: TFilterProc);

var
    lTime: QWord;

    procedure ThrowEvents(const lActChild: TGedComObj; const Level: integer);
    begin
        if assigned(OnUpd) and (Level = 0) then
            OnUpd(lActChild);
        if assigned(onLongOp) and (GetTickCount64 - ltime > 100) then
          begin
            onLongOp(lActChild);
            lTime := GetTickCount64;
          end;
    end;

    procedure IterateParent(const Lines: TStrings; gcParent: IGedParent; Level: integer);

    var
        lActChild: TGedComObj;

    begin
        if (gcParent = gcBase) and (gcParent.ChildCount > 3) then
          begin
            for lActChild in gcParent do
                if (lActChild.NodeType = 'HEAD') or
                    (lActChild.NodeType = 'SUBM') or
                    (lActChild.NodeType = 'INDI')
                then
                  begin
                    if (lActChild.NodeType='INDI') and
                        assigned(aFilter) and
                        not aFilter(lActChild) then
                          continue;
                    Lines.Append(BuildgedcomLine(Level, lActChild));
                    IterateParent(Lines, lActChild, Level + 1);
                    ThrowEvents(lActChild, Level);
                  end;
            for lActChild in gcParent do
                if (lActChild.NodeType <> 'HEAD') and
                    (lActChild.NodeType <> 'SUBM') and (lActChild.NodeType <> 'INDI')
                then
                  begin
                    if (lActChild.NodeType <> 'HEAD') and
                    (lActChild.NodeType <> 'SUBM') and
                    (lActChild.NodeType <> 'INDI') and
                    (lActChild.NodeType <> 'TRLR') and
                        assigned(aFilter) and
                        not aFilter(lActChild) then
                          continue;
                    Lines.Append(BuildgedcomLine(Level, lActChild));
                    IterateParent(Lines, lActChild, Level + 1);
                    ThrowEvents(lActChild, Level);
                  end;
          end
        else
            for lActChild in gcParent do
              begin
                Lines.Append(BuildgedcomLine(Level, lActChild));
                IterateParent(Lines, lActChild, Level + 1);
                ThrowEvents(lActChild, Level);
              end;
    end;

begin
    lTime := GetTickCount64;
    IterateParent(Lines, gcBase, 0);
end;

procedure TGedComFile.LoadFromStream(st: TStream);
var
    lst: string='';
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
        ParseGed(lsl, self, OnReadUpdate, FonLongOp);
      finally
        FreeAndNil(lsl)
      end;
    FChanged := False;
end;

procedure TGedComFile.WriteToStream(st: TStream; aFilter: TFilterProc);

var
    lsl: TStringList;
    lst: string;
    lbEncoded: boolean;
begin
    lsl := TStringList.Create;
      try
        PutGed(lsl, self, FOnWriteUpdate, FonLongOp,aFilter);
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
    AppendChildNode(Result);
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

procedure TGedComFile.AppendUnresolvedLink(aLink: string; aObj1: TGedComObj);
begin

end;

function TGedComFile.AppendChildNode(aChild: TGedComObj): integer;
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

function TGedComFile.RevEnum: TGedComRevEnumerator;
begin
    result := TGedComRevEnumerator.Create(self);
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

function TGedComFile.GetObject: TObject;
begin
    Result := Self;
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
    lGC := ParseGed(lLines, nil, nil, nil);
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
    setlength(Result{%H-}, 1);
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

end.
