unit tst_GedComExt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,Cmp_GedComFile,Cls_GedComExt;

type
  { TTestGedComExtBase }
  TTestGedComExtBase = class(TTestCase,IGedParent)
  private
  protected
    FDataPath: String;
    FChild:TGedComObj;
    function AppendChildNode(aChild: TGedComObj): integer;
    procedure RemoveChild(aChild: TGedComObj);
    function GetChildIdx(aChild: TGedComObj): integer;
    function GetChild(Idx: variant): TGedComObj;
    function GetParent: IGedParent;
    function Find(aID: string): TGedComObj;
    function ChildCount: integer;
    function GetEnumerator: TGedComObjEnumerator;
    procedure EndUpdate;virtual;
    procedure ChildUpdate(aChild: TGedComObj);virtual;
    function GetObject: TObject;
  published
  public
    Constructor Create; override;
  end;


   { TTestGedComEvent }
    TTestGedComExt= class(TTestGedComExtBase)
    private
    protected
      procedure SetUp; override;
      procedure TearDown; override;
    published
      procedure TestSetUp;
      Procedure TestTagToNatur;
      Procedure TestDatetime2GedDate;
      Procedure TestGedDate2DateTime;
    public
    end;



 { TTestGedComEvent }
  TTestGedComEvent= class(TTestGedComExtBase)
  private
    FEndUpdateCnt:integer;
    FChildUpdateCnt:integer;
    function GetEvent: TGedEvent;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure EndUpdate;override;
    procedure ChildUpdate(aChild: TGedComObj);override;
  published
    procedure TestSetUp;
  public
    property GedEvent:TGedEvent read GetEvent;

  end;

implementation

uses unt_GenTestBase;

{ TTestGedComExt }

procedure TTestGedComExt.SetUp;
begin
end;

procedure TTestGedComExt.TearDown;
begin
end;

procedure TTestGedComExt.TestSetUp;
begin
  CheckTrue(DirectoryExists(FDataPath),'Datapath exists');
end;

procedure TTestGedComExt.TestTagToNatur;
begin
  CheckEquals('born',TagToNatur(CEventBirth,0),'TagToNatur(CEventBirth,0)');
  CheckEquals('baptised',TagToNatur(CEventBaptism,0),'TagToNatur(CEventBaptism,0)');
  CheckEquals('married',TagToNatur(CEventMarriage,0),'TagToNatur(CEventMarriage,0)');
  CheckEquals('died',TagToNatur(CEventDeath,0),'TagToNatur(CEventDeath,0)');
  CheckEquals('burried',TagToNatur(CEventBurial,0),'TagToNatur(CEventBurial,0)');
  CheckEquals('confirmed',TagToNatur(CEventConfirm,0),'TagToNatur(CEventConfirm,0)');
  CheckEquals('divorced',TagToNatur(CEventDivource,0),'TagToNatur(CEventDivource,0)');
end;

procedure TTestGedComExt.TestDatetime2GedDate;
begin
  CheckEquals('21 JAN 1971',Datetime2GedDate(EncodeDate(1971,1,21)),'Datetime2GedDate(CEventBirth,0)');
end;

procedure TTestGedComExt.TestGedDate2DateTime;
var
  lModif: string;
begin
  CheckEquals(EncodeDate(1971,1,1),GedDate2DateTime('1971',lModif),'GedDate2DateTime(''21 JAN 1971'')');
  CheckEquals('',lModif,'Modifyer is Empty');
  CheckEquals(EncodeDate(1971,1,1),GedDate2DateTime('JAN 1971',lModif),'GedDate2DateTime(''21 JAN 1971'')');
  CheckEquals('',lModif,'Modifyer is Empty');
  CheckEquals(EncodeDate(1971,1,21),GedDate2DateTime('21 JAN 1971',lModif),'GedDate2DateTime(''21 JAN 1971'')');
  CheckEquals('',lModif,'Modifyer is Empty');
  CheckEquals(EncodeDate(1971,1,21),GedDate2DateTime('EST 21 JAN 1971',lModif),'GedDate2DateTime(''21 JAN 1971'')');
  CheckEquals('EST',lModif,'Modifyer is EST');
end;

{ TTestGedComEvent }

function TTestGedComEvent.GetEvent: TGedEvent;
begin
  Result:=TGedEvent(FChild);
end;

procedure TTestGedComEvent.SetUp;
var
  lEvent: TGedEvent;
begin
  lEvent := TGedEvent.Create('','EVEN','');
  lEvent.Parent:=self;
  lEvent.Root:=self;
  FEndUpdateCnt:=0;
  FChildUpdateCnt:=0;
end;

procedure TTestGedComEvent.TearDown;
begin
  FreeandNil(FChild);
end;

procedure TTestGedComEvent.EndUpdate;
begin
  inc(FEndUpdateCnt);
end;

procedure TTestGedComEvent.ChildUpdate(aChild: TGedComObj);
begin
   inc(FChildUpdateCnt);
end;

procedure TTestGedComEvent.TestSetUp;
begin
  CheckTrue(DirectoryExists(FDataPath),'Datapath exists');
  CheckNotNull(GedEvent,'GedEvent is assigned');
end;


{ TTestGedComExtBase }
constructor TTestGedComExtBase.Create;

begin
    inherited Create;
    FDataPath:=GetDataPath('GenData');
end;

function TTestGedComExtBase.AppendChildNode(aChild: TGedComObj): integer;
begin
  if FChild=aChild then exit;
  FChild:=aChild;
end;

procedure TTestGedComExtBase.RemoveChild(aChild: TGedComObj);
begin
  if FChild<>aChild then exit;
  FChild:=nil;
end;

function TTestGedComExtBase.GetChildIdx(aChild: TGedComObj): integer;
begin
  result :=-1;
  if aChild=FChild then
    exit(0);
end;

function TTestGedComExtBase.GetChild(Idx: variant): TGedComObj;
begin
 result := nil;
 if idx=0 then
   exit(FChild)
end;

function TTestGedComExtBase.GetParent: IGedParent;
begin
  result := nil;
end;

function TTestGedComExtBase.Find(aID: string): TGedComObj;
begin
  result := nil;
  if Assigned(FChild) and (FChild.NodeType=aID) then
    exit(FChild)
end;

function TTestGedComExtBase.ChildCount: integer;
begin
  result:= 0;
  if assigned(FChild) then exit(1);
end;

function TTestGedComExtBase.GetEnumerator: TGedComObjEnumerator;
begin
  result := nil;
end;

procedure TTestGedComExtBase.EndUpdate;
begin
  // this is intentionally empty
end;

procedure TTestGedComExtBase.ChildUpdate(aChild: TGedComObj);
begin
  // this is intentionally empty
end;

function TTestGedComExtBase.GetObject: TObject;
begin
   result := self;
end;

initialization

 RegisterTest(TTestGedComExt);
  RegisterTest('TTestGedComExt',TTestGedComEvent);
end.

