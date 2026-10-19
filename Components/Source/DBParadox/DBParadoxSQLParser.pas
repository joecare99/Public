unit DBParadoxSQLParser;

{$mode objfpc}{$H+}

interface

uses
  DB;

type
  EDBParadoxSQLSyntaxError = class(EDatabaseError);

  TDBParadoxComparison = (
    dpcEqual,
    dpcNotEqual,
    dpcLess,
    dpcLessOrEqual,
    dpcGreater,
    dpcGreaterOrEqual
  );

  TDBParadoxStringArray = array of string;

  TDBParadoxPredicate = record
    FieldName: string;
    Comparison: TDBParadoxComparison;
    ParameterName: string;
  end;

  TDBParadoxPredicateArray = array of TDBParadoxPredicate;

  TDBParadoxOrderTerm = record
    FieldName: string;
    Descending: Boolean;
  end;

  TDBParadoxOrderArray = array of TDBParadoxOrderTerm;

  TDBParadoxSelectPlan = record
    TableName: string;
    SelectAll: Boolean;
    Fields: TDBParadoxStringArray;
    Predicates: TDBParadoxPredicateArray;
    OrderBy: TDBParadoxOrderArray;
  end;

function ParseDBParadoxSelect(const SQL: string): TDBParadoxSelectPlan;

implementation

uses
  SysUtils;

type
  TTokenKind = (
    tkIdentifier,
    tkParameter,
    tkEqual,
    tkNotEqual,
    tkLess,
    tkLessOrEqual,
    tkGreater,
    tkGreaterOrEqual,
    tkStar,
    tkComma,
    tkDot,
    tkSemicolon,
    tkEnd
  );

  TToken = record
    Kind: TTokenKind;
    Text: string;
    Position: SizeInt;
  end;

  TTokenArray = array of TToken;

  TSelectParser = class
  private
    FSQL: string;
    FTokens: TTokenArray;
    FTokenIndex: SizeInt;
    function CurrentToken: TToken;
    function IsKeyword(const AKeyword: string): Boolean;
    procedure ConsumeKeyword(const AKeyword: string);
    procedure Consume(AKind: TTokenKind; const Expected: string);
    procedure RaiseSyntaxError(const Detail: string);
    function ReadIdentifier(const Context: string): string;
    procedure ParseProjection(var Plan: TDBParadoxSelectPlan);
    procedure ParseTableName(var Plan: TDBParadoxSelectPlan);
    procedure ParsePredicates(var Plan: TDBParadoxSelectPlan);
    procedure ParseOrderBy(var Plan: TDBParadoxSelectPlan);
    procedure ParseOptionalTerminator;
    procedure Tokenize;
  public
    constructor Create(const ASQL: string);
    function Parse: TDBParadoxSelectPlan;
  end;

procedure AddToken(var Tokens: TTokenArray; const Kind: TTokenKind;
  const Text: string; const Position: SizeInt);
var
  Token: TToken;
  TokenCount: SizeInt;
begin
  Token.Kind := Kind;
  Token.Text := Text;
  Token.Position := Position;
  TokenCount := Length(Tokens);
  SetLength(Tokens, TokenCount + 1);
  Tokens[TokenCount] := Token;
end;

function IsIdentifierStart(const Ch: Char): Boolean; inline;
begin
  Result := (Ch in ['A'..'Z', 'a'..'z', '_']);
end;

function IsIdentifierPart(const Ch: Char): Boolean; inline;
begin
  Result := IsIdentifierStart(Ch) or (Ch in ['0'..'9']);
end;

constructor TSelectParser.Create(const ASQL: string);
begin
  inherited Create;
  FSQL := ASQL;
  Tokenize;
end;

function TSelectParser.CurrentToken: TToken;
begin
  Result := FTokens[FTokenIndex];
end;

function TSelectParser.IsKeyword(const AKeyword: string): Boolean;
begin
  Result := (CurrentToken.Kind = tkIdentifier) and
    SameText(CurrentToken.Text, AKeyword);
end;

procedure TSelectParser.ConsumeKeyword(const AKeyword: string);
begin
  if not IsKeyword(AKeyword) then
    RaiseSyntaxError(Format('Expected keyword %s.', [AKeyword]));
  Inc(FTokenIndex);
end;

