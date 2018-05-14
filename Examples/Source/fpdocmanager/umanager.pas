unit uManager;
(* Manager object for FPDoc GUI, by DoDi
Holds configuration and packages.

Packages (shall) contain extended descriptions for:
- default OSTarget (FPCDocs: Unix/Linux)
- inputs: by OSTarget
- directories: project(file), InputDir, DescrDir[by language?]
- FPCVersion, LazVersion: variations of inputs
- Skeleton and Output options, depending on DocType/Level and Format.
Units can be described in multiple XML docs, so that it's possible to
have specific parts depending on Laz/FPC version, OSTarget, Language, Widgetset.

This version is decoupled from the fpdoc classes, introduces the classes
  TFPDocManager for all packages
  TDocPackage for a single package
  TFPDocHelper for fpdoc projects
*)

(* Currently registered writers:
TFPDocWriter in 'dwriter.pp'
  template: TTemplateWriter(TFPDocWriter) in 'dw_tmpl.pp'
  man:  TMANWriter(TFPDocWriter) in 'dw_man.pp' --> <pkg>.man /unit.
  dxml:  TDXMLWriter(TFPDocWriter) in 'dw_dxml.pp'
  xml:  TXMLWriter(TFPDocWriter) in 'dw_xml.pp'
  html: THTMLWriter(TFPDocWriter) in 'dw_html.pp'
    htm:  THTMWriter(THTMLWriter)
    chm:  TCHMHTMLWriter(THTMLWriter)
  TLinearWriter in 'dwlinear.pp'
    template: TTemplateWriter(TLinearWriter) in 'dw_lintmpl.pp'
    ipf:  TIPFNewWriter(TLinearWriter) in 'dw_ipflin.pas'
    latex:  TLaTeXWriter(TLinearWriter) in 'dw_latex.pp'
    rtf:  TRTFWriter(TLinearWriter) in 'dw_linrtf.pp'
    txt:  TTXTWriter(TLinearWriter) in 'dw_txt.pp'

TLinearWriter based writers create an single output file for a package:
  <path>/pkg .<ext>
TFPDocWriter based writers create an file for every module:
  <path>/pkg /unit.<ext>

*)
{$mode objfpc}{$H+}

{$DEFINE EasyImports} //EasyImports.patch applied?

interface

uses
  Classes, SysUtils,
  umakeskel, ConfigFile, fpdocproj, dw_HTML;

type
  TFPDocHelper = class;

  { TDocPackage }

(* TDocPackage describes a package documentation project.
*)
  TDocPackage = class
  private
    FAllDirs: boolean;
    FAltDir: string;
    FCompOpts: string;
    FDescrDir: string;
    FDescriptions: TStrings;
    FIncludePath: string;
    FInputDir: string;
    FLazPkg: string;
    FLoaded: boolean;
    FName: string;
    FProjectDir: string;
    FProjectFile: string;
    FSrcDirs: TStrings;
    FRequires: TStrings;
    FUnitPath: string;
    FUnits: TStrings;
    function GetAltDir: string;
    procedure SetAllDirs(AValue: boolean);
    procedure SetAltDir(AValue: string);
    procedure SetCompOpts(AValue: string);
    procedure SetDescrDir(AValue: string);
    procedure SetDescriptions(AValue: TStrings);
    procedure SetIncludePath(AValue: string);
    procedure SetInputDir(AValue: string);
    procedure SetLazPkg(AValue: string);
    procedure SetLoaded(AValue: boolean);
    procedure SetName(AValue: string);
    procedure SetProjectDir(AValue: string);
    procedure SetProjectFile(AValue: string);
    procedure SetRequires(AValue: TStrings);
    procedure SetUnitPath(AValue: string);
    procedure SetUnits(AValue: TStrings);
  protected
    Config: TConfigFile;
    procedure ReadConfig; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function  IniFileName: string;
    function  CreateProject(APrj: TFPDocHelper; const AFile: string): boolean; virtual; //new package project
    function  ImportProject(APrj: TFPDocHelper; APkg: TFPDocPackage; const AFile: string): boolean;
    procedure UpdateConfig;
    procedure EnumUnits(AList: TStrings); virtual;
    function  DescrFileName(const AUnit: string): string;
    property Name: string read FName write SetName;
    property Loaded: boolean read FLoaded write SetLoaded;
    property ProjectFile: string read FProjectFile write SetProjectFile; //xml?
  //from LazPkg
    procedure AddUnit(const AFile: string);
    property AllDirs: boolean read FAllDirs write SetAllDirs;
    property CompOpts: string read FCompOpts write SetCompOpts;
    property LazPkg: string read FLazPkg write SetLazPkg; //LPK name?
    property ProjectDir: string read FProjectDir write SetProjectDir;
    property DescrDir: string read FDescrDir write SetDescrDir;
    property Descriptions: TStrings read FDescriptions write SetDescriptions;
    property AltDir: string read GetAltDir write SetAltDir;
    property InputDir: string read FInputDir write SetInputDir;
    property SrcDirs: TStrings read FSrcDirs;
    property Units: TStrings read FUnits write SetUnits;
    property Requires: TStrings read FRequires write SetRequires; //only string?
    property IncludePath: string read FIncludePath write SetIncludePath; //-Fi
    property UnitPath: string read FUnitPath write SetUnitPath; //-Fu
  end;

  { TFCLDocPackage }

  TFCLDocPackage = class(TDocPackage)
  protected
    procedure ReadConfig; override;
  public
    function  CreateProject(APrj: TFPDocHelper; const AFile: string): boolean; override;
  end;

  { TFPDocHelper }

//holds temporary project

  TFPDocHelper = class(TFPDocMaker)
  private
    FProjectDir: string;
    procedure SetProjectDir(AValue: string);
  public
    InputList, DescrList: TStringList; //still required?
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function  BeginTest(APkg: TDocPackage): boolean;
    function  BeginTest(ADir: string): boolean;
    procedure EndTest;
    function  CmdToPrj(const AFileName: string): boolean;
    function  TestRun(APkg: TDocPackage; AUnit: string): boolean;
    function  Update(APkg: TDocPackage; const AUnit: string): boolean;
    function  MakeDocs(APkg: TDocPackage; const AUnit: string; AOutput: string): boolean;
    property ProjectDir: string read FProjectDir write SetProjectDir;
  end;

  TLogHandler = Procedure (Sender : TObject; Const Msg : String) of object;

  { TFPDocManager }

