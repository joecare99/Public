unit TestPasSrc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, PParser, PasTree;

type
  { We have to override abstract TPasTreeContainer methods.
    See utils/fpdoc/dglobals.pp for an implementation of TFPDocEngine,
    a "real" engine. }
  TSimpleEngine = class(TPasTreeContainer)
  public
    function CreateElement(AClass: TPTreeElement; const AName: String;
      AParent: TPasElement; AVisibility: TPasMemberVisibility;
      const ASourceFilename: String; ASourceLinenumber: Integer): TPasElement;
      override;
    function FindElement(const AName: String): TPasElement; override;
  end;

type

  { TTestPassRc }

  TTestPassRc= class(TTestCase)
  private
      E: TPasTreeContainer;
      FDataPath:String;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    Procedure TestSetup;
    procedure TestParseIopcc;
    Procedure TestParseTraFile;
    procedure TestMiniTest;
    procedure TestMiniTest2;
    procedure TestMiniTest3;
    procedure TestCreateUnit;
  public
    Constructor Create; override;
  end;

implementation

uses PasWrite;

const CDataPath='Data';

function TSimpleEngine.CreateElement(AClass: TPTreeElement; const AName: String;
  AParent: TPasElement; AVisibility: TPasMemberVisibility;
  const ASourceFilename: String; ASourceLinenumber: Integer): TPasElement;
begin
  Result := AClass.Create(AName, AParent);
  Result.Visibility := AVisibility;
  Result.SourceFilename := ASourceFilename;
  Result.SourceLinenumber := ASourceLinenumber;
end;

function TSimpleEngine.FindElement(const AName: String): TPasElement;
begin
  { dummy implementation, see TFPDocEngine.FindElement for a real example }
  Result := nil;
end;



procedure TTestPassRc.TestParseIopcc;

var
  M: TPasModule;
  Decls: {$ifdef VER2_6} TList {$else} { for FPC > 2.6.0 } TFPList {$endif};

const Filename='unt_iopcc.pas';

begin
    M := ParseSource(E,[FDataPath+DirectorySeparator+ Filename], 'linux', 'i386',[]);

    { Cool, we successfully parsed the module.
      Now output some info about it. }
    CheckEquals('TPasModule',M.ClassName,'ClassName');
    CheckEquals('Unt_iopcc',M.Name,'name');

    if M.InterfaceSection <> nil then
    begin
      Decls := M.InterfaceSection.Declarations;
      CheckEquals(1,Decls.Count,'Interface has # Entries');
      CheckEquals('Main',(TObject(Decls[0]) as TPasElement).Name,'Name of Entry');
      CheckEquals('procedure',(TObject(Decls[0]) as TPasElement).ElementTypeName,'Type of Entry');
      CheckEquals('',(TObject(Decls[0]) as TPasElement).DocComment,'Comment of Entry');
    end;
//      Writeln('No interface section --- this is not a unit, this is a ', M.ClassName);

    if M.ImplementationSection <> nil then // may be nil in case of a simple program
    begin
      Decls := M.ImplementationSection.Declarations;
      CheckEquals(14,Decls.Count,'Implementation has # Entries');
      CheckEquals('L',(TObject(Decls[0]) as TPasElement).Name,'Name if Entry 0');
      CheckEquals('I',(TObject(Decls[1]) as TPasElement).Name,'Name if Entry 1');
      CheckEquals('Z',(TObject(Decls[2]) as TPasElement).Name,'Name if Entry 2');
      CheckEquals('U',(TObject(Decls[3]) as TPasElement).Name,'Name if Entry 3');
      CheckEquals('O',(TObject(Decls[4]) as TPasElement).Name,'Name if Entry 4');
      CheckEquals('D',(TObject(Decls[5]) as TPasElement).Name,'Name if Entry 5');
      CheckEquals('C',(TObject(Decls[6]) as TPasElement).Name,'Name if Entry 6');
      CheckEquals('B',(TObject(Decls[7]) as TPasElement).Name,'Name if Entry 7');
      CheckEquals('constant',(TObject(Decls[7]) as TPasElement).ElementTypeName,'Type of Entry 7');
      CheckEquals('l0',(TObject(Decls[8]) as TPasElement).Name,'Name if Entry 8');
      CheckEquals('constant',(TObject(Decls[8]) as TPasElement).ElementTypeName,'Type of Entry 8');
      CheckEquals('lQ',(TObject(Decls[9]) as TPasElement).Name,'Name if Entry 9');
      CheckEquals('constant',(TObject(Decls[9]) as TPasElement).ElementTypeName,'Type of Entry 9');
      CheckEquals('E',(TObject(Decls[10]) as TPasElement).Name,'Name if Entry 10');
      CheckEquals('variable',(TObject(Decls[10]) as TPasElement).ElementTypeName,'Type of Entry 10');
      CheckEquals('H',(TObject(Decls[11]) as TPasElement).Name,'Name if Entry 11');
      CheckEquals('function',(TObject(Decls[11]) as TPasElement).ElementTypeName,'Type of Entry 11');
      CheckEquals('TPasProcedure',TObject(Decls[12]).ClassName,'ClassName of Entry 12');
      CheckEquals('Q',(TObject(Decls[12]) as TPasElement).Name,'Name if Entry 12');
      CheckEquals('procedure',(TObject(Decls[12]) as TPasElement).ElementTypeName,'Type of Entry 12');
      CheckEquals('TProcedureBody',(TObject(Decls[12]) as TPasProcedure).Body.ToString,'Type of Entry 12');
      CheckEquals('Main',(TObject(Decls[13]) as TPasElement).Name,'Name if Entry 13');
      CheckEquals('procedure',(TObject(Decls[13]) as TPasElement).ElementTypeName,'Type of Entry 13');
    end;

    WritePasFile(M,FDataPath+DirectorySeparator+M.Name+'_.pas');

    FreeAndNil(M);
