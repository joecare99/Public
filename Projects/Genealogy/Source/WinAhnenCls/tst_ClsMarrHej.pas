unit tst_ClsMarrHej;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils{$IFNDEF FPC},TestFramework {$Else} ,fpcunit, testutils,
  testregistry {$endif}, cls_HejMarrData;

type

    { TTestMarrHej }

    TTestMarrHej = class(TTestCase)
    protected
        procedure SetUp; override;
        procedure TearDown; override;
    private
        FHejMarrData: THejMarrData;
        FDataDir: string;

    published
        procedure TestSetUp;
        procedure TestID;
        procedure TestidPerson;
        procedure TestidSpouse;
        procedure TestMarrChrchDay;
        procedure TestMarrChrchMonth;
        procedure TestMarrChrchYear;
        procedure TestMarrChrchplace;
        procedure TestMarrChrchWitness;
        procedure TestMarrStateDay;
        procedure TestMarrStateMonth;
        procedure TestMarrStateYear;
        procedure TestMarrStatePlace;
        procedure TestMarrStateWitness;
        procedure TestDivorceDay;
        procedure TestDivorceMonth;
        procedure TestDivorceYear;
        procedure TestDivorcePlace;
        procedure TestMarrChrchSource;
        procedure TestMarrStateSource;
        procedure TestDivorceSource;
        procedure TestBurialSource;
        procedure TestReadStream;
        procedure TestWriteStream;
        procedure TestToString;
        procedure TestToPasStruct;
    end;

    { TTestClsMarrHej }

    TTestClsMarrHej = class(TTestCase)
    protected
        procedure SetUp; override;
        procedure TearDown; override;
        Procedure CheckEquals(const Expected,Actual:THejMarrData;Msg:String;ChkID:Boolean=false);overload;
    private
        FClsHejMarriages: TClsHejMarriages;
        FDataDir: string;
        Procedure CreateTestData(Tested:Boolean=false);
    published
        procedure TestSetUp;
        Procedure TestCreateTestData;
        Procedure TestIndexOf;
        Procedure TestSeek;
        procedure TestReadStream;
        procedure TestReadStream2;
        procedure TestWriteStream;
    end;

implementation

uses unt_MarrTestData,variants;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

resourcestring
    DefDataDir = 'Data';


{ TTestClsMarrHej }

procedure TTestClsMarrHej.SetUp;
var
    i: integer;
begin
    FClsHejMarriages := TClsHejMarriages.Create;
    FDataDir := DefDataDir;
    for i := 0 to 2 do
        if not DirectoryExists(FDataDir) then
            FDataDir := '..' + DirectorySeparator + FDataDir
        else
            break;
    FDataDir := FDataDir + DirectorySeparator + 'HejTest';
end;

procedure TTestClsMarrHej.TearDown;
begin
    FreeAndNil(FClsHejMarriages);
end;

procedure TTestClsMarrHej.CheckEquals(const Expected, Actual: THejMarrData;
  Msg: String; ChkID: Boolean);
var
  lFld: TEnumHejMarrDatafields;
begin
  for lFld in TEnumHejMarrDatafields do
     if lFld> hmar_idSpouse then
         CheckEquals(string(expected.Data[lFld]),actual.Data[lFld],msg +' fld:'+CHejMarrDataDesc[lFld]);
       if ChkID then
         begin
       CheckEquals(integer(expected.Data[hmar_idSpouse]),actual.Data[hmar_idSpouse],msg +' fld:'+CHejMarrDataDesc[hmar_idSpouse]);
       CheckEquals(integer(expected.Data[hmar_idPerson]),actual.Data[hmar_idPerson],msg +' fld:'+CHejMarrDataDesc[hmar_idPerson]);
       CheckEquals(integer(expected.Data[hmar_ID]),actual.Data[hmar_ID],msg +' fld:'+CHejMarrDataDesc[hmar_ID]);
         end;
end;

procedure TTestClsMarrHej.CreateTestData(Tested: Boolean);
var
  lMarr: THejMarrData;
  i: Integer;
