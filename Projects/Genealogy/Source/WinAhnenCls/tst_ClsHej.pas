unit tst_ClsHej;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils{$IFNDEF FPC},TestFramework {$Else} ,fpcunit, testutils,
  testregistry {$endif}, sqldb,
    cls_HejData, cls_HejIndData, cls_HejMarrData, cls_HejPlaceData, cls_HejSourceData,
    dm_GenData2;

type

    { TTestClsHejWithDB }

    TTestClsHejWithDB = class(TTestCase)
    private
        FHejIndData: THejIndData;
        FDataDir: string;
    protected
        procedure SetUp; override;
        procedure TearDown; override;
        procedure CreateTestData;
    published
        procedure TestSetUp;
        procedure TestDecode;
        procedure TestEncode;
        procedure TestCreateDB;
        procedure TestCreateData;
        procedure TestCreateData2;
        procedure TestPutOneRecordtoDB;
        procedure TestReadRecordFromDB;
    end;

    { TTestClsHey }

    TTestClsHej = class(TTestCase)
    private
        FHejClass: TClsHejGenealogy;
        FStateChCount, FDataChCount, FUpdateCount: integer;
        FDataDir: string;
        procedure CreateTestdata(Tested: boolean);
        procedure AppendTestdata(Tested: boolean);
        procedure CheckEqualsVar(Expected, Actual: variant; Message: string);
        procedure HejClassOnDataChange(Sender: TObject);
        procedure HejClassOnStateChange(Sender: TObject);
        procedure HejClassOnUpdate(Sender: TObject);
    protected
        procedure SetUp; override;
        procedure TearDown; override;
        procedure CheckEquals(const expected, actual: THejIndData;
           msg: string='';ChkID: boolean=false); overload;

    published
        procedure TestSetup;
        procedure TestCreateTestData;
        procedure TestAppendTestData;
        procedure TestReadFromStream;
        procedure TestLoadFromFile;
        procedure TestWriteToStream;
        procedure TestSetPlace;
        procedure TestGetDataInd;
        procedure TestGetDataMarr;
        procedure TestGetDataRedir;
        procedure TestGetMetaData;
        procedure TestMetaDataField;
        procedure TestMetaDataField2;
    end;

    { TTestClsHejBase }

    TTestClsHejBase = class(TTestCase)
    private
    protected
        procedure SetUp; override;
        procedure TearDown; override;
    published
        procedure TestHejDate2DateStr;
        procedure TestDateStr2HeyDate;
    end;

implementation

uses Forms, frm_ConnectDB,cls_HejBase,unt_IndTestData,unt_MarrTestData,unt_PlaceTestData,unt_SourceTestData, Controls, variants;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

resourcestring
    DefDataDir = 'Data';
    rsTestData =
        'INSERT INTO `individuals` (`idIndividual`, `idIndividual_Father`, `idIndividual_Mother`,'
        + ' `FamilyName`, `GivenName`, `Sex`, `Religion`, `Occupation`, `Birth`, `BirthModif`, `Birthplace`,'
        + ' `BirthSource`, `BaptDate`, `BaptModif`, `BaptPlace`, `Godparents`, `BaptSource`, `Residence`, '
        + '`DeathDate`, `DeathModif`, `DeathPlace`, `DeathReason`, `DearhSource`, `BurialDate`, `BurialModif`,'
        + ' `BurialPlace`, `BurialSource`, `Text`, `living`, `AKA`, `Index`, `Adopted`, `FarmName`, `AdrStreet`,'
        + ' `AdrAddit`, `AdrPLZ`, `AdrPlace`, `AdrPlaceAddit`, `Age`, `Phone`, `eMail`, `WebAdr`, `NameSource`,'
        + ' `CallName`) VALUES' +
        '(1, 0, 0, ''Care'', ''Joe'', ''M'', ''Be'', ''Beruf'', ''1971-01-21 00:00:00'', '''', '
        + '''Eppingen'', ''Geburtsurkunde'', ''1972-02-01 00:00:00'', ''Bef'', ''Sulzfeld'', ''Uwe'
        + ' Care'', ''Taufbuch'', ''Baden'', ''2069-03-01 00:00:00'', ''Abt'', ''Binau'', ''TU'','
        + ' ''Sterbeanzeige'', ''2070-04-01 00:00:00'', ''Abt'', ''Mosbach'', ''Friedhof Mosbach'','
        + ' ''Dies ist ein Text zu Joe Care\r\n2. Zeile\r\n'', ''Y'', ''JaySee'', ''I0001'', ''Ad'','
        + ' ''Hofname'', ''Baumstr. 42'', ''Himmelhof'', ''D74821'', ''Mörtelstein'', ''am Neckar'','
        + ' ''ca. 98 J'', ''0800 330 1000'', ''test@jc99.de'', ''www.jc99.de'', ''hörensagen'','
        + ' ''Joker''),' +
        '(2, 3, 4, ''Ute'', ''Comp'', ''F'', ''co'', ''Rechengehilfin'', NULL, '''', '''', '''','
        +
        ' NULL, '''', '''', '''', '''', ''Computerland'', NULL, '''', '''', '''', '''', NULL, '''','
        + ' '''', '''', NULL, ''Y'', ''Comp J. Uda'', ''I00002'', ''V'', '''', '''', '''', '''', '''','
        + ' '''', '''', '''', '''', '''', ''Rechnung'', ''Compy''),' +
        '(3, 0, 0, ''Ute'', ''Karl'', ''M'', ''co'', ''Rechengehilfin'', NULL, '''', '''', '''','
        + ' NULL, '''', '''', '''', '''', ''Computerland'', NULL, '''', '''', '''', '''', NULL, '''','
        + ' '''', ''1'', NULL, ''Y'', ''Comp J. Uda'', ''I00003'', '''', '''', '''', '''', '''', '''','
        + ' '''', '''', '''', '''', '''', ''Rechnung'', ''Compy''),' +
        '(4, 0, 0, ''Ute'', ''Elsa'', ''F'', ''co'', ''Rechengehilfin'', NULL, '''', '''', '''','
        + ' NULL, '''', '''', '''', '''', ''Computerland'', NULL, '''', '''', '''', ''1'', NULL, '''','
        + ' '''', '''', ''D\r\n'', ''Y'', ''Comp J. Uda'', ''I00004'', '''', '''', '''', '''', '''','
        + ' '''', '''', '''', '''', '''', '''', ''Rechnung'', ''Compy'');';

const
    TestDatabase = 'AhnenWinTest';




function GetApplicationName: string;
begin
    Result := 'AhnenWinNT';
end;

function GetVendorName: string;
begin
    Result := 'JC-Soft';
end;

{ TTestClsHejBase }

procedure TTestClsHejBase.SetUp;
begin
end;

procedure TTestClsHejBase.TearDown;
begin
end;

procedure TTestClsHejBase.TestHejDate2DateStr;

type TTestRec=record
        ExpResult,
        acDay,acMonth,acYear:String;
        dtOnly:boolean;
      end;

const cTestData:array[0..8] of TTestrec=
    ((ExpResult:'';acDay:'';acMonth:'';acYear:'';dtOnly:false),
     (ExpResult:'';acDay:'01';acMonth:'01';acYear:'01';dtOnly:false),
     (ExpResult:'01.01.02';acDay:'01';acMonth:'01';acYear:'02';dtOnly:false),
     (ExpResult:'21.01.1971';acDay:'21';acMonth:'01';acYear:'1971';dtOnly:false),
     (ExpResult:'vo 01.01.1971';acDay:'vo 01';acMonth:'01';acYear:'1971';dtOnly:false),
     (ExpResult:'03.06.1971';acDay:'vo 03';acMonth:'06';acYear:'1971';dtOnly:true),
     (ExpResult:'vo 01.02.1971';acDay:'vo';acMonth:'02';acYear:'1971';dtOnly:false),
     (ExpResult:'01.06.1971';acDay:'vo';acMonth:'06';acYear:'1971';dtOnly:true),
     (ExpResult:'05.01.2000';acDay:'05';acMonth:'Mr';acYear:'2000';dtOnly:false));
var
  dt: TTestRec;

begin
  for dt in cTestData do
    CheckEquals(dt.ExpResult,HejDate2DateStr(dt.acDay,dt.acMonth,dt.acYear,dt.dtOnly),'HejDate2DateStr('+dt.acDay+','+dt.acMonth+','+dt.acYear+','+BoolToStr(dt.dtOnly)+')');
end;

procedure TTestClsHejBase.TestDateStr2HeyDate;
begin

end;

