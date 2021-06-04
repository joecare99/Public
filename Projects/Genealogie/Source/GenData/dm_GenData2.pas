unit dm_GenData2;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, sqldb, sqldblib,
    mysql57conn, FileUtil, Unt_Config, DB;

type

    { TdmGenData }

    TdmGenData = class(TDataModule)
        Config1: TConfig;
        MySQL57Connection1: TMySQL57Connection;
        qryIndividuals: TSQLQuery;
        qryMarriages: TSQLQuery;
        qryIndividual_Spouse: TSQLQuery;
        qryIndividual_Kids: TSQLQuery;
        qryIndividual_Mother: TSQLQuery;
        qryIndividual_Father: TSQLQuery;
        SQLTransaction1: TSQLTransaction;
        SQLConnector1: TSQLConnector;
        qryInternal: TSQLQuery;
        procedure qryIndividualsBeforePost(DataSet: TDataSet);
        procedure SQLConnector1AfterConnect(Sender: TObject);
    private
        FListdbs: TStrings;
        FProjectIsOpen: boolean;
        function getDB_Connected: boolean;
        function getProjectIsOpen: boolean;
        function getSQLDatabaseName: string;
        function NormalizeSex(AValue: string): string;
        function NormalizeYN(AValue: string): string;
        procedure setDB_Connected(AValue: boolean);
        procedure setSQLDatabaseName(AValue: string);
        { private declarations }
    public
        { public declarations }
        destructor Destroy; override;
        procedure ListDBTables(const Ts: TStrings; Systemtables: boolean = False);
        procedure ListDBTableFields(TableName: string; const ts: TStrings);

        procedure GetDBSchemas(const aList: TStrings);
        procedure CreateMandant(AMandantName: string; onProgress: TNotifyEvent = nil);
        procedure DeleteMandant(const AMandantName: string);
        procedure SetMandant(const AMandantName: string; out bSuccess: boolean);
        function GetMandant: string;

        procedure ReadCfgConnection(out Host, User, Password: string);
        procedure WriteCfgConnection(Host, User, Password: string);
        procedure ReadCfgProject(out lProjectName: string; out lConnected: boolean);
        procedure WriteCfgProject(const ProjectName: string; Connected: boolean);

        procedure SetDBHostUserPass(const lDBHostName, lDBUser, lDBPassword: string;
            out Success: boolean);
        function NormalizeDateModif(AValue: string): string;

        property ListDBs: TStrings read FListdbs;
        property SQLDatabaseName: string read getSQLDatabaseName write setSQLDatabaseName;
        property DB_Connected: boolean read getDB_Connected write setDB_Connected;
        property ProjectIsOpen: boolean read getProjectIsOpen;
    end;

var
    dmGenData: TdmGenData;

const
    SR_Array_DModif: array[0..9] of string =
        ('ca', 'Abt',
        'vo', 'Bef',
        'na', 'Aft',
        'um', 'Est',
        're', 'Cal');
    SR_Array_jn: array[0..3] of string =
        ('j', 'Y',
        'n', 'N');
    SR_Array_Sex: array[0..5] of string =
        ('m', 'M',
        'w', 'F',
        '?', 'U');

    Function MyHash(s:String):int64;
    Function Encode(s, key: string; Salt: int64): string;
    Function Decode(c, key: string; Salt: int64): string;


implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

