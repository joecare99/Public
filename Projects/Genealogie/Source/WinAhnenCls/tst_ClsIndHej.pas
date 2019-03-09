unit tst_ClsIndHej;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFNDEF FPC},TestFramework {$Else} ,fpcunit, testutils,
  testregistry {$endif}, cls_HejIndData;

type

  { TTestIndHej }

  TTestIndHej= class(TTestCase)
  private
      FHejIndData: THejIndData;
      FDataDir: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestID;
    procedure TestidFather;
    procedure TestidMother;
    procedure TestFamilyName;
    procedure TestGivenName;
    procedure TestSex;
    procedure TestReligion;
    procedure TestOccupation;
    procedure TestBirthDay;
    procedure TestBirthMonth;
    procedure TestBirthYear;
    procedure TestBirthplace;
    procedure TestBaptDay;
    procedure TestBaptMonth;
    procedure TestBaptYear;
    procedure TestBaptPlace;
    procedure TestGodparents;
    procedure TestResidence;
    procedure TestDeathDay;
    procedure TestDeathMonth;
    procedure TestDeathYear;
    procedure TestDeathPlace;
    procedure TestDeathReason;
    procedure TestBurialDay;
    procedure TestBurialMonth;
    procedure TestBurialYear;
    procedure TestBurialPlace;
    procedure TestBirthSource;
    procedure TestBaptSource;
    procedure TestDeathSource;
    procedure TestBurialSource;
    procedure TestText;
    procedure TestLiving;
    procedure TestAKA;
    procedure TestIndex;
    procedure TestAdopted;
    procedure TestFarmName;
    procedure TestAdrStreet;
    procedure TestAdrAddit;
    procedure TestAdrPLZ;
    procedure TestAdrPlace;
    procedure TestAdrPlaceAdd;
    procedure TestFree1;
    procedure TestFree2;
    procedure TestFree3;
    procedure TestAge;
    procedure TestPhone;
    procedure TesteMail;
    procedure TestWebAdr;
    procedure TestNameSource;
    procedure TestCallName;
    Procedure TestEquals;
    procedure TestReadStream;
    Procedure TestWriteStream;
    Procedure TestAppendChild;
    Procedure TestAppendMarriage;
    Procedure testRemoveParent;
    Procedure testRemoveChild;
    Procedure testRemoveMarriage;
    Procedure testDeleteChild;
    Procedure testDeleteMarriage;
    Procedure TestToString;
    Procedure TestToPasStruct;
  end;

{ TTestClsIndHej }

  TTestClsIndHej= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CheckEquals(const expected, actual: THejIndData;
      msg: string='';ChkID: boolean=false); overload;
  private
      FClsHejIndividuals: TClsHejIndividuals;
      FDataDir: string;
    Procedure CreateTestData(Tested:boolean);
  published
    procedure TestSetUp;
    procedure TestCreateTestData;
    procedure TestIndexOf;
    procedure TestIndexOf2;
    procedure TestIndexOf3;
    procedure TestIndexOf4;
    Procedure TestSetActualMarriage;
    procedure TestReadStream;
    procedure TestReadStream2;
    procedure TestWriteStream;
  end;


implementation

uses unt_IndTestData,unt_MarrTestData,variants;

resourcestring
  DefDataDir = 'Data';

{ TTestClsIndHej }

procedure TTestClsIndHej.SetUp;
var
  i: Integer;
begin
  FClsHejIndividuals:=TClsHejIndividuals.Create;
  FDataDir := DefDataDir;
  for i := 0 to 2 do
      if not DirectoryExists(FDataDir) then
          FDataDir := '..' + DirectorySeparator + FDataDir
      else
          break;
  FDataDir := FDataDir + DirectorySeparator + 'HejTest';
end;

procedure TTestClsIndHej.TearDown;
begin
  freeandnil(FClsHejIndividuals);
end;

procedure TTestClsIndHej.CreateTestData(Tested: boolean);
var
  i, j: Integer;
begin
  FClsHejIndividuals.Clear;
  if Tested then
     CheckEquals(0, FClsHejIndividuals.Count, 'No Individuals');
  if Tested then
     CheckEquals(0, FClsHejIndividuals.Count, 'No Individuals');

  FClsHejIndividuals.Append(self);

  if Tested then
     CheckEquals(1, FClsHejIndividuals.Count, '1 Individual');
  FClsHejIndividuals.ActualInd := cInd[1];
  if Tested then
     CheckEquals(cind[1], FClsHejIndividuals.ActualInd, 'Individual[1] match');
  if Tested then
     CheckEquals(cind[1], FClsHejIndividuals.PeekInd[1], 'Individual[1] match 2');

  for i := 2 to high(cInd) do
     begin
       FClsHejIndividuals.Append(self);

       if Tested then
          CheckEquals(i, FClsHejIndividuals.Count, inttostr(i)+' Individuals');
       FClsHejIndividuals.ActualInd := cInd[i];

       if Tested then
          CheckEquals(cind[i], FClsHejIndividuals.ActualInd, 'Individual['+inttostr(i)+'] match');
       if Tested then
          CheckEquals(cind[i], FClsHejIndividuals.PeekInd[i], 'Individual['+inttostr(i)+'] match 2');

       if cInd[i].idFather<i then
          FClsHejIndividuals.AppendLinkChild(cInd[i].idFather,i);
       if cInd[i].idMother<i then
          FClsHejIndividuals.AppendLinkChild(cInd[i].idMother,i);

       for j := 1 to FClsHejIndividuals.Count-1 do
          if (cInd[j].idFather = i) or (cInd[j].idMother = i) then
             FClsHejIndividuals.AppendLinkChild(i,j);
     end;

// Append some Marriages
  FClsHejIndividuals.AppendMarriage(1,0);
  FClsHejIndividuals.AppendMarriage(2,1);
  for i := 1 to high(cMarr) do
    FClsHejIndividuals.AppendMarriage(cMarr[i].idPerson,cMarr[i].id);

// Delete an unwanted record
for i := 1 to high(cInd) do
  if cInd[i].id = 0 then
     begin
       FClsHejIndividuals.Seek(i);
       FClsHejIndividuals.Delete(self);
     end;
  FClsHejIndividuals.First;


end;

procedure TTestClsIndHej.CheckEquals(const expected, actual: THejIndData;
  msg: string; ChkID: boolean);
var
  lFld: TEnumHejIndDatafields;
begin
  for lFld in TEnumHejIndDatafields do
    if lFld> hind_idMother then
    CheckEquals(string(expected.Data[lFld]),actual.Data[lFld],msg +' fld:'+CHejIndDataDesc[lFld]);
  if ChkID then
    begin
  CheckEquals(integer(expected.Data[hind_idMother]),actual.Data[hind_idMother],msg +' fld:'+CHejIndDataDesc[hind_idMother]);
  CheckEquals(integer(expected.Data[hind_idFather]),actual.Data[hind_idFather],msg +' fld:'+CHejIndDataDesc[hind_idFather]);
  CheckEquals(integer(expected.Data[hind_ID]),actual.Data[hind_ID],msg +' fld:'+CHejIndDataDesc[hind_ID]);
    end;
end;

procedure TTestClsIndHej.TestSetUp;
begin
    CheckTrue(DirectoryExists(FDataDir),'Data-Directory '+FDataDir+' exists');
    CheckNotNull(FClsHejIndividuals,'Individuals are assigned');
    CheckEquals(0,FClsHejIndividuals.Count,'No Individuals');
end;

procedure TTestClsIndHej.TestCreateTestData;
var
  i: Integer;
