unit tst_GedComFile;

{$mode delphi}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}

interface

uses
    Classes, SysUtils, fpcunit, testutils, testregistry, Cmp_GedComFile;

type

    { TTestGedComFile }

    TTestGedComFile = class(TTestCase)
    private
        FGedComFile: TGedComFile;
        FDataPath: string;
        procedure CreateNewHeader(Filename: string);
    protected
        procedure SetUp; override;
        procedure TearDown; override;
        procedure StartFamily(aText, aRef: string; SubType: integer);
        procedure FamilyIndiv(aText, aRef: string; SubType: integer);
        procedure IndiName(aText, aRef: string; SubType: integer);
        procedure IndiData(aText, aRef: string; SubType: integer);
        procedure IndiDate(aText, aRef: string; SubType: integer);
        procedure IndiPlace(aText, aRef: string; SubType: integer);
        procedure IndiRef(aText, aRef: string; SubType: integer);
    published
        procedure TestSetUp;
        procedure TestIIndex;
        procedure TestIIndex2;
        procedure TestIIndex3;
        procedure CreateHeader;
        procedure TestParserOutp3;
        procedure TestFile0;
        procedure TestFile1;
        procedure TestEnum;
        procedure TestRevEnum;
    public
        constructor Create; override;
    end;

var cDebugDate:TDateTime=0.0;

implementation

uses Cls_GedComExt,unt_GenTestBase;

procedure TTestGedComFile.TestSetUp;
begin
    CheckNotNull(FGedComFile, 'GedComFile is assigned');
end;

procedure TTestGedComFile.TestIIndex;
var
    i: integer;
begin
    FGedComFile.Clear;
    FGedComFile.CreateChild('@I1M@', 'INDI')['NAME'].Data := 'Peter Mustermann';
    FGedComFile['@I1M@']['SEX'].Data := 'M';
    for i := 9999 downto 2 do
        FGedComFile.AppendIndex('@I' + IntToStr(i) + 'M', FGedComFile['@I1M@']);
    for i := 0 to 10000 do
        CheckEquals('Peter Mustermann', FGedComFile['@I1M@']['NAME'].Data,
            'Suche nach Peter');

end;

procedure TTestGedComFile.TestIIndex2;
var
    i: integer;
begin
    FGedComFile.Clear;
    FGedComFile.CreateChild('@I1M@', 'INDI')['NAME'].Data := 'Peter Mustermann';
    FGedComFile['@I1M@']['SEX'].Data := 'M';
    for i := 2 to 9999 do
        FGedComFile.AppendIndex('@I' + IntToStr(i) + 'M@', FGedComFile['@I1M@']);
    for i := 0 to 10000 do
        CheckEquals('Peter Mustermann', FGedComFile['@I9999M@']['NAME'].Data,
            'Suche nach Peter');
end;

procedure TTestGedComFile.TestIIndex3;
var
    i: integer;
    lr: string;
begin
    FGedComFile.Clear;
    FGedComFile.CreateChild('@I1M@', 'INDI')['NAME'].Data := 'Peter Mustermann';
    FGedComFile['@I1M@']['SEX'].Data := 'M';
    for i := 2 to 9999 do
        FGedComFile.AppendIndex('@I' + IntToStr(i) + 'M@', FGedComFile['@I1M@']);
    for i := 0 to 10000 do
      begin
        lr := '@I' + IntToStr(random(9999) + 1) + 'M@';
        CheckEquals('Peter Mustermann', FGedComFile[lr]['NAME'].Data, 'Suche nach Peter');
      end;
end;

procedure TTestGedComFile.CreateHeader;
var
    lSt: TMemoryStream;
begin
    CreateNewHeader('TestFile.ged');

    FGedComFile.CreateChild('', 'TRLR');
    lSt := TMemoryStream.Create;
      try
        FGedComFile.WriteToStream(lst);
        lst.Seek(0, soFromBeginning);
        lst.SaveToFile(FDataPath + DirectorySeparator + 'TestFile.ged');
      finally
        FreeAndNil(lSt);
      end;
end;

procedure TTestGedComFile.TestParserOutp3;
var
    lSt: TMemoryStream;
    lInd: TGedComObj;