(* Holds configuration and package projects.
*)
  TFPDocManager = class(TComponent)
  private
    FExcludedUnits: boolean;
    FFpcDir: string;
    FFPDocDir: string;
    FLazarusDir: string;
    FModified: boolean;
    FNoParseUnits: TStringList;
    FOnChange: TNotifyEvent;
    FOnLog: TLogHandler;
    FOptions: TCmdOptions;
    FPackage: TDocPackage;
    FPackages: TStrings;
    FProfile: string;
    FProfiles: string; //CSV list of profile names
    FRootDir: string;
    UpdateCount: integer;
    function  GetNoParseUnits: TStrings;
    procedure SetExcludedUnits(AValue: boolean);
    procedure SetFpcDir(AValue: string);
    procedure SetFPDocDir(AValue: string);
    procedure SetLazarusDir(AValue: string);
    procedure SetNoParseUnits(AValue: TStrings);
    procedure SetOnChange(AValue: TNotifyEvent);
    procedure SetPackage(AValue: TDocPackage);
    procedure SetProfile(AValue: string);
    procedure SetRootDir(AValue: string);
  protected
    Helper: TFPDocHelper; //temporary
    procedure Changed;
    function  BeginTest(const ADir: string): boolean;
    procedure EndTest;
    function  RegisterPackage(APkg: TDocPackage): integer;
    Procedure DoLog(Const Msg : String);
  public
    Config: TConfigFile; //extend class
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    function  LoadConfig(const ADir: string; Force: boolean = False): boolean;
    function  SaveConfig: boolean;
    procedure AddProfile(const AName: string);
    function  AddProject(const APkg, AFile: string): boolean; //from config
    function  CreateProject(const AFileName: string; APkg: TDocPackage): boolean;
    function  AddPackage(AName: string): TDocPackage;
    function  IsExtended(const APkg: string): string;
    function  ImportLpk(const AFile: string): TDocPackage;
    procedure ImportProject(APkg: TFPDocPackage; const AFile: string);
    function  ImportCmd(const AFile: string): boolean;
    procedure UpdatePackage(const AName: string);
    function  UpdateFCL(enabled: boolean): boolean;
  //actions
    function  MakeDoc(APkg: TDocPackage; const AUnit, AOutput: string): boolean;
    function  TestRun(APkg: TDocPackage; AUnit: string): boolean;
    function  Update(APkg: TDocPackage; const AUnit: string): boolean;
  public //published?
    property ExcludeUnits: boolean read FExcludedUnits write SetExcludedUnits;
    property NoParseUnits: TStrings read GetNoParseUnits write SetNoParseUnits;
    property FpcDir: string read FFpcDir write SetFpcDir;
    property FpcDocDir: string read FFPDocDir write SetFPDocDir;
    property LazarusDir: string read FLazarusDir write SetLazarusDir;
    property RootDir: string read FRootDir write SetRootDir;
    property Options: TCmdOptions read FOptions;
    property Profile: string read FProfile write SetProfile;
    property Profiles: string read FProfiles;
    property Packages: TStrings read FPackages;
    property Package: TDocPackage read FPackage write SetPackage;
    property Modified: boolean read FModified; //app
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    Property OnLog : TLogHandler Read FOnLog Write FOnLog;
  end;

var
  Manager: TFPDocManager = nil; //init by application

function  FixPath(const s: string): string;
procedure ListDirs(const ARoot: string; AList: TStrings);
procedure ListUnits(const AMask: string; AList: TStrings);
function  MatchUnits(const ADir: string; AList: TStrings): integer;

implementation

uses
  uLpk, PParser;

const
  ConfigName = 'docmgr.ini';
  SecProjects = 'projects';
  SecGen = 'dirs';
  SecDoc = 'project';

function FixPath(const s: string): string;
var
  c: string;
begin
  if DirectorySeparator = '/' then
    c := '\'
  else
    c := '/';
  Result := StringReplace(s, c, DirectorySeparator, [rfReplaceAll]);
end;

procedure ListDirs(const ARoot: string; AList: TStrings);
var
  Info : TSearchRec;
  s: string;
begin
  if FindFirst (ARoot+'/*',faDirectory,Info)=0 then begin
    repeat
      if not ((Info.Attr and faDirectory) = faDirectory) then
        continue;
      s := Info.Name;
      if (s[1] <> '.')
      and (AList.IndexOf(s) < 0) then //exclude dupes
        AList.Add(s); //name only, allow to create relative refs
    until FindNext(info)<>0;
  end;
  FindClose(Info);
end;

procedure ListUnits(const AMask: string; AList: TStrings);
var
  Info : TSearchRec;
  s, f: string;
begin
  if FindFirst (AMask,faArchive,Info)=0 then begin
    repeat
      s := Info.Name;
      if s[1] <> '.' then begin
        f := ChangeFileExt(s, ''); //unit name only
        if Manager.ExcludeUnits and (Manager.NoParseUnits.IndexOf(f) >= 0) then
          continue; //excluded unit!
        AList.Add(f);
      end;
    until FindNext(info)<>0;
  end;
  FindClose(Info);
end;

function MatchUnits(const ADir: string; AList: TStrings): integer;
var
  Info : TSearchRec;
  s, ext: string;
begin
  Result := -1;
  if FindFirst(ADir+DirectorySeparator+'*',faArchive,Info)=0 then begin
    repeat
      s := Info.Name;
      ext := ExtractFileExt(s);
      if (ext = '.pas') or (ext = '.pp') then begin
        ext := ChangeFileExt(s, '');
        Result := AList.IndexOf(ext); //ChangeFileExt(s, '.xml'));
        if Result >= 0 then begin
          //AList.Delete(Result); //don't search any more
          break;
        end;
      end;
    Until FindNext(info)<>0;
  end;
  FindClose(Info);
