{
    This file is inspired by PScanner, the Pascal source lexical scanner

    CSharp Source Lexical Scanner
 **********************************************************************}

unit CShScanner;

{$i jcs-cshsrc.inc}

interface

uses
  {$ifdef pas2js}
  js,
  {$IFDEF NODEJS}
  Node.FS,
  {$ENDIF}
  Types,
  {$endif}
    SysUtils, Classes;

// message numbers
const
    nErrInvalidCharacter = 1001;
    nErrOpenString = 1002;
    nErrIncludeFileNotFound = 1003;
    nErrIfXXXNestingLimitReached = 1004;
    nErrInvalidPPElse = 1005;
    nErrInvalidPPEndif = 1006;
    nLogOpeningFile = 1007;
    nLogLineNumber = 1008; // same as FPC
    nLogIFDefAccepted = 1009;
    nLogIFDefRejected = 1010;
    nLogIFNDefAccepted = 1011;
    nLogIFNDefRejected = 1012;
    nLogIFAccepted = 1013;
    nLogIFRejected = 1014;
    //  nLogIFOptAccepted = 1015;
    //  nLogIFOptRejected = 1016;
    nLogELSEIFAccepted = 1017;
    nLogELSEIFRejected = 1018;
    nErrInvalidMode = 1019;
    nErrInvalidModeSwitch = 1020;
    nErrXExpectedButYFound = 1021;
    nErrRangeCheck = 1022;
    nErrDivByZero = 1023;
    nErrOperandAndOperatorMismatch = 1024;
    nUserDefined = 1025;
    nLogMacroDefined = 1026; // FPC=3101
    nLogMacroUnDefined = 1027; // FPC=3102
    nWarnIllegalCompilerDirectiveX = 1028;
    nIllegalStateForWarnDirective = 1027;
    nErrIncludeLimitReached = 1028;
    nMisplacedGlobalCompilerSwitch = 1029;
    nLogMacroXSetToY = 1030;
    nInvalidDispatchFieldName = 1031;
    nErrWrongSwitchToggle = 1032;
    nNoResourceSupport = 1033;
    nResourceFileNotFound = 1034;

// resourcestring patterns of messages
resourcestring
    SErrInvalidCharacter = 'Invalid character ''%s''';
    SErrOpenString = 'string exceeds end of line';
    SErrIncludeFileNotFound = 'Could not find include file ''%s''';
    SErrResourceFileNotFound = 'Could not find resource file ''%s''';
    SErrIfXXXNestingLimitReached = 'Nesting of $IFxxx too deep';
    SErrInvalidPPElse = '$ELSE without matching $IFxxx';
    SErrInvalidPPEndif = '$ENDIF without matching $IFxxx';
    SLogOpeningFile = 'Opening source file "%s".';
    SLogLineNumber = 'Reading line %d.';
    SLogIFDefAccepted = 'IFDEF %s found, accepting.';
    SLogIFDefRejected = 'IFDEF %s found, rejecting.';
    SLogIFNDefAccepted = 'IFNDEF %s found, accepting.';
    SLogIFNDefRejected = 'IFNDEF %s found, rejecting.';
    SLogIFAccepted = 'IF %s found, accepting.';
    SLogIFRejected = 'IF %s found, rejecting.';
    SLogELSEIFAccepted = 'ELSEIF %s found, accepting.';
    SLogELSEIFRejected = 'ELSEIF %s found, rejecting.';
    SErrInvalidMode = 'Invalid mode: "%s"';
    SErrInvalidModeSwitch = 'Invalid mode switch: "%s"';
    SErrXExpectedButYFound = '"%s" expected, but "%s" found';
    SErrRangeCheck = 'range check failed';
    SErrDivByZero = 'division by zero';
    SErrOperandAndOperatorMismatch = 'operand and operator mismatch';
    SUserDefined = 'User defined: "%s"';
    SLogMacroDefined = 'Macro defined: %s';
    SLogMacroUnDefined = 'Macro undefined: %s';
    SWarnIllegalCompilerDirectiveX = 'Illegal compiler directive "%s"';
    SIllegalStateForWarnDirective = 'Illegal state "%s" for $WARN directive';
    SErrIncludeLimitReached = 'Include file limit reached';
    SMisplacedGlobalCompilerSwitch = 'Misplaced global compiler switch, ignored';
    SLogMacroXSetToY = 'Macro %s set to %s';
    SInvalidDispatchFieldName = 'Invalid Dispatch field name';
    SErrWrongSwitchToggle = 'Wrong switch toggle, use ON/OFF or +/-';
    SNoResourceSupport = 'No support for resources of type "%s"';

type
    TMessageType = (
        mtFatal,
        mtError,
        mtWarning,
        mtNote,
        mtHint,
        mtInfo,
        mtDebug
        );
    TMessageTypes = set of TMessageType;

    TMessageArgs = array of string;

    TToken = (
        tkEOF,
        tkWhitespace,
        tkIdentifier,
        tkLabel,
        tkStringConst,
        tkNumber,
        tkCharacter, // ^A .. ^Z
        tkLineEnding, // normal LineEnding
        tkTab, // a Tabulator-Key

        tkLineComment,  // //
        tkComment,      // /* ... */

        // Simple (one-character) tokens
        tkCurlyBraceOpen,        // '{'
        tkCurlyBraceClose,       // '}'
        tkBraceOpen,             // '('
        tkBraceClose,            // ')'
        tkMul,                   // '*'
        tkPlus,                  // '+'
        tkComma,                 // ','
        tkMinus,                 // '-'
        tkDot,                   // '.'
        tkDivision,              // '/'
        tkColon,                 // ':'
        tkSemicolon,             // ';'
        tkLessThan,              // '<'
        tkAssign,                // '='
        tkGreaterThan,           // '>'
//        tkAt,                    // '@'
        tkSquaredBraceOpen,      // '['
        tkSquaredBraceClose,     // ']'
        tkXor,                   // '^' (xor operator)
        tkBackslash,             // '\'
        tkSingleAnd,             // '&'
        tkSingleOr,              // '|'
        tkNot,                   // '!'
        tkAsk,                   // '?'
        tkmod,                   // '%'
        tkKomplement,            // '~'
        // Two-character tokens
        tkEqual,                 // '=='
        tkLambda,                // '=>'
        tkDotDot,                // '..'
        tkNotEqual,              // '!='
        tkLessEqualThan,         // '<='
        tkGreaterEqualThan,      // '>='
        tkPower,                 // '**'
        tkSymmetricalDifference, // '><'
        tkAskAsk,                // '??'
        tkPlusPlus,              // '++'
        tkMinusMinus,            // '--'
        tkAssignPlus,            // '+='
        tkAssignMinus,           // '-='
        tkAssignMul,             // '*='
        tkAssignDivision,        // '/='
        tkAssignModulo,          // '%='
        tkAssignAnd,             // '&='
        tkAssignOr,              // '|='
        tkAssignXor,             // '^='
        tkand,                   // '&&'
        tkor,                    // '||'
        tkshl,                   // '<<'
        tkshr,                   // '>>'
        // Three-Character token
        tkAssignshl,             // '<<='
        tkAssignshr,             // '>>='
        tkAssignAsk,             // '??='

        // Reserved words
        tkAbstract, tkAs, tkBase, tkBool,
        tkBreak, tkByte, tkCase, tkCatch,
        tkChar, tkChecked, tkClass, tkConst,
        tkContinue, tkDecimal, tkDefault, tkDelegate,
        tkDo, tkDouble, tkElse, tkEnum,
        tkEvent, tkExplicit, tkExtern, tkFalse,
        tkFinally, tkFixed, tkFloat, tkFor,
        tkForeach, tkGoto, tkIf, tkImplicit,
        tkIn, tkInt, tkInterface, tkInternal,
        tkIs, tkLock, tkLong, tkNamespace,
        tkNew, tkNull, tkObject, tkOperator,
        tkOut, tkOverride, tkParams, tkPrivate,
        tkProtected, tkPublic, tkReadonly, tkRef,
        tkReturn, tkSbyte, tkSealed, tkShort,
        tkSizeof, tkStackalloc, tkStatic, tkString,
        tkStruct, tkSwitch, tkThis, tkThrow,
        tkTrue, tkTry, tkTypeof, tkUint,
        tkUlong, tkUnchecked, tkUnsafe, tkUshort,
        tkUsing, tkVirtual, tkVoid, tkVolatile,
        tkWhile
        );
    TTokens = set of TToken;

    TModeSwitch = (
        msNone
        { generic }
        );
    TModeSwitches = set of TModeSwitch;

    //Todo -oJC : See what switches are needed
    //switches, that can be 'on' or 'off'
    TBoolSwitch = (
        bsNone,
        bsAlign,          // A   align fields
        bsBoolEval,       // B   complete boolean evaluation
        bsAssertions,     // C   generate code for assertions
        bsDebugInfo,      // D   generate debuginfo (debug lines), OR: $description 'text'
        bsExtension,      // E   output file extension
        // F
        bsImportedData,   // G
        bsLongStrings,    // H   String=AnsiString
        bsIOChecks,       // I   generate EInOutError
        bsWriteableConst, // J   writable typed const
        // K
        bsLocalSymbols,   // L   generate local symbol information (debug, requires $D+)
        bsTypeInfo,       // M   allow published members OR $M minstacksize,maxstacksize
        // N
        bsOptimization,   // O   enable safe optimizations (-O1)
        bsOpenStrings,    // P   deprecated Delphi directive
        bsOverflowChecks, // Q   or $OV
        bsRangeChecks,    // R
        // S
        bsTypedAddress,
        // T   enabled: @variable gives typed pointer, otherwise untyped pointer
        bsSafeDivide,     // U
        bsVarStringChecks,// V   strict shortstring checking, e.g. cannot pass shortstring[3] to shortstring
        bsStackframes,    // W   always generate stackframes (debugging)
        bsExtendedSyntax, // X   deprecated Delphi directive
        bsReferenceInfo,  // Y   store for each identifier the declaration location
        // Z
        bsHints,
        bsNotes,
        bsWarnings,
        bsMacro,
        bsScopedEnums,
        bsObjectChecks,   // check methods 'Self' and object type casts
        bsPointerMath,    // pointer arithmetic
        bsGoto       // support label and goto, set by {$goto on|off}
        );
    TBoolSwitches = set of TBoolSwitch;

const
    LetterToBoolSwitch: array['A'..'Z'] of TBoolSwitch = (
        bsAlign,          // A
        bsBoolEval,       // B
        bsAssertions,     // C
        bsDebugInfo,      // D or $description
        bsExtension,      // E
        bsNone,           // F
        bsImportedData,   // G
        bsLongStrings,    // H
        bsIOChecks,       // I or $include
        bsWriteableConst, // J
        bsNone,           // K
        bsLocalSymbols,   // L
        bsTypeInfo,       // M or $M minstacksize,maxstacksize
        bsNone,           // N
        bsOptimization,   // O
        bsOpenStrings,    // P
        bsOverflowChecks, // Q
        bsRangeChecks,    // R or $resource
        bsNone,           // S
        bsTypedAddress,   // T
        bsSafeDivide,     // U
        bsVarStringChecks,// V
        bsStackframes,    // W
        bsExtendedSyntax, // X
        bsReferenceInfo,  // Y
        bsNone            // Z
        );

    bsAll = [low(TBoolSwitch)..high(TBoolSwitch)];
    bsFPCMode: TBoolSwitches = [bsPointerMath, bsWriteableConst];
    bsObjFPCMode: TBoolSwitches = [bsPointerMath, bsWriteableConst];
    bsDelphiMode: TBoolSwitches = [bsWriteableConst, bsGoto];
    bsDelphiUnicodeMode: TBoolSwitches = [bsWriteableConst, bsGoto];
    bsMacPasMode: TBoolSwitches = [bsPointerMath, bsWriteableConst];

type
    TValueSwitch = (
        vsInterfaces,
        vsDispatchField,
        vsDispatchStrField
        );
    TValueSwitches = set of TValueSwitch;
    TValueSwitchArray = array[TValueSwitch] of string;

const
    vsAllValueSwitches = [low(TValueSwitch)..high(TValueSwitch)];
    DefaultValueSwitches: array[TValueSwitch] of string = (
        'com', // vsInterfaces
        'Msg', // vsDispatchField
        'MsgStr' // vsDispatchStrField
        );
    DefaultMaxIncludeStackDepth = 20;

type
    TWarnMsgState = (
        wmsDefault,
        wmsOn,
        wmsOff,
        wmsError
        );

type
    TTokenOption = (toForceCaret, toOperatorToken);
    TTokenOptions = set of TTokenOption;


    { TMacroDef }

    TMacroDef = class(TObject)
    private
        FName: string;
        FValue: string;
    public
        constructor Create(const AName, AValue: string);
        property Name: string read FName;
        property Value: string read FValue write FValue;
    end;

    { TLineReader }

    TLineReader = class
    private
        FFilename: string;
    public
        constructor Create(const AFilename: string); virtual;
        function IsEOF: boolean; virtual; abstract;
        function ReadLine: string; virtual; abstract;
        property Filename: string read FFilename;
    end;

    { TFileLineReader }

    TFileLineReader = class(TLineReader)
    private
    {$ifdef pas2js}
    {$else}
        FTextFile: Text;
        FFileOpened: boolean;
        FBuffer: array[0..4096 - 1] of byte;
    {$endif}
    public
        constructor Create(const AFilename: string); override;
        destructor Destroy; override;
        function IsEOF: boolean; override;
        function ReadLine: string; override;
    end;

    { TStreamLineReader }

    TStreamLineReader = class(TLineReader)
    private
        FContent: string;
        FPos: integer;
    public
    {$ifdef HasStreams}
    Procedure InitFromStream(AStream : TStream);
    {$endif}
        procedure InitFromString(const s: string);
        function IsEOF: boolean; override;
        function ReadLine: string; override;
    end;

    { TFileStreamLineReader }

    TFileStreamLineReader = class(TStreamLineReader)
    public
        constructor Create(const AFilename: string); override;
    end;

    { TStringStreamLineReader }

    TStringStreamLineReader = class(TStreamLineReader)
    public
        constructor Create(const AFilename: string; const ASource: string); reintroduce;
    end;

    { TMacroReader }

    TMacroReader = class(TStringStreamLineReader)
    private
        FCurCol: integer;
        FCurRow: integer;
    public
        property CurCol: integer read FCurCol write FCurCol;
        property CurRow: integer read FCurRow write FCurRow;
    end;

    { TBaseFileResolver }

    TBaseFileResolver = class
    private
        FBaseDirectory: string;
        FResourcePaths, FIncludePaths: TStringList;
        FStrictFileCase: boolean;
    protected
        function FindIncludeFileName(const aFilename: string): string; virtual; abstract;
        procedure SetBaseDirectory(AValue: string); virtual;
        procedure SetStrictFileCase(AValue: boolean); virtual;
        property IncludePaths: TStringList read FIncludePaths;
        property ResourcePaths: TStringList read FResourcePaths;
    public
        constructor Create; virtual;
        destructor Destroy; override;
        procedure AddIncludePath(const APath: string); virtual;
        procedure AddResourcePath(const APath: string); virtual;
        function FindResourceFileName(const AName: string): string; virtual; abstract;
        function FindSourceFile(const AName: string): TLineReader; virtual; abstract;
        function FindIncludeFile(const AName: string): TLineReader; virtual; abstract;
        property StrictFileCase: boolean read FStrictFileCase write SetStrictFileCase;
        property BaseDirectory: string read FBaseDirectory write SetBaseDirectory;
    end;

    TBaseFileResolverClass = class of TBaseFileResolver;

{$IFDEF HASFS}
  { TFileResolver }

  TFileResolver = class(TBaseFileResolver)
  private
    {$ifdef HasStreams}
    FUseStreams: Boolean;
    {$endif}
  Protected
    function SearchLowUpCase(FN: string): string;
    Function FindIncludeFileName(const AName: string): String; override;
    Function CreateFileReader(Const AFileName : String) : TLineReader; virtual;
  Public
    function FindResourceFileName(const AFileName: string): String; override;
    function FindSourceFile(const AName: string): TLineReader; override;
    function FindIncludeFile(const AName: string): TLineReader; override;
    {$ifdef HasStreams}
    Property UseStreams : Boolean Read FUseStreams Write FUseStreams;
    {$endif}
  end;
{$ENDIF}

  {$ifdef fpc}
  { TStreamResolver }

  TStreamResolver = class(TBaseFileResolver)
  Private
    FOwnsStreams: Boolean;
    FStreams : TStringList;
    function FindStream(const AName: string; ScanIncludes: Boolean): TStream;
    function FindStreamReader(const AName: string; ScanIncludes: Boolean): TLineReader;
    procedure SetOwnsStreams(AValue: Boolean);
  Protected
    function FindIncludeFileName(const aFilename: string): String; override;
  Public
    constructor Create; override;
    destructor Destroy; override;
    Procedure Clear;
    function FindResourceFileName(const AFileName: string): String; override;
    Procedure AddStream(Const AName : String; AStream : TStream);
    function FindSourceFile(const AName: string): TLineReader; override;
    function FindIncludeFile(const AName: string): TLineReader; override;
    Property OwnsStreams : Boolean Read FOwnsStreams write SetOwnsStreams;
    Property Streams: TStringList read FStreams;
  end;
  {$endif}

const
    CondDirectiveBool: array[boolean] of string = (
        '0', // false
        '1'  // true  Note: True is <>'0'
        );

