unit tst_GenHelper;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,Cmp_GedComFile, cls_GenealogieHelper;

type

  { TTestGenealogieHelper }

  TTestGenealogieHelper= class(TTestCase)
  private
    FDataPath: String;
    FGedComFile: TGedComFile;
    FGenealogyHelper: TGenealogyHelper;

  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
  public
      constructor Create; override;
  end;

implementation

uses unt_GenTestBase;

procedure TTestGenealogieHelper.TestSetUp;
begin
    CheckNotNull(FGedComFile, 'FGedComFile is assigned');
    CheckNotNull(FGenealogyHelper, 'FGenealogyHelper is assigned');
    CheckNotNull(FGenealogyHelper.GedComFile, 'FGenealogyHelper.GedComFile is assigned');
    checktrue(DirectoryExists(FDataPath), 'DataPath exists');
end;

constructor TTestGenealogieHelper.Create;
var
    i: integer;
begin
    inherited Create;
     FDataPath:=GetDataPath('GenData');
end;

procedure TTestGenealogieHelper.SetUp;
begin
    FGedComFile := TGedComFile.Create;
    FGenealogyHelper := TGenealogyHelper.Create;
    FGenealogyHelper.GedComFile := FGedComFile;
end;

procedure TTestGenealogieHelper.TearDown;
begin
    FreeAndNil(FGedComFile);
    FreeAndNil(FGenealogyHelper);
end;

initialization

  RegisterTest(TTestGenealogieHelper);
end.