resourcestring
    rsDatapath = 'Data';
    rsSelectFromTable = 'select * from `%s`;';
    rsQuote = '`%s`';
    rsShowDatabase = 'show databases';
    rsCreateSchema = 'CREATE DATABASE `%s`;';
    rsCreateIndividuals = 'CREATE TABLE `%s`.`Individuals` (' +
        '`idIndividual` INT(11) NOT NULL COMMENT ''id des Individuums, (Primary Key)'',' +
        '`idIndividual_Father` INT(11) NOT NULL DEFAULT ''0'' COMMENT ''id-Verbindung zu Vater'','
        +
        '`idIndividual_Mother` INT(11) NOT NULL DEFAULT ''0'' COMMENT ''id-Verbindung zu Mutter'','
        +
        '`FamilyName` VARCHAR(100) NULL DEFAULT NULL COMMENT ''Familienname'',' +
        '`GivenName` VARCHAR(100) NULL DEFAULT NULL COMMENT ''Vorname'',' +
        '`Sex` ENUM(''M'',''F'',''U'') NOT NULL DEFAULT ''U'' COMMENT ''Geschlecht'',' +
        '`Religion` VARCHAR(10) NULL DEFAULT NULL COMMENT ''Religionszugehörigkeit (Abk)'',' +
        '`Occupation` VARCHAR(100) NULL DEFAULT NULL COMMENT ''Beruf'',' +
        '`Birth` DATETIME NULL DEFAULT NULL,' +
        '`BirthModif` ENUM('''',''Abt'',''Est'',''Cal'',''Bef'',''Aft'') NOT NULL DEFAULT '''','
        +
        //  ENUM('''',''Abt'',''Est'',''Cal'',''Bef'',''Aft'') NOT NULL DEFAULT '''','+
        '`Birthplace` VARCHAR(100) NULL DEFAULT '''',' +
        '`BirthSource` VARCHAR(100) NULL DEFAULT '''',' +
        '`BaptDate` DATETIME NULL DEFAULT NULL,' +
        '`BaptModif` ENUM('''',''Abt'',''Est'',''Cal'',''Bef'',''Aft'') NULL DEFAULT '''','
        +
        '`BaptPlace` VARCHAR(100) NULL DEFAULT '''',' +
        '`Godparents` VARCHAR(100) NULL DEFAULT '''',' +
        '`BaptSource` VARCHAR(100) NULL DEFAULT '''',' +
        '`Residence` VARCHAR(100) NULL DEFAULT '''',' +
        '`DeathDate` DATETIME NULL DEFAULT NULL,' +
        '`DeathModif` ENUM('''',''Abt'',''Est'',''Cal'',''Bef'',''Aft'') NULL DEFAULT '''','
        +
        '`DeathPlace` VARCHAR(100) NULL DEFAULT '''',' +
        '`DeathReason` VARCHAR(100) NULL DEFAULT '''',' +
        '`DearhSource` VARCHAR(100) NULL DEFAULT '''',' +
        '`BurialDate` DATETIME NULL DEFAULT NULL,' +
        '`BurialModif` ENUM('''',''Abt'',''Est'',''Cal'',''Bef'',''Aft'') NULL DEFAULT '''','
        +
        '`BurialPlace` VARCHAR(100) NULL DEFAULT '''',' +
        '`BurialSource` VARCHAR(100) NULL DEFAULT '''',' +
        '`Text` LONGTEXT NULL,' +
        '`living` ENUM('''',''Y'',''N'') NULL DEFAULT ''N'',' +
        '`AKA` VARCHAR(100) NULL DEFAULT '''',' +
        '`Index` VARCHAR(30) NULL DEFAULT '''',' +
        '`Adopted` VARCHAR(100) NULL DEFAULT '''',' +
        '`FarmName` VARCHAR(100) NULL DEFAULT '''',' +
        '`AdrStreet` VARCHAR(100) NULL DEFAULT '''',' +
        '`AdrAddit` VARCHAR(100) NULL DEFAULT '''',' +
        '`AdrPLZ` VARCHAR(100) NULL DEFAULT '''',' +
        '`AdrPlace` VARCHAR(100) NULL DEFAULT '''',' +
        '`AdrPlaceAddit` VARCHAR(100) NULL DEFAULT '''',' +
        '`Age` VARCHAR(100) NULL DEFAULT '''',' +
        '`Phone` VARCHAR(100) NULL DEFAULT '''',' +
        '`eMail` VARCHAR(100) NULL DEFAULT '''',' +
        '`WebAdr` VARCHAR(100) NULL DEFAULT '''',' +
        '`NameSource` VARCHAR(100) NULL DEFAULT '''',' +
        '`CallName` VARCHAR(100) NULL DEFAULT '''',' +
        'PRIMARY KEY (`idIndividual`),' + 'INDEX `Index` (`Index`),' +
        'INDEX `FamilyName` (`FamilyName`)' +
        ') ' +
        'COLLATE=''utf8_general_ci''' + ' ENGINE=InnoDB;';
    rsCreateAdoption = 'CREATE TABLE `%s`.`adoptions` ( ' + '`idIndividual` INT(11) NOT NULL,' +
        '`idIndividual_AdopFather` INT(11) NULL DEFAULT ''0'',' +
        '`idIndividual_AdopMother` INT(11) NULL DEFAULT ''0''' +
 //        'INDEX `idIndividual` (`idIndividual`), ' +
        ') ' +
        'COMMENT=''Adoption Information of individuals''' + ' COLLATE=''utf8_general_ci''' +
        ' ENGINE=InnoDB;';
    rsCreateMarriage = 'CREATE TABLE `%s`.`marriages` ( ' +
        '`idIndividual` INT(11) NULL DEFAULT NULL, ' +
        '`idIndividual_Spouse` INT(11) NULL DEFAULT NULL,' +
        '`Chrch` DATETIME NULL DEFAULT NULL, ' +
        '`ChrchModif` ENUM('''',''Abt'',''Est'',''Cal'',''Bef'',''Aft'') NULL DEFAULT '''', ' +
        '`ChrchPlace` VARCHAR(50) NULL DEFAULT NULL, ' +
        '`ChrchWitness` VARCHAR(50) NULL DEFAULT NULL, ' +
        '`State` DATETIME NULL DEFAULT NULL, ' +
        '`StateModif` ENUM('''',''Abt'',''Est'',''Cal'',''Bef'',''Aft'') NULL DEFAULT '''',' +
        '`StatePlace` VARCHAR(50) NULL DEFAULT NULL, ' +
        '`StateWitness` VARCHAR(50) NULL DEFAULT NULL, ' +
        '`MarrKind` VARCHAR(50) NULL DEFAULT NULL, ' +
        '`Divource` DATETIME NULL DEFAULT NULL, ' +
        '`DivourceModif` ENUM('''',''Abt'',''Est'',''Cal'',''Bef'',''Aft'') NULL DEFAULT '''',' +
        '`DivourcePlace` VARCHAR(50) NULL DEFAULT NULL, ' +
        '`ChrchSource` VARCHAR(50) NULL DEFAULT NULL, ' +
        '`StateSource` VARCHAR(50) NULL DEFAULT NULL, ' +
        '`DivourceSource` VARCHAR(50) NULL DEFAULT NULL, ' +
        'INDEX `idIndividual` (`idIndividual`), ' +
        'INDEX `idIndividual_Spouse` (`idIndividual_Spouse`) ' + ') ' +
        'COMMENT=''Marriages of individuals''' + ' COLLATE=''utf8_general_ci''' + ' ENGINE=InnoDB;';
    rsCreatePlace = 'CREATE TABLE `%s`.`places` ( ' + '`idPlace` INT(11) NULL DEFAULT NULL, ' +
        '`Placename` VARCHAR(100) NULL DEFAULT NULL COMMENT ''Ortsname'', ' +
        '`ZIP` VARCHAR(50) NULL DEFAULT NULL COMMENT ''PLZ'', ' +
        '`State` VARCHAR(100) NULL DEFAULT NULL COMMENT ''Land'', ' +
        '`Localgov` VARCHAR(100) NULL DEFAULT NULL COMMENT ''Reg. Bezirk'', ' +
        '`GOV` VARCHAR(50) NULL DEFAULT NULL COMMENT ''GOV'', ' +
        '`Country` VARCHAR(50) NULL DEFAULT NULL COMMENT ''Land'', ' +
        '`Comunity` VARCHAR(50) NULL DEFAULT NULL COMMENT ''Gemeinde'', ' +
        '`Parish` VARCHAR(50) NULL DEFAULT NULL COMMENT ''Pfarrei/Kirchspiel'', ' +
        '`Kreis` VARCHAR(50) NULL DEFAULT NULL COMMENT ''Landkreis'', ' +
        '`shortname` VARCHAR(50) NULL DEFAULT NULL COMMENT ''Kurzname'', ' +
        '`Longitude` VARCHAR(50) NULL DEFAULT NULL COMMENT ''Längengrad'', ' +
        '`Magnitude` VARCHAR(50) NULL DEFAULT NULL COMMENT ''Breitengrad'', ' +
        '`Maidenhead` VARCHAR(50) NULL DEFAULT NULL COMMENT ''Maidenhead Locator'' ' +
        ') ' + 'COMMENT=''Information on Places''' + ' COLLATE=''utf8_general_ci''' + ' ENGINE=InnoDB;';
    rsCreateSource = 'CREATE TABLE `%s`.`sources` ( ' +
        '`Description` VARBINARY(100) NULL DEFAULT NULL COMMENT ''Quellname'', ' +
        '`short` VARBINARY(100) NULL DEFAULT NULL COMMENT ''Abk'', ' +
        '`events` VARBINARY(100) NULL DEFAULT NULL COMMENT ''Eeignis(se)'', ' +
        '`from` INT(11) NULL DEFAULT NULL COMMENT ''von'', ' +
        '`to` INT(11) NULL DEFAULT NULL COMMENT ''bis'', ' +
        '`place` VARBINARY(100) NULL DEFAULT NULL COMMENT ''Standort'',' +
        '`owner` VARBINARY(100) NULL DEFAULT NULL COMMENT ''Anbieter'', ' +
        '`address` VARBINARY(100) NULL DEFAULT NULL COMMENT ''Adresse des Archives'',' +
        '`info` VARBINARY(100) NULL DEFAULT NULL COMMENT ''Bemerkung'', ' +
        '`best` VARBINARY(100) NULL DEFAULT NULL COMMENT ''Bestand'',' +
        '`medium` VARBINARY(100) NULL DEFAULT NULL COMMENT ''Medium'' ' +
        ') ' + 'COMMENT=''Information on sources'' ' + ' COLLATE=''utf8_general_ci'' ' +
        ' ENGINE=InnoDB';

