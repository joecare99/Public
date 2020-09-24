unit tst_CShScanner;

{ Adapted the tcScanner.pp for my CShScanner }

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, typinfo, fpcunit, testregistry, CShScanner;

type

    { TTestTokenFinder }

    TTestTokenFinder = class(TTestCase)
    published
        procedure TestFind;
    end;

    { TTestStreamLineReader }


    TTestStreamLineReader = class(TTestCase)
    private
        FReader: TStreamLineReader;
    protected
        procedure NewSource(const Source: string);
        procedure TestLine(const ALine: string; ExpectEOF: boolean = True);
        procedure TearDown; override;
    published
        procedure TestCreate;
        procedure TestEOF;
        procedure TestEmptyLine;
        procedure TestEmptyLineCR;
        procedure TestEmptyLineLF;
        procedure TestEmptyLineCRLF;
        procedure TestEmptyLineLFCR;
        procedure TestOneLine;
        procedure TestTwoLines;
    end;

    { TTestingCSharpScanner }

    TTestingCSharpScanner = class(TCSharpScanner)
    private
        FDoSpecial: boolean;
    protected
        function HandleMacro(AIndex: integer): TToken; override;
    public
        property DoSpecial: boolean read FDoSpecial write FDoSpecial;
    end;

    { TTestCShScanner }
    TTestCShScanner = class(TTestCase)
    private
        FLI: string;
        FScanner: TCSharpScanner;
        FResolver: TStreamResolver;
        FDoCommentCalled: boolean;
        FComment: string;
    protected
        procedure DoComment(Sender: TObject; aComment: string);
        procedure SetUp; override;
        procedure TearDown; override;
        function TokenToString(tk: TToken): string;
        procedure AssertEquals(Msg: string; Expected, Actual: TToken); overload;
        procedure AssertEquals(Msg: string; Expected, Actual: TModeSwitch); overload;
        procedure AssertEquals(Msg: string; Expected, Actual: TModeSwitches); overload;
        procedure NewSource(const Source: string; DoClear: boolean = True);
        procedure DoTestToken(t: TToken; const ASource: string;
            const CheckEOF: boolean = True);
        procedure TestToken(t: TToken; const ASource: string;
            const CheckEOF: boolean = True);
        procedure TestTokens(t: array of TToken; const ASource: string;
            const CheckEOF: boolean = True; const DoClear: boolean = True);
        property LastIDentifier: string read FLI write FLi;
        property Scanner: TCSharpScanner read FScanner;
    published
        procedure TestEmpty;
        procedure TestEOF;
        procedure TestWhitespace;
        procedure TestLineEnding2;
        procedure TestLineEnding3;
        procedure TestComment1;
        procedure TestComment2;
        procedure TestComment3;
        procedure TestComment4;
        procedure TestComment5;
        procedure TestComment6;
        procedure TestComment7;
        procedure TestComment8;
        procedure TestComment9;
        procedure TestNestedComment1;
        procedure TestNestedComment2;
        procedure TestNestedComment3;
        procedure TestNestedComment4;
        procedure TestNestedComment5;
        procedure TestonComment;
        procedure TestIdentifier;
        procedure TestThis;
        procedure TestStringConst;
        procedure TestNumber;
        procedure TestCharacter;
        procedure TestCharString;
        procedure TestBraceOpen;
        procedure TestBraceClose;
        procedure TestMul;
        procedure TestPlus;
        procedure TestComma;
        procedure TestMinus;
        procedure TestDot;
        procedure TestDivision;
        procedure TestColon;
        procedure TestSemicolon;
        procedure TestLessThan;
        procedure TestEqual;
        procedure TestGreaterThan;
        procedure TestDoubleOr;
        procedure TestOr;
        procedure TestShlC;
        procedure TestShrC;
        procedure TestAt;
        procedure TestSquaredBraceOpen;
        procedure TestSquaredBraceClose;
        procedure TestCaret;
        procedure TestBackslash;
        procedure TestDotDot;
        procedure TestAssign;
        procedure TestAssignPlus;
        procedure TestAssignMinus;
        procedure TestAssignMul;
        procedure TestAssignDivision;
        procedure TestNotEqual;
        procedure TestLessEqualThan;
        procedure TestGreaterEqualThan;
        procedure TestPower;
        procedure TestSymmetricalDifference;
        procedure TestAbstract;
        procedure TestAs;
        procedure TestBase;
        procedure TestBool;

        procedure TestBreak;
        procedure TestByte;
        procedure TestCase;
        procedure TestCatch;

        procedure TestChar;
        procedure TestChecked;
        procedure TestClass;
        procedure TestConst;

        procedure TestContinue;
        procedure TestDecimal;
        procedure TestDefault;
        procedure TestDelegate;

        procedure TestDo;
        procedure TestDouble;
        procedure TestElse;
        procedure TestEnum;

        procedure TestEvent;
        procedure TestExplicit;
        procedure TestExtern;
        procedure TestFalse;

        procedure TestFinally;
        procedure TestFixed;
        procedure TestFloat;
        procedure TestFor;

        procedure TestForeach;
        procedure TestGoto;
        procedure TestIf;
        procedure TestImplicit;

        procedure TestIn;
        procedure TestInt;
        procedure TestInterface;
        procedure TestInternal;

        procedure TestIs;
        procedure TestLock;
        procedure TestLong;
        procedure TestNamespace;

        procedure TestNew;
        procedure TestNull;
        procedure TestObject;
        procedure TestOperator;

        procedure TestOut;
        procedure TestOverride;
        procedure TestParams;
        procedure TestPrivate;

        procedure TestProtected;
        procedure TestPublic;
        procedure TestReadonly;
        procedure TestRef;

        procedure TestReturn;
        procedure TestSbyte;
        procedure TestSealed;
        procedure TestShort;

        procedure TestSizeof;
        procedure TestStackalloc;
        procedure TestStatic;
        procedure TestString;

        procedure TestStruct;
        procedure TestSwitch;
        //procedure TestThis;
        procedure TestThrow;

        procedure TestTrue;
        procedure TestTry;
        procedure TestTypeof;
        procedure TestUint;

        procedure TestUlong;
        procedure TestUnchecked;
        procedure TestUnsafe;
        procedure TestUshort;

        procedure TestUsing;
        procedure TestVirtual;
        procedure TestVoid;
        procedure TestVolatile;

        procedure TestWhile;

        procedure TestLineEnding;
        procedure TestTab;

        procedure TestObjCProtocol2;
        procedure TestObjCCategory2;

        procedure TestEscapedKeyWord;
        procedure TestTokenSeries;
        procedure TestTokenSeriesNoWhiteSpace;
        procedure TestTokenSeriesComments;
        procedure TestTokenSeriesNoComments;

        procedure TestDefine0;
        procedure TestDefine0Spaces;
        procedure TestDefine0Spaces2;
        procedure TestDefine01;
        procedure TestDefine1;
        procedure TestDefine2;
        procedure TestDefine21;
        procedure TestDefine22;
        procedure TestDefine3;
        procedure TestDefine4;
        procedure TestDefine5;
        procedure TestDefine6;
        procedure TestDefine7;
        procedure TestDefine8;
        procedure TestDefine9;
        procedure TestDefine10;
        procedure TestDefine11;
        procedure TestDefine12;
        procedure TestDefine13;
        procedure TestDefine14;
        procedure TestInclude;
        procedure TestInclude2;
        procedure TestUnDefine1;
        procedure TestIFDefined;
        procedure TestIFUnDefined;
        procedure TestIFAnd;
        procedure TestIFAndShortEval;
        procedure TestIFOr;
        procedure TestIFOrShortEval;
        procedure TestIFXor;
        procedure TestIFAndOr;
        procedure TestIFDefinedElseIf;
        procedure TestIfError;
        procedure TestModeSwitch;
        procedure TestOperatorIdentifier;
        procedure TestUTF8BOM;
        procedure TestBooleanSwitch;
    end;