procedure TTestClsHej.CreateTestdata(Tested: boolean);
begin
    FHejClass.Clear;
    if Tested then
        FhejClass.OnStateChange := HejClassOnStateChange;
    if Tested then
        FhejClass.OnUpdate := HejClassOnUpdate;
    if Tested then
        FHejClass.OnDataChange := HejClassOnDataChange;
    if Tested then
        CheckEquals(0, FHejClass.MarriagesCount, 'No Marriages');
    if Tested then
        CheckEquals(0, FHejClass.IndividualCount, 'No Individuals');
    FHejClass.Append;
    if Tested then
        CheckEquals(1, FHejClass.IndividualCount, '1 Individuals');
    if Tested then
        CheckEquals(1, FUpdateCount, '1 Update');
    if Tested then
        CheckEquals(1, FHejClass.GetActID, '1 Update');
    FhejClass.actualInd := cInd[1];
    if Tested then
        CheckEquals(1, FDataChCount, '1 DataChange');
    FHejClass.AppendSpouse;
    if Tested then
        CheckEquals(2, FHejClass.MarriagesCount, '2 Marriages');
    if Tested then
        CheckEquals(2, FHejClass.IndividualCount, '2 Individuals');
    if Tested then
        CheckEquals(2, FHejClass.GetActID, 'ID:2');
    if Tested then
        CheckEquals(1, length(FHejClass.ActualInd.Marriages), 'length(ActInd.Marriage)');
    if Tested then
        CheckEquals(1, length(FHejClass.PeekInd(1).Marriages),
            'length(peekInd[0].Marriage)');
    if Tested then
        CheckEquals(2, FUpdateCount, '2 Update');
    FHejClass.ActualInd := cInd[2];
    if Tested then
        CheckEquals(2, FDataChCount, '2 DataChange');
    FHejClass.ActualMarriage := cMarr[0];
    if Tested then
        CheckEquals(3, FDataChCount, '3 DataChange');
    FHejclass.AppendParent(hind_idFather);
    if Tested then
        CheckEquals(3, FHejClass.IndividualCount, '3 Individuals');
    if Tested then
        CheckEquals(1, FHejClass.ChildCount, '1 Child');
    if Tested then
        CheckEquals(3, FHejClass.GetActID, 'ID:3');
    if Tested then
        CheckEquals(3, FUpdateCount, '3 Update');
    if Tested then
        CheckEquals(3, FHejClass.GetData(2, hind_idFather), 'IDFather:3');
    FHejClass.ActualInd := cInd[3];
    if Tested then
        CheckEquals(4, FDataChCount, '4 DataChange');
    FHejClass.GotoChild;
    if Tested then
        CheckEquals(4, FUpdateCount, '4 Update');
    if Tested then
        CheckEquals(2, FHejClass.GetActID, 'ID:2');
    if Tested then
        CheckEquals(3, FHejClass.ActualInd.idFather, 'IDFather:3');
    FHejClass.AppendParent(hind_idMother);
    if Tested then
        CheckEquals(4, FHejClass.IndividualCount, '4 Individuals');
    if Tested then
        CheckEquals(1, FHejClass.ChildCount, '1 Child');
    if Tested then
        CheckEquals(4, FHejClass.GetActID, 'ID:4');
    if Tested then
        CheckEquals(5, FUpdateCount, '5 Update');
    if Tested then
        CheckEquals(4, FHejClass.GetData(2, hind_idMother), 'IDMother:4');
    FHejClass.ActualInd := cInd[4];
    if Tested then
        CheckEquals(5, FDataChCount, '5 DataChange');
    FHejClass.Seek(2);
    if Tested then
        CheckEquals(2, FHejClass.GetActID, 'ID:1');
    if Tested then
        CheckEquals(6, FUpdateCount, '6 Update');
    FHejClass.AppendAdoption(3);
    if Tested then
        CheckEquals(2, FHejClass.GetActID, 'ID:1');
    if Tested then
        CheckEquals(6, FUpdateCount, '6 Update');

    FHejClass.SetPlace(cPlace[1]);
    FHejClass.SetPlace(cPlace[2]);
    FHejClass.SetPlace(cPlace[3]);
    FHejClass.SetPlace(cPlace[4]);
    FHejClass.SetPlace(cPlace[5]);
    FHejClass.SetPlace(cPlace[6]);
    FHejClass.SetPlace(cPlace[7]);
    if Tested then
      CheckEquals(7, FHejClass.PlaceCount, '7 Places');

    FhejClass.SetSource(cSource[1]);
    FhejClass.SetSource(cSource[2]);
    FhejClass.SetSource(cSource[3]);
    FhejClass.SetSource(cSource[4]);
    FhejClass.SetSource(cSource[5]);
    FhejClass.SetSource(cSource[6]);
    FhejClass.SetSource(cSource[7]);
    FhejClass.SetSource(cSource[8]);
    FhejClass.SetSource(cSource[9]);
    FhejClass.SetSource(cSource[10]);
    FhejClass.SetSource(cSource[11]);
    FhejClass.SetSource(cSource[12]);
    if Tested then
        CheckEquals(12, FHejClass.SourceCount, '12 Sources');
end;

procedure TTestClsHej.AppendTestdata(Tested: boolean);
var
  lIDBase, i, j: Integer;
begin
  lIDBase := FhejClass.IndexOf(VarArrayOf(['Care','Joe',StrToDate('21.01.1971')]));
  CheckEquals(1,lIDBase,'Test first Individual');
  for i := FHejClass.Count+1 to high(cind) do
    begin
      FHejClass.Append(self);
      if Tested then
         CheckEquals(i, FHejClass.Count, inttostr(i)+' Individuals');

      FHejClass.ActualInd := cind[i] ;
      if Tested then
         CheckEquals(cind[i], FHejClass.ActualInd, 'Individual['+inttostr(i)+'] match');
      if Tested then
         CheckEquals(cind[i], FHejClass.PeekInd(i), 'Individual['+inttostr(i)+'] match 2');

      if cInd[i].idFather<i then
         FHejClass.AppendLinkChild(cInd[i].idFather,i);
      if cInd[i].idMother<i then
         FHejClass.AppendLinkChild(cInd[i].idMother,i);

      for j := 1 to FHejClass.Count-1 do
         if (cInd[j].idFather = i) or (cInd[j].idMother = i) then
            FHejClass.AppendLinkChild(i,j);

    end;

  // Delete an unwanted record
  for i := 1 to high(cInd) do
    if cInd[i].id = 0 then
       begin
         FHejClass.Seek(i);
         FHejClass.Delete(FHejClass);
       end;

  for i := 1 to high(cMarr) do
    begin
      FHejClass.SetMarriage(cMarr[i].idPerson,cMarr[i].idSpouse);
      FHejClass.ActualMarriage := cMarr[i];
    end;

  FHejClass.SetPlace(cPlace[0]);
  for i := FHejClass.PlaceCount to high(cPlace) do
    FHejClass.SetPlace(cPlace[i]);

  FHejClass.SetSource(cSource[0]);
  for i := FHejClass.PlaceCount to high(cSource) do
    FHejClass.SetSource(cSource[i]);

    FHejClass.First;

end;

procedure TTestClsHej.CheckEqualsVar(Expected, Actual: variant; Message: string);
var
    i: longint;
    lTestStr: string;