const
    CIniKeyConnected = 'Connected';
    CIniKeyDatabase = 'DB';
    CIniKeyHostname = 'server';
    CIniKeyUsername = 'user';
    CIniKeySalt = 'salt';
    CIniKeyPassword = 'password';
    CIniKeyProject = 'project';

{ Allgemeines }

    function MyHash(s: String): int64;
    const cMult=$1CBE991A43; // Große Primzahl
    var
      i: Integer;
    begin
      result := 0;
      for i := 1 to length(s) do
         result := int64(RolQWord(qword(result xor (cMult *(word(s[i])+1))),23));
    end;

    function Encode(s, key: string; Salt: int64): string;

    var
        lSalt: QWord;
        i: integer;
    begin
        Result := '$';
        lSalt := QWord(Salt);
        for i := 1 to length(s) do
          begin
            if length(key)>0 then
            Result := Result + IntToHex(byte(s[i]) xor byte(
                (lsalt and $ff) + byte(key[i mod length(key) + 1]) and $ff), 2)
            else
              Result := Result + IntToHex(byte(s[i]) xor byte(
                  lsalt and $ff), 2);
            lsalt := RolQWord(lSalt, 11);
          end;
    end;

    function Decode(c, key: string; Salt: int64): string;

    var
        lSalt: QWord;
        lb: byte;
        i: integer;


    begin
        Result := '';
        if copy(c, 1, 1) = '$' then
          begin
            lSalt := QWord(Salt);
            for i := 1 to length(c) div 2 do
              begin
                lb := (byte(c[i * 2]) and $f+((byte(c[i * 2]) and $40) shr 6)*9 ) shl 4 + byte(c[i * 2 + 1]) and $f +((byte(c[i * 2+1]) and $40) shr 6)*9;
                Result := Result + char(
                    lb xor ((byte(lsalt and $ff) + byte(key[i mod length(key) + 1])) and $ff));
                lsalt := RolQWord(lSalt, 11);
              end;
          end;
    end;

