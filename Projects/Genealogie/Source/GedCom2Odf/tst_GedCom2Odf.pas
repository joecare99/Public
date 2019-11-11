unit tst_GedCom2Odf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,Cmp_GedComFile, cmp_GedComDocumentWriter;

type

  { TTestGed2Odf }

  TTestGed2Odf= class(TTestCase)
  private
    FDataPath: String;
    FGedComFile: TGedComFile;
    FGenDocumentWriter: TGenDocumentWriter;
    procedure OnLongOp(Sender: TObject);

  protected
    procedure LoadGedFile(const lName: String);
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure testEvent2Readable;
    Procedure TestMuster;
    Procedure TestEntry0052rr;
    Procedure TestEntry0001ff;
  public
      constructor Create; override;
  end;

implementation

uses Cls_GedComExt,unt_IGenBase2,Forms;

const CMuster='Muster_GEDCOM_UTF-8.ged';
      CEntryGC0052rr='EntryGC0052rr.New.ged';
      CEntry001ff2='Entry0001ff2.ged';


constructor TTestGed2Odf.Create;
var
    i: integer;
begin
    inherited Create;
    FDataPath := 'Data';
    for i := 0 to 2 do
        if DirectoryExists(FDataPath) then
            break
        else
            FDataPath := '..' + DirectorySeparator + FDataPath;
    if not DirectoryExists(FDataPath) then
        FDataPath := GetAppConfigDir(True)
    else
        FDataPath := FDataPath + DirectorySeparator + 'GenData';
    if not DirectoryExists(FDataPath) then
        ForceDirectories(FDataPath);
end;

procedure TTestGed2Odf.TestSetUp;
begin
  CheckNotNull(FGedComFile, 'FGedComFile is assigned');
  CheckNotNull(FGenDocumentWriter, 'FGenDocumentWriter is assigned');
  CheckNotNull(FGenDocumentWriter.Genealogy, 'FGenDocumentWriter.GedComFile is assigned');
  CheckNotNull(FGenDocumentWriter.Document, 'FGenDocumentWriter.Document is assigned');
  checktrue(DirectoryExists(FDataPath), 'DataPath exists');
end;

procedure TTestGed2Odf.testEvent2Readable;
begin
  CheckEquals('(s) 20.11.1723',FGenDocumentWriter.EventDateToReadable('EST 20 NOV 1723'),'E2R(EST 20 NOV 1723)');
  CheckEquals('vor 1.01.1970',FGenDocumentWriter.EventDateToReadable('BEF 1 JAN 1970'),'E2R(BEF 1 JAN 1970)');
  CheckEquals('31.12.1234',FGenDocumentWriter.EventDateToReadable('31 DEC 1234'),'E2R(31 DEC 1234)');
  CheckEquals('15.08.1979',FGenDocumentWriter.EventDateToReadable('15 AUG 1979'),'E2R(15 AUG 1979)');
  CheckEquals('(err) 1900',FGenDocumentWriter.EventDateToReadable('CAL 1900'),'E2R(CAL 1900)');
  CheckEquals('um 1860',FGenDocumentWriter.EventDateToReadable('ABT 1860'),'E2R(ABT 1860)');
  CheckEquals('(s) 1833',FGenDocumentWriter.EventDateToReadable('EST 1833'),'E2R(EST 1833)');
  CheckEquals('nach 1730',FGenDocumentWriter.EventDateToReadable('AFT 1730'),'E2R(AFT 1730)');
end;

procedure TTestGed2Odf.TestMuster;

var
  lChlds: TGedComObj;
  lFams:  IGenFamily;
  lFilename: String;
begin
  lFilename := Fdatapath+DirectorySeparator +CMuster;
  LoadGedFile(lFilename);
  FGenDocumentWriter.PrepareDocument;
  for lChlds in FGedComFile do
      if lChlds.inheritsfrom(TGedFamily) then
           FgenDocumentWriter.AppendFamily(lChlds as IGenFamily);
  FGenDocumentWriter.SortAndRenumberFamiliies;
  {
  for lFams in FGenDocumentWriter.EnumerateFamilies do
      FGenDocumentWriter.WriteFamily(lFams);
   }
   FGenDocumentWriter.FamList.SaveToFile(ChangeFileExt(lFilename,'f.txt'));
   FGenDocumentWriter.PlacList.SaveToFile(ChangeFileExt(lFilename,'p.txt'));
   FGenDocumentWriter.Plac2List.SaveToFile(ChangeFileExt(lFilename,'p2.txt'));
   FGenDocumentWriter.IndList.SaveToFile(ChangeFileExt(lFilename,'i.txt'));
   FGenDocumentWriter.OccuList.SaveToFile(ChangeFileExt(lFilename,'o.txt'));
   FGenDocumentWriter.WriteIndIndex;
   FGenDocumentWriter.WriteOccIndex;
   FGenDocumentWriter.WritePlaceIndex;
   FGenDocumentWriter.WritePlace2Index;
  FGenDocumentWriter.Document.SaveToSingleXml(ChangeFileExt(lFilename,'.fodt'));
