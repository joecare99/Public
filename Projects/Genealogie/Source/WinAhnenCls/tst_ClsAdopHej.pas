unit tst_ClsAdopHej;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFNDEF FPC},TestFramework {$Else} ,fpcunit, testutils,
  testregistry {$endif}, cls_HejAdopData;

type

  { TTestAdopHej }

  TTestAdopHej= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  private
      FHejAdopData: THejAdopData;
      FDataDir: string;
      procedure readnext;

  published
    procedure TestSetUp;
    Procedure TestClear;
    procedure TestID;
    procedure TestidPerson;
    procedure TestidSpouse;
    procedure TestReadStream;
    procedure TestWriteStream;
    Procedure TestEquals;
    procedure TestToString;
    procedure TestToPasStruct;

  end;

  { TTestClsAdopHej }

  TTestClsAdopHej= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  private
      FClsHejAdoptions: TClsHejAdoptions;
      FDataDir: string;

  published
    procedure TestSetUp;
    procedure TestReadStream;
    procedure TestReadStream2;
    procedure TestWriteStream;

  end;

implementation

resourcestring
  DefDataDir = 'Data';

const cTestAdop:array[0..4] of THejAdopData = ((ID:0),
      (ID:1;idPerson:2;idFather_adop:0;idMother_adop:0{%H-}),
      (ID:2;idPerson:3;idFather_adop:10;idMother_adop:0{%H-}),
      (ID:3;idPerson:5;idFather_adop:0;idMother_adop:12{%H-}),
      (ID:4;idPerson:7;idFather_adop:8;idMother_adop:23{%H-}));
{ TTestClsAdopHej }

procedure TTestClsAdopHej.SetUp;
var i:Integer;
begin
FClsHejAdoptions:=TClsHejAdoptions.Create;
FDataDir := DefDataDir;
for i := 0 to 2 do
    if not DirectoryExists(FDataDir) then
        FDataDir := '..' + DirectorySeparator + FDataDir
    else
        break;
FDataDir := FDataDir + DirectorySeparator + 'HejTest';
end;

procedure TTestClsAdopHej.TearDown;
begin
  FreeAndNil(FClsHejAdoptions);
end;

procedure TTestClsAdopHej.TestSetUp;
begin
  CheckTrue(DirectoryExists(FDataDir),'Data-Directory '+FDataDir+' exists');
  CheckNotNull(FClsHejAdoptions,'Adoptions are assigned');
  CheckEquals(0,FClsHejAdoptions.Count,'No Adoptions');
end;

procedure TTestClsAdopHej.TestReadStream;
var
    lStr: TStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.Seek(1061,soBeginning);
        FClsHejAdoptions.ReadFromStream(lStr);
        CheckEquals(1,FClsHejAdoptions.Count,'1 Adoptions');
        CheckEquals(1074, lStr.Position, 'Stringposition is 1074');
     finally
        freeandnil(lStr)
      end;

      FClsHejAdoptions.Clear;
      CheckEquals(0,FClsHejAdoptions.Count,'No Adoptions');

      Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'), 'Datei existiert');
      lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'BigData5.hej', fmOpenRead);
        try
          lStr.Seek(11102392,soBeginning);
          FClsHejAdoptions.ReadFromStream(lStr);
          CheckEquals(3,FClsHejAdoptions.Count,'3 Adoptions');
          CheckEquals(11102443, lStr.Position, 'Stringposition is 11102443');
        finally
          freeandnil(lStr)
        end;
end;

procedure TTestClsAdopHej.TestReadStream2;
var
    lStr: TStream;
    lStl:TMemoryStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.Seek(1061,soBeginning);
        FClsHejAdoptions.ReadFromStream(lStr);
        CheckEquals(1,FClsHejAdoptions.Count,'1 Adoptions');
        CheckEquals(1074, lStr.Position, 'Stringposition is 1074');
      finally
        freeandnil(lStr)
      end;

      FClsHejAdoptions.Clear;
      CheckEquals(0,FClsHejAdoptions.Count,'No Adoptions');

      Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'), 'Datei existiert');
      lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'BigData5.hej', fmOpenRead);
      lStl := TMemoryStream.Create;
        try
          lStl.LoadFromStream(lstr);
          lStl.Seek(11102392,soBeginning);
          FClsHejAdoptions.ReadFromStream(lStl);
          CheckEquals(3,FClsHejAdoptions.Count,'3 Adoptions');
          CheckEquals(11102443, lStl.Position, 'Stringposition is 11102443');
        finally
          freeandnil(lStr);
          freeandnil(lStl)
        end;