begin

    CheckEquals(VarIsFloat(Expected), VarIsFloat(Actual), Message + ' (VarIsFloat)');
    CheckEquals(VarIsNumeric(Expected), VarIsNumeric(Actual), Message + ' (VarIsNumeric)');
    CheckEquals(VarIsStr(Expected), VarIsStr(Actual), Message + ' (VarIsStr)');
    CheckEquals(VarIsBool(Expected), VarIsBool(Actual), Message + ' (VarIsBool)');
    CheckEquals(VarIsArray(Expected), VarIsArray(Actual), Message + ' (VarIsArray)');
    if VarIsArray(Expected) then
      begin
        lTestStr := '';
        for i := VarArrayLowBound(Actual, 1) to VarArrayHighBound(Actual, 1) do
            if VarIsNumeric(Actual[i]) then
                lTestStr := lTestStr + ',' + IntToStr(Actual[i])
            else
                lTestStr := lTestStr + ',''' + Actual[i] + '''';
        lTestStr := '[' + RightStr(lTestStr, length(lTestStr) - 1) + ']';
        CheckEquals(VarArrayLowBound(Expected, 1), VarArrayLowBound(Actual, 1), Message +
            ' (Low)');
        CheckEquals(VarArrayHighBound(Expected, 1), VarArrayHighBound(Actual, 1), Message +
            ' (High)');

        for i := VarArrayLowBound(Expected, 1) to VarArrayHighBound(Expected, 1) do
            CheckEqualsvar(Expected[i], Actual[i], Message + '[' + IntToStr(i) + ']');
      end
    else if VarIsFloat(Expected) then
        CheckEquals(extended(Expected), Actual, 1e-8, Message)
    else if VarIsNumeric(Expected) then
        CheckEquals(int64(Expected), Actual, Message)
    else if VarIsStr(Expected) then
        CheckEquals(string(Expected), Actual, Message)
    else if VarIsBool(Expected) then
        CheckEquals(boolean(Expected), Actual, Message);
end;

procedure TTestClsHej.HejClassOnDataChange(Sender: TObject);
begin
    Inc(FDataChCount);
end;

procedure TTestClsHej.HejClassOnStateChange(Sender: TObject);
begin
    Inc(FStateChCount);
    //  FlastState:=FHejClass.State;
end;

procedure TTestClsHej.HejClassOnUpdate(Sender: TObject);
begin
    Inc(FUpdateCount);
end;

{ TTestClsHej }
procedure TTestClsHej.SetUp;
var
    i: integer;
begin
    FHejClass := TClsHejGenealogy.Create;
    FDataDir := DefDataDir;
    for i := 0 to 2 do
        if not DirectoryExists(FDataDir) then
            FDataDir := '..' + DirectorySeparator + FDataDir
        else
            break;
    FDataDir := FDataDir + DirectorySeparator + 'HejTest';
    FDataChCount := 0;
    FUpdateCount := 0;
    FStateChCount := 0;
end;

procedure TTestClsHej.TearDown;
begin
    FreeAndNil(FHejClass);
end;

procedure TTestClsHej.CheckEquals(const expected, actual: THejIndData;
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

procedure TTestClsHej.TestSetup;
var
    i: integer;
begin
    CheckNotNull(FHejClass, 'Class is assigned');
    FDataDir := DefDataDir;
    for i := 0 to 2 do
        if not DirectoryExists(FDataDir) then
            FDataDir := '..' + DirectorySeparator + FDataDir
        else
            break;
    FDataDir := FDataDir + DirectorySeparator + 'HejTest';
end;

procedure TTestClsHej.TestCreateTestData;
var
  i: Integer;
begin
    CreateTestdata(True);
    CheckEquals(4, FHejClass.IndividualCount, '4 Individuals');
    CheckEquals(2, FHejClass.MarriagesCount, '2 Marriages');
    for i := 1 to 4 do
       begin
         Checktrue(cInd[i].Equals(FHejClass.PeekInd(i)),'cInd['+inttostr(i)+'].Equals(FHejClass.PeekInd('+inttostr(i)+'))');
         Checktrue(FHejClass.PeekInd(i).Equals(cind[i]),'FHejClass.PeekInd('+inttostr(i)+').Equals(cInd['+inttostr(i)+'])');
         CheckFalse(cInd[5-i].Equals(FHejClass.PeekInd(i)),'not cInd['+inttostr(5-i)+'].Equals(FHejClass.PeekInd('+inttostr(i)+'))');
         CheckFalse(FHejClass.PeekInd(5-i).Equals(cind[i]),'not FHejClass.PeekInd('+inttostr(5-i)+').Equals(cInd['+inttostr(i)+'])');
       end;
end;

procedure TTestClsHej.TestAppendTestData;
var
  i: Integer;
begin
  CreateTestdata(false);
  AppendTestdata(true);
  CheckEquals(9, FHejClass.IndividualCount, '9 Individuals');
  CheckEquals(6, FHejClass.MarriagesCount, '6 Marriages');
  for i := 1 to high(cind) do
     begin
       Checktrue(cInd[i].Equals(FHejClass.PeekInd(i)),'cInd['+inttostr(i)+'].Equals(FHejClass.PeekInd('+inttostr(i)+'))');
       Checktrue(FHejClass.PeekInd(i).Equals(cind[i]),'FHejClass.PeekInd('+inttostr(i)+').Equals(cInd['+inttostr(i)+'])');
       CheckFalse(cInd[9-i].Equals(FHejClass.PeekInd(i)),'not cInd['+inttostr(9-i)+'].Equals(FHejClass.PeekInd('+inttostr(i)+'))');
       CheckFalse(FHejClass.PeekInd(9-i).Equals(cind[i]),'not FHejClass.PeekInd('+inttostr(9-i)+').Equals(cInd['+inttostr(i)+'])');
     end;
  for i := 1 to high(cMarr) do
     begin
//       exp := cMarr[i];
       Checktrue(cMarr[i].Equals(FHejClass.Marriage[i+1]),'cMarr['+inttostr(i)+'].Equals(FHejClass.MarriageData['+inttostr(i+1)+'])');
       Checktrue(FHejClass.Marriage[i+1].Equals(cMarr[i]),'FHejClass.MarriageData[i]('+inttostr(i)+').Equals(cMarr['+inttostr(i)+'])');
       CheckFalse(cMarr[5-i].Equals(FHejClass.Marriage[i+1]),'not cMarr['+inttostr(5-i)+'].Equals(FHejClass.MarriageData['+inttostr(i+1)+'])');
       CheckFalse(FHejClass.Marriage[6-i].Equals(cMarr[i]),'not FHejClass.MarriageData[i]('+inttostr(6-i)+').Equals(cMarr['+inttostr(i)+'])');
     end;
end;

procedure TTestClsHej.TestReadFromStream;
var
    lStr: TStream;
    lStl: TMemoryStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        CheckEquals(1710, lStr.Size, 'StreamSize is 1710');
        FHejClass.ReadFromStream(lStr);
        CheckEquals(1710, lStr.Position, 'Streamposition is 1710');

      finally
        FreeAndNil(lStr)
      end;
    CheckEquals(4, FHejClass.IndividualCount, '4 Individuals');
    CheckEquals(2, FHejClass.MarriagesCount, '2 Marriages');

    FHejClass.First;
    CheckEquals(1, FHejClass.GetActID, 'ID:1');
    CheckEquals(1, FHejClass.SpouseCount, 'C(S):1');
    CheckEquals(0, FHejClass.ChildCount, 'C(C):0');
    FHejClass.Next;
    CheckEquals(2, FHejClass.GetActID, 'ID:2');
    CheckEquals(1, FHejClass.SpouseCount, 'C(S):1');
    CheckEquals(0, FHejClass.ChildCount, 'C(C):0');
    FHejClass.Next;
    CheckEquals(3, FHejClass.GetActID, 'ID:3');
    CheckEquals(0, FHejClass.SpouseCount, 'C(S):0');
    CheckEquals(1, FHejClass.ChildCount, 'C(C):1');
    FHejClass.Next;
    CheckEquals(4, FHejClass.GetActID, 'ID:4');
    CheckEquals(0, FHejClass.SpouseCount, 'C(S):0');
    CheckEquals(1, FHejClass.ChildCount, 'C(C):1');

    FHejClass.Clear;
    CheckEquals(0, FHejClass.MarriagesCount, 'No Marriages');

    Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'),
        'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator +
        'BigData5.hej', fmOpenRead);
    lStl := TMemoryStream.Create;
      try
        CheckEquals(0, lStl.size, 'StreamSize is 11760592');
        lStl.LoadFromStream(lstr);
        CheckEquals(11760592, lStl.size, 'StreamSize is 11760592');
        FHejClass.ReadFromStream(lStl);
        CheckEquals(49302, FHejClass.IndividualCount, '49302 Individuals');
        CheckEquals(30643, FHejClass.MarriagesCount, '30643 Marriages');
        CheckEquals(11760592, lStl.Position, 'StreamPosition is 11760592');
      finally
        FreeAndNil(lStr);
        FreeAndNil(lStl)
      end;
end;

procedure TTestClsHej.TestLoadFromFile;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    FHejClass.LoadFromFile(FDataDir + DirectorySeparator + 'Care.hej');
    CheckEquals(4, FHejClass.IndividualCount, '4 Individuals');
    CheckEquals(2, FHejClass.MarriagesCount, '2 Marriages');
end;

procedure TTestClsHej.TestWriteToStream;
var
    lStr: TStream;
    //   lStl: TMemoryStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        CheckEquals(1710, lStr.Size, 'StreamSize is 1710');
        FHejClass.ReadfromStream(lStr);

      finally
        FreeAndNil(lStr)
      end;

    if FileExists(FDataDir + DirectorySeparator + 'Care2.hej') then
        deleteFile(FDataDir + DirectorySeparator + 'Care2.hej');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care2.hej',
        fmCreate + fmOpenWrite);
      try
        FHejClass.WriteToStream(lStr);
        CheckEquals(1710, lStr.Size, 'StreamSize is 1710');
      finally
        FreeAndNil(lStr);
      end;

    CreateTestdata(False);
    if FileExists(FDataDir + DirectorySeparator + 'Care3.hej') then
        deleteFile(FDataDir + DirectorySeparator + 'Care3.hej');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care3.hej',
        fmCreate + fmOpenWrite);
      try
        FHejClass.WriteToStream(lStr);
        CheckEquals(1725, lStr.Size, 'StreamSize is 1725');
      finally
        FreeAndNil(lStr);
      end;

end;

procedure TTestClsHej.TestSetPlace;
begin
    CreateTestdata(False);

end;

procedure TTestClsHej.TestGetDataInd;
var
    lFld: TEnumHejIndDatafields;
begin
    CreateTestdata(False);
    FHejClass.First;
    for lFld in TEnumHejIndDatafields do
      begin
        checkEquals(string(cInd[1].Data[lFld]), FHejClass.GetData(
            1, lFld), 'Prüfe direkt Erste Person, F:' + CHejIndDataDesc[lFld]);
        checkEquals(string(cInd[1].Data[lFld]), FHejClass.GetData(
            -1, lFld), 'Prüfe indirekt Erste Person, F:' + CHejIndDataDesc[lFld]);
      end;
    FHejClass.Next;
    for lFld in TEnumHejIndDatafields do
      begin
        checkEquals(string(cInd[2].Data[lFld]), FHejClass.GetData(
            2, lFld), 'Prüfe direkt zweite Person, F:' + CHejIndDataDesc[lFld]);
        checkEquals(string(cInd[2].Data[lFld]), FHejClass.GetData(
            -1, lFld), 'Prüfe indirekt zweite Person, F:' + CHejIndDataDesc[lFld]);
      end;
end;

procedure TTestClsHej.TestGetDataMarr;
var
    lFld: TEnumHejMarrDatafields;
    cMarr1: THejMarrData;
begin
    CreateTestdata(False);
    FHejClass.First;
    for lFld in TEnumHejMarrDatafields do
        if lFld <> hmar_ID then
          begin
            CheckEqualsVar(cMarr[0].Data[lFld], FHejClass.GetData(1, 0, lFld),
                'Prüfe direkt Erste Heirat, F:' + CHejMarrDataDesc[lFld]);
            CheckEqualsVar(cMarr[0].Data[lFld], FHejClass.GetData(-1, 0, lFld),
                'Prüfe indirekt Erste Heirat, F:' + CHejMarrDataDesc[lFld]);
          end;
    FHejClass.Next;
    cMarr1 := cMarr[0];
    cMarr1.idSpouse := cMarr[0].idPerson;
    cMarr1.idPerson := cMarr[0].idSpouse;
    for lFld in TEnumHejMarrDatafields do
        if lFld <> hmar_ID then
          begin
            CheckEqualsVar(cMarr1.Data[lFld], FHejClass.GetData(2, 0, lFld),
                'Prüfe direkt zweite Heirat, F:' + CHejMarrDataDesc[lFld]);
            CheckEqualsVar(cMarr1.Data[lFld], FHejClass.GetData(-1, 0, lFld),
                'Prüfe indirekt zweite Heirat, F:' + CHejMarrDataDesc[lFld]);
          end;
end;

procedure TTestClsHej.TestGetDataRedir;

var
    lFld: TEnumHejIndDatafields;
    lExp:variant;
begin
    CreateTestdata(False);
    FHejClass.First;
    for lFld in TEnumHejIndDatafields do
      begin
        CheckEqualsVar(cInd[1].Data[lFld], FHejClass.GetData(
            1, hIRd_Ind, Ord(lFld) + 100), 'Prüfe direkt Erste Person, F:' + CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[1].Data[lFld], FHejClass.GetData(
            -1, hIRd_Ind, Ord(lFld) + 100), 'Prüfe indirekt Erste Person, F:' + CHejIndDataDesc[lFld]);

        if lFld > hind_ID then
          lExp := null
        else
          lExp :=0;

            CheckEqualsVar(lExp, FHejClass.GetData(1, hIRd_Father, Ord(lFld) + 100),
                'Prüfe direkt Erste Person Vater, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(lExp, FHejClass.GetData(-1, hIRd_Father, Ord(lFld) + 100),
                'Prüfe indirekt Erste Person Vater, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(lExp, FHejClass.GetData(1, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe direkt Erste Person Mutter, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(lExp, FHejClass.GetData(-1, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe indirekt Erste Person Mutter, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(lExp, FHejClass.GetData(1, hIRd_Child, Ord(lFld) + 100),
                'Prüfe direkt Erste Person Kind, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(lExp, FHejClass.GetData(-1, hIRd_Child, Ord(lFld) + 100),
                'Prüfe indirekt Erste Person Kind, F:' + CHejIndDataDesc[lFld]);
        CheckEqualsVar(cInd[2].Data[lFld], FHejClass.GetData(1, hIRd_Spouse, Ord(lFld) + 100),
            'Prüfe direkt Erste Person Partner, F:' + CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[2].Data[lFld], FHejClass.GetData(-1, hIRd_Spouse, Ord(lFld) + 100),
            'Prüfe indirekt Erste Person Partner, F:' + CHejIndDataDesc[lFld]);

        checkEqualsvar(cInd[2].Data[lFld], FHejClass.GetData(-1, hIRd_AnySpouse, Ord(lFld) + 100),
            'Prüfe indirekt Erste Person Partner, F:' + CHejIndDataDesc[lFld]);
      end;
    FHejClass.Next;
    for lFld in TEnumHejIndDatafields do
      begin
        if lFld > hind_ID then
          lExp := null
        else
          lExp :=0;

        CheckEqualsVar(cInd[2].Data[lFld], FHejClass.GetData(
            2, hIRd_Ind, Ord(lFld) + 100), 'Prüfe direkt zweite Person, F:' + CHejIndDataDesc[lFld]);
        CheckEqualsVar(cInd[2].Data[lFld], FHejClass.GetData(
            -1, hIRd_Ind, Ord(lFld) + 100), 'Prüfe indirekt zweite Person, F:' + CHejIndDataDesc[lFld]);

        CheckEqualsVar(cInd[3].Data[lFld], FHejClass.GetData(
            2, hIRd_Father, Ord(lFld) + 100), 'Prüfe direkt zweite Person Vater, F:' +
            CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[3].Data[lFld], FHejClass.GetData(
            -1, hIRd_Father, Ord(lFld) + 100), 'Prüfe indirekt zweite Person Vater, F:' +
            CHejIndDataDesc[lFld]);

        CheckEqualsVar(cInd[4].Data[lFld], FHejClass.GetData(
            2, hIRd_Mother, Ord(lFld) + 100), 'Prüfe direkt zweite Person Mutter, F:' +
            CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[4].Data[lFld], FHejClass.GetData(
            -1, hIRd_Mother, Ord(lFld) + 100), 'Prüfe indirekt zweite Person Mutter, F:' +
            CHejIndDataDesc[lFld]);

        CheckEqualsVar(vararrayof([cInd[3].Data[lFld],cInd[4].Data[lFld]]),
            FHejClass.GetData(
            2, hIRd_AllParent, Ord(lFld) + 100), 'Prüfe direkt zweite Person Alle Eltern, F:' +
            CHejIndDataDesc[lFld]);
        checkEqualsvar(vararrayof([cInd[3].Data[lFld],cInd[4].Data[lFld]]),
            FHejClass.GetData(
            -1, hIRd_AllParent, Ord(lFld) + 100), 'Prüfe indirekt zweite Person Alle Eltern, F:' +
            CHejIndDataDesc[lFld]);
        CheckEqualsVar(vararrayof([cInd[3].Data[lFld],cInd[4].Data[lFld]]),
            FHejClass.GetData(
            2, hIRd_AnyParent, Ord(lFld) + 100), 'Prüfe direkt zweite Person mögl. Eltern, F:' +
            CHejIndDataDesc[lFld]);
        checkEqualsvar(vararrayof([cInd[3].Data[lFld],cInd[4].Data[lFld]]),
            FHejClass.GetData(
            -1, hIRd_AnyParent, Ord(lFld) + 100), 'Prüfe indirekt zweite Person mögl. Eltern, F:' +
            CHejIndDataDesc[lFld]);


        CheckEqualsVar(cInd[1].Data[lFld], FHejClass.GetData(
            2, hIRd_Spouse, Ord(lFld) + 100), 'Prüfe direkt zweite Person Partner, F:' +
            CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[1].Data[lFld], FHejClass.GetData(
            -1, hIRd_Spouse, Ord(lFld) + 100), 'Prüfe indirekt zweite Person Partner, F:' +
            CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[1].Data[lFld], FHejClass.GetData(
            2, hIRd_AnySpouse, Ord(lFld) + 100), 'Prüfe direkt zweite Person AnyPartner, F:' +
            CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[1].Data[lFld], FHejClass.GetData(
            -1, hIRd_AnySpouse, Ord(lFld) + 100), 'Prüfe indirekt zweite Person AnyPartner, F:' +
            CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[1].Data[lFld], FHejClass.GetData(
            2, hIRd_AllSpouse, Ord(lFld) + 100), 'Prüfe direkt zweite Person AllPartner, F:' +
            CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[1].Data[lFld], FHejClass.GetData(
            -1, hIRd_AllSpouse, Ord(lFld) + 100), 'Prüfe indirekt zweite Person AllPartner, F:' +
            CHejIndDataDesc[lFld]);

            CheckEqualsVar(lExp, FHejClass.GetData(1, hIRd_Child, Ord(lFld) + 100),
                'Prüfe direkt zweite Person Kind, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(lExp, FHejClass.GetData(-1, hIRd_Child, Ord(lFld) + 100),
                'Prüfe indirekt zweite Person Kind, F:' + CHejIndDataDesc[lFld]);

      end;
    FHejClass.Next;
    for lFld in TEnumHejIndDatafields do
      begin
        CheckEqualsVar(cInd[3].Data[lFld], FHejClass.GetData(
            3, hIRd_Ind, Ord(lFld) + 100), 'Prüfe direkt dritte Person, F:' + CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[3].Data[lFld], FHejClass.GetData(
            -1, hIRd_Ind, Ord(lFld) + 100), 'Prüfe indirekt dritte Person, F:' + CHejIndDataDesc[lFld]);

        if lFld > hind_ID then
          begin
            CheckEqualsVar(null, FHejClass.GetData(3, hIRd_Father, Ord(lFld) + 100),
                'Prüfe direkt dritte Person Vater, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(null, FHejClass.GetData(-1, hIRd_Father, Ord(lFld) + 100),
                'Prüfe indirekt dritte Person Vater, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(null, FHejClass.GetData(3, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe direkt dritte Person Mutter, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(null, FHejClass.GetData(-1, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe indirekt dritte Person Mutter, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(null, FHejClass.GetData(3, hIRd_Spouse, Ord(lFld) + 100),
                'Prüfe direkt dritte Person Patner, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(null, FHejClass.GetData(-1, hIRd_Spouse, Ord(lFld) + 100),
                'Prüfe indirekt dritte Person Partner, F:' + CHejIndDataDesc[lFld]);
          end
        else
          begin
            CheckEqualsVar(0, FHejClass.GetData(3, hIRd_Father, Ord(lFld) + 100),
                'Prüfe direkt dritte Person Vater, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(0, FHejClass.GetData(-1, hIRd_Father, Ord(lFld) + 100),
                'Prüfe indirekt dritte Person Vater, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(0, FHejClass.GetData(3, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe direkt dritte Person Mutter, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(0, FHejClass.GetData(-1, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe indirekt dritte Person Mutter, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(0, FHejClass.GetData(3, hIRd_Spouse, Ord(lFld) + 100),
                'Prüfe direkt dritte Person Partner, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(0, FHejClass.GetData(-1, hIRd_Spouse, Ord(lFld) + 100),
                'Prüfe indirekt dritte Person Partner, F:' + CHejIndDataDesc[lFld]);
          end;

          CheckEqualsVar(cInd[2].Data[lFld], FHejClass.GetData(
              3, hIRd_Child, Ord(lFld) + 100), 'Prüfe direkt dritte Person Kind, F:' + CHejIndDataDesc[lFld]);
          checkEqualsvar(cInd[2].Data[lFld], FHejClass.GetData(
              -1, hIRd_Child, Ord(lFld) + 100), 'Prüfe indirekt dritte Person Kind, F:' + CHejIndDataDesc[lFld]);
      end;
    FHejClass.Next;
    for lFld in TEnumHejIndDatafields do
      begin
        CheckEqualsVar(cInd[4].Data[lFld], FHejClass.GetData(
            4, hIRd_Ind, Ord(lFld) + 100), 'Prüfe direkt vierte Person, F:' + CHejIndDataDesc[lFld]);
        checkEqualsvar(cInd[4].Data[lFld], FHejClass.GetData(
            -1, hIRd_Ind, Ord(lFld) + 100), 'Prüfe indirekt vierte Person, F:' + CHejIndDataDesc[lFld]);

        if lFld > hind_ID then
          begin
            CheckEqualsVar(null, FHejClass.GetData(4, hIRd_Father, Ord(lFld) + 100),
                'Prüfe direkt vierte Person Vater, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(null, FHejClass.GetData(-1, hIRd_Father, Ord(lFld) + 100),
                'Prüfe indirekt vierte Person Vater, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(null, FHejClass.GetData(4, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe direkt vierte Person Mutter, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(null, FHejClass.GetData(-1, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe indirekt vierte Person Mutter, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(null, FHejClass.GetData(4, hIRd_Spouse, Ord(lFld) + 100),
                'Prüfe direkt vierte Person Patner, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(null, FHejClass.GetData(-1, hIRd_Spouse, Ord(lFld) + 100),
                'Prüfe indirekt vierte Person Partner, F:' + CHejIndDataDesc[lFld]);
          end
        else
          begin
            CheckEqualsVar(0, FHejClass.GetData(4, hIRd_Father, Ord(lFld) + 100),
                'Prüfe direkt vierte Person Vater, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(0, FHejClass.GetData(-1, hIRd_Father, Ord(lFld) + 100),
                'Prüfe indirekt vierte Person Vater, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(0, FHejClass.GetData(4, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe direkt vierte Person Mutter, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(0, FHejClass.GetData(-1, hIRd_Mother, Ord(lFld) + 100),
                'Prüfe indirekt vierte Person Mutter, F:' + CHejIndDataDesc[lFld]);

            CheckEqualsVar(0, FHejClass.GetData(4, hIRd_Spouse, Ord(lFld) + 100),
                'Prüfe direkt vierte Person Partner, F:' + CHejIndDataDesc[lFld]);
            checkEqualsvar(0, FHejClass.GetData(-1, hIRd_Spouse, Ord(lFld) + 100),
                'Prüfe indirekt vierte Person Partner, F:' + CHejIndDataDesc[lFld]);
          end;
          CheckEqualsVar(cInd[2].Data[lFld], FHejClass.GetData(
              4, hIRd_Child, Ord(lFld) + 100), 'Prüfe direkt vierte Person Kind, F:' + CHejIndDataDesc[lFld]);
          checkEqualsvar(cInd[2].Data[lFld], FHejClass.GetData(
              -1, hIRd_Child, Ord(lFld) + 100), 'Prüfe indirekt vierte Person Kind, F:' + CHejIndDataDesc[lFld]);
      end;
end;

procedure TTestClsHej.TestGetMetaData;

begin
    CreateTestdata(False);
    FHejClass.First;
    CheckEqualsVar(0, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_ParentCount)),
        'Prüfe direkt Erste Person, ParentCount');
    CheckEqualsVar(1, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_SpouseCount)),
        'Prüfe direkt Erste Person, SpouseCount');
    CheckEqualsVar(0, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_ChildCount)),
        'Prüfe direkt Erste Person, ChildCount');
    CheckEqualsVar(0, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_SiblingCount)),
        'Prüfe direkt Erste Person, SiblingCount');
    CheckEqualsVar(8, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_SourceCount)),
        'Prüfe direkt Erste Person, SourceCount');
    CheckEqualsVar(9, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_PlaceCount)),
        'Prüfe direkt Erste Person, PlaceCount');
    CheckEqualsVar(null, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_AdoptCount)),
        'Prüfe direkt Erste Person, AdoptCount');
    CheckEqualsVar(vararrayof(
        ['Geburtsurkunde', 'Taufbuch', 'Sterbeanzeige', 'Friedhof Mosbach',
        'hörensagen', 'Quelle1', 'Quelle2', 'Quelle3']), FHejClass.GetData(
        1, hIRd_Meta, Ord(hInMeD_AnySource)), 'Prüfe direkt Erste Person, AnySource');
    CheckEqualsVar(vararrayof(['Eppingen', 'Sulzfeld', 'Baden', 'Binau',
        'Mosbach', 'Mörtelstein', 'Neckarbischofsheim', 'Adelsheim', 'Nimmerland']),
        FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_AnyPlace)),
        'Prüfe direkt Erste Person, AnyPlace');
    CheckEqualsVar(vararrayof([1, 0, 0, 'Care', 'Joe', 'm', 'Be', 'Beruf',
        '21', '01', '1971', 'Eppingen', 'bf', '02', '1972', 'Sulzfeld', 'Uwe Care',
        'Baden', 'af', '03', '2069', 'Binau', 'TU', 'ca', '04', '2070', 'Mosbach',
        'Geburtsurkunde', 'Taufbuch', 'Sterbeanzeige', 'Friedhof Mosbach',
        'Dies ist ein Text zu Joe Care'#13#10'2. Zeile'#13#10, 'n', 'JaySee',
        'I0001', 'Ad', 'Hofname', 'Baumstr. 42', 'Himmelhof', 'D74821',
        'Mörtelstein', 'am Neckar', '98', '97', '96', 'ca. 98 J',
        '0800 330 1000', 'test@jc99.de', 'www.jc99.de', 'hörensagen', 'Joker', 0, 1,
        2, '1', '2', '1993', 'Neckarbischofsheim', 'Walter Götz, Richard Laber',
        '3', '4', '1994', 'Adelsheim', 'Walter Götz,', 'Lebensgemeinschaft',
        '5', '6', '2099', 'Nimmerland', 'Quelle1', 'Quelle2', 'Quelle3', '3', '4']),
        FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_AnyData)),
        'Prüfe direkt Erste Person, AnyData');
    CheckEqualsVar(1.02943189596167, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_AgeOfBapt)),
        'Prüfe direkt Erste Person, AgeOfBapt');
    CheckEqualsVar(null, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_AgeOfConf)),
        'Prüfe direkt Erste Person, AgeOfConf');
    CheckEqualsVar(23, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_AgeOfFMarriage)),
        'Prüfe direkt Erste Person, AgeOfFMarriage');
    CheckEqualsVar(23, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_AgeOfLMarriage)),
        'Prüfe direkt Erste Person, AgeOfLMarriage');
    CheckEqualsVar(98, FHejClass.GetData(1, hIRd_Meta, Ord(hInMeD_AgeOfDeath)),
        'Prüfe direkt Erste Person, AgeOfDeath');
   //--------------------------------------------------------------------
    FHejClass.Next;
    CheckEqualsVar(2, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_ParentCount)),
        'Prüfe indirekt zweite Person, ParentCount');
    CheckEqualsVar(1, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_SpouseCount)),
        'Prüfe direkt zweite Person, SpouseCount');
    CheckEqualsVar(0, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_ChildCount)),
        'Prüfe indirekt zweite Person, ChildCount');
    CheckEqualsVar(0, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_SiblingCount)),
        'Prüfe indirekt zweite Person, SiblingCount');
    CheckEqualsVar(4, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_SourceCount)),
        'Prüfe indirekt zweite Person, SourceCount');
    CheckEqualsVar(4, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_PlaceCount)),
        'Prüfe indirekt zweite Person, PlaceCount');
    CheckEqualsVar(null, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AdoptCount)),
        'Prüfe indirekt zweite Person, AdoptCount');
    CheckEqualsVar(vararrayof(['Rechnung', 'Quelle1', 'Quelle2', 'Quelle3']),
        FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AnySource)),
        'Prüfe indirekt zweite Person, AnySource');
    CheckEqualsVar(vararrayof(['Computerland', 'Neckarbischofsheim',
        'Adelsheim', 'Nimmerland']), FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AnyPlace)),
        'Prüfe indirekt zweite Person, AnyPlace');
    CheckEqualsVar(vararrayof(
        [2, 3, 4, 'Ute', 'Comp', 'w', 'co', 'Rechengehilfin', '', '', '', '', '', '', '',
        '', '', 'Computerland', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
        'j', 'Comp J. Uda', 'I00002', 'V', '', '', '', '', '', '', '', '', '', '', '', '', '', 'Rechnung',
        'Compy', 1, 2, 1, '1', '2', '1993', 'Neckarbischofsheim', 'Walter Götz, Richard Laber',
        '3', '4', '1994', 'Adelsheim', 'Walter Götz,', 'Lebensgemeinschaft',
        '5', '6', '2099', 'Nimmerland', 'Quelle1', 'Quelle2', 'Quelle3', '3', '4']),
        FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AnyData)),
        'Prüfe indirekt zweite Erste Person, AnyData');
    CheckEqualsVar(0.0, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AgeOfBapt)),
        'Prüfe indirekt zweite Person, AgeOfBapt');
    CheckEqualsVar(null, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AgeOfConf)),
        'Prüfe direkt Zweite Person, AgeOfConf');
    CheckEqualsVar(null, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AgeOfFMarriage)),
        'Prüfe direkt Zweite Person, AgeOfFFMarriage');
    CheckEqualsVar(null, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AgeOfDeath)),
        'Prüfe direkt Zweite Person, AgeOfDeath');
//------------------------------------------------------------------------------------
    FHejClass.Next;
    CheckEqualsVar(0, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_ParentCount)),
        'Prüfe direkt dritte Person, ParentCount');
    CheckEqualsVar(0, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_SpouseCount)),
        'Prüfe direkt dritte Person, SpouseCount');
    CheckEqualsVar(1, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_ChildCount)),
        'Prüfe direkt dritte Person, ChildCount');
    CheckEqualsVar(0, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_SiblingCount)),
        'Prüfe direkt dritte Person, SiblingCount');
    CheckEqualsVar(2, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_SourceCount)),
        'Prüfe direkt dritte Person, SourceCount');
    CheckEqualsVar(1, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_PlaceCount)),
        'Prüfe direkt dritte Person, PlaceCount');
    CheckEqualsVar(null, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AdoptCount)),
        'Prüfe direkt dritte Person, AdoptCount');
    CheckEqualsVar(vararrayof(['1', 'Rechnung']), FHejClass.GetData(
        -1, hIRd_Meta, Ord(hInMeD_AnySource)), 'Prüfe direkt dritte Person, AnySource');
    CheckEqualsVar(vararrayof(['Computerland']), FHejClass.GetData(
        -1, hIRd_Meta, Ord(hInMeD_AnyPlace)), 'Prüfe direkt dritte Person, AnyPlace');
    CheckEqualsVar(vararrayof(
        [3, 0, 0, 'Ute', 'Karl', 'm', 'co', 'Rechengehilfin', '', '', '', '', '', '', '',
        '', '', 'Computerland', '', '', '', '', '', '', '', '', '', '', '', '', '1', '',
        'j', 'Comp J. Uda', 'I00003', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 'Rechnung',
        'Compy']), FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AnyData)),
        'Prüfe dritte Erste Person, AnyData');
    FHejClass.Next;
    CheckEqualsVar(0, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_ParentCount)),
        'Prüfe direkt vierte Person, ParentCount');
    CheckEqualsVar(0, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_SpouseCount)),
        'Prüfe direkt vierte Person, SpouseCount');
    CheckEqualsVar(1, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_ChildCount)),
        'Prüfe direkt vierte Person, ChildCount');
    CheckEqualsVar(0, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_SiblingCount)),
        'Prüfe direkt vierte Person, SiblingCount');
    CheckEqualsVar(2, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_SourceCount)),
        'Prüfe direkt vierte Person, SourceCount');
    CheckEqualsVar(1, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_PlaceCount)),
        'Prüfe direkt vierte Person, PlaceCount');
    CheckEqualsVar(null, FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AdoptCount)),
        'Prüfe direkt vierte Person, AdoptCount');
    CheckEqualsVar(vararrayof(['1', 'Rechnung']), FHejClass.GetData(
        -1, hIRd_Meta, Ord(hInMeD_AnySource)), 'Prüfe direkt vierte Person, AnySource');
    CheckEqualsVar(vararrayof(['Computerland']), FHejClass.GetData(
        -1, hIRd_Meta, Ord(hInMeD_AnyPlace)), 'Prüfe direkt vierte Person, AnyPlace');
    CheckEqualsVar(vararrayof(
        [4, 0, 0, 'Ute', 'Elsa', 'w', 'co', 'Rechengehilfin', '', '', '', '', '', '', '',
        '', '', 'Computerland', '', '', '', '', '', '', '', '', '', '', '', '1', '',
        'D'#13#10, 'j', 'Comp J. Uda', 'I00004', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
        'Rechnung', 'Compy']), FHejClass.GetData(-1, hIRd_Meta, Ord(hInMeD_AnyData)),
        'Prüfe vierte Erste Person, AnyData');

end;

procedure TTestClsHej.TestMetaDataField;
begin
    CreateTestdata(False);
    FHejClass.First;
    FHejClass.Next;
    CheckEquals('Computerland',FHejClass.iData[-1,hind_Residence],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');
    FHejClass.iMetaData[0,-1,hind_Residence,0] := 'Hauptstr. 20';
    CheckEquals('Hauptstr. 20',FHejClass.iData[-1,hind_Residence],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');
    FHejClass.iMetaData[-1,-1,hind_Residence,1] := '1920';
    CheckEquals('1920: Hauptstr. 20',FHejClass.iData[-1,hind_Residence],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');
    FHejClass.iMetaData[-1,-1,hind_Residence,2] := 'Sulzfeld';
    CheckEquals('1920: Hauptstr. 20 in Sulzfeld',FHejClass.iData[-1,hind_Residence],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');
    FHejClass.iMetaData[-1,-1,hind_Residence,1] := '1930';
    CheckEquals('1920: Hauptstr. 20 in Sulzfeld / 1930: ',FHejClass.iData[-1,hind_Residence],'Residence Data');
    CheckEquals(2,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');
    FHejClass.iMetaData[-1,-1,hind_Residence,2] := 'Sulzfeld';
    CheckEquals('1920: Hauptstr. 20 in Sulzfeld / 1930:  in Sulzfeld',FHejClass.iData[-1,hind_Residence],'Residence Data');
    CheckEquals(2,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');
    FHejClass.iMetaData[-1,-1,hind_Residence,0] := 'Hauptstr. 50';
    CheckEquals('1920: Hauptstr. 20 in Sulzfeld / 1930: Hauptstr. 50 in Sulzfeld',FHejClass.iData[-1,hind_Residence],'Residence Data');
    CheckEquals(2,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');
    FHejClass.iMetaData[-1,-1,hind_Residence,0] := 'im Altersheim';
    CheckEquals('1920: Hauptstr. 20 in Sulzfeld / 1930: Hauptstr. 50 in Sulzfeld / im Altersheim',FHejClass.iData[-1,hind_Residence],'Residence Data');
    CheckEquals(3,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');
end;

procedure TTestClsHej.TestMetaDataField2;
begin
    CreateTestdata(False);
    FHejClass.First;
    FHejClass.Next;
    CheckEquals('Computerland',FHejClass.iData[-1,hind_Residence],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');
    CheckEquals('',FHejClass.iMetaData[0,-1,hind_Residence,2],'Residence Data');
    CheckEquals('Computerland',FHejClass.iMetaData[0,-1,hind_Residence,0],'Residence Data');
    CheckEquals('',FHejClass.iMetaData[0,-1,hind_Residence,1],'Residence Data');

    FHejClass.iData[-1,hind_Residence]:='Hauptstr. 20';
    CheckEquals('Hauptstr. 20',FHejClass.iMetaData[0,-1,hind_Residence,0],'Residence Data');
    CheckEquals('',FHejClass.iMetaData[0,-1,hind_Residence,2],'Residence Data');
    CheckEquals('',FHejClass.iMetaData[0,-1,hind_Residence,1],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');

    FHejClass.iData[-1,hind_Residence]:='1920:';
    CheckEquals('',FHejClass.iMetaData[0,-1,hind_Residence,0],'Residence Data');
    CheckEquals('1920',FHejClass.iMetaData[0,-1,hind_Residence,1],'Residence Data');
    CheckEquals('',FHejClass.iMetaData[0,-1,hind_Residence,2],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');

    FHejClass.iData[-1,hind_Residence]:='in Stettin';
    CheckEquals('',FHejClass.iMetaData[0,-1,hind_Residence,0],'Residence Data');
    CheckEquals('',FHejClass.iMetaData[0,-1,hind_Residence,1],'Residence Data');
    CheckEquals('Stettin',FHejClass.iMetaData[0,-1,hind_Residence,2],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');

    FHejClass.iData[-1,hind_Residence]:='1920: Hauptstr. 20';
    CheckEquals('Hauptstr. 20',FHejClass.iMetaData[0,-1,hind_Residence,0],'Residence Data');
    CheckEquals('1920',FHejClass.iMetaData[0,-1,hind_Residence,1],'Residence Data');
    CheckEquals('',FHejClass.iMetaData[0,-1,hind_Residence,2],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');

    FHejClass.iData[-1,hind_Residence]:='1920: Hauptstr. 20 in Sulzfeld';
    CheckEquals('Hauptstr. 20',FHejClass.iMetaData[0,-1,hind_Residence,0],'Residence Data');
    CheckEquals('1920',FHejClass.iMetaData[0,-1,hind_Residence,1],'Residence Data');
    CheckEquals('Sulzfeld',FHejClass.iMetaData[0,-1,hind_Residence,2],'Residence Data');
    CheckEquals(1,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');

    FHejClass.iData[-1,hind_Residence]:='1920: Hauptstr. 20 in Sulzfeld / 1930: ';
    CheckEquals('',FHejClass.iMetaData[-1,-1,hind_Residence,0],'Residence Data');
    CheckEquals('1930',FHejClass.iMetaData[-1,-1,hind_Residence,1],'Residence Data');
    CheckEquals('',FHejClass.iMetaData[-1,-1,hind_Residence,2],'Residence Data');
    CheckEquals(2,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');

    FHejClass.iData[-1,hind_Residence]:='1920: Hauptstr. 20 in Sulzfeld / 1930:  in Stettin';
    CheckEquals('',FHejClass.iMetaData[-1,-1,hind_Residence,0],'Residence Data');
    CheckEquals('1930',FHejClass.iMetaData[-1,-1,hind_Residence,1],'Residence Data');
    CheckEquals('Stettin',FHejClass.iMetaData[-1,-1,hind_Residence,2],'Residence Data');
    CheckEquals(2,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');

    FHejClass.iData[-1,hind_Residence]:='1920: Hauptstr. 20 in Sulzfeld / 1930: Hauptstr. 50 in Stettin';
    CheckEquals('Hauptstr. 50',FHejClass.iMetaData[-1,-1,hind_Residence,0],'Residence Data');
    CheckEquals('1930',FHejClass.iMetaData[-1,-1,hind_Residence,1],'Residence Data');
    CheckEquals('Stettin',FHejClass.iMetaData[-1,-1,hind_Residence,2],'Residence Data');
    CheckEquals(2,FHejClass.GetiMetaFieldCount(-1,hind_Residence),'FieldCount of Residence');

end;

{ TTestClsHejWithDB }

procedure TTestClsHejWithDB.SetUp;
var
    i: integer;
begin
    FHejIndData.Clear;
    if not assigned(OnGetVendorName) then
        OnGetVendorName := @GetVendorName;
    if not assigned(OnGetApplicationName) then
        OnGetVendorName := @GetApplicationName;
    if not assigned(dmGenData) then
        Application.CreateForm(TdmGenData, dmGenData);
    FDataDir := DefDataDir;
    for i := 0 to 2 do
        if not DirectoryExists(FDataDir) then
            FDataDir := '..' + DirectorySeparator + FDataDir
        else
            break;
    FDataDir := FDataDir + DirectorySeparator + 'HejTest';
end;

procedure TTestClsHejWithDB.TearDown;
var
    aList: TStrings;
begin
    FHejIndData.Clear;
    if dmGenData.DB_Connected then
      begin
        aList := TStringList.Create;
          try
            dmgenData.GetDBSchemas(aList);
            if aList.IndexOf(TestDatabase) <> -1 then
                dmGenData.DeleteMandant(TestDatabase);
          finally
            FreeAndNil(alist);
          end;
      end;
    dmGenData.DB_Connected := False;
end;

procedure TTestClsHejWithDB.TestSetUp;
var
    i: TEnumHejIndDatafields;
begin
    for i in TEnumHejIndDatafields do
        if Ord(i) <= Ord(hind_idMother) then
            CheckEquals(0, FHejIndData.Data[i], 'Data[' + CHejIndDataDesc[i] + '] is 0')
        else
            CheckEquals('', FHejIndData.Data[i], 'Data[' + CHejIndDataDesc[i] +
                '] is ''''');