end;

{ TFCLDocPackage }

procedure TFCLDocPackage.ReadConfig;
begin
  inherited ReadConfig;
  if FSrcDirs = nil then
    FSrcDirs := TStringList.Create;
  Config.ReadSection('SrcDirs', FSrcDirs);
end;

function TFCLDocPackage.CreateProject(APrj: TFPDocHelper; const AFile: string
  ): boolean;
var
  i: integer;
  s, d, f: string;
  dirs, descs: TStringList;
  incl, excl: boolean;
begin
(* Add Lazarus FCL, and explicit or added or all FCL dirs
*)
  if APrj.Package <> nil then
    exit(True); //already configured
  Result:=inherited CreateProject(APrj, AFile);
  descs := TStringList.Create;
//add lazdir
  if AltDir <> '' then begin
  (* Add inputs for all descrs found in AltDir.
    For *MakeSkel* add all units in the selected(!) fcl packages to inputs.
    How to distinguish both modes?
  *)
    s := Manager.LazarusDir + 'docs' + DirectorySeparator + 'xml' + DirectorySeparator + 'fcl';
    //APrj.ParseFPDocOption(Format('--descr-dir="%s"', [s])); //todo: add includes
    //APrj.AddDirToFileList(descs, s, '*.xml');
    ListUnits(s+ DirectorySeparator+ '*.xml', descs); //exclude NoParseUnits
    descs.Sorted := True;
  end;
//scan fcl dirs
  dirs := TStringList.Create; //use prepared list?
  s := Manager.FFpcDir + 'packages' + DirectorySeparator;
  ListDirs(s, dirs);
//now match all files in the source dirs
  for i := dirs.Count - 1 downto 0 do begin
    d := s + dirs[i] + DirectorySeparator + 'src';
    if not DirectoryExists(d) then continue; //can this happen?
  (* skip explicitly excluded packages, and exclude selected units.
  *)
    excl := not FAllDirs
      and assigned(FSrcDirs)
      and (SrcDirs.IndexOfName(dirs[i]) >= 0)
      and (SrcDirs.Values[dirs[i]] <= '0');
    if excl then begin
      //Manager.DoLog('Skipping directory ' + dirs[i]);
    end else begin
      incl := FAllDirs
      or (assigned(FSrcDirs)
        and (SrcDirs.IndexOfName(dirs[i]) >= 0)
        and (SrcDirs.Values[dirs[i]] > '0'))
      or (MatchUnits(d, descs) >= 0); //!!! descs now is empty!
      if incl then begin
      //add dir
        Manager.DoLog('Adding directory ' + dirs[i]);
        APrj.ParseFPDocOption(Format('--input-dir="%s"', [d])); //todo: add includes?
      end;
    end;
  end;
//exclude explicit units - only for FCL?
  if Manager.ExcludeUnits and (Manager.NoParseUnits.Count > 0) then begin
  //exclude inputs
    for i := APrj.InputList.Count - 1 downto 0 do begin
      s := ExtractUnitName(APrj.InputList, i);
      if Manager.NoParseUnits.IndexOf(s) >= 0 then //case?
        APrj.InputList.Delete(i);
    end;
  end;
//re-create project? The normal project was already created by inherited!
  if AFile <> '' then begin
    f := ChangeFileExt(AFile, '_ext.xml'); //preserve unmodified project?
    APrj.CreateProjectFile(f);
  end; // else APrj.CreateProjectFile(Manager.RootDir + 'fcl_ext.xml'); //preserve unmodified project?
//finally
  dirs.Free;
  descs.Free;
end;

{ TDocPackage }

procedure TDocPackage.SetDescrDir(AValue: string);
begin
  if FDescrDir=AValue then Exit;
  FDescrDir:=AValue;
end;

procedure TDocPackage.SetCompOpts(AValue: string);
begin
(* collect all compiler options
*)
  if FCompOpts=AValue then Exit;
  if AValue = '' then exit;
  if FCompOpts = '' then
    FCompOpts:=AValue
  else
    FCompOpts:= FCompOpts + ' ' + AValue;
end;

procedure TDocPackage.SetAltDir(AValue: string);
begin
  AValue:=FixPath(AValue);
  if FAltDir=AValue then Exit;
  FAltDir:=AValue;
//we must signal config updated
  Config.WriteString(SecDoc, 'AltDir', AltDir);
end;

procedure TDocPackage.SetAllDirs(AValue: boolean);
begin
  if FAllDirs=AValue then Exit;
  FAllDirs:=AValue;
end;

function TDocPackage.GetAltDir: string;
begin
{$IFDEF FCLadds}
  Result := FAltDir;
{$ELSE}
  Result := '';
{$ENDIF}
end;

procedure TDocPackage.SetDescriptions(AValue: TStrings);
(* Shall we allow for multiple descriptions? (general + OS specific!?)
*)
begin
  if FDescriptions=AValue then Exit;
  if AValue = nil then exit; //clear?
  if AValue.Count = 0 then exit;
  FDescriptions.Assign(AValue);
end;

(* Requires[] only contain package names.
  Internal use: Get/Set CommaText
*)
procedure TDocPackage.SetRequires(AValue: TStrings);

  procedure Import;
  var
    i: integer;
    s: string;
  begin
    FRequires.Clear; //assume full replace
    for i := 0 to AValue.Count - 1 do begin
      s := AValue[i]; //<name.xct>,<prefix>
      FRequires.Add(ExtractImportName(s));  // + '=' + s);
    end;
  end;

begin
  if FRequires=AValue then Exit;
  if AValue = nil then exit;
  if AValue.Count = 0 then exit;
  Import;
end;

procedure TDocPackage.SetUnits(AValue: TStrings);

  procedure Import;
  var
    i: integer;
    s: string;
  begin
    FUnits.Clear; //assume full replace
    for i := 0 to AValue.Count - 1 do begin
      s := AValue[i]; //filespec
      FUnits.Add(ExtractUnitName(AValue, i) + '=' + s);
    end;
  end;

begin
  if FUnits=AValue then Exit;
  if AValue = nil then exit;
  if AValue.Count = 0 then exit;
