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

Type
  { TTestStatementParserBase }

  TTestStatementParserBase = Class(TTestParser)
  private
    FMainClass: TCShClassType;
    FMainProc: TCShFunction;
    FStatement: TCShImplBlock;
    FVariables : TStrings;
  Protected
    Procedure SetUp; override;
    Procedure TearDown; override;
    procedure AddStatements(ASource : Array of string);
    Procedure DeclareVar(Const AVarType : String; Const AVarName : String = 'A');
    function TestStatement(ASource : string) : TCShImplElement;
    function TestStatement(ASource : Array of string) : TCShImplElement;
    Procedure ExpectParserError(Const Msg : string);
    Procedure ExpectParserError(Const Msg : string; ASource : Array of string);
    Function AssertStatement(Msg : String; AClass : TClass;AIndex : Integer = 0) : TCShImplBlock;overload;
    Procedure  AssertImplElement(Msg : String; AClass : TClass;aStmt:TCShImplElement);overload;
    Property Statement: TCShImplBlock Read FStatement;
    property MainClass:TCShClassType read FMainClass;
    property MainProc:TCShFunction read FMainProc;
  end;

  TTestParserStatementEmpty=class(TTestStatementParserBase)
        Procedure TestEmpty;
    Procedure TestEmptyStatement;
    Procedure TestEmptyStatements;
  end;

  TTestParserStatementBlock=class(TTestStatementParserBase)
    Procedure TestBlock;
    Procedure TestBlockComment;
    Procedure TestBlock2Comments;
  end;

  TTestParserStatementAssignment=class(TTestStatementParserBase)
    Procedure TestAssignment;
    Procedure TestAssignmentAdd;
    Procedure TestAssignmentMinus;
    Procedure TestAssignmentMul;
    Procedure TestAssignmentDivision;
    Procedure TestAssignmentMissingSemicolonError;
  end;

  TTestParserStatementCall=class(TTestStatementParserBase)
 private
    procedure TestCallFormat(FN: String; AddPrecision: Boolean; AddSecondParam: boolean = false);
    procedure DoTestCallOtherFormat;
  published
    Procedure TestCall;
    Procedure TestCallComment;
    Procedure TestCallQualified;
    Procedure TestCallQualified2;
    Procedure TestCallNoArgs;
    Procedure TestCallOneArg;
    procedure TestCallWriteFormat1;
    procedure TestCallWriteFormat2;
    procedure TestCallWriteFormat3;
    procedure TestCallWriteFormat4;
    procedure TestCallWritelnFormat1;
    procedure TestCallWritelnFormat2;
    procedure TestCallStrFormat1;
    procedure TestCallStrFormat2;
    procedure TestCallOtherFormat;
  end;

  TTestParserStatementIf=class(TTestStatementParserBase)
    Procedure TestIf;
    Procedure TestIfBlock;
    Procedure TestIfAssignment;
    Procedure TestIfElse;
    Procedure TestIfElseBlock;
    procedure TestIfElseInBlock;
    Procedure TestIfSemiColonElseError;
    procedure TestIfforElseBlock;
    procedure TestIfRaiseElseBlock;
    procedure TestIfWithBlock;
    Procedure TestNestedIf;
    Procedure TestNestedIfElse;
    Procedure TestNestedIfElseElse;
    procedure TestIfIfElseElseBlock;
  end;

  TTestParserStatementLoops=class(TTestStatementParserBase)
    Procedure TestWhile;
    Procedure TestWhileBlock;
    Procedure TestWhileNested;
    Procedure TestRepeat;
    Procedure TestRepeatBlock;
    procedure TestRepeatBlockNosemicolon;
    Procedure TestRepeatNested;
    Procedure TestFor;
    Procedure TestForIn;
    Procedure TestForExpr;
    Procedure TestForBlock;
    procedure TestDowntoBlock;
    Procedure TestForNested;
  end;

  TTestParserStatementWith=class(TTestStatementParserBase)
    Procedure TestWith;
    Procedure TestWithMultiple;
  end;

  TTestParserStatementCase=class(TTestStatementParserBase)
    Procedure TestCaseEmpty;
    Procedure TestCaseOneInteger;
    Procedure TestCaseTwoIntegers;
    Procedure TestCaseRange;
    Procedure TestCaseRangeSeparate;
    Procedure TestCase2Cases;
    Procedure TestCaseBlock;
    Procedure TestCaseElseBlockEmpty;
    procedure TestCaseOtherwiseBlockEmpty;
    Procedure TestCaseElseBlockAssignment;
    Procedure TestCaseElseBlock2Assignments;
    Procedure TestCaseIfCaseElse;
    Procedure TestCaseIfCaseElseElse;
    Procedure TestCaseIfElse;
    Procedure TestCaseElseNoSemicolon;
    Procedure TestCaseIfElseNoSemicolon;
    procedure TestCaseIfOtherwiseNoSemicolon;
  end;

  TTestParserStatementRaise=class(TTestStatementParserBase)
    Procedure TestRaise;
    Procedure TestRaiseEmpty;
    Procedure TestRaiseAt;
  end;

  TTestParserStatementTry=class(TTestStatementParserBase)
    Procedure TestTryFinally;
    Procedure TestTryFinallyEmpty;
    Procedure TestTryFinallyNested;
    procedure TestTryExcept;
    procedure TestTryExceptNested;
    procedure TestTryExceptEmpty;
    Procedure TestTryExceptOn;
    Procedure TestTryExceptOn2;
    Procedure TestTryExceptOnElse;
    Procedure TestTryExceptOnIfElse;
    Procedure TestTryExceptOnElseNoSemicolo;
    procedure TestTryExceptRaise;
  end;

  TTestParserStatementAsm=class(TTestStatementParserBase)
    Procedure TestAsmBlock;
    Procedure TestAsmBlockWithEndLabel;
    Procedure TestAsmBlockInIfThen;
  end;

  TTestParserStatementSpecial=class(TTestStatementParserBase)
Procedure TestGotoInIfThen;
procedure TestAssignToAddress;
procedure TestFinalizationNoSemicolon;
procedure TestMacroComment;
Procedure TestPlatformIdentifier;
Procedure TestPlatformIdentifier2;
Procedure TestArgumentNameOn;
end;

implementation

{ TTestStatementParserBase }

procedure TTestStatementParserBase.SetUp;
begin
  inherited SetUp;
  FVariables:=TStringList.Create;
end;

procedure TTestStatementParserBase.TearDown;
begin
  FreeAndNil(FVariables);
  inherited TearDown;
end;

procedure TTestStatementParserBase.AddStatements(ASource: array of string);

Var
  I :Integer;
begin
  StartProgram(ExtractFileUnitName(MainFilename));
  if FVariables.Count>0 then
    begin
    For I:=0 to FVariables.Count-1 do
      Add('  '+Fvariables[I]);
    end;
  Add('static void Main(string[] args)');
  Add('{');
  For I:=Low(ASource) to High(ASource) do
    Add('  '+ASource[i]);
end;

procedure TTestStatementParserBase.DeclareVar(const AVarType: String;
  const AVarName: String);
begin
  FVariables.Add(AVarType+' '+AVarName+';');
end;

function TTestStatementParserBase.TestStatement(ASource: string): TCShImplElement;
begin
  Result:=TestStatement([ASource]);
end;

function TTestStatementParserBase.TestStatement(ASource: array of string
  ): TCShImplElement;


begin
  Result:=Nil;
  FStatement:=Nil;
  AddStatements(ASource);
  ParseModule;
  AssertEquals('Have Module',TCShModule,Module.ClassType);
  AssertNotNull('Class exists',Module.ImplementationSection.Declarations[0]);
  AssertEquals('Is Class',TCShClassType,TObject(Module.ImplementationSection.Declarations[0]).ClassType);
  FMainClass := TCshClassType(Module.ImplementationSection.Declarations[0]);
  AssertNotNull('Class exists',FMainClass.Members[0]);
  AssertEquals('Is Class',TCShFunction,TObject(FMainClass.Members[0]).ClassType);
  FMainProc := TCShFunction(FMainClass.Members[0]);
  Result:=FStatement;
end;

procedure TTestStatementParserBase.ExpectParserError(const Msg: string);
begin
  AssertException(Msg,EParserError,@ParseModule);