begin
  CreateTestData(true);
  for i := 0 to high(cInd) do
     CheckEquals(cind[i], FClsHejIndividuals.PeekInd[i], 'Individual['+inttostr(i)+']',true);
  for i := 1 to high(cMarr) do
     CheckEquals(cMarr[i].ID, FClsHejIndividuals.PeekInd[cMarr[i].idPerson].Marriages[0], 'Individual['+inttostr(i)+'].Marriages');


end;

procedure TTestClsIndHej.TestIndexOf;
begin
  CreateTestData(false);
  CheckEquals(1,FClsHejIndividuals.IndexOf('Care, Joe'),'Index of "Care, Joe"');
  CheckEquals(0,FClsHejIndividuals.IndexOf('Mustermann, Petra'),'Index of "Mustermann, Petra"');
  CheckEquals(7,FClsHejIndividuals.IndexOf('Musterfrau, Andrea'),'Index of "Musterfrau, Andrea"');
  CheckEquals(6,FClsHejIndividuals.IndexOf('Mustermann, Peter'),'Index of "Mustermann, Peter"');
  CheckEquals(6,FClsHejIndividuals.IndexOf('Mustermann, pEtEr'),'Index of "Mustermann, pEtEr"');
end;

procedure TTestClsIndHej.TestIndexOf2;
begin
  CreateTestData(false);
  CheckEquals(1,FClsHejIndividuals.IndexOf(1),'Index of "Care, Joe"');
  CheckEquals(0,FClsHejIndividuals.IndexOf(0),'Index of "Mustermann, Petra"');
  CheckEquals(7,FClsHejIndividuals.IndexOf(7),'Index of "Musterfrau, Andrea"');
  CheckEquals(6,FClsHejIndividuals.IndexOf(6),'Index of "Mustermann, Peter"');
  CheckEquals(1,FClsHejIndividuals.IndexOf(-1),'Index of "-1"');

end;

procedure TTestClsIndHej.TestIndexOf3;
begin
  CreateTestData(false);
  CheckEquals(1,FClsHejIndividuals.IndexOf(strtodate('21.01.1971')),'Index of "Care, Joe"');
  CheckEquals(0,FClsHejIndividuals.IndexOf(strtodate('21.02.1971')),'Index of "Mustermann, Petra"');
  CheckEquals(9,FClsHejIndividuals.IndexOf(strtodate('01.03.1985')),'Index of "Musterfrau, Andrea"');
  CheckEquals(6,FClsHejIndividuals.IndexOf(strtodate('14.08.1956')),'Index of "Mustermann, Peter"');
  CheckEquals(1,FClsHejIndividuals.IndexOf(strtodate('01.01.1971')),'Index of "1971"');
end;

procedure TTestClsIndHej.TestIndexOf4;
begin
  CreateTestData(false);
  CheckEquals(1,FClsHejIndividuals.IndexOf(VarArrayOf(['Care, Joe',strtodate('21.01.1971')])),'Index of "Care, Joe"');
  CheckEquals(0,FClsHejIndividuals.IndexOf(VarArrayOf(['Mustermann, Petra',strtodate('21.02.1971')])),'Index of "Mustermann, Petra"');
  CheckEquals(9,FClsHejIndividuals.IndexOf(VarArrayOf([strtodate('01.03.1985')])),'Index of "Musterfrau, Andrea"');
  CheckEquals(6,FClsHejIndividuals.IndexOf(VarArrayOf([strtodate('14.08.1956')])),'Index of "Mustermann, Peter"');
  CheckEquals(1,FClsHejIndividuals.IndexOf(VarArrayOf(['Care','joe',strtodate('01.01.1971')])),'Index of "1971"');
end;

procedure TTestClsIndHej.TestSetActualMarriage;
begin
  CreateTestData(false);
//  Check
end;

procedure TTestClsIndHej.TestReadStream;
    var
        lStr: TStream;
    begin
        Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
        lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
          try
            FClsHejIndividuals.ReadFromStream(lStr);
            CheckEquals(4,FClsHejIndividuals.Count,'4 Individuals');
            CheckEquals(738, lStr.Position, 'Stringposition is ');
         finally
            freeandnil(lStr)
          end;

          FClsHejIndividuals.Clear;
          CheckEquals(0,FClsHejIndividuals.Count,'No Individuals');

          Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'), 'Datei existiert');
          lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'BigData5.hej', fmOpenRead);
            try
              FClsHejIndividuals.ReadFromStream(lStr);
              CheckEquals(49302,FClsHejIndividuals.Count,'49302 Individuals');
              CheckEquals(8939706, lStr.Position, 'Stringposition is ');
            finally
              freeandnil(lStr)
            end;
end;

procedure TTestClsIndHej.TestReadStream2;

    var
        lStr: TStream;
        lStl:TMemoryStream;
    begin
        Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
        lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
          try
            FClsHejIndividuals.ReadFromStream(lStr);
            CheckEquals(4,FClsHejIndividuals.Count,'4 Individuals');
            CheckEquals(738, lStr.Position, 'Stringposition is ');
          finally
            freeandnil(lStr)
          end;

          FClsHejIndividuals.Clear;
          CheckEquals(0,FClsHejIndividuals.Count,'No Individuals');

          Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'), 'Datei existiert');
          lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'BigData5.hej', fmOpenRead);

          lStl := TMemoryStream.Create;
            try

              lStl.LoadFromStream(lstr);
              FClsHejIndividuals.ReadFromStream(lStl);
              CheckEquals(49302,FClsHejIndividuals.Count,'49302 Individuals');
              CheckEquals(8939706, lStl.Position, 'Stringposition is ');
            finally
              freeandnil(lStr);
              freeandnil(lStl)
            end;
end;

procedure TTestClsIndHej.TestWriteStream;
begin

end;

{----------------------------------------------}
procedure TTestIndHej.SetUp;
var
    i: integer;
begin
    FHejIndData.Clear;
    FDataDir := DefDataDir;
    for i := 0 to 2 do
        if not DirectoryExists(FDataDir) then
            FDataDir := '..' + DirectorySeparator + FDataDir
        else
            break;
    FDataDir := FDataDir + DirectorySeparator + 'HejTest';
end;

procedure TTestIndHej.TearDown;
begin
    FHejIndData.Clear;
end;

procedure TTestIndHej.TestSetUp;
var
    i: TEnumHejIndDatafields;