{ TdmGenData }

procedure TdmGenData.SQLConnector1AfterConnect(Sender: TObject);
var
    lSqlQ: TSQLQuery;
begin
    if not assigned(FListDBs) then
        FListDBS := TStringList.Create
    else
        FListDBS.Clear;
      try
        // first try Get SchemaNames
        SQLConnector1.GetSchemaNames(FListdbs);
      except
          try
            lSqlQ := TSQLQuery.Create(self);
            lsqlq.DataBase := SQLConnector1;
            lsqlq.Transaction := SQLTransaction1;
            lsqlq.SQL.Text := rsShowDatabase;
            lsqlq.Open;
            while not lsqlq.EOF do
              begin
                FListDBS.Add(lsqlq.Fields[0].AsString);
                lsqlq.Next;
              end;
            lsqlq.Close;

          finally
            FreeAndNil(lSqlQ);
          end;
      end;
end;

procedure TdmGenData.qryIndividualsBeforePost(DataSet: TDataSet);
begin
    DataSet.Fields[5].AsString := dmGenData.NormalizeSex(DataSet.Fields[5].AsString);
    DataSet.Fields[9].AsString := dmGenData.NormalizeDateModif(DataSet.Fields[9].AsString);
    DataSet.Fields[13].AsString := dmGenData.NormalizeDateModif(
        DataSet.Fields[13].AsString);
    DataSet.Fields[19].AsString := dmGenData.NormalizeDateModif(
        DataSet.Fields[19].AsString);
    DataSet.Fields[24].AsString := dmGenData.NormalizeDateModif(
        DataSet.Fields[24].AsString);
    DataSet.Fields[28].AsString := dmGenData.NormalizeYN(DataSet.Fields[28].AsString);
