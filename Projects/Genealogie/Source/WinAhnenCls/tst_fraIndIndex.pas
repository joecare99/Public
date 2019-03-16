unit tst_fraIndIndex;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, Forms, SysUtils{$IFNDEF FPC},TestFramework {$Else} ,fpcunit, testutils,
  testregistry {$endif},cls_HejData,fra_IndIndex;

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
    Procedure Test3;
  end;

implementation

uses Controls, cls_HejIndData, unt_IndTestData, unt_MarrTestData, unt_SourceTestData, unt_PlaceTestData;

const     DefDataDir = 'Data';


  procedure GenerateTestData(aHejClass:TClsHejGenealogy);

  var
    i, j: Integer;
  begin
      for i := 1 to high(cInd) do
       begin
         aHejClass.Append(aHejClass);
         aHejClass.ActualInd := cInd[i];

         if cInd[i].idFather<i then
            aHejClass.AppendLinkChild(cInd[i].idFather,i);
         if cInd[i].idMother<i then
            aHejClass.AppendLinkChild(cInd[i].idMother,i);

         for j := 1 to aHejClass.Count-1 do
            if (cInd[j].idFather = i) or (cInd[j].idMother = i) then
               aHejClass.AppendLinkChild(i,j);
       end;
  // Delete an unwanted record
  for i := 1 to high(cInd) do
    if cInd[i].id = 0 then
       begin
         aHejClass.Seek(i);
         aHejClass.Delete(aHejClass);
       end;

  for i := 0 to high(cPlace) do
    aHejClass.SetPlace(cPlace[i]);

  for i := 0 to high(cSource) do
    aHejClass.SetSource(cSource[i]);

    aHejClass.First;

  end;


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

procedure TTestFraIndIndex.Test3;
var
  i: Integer;
begin
  GenerateTestData(FGenealogy);
  for i := 0 to 5 do
    begin
      sleep(100);
      Application.ProcessMessages;
    end;
  while not FGenealogy.EOF do
    begin
      FGenealogy.Next(self);
      for i := 0 to 5 do
        begin
          sleep(50);
          Application.ProcessMessages;
        end;
    end;
  while not FGenealogy.BOF do
    begin
      FGenealogy.Previous(self);
      for i := 0 to 5 do
        begin
          sleep(50);
          Application.ProcessMessages;
        end;
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
  FGenealogy.OnUpdate:=GenOnUpdateTest;
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