type
    TMaxPrecInt = {$ifdef fpc}int64{$else}NativeInt{$endif};
    TMaxFloat = {$ifdef fpc}extended{$else}double{$endif};

    TCondDirectiveEvaluator = class;

    TCEEvalVarEvent = function(Sender: TCondDirectiveEvaluator;
        Name: string; out Value: string): boolean of object;
    TCEEvalFunctionEvent = function(Sender: TCondDirectiveEvaluator;
        Name, Param: string; out Value: string): boolean of object;
    TCELogEvent = procedure(Sender: TCondDirectiveEvaluator;
        Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif}) of object;

    { TCondDirectiveEvaluator - evaluate $IF expression }

    TCondDirectiveEvaluator = class
    private
        FOnEvalFunction: TCEEvalFunctionEvent;
        FOnEvalVariable: TCEEvalVarEvent;
        FOnLog: TCELogEvent;
    protected
        type
        TPrecedenceLevel = (
            ceplFirst, // tkNot
            ceplSecond, // *, /, div, mod, and, shl, shr
            ceplThird, // +, -, or, xor
            ceplFourth // =, <>, <, >, <=, >=
        );

        TStackItem = record
            Level: TPrecedenceLevel;
            Operathor: TToken;
            Operand: string;
            OperandPos: integer;
        end;
    protected
    {$ifdef UsePChar}
        FTokenStart: PChar;
        FTokenEnd: PChar;
    {$else}
        FTokenStart: integer; // position in Expression
        FTokenEnd: integer; // position in Expression
    {$endif}
        FToken: TToken;
        FStack: array of TStackItem;
        FStackTop: integer;
        function IsFalse(const Value: string): boolean; inline;
        function IsTrue(const Value: string): boolean; inline;
        function IsInteger(const Value: string; out i: TMaxPrecInt): boolean;
        function IsExtended(const Value: string; out e: TMaxFloat): boolean;
        procedure NextToken;
        procedure Log(aMsgType: TMessageType; aMsgNumber: integer;
            const aMsgFmt: string;
            const Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif}; MsgPos: integer = 0);
        procedure LogXExpectedButTokenFound(const X: string; ErrorPos: integer = 0);
        procedure ReadOperand(Skip: boolean = False); // unary operators plus one operand
        procedure ReadExpression; // binary operators
        procedure ResolveStack(MinStackLvl: integer; Level: TPrecedenceLevel;
            NewOperator: TToken);
        function GetTokenString: string;
        function GetStringLiteralValue: string; // read value of tkString
        procedure Push(const AnOperand: string; OperandPosition: integer);
    public
        Expression: string;
        MsgPos: integer;
        MsgNumber: integer;
        MsgType: TMessageType;
        MsgPattern: string; // Format parameter
        constructor Create;
        destructor Destroy; override;
        function Eval(const Expr: string): boolean;
        property OnEvalVariable: TCEEvalVarEvent
            read FOnEvalVariable write FOnEvalVariable;
        property OnEvalFunction: TCEEvalFunctionEvent
            read FOnEvalFunction write FOnEvalFunction;
        property OnLog: TCELogEvent read FOnLog write FOnLog;
    end;

    EScannerError = class(Exception);
    EFileNotFoundError = class(Exception);

    TCSharpScannerCSSkipMode = (csSkipNone, csSkipIfBranch, csSkipElseBranch, csSkipAll);

    TCSOption = (
        po_KeepScannerError,
        // default: catch EScannerError and raise an EParserError instead
        po_CAssignments,         // allow C-operators += -= *= /=
        po_ResolveStandardTypes,
        // search for 'longint', 'string', etc., do not use dummies, TPasResolver sets this to use its declarations
        po_AsmWhole,
        // store whole text between asm..end in TPasImplAsmStatement.Tokens
        po_NoOverloadedProcs,
        // do not create TPasOverloadedProc for procs with same name
        po_KeepClassForward,
        // disabled: delete class fowards when there is a class declaration
        po_ArrayRangeExpr,
        // enable: create TPasArrayType.IndexRange, disable: create TPasArrayType.Ranges
        po_SelfToken,            // Self is a token. For backward compatibility.
        po_CheckModeSwitches,    // error on unknown modeswitch with an error
        po_CheckCondFunction,
        // error on unknown function in conditional expression, default: return '0'
        po_StopOnErrorDirective, // error on user $Error, $message error|fatal
        po_ExtConstWithoutExpr,
        // allow typed const without expression in external class and with external modifier
        po_StopOnUnitInterface,  // parse only a unit name and stop at interface keyword
        po_IgnoreUnknownResource,// Ignore resources for which no handler is registered.
        po_AsyncProcs            // allow async procedure modifier
        );
    TCShOptions = set of TCSOption;

type
    TCShSourcePos = record
        FileName: string;
        Row, Column: cardinal;
    end;

const
    DefCShSourcePos: TCShSourcePos = (Filename: ''; Row: 0; Column: 0);

type
    { TCSharpScanner }

    TCShScannerLogHandler = procedure(Sender: TObject; const Msg: string) of object;
    TCShScannerLogEvent = (sleFile, sleLineNumber, sleConditionals, sleDirective);
    TCShScannerLogEvents = set of TCShScannerLogEvent;
    TCShScannerDirectiveEvent = procedure(Sender: TObject;
        Directive, Param: string; var Handled: boolean) of object;
    TCShScannerCommentEvent = procedure(Sender: TObject; aComment: string) of object;
    TCShScannerFormatPathEvent = function(const aPath: string): string of object;
    TCShScannerWarnEvent = procedure(Sender: TObject; Identifier: string;
        State: TWarnMsgState; var Handled: boolean) of object;
    TCShScannerModeDirective = procedure(Sender: TObject; NewMode: TModeSwitch;
        Before: boolean; var Handled: boolean) of object;

    // aFileName: full filename (search is already done) aOptions: list of name:value pairs.
    TResourceHandler = procedure(Sender: TObject; const aFileName: string;
        aOptions: TStrings) of object;

    TCShScannerTokenPos = {$ifdef UsePChar}PChar{$else}integer{$endif};

    TCSharpScanner = class
    private
        type
        TResourceHandlerRecord = record
            Ext: string;
            Handler: TResourceHandler;
        end;

        TWarnMsgNumberState = record
            Number: integer;
            State: TWarnMsgState;
        end;
        TWarnMsgNumberStateArr = array of TWarnMsgNumberState;
    private
        FAllowedBoolSwitches: TBoolSwitches;
        FAllowedModeSwitches: TModeSwitches;
        FAllowedValueSwitches: TValueSwitches;
        FConditionEval: TCondDirectiveEvaluator;
        FCurrentBoolSwitches: TBoolSwitches;
        FCurrentModeSwitches: TModeSwitches;
        FCurrentValueSwitches: TValueSwitchArray;
        FCurTokenPos: TCShSourcePos;
        FLastMsg: string;
        FLastMsgArgs: TMessageArgs;
        FLastMsgNumber: integer;
        FLastMsgPattern: string;
        FLastMsgType: TMessageType;
        FFileResolver: TBaseFileResolver;
        FCurSourceFile: TLineReader;
        FCurFilename: string;
        FCurRow: integer;
        FCurColumnOffset: integer;
        FCurToken: TToken;
        FCurTokenString: string;
        FCurLine: string;
        FMaxIncludeStackDepth: integer;
        FModuleRow: integer;
        FMacros: TStrings; // Objects are TMacroDef
        FDefines: TStrings;
        FNonTokens: TTokens;
        FOnComment: TCShScannerCommentEvent;
        FOnDirective: TCShScannerDirectiveEvent;
        FOnEvalFunction: TCEEvalFunctionEvent;
        FOnEvalVariable: TCEEvalVarEvent;
        FOnFormatPath: TCShScannerFormatPathEvent;
        FOnModeChanged: TCShScannerModeDirective;
        FOnWarnDirective: TCShScannerWarnEvent;
        FOptions: TCShOptions;
        FLogEvents: TCShScannerLogEvents;
        FOnLog: TCShScannerLogHandler;
        FPreviousToken: TToken;
        FReadOnlyBoolSwitches: TBoolSwitches;
        FReadOnlyModeSwitches: TModeSwitches;
        FReadOnlyValueSwitches: TValueSwitches;
        FSkipComments: boolean;
        FSkipGlobalSwitches: boolean;
        FSkipWhiteSpace: boolean;
        FTokenOptions: TTokenOptions;
        FTokenPos: TCShScannerTokenPos; // position in FCurLine }
        FIncludeStack: TFPList;
        FFiles: TStrings;
        FWarnMsgStates: TWarnMsgNumberStateArr;
        FResourceHandlers: array of TResourceHandlerRecord;

        // Preprocessor $IFxxx skipping data
        CShSkipMode: TCSharpScannerCSSkipMode;
        CShIsSkipping: boolean;
        CShSkipStackIndex: integer;
        CShSkipModeStack: array[0..255] of TCSharpScannerCSSkipMode;
        CShIsSkippingStack: array[0..255] of boolean;
        function GetCurColumn: integer;
        function GetCurrentValueSwitch(V: TValueSwitch): string;
        function GetForceCaret: boolean;
        function GetMacrosOn: boolean;
        function IndexOfWarnMsgState(Number: integer; InsertPos: boolean): integer;
        function OnCondEvalFunction(Sender: TCondDirectiveEvaluator;
            Name, Param: string; out Value: string): boolean;
        procedure OnCondEvalLog(Sender: TCondDirectiveEvaluator;
            Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif});
        function OnCondEvalVar(Sender: TCondDirectiveEvaluator;
            Name: string; out Value: string): boolean;
        procedure SetAllowedBoolSwitches(const AValue: TBoolSwitches);
        procedure SetAllowedModeSwitches(const AValue: TModeSwitches);
        procedure SetAllowedValueSwitches(const AValue: TValueSwitches);
        procedure SetMacrosOn(const AValue: boolean);
        procedure SetOptions(AValue: TCShOptions);
        procedure SetReadOnlyBoolSwitches(const AValue: TBoolSwitches);
        procedure SetReadOnlyModeSwitches(const AValue: TModeSwitches);
        procedure SetReadOnlyValueSwitches(const AValue: TValueSwitches);
    protected
        // extension without initial dot (.)
        function IndexOfResourceHandler(const aExt: string): integer;
        function FindResourceHandler(const aExt: string): TResourceHandler;
        function ReadIdentifier(const AParam: string): string;
        function FetchLine: boolean;
        procedure AddFile(aFilename: string); virtual;
        function GetMacroName(const Param: string): string;
        procedure SetCurMsg(MsgType: TMessageType; MsgNumber: integer;
            const Fmt: string;
            Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif});
        procedure DoLog(MsgType: TMessageType; MsgNumber: integer;
            const Msg: string; SkipSourceInfo: boolean = False); overload;
        procedure DoLog(MsgType: TMessageType; MsgNumber: integer;
            const Fmt: string;
            Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif}; SkipSourceInfo: boolean = False); overload;
        procedure Error(MsgNumber: integer; const Msg: string); overload;
        procedure Error(MsgNumber: integer; const Fmt: string;
            Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif}); overload;
        procedure PushSkipMode;
        function HandleDirective(const ADirectiveText: string): TToken; virtual;
        function HandleLetterDirective(Letter: char; Enable: boolean): TToken; virtual;
        procedure HandleBoolDirective(bs: TBoolSwitch; const Param: string); virtual;
        procedure DoHandleComment(Sender: TObject; const aComment: string); virtual;
        procedure DoHandleDirective(Sender: TObject; Directive, Param: string;
            var Handled: boolean); virtual;
        procedure HandleIFDEF(const AParam: string);
        procedure HandleIFNDEF(const AParam: string);
        procedure HandleIF(const AParam: string);
        procedure HandleELSEIF(const AParam: string);
        procedure HandleELSE(const AParam: string);
        procedure HandleENDIF(const AParam: string);
        procedure HandleDefine(Param: string); virtual;
        procedure HandleError(Param: string); virtual;
        procedure HandleLine(Param: string); virtual;
        procedure HandleRegion(Param: string); virtual;
        procedure HandleEndRegion(Param: string); virtual;
        procedure HandlePragma(Param: string); virtual;
        procedure HandleIncludeFile(Param: string); virtual;
        procedure HandleResource(Param: string); virtual;
        procedure HandleOptimizations(Param: string); virtual;
        procedure DoHandleOptimization(OptName, OptValue: string); virtual;

        procedure HandleUnDefine(Param: string); virtual;

        function HandleInclude(const Param: string): TToken; virtual;
        procedure HandleInterfaces(const Param: string); virtual;
        procedure HandleWarn(Param: string); virtual;
        procedure HandleWarnIdentifier(Identifier, Value: string); virtual;
        procedure PushStackItem; virtual;
        function DoFetchTextToken(ModeChar: char = #0): TToken;
        function DoFetchToken: TToken;
        procedure ClearFiles;
        procedure ClearMacros;
        procedure SetCurToken(const AValue: TToken);
        procedure SetCurTokenString(const AValue: string);
        procedure SetCurrentBoolSwitches(const AValue: TBoolSwitches); virtual;deprecated 'not use';
        procedure SetCurrentModeSwitches(AValue: TModeSwitches); virtual;deprecated 'not use';
        procedure SetCurrentValueSwitch(V: TValueSwitch; const AValue: string);
        procedure SetWarnMsgState(Number: integer; State: TWarnMsgState); virtual;
        function GetWarnMsgState(Number: integer): TWarnMsgState; virtual;
        function LogEvent(E: TCShScannerLogEvent): boolean; inline;
        property TokenPos: TCShScannerTokenPos read FTokenPos write FTokenPos;
    public
        constructor Create(AFileResolver: TBaseFileResolver);
        destructor Destroy; override;
        // extension without initial dot  (.), case insensitive
        procedure RegisterResourceHandler(aExtension: string;
            aHandler: TResourceHandler); overload;
        procedure RegisterResourceHandler(aExtensions: array of string;
            aHandler: TResourceHandler); overload;
        procedure OpenFile(AFilename: string);
        procedure FinishedModule; virtual; // called by parser after end.
        function FormatPath(const aFilename: string): string; virtual;
        procedure SetNonToken(aToken: TToken);
        procedure UnsetNonToken(aToken: TToken);
        procedure SetTokenOption(aOption: TTokenoption);
        procedure UnSetTokenOption(aOption: TTokenoption);
        function CheckToken(aToken: TToken; const ATokenString: string): TToken;
        function FetchToken: TToken;
        function ReadNonPascalTillEndToken(StopAtLineEnd: boolean): TToken; virtual;
        function AddDefine(const aName: string; Quiet: boolean = False): boolean;
        function RemoveDefine(const aName: string; Quiet: boolean = False): boolean;
        function UnDefine(const aName: string; Quiet: boolean = False): boolean;
        // check defines and macros
        function IsDefined(const aName: string): boolean; // check defines and macros
        function IfOpt(Letter: char): boolean;
        function AddMacro(const aName, aValue: string; Quiet: boolean = False): boolean;
        function RemoveMacro(const aName: string; Quiet: boolean = False): boolean;
        procedure SetCompilerMode(S: string);
        function CurSourcePos: TCShSourcePos;
        function SetForceCaret(AValue: boolean): boolean; // returns old state
        function IgnoreMsgType(MsgType: TMessageType): boolean; virtual;
        property FileResolver: TBaseFileResolver read FFileResolver;
        property Files: TStrings read FFiles;
        property CurSourceFile: TLineReader read FCurSourceFile;
        property CurFilename: string read FCurFilename;
        property CurLine: string read FCurLine;
        property CurRow: integer read FCurRow;
        property CurColumn: integer read GetCurColumn;
        property CurToken: TToken read FCurToken;
        property CurTokenString: string read FCurTokenString;
        property CurTokenPos: TCShSourcePos read FCurTokenPos;
        property PreviousToken: TToken read FPreviousToken;
        property ModuleRow: integer read FModuleRow;
        property NonTokens: TTokens read FNonTokens;
        property TokenOptions: TTokenOptions read FTokenOptions write FTokenOptions;
        property Defines: TStrings read FDefines;
        property Macros: TStrings read FMacros;
        property MacrosOn: boolean read GetMacrosOn write SetMacrosOn;
        property AllowedModeSwitches: TModeSwitches
            read FAllowedModeSwitches write SetAllowedModeSwitches;
        property ReadOnlyModeSwitches: TModeSwitches
            read FReadOnlyModeSwitches write SetReadOnlyModeSwitches;
        // always set, cannot be disabled
        property CurrentModeSwitches: TModeSwitches
            read FCurrentModeSwitches write SetCurrentModeSwitches;
        property AllowedBoolSwitches: TBoolSwitches
            read FAllowedBoolSwitches write SetAllowedBoolSwitches;
        property ReadOnlyBoolSwitches: TBoolSwitches
            read FReadOnlyBoolSwitches write SetReadOnlyBoolSwitches;// cannot be changed by code
        property CurrentBoolSwitches: TBoolSwitches
            read FCurrentBoolSwitches write SetCurrentBoolSwitches;
        property AllowedValueSwitches: TValueSwitches
            read FAllowedValueSwitches write SetAllowedValueSwitches;
        property ReadOnlyValueSwitches: TValueSwitches
            read FReadOnlyValueSwitches write SetReadOnlyValueSwitches;// cannot be changed by code
        property CurrentValueSwitch[V: TValueSwitch]: string
            read GetCurrentValueSwitch write SetCurrentValueSwitch;
        property WarnMsgState[Number: integer]: TWarnMsgState
            read GetWarnMsgState write SetWarnMsgState;
        property Options: TCShOptions read FOptions write SetOptions;
        property SkipWhiteSpace: boolean read FSkipWhiteSpace write FSkipWhiteSpace;
        property SkipComments: boolean read FSkipComments write FSkipComments;
        property SkipGlobalSwitches: boolean
            read FSkipGlobalSwitches write FSkipGlobalSwitches;
        property MaxIncludeStackDepth: integer
            read FMaxIncludeStackDepth write FMaxIncludeStackDepth default
            DefaultMaxIncludeStackDepth;
        property ForceCaret: boolean read GetForceCaret;

        property LogEvents: TCShScannerLogEvents read FLogEvents write FLogEvents;
        property OnLog: TCShScannerLogHandler read FOnLog write FOnLog;
        property OnFormatPath: TCShScannerFormatPathEvent
            read FOnFormatPath write FOnFormatPath;
        property ConditionEval: TCondDirectiveEvaluator read FConditionEval;
        property OnEvalVariable: TCEEvalVarEvent
            read FOnEvalVariable write FOnEvalVariable;
        property OnEvalFunction: TCEEvalFunctionEvent
            read FOnEvalFunction write FOnEvalFunction;
        property OnWarnDirective: TCShScannerWarnEvent
            read FOnWarnDirective write FOnWarnDirective;
        property OnModeChanged: TCShScannerModeDirective
            read FOnModeChanged write FOnModeChanged; // set by TPasParser
        property OnDirective: TCShScannerDirectiveEvent
            read FOnDirective write FOnDirective;
        property OnComment: TCShScannerCommentEvent read FOnComment write FOnComment;


        property LastMsg: string read FLastMsg write FLastMsg;
        property LastMsgNumber: integer read FLastMsgNumber write FLastMsgNumber;
        property LastMsgType: TMessageType read FLastMsgType write FLastMsgType;
        property LastMsgPattern: string read FLastMsgPattern write FLastMsgPattern;
        property LastMsgArgs: TMessageArgs read FLastMsgArgs write FLastMsgArgs;
    end;

const
    TokenInfos: array[TToken] of string = (
        'EOF',
        'Whitespace',
        'Identifier',
        'Label',
        'StringConst',
        'Number',
        'Character',
        'LineEnding',
        'Tab',

        '//',
        '/*',

        // Simple (one-character) tokens
        '{',
        '}',
        '(',
        ')',
        '*',
        '+',
        ',',
        '-',
        '.',
        '/',
        ':',
        ';',
        '<',
        '=',
        '>',
 //       '@',
        '[',
        ']',
        '^',
        '\',
        '&',
        '|',
        '!',
        '?',
        '%',
        '~',
        // Two-character tokens
        '==',
        '=>',
        '..',
        '!=',
        '<=',
        '>=',
        '**',
        '><',
        '??',
        '++',
        '--',
        '+=',
        '-=',
        '*=',
        '/=',
        '%=',
        '&=',
        '|=',
        '^=',
        '&&',
        '||',
        '<<',
        '>>',
        // Three-Character Tokens
        '<<=',
        '>>=',
        '??=',
        // Reserved words
        'abstract', 'as', 'base', 'bool',
        'break', 'byte', 'case', 'catch',
        'char', 'checked', 'class', 'const',
        'continue', 'decimal', 'default', 'delegate',
        'do', 'double', 'else', 'enum',
        'event', 'explicit', 'extern', 'false',
        'finally', 'fixed', 'float', 'for',
        'foreach', 'goto', 'if', 'implicit',
        'in', 'int', 'interface', 'internal',
        'is', 'lock', 'long', 'namespace',
        'new', 'null', 'object', 'operator',
        'out', 'override', 'params', 'private',
        'protected', 'public', 'readonly', 'ref',
        'return', 'sbyte', 'sealed', 'short',
        'sizeof', 'stackalloc', 'static', 'string',
        'struct', 'switch', 'this', 'throw',
        'true', 'try', 'typeof', 'uint',
        'ulong', 'unchecked', 'unsafe', 'ushort',
        'using', 'virtual', 'void', 'volatile',
        'while');

    SModeSwitchNames: array[TModeSwitch] of string =
        ('');

    LetterSwitchNames: array['A'..'Z'] of string = (
        'ALIGN'          // A   align fields
        , 'BOOLEVAL'       // B   complete boolean evaluation
        , 'ASSERTIONS'     // C   generate code for assertions
        , 'DEBUGINFO'      // D   generate debuginfo (debug lines), OR: $description 'text'
        , 'EXTENSION'      // E   output file extension
        , ''               // F
        , 'IMPORTEDDATA'   // G
        , 'LONGSTRINGS'    // H   String=AnsiString
        , 'IOCHECKS'       // I   generate EInOutError
        , 'WRITEABLECONST' // J   writable typed const
        , ''               // K
        , 'LOCALSYMBOLS'   // L   generate local symbol information (debug, requires $D+)
        , 'TYPEINFO'       // M   allow published members OR $M minstacksize,maxstacksize
        , ''               // N
        , 'OPTIMIZATION'   // O   enable safe optimizations (-O1)
        , 'OPENSTRINGS'    // P   deprecated Delphi directive
        , 'OVERFLOWCHECKS' // Q
        , 'RANGECHECKS'    // R   OR resource
        , ''               // S
        , 'TYPEDADDRESS'
        // T   enabled: @variable gives typed pointer, otherwise untyped pointer
        , 'SAFEDIVIDE'     // U
        , 'VARSTRINGCHECKS'
        // V   strict shortstring checking, e.g. cannot pass shortstring[3] to shortstring
        , 'STACKFRAMES'    // W   always generate stackframes (debugging)
        , 'EXTENDEDSYNTAX' // X   deprecated Delphi directive
        , 'REFERENCEINFO'  // Y   store for each identifier the declaration location
        , ''               // Z
        );

    BoolSwitchNames: array[TBoolSwitch] of string = (
        // letter directives
        'None',
        'Align',
        'BoolEval',
        'Assertions',
        'DebugInfo',
        'Extension',
        'ImportedData',
        'LongStrings',
        'IOChecks',
        'WriteableConst',
        'LocalSymbols',
        'TypeInfo',
        'Optimization',
        'OpenStrings',
        'OverflowChecks',
        'RangeChecks',
        'TypedAddress',
        'SafeDivide',
        'VarStringChecks',
        'Stackframes',
        'ExtendedSyntax',
        'ReferenceInfo',
        // other bool directives
        'Hints',
        'Notes',
        'Warnings',
        'Macro',
        'ScopedEnums',
        'ObjectChecks',
        'PointerMath',
        'Goto'
        );

    ValueSwitchNames: array[TValueSwitch] of string = (
        'Interfaces', // vsInterfaces
        'DispatchField', // vsDispatchField
        'DispatchStrField' // vsDispatchStrField
        );

const
    MessageTypeNames: array[TMessageType] of string = (
        'Fatal', 'Error', 'Warning', 'Note', 'Hint', 'Info', 'Debug'
        );

const
    // all mode switches supported by FPC
    msAllModeSwitches = [low(TModeSwitch)..High(TModeSwitch)];

function StrToModeSwitch(aName: string): TModeSwitch;
function ModeSwitchesToStr(Switches: TModeSwitches): string;
function BoolSwitchesToStr(Switches: TBoolSwitches): string;

function FilenameIsAbsolute(const TheFilename: string): boolean;
function FilenameIsWinAbsolute(const TheFilename: string): boolean;
function FilenameIsUnixAbsolute(const TheFilename: string): boolean;
function IsNamedToken(const AToken: string; Out T: TToken): boolean;
function ExtractFilenameOnly(const AFileName: string): string;

procedure CreateMsgArgs(var MsgArgs: TMessageArgs;
    Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif});