//import formatted: <unit>=<descr file> (multiple???)
  if Pos('=', AValue[0]) > 0 then
    FUnits.Assign(AValue) //clears previous content
  else //if AValue.Count > 0 then
    Import;
end;

procedure TDocPackage.SetIncludePath(AValue: string);
begin
  if FIncludePath=AValue then Exit;
  FIncludePath:=AValue;
end;

procedure TDocPackage.SetInputDir(AValue: string);
begin
  if FInputDir=AValue then Exit;
  FInputDir:=AValue;
end;

procedure TDocPackage.SetLazPkg(AValue: string);
begin
  if FLazPkg=AValue then Exit;
  if AValue = '' then exit;
  FLazPkg:=AValue;
  FProjectDir := ExtractFilePath(AValue);
  //todo: import
end;

procedure TDocPackage.SetLoaded(AValue: boolean);
begin
  if FLoaded=AValue then Exit;
  FLoaded:=AValue;
  if not FLoaded then
    exit; //???
  if Manager.RegisterPackage(self) < 0 then //now definitely loaded
    exit; //really exit?
  if Config = nil then
    UpdateConfig; //create INI file when loaded
end;

procedure TDocPackage.SetName(AValue: string);
begin
  if FName=AValue then Exit;
  FName:=AValue;
  ReadConfig;
end;

procedure TDocPackage.SetProjectDir(AValue: string);
begin
  if FProjectDir=AValue then Exit;
  FProjectDir:=AValue;
end;

procedure TDocPackage.SetProjectFile(AValue: string);
begin
  if FProjectFile=AValue then Exit;
  FProjectFile:=AValue;
//really do more?
  if FProjectFile = '' then
    exit;
  ProjectDir:=ExtractFilePath(FProjectFile);
  if ExtractFileExt(FProjectFile) <> '.xml' then
    ; //really change here???
  //import requires fpdocproject - must be created by Manager!
end;

procedure TDocPackage.SetUnitPath(AValue: string);
begin
  if FUnitPath=AValue then Exit;
  FUnitPath:=AValue;
//save to config?
end;

constructor TDocPackage.Create;
begin
  FUnits := TStringList.Create;
  FDescriptions := TStringList.Create;
  FRequires := TStringList.Create;
  //Config requires valid Name -> in SetName
end;

destructor TDocPackage.Destroy;
begin
  FreeAndNil(Config);
  FreeAndNil(FUnits);
  FreeAndNil(FDescriptions);
  FreeAndNil(FRequires);
  FreeAndNil(FSrcDirs);
  inherited Destroy;
end;

(* Create new(?) project.
Usage: after LoadLpk, in general for configured project (user options!)
(more options to come)
*)
function TDocPackage.CreateProject(APrj: TFPDocHelper; const AFile: string): boolean;
var
  s, imp: string;
  pkg: TFPDocPackage;
  i: integer;
  lst: TStringList;
begin
  Result := APrj.Package <> nil; //already configured?
  if Result then
    exit;
  Result := ProjectDir <> '';
  if not Result then
    exit; //dir must be known
//create pkg
  APrj.ParseFPDocOption('--package=' + Name); //selects or creates the pkg
  pkg := APrj.SelectedPackage;
//add Inputs
  //todo: common options? OS options?
  for i := 0 to Units.Count - 1 do begin
    s := Units.ValueFromIndex[i];
    if CompOpts <> '' then
      s := s + ' ' + CompOpts;
    //add further options?
    pkg.Inputs.Add(s);
  end;
//add Descriptions - either explicit or implicit
  if (DescrDir <> '') and (Descriptions.Count = 0) then begin
  //first check for existing directory
    if not DirectoryExists(DescrDir) then begin
      MkDir(DescrDir); //exclude \?
    end else if Descriptions.Count = 0 then begin
      APrj.ParseFPDocOption('--descr-dir=' + DescrDir); //adds all XML files
    end;
  end else begin
    APrj.DescrDir := DescrDir; //needed by Update
    for i := 0 to Descriptions.Count - 1 do begin
      s := Descriptions[i];
      if Pos('=', s) > 0 then
        pkg.Descriptions.Add(Descriptions.ValueFromIndex[i])
      else
        pkg.Descriptions.Add(s);
    end;
  end;
  if AltDir <> '' then begin
  //add descr files
    s := Manager.LazarusDir + AltDir;
    s := FixPath(s);
    if ForceDirectories(s) then begin
    //exclude NoParse units
      //APrj.ParseFPDocOption(Format('--descr-dir="%s"', [s]));
      lst := TStringList.Create;
      ListUnits(AltDir + '*.xml', lst); //unit names only
    (* add the unit names from lst to the pkg/project
    *)
      pkg := APrj.SelectedPackage;
      for i := 0 to lst.Count - 1 do begin
        s := AltDir + lst[i] + '.xml';
        pkg.Descriptions.Add(s);
      end;
    end;
  //add source files!?
  end;
//add Imports
  for i := 0 to Requires.Count - 1 do begin
    s := Requires[i];
  {$IFDEF EasyImports}
    imp := Manager.RootDir + s;
  {$ELSE}
    imp := Manager.RootDir + s + '.xct,../' + s + '/'; //valid for HTML, not for CHM!
  {$ENDIF}
    APrj.ParseFPDocOption('--import=' + imp);
  end;
//add options
  APrj.Options.Assign(Manager.Options);
//debug, looks good here!?
  if APrj.Options.Backend = '' then
    Manager.DoLog('No format, should be ' + Manager.Options.Backend);
  pkg.Output := Manager.RootDir + Name; //???
  pkg.ContentFile := Manager.RootDir + Name + '.xct';
//now create project file
  if AFile <> '' then begin
    if ExtractFileExt(AFile) <> '.xml' then
      FProjectFile := ExtractFilePath(AFile) + Name + '_prj.xml'
    else
      FProjectFile := AFile;
    APrj.CreateProjectFile(ProjectFile);
  end;
  Result := True; //assume okay
end;

