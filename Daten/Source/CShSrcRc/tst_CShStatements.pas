{
  Examples:
    ./testCShsrc --suite=TTestStatementParser.TestCallQualified2
}
unit tst_CShStatements;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, fpcunit, CShtree, CShScanner, CShParser,
    tst_CShBaseParser, testregistry;

type
    { TTestStatementParserBase }

    TTestStatementParserBase = class(TTestParser)
    private
        FMainClass :TCShClassType;
        FMainProc  :TCShFunction;
        FStatement :TCShImplBlock;
        FVariables :TStrings;
    protected
        procedure SetUp; override;
        procedure TearDown; override;
        procedure AddStatements(ASource :array of string);
        procedure DeclareVar(const AVarType :string; const AVarName :string = 'A');
        function TestStatement(ASource :string) :TCShImplElement;
        function TestStatement(ASource :array of string) :TCShImplElement;
        procedure ExpectParserError(const Msg :string);
        procedure ExpectParserError(const Msg :string; ASource :array of string);
        function AssertStatement(Msg :string;
            AClass :TClass; AIndex :integer = 0) :TCShImplBlock; overload;
        procedure AssertImplElement(Msg :string;
            AClass :TClass; aStmt :TCShImplElement); overload;
        property Statement :TCShImplBlock read FStatement;
        property MainClass :TCShClassType read FMainClass;
        property MainProc :TCShFunction read FMainProc;
    end;

    TTestParserStatementEmpty = class(TTestStatementParserBase)
        procedure TestEmpty;
        procedure TestEmptyStatement;
        procedure TestEmptyStatements;
    end;

    { TTestParserStatementBlock }

    TTestParserStatementBlock = class(TTestStatementParserBase)
        procedure TestBlock;
        procedure TestBlock2;
        procedure TestBlockComment;
        procedure TestBlock2Comments;
    end;

    { TTestParserStatementAssignment }

    TTestParserStatementAssignment = class(TTestStatementParserBase)
        procedure TestAssignment;
        procedure TestAssignmentAdd;
        procedure TestAssignmentMinus;
        procedure TestAssignmentMul;
        procedure TestAssignmentDivision;
        procedure TestAssignmentModulo;
        procedure TestAssignmentAnd;
        procedure TestAssignmentOr;
        procedure TestAssignmentXor;
        procedure TestAssignmentAsk;
        procedure TestAssignmentShr;
        procedure TestAssignmentShl;
        procedure TestAssignmentMissingSemicolonError;
    end;

    TTestParserStatementCall = class(TTestStatementParserBase)
    private
        procedure TestCallFormat(FN: string; AddSecondParam: boolean);
        procedure DoTestCallOtherFormat;
    published
        procedure TestCall;
        procedure TestCallComment;
        procedure TestCallQualified;
        procedure TestCallQualified2;
        procedure TestCallNoArgs;
        procedure TestCallOneArg;
        procedure TestCallWriteFormat1;
        procedure TestCallWriteFormat2;
        procedure TestCallWritelnFormat1;
        procedure TestCallWritelnFormat2;
        procedure TestCallStrFormat1;
        procedure TestCallStrFormat2;
        procedure TestCallOtherFormat;
    end;

    TTestParserStatementIf = class(TTestStatementParserBase)
        procedure TestIf;
        procedure TestIfBlock;
        procedure TestIfAssignment;
        procedure TestIfSKElse;
        procedure TestIfBlockElse;
        procedure TestIfElseBlock;
        procedure TestIfElseInBlock;
        procedure TestIfforElseBlock;
        procedure TestIfRaiseElseBlock;
        procedure TestIfUsingBlock;
        procedure TestWhileNestedIf;
        procedure TestNestedIfElse;
        procedure TestNestedIfElseElse;
        procedure TestNestedIf;
        procedure TestIfIfElseElseBlock;
        procedure TestWhileNestedIfBlock;
        // Errors NIO - Statements
        procedure TestIfnoSKError;
        procedure TestIfElseError;
        procedure TestIfElsenoSKError;
        procedure TestNestedIfElsenoSKError;
        procedure TestIfSemiColonElseError;
    private
    end;

    { TTestParserStatementLoops }

    TTestParserStatementLoops = class(TTestStatementParserBase)
        procedure TestWhile;
        procedure TestWhileBlock;
        procedure TestWhileNested;
        procedure TestDoWhile;
        procedure TestDoWhileBlock;
        procedure TestDoProcWhile;
        procedure TestDoNested;
        procedure TestDoWhileNested;
        procedure TestFor;
        procedure TestForExpr;
        procedure TestForBlock;
        procedure TestDowntoBlock;
        procedure TestForNested;
        procedure TestForeachIn;
    end;

    TTestParserStatementUsing = class(TTestStatementParserBase)
        procedure TestUsing;
        procedure TestWithMultiple;
    end;

    TTestParserStatementSwitch = class(TTestStatementParserBase)
        procedure TestCaseEmpty;
        procedure TestCaseOneInteger;
        procedure TestCaseTwoIntegers;
        procedure TestCaseRange;
        procedure TestCaseRangeSeparate;
        procedure TestCase2Cases;
        procedure TestCaseBlock;
        procedure TestCaseElseBlockEmpty;
        procedure TestCaseOtherwiseBlockEmpty;
        procedure TestCaseElseBlockAssignment;
        procedure TestCaseElseBlock2Assignments;
        procedure TestCaseIfCaseElse;
        procedure TestCaseIfCaseElseElse;
        procedure TestCaseIfElse;
        procedure TestCaseElseNoSemicolon;
        procedure TestCaseIfElseNoSemicolon;
        procedure TestCaseIfOtherwiseNoSemicolon;
    end;

    TTestParserStatementThrow = class(TTestStatementParserBase)
        procedure TestRaise;
        procedure TestRaiseEmpty;
        procedure TestRaiseAt;
    end;

    TTestParserStatementTry = class(TTestStatementParserBase)
        procedure TestTryFinally;
        procedure TestTryFinallyEmpty;
        procedure TestTryFinallyNested;
        procedure TestTryExcept;
        procedure TestTryExceptNested;
        procedure TestTryExceptEmpty;
        procedure TestTryExceptOn;
        procedure TestTryExceptOn2;
        procedure TestTryExceptOnElse;
        procedure TestTryExceptOnIfElse;
        procedure TestTryExceptOnElseNoSemicolo;
        procedure TestTryExceptRaise;
    end;

    TTestParserStatementSpecial = class(TTestStatementParserBase)
        procedure TestGotoInIfThen;
        procedure TestAssignToAddress;
        procedure TestFinalizationNoSemicolon;
        procedure TestMacroComment;
        procedure TestPlatformIdentifier;
        procedure TestPlatformIdentifier2;
        procedure TestArgumentNameOn;
    end;

implementation

{ TTestStatementParserBase }

procedure TTestStatementParserBase.SetUp;
begin
    inherited SetUp;
    FVariables := TStringList.Create;
end;

procedure TTestStatementParserBase.TearDown;
begin
    FreeAndNil(FVariables);
    inherited TearDown;
end;

procedure TTestStatementParserBase.AddStatements(ASource :array of string);

var
    I :integer;
begin
    StartProgram(ExtractFileUnitName(MainFilename));
    if FVariables.Count > 0 then
      begin
        for I := 0 to FVariables.Count - 1 do
            Add('  ' + Fvariables[I]);
      end;
    Add('static void Main(string[] args)');
    Add('{');
    for I := Low(ASource) to High(ASource) do
        Add('  ' + ASource[i]);
end;

procedure TTestStatementParserBase.DeclareVar(const AVarType :string;
    const AVarName :string);
begin
    FVariables.Add(AVarType + ' ' + AVarName + ';');
end;

function TTestStatementParserBase.TestStatement(ASource :string) :TCShImplElement;
begin
    Result := TestStatement([ASource]);
end;

function TTestStatementParserBase.TestStatement(ASource :array of string):
TCShImplElement;

begin
    Result     := nil;
    FStatement := nil;
    AddStatements(ASource);
    ParseModule;
    AssertEquals('Have Module', TCShModule, Module.ClassType);
    AssertNotNull('Class exists', Module.ImplementationSection.Declarations[0]);
    AssertEquals('Is Class', TCShClassType, TObject(
        Module.ImplementationSection.Declarations[0]).ClassType);
    FMainClass := TCshClassType(Module.ImplementationSection.Declarations[0]);
    AssertNotNull('Class exists', FMainClass.Members[0]);
    AssertEquals('Is Class', TCShFunction, TObject(FMainClass.Members[0]).ClassType);
    FMainProc := TCShFunction(FMainClass.Members[0]);
    Result    := FStatement;
end;

procedure TTestStatementParserBase.ExpectParserError(const Msg :string);
begin
    AssertException(Msg, EParserError, @ParseModule);
end;

procedure TTestStatementParserBase.ExpectParserError(const Msg :string;
    ASource :array of string);
begin
    AddStatements(ASource);
    ExpectParserError(Msg);
end;

function TTestStatementParserBase.AssertStatement(Msg :string;
    AClass :TClass; AIndex :integer) :TCShImplBlock;
begin
    AssertNotNull(Msg + ' Have statement', MainProc.Body);
    AssertEquals(Msg + ' statement class', AClass, TObject(
        MainProc.body.Statements.Elements[AIndex]).ClassType);
    Result := TObject(MainProc.body.Statements) as TCShImplBlock;
end;

procedure TTestStatementParserBase.AssertImplElement(Msg :string;
    AClass :TClass; aStmt :TCShImplElement);