function SafeFormat(const Fmt: string;
    Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif}): string;

implementation

const
    IdentChars = ['0'..'9', 'A'..'Z', 'a'..'z', '_'];
    Digits = ['0'..'9'];
    Letters = ['a'..'z', 'A'..'Z'];
    HexDigits = ['0'..'9', 'a'..'f', 'A'..'F'];
    WhiteSpace = [' ',#9,#10,#13,#255];

Type TTokenKey=record
        token:TToken;
        key:string;
        l:integer  // length of the key;
     end;
     TTokenKeyArray= array of TTokenkey;
var
    SortedTokens: array of TToken;
    LowerCaseTokens: array[ttoken] of string;
    TokenIndex:array[char] of TTokenKeyArray;

function ExtractFilenameOnly(const AFileName: string): string;

begin
    Result := ChangeFileExt(ExtractFileName(aFileName), '');
end;


procedure SortTokenInfo;

var
    tk: tToken;
    I, J, K, l: integer;

begin
    for tk := Low(TToken) to High(ttoken) do
        LowerCaseTokens[tk] := LowerCase(TokenInfos[tk]);
    SetLength(SortedTokens, Ord(high(TToken)) - Ord(tkAbstract) + 1);
    I := 0;
    for tk := tkAbstract to high(TToken) do
      begin
        SortedTokens[i] := tk;
        Inc(i);
      end;
    l := Length(SortedTokens) - 1;
    k := l shr 1;
    while (k > 0) do
      begin
        for i := 0 to l - k do
          begin
            j := i;
            while (J >= 0) and (LowerCaseTokens[SortedTokens[J]] >
                    LowerCaseTokens[SortedTokens[J + K]]) do
              begin
                tk := SortedTokens[J];
                SortedTokens[J] := SortedTokens[J + K];
                SortedTokens[J + K] := tk;
                if (J > K) then
                    Dec(J, K)
                else
                    J := 0;
              end;
          end;
        K := K shr 1;
      end;
end;

function IndexOfToken(const AToken: string): integer;

var
    B, T, M: integer;
    N: string;
begin
    B := 0;
    T := Length(SortedTokens) - 1;
    while (B <= T) do
      begin
        M := (B + T) div 2;
        N := LowerCaseTokens[SortedTokens[M]];
        if (AToken < N) then
            T := M - 1
        else if (AToken = N) then
            Exit(M)
        else
            B := M + 1;
      end;
    Result := -1;
end;

function IsNamedToken(const AToken: string; Out T: TToken): boolean;

var
    I: integer;

begin
    if (Length(SortedTokens) = 0) then
        SortTokenInfo;
    I := IndexOfToken(LowerCase(AToken));
    Result := I <> -1;
    if Result then
        T := SortedTokens[I];
end;

procedure CreateMsgArgs(var MsgArgs: TMessageArgs;
    Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif});
var
    i: integer;
  {$ifdef pas2js}
  v: jsvalue;
  {$endif}
begin
    SetLength(MsgArgs, High(Args) - Low(Args) + 1);
    for i := Low(Args) to High(Args) do
    {$ifdef pas2js}
    begin
    v:=Args[i];
    if isBoolean(v) then
      MsgArgs[i] := BoolToStr(Boolean(v))
    else if isString(v) then
      MsgArgs[i] := String(v)
    else if isNumber(v) then
      begin
      if IsInteger(v) then
        MsgArgs[i] := str(NativeInt(v))
      else
        MsgArgs[i] := str(double(v));
      end
    else
      MsgArgs[i]:='';
    end;
    {$else}
        case Args[i].VType of
            vtInteger: MsgArgs[i] := IntToStr(Args[i].VInteger);
            vtBoolean: MsgArgs[i] := BoolToStr(Args[i].VBoolean);
            vtChar: MsgArgs[i] := Args[i].VChar;
      {$ifndef FPUNONE}
            vtExtended: ; //  Args[i].VExtended^;
      {$ENDIF}
            vtString: MsgArgs[i] := Args[i].VString^;
            vtPointer: ; //  Args[i].VPointer;
            vtPChar: MsgArgs[i] := Args[i].VPChar;
            vtObject: ; //  Args[i].VObject;
            vtClass: ; //  Args[i].VClass;
            vtWideChar: MsgArgs[i] := ansistring(Args[i].VWideChar);
            vtPWideChar: MsgArgs[i] := Args[i].VPWideChar;
            vtAnsiString: MsgArgs[i] := ansistring(Args[i].VAnsiString);
            vtCurrency: ; //  Args[i].VCurrency^);
            vtVariant: ; //  Args[i].VVariant^);
            vtInterface: ; //  Args[i].VInterface^);
            vtWidestring: MsgArgs[i] := ansistring(WideString(Args[i].VWideString));
            vtInt64: MsgArgs[i] := IntToStr(Args[i].VInt64^);
            vtQWord: MsgArgs[i] := IntToStr(Args[i].VQWord^);
            vtUnicodeString: MsgArgs[i] :=
                    ansistring(UnicodeString(Args[i].VUnicodeString));
          end;
    {$endif}
end;

function SafeFormat(const Fmt: string;
    Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif}): string;
var
    MsgArgs: TMessageArgs;
    i: integer;
begin
      try
        Result := Format(Fmt, Args);
      except
        Result := '';
        MsgArgs := nil;
        CreateMsgArgs(MsgArgs, Args);
        for i := 0 to length(MsgArgs) - 1 do
          begin
            if i > 0 then
                Result := Result + ',';
            Result := Result + MsgArgs[i];
          end;
        Result := '{' + Fmt + '}[' + Result + ']';
      end;
end;

type
    TIncludeStackItem = class
        SourceFile: TLineReader;
        Filename: string;
        Token: TToken;
        TokenString: string;
        Line: string;
        Row: integer;
        ColumnOffset: integer;
        TokenPos: {$ifdef UsePChar}PChar;
{$else}integer; { position in Line }{$endif}
    end;

function StrToModeSwitch(aName: string): TModeSwitch;
var
    ms: TModeSwitch;
begin
    aName := UpperCase(aName);
    if aName = '' then
        exit(msNone);
    for ms in TModeSwitch do
        if SModeSwitchNames[ms] = aName then
            exit(ms);
    Result := msNone;
end;

function ModeSwitchesToStr(Switches: TModeSwitches): string;
var
    ms: TModeSwitch;
begin
    Result := '';
    for ms in Switches do
        Result := Result + SModeSwitchNames[ms] + ',';
    Result := '[' + LeftStr(Result, length(Result) - 1) + ']';
end;

function BoolSwitchesToStr(Switches: TBoolSwitches): string;
var
    bs: TBoolSwitch;
begin
    Result := '';
    for bs in Switches do
        Result := Result + BoolSwitchNames[bs] + ',';
    Result := '[' + LeftStr(Result, length(Result) - 1) + ']';
end;

function FilenameIsAbsolute(const TheFilename: string): boolean;
begin
  {$IFDEF WINDOWS}
  // windows
  Result:=FilenameIsWinAbsolute(TheFilename);
  {$ELSE}
    // unix
    Result := FilenameIsUnixAbsolute(TheFilename);
  {$ENDIF}
end;