(* Init from TFPDocPackage, into which AFile has been loaded.
*)
function TDocPackage.ImportProject(APrj: TFPDocHelper; APkg: TFPDocPackage; const AFile: string): boolean;
var
  s: string;
begin
//check loaded
  Result := Loaded;
  if Result then
    exit;
//init...
  s := UnitFile(APkg.Inputs, 0);
  if s <> '' then
    FUnitPath := ExtractFilePath(s);
  s := UnitFile(APkg.Descriptions, 0);
  if s <> '' then
    FDescrDir := ExtractFilePath(s);
//project file - empty if not applicable (multi-package project?!)
  if (AFile <> '') and (APrj.Packages.Count = 1) then
    ProjectFile := AFile //only if immediately applicable!
  else
    ProjectDir := ExtractFilePath(AFile);
//init lists
  Units := APkg.Inputs;
  Descriptions := APkg.Descriptions;
  Requires := APkg.Imports;
//more?
//save config!
  UpdateConfig;
//finish
  Result := Loaded;
end;

procedure TDocPackage.ReadConfig;
var
  s: string;
begin
  if Loaded then
    exit;
  if Config = nil then
    Config := TConfigFile.Create(IniFileName);
//check config
  s := Config.ReadString(SecDoc, 'projectdir', '');
  if s = '' then begin
    FreeAndNil(Config); //must create and fill later!
    exit; //project directory MUST be known
  end;
  ProjectFile := Config.ReadString(SecDoc, 'projectfile', '');
  FInputDir := Config.ReadString(SecDoc, 'inputdir', '');
  FCompOpts := Config.ReadString(SecDoc, 'options', '');
  FDescrDir := Config.ReadString(SecDoc, 'descrdir', '');
  FAltDir := Config.ReadString(SecDoc, 'AltDir', '');
  FAllDirs:= Config.ReadBool(SecDoc, 'AllDirs', False);
  Requires.CommaText := Config.ReadString(SecDoc, 'requires', '');
//units
  Config.ReadSection('units', Units);
  Config.ReadSection('descrs', Descriptions);
//more?
//all done
  Loaded := True;
end;

(* Initialize the package, write global config (+local?)
*)
procedure TDocPackage.UpdateConfig;
begin
//create ini file, if not already created
  if Config = nil then
    Config := TConfigFile.Create(IniFileName); //in document RootDir
//general information
  Config.WriteString(SecDoc, 'projectdir', ProjectDir);
  Config.WriteString(SecDoc, 'projectfile', ProjectFile);
  Config.WriteString(SecDoc, 'inputdir', InputDir);
  Config.WriteString(SecDoc, 'options', CompOpts);
  Config.WriteString(SecDoc, 'descrdir', DescrDir);
  Config.WriteString(SecDoc, 'AltDir', FAltDir);
  Config.WriteBool(SecDoc, 'AllDirs', AllDirs);
  Config.WriteString(SecDoc, 'requires', Requires.CommaText);
//units
  Config.WriteSectionValues('units', Units);
  Config.WriteSectionValues('descrs', Descriptions);
  Config.WriteSectionValues('SrcDirs', SrcDirs);
//all done
  Config.Flush;
  Loaded := True;
end;

procedure TDocPackage.EnumUnits(AList: TStrings);
var
  i: integer;
begin
//override to add further units (from AltDir...)
  for i := 0 to Units.Count - 1 do
    AList.Add(Units.Names[i]);
end;

function TDocPackage.DescrFileName(const AUnit: string): string;
begin
(* [ProjectDir +] DescrDir + AUnit + .xml
*)
  Result := DescrDir;
  if (Result = '') or (Result[1] = '.') then
    Result := ProjectDir + Result;
  Result := Result + DirectorySeparator + AUnit + '.xml';
end;

function TDocPackage.IniFileName: string;
begin
  Result := Manager.RootDir + Name + '.ini';
end;

procedure TDocPackage.AddUnit(const AFile: string);
var
  s: string;
begin
  s := ExtractUnitName(AFile);
  if s = '' then
    Manager.DoLog('No unit: ' + AFile)
  else
    Units.Add(s + '=' + AFile);
end;

{ TFPDocManager }

constructor TFPDocManager.Create(AOwner: TComponent);
var
  lst: TStringList;
begin
  inherited Create(AOwner);
  lst := TStringList.Create;
  lst.OwnsObjects := True;
  FPackages := lst;
  FOptions := TCmdOptions.Create;
  FNoParseUnits := TStringList.Create;
end;

destructor TFPDocManager.Destroy;
begin
  SaveConfig;
  FreeAndNil(Config);
  //FPackages.Clear; //destructor seems NOT to clear/destroy owned object!?
  FreeAndNil(FPackages);
  FreeAndNil(FOptions);
  FreeAndNil(FNoParseUnits);
  inherited Destroy;
end;

procedure TFPDocManager.SetFPDocDir(AValue: string);
begin
  if FFPDocDir=AValue then Exit;
  FFPDocDir:=AValue;
  Config.WriteString(SecGen, 'FpcDocDir', FpcDocDir);
end;

procedure TFPDocManager.SetFpcDir(AValue: string);
begin
  if FFpcDir=AValue then Exit;
  FFpcDir:=AValue;
  Config.WriteString(SecGen, 'FpcDir', FpcDir);
end;

procedure TFPDocManager.SetExcludedUnits(AValue: boolean);
begin
  if FExcludedUnits=AValue then Exit;
  FExcludedUnits:=AValue;
  Config.WriteBool(SecGen, 'ExcludeUnits', AValue);
end;

procedure TFPDocManager.UpdatePackage(const AName: string);
var
  pkg: TDocPackage;
  i: integer;
  s: string;
begin
  if LazarusDir = '' then exit;
  s := {LazarusDir +} 'docs/xml/'+AName;
  if not DirectoryExists(FixPath(LazarusDir + s)) then
    exit;
  i := Packages.IndexOfName(AName);
  if i < 0 then
    exit;
  pkg := Packages.Objects[i] as TDocPackage;
  pkg.AltDir := s; //add descriptors when configuring the project/helper
end;

function TFPDocManager.UpdateFCL(enabled: boolean): boolean;
var
  pkg: TFCLDocPackage;
