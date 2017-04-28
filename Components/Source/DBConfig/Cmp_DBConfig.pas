UNIT Cmp_DBConfig;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{*V 2.00.03}
{*H 2.00.02 Setvalue-Procedure Nach public verschoben }
{*H 2.00.01 }
INTERFACE

USES
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils,
  Classes,
  {$ifdef COMPILER15_UP}
  vcl.Controls,
  vcl.Forms,
  vcl.Dialogs,
  {$else ~COMPILER15_UP}
  Controls,
  Forms,
  Dialogs,
  {$Endif ~COMPILER15_UP}

  Unt_Config,
  DB;

TYPE
  TDBConfig = CLASS(TCustomConfig)
  Private
    { Private-Deklarationen }
    FDataSource: TDataSource;
    FOnException: TExceptionEvent;
    FObjectField, // Dieses Feld muﬂ 200 zeichen lang sein.
      FActiveField, // Dies ist ein Bit-Feld
      FEintragField, // Dieses Feld muﬂ 25 zeichen lang sein (tName)
      FBezField, // Bezeichnungsfeld
      FValueField: STRING;
    Finfo: TStrings;
    FUNCTION CheckDataSource(DS: TDatasource): Boolean; // Dieses Feld muﬂ 50 Zeichen lang sein (tValue)
    PROCEDURE AppendEntry(Section, Eintrag, wert: STRING; active: boolean;
      Bez: STRING);
    PROCEDURE SetDatasource(NewDS: Tdatasource);

  Protected
    { Protected-Deklarationen }
    FUNCTION getvalue(index: TObject; Eintrag: STRING): variant; Overload; Override;
//    FUNCTION GetFilename: STRING;

  Public
    { Public-Deklarationen }
    CONSTRUCTOR Create(AOwner: TComponent); Override;
    PROCEDURE setvalue(index: TObject; Eintrag: STRING; newval: variant); Override;
    DESTRUCTOR Destroy; Override;
    PROPERTY Value[index: TObject; name: STRING]: variant Read getvalue Write setvalue;
    FUNCTION getvalue(Section: STRING; Eintrag: STRING; defaul: variant): variant; Overload; Override;

  Published
    { Published-Deklarationen }
    FUNCTION EnableRollBack: word; Override;
    FUNCTION getvalue(index: TObject; Eintrag: STRING; defaul: variant): variant; Overload; Override;
    PROCEDURE RBCommit(RBLevel: Word); Override;
    PROCEDURE RBUndo(RBLevel: Word); Override;
//    PROPERTY FileName: STRING Read getfilename;
    PROPERTY Datasource: Tdatasource Read FDatasource Write Setdatasource;
    PROPERTY objectField: STRING Read FObjectField Write FObjectField;
    PROPERTY EintragField: STRING Read FEintragField Write FEintragField;
    PROPERTY ActiveField: STRING Read FActiveField Write FActiveField;
    PROPERTY ValueField: STRING Read FValueField Write FValueField;
    property OnException:TExceptionEvent read Fonexception write Fonexception;
    PROPERTY Info: TStrings Read FInfo;
  END;

PROCEDURE Register;

IMPLEMENTATION

USES variants, Unt_Allgfunklib;

PROCEDURE Register;
BEGIN
  RegisterComponents('Projekt', [TDBConfig]);
END;

//---------------------------------------------------------------

FUNCTION deci(value: integer; Sze: integer = 0): STRING;
// aus Inttostr
// Wandelt eine Zahl in Decimal-String um

CONST hexcode = '0123456789ABCDEF';

VAR i: integer;
  v: longint;
  h: STRING;

BEGIN
  i := 1;
  v := value;
  h := '';
  WHILE (i <= Sze) OR (v <> 0) DO
    BEGIN
      h := hexcode[v MOD 10] + h;
      v := v DIV 10;
      inc(i);
    END;
  deci := h
END;
//-------------------------------------------------------------

CONSTRUCTOR TDBConfig.Create;

BEGIN
  INHERITED;
  Finfo := TStringList.Create;
END;
//-------------------------------------------------------------

DESTRUCTOR TDBConfig.Destroy;

BEGIN
  IF assigned(Finfo) THEN
    TRY
      Finfo.Free;
    EXCEPT
    END;
  INHERITED;
END;
//-------------------------------------------------------------

FUNCTION TDBConfig.getvalue(index: TObject; Eintrag: STRING): variant;

VAR section: STRING;

BEGIN
  //
  section := getsection(index);
  result := '';
  IF CheckDataSource(FDataSource) THEN
    WITH FDataSource.DataSet DO
      try
        IF locate(FObjectField + ';' + FEintragField + ';' + FActiveField, VarArrayOf([section, Eintrag, 1]), [loCaseInsensitive]) THEN
          BEGIN
            IF NOT FieldByName(FValueField).IsNull THEN
              result := fieldvalues[FValueField];
          END;
      except
        try
          refresh;
          IF locate(FObjectField + ';' + FEintragField + ';' + FActiveField, VarArrayOf([section, Eintrag, 1]), [loCaseInsensitive]) THEN
            IF NOT FieldByName(FValueField).IsNull THEN
              result := fieldvalues[FValueField];
        except
          close;
        end
      END;
END;

FUNCTION TDBConfig.getvalue(Section: STRING; Eintrag: STRING; defaul: variant): variant;

