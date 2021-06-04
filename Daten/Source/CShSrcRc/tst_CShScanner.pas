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
            const CheckEOF: boolean = True;Const CheckUppToIdent:boolean = true);
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
//        procedure TestComment2;
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
        procedure TestStringConst2;
        procedure TestStringConst3;
        procedure TestAtString;
        procedure TestDollarStringConst;
        procedure TestNumber;
        procedure TestNumber2;
        procedure TestNumber3;
        procedure TestCharacter;
        procedure TestCharString;
        procedure TestCharString2;
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
        procedure TestXor;
        procedure TestBackslash;
        procedure TestDotDot;
        procedure TestAssign;
        procedure TestAssignPlus;
        procedure TestAssignMinus;
        procedure TestAssignMul;
        procedure TestAssignDivision;
        procedure TestAssignAnd;
        procedure TestAssignModulo;
        procedure TestAssignOr;
        procedure TestAssignXor;
        procedure TestNotEqual;
        procedure TestLessEqualThan;
        procedure TestGreaterEqualThan;
        procedure TestPower;
        procedure TestSymmetricalDifference;
        procedure TestKomplement;
        procedure TestAllnonChar;

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
        procedure TestAllChar;

        procedure TestLineEnding;
        procedure TestTab;

//        procedure TestEscapedKeyWord;   // to be checked
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
//        procedure TestInclude;
//        procedure TestInclude2;
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
        procedure TestAskAsk;
        procedure TestSomeLine1;
    end;

implementation

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
    AssertEquals(TestName+': Read token equals expected token.', t, tk);
    if CheckEOF then
      begin
        tk := FScanner.FetchToken;
        if (tk = tkLineEnding) and not (t in [tkEOF, tkLineEnding]) then
            tk := FScanner.FetchToken;
        AssertEquals(TestName+': EOF reached.', tkEOF, FScanner.FetchToken);
      end;
end;

procedure TTestCShScanner.TestToken(t: TToken; const ASource: string;
  const CheckEOF: boolean; const CheckUppToIdent: boolean);
var
    S: string;
begin
    DoTestToken(t, ASource);
    if (ASource <> '') then
      begin
        S := ASource;
        S[1] := Upcase(S[1]);
        if CheckUppToIdent and (S <> ASource) then
        DoTestToken(tkIdentifier, S);
      end;
    if CheckUppToIdent and (Uppercase(ASource) <> ASource) then
      DoTestToken(tkIdentifier, UpperCase(ASource));
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
        AssertEquals(Format('%s: Read token %d equals expected token.', [TestName,i]), t[i], tk);
        if tk = tkIdentifier then
            LastIdentifier := FScanner.CurtokenString;
      end;
    if CheckEOF then
      begin
        tk := FScanner.FetchToken;
        if (tk = tkLineEnding) then
            tk := FScanner.FetchToken;
        AssertEquals(TestName+': EOF reached.', tkEOF, FScanner.FetchToken);
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
    TestToken(tkComment, '/* comment */',True,False);
end;


procedure TTestCShScanner.TestComment3;

begin
    TestToken(tkLineComment, '//');
end;

procedure TTestCShScanner.TestComment4;

begin
    DoTestToken(tkComment, '/* abc */',false);
    AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment5;

