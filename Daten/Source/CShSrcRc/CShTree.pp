{
    CSharp parse tree classes
    inspired by CShTree that is part of the Free Component Library

    Copyright (c) 2000-2005 by
      Areca Systems GmbH / Sebastian Guenther, sg@freepascal.org

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

unit CShTree;

{$i jcs-cshsrc.inc}

{$if defined(debugrefcount) or defined(VerboseCShTreeMem) or defined(VerboseCShResolver)}
  {$define EnableCShTreeGlobalRefCount}
{$endif}

interface

uses SysUtils, Classes;

resourcestring
  // Parse tree node type names
  SCShTreeElement = 'generic element';
  SCShTreeSection = 'unit section';
  SCShTreeNamespace = 'namespace section';
  SCShTreeProgramSection = 'program section';
  SCShTreeLibrarySection = 'library section';
  SCShTreeUsingNamespace = 'using namespace';
  SCShTreeModule = 'module';
  SCShTreeProgram = 'program';
  SCShTreePackage = 'package';
  SCShTreeResString = 'resource string';
  SCShTreeType = 'generic type';
  SCShTreePointerType = 'pointer type';
  SCShTreeAliasType = 'alias type';
  SCShTreeTypeAliasType = '"type" alias type';
  SCShTreeClassOfType = '"class of" type';
  SCShTreeRangeType = 'range type';
  SCShTreeArrayType = 'array type';
  SCShTreeEnumValue = 'enumeration value';
  SCShTreeEnumType = 'enumeration type';
  SCShTreeSetType = 'set type';
  SCShTreeStructType = 'struct type';
  SCShStringType = 'string type';
  SCShTreeObjectType = 'object';
  SCShTreeClassType = 'class';
  SCShTreeInterfaceType = 'interface';
  SCShTreeSpecializedType = 'specialized class type';
  SCShTreeSpecializedExpr = 'specialize expr';
  SCShClassHelperType = 'class helper type';
  SCShRecordHelperType = 'record helper type';
  SCShTypeHelperType = 'type helper type';
  SCShTreeArgument = 'argument';
  SCShTreeProcedureType = 'procedure type';
  SCShTreeResultElement = 'function result';
  SCShTreeConstructorType = 'constructor type';
  SCShTreeDestructorType = 'destructor type';
  SCShTreeFunctionType = 'function type';
  SCShTreeUnresolvedTypeRef = 'unresolved type reference';
  SCShTreeVariable = 'variable';
  SCShTreeConst = 'constant';
  SCShTreeProperty = 'property';
  SCShTreeOverloadedProcedure = 'overloaded procedure';
  SCShTreeProcedure = 'procedure';
  SCShTreeFunction = 'function';
  SCShTreeOperator = 'operator';
  SCShTreeClassOperator = 'class operator';
  SCShTreeClassProcedure = 'class procedure';
  SCShTreeClassFunction = 'class function';
  SCShTreeClassConstructor = 'class constructor';
  SCShTreeClassDestructor = 'class destructor';
  SCShTreeConstructor = 'constructor';
  SCShTreeDestructor = 'destructor';
  SCShTreeAnonymousProcedure = 'anonymous procedure';
  SCShTreeAnonymousFunction = 'anonymous function';
  SCShTreeProcedureImpl = 'procedure/function implementation';
  SCShTreeConstructorImpl = 'constructor implementation';
  SCShTreeDestructorImpl = 'destructor implementation';

type
  ECShTree = Class(Exception);

  // Visitor pattern.
  TCShsTreeVisitor = class;

  { TCShElementBase }

  TCShElementBase = class
  private
    FData: TObject;
  protected
    procedure Accept(Visitor: TCShsTreeVisitor); virtual;
  public
    Property CustomData: TObject Read FData Write FData;
  end;
  TCShElementBaseClass = class of TCShElementBase;


  TCShModule = class;

  TCShMemberVisibility = (visDefault, visPrivate, visProtected, visPublic,
    visPublished, visAutomated,
    visStrictPrivate, visStrictProtected, visInternal);

  TCallingConvention = (ccDefault,ccRegister,ccCSharp,ccCDecl,ccStdCall,
                        ccOldFPCCall,ccSafeCall,ccSysCall,ccMWCSharp,
                        ccHardFloat,ccSysV_ABI_Default,ccSysV_ABI_CDecl,
                        ccMS_ABI_Default,ccMS_ABI_CDecl,
                        ccVectorCall);
  TProcTypeModifier = (ptmOfObject,ptmIsNested,ptmStatic,ptmVarargs,
                       ptmReferenceTo,ptmAsync);
  TProcTypeModifiers = set of TProcTypeModifier;
  TPackMode = (pmNone,pmPacked,pmBitPacked);

  TCShMemberVisibilities = set of TCShMemberVisibility;
  TCShMemberHint = (hDeprecated,hLibrary,hPlatform,hExperimental,hUnimplemented);
  TCShMemberHints = set of TCShMemberHint; 

  TCShElement = class;
  TCShTreeElement = class of TCShElement;

  TOnForEachCShElement = procedure(El: TCShElement; arg: pointer) of object;

  { TCShElement }

  TCShElement = class(TCShElementBase)
  private
    FDocComment: String;
    FRefCount: LongWord;
    FName: string;
    FParent: TCShElement;
    FHints : TCShMemberHints;
    FHintMessage : String;
    {$ifdef pas2js}
    FCShElementId: NativeInt;
    class var FLastCShElementId: NativeInt;
    {$endif}
    {$ifdef EnableCShTreeGlobalRefCount}
    class var FGlobalRefCount: NativeInt;
    {$endif}
  protected
    procedure ProcessHints(const ASemiColonPrefix: boolean; var AResult: string); virtual;
    procedure SetParent(const AValue: TCShElement); virtual;
  public
    SourceFilename: string;
    SourceLinenumber: Integer;
    SourceEndLinenumber: Integer;
    Visibility: TCShMemberVisibility;
    {$IFDEF CheckCShTreeRefCount}
  public
    RefIds: TStringList;
    NextRefEl, PrevRefEl: TCShElement;
    class var FirstRefEl, LastRefEl: TCShElement;
    procedure ChangeRefId(const OldId, NewId: string);
    {$ENDIF}
    constructor Create(const AName: string; AParent: TCShElement); virtual;
    destructor Destroy; override;
    Class Function IsKeyWord(Const S : String) : Boolean;
    Class Function EscapeKeyWord(Const S : String) : String;
    procedure AddRef{$IFDEF CheckCShTreeRefCount}(const aId: string){$ENDIF};
    procedure Release{$IFDEF CheckCShTreeRefCount}(const aId: string){$ENDIF};
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); virtual;
    procedure ForEachChildCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer; Child: TCShElement; CheckParent: boolean); virtual;
    Function SafeName : String; virtual;                // Name but with & prepended if name is a keyword.
    function FullPath: string;                  // parent's names, until parent is not TCShDeclarations
    function ParentPath: string;                // parent's names
    function FullName: string; virtual;         // FullPath + Name
    function PathName: string; virtual;         // = Module.Name + ParentPath
    function GetModule: TCShModule;
    function ElementTypeName: string; virtual;
    Function HintsString : String;
    function GetDeclaration(full : Boolean) : string; virtual;
    procedure Accept(Visitor: TCShsTreeVisitor); override;
    procedure ClearTypeReferences(aType: TCShElement); virtual;
    function HasParent(aParent: TCShElement): boolean;
    property RefCount: LongWord read FRefCount;
    property Name: string read FName write FName;
    property Parent: TCShElement read FParent Write SetParent;
    property Hints : TCShMemberHints Read FHints Write FHints;
    property HintMessage : String Read FHintMessage Write FHintMessage;
    property DocComment : String Read FDocComment Write FDocComment;
    {$ifdef pas2js}
    property CShElementId: NativeInt read FCShElementId; // global unique id
    {$endif}
    {$ifdef EnableCShTreeGlobalRefCount}
    class property GlobalRefCount: NativeInt read FGlobalRefCount write FGlobalRefCount;
    {$endif}
  end;
  TCShElementArray = array of TCShElement;

  TCShExprKind = (pekIdent, pekNumber, pekString, pekSet, pekNull, pekBoolConst,
     pekRange, pekUnary, pekBinary, pekFuncParams, pekArrayParams, pekListOfExp,
     pekInherited, pekThis, pekSpecialize, pekProcedure);

  TExprOpCode = (eopNone,
                 eopAdd,eopInc,eopSubtract,eopDec,eopMultiply,eopDivide{/}, eopMod, eopPower,// arithmetic
                 eopShr,eopShl, // bit operations
                 eopNot,eopSingleAnd,eopAnd,eopSingleOr,eopOr,eopXor,eopKomplement, // logical/bit
                 eopEqual, eopNotEqual,eopAsk, eopAskAsk,  // Logical
                 eopLessThan,eopGreaterThan, eopLessthanEqual,eopGreaterThanEqual, // ordering
                 eopIn,eopIs,eopAs, eopSymmetricaldifference,eopLampda, // Specials
//                 eopAddress, eopDeref, eopMemAddress, // Pointers  eopMemAddress=**
                 eopSubIdent); // SomeRec.A, A is subIdent of SomeRec

  { TCShExpr }

  TCShExpr = class(TCShElement)
    Kind      : TCShExprKind;
    OpCode    : TExprOpCode;
    format1,format2 : TCShExpr; // write, writeln, str
    constructor Create(AParent : TCShElement; AKind: TCShExprKind; AOpCode: TExprOpCode); virtual; overload;
    destructor Destroy; override;
  end;

  { TUnaryExpr }

  TUnaryExpr = class(TCShExpr)
    Operand   : TCShExpr;
    constructor Create(AParent : TCShElement; AOperand: TCShExpr; AOpCode: TExprOpCode); overload;
    function GetDeclaration(full : Boolean) : string; override;
    destructor Destroy; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  { TBinaryExpr }

  TBinaryExpr = class(TCShExpr)
    left      : TCShExpr;
    right     : TCShExpr;
    constructor Create(AParent : TCShElement; xleft, xright: TCShExpr; AOpCode: TExprOpCode); overload;
    constructor CreateRange(AParent : TCShElement; xleft, xright: TCShExpr); overload;
    function GetDeclaration(full : Boolean) : string; override;
    destructor Destroy; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    class function IsRightSubIdent(El: TCShElement): boolean;
  end;

  { TPrimitiveExpr }

  TPrimitiveExpr = class(TCShExpr)
    Value     : String;
    constructor Create(AParent : TCShElement; AKind: TCShExprKind; const AValue : string); overload;
    function GetDeclaration(full : Boolean) : string; override;
  end;
  
  { TBoolConstExpr }

  TBoolConstExpr = class(TCShExpr)
    Value     : Boolean;
    constructor Create(AParent : TCShElement; AKind: TCShExprKind; const ABoolValue : Boolean); overload;
    function GetDeclaration(full : Boolean) : string; override;
  end;

  { TNullExpr }

  TNullExpr = class(TCShExpr)
    constructor Create(AParent : TCShElement); overload;
    function GetDeclaration(full : Boolean) : string; override;
  end;

  { TInheritedExpr }

  TInheritedExpr = class(TCShExpr)
  Public
    constructor Create(AParent : TCShElement); overload;
    function GetDeclaration(full : Boolean) : string; override;
  end;

  { TThisExpr }

  TThisExpr = class(TCShExpr)
    constructor Create(AParent : TCShElement); overload;
    function GetDeclaration(full : Boolean) : string; override;
  end;

  TCShExprArray = array of TCShExpr;

  { TParamsExpr - source position is the opening bracket }

  TParamsExpr = class(TCShExpr)
    Value     : TCShExpr;
    Params    : TCShExprArray;
    // Kind: pekArrayParams, pekFuncParams, pekSet
    constructor Create(AParent : TCShElement; AKind: TCShExprKind); overload;
    function GetDeclaration(full : Boolean) : string; override;
    destructor Destroy; override;
    procedure AddParam(xp: TCShExpr);
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  { TRecordValues }

  TRecordValuesItem = record
    Name      : String;
    NameExp   : TPrimitiveExpr;
    ValueExp  : TCShExpr;
  end;
  PRecordValuesItem = ^TRecordValuesItem;
  TRecordValuesItemArray = array of TRecordValuesItem;

  TRecordValues = class(TCShExpr)
    Fields    : TRecordValuesItemArray;
    constructor Create(AParent : TCShElement); overload;
    destructor Destroy; override;
    procedure AddField(AName: TPrimitiveExpr; Value: TCShExpr);
    function GetDeclaration(full : Boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  { TArrayValues }

  TArrayValues = class(TCShExpr)
    Values    : TCShExprArray;
    constructor Create(AParent : TCShElement); overload;
    destructor Destroy; override;
    procedure AddValues(AValue: TCShExpr);
    function GetDeclaration(full : Boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  { TCShDeclarations - base class of TCShSection, TProcedureBody }

  TCShDeclarations = class(TCShElement)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Declarations: TFPList; // list of TCShElement
    // Declarations contains all the following:
    Attributes, // TCShAttributes
    Classes,    // TCShClassType, TCShRecordType
    Consts,     // TCShConst
    ExportSymbols,// TCShExportSymbol
    Functions,  // TCShProcedure
    Properties, // TCShProperty
    ResStrings, // TCShResString
    Types,      // TCShType, except TCShClassType, TCShRecordType
    Variables   // TCShVariable, not descendants
      : TFPList;
  end;

  { TCShUsingNamespace - Parent is TCShSection }

  TCShUsingNamespace = class(TCShElement)
  public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Expr: TCShExpr; // name expression
    InFilename: TPrimitiveExpr; // Kind=pekString, can be nil
    Module: TCShElement; // TCShUnresolvedUnitRef or TCShModule
  end;
  TCShUsesClause = array of TCShUsingNamespace;

  { TCShSection }

  TCShSection = class(TCShDeclarations)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function AddUnitToUsesList(const AUnitName: string; aName: TCShExpr = nil;
      InFilename: TPrimitiveExpr = nil; aModule: TCShElement = nil;
      UsesUnit: TCShUsingNamespace = nil): TCShUsingNamespace;
    function ElementTypeName: string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ReleaseUsedNamespaces;
  public
    UsesList: TFPList; // kept for compatibility, see TCShUsingNamespace.Module
    UsesClause: TCShUsesClause;
    PendingUsedIntf: TCShUsingNamespace; // <>nil while resolving a uses cycle
  end;
  TCShSectionClass = class of TCShSection;

  { TImplementationSection }

  TImplementationSection = class(TCShSection)
  public
    // Its only a class between, because the whole file is an implementation-section.
  end;

  { TProgramSection }

  TProgramSection = class(TImplementationSection)
  public
    function ElementTypeName: string; override;
  end;

  { TLibrarySection }

  TLibrarySection = class(TImplementationSection)
  public
    function ElementTypeName: string; override;
  end;

  TCShImplCommandBase = class;
  TInitializationSection = class;
  TFinalizationSection = class;

  { TCShModule }

  TCShModule = class(TCShElement)
  public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ReleaseUsedNamespace; virtual;
  public
    GlobalDirectivesSection: TCShImplCommandBase; // not used by pparser
    ImplementationSection: TImplementationSection;
    InitializationSection: TInitializationSection; // in TCShProgram the begin..end.
    FinalizationSection: TFinalizationSection;
    PackageName: string;
    Filename   : String;  // the IN filename, only written when not empty.
  end;

  { TCShNamespaceModule }

  TCShNamespaceModule = Class(TCShModule)
    function ElementTypeName: string; override;
  end;

  { TCShProgram }

  TCShProgram = class(TCShModule)
  Public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ReleaseUsedNamespace; override;
  Public
    ProgramSection: TProgramSection;
    InputFile,OutPutFile : String;
    // Note: the begin..end. block is in the InitializationSection
  end;

  { TCShLibrary }

  TCShLibrary = class(TCShModule)
  Public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ReleaseUsedNamespace; override;
  Public
    LibrarySection: TLibrarySection;
    InputFile,OutPutFile : String;
  end;

  { TCShPackage }

  TCShPackage = class(TCShElement)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Modules: TFPList;     // List of TCShModule objects
  end;

  { TCShResString }

  TCShResString = class(TCShElement)
  public
    Destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : Boolean) : string; Override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Expr: TCShExpr;
  end;

  { TCShType }

  TCShType = class(TCShElement)
  Protected
    Function FixTypeDecl(aDecl: String) : String;
  public
    Function SafeName : String; override;
    function ElementTypeName: string; override;
  end;
  TCShTypeArray = array of TCShType;

  { TCShAliasType }

  TCShAliasType = class(TCShType)
  protected
    procedure SetParent(const AValue: TCShElement); override;
  public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : Boolean): string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ClearTypeReferences(aType: TCShElement); override;
  public
    DestType: TCShType;
    Expr: TCShExpr;
  end;

  { TCShPointerType - todo: change it TCShAliasType }

  TCShPointerType = class(TCShType)
  protected
    procedure SetParent(const AValue: TCShElement); override;
  public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : Boolean): string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ClearTypeReferences(aType: TCShElement); override;
  public
    DestType: TCShType;
  end;

  { TCShTypeAliasType }

  TCShTypeAliasType = class(TCShAliasType)
  public
    function ElementTypeName: string; override;
  end;

  { TCShGenericTemplateType - type param of a generic }

  TCShGenericTemplateType = Class(TCShType)
  protected
    procedure SetParent(const AValue: TCShElement); override;
  public
    destructor Destroy; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure AddConstraint(El: TCShElement);
    procedure ClearConstraints;
  Public
    TypeConstraint: String deprecated; // deprecated in fpc 3.3.1
    Constraints: TCShElementArray; // list of TCShExpr or TCShType, can be nil!
  end;

  { TCShGenericType - abstract base class for all types which can be generics }

  TCShGenericType = class(TCShType)
  private
    procedure ClearChildReferences(El: TCShElement; arg: pointer);
  protected
    procedure SetParent(const AValue: TCShElement); override;
  public
    GenericTemplateTypes: TFPList; // list of TCShGenericTemplateType, can be nil
    destructor Destroy; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure SetGenericTemplates(AList: TFPList); virtual;
  end;

  { TCShSpecializeType DestType<Params> }

  TCShSpecializeType = class(TCShAliasType)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full: boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Params: TFPList; // list of TCShType or TCShExpr
  end;

  { TInlineSpecializeExpr - A<B,C> }

  TInlineSpecializeExpr = class(TCShExpr)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : Boolean): string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    NameExpr: TCShExpr;
    Params: TFPList; // list of TCShType
  end;

  { TCShClassOfType }

  TCShClassOfType = class(TCShAliasType)
  public
    function ElementTypeName: string; override;
    function GetDeclaration(full: boolean) : string; override;
  end;

  { TCShRangeType }

  TCShRangeType = class(TCShType)
  public
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    RangeExpr : TBinaryExpr; // Kind=pekRange
    Destructor Destroy; override;
    Function RangeStart : String;
    Function RangeEnd : String;
  end;

  { TCShArrayType }

  TCShArrayType = class(TCShGenericType)
  protected
    procedure SetParent(const AValue: TCShElement); override;
  public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
  public
    IndexRange : string; // only valid if Parser po_arrayrangeexpr disabled
    Ranges: TCShExprArray; // only valid if Parser po_arrayrangeexpr enabled
    PackMode : TPackMode;
    ElType: TCShType; // nil means array-of-const
    function IsGenericArray : Boolean; inline;
    function IsPacked : Boolean; inline;
    procedure AddRange(Range: TCShExpr);
  end;

  { TCShFileType }

  TCShFileType = class(TCShType) {deprecated 'CSharp has no file-types or files of a type';}
  public
    destructor Destroy; override;
    function GetDeclaration(full : boolean) : string; override; deprecated 'CSharp has no file-types or files of a type';
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    ElType: TCShType;
  end;

  { TCShEnumValue - Parent is TCShEnumType }

  TCShEnumValue = class(TCShElement)
  public
    function ElementTypeName: string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Value: TCShExpr;
    Destructor Destroy; override;
    Function AssignedValue : string;
  end;

  { TCShEnumType }

  TCShEnumType = class(TCShType)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    Procedure GetEnumNames(Names : TStrings);
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Values: TFPList;      // List of TCShEnumValue
  end;

  { TCShSetType }

  TCShSetType = class(TCShType)
  public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    EnumType: TCShType;
    IsPacked : Boolean;
  end;

  TCShRecordType = class;

  { TCShVariant }

  TCShVariant = class(TCShElement)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Values: TFPList; // list of TCShElement
    Members: TCShRecordType;
  end;

  { TCShMembersType - base type for TCShRecordType and TCShClassType }

  TCShMembersType = class(TCShGenericType)
  public
    PackMode: TPackMode;
    Members: TFPList;
    Constructor Create(const AName: string; AParent: TCShElement); override;
    Destructor Destroy; override;
    Function IsPacked: Boolean; inline;
    Function IsBitPacked : Boolean; inline;
    Procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  { TCShRecordType }

  TCShRecordType = class(TCShMembersType)
  private
    procedure GetMembers(S: TStrings);
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    VariantEl: TCShElement; // nil or TCShVariable or TCShType
    Variants: TFPList;	// list of TCShVariant elements, may be nil!
    Function IsAdvancedRecord : Boolean;
  end;

  TCShObjKind = (
    okObject, okClass, okInterface,
    // okGeneric  removed in FPC 3.3.1  check instead GenericTemplateTypes<>nil
    // okSpecialize removed in FPC 3.1.1
    okClassHelper, okRecordHelper, okTypeHelper,
    okDispInterface, okObjcClass, okObjcCategory,
    okObjcProtocol);