procedure TSelectParser.Consume(AKind: TTokenKind; const Expected: string);
begin
  if CurrentToken.Kind <> AKind then
    RaiseSyntaxError(Format('Expected %s.', [Expected]));
  Inc(FTokenIndex);
end;

procedure TSelectParser.RaiseSyntaxError(const Detail: string);
begin
  raise EDBParadoxSQLSyntaxError.CreateFmt(
    'Unsupported or invalid DBParadox SELECT at character %d: %s',
    [CurrentToken.Position, Detail]);
end;

function TSelectParser.ReadIdentifier(const Context: string): string;
begin
  if CurrentToken.Kind <> tkIdentifier then
    RaiseSyntaxError(Format('Expected %s identifier.', [Context]));
  Result := CurrentToken.Text;
  Inc(FTokenIndex);
end;

procedure TSelectParser.ParseProjection(var Plan: TDBParadoxSelectPlan);
var
  FieldCount: SizeInt;
begin
  if CurrentToken.Kind = tkStar then
  begin
    Plan.SelectAll := True;
    Inc(FTokenIndex);
    Exit;
  end;

  Plan.SelectAll := False;
  repeat
    FieldCount := Length(Plan.Fields);
    SetLength(Plan.Fields, FieldCount + 1);
    Plan.Fields[FieldCount] := ReadIdentifier('selected field');
    if CurrentToken.Kind <> tkComma then
      Break;
    Inc(FTokenIndex);
  until False;
end;

procedure TSelectParser.ParseTableName(var Plan: TDBParadoxSelectPlan);
var
  Extension: string;
begin
  Plan.TableName := ReadIdentifier('table');
  if CurrentToken.Kind = tkDot then
  begin
    Inc(FTokenIndex);
    Extension := ReadIdentifier('table extension');
    Plan.TableName := Plan.TableName + '.' + Extension;
    if CurrentToken.Kind = tkDot then
      RaiseSyntaxError('Qualified table names and paths are not supported.');
  end;
end;

procedure TSelectParser.ParsePredicates(var Plan: TDBParadoxSelectPlan);
var
  Predicate: TDBParadoxPredicate;
  PredicateCount: SizeInt;
begin
  repeat
    Predicate.FieldName := ReadIdentifier('predicate field');
    case CurrentToken.Kind of
      tkEqual:
        Predicate.Comparison := dpcEqual;
      tkNotEqual:
        Predicate.Comparison := dpcNotEqual;
      tkLess:
        Predicate.Comparison := dpcLess;
      tkLessOrEqual:
        Predicate.Comparison := dpcLessOrEqual;
      tkGreater:
        Predicate.Comparison := dpcGreater;
      tkGreaterOrEqual:
        Predicate.Comparison := dpcGreaterOrEqual;
    else
      RaiseSyntaxError('Expected a supported comparison operator.');
    end;
    Inc(FTokenIndex);
    if CurrentToken.Kind <> tkParameter then
      RaiseSyntaxError('Comparisons must use a named parameter.');
    Predicate.ParameterName := CurrentToken.Text;
    Inc(FTokenIndex);

    PredicateCount := Length(Plan.Predicates);
    SetLength(Plan.Predicates, PredicateCount + 1);
    Plan.Predicates[PredicateCount] := Predicate;

    if not IsKeyword('AND') then
      Break;
    Inc(FTokenIndex);
  until False;
end;

procedure TSelectParser.ParseOrderBy(var Plan: TDBParadoxSelectPlan);
var
  OrderTerm: TDBParadoxOrderTerm;
  OrderCount: SizeInt;
begin
  repeat
    OrderTerm.FieldName := ReadIdentifier('ORDER BY field');
    OrderTerm.Descending := False;
    if IsKeyword('ASC') then
      Inc(FTokenIndex)
    else if IsKeyword('DESC') then
    begin
      OrderTerm.Descending := True;
      Inc(FTokenIndex);
    end;

    OrderCount := Length(Plan.OrderBy);
    SetLength(Plan.OrderBy, OrderCount + 1);
    Plan.OrderBy[OrderCount] := OrderTerm;

    if CurrentToken.Kind <> tkComma then
      Break;
    Inc(FTokenIndex);
  until False;
end;

procedure TSelectParser.ParseOptionalTerminator;
begin
  if CurrentToken.Kind = tkSemicolon then
    Inc(FTokenIndex);
  if CurrentToken.Kind <> tkEnd then
    RaiseSyntaxError('Only one SELECT statement is supported.');
