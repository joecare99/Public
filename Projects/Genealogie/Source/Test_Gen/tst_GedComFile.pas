unit tst_GedComFile;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,Cmp_GedComFile;

type

  { TTestGedComFile }

  TTestGedComFile= class(TTestCase)
  private
    FGedComFile:TGedComFile;
    FDataPath:String;
    procedure CreateNewHeader(Filename:String);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    Procedure StartFamily(aText,aRef:String;SubType:integer);
    Procedure FamilyIndiv(aText,aRef:String;SubType:integer);
    Procedure IndiName(aText,aRef:String;SubType:integer);
    Procedure IndiData(aText,aRef:String;SubType:integer);
    Procedure IndiDate(aText,aRef:String;SubType:integer);
    Procedure IndiPlace(aText,aRef:String;SubType:integer);
    Procedure IndiRef(aText,aRef:String;SubType:integer);
  published
    procedure TestSetUp;
    Procedure TestIIndex;
    Procedure TestIIndex2;
    Procedure TestIIndex3;
    Procedure CreateHeader;
    Procedure TestParserOutp3;
  public
    constructor Create; override;
  end;

implementation

procedure TTestGedComFile.TestSetUp;
begin
  CheckNotNull(FGedComFile,'GedComFile is assigned');
end;

procedure TTestGedComFile.TestIIndex;
var
  i: Integer;
begin
  FGedComFile.clear;
  FGedComFile.CreateChild('@I1M@','INDI')['NAME'].data := 'Peter Mustermann';
  FGedComFile['@I1M@']['SEX'].data:='M';
  for i := 9999 downto 2 do
     FGedComFile.AppendIndex('@I'+inttostr(i)+'M',FGedComFile['@I1M@']);
  for i := 0 to 10000 do
     CheckEquals('Peter Mustermann',FGedComFile['@I1M@']['NAME'].data,'Suche nach Peter');

end;

procedure TTestGedComFile.TestIIndex2;
var
  i: Integer;
begin
  FGedComFile.clear;
  FGedComFile.CreateChild('@I1M@','INDI')['NAME'].data := 'Peter Mustermann';
  FGedComFile['@I1M@']['SEX'].data:='M';
  for i := 2 to 9999 do
     FGedComFile.AppendIndex('@I'+inttostr(i)+'M@',FGedComFile['@I1M@']);
  for i := 0 to 10000 do
     CheckEquals('Peter Mustermann',FGedComFile['@I9999M@']['NAME'].data,'Suche nach Peter');
end;

procedure TTestGedComFile.TestIIndex3;
var
  i: Integer;
  lr: String;
begin
  FGedComFile.clear;
  FGedComFile.CreateChild('@I1M@','INDI')['NAME'].data := 'Peter Mustermann';
  FGedComFile['@I1M@']['SEX'].data:='M';
  for i := 2 to 9999 do
     FGedComFile.AppendIndex('@I'+inttostr(i)+'M@',FGedComFile['@I1M@']);
  for i := 0 to 10000 do
     begin
       lr:='@I'+inttostr(random(9999)+1)+'M@';
       CheckEquals('Peter Mustermann',FGedComFile[lr]['NAME'].data,'Suche nach Peter');
     end
end;

procedure TTestGedComFile.CreateHeader;
var
  lSt: TMemoryStream;
begin
  CreateNewHeader('TestFile.ged');

  FGedComFile.CreateChild('','TRLR');
  lSt:=TMemoryStream.Create;
  try
  FGedComFile.WriteToStream(lst);
  lst.Seek(0,soFromBeginning);
  lst.SaveToFile(FDataPath+DirectorySeparator+'TestFile.ged');
  finally
    freeandnil(lSt);
  end;
end;

procedure TTestGedComFile.TestParserOutp3;
var
  lSt: TMemoryStream;
begin
  CreateNewHeader('FBObr0003.ged');
StartFamily	('3',		'',     0);
IndiName	('Adam',        'I3U',	1);
FamilyIndiv	('I3U',	        '3',	1);
IndiName	('Johann Georg','I3U',	2);
IndiData	('lu.',	        'I3U',	8);
StartFamily	('3U',		'', 0);
FamilyIndiv	('I3U',	        '3U',	3);
IndiName	('Adam',	'I3UM',	1);
FamilyIndiv	('I3UM',	'3U',	1);
IndiName	('Georg',	'I3UM',	2);
IndiData	('lu.',	        'I3UM',	8);
IndiDate	('(err) 09.07.1734','I3U',1);
IndiPlace	('Obrigheim',	'I3U',	1);
IndiDate	('12.07.1734',	'I3U',	5);
IndiPlace	('Obrigheim',	'I3U',	5);
IndiRef	        ('49671',	'I3U',	0);
FGedComFile.CreateChild('','TRLR');
lSt:=TMemoryStream.Create;
try
FGedComFile.WriteToStream(lst);
lst.Seek(0,soFromBeginning);
lst.SaveToFile(FDataPath+DirectorySeparator+'FBObr0003.ged');
finally
  freeandnil(lSt);
end;
end;

procedure TTestGedComFile.CreateNewHeader(Filename: String);
var
  lGedObj1: TGedComObj;
  lGedObj0: TGedComObj;
