unit tst_fraIndIndex;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, SysUtils, fpcunit, testutils, testregistry,cls_HejData,fra_IndIndex;

type

  { TTestFraIndIndex }

  TTestFraIndIndex= class(TTestCase)
  private
    FDataDir: String;
    FtestForm:TForm;
    FFraIndIndex:TfraIndIndex;
    FGenealogy:TClsHejGenealogy;
    FUpdateSender: TObject;
    FOnUpdateCount:integer;
    procedure GenOnUpdateTest(Sender: TObject);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure Test2;
  end;

implementation

uses Controls;

const     DefDataDir = 'Data';

procedure TTestFraIndIndex.TestSetUp;
var
  i: Integer;
begin
  CheckNotNull (FtestForm,'Testform is assigned');
  CheckNotNull(FFraIndIndex,'TestFrame is assigned');
  CheckNotNull(FGenealogy,'Genealogy is assigned');
  CheckTrue(FtestForm.Visible,'Testform is Visible');
  for i := 0 to 100 do
    begin
      sleep(10);
      Application.ProcessMessages;
    end;
end;

procedure TTestFraIndIndex.Test2;
var
  i: Integer;
begin
  FGenealogy.LoadFromFile(FDataDir+DirectorySeparator+'Care.hej');
  for i := 0 to 10 do
    begin
      sleep(100);
      Application.ProcessMessages;
    end;
  FGenealogy.Next(self);
  for i := 0 to 10 do
    begin
      sleep(100);
      Application.ProcessMessages;
    end;
  FGenealogy.Next(self);
  for i := 0 to 10 do
    begin
      sleep(100);
      Application.ProcessMessages;
    end;
  FGenealogy.Next(self);
  for i := 0 to 10 do
    begin
      sleep(100);
      Application.ProcessMessages;
    end;
end;

procedure TTestFraIndIndex.GenOnUpdateTest(Sender: TObject);
begin
  FUpdateSender := Sender;
  FOnUpdateCount := FonUpdateCount + 1;
end;

procedure TTestFraIndIndex.SetUp;
var
  i: Integer;
begin
    FDataDir := DefDataDir;
    for i := 0 to 2 do
        if not DirectoryExists(FDataDir) then
            FDataDir := '..' + DirectorySeparator + FDataDir
        else
            break;
    FDataDir := FDataDir + DirectorySeparator + 'HejTest';

  FGenealogy:=TClsHejGenealogy.Create;
  FGenealogy.OnUpdate:=@GenOnUpdateTest;
  FOnUpdateCount:=0;
  if not Assigned(FtestForm) then
    Application.CreateForm(TForm,FtestForm);
  FtestForm.height := Screen.Height div 2;
  FFraIndIndex:=TfraIndIndex.Create(FtestForm);
  FFraIndIndex.Parent:=FtestForm;
  FFraIndIndex.Align:= alLeft;
  FFraIndIndex.Genealogy:=FGenealogy;
  FtestForm.Show;
end;

procedure TTestFraIndIndex.TearDown;
begin
  FreeAndNil(FFraIndIndex);
  FreeAndNil(FGenealogy);
  FtestForm.hide;
end;

initialization

  RegisterTest(TTestFraIndIndex);
end.