begin
(* Adding to the FCL requires valid FPC and Lazarus directories (caller checks).
  Then laz/docs/xml/fcl/ is added to fpc descr-dirs.
  The related units have to be added as input-dirs.
  Scan fpc/packages/ for candidates.
*)
//todo: implement
  pkg := AddPackage('fcl') as TFCLDocPackage;
  if pkg = nil then
    exit(False);
  if enabled then
    pkg.AltDir := 'docs/xml/fcl'
  else
    pkg.AltDir := '';
  Result := True;
end;

procedure TFPDocManager.SetLazarusDir(AValue: string);
begin
  if FLazarusDir=AValue then Exit;
  FLazarusDir:=AValue;
  Config.WriteString(SecGen, 'LazarusDir', FLazarusDir);
//update RTL and FCL - if exist and Dir exists
  UpdatePackage('rtl');
  UpdatePackage('fcl');
end;

function TFPDocManager.GetNoParseUnits: TStrings;
begin
  Result := FNoParseUnits;
end;

procedure TFPDocManager.SetNoParseUnits(AValue: TStrings);
begin
  FNoParseUnits.Assign(AValue);
  FNoParseUnits.Sorted := True;
  Config.WriteSection('NoParseUnits', NoParseUnits);
end;

procedure TFPDocManager.SetOnChange(AValue: TNotifyEvent);
begin
  if FOnChange=AValue then Exit;
  FOnChange:=AValue;
end;

procedure TFPDocManager.SetPackage(AValue: TDocPackage);
begin
  if FPackage=AValue then Exit;
  FPackage:=AValue;
end;

procedure TFPDocManager.SetProfile(AValue: string);
begin
  if AValue = '' then exit;
  if FProfile=AValue then Exit;
  if Options.Modified then
    Options.SaveConfig(Config, FProfile);
  FProfile:=AValue;
  if not Config.SectionExists(AValue) then begin
    FProfiles := FProfiles + ',' + AValue;
    Config.WriteString(SecGen, 'Profiles', FProfiles);
  end;
  Config.WriteString(SecGen, 'Profile', FProfile);
  Options.LoadConfig(Config, Profile);
end;

(* Try load config from new dir - this may fail on the first run.
*)
procedure TFPDocManager.SetRootDir(AValue: string);
var
  s: string;
begin
  s := IncludeTrailingPathDelimiter(AValue);
  if FRootDir=s then Exit; //prevent recursion
  FRootDir:=s;
//load config - not here!
end;

procedure TFPDocManager.Changed;
begin
  if not Modified or (UpdateCount > 0) then
    exit; //should not be called directly
  FModified := False;
  if Assigned(OnChange) then
    FOnChange(self);
end;

function TFPDocManager.BeginTest(const ADir: string): boolean;
begin
  Helper.Free; //should have been done
  Helper := TFPDocHelper.Create(nil);
  Helper.OnLog := OnLog;
  Result := Helper.BeginTest(ADir);
  if Result then
    Helper.CmdOptions := Options; //set reference AND propagate!?
end;

procedure TFPDocManager.EndTest;
begin
  SetCurrentDir(ExtractFileDir(RootDir));
  FreeAndNil(Helper);
end;

procedure TFPDocManager.BeginUpdate;
begin
  inc(UpdateCount);
end;

procedure TFPDocManager.EndUpdate;
begin
  dec(UpdateCount);
  if UpdateCount <= 0 then begin
    UpdateCount := 0;
    if Modified then
      Changed;
  end;
end;

(* Try load config.
  Init RootDir (only when config found?)
  Try load packages from their INI files
*)
function TFPDocManager.LoadConfig(const ADir: string; Force: boolean): boolean;
var
  s, pf, cf: string;
  i: integer;
begin
  s := IncludeTrailingPathDelimiter(ADir);
  cf := s + ConfigName;
  Result := FileExists(cf);
  if not Result and not Force then
    exit;
  RootDir:=s; //recurse if RootDir changed
//sanity check: only one config file!
  if assigned(Config) then begin
    if (Config.FileName = cf) then
      exit(false) //nothing new?
    else
      Config.Free;
    //clear packages???
  end;
  Config := TConfigFile.Create(cf);
  //Config.CacheUpdates := True;
  if not Result then
    exit; //nothing to read
//read directories
  FFpcDir := Config.ReadString(SecGen, 'FpcDir', '');
  FFPDocDir := Config.ReadString(SecGen, 'FpcDocDir', '');
  FLazarusDir:=Config.ReadString(SecGen, 'LazarusDir', '');
//read packages
  Config.ReadSection(SecProjects, FPackages); //<prj>=<file>
//read detailed package information - possibly multiple packages per project!
  BeginUpdate;  //turn of app notification!
  for i := 0 to Packages.Count - 1 do begin
  //read package config (=project file name?)
    s := Packages.Names[i];
    pf := Packages.ValueFromIndex[i];
    if pf <> '' then begin
      AddProject(s, pf); //add and load project file, don't update config!
      FModified := True; //force app notification
    end;
  end;
//more? (preferences?)
  FProfiles:=Config.ReadString(SecGen, 'Profiles', 'default');
  FProfile := Config.ReadString(SecGen,'Profile', 'default');
  Options.LoadConfig(Config, Profile);
  FExcludedUnits := Config.ReadBool(SecGen, 'ExcludeUnits', True);
  Config.ReadSection('NoParseUnits', NoParseUnits);
//done, nothing modified
  EndUpdate;
end;

function TFPDocManager.SaveConfig: boolean;
begin
//Options? assume saved by application?
  if Options.Modified then begin
    Options.SaveConfig(Config, Profile);
  end;
  Config.Flush;
  Result := True; //for now
end;

procedure TFPDocManager.AddProfile(const AName: string);
begin
//add and select - obsolete!
  Profile := AName;
end;