end;

procedure TTestClsAdopHej.TestWriteStream;
begin

end;

{ TTestAdopHej }

procedure TTestAdopHej.TestSetUp;
var
  i: TEnumHejAdopDatafields;
begin
 CheckTrue(DirectoryExists(FDataDir),'Data-Directory '+FDataDir+' Exists');
  for i in TEnumHejAdopDatafields do
        if  (i <= hadop_idMother) then
            CheckEquals(0, FHejAdopData.Data[i], 'Data[' + CHejAdopDataDesc[i] + '] is 0')
        else
             CheckEquals('', FHejAdopData.Data[i], 'Data[' + CHejAdopDataDesc[i] +
                '] is ''''');
end;

procedure TTestAdopHej.TestClear;
var
  i: TEnumHejAdopDatafields;
begin
  FHejAdopData := cTestAdop[4];
  FHejAdopData.Clear;
  for i in TEnumHejAdopDatafields do
        if  (i <= hadop_idMother) then
            CheckEquals(0, FHejAdopData.Data[i], 'Data[' + CHejAdopDataDesc[i] + '] is 0')
        else
             CheckEquals('', FHejAdopData.Data[i], 'Data[' + CHejAdopDataDesc[i] +
                '] is ''''');
end;

procedure TTestAdopHej.TestID;
var
    lTestValue, lTestValue2: integer;
    lSecVal, i: integer;