end;

function TdmGenData.getSQLDatabaseName: string;
begin
    Result := SQLConnector1.DatabaseName;
end;

procedure TdmGenData.setDB_Connected(AValue: boolean);
begin
    if SQLConnector1.Connected = AValue then
        exit;
    SQLConnector1.Connected := AValue;
end;

function TdmGenData.getDB_Connected: boolean;
begin
    Result := SQLConnector1.Connected;
end;

function TdmGenData.getProjectIsOpen: boolean;
begin
    Result := FProjectIsOpen;
end;

procedure TdmGenData.setSQLDatabaseName(AValue: string);
begin
    SQLTransaction1.Active := False;
    SQLConnector1.Close;
    SQLConnector1.DatabaseName := AValue;
    SQLConnector1.Open;
    qryIndividuals.Open;
end;

destructor TdmGenData.Destroy;
begin
    FreeAndNil(FListdbs);
    inherited Destroy;
end;

procedure TdmGenData.ListDBTables(const Ts: TStrings; Systemtables: boolean);
var
    lSqlQ: TSQLQuery;
begin
    if SQLConnector1.Connected then
          try
            // first try Get Tablenames
            SQLConnector1.GetTableNames(ts, Systemtables);
          except
            // if
              try
                lSqlQ := TSQLQuery.Create(self);
                lsqlq.DataBase := SQLConnector1;
                lsqlq.Transaction := SQLTransaction1;
                lsqlq.SQL.Text := 'show tables;';
                lSqlQ.ReadOnly := True;
                lSqlQ.Open;
                ts.Clear;
                lSqlQ.First;
                while not lSqlQ.EOF do
                  begin
                    ts.Add(lSqlQ.Fields[0].Value);
                    lSqlQ.Next;
                  end;
                lSqlQ.Close;
              finally
                FreeAndNil(lSqlQ);
              end;
          end;
end;

procedure TdmGenData.ListDBTableFields(TableName: string; const ts: TStrings);
var
    lSqlQ: TSQLQuery;