end;

procedure TTestStatementParserBase.ExpectParserError(const Msg: string;
  ASource: array of string);
begin
  AddStatements(ASource);
  ExpectParserError(Msg);
end;

function TTestStatementParserBase.AssertStatement(Msg: String; AClass: TClass;
  AIndex: Integer): TCShImplBlock;
begin
  AssertNotNull(Msg+' Have statement',MainProc.Body);
  AssertEquals(Msg+' statement class',AClass,TObject(MainProc.body.Statements.Elements[AIndex]).ClassType);
  Result:=TObject(MainProc.body.Statements) as TCShImplBlock;
end;

procedure TTestStatementParserBase.AssertImplElement(Msg: String;
  AClass: TClass; aStmt: TCShImplElement);
begin
  AssertNotNull(Msg+' Have statement',aStmt);
  AssertEquals(Msg+' statement class',AClass,aStmt.ClassType);
end;


procedure TTestParserStatementEmpty.TestEmpty;
begin
  //TestStatement(';');
  TestStatement('');
  AssertEquals('No statements',0,MainProc.body.Statements.Elements.Count);
end;

procedure TTestParserStatementEmpty.TestEmptyStatement;
begin
  TestStatement(';');
  AssertEquals('0 statement',0,MainProc.body.Statements.Elements.Count);
end;

procedure TTestParserStatementEmpty.TestEmptyStatements;
begin
  TestStatement(';;');
  AssertEquals('0 statement',0,MainProc.body.Statements.Elements.Count);
end;

procedure TTestParserStatementBlock.TestBlock;

Var
  B : TCShImplBeginBlock;

begin
  TestStatement(['{','}']);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertNotNull('Statement assigned',MainProc.body.Statements.Elements[0]);
  AssertEquals('Block statement',TCShImplBeginBlock,Statement.ClassType);
  B:= Statement as TCShImplBeginBlock;
  AssertEquals('Empty block',0,B.Elements.Count);
end;

procedure TTestParserStatementBlock.TestBlockComment;
Var
  B : TCShImplBeginBlock;

begin
  Engine.NeedComments:=True;
  TestStatement(['/* This is a comment */','{','}']);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertNotNull('Statement assigned',MainProc.body.Statements.Elements[0]);
  AssertEquals('Block statement',TCShImplBeginBlock,Statement.ClassType);
  B:= Statement as TCShImplBeginBlock;
  AssertEquals('Empty block',0,B.Elements.Count);
  AssertEquals('No DocComment','',B.DocComment);
end;

procedure TTestParserStatementBlock.TestBlock2Comments;
Var
  B : TCShImplBeginBlock;

begin
  Engine.NeedComments:=True;
  TestStatement(['{ This is a comment }','// Another comment','begin','end']);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertNotNull('Statement assigned',MainProc.body.Statements.Elements[0]);
  AssertEquals('Block statement',TCShImplBeginBlock,Statement.ClassType);
  B:= Statement as TCShImplBeginBlock;
  AssertEquals('Empty block',0,B.Elements.Count);
  AssertEquals('No DocComment','',B.DocComment);
end;

procedure TTestParserStatementAssignment.TestAssignment;

Var
  A : TCShImplAssign;

begin
  DeclareVar('integer');
  TestStatement(['a:=1;']);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Assignment statement',TCShImplAssign,Statement.ClassType);
  A:=Statement as TCShImplAssign;
  AssertEquals('Normal assignment',akDefault,A.Kind);
  AssertExpression('Right side is constant',A.Right,pekNumber,'1');
  AssertExpression('Left side is variable',A.Left,pekIdent,'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentAdd;

Var
  A : TCShImplAssign;

begin
  Parser.Scanner.Options:=[po_cassignments];
  DeclareVar('integer');
  TestStatement(['a+=1;']);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Assignment statement',TCShImplAssign,Statement.ClassType);
  A:=Statement as TCShImplAssign;
  AssertEquals('Add assignment',akAdd,A.Kind);
  AssertExpression('Right side is constant',A.Right,pekNumber,'1');
  AssertExpression('Left side is variable',A.Left,pekIdent,'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentMinus;
Var
  A : TCShImplAssign;

begin
  Parser.Scanner.Options:=[po_cassignments];
  DeclareVar('integer');
  TestStatement(['a-=1;']);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Assignment statement',TCShImplAssign,Statement.ClassType);
  A:=Statement as TCShImplAssign;
  AssertEquals('Minus assignment',akMinus,A.Kind);
  AssertExpression('Right side is constant',A.Right,pekNumber,'1');
  AssertExpression('Left side is variable',A.Left,pekIdent,'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentMul;
Var
  A : TCShImplAssign;

begin
  Parser.Scanner.Options:=[po_cassignments];
  DeclareVar('integer');
  TestStatement(['a*=1;']);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Assignment statement',TCShImplAssign,Statement.ClassType);
  A:=Statement as TCShImplAssign;
  AssertEquals('Mul assignment',akMul,A.Kind);
  AssertExpression('Right side is constant',A.Right,pekNumber,'1');
  AssertExpression('Left side is variable',A.Left,pekIdent,'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentDivision;
Var
  A : TCShImplAssign;

begin
  Parser.Scanner.Options:=[po_cassignments];
  DeclareVar('integer');
  TestStatement(['a/=1;']);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Assignment statement',TCShImplAssign,Statement.ClassType);
  A:=Statement as TCShImplAssign;
  AssertEquals('Division assignment',akDivision,A.Kind);
  AssertExpression('Right side is constant',A.Right,pekNumber,'1');
  AssertExpression('Left side is variable',A.Left,pekIdent,'a');
end;

procedure TTestParserStatementAssignment.TestAssignmentMissingSemicolonError;
begin
  DeclareVar('integer');
  ExpectParserError('Semicolon expected, but "a" found',['a:=1','a:=2']);
end;

procedure TTestParserStatementCall.TestCall;

Var
  S : TCShImplSimple;

begin
  TestStatement('Doit;');
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,Statement.ClassType);
  S:=Statement as TCShImplSimple;
  AssertExpression('Doit call',S.Expr,pekIdent,'Doit');
end;

procedure TTestParserStatementCall.TestCallComment;

Var
  S : TCShImplSimple;
begin
  Engine.NeedComments:=True;
  TestStatement(['//comment line','Doit;']);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,Statement.ClassType);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  S:=Statement as TCShImplSimple;
  AssertExpression('Doit call',S.Expr,pekIdent,'Doit');
  AssertEquals('No DocComment','',S.DocComment);
end;

procedure TTestParserStatementCall.TestCallQualified;

Var
  S : TCShImplSimple;
  B : TBinaryExpr;

begin
  TestStatement('Unita.Doit;');
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,Statement.ClassType);
  S:=Statement as TCShImplSimple;
  AssertExpression('Doit call',S.Expr,pekBinary,TBinaryExpr);
  B:=S.Expr as TBinaryExpr;
  TAssert.AssertSame('B.left.Parent=B',B,B.left.Parent);
  TAssert.AssertSame('B.right.Parent=B',B,B.right.Parent);
  AssertExpression('Unit name',B.Left,pekIdent,'Unita');
  AssertExpression('Doit call',B.Right,pekIdent,'Doit');
end;

procedure TTestParserStatementCall.TestCallQualified2;
Var
  S : TCShImplSimple;
  B : TBinaryExpr;

begin
  TestStatement('Unita.ClassB.Doit;');
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,Statement.ClassType);
  S:=Statement as TCShImplSimple;
  AssertExpression('Doit call',S.Expr,pekBinary,TBinaryExpr);
  B:=S.Expr as TBinaryExpr;
  AssertExpression('Doit call',B.Right,pekIdent,'Doit');
  AssertExpression('First two parts of unit name',B.left,pekBinary,TBinaryExpr);
  B:=B.left as TBinaryExpr;
  AssertExpression('Unit name part 1',B.Left,pekIdent,'Unita');
  AssertExpression('Unit name part 2',B.right,pekIdent,'ClassB');
end;

procedure TTestParserStatementCall.TestCallNoArgs;

Var
  S : TCShImplSimple;
  P : TParamsExpr;

