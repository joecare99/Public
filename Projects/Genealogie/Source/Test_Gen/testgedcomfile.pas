unit testGedComFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,Cmp_GedComFile;

type

  { TTestGedComFile }

  TTestGedComFile= class(TTestCase)
  private
    FGedComFile:TGedComFile;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
  end;

implementation

procedure TTestGedComFile.TestSetUp;
begin
  CheckNotNull(FGedComFile,'GedComFile is assigned');
end;

procedure TTestGedComFile.SetUp;
begin
  FGedComFile:=TGedComFile.Create;
end;

procedure TTestGedComFile.TearDown;
begin
  FreeAndNil(FGedComFile);
end;

initialization

  RegisterTest(TTestGedComFile);
end.

