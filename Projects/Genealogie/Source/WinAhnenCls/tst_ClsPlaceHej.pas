unit tst_ClsPlaceHej;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, cls_HejPlaceData;

type

  { TTestPlaceHej }

  TTestPlaceHej= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  private
      FHejPlaceData: THejPlaceData;
      FDataDir: string;

  published
    procedure TestSetUp;
    procedure TestReadStream;
    procedure TestWriteStream;
    procedure TestToString;
    procedure TestToPasStruct;
  end;

  { TTestClsPlaceHej }

   TTestClsPlaceHej= class(TTestCase)
   protected
     procedure SetUp; override;
     procedure TearDown; override;
   private
       FClsHejPlaces: TClsHejPlaces;
       FDataDir: string;
       Procedure CreateTestData(tested:boolean);
   published
     procedure TestSetUp;
     procedure TestReadStream;
     procedure TestReadStream2;
     procedure TestWriteStream;

   end;

implementation

uses unt_PlaceTestData;

resourcestring
  DefDataDir = 'Data';

  { TTestClsPLaceHej }

    procedure TTestClsPlaceHej.SetUp;
  var i:Integer;
  begin
  FClsHejPlaces:=TClsHejPlaces.Create;
  FDataDir := DefDataDir;
  for i := 0 to 2 do
      if not DirectoryExists(FDataDir) then
          FDataDir := '..' + DirectorySeparator + FDataDir
      else
          break;
  FDataDir := FDataDir + DirectorySeparator + 'HejTest';
  end;

    procedure TTestClsPlaceHej.TearDown;
  begin
    FreeAndNil(FClsHejPlaces);
  end;

  procedure TTestClsPlaceHej.CreateTestData(tested: boolean);
  var
     ls: THejPlaceData;
   begin
     for ls in cPlace do
     FClsHejPlaces.SetPlace(ls);
  end;

    procedure TTestClsPlaceHej.TestSetUp;
  begin
    CheckTrue(DirectoryExists(FDataDir),'Data-Directory '+FDataDir+' exists');
    CheckNotNull(FClsHejPlaces,'Places are assigned');
    CheckEquals(0,FClsHejPlaces.Count,'No Places');
  end;

    procedure TTestClsPlaceHej.TestReadStream;
  var
      lStr: TStream;
  begin
      Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
      lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
        try
          lStr.Seek(1074,soBeginning);
          FClsHejPlaces.ReadFromStream(lStr);
          CheckEquals(7,FClsHejPlaces.Count,'7 Places');
          CheckEquals(1356, lStr.Position, 'Stringposition is 1356');
       finally
          freeandnil(lStr)
        end;

        FClsHejPlaces.Clear;
        CheckEquals(0,FClsHejPlaces.Count,'No Places');

        Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'), 'Datei existiert');
        lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'BigData5.hej', fmOpenRead);
          try
            lStr.Seek(11102443,soBeginning);
            FClsHejPlaces.ReadFromStream(lStr);
            CheckEquals(2538,FClsHejPlaces.Count,'3 Places');
            CheckEquals(11179859, lStr.Position, 'Stringposition is 11179859');
          finally
            freeandnil(lStr)
          end;
  end;

    procedure TTestClsPlaceHej.TestReadStream2;
  var
      lStr: TStream;
      lStl:TMemoryStream;
  begin
      Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
      lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
        try
          lStr.Seek(1074,soBeginning);
          FClsHejPlaces.ReadFromStream(lStr);
          CheckEquals(7,FClsHejPlaces.Count,'7 Places');
          CheckEquals(1356, lStr.Position, 'Stringposition is 1356');
        finally
          freeandnil(lStr)
        end;

        FClsHejPlaces.Clear;
        CheckEquals(0,FClsHejPlaces.Count,'No Places');

        Check(FileExists(FDataDir + DirectorySeparator + 'BigData5.hej'), 'Datei existiert');
        lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'BigData5.hej', fmOpenRead);
        lStl := TMemoryStream.Create;
          try
            lStl.LoadFromStream(lstr);
            lStl.Seek(11102443,soBeginning);
            FClsHejPlaces.ReadFromStream(lStl);
            CheckEquals(2538,FClsHejPlaces.Count,'3 Places');
            CheckEquals(11179859, lStl.Position, 'Stringposition is 11179859');
          finally
            freeandnil(lStr);
            freeandnil(lStl)
          end;
  end;

    procedure TTestClsPlaceHej.TestWriteStream;
  begin

  end;