(* Add a DocPackage to Packages and INI.
  Return package Index.
  For exclusive use by Package.SetLoaded!
*)
function TFPDocManager.RegisterPackage(APkg: TDocPackage): integer;
begin
  Result := Packages.IndexOfName(APkg.Name);
  if Result < 0 then begin
  //add package
    Result := Packages.AddObject(APkg.Name + '=' + APkg.ProjectFile, APkg);
  end else if Packages.Objects[Result] = nil then
    Packages.Objects[Result] := APkg;
  if APkg.Loaded then begin
  //check/create project file?
    if APkg.ProjectFile = '' then begin
      if APkg.ProjectDir = '' then begin
        DoLog('Missing project directory for package ' + APkg.Name);
        exit(-1); //???
      end;
      APkg.ProjectFile := APkg.ProjectDir + APkg.Name; //to be fixed by pkg
    end;
    if (ExtractFileExt(APkg.ProjectFile) <> '.xml') then begin
    //create project file
      APkg.ProjectFile := ChangeFileExt(APkg.ProjectFile, '_prj.xml');
      CreateProject(APkg.ProjectFile, APkg);
    //update Packages[] string
      Packages[Result] := APkg.Name + '=' + APkg.ProjectFile;
    end;
    Config.WriteString(SecProjects, APkg.Name, APkg.ProjectFile);
  end;
  FModified := True;
end;

(* Load FPDoc (XML) project file.
Called by
- init - not Dirty!
*)
function TFPDocManager.AddProject(const APkg, AFile: string): boolean;
var
  pkg: TDocPackage;
  i: integer;
begin
//create DocPackage
  pkg := AddPackage(APkg);
  if pkg.Loaded then
    exit(True); //assume registered!?
//check project file
  if ExtractFileExt(AFile) <> '.xml' then begin
    DoLog('Not a project file: ' + AFile);
    Exit(False);
  end;
  if not FileExists(AFile) then begin
    DoLog('Missing project file: ' + AFile);
    exit(False);
  end;
//create helper
  BeginTest(AFile);
  try
  //load the project file into Helper
    Helper.LoadProjectFile(AFile);
    if Helper.Packages.Count = 1 then begin
      Helper.Package := Helper.Packages[0]; //in LoadProject?
      Result := pkg.ImportProject(Helper, Helper.Package, AFile);
      exit;
    end;
  //load all packages
    for i := 0 to Helper.Packages.Count - 1 do begin
      Helper.Package := Helper.Packages[i];
      pkg := AddPackage(Helper.Package.Name);
      if pkg.Loaded then
        continue; //already initialized
      pkg.ImportProject(Helper, Helper.Package, '');
    end;
  finally
    EndTest;
  end;
end;

(* Ask DocPackage to create an projectfile.
  Overwrite if exists???
  AFileName is any file in the project directory, required for CD!
  !!! prevent recursive calls, destroying Helper !!!
*)
function TFPDocManager.CreateProject(const AFileName: string; APkg: TDocPackage
  ): boolean;
begin
  if Helper = nil then begin
    BeginTest(AFileName); //CD into project dir
    try
      Result := APkg.CreateProject(Helper, AFileName);
    finally
      EndTest;
    end;
  end else begin
  //assume that Helper IS for APkg
    Result := APkg.CreateProject(Helper, AFileName);
  end;
end;

(* Return the named package, create if not found.
  Rename: GetPackage?
*)
function TFPDocManager.AddPackage(AName: string): TDocPackage;
var
  i: integer;
begin
  AName := LowerCase(AName);
  i := FPackages.IndexOfName(AName);
  if i < 0 then
    Result := nil
  else
    Result := FPackages.Objects[i] as TDocPackage;
  if Result = nil then begin
  {$IFDEF FCLadds}
    if AName = 'fcl' then
      Result := TFCLDocPackage.Create
    else
  {$ELSE}
  {$ENDIF}
      Result := TDocPackage.Create;
    Result.Name := AName; //triggers load config --> register
    i := FPackages.IndexOfName(AName); //already registered?
  end;
  if i < 0 then begin
  //we MUST create an entry
    Packages.AddObject(AName + '=' + Result.ProjectFile, Result);
  end;
end;

function TFPDocManager.IsExtended(const APkg: string): string;
var
  pkg: TDocPackage;
begin
{$IFDEF FCLadds}
  pkg := AddPackage(APkg);
  if pkg = nil then
    Result := ''
  else
    Result := pkg.AltDir;
{$ELSE}
  Result := '';
{$ENDIF}
end;

function TFPDocManager.ImportLpk(const AFile: string): TDocPackage;
begin
  BeginUpdate;
//import the LPK file into? Here: TDocPackage, could be FPDocProject?
  Result := uLpk.ImportLpk(AFile);
  if Result = nil then
    DoLog('Import failed on ' + AFile)
  else begin
    Result.Loaded := True; //import and write config file
  end;
  EndUpdate;
end;

(* Add the project, just created from cmdline or projectfile
*)
procedure TFPDocManager.ImportProject(APkg: TFPDocPackage; const AFile: string);
var
  pkg: TDocPackage;
begin
  pkg := AddPackage(APkg.Name);
  pkg.ImportProject(Helper, APkg, AFile);
//update config?
  Config.WriteString(SecProjects, pkg.Name, AFile);
  FModified := true;
//notify app?
  //Changed;
end;

function TFPDocManager.ImportCmd(const AFile: string): boolean;
var
  pkg: TDocPackage;
begin
  Result := False;
  BeginTest(AFile); //directory!!!
  try
    Result := Helper.CmdToPrj(AFile);
    if not Result then
      exit;
    pkg := AddPackage(Helper.SelectedPackage.Name); //create [and register]
    pkg.Loaded := False; //force reload
    if not pkg.Loaded then begin
      Result := pkg.ImportProject(Helper, Helper.Package, AFile);
    end;
  finally
    EndTest;
  end;
  if Result then
    Changed;
end;

function TFPDocManager.MakeDoc(APkg: TDocPackage; const AUnit, AOutput: string): boolean;
begin
  Result := assigned(APkg)
  and BeginTest(APkg.ProjectDir)
  and APkg.CreateProject(Helper, ''); //only configure, don't create file
  if not Result then
    exit;
  try
    Helper.ParseFPDocOption(Format('--output="%s"', [AOutput]));
    if Options.Backend = 'chm' then begin
      Helper.ParseFPDocOption('--auto-toc');
      Helper.ParseFPDocOption('--auto-index');
    end;
      Helper.ParseFPDocOption('--make-searchable'); //always?
    //Result :=
    Helper.CreateUnitDocumentation(AUnit, False);
  finally
    EndTest;
  end;
