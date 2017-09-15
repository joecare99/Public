unit dm_GenData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, FileUtil, dbf, DB, sqldb,
  mysql57conn, mysql56conn, Grids, Controls, ComCtrls,
  IniFiles;

type
  TArrayOfIntegers = array of integer;

  { TdmGenData }

  TdmGenData = class(TDataModule)
    Database: TSQLConnector;
    dsNames: TDataSource;
    qryInternal: TSQLQuery;
    qryInternal2: TSQLQuery;
    qryNames: TSQLQuery;
    qrySysInfo: TSQLQuery;
    Query1: TSQLQuery;
    Query2: TSQLQuery;
    Query3: TSQLQuery;
    Query4: TSQLQuery;
    Query5: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    TMG: TDbf;
    procedure DataModuleCreate(Sender: TObject);
  private
    FOnModifyEvent: TNotifyEvent;
    FOnModifyIndividual: TNotifyEvent;
    FProjectIsOpen: boolean;
    FInifile: TIniFile;
    function getDB_Connected: boolean;
    function GetProjectIsOpen: boolean;
    procedure SetDB_Connected(AValue: boolean);
    procedure SetOnModifyEvent(AValue: TNotifyEvent);
    procedure SetOnModifyIndividual(AValue: TNotifyEvent);

    { private declarations }
  public
    { public declarations }
    Filo: TStringGrid;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetCode(out code: string; out no: integer); overload;deprecated;
    procedure PutCode(code: string; no: integer); overload; deprecated;
    procedure GetCode(out code: string; out no: string); overload; deprecated;
    procedure PutCode(code: string; no: string); overload; deprecated;

    // Configuration
    procedure ReadCfgConnection(out Host, User, Password: string);
    procedure WriteCfgConnection(Host, User, Password: string);
    procedure ReadCfgProject(out ProjectName: string; out Connected: boolean);
    procedure WriteCfgProject(const ProjectName: string; Connected: boolean);
    procedure ReadCfgLastPerson(out idLastPerson: integer);
    procedure WriteCfgLastPerson(const idLastPerson: integer);
    function ReadCfgInteger(const Section, Ident: string; Default: longint): longint;
    procedure WriteCfgInteger(const Section, Ident: string; Data: longint);
    function ReadCfgString(const Section, Ident, Default: string): string;
    procedure WriteCfgString(const Section, Ident, Value: string);
    procedure ReadCfgFormPosition(Sender: TForm; a: integer; b: integer;
      c: integer; d: integer);
    procedure WriteCfgFormPosition(Sender: TForm);
    procedure ReadCfgGridPosition(Sender: TStringGrid; cols: integer);
    procedure WriteCfgGridPosition(Sender: TStringGrid; cols: integer);

    // Individuum - Methods
    function GetDataOfInd(const nID: longint; out sSex, sLiving, sDate: string;
      out iInterest: longint): boolean;
    procedure InsertIndividuumData(const idInd: integer;
      const Importance: integer; const Date: string; const Sex: string;
      const Living: string);
    procedure FullDeleteIndividuum(const idInd: longint);
    function FullCopyPerson(idInd: integer): integer;
    procedure GetIndBaseData(idInd: integer; out sName, sBirth, sDeath: string);
    function GetFirstIndividuum: integer;
    function IsValidIndividuum(idInd: integer): boolean;
    function GetSexOfInd(const nID: longint): string;
    function GetLivingOfInd(const nID: longint): string;
    procedure UpdateIndLiving(const lidInd: integer; NewVal: char;
      const Sender: TObject);
    procedure UpdateIndSex(const lidInd: integer; NewVal: char;
      const Sender: TObject);
    procedure UpdateIndInterrest(const lidInd: integer; NewVal: integer;
      const Sender: TObject);
    function CopyIndividual(const nID: longint): longint;
    function AddNewIndividual(sex, living: string; interest: integer): longint;
    procedure RepairRelDateByIndDate(const OnProgress: TNotifyEvent);
    procedure SaveModificationTime(no: integer); overload;
    procedure SaveModificationTime(no: string); overload;
      deprecated {$IFNDEF NoFormat} 'use integer-variant' {$ENDIF};
    procedure UpdateIndModificationTimeByName(lLinkID: integer);
    procedure UpdateIndModificationTimesByEvent(lLinkID: integer);

    // Name
    function getIdNameofInd(const lidInd: integer): integer;
    procedure GetNameData(const lidName: integer; out idInd, idType: longint;
      out iName, Memo, Phrase, aDate, SortDate: string; out Pref: boolean);
    function SaveNameData(idName: longint; const Prefered: boolean;
      const lidEvType: PtrInt; const Phrase: string; const SDate: string;
      const PDate: string; const lMemoText: string; const i4: string;
      const i3: string; const i2: string; const i1: string; const lName: string;
      const lidInd: longint): integer;
    procedure UpdateNameI3(const lDate: string; const lidInd: integer);
    procedure UpdateNameI4(const lDate: string; const lidInd: integer);
    procedure UpdateNamesPrefered(const idNamePref, idNameUnPref: integer);
    function GetIndividuumName(idInd: integer): string;
    function GetIndividuumName(NStr: string): string;
      overload; deprecated {$IFNDEF NoFormat} 'use integer-variant' {$ENDIF};
    function GetI3(idInd: integer): string;
    function GetI4(idInd: integer): string;
    procedure DeleteName(const lidName: integer);
    procedure RepairNameOrder(OnUpdate: TNotifyEvent);

    // Explorer
    procedure FillExplorerIndex(const aGrid: TStringGrid; Order: integer;
      const OnProgress: TNotifyEvent = nil);
    procedure FillIndexBySearchtext(const lGrid: TStringGrid;
      const lSearchText: string; const lOnProgress: TNotifyEvent);

    // Name Methods
    procedure PopulateNameTable(const lidInd: longint; tblName: TStringGrid);
    function CopyName(const lidName: longint; out i1, i2, i3, i4: string): longint;
    function CopyIndName(const idInd, idNewInd: longint): longint;

    // Relation Methods
    procedure GetRelationData(const idRelation: integer;
      out lSortDate: string; out lPhraseText: string; out lMemoText: string;
      out lPrefered: boolean; out lidParent: longint; out lidChild: longint;
      out lRelType: longint);
    function SaveRelationData(const idRelation: integer;
      const lPhrase: TCaption; const lSDate: TCaption; const lidType: PtrInt;
      const prefered: boolean; const lidParent: integer;
      const lidChild: integer; const lMemoText: string): integer;
    procedure InsertRelation(const lidParent: longint; const lidChild: longint;
      const lidType: longint; const lidRelation: longint;
  const lPhrase: string; const lSDate: string; const lNote: string;
  lidPrefered: Boolean);
    function CopyRelation(lidRelation: integer; idNewInd: integer = 0): longint;
    function RelationInsertData(idType, IdInd, idLink: integer;
      const Note: string = ''; const Phrase: string = ''; Prefered: boolean = True;
      Date: string = ''): integer;
    function CheckIndChildExists(const lidParent: longint): boolean;
    function CheckIndParentExists(const lidInd: longint): boolean;
    function CheckPrefParentExists(const lSex: string;
      const lidInd: longint): boolean;
    procedure AppendSiblings(const Liste: TStringGrid; idInd: integer);
    procedure AppendSpousesSpouses(const Liste: TStringGrid; idInd: integer);
    function CheckIndRelationExist(idInd: integer): boolean;
    function GetChild(idInd: integer): TArrayOfIntegers;
    function GetParents(idInd: integer): TArrayOfIntegers;
    procedure UpdateRelationSortdate(var lidInd: integer; var lDate: string);
    procedure PopulateParents(aSG: TStringGrid; idChild: longint); overload;
    procedure PopulateParents(aSG: TStringGrid; NStr: string);
      overload; deprecated {$IFNDEF NoFormat} 'use integer-variant' {$ENDIF};
    procedure FillChildrenList(const LTable: TStringGrid;
      const lidInd: integer; out principaux: integer);
    procedure ResetRelationPrefered(const lidInd, lidIndRel: integer;
      const lidRelation: integer);
    procedure SetRelationPrefered(const lidInd, lidIndRel: integer;
      const lidRelation: integer);
    function GetRelationChildExists(const lidChild: longint): boolean;
    procedure AppendRelationTreeVParents(const lTreeView: TTreeView);
    procedure AppendRelationTreeVChildren(const lTreeView: TTreeView);
    procedure FillSiblingsTable(const lTable: TStringGrid; const lidInd: longint);
    function GetIndSpouse(const idInd: longint; out Spouse: string): integer;
    procedure DeleteRelation(const lidRelation: PtrInt);
    procedure DeleteRelationFull(const lidInd: integer;
      const lidIndChild: integer; const lidRelation: integer);
    procedure UpdateIndModificationTimesByRelation(lLinkID: integer);

    // Event Methods
    procedure FillTableEvents(const idInd: integer; const lgrdEvents: TStringGrid);
    function GetEventType(const lIdEvent: integer): string;
    procedure CopyEvent(const idEvent: integer);
    function SaveEventData(const pidEvent: integer; const pidType: integer;
      const pIdPlace: integer; const pPrefered: boolean;
      const pInfo: string = ''; const pDate: string = '';
      const pSortDate: string = ''): integer;
    procedure DeleteEvent(const lidEvent: integer);
    function GetEventExtType(idEvent, idInd: integer;
      out EvType, TypeType: string): boolean;
    procedure DeleteEventComplete(const lidEvent: integer);
    function CheckIndSharedEventExists(idInd: integer): boolean;
    procedure ResetEventPrefered(lidEvent: integer);
    procedure ResetEventPref(lidEvent: integer);
    procedure SetEventPref(lidEvent: integer);
    function SetEventPrefered(const lidEvent, lidInd: integer): boolean;
    procedure InsertEvent(const idEvent: longint; const idType: longint;
      const idPlace: longint; const Prefered: boolean; const lMemo: string = '';
      const SDate: string = ''; const PDate: string = '');

    //Witness
    function AppendWitness(Role, Phrase: string; idInd, idEvent: integer;
      Pref: boolean): integer;
    procedure InsertWitness(const Prefered: boolean; const idEvent: longint;
      const idInd: longint; const Role: string; const Phrase: string);
      deprecated {$IFNDEF NoFormat} 'use AppendWitness' {$ENDIF};
    function GetWitnessListbyEvent(lidEvent: integer): string;
    procedure UpdateWitnessModDatebyEvent(lidEvent: integer);
    procedure UpdateWitnessModbyEvent(lidEvent: integer);
    procedure DeleteWitnessbyEvent(const lidEvent: integer);
    procedure UpdateWitnessPhraseRole(const idWitness: integer;
      const Role: string; const Phrase: string);

    // Citation Methods
    procedure GetCitationData(idCitation: integer; out lTypeCode: string;
      out lLinkID: integer; out lMemoText: string;
      out lidSource, lQuality: integer);
    function SaveCitationData(const lidCitation: integer;
      const lTypeCode: string; const lLinkID: integer; const lMemoText: string;
      const lidSource, lQuality: integer): integer;
    procedure InsertCitation(const idSource: longint; const LinkID: longint;
      const MemoText: string; const LinkType: string; const Quality: integer);
    procedure CopyCitation(AType: string; idLink, idNewLink: integer); overload;
    procedure CopyCitation(AType: string; idLink: integer; ANewType: string;
      idNewLink: integer); overload;
    procedure CopyCitationOfIndByType(const lidInd: integer;
      const lSourceType: string; const lidInd_Dest: integer; const lDestType: string);

    function GetCitationBestQuality(sType: string; idLink: integer): string;
    procedure PopulateCitations(Tableau: TStringGrid; Code: string;
      idName: integer); overload;
    procedure PopulateCitations(Tableau: TStringGrid; Code: string; NStr: string);
      overload; deprecated;
    procedure DeleteCitation(const lidCitation: integer);
    procedure DeleteCitationb_TypeId(const aType: string; const id: integer);
    procedure DeleteCitationsbyType_ID(const aType: char; const aID: integer);

    // Documents Methods
    function SaveDocumentData(lidDocument: integer; const lLinkID: integer;
      const lDocumentType: TCaption; const lFileName: TCaption;
      const lDocumentDescription: TCaption;
      const lDocumentTitle: TCaption): integer;
    procedure UpdateDocumentMemo(const lidDocument: integer;
      const lImageMemoText: TCaption);
    procedure UpdateModificationByEventDocument(lidDocument: integer);
    procedure PopulateDocuments(Tableau: TStringGrid; Code: string; no: integer);
    procedure CopyDocumentbyType_ID(const aType: string; const aID, aNewID: integer);
    function GetDocumentFilename(no, IdInd: integer): string;
    function GetDocumentInfo(const lidDocument: Integer): string;
     procedure UpdateDocumentInfo(const lidDocument: integer;
       const lDocumentInfo: string);
    procedure SelectDocumentData(const lidDocument: integer;
      out lPrefered: boolean;
      out lDocumentInfo, lDocType, lFileName, lDocumentDescription,
      lDocumentTitle: string);
    procedure UpdateDocument_SRPrefered(const lidInd: longint;
      const lNewPref: boolean; const lidDocument: integer);
    procedure DeleteDocumentsbyType_ID(const aType: char; const aID: integer);
    procedure DeleteDocument(const lidDocument: integer);

    // Type Methods
    procedure GetTypeData(idType: integer; out TypeCat: string;
      out Phrase: string; out Title: string);
    procedure InsertType(const idType: longint; const Title: string;
      const Phrase: string; const Roles: string; const TypeCat: string);
    procedure SaveTypeData(lidType: integer; const lTitle: TCaption;
      const lPhrase: TCaption; const lTypeChar: string; const roles: string);
    procedure GetTypeList(const aList: TStrings; aType: string;
      Append: boolean = False);
    procedure DeleteType(const lidType: PtrInt);
    procedure FillTableTypes(const ltblTypes: TStringGrid; OnUpdate: TNotifyEvent);
    procedure UpdateTableTypes(const ltblTypes: TStringGrid;
      const lidType: integer);
    procedure GetTypeList(const aList: TStrings; aTypes: array of string);
    function GetTypePhrase(idType: integer): string;
    procedure GetTypePhraseRole(const idType: integer; out Phrase: string;
      out Roles: string);
    function GetTypeName(const idType: longint): string;

    // Source Methods
    procedure InsertSource(const lidSource: longint; const lQuality: longint;
      const lLink: string; const lNote: string; const lDescription: string;
      const lTitle: string);
    function SaveSourceData(const pidSource: integer; const piQuality: integer;
      const psTitle: string; const psDescription: string;
      const psInformation: string; const psAuthor: string): integer;
    function CheckIndSourceExist(idInd: integer): boolean;
    procedure DeleteSourceFull(const lidSource: integer);
    function GetSourceQuality(const lidSource: integer): longint;
    procedure FillSourcesTable(const lNotification: TNotifyEvent;
      const lTable: TStringGrid);
    procedure FillSourcesSL(const LStr: TStrings);
    function GetSourceCitCount(const lidSource: integer): integer;

    // Repository Methods
    function CheckIndDepositExist(idInd: integer): boolean;
    procedure InsertDepot(const lMemo: variant; const lDescription: string;
      const lTitle: string; const lidIndividual: longint;
      const lidRepository: longint);
    procedure FillDepotsSL(const LStr: TStrings);
    procedure InsertDepotOfSource(const lidSource: longint;
      const lidRepository: longint; const buffer: string);

    // Places
    procedure InsertPlace(lidPlace: longint; const Place: string);
    function GetPlaceName(const liResult: integer): string;

    // TMG-Methods
    function CountAllRecordsTMG(const filename: string): longint;

    // Common Methods
    procedure SetDBHostUserPass(const lDBHostName, lDBUser, lDBPassword: string;
      out Success: boolean);
    procedure SetDBSchema(const lDBSchema: string; out bSuccess: boolean);
    function GetDBSchema: string;
    procedure GetDBSchemas(const aList: TStrings);
    procedure CreateDBProject(const db: string; onProgress: TNotifyEvent = nil);
    procedure DeleteDBProject(const db: string);
    function CountAllRecords: longint;
    procedure RepairProjectDB(onProgress: TNotifyEvent = nil);
    procedure RepairIndBirthDeath(onProgress: TNotifyEvent = nil);
    function GetLastIDOfTable(TableName: string): longint;

    procedure NamesChanged(Sender: TObject);
    procedure EventChanged(Sender: TObject);

    property DB_Connected: boolean read GetDB_Connected write SetDB_Connected;
    property ProjectIsOpen: boolean read GetProjectIsOpen;
    property OnModifyIndividual: TNotifyEvent
      read FOnModifyIndividual write SetOnModifyIndividual;
    property OnModifyEvent: TNotifyEvent read FOnModifyEvent write SetOnModifyEvent;
  end;

var
  dmGenData: TdmGenData;
  iniFileName: string = 'stemma.ini';
  resPath: string = 'icons';
  DataPath: string = 'data';

const
  CTagNameTitle = 'Title';
  CTagNameGivenName = 'First name';
  CTagNameFamilyName = 'Name';
  CTagNameSuffix = 'Suffix';
  CTagNameArticle = 'Article';
  CTagNameDetail = 'Detail';
  CTagNamePlace = 'Place';
  CTagNameRegion = 'Region';
  CTagNameCountry = 'Country';
  CTagNameState = 'State';
  CIniKeyConnected = 'Connected';
  CIniKeyDatabase = 'DB';
  CIniKeyWindow = 'Window';
  CIniKeyHostname = 'server';
  CIniKeyUsername = 'user';
  CIniKeyPassword = 'password';
  CIniKeyProject = 'project';
  CIniKeyPerson = 'person';
  CIniKeyWndTop = 'top';
  CIniKeyWndLeft = 'left';
  CIniKeyWndWidth = 'width';
  CIniKeyWndHeight = 'height';


implementation

uses FMUtils, StrUtils, AnchorDocking, cls_Translation, LConvEncoding;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}

{$R *.dfm}

{$ENDIF}

constructor TdmGenData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Filo := TStringGrid.Create(self);
end;


procedure TdmGenData.DeleteCitationsbyType_ID(const aType: char; const aID: integer);
begin
  with Query1 do
   begin
    Close;
    SQL.Text := 'DELETE FROM C WHERE Y=:Type AND N=:ID';
    ParamByName('Type').AsString := aType;
    ParamByName('ID').AsInteger := aID;
    ExecSQL;
   end;
end;



destructor TdmGenData.Destroy;
begin
  if assigned(FInifile) then
    FreeAndNil(FInifile);
  FreeAndNil(Filo);
  inherited Destroy;
end;

procedure TdmGenData.GetCode(out code: string; out no: integer);
begin
  with Filo do
    if RowCount > 0 then
     begin
      code := Cells[0, 0];
      no := StrToInt(Cells[1, 0]);
      DeleteRow(0);
     end
    else
     begin
      code := '';
      no := 0;
     end;
end;

procedure TdmGenData.PutCode(code: string; no: integer);
begin
  with Filo do
   begin
    InsertColRow(False, 0);
    Cells[0, 0] := code;
    Cells[1, 0] := IntToStr(no);
   end;
end;

procedure TdmGenData.GetCode(out code: string; out no: string);

begin
  with Filo do
    if RowCount > 0 then
     begin
      code := Cells[0, 0];
      no := Cells[1, 0];
      DeleteRow(0);
     end
    else
     begin
      code := '';
      no := '0';
     end;
end;

procedure TdmGenData.PutCode(code: string; no: string);
begin
  with Filo do
   begin
    InsertColRow(False, 0);
    Cells[0, 0] := code;
    Cells[1, 0] := no;
   end;
end;

procedure TdmGenData.DeleteDBProject(const db: string);
begin
   try
    qryInternal.SQL.Text := 'DROP DATABASE `' + db + '`;';
    qryInternal.ExecSQL;
   except
   end;