begin
    CreateNewHeader('FBObr0003.ged');
    StartFamily('3', '', 0);
    IndiName('Adam', 'I3U', 1);
    FamilyIndiv('I3U', '3', 1);
    IndiName('Johann Georg', 'I3U', 2);
    IndiData('M', 'I3U', 6);
    IndiData('lu.', 'I3U', 8);
    StartFamily('3U', '', 0);
    FamilyIndiv('I3U', '3U', 3);
    IndiName('Adam', 'I3UM', 1);
    FamilyIndiv('I3UM', '3U', 1);
    IndiName('Georg', 'I3UM', 2);
    IndiData('lu.', 'I3UM', 8);
    IndiDate('(err) 09.07.1734', 'I3U', 1);
    IndiPlace('Obrigheim', 'I3U', 1);
    IndiDate('12.07.1734', 'I3U', 5);
    IndiPlace('Obrigheim', 'I3U', 5);
    IndiRef('49671', 'I3U', 0);
    FGedComFile.CreateChild('', 'TRLR');
    lSt := TMemoryStream.Create;
      try
        FGedComFile.WriteToStream(lst);
        lst.Seek(0, soFromBeginning);
        lst.SaveToFile(FDataPath + DirectorySeparator + 'FBObr0003.ged');
      finally
        FreeAndNil(lSt);
      end;
 {--- Check ---}
    lInd := FGedComFile['@I3U@'];
    CheckNotNull(lInd, 'Indi is not NULL');
    CheckIs(lind, TGedIndividual, '... is TGedIndividual');
    with TGedIndividual(lind) do
      begin
        CheckEquals('Johann Georg Adam', Name, 'Name is "Johann Georg Adam"');
        CheckEquals('49671', PersonID, 'PersonID is CAL 09.07.1734');
        CheckEquals('M', Sex, 'Ind is Male');
        CheckEquals('(err) 09.07.1734', BirthDate, 'BirthDate is (err) 09.07.1734');
        CheckEquals('', BaptDate, 'BaptDate not set');
        CheckEquals('', DeathDate, 'DeathDate not set');
        CheckEquals('12.07.1734', BurialDate, 'BurialDate set');
        CheckEquals(0, SpouseCount, 'no Spouses');
        CheckEquals(0, ChildrenCount, 'no Children');
        CheckNotNull(Father, 'Indi.Father is not NULL');
        CheckNull(Mother, 'Indi.Father is NULL');
        CheckEquals('Georg Adam', Father.Name, 'Indi.Father is not NULL');
 //       CheckEquals('Linda Kleis', Mother.Name, 'Indi.Father is not NULL');
        CheckEquals('I: Johann Georg Adam, M, E: born: (err) 09.07.1734 in Obrigheim', ToString, 'Name is "Joe Care"');
        CheckEquals(
 'Person: Johann Georg Adam' + lineending +
 'Sex: M' + lineending +
 'Event: Birth am (err) 09.07.1734 in Obrigheim' + lineending +
 'Religion: lu.' + lineending +
 'Event: Burrial am 12.07.1734 in Obrigheim' + lineending
 , Description, 'Description is "Johann Georg Adam"');
      end;

end;

procedure TTestGedComFile.TestFile0;
var
    lSt: TMemoryStream;
    lInd: TGedComObj;

const
    CFilename1 = 'Care_2019-10-11.ged';