end;

procedure TTestClsHejWithDB.TestEncode;
const
    cSalt = $edcba9876543210f;
    cKey = 'ABCDEFGHIJKLMNOP';
begin
    CheckEquals('$15D84B20BABEF476D3E3F5E16C60935EF1', encode(
        'Dies ist ein Test', cKey, cSalt), 'Encode "Dies ist ein Test');
    CheckNotEquals('$15D84B20BABEF476D3E3F5E16C60935EF1', encode(
        'Dies ist ein Test', cKey, cSalt xor $100), 'Encode "Dies ist ein Test ,salt');
    CheckEquals('$14D84B20BABEF076D3E3F5E11C60935EF1', encode(
        'Dies ist ein Test', cKey, cSalt xor 1), 'Encode "Dies ist ein Test');
    CheckNotEquals('$15D84B20BABEF476D3E3F5E16C60935EF1', encode(
        'Dies ist ein Test', cKey + '0', cSalt), 'Encode "Dies ist ein Test key');
end;

procedure TTestClsHejWithDB.TestDecode;
const
    cSalt = $edcba9876543210f;
    cKey = 'ABCDEFGHIJKLMNOP';
begin
    CheckEquals('Dies ist ein Test', Decode('$15D84B20BABEF476D3E3F5E16C60935EF1',
        cKey, cSalt), 'Decode "Dies ist ein Test');