const
  okWithFields = [okObject, okClass, okObjcClass, okObjcCategory];
  okAllHelpers = [okClassHelper,okRecordHelper,okTypeHelper];
  okWithClassFields = okWithFields+okAllHelpers;
  okObjCClasses = [okObjcClass, okObjcCategory, okObjcProtocol];

type

  TCShClassInterfaceType = (
    citCom, // default
    citCorba
    );

  { TCShClassType }

  TCShClassType = class(TCShMembersType)
  protected
    procedure SetParent(const AValue: TCShElement); override;
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    ObjKind: TCShObjKind;
    AncestorType: TCShType;   // TCShClassType or TCShUnresolvedTypeRef or TCShAliasType or TCShTypeAliasType
                              // Note: AncestorType can be nil even though it has a default ancestor
    HelperForType: TCShType;  // any type, except helper
    IsForward: Boolean;
    IsExternal : Boolean;
    IsShortDefinition: Boolean;//class(anchestor); without end
    GUIDExpr : TCShExpr;
    Modifiers: TStringList;
    Interfaces : TFPList; // list of TCShType
    ExternalNameSpace : String;
    ExternalName : String;
    InterfaceType: TCShClassInterfaceType;
    Function IsObjCClass : Boolean;
    Function FindMember(MemberClass : TCShTreeElement; Const MemberName : String) : TCShElement;
    Function FindMemberInAncestors(MemberClass : TCShTreeElement; Const MemberName : String) : TCShElement;
    Function InterfaceGUID : string;
    Function IsSealed : Boolean;
    Function IsAbstract : Boolean;
    Function HasModifier(const aModifier: String): Boolean;
  end;

  TArgumentAccess = (argDefault, argConst, argVar, argOut, argConstRef);

  { TCShArgument }

  TCShArgument = class(TCShElement)
  public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ClearTypeReferences(aType: TCShElement); override;
  public
    Access: TArgumentAccess;
    ArgType: TCShType; // can be nil, when Access<>argDefault
    ValueExpr: TCShExpr; // the default value
    Function Value : String;
  end;

  { TCShProcedureType }

  TCShProcedureType = class(TCShGenericType)
  private
    function GetIsAsync: Boolean; inline;
    function GetIsNested: Boolean; inline;
    function GetIsOfObject: Boolean; inline;
    function GetIsReference: Boolean; inline;
    procedure SetIsAsync(const AValue: Boolean);
    procedure SetIsNested(const AValue: Boolean);
    procedure SetIsOfObject(const AValue: Boolean);
    procedure SetIsReference(AValue: Boolean);
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    class function TypeName: string; virtual;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure GetArguments(List : TStrings);
    function CreateArgument(const AName, AUnresolvedTypeName: string): TCShArgument; // not used by TCShParser
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Args: TFPList;        // List of TCShArgument objects
    CallingConvention: TCallingConvention;
    Modifiers: TProcTypeModifiers;
    VarArgsType: TCShType;
    property IsOfObject: Boolean read GetIsOfObject write SetIsOfObject;
    property IsNested : Boolean read GetIsNested write SetIsNested;
    property IsReferenceTo : Boolean Read GetIsReference write SetIsReference;
    property IsAsync: Boolean read GetIsAsync write SetIsAsync;
  end;
  TCShProcedureTypeClass = class of TCShProcedureType;

  { TCShResultElement - parent is TCShFunctionType }

  TCShResultElement = class(TCShElement)
  public
    destructor Destroy; override;
    function ElementTypeName : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ClearTypeReferences(aType: TCShElement); override;
  public
    ResultType: TCShType;
  end;

  { TCShFunctionType }

  TCShFunctionType = class(TCShProcedureType)
  public
    destructor Destroy; override;
    class function TypeName: string; override;
    function ElementTypeName: string; override;
    function GetDeclaration(Full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    ResultEl: TCShResultElement;
  end;

  TCShUnresolvedSymbolRef = class(TCShType)
  end;

  TCShUnresolvedTypeRef = class(TCShUnresolvedSymbolRef)
  public
    // Typerefs cannot be parented! -> AParent _must_ be NIL
    constructor Create(const AName: string; AParent: TCShElement); override;
    function ElementTypeName: string; override;
  end;

  { TCShUnresolvedUnitRef }

  TCShUnresolvedUnitRef = Class(TCShUnresolvedSymbolRef)
  public
    FileName : string;
    function ElementTypeName: string; override;
  end;

  { TCShStringType - e.g. string[len] }

  TCShStringType = class(TCShUnresolvedTypeRef)
  public
    LengthExpr : String;
    function ElementTypeName: string; override;
  end;

  { TCShTypeRef  - not used by TCShParser }

  TCShTypeRef = class(TCShUnresolvedTypeRef)
  public
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    RefType: TCShType;
  end;

  { TCShVariable }
  TVariableModifier = (vmCVar, vmExternal, vmPublic, vmExport, vmClass, vmStatic, vmInternal);
  TVariableModifiers = set of TVariableModifier;

  TCShVariable = class(TCShElement)
  public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ClearTypeReferences(aType: TCShElement); override;
  public
    VarType: TCShType;
    VarModifiers : TVariableModifiers;
    LibraryName : TCShExpr; // libname of modifier external
    ExportName : TCShExpr; // symbol name of modifier external, export and public
    Modifiers : string;
    AbsoluteLocation : String deprecated; // deprecated in fpc 3.1.1
    AbsoluteExpr: TCShExpr;
    Expr: TCShExpr;
    Function Value : String;
  end;

  { TCShExportSymbol }

  TCShExportSymbol = class(TCShElement)
  public
    ExportName : TCShExpr;
    ExportIndex : TCShExpr;
    Destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  { TCShConst }

  TCShConst = class(TCShVariable)
  public
    IsConst: boolean; // true iff untyped const or typed with $WritableConst off
    function ElementTypeName: string; override;
  end;

  { TCShProperty }

  TCShProperty = class(TCShVariable)
  private
    FArgs: TFPList;
    FResolvedType : TCShType;
    function GetIsClass: boolean; inline;
    procedure SetIsClass(AValue: boolean);
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function GetDeclaration(full : boolean) : string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    IndexExpr: TCShExpr;
    ReadAccessor: TCShExpr;
    WriteAccessor: TCShExpr;
    DispIDExpr : TCShExpr;   // Can be nil.
    Implements: TCShExprArray;
    StoredAccessor: TCShExpr;
    DefaultExpr: TCShExpr;
    ReadAccessorName: string; // not used by resolver
    WriteAccessorName: string; // not used by resolver
    ImplementsName: string; // not used by resolver
    StoredAccessorName: string; // not used by resolver
    DispIDReadOnly,
    IsDefault, IsNodefault: Boolean;
    property Args: TFPList read FArgs; // List of TCShArgument objects
    property IsClass: boolean read GetIsClass write SetIsClass;
    Function ResolvedType : TCShType;
    Function IndexValue : String;
    Function DefaultValue : string;
  end;

  { TCShAttributes }

  TCShAttributes = class(TCShElement)
  public
    destructor Destroy; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure AddCall(Expr: TCShExpr);
  public
    Calls: TCShExprArray;
  end;

  TProcType = (ptProcedure, ptFunction,
               ptOperator, ptClassOperator,
               ptConstructor, ptDestructor,
               ptClassProcedure, ptClassFunction,
               ptClassConstructor, ptClassDestructor,
               ptAnonymousProcedure, ptAnonymousFunction);

  { TCShProcedureBase }

  TCShProcedureBase = class(TCShElement)
  public
    function TypeName: string; virtual; abstract;
  end;

  { TCShOverloadedProc - not used by resolver }

  TCShOverloadedProc = class(TCShProcedureBase)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function TypeName: string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Overloads: TFPList;           // List of TCShProcedure nodes
  end;

  { TCShProcedure }

  TProcedureModifier = (pmVirtual, pmDynamic, pmAbstract, pmOverride,
                        pmExport, pmOverload, pmMessage, pmReintroduce,
                        pmInline, pmAssembler, pmPublic,
                        pmCompilerProc, pmExternal, pmForward, pmDispId,
                        pmNoReturn, pmFar, pmFinal);
  TProcedureModifiers = Set of TProcedureModifier;
  TProcedureMessageType = (pmtNone,pmtInteger,pmtString);

  { TProcedureNamePart }

  TProcedureNamePart = class
    Name: string;
    Templates: TFPList; // optional list of TCShGenericTemplateType, can be nil!
  end;
  TProcedureNameParts = TFPList; // list of TProcedureNamePart
                        
  TProcedureBody = class;

  { TCShProcedure - named procedure, not anonymous }

  TCShProcedure = class(TCShProcedureBase)
  Private
    FModifiers : TProcedureModifiers;
    FMessageName : String;
    FMessageType : TProcedureMessageType;
    function GetCallingConvention: TCallingConvention;
    procedure SetCallingConvention(AValue: TCallingConvention);
  public
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function TypeName: string; override;
    function GetDeclaration(full: Boolean): string; override;
    procedure GetModifiers(List: TStrings);
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    PublicName, // e.g. public PublicName;
    LibrarySymbolName,
    LibraryExpr : TCShExpr; // e.g. external LibraryExpr name LibrarySymbolName;
    DispIDExpr :  TCShExpr;
    MessageExpr: TCShExpr;
    AliasName : String;
    ProcType : TCShProcedureType;
    Body : TProcedureBody;
    NameParts: TProcedureNameParts; // only used for generic aka parametrized functions
    Procedure AddModifier(AModifier : TProcedureModifier);
    Function IsVirtual : Boolean; inline;
    Function IsDynamic : Boolean; inline;
    Function IsAbstract : Boolean; inline;
    Function IsOverride : Boolean; inline;
    Function IsExported : Boolean; inline;
    Function IsExternal : Boolean; inline;
    Function IsOverload : Boolean; inline;
    Function IsMessage: Boolean; inline;
    Function IsReintroduced : Boolean; inline;
    Function IsStatic : Boolean; inline;
    Function IsForward: Boolean; inline;
    Function IsAssembler: Boolean; inline;
    Function IsAsync: Boolean; inline;
    Function GetProcTypeEnum: TProcType; virtual;
    procedure SetNameParts(Parts: TProcedureNameParts);
    Property Modifiers : TProcedureModifiers Read FModifiers Write FModifiers;
    Property CallingConvention : TCallingConvention Read GetCallingConvention Write SetCallingConvention;
    Property MessageName : String Read FMessageName Write FMessageName;
    property MessageType : TProcedureMessageType Read FMessageType Write FMessageType;
  end;
  TCShProcedureClass = class of TCShProcedure;

  TArrayOfCShProcedure = array of TCShProcedure;

  { TCShFunction - named function, not anonymous function}

  TCShFunction = class(TCShProcedure)
  private
    function GetFT: TCShFunctionType; inline;
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
    Property FuncType : TCShFunctionType Read GetFT;
    function GetProcTypeEnum: TProcType; override;
  end;

  { TCShOperator }
  TOperatorType = (
    otUnknown,
    otImplicit, otExplicit,
    otMul, otPlus, otMinus, otDivision,
    otLessThan, otEqual, otGreaterThan,
    otAssign, otNotEqual, otLessEqualThan, otGreaterEqualThan,
    otPower, otSymmetricalDifference,
    otInc, otDec,
    otMod,
    otNegative, otPositive,
    otBitWiseOr,
    otDiv,
    otLeftShift,
    otLogicalOr,
    otBitwiseAnd, otbitwiseXor,
    otLogicalAnd, otLogicalNot, otLogicalXor,
    otRightShift,
    otEnumerator, otIn
    );
  TOperatorTypes = set of TOperatorType;

  TCShOperator = class(TCShFunction)
  private
    FOperatorType: TOperatorType;
    FTokenBased: Boolean;
    function NameSuffix: String;
  public
    Class Function OperatorTypeToToken(T : TOperatorType) : String;
    Class Function OperatorTypeToOperatorName(T: TOperatorType) : String;
    Class Function TokenToOperatorType(S : String) : TOperatorType;
    Class Function NameToOperatorType(S : String) : TOperatorType;
    Procedure CorrectName;
    // For backwards compatibility the old name can still be used to search on.
    function GetOperatorDeclaration(Full: Boolean): string;
    Function OldName(WithPath : Boolean) : String;
    function ElementTypeName: string; override;
    function TypeName: string; override;
    function GetProcTypeEnum: TProcType; override;
    function GetDeclaration (full : boolean) : string; override;
    Property OperatorType : TOperatorType Read FOperatorType Write FOperatorType;
    // True if the declaration was using a token instead of an identifier
    Property TokenBased : Boolean Read FTokenBased Write FTokenBased;
  end;

  { TCShClassOperator }

  TCShClassOperator = class(TCShOperator)
  public
    function TypeName: string; override;
    function GetProcTypeEnum: TProcType; override;
  end;


  { TCShConstructor }

  TCShConstructor = class(TCShProcedure)
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
    function GetProcTypeEnum: TProcType; override;
  end;

  { TCShClassConstructor }

  TCShClassConstructor  = class(TCShConstructor)
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
    function GetProcTypeEnum: TProcType; override;
  end;

  { TCShDestructor }

  TCShDestructor = class(TCShProcedure)
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
    function GetProcTypeEnum: TProcType; override;
  end;

  { TCShClassDestructor }

  TCShClassDestructor  = class(TCShDestructor)
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
    function GetProcTypeEnum: TProcType; override;
  end;

  { TCShClassProcedure }

  TCShClassProcedure = class(TCShProcedure)
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
    function GetProcTypeEnum: TProcType; override;
  end;

  { TCShClassFunction }

  TCShClassFunction = class(TCShFunction)
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
    function GetProcTypeEnum: TProcType; override;
  end;

  { TCShAnonymousProcedure - parent is TProcedureExpr }

  TCShAnonymousProcedure = class(TCShProcedure)
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
    function GetProcTypeEnum: TProcType; override;
  end;

  { TCShAnonymousFunction - parent is TProcedureExpr and ProcType is TCShFunctionType}

  TCShAnonymousFunction = class(TCShAnonymousProcedure)
  private
    function GetFT: TCShFunctionType; inline;
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
    Property FuncType : TCShFunctionType Read GetFT;
    function GetProcTypeEnum: TProcType; override;
  end;

  { TProcedureExpr }

  TProcedureExpr = class(TCShExpr)
  public
    Proc: TCShAnonymousProcedure;
    constructor Create(AParent: TCShElement); overload;
    destructor Destroy; override;
    function GetDeclaration(full: Boolean): string; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  { TCShMethodResolution }

  TCShMethodResolution = class(TCShElement)
  public
    destructor Destroy; override;
  public
    ProcClass: TCShProcedureClass;
    InterfaceName: TCShExpr;
    InterfaceProc: TCShExpr;
    ImplementationProc: TCShExpr;
  end;

  TCShImplBlock = class;

  { TProcedureBody - the var+type+const+begin, without the header, child of TCShProcedure }

  TProcedureBody = class(TCShDeclarations)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Body: TCShImplBlock;
  end;

  { TCShProcedureImpl - used by mkxmlrpc, not by pparser }

  TCShProcedureImpl = class(TCShElement)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    function ElementTypeName: string; override;
    function TypeName: string; virtual;
  public
    ProcType: TCShProcedureType;
    Locals: TFPList;
    Body: TCShImplBlock;
    IsClassMethod: boolean;
  end;

  { TCShConstructorImpl - used by mkxmlrpc, not by pparser }

  TCShConstructorImpl = class(TCShProcedureImpl)
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
  end;

  { TCShDestructorImpl - used by mkxmlrpc, not by pparser }

  TCShDestructorImpl = class(TCShProcedureImpl)
  public
    function ElementTypeName: string; override;
    function TypeName: string; override;
  end;

  { TCShImplElement - implementation element }

  TCShImplElement = class(TCShElement)
  end;

  { TCShImplCommandBase }

  TCShImplCommandBase = class(TCShImplElement)
  public
    SemicolonAtEOL: boolean;
    constructor Create(const AName: string; AParent: TCShElement); override;
  end;

  { TCShImplCommand - currently used as empty statement, e.g. if then else ; }

  TCShImplCommand = class(TCShImplCommandBase)
  public
    Command: string; // never set by TCShParser
  end;

  { TCShImplCommands - used by mkxmlrpc, not used by pparser }

  TCShImplCommands = class(TCShImplCommandBase)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
  public
    Commands: TStrings;
  end;

  { TCShLabels }

  TCShLabels = class(TCShImplElement)
  public
    Labels: TStrings;
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
  end;

  TCShImplBeginBlock = class;
  TCShImplRepeatUntil = class;
  TCShImplIfElse = class;
  TCShImplWhileDo = class;
  TCShImplWithDo = class;
  TCShImplCaseOf = class;
  TCShImplForLoop = class;
  TCShImplTry = class;
  TCShImplExceptOn = class;
  TCShImplRaise = class;
  TCShImplAssign = class;
  TCShImplSimple = class;
  TCShImplLabelMark = class;

  { TCShImplBlock }

  TCShImplBlock = class(TCShImplElement)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    procedure AddElement(Element: TCShImplElement); virtual;
    function AddCommand(const ACommand: string): TCShImplCommand;
    function AddCommands: TCShImplCommands; // used by mkxmlrpc, not by pparser
    function AddBeginBlock: TCShImplBeginBlock;
    function AddRepeatUntil: TCShImplRepeatUntil;
    function AddIfElse(const ACondition: TCShExpr): TCShImplIfElse;
    function AddWhileDo(const ACondition: TCShExpr): TCShImplWhileDo;
    function AddWithDo(const Expression: TCShExpr): TCShImplWithDo;
    function AddCaseOf(const Expression: TCShExpr): TCShImplCaseOf;
    function AddForLoop(AVar: TCShVariable;
      const AStartValue, AEndValue: TCShExpr): TCShImplForLoop;
    function AddForLoop(AVarName : TCShExpr; AStartValue, AEndValue: TCShExpr;
      ADownTo: Boolean = false): TCShImplForLoop;
    function AddTry: TCShImplTry;
    function AddExceptOn(const VarName, TypeName: string): TCShImplExceptOn;
    function AddExceptOn(const VarName: string; VarType: TCShType): TCShImplExceptOn;
    function AddExceptOn(const VarEl: TCShVariable): TCShImplExceptOn;
    function AddExceptOn(const TypeEl: TCShType): TCShImplExceptOn;
    function AddRaise: TCShImplRaise;
    function AddLabelMark(const Id: string): TCShImplLabelMark;
    function AddAssign(left, right: TCShExpr): TCShImplAssign;
    function AddSimple(exp: TCShExpr): TCShImplSimple;
    function CloseOnSemicolon: boolean; virtual;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Elements: TFPList;    // list of TCShImplElement
  end;
  TCShImplBlockClass = class of TCShImplBlock;

  { TCShImplStatement - base class }

  TCShImplStatement = class(TCShImplBlock)
  public
    function CloseOnSemicolon: boolean; override;
  end;

  { TCShImplBeginBlock }

  TCShImplBeginBlock = class(TCShImplBlock)
  end;

  { TInitializationSection }

  TInitializationSection = class(TCShImplBlock)
  end;

  { TFinalizationSection }

  TFinalizationSection = class(TCShImplBlock)
  end;

  { TCShImplAsmStatement }

  TCShImplAsmStatement = class (TCShImplStatement)
  private
    FTokens: TStrings;
  Public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    Property Tokens : TStrings Read FTokens;
  end;

  { TCShImplRepeatUntil }

  TCShImplRepeatUntil = class(TCShImplBlock)
  public
    ConditionExpr : TCShExpr;
    destructor Destroy; override;
    Function Condition: string;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  { TCShImplIfElse }

  TCShImplIfElse = class(TCShImplBlock)
  public
    destructor Destroy; override;
    procedure AddElement(Element: TCShImplElement); override;
    function CloseOnSemicolon: boolean; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    ConditionExpr: TCShExpr;
    IfBranch: TCShImplElement;
    ElseBranch: TCShImplElement; // can be nil
    Function Condition: string;
  end;

  { TCShImplWhileDo }

  TCShImplWhileDo = class(TCShImplStatement)
  public
    destructor Destroy; override;
    procedure AddElement(Element: TCShImplElement); override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    ConditionExpr : TCShExpr;
    Body: TCShImplElement;
    function Condition: string;
  end;

  { TCShImplWithDo }

  TCShImplWithDo = class(TCShImplStatement)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    procedure AddElement(Element: TCShImplElement); override;
    procedure AddExpression(const Expression: TCShExpr);
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Expressions: TFPList; // list of TCShExpr
    Body: TCShImplElement;
  end;

  TCShImplCaseStatement = class;
  TCShImplCaseElse = class;

  { TCShImplCaseOf - Elements are TCShImplCaseStatement }

  TCShImplCaseOf = class(TCShImplBlock)
  public
    destructor Destroy; override;
    procedure AddElement(Element: TCShImplElement); override;
    function AddCase(const Expression: TCShExpr): TCShImplCaseStatement;
    function AddElse: TCShImplCaseElse;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    CaseExpr : TCShExpr;
    ElseBranch: TCShImplCaseElse; // this is also in Elements
    function Expression: string;
  end;

  { TCShImplCaseStatement }

  TCShImplCaseStatement = class(TCShImplStatement)
  public
    constructor Create(const AName: string; AParent: TCShElement); override;
    destructor Destroy; override;
    procedure AddElement(Element: TCShImplElement); override;
    procedure AddExpression(const Expr: TCShExpr);
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    Expressions: TFPList; // list of TCShExpr
    Body: TCShImplElement;
  end;

  { TCShImplCaseElse }

  TCShImplCaseElse = class(TCShImplBlock)
  end;

  { TCShImplForLoop
    - for VariableName in StartExpr do Body
    - for VariableName := StartExpr to EndExpr do Body }

  TLoopType = (ltNormal,ltDown,ltIn);
  TCShImplForLoop = class(TCShImplStatement)
  public
    destructor Destroy; override;
    procedure AddElement(Element: TCShImplElement); override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    VariableName : TCShExpr;
    LoopType : TLoopType;
    StartExpr : TCShExpr;
    EndExpr : TCShExpr; // if LoopType=ltIn this is nil
    Body: TCShImplElement;
    Variable: TCShVariable; // not used by TCShParser
    Function Down: boolean; inline;// downto, backward compatibility
    Function StartValue : String;
    Function EndValue: string;
  end;

  { TCShImplAssign }

  TAssignKind = (akDefault,akAdd,akMinus,akMul,akDivision);
  TCShImplAssign = class (TCShImplStatement)
  public
    left  : TCShExpr;
    right : TCShExpr;
    Kind : TAssignKind;
    Destructor Destroy; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  { TCShImplSimple }

  TCShImplSimple = class (TCShImplStatement)
  public
    Expr  : TCShExpr;
    Destructor Destroy; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  end;

  TCShImplTryHandler = class;
  TCShImplTryFinally = class;
  TCShImplTryExcept = class;
  TCShImplTryExceptElse = class;

  { TCShImplTry }

  TCShImplTry = class(TCShImplBlock)
  public
    destructor Destroy; override;
    function AddFinally: TCShImplTryFinally;
    function AddExcept: TCShImplTryExcept;
    function AddExceptElse: TCShImplTryExceptElse;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  public
    FinallyExcept: TCShImplTryHandler; // not in Elements
    ElseBranch: TCShImplTryExceptElse; // not in Elements
  end;

  TCShImplTryHandler = class(TCShImplBlock)
  end;

  { TCShImplTryFinally }

  TCShImplTryFinally = class(TCShImplTryHandler)
  end;

  { TCShImplTryExcept }

  TCShImplTryExcept = class(TCShImplTryHandler)
  end;

  { TCShImplTryExceptElse }

  TCShImplTryExceptElse = class(TCShImplTryHandler)
  end;

  { TCShImplExceptOn - Parent is TCShImplTryExcept }

  TCShImplExceptOn = class(TCShImplStatement)
  public
    destructor Destroy; override;
    procedure AddElement(Element: TCShImplElement); override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
    procedure ClearTypeReferences(aType: TCShElement); override;
  public
    VarEl: TCShVariable; // can be nil
    TypeEl : TCShType; // if VarEl<>nil then TypeEl=VarEl.VarType
    Body: TCShImplElement;
    Function VariableName : String;
    Function TypeName: string;
  end;

  { TCShImplRaise }

  TCShImplRaise = class(TCShImplStatement)
  public
    destructor Destroy; override;
    procedure ForEachCall(const aMethodCall: TOnForEachCShElement;
      const Arg: Pointer); override;
  Public
    ExceptObject,
    ExceptAddr : TCShExpr;
  end;

  { TCShImplLabelMark }

  TCShImplLabelMark = class(TCShImplElement)
  public
    LabelId: String;
  end;

  { TCShsTreeVisitor }

  TCShsTreeVisitor = class
  public
    procedure Visit(obj: TCShElement); virtual;
  end;

const
  AccessNames: array[TArgumentAccess] of string{$ifdef fpc}[9]{$endif} = ('', 'const ', 'var ', 'out ','constref ');
  AccessDescriptions: array[TArgumentAccess] of string{$ifdef fpc}[9]{$endif} = ('default', 'const', 'var', 'out','constref');
  AllVisibilities: TCShMemberVisibilities =
     [visDefault, visPrivate, visProtected, visPublic,
      visPublished, visAutomated];

  VisibilityNames: array[TCShMemberVisibility] of string = (
    'default','private', 'protected', 'public', 'published', 'automated',
    'strict private', 'strict protected','internal');

  ObjKindNames: array[TCShObjKind] of string = (
    'object', 'class', 'interface',
    'class helper','record helper','type helper',
    'dispinterface', 'ObjcClass', 'ObjcCategory',
    'ObjcProtocol');

  InterfaceTypeNames: array[TCShClassInterfaceType] of string = (
    'COM',
    'Corba'
    );

  ExprKindNames : Array[TCShExprKind] of string = (
      'Ident',
      'Number',
      'String',
      'Set',
      'Nil',
      'BoolConst',
      'Range',
      'Unary',
      'Binary',
      'FuncParams',
      'ArrayParams',
      'ListOfExp',
      'Inherited',
      'Self',
      'Specialize',
      'Procedure');

  OpcodeStrings : Array[TExprOpCode] of string = (
        '','+','++','-','--','*','/','%','**',
        '>>','<<',
        '!','&','&&','|','||','^','~',
        '=','!=','?','??',
        '<','>','<=','>=',
        'in','is','as','><','=>',
 //       '@','^','@@',
        '.');


  UnaryOperators = [otImplicit,otExplicit,otAssign,otNegative,otPositive,otEnumerator];

  OperatorTokens : Array[TOperatorType] of string
       =  ('','','','*','+','-','/','<','=',
           '>',':=','<>','<=','>=','**',
           '><','Inc','Dec','mod','-','+','Or','div',
           'shl','or','and','xor','and','not','xor',
           'shr','enumerator','in');
  OperatorNames : Array[TOperatorType] of string
       =  ('','implicit','explicit','multiply','add','subtract','divide','lessthan','equal',
           'greaterthan','assign','notequal','lessthanorequal','greaterthanorequal','power',
           'symmetricaldifference','inc','dec','modulus','negative','positive','bitwiseor','intdivide',
           'leftshift','logicalor','bitwiseand','bitwisexor','logicaland','logicalnot','logicalxor',
           'rightshift','enumerator','in');

  AssignKindNames : Array[TAssignKind] of string = (':=','+=','-=','*=','/=' );

  cCShMemberHint : Array[TCShMemberHint] of string =
      ( 'deprecated', 'library', 'platform', 'experimental', 'unimplemented' );
  cCallingConventions : Array[TCallingConvention] of string =
      ( '', 'Register','Pascal','cdecl','stdcall','OldFPCCall','safecall','SysCall','MWPascal',
                        'HardFloat','SysV_ABI_Default','SysV_ABI_CDecl',
                        'MS_ABI_Default','MS_ABI_CDecl',
                        'VectorCall');
  ProcTypeModifiers : Array[TProcTypeModifier] of string =
      ('of Object', 'is nested','static','varargs','reference to','async');

  ModifierNames : Array[TProcedureModifier] of string
                = ('virtual', 'dynamic','abstract', 'override',
                   'export', 'overload', 'message', 'reintroduce',
                   'inline','assembler','public',
                   'compilerproc','external','forward','dispid',
                   'noreturn','far','final');

  VariableModifierNames : Array[TVariableModifier] of string
     = ('cvar', 'external', 'public', 'export', 'class', 'static', 'internal');

procedure ReleaseAndNil(var El: TCShElement {$IFDEF CheckCShTreeRefCount}; const Id: string{$ENDIF}); overload;
procedure ReleaseGenericTemplateTypes(var GenericTemplateTypes: TFPList{$IFDEF CheckCShTreeRefCount}; const Id: string{$ENDIF});
procedure ReleaseElementList(ElList: TFPList{$IFDEF CheckCShTreeRefCount}; const Id: string{$ENDIF});
function GenericTemplateTypesAsString(List: TFPList): string;
procedure ReleaseProcNameParts(var NameParts: TProcedureNameParts);

function dbgs(const s: TProcTypeModifiers): string; overload;

{$IFDEF HasPTDumpStack}
procedure PTDumpStack;
function GetPTDumpStack: string;
{$ENDIF}

implementation


procedure ReleaseAndNil(var El: TCShElement {$IFDEF CheckCShTreeRefCount}; const Id: string{$ENDIF});
begin
  if El=nil then exit;
  {$IFDEF VerboseCShTreeMem}writeln('ReleaseAndNil ',El.Name,' ',El.ClassName);{$ENDIF}
  El.Release{$IFDEF CheckCShTreeRefCount}(Id){$ENDIF};
  El:=nil;
end;

procedure ReleaseGenericTemplateTypes(var GenericTemplateTypes: TFPList{$IFDEF CheckCShTreeRefCount}; const Id: string{$ENDIF});
var
  i: Integer;
  El: TCShElement;
begin
  if GenericTemplateTypes=nil then exit;
  for i := 0 to GenericTemplateTypes.Count - 1 do
    begin
    El:=TCShElement(GenericTemplateTypes[i]);
    El.Parent:=nil;
    El.Release{$IFDEF CheckCShTreeRefCount}(Id){$ENDIF};
    end;
  FreeAndNil(GenericTemplateTypes);
end;

procedure ReleaseElementList(ElList: TFPList{$IFDEF CheckCShTreeRefCount}; const Id: string{$ENDIF});
var
  i: Integer;
  El: TCShElement;
begin
  if ElList=nil then exit;
  for i := 0 to ElList.Count - 1 do
    begin
    El:=TCShElement(ElList[i]);
    if El<>nil then
      El.Release{$IFDEF CheckCShTreeRefCount}(Id){$ENDIF};
    end;
  ElList.Clear;
end;

function GenericTemplateTypesAsString(List: TFPList): string;
var
  i, j: Integer;
  T: TCShGenericTemplateType;
begin
  Result:='';
  for i:=0 to List.Count-1 do
    begin
    if i>0 then
      Result:=Result+',';
    T:=TCShGenericTemplateType(List[i]);
    Result:=Result+T.Name;
    if length(T.Constraints)>0 then
      begin
      Result:=Result+':';
      for j:=0 to length(T.Constraints)-1 do
        begin
        if j>0 then
          Result:=Result+',';
        Result:=Result+T.GetDeclaration(false);
        end;
      end;
    end;
  Result:='<'+Result+'>';
end;

procedure ReleaseProcNameParts(var NameParts: TProcedureNameParts);
var
  El: TCShElement;
  i, j: Integer;
  Part: TProcedureNamePart;
begin
  if NameParts=nil then exit;
  for i := NameParts.Count-1 downto 0 do
    begin
    Part:=TProcedureNamePart(NameParts[i]);
    if Part.Templates<>nil then
      begin
      for j:=0 to Part.Templates.Count-1 do
        begin
        El:=TCShGenericTemplateType(Part.Templates[j]);
        El.Parent:=nil;
        El.Release{$IFDEF CheckCShTreeRefCount}('TCShProcedure.NameParts'){$ENDIF};
        end;
      Part.Templates.Free;
      Part.Templates:=nil;
      end;
    NameParts.Delete(i);
    Part.Free;
    end;
  NameParts.Free;
  NameParts:=nil;
end;

function dbgs(const s: TProcTypeModifiers): string;
var
  m: TProcTypeModifier;
begin
  Result:='';
  for m in s do
    begin
    if Result<>'' then Result:=Result+',';
    Result:=Result+ProcTypeModifiers[m];
    end;
  Result:='['+Result+']';
end;

Function IndentStrings(S : TStrings; indent : Integer) : string;
Var
  I,CurrLen,CurrPos : Integer;
begin
  Result:='';
  CurrLen:=0;
  CurrPos:=0;
  For I:=0 to S.Count-1 do
    begin
    CurrLen:=Length(S[i]);
    If (CurrLen+CurrPos)>72 then
      begin
      Result:=Result+LineEnding+StringOfChar(' ',Indent);
      CurrPos:=Indent;
      end;
    Result:=Result+S[i];
    CurrPos:=CurrPos+CurrLen;
    end;
end;

{ TCShGenericType }

procedure TCShGenericType.ClearChildReferences(El: TCShElement; arg: pointer);
begin
  El.ClearTypeReferences(Self);
  if arg=nil then ;
end;

procedure TCShGenericType.SetParent(const AValue: TCShElement);
begin
  if (AValue=nil) and (Parent<>nil) then
    begin
    // parent is cleared
    // -> clear all child references to this array (releasing loops)
    ForEachCall(@ClearChildReferences,nil);
    end;
  inherited SetParent(AValue);
end;

destructor TCShGenericType.Destroy;
begin
  ReleaseGenericTemplateTypes(GenericTemplateTypes{$IFDEF CheckCShTreeRefCount},'TCShGenericType'{$ENDIF});
  inherited Destroy;
end;

procedure TCShGenericType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  if GenericTemplateTypes<>nil then
    for i:=0 to GenericTemplateTypes.Count-1 do
      ForEachChildCall(aMethodCall,Arg,TCShElement(GenericTemplateTypes[i]),false);
end;

procedure TCShGenericType.SetGenericTemplates(AList: TFPList);
var
  I: Integer;
  El: TCShElement;
begin
  if GenericTemplateTypes=nil then
    GenericTemplateTypes:=TFPList.Create;
  For I:=0 to AList.Count-1 do
    begin
    El:=TCShElement(AList[i]);
    El.Parent:=Self;
    GenericTemplateTypes.Add(El);
    end;
  AList.Clear;
end;

{ TCShGenericTemplateType }

procedure TCShGenericTemplateType.SetParent(const AValue: TCShElement);
begin
  if (AValue=nil) and (Parent<>nil) then
    begin
    // parent is cleared
    // -> clear all references to this class (releasing loops)
    ClearConstraints;
    end;
  inherited SetParent(AValue);
end;

destructor TCShGenericTemplateType.Destroy;
begin
  ClearConstraints;
  inherited Destroy;
end;

function TCShGenericTemplateType.GetDeclaration(full: boolean): string;
var
  i: Integer;
begin
  Result:=inherited GetDeclaration(full);
  if length(Constraints)>0 then
    begin
    Result:=Result+': ';
    for i:=0 to length(Constraints)-1 do
      begin
      if i>0 then
        Result:=Result+',';
      Result:=Result+Constraints[i].GetDeclaration(false);
      end;
    end;
end;

procedure TCShGenericTemplateType.ForEachCall(
  const aMethodCall: TOnForEachCShElement; const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to length(Constraints)-1 do
    ForEachChildCall(aMethodCall,Arg,Constraints[i],false);
end;

procedure TCShGenericTemplateType.AddConstraint(El: TCShElement);
var
  l: Integer;
begin
  l:=Length(Constraints);
  SetLength(Constraints,l+1);
  Constraints[l]:=El;
end;

procedure TCShGenericTemplateType.ClearConstraints;
var
  i: Integer;
  aConstraint: TCShElement;
begin
  // -> clear all references to this class (releasing loops)
  for i:=0 to length(Constraints)-1 do
    begin
    aConstraint:=Constraints[i];
    if aConstraint.Parent=Self then
      aConstraint.Parent:=nil;
    aConstraint.Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
    end;
  Constraints:=nil;
end;

{$IFDEF HasPTDumpStack}
procedure PTDumpStack;
begin
  {AllowWriteln}
  writeln(GetPTDumpStack);
  {AllowWriteln-}
end;

function GetPTDumpStack: string;
var
  bp: Pointer;
  addr: Pointer;
  oldbp: Pointer;
  CurAddress: Shortstring;
begin
  Result:='';
  { retrieve backtrace info }
  bp:=get_caller_frame(get_frame);
  while bp<>nil do begin
    addr:=get_caller_addr(bp);
    CurAddress:=BackTraceStrFunc(addr);
    Result:=Result+CurAddress+LineEnding;
    oldbp:=bp;
    bp:=get_caller_frame(bp);
    if (bp<=oldbp) or (bp>(StackBottom + StackLength)) then
      bp:=nil;
  end;
end;
{$ENDIF}

{ TCShAttributes }

destructor TCShAttributes.Destroy;
var
  i: Integer;
begin
  for i:=0 to length(Calls)-1 do
    Calls[i].Release{$IFDEF CheckCShTreeRefCount}('TCShAttributes.Destroy'){$ENDIF};
  inherited Destroy;
end;

procedure TCShAttributes.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to length(Calls)-1 do
    ForEachChildCall(aMethodCall,Arg,Calls[i],false);
end;

procedure TCShAttributes.AddCall(Expr: TCShExpr);
var
  i : Integer;
begin
  i:=Length(Calls);
  SetLength(Calls, i+1);
  Calls[i]:=Expr;
end;

{ TCShMethodResolution }

destructor TCShMethodResolution.Destroy;
begin
  ReleaseAndNil(TCShElement(InterfaceName){$IFDEF CheckCShTreeRefCount},'TCShMethodResolution.InterfaceName'{$ENDIF});
  ReleaseAndNil(TCShElement(InterfaceProc){$IFDEF CheckCShTreeRefCount},'TCShMethodResolution.InterfaceProc'{$ENDIF});
  ReleaseAndNil(TCShElement(ImplementationProc){$IFDEF CheckCShTreeRefCount},'TCShMethodResolution.ImplementationProc'{$ENDIF});
  inherited Destroy;
end;

{ TCShImplCommandBase }

constructor TCShImplCommandBase.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  SemicolonAtEOL := true;
end;

{ TInlineSpecializeExpr }

constructor TInlineSpecializeExpr.Create(const AName: string;
  AParent: TCShElement);
begin
  if AName='' then ;
  inherited Create(AParent, pekSpecialize, eopNone);
  Params:=TFPList.Create;
end;

destructor TInlineSpecializeExpr.Destroy;
var
  i: Integer;
begin
  TCShElement(NameExpr).Release{$IFDEF CheckCShTreeRefCount}('CreateElement'){$ENDIF};
  for i:=0 to Params.Count-1 do
    TCShElement(Params[i]).Release{$IFDEF CheckCShTreeRefCount}('TInlineSpecializeExpr.Params'){$ENDIF};
  FreeAndNil(Params);
  inherited Destroy;
end;

function TInlineSpecializeExpr.ElementTypeName: string;
begin
  Result:=SCShTreeSpecializedExpr;
end;

function TInlineSpecializeExpr.GetDeclaration(full: Boolean): string;
var
  i: Integer;
begin
  Result:='specialize '+NameExpr.GetDeclaration(false)+'<';
  for i:=0 to Params.Count-1 do
    begin
    if i>0 then
      Result:=Result+',';
    Result:=Result+TCShElement(Params[i]).GetDeclaration(false);
    end;
  Result:=Result+'>';
  if full then ;
end;

procedure TInlineSpecializeExpr.ForEachCall(
  const aMethodCall: TOnForEachCShElement; const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,NameExpr,false);
  for i:=0 to Params.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Params[i]),true);