begin
  if Tested then
      CheckEquals(0,FClsHejMarriages.Count,'Keine Hochzeiten');
  FClsHejMarriages.Append(self);
  if Tested then
      CheckEquals(1,FClsHejMarriages.Count,'1 Hochzeit');
  FClsHejMarriages.ActualMarrSetLink(cMarr[0].idPerson,cMarr[0].idSpouse);
  if Tested then
      CheckEquals(cMarr[0].idPerson,FClsHejMarriages.Data[0,hmar_idPerson],'Hochzeit[0].idPerson');
  if Tested then
      CheckEquals(cMarr[0].idSpouse,FClsHejMarriages.Data[0,hmar_idSpouse],'Hochzeit[0].idPerson');
  FClsHejMarriages.ActualMarr := cMarr[0];
  if Tested then
      CheckEquals(1,FClsHejMarriages.Count,'1 Hochzeit');
  FClsHejMarriages.Append(self);
  if Tested then
      CheckEquals(2,FClsHejMarriages.Count,'2 Hochzeit');
  FClsHejMarriages.ActualMarrSetLink(cMarr[0].idSpouse,cMarr[0].idPerson);
  FClsHejMarriages.SetRevIdx(0);
  if Tested then
      CheckEquals(cMarr[0].idSpouse,FClsHejMarriages.Data[1,hmar_idPerson],'Hochzeit[1].idPerson');
  if Tested then
      CheckEquals(cMarr[0].idPerson,FClsHejMarriages.Data[1,hmar_idSpouse],'Hochzeit[1].idPerson');
  FClsHejMarriages.ActualMarr := cMarr[0];
  for i := 1 to high(cMarr) do
     begin
       FClsHejMarriages.Append(self);
       if Tested then
           CheckEquals(i+2,FClsHejMarriages.Count,inttostr(i+2)+' Hochzeiten');
       FClsHejMarriages.ActualMarrSetLink(cMarr[i].idPerson,cMarr[i].idSpouse);
       if Tested then
           CheckEquals(cMarr[i].idPerson,FClsHejMarriages.Data[i+1,hmar_idPerson],'Hochzeit['+inttostr(i+1)+'].idPerson');
       if Tested then
           CheckEquals(cMarr[i].idSpouse,FClsHejMarriages.Data[i+1,hmar_idSpouse],'Hochzeit['+inttostr(i+1)+'].idPerson');
       if  cMarr[i].idPerson > cMarr[i].idSpouse then
         FClsHejMarriages.SetRevIdx(i);
       FClsHejMarriages.ActualMarr := cMarr[i];
     end;
  FClsHejMarriages.Seek(0);
end;

procedure TTestClsMarrHej.TestSetUp;
begin
    CheckTrue(DirectoryExists(FDataDir), 'Data-Directory ' + FDataDir + ' exists');
    CheckNotNull(FClsHejMarriages, 'Marriages are assigned');
    CheckEquals(0, FClsHejMarriages.Count, 'No Marriages');
end;

procedure TTestClsMarrHej.TestCreateTestData;
var
  lMarr: THejMarrData;
  i: Integer;
begin
  CreateTestData(true);
  CheckEquals(6,FClsHejMarriages.Count,'6 Marriages');
  lMarr:=cMarr[0];
  lMarr.id :=0;
  CheckEquals(lMarr,FClsHejMarriages.Marriage[0],'Marriage[0]',true);
  lMarr:=cMarr[0];
  lMarr.id :=1;
  lMarr.idPerson := cMarr[0].idSpouse;
  lMarr.idSpouse := cMarr[0].idPerson;
  CheckEquals(lMarr,FClsHejMarriages.Marriage[1],'Marriage[1]',true);
  for i := 2 to FClsHejMarriages.Count-1 do
    CheckEquals(cMarr[i-1],FClsHejMarriages.Marriage[i],'Marriage['+inttostr(i)+']',true);
  CheckEquals(0,FClsHejMarriages.GetActID,'GetActID:0');
end;

procedure TTestClsMarrHej.TestIndexOf;
begin
  CreateTestData;
  CheckEquals(3,FClsHejMarriages.IndexOf(vararrayof([7,6])),'idI:7 idS:6');
  CheckEquals(2,FClsHejMarriages.IndexOf(vararrayof([6,7])),'idI:6 idS:7');
  CheckEquals(4,FClsHejMarriages.IndexOf(vararrayof([3,4])),'idI:3 idS:4');
  CheckEquals(1,FClsHejMarriages.IndexOf(vararrayof([2,1])),'idI:2 idS:1');

  CheckEquals(-1,FClsHejMarriages.IndexOf(vararrayof([1,3])),'idI:1 idS:3 !');
  CheckEquals(-1,FClsHejMarriages.IndexOf(vararrayof([0,0])),'idI:0 idS:0 !');
