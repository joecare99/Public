{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit DBParadox;

{$warn 5023 off : no warning about unused units}
interface

uses
  DBParadoxConnection, DBParadoxSQLParser, DBParadoxWriteBuffer, 
  DBParadoxRecordEncoder, DBParadoxIndexFileBuilder, 
  DBParadoxTableFileBuilder, DBParadoxSecondaryIndexBuilder, 
  DBParadoxFileReader, DBParadoxStagedTable, DBParadoxDMLExecutor, 
  DBParadoxPrimaryKeyDiscovery, DBParadoxFamilyJournal, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('DBParadox', @Register);
end.