end;

{ TCShSpecializeType }

constructor TCShSpecializeType.Create(const AName: string; AParent: TCShElement
  );
begin
  inherited Create(AName, AParent);
  Params:=TFPList.Create;
end;

destructor TCShSpecializeType.Destroy;
var
  i: Integer;
begin
  for i:=0 to Params.Count-1 do
    TCShElement(Params[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShSpecializeType.Params'){$ENDIF};
  FreeAndNil(Params);
  inherited Destroy;
end;

function TCShSpecializeType.ElementTypeName: string;
begin
  Result:=SCShTreeSpecializedType;
end;

function TCShSpecializeType.GetDeclaration(full: boolean): string;
var
  i: Integer;
begin
  Result:='specialize '+DestType.Name+'<';
  for i:=0 to Params.Count-1 do
    begin
    if i>0 then
      Result:=Result+',';
    Result:=Result+TCShElement(Params[i]).GetDeclaration(false);
    end;
  If Full and (Name<>'') then
    begin
    Result:=Name+' = '+Result;
    ProcessHints(False,Result);
    end;
end;

procedure TCShSpecializeType.ForEachCall(
  const aMethodCall: TOnForEachCShElement; const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to Params.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Params[i]),true);
end;


{ TLibrarySection }

function TLibrarySection.ElementTypeName: string;
begin
  Result:=SCShTreeLibrarySection;
end;

{ TProgramSection }

function TProgramSection.ElementTypeName: string;
begin
  Result:=SCShTreeProgramSection;
end;

{ TCShUsingNamespace }

destructor TCShUsingNamespace.Destroy;
begin
  ReleaseAndNil(TCShElement(Expr){$IFDEF CheckCShTreeRefCount},'TCShUsesUnit.Expr'{$ENDIF});
  ReleaseAndNil(TCShElement(InFilename){$IFDEF CheckCShTreeRefCount},'TCShUsesUnit.InFilename'{$ENDIF});
  ReleaseAndNil(TCShElement(Module){$IFDEF CheckCShTreeRefCount},'TCShUsesUnit.Module'{$ENDIF});
  inherited Destroy;
end;

function TCShUsingNamespace.ElementTypeName: string;
begin
  Result := SCShTreeUsingNamespace;
end;

procedure TCShUsingNamespace.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,Expr,false);
  ForEachChildCall(aMethodCall,Arg,InFilename,false);
  ForEachChildCall(aMethodCall,Arg,Module,true);