end;

procedure TSelectParser.Tokenize;
var
  Index: SizeInt;
  Start: SizeInt;
  Ch: Char;
  OperatorText: string;
  OperatorKind: TTokenKind;
begin
  Index := 1;
  while Index <= Length(FSQL) do
  begin
    Ch := FSQL[Index];
    if Ch in [#9, #10, #13, ' '] then
    begin
      Inc(Index);
      Continue;
    end;

    Start := Index;
    if IsIdentifierStart(Ch) then
    begin
      Inc(Index);
      while (Index <= Length(FSQL)) and IsIdentifierPart(FSQL[Index]) do
        Inc(Index);
      AddToken(FTokens, tkIdentifier, Copy(FSQL, Start, Index - Start), Start);
      Continue;
    end;

    if Ch = ':' then
    begin
      Inc(Index);
      Start := Index;
      if (Index > Length(FSQL)) or not IsIdentifierStart(FSQL[Index]) then
        raise EDBParadoxSQLSyntaxError.CreateFmt(
          'Unsupported or invalid DBParadox SELECT at character %d: ' +
          'Expected a named parameter after ":".',
          [Index - 1]);
      Inc(Index);
      while (Index <= Length(FSQL)) and IsIdentifierPart(FSQL[Index]) do
        Inc(Index);
      AddToken(FTokens, tkParameter, Copy(FSQL, Start, Index - Start), Start);
      Continue;
    end;

    case Ch of
      '=':
        begin
          AddToken(FTokens, tkEqual, Ch, Index);
          Inc(Index);
        end;
      '<', '>':
        begin
          OperatorText := Ch;
          Inc(Index);
          if Index <= Length(FSQL) then
          begin
            if (Ch = '<') and (FSQL[Index] = '>') then
            begin
              OperatorText := '<>';
              OperatorKind := tkNotEqual;
              Inc(Index);
            end
            else if FSQL[Index] = '=' then
            begin
              OperatorText := OperatorText + '=';
              if Ch = '<' then
                OperatorKind := tkLessOrEqual
              else
                OperatorKind := tkGreaterOrEqual;
              Inc(Index);
            end
            else if Ch = '<' then
              OperatorKind := tkLess
            else
              OperatorKind := tkGreater;
          end
          else if Ch = '<' then
            OperatorKind := tkLess
          else
            OperatorKind := tkGreater;
          AddToken(FTokens, OperatorKind, OperatorText, Start);
        end;
      '*':
        begin
          AddToken(FTokens, tkStar, Ch, Index);
          Inc(Index);
        end;
      ',':
        begin
          AddToken(FTokens, tkComma, Ch, Index);
          Inc(Index);
        end;
      '.':
        begin
          AddToken(FTokens, tkDot, Ch, Index);
          Inc(Index);
        end;
      ';':
        begin
          AddToken(FTokens, tkSemicolon, Ch, Index);
          Inc(Index);
        end;
    else
      raise EDBParadoxSQLSyntaxError.CreateFmt(
        'Unsupported or invalid DBParadox SELECT at character %d: ' +
        'Unsupported character "%s".',
        [Index, Ch]);
    end;
  end;

  AddToken(FTokens, tkEnd, '', Length(FSQL) + 1);
  FTokenIndex := 0;
end;

function TSelectParser.Parse: TDBParadoxSelectPlan;
begin
  Result.TableName := '';
  Result.SelectAll := False;
  SetLength(Result.Fields, 0);
  SetLength(Result.Predicates, 0);
  SetLength(Result.OrderBy, 0);
  ConsumeKeyword('SELECT');
  ParseProjection(Result);
  ConsumeKeyword('FROM');
  ParseTableName(Result);
  if IsKeyword('WHERE') then
  begin
    Inc(FTokenIndex);
    ParsePredicates(Result);
  end;
  if IsKeyword('ORDER') then
  begin
    Inc(FTokenIndex);
    ConsumeKeyword('BY');
    ParseOrderBy(Result);
  end;
  ParseOptionalTerminator;
end;

function ParseDBParadoxSelect(const SQL: string): TDBParadoxSelectPlan;
var
  Parser: TSelectParser;
begin
  Parser := TSelectParser.Create(SQL);
  try
    Result := Parser.Parse;
  finally
    Parser.Free;
  end;
end;

end.
