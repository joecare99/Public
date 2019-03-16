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
    Procedure TestCompNop;
    Procedure TestCompEqual;
    Procedure TestCompUnEqual;
    Procedure TestCompLess;
    Procedure TestCompLessOEqual;
    Procedure TestCompGreaterOEqual;
    Procedure TestCompGreater;
    Procedure TestCompStartswith;
    Procedure TestCompEndswith;
    Procedure TestCompContains;
    Procedure TestCompIsEmpty;
    Procedure TestCompIsNotEmpty;
    Procedure TestEquals;
    Procedure TestToString;
    Procedure TestToPasStruct;
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

uses cls_HejIndData, unt_IndTestData, unt_MarrTestData, unt_SourceTestData, unt_PlaceTestData;

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

procedure TTestClsHejFRule.TestCompNop;
Const CompToTest:TEnumHejCompareType=hCmp_Nop;
begin
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,0);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'nop is always false 1');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,1);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'nop is always false 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'nop is always false 3');
end;

procedure TTestClsHejFRule.TestCompEqual;
Const CompToTest:TEnumHejCompareType=hCmp_Equal;
begin
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,0);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 1');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,1);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is true 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 3');
end;

procedure TTestClsHejFRule.TestCompUnEqual;
Const CompToTest:TEnumHejCompareType=hCmp_UnEqual;
begin
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,0);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 1');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,1);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is true 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 3');
end;

procedure TTestClsHejFRule.TestCompLess;
Const CompToTest:TEnumHejCompareType=hCmp_Less;
begin
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,0);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 1');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,1);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is true 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,2);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is true 2b');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 3');
end;

procedure TTestClsHejFRule.TestCompLessOEqual;
Const CompToTest:TEnumHejCompareType=hCmp_LessOEqual;
begin
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,0);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 1');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,1);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is true 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,2);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is true 2b');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 3');
end;

procedure TTestClsHejFRule.TestCompGreaterOEqual;
Const CompToTest:TEnumHejCompareType=hCmp_GreaterOEqual;
begin
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,0);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 1');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,1);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,2);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 2b');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 3');
end;

procedure TTestClsHejFRule.TestCompGreater;
Const CompToTest:TEnumHejCompareType=hCmp_Greater;
begin
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,0);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 1');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,1);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,2);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 2b');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 3');
end;

procedure TTestClsHejFRule.TestCompStartswith;
Const CompToTest:TEnumHejCompareType=hCmp_Startswith;
begin
  FFilterRule.Init(ord(hind_AdrPlace)+100,hIRd_Ind,CompToTest,'Mörtel');
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 1');
  FFilterRule.Init(ord(hind_AdrPlace)+100,hIRd_Ind,CompToTest,'Heidel');
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,2);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 2b');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 3');
end;

procedure TTestClsHejFRule.TestCompEndswith;
Const CompToTest:TEnumHejCompareType=hCmp_Endswith;
begin
FFilterRule.Init(ord(hind_AdrPlace)+100,hIRd_Ind,CompToTest,'stein');
CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 1');
FFilterRule.Init(ord(hind_AdrPlace)+100,hIRd_Ind,CompToTest,'berg');
CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,2);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 2b');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 3');
end;

procedure TTestClsHejFRule.TestCompContains;
Const CompToTest:TEnumHejCompareType=hCmp_Contains;
begin
FFilterRule.Init(ord(hind_AdrPlace)+100,hIRd_Ind,CompToTest,'rtelst');
CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 1');
FFilterRule.Init(ord(hind_AdrPlace)+100,hIRd_Ind,CompToTest,'delber');
CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,2);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 2b');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),CCompTypeOp[CompToTest]+' is false 3');
end;

procedure TTestClsHejFRule.TestCompIsEmpty;
Const CompToTest:TEnumHejCompareType=hCmp_IsEmpty;
begin
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,0);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 1');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,1);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,2);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 2b');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(false,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 3');
end;

procedure TTestClsHejFRule.TestCompIsNotEmpty;
Const CompToTest:TEnumHejCompareType=hCmp_IsNotEmpty;
begin
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,0);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 1');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,1);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 2');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,2);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is true 2b');
  FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,CompToTest,null);
  CheckEquals(true,FFilterRule.Eval(1,FHejClass),'('+FFilterRule.toString+') is false 3');
end;

procedure TTestClsHejFRule.TestEquals;
begin
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Equal,0);
CheckEquals(false,FFilterRule.Equals(FilterRule(99,hIRd_Ind,hCmp_Nop,0)),'('+FFilterRule.toString+').equals 1');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Equal,1);
CheckEquals(true,FFilterRule.Equals(FilterRule(99,hIRd_Ind,hCmp_Equal,1)),'('+FFilterRule.toString+').equals 2');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Equal,2);
CheckEquals(false,FFilterRule.Equals(FilterRule(100,hIRd_Ind,hCmp_Equal,2)),'('+FFilterRule.toString+').equals 2b');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Equal,2);
CheckEquals(false,FFilterRule.Equals(FilterRule(99,hIRd_Meta,hCmp_Equal,2)),'('+FFilterRule.toString+').equals  2c');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Equal,null);
CheckEquals(true,FFilterRule.Equals(FilterRule(ord(hind_ID)+100,hIRd_Ind,hCmp_Equal,null)),'('+FFilterRule.toString+').equals 3');
end;

procedure TTestClsHejFRule.TestToString;
begin
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Equal,0);
CheckEquals('.ID= 0',FFilterRule.toString,'('+FFilterRule.toString+').ToString 1');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Nop,1);
CheckEquals('.ID? 1',FFilterRule.toString,'('+FFilterRule.toString+').ToString 2');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Contains,2);
CheckEquals('.ID like "*2*"',FFilterRule.toString,'('+FFilterRule.toString+').ToString 2b');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_IsEmpty,null);
CheckEquals('.ID IsEmpty',FFilterRule.toString,'('+FFilterRule.toString+').ToString 3');
end;

procedure TTestClsHejFRule.TestToPasStruct;
begin
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Equal,0);
CheckEquals('(Concat:hCcT_Or;DataField:99;IndRedir:hIRd_Ind;CompType:hCmp_Equal;CompValue:0)',FFilterRule.toPasStruct,'('+FFilterRule.toString+').toPasStruct 1');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Nop,1);
CheckEquals('(Concat:hCcT_Or;DataField:99;IndRedir:hIRd_Ind;CompType:hCmp_Nop;CompValue:1)',FFilterRule.toPasStruct,'('+FFilterRule.toString+').toPasStruct 2');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_Contains,2);
CheckEquals('(Concat:hCcT_Or;DataField:99;IndRedir:hIRd_Ind;CompType:hCmp_Contains;CompValue:2)',FFilterRule.toPasStruct,'('+FFilterRule.toString+').toPasStruct 2b');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Meta,hCmp_Less,3);
CheckEquals('(Concat:hCcT_Or;DataField:99;IndRedir:hIRd_Meta;CompType:hCmp_Less;CompValue:3)',FFilterRule.toPasStruct,'('+FFilterRule.toString+').toPasStruct 2c');
FFilterRule.Init(ord(hind_ID)+100,hIRd_Ind,hCmp_IsEmpty,null);
CheckEquals('(Concat:hCcT_Or;DataField:99;IndRedir:hIRd_Ind;CompType:hCmp_IsEmpty;CompValue:null)',FFilterRule.toPasStruct,'('+FFilterRule.toString+').toPasStruct 3');
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