begin
  FGedComFile.Clear;
  CheckEquals(0, FGedComFile.Count, '0 Einträge');
  lGedObj0 := FGedComFile.CreateChild('', 'HEAD');
  CheckEquals(1, FGedComFile.Count, '1 Eintrag');
  lGedObj0['SOUR'].data:= 'GEDTest';
  lGedObj0['SOUR']['NAME'].data:= 'Test GedCom V0.1';
  lGedObj0['SOUR']['VERS'].data:= 'V0.1';
  lGedObj0['DEST'].data := 'GEDTest';
  lGedObj0['DATE'].data := DateToStr(Now());
  lGedObj0['SUBM'].data := '@SUBM@';
  lGedObj0['CHAR'].data := FGedComFile.Encoding;
  lGedObj0['LANG'].data := 'GERMAN';
  lGedObj0['FILE'].data := FileName;
  lGedObj0['GEDC']['VERS'].data := '5.5.1';
  lGedObj0['GEDC']['FORM'].data := 'LINEAGE-LINKED';
  lGedObj0 := FGedComFile.CreateChild('@SUBM@', 'SUBM');
  CheckEquals(2, FGedComFile.Count, '2 Einträge');
  lGedObj0['NAME'].data := 'Joe Care';
end;

procedure TTestGedComFile.SetUp;
begin
  FGedComFile:=TGedComFile.Create;
end;

procedure TTestGedComFile.TearDown;
begin
  FreeAndNil(FGedComFile);
end;

procedure TTestGedComFile.StartFamily(aText, aRef: String; SubType: integer);
var
  lFam: TGedComObj;
begin
  lFam :=FGedComFile.CreateChild('@F'+aText+'@','FAM');
  lFam['REFN'].data := 'OsBObr'+RightStr('000'+atext,4);
end;

procedure TTestGedComFile.FamilyIndiv(aText, aRef: String; SubType: integer);
var
  lFam, lInd: TGedComObj;
begin
  lInd := FGedComFile.Find('@'+aText+'@');
  lFam := FGedComFile.Find('@F'+aRef+'@');
  if assigned(lInd) and assigned (lFam) then
    begin
      if SubType = 1 then
        begin
          lFam['HUSB'].Data := '@'+aText+'@';
          lInd['FAMS'].Data := '@F'+aRef+'@';
        end else
      if SubType = 2 then
        begin
          lFam['WIFE'].Data := '@'+aText+'@';
          lInd['FAMS'].Data := '@F'+aRef+'@';
        end;
      if SubType > 2 then
        begin
          lFam.CreateChild('','CHIL','@'+aText+'@');
          lInd['FAMC'].Data := '@F'+aRef+'@';
        end;
    end;
end;

procedure TTestGedComFile.IndiName(aText, aRef: String; SubType: integer);
var
  lInd, lName: TGedComObj;
begin
  lInd := FGedComFile.Find('@'+aRef+'@');
  if not assigned(lInd) then
    lInd := FGedComFile.CreateChild('@'+aRef+'@','INDI');
  if SubType = 0 then
    begin
      lInd['NAME'].Data := aText
    end
  else
  if SubType = 1 then
    begin
      lInd['NAME'].Data := '/'+aText+'/';
      lInd['NAME']['SURN'].data:=aText;
    end
  else
  if SubType = 2 then
    begin
      lInd['NAME'].Data := aText+' '+lInd['NAME'].Data;
      lInd['NAME']['GIVN'].data:=aText;
    end

end;

procedure TTestGedComFile.IndiData(aText, aRef: String; SubType: integer);
var
  lInd: TGedComObj;
begin
lInd := FGedComFile.Find('@'+aRef+'@');
if assigned(lInd) then
  case SubType of
    8: lind['RELI'].Data := aText;
  else
     lind['NOTE'].Data :=lind['NOTE'].Data+'/'+ aText;
  end;
end;

procedure TTestGedComFile.IndiDate(aText, aRef: String; SubType: integer);
var
  lInd: TGedComObj;
begin
  lInd := FGedComFile.Find('@'+aRef+'@');
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

procedure TTestGedComFile.IndiPlace(aText, aRef: String; SubType: integer);
var
  lInd: TGedComObj;
begin
  lInd := FGedComFile.Find('@'+aRef+'@');
  if assigned(lInd)  then
  case SubType of
    1: lInd['BIRT']['PLAC'].Data := aText;
    2: lInd['BAPT']['PLAC'].Data := aText;
    4: lInd['DEAT']['PLAC'].Data := aText;
    5: lInd['BURI']['PLAC'].Data := aText;
    else
       lind['DATE'].Data := aText;
  end;
end;

procedure TTestGedComFile.IndiRef(aText, aRef: String; SubType: integer);
var
  lInd: TGedComObj;
begin
lInd := FGedComFile.Find('@'+aRef+'@');
if assigned(lInd)  then
  lind['REFN'].Data := aText;
end;

constructor TTestGedComFile.Create;

var
  i: Integer;

begin
  inherited Create;
  FDataPath:='Data';
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      break
    else
      FDataPath:='..'+DirectorySeparator+FDataPath;
  if not DirectoryExists(FDataPath) then
    FDataPath:=GetAppConfigDir(true)
  else
    FDataPath:=FDataPath+DirectorySeparator+'GenData';
  if not DirectoryExists(FDataPath) then
    ForceDirectories(FDataPath);
end;

initialization

  RegisterTest(TTestGedComFile);
end.