begin
    if SQLConnector1.Connected then
          try
            // first try Get GetFieldNames
            SQLConnector1.GetFieldNames(format(rsQuote, [TableName]), ts);
          except
              try
                lSqlQ := TSQLQuery.Create(self);
                lsqlq.DataBase := SQLConnector1;
                lsqlq.Transaction := SQLTransaction1;
                lsqlq.SQL.Text := 'show columns from ' + format(rsQuote, [TableName]) + ';';
                lSqlQ.ReadOnly := True;
                lSqlQ.Open;
                ts.Clear;
                lSqlQ.First;
                while not lSqlQ.EOF do
                  begin
                    ts.Add(lSqlQ.Fields[0].Value);
                    lSqlQ.Next;
                  end;
                lSqlQ.Close;
              finally
                FreeAndNil(lSqlQ);
              end;
          end;
end;

procedure TdmGenData.CreateMandant(AMandantName: string; onProgress: TNotifyEvent);
begin
    if SQLConnector1.Connected then
      begin
        // Lege Neues Schema An
        SQLTransaction1.Active := False;
        SQLConnector1.Close;
        //      SQLConnector1.DatabaseName := AMandantName;
          try
            //      SQLConnector1.CreateDB;
            SQLConnector1.DatabaseName := 'mysql';
            SQLConnector1.ExecuteDirect(format(rsCreateSchema, [AMandantName]));
            SQLConnector1.DatabaseName := AMandantName;
          except
            on e: Exception do
              begin
                SQLConnector1.DatabaseName := 'mysql';
                SQLConnector1.ExecuteDirect(format(rsCreateSchema, [AMandantName]));
                SQLConnector1.DatabaseName := AMandantName;
              end;
          end;
        SQLConnector1.Connected := True;
        SQLConnector1AfterConnect(nil);
        // Lege Tabellen an
        SQLConnector1.ExecuteDirect(format(rsCreateIndividuals, [AMandantName]));
        SQLConnector1.ExecuteDirect(format(rsCreateAdoption, [AMandantName]));
        SQLConnector1.ExecuteDirect(format(rsCreateMarriage, [AMandantName]));
        SQLConnector1.ExecuteDirect(format(rsCreatePlace, [AMandantName]));
        SQLConnector1.ExecuteDirect(format(rsCreateSource, [AMandantName]));

        SQLConnector1.Connected := False;
        SQLConnector1.Connected := True;
        qryIndividuals.Open;
        FProjectIsOpen := True;
      end;
end;

procedure TdmGenData.DeleteMandant(const AMandantName: string);
begin
      try
        SQLConnector1.ExecuteDirect('DROP DATABASE ' + format(rsQuote, [AMandantName]) + ';');
        SQLConnector1.Close;
      except
      end;
end;

procedure TdmGenData.ReadCfgConnection(out Host, User, Password: string);
var lSalt :int64;
  lKey: string;
begin
    Host := Config1.getvalue(CIniKeyDatabase, CIniKeyHostname, 'localhost');
    User := Config1.getvalue(CIniKeyDatabase, CIniKeyUsername, 'root');
    lSalt := Config1.getvalue(CIniKeyDatabase, CIniKeySalt,random(high(int64)));
    lKey:=GetEnvironmentVariable('COMPUTERNAME') +User+'@'+host;
    Password := decode(Config1.getvalue(CIniKeyDatabase, CIniKeyPassword,
                Encode('<Password>',lKey,lSalt)),lKey,lSalt);
end;

procedure TdmGenData.WriteCfgConnection(Host, User, Password: string);
var
  lSalt: Int64;
  lKey:String;
begin
    Config1.setvalue(CIniKeyDatabase, CIniKeyHostname, Host);
    Config1.setvalue(CIniKeyDatabase, CIniKeyUsername, User);
    lSalt := random(high(int64));
    Config1.setvalue(CIniKeyDatabase, CIniKeySalt, lSalt);
    lKey:=GetEnvironmentVariable('COMPUTERNAME') +User+'@'+host;
    if (Password = '') then
        Config1.setvalue(CIniKeyDatabase, CIniKeyPassword, '')
    else
        Config1.setvalue(CIniKeyDatabase, CIniKeyPassword, Encode(Password,lKey,lSalt));