begin
    CheckTrue(DirectoryExists(FDataDir),'Data-Directory '+FDataDir+' exists');
    for i in TEnumHejIndDatafields do
        if Ord(i) <= Ord(hind_idMother) then
            CheckEquals(0, FHejIndData.Data[i], 'Data[' + CHejIndDataDesc[i] + '] is 0')
        else
            CheckEquals('', FHejIndData.Data[i], 'Data[' + CHejIndDataDesc[i] +
                '] is ''''');
end;

procedure TTestIndHej.TestID;
var
    lTestValue, lTestValue2: integer;
    lSecVal, i: integer;
begin
    // Test positive
    FHejIndData.ID := 15;
    CheckEquals(15, FHejIndData.ID, 'ID is 15');
    CheckEquals(15, FHejIndData.Data[hind_ID], 'Data[ID] is 15');
    FHejIndData.Data[hind_ID] := 19;
    CheckEquals(19, FHejIndData.ID, 'ID is 19');
    CheckEquals(19, FHejIndData.Data[hind_ID], 'Data[ID] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        FHejIndData.ID := lTestValue;
        CheckEquals(lTestValue, FHejIndData.ID, 'ID is ' + IntToStr(
            lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_ID], 'Data[ID] is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        lTestValue := Random(MaxInt);
        FHejIndData.Data[hind_ID] := lTestValue;
        CheckEquals(lTestValue, FHejIndData.ID, 'ID is ' + IntToStr(
            lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_ID], 'Data[ID] is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejIndData.ID := 15;
    FHejIndData.idFather := 3;
    CheckEquals(15, FHejIndData.ID, 'ID is 15');
    FHejIndData.Data[hind_ID] := 19;
    FHejIndData.idMother := 1234;
    CheckEquals(19, FHejIndData.ID, 'ID is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        lTestValue2 := Random(MaxInt);
        if lTestValue = lTestValue2 then
            Inc(lTestValue2);
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejIndData.ID := lTestValue;
        lSecVal := random(Ord(high(TEnumHejIndDatafields)));
        if lSecval <= Ord(hind_id) then
            Dec(lSecVal);
        FHejIndData.Data[TEnumHejIndDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejIndData.ID, 'ID is still ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_ID], 'Data[ID] is still ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;
end;

procedure TTestIndHej.TestidFather;
var
    lTestValue, lTestValue2: integer;
    lSecVal, i: integer;
begin
    // Test positive
    FHejIndData.idFather := 15;
    CheckEquals(15, FHejIndData.idFather, 'idFather is 15');
    CheckEquals(15, FHejIndData.Data[hind_idFather], 'Data[idFather] is 15');
    FHejIndData.Data[hind_idFather] := 19;
    CheckEquals(19, FHejIndData.idFather, 'idFather is 19');
    CheckEquals(19, FHejIndData.Data[hind_idFather], 'Data[idFather] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        FHejIndData.idFather := lTestValue;
        CheckEquals(lTestValue, FHejIndData.idFather, 'idFather is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_idFather],
            'Data[idFather] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        lTestValue := Random(MaxInt);
        FHejIndData.Data[hind_idFather] := lTestValue;
        CheckEquals(lTestValue, FHejIndData.idFather, 'idFather is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_idFather],
            'Data[idFather] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejIndData.idFather := 15;
    FHejIndData.ID := 3;
    CheckEquals(15, FHejIndData.idFather, 'idFather is 15');
    FHejIndData.Data[hind_idFather] := 19;
    FHejIndData.idMother := 1234;
    CheckEquals(19, FHejIndData.idFather, 'idFather is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        lTestValue2 := Random(MaxInt);
        if lTestValue = lTestValue2 then
            Inc(lTestValue2);
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejIndData.idFather := lTestValue;
        lSecVal := random(Ord(high(TEnumHejIndDatafields)));
        if lSecval <= Ord(hind_idFather) then
            Dec(lSecVal);
        FHejIndData.Data[TEnumHejIndDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejIndData.idFather, 'idFather is still ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_idFather],
            'Data[idFather] is still ' + IntToStr(lTestValue) + ' (' +
            IntToStr(i) + ')');
      end;
end;

procedure TTestIndHej.TestidMother;
var
    lTestValue, lTestValue2: integer;
    lSecVal, i: integer;
begin
    // Test positive
    FHejIndData.idMother := 15;
    CheckEquals(15, FHejIndData.idMother, 'idMother is 15');
    CheckEquals(15, FHejIndData.Data[hind_idMother], 'Data[idMother] is 15');
    FHejIndData.Data[hind_idMother] := 19;
    CheckEquals(19, FHejIndData.idMother, 'idMother is 19');
    CheckEquals(19, FHejIndData.Data[hind_idMother], 'Data[idMother] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        FHejIndData.idMother := lTestValue;
        CheckEquals(lTestValue, FHejIndData.idMother, 'idMother is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_idMother],
            'Data[idMother] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        lTestValue := Random(MaxInt);
        FHejIndData.Data[hind_idMother] := lTestValue;
        CheckEquals(lTestValue, FHejIndData.idMother, 'idMother is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_idMother],
            'Data[idMother] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejIndData.idMother := 15;
    FHejIndData.idFather := 3;
    CheckEquals(15, FHejIndData.idMother, 'idMother is 15');
    FHejIndData.Data[hind_idMother] := 19;
    FHejIndData.FamilyName := 'Mustermann';
    CheckEquals(19, FHejIndData.idMother, 'idMother is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        lTestValue2 := Random(MaxInt);
        if lTestValue = lTestValue2 then
            Inc(lTestValue2);
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejIndData.idMother := lTestValue;
        lSecVal := random(Ord(high(TEnumHejIndDatafields)));
        if lSecval <= Ord(hind_idMother) then
            Dec(lSecVal);
        FHejIndData.Data[TEnumHejIndDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejIndData.idMother, 'idMother is still ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_idMother],
            'Data[idMother] is still ' + IntToStr(lTestValue) + ' (' +
            IntToStr(i) + ')');
      end;
end;

procedure TTestIndHej.TestFamilyName;
var
    lTestValue, lTestValue2: string;
    lSecVal, i: integer;
begin
    // Test positive
    FHejIndData.FamilyName := 'Mustermann';
    CheckEquals('Mustermann', FHejIndData.FamilyName, 'FamilyName is Mustermann');
    CheckEquals('Mustermann', FHejIndData.Data[hind_FamilyName],
        'Data[FamilyName] is ''Mustermann''');
    FHejIndData.Data[hind_FamilyName] := '19';
    CheckEquals('19', FHejIndData.FamilyName, 'FamilyName is 19');
    CheckEquals(19, FHejIndData.Data[hind_FamilyName], 'Data[FamilyName] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.FamilyName := lTestValue;
        CheckEquals(lTestValue, FHejIndData.FamilyName, 'FamilyName is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_FamilyName],
            'Data[FamilyName] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.Data[hind_FamilyName] := lTestValue;
        CheckEquals(lTestValue, FHejIndData.FamilyName, 'FamilyName is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_FamilyName],
            'Data[FamilyName] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejIndData.FamilyName := '15';
    FHejIndData.idmother := 3;
    CheckEquals('15', FHejIndData.FamilyName, 'FamilyName is 15');
    FHejIndData.Data[hind_FamilyName] := 19;
    FHejIndData.GivenName := 'Peter';
    CheckEquals('19', FHejIndData.FamilyName, 'FamilyName is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        lTestValue2 := IntToStr(Random(MaxInt));
        if lTestValue = lTestValue2 then
            lTestValue2 := '-' + lTestValue2;
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejIndData.FamilyName := lTestValue;
        lSecVal := random(Ord(high(TEnumHejIndDatafields)));
        if lSecval <= Ord(hind_FamilyName) then
            Dec(lSecVal);
        FHejIndData.Data[TEnumHejIndDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejIndData.FamilyName, 'FamilyName is still ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_FamilyName],
            'Data[FamilyName] is still ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;
end;

procedure TTestIndHej.TestGivenName;
var
    lTestValue, lTestValue2: string;
    lSecVal, i: integer;
begin
    // Test positive
    FHejIndData.GivenName := 'Mustermann';
    CheckEquals('Mustermann', FHejIndData.GivenName, 'GivenName is Mustermann');
    CheckEquals('Mustermann', FHejIndData.Data[hind_GivenName],
        'Data[GivenName] is ''Mustermann''');
    FHejIndData.Data[hind_GivenName] := '19';
    CheckEquals('19', FHejIndData.GivenName, 'GivenName is 19');
    CheckEquals(19, FHejIndData.Data[hind_GivenName], 'Data[GivenName] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.GivenName := lTestValue;
        CheckEquals(lTestValue, FHejIndData.GivenName, 'GivenName is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_GivenName],
            'Data[GivenName] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.Data[hind_GivenName] := lTestValue;
        CheckEquals(lTestValue, FHejIndData.GivenName, 'GivenName is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_GivenName],
            'Data[GivenName] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejIndData.GivenName := '15';
    FHejIndData.FamilyName := 'Mustermann';
    CheckEquals('15', FHejIndData.GivenName, 'GivenName is 15');
    FHejIndData.Data[hind_GivenName] := 19;
    FHejIndData.Sex := 'm';
    CheckEquals('19', FHejIndData.GivenName, 'GivenName is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        lTestValue2 := IntToStr(Random(MaxInt));
        if lTestValue = lTestValue2 then
            lTestValue2 := '-' + lTestValue2;
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejIndData.GivenName := lTestValue;
        lSecVal := random(Ord(high(TEnumHejIndDatafields)));
        if lSecval <= Ord(hind_GivenName) then
            Dec(lSecVal);
        FHejIndData.Data[TEnumHejIndDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejIndData.GivenName, 'GivenName is still ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_GivenName],
            'Data[GivenName] is still ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;
end;

procedure TTestIndHej.TestSex;
var
    lTestValue, lTestValue2: string;
    lSecVal, i: integer;
begin
    // Test positive
    FHejIndData.Sex := 'm';
    CheckEquals('m', FHejIndData.Sex, 'Sex is m');
    CheckEquals('m', FHejIndData.Data[hind_Sex],
        'Data[Sex] is ''m''');
    FHejIndData.Data[hind_Sex] := '19';
    CheckEquals('19', FHejIndData.Sex, 'Sex is 19');
    CheckEquals(19, FHejIndData.Data[hind_Sex], 'Data[Sex] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.Sex := lTestValue;
        CheckEquals(lTestValue, FHejIndData.Sex, 'Sex is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_Sex],
            'Data[Sex] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.Data[hind_Sex] := lTestValue;
        CheckEquals(lTestValue, FHejIndData.Sex, 'Sex is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_Sex],
            'Data[Sex] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejIndData.Sex := 'w';
    FHejIndData.GivenName := 'Peter';
    CheckEquals('w', FHejIndData.Sex, 'Sex is w');
    FHejIndData.Data[hind_Sex] := 19;
    FHejIndData.Religion := 'ev';
    CheckEquals('19', FHejIndData.Sex, 'Sex is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        lTestValue2 := IntToStr(Random(MaxInt));
        if lTestValue = lTestValue2 then
            lTestValue2 := '-' + lTestValue2;
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejIndData.Sex := lTestValue;
        lSecVal := random(Ord(high(TEnumHejIndDatafields)));
        if lSecval <= Ord(hind_Sex) then
            Dec(lSecVal);
        FHejIndData.Data[TEnumHejIndDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejIndData.Sex, 'Sex is still ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_Sex],
            'Data[Sex] is still ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;
end;

procedure TTestIndHej.TestReligion;
var
    lTestValue, lTestValue2: string;
    lSecVal, i: integer;
begin
    // Test positive
    FHejIndData.Religion := 'ev';
    CheckEquals('ev', FHejIndData.Religion, 'Religion is ev');
    CheckEquals('ev', FHejIndData.Data[hind_Religion],
        'Data[Religion] is ''ev''');
    FHejIndData.Data[hind_Religion] := '19';
    CheckEquals('19', FHejIndData.Religion, 'Religion is 19');
    CheckEquals(19, FHejIndData.Data[hind_Religion], 'Data[Religion] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.Religion := lTestValue;
        CheckEquals(lTestValue, FHejIndData.Religion, 'Religion is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_Religion],
            'Data[Religion] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.Data[hind_Religion] := lTestValue;
        CheckEquals(lTestValue, FHejIndData.Religion, 'Religion is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_Religion],
            'Data[Religion] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejIndData.Religion := 'ev';
    FHejIndData.Sex := 'm';
    CheckEquals('ev', FHejIndData.Religion, 'Religion is ev');
    FHejIndData.Data[hind_Religion] := 19;
    FHejIndData.Occupation := 'ev';
    CheckEquals('19', FHejIndData.Religion, 'Religion is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        lTestValue2 := IntToStr(Random(MaxInt));
        if lTestValue = lTestValue2 then
            lTestValue2 := '-' + lTestValue2;
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejIndData.Religion := lTestValue;
        lSecVal := random(Ord(high(TEnumHejIndDatafields)));
        if lSecval <= Ord(hind_Religion) then
            Dec(lSecVal);
        FHejIndData.Data[TEnumHejIndDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejIndData.Religion, 'Religion is still ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_Religion],
            'Data[Religion] is still ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;
end;

procedure TTestIndHej.TestOccupation;
var
    lTestValue, lTestValue2: string;
    lSecVal, i: integer;
begin
    // Test positive
    FHejIndData.Occupation := 'Landwirt';
    CheckEquals('Landwirt', FHejIndData.Occupation, 'Occupation is Landwirt');
    CheckEquals('Landwirt', FHejIndData.Data[hind_Occupation],
        'Data[Occupation] is ''Landwirt''');
    FHejIndData.Data[hind_Occupation] := '19';
    CheckEquals('19', FHejIndData.Occupation, 'Occupation is 19');
    CheckEquals(19, FHejIndData.Data[hind_Occupation], 'Data[Occupation] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.Occupation := lTestValue;
        CheckEquals(lTestValue, FHejIndData.Occupation, 'Occupation is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_Occupation],
            'Data[Occupation] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
        lTestValue := IntToStr(Random(MaxInt));
        FHejIndData.Data[hind_Occupation] := lTestValue;
        CheckEquals(lTestValue, FHejIndData.Occupation, 'Occupation is ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_Occupation],
            'Data[Occupation] is ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejIndData.Occupation := 'Landwirt';
    FHejIndData.Religion := 'ev';
    CheckEquals('Landwirt', FHejIndData.Occupation, 'Occupation is Landwirt');
    FHejIndData.Data[hind_Occupation] := 19;
    FHejIndData.BirthDay := '01';
    CheckEquals('19', FHejIndData.Occupation, 'Occupation is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := IntToStr(Random(MaxInt));
        lTestValue2 := IntToStr(Random(MaxInt));
        if lTestValue = lTestValue2 then
            lTestValue2 := '-' + lTestValue2;
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejIndData.Occupation := lTestValue;
        lSecVal := random(Ord(high(TEnumHejIndDatafields)));
        if lSecval <= Ord(hind_Occupation) then
            Dec(lSecVal);
        FHejIndData.Data[TEnumHejIndDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejIndData.Occupation, 'Occupation is still ''' +
            lTestValue + ''' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejIndData.Data[hind_Occupation],
            'Data[Occupation] is still ''' + lTestValue + ''' (' + IntToStr(i) + ')');
      end;
end;

procedure TTestIndHej.TestBirthDay;
begin

end;

procedure TTestIndHej.TestBirthMonth;
begin

end;

procedure TTestIndHej.TestBirthYear;
begin

end;

procedure TTestIndHej.TestBirthplace;
begin

end;

procedure TTestIndHej.TestBaptDay;
begin

end;

procedure TTestIndHej.TestBaptMonth;
begin

end;

procedure TTestIndHej.TestBaptYear;
begin

end;

procedure TTestIndHej.TestBaptPlace;
begin

end;

procedure TTestIndHej.TestGodparents;
begin

end;

procedure TTestIndHej.TestResidence;
begin

end;

procedure TTestIndHej.TestDeathDay;
begin

end;

procedure TTestIndHej.TestDeathMonth;
begin

end;

procedure TTestIndHej.TestDeathYear;
begin

end;

procedure TTestIndHej.TestDeathPlace;
begin

end;

procedure TTestIndHej.TestDeathReason;
begin

end;

procedure TTestIndHej.TestBurialDay;
begin

end;

procedure TTestIndHej.TestBurialMonth;
begin

end;

procedure TTestIndHej.TestBurialYear;
begin

end;

procedure TTestIndHej.TestBurialPlace;
begin

end;

procedure TTestIndHej.TestBirthSource;
begin

end;

procedure TTestIndHej.TestBaptSource;
begin

end;

procedure TTestIndHej.TestDeathSource;
begin

end;

procedure TTestIndHej.TestBurialSource;
begin

end;

procedure TTestIndHej.TestText;
begin

end;

procedure TTestIndHej.TestLiving;
begin

end;

procedure TTestIndHej.TestAKA;
begin

end;

procedure TTestIndHej.TestIndex;
begin

end;

procedure TTestIndHej.TestAdopted;
begin

end;

procedure TTestIndHej.TestFarmName;
begin

end;

procedure TTestIndHej.TestAdrStreet;
begin

end;

procedure TTestIndHej.TestAdrAddit;
begin

end;

procedure TTestIndHej.TestAdrPLZ;
begin

end;

procedure TTestIndHej.TestAdrPlace;
begin

end;

procedure TTestIndHej.TestAdrPlaceAdd;
begin

end;

procedure TTestIndHej.TestFree1;
begin

end;

procedure TTestIndHej.TestFree2;
begin

end;

procedure TTestIndHej.TestFree3;
begin

end;

procedure TTestIndHej.TestAge;
begin

end;

procedure TTestIndHej.TestPhone;
begin

end;

procedure TTestIndHej.TesteMail;
begin

end;

procedure TTestIndHej.TestWebAdr;
begin

end;

procedure TTestIndHej.TestNameSource;
begin

end;

procedure TTestIndHej.TestCallName;
begin

end;

procedure TTestIndHej.TestEquals;
var
  j: TEnumHejIndDatafields;
  i: Integer;
begin
  FHejIndData := cInd[1];
  Checktrue(FHejIndData.Equals(FHejIndData),'Prüfe direkte Übereinstimmung');
  for j in TEnumHejIndDatafields do
    begin
      FHejIndData.Data[j]:= 987600+random(100);
      CheckNotEquals(string(FHejIndData.Data[j]),string(cind[1].Data[j]),'Prüfe zuerst ob daten nicht übereinstimmen['+CHejIndDataDesc[j]+']');
      // Strict
      if j>hind_ID then
        begin
      CheckFalse(FHejIndData.Equals(cind[1]),'Prüfe nicht-Übereinstimmung');
      CheckFalse(cInd[1].Equals(FHejIndData),'Prüfe nicht-Übereinstimmung2');
        end
      else
        begin
      CheckTrue(FHejIndData.Equals(cind[1]),'Prüfe dennoch-Übereinstimmung');
      CheckTrue(cInd[1].Equals(FHejIndData),'Prüfe dennoch-Übereinstimmung2');
        end;
      // only Data
        if j>hind_idMother then
          begin
        CheckFalse(FHejIndData.Equals(cind[1],True),'Prüfe nicht-Übereinstimmung3');
        CheckFalse(cInd[1].Equals(FHejIndData,True),'Prüfe nicht-Übereinstimmung4');
          end
        else
          begin
        CheckTrue(FHejIndData.Equals(cind[1],True),'Prüfe dennoch-Übereinstimmung3');
        CheckTrue(cInd[1].Equals(FHejIndData,True),'Prüfe dennoch-Übereinstimmung4');
          end;

      FHejIndData.Data[j]:=cind[1].data[j];
      CheckTrue(FHejIndData.Equals(cind[1]),'Prüfe wieder Übereinstimmung');
    end;
  for i := 0 to high(cInd) do
    begin
      FHejIndData := cInd[i];
      Checktrue(FHejIndData.Equals(FHejIndData),'I'+inttostr(i)+'] Prüfe direkte Übereinstimmung');
      for j in TEnumHejIndDatafields do
        begin
          FHejIndData.Data[j]:= 123400+random(100);
          CheckNotEquals(string(FHejIndData.Data[j]),string(cind[i].Data[j]),'I'+inttostr(i)+'] Prüfe zuerst ob daten nicht übereinstimmen['+CHejIndDataDesc[j]+']');
          // Strict
          if j>hind_ID then
            begin
          CheckFalse(FHejIndData.Equals(cind[i]),'I'+inttostr(i)+'] Prüfe nicht-Übereinstimmung');
          CheckFalse(cInd[i].Equals(FHejIndData),'I'+inttostr(i)+'] Prüfe nicht-Übereinstimmung2');
            end
          else
            begin
          CheckTrue(FHejIndData.Equals(cind[i]),'I'+inttostr(i)+'] Prüfe dennoch-Übereinstimmung');
          CheckTrue(cInd[i].Equals(FHejIndData),'I'+inttostr(i)+'] Prüfe dennoch-Übereinstimmung2');
            end;
          // only Data
            if j>hind_idMother then
              begin
            CheckFalse(FHejIndData.Equals(cind[i],True),'I'+inttostr(i)+'] Prüfe nicht-Übereinstimmung3');
            CheckFalse(cInd[i].Equals(FHejIndData,True),'I'+inttostr(i)+'] Prüfe nicht-Übereinstimmung4');
              end
            else
              begin
            CheckTrue(FHejIndData.Equals(cind[i],True),'I'+inttostr(i)+'] Prüfe dennoch-Übereinstimmung3');
            CheckTrue(cInd[i].Equals(FHejIndData,True),'I'+inttostr(i)+'] Prüfe dennoch-Übereinstimmung4');
              end;

          FHejIndData.Data[j]:=cind[i].data[j];
          CheckTrue(FHejIndData.Equals(cind[i]),'I'+inttostr(i)+'] Prüfe wieder Übereinstimmung');
        end;
    end;
end;

procedure TTestIndHej.TestReadStream;
var
    lStr: TStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        FHejIndData.ReadFromStream(lStr);
        CheckEquals(1, FHejIndData.id, 'ID is 1');
        CheckEquals(0, FHejIndData.idFather, 'idFather is 0');
        CheckEquals(0, FHejIndData.idMother, 'idMother is 0');
        CheckEquals('Care', FHejIndData.FamilyName, 'FamilyName is Care');
        CheckEquals('Joe', FHejIndData.GivenName, 'GivenName is Joe');
        CheckEquals('m', FHejIndData.Sex, 'Sex is m');
        CheckEquals('Be', FHejIndData.Religion, 'Religion is Be');
        CheckEquals('n', FHejIndData.Living, 'Living is j');
        CheckEquals('Joker', FHejIndData.CallName, 'Callname is Joker');
        CheckEquals('I0001', FHejIndData.Index, 'Living is j');
        CheckEquals('JaySee', FHejIndData.AKA, 'Callname is Joker');
        FHejIndData.ReadFromStream(lStr);
        CheckEquals(2, FHejIndData.id, 'ID is 2');
        CheckEquals(3, FHejIndData.idFather, 'idFather is 3');
        CheckEquals(4, FHejIndData.idMother, 'idMother is 4');
        CheckEquals('Ute', FHejIndData.FamilyName, 'FamilyName is Ute');
        CheckEquals('Comp', FHejIndData.GivenName, 'GivenName is Comp');
        CheckEquals('w', FHejIndData.Sex, 'Sex is w');
        CheckEquals('co', FHejIndData.Religion, 'Religion is co');
        CheckEquals('j', FHejIndData.Living, 'Living is j');
        CheckEquals('Compy', FHejIndData.CallName, 'Callname is Compy');
        CheckEquals(490, lStr.Position, 'Stringposition is ');
        FHejIndData.ReadFromStream(lStr);
        FHejIndData.ReadFromStream(lStr);
        CheckEquals(738, lStr.Position, 'Stringposition is ');
      finally
        FreeAndNil(lStr);
      end;
end;

procedure TTestIndHej.TestWriteStream;
    var
        lStr: TStream;
    begin
      lStr:=TMemoryStream.Create;
      try
        cInd[6].WriteToStream(lStr);
        CheckEquals(146,lStr.Position,'Stringposition is ');
        cInd[7].WriteToStream(lStr);
        CheckEquals(241,lStr.Position,'Stringposition 2 is ');
        cInd[5].WriteToStream(lStr);
        CheckEquals(241,lStr.Position,'Stringposition 3 is ');
      finally
        FreeAndNil(lStr);
      end;

        if FileExists(FDataDir + DirectorySeparator + 'Care_out.ihej') then
           deleteFile(FDataDir + DirectorySeparator + 'Care_out.ihej');
        lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care_out.ihej', fmCreate + fmOpenWrite);
          try
            cInd[6].WriteToStream(lStr);
            cInd[7].WriteToStream(lStr);
          finally
            FreeAndNil(lStr);
          end;

end;

procedure TTestIndHej.TestAppendChild;
begin
  CheckEquals(0,FHejIndData.ChildCount,'Anfang: Keine Kinder');
  FHejIndData.AppendChild(1);
  CheckEquals(1,FHejIndData.ChildCount,'1 Kind');
  CheckEquals(1,FHejIndData.Children[0],'1. Kind');
  FHejIndData.AppendChild(1);
  CheckEquals(1,FHejIndData.ChildCount,'Noch 1 Kind');
  CheckEquals(1,FHejIndData.Children[0],'1. Kind');
  FHejIndData.AppendChild(2);
  CheckEquals(2,FHejIndData.ChildCount,'2 Kinder');
  CheckEquals(1,FHejIndData.Children[0],'1. Kind');
  CheckEquals(2,FHejIndData.Children[1],'2. Kind');
  FHejIndData.AppendChild(1);
  CheckEquals(2,FHejIndData.ChildCount,'Noch 2 Kinder');
  CheckEquals(1,FHejIndData.Children[0],'1. Kind');
  CheckEquals(2,FHejIndData.Children[1],'2. Kind');
  FHejIndData.AppendChild(3);
  CheckEquals(3,FHejIndData.ChildCount,'3 Kinder');
  CheckEquals(1,FHejIndData.Children[0],'1. Kind');
  CheckEquals(2,FHejIndData.Children[1],'2. Kind');
  CheckEquals(3,FHejIndData.Children[2],'3. Kind');
end;

procedure TTestIndHej.TestAppendMarriage;
begin
  CheckEquals(0,FHejIndData.SpouseCount,'Anfang: Keine Ehen');
  FHejIndData.AppendMarriage(1);
  CheckEquals(1,FHejIndData.SpouseCount,'1 Ehe');
  CheckEquals(1,FHejIndData.Marriages[0],'1. Ehe');
  FHejIndData.AppendMarriage(1);
  CheckEquals(1,FHejIndData.SpouseCount,'Noch 1 Ehe');
  CheckEquals(1,FHejIndData.Marriages[0],'1. Ehe');
  FHejIndData.AppendMarriage(2);
  CheckEquals(2,FHejIndData.SpouseCount,'2 Ehen');
  CheckEquals(1,FHejIndData.Marriages[0],'1. Ehe');
  CheckEquals(2,FHejIndData.Marriages[1],'2. Ehe');
  FHejIndData.AppendMarriage(1);
  CheckEquals(2,FHejIndData.SpouseCount,'Noch 2 Ehen');
  CheckEquals(1,FHejIndData.Marriages[0],'1. Ehe');
  CheckEquals(2,FHejIndData.Marriages[1],'2. Ehe');
  FHejIndData.AppendMarriage(3);
  CheckEquals(3,FHejIndData.SpouseCount,'3 Ehen');
  CheckEquals(1,FHejIndData.Marriages[0],'1. Ehe');
  CheckEquals(2,FHejIndData.Marriages[1],'2. Ehe');
  CheckEquals(3,FHejIndData.Marriages[2],'3. Ehe');

end;

procedure TTestIndHej.testRemoveParent;
begin
  CheckEquals(0,FHejIndData.ParentCount,'Anfang: Kein Elternteil');
  FHejIndData.idFather := 4;
  FHejIndData.idMother := 3;
  CheckEquals(2,FHejIndData.ParentCount,'Ausgangstest: 2 Eltern');
  FHejIndData.RemoveParent(5);;
  CheckEquals(2,FHejIndData.ParentCount,'Immernoch: 2 Eltern');
  FHejIndData.RemoveParent(4);
  CheckEquals(1,FHejIndData.ParentCount,'Noch: 1 Elternteil');
  CheckEquals(0,FHejIndData.idFather,'Kein Vater (1)');
  CheckEquals(3,FHejIndData.idMother,'Nur Mutter (1)');
  FHejIndData.RemoveParent(2);
  CheckEquals(1,FHejIndData.ParentCount,'Immernoch: 1 Elternteil(2)');
  CheckEquals(0,FHejIndData.idFather,'Kein Vater (2)');
  CheckEquals(3,FHejIndData.idMother,'Nur Mutter (2)');
  FHejIndData.RemoveParent(3);
  CheckEquals(0,FHejIndData.ParentCount,'Kein Elternteil');
  CheckEquals(0,FHejIndData.idFather,'Kein Vater (3)');
  CheckEquals(0,FHejIndData.idMother,'Keine Mutter (3)');

  FHejIndData.idFather := 6;
  FHejIndData.idMother := 6;
  CheckEquals(2,FHejIndData.ParentCount,'Ausgangstest2: 2 Eltern');
  FHejIndData.RemoveParent(5);
  CheckEquals(2,FHejIndData.ParentCount,'Immernoch: 2 Eltern(6)');
  FHejIndData.RemoveParent(6);
  CheckEquals(0,FHejIndData.ParentCount,'Kein Elternteil');
  CheckEquals(0,FHejIndData.idFather,'Kein Vater (4)');
  CheckEquals(0,FHejIndData.idMother,'Keine Mutter (4)');
end;

procedure TTestIndHej.testRemoveChild;
begin
  CheckEquals(0,FHejIndData.ChildCount,'Anfang: Keine Kinder');
  FHejIndData.AppendChild(1);
  FHejIndData.AppendChild(2);
  FHejIndData.AppendChild(3);
  FHejIndData.AppendChild(4);
  FHejIndData.AppendChild(5);
  FHejIndData.AppendChild(6);
  CheckEquals(6,FHejIndData.ChildCount,'Ausgangstest: 6 Kinder');
  FHejIndData.RemoveChild(0);
  CheckEquals(6,FHejIndData.ChildCount,'Test(2): 6 Kinder');
  FHejIndData.RemoveChild(9);
  CheckEquals(6,FHejIndData.ChildCount,'Test(3): 6 Kinder');
  FHejIndData.RemoveChild(3);
  CheckEquals(5,FHejIndData.ChildCount,'Test(4): 5 Kinder');
  CheckEquals(1,FHejIndData.Children[0],'1. Kind');
  CheckEquals(2,FHejIndData.Children[1],'2. Kind');
  CheckEquals(4,FHejIndData.Children[2],'3. Kind');
  CheckEquals(5,FHejIndData.Children[3],'4. Kind');
  CheckEquals(6,FHejIndData.Children[4],'5. Kind');
  FHejIndData.RemoveChild(3);
  CheckEquals(5,FHejIndData.ChildCount,'Test(5): 5 Kinder');
  CheckEquals(1,FHejIndData.Children[0],'1. Kind');
  CheckEquals(2,FHejIndData.Children[1],'2. Kind');
  CheckEquals(4,FHejIndData.Children[2],'3. Kind');
  CheckEquals(5,FHejIndData.Children[3],'4. Kind');
  CheckEquals(6,FHejIndData.Children[4],'5. Kind');

end;

procedure TTestIndHej.testRemoveMarriage;

  function iHash(i:integer):integer;
  begin
    result:=$10ECA8E xor ((i+1)*11)
  end;

 var
  i, lSCount: Integer;

begin
  CheckEquals(0,FHejIndData.SpouseCount,'Anfang: Keine Ehen');
  setlength(FHejIndData.Marriages,10);
  for i := 0 to high(FHejIndData.Marriages) do
    FHejIndData.Marriages[i]:= iHash(i);

  CheckEquals(10,FHejIndData.SpouseCount,'10 Ehen');
  CheckEquals(iHash(0),FHejIndData.Marriages[0],'1. Ehe');

  FHejIndData.RemoveMarriage(iHash(1));
  CheckEquals(9,FHejIndData.SpouseCount,'Noch 9 Ehen');
  CheckEquals(iHash(2),FHejIndData.Marriages[1],'3. Ehe');

  FHejIndData.RemoveMarriage(iHash(5));
  CheckEquals(8,FHejIndData.SpouseCount,'Noch 8 Ehen');
  CheckEquals(iHash(6),FHejIndData.Marriages[4],'8. Ehe');

  lSCount:= 8;
  for i := 0 to 9 do
    begin
      FHejIndData.RemoveMarriage(iHash(i));
      if not (i in [1,5]) then
        dec(lSCount);
      CheckEquals(lSCount,FHejIndData.SpouseCount,'Noch '+inttostr(lSCount)+' Ehen');
    end;
  CheckEquals(0,FHejIndData.SpouseCount,'keine Ehen');

end;

procedure TTestIndHej.testDeleteChild;
function iHash(i:integer):integer;
begin
  result:=$10ECA8E xor ((i+1)*11)
end;

var
i, lSCount: Integer;

begin
CheckEquals(0,FHejIndData.ChildCount,'Anfang: Keine Children');
setlength(FHejIndData.Children,10);
for i := 0 to high(FHejIndData.Children) do
  FHejIndData.Children[i]:= iHash(i);

CheckEquals(10,FHejIndData.ChildCount,'10 Children');
CheckEquals(iHash(0),FHejIndData.Children[0],'1. Child');

FHejIndData.DeleteChild(1);
CheckEquals(9,FHejIndData.ChildCount,'Noch 9 Children');
CheckEquals(iHash(2),FHejIndData.Children[1],'2. Child');

FHejIndData.DeleteChild(4);
CheckEquals(8,FHejIndData.ChildCount,'Noch 8 Children');
CheckEquals(iHash(6),FHejIndData.Children[4],'5. Child');

for i := 7 downto 0 do
  begin
    FHejIndData.DeleteChild(random(i+1));
    CheckEquals(i,FHejIndData.ChildCount,'Noch '+inttostr(lSCount)+' Children');
  end;
CheckEquals(0,FHejIndData.ChildCount,'keine Children');

end;

procedure TTestIndHej.testDeleteMarriage;

function iHash(i:integer):integer;

begin
  result:=$10ECA8E xor ((i+1)*11)
end;

var
i, lSCount: Integer;

begin
CheckEquals(0,FHejIndData.SpouseCount,'Anfang: Keine Ehen');
setlength(FHejIndData.Marriages,10);
for i := 0 to high(FHejIndData.Marriages) do
  FHejIndData.Marriages[i]:= iHash(i);

CheckEquals(10,FHejIndData.SpouseCount,'10 Ehen');
CheckEquals(iHash(0),FHejIndData.Marriages[0],'1. Ehe');

FHejIndData.DeleteMarriage(1);
CheckEquals(9,FHejIndData.SpouseCount,'Noch 9 Ehen');
CheckEquals(iHash(2),FHejIndData.Marriages[1],'2. Ehe');

FHejIndData.DeleteMarriage(4);
CheckEquals(8,FHejIndData.SpouseCount,'Noch 8 Ehen');
CheckEquals(iHash(6),FHejIndData.Marriages[4],'5. Ehe');

for i := 7 downto 0 do
  begin
    FHejIndData.DeleteMarriage(random(i+1));
    CheckEquals(i,FHejIndData.SpouseCount,'Noch '+inttostr(lSCount)+' Ehen');
  end;
CheckEquals(0,FHejIndData.SpouseCount,'keine Ehen');
end;

procedure TTestIndHej.TestToString;
var
  lStr: TStream;
begin
  CheckEquals('Mustermann, Peter ( *14.08.1956) in Neunkirchen',cInd[6].ToString,'cInd[6].ToString');
  CheckEquals('Musterfrau, Andrea ( *22.04.1959)',cInd[7].ToString,'cInd[6].ToString');
  Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
  lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
    try
      FHejIndData.ReadFromStream(lStr);
      CheckEquals('Care, Joe ( *21.01.1971 +af.03.2069) in Baden',FHejIndData.ToString,'FHejIndData[0].ToString');
      FHejIndData.ReadFromStream(lStr);
      CheckEquals('Ute, Comp () in Computerland',FHejIndData.ToString,'FHejIndData[1].ToString');
      FHejIndData.ReadFromStream(lStr);
      CheckEquals('Ute, Karl () in Computerland',FHejIndData.ToString,'FHejIndData[2].ToString');
      FHejIndData.ReadFromStream(lStr);
      CheckEquals('Ute, Elsa () in Computerland',FHejIndData.ToString,'FHejIndData[3].ToString');
    finally
      FreeAndNil(lstr);
    end;
end;

procedure TTestIndHej.TestToPasStruct;
var
  lStr: TStream;
begin
  CheckEquals('(ID:6;idFather:3;idMother:4;FamilyName:''Mustermann'';GivenName:'''+
  'Peter'';Sex:''m'';Religion:''ev'';Occupation:''Arbeiter'';BirthDay:''14'';Birt'+
  'hMonth:''08'';BirthYear:''1956'';Birthplace:''Hamburg'';BaptDay:''21'';BaptMont'+
  'h:''09'';BaptYear:''1956'';BaptPlace:''Hamburg-Altona'';Godparents:''The Fary G'+
  'odmother'';Residence:''Neunkirchen'';DeathDay:'''';DeathMonth:'''';DeathYear:'''+
  ''';DeathPlace:'''';DeathReason:'''';BurialDay:'''';BurialMonth:'''';BurialYear:'+
  ''''';BurialPlace:'''';BirthSource:'''';BaptSource:'''';DeathSource:'''';BurialS'+
  'ource:'''';Text:'''';Living:'''';AKA:'''';Index:'''';Adopted:'''';FarmName:'''''+
  ';AdrStreet:'''';AdrAddit:'''';AdrPLZ:'''';AdrPlace:'''';AdrPlaceAdd:'''';Free1:'+
  ''''';Free2:'''';Free3:'''';Age:'''';Phone:'''';eMail:'''';WebAdr:'''';NameSourc'+
  'e:'''';CallName:''''{%H-})',cInd[6].ToPasStruct,'cInd[6].ToPasStruct');
  CheckEquals('(ID:7;idFather:0;idMother:0;FamilyName:''Musterfrau'';GivenName:'''+
  'Andrea'';Sex:''w'';Religion:''rk'';Occupation:''Sachbearbeiter'';BirthDay:''22'';'+
  'BirthMonth:''04'';BirthYear:''1959'';Birthplace:'''';BaptDay:'''';BaptMonth:'''+
  ''';BaptYear:'''';Bapt'+
  'Place:'''';Godparents:'''';Residence:'''';DeathDay:'''';DeathMonth:'''';DeathY'+
  'ear:'''';DeathPlace:'''';DeathReason:'''';BurialDay:'''';BurialMonth:'''';Buri'+
  'alYear:'''';BurialPlace:'''';BirthSource:'''';BaptSource:'''';DeathSource:'''''+
  ';BurialSource:'''';Text:'''';Living:'''';AKA:'''';Index:'''';Adopted:'''';Farm'+
  'Name:'''';AdrStreet:'''';AdrAddit:'''';AdrPLZ:'''';AdrPlace:'''';AdrPlaceAdd:'''+
  ''';Free1:'''';Free2:'''';Free3:'''';Age:'''';Phone:'''';eMail:'''';WebAdr:'''';'+
  'NameSource:'''';CallName:''''{%H-})',cInd[7].ToPasStruct,'cInd[7].ToPasStruct');
  Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
  lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
    try
      FHejIndData.ReadFromStream(lStr);
      CheckEquals('(ID:1;idFather:0;idMother:0;FamilyName:''Care'';GivenName:''J'+
  'oe'';Sex:''m'';Religion:''Be'';Occupation:''Beruf'';BirthDay:''21'';BirthMont'+
  'h:''01'';BirthYear:''1971'';Birthplace:''Eppingen'';BaptDay:''bf'';BaptMonth:'+
  '''02'';BaptYear:''1972'';BaptPlace:''Sulzfeld'';Godparents:''Uwe Care'';Resid'+
  'ence:''Baden'';DeathDay:''af'';DeathMonth:''03'';DeathYear:''2069'';DeathPlac'+
  'e:''Binau'';DeathReason:''TU'';BurialDay:''ca'';BurialMonth:''04'';BurialYear'+
  ':''2070'';BurialPlace:''Mosbach'';BirthSource:''Geburtsurkunde'';BaptSource:'''+
  'Taufbuch'';DeathSource:''Sterbeanzeige'';BurialSource:''Friedhof Mosbach'';Te'+
  'xt:''Dies ist ein Text zu Joe Care'+lineending+'2. Zeile'+LineEnding+''';Living'+
  ':''n'';AKA:''JaySee'';Index:''I0001'';Adopted:''Ad'';FarmName:''Hofname'';Adr'+
  'Street:''Baumstr. 42'';AdrAddit:''Himmelhof'';AdrPLZ:''D74821'';AdrPlace:''Mö'+
  'rtelstein'';AdrPlaceAdd:''am Neckar'';Free1:''98'';Free2:''97'';Free3:''96'';'+
  'Age:''ca. 98 J'';Phone:''0800 330 1000'';eMail:''test@jc99.de'';WebAdr:''www.'+
  'jc99.de'';NameSource:''hörensagen'';CallName:''Joker''{%H-})',FHejIndData.ToPasStruct,'FHejIndData[0].ToPasStruct');
      FHejIndData.ReadFromStream(lStr);
      CheckEquals('(ID:2;idFather:3;idMother:4;FamilyName:''Ute'';GivenName:''Comp'';Sex:''w'';Religion:''co'';Occupation:''Rechengehilfin'';BirthDay:'''';BirthMonth:'''';BirthYear:'''';Birthplace:'''';BaptDay:'''';BaptMonth:'''';BaptYear:'''';BaptPlace:'''';Godparents:'''';Residence:''Computerland'';DeathDay:'''';DeathMonth:'''';DeathYear:'''';DeathPlace:'''';DeathReason:'''';BurialDay:'''';BurialMonth:'''';BurialYear:'''';BurialPlace:'''';BirthSource:'''';BaptSource:'''';DeathSource:'''';BurialSource:'''';Text:'''';Living:''j'';AKA:''Comp J. Uda'';Index:''I00002'';Adopted:''V'';FarmName:'''';AdrStreet:'''';AdrAddit:'''';AdrPLZ:'''';AdrPlace:'''';AdrPlaceAdd:'''';Free1:'''';Free2:'''';Free3:'''';Age:'''';Phone:'''';eMail:'''';WebAdr:'''';NameSource:''Rechnung'';CallName:''Compy''{%H-})',FHejIndData.ToPasStruct,'FHejIndData[1].ToPasStruct');
      FHejIndData.ReadFromStream(lStr);
      CheckEquals('(ID:3;idFather:0;idMother:0;FamilyName:''Ute'';GivenName:''Karl'';Sex:''m'';Religion:''co'';Occupation:''Rechengehilfin'';BirthDay:'''';BirthMonth:'''';BirthYear:'''';Birthplace:'''';BaptDay:'''';BaptMonth:'''';BaptYear:'''';BaptPlace:'''';Godparents:'''';Residence:''Computerland'';DeathDay:'''';DeathMonth:'''';DeathYear:'''';DeathPlace:'''';DeathReason:'''';BurialDay:'''';BurialMonth:'''';BurialYear:'''';BurialPlace:'''';BirthSource:'''';BaptSource:'''';DeathSource:'''';BurialSource:''1'';Text:'''';Living:''j'';AKA:''Comp J. Uda'';Index:''I00003'';Adopted:'''';FarmName:'''';AdrStreet:'''';AdrAddit:'''';AdrPLZ:'''';AdrPlace:'''';AdrPlaceAdd:'''';Free1:'''';Free2:'''';Free3:'''';Age:'''';Phone:'''';eMail:'''';WebAdr:'''';NameSource:''Rechnung'';CallName:''Compy''{%H-})',FHejIndData.ToPasStruct,'FHejIndData[2].ToPasStruct');
      FHejIndData.ReadFromStream(lStr);
      CheckEquals('(ID:4;idFather:0;idMother:0;FamilyName:''Ute'';GivenName:''Elsa'';Sex:''w'';Religion:''co'';Occupation:''Rechengehilfin'';BirthDay:'''';BirthMonth:'''';BirthYear:'''';Birthplace:'''';BaptDay:'''';BaptMonth:'''';BaptYear:'''';BaptPlace:'''';Godparents:'''';Residence:''Computerland'';DeathDay:'''';DeathMonth:'''';DeathYear:'''';DeathPlace:'''';DeathReason:'''';BurialDay:'''';BurialMonth:'''';BurialYear:'''';BurialPlace:'''';BirthSource:'''';BaptSource:'''';DeathSource:''1'';BurialSource:'''';Text:''D'+lineending+''';Living:''j'';AKA:''Comp J. Uda'';Index:''I00004'';Adopted:'''';FarmName:'''';AdrStreet:'''';AdrAddit:'''';AdrPLZ:'''';AdrPlace:'''';AdrPlaceAdd:'''';Free1:'''';Free2:'''';Free3:'''';Age:'''';Phone:'''';eMail:'''';WebAdr:'''';NameSource:''Rechnung'';CallName:''Compy''{%H-})',FHejIndData.ToPasStruct,'FHejIndData[3].ToPasStruct');
    finally
      FreeAndNil(lstr);
    end;

end;

initialization

  RegisterTest(TTestIndHej);
  RegisterTest(TTestClsIndHej);
end.