end;

{ TCShElementBase }

procedure TCShElementBase.Accept(Visitor: TCShsTreeVisitor);
begin
  if Visitor=nil then ;
end;

{ TCShTypeRef }

procedure TCShTypeRef.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,RefType,true);
end;

{ TCShClassOperator }

function TCShClassOperator.TypeName: string;
begin
  Result:='class operator';
end;

function TCShClassOperator.GetProcTypeEnum: TProcType;
begin
  Result:=ptClassOperator;
end;

{ TCShImplAsmStatement }

constructor TCShImplAsmStatement.Create(const AName: string;
  AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  FTokens:=TStringList.Create;
end;

destructor TCShImplAsmStatement.Destroy;
begin
  FreeAndNil(FTokens);
  inherited Destroy;
end;

{ TCShClassConstructor }

function TCShClassConstructor.TypeName: string;
begin
  Result:='class '+ inherited TypeName;
end;

function TCShClassConstructor.GetProcTypeEnum: TProcType;
begin
  Result:=ptClassConstructor;
end;

{ TCShAnonymousProcedure }

function TCShAnonymousProcedure.ElementTypeName: string;
begin
  Result:=SCShTreeAnonymousProcedure;
end;

function TCShAnonymousProcedure.TypeName: string;
begin
  Result:='anonymous procedure';
end;

function TCShAnonymousProcedure.GetProcTypeEnum: TProcType;
begin
  Result:=ptAnonymousProcedure;
end;

{ TCShAnonymousFunction }

function TCShAnonymousFunction.GetFT: TCShFunctionType;
begin
  Result:=ProcType as TCShFunctionType;
end;

function TCShAnonymousFunction.ElementTypeName: string;
begin
  Result := SCShTreeAnonymousFunction;
end;

function TCShAnonymousFunction.TypeName: string;
begin
  Result:='anonymous function';
end;

function TCShAnonymousFunction.GetProcTypeEnum: TProcType;
begin
  Result:=ptAnonymousFunction;
end;

{ TProcedureExpr }

constructor TProcedureExpr.Create(AParent: TCShElement);
begin
  inherited Create(AParent,pekProcedure,eopNone);
end;

destructor TProcedureExpr.Destroy;
begin
  ReleaseAndNil(TCShElement(Proc){$IFDEF CheckCShTreeRefCount},'TProcedureExpr.Proc'{$ENDIF});
  inherited Destroy;
end;

function TProcedureExpr.GetDeclaration(full: Boolean): string;
begin
  if Proc<>nil then
    Result:=Proc.GetDeclaration(full)
  else
    Result:='procedure-expr';
end;

procedure TProcedureExpr.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,Proc,false);
end;

{ TCShImplRaise }

destructor TCShImplRaise.Destroy;
begin
  ReleaseAndNil(TCShElement(ExceptObject){$IFDEF CheckCShTreeRefCount},'TCShImplRaise.ExceptObject'{$ENDIF});
  ReleaseAndNil(TCShElement(ExceptAddr){$IFDEF CheckCShTreeRefCount},'TCShImplRaise.ExceptAddr'{$ENDIF});
  inherited Destroy;
end;

procedure TCShImplRaise.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,ExceptObject,false);
  ForEachChildCall(aMethodCall,Arg,ExceptAddr,false);
end;

{ TCShImplRepeatUntil }

destructor TCShImplRepeatUntil.Destroy;
begin
  ReleaseAndNil(TCShElement(ConditionExpr){$IFDEF CheckCShTreeRefCount},'TCShImplRepeatUntil.ConditionExpr'{$ENDIF});
  inherited Destroy;
end;

function TCShImplRepeatUntil.Condition: string;
begin
  If Assigned(ConditionExpr) then
    Result:=ConditionExpr.GetDeclaration(True)
  else
    Result:='';
end;

procedure TCShImplRepeatUntil.ForEachCall(
  const aMethodCall: TOnForEachCShElement; const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,ConditionExpr,false);
end;

{ TCShImplSimple }

destructor TCShImplSimple.Destroy;
begin
  ReleaseAndNil(TCShElement(Expr){$IFDEF CheckCShTreeRefCount},'TCShImplSimple.Expr'{$ENDIF});
  inherited Destroy;
end;

procedure TCShImplSimple.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,Expr,false);
end;

{ TCShImplAssign }

destructor TCShImplAssign.Destroy;
begin
  ReleaseAndNil(TCShElement(Left){$IFDEF CheckCShTreeRefCount},'TCShImplAssign.left'{$ENDIF});
  ReleaseAndNil(TCShElement(Right){$IFDEF CheckCShTreeRefCount},'TCShImplAssign.right'{$ENDIF});
  inherited Destroy;
end;

procedure TCShImplAssign.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,left,false);
  ForEachChildCall(aMethodCall,Arg,right,false);
end;

{ TCShExportSymbol }

destructor TCShExportSymbol.Destroy;
begin
  ReleaseAndNil(TCShElement(ExportName){$IFDEF CheckCShTreeRefCount},'TCShExportSymbol.ExportName'{$ENDIF});
  ReleaseAndNil(TCShElement(ExportIndex){$IFDEF CheckCShTreeRefCount},'TCShExportSymbol.ExportIndex'{$ENDIF});
  inherited Destroy;
end;

function TCShExportSymbol.ElementTypeName: string;
begin
  Result:='Export'
end;

function TCShExportSymbol.GetDeclaration(full: boolean): string;
begin
  Result:=Name;
  if (ExportName<>Nil) then
    Result:=Result+' name '+ExportName.GetDeclaration(Full)
  else if (ExportIndex<>Nil) then
    Result:=Result+' index '+ExportIndex.GetDeclaration(Full);
end;

procedure TCShExportSymbol.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,ExportName,false);
  ForEachChildCall(aMethodCall,Arg,ExportIndex,false);
end;

{ TCShUnresolvedUnitRef }

function TCShUnresolvedUnitRef.ElementTypeName: string;
begin
  Result:=SCShTreeNamespace;
end;

{ TCShLibrary }

destructor TCShLibrary.Destroy;
begin
  ReleaseAndNil(TCShElement(LibrarySection){$IFDEF CheckCShTreeRefCount},'TCShLibrary.LibrarySection'{$ENDIF});
  inherited Destroy;
end;

function TCShLibrary.ElementTypeName: string;
begin
  Result:=inherited ElementTypeName;
end;

procedure TCShLibrary.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  ForEachChildCall(aMethodCall,Arg,LibrarySection,false);
  inherited ForEachCall(aMethodCall, Arg);
end;

procedure TCShLibrary.ReleaseUsedNamespace;
begin
  if LibrarySection<>nil then
    LibrarySection.ReleaseUsedNamespaces;
  inherited;
end;

{ TCShProgram }

destructor TCShProgram.Destroy;
begin
  {$IFDEF VerboseCShTreeMem}writeln('TCShProgram.Destroy ProgramSection');{$ENDIF}
  ReleaseAndNil(TCShElement(ProgramSection){$IFDEF CheckCShTreeRefCount},'TCShProgram.ProgramSection'{$ENDIF});
  {$IFDEF VerboseCShTreeMem}writeln('TCShProgram.Destroy inherited');{$ENDIF}
  inherited Destroy;
  {$IFDEF VerboseCShTreeMem}writeln('TCShProgram.Destroy END');{$ENDIF}
end;

function TCShProgram.ElementTypeName: string;
begin
  Result:=inherited ElementTypeName;
end;

procedure TCShProgram.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  ForEachChildCall(aMethodCall,Arg,ProgramSection,false);
  inherited ForEachCall(aMethodCall, Arg);
end;

procedure TCShProgram.ReleaseUsedNamespace;
begin
  if ProgramSection<>nil then
    ProgramSection.ReleaseUsedNamespaces;
  inherited;
end;

{ TCShNamespaceModule }

function TCShNamespaceModule.ElementTypeName: string;
begin
  Result:=SCShTreeNamespace;
end;

{ Parse tree element type name functions }
function TCShElement.ElementTypeName: string; begin Result := SCShTreeElement end;

function TCShElement.HintsString: String;

Var
  H : TCShMemberHint;

begin
  Result:='';
  For H := Low(TCShMemberHint) to High(TCShMemberHint) do
    if H in Hints then
      begin
      If (Result<>'') then
        Result:=Result+'; ';
      Result:=Result+cCShMemberHint[h];
      end;
end;

function TCShDeclarations.ElementTypeName: string; begin Result := SCShTreeSection end;

procedure TCShDeclarations.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to Declarations.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Declarations[i]),false);
end;

function TCShModule.ElementTypeName: string; begin Result := SCShTreeModule end;
function TCShPackage.ElementTypeName: string; begin Result := SCShTreePackage end;

procedure TCShPackage.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to Modules.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShModule(Modules[i]),true);
end;

function TCShResString.ElementTypeName: string; begin Result := SCShTreeResString; end;

function TCShType.FixTypeDecl(aDecl: String): String;
begin
  Result:=aDecl;
  if (Name<>'') then
    Result:=SafeName+' = '+Result;
  ProcessHints(false,Result);
end;

function TCShType.SafeName: String;
begin
  if SameText(Name,'string') then
    Result:=Name
  else
    Result:=inherited SafeName;
end;

function TCShType.ElementTypeName: string; begin Result := SCShTreeType; end;
function TCShPointerType.ElementTypeName: string; begin Result := SCShTreePointerType; end;
function TCShAliasType.ElementTypeName: string; begin Result := SCShTreeAliasType; end;
function TCShTypeAliasType.ElementTypeName: string; begin Result := SCShTreeTypeAliasType; end;
function TCShClassOfType.ElementTypeName: string; begin Result := SCShTreeClassOfType; end;
function TCShRangeType.ElementTypeName: string; begin Result := SCShTreeRangeType; end;
function TCShArrayType.ElementTypeName: string; begin Result := SCShTreeArrayType; end;
function TCShEnumValue.ElementTypeName: string; begin Result := SCShTreeEnumValue; end;

procedure TCShEnumValue.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,Value,false);
end;

destructor TCShEnumValue.Destroy;
begin
  ReleaseAndNil(TCShElement(Value){$IFDEF CheckCShTreeRefCount},'TCShEnumValue.Value'{$ENDIF});
  inherited Destroy;
end;

function TCShEnumValue.AssignedValue: string;
begin
  If Assigned(Value) then
    Result:=Value.GetDeclaration(True)
  else
    Result:='';
end;

function TCShEnumType.ElementTypeName: string; begin Result := SCShTreeEnumType end;
function TCShSetType.ElementTypeName: string; begin Result := SCShTreeSetType end;
function TCShRecordType.ElementTypeName: string; begin Result := SCShTreeStructType end;
function TCShArgument.ElementTypeName: string; begin Result := SCShTreeArgument end;
function TCShProcedureType.ElementTypeName: string; begin Result := SCShTreeProcedureType end;
function TCShResultElement.ElementTypeName: string; begin Result := SCShTreeResultElement end;

procedure TCShResultElement.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,ResultType,true);
end;

procedure TCShResultElement.ClearTypeReferences(aType: TCShElement);
begin
  if ResultType=aType then
    ReleaseAndNil(TCShElement(ResultType){$IFDEF CheckCShTreeRefCount},'TCShResultElement.ResultType'{$ENDIF});
end;

function TCShFunctionType.ElementTypeName: string; begin Result := SCShTreeFunctionType end;
function TCShUnresolvedTypeRef.ElementTypeName: string; begin Result := SCShTreeUnresolvedTypeRef end;
function TCShVariable.ElementTypeName: string; begin Result := SCShTreeVariable end;
function TCShConst.ElementTypeName: string; begin Result := SCShTreeConst end;
function TCShProperty.ElementTypeName: string; begin Result := SCShTreeProperty end;
function TCShOverloadedProc.ElementTypeName: string; begin Result := SCShTreeOverloadedProcedure end;
function TCShProcedure.ElementTypeName: string; begin Result := SCShTreeProcedure end;

function TCShFunction.GetFT: TCShFunctionType;
begin
  Result:=ProcType as TCShFunctionType;
end;

function TCShFunction.ElementTypeName: string; begin Result := SCShTreeFunction; end;
function TCShClassProcedure.ElementTypeName: string; begin Result := SCShTreeClassProcedure; end;
function TCShClassConstructor.ElementTypeName: string; begin Result := SCShTreeClassConstructor; end;
function TCShClassDestructor.ElementTypeName: string; begin Result := SCShTreeClassDestructor; end;

function TCShClassDestructor.TypeName: string;
begin
  Result:='destructor';
end;

function TCShClassDestructor.GetProcTypeEnum: TProcType;
begin
  Result:=ptClassDestructor;
end;

function TCShClassFunction.ElementTypeName: string; begin Result := SCShTreeClassFunction; end;

class function TCShOperator.OperatorTypeToToken(T: TOperatorType): String;
begin
  Result:=OperatorTokens[T];
end;

class function TCShOperator.OperatorTypeToOperatorName(T: TOperatorType
  ): String;
begin
  Result:=OperatorNames[T];
end;

class function TCShOperator.TokenToOperatorType(S: String): TOperatorType;
begin
  Result:=High(TOperatorType);
  While (Result>otUnknown) and (CompareText(S,OperatorTokens[Result])<>0) do
    Result:=Pred(Result);
end;

class function TCShOperator.NameToOperatorType(S: String): TOperatorType;
begin
  Result:=High(TOperatorType);
  While (Result>otUnknown) and (CompareText(S,OperatorNames[Result])<>0) do
    Result:=Pred(Result);
end;

Function TCShOperator.NameSuffix : String;

Var
  I : Integer;

begin
  Result:='(';
  if Assigned(ProcType) and Assigned(ProcType.Args) then
  for i:=0 to ProcType.Args.Count-1 do
    begin
    if i>0 then
      Result:=Result+',';
    Result:=Result+TCShArgument(ProcType.Args[i]).ArgType.Name;
    end;
  Result:=Result+')';
  if Assigned(TCShFunctionType(ProcType)) and
     Assigned(TCShFunctionType(ProcType).ResultEl) and
     Assigned(TCShFunctionType(ProcType).ResultEl.ResultType) then
    Result:=Result+':'+TCShFunctionType(ProcType).ResultEl.ResultType.Name;
end;

procedure TCShOperator.CorrectName;

begin
  Name:=OperatorNames[OperatorType]+NameSuffix;
end;

function TCShOperator.OldName(WithPath : Boolean): String;

Var
  I : Integer;
  S : String;
begin
  Result:=TypeName+' '+OperatorTokens[OperatorType];
  Result := Result + '(';
  if Assigned(ProcType) then
    begin
    for i := 0 to ProcType.Args.Count - 1 do
      begin
      if i > 0 then
        Result := Result + ', ';
      Result := Result + TCShArgument(ProcType.Args[i]).ArgType.Name;
      end;
    Result := Result + '): ' + TCShFunctionType(ProcType).ResultEl.ResultType.Name;
    If WithPath then
      begin
      S:=Self.ParentPath;
      if (S<>'') then
        Result:=S+'.'+Result;
      end;
    end;
end;

function TCShOperator.ElementTypeName: string;
begin
  Result := SCShTreeOperator
end;

function TCShConstructor.ElementTypeName: string; begin Result := SCShTreeConstructor end;
function TCShDestructor.ElementTypeName: string; begin Result := SCShTreeDestructor end;
function TCShProcedureImpl.ElementTypeName: string; begin Result := SCShTreeProcedureImpl end;
function TCShConstructorImpl.ElementTypeName: string; begin Result := SCShTreeConstructorImpl end;
function TCShDestructorImpl.ElementTypeName: string; begin Result := SCShTreeDestructorImpl end;
function TCShStringType.ElementTypeName: string; begin Result:=SCShStringType;end;


{ All other stuff: }

procedure TCShElement.ProcessHints(const ASemiColonPrefix: boolean; var AResult: string);
var
  S : String;
begin
  if Hints <> [] then
    begin
    if ASemiColonPrefix then
      AResult := AResult + ';';
    S:=HintsString;
    if (S<>'') then
      AResult:=AResult+' '+S;
    if ASemiColonPrefix then
      AResult:=AResult+';';
    end;
end;

procedure TCShElement.SetParent(const AValue: TCShElement);
begin
  FParent:=AValue;
end;

{$IFDEF CheckCShTreeRefCount}
procedure TCShElement.ChangeRefId(const OldId, NewId: string);
var
  i: Integer;
begin
  i:=RefIds.IndexOf(OldId);
  if i<0 then
    begin
    {AllowWriteln}
    writeln('ERROR: TCShElement.ChangeRefId ',Name,':',ClassName,' Old="'+OldId+'" New="'+NewId+'" Old not found');
    writeln(RefIds.Text);
    {AllowWriteln-}
    raise ECShTree.Create('');
    end;
  RefIds.Delete(i);
  RefIds.Add(NewId);
end;
{$ENDIF}

constructor TCShElement.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create;
  FName := AName;
  FParent := AParent;
  {$ifdef pas2js}
  inc(FLastCShElementId);
  FCShElementId:=FLastCShElementId;
  //writeln('TCShElement.Create ',Name,':',ClassName,' ID=[',FCShElementId,']');
  {$endif}
  {$ifdef EnableCShTreeGlobalRefCount}
  Inc(FGlobalRefCount);
  {$endif}
  {$IFDEF CheckCShTreeRefCount}
  RefIds:=TStringList.Create;
  PrevRefEl:=LastRefEl;
  if LastRefEl<>nil then
    LastRefEl.NextRefEl:=Self
  else
    FirstRefEl:=Self;
  LastRefEl:=Self;
  {$ENDIF}
end;

destructor TCShElement.Destroy;
begin
  if (FRefCount>0) and (FRefCount<high(FRefCount)) then
    begin
    {$if defined(debugrefcount) or defined(VerboseCShTreeMem)}writeln('TCShElement.Destroy ',Name,':',ClassName);{$ENDIF}
    {$IFDEF CheckCShTreeRefCount}
    if (FRefCount>0) and (FRefCount<high(FRefCount)) then
      begin
      {AllowWriteln}
      writeln('TCShElement.Destroy ',Name,':',ClassName,' RefIds.Count=',RefIds.Count);
      writeln(RefIds.Text);
      {AllowWriteln-}
      end;
    FreeAndNil(RefIds);
    {$ENDIF}
    raise ECShTree.Create(ClassName+'Destroy called wrong');
    end;
  {$IFDEF CheckCShTreeRefCount}
  FreeAndNil(RefIds);
  // remove from global chain
  if FirstRefEl=Self then FirstRefEl:=NextRefEl;
  if LastRefEl=Self then LastRefEl:=PrevRefEl;
  if PrevRefEl<>nil then
    PrevRefEl.NextRefEl:=NextRefEl;
  if NextRefEl<>nil then
    NextRefEl.PrevRefEl:=PrevRefEl;
  PrevRefEl:=nil;
  NextRefEl:=nil;
  {$ENDIF}
  FParent:=nil;
  {$ifdef EnableCShTreeGlobalRefCount}
  Dec(FGlobalRefCount);
  {$endif}
  inherited Destroy;
end;

class function TCShElement.IsKeyWord(const S: String): Boolean;

Const
   KW=';absolute;and;array;asm;begin;case;const;constructor;destructor;div;do;'+
       'downto;else;end;file;for;function;goto;if;implementation;in;inherited;'+
       'inline;interface;label;mod;nil;not;object;of;on;operator;or;packed;'+
       'procedure;program;record;reintroduce;repeat;self;set;shl;shr;string;then;'+
       'to;type;unit;until;uses;var;while;with;xor;dispose;exit;false;new;true;'+
       'as;class;dispinterface;except;exports;finalization;finally;initialization;'+
       'inline;is;library;on;out;packed;property;raise;resourcestring;threadvar;try;'+
       'private;published;length;setlength;';

begin
  Result:=Pos(';'+lowercase(S)+';',KW)<>0;
end;

class function TCShElement.EscapeKeyWord(const S: String): String;
begin
  Result:=S;
  If IsKeyWord(Result) then
    Result:='&'+Result

end;

procedure TCShElement.AddRef{$IFDEF CheckCShTreeRefCount}(const aId: string){$ENDIF};
begin
  {$ifdef EnableCShTreeGlobalRefCount}
  Inc(FGlobalRefCount);
  {$endif}
  Inc(FRefCount);
  {$IFDEF CheckCShTreeRefCount}
  if SameText(aId,'CreateElement') and (RefIds.IndexOf('CreateElement')>=0) then
    begin
    {AllowWriteln}
    writeln('TCShElement.AddRef ',Name,':',ClassName,' RefCount=',RefCount,' RefIds={',RefIds.Text,'}');
    {AllowWriteln-}
    {$IFDEF HasPTDumpStack}
    PTDumpStack;
    {$ENDIF}
    Halt;
    end;
  RefIds.Add(aId);
  {$ENDIF}
end;