BEGIN
  result := '';
  IF CheckDataSource(FDataSource) THEN
    WITH FDataSource.DataSet DO
      BEGIN
        IF locate(FObjectField + ';' + FEintragField + ';' + FActiveField, VarArrayOf([section, Eintrag, true]), [loCaseInsensitive]) THEN
          BEGIN
            IF NOT FieldByName(FValueField).IsNull THEN
              result := fieldvalues[FValueField];
          END
        ELSE
          BEGIN
            result := VarToStr(defaul);
            AppendEntry(section, Eintrag, result, true, ExtractFileName(section) + '.' + eintrag)
          END;
      END;
END;


FUNCTION TDBConfig.getvalue(index: TObject; Eintrag: STRING; defaul: variant): variant;

VAR section: STRING;

BEGIN
  //
  section := getsection(index);
  result := getvalue(section, Eintrag, defaul);
END;

PROCEDURE TDBConfig.setvalue(index: TObject; Eintrag: STRING; newval: variant);

VAR section: STRING;

BEGIN
  //
  section := getsection(index);
  IF CheckDataSource(FDataSource) THEN
    WITH FDataSource.DataSet DO
      BEGIN
        IF locate(FObjectField + ';' + FEintragField + ';' + FActiveField, VarArrayOf([section, Eintrag, bool2byte[true]]), [loCaseInsensitive]) THEN
          TRY
            edit;
            fieldvalues[FValueField] := vartostr(newval);
            post;
          EXCEPT
            ON e: Exception DO
              BEGIN
                IF assigned(Fonexception) THEN
                  FOnException(self, e)
                ELSE
                  RAISE;
                exit;
              END;
          END
        ELSE
          BEGIN
            AppendEntry(section, Eintrag, vartostr(Newval), true, ExtractFileName(section) + '.' + eintrag)
          END;
      END;
END;

PROCEDURE TDBConfig.AppendEntry(Section, Eintrag, wert: STRING; active: boolean;
  Bez: STRING);
BEGIN
  WITH FDataSource.DataSet DO
    TRY
      append;
      fieldvalues[FObjectField] := section;
      fieldvalues[FEintragField] := Eintrag;
      fieldvalues[FActiveField] := true;
      fieldvalues[FValueField] := wert;
      IF FBezField <> '' THEN
        fieldvalues[FBezField] := Bez;
      Post;
    EXCEPT
      ON e: Exception DO
        BEGIN
          IF assigned(Fonexception) THEN
            FOnException(self, e)
          ELSE
            RAISE;
          exit;
        END;
    END;
END;

FUNCTION TDBConfig.CheckDataSource(DS: TDatasource): Boolean;

VAR i: integer;
BEGIN
  Result := False;
  IF assigned(FDataSource) THEN
    IF Assigned(FDataSource.DataSet) THEN
      WITH FDataSource.DataSet DO
        BEGIN
          IF NOT Active THEN
            TRY
              open;
            EXCEPT
              ON e: Exception DO
                BEGIN
                  IF assigned(Fonexception) THEN
                    FOnException(self, e)
                  ELSE
                    RAISE;
                  exit;
                END;
            END;
          result := true;
          IF FBezField = '' THEN
            FOR I := 0 TO fields.Count - 1 DO
              BEGIN
                IF fields[i].inheritsfrom(TStringField) THEN
                  WITH TStringField(fields[i]) DO
                    BEGIN
                      IF (Size IN [20..30]) AND
                        (UpperCase(copy(fieldname, 1, 3)) = 'BEZ') AND
                        (FEintragField <> fieldname) THEN
                        FBezField := fieldname;
                    END;
              END;
        END;
END;

FUNCTION TDBConfig.EnableRollBack: word;

BEGIN
  result := 0;
// Todo   -oJoe Care:Rollback: Enable Rollback
END;

PROCEDURE TDBConfig.RBCommit(RBLevel: Word);

BEGIN
  // ToDo -oJoe Care -cLow: Rollback: Commit Entwickeln
END;

PROCEDURE TDBConfig.RBUndo(RBLevel: Word);

BEGIN
// Todo   -oJoe Care:Rollback: Undo
END;
//--------------------------------------------------

PROCEDURE TDBConfig.SetDataSource;

VAR i: integer;
BEGIN
  Finfo.Clear;
  IF assigned(NewDS) THEN
    IF (csDesigning IN ComponentState) THEN
      BEGIN
        Finfo.Add('Component in Designing Mode');
        IF assigned(NewDS.DataSet) THEN
          WITH NewDS.DataSet DO
            IF active THEN
              BEGIN
                Finfo.Add('Dataset is active');
                FOR I := 0 TO fields.Count - 1 DO
                  BEGIN
                    Finfo.Add('Field:' + Fields[i].fieldname + ' (' + Fields[i].Classname + ')');
                    IF fields[i].inheritsfrom(TBooleanfield) THEN
                      fActiveField := Fields[i].fieldname;
                    IF fields[i].inheritsfrom(TStringField) THEN
                      WITH TStringField(fields[i]) DO
                        BEGIN
                          IF Size IN [20..30] THEN
                            BEGIN
                              IF UpperCase(copy(fieldname, 1, 3)) = 'BEZ' THEN
                                FBezField := fieldname;
                              FEintragField := fieldname;
                            END;
                          IF Size IN [40..60] THEN
                            FValueField := fieldname;
                          IF Size IN [180..220] THEN
                            FObjectField := fieldname;
                        END;
                  END;
              END
            ELSE
              Finfo.Add('Dataset is NOT active !')
          ELSE
            Finfo.Add('Dataset is NOT assigned !');
      END;
  Fdatasource := NewDS;
END;

{----------------------------------------------------------}

INITIALIZATION
// Unit-Initialisierungscode...

FINALIZATION
// Unit-Finalisierungscode...

END.