implementation

{ TTestingCSharpScanner }

function TTestingCSharpScanner.HandleMacro(AIndex: integer): TToken;
begin
    if DoSpecial then
      begin
        Result := tkIdentifier;
        SetCurTokenstring('somethingweird');
      end
    else
        Result := inherited HandleMacro(AIndex);
end;

{ TTestTokenFinder }

procedure TTestTokenFinder.TestFind;

var
    tk, tkr: TToken;
    S: string;
    B: boolean;

begin
    for tk := tkAbstract to high(TToken) do
      begin
        S := tokenInfos[tk];
        B := IsNamedToken(S, tkr);
        AssertEquals('Token ' + S + ' is a token', True, B);
        AssertEquals('Token ' + S + ' returns correct token', Ord(tk), Ord(tkr));
      end;
end;

{ TTestStreamLineReader }

procedure TTestStreamLineReader.NewSource(const Source: string);
begin
    FReader := TStringStreamLineReader.Create('afile', Source);
end;

procedure TTestStreamLineReader.TestLine(const ALine: string; ExpectEOF: boolean);
begin
    AssertNotNull('Have reader', FReader);
    AssertEquals('Reading source line', ALine, FReader.ReadLine);
    if ExpectEOF then
        AssertEquals('End of file reached', True, FReader.IsEOF);
end;

procedure TTestStreamLineReader.TearDown;
begin
    inherited TearDown;
    if Assigned(FReader) then
        FreeAndNil(Freader);
end;

procedure TTestStreamLineReader.TestCreate;
begin
    FReader := TStreamLineReader.Create('afile');
    AssertEquals('Correct filename', 'afile', FReader.FileName);
    AssertEquals('Initially empty', True, FReader.isEOF);
end;

procedure TTestStreamLineReader.TestEOF;
begin
    NewSource('');
    AssertEquals('Empty stream', True, FReader.IsEOF);
end;

procedure TTestStreamLineReader.TestEmptyLine;
begin
    NewSource('');
    TestLine('');
end;