end;

procedure TTestPassRc.TestParseTraFile;
var
  M: TPasModule;
  Decls: {$ifdef VER2_6} TList {$else} { for FPC > 2.6.0 } TFPList {$endif};

const Filename='tra_FormPrincipal.pas';

begin
    M := ParseSource(E,[FDataPath+DirectorySeparator+ Filename], 'linux', 'i386',[]);

    { Cool, we successfully parsed the module.
      Now output some info about it. }
    FreeAndNil(M);
end;

procedure TTestPassRc.TestMiniTest;
var
  M: TPasModule;
  Decls: {$ifdef VER2_6} TList {$else} { for FPC > 2.6.0 } TFPList {$endif};

const Filename='Minitest.lpr';

begin
    M := ParseSource(E,[FDataPath+DirectorySeparator+ Filename], 'linux', 'i386',[]);

    { Cool, we successfully parsed the module.
      Now output some info about it. }
      WritePasFile(M,FDataPath+DirectorySeparator+extractFilename(M.Name)+'_.lpr');

      FreeAndNil(M);
end;

procedure TTestPassRc.TestMiniTest2;
var
  M: TPasModule;
  Decls: {$ifdef VER2_6} TList {$else} { for FPC > 2.6.0 } TFPList {$endif};

const Filename='Minitest2.lpr';

begin
    M := ParseSource(E,[FDataPath+DirectorySeparator+ Filename], 'linux', 'i386',[]);

    { Cool, we successfully parsed the module.
      Now output some info about it. }
      WritePasFile(M,FDataPath+DirectorySeparator+extractFilename(M.Name)+'_.lpr');

      FreeAndNil(M);
end;

procedure TTestPassRc.TestMiniTest3;
var
  M: TPasModule;
  Decls: {$ifdef VER2_6} TList {$else} { for FPC > 2.6.0 } TFPList {$endif};

const Filename='Minitest3.lpr';

begin
    M := ParseSource(E,[FDataPath+DirectorySeparator+ Filename], 'linux', 'i386',[]);

    { Cool, we successfully parsed the module.
      Now output some info about it. }
      WritePasFile(M,FDataPath+DirectorySeparator+extractFilename(M.Name)+'_.lpr');

      FreeAndNil(M);
end;


procedure TTestPassRc.TestCreateUnit;
var M:TPasModule;
begin
  M := TPasModule.Create('unt_TestUnit',nil);
  M.DocComment:='This is a test-Unit.';
  M.InterfaceSection := TInterfaceSection.Create('interface',M);
  M.ImplementationSection := TImplementationSection.Create('implementation',M);

  WritePasFile(M,FDataPath+DirectorySeparator+M.Name+'.pas');
end;

constructor TTestPassRc.Create;
var
  i: Integer;
begin
  inherited Create;
  FDataPath:= CDataPath;
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      Break
    else
      FDataPath:='..'+DirectorySeparator+FDataPath;
  FDataPath := FDataPath+DirectorySeparator+'PassRc';
  ForceDirectories(FDataPath);
end;

procedure TTestPassRc.SetUp;
begin
  E := TSimpleEngine.Create;
end;

procedure TTestPassRc.TearDown;
begin
  FreeAndNil(E)
end;

procedure TTestPassRc.TestSetup;
begin
  CheckTrue(DirectoryExists(FDataPath),'DataPath Exists');
  CheckNotNull(E,'E is assigned');
end;

initialization

  RegisterTest(TTestPassRc);
end.