begin
    lSt := TMemoryStream.Create;
      try
        lst.LoadFromFile(FDataPath + DirectorySeparator + CFilename1);
        lst.seek(0, soBeginning);
        FGedComFile.LoadFromStream(lst);
        lst.Clear;
      finally;
        FreeAndNil(lst);
      end;
    {--}
    lInd := FGedComFile['@I1@'];
    CheckNotNull(lInd, 'Indi is not NULL');
    CheckIs(lind, TGedIndividual, '... is TGedIndividual');
    with TGedIndividual(lind) do
      begin
        CheckEquals('Joe Care', Name, 'Name is "Joe Care"');
        CheckEquals('1', PersonID, 'PersonID is 1');
        CheckEquals('M', Sex, 'Ind is Male');
        CheckEquals('21 JAN 1971', BirthDate, 'BirthDate is 21 JAN 1971');
        CheckEquals('7 MAR 1971', BaptDate, 'BaptDate is 07 MAR 1971');
        CheckEquals('2099', DeathDate, 'DeathDate not set');
        CheckEquals('1 APR 2099', BurialDate, 'BurialDate set');
        CheckEquals(0, SpouseCount, 'no Spouses');
        CheckEquals(0, ChildrenCount, 'no Children');
        CheckNotNull(Father, 'Indi.Father is not NULL');
        CheckNotNull(Mother, 'Indi.Father is not NULL');
        CheckEquals('Peter Care', Father.Name, 'Indi.Father is not NULL');
        CheckEquals('Linda Kleis', Mother.Name, 'Indi.Father is not NULL');
        CheckEquals('I: Joe Care, M, E: born: 21 JAN 1971 in Eppingen, Heilbronn, Baden-Württemberg, Germany', ToString, 'Name is "Joe Care"');
        CheckEquals('Person: Joe Care' + LineEnding + 'Sex: M' + LineEnding +
            'Event: Birth am 21 JAN 1971 in Eppingen, Heilbronn, Baden-Württemberg, Germany (Im Kreiskrankenhaus) Q:(PI of Joe Care)'
            +
            LineEnding + 'Event: Baptism am 7 MAR 1971 in Sulzfeld, Karlsruhe, Baden-Württemberg, Germany Q:(PI of Joe Care)'
            +
            LineEnding + 'Religion: ev.' + LineEnding +
            'Event: Death am 2099 in St. NImmerleinsdorf (Im Kreise seiner Familie)' +
            LineEnding + 'Event: Burrial am 1 APR 2099', Description, 'Description is "Joe Care"');
      end;
    {-------------}
    lInd := FGedComFile['@I2@'];
    CheckNotNull(lInd, 'Indi2 is not NULL');
    CheckIs(lind, TGedIndividual, '...2 is TGedIndividual');
    with TGedIndividual(lind) do
      begin
        CheckEquals('Peter Care', Name, 'Name2 is "Joe Care"');
        CheckEquals('M', Sex, 'Ind2 is Male');
        CheckEquals('', BirthDate, 'BirthDate2 not set');
        CheckEquals('', BaptDate, 'BaptDate2 not set');
        CheckEquals('', DeathDate, 'DeathDate2 not set');
        CheckEquals('', BurialDate, 'BurialDate2 not set');
        CheckEquals(1, SpouseCount, 'no Spouses');
        CheckEquals('Linda Kleis', Spouses[0].Name, 'Spouse is "Linda Kleis"');
        CheckEquals(1, ChildrenCount, '1 Children');
        CheckEquals('Joe Care', Children[0].Name, 'Child is "Joe Care"');
        CheckNull(Father, 'Indi2.Father is NULL');
        CheckNull(Mother, 'Indi2.Mother is NULL');
        CheckEquals('I: Peter Care, M', ToString, 'Name is "Joe Care"');
        CheckEquals('Person: Peter Care' + LineEnding + 'Sex: M', Description,
            'Name is "Joe Care"');
      end;
end;

procedure TTestGedComFile.TestFile1;
var
    lSt: TMemoryStream;
    lInd: TGedComObj;
const
    CFilename1 = 'Test1_2019-10-16.ged';

begin
    lSt := TMemoryStream.Create;
      try
        lst.LoadFromFile(FDataPath + DirectorySeparator + CFilename1);
        lst.seek(0, soBeginning);
        FGedComFile.LoadFromStream(lst);
        lst.Clear;
      finally;
        FreeAndNil(lst);
      end;
    lInd := FGedComFile['@I1@'];
    CheckNotNull(lInd, 'Indi is not NULL');
    CheckIs(lind, TGedIndividual, '... is TGedIndividual');
    with TGedIndividual(lind) do
      begin
        CheckEquals('Peter Mustermann', Name, 'Name is "Peter Mustermann"');
        CheckEquals('', PersonID, 'PersonID is not set');
        CheckEquals('M', Sex, 'Ind is Male');
        CheckEquals('', BirthDate, 'BirthDate not set');
        CheckEquals('27 JAN 1940', BaptDate, 'BaptDate is 27 JAN 1940');
        CheckEquals('', DeathDate, 'DeathDate not set');
        CheckEquals('', BurialDate, 'BurialDate not set');
        CheckEquals(0, SpouseCount, 'no Spouses');
        CheckEquals(0, ChildrenCount, 'no Children');

      end;
end;

procedure TTestGedComFile.TestEnum;
var
  lCh: TGedComObj;
  i: Integer;
begin
  CreateNewHeader('Dummy.ged');
  i := 0;
  for lCh in FGedComFile['HEAD'] do
    begin
      CheckEquals(i, lCh.ID,'ID');
      inc(i);
    end;
end;

procedure TTestGedComFile.TestRevEnum;
var
  lCh: TGedComObj;
begin
    CreateNewHeader('Dummy.ged');
    for lCh in FGedComFile['HEAD'].GetRevEnumerator('SOUR') do
      begin
        CheckEquals(0, lCh.ID,'ID');
      end;
end;

procedure TTestGedComFile.CreateNewHeader(Filename: string);
var
    lGedObj1: TGedComObj;
    lGedObj0: TGedComObj;