begin
    DoTestToken(tkComment, '/* abc' + LineEnding + 'def */',false);
    AssertEquals('Correct comment', ' abc' + LineEnding + 'def ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment6;

begin
    //DoTestToken(tkComment, '{ abc }', False);
    //AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment7;

begin
    //DoTestToken(tkComment, '{ abc' + LineEnding + 'def }', False);
    //AssertEquals('Correct comment', ' abc' + LineEnding + 'def ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment8;

begin
    DoTestToken(tkLineComment, '// abc ',false);
    AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestComment9;

begin
    DoTestToken(tkLineComment, '// abc ' + LineEnding,false);
    AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
end;

procedure TTestCShScanner.TestNestedComment1;
begin
    TestToken(tkLineComment, '// { comment } ', true,False);
end;

procedure TTestCShScanner.TestNestedComment2;
begin
    TestToken(tkComment, '/* { comment } */', true,False);
end;

procedure TTestCShScanner.TestNestedComment3;
begin
    TestToken(tkComment, '/* /* comment */ */', true,False);
end;

procedure TTestCShScanner.TestNestedComment4;
begin
//    TestToken(tkComment, '{ (* comment *) }');
end;

procedure TTestCShScanner.TestNestedComment5;
begin
//    TestToken(tkComment, '(* (* comment *) *)');
end;

procedure TTestCShScanner.TestonComment;
begin
    FScanner.OnComment := @DoComment;
    DoTestToken(tkComment, '/* abc */', False);
    assertTrue('Comment called', FDoCommentCalled);
    AssertEquals('Correct comment', ' abc ', Scanner.CurTokenString);
    AssertEquals('Correct comment token', ' abc ', FComment);
end;


procedure TTestCShScanner.TestIdentifier;

begin
    TestToken(tkIdentifier, 'identifier');  // ??
end;


procedure TTestCShScanner.TestStringConst;

begin
    TestToken(CShScanner.tkStringConst, '"A string"', true,False);
end;

procedure TTestCShScanner.TestStringConst2;

begin
    TestToken(CShScanner.tkStringConst, '"A \"string"', true,False);
end;

procedure TTestCShScanner.TestStringConst3;

begin
    TestToken(CShScanner.tkStringConst, '"A'' \"string"', true,False);
end;


procedure TTestCShScanner.TestDollarStringConst;

begin
    TestToken(CShScanner.tkStringConst, '$"A string"', true,False);
end;

procedure TTestCShScanner.TestCharString;

begin
    TestToken(CShScanner.tkCharacter, '''A''');
end;

procedure TTestCShScanner.TestCharString2;

begin
    TestToken(CShScanner.tkCharacter, '''\n''',true,false);
end;


procedure TTestCShScanner.TestNumber;

begin
    TestToken(tkNumber, '123');
end;

procedure TTestCShScanner.TestNumber2;

begin
    TestToken(tkNumber, '123f',true,false);
end;

procedure TTestCShScanner.TestNumber3;

begin
    TestToken(tkNumber, '123d',true,false);
end;

procedure TTestCShScanner.TestCharacter;

begin
    TestToken(CShScanner.tkLineComment, '#65 ', False);
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
    TestToken(tkEqual, '==');
end;


procedure TTestCShScanner.TestGreaterThan;

begin
    TestToken(tkGreaterThan, '>');
end;


procedure TTestCShScanner.TestAt;

begin
    TestToken(tkLineEnding, '@');  // ??
end;

procedure TTestCShScanner.TestAtString;

begin
    TestToken(tkStringConst, '@"This\is\a\Test"',true,false);
end;


procedure TTestCShScanner.TestSquaredBraceOpen;

begin
    TestToken(tkSquaredBraceOpen, '[');
end;


procedure TTestCShScanner.TestSquaredBraceClose;

begin
    TestToken(tkSquaredBraceClose, ']');
end;


procedure TTestCShScanner.TestXor;

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
    TestToken(tkAssign, '=');
end;

procedure TTestCShScanner.TestAssignPlus;
begin
    TestToken(tkAssignPlus, '+=');
end;

procedure TTestCShScanner.TestAssignMinus;
begin
    TestToken(tkAssignMinus, '-=');
end;

procedure TTestCShScanner.TestAssignMul;
begin
    TestToken(tkAssignMul, '*=');
end;

procedure TTestCShScanner.TestAssignDivision;
begin
    TestToken(tkAssignDivision, '/=');
end;

procedure TTestCShScanner.TestAssignModulo;
begin
    TestToken(tkAssignModulo, '%=');
end;

procedure TTestCShScanner.TestAssignAnd;
begin
    TestToken(tkAssignAnd, '&=');
end;

procedure TTestCShScanner.TestAssignOr;
begin
    TestToken(tkAssignOr, '|=');
end;

procedure TTestCShScanner.TestAssignXor;
begin
    TestToken(tkAssignXor, '^=');
end;

procedure TTestCShScanner.TestNotEqual;

begin
    TestToken(tkNotEqual, '!=');
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

procedure TTestCShScanner.TestAbstract;

begin
    TestToken(tkabstract, 'abstract');
end;

procedure TTestCShScanner.TestAs;

begin
    TestToken(tkas, 'as');
end;

procedure TTestCShScanner.TestBase;

begin
    TestToken(tkbase, 'base');
end;

procedure TTestCShScanner.TestBool;

begin
    TestToken(tkbool, 'bool');
end;


procedure TTestCShScanner.TestBreak;

begin
    TestToken(tkbreak, 'break');
end;

procedure TTestCShScanner.TestByte;

begin
    TestToken(tkbyte, 'byte');
end;

procedure TTestCShScanner.TestCase;

begin
    TestToken(tkcase, 'case');
end;

procedure TTestCShScanner.TestCatch;

begin
    TestToken(tkcatch, 'catch');
end;


procedure TTestCShScanner.TestChar;

begin
    TestToken(tkchar, 'char');
end;

procedure TTestCShScanner.TestChecked;

begin
    TestToken(tkchecked, 'checked');
end;

procedure TTestCShScanner.TestClass;

begin
    TestToken(tkclass, 'class');
end;

procedure TTestCShScanner.TestConst;

begin
    TestToken(tkconst, 'const');
end;


procedure TTestCShScanner.TestContinue;

begin
    TestToken(tkcontinue, 'continue');
end;

procedure TTestCShScanner.TestDecimal;

begin
    TestToken(tkdecimal, 'decimal');
end;

procedure TTestCShScanner.TestDefault;

begin
    TestToken(tkdefault, 'default');
end;

procedure TTestCShScanner.TestDelegate;

begin
    TestToken(tkdelegate, 'delegate');
end;


procedure TTestCShScanner.TestDo;

begin
    TestToken(tkdo, 'do');
end;

procedure TTestCShScanner.TestDouble;

begin
    TestToken(tkdouble, 'double');
end;

procedure TTestCShScanner.TestElse;

begin
    TestToken(tkelse, 'else');
end;

procedure TTestCShScanner.TestEnum;

begin
    TestToken(tkenum, 'enum');
end;


procedure TTestCShScanner.TestEvent;

begin
    TestToken(tkevent, 'event');
end;

procedure TTestCShScanner.TestExplicit;

begin
    TestToken(tkexplicit, 'explicit');
end;

procedure TTestCShScanner.TestExtern;

begin
    TestToken(tkextern, 'extern');
end;

procedure TTestCShScanner.TestFalse;

begin
    TestToken(tkfalse, 'false');
end;


procedure TTestCShScanner.TestFinally;

begin
    TestToken(tkfinally, 'finally');
end;

procedure TTestCShScanner.TestFixed;

begin
    TestToken(tkfixed, 'fixed');
end;

procedure TTestCShScanner.TestFloat;

begin
    TestToken(tkfloat, 'float');
end;

procedure TTestCShScanner.TestFor;

begin
    TestToken(tkfor, 'for');
end;


procedure TTestCShScanner.TestForeach;

begin
    TestToken(tkforeach, 'foreach');
end;

procedure TTestCShScanner.TestGoto;

begin
    TestToken(tkgoto, 'goto');
end;

procedure TTestCShScanner.TestIf;

begin
    TestToken(tkif, 'if');
end;

procedure TTestCShScanner.TestImplicit;

begin
    TestToken(tkimplicit, 'implicit');
end;


procedure TTestCShScanner.TestIn;

begin
    TestToken(tkin, 'in');
end;

procedure TTestCShScanner.TestInt;

begin
    TestToken(tkint, 'int');
end;

procedure TTestCShScanner.TestInterface;

begin
    TestToken(tkinterface, 'interface');
end;

procedure TTestCShScanner.TestInternal;

begin
    TestToken(tkinternal, 'internal');
end;


procedure TTestCShScanner.TestIs;

begin
    TestToken(tkis, 'is');
end;

procedure TTestCShScanner.TestLock;

begin
    TestToken(tklock, 'lock');
end;

procedure TTestCShScanner.TestLong;

begin
    TestToken(tklong, 'long');
end;

procedure TTestCShScanner.TestNamespace;

begin
    TestToken(tknamespace, 'namespace');
end;


procedure TTestCShScanner.TestNew;

begin
    TestToken(tknew, 'new');
end;

procedure TTestCShScanner.TestNull;

begin
    TestToken(tknull, 'null');
end;

procedure TTestCShScanner.TestObject;

begin
    TestToken(tkobject, 'object');
end;

procedure TTestCShScanner.TestOperator;

begin
    TestToken(tkoperator, 'operator');
end;


procedure TTestCShScanner.TestOut;

begin
    TestToken(tkout, 'out');
end;

procedure TTestCShScanner.TestOverride;

begin
    TestToken(tkoverride, 'override');
end;

procedure TTestCShScanner.TestParams;

begin
    TestToken(tkparams, 'params');
end;

procedure TTestCShScanner.TestPrivate;

begin
    TestToken(tkprivate, 'private');
end;


procedure TTestCShScanner.TestProtected;

begin
    TestToken(tkprotected, 'protected');
end;

procedure TTestCShScanner.TestPublic;

begin
    TestToken(tkpublic, 'public');
end;

procedure TTestCShScanner.TestReadonly;

begin
    TestToken(tkreadonly, 'readonly');
end;

procedure TTestCShScanner.TestRef;

begin
    TestToken(tkref, 'ref');
end;


procedure TTestCShScanner.TestReturn;

begin
    TestToken(tkreturn, 'return');
end;

procedure TTestCShScanner.TestSbyte;

begin
    TestToken(tksbyte, 'sbyte');
end;

procedure TTestCShScanner.TestSealed;

begin
    TestToken(tksealed, 'sealed');
end;

procedure TTestCShScanner.TestShort;

begin
    TestToken(tkshort, 'short');
end;


procedure TTestCShScanner.TestSizeof;

begin
    TestToken(tksizeof, 'sizeof');
end;

procedure TTestCShScanner.TestStackalloc;

begin
    TestToken(tkstackalloc, 'stackalloc');
end;

procedure TTestCShScanner.TestStatic;

begin
    TestToken(tkstatic, 'static');
end;

procedure TTestCShScanner.TestString;

begin
    TestToken(tkstring, 'string');
end;


procedure TTestCShScanner.TestStruct;

begin
    TestToken(tkstruct, 'struct');
end;

procedure TTestCShScanner.TestSwitch;

begin
    TestToken(tkswitch, 'switch');
end;

procedure TTestCShScanner.TestThis;

begin
    TestToken(tkthis, 'this');
end;

procedure TTestCShScanner.TestThrow;

begin
    TestToken(tkthrow, 'throw');
end;


procedure TTestCShScanner.TestTrue;

begin
    TestToken(tktrue, 'true');
end;

procedure TTestCShScanner.TestTry;

begin
    TestToken(tktry, 'try');
end;

procedure TTestCShScanner.TestTypeof;

begin
    TestToken(tktypeof, 'typeof');
end;

procedure TTestCShScanner.TestUint;

begin
    TestToken(tkuint, 'uint');
end;


procedure TTestCShScanner.TestUlong;

begin
    TestToken(tkulong, 'ulong');
end;

procedure TTestCShScanner.TestUnchecked;

begin
    TestToken(tkunchecked, 'unchecked');
end;

procedure TTestCShScanner.TestUnsafe;

begin
    TestToken(tkunsafe, 'unsafe');
end;

procedure TTestCShScanner.TestUshort;

begin
    TestToken(tkushort, 'ushort');
end;


procedure TTestCShScanner.TestUsing;

begin
    TestToken(tkusing, 'using');
end;

procedure TTestCShScanner.TestVirtual;

begin
    TestToken(tkvirtual, 'virtual');
end;

procedure TTestCShScanner.TestVoid;

begin
    TestToken(tkvoid, 'void');
end;

procedure TTestCShScanner.TestVolatile;

begin
    TestToken(tkvolatile, 'volatile');
end;

procedure TTestCShScanner.TestWhile;

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

procedure TTestCShScanner.TestKomplement;
begin
    TestToken(tkKomplement, '~');
end;

procedure TTestCShScanner.TestAskAsk;
begin
    TestToken(tkAskAsk, '??');
end;

procedure TTestCShScanner.TestAllnonChar;
var
  tkn: TToken;
begin
   for tkn in TToken do
     if tkn <> tkComment then
       if not (TokenInfos[tkn][1] in ['A'..'Z','a'..'z']) then
         TestToken(tkn, TokenInfos[tkn] );
end;

procedure TTestCShScanner.TestAllChar;
var
  tkn: TToken;
begin
   for tkn in TToken do
     if tkn > tkComment then
       if  (TokenInfos[tkn][1] in ['A'..'Z','a'..'z']) then
         TestToken(tkn, TokenInfos[tkn] );
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

procedure TTestCShScanner.TestTab;

begin
    TestToken(tkTab, #9);
end;

procedure TTestCShScanner.TestTokenSeries;
begin
    TestTokens([tkin, tkWhitespace, tkOut, tkWhiteSpace, tkwhile, tkWhiteSpace, tkIdentifier],
        'in out while aninteger');
end;

procedure TTestCShScanner.TestTokenSeriesNoWhiteSpace;
begin
    FScanner.SkipWhiteSpace := True;
    TestTokens([tkin, tkOut, tkwhile, tkIdentifier], 'in out while aninteger');
end;

procedure TTestCShScanner.TestTokenSeriesComments;
begin
    TestTokens([tkin, tkWhitespace, tkOut, tkWhiteSpace, tkComment, tkWhiteSpace, tkIdentifier],
        'in out /*while*/ aninteger');
end;

procedure TTestCShScanner.TestTokenSeriesNoComments;
begin
    FScanner.SkipComments := True;
    TestTokens([tkin, tkWhitespace, tkOut, tkWhiteSpace, tkWhiteSpace, tkIdentifier],
        'in out /*while*/ aninteger');
end;

procedure TTestCShScanner.TestDefine0;
begin
    TestTokens([tkLineComment], '#define NEVER');
    AssertTrue('Define not defined', FSCanner.Defines.IndexOf('NEVER') <> -1);
end;

procedure TTestCShScanner.TestDefine0Spaces;
begin
    TestTokens([tkLineComment], '#define  NEVER');
    AssertTrue('Define not defined', FSCanner.Defines.IndexOf('NEVER') <> -1);
end;

procedure TTestCShScanner.TestDefine0Spaces2;
begin
    TestTokens([tkLineComment], '#define NEVER');
    AssertTrue('Define not defined', FSCanner.Defines.IndexOf('NEVER') <> -1);
end;

procedure TTestCShScanner.TestDefine01;
begin
    TestTokens([tkLineComment], '#define NEVER');
    AssertTrue('Define not defined', FSCanner.Defines.IndexOf('NEVER') <> -1);
end;

procedure TTestCShScanner.TestDefine1;
begin
    TestTokens([tkLineComment], '#IF (NEVER)'+LineEnding+'of'+LineEnding+'#endif');
end;

procedure TTestCShScanner.TestDefine2;

begin
    FSCanner.Defines.Add('ALWAYS');
    TestTokens([tkLineComment, tkLineEnding, tkout, tkLineEnding, tkLineComment],
        '#if (ALWAYS)'+LineEnding+'out'+LineEnding+'#endif');
end;

procedure TTestCShScanner.TestDefine21;
begin
    FSCanner.Defines.Add('ALWAYS');
    TestTokens([tkLineComment, tkLineEnding, tkout, tkLineEnding, tkLineComment],
        '#if ALWAYS'+LineEnding+'out'+LineEnding+'#endif');
end;

procedure TTestCShScanner.TestDefine22;
begin
    FSCanner.Defines.Add('ALWAYS');
    // No whitespace. Test border of *)
    TestTokens([tkLineComment,tkLineEnding,tkout, tkLineEnding, tkLineComment], '#if (ALWAYS)'+LineEnding+'out'+LineEnding+'#endif');
end;

procedure TTestCShScanner.TestDefine3;
begin
    FSCanner.Defines.Add('ALWAYS');
    TestTokens([tkLineComment, tkLineEnding, tkout, tkLineEnding],
        '#if ALWAYS'+LineEnding+'out'+LineEnding+'#else'+LineEnding+'in'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine4;
begin
    TestTokens([tkLineComment, tkLineEnding, tkin, tkLineEnding, tkLineComment],
        '#if ALWAYS'+LineEnding+'out'+LineEnding+'#else'+LineEnding+'in'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine5;
begin
    FScanner.SkipComments := True;
    TestTokens([tkEOF], '#if NEVER'+LineEnding+'out'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine6;

begin
    FSCanner.Defines.Add('ALWAYS');
    FScanner.SkipComments := True;
    TestTokens([tkLineEnding, tkout, tkLineEnding], '#if ALWAYS'+LineEnding+'out'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine7;
begin
    FSCanner.Defines.Add('ALWAYS');
    FScanner.SkipComments := True;
    TestTokens([tkLineEnding, tkout, tkLineEnding],
        '#if ALWAYS'+LineEnding+'out'+LineEnding+'#else'+LineEnding+'in'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine8;
begin
    FScanner.SkipComments := True;
    TestTokens([tkLineEnding, tkin, tkLineEnding], '#if ALWAYS'+LineEnding+'out'+LineEnding+'#else'+LineEnding+'in'+LineEnding+'#endif');
end;

procedure TTestCShScanner.TestDefine9;
begin
    FScanner.SkipWhiteSpace := True;
    TestTokens([], '#if NEVER'+LineEnding+'of'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine10;

begin
    FSCanner.Defines.Add('ALWAYS');
    FScanner.SkipComments := True;
    TestTokens([tkLineEnding, tkout, tkLineEnding], '#if ALWAYS'+LineEnding+'out'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine11;
begin
    FSCanner.Defines.Add('ALWAYS');
    FScanner.SkipComments := True;
    FScanner.SkipWhiteSpace := True;
    TestTokens([tkout], '#if ALWAYS'+LineEnding+'out'+LineEnding+'#else'+LineEnding+'in'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine12;
begin
    FScanner.SkipComments := True;
    FScanner.SkipWhiteSpace := True;
    TestTokens([tkin], '#if ALWAYS'+LineEnding+'of'+LineEnding+'#else'+LineEnding+'in'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine13;
begin
    FScanner.SkipComments := True;
    FScanner.SkipWhiteSpace := True;
    TestTokens([tkin], '#if ALWAYS'+LineEnding+'; ą è'+LineEnding+'#else'+LineEnding+'in'+LineEnding+'#endif}');
end;

procedure TTestCShScanner.TestDefine14;
const
    Source = '#if NEVER_DEFINED' + sLineBreak + 'type' + sLineBreak +
        '  TNPEventModel = (' + sLineBreak +
        '  NPEventModelCarbon = 0,' + sLineBreak +
        '  NPEventModelCocoa = 1' + sLineBreak +
        '}; // yes, this is an error... except this code should never be included.' +
        sLineBreak + 'ą' + sLineBreak + '|' + sLineBreak +
        '#endif' + sLineBreak + '' + sLineBreak +
        'begin' + sLineBreak + 'end.' + sLineBreak;
begin
    NewSource(Source, True);
    while FScanner.fetchToken <> tkEOF do ;

end;

// no include
//procedure TTestCShScanner.TestInclude;
//begin
//    FResolver.AddStream('myinclude.inc', TStringStream.Create('if true then'));
//    FScanner.SkipWhiteSpace := True;
//    FScanner.SkipComments := True;
//    TestTokens([tkIf, tkTrue, tkIdentifier], '#I myinclude.inc', True, False);
//end;
//
//procedure TTestCShScanner.TestInclude2;
//begin
//    FResolver.AddStream('myinclude.inc', TStringStream.Create('if true then'));
//    FScanner.SkipWhiteSpace := True;
//    FScanner.SkipComments := True;
//    TestTokens([tkIf, tkTrue, tkIdentifier, tkElse], '#I myinclude.inc else', True, False);
//end;

procedure TTestCShScanner.TestUnDefine1;
begin
    FSCanner.Defines.Add('ALWAYS');
    TestTokens([tkLineComment], '#undef ALWAYS}');
    AssertEquals('No more define', -1, FScanner.Defines.INdexOf('ALWAYS'));
end;

procedure TTestCShScanner.TestIFDefined;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose],
        '#define A'+LineEnding+'#if A'+LineEnding+'{'+LineEnding+'#endif'+LineEnding+'}', True, False);
end;

procedure TTestCShScanner.TestIFUnDefined;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose],
        '#if !A'+LineEnding+'{'+LineEnding+'#endif'+LineEnding+'}', True, False);
end;

procedure TTestCShScanner.TestIFAnd;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose],
        '#define A'+LineEnding+'#if (A & !B)'+LineEnding+'{'+LineEnding+'#endif'+LineEnding+'}', True, False);
end;

procedure TTestCShScanner.TestIFAndShortEval;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose],
        '#undefine A'+LineEnding+'#IF (A && !B)'+LineEnding+'wrong'+LineEnding+'#else'+LineEnding+'{'+LineEnding+'#endif'+LineEnding+'}',
        True, False);
end;

procedure TTestCShScanner.TestIFOr;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose],
        '#define B'+LineEnding+'#IF (A | B)'+LineEnding+'{'+LineEnding+'#endif'+LineEnding+'}', True, False);
end;

procedure TTestCShScanner.TestIFOrShortEval;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose],
        '#define A'+LineEnding+'#IF (A || B)'+LineEnding+'{'+LineEnding+'#endif'+LineEnding+'}', True, False);