begin
    AssertNotNull(Msg + ' Have statement', aStmt);
    AssertEquals(Msg + ' statement class', AClass, aStmt.ClassType);
end;


procedure TTestParserStatementEmpty.TestEmpty;
begin
    //TestStatement(';');
    TestStatement('');
    AssertEquals('No statements', 0, MainProc.body.Statements.Elements.Count);
end;

procedure TTestParserStatementEmpty.TestEmptyStatement;
begin
    TestStatement(';');
    AssertEquals('0 statement', 0, MainProc.body.Statements.Elements.Count);
end;

procedure TTestParserStatementEmpty.TestEmptyStatements;
begin
    TestStatement(';;');
    AssertEquals('0 statement', 0, MainProc.body.Statements.Elements.Count);
end;

procedure TTestParserStatementBlock.TestBlock;

var
    B :TCShImplBeginBlock;

begin
    TestStatement(['{', '}']);
    AssertEquals('1 statement', 1, MainProc.body.Statements.Elements.Count);
    AssertNotNull('Statement assigned', MainProc.body.Statements.Elements[0]);
    AssertEquals('Block statement', TCShImplBeginBlock, Statement.ClassType);
    B := Statement as TCShImplBeginBlock;
    AssertEquals('Empty block', 0, B.Elements.Count);
end;

procedure TTestParserStatementBlock.TestBlock2;
var
    B :TCShImplBeginBlock;

begin
    TestStatement(['{', '}', '{', '}']);
    AssertEquals('2 statements', 2, ImpBlock.Elements.Count);
    AssertNotNull('Statement assigned', ImpBlock.Elements[0]);
    FStatement := AssertStatement('Block statement', TCShImplBeginBlock);
    B := Statement as TCShImplBeginBlock;
    AssertEquals('Empty block', 0, B.Elements.Count);
    FStatement := AssertStatement('Block statement', TCShImplBeginBlock, 1);
    B := Statement as TCShImplBeginBlock;
    AssertEquals('Empty block', 0, B.Elements.Count);
end;

procedure TTestParserStatementBlock.TestBlockComment;
var
    B :TCShImplBeginBlock;

begin
    Engine.NeedComments := True;
    TestStatement(['/* This is a comment */', '{', '}']);
    AssertEquals('1 statement', 1, ImpBlock.Elements.Count);
    AssertNotNull('Statement assigned', ImpBlock.Elements[0]);
    FStatement := AssertStatement('Block statement', TCShImplBeginBlock);
    B := Statement as TCShImplBeginBlock;
    AssertEquals('Empty block', 0, B.Elements.Count);
    AssertEquals('The DocComment', ' This is a comment ', B.DocComment);
end;

procedure TTestParserStatementBlock.TestBlock2Comments;
var
    B :TCShImplBeginBlock;

begin
    Engine.NeedComments := True;
    TestStatement(['/* This is a comment */', '// Another comment', '{', '}']);
    AssertEquals('1 statement', 1, ImpBlock.Elements.Count);
    AssertNotNull('Statement assigned', ImpBlock.Elements[0]);
    FStatement := AssertStatement('Block statement', TCShImplBeginBlock);
    B := Statement as TCShImplBeginBlock;
    AssertEquals('Empty block', 0, B.Elements.Count);
    AssertEquals('No DocComment', '', B.DocComment);
end;

procedure TTestParserStatementAssignment.TestAssignment;

var
    A :TCShImplAssign;