begin
    // Test positive
    FHejAdopData.ID := 15;
    CheckEquals(15, FHejAdopData.ID, 'ID is 15');
    CheckEquals(15, FHejAdopData.Data[hadop_ID], 'Data[ID] is 15');
    FHejAdopData.Data[hadop_ID] := 19;
    CheckEquals(19, FHejAdopData.ID, 'ID is 19');
    CheckEquals(19, FHejAdopData.Data[hadop_ID], 'Data[ID] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        FHejAdopData.ID := lTestValue;
        CheckEquals(lTestValue, FHejAdopData.ID, 'ID is ' + IntToStr(
            lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejAdopData.Data[hadop_ID], 'Data[ID] is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        lTestValue := Random(MaxInt);
        FHejAdopData.Data[hadop_ID] := lTestValue;
        CheckEquals(lTestValue, FHejAdopData.ID, 'ID is ' + IntToStr(
            lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejAdopData.Data[hadop_ID], 'Data[ID] is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejAdopData.ID := 15;
    FHejAdopData.idPerson := 3;
    CheckEquals(15, FHejAdopData.ID, 'ID is 15');
    FHejAdopData.Data[hadop_ID] := 19;
    FHejAdopData.idFather_adop := 1234;
    CheckEquals(19, FHejAdopData.ID, 'ID is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        lTestValue2 := Random(MaxInt);
        if lTestValue = lTestValue2 then
            Inc(lTestValue2);
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejAdopData.ID := lTestValue;
        lSecVal := random(Ord(high(TEnumHejAdopDatafields)));
        if lSecval <= Ord(hadop_ID) then
            Dec(lSecVal);
        FHejAdopData.Data[TEnumHejAdopDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejAdopData.ID, 'ID is still ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejAdopData.Data[hadop_ID],
            'Data[ID] is still ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;
end;

procedure TTestAdopHej.TestidPerson;
var
    lTestValue, lTestValue2: integer;
    lSecVal, i: integer;
begin
    // Test positive
    FHejAdopData.idPerson := 15;
    CheckEquals(15, FHejAdopData.idPerson, 'idPerson is 15');
    CheckEquals(15, FHejAdopData.Data[hadop_idPerson], 'Data[idPerson] is 15');
    FHejAdopData.Data[hadop_idPerson] := 19;
    CheckEquals(19, FHejAdopData.idPerson, 'idPerson is 19');
    CheckEquals(19, FHejAdopData.Data[hadop_idPerson], 'Data[idPerson] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        FHejAdopData.idPerson := lTestValue;
        CheckEquals(lTestValue, FHejAdopData.idPerson, 'idPerson is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejAdopData.Data[hadop_idPerson],
            'Data[idPerson] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        lTestValue := Random(MaxInt);
        FHejAdopData.Data[hadop_idPerson] := lTestValue;
        CheckEquals(lTestValue, FHejAdopData.idPerson, 'idPerson is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejAdopData.Data[hadop_idPerson],
            'Data[idPerson] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejAdopData.idPerson := 15;
    FHejAdopData.ID := 3;
    CheckEquals(15, FHejAdopData.idPerson, 'idPerson is 15');
    FHejAdopData.Data[hadop_idPerson] := 19;
    FHejAdopData.idFather_adop := 1234;
    CheckEquals(19, FHejAdopData.idPerson, 'idPerson is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        lTestValue2 := Random(MaxInt);
        if lTestValue = lTestValue2 then
            Inc(lTestValue2);
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejAdopData.idPerson := lTestValue;
        lSecVal := random(Ord(high(TEnumHejAdopDatafields)));
        if lSecval <= Ord(hadop_idPerson) then
            Dec(lSecVal);
        FHejAdopData.Data[TEnumHejAdopDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejAdopData.idPerson, 'idPerson is still ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejAdopData.Data[hadop_idPerson],
            'Data[idPerson] is still ' + IntToStr(lTestValue) + ' (' +
            IntToStr(i) + ')');
      end;
end;

procedure TTestAdopHej.TestidSpouse;
var
    lTestValue, lTestValue2: integer;
    lSecVal, i: integer;
begin
// Test positive
 FHejAdopData.idFather_adop := 15;
 CheckEquals(15, FHejAdopData.idFather_adop, 'idFather_adop is 15');
 CheckEquals(15, FHejAdopData.Data[hadop_idFather], 'Data[idFather_adop] is 15');
 FHejAdopData.Data[hadop_idFather] := 19;
 CheckEquals(19, FHejAdopData.idFather_adop, 'idFather_adop is 19');
 CheckEquals(19, FHejAdopData.Data[hadop_idFather], 'Data[idFather_adop] is 19');
 // Test-Schleife
 for i := 2 to 10000 do
   begin
     lTestValue := Random(MaxInt);
     FHejAdopData.idFather_adop := lTestValue;
     CheckEquals(lTestValue, FHejAdopData.idFather_adop, 'idFather_adop is ' +
         IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
     CheckEquals(lTestValue, FHejAdopData.Data[hadop_idFather],
         'Data[idFather_adop] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
     lTestValue := Random(MaxInt);
     FHejAdopData.Data[hadop_idFather] := lTestValue;
     CheckEquals(lTestValue, FHejAdopData.idFather_adop, 'idFather_adop is ' +
         IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
     CheckEquals(lTestValue, FHejAdopData.Data[hadop_idFather],
         'Data[idFather_adop] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
   end;

 // Test negative
 FHejAdopData.idFather_adop := 15;
 FHejAdopData.idPerson := 3;
 CheckEquals(15, FHejAdopData.idFather_adop, 'idFather_adop is 15');
 FHejAdopData.Data[hadop_idFather] := 19;
 FHejAdopData.idMother_adop := 1234;
 CheckEquals(19, FHejAdopData.idFather_adop, 'idFather_adop is 19');
 // Test-Schleife
 for i := 2 to 10000 do
   begin
     lTestValue := Random(MaxInt);
     lTestValue2 := Random(MaxInt);
     if lTestValue = lTestValue2 then
         Inc(lTestValue2);
     CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
     FHejAdopData.idFather_adop := lTestValue;
     lSecVal := random(Ord(high(TEnumHejAdopDatafields)));
     if lSecval <= Ord(hadop_idFather) then
         Dec(lSecVal);
     FHejAdopData.Data[TEnumHejAdopDatafields(lSecVal)] := lTestValue2;
     CheckEquals(lTestValue, FHejAdopData.idFather_adop, 'idFather_adop is still ' +
         IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
     CheckEquals(lTestValue, FHejAdopData.Data[hadop_idFather],
         'Data[idFather_adop] is still ' + IntToStr(lTestValue) + ' (' +
         IntToStr(i) + ')');
   end;
end;

procedure TTestAdopHej.SetUp;
var
  i: Integer;
begin
  FHejAdopData.Clear;
  FDataDir := DefDataDir;
  for i := 0 to 2 do
      if not DirectoryExists(FDataDir) then
          FDataDir := '..' + DirectorySeparator + FDataDir
      else
          break;
  if not DirectoryExists(FDataDir) then
       ;
  FDataDir := FDataDir + DirectorySeparator + 'HejTest';

end;

procedure TTestAdopHej.TearDown;
begin
  FHejAdopData.Clear;
end;

var aStr:Tstream ;
procedure TTestAdopHej.readnext;
begin
  FHejAdopData.ReadFromStream(aStr);
end;

procedure TTestAdopHej.TestReadStream;
var
    lStr: TStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.seek(490,soBeginning);
        CheckEquals(false, FHejAdopData.TestStreamHeader(lStr), 'Teste Streamheader');
        CheckEquals(490, lStr.Position, 'Stringposition is ');
        lStr.seek(1061,soBeginning);
        CheckEquals(true, FHejAdopData.TestStreamHeader(lStr), 'Teste Streamheader');
        CheckEquals(1067, lStr.Position, 'Stringposition is ');
        FHejAdopData.ReadFromStream(lStr);
        CheckEquals(-1, FHejAdopData.id, 'ID is -1');
        CheckEquals(2, FHejAdopData.idPerson, 'idPerson is hörensagen');
        CheckEquals(3, FHejAdopData.idFather_adop, 'idFather_adop is 3');
        CheckEquals(0, FHejAdopData.idMother_adop, 'idMother_adop is Care');
        CheckEquals(1074, lStr.Position, 'Stringposition is ');
        aStr:=lStr;
        CheckException(ReadNext,EVariantError,'Now A Converterror must Happen');
        CheckEquals(1080, lStr.Position, 'Stringposition is ');
      finally
        FreeAndNil(lStr);
      end;
end;

procedure TTestAdopHej.TestWriteStream;
begin
  // Todo:
  fail('Todo:')
end;

procedure TTestAdopHej.TestEquals;
begin

end;

procedure TTestAdopHej.TestToString;
var
  lStr: TFileStream;
begin
  CheckEquals('0',cTestAdop[0].toString,'cTestAdop[0].toString');
  CheckEquals('2',cTestAdop[1].toString,'cTestAdop[1].toString');
  CheckEquals('3 aV:10',cTestAdop[2].toString,'cTestAdop[2].toString');
  CheckEquals('5 aM:12',cTestAdop[3].toString,'cTestAdop[3].toString');
  CheckEquals('7 aV:8 aM:23',cTestAdop[4].toString,'cTestAdop[4].toString');
  Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.seek(1061,soBeginning);
        CheckEquals(true, FHejAdopData.TestStreamHeader(lStr), 'Teste Streamheader');
        FHejAdopData.ReadFromStream(lStr);
        CheckEquals('2 aV:3',FHejAdopData.toString,'FHejAdopData[0].toString');
      finally
         FreeAndNil(lStr);
      end;

end;

procedure TTestAdopHej.TestToPasStruct;
var
  lStr: TFileStream;
begin
  CheckEquals('(ID:0;idPerson:0;idFather_adop:0;idMother_adop:0{%H-})',cTestAdop[0].ToPasStruct,'cTestAdop[0].ToPasStruct');
  CheckEquals('(ID:1;idPerson:2;idFather_adop:0;idMother_adop:0{%H-})',cTestAdop[1].ToPasStruct,'cTestAdop[1].ToPasStruct');
  CheckEquals('(ID:2;idPerson:3;idFather_adop:10;idMother_adop:0{%H-})',cTestAdop[2].ToPasStruct,'cTestAdop[2].ToPasStruct');
  CheckEquals('(ID:3;idPerson:5;idFather_adop:0;idMother_adop:12{%H-})',cTestAdop[3].ToPasStruct,'cTestAdop[3].ToPasStruct');
  CheckEquals('(ID:4;idPerson:7;idFather_adop:8;idMother_adop:23{%H-})',cTestAdop[4].ToPasStruct,'cTestAdop[4].ToPasStruct');
      lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.seek(1061,soBeginning);
        CheckEquals(true, FHejAdopData.TestStreamHeader(lStr), 'Teste Streamheader');
        FHejAdopData.ReadFromStream(lStr);
        CheckEquals('(ID:-1;idPerson:2;idFather_adop:3;idMother_adop:0{%H-})',FHejAdopData.ToPasStruct,'FHejAdopData[0].ToPasStruct');
      finally
         FreeAndNil(lStr);
      end;

end;


initialization

  RegisterTest(TTestAdopHej);
  RegisterTest(TTestClsAdopHej);
end.