end;


procedure TTestClsHejWithDB.CreateTestData;
var
    Host, User, Password, lProjectName: string;
    lConnected, Success: boolean;
begin
    dmGenData.ReadCfgConnection(Host, User, Password);
    dmGenData.ReadCfgProject(lProjectName, lConnected);

    if lProjectName <> TestDatabase then
      begin
        frmConnectDb.SetData(Host, User, Password);
        if frmConnectDb.ShowModal <> mrOk then
            Fail('Canceled by User')
        else
            frmConnectDb.GetData(Host, User, Password);
      end;

    dmGenData.SetDBHostUserPass(Host, User, Password, Success);
    if success then
      begin
        dmgendata.CreateMandant(TestDatabase, nil);
        dmGenData.WriteCfgProject(TestDatabase, True);
      end
    else
        dmGenData.WriteCfgProject('', False);
end;

procedure TTestClsHejWithDB.TestCreateDB;
var
    Host, User, Password, lProjectName: string;
    success, lConnected: boolean;

begin
    dmGenData.ReadCfgConnection(Host, User, Password);
    dmGenData.ReadCfgProject(lProjectName, lConnected);
    if lProjectName = TestDatabase then
        dmGenData.SetDBHostUserPass(Host, User, Password, Success)
    else
        success := False;
    if not success then
      begin
        frmConnectDb.SetData(Host, User, Password);
        if frmConnectDb.ShowModal <> mrOk then
            Fail('Canceled by User')
        else
          begin
            frmConnectDb.GetData(Host, User, Password);

          end;
      end;
    dmGenData.SetDBHostUserPass(Host, User, Password, Success);
    CheckTrue(success, 'Set Host,User,PW -> Success');
    CheckTrue(dmGenData.DB_Connected, 'DB Connected');
    CheckFalse(dmGenData.ProjectIsOpen, 'Project is Open');
    dmGenData.WriteCfgConnection(Host, User, Password);