// Todo -jc Großer Test
end;

procedure TTestClsMarrHej.TestSeek;
var
  lSeelDest: LongInt;
  i: Integer;
begin
    CreateTestData;
    CheckEquals(0,FClsHejMarriages.GetActID,'default Actual Marriage');
    FClsHejMarriages.Seek(1);
    CheckEquals(1,FClsHejMarriages.GetActID,'GetActID:1');
    FClsHejMarriages.Seek(2);
    CheckEquals(2,FClsHejMarriages.GetActID,'GetActID:2');
    FClsHejMarriages.Seek(3);
    CheckEquals(3,FClsHejMarriages.GetActID,'GetActID:3');
    FClsHejMarriages.Seek(4);
    CheckEquals(4,FClsHejMarriages.GetActID,'GetActID:4');
    FClsHejMarriages.Seek(-1);
    CheckEquals(4,FClsHejMarriages.GetActID,'GetActID.2:4');
    for i := 0 to 10000 do
      begin
        lSeelDest:=random(FClsHejMarriages.Count);
        FClsHejMarriages.Seek(lSeelDest);
        CheckEquals(lSeelDest,FClsHejMarriages.GetActID,'GetActID['+IntToStr(i)+']:'+inttostr(lSeelDest));
      end;
end;

procedure TTestClsMarrHej.TestReadStream;
var
    lStr: TStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.Seek(738, soBeginning);
        FClsHejMarriages.ReadFromStream(lStr);
        CheckEquals(2, FClsHejMarriages.Count, '2 Marriages');
        CheckEquals(1059, lStr.Position, 'Stringposition is 1059');
      finally
        FreeAndNil(lStr)
      end;

    FClsHejMarriages.Clear;
    CheckEquals(0, FClsHejMarriages.Count, 'No Marriages');

    Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'),
        'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator +
        'BigData5.hej', fmOpenRead);
      try
        lStr.Seek(8939706, soBeginning);
        FClsHejMarriages.ReadFromStream(lStr);
        CheckEquals(30643, FClsHejMarriages.Count, '30643 Marriages');
        CheckEquals(11102392, lStr.Position, 'Stringposition is 11102392');
      finally
        FreeAndNil(lStr)
      end;
end;

procedure TTestClsMarrHej.TestReadStream2;
var
    lStr: TStream;
    lStl: TMemoryStream;
    lMarr: THejMarrData;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.Seek(738, soBeginning);
        FClsHejMarriages.ReadFromStream(lStr);
        CheckEquals(2, FClsHejMarriages.Count, '2 Marriages');
        CheckEquals(1061, lStr.Position, 'Stringposition is 1061');
      finally
        FreeAndNil(lStr)
      end;

    lMarr := cMarr[0];
    lMarr.id :=0;
    CheckEquals(lMarr, FClsHejMarriages.Marriage[0], 'Marriages[0]');

    lMarr.id :=1;
    lMarr.idPerson := cMarr[0].idSpouse;
    lMarr.idSpouse := cMarr[0].idPerson;
    CheckEquals(lMarr, FClsHejMarriages.Marriage[1], 'Marriages[1]');

    FClsHejMarriages.Clear;
    CheckEquals(0, FClsHejMarriages.Count, 'No Marriages');

    Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'),
        'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator +
        'BigData5.hej', fmOpenRead);
    lStl := TMemoryStream.Create;
      try
        lStl.LoadFromStream(lstr);
        lStl.Seek(8939706, soBeginning);
        FClsHejMarriages.ReadFromStream(lStl);
        CheckEquals(30643, FClsHejMarriages.Count, '30643 Marriages');
        CheckEquals(11102392, lStl.Position, 'Stringposition is 11102392');
      finally
        FreeAndNil(lStr);
        FreeAndNil(lStl)
      end;
end;

