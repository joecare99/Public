unit tst_ClsHejFilter;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFNDEF FPC},TestFramework {$Else} ,fpcunit, testutils,
  testregistry {$endif},cls_HejData, cls_HejDataFilter;

type

  { TTestClsHejFRule }

  TTestClsHejFRule= class(TTestCase)
  private
    FHejClass:TClsHejGenealogy;
    FFilterRule:TFilterRule;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
  end;


  { TTestClsHejFilter }

  TTestClsHejFilter= class(TTestCase)
  private
    FGenFilter: TGenFilter;
    FHejClass: TClsHejGenealogy;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
  end;

implementation

uses unt_IndTestData, unt_MarrTestData, unt_SourceTestData, unt_PlaceTestData;

procedure  GenerateTestData(aHejClass:TClsHejGenealogy);

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

{ TTestClsHejFRule }

procedure TTestClsHejFRule.SetUp;
begin
  FHejClass:=TClsHejGenealogy.Create;
  GenerateTestData(FHejClass);
  FFilterRule.clear;
end;

procedure TTestClsHejFRule.TearDown;
begin
  freeandnil(FHejClass);
  FFilterRule.clear;
end;

procedure TTestClsHejFRule.TestSetUp;
var
  i: Integer;
begin
   CheckNotNull(FHejClass,'GEnealogie is assigned');
   CheckEquals(9, FHejClass.Count, '9 Individuals');
   CheckEquals(12, FHejClass.PlaceCount, '12 Places');
   CheckEquals(17, FHejClass.SourceCount, '17 Sources');

for i := 1 to high(cInd) do
 begin
   FHejClass.Seek(i);
          Checktrue(FHejClass.ActualInd.Equals(cind[i]),  'Individual['+inttostr(i)+'] match');
          CheckTrue(cind[i].Equals(FHejClass.PeekInd(i)), 'Individual['+inttostr(i)+'] match 2');
 end;
end;



{TTestClsHejFilter}

procedure TTestClsHejFilter.SetUp;
begin
FHejClass:=TClsHejGenealogy.Create;
GenerateTestData(FHejClass);
FGenFilter := TGenFilter.create;
end;

procedure TTestClsHejFilter.TearDown;
begin
  FreeandNil(FGenFilter);
  freeandnil(FHejClass);
end;

procedure TTestClsHejFilter.TestSetUp;
var
  i: Integer;
begin
CheckNotNull(FHejClass,'GEnealogie is assigned');
CheckEquals(9, FHejClass.Count, '9 Individuals');
CheckEquals(12, FHejClass.PlaceCount, '12 Places');
CheckEquals(17, FHejClass.SourceCount, '17 Sources');

for i := 1 to high(cInd) do
begin
FHejClass.Seek(i);
       Checktrue(FHejClass.ActualInd.Equals(cind[i]),  'Individual['+inttostr(i)+'] match');
       CheckTrue(cind[i].Equals(FHejClass.PeekInd(i)), 'Individual['+inttostr(i)+'] match 2');
end;
CheckNotNull(FGenFilter,'Filter is assigned');
end;

initialization

  RegisterTest(TTestClsHejFRule{$IFNDEF FPC}.suite{$ENDIF});
  RegisterTest(TTestClsHejFilter{$IFNDEF FPC}.suite{$ENDIF});
end.

