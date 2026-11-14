unit tst_DBParadoxSQLParserTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestDBParadoxSQLParser = class(TTestCase)
  private
    procedure AssertRejected(const SQL: string);
  published
    procedure ParsesTSQLTableQueryWithParadoxExtension;
    procedure ParsesParameterizedProjectionPredicatesAndOrdering;
    procedure ParsesEverySupportedComparisonOperator;
    procedure ParsesKeywordsCaseInsensitivelyAndAllowsNoTerminator;
    procedure RejectsInlineLiteral;
    procedure RejectsOrPredicate;
    procedure RejectsJoin;
    procedure RejectsTablePath;
    procedure RejectsMultipleStatements;
    procedure RejectsUnboundComparisonValue;
  end;

implementation

uses
  DBParadoxSQLParser, SysUtils;

procedure TTestDBParadoxSQLParser.AssertRejected(const SQL: string);
begin
  try
    ParseDBParadoxSelect(SQL);
  except
    on E: EDBParadoxSQLSyntaxError do
      Exit;
  end;
  Fail('Expected strict DBParadox SELECT parser rejection: ' + SQL);
end;

procedure TTestDBParadoxSQLParser.
  ParsesTSQLTableQueryWithParadoxExtension;
var
  Plan: TDBParadoxSelectPlan;
begin
  Plan := ParseDBParadoxSelect('select * from MRG.DB;');
  CheckTrue(Plan.SelectAll);
  CheckEquals('MRG.DB', Plan.TableName);
  CheckEquals(0, Length(Plan.Fields));
  CheckEquals(0, Length(Plan.Predicates));
  CheckEquals(0, Length(Plan.OrderBy));
end;

procedure TTestDBParadoxSQLParser.
  ParsesParameterizedProjectionPredicatesAndOrdering;
var
  Plan: TDBParadoxSelectPlan;
begin
  Plan := ParseDBParadoxSelect(
    'SELECT Nummer, Vater FROM AWD.DB ' +
    'WHERE Geschlecht = :sex AND Vater >= :parent ' +
    'ORDER BY Gebjahr DESC, Nummer ASC;');

  CheckFalse(Plan.SelectAll);
  CheckEquals('AWD.DB', Plan.TableName);
  CheckEquals(2, Length(Plan.Fields));
  CheckEquals('Nummer', Plan.Fields[0]);
  CheckEquals('Vater', Plan.Fields[1]);
  CheckEquals(2, Length(Plan.Predicates));
  CheckEquals('Geschlecht', Plan.Predicates[0].FieldName);
  CheckEquals(Ord(dpcEqual), Ord(Plan.Predicates[0].Comparison));
  CheckEquals('sex', Plan.Predicates[0].ParameterName);
  CheckEquals('Vater', Plan.Predicates[1].FieldName);
  CheckEquals(Ord(dpcGreaterOrEqual),
    Ord(Plan.Predicates[1].Comparison));
  CheckEquals('parent', Plan.Predicates[1].ParameterName);
  CheckEquals(2, Length(Plan.OrderBy));
  CheckEquals('Gebjahr', Plan.OrderBy[0].FieldName);
  CheckTrue(Plan.OrderBy[0].Descending);
  CheckEquals('Nummer', Plan.OrderBy[1].FieldName);
  CheckFalse(Plan.OrderBy[1].Descending);
end;

procedure TTestDBParadoxSQLParser.
  ParsesEverySupportedComparisonOperator;
const
  SQLOperators: array[0..5] of string = ('=', '<>', '<', '<=', '>', '>=');
  Expected: array[0..5] of TDBParadoxComparison = (
    dpcEqual, dpcNotEqual, dpcLess, dpcLessOrEqual,
    dpcGreater, dpcGreaterOrEqual);
var
  Index: Integer;
  Plan: TDBParadoxSelectPlan;
begin
  for Index := Low(SQLOperators) to High(SQLOperators) do
  begin
    Plan := ParseDBParadoxSelect(
      'select Nummer from AWD.DB where Nummer ' +
      SQLOperators[Index] + ' :value');
    CheckEquals(1, Length(Plan.Predicates));
    CheckEquals(Ord(Expected[Index]),
      Ord(Plan.Predicates[0].Comparison));
  end;
end;

procedure TTestDBParadoxSQLParser.
  ParsesKeywordsCaseInsensitivelyAndAllowsNoTerminator;
var
  Plan: TDBParadoxSelectPlan;
begin
  Plan := ParseDBParadoxSelect(' select * FROM AWD.db ');
  CheckTrue(Plan.SelectAll);
  CheckEquals('AWD.db', Plan.TableName);
end;

procedure TTestDBParadoxSQLParser.RejectsInlineLiteral;
begin
  AssertRejected('select Nummer from AWD.DB where Nummer = 123');
  AssertRejected('select Nummer from AWD.DB where Name = ''Ada''');
end;

procedure TTestDBParadoxSQLParser.RejectsOrPredicate;
begin
  AssertRejected(
    'select Nummer from AWD.DB where Nummer = :number OR Vater = :father');
end;

procedure TTestDBParadoxSQLParser.RejectsJoin;
begin
  AssertRejected(
    'select a.Nummer from AWD.DB a JOIN MRG.DB b ON a.Nummer = b.Nummer');
end;

procedure TTestDBParadoxSQLParser.RejectsTablePath;
begin
  AssertRejected('select * from ..\outside.db');
  AssertRejected('select * from C:\data\AWD.DB');
end;

procedure TTestDBParadoxSQLParser.RejectsMultipleStatements;
begin
  AssertRejected('select * from AWD.DB; delete from AWD.DB');
  AssertRejected('select * from AWD.DB;;');
end;

procedure TTestDBParadoxSQLParser.RejectsUnboundComparisonValue;
begin
  AssertRejected('select Nummer from AWD.DB where Nummer =');
  AssertRejected('select Nummer from AWD.DB where Nummer = ?');
  AssertRejected('select Nummer from AWD.DB where Nummer = :');
end;

initialization
  RegisterTest(TTestDBParadoxSQLParser);

end.