end;


procedure TTestClsHejWithDB.TestCreateData;
begin
    CreateTestData;
    CheckTrue(dmGenData.DB_Connected);
    CheckTrue(dmGenData.ProjectIsOpen);
    dmGenData.qryInternal.SQL.Text := rsTestData;
    dmGenData.qryInternal.ExecSQL;
    dmGenData.qryInternal.Close;
    dmGenData.qryIndividuals.Refresh;
    dmGenData.qryIndividuals.Append;
    dmGenData.qryIndividuals.FieldByName('idIndividual').AsInteger := 5;
    dmGenData.qryIndividuals.FieldByName('idIndividual_Father').AsInteger := 0;
    dmGenData.qryIndividuals.FieldByName('idIndividual_Mother').AsInteger := 0;
    dmGenData.qryIndividuals.FieldByName('FamilyName').AsString := 'Mustermann';
    dmGenData.qryIndividuals.FieldByName('GivenName').AsString := 'Peter';
    dmGenData.qryIndividuals.FieldByName('Sex').AsString := 'M';
    dmGenData.qryIndividuals.FieldByName('Religion').AsString := 'ev';
    dmGenData.qryIndividuals.FieldByName('Occupation').AsString := 'Angestellter';
    dmGenData.qryIndividuals.FieldByName('Birth').AsDateTime := StrToDate('07.05.1960');
    dmGenData.qryIndividuals.FieldByName('BirthModif').AsString := '';
    dmGenData.qryIndividuals.FieldByName('BirthPlace').AsString := 'Bonn';
    dmGenData.qryIndividuals.FieldByName('BirthSource').AsString := 'Geburtsurkunde';
    dmGenData.qryIndividuals.FieldByName('BaptDate').AsDateTime :=
        StrToDate('07.05.1960');
    dmGenData.qryIndividuals.FieldByName('BaptModif').AsString := '';
    dmGenData.qryIndividuals.FieldByName('BaptPlace').AsString := 'Bonn-2';
    dmGenData.qryIndividuals.FieldByName('GodParents').AsString :=
        'Onkel Dieter; Tante Uschi';
    dmGenData.qryIndividuals.FieldByName('BaptSource').AsString := 'Stammbuch';
    dmGenData.qryIndividuals.Post;
