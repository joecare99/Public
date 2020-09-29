{
  CSharp source parser

    This file is inspired & based on the

    Pascal source parser which is part of the Free Component Library

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        

 **********************************************************************}

unit CShParser;

{$i jcs-cshsrc.inc}

interface

uses
  {$ifdef NODEJS}
  Node.FS,
  {$endif}
  SysUtils, Classes, Types, CShTree, CShScanner;

// message numbers
const
  nErrNoSourceGiven = 2001;
  nErrMultipleSourceFiles = 2002;
  nParserError = 2003;
  nParserErrorAtToken = 2004;
  nParserUngetTokenError = 2005;
  nParserExpectTokenError = 2006;
  nParserForwardNotInterface = 2007;
  nParserExpectVisibility = 2008;
  nParserStrangeVisibility = 2009;
  nParserExpectToken2Error = 2010;
  nParserExpectedCommaRBracket = 2011;
  nParserExpectedCommaSemicolon = 2012;
  nParserExpectedAssignIn = 2013;
  nParserExpectedCommaColon = 2014;
  nErrUnknownOperatorType = 2015;
  nParserOnlyOneArgumentCanHaveDefault = 2016;
  nParserExpectedLBracketColon = 2017;
  nParserExpectedSemiColonEnd = 2018;
  nParserExpectedConstVarID = 2019;
  nParserExpectedNested = 2020;
  nParserExpectedColonID = 2021;
  nParserSyntaxError = 2022;
  nParserTypeSyntaxError = 2023;
  nParserArrayTypeSyntaxError = 2024;
  nParserExpectedIdentifier = 2026;
  nParserNotAProcToken = 2026;
  nRangeExpressionExpected = 2027;
  nParserExpectCase = 2028;
  nParserGenericFunctionNeedsGenericKeyword = 2029;
  nLogStartImplementation = 2030;
  nLogStartInterface = 2031;
  nParserNoConstructorAllowed = 2032;
  nParserNoFieldsAllowed = 2033;
  nParserInvalidRecordVisibility = 2034;
  nErrRecordConstantsNotAllowed = 2035;
  nErrRecordMethodsNotAllowed = 2036;
  nErrRecordPropertiesNotAllowed = 2037;
  nErrRecordTypesNotAllowed = 2038;
  nParserTypeNotAllowedHere = 2039;
  nParserNotAnOperand = 2040;
  nParserArrayPropertiesCannotHaveDefaultValue = 2041;
  nParserDefaultPropertyMustBeArray = 2042;
  nParserUnknownProcedureType = 2043;
  nParserGenericArray1Element = 2044;
  nParserTypeParamsNotAllowedOnType = 2045;
  nParserDuplicateIdentifier = 2046;
  nParserDefaultParameterRequiredFor = 2047;
  nParserOnlyOneVariableCanBeInitialized = 2048;
  nParserExpectedTypeButGot = 2049;
  nParserPropertyArgumentsCanNotHaveDefaultValues = 2050;
  nParserExpectedExternalClassName = 2051;
  nParserNoConstRangeAllowed = 2052;
  nErrRecordVariablesNotAllowed = 2053;
  nParserResourcestringsMustBeGlobal = 2054;
  nParserOnlyOneVariableCanBeAbsolute = 2055;
  nParserXNotAllowedInY = 2056;
  nFileSystemsNotSupported = 2057;
  nInvalidMessageType = 2058;

// resourcestring patterns of messages
resourcestring
  SErrNoSourceGiven = 'No source file specified';
  SErrMultipleSourceFiles = 'Please specify only one source file';
  SParserError = 'Error';
  SParserErrorAtToken = '%s at token "%s" in file %s at line %d column %d';
  SParserUngetTokenError = 'Internal error: Cannot unget more tokens, history buffer is full';
  SParserExpectTokenError = 'Expected "%s"';
  SParserForwardNotInterface = 'The use of a FORWARD procedure modifier is not allowed in the interface';
  SParserExpectVisibility = 'Expected visibility specifier';
  SParserStrangeVisibility = 'Strange strict visibility encountered : "%s"';
  SParserExpectToken2Error = 'Expected "%s" or "%s"';
  SParserExpectedCommaRBracket = 'Expected "," or ")"';
  SParserExpectedCommaSemicolon = 'Expected "," or ";"';
  SParserExpectedAssignIn = 'Expected := or in';
  SParserExpectedCommaColon = 'Expected "," or ":"';
  SErrUnknownOperatorType = 'Unknown operator type: %s';
  SParserOnlyOneArgumentCanHaveDefault = 'A default value can only be assigned to 1 parameter';
  SParserExpectedLBracketColon = 'Expected "(" or ":"';
  SParserExpectedSemiColonEnd = 'Expected ";" or "End"';
  SParserExpectedConstVarID = 'Expected "const", "var" or identifier';
  SParserExpectedNested = 'Expected nested keyword';
  SParserExpectedColonID = 'Expected ":" or identifier';
  SParserSyntaxError = 'Syntax error';
  SParserTypeSyntaxError = 'Syntax error in type';
  SParserArrayTypeSyntaxError = 'Syntax error in array type';
  SParserExpectedIdentifier = 'Identifier expected';
  SParserNotAProcToken = 'Not a procedure or function token';
  SRangeExpressionExpected = 'Range expression expected';
  SParserExpectCase = 'Case label expression expected';
  SParserGenericFunctionNeedsGenericKeyword = 'Generic function needs keyword generic';
  SLogStartImplementation = 'Start parsing implementation section.';
  SLogStartInterface = 'Start parsing interface section';
  SParserNoConstructorAllowed = 'Constructors or Destructors are not allowed in Interfaces or Records';
  SParserNoFieldsAllowedInX = 'Fields are not allowed in %s';
  SParserInvalidRecordVisibility = 'Records can only have public and (strict) private as visibility specifiers';
  SErrRecordConstantsNotAllowed = 'Record constants not allowed at this location';
  SErrRecordVariablesNotAllowed = 'Record variables not allowed at this location';
  SErrRecordMethodsNotAllowed = 'Record methods not allowed at this location';
  SErrRecordPropertiesNotAllowed = 'Record properties not allowed at this location';
  SErrRecordTypesNotAllowed = 'Record types not allowed at this location';
  SParserTypeNotAllowedHere = 'Type "%s" not allowed here';
  SParserNotAnOperand = 'Not an operand: (%d : %s)';
  SParserArrayPropertiesCannotHaveDefaultValue = 'Array properties cannot have default value';
  SParserDefaultPropertyMustBeArray = 'The default property must be an array property';
  SParserUnknownProcedureType = 'Unknown procedure type "%d"';
  SParserGenericArray1Element = 'Generic arrays can have only 1 template element';
  SParserTypeParamsNotAllowedOnType = 'Type parameters not allowed on this type';
  SParserDuplicateIdentifier = 'Duplicate identifier "%s"';
  SParserDefaultParameterRequiredFor = 'Default parameter required for "%s"';
  SParserOnlyOneVariableCanBeInitialized = 'Only one variable can be initialized';
  SParserExpectedTypeButGot = 'Expected type, but got %s';
  SParserPropertyArgumentsCanNotHaveDefaultValues = 'Property arguments can not have default values';
  SParserExpectedExternalClassName = 'Expected external class name';
  SParserNoConstRangeAllowed = 'Const ranges are not allowed';
  SParserResourcestringsMustBeGlobal = 'Resourcestrings can be only static or global';
  SParserOnlyOneVariableCanBeAbsolute = 'Only one variable can be absolute';
  SParserXNotAllowedInY = '%s is not allowed in %s';
  SErrFileSystemNotSupported = 'No support for filesystems enabled';
  SErrInvalidMessageType = 'Invalid message type: string or integer expression expected';

type
  TCShScopeType = (
    stModule,  // e.g. unit, program, library
    stUsesClause,
    stTypeSection,
    stTypeDef, // e.g. a TCShType
    stResourceString, // e.g. TCShResString
    stProcedure, // also method, procedure, constructor, destructor, ...
    stProcedureHeader,
    stWithExpr, // calls BeginScope after parsing every WITH-expression
    stExceptOnExpr,
    stExceptOnStatement,
    stForLoopHeader,
    stDeclaration, // e.g. a TCShProperty, TCShVariable, TCShArgument, ...
    stAncestors, // the list of ancestors and interfaces of a class
    stInitialFinalization
    );
  TCShScopeTypes = set of TCShScopeType;

  TCShParserLogHandler = Procedure (Sender : TObject; Const Msg : String) of object;
  TCShParserLogEvent = (cleImplementation);
  TCShParserLogEvents = set of TCShParserLogEvent;
  TCShParser = Class;

  { TCShTreeContainer }

  TCShTreeContainer = class
  private
    FCurrentParser: TCShParser;
    FNeedComments: Boolean;
    FOnLog: TCShParserLogHandler;
    FPParserLogEvents: TCShParserLogEvents;
    FScannerLogEvents: TCShScannerLogEvents;
  protected
    FPackage: TCShPackage;
    FInterfaceOnly : Boolean;
    procedure SetCurrentParser(AValue: TCShParser); virtual;
  public
    function CreateElement(AClass: TCShTreeElement; const AName: String;
      AParent: TCShElement; const ASourceFilename: String;
      ASourceLinenumber: Integer): TCShElement;overload;
    function CreateElement(AClass: TCShTreeElement; const AName: String;
      AParent: TCShElement; AVisibility: TCShMemberVisibility;
      const ASourceFilename: String; ASourceLinenumber: Integer): TCShElement;overload;
      virtual; abstract;
    function CreateElement(AClass: TCShTreeElement; const AName: String;
      AParent: TCShElement; AVisibility: TCShMemberVisibility;
      const ASrcPos: TCShSourcePos; TypeParams: TFPList = nil): TCShElement; overload;
      virtual;
    function CreateFunctionType(const AName, AResultName: String; AParent: TCShElement;
      UseParentAsResultParent: Boolean; const ASrcPos: TCShSourcePos; TypeParams: TFPList = nil): TCShFunctionType;
    function FindElement(const AName: String): TCShElement; virtual; abstract;
    function FindElementFor(const AName: String; AParent: TCShElement; TypeParamCount: integer): TCShElement; virtual;
    procedure BeginScope(ScopeType: TCShScopeType; El: TCShElement); virtual;
    procedure FinishScope(ScopeType: TCShScopeType; El: TCShElement); virtual;
    procedure FinishTypeAlias(var aType: TCShType); virtual;
    function FindModule(const AName: String): TCShModule; virtual;
    function FindModule(const AName: String; NameExpr, InFileExpr: TCShExpr): TCShModule; virtual;
    function CheckPendingUsedInterface(Section: TCShSection): boolean; virtual; // true if changed
    function NeedArrayValues(El: TCShElement): boolean; virtual;
    function GetDefaultClassVisibility(AClass: TCShClassType): TCShMemberVisibility; virtual;
    procedure ModeChanged(Sender: TObject; NewMode: TModeSwitch;
      Before: boolean; var Handled: boolean); virtual;
    property Package: TCShPackage read FPackage;
    property InterfaceOnly : Boolean Read FInterfaceOnly Write FInterFaceOnly;
    property ScannerLogEvents : TCShScannerLogEvents Read FScannerLogEvents Write FScannerLogEvents;
    property ParserLogEvents : TCShParserLogEvents Read FPParserLogEvents Write FPParserLogEvents;
    property OnLog : TCShParserLogHandler Read FOnLog Write FOnLog;
    property CurrentParser : TCShParser Read FCurrentParser Write SetCurrentParser;
    property NeedComments : Boolean Read FNeedComments Write FNeedComments;
  end;

  EParserError = class(Exception)
  private
    FFilename: String;
    FRow, FColumn: Integer;
  public
    constructor Create(const AReason, AFilename: String;
      ARow, AColumn: Integer); reintroduce;
    property Filename: String read FFilename;
    property Row: Integer read FRow;
    property Column: Integer read FColumn;
  end;

  TExprKind = (ek_Normal, ek_PropertyIndex);
  TIndentAction = (iaNone,iaIndent,iaUndent);

  { TCShParser }

  TCShParser = class
  private
    const FTokenRingSize = 32;
    type
      TTokenRec = record
        Token: TToken;
        AsString: String;
        Comments: TStrings;
        SourcePos: TCShSourcePos;
        TokenPos: TCShSourcePos;
      end;
      PTokenRec = ^TTokenRec;
  private
    FCurModule: TCShModule;
    FFileResolver: TBaseFileResolver;
    FImplicitUses: TStrings;
    FLastMsg: string;
    FLastMsgArgs: TMessageArgs;
    FLastMsgNumber: integer;
    FLastMsgPattern: string;
    FLastMsgType: TMessageType;
    FLogEvents: TCShParserLogEvents;
    FOnLog: TCShParserLogHandler;
    FOptions: TCShOptions;
    FScanner: TCSharpScanner;
    FEngine: TCShTreeContainer;
    FCurToken: TToken;
    FCurTokenString: String;
    FSavedComments : String;
    // UngetToken support:
    FTokenRing: array[0..FTokenRingSize-1] of TTokenRec;
    FTokenRingCur: Integer; // index of current token in FTokenBuffer
    FTokenRingStart: Integer; // first valid ring index in FTokenBuffer, if FTokenRingStart=FTokenRingEnd the ring is empty
    FTokenRingEnd: Integer; // first invalid ring index in FTokenBuffer
    {$ifdef VerboseCShParser}
    FDumpIndent : String;
    procedure DumpCurToken(Const Msg : String; IndentAction : TIndentAction = iaNone);
    {$endif}
    function CheckOverloadList(AList: TFPList; AName: String; out OldMember: TCShElement): TCShOverloadedProc;
    function DoCheckHint(Element: TCShElement): Boolean;
    function GetCurrentModeSwitches: TModeSwitches;
    Procedure SetCurrentModeSwitches(AValue: TModeSwitches);
    function GetVariableModifiers(Parent: TCShElement;
      Out VarMods: TVariableModifiers; Out LibName, ExportName: TCShExpr;
      const AllowedMods: TVariableModifiers): string;
    procedure HandleProcedureModifier(Parent: TCShElement; pm : TProcedureModifier);
    procedure HandleProcedureTypeModifier(ProcType: TCShProcedureType; ptm : TProcTypeModifier);
    procedure ParseMembersLocalConsts(AType: TCShMembersType; AVisibility: TCShMemberVisibility);
    procedure ParseMembersLocalTypes(AType: TCShMembersType; AVisibility: TCShMemberVisibility);
    procedure ParseVarList(Parent: TCShElement; VarList: TFPList; AVisibility: TCShMemberVisibility; Full: Boolean);
    procedure SetOptions(AValue: TCShOptions);
    procedure OnScannerModeChanged(Sender: TObject; NewMode: TModeSwitch;
      Before: boolean; var Handled: boolean);
  protected
    Function SaveComments : String;
    Function SaveComments(Const AValue : String) : String;
    function LogEvent(E : TCShParserLogEvent) : Boolean; inline;
    Procedure DoLog(MsgType: TMessageType; MsgNumber: integer; Const Msg : String; SkipSourceInfo : Boolean = False);overload;
    Procedure DoLog(MsgType: TMessageType; MsgNumber: integer; Const Fmt : String; Args : Array of {$ifdef pas2js}jsvalue{$else}const{$endif};SkipSourceInfo : Boolean = False);overload;
    function GetProcTypeFromToken(tk: TToken; IsClass: Boolean=False ): TProcType;
    procedure ParseRecordMembers(ARec: TCShRecordType; AEndToken: TToken; AllowMethods : Boolean);
    procedure ParseRecordVariantParts(ARec: TCShRecordType; AEndToken: TToken);
    function GetProcedureClass(ProcType : TProcType): TCShTreeElement;
    procedure ParseClassFields(AType: TCShClassType; const AVisibility: TCShMemberVisibility; IsClassField : Boolean);
    procedure ParseClassMembers(AType: TCShClassType);
    procedure ProcessMethod(AType: TCShClassType; IsClass : Boolean; AVisibility : TCShMemberVisibility; MustBeGeneric: boolean);
    procedure ReadGenericArguments(List: TFPList; Parent: TCShElement);
    procedure ReadSpecializeArguments(Parent: TCShElement; Params: TFPList);
    function ReadDottedIdentifier(Parent: TCShElement; out Expr: TCShExpr; NeedAsString: boolean): String;
    function CheckProcedureArgs(Parent: TCShElement;
      Args: TFPList; // list of TCShArgument
      ProcType: TProcType): boolean;
    function CheckVisibility(S: String; var AVisibility: TCShMemberVisibility): Boolean;
    procedure ParseExc(MsgNumber: integer; const Msg: String);
    procedure ParseExc(MsgNumber: integer; const Fmt: String; Args : Array of {$ifdef pas2js}jsvalue{$else}const{$endif});
    procedure ParseExcExpectedIdentifier;
    procedure ParseExcSyntaxError;
    procedure ParseExcTokenError(const Arg: string);
    procedure ParseExcTypeParamsNotAllowed;
    procedure ParseExcExpectedAorB(const A, B: string);
    function OpLevel(t: TToken): Integer;
    Function TokenToExprOp (AToken : TToken) : TExprOpCode;
    function CreateElement(AClass: TCShTreeElement; const AName: String; AParent: TCShElement): TCShElement;overload;
    function CreateElement(AClass: TCShTreeElement; const AName: String; AParent: TCShElement; const ASrcPos: TCShSourcePos): TCShElement;overload;
    function CreateElement(AClass: TCShTreeElement; const AName: String; AParent: TCShElement; AVisibility: TCShMemberVisibility): TCShElement;overload;
    function CreateElement(AClass: TCShTreeElement; const AName: String; AParent: TCShElement; AVisibility: TCShMemberVisibility; const ASrcPos: TCShSourcePos; TypeParams: TFPList = nil): TCShElement;overload;
    function CreatePrimitiveExpr(AParent: TCShElement; AKind: TCShExprKind; const AValue: String): TPrimitiveExpr;
    function CreateBoolConstExpr(AParent: TCShElement; AKind: TCShExprKind; const ABoolValue : Boolean): TBoolConstExpr;
    function CreateBinaryExpr(AParent : TCShElement; xleft, xright: TCShExpr; AOpCode: TExprOpCode): TBinaryExpr; overload;
    function CreateBinaryExpr(AParent : TCShElement; xleft, xright: TCShExpr; AOpCode: TExprOpCode; const ASrcPos: TCShSourcePos): TBinaryExpr; overload;
    procedure AddToBinaryExprChain(var ChainFirst: TCShExpr;
      Element: TCShExpr; AOpCode: TExprOpCode; const ASrcPos: TCShSourcePos);
    {$IFDEF VerboseCShParser}
    procedure WriteBinaryExprChain(Prefix: string; First, Last: TCShExpr);
    {$ENDIF}
    function CreateUnaryExpr(AParent : TCShElement; AOperand: TCShExpr; AOpCode: TExprOpCode): TUnaryExpr; overload;
    function CreateUnaryExpr(AParent : TCShElement; AOperand: TCShExpr; AOpCode: TExprOpCode; const ASrcPos: TCShSourcePos): TUnaryExpr; overload;
    function CreateArrayValues(AParent : TCShElement): TArrayValues;
    function CreateFunctionType(const AName, AResultName: String; AParent: TCShElement;
             UseParentAsResultParent: Boolean; const NamePos: TCShSourcePos; TypeParams: TFPList = nil): TCShFunctionType;
    function CreateInheritedExpr(AParent : TCShElement): TInheritedExpr;
    function CreateSelfExpr(AParent : TCShElement): TThisExpr;
    function CreateNilExpr(AParent : TCShElement): TNullExpr;
    function CreateRecordValues(AParent : TCShElement): TRecordValues;
    Function IsCurTokenHint(out AHint : TCShMemberHint) : Boolean; overload;
    Function IsCurTokenHint: Boolean; overload;
    Function TokenIsCallingConvention(const S: String; out CC : TCallingConvention) : Boolean; virtual;
    Function TokenIsProcedureModifier(Parent: TCShElement; const S: String; Out PM : TProcedureModifier): Boolean; virtual;
    Function TokenIsAnonymousProcedureModifier(Parent: TCShElement; S: String; Out PM: TProcedureModifier): Boolean; virtual;
    Function TokenIsProcedureTypeModifier(Parent : TCShElement; const S : String; Out PTM : TProcTypeModifier) : Boolean; virtual;
    Function CheckHint(Element : TCShElement; ExpectSemiColon : Boolean) : TCShMemberHints;
    function IsAnonymousProcAllowed(El: TCShElement): boolean; virtual;
    function ParseParams(AParent : TCShElement; ParamsKind: TCShExprKind; AllowFormatting : Boolean = False): TParamsExpr;
    function ParseExprOperand(AParent : TCShElement): TCShExpr;
    function ParseExpIdent(AParent : TCShElement): TCShExpr; deprecated 'use ParseExprOperand instead'; // since fpc 3.3.1
    procedure DoParseClassType(AType: TCShClassType);
    Function DoParseClassExternalHeader(AObjKind: TCShObjKind;
      out AExternalNameSpace, AExternalName: string) : Boolean;
    procedure DoParseArrayType(ArrType: TCShArrayType);
    function DoParseExpression(AParent: TCShElement;InitExpr: TCShExpr=nil; AllowEqual : Boolean = True): TCShExpr;
    function DoParseConstValueExpression(AParent: TCShElement): TCShExpr;
    function CheckPackMode: TPackMode;
    function AddUseUnit(ASection: TCShSection; const NamePos: TCShSourcePos;
      AUnitName : string; NameExpr: TCShExpr; InFileExpr: TPrimitiveExpr): TCShUsingNamespace;
    procedure CheckImplicitUsedUnits(ASection: TCShSection);
    procedure FinishedModule; virtual;
    // Overload handling
    procedure AddProcOrFunction(Decs: TCShDeclarations; AProc: TCShProcedure);
    function  CheckIfOverloaded(AParent: TCShElement; const AName: String): TCShElement;
  public
    constructor Create(AScanner: TCSharpScanner; AFileResolver: TBaseFileResolver;  AEngine: TCShTreeContainer);
    Destructor Destroy; override;
    procedure SetLastMsg(MsgType: TMessageType; MsgNumber: integer; Const Fmt : String; Args : Array of {$ifdef pas2js}jsvalue{$else}const{$endif});
    // General parsing routines
    function CurTokenName: String;
    function CurTokenText: String;
    Function CurComments : TStrings;
    function CurTokenPos: TCShSourcePos;
    function CurSourcePos: TCShSourcePos;
    function HasToken: boolean;
    Function SavedComments : String;
    procedure NextToken; // read next non whitespace, non space
    procedure ChangeToken(tk: TToken);
    procedure UngetToken;
    procedure CheckToken(tk: TToken);
    procedure CheckTokens(tk: TTokens);
    procedure ExpectToken(tk: TToken);
    procedure ExpectTokens(tk:  TTokens);
    function GetPrevToken: TToken;
    function ExpectIdentifier: String;
    Function CurTokenIsIdentifier(Const S : String) : Boolean;
    // Expression parsing
    function isEndOfExp(AllowEqual : Boolean = False; CheckHints : Boolean = True): Boolean;
    function ExprToText(Expr: TCShExpr): String;
    function ArrayExprToText(Expr: TCShExprArray): String;
    // Type declarations
    function ResolveTypeReference(Name: string; Parent: TCShElement; ParamCnt: integer = 0): TCShType;
    function ParseVarType(Parent : TCShElement = Nil): TCShType;
    function ParseTypeDecl(Parent: TCShElement): TCShType;
    function ParseGenericTypeDecl(Parent: TCShElement; AddToParent: boolean): TCShGenericType;
    function ParseType(Parent: TCShElement; const NamePos: TCShSourcePos; const TypeName: String = ''; Full: Boolean = false): TCShType;
    function ParseReferenceToProcedureType(Parent: TCShElement; Const NamePos: TCShSourcePos; Const TypeName: String): TCShProcedureType;
    function ParseProcedureType(Parent: TCShElement; Const NamePos: TCShSourcePos; Const TypeName: String; const PT: TProcType): TCShProcedureType;
    function ParseStringType(Parent: TCShElement; Const NamePos: TCShSourcePos; Const TypeName: String): TCShAliasType;
    function ParseSimpleType(Parent: TCShElement; Const NamePos: TCShSourcePos; Const TypeName: String; IsFull : Boolean = False): TCShType;
    function ParseAliasType(Parent: TCShElement; Const NamePos: TCShSourcePos; Const TypeName: String): TCShType;
    function ParseTypeReference(Parent: TCShElement; NeedExpr: boolean; out Expr: TCShExpr): TCShType;
    function ParseSpecializeType(Parent: TCShElement; Const NamePos: TCShSourcePos; const TypeName, GenName: string; var GenNameExpr: TCShExpr): TCShSpecializeType;
    function ParsePointerType(Parent: TCShElement; Const NamePos: TCShSourcePos; Const TypeName: String): TCShPointerType;
    Function ParseArrayType(Parent : TCShElement; Const NamePos: TCShSourcePos; Const TypeName : String; PackMode : TPackMode) : TCShArrayType;
    Function ParseRecordDecl(Parent: TCShElement; Const NamePos: TCShSourcePos; Const TypeName : string; const Packmode : TPackMode = pmNone) : TCShRecordType;
    function ParseEnumType(Parent: TCShElement; Const NamePos: TCShSourcePos; const TypeName: String): TCShEnumType;
    function ParseSetType(Parent: TCShElement; Const NamePos: TCShSourcePos; const TypeName: String; AIsPacked : Boolean = False): TCShSetType;
    Function ParseClassDecl(Parent: TCShElement; Const NamePos: TCShSourcePos; Const AClassName: String; AObjKind: TCShObjKind; PackMode : TPackMode= pmNone): TCShType;
    Function ParseProperty(Parent : TCShElement; Const AName : String; AVisibility : TCShMemberVisibility; IsClassField: boolean) : TCShProperty;
    function ParseRangeType(AParent: TCShElement; Const NamePos: TCShSourcePos; Const TypeName: String; Full: Boolean = True): TCShRangeType;
    procedure ParseExportDecl(Parent: TCShElement; List: TFPList);
    // Constant declarations
    function ParseConstDecl(Parent: TCShElement): TCShConst;
    function ParseResourcestringDecl(Parent: TCShElement): TCShResString;
    function ParseAttributes(Parent: TCShElement; Add: boolean): TCShAttributes;
    // Variable handling. This includes parts of records
    procedure ParseVarDecl(Parent: TCShElement; List: TFPList);
    procedure ParseInlineVarDecl(Parent: TCShElement; List: TFPList;  AVisibility : TCShMemberVisibility  = visDefault; ClosingBrace: Boolean = False);
    // Main scope parsing
    procedure ParseMain(var Module: TCShModule);
    procedure ParseUnit(var Module: TCShModule);
    function GetLastSection: TCShSection; virtual;
    function CanParseContinue(out Section: TCShSection): boolean; virtual;
    procedure ParseContinue; virtual;
    procedure ParseProgram(var Module: TCShModule; SkipHeader : Boolean = False);
    procedure ParseLibrary(var Module: TCShModule);
    procedure ParseOptionalUsesList(ASection: TCShSection);
    procedure ParseUsesList(ASection: TCShSection);
    procedure ParseImplementation;
    procedure ParseDeclarations(Declarations: TCShDeclarations);
    procedure ParseStatement(Parent: TCShImplBlock; out NewImplElement: TCShImplElement);
    procedure ParseAdhocExpression(out NewExprElement: TCShExpr);
    procedure ParseLabels(AParent: TCShElement);
    procedure ParseProcBeginBlock(Parent: TProcedureBody);
    // Function/Procedure declaration
    function ParseProcedureOrFunctionDecl(Parent: TCShElement;
      ProcType: TProcType; MustBeGeneric: boolean;
      AVisibility: TCShMemberVisibility = VisDefault): TCShProcedure;
    procedure ParseArgList(Parent: TCShElement;
      Args: TFPList; // list of TCShArgument
      EndToken: TToken);
    procedure ParseProcedureOrFunction(Parent: TCShElement; Element: TCShProcedureType; ProcType: TProcType; OfObjectPossible: Boolean);
    procedure ParseProcedureBody(Parent: TCShElement);
    function ParseMethodResolution(Parent: TCShElement): TCShMethodResolution;
    // Properties for external access
    property FileResolver: TBaseFileResolver read FFileResolver;
    property Scanner: TCSharpScanner read FScanner;
    property Engine: TCShTreeContainer read FEngine;
    property CurToken: TToken read FCurToken;
    property CurTokenString: String read FCurTokenString;
    property Options : TCShOptions Read FOptions Write SetOptions;
    property CurrentModeswitches : TModeSwitches Read GetCurrentModeSwitches Write SetCurrentModeSwitches;
    property CurModule : TCShModule Read FCurModule;
    property LogEvents : TCShParserLogEvents Read FLogEvents Write FLogEvents;
    property OnLog : TCShParserLogHandler Read FOnLog Write FOnLog;
    property ImplicitUses: TStrings read FImplicitUses;
    property LastMsg: string read FLastMsg write FLastMsg;
    property LastMsgNumber: integer read FLastMsgNumber write FLastMsgNumber;
    property LastMsgType: TMessageType read FLastMsgType write FLastMsgType;
    property LastMsgPattern: string read FLastMsgPattern write FLastMsgPattern;
    property LastMsgArgs: TMessageArgs read FLastMsgArgs write FLastMsgArgs;
  end;

Type
  TParseSourceOption = (
    {$ifdef HasStreams}
    poUseStreams,
    {$endif}
    poSkipDefaultDefs);
  TParseSourceOptions = set of TParseSourceOption;

Var
  DefaultFileResolverClass : TBaseFileResolverClass = Nil;

{$ifdef HasStreams}
function ParseSource(AEngine: TCShTreeContainer;
                     const FPCCommandLine, OSTarget, CPUTarget: String;
                     UseStreams  : Boolean): TCShModule; deprecated 'use version with options';
{$endif}
function ParseSource(AEngine: TCShTreeContainer;
                     const FPCCommandLine, OSTarget, CPUTarget: String): TCShModule; deprecated 'use version with split command line';
function ParseSource(AEngine: TCShTreeContainer;
                     const FPCCommandLine, OSTarget, CPUTarget: String;
                     Options : TParseSourceOptions): TCShModule; deprecated 'use version with split command line';
function ParseSource(AEngine: TCShTreeContainer;
                     const FPCCommandLine : Array of String;
                     OSTarget, CPUTarget: String;
                     Options : TParseSourceOptions): TCShModule;

Function IsHintToken(T : String; Out AHint : TCShMemberHint) : boolean;
Function IsProcModifier(S : String; Out PM : TProcedureModifier) : Boolean;
Function IsCallingConvention(S : String; out CC : TCallingConvention) : Boolean;
Function TokenToAssignKind( tk : TToken) : TAssignKind;

implementation