end;

procedure TTestGed2Odf.TestEntry0052rr;
var
  lChlds: TGedComObj;
  lFilename: String;
begin
  lFilename := Fdatapath+DirectorySeparator +CEntryGC0052rr;
  LoadGedFile(lFilename);
  FGenDocumentWriter.PrepareDocument;
  for lChlds in FGedComFile do
      if lChlds.inheritsfrom(TGedFamily) then
           FgenDocumentWriter.AppendFamily(lChlds as IGenFamily);
  FGenDocumentWriter.SortAndRenumberFamiliies;
  {
  for lFams in FGenDocumentWriter.EnumerateFamilies do
      FGenDocumentWriter.WriteFamily(lFams);
   }
   FGenDocumentWriter.FamList.SaveToFile(ChangeFileExt(lFilename,'f.txt'));
   FGenDocumentWriter.PlacList.SaveToFile(ChangeFileExt(lFilename,'p.txt'));
   FGenDocumentWriter.Plac2List.SaveToFile(ChangeFileExt(lFilename,'p2.txt'));
   FGenDocumentWriter.IndList.SaveToFile(ChangeFileExt(lFilename,'i.txt'));
   FGenDocumentWriter.OccuList.SaveToFile(ChangeFileExt(lFilename,'o.txt'));
   FGenDocumentWriter.WriteIndIndex;
   FGenDocumentWriter.WriteOccIndex;
   FGenDocumentWriter.WritePlaceIndex;
   FGenDocumentWriter.WritePlace2Index;
  FGenDocumentWriter.Document.SaveToSingleXml(ChangeFileExt(lFilename,'.fodt'));
end;

procedure TTestGed2Odf.TestEntry0001ff;
var
  lChlds: TGedComObj;
  lFilename: String;
begin
  lFilename := Fdatapath+DirectorySeparator +CEntry001ff2;
  LoadGedFile(lFilename);
  FGenDocumentWriter.PrepareDocument;
  for lChlds in FGedComFile do
      if lChlds.inheritsfrom(TGedFamily) then
           FgenDocumentWriter.AppendFamily(lChlds as IGenFamily);
  FGenDocumentWriter.SortAndRenumberFamiliies;
  {
  for lFams in FGenDocumentWriter.EnumerateFamilies do
      FGenDocumentWriter.WriteFamily(lFams);
   }
   FGenDocumentWriter.FamList.SaveToFile(ChangeFileExt(lFilename,'f.txt'));
   FGenDocumentWriter.PlacList.SaveToFile(ChangeFileExt(lFilename,'p.txt'));
   FGenDocumentWriter.Plac2List.SaveToFile(ChangeFileExt(lFilename,'p2.txt'));
   FGenDocumentWriter.IndList.SaveToFile(ChangeFileExt(lFilename,'i.txt'));
   FGenDocumentWriter.OccuList.SaveToFile(ChangeFileExt(lFilename,'o.txt'));
   FGenDocumentWriter.WriteIndIndex;
   FGenDocumentWriter.WriteOccIndex;
   FGenDocumentWriter.WritePlaceIndex;
   FGenDocumentWriter.WritePlace2Index;
  FGenDocumentWriter.Document.SaveToSingleXml(ChangeFileExt(lFilename,'.fodt'));
end;

procedure TTestGed2Odf.OnLongOp(Sender: TObject);
begin
//  ApplicationProperties1Idle(sender,Done{%H-});
  Application.ProcessMessages;
end;

procedure TTestGed2Odf.LoadGedFile(const lName: String);
var
  str: TMemoryStream;
begin
  FGedComFile.Clear;
  if not fileexists(lName) then
       exit;
  str := TMemoryStream.Create;
  try
  str.LoadFromFile(lName);
  str.seek(0, soBeginning);
  FGedComFile.LoadFromStream(str);
  finally
    freeandnil(str)
  end;
end;

procedure TTestGed2Odf.SetUp;
begin
  FGedComFile := TGedComFile.Create;
  FGenDocumentWriter := TGenDocumentWriter.Create(nil);
  FGenDocumentWriter.Genealogy := FGedComFile;
  FGenDocumentWriter.OnLongOp:=@OnLongOp;
end;

procedure TTestGed2Odf.TearDown;
begin
  FreeAndNil(FGedComFile);
  FreeAndNil(FGenDocumentWriter);
end;

initialization

  RegisterTest(TTestGed2Odf);
end.