procedure TCShElement.Release{$IFDEF CheckCShTreeRefCount}(const aId: string){$ENDIF};
{$if defined(debugrefcount) or defined(VerboseCShTreeMem)}
Var
  Cn : String;
  {$endif}
{$IFDEF CheckCShTreeRefCount}
var i: integer;
{$ENDIF}
begin
  {$if defined(debugrefcount) or defined(VerboseCShTreeMem)}
  {AllowWriteln}
  CN:=ClassName+' '+Name;
  CN:=CN+' '+IntToStr(FRefCount);
  //If Assigned(Parent) then
  //  CN:=CN+' ('+Parent.ClassName+')';
  Writeln('TCShElement.Release : ',Cn);
  {AllowWriteln-}
  {$endif}
  {$IFDEF CheckCShTreeRefCount}
  i:=RefIds.IndexOf(aId);
  if i<0 then
    RefIds.Add('remove:'+aId)
  else
    RefIds.Delete(i);
  {$ENDIF}
  if FRefCount = 0 then
    begin
    FRefCount:=High(FRefCount);
    {$ifdef pas2js}
    Destroy;
    {$else}
    Free;
    {$endif}
    end
  else if FRefCount=High(FRefCount) then
    begin
    {$if defined(debugrefcount) or defined(VerboseCShTreeMem)}
    Writeln('TCShElement.Released OUCH: ',Cn);
    {$endif}
    {$if defined(VerboseCShResolver) or defined(VerbosePCUFiler)}
    Writeln('TCShElement.Released : ',ClassName,' ',Name);
    {$endif}
    raise ECShTree.Create(ClassName+': Destroy called wrong');
    end
  else
    begin
    Dec(FRefCount);
    {$ifdef EnableCShTreeGlobalRefCount}
    Dec(FGlobalRefCount);
    {$endif}
    end;
{$if defined(debugrefcount) or defined(VerboseCShTreeMem)}  Writeln('TCShElement.Released : ',Cn); {$endif}
end;

procedure TCShElement.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  aMethodCall(Self,Arg);
end;

procedure TCShElement.ForEachChildCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer; Child: TCShElement; CheckParent: boolean);
begin
  if (Child=nil) then exit;
  if CheckParent and (not Child.HasParent(Self)) then exit;
  Child.ForEachCall(aMethodCall,Arg);
end;

function TCShElement.SafeName: String;
begin
  Result:=Name;
  if IsKeyWord(Result) then
    Result:='&'+Result;
end;

function TCShElement.FullPath: string;

var
  p: TCShElement;

begin
  Result := '';
  p := Parent;
  while Assigned(p) and not p.InheritsFrom(TCShDeclarations) do
  begin
    if (p.Name<>'') and (Not (p is TCShOverloadedProc)) then
      if Length(Result) > 0 then
        Result := p.Name + '.' + Result
      else
        Result := p.Name;
    p := p.Parent;
  end;
end;

function TCShElement.FullName: string;


begin
  Result := FullPath;
  if Result<>'' then
    Result:=Result+'.'+Name
  else
    Result:=Name;
end;

function TCShElement.ParentPath: string;

var
  p: TCShElement;
begin
  Result:='';
  p := Parent;
  while Assigned(p) do
  begin
    if (p.Name<>'') and (Not (p is TCShOverloadedProc)) then
      if Length(Result) > 0 then
        Result := p.Name + '.' + Result
      else
        Result := p.Name;
    p := p.Parent;
  end;
end;

function TCShElement.PathName: string;

begin
  Result := ParentPath;
  if Result<>'' then
    Result:=Result+'.'+Name
  else
    Result:=Name;
end;

function TCShElement.GetModule: TCShModule;

Var
  p : TCShElement;
begin
  if Self is TCShPackage then
    Result := nil
  else
    begin
    P:=Self;
    While (P<>Nil) and Not (P is TCShModule) do
      P:=P.Parent;
    Result:=TCShModule(P);
    end;
end;

function TCShElement.GetDeclaration(full: Boolean): string;

begin
  if Full then
    Result := SafeName
  else
    Result := '';
end;

procedure TCShElement.Accept(Visitor: TCShsTreeVisitor);
begin
  Visitor.Visit(Self);
end;

procedure TCShElement.ClearTypeReferences(aType: TCShElement);
begin
  if aType=nil then ;
end;

function TCShElement.HasParent(aParent: TCShElement): boolean;
var
  El: TCShElement;
begin
  El:=Parent;
  while El<>nil do
    begin
    if El=aParent then exit(true);
    El:=El.Parent;
    end;
  Result:=false;
end;

constructor TCShDeclarations.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Declarations := TFPList.Create;
  Attributes := TFPList.Create;
  Classes := TFPList.Create;
  Consts := TFPList.Create;
  ExportSymbols := TFPList.Create;
  Functions := TFPList.Create;
  Properties := TFPList.Create;
  ResStrings := TFPList.Create;
  Types := TFPList.Create;
  Variables := TFPList.Create;
end;

destructor TCShDeclarations.Destroy;
var
  i: Integer;
  Child: TCShElement;
begin
  {$IFDEF VerboseCShTreeMem}writeln('TCShDeclarations.Destroy START');{$ENDIF}
  FreeAndNil(Variables);
  FreeAndNil(Types);
  FreeAndNil(ResStrings);
  FreeAndNil(Properties);
  FreeAndNil(Functions);
  FreeAndNil(ExportSymbols);
  FreeAndNil(Consts);
  FreeAndNil(Classes);
  FreeAndNil(Attributes);
  {$IFDEF VerboseCShTreeMem}writeln('TCShDeclarations.Destroy Declarations');{$ENDIF}
  for i := 0 to Declarations.Count - 1 do
    begin
    Child:=TCShElement(Declarations[i]);
    Child.Parent:=nil;
    Child.Release{$IFDEF CheckCShTreeRefCount}('TCShDeclarations.Children'){$ENDIF};
    end;
  FreeAndNil(Declarations);

  {$IFDEF VerboseCShTreeMem}writeln('TCShDeclarations.Destroy inherited');{$ENDIF}
  inherited Destroy;
  {$IFDEF VerboseCShTreeMem}writeln('TCShDeclarations.Destroy END');{$ENDIF}
end;

destructor TCShModule.Destroy;
begin
  {$IFDEF VerboseCShTreeMem}writeln('TCShModule.Destroy ReleaseUsedUnits');{$ENDIF}
  ReleaseUsedNamespace;
  {$IFDEF VerboseCShTreeMem}writeln('TCShModule.Destroy global directives');{$ENDIF}
  ReleaseAndNil(TCShElement(GlobalDirectivesSection){$IFDEF CheckCShTreeRefCount},'TCShModule.GlobalDirectivesSection'{$ENDIF});
  {$IFDEF VerboseCShTreeMem}writeln('TCShModule.Destroy implementation');{$ENDIF}
  ReleaseAndNil(TCShElement(ImplementationSection){$IFDEF CheckCShTreeRefCount},'TCShModule.ImplementationSection'{$ENDIF});
  {$IFDEF VerboseCShTreeMem}writeln('TCShModule.Destroy initialization');{$ENDIF}
  ReleaseAndNil(TCShElement(InitializationSection){$IFDEF CheckCShTreeRefCount},'TCShModule.InitializationSection'{$ENDIF});
  {$IFDEF VerboseCShTreeMem}writeln('TCShModule.Destroy finalization');{$ENDIF}
  ReleaseAndNil(TCShElement(FinalizationSection){$IFDEF CheckCShTreeRefCount},'TCShModule.FinalizationSection'{$ENDIF});
  {$IFDEF VerboseCShTreeMem}writeln('TCShModule.Destroy inherited');{$ENDIF}
  inherited Destroy;
  {$IFDEF VerboseCShTreeMem}writeln('TCShModule.Destroy END');{$ENDIF}
end;


constructor TCShPackage.Create(const AName: string; AParent: TCShElement);
begin
  if (Length(AName) > 0) and (AName[1] <> '#') then
    inherited Create('#' + AName, AParent)
  else
    inherited Create(AName, AParent);
  Modules := TFPList.Create;
end;

destructor TCShPackage.Destroy;
var
  i: Integer;