begin
    DeclareVar('int');
    TestStatement(['a=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Normal assignment', akDefault, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentAdd;

var
    A :TCShImplAssign;

begin
    DeclareVar('int');
    TestStatement(['a+=1;']);
    AssertEquals('1 statement', 1, MainProc.body.Statements.Elements.Count);
    AssertEquals('Assignment statement', TCShImplAssign, Statement.ClassType);
    A := Statement as TCShImplAssign;
    AssertEquals('Add assignment', akAdd, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentMinus;
var
    A :TCShImplAssign;

begin
    DeclareVar('int');
    TestStatement(['a-=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Minus assignment', akMinus, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentMul;
var
    A :TCShImplAssign;

begin
    DeclareVar('int');
    TestStatement(['a*=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Mul assignment', akMul, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentDivision;
var
    A :TCShImplAssign;

begin
    DeclareVar('int');
    TestStatement(['a/=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Division assignment', akDivision, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentModulo;
var
    A :TCShImplAssign;
begin
    DeclareVar('int');
    TestStatement(['a%=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Modulo assignment', akModulo, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentAnd;
var
    A :TCShImplAssign;
begin
    DeclareVar('int');
    TestStatement(['a&=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Logical-And assignment', akAnd, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentOr;
var
    A :TCShImplAssign;
begin
    DeclareVar('int');
    TestStatement(['a|=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Logical-Or assignment', akOr, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentXor;
var
    A :TCShImplAssign;
begin
    DeclareVar('int');
    TestStatement(['a^=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Xor assignment', akXor, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentAsk;
var
    A :TCShImplAssign;
begin
    DeclareVar('int');
    TestStatement(['a??=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Ask assignment', akAsk, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentShr;
var
    A :TCShImplAssign;
begin
    DeclareVar('int');
    TestStatement(['a>>=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Shift-Right assignment', akShr, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentShl;
var
    A :TCShImplAssign;
begin
    DeclareVar('int');
    TestStatement(['a<<=1;']);
    AssertEquals('2 statement', 2, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Assignment statement', TCShImplAssign, 1);
    A := Statement as TCShImplAssign;
    AssertEquals('Shift-Left assignment', akShl, A.Kind);
    AssertExpression('Right side is constant', A.Right, pekNumber, '1');
    AssertExpression('Left side is variable', A.Left, pekIdent, 'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentMissingSemicolonError;
begin
    DeclareVar('int');
    ExpectParserError('Semicolon expected, but "a" found', ['a=1', 'a=2']);
end;

procedure TTestParserStatementCall.TestCall;

var
    S :TCShImplSimple;

begin
    TestStatement('Doit();');
    AssertEquals('1 statement', 1, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Simple statement', TCShImplSimple);
    S := Statement as TCShImplSimple;
    AssertExpression('Doit call', S.Expr, 'Doit');
end;

procedure TTestParserStatementCall.TestCallComment;

var
    S :TCShImplSimple;

begin
    Engine.NeedComments := True;
    TestStatement(['//comment line', 'Doit();']);
    AssertEquals('1 statement', 1, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Simple statement', TCShImplSimple);
    S := Statement as TCShImplSimple;
    AssertExpression('Doit call', S.Expr, 'Doit');
    AssertEquals('No DocComment', '', S.DocComment);
end;

procedure TTestParserStatementCall.TestCallQualified;

var
    S :TCShImplSimple;
    F :TParamsExpr;
    B :TBinaryExpr;

begin
    TestStatement('Unita.Doit();');
    AssertEquals('1 statement', 1, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Simple statement', TCShImplSimple);
    S := Statement as TCShImplSimple;
    F := AssertExpression('Doit call', S.Expr, 'Unita.Doit');
    B := AssertExpression('Doit Call', F.Value, eopSubIdent);
    TAssert.AssertSame('B.left.Parent=B', B, B.left.Parent);
    TAssert.AssertSame('B.right.Parent=B', B, B.right.Parent);
    AssertExpression('Unit name', B.Left, pekIdent, 'Unita');
    AssertExpression('Doit call', B.Right, pekIdent, 'Doit');
end;

procedure TTestParserStatementCall.TestCallQualified2;
var
    S :TCShImplSimple;
    F :TParamsExpr;
    B :TBinaryExpr;

begin
    TestStatement('Unita.ClassB.Doit();');
    AssertEquals('1 statement', 1, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Simple statement', TCShImplSimple);
    S := Statement as TCShImplSimple;
    F := AssertExpression('Doit call', S.Expr, 'Unita.ClassB.Doit');
    B := AssertExpression('Doit Call', F.Value, eopSubIdent);
    AssertExpression('Doit call', B.Right, pekIdent, 'Doit');
    AssertExpression('First two parts of unit name', B.left, pekBinary, TBinaryExpr);
    B := B.left as TBinaryExpr;
    AssertExpression('Unit name part 1', B.Left, pekIdent, 'Unita');
    AssertExpression('Unit name part 2', B.right, pekIdent, 'ClassB');
end;

procedure TTestParserStatementCall.TestCallNoArgs;

var
    S :TCShImplSimple;
    P :TParamsExpr;

begin
    TestStatement('Doit();');
    AssertEquals('1 statement', 1, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Simple statement', TCShImplSimple);
    S := Statement as TCShImplSimple;
    P := AssertExpression('Doit call', S.Expr, 'Doit');
    AssertExpression('Correct function call name', P.Value, pekIdent, 'Doit');
    AssertEquals('No params', 0, Length(P.Params));
end;

procedure TTestParserStatementCall.TestCallOneArg;

var
    S :TCShImplSimple;
    P :TParamsExpr;

begin
    TestStatement('Doit(1);');
    AssertEquals('1 statement', 1, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Simple statement', TCShImplSimple);
    S := Statement as TCShImplSimple;
    P := AssertExpression('Doit call', S.Expr, 'Doit');
    AssertExpression('Correct function call name', P.Value, pekIdent, 'Doit');
    AssertEquals('One param', 1, Length(P.Params));
    AssertExpression('Parameter is constant', P.Params[0], pekNumber, '1');
end;

procedure TTestParserStatementCall.TestCallFormat(FN :string; AddSecondParam :boolean);
var
    P :TParamsExpr;

var
    S      :TCShImplSimple;
    N      :string;
    ArgCnt :integer;
begin
    N      := fn + '(a';
    ArgCnt := 1;
    if AddSecondParam then
      begin
        ArgCnt := 2;
        N      := N + ',b';
      end;
    N := N + ');';
    TestStatement(N);
    AssertEquals('1 statement', 1, ImpBlock.Elements.Count);
    FStatement := AssertStatement('Simple statement', TCShImplSimple);
    AssertEquals('Simple statement', TCShImplSimple, Statement.ClassType);
    S := Statement as TCShImplSimple;
    P := AssertExpression(FN + ' call', S.Expr, FN);
    AssertExpression('Correct function call name', P.Value, pekIdent, FN);
    AssertEquals(IntToStr(ArgCnt) + ' param', ArgCnt, Length(P.Params));
end;

procedure TTestParserStatementCall.TestCallWriteFormat1;

begin
    TestCallFormat('write', False);
end;

procedure TTestParserStatementCall.TestCallWriteFormat2;

begin
    TestCallFormat('write', True);
end;

procedure TTestParserStatementCall.TestCallWritelnFormat1;
begin
    TestCallFormat('writeln', False);
end;

procedure TTestParserStatementCall.TestCallWritelnFormat2;
begin
    TestCallFormat('writeln', True);
end;

procedure TTestParserStatementCall.TestCallStrFormat1;
begin
    TestCallFormat('str', False);
end;

procedure TTestParserStatementCall.TestCallStrFormat2;
begin
    TestCallFormat('str', True);
end;

procedure TTestParserStatementCall.DoTestCallOtherFormat;

begin
    TestCallFormat('nono', False);
end;

procedure TTestParserStatementCall.TestCallOtherFormat;

begin
    AssertException('Only Write(ln) and str allow format', EParserError,
        @DoTestCallOtherFormat);
end;

procedure TTestParserStatementIf.TestIf;

var
    I :TCShImplIfElse;

begin
    DeclareVar('bool');
    TestStatement(['if (a)', ';']);
    I := AssertStatement('If statement', TCShImplIfElse, 1) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNull('No else', i.ElseBranch);
    AssertNull('No if branch', I.IfBranch);
end;

procedure TTestParserStatementIf.TestIfBlock;

var
    I :TCShImplIfElse;

begin
    DeclareVar('bool');
    TestStatement(['if(a)', '  {', '  }']);
    I := AssertStatement('If statement', TCShImplIfElse, 1) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNull('No else', i.ElseBranch);
    AssertNotNull('if branch', I.IfBranch);
    AssertEquals('begin end block', TCShImplBeginBlock, I.ifBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfAssignment;

var
    I :TCShImplIfElse;

begin
    DeclareVar('bool');
    TestStatement(['if (a)', '  a=False;']);
    I := AssertStatement('If statement', TCShImplIfElse, 1) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNull('No else', i.ElseBranch);
    AssertNotNull('if branch', I.IfBranch);
    AssertEquals('assignment statement', TCShImplAssign, I.ifBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfSKElse;

var
    I :TCShImplIfElse;

begin
    DeclareVar('bool');
    TestStatement(['if (a) ;', 'else', ';']);
    I := AssertStatement('If statement', TCShImplIfElse, 1) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNotNull('if branch', I.IfBranch);
    AssertEquals('Command', TCShImplCommand, I.ifBranch.ClassType);
    AssertEquals('Empty Command', '', TCShImplCommand(I.ifBranch).Command);
    AssertnotNull('else', i.ElseBranch);
    AssertEquals('Command', TCShImplCommand, I.ElseBranch.ClassType);
    AssertEquals('Empty Command', '', TCShImplCommand(I.ElseBranch).Command);
end;

procedure TTestParserStatementIf.TestIfBlockElse;

var
    I :TCShImplIfElse;

begin
    DeclareVar('bool');
    TestStatement(['if (a)', '  {', '  }', 'else', ';']);
    I := AssertStatement('If statement', TCShImplIfElse, 1) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNotNull('if branch', I.IfBranch);
    AssertEquals('begin end block', TCShImplBeginBlock, I.ifBranch.ClassType);
    AssertnotNull('else', i.ElseBranch);
    AssertEquals('Command', TCShImplCommand, I.ElseBranch.ClassType);
    AssertEquals('Empty Command', '', TCShImplCommand(I.ElseBranch).Command);
end;

procedure TTestParserStatementIf.TestIfElseBlock;
var
    I :TCShImplIfElse;

begin
    DeclareVar('bool');
    TestStatement(['if (a)', '  {', '  }', 'else', '  {', '  }']);
    I := AssertStatement('If statement', TCShImplIfElse, 1) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNotNull('if branch', I.IfBranch);
    AssertEquals('begin end block', TCShImplBeginBlock, I.ifBranch.ClassType);
    AssertNotNull('Else branch', i.ElseBranch);
    AssertEquals('begin end block', TCShImplBeginBlock, I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfElseInBlock;
var
    B :TCShImplBeginBlock;
    I :TCShImplIfElse;

begin
    DeclareVar('bool');
    TestStatement(['{', '  if (a)', '    DoA();', '  else ;', '}']);

    B := AssertStatement('begin block', TCShImplBeginBlock) as TCShImplBeginBlock;
    AssertEquals('One Element', 1, B.Elements.Count);
    AssertEquals('If statement', TCShImplIfElse, TObject(B.Elements[0]).ClassType);
    I := TCShImplIfElse(B.Elements[0]);
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNotNull('if branch', I.IfBranch);
    AssertEquals('i_br: simple command', TCShImplSimple, I.ifBranch.ClassType);
    AssertExpression('Doit call', TCShImplSimple(I.ifBranch).Expr, 'DoA');
    AssertnotNull('else', i.ElseBranch);
    AssertEquals('Command', TCShImplCommand, I.ElseBranch.ClassType);
    AssertEquals('Empty Command', '', TCShImplCommand(I.ElseBranch).Command);
end;

procedure TTestParserStatementIf.TestIfforElseBlock;

var
    I :TCShImplIfElse;

begin
    TestStatement(['if (a) ', 'for (X = 1, X >= 0,X--) Write(X);',
        'else', 'for (X = 0, X<= 1, X++) Write(X);']);
    I := AssertStatement('If statement', TCShImplIfElse) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertEquals('For statement', TCShImplForLoop, I.ifBranch.ClassType);
    AssertEquals('For statement', TCShImplForLoop, I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfRaiseElseBlock;
var
    I :TCShImplIfElse;
begin
    TestStatement(['if (a)', 'throw(e);', 'else', 'for (X = 0,X<= 1,X++) Writeln(X);']);
    I := AssertStatement('If statement', TCShImplIfElse) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertEquals('trow statement', TCShImplRaise, I.ifBranch.ClassType);
    AssertNotNull('Else-Branch exisis', I.ElseBranch);
    AssertEquals('For statement', TCShImplForLoop, I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfUsingBlock;
var
    I :TCShImplIfElse;
begin
    TestStatement(['if (a)', 'using(b) something();', 'else',
        'for (X = 0,X <= 1,X++) Writeln(X);']);
    I := AssertStatement('If statement', TCShImplIfElse) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertEquals('For statement', TCShImplUsing, I.ifBranch.ClassType);
    AssertEquals('For statement', TCShImplForLoop, I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestWhileNestedIf;
var
    W1 :TCShImplWhile;
    I  :TCShImplIfElse;
begin
    TestStatement(['while (a)', '  if (b)', 'while (c) { }', '  else', ' DoIt();']);
    W1 := AssertStatement('If statement', TCShImplWhile) as TCShImplWhile;
    AssertNotNull('Body is assigned', W1.Body);
    AssertNotNull('Params are assigned', W1.ParamExpression);
    AssertEquals('Body is TCShImplIfElse', TCShImplIfElse.ClassName, W1.Body.ClassName);
    I := TCShImplIfElse(W1.Body);
    AssertNotNull('Condition is assigned', I.ConditionExpr);
    AssertNotNull('If-Branch is assigned', I.IfBranch);
    AssertEquals('If-Branch is TCShImplIfElse', TCShImplWhile.ClassName,
        I.IfBranch.ClassName);
    AssertNotNull('Else-Branch are assigned', I.ElseBranch);
    AssertEquals('Else-Branch is TCShImplIfElse', TCShImplSimple.ClassName,
        I.ElseBranch.ClassName);
end;

procedure TTestParserStatementIf.TestWhileNestedIfBlock;
var
    W1 :TCShImplWhile;
    I  :TCShImplIfElse;
begin
    TestStatement(['while (a)', '  if (b)', 'while (c) ;', '  else', ' DoIt();']);
    W1 := AssertStatement('If statement', TCShImplWhile) as TCShImplWhile;
    AssertNotNull('Body is assigned', W1.Body);
    AssertNotNull('Params are assigned', W1.ParamExpression);
    AssertEquals('Body is TCShImplIfElse', TCShImplIfElse.ClassName, W1.Body.ClassName);
    I := TCShImplIfElse(W1.Body);
    AssertNotNull('Condition is assigned', I.ConditionExpr);
    AssertNotNull('If-Branch is assigned', I.IfBranch);
    AssertEquals('If-Branch is TCShImplIfElse', TCShImplWhile.ClassName,
        I.IfBranch.ClassName);
    AssertNotNull('Else-Branch are assigned', I.ElseBranch);
    AssertEquals('Else-Branch is TCShImplIfElse', TCShImplSimple.ClassName,
        I.ElseBranch.ClassName);
end;


procedure TTestParserStatementIf.TestIfElseError;

begin
    DeclareVar('bool');
    ExpectParserError('Semicolon before else', ['if (a)', 'else']);
end;

procedure TTestParserStatementIf.TestNestedIf;
var
    I :TCShImplIfElse;
begin
    DeclareVar('bool');
    DeclareVar('bool', 'b');
    TestStatement(['if (a)', '  if (b)', '    {', '    }', 'else', '  {', '  }']);
    I := AssertStatement('If statement', TCShImplIfElse, 2) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNotNull('if branch', I.IfBranch);
    AssertNull('Else branch', i.ElseBranch);
    AssertEquals('if in if branch', TCShImplIfElse, I.ifBranch.ClassType);
    I := I.Ifbranch as TCShImplIfElse;
    AssertEquals('begin end block', TCShImplBeginBlock, I.ElseBranch.ClassType);

end;

procedure TTestParserStatementIf.TestNestedIfElse;

var
    I :TCShImplIfElse;

begin
    DeclareVar('bool');
    TestStatement(['if (a)', '  if (b) ', '    {', '    }', '  else',
        '    {', '   }', 'else', '  {', '}']);
    I := AssertStatement('If statement', TCShImplIfElse, 1) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNotNull('if branch', I.IfBranch);
    AssertNotNull('Else branch', i.ElseBranch);
    AssertEquals('begin end block', TCShImplBeginBlock, I.ElseBranch.ClassType);
    AssertEquals('if in if branch', TCShImplIfElse, I.ifBranch.ClassType);
    I := I.Ifbranch as TCShImplIfElse;
    AssertEquals('begin end block', TCShImplBeginBlock, I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestNestedIfElseElse;

// Bug ID 37760

var
    I, I2 :TCShImplIfElse;

begin
    DeclareVar('bool');
    TestStatement(['if (a)', '  if (b)', '    DoA(); ',
        '   else;', ' else', '   DoB();']);
    I := AssertStatement('If statement', TCShImplIfElse, 1) as TCShImplIfElse;
    AssertExpression('IF condition', I.ConditionExpr, pekIdent, 'a');
    AssertNotNull('if branch', I.IfBranch);
    AssertNotNull('Have else for outer if', I.ElseBranch);
    AssertEquals('Have if in if branch', TCShImplIfElse, I.ifBranch.ClassType);
    I2 := I.Ifbranch as TCShImplIfElse;
    AssertExpression('IF condition', I2.ConditionExpr, pekIdent, 'b');
    AssertNotNull('Have then for inner if', I2.ifBranch);
    AssertnotNull('Empty else for inner if', I2.ElseBranch);
    AssertEquals('Have a commend for inner if else', TCShImplCommand,
        I2.ElseBranch.ClassType);
    AssertEquals('... an empty command', '', TCShImplCommand(I2.ElseBranch).Command);
end;

procedure TTestParserStatementIf.TestIfIfElseElseBlock;

var
    OuterIf, InnerIf :TCShImplIfElse;
begin
    DeclareVar('bool');
    DeclareVar('bool', 'B');
    TestStatement(['if (a)', 'if (b)', '  {', '  }', 'else ;',
        'else', '  {', '  }']);
    OuterIf := AssertStatement('If statement', TCShImplIfElse, 2) as TCShImplIfElse;
    AssertExpression('IF condition', OuterIf.ConditionExpr, pekIdent, 'a');
    AssertNotNull('if branch', OuterIf.IfBranch);
    AssertEquals('if else block', TCShImplIfElse, OuterIf.ifBranch.ClassType);
    InnerIf := OuterIf.IfBranch as TCShImplIfElse;
    AssertExpression('IF condition', InnerIf.ConditionExpr, pekIdent, 'b');
    AssertNotNull('if branch', InnerIf.IfBranch);
    AssertEquals('begin end block', TCShImplBeginBlock, InnerIf.ifBranch.ClassType);
    AssertNotNull('Else branch', InnerIf.ElseBranch);
    AssertEquals('empty statement', TCShImplCommand, InnerIf.ElseBranch.ClassType);
    AssertEquals('empty command', '', TCShImplCommand(InnerIf.ElseBranch).Command);
    AssertNotNull('Else branch', OuterIf.ElseBranch);
    AssertEquals('begin end block', TCShImplBeginBlock, OuterIf.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfnoSKError;
begin
    DeclareVar('bool');
    ExpectParserError('No Semicolon,Identifyer or CBraceopen missing', ['if (a)']);
end;

procedure TTestParserStatementIf.TestIfElsenoSKError;
begin
    DeclareVar('bool');
    ExpectParserError('No Semicolon,Identifyer or CBraceopen missing', ['if (a); else']);
end;

procedure TTestParserStatementIf.TestNestedIfElsenoSKError;
begin
    DeclareVar('bool');
    ExpectParserError('No Semicolon,Identifyer or CBraceopen missing',
        ['if (a) if (a); else else;']);
end;

procedure TTestParserStatementIf.TestIfSemiColonElseError;

begin
    DeclareVar('bool');
    ExpectParserError('No semicolon before else', ['if (a)', '  {',
        '  };', 'else', '  {', '  }']);
end;


procedure TTestParserStatementLoops.TestWhile;

var
    W :TCShImplWhile;

begin
    DeclareVar('bool');
    TestStatement(['while(a) ;']);
    W := AssertStatement('While statement', TCShImplWhile, 1) as TCShImplWhile;
    AssertExpression('While condition', W.ParamExpression, pekIdent, 'a');
    AssertNull('Empty body', W.Body);
end;

procedure TTestParserStatementLoops.TestWhileBlock;
var
    W :TCShImplWhile;

begin
    DeclareVar('bool');
    TestStatement(['while (a)', '  {', '  }']);
    W := AssertStatement('While statement', TCShImplWhile, 1) as TCShImplWhile;
    AssertExpression('While condition', W.ParamExpression, pekIdent, 'a');
    AssertNotNull('Have while body', W.Body);
    AssertEquals('begin end block', TCShImplBeginBlock, W.Body.ClassType);
    AssertEquals('Empty block', 0, TCShImplBeginBlock(W.Body).ELements.Count);
end;

procedure TTestParserStatementLoops.TestWhileNested;

var
    W :TCShImplWhile;

begin
    DeclareVar('bool');
    DeclareVar('bool', 'b');
    TestStatement(['while (a)', '  while (b)', '    {', '    }']);
    W := AssertStatement('While statement', TCShImplWhile, 2) as TCShImplWhile;
    AssertExpression('While condition', W.ParamExpression, pekIdent, 'a');
    AssertNotNull('Have while body', W.Body);
    AssertEquals('Nested while', TCShImplWhile, W.Body.ClassType);
    W := W.Body as TCShImplWhile;
    AssertExpression('While condition', W.ParamExpression, pekIdent, 'b');
    AssertNotNull('Have nested while body', W.Body);
    AssertEquals('Nested begin end block', TCShImplBeginBlock, W.Body.ClassType);
    AssertEquals('Empty nested block', 0, TCShImplBeginBlock(W.Body).ELements.Count);
end;

procedure TTestParserStatementLoops.TestDoWhile;

var
    R :TCShImplDoWhile;

begin
    DeclareVar('bool');
    TestStatement(['do;', 'while (a);']);
    R := AssertStatement('Repeat statement', TCShImplDoWhile, 1) as TCShImplDoWhile;
    AssertNotNull('Condition exists', R.ParamExpression);
    AssertExpression('repeat condition', R.ParamExpression, pekIdent, 'a');
    AssertNotNull('Empty body', R.Body);
end;

procedure TTestParserStatementLoops.TestDoWhileBlock;

var
    R :TCShImplDoWhile;

begin
    DeclareVar('bool');
    TestStatement(['do', '{', '}', 'while (a);']);
    R := AssertStatement('repeat statement', TCShImplDoWhile, 1) as TCShImplDoWhile;
    AssertExpression('repeat condition', R.ParamExpression, pekIdent, 'a');
    AssertEquals('Have statement', 1, R.Elements.Count);
    AssertEquals('begin end block', TCShImplBeginBlock,
        TObject(R.Elements[0]).ClassType);
    AssertEquals('Empty block', 0, TCShImplBeginBlock(R.Elements[0]).ELements.Count);
end;

procedure TTestParserStatementLoops.TestDoProcWhile;

var
    R :TCShImplDoWhile;

begin
    DeclareVar('bool');
    TestStatement(['do', '  Doit();', 'while (a);']);
    R := AssertStatement('repeat statement', TCShImplDoWhile, 1) as TCShImplDoWhile;
    AssertExpression('repeat condition', R.ParamExpression, pekIdent, 'a');
    AssertEquals('Have statement', 1, R.Elements.Count);
    AssertEquals('begin end block', TCShImplSimple, TObject(R.Body).ClassType);
    AssertExpression('repeat condition', TCShImplSimple(R.Body).Expr, 'Doit');
end;

procedure TTestParserStatementLoops.TestDoNested;
var
    R :TCShImplDoWhile;

begin
    DeclareVar('bool');
    DeclareVar('bool', 'b');
    TestStatement(['do', 'do', '{', '}', 'while (b);', 'while (a);']);
    R := AssertStatement('repeat statement', TCShImplDoWhile, 2) as TCShImplDoWhile;
    AssertExpression('repeat condition', R.ParamExpression, pekIdent, 'a');
    AssertEquals('Have statement', 1, R.Elements.Count);
    AssertEquals('Nested repeat', TCShImplDoWhile, TObject(R.Elements[0]).ClassType);
    R := TCShImplDoWhile(R.Elements[0]);
    AssertExpression('repeat condition', R.ParamExpression, pekIdent, 'b');
    AssertEquals('Have statement', 1, R.Elements.Count);
    AssertEquals('begin end block', TCShImplBeginBlock,
        TObject(R.Elements[0]).ClassType);
    AssertEquals('Empty block', 0, TCShImplBeginBlock(R.Elements[0]).ELements.Count);
end;

procedure TTestParserStatementLoops.TestDoWhileNested;
var
    R :TCShImplDoWhile;
    W :TCShImplWhile;

begin
    DeclareVar('bool');
    DeclareVar('bool', 'b');
    TestStatement(['do', 'while (b)', '{', '}', 'while (a);']);
    R := AssertStatement('repeat statement', TCShImplDoWhile, 2) as TCShImplDoWhile;
    AssertExpression('repeat condition', R.ParamExpression, pekIdent, 'a');
    AssertEquals('Have statement', 1, R.Elements.Count);
    AssertEquals('Nested repeat', TCShImplWhile, TObject(R.Elements[0]).ClassType);
    W := TCShImplWhile(R.Elements[0]);
    AssertExpression('repeat condition', W.ParamExpression, pekIdent, 'b');
    AssertEquals('Have statement', 1, W.Elements.Count);
    AssertEquals('begin end block', TCShImplBeginBlock,
        TObject(W.Elements[0]).ClassType);
    AssertEquals('Empty block', 0, TCShImplBeginBlock(W.Elements[0]).ELements.Count);
end;


procedure TTestParserStatementLoops.TestFor;

var
    F      :TCShImplForLoop;
    P      :TParamsExpr;
    P1, P2 :TBinaryExpr;
    P3     :TUnaryExpr;

begin
    DeclareVar('int');
    TestStatement(['for(a=1,a<10,a++)', ';']);
    F := AssertStatement('For statement', TCShImplForLoop, 1) as TCShImplForLoop;
    AssertNull('Empty body', F.Body);
    P := AssertExpression('Loop variable name', F.ParamExpression, 'a');
    //    AssertNotNull('Params', P.Params);
    AssertEquals('Param.count', 3, length(P.Params));
    P1 := AssertExpression('P1', P.Params[0], eopAssign);
    AssertExpression('Loop variable name', P1.left, pekIdent, 'a');
    P2 := AssertExpression('P2', P.Params[1], eopLessThan);
    AssertExpression('Loop variable name', P2.left, pekIdent, 'a');
    P3 := TUnaryExpr(AssertExpression('P3', P.Params[2], pekUnary, TUnaryExpr));
    AssertExpression('Loop variable name', P3.Operand, pekIdent, 'a');
    AssertEquals('P3.op=++', Ord(P3.OpCode), Ord(eopIncp));
end;

procedure TTestParserStatementLoops.TestForExpr;
var
    F  :TCShImplForLoop;
    B, P1, P2 :TBinaryExpr;
    P  :TParamsExpr;
    P3 :TUnaryExpr;

begin
    DeclareVar('int');
    TestStatement(['for(a=1+1,a< 5+5,a++) ', ';']);
    F := AssertStatement('For statement', TCShImplForLoop, 1) as TCShImplForLoop;
    AssertNull('Empty body', F.Body);
    P := AssertExpression('Loop variable name', F.ParamExpression, 'a');
    AssertEquals('Param.count', 3, length(P.Params));
    P1 := AssertExpression('P1', P.Params[0], eopAssign);
    AssertExpression('P1', P1.right, eopAdd);
    P2 := AssertExpression('P2', P.Params[1], eopLessThan);
    AssertExpression('P1', P2.right, eopAdd);
    P3 := TUnaryExpr(AssertExpression('P2', P.Params[2], pekUnary, TUnaryExpr));
end;

procedure TTestParserStatementLoops.TestForBlock;

var
    F :TCShImplForLoop;
    P      :TParamsExpr;
    P1, P2 :TBinaryExpr;
    P3     :TUnaryExpr;

begin
    DeclareVar('int');
    TestStatement(['for (a=1,a <=10,a++) ', '{', '}']);
    F := AssertStatement('For statement', TCShImplForLoop, 1) as TCShImplForLoop;
    AssertNotNull('Have for body', F.Body);
    AssertEquals('begin end block', TCShImplBeginBlock, F.Body.ClassType);
    AssertEquals('Empty block', 0, TCShImplBeginBlock(F.Body).ELements.Count);
    P := AssertExpression('Loop variable name', F.ParamExpression, 'a');
    //    AssertNotNull('Params', P.Params);
    AssertEquals('Param.count', 3, length(P.Params));
    P1 := AssertExpression('P1', P.Params[0], eopAssign);
    P2 := AssertExpression('P2', P.Params[1], eopLessthanEqual);
    P3 := TUnaryExpr(AssertExpression('P3', P.Params[2], pekUnary, TUnaryExpr));
    AssertEquals('P3.op=++', Ord(P3.OpCode), Ord(eopIncp));
end;

procedure TTestParserStatementLoops.TestDowntoBlock;

var
    F :TCShImplForLoop;
    P      :TParamsExpr;
    P1, P2 :TBinaryExpr;
    P3     :TUnaryExpr;

begin
    DeclareVar('int');
    TestStatement(['for (a=10,a>= 1,a--)', '{', '}']);
    F := AssertStatement('For statement', TCShImplForLoop, 1) as TCShImplForLoop;
    AssertNotNull('Have for body', F.Body);
    AssertEquals('begin end block', TCShImplBeginBlock, F.Body.ClassType);
    AssertEquals('Empty block', 0, TCShImplBeginBlock(F.Body).ELements.Count);
    P := AssertExpression('Loop variable name', F.ParamExpression, 'a');
    //    AssertNotNull('Params', P.Params);
    AssertEquals('Param.count', 3, length(P.Params));
    P1 := AssertExpression('P1', P.Params[0], eopAssign);
    P2 := AssertExpression('P2', P.Params[1], eopGreaterThanEqual);
    P3 := TUnaryExpr(AssertExpression('P3', P.Params[2], pekUnary, TUnaryExpr));
    AssertEquals('P3.op=--', Ord(P3.OpCode), Ord(eopDecp));
end;

procedure TTestParserStatementLoops.TestForNested;
var
    F :TCShImplForLoop;
    P      :TParamsExpr;
    P1, P2 :TBinaryExpr;
    P3     :TUnaryExpr;

begin
    DeclareVar('int');
    DeclareVar('int', 'b');
    TestStatement(['for (a=1,a<=10,a++) ', 'for (b=11,b <= 20,b++) ', '{', '}']);
    F := AssertStatement('For statement', TCShImplForLoop, 2) as TCShImplForLoop;
    AssertNotNull('Have while body', F.Body);
    AssertEquals('begin end block', TCShImplForLoop, F.Body.ClassType);
    P := AssertExpression('Loop variable name', F.ParamExpression, 'a');
    //    AssertNotNull('Params', P.Params);
    AssertEquals('Param.count', 3, length(P.Params));
    P1 := AssertExpression('P1', P.Params[0], eopAssign);
    AssertExpression('Loop variable name', P1.left, pekIdent, 'a');
    P2 := AssertExpression('P2', P.Params[1], eopLessthanEqual);
    AssertExpression('Loop variable name', P2.left, pekIdent, 'a');
    P3 := TUnaryExpr(AssertExpression('P3', P.Params[2], pekUnary, TUnaryExpr));
    AssertExpression('Loop variable name', P3.Operand, pekIdent, 'a');
    AssertEquals('P3.op=++', Ord(P3.OpCode), Ord(eopIncp));

    F := F.Body as TCShImplForLoop;
    AssertNotNull('Have for body', F.Body);
    AssertEquals('begin end block', TCShImplBeginBlock, F.Body.ClassType);
    AssertEquals('Empty block', 0, TCShImplBeginBlock(F.Body).ELements.Count);
    P := AssertExpression('Loop variable name', F.ParamExpression, 'a');
    //    AssertNotNull('Params', P.Params);
    AssertEquals('Param.count', 3, length(P.Params));
    P1 := AssertExpression('P1', P.Params[0], eopAssign);
    AssertExpression('Loop variable name', P1.left, pekIdent, 'b');
    P2 := AssertExpression('P2', P.Params[1], eopLessthanEqual);
    AssertExpression('Loop variable name', P2.left, pekIdent, 'b');
    P3 := TUnaryExpr(AssertExpression('P3', P.Params[2], pekUnary, TUnaryExpr));
    AssertExpression('Loop variable name', P3.Operand, pekIdent, 'b');
    AssertEquals('P3.op=++', Ord(P3.OpCode), Ord(eopIncp));
end;

procedure TTestParserStatementLoops.TestForeachIn;

var
    F :TCShImplForeachLoop;
    P :TBinaryExpr;

begin
    DeclareVar('int');
    TestStatement(['foreach (a in SomeSet)', ';']);
    F := AssertStatement('For statement', TCShImplForeachLoop, 1) as TCShImplForeachLoop;
    P := AssertExpression('Loop variable name', F.ParamExpression, eopIn);
    AssertExpression('Loop variable name', P.left, pekIdent, 'a');
    AssertExpression('in Set', P.right, pekIdent, 'SomeSet');
    AssertNull('Empty body', F.Body);
end;


procedure TTestParserStatementUsing.TestUsing;

var
    W :TCShImplUsing;

begin
    DeclareVar('struct { int X,Y; }');
    TestStatement(['using (a) ', '{', '}']);
    W := AssertStatement('For statement', TCShImplUsing, 1) as TCShImplUsing;
    AssertNotNull('Have with body', W.Body);
    AssertEquals('begin end block', TCShImplBeginBlock, W.Body.ClassType);
    AssertEquals('Empty block', 0, TCShImplBeginBlock(W.Body).ELements.Count);
end;

procedure TTestParserStatementUsing.TestWithMultiple;
var
    W :TCShImplUsing;

begin
    DeclareVar('record X,Y : Integer; end');
    DeclareVar('record W,Z : Integer; end', 'b');
    TestStatement(['With a,b do', 'begin', 'end']);
    W := AssertStatement('Using statement', TCShImplUsing) as TCShImplUsing;
    AssertNotNull('Have with body', W.Body);
    AssertEquals('begin end block', TCShImplBeginBlock, W.Body.ClassType);
    AssertEquals('Empty block', 0, TCShImplBeginBlock(W.Body).ELements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseEmpty;
begin
    DeclareVar('integer');
    AddStatements(['case a of', 'end;']);
    ExpectParserError('Empty case not allowed');
end;

procedure TTestParserStatementSwitch.TestCaseOneInteger;

var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;

begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : ;', 'end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertNull('No else branch', C.ElseBranch);
    AssertEquals('One case label', 1, C.Elements.Count);
    AssertEquals('Correct case for case label', TCShImplCaseStatement,
        TCShElement(C.Elements[0]).ClassType);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('1 expression for case', 1, S.Expressions.Count);
    AssertExpression('With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    AssertEquals('Empty case label statement', 0, S.Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseTwoIntegers;

var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;

begin
    DeclareVar('integer');
    TestStatement(['case a of', '1,2 : ;', 'end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertNull('No else branch', C.ElseBranch);
    AssertEquals('One case label', 1, C.Elements.Count);
    AssertEquals('Correct case for case label', TCShImplCaseStatement,
        TCShElement(C.Elements[0]).ClassType);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('2 expressions for case', 2, S.Expressions.Count);
    AssertExpression('With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    AssertExpression('With identifier 2', TCShExpr(S.Expressions[1]), pekNumber, '2');
    AssertEquals('Empty case label statement', 0, S.Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseRange;
var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;

begin
    DeclareVar('integer');
    TestStatement(['case a of', '1..3 : ;', 'end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertNull('No else branch', C.ElseBranch);
    AssertEquals('One case label', 1, C.Elements.Count);
    AssertEquals('Correct case for case label', TCShImplCaseStatement,
        TCShElement(C.Elements[0]).ClassType);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('1 expression for case', 1, S.Expressions.Count);
    AssertExpression('With identifier 1', TCShExpr(S.Expressions[0]), pekRange, TBinaryExpr);
    AssertEquals('Empty case label statement', 0, S.Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseRangeSeparate;
var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;

begin
    DeclareVar('integer');
    TestStatement(['case a of', '1..3,5 : ;', 'end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertNull('No else branch', C.ElseBranch);
    AssertEquals('One case label', 1, C.Elements.Count);
    AssertEquals('Correct case for case label', TCShImplCaseStatement,
        TCShElement(C.Elements[0]).ClassType);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('2 expressions for case', 2, S.Expressions.Count);
    AssertExpression('With identifier 1', TCShExpr(S.Expressions[0]), pekRange, TBinaryExpr);
    AssertExpression('With identifier 2', TCShExpr(S.Expressions[1]), pekNumber, '5');
    AssertEquals('Empty case label statement', 0, S.Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCase2Cases;
var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;

begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : ;', '2 : ;', 'end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertNull('No else branch', C.ElseBranch);
    AssertEquals('Two case labels', 2, C.Elements.Count);
    AssertEquals('Correct case for case label 1', TCShImplCaseStatement,
        TCShElement(C.Elements[0]).ClassType);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('2 expressions for case 1', 1, S.Expressions.Count);
    AssertExpression('Case 1 With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    AssertEquals('Empty case label statement 1', 0, S.Elements.Count);
    // Two
    AssertEquals('Correct case for case label 2', TCShImplCaseStatement,
        TCShElement(C.Elements[1]).ClassType);
    S := TCShImplCaseStatement(C.Elements[1]);
    AssertEquals('2 expressions for case 2', 1, S.Expressions.Count);
    AssertExpression('Case 2 With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '2');
    AssertEquals('Empty case label statement 2', 0, S.Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseBlock;

var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;
    B :TCShImplbeginBlock;

begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : begin end;', 'end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertNull('No else branch', C.ElseBranch);
    AssertEquals('Two case labels', 1, C.Elements.Count);
    AssertEquals('Correct case for case label 1', TCShImplCaseStatement,
        TCShElement(C.Elements[0]).ClassType);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('2 expressions for case 1', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    AssertEquals('1 case label statement', 1, S.Elements.Count);
    AssertEquals('Correct case for case label 1', TCShImplbeginBlock,
        TCShElement(S.Elements[0]).ClassType);
    B := TCShImplbeginBlock(S.Elements[0]);
    AssertEquals('0 statements in block', 0, B.Elements.Count);

end;

procedure TTestParserStatementSwitch.TestCaseElseBlockEmpty;

var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;
    B :TCShImplbeginBlock;

begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : begin end;', 'else', ' end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertEquals('Two case labels', 2, C.Elements.Count);
    AssertEquals('Correct case for case label 1', TCShImplCaseStatement,
        TCShElement(C.Elements[0]).ClassType);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('2 expressions for case 1', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    AssertEquals('1 case label statement', 1, S.Elements.Count);
    AssertEquals('Correct case for case label 1', TCShImplbeginBlock,
        TCShElement(S.Elements[0]).ClassType);
    B := TCShImplbeginBlock(S.Elements[0]);
    AssertEquals('0 statements in block', 0, B.Elements.Count);
    AssertNotNull('Have else branch', C.ElseBranch);
    AssertEquals('Correct else branch class', TCShImplSwitchElse, C.ElseBranch.ClassType);
    AssertEquals('Zero statements ', 0, TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseOtherwiseBlockEmpty;

var
    C :TCShImplSwitch;
begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : begin end;', 'otherwise', ' end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertNotNull('Have else branch', C.ElseBranch);
    AssertEquals('Correct else branch class', TCShImplSwitchElse, C.ElseBranch.ClassType);
    AssertEquals('Zero statements ', 0, TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseElseBlockAssignment;
var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;
    B :TCShImplbeginBlock;

begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : begin end;', 'else', 'a:=1', ' end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertEquals('Two case labels', 2, C.Elements.Count);
    AssertEquals('Correct case for case label 1', TCShImplCaseStatement,
        TCShElement(C.Elements[0]).ClassType);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('2 expressions for case 1', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    AssertEquals('1 case label statement', 1, S.Elements.Count);
    AssertEquals('Correct case for case label 1', TCShImplbeginBlock,
        TCShElement(S.Elements[0]).ClassType);
    B := TCShImplbeginBlock(S.Elements[0]);
    AssertEquals('0 statements in block', 0, B.Elements.Count);
    AssertNotNull('Have else branch', C.ElseBranch);
    AssertEquals('Correct else branch class', TCShImplSwitchElse, C.ElseBranch.ClassType);
    AssertEquals('1 statement in else branch ', 1, TCShImplSwitchElse(
        C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseElseBlock2Assignments;

var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;
    B :TCShImplbeginBlock;

begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : begin end;', 'else', 'a:=1;', 'a:=32;', ' end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertEquals('Two case labels', 2, C.Elements.Count);
    AssertEquals('Correct case for case label 1', TCShImplCaseStatement,
        TCShElement(C.Elements[0]).ClassType);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('2 expressions for case 1', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    AssertEquals('1 case label statement', 1, S.Elements.Count);
    AssertEquals('Correct case for case label 1', TCShImplbeginBlock,
        TCShElement(S.Elements[0]).ClassType);
    B := TCShImplbeginBlock(S.Elements[0]);
    AssertEquals('0 statements in block', 0, B.Elements.Count);
    AssertNotNull('Have else branch', C.ElseBranch);
    AssertEquals('Correct else branch class', TCShImplSwitchElse, C.ElseBranch.ClassType);
    AssertEquals('2 statements in else branch ', 2, TCShImplSwitchElse(
        C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseIfCaseElse;

var
    C :TCShImplSwitch;

begin
    DeclareVar('integer');
    DeclareVar('boolean', 'b');
    TestStatement(['case a of', '1 : if b then', ' begin end;', 'else', ' end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertEquals('Two case labels', 2, C.Elements.Count);
    AssertNotNull('Have else branch', C.ElseBranch);
    AssertEquals('Correct else branch class', TCShImplSwitchElse, C.ElseBranch.ClassType);
    AssertEquals('0 statement in else branch ', 0, TCShImplSwitchElse(
        C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseIfElse;
var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;

begin
    DeclareVar('integer');
    DeclareVar('boolean', 'b');
    TestStatement(['case a of', '1 : if b then', ' begin end', 'else', 'begin', 'end', ' end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertEquals('One case label', 1, C.Elements.Count);
    AssertNull('Have no else branch', C.ElseBranch);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('2 expressions for case 1', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    AssertEquals('1 case label statement', 1, S.Elements.Count);
    AssertEquals('If statement in case label 1', TCShImplIfElse, TCShElement(
        S.Elements[0]).ClassType);
    AssertNotNull('If statement has else block', TCShImplIfElse(S.Elements[0]).ElseBranch);
end;

procedure TTestParserStatementSwitch.TestCaseIfCaseElseElse;
var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;

begin
    DeclareVar('integer');
    DeclareVar('boolean', 'b');
    TestStatement(['case a of', '1 : if b then', ' begin end', 'else',
        'else', 'DoElse', ' end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertEquals('Two case labels', 2, C.Elements.Count);
    AssertNotNull('Have an else branch', C.ElseBranch);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('2 expressions for case 1', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    AssertEquals('1 case label statement', 1, S.Elements.Count);
    AssertEquals('If statement in case label 1', TCShImplIfElse, TCShElement(
        S.Elements[0]).ClassType);
    AssertNotNull('If statement has else block', TCShImplIfElse(S.Elements[0]).ElseBranch);
    AssertEquals('If statement has a commend as else block', TCShImplCommand,
        TCShImplIfElse(S.Elements[0]).ElseBranch.ClassType);
    AssertEquals('But ... an empty command', '', TCShImplCommand(
        TCShImplIfElse(S.Elements[0]).ElseBranch).Command);
end;

procedure TTestParserStatementSwitch.TestCaseElseNoSemicolon;
var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;
begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : dosomething;', '2 : dosomethingmore',
        'else', 'a:=1;', 'end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertEquals('case label count', 3, C.Elements.Count);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('case 1', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    S := TCShImplCaseStatement(C.Elements[1]);
    AssertEquals('case 2', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '2');
    AssertEquals('third is else', TCShImplSwitchElse, TObject(C.Elements[2]).ClassType);
    AssertNotNull('Have else branch', C.ElseBranch);
    AssertEquals('Correct else branch class', TCShImplSwitchElse, C.ElseBranch.ClassType);
    AssertEquals('1 statements in else branch ', 1, TCShImplSwitchElse(
        C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseIfElseNoSemicolon;
var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;
begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : dosomething;', '2: if b then',
        ' dosomething', 'else  dosomethingmore', 'else', 'a:=1;', 'end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertEquals('case label count', 3, C.Elements.Count);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('case 1', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    S := TCShImplCaseStatement(C.Elements[1]);
    AssertEquals('case 2', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '2');
    AssertEquals('third is else', TCShImplSwitchElse, TObject(C.Elements[2]).ClassType);
    AssertNotNull('Have else branch', C.ElseBranch);
    AssertEquals('Correct else branch class', TCShImplSwitchElse, C.ElseBranch.ClassType);
    AssertEquals('1 statements in else branch ', 1, TCShImplSwitchElse(
        C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementSwitch.TestCaseIfOtherwiseNoSemicolon;
var
    C :TCShImplSwitch;
    S :TCShImplCaseStatement;
begin
    DeclareVar('integer');
    TestStatement(['case a of', '1 : dosomething;', '2: if b then',
        ' dosomething', 'else  dosomethingmore', 'otherwise', 'a:=1;', 'end;']);
    C := AssertStatement('Case statement', TCShImplSwitch) as TCShImplSwitch;
    AssertNotNull('Have case expression', C.CaseExpr);
    AssertExpression('Case expression', C.CaseExpr, pekIdent, 'a');
    AssertEquals('case label count', 3, C.Elements.Count);
    S := TCShImplCaseStatement(C.Elements[0]);
    AssertEquals('case 1', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '1');
    S := TCShImplCaseStatement(C.Elements[1]);
    AssertEquals('case 2', 1, S.Expressions.Count);
    AssertExpression('Case With identifier 1', TCShExpr(S.Expressions[0]), pekNumber, '2');
    AssertEquals('third is else', TCShImplSwitchElse, TObject(C.Elements[2]).ClassType);
    AssertNotNull('Have else branch', C.ElseBranch);
    AssertEquals('Correct else branch class', TCShImplSwitchElse, C.ElseBranch.ClassType);
    AssertEquals('1 statements in else branch ', 1, TCShImplSwitchElse(
        C.ElseBranch).Elements.Count);
end;



procedure TTestParserStatementThrow.TestRaise;

var
    R :TCShImplRaise;

begin
    DeclareVar('Exception');
    TestStatement('Raise A;');
    R := AssertStatement('Raise statement', TCShImplRaise) as TCShImplRaise;
    AssertEquals(0, R.Elements.Count);
    AssertNotNull(R.ExceptObject);
    AssertNull(R.ExceptAddr);
    AssertExpression('Expression object', R.ExceptObject, pekIdent, 'A');
end;

procedure TTestParserStatementThrow.TestRaiseEmpty;
var
    R :TCShImplRaise;

begin
    TestStatement('Raise;');
    R := AssertStatement('Raise statement', TCShImplRaise) as TCShImplRaise;
    AssertEquals(0, R.Elements.Count);
    AssertNull(R.ExceptObject);
    AssertNull(R.ExceptAddr);
end;

procedure TTestParserStatementThrow.TestRaiseAt;

var
    R :TCShImplRaise;

begin
    DeclareVar('Exception');
    DeclareVar('Pointer', 'B');
    TestStatement('Raise A at B;');
    R := AssertStatement('Raise statement', TCShImplRaise) as TCShImplRaise;
    AssertEquals(0, R.Elements.Count);
    AssertNotNull(R.ExceptObject);
    AssertNotNull(R.ExceptAddr);
    AssertExpression('Expression object', R.ExceptAddr, pekIdent, 'B');
end;

procedure TTestParserStatementTry.TestTryFinally;

var
    T :TCShImplTry;
    S :TCShImplSimple;
    F :TCShImplTryFinally;

begin
    TestStatement(['Try', '  DoSomething;', 'finally', '  DoSomethingElse', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Finally statement', TCShImplTryFinally, T.FinallyExcept.ClassType);
    F := TCShImplTryFinally(T.FinallyExcept);
    AssertEquals(1, F.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(F.Elements[0]).ClassType);
    S := TCShImplSimple(F.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse');
end;

procedure TTestParserStatementTry.TestTryFinallyEmpty;
var
    T :TCShImplTry;
    F :TCShImplTryFinally;

begin
    TestStatement(['Try', 'finally', 'end;']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(0, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertEquals('Finally statement', TCShImplTryFinally, T.FinallyExcept.ClassType);
    F := TCShImplTryFinally(T.FinallyExcept);
    AssertEquals(0, F.Elements.Count);
end;

procedure TTestParserStatementTry.TestTryFinallyNested;
var
    T :TCShImplTry;
    S :TCShImplSimple;
    F :TCShImplTryFinally;

begin
    TestStatement(['Try', '  DoSomething1;', '  Try', '    DoSomething2;',
        '  finally', '    DoSomethingElse2', '  end;', 'Finally', '  DoSomethingElse1', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(2, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething1');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Finally statement', TCShImplTryFinally, T.FinallyExcept.ClassType);
    F := TCShImplTryFinally(T.FinallyExcept);
    AssertEquals(1, F.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(F.Elements[0]).ClassType);
    S := TCShImplSimple(F.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse1');
    // inner statement
    AssertNotNull(T.Elements[1]);
    AssertEquals('Nested try statement', TCShImplTry, TCShElement(T.Elements[1]).ClassType);
    T := TCShImplTry(T.Elements[1]);
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething2');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Finally statement', TCShImplTryFinally, T.FinallyExcept.ClassType);
    F := TCShImplTryFinally(T.FinallyExcept);
    AssertEquals(1, F.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(F.Elements[0]).ClassType);
    S := TCShImplSimple(F.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse2');
end;

procedure TTestParserStatementTry.TestTryExcept;

var
    T :TCShImplTry;
    S :TCShImplSimple;
    E :TCShImplTryExcept;

begin
    TestStatement(['Try', '  DoSomething;', 'except', '  DoSomethingElse', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Except statement', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(1, E.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(E.Elements[0]).ClassType);
    S := TCShImplSimple(E.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse');
end;

procedure TTestParserStatementTry.TestTryExceptNested;
var
    T :TCShImplTry;
    S :TCShImplSimple;
    E :TCShImplTryExcept;

begin
    TestStatement(['Try', '  DoSomething1;', '  try', '    DoSomething2;',
        '  except', '    DoSomethingElse2', '  end', 'except', '  DoSomethingElse1', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(2, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething1');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Except statement', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(1, E.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(E.Elements[0]).ClassType);
    S := TCShImplSimple(E.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse1');
    AssertNotNull(T.Elements[1]);
    AssertEquals('Simple statement', TCShImplTry, TCShElement(T.Elements[1]).ClassType);
    T := TCShImplTry(T.Elements[1]);
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement 2', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething2 call ', S.Expr, pekIdent, 'DoSomething2');
    AssertEquals('Simple statement2', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Except statement2', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(1, E.Elements.Count);
    AssertEquals('Simple statement2', TCShImplSimple, TCShElement(E.Elements[0]).ClassType);
    S := TCShImplSimple(E.Elements[0]);
    AssertExpression('DoSomethingElse2 call', S.Expr, pekIdent, 'DoSomethingElse2');
end;

procedure TTestParserStatementTry.TestTryExceptEmpty;

var
    T :TCShImplTry;
    E :TCShImplTryExcept;

begin
    TestStatement(['Try', 'except', 'end;']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(0, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertEquals('Except statement', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(0, E.Elements.Count);
end;

procedure TTestParserStatementTry.TestTryExceptOn;

var
    T :TCShImplTry;
    S :TCShImplSimple;
    E :TCShImplTryExcept;
    O :TCShImplExceptOn;

begin
    TestStatement(['Try', '  DoSomething;', 'except', 'On E : Exception do',
        'DoSomethingElse;', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Except statement', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(1, E.Elements.Count);
    AssertEquals('Except on handler', TCShImplExceptOn, TCShElement(
        E.Elements[0]).ClassType);
    O := TCShImplExceptOn(E.Elements[0]);
    AssertEquals(1, O.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(O.Elements[0]).ClassType);
    AssertEquals('Exception Variable name', 'E', O.VariableName);
    AssertEquals('Exception Type name', 'Exception', O.TypeName);
    S := TCShImplSimple(O.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse');
    //  AssertEquals('Variable name',

end;

procedure TTestParserStatementTry.TestTryExceptOn2;

var
    T :TCShImplTry;
    S :TCShImplSimple;
    E :TCShImplTryExcept;
    O :TCShImplExceptOn;

begin
    TestStatement(['Try', '  DoSomething;', 'except',
        'On E : Exception do', 'DoSomethingElse;',
        'On Y : Exception2 do', 'DoSomethingElse2;', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Except statement', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(2, E.Elements.Count);
    // Exception handler 1
    AssertEquals('Except on handler', TCShImplExceptOn, TCShElement(
        E.Elements[0]).ClassType);
    O := TCShImplExceptOn(E.Elements[0]);
    AssertEquals(1, O.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(O.Elements[0]).ClassType);
    AssertEquals('Exception Variable name', 'E', O.VariableName);
    AssertEquals('Exception Type name', 'Exception', O.TypeName);
    S := TCShImplSimple(O.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse');
    // Exception handler 2
    AssertEquals('Except on handler', TCShImplExceptOn, TCShElement(
        E.Elements[1]).ClassType);
    O := TCShImplExceptOn(E.Elements[1]);
    AssertEquals(1, O.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(O.Elements[0]).ClassType);
    AssertEquals('Exception Variable name', 'Y', O.VariableName);
    AssertEquals('Exception Type name', 'Exception2', O.TypeName);
    S := TCShImplSimple(O.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse2');
end;

procedure TTestParserStatementTry.TestTryExceptOnElse;
var
    T  :TCShImplTry;
    S  :TCShImplSimple;
    E  :TCShImplTryExcept;
    O  :TCShImplExceptOn;
    EE :TCShImplTryExceptElse;
    I  :TCShImplIfElse;

begin
    DeclareVar('Boolean', 'b');
    // Check that Else belongs to Except, not to IF

    TestStatement(['Try', '  DoSomething;', 'except', 'On E : Exception do',
        'if b then', 'DoSomethingElse;', 'else', 'DoSomethingMore;', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNotNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Except statement', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(1, E.Elements.Count);
    AssertEquals('Except on handler', TCShImplExceptOn, TCShElement(
        E.Elements[0]).ClassType);
    O := TCShImplExceptOn(E.Elements[0]);
    AssertEquals('Exception Variable name', 'E', O.VariableName);
    AssertEquals('Exception Type name', 'Exception', O.TypeName);
    AssertEquals(1, O.Elements.Count);
    AssertEquals('Simple statement', TCShImplIfElse, TCShElement(O.Elements[0]).ClassType);
    I := TCShImplIfElse(O.Elements[0]);
    AssertEquals(1, I.Elements.Count);
    AssertNull('No else barcnh for if', I.ElseBranch);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(I.Elements[0]).ClassType);
    S := TCShImplSimple(I.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse');
    AssertEquals('Except Else statement', TCShImplTryExceptElse, T.ElseBranch.ClassType);
    EE := TCShImplTryExceptElse(T.ElseBranch);
    AssertEquals(1, EE.Elements.Count);
    AssertNotNull(EE.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(EE.Elements[0]).ClassType);
    S := TCShImplSimple(EE.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomethingMore');
end;

procedure TTestParserStatementTry.TestTryExceptOnIfElse;
var
    T  :TCShImplTry;
    S  :TCShImplSimple;
    E  :TCShImplTryExcept;
    O  :TCShImplExceptOn;
    EE :TCShImplTryExceptElse;

begin
    TestStatement(['Try', '  DoSomething;', 'except', 'On E : Exception do',
        'DoSomethingElse;', 'else', 'DoSomethingMore;', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNotNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Except statement', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(1, E.Elements.Count);
    AssertEquals('Except on handler', TCShImplExceptOn, TCShElement(
        E.Elements[0]).ClassType);
    O := TCShImplExceptOn(E.Elements[0]);
    AssertEquals('Exception Variable name', 'E', O.VariableName);
    AssertEquals('Exception Type name', 'Exception', O.TypeName);
    AssertEquals(1, O.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(O.Elements[0]).ClassType);
    S := TCShImplSimple(O.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse');
    AssertEquals('Except Else statement', TCShImplTryExceptElse, T.ElseBranch.ClassType);
    EE := TCShImplTryExceptElse(T.ElseBranch);
    AssertEquals(1, EE.Elements.Count);
    AssertNotNull(EE.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(EE.Elements[0]).ClassType);
    S := TCShImplSimple(EE.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomethingMore');
end;

procedure TTestParserStatementTry.TestTryExceptOnElseNoSemicolo;
var
    T  :TCShImplTry;
    S  :TCShImplSimple;
    E  :TCShImplTryExcept;
    O  :TCShImplExceptOn;
    EE :TCShImplTryExceptElse;
begin
    TestStatement(['Try', '  DoSomething;', 'except', 'On E : Exception do',
        'DoSomethingElse', 'else', 'DoSomethingMore', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNotNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Except statement', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(1, E.Elements.Count);
    AssertEquals('Except on handler', TCShImplExceptOn, TCShElement(
        E.Elements[0]).ClassType);
    O := TCShImplExceptOn(E.Elements[0]);
    AssertEquals('Exception Variable name', 'E', O.VariableName);
    AssertEquals('Exception Type name', 'Exception', O.TypeName);
    AssertEquals(1, O.Elements.Count);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(O.Elements[0]).ClassType);
    S := TCShImplSimple(O.Elements[0]);
    AssertExpression('DoSomethingElse call', S.Expr, pekIdent, 'DoSomethingElse');
    AssertEquals('Except Else statement', TCShImplTryExceptElse, T.ElseBranch.ClassType);
    EE := TCShImplTryExceptElse(T.ElseBranch);
    AssertEquals(1, EE.Elements.Count);
    AssertNotNull(EE.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(EE.Elements[0]).ClassType);
    S := TCShImplSimple(EE.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomethingMore');
end;

procedure TTestParserStatementTry.TestTryExceptRaise;
var
    T :TCShImplTry;
    S :TCShImplSimple;
    E :TCShImplTryExcept;

begin
    TestStatement(['Try', '  DoSomething;', 'except', '  raise', 'end']);
    T := AssertStatement('Try statement', TCShImplTry) as TCShImplTry;
    AssertEquals(1, T.Elements.Count);
    AssertNotNull(T.FinallyExcept);
    AssertNull(T.ElseBranch);
    AssertNotNull(T.Elements[0]);
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    S := TCShImplSimple(T.Elements[0]);
    AssertExpression('DoSomething call', S.Expr, pekIdent, 'DoSomething');
    AssertEquals('Simple statement', TCShImplSimple, TCShElement(T.Elements[0]).ClassType);
    AssertEquals('Except statement', TCShImplTryExcept, T.FinallyExcept.ClassType);
    E := TCShImplTryExcept(T.FinallyExcept);
    AssertEquals(1, E.Elements.Count);
    AssertEquals('Raise statement', TCShImplRaise, TCShElement(E.Elements[0]).ClassType);
end;

procedure TTestParserStatementSpecial.TestAssignToAddress;

begin
    AddStatements(['@Proc:=Nil']);
    ParseModule;
end;

procedure TTestParserStatementSpecial.TestFinalizationNoSemicolon;
begin
    Source.Add('unit afile;');
    Source.Add('{$mode objfpc}');
    Source.Add('interface');
    Source.Add('implementation');
    Source.Add('initialization');
    Source.Add('  writeln(''qqq'')');
    Source.Add('finalization');
    Source.Add('  write(''rrr'')');
    ParseModule;
end;

procedure TTestParserStatementSpecial.TestMacroComment;
begin
    AddStatements(['{$MACRO ON}', '{$DEFINE func := //}', '  calltest;',
        '  func (''1'',''2'',''3'');', 'CallTest2;']);
    ParseModule;
end;

procedure TTestParserStatementSpecial.TestPlatformIdentifier;
begin
    AddStatements(['write(platform);']);
    ParseModule;
end;

procedure TTestParserStatementSpecial.TestPlatformIdentifier2;
begin
    AddStatements(['write(libs+platform);']);
    ParseModule;
end;

procedure TTestParserStatementSpecial.TestArgumentNameOn;
begin
    Source.Add('function TryOn(const on: boolean): boolean;');
    Source.Add('  begin');
    Source.Add('  end;');
    Source.Add('  begin');
    Source.Add('  end.');
    ParseModule;
end;

procedure TTestParserStatementSpecial.TestGotoInIfThen;

begin
    AddStatements(['{$goto on}', 'if expr then', '  dosomething',
        '   else if expr2 then', '    goto try_qword', '  else',
        '    dosomething;', '  try_qword:', '  dosomething;']);
    ParseModule;
end;

initialization
    RegisterTests('TCShTestParserStatements', 
        [TTestParserStatementEmpty, TTestParserStatementBlock,
        TTestParserStatementAssignment, TTestParserStatementCall,
        TTestParserStatementIf, TTestParserStatementLoops, TTestParserStatementUsing,
        TTestParserStatementSwitch, TTestParserStatementThrow,
        TTestParserStatementTry, TTestParserStatementSpecial]);

end.
