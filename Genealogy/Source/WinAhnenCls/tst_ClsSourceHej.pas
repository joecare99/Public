unit tst_ClsSourceHej;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFNDEF FPC},TestFramework {$Else} ,fpcunit, testutils,
  testregistry {$endif}, cls_HejSourceData;

type

  { TTestSourceHej }

  TTestSourceHej= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  private
      FHejSourData: THejSourData;
      FDataDir: string;

  published
    procedure TestSetUp;
    procedure TestReadStream;
    procedure TestWriteStream;
    procedure TestToString;
    procedure TestToPasStruct;
  end;

  { TTestClsSourceHej }

   TTestClsSourceHej= class(TTestCase)
   protected
     procedure SetUp; override;
     procedure TearDown; override;
   private
       FClsHejSources: TClsHejSources;
       FDataDir: string;
       Procedure CreateTestData(tested:boolean=false);
   published
     procedure TestSetUp;
     Procedure TestClear;
     PRocedure TestIndexOf;
     Procedure TestSetsource;
     procedure TestReadStream;
     procedure TestReadStream2;
     procedure TestWriteStream;
   end;

implementation

uses unt_SourceTestData;

resourcestring
  DefDataDir = 'Data';

  { TTestClsSourceHej }

   procedure TTestClsSourceHej.SetUp;
   var i:Integer;
   begin
   FClsHejSources:=TClsHejSources.Create;
   FDataDir := DefDataDir;
   for i := 0 to 2 do
       if not DirectoryExists(FDataDir) then
           FDataDir := '..' + DirectorySeparator + FDataDir
       else
           break;
   FDataDir := FDataDir + DirectorySeparator + 'HejTest';
   end;

   procedure TTestClsSourceHej.TearDown;
   begin
     FreeAndNil(FClsHejSources);
   end;

   procedure TTestClsSourceHej.CreateTestData(tested: boolean);
   var
     ls: THejSourData;
   begin
     for ls in cSource do
     FClsHejSources.SetSource(ls);
   end;

   procedure TTestClsSourceHej.TestSetUp;
   begin
     CheckTrue(DirectoryExists(FDataDir),'Data-Directory '+FDataDir+' exists');
     CheckNotNull(FClsHejSources,'Sources are assigned');
     CheckEquals(0,FClsHejSources.Count,'No Sources');
   end;

   procedure TTestClsSourceHej.TestClear;
   begin
     CreateTestData;
     CheckEquals(17,FClsHejSources.Count,'FClsHejSources.Count');
     FClsHejSources.Clear;
     CheckEquals(0,FClsHejSources.Count,'FClsHejSources.Count = 0');
   end;

   procedure TTestClsSourceHej.TestIndexOf;
   begin
     CreateTestData ;
      CheckEquals(0,FClsHejSources.IndexOf(''),'FClsHejSources.IndexOf('''')');
      CheckEquals(13,FClsHejSources.IndexOf('Ancestry.com'),'FClsHejSources.IndexOf(''Ancestry.com'')');
      CheckEquals(14,FClsHejSources.IndexOf('Eigenes Wissen'),'FClsHejSources.IndexOf(''Eigenes Wissen'')');
      CheckEquals(15,FClsHejSources.IndexOf('OSB Meißenheim'),'FClsHejSources.IndexOf(''OSB Meißenheim'')');
      CheckEquals(16,FClsHejSources.IndexOf('Test'),'FClsHejSources.IndexOf(''Test'')');
      CheckEquals(-1,FClsHejSources.IndexOf('Test2'),'FClsHejSources.IndexOf(''Test2'')');
   end;

   procedure TTestClsSourceHej.TestSetsource;
   begin

   end;

   procedure TTestClsSourceHej.TestReadStream;
   var
       lStr: TStream;
   begin
       Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
       lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
         try
           CheckEquals(1725, lStr.size, 'Streamsize is 1725');
           lStr.Seek(1356,soBeginning);
           FClsHejSources.ReadFromStream(lStr);
           CheckEquals(12,FClsHejSources.Count,'12 Sources');
           CheckEquals(1725, lStr.Position, 'Stringposition is 1725');
        finally
           freeandnil(lStr)
         end;

         FClsHejSources.Clear;
         CheckEquals(0,FClsHejSources.Count,'No Sources');

         Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'), 'Datei existiert');
         lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'BigData5.hej', fmOpenRead);
           try
             CheckEquals(11760592, lStr.size, 'Streamsize is 11760592');
             lStr.Seek(11179859,soBeginning);
             FClsHejSources.ReadFromStream(lStr);
             CheckEquals(17139,FClsHejSources.Count,'17139 Sources');
             CheckEquals(11760592, lStr.Position, 'Streamposition is 11760592');
           finally
             freeandnil(lStr)
           end;
   end;

   procedure TTestClsSourceHej.TestReadStream2;
   var
       lStr: TStream;
       lStl:TMemoryStream;
   begin
       Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
       lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
         try
           CheckEquals(1725, lStr.size, 'Streamsize is 1725');
           lStr.Seek(1356,soBeginning);
           FClsHejSources.ReadFromStream(lStr);
           CheckEquals(12,FClsHejSources.Count,'12 Sources');
           CheckEquals(1725, lStr.Position, 'Stringposition is 1725');
         finally
           freeandnil(lStr)
         end;

         FClsHejSources.Clear;
         CheckEquals(0,FClsHejSources.Count,'No Sources');

         Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'), 'Datei existiert');
         lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'BigData5.hej', fmOpenRead);
         lStl := TMemoryStream.Create;
           try
             CheckEquals(11760592, lStr.size, 'Streamsize is 1725');
             lStl.LoadFromStream(lstr);
             lStl.Seek(11179859,soBeginning);
             FClsHejSources.ReadFromStream(lStl);
             CheckEquals(17139,FClsHejSources.Count,'17139 Sources');
             CheckEquals(11760592, lStl.Position, 'Streamposition is 11760592');
           finally
             freeandnil(lStr);
             freeandnil(lStl)
           end;
   end;

   procedure TTestClsSourceHej.TestWriteStream;
   begin

   end;

procedure TTestSourceHej.TestSetUp;
var
  i: TEnumHejSourDatafields;
begin
 CheckTrue(DirectoryExists(FDataDir),'Data-Directory '+FDataDir+' Exists');
  for i in TEnumHejSourDatafields do
        if  (i <= hsour_ID) then
            CheckEquals(0, FHejSourData.Data[i], 'Data[' + CHejSourDataDesc[i] + '] is 0')
        else
             CheckEquals('', FHejSourData.Data[i], 'Data[' + CHejSourDataDesc[i] +
                '] is ''''');
