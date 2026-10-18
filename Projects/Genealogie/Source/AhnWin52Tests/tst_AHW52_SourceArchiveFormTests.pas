unit tst_AHW52_SourceArchiveFormTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52SourceArchiveForm = class(TTestCase)
  published
    procedure TestFormShowRejectsUnsupportedFindKeyWithoutOpeningTable;
  end;

implementation

uses
  Cmp_SQLTable, DBTablesCompatErrors, Forms, StdCtrls, Unit2, Unit30;

procedure TTestAHW52SourceArchiveForm.
  TestFormShowRejectsUnsupportedFindKeyWithoutOpeningTable;
var
  sourceForm: TForm30;
  previousSourceForm: TForm30;
  syntheticDataModule: TDataModule2;
  previousDataModule: TDataModule2;
  table: TSQLTable;
  label2: TLabel;
begin
  previousSourceForm := Form30;
  previousDataModule := DataModule2;
  sourceForm := nil;
  syntheticDataModule := nil;
  try
    sourceForm := TForm30.CreateNew(nil);
    syntheticDataModule := TDataModule2.CreateNew(nil);
    table := TSQLTable.Create(syntheticDataModule);
    syntheticDataModule.Table11 := table;

    label2 := TLabel.Create(sourceForm);
    label2.Parent := sourceForm;
    label2.Caption := 'synthetic-source-key';
    sourceForm.Label2 := label2;

    Form30 := sourceForm;
    DataModule2 := syntheticDataModule;

    try
      sourceForm.FormShow(nil);
      Fail('FormShow must reject the unsupported BDE key lookup.');
    except
      on E: EDBTablesCompatibilityUnsupported do
        AssertEquals('TTable.FindKey', E.Operation);
    end;

    AssertFalse('The synthetic table must remain unopened.', table.Active);
  finally
    Form30 := previousSourceForm;
    DataModule2 := previousDataModule;
    syntheticDataModule.Free;
    sourceForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52SourceArchiveForm);

end.