end;

procedure TTestCShScanner.TestIFXor;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose],
        '#define B' + LineEnding +'#IF (A ^ B)' + LineEnding +'{' + LineEnding +'#endif' + LineEnding +'}', True, False);
end;

procedure TTestCShScanner.TestIFAndOr;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkCurlyBraceOpen, tkCurlyBraceClose, tkDot],
        '#if   (A && B || C)' + LineEnding +'wrong1' + LineEnding +'#endif' + LineEnding +
        '#if   (A && B || !C)' + LineEnding +'#else' + LineEnding +'wrong2' + LineEnding +'#endif' + LineEnding +
        '#if   (A && !B || C)' + LineEnding +'wrong3' + LineEnding +'#endif' + LineEnding +
        '#if   (A && !B || !C)' + LineEnding +'#else' + LineEnding +'wrong4' + LineEnding +'#endif' + LineEnding +
        '#if   (!A && B || C)' + LineEnding +'wrong5' + LineEnding +'#endif' + LineEnding +
        '#if   (!A && B || !C)' + LineEnding +'#else' + LineEnding +'wrong6' + LineEnding +'#endif' + LineEnding +
        '#if   (!A && !B || C)' + LineEnding +'#else' + LineEnding +'wrong7' + LineEnding +'#endif' + LineEnding +
        '#if   (!A && !B || !C)' + LineEnding +'#endif',
        True, False);