end;

procedure TTestClsHejWithDB.TestCreateData2;
var
    lds: TSQLQuery;
begin
    CreateTestData;
    CheckTrue(dmGenData.DB_Connected);
    CheckTrue(dmGenData.ProjectIsOpen);
    lds := dmGenData.qryIndividuals;
    lds.append;
    lds.FieldByName('idIndividual').AsInteger := 1;
    lds.FieldByName('idIndividual_Father').AsInteger := 0;
    lds.FieldByName('idIndividual_Mother').AsInteger := 0;
    lds.FieldByName('FamilyName').AsString := 'Mustermann';
    lds.FieldByName('GivenName').AsString := 'Peter';
    lds.FieldByName('Sex').AsString := 'M';
    lds.FieldByName('Religion').AsString := 'ev';
    lds.FieldByName('Occupation').AsString := 'Angestellter';
    lds.FieldByName('Birth').AsDateTime := StrToDate('07.05.1960');
    lds.FieldByName('BirthModif').AsString := '';
    lds.FieldByName('BirthPlace').AsString := 'Bonn';
    lds.FieldByName('BirthSource').AsString := 'Geburtsurkunde';
    lds.FieldByName('BaptDate').AsDateTime := StrToDate('07.05.1960');
    lds.FieldByName('BaptModif').AsString := '';
    lds.FieldByName('BaptPlace').AsString := 'Bonn-2';
    lds.FieldByName('GodParents').AsString := 'Onkel Dieter; Tante Uschi';
    lds.FieldByName('BaptSource').AsString := 'Stammbuch';
    lds.Post;
    lds.Refresh;