procedure TTestStreamLineReader.TestEmptyLineCR;
begin
    NewSource(#13);
    TestLine('');
end;

procedure TTestStreamLineReader.TestEmptyLineLF;
begin
    NewSource(#10);
    TestLine('');
end;

procedure TTestStreamLineReader.TestEmptyLineCRLF;
begin
    NewSource(#13#10);
    TestLine('');
end;

procedure TTestStreamLineReader.TestEmptyLineLFCR;
begin
    NewSource(#10#13);
    TestLine('', False);
    TestLine('');
end;

procedure TTestStreamLineReader.TestOneLine;

const
    S = 'a line with text';
begin
    NewSource(S);
    TestLine(S);
end;

procedure TTestStreamLineReader.TestTwoLines;
const
    S = 'a line with text';
begin
    NewSource(S + sLineBreak + S);
    TestLine(S, False);
    TestLine(S);
end;

{ ---------------------------------------------------------------------
  TTestCShScanner
  ---------------------------------------------------------------------}

procedure TTestCShScanner.DoComment(Sender: TObject; aComment: string);
begin
    FDoCommentCalled := True;
    FComment := aComment;
end;

procedure TTestCShScanner.SetUp;
begin
    FDoCommentCalled := False;
    FResolver := TStreamResolver.Create;
    FResolver.OwnsStreams := True;
    FScanner := TTestingCSharpScanner.Create(FResolver);
    // Do nothing
end;

procedure TTestCShScanner.TearDown;
begin
    FreeAndNil(FScanner);
    FreeAndNil(FResolver);
end;

function TTestCShScanner.TokenToString(tk: TToken): string;
begin
    Result := GetEnumName(TypeInfo(TToken), Ord(tk));
end;

procedure TTestCShScanner.AssertEquals(Msg: string; Expected, Actual: TToken);
begin
    AssertEquals(Msg, TokenToString(Expected), TokenToString(Actual));
end;

procedure TTestCShScanner.AssertEquals(Msg: string; Expected, Actual: TModeSwitch);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TModeSwitch), Ord(Expected)),
        GetEnumName(TypeInfo(TModeSwitch), Ord(Actual)));
end;

procedure TTestCShScanner.AssertEquals(Msg: string; Expected, Actual: TModeSwitches);

    function ToString(S: TModeSwitches): string;

    var
        M: TModeSwitch;

    begin
        Result := '';
        for M in TModeswitch do
            if M in S then
              begin
                if (Result <> '') then
                    Result := Result + ', ';
                Result := Result + GetEnumName(TypeInfo(TModeSwitch), Ord(M));
              end;
    end;

begin
    AssertEquals(Msg, ToString(Expected), ToString(Actual));
end;

procedure TTestCShScanner.NewSource(const Source: string; DoClear: boolean = True);
begin
    if DoClear then
        FResolver.Clear;
    FResolver.AddStream('afile.cs', TStringStream.Create(Source));
  {$ifndef NOCONSOLE}// JC: To get the tests to run with GUI
    Writeln('// ' + TestName);
    Writeln(Source);
  {$else}

  {$EndIf}
    //  FreeAndNil(FScanner);
    //  FScanner:=TTestingPascalScanner.Create(FResolver);
    FScanner.OpenFile('afile.cs');
end;

procedure TTestCShScanner.DoTestToken(t: TToken; const ASource: string;
    const CheckEOF: boolean);

var
    tk: ttoken;

begin
    NewSource(ASource);
    tk := FScanner.FetchToken;
    AssertEquals('Read token equals expected token.', t, tk);
    if CheckEOF then
      begin
        tk := FScanner.FetchToken;
        if (tk = tkLineEnding) and not (t in [tkEOF, tkLineEnding]) then
            tk := FScanner.FetchToken;
        AssertEquals('EOF reached.', tkEOF, FScanner.FetchToken);
      end;
end;

procedure TTestCShScanner.TestToken(t: TToken; const ASource: string;
    const CheckEOF: boolean);
var
    S: string;
begin
    DoTestToken(t, ASource);
    if (ASource <> '') then
      begin
        S := ASource;
        S[1] := Upcase(S[1]);
        DoTestToken(t, S);
      end;
    DoTestToken(t, UpperCase(ASource));
    DoTestToken(t, LowerCase(ASource), CheckEOF);
end;

procedure TTestCShScanner.TestTokens(t: array of TToken; const ASource: string;
    const CheckEOF: boolean; const DoClear: boolean);
var
    tk: ttoken;
    i: integer;

begin
    NewSource(ASource, DoClear);
    for I := Low(t) to High(t) do
      begin
        tk := FScanner.FetchToken;
        AssertEquals(Format('Read token %d equals expected token.', [i]), t[i], tk);
        if tk = tkIdentifier then
            LastIdentifier := FScanner.CurtokenString;
      end;
    if CheckEOF then
      begin
        tk := FScanner.FetchToken;
        if (tk = tkLineEnding) then
            tk := FScanner.FetchToken;
        AssertEquals('EOF reached.', tkEOF, FScanner.FetchToken);
      end;
end;

procedure TTestCShScanner.TestEmpty;
begin
    AssertNotNull('Have Scanner', Scanner);
    AssertTrue('Options is empty', [] = Scanner.Options);
    // Todo:  AssertEquals('FPC modes is default',ModeSwitches,Scanner.CurrentModeSwitches);
end;

procedure TTestCShScanner.TestEOF;
begin
    TestToken(tkEOF, '');
end;

procedure TTestCShScanner.TestWhitespace;

begin
    TestToken(tkWhitespace, ' ');
    TestToken(tkWhitespace, ' ');
end;


procedure TTestCShScanner.TestComment1;

begin
    TestToken(tkComment, '{ comment }');
end;


procedure TTestCShScanner.TestComment2;

begin
    TestToken(tkComment, '(* comment *)');
end;


procedure TTestCShScanner.TestComment3;

begin
    TestToken(tkComment, '//');
end;

procedure TTestCShScanner.TestComment4;

begin
    DoTestToken(tkComment, '(* abc *)', False);
    AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment5;

begin
    DoTestToken(tkComment, '(* abc' + LineEnding + 'def *)', False);
    AssertEquals('Correct comment', ' abc' + LineEnding + 'def ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment6;

begin
    DoTestToken(tkComment, '{ abc }', False);
    AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment7;

begin
    DoTestToken(tkComment, '{ abc' + LineEnding + 'def }', False);
    AssertEquals('Correct comment', ' abc' + LineEnding + 'def ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment8;

begin
    DoTestToken(tkComment, '// abc ', False);
    AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment9;

begin
    DoTestToken(tkComment, '// abc ' + LineEnding, False);
    AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestNestedComment1;
begin
    TestToken(tkComment, '// { comment } ');
end;

procedure TTestCShScanner.TestNestedComment2;
begin
    TestToken(tkComment, '(* { comment } *)');
end;

procedure TTestCShScanner.TestNestedComment3;
begin
    TestToken(tkComment, '{ { comment } }');
end;

procedure TTestCShScanner.TestNestedComment4;
begin
    TestToken(tkComment, '{ (* comment *) }');
end;

procedure TTestCShScanner.TestNestedComment5;
begin
    TestToken(tkComment, '(* (* comment *) *)');
end;

procedure TTestCShScanner.TestonComment;
begin
    FScanner.OnComment := @DoComment;
    DoTestToken(tkComment, '(* abc *)', False);
    assertTrue('Comment called', FDoCommentCalled);
    AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
    AssertEquals('Correct comment token', ' abc ', FComment);
end;


procedure TTestCShScanner.TestIdentifier;

begin
    TestToken(tkIdentifier, 'identifier');
end;


procedure TTestCShScanner.TestStringConst;

begin
    TestToken(CShScanner.tkString, '''A string''');
end;

procedure TTestCShScanner.TestCharString;

begin
    TestToken(CShScanner.tkChar, '''A''');
end;

procedure TTestCShScanner.TestNumber;

begin
    TestToken(tkNumber, '123');
end;


procedure TTestCShScanner.TestCharacter;

begin
    TestToken(CShScanner.tkCharacter, '#65 ', False);
end;


procedure TTestCShScanner.TestBraceOpen;

begin
    TestToken(tkBraceOpen, '(');
end;


procedure TTestCShScanner.TestBraceClose;

begin
    TestToken(tkBraceClose, ')');
end;


procedure TTestCShScanner.TestMul;

begin
    TestToken(tkMul, '*');
end;


procedure TTestCShScanner.TestPlus;

begin
    TestToken(tkPlus, '+');
end;


procedure TTestCShScanner.TestComma;

begin
    TestToken(tkComma, ',');
end;


procedure TTestCShScanner.TestMinus;

begin
    TestToken(tkMinus, '-');
end;


procedure TTestCShScanner.TestDot;

begin
    TestToken(tkDot, '.');
end;


procedure TTestCShScanner.TestDivision;

begin
    TestToken(tkDivision, '/');
end;


procedure TTestCShScanner.TestColon;

begin
    TestToken(tkColon, ':');
end;


procedure TTestCShScanner.TestSemicolon;

begin
    TestToken(tkSemicolon, ';');
end;


procedure TTestCShScanner.TestLessThan;

begin
    TestToken(tkLessThan, '<');
end;


procedure TTestCShScanner.TestEqual;

begin
    TestToken(tkEqual, '=');
end;


procedure TTestCShScanner.TestGreaterThan;

begin
    TestToken(tkGreaterThan, '>');
end;


procedure TTestCShScanner.TestAt;

begin
    TestToken(tkAt, '@');
end;


procedure TTestCShScanner.TestSquaredBraceOpen;

begin
    TestToken(tkSquaredBraceOpen, '[');
    TestToken(tkSquaredBraceOpen, '(.'); // JC: Test for the BraceDotOpen
end;


procedure TTestCShScanner.TestSquaredBraceClose;

begin
    TestToken(tkSquaredBraceClose, ']');
    TestToken(tkSquaredBraceClose, '.)'); // JC: Test for the DotBraceClose
    TestTokens([tkNumber, tkSquaredBraceClose], '1.)');
    // JC: Test for a Number followed by DotBraceClose
end;


procedure TTestCShScanner.TestCaret;

begin
    TestToken(tkXor, '^');
end;


procedure TTestCShScanner.TestBackslash;

begin
    TestToken(tkBackslash, '\');
end;


procedure TTestCShScanner.TestDotDot;

begin
    TestToken(tkDotDot, '..');
end;


procedure TTestCShScanner.TestAssign;

begin
    TestToken(tkAssign, ':=');
end;

procedure TTestCShScanner.TestAssignPlus;
begin
    TestTokens([tkPlus, tkEqual], '+=');
    FScanner.Options := [po_cassignments];
    TestToken(tkAssignPlus, '+=');
end;

procedure TTestCShScanner.TestAssignMinus;
begin
    TestTokens([tkMinus, tkEqual], '-=');
    FScanner.Options := [po_cassignments];
    TestToken(tkAssignMinus, '-=');
end;

procedure TTestCShScanner.TestAssignMul;
begin
    TestTokens([tkMul, tkEqual], '*=');
    FScanner.Options := [po_cassignments];
    TestToken(tkAssignMul, '*=');
end;

procedure TTestCShScanner.TestAssignDivision;
begin
    TestTokens([tkDivision, tkEqual], '/=');
    FScanner.Options := [po_cassignments];
    TestToken(tkAssignDivision, '/=');
end;


procedure TTestCShScanner.TestNotEqual;

begin
    TestToken(tkNotEqual, '<>');
end;


procedure TTestCShScanner.TestLessEqualThan;

begin
    TestToken(tkLessEqualThan, '<=');
end;


procedure TTestCShScanner.TestGreaterEqualThan;

begin
    TestToken(tkGreaterEqualThan, '>=');
end;


procedure TTestCShScanner.TestPower;

begin
    TestToken(tkPower, '**');
end;


procedure TTestCShScanner.TestSymmetricalDifference;

begin
    TestToken(tkSymmetricalDifference, '><');
end;

procedure TTestCShScanner.Testabstract;

begin
    TestToken(tkabstract, 'abstract');
end;

procedure TTestCShScanner.Testas;

begin
    TestToken(tkas, 'as');
end;

procedure TTestCShScanner.Testbase;

begin
    TestToken(tkbase, 'base');
end;

procedure TTestCShScanner.Testbool;

begin
    TestToken(tkbool, 'bool');
end;


procedure TTestCShScanner.Testbreak;

begin
    TestToken(tkbreak, 'break');
end;

procedure TTestCShScanner.Testbyte;

begin
    TestToken(tkbyte, 'byte');
end;

procedure TTestCShScanner.Testcase;

begin
    TestToken(tkcase, 'case');
end;

procedure TTestCShScanner.Testcatch;

begin
    TestToken(tkcatch, 'catch');
end;


procedure TTestCShScanner.Testchar;

begin
    TestToken(tkchar, 'char');
end;

procedure TTestCShScanner.Testchecked;

begin
    TestToken(tkchecked, 'checked');
end;

procedure TTestCShScanner.Testclass;

begin
    TestToken(tkclass, 'class');
end;

procedure TTestCShScanner.Testconst;

begin
    TestToken(tkconst, 'const');
end;


procedure TTestCShScanner.Testcontinue;

begin
    TestToken(tkcontinue, 'continue');
end;

procedure TTestCShScanner.Testdecimal;

begin
    TestToken(tkdecimal, 'decimal');
end;

procedure TTestCShScanner.Testdefault;

begin
    TestToken(tkdefault, 'default');
end;

procedure TTestCShScanner.Testdelegate;

begin
    TestToken(tkdelegate, 'delegate');
end;


procedure TTestCShScanner.Testdo;

begin
    TestToken(tkdo, 'do');
end;

procedure TTestCShScanner.Testdouble;

begin
    TestToken(tkdouble, 'double');
end;

procedure TTestCShScanner.Testelse;

begin
    TestToken(tkelse, 'else');
end;

procedure TTestCShScanner.Testenum;

begin
    TestToken(tkenum, 'enum');
end;


procedure TTestCShScanner.Testevent;

begin
    TestToken(tkevent, 'event');
end;

procedure TTestCShScanner.Testexplicit;

begin
    TestToken(tkexplicit, 'explicit');
end;

procedure TTestCShScanner.Testextern;

begin
    TestToken(tkextern, 'extern');
end;

procedure TTestCShScanner.Testfalse;

begin
    TestToken(tkfalse, 'false');
end;


procedure TTestCShScanner.Testfinally;

begin
    TestToken(tkfinally, 'finally');
end;

procedure TTestCShScanner.Testfixed;

begin
    TestToken(tkfixed, 'fixed');
end;

procedure TTestCShScanner.Testfloat;

begin
    TestToken(tkfloat, 'float');
end;

procedure TTestCShScanner.Testfor;

begin
    TestToken(tkfor, 'for');
end;


procedure TTestCShScanner.Testforeach;

begin
    TestToken(tkforeach, 'foreach');
end;

procedure TTestCShScanner.Testgoto;

begin
    TestToken(tkgoto, 'goto');
end;

procedure TTestCShScanner.Testif;

begin
    TestToken(tkif, 'if');
end;

procedure TTestCShScanner.Testimplicit;

begin
    TestToken(tkimplicit, 'implicit');
end;


procedure TTestCShScanner.Testin;

begin
    TestToken(tkin, 'in');
end;

procedure TTestCShScanner.Testint;

begin
    TestToken(tkint, 'int');
end;

procedure TTestCShScanner.Testinterface;

begin
    TestToken(tkinterface, 'interface');
end;

procedure TTestCShScanner.Testinternal;

begin
    TestToken(tkinternal, 'internal');
end;


procedure TTestCShScanner.Testis;

begin
    TestToken(tkis, 'is');
end;

procedure TTestCShScanner.Testlock;

begin
    TestToken(tklock, 'lock');
end;

procedure TTestCShScanner.Testlong;

begin
    TestToken(tklong, 'long');
end;

procedure TTestCShScanner.Testnamespace;

begin
    TestToken(tknamespace, 'namespace');
end;


procedure TTestCShScanner.Testnew;

begin
    TestToken(tknew, 'new');
end;

procedure TTestCShScanner.Testnull;

begin
    TestToken(tknull, 'null');
end;

procedure TTestCShScanner.Testobject;

begin
    TestToken(tkobject, 'object');
end;

procedure TTestCShScanner.Testoperator;

begin
    TestToken(tkoperator, 'operator');
end;


procedure TTestCShScanner.Testout;

begin
    TestToken(tkout, 'out');
end;

procedure TTestCShScanner.Testoverride;

begin
    TestToken(tkoverride, 'override');
end;

procedure TTestCShScanner.Testparams;

begin
    TestToken(tkparams, 'params');
end;

procedure TTestCShScanner.Testprivate;

begin
    TestToken(tkprivate, 'private');
end;


procedure TTestCShScanner.Testprotected;

begin
    TestToken(tkprotected, 'protected');
end;

procedure TTestCShScanner.Testpublic;

begin
    TestToken(tkpublic, 'public');
end;

procedure TTestCShScanner.Testreadonly;

begin
    TestToken(tkreadonly, 'readonly');
end;

procedure TTestCShScanner.Testref;

begin
    TestToken(tkref, 'ref');
end;


procedure TTestCShScanner.Testreturn;

begin
    TestToken(tkreturn, 'return');
end;

procedure TTestCShScanner.Testsbyte;

begin
    TestToken(tksbyte, 'sbyte');
end;

procedure TTestCShScanner.Testsealed;

begin
    TestToken(tksealed, 'sealed');
end;

procedure TTestCShScanner.Testshort;

begin
    TestToken(tkshort, 'short');
end;


procedure TTestCShScanner.Testsizeof;

begin
    TestToken(tksizeof, 'sizeof');
end;

procedure TTestCShScanner.Teststackalloc;

begin
    TestToken(tkstackalloc, 'stackalloc');
end;

procedure TTestCShScanner.Teststatic;

begin
    TestToken(tkstatic, 'static');
end;

procedure TTestCShScanner.Teststring;

begin
    TestToken(tkstring, 'string');
end;


procedure TTestCShScanner.Teststruct;

begin
    TestToken(tkstruct, 'struct');
end;

procedure TTestCShScanner.Testswitch;

begin
    TestToken(tkswitch, 'switch');
end;

procedure TTestCShScanner.Testthis;

begin
    TestToken(tkthis, 'this');
end;

procedure TTestCShScanner.Testthrow;

begin
    TestToken(tkthrow, 'throw');
end;


procedure TTestCShScanner.Testtrue;

begin
    TestToken(tktrue, 'true');
end;

procedure TTestCShScanner.Testtry;

begin
    TestToken(tktry, 'try');
end;

procedure TTestCShScanner.Testtypeof;

begin
    TestToken(tktypeof, 'typeof');
end;

procedure TTestCShScanner.Testuint;

begin
    TestToken(tkuint, 'uint');
end;


procedure TTestCShScanner.Testulong;

begin
    TestToken(tkulong, 'ulong');
end;

procedure TTestCShScanner.Testunchecked;

begin
    TestToken(tkunchecked, 'unchecked');
end;

procedure TTestCShScanner.Testunsafe;

begin
    TestToken(tkunsafe, 'unsafe');
end;

procedure TTestCShScanner.Testushort;

begin
    TestToken(tkushort, 'ushort');
end;


procedure TTestCShScanner.Testusing;

begin
    TestToken(tkusing, 'using');
end;

procedure TTestCShScanner.Testvirtual;

begin
    TestToken(tkvirtual, 'virtual');
end;

procedure TTestCShScanner.Testvoid;

begin
    TestToken(tkvoid, 'void');
end;

procedure TTestCShScanner.Testvolatile;

begin
    TestToken(tkvolatile, 'volatile');
end;

procedure TTestCShScanner.Testwhile;

begin
    TestToken(tkwhile, 'while');
end;


procedure TTestCShScanner.TestOr;

begin
    TestToken(tkSingleOr, '|');
end;

procedure TTestCShScanner.TestDoubleOr;

begin
    TestToken(tkOr, '||');
end;


procedure TTestCShScanner.TestShlC;
begin
    TestToken(tkshl, '<<');
end;

procedure TTestCShScanner.TestShrC;
begin
    TestToken(tkshr, '>>');
end;

procedure TTestCShScanner.TestLineEnding;

begin
    TestToken(tkLineEnding, #10);
end;

procedure TTestCShScanner.TestLineEnding2;

begin
    TestToken(tkLineEnding, #13);
end;

procedure TTestCShScanner.TestLineEnding3;

begin
    TestToken(tkLineEnding, #10#13);
end;

procedure TTestCShScanner.TestObjCProtocol2;
begin
    TestTokens([tkComment, tkWhitespace, tkidentifier], '{$mode fpc} objcprotocol');
end;

procedure TTestCShScanner.TestObjCCategory2;
begin
    TestTokens([tkComment, tkWhitespace, tkidentifier], '{$mode fpc} objccategory');
end;


procedure TTestCShScanner.TestTab;

begin
    TestToken(tkTab, #9);
end;

procedure TTestCShScanner.TestEscapedKeyWord;
begin
    TestToken(tkIdentifier, '&xor');
end;

procedure TTestCShScanner.TestTokenSeries;
begin
    TestTokens([tkin, tkWhitespace, tkOut, tkWhiteSpace, tkwhile, tkWhiteSpace, tkIdentifier],
        'in of while aninteger');
end;

procedure TTestCShScanner.TestTokenSeriesNoWhiteSpace;
begin
    FScanner.SkipWhiteSpace := True;
    TestTokens([tkin, tkOut, tkwhile, tkIdentifier], 'in of while aninteger');
end;

procedure TTestCShScanner.TestTokenSeriesComments;
begin
    TestTokens([tkin, tkWhitespace, tkOut, tkWhiteSpace, tkComment, tkWhiteSpace, tkIdentifier],
        'in of {while} aninteger');
end;

procedure TTestCShScanner.TestTokenSeriesNoComments;
begin
    FScanner.SkipComments := True;
    TestTokens([tkin, tkWhitespace, tkOut, tkWhiteSpace, tkWhiteSpace, tkIdentifier],
        'in of {while} aninteger');
end;

procedure TTestCShScanner.TestDefine0;
begin
    TestTokens([tkComment], '#DEFINE NEVER');
    AssertTrue('Define not defined', FSCanner.Defines.IndexOf('NEVER') <> -1);
end;

procedure TTestCShScanner.TestDefine0Spaces;
begin
    TestTokens([tkComment], '#DEFINE  NEVER');
    AssertTrue('Define not defined', FSCanner.Defines.IndexOf('NEVER') <> -1);
end;

procedure TTestCShScanner.TestDefine0Spaces2;
begin
    TestTokens([tkComment], '#DEFINE NEVER');
    AssertTrue('Define not defined', FSCanner.Defines.IndexOf('NEVER') <> -1);
end;

procedure TTestCShScanner.TestDefine01;
begin
    TestTokens([tkComment], '#DEFINE NEVER');
    AssertTrue('Define not defined', FSCanner.Defines.IndexOf('NEVER') <> -1);
end;

procedure TTestCShScanner.TestDefine1;
begin
    TestTokens([tkComment], '#IFDEF (NEVER) of #ENDIF');
end;

procedure TTestCShScanner.TestDefine2;

begin
    FSCanner.Defines.Add('ALWAYS');
    TestTokens([tkComment, tkWhitespace, tkout, tkWhitespace, tkcomment],
        '#IFDEF (ALWAYS) comment of #ENDIF');
end;

procedure TTestCShScanner.TestDefine21;
begin
    FSCanner.Defines.Add('ALWAYS');
    TestTokens([tkComment, tkWhitespace, tkout, tkWhitespace, tkcomment],
        '(*$IFDEF ALWAYS*) out (*$ENDIF*)');
end;

procedure TTestCShScanner.TestDefine22;
begin
    FSCanner.Defines.Add('ALWAYS');
    // No whitespace. Test border of *)
    TestTokens([tkComment, tkout, tkWhitespace, tkcomment], '(*$IFDEF ALWAYS*)out (*$ENDIF*)');
end;

procedure TTestCShScanner.TestDefine3;
begin
    FSCanner.Defines.Add('ALWAYS');
    TestTokens([tkComment, tkWhitespace, tkout, tkWhitespace, tkcomment],
        '{$IFDEF ALWAYS} out {$ELSE} in {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine4;
begin
    TestTokens([tkComment, tkWhitespace, tkin, tkWhitespace, tkcomment],
        '{$IFDEF ALWAYS} out {$ELSE} in {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine5;
begin
    FScanner.SkipComments := True;
    TestTokens([tkLineEnding], '{$IFDEF NEVER} of {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine6;

begin
    FSCanner.Defines.Add('ALWAYS');
    FScanner.SkipComments := True;
    TestTokens([tkWhitespace, tkout, tkWhitespace], '{$IFDEF ALWAYS} out {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine7;
begin
    FSCanner.Defines.Add('ALWAYS');
    FScanner.SkipComments := True;
    TestTokens([tkWhitespace, tkout, tkWhitespace],
        '{$IFDEF ALWAYS} out {$ELSE} in {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine8;
begin
    FScanner.SkipComments := True;
    TestTokens([tkWhitespace, tkin, tkWhitespace], '{$IFDEF ALWAYS} out {$ELSE} in {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine9;
begin
    FScanner.SkipWhiteSpace := True;
    TestTokens([], '{$IFDEF NEVER} of {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine10;

begin
    FSCanner.Defines.Add('ALWAYS');
    FScanner.SkipComments := True;
    TestTokens([tkWhitespace, tkout, tkWhitespace], '{$IFDEF ALWAYS} of {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine11;
begin
    FSCanner.Defines.Add('ALWAYS');
    FScanner.SkipComments := True;
    FScanner.SkipWhiteSpace := True;
    TestTokens([tkout], '{$IFDEF ALWAYS} of {$ELSE} in {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine12;
begin
    FScanner.SkipComments := True;
    FScanner.SkipWhiteSpace := True;
    TestTokens([tkin], '{$IFDEF ALWAYS} of {$ELSE} in {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine13;
begin
    FScanner.SkipComments := True;
    FScanner.SkipWhiteSpace := True;
    TestTokens([tkin], '{$IFDEF ALWAYS} }; ą è {$ELSE} in {$ENDIF}');
end;

procedure TTestCShScanner.TestDefine14;
const
    Source = '{$ifdef NEVER_DEFINED}' + sLineBreak + 'type' + sLineBreak +
        '  TNPEventModel = (' + sLineBreak +
        '  NPEventModelCarbon = 0,' + sLineBreak +
        '  NPEventModelCocoa = 1' + sLineBreak +
        '}; // yes, this is an error... except this code should never be included.' +
        sLineBreak + 'ą' + sLineBreak + '|' + sLineBreak +
        '{$endif}' + sLineBreak + '' + sLineBreak +
        'begin' + sLineBreak + 'end.' + sLineBreak;
begin
    NewSource(Source, True);
    while FScanner.fetchToken <> tkEOF do ;

end;

procedure TTestCShScanner.TestInclude;
begin
    FResolver.AddStream('myinclude.inc', TStringStream.Create('if true then'));
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkIf, tkTrue, tkIdentifier], '{$I myinclude.inc}', True, False);
end;

procedure TTestCShScanner.TestInclude2;
begin
    FResolver.AddStream('myinclude.inc', TStringStream.Create('if true then'));
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkIf, tkTrue, tkIdentifier, tkElse], '{$I myinclude.inc} else', True, False);
end;

procedure TTestCShScanner.TestUnDefine1;
begin
    FSCanner.Defines.Add('ALWAYS');
    TestTokens([tkComment], '{$UNDEF ALWAYS}');
    AssertEquals('No more define', -1, FScanner.Defines.INdexOf('ALWAYS'));
end;

procedure TTestCShScanner.TestIFDefined;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        '{$DEFINE A}{$IF defined(A)}begin{$ENDIF}end.', True, False);
end;

procedure TTestCShScanner.TestIFUnDefined;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        '{$IF undefined(A)}begin{$ENDIF}end.', True, False);
end;

procedure TTestCShScanner.TestIFAnd;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        '{$DEFINE A}{$IF defined(A && !B)}begin{$ENDIF}end.', True, False);
end;

procedure TTestCShScanner.TestIFAndShortEval;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        '{$UNDEFINE A}{$IF defined(A && !B)}wrong{$ELSE}begin{$ENDIF}end.',
        True, False);
end;

procedure TTestCShScanner.TestIFOr;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        '{$DEFINE B}{$IF defined(A) or defined(B)}begin{$ENDIF}end.', True, False);
end;

procedure TTestCShScanner.TestIFOrShortEval;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        '{$DEFINE A}{$IF defined(A) or defined(B)}begin{$ENDIF}end.', True, False);
end;

procedure TTestCShScanner.TestIFXor;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        '{$DEFINE B}{$IF defined(A) xor defined(B)}begin{$ENDIF}end.', True, False);
end;

procedure TTestCShScanner.TestIFAndOr;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        '#IF   (A && B || C) wrong1 #ENDIF' + LineEnding +
        '#IF   (A && B || !C) #ELSE wrong2 #ENDIF' + LineEnding +
        '#IF   (A && !B || C) wrong3 #ENDIF' + LineEnding +
        '#IF   (A && !B || !C) #ELSE wrong4 #ENDIF' + LineEnding +
        '#IF   (!A && B || C) wrong5 #ENDIF' + LineEnding +
        '#IF   (!A && B || !C) #ELSE wrong6 #ENDIF' + LineEnding +
        '#IF   (!A && !B || C) #ELSE wrong7 #ENDIF' + LineEnding +
        '#IF   (!A && !B || !C) {#ENDIF }',
        True, False);
end;

procedure TTestCShScanner.TestIFDefinedElseIf;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    FScanner.AddDefine('cpu32');
    TestTokens([tkconst, tkIdentifier, tkEqual, tkString, tkSemicolon,
        tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        'const platform = ' + LineEnding + '{$if defined(cpu32)} ''x86''' +
        LineEnding + '{$elseif defined(cpu64)} ''x64''' + LineEnding +
        '{$else} {$error unknown platform} {$endif};' + LineEnding + 'begin end.', True, False);
end;

procedure TTestCShScanner.TestIfError;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkIdentifier, tkSemicolon, tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        'program Project1;' + LineEnding + 'begin' + LineEnding +
        '{$if sizeof(integer) <> 4} {$error wrong sizeof(integer)} {$endif}' +
        LineEnding + 'end.', True, False);
end;

procedure TTestCShScanner.TestModeSwitch;

const
    PlusMinus = [' ', '+', '-'];

var
    M: TModeSwitch;
    C: char;
begin
    for M in TModeSwitch do
        for C in PlusMinus do
            if SModeSwitchNames[M] <> '' then
              begin
                Scanner.CurrentModeSwitches := [];
                NewSource('{$MODESWITCH ' + SModeSwitchNames[M] + C + '}');
                while not (Scanner.FetchToken = tkEOF) do ;
                if C in [' ', '+'] then
                    AssertTrue(SModeSwitchNames[M] + C + ' sets ' + GetEnumName(
                        TypeInfo(TModeSwitch), Ord(M)), M in Scanner.CurrentModeSwitches)
                else
                    AssertFalse(SModeSwitchNames[M] + C + ' removes ' + GetEnumName(
                        TypeInfo(TModeSwitch), Ord(M)), M in Scanner.CurrentModeSwitches);
              end;
end;

procedure TTestCShScanner.TestOperatorIdentifier;
begin
    Scanner.SetNonToken(tkoperator);
    TestToken(tkidentifier, 'operator', True);
end;

procedure TTestCShScanner.TestUTF8BOM;

begin
    DoTestToken(tkLineEnding, #$EF + #$BB + #$BF);
end;

procedure TTestCShScanner.TestBooleanSwitch;

begin
    Scanner.CurrentBoolSwitches := [bsHints];
    // end space intentional.
    NewSource('{$HINTS OFF }');
    while not (Scanner.FetchToken = tkEOF) do ;
    AssertFalse('Hints off', bshints in Scanner.CurrentBoolSwitches);
end;

initialization
    RegisterTests([TTestTokenFinder, TTestStreamLineReader, TTestCShScanner]);
end.