end;


{$Region Config}
procedure TdmGenData.ReadCfgConnection(out Host, User, Password: string);
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  Host := FInifile.ReadString(CIniKeyDatabase, CIniKeyHostname, 'localhost');
  User := FInifile.ReadString(CIniKeyDatabase, CIniKeyUsername, 'root');
  Password := FInifile.ReadString(CIniKeyDatabase, CIniKeyPassword, '');
end;

procedure TdmGenData.SetEventPref(lidEvent: integer);
begin
  with qryInternal do
   begin
    Close;
    // fr: mets le tag primaire à l'événement sélectionné dans la base de données et dans le tableau
    // en: put the primary tag to the event selected in the database and the table
    SQL.Text := 'UPDATE E SET X=1 WHERE no=:idEvent';
    ParamByName('idEvent').AsInteger := lidEvent;
    ExecSQL;
   end;
end;

procedure TdmGenData.WriteCfgConnection(Host, User, Password: string);
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  FInifile.WriteString(CIniKeyDatabase, CIniKeyHostname, Host);
  FInifile.WriteString(CIniKeyDatabase, CIniKeyUsername, User);
  if (Password = '') then
    FInifile.DeleteKey(CIniKeyDatabase, CIniKeyPassword)
  else
    FInifile.WriteString(CIniKeyDatabase, CIniKeyPassword, Password);
end;

procedure TdmGenData.ReadCfgProject(out ProjectName: string; out Connected: boolean);
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  ProjectName := FInifile.ReadString(CIniKeyDatabase, CIniKeyProject, ApplicationName);
  Connected := FInifile.ReadBool(CIniKeyDatabase, CIniKeyConnected, False);
end;

procedure TdmGenData.WriteCfgProject(const ProjectName: string; Connected: boolean);
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  FInifile.WriteString(CIniKeyDatabase, CIniKeyProject, ProjectName);
  FInifile.WriteBool(CIniKeyDatabase, CIniKeyConnected, Connected);
end;

procedure TdmGenData.ReadCfgLastPerson(out idLastPerson: integer);
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  idLastPerson := FInifile.ReadInteger(CIniKeyDatabase, CIniKeyPerson, 1);
end;

procedure TdmGenData.WriteCfgLastPerson(const idLastPerson: integer);
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  FInifile.WriteInteger(CIniKeyDatabase, CIniKeyPerson, idLastPerson);
end;

function TdmGenData.ReadCfgInteger(const Section, Ident: string;
  Default: longint): longint;
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  Result := FInifile.ReadInteger(Section, Ident, Default);
end;

procedure TdmGenData.WriteCfgInteger(const Section, Ident: string; Data: longint);
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  FInifile.WriteInteger(Section, Ident, Data);
end;

function TdmGenData.ReadCfgString(const Section, Ident, Default: string): string;
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  Result := FInifile.ReadString(Section, Ident, Default);
end;

procedure TdmGenData.WriteCfgString(const Section, Ident, Value: string);
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  FInifile.WriteString(Section, Ident, Value);
end;

procedure TdmGenData.WriteCfgFormPosition(Sender: TForm);
var
  Hostform: TWinControl;
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  if assigned(Sender.parent) and (Sender.parent is TAnchorDockHostSite) then
    Hostform := Sender.parent
  else
    HostForm := Sender;
  FInifile.WriteInteger(Sender.Name, CIniKeyWndTop, Hostform.Top);
  FInifile.WriteInteger(Sender.Name, CIniKeyWndLeft, Hostform.Left);
  FInifile.WriteInteger(Sender.Name, CIniKeyWndHeight, Hostform.Height);
  FInifile.WriteInteger(Sender.Name, CIniKeyWndWidth, Hostform.Width);
end;

procedure TdmGenData.ReadCfgFormPosition(Sender: TForm; a: integer;
  b: integer; c: integer; d: integer);
var
  Hostform: TWinControl;
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  if assigned(Sender.parent) and (Sender.parent is TAnchorDockHostSite) then
    Hostform := Sender.parent
  else
    HostForm := Sender;
  HostForm.Top := FInifile.ReadInteger(Sender.Name, CIniKeyWndTop, a);
  HostForm.Left := FInifile.ReadInteger(Sender.Name, CIniKeyWndLeft, b);
  HostForm.Height := FInifile.ReadInteger(Sender.Name, CIniKeyWndHeight, c);
  HostForm.Width := FInifile.ReadInteger(Sender.Name, CIniKeyWndWidth, d);

end;


procedure TdmGenData.WriteCfgGridPosition(Sender: TStringGrid; cols: integer);
var
  i: integer;
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  for i := 0 to cols - 1 do
    FInifile.WriteInteger(Sender.Name, IntToStr(i), Sender.Columns[i].Width);
end;

procedure TdmGenData.ReadCfgGridPosition(Sender: TStringGrid; cols: integer);
var
  i: integer;
begin
  if not assigned(FInifile) then
    FInifile := TIniFile.Create(iniFileName);
  for i := 0 to cols - 1 do
    Sender.Columns[i].Width := FInifile.ReadInteger(Sender.Name, IntToStr(i), 15);
end;

{$endregion}

procedure TdmGenData.DataModuleCreate(Sender: TObject);
var
  FDataPath: string;
  i: integer;
begin
  FDataPath := 'Data';
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      break
    else
      FDataPath := '..' + DirectorySeparator + FDataPath;
  if not DirectoryExists(FDataPath) then
    {$IFDEF MSWINDOWS}
   begin
    FDataPath := GetEnvironmentVariable('ProgramData') + DirectorySeparator + VendorName;
    if not DirectoryExists(FDataPath) then
      mkdir(FDataPath);
   end;
    {$ELSE}
        FDataPath := '';
    {$ENDIF}

  FDataPath := FDataPath + DirectorySeparator + ApplicationName;
  //Todo: Encode Appname to Pathname if needed
  if not DirectoryExists(FDataPath) then
    mkdir(FDataPath);

  iniFileName := FDataPath + DirectorySeparator + iniFileName;
  resPath := FDataPath + DirectorySeparator + resPath;
  DataPath := FDataPath + DirectorySeparator + DataPath;
end;

function TdmGenData.getDB_Connected: boolean;
begin
  Result := False;
  if assigned(Database) then
    Result := Database.Connected;
end;

function TdmGenData.GetProjectIsOpen: boolean;
begin
  Result := Database.Connected and FProjectIsOpen;
end;

procedure TdmGenData.SetDB_Connected(AValue: boolean);
begin
  if assigned(Database) then
   begin
    Database.Connected := AValue;
    FProjectIsOpen := FProjectIsOpen and Database.Connected;
   end
  else
    FProjectIsOpen := False;
end;

procedure TdmGenData.SetOnModifyEvent(AValue: TNotifyEvent);
begin
  if FOnModifyEvent = AValue then
    Exit;
  FOnModifyEvent := AValue;
end;

procedure TdmGenData.SetOnModifyIndividual(AValue: TNotifyEvent);
begin
  if FOnModifyIndividual = AValue then
    Exit;
  FOnModifyIndividual := AValue;
end;

{$Region Individual I,N}
procedure TdmGenData.GetIndBaseData(idInd: integer; out sName, sBirth, sDeath: string);

begin
  with qryInternal do
   begin
    sql.Text := 'SELECT N, I3, I4 FROM N WHERE X=1 AND I=:idInd';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    sName := DecodeName(Fields[0].AsString, 1);
    if Copy(Fields[1].AsString, 1, 1) = '1' then
      sBirth := Copy(Fields[1].AsString, 2, 4)
    else
      sBirth := '';
    if Copy(Fields[2].AsString, 1, 1) = '1' then
      sDeath := Copy(Fields[2].AsString, 2, 4)
    else
      sDeath := '';
   end;
end;

procedure TdmGenData.InsertIndividuumData(const idInd: integer;
  const Importance: integer; const Date: string; const Sex: string;
  const Living: string);
begin
  with qryInternal do
   begin
    SQL.Text :=
      'INSERT IGNORE INTO I (no, S, V, I, date) ' +
      'VALUES (:idInd, :Sex, :Living, :Importance, :Date)';
    ParamByName('idInd').AsInteger := idInd;
    ParamByName('Sex').AsString := Sex;
    ParamByName('Living').AsString := Living;
    ParamByName('Importance').AsInteger := Importance;
    ParamByName('Date').AsString := Date;
    ExecSQL;
   end;
end;

function TdmGenData.FullCopyPerson(idInd: integer): integer;
var
  lLastidName, lLastREntry: longint;
  nouveau: integer;
  lFullName: string;
  i4: string;
  i3: string;
  i2: string;
  i1: string;