procedure TTestClsMarrHej.TestWriteStream;
var
       lStr: TStream;
   begin
     CreateTestData;

     lStr:=TMemoryStream.Create;
     try
       FClsHejMarriages.WriteToStream(lStr);
       CheckEquals(659,lStr.Position,'Stringposition is ');
     finally
       FreeAndNil(lStr);
     end;

       if FileExists(FDataDir + DirectorySeparator + 'Care_out2.mhej') then
          deleteFile(FDataDir + DirectorySeparator + 'Care_out2.mhej');
       lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care_out2.mhej', fmCreate + fmOpenWrite);
         try
           FClsHejMarriages.WriteToStream(lStr);
           CheckEquals(659,lStr.Position,'Stringposition is ');
         finally
           FreeAndNil(lStr);
         end;
end;

{ TTestMarrHej }

procedure TTestMarrHej.TestSetUp;
var
    i: TEnumHejMarrDatafields;
begin
    CheckTrue(DirectoryExists(FDataDir), 'Data-Directory ' + FDataDir + ' Exists');
    for i in TEnumHejMarrDatafields do
        if (i <= hmar_idSpouse) then
            CheckEquals(0, FHejMarrData.Data[i], 'Data[' +
                CHejMarrDataDesc[i] + '] is 0')
        else
            CheckEquals('', FHejMarrData.Data[i], 'Data[' +
                CHejMarrDataDesc[i] + '] is ''''');
end;

procedure TTestMarrHej.SetUp;
var
    i: integer;
begin
    FHejMarrData.Clear;
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

procedure TTestMarrHej.TearDown;
begin
    FHejMarrData.Clear;
end;

procedure TTestMarrHej.TestID;
var
    lTestValue, lTestValue2: integer;
    lSecVal, i: integer;
begin
    // Test positive
    FHejMarrData.ID := 15;
    CheckEquals(15, FHejMarrData.ID, 'ID is 15');
    CheckEquals(15, FHejMarrData.Data[hmar_ID], 'Data[ID] is 15');
    FHejMarrData.Data[hmar_ID] := 19;
    CheckEquals(19, FHejMarrData.ID, 'ID is 19');
    CheckEquals(19, FHejMarrData.Data[hmar_ID], 'Data[ID] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        FHejMarrData.ID := lTestValue;
        CheckEquals(lTestValue, FHejMarrData.ID, 'ID is ' + IntToStr(
            lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejMarrData.Data[hmar_ID], 'Data[ID] is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        lTestValue := Random(MaxInt);
        FHejMarrData.Data[hmar_ID] := lTestValue;
        CheckEquals(lTestValue, FHejMarrData.ID, 'ID is ' + IntToStr(
            lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejMarrData.Data[hmar_ID], 'Data[ID] is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejMarrData.ID := 15;
    FHejMarrData.idPerson := 3;
    CheckEquals(15, FHejMarrData.ID, 'ID is 15');
    FHejMarrData.Data[hmar_ID] := 19;
    FHejMarrData.idSpouse := 1234;
    CheckEquals(19, FHejMarrData.ID, 'ID is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        lTestValue2 := Random(MaxInt);
        if lTestValue = lTestValue2 then
            Inc(lTestValue2);
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejMarrData.ID := lTestValue;
        lSecVal := random(Ord(high(TEnumHejMarrDatafields)));
        if lSecval <= Ord(hmar_ID) then
            Dec(lSecVal);
        FHejMarrData.Data[TEnumHejMarrDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejMarrData.ID, 'ID is still ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejMarrData.Data[hmar_ID],
            'Data[ID] is still ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;
end;

procedure TTestMarrHej.TestidPerson;
var
    lTestValue, lTestValue2: integer;
    lSecVal, i: integer;
begin
    // Test positive
    FHejMarrData.idPerson := 15;
    CheckEquals(15, FHejMarrData.idPerson, 'idPerson is 15');
    CheckEquals(15, FHejMarrData.Data[hmar_idPerson], 'Data[idPerson] is 15');
    FHejMarrData.Data[hmar_idPerson] := 19;
    CheckEquals(19, FHejMarrData.idPerson, 'idPerson is 19');
    CheckEquals(19, FHejMarrData.Data[hmar_idPerson], 'Data[idPerson] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        FHejMarrData.idPerson := lTestValue;
        CheckEquals(lTestValue, FHejMarrData.idPerson, 'idPerson is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejMarrData.Data[hmar_idPerson],
            'Data[idPerson] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        lTestValue := Random(MaxInt);
        FHejMarrData.Data[hmar_idPerson] := lTestValue;
        CheckEquals(lTestValue, FHejMarrData.idPerson, 'idPerson is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejMarrData.Data[hmar_idPerson],
            'Data[idPerson] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejMarrData.idPerson := 15;
    FHejMarrData.ID := 3;
    CheckEquals(15, FHejMarrData.idPerson, 'idPerson is 15');
    FHejMarrData.Data[hmar_idPerson] := 19;
    FHejMarrData.idSpouse := 1234;
    CheckEquals(19, FHejMarrData.idPerson, 'idPerson is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        lTestValue2 := Random(MaxInt);
        if lTestValue = lTestValue2 then
            Inc(lTestValue2);
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejMarrData.idPerson := lTestValue;
        lSecVal := random(Ord(high(TEnumHejMarrDatafields)));
        if lSecval <= Ord(hmar_idPerson) then
            Dec(lSecVal);
        FHejMarrData.Data[TEnumHejMarrDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejMarrData.idPerson, 'idPerson is still ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejMarrData.Data[hmar_idPerson],
            'Data[idPerson] is still ' + IntToStr(lTestValue) + ' (' +
            IntToStr(i) + ')');
      end;

end;

procedure TTestMarrHej.TestidSpouse;
var
    lTestValue, lTestValue2: integer;
    lSecVal, i: integer;
begin
    // Test positive
    FHejMarrData.idSpouse := 15;
    CheckEquals(15, FHejMarrData.idSpouse, 'idSpouse is 15');
    CheckEquals(15, FHejMarrData.Data[hmar_idSpouse], 'Data[idSpouse] is 15');
    FHejMarrData.Data[hmar_idSpouse] := 19;
    CheckEquals(19, FHejMarrData.idSpouse, 'idSpouse is 19');
    CheckEquals(19, FHejMarrData.Data[hmar_idSpouse], 'Data[idSpouse] is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        FHejMarrData.idSpouse := lTestValue;
        CheckEquals(lTestValue, FHejMarrData.idSpouse, 'idSpouse is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejMarrData.Data[hmar_idSpouse],
            'Data[idSpouse] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        lTestValue := Random(MaxInt);
        FHejMarrData.Data[hmar_idSpouse] := lTestValue;
        CheckEquals(lTestValue, FHejMarrData.idSpouse, 'idSpouse is ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejMarrData.Data[hmar_idSpouse],
            'Data[idSpouse] is ' + IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
      end;

    // Test negative
    FHejMarrData.idSpouse := 15;
    FHejMarrData.idPerson := 3;
    CheckEquals(15, FHejMarrData.idSpouse, 'idSpouse is 15');
    FHejMarrData.Data[hmar_idSpouse] := 19;
    FHejMarrData.MarrChrchDay := '1234';
    CheckEquals(19, FHejMarrData.idSpouse, 'idSpouse is 19');
    // Test-Schleife
    for i := 2 to 10000 do
      begin
        lTestValue := Random(MaxInt);
        lTestValue2 := Random(MaxInt);
        if lTestValue = lTestValue2 then
            Inc(lTestValue2);
        CheckNotEquals(lTestValue, lTestValue2, 'Ungültiger Test Matching TestValues');
        FHejMarrData.idSpouse := lTestValue;
        lSecVal := random(Ord(high(TEnumHejMarrDatafields)));
        if lSecval <= Ord(hmar_idSpouse) then
            Dec(lSecVal);
        FHejMarrData.Data[TEnumHejMarrDatafields(lSecVal)] := lTestValue2;
        CheckEquals(lTestValue, FHejMarrData.idSpouse, 'idSpouse is still ' +
            IntToStr(lTestValue) + ' (' + IntToStr(i) + ')');
        CheckEquals(lTestValue, FHejMarrData.Data[hmar_idSpouse],
            'Data[idSpouse] is still ' + IntToStr(lTestValue) + ' (' +
            IntToStr(i) + ')');
      end;

end;

procedure TTestMarrHej.TestMarrChrchDay;
begin

end;

procedure TTestMarrHej.TestMarrChrchMonth;
begin

end;

procedure TTestMarrHej.TestMarrChrchYear;
begin

end;

procedure TTestMarrHej.TestMarrChrchplace;
begin

end;

procedure TTestMarrHej.TestMarrChrchWitness;
begin

end;

procedure TTestMarrHej.TestMarrStateDay;
begin

end;

procedure TTestMarrHej.TestMarrStateMonth;
begin

end;

procedure TTestMarrHej.TestMarrStateYear;
begin

end;

procedure TTestMarrHej.TestMarrStatePlace;
begin

end;

procedure TTestMarrHej.TestMarrStateWitness;
begin

end;

procedure TTestMarrHej.TestDivorceDay;
begin

end;

procedure TTestMarrHej.TestDivorceMonth;
begin

end;

procedure TTestMarrHej.TestDivorceYear;
begin

end;

procedure TTestMarrHej.TestDivorcePlace;
begin

end;

procedure TTestMarrHej.TestMarrChrchSource;
begin

end;

procedure TTestMarrHej.TestMarrStateSource;
begin

end;

procedure TTestMarrHej.TestDivorceSource;
begin

end;

procedure TTestMarrHej.TestBurialSource;
begin

end;

procedure TTestMarrHej.TestReadStream;
var
    lStr: TStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.seek(490, soBeginning);
        CheckEquals(False, FHejMarrData.TestStreamHeader(lStr), 'Teste Streamheader');
        CheckEquals(490, lStr.Position, 'Stringposition is ');
        lStr.seek(738, soBeginning);
        CheckEquals(True, FHejMarrData.TestStreamHeader(lStr), 'Teste Streamheader');
        CheckEquals(743, lStr.Position, 'Stringposition is ');
        FHejMarrData.ReadFromStream(lStr);
        CheckEquals(-1, FHejMarrData.id, 'ID is -1');
        CheckEquals(1, FHejMarrData.idPerson, 'idPerson is 1');
        CheckEquals(2, FHejMarrData.idSpouse, 'idSpouse is 2');
        CheckEquals('1', FHejMarrData.MarrChrchDay, 'MarrChrchDay is Care');
        CheckEquals('2', FHejMarrData.MarrChrchMonth, 'MarrChrchMonth is Joe');
        CheckEquals('1993', FHejMarrData.MarrChrchYear, 'MarrChrchYear is m');
        CheckEquals('Neckarbischofsheim', FHejMarrData.MarrChrchplace,
            'MarrChrchplace is Be');
        CheckEquals('Walter Götz, Richard Laber', FHejMarrData.MarrChrchWitness,
            'MarrChrchWitness is j');
        CheckEquals('3', FHejMarrData.MarrStateDay, 'MarrStateDay is Joker');
        CheckEquals('4', FHejMarrData.MarrStateMonth, 'MarrStateMonth is j');
        CheckEquals('1994', FHejMarrData.MarrStateYear, 'MarrStateYear is JaySee');
        CheckEquals(901, lStr.Position, 'Stringposition is ');
        FHejMarrData.ReadFromStream(lStr);
        CheckEquals(2, FHejMarrData.idPerson, 'idPerson2 is 2');
        CheckEquals(1, FHejMarrData.idSpouse, 'idSpouse2 is 1');
        CheckEquals('1', FHejMarrData.MarrChrchDay, 'MarrChrchDay is Care');
        CheckEquals('2', FHejMarrData.MarrChrchMonth, 'MarrChrchMonth is Joe');
        CheckEquals('1993', FHejMarrData.MarrChrchYear, 'MarrChrchYear is m');
        CheckEquals('Neckarbischofsheim', FHejMarrData.MarrChrchplace,
            'MarrChrchplace is Be');
        CheckEquals('Walter Götz, Richard Laber', FHejMarrData.MarrChrchWitness,
            'MarrChrchWitness is j');
        CheckEquals('3', FHejMarrData.MarrStateDay, 'MarrStateDay is Joker');
        CheckEquals('4', FHejMarrData.MarrStateMonth, 'MarrStateMonth is j');
        CheckEquals('1994', FHejMarrData.MarrStateYear, 'MarrStateYear is JaySee');
        CheckEquals(1061, lStr.Position, 'Stringposition is ');
      finally
        FreeAndNil(lStr);
      end;
end;

procedure TTestMarrHej.TestWriteStream;
var
    lStr: TStream;
begin
    lStr := TMemoryStream.Create;
      try
        cMarr[1].WriteToStream(lStr);
        CheckEquals(143, lStr.Position, 'Stringposition is ');
        cMarr[2].WriteToStream(lStr);
        CheckEquals(286, lStr.Position, 'Stringposition 2 is ');
        cMarr[3].WriteToStream(lStr);
        CheckEquals(311, lStr.Position, 'Stringposition 3 is ');
        cMarr[4].WriteToStream(lStr);
        CheckEquals(336, lStr.Position, 'Stringposition 4 is ');
      finally
        FreeAndNil(lStr);
      end;

    if FileExists(FDataDir + DirectorySeparator + 'Care_out.mhej') then
        deleteFile(FDataDir + DirectorySeparator + 'Care_out.mhej');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator +
        'Care_out.mhej', fmCreate + fmOpenWrite);
      try
        cMarr[1].WriteToStream(lStr);
        cMarr[2].WriteToStream(lStr);
        cMarr[3].WriteToStream(lStr);
        cMarr[4].WriteToStream(lStr);
      finally
        FreeAndNil(lStr);
      end;

end;

procedure TTestMarrHej.TestToString;
var
    lStr: TStream;
begin
    CheckEquals('ooK11.05.1978', cMarr[1].ToString, 'cMarr[1].ToString');
    CheckEquals('ooK11.05.1978', cMarr[2].ToString, 'cMarr[2].ToString');
    CheckEquals('', cMarr[3].ToString, 'cMarr[3].ToString');
    CheckEquals('', cMarr[4].ToString, 'cMarr[4].ToString');

    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.seek(738, soBeginning);
        CheckEquals(True, FHejMarrData.TestStreamHeader(lStr), 'Teste Streamheader');
        FHejMarrData.ReadFromStream(lStr);
        CheckEquals('ooK1.2.1993', FHejMarrData.ToString, 'FHejMarrData[0].ToString');
        FHejMarrData.ReadFromStream(lStr);
        CheckEquals('ooK1.2.1993', FHejMarrData.ToString, 'FHejMarrData[1].ToString');
      finally
        FreeAndNil(lStr);
      end;
end;

procedure TTestMarrHej.TestToPasStruct;
var
    lStr: TStream;
begin
    CheckEquals('(ID:2;idPerson:6;idSpouse:7;MarrChrchDay:''11'';MarrChrchMonth:''05''' +
        ';MarrChrchYear:''1978'';MarrChrchplace:''Hamburg-Altona'';MarrChrchWitness:''' +
        'Lehrer, Küster, Bürgermeister'';MarrStateDay:''10'';MarrStateMonth:''05'';Ma' +
        'rrStateYear:''1978'';MarrStatePlace:''Hamburg'';MarrStateWitness:''Lehrer, B' +
        'ürgermeister, '';Kind:''Ehe'';DivorceDay:'''';DivorceMonth:'''';DivorceYear:' +
        ''''';DivorcePlace:'''';MarrChrchSource:''Kirchenbuch'';MarrStateSource:''Sta' +
        'ndesregister'';DivorceSource:'''';Indj:'''';Indm:''''{%H-})',
        cMarr[1].ToPasStruct, 'cMarr[1].ToPasStruct');
    CheckEquals('(ID:3;idPerson:7;idSpouse:6;MarrChrchDay:''11'';MarrChrchMonth:''05''' +
        ';MarrChrchYear:''1978'';MarrChrchplace:''Hamburg-Altona'';MarrChrchWitness:''' +
        'Lehrer, Küster, Bürgermeister'';MarrStateDay:''10'';MarrStateMonth:''05'';Ma' +
        'rrStateYear:''1978'';MarrStatePlace:''Hamburg'';MarrStateWitness:''Lehrer, B' +
        'ürgermeister, '';Kind:''Ehe'';DivorceDay:'''';DivorceMonth:'''';DivorceYear:' +
        ''''';DivorcePlace:'''';MarrChrchSource:''Kirchenbuch'';MarrStateSource:''Sta' +
        'ndesregister'';DivorceSource:'''';Indj:'''';Indm:''''{%H-})',
        cMarr[2].ToPasStruct, 'cMarr[2].ToPasStruct');
    CheckEquals(
        '(ID:4;idPerson:3;idSpouse:4;MarrChrchDay:'''';MarrChrchMonth:'''';MarrChrchY' +
        'ear:'''';MarrChrchplace:'''';MarrChrchWitness:'''';MarrStateDay:'''';MarrSta' +
        'teMonth:'''';MarrStateYear:'''';MarrStatePlace:'''';MarrStateWitness:'''';Ki' +
        'nd:'''';DivorceDay:'''';DivorceMonth:'''';DivorceYear:'''';DivorcePlace:''''' +
        ';MarrChrchSource:'''';MarrStateSource:'''';DivorceSource:'''';Indj:'''';Indm' +
        ':''''{%H-})', cMarr[3].ToPasStruct, 'cMarr[3].ToPasStruct');
    CheckEquals(
        '(ID:5;idPerson:4;idSpouse:3;MarrChrchDay:'''';MarrChrchMonth:'''';MarrChrchY' +
        'ear:'''';MarrChrchplace:'''';MarrChrchWitness:'''';MarrStateDay:'''';MarrSta' +
        'teMonth:'''';MarrStateYear:'''';MarrStatePlace:'''';MarrStateWitness:'''';Ki' +
        'nd:'''';DivorceDay:'''';DivorceMonth:'''';DivorceYear:'''';DivorcePlace:''''' +
        ';MarrChrchSource:'''';MarrStateSource:'''';DivorceSource:'''';Indj:'''';Indm' +
        ':''''{%H-})', cMarr[4].ToPasStruct, 'cMarr[4].ToPasStruct');

    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.seek(738, soBeginning);
        CheckEquals(True, FHejMarrData.TestStreamHeader(lStr), 'Teste Streamheader');
        FHejMarrData.ReadFromStream(lStr);
        CheckEquals(
        '(ID:-1;idPerson:1;idSpouse:2;MarrChrchDay:''1'';MarrChrchMonth:''2'';MarrChr' +
        'chYear:''1993'';MarrChrchplace:''Neckarbischofsheim'';MarrChrchWitness:''Wal' +
        'ter Götz, Richard Laber'';MarrStateDay:''3'';MarrStateMonth:''4'';MarrStateY' +
        'ear:''1994'';MarrStatePlace:''Adelsheim'';MarrStateWitness:''Walter Götz,'';' +
        'Kind:''Lebensgemeinschaft'';DivorceDay:''5'';DivorceMonth:''6'';DivorceYear:' +
        '''2099'';DivorcePlace:''Nimmerland'';MarrChrchSource:''Quelle1'';MarrStateSo' +
        'urce:''Quelle2'';DivorceSource:''Quelle3'';Indj:''3'';Indm:''4''{%H-})', FHejMarrData.ToPasStruct, 'FHejMarrData[0].ToPasStruct');
        FHejMarrData.ReadFromStream(lStr);
        CheckEquals(
        '(ID:-1;idPerson:2;idSpouse:1;MarrChrchDay:''1'';MarrChrchMonth:''2'';MarrChr' +
        'chYear:''1993'';MarrChrchplace:''Neckarbischofsheim'';MarrChrchWitness:''Wal' +
        'ter Götz, Richard Laber'';MarrStateDay:''3'';MarrStateMonth:''4'';MarrStateY' +
        'ear:''1994'';MarrStatePlace:''Adelsheim'';MarrStateWitness:''Walter Götz,'';' +
        'Kind:''Lebensgemeinschaft'';DivorceDay:''5'';DivorceMonth:''6'';DivorceYear:' +
        '''2099'';DivorcePlace:''Nimmerland'';MarrChrchSource:''Quelle1'';MarrStateSo' +
        'urce:''Quelle2'';DivorceSource:''Quelle3'';Indj:''3'';Indm:''4''{%H-})', FHejMarrData.ToPasStruct, 'FHejMarrData[1].ToPasStruct');

      finally
        FreeAndNil(lStr);
      end;

end;

initialization

    RegisterTest(TTestMarrHej);
    RegisterTest(TTestClsMarrHej);
end.