end;

procedure TTestClsHejWithDB.TestPutOneRecordtoDB;
var
    lStr: TStream;
    lds: TSQLQuery;
begin
    CreateTestData;
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        FHejIndData.ReadFromStream(lStr);
        FHejIndData.UpdateDataset(dmGenData.qryIndividuals);
        lds := dmGenData.qryIndividuals;
        CheckEquals(1, lds.FieldByName('idIndividual').AsInteger, 'ID is 1');
        CheckEquals(0, lds.FieldByName('idIndividual_Father').AsInteger,
            'idFather is 0');
        CheckEquals(0, lds.FieldByName('idIndividual_Mother').AsInteger,
            'idMother is 0');
        CheckEquals('Care', lds.FieldByName('FamilyName').AsString,
            'FamilyName is Care');
        CheckEquals('Joe', lds.FieldByName('GivenName').AsString, 'GivenName is Joe');
        CheckEquals('M', lds.FieldByName('Sex').AsString, 'Sex is M');
        CheckEquals('Be', lds.FieldByName('Religion').AsString, 'Religion is Be');
        CheckEquals('N', lds.FieldByName('Living').AsString, 'Living is N');
        CheckEquals('Joker', lds.FieldByName('Callname').AsString, 'Callname is Joker');
        FHejIndData.ReadFromStream(lStr);
        FHejIndData.UpdateDataset(dmGenData.qryIndividuals);
        CheckEquals(2, lds.FieldByName('idIndividual').AsInteger, 'ID is 2');
        CheckEquals(3, lds.FieldByName('idIndividual_Father').AsInteger,
            'idFather is 3');
        CheckEquals(4, lds.FieldByName('idIndividual_Mother').AsInteger,
            'idMother is 4');
        CheckEquals('Ute', lds.FieldByName('FamilyName').AsString, 'FamilyName is Ute');
        CheckEquals('Comp', lds.FieldByName('GivenName').AsString, 'GivenName is Joe');
        CheckEquals('F', lds.FieldByName('Sex').AsString, 'Sex is M');
        CheckEquals('co', lds.FieldByName('Religion').AsString, 'Religion is Be');
        CheckEquals('Y', lds.FieldByName('Living').AsString, 'Living is Y');
        CheckEquals('Compy', lds.FieldByName('Callname').AsString, 'Callname is Compy');
        FHejIndData.ReadFromStream(lStr);
        FHejIndData.UpdateDataset(dmGenData.qryIndividuals);
        FHejIndData.ReadFromStream(lStr);
        FHejIndData.UpdateDataset(dmGenData.qryIndividuals);
      finally
        FreeAndNil(lStr);
      end;

end;

procedure TTestClsHejWithDB.TestReadRecordFromDB;
begin
    CreateTestData;
    CheckTrue(dmGenData.DB_Connected);
    CheckTrue(dmGenData.ProjectIsOpen);
    dmGenData.qryInternal.SQL.Text := rsTestData;
    dmGenData.qryInternal.ExecSQL;
    dmGenData.qryInternal.Close;
    dmGenData.qryIndividuals.Refresh;
    FHejIndData.ReadFromDataset(1, dmGenData.qryIndividuals);
    CheckEquals(1, FHejIndData.id, 'ID is 1');
    CheckEquals(0, FHejIndData.idFather, 'idFather is 0');
    CheckEquals(0, FHejIndData.idMother, 'idMother is 0');
    CheckEquals('Care', FHejIndData.FamilyName, 'FamilyName is Care');
    CheckEquals('Joe', FHejIndData.GivenName, 'GivenName is Joe');
    CheckEquals('m', FHejIndData.Sex, 'Sex is m');
    CheckEquals('Be', FHejIndData.Religion, 'Religion is Be');
    CheckEquals('j', FHejIndData.Living, 'Living is j');
    CheckEquals('Joker', FHejIndData.CallName, 'Callname is Joker');
    CheckEquals('I0001', FHejIndData.Index, 'Index is I0001');
    CheckEquals('JaySee', FHejIndData.AKA, 'AKA is JaySee');
end;




initialization

    RegisterTest(TTestClsHejBase);
    RegisterTest(TTestClsHej);
    RegisterTest(TTestClsHejWithDB);
end.
