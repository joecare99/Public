unit Cmp_GedComFile;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
{$Interfaces CORBA}

interface

uses Classes, SysUtils, Unt_FileProcs;

type
  TGedComObj = class;

  IGedParent = interface
    ['{AFA6D380-06CD-41D8-B195-DF54C7308E7E}']
    function appendChild(aChild: TGedComObj): integer;
    procedure RemoveChild(aChild: TGedComObj);
    function GetChildIdx(aChild: TGedComObj): integer;
    function GetChild(Idx: integer): TGedComObj;
    Function GetParent:IGedParent;
    function ChildCount: integer;
  end;

  { TGedComObj }

  TGedComObj = class(IGedParent)
  private
    FNodeID: string;
    FParent: IGedParent;
    FChildren: array of TGedComObj;
    FInformation: string;
    FNodeType: string;
    procedure SetNodeID(AValue: string);
    procedure SetParent(AValue: IGedParent);
  protected
    function appendChild(aChild: TGedComObj): integer; virtual;
    procedure RemoveChild(aChild: TGedComObj); virtual;
    function GetChildIdx(aChild: TGedComObj): integer; virtual;
    function GetChild(Idx: integer): TGedComObj;
    function GetParent: IGedParent;
    function ChildCount: integer;
  public
    destructor Destroy; override;
    Constructor Create(const aID,aType,aInfo:string);virtual;overload;
    function ToString: ansistring; override;
    function CByType(aType:String): TGedComObj;
    property Parent: IGedParent read FParent write SetParent;
    property Information: string read FInformation write FInformation;
    property NodeType: string read FNodeType write FNodeType;
    property NodeID: string read FNodeID write SetNodeID;
    property Count:integer read ChildCount;
    property Child[Index: integer]: TGedComObj read GetChild; default;
  public
    class function AssNodeType:String;virtual;
    class function HandlesNodeType({%H-}aType:string):Boolean;virtual;
  end;
  TGedObjClass = class of TGedComObj;
  { TGedComFile }

  TGedComFile = class(CFileInfo, IGedParent)
  private
    FChanged: Boolean;
    FChildren: array of TGedComObj;
    FEncoding:String;
    FIdx:TStringList;
    FOnUpdate: TNotifyEvent;
    FOnWriteUpdate:TNotifyEvent;
    procedure OnReadUpdate(Sender: TObject);
    class function ParseLine(const Line: string; out NodeID, NodeType,
      Information: String): Integer;
    class var FGedComObjects:array of TGedObjClass;
    procedure SetEncoding(AValue: String);
    procedure SetOnUpdate(AValue: TNotifyEvent);
    procedure SetOnWriteUpdate(AValue: TNotifyEvent);
  protected
    function appendChild(aChild: TGedComObj): integer; virtual;
    procedure RemoveChild(aChild: TGedComObj); virtual;
    function GetChildIdx(aChild: TGedComObj): integer; virtual;
    function GetChild(Idx: integer): TGedComObj;
     function GetParent: IGedParent;
    function ChildCount: integer;
  public
    ///<author>Joe Care</author>
    ///  <version>1.00.02</version>
    Constructor Create;

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
    class Procedure RegisterGedComClass(aGCClass:TGedObjClass);

    ///<author>Joe Care</author>
    ///  <version>1.00.02</version>
    class function ParseGed(const Lines: TStrings; gcBase: IGedParent = nil;OnUpd:TNotifyEvent=nil): IGedParent;

    ///<author>Joe Care</author>
    ///  <version>1.00.02</version>
    class Procedure  PutGed(const Lines: TStrings; gcBase: IGedParent;OnUpd:TNotifyEvent=nil);

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
    Procedure AppendIndex(const aIdx:String;const aGedObj:TGedComObj);
    property Count:integer read ChildCount;
    PRoperty Child[idx:integer]:TGedComObj read GetChild; default;
    Property OnUpdate:TNotifyEvent read FOnUpdate write SetOnUpdate;
    Property OnWriteUpdate:TNotifyEvent read FOnWriteUpdate write SetOnWriteUpdate;
    Property Encoding:String read FEncoding write SetEncoding;
  end;

implementation

uses Unt_StringProcs, LConvEncoding;

{ TGedComObj }

resourceString
  rsGenealogieExchangeFile = 'Genealogie-Exchange-File';


procedure TGedComObj.SetParent(AValue: IGedParent);
begin
  if FParent = AValue then
    Exit;
  if (AValue = nil) and assigned(FParent) then
    FParent.RemoveChild(self);
  FParent := AValue;
  if assigned(FParent) then
    FParent.appendChild(self);