end;

procedure TTestSourceHej.SetUp;
var
  i: Integer;
begin
  FHejSourData.Clear;
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

procedure TTestSourceHej.TearDown;
begin
  FHejSourData.Clear;
end;

procedure TTestSourceHej.TestReadStream;
var
    lStr: TStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.seek(490,soBeginning);
        CheckEquals(false, FHejSourData.TestStreamHeader(lStr), 'Teste Streamheader');
        CheckEquals(490, lStr.Position, 'Stringposition is ');
        lStr.seek(1356,soBeginning);
        CheckEquals(true, FHejSourData.TestStreamHeader(lStr), 'Teste Streamheader');
        CheckEquals(1364, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals(-1, FHejSourData.id, 'ID is -1');
        CheckEquals('hörensagen', FHejSourData.Title, 'Title is hörensagen');
        CheckEquals('1', FHejSourData.Abk, 'Abk is 2');
        CheckEquals('2', FHejSourData.Ereignisse, 'Ereignisse is Care');
        CheckEquals('3', FHejSourData.Von, 'Von is Joe');
        CheckEquals('4', FHejSourData.Bis, 'Bis is m');
        CheckEquals('5', FHejSourData.Standort, 'Standort is Be');
        CheckEquals('6', FHejSourData.Publ, 'Publ is j');
        CheckEquals('7', FHejSourData.Rep, 'Rep is Joker');
        CheckEquals('8', FHejSourData.Bem, 'Bem is j');
        CheckEquals('9', FHejSourData.Bestand, 'Bestand is JaySee');
        CheckEquals('10', FHejSourData.Med, 'Med is JaySee');
        CheckEquals(1397, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Sterbeanzeige', FHejSourData.Title, 'Title 2 is Sterbeanzeige');
        CheckEquals('Strb.Anz.', FHejSourData.Abk, 'Abk 2 is 1');
        CheckEquals('Sterbefälle', FHejSourData.Ereignisse, 'Ereignisse is Care');
        CheckEquals('2015', FHejSourData.Von, 'Von is Joe');
        CheckEquals('2018', FHejSourData.Bis, 'Bis is m');
        CheckEquals('Heidelberg', FHejSourData.Standort, 'Standort is Heidelberg');
        CheckEquals('RNZ', FHejSourData.Publ, 'Publ is RNZ');
        CheckEquals('Druckergasse 15', FHejSourData.Rep, 'Rep is Druckergasse 15');
        CheckEquals('Kann Online abgefragt werden', FHejSourData.Bem, 'Bem is j');
        CheckEquals('Nur die letzten 14 Tage', FHejSourData.Bestand, 'Bestand is JaySee');
        CheckEquals('online', FHejSourData.Med, 'Med is JaySee');
        CheckEquals(1535, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Friedhof Mosbach', FHejSourData.Title, 'Title 3 is Friedhof Mosbach');
        CheckEquals(1563, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('2', FHejSourData.Title, 'Title 4 is 2');
        CheckEquals(1576, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Taufbuch', FHejSourData.Title, 'Title 5 is Taufbuch');
        CheckEquals(1596, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Geburtsurkunde', FHejSourData.Title, 'Title 6 is Geburtsurkunde');
        CheckEquals(1622, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Rechnung', FHejSourData.Title, 'Title 7 is Rechnung');
        CheckEquals(1642, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('1', FHejSourData.Title, 'Title 8 is 1');
        CheckEquals(1655, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('3', FHejSourData.Title, 'Title 9 is 3');
        CheckEquals(1668, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Quelle1', FHejSourData.Title, 'Title 10 is Quelle1');
        CheckEquals(1687, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Quelle2', FHejSourData.Title, 'Title 11 is Quelle2');
        CheckEquals(1706, lStr.Position, 'Stringposition is ');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Quelle3', FHejSourData.Title, 'Title 12 is Quelle3');
        CheckEquals(1725, lStr.Position, 'Stringposition is ');
      finally
        FreeAndNil(lStr);
      end;
end;

procedure TTestSourceHej.TestWriteStream;
var
       lStr: TStream;
   begin
     lStr:=TMemoryStream.Create;
     try
       cSource[0].WriteToStream(lStr);
       CheckEquals(12,lStr.Position,'Stringposition is ');
       cSource[13].WriteToStream(lStr);
       CheckEquals(99,lStr.Position,'Stringposition 2 is ');
       cSource[14].WriteToStream(lStr);
       CheckEquals(180,lStr.Position,'Stringposition 3 is ');
       cSource[15].WriteToStream(lStr);
       CheckEquals(250,lStr.Position,'Stringposition 4 is ');
     finally
       FreeAndNil(lStr);
     end;

       if FileExists(FDataDir + DirectorySeparator + 'Care_out.shej') then
          deleteFile(FDataDir + DirectorySeparator + 'Care_out.shej');
       lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care_out.shej', fmCreate + fmOpenWrite);
         try
           cSource[0].WriteToStream(lStr);
           cSource[1].WriteToStream(lStr);
           cSource[2].WriteToStream(lStr);
           cSource[3].WriteToStream(lStr);
           cSource[4].WriteToStream(lStr);
         finally
           FreeAndNil(lStr);
         end;
end;

procedure TTestSourceHej.TestToString;
var
  lStr: TFileStream;
begin
   CheckEquals('',cSource[0].toString,'cSource[0].toString');
   CheckEquals('Ancestry.com',cSource[13].toString,'cSource[13].toString');
   CheckEquals('Eigenes Wissen',cSource[14].toString,'cSource[14].toString');
   CheckEquals('OSB Meißenheim',cSource[15].toString,'cSource[15].toString');
   CheckEquals('Test',cSource[16].toString,'cSource[16].toString');
      lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
         lStr.seek(1356,soBeginning);
        CheckEquals(true, FHejSourData.TestStreamHeader(lStr), 'Teste Streamheader');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('hörensagen',FHejSourData.toString,'FHejSourData[0].toString');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Sterbeanzeige',FHejSourData.toString,'FHejSourData[1].toString');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Friedhof Mosbach',FHejSourData.toString,'FHejSourData[2].toString');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('2',FHejSourData.toString,'FHejSourData[3].toString');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Taufbuch',FHejSourData.toString,'FHejSourData[4].toString');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Geburtsurkunde',FHejSourData.toString,'FHejSourData[5].toString');
        FHejSourData.ReadFromStream(lStr);
        CheckEquals('Rechnung',FHejSourData.toString,'FHejSourData[5].toString');
      finally
         FreeAndNil(lStr);
      end;

end;

procedure TTestSourceHej.TestToPasStruct;
var
  lStr: TFileStream;
begin
  CheckEquals('(ID:0;Title:'''';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',cSource[0].ToPasStruct,'cSource[0].ToPasStruct');
  lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
  try
     lStr.seek(1356,soBeginning);
    CheckEquals(true, FHejSourData.TestStreamHeader(lStr), 'Teste Streamheader');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''hörensagen'';Abk:''1'';Ereignisse:''2'';Von:''3'';Bis:''4'';Standort:''5'';Publ:''6'';Rep:''7'';Bem:''8'';Bestand:''9'';Med:''10''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[0].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''Sterbeanzeige'';Abk:''Strb.Anz.'';Ereignisse:''Sterbefälle'';Von:''2015'';Bis:''2018'';Standort:''Heidelberg'';Publ:''RNZ'';Rep:''Druckergasse 15'';Bem:''Kann Online abgefragt werden'';Bestand:''Nur die letzten 14 Tage'';Med:''online''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[1].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''Friedhof Mosbach'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[2].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''2'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[3].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''Taufbuch'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[4].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''Geburtsurkunde'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[5].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''Rechnung'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[5].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''1'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[5].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''3'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[5].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''Quelle1'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[5].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''Quelle2'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[5].ToPasStruct');
    FHejSourData.ReadFromStream(lStr);
    CheckEquals('(ID:-1;Title:''Quelle3'';Abk:'''';Ereignisse:'''';Von:'''';Bis:'''';Standort:'''';Publ:'''';Rep:'''';Bem:'''';Bestand:'''';Med:''''{%H-})',FHejSourData.ToPasStruct,'FHejSourData[5].ToPasStruct');
  finally
     FreeAndNil(lStr);
  end;

end;


initialization

  RegisterTest(TTestSourceHej);
  RegisterTest(TTestClsSourceHej);
end.