end;

procedure TdmGenData.ReadCfgProject(out lProjectName: string; out lConnected: boolean);
begin
    lProjectName := Config1.getvalue(CIniKeyDatabase, CIniKeyProject, 'AhnenWin');
    lConnected := Config1.getvalue(CIniKeyDatabase, CIniKeyConnected, 'false');
end;

procedure TdmGenData.WriteCfgProject(const ProjectName: string; Connected: boolean);
begin
    Config1.setvalue(CIniKeyDatabase, CIniKeyProject, ProjectName);
    Config1.setvalue(CIniKeyDatabase, CIniKeyConnected, Connected);
end;

procedure TdmGenData.SetDBHostUserPass(const lDBHostName, lDBUser, lDBPassword: string;
    out Success: boolean);
begin
    Success := False;
    with SQLConnector1 do
      begin
        Connected := False;
        FProjectIsOpen := False;
        HostName := lDBHostName;
        UserName := lDBUser;
        Password := lDBPassword;
        DatabaseName := 'mysql';
          try
            Connected := True;
            Success := Connected;
          except
            Success := False;
          end;
      end;
end;

procedure TdmGenData.SetMandant(const AMandantName: string; out bSuccess: boolean);
begin
    bSuccess := False;
    with SQLConnector1 do
      begin
        Connected := False;
          try
            DatabaseName := AMandantName;
            Connected := True;
            bSuccess := Connected;
            FProjectIsOpen := bSuccess;
          except
            // no exception
          end;
      end;
end;

function TdmGenData.GetMandant: string;
begin
    Result := SQLConnector1.DatabaseName;
end;

procedure TdmGenData.GetDBSchemas(const aList: TStrings);
begin
    aList.Clear;
    SQLConnector1AfterConnect(nil);
    aList.AddStrings(FListdbs);
end;

function CalcSimilarity(aStr1, aStr2: string): extended;

var
    i, lDif, lJ, j: integer;
begin
    Result := 0.0;
    if (length(aStr1) = 0) then
        if (Length(Astr2) = 0) then
            exit(1.0)
        else
            Exit
    else if (Length(Astr2) = 0) then
        exit(0.0);
    for i := 1 to length(aStr1) do
      begin
        lDif := length(aStr2) * 2;
        lJ := 0;
        for j := 1 to length(aStr2) do
            if aStr1[i] = aStr2[j] then
              begin
                if abs(i - j) < lDif then
                  begin
                    lDif := abs(i - j);
                    lj := j;
                  end;
              end;
        if lj > 0 then
            Result := Result + (length(aStr2)) / ((length(aStr2) - lDif) * Length(aStr1));
      end;

end;


function TdmGenData.NormalizeDateModif(AValue: string): string;

const
    SR_Array_DModif: array[0..19] of string =
        ('ca', 'Abt',
        '~', 'Abt',
        'vo', 'Bef',
        'bf', 'Bef',
        '<', 'Bef',
        'na', 'Aft',
        '>', 'Aft',
        'et', 'Est',
        'cl', 'Cal',
        're', 'Cal');

var
    i: integer;
    lSimilarity, lActSimilarity: extended;