{$IF FPC_FULLVERSION>=30301}
uses strutils;
{$ENDIF}

const
  WhitespaceTokensToIgnore = [tkWhitespace, tkComment, tkLineEnding, tkTab];

type
  TDeclType = (declNone, declConst, declResourcestring, declType,
               declVar, declThreadvar, declProperty, declExports);

{$IF FPC_FULLVERSION<30301}
Function SplitCommandLine(S: String) : TStringDynArray;

  Function GetNextWord : String;

  Const
    WhiteSpace = [' ',#9,#10,#13];
    Literals = ['"',''''];

  Var
    Wstart,wend : Integer;
    InLiteral : Boolean;
    LastLiteral : Char;

    Procedure AppendToResult;

    begin
      Result:=Result+Copy(S,WStart,WEnd-WStart);
      WStart:=Wend+1;
    end;

  begin
    Result:='';
    WStart:=1;
    While (WStart<=Length(S)) and charinset(S[WStart],WhiteSpace) do
      Inc(WStart);
    WEnd:=WStart;
    InLiteral:=False;
    LastLiteral:=#0;
    While (Wend<=Length(S)) and (Not charinset(S[Wend],WhiteSpace) or InLiteral) do
      begin
      if charinset(S[Wend],Literals) then
        If InLiteral then
          begin
          InLiteral:=Not (S[Wend]=LastLiteral);
          if not InLiteral then
            AppendToResult;
          end
        else
          begin
          InLiteral:=True;
          LastLiteral:=S[Wend];
          AppendToResult;
          end;
       inc(wend);
       end;
     AppendToResult;
     While (WEnd<=Length(S)) and (S[Wend] in WhiteSpace) do
       inc(Wend);
     Delete(S,1,WEnd-1);
  end;

Var
  W : String;
  len : Integer;

begin
  Len:=0;
  Result:=Default(TStringDynArray);
  SetLength(Result,(Length(S) div 2)+1);
  While Length(S)>0 do
    begin
    W:=GetNextWord;
    If (W<>'') then
      begin
      Result[Len]:=W;
      Inc(Len);
      end;
    end;
  SetLength(Result,Len);
end;
{$ENDIF}

Function IsHintToken(T : String; Out AHint : TCShMemberHint) : boolean;

Const
   MemberHintTokens : Array[TCShMemberHint] of string =
     ('deprecated','library','platform','experimental','unimplemented');
Var
  I : TCShMemberHint;

begin
  t:=LowerCase(t);
  Result:=False;
  For I:=Low(TCShMemberHint) to High(TCShMemberHint) do
    begin
    result:=(t=MemberHintTokens[i]);
    if Result then
      begin
      aHint:=I;
      exit;
      end;
    end;
end;


Function IsCallingConvention(S : String; out CC : TCallingConvention) : Boolean;

Var
  CCNames : Array[TCallingConvention] of String
         = ('','register','pascal','cdecl','stdcall','oldfpccall','safecall','syscall',
           'mwpascal', 'hardfloat','sysv_abi_default','sysv_abi_cdecl',
           'ms_abi_default','ms_abi_cdecl','vectorcall');
Var
  C : TCallingConvention;

begin
  S:=Lowercase(s);
  Result:=False;
  for C:=Low(TCallingConvention) to High(TCallingConvention) do
    begin
    Result:=(CCNames[c]<>'') and (s=CCnames[c]);
    If Result then
      begin
      CC:=C;
      exit;
      end;
    end;
end;

Function IsProcModifier(S : String; Out PM : TProcedureModifier) : Boolean;

Var
  P : TProcedureModifier;

begin
  S:=LowerCase(S);
  Result:=False;
  For P:=Low(TProcedureModifier) to High(TProcedureModifier) do
    begin
    Result:=s=ModifierNames[P];
    If Result then
      begin
      PM:=P;
      exit;
      end;
    end;
end;

Function TokenToAssignKind( tk : TToken) : TAssignKind;

begin
  case tk of
    tkAssign         : Result:=akDefault;
    tkAssignPlus     : Result:=akAdd;
    tkAssignMinus    : Result:=akMinus;
    tkAssignMul      : Result:=akMul;
    tkAssignDivision : Result:=akDivision;
  else
    Raise Exception.CreateFmt('Not an assignment token : %s',[TokenInfos[tk]]);
  end;
end;

function ParseSource(AEngine: TCShTreeContainer;
  const FPCCommandLine, OSTarget, CPUTarget: String): TCShModule;
var
  FPCParams: TStringDynArray;
begin
  FPCParams:=SplitCommandLine(FPCCommandLine);
  Result:=ParseSource(AEngine, FPCParams, OSTarget, CPUTarget,[]);
end;

{$ifdef HasStreams}
function ParseSource(AEngine: TCShTreeContainer;
  const FPCCommandLine, OSTarget, CPUTarget: String; UseStreams : Boolean): TCShModule;
var
  FPCParams: TStringDynArray;
begin
  FPCParams:=SplitCommandLine(FPCCommandLine);
  if UseStreams then
    Result:=ParseSource(AEngine,FPCParams, OSTarget, CPUTarget,[poUseStreams])
  else
    Result:=ParseSource(AEngine,FPCParams, OSTarget, CPUTarget,[]);
end;
{$endif}

function ParseSource(AEngine: TCShTreeContainer;
  const FPCCommandLine, OSTarget, CPUTarget: String;
  Options : TParseSourceOptions): TCShModule;

Var
  Args : TStringArray;

begin
  Args:=SplitCommandLine(FPCCommandLine);
  Result:=ParseSource(aEngine,Args,OSTarget,CPUTarget,Options);

end;

function ParseSource(AEngine: TCShTreeContainer;
                     const FPCCommandLine : Array of String;
                     OSTarget, CPUTarget: String;
                     Options : TParseSourceOptions): TCShModule;

var
  FileResolver: TBaseFileResolver;
  Parser: TCShParser;
  Filename: String;
  Scanner: TCSharpScanner;

  procedure ProcessCmdLinePart(S : String);
  var
    l,Len: Integer;

  begin
    if (S='') then
      exit;
    Len:=Length(S);
    if (s[1] = '-') and (len>1) then
    begin
      case s[2] of
        'd': // -d define
          Scanner.AddDefine(UpperCase(Copy(s, 3, Len)));
        'u': // -u undefine
          Scanner.RemoveDefine(UpperCase(Copy(s, 3, Len)));
        'F': // -F
          if (len>2) and (s[3] = 'i') then // -Fi include path
            FileResolver.AddIncludePath(Copy(s, 4, Len));
        'I': // -I include path
          FileResolver.AddIncludePath(Copy(s, 3, Len));
        'S': // -S mode
          if  (len>2) then
            begin
            l:=3;
            While L<=Len do
              begin
              case S[l] of
                'c' : Scanner.Options:=Scanner.Options+[po_cassignments];
                'd' : Scanner.SetCompilerMode('DELPHI');
                '2' : Scanner.SetCompilerMode('OBJFPC');
                'h' : ; // do nothing
              end;
              inc(l);
              end;
            end;
        'M' :
           begin
           delete(S,1,2);
           Scanner.SetCompilerMode(S);
           end;
      end;
    end else
      if Filename <> '' then
        raise ENotSupportedException.Create(SErrMultipleSourceFiles)
      else
        Filename := s;
  end;

var
  S: String;

begin
  if DefaultFileResolverClass=Nil then
    raise ENotImplemented.Create(SErrFileSystemNotSupported);
  Result := nil;
  FileResolver := nil;
  Scanner := nil;
  Parser := nil;
  try
    FileResolver := DefaultFileResolverClass.Create;
    {$ifdef HasStreams}
    if FileResolver is TFileResolver then
      TFileResolver(FileResolver).UseStreams:=poUseStreams in Options;
    {$endif}
    Scanner := TCSharpScanner.Create(FileResolver);
    Scanner.LogEvents:=AEngine.ScannerLogEvents;
    Scanner.OnLog:=AEngine.Onlog;
    if not (poSkipDefaultDefs in Options) then
      begin
      Scanner.AddDefine('FPK');
      Scanner.AddDefine('FPC');
      // TargetOS
      s := UpperCase(OSTarget);
      Scanner.AddDefine(s);
      Case s of
        'LINUX' : Scanner.AddDefine('UNIX');
        'FREEBSD' :
          begin
          Scanner.AddDefine('BSD');
          Scanner.AddDefine('UNIX');
          end;
        'NETBSD' :
          begin
          Scanner.AddDefine('BSD');
          Scanner.AddDefine('UNIX');
          end;
        'SUNOS' :
          begin
          Scanner.AddDefine('SOLARIS');
          Scanner.AddDefine('UNIX');
          end;
        'GO32V2' : Scanner.AddDefine('DPMI');
        'BEOS' : Scanner.AddDefine('UNIX');
        'QNX' : Scanner.AddDefine('UNIX');
        'AROS' : Scanner.AddDefine('HASAMIGA');
        'MORPHOS' : Scanner.AddDefine('HASAMIGA');
        'AMIGA' : Scanner.AddDefine('HASAMIGA');
      end;
      // TargetCPU
      s := UpperCase(CPUTarget);
      Scanner.AddDefine('CPU'+s);
      if (s='X86_64') then
        Scanner.AddDefine('CPU64')
      else
        Scanner.AddDefine('CPU32');
      end;
    Parser := TCShParser.Create(Scanner, FileResolver, AEngine);
    if (poSkipDefaultDefs in Options) then
      Parser.ImplicitUses.Clear;
    Filename := '';
    Parser.LogEvents:=AEngine.ParserLogEvents;
    Parser.OnLog:=AEngine.Onlog;

    For S in FPCCommandLine do
      ProcessCmdLinePart(S);
    if Filename = '' then
      raise Exception.Create(SErrNoSourceGiven);
{$IFDEF HASFS}
    FileResolver.AddIncludePath(ExtractFilePath(FileName));
{$ENDIF}
    Scanner.OpenFile(Filename);
    Parser.ParseMain(Result);
  finally
    Parser.Free;
    Scanner.Free;
    FileResolver.Free;
  end;
end;

{ ---------------------------------------------------------------------
  TCShTreeContainer
  ---------------------------------------------------------------------}

procedure TCShTreeContainer.SetCurrentParser(AValue: TCShParser);
begin
  if FCurrentParser=AValue then Exit;
  FCurrentParser:=AValue;
end;

function TCShTreeContainer.CreateElement(AClass: TCShTreeElement;
  const AName: String; AParent: TCShElement; const ASourceFilename: String;
  ASourceLinenumber: Integer): TCShElement;
begin
  Result := CreateElement(AClass, AName, AParent, visDefault, ASourceFilename,
    ASourceLinenumber);
end;

function TCShTreeContainer.CreateElement(AClass: TCShTreeElement;
  const AName: String; AParent: TCShElement; AVisibility: TCShMemberVisibility;
  const ASrcPos: TCShSourcePos; TypeParams: TFPList): TCShElement;
begin
  Result := CreateElement(AClass, AName, AParent, AVisibility, ASrcPos.FileName,
    ASrcPos.Row);
  if TypeParams=nil then ;
end;

function TCShTreeContainer.CreateFunctionType(const AName, AResultName: String;
  AParent: TCShElement; UseParentAsResultParent: Boolean;
  const ASrcPos: TCShSourcePos; TypeParams: TFPList): TCShFunctionType;
var
  ResultParent: TCShElement;
begin
  Result := TCShFunctionType(CreateElement(TCShFunctionType, AName, AParent,
    visDefault, ASrcPos, TypeParams));

  if UseParentAsResultParent then
    ResultParent := AParent
  else
    ResultParent := Result;

  TCShFunctionType(Result).ResultEl :=
    TCShResultElement(CreateElement(TCShResultElement, AResultName, ResultParent,
    visDefault, ASrcPos, TypeParams));
end;

function TCShTreeContainer.FindElementFor(const AName: String;
  AParent: TCShElement; TypeParamCount: integer): TCShElement;
begin
  Result:=FindElement(AName);
  if AParent=nil then ;
  if TypeParamCount=0 then ;
end;

procedure TCShTreeContainer.BeginScope(ScopeType: TCShScopeType; El: TCShElement
  );
begin
  if ScopeType=stModule then ; // avoid compiler warning
  if El=nil then ;
end;

procedure TCShTreeContainer.FinishScope(ScopeType: TCShScopeType;
  El: TCShElement);
begin
  if ScopeType=stModule then ; // avoid compiler warning
  if Assigned(El) and (CurrentParser<>nil) then
    El.SourceEndLinenumber := CurrentParser.CurSourcePos.Row;
end;

procedure TCShTreeContainer.FinishTypeAlias(var aType: TCShType);
begin
  if aType=nil then ;
end;

function TCShTreeContainer.FindModule(const AName: String): TCShModule;
begin
  if AName='' then ;  // avoid compiler warning
  Result := nil;
end;

function TCShTreeContainer.FindModule(const AName: String; NameExpr,
  InFileExpr: TCShExpr): TCShModule;
begin
  Result:=FindModule(AName);
  if NameExpr=nil then ;
  if InFileExpr=nil then ;
end;

function TCShTreeContainer.CheckPendingUsedInterface(Section: TCShSection
  ): boolean;
begin
  if Section=nil then ;  // avoid compiler warning
  Result:=false;
end;

function TCShTreeContainer.NeedArrayValues(El: TCShElement): boolean;
begin
  Result:=false;
  if El=nil then ;  // avoid compiler warning
end;

function TCShTreeContainer.GetDefaultClassVisibility(AClass: TCShClassType
  ): TCShMemberVisibility;
begin
  Result:=visDefault; 
  if AClass=nil then ;  // avoid compiler warning
end;

procedure TCShTreeContainer.ModeChanged(Sender: TObject; NewMode: TModeSwitch;
  Before: boolean; var Handled: boolean);
begin
  if Sender=nil then ;
  if NewMode=msNone then ;
  if Before then ;
  if Handled then ;
end;

{ ---------------------------------------------------------------------
  EParserError
  ---------------------------------------------------------------------}

constructor EParserError.Create(const AReason, AFilename: String;
  ARow, AColumn: Integer);
begin
  inherited Create(AReason);
  FFilename := AFilename;
  FRow := ARow;
  FColumn := AColumn;
end;

{ ---------------------------------------------------------------------
  TCShParser
  ---------------------------------------------------------------------}

procedure TCShParser.ParseExc(MsgNumber: integer; const Msg: String);
begin
  ParseExc(MsgNumber,Msg,[]);
end;

procedure TCShParser.ParseExc(MsgNumber: integer; const Fmt: String;
  Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif});
var
  p: TCShSourcePos;
begin
  {$IFDEF VerboseCShParser}
  writeln('TCShParser.ParseExc Token="',CurTokenText,'"');
  //writeln('TCShParser.ParseExc ',Scanner.CurColumn,' ',Scanner.CurSourcePos.Column,' ',Scanner.CurTokenPos.Column,' ',Scanner.CurSourceFile.Filename);
  {$ENDIF}
  SetLastMsg(mtError,MsgNumber,Fmt,Args);
  p:=Scanner.CurTokenPos;
  if p.FileName='' then
    p:=Scanner.CurSourcePos;
  if p.Row=0 then
    begin
    p.Row:=1;
    p.Column:=1;
    end;
  raise EParserError.Create(SafeFormat(SParserErrorAtToken,
    [FLastMsg, CurTokenName, p.FileName, p.Row, p.Column])
    {$ifdef addlocation}+' ('+IntToStr(p.Row)+' '+IntToStr(p.Column)+')'{$endif},
    p.FileName, p.Row, p.Column);
end;

procedure TCShParser.ParseExcExpectedIdentifier;
begin
  ParseExc(nParserExpectedIdentifier,SParserExpectedIdentifier);
end;

procedure TCShParser.ParseExcSyntaxError;
begin
  ParseExc(nParserSyntaxError,SParserSyntaxError);
end;

procedure TCShParser.ParseExcTokenError(const Arg: string);
begin
  ParseExc(nParserExpectTokenError,SParserExpectTokenError,[Arg]);
end;

procedure TCShParser.ParseExcTypeParamsNotAllowed;
begin
  ParseExc(nParserTypeParamsNotAllowedOnType,sParserTypeParamsNotAllowedOnType,[]);
end;

procedure TCShParser.ParseExcExpectedAorB(const A, B: string);
begin
  ParseExc(nParserExpectToken2Error,SParserExpectToken2Error,[A,B]);
end;

constructor TCShParser.Create(AScanner: TCSharpScanner;
  AFileResolver: TBaseFileResolver; AEngine: TCShTreeContainer);
begin
  inherited Create;
  FScanner := AScanner;
  if FScanner.OnModeChanged=nil then
    FScanner.OnModeChanged:=@OnScannerModeChanged;
  FFileResolver := AFileResolver;
  FTokenRingCur:=High(FTokenRing);
  FEngine := AEngine;
  if Assigned(FEngine) then
    begin
    FEngine.CurrentParser:=Self;
    If FEngine.NeedComments then
      FScanner.SkipComments:=Not FEngine.NeedComments;
    end;
  FImplicitUses := TStringList.Create;
  FImplicitUses.Add('System'); // system always implicitely first.
end;

destructor TCShParser.Destroy;
var
  i: Integer;
begin
  if FScanner.OnModeChanged=@OnScannerModeChanged then
    FScanner.OnModeChanged:=nil;
  if Assigned(FEngine) then
    begin
    FEngine.CurrentParser:=Nil;
    FEngine:=nil;
    end;
  FreeAndNil(FImplicitUses);
  for i:=low(FTokenRing) to high(FTokenRing) do
    FreeAndNil(FTokenRing[i].Comments);
  inherited Destroy;
end;

function TCShParser.CurTokenName: String;
begin
  if CurToken = tkIdentifier then
    Result := 'Identifier ' + FCurTokenString
  else
    Result := TokenInfos[CurToken];
end;

function TCShParser.CurTokenText: String;
begin
  case CurToken of
    tkIdentifier, tkString, tkNumber, tkChar:
      Result := FCurTokenString;
    else
      Result := TokenInfos[CurToken];
  end;
end;

function TCShParser.CurComments: TStrings;
begin
  if FTokenRingStart=FTokenRingEnd then
    Result:=nil
  else
    Result:=FTokenRing[FTokenRingCur].Comments;
end;

function TCShParser.CurTokenPos: TCShSourcePos;
begin
  if HasToken then
    Result:=FTokenRing[FTokenRingCur].TokenPos
  else if Scanner<>nil then
    Result:=Scanner.CurTokenPos
  else
    Result:=Default(TCShSourcePos);
end;

function TCShParser.CurSourcePos: TCShSourcePos;
begin
  if HasToken then
    Result:=FTokenRing[FTokenRingCur].SourcePos
  else if Scanner<>nil then
    Result:=Scanner.CurSourcePos
  else
    Result:=Default(TCShSourcePos);
end;

function TCShParser.HasToken: boolean;
begin
  if FTokenRingStart<FTokenRingEnd then
    Result:=(FTokenRingCur>=FTokenRingStart) and (FTokenRingCur<FTokenRingEnd)
  else
    Result:=(FTokenRingCur>=FTokenRingStart) or (FTokenRingCur<FTokenRingEnd);
end;

function TCShParser.SavedComments: String;
begin
  Result:=FSavedComments;
end;

procedure TCShParser.NextToken;

Var
  P: PTokenRec;
begin
  FTokenRingCur:=(FTokenRingCur+1) mod FTokenRingSize;
  P:=@FTokenRing[FTokenRingCur];
  if FTokenRingCur <> FTokenRingEnd then
    begin
    // Get token from buffer
    //writeln('TCShParser.NextToken REUSE Start=',FTokenRingStart,' Cur=',FTokenRingCur,' End=',FTokenRingEnd,' Cur=',CurTokenString);
    FCurToken := Scanner.CheckToken(P^.Token,P^.AsString);
    FCurTokenString := P^.AsString;
    end
  else
    begin
    // Fetch new token
    //writeln('TCShParser.NextToken FETCH Start=',FTokenRingStart,' Cur=',FTokenRingCur,' End=',FTokenRingEnd,' Cur=',CurTokenString);
    FTokenRingEnd:=(FTokenRingEnd+1) mod FTokenRingSize;
    if FTokenRingStart=FTokenRingEnd then
      FTokenRingStart:=(FTokenRingStart+1) mod FTokenRingSize;
    try
      if p^.Comments=nil then
        p^.Comments:=TStringList.Create
      else
        p^.Comments.Clear;
      repeat
        FCurToken := Scanner.FetchToken;
        if FCurToken=tkComment then
          p^.Comments.Add(Scanner.CurTokenString);
      until not (FCurToken in WhitespaceTokensToIgnore);
    except
      on e: EScannerError do
        begin
        if po_KeepScannerError in Options then
          raise
        else
          begin
          FLastMsgType := mtError;
          FLastMsgNumber := Scanner.LastMsgNumber;
          FLastMsgPattern := Scanner.LastMsgPattern;
          FLastMsg := Scanner.LastMsg;
          FLastMsgArgs := Scanner.LastMsgArgs;
          raise EParserError.Create(e.Message,
            Scanner.CurFilename, Scanner.CurRow, Scanner.CurColumn);
          end;
        end;
    end;
    p^.Token:=FCurToken;
    FCurTokenString := Scanner.CurTokenString;
    p^.AsString:=FCurTokenString;
    p^.SourcePos:=Scanner.CurSourcePos;
    p^.TokenPos:=Scanner.CurTokenPos;
    end;
  //writeln('TCShParser.NextToken END Start=',FTokenRingStart,' Cur=',FTokenRingCur,' End=',FTokenRingEnd,' Cur=',CurTokenString);
end;

procedure TCShParser.ChangeToken(tk: TToken);
var
  Cur, Last: PTokenRec;
  IsLast: Boolean;
begin
  //writeln('TCShParser.ChangeToken FTokenBufferSize=',FTokenRingStart,' FTokenBufferIndex=',FTokenRingCur);
  IsLast:=((FTokenRingCur+1) mod FTokenRingSize)=FTokenRingEnd;
  if (CurToken=tkshr) and (tk=tkGreaterThan) and IsLast then
    begin
    // change last token '>>' into two '>'
    Cur:=@FTokenRing[FTokenRingCur];
    Cur^.Token:=tkGreaterThan;
    Cur^.AsString:='>';
    Last:=@FTokenRing[FTokenRingEnd];
    Last^.Token:=tkGreaterThan;
    Last^.AsString:='>';
    if Last^.Comments<>nil then
      Last^.Comments.Clear;
    Last^.SourcePos:=Cur^.SourcePos;
    dec(Cur^.SourcePos.Column);
    Last^.TokenPos:=Cur^.TokenPos;
    inc(Last^.TokenPos.Column);
    FTokenRingEnd:=(FTokenRingEnd+1) mod FTokenRingSize;
    if FTokenRingStart=FTokenRingEnd then
      FTokenRingStart:=(FTokenRingStart+1) mod FTokenRingSize;
    FCurToken:=tkGreaterThan;
    FCurTokenString:='>';
    end
  else
    CheckToken(tk);
end;

procedure TCShParser.UngetToken;

var
  P: PTokenRec;
begin
  //writeln('TCShParser.UngetToken START Start=',FTokenRingStart,' Cur=',FTokenRingCur,' End=',FTokenRingEnd,' Cur=',CurTokenString);
  if FTokenRingStart = FTokenRingEnd then
    ParseExc(nParserUngetTokenError,SParserUngetTokenError);
  if FTokenRingCur>0 then
    dec(FTokenRingCur)
  else
    FTokenRingCur:=High(FTokenRing);
  P:=@FTokenRing[FTokenRingCur];
  FCurToken := P^.Token;
  FCurTokenString := P^.AsString;
  //writeln('TCShParser.UngetToken END Start=',FTokenRingStart,' Cur=',FTokenRingCur,' End=',FTokenRingEnd,' Cur=',CurTokenString);
end;

procedure TCShParser.CheckToken(tk: TToken);
begin
  if (CurToken<>tk) then
    begin
    {$IFDEF VerboseCShParser}
    writeln('TCShParser.ParseExcTokenError String="',CurTokenString,'" Text="',CurTokenText,'" CurToken=',CurToken,' tk=',tk);
    {$ENDIF}
    ParseExcTokenError(TokenInfos[tk]);
    end;
end;

procedure TCShParser.CheckTokens(tk: TTokens);

Var
  S : String;
  T : TToken;
begin
  if not (CurToken in tk) then
    begin
    {$IFDEF VerboseCShParser}
    writeln('TCShParser.ParseExcTokenError String="',CurTokenString,'" Text="',CurTokenText,'" CurToken=',CurToken);
    {$ENDIF}
    S:='';
    For T in TToken do
      if t in tk then
        begin
        if (S<>'') then
          S:=S+' or ';
        S:=S+TokenInfos[t];
        end;
    ParseExcTokenError(S);
    end;
end;


procedure TCShParser.ExpectToken(tk: TToken);
begin
  NextToken;
  CheckToken(tk);
end;

procedure TCShParser.ExpectTokens(tk: TTokens);
begin
  NextToken;
  CheckTokens(tk);
end;

function TCShParser.GetPrevToken: TToken;
var
  i: Integer;
  P: PTokenRec;
begin
  if FTokenRingStart = FTokenRingEnd then
    Result:=tkEOF;
  i:=FTokenRingCur;
  if i>0 then
    dec(i)
  else
    i:=High(FTokenRing);
  P:=@FTokenRing[i];
  Result := P^.Token;
end;

function TCShParser.ExpectIdentifier: String;
begin
  ExpectToken(tkIdentifier);
  Result := CurTokenString;
end;

function TCShParser.CurTokenIsIdentifier(const S: String): Boolean;
begin
  Result:=(Curtoken=tkIdentifier) and (CompareText(S,CurtokenText)=0);
end;

function TCShParser.IsCurTokenHint(out AHint: TCShMemberHint): Boolean;
begin
//Todo:  Result:=false {tkLIbrary};
  if Result then
    AHint:=hLibrary
  else if (CurToken=tkIdentifier) then
    Result:=IsHintToken(CurTokenString,ahint);
end;

function TCShParser.IsCurTokenHint: Boolean;
var
  dummy : TCShMemberHint;
begin
  Result:=IsCurTokenHint(dummy);
end;

function TCShParser.TokenIsCallingConvention(const S: String; out
  CC: TCallingConvention): Boolean;
begin
  Result:=IsCallingConvention(S,CC);
end;

function TCShParser.TokenIsProcedureModifier(Parent: TCShElement;
  const S: String; out PM: TProcedureModifier): Boolean;
begin
  Result:=IsProcModifier(S,PM);
  if not Result then exit;
  While (Parent<>Nil) do
    begin
    if Parent is TCShClassType then
      begin
      if PM in [pmPublic,pmForward] then exit(false);
      if TCShClassType(Parent).ObjKind in [okInterface,okDispInterface] then
        if not (PM in [pmOverload, pmMessage, pmDispId,pmNoReturn,pmFar,pmFinal]) then
          exit(false);
      exit;
      end
    else if Parent is TCShRecordType then
      begin
      if not (PM in [pmOverload,
                     pmInline, pmAssembler,
                     pmExternal,
                     pmNoReturn, pmFar, pmFinal]) then exit(false);
      exit;
      end;
    Parent:=Parent.Parent;
    end;
end;

function TCShParser.TokenIsAnonymousProcedureModifier(Parent: TCShElement;
  S: String; out PM: TProcedureModifier): Boolean;
begin
  Result:=IsProcModifier(S,PM);
  if not Result then exit;
  case PM of
  pmAssembler: Result:=true;
  else
    Result:=false;
  end;
  if Parent=nil then ;
end;

function TCShParser.TokenIsProcedureTypeModifier(Parent: TCShElement;
  const S: String; out PTM: TProcTypeModifier): Boolean;
begin
  if CompareText(S,ProcTypeModifiers[ptmVarargs])=0 then
    begin
    Result:=true;
    PTM:=ptmVarargs;
    end
  else if CompareText(S,ProcTypeModifiers[ptmStatic])=0 then
    begin
    Result:=true;
    PTM:=ptmStatic;
    end
  else if (CompareText(S,ProcTypeModifiers[ptmAsync])=0) and (po_AsyncProcs in Options) then
    begin
    Result:=true;
    PTM:=ptmAsync;
    end
  else
   Result:=false;
  if Parent=nil then;
end;

function TCShParser.CheckHint(Element: TCShElement; ExpectSemiColon: Boolean
  ): TCShMemberHints;

Var
  Found : Boolean;
  h : TCShMemberHint;

begin
  Result:=[];
  Repeat
    NextToken;
    Found:=IsCurTokenHint(h);
    If Found then
      begin
      Include(Result,h);
      if (h=hDeprecated) then
        begin
        NextToken;
        if (Curtoken<>tkString) then
          UnGetToken
        else if assigned(Element) then
          Element.HintMessage:=CurTokenString;
        end;
      end;
  Until Not Found;
  UngetToken;
  If Assigned(Element) then
    Element.Hints:=Result;
  if ExpectSemiColon then
    ExpectToken(tkSemiColon);
end;

function TCShParser.IsAnonymousProcAllowed(El: TCShElement): boolean;
begin
  while El is TCShExpr do
    El:=El.Parent;
  Result:=El is TCShImplBlock; // only in statements
end;

function TCShParser.CheckPackMode: TPackMode;

begin
  NextToken;
  result:=pmNone;
  if (Result<>pmNone) then
     begin
     NextToken;
     if Not (CurToken in [TToken.tkStruct, TToken.tkClass]) then
       ParseExcTokenError('SET, ARRAY, RECORD, OBJECT or CLASS');
     end;
end;

Function IsSimpleTypeToken(Var AName : String) : Boolean;

Const
   SimpleTypeCount = 15;
   SimpleTypeNames : Array[1..SimpleTypeCount] of string =
     ('byte','boolean','char','integer','int64','longint','longword','double',
      'shortint','smallint','string','word','qword','cardinal','widechar');
   SimpleTypeCaseNames : Array[1..SimpleTypeCount] of string =
     ('Byte','Boolean','Char','Integer','Int64','LongInt','LongWord','Double',
     'ShortInt','SmallInt','String','Word','QWord','Cardinal','WideChar');

Var
  S : String;
  I : Integer;

begin
  S:=LowerCase(AName);
  I:=SimpleTypeCount;
  While (I>0) and (s<>SimpleTypeNames[i]) do
    Dec(I);
  Result:=(I>0);
  if Result Then
    AName:=SimpleTypeCaseNames[I];
end;

function TCShParser.ParseStringType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String): TCShAliasType;

Var
  LengthAsText : String;
  ok: Boolean;
  Params: TParamsExpr;
  LengthExpr: TCShExpr;

begin
  Result := TCShAliasType(CreateElement(TCShAliasType, TypeName, Parent, NamePos));
  ok:=false;
  try
    If (Result.Name='') then
      Result.Name:='string';
    Result.Expr:=CreatePrimitiveExpr(Result,pekIdent,TypeName);
    NextToken;
    LengthAsText:='';
    if CurToken=tkSquaredBraceOpen then
      begin
      Params:=TParamsExpr(CreateElement(TParamsExpr,'',Result));
      Params.Value:=Result.Expr;
      Params.Value.Parent:=Params;
      Result.Expr:=Params;
      LengthAsText:='';
      NextToken;
      LengthExpr:=DoParseExpression(Params,nil,false);
      Params.AddParam(LengthExpr);
      CheckToken(tkSquaredBraceClose);
      LengthAsText:=ExprToText(LengthExpr);
      end
    else
      UngetToken;
    Result.DestType:=TCShStringType(CreateElement(TCShStringType,'string',Result));
    TCShStringType(Result.DestType).LengthExpr:=LengthAsText;
    ok:=true;
  finally
    if not ok then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.ParseSimpleType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String; IsFull: Boolean
  ): TCShType;

Type
  TSimpleTypeKind = (stkAlias,stkString,stkRange);

Var
  Ref: TCShType;
  K : TSimpleTypeKind;
  Name : String;
  Expr: TCShExpr;
  ok, MustBeSpecialize: Boolean;

begin
  Result:=nil;
  MustBeSpecialize:=false;
  Name := CurTokenString;
  Expr:=nil;
  Ref:=nil;
  ok:=false;
  try
    if IsFull then
      Name:=ReadDottedIdentifier(Parent,Expr,true)
    else
      begin
      NextToken;
      while CurToken=tkDot do
        begin
        ExpectIdentifier;
        Name := Name+'.'+CurTokenString;
        NextToken;
        end;
      end;

    if MustBeSpecialize and (CurToken<>tkLessThan) then
      ParseExcTokenError('<');

    // Current token is first token after identifier.
    if IsFull and (CurToken=tkSemicolon) or isCurTokenHint then // Type A = B;
      begin
      K:=stkAlias;
      UnGetToken;
      end
    else if IsFull and (CurToken=tkSquaredBraceOpen) then
      begin
      if LowerCase(Name)='string' then // Type A = String[12]; shortstring
        K:=stkString
      else
        ParseExcSyntaxError;
      UnGetToken;
      end
    else if (CurToken = tkLessThan) then // A = B<t>;
      begin
      Result:=ParseSpecializeType(Parent,NamePos,TypeName,Name,Expr);
      ok:=true;
      exit;
      end
    else if (CurToken in [tkBraceOpen,tkDotDot]) then // A: B..C;
      begin
      K:=stkRange;
      UnGetToken;
      end
    else
      begin
      if IsFull then
        ParseExcTokenError(';');
      K:=stkAlias;
      if (not (po_resolvestandardtypes in Options)) and (LowerCase(Name)='string') then
        K:=stkString;
      UnGetToken;
      end;

    Case K of
      stkString:
        begin
        ReleaseAndNil(TCShElement(Expr){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
        Result:=ParseStringType(Parent,NamePos,TypeName);
        end;
      stkRange:
        begin
        ReleaseAndNil(TCShElement(Expr){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
        UnGetToken; // move to '='
        Result:=ParseRangeType(Parent,NamePos,TypeName,False);
        end;
      stkAlias:
        begin
        Ref:=ResolveTypeReference(Name,Parent);
        if IsFull then
          begin
          Result := TCShAliasType(CreateElement(TCShAliasType, TypeName, Parent, NamePos));
          TCShAliasType(Result).DestType:=Ref;
          Ref:=nil;
          TCShAliasType(Result).Expr:=Expr;
          Expr.Parent:=Result;
          Expr:=nil;
          if TypeName<>'' then
            Engine.FinishScope(stTypeDef,Result);
          end
        else
          Result:=Ref;
        end;
    end;
    ok:=true;
  finally
    if not ok then
      begin
      if Result<>nil then
        Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      if Expr<>nil then
        Expr.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      if Ref<>nil then
        Ref.Release{$IFDEF CheckCShTreeRefCount}('ResolveTypeReference'){$ENDIF};
      end
  end;
end;

// On entry, we're on the TYPE token
function TCShParser.ParseAliasType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String): TCShType;
var
  ok: Boolean;
begin
  Result := TCShTypeAliasType(CreateElement(TCShTypeAliasType, TypeName, Parent, NamePos));
  ok:=false;
  try
    TCShTypeAliasType(Result).DestType := ParseType(Result,NamePos,'');
    Engine.FinishTypeAlias(Result);
    Engine.FinishScope(stTypeDef,Result);
    ok:=true;
  finally
    if not ok then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.ParseTypeReference(Parent: TCShElement; NeedExpr: boolean;
  out Expr: TCShExpr): TCShType;
// returns either
// a) TCShSpecializeType, Expr=nil
// b) TCShUnresolvedTypeRef, Expr<>nil
// c) TCShType, Expr<>nil
// After parsing CurToken is behind last reference token, e.g. ;
var
  Name: String;
  IsSpecialize, ok: Boolean;
  NamePos: TCShSourcePos;
begin
  Result:=nil;
  Expr:=nil;
  ok:=false;
  try
    NamePos:=CurSourcePos;
    IsSpecialize:=false;
    // read dotted identifier
    CheckToken(tkIdentifier);
    Name:=ReadDottedIdentifier(Parent,Expr,true);

    if CurToken=tkLessThan then
      begin
      // specialize
        Result:=ParseSpecializeType(Parent,NamePos,'',Name,Expr);
        NextToken;
      end
    else if IsSpecialize then
      CheckToken(tkLessThan)
    else
      begin
      // simple type reference
      Result:=ResolveTypeReference(Name,Parent);
      end;
    ok:=true;
  finally
    if not ok then
      begin
      if Result<>nil then
        Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      ReleaseAndNil(TCShElement(Expr){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
      end
    else if (not NeedExpr) and (Expr<>nil) then
      ReleaseAndNil(TCShElement(Expr){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
  end;
end;

function TCShParser.ParseSpecializeType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName, GenName: string;
  var GenNameExpr: TCShExpr): TCShSpecializeType;
// after parsing CurToken is at >
var
  ST: TCShSpecializeType;
begin
  Result:=nil;
  if CurToken<>tkLessThan then
    ParseExcTokenError('[20190801112729]');
  ST:=TCShSpecializeType(CreateElement(TCShSpecializeType,TypeName,Parent,NamePos));
  try
    if GenNameExpr<>nil then
      begin
      ST.Expr:=GenNameExpr;
      GenNameExpr.Parent:=ST;
      GenNameExpr:=nil; // ownership transferred to ST
      end;
    // read nested specialize arguments
    ReadSpecializeArguments(ST,ST.Params);
    // Important: resolve type reference AFTER args, because arg count is needed
    ST.DestType:=ResolveTypeReference(GenName,ST,ST.Params.Count);

    if CurToken<>tkGreaterThan then
      ParseExcTokenError('[20190801113005]');
    // ToDo: cascaded specialize A<B>.C<D>

    Engine.FinishScope(stTypeDef,ST);
    Result:=ST;
  finally
    if Result=nil then
      ST.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.ParsePointerType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String): TCShPointerType;

var
  ok: Boolean;
  Name: String;
begin
  Result := TCShPointerType(CreateElement(TCShPointerType, TypeName, Parent, NamePos));
  ok:=false;
  Try
    // only allowed: ^dottedidentifer
    // forbidden: ^^identifier, ^array of word, ^A<B>
    ExpectIdentifier;
    Name:=CurTokenString;
    repeat
      NextToken;
      if CurToken=tkDot then
        begin
        ExpectIdentifier;
        Name := Name+'.'+CurTokenString;
        end
      else
        break;
    until false;
    UngetToken;
    Result.DestType:=ResolveTypeReference(Name,Result);
    Engine.FinishScope(stTypeDef,Result);
    ok:=true;
  finally
    if not ok then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.ParseEnumType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String): TCShEnumType;

Var
  EnumValue: TCShEnumValue;
  ok: Boolean;

begin
  Result := TCShEnumType(CreateElement(TCShEnumType, TypeName, Parent, NamePos));
  ok:=false;
  try
    while True do
      begin
      NextToken;
      SaveComments;
      EnumValue := TCShEnumValue(CreateElement(TCShEnumValue, CurTokenString, Result));
      Result.Values.Add(EnumValue);
      NextToken;
      if CurToken = tkBraceClose then
        break
      else if CurToken in [tkEqual,tkAssign] then
        begin
        NextToken;
        EnumValue.Value:=DoParseExpression(Result);
       // UngetToken;
        if CurToken = tkBraceClose then
          Break
        else if not (CurToken=tkComma) then
          ParseExc(nParserExpectedCommaRBracket,SParserExpectedCommaRBracket);
        end
      else if not (CurToken=tkComma) then
        ParseExc(nParserExpectedCommaRBracket,SParserExpectedCommaRBracket)
      end;
    Engine.FinishScope(stTypeDef,Result);
    ok:=true;
  finally
    if not ok then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.ParseSetType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String; AIsPacked : Boolean = False): TCShSetType;

var
  ok: Boolean;
begin
  Result := TCShSetType(CreateElement(TCShSetType, TypeName, Parent, NamePos));
  Result.IsPacked:=AIsPacked;
  ok:=false;
  try
//    ExpectToken(tkOf);
    Result.EnumType := ParseType(Result,CurSourcePos);
    Engine.FinishScope(stTypeDef,Result);
    ok:=true;
  finally
    if not ok then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.ParseType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String; Full: Boolean
  ): TCShType;

Type
  TLocalClassType = (lctClass,lctObjcClass,lctObjcCategory,lctHelper);

Const
  // These types are allowed only when full type declarations
  FullTypeTokens = [tkClass,tkInterface];
  // Parsing of these types already takes care of hints
  NoHintTokens = [tkVoid];
  InterfaceKindTypes : Array[Boolean] of TCShObjKind = (okInterface,okObjcProtocol);
  ClassKindTypes : Array[TLocalClassType] of TCShObjKind = (okClass,okObjCClass,okObjcCategory,okClassHelper);


var
  PM: TPackMode;
  CH, ok, isHelper : Boolean;
  lClassType : TLocalClassType;

begin
  Result := nil;
  // NextToken and check pack mode
  Pm:=CheckPackMode;
  if Full then
    CH:=Not (CurToken in NoHintTokens)
  else
    begin
    CH:=False;
    if (CurToken in FullTypeTokens) then
      ParseExc(nParserTypeNotAllowedHere,SParserTypeNotAllowedHere,[CurtokenText]);
    end;
  ok:=false;
  Try
    case CurToken of
      // types only allowed when full
      tkObject: Result := ParseClassDecl(Parent, NamePos, TypeName, okObject,PM);
      tkInterface:
        begin
        Result := ParseClassDecl(Parent, NamePos, TypeName,okInterface,PM);
        end;
      tkClass:
        begin
          begin
          lClassType:=lctClass;
          NextToken;
          if CurTokenIsIdentifier('Helper') then
            begin
            // class helper: atype end;
            // class helper for atype end;
            NextToken;
            if CurToken in [tkfor,tkBraceOpen] then
              lClassType:=lctHelper;
            UnGetToken;
            end;
          UngetToken;
          end;
        Result:=ParseClassDecl(Parent,NamePos,TypeName,ClassKindTypes[lClasstype], PM);
        end;
      // Always allowed
      tkIdentifier:
        begin
        // Bug 31709: PReference = ^Reference;
        // Checked in Delphi: ^Reference to procedure; is not allowed !!
        if CurTokenIsIdentifier('reference') and Not (Parent is TCShPointerType) then
          begin
          CH:=False;
          Result:=ParseReferencetoProcedureType(Parent,NamePos,TypeName)
          end
        else
          Result:=ParseSimpleType(Parent,NamePos,TypeName,Full);
        end;
      tkBraceOpen: Result:=ParseEnumType(Parent,NamePos,TypeName);
      tkVoid: Result:=ParseProcedureType(Parent,NamePos,TypeName,ptProcedure);
//      tkFunction: Result:=ParseProcedureType(Parent,NamePos,TypeName,ptFunction);
      tkStruct:
        begin
        NextToken;
        isHelper:=false;
        if CurTokenIsIdentifier('Helper') then
          begin
          // record helper: atype end;
          // record helper for atype end;
          NextToken;
          isHelper:=CurToken in [tkfor,tkBraceOpen];
          UnGetToken;
          end;
        UngetToken;
        if isHelper then
          Result:=ParseClassDecl(Parent,NamePos,TypeName,okRecordHelper,PM)
        else
          Result:=ParseRecordDecl(Parent,NamePos,TypeName,PM);
        end;
      tkNumber,tkMinus,tkChar:
        begin
        UngetToken;
        Result:=ParseRangeType(Parent,NamePos,TypeName,Full);
        end;
    else
      ParseExcExpectedIdentifier;
    end;
    if CH then
      CheckHint(Result,True);
    ok:=true;
  finally
    if not ok then
      if Result<>nil then
        Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.ParseReferenceToProcedureType(Parent: TCShElement; const NamePos: TCShSourcePos; const TypeName: String
  ): TCShProcedureType;
begin
  if not CurTokenIsIdentifier('reference') then
    ParseExcTokenError('reference');
//  ExpectToken(tkTo);
  NextToken;
  Case CurToken of
   tkVoid : Result:=ParseProcedureType(Parent,NamePos,TypeName,ptProcedure);
//   tkfunction : Result:=ParseProcedureType(Parent,NamePos,TypeName,ptFunction);
  else
    result:=Nil; // Fool compiler
    ParseExcTokenError('procedure or function');
  end;
  Result.IsReferenceTo:=True;
end;

function TCShParser.ParseVarType(Parent : TCShElement = Nil): TCShType;
var
  NamePos: TCShSourcePos;
begin
  NextToken;
  case CurToken of
    tkVoid:
      begin
        Result := TCShProcedureType(CreateElement(TCShProcedureType, '', Parent));
        ParseProcedureOrFunction(Result, TCShProcedureType(Result), ptProcedure, True);
        if CurToken = tkSemicolon then
          UngetToken;        // Unget semicolon
      end;
{    tkFunction:
      begin
        Result := CreateFunctionType('', 'Result', Parent, False, CurSourcePos);
        ParseProcedureOrFunction(Result, TCShFunctionType(Result), ptFunction, True);
        if CurToken = tkSemicolon then
          UngetToken;        // Unget semicolon
      end; }
  else
    NamePos:=CurSourcePos;
    UngetToken;
    Result := ParseType(Parent,NamePos);
  end;
end;

function TCShParser.ParseArrayType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String; PackMode: TPackMode
  ): TCShArrayType;
Var
  ok: Boolean;
begin
  Result := TCShArrayType(CreateElement(TCShArrayType, TypeName, Parent, NamePos));
  ok:=false;
  try
    Result.PackMode:=PackMode;
    DoParseArrayType(Result);
    Engine.FinishScope(stTypeDef,Result);
    ok:=true;
  finally
    if not ok then
      begin
      Result.Parent:=nil;
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      end;
  end;
end;

function TCShParser.isEndOfExp(AllowEqual : Boolean = False; CheckHints : Boolean = True):Boolean;
const
  EndExprToken = [
    tkEOF, tkBraceClose, tkSquaredBraceClose, tkSemicolon, tkComma, tkColon,
    tkelse, tkCurlyBraceClose ];
begin
  if (CurToken in EndExprToken) or (CheckHints and IsCurTokenHint) then
    exit(true);
  if AllowEqual and (CurToken=tkEqual) then
    exit(true);
  Result:=false;
end;

function TCShParser.ExprToText(Expr: TCShExpr): String;
var
  C: TClass;
begin
  Result:='';
  C:=Expr.ClassType;
  if C=TPrimitiveExpr then
    Result:=TPrimitiveExpr(Expr).Value
  else if C=TThisExpr then
    Result:='self'
  else if C=TBoolConstExpr then
    Result:=BoolToStr(TBoolConstExpr(Expr).Value,'true','false')
  else if C=TNullExpr then
    Result:='nil'
  else if C=TInheritedExpr then
    Result:='inherited'
  else if C=TUnaryExpr then
    Result:=OpcodeStrings[TUnaryExpr(Expr).OpCode]+ExprToText(TUnaryExpr(Expr).Operand)
  else if C=TBinaryExpr then
    begin
    Result:=ExprToText(TBinaryExpr(Expr).left);
    if OpcodeStrings[TBinaryExpr(Expr).OpCode]<>'' then
      Result:=Result+OpcodeStrings[TBinaryExpr(Expr).OpCode]
    else
      Result:=Result+' ';
    Result:=Result+ExprToText(TBinaryExpr(Expr).right)
    end
  else if C=TParamsExpr then
    begin
    case TParamsExpr(Expr).Kind of
      pekArrayParams: Result:=ExprToText(TParamsExpr(Expr).Value)
        +'['+ArrayExprToText(TParamsExpr(Expr).Params)+']';
      pekFuncParams: Result:=ExprToText(TParamsExpr(Expr).Value)
        +'('+ArrayExprToText(TParamsExpr(Expr).Params)+')';
      pekSet: Result:='['+ArrayExprToText(TParamsExpr(Expr).Params)+']';
      else ParseExc(nErrUnknownOperatorType,SErrUnknownOperatorType,[ExprKindNames[TParamsExpr(Expr).Kind]]);
    end;
    end
  else
    ParseExc(nErrUnknownOperatorType,SErrUnknownOperatorType,['TCShParser.ExprToText: '+Expr.ClassName]);
end;

function TCShParser.ArrayExprToText(Expr: TCShExprArray): String;
var
  i: Integer;
begin
  Result:='';
  for i:=0 to length(Expr)-1 do
    begin
    if i>0 then
      Result:=Result+',';
    Result:=Result+ExprToText(Expr[i]);
    end;
end;

function TCShParser.ResolveTypeReference(Name: string; Parent: TCShElement;
  ParamCnt: integer): TCShType;
var
  SS: Boolean;
  Ref: TCShElement;
begin
  Ref:=Nil;
  SS:=(not (po_ResolveStandardTypes in FOptions)) and isSimpleTypeToken(Name);
  if not SS then
    begin
    Ref:=Engine.FindElementFor(Name,Parent,ParamCnt);
    if Ref=nil then
      begin
      {$IFDEF VerboseCShResolver}
      {AllowWriteln}
      if po_resolvestandardtypes in FOptions then
        begin
        writeln('ERROR: TCShParser.ResolveTypeReference: resolver failed to raise an error');
        ParseExcExpectedIdentifier;
        end;
      {AllowWriteln-}
      {$ENDIF}
      end
    else if not (Ref is TCShType) then
      ParseExc(nParserExpectedTypeButGot,SParserExpectedTypeButGot,[Ref.ElementTypeName]);
    end;
  if (Ref=Nil) then
    Result:=TCShUnresolvedTypeRef(CreateElement(TCShUnresolvedTypeRef,Name,Parent))
  else
    begin
    Ref.AddRef{$IFDEF CheckCShTreeRefCount}('ResolveTypeReference'){$ENDIF};
    Result:=TCShType(Ref);
    end;
end;

function TCShParser.ParseParams(AParent: TCShElement; ParamsKind: TCShExprKind;
  AllowFormatting: Boolean = False): TParamsExpr;
var
  Params  : TParamsExpr;
  Expr    : TCShExpr;
  PClose  : TToken;

begin
  Result:=nil;
  if ParamsKind in [pekArrayParams, pekSet] then
    begin
    if CurToken<>tkSquaredBraceOpen then
      ParseExc(nParserExpectTokenError,SParserExpectTokenError,['[']);
    PClose:=tkSquaredBraceClose;
    end
  else
    begin
    if CurToken<>tkBraceOpen then
      ParseExc(nParserExpectTokenError,SParserExpectTokenError,['(']);
    PClose:=tkBraceClose;
    end;

  Params:=TParamsExpr(CreateElement(TParamsExpr,'',AParent,CurTokenPos));
  try
    Params.Kind:=ParamsKind;
    NextToken;
    if not isEndOfExp(false,false) then
      begin
      repeat
        Expr:=DoParseExpression(Params);
        if not Assigned(Expr) then
          ParseExcSyntaxError;
        Params.AddParam(Expr);
        if (CurToken=tkColon) then
          if Not AllowFormatting then
            ParseExc(nParserExpectTokenError,SParserExpectTokenError,[','])
          else
            begin
            NextToken;
            Expr.format1:=DoParseExpression(Expr);
            if (CurToken=tkColon) then
              begin
              NextToken;
              Expr.format2:=DoParseExpression(Expr);
              end;
            end;
        if not (CurToken in [tkComma, PClose]) then
          ParseExc(nParserExpectTokenError,SParserExpectTokenError,[',']);

        if CurToken = tkComma then
          begin
          NextToken;
          if CurToken = PClose then
            begin
            //ErrorExpected(parser, 'identifier');
            ParseExcSyntaxError;
            end;
          end;
      until CurToken=PClose;
      end;
    NextToken;
    Result:=Params;
  finally
    if Result=nil then
      Params.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.TokenToExprOp(AToken: TToken): TExprOpCode;

begin
  Case AToken of
    tkMul                   : Result:=eopMultiply;
    tkPlus                  : Result:=eopAdd;
    tkMinus                 : Result:=eopSubtract;
    tkDivision              : Result:=eopDivide;
    tkLessThan              : Result:=eopLessThan;
    tkEqual                 : Result:=eopEqual;
    tkGreaterThan           : Result:=eopGreaterThan;
    tkNotEqual              : Result:=eopNotEqual;
    tkLessEqualThan         : Result:=eopLessthanEqual;
    tkGreaterEqualThan      : Result:=eopGreaterThanEqual;
    tkPower                 : Result:=eopPower;
    tkSymmetricalDifference : Result:=eopSymmetricalDifference;
    tkIs                    : Result:=eopIs;
    tkAs                    : Result:=eopAs;
    tkSHR                   : Result:=eopSHR;
    tkSHL                   : Result:=eopSHL;
    tkAnd                   : Result:=eopSingleAnd;
    tkOr                    : Result:=eopSingleOr;
    tkXor                   : Result:=eopXOR;
    tkMod                   : Result:=eopMod;
    tkNot                   : Result:=eopNot;
    tkIn                    : Result:=eopIn;
    tkDot                   : Result:=eopSubIdent;
  else
    result:=eopAdd; // Fool compiler
    ParseExc(nParserNotAnOperand,SParserNotAnOperand,[AToken,TokenInfos[AToken]]);
  end;
end;

function TCShParser.ParseExprOperand(AParent: TCShElement): TCShExpr;
type
  TAllow = (aCannot, aCan, aMust);

  Function IsWriteOrStr(P : TCShExpr) : boolean;

  Var
    N : String;
  begin
    Result:=P is TPrimitiveExpr;
    if Result then
      begin
      N:=LowerCase(TPrimitiveExpr(P).Value);
      // We should actually resolve this to system.NNN
      Result:=(N='write') or (N='str') or (N='writeln') or (N='writestr');
      end;
  end;

  function IsSpecialize: boolean;
  var
    LookAhead, i: Integer;

    function Next: boolean;
    begin
      if LookAhead=FTokenRingSize then exit(false);
      NextToken;
      inc(LookAhead);
      Result:=true;
    end;

  begin
    Result:=false;
    LookAhead:=0;
    CheckToken(tkLessThan);
    try
      Next;
      if not (CurToken in [tkIdentifier,tkThis]) then exit;
      while Next do
        case CurToken of
        tkDot:
          begin
          if not Next then exit;
          if not (CurToken in [tkIdentifier,tkThis,tktrue,tkfalse]) then exit;
          end;
        tkComma:
          begin
          if not Next then exit;
          if not (CurToken in [tkIdentifier,tkThis]) then exit;
          end;
        tkLessThan:
          begin
          // e.g. A<B<
          // not a valid comparison, could be a specialization -> good enough
          exit(true);
          end;
        tkGreaterThan:
          begin
          // e.g. A<B>
          exit(true);
          end;
        else
          exit;
        end;
    finally
      for i:=1 to LookAhead do
        UngetToken;
    end;
  end;

var
  Last, Func, Expr: TCShExpr;
  Params: TParamsExpr;
  Bin: TBinaryExpr;
  ok: Boolean;
  CanSpecialize: TAllow;
  aName: String;
  ISE: TInlineSpecializeExpr;
  SrcPos, ScrPos: TCShSourcePos;
  ProcType: TProcType;
  ProcExpr: TProcedureExpr;
begin
  Result:=nil;
  CanSpecialize:=aCannot;
  aName:='';
  case CurToken of
    tkString: Last:=CreatePrimitiveExpr(AParent,pekString,CurTokenString);
    tkChar:   Last:=CreatePrimitiveExpr(AParent,pekString,CurTokenText);
    tkNumber: Last:=CreatePrimitiveExpr(AParent,pekNumber,CurTokenString);
    tkIdentifier:
      begin
        CanSpecialize:=aCan;
      aName:=CurTokenText;
      if (CompareText(aName,'self')=0) and not (tkThis in Scanner.NonTokens) then
        Last:=CreateSelfExpr(AParent)
      else
        Last:=CreatePrimitiveExpr(AParent,pekIdent,aName);
      end;
    tkfalse, tktrue:    Last:=CreateBoolConstExpr(AParent,pekBoolConst, CurToken=tktrue);
    tkNull:              Last:=CreateNilExpr(AParent);
    tkSquaredBraceOpen:
      begin
      Last:=ParseParams(AParent,pekSet);
      UngetToken;
      end;
    tkBase:
      begin
      //inherited; inherited function
      Last:=CreateInheritedExpr(AParent);
      NextToken;
      if (CurToken=tkIdentifier) then
        begin
        SrcPos:=CurTokenPos;
        Bin:=CreateBinaryExpr(AParent,Last,ParseExprOperand(AParent),eopNone,SrcPos);
        if not Assigned(Bin.right) then
          begin
          Bin.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
          ParseExcExpectedIdentifier;
          end;
        Result:=Bin;
        exit;
        end;
      UngetToken;
      end;
    tkThis:
      begin
      CanSpecialize:=aCan;
      aName:=CurTokenText;
      Last:=CreateSelfExpr(AParent);
      end;
    tkVoid //,tkfunction
    :
      begin
      if not IsAnonymousProcAllowed(AParent) then
        ParseExcExpectedIdentifier;
      if CurToken=tkVoid then
        ProcType:=ptAnonymousProcedure
      else
        ProcType:=ptAnonymousFunction;
      try
        ProcExpr:=TProcedureExpr(CreateElement(TProcedureExpr,'',AParent,visPublic));
        ProcExpr.Proc:=TCShAnonymousProcedure(ParseProcedureOrFunctionDecl(ProcExpr,ProcType,false));
        Engine.FinishScope(stProcedure,ProcExpr.Proc);
        Result:=ProcExpr;
      finally
        if Result=nil then
          ProcExpr.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      end;
      exit; // do not allow postfix operators . ^. [] ()
      end;
    tkBraceOpen:
      begin
      NextToken;
      Last:=DoParseExpression(AParent);
      if not Assigned(Last) then
        ParseExcSyntaxError;
      if (CurToken<>tkBraceClose) then
        begin
        Last.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
        CheckToken(tkBraceClose);
        end;
      end
  else
    ParseExcExpectedIdentifier;
  end;

  Result:=Last;
  ok:=false;
  ISE:=nil;
  try
    NextToken;
    Func:=Last;
    repeat
      case CurToken of
      tkDot:
        begin
        ScrPos:=CurTokenPos;
        NextToken;
        if CurToken in [tkIdentifier,tktrue,tkfalse,tkThis] then // true and false are sub identifiers as well
          begin
          aName:=aName+'.'+CurTokenString;
          Expr:=CreatePrimitiveExpr(AParent,pekIdent,CurTokenString);
          AddToBinaryExprChain(Result,Expr,eopSubIdent,ScrPos);
          Func:=Expr;
          NextToken;
          end
        else
          begin
          UngetToken;
          ParseExcExpectedIdentifier;
          end;
        end;
      tkBraceOpen,tkSquaredBraceOpen:
        begin
        if CurToken=tkBraceOpen then
          Params:=ParseParams(AParent,pekFuncParams,IsWriteOrStr(Func))
        else
          Params:=ParseParams(AParent,pekArrayParams);
        if not Assigned(Params) then Exit;
        Params.Value:=Result;
        Result.Parent:=Params;
        Result:=Params;
        CanSpecialize:=aCannot;
        Func:=nil;
        end;
      tkLessThan:
        begin
        SrcPos:=CurTokenPos;
        if CanSpecialize=aCannot then
          break
        else if (CanSpecialize=aCan) and not IsSpecialize then
          break
        else
          begin
          // an inline specialization (e.g. A<B,C>  or  something.A<B>)
          // check expression in front is an identifier
          Expr:=Result;
          if Expr.Kind=pekBinary then
            begin
            if Expr.OpCode<>eopSubIdent then
              ParseExcSyntaxError;
            Expr:=TBinaryExpr(Expr).right;
            end;
          if Expr.Kind<>pekIdent then
            ParseExcSyntaxError;

          // read specialized params
          ISE:=TInlineSpecializeExpr(CreateElement(TInlineSpecializeExpr,'',AParent,SrcPos));
          ReadSpecializeArguments(ISE,ISE.Params);

          // A<B>  or  something.A<B>
          ISE.NameExpr:=Result;
          Result.Parent:=ISE;
          Result:=ISE;
          ISE:=nil;
          CanSpecialize:=aCannot;
          NextToken;
          end;
        Func:=nil;
        end
      else
        break;
      end;
    until false;
    ok:=true;
  finally
    if not ok then
      begin
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      ISE.Free;
      end;
  end;
end;

function TCShParser.ParseExpIdent(AParent: TCShElement): TCShExpr;
begin
  Result:=ParseExprOperand(AParent);
end;

function TCShParser.OpLevel(t: TToken): Integer;
begin
  case t of
  //  tkDot:
  //    Result:=5;
    tknot,tkAt:
      Result:=4;
    tkMul, tkDivision, tkmod, tkand, tkShl,tkShr, tkas, tkPower, tkis:
      // Note that "is" has same precedence as "and" in Delphi and fpc, even though
      // some docs say otherwise. e.g. "Obj is TObj and aBool"
      Result:=3;
    tkPlus, tkMinus, tkor, tkxor:
      Result:=2;
    tkEqual, tkNotEqual, tkLessThan, tkLessEqualThan, tkGreaterThan, tkGreaterEqualThan, tkin:
      Result:=1;
  else
    Result:=0;
  end;
end;

function TCShParser.DoParseExpression(AParent: TCShElement; InitExpr: TCShExpr;
  AllowEqual: Boolean): TCShExpr;
type
  TOpStackItem = record
    Token: TToken;
    SrcPos: TCShSourcePos;
  end;

var
  ExpStack  : TFPList; // list of TCShExpr
  OpStack   : array of TOpStackItem;
  OpStackTop: integer;
  PrefixCnt : Integer;
  x         : TCShExpr;
  i         : Integer;
  TempOp    : TToken;
  NotBinary : Boolean;

const
  PrefixSym = [tkPlus, tkMinus, tknot, tkAt, tkKomplement]; // + - not @ @@
  BinaryOP  = [tkMul, tkDivision, tkmod,  tkDotDot,
               tkand, tkShl,tkShr, tkas, tkPower,
               tkPlus, tkMinus, tkor, tkSingleAnd,tkSingleOr, tkxor, tkSymmetricalDifference,
               tkEqual, tkNotEqual, tkLessThan, tkLessEqualThan,
               tkGreaterThan, tkGreaterEqualThan, tkin, tkis, tkAsk, tkAskAsk];

  function PopExp: TCShExpr; inline;
  begin
    if ExpStack.Count>0 then begin
      Result:=TCShExpr(ExpStack[ExpStack.Count-1]);
      ExpStack.Delete(ExpStack.Count-1);
    end else
      Result:=nil;
  end;

  procedure PushOper(Token: TToken);
  begin
    inc(OpStackTop);
    if OpStackTop=length(OpStack) then
      SetLength(OpStack,length(OpStack)*2+4);
    OpStack[OpStackTop].Token:=Token;
    OpStack[OpStackTop].SrcPos:=CurTokenPos;
  end;

  function PeekOper: TToken; inline;
  begin
    if OpStackTop>=0 then Result:=OpStack[OpStackTop].Token
    else Result:=tkEOF;
  end;

  function PopOper(out SrcPos: TCShSourcePos): TToken;
  begin
    Result:=PeekOper;
    if Result=tkEOF then
      SrcPos:=DefCShSourcePos
    else
      begin
      SrcPos:=OpStack[OpStackTop].SrcPos;
      dec(OpStackTop);
      end;
  end;

  procedure PopAndPushOperator;
  var
    t       : TToken;
    xright  : TCShExpr;
    xleft   : TCShExpr;
    bin     : TBinaryExpr;
    SrcPos: TCShSourcePos;
  begin
    t:=PopOper(SrcPos);
    xright:=PopExp;
    xleft:=PopExp;
    if t=tkDotDot then
      begin
      bin:=CreateBinaryExpr(AParent,xleft,xright,eopNone,SrcPos);
      bin.Kind:=pekRange;
      end
    else
      bin:=CreateBinaryExpr(AParent,xleft,xright,TokenToExprOp(t),SrcPos);
    ExpStack.Add(bin);
  end;

Var
  AllowedBinaryOps : Set of TToken;
  SrcPos: TCShSourcePos;
begin
  AllowedBinaryOps:=BinaryOP;
  if Not AllowEqual then
    Exclude(AllowedBinaryOps,tkEqual);
  {$ifdef VerboseCShParser}
  //DumpCurToken('Entry',iaIndent);
  {$endif}
  Result:=nil;
  ExpStack := TFPList.Create;
  SetLength(OpStack,4);
  OpStackTop:=-1;
  try
    repeat
      NotBinary:=True;
      PrefixCnt:=0;
      if not Assigned(InitExpr) then
        begin

        // parse prefix operators
        while CurToken in PrefixSym do
          begin
          PushOper(CurToken);
          inc(PrefixCnt);
          NextToken;
          end;
        // parse operand
        x:=ParseExprOperand(AParent);
        if not Assigned(x) then
          ParseExcSyntaxError;
        ExpStack.Add(x);
        // apply prefixes
        for i:=1 to PrefixCnt do
          begin
          TempOp:=PopOper(SrcPos);
          x:=PopExp;
          if (TempOp=tkMinus) and (x.Kind=pekRange) then
            begin
            TBinaryExpr(x).Left:=CreateUnaryExpr(x, TBinaryExpr(x).left,
                                                 eopSubtract, SrcPos);
            ExpStack.Add(x);
            end
          else
            ExpStack.Add(CreateUnaryExpr(AParent, x, TokenToExprOp(TempOp), SrcPos));
          end;
        end
      else
        begin
        // the first part of the expression has been parsed externally.
        // this is used by Constant Expression parser (CEP) parsing only,
        // whenever it makes a false assuming on constant expression type.
        // i.e: SI_PAD_SIZE = ((128/sizeof(longint)) - 3);
        //
        // CEP assumes that it's array or record, because the expression
        // starts with "(". After the first part is parsed, the CEP meets "-"
        // that assures, it's not an array expression. The CEP should give the
        // first part back to the expression parser, to get the correct
        // token tree according to the operations priority.
        //
        // quite ugly. type information is required for CEP to work clean
        ExpStack.Add(InitExpr);
        InitExpr:=nil;
        end;
      if (CurToken in AllowedBinaryOPs) then
        begin
        // process operators of higher precedence than next operator
        NotBinary:=False;
        TempOp:=PeekOper;
        while (OpStackTop>=0) and (OpLevel(TempOp)>=OpLevel(CurToken)) do begin
          PopAndPushOperator;
          TempOp:=PeekOper;
        end;
        PushOper(CurToken);
        NextToken;
        end;
       //Writeln('Bin ',NotBinary ,' or EOE ',isEndOfExp, ' Ex ',Assigned(x),' stack ',ExpStack.Count);
    until NotBinary or isEndOfExp(AllowEqual, NotBinary);

    if not NotBinary then ParseExcExpectedIdentifier;

    while OpStackTop>=0 do PopAndPushOperator;

    // only 1 expression should be left on the OpStack
    if ExpStack.Count<>1 then
      ParseExcSyntaxError;
    Result:=TCShExpr(ExpStack[0]);
    Result.Parent:=AParent;

  finally
    {$ifdef VerboseCShParser}
    if Not Assigned(Result) then
      DumpCurToken('Exiting (no result)',iaUndent)
    else
      DumpCurtoken('Exiting (Result: "'+Result.GetDeclaration(true)+'") ',iaUndent);
    {$endif}
    if not Assigned(Result) then begin
      // expression error!
      for i:=0 to ExpStack.Count-1 do
        TCShExpr(ExpStack[i]).Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
    end;
    SetLength(OpStack,0);
    ExpStack.Free;
  end;
end;

function GetExprIdent(p: TCShExpr): String;
begin
  Result:='';
  if not Assigned(p) then exit;
  if (p.ClassType=TPrimitiveExpr) and (p.Kind=pekIdent) then
    Result:=TPrimitiveExpr(p).Value
  else if (p.ClassType=TThisExpr) then
    Result:='Self';
end;

function TCShParser.DoParseConstValueExpression(AParent: TCShElement): TCShExpr;
// sets CurToken to token behind expression

  function lastfield:boolean;

  begin
    Result:=CurToken<>tkSemicolon;
    if not Result then
     begin
       NextToken;
       if CurToken=tkBraceClose then
         Result:=true
       else
         UngetToken;
     end;
  end;

  procedure ReadArrayValues(x : TCShExpr);
  var
    a: TArrayValues;
  begin
    Result:=nil;
    a:=nil;
    try
      a:=CreateArrayValues(AParent);
      if x<>nil then
        begin
        a.AddValues(x);
        x:=nil;
        end;
      repeat
        NextToken;
        a.AddValues(DoParseConstValueExpression(a));
      until CurToken<>tkComma;
      Result:=a;
    finally
      if Result=nil then
        begin
        a.Free;
        x.Free;
        end;
    end;
  end;

var
  x , v: TCShExpr;
  n : String;
  r : TRecordValues;
begin
  if CurToken <> tkBraceOpen then
    Result:=DoParseExpression(AParent)
  else begin
    Result:=nil;
    if Engine.NeedArrayValues(AParent) then
      ReadArrayValues(nil)
    else
      begin
      NextToken;
      x:=DoParseConstValueExpression(AParent);
      case CurToken of
        tkComma: // array of values (a,b,c);
          ReadArrayValues(x);

        tkColon: // record field (a:xxx;b:yyy;c:zzz);
          begin
          if not (x is TPrimitiveExpr) then
            CheckToken(tkBraceClose);
          r:=nil;
          try
            n:=GetExprIdent(x);
            r:=CreateRecordValues(AParent);
            NextToken;
            v:=DoParseConstValueExpression(r);
            r.AddField(TPrimitiveExpr(x), v);
            x:=nil;
            if not lastfield then
              repeat
                n:=ExpectIdentifier;
                x:=CreatePrimitiveExpr(r,pekIdent,n);
                ExpectToken(tkColon);
                NextToken;
                v:=DoParseConstValueExpression(AParent);
                r.AddField(TPrimitiveExpr(x), v);
                x:=nil;
              until lastfield; // CurToken<>tkSemicolon;
            Result:=r;
          finally
            if Result=nil then
              begin
              r.Free;
              x.Free;
              end;
          end;
          end;
      else
        // Binary expression!  ((128 div sizeof(longint)) - 3);
        Result:=DoParseExpression(AParent,x);
        if CurToken<>tkBraceClose then
          begin
          ReleaseAndNil(TCShElement(Result){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
          ParseExc(nParserExpectedCommaRBracket,SParserExpectedCommaRBracket);
          end;
        NextToken;
        if CurToken <> tkSemicolon then // the continue of expression
          Result:=DoParseExpression(AParent,Result);
        Exit;
      end;
      end;
    if CurToken<>tkBraceClose then
      begin
      ReleaseAndNil(TCShElement(Result){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
      ParseExc(nParserExpectedCommaRBracket,SParserExpectedCommaRBracket);
      end;
    NextToken;
  end;
end;

function TCShParser.CheckOverloadList(AList: TFPList; AName: String; out
  OldMember: TCShElement): TCShOverloadedProc;

Var
  I : Integer;

begin
  Result:=Nil;
  I:=0;
  While (Result=Nil) and (I<AList.Count) do
    begin
    OldMember:=TCShElement(AList[i]);
    if CompareText(OldMember.Name, AName) = 0 then
      begin
      if OldMember is TCShOverloadedProc then
        Result:=TCShOverloadedProc(OldMember)
      else
        begin
        Result:=TCShOverloadedProc(CreateElement(TCShOverloadedProc, AName, OldMember.Parent));
        OldMember.Parent:=Result;
        Result.Visibility:=OldMember.Visibility;
        Result.Overloads.Add(OldMember);
        Result.SourceFilename:=OldMember.SourceFilename;
        Result.SourceLinenumber:=OldMember.SourceLinenumber;
        Result.DocComment:=Oldmember.DocComment;
        AList[i] := Result;
        end;
      end;
    Inc(I);
    end;
  If Result=Nil then
    OldMember:=Nil;
end;

procedure TCShParser.AddProcOrFunction(Decs: TCShDeclarations;
  AProc: TCShProcedure);
var
  I : Integer;
  OldMember: TCShElement;
  OverloadedProc: TCShOverloadedProc;
begin
  OldMember:=nil;
  With Decs do
    begin
    if not (po_nooverloadedprocs in Options) then
      OverloadedProc:=CheckOverloadList(Functions,AProc.Name,OldMember)
    else
      OverloadedProc:=nil;
    If (OverloadedProc<>Nil) then
      begin
      OverLoadedProc.Overloads.Add(AProc);
      if (OldMember<>OverloadedProc) then
        begin
        I:=Declarations.IndexOf(OldMember);
        If I<>-1 then
          Declarations[i]:=OverloadedProc;
        end;
      end
    else
      begin
      Declarations.Add(AProc);
      Functions.Add(AProc);
      end;
    end;
  Engine.FinishScope(stProcedure,AProc);
end;

// Return the parent of a function declaration. This is AParent,
// except when AParent is a class/record and the function is overloaded.
// Then the parent is the overload object.
function TCShParser.CheckIfOverloaded(AParent: TCShElement; const AName: String): TCShElement;
var
  Member: TCShElement;
  OverloadedProc: TCShOverloadedProc;

begin
  Result:=AParent;
  If (not (po_nooverloadedprocs in Options)) and (AParent is TCShMembersType) then
    begin
    OverloadedProc:=CheckOverLoadList(TCShMembersType(AParent).Members,AName,Member);
    If (OverloadedProc<>Nil) then
      Result:=OverloadedProc;
    end;
end;

procedure TCShParser.ParseMain(var Module: TCShModule);
begin
  Module:=nil;
  NextToken;
  SaveComments;
  case CurToken of
    tkUsing:
      ParseUnit(Module);
    tkEOF:
      CheckToken(tkEOF);
  else
    UngetToken;
    ParseProgram(Module,True);
  end;
end;

// Starts after the "unit" token
procedure TCShParser.ParseUnit(var Module: TCShModule);
var
  AUnitName: String;
  StartPos: TCShSourcePos;
  HasFinished: Boolean;
begin
  StartPos:=CurTokenPos;
  Module := nil;
  AUnitName := ExpectIdentifier;
  NextToken;
  while CurToken = tkDot do
    begin
    ExpectIdentifier;
    AUnitName := AUnitName + '.' + CurTokenString;
    NextToken;
    end;
  UngetToken;
  Module := TCShModule(CreateElement(TCShModule, AUnitName, Engine.Package, StartPos));
  FCurModule:=Module;
  HasFinished:=true;
  try
    if Assigned(Engine.Package) then
      begin
      Module.PackageName := Engine.Package.Name;
      Engine.Package.Modules.Add(Module);
      Module.AddRef{$IFDEF CheckCShTreeRefCount}('TCShPackage.Modules'){$ENDIF};
      end;
    CheckHint(Module,True);
    ExpectToken(tkInterface);
    if po_StopOnUnitInterface in Options then
      begin
      HasFinished:=false;
      {$IFDEF VerboseCShResolver}
      writeln('TCShParser.ParseUnit pause parsing after unit name ',CurModule.Name);
      {$ENDIF}
      exit;
      end;
    if (Module.ImplementationSection<>nil)
        and (Module.ImplementationSection.PendingUsedIntf<>nil) then
      begin
      HasFinished:=false;
      {$IFDEF VerboseCShResolver}
      writeln('TCShParser.ParseUnit pause parsing after implementation uses list ',CurModule.Name);
      {$ENDIF}
      end;
    if HasFinished then
      FinishedModule;
  finally
    if HasFinished then
      FCurModule:=nil; // clear module if there is an error or finished parsing
  end;
end;

function TCShParser.GetLastSection: TCShSection;
begin
  Result:=nil;
  if FCurModule=nil then
    exit; // parse completed
  if CurModule is TCShProgram then
    Result:=TCShProgram(CurModule).ProgramSection
  else if CurModule is TCShLibrary then
    Result:=TCShLibrary(CurModule).LibrarySection
  else if (CurModule.ClassType=TCShModule) then
    begin
    if CurModule.ImplementationSection<>nil then
      Result:=CurModule.ImplementationSection
    end;
end;

function TCShParser.CanParseContinue(out Section: TCShSection): boolean;
begin
  Result:=false;
  Section:=nil;
  if FCurModule=nil then
    exit; // parse completed
  if (LastMsg<>'') and (LastMsgType<=mtError) then
    begin
    {$IF defined(VerboseCShResolver) or defined(VerboseUnitQueue)}
    writeln('TCShParser.CanParseContinue ',CurModule.Name,' LastMsg="',LastMsgType,':',LastMsg,'"');
    {$ENDIF}
    exit;
    end;
  if (Scanner.LastMsg<>'') and (Scanner.LastMsgType<=mtError) then
    begin
    {$IF defined(VerboseCShResolver) or defined(VerboseUnitQueue)}
    writeln('TCShParser.CanParseContinue ',CurModule.Name,' Scanner.LastMsg="',Scanner.LastMsgType,':',Scanner.LastMsg,'"');
    {$ENDIF}
    exit;
    end;

  Section:=GetLastSection;
  if Section=nil then
    if (po_StopOnUnitInterface in Options)
        and (CurModule.ClassType=TCShModule) then
      exit(true)
    else
      begin
      {$IFDEF VerboseUnitQueue}
      writeln('TCShParser.CanParseContinue ',CurModule.Name,' no LastSection');
      {$ENDIF}
      exit(false);
      end;
  Result:=Section.PendingUsedIntf=nil;
  {$IFDEF VerboseUnitQueue}
  writeln('TCShParser.CanParseContinue ',CurModule.Name,' Result=',Result,' ',Section.ElementTypeName);
  {$ENDIF}
end;

procedure TCShParser.ParseContinue;
// continue parsing after stopped due to pending uses
var
  Section: TCShSection;
  HasFinished: Boolean;
begin
  if CurModule=nil then
    ParseExcTokenError('TCShParser.ParseContinue missing module');
  {$IFDEF VerboseCShParser}
  writeln('TCShParser.ParseContinue ',CurModule.Name);
  {$ENDIF}
  if not CanParseContinue(Section) then
    ParseExcTokenError('TCShParser.ParseContinue missing section');
  HasFinished:=true;
  try
    if Section=nil then
      begin
      // continue after unit name
      end
    else
      begin
      // continue after uses clause
      Engine.FinishScope(stUsesClause,Section);
      ParseDeclarations(Section);
      end;
    Section:=GetLastSection;
    if Section=nil then
      ParseExc(nErrNoSourceGiven,'[20180306112327]');
    if Section.PendingUsedIntf<>nil then
      HasFinished:=false;
    if HasFinished then
      FinishedModule;
  finally
    if HasFinished then
      FCurModule:=nil; // clear module if there is an error or finished parsing
  end;
end;

// Starts after the "program" token
procedure TCShParser.ParseProgram(var Module: TCShModule; SkipHeader : Boolean = False);
Var
  PP : TCShProgram;
  Section : TProgramSection;
  N : String;
  StartPos: TCShSourcePos;
  HasFinished: Boolean;
  {$IFDEF VerboseCShResolver}
  aSection: TCShSection;
  {$ENDIF}
begin
  StartPos:=CurTokenPos;
  if SkipHeader then
    N:=ChangeFileExt(Scanner.CurFilename,'')
  else
    begin
    N:=ExpectIdentifier;
    NextToken;
    while CurToken = tkDot do
      begin
      ExpectIdentifier;
      N := N + '.' + CurTokenString;
      NextToken;
      end;
    UngetToken;
    end;
  Module := nil;
  PP:=TCShProgram(CreateElement(TCShProgram, N, Engine.Package, StartPos));
  Module :=PP;
  HasFinished:=true;
  FCurModule:=Module;
  try
    if Assigned(Engine.Package) then
    begin
      Module.PackageName := Engine.Package.Name;
      Engine.Package.Modules.Add(Module);
    end;
    if not SkipHeader then
      begin
      NextToken;
      If (CurToken=tkBraceOpen) then
        begin
        PP.InputFile:=ExpectIdentifier;
        NextToken;
        if Not (CurToken in [tkBraceClose,tkComma]) then
          ParseExc(nParserExpectedCommaRBracket,SParserExpectedCommaRBracket);
        If (CurToken=tkComma) then
          PP.OutPutFile:=ExpectIdentifier;
        ExpectToken(tkBraceClose);
        NextToken;
        end;
      if (CurToken<>tkSemicolon) then
        ParseExcTokenError(';');
      end;
    Section := TProgramSection(CreateElement(TProgramSection, '', CurModule));
    PP.ProgramSection := Section;
    ParseOptionalUsesList(Section);
    HasFinished:=Section.PendingUsedIntf=nil;
    if not HasFinished then
      begin
      {$IFDEF VerboseCShResolver}
      {AllowWriteln}
      writeln('TCShParser.ParseProgram pause parsing after uses list of "',CurModule.Name,'"');
      if CanParseContinue(aSection) then
        begin
        writeln('TCShParser.ParseProgram Section=',Section.ClassName,' Section.PendingUsedIntf=',Section.PendingUsedIntf<>nil);
        if aSection<>nil then
          writeln('TCShParser.ParseProgram aSection=',aSection.ClassName,' ',Section=aSection);
        ParseExc(nErrNoSourceGiven,'[20180305172432] ');
        end;
      {AllowWriteln-}
      {$ENDIF}
      exit;
      end;
    ParseDeclarations(Section);
    FinishedModule;
  finally
    if HasFinished then
      FCurModule:=nil; // clear module if there is an error or finished parsing
  end;
end;

// Starts after the "library" token
procedure TCShParser.ParseLibrary(var Module: TCShModule);
Var
  PP : TCShLibrary;
  Section : TLibrarySection;
  N: String;
  StartPos: TCShSourcePos;
  HasFinished: Boolean;

begin
  StartPos:=CurTokenPos;
  N:=ExpectIdentifier;
  NextToken;
  while CurToken = tkDot do
    begin
    ExpectIdentifier;
    N := N + '.' + CurTokenString;
    NextToken;
    end;
  UngetToken;
  Module := nil;
  PP:=TCShLibrary(CreateElement(TCShLibrary, N, Engine.Package, StartPos));
  Module :=PP;
  HasFinished:=true;
  FCurModule:=Module;
  try
    if Assigned(Engine.Package) then
    begin
      Module.PackageName := Engine.Package.Name;
      Engine.Package.Modules.Add(Module);
    end;
    NextToken;
    if (CurToken<>tkSemicolon) then
        ParseExcTokenError(';');
    Section := TLibrarySection(CreateElement(TLibrarySection, '', CurModule));
    PP.LibrarySection := Section;
    ParseOptionalUsesList(Section);
    HasFinished:=Section.PendingUsedIntf=nil;
    if not HasFinished then
      exit;
    ParseDeclarations(Section);
    FinishedModule;
  finally
    if HasFinished then
      FCurModule:=nil; // clear module if there is an error or finished parsing
  end;
end;

procedure TCShParser.ParseOptionalUsesList(ASection: TCShSection);
// checks if next token is Uses keyword and reads the uses list
begin
  NextToken;
  CheckImplicitUsedUnits(ASection);
  if CurToken=tkUsing then
    ParseUsesList(ASection)
  else
    UngetToken;
  Engine.CheckPendingUsedInterface(ASection);
  if ASection.PendingUsedIntf<>nil then
    exit;
  Engine.FinishScope(stUsesClause,ASection);
end;

// Starts after the "implementation" token
procedure TCShParser.ParseImplementation;
var
  Section: TImplementationSection;
begin
  Section := TImplementationSection(CreateElement(TImplementationSection, '', CurModule));
  CurModule.ImplementationSection := Section;
  ParseOptionalUsesList(Section);
  if Section.PendingUsedIntf<>nil then
    exit;
  ParseDeclarations(Section);
end;

function TCShParser.GetProcTypeFromToken(tk: TToken; IsClass: Boolean
  ): TProcType;
begin
  Result:=ptProcedure;
  Case tk of
    tkVoid :
      if IsClass then
        Result:=ptClassProcedure
      else
        Result:=ptProcedure;
    tkInt,tkUint, tkByte, tkString:
      if IsClass then
        Result:=ptClassFunction
      else
        Result:=ptFunction;
    tkOperator:
      if IsClass then
        Result:=ptClassOperator
      else
        Result:=ptOperator;
  else
    ParseExc(nParserNotAProcToken,SParserNotAProcToken);
  end;
end;

procedure TCShParser.ParseDeclarations(Declarations: TCShDeclarations);
var
  HadTypeSection: boolean;
  CurBlock: TDeclType;

  procedure SetBlock(NewBlock: TDeclType);
  begin
    if CurBlock=NewBlock then exit;
    if CurBlock=declType then
      begin
      end;
    if NewBlock=declType then
      HadTypeSection:=true
    else if (NewBlock=declNone) and HadTypeSection then
      begin
      HadTypeSection:=false;
      Engine.FinishScope(stTypeSection,Declarations);
      end;
    CurBlock:=NewBlock;
    Scanner.SetForceCaret(NewBlock=declType);
  end;

var
  ConstEl: TCShConst;
  ResStrEl: TCShResString;
  TypeEl: TCShType;
  ClassEl: TCShClassType;
  List: TFPList;
  i,j: Integer;
  ExpEl: TCShExportSymbol;
  PropEl : TCShProperty;
  PT : TProcType;
  ok, MustBeGeneric: Boolean;
  Proc: TCShProcedure;
  CurEl: TCShElement;
begin
  CurBlock := declNone;
  HadTypeSection:=false;
  MustBeGeneric:=false;
  while True do
  begin
    if CurBlock in [DeclNone,declConst,declType,declVar] then
      Scanner.SetTokenOption(toOperatorToken)
    else
      Scanner.UnSetTokenOption(toOperatorToken);
    NextToken;
    Scanner.SkipGlobalSwitches:=true;
  //  writeln('TCShParser.ParseDeclarations Token=',CurTokenString,' ',CurToken, ' ',scanner.CurFilename);
    case CurToken of
    tkCurlyBraceClose:
      begin
      If (CurModule is TCShProgram) and (CurModule.InitializationSection=Nil) then
        ParseExcTokenError('begin');
      ExpectToken(tkDot);
      break;
      end;
  {  tkimplementation:
        begin
        If Not Engine.InterfaceOnly then
          begin
          If LogEvent(pleImplementation) then
            DoLog(mtInfo,nLogStartImplementation,SLogStartImplementation);
          SetBlock(declNone);
          ParseImplementation;
          end;
        break;
        end; }
    tkUsing:
      if Declarations is TCShSection then
        ParseExcTokenError(TokenInfos[tkCurlyBraceClose])
      else
        ParseExcSyntaxError;
    tkConst:
      SetBlock(declConst);
    tkVoid, tkOperator:
      begin
      SetBlock(declNone);
      SaveComments;
      pt:=GetProcTypeFromToken(CurToken);
      AddProcOrFunction(Declarations, ParseProcedureOrFunctionDecl(Declarations, pt, MustBeGeneric));
      end;
    tkClass:
      begin
      SetBlock(declNone);
      SaveComments;
      NextToken;
      CheckTokens([tkVoid,tkoperator]);
      pt:=GetProcTypeFromToken(CurToken,True);
      AddProcOrFunction(Declarations,ParseProcedureOrFunctionDecl(Declarations, pt, MustBeGeneric));
      end;
    tkIdentifier:
      begin
      Scanner.UnSetTokenOption(toOperatorToken);
      SaveComments;
      case CurBlock of
        declConst:
          begin
            ConstEl := ParseConstDecl(Declarations);
            Declarations.Declarations.Add(ConstEl);
            Declarations.Consts.Add(ConstEl);
            Engine.FinishScope(stDeclaration,ConstEl);
          end;
        declResourcestring:
          begin
            ResStrEl := ParseResourcestringDecl(Declarations);
            Declarations.Declarations.Add(ResStrEl);
            Declarations.ResStrings.Add(ResStrEl);
            Engine.FinishScope(stResourceString,ResStrEl);
          end;
        declType:
          begin
          TypeEl := ParseTypeDecl(Declarations);
          // Scanner.SetForceCaret(OldForceCaret); // It may have been switched off
          if Assigned(TypeEl) then        // !!!
            begin
            Declarations.Declarations.Add(TypeEl);
            {$IFDEF CheckCShTreeRefCount}if TypeEl.RefIds.IndexOf('CreateElement')>=0 then TypeEl.ChangeRefId('CreateElement','TCShDeclarations.Children');{$ENDIF}
            if (TypeEl.ClassType = TCShClassType)
                and (not (po_keepclassforward in Options)) then
            begin
              // Remove previous forward declarations, if necessary
              for i := 0 to Declarations.Classes.Count - 1 do
              begin
                ClassEl := TCShClassType(Declarations.Classes[i]);
                if CompareText(ClassEl.Name, TypeEl.Name) = 0 then
                begin
                  Declarations.Classes.Delete(i);
                  for j := 0 to Declarations.Declarations.Count - 1 do
                    if CompareText(TypeEl.Name,
                      TCShElement(Declarations.Declarations[j]).Name) = 0 then
                    begin
                      Declarations.Declarations.Delete(j);
                      break;
                    end;
                  ClassEl.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
                  break;
                end;
              end;
              // Add the new class to the class list
              Declarations.Classes.Add(TypeEl)
            end else
              Declarations.Types.Add(TypeEl);
            end;
          end;
        declExports:
          begin
          List := TFPList.Create;
          try
            ok:=false;
            try
              ParseExportDecl(Declarations, List);
              ok:=true;
            finally
              if not ok then
                for i := 0 to List.Count - 1 do
                  TCShExportSymbol(List[i]).Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
            end;
            for i := 0 to List.Count - 1 do
            begin
              ExpEl := TCShExportSymbol(List[i]);
              Declarations.Declarations.Add(ExpEl);
              {$IFDEF CheckCShTreeRefCount}ExpEl.ChangeRefId('CreateElement','TCShDeclarations.Children');{$ENDIF}
              Declarations.ExportSymbols.Add(ExpEl);
            end;
          finally
            List.Free;
          end;
          end;
        declVar, declThreadVar:
          begin
            List := TFPList.Create;
            try
              ParseVarDecl(Declarations, List);
              for i := 0 to List.Count - 1 do
              begin
                CurEl := TCShElement(List[i]);
                Declarations.Declarations.Add(CurEl);
                if CurEl.ClassType=TCShAttributes then
                  Declarations.Attributes.Add(CurEl)
                else
                  Declarations.Variables.Add(TCShVariable(CurEl));
                Engine.FinishScope(stDeclaration,CurEl);
              end;
              CheckToken(tkSemicolon);
            finally
              List.Free;
            end;
          end;
        declProperty:
          begin
          PropEl:=ParseProperty(Declarations,CurtokenString,visDefault,false);
          Declarations.Declarations.Add(PropEl);
          {$IFDEF CheckCShTreeRefCount}PropEl.ChangeRefId('CreateElement','TCShDeclarations.Children');{$ENDIF}
          Declarations.Properties.Add(PropEl);
          Engine.FinishScope(stDeclaration,PropEl);
          end;
      else
        ParseExcSyntaxError;
      end;
      end;
    tkCurlyBraceOpen:
      begin
      if Declarations is TProcedureBody then
        begin
        Proc:=Declarations.Parent as TCShProcedure;
        SetBlock(declNone);
        ParseProcBeginBlock(TProcedureBody(Declarations));
        break;
        end
      else if  (Declarations is TImplementationSection) then
        begin
        SetBlock(declNone);
        break;
        end
      else
        ParseExcSyntaxError;
      end;
    tkSquaredBraceOpen:
     { if true {Attributes}then
        ParseAttributes(Declarations,true)
      else    }
        ParseExcSyntaxError;
    else
      ParseExcSyntaxError;
    end;
  end;
  SetBlock(declNone);
end;

function TCShParser.AddUseUnit(ASection: TCShSection;
  const NamePos: TCShSourcePos; AUnitName: string; NameExpr: TCShExpr;
  InFileExpr: TPrimitiveExpr): TCShUsingNamespace;

  procedure CheckDuplicateInUsesList(UsesClause: TCShUsesClause);
  var
    i: Integer;
  begin
    if UsesClause=nil then exit;
    for i:=0 to length(UsesClause)-1 do
      if CompareText(AUnitName,UsesClause[i].Name)=0 then
        ParseExc(nParserDuplicateIdentifier,SParserDuplicateIdentifier,[AUnitName]);
  end;

var
  UnitRef: TCShElement;
  UsesUnit: TCShUsingNamespace;
begin
  Result:=nil;
  UsesUnit:=nil;
  UnitRef:=nil;
  try
    {$IFDEF VerboseCShParser}
    writeln('TCShParser.AddUseUnit AUnitName=',AUnitName,' CurModule.Name=',CurModule.Name);
    {$ENDIF}
    if CompareText(AUnitName,CurModule.Name)=0 then
      begin
      if CompareText(AUnitName,'System')=0 then
        exit; // for compatibility ignore implicit use of system in system
      ParseExc(nParserDuplicateIdentifier,SParserDuplicateIdentifier,[AUnitName]);
      end;

    // Note: The alias (AUnitName) must be unique within a module.
    //       Using an unit module twice with different alias is allowed.
    CheckDuplicateInUsesList(ASection.UsesClause);
 {   if ASection.ClassType=TImplementationSection then
      CheckDuplicateInUsesList(CurModule.InterfaceSection.UsesClause);
    }
    UnitRef := Engine.FindModule(AUnitName,NameExpr,InFileExpr);
    if Assigned(UnitRef) then
      UnitRef.AddRef{$IFDEF CheckCShTreeRefCount}('TCShUsingNamespace.Module'){$ENDIF}
    else
      UnitRef := TCShUnresolvedUnitRef(CreateElement(TCShUnresolvedUnitRef,
        AUnitName, ASection, NamePos));

    UsesUnit:=TCShUsingNamespace(CreateElement(TCShUsingNamespace,AUnitName,ASection,NamePos));
    Result:=ASection.AddUnitToUsesList(AUnitName,NameExpr,InFileExpr,UnitRef,UsesUnit);
    if InFileExpr<>nil then
      begin
      if UnitRef is TCShModule then
        begin
        if TCShModule(UnitRef).Filename='' then
          TCShModule(UnitRef).Filename:=InFileExpr.Value;
        end
      else if UnitRef is TCShUnresolvedUnitRef then
        TCShUnresolvedUnitRef(UnitRef).FileName:=InFileExpr.Value;
      end;
  finally
    if Result=nil then
      begin
      if UsesUnit<>nil then
        UsesUnit.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      if NameExpr<>nil then
        NameExpr.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      if InFileExpr<>nil then
        InFileExpr.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      if UnitRef<>nil then
        UnitRef.Release{$IFDEF CheckCShTreeRefCount}('FindModule'){$ENDIF};
      end;
  end;
end;

procedure TCShParser.CheckImplicitUsedUnits(ASection: TCShSection);
var
  i: Integer;
  NamePos: TCShSourcePos;
begin
  If not (ASection.ClassType=TImplementationSection) Then // interface,program,library,package
    begin
    // load implicit units, like 'System'
    NamePos:=CurSourcePos;
    for i:=0 to ImplicitUses.Count-1 do
      AddUseUnit(ASection,NamePos,ImplicitUses[i],nil,nil);
    end;
end;

procedure TCShParser.FinishedModule;
begin
  if Scanner<>nil then
    Scanner.FinishedModule;
  Engine.FinishScope(stModule,CurModule);
end;

// Starts after the "uses" token
procedure TCShParser.ParseUsesList(ASection: TCShSection);
var
  AUnitName, aName: String;
  NameExpr: TCShExpr;
  InFileExpr: TPrimitiveExpr;
  FreeExpr: Boolean;
  NamePos, SrcPos: TCShSourcePos;
  aModule: TCShModule;
begin
  Scanner.SkipGlobalSwitches:=true;
  NameExpr:=nil;
  InFileExpr:=nil;
  FreeExpr:=true;
  try
    Repeat
      FreeExpr:=true;
      AUnitName := ExpectIdentifier;
      NamePos:=CurSourcePos;
      NameExpr:=CreatePrimitiveExpr(ASection,pekString,AUnitName);
      NextToken;
      while CurToken = tkDot do
      begin
        SrcPos:=CurTokenPos;
        ExpectIdentifier;
        aName:=CurTokenString;
        AUnitName := AUnitName + '.' + aName;
        AddToBinaryExprChain(NameExpr,
              CreatePrimitiveExpr(ASection,pekString,aName),eopSubIdent,SrcPos);
        NextToken;
      end;
      if (CurToken=tkin) then
        begin
        if (true {delphi}) then
          begin
          aModule:=ASection.GetModule;
          if (aModule<>nil)
              and ((aModule.ClassType=TCShModule) or (true {UnitModule})) then
            CheckToken(tkSemicolon); // delphi does not allow in-filename in units
          end;
        ExpectToken(tkString);
        InFileExpr:=CreatePrimitiveExpr(ASection,pekString,CurTokenString);
        NextToken;
        end;
      FreeExpr:=false;
      AddUseUnit(ASection,NamePos,AUnitName,NameExpr,InFileExpr);
      InFileExpr:=nil;
      NameExpr:=nil;

      if Not (CurToken in [tkComma,tkSemicolon]) then
        ParseExc(nParserExpectedCommaSemicolon,SParserExpectedCommaSemicolon);
    Until (CurToken=tkSemicolon);
  finally
    if FreeExpr then
      begin
      ReleaseAndNil(TCShElement(NameExpr){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
      ReleaseAndNil(TCShElement(InFileExpr){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
      end;
  end;
end;

// Starts after the variable name
function TCShParser.ParseConstDecl(Parent: TCShElement): TCShConst;
var
  OldForceCaret,ok: Boolean;
begin
  SaveComments;
  Result := TCShConst(CreateElement(TCShConst, CurTokenString, Parent));
  if Parent is TCShMembersType then
    Include(Result.VarModifiers,vmClass);
  ok:=false;
  try
    NextToken;
    if CurToken = tkColon then
      begin
      if not (bsWriteableConst in Scanner.CurrentBoolSwitches) then
        Result.IsConst:=true;
      OldForceCaret:=Scanner.SetForceCaret(True);
      try
        Result.VarType := ParseType(Result,CurSourcePos);
        {$IFDEF CheckCShTreeRefCount}if Result.VarType.RefIds.IndexOf('CreateElement')>=0 then Result.VarType.ChangeRefId('CreateElement','TCShVariable.VarType'){$ENDIF};
      finally
        Scanner.SetForceCaret(OldForceCaret);
      end;
      end
    else
      begin
      UngetToken;
      Result.IsConst:=true;
      end;
    NextToken;
    if CurToken=tkEqual then
      begin
      NextToken;
      Result.Expr:=DoParseConstValueExpression(Result);
      if (Result.VarType=Nil) and (Result.Expr.Kind=pekRange) then
        ParseExc(nParserNoConstRangeAllowed,SParserNoConstRangeAllowed);
      end
    else if (Result.VarType<>nil)
        and (po_ExtConstWithoutExpr in Options) then
      begin
      if (Parent is TCShClassType)
          and TCShClassType(Parent).IsExternal
          and (TCShClassType(Parent).ObjKind=okClass) then
        // typed const without expression is allowed in external class
        Result.IsConst:=true
      else if CurToken=tkSemicolon then
        begin
        NextToken;
        if CurTokenIsIdentifier('external') then
          begin
          // typed external const without expression is allowed
          Result.IsConst:=true;
          Include(Result.VarModifiers,vmExternal);
          NextToken;
          if CurToken in [tkString,tkIdentifier] then
            begin
            // external LibraryName;
            // external LibraryName name ExportName;
            // external name ExportName;
            if not CurTokenIsIdentifier('name') then
              Result.LibraryName:=DoParseExpression(Result);
            if not CurTokenIsIdentifier('name') then
              ParseExcSyntaxError;
            NextToken;
            if not (CurToken in [tkChar,tkString,tkIdentifier]) then
              ParseExcTokenError(TokenInfos[tkString]);
            Result.ExportName:=DoParseExpression(Result);
            Result.IsConst:=true; // external const is readonly
            end
          else if CurToken=tkSemicolon then
            // external;
          else
            ParseExcSyntaxError;
          end
        else
          begin
          UngetToken;
          CheckToken(tkEqual);
          end;
        end
      else
        CheckToken(tkEqual);
      end
    else
      CheckToken(tkEqual);
    UngetToken;
    CheckHint(Result,not (Parent is TCShMembersType));
    ok:=true;
  finally
    if not ok then
      ReleaseAndNil(TCShElement(Result){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
  end;
end;

// Starts after the variable name
function TCShParser.ParseResourcestringDecl(Parent: TCShElement): TCShResString;
var
  ok: Boolean;
begin
  SaveComments;
  Result := TCShResString(CreateElement(TCShResString, CurTokenString, Parent));
  ok:=false;
  try
    ExpectToken(tkEqual);
    NextToken; // skip tkEqual
    Result.Expr:=DoParseConstValueExpression(Result);
    UngetToken;
    CheckHint(Result,True);
    ok:=true;
  finally
    if not ok then
      ReleaseAndNil(TCShElement(Result){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
  end;
end;

function TCShParser.ParseAttributes(Parent: TCShElement; Add: boolean
  ): TCShAttributes;
// returns with CurToken at tkSquaredBraceClose
var
  Expr, Arg: TCShExpr;
  Attributes: TCShAttributes;
  Params: TParamsExpr;
  Decls: TCShDeclarations;
begin
  Result:=nil;
  Attributes:=TCShAttributes(CreateElement(TCShAttributes,'',Parent));
  try
    repeat
      NextToken;
      // [name,name(param,param,...),...]
      Expr:=nil;
      ReadDottedIdentifier(Attributes,Expr,false);
      if CurToken=tkBraceOpen then
        begin
        Params:=TParamsExpr(CreateElement(TParamsExpr,'',Attributes));
        Params.Kind:=pekFuncParams;
        Attributes.AddCall(Params);
        Params.Value:=Expr;
        Expr.Parent:=Params;
        Expr:=nil;
        repeat
          NextToken;
          if CurToken=tkBraceClose then
            break;
          Arg:=DoParseConstValueExpression(Params);
          Params.AddParam(Arg);
        until CurToken<>tkComma;
        CheckToken(tkBraceClose);
        NextToken;
        end
      else
        begin
        Attributes.AddCall(Expr);
        Expr:=nil;
        end;
    until CurToken<>tkComma;
    CheckToken(tkSquaredBraceClose);
    Result:=Attributes;
    if Add then
      begin
      if Parent is TCShDeclarations then
        begin
        Decls:=TCShDeclarations(Parent);
        Decls.Declarations.Add(Result);
        Decls.Attributes.Add(Result);
        end
      else if Parent is TCShMembersType then
        TCShMembersType(Parent).Members.Add(Result)
      else
        ParseExcTokenError('[20190922193803]');
      Engine.FinishScope(stDeclaration,Result);
      end;
  finally
    if Result=nil then
      begin
      Attributes.Free;
      Expr.Free;
      end;
  end;
end;

{$warn 5043 off}
procedure TCShParser.ReadGenericArguments(List: TFPList; Parent: TCShElement);
Var
  N : String;
  T : TCShGenericTemplateType;
  Expr: TCShExpr;
  TypeEl: TCShType;
begin
  ExpectToken(tkLessThan);
  repeat
    N:=ExpectIdentifier;
    T:=TCShGenericTemplateType(CreateElement(TCShGenericTemplateType,N,Parent));
    List.Add(T);
    NextToken;
    if Curtoken = tkColon then
      repeat
        NextToken;
        // comma separated list of constraints: identifier, class, record, constructor
        case CurToken of
        tkclass,tkStruct:
          begin
          if T.TypeConstraint='' then
            T.TypeConstraint:=CurTokenString;
          Expr:=CreatePrimitiveExpr(T,pekIdent,CurTokenText);
          T.AddConstraint(Expr);
          NextToken;
          end;
        tkIdentifier:
          begin
          TypeEl:=ParseTypeReference(T,false,Expr);
          if T.TypeConstraint='' then
            T.TypeConstraint:=TypeEl.Name;
          if (Expr<>nil) and (Expr.Parent=T) then
            Expr.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
          T.AddConstraint(TypeEl);
          end;
        else
          CheckToken(tkIdentifier);
        end;
      until CurToken<>tkComma;
    Engine.FinishScope(stTypeDef,T);
  until not (CurToken in [tkSemicolon,tkComma]);
  if CurToken<>tkGreaterThan then
    ParseExcExpectedAorB(TokenInfos[tkComma], TokenInfos[tkGreaterThan]);
end;
{$warn 5043 on}

procedure TCShParser.ReadSpecializeArguments(Parent: TCShElement;
  Params: TFPList);
// after parsing CurToken is on tkGreaterThan
Var
  TypeEl: TCShType;
begin
  //writeln('START TCShParser.ReadSpecializeArguments ',CurTokenText,' ',CurTokenString);
  CheckToken(tkLessThan);
  repeat
    //writeln('ARG TCShParser.ReadSpecializeArguments ',CurTokenText,' ',CurTokenString);
    TypeEl:=ParseType(Parent,CurTokenPos,'');
    Params.Add(TypeEl);
    NextToken;
    if CurToken=tkComma then
      continue
    else if CurToken=tkshr then
      begin
      ChangeToken(tkGreaterThan);
      break;
      end
    else if CurToken=tkGreaterThan then
      break
    else
      ParseExcExpectedAorB(TokenInfos[tkComma], TokenInfos[tkGreaterThan]);
  until false;
end;

function TCShParser.ReadDottedIdentifier(Parent: TCShElement; out
  Expr: TCShExpr; NeedAsString: boolean): String;
var
  SrcPos: TCShSourcePos;
begin
  Expr:=nil;
  if NeedAsString then
    Result := CurTokenString
  else
    Result:='';
  CheckToken(tkIdentifier);
  Expr:=CreatePrimitiveExpr(Parent,pekIdent,CurTokenString);
  NextToken;
  while CurToken=tkDot do
    begin
    SrcPos:=CurTokenPos;
    ExpectIdentifier;
    if NeedAsString then
      Result := Result+'.'+CurTokenString;
    AddToBinaryExprChain(Expr,CreatePrimitiveExpr(Parent,pekIdent,CurTokenString),
                         eopSubIdent,SrcPos);
    NextToken;
    end;
end;

// Starts after the type name
function TCShParser.ParseRangeType(AParent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String; Full: Boolean
  ): TCShRangeType;

Var
  PE : TCShExpr;
  ok: Boolean;

begin
  Result := TCShRangeType(CreateElement(TCShRangeType, TypeName, AParent, NamePos));
  ok:=false;
  try
    if Full then
      begin
      If not (CurToken=tkEqual) then
        ParseExcTokenError(TokenInfos[tkEqual]);
      end;
    NextToken;
    PE:=DoParseExpression(Result,Nil,False);
    if not ((PE is TBinaryExpr) and (TBinaryExpr(PE).Kind=pekRange)) then
      begin
      PE.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      ParseExc(nRangeExpressionExpected,SRangeExpressionExpected);
      end;
    Result.RangeExpr:=TBinaryExpr(PE);
    UngetToken;
    Engine.FinishScope(stTypeDef,Result);
    ok:=true;
  finally
    if not ok then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

// Starts after Exports, on first identifier.
procedure TCShParser.ParseExportDecl(Parent: TCShElement; List: TFPList);
Var
  E : TCShExportSymbol;
begin
  Repeat
    if List.Count<>0 then
      ExpectIdentifier;
    E:=TCShExportSymbol(CreateElement(TCShExportSymbol,CurtokenString,Parent));
    List.Add(E);
    NextToken;
    if CurTokenIsIdentifier('INDEX') then
      begin
      NextToken;
      E.Exportindex:=DoParseExpression(E,Nil)
      end
    else if CurTokenIsIdentifier('NAME') then
      begin
      NextToken;
      E.ExportName:=DoParseExpression(E,Nil)
      end;
    if not (CurToken in [tkComma,tkSemicolon]) then
      ParseExc(nParserExpectedCommaSemicolon,SParserExpectedCommaSemicolon);
  until (CurToken=tkSemicolon);
end;

function TCShParser.ParseProcedureType(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: String; const PT: TProcType
  ): TCShProcedureType;

var
  ok: Boolean;
begin
  if PT in [ptFunction,ptClassFunction] then
    Result := CreateFunctionType(TypeName, 'Result', Parent, False, NamePos)
  else
    Result := TCShProcedureType(CreateElement(TCShProcedureType, TypeName, Parent, NamePos));
  ok:=false;
  try
    ParseProcedureOrFunction(Result, TCShProcedureType(Result), PT, True);
    ok:=true;
  finally
    if not ok then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.ParseTypeDecl(Parent: TCShElement): TCShType;
var
  TypeName: String;
  NamePos: TCShSourcePos;
  OldForceCaret , IsDelphiGenericType: Boolean;
begin
  OldForceCaret:=Scanner.SetForceCaret(True);
  try
    IsDelphiGenericType:=false;
    if (true {delphi}) then
      begin
      NextToken;
      IsDelphiGenericType:=CurToken=tkLessThan;
      UngetToken;
      end;
    if IsDelphiGenericType then
      Result:=ParseGenericTypeDecl(Parent,false)
    else
      begin
      TypeName := CurTokenString;
      NamePos:=CurSourcePos;
      ExpectToken(tkEqual);
      Result:=ParseType(Parent,NamePos,TypeName,True);
      end;
  finally
    Scanner.SetForceCaret(OldForceCaret);
  end;
end;

function TCShParser.ParseGenericTypeDecl(Parent: TCShElement;
  AddToParent: boolean): TCShGenericType;

  procedure InitGenericType(NewEl: TCShGenericType; GenericTemplateTypes: TFPList);
  begin
    ParseGenericTypeDecl:=NewEl;
    if AddToParent then
      begin
      if Parent is TCShDeclarations then
        begin
        TCShDeclarations(Parent).Declarations.Add(NewEl);
        {$IFDEF CheckCShTreeRefCount}NewEl.ChangeRefId('CreateElement','TCShDeclarations.Children');{$ENDIF}
        end
      else if Parent is TCShMembersType then
        begin
        TCShMembersType(Parent).Members.Add(NewEl);
        {$IFDEF CheckCShTreeRefCount}NewEl.ChangeRefId('CreateElement','TCShMembersType.Members');{$ENDIF}
        end;
      end;
    if GenericTemplateTypes.Count>0 then
      begin
      // Note: TCShResolver sets GenericTemplateTypes already in CreateElement
      //       This is for other tools like fpdoc.
      NewEl.SetGenericTemplates(GenericTemplateTypes);
      end;
  end;

  procedure ParseProcType(const TypeName: string;
    const NamePos: TCShSourcePos; TypeParams: TFPList;
    IsReferenceTo: boolean);
  var
    ProcTypeEl: TCShProcedureType;
    ProcType: TProcType;
  begin
    ProcTypeEl:=Nil;
    ProcType:=ptProcedure;
    case CurToken of
{    tkFunction:
      begin
      ProcTypeEl := CreateFunctionType(TypeName, 'Result', Parent, False,
                                       NamePos, TypeParams);
      ProcType:=ptFunction;
      end;  }
    tkVoid:
      begin
      ProcTypeEl := TCShProcedureType(CreateElement(TCShProcedureType,
                          TypeName, Parent, visDefault, NamePos, TypeParams));
      ProcType:=ptProcedure;
      end;
    else
      ParseExcTokenError('procedure or function');
    end;
    ProcTypeEl.IsReferenceTo:=IsReferenceTo;
    if AddToParent and (Parent is TCShDeclarations) then
      TCShDeclarations(Parent).Functions.Add(ProcTypeEl);
    InitGenericType(ProcTypeEl,TypeParams);
    ParseProcedureOrFunction(ProcTypeEl, ProcTypeEl, ProcType, True);
  end;

var
  TypeName, AExternalNameSpace, AExternalName: String;
  NamePos: TCShSourcePos;
  TypeParams: TFPList;
  ClassEl: TCShClassType;
  RecordEl: TCShRecordType;
  ArrEl: TCShArrayType;
  i: Integer;
  AObjKind: TCShObjKind;
  ok: Boolean;
  GenTempl: TCShGenericTemplateType;
begin
  Result:=nil;
  ok := false;
  TypeName := CurTokenString;
  NamePos := CurSourcePos;
  TypeParams:=TFPList.Create;
  try
    ReadGenericArguments(TypeParams,Parent);
    ExpectToken(tkEqual);
    NextToken;
    Case CurToken of
      tkObject,
      tkClass,
      tkinterface:
        begin
        case CurToken of
        tkobject: AObjKind:=okObject;
        tkinterface: AObjKind:=okInterface;
        else AObjKind:=okClass;
        end;
        NextToken;
{        if (AObjKind = okClass) and (CurToken = tkOf) then
          ParseExcExpectedIdentifier; }
        DoParseClassExternalHeader(AObjKind,AExternalNameSpace,AExternalName);
        ClassEl := TCShClassType(CreateElement(TCShClassType,
          TypeName, Parent, visDefault, NamePos, TypeParams));
        ClassEl.ObjKind:=AObjKind;
        if AObjKind=okInterface then
          if SameText(Scanner.CurrentValueSwitch[vsInterfaces],'CORBA') then
            ClassEl.InterfaceType:=citCorba;
        if AddToParent and (Parent is TCShDeclarations) then
          TCShDeclarations(Parent).Classes.Add(ClassEl);
        ClassEl.IsExternal:=(AExternalName<>'');
        if AExternalName<>'' then
          ClassEl.ExternalName:={$ifdef pas2js}DeQuoteString{$else}AnsiDequotedStr{$endif}(AExternalName,'''');
        if AExternalNameSpace<>'' then
          ClassEl.ExternalNameSpace:={$ifdef pas2js}DeQuoteString{$else}AnsiDequotedStr{$endif}(AExternalNameSpace,'''');
        InitGenericType(ClassEl,TypeParams);
        DoParseClassType(ClassEl);
        CheckHint(ClassEl,True);
        Engine.FinishScope(stTypeDef,ClassEl);
        end;
     tkStruct:
       begin
       RecordEl := TCShRecordType(CreateElement(TCShRecordType,
         TypeName, Parent, visDefault, NamePos, TypeParams));
       if AddToParent and (Parent is TCShDeclarations) then
         TCShDeclarations(Parent).Classes.Add(RecordEl);
       InitGenericType(RecordEl,TypeParams);
       NextToken;
       ParseRecordMembers(RecordEl,tkCurlyBraceClose,
                        (true)
                        and not (Parent is TProcedureBody)
                        and (RecordEl.Name<>''));
       CheckHint(RecordEl,True);
       Engine.FinishScope(stTypeDef,RecordEl);
       end;
{     tkArray:
       begin
       ArrEl := TCShArrayType(CreateElement(TCShArrayType,
         TypeName, Parent, visDefault, NamePos, TypeParams));
       if AddToParent and (Parent is TCShDeclarations) then
         TCShDeclarations(Parent).Types.Add(ArrEl);
       InitGenericType(ArrEl,TypeParams);
       DoParseArrayType(ArrEl);
       CheckHint(ArrEl,True);
       Engine.FinishScope(stTypeDef,ArrEl);
       end;  }
    tkVoid:
      ParseProcType(TypeName,NamePos,TypeParams,false);
    tkIdentifier:
        ParseExcTypeParamsNotAllowed;
    else
      ParseExcTypeParamsNotAllowed;
    end;
    ok:=true;
  finally
    if (not ok) and (Result<>nil) and not AddToParent then
      Result.Release({$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF});
    for i:=0 to TypeParams.Count-1 do
      begin
      GenTempl:=TCShGenericTemplateType(TypeParams[i]);
      GenTempl.Parent:=nil;
      GenTempl.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      end;
    TypeParams.Free;
  end;
end;

function TCShParser.GetVariableModifiers(Parent: TCShElement; out
  VarMods: TVariableModifiers; out LibName, ExportName: TCShExpr;
  const AllowedMods: TVariableModifiers): string;

Var
  S : String;
  ExtMod: TVariableModifier;
begin
  Result := '';
  LibName := nil;
  ExportName := nil;
  VarMods := [];
  NextToken;
  If (vmCVar in AllowedMods) and CurTokenIsIdentifier('cvar') then
    begin
    Result:=';cvar';
    Include(VarMods,vmcvar);
    ExpectToken(tkSemicolon);
    NextToken;
    end;
  s:=LowerCase(CurTokenText);
  if (vmExternal in AllowedMods) and (s='external') then
    ExtMod:=vmExternal
  else if (vmPublic in AllowedMods) and (s='public') then
    ExtMod:=vmPublic
  else if (vmExport in AllowedMods) and (s='export') then
    ExtMod:=vmExport
  else
    begin
    UngetToken;
    exit;
    end;
  Include(VarMods,ExtMod);
  Result:=Result+';'+CurTokenText;

  NextToken;
  if not (CurToken in [tkString,tkIdentifier]) then
    begin
    if (CurToken=tkSemicolon) and (ExtMod in [vmExternal,vmPublic]) then
      exit;
    ParseExcSyntaxError;
    end;
  // export name exportname;
  // public;
  // public name exportname;
  // external;
  // external libname;
  // external libname name exportname;
  // external name exportname;
  if (ExtMod=vmExternal) and (CurToken in [tkString,tkIdentifier])
      and Not (CurTokenIsIdentifier('name')) then
    begin
    Result := Result + ' ' + CurTokenText;
    LibName:=DoParseExpression(Parent);
    end;
  if not CurTokenIsIdentifier('name') then
    ParseExcSyntaxError;
  NextToken;
  if not (CurToken in [tkChar,tkString,tkIdentifier]) then
    ParseExcTokenError(TokenInfos[tkString]);
  Result := Result + ' ' + CurTokenText;
  ExportName:=DoParseExpression(Parent);
end;


// Full means that a full variable declaration is being parsed.
procedure TCShParser.ParseVarList(Parent: TCShElement; VarList: TFPList;
  AVisibility: TCShMemberVisibility; Full : Boolean);
// on Exception the VarList is restored, no need to Release the new elements

var
  i, OldListCount: Integer;
  Value , aLibName, aExpName, AbsoluteExpr: TCShExpr;
  VarType: TCShType;
  VarEl: TCShVariable;
  H : TCShMemberHints;
  VarMods, AllowedVarMods: TVariableModifiers;
  D,Mods,AbsoluteLocString: string;
  OldForceCaret,ok,ExternalStruct: Boolean;

begin
  Value:=Nil;
  aLibName:=nil;
  aExpName:=nil;
  AbsoluteExpr:=nil;
  AbsoluteLocString:='';
  OldListCount:=VarList.Count;
  ok:=false;
  try
    D:=SaveComments; // This means we support only one comment per 'list'.
    VarEl:=nil;
    while CurToken=tkSquaredBraceOpen do
      begin
      if true {Attributes}then
        begin
        VarList.Add(ParseAttributes(Parent,false));
        NextToken;
        end
      else
        CheckToken(tkIdentifier);
      end;
    Repeat
      // create the TCShVariable here, so that SourceLineNumber is correct
      VarEl:=TCShVariable(CreateElement(TCShVariable,CurTokenString,Parent,
                                        AVisibility,CurTokenPos));
      VarList.Add(VarEl);
      NextToken;
      case CurToken of
      tkColon: break;
      tkComma: ExpectIdentifier;
      else
        ParseExc(nParserExpectedCommaColon,SParserExpectedCommaColon);
      end;
    Until (CurToken=tkColon);
    OldForceCaret:=Scanner.SetForceCaret(True);
    try
      VarType := ParseVarType(VarEl);
      {$IFDEF CheckCShTreeRefCount}if VarType.RefIds.IndexOf('CreateElement')>=0 then VarType.ChangeRefId('CreateElement','TCShVariable.VarType'){$ENDIF};
    finally
      Scanner.SetForceCaret(OldForceCaret);
    end;
    // read type
    for i := OldListCount to VarList.Count - 1 do
      begin
      VarEl:=TCShVariable(VarList[i]);
      // Writeln(VarEl.Name, AVisibility);
      VarEl.VarType := VarType;
      //VarType.Parent := VarEl; // this is wrong for references
      if (i>OldListCount) then
        VarType.AddRef{$IFDEF CheckCShTreeRefCount}('TCShVariable.VarType'){$ENDIF};
      end;

    H:=CheckHint(Nil,False);
    if (VarList.Count>OldListCount+1) then
      begin
      // multiple variables
      if Value<>nil then
        ParseExc(nParserOnlyOneVariableCanBeInitialized,SParserOnlyOneVariableCanBeInitialized);
      if AbsoluteExpr<>nil then
        ParseExc(nParserOnlyOneVariableCanBeAbsolute,SParserOnlyOneVariableCanBeAbsolute);
      end;
    TCShVariable(VarList[OldListCount]).Expr:=Value;
    Value:=nil;

    // Note: external members are allowed for non external classes/records too
    ExternalStruct:=(true {ExternalClass})
                    and (Parent is TCShMembersType);

    H:=H+CheckHint(Nil,False);
    if Full or ExternalStruct then
      begin
      NextToken;
      If Curtoken<>tkSemicolon then
        UnGetToken;
      VarEl:=TCShVariable(VarList[OldListCount]);
      AllowedVarMods:=[];
      if ExternalStruct then
        AllowedVarMods:=[vmExternal]
      else
        AllowedVarMods:=[vmCVar,vmExternal,vmPublic,vmExport];
      Mods:=GetVariableModifiers(VarEl,VarMods,aLibName,aExpName,AllowedVarMods);
      if (Mods='') and (CurToken<>tkSemicolon) then
        NextToken;
      end
    else
      begin
      NextToken;
      VarMods:=[];
      Mods:='';
      end;
    SaveComments(D);

    // connect
    for i := OldListCount to VarList.Count - 1 do
      begin
      VarEl:=TCShVariable(VarList[i]);
      // Writeln(VarEl.Name, AVisibility);
      // Procedure declaration eats the hints.
      if Assigned(VarType) and (VarType is TCShProcedureType) then
        VarEl.Hints:=VarType.Hints
      else
        VarEl.Hints:=H;
      VarEl.Modifiers:=Mods;
      VarEl.VarModifiers:=VarMods;
      VarEl.{%H-}AbsoluteLocation:=AbsoluteLocString;
      if AbsoluteExpr<>nil then
        begin
        VarEl.AbsoluteExpr:=AbsoluteExpr;
        AbsoluteExpr:=nil;
        end;
      if aLibName<>nil then
        begin
        VarEl.LibraryName:=aLibName;
        aLibName:=nil;
        end;
      if aExpName<>nil then
        begin
        VarEl.ExportName:=aExpName;
        aExpName:=nil;
        end;
      end;
    ok:=true;
  finally
    if not ok then
      begin
      if aLibName<>nil then aLibName.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      if aExpName<>nil then aExpName.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      if AbsoluteExpr<>nil then AbsoluteExpr.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      if Value<>nil then Value.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      for i:=OldListCount to VarList.Count-1 do
        TCShElement(VarList[i]).Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      VarList.Count:=OldListCount;
      end;
  end;
end;

procedure TCShParser.SetOptions(AValue: TCShOptions);
begin
  if FOptions=AValue then Exit;
  FOptions:=AValue;
  If Assigned(FScanner) then
    FScanner.Options:=AValue;
end;

procedure TCShParser.OnScannerModeChanged(Sender: TObject;
  NewMode: TModeSwitch; Before: boolean; var Handled: boolean);
begin
  Engine.ModeChanged(Self,NewMode,Before,Handled);
  if Sender=nil then ;
end;

function TCShParser.SaveComments: String;
begin
  if Engine.NeedComments then
    FSavedComments:=CurComments.Text; // Expensive, so don't do unless needed.
  Result:=FSavedComments;
end;

function TCShParser.SaveComments(const AValue: String): String;
begin
  FSavedComments:=AValue;
  Result:=FSavedComments;
end;

function TCShParser.LogEvent(E: TCShParserLogEvent): Boolean;
begin
  Result:=E in FLogEvents;
end;

procedure TCShParser.SetLastMsg(MsgType: TMessageType; MsgNumber: integer;
  const Fmt: String; Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif});
begin
  FLastMsgType := MsgType;
  FLastMsgNumber := MsgNumber;
  FLastMsgPattern := Fmt;
  FLastMsg := SafeFormat(Fmt,Args);
  CreateMsgArgs(FLastMsgArgs,Args);
end;

procedure TCShParser.DoLog(MsgType: TMessageType; MsgNumber: integer;
  const Msg: String; SkipSourceInfo: Boolean);
begin
  DoLog(MsgType,MsgNumber,Msg,[],SkipSourceInfo);
end;

procedure TCShParser.DoLog(MsgType: TMessageType; MsgNumber: integer;
  const Fmt: String; Args: array of {$ifdef pas2js}jsvalue{$else}const{$endif};
  SkipSourceInfo: Boolean);

Var
  Msg : String;

begin
  if (Scanner<>nil) and Scanner.IgnoreMsgType(MsgType) then
    exit;
  SetLastMsg(MsgType,MsgNumber,Fmt,Args);
  If Assigned(FOnLog) then
    begin
    Msg:=MessageTypeNames[MsgType]+': ';
    if SkipSourceInfo or not assigned(scanner) then
      Msg:=Msg+FLastMsg
    else
      Msg:=Msg+Format('%s(%d,%d) : %s',[Scanner.CurFilename,Scanner.CurRow,Scanner.CurColumn,FLastMsg]);
    FOnLog(Self,Msg);
    end;
end;

procedure TCShParser.ParseInlineVarDecl(Parent: TCShElement; List: TFPList;
  AVisibility: TCShMemberVisibility = VisDefault; ClosingBrace: Boolean = False);

Var
  tt : TTokens;
begin
  ParseVarList(Parent,List,AVisibility,False);
  tt:=[tkCurlyBraceClose,tkSemicolon];
  if ClosingBrace then
    Include(tt,tkBraceClose);
  if not (CurToken in tt) then
    ParseExc(nParserExpectedSemiColonEnd,SParserExpectedSemiColonEnd);
end;

// Starts after the variable name
procedure TCShParser.ParseVarDecl(Parent: TCShElement; List: TFPList);

begin
  ParseVarList(Parent,List,visDefault,True);
end;

// Starts after the opening bracket token
procedure TCShParser.ParseArgList(Parent: TCShElement; Args: TFPList; EndToken: TToken);
var
  IsUntyped, ok, LastHadDefaultValue: Boolean;
  Name : String;
  Value : TCShExpr;
  i, OldArgCount: Integer;
  Arg: TCShArgument;
  Access: TArgumentAccess;
  ArgType: TCShType;
begin
  LastHadDefaultValue := false;
  while True do
  begin
    OldArgCount:=Args.Count;
    Access := argDefault;
    IsUntyped := False;
    ArgType := nil;
    NextToken;
    if CurToken = tkConst then
    begin
      Access := argConst;
      Name := ExpectIdentifier;
    end else {if CurToken = tkConstRef then
    begin
      Access := argConstref;
      Name := ExpectIdentifier;
    end else} { if CurToken = tkVar then
    begin
      Access := ArgVar;
      Name := ExpectIdentifier;
    end else }if (CurToken = tkIdentifier) and (UpperCase(CurTokenString) = 'OUT') then
    begin
      Access := ArgOut;
      Name := ExpectIdentifier;
    end else if CurToken = tkIdentifier then
      Name := CurTokenString
    else
      ParseExc(nParserExpectedConstVarID,SParserExpectedConstVarID);
    while True do
    begin
      Arg := TCShArgument(CreateElement(TCShArgument, Name, Parent));
      Arg.Access := Access;
      Args.Add(Arg);
      NextToken;
      if CurToken = tkColon then
        break
      else if ((CurToken = tkSemicolon) or (CurToken = tkBraceClose)) and
        (Access <> argDefault) then
      begin
        // found an untyped const or var argument
        UngetToken;
        IsUntyped := True;
        break
      end
      else if CurToken <> tkComma then
        ParseExc(nParserExpectedCommaColon,SParserExpectedCommaColon);
      NextToken;
      if CurToken = tkIdentifier then
        Name := CurTokenString
      else
        ParseExc(nParserExpectedConstVarID,SParserExpectedConstVarID);
    end;
    Value:=Nil;
    if not IsUntyped then
      begin
      Arg := TCShArgument(Args[OldArgCount]);
      ArgType := ParseType(Arg,CurSourcePos);
      ok:=false;
      try
        NextToken;
        if CurToken = tkEqual then
          begin
          if (Args.Count>OldArgCount+1) then
            begin
            ArgType.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
            ArgType:=nil;
            ParseExc(nParserOnlyOneArgumentCanHaveDefault,SParserOnlyOneArgumentCanHaveDefault);
            end;
          if Parent is TCShProperty then
            ParseExc(nParserPropertyArgumentsCanNotHaveDefaultValues,
              SParserPropertyArgumentsCanNotHaveDefaultValues);
          NextToken;
          Value := DoParseExpression(Arg,Nil);
          // After this, we're on ), which must be unget.
          LastHadDefaultValue:=true;
          end
        else if LastHadDefaultValue then
          ParseExc(nParserDefaultParameterRequiredFor,
            SParserDefaultParameterRequiredFor,[TCShArgument(Args[OldArgCount]).Name]);
        UngetToken;
        ok:=true;
      finally
        if (not ok) and (ArgType<>nil) then
          ArgType.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      end;
      end;

    for i := OldArgCount to Args.Count - 1 do
    begin
      Arg := TCShArgument(Args[i]);
      Arg.ArgType := ArgType;
      if Assigned(ArgType) then
        begin
        if (i > OldArgCount) then
          ArgType.AddRef{$IFDEF CheckCShTreeRefCount}('TCShArgument.ArgType'){$ENDIF};
        end;
      Arg.ValueExpr := Value;
      Value:=Nil; // Only the first gets a value. OK, since Var A,B : Integer = 1 is not allowed.
    end;

    for i := OldArgCount to Args.Count - 1 do
      Engine.FinishScope(stDeclaration,TCShArgument(Args[i]));

    NextToken;
    if (CurToken = tkIdentifier) and (LowerCase(CurTokenString) = 'location') then
      begin
        NextToken; // remove 'location'
        NextToken; // remove register
      end;
    if CurToken = EndToken then
      break;
    CheckToken(tkSemicolon);
  end;
end;


function TCShParser.CheckProcedureArgs(Parent: TCShElement; Args: TFPList;
  ProcType: TProcType): boolean;

begin
  NextToken;
  if CurToken=tkBraceOpen then
    begin
    Result:=true;
    NextToken;
    if (CurToken<>tkBraceClose) then
      begin
      UngetToken;
      ParseArgList(Parent, Args, tkBraceClose);
      end;
    end
  else
    begin
    Result:=false;
    case ProcType of
    ptOperator,ptClassOperator:
      ParseExc(nParserExpectedLBracketColon,SParserExpectedLBracketColon);
    ptAnonymousProcedure,ptAnonymousFunction:
      case CurToken of
      tkIdentifier, // e.g. procedure assembler
      tkCurlyBraceOpen,tkconst,tkVoid:
        UngetToken;
      tkColon:
        if ProcType=ptAnonymousFunction then
          UngetToken
        else
          ParseExcTokenError('begin');
      else
        ParseExcTokenError('begin');
      end;
    else
      case CurToken of
        tkSemicolon, // e.g. procedure;
        tkColon, // e.g. function: id
        tkis, // e.g. procedure is nested
        tkIdentifier: // e.g. procedure cdecl;
          UngetToken;
      else
        ParseExcTokenError(';');
      end;
    end;
    end;
end;

procedure TCShParser.HandleProcedureModifier(Parent: TCShElement; pm: TProcedureModifier);
// at end on last token of modifier, usually the semicolon
Var
  P : TCShProcedure;
  E : TCShExpr;

  procedure AddModifier;
  begin
    if pm in P.Modifiers then
      ParseExcSyntaxError;
    P.AddModifier(pm);
  end;

begin
  P:=TCShProcedure(Parent);
  if pm<>pmPublic then
    AddModifier;
  Case pm of
  pmExternal:
    begin
    NextToken;
    if CurToken in [tkString,tkIdentifier] then
      begin
      // external libname
      // external libname name XYZ
      // external name XYZ
      if Not CurTokenIsIdentifier('NAME') then
        begin
        E:=DoParseExpression(Parent);
        if Assigned(P) then
          P.LibraryExpr:=E;
        end;
      if CurTokenIsIdentifier('NAME') then
        begin
        NextToken;
        if not (CurToken in [tkChar,tkString,tkIdentifier]) then
          ParseExcTokenError(TokenInfos[tkString]);
        E:=DoParseExpression(Parent);
        if Assigned(P) then
          P.LibrarySymbolName:=E;
        end;
      if CurToken<>tkSemicolon then
        UngetToken;
      end
    else
      UngetToken;
    end;
  pmPublic:
    begin
    NextToken;
    If not CurTokenIsIdentifier('name') then
      begin
      if P.Parent is TCShMembersType then
        begin
        // public section starts
        UngetToken;
        UngetToken;
        exit;
        end;
      AddModifier;
      CheckToken(tkSemicolon);
      exit;
      end
    else
      begin
      AddModifier;
      NextToken;  // Should be "public name string".
      if not (CurToken in [tkString,tkIdentifier]) then
        ParseExcTokenError(TokenInfos[tkString]);
      E:=DoParseExpression(Parent);
      if Parent is TCShProcedure then
        TCShProcedure(Parent).PublicName:=E;
      CheckToken(tkSemicolon);
      end;
    end;
  pmForward:
    begin
{    if (Parent.Parent is TInterfaceSection) then
       begin
       ParseExc(nParserForwardNotInterface,SParserForwardNotInterface);
       UngetToken;
       end;     }
    end;
  pmMessage:
    begin
    NextToken;
    E:=DoParseExpression(Parent);
    TCShProcedure(Parent).MessageExpr:=E;
    if E is TPrimitiveExpr then
      begin
      TCShProcedure(Parent).MessageName:=TPrimitiveExpr(E).Value;
      case E.Kind of
        pekNumber, pekUnary:
          TCShProcedure(Parent).Messagetype:=pmtInteger;
        pekString:
          TCShProcedure(Parent).Messagetype:=pmtString;
        pekIdent : ; // unknown at this time
      else
        ParseExc(nInvalidMessageType,SErrInvalidMessageType);
      end;
      end;
    if CurToken<>tkSemicolon then
      UngetToken;
    end;
  pmDispID:
    begin
    NextToken;
    TCShProcedure(Parent).DispIDExpr:=DoParseExpression(Parent);
    if CurToken<>tkSemicolon then
      UngetToken;
    end;
  else
    // Do nothing, satisfy compiler
  end; // Case
end;

procedure TCShParser.HandleProcedureTypeModifier(ProcType: TCShProcedureType;
  ptm: TProcTypeModifier);
var
  Expr: TCShExpr;
begin
  if ptm in ProcType.Modifiers then
    ParseExcSyntaxError;
  Include(ProcType.Modifiers,ptm);
  if ptm=ptmVarargs then
    begin
    NextToken;
    Expr:=nil;
    try
      ProcType.VarArgsType:=ParseTypeReference(ProcType,false,Expr);
    finally
      if Expr<>nil then Expr.Release{$IFDEF CheckCShTreeRefCount}('20191029145019'){$ENDIF};
    end;
    end;
end;

// Next token is expected to be a "(", ";" or for a function ":". The caller
// will get the token after the final ";" as next token.

function TCShParser.DoCheckHint(Element : TCShElement): Boolean;

var
  ahint : TCShMemberHint;

begin
  Result:= IsCurTokenHint(ahint);
  if Result then  // deprecated,platform,experimental,library, unimplemented etc
    begin
    Element.Hints:=Element.Hints+[ahint];
    if aHint=hDeprecated then
      begin
      NextToken;
      if (CurToken<>tkString) then
        UngetToken
      else
        Element.HintMessage:=CurTokenString;
      end;
    end;
end;

procedure TCShParser.ParseProcedureOrFunction(Parent: TCShElement;
  Element: TCShProcedureType; ProcType: TProcType; OfObjectPossible: Boolean);

  Function FindInSection(AName : String;ASection : TCShSection) : Boolean;

  Var
    I : integer;
    Cn,FN : String;
    CT : TCShClassType;

  begin
    I:=ASection.Functions.Count-1;
    While (I>=0) and (CompareText(TCShElement(ASection.Functions[I]).Name,AName)<>0) do
      Dec(I);
    Result:=I<>-1;
    I:=Pos('.',AName);
    if (Not Result) and (I>0) then
      begin
      CN:=Copy(AName,1,I-1);
      FN:=AName;
      Delete(FN,1,I);
      I:=ASection.Classes.Count-1;
      While Not Result and (I>=0) do
        begin
        CT:=TCShClassType(ASection.Classes[i]);
        if CompareText(CT.Name,CN)=0 then
          Result:=CT.FindMember(TCShFunction, FN)<>Nil;
        Dec(I);
        end;
      end;
  end;

  procedure ConsumeSemi;
  begin
    NextToken;
    if (CurToken <> tkSemicolon) and IsCurTokenHint then
      UngetToken;
  end;

Var
  Tok : String;
  CC : TCallingConvention;
  PM : TProcedureModifier;
  ResultEl: TCShResultElement;
  OK: Boolean;
  IsProcType: Boolean; // false = procedure, true = procedure type
  IsAnonymous: Boolean;
  PTM: TProcTypeModifier;
  ModTokenCount: Integer;
  LastToken: TToken;

begin
  // Element must be non-nil. Removed all checks for not-nil.
  // If it is nil, the following fails anyway.
  CheckProcedureArgs(Element,Element.Args,ProcType);
  IsProcType:=not (Parent is TCShProcedure);
  IsAnonymous:=(not IsProcType) and (ProcType in [ptAnonymousProcedure,ptAnonymousFunction]);
  case ProcType of
    ptFunction,ptClassFunction,ptAnonymousFunction:
      begin
      NextToken;
      if CurToken = tkColon then
        begin
        ResultEl:=TCShFunctionType(Element).ResultEl;
        ResultEl.ResultType := ParseType(ResultEl,CurSourcePos);
        end
      // In Delphi mode, the signature in the implementation section can be
      // without result as it was declared
      // We actually check if the function exists in the interface section.
      else if (not IsAnonymous)
          and (true {delphi})
          and (Assigned(CurModule.ImplementationSection)
            or (CurModule is TCShProgram))
          then
        begin
        OK:=False;
        if (CurModule is TCShProgram) and Assigned(TCShProgram(CurModule).ProgramSection) then
          OK:=FindInSection(Parent.Name,TCShProgram(CurModule).ProgramSection);
        if Not OK then
          CheckToken(tkColon)
        else
          begin
          CheckToken(tkSemiColon);
          UngetToken;
          end;
        end
      else
        begin
        // Raise error
        CheckToken(tkColon);
        end;
      end;
    ptOperator,ptClassOperator:
      begin
      NextToken;
      ResultEl:=TCShFunctionType(Element).ResultEl;
      if (CurToken=tkIdentifier) then
        begin
        ResultEl.Name := CurTokenName;
        ExpectToken(tkColon);
        end
      else
        if (CurToken=tkColon) then
          ResultEl.Name := 'Result'
        else
          ParseExc(nParserExpectedColonID,SParserExpectedColonID);
        ResultEl.ResultType := ParseType(ResultEl,CurSourcePos);
      end;
  else
    resultEl:=Nil;
  end;
  if OfObjectPossible then
    begin
    NextToken;
    if (CurToken = tkIs) then
      begin
      expectToken(tkIdentifier);
      if (lowerCase(CurTokenString)<>'nested') then
        ParseExc(nParserExpectedNested,SParserExpectedNested);
      Element.IsNested:=True;
      end
    else
      UnGetToken;
    end;
  ModTokenCount:=0;
  //writeln('TCShParser.ParseProcedureOrFunction IsProcType=',IsProcType,' IsAnonymous=',IsAnonymous);
  Repeat
    inc(ModTokenCount);
    //writeln('TCShParser.ParseProcedureOrFunction ',ModTokenCount,' ',CurToken,' ',CurTokenText);
    LastToken:=CurToken;
    NextToken;
    if (CurToken = tkEqual) and IsProcType and (ModTokenCount<=3) then
      begin
      // for example: const p: procedure = nil;
      UngetToken;
      Engine.FinishScope(stProcedureHeader,Element);
      exit;
      end;
    If CurToken=tkSemicolon then
      begin
      if IsAnonymous then
        CheckToken(tkCurlyBraceOpen); // begin expected, but ; found
      if LastToken=tkSemicolon then
        ParseExcSyntaxError;
      continue;
      end
    else if TokenIsCallingConvention(CurTokenString,cc) then
      begin
      Element.CallingConvention:=Cc;
      if cc = ccSysCall then
      begin
        // remove LibBase
        NextToken;
        if CurToken=tkSemiColon then
          UngetToken
        else
          // remove legacy or basesysv on MorphOS syscalls
          begin
          if CurTokenIsIdentifier('legacy') or CurTokenIsIdentifier('BaseSysV') then
            NextToken;
          NextToken; // remove offset
          end;
      end;
      if IsProcType then
        begin
        ExpectTokens([tkSemicolon,tkEqual]);
        if CurToken=tkEqual then
          UngetToken;
        end
      else if IsAnonymous then
      else
        ExpectTokens([tkSemicolon]);
      end
    else if IsAnonymous and TokenIsAnonymousProcedureModifier(Parent,CurTokenString,PM) then
      HandleProcedureModifier(Parent,PM)
    else if TokenIsProcedureTypeModifier(Parent,CurTokenString,PTM) then
      HandleProcedureTypeModifier(Element,PTM)
    else if (not IsProcType) and (not IsAnonymous)
        and TokenIsProcedureModifier(Parent,CurTokenString,PM) then
      HandleProcedureModifier(Parent,PM)
    else if (false {tkLIbrary}) and not IsProcType and not IsAnonymous then
      // library is a token and a directive.
      begin
      Tok:=UpperCase(CurTokenString);
      NextToken;
      If (tok<>'NAME') then
        begin
        if hLibrary in Element.Hints then
          ParseExcSyntaxError;
        Element.Hints:=Element.Hints+[hLibrary];
        end
      else
        begin
        NextToken;  // Should be "export name astring".
        ExpectToken(tkSemicolon);
        end;
      end
    else if (not IsAnonymous) and DoCheckHint(Element) then
      // deprecated,platform,experimental,library, unimplemented etc
      ConsumeSemi
    else if (CurToken=tkIdentifier) and (not IsAnonymous)
        and (CompareText(CurTokenText,'alias')=0) then
      begin
      ExpectToken(tkColon);
      ExpectToken(tkString);
      if (Parent is TCShProcedure) then
        (Parent as TCShProcedure).AliasName:=CurTokenText;
      ExpectToken(tkSemicolon);
      end
    else if (CurToken = tkSquaredBraceOpen) then
      begin
      if true {Attributes}then
        begin
        // [attribute]
        UngetToken;
        break;
        end
      else
        begin
        // ToDo: read FPC's [] modifiers, e.g. [public,alias:'']
        repeat
          NextToken;
          if CurToken in [tkSquaredBraceOpen,tkSemicolon] then
            CheckToken(tkSquaredBraceClose);
        until CurToken = tkSquaredBraceClose;
        ExpectToken(tkSemicolon);
        end;
      end
    else
      begin
      // not a modifier/hint/calling convention
      if LastToken=tkSemicolon then
        begin
        UngetToken;
        if IsAnonymous then
          ParseExcSyntaxError;
        break;
        end
      else if IsAnonymous then
        begin
        UngetToken;
        break;
        end
      else
        begin
        CheckToken(tkSemicolon);
        continue;
        end;
      end;
    // Writeln('Done: ',TokenInfos[Curtoken],' ',CurtokenString);
  Until false;
  if (ProcType in [ptOperator,ptClassOperator]) and (Parent is TCShOperator) then
    TCShOperator(Parent).CorrectName;
  Engine.FinishScope(stProcedureHeader,Element);
  if (not IsProcType)
  and (not TCShProcedure(Parent).IsForward)
  and (not TCShProcedure(Parent).IsExternal)
  and ((Parent.Parent is TImplementationSection)
     or (Parent.Parent is TProcedureBody)
     or IsAnonymous)
  then
    ParseProcedureBody(Parent);
end;

// starts after the semicolon
procedure TCShParser.ParseProcedureBody(Parent: TCShElement);

var
  Body: TProcedureBody;

begin
  Body := TProcedureBody(CreateElement(TProcedureBody, '', Parent));
  TCShProcedure(Parent).Body:=Body;
  ParseDeclarations(Body);
end;

function TCShParser.ParseMethodResolution(Parent: TCShElement
  ): TCShMethodResolution;
var
  ok: Boolean;
begin
  ok:=false;
  Result:=TCShMethodResolution(CreateElement(TCShMethodResolution,'',Parent));
  try
    if false {tkFunction} then
      Result.ProcClass:=TCShFunction
    else
      Result.ProcClass:=TCShProcedure;
    ExpectToken(tkIdentifier);
    Result.InterfaceName:=CreatePrimitiveExpr(Result,pekIdent,CurTokenString);
    ExpectToken(tkDot);
    ExpectToken(tkIdentifier);
    Result.InterfaceProc:=CreatePrimitiveExpr(Result,pekIdent,CurTokenString);
    ExpectToken(tkEqual);
    ExpectToken(tkIdentifier);
    Result.ImplementationProc:=CreatePrimitiveExpr(Result,pekIdent,CurTokenString);
    NextToken;
    if CurToken=tkSemicolon then
    else if CurToken=tkCurlyBraceClose then
      UngetToken
    else
      CheckToken(tkSemicolon);
    ok:=true;
  finally
    if not ok then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

function TCShParser.ParseProperty(Parent: TCShElement; const AName: String;
  AVisibility: TCShMemberVisibility; IsClassField: boolean): TCShProperty;

  function GetAccessorName(aParent: TCShElement; out Expr: TCShExpr): String;
  var
    Params: TParamsExpr;
    Param: TCShExpr;
    SrcPos: TCShSourcePos;
  begin
    NextToken;
    // read ident.subident...
    Result:=ReadDottedIdentifier(aParent,Expr,true);

    // read optional array index
    if CurToken <> tkSquaredBraceOpen then
      UnGetToken
    else
      begin
      Result := Result + '[';
      Param:=Nil;
      Params:=TParamsExpr(CreateElement(TParamsExpr,'',aParent));
      Params.Kind:=pekArrayParams;
      Params.Value:=Expr;
      Expr.Parent:=Params;
      Expr:=Params;
      NextToken;
      case CurToken of
        tkChar:             Param:=CreatePrimitiveExpr(aParent,pekString, CurTokenText);
        tkNumber:           Param:=CreatePrimitiveExpr(aParent,pekNumber, CurTokenString);
        tkIdentifier:       Param:=CreatePrimitiveExpr(aParent,pekIdent, CurTokenText);
        tkfalse, tktrue:    Param:=CreateBoolConstExpr(aParent,pekBoolConst, CurToken=tktrue);
      else
        ParseExcExpectedIdentifier;
      end;
      Params.AddParam(Param);
      Result := Result + CurTokenString;
      ExpectToken(tkSquaredBraceClose);
      Result := Result + ']';
      end;
    repeat
      NextToken;
      if CurToken <> tkDot then
        begin
        UngetToken;
        break;
        end;
      SrcPos:=CurTokenPos;
      ExpectIdentifier;
      Result := Result + '.' + CurTokenString;
      AddToBinaryExprChain(Expr,CreatePrimitiveExpr(aParent,pekIdent,CurTokenString),
                           eopSubIdent,SrcPos);
    until false;
  end;

  procedure ParseImplements;
  var
    Identifier: String;
    Expr: TCShExpr;
    l: Integer;
  begin
    // comma list of identifiers
    repeat
      ExpectToken(tkIdentifier);
      l:=length(Result.Implements);
      Identifier:=ReadDottedIdentifier(Result,Expr,l=0);
      if l=0 then
        Result.ImplementsName := Identifier;
      SetLength(Result.Implements,l+1);
      Result.Implements[l]:=Expr;
    until CurToken<>tkComma;
  end;

  procedure ConsumeSemi;
  begin
    if (CurToken = tkSemicolon) then
      begin
      NextToken;
      if IsCurTokenHint then
        UngetToken;
      end;
  end;

var
  isArray , ok, IsClass: Boolean;
  ObjKind: TCShObjKind;
begin
  Result:=TCShProperty(CreateElement(TCShProperty,AName,Parent,AVisibility));
  if IsClassField then
    Include(Result.VarModifiers,vmClass);
  IsClass:=(Parent<>nil) and (Parent.ClassType=TCShClassType);
  if IsClass then
    ObjKind:=TCShClassType(Parent).ObjKind
  else
    ObjKind:=okClass;
  ok:=false;
  try
    NextToken;
    isArray:=CurToken=tkSquaredBraceOpen;
    if isArray then
      begin
      ParseArgList(Result, Result.Args, tkSquaredBraceClose);
      NextToken;
      end;
    if CurToken = tkColon then
      begin
      Result.VarType := ParseType(Result,CurSourcePos);
      {$IFDEF CheckCShTreeRefCount}if Result.VarType.RefIds.IndexOf('CreateElement')>=0 then Result.VarType.ChangeRefId('CreateElement','TCShVariable.VarType'){$ENDIF};
      NextToken;
      end
    else if not IsClass then
      ParseExcTokenError(':');
    if CurTokenIsIdentifier('INDEX') then
      begin
      NextToken;
      Result.IndexExpr := DoParseExpression(Result);
      end;
    if CurTokenIsIdentifier('READ') then
      begin
      Result.ReadAccessorName := GetAccessorName(Result,Result.ReadAccessor);
      NextToken;
      end;
    if CurTokenIsIdentifier('WRITE') then
      begin
      Result.WriteAccessorName := GetAccessorName(Result,Result.WriteAccessor);
      NextToken;
      end;
    if IsClass and (ObjKind=okDispInterface) then
      begin
      if CurTokenIsIdentifier('READONLY') then
        begin
        Result.DispIDReadOnly:=True;
        NextToken;
        end;
      if CurTokenIsIdentifier('DISPID') then
        begin
        NextToken;
        Result.DispIDExpr := DoParseExpression(Result,Nil);
        end;
      end;
    if IsClass and (ObjKind=okClass) and CurTokenIsIdentifier('IMPLEMENTS') then
      ParseImplements;
    if CurTokenIsIdentifier('STORED') then
      begin
      if not (ObjKind in [okClass]) then
        ParseExc(nParserXNotAllowedInY,SParserXNotAllowedInY,['STORED',ObjKindNames[ObjKind]]);
      NextToken;
      if CurToken = tkTrue then
        begin
        Result.StoredAccessorName := 'True';
        Result.StoredAccessor := CreateBoolConstExpr(Result,pekBoolConst,true);
        end
      else if CurToken = tkFalse then
        begin
        Result.StoredAccessorName := 'False';
        Result.StoredAccessor := CreateBoolConstExpr(Result,pekBoolConst,false);
        end
      else if CurToken = tkIdentifier then
        begin
        UngetToken;
        Result.StoredAccessorName := GetAccessorName(Result,Result.StoredAccessor);
        end
      else
        ParseExcSyntaxError;
      NextToken;
      end;
    if CurTokenIsIdentifier('DEFAULT') then
      begin
      if not (ObjKind in [okClass,okClassHelper]) then // FPC allows it in type helpers
        ParseExc(nParserXNotAllowedInY,SParserXNotAllowedInY,['DEFAULT',ObjKindNames[ObjKind]]);
      if isArray then
        ParseExc(nParserArrayPropertiesCannotHaveDefaultValue,SParserArrayPropertiesCannotHaveDefaultValue);
      NextToken;
      Result.DefaultExpr := DoParseExpression(Result);
  //      NextToken;
      end
    else if CurtokenIsIdentifier('NODEFAULT') then
      begin
      if not (ObjKind in [okClass]) then
        ParseExc(nParserXNotAllowedInY,SParserXNotAllowedInY,['NODEFAULT',ObjKindNames[ObjKind]]);
      Result.IsNodefault:=true;
      if Result.DefaultExpr<>nil then
        ParseExcSyntaxError;
      NextToken;
      end;
    // Here the property ends. There can still be a 'default'
    if CurToken = tkSemicolon then
      begin
      NextToken;
      if CurTokenIsIdentifier('DEFAULT') then
        begin
        if (Result.VarType<>Nil) and (not isArray) then
          ParseExc(nParserDefaultPropertyMustBeArray,SParserDefaultPropertyMustBeArray);
        NextToken;
        if CurToken = tkSemicolon then
          begin
          Result.IsDefault := True;
          NextToken;
          end
        end;
      // Handle hints
      while DoCheckHint(Result) do
        begin
        NextToken; // eat Hint token
        ConsumeSemi; // Now on hint token or semicolon
        end;
//      if Result.Hints=[] then
        UngetToken;
      end
    else if CurToken=tkCurlyBraceClose then
      // ok
    else
      CheckToken(tkSemicolon);
    ok:=true;
  finally
    if not ok then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

// Starts after the "begin" token
procedure TCShParser.ParseProcBeginBlock(Parent: TProcedureBody);
var
  BeginBlock: TCShImplBeginBlock;
  SubBlock: TCShImplElement;
  Proc: TCShProcedure;
begin
  BeginBlock := TCShImplBeginBlock(CreateElement(TCShImplBeginBlock, '', Parent));
  Parent.Body := BeginBlock;
  // these can be used in code for typecasts
  repeat
    NextToken;
//    writeln('TCShParser.ParseProcBeginBlock ',curtokenstring);
    if CurToken=tkCurlyBraceClose then
      break
    else if CurToken<>tkSemiColon then
    begin
      UngetToken;
      ParseStatement(BeginBlock,SubBlock);
      if SubBlock=nil then
        ExpectToken(tkCurlyBraceClose);
    end;
  until false;
  // A declaration can follow...
  Proc:=Parent.Parent as TCShProcedure;
  if Proc.GetProcTypeEnum in [ptAnonymousProcedure,ptAnonymousFunction] then
    NextToken
  else
    ExpectToken(tkSemicolon);
//  writeln('TCShParser.ParseProcBeginBlock ended ',curtokenstring);
end;

// Next token is start of (compound) statement
// After parsing CurToken is on last token of statement
procedure TCShParser.ParseStatement(Parent: TCShImplBlock;
  out NewImplElement: TCShImplElement);
var
  CurBlock: TCShImplBlock;

  {$IFDEF VerboseCShParser}
  function i: string;
  var
    c: TCShElement;
  begin
    Result:='ParseImplCompoundStatement ';
    c:=CurBlock;
    while c<>nil do begin
      Result:=Result+'  ';
      c:=c.Parent;
    end;
  end;
  {$ENDIF}

  function CloseBlock: boolean; // true if parent reached
  var C: TCShImplBlockClass;
  begin
    C:=TCShImplBlockClass(CurBlock.ClassType);
    if C=TCShImplExceptOn then
      Engine.FinishScope(stExceptOnStatement,CurBlock)
    else if C=TCShImplWithDo then
      Engine.FinishScope(stWithExpr,CurBlock);
    CurBlock:=CurBlock.Parent as TCShImplBlock;
    Result:=CurBlock=Parent;
  end;

  function CloseStatement(CloseIfs: boolean): boolean; // true if parent reached
  begin
    if CurBlock=Parent then exit(true);
    while CurBlock.CloseOnSemicolon
        or (CloseIfs and (CurBlock is TCShImplIfElse)) do
      if CloseBlock then exit(true);
    Result:=false;
  end;

  procedure CreateBlock(NewBlock: TCShImplBlock);
  begin
    CurBlock.AddElement(NewBlock);
    CurBlock:=NewBlock;
    if NewImplElement=nil then NewImplElement:=CurBlock;
  end;

  procedure CheckStatementCanStart;
  var
    t: TToken;
  begin
    if (CurBlock.Elements.Count=0) then
      exit; // at start of block
    t:=GetPrevToken;
    if t in [tkSemicolon,tkColon,tkElse] then
      exit;
    {$IFDEF VerboseCShParser}
    writeln('TCShParser.ParseStatement.CheckSemicolon Prev=',GetPrevToken,' Cur=',CurToken,' ',CurBlock.ClassName,' ',CurBlock.Elements.Count,' ',TObject(CurBlock.Elements[0]).ClassName);
    {$ENDIF}
    // last statement not complete -> semicolon is missing
    ParseExcTokenError('Semicolon');
  end;

var
  CmdElem: TCShImplElement;

  procedure AddStatement(El: TCShImplElement);
  begin
    CurBlock.AddElement(El);
    CmdElem:=El;
    UngetToken;
  end;

var
  SubBlock: TCShImplElement;
  Left, Right, Expr: TCShExpr;
  El : TCShImplElement;
  lt : TLoopType;
  SrcPos: TCShSourcePos;
  Name: String;
  TypeEl: TCShType;
  ImplRaise: TCShImplRaise;
  VarEl: TCShVariable;

begin
  NewImplElement:=nil;
  El:=nil;
  Left:=nil;
  try
    CurBlock := Parent;
    while True do
    begin
      NextToken;
      //WriteLn({$IFDEF VerboseCShParser}i,{$ENDIF}' Token=',CurTokenText,' CurBlock=',CurBlock.ClassName);
      case CurToken of
      tkCurlyBraceOpen:
        begin
        CheckStatementCanStart;
        El:=TCShImplElement(CreateElement(TCShImplBeginBlock,'',CurBlock,CurTokenPos));
        CreateBlock(TCShImplBeginBlock(El));
        El:=nil;
        end;
      tkIf:
        begin
        CheckStatementCanStart;
        SrcPos:=CurTokenPos;
        NextToken;
        Left:=DoParseExpression(CurBlock);
        UngetToken;
        El:=TCShImplIfElse(CreateElement(TCShImplIfElse,'',CurBlock,SrcPos));
        TCShImplIfElse(El).ConditionExpr:=Left;
        Left.Parent:=El;
        Left:=nil;
        //WriteLn(i,'IF Condition="',Condition,'" Token=',CurTokenText);
        CreateBlock(TCShImplIfElse(El));
        El:=nil;
        ExpectToken(tkBraceClose);
        end;
      tkelse:
        // ELSE can close multiple blocks, similar to semicolon
        repeat
          {$IFDEF VerboseCShParser}
          writeln('TCShParser.ParseStatement ELSE CurBlock=',CurBlock.ClassName);
          {$ENDIF}
          if CurBlock is TCShImplIfElse then
            begin
            if TCShImplIfElse(CurBlock).IfBranch=nil then
            begin
              // empty THEN statement  e.g. if condition then else
              El:=TCShImplCommand(CreateElement(TCShImplCommand,'', CurBlock,CurTokenPos));
              CurBlock.AddElement(El); // this sets TCShImplIfElse(CurBlock).IfBranch:=El
              El:=nil;
            end;
            if (CurToken=tkelse) and (TCShImplIfElse(CurBlock).ElseBranch=nil) then
              break; // add next statement as ElseBranch
            end
          else if (CurBlock is TCShImplTryExcept) and (CurToken=tkelse) then
            begin
            // close TryExcept handler and open an TryExceptElse handler
            CloseBlock;
            El:=TCShImplTryExceptElse(CreateElement(TCShImplTryExceptElse,'',CurBlock,CurTokenPos));
            TCShImplTry(CurBlock).ElseBranch:=TCShImplTryExceptElse(El);
            CurBlock:=TCShImplTryExceptElse(El);
            El:=nil;
            break;
            end
          else if (CurBlock is TCShImplCaseStatement) then
            begin
            UngetToken;
            // Note: a TCShImplCaseStatement is parsed by a call of ParseStatement,
            //       so it must be the top level block
            if CurBlock<>Parent then
              CheckToken(tkSemicolon);
            exit;
            end
          else if (CurBlock is TCShImplWhileDo)
              or (CurBlock is TCShImplForLoop)
              or (CurBlock is TCShImplWithDo)
              or (CurBlock is TCShImplRaise)
              or (CurBlock is TCShImplExceptOn) then
            // simply close block
          else
            ParseExcSyntaxError;
          CloseBlock;
        until false;
      tkwhile:
        begin
          // while Condition do
          CheckStatementCanStart;
          SrcPos:=CurTokenPos;
          NextToken;
          Left:=DoParseExpression(CurBlock);
          UngetToken;
          //WriteLn(i,'WHILE Condition="',Condition,'" Token=',CurTokenText);
          El:=TCShImplWhileDo(CreateElement(TCShImplWhileDo,'',CurBlock,SrcPos));
          TCShImplWhileDo(El).ConditionExpr:=Left;
          Left.Parent:=El;
          Left:=nil;
          CreateBlock(TCShImplWhileDo(El));
          El:=nil;
          ExpectToken(tkBraceClose);
        end;
      tkUsing:
        begin
          CheckStatementCanStart;
          NextToken;
          CurBlock.AddCommand('using '+curtokenstring);
          ExpectToken(tkBraceClose);
        end;
      tkgoto:
        begin
        CheckStatementCanStart;
        NextToken;
        CurBlock.AddCommand('goto '+curtokenstring);
        // expecttoken(tkSemiColon);
        end;
      tkfor:
        begin
          // for VarName := StartValue to EndValue do
          // for VarName in Expression do
          CheckStatementCanStart;
          ExpectToken(tkBraceOpen);

          El:=TCShImplForLoop(CreateElement(TCShImplForLoop,'',CurBlock,CurTokenPos));
          ExpectIdentifier;
          Expr:=CreatePrimitiveExpr(El,pekIdent,CurTokenString);
          TCShImplForLoop(El).VariableName:=Expr;
          repeat
            NextToken;
            case CurToken of
              tkAssign:
                begin
                lt:=ltNormal;
                break;
                end;
              tkin:
                begin
                lt:=ltIn;
                break;
                end;
              tkDot:
                begin
                SrcPos:=CurTokenPos;
                ExpectIdentifier;
                AddToBinaryExprChain(Expr,
                  CreatePrimitiveExpr(El,pekIdent,CurTokenString), eopSubIdent,SrcPos);
                TCShImplForLoop(El).VariableName:=Expr;
                end;
            else
              ParseExc(nParserExpectedAssignIn,SParserExpectedAssignIn);
            end;
          until false;
          NextToken;
          TCShImplForLoop(El).StartExpr:=DoParseExpression(El);
          if (Lt=ltNormal) then
            begin
            NextToken;
            TCShImplForLoop(El).EndExpr:=DoParseExpression(El);
            end;
          TCShImplForLoop(El).LoopType:=lt;
          if (CurToken<>tkDo) then
            ParseExcTokenError(TokenInfos[tkDo]);
          Engine.FinishScope(stForLoopHeader,El);
          CreateBlock(TCShImplForLoop(El));
          El:=nil;
          //WriteLn(i,'FOR "',VarName,'" := ',StartValue,' to ',EndValue,' Token=',CurTokenText);
        end;
      tkSwitch:
        begin
          CheckStatementCanStart;
          SrcPos:=CurTokenPos;
          NextToken;
          Left:=DoParseExpression(CurBlock);
          UngetToken;
          El:=TCShImplCaseOf(CreateElement(TCShImplCaseOf,'',CurBlock,SrcPos));
          TCShImplCaseOf(El).CaseExpr:=Left;
          Left.Parent:=El;
          Left:=nil;
          CreateBlock(TCShImplCaseOf(El));
          El:=nil;
          repeat
            NextToken;
            //writeln(i,'CASE OF Token=',CurTokenText);
            case CurToken of
            tkCurlyBraceClose:
              begin
              if CurBlock.Elements.Count=0 then
                ParseExc(nParserExpectCase,SParserExpectCase);
              break; // end without else
              end;
            tkelse:
              begin
                // create case-else block
                El:=TCShImplCaseElse(CreateElement(TCShImplCaseElse,'',CurBlock,CurTokenPos));
                TCShImplCaseOf(CurBlock).ElseBranch:=TCShImplCaseElse(El);
                CreateBlock(TCShImplCaseElse(El));
                El:=nil;
                break;
              end
            else
              // read case values
              repeat
                SrcPos:=CurTokenPos;
                Left:=DoParseExpression(CurBlock);
                //writeln(i,'CASE value="',Expr,'" Token=',CurTokenText);
                if CurBlock is TCShImplCaseStatement then
                  begin
                  TCShImplCaseStatement(CurBlock).AddExpression(Left);
                  Left:=nil;
                  end
                else
                  begin
                  El:=TCShImplCaseStatement(CreateElement(TCShImplCaseStatement,'',CurBlock,SrcPos));
                  TCShImplCaseStatement(El).AddExpression(Left);
                  Left:=nil;
                  CreateBlock(TCShImplCaseStatement(El));
                  El:=nil;
                  end;
                //writeln(i,'CASE after value Token=',CurTokenText);
                if (CurToken=tkComma) then
                  NextToken
                else if (CurToken<>tkColon) then
                  ParseExcTokenError(TokenInfos[tkComma]);
              until Curtoken=tkColon;
              // read statement
              ParseStatement(CurBlock,SubBlock);
              // CurToken is now at last token of case-statement
              CloseBlock;
              if CurToken<>tkSemicolon then
                NextToken;
              if (CurToken in [tkSemicolon,tkelse,tkCurlyBraceClose]) then
                // ok
              else
                ParseExcTokenError(TokenInfos[tkSemicolon]);
              if CurToken<>tkSemicolon then
                UngetToken;
            end;
          until false;
          if CurToken=tkCurlyBraceClose then
          begin
            if CloseBlock then break;
            if CloseStatement(false) then break;
          end;
        end;
      tktry:
        begin
        CheckStatementCanStart;
        El:=TCShImplTry(CreateElement(TCShImplTry,'',CurBlock,CurTokenPos));
        CreateBlock(TCShImplTry(El));
        El:=nil;
        end;
      tkfinally:
        begin
          if CloseStatement(true) then
          begin
            UngetToken;
            break;
          end;
          if CurBlock is TCShImplTry then
          begin
            El:=TCShImplTryFinally(CreateElement(TCShImplTryFinally,'',CurBlock,CurTokenPos));
            TCShImplTry(CurBlock).FinallyExcept:=TCShImplTryFinally(El);
            CurBlock:=TCShImplTryFinally(El);
            El:=nil;
          end else
            ParseExcSyntaxError;
        end;
      tkCatch:
        begin
          if CloseStatement(true) then
          begin
            UngetToken;
            break;
          end;
          if CurBlock is TCShImplTry then
          begin
            //writeln(i,'EXCEPT');
            El:=TCShImplTryExcept(CreateElement(TCShImplTryExcept,'',CurBlock,CurTokenPos));
            TCShImplTry(CurBlock).FinallyExcept:=TCShImplTryExcept(El);
            CurBlock:=TCShImplTryExcept(El);
            El:=nil;
          end else
            ParseExcSyntaxError;
        end;
      tkThrow:
        begin
        CheckStatementCanStart;
        ImplRaise:=TCShImplRaise(CreateElement(TCShImplRaise,'',CurBlock,CurTokenPos));
        CreateBlock(ImplRaise);
        NextToken;
        If Curtoken in [tkElse,tkCurlyBraceClose,tkSemicolon] then
          UnGetToken
        else
          begin
          ImplRaise.ExceptObject:=DoParseExpression(ImplRaise);
          if (CurToken=tkIdentifier) and (Uppercase(CurtokenString)='AT') then
            begin
            NextToken;
            ImplRaise.ExceptAddr:=DoParseExpression(ImplRaise);
            end;
          If Curtoken in [tkElse,tkCurlyBraceClose,tkSemicolon] then
            UngetToken
          end;
        end;
      tkCurlyBraceClose:
        begin
          // Note: ParseStatement should return with CurToken at last token of the statement
          if CloseStatement(true) then
          begin
            // there was none requiring an END
            UngetToken;
            break;
          end;
          // still a block left
          if CurBlock is TCShImplBeginBlock then
          begin
            // close at END
            if CloseBlock then break; // close end
            if CloseStatement(false) then break;
          end else if CurBlock is TCShImplCaseElse then
          begin
            if CloseBlock then break; // close else
            if CloseBlock then break; // close caseof
            if CloseStatement(false) then break;
          end else if CurBlock is TCShImplTryHandler then
          begin
            if CloseBlock then break; // close finally/except
            if CloseBlock then break; // close try
            if CloseStatement(false) then break;
          end else
            ParseExcSyntaxError;
        end;
      tkSemiColon:
        if CloseStatement(true) then break;
      tkEOF:
        CheckToken(tkCurlyBraceClose);
      tkIdentifier,
      tkNumber,tkString,tkfalse,tktrue,tkChar,
      tkBraceOpen,tkSquaredBraceOpen,
      tkMinus,tkPlus,tkBase:
        begin
        // Do not check this here:
        //      if (CurToken=tkAt) and not (true {delphi}) then
        //        ParseExc;
        CheckStatementCanStart;

        // On is usable as an identifier
        if lowerCase(CurTokenText)='on' then
          begin
            // in try except:
            // on E: Exception do
            // on Exception do
            if CurBlock is TCShImplTryExcept then
            begin
              SrcPos:=CurTokenPos;
              ExpectIdentifier;
              El:=TCShImplExceptOn(CreateElement(TCShImplExceptOn,'',CurBlock,SrcPos));
              SrcPos:=CurSourcePos;
              Name:=CurTokenString;
              NextToken;
              //writeln('ON t=',Name,' Token=',CurTokenText);
              if CurToken=tkColon then
                begin
                // the first expression was the variable name
                NextToken;
                TypeEl:=ParseSimpleType(El,SrcPos,'');
                TCShImplExceptOn(El).TypeEl:=TypeEl;
                VarEl:=TCShVariable(CreateElement(TCShVariable,Name,El,SrcPos));
                TCShImplExceptOn(El).VarEl:=VarEl;
                VarEl.VarType:=TypeEl;
                TypeEl.AddRef{$IFDEF CheckCShTreeRefCount}('TCShVariable.VarType'){$ENDIF};
                if TypeEl.Parent=El then
                  TypeEl.Parent:=VarEl;
                end
              else
                begin
                UngetToken;
                TCShImplExceptOn(El).TypeEl:=ParseSimpleType(El,SrcPos,'');
                end;
              Engine.FinishScope(stExceptOnExpr,El);
              CreateBlock(TCShImplExceptOn(El));
              El:=nil;
              ExpectToken(tkDo);
            end else
              ParseExcSyntaxError;
          end
        else
          begin
          SrcPos:=CurTokenPos;
          Left:=DoParseExpression(CurBlock);
          case CurToken of
            tkAssign,
            tkAssignPlus,
            tkAssignMinus,
            tkAssignMul,
            tkAssignDivision:
              begin
              // assign statement
              El:=TCShImplAssign(CreateElement(TCShImplAssign,'',CurBlock,SrcPos));
              TCShImplAssign(El).left:=Left;
              Left.Parent:=El;
              Left:=nil;
              TCShImplAssign(El).Kind:=TokenToAssignKind(CurToken);
              NextToken;
              Right:=DoParseExpression(CurBlock);
              TCShImplAssign(El).right:=Right;
              Right.Parent:=El;
              Right:=nil;
              AddStatement(El);
              El:=nil;
              end;
            tkColon:
              begin
              if not (bsGoto in Scanner.CurrentBoolSwitches) then
                ParseExcTokenError(TokenInfos[tkSemicolon])
              else if not (Left is TPrimitiveExpr) then
                ParseExcTokenError(TokenInfos[tkSemicolon]);
              // label mark. todo: check mark identifier in the list of labels
              El:=TCShImplLabelMark(CreateElement(TCShImplLabelMark,'', CurBlock,SrcPos));
              TCShImplLabelMark(El).LabelId:=TPrimitiveExpr(Left).Value;
              ReleaseAndNil(TCShElement(Left){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
              CurBlock.AddElement(El);
              CmdElem:=TCShImplLabelMark(El);
              El:=nil;
              end;
          else
            // simple statement (function call)
            El:=TCShImplSimple(CreateElement(TCShImplSimple,'',CurBlock,SrcPos));
            TCShImplSimple(El).Expr:=Left;
            Left.Parent:=El;
            Left:=nil;
            AddStatement(El);
            El:=nil;
          end;

          if not (CmdElem is TCShImplLabelMark) then
            if NewImplElement=nil then NewImplElement:=CmdElem;
          end;
        end;
      else
        ParseExcSyntaxError;
      end;
    end;
  finally
    if El<>nil then El.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
    if Left<>nil then Left.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

procedure TCShParser.ParseLabels(AParent: TCShElement);
var
  Labels: TCShLabels;
begin
  Labels:=TCShLabels(CreateElement(TCShLabels, '', AParent));
  repeat
    expectTokens([tkIdentifier,tkNumber]);
    Labels.Labels.Add(CurTokenString);
    NextToken;
    if not (CurToken in [tkSemicolon, tkComma]) then
      ParseExcTokenError(TokenInfos[tkSemicolon]);
  until CurToken=tkSemicolon;
end;

// Starts after the "procedure" or "function" token
function TCShParser.GetProcedureClass(ProcType: TProcType): TCShTreeElement;

begin
  Result:=Nil;
  Case ProcType of
    ptFunction       : Result:=TCShFunction;
    ptClassFunction  : Result:=TCShClassFunction;
    ptClassProcedure : Result:=TCShClassProcedure;
    ptClassConstructor : Result:=TCShClassConstructor;
    ptClassDestructor  : Result:=TCShClassDestructor;
    ptProcedure      : Result:=TCShProcedure;
    ptConstructor    : Result:=TCShConstructor;
    ptDestructor     : Result:=TCShDestructor;
    ptOperator       : Result:=TCShOperator;
    ptClassOperator  : Result:=TCShClassOperator;
    ptAnonymousProcedure: Result:=TCShAnonymousProcedure;
    ptAnonymousFunction: Result:=TCShAnonymousFunction;
  else
    ParseExc(nParserUnknownProcedureType,SParserUnknownProcedureType,[Ord(ProcType)]);
  end;
end;

function TCShParser.ParseProcedureOrFunctionDecl(Parent: TCShElement;
  ProcType: TProcType; MustBeGeneric: boolean; AVisibility: TCShMemberVisibility
  ): TCShProcedure;
var
  NameParts: TProcedureNameParts;
  NamePos: TCShSourcePos;

  function ExpectProcName: string;
  { Simple procedure:
      Name
    Method implementation of non generic class:
      aClass.SubClass.Name
    ObjFPC generic procedure or method declaration:
      MustBeGeneric=true, Name<Templates>
    Delphi generic Method Declaration:
      MustBeGeneric=false, Name<Templates>
    ObjFPC Method implementation of generic class:
      aClass.SubClass.Name
    Delphi Method implementation of generic class:
      aClass<Templates>.SubClass<Templates>.Name
      aClass.SubClass<Templates>.Name<Templates>
  }
  Var
    L : TFPList;
    I , Cnt, p: Integer;
    CurName: String;
    Part: TProcedureNamePart;
  begin
    Result:=ExpectIdentifier;
    NamePos:=CurSourcePos;
    Cnt:=1;
    repeat
      NextToken;
      if CurToken=tkDot then
        begin
        if Parent is TImplementationSection then
          begin
          inc(Cnt);
          CurName:=ExpectIdentifier;
          NamePos:=CurSourcePos;
          Result:=Result+'.'+CurName;
          if NameParts<>nil then
            begin
            Part:=TProcedureNamePart.Create;
            NameParts.Add(Part);
            Part.Name:=CurName;
            end;
          end
        else
          ParseExcSyntaxError;
        end
      else if CurToken=tkLessThan then
        begin
        if (not MustBeGeneric) and not (true {delphi}) then
          ParseExc(nParserGenericFunctionNeedsGenericKeyword,SParserGenericFunctionNeedsGenericKeyword);
        // generic templates
        if NameParts=nil then
          begin
          // initialize NameParts
          NameParts:=TProcedureNameParts.Create;
          i:=0;
          CurName:=Result;
          repeat
            Part:=TProcedureNamePart.Create;
            NameParts.Add(Part);
            p:=Pos('.',CurName);
            if p>0 then
              begin
              Part.Name:=LeftStr(CurName,p-1);
              System.Delete(CurName,1,p);
              end
            else
              begin
              Part.Name:=CurName;
              break;
              end;
            inc(i);
          until false;
          end
        else if TProcedureNamePart(NameParts[Cnt-1]).Templates<>nil then
          ParseExcSyntaxError;
        UnGetToken;
        L:=TFPList.Create;
        TProcedureNamePart(NameParts[Cnt-1]).Templates:=L;
        ReadGenericArguments(L,Parent);
        end
      else
        break;
    until false;
    if (NameParts=nil) and MustBeGeneric then
      CheckToken(tkLessThan);
    UngetToken;
  end;

var
  OperatorTypeName,Name: String;
  PC : TCShTreeElement;
  Ot : TOperatorType;
  IsTokenBased , ok: Boolean;
  j, i: Integer;

begin
  OperatorTypeName:='';
  NameParts:=nil;
  Result:=nil;
  ok:=false;
  try
    case ProcType of
    ptOperator,ptClassOperator:
      begin
      if MustBeGeneric then
        ParseExcTokenError('procedure');
      NextToken;
      IsTokenBased:=CurToken<>tkIdentifier;
      if IsTokenBased then
        OT:=TCShOperator.TokenToOperatorType(CurTokenText)
      else
        begin
        OT:=TCShOperator.NameToOperatorType(CurTokenString);
        OperatorTypeName:=CurTokenString;
        // Case Class operator TMyRecord.+
        if (OT=otUnknown) then
          begin
          NextToken;
          if CurToken<>tkDot then
            ParseExc(nErrUnknownOperatorType,SErrUnknownOperatorType,[OperatorTypeName]);
          NextToken;
          IsTokenBased:=CurToken<>tkIdentifier;
          if IsTokenBased then
            OT:=TCShOperator.TokenToOperatorType(CurTokenText)
          else
            OT:=TCShOperator.NameToOperatorType(CurTokenString);
          end;
        end;
      if (ot=otUnknown) then
        ParseExc(nErrUnknownOperatorType,SErrUnknownOperatorType,[CurTokenString]);
      Name:=OperatorNames[Ot];
      if OperatorTypeName<>'' then
        Name:=OperatorTypeName+'.'+Name;
      NamePos:=CurTokenPos;
      end;
    ptAnonymousProcedure,ptAnonymousFunction:
      begin
      Name:='';
      if MustBeGeneric then
        ParseExcTokenError('generic'); // inconsistency
      NamePos:=CurTokenPos;
      end
    else
      Name:=ExpectProcName;
    end;
    PC:=GetProcedureClass(ProcType);
    if Name<>'' then
      Parent:=CheckIfOverLoaded(Parent,Name);
    Result := TCShProcedure(Engine.CreateElement(PC, Name, Parent, AVisibility,
                                                 NamePos, NameParts));
    if NameParts<>nil then
      begin
      if Result.NameParts=nil then
        // CreateElement has not used the NameParts -> do it now
        Result.SetNameParts(NameParts);
      // sanity check
      for i:=0 to Result.NameParts.Count-1 do
        with TProcedureNamePart(Result.NameParts[i]) do
          if Templates<>nil then
            for j:=0 to Templates.Count-1 do
              if TCShElement(Templates[j]).Parent<>Result then
                ParseExc(nParserError,SParserError+'[20190818131750] '+TCShElement(Templates[j]).Parent.Name+':'+TCShElement(Templates[j]).Parent.ClassName);
      if NameParts.Count>0 then
        ParseExc(nParserError,SParserError+'[20190818131909] "'+Name+'"');
      end;
    case ProcType of
    ptFunction, ptClassFunction, ptOperator, ptClassOperator, ptAnonymousFunction:
      begin
      Result.ProcType := CreateFunctionType('', 'Result', Result, False, CurTokenPos);
      if (ProcType in [ptOperator, ptClassOperator]) then
        begin
        TCShOperator(Result).TokenBased:=IsTokenBased;
        TCShOperator(Result).OperatorType:=OT;
        TCShOperator(Result).CorrectName;
        end;
      end;
    else
      Result.ProcType := TCShProcedureType(CreateElement(TCShProcedureType, '', Result));
    end;
    ParseProcedureOrFunction(Result, Result.ProcType, ProcType, False);
    Result.Hints:=Result.ProcType.Hints;
    Result.HintMessage:=Result.ProcType.HintMessage;
    // + is detected as 'positive', but is in fact Add if there are 2 arguments.
    if (ProcType in [ptOperator, ptClassOperator]) then
      With TCShOperator(Result) do
        begin
        if (OperatorType in [otPositive, otNegative]) then
          begin
          if (ProcType.Args.Count>1) then
            begin
            Case OperatorType of
              otPositive : OperatorType:=otPlus;
              otNegative : OperatorType:=otMinus;
            else
            end;
            Name:=OperatorNames[OperatorType];
            TCShOperator(Result).CorrectName;
            end;
          end;
        end;
    ok:=true;
  finally
    if NameParts<>nil then
      ReleaseProcNameParts(NameParts);
    if (not ok) and (Result<>nil) then
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  end;
end;

// Current token is the first token after tkOf
procedure TCShParser.ParseRecordVariantParts(ARec: TCShRecordType;
  AEndToken: TToken);

Var
  M : TCShRecordType;
  V : TCShVariant;
  Done : Boolean;

begin
  Repeat
    V:=TCShVariant(CreateElement(TCShVariant, '', ARec));
    ARec.Variants.Add(V);
    Repeat
      NextToken;
      V.Values.Add(DoParseExpression(ARec));
      if Not (CurToken in [tkComma,tkColon]) then
        ParseExc(nParserExpectedCommaColon,SParserExpectedCommaColon);
    Until (curToken=tkColon);
    ExpectToken(tkBraceOpen);
    NextToken;
    M:=TCShRecordType(CreateElement(TCShRecordType,'',V));
    V.Members:=M;
    ParseRecordMembers(M,tkBraceClose,False);
    // Current token is closing ), so we eat that
    NextToken;
    // If there is a semicolon, we eat that too.
    if CurToken=tkSemicolon then
      NextToken;
    // ParseExpression starts with a nexttoken.
    // So we need to determine the next token, and if it is an ending token, unget.
    Done:=CurToken=AEndToken;
    If not Done then
      Ungettoken;
  Until Done;
end;

{$ifdef VerboseCShParser}
procedure TCShParser.DumpCurToken(const Msg: String; IndentAction: TIndentAction
  );
begin
  {AllowWriteln}
  if IndentAction=iaUndent then
    FDumpIndent:=copy(FDumpIndent,1,Length(FDumpIndent)-2);
  Writeln(FDumpIndent,Msg,' : ',TokenInfos[CurToken],' "',CurTokenString,'", Position: ',Scanner.CurFilename,'(',Scanner.CurRow,',',SCanner.CurColumn,') : ',Scanner.CurLine);
  if IndentAction=iaIndent then
    FDumpIndent:=FDumpIndent+'  ';
  {$ifdef pas2js}
  // ToDo
  {$else}
  Flush(output);
  {$endif}
  {AllowWriteln-}
end;
{$endif}

function TCShParser.GetCurrentModeSwitches: TModeSwitches;
begin
  if Assigned(FScanner) then
    Result:=FScanner.CurrentModeSwitches
  else
    Result:=[msNone];
end;

procedure TCShParser.SetCurrentModeSwitches(AValue: TModeSwitches);
begin
  if Assigned(FScanner) then
    FScanner.CurrentModeSwitches:=AValue;
end;

// Starts on first token after Record or (. Ends on AEndToken
procedure TCShParser.ParseRecordMembers(ARec: TCShRecordType;
  AEndToken: TToken; AllowMethods: Boolean);
var
  isClass : Boolean;

  procedure EnableIsClass;
  begin
    isClass:=True;
    Scanner.SetTokenOption(toOperatorToken);
  end;

  procedure DisableIsClass;
  begin
    if not isClass then exit;
    isClass:=false;
    Scanner.UnSetTokenOption(toOperatorToken);
  end;

Var
  VariantName : String;
  v : TCShMemberVisibility;
  Proc: TCShProcedure;
  ProcType: TProcType;
  Prop : TCShProperty;
  NamePos: TCShSourcePos;
  OldCount, i: Integer;
  CurEl: TCShElement;
  LastToken: TToken;
  AllowVisibility: Boolean;
begin
  AllowVisibility:=true {AdvanceRecords};
  if AllowVisibility then
    v:=visPublic
  else
    v:=visDefault;
  isClass:=False;
  LastToken:=tkStruct;
  while CurToken<>AEndToken do
    begin
    SaveComments;
    Case CurToken of
      tkConst:
        begin
        DisableIsClass;
        if Not AllowMethods then
          ParseExc(nErrRecordConstantsNotAllowed,SErrRecordConstantsNotAllowed);
        ExpectToken(tkIdentifier);
        ParseMembersLocalConsts(ARec,v);
        end;
      tkClass:
        begin
        if LastToken=tkclass then
          ParseExc(nParserTypeSyntaxError,SParserTypeSyntaxError);
        if Not AllowMethods then
          begin
          NextToken;
          case CurToken of
          tkConst: ParseExc(nErrRecordConstantsNotAllowed,SErrRecordConstantsNotAllowed);
          else
            ParseExc(nErrRecordMethodsNotAllowed,SErrRecordMethodsNotAllowed);
          end;
          end;
        EnableIsClass;
        end;
{      tkProperty:
        begin
        DisableIsClass;
        if Not AllowMethods then
          ParseExc(nErrRecordPropertiesNotAllowed,SErrRecordPropertiesNotAllowed);
        ExpectToken(tkIdentifier);
        Prop:=ParseProperty(ARec,CurtokenString,v,LastToken=tkclass);
        ARec.Members.Add(Prop);
        Engine.FinishScope(stDeclaration,Prop);
        end; }
      tkOperator,
      tkVoid{,
      tkConstructor,
      tkFunction} :
        begin
        DisableIsClass;
        if Not AllowMethods then
          ParseExc(nErrRecordMethodsNotAllowed,SErrRecordMethodsNotAllowed);
        ProcType:=GetProcTypeFromToken(CurToken,LastToken=tkclass);
        Proc:=ParseProcedureOrFunctionDecl(ARec,ProcType,false,v);
        if Proc.Parent is TCShOverloadedProc then
          TCShOverloadedProc(Proc.Parent).Overloads.Add(Proc)
        else
          ARec.Members.Add(Proc);
        Engine.FinishScope(stProcedure,Proc);
        end;
      tkThis, // Counts as field name
      tkIdentifier :
        begin
        If AllowVisibility and CheckVisibility(CurTokenString,v) then
          begin
          if not (v in [visPrivate,visPublic,visStrictPrivate]) then
            ParseExc(nParserInvalidRecordVisibility,SParserInvalidRecordVisibility);
          NextToken;
          Continue;
          end;
        OldCount:=ARec.Members.Count;
        ParseInlineVarDecl(ARec, ARec.Members, v, AEndToken=tkBraceClose);
        for i:=OldCount to ARec.Members.Count-1 do
          begin
          CurEl:=TCShElement(ARec.Members[i]);
          if CurEl.ClassType=TCShAttributes then continue;
          if isClass then
            With TCShVariable(CurEl) do
              VarModifiers:=VarModifiers + [vmClass];
          Engine.FinishScope(stDeclaration,TCShVariable(CurEl));
          end;
        end;
      tkSquaredBraceOpen:
        if true {Attributes}then
          ParseAttributes(ARec,true)
        else
          CheckToken(tkIdentifier);
      tkCase :
        begin
        DisableIsClass;
        ARec.Variants:=TFPList.Create;
        NextToken;
        VariantName:=CurTokenString;
        NamePos:=CurSourcePos;
        NextToken;
        If CurToken=tkColon then
          begin
          ARec.VariantEl:=TCShVariable(CreateElement(TCShVariable,VariantName,ARec,NamePos));
          TCShVariable(ARec.VariantEl).VarType:=ParseType(ARec,CurSourcePos);
          end
        else
          begin
          UnGetToken;
          UnGetToken;
          ARec.VariantEl:=ParseType(ARec,CurSourcePos);
          end;
        ParseRecordVariantParts(ARec,AEndToken);
        end;
    else
      ParseExc(nParserTypeSyntaxError,SParserTypeSyntaxError);
    end;
    if CurToken=AEndToken then
      break;
    LastToken:=CurToken;
    NextToken;
    end;
end;

// Starts after the "record" token
function TCShParser.ParseRecordDecl(Parent: TCShElement;
  const NamePos: TCShSourcePos; const TypeName: string;
  const Packmode: TPackMode): TCShRecordType;

var
  ok: Boolean;
  allowadvanced : Boolean;

begin
  Result := TCShRecordType(CreateElement(TCShRecordType, TypeName, Parent, NamePos));
  ok:=false;
  try
    Result.PackMode:=PackMode;
    NextToken;
    allowAdvanced:=(true {AdvanceRecords})
                   and not (Parent is TProcedureBody)
                   and (Result.Name<>'');
    ParseRecordMembers(Result,tkCurlyBraceClose,allowAdvanced);
    Engine.FinishScope(stTypeDef,Result);
    ok:=true;
  finally
    if not ok then
      begin
      Result.Parent:=nil; // clear references from members to Result
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      end;
  end;
end;

Function IsVisibility(S : String;  var AVisibility :TCShMemberVisibility) : Boolean;

Const
  VNames : array[TCShMemberVisibility] of string =
    ('', 'private', 'protected', 'public', 'published', 'automated', '', '', 'internal');
Var
  V : TCShMemberVisibility;

begin
  Result:=False;
  S:=lowerCase(S);
  For V :=Low(TCShMemberVisibility) to High(TCShMemberVisibility) do
    begin
    Result:=(VNames[V]<>'') and (S=VNames[V]);
    if Result then
      begin
      AVisibility := v;
      Exit;
      end;
    end;
end;

function TCShParser.CheckVisibility(S: String;
  var AVisibility: TCShMemberVisibility): Boolean;

Var
  B : Boolean;

begin
  s := LowerCase(CurTokenString);
  B:=(S='strict');
  if B then
    begin
    NextToken;
    s:=LowerCase(CurTokenString);
    end;
  Result:=isVisibility(S,AVisibility);
  if Result then
    begin
    if (AVisibility=visPublished) and (false {OmitRTTI}) then
      AVisibility:=visPublic;
    if B then
      case AVisibility of
        visPrivate   : AVisibility:=visStrictPrivate;
        visProtected : AVisibility:=visStrictProtected;
      else
        ParseExc(nParserStrangeVisibility,SParserStrangeVisibility,[S]);
      end
    end
  else if B then
    ParseExc(nParserExpectVisibility,SParserExpectVisibility);
end;

procedure TCShParser.ProcessMethod(AType: TCShClassType; IsClass: Boolean;
  AVisibility: TCShMemberVisibility; MustBeGeneric: boolean);

var
  Proc: TCShProcedure;
  ProcType: TProcType;
begin
  ProcType:=GetProcTypeFromToken(CurToken,isClass);
  Proc:=ParseProcedureOrFunctionDecl(AType,ProcType,MustBeGeneric,AVisibility);
  if Proc.Parent is TCShOverloadedProc then
    TCShOverloadedProc(Proc.Parent).Overloads.Add(Proc)
  else
    AType.Members.Add(Proc);
  Engine.FinishScope(stProcedure,Proc);
end;

procedure TCShParser.ParseClassFields(AType: TCShClassType;
  const AVisibility: TCShMemberVisibility; IsClassField: Boolean);

Var
  VarList: TFPList;
  Element: TCShElement;
  I : Integer;
  isStatic : Boolean;
  VarEl: TCShVariable;

begin
  VarList := TFPList.Create;
  try
    ParseInlineVarDecl(AType, VarList, AVisibility, False);
    if CurToken=tkSemicolon then
      begin
      NextToken;
      isStatic:=CurTokenIsIdentifier('static');
      if isStatic then
        ExpectToken(tkSemicolon)
      else
        UngetToken;
      end;
    for i := 0 to VarList.Count - 1 do
      begin
      Element := TCShElement(VarList[i]);
      Element.Visibility := AVisibility;
      AType.Members.Add(Element);
      if (Element is TCShVariable) then
        begin
        VarEl:=TCShVariable(Element);
        if IsClassField then
          Include(VarEl.VarModifiers,vmClass);
        if isStatic then
          Include(VarEl.VarModifiers,vmStatic);
        Engine.FinishScope(stDeclaration,VarEl);
        end;
      end;
  finally
    VarList.Free;
  end;
end;

procedure TCShParser.ParseMembersLocalTypes(AType: TCShMembersType;
  AVisibility: TCShMemberVisibility);

Var
  T : TCShType;
  Done : Boolean;
begin
  Done:=False;
  //Writeln('Parsing local types');
  while (CurToken=tkSquaredBraceOpen)
      and (true {Attributes}) do
    begin
    ParseAttributes(AType,true);
    NextToken;
    end;
  Repeat
    T:=ParseTypeDecl(AType);
    T.Visibility:=AVisibility;
    AType.Members.Add(t);
    // Writeln(CurtokenString,' ',TokenInfos[Curtoken]);
    NextToken;
    case CurToken of
    tkIdentifier:
      Done:=CheckVisibility(CurTokenString,AVisibility);
    tkSquaredBraceOpen:
      if true {Attributes}then
        repeat
          ParseAttributes(AType,true);
          NextToken;
          Done:=false;
        until CurToken<>tkSquaredBraceOpen
      else
        Done:=true;
    else
      Done:=true;
    end;
    if Done then
      UngetToken;
  Until Done;
  Engine.FinishScope(stTypeSection,AType);
end;

procedure TCShParser.ParseMembersLocalConsts(AType: TCShMembersType;
  AVisibility: TCShMemberVisibility);

Var
  C : TCShConst;
  Done : Boolean;
begin
  // Writeln('Parsing local consts');
  while (CurToken=tkSquaredBraceOpen)
      and (true {Attributes}) do
    begin
    ParseAttributes(AType,true);
    NextToken;
    end;
  Repeat
    C:=ParseConstDecl(AType);
    C.Visibility:=AVisibility;
    AType.Members.Add(C);
    Engine.FinishScope(stDeclaration,C);
    //Writeln('TCShParser.ParseMembersLocalConsts ',CurtokenString,' ',TokenInfos[CurToken]);
    NextToken;
    if CurToken<>tkSemicolon then
      exit;
    NextToken;
    case CurToken of
    tkIdentifier:
      Done:=CheckVisibility(CurTokenString,AVisibility);
    tkSquaredBraceOpen:
      if true {Attributes}then
        repeat
          ParseAttributes(AType,true);
          NextToken;
          Done:=false;
        until CurToken<>tkSquaredBraceOpen
      else
        Done:=true;
    else
      Done:=true;
    end;
    if Done then
      UngetToken;
  Until Done;
end;

procedure TCShParser.ParseClassMembers(AType: TCShClassType);
Type
  TSectionType = (stNone,stConst,stType,stVar,stClassVar);
Var
  CurVisibility : TCShMemberVisibility;
  CurSection : TSectionType;
  haveClass: boolean; // true means last token was class keyword
  IsMethodResolution: Boolean;
  LastToken: TToken;
  PropEl: TCShProperty;
  MethodRes: TCShMethodResolution;
begin
  CurSection:=stNone;
  haveClass:=false;
  if Assigned(FEngine) then
    CurVisibility:=FEngine.GetDefaultClassVisibility(AType)
  else
    CurVisibility := visPublic;
  LastToken:=CurToken;
  while (CurToken<>tkCurlyBraceClose) do
    begin
    //writeln('TCShParser.ParseClassMembers LastToken=',LastToken,' CurToken=',CurToken,' haveClass=',haveClass,' CurSection=',CurSection);
    case CurToken of
    tkConst:
      begin
      if haveClass then
        ParseExcExpectedAorB('Procedure','Var');
      case AType.ObjKind of
      okClass,okObject,
      okClassHelper,okRecordHelper,okTypeHelper: ;
      else
        ParseExc(nParserXNotAllowedInY,SParserXNotAllowedInY,['CONST',ObjKindNames[AType.ObjKind]]);
      end;
      CurSection:=stConst;
      NextToken;
      ParseMembersLocalConsts(AType,CurVisibility);
      CurSection:=stNone;
      end;
    tkIdentifier:
      if CheckVisibility(CurTokenString,CurVisibility) then
        CurSection:=stNone
      else
        begin
        if haveClass then
          begin
          if LastToken=tkclass then
            ParseExcExpectedAorB('Procedure','Function');
          end
        else
          SaveComments;
        Case CurSection of
        stNone,
        stVar:
          begin
          if not (AType.ObjKind in okWithFields) then
            ParseExc(nParserNoFieldsAllowed,SParserNoFieldsAllowedInX,[ObjKindNames[AType.ObjKind]]);
          ParseClassFields(AType,CurVisibility,CurSection=stClassVar);
          HaveClass:=False;
          end;
        stClassVar:
          begin
          if not (AType.ObjKind in okWithClassFields) then
            ParseExc(nParserNoFieldsAllowed,SParserNoFieldsAllowedInX,[ObjKindNames[AType.ObjKind]]);
          ParseClassFields(AType,CurVisibility,CurSection=stClassVar);
          HaveClass:=False;
          end;
        else
          Raise Exception.Create('Internal error 201704251415');
        end;
        end;
    tkVoid:
      begin
      curSection:=stNone;
      IsMethodResolution:=false;
      if not haveClass then
        begin
        SaveComments;
        if AType.ObjKind=okClass then
          begin
          NextToken;
          if CurToken=tkIdentifier then
            begin
            NextToken;
            IsMethodResolution:=CurToken=tkDot;
            UngetToken;
            end;
          UngetToken;
          end;
        end;
      if IsMethodResolution then
        begin
        MethodRes:=ParseMethodResolution(AType);
        AType.Members.Add(MethodRes);
        Engine.FinishScope(stDeclaration,MethodRes);
        end
      else
        ProcessMethod(AType,HaveClass,CurVisibility,false);
      haveClass:=False;
      end;
{    tkgeneric:
      begin
      if true {delphi} then
        ParseExcSyntaxError; // inconsistency, tkGeneric should be in Scanner.NonTokens
      if haveClass and (LastToken=tkclass) then
        ParseExcTokenError('Generic Class');
      case AType.ObjKind of
      okClass,okObject,
      okClassHelper,okRecordHelper,okTypeHelper: ;
      else
        ParseExc(nParserXNotAllowedInY,SParserXNotAllowedInY,['generic',ObjKindNames[AType.ObjKind]]);
      end;
      SaveComments;
      CurSection:=stNone;
      NextToken;
      if CurToken=tkclass then
        begin
        haveClass:=true;
        NextToken;
        end
      else
        haveClass:=false;
      if not (CurToken in [tkVoid,tkfunction]) then
        ParseExcExpectedAorB('Procedure','Function');
      ProcessMethod(AType,HaveClass,CurVisibility,true);
      end; }
    tkclass:
      begin
      case AType.ObjKind of
      okClass,okObject,
      okClassHelper,okRecordHelper,okTypeHelper, okObjCClass, okObjcCategory, okObjcProtocol : ;
      else
        ParseExc(nParserXNotAllowedInY,SParserXNotAllowedInY,['CLASS',ObjKindNames[AType.ObjKind]]);
      end;

      SaveComments;
      HaveClass:=True;
      curSection:=stNone;
      end;
{    tkProperty:
      begin
      curSection:=stNone;
      if not haveClass then
        SaveComments;
      ExpectIdentifier;
      PropEl:=ParseProperty(AType,CurtokenString,CurVisibility,HaveClass);
      AType.Members.Add(PropEl);
      Engine.FinishScope(stDeclaration,PropEl);
      HaveClass:=False;
      end; }
    tkSquaredBraceOpen:
      if true {Attributes}then
        ParseAttributes(AType,true)
      else
        CheckToken(tkIdentifier);
    else
      CheckToken(tkIdentifier);
    end;
    LastToken:=CurToken;
    NextToken;
    end;
end;

procedure TCShParser.DoParseClassType(AType: TCShClassType);
var
  s: String;
  Expr: TCShExpr;
begin
  if (CurToken=tkIdentifier) and (AType.ObjKind=okClass) then
    begin
    s := LowerCase(CurTokenString);
    if (s = 'sealed') or (s = 'abstract') then
      begin
      AType.Modifiers.Add(s);
      NextToken;
      end;
    end;
  // Parse ancestor list
  AType.IsForward:=(CurToken=tkSemiColon);
  if (CurToken=tkBraceOpen) then
    begin
    // read ancestor and interfaces
    if (AType.ObjKind=okRecordHelper)
        and (false) then
      // Delphi does not support ancestors in record helpers
      CheckToken(tkCurlyBraceClose);
    NextToken;
    AType.AncestorType := ParseTypeReference(AType,false,Expr);
    if AType.ObjKind in [okClass,okObjCClass] then
      while CurToken=tkComma do
        begin
        NextToken;
        AType.Interfaces.Add(ParseTypeReference(AType,false,Expr));
        end;
    CheckToken(tkBraceClose);
    NextToken;
    AType.IsShortDefinition:=(CurToken=tkSemicolon);
    end;
  if (AType.ObjKind in okAllHelpers) then
    begin
    CheckToken(tkfor);
    NextToken;
    AType.HelperForType:=ParseTypeReference(AType,false,Expr);
    end;
  Engine.FinishScope(stAncestors,AType);
  if AType.IsShortDefinition or AType.IsForward then
    UngetToken
  else
    begin
    if (AType.ObjKind in [okInterface,okDispInterface]) and (CurToken = tkSquaredBraceOpen) then
      begin
      NextToken;
      AType.GUIDExpr:=DoParseExpression(AType);
      if (CurToken<>tkSquaredBraceClose) then
        ParseExcTokenError(TokenInfos[tkSquaredBraceClose]);
      NextToken;
      end;
    ParseClassMembers(AType);
    end;
end;

function TCShParser.DoParseClassExternalHeader(AObjKind: TCShObjKind; out AExternalNameSpace, AExternalName: string): Boolean;
begin
  Result:=False;
  if ((aObjKind in [okObjcCategory,okObjcClass]) or
      ((AObjKind in [okClass,okInterface]) and (true {ExternalClass})))
      and CurTokenIsIdentifier('external') then
    begin
    Result:=True;
    NextToken;
    if CurToken<>tkString then
      UnGetToken
    else
      AExternalNameSpace:=CurTokenString;
    if (aObjKind in [okObjcCategory,okObjcClass]) then
      begin
      // Name is optional in objcclass/category
      NextToken;
      if CurToken=tkBraceOpen then
        exit;
      UnGetToken;
      end;
    ExpectIdentifier;
    If Not CurTokenIsIdentifier('Name')  then
      ParseExc(nParserExpectedExternalClassName,SParserExpectedExternalClassName);
    NextToken;
    if not (CurToken in [tkChar,tkString]) then
      CheckToken(tkString);
    AExternalName:=CurTokenString;
    NextToken;
    end
  else
    begin
    AExternalNameSpace:='';
    AExternalName:='';
    end;
end;

procedure TCShParser.DoParseArrayType(ArrType: TCShArrayType);
var
  S: String;
  RangeExpr: TCShExpr;
begin
  NextToken;
  S:='';
  case CurToken of
    tkSquaredBraceOpen:
      begin
      // static array
      if ArrType.Parent is TCShArgument then
        ParseExcTokenError('of');
      repeat
        NextToken;
        if po_arrayrangeexpr in Options then
          begin
          RangeExpr:=DoParseExpression(ArrType);
          ArrType.AddRange(RangeExpr);
          end
        else if CurToken<>tkSquaredBraceClose then
          S:=S+CurTokenText;
        if CurToken=tkSquaredBraceClose then
          break
        else if CurToken=tkComma then
          continue
        else if po_arrayrangeexpr in Options then
          ParseExcTokenError(']');
      until false;
      ArrType.IndexRange:=S;
      ArrType.ElType := ParseType(ArrType,CurSourcePos);
      end;
{    tkOf:
      begin
      NextToken;
      if CurToken = tkConst then
        // array of const
        begin
        if not (ArrType.Parent is TCShArgument) then
          ParseExcExpectedIdentifier;
        end
      else
        begin
        if (CurToken=tkarray) and (ArrType.Parent is TCShArgument) then
          ParseExcExpectedIdentifier;
        UngetToken;
        ArrType.ElType := ParseType(ArrType,CurSourcePos);
        end;
      end
    else
      ParseExc(nParserArrayTypeSyntaxError,SParserArrayTypeSyntaxError); }
  end;
  // TCShProcedureType parsing has eaten the semicolon;
  // We know it was a local definition if the array def (ArrType) is the parent
  if (ArrType.ElType is TCShProcedureType) and (ArrType.ElType.Parent=ArrType) then
    UnGetToken;
end;

function TCShParser.ParseClassDecl(Parent: TCShElement;
  const NamePos: TCShSourcePos; const AClassName: String;
  AObjKind: TCShObjKind; PackMode: TPackMode): TCShType;

Var
  isExternal,ok: Boolean;
  AExternalNameSpace,AExternalName : String;
  PCT:TCShClassType;

begin
  NextToken;
{  if (AObjKind = okClass) and (CurToken = tkOf) then
    begin
    Result := TCShClassOfType(CreateElement(TCShClassOfType, AClassName,
      Parent, NamePos));
    ok:=false;
    try
      ExpectIdentifier;
      UngetToken;                // Only names are allowed as following type
      TCShClassOfType(Result).DestType := ParseType(Result,CurSourcePos);
      Engine.FinishScope(stTypeDef,Result);
      ok:=true;
    finally
      if not ok then
        Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
    end;
    exit;
    end; }
  isExternal:=DoParseClassExternalHeader(AObjKind,AExternalNameSpace,AExternalName);
  if AObjKind in okAllHelpers then
    begin
    if not CurTokenIsIdentifier('Helper') then
      ParseExcSyntaxError;
    NextToken;
    end;
  PCT := TCShClassType(CreateElement(TCShClassType, AClassName,
    Parent, NamePos));
  Result:=PCT;
  ok:=false;
  try
    PCT.HelperForType:=nil;
    PCT.IsExternal:=IsExternal;
    if AExternalName<>'' then
      PCT.ExternalName:={$ifdef pas2js}DeQuoteString{$else}AnsiDequotedStr{$endif}(AExternalName,'''');
    if AExternalNameSpace<>'' then
      PCT.ExternalNameSpace:={$ifdef pas2js}DeQuoteString{$else}AnsiDequotedStr{$endif}(AExternalNameSpace,'''');
    PCT.ObjKind := AObjKind;
    PCT.PackMode:=PackMode;
    if AObjKind=okInterface then
      begin
      if SameText(Scanner.CurrentValueSwitch[vsInterfaces],'CORBA') then
        PCT.InterfaceType:=citCorba;
      end;
    DoParseClassType(PCT);
    Engine.FinishScope(stTypeDef,Result);
    ok:=true;
  finally
    if not ok then
      begin
      PCT.Parent:=nil; // clear references from members to PCT
      Result.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
      end;
  end;
end;

function TCShParser.CreateElement(AClass: TCShTreeElement; const AName: String;
  AParent: TCShElement): TCShElement;
begin
  Result := Engine.CreateElement(AClass, AName, AParent, visDefault, CurSourcePos);
end;

function TCShParser.CreateElement(AClass: TCShTreeElement; const AName: String;
  AParent: TCShElement; const ASrcPos: TCShSourcePos): TCShElement;
begin
  Result := Engine.CreateElement(AClass, AName, AParent, visDefault, ASrcPos);
end;

function TCShParser.CreateElement(AClass: TCShTreeElement; const AName: String;
  AParent: TCShElement; AVisibility: TCShMemberVisibility): TCShElement;
begin
  Result := Engine.CreateElement(AClass, AName, AParent, AVisibility,
    CurSourcePos);
end;

function TCShParser.CreateElement(AClass: TCShTreeElement; const AName: String;
  AParent: TCShElement; AVisibility: TCShMemberVisibility;
  const ASrcPos: TCShSourcePos; TypeParams: TFPList): TCShElement;
begin
  if (ASrcPos.Row=0) and (ASrcPos.FileName='') then
    Result := Engine.CreateElement(AClass, AName, AParent, AVisibility, CurSourcePos, TypeParams)
  else
    Result := Engine.CreateElement(AClass, AName, AParent, AVisibility, ASrcPos, TypeParams);
end;

function TCShParser.CreatePrimitiveExpr(AParent: TCShElement;
  AKind: TCShExprKind; const AValue: String): TPrimitiveExpr;
begin
  Result:=TPrimitiveExpr(CreateElement(TPrimitiveExpr,'',AParent,CurTokenPos));
  Result.Kind:=AKind;
  Result.Value:=AValue;
end;

function TCShParser.CreateBoolConstExpr(AParent: TCShElement;
  AKind: TCShExprKind; const ABoolValue: Boolean): TBoolConstExpr;
begin
  Result:=TBoolConstExpr(CreateElement(TBoolConstExpr,'',AParent,CurTokenPos));
  Result.Kind:=AKind;
  Result.Value:=ABoolValue;
end;

function TCShParser.CreateBinaryExpr(AParent: TCShElement; xleft,
  xright: TCShExpr; AOpCode: TExprOpCode): TBinaryExpr;
begin
  Result:=CreateBinaryExpr(AParent,xleft,xright,AOpCode,CurSourcePos);
end;

function TCShParser.CreateBinaryExpr(AParent: TCShElement; xleft,
  xright: TCShExpr; AOpCode: TExprOpCode; const ASrcPos: TCShSourcePos
  ): TBinaryExpr;
begin
  Result:=TBinaryExpr(CreateElement(TBinaryExpr,'',AParent,ASrcPos));
  Result.OpCode:=AOpCode;
  Result.Kind:=pekBinary;
  if xleft<>nil then
    begin
    Result.left:=xleft;
    xleft.Parent:=Result;
    end;
  if xright<>nil then
    begin
    Result.right:=xright;
    xright.Parent:=Result;
    end;
end;

procedure TCShParser.AddToBinaryExprChain(var ChainFirst: TCShExpr;
  Element: TCShExpr; AOpCode: TExprOpCode; const ASrcPos: TCShSourcePos);
begin
  if Element=nil then
    exit
  else if ChainFirst=nil then
    begin
    // empty chain => simply add element, no need to create TBinaryExpr
    ChainFirst:=Element;
    end
  else
    begin
    // create new binary, old becomes left, Element right
    ChainFirst:=CreateBinaryExpr(ChainFirst.Parent,ChainFirst,Element,AOpCode,ASrcPos);
    end;
end;

{$IFDEF VerboseCShParser}
{AllowWriteln}
procedure TCShParser.WriteBinaryExprChain(Prefix: string; First, Last: TCShExpr
  );
var
  i: Integer;
begin
  if First=nil then
    begin
    write(Prefix,'First=nil');
    if Last=nil then
      writeln('=Last')
    else
      begin
      writeln(', ERROR Last=',Last.ClassName);
      ParseExcSyntaxError;
      end;
    end
  else if Last=nil then
    begin
    writeln(Prefix,'ERROR Last=nil First=',First.ClassName);
    ParseExcSyntaxError;
    end
  else if First is TBinaryExpr then
    begin
    i:=0;
    while First is TBinaryExpr do
      begin
      writeln(Prefix,Space(i*2),'bin.left=',TBinaryExpr(First).left.ClassName);
      if First=Last then break;
      First:=TBinaryExpr(First).right;
      inc(i);
      end;
    if First<>Last then
      begin
      writeln(Prefix,Space(i*2),'ERROR Last is not last in chain');
      ParseExcSyntaxError;
      end;
    if not (Last is TBinaryExpr) then
      begin
      writeln(Prefix,Space(i*2),'ERROR Last is not TBinaryExpr: ',Last.ClassName);
      ParseExcSyntaxError;
      end;
    if TBinaryExpr(Last).right=nil then
      begin
      writeln(Prefix,Space(i*2),'ERROR Last.right=nil');
      ParseExcSyntaxError;
      end;
    writeln(Prefix,Space(i*2),'last.right=',TBinaryExpr(Last).right.ClassName);
    end
  else if First=Last then
    writeln(Prefix,'First=Last=',First.ClassName)
  else
    begin
    write(Prefix,'ERROR First=',First.ClassName);
    if Last<>nil then
      writeln(' Last=',Last.ClassName)
    else
      writeln(' Last=nil');
    end;
end;
{AllowWriteln-}
{$ENDIF}

function TCShParser.CreateUnaryExpr(AParent: TCShElement; AOperand: TCShExpr;
  AOpCode: TExprOpCode): TUnaryExpr;
begin
  Result:=CreateUnaryExpr(AParent,AOperand,AOpCode,CurTokenPos);
end;

function TCShParser.CreateUnaryExpr(AParent: TCShElement; AOperand: TCShExpr;
  AOpCode: TExprOpCode; const ASrcPos: TCShSourcePos): TUnaryExpr;
begin
  Result:=TUnaryExpr(CreateElement(TUnaryExpr,'',AParent,ASrcPos));
  Result.Kind:=pekUnary;
  Result.Operand:=AOperand;
  Result.Operand.Parent:=Result;
  Result.OpCode:=AOpCode;
end;

function TCShParser.CreateArrayValues(AParent: TCShElement): TArrayValues;
begin
  Result:=TArrayValues(CreateElement(TArrayValues,'',AParent));
  Result.Kind:=pekListOfExp;
end;

function TCShParser.CreateFunctionType(const AName, AResultName: String;
  AParent: TCShElement; UseParentAsResultParent: Boolean;
  const NamePos: TCShSourcePos; TypeParams: TFPList): TCShFunctionType;
begin
  Result:=Engine.CreateFunctionType(AName,AResultName,
                                    AParent,UseParentAsResultParent,
                                    NamePos,TypeParams);
end;

function TCShParser.CreateInheritedExpr(AParent: TCShElement): TInheritedExpr;
begin
  Result:=TInheritedExpr(CreateElement(TInheritedExpr,'',AParent,CurTokenPos));
  Result.Kind:=pekInherited;
end;

function TCShParser.CreateSelfExpr(AParent: TCShElement): TThisExpr;
begin
  Result:=TThisExpr(CreateElement(TThisExpr,'Self',AParent,CurTokenPos));
  Result.Kind:=pekThis;
end;

function TCShParser.CreateNilExpr(AParent: TCShElement): TNullExpr;
begin
  Result:=TNullExpr(CreateElement(TNullExpr,'nil',AParent,CurTokenPos));
  Result.Kind:=pekNull;
end;

function TCShParser.CreateRecordValues(AParent: TCShElement): TRecordValues;
begin
  Result:=TRecordValues(CreateElement(TRecordValues,'',AParent));
  Result.Kind:=pekListOfExp;
end;

procedure TCShParser.ParseAdhocExpression(out NewExprElement: TCShExpr);
begin
  NewExprElement := DoParseExpression(nil);
end;

initialization
{$IFDEF HASFS}
  DefaultFileResolverClass:=TFileResolver;
{$ENDIF}
end.