function FilenameIsWinAbsolute(const TheFilename: string): boolean;
begin
    Result := ((length(TheFilename) >= 2) and (TheFilename[1] in
        Letters ) and (TheFilename[2] = ':')) or
        ((length(TheFilename) >= 2) and (TheFilename[1] = '\') and
        (TheFilename[2] = '\'));
end;

function FilenameIsUnixAbsolute(const TheFilename: string): boolean;
begin
    Result := (TheFilename <> '') and (TheFilename[1] = '/');
end;

{ TCondDirectiveEvaluator }

// inline
function TCondDirectiveEvaluator.IsFalse(const Value: string): boolean;
begin
    Result := Value = CondDirectiveBool[False];
end;

// inline
function TCondDirectiveEvaluator.IsTrue(const Value: string): boolean;
begin
    Result := Value <> CondDirectiveBool[False];
end;

function TCondDirectiveEvaluator.IsInteger(const Value: string;
    out i: TMaxPrecInt): boolean;
var
    Code: integer;
begin
    val(Value, i, Code);
    Result := Code = 0;
end;

function TCondDirectiveEvaluator.IsExtended(const Value: string;
    out e: TMaxFloat): boolean;
var
    Code: integer;
begin
    val(Value, e, Code);
    Result := Code = 0;
end;

procedure TCondDirectiveEvaluator.NextToken;

  {$ifdef UsePChar}
    function IsIdentifier(a: PChar; b: string): boolean;
    var
        ac: char;
        bx: integer = 1;

    begin
        repeat
            ac := a^;
            if (ac in IdentChars) and (upcase(ac) = upcase(b[bx])) then
              begin
                Inc(a);
                Inc(bx);
              end
            else
              begin
                Result := (not (ac in IdentChars)) and (not (b[bx] in IdentChars));
                exit;
              end;
        until False;
    end;

  {$endif}

    function ReadIdentifier: TToken;
          {$ifndef UsePChar}
     var   tt: TToken;    {$endif}
    begin
        Result := tkIdentifier;
   {$ifdef UsePChar}
        case FTokenEnd - FTokenStart of
            2:
                if IsIdentifier(FTokenStart, TokenInfos[tkor]) then
                    Result := tkor;
            3:
                if IsIdentifier(FTokenStart, TokenInfos[tknot]) then
                    Result := tknot
                else if IsIdentifier(FTokenStart, TokenInfos[tkand]) then
                    Result := tkand
                else if IsIdentifier(FTokenStart, TokenInfos[tkxor]) then
                    Result := tkxor
                else if IsIdentifier(FTokenStart, TokenInfos[tkshl]) then
                    Result := tkshl
                else if IsIdentifier(FTokenStart, TokenInfos[tkshr]) then
                    Result := tkshr
                else if IsIdentifier(FTokenStart, TokenInfos[tkor]) then
                    Result := tkmod;
          end;
    {$else}
        for tt in [tkor, tknot, tkand, tkxor, tkshr, tkmod] do
            if copy(Expression, FTokenStart, FTokenEnd - FTokenStart) =
                TokenInfos[tt] then
                Result := tt;
    {$endif}
    end;

{$ifndef UsePChar}
const
    AllSpaces = [#9, #10, #13, ' '];
    Digits = ['0'..'9'];
    HexDigits = ['0'..'9'];
var
    l: integer;
    Src: string;
{$endif}

 function FetchActChar:char;inline;
 begin
   {$ifdef UsePChar}
          result := FTokenEnd^
   {$else}
         if l>=FTokenEnd then
           result :=Src[FTokenEnd]
         else
           result :=#0;
   {$endif}

 end;

 function FetchNextChar:char;inline;
 begin
   {$ifdef UsePChar}
          result := FTokenEnd[1]
   {$else}
         if l>FTokenEnd then
           result :=Src[FTokenEnd+1]
         else
           result :=#0;
   {$endif}

 end;

begin
    FTokenStart := FTokenEnd;

    // skip white space
  {$ifdef UsePChar}
    repeat
        case FetchActChar of
            #0:
                if FTokenEnd - PChar(Expression) >= length(Expression) then
                  begin
                    FToken := tkEOF;
                    FTokenStart := FTokenEnd;
                    exit;
                  end
                else
                    Inc(FTokenEnd);
            #9, #10, #13, ' ':
                Inc(FTokenEnd);
            else
                break;
          end;
    until False;
  {$else}
    Src := Expression;
    l := length(Src);
    while (FTokenEnd <= l) and (Src[FTokenEnd] in AllSpaces) do
        Inc(FTokenEnd);
    if FTokenEnd > l then
      begin
        FToken := tkEOF;
        FTokenStart := FTokenEnd;
        exit;
      end;
  {$endif}

    // read token
    FTokenStart := FTokenEnd;
    case FetchActChar  of
        'a'..'z', 'A'..'Z', '_':
          begin
            Inc(FTokenEnd);
            while FetchActChar in IdentChars do
                Inc(FTokenEnd);
            FToken := ReadIdentifier;
          end;
        '(':
          begin
            FToken := tkBraceOpen;
            Inc(FTokenEnd);
          end;
        ')':
          begin
            FToken := tkBraceClose;
            Inc(FTokenEnd);
          end;
        '^':
          begin
            FToken := tkXor;
            Inc(FTokenEnd);
          end;
        '&':
          begin
            FToken := tkSingleAnd;
            Inc(FTokenEnd);
            if FetchActChar = '&' then
              begin
                FToken := tkand;
                Inc(FTokenEnd);
              end;
          end;
        '|':
          begin
            FToken := tkSingleOr;
            Inc(FTokenEnd);
            if FetchActChar = '|' then
              begin
                FToken := tkor;
                Inc(FTokenEnd);
              end;
          end;
        '=':
          begin
            FToken := tkAssign;
            Inc(FTokenEnd);
            if FetchActChar = '=' then
              begin
                FToken := tkEqual;
                Inc(FTokenEnd);
              end;
          end;
        '!':
          begin
            Inc(FTokenEnd);
            case FetchActChar                of
                '=':
                  begin
                    FToken := tkNotEqual;
                    Inc(FTokenEnd);
                  end;
                else
                    FToken := tkNot;
              end;
          end;
        else
            FToken := tkEOF;
      end;
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TCondDirectiveEvaluator.NextToken END Token[',FTokenStart-PChar(Expression)+1,']="',GetTokenString,'" ',FToken);
  {$ENDIF}
end;

procedure TCondDirectiveEvaluator.Log(aMsgType: TMessageType;
    aMsgNumber: integer; const aMsgFmt: string;
    const Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif}; MsgPos: integer);
begin
    if MsgPos < 1 then
        MsgPos := FTokenEnd
{$ifdef UsePChar}
            - PChar(Expression) + 1
{$endif}
    ;
    MsgType := aMsgType;
    MsgNumber := aMsgNumber;
    MsgPattern := aMsgFmt;
    if Assigned(OnLog) then
      begin
        OnLog(Self, Args);
        if not (aMsgType in [mtError, mtFatal]) then
            exit;
      end;
    raise EScannerError.CreateFmt(MsgPattern + ' at ' + IntToStr(MsgPos), Args);
end;

procedure TCondDirectiveEvaluator.LogXExpectedButTokenFound(const X: string;
    ErrorPos: integer);
begin
    Log(mtError, nErrXExpectedButYFound, SErrXExpectedButYFound,
        [X, TokenInfos[FToken]], ErrorPos);
end;

procedure TCondDirectiveEvaluator.ReadOperand(Skip: boolean);
{ Read operand and put it on the stack
  Examples:
   Variable
   not Variable
   not not undefined Variable
   defined(Variable)
   !Variable
   unicodestring
   123
   $45
   'Abc'
   (expression)
}
var
    i: TMaxPrecInt;
    e: extended;
    S, aName, Param: string;
    Code: integer;
    NameStartP:
{$ifdef UsePChar}
    PChar
{$else}
    integer
{$endif}
    ;
    p, Lvl: integer;
begin
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TCondDirectiveEvaluator.ReadOperand START Token[',FTokenStart-PChar(Expression)+1,']="',GetTokenString,'" ',FToken,BoolToStr(Skip,' SKIP',''));
  {$ENDIF}
    case FToken of
        tknot:
          begin
            // boolean not
            NextToken;
            ReadOperand(Skip);
            if not Skip then
                FStack[FStackTop].Operand :=
                    CondDirectiveBool[IsFalse(FStack[FStackTop].Operand)];
          end;
        tkIdentifier:
            if Skip then
              begin
                NextToken;
                if FToken = tkBraceOpen then
                  begin
                    // only one parameter is supported
                    NextToken;
                    if FToken = tkIdentifier then
                        NextToken;
                    if FToken <> tkBraceClose then
                        LogXExpectedButTokenFound(')');
                    NextToken;
                  end;
              end
            else
              begin
                aName := GetTokenString;
                p := FTokenStart
{$ifdef UsePChar}
                    - PChar(Expression) + 1
{$endif}
                ;
                NextToken;
                if FToken = tkBraceOpen then
                  begin
                    // function
                    NameStartP := FTokenStart;
                    NextToken;
                    // only one parameter is supported
                    Param := '';
                    if FToken = tkIdentifier then
                      begin
                        Param := GetTokenString;
                        NextToken;
                      end;
                    if FToken <> tkBraceClose then
                        LogXExpectedButTokenFound(')');
                    if not OnEvalFunction(Self, aName, Param, S) then
                      begin
                        FTokenStart := NameStartP;
                        FTokenEnd := FTokenStart + length(aName);
                        LogXExpectedButTokenFound('function');
                      end;
                    Push(S, p);
                    NextToken;
                  end
                else
                  begin
                    // variable
                    if OnEvalVariable(Self, aName, S) then
                        Push(S, p)
                    else
                      begin
                        // variable does not exist -> evaluates to false
                        Push(CondDirectiveBool[False], p);
                      end;
                  end;
              end;
        tkBraceOpen:
          begin
            NextToken;
            if Skip then
              begin
                Lvl := 1;
                repeat
                    case FToken of
                        tkEOF:
                            LogXExpectedButTokenFound(')');
                        tkBraceOpen: Inc(Lvl);
                        tkBraceClose:
                          begin
                            Dec(Lvl);
                            if Lvl = 0 then
                                break;
                          end;
                        else
                        // Do nothing, satisfy compiler
                      end;
                    NextToken;
                until False;
              end
            else
              begin
                ReadExpression;
                if FToken <> tkBraceClose then
                    LogXExpectedButTokenFound(')');
              end;
            NextToken;
          end;
        else
            LogXExpectedButTokenFound('identifier');
      end;
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TCondDirectiveEvaluator.ReadOperand END Top=',FStackTop,' Value="',FStack[FStackTop].Operand,'" Token[',FTokenStart-PChar(Expression)+1,']="',GetTokenString,'" ',FToken);
  {$ENDIF}
end;

procedure TCondDirectiveEvaluator.ReadExpression;
// read operand operator operand ... til tkEOF or tkBraceClose
var
    OldStackTop: integer;

    procedure ReadBinary(Level: TPrecedenceLevel; NewOperator: TToken);
    begin
        ResolveStack(OldStackTop, Level, NewOperator);
        NextToken;
        ReadOperand;
    end;

begin
    OldStackTop := FStackTop;
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TCondDirectiveEvaluator.ReadExpression START Top=',FStackTop,' Token[',FTokenStart-PChar(Expression)+1,']="',GetTokenString,'" ',FToken);
  {$ENDIF}
    ReadOperand;
    repeat
    {$IFDEF VerbosePasDirectiveEval}
    writeln('TCondDirectiveEvaluator.ReadExpression NEXT Top=',FStackTop,' Token[',FTokenStart-PChar(Expression)+1,']="',GetTokenString,'" ',FToken);
    {$ENDIF}
        case FToken of
            tkEOF, tkBraceClose:
              begin
                ResolveStack(OldStackTop, high(TPrecedenceLevel), tkEOF);
                exit;
              end;
            tkand:
              begin
                ResolveStack(OldStackTop, ceplSecond, tkand);
                NextToken;
                if (FStackTop = OldStackTop + 1) and
                    IsFalse(FStack[FStackTop].Operand) then
                  begin
                    // false and ...
                    // -> skip all "and"
                    repeat
                        ReadOperand(True);
                        if FToken <> tkand then
                            break;
                        NextToken;
                    until False;
                    FStack[FStackTop].Operathor := tkEOF;
                  end
                else
                    ReadOperand;
              end;
            tkor:
              begin
                ResolveStack(OldStackTop, ceplThird, tkor);
                NextToken;
                if (FStackTop = OldStackTop + 1) and
                    IsTrue(FStack[FStackTop].Operand) then
                  begin
                    // true or ...
                    // -> skip all "and" and "or"
                    repeat
                        ReadOperand(True);
                        if not (FToken in [tkand, tkor]) then
                            break;
                        NextToken;
                    until False;
                    FStack[FStackTop].Operathor := tkEOF;
                  end
                else
                    ReadOperand;
              end;
            tkSingleAnd:
                ReadBinary(ceplSecond, FToken);
            tkxor, tkSingleOr:
                ReadBinary(ceplThird, FToken);
            tkEqual, tkNotEqual:
                ReadBinary(ceplFourth, FToken);
            else
                LogXExpectedButTokenFound('operator');
          end;
    until False;
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TCondDirectiveEvaluator.ReadExpression END Top=',FStackTop,' Value="',FStack[FStackTop].Operand,'" Token[',FTokenStart-PChar(Expression)+1,']=',GetTokenString,' ',FToken);
  {$ENDIF}
end;

procedure TCondDirectiveEvaluator.ResolveStack(MinStackLvl: integer;
    Level: TPrecedenceLevel; NewOperator: TToken);
var
    A, B, R: string;
    Op: TToken;
    AInt, BInt: TMaxPrecInt;
    AFloat, BFloat: extended;
    BPos: integer;
begin
    // resolve all higher or equal level operations
    // Note: the stack top contains operand B
    //       the stack second contains operand A and the operator between A and B

    //writeln('TCondDirectiveEvaluator.ResolveStack FStackTop=',FStackTop,' MinStackLvl=',MinStackLvl);
    //if FStackTop>MinStackLvl+1 then
    //  writeln('  FStack[FStackTop-1].Level=',FStack[FStackTop-1].Level,' Level=',Level);
    while (FStackTop > MinStackLvl + 1) and (FStack[FStackTop - 1].Level <= Level) do
      begin
        // pop last operand and operator from stack
        B := FStack[FStackTop].Operand;
        BPos := FStack[FStackTop].OperandPos;
        Dec(FStackTop);
        Op := FStack[FStackTop].Operathor;
        A := FStack[FStackTop].Operand;
    {$IFDEF VerbosePasDirectiveEval}
    writeln('  ResolveStack Top=',FStackTop,' A="',A,'" ',Op,' B="',B,'"');
    {$ENDIF}
    {$IFOPT R+}{$DEFINE RangeChecking}{$ENDIF}
    {$R+}
          try
            case Op of
                tkand,tkSingleAnd: // boolean and
                    R := CondDirectiveBool[IsTrue(A) and IsTrue(B)];
                tkor,tkSingleOr: // boolean or
                    R := CondDirectiveBool[IsTrue(A) or IsTrue(B)];
                tkxor: // boolean xor
                    R := CondDirectiveBool[IsTrue(A) xor IsTrue(B)];
                tkEqual,
                tkNotEqual:
                  begin
                     case Op of
                            tkEqual: R := CondDirectiveBool[A = B];
                            tkNotEqual: R := CondDirectiveBool[A <> B];
                            else
                            // Do nothing, satisfy compiler
                          end;
                  end;
                else
                    Log(mtError, nErrOperandAndOperatorMismatch,
                        sErrOperandAndOperatorMismatch, []);
              end;
          except
            on E: EMathError do
                Log(mtError, nErrRangeCheck, sErrRangeCheck + ' ' + E.Message, []);
            on E: EInterror do
                Log(mtError, nErrRangeCheck, sErrRangeCheck + ' ' + E.Message, []);
          end;
    {$IFNDEF RangeChecking}{$R-}{$UNDEF RangeChecking}{$ENDIF}
    {$IFDEF VerbosePasDirectiveEval}
    writeln('  ResolveStack Top=',FStackTop,' A="',A,'" ',Op,' B="',B,'" = "',R,'"');
    {$ENDIF}
        FStack[FStackTop].Operand := R;
        FStack[FStackTop].OperandPos := BPos;
      end;
    FStack[FStackTop].Operathor := NewOperator;
    FStack[FStackTop].Level := Level;
end;

function TCondDirectiveEvaluator.GetTokenString: string;
begin
    Result := copy(Expression, FTokenStart
{$ifdef UsePChar}
        - PChar(Expression) + 1
{$endif}
        , FTokenEnd - FTokenStart);
end;

function TCondDirectiveEvaluator.GetStringLiteralValue: string;
var
  {$ifdef UsePChar}
    p, StartP: PChar;
  {$else}
    Src: string;
    p, l, StartP: integer;
  {$endif}
begin
    Result := '';
    p := FTokenStart;
  {$ifdef UsePChar}
    repeat
        case p^ of
            '''':
              begin
                Inc(p);
                StartP := p;
                repeat
                    case p^ of
                        #0: Log(mtError, nErrInvalidCharacter,
                                SErrInvalidCharacter, ['#0']);
                        '''': break;
                        else
                            Inc(p);
                      end;
                until False;
                if p > StartP then
                    Result := Result + copy(Expression, StartP -
                        PChar(Expression) + 1, p - StartP);
                Inc(p);
              end;
            else
                Log(mtError, nErrInvalidCharacter, SErrInvalidCharacter, ['#0']);
          end;
    until False;
  {$else}
    Src := Expression;
    l := length(Src);
    repeat
        if (p > l) or (Src[p] <> '''') then
            Log(mtError, nErrInvalidCharacter, SErrInvalidCharacter, ['#0'])
        else
          begin
            Inc(p);
            StartP := p;
            repeat
                if p > l then
                    Log(mtError, nErrInvalidCharacter, SErrInvalidCharacter, ['#0'])
                else if Src[p] = '''' then
                    break
                else
                    Inc(p);
            until False;
            if p > StartP then
                Result := Result + copy(Expression, StartP, p - StartP);
            Inc(p);
          end;
    until False;
  {$endif}
end;

procedure TCondDirectiveEvaluator.Push(const AnOperand: string;
    OperandPosition: integer);
begin
    Inc(FStackTop);
    if FStackTop >= length(FStack) then
        SetLength(FStack, length(FStack) * 2 + 4);
    with FStack[FStackTop] do
      begin
        Operand := AnOperand;
        OperandPos := OperandPosition;
        Operathor := tkEOF;
        Level := ceplFourth;
      end;
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TCondDirectiveEvaluator.Push Top=',FStackTop,' Operand="',AnOperand,'" Pos=',OperandPosition);
  {$ENDIF}
end;

constructor TCondDirectiveEvaluator.Create;
begin

end;

destructor TCondDirectiveEvaluator.Destroy;
begin
    inherited Destroy;
end;

function TCondDirectiveEvaluator.Eval(const Expr: string): boolean;
begin
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TCondDirectiveEvaluator.Eval Expr="',Expr,'"');
  {$ENDIF}
    Expression := Expr;
    MsgType := mtInfo;
    MsgNumber := 0;
    MsgPattern := '';
    if Expr = '' then
        exit(False);
    FTokenStart :=
{$ifdef UsePChar}
        PChar(Expr)
{$else}
        1
{$endif}
    ;
    FTokenEnd := FTokenStart;
    FStackTop := -1;
    NextToken;
    ReadExpression;
    Result := IsTrue(FStack[0].Operand);
end;

{ TMacroDef }

constructor TMacroDef.Create(const AName, AValue: string);
begin
    FName := AName;
    FValue := AValue;
end;

{ TLineReader }

constructor TLineReader.Create(const AFilename: string);
begin
    FFileName := AFileName;
end;

{ ---------------------------------------------------------------------
  TFileLineReader
  ---------------------------------------------------------------------}

constructor TFileLineReader.Create(const AFilename: string);

begin
    inherited Create(AFileName);
  {$ifdef pas2js}
  raise Exception.Create('ToDo TFileLineReader.Create');
  {$else}
    Assign(FTextFile, AFilename);
    Reset(FTextFile);
    SetTextBuf(FTextFile, FBuffer, SizeOf(FBuffer));
    FFileOpened := True;
  {$endif}
end;

destructor TFileLineReader.Destroy;
begin
  {$ifdef pas2js}
  // ToDo
  {$else}
    if FFileOpened then
        Close(FTextFile);
  {$endif}
    inherited Destroy;
end;

function TFileLineReader.IsEOF: boolean;
begin
  {$ifdef pas2js}
  Result:=true;// ToDo
  {$else}
    Result := EOF(FTextFile);
  {$endif}
end;

function TFileLineReader.ReadLine: string;
begin
  {$ifdef pas2js}
  Result:='';// ToDo
  {$else}
    ReadLn(FTextFile, Result);
  {$endif}
end;

{ TStreamLineReader }

{$ifdef HasStreams}
Procedure TStreamLineReader.InitFromStream(AStream : TStream);

begin
  SetLength(FContent,AStream.Size);
  if FContent<>'' then
    AStream.Read(FContent[1],length(FContent));
  FPos:=0;
end;
{$endif}

procedure TStreamLineReader.InitFromString(const s: string);
begin
    FContent := s;
    FPos := 0;
end;

function TStreamLineReader.IsEOF: boolean;
begin
    Result := FPos >= Length(FContent);
end;

function TStreamLineReader.ReadLine: string;

var
    LPos: integer;
    EOL: boolean;

begin
    if isEOF then
        exit('');
    LPos := FPos + 1;
    repeat
        Inc(FPos);
        EOL := (FContent[FPos] in [#10, #13]);
    until isEOF or EOL;
    if EOL then
        Result := Copy(FContent, LPos, FPos - LPos)
    else
        Result := Copy(FContent, LPos, FPos - LPos + 1);
    if (not isEOF) and (FContent[FPos] = #13) and (FContent[FPos + 1] = #10) then
        Inc(FPos);
end;

{ TFileStreamLineReader }

constructor TFileStreamLineReader.Create(const AFilename: string);
{$ifdef HasStreams}
Var
  S : TFileStream;
{$endif}
begin
    inherited Create(AFilename);
  {$ifdef HasStreams}
  S:=TFileStream.Create(AFileName,fmOpenRead or fmShareDenyWrite);
  try
     InitFromStream(S);
  finally
    S.Free;
  end;
  {$else}
    raise Exception.Create('TFileStreamLineReader.Create');
  {$endif}
end;

{ TStringStreamLineReader }

constructor TStringStreamLineReader.Create(const AFilename: string;
    const ASource: string);
begin
    inherited Create(AFilename);
    InitFromString(ASource);
end;

{ ---------------------------------------------------------------------
  TBaseFileResolver
  ---------------------------------------------------------------------}

procedure TBaseFileResolver.SetBaseDirectory(AValue: string);
begin
    if FBaseDirectory = AValue then
        Exit;
    FBaseDirectory := AValue;
end;

procedure TBaseFileResolver.SetStrictFileCase(AValue: boolean);
begin
    if FStrictFileCase = AValue then
        Exit;
    FStrictFileCase := AValue;
end;


constructor TBaseFileResolver.Create;
begin
    inherited Create;
    FIncludePaths := TStringList.Create;
    FResourcePaths := TStringList.Create;
end;

destructor TBaseFileResolver.Destroy;
begin
    FResourcePaths.Free;
    FIncludePaths.Free;
    inherited Destroy;
end;

procedure TBaseFileResolver.AddIncludePath(const APath: string);

var
    FP: string;

begin
    if (APath = '') then
        FIncludePaths.Add('./')
    else
      begin
{$IFDEF HASFS}
    FP:=IncludeTrailingPathDelimiter(ExpandFileName(APath));
{$ELSE}
        FP := APath;
{$ENDIF}
        FIncludePaths.Add(FP);
      end;
end;

procedure TBaseFileResolver.AddResourcePath(const APath: string);
var
    FP: string;

begin
    if (APath = '') then
        FResourcePaths.Add('./')
    else
      begin
{$IFDEF HASFS}
    FP:=IncludeTrailingPathDelimiter(ExpandFileName(APath));
{$ELSE}
        FP := APath;
{$ENDIF}
        FResourcePaths.Add(FP);
      end;
end;


{$IFDEF HASFS}

{ ---------------------------------------------------------------------
  TFileResolver
  ---------------------------------------------------------------------}


function TFileResolver.SearchLowUpCase(FN: string): string;

var
  Dir: String;

begin
  If FileExists(FN) then
    Result:=FN
  else if StrictFileCase then
    Result:=''
  else
    begin
    Dir:=ExtractFilePath(FN);
    FN:=ExtractFileName(FN);
    Result:=Dir+LowerCase(FN);
    If FileExists(Result) then exit;
    Result:=Dir+uppercase(Fn);
    If FileExists(Result) then exit;
    Result:='';
    end;
end;

function TFileResolver.FindIncludeFileName(const AName: string): String;


  Function FindInPath(FN : String) : String;

  var
    I : integer;

  begin
    Result:='';
    I:=0;
    While (Result='') and (I<FIncludePaths.Count) do
      begin
      Result:=SearchLowUpCase(FIncludePaths[i]+FN);
      Inc(I);
      end;
    // search in BaseDirectory
    if (Result='') and (BaseDirectory<>'') then
      Result:=SearchLowUpCase(BaseDirectory+FN);
  end;

var
  FN : string;

begin
  Result := '';
  // convert pathdelims to system
  FN:=SetDirSeparators(AName);
  If FilenameIsAbsolute(FN) then
    begin
    Result := SearchLowUpCase(FN);
    if (Result='') and (ExtractFileExt(FN)='') then
      begin
      Result:=SearchLowUpCase(FN+'.inc');
      if Result='' then
        Result:=SearchLowUpCase(FN+'.cs');
      end;
    end
  else
    begin
    // file name is relative
    // search in include path
    Result:=FindInPath(FN);
    // No extension, try default extensions
    if (Result='') and (ExtractFileExt(FN)='') then
      begin
      Result:=FindInPath(FN+'.inc');
      if Result='' then
        Result:=FindInPath(FN+'.cs');
      end
    end;
end;

function TFileResolver.CreateFileReader(const AFileName: String): TLineReader;
begin
  {$ifdef HasStreams}
  If UseStreams then
    Result:=TFileStreamLineReader.Create(AFileName)
  else
  {$endif}
    Result:=TFileLineReader.Create(AFileName);
end;

function TFileResolver.FindResourceFileName(const AFileName: string): String;

  Function FindInPath(FN : String) : String;

  var
    I : integer;

  begin
    Result:='';
    I:=0;
    While (Result='') and (I<FResourcePaths.Count) do
      begin
      Result:=SearchLowUpCase(FResourcePaths[i]+FN);
      Inc(I);
      end;
    // search in BaseDirectory
    if (Result='') and (BaseDirectory<>'') then
      Result:=SearchLowUpCase(BaseDirectory+FN);
  end;

var
  FN : string;

begin
  Result := '';
  // convert pathdelims to system
  FN:=SetDirSeparators(AFileName);
  If FilenameIsAbsolute(FN) then
    begin
    Result := SearchLowUpCase(FN);
    end
  else
    begin
    // file name is relative
    // search in include path
    Result:=FindInPath(FN);
    end;
end;

function TFileResolver.FindSourceFile(const AName: string): TLineReader;
begin
  Result := nil;
  if not FileExists(AName) then
    Raise EFileNotFoundError.create(AName)
  else
    try
      Result := CreateFileReader(AName)
    except
      Result := nil;
    end;
end;

function TFileResolver.FindIncludeFile(const AName: string): TLineReader;

Var
  FN : String;

begin
  Result:=Nil;
  FN:=FindIncludeFileName(AName);
  If (FN<>'') then
    try
      Result := TFileLineReader.Create(FN);
    except
      Result:=Nil;
    end;
end;
{$ENDIF}

{$ifdef fpc}
{ TStreamResolver }

procedure TStreamResolver.SetOwnsStreams(AValue: Boolean);
begin
  if FOwnsStreams=AValue then Exit;
  FOwnsStreams:=AValue;
end;

function TStreamResolver.FindIncludeFileName(const aFilename: string): String;
begin
  raise EFileNotFoundError.Create('TStreamResolver.FindIncludeFileName not supported '+aFilename);
  Result:='';
end;

function TStreamResolver.FindResourceFileName(const AFileName: string): String;
begin
  raise EFileNotFoundError.Create('TStreamResolver.FindResourceFileName not supported '+aFileName);
  Result:='';
end;

constructor TStreamResolver.Create;
begin
  Inherited;
  FStreams:=TStringList.Create;
  FStreams.Sorted:=True;
  FStreams.Duplicates:=dupError;
end;

destructor TStreamResolver.Destroy;
begin
  Clear;
  FreeAndNil(FStreams);
  inherited Destroy;
end;

procedure TStreamResolver.Clear;

Var
  I : integer;
begin
  if OwnsStreams then
    begin
    For I:=0 to FStreams.Count-1 do
      Fstreams.Objects[i].Free;
    end;
  FStreams.Clear;
end;

procedure TStreamResolver.AddStream(const AName: String; AStream: TStream);
begin
  FStreams.AddObject(AName,AStream);
end;

function TStreamResolver.FindStream(const AName: string; ScanIncludes : Boolean) : TStream;

Var
  I,J : Integer;
  FN : String;
begin
  Result:=Nil;
  I:=FStreams.IndexOf(AName);
  If (I=-1) and ScanIncludes then
    begin
    J:=0;
    While (I=-1) and (J<IncludePaths.Count-1) do
      begin
      FN:=IncludeTrailingPathDelimiter(IncludePaths[i])+AName;
      I:=FStreams.IndexOf(FN);
      Inc(J);
      end;
    end;
  If (I<>-1) then
    Result:=FStreams.Objects[i] as TStream;
end;

function TStreamResolver.FindStreamReader(const AName: string; ScanIncludes : Boolean) : TLineReader;

Var
  S : TStream;
  SL : TStreamLineReader;

begin
  Result:=Nil;
  S:=FindStream(AName,ScanIncludes);
  If (S<>Nil) then
    begin
    S.Position:=0;
    SL:=TStreamLineReader.Create(AName);
    try
      SL.InitFromStream(S);
      Result:=SL;
    except
      FreeAndNil(SL);
      Raise;
    end;
    end;
end;

function TStreamResolver.FindSourceFile(const AName: string): TLineReader;

begin
  Result:=FindStreamReader(AName,False);
end;

function TStreamResolver.FindIncludeFile(const AName: string): TLineReader;
begin
  Result:=FindStreamReader(AName,True);
end;
{$endif}

{ ---------------------------------------------------------------------
  TCSharpScanner
  ---------------------------------------------------------------------}

constructor TCSharpScanner.Create(AFileResolver: TBaseFileResolver);

    function CS: TStringList;

    begin
        Result := TStringList.Create;
        Result.Sorted := True;
        Result.Duplicates := dupError;
    end;


var
    vs: TValueSwitch;
begin
    inherited Create;
    FFileResolver := AFileResolver;
    FFiles := TStringList.Create;
    FIncludeStack := TFPList.Create;
    FDefines := CS;
    FMacros := CS;
    FMaxIncludeStackDepth := DefaultMaxIncludeStackDepth;

    FAllowedModeSwitches := msAllModeSwitches;
    FCurrentBoolSwitches := bsFPCMode;
    FAllowedBoolSwitches := bsAll;
    FAllowedValueSwitches := vsAllValueSwitches;
    for vs in TValueSwitch do
        FCurrentValueSwitches[vs] := DefaultValueSwitches[vs];

    FConditionEval := TCondDirectiveEvaluator.Create;
    FConditionEval.OnLog := @OnCondEvalLog;
    FConditionEval.OnEvalVariable := @OnCondEvalVar;
    FConditionEval.OnEvalFunction := @OnCondEvalFunction;


end;

destructor TCSharpScanner.Destroy;
begin
    FreeAndNil(FConditionEval);
    ClearMacros;
    FreeAndNil(FMacros);
    FreeAndNil(FDefines);
    ClearFiles;
    FreeAndNil(FFiles);
    FreeAndNil(FIncludeStack);
    inherited Destroy;
end;

procedure TCSharpScanner.RegisterResourceHandler(aExtension: string;
    aHandler: TResourceHandler);

var
    Idx: integer;

begin
    if (aExtension = '') then
        exit;
    if (aExtension[1] = '.') then
        aExtension := copy(aExtension, 2, Length(aExtension) - 1);
    Idx := IndexOfResourceHandler(lowerCase(aExtension));
    if Idx = -1 then
      begin
        Idx := Length(FResourceHandlers);
        SetLength(FResourceHandlers, Idx + 1);
        FResourceHandlers[Idx].Ext := LowerCase(aExtension);
      end;
    FResourceHandlers[Idx].handler := aHandler;
end;

procedure TCSharpScanner.RegisterResourceHandler(aExtensions: array of string;
    aHandler: TResourceHandler);

var
    S: string;

begin
    for S in aExtensions do
        RegisterResourceHandler(S, aHandler);
end;

procedure TCSharpScanner.ClearFiles;

begin
    // Dont' free the first element, because it is CurSourceFile
    while FIncludeStack.Count > 1 do
      begin
        TBaseFileResolver(FIncludeStack[1]).
{$ifdef pas2js}Destroy{$else}
            Free
{$endif}
        ;
        FIncludeStack.Delete(1);
      end;
    FIncludeStack.Clear;
    FreeAndNil(FCurSourceFile);
    FFiles.Clear;
    FModuleRow := 0;
end;

procedure TCSharpScanner.ClearMacros;

var
    I: integer;

begin
    for I := 0 to FMacros.Count - 1 do
        FMacros.Objects[i].
{$ifdef pas2js}Destroy{$else}
            Free
{$endif}
    ;
    FMacros.Clear;
end;

procedure TCSharpScanner.SetCurToken(const AValue: TToken);
begin
    FCurToken := AValue;
end;

procedure TCSharpScanner.SetCurTokenString(const AValue: string);
begin
    FCurTokenString := AValue;
end;

procedure TCSharpScanner.OpenFile(AFilename: string);
begin
    Clearfiles;
    FCurSourceFile := FileResolver.FindSourceFile(AFilename);
    FCurFilename := AFilename;
    AddFile(FCurFilename);
  {$IFDEF HASFS}
  FileResolver.BaseDirectory := IncludeTrailingPathDelimiter(ExtractFilePath(FCurFilename));
  {$ENDIF}
    if LogEvent(sleFile) then
        DoLog(mtInfo, nLogOpeningFile, SLogOpeningFile, [FormatPath(AFileName)], True);
end;

procedure TCSharpScanner.FinishedModule;
begin
    if (sleLineNumber in LogEvents) and (not CurSourceFile.IsEOF) and
        ((FCurRow mod 100) > 0) then
        DoLog(mtInfo, nLogLineNumber, SLogLineNumber, [CurRow], True);
end;

function TCSharpScanner.FormatPath(const aFilename: string): string;
begin
    if Assigned(OnFormatPath) then
        Result := OnFormatPath(aFilename)
    else
        Result := aFilename;
end;

procedure TCSharpScanner.SetNonToken(aToken: TToken);
begin
    Include(FNonTokens, aToken);
end;

procedure TCSharpScanner.UnsetNonToken(aToken: TToken);
begin
    Exclude(FNonTokens, aToken);
end;

procedure TCSharpScanner.SetTokenOption(aOption: TTokenoption);
begin
    Include(FTokenOptions, aOption);
end;

procedure TCSharpScanner.UnSetTokenOption(aOption: TTokenoption);
begin
    Exclude(FTokenOptions, aOption);
end;

function TCSharpScanner.CheckToken(aToken: TToken; const ATokenString: string): TToken;
begin
    Result := atoken;
    if (aToken = tkIdentifier) and (CompareText(aTokenString, 'operator') = 0) then
        if (toOperatorToken in TokenOptions) then
            Result := tkoperator;
end;

function TCSharpScanner.FetchToken: TToken;
var
    IncludeStackItem: TIncludeStackItem;
begin
    FPreviousToken := FCurToken;
    while True do
      begin
        Result := DoFetchToken;
        case FCurToken of
            tkEOF:
              begin
                if FIncludeStack.Count > 0 then
                  begin
                    IncludeStackItem :=
                        TIncludeStackItem(FIncludeStack[FIncludeStack.Count - 1]);
                    FIncludeStack.Delete(FIncludeStack.Count - 1);
                    CurSourceFile.
{$ifdef pas2js}Destroy{$else}
                        Free
{$endif}
                    ;
                    FCurSourceFile := IncludeStackItem.SourceFile;
                    FCurFilename := IncludeStackItem.Filename;
                    FCurToken := IncludeStackItem.Token;
                    FCurTokenString := IncludeStackItem.TokenString;
                    FCurLine := IncludeStackItem.Line;
                    FCurRow := IncludeStackItem.Row;
                    FCurColumnOffset := IncludeStackItem.ColumnOffset;
                    FTokenPos := IncludeStackItem.TokenPos;
                    IncludeStackItem.Free;
                    Result := FCurToken;
                  end
                else
                    break;
              end;
            tkWhiteSpace,
            tkLineEnding:
                if not (FSkipWhiteSpace or CShIsSkipping) then
                    Break;
            tkComment:
                if not (FSkipComments or CShIsSkipping) then
                    Break;
            tkLineComment:
                if not (FSkipComments or CShIsSkipping) then
                    Break;
            tkOperator:
              begin
                if not (CShIsSkipping) then
                    Break;
              end;

            else
                if not CShIsSkipping then
                    break;
          end; // Case
      end;
    //  Writeln(Result, '(',CurTokenString,')');
end;

function TCSharpScanner.ReadNonPascalTillEndToken(StopAtLineEnd: boolean): TToken;
var
    StartPos:
{$ifdef UsePChar}
    PChar
{$else}
    integer
{$endif}
    ;

  {$ifndef UsePChar}
var
    s: string;
    l: integer;

  {$endif}

    procedure Add;
    var
        AddLen: PtrInt;
    {$ifdef UsePChar}
        OldLen: integer;
    {$endif}
    begin
        AddLen := FTokenPos - StartPos;
        if AddLen = 0 then
            FCurTokenString := ''
        else
          begin
      {$ifdef UsePChar}
            OldLen := length(FCurTokenString);
            SetLength(FCurTokenString, OldLen + AddLen);
            Move(StartPos^, PChar(PChar(FCurTokenString) + OldLen)^, AddLen);
      {$else}
            FCurTokenString := FCurTokenString + copy(FCurLine, StartPos, AddLen);
      {$endif}
            StartPos := FTokenPos;
          end;
    end;

    function DoEndOfLine: boolean;
    begin
        Add;
        if StopAtLineEnd then
          begin
            ReadNonPascalTillEndToken := tkLineEnding;
            FCurToken := tkLineEnding;
            FetchLine;
            exit(True);
          end;
        if not FetchLine then
          begin
            ReadNonPascalTillEndToken := tkEOF;
            FCurToken := tkEOF;
            exit(True);
          end;
    {$ifndef UsePChar}
        s := FCurLine;
        l := length(s);
    {$endif}
        StartPos := FTokenPos;
        Result := False;
    end;

begin
    Result := tkEOF;
    FCurTokenString := '';
    StartPos := FTokenPos;
  {$ifndef UsePChar}
    s := FCurLine;
    l := length(s);
  {$endif}
    repeat
    {$ifndef UsePChar}
        if FTokenPos > l then
            if DoEndOfLine then
                exit;
    {$endif}
        case
{$ifdef UsePChar}
            FTokenPos^
{$else}
            s[FTokenPos]
{$endif}
            of
      {$ifdef UsePChar}
            #0: // end of line
                if DoEndOfLine then
                    exit;
      {$endif}
            '''':
              begin
                // Notes:
                // 1. Eventually there should be a mechanism to override parsing non-pascal
                // 2. By default skip Pascal string literals, as this is more intuitive
                //    in IDEs with Pascal highlighters
                Inc(FTokenPos);
                repeat
          {$ifndef UsePChar}
                    if FTokenPos > l then
                        Error(nErrOpenString, SErrOpenString);
          {$endif}
                    case
{$ifdef UsePChar}
                        FTokenPos^
{$else}
                        s[FTokenPos]
{$endif}
                        of
          {$ifdef UsePChar}
                        #0: Error(nErrOpenString, SErrOpenString);
          {$endif}
                        '''':
                          begin
                            Inc(FTokenPos);
                            break;
                          end;
                        #10, #13:
                          begin
                            // string literal missing closing apostroph
                            break;
                          end
                        else
                            Inc(FTokenPos);
                      end;
                until False;
              end;
            '/':
              begin
                Inc(FTokenPos);
                if
{$ifdef UsePChar}
                FTokenPos^ = '/'
{$else}
                (FTokenPos <= l) and (s[FTokenPos] = '/')
{$endif}
                then
                  begin
                    // skip Delphi comment //, see Note above
                    repeat
                        Inc(FTokenPos);
                    until
{$ifdef UsePChar}
                        FTokenPos^ in [#0, #10, #13]
{$else}
                        (FTokenPos > l) or (s[FTokenPos] in [#10, #13])
{$endif}
                    ;
                  end;
              end;
            '0'..'9', 'A'..'Z', 'a'..'z', '_':
              begin
                // number or identifier
                if
{$ifdef UsePchar}
                (FTokenPos[0] in ['e', 'E']) and
                    (FTokenPos[1] in ['n', 'N']) and (FTokenPos[2] in ['d', 'D']) and
                    not (FTokenPos[3] in IdentChars)
            {$else}
           {$ifndef pas2js}
                (copy(s, FTokenPos, 3).ToLower = 'end') and
                    ((FTokenPos + 3 > l) or not (s[FTokenPos + 3] in IdentChars))
            {$else}
            (TJSString(copy(s,FTokenPos,3)).toLowerCase='end')
            and ((FTokenPos+3>l) or not (s[FTokenPos+3] in IdentChars))
            {$endif}
            {$endif}
                then
                  begin
                    // 'end' found
                    Add;
                    if FCurTokenString <> '' then
                      begin
                        // return characters in front of 'end'
                        Result := tkWhitespace;
                        FCurToken := Result;
                        exit;
                      end;
                    // return 'end'
          {$ifdef UsePChar}
                    SetLength(FCurTokenString, 3);
                    Move(FTokenPos^, FCurTokenString[1], 3);
          {$else}
                    FCurTokenString := copy(s, FTokenPos, 3);
          {$endif}
                    Inc(FTokenPos, 3);
                    FCurToken := Result;
                    exit;
                  end
                else
                  begin
                    // skip identifier
                    while
{$ifdef UsePChar}
                        FTokenPos[0] in IdentChars
{$else}
                        (FTokenPos <= l) and (s[FTokenPos] in IdentChars)
{$endif}
                        do
                        Inc(FTokenPos);
                  end;
              end;
            else
                Inc(FTokenPos);
          end;
    until False;
end;

procedure TCSharpScanner.Error(MsgNumber: integer; const Msg: string);
begin
    SetCurMsg(mtError, MsgNumber, Msg, []);
    raise EScannerError.CreateFmt('%s(%d,%d) Error: %s',
        [FormatPath(CurFilename), CurRow, CurColumn, FLastMsg]);
end;

procedure TCSharpScanner.Error(MsgNumber: integer; const Fmt: string;
    Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif});
begin
    SetCurMsg(mtError, MsgNumber, Fmt, Args);
    raise EScannerError.CreateFmt('%s(%d,%d) Error: %s',
        [FormatPath(CurFilename), CurRow, CurColumn, FLastMsg]);
end;

function TCSharpScanner.DoFetchTextToken(ModeChar: char): TToken;
var
    OldLength: integer;
    TokenStart:
{$ifdef UsePChar}
    PChar
{$else}
    integer
{$endif}
    ;
    SectionLength: integer;
  {$ifndef UsePChar}
    s: string;
    l: integer;
  {$endif}
begin
    Result := tkEOF;
    OldLength := 0;
    FCurTokenString := '';
  {$ifndef UsePChar}
    s := FCurLine;
    l := length(s);
  {$endif}

    repeat
    {$ifndef UsePChar}
        if FTokenPos > l then
            break;
    {$endif}
        case
{$ifdef UsePChar}
            FTokenPos[0]
{$else}
            s[FTokenPos]
{$endif}
            of
            '^':
              begin
                TokenStart := FTokenPos;
                Inc(FTokenPos);
                if
{$ifdef UsePChar}
                FTokenPos[0] in Letters
{$else}
                (FTokenPos < l) and (s[FTokenPos] in Letters)
{$endif}
                then
                    Inc(FTokenPos);
                if Result = tkEOF then
                    Result := tkChar
                else
                    Result := tkString;
              end;
            '#':
              begin
                TokenStart := FTokenPos;
                Inc(FTokenPos);
                if
{$ifdef UsePChar}
                FTokenPos[0] = '$'
{$else}
                (FTokenPos < l) and (s[FTokenPos] = '$')
{$endif}
                then
                  begin
                    Inc(FTokenPos);
                    repeat
                        Inc(FTokenPos);
                    until not (
{$ifdef UsePChar}
                        FTokenPos[0]
{$else}
                        FTokenPos <= l) or not (s[FTokenPos]{$endif} in HexDigits)

                    ;
                  end
                else
                    repeat
                        Inc(FTokenPos);
                    until not (
{$ifdef UsePChar}
                        FTokenPos[0]
{$else}
                        (FTokenPos <= l) or not (s[FTokenPos]{$endif}  in Digits)

                ;
                if Result = tkEOF then
                    Result := tkChar
                else
                    Result := tkString;
              end;
            '''':
              begin
                TokenStart := FTokenPos;
                Inc(FTokenPos);
                while not (
{$ifdef UsePChar}
                        FTokenPos[0]
{$else}
                    (FTokenPos <= l) or not (s[FTokenPos]{$endif}
                        = '''') do
                  begin

                    if
{$ifdef UsePChar}
                    FTokenPos[0] = #0
{$else}
                    FTokenPos > l
        {$endif}
                    then
                        Error(nErrOpenString, SErrOpenString);

                    Inc(FTokenPos);
                  end;
                Inc(FTokenPos);
                if ((FTokenPos - TokenStart) in [3, 4]) then // 'z'
                    Result := tkCharacter;

              end;
            '"':
              begin
                TokenStart := FTokenPos;
                Inc(FTokenPos);

                while True do
                  begin
                    if (
{$ifdef UsePChar}
                    FTokenPos[0]
{$else}
                    FTokenPos <= l) and (s[FTokenPos]{$endif} = '\')

                    then
                        Inc(FTokenPos)
                    else if (
{$ifdef UsePChar}
                    FTokenPos[0]
{$else}
                    FTokenPos <= l) and (s[FTokenPos]{$endif} in ['"'])

                    then
                        break;

                    if
{$ifdef UsePChar}
                    FTokenPos[0] = #0
{$else}
                    FTokenPos > l
{$endif}
                    then
                        Error(nErrOpenString, SErrOpenString);

                    Inc(FTokenPos);
                  end;
                Inc(FTokenPos);
                Result := tkStringConst;
              end;
            else
                Break;
          end;
        SectionLength := FTokenPos - TokenStart;
    {$ifdef UsePChar}
        SetLength(FCurTokenString, OldLength + SectionLength);
        if SectionLength > 0 then
            Move(TokenStart^, FCurTokenString[OldLength + 1], SectionLength);
    {$else}
        FCurTokenString := FCurTokenString + copy(FCurLine, TokenStart, SectionLength);
    {$endif}
        Inc(OldLength, SectionLength);
    until False;
end;

procedure TCSharpScanner.PushStackItem;

var
    SI: TIncludeStackItem;

begin
    if FIncludeStack.Count >= MaxIncludeStackDepth then
        Error(nErrIncludeLimitReached, SErrIncludeLimitReached);
    SI := TIncludeStackItem.Create;
    SI.SourceFile := CurSourceFile;
    SI.Filename := CurFilename;
    SI.Token := CurToken;
    SI.TokenString := CurTokenString;
    SI.Line := CurLine;
    SI.Row := CurRow;
    SI.ColumnOffset := FCurColumnOffset;
    SI.TokenPos := FTokenPos;
    FIncludeStack.Add(SI);
    FTokenPos :=
{$ifdef UsePChar}
        nil
{$else}
        -1
{$endif}
    ;
    FCurRow := 0;
    FCurColumnOffset := 1;
end;

procedure TCSharpScanner.HandleIncludeFile(Param: string);

var
    NewSourceFile: TLineReader;
begin
    Param := Trim(Param);
    if Length(Param) > 1 then
      begin
        if (Param[1] = '''') then
          begin
            if Param[length(Param)] <> '''' then
                Error(nErrOpenString, SErrOpenString, []);
            Param := copy(Param, 2, length(Param) - 2);
          end;
      end;
    NewSourceFile := FileResolver.FindIncludeFile(Param);
    if not Assigned(NewSourceFile) then
        Error(nErrIncludeFileNotFound, SErrIncludeFileNotFound, [Param]);

    PushStackItem;
    FCurSourceFile := NewSourceFile;
    FCurFilename := Param;
    if FCurSourceFile is TFileLineReader then
        FCurFilename := TFileLineReader(FCurSourceFile).Filename; // nicer error messages
    AddFile(FCurFilename);
    if LogEvent(sleFile) then
        DoLog(mtInfo, nLogOpeningFile, SLogOpeningFile,
            [FormatPath(FCurFileName)], True);
end;

procedure TCSharpScanner.HandleResource(Param: string);

var
    Ext, aFullFileName, aFilename, aOptions: string;
    P: integer;
    H: TResourceHandler;
    OptList: TStrings;

begin
    aFilename := '';
    aOptions := '';
    P := Pos(';', Param);
    if P = 0 then
        aFileName := Trim(Param)
    else
      begin
        aFileName := Trim(Copy(Param, 1, P - 1));
        aOptions := Copy(Param, P + 1, Length(Param) - P);
      end;
    Ext := ExtractFileExt(aFileName);
    // Construct & find filename
    if (ChangeFileExt(aFileName, '') = '*') then
        aFileName := ChangeFileExt(ExtractFileName(CurFilename), Ext);
    aFullFileName := FileResolver.FindResourceFileName(aFileName);
    if aFullFileName = '' then
        Error(nResourceFileNotFound, SErrResourceFileNotFound, [aFileName]);
    // Check if we can find a handler.
    if Ext <> '' then
        Ext := Copy(Ext, 2, Length(Ext) - 1);
    H := FindResourceHandler(LowerCase(Ext));
    if (H = nil) then
        H := FindResourceHandler('*');
    if (H = nil) then
      begin
        if not (po_IgnoreUnknownResource in Options) then
            Error(nNoResourceSupport, SNoResourceSupport, [Ext]);
        exit;
      end;
    // Let the handler take care of the rest.
    OptList := TStringList.Create;
      try
        OptList.NameValueSeparator := ':';
        OptList.Delimiter := ';';
        OptList.StrictDelimiter := True;
        OptList.DelimitedText := aOptions;
        H(Self, aFullFileName, OptList);
      finally
        OptList.Free;
      end;
end;

procedure TCSharpScanner.HandleOptimizations(Param: string);
// $optimization A,B-,C+
var
    p, StartP, l: integer;
    OptName, Value: string;
begin
    p := 1;
    l := length(Param);
    while p <= l do
      begin
        // read next flag
        // skip whitespace
        while (p <= l) and (Param[p] in [' ', #9, #10, #13]) do
            Inc(p);
        // read name
        StartP := p;
        while (p <= l) and (Param[p] in ['a'..'z', 'A'..'Z', '0'..'9', '_']) do
            Inc(p);
        if p = StartP then
            Error(nWarnIllegalCompilerDirectiveX, sWarnIllegalCompilerDirectiveX,
                ['optimization']);
        OptName := copy(Param, StartP, p - StartP);
        // skip whitespace
        while (p <= l) and (Param[p] in [' ', #9, #10, #13]) do
            Inc(p);
        // read value
        StartP := p;
        while (p <= l) and (Param[p] <> ',') do
            Inc(p);
        Value := TrimRight(copy(Param, StartP, p - StartP));
        DoHandleOptimization(OptName, Value);
        Inc(p);
      end;
end;

procedure TCSharpScanner.DoHandleOptimization(OptName, OptValue: string);
begin
    // default: skip any optimization directive
    if OptName = '' then
    ;
    if OptValue = '' then
    ;
end;


procedure TCSharpScanner.HandleInterfaces(const Param: string);
var
    s, NewValue: string;
    p: SizeInt;
begin
    if not (vsInterfaces in AllowedValueSwitches) then
        Error(nWarnIllegalCompilerDirectiveX, sWarnIllegalCompilerDirectiveX,
            ['interfaces']);
    s := Uppercase(Param);
    p := Pos(' ', s);
    if p > 0 then
        s := LeftStr(s, p - 1);
    case s of
        'COM', 'DEFAULT': NewValue := 'COM';
        'CORBA': NewValue := 'CORBA';
        else
            Error(nWarnIllegalCompilerDirectiveX, sWarnIllegalCompilerDirectiveX,
                ['interfaces ' + s]);
            exit;
      end;
    if SameText(NewValue, CurrentValueSwitch[vsInterfaces]) then
        exit;
    if vsInterfaces in ReadOnlyValueSwitches then
      begin
        Error(nWarnIllegalCompilerDirectiveX, sWarnIllegalCompilerDirectiveX,
            ['interfaces']);
        exit;
      end;
    CurrentValueSwitch[vsInterfaces] := NewValue;
end;

procedure TCSharpScanner.HandleWarn(Param: string);
// $warn identifier on|off|default|error
var
    p, StartPos: integer;
    Identifier, Value: string;
begin
    p := 1;
    while (p <= length(Param)) and (Param[p] in [' ', #9]) do
        Inc(p);
    StartPos := p;
    while (p <= length(Param)) and (Param[p] in IdentChars) do
        Inc(p);
    Identifier := copy(Param, StartPos, p - StartPos);
    while (p <= length(Param)) and (Param[p] in [' ', #9]) do
        Inc(p);
    StartPos := p;
    while (p <= length(Param)) and (Param[p] in Letters+['_']) do
        Inc(p);
    Value := copy(Param, StartPos, p - StartPos);
    HandleWarnIdentifier(Identifier, Value);
end;

procedure TCSharpScanner.HandleWarnIdentifier(Identifier, Value: string);
var
    Number: longint;
    State: TWarnMsgState;
    Handled: boolean;
begin
    if Identifier = '' then
        Error(nIllegalStateForWarnDirective, SIllegalStateForWarnDirective, ['']);
    if Value = '' then
      begin
        DoLog(mtWarning, nIllegalStateForWarnDirective,
            SIllegalStateForWarnDirective, ['']);
        exit;
      end;
    case lowercase(Value) of
        'on': State := wmsOn;
        'off': State := wmsOff;
        'default': State := wmsDefault;
        'error': State := wmsError;
        else
            DoLog(mtWarning, nIllegalStateForWarnDirective,
                SIllegalStateForWarnDirective, [Value]);
            exit;
      end;

    if Assigned(OnWarnDirective) then
      begin
        Handled := False;
        OnWarnDirective(Self, Identifier, State, Handled);
        if Handled then
            exit;
      end;

    if Identifier[1] in ['0'..'9'] then
      begin
        // fpc number
        Number := StrToIntDef(Identifier, -1);
        if Number < 0 then
          begin
            DoLog(mtWarning, nIllegalStateForWarnDirective,
                SIllegalStateForWarnDirective,
                [Identifier]);
            exit;
          end;
        SetWarnMsgState(Number, State);
      end;
end;

procedure TCSharpScanner.HandleDefine(Param: string);

var
    Index: integer;
    MName, MValue: string;

begin
    Param := UpperCase(Param);
    Index := Pos(':=', Param);
    if (Index = 0) then
        AddDefine(GetMacroName(Param))
    else
      begin
        MValue := Trim(Param);
        MName := Trim(Copy(MValue, 1, Index - 1));
        Delete(MValue, 1, Index + 1);
        AddMacro(MName, MValue);
      end;
end;

procedure TCSharpScanner.HandleError(Param: string);
begin
    if po_StopOnErrorDirective in Options then
        Error(nUserDefined, SUserDefined, [Param])
    else
        DoLog(mtWarning, nUserDefined, SUserDefined + ' error', [Param]);
end;

procedure TCSharpScanner.HandleLine(Param: string);
begin
    DoLog(mtInfo, nUserDefined, SUserDefined + ' Line', [Param]);
end;

procedure TCSharpScanner.HandleRegion(Param: string);
begin
    DoLog(mtInfo, nUserDefined, SUserDefined + ' Region', [Param]);
end;

procedure TCSharpScanner.HandleEndRegion(Param: string);
begin
    DoLog(mtInfo, nUserDefined, SUserDefined + ' EndRegion', [Param]);
end;

procedure TCSharpScanner.HandlePragma(Param: string);
begin
    DoLog(mtInfo, nUserDefined, SUserDefined + ' pragma', [Param]);
end;

procedure TCSharpScanner.HandleUnDefine(Param: string);
begin
    UnDefine(GetMacroName(Param));
end;

function TCSharpScanner.HandleInclude(const Param: string): TToken;

begin
    Result := tkComment;
    if (Param <> '') and (Param[1] = '%') then
      begin
        FCurTokenString := '''' + Param + '''';
        FCurToken := tkString;
        Result := FCurToken;
      end
    else
        HandleIncludeFile(Param);
end;

procedure TCSharpScanner.PushSkipMode;

begin
    if CShSkipStackIndex = High(CShSkipModeStack) then
        Error(nErrIfXXXNestingLimitReached, SErrIfXXXNestingLimitReached);
    CShSkipModeStack[CShSkipStackIndex] := CShSkipMode;
    CShIsSkippingStack[CShSkipStackIndex] := CShIsSkipping;
    Inc(CShSkipStackIndex);
end;

procedure TCSharpScanner.HandleIFDEF(const AParam: string);
var
    aName: string;
begin
    PushSkipMode;
    if CShIsSkipping then
        CShSkipMode := csSkipAll
    else
      begin
        aName := ReadIdentifier(AParam);
        if IsDefined(aName) then
            CShSkipMode := csSkipElseBranch
        else
          begin
            CShSkipMode := csSkipIfBranch;
            CShIsSkipping := True;
          end;
        if LogEvent(sleConditionals) then
            if CShSkipMode = csSkipElseBranch then
                DoLog(mtInfo, nLogIFDefAccepted, sLogIFDefAccepted, [aName])
            else
                DoLog(mtInfo, nLogIFDefRejected, sLogIFDefRejected, [aName]);
      end;
end;

procedure TCSharpScanner.HandleIFNDEF(const AParam: string);
var
    aName: string;
begin
    PushSkipMode;
    if CShIsSkipping then
        CShSkipMode := csSkipAll
    else
      begin
        aName := ReadIdentifier(AParam);
        if IsDefined(aName) then
          begin
            CShSkipMode := csSkipIfBranch;
            CShIsSkipping := True;
          end
        else
            CShSkipMode := csSkipElseBranch;
        if LogEvent(sleConditionals) then
            if CShSkipMode = csSkipElseBranch then
                DoLog(mtInfo, nLogIFNDefAccepted, sLogIFNDefAccepted, [aName])
            else
                DoLog(mtInfo, nLogIFNDefRejected, sLogIFNDefRejected, [aName]);
      end;
end;

procedure TCSharpScanner.HandleIF(const AParam: string);

begin
    PushSkipMode;
    if CShIsSkipping then
        CShSkipMode := csSkipAll
    else
      begin
        if ConditionEval.Eval(AParam) then
            CShSkipMode := csSkipElseBranch
        else
          begin
            CShSkipMode := csSkipIfBranch;
            CShIsSkipping := True;
          end;
        if LogEvent(sleConditionals) then
            if CShSkipMode = csSkipElseBranch then
                DoLog(mtInfo, nLogIFAccepted, sLogIFAccepted, [AParam])
            else
                DoLog(mtInfo, nLogIFRejected, sLogIFRejected, [AParam]);
      end;
end;

procedure TCSharpScanner.HandleELSEIF(const AParam: string);
begin
    if CShSkipStackIndex = 0 then
        Error(nErrInvalidPPElse, sErrInvalidPPElse);
    if CShSkipMode = csSkipIfBranch then
      begin
        if ConditionEval.Eval(AParam) then
          begin
            CShSkipMode := csSkipElseBranch;
            CShIsSkipping := False;
          end
        else
            CShIsSkipping := True;
        if LogEvent(sleConditionals) then
            if CShSkipMode = csSkipElseBranch then
                DoLog(mtInfo, nLogELSEIFAccepted, sLogELSEIFAccepted, [AParam])
            else
                DoLog(mtInfo, nLogELSEIFRejected, sLogELSEIFRejected, [AParam]);
      end
    else if CShSkipMode = csSkipElseBranch then
      begin
        CShIsSkipping := True;
      end;
end;

procedure TCSharpScanner.HandleELSE(const AParam: string);

begin
    if AParam = '' then;
    if CShSkipStackIndex = 0 then
        Error(nErrInvalidPPElse, sErrInvalidPPElse);
    if CShSkipMode = csSkipIfBranch then
        CShIsSkipping := False
    else if CShSkipMode = csSkipElseBranch then
        CShIsSkipping := True;
end;


procedure TCSharpScanner.HandleENDIF(const AParam: string);

begin
    if AParam = '' then;
    if CShSkipStackIndex = 0 then
        Error(nErrInvalidPPEndif, sErrInvalidPPEndif);
    Dec(CShSkipStackIndex);
    CShSkipMode := CShSkipModeStack[CShSkipStackIndex];
    CShIsSkipping := CShIsSkippingStack[CShSkipStackIndex];
end;

function TCSharpScanner.HandleDirective(const ADirectiveText: string): TToken;

var
    Directive, Param: string;
    P: integer;
    Handled: boolean;

    procedure DoBoolDirective(bs: TBoolSwitch);
    begin
        if bs in AllowedBoolSwitches then
          begin
            Handled := True;
            HandleBoolDirective(bs, Param);
          end
        else
            Handled := False;
    end;

begin
    Result := tkLineComment;
    P := Pos(' ', ADirectiveText);
    if P = 0 then
        P := Length(ADirectiveText) + 1;
    Directive := Copy(ADirectiveText, 2, P - 2); // 1 is $
    Param := ADirectiveText;
    Delete(Param, 1, P);
  {$IFDEF VerbosePasDirectiveEval}
  Writeln('TPascalScanner.HandleDirective.Directive: "',Directive,'", Param : "',Param,'"');
  {$ENDIF}

    case UpperCase(Directive) of
        'IF':
            HandleIF(Param);
        'ELIF':
            HandleELSEIF(Param);
        'ELSE':
            HandleELSE(Param);
        'ENDIF':
            HandleENDIF(Param);
        else
            if CShIsSkipping then
                exit;

            Handled := False;
            if (length(Directive) = 2) and (Directive[1] in ['a'..'z', 'A'..'Z']) and
                (Directive[2] in ['-', '+']) then
              begin
                Handled := True;
                Result := HandleLetterDirective(Directive[1], Directive[2] = '+');
              end;

            if not Handled then
              begin
                Handled := True;
                Param := Trim(Param);
                case Directive of
                    'define':
                        HandleDefine(Param);
                    'undef':
                        HandleUnDefine(Param);
                    'warning':
                        HandleWarn(Param);
                    'error':
                        HandleError(Param);
                    'line':
                        HandleLine(Param);
                    'region':
                        HandleRegion(Param);
                    'endregion':
                        HandleEndRegion(Param);
                    'pragma':
                        HandlePragma(Param);
                    else
                        Handled := False;
                  end;
              end;

            DoHandleDirective(Self, Directive, Param, Handled);
            if (not Handled) then
                if LogEvent(sleDirective) then
                    DoLog(mtWarning, nWarnIllegalCompilerDirectiveX,
                        sWarnIllegalCompilerDirectiveX,
                        [Directive]);
      end;
end;

function TCSharpScanner.HandleLetterDirective(Letter: char; Enable: boolean): TToken;
var
    bs: TBoolSwitch;
begin
    Result := tkComment;
    Letter := upcase(Letter);
    bs := LetterToBoolSwitch[Letter];
    if bs = bsNone then
        DoLog(mtWarning, nWarnIllegalCompilerDirectiveX, sWarnIllegalCompilerDirectiveX,
            [Letter]);
    if not (bs in AllowedBoolSwitches) then
      begin
        DoLog(mtWarning, nWarnIllegalCompilerDirectiveX, sWarnIllegalCompilerDirectiveX,
            [Letter]);
      end;
    if (bs in FCurrentBoolSwitches) <> Enable then
      begin
        if bs in FReadOnlyBoolSwitches then
          begin
            DoLog(mtWarning, nWarnIllegalCompilerDirectiveX,
                sWarnIllegalCompilerDirectiveX,
                [Letter + BoolToStr(Enable, '+', '-')]);
            exit;
          end;
        if Enable then
          begin
            AddDefine(LetterSwitchNames[Letter]);
            Include(FCurrentBoolSwitches, bs);
          end
        else
          begin
            UnDefine(LetterSwitchNames[Letter]);
            Exclude(FCurrentBoolSwitches, bs);
          end;
      end;
end;

procedure TCSharpScanner.HandleBoolDirective(bs: TBoolSwitch; const Param: string);
var
    NewValue: boolean;

begin
    if CompareText(Param, 'on') = 0 then
        NewValue := True
    else if CompareText(Param, 'off') = 0 then
        NewValue := False
    else
      begin
        NewValue := True;// Fool compiler
        Error(nErrXExpectedButYFound, SErrXExpectedButYFound, ['on', Param]);
      end;
    if (bs in CurrentBoolSwitches) = NewValue then
        exit;
    if bs in ReadOnlyBoolSwitches then
        DoLog(mtWarning, nWarnIllegalCompilerDirectiveX, sWarnIllegalCompilerDirectiveX,
            [BoolSwitchNames[bs]])
    else if NewValue then
        CurrentBoolSwitches := CurrentBoolSwitches + [bs]
    else
        CurrentBoolSwitches := CurrentBoolSwitches - [bs];
end;

procedure TCSharpScanner.DoHandleComment(Sender: TObject; const aComment: string);
begin
    if Assigned(OnComment) then
        OnComment(Sender, aComment);
end;

procedure TCSharpScanner.DoHandleDirective(Sender: TObject;
    Directive, Param: string; var Handled: boolean);
begin
    if Assigned(OnDirective) then
        OnDirective(Sender, Directive, Param, Handled);
end;

function TCSharpScanner.DoFetchToken: TToken;
var
    TokenStart:
{$ifdef UsePChar}
    PChar
{$else}
    integer
{$endif}
    ;
    i: TToken;
    SectionLength, Index: integer;
  {$ifdef UsePChar}
    OldLength, j: integer;
    ch0: Char;
    TestKey: UnicodeString;

  {$else}
    s: string;
    l: integer;

  {$endif}

  function FetchActChar:Char;inline ;
begin
     {$ifdef UsePChar}
    result :=    FTokenPos[0]
{$else}
    if TokenPos <= l then
      result :=    s[FTokenPos]
    else
      result := #0;
{$endif}
  end;

  function FetchNextChar:Char;inline;
begin
     {$ifdef UsePChar}
    result :=    FTokenPos[1]
{$else}
    if TokenPos < l then
      result :=    s[FTokenPos+1]
    else
      result := #0;
{$endif}
  end ;

    procedure FetchCurTokenString; inline;
    begin
    {$ifdef UsePChar}
        SetLength(FCurTokenString, SectionLength);
        if SectionLength > 0 then
            Move(TokenStart^, FCurTokenString[1], SectionLength);
    {$else}
        FCurTokenString := copy(FCurLine, TokenStart, SectionLength);
    {$endif}
    end;

    function FetchLocalLine: boolean; inline;
    begin
        Result := FetchLine;
    {$ifndef UsePChar}
        if not Result then
            exit;
        s := FCurLine;
        l := length(s);
    {$endif}
    end;

    procedure FetchNumber;
    begin
        // 1, 12, 1.2, 1.2E3, 1.E2, 1E2, 1.2E-3, 1E+2
        // also typed Numbers like 1f 2d 3l
        // beware of 1..2
        TokenStart := FTokenPos;
        repeat
            Inc(FTokenPos);
        until not ( FetchActChar  in Digits);
        if ( FetchActChar = '.') and (FetchNextChar <> '.') then
          begin
            Inc(FTokenPos);
            while ( FetchActChar  in Digits) do
                Inc(FTokenPos);
          end;
        // Check for Exponent
        if ( FetchActChar in ['e']) then
          begin
            Inc(FTokenPos);
            if (FetchActChar  in ['-', '+'])

            then
                Inc(FTokenPos);
            while (FetchActChar in Digits)
                do
                Inc(FTokenPos);
          end;
        // Check for type
        if ( FetchActChar  in ['b', 'd', 'f', 'l'])
        then
           Inc(FTokenPos);
        SectionLength := FTokenPos - TokenStart;
        FetchCurTokenString;
        Result := tkNumber;
    end;

    procedure FetchMLComment(Start: string);
    var
        NestingLevel: integer;
        ch: char;

    begin
          begin
            // Multi-line comment
          //  Inc(FTokenPos);
            TokenStart := FTokenPos;
            FCurTokenString := '';
            {$ifdef UsePChar}
            OldLength := 0;
            {$endif}
            NestingLevel := 0;
            repeat
                if  FetchActChar  = #0   then
                  begin
                    SectionLength := FTokenPos - TokenStart;
                {$ifdef UsePChar}
                    SetLength(FCurTokenString, OldLength + SectionLength +
                        length(LineEnding));
                    // +1 for #10
                    if SectionLength > 0 then
                        Move(TokenStart^, FCurTokenString[OldLength + 1], SectionLength);
                    Inc(OldLength, SectionLength);
                    for ch in string(LineEnding) do
                      begin
                        Inc(OldLength);
                        FCurTokenString[OldLength] := ch;
                      end;
                {$else}
                    FCurTokenString :=
                        FCurTokenString + copy(
                        FCurLine, TokenStart, SectionLength) + LineEnding;
                {$endif}
                    if not FetchLocalLine then
                      begin
                        Result := tkEOF;
                        FCurToken := Result;
                        exit;
                      end;
                    TokenStart := FTokenPos;
                  end
                else if (FetchActChar  = '*') and (FetchNextChar = '/') then
                  begin
                    Dec(NestingLevel);
                    if NestingLevel < 0 then
                        break;
                    Inc(FTokenPos, 2);
                  end
                else if (FetchActChar  = '/') and (FetchNextChar = '*')  then
                  begin
                    Inc(FTokenPos, 2);
                    Inc(NestingLevel);
                  end
                else
                    Inc(FTokenPos);
            until False;
            SectionLength := FTokenPos - TokenStart;
            {$ifdef UsePChar}
            SetLength(FCurTokenString, OldLength + SectionLength);
            if SectionLength > 0 then
                Move(TokenStart^, FCurTokenString[OldLength + 1], SectionLength);
            {$else}
            FCurTokenString :=
                FCurTokenString + copy(FCurLine, TokenStart, SectionLength);
            {$endif}
            Inc(FTokenPos, 2);
            Result := tkComment;
            DoHandleComment(Self, CurTokenString);
          end;
    end;

begin
    TokenStart :=
{$ifdef UsePChar}
        nil
{$else}
        0
{$endif}
    ;
    Result := tkLineEnding;
    if FTokenPos
{$ifdef UsePChar}
        = nil
{$else}
        < 1
{$endif}
    then
        if not FetchLine then
          begin
            Result := tkEOF;
            FCurToken := Result;
            exit;
          end;
    FCurTokenString := '';
    FCurTokenPos.FileName := CurFilename;
    FCurTokenPos.Row := CurRow;
    FCurTokenPos.Column := CurColumn;
  {$ifndef UsePChar}
    s := FCurLine;
    l := length(s);
    if FTokenPos > l then
      begin
        FetchLine;
        Result := tkLineEnding;
        FCurToken := Result;
        exit;
      end;
  {$endif}
    ch0 := FetchActChar;
    if assigned(TokenIndex[ch0]) then
       begin
         inc(FTokenPos);
         TestKey := ch0 + FetchActChar+FetchNextChar;
         for j := 0 to high(TokenIndex[ch0]) do
           if copy(TokenIndex[ch0][j].key,1,3) = copy(testkey,1,TokenIndex[ch0][j].l) then
              begin
                 if (TokenIndex[ch0][j].l <=3) and not (ch0 in IdentChars) then
                   begin
                     result := TokenIndex[ch0][j].token;
                     inc(FTokenPos,TokenIndex[ch0][j].l-1);
                     break;
                   end
                 else
                   begin
                     if CurTokenString = '' then
                       begin
                         TokenStart := FTokenPos-1;
                         while FetchActChar in IdentChars do
                           Inc(FTokenPos);
                         SectionLength := FTokenPos - TokenStart;
                         FetchCurTokenString;
                       end;
                     if CurTokenString = TokenIndex[ch0][j].key then
                       begin
                         result := TokenIndex[ch0][j].token;
                         break
                       end
                   end
              end;

           case result of
               tkComment: FetchMLComment(TokenInfos[result]);
               tkLineComment: begin
                  TokenStart := FTokenPos;
                  FCurTokenString := '';
                  while FetchActChar <> #0  do
                      Inc(FTokenPos);
                  SectionLength := FTokenPos - TokenStart;
                  FetchCurTokenString;
              end;
             tkLineEnding:if ch0 in IdentChars then
               begin
               if CurTokenString = '' then
                 begin
                 TokenStart := FTokenPos-1;
                 while FetchActChar in IdentChars do
                   Inc(FTokenPos);
                 SectionLength := FTokenPos - TokenStart;
                 FetchCurTokenString;
                 end;
                 result := tkIdentifier;
               end;
           end;
         end
       else
    case  ch0  of
    {$ifdef UsePChar}
        #0:         // Empty line
          begin
            FetchLine;
            Result := tkLineEnding;
          end;
    {$endif}
        ' ':
          begin
            Result := tkWhitespace;
            repeat
                Inc(FTokenPos);
                if FetchActChar = #0 then
                    if not FetchLocalLine then
                      begin
                        FCurToken := Result;
                        exit;
                      end;
            until not (FetchActChar = ' ');
          end;
        #9:
          begin
            Result := tkTab;
            repeat
                Inc(FTokenPos);
                if FetchActChar = #0  then
                    if not FetchLocalLine then
                      begin
                        FCurToken := Result;
                        exit;
                      end;
            until not (FetchActChar= #9);
          end;
        '#': // Compiler Directive
          begin
            TokenStart := FTokenPos;
            FCurTokenString := '';
            while FetchActChar <> #0 do
                Inc(FTokenPos);
            SectionLength := FTokenPos - TokenStart;
            FetchCurTokenString;
            Result := HandleDirective(CurTokenString);
          end;
        '''', '"':
            Result := DoFetchTextToken;
{        '&':
          begin
            Result := tkSingleAnd;
            Inc(FTokenPos);
            if FetchActChar = '&' then
              begin
                Inc(FTokenPos);
                Result := tkAnd;
              end;
            if FetchActChar = '=' then
              begin
                Inc(FTokenPos);
                Result := tkAssignAnd;
              end;

          end;
        '|':
          begin
            Result := tkSingleOr;
            Inc(FTokenPos);
            if FetchActChar = '|'  then
              begin
                Inc(FTokenPos);
                Result := tkOr;
              end;
            if FetchActChar = '=' then
              begin
                Inc(FTokenPos);
                Result := tkAssignOr;
              end;

          end;
        '~':
          begin
            Result := tkKomplement;
            Inc(FTokenPos);
          end; }
        '@':
          begin
            Inc(FTokenPos);
            if FetchActChar = '"'  then
                Result := DoFetchTextToken('@');
          end;
        '$':
          begin
            Inc(FTokenPos);
            if FetchActChar = '"'  then
                Result := DoFetchTextToken('$');
          end;
{        '%':
          begin
            Result := tkmod;
            Inc(FTokenPos);
            if  FetchActChar = '=' then
              begin
                Inc(FTokenPos);
                Result := tkAssignModulo;
              end;
          end;
        '(':
          begin
            Inc(FTokenPos);
            Result := tkBraceOpen;
          end;
        ')':
          begin
            Inc(FTokenPos);
            Result := tkBraceClose;
          end;
        '*':
          begin
            Result := tkMul;
            Inc(FTokenPos);
            if FetchActChar = '*' then
              begin
                Inc(FTokenPos);
                Result := tkPower;
              end
            else if FetchActChar = '='  then
              begin
                Inc(FTokenPos);
                Result := tkAssignMul;
              end;

          end;
        '+':
          begin
            Result := tkPlus;
            Inc(FTokenPos);
            if FetchActChar = '=' then
              begin
                Inc(FTokenPos);
                Result := tkAssignPlus;
              end
            else if FetchActChar = '+' then
              begin
                Inc(FTokenPos);
                Result := tkPlusPlus;
              end;
          end;
        ',':
          begin
            Inc(FTokenPos);
            Result := tkComma;
          end;
        '-':
          begin
            Result := tkMinus;
            Inc(FTokenPos);
            if FetchActChar = '=' then
              begin
                Inc(FTokenPos);
                Result := tkAssignMinus;
              end
            else if FetchActChar = '-' then
               begin
                 Inc(FTokenPos);
                 Result := tkMinusMinus;
               end;
          end;
        '.':
          begin
            Inc(FTokenPos);
            Result := tkDot;
            if FetchActChar =  '.'  then
              begin
                Inc(FTokenPos);
                Result := tkDotDot;
              end
          end;
        '/':
          begin
            Result := tkDivision;
            Inc(FTokenPos);
            if FetchActChar =  '/'  then
              begin
                // Single-line comment
                Inc(FTokenPos);
                TokenStart := FTokenPos;
                FCurTokenString := '';
                while FetchActChar <> #0  do
                    Inc(FTokenPos);
                SectionLength := FTokenPos - TokenStart;
                FetchCurTokenString;
                Result := tkLineComment;
              end
            else if FetchActChar = '='  then
              begin
                Inc(FTokenPos);
                Result := tkAssignDivision;
              end
            else if FetchActChar  = '*') then
                FetchMLComment('/*');

          end; }
        '0'..'9':
            FetchNumber;
   {     ':':
          begin
            Inc(FTokenPos);
            Result := tkColon;
          end;
        '?':
          begin
            Inc(FTokenPos);
            Result := tkAsk;
            if FetchActChar  = '?' then
              begin
                Inc(FTokenPos);
                Result := tkAskAsk;
                if FetchActChar  =   '=' then
                  begin
                    Inc(FTokenPos);
                    Result := tkAssignAsk;
                  end
              end

          end;
        ';':
          begin
            Inc(FTokenPos);
            Result := tkSemicolon;
          end;
        '<':
          begin
            Inc(FTokenPos);
            case FetchActChar  of
                '=':
                  begin
                    Inc(FTokenPos);
                    Result := tkLessEqualThan;
                  end;
                '<':
                  begin
                    Inc(FTokenPos);
                    Result := tkshl;
                    if FetchActChar  '=' then
                      begin
                        Inc(FTokenPos);
                        Result := tkAssignshl;
                      end;
                  end;
                else
                    Result := tkLessThan;
              end;
          end;
        '=':
          begin
            Inc(FTokenPos);
            Result := tkAssign;
            if FetchActChar = '=' then
              begin
                Inc(FTokenPos);
                Result := tkEqual;
              end
            else if FetchActChar  = '>' then
              begin
                Inc(FTokenPos);
                Result := tkLambda;
              end;
          end;
        '!':
          begin
            Inc(FTokenPos);
            Result := tkNot;
            if FetchActChar = '=' then
              begin
                Inc(FTokenPos);
                Result := tkNotEqual;
              end;
          end;
        '>':
          begin
            Inc(FTokenPos);
            case  FetchActChar  of
                '=':
                  begin
                    Inc(FTokenPos);
                    Result := tkGreaterEqualThan;
                  end;
                '<':
                  begin
                    Inc(FTokenPos);
                    Result := tkSymmetricalDifference;
                  end;
                '>':
                  begin
                    Inc(FTokenPos);
                    Result := tkshr;
                    if FetchActChar = '=' then
                      begin
                        Inc(FTokenPos);
                        Result := tkAssignshr;
                      end;

                  end;
                else
                    Result := tkGreaterThan;
              end;
          end;
        '[':
          begin
            Inc(FTokenPos);
            Result := tkSquaredBraceOpen;
          end;
        ']':
          begin
            Inc(FTokenPos);
            Result := tkSquaredBraceClose;
          end;
        '^':
          begin
                Inc(FTokenPos);
                Result := tkXor;
                if FetchActChar   '='  then
                  begin
                    Inc(FTokenPos);
                    Result := tkAssignXor;
                  end;
          end;
        '\':
          begin
            Inc(FTokenPos);
            Result := tkBackslash;
          end;
        '{':
          begin
            Inc(FTokenPos);
            Result := tkCurlyBraceOpen;
          end;
        '}':
          begin
            Inc(FTokenPos);
            Result := tkCurlyBraceClose;
          end;  }
        'A'..'Z', 'a'..'z', '_':
          begin
            TokenStart := FTokenPos;
            Inc(FTokenPos);
            while FetchActChar  in IdentChars do
              Inc(FTokenPos);
            SectionLength := FTokenPos - TokenStart;
            FetchCurTokenString;
            Result := tkIdentifier;
            for i := tkAbstract to high(TToken) do
              begin
                if CurTokenString = TokenInfos[i] then   // CSharp is case-sensitive
                  begin
                    Result := I;
                    break;
                  end;
              end;
            if (Result <> tkIdentifier) and (Result in FNonTokens) then
                Result := tkIdentifier;
            FCurToken := Result;
          end;
        else
            if CShIsSkipping then
                Inc(FTokenPos)
            else
                Error(nErrInvalidCharacter, SErrInvalidCharacter,
                    [FetchActChar ]);
      end;

    FCurToken := Result;
end;

function TCSharpScanner.LogEvent(E: TCShScannerLogEvent): boolean;
begin
    Result := E in FLogEvents;
end;

function TCSharpScanner.GetCurColumn: integer;
begin
    if
{$ifdef UsePChar}
    (FTokenPos <> nil)
{$else}
    FTokenPos > 0
{$endif}
    then
        Result := FTokenPos
{$ifdef UsePChar}
            - PChar(CurLine)
{$else}
            - 1
{$endif}
            + FCurColumnOffset
    else
        Result := FCurColumnOffset;
end;

function TCSharpScanner.GetCurrentValueSwitch(V: TValueSwitch): string;
begin
    Result := FCurrentValueSwitches[V];
end;

function TCSharpScanner.GetForceCaret: boolean;
begin
    Result := toForceCaret in FTokenOptions;
end;

function TCSharpScanner.GetMacrosOn: boolean;
begin
    Result := bsMacro in FCurrentBoolSwitches;
end;

function TCSharpScanner.IndexOfWarnMsgState(Number: integer;
    InsertPos: boolean): integer;
var
    l, r, m, CurNumber: integer;
begin
    l := 0;
    r := length(FWarnMsgStates) - 1;
    m := 0;
    while l <= r do
      begin
        m := (l + r) div 2;
        CurNumber := FWarnMsgStates[m].Number;
        if Number > CurNumber then
            l := m + 1
        else if Number < CurNumber then
            r := m - 1
        else
            exit(m);
      end;
    if not InsertPos then
        exit(-1);
    if length(FWarnMsgStates) = 0 then
        exit(0);
    if (m < length(FWarnMsgStates)) and (FWarnMsgStates[m].Number <= Number) then
        Inc(m);
    Result := m;
end;

function TCSharpScanner.OnCondEvalFunction(Sender: TCondDirectiveEvaluator;
    Name, Param: string; out Value: string): boolean;
begin
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TPascalScanner.OnCondEvalFunction Func="',Name,'" Param="',Param,'"');
  {$ENDIF}
    if CompareText(Name, 'defined') = 0 then
      begin
        if not IsValidIdent(Param) then
            Sender.Log(mtError, nErrXExpectedButYFound, SErrXExpectedButYFound,
                ['identifier', Param]);
        Value := CondDirectiveBool[IsDefined(Param)];
        exit(True);
      end
    else if CompareText(Name, 'undefined') = 0 then
      begin
        if not IsValidIdent(Param) then
            Sender.Log(mtError, nErrXExpectedButYFound, SErrXExpectedButYFound,
                ['identifier', Param]);
        Value := CondDirectiveBool[not IsDefined(Param)];
        exit(True);
      end
    else if CompareText(Name, 'option') = 0 then
      begin
        if (length(Param) <> 1) or not (Param[1] in ['a'..'z', 'A'..'Z']) then
            Sender.Log(mtError, nErrXExpectedButYFound, SErrXExpectedButYFound,
                ['letter', Param]);
        Value := CondDirectiveBool[IfOpt(Param[1])];
        exit(True);
      end;
    // last check user hook
    if Assigned(OnEvalFunction) then
      begin
        Result := OnEvalFunction(Sender, Name, Param, Value);
        if not (po_CheckCondFunction in Options) then
          begin
            Value := '0';
            Result := True;
          end;
        exit;
      end;
    if (po_CheckCondFunction in Options) then
      begin
        Value := '';
        Result := False;
      end
    else
      begin
        Value := '0';
        Result := True;
      end;
end;

procedure TCSharpScanner.OnCondEvalLog(Sender: TCondDirectiveEvaluator;
    Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif});
begin
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TPascalScanner.OnCondEvalLog "',Sender.MsgPattern,'"');
  {$ENDIF}
    // ToDo: move CurLine/CurRow to Sender.MsgPos
    if Sender.MsgType <= mtError then
      begin
        SetCurMsg(Sender.MsgType, Sender.MsgNumber, Sender.MsgPattern, Args);
        raise EScannerError.Create(FLastMsg);
      end
    else
        DoLog(Sender.MsgType, Sender.MsgNumber, Sender.MsgPattern, Args, True);
end;

function TCSharpScanner.OnCondEvalVar(Sender: TCondDirectiveEvaluator;
    Name: string; out Value: string): boolean;
var
    i: integer;
    M: TMacroDef;
begin
  {$IFDEF VerbosePasDirectiveEval}
  writeln('TPascalScanner.OnCondEvalVar "',Name,'"');
  {$ENDIF}
    // first check defines
    if FDefines.IndexOf(Name) >= 0 then
      begin
        Value := '1';
        exit(True);
      end;
    Value := '0';
    Result := False;
end;

procedure TCSharpScanner.SetAllowedBoolSwitches(const AValue: TBoolSwitches);
begin
    if FAllowedBoolSwitches = AValue then
        Exit;
    FAllowedBoolSwitches := AValue;
end;

procedure TCSharpScanner.SetAllowedModeSwitches(const AValue: TModeSwitches);
begin
    if FAllowedModeSwitches = AValue then
        Exit;
    FAllowedModeSwitches := AValue;
    CurrentModeSwitches := FCurrentModeSwitches * AllowedModeSwitches;
end;

procedure TCSharpScanner.SetAllowedValueSwitches(const AValue: TValueSwitches);
begin
    if FAllowedValueSwitches = AValue then
        Exit;
    FAllowedValueSwitches := AValue;
end;

procedure TCSharpScanner.SetCurrentBoolSwitches(const AValue: TBoolSwitches);
var
    OldBS: TBoolSwitches;
begin
    if FCurrentBoolSwitches = AValue then
        Exit;
    OldBS := FCurrentBoolSwitches;
    FCurrentBoolSwitches := AValue;
end;

procedure TCSharpScanner.SetCurrentModeSwitches(AValue: TModeSwitches);
var
    Old: TModeSwitches;
begin
    AValue := AValue * AllowedModeSwitches;
    if FCurrentModeSwitches = AValue then
        Exit;
    Old := FCurrentModeSwitches;
    FCurrentModeSwitches := AValue;
end;

procedure TCSharpScanner.SetCurrentValueSwitch(V: TValueSwitch; const AValue: string);
begin
    if not (V in AllowedValueSwitches) then
        exit;
    if FCurrentValueSwitches[V] = AValue then
        exit;
    FCurrentValueSwitches[V] := AValue;
end;

procedure TCSharpScanner.SetWarnMsgState(Number: integer; State: TWarnMsgState);

  {$IFDEF EmulateArrayInsert}
  procedure Delete(var A: TWarnMsgNumberStateArr; Index, Count: integer); overload;
  var
    i: Integer;
  begin
    if Index<0 then
      Error(nErrDivByZero,'[20180627142123]');
    if Index+Count>length(A) then
      Error(nErrDivByZero,'[20180627142127]');
    for i:=Index+Count to length(A)-1 do
      A[i-Count]:=A[i];
    SetLength(A,length(A)-Count);
  end;

  procedure Insert(Item: TWarnMsgNumberState; var A: TWarnMsgNumberStateArr; Index: integer); overload;
  var
    i: Integer;
  begin
    if Index<0 then
      Error(nErrDivByZero,'[20180627142133]');
    if Index>length(A) then
      Error(nErrDivByZero,'[20180627142137]');
    SetLength(A,length(A)+1);
    for i:=length(A)-1 downto Index+1 do
      A[i]:=A[i-1];
    A[Index]:=Item;
  end;
  {$ENDIF}

var
    i: integer;
    Item: TWarnMsgNumberState;
begin
    i := IndexOfWarnMsgState(Number, True);
    if (i < length(FWarnMsgStates)) and (FWarnMsgStates[i].Number = Number) then
      begin
        // already exists
        if State = wmsDefault then
            Delete(FWarnMsgStates, i, 1)
        else
            FWarnMsgStates[i].State := State;
      end
    else if State <> wmsDefault then
      begin
        // new state
        Item.Number := Number;
        Item.State := State;
        Insert(Item, FWarnMsgStates, i);
      end;
end;

function TCSharpScanner.GetWarnMsgState(Number: integer): TWarnMsgState;
var
    i: integer;
begin
    i := IndexOfWarnMsgState(Number, False);
    if i < 0 then
        Result := wmsDefault
    else
        Result := FWarnMsgStates[i].State;
end;

procedure TCSharpScanner.SetMacrosOn(const AValue: boolean);
begin
    if AValue then
        Include(FCurrentBoolSwitches, bsMacro)
    else
        Exclude(FCurrentBoolSwitches, bsMacro);
end;

procedure TCSharpScanner.DoLog(MsgType: TMessageType; MsgNumber: integer;
    const Msg: string; SkipSourceInfo: boolean);
begin
    DoLog(MsgType, MsgNumber, Msg, [], SkipSourceInfo);
end;

procedure TCSharpScanner.DoLog(MsgType: TMessageType; MsgNumber: integer;
    const Fmt: string; Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif}; SkipSourceInfo: boolean);

var
    Msg: string;

begin
    if IgnoreMsgType(MsgType) then
        exit;
    SetCurMsg(MsgType, MsgNumber, Fmt, Args);
    if Assigned(FOnLog) then
      begin
        Msg := MessageTypeNames[MsgType] + ': ';
        if SkipSourceInfo then
            Msg := Msg + FLastMsg
        else
            Msg := Msg + Format('%s(%d,%d) : %s',
                [FormatPath(FCurFileName), CurRow, CurColumn, FLastMsg]);
        FOnLog(Self, Msg);
      end;
end;

procedure TCSharpScanner.SetOptions(AValue: TCShOptions);

begin
    if FOptions = AValue then
        Exit;
    // Change of mode ?
    FOptions := AValue;
end;

procedure TCSharpScanner.SetReadOnlyBoolSwitches(const AValue: TBoolSwitches);
begin
    if FReadOnlyBoolSwitches = AValue then
        Exit;
    FReadOnlyBoolSwitches := AValue;
end;

procedure TCSharpScanner.SetReadOnlyModeSwitches(const AValue: TModeSwitches);
begin
    if FReadOnlyModeSwitches = AValue then
        Exit;
    FReadOnlyModeSwitches := AValue;
    FAllowedModeSwitches := FAllowedModeSwitches + FReadOnlyModeSwitches;
    FCurrentModeSwitches := FCurrentModeSwitches + FReadOnlyModeSwitches;
end;

procedure TCSharpScanner.SetReadOnlyValueSwitches(const AValue: TValueSwitches);
begin
    if FReadOnlyValueSwitches = AValue then
        Exit;
    FReadOnlyValueSwitches := AValue;
end;

function TCSharpScanner.IndexOfResourceHandler(const aExt: string): integer;

begin
    Result := Length(FResourceHandlers) - 1;
    while (Result >= 0) and (FResourceHandlers[Result].Ext <> aExt) do
        Dec(Result);
end;

function TCSharpScanner.FindResourceHandler(const aExt: string): TResourceHandler;

var
    Idx: integer;

begin
    Idx := IndexOfResourceHandler(aExt);
    if Idx = -1 then
        Result := nil
    else
        Result := FResourceHandlers[Idx].handler;
end;

function TCSharpScanner.ReadIdentifier(const AParam: string): string;
var
    p, l: integer;
begin
    p := 1;
    l := length(AParam);
    while (p <= l) and (AParam[p] in IdentChars) do
        Inc(p);
    Result := LeftStr(AParam, p - 1);
end;

function TCSharpScanner.FetchLine: boolean;
begin
    if CurSourceFile.IsEOF then
      begin
        if
{$ifdef UsePChar}
        FTokenPos <> nil
{$else}
        FTokenPos > 0
{$endif}
        then
          begin
            FCurLine := '';
            FTokenPos :=
{$ifdef UsePChar}
                nil
{$else}
                -1
{$endif}
            ;
            Inc(FCurRow); // set CurRow to last line+1
            Inc(FModuleRow);
            FCurColumnOffset := 1;
          end;
        Result := False;
      end
    else
      begin
        FCurLine := CurSourceFile.ReadLine;
        FTokenPos :=
{$ifdef UsePChar}
            PChar(CurLine)
{$else}
            1
{$endif}
        ;
        Result := True;
    {$ifdef PChar}
    if (FCurRow = 0)
    and (Length(CurLine) >= 3)
    and (FTokenPos[0] = #$EF)
    and (FTokenPos[1] = #$BB)
    and (FTokenPos[2] = #$BF) then
      // ignore UTF-8 Byte Order Mark
      inc(FTokenPos, 3);
    {$else}
        if (FCurRow = 0) and FCurLine.StartsWith(#$EF#$BB#$BF) then
            Inc(FTokenPos, 3);
    {$endif}
        Inc(FCurRow);
        Inc(FModuleRow);
        FCurColumnOffset := 1;
        if (FCurSourceFile is TMacroReader) and (FCurRow = 1) then
          begin
            FCurRow := TMacroReader(FCurSourceFile).CurRow;
            FCurColumnOffset := TMacroReader(FCurSourceFile).CurCol;
          end;
        if LogEvent(sleLineNumber) and (((FCurRow mod 100) = 0) or
            CurSourceFile.IsEOF) then
            DoLog(mtInfo, nLogLineNumber, SLogLineNumber, [FCurRow], True);
        // log last line
      end;
end;

procedure TCSharpScanner.AddFile(aFilename: string);
var
    i: integer;
begin
    for i := 0 to FFiles.Count - 1 do
        if FFiles[i] = aFilename then
            exit;
    FFiles.Add(aFilename);
end;

function TCSharpScanner.GetMacroName(const Param: string): string;
var
    p: integer;
begin
    Result := Trim(Param);
    p := 1;
    while (p <= length(Result)) and (Result[p] in IdentChars) do
        Inc(p);
    SetLength(Result, p - 1);
end;

procedure TCSharpScanner.SetCurMsg(MsgType: TMessageType; MsgNumber: integer;
    const Fmt: string; Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif});
begin
    FLastMsgType := MsgType;
    FLastMsgNumber := MsgNumber;
    FLastMsgPattern := Fmt;
    FLastMsg := SafeFormat(Fmt, Args);
    CreateMsgArgs(FLastMsgArgs, Args);
end;

function TCSharpScanner.AddDefine(const aName: string; Quiet: boolean): boolean;

begin
    if FDefines.IndexOf(aName) >= 0 then
        exit(False);
    Result := True;
    FDefines.Add(aName);
    if (not Quiet) and LogEvent(sleConditionals) then
        DoLog(mtInfo, nLogMacroDefined, sLogMacroDefined, [aName]);
end;

function TCSharpScanner.RemoveDefine(const aName: string; Quiet: boolean): boolean;

var
    I: integer;

begin
    I := FDefines.IndexOf(aName);
    if (I < 0) then
        exit(False);
    Result := True;
    FDefines.Delete(I);
    if (not Quiet) and LogEvent(sleConditionals) then
        DoLog(mtInfo, nLogMacroUnDefined, sLogMacroUnDefined, [aName]);
end;

function TCSharpScanner.UnDefine(const aName: string; Quiet: boolean): boolean;
begin
    // Important: always call both, do not use OR
    Result := RemoveDefine(aName, Quiet);
    if RemoveMacro(aName, Quiet) then
        Result := True;
end;

function TCSharpScanner.IsDefined(const aName: string): boolean;
begin
    Result := (FDefines.IndexOf(aName) >= 0) or (FMacros.IndexOf(aName) >= 0);
end;

function TCSharpScanner.IfOpt(Letter: char): boolean;
begin
    Letter := upcase(Letter);
    Result := (Letter in ['A'..'Z']) and (LetterSwitchNames[Letter] <> '') and
        IsDefined(LetterSwitchNames[Letter]);
end;

function TCSharpScanner.AddMacro(const aName, aValue: string; Quiet: boolean): boolean;
var
    Index: integer;
begin
    Index := FMacros.IndexOf(aName);
    if (Index = -1) then
        FMacros.AddObject(aName, TMacroDef.Create(aName, aValue))
    else
      begin
        if TMacroDef(FMacros.Objects[Index]).Value = aValue then
            exit(False);
        TMacroDef(FMacros.Objects[Index]).Value := aValue;
      end;
    Result := True;
    if (not Quiet) and LogEvent(sleConditionals) then
        DoLog(mtInfo, nLogMacroXSetToY, SLogMacroXSetToY, [aName, aValue]);
end;

function TCSharpScanner.RemoveMacro(const aName: string; Quiet: boolean): boolean;
var
    Index: integer;
begin
    Index := FMacros.IndexOf(aName);
    if Index < 0 then
        exit(False);
    Result := True;
    TMacroDef(FMacros.Objects[Index]).
{$ifdef pas2js}Destroy{$else}
        Free
{$endif}
    ;
    FMacros.Delete(Index);
    if (not Quiet) and LogEvent(sleConditionals) then
        DoLog(mtInfo, nLogMacroUnDefined, sLogMacroUnDefined, [aName]);
end;

procedure TCSharpScanner.SetCompilerMode(S: string);
begin

end;

function TCSharpScanner.CurSourcePos: TCShSourcePos;
begin
    Result.FileName := CurFilename;
    Result.Row := CurRow;
    Result.Column := CurColumn;
end;

function TCSharpScanner.SetForceCaret(AValue: boolean): boolean;

begin
    Result := toForceCaret in FTokenOptions;
    if aValue then
        Include(FTokenOptions, toForceCaret)
    else
        Exclude(FTokenOptions, toForceCaret);
end;

function TCSharpScanner.IgnoreMsgType(MsgType: TMessageType): boolean;
begin
    Result := False;
    case MsgType of
        mtWarning: if not (bsWarnings in FCurrentBoolSwitches) then
                exit(True);
        mtNote: if not (bsNotes in FCurrentBoolSwitches) then
                exit(True);
        mtHint: if not (bsHints in FCurrentBoolSwitches) then
                exit(True);
        else
        // Do nothing, satisfy compiler
      end;
end;

procedure AppendIdx(var a:TTokenKeyArray;const aStr:string;const aTkn:TToken);

var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to high(a) do
    if (a[i].l>length(aStr)) then
      idx:=i+1 else break;
  setlength(a,high(a)+2);
  for i := high(a) downto idx+1 do
     a[i] := a[i-1];
  with a[idx] do
    begin
      token:=aTkn;
      key:=aStr;
      l := length(aStr);
    end;
end;
var i:ttoken;
  initialization
for i := tkLineComment to high(TToken) do
  appendIdx(TokenIndex[TokenInfos[i][1]],TokenInfos[i],i);
end.