begin
  with dmGenData do
   begin
    // Copier individu
    nouveau := CopyIndividual(idInd);

    with Query1 do
     begin
      // Copie toutes les relations
      SQL.Text := 'SELECT Y, A, B, M, P, X, SD, no FROM R WHERE A=:idInd OR B=:idInd';
      ParamByName('idInd').AsInteger := idInd;
      Open;
      while not EOF do
       begin
        Query2.SQL.Clear;
        if Fields[1].AsInteger = idInd then
         begin
          Query2.SQL.Add('INSERT IGNORE INTO R (Y, A, B, M, P, X, SD) VALUES (' +
            Fields[0].AsString + ', ' + IntToStr(nouveau) + ', ' +
            Fields[2].AsString + ', ''' + AutoQuote(Fields[3].AsString) +
            ''', ''' + AutoQuote(Fields[4].AsString) + ''', ' +
            Fields[5].AsString + ', ''' + AutoQuote(Fields[6].AsString) + ''')');
          SaveModificationTime(Fields[2].AsInteger);
         end
        else
         begin
          Query2.SQL.Add('INSERT IGNORE INTO R (Y, A, B, M, P, X, SD) VALUES (' +
            Fields[0].AsString + ', ' + Fields[1].AsString + ', ' +
            IntToStr(nouveau) + ', ''' + AutoQuote(Fields[3].AsString) +
            ''', ''' + AutoQuote(Fields[4].AsString) + ''', ' +
            Fields[5].AsString + ', ''' + AutoQuote(Fields[6].AsString) + ''')');
          SaveModificationTime(Fields[1].AsInteger);
         end;
        lLastREntry := GetLastIDOfTable('R');

        CopyCitation('R', Fields[7].AsInteger, lLastREntry);
        Next;
       end;
     end;

    // Copie tous les noms
    Query1.Close;
    Query1.SQL.Text :=
      'SELECT I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4, no FROM N WHERE I=:idInd';
    Query1.ParamByName('idInd').AsInteger := idInd;
    Query1.Open;
    while not Query1.EOF do
     begin
      i1 := Query1.Fields[8].AsString;
      i2 := Query1.Fields[9].AsString;
      i3 := Query1.Fields[10].AsString;
      i4 := Query1.Fields[11].AsString;

      lFullName := Query1.Fields[2].AsString;
      Query2.SQL.Clear;
      Query2.SQL.Add(
        'INSERT IGNORE INTO N (I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4) VALUES (' +
        IntToStr(nouveau) + ', ' + Query1.Fields[1].AsString +
        ', ''' + AutoQuote(lFullName) + ''', ' + Query1.Fields[3].AsString +
        ', ''' + AutoQuote(Query1.Fields[4].AsString) + ''', ''' +
        AutoQuote(Query1.Fields[5].AsString) + ''', ''' +
        AutoQuote(Query1.Fields[6].AsString) + ''', ''' +
        AutoQuote(Query1.Fields[7].AsString) + ''', ''' +
        AutoQuote(Query1.Fields[8].AsString) + ''', ''' +
        AutoQuote(Query1.Fields[9].AsString) + ''', ''' +
        AutoQuote(Query1.Fields[10].AsString) + ''', ''' +
        AutoQuote(Query1.Fields[11].AsString) + ''')');
      Query2.ExecSQL;
      lLastidName := GetLastIDOfTable('N');
      CopyCitation('N', Query1.Fields[12].AsInteger, lLastidName);
      // Ajoute le nom dans l'explorateur...
      //      if mniExplorateur.Checked then
      //         frmExplorer.AddNameToExplorer(lLastidName,lFullName,i1,i2,i3,i4);
      Query1.Next;
     end;

    // Copie tous les documents
    Query1.SQL.Text := 'SELECT X, T, D, F, Z, A, N FROM X WHERE A=''I'' AND N=:idInd';
    Query1.ParamByName('idInd').AsInteger := idInd;
    Query1.Open;
    while not Query1.EOF do
     begin
      Query2.SQL.Clear;
      Query2.SQL.Add('INSERT IGNORE INTO X (X, T, D, F, Z, A, N) VALUES (' +
        Query1.Fields[0].AsString + ', ''' + AutoQuote(Query1.Fields[1].AsString) +
        ''', ''' + AutoQuote(lFullName) + ''', ''' +
        AutoQuote(Query1.Fields[3].AsString) + ''', ''' +
        AutoQuote(Query1.Fields[4].AsString) + ''', ''' + 'I' + ''', ' +
        IntToStr(nouveau) + ')');
      Query2.ExecSQL;
      Query1.Next;
     end;

    // Copie tous les événements
    Query1.SQL.Text :=
      'SELECT E.Y, E.PD, E.SD, E.L, E.M, E.X, E.no FROM E JOIN W on E.no=W.E WHERE W.I=:idInd';
    Query1.ParamByName('idInd').AsInteger := idInd;
    Query1.Open;
    while not Query1.EOF do
     begin
      Query2.SQL.Clear;
      Query2.SQL.Add('INSERT IGNORE INTO E (Y, PD, SD, L, M, X) VALUES (' +
        Query1.Fields[0].AsString + ', ''' + AutoQuote(Query1.Fields[1].AsString) +
        ''', ''' + AutoQuote(lFullName) + ''', ' + Query1.Fields[3].AsString +
        ', ''' + AutoQuote(Query1.Fields[4].AsString) + ''', ' +
        Query1.Fields[5].AsString + ')');
      Query2.ExecSQL;
      Query2.SQL.Text := 'SHOW TABLE STATUS WHERE NAME=''E''';
      Query2.Open;
      Query2.First;
      lLastidName := Query2.Fields[10].AsInteger;
      Query2.Close;
      Query3.SQL.Text := 'SELECT Y, N, S, Q, M FROM C WHERE Y=''E'' AND N=' +
        Query1.Fields[6].AsString;
      Query3.Open;
      while not Query3.EOF do
       begin
        Query4.SQL.Clear;
        Query4.SQL.Add('INSERT IGNORE INTO C (Y, N, S, Q, M) VALUES (''' +
          Query3.Fields[0].AsString + ''', ' + IntToStr(lLastidName - 1) +
          ', ' + Query3.Fields[2].AsString + ', ' + Query3.Fields[3].AsString +
          ', ''' + AutoQuote(Query3.Fields[4].AsString) + ''')');
        Query4.ExecSQL;
        Query3.Next;
       end;
      Query3.SQL.Text := 'SELECT X, T, D, F, Z FROM X WHERE A=''E'' AND N=' +
        Query1.Fields[6].AsString;
      Query3.Open;
      while not Query3.EOF do
       begin
        Query4.SQL.Clear;
        Query4.SQL.Add('INSERT IGNORE INTO X (X, T, D, F, Z, A, N) VALUES (' +
          '0' + ', ''' + AutoQuote(Query3.Fields[1].AsString) +
          ''', ''' + AutoQuote(Query3.Fields[2].AsString) + ''', ''' +
          AutoQuote(Query3.Fields[3].AsString) + ''', ''' +
          AutoQuote(Query1.Fields[4].AsString) + ''', ''E'', ' +
          IntToStr(lLastidName - 1) + ')');
        Query4.ExecSQL;
        Query3.Next;
       end;
      Query3.SQL.Text := 'SELECT I, E, X, P, R FROM W WHERE E=' +
        Query1.Fields[6].AsString;
      Query3.Open;
      while not Query3.EOF do
       begin
        Query4.SQL.Clear;
        if idInd = Query3.Fields[0].AsInteger then
          Query4.SQL.Add('INSERT IGNORE INTO W (I, E, X, P, R) VALUES (' +
            IntToStr(nouveau) + ', ' + IntToStr(lLastidName - 1) +
            ', ' + Query3.Fields[2].AsString + ', ''' +
            AutoQuote(Query3.Fields[3].AsString) + ''', ''' +
            AutoQuote(Query3.Fields[4].AsString) + ''')')
        else
          Query4.SQL.Add('INSERT IGNORE INTO W (I, E, X, P, R) VALUES (' +
            Query3.Fields[0].AsString + ', ' + IntToStr(lLastidName - 1) +
            ', ' + Query3.Fields[2].AsString + ', ''' +
            AutoQuote(Query3.Fields[3].AsString) + ''', ''' +
            AutoQuote(Query3.Fields[4].AsString) + ''')');
        Query4.ExecSQL;
        SaveModificationTime(Query3.Fields[0].AsInteger);
        Query3.Next;
       end;
      Query1.Next;
     end;
    SaveModificationTime(nouveau);
   end;
  Result := nouveau;
end;

procedure TdmGenData.FullDeleteIndividuum(const idInd: longint);
begin
  with qryInternal do
   begin
    // Supprime la personne
    SQL.Text := 'DELETE FROM I WHERE no=:idInd';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;

    // Supprime ses noms
    SQL.Text := 'DELETE C ' + 'FROM C INNER JOIN N ' +
      'ON Y=''N'' AND N=N.no ' + 'FROM N WHERE N.I=:idInd';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;
    SQL.Text := 'DELETE FROM N ' + 'WHERE I=:idInd';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;

    // supprime ses événements
    SQL.Text := 'DELETE C ' + 'FROM C INNER JOIN E ' +
      'ON C.Y=''E'' AND C.N=E.no JOIN W ON W.E=E.no ' + 'WHERE W.I=:idInd';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;
    SQL.Text := 'DELETE X ' + 'FROM X ' +
      'INNER JOIN E ON X.A=''E'' AND X.N=E.no ' + 'JOIN W ON W.E=E.no ' +
      'WHERE W.I=:idInd';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;
    SQL.Text := 'DELETE E ' + 'FROM E ' + 'INNER JOIN W ON W.E=E.no ' +
      'WHERE W.I=:idInd';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;
    SQL.Text := 'DELETE FROM W ' + 'WHERE I=:idInd';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;

    // Supprime ses documents
    SQL.Text := 'DELETE FROM X ' + 'WHERE X.A=''I'' AND X.N=:idInd';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;

    // Supprime ses relations
    SQL.Text := 'DELETE C FROM C INNER JOIN R ' + 'ON C.Y=''R'' AND C.N=R.no ' +
      'WHERE (R.A=:idInd) OR R.B=:idInd)';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;

    SQL.Text := 'DELETE FROM R ' + 'WHERE (R.A=:idInd) OR R.B=:idInd)';
    ParamByName('inInd').AsInteger := idInd;
    ExecSQL;
   end;
end;

procedure TdmGenData.SaveModificationTime(no: integer);
begin
  with qryInternal do
   begin
    // Todo -oJC: Modification-date as Datetime
    SQL.Text := 'UPDATE I SET date=:ModDate WHERE no=:idInd';
    ParamByName('ModDate').AsString := FormatDateTime('YYYYMMDD', now);
    ParamByName('idInd').AsInteger := no;
    ExecSQL;
   end;
end;

procedure TdmGenData.SaveModificationTime(no: string);
var
  nn: integer;
begin
  if TryStrToInt(no, nn) then
    SaveModificationTime(nn);
end;

procedure TdmGenData.UpdateIndModificationTimeByName(lLinkID: integer);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'UPDATE I SET I.date=:ModDate ' +
      'FROM I INNER JOIN N ON N.I = I.no ' + 'WHERE N.no=:idName';
    ParamByName('ModDate').AsString := FormatDateTime('YYYYMMDD', now);
    ParamByName('idName').AsInteger := lLinkID;
    ExecSQL;
   end;
  if assigned(FOnModifyIndividual) then
    FOnModifyIndividual(self);
end;

procedure TdmGenData.UpdateIndModificationTimesByEvent(lLinkID: integer);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'UPDATE I SET I.date=:ModDate ' +
      'FROM I INNER JOIN W ON W.I = I.no ' + 'WHERE W.E=:idEvent';
    ParamByName('ModDate').AsString := FormatDateTime('YYYYMMDD', now);
    ParamByName('idEvent').AsInteger := lLinkID;
    ExecSQL;
   end;
  if assigned(FOnModifyIndividual) then
    FOnModifyIndividual(self);
end;

function TdmGenData.GetDataOfInd(const nID: longint; out sSex, sLiving, sDate: string;
  out iInterest: longint): boolean;

begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT S, V, I, date FROM I WHERE no=:idInd';
    ParamByName('idInd').AsInteger := nID;
    Open;
    Result := not EOF;
    if Result then
     begin
      sSex := Fields[0].AsString;
      sLiving := Fields[1].AsString;
      iInterest := Fields[2].AsInteger;
      sDate := Fields[3].AsString;
     end
    else
     begin
      sSex := '?';
      sLiving := '?';
      iInterest := 0;
      sDate := '000000000';
     end;
    Close;
   end;
end;

function TdmGenData.GetSexOfInd(const nID: longint): string;

begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT S FROM I WHERE no=:idInd';
    ParamByName('idInd').AsInteger := nID;
    Open;
    if not EOF then
      Result := Fields[0].AsString
    else
      Result := '';
    Close;
   end;
end;

function TdmGenData.GetLivingOfInd(const nID: longint): string;
begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT V FROM I WHERE no=:idInd';
    ParamByName('idInd').AsInteger := nID;
    Open;
    if not EOF then
      Result := Fields[0].AsString
    else
      Result := '';
    Close;
   end;
end;

function TdmGenData.CopyIndividual(const nID: longint): longint;
begin
  with qryInternal2 do
   begin
    SQL.Text := 'SELECT S, V, I, date FROM I WHERE no=:idInd';
    ParamByName('idInd').AsInteger := nID;
    Open;
   end;
  if not qryInternal2.EOF then
    with qryInternal do
     begin
      sql.Text :=
        'Insert into I (S, V, I, Date) Values (:Sex, :Living, :Importance, :Date)';
      ParamByName('Sex').AsString := qryInternal2.Fields[0].AsString;
      ParamByName('Living').AsString := qryInternal2.Fields[1].AsString;
      ParamByName('Importance').AsInteger := qryInternal2.Fields[2].AsInteger;
      ParamByName('Date').AsString := FormatDateTime('YYYYMMDD', now);
      ExecSQL;
      sql.Text := 'Select @@identity';
      Open;
      Result := Fields[0].AsInteger;
      Close;
     end
  else
    Result := 0;
  qryInternal2.Close;
  if Result <> 0 then
    CopyIndName(nID, Result);
end;

procedure TdmGenData.RepairNameOrder(OnUpdate: TNotifyEvent);
var
  pos2: integer;
  pos1: integer;
  lName: string;
  i2: string;
  lSurname: string;
  lidName: longint;
begin
  with qryInternal2 do
   begin
    Close;
    SQL.Text := 'SELECT no, I, N FROM N';
    Open;
    tag := -RecordCount;
    if Assigned(OnUpdate) then
      OnUpdate(qryInternal2);
    tag := 0;
    if Assigned(OnUpdate) then
      OnUpdate(qryInternal2);
    while not EOF do
     begin

      lName := Fields[2].AsString;
      lidName := Fields[0].AsInteger;
      if Copy(lName, 1, 4) = '!TMG' then
       begin
        lSurname := ExtractDelimited(2, lName, ['|']);
        i2 := ExtractDelimited(4, lName, ['|']);
       end
      else
       begin
        Pos1 := AnsiPos('<' + CTagNameFamilyName + '>', lName) +
          length(CTagNameFamilyName) + 2;
        Pos2 := AnsiPos('</' + CTagNameFamilyName + '>', lName);
        if (Pos1 + Pos2) > length(CTagNameFamilyName) + 2 then
          lSurname := RemoveUTF8(Copy(lName, Pos1, Pos2 - Pos1));

        Pos1 := AnsiPos('<' + CTagNameGivenName + '>', lName) +
          length(CTagNameGivenName) + 2;
        // 9 car le 'é' prends 2 position en ANSI
        Pos2 := AnsiPos('</' + CTagNameGivenName + '>', lName);
        if (Pos1 + Pos2) > length(CTagNameGivenName) + 2 then
          i2 := RemoveUTF8(Copy(lName, Pos1, Pos2 - Pos1));
       end;
      with qryInternal do
       begin
        Close;
        SQL.Text := 'UPDATE N SET I1=:Surname, I2=:Givenname WHERE no=:idName';
        ParamByName('Surname').AsString := lSurname;
        ParamByName('Givenname').AsString := i2;
        ParamByName('idName').AsInteger := lidName;
        ExecSQL;
       end;
      Next;
      tag := tag + 1;
      if Assigned(OnUpdate) then
        OnUpdate(qryInternal2);
     end;
   end;
end;

function TdmGenData.AddNewIndividual(sex, living: string; interest: integer): longint;

begin
  with qryInternal do
   begin
    SQL.Text := 'INSERT INTO I (S, V, I, Date) VALUES (:sex, :living, :interest, :Date)';
    ParamByName('sex').AsString := sex;
    ParamByName('living').AsString := living;
    ParamByName('interest').AsInteger := interest;
    ParamByName('Date').AsString := FormatDateTime('YYYYMMDD', now);
    ExecSQL;
    SQL.Text := 'SELECT @@identity';
    Open;
    Result := qryInternal.Fields[0].AsInteger;
    Close;
   end;
end;

procedure TdmGenData.UpdateIndLiving(const lidInd: integer; NewVal: char;
  const Sender: TObject);
begin
  with qryInternal do
   begin
    SQL.Text := 'UPDATE I SET V=:VChar WHERE no=:idInd';
    ParamByName('idInd').AsInteger := lidInd;
    ParamByName('VChar').AsString := NewVal;
    ExecSQL;
   end;
  NamesChanged(Sender);
end;

procedure TdmGenData.UpdateIndSex(const lidInd: integer; NewVal: char;
  const Sender: TObject);
begin
  with qryInternal do
   begin
    SQL.Text := 'UPDATE I SET S=:VChar WHERE no=:idInd';
    ParamByName('idInd').AsInteger := lidInd;
    ParamByName('VChar').AsString := NewVal;
    ExecSQL;
   end;
  NamesChanged(Sender);
end;

procedure TdmGenData.UpdateIndInterrest(const lidInd: integer;
  NewVal: integer; const Sender: TObject);
begin
  with qryInternal do
   begin
    SQL.Text := 'UPDATE I SET I=:IVal WHERE no=:idInd';
    ParamByName('idInd').AsInteger := lidInd;
    ParamByName('IVal').AsInteger := NewVal;
    ExecSQL;
   end;
  NamesChanged(Sender);
end;


procedure TdmGenData.RepairRelDateByIndDate(const OnProgress: TNotifyEvent);
begin
  qryInternal2.SQL.Text := 'SELECT no, I, I3 FROM N WHERE X=1';
  qryInternal2.Open;
  qryInternal2.tag := -qryInternal2.RecordCount;
  if assigned(OnProgress) then
    OnProgress(qryInternal2);
  qryInternal2.tag := 0;
  if assigned(OnProgress) then
    OnProgress(qryInternal2);
  while not qryInternal2.EOF do
    with qryInternal do
     begin
      SQL.Text := 'UPDATE R SET SD=:SDate WHERE A=:idInd AND SD=:qSDate';
      ParamByName('idInd').AsString := qryInternal2.Fields[1].AsString;
      ParamByName('SDate').AsString := qryInternal2.Fields[2].AsString;
      ParamByName('qSDate').AsString := '100000000030000000000';
      ExecSQL;
      ParamByName('qSDate').AsString := '';
      ExecSQL;
      qryInternal2.Next;
      qryInternal2.tag := qryInternal2.tag + 1;
      if assigned(OnProgress) then
        OnProgress(qryInternal2);
     end;
end;

function TdmGenData.GetFirstIndividuum: integer;
begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT no FROM I LIMIT 1';
    Open;
    Result := Fields[0].AsInteger;
    Close;
   end;
end;

function TdmGenData.IsValidIndividuum(idInd: integer): boolean;

begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT no FROM I WHERE no=:idInd';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    Result := not EOF;
    Close;
   end;
end;

procedure TdmGenData.GetNameData(const lidName: integer;
  out idInd, idType: longint; out iName, Memo, Phrase, aDate, SortDate: string;
  out Pref: boolean);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text :=
      'SELECT N.no, N.I, N.Y, N.N, N.M, N.P, N.PD, N.SD, N.X FROM  N WHERE N.no=:idName';
    ParamByName('idName').AsInteger := lidName;
    Open;
    First;
    idInd := Fields[1].AsInteger;
    idType := Fields[2].AsInteger;
    iName := Fields[3].AsString;
    Memo := Fields[4].AsString;
    Phrase := Fields[5].AsString;
    aDate := Fields[6].AsString;
    SortDate := Fields[7].AsString;
    Pref := Fields[8].AsBoolean;
    Close;
   end;
end;

function TdmGenData.SaveNameData(idName: longint; const Prefered: boolean;
  const lidEvType: PtrInt; const Phrase: string; const SDate: string;
  const PDate: string; const lMemoText: string; const i4: string;
  const i3: string; const i2: string; const i1: string; const lName: string;
  const lidInd: longint): integer;
begin
  with Query1 do
   begin
    if idName = 0 then
     begin
      SQL.Text := 'INSERT INTO N (Y, I, M, N, I1, I2, PD, SD, P, I3, I4, X) VALUES ' +
        '( :idEvType, :idInd, :M, :Name, :i1, :i2, :PDate, :SDate, :P, :i3, :i4, :X)';
      ParamByName('i3').AsString := i3;
      ParamByName('i4').AsString := i4;
     end
    else
     begin
      SQL.Text :=
        'UPDATE N SET Y=:idEvType, I=:idInd, M=:M, N=:Name, I1=:I1, I2=:I2, PD=:PDate, SD=:SDate, P=:P, X=:X WHERE no=:idName';
      ParamByName('idName').AsInteger := idName;
     end;
    ParamByName('idEvType').AsInteger := lidEvType;
    ParamByName('idInd').AsInteger := lidInd;
    ParamByName('M').AsString := lMemoText;
    ParamByName('Name').AsString := lName;
    ParamByName('i1').AsString := i1;
    ParamByName('i2').AsString := i2;
    ParamByName('PDate').AsString := PDate;
    ParamByName('SDate').AsString := SDate;
    ParamByName('P').AsString := Phrase;
    ParamByName('X').AsBoolean := Prefered;
    ExecSQL;
    if idName = 0 then
      Result := dmGenData.GetLastIDOfTable('N')
    else
      Result := idName;
    // Sauvegarder les modifications
    dmGenData.SaveModificationTime(Result);
   end;
end;


function TdmGenData.GetIndividuumName(idInd: integer): string;

begin
  with qryInternal do
   begin
    if Active then
      Close;
    SQL.Text :=
      'SELECT N.N FROM N WHERE N.X=1 AND N.I=:idInd';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    //    First;

    if not EOF then
      Result := Fields[0].AsString
    else
      Result := '';
    Close;
   end;
end;

function TdmGenData.GetIndividuumName(NStr: string): string;
var
  no: longint;
begin
  if TryStrToInt(NStr, no) then
    Result := GetIndividuumName(no);
end;

{$EndRegion ~Individual}

{$region Citation}
procedure TdmGenData.GetCitationData(idCitation: integer; out lTypeCode: string;
  out lLinkID: integer; out lMemoText: string; out lidSource, lQuality: integer);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT C.no, C.Y, C.N, C.S, C.M, C.Q FROM C WHERE C.no=:idCitation';
    ParamByName('idCitation').AsInteger := idCitation;
    Open;
    First;
    lTypeCode := Fields[1].AsString;
    lLinkID := Fields[2].AsInteger;
    lidSource := Fields[3].AsInteger;
    lMemoText := Fields[4].AsString;
    lQuality := Fields[5].AsInteger;
    Close;
   end;
end;

function TdmGenData.SaveCitationData(const lidCitation: integer;
  const lTypeCode: string; const lLinkID: integer; const lMemoText: string;
  const lidSource, lQuality: integer): integer;
begin
  with qryInternal do
   begin
    Close;
    if lidCitation = 0 then
     begin
      SQL.Text :=
        'INSERT INTO C (S, M, Q, Y, N) VALUES ( :idSource, :Memo, :Q, :Type, :N)';
      ParamByName('Type').AsString := lTypeCode;
      ParamByName('N').AsInteger := lLinkID;
     end
    else
     begin
      SQL.Text := 'UPDATE C SET S=:idSource, M=:Memo, Q=:Q  WHERE no=:idCitation';
      ParamByName('idCitation').AsInteger := lidCitation;
     end;
    ParamByName('idSource').AsInteger := lidSource;
    ParamByName('Memo').AsString := lMemoText;
    ParamByName('Q').AsInteger := lQuality;
    ExecSQL;
    if lidCitation = 0 then
     begin
      sql.Text := 'Select @@identity';
      Open;
      Result := Fields[0].AsInteger;
      Close;
     end
    else
      Result := lidCitation;
   end;
end;

procedure TdmGenData.InsertCitation(const idSource: longint;
  const LinkID: longint; const MemoText: string; const LinkType: string;
  const Quality: integer);
begin
  with qryInternal do
   begin
    SQL.Text := 'INSERT IGNORE INTO C (Y, N, S, M, Q) ' +
      'VALUES (:Type, :LinkID, :idSource, :Memo, :Quality)';
    ParamByName('Type').AsString := LinkType;
    ParamByName('LinkID').AsInteger := LinkID;
    ParamByName('idSource').AsInteger := idSource;
    ParamByName('Memo').AsString := MemoText;
    ParamByName('Quality').AsInteger := Quality;
    ExecSQL;
   end;
end;

procedure TdmGenData.CopyCitation(AType: string; idLink, idNewLink: integer);
begin
  CopyCitation(AType, idLink, AType, idNewLink);
end;

procedure TdmGenData.CopyCitation(AType: string; idLink: integer;
  ANewType: string; idNewLink: integer);
begin
  with qryInternal2 do
   begin
    SQL.Text := 'SELECT Y, N, S, Q, M FROM C WHERE Y=:Type AND N=:idLink';
    ParamByName('Type').AsString := AType;
    ParamByName('idLink').AsInteger := idLink;
    Open;
   end;
  while not qryInternal2.EOF do
    with qryInternal do
     begin
      SQL.Text :=
        'INSERT IGNORE INTO C (Y, N, S, Q, M) VALUES (:Type, :idLink, :S, :Q,' +
        ' :M)';
      ParamByName('Type').AsString := ANewType;
      ParamByName('idLink').AsInteger := idNewLink;
      ParamByName('S').AsInteger := qryInternal2.Fields[2].AsInteger;
      ParamByName('Q').AsInteger := qryInternal2.Fields[3].AsInteger;
      ParamByName('M').AsString := qryInternal2.Fields[4].AsString;
      ExecSQL;
      Close;
      qryInternal2.Next;
     end;
  qryInternal2.Close;
end;

procedure TdmGenData.CopyCitationOfIndByType(const lidInd: integer;
  const lSourceType: string; const lidInd_Dest: integer; const lDestType: string);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text :=
      'INSERT INTO C (Y, N, S, Q, M) ' + 'SELECT :DType, :idDInd, S, Q, M FROM C ' +
      'WHERE Y=:SType AND N=:idSInd';
    ParamByName('SType').AsString := lSourceType;
    ParamByName('idSInd').AsInteger := lidInd;
    ParamByName('DType').AsString := lDestType;
    ParamByName('idDInd').AsInteger := lidInd_Dest;
    ExecSQL;
   end;
end;


procedure TdmGenData.DeleteCitationb_TypeId(const aType: string; const id: integer);
begin
  with Query1 do
   begin
    SQL.Text := 'DELETE FROM C WHERE Y=:Type AND N=:idNr';
    ParamByName('Type').AsString := aType;
    ParamByName('idNr').AsInteger := id;
    ExecSQL;
   end;
end;

procedure TdmGenData.PopulateCitations(Tableau: TStringGrid; Code: string;
  idName: integer);
var
  row: integer;
begin
  with qryInternal do
   begin
    //Fr: Populate le tableau de citations
    //de: Die Tabelle der Zitate füllen
    //en: fill the table of citations
    SQL.Text :=
      'SELECT C.no, S.T, C.M, C.Q FROM C JOIN S ON C.S=S.no WHERE C.Y=:Type AND C.N=:idName';
    ParamByName('Type').AsString := Code;
    ParamByName('idName').AsInteger := idName;
    Open;
    First;
    row := 1;
    Tableau.RowCount := RecordCount + 1;
    while not EOF do
     begin
      Tableau.Cells[0, row] := Fields[0].AsString;
      Tableau.Objects[0, row] := TObject(ptrint(Fields[0].AsInteger));
      Tableau.Cells[1, row] := Fields[1].AsString;
      Tableau.Cells[2, row] := Fields[2].AsString;
      Tableau.Cells[3, row] := Fields[3].AsString;
      Tableau.Objects[3, row] := TObject(ptrint(Fields[3].AsInteger));
      Next;
      row := row + 1;
     end;
    Close;
   end;
end;

function TdmGenData.GetCitationBestQuality(sType: string; idLink: integer): string;
begin
  with qryInternal do
   begin
    sql.Text := 'SELECT Q FROM C WHERE Y=:Type AND N=:idLink ORDER BY Q DESC';
    ParamByName('Type').AsString := sType;
    ParamByName('idLink').AsInteger := idLink;
    Open;
    if not EOF then
      Result := Fields[0].AsString
    else
      Result := '';
    Close;
   end;
end;

procedure TdmGenData.DeleteCitation(const lidCitation: integer);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'DELETE FROM C WHERE no=idCitation';
    ParamByName('idCitation').AsInteger := lidCitation;
    ExecSQL;
   end;
end;

{$endregion ~Citation}

function TdmGenData.CheckIndParentExists(const lidInd: longint): boolean;
var
  lParentExists: boolean;
begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT R.no, R.B FROM R WHERE R.X=1 AND R.A=:idInd';
    ParamByName('idInd').AsInteger := lidInd;
    Open;
    lParentExists := not EOF;
    Result := lParentExists;
   end;
end;

function TdmGenData.GetI3(idInd: integer): string;
begin
  with qryInternal do
   begin
    SQL.Text :=
      'SELECT E.PD, E.SD FROM E JOIN W on E.no=W.E JOIN Y on Y.no=E.Y WHERE E.X=1 AND W.X=1 AND Y.Y=:Type AND W.I=:idInd';
    ParamByName('Type').AsString := 'B';
    paramByName('idInd').AsInteger := idInd;
    Open;
    First;
    if not EOF then
     begin
      if not (Copy(Fields[0].AsString, 1, 1) = '1') then
        Result := Fields[1].AsString
      else
        Result := Fields[0].AsString;
     end
    else
      Result := '';
   end;
end;

function TdmGenData.GetI4(idInd: integer): string;
begin
  with qryInternal do
   begin
    SQL.Text :=
      'SELECT E.PD, E.SD FROM E JOIN W on E.no=W.E JOIN Y on Y.no=E.Y WHERE E.X=1 AND W.X=1 AND Y.Y=:Type AND W.I=:idInd';
    ParamByName('Type').AsString := 'D';
    paramByName('idInd').AsInteger := idInd;
    Open;
    First;
    if not EOF then
     begin
      if not (Copy(Fields[0].AsString, 1, 1) = '1') then
        Result := Fields[1].AsString
      else
        Result := Fields[0].AsString;
     end
    else
      Result := '';
   end;
end;

procedure TdmGenData.AppendSiblings(const Liste: TStringGrid; idInd: integer);

begin
  with Liste, Query1 do
   begin
    SQL.Text := 'SELECT DISTINCT R.B FROM R INNER JOIN R AS P ' +
      'ON R.A=P.B WHERE R.X=1 AND P.X=1 AND P.B=:idIND AND NOT R.B=:idInd';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    while not EOF do
     begin
      RowCount := RowCount + 1;
      Cells[0, RowCount - 1] := Fields[0].AsString;
      Objects[0, RowCount - 1] := TObject(ptrint(Fields[0].AsInteger));
      Cells[1, RowCount - 1] :=
        GetIndividuumName(Fields[0].AsInteger);
     end;
    Next;
   end;
end;

procedure TdmGenData.AppendSpousesSpouses(const Liste: TStringGrid; idInd: integer);

begin
  with Liste, Query1 do
   begin
    SQL.Text :=
      'SELECT DISTINCT W2.I FROM W as W2 ' +
      'INNER JOIN W ON W2.E=W.I AND W2.i<>W.I ' + 'INNER JOIN E on W.E=E.no ' +
      'INNER JOIN Y on E.Y=Y.no WHERE W2.X=1 AND E.X=1 AND W.X=1 AND Y.Y=''M'' AND W.I=:idInd';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    while not EOF do
     begin
      RowCount := RowCount + 1;
      Cells[0, RowCount - 1] :=
        Fields[0].AsString;
      Objects[0, RowCount - 1] := TObject(ptrint(Fields[0].AsInteger));
      Cells[1, RowCount - 1] :=
        GetIndividuumName(Fields[0].AsInteger);
      Next;
     end;
   end;
end;

function TdmGenData.CheckIndSharedEventExists(idInd: integer): boolean;
  // fr: Vérifier qu'il n'y a pas d'événements primaire avec d'autre témoins primaires
  // en: Check that there is no primary events with other primary witnesses

begin
  with Query1 do
   begin
    SQL.Text :=
      'SELECT E.no FROM E JOIN W ON E.no=W.E JOIN W as W2 ON W.E=W2.E and W.I <> W2.I WHERE E.X=1 AND W.X=1 AND W.I=:idInd';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    Result := not EOF;
    Close;
   end;
end;

procedure TdmGenData.FillExplorerIndex(const aGrid: TStringGrid;
  Order: integer; const OnProgress: TNotifyEvent = nil);
var
  aRow: integer;
begin
  with Query5, aGrid do
   begin
    SQL.Clear;
    case Order of
      1: SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N ORDER BY I2, I1, I3, I4');
      2: SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N ORDER BY I1, I2, I3, I4');
      3: SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N ORDER BY I3, I4, I1, I2');
      4: SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N ORDER BY I4, I3, I1, I2')
      else
        SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N ORDER BY I1, I2, I3, I4');
     end;
    Open;
    First;
    aRow := 1;
    RowCount := RecordCount + 1;
    tag := -RowCount;
    if Assigned(OnProgress) then
      OnProgress(Query5);
    while not EOF do
     begin
      Cells[0, aRow] := Fields[0].AsString;
      Objects[0, aRow] := TObject(ptrint(Fields[0].AsInteger));
      Cells[1, aRow] := Fields[1].AsString;
      Objects[1, aRow] := TObject(ptrint(Fields[1].AsInteger));
      // Change col 2 selon Order
      case Order of
        1: Cells[2, aRow] := (DecodeName(Fields[2].AsString, 1));
        2: Cells[2, aRow] := (DecodeName(Fields[2].AsString, 2));
        3: Cells[2, aRow] := (DecodeName(Fields[2].AsString, 2));
        4: Cells[2, aRow] := (DecodeName(Fields[2].AsString, 2))
        else
          Cells[2, aRow] := (DecodeName(Fields[2].AsString, 2));
       end;
      Cells[3, aRow] := ConvertDate(Fields[5].AsString, 1);
      Cells[4, aRow] := ConvertDate(Fields[6].AsString, 1);
      if Fields[7].AsBoolean then
        Cells[5, aRow] := '*'
      else
        Cells[5, aRow] := '';
      // Change col 6 selon Order
      case Order of
        1: Cells[6, aRow] := Fields[4].AsString + ' ' + Fields[3].AsString;
        2: Cells[6, aRow] :=
            RemoveUTF8(Fields[3].AsString) + ', ' + RemoveUTF8(
            Fields[4].AsString);
        3: Cells[6, aRow] := ConvertDate(Fields[5].AsString, 1);
        4: Cells[6, aRow] := ConvertDate(Fields[6].AsString, 1)
        else
          Cells[6, aRow] :=
            RemoveUTF8(Fields[3].AsString) + ', ' + RemoveUTF8(
            Fields[4].AsString);
       end;
      aRow := aRow + 1;
      Next;
      tag := aRow;
      if Assigned(OnProgress) then
        OnProgress(Query5);
     end;
    Close;
   end;
end;

procedure TdmGenData.FillIndexBySearchtext(const lGrid: TStringGrid;
  const lSearchText: string; const lOnProgress: TNotifyEvent);
var
  row: integer;
begin
  with Query5 do
   begin
    SQL.Text :=
      'SELECT no, I, N, I1, I2, I3, I4, X FROM N WHERE MATCH (N) AGAINST (:SearchText IN BOOLEAN MODE) ORDER BY I1, I2';
    ParamByName('Searchtext').AsString := lSearchText;
    Open;
    First;
    row := 1;
    if not EOF then
     begin
      lGrid.RowCount := RecordCount + 1;
      tag := -lGrid.RowCount;
      if Assigned(lOnProgress) then
        lOnProgress(Query5);
      tag := 0;
      if Assigned(lOnProgress) then
        lOnProgress(Query5);

      while not EOF do
       begin
        lGrid.Cells[0, row] := Fields[0].AsString;
        lGrid.Cells[1, row] := Fields[1].AsString;
        lGrid.Cells[2, row] :=
          DecodeName(Fields[2].AsString, 2);
        lGrid.Cells[3, row] :=
          ConvertDate(Fields[5].AsString, 1);
        lGrid.Cells[4, row] :=
          ConvertDate(Fields[6].AsString, 1);
        if Fields[7].AsBoolean then
          lGrid.Cells[5, row] := '*'
        else
          lGrid.Cells[5, row] := '';
        lGrid.Cells[6, row] :=
          RemoveUTF8(Fields[3].AsString) + ', ' +
          RemoveUTF8(Fields[4].AsString);
        row := row + 1;
        Next;
        tag := row;
        if Assigned(lOnProgress) then
          lOnProgress(Query5);
       end;
      Close;
     end;
   end;
end;



procedure TdmGenData.PopulateNameTable(const lidInd: longint; tblName: TStringGrid);
var
  lidType: longint;
  lidName: longint;
  lQuality: string;
  row: integer;
begin
  with Query1 do
   begin
    Close;
    SQL.Text := 'SELECT no, X, Y, PD, SD, N FROM N WHERE I=:idInd ORDER BY X DESC, SD';
    ParamByName('idInd').AsInteger := lidInd;
    Open;
    First;
    row := 1;
    tblName.RowCount := RecordCount + 1;
    while not EOF do
     begin
      lidName := Fields[0].AsInteger;
      tblName.Cells[0, row] := IntToStr(lidName);
      tblName.Objects[0, row] := TObject(ptrint(lidname));
      if Fields[1].AsBoolean then
        tblName.Cells[1, row] := '*'
      else
        tblName.Cells[1, row] := '';

      if Fields[2].IsNull then
        lidtype := -1
      else
        lidType := Fields[2].AsInteger;
      tblName.Cells[2, row] := GetTypeName(lidType);
      tblName.Objects[2, row] := TObject(PtrInt(lidType));

      // Convertit la Modifie
      tblName.Cells[3, row] := ConvertDate(Fields[3].AsString, 1);

      tblName.Cells[4, row] := DecodeName(Fields[5].AsString, 1);

      lQuality := GetCitationBestQuality('N', lidName);
      tblName.Cells[5, row] := lQuality;

      Next;
      row := row + 1;
     end;
    Close;
   end;
end;

function TdmGenData.CopyName(const lidName: longint;
  out i1, i2, i3, i4: string): longint;

begin

  qryInternal2.SQL.Text :=
    'SELECT I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4 FROM N WHERE no=:idName';
  qryInternal2.ParamByName('idName').AsInteger := lidName;
  qryInternal2.Open;
  i1 := qryInternal2.Fields[8].AsString;
  i2 := qryInternal2.Fields[9].AsString;
  i3 := qryInternal2.Fields[10].AsString;
  i4 := qryInternal2.Fields[11].AsString;
  with qryInternal do
   begin
    SQL.Text :=
      'INSERT IGNORE INTO N (I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4) VALUES (' +
      ':idInd, :Type, :Name, :Prefered, :Note, :Phrase, :PDate, :SDate, :I1, :I2, :I3, :I4)';
    ParamByName('idInd').AsInteger := qryInternal2.Fields[0].AsInteger;
    ParamByName('Type').AsString := qryInternal2.Fields[1].AsString;
    ParamByName('Name').AsString := qryInternal2.Fields[2].AsString;
    ParamByName('Prefered').AsInteger := 0;
    ParamByName('Note').AsString := qryInternal2.Fields[4].AsString;
    ParamByName('Phrase').AsString := qryInternal2.Fields[5].AsString;
    ParamByName('PDate').AsString := qryInternal2.Fields[6].AsString;
    ParamByName('SDate').AsString := qryInternal2.Fields[7].AsString;
    ParamByName('I1').AsString := qryInternal2.Fields[8].AsString;
    ParamByName('I2').AsString := qryInternal2.Fields[9].AsString;
    ParamByName('I3').AsString := qryInternal2.Fields[10].AsString;
    ParamByName('I4').AsString := qryInternal2.Fields[11].AsString;
    ExecSQL;
    SQL.Text := 'Select @@identity';
    Open;
    Result := Fields[0].AsInteger;
    Close;
   end;
  qryInternal2.Close;
end;

function TdmGenData.CopyIndName(const idInd, idNewInd: longint): longint;

begin
  qryInternal2.SQL.Text :=
    'SELECT I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4 FROM N WHERE X=1 and i=:idInd';
  qryInternal2.ParamByName('idInd').AsInteger := idInd;
  qryInternal2.Open;
  with qryInternal do
   begin
    SQL.Text :=
      'INSERT IGNORE INTO N (I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4) VALUES (' +
      ':idInd, :Type, :Name, :Prefered, :Note, :Phrase, :PDate, :SDate, :I1, :I2, :I3, :I4)';
    ParamByName('idInd').AsInteger := idNewInd;
    ParamByName('Type').AsString := qryInternal2.Fields[1].AsString;
    ParamByName('Name').AsString := qryInternal2.Fields[2].AsString;
    ParamByName('Prefered').AsInteger := 1;
    ParamByName('Note').AsString := qryInternal2.Fields[4].AsString;
    ParamByName('Phrase').AsString := qryInternal2.Fields[5].AsString;
    ParamByName('PDate').AsString := qryInternal2.Fields[6].AsString;
    ParamByName('SDate').AsString := qryInternal2.Fields[7].AsString;
    ParamByName('I1').AsString := qryInternal2.Fields[8].AsString;
    ParamByName('I2').AsString := qryInternal2.Fields[9].AsString;
    ParamByName('I3').AsString := qryInternal2.Fields[10].AsString;
    ParamByName('I4').AsString := qryInternal2.Fields[11].AsString;
    ExecSQL;
    SQL.Text := 'Select @@identity';
    Open;
    Result := Fields[0].AsInteger;
    Close;
   end;
  qryInternal2.Close;
end;

procedure TdmGenData.UpdateNameI4(const lDate: string; const lidInd: integer);
begin
  // UPDATE N.I4!!!
  with qryInternal do
   begin
    SQL.Text := 'UPDATE N SET I4=:I4 WHERE N.I=:idInd';
    ParamByName('idInd').AsInteger := lidInd;
    ParamByName('I4').AsString := lDate;
    ExecSQL;
   end;
end;

procedure TdmGenData.UpdateNameI3(const lDate: string; const lidInd: integer);
begin
  // UPDATE N.I3!!!
  with qryInternal do
   begin
    SQL.Text := 'UPDATE N SET I3=:I3 WHERE N.I=:idInd';
    ParamByName('idInd').AsInteger := lidInd;
    ParamByName('I3').AsString := lDate;
    ExecSQL;
   end;
end;

procedure TdmGenData.UpdateNamesPrefered(const idNamePref, idNameUnPref: integer);
begin
  if idNamePref <> idNameUnPref then
    with qryInternal do
     begin
      SQL.Text := 'UPDATE N SET X=0 WHERE N.no=:idName';
      ParamByName('idName').AsInteger := idNameUnPref;
      ExecSQL;
      SQL.Text := 'UPDATE N SET X=1 WHERE N.no=:idName';
      ParamByName('idName').AsInteger := idNamePref;
      ExecSQL;
     end;
end;

function TdmGenData.getIdNameofInd(const lidInd: integer): integer;
var
  temp: integer;
begin
  // Get idName of prefered name
  with Query1 do
   begin
    SQL.Text := 'SELECT no FROM N WHERE N.X=1 AND N.I=:idInd';
    ParamByName('idInd').AsInteger := lidInd;
    Open;
    temp := Fields[0].AsInteger;
    Result := temp;
    Close;
   end;
end;

procedure TdmGenData.DeleteName(const lidName: integer);
begin
  with Query1 do
   begin
    SQL.Text := 'DELETE FROM N WHERE no=:idname';
    ParamByName('idName').AsInteger := lidName;
    ExecSQL;
   end;
end;

procedure TdmGenData.SetDBSchema(const lDBSchema: string; out bSuccess: boolean);
begin
  bSuccess := False;
  with Database do
   begin
    Connected := False;
     try
      DatabaseName := lDBSchema;
      Connected := True;
      bSuccess := Connected;
      FProjectIsOpen := bSuccess;
     except
      // no exception
     end;
   end;
end;

function TdmGenData.GetDBSchema: string;
begin
  Result := Database.DatabaseName;
end;

procedure TdmGenData.SetDBHostUserPass(const lDBHostName, lDBUser, lDBPassword: string;
  out Success: boolean);
begin
  Success := False;
  with Database do
   begin
    Connected := False;
    FProjectIsOpen := False;
    HostName := lDBHostName;
    UserName := lDBUser;
    Password := lDBPassword;
    DatabaseName := 'mysql';
     try
      Connected := True;
      Success := Connected;
     except
      Success := False;
     end;
   end;
end;

procedure TdmGenData.RepairProjectDB(onProgress: TNotifyEvent = nil);
begin
  //ToDo: Enumerate Tables and then step trough all tables
  qryInternal2.SQL.Text := 'Show tables';
  qryInternal2.Open;
  qryInternal.tag := -qryInternal2.RecordCount;
  if assigned(onProgress) then
    onProgress(qryInternal);
  tag := 0;
  if assigned(onProgress) then
    onProgress(qryInternal);
  while not EOF do
    with qryInternal do
     begin
      SQL.Text := 'REPAIR TABLE ' + qryInternal2.Fields[0].AsString;
      ExecSQL;
      tag := tag + 1;
      if assigned(onProgress) then
        onProgress(qryInternal);
      qryInternal2.Next;
     end;
end;

procedure TdmGenData.RepairIndBirthDeath(onProgress: TNotifyEvent = nil);
var
  i4: string;
  i3: string;
begin
  qryInternal2.SQL.Text := 'SELECT no, I, I3, I4 FROM N';
  qryInternal2.Open;
  qryInternal.tag := -qryInternal2.RecordCount;
  if assigned(onProgress) then
    onProgress(qryInternal);
  tag := 0;
  if assigned(onProgress) then
    onProgress(qryInternal);
  while not qryInternal2.EOF do
    with qryInternal do
     begin
      i3 := getI3(qryInternal2.Fields[1].AsInteger);
      i4 := getI4(qryInternal2.Fields[1].AsInteger);
      sql.Text := 'UPDATE N SET I3=:idxBirth ,I4=:idxDeath where no=:idName';
      ParamByName('idxBirth').AsString := i3;
      ParamByName('idxDeath').AsString := i4;
      ParamByName('idName').AsInteger := qryInternal2.Fields[0].AsInteger;
      ExecSQL;
      tag := tag + 1;
      if assigned(onProgress) then
        onProgress(qryInternal);
      qryInternal2.Next;
     end;
end;


procedure TdmGenData.NamesChanged(Sender: TObject);
begin
  if assigned(FOnModifyIndividual) then
    FOnModifyIndividual(Sender);
end;

procedure TdmGenData.EventChanged(Sender: TObject);
begin
  if assigned(FOnModifyEvent) then
    FOnModifyEvent(Sender);
end;

function TdmGenData.CountAllRecords: longint;
var
  lMaxRecords: longint;
begin
  // Count all Records
  qryInternal2.SQL.Text := 'Show tables';
  qryInternal2.Open;
  lMaxRecords := 0;
  while not EOF do
    with qryInternal do
     begin
      SQL.Text := 'SELECT COUNT(*) FROM ' + qryInternal2.Fields[0].AsString;
      Open;
      lMaxRecords := lMaxRecords + Fields[0].AsInteger;
      Close;
      qryInternal2.Next;
     end;
  Result := lMaxRecords;
end;


procedure TdmGenData.CreateDBProject(const db: string; onProgress: TNotifyEvent);
var
  i: integer;
  temp, lstrLst: TStringList;
  buffer, lStr, lEnc: string;
  lFS: TFileStream;
  lEncoded: boolean;
begin

  if not Database.Connected then
    exit;
  with qryInternal do
   begin
    SQL.Text := 'CREATE DATABASE ' + db;
    ExecSQL;
    Tag := 0;
   end;
  if assigned(onProgress) then
    onProgress(qryInternal);
  Database.Connected := False;
  Database.DatabaseName := db;
  Database.Connected := True;
  FProjectIsOpen := True;
  temp := TStringList.Create;
   try
    //fr: Réviser structure
    //en: Create Table-Structure
    temp.add(
      'CREATE TABLE Y ' + // Type-Ressourcen
      '(id SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT ''idType'', ' +
      'no SMALLINT(5) UNSIGNED COMMENT ''idTypeLn'', ' +
      'T VARCHAR(35) COMMENT ''Description'',' + 'Y CHAR(1) COMMENT ''TypeCat'',' +
      'LN VARCHAR(2) COMMENT ''Language'',' +
      'P MEDIUMTEXT NULL COMMENT ''Phrase'',' +
      'R MEDIUMTEXT NULL COMMENT ''Roles'') COMMENT=''Types'';');
    temp.add('CREATE INDEX no ON Y (LN,no);');
    temp.add(
      'CREATE TABLE L ' + // Places
      '(no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT ''idPlace'', ' +
      'L TINYTEXT COMMENT ''Place-Text'' ) COMMENT=''Places'';');
    temp.add(
      'CREATE TABLE N ' + // Names
      '(no MEDIUMINT(9) UNSIGNED AUTO_INCREMENT PRIMARY KEY, ' +
      'I MEDIUMINT(8) UNSIGNED COMMENT ''idIndividuum'', ' +
      'Y SMALLINT(5) UNSIGNED COMMENT ''Naming-Type'', ' +
      'N TEXT COMMENT ''Name-Text'', ' + 'X BOOL COMMENT ''Prefered-Entry'', ' +
      'M TEXT COMMENT ''Note'', ' + 'P MEDIUMTEXT COMMENT ''Phrase'', ' +
      'PD TINYTEXT COMMENT ''Date (visual)'', ' +
      'SD TINYTEXT COMMENT ''Date (Sorting)'', ' +
      'I1 VARCHAR(35) COMMENT ''Family-Name (Index)'', ' +
      'I2 VARCHAR(35) COMMENT ''Given-Name (Index)'', ' +
      'I3 VARCHAR(21) COMMENT ''Birth (Index)'', ' +
      'I4 VARCHAR(21) COMMENT ''Death (Index)'') ENGINE = MyISAM COMMENT=''Names'';');
    temp.add('CREATE FULLTEXT INDEX N ON N (N);');
    temp.add('CREATE INDEX I ON N (I);');
    temp.add('CREATE INDEX I1 ON N (I1);');
    temp.add('CREATE INDEX I2 ON N (I2);');
    temp.add('CREATE INDEX I3 ON N (I3);');
    temp.add('CREATE INDEX I4 ON N (I4);');
    temp.add(
      'CREATE TABLE R ' + // Relation
      '(no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY  COMMENT ''idRelation'', ' +
      'Y SMALLINT(5) UNSIGNED  COMMENT ''idType'', ' +
      'A MEDIUMINT(8) UNSIGNED  COMMENT ''idIndividualChild'', ' +
      'B MEDIUMINT(8) UNSIGNED  COMMENT ''idIndividualParent'', ' +
      'M TINYTEXT NULL  COMMENT ''Note'', ' +
      'X BOOL COMMENT ''Prefered-Entry'', ' +
      'P MEDIUMTEXT NULL  COMMENT ''Phrase'', ' +
      'SD TINYTEXT NULL COMMENT ''Date (Sorting)'') COMMENT=''Relation'';');
    temp.add('CREATE INDEX A ON R (A);');
    temp.add('CREATE INDEX B ON R (B);');
    temp.add(
      'CREATE TABLE E ' +  // Events
      '(no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT ''idEvent'', ' +
      'Y SMALLINT(5) UNSIGNED COMMENT ''idType'', ' +
      'PD TINYTEXT COMMENT ''Event-Date'', ' +
      'SD TINYTEXT COMMENT ''Sorting-Date'', ' +
      'L MEDIUMINT(8) UNSIGNED COMMENT ''idPlace'', ' +
      'M TEXT NULL COMMENT ''Note'', ' +
      'X BOOL COMMENT ''Prefered-Entry'') ENGINE = MyISAM COMMENT=''Events'' ;');
    temp.add('CREATE FULLTEXT INDEX M ON E (M);');
    temp.add(
      'CREATE TABLE W ' +  // Witnesses
      '(no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY, ' +
      'I MEDIUMINT(8) UNSIGNED COMMENT ''idIndividuum'', ' +
      'E MEDIUMINT(8) UNSIGNED COMMENT ''idEvent'', ' +
      'X BOOL COMMENT ''Prefered-Entry'', ' +
      'P TINYTEXT NULL  COMMENT ''Phrase'', ' +
      'R VARCHAR(20) COMMENT ''Role'' ) COMMENT=''Witness of Event'';');
    temp.add('CREATE INDEX E ON W (E);');
    temp.add('CREATE INDEX I ON W (I);');
    temp.add(
      'CREATE TABLE I ' +  // Individuals
      '(no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT ''idIndividuum'', ' +
      'S CHAR(1) COMMENT ''Sex'', ' + 'V CHAR(1) COMMENT ''Living'', ' +
      'I TINYINT(2) UNSIGNED COMMENT ''Importance'', ' +
      'date CHAR(8) COMMENT ''Last Change'') COMMENT=''Individuals'';');
    temp.add(
      'CREATE TABLE X ' +    // Documents
      '(no SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY, ' +
      'X BOOL, ' + 'T VARCHAR(35), ' + 'D TINYTEXT NULL, ' +
      'F TINYTEXT NULL, ' + 'Z LONGTEXT NULL, ' + 'A CHAR(1), ' +
      'N MEDIUMINT(9) UNSIGNED) COMMENT=''Dokuments'' ;');
    temp.add('CREATE INDEX N ON X (N);');
    temp.add(
      'CREATE TABLE A ' +  //Depot of Source Relation
      '(no SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT ''idDepotOfSource'', '
      +
      'S SMALLINT(8) UNSIGNED COMMENT ''idSource'', ' +
      'D SMALLINT(8) UNSIGNED COMMENT ''idDepot'', ' +
      'M TINYTEXT NULL COMMENT ''Note'') COMMENT=''Repository of Source'';');
    temp.add('CREATE INDEX S ON A (S);');
    temp.add('CREATE INDEX D ON A (D);');
    temp.add(
      'CREATE TABLE D ' + //Depot
      '(no SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT ''idDepot'', ' +
      'T VARCHAR(35) COMMENT ''Title'', ' + 'D TINYTEXT NULL, ' +
      'M TINYTEXT NULL COMMENT ''Note'', ' +
      'I MEDIUMINT(9) UNSIGNED  COMMENT ''idIndividual'') COMMENT=''Repository'' ;');
    temp.add(
      'CREATE TABLE S ' + //Sources
      '(no SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY  COMMENT ''idSource'', ' +
      'T VARCHAR(35) COMMENT ''Title'', ' +
      'D TINYTEXT NULL COMMENT ''Description'', ' +
      'M TINYTEXT NULL COMMENT ''Note'', ' + 'A TINYTEXT NULL  COMMENT ''??'', ' +
      'Q SMALLINT(2) UNSIGNED  COMMENT ''Quality'' )  COMMENT=''Source'';');
    temp.add(
      'CREATE TABLE C ' + //Citations
      '(no MEDIUMINT(9) UNSIGNED AUTO_INCREMENT PRIMARY KEY  COMMENT ''idCitation'', ' +
      'Y CHAR(1) COMMENT ''TypeKat'', ' +
      'N MEDIUMINT(9) UNSIGNED COMMENT ''LinkID'', ' +
      'S SMALLINT(6) UNSIGNED COMMENT ''idSource'',' +
      'Q SMALLINT(2) UNSIGNED COMMENT ''Quality'', ' +
      'M TEXT NULL  COMMENT ''Note'') COMMENT=''Citations'' ;');
    temp.add('CREATE INDEX N ON C (N);');
    temp.add('CREATE INDEX S ON C (S);');
    // fr: Populer par défaut la table "Types" à partir d'un fichier texte (TDATA.TXT)
    // en: Fill "Types"-table with default data/texts from a file (TDATA.TXT)

    if FileExists(DataPath + DirectorySeparator + 'tdata.txt') then
     begin
      lFS := TFileStream.Create(DataPath + DirectorySeparator + 'tdata.txt', fmOpenRead);
       try
        setlength(lStr, lFS.Size);
        lFS.ReadBuffer(lStr[1], lFS.Size);
       finally
        FreeAndNil(lFS);
       end;
      lEnc := GuessEncoding(lStr);
      lstrLst := TStringList.Create;
       try
        lstrLst.Text := ConvertEncodingToUTF8(lStr, lEnc, lEncoded);
        for Buffer in lstrLst do
          temp.add('INSERT INTO Y (id, ln, no, Y, T, R, P) VALUES (1' +
            copy(buffer, 1, 3) + ',''FR'',' + buffer + ');');
       finally
        FreeAndNil(lstrLst);
       end;
     end;

    if FileExists(DataPath + DirectorySeparator + 'tdata_en.txt') then
     begin
      lFS := TFileStream.Create(DataPath + DirectorySeparator +
        'tdata_en.txt', fmOpenRead);
       try
        setlength(lStr, lFS.Size);
        lfs.ReadBuffer(lStr[1], lFS.Size);
       finally
        FreeAndNil(lFS);
       end;
      lEnc := GuessEncoding(lStr);
      lstrLst := TStringList.Create;
       try
        lstrLst.Text := ConvertEncodingToUTF8(lStr, lEnc, lEncoded);
        for Buffer in lstrLst do
          temp.add('INSERT INTO Y (id, ln, no, Y, T, R, P) VALUES (0' +
            copy(buffer, 1, 3) + ',''EN'',' + buffer + ');');
       finally
        FreeAndNil(lstrLst);
       end;
     end;

    if FileExists(DataPath + DirectorySeparator + 'tdata_de.txt') then
     begin
      lFS := TFileStream.Create(DataPath + DirectorySeparator +
        'tdata_de.txt', fmOpenRead);
       try
        setlength(lStr, lFS.Size);
        lfs.ReadBuffer(lStr[1], lFS.Size);
       finally
        FreeAndNil(lFS);
       end;
      lEnc := GuessEncoding(lStr);
      lstrLst := TStringList.Create;
       try
        lstrLst.Text := ConvertEncodingToUTF8(lStr, lEnc, lEncoded);
        for Buffer in lstrLst do
          temp.add('INSERT INTO Y (id,ln, no, Y, T, R, P) VALUES (2' +
            copy(buffer, 1, 3) + ',''DE'',' + buffer + ');');
       finally
        FreeAndNil(lstrLst);
       end;
     end;

    qryInternal.Tag := -temp.Count + 1;
    if assigned(onProgress) then
      onProgress(qryInternal);
    qryInternal.Tag := 1;
    if assigned(onProgress) then
      onProgress(qryInternal);

    // fr: Créer les tables
    // en: Create the tables
    with qryInternal do
      for i := 0 to temp.Count - 1 do
       begin
        SQL.Text := temp[i];
        ExecSQL;
        Tag := Tag + 1;
        if assigned(onProgress) then
          onProgress(qryInternal);
       end;
   finally
    temp.Free;
   end;
end;

procedure TdmGenData.PopulateCitations(Tableau: TStringGrid; Code: string; NStr: string);
var
  no: longint;
begin
  if TryStrToInt(NStr, no) then
    PopulateCitations(Tableau, Code, no);
end;

//Relation-Methods
{$Region Relation}
procedure TdmGenData.GetRelationData(const idRelation: integer;
  out lSortDate: string; out lPhraseText: string; out lMemoText: string;
  out lPrefered: boolean; out lidParent: longint; out lidChild: longint;
  out lRelType: longint);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT R.Y, R.X, R.A, R.B, R.M, R.P, R.SD FROM R WHERE R.no=:idRelation';
    ParamByName('idRelation').AsInteger := idRelation;
    Open;

    lRelType := Fields[0].AsInteger;
    lPrefered := Fields[1].AsBoolean;
    lidChild := Fields[2].AsInteger;
    lidParent := Fields[3].AsInteger;
    lMemoText := Fields[4].AsString;
    lPhraseText := Fields[5].AsString;
    lSortDate := Fields[6].AsString;
    Close;
   end;
end;

function TdmGenData.SaveRelationData(const idRelation: integer;
  const lPhrase: TCaption; const lSDate: TCaption; const lidType: PtrInt;
  const prefered: boolean; const lidParent: integer; const lidChild: integer;
  const lMemoText: string): integer;
begin
  with Query1 do
   begin
    if idRelation = 0 then
      SQL.Text :=
        'INSERT INTO R (Y, A, B, M, SD, P, X) VALUES (:idType, :idIndA, :idIndB, :M, :SDate, :P, :X)'
    else
     begin
      SQL.Text :=
        'UPDATE R SET Y=:idType, A=:idIndA, B=:idIndB, M=:M, SD=:SDate, P=:P, X=:X where no=:idRel';
      ParamByName('idRel').AsInteger := idRelation;
     end;
    ParamByName('idType').AsInteger := lidType;
    ParamByName('idIndA').AsInteger := lidChild;
    ParamByName('idIndB').AsInteger := lidParent;
    ParamByName('M').AsString := lMemoText;
    ParamByName('SDate').AsString := lSDate;
    ParamByName('P').AsString := lPhrase;
    ParamByName('X').AsBoolean := prefered;
    ExecSQL;
    if idRelation = 0 then
     begin
      SQL.Text := 'SELECT @@identity';
      Open;
      Result := Fields[0].AsInteger;
      Close;
     end
    else
      Result := idRelation;
   end;

end;

procedure TdmGenData.InsertRelation(const lidParent: longint;
  const lidChild: longint; const lidType: longint; const lidRelation: longint;
  const lPhrase: string; const lSDate: string; const lNote: string; lidPrefered:Boolean);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'INSERT IGNORE INTO R (no, Y, A, B, M, X, SD, P) ' +
      'VALUES (:idRelation, :idType, :idChild, :idParent, :Note, :Prefered, :SDate, :Phrase)';
    ParamByName('idRelation').AsInteger := lidRelation;
    ParamByName('idType').AsInteger := lidType;
    ParamByName('idChild').AsInteger := lidChild;
    ParamByName('idParent').AsInteger := lidParent;
    ParamByName('Note').AsString := lNote;
    ParamByName('Prefered').AsBoolean := lidPrefered;
    ParamByName('SDate').AsString := lSDate;
    ParamByName('Phrase').AsString := lPhrase;
    ExecSQL;
   end;
end;

function TdmGenData.CopyRelation(lidRelation: integer; idNewInd: integer): longint;
var
  idSourceInd: longint;
begin

  qryInternal2.SQL.Text := 'SELECT Y, A, B, M, P, X, SD FROM R WHERE no=:idRelation';
  qryInternal2.ParamByName('idRelation').AsInteger := lidRelation;
  qryInternal2.Open;
  idSourceInd := qryInternal2.Fields[1].AsInteger;
  with qryInternal do
   begin
    SQL.Text :=
      'INSERT IGNORE INTO R (Y, A, B, M, P, X, SD) VALUES (:idType, :idInd, :idLink, :Note, :Phrase, :Prefered , :SDate)';
    ParamByName('idType').AsInteger := qryInternal2.Fields[0].AsInteger;
    ParamByName('idInd').AsInteger := idSourceInd;
    if idNewInd > 0 then
      ParamByName('idLink').AsInteger := idNewInd
    else
      ParamByName('idLink').AsInteger := qryInternal2.Fields[2].AsInteger;
    //ToDo: Check! Here lies a possible Bug (New Ind, not same Ind)
    ParamByName('Note').AsString := qryInternal2.Fields[3].AsString;
    ParamByName('Phrase').AsString := qryInternal2.Fields[4].AsString;
    if idNewInd > 0 then
      ParamByName('Prefered').AsInteger := 1
    else
      ParamByName('Prefered').AsInteger := 0;
    ParamByName('SDate').AsString := qryInternal2.Fields[6].AsString;
    ExecSQL;
    SQL.Text := 'select @@identity';
    Open;
    First;
    Result := Fields[0].AsInteger;
    Close;
   end;
  SaveModificationTime(idSourceInd);
end;

function TdmGenData.RelationInsertData(idType, IdInd, idLink: integer;
  const Note: string = ''; const Phrase: string = ''; Prefered: boolean = True;
  Date: string = ''): integer;
begin
  with qryInternal do
   begin
    SQL.Text :=
      'INSERT INTO R (Y, A, B, M, P, X, SD) VALUES (:idType, :idInd, :idLink, :Note, :Phrase, :Prefered, :SDate)';
    ParamByName('idType').AsInteger := idType;
    ParamByName('idInd').AsInteger := idInd;
    ParamByName('idLink').AsInteger := idLink;
    ParamByName('Note').AsString := Note;
    ParamByName('Phrase').AsString := Phrase;
    ParamByName('Prefered').AsBoolean := Prefered;
    ParamByName('SDate').AsString := Date;
    ExecSQL;
    SQL.Text := 'select @@identity';
    Open;
    First;
    Result := Fields[0].AsInteger;
    Close;
   end;
  SaveModificationTime(idInd);
end;

function TdmGenData.CheckPrefParentExists(const lSex: string;
  const lidInd: longint): boolean;

begin
  with qryInternal do
   begin
    Close;
    SQL.Text :=
      'SELECT R.no, R.B FROM R JOIN I ON R.B=I.no WHERE I.S=:sex AND R.X=1 AND R.A=:idInd';
    ParamByName('idInd').AsInteger := lIdInd;
    ParamByName('sex').AsString := lSex;
    Open;
    Result := not EOF;
    Close;
   end;
end;

function TdmGenData.CheckIndChildExists(const lidParent: longint): boolean;

begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT no FROM R WHERE X=1 AND B=:idInd';
    ParamByName('idInd').AsInteger := lidParent;
    Open;
    Result := not EOF;
    Close;
   end;
end;

function TdmGenData.CheckIndRelationExist(idInd: integer): boolean;

begin
  // fr: Vérifier qu'il n'y a pas de parents primaires
  // fr: Vérifier qu'il n'y a pas d'enfants primaires
  // en: Check that there is no primary relatives
  with qryInternal do
   begin
    SQL.Text :=
      'SELECT R.no FROM R WHERE R.X=1 AND (R.A=:idInd OR R.B=:idInd )';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    Result := not EOF;
    Close;
   end;
end;

function TdmGenData.GetChild(idInd: integer): TArrayOfIntegers;
begin
  with Query3 do
   begin
    Close;
    SQL.Text := 'SELECT R.A  FROM R WHERE X=1 AND R.B=:idInd';
    ParamByName('idInd').AsInteger := idind;
    Open;
    setlength(Result, RecordCount);
    while not EOF do
     begin
      Result[RecNo] := Fields[0].AsInteger;
      Next;
     end;
    Close;
   end;
end;

function TdmGenData.GetParents(idInd: integer): TArrayOfIntegers;
begin
  with Query3 do
   begin
    Close;
    SQL.Text := 'SELECT R.B  FROM R WHERE X=1 AND R.A=:idInd';
    ParamByName('idInd').AsInteger := idind;
    Open;
    setlength(Result, RecordCount);
    while not EOF do
     begin
      Result[RecNo] := Fields[0].AsInteger;
      Next;
     end;
    Close;
   end;
end;

// fr: Update date de tri de relation
// en: Update sort-date of relationship
procedure TdmGenData.UpdateRelationSortdate(var lidInd: integer; var lDate: string);
begin
  with qryInternal do
   begin
    SQL.Text :=
      'UPDATE R SET SD=:SDate WHERE A=:idInd AND (SD=''100000000030000000000'' OR SD ='''')';
    ParamByName('SDate').AsString := lDate;
    ParamByName('idInd').AsInteger := lidInd;
    ExecSQL;
   end;
end;

procedure TdmGenData.PopulateParents(aSG: TStringGrid; idChild: longint);
var
  row: integer;
  pName, pBirth, pDeath: string;
  lidRelation: longint;
  sBestQuality: RawByteString;
begin
  with qryInternal2 do
   begin
    SQL.Text := 'SELECT no, X, Y, B FROM R WHERE A=:idInd ORDER BY X DESC, SD, Y, B';
    ParamByName('idInd').AsInteger := idChild;
    Open;
    First;
    row := 1;
    aSG.RowCount := RecordCount + 1;
    while not EOF do
     begin
      lidRelation := Fields[0].AsInteger;
      aSG.Cells[0, row] := Fields[0].AsString;
      aSG.Objects[0, row] := TObject(ptrint(lidRelation));

      if Fields[1].AsBoolean then
        aSG.Cells[1, row] := '*'
      else
        aSG.Cells[1, row] := '';

      aSG.Cells[2, row] := GetTypeName(Fields[2].AsInteger);
      aSG.Objects[2, row] := TObject(Ptrint(Fields[2].AsInteger));

      GetIndBaseData(Fields[3].AsInteger, pName, pBirth, pDeath);
      aSG.Cells[3, row] := format(rsDispNameAndLiveDate, [pName, pBirth, pDeath]);
      aSG.Objects[3, row] := TObject(Ptrint(Fields[3].AsInteger));

      sBestQuality := GetCitationBestQuality('R', row);
      aSG.Cells[4, row] := sBestQuality;

      aSG.Cells[5, row] := Fields[3].AsString;
      Next;
      row := row + 1;
     end;
   end;
  aSG.Parent.Caption := Translation.Items[130] + ' (' +
    IntToStr(aSG.RowCount - 1) + ')';
end;

procedure TdmGenData.PopulateParents(aSG: TStringGrid; NStr: string);
var
  no: longint;
begin
  if TryStrToInt(NStr, no) then
    PopulateParents(aSG, no);
end;

procedure TdmGenData.FillChildrenList(const LTable: TStringGrid;
  const lidInd: integer; out principaux: integer);
var
  lidParent: longint;
  lName: string;
  deces: string;
  naissance: string;
  row: integer;
begin
  with qryInternal2 do
   begin
    Close;
    SQL.Text :=
      'SELECT R.no, R.X, R.Y, R.A FROM R WHERE R.B=:idInd ORDER BY R.X DESC, R.SD, R.Y';
    ParamByName('idInd').AsInteger := lidInd;
    Open;
    First;
    row := 1;
    principaux := 0;
    lTable.RowCount := RecordCount + 1;
    while not EOF do
     begin
      lTable.Cells[0, row] := Fields[0].AsString;
      lTable.Objects[0, row] := TObject(ptrint(Fields[0].AsInteger));

      if Fields[1].AsBoolean then
       begin
        lTable.Cells[1, row] := '*';
        principaux := principaux + 1;
       end
      else
        lTable.Cells[1, row] := '';

      lTable.Cells[2, row] := GetTypeName(Fields[2].AsInteger);
      lTable.Objects[2, row] := TObject(ptrint(Fields[2].AsInteger));

      lidParent := Fields[3].AsInteger;
      GetIndBaseData(lidParent, lName, naissance, deces);

      lTable.Cells[3, row] :=
        format('%s (%s - %s)', [DecodeName(lName, 1), naissance, deces]);
      lTable.Objects[3, row] := TObject(ptrint(lidParent));

      lTable.Cells[4, row] :=
        GetCitationBestQuality('R', ptrint(lTable.Objects[0, row]));
      lTable.Cells[5, row] := Fields[3].AsString;

      if CheckIndChildExists(lidParent) then
        lTable.Cells[6, row] := '+'
      else
        lTable.Cells[6, row] := '';
      Next;
      row := row + 1;
     end;
    Close;
   end;
end;

procedure TdmGenData.SetRelationPrefered(const lidInd, lidIndRel: integer;
  const lidRelation: integer);
var
  s: string;
begin

  with qryInternal2 do
   begin
    Close;
    qryInternal.Close;
    if IsValidIndividuum(lidIndRel) then
     begin
      S := GetSexOfInd(lidIndRel);

      SQL.Text :=
        'SELECT R.no, R.B FROM R JOIN I ON R.B=I.no WHERE I.S=:Sex AND R.X=1 AND R.A=:idind';
      ParamByName('idInd').AsInteger := lidInd;
      ParamByName('Sex').AsString := S;
      Open;
      if not EOF then
       begin

        qryInternal.SQL.Text := 'UPDATE R SET X=0 WHERE no=idRelation';
        qryInternal.ParamByName('idRelation').AsInteger := Fields[0].AsInteger;
        qryInternal.ExecSQL;

        SaveModificationTime(Fields[1].AsInteger);
       end;
      Close;
     end;
   end;

  // Set Relation Prefered
  with qryInternal do
   begin
    SQL.Text := 'UPDATE R SET X=1 WHERE no=:idRelation';
    ParamByName('idRelation').AsInteger := lidRelation;
    ExecSQL;
   end;

  // Modifie la date de modification
  SaveModificationTime(lidIndRel);
  SaveModificationTime(lidind);
end;

procedure TdmGenData.ResetRelationPrefered(const lidInd, lidIndRel: integer;
  const lidRelation: integer);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'UPDATE R SET X=0 WHERE no=:idRelation';
    ParamByName('idRelation').AsInteger := lidRelation;
    ExecSQL;
   end;
  // Modifie la date de modification
  SaveModificationTime(lidIndRel);
  SaveModificationTime(lidInd);
end;

function TdmGenData.GetRelationChildExists(const lidChild: longint): boolean;
var
  lChildsExist: boolean;
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT top(1) no FROM R WHERE X=1 AND B=:idInd';
    ParamByName('idInd').AsInteger := lidChild;
    Open;
    lChildsExist := not EOF;
    Result := lChildsExist;
    Close;
   end;
end;

procedure TdmGenData.FillSiblingsTable(const lTable: TStringGrid; const lidInd: longint);
var
  lChildsExist: boolean;
  lidRelation: longint;
  lidChild: longint;
  conjoint: string;
  deces: string;
  naissance: string;
  nbmarriage: integer;
  row: integer;
  p2: integer;
  p1: integer;
begin
  p1 := 0;
  p2 := 0;
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT R.B FROM R WHERE X=1 AND A=:idInd ORDER BY SD';
    ParamByName('idInd').AsInteger := lidInd;
    Open;
    if not EOF then
     begin
      p1 := Fields[0].AsInteger;
      Next;
     end;
    if not EOF then
      p2 := Fields[0].AsInteger;
    Close;
   end;
  with qryInternal2 do
   begin
    Close;
    SQL.Text := 'SELECT R.no, R.A, N.N, N.I3, N.I4 FROM R JOIN N on N.I=R.A ' +
      'WHERE N.X=1 AND R.X=1 AND (R.B=:idind1 OR R.B=:idind2) ORDER BY R.SD, N.I';
    ParamByName('idInd1').AsInteger := p1;
    ParamByName('idInd2').AsInteger := p2;
    Open;
    First;
    row := 1;
    lTable.RowCount := RecordCount + 1;
    while not EOF do
     begin
      // Enlève les doublons et le sujet
      if (not (Fields[1].AsInteger = lidInd)) and
        (not (Fields[1].AsInteger = ptrint(lTable.Objects[2, row - 1]))) then
       begin
        lidRelation := Fields[0].AsInteger;
        lTable.Cells[0, row] := IntToStr(lidRelation);
        lTable.Objects[0, row] := TObject(PtrInt(lidRelation));

        if Copy(Fields[3].AsString, 1, 1) = '1' then
          naissance := Copy(Fields[3].AsString, 2, 4)
        else
          naissance := '';

        if Copy(Fields[4].AsString, 1, 1) = '1' then
          deces := Copy(Fields[4].AsString, 2, 4)
        else
          deces := '';

        lTable.Cells[1, row] :=
          DecodeName(Fields[2].AsString, 1) + ' (' + naissance +
          ' - ' + deces + ')';
        // Trouver conjoint + nombre de conjoints
        lidChild := Fields[1].AsInteger;
        nbmarriage := GetIndSpouse(lidChild, conjoint);
        if length(conjoint) > 0 then
          lTable.Cells[1, row] :=
            lTable.Cells[1, row] + ' ' + format(rsMarriedWith, [conjoint, nbmarriage])
        else
          lTable.Cells[2, row] := IntToStr(lidChild);

        lTable.Objects[2, row] := TObject(ptrint(lidChild));

        lTable.Cells[3, row] := GetCitationBestQuality('R', lidRelation);

        lChildsExist := GetRelationChildExists(lidChild);
        if lChildsExist then
          lTable.Cells[4, row] := '+'
        else
          lTable.Cells[4, row] := '';
        row := row + 1;
       end
      else
        lTable.RowCount := lTable.RowCount - 1;
      Next;
     end;
    Close;
   end;
end;

function TdmGenData.GetIndSpouse(const idInd: longint; out Spouse: string): integer;
var
  lidEvent, lidSpouse: longint;
  nbmarriage: integer;
begin
  with qryInternal2 do
   begin
    Spouse := '';
    Close;
    SQL.Text :=
      'SELECT E.no FROM (E JOIN Y on E.Y=Y.no) JOIN W on W.E=E.no WHERE W.X=1 AND E.X=1 AND Y.Y=''M'' AND W.I=:idInd';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    nbmarriage := RecordCount;
    if not EOF then
     begin
      lidEvent := Fields[0].AsInteger;
      SQL.Text :=
        'SELECT W.I, N.N FROM W JOIN N on W.I=N.I WHERE W.X=1 AND N.X=1 AND W.E=:idEvent AND NOT W.I=:idInd';
      ParamByName('idEvent').AsInteger := lidEvent;
      ParamByName('idInd').AsInteger := idInd;
      Open;
      lidSpouse := Fields[0].AsInteger;
      Spouse := DecodeName(GetIndividuumName(lidSpouse), 1);
     end;
    Result := nbmarriage;
    Close;
   end;
end;

procedure TdmGenData.AppendRelationTreeVParents(const lTreeView: TTreeView);
var
  idInd: integer;
  deces: string;
  naissance: string;
begin
  if not lTreeView.Selected.HasChildren then
    with qryInternal2 do
     begin
      Close;
      idInd := ptrint(TObject(lTreeView.Selected.Data));
      SQL.Text :=
        'SELECT R.B, N.N, N.I3, N.I4 FROM R JOIN N on R.B=N.I WHERE R.X=1 AND N.X=1 AND R.A=:idInd';
      ParamByName('idInd').AsInteger := idInd;
      Open;
      First;
      while not EOF do
       begin
        if Copy(Fields[2].AsString, 1, 1) = '1' then
          naissance := Copy(Fields[2].AsString, 2, 4)
        else
          naissance := '';
        if Copy(Fields[3].AsString, 1, 1) = '1' then
          deces := Copy(Fields[3].AsString, 2, 4)
        else
          deces := '';
        lTreeView.Items.AddChildObject(
          lTreeView.Selected,
          format(rsDispNameIdAndLiveDate,
          [DecodeName(Fields[1].AsString, 1), Fields[0].AsInteger,
          naissance, deces]),
          pointer(TObject(ptrint(Fields[0].AsInteger))));
        Next;
       end;
      Close;
      lTreeView.Selected.Expand(True);
     end;
end;

procedure TdmGenData.AppendRelationTreeVChildren(const lTreeView: TTreeView);
var
  deces: string;
  naissance: string;
  lidInd: PtrInt;
begin
  if not lTreeView.Selected.HasChildren then
    with qryInternal2 do
     begin
       begin
        Close;
        lidInd := ptrint(TObject(lTreeView.Selected.Data));
        SQL.Text :=
          'SELECT R.A, N.N, N.I3, N.I4 FROM R JOIN N on R.A=N.I WHERE R.X=1 AND N.X=1 AND R.B=:idInd ORDER BY N.I3';
        ParamByName('idInd').AsInteger := lidInd;
        Open;
        First;
        while not EOF do
         begin
          if Copy(Fields[2].AsString, 1, 1) = '1' then
            naissance := Copy(Fields[2].AsString, 2, 4)
          else
            naissance := '';
          if Copy(Fields[3].AsString, 1, 1) = '1' then
            deces := Copy(Fields[3].AsString, 2, 4)
          else
            deces := '';
          lTreeView.Items.AddChild(lTreeView.Selected,
            DecodeName(Fields[1].AsString, 1) + ' [' +
            Fields[0].AsString + '] (' + naissance + '-' + deces + ')');
          Next;
         end;
        Close;
       end;
     end;
  lTreeView.Selected.Expand(True);
end;

procedure TdmGenData.DeleteRelationFull(const lidInd: integer;
  const lidIndChild: integer; const lidRelation: integer);
begin
  DeleteCitationsbyType_ID('R', lidRelation);
  DeleteRelation(lidRelation);
  SaveModificationTime(lidIndChild);
  SaveModificationTime(lidInd);

end;

procedure TdmGenData.DeleteRelation(const lidRelation: PtrInt);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'DELETE FROM R WHERE no=:idRelation';
    ParamByName('idRelation').AsInteger := lidRelation;
    ExecSQL;
   end;
end;

procedure TdmGenData.UpdateIndModificationTimesByRelation(lLinkID: integer);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT R.A, R.B FROM R WHERE R.no=:idRelation';
    ParamByName('idRelation').AsInteger := lLinkID;
    Open;
    First;
    SaveModificationTime(Fields[0].AsInteger);
    SaveModificationTime(Fields[1].AsInteger);
    Close;
   end;
end;


{$endRegion ~Relation}
// Witness-Methods
{$region Witness (W)}
function TdmGenData.AppendWitness(Role, Phrase: string; idInd, idEvent: integer;
  Pref: boolean): integer;
begin
  with qryInternal do
   begin
    SQL.Text :=
      'INSERT INTO W (R, I, P, E, X) VALUES (:Role, :idInd, :Phrase, :idEvent, :Pref)';
    ParamByName('Role').AsString := Role;
    ParamByName('Phrase').AsString := Phrase;
    ParamByName('idInd').AsInteger := idInd;
    ParamByName('idEvent').AsInteger := idEvent;
    ParamByName('Pref').AsBoolean := Pref;
    ExecSQL;
    SQL.Text := 'SELECT @@identity';
    Open;
    Result := qryInternal.Fields[0].AsInteger;
    Close;
   end;
end;

procedure TdmGenData.InsertWitness(const Prefered: boolean;
  const idEvent: longint; const idInd: longint; const Role: string;
  const Phrase: string);
begin
  AppendWitness(Role, Phrase, idInd, idEvent, Prefered);
end;


procedure TdmGenData.UpdateWitnessModDatebyEvent(lidEvent: integer);
var
  lidInd: longint;
begin
  with Query3 do
   begin
    Close;
    SQL.Text := 'SELECT W.I, W.X FROM W WHERE W.E=:idEvent';
    ParamByName('idEvent').AsInteger := lidEvent;
    Open;
    First;
    while not EOF do
     begin
      lidInd := Fields[0].AsInteger;
      SaveModificationTime(lidInd);
      Next;
     end;
    Close;
   end;
end;


procedure TdmGenData.UpdateWitnessModbyEvent(lidEvent: integer);
begin
  with Query3 do
   begin
    // fr: Sauvegarder les modifications pour tout les témoins de l'événements
    // en: Save the changes for all the witnesses to the events
    SQL.Text := 'SELECT W.I, W.X FROM W WHERE W.E=:idevent';
    ParamByName('idEvent').AsInteger := lidEvent;
    Open;
    First;
    while not EOF do
     begin
      SaveModificationTime(Fields[0].AsInteger);
      Next;
     end;
   end;
end;


procedure TdmGenData.DeleteWitnessbyEvent(const lidEvent: integer);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'DELETE FROM W WHERE E=:idEvent';
    ParamByName('idEvent').AsInteger := lidEvent;
    ExecSQL;
   end;
end;

function TdmGenData.GetWitnessListbyEvent(lidEvent: integer): string;
var
  temoins1: string;
begin
  with qryInternal do
   begin
    Close;
    SQL.Text :=
      'SELECT W.I FROM W WHERE W.X=1 AND W.E=:idEvent ORDER BY W.I';
    ParamByName('idEvent').AsInteger := lidEvent;
    Open;
    First;
    temoins1 := '';
    while not EOF do
     begin
      temoins1 := temoins1 + '|' + Fields[0].AsString;
      Next;
     end;
    Close;
    Result := temoins1;
   end;
end;

procedure TdmGenData.UpdateWitnessPhraseRole(const idWitness: integer;
  const Role: string; const Phrase: string);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'UPDATE W SET P=:Phrase, R=:Role WHERE W.no=:idWitness';
    ParamByName('idWitness').AsInteger := idWitness;
    ParamByName('Phrase').AsString := Phrase;
    ParamByName('Role').AsString := Role;
    ExecSQL;
   end;
end;

{$endRegion}

// Events-Methods
{$region Events}
procedure TdmGenData.FillTableEvents(const idInd: integer;
  const lgrdEvents: TStringGrid);
var
  lWitness: string;
  lMemo: string;
  lPlace, lBirth: string;
  row: integer;
  lAge: integer;
  lidWitness, lidEvent, lidType: longint;
begin
  lBirth := GetI3(idInd);
  Query1.Close;
  Query1.SQL.Text :=
    'SELECT E.no, E.X, E.Y, E.PD, E.L, E.SD, W.X, E.M FROM E JOIN W on W.E=E.no WHERE W.I=:idInd ORDER BY E.SD';
  Query1.ParamByName('idInd').AsInteger := idInd;
  Query1.Open;
  Query1.First;
  row := 1;
  lgrdEvents.RowCount := Query1.RecordCount + 1;
  assert(Query1.Fields.Count = 8, 'Query should have 8 Fields');
  while not Query1.EOF do
   begin
    // idEvent
    lidEvent := Query1.Fields[0].AsInteger;
    lgrdEvents.Cells[0, row] := IntToStr(lidEvent);
    lgrdEvents.objects[0, row] := TObject(ptrint(lidEvent));

    // Prefered
    if Query1.Fields[1].AsBoolean and Query1.Fields[6].AsBoolean then
      lgrdEvents.Cells[1, row] := '*'
    else
      lgrdEvents.Cells[1, row] := '';

    lidType := Query1.Fields[2].AsInteger;
    lgrdEvents.Cells[2, row] := GetTypeName(lidType);
    lgrdEvents.Objects[2, row] := TObject(ptrint(lidType));
    Query2.Close;

    lgrdEvents.Cells[3, row] := ConvertDate(Query1.Fields[3].AsString, 1);

    // Trouver # d'un autre principal témoin de l'événement
    Query2.SQL.Text := 'SELECT I FROM W WHERE X=1 AND E=:idEvent';
    Query2.ParamByName('idEvent').AsInteger := lidEvent;
    Query2.Open;
    lgrdEvents.Cells[7, row] := '0';
    lgrdEvents.Objects[7, row] := TObject(ptrint(0));
    lWitness := '';
    while not Query2.EOF do
     begin
      // Trouver les témoins principaux de l'événement
      if not (Query2.Fields[0].AsInteger = idInd) then
       begin
        lidWitness := Query2.Fields[0].AsInteger;
        if ptrint(lgrdEvents.Cells[7, row]) = 0 then
         begin
          lgrdEvents.Cells[7, row] := IntToStr(lidWitness);
          lgrdEvents.Objects[7, row] := TObject(ptrint(lidWitness));
         end;
        // Get Name of Witnesses
        if length(lWitness) > 0 then
          lWitness :=
            lWitness + ' & ' + format('%s [%d]',
            [GetIndividuumName(lidWitness), lidWitness])
        else
          lWitness :=
            format('%s [%d]', [GetIndividuumName(lidWitness), lidWitness]);
       end;
      Query2.Next;
     end;
    Query2.Close;

    // Implanter la description
    Query2.SQL.Text := 'SELECT L FROM L WHERE no=:idPlace';
    Query2.ParamByName('idPlace').AsInteger := Query1.Fields[4].AsInteger;
    Query2.Open;
    lPlace := DecodeChanged(Query2.Fields[0].AsString);
    lMemo := Query1.Fields[7].AsString;
    if length(lPlace) > 0 then
      if length(lMemo) > 0 then
        if length(lWitness) > 0 then
          lgrdEvents.Cells[4, row] := lWitness + '; ' + lPlace + '; ' + lMemo
        else
          lgrdEvents.Cells[4, row] := lPlace + '; ' + lMemo
      else
      if length(lWitness) > 0 then
        lgrdEvents.Cells[4, row] := lWitness + '; ' + lPlace
      else
        lgrdEvents.Cells[4, row] := lPlace
    else
    if length(lMemo) > 0 then
      if length(lWitness) > 0 then
        lgrdEvents.Cells[4, row] := lWitness + '; ' + lMemo
      else
        lgrdEvents.Cells[4, row] := lMemo
    else
    if length(lWitness) > 0 then
      lgrdEvents.Cells[4, row] := lWitness
    else
      lgrdEvents.Cells[4, row] := '';
    Query2.Close;

    Query2.SQL.Text :=
      'SELECT Q FROM C WHERE Y=''E'' AND N=:idEvent ORDER BY Q DESC';
    query2.ParamByName('idEvent').AsInteger := lidEvent;
    Query2.Open;
    lgrdEvents.Cells[5, row] := Query2.Fields[0].AsString;
    Query2.Close;

    // Calculer l'âge

    if ((Copy(lBirth, 1, 1) = '1') and
      (Copy(Query1.Fields[5].AsString, 1, 1) = '1')) then
      //Todo -ojc : find a better Age-calculating method.
      lAge := StrToInt(Copy(Query1.Fields[5].AsString, 2, 4)) -
        StrToInt(Copy(lBirth, 2, 4))
    else
      lAge := -1;
    if (lAge >= 0) and (lAge < 130) then
      //Todo -ojc : Make the Max-lAge configurable
      lgrdEvents.Cells[6, row] := IntToStr(lAge)
    else
      lgrdEvents.Cells[6, row] := '';
    if Query1.Fields[6].AsBoolean then
      lgrdEvents.Cells[8, row] := '*'
    else
      lgrdEvents.Cells[8, row] := '';
    Query1.Next;
    row := row + 1;
   end;
end;

function TdmGenData.GetEventType(const lIdEvent: integer): string;

begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT Y.Y FROM E JOIN Y ON Y.no=E.Y WHERE E.no=:idEvent';
    ParamByName('idEvent').AsInteger := lIdEvent;
    Open;
    Result := Fields[0].AsString;
    Close;
   end;
end;

function TdmGenData.GetEventExtType(idEvent, idInd: integer;
  out EvType, TypeType: string): boolean;
var
  lEventFound: boolean;
begin
  with qryInternal do
   begin
    Close;
    SQL.Text :=
      'SELECT E.Y, Y.Y FROM E JOIN W on W.E=E.no JOIN Y on E.Y' +
      '=Y.no WHERE W.X=1 AND W.I=:idInd AND E.no=:idEvent';
    ParamByName('idInd').AsInteger := idInd;
    ParamByName('idEvent').AsInteger := idEvent;
    Open;
    First;
    TypeType := Fields[1].AsString;
    lEventFound := not EOF;
    EvType := Fields[0].AsString;
    Close;
    Result := lEventFound;
   end;
end;

function TdmGenData.SaveEventData(const pidEvent: integer; const pidType: integer;
  const pIdPlace: integer; const pPrefered: boolean; const pInfo: string;
  const pDate: string; const pSortDate: string): integer;

begin

  if pidEvent = 0 then
    with qryInternal do
     begin
      Close;
      SQL.Text := 'INSERT INTO E (Y, L, M, PD, SD, X) VALUES ' +
        '(:idType, :idplace, :Info, :PD, :SD, :Pref);';
      ParamByName('idType').AsInteger := pidType;
      ParamByName('idplace').AsInteger := pIdPlace;
      ParamByName('info').AsString := pInfo;
      ParamByName('PD').AsString := pDate;
      ParamByName('SD').AsString := pSortDate;
      ParamByName('Pref').AsBoolean := pPrefered;
      ExecSQL;
      SQL.Text := 'select @@identity';
      Open;
      First;
      Result := Fields[0].AsInteger;
      Close;
     end
  else
    with qryInternal do
     begin
      Close;
      SQL.Text := 'UPDATE E SET Y=:idType ' +
        ', L=:idplace, M=:info, PD=:PD, SD=:SD WHERE no=:idEvent';
      ParamByName('info').AsString := pInfo;
      ParamByName('idType').AsInteger := pidType;
      ParamByName('idplace').AsInteger := pIdPlace;
      ParamByName('PD').AsString := pDate;
      ParamByName('SD').AsString := pSortDate;
      ExecSQL;
      Result := pidEvent;
     end;

end;

procedure TdmGenData.DeleteEvent(const lidEvent: integer);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'DELETE FROM E WHERE no=:idEvent';
    ParamByName('idEvent').AsInteger := lidEvent;
    ExecSQL;
   end;
end;

procedure TdmGenData.DeleteEventComplete(const lidEvent: integer);
const
  lType = 'E';
begin
  // Modifie la date de dernière modification pour tous les témoins
  UpdateWitnessModDatebyEvent(lidEvent);
  // Supprimer tous les exhibits de cet événement
  DeleteDocumentsbyType_ID(lType, lidEvent);

  DeleteCitationsbyType_ID(lType, lidEvent);

  DeleteWitnessbyEvent(lidEvent);

  DeleteEvent(lidEvent);
end;



procedure TdmGenData.CopyEvent(const idEvent: integer);
var
  idNewEvent: longint;

begin

  with qryInternal do
   begin
    SQL.Text := 'SELECT Y, PD, SD, L, M, X FROM E WHERE no=:idEvent';
    ParamByName('idEvent').AsInteger := idEvent;
    Open;
    if EOF then
     begin
      Close;
      exit;
     end;
   end;
  with qryInternal2, qryInternal.Fields do
   begin
    SQL.Text :=
      'INSERT IGNORE INTO E (Y, PD, SD, L, M, X) VALUES (:Type, :PDate, :SDate, :Place, :M, :X)';
    ParamByName('Type').AsString := FieldByNumber(0).AsString;
    ParamByName('PDate').AsString := FieldByNumber(1).AsString;
    ParamByName('SDate').AsString := FieldByNumber(2).AsString;
    ParamByName('Place').AsString := FieldByNumber(3).AsString;
    ParamByName('M').AsString := FieldByNumber(4).AsString;
    ParamByName('X').AsInteger := 0;
    ExecSQL;
    SQL.Text := 'select @@identity';
    Open;
    First;
    idNewEvent := Fields[0].AsInteger;
    Close;
    qryInternal.Close;
   end;
  // en: Copy Citation of Event
  CopyCitation('E', idNewEvent, idEvent);

  CopyDocumentbyType_ID('E', idNewEvent, idEvent);

  // en: Copy Witness
  with qryInternal do
   begin
    SQL.Text := 'SELECT I, E, X, P, R FROM W WHERE E=:idEvent';
    ParamByName('idEvent').AsInteger := idEvent;
    Open;
   end;
  while not qryInternal.EOF do
    with qryInternal2 do
     begin
      SQL.Text :=
        'INSERT IGNORE INTO W (I, E, X, P, R) VALUES (:idInd, :idEvent, :X, :P, :R)';
      ParamByName('idInd').AsInteger := qryInternal.Fields[0].AsInteger;
      ParamByName('idInd').AsInteger := idNewEvent;
      ParamByName('X').AsString := qryInternal.Fields[2].AsString;
      ParamByName('P').AsString := qryInternal.Fields[3].AsString;
      ParamByName('R').AsString := qryInternal.Fields[4].AsString;
      ExecSQL;
      SaveModificationTime(qryInternal.Fields[0].AsInteger);
      qryInternal.Next;
     end;
  EventChanged(self);

end;



procedure TdmGenData.ResetEventPref(lidEvent: integer);
begin
  with qryInternal do
   begin
    // fr: si primaire, enlève le primaire de la base de données et du tableau.
    // en: if prefered, removes the prefered-setting of the database.
    Close;
    SQL.Text := 'UPDATE E SET X=0 WHERE no=:idEvent';
    ParamByName('idEvent').AsInteger := lidEvent;
    ExecSQL;
   end;
end;

procedure TdmGenData.ResetEventPrefered(lidEvent: integer);
begin
  ResetEventPref(lidEvent);
  UpdateWitnessModDatebyEvent(lidEvent);
end;

function TdmGenData.SetEventPrefered(const lidEvent, lidInd: integer): boolean;
var
  redraw, lEventFound: boolean;
  lDate: string;
  lTypeType: string;
  lEvType: string;
  temoins2: string;
  temoins1: string;
  lidEvent2: longint;
begin
  redraw := False;
  lEventFound := GetEventExtType(lidEvent, lidInd, lEvType, lTypeType);
  if lEventFound then

   begin
    // trouve si autre événement du même types avec même témoins primaires qui est primaire
    temoins1 := GetWitnessListbyEvent(lidEvent);

    with qryInternal2 do
     begin
      Close;
      // Todo: Error: Query1.eof := true => No Data !!!
      if lTypeType = 'X' then
       begin
        SQL.Text :=
          'SELECT E.no, W.I FROM E JOIN W on W.E=E.no WHERE W.X=1 AND E.X=1 AND E.Y=:Type AND W.I=:idInd';
        ParamByName('Type').AsString := lEvType;
       end
      else
       begin
        SQL.Text :=
          'SELECT E.no, W.I FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no WHERE W.X=1 AND E.X=1 AND Y.Y=:Type AND W.I=:idInd';
        ParamByName('Type').AsString := lTypeType;
       end;
      ParamByName('idInd').AsInteger := lidInd;
      Open;
      First;
      while not EOF do
       begin
        lidEvent2 := Fields[0].AsInteger;
        temoins2 := GetWitnessListbyEvent(lidEvent2);

        // Enlève son tag primaire
        if temoins1 = temoins2 then
         begin
          ResetEventPref(lidEvent2);
          redraw := True;
         end;
        Next;
       end;
     end;

    SetEventPref(lidEvent);

    if lTypeType = 'B' then
     begin
      lDate := GetI3(lidInd);
      UpdateNameI3(lDate, lidInd);
     end
    else if lTypeType = 'D' then
     begin
      lDate := GetI3(lidInd);
      UpdateNameI4(lDate, lidInd);
     end;
   end;

  UpdateWitnessModDatebyEvent(lidevent);
  Result := redraw;
end;

procedure TdmGenData.InsertEvent(const idEvent: longint; const idType: longint;
  const idPlace: longint; const Prefered: boolean; const lMemo: string;
  const SDate: string; const PDate: string);
begin
  with Query1 do
   begin
    SQL.Text :=
      'INSERT IGNORE INTO E (no, Y, PD, SD, L, M, X) ' +
      'VALUES (:idEvent, :idType, :PDate, SDate, :idPlace, :Note, :Pref)';
    ParamByName('idEvent').AsInteger := idEvent;
    ParamByName('idType').AsInteger := idType;
    ParamByName('PDate').AsString := PDate;
    ParamByName('Sdate').AsString := SDate;
    ParamByName('idPlace').AsInteger := idPlace;
    ParamByName('Note').AsString := lMemo;
    ParamByName('Pref').AsBoolean := Prefered;
    ExecSQL;
   end;
end;

{$Endregion Events}
// Document Methods
{$region Documents}

function TdmGenData.GetDocumentInfo(const lidDocument: Integer): string;
var
  lMemoText: string;
begin
  with Query2 do begin
  SQL.Text := 'SELECT X.Z FROM X WHERE X.no=:idDocument';
          ParamByName('idDocument').AsInteger:=lidDocument;
          Open;
          lMemoText:=Fields[0].AsString;
          Close;
    Result:=lMemoText;
  end;
end;

procedure TdmGenData.UpdateDocumentInfo(const lidDocument: integer; const lDocumentInfo: string);
begin
    with Query2 do begin
    Close;
      SQL.Text := 'UPDATE X SET Z=:Z WHERE X.no=:idDocument';
      ParamByName('Z').AsString := lDocumentInfo;
      ParamByName('idDocument').AsInteger := lidDocument;
      ExecSQL;
    end;
end;

procedure TdmGenData.UpdateModificationByEventDocument(lidDocument: integer);

begin
  with qryInternal do
   begin
    Close;
    SQL.Text :=
      'SELECT W.I FROM (W JOIN E on W.E=E.no) JOIN X on X.N=E.no WHERE X.no=:idDocument';
    ParamByName('idDocument').AsInteger := lidDocument;
    Open;
    First;
    while not EOF do
     begin
      dmGenData.SaveModificationTime(Fields[0].AsInteger);
      Next;
     end;
    Close;
   end;
end;

function TdmGenData.SaveDocumentData(lidDocument: integer; const lLinkID: integer;
  const lDocumentType: TCaption; const lFileName: TCaption;
  const lDocumentDescription: TCaption; const lDocumentTitle: TCaption): integer;

begin
  with qryInternal do
   begin
    Close;
    if lidDocument = 0 then
     begin
      SQL.Text :=
        'INSERT INTO X (X, T, D, F, A, N) VALUES ( 0, :Title, :Description, :Filename, :DocType, :idLink';
      ParamByName('DocType').AsString := lDocumentType;
      ParamByName('idLink').AsInteger := lLinkID;
     end
    else
     begin
      SQL.Text := 'UPDATE X SET T=:Title, D=:Description, F=:Filename WHERE X.no=:idDocument';
      ParamByName('idDocument').AsInteger := lidDocument;
     end;
    ParamByName('Title').AsString := lDocumentTitle;
    ParamByName('Description').AsString := lDocumentDescription;
    ParamByName('Filename').AsString := lFileName;
    ExecSQL;
   end;
  // Enregistrer la date de la dernière modification pour tout les individus reliés
  // à cet exhibits.
  if lidDocument = 0 then
    Result := dmGenData.GetLastIDOfTable('X')
  else
    Result := lidDocument;
end;

procedure TdmGenData.UpdateDocumentMemo(const lidDocument: integer;
  const lImageMemoText: TCaption);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'UPDATE X SET Z=:MemoText WHERE X.no=:idDocument';
    ParamByName('idDocument').AsInteger := lidDocument;
    ParamByName('MemoText').AsString := lImageMemoText;
    ExecSQL;
   end;
end;

procedure TdmGenData.PopulateDocuments(Tableau: TStringGrid; Code: string; no: integer);

var
  row: integer;
  titre, desc: string;
begin
  with qryInternal2 do
   begin
    if code = 'I' then
     begin
      Close;
      // Ajouter les exhibits de l'individu
      SQL.Text := 'SELECT X.no, X.X, X.T, X.D, X.F, X.A FROM X WHERE (X.A=''I'' AND X.N='
        + IntToStr(no) + ')' + ' ORDER BY X.T';
      Open;
      First;
      row := 1;
      Tableau.RowCount := RecordCount + 1;
      while not EOF do
       begin
        Tableau.Cells[0, row] := Fields[0].AsString;
        Tableau.Objects[0, row] := TObject(ptrint(Fields[0].AsInteger));

        if Fields[1].AsBoolean then
          Tableau.Cells[1, row] := '*'
        else
          Tableau.Cells[1, row] := '';

        titre := Fields[2].AsString;
        desc := Fields[3].AsString;
        if length(titre) = 0 then
          if length(desc) = 0 then
            Tableau.Cells[2, row] := Translation.Items[63]
          else
            Tableau.Cells[2, row] := desc
        else
        if length(desc) = 0 then
          Tableau.Cells[2, row] := titre
        else
          Tableau.Cells[2, row] := titre + ', ' + desc;
        Tableau.Cells[3, row] := Fields[5].AsString;
        if length(Fields[4].AsString) = 0 then
          Tableau.Cells[4, row] := Translation.Items[34]
        else
          Tableau.Cells[4, row] := Translation.Items[64];
        Next;
        row := row + 1;
       end;
     end
    else
      Tableau.RowCount := 1;
    // Ajouter les exhibits des événements
    Close;
    sql.Clear;
    if code = 'I' then
      SQL.add(
        'SELECT X.no, X.X, X.T, X.D, X.F, X.A FROM (X JOIN E on X.N=E.no) JOIN W on W.E=E.no WHERE (X.A=''E'' AND W.I='
        + IntToStr(no) + ')' + ' ORDER BY X.T');
    if code = 'E' then
      SQL.add('SELECT X.no, X.X, X.T, X.D, X.F, X.A FROM X WHERE X.A=''E'' AND X.N='
        + IntToStr(no) + ' ORDER BY X.T');
    if code = 'S' then
      SQL.add('SELECT X.no, X.X, X.T, X.D, X.F, X.A FROM X WHERE X.A=''S'' AND X.N='
        + IntToStr(no) + ' ORDER BY X.T');
    Open;
    First;
    Tableau.RowCount := Tableau.RowCount + RecordCount;
    while not EOF do
     begin
      Tableau.Cells[0, row] := Fields[0].AsString;
      Tableau.Cells[1, row] := '';
      titre := Fields[2].AsString;
      desc := Fields[3].AsString;
      if length(titre) = 0 then
        if length(desc) = 0 then
          Tableau.Cells[2, row] := Translation.Items[63]
        else
          Tableau.Cells[2, row] := desc
      else
      if length(desc) = 0 then
        Tableau.Cells[2, row] := titre
      else
        Tableau.Cells[2, row] := titre + ', ' + desc;
      Tableau.Cells[3, row] := Fields[5].AsString;
      if length(Fields[4].AsString) = 0 then
        Tableau.Cells[4, row] := Translation.Items[34]
      else
        Tableau.Cells[4, row] := Translation.Items[64];
      Next;
      row := row + 1;
     end;
    Close;
   end;
end;

procedure TdmGenData.SelectDocumentData(const lidDocument: integer;
  out lPrefered: boolean; out lDocumentInfo, lDocType, lFileName,
  lDocumentDescription, lDocumentTitle: string);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text :=
      'SELECT X.no, X.X, X.T, X.D, X.F, X.Z, X.A FROM X WHERE (X.no=:idDocument)';
    ParamByName('idDocument').AsInteger := lidDocument;
    Open;
    First;
    lPrefered := Fields[1].AsBoolean;
    lDocumentTitle := Fields[2].AsString;
    lDocumentDescription := Fields[3].AsString;
    lFileName := Fields[4].AsString;
    lDocType := Fields[6].AsString;
    lDocumentInfo := Fields[5].AsString;
   end;
end;

function TdmGenData.GetDocumentFilename(no, IdInd: integer): string;

begin
  with qryInternal do
   begin
    Close;
    if no = 0 then
     begin
      SQL.Text := 'SELECT X.F FROM X WHERE X.A=''I'' AND X.X=1 AND X.N=:idInd';
      ParamByName('idInd').AsInteger := IdInd;
     end
    else
     begin
      SQL.Text := 'SELECT X.F FROM X WHERE X.no=:IdDocument';
      ParamByName('idDocument').AsInteger := no;
     end;
    Open;
    First;
    if not EOF then
      Result := Fields[0].AsString
    else
      Result := '';
    Close;
   end;
end;

procedure TdmGenData.DeleteDocument(const lidDocument: integer);
begin
  with Query1 do
   begin
    Close;
    SQL.Text := 'DELETE FROM X WHERE no=:idDocument';
    ParamByName('idDocument').AsInteger := lidDocument;
    ExecSQL;
   end;
end;

procedure TdmGenData.UpdateDocument_SRPrefered(const lidInd: longint;
  const lNewPref: boolean; const lidDocument: integer);
begin
  with Query1 do
    if not lNewPref then
     begin
      Close;
      SQL.Text := 'UPDATE X SET X=0 WHERE X.no=:idDocument';
      ParamByName('idDocument').AsInteger := lidDocument;
      ExecSQL;
     end
    else
     begin
      Close;
      SQL.Text := 'UPDATE X SET X=0 WHERE X.A=''I'' AND X.N=:idInd';
      ParamByName('idInd').AsInteger := lidInd;
      ExecSQL;
      SQL.Text := 'UPDATE X SET X=1 WHERE X.no=:idDocument';
      ParamByName('idDocument').AsInteger := lidDocument;
      ExecSQL;
     end;
end;

procedure TdmGenData.CopyDocumentbyType_ID(const aType: string;
  const aID, aNewID: integer);
begin
  // en: Copy Documents of Event
  with qryInternal do
   begin
    SQL.Text := 'SELECT X, T, D, F, Z FROM X WHERE A=:Type AND N=:idLink';
    ParamByName('Type').AsString := aType;
    ParamByName('idLink').AsInteger := aID;
    Open;
   end;
  while not qryInternal.EOF do
    with qryInternal2 do
     begin
      SQL.Text :=
        'INSERT IGNORE INTO X (X, T, D, F, Z, A, N) VALUES (:X, :T, :D, :F, :' +
        'Z, :LinkType, :idLink)';
      ParamByName('LinkType').AsString := aType;
      ParamByName('idLink').AsInteger := aNewID;
      ParamByName('X').AsString := qryInternal.Fields[0].AsString;
      ParamByName('T').AsString := qryInternal.Fields[1].AsString;
      ParamByName('D').AsString := qryInternal.Fields[2].AsString;
      ParamByName('F').AsString := qryInternal.Fields[3].AsString;
      ParamByName('Z').AsString := qryInternal.Fields[4].AsString;
      ExecSQL;
      Close;
      qryInternal.Next;
     end;
  qryInternal.Close;
end;

procedure TdmGenData.DeleteDocumentsbyType_ID(const aType: char; const aID: integer);
begin
  with Query1 do
   begin
    Close;
    SQL.Text := 'DELETE FROM X WHERE A=:Type AND N=:ID';
    ParamByName('Type').AsString := aType;
    ParamByName('ID').AsInteger := aID;
    ExecSQL;
   end;
end;

{$endregion ~Documents}
//Type - Methods
{$region Type}
procedure TdmGenData.GetTypeData(idType: integer; out TypeCat: string;
  out Phrase: string; out Title: string);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT Y.no, Y.T, Y.Y, Y.P FROM Y WHERE Y.no=:idType';
    ParamByName('idType').AsInteger := idType;
    Open;
    First;
    Title := Fields[1].AsString;
    Phrase := Fields[3].AsString;
    TypeCat := Fields[2].AsString;
    Close;
   end;
end;

procedure TdmGenData.InsertType(const idType: longint; const Title: string;
  const Phrase: string; const Roles: string; const TypeCat: string);
begin
  with qryInternal do
   begin
    SQL.Text :=
      'INSERT IGNORE INTO Y (no, Y, P, T, R) ' +
      'VALUES (:idType, :Type, :Phrase, :Title, :Fields)';
    ParamByName('idType').AsInteger := idType;
    ParamByName('Type').AsString := TypeCat;
    ParamByName('Phrase').AsString := Phrase;
    ParamByName('Title').AsString := Title;
    ParamByName('Fields').AsString := Roles;
    ExecSQL;
   end;
end;

procedure TdmGenData.GetTypeList(const aList: TStrings; aType: string;
  Append: boolean = False);
begin
  if not Append then
    aList.Clear;
  with qryInternal do
   begin
    SQL.Text := 'SELECT Y.no, Y.T, Y.P FROM Y WHERE Y.Y=:type and ln=:Lang';
    ParamByName('type').AsString := aType;
    ParamByName('Lang').AsString := uppercase(Translation.lnCode);
    Open;
    if EOF then
     begin
      Close;
      SQL.Text := 'SELECT Y.no, Y.T, Y.P FROM Y WHERE Y.Y=:type';
      ParamByName('type').AsString := aType;
      Open;
     end;
    First; // Todo: Fallback-Language
    while not EOF do
     begin
      aList.AddObject(Fields[1].AsString, TObject(NativeInt(Fields[0].AsInteger)));
      Next;
     end;
    Close;
   end;
end;

procedure TdmGenData.FillTableTypes(const ltblTypes: TStringGrid;
  OnUpdate: TNotifyEvent);
var
  i: integer;
begin
  with qryInternal2 do
   begin
    Close;
    SQL.Text := 'SELECT Y.no, Y.T, Y.Y, Y.P FROM Y ORDER BY Y.T';
    Open;
    First;
    ltblTypes.RowCount := RecordCount + 1;
    tag := -RecordCount - 1;
    if assigned(OnUpdate) then
      OnUpdate(qryInternal2);
    tag := 0;
    if assigned(OnUpdate) then
      OnUpdate(qryInternal2);
    i := 0;
    while not EOF do
     begin
      i := i + 1;
      ltblTypes.Cells[0, i] := Fields[0].AsString;
      ltblTypes.Cells[1, i] := Fields[0].AsString;
      ltblTypes.Cells[2, i] := Fields[1].AsString;
      ltblTypes.Cells[3, i] := Fields[2].AsString;
      ltblTypes.Cells[4, i] := Fields[3].AsString;
      // Aller chercher les utilisation
      Query2.SQL.Clear;
      if ltblTypes.Cells[3, i] = 'R' then
        Query2.SQL.add('SELECT COUNT(R.Y) FROM R WHERE R.Y=' +
          Fields[0].AsString)
      else
      if ltblTypes.Cells[3, i] = 'N' then
        Query2.SQL.add('SELECT COUNT(N.Y) FROM N WHERE N.Y=' +
          Fields[0].AsString)
      else
        Query2.SQL.add('SELECT COUNT(E.Y) FROM E WHERE E.Y=' +
          Fields[0].AsString);
      Query2.Open;
      Query2.First;
      ltblTypes.Cells[5, i] := Query2.Fields[0].AsString;
      tag := Tag + 1;
      if assigned(OnUpdate) then
        OnUpdate(qryInternal2);
      Next;
     end;
   end;
end;

procedure TdmGenData.DeleteType(const lidType: PtrInt);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'DELETE FROM Y WHERE no=:idtype';
    ParamByName('idType').AsInteger := lidType;
    ExecSQL;
   end;
end;

procedure TdmGenData.UpdateTableTypes(const ltblTypes: TStringGrid;
  const lidType: integer);
var
  lTblAktRow: integer;
begin
  with qryInternal2 do
   begin
    lTblAktRow := ltblTypes.Row;
    Close;
    SQL.Text := 'SELECT Y.no, Y.T, Y.Y, Y.P FROM Y WHERE Y.no=:idType';
    ParamByName('idType').AsInteger := lidType;
    ltblTypes.Cells[0, lTblAktRow];
    Open;
    First;
    ltblTypes.Cells[2, lTblAktRow] := Fields[1].AsString;
    ltblTypes.Cells[3, lTblAktRow] := Fields[2].AsString;
    ltblTypes.Cells[4, lTblAktRow] := Fields[3].AsString;
    Close;
    // Aller chercher les utilisation

    case ltblTypes.Cells[3, lTblAktRow][1] of
      'R': SQL.Text := 'SELECT COUNT(R.Y) FROM R WHERE R.Y=:idType';
      'N': SQL.Text := 'SELECT COUNT(N.Y) FROM N WHERE N.Y=:idType'
      else
        SQL.Text := 'SELECT COUNT(E.Y) FROM E WHERE E.Y=:idType';
     end;
    ParamByName('idType').AsInteger := lidType;
    Open;
    First;
    ltblTypes.Cells[5, lTblAktRow] := Fields[0].AsString;
    Close;
   end;
end;

procedure TdmGenData.GetTypeList(const aList: TStrings; aTypes: array of string);
var
  i: integer;
begin
  aList.Clear;
  for i := 0 to high(aTypes) do
    GetTypeList(aList, aTypes[i], True);
end;


function TdmGenData.GetTypeName(const idType: longint): string;

begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT T FROM Y WHERE no=:idType and ln=:Lang';
    ParamByName('idType').AsInteger := idType;
    ParamByName('Lang').AsString := uppercase(Translation.lnCode);
    Open;
    if EOF then
     begin
      Close;
      SQL.Text := 'SELECT T FROM Y WHERE no=:idType';
      ParamByName('idType').AsInteger := idType;
      Open;
     end;
    Result := Fields[0].AsString;
    Close;
   end;
end;

function TdmGenData.GetTypePhrase(idType: integer): string;

begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT Y.no, Y.T, Y.P FROM Y WHERE Y.no=:idType and ln=:Lang';
    ParamByName('idType').AsInteger := idType;
    ParamByName('Lang').AsString := uppercase(Translation.lnCode);
    Open;
    if EOF then
     begin
      Close;
      SQL.Text := 'SELECT Y.no, Y.T, Y.P FROM Y WHERE Y.no=:idType';
      ParamByName('idType').AsInteger := idType;
      Open;
     end;
    First;
    Result := Fields[2].AsString;
    Close;
   end;
end;

procedure TdmGenData.SaveTypeData(lidType: integer; const lTitle: TCaption;
  const lPhrase: TCaption; const lTypeChar: string; const roles: string);
begin
  with qryInternal do
   begin
    Close;
    if lidType = 0 then
      SQL.Text := 'INSERT INTO Y (T, Y, P, R) VALUES (:Title, :Type, :Phrase, :Role)'
    else
     begin
      SQL.Text := 'UPDATE Y SET T=:Title, Y=:Type, P=:Phrase, R=:Role WHERE no=:idType';
      ParamByName('idType').AsInteger := lidType;
     end;
    ParamByName('Title').AsString := lTitle;
    ParamByName('Type').AsString := lTypeChar;
    ParamByName('Phrase').AsString := lPhrase;
    ParamByName('Role').AsString := Roles;
    ExecSQL;
   end;
end;

procedure TdmGenData.GetTypePhraseRole(const idType: integer;
  out Phrase: string; out Roles: string);
begin
  with qryInternal do
   begin
    SQL.Clear;
    SQL.Text := 'SELECT Y.P, Y.R FROM Y WHERE Y.no=:idType';
    ParamByName('idType').AsInteger := idType;
    Open;
    First;
    Phrase := Fields[0].AsString;
    Roles := Fields[1].AsString;
    Close;
   end;
end;

{$endregion ~Type}
{$region Source}
procedure TdmGenData.InsertSource(const lidSource: longint;
  const lQuality: longint; const lLink: string; const lNote: string;
  const lDescription: string; const lTitle: string);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'INSERT IGNORE INTO S (no, T, M, D, A, Q) ' +
      'VALUES (:idSource, :Title, :Note, :Descr, :A, :Quality);';
    ParamByName('idSource').AsInteger := lidSource;
    ParamByName('Title').AsString := lTitle;
    ParamByName('Note').AsString := lNote;
    ParamByName('Descr').AsString := lDescription;
    ParamByName('A').AsString := lLink;
    ParamByName('Quality').AsInteger := lQuality;
    ExecSQL;
   end;
end;

function TdmGenData.CheckIndSourceExist(idInd: integer): boolean;

begin
  // Vérifier qu'il n'y a pas de source
  // en: Check that there is no source
  with qryInternal do
   begin
    SQL.Text := 'SELECT S.no FROM S WHERE S.A=:idInd';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    Result := not EOF;
    Close;
   end;
end;

function TdmGenData.SaveSourceData(const pidSource: integer;
  const piQuality: integer; const psTitle: string; const psDescription: string;
  const psInformation: string; const psAuthor: string): integer;

begin
  if pidSource = 0 then
    with qryInternal do
     begin
      Close;
      sql.Text := 'INSERT INTO S (T, D, M, A, Q) VALUES ' +
        '(:Title, :Descr, :Info, :Author, :Quality)';
      ParamByName('Title').AsString := psTitle;
      ParamByName('Descr').AsString := psDescription;
      ParamByName('Info').AsString := psInformation;
      ParamByName('Author').AsString := psAuthor;
      ParamByName('Quality').AsInteger := piQuality;
      ExecSQL;
      Result := GetLastIDOfTable('S');
     end
  else
    with qryInternal do
     begin
      Close;
      SQL.Text :=
        'UPDATE S SET T=:Title, D=:Descr, M=:Info, A=:Author, Q=:Quality  WHERE no=:idSource';
      ParamByName('Title').AsString := psTitle;
      ParamByName('Descr').AsString := psDescription;
      ParamByName('Info').AsString := psInformation;
      ParamByName('Author').AsString := psAuthor;
      ParamByName('Quality').AsInteger := piQuality;
      ParamByName('idSource').AsInteger := pidSource;
      ExecSQL;
      Result := pidSource;

     end;
end;

procedure TdmGenData.FillSourcesSL(const LStr: TStrings);
var
  sourcenumber: string;

begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT S.no, S.T FROM S ORDER BY S.no';
    Open;
    First;
    Lstr.Clear;
    //   i:=trunc(log10(qryInternal.RecordCount+1))+1;
    while not EOF do
     begin
      sourcenumber := Fields[0].AsString;
      //while length(sourcenumber)<i do sourcenumber:='0'+sourcenumber;
      LStr.AddObject(sourcenumber + #9'- ' + Fields[1].AsString,
        TObject(PtrInt(Fields[0].AsInteger)));
      Next;
     end;
    Close;
   end;
end;

function TdmGenData.GetSourceCitCount(const lidSource: integer): integer;
var
  lSourceCitCount: longint;
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT COUNT(C.S) FROM S LEFT JOIN C on C.S=S.no WHERE S.no=:idSource';
    ParamByName('idSource').AsInteger := lidSource;
    Open;
    lSourceCitCount := Fields[0].AsInteger;
    Result := lSourceCitCount;
   end;
end;

function TdmGenData.GetSourceQuality(const lidSource: integer): longint;
var
  lQuality: longint;
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT S.Q FROM S WHERE S.no=:idSource';
    ParamByName('idSource').AsInteger := lidSource;
    Open;
    First;
    lQuality := Fields[0].AsInteger;
    Result := lQuality;
    Close;
   end;
end;

procedure TdmGenData.DeleteSourceFull(const lidSource: integer);
begin
  with qryInternal do
   begin
    Close;
    // Supprimer tous les exhibits et association dépots de cette source
    SQL.Text := 'DELETE FROM X WHERE A=:Type AND N=:idSource';
    ParamByName('Type').AsString := 'S';
    ParamByName('idSource').AsInteger := lidSource;
    ExecSQL;
    SQL.Text := 'DELETE FROM A WHERE S=:idSource';
    ParamByName('idSource').AsInteger := lidSource;
    ExecSQL;
    SQL.Text := 'DELETE FROM S WHERE no=:idSource';
    ParamByName('idSource').AsInteger := lidSource;
    ExecSQL;
   end;
end;

procedure TdmGenData.FillSourcesTable(const lNotification: TNotifyEvent;
  const lTable: TStringGrid);
var
  temp: string;
  i: integer;
  lidIndSrc: longint;
begin
  with qryInternal2 do
   begin
    Close;
    // SQL.add('SELECT S.no, S.T, S.D, S.M, S.A, S.Q, COUNT(C.S) FROM S LEFT JOIN C on C.S=S.no GROUP by S.no');
    SQL.Text := 'SELECT S.no, S.T, S.D, S.M, S.A, S.Q FROM S ORDER BY S.no';
    Open;
    First;
    lTable.RowCount := RecordCount + 1;
    Tag := -lTable.RowCount;
    if assigned(lNotification) then
      lNotification(qryInternal2);
    i := 0;
    while not EOF do
     begin
      i := i + 1;
      lTable.Cells[0, i] := IntToStr(i);
      lTable.Cells[1, i] := Fields[0].AsString;
      lTable.Objects[1, i] := TObject(ptrint(Fields[0].AsInteger));
      lTable.Cells[2, i] := Fields[1].AsString;
      lTable.Cells[3, i] := Fields[2].AsString;
      lTable.Cells[4, i] := Fields[3].AsString;
      temp := Fields[4].AsString;
      lTable.Cells[6, i] := Fields[5].AsString;
      lTable.Objects[6, i] := TObject(ptrint(Fields[5].AsInteger));
      //     lTable.Cells[7,i]:= Fields[6].AsString;
      lTable.Cells[7, i] := '?';
      if tryStrtoint(temp, lidIndSrc) then
       begin
        lTable.Cells[5, i] :=
          GetIndividuumName(lidIndSrc) + ' (' + temp + ')';
        lTable.Objects[5, i] := TObject(ptrint(lidIndSrc));
       end
      else
       begin
        lTable.Cells[5, i] := temp;
        lTable.Objects[5, i] := nil;
       end;
      Next;
      Tag := i;
      if assigned(lNotification) then
        lNotification(qryInternal2);
     end;
    Close;
   end;
end;

{$endregion ~Source}
{$region deposit}
function TdmGenData.CheckIndDepositExist(idInd: integer): boolean;

begin
  // Vérifier qu'il n'y a pas de dépot
  // en: Check that there is no deposit
  with qryInternal do
   begin
    SQL.Text := 'SELECT D.no FROM D WHERE D.I=:idInd';
    ParamByName('idInd').AsInteger := idInd;
    Open;
    Result := not EOF;
    Close;
   end;
end;

procedure TdmGenData.InsertDepot(const lMemo: variant; const lDescription: string;
  const lTitle: string; const lidIndividual: longint; const lidRepository: longint);
begin
  with qryInternal do
   begin
    Close;
    SQL.Text :=
      'INSERT IGNORE INTO D (no, T, M, D, I) VALUES (:idRepository, :Title, :Memo, :Description, :idInd)';
    ParamByName('idRepository').AsInteger := lidRepository;
    ParamByName('Title').AsString := lTitle;
    ParamByName('Memo').Value := lMemo;
    ParamByName('Description').AsString := lDescription;
    ParamByName('idInd').AsInteger := lidIndividual;
    ExecSQL;
   end;
end;

procedure TdmGenData.FillDepotsSL(const LStr: TStrings);
var
  sourcenumber: String;
begin
  with qryInternal do
   begin
    Close;
    SQL.Text := 'SELECT no, T FROM D ORDER BY no';
    Open;
    First;
    Lstr.Clear;
    while not EOF do
     begin
      sourcenumber := Fields[0].AsString;
      LStr.AddObject(sourcenumber + #9'- ' + Fields[1].AsString,
        TObject(PtrInt(Fields[0].AsInteger)));
      Next;
     end;
    Close;
   end;
end;

procedure TdmGenData.InsertDepotOfSource(const lidSource: longint;
  const lidRepository: longint; const buffer: string);
begin
  with Query1 do
   begin
    Close;
    SQL.Text :=
      'INSERT IGNORE INTO A (S, D, M) VALUES (:idSource, :idDepot, :Note)';
    ParamByName('idSource').AsInteger := lidSource;
    ParamByName('idDepot').AsInteger := lidRepository;
    ParamByName('Note').AsString := buffer;
    ExecSQL;
   end;
end;

{$endregion ~deposit}
{$region Places}
procedure TdmGenData.InsertPlace(lidPlace: longint; const Place: string);
begin
  with Query1 do
   begin
    Close;
    SQL.Text :=
      'INSERT IGNORE INTO L (no, L) VALUES (:idPlace, :Place)';
    ParamByName('idPlace').AsInteger := lidPlace;
    ParamByName('Place').AsString := Place;
    ExecSQL;
   end;
end;

function TdmGenData.GetPlaceName(const liResult: integer): string;
var
  temp: string;
begin
  with qryInternal do
   begin
    SQL.Text := 'SELECT L FROM L WHERE no=:idPlace';
    ParamByName('idplace').AsInteger := liResult;
    Open;
    temp := Fields[0].AsString;
    Result := temp;
   end;
end;

{$endregion ~Places}

function TdmGenData.CountAllRecordsTMG(const filename: string): longint;
var
  lMaxRecords: longint;
  I: integer;
const
  TableS = '$EFGIMNPRSWT';
begin
  lMaxRecords := 0;
  for I := 1 to length(TableS) do
    with TMG do
     begin
      Tablename := filename + TableS[i] + '.DBF';
      Active := True;
      Open;
      lMaxRecords := lMaxRecords + RecordCount;
      Active := False;
     end;
  Result := lMaxRecords;
end;


function TdmGenData.GetLastIDOfTable(TableName: string): longint;

begin
  with qrySysInfo do
   begin
    SQL.Text := 'SHOW TABLE STATUS WHERE NAME=:TableName';
    ParamByName('TableName').AsString := TableName;
    Open;
    First;
    Result := Fields[10].AsInteger - 1;
    Close;
   end;
end;

procedure TdmGenData.GetDBSchemas(const aList: TStrings);

begin
  with qrySysInfo do
   begin
    aList.Clear;
    SQL.Text := 'SHOW DATABASES';
    Open;
    First;
    while not EOF do
     begin
      aList.add(Fields[0].AsString);
      Next;
     end;
    Close;
   end;
end;

initialization

end.