begin
  TestStatement('Doit();');
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,Statement.ClassType);
  S:=Statement as TCShImplSimple;
  AssertExpression('Doit call',S.Expr,pekFuncParams,TParamsExpr);
  P:=S.Expr as TParamsExpr;
  AssertExpression('Correct function call name',P.Value,pekIdent,'Doit');
  AssertEquals('No params',0,Length(P.Params));
end;

procedure TTestParserStatementCall.TestCallOneArg;

Var
  S : TCShImplSimple;
  P : TParamsExpr;

begin
  TestStatement('Doit(1);');
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,Statement.ClassType);
  S:=Statement as TCShImplSimple;
  AssertExpression('Doit call',S.Expr,pekFuncParams,TParamsExpr);
  P:=S.Expr as TParamsExpr;
  AssertExpression('Correct function call name',P.Value,pekIdent,'Doit');
  AssertEquals('One param',1,Length(P.Params));
  AssertExpression('Parameter is constant',P.Params[0],pekNumber,'1');
end;

procedure TTestParserStatementCall.TestCallFormat(FN: String;
  AddPrecision: Boolean; AddSecondParam: boolean);
var
  P : TParamsExpr;

Var
  S : TCShImplSimple;
  N : String;
  ArgCnt: Integer;
begin
  N:=fn+'(a:3';
  if AddPrecision then
    N:=N+':2';
  ArgCnt:=1;
  if AddSecondParam then
    begin
    ArgCnt:=2;
    N:=N+',b:3';
    if AddPrecision then
      N:=N+':2';
    end;
  N:=N+');';
  TestStatement(N);
  AssertEquals('1 statement',1,MainProc.body.Statements.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,Statement.ClassType);
  S:=Statement as TCShImplSimple;
  AssertExpression('Doit call',S.Expr,pekFuncParams,TParamsExpr);
  P:=S.Expr as TParamsExpr;
  AssertExpression('Correct function call name',P.Value,pekIdent,FN);
  AssertEquals(IntToStr(ArgCnt)+' param',ArgCnt,Length(P.Params));
end;

procedure TTestParserStatementCall.TestCallWriteFormat1;

begin
  TestCallFormat('write',False);
end;

procedure TTestParserStatementCall.TestCallWriteFormat2;

begin
  TestCallFormat('write',True);
end;

procedure TTestParserStatementCall.TestCallWriteFormat3;
begin
  TestCallFormat('write',false,true);
end;

procedure TTestParserStatementCall.TestCallWriteFormat4;
begin
  TestCallFormat('write',true,true);
end;

procedure TTestParserStatementCall.TestCallWritelnFormat1;
begin
  TestCallFormat('writeln',False);
end;

procedure TTestParserStatementCall.TestCallWritelnFormat2;
begin
  TestCallFormat('writeln',True);
end;

procedure TTestParserStatementCall.TestCallStrFormat1;
begin
  TestCallFormat('str',False);
end;

procedure TTestParserStatementCall.TestCallStrFormat2;
begin
  TestCallFormat('str',True);
end;

procedure TTestParserStatementCall.DoTestCallOtherFormat;

begin
  TestCallFormat('nono',False);
end;

procedure TTestParserStatementCall.TestCallOtherFormat;

begin
  AssertException('Only Write(ln) and str allow format',EParserError,@DoTestCallOtherFormat);
end;

procedure TTestParserStatementIf.TestIf;

Var
  I : TCShImplIfElse;