begin
  for i := 0 to Modules.Count - 1 do
    TCShModule(Modules[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShPackage.Modules'){$ENDIF};
  FreeAndNil(Modules);
  inherited Destroy;
end;

procedure TCShPointerType.SetParent(const AValue: TCShElement);
begin
  if (AValue=nil) and (Parent<>nil) and (DestType<>nil)
      and ((DestType.Parent=Parent) or (DestType=Self)) then
    begin
    // DestType in same type section can create a loop
    // -> break loop when type section is closed
    DestType.Release{$IFDEF CheckCShTreeRefCount}('TCShPointerType.DestType'){$ENDIF};
    DestType:=nil;
    end;
  inherited SetParent(AValue);
end;

destructor TCShPointerType.Destroy;
begin
  ReleaseAndNil(TCShElement(DestType){$IFDEF CheckCShTreeRefCount},'TCShPointerType.DestType'{$ENDIF});
  inherited Destroy;
end;

procedure TCShAliasType.SetParent(const AValue: TCShElement);
begin
  if (AValue=nil) and (Parent<>nil) and (DestType<>nil)
      and ((DestType.Parent=Parent) or (DestType=Self)) then
    begin
    // DestType in same type section can create a loop
    // -> break loop when type section is closed
    DestType.Release{$IFDEF CheckCShTreeRefCount}('TCShAliasType.DestType'){$ENDIF};
    DestType:=nil;
    end;
  inherited SetParent(AValue);
end;

destructor TCShAliasType.Destroy;
begin
  ReleaseAndNil(TCShElement(DestType){$IFDEF CheckCShTreeRefCount},'TCShAliasType.DestType'{$ENDIF});
  ReleaseAndNil(TCShElement(Expr){$IFDEF CheckCShTreeRefCount},'TCShAliasType.Expr'{$ENDIF});
  inherited Destroy;
end;

procedure TCShArrayType.SetParent(const AValue: TCShElement);
var
  CurArr: TCShArrayType;
begin
  if (AValue=nil) and (Parent<>nil) then
    begin
    // parent is cleared
    // -> clear all references to this array (releasing loops)
    CurArr:=Self;
    while CurArr.ElType is TCShArrayType do
      begin
      if CurArr.ElType=Self then
        begin
        ReleaseAndNil(TCShElement(CurArr.ElType){$IFDEF CheckCShTreeRefCount},'TCShClassType.AncestorType'{$ENDIF});
        break;
        end;
      CurArr:=TCShArrayType(CurArr.ElType);
      end;
    end;
  inherited SetParent(AValue);
end;

destructor TCShArrayType.Destroy;
var
  i: Integer;
begin
  for i:=0 to length(Ranges)-1 do
    Ranges[i].Release{$IFDEF CheckCShTreeRefCount}('TCShArrayType.Ranges'){$ENDIF};
  ReleaseAndNil(TCShElement(ElType){$IFDEF CheckCShTreeRefCount},'TCShArrayType.ElType'{$ENDIF});
  inherited Destroy;
end;

destructor TCShFileType.Destroy;
begin
  ReleaseAndNil(TCShElement(ElType){$IFDEF CheckCShTreeRefCount},'TCShFileType.ElType'{$ENDIF});
  inherited Destroy;
end;

constructor TCShEnumType.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Values := TFPList.Create;
end;

destructor TCShEnumType.Destroy;
var
  i: Integer;
begin
  for i := 0 to Values.Count - 1 do
    TCShEnumValue(Values[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShEnumType.Values'){$ENDIF};
  FreeAndNil(Values);
  inherited Destroy;
end;

procedure TCShEnumType.GetEnumNames(Names: TStrings);
var
  i: Integer;
begin
  with Values do
  begin
    for i := 0 to Count - 2 do
      Names.Add(TCShEnumValue(Items[i]).Name + ',');
    if Count > 0 then
      Names.Add(TCShEnumValue(Items[Count - 1]).Name);
  end;
end;

procedure TCShEnumType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to Values.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShEnumValue(Values[i]),false);
end;


constructor TCShVariant.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Values := TFPList.Create;
end;

destructor TCShVariant.Destroy;

Var
  I : Integer;

begin
  For I:=0 to Values.Count-1 do
    TCShElement(Values[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShVariant.Values'){$ENDIF};
  FreeAndNil(Values);
  ReleaseAndNil(TCShElement(Members){$IFDEF CheckCShTreeRefCount},'TCShVariant.Members'{$ENDIF});
  inherited Destroy;
end;

function TCShVariant.GetDeclaration(full: boolean): string;

Var
  i : Integer;
  S : TStrings;

begin
  Result:='';
  For I:=0 to Values.Count-1 do
    begin
    if (Result<>'') then
      Result:=Result+', ';
    Result:=Result+TCShElement(Values[i]).GetDeclaration(False);
    Result:=Result+': ('+sLineBreak;
    S:=TStringList.Create;
    try
      Members.GetMembers(S);
      Result:=Result+S.Text;
    finally
      S.Free;
    end;
    Result:=Result+');';
    if Full then ;
    end;
end;

procedure TCShVariant.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to Values.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Values[i]),false);
  ForEachChildCall(aMethodCall,Arg,Members,false);
end;

{ TCShRecordType }

constructor TCShRecordType.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
end;

destructor TCShRecordType.Destroy;
var
  i: Integer;
begin
  ReleaseAndNil(TCShElement(VariantEl){$IFDEF CheckCShTreeRefCount},'TCShRecordType.VariantEl'{$ENDIF});

  if Assigned(Variants) then
  begin
    for i := 0 to Variants.Count - 1 do
      TCShVariant(Variants[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShRecordType.Variants'){$ENDIF};
    FreeAndNil(Variants);
  end;

  inherited Destroy;
end;

{ TCShClassType }

procedure TCShClassType.SetParent(const AValue: TCShElement);
begin
  if (AValue=nil) and (Parent<>nil) then
    begin
    // parent is cleared
    // -> clear all references to this class (releasing loops)
    if AncestorType=Self then
      ReleaseAndNil(TCShElement(AncestorType){$IFDEF CheckCShTreeRefCount},'TCShClassType.AncestorType'{$ENDIF});
    if HelperForType=Self then
      ReleaseAndNil(TCShElement(HelperForType){$IFDEF CheckCShTreeRefCount},'TCShClassType.HelperForType'{$ENDIF});
    end;
  inherited SetParent(AValue);
end;

constructor TCShClassType.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  IsShortDefinition := False;
  Modifiers := TStringList.Create;
  Interfaces:= TFPList.Create;
end;

destructor TCShClassType.Destroy;
var
  i: Integer;
begin
  for i := 0 to Interfaces.Count - 1 do
    TCShElement(Interfaces[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShClassType.Interfaces'){$ENDIF};
  FreeAndNil(Interfaces);
  ReleaseAndNil(TCShElement(AncestorType){$IFDEF CheckCShTreeRefCount},'TCShClassType.AncestorType'{$ENDIF});
  ReleaseAndNil(TCShElement(HelperForType){$IFDEF CheckCShTreeRefCount},'TCShClassType.HelperForType'{$ENDIF});
  ReleaseAndNil(TCShElement(GUIDExpr){$IFDEF CheckCShTreeRefCount},'TCShClassType.GUIDExpr'{$ENDIF});
  FreeAndNil(Modifiers);
  inherited Destroy;
end;

function TCShClassType.ElementTypeName: string;
begin
  case ObjKind of
    okObject: Result := SCShTreeObjectType;
    okClass: Result := SCShTreeClassType;
    okInterface: Result := SCShTreeInterfaceType;
    okClassHelper : Result:=SCShClassHelperType;
    okRecordHelper : Result:=SCShRecordHelperType;
    okTypeHelper : Result:=SCShTypeHelperType;
  else
    Result:='ObjKind('+IntToStr(ord(ObjKind))+')';
  end;
end;

procedure TCShClassType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);

  ForEachChildCall(aMethodCall,Arg,AncestorType,true);
  for i:=0 to Interfaces.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Interfaces[i]),true);
  ForEachChildCall(aMethodCall,Arg,HelperForType,true);
  ForEachChildCall(aMethodCall,Arg,GUIDExpr,false);
end;

function TCShClassType.IsObjCClass: Boolean;

begin
  Result:=ObjKind in okObjCClasses;
end;

function TCShClassType.FindMember(MemberClass: TCShTreeElement; const MemberName: String): TCShElement;

Var
  I : Integer;

begin
//  Writeln('Looking for ',MemberName,'(',MemberClass.ClassName,') in ',Name);
  Result:=Nil;
  I:=0;
  While (Result=Nil) and (I<Members.Count) do
    begin
    Result:=TCShElement(Members[i]);
    if (Result.ClassType<>MemberClass) or (CompareText(Result.Name,MemberName)<>0) then
      Result:=Nil;
    Inc(I);
    end;
end;

function TCShClassType.FindMemberInAncestors(MemberClass: TCShTreeElement;
  const MemberName: String): TCShElement;

  Function A (C : TCShClassType) : TCShClassType;

  begin
    if C.AncestorType is TCShClassType then
      result:=TCShClassType(C.AncestorType)
    else
      result:=Nil;
  end;

Var
  C : TCShClassType;

begin
  Result:=Nil;
  C:=A(Self);
  While (Result=Nil) and (C<>Nil) do
    begin
    Result:=C.FindMember(MemberClass,MemberName);
    C:=A(C);
    end;
end;

function TCShClassType.InterfaceGUID: string;
begin
  If Assigned(GUIDExpr) then
    Result:=GUIDExpr.GetDeclaration(True)
  else
    Result:=''
end;

function TCShClassType.IsSealed: Boolean;
begin
  Result:=HasModifier('sealed');
end;

function TCShClassType.IsAbstract: Boolean;
begin
  Result:=HasModifier('abstract');
end;

function TCShClassType.HasModifier(const aModifier: String): Boolean;
var
  i: Integer;
begin
  for i:=0 to Modifiers.Count-1 do
    if CompareText(aModifier,Modifiers[i])=0 then
      exit(true);
  Result:=false;
end;

{ TCShArgument }

destructor TCShArgument.Destroy;
begin
  ReleaseAndNil(TCShElement(ArgType){$IFDEF CheckCShTreeRefCount},'TCShArgument.ArgType'{$ENDIF});
  ReleaseAndNil(TCShElement(ValueExpr){$IFDEF CheckCShTreeRefCount},'TCShArgument.ValueExpr'{$ENDIF});
  inherited Destroy;
end;

{ TCShProcedureType }

// inline
function TCShProcedureType.GetIsAsync: Boolean;
begin
  Result:=ptmAsync in Modifiers;
end;

// inline
function TCShProcedureType.GetIsNested: Boolean;
begin
  Result:=ptmIsNested in Modifiers;
end;

// inline
function TCShProcedureType.GetIsOfObject: Boolean;
begin
  Result:=ptmOfObject in Modifiers;
end;

// inline
function TCShProcedureType.GetIsReference: Boolean;
begin
  Result:=ptmReferenceTo in Modifiers;
end;

procedure TCShProcedureType.SetIsAsync(const AValue: Boolean);
begin
  if AValue then
    Include(Modifiers,ptmAsync)
  else
    Exclude(Modifiers,ptmAsync);
end;

procedure TCShProcedureType.SetIsNested(const AValue: Boolean);
begin
  if AValue then
    Include(Modifiers,ptmIsNested)
  else
    Exclude(Modifiers,ptmIsNested);
end;

procedure TCShProcedureType.SetIsOfObject(const AValue: Boolean);
begin
  if AValue then
    Include(Modifiers,ptmOfObject)
  else
    Exclude(Modifiers,ptmOfObject);
end;

procedure TCShProcedureType.SetIsReference(AValue: Boolean);
begin
  if AValue then
    Include(Modifiers,ptmReferenceTo)
  else
    Exclude(Modifiers,ptmReferenceTo);
end;

constructor TCShProcedureType.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Args := TFPList.Create;
end;

destructor TCShProcedureType.Destroy;
var
  i: Integer;
begin
  for i := 0 to Args.Count - 1 do
    TCShArgument(Args[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShProcedureType.Args'){$ENDIF};
  FreeAndNil(Args);
  ReleaseAndNil(TCShElement(VarArgsType){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
  inherited Destroy;
end;

class function TCShProcedureType.TypeName: string;
begin
  Result := 'procedure';
end;

function TCShProcedureType.CreateArgument(const AName,
  AUnresolvedTypeName: string): TCShArgument;
begin
  Result := TCShArgument.Create(AName, Self);
  Args.Add(Result);
  if AUnresolvedTypeName<>'' then
    Result.ArgType := TCShUnresolvedTypeRef.Create(AUnresolvedTypeName, Result);
end;

procedure TCShProcedureType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to Args.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Args[i]),false);
  ForEachChildCall(aMethodCall,Arg,VarArgsType,false);
end;

{ TCShResultElement }

destructor TCShResultElement.Destroy;
begin
  if Assigned(ResultType) then
    ReleaseAndNil(TCShElement(ResultType){$IFDEF CheckCShTreeRefCount},'TCShResultElement.ResultType'{$ENDIF});
  inherited Destroy;
end;

destructor TCShFunctionType.Destroy;
begin
  ReleaseAndNil(TCShElement(ResultEl){$IFDEF CheckCShTreeRefCount},'TCShFunctionType.ResultEl'{$ENDIF});
  inherited Destroy;
end;


class function TCShFunctionType.TypeName: string;
begin
  Result := 'function';
end;


constructor TCShUnresolvedTypeRef.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, nil);
  if AParent=nil then ;
end;


destructor TCShVariable.Destroy;
begin
//  FreeAndNil(Expr);
  { Attention, in derived classes, VarType isn't necessarily set!
    (e.g. in Constants) }
  ReleaseAndNil(TCShElement(VarType){$IFDEF CheckCShTreeRefCount},'TCShVariable.VarType'{$ENDIF});
  ReleaseAndNil(TCShElement(Expr){$IFDEF CheckCShTreeRefCount},'TCShVariable.Expr'{$ENDIF});
  ReleaseAndNil(TCShElement(LibraryName){$IFDEF CheckCShTreeRefCount},'TCShVariable.LibraryName'{$ENDIF});
  ReleaseAndNil(TCShElement(ExportName){$IFDEF CheckCShTreeRefCount},'TCShVariable.ExportName'{$ENDIF});
  ReleaseAndNil(TCShElement(AbsoluteExpr){$IFDEF CheckCShTreeRefCount},'TCShVariable.AbsoluteExpr'{$ENDIF});
  inherited Destroy;
end;

function TCShProperty.GetIsClass: boolean;
begin
  Result:=vmClass in VarModifiers;
end;

procedure TCShProperty.SetIsClass(AValue: boolean);
begin
   if AValue then
    Include(VarModifiers,vmClass)
  else
    Exclude(VarModifiers,vmClass);
end;

constructor TCShProperty.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  FArgs := TFPList.Create;
end;

destructor TCShProperty.Destroy;
var
  i: Integer;
begin
  for i := 0 to Args.Count - 1 do
    TCShArgument(Args[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShProperty.Args'){$ENDIF};
  FreeAndNil(FArgs);
  ReleaseAndNil(TCShElement(IndexExpr){$IFDEF CheckCShTreeRefCount},'TCShProperty.IndexExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(ReadAccessor){$IFDEF CheckCShTreeRefCount},'TCShProperty.ReadAccessor'{$ENDIF});
  ReleaseAndNil(TCShElement(WriteAccessor){$IFDEF CheckCShTreeRefCount},'TCShProperty.WriteAccessor'{$ENDIF});
  for i := 0 to length(Implements) - 1 do
    TCShExpr(Implements[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShProperty.Implements'){$ENDIF};
  SetLength(Implements,0);
  ReleaseAndNil(TCShElement(StoredAccessor){$IFDEF CheckCShTreeRefCount},'TCShProperty.StoredAccessor'{$ENDIF});
  ReleaseAndNil(TCShElement(DefaultExpr){$IFDEF CheckCShTreeRefCount},'TCShProperty.DefaultExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(DispIDExpr){$IFDEF CheckCShTreeRefCount},'TCShProperty.DispIDExpr'{$ENDIF});
  inherited Destroy;
end;


constructor TCShOverloadedProc.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Overloads := TFPList.Create;
end;

destructor TCShOverloadedProc.Destroy;
var
  i: Integer;
begin
  for i := 0 to Overloads.Count - 1 do
    TCShProcedure(Overloads[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShOverloadedProc.Overloads'){$ENDIF};
  FreeAndNil(Overloads);
  inherited Destroy;
end;

function TCShOverloadedProc.TypeName: string;
begin
  if Assigned(TCShProcedure(Overloads[0]).ProcType) then
    Result := TCShProcedure(Overloads[0]).ProcType.TypeName
  else
    SetLength(Result, 0);
end;

procedure TCShOverloadedProc.ForEachCall(
  const aMethodCall: TOnForEachCShElement; const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to Overloads.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShProcedure(Overloads[i]),false);
end;

function TCShProcedure.GetCallingConvention: TCallingConvention;
begin
  Result:=ccDefault;
  if Assigned(ProcType) then
    Result:=ProcType.CallingConvention;
end;

procedure TCShProcedure.SetCallingConvention(AValue: TCallingConvention);
begin
  if Assigned(ProcType) then
    ProcType.CallingConvention:=AValue;
end;

destructor TCShProcedure.Destroy;
begin
  ReleaseAndNil(TCShElement(PublicName){$IFDEF CheckCShTreeRefCount},'TCShProcedure.PublicName'{$ENDIF});
  ReleaseAndNil(TCShElement(LibraryExpr){$IFDEF CheckCShTreeRefCount},'TCShProcedure.LibraryExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(LibrarySymbolName){$IFDEF CheckCShTreeRefCount},'TCShProcedure.LibrarySymbolName'{$ENDIF});
  ReleaseAndNil(TCShElement(DispIDExpr){$IFDEF CheckCShTreeRefCount},'TCShProcedure.DispIDExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(MessageExpr){$IFDEF CheckCShTreeRefCount},'TCShProcedure.MessageExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(ProcType){$IFDEF CheckCShTreeRefCount},'TCShProcedure.ProcType'{$ENDIF});
  ReleaseAndNil(TCShElement(Body){$IFDEF CheckCShTreeRefCount},'TCShProcedure.Body'{$ENDIF});
  ReleaseProcNameParts(NameParts);
  inherited Destroy;
end;

function TCShProcedure.TypeName: string;
begin
  Result := 'procedure';
end;

constructor TCShProcedureImpl.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Locals := TFPList.Create;
end;

destructor TCShProcedureImpl.Destroy;
var
  i: Integer;
begin
  ReleaseAndNil(TCShElement(Body){$IFDEF CheckCShTreeRefCount},'TCShProcedureImpl.Body'{$ENDIF});

  for i := 0 to Locals.Count - 1 do
    TCShElement(Locals[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShProcedureImpl.Locals'){$ENDIF};
  FreeAndNil(Locals);

  ReleaseAndNil(TCShElement(ProcType){$IFDEF CheckCShTreeRefCount},'TCShProcedureImpl.ProcType'{$ENDIF});

  inherited Destroy;
end;

function TCShProcedureImpl.TypeName: string;
begin
  Result := ProcType.TypeName;
end;


function TCShConstructorImpl.TypeName: string;
begin
  Result := 'constructor';
end;

function TCShDestructorImpl.TypeName: string;
begin
  Result := 'destructor';
end;


constructor TCShImplCommands.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Commands := TStringList.Create;
end;

destructor TCShImplCommands.Destroy;
begin
  FreeAndNil(Commands);
  inherited Destroy;
end;


destructor TCShImplIfElse.Destroy;
begin
  ReleaseAndNil(TCShElement(ConditionExpr){$IFDEF CheckCShTreeRefCount},'TCShImplIfElse.ConditionExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(IfBranch){$IFDEF CheckCShTreeRefCount},'TCShImplIfElse.IfBranch'{$ENDIF});
  ReleaseAndNil(TCShElement(ElseBranch){$IFDEF CheckCShTreeRefCount},'TCShImplIfElse.ElseBranch'{$ENDIF});
  inherited Destroy;
end;

procedure TCShImplIfElse.AddElement(Element: TCShImplElement);
begin
  inherited AddElement(Element);
  if IfBranch=nil then
    begin
    IfBranch:=Element;
    Element.AddRef{$IFDEF CheckCShTreeRefCount}('TCShImplIfElse.IfBranch'){$ENDIF};
    end
  else if ElseBranch=nil then
    begin
    ElseBranch:=Element;
    Element.AddRef{$IFDEF CheckCShTreeRefCount}('TCShImplIfElse.ElseBranch'){$ENDIF};
    end
  else
    raise ECShTree.Create('TCShImplIfElse.AddElement if and else already set - please report this bug');
end;

function TCShImplIfElse.CloseOnSemicolon: boolean;
begin
  Result:=ElseBranch<>nil;
end;

procedure TCShImplIfElse.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  ForEachChildCall(aMethodCall,Arg,ConditionExpr,false);
  if Elements.IndexOf(IfBranch)<0 then
    ForEachChildCall(aMethodCall,Arg,IfBranch,false);
  if Elements.IndexOf(ElseBranch)<0 then
    ForEachChildCall(aMethodCall,Arg,ElseBranch,false);
  inherited ForEachCall(aMethodCall, Arg);
end;

function TCShImplIfElse.Condition: string;
begin
  If Assigned(ConditionExpr) then
    Result:=ConditionExpr.GetDeclaration(True)
  else
    Result:='';
end;

destructor TCShImplForLoop.Destroy;
begin
  ReleaseAndNil(TCShElement(VariableName){$IFDEF CheckCShTreeRefCount},'TCShImplForLoop.VariableName'{$ENDIF});
  ReleaseAndNil(TCShElement(StartExpr){$IFDEF CheckCShTreeRefCount},'TCShImplForLoop.StartExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(EndExpr){$IFDEF CheckCShTreeRefCount},'TCShImplForLoop.EndExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(Variable){$IFDEF CheckCShTreeRefCount},'TCShImplForLoop.Variable'{$ENDIF});
  ReleaseAndNil(TCShElement(Body){$IFDEF CheckCShTreeRefCount},'TCShImplForLoop.Body'{$ENDIF});
  inherited Destroy;
end;

procedure TCShImplForLoop.AddElement(Element: TCShImplElement);
begin
  inherited AddElement(Element);
  if Body=nil then
    begin
    Body:=Element;
    Body.AddRef{$IFDEF CheckCShTreeRefCount}('TCShImplForLoop.Body'){$ENDIF};
    end
  else
    raise ECShTree.Create('TCShImplForLoop.AddElement body already set - please report this bug');
end;

procedure TCShImplForLoop.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  ForEachChildCall(aMethodCall,Arg,VariableName,false);
  ForEachChildCall(aMethodCall,Arg,Variable,false);
  ForEachChildCall(aMethodCall,Arg,StartExpr,false);
  ForEachChildCall(aMethodCall,Arg,EndExpr,false);
  if Elements.IndexOf(Body)<0 then
    ForEachChildCall(aMethodCall,Arg,Body,false);
  inherited ForEachCall(aMethodCall, Arg);
end;

function TCShImplForLoop.Down: boolean;
begin
  Result:=(LoopType=ltDown);
end;

function TCShImplForLoop.StartValue: String;
begin
  If Assigned(StartExpr) then
    Result:=StartExpr.GetDeclaration(true)
  else
    Result:='';
end;

function TCShImplForLoop.EndValue: string;
begin
  If Assigned(EndExpr) then
    Result:=EndExpr.GetDeclaration(true)
  else
    Result:='';
end;

constructor TCShImplBlock.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Elements := TFPList.Create;
end;

destructor TCShImplBlock.Destroy;
var
  i: Integer;
begin
  for i := 0 to Elements.Count - 1 do
    TCShImplElement(Elements[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShImplBlock.Elements'){$ENDIF};
  FreeAndNil(Elements);
  inherited Destroy;
end;

procedure TCShImplBlock.AddElement(Element: TCShImplElement);
begin
  Elements.Add(Element);
end;

function TCShImplBlock.AddCommand(const ACommand: string): TCShImplCommand;
begin
  Result := TCShImplCommand.Create('', Self);
  Result.Command := ACommand;
  AddElement(Result);
end;

function TCShImplBlock.AddCommands: TCShImplCommands;
begin
  Result := TCShImplCommands.Create('', Self);
  AddElement(Result);
end;

function TCShImplBlock.AddBeginBlock: TCShImplBeginBlock;
begin
  Result := TCShImplBeginBlock.Create('', Self);
  AddElement(Result);
end;

function TCShImplBlock.AddRepeatUntil: TCShImplRepeatUntil;
begin
  Result := TCShImplRepeatUntil.Create('', Self);
  AddElement(Result);
end;

function TCShImplBlock.AddIfElse(const ACondition: TCShExpr): TCShImplIfElse;
begin
  Result := TCShImplIfElse.Create('', Self);
  Result.ConditionExpr := ACondition;
  AddElement(Result);
end;

function TCShImplBlock.AddWhileDo(const ACondition: TCShExpr): TCShImplWhileDo;
begin
  Result := TCShImplWhileDo.Create('', Self);
  Result.ConditionExpr := ACondition;
  AddElement(Result);
end;

function TCShImplBlock.AddWithDo(const Expression: TCShExpr): TCShImplWithDo;
begin
  Result := TCShImplWithDo.Create('', Self);
  Result.AddExpression(Expression);
  AddElement(Result);
end;

function TCShImplBlock.AddCaseOf(const Expression: TCShExpr): TCShImplCaseOf;
begin
  Result := TCShImplCaseOf.Create('', Self);
  Result.CaseExpr:= Expression;
  AddElement(Result);
end;

function TCShImplBlock.AddForLoop(AVar: TCShVariable; const AStartValue,
  AEndValue: TCShExpr): TCShImplForLoop;
begin
  Result := TCShImplForLoop.Create('', Self);
  Result.Variable := AVar;
  Result.StartExpr := AStartValue;
  Result.EndExpr:= AEndValue;
  AddElement(Result);
end;

function TCShImplBlock.AddForLoop(AVarName: TCShExpr; AStartValue,
  AEndValue: TCShExpr; ADownTo: Boolean): TCShImplForLoop;
begin
  Result := TCShImplForLoop.Create('', Self);
  Result.VariableName := AVarName;
  Result.StartExpr := AStartValue;
  Result.EndExpr := AEndValue;
  if ADownto then
    Result.Looptype := ltDown;
  AddElement(Result);
end;

function TCShImplBlock.AddTry: TCShImplTry;
begin
  Result := TCShImplTry.Create('', Self);
  AddElement(Result);
end;

function TCShImplBlock.AddExceptOn(const VarName, TypeName: string
  ): TCShImplExceptOn;
begin
  Result:=AddExceptOn(VarName,TCShUnresolvedTypeRef.Create(TypeName,nil));
end;

function TCShImplBlock.AddExceptOn(const VarName: string; VarType: TCShType
  ): TCShImplExceptOn;
var
  V: TCShVariable;
begin
  V:=TCShVariable.Create(VarName,nil);
  V.VarType:=VarType;
  Result:=AddExceptOn(V);
end;

function TCShImplBlock.AddExceptOn(const VarEl: TCShVariable): TCShImplExceptOn;
begin
  Result:=TCShImplExceptOn.Create('',Self);
  Result.VarEl:=VarEl;
  Result.TypeEl:=VarEl.VarType;
  Result.TypeEl.AddRef{$IFDEF CheckCShTreeRefCount}('TCShImplExceptOn.TypeEl'){$ENDIF};
  AddElement(Result);
end;

function TCShImplBlock.AddExceptOn(const TypeEl: TCShType): TCShImplExceptOn;
begin
  Result:=TCShImplExceptOn.Create('',Self);
  Result.TypeEl:=TypeEl;
  AddElement(Result);
end;

function TCShImplBlock.AddRaise: TCShImplRaise;
begin
  Result:=TCShImplRaise.Create('',Self);
  AddElement(Result);
end;

function TCShImplBlock.AddLabelMark(const Id: string): TCShImplLabelMark;
begin
  Result:=TCShImplLabelMark.Create('', Self);
  Result.LabelId:=Id;
  AddElement(Result);
end;

function TCShImplBlock.AddAssign(left,right:TCShExpr):TCShImplAssign;
begin
  Result:=TCShImplAssign.Create('', Self);
  Result.left:=left;
  Result.right:=right;
  AddElement(Result);
end;

function TCShImplBlock.AddSimple(exp:TCShExpr):TCShImplSimple;
begin
  Result:=TCShImplSimple.Create('', Self);
  Result.Expr:=exp;
  AddElement(Result);
end;

function TCShImplBlock.CloseOnSemicolon: boolean;
begin
  Result:=false;
end;

procedure TCShImplBlock.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to Elements.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Elements[i]),false);
end;



{ ---------------------------------------------------------------------

  ---------------------------------------------------------------------}

function TCShModule.GetDeclaration(full : boolean): string;
begin
  Result := 'Unit ' + SafeName;
  if full then ;
end;

procedure TCShModule.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,ImplementationSection,false);
  ForEachChildCall(aMethodCall,Arg,InitializationSection,false);
  ForEachChildCall(aMethodCall,Arg,FinalizationSection,false);
end;

procedure TCShModule.ReleaseUsedNamespace;
begin
  if ImplementationSection<>nil then
    ImplementationSection.ReleaseUsedNamespaces;
end;

function TCShResString.GetDeclaration(full: Boolean): string;
begin
  Result:=Expr.GetDeclaration(true);
  If Full Then
    begin
    Result:=SafeName+' = '+Result;
    ProcessHints(False,Result);
    end;
end;

procedure TCShResString.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,Expr,false);
end;

destructor TCShResString.Destroy;
begin
  ReleaseAndNil(TCShElement(Expr){$IFDEF CheckCShTreeRefCount},'TCShResString.Expr'{$ENDIF});
  inherited Destroy;
end;

function TCShPointerType.GetDeclaration(full: Boolean): string;
begin
  Result:='^'+DestType.SafeName;
  If Full then
    begin
    Result:=SafeName+' = '+Result;
    ProcessHints(False,Result);
    end;
end;

procedure TCShPointerType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,DestType,true);
end;

procedure TCShPointerType.ClearTypeReferences(aType: TCShElement);
begin
  if DestType=aType then
    ReleaseAndNil(TCShElement(DestType){$IFDEF CheckCShTreeRefCount},'TCShPointerType.DestType'{$ENDIF});
end;

function TCShAliasType.GetDeclaration(full: Boolean): string;
begin
  Result:=DestType.SafeName;
  If Full then
    Result:=FixTypeDecl(Result);
end;

procedure TCShAliasType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,DestType,true);
  ForEachChildCall(aMethodCall,Arg,Expr,false);
end;

procedure TCShAliasType.ClearTypeReferences(aType: TCShElement);
begin
  if DestType=aType then
    ReleaseAndNil(TCShElement(DestType){$IFDEF CheckCShTreeRefCount},'TCShAliasType.DestType'{$ENDIF});
end;

function TCShClassOfType.GetDeclaration (full : boolean) : string;
begin
  Result:='class of '+DestType.SafeName;
  If Full then
    Result:=FixTypeDecl(Result);
end;

function TCShRangeType.GetDeclaration (full : boolean) : string;
begin
  Result:=RangeStart+'..'+RangeEnd;
  If Full then
    Result:=FixTypeDecl(Result);
end;

procedure TCShRangeType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,RangeExpr,false);
end;

destructor TCShRangeType.Destroy;
begin
  ReleaseAndNil(TCShElement(RangeExpr){$IFDEF CheckCShTreeRefCount},'TCShRangeType.RangeExpr'{$ENDIF});
  inherited Destroy;
end;

function TCShRangeType.RangeStart: String;
begin
  Result:=RangeExpr.Left.GetDeclaration(False);
end;

function TCShRangeType.RangeEnd: String;
begin
  Result:=RangeExpr.Right.GetDeclaration(False);
end;

function TCShArrayType.GetDeclaration (full : boolean) : string;
begin
  Result:='Array';
  if Full then
    begin
    if GenericTemplateTypes<>nil then
      Result:=SafeName+GenericTemplateTypesAsString(GenericTemplateTypes)+' = '+Result
    else
      Result:=SafeName+' = '+Result;
    end;
  If (IndexRange<>'') then
    Result:=Result+'['+IndexRange+']';
  Result:=Result+' of ';
  If IsPacked then
    Result := 'packed '+Result;      // 12/04/04 Dave - Added
  If Assigned(Eltype) then
    Result:=Result+ElType.SafeName
  else
    Result:=Result+'const';
end;

function TCShArrayType.IsGenericArray: Boolean;
begin
  Result:=GenericTemplateTypes<>nil;
end;

function TCShArrayType.IsPacked: Boolean;
begin
  Result:=PackMode=pmPacked;
end;

procedure TCShArrayType.AddRange(Range: TCShExpr);
var
  i: Integer;
begin
  i:=Length(Ranges);
  SetLength(Ranges, i+1);
  Ranges[i]:=Range;
end;

function TCShFileType.GetDeclaration (full : boolean) : string;
begin
  Result:='File';
  If Assigned(Eltype) then
    Result:=Result+' of '+ElType.SafeName;
  If Full Then
    Result:=FixTypeDecl(Result);
end;

procedure TCShFileType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,ElType,true);
end;

function TCShEnumType.GetDeclaration (full : boolean) : string;

Var
  S : TStringList;

begin
  S:=TStringList.Create;
  Try
    If Full and (Name<>'') then
      S.Add(SafeName+' = (')
    else
      S.Add('(');
    GetEnumNames(S);
    S[S.Count-1]:=S[S.Count-1]+')';
    If Full then
      Result:=IndentStrings(S,Length(SafeName)+4)
    else
      Result:=IndentStrings(S,1);
    if Full then
      ProcessHints(False,Result);
  finally
    S.Free;
  end;
end;

destructor TCShSetType.Destroy;
begin
  ReleaseAndNil(TCShElement(EnumType){$IFDEF CheckCShTreeRefCount},'TCShSetType.EnumType'{$ENDIF});
  inherited Destroy;
end;

function TCShSetType.GetDeclaration (full : boolean) : string;

Var
  S : TStringList;
  i : Integer;

begin
  If (EnumType is TCShEnumType) and (EnumType.Name='') then
    begin
    S:=TStringList.Create;
    Try
      If Full and (Name<>'') then
        S.Add(SafeName+'= Set of (')
      else
        S.Add('Set of (');
      TCShEnumType(EnumType).GetEnumNames(S);
      S[S.Count-1]:=S[S.Count-1]+')';
      I:=Pos('(',S[0]);
      Result:=IndentStrings(S,i);
    finally
      S.Free;
    end;
    end
  else
    begin
    Result:='Set of '+EnumType.SafeName;
    If Full then
      Result:=SafeName+' = '+Result;
    end;
  If Full then
    ProcessHints(False,Result);
end;

procedure TCShSetType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,EnumType,true);
end;

{ TCShMembersType }

constructor TCShMembersType.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  PackMode:=pmNone;
  Members := TFPList.Create;
  GenericTemplateTypes:=TFPList.Create;
end;

destructor TCShMembersType.Destroy;
var
  i: Integer;
  El: TCShElement;
begin
  for i := 0 to Members.Count - 1 do
    begin
    El:=TCShElement(Members[i]);
    El.Parent:=nil;
    El.Release{$IFDEF CheckCShTreeRefCount}('TCShMembersType.Members'){$ENDIF};
    end;
  FreeAndNil(Members);

  ReleaseGenericTemplateTypes(GenericTemplateTypes
    {$IFDEF CheckCShTreeRefCount},'TCShMembersType.GenericTemplateTypes'{$ENDIF});

  inherited Destroy;
end;

function TCShMembersType.IsPacked: Boolean;
begin
  Result:=(PackMode <> pmNone);
end;

function TCShMembersType.IsBitPacked: Boolean;
begin
  Result:=(PackMode=pmBitPacked)
end;

procedure TCShMembersType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to Members.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Members[i]),false);
end;

{ TCShRecordType }

procedure TCShRecordType.GetMembers(S: TStrings);

Var
  T : TStringList;
  temp : string;
  I,J : integer;
  E : TCShElement;
  CV : TCShMemberVisibility ;

begin
  T:=TStringList.Create;
  try

  CV:=visDefault;
  For I:=0 to Members.Count-1 do
    begin
    E:=TCShElement(Members[i]);
    if E.Visibility<>CV then
      begin
      CV:=E.Visibility;
      if CV<>visDefault then
        S.Add(VisibilityNames[CV]);
      end;
    Temp:=E.GetDeclaration(True);
    If E is TCShProperty then
      Temp:='property '+Temp;
    If Pos(LineEnding,Temp)>0 then
      begin
      T.Text:=Temp;
      For J:=0 to T.Count-1 do
        if J=T.Count-1 then
          S.Add('  '+T[J]+';')
        else
          S.Add('  '+T[J])
      end
    else
      S.Add('  '+Temp+';');
    end;
  if Variants<>nil then
    begin
    temp:='case ';
    if (VariantEl is TCShVariable) then
      temp:=Temp+VariantEl.Name+' : '+TCShVariable(VariantEl).VarType.Name
    else if (VariantEl<>Nil) then
      temp:=temp+VariantEl.Name;
    S.Add(temp+' of');
    T.Clear;
    For I:=0 to Variants.Count-1 do
      T.Add(TCShVariant(Variants[i]).GetDeclaration(True));
    S.AddStrings(T);
    end;
  finally
    T.Free;
  end;
end;

function TCShRecordType.GetDeclaration (full : boolean) : string;

Var
  S : TStringList;
  temp : string;
begin
  S:=TStringList.Create;
  Try
    Temp:='record';
    If IsPacked then
      if IsBitPacked then
        Temp:='bitpacked '+Temp
      else
        Temp:='packed '+Temp;
    If Full and (Name<>'') then
      begin
      if GenericTemplateTypes.Count>0 then
        Temp:=SafeName+GenericTemplateTypesAsString(GenericTemplateTypes)+' = '+Temp
      else
        Temp:=SafeName+' = '+Temp;
      end;
    S.Add(Temp);
    GetMembers(S);
    S.Add('end');
    Result:=S.Text;
    if Full then
      ProcessHints(False, Result);
  finally
    S.free;
  end;
end;

procedure TCShRecordType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,VariantEl,true);
  if Variants<>nil then
    for i:=0 to Variants.Count-1 do
      ForEachChildCall(aMethodCall,Arg,TCShElement(Variants[i]),false);
end;

function TCShRecordType.IsAdvancedRecord: Boolean;

Var
  I : Integer;
  Member: TCShElement;

begin
  Result:=False;
  I:=0;
  While (Not Result) and (I<Members.Count) do
    begin
    Member:=TCShElement(Members[i]);
    if (Member.Visibility<>visPublic) then exit(true);
    if (Member.ClassType<>TCShVariable) then exit(true);
    Inc(I);
    end;
end;

procedure TCShProcedureType.GetArguments(List : TStrings);

Var
  T : string;
  I : Integer;

begin
  For I:=0 to Args.Count-1 do
    begin
    T:=AccessNames[TCShArgument(Args[i]).Access];
    T:=T+TCShArgument(Args[i]).GetDeclaration(True);
    If I=0 then
      T:='('+T;
    If I<Args.Count-1 then
      List.Add(T+'; ')
    else
      List.Add(T+')');
    end;
end;

function TCShProcedureType.GetDeclaration (full : boolean) : string;

Var
  S : TStringList;

begin
  S:=TStringList.Create;
  Try
    If Full then
      S.Add(Format('%s = ',[SafeName]));
    S.Add(TypeName);
    GetArguments(S);
    If IsOfObject then
      S.Add(' of object')
    else if IsNested then
      S.Add(' is nested');
    If Full then
      Result:=IndentStrings(S,Length(S[0])+Length(S[1])+1)
    else
      Result:=IndentStrings(S,Length(S[0])+1);
  finally
    S.Free;
  end;
end;

function TCShFunctionType.GetDeclaration(Full: boolean): string;

Var
  S : TStringList;
  T : string;

begin
  S:=TStringList.Create;
  Try
    If Full then
      S.Add(Format('%s = ',[SafeName]));
    S.Add(TypeName);
    GetArguments(S);
    If Assigned(ResultEl) then
      begin
      T:=' : ';
      If (ResultEl.ResultType.Name<>'') then
        T:=T+ResultEl.ResultType.SafeName
      else
        T:=T+ResultEl.ResultType.GetDeclaration(False);
      S.Add(T);
      end;
    If IsOfObject then
      S.Add(' of object');
    If Full then
      Result:=IndentStrings(S,Length(S[0])+Length(S[1])+1)
    else
      Result:=IndentStrings(S,Length(S[0])+1);
  finally
    S.Free;
  end;
end;

procedure TCShFunctionType.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,ResultEl,false);
end;

function TCShVariable.GetDeclaration (full : boolean) : string;

Const
 Seps : Array[Boolean] of Char = ('=',':');

begin
  If Assigned(VarType) then
    begin
    If VarType.Name='' then
      Result:=VarType.GetDeclaration(False)
    else
      Result:=VarType.SafeName;
    Result:=Result+Modifiers;
    if (Value<>'') then
      Result:=Result+' = '+Value;
    end
  else
    Result:=Value;
  If Full then
    begin
    Result:=SafeName+' '+Seps[Assigned(VarType)]+' '+Result;
    Result:=Result+HintsString;
    end;
end;

procedure TCShVariable.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,VarType,true);
  ForEachChildCall(aMethodCall,Arg,Expr,false);
  ForEachChildCall(aMethodCall,Arg,LibraryName,false);
  ForEachChildCall(aMethodCall,Arg,ExportName,false);
  ForEachChildCall(aMethodCall,Arg,AbsoluteExpr,false);
end;

procedure TCShVariable.ClearTypeReferences(aType: TCShElement);
begin
  if VarType=aType then
    ReleaseAndNil(TCShElement(VarType){$IFDEF CheckCShTreeRefCount},'TCShVariable.VarType'{$ENDIF});
end;


function TCShVariable.Value: String;
begin
  If Assigned(Expr) then
    Result:=Expr.GetDeclaration(True)
  else
    Result:='';
end;

function TCShProperty.GetDeclaration (full : boolean) : string;

Var
  S : string;
  I : Integer;

begin
  Result:='';
  If Assigned(VarType) then
    begin
    If VarType.Name='' then
      Result:=VarType.GetDeclaration(False)
    else
      Result:=VarType.SafeName;
    end
  else if Assigned(Expr) then
    Result:=Expr.GetDeclaration(True);
  S:='';
  If Assigned(Args) and (Args.Count>0) then
    begin
    For I:=0 to Args.Count-1 do
      begin
      If (S<>'') then
        S:=S+';';
      S:=S+TCShElement(Args[i]).GetDeclaration(true);
      end;
    end;
  If S<>'' then
    S:='['+S+']'
  else
    S:=' ';
  If Full then
    begin
    Result:=SafeName+S+': '+Result;
    If (ImplementsName<>'') then
       Result:=Result+' implements '+EscapeKeyWord(ImplementsName);
    end;   
  If IsDefault then
    Result:=Result+'; default';
  ProcessHints(True, Result);
end;

procedure TCShProperty.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,IndexExpr,false);
  for i:=0 to Args.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Args[i]),false);
  ForEachChildCall(aMethodCall,Arg,ReadAccessor,false);
  ForEachChildCall(aMethodCall,Arg,WriteAccessor,false);
  for i:=0 to length(Implements)-1 do
    ForEachChildCall(aMethodCall,Arg,Implements[i],false);
  ForEachChildCall(aMethodCall,Arg,StoredAccessor,false);
  ForEachChildCall(aMethodCall,Arg,DefaultExpr,false);
end;

function TCShProperty.ResolvedType: TCShType;

  Function GC(P : TCShProperty) : TCShClassType;

  begin
    if Assigned(P) and Assigned(P.Parent) and (P.Parent is TCShClassType) then
      Result:=P.Parent as TCShClassType
    else
      Result:=Nil;
  end;


Var
  P : TCShProperty;
  C : TCShClassType;

begin
  Result:=FResolvedType;
  if Result=Nil then
    Result:=VarType;
  P:=Self;
  While (Result=Nil) and (P<>Nil) do
    begin
    C:=GC(P);
//    Writeln('Looking for ',Name,' in ancestor ',C.Name);
    P:=TCShProperty(C.FindMemberInAncestors(TCShProperty,Name));
    if Assigned(P) then
      begin
//      Writeln('Found ',Name,' in ancestor : ',P.Name);
      Result:=P.ResolvedType;
      end
    end;
end;

function TCShProperty.IndexValue: String;
begin
  If Assigned(IndexExpr) then
    Result:=IndexExpr.GetDeclaration(true)
  else
    Result:='';
end;

function TCShProperty.DefaultValue: string;
begin
  If Assigned(DefaultExpr) then
    Result:=DefaultExpr.GetDeclaration(true)
  else
    Result:='';
end;

procedure TCShProcedure.GetModifiers(List: TStrings);

  Procedure DoAdd(B : Boolean; S : string);

  begin
    if B then
      List.add('; '+S);
  end;

begin
  Doadd(IsVirtual,' Virtual');
  DoAdd(IsDynamic,' Dynamic');
  DoAdd(IsOverride,' Override');
  DoAdd(IsAbstract,' Abstract');
  DoAdd(IsOverload,' Overload');
  DoAdd(IsReintroduced,' Reintroduce');
  DoAdd(IsStatic,' Static');
  DoAdd(IsMessage,' Message');
end;

procedure TCShProcedure.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i, j: Integer;
  Templates: TFPList;
begin
  inherited ForEachCall(aMethodCall, Arg);
  if NameParts<>nil then
    for i:=0 to NameParts.Count-1 do
      begin
      Templates:=TProcedureNamePart(NameParts[i]).Templates;
      if Templates<>nil then
        for j:=0 to Templates.Count-1 do
          ForEachChildCall(aMethodCall,Arg,TCShElement(Templates[j]),false);
      end;
  ForEachChildCall(aMethodCall,Arg,ProcType,false);
  ForEachChildCall(aMethodCall,Arg,PublicName,false);
  ForEachChildCall(aMethodCall,Arg,LibraryExpr,false);
  ForEachChildCall(aMethodCall,Arg,LibrarySymbolName,false);
  ForEachChildCall(aMethodCall,Arg,MessageExpr,false);
  ForEachChildCall(aMethodCall,Arg,Body,false);
end;

procedure TCShProcedure.AddModifier(AModifier: TProcedureModifier);
begin
  Include(FModifiers,AModifier);
end;

function TCShProcedure.IsVirtual: Boolean;
begin
  Result:=pmVirtual in FModifiers;
end;

function TCShProcedure.IsDynamic: Boolean;
begin
  Result:=pmDynamic in FModifiers;
end;

function TCShProcedure.IsAbstract: Boolean;
begin
  Result:=pmAbstract in FModifiers;
end;

function TCShProcedure.IsOverride: Boolean;
begin
  Result:=pmOverride in FModifiers;
end;

function TCShProcedure.IsExported: Boolean;
begin
  Result:=pmExport in FModifiers;
end;

function TCShProcedure.IsExternal: Boolean;
begin
  Result:=pmExternal in FModifiers;
end;

function TCShProcedure.IsOverload: Boolean;
begin
  Result:=pmOverload in FModifiers;
end;

function TCShProcedure.IsMessage: Boolean;
begin
  Result:=pmMessage in FModifiers;
end;

function TCShProcedure.IsReintroduced: Boolean;
begin
  Result:=pmReintroduce in FModifiers;
end;

function TCShProcedure.IsStatic: Boolean;

begin
  Result:=ptmStatic in ProcType.Modifiers;
end;

function TCShProcedure.IsForward: Boolean;
begin
  Result:=pmForward in FModifiers;
end;

function TCShProcedure.IsAssembler: Boolean;
begin
  Result:=pmAssembler in FModifiers;
end;

function TCShProcedure.IsAsync: Boolean;
begin
  Result:=ProcType.IsAsync;
end;

function TCShProcedure.GetProcTypeEnum: TProcType;
begin
  Result:=ptProcedure;
end;

procedure TCShProcedure.SetNameParts(Parts: TProcedureNameParts);
var
  i, j: Integer;
  El: TCShElement;
begin
  if NameParts<>nil then
    ReleaseProcNameParts(NameParts);
  NameParts:=TFPList.Create;
  NameParts.Assign(Parts);
  Parts.Clear;
  for i:=0 to NameParts.Count-1 do
    with TProcedureNamePart(NameParts[i]) do
      if Templates<>nil then
        for j:=0 to Templates.Count-1 do
          begin
          El:=TCShElement(Templates[j]);
          El.Parent:=Self;
          end;
end;

function TCShProcedure.GetDeclaration(full: Boolean): string;
Var
  S : TStringList;
  T: String;
  i: Integer;
begin
  S:=TStringList.Create;
  try
    If Full then
      begin
      T:=TypeName;
      if NameParts<>nil then
        begin
        T:=T+' ';
        for i:=0 to NameParts.Count-1 do
          begin
          if i>0 then
            T:=T+'.';
          with TProcedureNamePart(NameParts[i]) do
            begin
            T:=T+Name;
            if Templates<>nil then
              T:=T+GenericTemplateTypesAsString(Templates);
            end;
          end;
        end
      else if Name<>'' then
        T:=T+' '+SafeName;
      S.Add(T);
      end;
    ProcType.GetArguments(S);
    If (ProcType is TCShFunctionType)
        and Assigned(TCShFunctionType(Proctype).ResultEl) then
      With TCShFunctionType(ProcType).ResultEl.ResultType do
        begin
        T:=' : ';
        If (Name<>'') then
          T:=T+SafeName
        else
          T:=T+GetDeclaration(False);
        S.Add(T);
        end;
    GetModifiers(S);
    Result:=IndentStrings(S,Length(S[0]));
  finally
    S.Free;
  end;
end;

function TCShFunction.TypeName: string;
begin
  Result:='function';
end;

function TCShFunction.GetProcTypeEnum: TProcType;
begin
  Result:=ptFunction;
end;

function TCShOperator.GetOperatorDeclaration(Full : Boolean) : string;

begin
  if Full then
    begin
    Result:=FullPath;
    if (Result<>'') then
      Result:=Result+'.';
    end
  else
    Result:='';
  if TokenBased then
    Result:=Result+TypeName+' '+OperatorTypeToToken(OperatorType)
  else
    Result:=Result+TypeName+' '+OperatorTypeToOperatorName(OperatorType);
end;

function TCShOperator.GetDeclaration (full : boolean) : string;

Var
  S : TStringList;
  T : string;

begin
  S:=TStringList.Create;
  try
    If Full then
      S.Add(GetOperatorDeclaration(Full));
    ProcType.GetArguments(S);
    If Assigned((Proctype as TCShFunctionType).ResultEl) then
      With TCShFunctionType(ProcType).ResultEl.ResultType do
        begin
        T:=' : ';
        If (Name<>'') then
          T:=T+SafeName
        else
          T:=T+GetDeclaration(False);
        S.Add(T);
        end;
    GetModifiers(S);
    Result:=IndentStrings(S,Length(S[0]));

  finally
    S.Free;
  end;
end;

function TCShOperator.TypeName: string;
begin
  Result:='operator';
end;

function TCShOperator.GetProcTypeEnum: TProcType;
begin
  Result:=ptOperator;
end;

function TCShClassProcedure.TypeName: string;
begin
  Result:='class procedure';
end;

function TCShClassProcedure.GetProcTypeEnum: TProcType;
begin
  Result:=ptClassProcedure;
end;

function TCShClassFunction.TypeName: string;
begin
  Result:='class function';
end;

function TCShClassFunction.GetProcTypeEnum: TProcType;
begin
  Result:=ptClassFunction;
end;

function TCShConstructor.TypeName: string;
begin
  Result:='constructor';
end;

function TCShConstructor.GetProcTypeEnum: TProcType;
begin
  Result:=ptConstructor;
end;

function TCShDestructor.TypeName: string;
begin
  Result:='destructor';
end;

function TCShDestructor.GetProcTypeEnum: TProcType;
begin
  Result:=ptDestructor;
end;

function TCShArgument.GetDeclaration (full : boolean) : string;
begin
  If Assigned(ArgType) then
    begin
    If ArgType.Name<>'' then
      Result:=ArgType.SafeName
    else
      Result:=ArgType.GetDeclaration(False);
    If Full and (Name<>'') then
      Result:=SafeName+': '+Result;
    end
  else If Full then
    Result:=SafeName
  else
    Result:='';
end;

procedure TCShArgument.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,ArgType,true);
  ForEachChildCall(aMethodCall,Arg,ValueExpr,false);
end;

procedure TCShArgument.ClearTypeReferences(aType: TCShElement);
begin
  if ArgType=aType then
    ReleaseAndNil(TCShElement(ArgType){$IFDEF CheckCShTreeRefCount},'TCShArgument.ArgType'{$ENDIF});
end;

function TCShArgument.Value: String;
begin
  If Assigned(ValueExpr) then
    Result:=ValueExpr.GetDeclaration(true)
  else
    Result:='';
end;

{ TCShsTreeVisitor }

procedure TCShsTreeVisitor.Visit(obj: TCShElement);
begin
  // Needs to be implemented by descendents.
  if Obj=nil then ;
end;

{ TCShSection }

constructor TCShSection.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  UsesList := TFPList.Create;
end;

destructor TCShSection.Destroy;
begin
  ReleaseUsedNamespaces;
  FreeAndNil(UsesList);

  {$IFDEF VerboseCShTreeMem}writeln('TCShSection.Destroy inherited');{$ENDIF}
  inherited Destroy;
  {$IFDEF VerboseCShTreeMem}writeln('TCShSection.Destroy END');{$ENDIF}
end;

function TCShSection.AddUnitToUsesList(const AUnitName: string;
  aName: TCShExpr; InFilename: TPrimitiveExpr; aModule: TCShElement;
  UsesUnit: TCShUsingNamespace): TCShUsingNamespace;
var
  l: Integer;
begin
  if (InFilename<>nil) and (InFilename.Kind<>pekString) then
    raise ECShTree.Create('Wrong In expression for '+aUnitName);
  if aModule=nil then
    aModule:=TCShUnresolvedUnitRef.Create(AUnitName, Self);
  l:=length(UsesClause);
  SetLength(UsesClause,l+1);
  if UsesUnit=nil then
    begin
    UsesUnit:=TCShUsingNamespace.Create(AUnitName,Self);
    if aName<>nil then
      begin
      UsesUnit.SourceFilename:=aName.SourceFilename;
      UsesUnit.SourceLinenumber:=aName.SourceLinenumber;
      end;
    end;
  UsesClause[l]:=UsesUnit;
  UsesUnit.Expr:=aName;
  UsesUnit.InFilename:=InFilename;
  UsesUnit.Module:=aModule;
  Result:=UsesUnit;

  UsesList.Add(aModule);
  aModule.AddRef{$IFDEF CheckCShTreeRefCount}('TCShSection.UsesList'){$ENDIF};
end;

function TCShSection.ElementTypeName: string;
begin
  Result := SCShTreeSection;
end;

procedure TCShSection.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to length(UsesClause)-1 do
    ForEachChildCall(aMethodCall,Arg,UsesClause[i],false);
end;

procedure TCShSection.ReleaseUsedNamespaces;
var
  i: Integer;
begin
  {$IFDEF VerboseCShTreeMem}writeln('TCShSection.Destroy UsesList');{$ENDIF}
  for i := 0 to UsesList.Count - 1 do
    TCShType(UsesList[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShSection.UsesList'){$ENDIF};
  UsesList.Clear;
  {$IFDEF VerboseCShTreeMem}writeln('TCShSection.Destroy UsesClause');{$ENDIF}
  for i := 0 to length(UsesClause) - 1 do
    UsesClause[i].Release{$IFDEF CheckCShTreeRefCount}('TCShSection.UsesClause'){$ENDIF};
  SetLength(UsesClause,0);

  PendingUsedIntf:=nil; // not release
end;

{ TProcedureBody }

constructor TProcedureBody.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
end;

destructor TProcedureBody.Destroy;
begin
  ReleaseAndNil(TCShElement(Body){$IFDEF CheckCShTreeRefCount},'TProcedureBody.Body'{$ENDIF});
  inherited Destroy;
end;

procedure TProcedureBody.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,Body,false);
end;

{ TCShImplWhileDo }

destructor TCShImplWhileDo.Destroy;
begin
  ReleaseAndNil(TCShElement(ConditionExpr){$IFDEF CheckCShTreeRefCount},'TCShImplWhileDo.ConditionExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(Body){$IFDEF CheckCShTreeRefCount},'TCShImplWhileDo.Body'{$ENDIF});
  inherited Destroy;
end;

procedure TCShImplWhileDo.AddElement(Element: TCShImplElement);
begin
  inherited AddElement(Element);
  if Body=nil then
    begin
    Body:=Element;
    Body.AddRef{$IFDEF CheckCShTreeRefCount}('TCShImplWhileDo.Body'){$ENDIF};
    end
  else
    raise ECShTree.Create('TCShImplWhileDo.AddElement body already set');
end;

procedure TCShImplWhileDo.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  ForEachChildCall(aMethodCall,Arg,ConditionExpr,false);
  if Elements.IndexOf(Body)<0 then
    ForEachChildCall(aMethodCall,Arg,Body,false);
  inherited ForEachCall(aMethodCall, Arg);
end;

function TCShImplWhileDo.Condition: string;
begin
  If Assigned(ConditionExpr) then
    Result:=ConditionExpr.GetDeclaration(True)
  else
    Result:='';
end;

{ TCShImplCaseOf }

destructor TCShImplCaseOf.Destroy;
begin
  ReleaseAndNil(TCShElement(CaseExpr){$IFDEF CheckCShTreeRefCount},'TCShImplCaseOf.CaseExpr'{$ENDIF});
  ReleaseAndNil(TCShElement(ElseBranch){$IFDEF CheckCShTreeRefCount},'TCShImplCaseOf.ElseBranch'{$ENDIF});
  inherited Destroy;
end;

procedure TCShImplCaseOf.AddElement(Element: TCShImplElement);
begin
  if (ElseBranch<>Nil) and (Element=ElseBranch) then
    ElseBranch.AddRef{$IFDEF CheckCShTreeRefCount}('TCShImplCaseOf.ElseBranch'){$ENDIF};
  inherited AddElement(Element);
end;

function TCShImplCaseOf.AddCase(const Expression: TCShExpr
  ): TCShImplCaseStatement;
begin
  Result:=TCShImplCaseStatement.Create('',Self);
  Result.AddExpression(Expression);
  AddElement(Result);
end;

function TCShImplCaseOf.AddElse: TCShImplCaseElse;
begin
  Result:=TCShImplCaseElse.Create('',Self);
  ElseBranch:=Result;
  AddElement(Result);
end;

procedure TCShImplCaseOf.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  ForEachChildCall(aMethodCall,Arg,CaseExpr,false);
  if Elements.IndexOf(ElseBranch)<0 then
    ForEachChildCall(aMethodCall,Arg,ElseBranch,false);
  inherited ForEachCall(aMethodCall, Arg);
end;

function TCShImplCaseOf.Expression: string;
begin
  if Assigned(CaseExpr) then
    Result:=CaseExpr.GetDeclaration(True)
  else
    Result:='';
end;

{ TCShImplCaseStatement }

constructor TCShImplCaseStatement.Create(const AName: string;
  AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Expressions:=TFPList.Create;
end;

destructor TCShImplCaseStatement.Destroy;

Var
  I : integer;

begin
  For I:=0 to Expressions.Count-1 do
    TCShExpr(Expressions[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShImplCaseStatement.CaseExpr'){$ENDIF};
  FreeAndNil(Expressions);
  ReleaseAndNil(TCShElement(Body){$IFDEF CheckCShTreeRefCount},'TCShImplCaseStatement.Body'{$ENDIF});
  inherited Destroy;
end;

procedure TCShImplCaseStatement.AddElement(Element: TCShImplElement);
begin
  inherited AddElement(Element);
  if Body=nil then
    begin
    Body:=Element;
    Body.AddRef{$IFDEF CheckCShTreeRefCount}('TCShImplCaseStatement.Body'){$ENDIF};
    end
  else
    raise ECShTree.Create('TCShImplCaseStatement.AddElement body already set');
end;

procedure TCShImplCaseStatement.AddExpression(const Expr: TCShExpr);
begin
  Expressions.Add(Expr);
  Expr.Parent:=Self;
end;

procedure TCShImplCaseStatement.ForEachCall(
  const aMethodCall: TOnForEachCShElement; const Arg: Pointer);
var
  i: Integer;
begin
  for i:=0 to Expressions.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Expressions[i]),false);
  if Elements.IndexOf(Body)<0 then
    ForEachChildCall(aMethodCall,Arg,Body,false);
  inherited ForEachCall(aMethodCall, Arg);
end;

{ TCShImplWithDo }

constructor TCShImplWithDo.Create(const AName: string; AParent: TCShElement);
begin
  inherited Create(AName, AParent);
  Expressions:=TFPList.Create;
end;

destructor TCShImplWithDo.Destroy;
Var
  I : Integer;
begin
  ReleaseAndNil(TCShElement(Body){$IFDEF CheckCShTreeRefCount},'TCShImplWithDo.Body'{$ENDIF});
  For I:=0 to Expressions.Count-1 do
    TCShExpr(Expressions[i]).Release{$IFDEF CheckCShTreeRefCount}('TCShImplWithDo.Expressions'){$ENDIF};
  FreeAndNil(Expressions);
  inherited Destroy;
end;

procedure TCShImplWithDo.AddElement(Element: TCShImplElement);
begin
  inherited AddElement(Element);
  if Body=nil then
    begin
    Body:=Element;
    Body.AddRef{$IFDEF CheckCShTreeRefCount}('TCShImplWithDo.Body'){$ENDIF};
    end
  else
    raise ECShTree.Create('TCShImplWithDo.AddElement body already set');
end;

procedure TCShImplWithDo.AddExpression(const Expression: TCShExpr);
begin
  Expressions.Add(Expression);
end;

procedure TCShImplWithDo.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  for i:=0 to Expressions.Count-1 do
    ForEachChildCall(aMethodCall,Arg,TCShElement(Expressions[i]),false);
  if Elements.IndexOf(Body)<0 then
    ForEachChildCall(aMethodCall,Arg,Body,false);
  inherited ForEachCall(aMethodCall, Arg);
end;

{ TCShImplTry }

destructor TCShImplTry.Destroy;
begin
  ReleaseAndNil(TCShElement(FinallyExcept){$IFDEF CheckCShTreeRefCount},'TCShImplTry.FinallyExcept'{$ENDIF});
  ReleaseAndNil(TCShElement(ElseBranch){$IFDEF CheckCShTreeRefCount},'TCShImplTry.ElseBranch'{$ENDIF});
  inherited Destroy;
end;

function TCShImplTry.AddFinally: TCShImplTryFinally;
begin
  Result:=TCShImplTryFinally.Create('',Self);
  FinallyExcept:=Result;
end;

function TCShImplTry.AddExcept: TCShImplTryExcept;
begin
  Result:=TCShImplTryExcept.Create('',Self);
  FinallyExcept:=Result;
end;

function TCShImplTry.AddExceptElse: TCShImplTryExceptElse;
begin
  Result:=TCShImplTryExceptElse.Create('',Self);
  ElseBranch:=Result;
end;

procedure TCShImplTry.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,FinallyExcept,false);
  ForEachChildCall(aMethodCall,Arg,ElseBranch,false);
end;

{ TCShImplExceptOn }

destructor TCShImplExceptOn.Destroy;
begin
  ReleaseAndNil(TCShElement(VarEl){$IFDEF CheckCShTreeRefCount},'TCShImplExceptOn.VarEl'{$ENDIF});
  ReleaseAndNil(TCShElement(TypeEl){$IFDEF CheckCShTreeRefCount},'TCShImplExceptOn.TypeEl'{$ENDIF});
  ReleaseAndNil(TCShElement(Body){$IFDEF CheckCShTreeRefCount},'TCShImplExceptOn.Body'{$ENDIF});
  inherited Destroy;
end;

procedure TCShImplExceptOn.AddElement(Element: TCShImplElement);
begin
  inherited AddElement(Element);
  if Body=nil then
    begin
    Body:=Element;
    Body.AddRef{$IFDEF CheckCShTreeRefCount}('TCShImplExceptOn.Body'){$ENDIF};
    end;
end;

procedure TCShImplExceptOn.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  ForEachChildCall(aMethodCall,Arg,VarEl,false);
  ForEachChildCall(aMethodCall,Arg,TypeEl,true);
  if Elements.IndexOf(Body)<0 then
    ForEachChildCall(aMethodCall,Arg,Body,false);
  inherited ForEachCall(aMethodCall, Arg);
end;

procedure TCShImplExceptOn.ClearTypeReferences(aType: TCShElement);
begin
  if TypeEl=aType then
    ReleaseAndNil(TCShElement(TypeEl){$IFDEF CheckCShTreeRefCount},'TCShImplExceptOn.TypeEl'{$ENDIF});
end;

function TCShImplExceptOn.VariableName: String;
begin
  If assigned(VarEl) then
    Result:=VarEl.Name
  else
    Result:='';
end;

function TCShImplExceptOn.TypeName: string;
begin
  If assigned(TypeEl) then
    Result:=TypeEl.GetDeclaration(True)
  else
    Result:='';
end;

{ TCShImplStatement }

function TCShImplStatement.CloseOnSemicolon: boolean;
begin
  Result:=true;
end;

{ TCShExpr }

constructor TCShExpr.Create(AParent: TCShElement; AKind: TCShExprKind;
  AOpCode: TExprOpCode);
begin
  inherited Create(ClassName, AParent);
  Kind:=AKind;
  OpCode:=AOpCode;
end;

destructor TCShExpr.Destroy;
begin
  ReleaseAndNil(TCShElement(Format1){$IFDEF CheckCShTreeRefCount},'TCShExpr.format1'{$ENDIF});
  ReleaseAndNil(TCShElement(Format2){$IFDEF CheckCShTreeRefCount},'TCShExpr.format2'{$ENDIF});
  inherited Destroy;
end;

{ TPrimitiveExpr }

function TPrimitiveExpr.GetDeclaration(full: Boolean): string;
begin
  Result:=Value;
  if full then ;
end;

constructor TPrimitiveExpr.Create(AParent : TCShElement; AKind: TCShExprKind; const AValue : string);
begin
  inherited Create(AParent,AKind, eopNone);
  Value:=AValue;
end;

{ TBoolConstExpr }

constructor TBoolConstExpr.Create(AParent : TCShElement; AKind: TCShExprKind; const ABoolValue : Boolean);
begin
  inherited Create(AParent,AKind, eopNone);
  Value:=ABoolValue;
end;

function TBoolConstExpr.GetDeclaration(full: Boolean): string;

begin
  If Value then
    Result:='True'
  else
    Result:='False';
  if full then ;
end;



{ TUnaryExpr }

function TUnaryExpr.GetDeclaration(full: Boolean): string;

Const
  WordOpcodes = [];

begin
  Result:=OpCodeStrings[Opcode];
  if OpCode in WordOpCodes  then
    Result:=Result+' ';
  If Assigned(Operand) then
    Result:=Result+' '+Operand.GetDeclaration(Full);
end;

constructor TUnaryExpr.Create(AParent : TCShElement; AOperand: TCShExpr; AOpCode: TExprOpCode);
begin
  inherited Create(AParent,pekUnary, AOpCode);
  Operand:=AOperand;
  Operand.Parent:=Self;
end;

destructor TUnaryExpr.Destroy;
begin
  ReleaseAndNil(TCShElement(Operand){$IFDEF CheckCShTreeRefCount},'TUnaryExpr.Operand'{$ENDIF});
  inherited Destroy;
end;

procedure TUnaryExpr.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,Operand,false);
end;

{ TBinaryExpr }

function TBinaryExpr.GetDeclaration(full: Boolean): string;
  function OpLevel(op: TCShExpr): Integer;
  begin
    case op.OpCode of
      eopNot,eopKomplement:
        Result := 4;
      eopMultiply, eopDivide, eopMod, eopSingleAnd, eopShl,
      eopShr, eopAs, eopPower:
        Result := 3;
      eopAdd, eopSubtract, eopSingleOr, eopXor:
        Result := 2;
      eopEqual, eopNotEqual, eopLessThan, eopLessthanEqual, eopGreaterThan,
      eopGreaterThanEqual, eopIn, eopIs:
        Result := 1;
    else
      Result := 5; // Numbers and Identifiers
    end;
  end;
var op: string;
begin
  If Kind=pekRange then
    Result:='..'
  else
    begin
    Result:=OpcodeStrings[Opcode];
    if Not (OpCode in [eopSubIdent]) then
      Result:=' '+Result+' ';
    end;
  If Assigned(Left) then
  begin
    op := Left.GetDeclaration(Full);
    if OpLevel(Left) < OpLevel(Self) then
      Result := '(' + op + ')' + Result
    else
      Result := op + Result;
  end;
  If Assigned(Right) then
  begin
    op := Right.GetDeclaration(Full);
    if OpLevel(Left) < OpLevel(Self) then
      Result := Result + '(' + op + ')'
    else
      Result := Result + op;
  end;
end;


constructor TBinaryExpr.Create(AParent : TCShElement; xleft,xright:TCShExpr; AOpCode:TExprOpCode);
begin
  inherited Create(AParent,pekBinary, AOpCode);
  left:=xleft;
  left.Parent:=Self;
  right:=xright;
  right.Parent:=Self;
end;

constructor TBinaryExpr.CreateRange(AParent : TCShElement; xleft,xright:TCShExpr);
begin
  inherited Create(AParent,pekRange, eopNone);
  left:=xleft;
  left.Parent:=Self;
  right:=xright;
  right.Parent:=Self;
end;

destructor TBinaryExpr.Destroy;
begin
  ReleaseAndNil(TCShElement(left){$IFDEF CheckCShTreeRefCount},'TBinaryExpr.left'{$ENDIF});
  ReleaseAndNil(TCShElement(right){$IFDEF CheckCShTreeRefCount},'TBinaryExpr.right'{$ENDIF});
  inherited Destroy;
end;

procedure TBinaryExpr.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,left,false);
  ForEachChildCall(aMethodCall,Arg,right,false);
end;

class function TBinaryExpr.IsRightSubIdent(El: TCShElement): boolean;
var
  Bin: TBinaryExpr;
begin
  if (El=nil) or not (El.Parent is TBinaryExpr) then exit(false);
  Bin:=TBinaryExpr(El.Parent);
  Result:=(Bin.right=El) and (Bin.OpCode=eopSubIdent);
end;

{ TParamsExpr }

function TParamsExpr.GetDeclaration(full: Boolean): string;

Var
  I : Integer;

begin
  Result := '';
  For I:=0 to High(Params) do
    begin
    If (Result<>'')  then
      Result:=Result+', ';
    Result:=Result+Params[I].GetDeclaration(Full);  
    end;
  if Kind in [pekSet,pekArrayParams] then
    Result := '[' + Result + ']'
  else
    Result := '(' + Result + ')';
  if full and Assigned(Value) then
    Result:=Value.GetDeclaration(True)+Result;
end;

procedure TParamsExpr.AddParam(xp:TCShExpr);
var
  i : Integer;
begin
  i:=Length(Params);
  SetLength(Params, i+1);
  Params[i]:=xp;
end;

procedure TParamsExpr.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  ForEachChildCall(aMethodCall,Arg,Value,false);
  for i:=0 to Length(Params)-1 do
    ForEachChildCall(aMethodCall,Arg,Params[i],false);
end;

constructor TParamsExpr.Create(AParent : TCShElement; AKind: TCShExprKind);
begin
  inherited Create(AParent,AKind, eopNone);
end;

destructor TParamsExpr.Destroy;
var
  i : Integer;
begin
  ReleaseAndNil(TCShElement(Value){$IFDEF CheckCShTreeRefCount},'TParamsExpr.Value'{$ENDIF});
  for i:=0 to length(Params)-1 do
    Params[i].Release{$IFDEF CheckCShTreeRefCount}('TParamsExpr.Params'){$ENDIF};
  inherited Destroy;
end;

{ TRecordValues }

function TRecordValues.GetDeclaration(full: Boolean): string;

Var
  I : Integer;
begin
  Result := '';
  For I:=0 to High(Fields) do
    begin
    If Result<>'' then
      Result:=Result+'; ';
    Result:=Result+EscapeKeyWord(Fields[I].Name)+': '+Fields[i].ValueExp.getDeclaration(Full);
    end;
  Result:='('+Result+')';
end;

procedure TRecordValues.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to length(Fields)-1 do
    with Fields[i] do
      begin
      if NameExp<>nil then
        ForEachChildCall(aMethodCall,Arg,NameExp,false);
      if ValueExp<>nil then
        ForEachChildCall(aMethodCall,Arg,ValueExp,false);
      end;
end;

constructor TRecordValues.Create(AParent : TCShElement);
begin
  inherited Create(AParent,pekListOfExp, eopNone);
end;

destructor TRecordValues.Destroy;
var
  i : Integer;
begin
  for i:=0 to length(Fields)-1 do
    begin
    Fields[i].NameExp.Release{$IFDEF CheckCShTreeRefCount}('TRecordValues.Fields.NameExpr'){$ENDIF};
    Fields[i].ValueExp.Release{$IFDEF CheckCShTreeRefCount}('TRecordValues.Fields.ValueExp'){$ENDIF};
    end;
  Fields:=nil;
  inherited Destroy;
end;

procedure TRecordValues.AddField(AName: TPrimitiveExpr; Value: TCShExpr);
var
  i : Integer;
begin
  i:=length(Fields);
  SetLength(Fields, i+1);
  Fields[i].Name:=AName.Value;
  Fields[i].NameExp:=AName;
  AName.Parent:=Self;
  Fields[i].ValueExp:=Value;
  Value.Parent:=Self;
end;

{ TNullExpr }

function TNullExpr.GetDeclaration(full: Boolean): string;
begin
  Result:='Nil';
  if full then ;
end;

{ TInheritedExpr }

function TInheritedExpr.GetDeclaration(full: Boolean): string;
begin
  Result:='Inherited';
  if full then ;
end;

{ TThisExpr }

function TThisExpr.GetDeclaration(full: Boolean): string;
begin
  Result:='Self';
  if full then ;
end;

{ TArrayValues }

function TArrayValues.GetDeclaration(full: Boolean): string;

Var
  I : Integer;

begin
  Result := '';
  For I:=0 to High(Values) do
    begin
    If Result<>'' then
      Result:=Result+', ';
    Result:=Result+Values[i].getDeclaration(Full);
    end;
  Result:='('+Result+')';
end;

procedure TArrayValues.ForEachCall(const aMethodCall: TOnForEachCShElement;
  const Arg: Pointer);
var
  i: Integer;
begin
  inherited ForEachCall(aMethodCall, Arg);
  for i:=0 to length(Values)-1 do
    ForEachChildCall(aMethodCall,Arg,Values[i],false);
end;

constructor TArrayValues.Create(AParent : TCShElement);
begin
  inherited Create(AParent,pekListOfExp, eopNone);
end;

destructor TArrayValues.Destroy;
var
  i : Integer;
begin
  for i:=0 to length(Values)-1 do
    Values[i].Release{$IFDEF CheckCShTreeRefCount}('TArrayValues.Values'){$ENDIF};
  Values:=nil;
  inherited Destroy;
end;

procedure TArrayValues.AddValues(AValue:TCShExpr);
var
  i : Integer;
begin
  i:=length(Values);
  SetLength(Values, i+1);
  Values[i]:=AValue;
  AValue.Parent:=Self;
end;

{ TNullExpr }

constructor TNullExpr.Create(AParent : TCShElement);
begin
  inherited Create(AParent,pekNull, eopNone);
end;

{ TInheritedExpr }

constructor TInheritedExpr.Create(AParent : TCShElement);
begin
  inherited Create(AParent,pekInherited, eopNone);
end;


{ TThisExpr }

constructor TThisExpr.Create(AParent : TCShElement);
begin
  inherited Create(AParent,pekThis, eopNone);
end;

{ TCShLabels }

constructor TCShLabels.Create(const AName:string;AParent:TCShElement);
begin
  inherited Create(AName,AParent);
  Labels := TStringList.Create;
end;

destructor TCShLabels.Destroy;
begin
  FreeAndNil(Labels);
  inherited Destroy;
end;

end.
