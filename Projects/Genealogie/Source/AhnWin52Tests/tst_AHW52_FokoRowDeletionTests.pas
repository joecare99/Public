unit tst_AHW52_FokoRowDeletionTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52FokoRowDeletion = class(TTestCase)
  published
    procedure TestConfirmedAndCancelledDeletion;
  end;

implementation

uses
  SysUtils, DB, BufDataset, FokoRowDeletionService;

procedure AssertEqual(const Description: string; Expected, Actual: Longint);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected %d, got %d.',
      [Description, Expected, Actual]);
end;

procedure AssertBoolean(const Description: string; Expected, Actual: Boolean);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected %s, got %s.',
      [Description, BoolToStr(Expected, True), BoolToStr(Actual, True)]);
end;

procedure AssertText(const Description, Expected, Actual: string);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected "%s", got "%s".',
      [Description, Expected, Actual]);
end;

procedure AppendSyntheticRow(const DataSet: TBufDataset; const Name: string);
begin
  DataSet.Append;
  DataSet.FieldByName('NAME').AsString := Name;
  DataSet.Post;
end;

var
  dataSet: TBufDataset;
  rejected: Boolean;

procedure TTestAHW52FokoRowDeletion.TestConfirmedAndCancelledDeletion;
begin
  dataSet := TBufDataset.Create(nil);
    try
      dataSet.FieldDefs.Add('NAME', ftString, 32);
      dataSet.CreateDataset;
      AppendSyntheticRow(dataSet, 'synthetic first');
      AppendSyntheticRow(dataSet, 'synthetic second');
      dataSet.First;

      AssertBoolean('Confirmed delete result', True,
        DeleteCurrentRowIfConfirmed(dataSet, True));
      AssertEqual('Record count after confirmed delete', 1, dataSet.RecordCount);
      AssertText('Current synthetic row after delete', 'synthetic second',
        dataSet.FieldByName('NAME').AsString);

      dataSet.First;
      AssertBoolean('Cancelled delete result', False,
        DeleteCurrentRowIfConfirmed(dataSet, False));
      AssertEqual('Record count after cancelled delete', 1, dataSet.RecordCount);
      if dataSet.FieldByName('NAME').AsString <> 'synthetic second' then
        raise Exception.Create('Cancellation changed the remaining synthetic row.');

      rejected := False;
      try
        DeleteCurrentRowIfConfirmed(nil, True);
      except
        on EArgumentNilException do
          rejected := True;
      end;
      AssertBoolean('Nil dataset rejection', True, rejected);
    finally
      dataSet.Free;
    end;
end;

initialization
  RegisterTest(TTestAHW52FokoRowDeletion);

end.