begin
    FGedComFile.Clear;
    CheckEquals(0, FGedComFile.Count, '0 Einträge');
    lGedObj0 := FGedComFile.CreateChild('', 'HEAD');
    CheckEquals(1, FGedComFile.Count, '1 Eintrag');
    lGedObj0['SOUR'].Data := 'GEDTest';
    lGedObj0['SOUR']['NAME'].Data := 'Test GedCom V0.1';
    lGedObj0['SOUR']['VERS'].Data := 'V0.1';
    lGedObj0['DEST'].Data := 'GEDTest';
    lGedObj0['DATE'].Data := DateToStr(cDebugDate);
    lGedObj0['SUBM'].Data := '@SUBM@';
    lGedObj0['CHAR'].Data := FGedComFile.Encoding;
    lGedObj0['LANG'].Data := 'GERMAN';
    lGedObj0['FILE'].Data := FileName;
    lGedObj0['GEDC']['VERS'].Data := '5.5.1';
    lGedObj0['GEDC']['FORM'].Data := 'LINEAGE-LINKED';
    lGedObj0 := FGedComFile.CreateChild('@SUBM@', 'SUBM');
    CheckEquals(2, FGedComFile.Count, '2 Einträge');
    lGedObj0['NAME'].Data := 'Joe Care';
end;

procedure TTestGedComFile.SetUp;
begin
    cDebugDate:=EncodeDate(2021,05,01);
    FGedComFile := TGedComFile.Create;
end;

procedure TTestGedComFile.TearDown;
begin
    FreeAndNil(FGedComFile);
end;

procedure TTestGedComFile.StartFamily(aText, aRef: string; SubType: integer);
var
    lFam: TGedComObj;
begin
    lFam := FGedComFile.CreateChild('@F' + aText + '@', 'FAM');
    lFam['REFN'].Data := 'OsBObr' + RightStr('000' + atext, 4);
end;

procedure TTestGedComFile.FamilyIndiv(aText, aRef: string; SubType: integer);
var
    lFam, lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aText + '@');
    lFam := FGedComFile.Find('@F' + aRef + '@');
    if assigned(lInd) and assigned(lFam) then
      begin
        if SubType = 1 then
          begin
            lFam['HUSB'].Data := '@' + aText + '@';
            lInd['FAMS'].Data := '@F' + aRef + '@';
          end
        else
        if SubType = 2 then
          begin
            lFam['WIFE'].Data := '@' + aText + '@';
            lInd['FAMS'].Data := '@F' + aRef + '@';
          end;
        if SubType > 2 then
          begin
            lFam.CreateChild('', 'CHIL', '@' + aText + '@');
            lInd['FAMC'].Data := '@F' + aRef + '@';
          end;
      end;
end;

procedure TTestGedComFile.IndiName(aText, aRef: string; SubType: integer);
var
    lInd, lName: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if not assigned(lInd) then
        lInd := FGedComFile.CreateChild('@' + aRef + '@', 'INDI');
    if SubType = 0 then
      begin
        lInd['NAME'].Data := aText;
      end
    else
    if SubType = 1 then
      begin
        lInd['NAME'].Data := '/' + aText + '/';
        lInd['NAME']['SURN'].Data := aText;
      end
    else
    if SubType = 2 then
      begin
        lInd['NAME'].Data := aText + ' ' + lInd['NAME'].Data;
        lInd['NAME']['GIVN'].Data := aText;
      end;

end;

procedure TTestGedComFile.IndiData(aText, aRef: string; SubType: integer);
var
    lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if assigned(lInd) then
        case SubType of
            6: lind[CFactSex].Data := aText;
            8: lind['RELI'].Data := aText;
            else
                lind['NOTE'].Data := lind['NOTE'].Data + '/' + aText;
          end;
end;

procedure TTestGedComFile.IndiDate(aText, aRef: string; SubType: integer);
var
    lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if assigned(lInd) then
        case SubType of
            1: lInd['BIRT']['DATE'].Data := aText;
            2: lInd['BAPT']['DATE'].Data := aText;
            4: lInd['DEAT']['DATE'].Data := aText;
            5: lInd['BURI']['DATE'].Data := aText;
            else
                lind['DATE'].Data := aText;
          end;
end;

procedure TTestGedComFile.IndiPlace(aText, aRef: string; SubType: integer);
var
    lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if assigned(lInd) then
        case SubType of
            1: lInd['BIRT']['PLAC'].Data := aText;
            2: lInd['BAPT']['PLAC'].Data := aText;
            4: lInd['DEAT']['PLAC'].Data := aText;
            5: lInd['BURI']['PLAC'].Data := aText;
            else
                lind['DATE'].Data := aText;
          end;
end;

procedure TTestGedComFile.IndiRef(aText, aRef: string; SubType: integer);
var
    lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if assigned(lInd) then
        lind['REFN'].Data := aText;
end;

constructor TTestGedComFile.Create;

var
    i: integer;

begin
    inherited Create;
    FDataPath:=GetDataPath('GenData');
end;

initialization

    RegisterTest(TTestGedComFile);
end.
