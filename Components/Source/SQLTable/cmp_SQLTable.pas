unit cmp_SQLTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,db, sqldb;

type

  { TSQLTable }

  TSQLTable = class(TCustomSQLQuery)
    property SchemaType;
    Property StatementType;
  private
    FMasterFields: String;
    FMasterSource: TDataSource;
    FTableName: string;
    procedure SetMasterFields(AValue: String);
    procedure SetMasterSource(AValue: TDataSource);
    procedure SetTableName(AValue: string);
  Published
    property MaxIndexesCount;
   // TDataset stuff
    property FieldDefs;
    Property Active;
    Property AutoCalcFields;
    Property Filter;
    Property Filtered;
    Property FilterOptions;
    Property AfterCancel;
    Property AfterClose;
    Property AfterDelete;
    Property AfterEdit;
    Property AfterInsert;
    Property AfterOpen;
    Property AfterPost;
    Property AfterScroll;
    Property BeforeCancel;
    Property BeforeClose;
    Property BeforeDelete;
    Property BeforeEdit;
    Property BeforeInsert;
    Property BeforeOpen;
    Property BeforePost;
    Property BeforeScroll;
    Property OnCalcFields;
    Property OnDeleteError;
    Property OnEditError;
    Property OnFilterRecord;
    Property OnNewRecord;
    Property OnPostError;

    //    property SchemaInfo default stNoSchema;
    property MasterFields:String read FMasterFields write SetMasterFields;
    property MasterSource:TDataSource read FMasterSource write SetMasterSource;
    property Database;
    property Transaction;
    property ReadOnly;
    property TableName:string read FTableName write SetTableName;
    property IndexDefs;
    property ParseSQL;
    property UpdateMode;
    property UsePrimaryKeyAsKey;
    Property DataSource;
    property ServerFilter;
    property ServerFiltered;
    property ServerIndexDefs;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SQLDB',[TSQLTable]);
end;

{ TSQLTable }

procedure TSQLTable.SetTableName(AValue: string);
begin
  if FTableName=AValue then Exit;
  FTableName:=AValue;
  SQL.text := format('select * from %s;',[FTableName]);
end;

procedure TSQLTable.SetMasterFields(AValue: String);
begin
  if FMasterFields=AValue then Exit;
  FMasterFields:=AValue;
end;

procedure TSQLTable.SetMasterSource(AValue: TDataSource);
begin
  if FMasterSource=AValue then Exit;
  FMasterSource:=AValue;
end;

end.
