unit tst_DBParadoxSQLParser;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestDBParadoxSQLParser = class(TTestCase)
  private
    procedure AssertRejected(const SQL: string);
  published
    procedure ParsesProjectionPredicatesAndOrdering;
    procedure ParsesAllComparisonOperators;
    procedure AcceptsCaseInsensitiveKeywordsAndOptionalExtension;
    procedure RejectsLiteralsOrJoinsAndPositionalParameters;
    procedure RejectsPathsAndMultipleStatements;
  end;

implementation

uses
  SysUtils, DBParadoxSQLParser;

procedure TTestDBParadoxSQLParser.AssertRejected(const SQL: string);
begin
  try
    ParseDBParadoxSelect(SQL);
  except
    on E: EDBParadoxSQLSyntaxError do
      Exit;
  end;
  Fail('Expected unsupported SELECT syntax to be rejected: ' + SQL);
end;

procedure TTestDBParadoxSQLParser.ParsesProjectionPredicatesAndOrdering;
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
  CheckEquals('sex', Plan.Predicates[0].ParameterName);
  CheckEquals(Ord(dpcEqual), Ord(Plan.Predicates[0].Comparison));
  CheckEquals('Vater', Plan.Predicates[1].FieldName);
  CheckEquals('parent', Plan.Predicates[1].ParameterName);
  CheckEquals(Ord(dpcGreaterOrEqual),
    Ord(Plan.Predicates[1].Comparison));
  CheckEquals(2, Length(Plan.OrderBy));
  CheckEquals('Gebjahr', Plan.OrderBy[0].FieldName);
  CheckTrue(Plan.OrderBy[0].Descending);
  CheckEquals('Nummer', Plan.OrderBy[1].FieldName);
  CheckFalse(Plan.OrderBy[1].Descending);
end;

procedure TTestDBParadoxSQLParser.ParsesAllComparisonOperators;
const
  Operators: array[0..5] of string = ('=', '<>', '<', '<=', '>', '>=');
  Comparisons: array[0..5] of TDBParadoxComparison = (
    dpcEqual, dpcNotEqual, dpcLess, dpcLessOrEqual,
    dpcGreater, dpcGreaterOrEqual);
var
  Index: Integer;
  Plan: TDBParadoxSelectPlan;
begin
  for Index := Low(Operators) to High(Operators) do
  begin
    Plan := ParseDBParadoxSelect(
      'SELECT ID FROM Table13.DB WHERE ID ' +
      Operators[Index] + ' :value');
    CheckEquals(1, Length(Plan.Predicates));
    CheckEquals(Ord(Comparisons[Index]),
      Ord(Plan.Predicates[0].Comparison));
  end;
end;

procedure TTestDBParadoxSQLParser.
  AcceptsCaseInsensitiveKeywordsAndOptionalExtension;
var
  Plan: TDBParadoxSelectPlan;
begin
  Plan := ParseDBParadoxSelect(' select * FROM AWD ');
  CheckTrue(Plan.SelectAll);
  CheckEquals('AWD', Plan.TableName);
  CheckEquals(0, Length(Plan.Fields));
  CheckEquals(0, Length(Plan.Predicates));
  CheckEquals(0, Length(Plan.OrderBy));

  Plan := ParseDBParadoxSelect('select * from AWD.DB;');
  CheckEquals('AWD.DB', Plan.TableName);
end;

procedure TTestDBParadoxSQLParser.
  RejectsLiteralsOrJoinsAndPositionalParameters;
begin
  AssertRejected('SELECT ID FROM Table13.DB WHERE ID = 4');
  AssertRejected('SELECT ID FROM Table13.DB WHERE Ort = ''Berlin''');
  AssertRejected(
    'SELECT a.ID FROM Table13.DB a JOIN Table14.DB b ON a.ID = b.ID');
  AssertRejected('SELECT ID FROM Table13.DB WHERE ID = ?');
  AssertRejected('SELECT ID FROM Table13.DB WHERE ID = :');
  AssertRejected(
    'SELECT ID FROM Table13.DB WHERE ID = :id OR ID = :other');
end;

procedure TTestDBParadoxSQLParser.RejectsPathsAndMultipleStatements;
begin
  AssertRejected('SELECT * FROM ..\outside.DB');
  AssertRejected('SELECT * FROM C:\Paradox\AWD.DB');
  AssertRejected('SELECT * FROM Table13.DB; DELETE FROM Table13.DB');
  AssertRejected('SELECT * FROM Table13.DB;;');
end;

initialization
  RegisterTest(TTestDBParadoxSQLParser);

end.