end;

procedure TTestCShScanner.TestIFDefinedElseIf;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    FScanner.AddDefine('cpu32');
    TestTokens([tkconst, tkIdentifier, tkEqual, tkString, tkSemicolon,
        tkCurlyBraceOpen, tkCurlyBraceClose],
        'const platform == ' + LineEnding + '#if cpu32' + LineEnding + '''x86''' +
        LineEnding + '#elif cpu64' + LineEnding + '''x64''' + LineEnding +
        '#else' + LineEnding + '#error unknown platform' + LineEnding + '#endif' + LineEnding + '{ }', True, False);
end;

procedure TTestCShScanner.TestIfError;
begin
    FScanner.SkipWhiteSpace := True;
    FScanner.SkipComments := True;
    TestTokens([tkIdentifier,tkIdentifier, tkSemicolon, tkCurlyBraceOpen, tkCurlyBraceClose],
        'program Project1;' + LineEnding + '{' + LineEnding +
        '#if sizeof(integer) <> 4' + LineEnding + '#error wrong sizeof(integer)' + LineEnding + '#endif}' +
        LineEnding + '}', True, False);
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
                NewSource('#MODESWITCH ' + SModeSwitchNames[M] + C + '}');
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

Procedure TTestCShScanner.TestSomeLine1;

begin
   FScanner.SkipWhiteSpace := True;
    TestTokens([tkIdentifier,tkAssignPlus, tkString,tkDot, tkIdentifier, tkBraceOpen,tkStringConst,
           tkComma, tkIdentifier, tkSquaredBraceOpen,tkStringConst,tkSquaredBraceClose,tkComma,
           tkIdentifier, tkBraceOpen, tkIdentifier, tkSquaredBraceOpen,tkStringConst,tkSquaredBraceClose, tkBraceClose ,
           tkDivision,tkNumber,tkComma,
           tkIdentifier, tkBraceOpen, tkIdentifier, tkSquaredBraceOpen,tkStringConst,tkSquaredBraceClose, tkBraceClose ,
           tkDivision,tkNumber,tkBraceClose,tkSemicolon],
        'RetText += string.Format("Disk: {0}  Size: {1,5:0.0} GB   Free:{2,5:0.0} GB\r\n", mo["Name"], AsDouble(mo["Size"]) / 1073741824.0, AsDouble(mo["FreeSpace"]) / 1073741824.0);',
        false);
end;

initialization
    RegisterTests([TTestTokenFinder, TTestStreamLineReader, TTestCShScanner]);
end.