begin
    lSimilarity := 0.0;
    Result := '';
    if AValue = '' then
        exit;
    for i := 0 to high(SR_Array_DModif) div 2 do
        if lowercase(SR_Array_DModif[i * 2 + 1]) = LowerCase(AValue) then
            exit(SR_Array_DModif[i * 2 + 1])
        else
          begin
            lActSimilarity := CalcSimilarity(lowercase(SR_Array_DModif[i * 2 + 1]),
                LowerCase(copy(AValue, 1, length(SR_Array_DModif[i * 2 + 1]))));
            if lActSimilarity > lSimilarity then
              begin
                Result := SR_Array_DModif[i * 2 + 1];
                lSimilarity := lActSimilarity;
              end;
          end;
    for i := 0 to high(SR_Array_DModif) div 2 do
        if lowercase(SR_Array_DModif[i * 2]) = LowerCase(
            copy(AValue, 1, length(SR_Array_DModif[i * 2]))) then
            exit(SR_Array_DModif[i * 2 + 1])
        else
          begin
            lActSimilarity := CalcSimilarity(lowercase(SR_Array_DModif[i * 2]),
                LowerCase(copy(AValue, 1, length(SR_Array_DModif[i * 2]))));
            if lActSimilarity > lSimilarity then
              begin
                Result := SR_Array_DModif[i * 2 + 1];
                lSimilarity := lActSimilarity;
              end;
          end;

end;

function TdmGenData.NormalizeYN(AValue: string): string;

const
    SR_Array: array[0..19] of string =
        ('j', 'Y',
        'n', 'N',
        'Yes', 'y',
        'No', 'N',
        'Oui', 'Y',
        'ja', 'Y',
        'nein', 'N',
        'si', 'Y',
        '?', '',
        'u', '');
var
    i: integer;
    lSimilarity, lActSimilarity: extended;

begin
    lSimilarity := 0.0;
    Result := '';
    if AValue = '' then
        exit;
    for i := 0 to high(SR_Array) div 2 do
        if lowercase(SR_array[i * 2 + 1]) = LowerCase(AValue) then
            exit(SR_array[i * 2 + 1])
        else
          begin
            lActSimilarity := CalcSimilarity(lowercase(SR_array[i * 2 + 1]), LowerCase(
                copy(AValue, 1, length(SR_array[i * 2 + 1]))));
            if lActSimilarity > lSimilarity then
              begin
                Result := SR_array[i * 2 + 1];
                lSimilarity := lActSimilarity;
              end;
          end;
    for i := 0 to high(SR_Array) div 2 do
        if lowercase(SR_array[i * 2]) = LowerCase(copy(AValue, 1, length(SR_array[i * 2]))) then
            exit(SR_array[i * 2 + 1])
        else
          begin
            lActSimilarity := CalcSimilarity(lowercase(SR_array[i * 2]), LowerCase(
                copy(AValue, 1, length(SR_array[i * 2]))));
            if lActSimilarity > lSimilarity then
              begin
                Result := SR_array[i * 2 + 1];
                lSimilarity := lActSimilarity;
              end;
          end;

end;

function TdmGenData.NormalizeSex(AValue: string): string;

const
    SR_Array: array[0..11] of string =
        ('m', 'M',
        'w', 'F',
        '?', 'U',
        'f', 'F',
        'u', 'U',
        '', 'U');
var
    i: integer;
    lSimilarity, lActSimilarity: extended;

begin
    lSimilarity := 0.0;
    Result := '';
    if AValue = '' then
        exit;
    for i := 0 to high(SR_Array) div 2 do
        if lowercase(SR_array[i * 2 + 1]) = LowerCase(AValue) then
            exit(SR_array[i * 2 + 1])
        else
          begin
            lActSimilarity := CalcSimilarity(lowercase(SR_array[i * 2 + 1]), LowerCase(
                copy(AValue, 1, length(SR_array[i * 2 + 1]))));
            if lActSimilarity > lSimilarity then
              begin
                Result := SR_array[i * 2 + 1];
                lSimilarity := lActSimilarity;
              end;
          end;
    for i := 0 to high(SR_Array) div 2 do
        if lowercase(SR_array[i * 2]) = LowerCase(copy(AValue, 1, length(SR_array[i * 2]))) then
            exit(SR_array[i * 2 + 1])
        else
          begin
            lActSimilarity := CalcSimilarity(lowercase(SR_array[i * 2]), LowerCase(
                copy(AValue, 1, length(SR_array[i * 2]))));
            if lActSimilarity > lSimilarity then
              begin
                Result := SR_array[i * 2 + 1];
                lSimilarity := lActSimilarity;
              end;
          end;

end;

end.