procedure TTestPlaceHej.TestSetUp;
var
  i: TEnumHejPlaceDatafields;
begin
 CheckTrue(DirectoryExists(FDataDir),'Data-Directory '+FDataDir+' Exists');
  for i in TEnumHejPlaceDatafields do
        if  (i <= hplace_ID) then
            CheckEquals(0, FHejPlaceData.Data[i], 'Data[' + CHejPlaceDataDesc[i] + '] is 0')
        else
             CheckEquals('', FHejPlaceData.Data[i], 'Data[' + CHejPlaceDataDesc[i] +
                '] is ''''');
end;

procedure TTestPlaceHej.SetUp;
var
  i: Integer;
begin
  FHejPlaceData.Clear;
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

procedure TTestPlaceHej.TearDown;
begin
  FHejPlaceData.Clear;
end;

procedure TTestPlaceHej.TestReadStream;
var
    lStr: TStream;
begin
    Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
        lStr.seek(1061,soBeginning);
        CheckEquals(false, FHejPlaceData.TestStreamHeader(lStr), 'Teste Streamheader');
        CheckEquals(1061, lStr.Position, 'Stringposition is ');
        lStr.seek(1074,soBeginning);
        CheckEquals(true, FHejPlaceData.TestStreamHeader(lStr), 'Teste Streamheader');
        CheckEquals(1080, lStr.Position, 'Stringposition is ');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals(-1, FHejPlaceData.id, 'ID is -1');
        CheckEquals('Adelsheim', FHejPlaceData.PlaceName, 'PlaceName is Adelsheim');
        CheckEquals('', FHejPlaceData.ZIPCode, 'ZIPCode is 2');
        CheckEquals('', FHejPlaceData.State, 'State is Care');
        CheckEquals('', FHejPlaceData.District, 'District is Joe');
        CheckEquals('', FHejPlaceData.GOV, 'GOV is m');
        CheckEquals('', FHejPlaceData.Country, 'Country is Be');
        CheckEquals('', FHejPlaceData.PolName, 'PolName is j');
        CheckEquals('', FHejPlaceData.Parish, 'Parish is Joker');
        CheckEquals('', FHejPlaceData.County, 'County is j');
        CheckEquals('', FHejPlaceData.ShortName, 'ShortName is JaySee');
        CheckEquals(1103, lStr.Position, 'Stringposition is ');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('Binau', FHejPlaceData.PlaceName, 'PlaceName 2 is 2');
        CheckEquals('74862', FHejPlaceData.ZIPCode, 'ZIPCode 2 is 74862');
        CheckEquals('Deutschland', FHejPlaceData.State, 'State is Deutschland');
        CheckEquals('Mosbach', FHejPlaceData.District, 'District is Mosbach');
        CheckEquals('GOV', FHejPlaceData.GOV, 'GOV is GOV');
        CheckEquals('Baden-Württemberg', FHejPlaceData.Country, 'Country is Baden-Württemberg');
        CheckEquals('Binau (Gemeinde)', FHejPlaceData.PolName, 'PolName is Binau (Gemeinde)');
        CheckEquals('Neckargerach', FHejPlaceData.Parish, 'Parish is Neckargerach');
        CheckEquals('Neckar-Odenwald-Kreis', FHejPlaceData.County, 'County is Neckar-Odenwald-Kreis');
        CheckEquals('Binau', FHejPlaceData.ShortName, 'ShortName is Binau');
        CheckEquals(1235, lStr.Position, 'Stringposition is ');
        FHejPlaceData.ReadFromStream(lStr);
         CheckEquals('Eppingen', FHejPlaceData.PlaceName, 'PlaceName 3 is Eppingen');
        FHejPlaceData.ReadFromStream(lStr);
         CheckEquals('Mosbach', FHejPlaceData.PlaceName, 'PlaceName 4 is Mosbach');
        FHejPlaceData.ReadFromStream(lStr);
         CheckEquals('Neckarbischofsheim', FHejPlaceData.PlaceName, 'PlaceName 5 is Neckarbischofsheim');
        FHejPlaceData.ReadFromStream(lStr);
         CheckEquals('Nimmerland', FHejPlaceData.PlaceName, 'PlaceName 6 is Nimmerland');
        FHejPlaceData.ReadFromStream(lStr);
         CheckEquals('Sulzfeld', FHejPlaceData.PlaceName, 'PlaceName 7 is Sulzfeld');
         CheckEquals(1356, lStr.Position, 'Stringposition is ');
        FHejPlaceData.ReadFromStream(lStr);
         CheckEquals('quellv', FHejPlaceData.PlaceName, 'PlaceName is quellv');
        CheckEquals(1364, lStr.Position, 'Stringposition is ');
      finally
        FreeAndNil(lStr);
      end;
end;

procedure TTestPlaceHej.TestWriteStream;
var
       lStr: TStream;
   begin
     lStr:=TMemoryStream.Create;
     try
       cPlace[0].WriteToStream(lStr);
       CheckEquals(14,lStr.Position,'Stringposition is ');
       cPlace[8].WriteToStream(lStr);
       CheckEquals(61,lStr.Position,'Stringposition 2 is ');
       cPlace[9].WriteToStream(lStr);
       CheckEquals(93,lStr.Position,'Stringposition 3 is ');
       cPlace[10].WriteToStream(lStr);
       CheckEquals(126,lStr.Position,'Stringposition 4 is ');
     finally
       FreeAndNil(lStr);
     end;

       if FileExists(FDataDir + DirectorySeparator + 'Care_out.phej') then
          deleteFile(FDataDir + DirectorySeparator + 'Care_out.phej');
       lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care_out.phej', fmCreate + fmOpenWrite);
         try
           cPlace[0].WriteToStream(lStr);
           cPlace[8].WriteToStream(lStr);
           cPlace[9].WriteToStream(lStr);
           cPlace[10].WriteToStream(lStr);
           cPlace[11].WriteToStream(lStr);
         finally
           FreeAndNil(lStr);
         end;

end;

procedure TTestPlaceHej.TestToString;
var
  lStr: TFileStream;
begin
  CheckEquals('',cPlace[0].toString,'cTestPlace[0].toString');
  CheckEquals('Hamburg, Hamburg, Hamburg, Germany',cPlace[8].toString,'cPlace[8].toString');
  CheckEquals('Bremen, Germany',cPlace[9].toString,'cPlace[9].toString');
  CheckEquals('München, Germany',cPlace[10].toString,'cPlace[10].toString');
  CheckEquals('Berlin, Germany',cPlace[11].toString,'cPlace[11].toString');
  Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
         lStr.seek(1074,soBeginning);
        CheckEquals(true, FHejPlaceData.TestStreamHeader(lStr), 'Teste Streamheader');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('Adelsheim',FHejPlaceData.toString,'FHejPlaceData[0].toString');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('Binau, Neckar-Odenwald-Kreis, Baden-Württemberg, Deutschland',FHejPlaceData.toString,'FHejPlaceData[1].toString');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('Eppingen',FHejPlaceData.toString,'FHejPlaceData[2].toString');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('Mosbach',FHejPlaceData.toString,'FHejPlaceData[3].toString');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('Neckarbischofsheim',FHejPlaceData.toString,'FHejPlaceData[4].toString');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('Nimmerland',FHejPlaceData.toString,'FHejPlaceData[5].toString');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('Sulzfeld',FHejPlaceData.toString,'FHejPlaceData[5].toString');
      finally
         FreeAndNil(lStr);
      end;
end;

procedure TTestPlaceHej.TestToPasStruct;
var
  lStr: TFileStream;
begin
  CheckEquals('(ID:0;PlaceName:'''';ZIPCode:'''';State:'''';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',cPlace[0].ToPasStruct,'cTestPlace[0].ToPasStruct');
  CheckEquals('(ID:8;PlaceName:''Hamburg'';ZIPCode:''22609'';State:''Germany'';District:'''';GOV:'''';Country:''Hamburg'';PolName:'''';Parish:'''';County:''Hamburg'';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',cPlace[8].ToPasStruct,'cTestPlace[1].ToPasStruct');
  CheckEquals('(ID:9;PlaceName:''Bremen'';ZIPCode:''20000'';State:''Germany'';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',cPlace[9].ToPasStruct,'cTestPlace[2].ToPasStruct');
  CheckEquals('(ID:10;PlaceName:''München'';ZIPCode:''30000'';State:''Germany'';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',cPlace[10].ToPasStruct,'cTestPlace[3].ToPasStruct');
  CheckEquals('(ID:11;PlaceName:''Berlin'';ZIPCode:''80000'';State:''Germany'';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',cPlace[11].ToPasStruct,'cTestPlace[4].ToPasStruct');
  Check(FileExists(FDataDir + DirectorySeparator + 'Care.hej'), 'Datei existiert');
    lStr := TFileStream.Create(FDataDir + DirectorySeparator + 'Care.hej', fmOpenRead);
      try
         lStr.seek(1074,soBeginning);
        CheckEquals(true, FHejPlaceData.TestStreamHeader(lStr), 'Teste Streamheader');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('(ID:-1;PlaceName:''Adelsheim'';ZIPCode:'''';State:'''';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',FHejPlaceData.ToPasStruct,'FHejPlaceData[0].ToPasStruct');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('(ID:-1;PlaceName:''Binau'';ZIPCode:''74862'';State:''Deutschland'';District:''Mosbach'';GOV:''GOV'';Country:''Baden-Württemberg'';PolName:''Binau (Gemeinde)'';Parish:''Neckargerach'';County:''Neckar-Odenwald-Kreis'';ShortName:''Binau'';Longitude:''L90'';Magnitude:''B21'';MaidenheadLoc:''Maidenhead''{%H-})',FHejPlaceData.ToPasStruct,'FHejPlaceData[1].ToPasStruct');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('(ID:-1;PlaceName:''Eppingen'';ZIPCode:'''';State:'''';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',FHejPlaceData.ToPasStruct,'FHejPlaceData[2].ToPasStruct');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('(ID:-1;PlaceName:''Mosbach'';ZIPCode:'''';State:'''';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',FHejPlaceData.ToPasStruct,'FHejPlaceData[3].ToPasStruct');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('(ID:-1;PlaceName:''Neckarbischofsheim'';ZIPCode:'''';State:'''';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',FHejPlaceData.ToPasStruct,'FHejPlaceData[4].ToPasStruct');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('(ID:-1;PlaceName:''Nimmerland'';ZIPCode:'''';State:'''';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',FHejPlaceData.ToPasStruct,'FHejPlaceData[5].ToPasStruct');
        FHejPlaceData.ReadFromStream(lStr);
        CheckEquals('(ID:-1;PlaceName:''Sulzfeld'';ZIPCode:'''';State:'''';District:'''';GOV:'''';Country:'''';PolName:'''';Parish:'''';County:'''';ShortName:'''';Longitude:'''';Magnitude:'''';MaidenheadLoc:''''{%H-})',FHejPlaceData.ToPasStruct,'FHejPlaceData[5].ToPasStruct');
      finally
         FreeAndNil(lStr);
      end;
end;


initialization

  RegisterTest(TTestPlaceHej);
  RegisterTest(TTestClsPlaceHej);
end.