end;

procedure TGedComObj.SetNodeID(AValue: string);
begin
  if FNodeID = AValue then
    Exit;
  FNodeID := AValue;
end;

function TGedComObj.appendChild(aChild: TGedComObj): integer;
var
  i: integer;
begin
  if not assigned(aChild) then
    exit(-1);
  for i := 0 to high(FChildren) do
    if FChildren[i] = aChild then
      exit(i);
  setlength(FChildren, high(FChildren) + 2);
  Result := high(FChildren);
  FChildren[Result] := aChild;
  if aChild.Parent <> iGedparent(self) then
    aChild.Parent := self;
end;

procedure TGedComObj.RemoveChild(aChild: TGedComObj);
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

function TGedComObj.GetChildIdx(aChild: TGedComObj): integer;
var
  i: integer;
begin
  Result := -1;
  if not assigned(aChild) then
    exit;
  for i := 0 to high(FChildren) do
    if FChildren[i] = aChild then
      exit(i);
end;

function TGedComObj.GetChild(Idx: integer): TGedComObj;
begin
  Result := FChildren[idx];
end;

function TGedComObj.GetParent: IGedParent;
begin
  result := FParent;
end;

function TGedComObj.ChildCount: integer;
begin
  Result := length(FChildren);
end;

destructor TGedComObj.Destroy;
var
  i: integer;
begin
  for i := high(FChildren) downto 0 do
    FreeAndNil(FChildren[i]);
  setlength(FChildren, 0);
end;

constructor TGedComObj.Create(const aID, aType, aInfo: string);
begin
  inherited Create;
  FNodeType:=aType;
  FNodeID:=aID;
  FParent:=nil;
  FInformation:=aInfo;
end;

function TGedComObj.ToString: ansistring;
begin
  Result := FNodeType;
  if FNodeID <> '' then
    Result := FNodeID + ' ' + Result;
  if FInformation <> '' then
    Result := Result + ' ' + FInformation;
end;

function TGedComObj.CByType(aType: String): TGedComObj;
var
  i: Integer;
begin
  result:=nil;
  for i := 0 to high(FChildren) do
    if FChildren[i].NodeType=aType then
      begin
        result:=FChildren[i];
        break;
      end;
end;

class function TGedComObj.AssNodeType: String;
begin
  result := ''
end;

class function TGedComObj.HandlesNodeType(aType: string): Boolean;
begin
  result := true;
end;

{ TGedComFile }

class function TGedComFile.ParseLine(const Line: string; out NodeID, NodeType,
  Information: String): Integer;
var
  ep: SizeInt;
  sp: integer;
begin
  NodeID :='';
  NodeType :='';
  Information :='';
  result := -1;
 if trystrtoint(trim(copy(Line, 1, 2)), result) then
   begin
    sp := 3;
    if copy(line, 3, 1) = '@' then
     begin
      ep := pos(' ', line, sp + 1);
      NodeID := copy(line, sp, ep - sp);
      sp := ep + 1;
     end
    else if result > 9 then
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
  if @FOnUpdate=@AValue then Exit;
  FOnUpdate:=AValue;
end;

procedure TGedComFile.SetEncoding(AValue: String);
var
  lCharNode: TGedComObj;
begin
  if FEncoding=AValue then Exit;
  FEncoding:=AValue;
  if (high(FChildren)>=0 ) then
    begin
      lCharNode:= FChildren[0].CByType('CHAR');
      if assigned(lCharNode) then
        lCharNode.Information:=AValue;
    end;
end;

procedure TGedComFile.SetOnWriteUpdate(AValue: TNotifyEvent);
begin
  if @FOnWriteUpdate=@AValue then Exit;
  FOnWriteUpdate:=AValue;
end;

procedure TGedComFile.OnReadUpdate(Sender: TObject);
begin
  if sender.InheritsFrom(TGedComObj) then
   with sender as TGedComObj do
    begin
      if NodeID <> '' then
         AppendIndex(NodeID,Sender as TGedComObj);
    end;
  if assigned(FOnUpdate) then
    FOnUpdate(Sender);
end;


class function TGedComFile.ParseGed(const Lines: TStrings; gcBase: IGedParent;
  OnUpd: TNotifyEvent): IGedParent;