begin
  DeclareVar('boolean');
  TestStatement(['if a then',';']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertNull('No else',i.ElseBranch);
  AssertNull('No if branch',I.IfBranch);
end;

procedure TTestParserStatementIf.TestIfBlock;

Var
  I : TCShImplIfElse;

begin
  DeclareVar('boolean');
  TestStatement(['if a then','  begin','  end']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertNull('No else',i.ElseBranch);
  AssertNotNull('if branch',I.IfBranch);
  AssertEquals('begin end block',TCShImplBeginBlock,I.ifBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfAssignment;

Var
  I : TCShImplIfElse;

begin
  DeclareVar('boolean');
  TestStatement(['if a then','  a:=False;']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertNull('No else',i.ElseBranch);
  AssertNotNull('if branch',I.IfBranch);
  AssertEquals('assignment statement',TCShImplAssign,I.ifBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfElse;

Var
  I : TCShImplIfElse;

begin
  DeclareVar('boolean');
  TestStatement(['if a then','  begin','  end','else',';']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertNull('No else',i.ElseBranch);
  AssertNotNull('if branch',I.IfBranch);
  AssertEquals('begin end block',TCShImplBeginBlock,I.ifBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfElseBlock;
Var
  I : TCShImplIfElse;

begin
  DeclareVar('boolean');
  TestStatement(['if a then','  begin','  end','else','  begin','  end']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertNotNull('if branch',I.IfBranch);
  AssertEquals('begin end block',TCShImplBeginBlock,I.ifBranch.ClassType);
  AssertNotNull('Else branch',i.ElseBranch);
  AssertEquals('begin end block',TCShImplBeginBlock,I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfElseInBlock;
Var
  B : TCShImplBeginBlock;
  I : TCShImplIfElse;

begin
  DeclareVar('boolean');
  TestStatement(['begin',
                 '  if a then',
                 '    DoA',
                 '  else',
                 'end']);

  B:=AssertStatement('begin block',TCShImplBeginBlock) as TCShImplBeginBlock;
  AssertEquals('One Element',1,B.Elements.Count);
  AssertEquals('If statement',TCShImplIfElse,TObject(B.Elements[0]).ClassType);
  I:=TCShImplIfElse(B.Elements[0]);
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertNotNull('if branch',I.IfBranch);
  AssertEquals('i_br: simple command',TCShImplSimple,I.ifBranch.ClassType);
  AssertExpression('Doit call',TCShImplSimple(I.ifBranch).Expr,pekIdent,'DoA');
  AssertNull('Else branch',i.ElseBranch);
end;

procedure TTestParserStatementIf.TestIfforElseBlock;

Var
  I : TCShImplIfElse;

begin
  TestStatement(['if a then','for X := 1 downto 0 do Writeln(X)','else', 'for X := 0 to 1 do Writeln(X)']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertEquals('For statement',TCShImplForLoop,I.ifBranch.ClassType);
  AssertEquals('For statement',TCShImplForLoop,I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfRaiseElseBlock;
Var
  I : TCShImplIfElse;
begin
  TestStatement(['if a then','raise','else', 'for X := 0 to 1 do Writeln(X)']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertEquals('For statement',TCShImplRaise,I.ifBranch.ClassType);
  AssertEquals('For statement',TCShImplForLoop,I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfWithBlock;
Var
  I : TCShImplIfElse;
begin
  TestStatement(['if a then','with b do something','else', 'for X := 0 to 1 do Writeln(X)']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertEquals('For statement',TCShImplUsing,I.ifBranch.ClassType);
  AssertEquals('For statement',TCShImplForLoop,I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestIfSemiColonElseError;

begin
  DeclareVar('boolean');
  ExpectParserError('No semicolon before else',['if a then','  begin','  end;','else','  begin','  end']);
end;

procedure TTestParserStatementIf.TestNestedIf;
Var
  I : TCShImplIfElse;
begin
  DeclareVar('boolean');
  DeclareVar('boolean','b');
  TestStatement(['if a then','  if b then','    begin','    end','else','  begin','  end']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertNotNull('if branch',I.IfBranch);
  AssertNull('Else branch',i.ElseBranch);
  AssertEquals('if in if branch',TCShImplIfElse,I.ifBranch.ClassType);
  I:=I.Ifbranch as TCShImplIfElse;
  AssertEquals('begin end block',TCShImplBeginBlock,I.ElseBranch.ClassType);

end;

procedure TTestParserStatementIf.TestNestedIfElse;

Var
  I : TCShImplIfElse;

begin
  DeclareVar('boolean');
  TestStatement(['if a then','  if b then','    begin','    end','  else','    begin','    end','else','  begin','end']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertNotNull('if branch',I.IfBranch);
  AssertNotNull('Else branch',i.ElseBranch);
  AssertEquals('begin end block',TCShImplBeginBlock,I.ElseBranch.ClassType);
  AssertEquals('if in if branch',TCShImplIfElse,I.ifBranch.ClassType);
  I:=I.Ifbranch as TCShImplIfElse;
  AssertEquals('begin end block',TCShImplBeginBlock,I.ElseBranch.ClassType);
end;

procedure TTestParserStatementIf.TestNestedIfElseElse;

// Bug ID 37760

Var
  I,I2 : TCShImplIfElse;

begin
  DeclareVar('boolean');
  TestStatement(['if a then',
                 '  if b then',
                 '    DoA ',
                 '   else',
                 ' else',
                 '   DoB']);
  I:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',I.ConditionExpr,pekIdent,'a');
  AssertNotNull('if branch',I.IfBranch);
  AssertNotNull('Have else for outer if',I.ElseBranch);
  AssertEquals('Have if in if branch',TCShImplIfElse,I.ifBranch.ClassType);
  I2:=I.Ifbranch as TCShImplIfElse;
  AssertExpression('IF condition',I2.ConditionExpr,pekIdent,'b');
  AssertNotNull('Have then for inner if',I2.ifBranch);
  AssertnotNull('Empty else for inner if',I2.ElseBranch);
  AssertEquals('Have a commend for inner if else',TCShImplCommand,I2.ElseBranch.ClassType);
  AssertEquals('... an empty command','',TCShImplCommand(I2.ElseBranch).Command);
end;

procedure TTestParserStatementIf.TestIfIfElseElseBlock;

var
  OuterIf,InnerIf: TCShImplIfElse;
begin
  DeclareVar('boolean');
  DeclareVar('boolean','B');
  TestStatement(['if a then','if b then','  begin','  end','else','else','  begin','  end']);
  OuterIf:=AssertStatement('If statement',TCShImplIfElse) as TCShImplIfElse;
  AssertExpression('IF condition',OuterIf.ConditionExpr,pekIdent,'a');
  AssertNotNull('if branch',OuterIf.IfBranch);
  AssertEquals('if else block',TCShImplIfElse,OuterIf.ifBranch.ClassType);
  InnerIf:=OuterIf.IfBranch as TCShImplIfElse;
  AssertExpression('IF condition',InnerIf.ConditionExpr,pekIdent,'b');
  AssertNotNull('if branch',InnerIf.IfBranch);
  AssertEquals('begin end block',TCShImplBeginBlock,InnerIf.ifBranch.ClassType);
  AssertNotNull('Else branch',InnerIf.ElseBranch);
  AssertEquals('empty statement',TCShImplCommand,InnerIf.ElseBranch.ClassType);
  AssertEquals('empty command','',TCShImplCommand(InnerIf.ElseBranch).Command);
  AssertNotNull('Else branch',OuterIf.ElseBranch);
  AssertEquals('begin end block',TCShImplBeginBlock,OuterIf.ElseBranch.ClassType);
end;


procedure TTestParserStatementLoops.TestWhile;

Var
  W : TCShImplWhile;

begin
  DeclareVar('boolean');
  TestStatement(['While a do ;']);
  W:=AssertStatement('While statement',TCShImplWhile) as TCShImplWhile;
  AssertExpression('While condition',W.ConditionExpr,pekIdent,'a');
  AssertNull('Empty body',W.Body);
end;

procedure TTestParserStatementLoops.TestWhileBlock;
Var
  W : TCShImplWhile;

begin
  DeclareVar('boolean');
  TestStatement(['While a do','  begin','  end']);
  W:=AssertStatement('While statement',TCShImplWhile) as TCShImplWhile;
  AssertExpression('While condition',W.ConditionExpr,pekIdent,'a');
  AssertNotNull('Have while body',W.Body);
  AssertEquals('begin end block',TCShImplBeginBlock,W.Body.ClassType);
  AssertEquals('Empty block',0,TCShImplBeginBlock(W.Body).ELements.Count);
end;

procedure TTestParserStatementLoops.TestWhileNested;

Var
  W : TCShImplWhile;

begin
  DeclareVar('boolean');
  DeclareVar('boolean','b');
  TestStatement(['While a do','  while b do','    begin','    end']);
  W:=AssertStatement('While statement',TCShImplWhile) as TCShImplWhile;
  AssertExpression('While condition',W.ConditionExpr,pekIdent,'a');
  AssertNotNull('Have while body',W.Body);
  AssertEquals('Nested while',TCShImplWhile,W.Body.ClassType);
  W:=W.Body as TCShImplWhile;
  AssertExpression('While condition',W.ConditionExpr,pekIdent,'b');
  AssertNotNull('Have nested while body',W.Body);
  AssertEquals('Nested begin end block',TCShImplBeginBlock,W.Body.ClassType);
  AssertEquals('Empty nested block',0,TCShImplBeginBlock(W.Body).ELements.Count);
end;

procedure TTestParserStatementLoops.TestRepeat;

Var
  R : TCShImplDoWhile;

begin
  DeclareVar('boolean');
  TestStatement(['Repeat','Until a;']);
  R:=AssertStatement('Repeat statement',TCShImplDoWhile) as TCShImplDoWhile;
  AssertExpression('repeat condition',R.ConditionExpr,pekIdent,'a');
  AssertEquals('Empty body',0,R.Elements.Count);
end;

procedure TTestParserStatementLoops.TestRepeatBlock;

Var
  R : TCShImplDoWhile;

begin
  DeclareVar('boolean');
  TestStatement(['Repeat','begin','end;','Until a;']);
  R:=AssertStatement('repeat statement',TCShImplDoWhile) as TCShImplDoWhile;
  AssertExpression('repeat condition',R.ConditionExpr,pekIdent,'a');
  AssertEquals('Have statement',1,R.Elements.Count);
  AssertEquals('begin end block',TCShImplBeginBlock,TObject(R.Elements[0]).ClassType);
  AssertEquals('Empty block',0,TCShImplBeginBlock(R.Elements[0]).ELements.Count);
end;

procedure TTestParserStatementLoops.TestRepeatBlockNosemicolon;

Var
  R : TCShImplDoWhile;

begin
  DeclareVar('boolean');
  TestStatement(['Repeat','begin','end','Until a;']);
  R:=AssertStatement('repeat statement',TCShImplDoWhile) as TCShImplDoWhile;
  AssertExpression('repeat condition',R.ConditionExpr,pekIdent,'a');
  AssertEquals('Have statement',1,R.Elements.Count);
  AssertEquals('begin end block',TCShImplBeginBlock,TObject(R.Elements[0]).ClassType);
  AssertEquals('Empty block',0,TCShImplBeginBlock(R.Elements[0]).ELements.Count);
end;

procedure TTestParserStatementLoops.TestRepeatNested;

Var
  R : TCShImplDoWhile;

begin
  DeclareVar('boolean');
  DeclareVar('boolean','b');
  TestStatement(['Repeat','repeat','begin','end','until b','Until a;']);
  R:=AssertStatement('repeat statement',TCShImplDoWhile) as TCShImplDoWhile;
  AssertExpression('repeat condition',R.ConditionExpr,pekIdent,'a');
  AssertEquals('Have statement',1,R.Elements.Count);
  AssertEquals('Nested repeat',TCShImplDoWhile,TObject(R.Elements[0]).ClassType);
  R:=TCShImplDoWhile(R.Elements[0]);
  AssertExpression('repeat condition',R.ConditionExpr,pekIdent,'b');
  AssertEquals('Have statement',1,R.Elements.Count);
  AssertEquals('begin end block',TCShImplBeginBlock,TObject(R.Elements[0]).ClassType);
  AssertEquals('Empty block',0,TCShImplBeginBlock(R.Elements[0]).ELements.Count);
end;

procedure TTestParserStatementLoops.TestFor;

Var
  F : TCShImplForLoop;

begin
  DeclareVar('integer');
  TestStatement(['For(a=1,a<10,a++)',';']);
  F:=AssertStatement('For statement',TCShImplForLoop) as TCShImplForLoop;
  AssertExpression('Loop variable name',F.IterExpesion,pekIdent,'a');
  AssertImplElement('Start value',TCShImplAssign,F.InitStatement);
  AssertImplElement('End value',TCShImplSimple,F.IncStatement);
  AssertNull('Empty body',F.Body);
end;

procedure TTestParserStatementLoops.TestForIn;

Var
  F : TCShImplForLoop;

begin
  DeclareVar('integer');
  TestStatement(['For a in SomeSet Do',';']);
  F:=AssertStatement('For statement',TCShImplForLoop) as TCShImplForLoop;
  AssertExpression('Loop variable name',F.IterExpesion,pekIdent,'a');
  AssertImplElement('Start value',TCShImplAssign,F.InitStatement);
  AssertImplElement('End value',TCShImplSimple,F.IncStatement);
  AssertNull('Empty body',F.Body);
end;

procedure TTestParserStatementLoops.TestForExpr;
Var
  F : TCShImplForLoop;
  B : TBinaryExpr;

begin
  DeclareVar('integer');
  TestStatement(['For a:=1+1 to 5+5 do',';']);
  F:=AssertStatement('For statement',TCShImplForLoop) as TCShImplForLoop;
  AssertExpression('Loop variable name',F.IterExpesion,pekIdent,'a');
  AssertImplElement('Start value',TCShImplAssign,F.InitStatement);
  AssertImplElement('End value',TCShImplSimple,F.IncStatement);
  AssertNull('Empty body',F.Body);
end;

procedure TTestParserStatementLoops.TestForBlock;

Var
  F : TCShImplForLoop;

begin
  DeclareVar('integer');
  TestStatement(['For a:=1 to 10 do','begin','end']);
  F:=AssertStatement('For statement',TCShImplForLoop) as TCShImplForLoop;
  AssertExpression('Loop variable name',F.IterExpesion,pekIdent,'a');
  AssertImplElement('Start value',TCShImplAssign,F.InitStatement);
  AssertImplElement('End value',TCShImplSimple,F.IncStatement);
  AssertNotNull('Have for body',F.Body);
  AssertEquals('begin end block',TCShImplBeginBlock,F.Body.ClassType);
  AssertEquals('Empty block',0,TCShImplBeginBlock(F.Body).ELements.Count);
end;

procedure TTestParserStatementLoops.TestDowntoBlock;

Var
  F : TCShImplForLoop;

begin
  DeclareVar('integer');
  TestStatement(['For a:=10 downto 1 do','begin','end']);
  F:=AssertStatement('For statement',TCShImplForLoop) as TCShImplForLoop;
  AssertExpression('Loop variable name',F.IterExpesion,pekIdent,'a');
  AssertImplElement('Start value',TCShImplAssign,F.InitStatement);
  AssertImplElement('End value',TCShImplSimple,F.IncStatement);
  AssertNotNull('Have for body',F.Body);
  AssertEquals('begin end block',TCShImplBeginBlock,F.Body.ClassType);
  AssertEquals('Empty block',0,TCShImplBeginBlock(F.Body).ELements.Count);
end;

procedure TTestParserStatementLoops.TestForNested;
Var
  F : TCShImplForLoop;

begin
  DeclareVar('integer');
  DeclareVar('integer','b');
  TestStatement(['For a:=1 to 10 do','For b:=11 to 20 do','begin','end']);
  F:=AssertStatement('For statement',TCShImplForLoop) as TCShImplForLoop;
  AssertExpression('Loop variable name',F.IterExpesion,pekIdent,'a');
  AssertImplElement('Start value',TCShImplAssign,F.InitStatement);
  AssertImplElement('End value',TCShImplSimple,F.IncStatement);
  AssertNotNull('Have while body',F.Body);
  AssertEquals('begin end block',TCShImplForLoop,F.Body.ClassType);
  F:=F.Body as TCShImplForLoop;
  AssertExpression('Loop variable name',F.IterExpesion,pekIdent,'a');
  AssertImplElement('Start value',TCShImplAssign,F.InitStatement);
  AssertImplElement('End value',TCShImplSimple,F.IncStatement);
  AssertNotNull('Have for body',F.Body);
  AssertEquals('begin end block',TCShImplBeginBlock,F.Body.ClassType);
  AssertEquals('Empty block',0,TCShImplBeginBlock(F.Body).ELements.Count);
end;

procedure TTestParserStatementWith.TestWith;

Var
  W : TCShImplUsing;

begin
  DeclareVar('record X,Y : Integer; end');
  TestStatement(['With a do','begin','end']);
  W:=AssertStatement('For statement',TCShImplUsing) as TCShImplUsing;
  AssertEquals('1 expression',1,W.Expressions.Count);
  AssertExpression('With identifier',TCShExpr(W.Expressions[0]),pekIdent,'a');
  AssertNotNull('Have with body',W.Body);
  AssertEquals('begin end block',TCShImplBeginBlock,W.Body.ClassType);
  AssertEquals('Empty block',0,TCShImplBeginBlock(W.Body).ELements.Count);
end;

procedure TTestParserStatementWith.TestWithMultiple;
Var
  W : TCShImplUsing;

begin
  DeclareVar('record X,Y : Integer; end');
  DeclareVar('record W,Z : Integer; end','b');
  TestStatement(['With a,b do','begin','end']);
  W:=AssertStatement('For statement',TCShImplUsing) as TCShImplUsing;
  AssertEquals('2 expressions',2,W.Expressions.Count);
  AssertExpression('With identifier 1',TCShExpr(W.Expressions[0]),pekIdent,'a');
  AssertExpression('With identifier 2',TCShExpr(W.Expressions[1]),pekIdent,'b');
  AssertNotNull('Have with body',W.Body);
  AssertEquals('begin end block',TCShImplBeginBlock,W.Body.ClassType);
  AssertEquals('Empty block',0,TCShImplBeginBlock(W.Body).ELements.Count);
end;

procedure TTestParserStatementCase.TestCaseEmpty;
begin
  DeclareVar('integer');
  AddStatements(['case a of','end;']);
  ExpectParserError('Empty case not allowed');
end;

procedure TTestParserStatementCase.TestCaseOneInteger;

Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;

begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : ;','end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertNull('No else branch',C.ElseBranch);
  AssertEquals('One case label',1,C.Elements.Count);
  AssertEquals('Correct case for case label',TCShImplCaseStatement,TCShElement(C.Elements[0]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('1 expression for case',1,S.Expressions.Count);
  AssertExpression('With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  AssertEquals('Empty case label statement',0,S.Elements.Count);
  AssertNull('Empty case label statement',S.Body);
end;

procedure TTestParserStatementCase.TestCaseTwoIntegers;

Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;

begin
  DeclareVar('integer');
  TestStatement(['case a of','1,2 : ;','end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertNull('No else branch',C.ElseBranch);
  AssertEquals('One case label',1,C.Elements.Count);
  AssertEquals('Correct case for case label',TCShImplCaseStatement,TCShElement(C.Elements[0]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('2 expressions for case',2,S.Expressions.Count);
  AssertExpression('With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  AssertExpression('With identifier 2',TCShExpr(S.Expressions[1]),pekNumber,'2');
  AssertEquals('Empty case label statement',0,S.Elements.Count);
  AssertNull('Empty case label statement',S.Body);
end;

procedure TTestParserStatementCase.TestCaseRange;
Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;

begin
  DeclareVar('integer');
  TestStatement(['case a of','1..3 : ;','end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertNull('No else branch',C.ElseBranch);
  AssertEquals('One case label',1,C.Elements.Count);
  AssertEquals('Correct case for case label',TCShImplCaseStatement,TCShElement(C.Elements[0]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('1 expression for case',1,S.Expressions.Count);
  AssertExpression('With identifier 1',TCShExpr(S.Expressions[0]),pekRange,TBinaryExpr);
  AssertEquals('Empty case label statement',0,S.Elements.Count);
  AssertNull('Empty case label statement',S.Body);
end;

procedure TTestParserStatementCase.TestCaseRangeSeparate;
Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;

begin
  DeclareVar('integer');
  TestStatement(['case a of','1..3,5 : ;','end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertNull('No else branch',C.ElseBranch);
  AssertEquals('One case label',1,C.Elements.Count);
  AssertEquals('Correct case for case label',TCShImplCaseStatement,TCShElement(C.Elements[0]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('2 expressions for case',2,S.Expressions.Count);
  AssertExpression('With identifier 1',TCShExpr(S.Expressions[0]),pekRange,TBinaryExpr);
  AssertExpression('With identifier 2',TCShExpr(S.Expressions[1]),pekNumber,'5');
  AssertEquals('Empty case label statement',0,S.Elements.Count);
  AssertNull('Empty case label statement',S.Body);
end;

procedure TTestParserStatementCase.TestCase2Cases;
Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;

begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : ;','2 : ;','end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertNull('No else branch',C.ElseBranch);
  AssertEquals('Two case labels',2,C.Elements.Count);
  AssertEquals('Correct case for case label 1',TCShImplCaseStatement,TCShElement(C.Elements[0]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('2 expressions for case 1',1,S.Expressions.Count);
  AssertExpression('Case 1 With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  AssertEquals('Empty case label statement 1',0,S.Elements.Count);
  AssertNull('Empty case label statement 1',S.Body);
  // Two
  AssertEquals('Correct case for case label 2',TCShImplCaseStatement,TCShElement(C.Elements[1]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[1]);
  AssertEquals('2 expressions for case 2',1,S.Expressions.Count);
  AssertExpression('Case 2 With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'2');
  AssertEquals('Empty case label statement 2',0,S.Elements.Count);
  AssertNull('Empty case label statement 2',S.Body);
end;

procedure TTestParserStatementCase.TestCaseBlock;

Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;
  B : TCShImplbeginBlock;

begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : begin end;','end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertNull('No else branch',C.ElseBranch);
  AssertEquals('Two case labels',1,C.Elements.Count);
  AssertEquals('Correct case for case label 1',TCShImplCaseStatement,TCShElement(C.Elements[0]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('2 expressions for case 1',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  AssertEquals('1 case label statement',1,S.Elements.Count);
  AssertEquals('Correct case for case label 1',TCShImplbeginBlock,TCShElement(S.Elements[0]).ClassType);
  B:=TCShImplbeginBlock(S.Elements[0]);
  AssertEquals('0 statements in block',0,B.Elements.Count);

end;

procedure TTestParserStatementCase.TestCaseElseBlockEmpty;

Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;
  B : TCShImplbeginBlock;

begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : begin end;','else',' end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertEquals('Two case labels',2,C.Elements.Count);
  AssertEquals('Correct case for case label 1',TCShImplCaseStatement,TCShElement(C.Elements[0]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('2 expressions for case 1',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  AssertEquals('1 case label statement',1,S.Elements.Count);
  AssertEquals('Correct case for case label 1',TCShImplbeginBlock,TCShElement(S.Elements[0]).ClassType);
  B:=TCShImplbeginBlock(S.Elements[0]);
  AssertEquals('0 statements in block',0,B.Elements.Count);
  AssertNotNull('Have else branch',C.ElseBranch);
  AssertEquals('Correct else branch class',TCShImplSwitchElse,C.ElseBranch.ClassType);
  AssertEquals('Zero statements ',0,TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementCase.TestCaseOtherwiseBlockEmpty;

Var
  C : TCShImplSwitch;
begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : begin end;','otherwise',' end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertNotNull('Have else branch',C.ElseBranch);
  AssertEquals('Correct else branch class',TCShImplSwitchElse,C.ElseBranch.ClassType);
  AssertEquals('Zero statements ',0,TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementCase.TestCaseElseBlockAssignment;
Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;
  B : TCShImplbeginBlock;

begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : begin end;','else','a:=1',' end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertEquals('Two case labels',2,C.Elements.Count);
  AssertEquals('Correct case for case label 1',TCShImplCaseStatement,TCShElement(C.Elements[0]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('2 expressions for case 1',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  AssertEquals('1 case label statement',1,S.Elements.Count);
  AssertEquals('Correct case for case label 1',TCShImplbeginBlock,TCShElement(S.Elements[0]).ClassType);
  B:=TCShImplbeginBlock(S.Elements[0]);
  AssertEquals('0 statements in block',0,B.Elements.Count);
  AssertNotNull('Have else branch',C.ElseBranch);
  AssertEquals('Correct else branch class',TCShImplSwitchElse,C.ElseBranch.ClassType);
  AssertEquals('1 statement in else branch ',1,TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementCase.TestCaseElseBlock2Assignments;

Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;
  B : TCShImplbeginBlock;

begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : begin end;','else','a:=1;','a:=32;',' end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertEquals('Two case labels',2,C.Elements.Count);
  AssertEquals('Correct case for case label 1',TCShImplCaseStatement,TCShElement(C.Elements[0]).ClassType);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('2 expressions for case 1',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  AssertEquals('1 case label statement',1,S.Elements.Count);
  AssertEquals('Correct case for case label 1',TCShImplbeginBlock,TCShElement(S.Elements[0]).ClassType);
  B:=TCShImplbeginBlock(S.Elements[0]);
  AssertEquals('0 statements in block',0,B.Elements.Count);
  AssertNotNull('Have else branch',C.ElseBranch);
  AssertEquals('Correct else branch class',TCShImplSwitchElse,C.ElseBranch.ClassType);
  AssertEquals('2 statements in else branch ',2,TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementCase.TestCaseIfCaseElse;

Var
  C : TCShImplSwitch;

begin
  DeclareVar('integer');
  DeclareVar('boolean','b');
  TestStatement(['case a of','1 : if b then',' begin end;','else',' end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertEquals('Two case labels',2,C.Elements.Count);
  AssertNotNull('Have else branch',C.ElseBranch);
  AssertEquals('Correct else branch class',TCShImplSwitchElse,C.ElseBranch.ClassType);
  AssertEquals('0 statement in else branch ',0,TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementCase.TestCaseIfElse;
Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;

begin
  DeclareVar('integer');
  DeclareVar('boolean','b');
  TestStatement(['case a of','1 : if b then',' begin end','else','begin','end',' end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertEquals('One case label',1,C.Elements.Count);
  AssertNull('Have no else branch',C.ElseBranch);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('2 expressions for case 1',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  AssertEquals('1 case label statement',1,S.Elements.Count);
  AssertEquals('If statement in case label 1',TCShImplIfElse,TCShElement(S.Elements[0]).ClassType);
  AssertNotNull('If statement has else block',TCShImplIfElse(S.Elements[0]).ElseBranch);
end;

procedure TTestParserStatementCase.TestCaseIfCaseElseElse;
Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;

begin
  DeclareVar('integer');
  DeclareVar('boolean','b');
  TestStatement(['case a of','1 : if b then',' begin end','else','else','DoElse',' end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertEquals('Two case labels',2,C.Elements.Count);
  AssertNotNull('Have an else branch',C.ElseBranch);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('2 expressions for case 1',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  AssertEquals('1 case label statement',1,S.Elements.Count);
  AssertEquals('If statement in case label 1',TCShImplIfElse,TCShElement(S.Elements[0]).ClassType);
  AssertNotNull('If statement has else block',TCShImplIfElse(S.Elements[0]).ElseBranch);
  AssertEquals('If statement has a commend as else block',TCShImplCommand,TCShImplIfElse(S.Elements[0]).ElseBranch.ClassType);
  AssertEquals('But ... an empty command','',TCShImplCommand(TCShImplIfElse(S.Elements[0]).ElseBranch).Command);
end;

procedure TTestParserStatementCase.TestCaseElseNoSemicolon;
Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;
begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : dosomething;','2 : dosomethingmore','else','a:=1;','end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertEquals('case label count',3,C.Elements.Count);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('case 1',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  S:=TCShImplCaseStatement(C.Elements[1]);
  AssertEquals('case 2',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'2');
  AssertEquals('third is else',TCShImplSwitchElse,TObject(C.Elements[2]).ClassType);
  AssertNotNull('Have else branch',C.ElseBranch);
  AssertEquals('Correct else branch class',TCShImplSwitchElse,C.ElseBranch.ClassType);
  AssertEquals('1 statements in else branch ',1,TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementCase.TestCaseIfElseNoSemicolon;
Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;
begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : dosomething;','2: if b then',' dosomething','else  dosomethingmore','else','a:=1;','end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertEquals('case label count',3,C.Elements.Count);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('case 1',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  S:=TCShImplCaseStatement(C.Elements[1]);
  AssertEquals('case 2',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'2');
  AssertEquals('third is else',TCShImplSwitchElse,TObject(C.Elements[2]).ClassType);
  AssertNotNull('Have else branch',C.ElseBranch);
  AssertEquals('Correct else branch class',TCShImplSwitchElse,C.ElseBranch.ClassType);
  AssertEquals('1 statements in else branch ',1,TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;

procedure TTestParserStatementCase.TestCaseIfOtherwiseNoSemicolon;
Var
  C : TCShImplSwitch;
  S : TCShImplCaseStatement;
begin
  DeclareVar('integer');
  TestStatement(['case a of','1 : dosomething;','2: if b then',' dosomething','else  dosomethingmore','otherwise','a:=1;','end;']);
  C:=AssertStatement('Case statement',TCShImplSwitch) as TCShImplSwitch;
  AssertNotNull('Have case expression',C.CaseExpr);
  AssertExpression('Case expression',C.CaseExpr,pekIdent,'a');
  AssertEquals('case label count',3,C.Elements.Count);
  S:=TCShImplCaseStatement(C.Elements[0]);
  AssertEquals('case 1',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'1');
  S:=TCShImplCaseStatement(C.Elements[1]);
  AssertEquals('case 2',1,S.Expressions.Count);
  AssertExpression('Case With identifier 1',TCShExpr(S.Expressions[0]),pekNumber,'2');
  AssertEquals('third is else',TCShImplSwitchElse,TObject(C.Elements[2]).ClassType);
  AssertNotNull('Have else branch',C.ElseBranch);
  AssertEquals('Correct else branch class',TCShImplSwitchElse,C.ElseBranch.ClassType);
  AssertEquals('1 statements in else branch ',1,TCShImplSwitchElse(C.ElseBranch).Elements.Count);
end;



procedure TTestParserStatementRaise.TestRaise;

Var
  R : TCShImplRaise;

begin
  DeclareVar('Exception');
  TestStatement('Raise A;');
  R:=AssertStatement('Raise statement',TCShImplRaise) as TCShImplRaise;
  AssertEquals(0,R.Elements.Count);
  AssertNotNull(R.ExceptObject);
  AssertNull(R.ExceptAddr);
  AssertExpression('Expression object',R.ExceptObject,pekIdent,'A');
end;

procedure TTestParserStatementRaise.TestRaiseEmpty;
Var
  R : TCShImplRaise;

begin
  TestStatement('Raise;');
  R:=AssertStatement('Raise statement',TCShImplRaise) as TCShImplRaise;
  AssertEquals(0,R.Elements.Count);
  AssertNull(R.ExceptObject);
  AssertNull(R.ExceptAddr);
end;

procedure TTestParserStatementRaise.TestRaiseAt;

Var
  R : TCShImplRaise;

begin
  DeclareVar('Exception');
  DeclareVar('Pointer','B');
  TestStatement('Raise A at B;');
  R:=AssertStatement('Raise statement',TCShImplRaise) as TCShImplRaise;
  AssertEquals(0,R.Elements.Count);
  AssertNotNull(R.ExceptObject);
  AssertNotNull(R.ExceptAddr);
  AssertExpression('Expression object',R.ExceptAddr,pekIdent,'B');
end;

procedure TTestParserStatementTry.TestTryFinally;

Var
  T : TCShImplTry;
  S : TCShImplSimple;
  F : TCShImplTryFinally;

begin
  TestStatement(['Try','  DoSomething;','finally','  DoSomethingElse','end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Finally statement',TCShImplTryFinally,T.FinallyExcept.ClassType);
  F:=TCShImplTryFinally(T.FinallyExcept);
  AssertEquals(1,F.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(F.Elements[0]).ClassType);
  S:=TCShImplSimple(F.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse');
end;

procedure TTestParserStatementTry.TestTryFinallyEmpty;
Var
  T : TCShImplTry;
  F : TCShImplTryFinally;

begin
  TestStatement(['Try','finally','end;']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(0,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertEquals('Finally statement',TCShImplTryFinally,T.FinallyExcept.ClassType);
  F:=TCShImplTryFinally(T.FinallyExcept);
  AssertEquals(0,F.Elements.Count);
end;

procedure TTestParserStatementTry.TestTryFinallyNested;
Var
  T : TCShImplTry;
  S : TCShImplSimple;
  F : TCShImplTryFinally;

begin
  TestStatement(['Try','  DoSomething1;','  Try','    DoSomething2;','  finally','    DoSomethingElse2','  end;','Finally','  DoSomethingElse1','end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(2,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething1');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Finally statement',TCShImplTryFinally,T.FinallyExcept.ClassType);
  F:=TCShImplTryFinally(T.FinallyExcept);
  AssertEquals(1,F.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(F.Elements[0]).ClassType);
  S:=TCShImplSimple(F.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse1');
  // inner statement
  AssertNotNull(T.Elements[1]);
  AssertEquals('Nested try statement',TCShImplTry,TCShElement(T.Elements[1]).ClassType);
  T:=TCShImplTry(T.Elements[1]);
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething2');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Finally statement',TCShImplTryFinally,T.FinallyExcept.ClassType);
  F:=TCShImplTryFinally(T.FinallyExcept);
  AssertEquals(1,F.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(F.Elements[0]).ClassType);
  S:=TCShImplSimple(F.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse2');
end;

procedure TTestParserStatementTry.TestTryExcept;

Var
  T : TCShImplTry;
  S : TCShImplSimple;
  E : TCShImplTryExcept;

begin
  TestStatement(['Try','  DoSomething;','except','  DoSomethingElse','end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Except statement',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(1,E.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(E.Elements[0]).ClassType);
  S:=TCShImplSimple(E.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse');
end;

procedure TTestParserStatementTry.TestTryExceptNested;
Var
  T : TCShImplTry;
  S : TCShImplSimple;
  E : TCShImplTryExcept;

begin
  TestStatement(['Try','  DoSomething1;','  try','    DoSomething2;','  except','    DoSomethingElse2','  end','except','  DoSomethingElse1','end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(2,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething1');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Except statement',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(1,E.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(E.Elements[0]).ClassType);
  S:=TCShImplSimple(E.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse1');
  AssertNotNull(T.Elements[1]);
  AssertEquals('Simple statement',TCShImplTry,TCShElement(T.Elements[1]).ClassType);
  T:=TCShImplTry(T.Elements[1]);
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement 2',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething2 call ',S.Expr,pekIdent,'DoSomething2');
  AssertEquals('Simple statement2',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Except statement2',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(1,E.Elements.Count);
  AssertEquals('Simple statement2',TCShImplSimple,TCShElement(E.Elements[0]).ClassType);
  S:=TCShImplSimple(E.Elements[0]);
  AssertExpression('DoSomethingElse2 call',S.Expr,pekIdent,'DoSomethingElse2');
end;

procedure TTestParserStatementTry.TestTryExceptEmpty;

Var
  T : TCShImplTry;
  E : TCShImplTryExcept;

begin
  TestStatement(['Try','except','end;']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(0,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertEquals('Except statement',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(0,E.Elements.Count);
end;

procedure TTestParserStatementTry.TestTryExceptOn;

Var
  T : TCShImplTry;
  S : TCShImplSimple;
  E : TCShImplTryExcept;
  O : TCShImplExceptOn;

begin
  TestStatement(['Try','  DoSomething;','except','On E : Exception do','DoSomethingElse;','end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Except statement',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(1,E.Elements.Count);
  AssertEquals('Except on handler',TCShImplExceptOn,TCShElement(E.Elements[0]).ClassType);
  O:=TCShImplExceptOn(E.Elements[0]);
  AssertEquals(1,O.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(O.Elements[0]).ClassType);
  AssertEquals('Exception Variable name','E',O.VariableName);
  AssertEquals('Exception Type name','Exception',O.TypeName);
  S:=TCShImplSimple(O.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse');
//  AssertEquals('Variable name',

end;

procedure TTestParserStatementTry.TestTryExceptOn2;

Var
  T : TCShImplTry;
  S : TCShImplSimple;
  E : TCShImplTryExcept;
  O : TCShImplExceptOn;

begin
  TestStatement(['Try','  DoSomething;','except',
                 'On E : Exception do','DoSomethingElse;',
                 'On Y : Exception2 do','DoSomethingElse2;',
                 'end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Except statement',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(2,E.Elements.Count);
  // Exception handler 1
  AssertEquals('Except on handler',TCShImplExceptOn,TCShElement(E.Elements[0]).ClassType);
  O:=TCShImplExceptOn(E.Elements[0]);
  AssertEquals(1,O.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(O.Elements[0]).ClassType);
  AssertEquals('Exception Variable name','E',O.VariableName);
  AssertEquals('Exception Type name','Exception',O.TypeName);
  S:=TCShImplSimple(O.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse');
  // Exception handler 2
  AssertEquals('Except on handler',TCShImplExceptOn,TCShElement(E.Elements[1]).ClassType);
  O:=TCShImplExceptOn(E.Elements[1]);
  AssertEquals(1,O.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(O.Elements[0]).ClassType);
  AssertEquals('Exception Variable name','Y',O.VariableName);
  AssertEquals('Exception Type name','Exception2',O.TypeName);
  S:=TCShImplSimple(O.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse2');
end;

procedure TTestParserStatementTry.TestTryExceptOnElse;
Var
  T : TCShImplTry;
  S : TCShImplSimple;
  E : TCShImplTryExcept;
  O : TCShImplExceptOn;
  EE : TCShImplTryExceptElse;
  I : TCShImplIfElse;

begin
  DeclareVar('Boolean','b');
  // Check that Else belongs to Except, not to IF

  TestStatement(['Try','  DoSomething;','except','On E : Exception do','if b then','DoSomethingElse;','else','DoSomethingMore;','end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNotNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Except statement',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(1,E.Elements.Count);
  AssertEquals('Except on handler',TCShImplExceptOn,TCShElement(E.Elements[0]).ClassType);
  O:=TCShImplExceptOn(E.Elements[0]);
  AssertEquals('Exception Variable name','E',O.VariableName);
  AssertEquals('Exception Type name','Exception',O.TypeName);
  AssertEquals(1,O.Elements.Count);
  AssertEquals('Simple statement',TCShImplIfElse,TCShElement(O.Elements[0]).ClassType);
  I:=TCShImplIfElse(O.Elements[0]);
  AssertEquals(1,I.Elements.Count);
  AssertNull('No else barcnh for if',I.ElseBranch);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(I.Elements[0]).ClassType);
  S:=TCShImplSimple(I.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse');
  AssertEquals('Except Else statement',TCShImplTryExceptElse,T.ElseBranch.ClassType);
  EE:=TCShImplTryExceptElse(T.ElseBranch);
  AssertEquals(1,EE.Elements.Count);
  AssertNotNull(EE.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(EE.Elements[0]).ClassType);
  S:=TCShImplSimple(EE.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomethingMore');
end;

procedure TTestParserStatementTry.TestTryExceptOnIfElse;
Var
  T : TCShImplTry;
  S : TCShImplSimple;
  E : TCShImplTryExcept;
  O : TCShImplExceptOn;
  EE : TCShImplTryExceptElse;

begin
  TestStatement(['Try','  DoSomething;','except','On E : Exception do','DoSomethingElse;','else','DoSomethingMore;','end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNotNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Except statement',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(1,E.Elements.Count);
  AssertEquals('Except on handler',TCShImplExceptOn,TCShElement(E.Elements[0]).ClassType);
  O:=TCShImplExceptOn(E.Elements[0]);
  AssertEquals('Exception Variable name','E',O.VariableName);
  AssertEquals('Exception Type name','Exception',O.TypeName);
  AssertEquals(1,O.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(O.Elements[0]).ClassType);
  S:=TCShImplSimple(O.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse');
  AssertEquals('Except Else statement',TCShImplTryExceptElse,T.ElseBranch.ClassType);
  EE:=TCShImplTryExceptElse(T.ElseBranch);
  AssertEquals(1,EE.Elements.Count);
  AssertNotNull(EE.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(EE.Elements[0]).ClassType);
  S:=TCShImplSimple(EE.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomethingMore');
end;

procedure TTestParserStatementTry.TestTryExceptOnElseNoSemicolo;
Var
  T : TCShImplTry;
  S : TCShImplSimple;
  E : TCShImplTryExcept;
  O : TCShImplExceptOn;
  EE : TCShImplTryExceptElse;
begin
  TestStatement(['Try','  DoSomething;','except','On E : Exception do','DoSomethingElse','else','DoSomethingMore','end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNotNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Except statement',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(1,E.Elements.Count);
  AssertEquals('Except on handler',TCShImplExceptOn,TCShElement(E.Elements[0]).ClassType);
  O:=TCShImplExceptOn(E.Elements[0]);
  AssertEquals('Exception Variable name','E',O.VariableName);
  AssertEquals('Exception Type name','Exception',O.TypeName);
  AssertEquals(1,O.Elements.Count);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(O.Elements[0]).ClassType);
  S:=TCShImplSimple(O.Elements[0]);
  AssertExpression('DoSomethingElse call',S.Expr,pekIdent,'DoSomethingElse');
  AssertEquals('Except Else statement',TCShImplTryExceptElse,T.ElseBranch.ClassType);
  EE:=TCShImplTryExceptElse(T.ElseBranch);
  AssertEquals(1,EE.Elements.Count);
  AssertNotNull(EE.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(EE.Elements[0]).ClassType);
  S:=TCShImplSimple(EE.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomethingMore');
end;

procedure TTestParserStatementTry.TestTryExceptRaise;
Var
  T : TCShImplTry;
  S : TCShImplSimple;
  E : TCShImplTryExcept;

begin
  TestStatement(['Try','  DoSomething;','except','  raise','end']);
  T:=AssertStatement('Try statement',TCShImplTry) as TCShImplTry;
  AssertEquals(1,T.Elements.Count);
  AssertNotNull(T.FinallyExcept);
  AssertNull(T.ElseBranch);
  AssertNotNull(T.Elements[0]);
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  S:=TCShImplSimple(T.Elements[0]);
  AssertExpression('DoSomething call',S.Expr,pekIdent,'DoSomething');
  AssertEquals('Simple statement',TCShImplSimple,TCShElement(T.Elements[0]).ClassType);
  AssertEquals('Except statement',TCShImplTryExcept,T.FinallyExcept.ClassType);
  E:=TCShImplTryExcept(T.FinallyExcept);
  AssertEquals(1,E.Elements.Count);
  AssertEquals('Raise statement',TCShImplRaise,TCShElement(E.Elements[0]).ClassType);
end;

procedure TTestParserStatementAsm.TestAsmBlock;
begin
  Source.Add('{$MODE DELPHI}');
  Source.Add('function BitsHighest(X: Cardinal): Integer;');
  Source.Add('asm');
  Source.Add('end;');
  Source.Add('begin');
  Source.Add('end.');
  ParseModule;
end;

procedure TTestParserStatementAsm.TestAsmBlockWithEndLabel;
begin
  Source.Add('{$MODE DELPHI}');
  Source.Add('function BitsHighest(X: Cardinal): Integer;');
  Source.Add('asm');
  Source.Add('  MOV ECX, EAX');
  Source.Add('  MOV EAX, -1');
  Source.Add('  BSR EAX, ECX');
  Source.Add('  JNZ @@End');
  Source.Add('  MOV EAX, -1');
  Source.Add('@@End:');
  Source.Add('end;');
  Source.Add('begin');
  Source.Add('end.');
  ParseModule;
end;

procedure TTestParserStatementAsm.TestAsmBlockInIfThen;
begin
  Source.Add('{$MODE DELPHI}');
  Source.Add('function Get8087StatusWord(ClearExceptions: Boolean): Word;');
  Source.Add('  begin');
  Source.Add('    if ClearExceptions then');
  Source.Add('    asm');
  Source.Add('    end');
  Source.Add('    else');
  Source.Add('    asm');
  Source.Add('    end;');
  Source.Add('  end;');
  Source.Add('  begin');
  Source.Add('  end.');
  ParseModule;
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
  AddStatements(['{$MACRO ON}',
  '{$DEFINE func := //}',
  '  calltest;',
  '  func (''1'',''2'',''3'');',
  'CallTest2;'
  ]);
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
  AddStatements([
  '{$goto on}',
  'if expr then',
  '  dosomething',
  '   else if expr2 then',
  '    goto try_qword',
  '  else',
  '    dosomething;',
  '  try_qword:',
  '  dosomething;']);
  ParseModule;
end;

initialization
  RegisterTests('TCShTestParserStatements',[TTestParserStatementEmpty,
  TTestParserStatementBlock,TTestParserStatementAssignment]);

end.