end;

function TFPDocManager.TestRun(APkg: TDocPackage; AUnit: string): boolean;
begin
  BeginTest(APkg.ProjectFile);
  try
    try
      Result := Helper.TestRun(APkg, AUnit);
    except
      on E: EParserError do
        DoLog(Format('%s(%d,%d): %s',[e.Filename, e.Row, e.Column, e.Message]));
      on E: Exception do
        DoLog(E.Message);
    end;
  finally
    EndTest;
  end;
end;

function TFPDocManager.Update(APkg: TDocPackage; const AUnit: string): boolean;
begin
  Result := assigned(APkg)
  and BeginTest(APkg.ProjectFile);
  if not Result then
    exit;
  try
    Result := APkg.CreateProject(Helper, ''); //only configure, don't create file
    if not Result then
      exit;
    Result := Helper.Update(APkg, AUnit);
  finally
    EndTest;
  end;
end;

procedure TFPDocManager.DoLog(const Msg: String);
begin
  if Assigned(FOnLog) then
    FOnLog(self, msg);
end;

{ TFPDocHelper }

constructor TFPDocHelper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InputList := TStringList.Create;
  DescrList := TStringList.Create;
end;

destructor TFPDocHelper.Destroy;
begin
  FreeAndNil(InputList);
  FreeAndNil(DescrList);
  inherited Destroy;
end;

(* Prepare MakeSkel on temporary FPDocPackage
*)
function TFPDocHelper.BeginTest(APkg: TDocPackage): boolean;
begin
  if not assigned(APkg) then
    exit(False);
  Result := BeginTest(APkg.ProjectFile); //directory would be sufficient!
  if not Result then
    exit;
  APkg.CreateProject(self, ''); //create project file?
  Package := Packages.FindPackage(APkg.Name);
  //Options?
//okay, so far
  Result := assigned(Package);
end;

procedure TFPDocHelper.EndTest;
begin
//???
end;

function TFPDocHelper.BeginTest(ADir: string): boolean;
begin
  Result := ADir <> '';
  if not Result then
    exit;
//remember dir!
  if ExtractFileExt(ADir) <> '' then //todo: better check for directory!?
    ADir := ExtractFileDir(ADir);
  ProjectDir:=ADir;
  SetCurrentDir(ProjectDir);
end;

(* Create a project from an FPDoc commandline.
  Do NOT create an project file!(?)
*)
function TFPDocHelper.CmdToPrj(const AFileName: string): boolean;
var
  l, w: string;
  i: integer;
begin
  Result := False; //in case of errors
//read the commandline
  InputList.LoadFromFile(AFileName);
  for i := 0 to InputList.Count - 1 do begin
    l := InputList[i];
    w := GetNextWord(l);
    if w = 'fpdoc' then begin //contains!?
      Result := True; //so far
      break; //fpdoc command found
    end;
  end;
  InputList.Clear;
  if not Result then
    exit;
//parse commandline
  while l <> '' do begin
    w := GetNextWord(l);
    ParseFPDocOption(w);
  end;
  Result := True;
end;

function TFPDocHelper.MakeDocs(APkg: TDocPackage; const AUnit: string;
  AOutput: string): boolean;
begin
  Result := BeginTest(APkg); //configure and select package
  if not Result then
    exit;
  try
    ParseFPDocOption(Format('--output="%s"', [AOutput]));
    CreateDocumentation(Package, False);
  finally
    EndTest;
  end;
end;

function TFPDocHelper.TestRun(APkg: TDocPackage; AUnit: string): boolean;
begin
(* more detailed error handling?
  Must CD to the project file directory!?
*)
  Result := BeginTest(APkg);
  if not Result then
    exit;
  try
  //override options for test
    ParseFPDocOption('--format=html');
    ParseFPDocOption('-v');
    ParseFPDocOption('-n');
    //verbose?
    CreateUnitDocumentation(AUnit, True);
  finally
    EndTest;
  end;
end;

(* MakeSkel functionality - create skeleton or update file
  using temporary Project
*)
function TFPDocHelper.Update(APkg: TDocPackage; const AUnit: string): boolean;

  function DocumentUnit(const AUnit: string): boolean;
  var
    OutName, msg: string;
  begin
    if Manager.NoParseUnits.IndexOf(AUnit) >= 0 then begin
      DoLog('NoParse ' + AUnit);
      exit(False);
    end;
    InputList.Clear;
    InputList.Add(UnitSpec(AUnit));
    DescrList.Clear;
    OutName := AUnit + '.xml';
    if DescrDir <> '' then
      OutName := IncludeTrailingBackslash(DescrDir) + OutName;
    CmdOptions.UpdateMode := FileExists(OutName);
    if CmdOptions.UpdateMode then begin
      DescrList.Add(OutName);
      OutName:=Manager.RootDir + 'upd.' + AUnit + '.xml';
      DoLog('Update ' + OutName);
    end else begin
      DoLog('Create ' + OutName);
    end;
    msg := DocumentPackage(APkg.Name, OutName, InputList, DescrList);
    Result := msg = '';
    if not Result then
      DoLog(msg) //+unit?
    else if CmdOptions.UpdateMode then begin
      CleanXML(OutName);
    end;
  end;

var
  i: integer;
  u: string;
begin
  Result := BeginTest(APkg);
  if not Result then
    exit;
  if AUnit <> '' then begin
    Result := DocumentUnit(AUnit);
  end else begin
    for i := 0 to Package.Inputs.Count - 1 do begin
      u := ExtractUnitName(Package.Inputs, i);
      DocumentUnit(u);
    end;
  end;
  EndTest;
end;

procedure TFPDocHelper.SetProjectDir(AValue: string);
begin
  if FProjectDir=AValue then Exit;
  FProjectDir:=AValue;
end;

end.