var
  ActLevel: integer;
  actVar: array of IGedParent;

  procedure AppendLine(const Line: string);

  var
    LineLevel,i,LGedObj: integer;
    newvar: TGedComObj;
    lNodeID, lNodeType, lInformation: String;

  begin
    LineLevel := ParseLine(Line,lNodeID,lNodeType,lInformation);
    if (LineLevel>=0) and (LineLevel <= ActLevel+1) then
    begin
      if LineLevel = ActLevel + 1 then
        setlength(actVar, LineLevel + 2);
        for i := high(FGedComObjects) downto 0 do
          if FGedComObjects[i].HandlesNodeType(lNodeType) then
            begin
              lGedObj:=i;
              break;
            end;
        newvar := FGedComObjects[lGedObj].Create(lNodeId,lNodeType,lInformation);
        newvar.Parent := actVar[LineLevel];
        if (lNodeID <> '') and assigned(OnUpd) then
          OnUpd(newvar);
        actVar[LineLevel + 1] := newvar;
        ActLevel := LineLevel;
    end
  end;

var

  I: integer;

begin
  ActLevel := -1;
  setlength(actVar, 1);
  if assigned(gcBase) then
    actVar[0] := gcBase
  else
    actvar[0] := TGedComObj.Create('','_BASE','');
  for I := 0 to Lines.Count - 1 do
    AppendLine(Lines[i]);
  Result := actVar[0];
end;

class function BuildgedcomLine(Level:integer;const lActChild:TGedComObj):string;
begin
  result := inttostr(Level);
  if lActChild.NodeID <> '' then
    result := result + ' '+lActChild.NodeID;
  result := result + ' '+lActChild.NodeType;
  if lActChild.Information <> '' then
    result := result + ' '+lActChild.Information;
end;

class procedure TGedComFile.PutGed(const Lines: TStrings; gcBase: IGedParent;
  OnUpd: TNotifyEvent);

  procedure IterateParent(const Lines: TStrings; gcParent: IGedParent;Level:integer);

  var
    lActChild: TGedComObj;
    i: Integer;
  begin
    for i := 0 to gcParent.ChildCount-1 do
      begin
        lActChild := gcParent.GetChild(i);
        Lines.Append(BuildgedcomLine(Level,lActChild));
        IterateParent(Lines,lActChild,Level+1);
        if assigned(OnUpd) and (Level=0) then
          OnUpd(lActChild);
      end;
  end;

begin
  IterateParent(Lines,gcBase,0);
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
    ParseGed(lsl, self, OnReadUpdate);
   finally
    FreeAndNil(lsl)
   end;
  FChanged := false;
end;

procedure TGedComFile.WriteToStream(st: TStream);

var
  lsl: TStringList;
  lst: String;
  lbEncoded: boolean;
begin
  lsl := TStringList.Create;
   try
      PutGed(lsl,self,FOnWriteUpdate);
      if FEncoding <> '' then
        lst:=ConvertEncodingFromUTF8(lsl.text,FEncoding,lbEncoded)
      else
        lst:=lsl.text;
      st.WriteBuffer(lst[1],length(lst));
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
end;

procedure TGedComFile.AppendIndex(const aIdx: String; const aGedObj: TGedComObj);
begin
  Fidx.AddObject(aIdx,aGedObj);
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
  Result := high(FChildren);
  FChildren[Result] := aChild;
  aChild.Parent := self;
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
  for i := 0 to high(FChildren) do
    if FChildren[i] = aChild then
      exit(i);
end;

function TGedComFile.GetChild(Idx: integer): TGedComObj;
begin
  Result := FChildren[Idx];
end;

function TGedComFile.GetParent: IGedParent;
begin
  result := nil;
end;

function TGedComFile.ChildCount: integer;
begin
  Result := length(FChildren);
end;

constructor TGedComFile.Create;
begin
  Inherited;
  FIdx:= TStringList.Create;
end;

destructor TGedComFile.Destroy;
begin
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
  lGC := ParseGed(lLines);
  lLines.Free;
  Result := '[' + csSection + ']' + LineEnding;
  lresult2 := '[' + cSWildCardFill + ']' + LineEnding;
  for i := 0 to lGC.ChildCount - 1 do
   begin
    Result := Result + lowercase(lGC.GetChild(i).NodeType) + '=' +
      lGC.GetChild(i).Information + LineEnding;
    lresult2 := lresult2 + lowercase(lGC.GetChild(i).NodeType)[1] +
      '=' + lGC.GetChild(i).Information + LineEnding;
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
  setlength(FGedComObjects,length(FGedComObjects)+1);
  FGedComObjects[high(FGedComObjects)]:=aGCClass;
end;

initialization
   RegisterGetInfoProc(TGedComFile);
   TGedComFile.RegisterGedComClass(TGedComObj);
end.
