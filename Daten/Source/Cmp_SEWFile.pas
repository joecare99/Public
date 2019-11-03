UNIT Cmp_SEWFile;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}
INTERFACE

USES
  Unt_FileProcs,
  Unt_StringProcs,
  classes;

TYPE
  tAHFCallback = procedure (const aKey,aValue:String;LineNo:integer) of object;
  { TSEW_Exp_File }

  TenumVarsection=(vs_Var,vs_VarInput,vs_VarOutput,vs_VarInOut,vs_VarConst);
  TenumVarType=(vt_Any);

  TKnownIdentifyer=record
     Name,
     Comment,
     DefaultValue:String;
     VarSection:TenumVarsection;
     VarType:TVartype;
     VarTypeString:String;
  end;

  TKnownIdentifyerList = array of TKnownIdentifyer;

  TSEW_Exp_File = CLASS(CFileInfo)
  PRIVATE
    /// <author>C. Rosewich</author>
    /// <since>30.11.2014</since>
    FFileEncoding:string;
    /// <author>C. Rosewich</author>
    /// <since>30.11.2014</since>
    FAuthor:string;
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    FLines: TStrings;
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    FOptions: TStrings;
    /// <author>C. Rosewich</author>
    /// <since>30.11.2014</since>
    FVersion: String;
    /// <author>C. Rosewich</author>
    /// <since>03.12.2014</since>
    FPath: String;
    /// <author>C. Rosewich</author>
    /// <since>03.12.2014</since>
    Ftype: String;
    /// <author>C. Rosewich</author>
    /// <since>03.12.2014</since>
    FHeaderIdx: array[0..8] of integer;
    /// <author>C. Rosewich</author>
    /// <since>14.04.2015</since>
     FKnownIdentifyer: TKnownIdentifyerList;
    class procedure AppendFIHeaderField(const Key, Value: String;{%H-}LineNo:integer);
    function GetAuthor: String;
    CLASS procedure IntParseHeaderLines(const Lines: TStrings; AppendHeaderField: TAHFCallback);
    Procedure SetHeaderField(const Key, Value: String;LineNo:integer);
    procedure SetAuthor(AValue: String);
    procedure SetPath(AValue: String);
    procedure SetType(AValue: String);
    procedure SetVersion(AValue: String);
    procedure CodeChange(Sender: TObject);
    procedure UpdateLineHF(const Ix: Integer; const AValue: String);
    Procedure InsertHeader;
  PUBLIC
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    CONSTRUCTOR Create; REINTRODUCE;
    /// <author>C. Rosewich</author>
    /// <since>28.11.2014</since>
    destructor Destroy; override;
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    CLASS FUNCTION DisplayName: STRING; OVERRIDE;
    /// <author>Joe Care</author>
    /// <since>26.10.2012</since>
    CLASS FUNCTION Extensions: {$IFNDEF Support_Generics} TStringArray {$ELSE} TArray<STRING> {$ENDIF}; OVERRIDE;
    /// <author>C. Rosewich</author>
    /// <since>27.10.2012</since>
    class function GetFileInfoStr(FilePath: STRING; {%H-}force: boolean=false): STRING;
      OVERRIDE;
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    PROCEDURE LoadfromFile(Filename: STRING);
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    PROCEDURE LoadfromStrings(S: TStrings);
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    PROCEDURE LoadfromStream(Stream: TStream);
    /// <author>C. Rosewich</author>
    /// <since>08.02.2017</since>
    PROCEDURE SaveToFile(Filename: STRING);
    /// <author>C. Rosewich</author>
    /// <since>08.02.2017</since>
    PROCEDURE WriteToStream(Stream: TStream);
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    PROCEDURE AutoFormat;
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    procedure AppendVariableDef(const AVarname: string;
      const aVarSection: TenumVarsection; const Atype, AComment: string);
    /// <author>C. Rosewich</author>
    /// <since>27.03.2015</since>
    PROPERTY FileEncoding: String READ FFileEncoding;
    /// <author>C. Rosewich</author>
    /// <since>27.03.2015</since>
    PROPERTY Lines: TStrings READ FLines;
    /// <author>C. Rosewich</author>
    /// <since>30.11.2014</since>
    PROPERTY Author: String READ GetAuthor write SetAuthor;
    /// <author>C. Rosewich</author>
    /// <since>30.11.2014</since>
    PROPERTY Version: String read FVersion write SetVersion ;
    /// <author>C. Rosewich</author>
    /// <since>30.11.2014</since>
    PROPERTY Path: String READ Fpath write SetPath;
    /// <author>C. Rosewich</author>
    /// <since>30.11.2014</since>
    PROPERTY BlockType: String read FType write SetType ;
    /// <author>C. Rosewich</author>
    /// <since>26.10.2012</since>
    PROPERTY Options: TStrings READ FOptions;

  END;

  TParseMode = (
    psm_Normal, psm_Case, psm_ActionDecl, psm_Action, psm_Comment, psm_Type,
    psm_Struct, psm_VarStart, psm_Var, psm_VarInit, psm_Bitaccess,
    psm_Expression,
    psm_Expression2, (* ?? *)
    psm_ProcParam,
    psm_LoopStart,
    psm_nonST);

FUNCTION FormatCode(line: STRING; VAR Indent: Integer;
  VAR ParseMode: TParseMode;const KnownIdentifyer:TKnownIdentifyerList=nil): STRING;
{$IFDEF DEBUG}
FUNCTION ParseCode(Cmd: STRING; OUT BreakBefore: boolean;
  VAR LineBreak: boolean; VAR ParseMode: TParseMode): STRING;
PROCEDURE Push(ParseMode: TParseMode; Indent: Integer);
FUNCTION Pop(OUT Indent: Integer): TParseMode;
FUNCTION PeekPM(OUT Indent: Integer): TParseMode;
{$ENDIF}


VAR
  SEWFile: TSEW_Exp_File;
  Identifyers: TarrayOfString;
  HFIdentifyers: TarrayOfString;
  HFAIdentifyers: TarrayOfString;
  WellKnownCnstFct: TarrayOfString;

IMPLEMENTATION

USES variants,
  LConvEncoding,
  sysutils;


TYPE
  TOption = ARRAY [0 .. 1] OF STRING;

  TModeDefs = RECORD
    StartStr, EndStr: STRING;
    Indent: boolean;
    LbrAfterStartstr: boolean;

    NewMode: TParseMode;
  END;

  FormatOptions=(
    efo_Linefeed_Double = 0, // Lösche doppelte Leerzeilen
    efo_Linefeed_BeforeFkn = 1, // Zeilenwechsel vor Funktionen
    efo_Linefeed_AftAND_OR = 2, // Zeilenwechsel nach AND und OR
    efo_Indent_Default = 3, // Standart Einrückung
    efo_Indent_Blocktype = 4, // Einrückungsart
    efo_Space_NumFktn = 5, // Leerzeichen um numerische Funktionen
    efo_Space_CompFktn = 6, // Leerzeichen um Vergleichsfunktionen
    efo_Space_CBrackets = 7, // Leerzeichen bei eckigen Klammern
    efo_Space_RBrackets = 8, // Leerzeichen bei runden Klammern
    efo_Info_InsertHeader = 9, // Header einfügen
    efo_Info_InsertPath = 10, // Pfad einfügen
    efo_Info_InsertDate = 11, // Datum einfügen
    efo_Info_InsertAuthor = 12 // Author einfügen
    );

CONST
  Section = 'SEW-Exp-File';
  BaseIdent: ARRAY [0 .. 8] OF STRING = ('VAR_GLOBAL', 'VAR_CONFIG',
    'FUNCTION_BLOCK', 'FUNCTION', 'PROGRAM', 'TYPE', 'MACRO', 'PLC_CONFIGURATION', 'VISUALISATION');

  BblockHeader1 =
  	'(*---------------------------------------------------------------------*' + LineEnding +
	'*	Function: %s' + LineEnding +
	'*	Author: %s' + LineEnding +
	'*	Option: %s' + LineEnding +
	'*	Date: %s' + LineEnding +
	'*	Version: %s' + LineEnding +
	'*----------------------------------------------------------------------*' + LineEnding +
	'*	Info: %s' + LineEnding +
	'*----------------------------------------------------------------------*' + LineEnding +
	'Änderungen:' + LineEnding +
	LineEnding +
	'*----------------------------------------------------------------------*)' + LineEnding ;

    LChanges='ÄNDERUNGEN';

    HeaderFieldIdent: ARRAY [0 .. 8] OF STRING = ('FUNCTION', 'AUTHOR',
    'OPTION', 'DATE', 'VERSION', 'INFO','CHANGES', 'PATH', 'TYPE');

    AlternHeaderFieldIdent: ARRAY [0 .. 8] OF STRING = ('BAUSTEIN', 'VON',
    'OPTION', 'ERSTELLT AM', 'VERSION', 'BEMERKUNG', LChanges, 'PATH', 'TYPE');

  {$IFDEF FPC}
  DefaultTrueBoolStr = 'true';
  DefaultFalseBoolStr = 'false';
  {$ENDIF}

  DefaultOption: ARRAY [FormatOptions] OF TOption =
    (('Linefeed.Double', DefaultTrueBoolStr),
    ('Linefeed.BeforeFkn', DefaultTrueBoolStr),
    ('Linefeed.AftAND_OR', DefaultTrueBoolStr),
    ('Indent.Default', '<tab>'),
    ('Indent.Blocktype', DefaultFalseBoolStr),
    ('Space.NumFktn', DefaultTrueBoolStr),
    ('Space.CompFktn', DefaultTrueBoolStr),
    ('Space.CBrackets', DefaultTrueBoolStr),
    ('Space.RBrackets', DefaultTrueBoolStr),
    ('Info.InsertHeader', DefaultTrueBoolStr),
    ('Info.InsertPath', DefaultTrueBoolStr),
    ('Info.InsertDate', DefaultTrueBoolStr),
    ('Info.InsertAuthor', DefaultTrueBoolStr));

  RelevColumn: ARRAY [TParseMode] OF Integer = (1, 1, 1, 1, 1, 1, 1, 1, 1, 2,
    1, 1, 1, 1, 1, 1);

CONST
  OpenComment = '(*';
  CloseComment = '*)';
  CommandEnd = ';';
  QuoteChar = '''';
  BAQuoteChar = '"';

TYPE
  TpmStack = RECORD
    ParseMode: TParseMode;
    Indent: Integer;
  END;

VAR
  pmStack: ARRAY OF TpmStack;
  ooParsemode: TParseMode;

CONST
  IndentString: ARRAY [0 .. 17] OF TModeDefs = //
    ((StartStr: 'IF'; EndStr: 'END_IF'; Indent: true; LbrAfterStartstr: false{%H-}),
    //
    (StartStr: 'FOR'; EndStr: 'END_FOR'; Indent: true; LbrAfterStartstr: false ; NewMode: psm_LoopStart), //
    (StartStr: 'WHILE'; EndStr: 'END_WHILE'; Indent: true;
    LbrAfterStartstr: false; NewMode: psm_LoopStart), //
    (StartStr: 'CASE'; EndStr: 'END_CASE'; Indent: true;
    LbrAfterStartstr: false; NewMode: psm_Case), //
    (StartStr: 'ACTION'; EndStr: 'END_ACTION'; Indent: true;
    LbrAfterStartstr: false; NewMode: psm_ActionDecl), //
    (StartStr: 'VAR'; EndStr: 'END_VAR'; Indent: true;
    LbrAfterStartstr: false; NewMode: psm_VarStart), //
    (StartStr: 'VAR_INPUT'; EndStr: 'END_VAR'; Indent: true;
    LbrAfterStartstr: true; NewMode: psm_Var), //
    (StartStr: 'VAR_OUTPUT'; EndStr: 'END_VAR'; Indent: true;
    LbrAfterStartstr: true; NewMode: psm_Var), //
    (StartStr: 'VAR_IN_OUT'; EndStr: 'END_VAR'; Indent: true;
    LbrAfterStartstr: true; NewMode: psm_Var), //
    (StartStr: 'VAR_GLOBAL'; EndStr: 'END_VAR'; Indent: true;
    LbrAfterStartstr: false; NewMode: psm_VarStart), //
    (StartStr: 'TYPE'; EndStr: 'END_TYPE'; Indent: true;
    LbrAfterStartstr: false; NewMode: psm_Type), //
    (StartStr: 'STRUCT'; EndStr: 'END_STRUCT'; Indent: true;
    LbrAfterStartstr: true; NewMode: psm_Struct), //
    (StartStr: '_LD_BODY'; EndStr: '_END_BODY'; Indent: false;
    LbrAfterStartstr: true; NewMode: psm_nonST), //
    (StartStr: '_FBD_BODY'; EndStr: '_END_BODY'; Indent: false;
    LbrAfterStartstr: true; NewMode: psm_nonST), //
    (StartStr: 'MACRO'; EndStr: 'END_MACRO'; Indent: true;
    LbrAfterStartstr: true; NewMode: psm_nonST), //
    (StartStr: 'VISUALISATION'; EndStr: 'END_VISUALISATION'; Indent: true;
    LbrAfterStartstr: true; NewMode: psm_nonST), //
    (StartStr: 'LD'; EndStr: '_END_BODY'; Indent: false; LbrAfterStartstr: true;
    NewMode: psm_nonST), //
    (StartStr: '{'; EndStr: '}'; Indent: false; LbrAfterStartstr: false;
    NewMode: psm_Bitaccess));

  NegIndentString: ARRAY [0 .. 1] OF STRING = ('ELSE', 'ELSIF');

  VarModStr: ARRAY [0 .. 2] OF STRING = ('CONSTANT', 'RETAIN', 'PERSISTANT');

  LineBreakStr: ARRAY [0 .. 5] OF STRING = ('THEN', 'DO', 'OF', CommandEnd,
    ':(', 'ELSE');

  DWellKnownCnstFct: ARRAY [0 .. 11] OF STRING =
        ('TRUE','FALSE',
        'BYTE_TO_INT','INT_TO_BYTE',
        'UINT_TO_INT','INT_TO_UINT',
        'WORD_TO_INT','INT_TO_WORD',
        'UINT_TO_DINT','DINT_TO_UINT',
        'UDINT_TO_DINT','DINT_TO_UUINT');
type
  TenumSpaceSur = ( ess_AND, ess_XOR, ess_MOD, ess_Zuweisung, ess_EnumDef, ess_TO, ess_DO,
    ess_OR, ess_IF , ess_GToE, ess_LToE, ess_OutPar, ess_Unknown,ess_Unequal, ess_pp,
    ess_OpenComment, ess_CloseComment, ess_plus, ess_minus,
    ess_Divide, ess_Multiply, ess_equal, ess_LT, ess_GT, ess_Komma, ess_OpenRBracket,
    ess_CloseRBracket, ess_openEBracket, ess_CloseEBracket, ess_DoppelDot,
    ess_Semikolon, ess_Dot); (* *)

const
  SpaceSurString: ARRAY [TenumSpaceSur] OF STRING = ('AND', 'XOR', 'MOD', ':=', ':(', 'TO', 'DO',
    'OR', 'IF', '>=', '=<', '=>', '<=', '<>', '..', OpenComment, CloseComment, '+', '-',
    '/', '*', '=', '<', '>', ',', '(', ')', '[', ']', ':', ';', '.');(* *)

  SpaceSurType: ARRAY [TenumSpaceSur, 0 .. 3] OF boolean = (
    // spb,  spa,  ind,   lnf,
    (true, true, false, true),    // AND
    (true, true, false, true),    // XOR
    (true, true, false, true),   // Mod
    (true, true, false, false),   // :=
    (true, true, true, false),    // :(
    (true, true, false, false),   // TO
    (true, false, false, true),   // DO
    (true, true, false, true),    // OR
    (false, true, true, false),    // IF
    (true, true, false, false),   // >=
    (true, true, false, false),   // =<
    (true, true, false, false),   // =>
    (true, true, false, false),   // <=
    (true, true, false, false),   // <>
    (true, true, false, false), // ..
    (false, false, false, false), // (*
    (false, false, false, false), // *)
    (true, true, false, true),   // +
    (true, true, false, true),   // -
    (true, true, false, true),   // /
    (true, true, false, true),   // *
    (true, true, false, false),   // =
    (true, true, false, false),   // <
    (true, true, false, false),   // >
    (false, true, false, true),   // ,
    (false, true, true, false),   // (
    (true,  true, true, false),   // )
    (false, true, true, false),   // [
    (true, false, true, false),   // [
    (false, true, false, false),   // :
    (false, false, false, false),   // ;
    (false, false, false, false)   // .
    );

{$REGION 'Unit Procedures'}
Function TestCharset(const TestStr:String;CSFirst,CSTail:TCharset):boolean;

var
  i: Integer;
begin
  result := CharInSet(copy(TestStr+#0,1,1)[1],CSFirst);
  i := 2;
  while result and (i<=length(TestStr)) and CharInSet(copy(TestStr+#0,i,1)[1],CSTail) do
    inc(i);
  Result := result and (i>length(TestStr));
end;

PROCEDURE Push(ParseMode: TParseMode; Indent: Integer);
  BEGIN
    SetLength(pmStack, HIGH(pmStack) + 2);
    pmStack[ HIGH(pmStack)].ParseMode := ParseMode;
    pmStack[ HIGH(pmStack)].Indent := Indent;
  END;

FUNCTION Pop(OUT Indent: Integer): TParseMode;

  BEGIN
    result := psm_Normal;
    IF HIGH(pmStack) >= 0 THEN
      BEGIN
        result := pmStack[ HIGH(pmStack)].ParseMode;
        Indent := pmStack[ HIGH(pmStack)].Indent;
      END;
    IF HIGH(pmStack) > 0 THEN
      SetLength(pmStack, HIGH(pmStack));
  END;

FUNCTION PeekPM(OUT Indent: Integer): TParseMode;

  BEGIN
    result := psm_Normal;
    IF HIGH(pmStack) >= 0 THEN
      BEGIN
        result := pmStack[ HIGH(pmStack)].ParseMode;
        Indent := pmStack[ HIGH(pmStack)].Indent;
      END;
  END;


PROCEDURE AppendLine(Lines: TStrings; ParseMode: TParseMode; NewLine: STRING;
  VAR columnsize: ARRAY OF Integer);
  VAR
    cs: Integer;
    v: Variant;
  BEGIN
    Lines.AddObject(NewLine, tobject(ptrint(ParseMode)));
    IF NewLine <> '' THEN
      BEGIN
        v := VarArrayByLinesep(NewLine, [Sep_Space,Sep_Tab], true);
        IF VarArrayHighBound(v, 1) >= RelevColumn[ParseMode] - 1 THEN
          BEGIN
            cs := length(v[RelevColumn[ParseMode] - 1]);
            IF (columnsize[ord(ParseMode)] < cs) AND
              (cs <= 30 { maxColumnSize } ) THEN
              columnsize[ord(ParseMode)] := cs;
          END;
      END;
  END;

FUNCTION CompareStr(Cmd, testStr: STRING; OUT BreakBefore: boolean;
  OUT LineBreak: boolean; bbf: boolean; baf: boolean): boolean;
  BEGIN
    result := false;
    IF (UpperCase(right(Cmd, length(testStr))) = testStr) OR
      (UpperCase(left(Cmd, length(testStr))) = testStr) THEN
      BEGIN
        IF NOT charinset(copy(testStr, 1, 1)[1], alphanum) OR
          (length(Cmd) = length(testStr)) THEN
          BEGIN
            BreakBefore := bbf;
            LineBreak := baf;
            result := true;
          END
        ELSE
          BEGIN
            result := charinset(copy(' ' + Cmd, length(Cmd) - length(testStr)+1,
              1)[1], whitespace+[')',']']);
            LineBreak := result AND baf;
            BreakBefore := result AND bbf;
          END;
      END;
  END;

FUNCTION CompareStr2(Cmd, testStr: STRING): boolean; // INLINE;
  BEGIN
    if TestString(testStr,[#0..#255]-alphanum) then
      result := (pos( testStr,cmd) >0)
    else
    result := (UpperCase(copy(Cmd, 1, length(testStr))) = testStr) AND
      charinset(copy(Cmd + ' ', length(testStr) + 1, 1)[1],
      whitespace + [CommandEnd,'(']);
  END;

FUNCTION ParseCode(Cmd: STRING; OUT BreakBefore: boolean;
  VAR LineBreak: boolean; VAR ParseMode: TParseMode): STRING;
  VAR
    I: Integer;
    // breakit: boolean;
  BEGIN
    BreakBefore := false;
    LineBreak := false;
    IF ParseMode = psm_ActionDecl THEN
      BEGIN
        IF right(Cmd, 1) = ':' THEN
          BEGIN
            ParseMode := psm_Action;
            LineBreak := true;
          END;
        result := Cmd;
        exit
      END
    ELSE IF ParseMode = psm_VarStart THEN
      BEGIN
        FOR I := LOW(VarModStr) TO HIGH(VarModStr) DO
          BEGIN
            IF CompareStr(Cmd, UpperCase(VarModStr[I]), BreakBefore, LineBreak,
              false, false) THEN
              BEGIN
                result := Cmd + ' ';
                exit
              END;
          END;
        IF trim(Cmd) <> '' THEN
          BEGIN
            ParseMode := psm_Var;
            BreakBefore := true;
            result := Cmd + ' ';
          END
        ELSE
          result := '';
      END;

    FOR I := LOW(LineBreakStr) TO HIGH(LineBreakStr) DO
      BEGIN
        IF (I <> 2) OR NOT(ParseMode IN [psm_Struct, psm_Var]) THEN
          IF CompareStr(Cmd, UpperCase(LineBreakStr[I]), BreakBefore, LineBreak,
            I > 4, ParseMode <> psm_Bitaccess) THEN
            break;
      END;

    IF (NOT BreakBefore or (ParseMode=psm_Var)) AND NOT LineBreak THEN
      FOR I := LOW(IndentString) TO HIGH(IndentString) DO
        BEGIN
          IF CompareStr(Cmd, UpperCase(IndentString[I].EndStr), BreakBefore,
            LineBreak, ParseMode <> psm_Bitaccess, true) THEN
            break;

          IF CompareStr(Cmd, UpperCase(IndentString[I].StartStr), BreakBefore,
            LineBreak, true, IndentString[I].LbrAfterStartstr) THEN
            BEGIN
              Push(ParseMode, -1);
              ParseMode := IndentString[I].NewMode;

              break;
            END;
        END;

    IF NOT BreakBefore AND NOT LineBreak THEN
      IF ParseMode IN [psm_Type] THEN
        CompareStr(Cmd, ',', BreakBefore, LineBreak, false, true);

    IF trim(Cmd) <> '' THEN
      result := Cmd + ' '
    ELSE
      result := '';
  END;

FUNCTION FormatColumns(line: STRING; columnsize: ARRAY OF Integer): STRING;
  VAR
    v: Variant;
    I: Integer;
  BEGIN
    if trim(line)='' then
      begin
        result := '';
        exit;
      end;
    v := VarArrayByLinesep(line, Sep_Space, true);
    result := '';
    FOR I := 0 TO VarArrayHighBound(v, 1)-1 DO
      BEGIN
        IF I > 0 THEN
          result := result + ' ';
        IF (I <= HIGH(columnsize)) AND (columnsize[I] > length(v[I]))  THEN
          result := result + v[I] + StringOfChar(' ',
            columnsize[I] - length(v[I]))
        ELSE
          result := result + v[I];
      END;
    IF VarArrayHighBound(v, 1) > 0 THEN
      result := result + ' ';
    result := result+ v[VarArrayHighBound(v, 1)];

  END;

FUNCTION FormatCode(line: STRING; VAR Indent: Integer;
  VAR ParseMode: TParseMode;const KnownIdentifyer:TKnownIdentifyerList=nil ): STRING;
  VAR
    I,    // Schleifenzähler
    pp,   // Positionsmerker
    ppn,
    ppx: Integer;
    oldIndent: Integer;
    ppf, // Gefundener SpcSur-Operator
    nlIndentstring: STRING;
    pTest  // Aktiviere spb,spa,incind,lnfa-Teats
    (* , OldlineBreak *) : boolean;
    testset: TSysCharset;
    spb: boolean; // Sps-Operator Kennung: Space Before
    spa: boolean; // Sps-Operator Kennung: Space After
    lfda: boolean; // Sps-Operator Kennung: Linefeed After
    incdecind: boolean; // Sps-Operator Kennung; Berechne Einrückung neu
    lFoundResWord: Boolean; // Sps-Operator ist reserviertes Wort

    Expression: boolean;
    sIsResWord: boolean;
    sIsReswordTest: Boolean;

    Indents, BefCh, AftCh: Char;
    ComplexExpression: boolean;
    Proceduretest: Integer;
    SpSurCount: Integer;
    si: Integer;
    ppt: Integer;
    ProcFirst,
    Zuweisung:boolean;
    ZWpos: Integer;  // Zuweisungs-Position (für nachträgliches LineBreak)
    VarCount:Integer; // Anzahl Variablen pro Zeile
    oldParseMode: TParseMode;
    Indentl: Integer;
    ZWVar: String;
    FirstVar: String;
    lWasResWord: Boolean;
    ppfl: Integer;
    ppo: Integer;
    PossibIdentifyer: String;
    lppf: String;
    lRestContAlphaChar: Boolean; // Result-Rest (nach ppn) enthält alphaheth-Zeichen
    lParCount: Integer;  // Anzahl Parameter in Anweisung
    Dummy: Integer;

  BEGIN
    Indents := #9;
    // Indent
    oldIndent := Indent;
    oldParseMode := ParseMode;

    IF pmStack[ HIGH(pmStack)].Indent = -1 THEN
      BEGIN
        pmStack[ HIGH(pmStack)].Indent := Indent;
      END;
    FOR I := LOW(IndentString) TO HIGH(IndentString) DO
      BEGIN
        IF (IndentString[I].Indent or (IndentString[I].NewMode = ParseMode)) AND (Indent >= 1) AND
          CompareStr2(line, IndentString[I].EndStr) THEN
          BEGIN
            ParseMode := Pop(Indent);
            break;
          END;
      END;

    si := 0;
    FOR I := LOW(NegIndentString) TO HIGH(NegIndentString) DO
      IF (Indent >= 1) AND CompareStr2(line, NegIndentString[I]) THEN
        BEGIN
          dec(oldIndent);
          si := -1
        END;


    IF (ParseMode = psm_Case) THEN
      BEGIN
        ppx := pos(1, ':', line);
        IF (ppx > 1) AND (copy(line + ' ', ppx + 1, 1) <> '=') THEN
          dec(si);
      END;

    IF ParseMode = psm_Bitaccess THEN
      result := line
    ELSE IF Indents = #9 THEN
      result := StringOfChar(Indents, Indent + si) + line
    ELSE
      result := StringOfChar(' ', (Indent + si) * 2 (* Indentsize *) ) + line;

    IF oldParseMode = psm_Bitaccess THEN
       exit;

    FOR I := LOW(IndentString) TO HIGH(IndentString) DO
      IF IndentString[I].Indent AND
        CompareStr2(line, IndentString[I].StartStr) THEN
        BEGIN
          Indent := Indent + 1;
          ParseMode := IndentString[I].NewMode;
          IF ParseMode = psm_Case THEN
            inc(Indent);
          IF ParseMode = psm_ActionDecl THEN
            ParseMode := psm_Action;
          break;
        END;
    // Spaces suround
    pp := 1;
    ppn := -1;
    ZWpos:=0;
    Proceduretest := 0;
    Zuweisung:=false;
    ProcFirst:=false;
    Expression := ParseMode IN [psm_Var, psm_Type, psm_Expression,
      psm_Expression2, psm_ProcParam];
    ComplexExpression := ParseMode IN [psm_Expression, psm_Expression2,
      psm_ProcParam];
    IF ComplexExpression THEN
      IF ParseMode = psm_Expression THEN
        Proceduretest := 2
      ELSE
        Proceduretest := 1;

    IF TryFWildcardMatching(trim(line), 'IF *THEN') > 0 THEN
      Expression := true;
    IF TryFWildcardMatching(trim(line), 'ELSIF *THEN') > 0 THEN
      Expression := true;
    IF TryFWildcardMatching(trim(line), 'WHILE *DO') > 0 THEN
      Expression := true;
    IF TryFWildcardMatching(line, '*:=*;') > 0 THEN
      Expression := true;
    IF ParseMode = psm_Expression THEN
      Expression := true;
    SpSurCount := 0;
    VarCount:=0;
    lParCount:=0;
    ppfl:= 2;
    ppf := '';
    lppf := '';
    lWasResWord := false;
    lFoundResWord := false;
    WHILE ppn <> 0 DO
      BEGIN
        ppo := ppn+ppfl;
        if lppf <> CommandEnd then
          lppf := ppf;
        ppn := 0;
        incdecind := false;
        spa := false;
        spb := false;
        lfda := false;
        lWasResWord:=lFoundResWord;
        lFoundResWord:=false;
        // Suche nächste Kennung in der Zeile
        FOR I := ord(LOW(SpaceSurString)) TO ord(HIGH(SpaceSurString)) DO
          BEGIN
            sIsResWord := charinset(SpaceSurString[TenumSpaceSur(I)][1], Charset);
            sIsReswordTest := sIsResWord;
            ppx := pos(pp, SpaceSurString[TenumSpaceSur(I)], UpperCase(result));
            while (ppx > 0) AND ((ppx < ppn) OR (ppn < pp)) AND sIsResWordTest do
              BEGIN
                BefCh := copy(' ' + result, ppx, 1)[1];
                AftCh := copy(result + ' ',
                  ppx + length(SpaceSurString[TenumSpaceSur(I)]), 1)[1];
                IF charinset(BefCh, alphanum + ['_']) OR
                  charinset(AftCh, alphanum + ['_']) THEN
                  ppx := pos(ppx+1, SpaceSurString[TenumSpaceSur(I)], UpperCase(result))
                else
                  sIsReswordTest:=false; (* Success *)
              END;
            IF (ppx > 0) AND ((ppx < ppn) OR (ppn < pp)) THEN
              BEGIN
                ppn := ppx;
                ppf := SpaceSurString[TenumSpaceSur(I)];
                ppfl := length(ppf);
                spb := SpaceSurType[TenumSpaceSur(I), 0];
                spa := SpaceSurType[TenumSpaceSur(I), 1];
                incdecind := SpaceSurType[TenumSpaceSur(I), 2];
                lfda := SpaceSurType[TenumSpaceSur(I), 3];
                lFoundResWord := sIsResWord;
(*  Debug:      te := copy(result, ppn, length(ppf)); *)
              END;
          END;

     pTest := true;
(* Look for identifyers *)
     if parsemode <> psm_LoopStart then
       PossibIdentifyer  := trim(copy(result,ppo,ppn-ppo))
     else
       begin
         pp := pos(ppo,' ',result);
         if pp <> 0 then
           ppo := pp;
         PossibIdentifyer  := trim(copy(result,ppo,ppn-ppo));
       end;
     if (PossibIdentifyer <> '') then
       begin
         if charinset(PossibIdentifyer[1],Charset) then
           begin
             if (ParseStr(PossibIdentifyer,WellKnownCnstFct) = -1) and (ppf <>'(') then
              inc(VarCount);
             for i := 0 to high(KnownIdentifyer) do
               if uppercase(PossibIdentifyer)=uppercase(KnownIdentifyer[i].Name) then
                 begin
                   if PossibIdentifyer <> KnownIdentifyer[i].Name then
                     result :=
                            copy(result,1,ppo-1)+
                            StringReplace(copy(result,ppo,ppn-ppo),PossibIdentifyer,KnownIdentifyer[i].Name,[])+
                            copy(result,ppn,length(result));
                 end;
         end;

       ppx := pos(1, QuoteChar, copy(result,ppo,ppn-ppo));
       IF ppx <>0 THEN
          BEGIN
            ppx := pos(ppo +ppx+ 1, QuoteChar, result);
            IF ppx = 0 THEN
              ppn := 0
            ELSE
              BEGIN
                Lppf := ppf;
                ppf := QuoteChar;
                ppn := ppx;
                spb:=false;
                spa:=false;
                lfda:=false;
                lFoundResWord:=false;
                pTest := false;
              END;
          END;
        end;

        IF ppf = OpenComment THEN
          BEGIN
            ppx := pos(ppn + 2, CloseComment, UpperCase(result));
            IF ppx = 0 THEN
              ppn := 0
            ELSE
              BEGIN
                lfda:=false;
                pTest := false;
                IF (ppx > length(result) - 4) AND
                  (trim(copy(result, ppx + 2, 2)) = CommandEnd)  THEN
                    if (lppf = CommandEnd )  then
                      begin
                        lfda := true;
                        ptest := true;
                        spa := true;
                      end
                else
                  BEGIN
                    // Strichpunkt vor Kommentar
                    insert(CommandEnd, result, ppn - 1);
                    inc(ppx);
                    delete(result, ppx + 2, 2);
                    WHILE ParseMode = psm_Expression DO
                      ParseMode := Pop(Indent);
                  END
                ELSE IF (ppx > length(result) - 4) AND
                  (trim(copy(result, ppx + 2, 2)) = ',') THEN
                      if (lppf = ',' )  then
                        begin
                          lfda := true;
                          ptest := true;
                          spa := true;
                        end
                  else
                  BEGIN
                    // Komma vor Kommentar
                    insert(',', result, ppn - 1);
                    inc(ppx);
                    delete(result, ppx + 2, 2);
                    WHILE ParseMode = psm_Expression2 DO
                      ParseMode := Pop(Indent);
                  END;
                if lppf <> CommandEnd then
                  Lppf := ppf;
                ppf := CloseComment;
                ppn := ppx;
                spb:=false;
                spa:=false;
                lFoundResWord:=false;
              END;
          END;

        // Spezialbehandlung von : in Deklarationen;
        IF (ppf = ':') THEN
          BEGIN
            spb := spb OR (ParseMode IN [psm_Var, psm_Struct, psm_Type]);
            IF ParseMode = psm_Case THEN
              BEGIN
                spb:=false;
              END;
          END;

        // Prüfe ob dies ein gültiger Treffer
        IF (ppn <> 0) AND charinset(ppf[1], Charset) THEN
          BEGIN
            testset := AllVisible - Charset;

            pTest := ((ppn = 1) OR charinset(copy(result, ppn - 1, 1)[1],
              testset)) AND charinset(copy(result + ' ', ppn + length(ppf), 1)
              [1], testset);
          END
        ELSE
          pTest := pTest and (ppn > 0);

        IF pTest THEN
          BEGIN
            // Space before
            IF spb THEN
              BEGIN
                // Done -o JC : Doppelte Zuweisungen
                IF (ppf = ':=') AND NOT(ParseMode IN [psm_Type, psm_Var]) THEN
                  BEGIN
                    if Zuweisung and (Proceduretest= 2) and (ParseMode<>psm_ProcParam) then
                      begin
                        // Doppelte Zuweisung
                        IF charinset(copy(result , Zwpos+2 , 1)[1],
                          whitespace) THEN
                            begin
                          delete(result, Zwpos+2 , 1);
                          dec(ppn);
                            end;
                        IF Indents = #9 THEN
                          nlIndentstring := vbnewline + StringOfChar(Indents, Indent-1)
                        ELSE
                          nlIndentstring := vbnewline +
                            StringOfChar(' ', (Indent-1) * 2 (* Indentsize *) );
                        insert(nlIndentstring, result, Zwpos+2 );
                        inc(ppn,length(nlIndentstring));
                        ComplexExpression := true;
                        VarCount:= 1;
                        ZWpos:= ppn;  // Neue Zuweisungspoition merken
                      end;
                    IF (Proceduretest = 0) THEN
                      BEGIN
                        Proceduretest := 2; // Zuweisung
                        Zuweisung := not ProcFirst;
                        Expression:=true;
                        if Zuweisung and (ZwPos<=0) then
                          begin
                          ZwPos := ppn; // Position der Zuweisung merken
                          oldIndent:=Indent;
                          end;
                      END;
                    IF ParseMode <> psm_Expression THEN
                      BEGIN
                        Push(ParseMode, Indent);
                        inc(Indent);
                      END;
//                    IF ParseMode = psm_ProcParam then
//                      dec(varcount);
                    IF ParseMode IN [psm_ProcParam, psm_Expression2] THEN
                      ParseMode := psm_Expression2
                    ELSE
                      ParseMode := psm_Expression;
                  END;
                IF spa THEN
                  IF (SpSurCount < 2) OR ComplexExpression or (Parsemode= psm_var) THEN
                    inc(SpSurCount)
                  ELSE
                    ComplexExpression := true;
                IF (ppn > 1) AND NOT charinset(copy(result, ppn - 1, 1)[1],
                  whitespace) THEN
                  BEGIN
                    if (ppf = '(') or (ppf = ':=') then
                      insert(#9, result, ppn)
                    else
                      insert(' ', result, ppn);
                    inc(ppn);
                    if ZWpos+1 = ppn  then
                      inc(zwpos);
                  END
                else if (copy(result, ppn - 1, 1) = ' ') and (ppf= ':=') then
                  // Tab vor Zusweisungen
                  begin
                    delete( result, ppn-1,1);
                    insert(#9, result, ppn-1);
                  end;
                // Umbruch vor 1. Parameter-Zuweisung
                IF (ppf = ':=') and (ppn> 1) and
                  (ParseMode = psm_Expression2) and
                  TestCharset(trim(copy(result,pp,ppn-pp)),Charset,AlphaNum) and
                  (copy(result,pp-1,1) ='(') then
                    begin
                      IF charinset(copy(result , pp , 1)[1], whitespace) THEN
                          begin
                            delete(result, pp , 1);
                            dec(ppn);
                            if ZWpos-1 = ppn  then
                              dec(zwpos);
                          end;
                      IF Indents = #9 THEN
                        nlIndentstring := vbnewline + StringOfChar(Indents, Indent-1)
                      ELSE
                        nlIndentstring := vbnewline +
                          StringOfChar(' ', (Indent-1) * 2 (* Indentsize *) );
                      insert(nlIndentstring, result, pp );

                      // Zähle Zuweisungs-Position weiter
                      if ZWpos = ppn  then
                        inc(ZWpos,length(nlIndentstring));
                      inc(ppn,length(nlIndentstring));

                      VarCount := 1; (* Zuweisungsvariable wurde mit umgebrochen *)
                    end;
                IF (ppf = 'DO')  then
                  begin
                  if (ParseMode in [psm_Expression2,psm_Expression]) then
                    parsemode := pop(Indent);
                  if (ParseMode = psm_LoopStart) then
                    parsemode := psm_Normal;
                  end;
              END
            ELSE IF (ppn > 2) AND charinset(copy(result, ppn - 1, 1)[1],
              whitespace) AND charinset(copy(result, ppn - 2, 1)[1],
              alphanum+[')']) and ((ppf<>'(') or not lWasResWord) and
              (ppf <> CloseComment) THEN
              BEGIN
                delete(result, ppn - 1, 1);
                dec(ppn);

              END;

            // Space after
            IF spa THEN
              BEGIN
                IF NOT charinset(copy(result + ' ', ppn + length(ppf), 1)[1],
                  whitespace) and (ppf <>'-') THEN
                  BEGIN
                    insert(' ', result, ppn + length(ppf));
                  END;
                // Spezialbehandlung von minus ( operator vs. modifyer vs. Zahl )
                if ppf = '-' then
                  begin
                    if not charinset(copy(result,ppn -2,1)[1],AlphaNum+[']']) then
                      begin
                        lfda := false; (* Modifyer oder Zahl ohne Linefeed *)
                        if charinset(copy(result,ppn + length(ppf),1)[1],Whitespace) then
                          delete( result, ppn + length(ppf),1);
                      end
                    else
                      if NOT charinset(copy(result + ' ', ppn + length(ppf), 1)[1],
                         whitespace) then
                        insert(' ', result, ppn + length(ppf))
                  end;
                // Tab after Brackets
                if (copy(result , ppn + length(ppf), 1) = ' ') and
                   (ppf = '(') then
                  begin
                    delete( result, ppn + length(ppf),1);
                    insert(#9, result, ppn + length(ppf));

                  end
              END
            ELSE IF (ppn < length(result)-2) AND charinset(copy(result, ppn +
              length(ppf), 1)[1],
              whitespace) AND charinset(copy(result, ppn +length(ppf)+1, 1)[1],
              alphanum) THEN
              BEGIN
                delete(result, ppn +length(ppf), 1);
              END;

            IF incdecind THEN
              BEGIN
                IF ppf = '(' THEN
                  BEGIN
                    IF (Proceduretest = 0) THEN
                      BEGIN
                        Expression := true;
                        Proceduretest := 1; // Procedure-param
                        Procfirst := not Zuweisung;
                      END;
                    IF (ppn > 1) AND
                      charinset(copy(result, ppn - 1, 1)[1],alphanum+[']']) THEN
                      BEGIN
                        if Proceduretest = 2 then
                          begin
                            // function -> Newline
                            ppt := ppn-1;
                            while (ppt>1) and charinset(copy(result, ppt, 1)[1],alphanum+['[',']','.',' '])do
                              dec(ppt);
                            inc(ppt);
                            if (ppt>2) and (copy(result, ppt, 1)=' ') then
                              begin
                                  delete(result, ppt , 1);
                                  dec(ppn);

                                IF Indents = #9 THEN
                                  nlIndentstring := vbnewline + StringOfChar(Indents, Indent)
                                ELSE
                                  nlIndentstring := vbnewline +
                                    StringOfChar(' ', (Indent) * 2 (* Indentsize *) );
                                insert(nlIndentstring, result, ppt );
                                inc(ppn,length(nlIndentstring));
                                if ppt = zwpos+length(SpaceSurString[ess_Zuweisung]) then
                                  zwpos := 0; (*Zuweisungsposition löschen, da schon lf eingefügt *)
                                VarCount:= 0; (* Neue Zeile, Var-zählung neu starten  *)
                              end;
                          end;
                        Push(ParseMode, Indent);
                        inc(Indent);
                        ParseMode := psm_ProcParam;
                        Proceduretest := 0;
                      END
                    ELSE IF NOT(ParseMode IN [psm_Var, psm_Type, psm_Struct]) THEN
                      BEGIN
                        Push(ParseMode, Indent);
                        inc(Indent);
                        IF NOT(ParseMode IN [psm_Expression, psm_Expression2,
                          psm_ProcParam]) THEN
                          ParseMode := psm_Expression
                        ELSE IF ParseMode IN [psm_ProcParam] THEN
                          ParseMode := psm_Expression2
                      END;
                  END
                ELSE IF ppf = ')' THEN
                  BEGIN
                    IF ParseMode IN [psm_Expression, psm_Expression2,
                      psm_Type] THEN
                      ParseMode := Pop(Indent);
                    IF ParseMode IN [psm_ProcParam] THEN
                      ParseMode := Pop(Indent);
                  END;
                IF spa and (ppf <> ')') THEN
                ELSE
                  BEGIN
                    ComplexExpression := ComplexExpression OR
                      ((ppn < length(result) - 3) AND (ppf = ')'));
                  END;
              END;

            // Linefeed after
            IF lfda AND Expression and (Parsemode<> psm_Var) THEN
              BEGIN
                lRestContAlphaChar := false;
                for I := ppn+length(ppf) to length(result) do
                  if charinset(result[i],Charset) then
                    begin
                      if ((uppercase(copy(result,I,2)) = 'TO') and (PeekPM(Dummy)=psm_LoopStart)) or
                       ((uppercase(copy(result,I,2)) = 'DO') and (PeekPM(Dummy)=psm_LoopStart)) then
                         break;

                    lRestContAlphaChar:=true;
                    break;
                    end
                  else
                    if (copy(result,I,length(ppf)) = ppf) or
                    (copy(result,I,length(OpenComment)) = OpenComment) or
                    ((copy(result,I,1) = ']') and (ppf=',')) or
                    ((copy(result,I,1) = ')') and (ppf=',')) or
                    (copy(result,I,length(QuoteChar)) = QuoteChar) then
                      break;
                if zwpos >0 then
                  ComplexExpression := (not TestString(copy(result,ZWpos,ppn-zwpos),[#0..#255]- Charset-['.'])) or (ppf=',')
                else
                  ComplexExpression := true;
                IF ppf = ',' THEN
                  BEGIN
                    IF ParseMode = psm_Expression2 THEN
                      BEGIN
                        ParseMode := Pop(Indent);
                        inc(lParCount);
                      END;
                  END;
                // Prüfe ob direkt danach ein Kommentar kommt
                ppx := pos(ppn + length(ppf), OpenComment, result);
                IF (ppx > 0) AND (ppx < ppn + length(ppf) + 2) THEN
                  BEGIN
                    ppx := pos(ppx + 2, CloseComment, UpperCase(result));
                    IF ppx = 0 THEN
                      ppn := 0
                    ELSE
                      BEGIN
                        ppf := CloseComment;
                        ppn := ppx;
                        lRestContAlphaChar:=pos(ppn+2,':=',result)<>0;
                      END;
                  END;
                if ComplexExpression and (ppn > 0)
                    and lRestContAlphaChar
                    and ((varcount>=1) or ((ParseMode <> psm_Expression)
                    and  (ParseMode <> psm_ProcParam)))
                    then
                  begin
                    IF charinset(copy(result + ' ', ppn + length(ppf), 1)[1],
                      whitespace)  THEN
                      delete(result, ppn + length(ppf), 1);

                    IF Indents = #9 THEN
                      nlIndentstring := vbnewline + StringOfChar(Indents, Indent)
                    ELSE
                      nlIndentstring := vbnewline +
                        StringOfChar(' ', (Indent) * 2 (* Indentsize *) );

                    IF ppn + length(ppf) <= length(result) THEN
                      begin
                        insert(nlIndentstring, result, ppn + length(ppf));
                        IF (ParseMode = psm_ProcParam)  and  (lParCount<2)
                           THEN
                          ZWpos:=0
                          else
                          lParCount :=  lParCount + 1;
                      end;

                    (* Nach Umbruch Variablenzählung resetten *)
                    VarCount:=0;

                  end;
              END;
           IF lfda AND (Parsemode= psm_Var) and ((ppn + length(ppf)) < length(result)) THEN
              begin
                 IF charinset(copy(result + ' ', ppn + length(ppf), 1)[1],whitespace) THEN
                    delete(result, ppn + length(ppf),1);
                insert(#9, result, ppn + length(ppf));
              END;

          END;
        pp := ppn + length(ppf);
      END;
    IF ComplexExpression THEN
      BEGIN
        pp := pos('IF ', result);
        IF pp > 0 THEN
          result[pp + 2] := #9;
        pp := pos('IF(', result);
        IF pp > 0 THEN
          insert(#9, result, pp + 2);

        // Bei Zuweisung : LF nach erstem :=
        pp := ZWpos;
        IF (pp > 0) AND
          (copy(result,pp,3) = ':= ') and
          (Zuweisung) AND
          (ParseMode <> psm_Type) AND
          (ParseMode <> psm_Struct) AND
          (ParseMode <> psm_Var) THEN
          begin
            IF Indents = #9 THEN
              Indentl := oldIndent
            else
              Indentl := oldIndent*2;
            ZWVar := copy(result,Indentl+1,pp-Indentl-2);
            FirstVar := copy(result,pp+3,pp-Indentl-2);
            if ZWVar <> FirstVar then
          BEGIN
            delete(result, pp + 2, 1);
            IF Indents = #9 THEN
              nlIndentstring := vbnewline + StringOfChar(Indents, oldIndent + 1)
            ELSE
              nlIndentstring := vbnewline + StringOfChar(' ',
                (oldIndent + 1) * 2 (* Indentsize *) ) + line;
            insert(nlIndentstring, result, pp + 2);
          END;
          end
      end;

    IF (ParseMode IN [psm_Expression, psm_Expression2, psm_ProcParam]) THEN
      BEGIN
        if right(trim(result), length(CloseComment)) <> CloseComment then
        begin
        FOR I := 0 TO HIGH(LineBreakStr) DO
          IF right(result, length(LineBreakStr[I])) = LineBreakStr[I] THEN
            BEGIN
              WHILE (ParseMode IN [psm_Expression, psm_Expression2,
                psm_ProcParam]) DO
                ParseMode := Pop(Indent);
              break;
            END
        end
        else
        FOR I := 0 TO HIGH(LineBreakStr) DO
        IF lppf = LineBreakStr[I] THEN
          BEGIN
            WHILE (ParseMode IN [psm_Expression, psm_Expression2,
              psm_ProcParam]) DO
              ParseMode := Pop(Indent);
            break;
          END
      END;

  END;
{$ENDREGION 'Unit Procedures'}

{$REGION 'Class Methods'}
constructor TSEW_Exp_File.Create;
  VAR
    Opt: TOption;
  BEGIN
    INHERITED Create;
    FLines := TStringList.Create;
    Tstringlist(Flines).OnChange:=CodeChange;
    FOptions := TStringList.Create;
    FOR Opt IN DefaultOption DO
      FOptions.Values[Opt[0]] := Opt[1];
  END;

destructor TSEW_Exp_File.Destroy;
begin
  if assigned(FLines) then
    FreeAndNil(FLines);
  FreeAndNil(FOptions);
  inherited Destroy;
end;


class function TSEW_Exp_File.DisplayName: STRING;
  BEGIN
    result := 'SEW-Export-Datei'
  END;

class function TSEW_Exp_File.Extensions: {$IFnDEF Support_Generics} TStringArray {$ELSE} TArray<STRING> {$ENDIF};
  BEGIN
    SetLength(result, 1);
    result[0] := '.EXP';
  END;

var
  HF:{$IFDEF FPC} TStringArray {$ELSE} TArray<STRING> {$ENDIF};

procedure TSEW_Exp_File.CodeChange(Sender: TObject);
begin
  FAuthor:='';
  FVersion:='0.0';
  FPath:='\';
  Ftype:='';
  IntParseHeaderLines(FLines,SetHeaderField);
end;

procedure TSEW_Exp_File.UpdateLineHF(const Ix: Integer; const AValue: String);
var
  pp: integer;
  Line: String;
begin
  TStringList(FLines).OnChange:=nil;
  Line := FLines[FHeaderIdx[Ix]];
  pp := pos(':', Line);
  while (pp>0) and charinset(Line[pp], [':',' ',#9]) do
    inc (pp);
  if copy(line, length(line)-1, 2) = CloseComment then
    FLines[FHeaderIdx[Ix]] := copy(line, 1, pp-1)+AValue+#9+CloseComment
  else
    FLines[FHeaderIdx[Ix]] := copy(line, 1, pp-1)+AValue;
  TStringList(FLines).OnChange:=CodeChange;
end;

procedure TSEW_Exp_File.InsertHeader;
var
  Header: TStringList;
  i: Integer;
begin
  if FHeaderIdx[8] >0 then
    try
    Header := TStringList.create;
    Header.Text:= Format(BblockHeader1,['',FAuthor,'','',FVersion,'']);
    Flines.BeginUpdate;
    for i := 0 to Header.Count -1 do
      Flines.Insert(FHeaderIdx[8]+1+i,Header[i]);
    Flines.EndUpdate;
    finally
      freeandnil(Header);
    end;
end;

class procedure TSEW_Exp_File.AppendFIHeaderField(const Key, Value: String;
  LineNo: integer);

var
  i: Integer;
begin
  for i := 0 to (high(HF)-1) div 2 do
    if HF[i*2]=uppercase(key) then
      begin
        HF[i*2+1] := Value;
        exit
      end;
  setlength(HF,((High(HF)-1) div 2)*2+4);
  HF[High(HF)-1] := uppercase(Key);
  HF[High(HF)] := Value;
end;

class function TSEW_Exp_File.GetFileInfoStr(FilePath: STRING; force: boolean
=false ): STRING;

  VAR
    lStream: TStream;
    lLines: TStrings;
    I: Integer;
    st,lresult2, lEncoding: STRING;
    Encodec: boolean;

  CONST
    cSWildCardFill = 'WildCardFill';

  BEGIN
    lLines := TStringList.Create;
    try
    lStream := TfileStream.Create(FilePath, fmOpenRead);
    try
    setlength(st,lStream.size);
    lStream.ReadBuffer(st[1],lStream.size);
    finally
      freeandnil(lStream);
    end;
    lEncoding := GuessEncoding(st);
    lLines.Text:=ConvertEncodingToUTF8(st,lEncoding,Encodec);
    st:='';
    setlength(HF,0);
    IntParseHeaderLines(lLines,AppendFIHeaderField);
    finally
    freeandnil(lLines);
    end;
    result := '[' + Section + ']' + vbnewline;
    lresult2 := '[' + cSWildCardFill + ']' + vbnewline;
    for i := 0 to (high(HF)-1) div 2 do
        begin
          result :=result + lowercase(HF[i*2]) +'='+ HF[i*2+1] + vbnewline;
          lresult2 :=lresult2 + lowercase(HF[i*2])[1] +'='+ HF[i*2+1] + vbnewline;
        end;
    result := result +LineEnding+ lresult2;
    setlength(HF,0);
  END;


class procedure TSEW_Exp_File.IntParseHeaderLines(const Lines: TStrings;
  AppendHeaderField: TAHFCallback);

  function GetIdentifyerBef(const Line:String;sPos:integer;out Key:String):boolean;
  var
    pp: Integer;
    tt: String;
  begin
    tt := trim(copy(Line,1,sPos));
    pp := ParseStr(tt,HFIdentifyers,psm_enderw);
    if pp<0 then
      pp := ParseStr(tt,HFAIdentifyers,psm_enderw);
    result:= (pp>=0);
    if result then
      Key:=HFIdentifyers[pp];
  end;

var
  KeyValue: STRING;
  KeyName: STRING;
  line: STRING;
  EqP, I: Integer;
  TypeSet: Boolean;
  HeaderEnd: Boolean;
  ps: Integer;
  Commentmode: Boolean;

begin
  TypeSet := false;
  HeaderEnd:= false;
  Commentmode:=false;
  for I := 0 to Lines.Count - 1 do
    begin
      if (I > 30) or HeaderEnd then
        break;
      line := Lines.Strings[I];
      EqP := pos(0, ':=', line);
      if not typeset and (copy(line, 1, 4) = '(* @') and (EqP > 0) then
        begin
          // Hole Key und wert
          KeyName := trim(copy(line, 5, EqP - 5));
          KeyValue := trim(copy(line, EqP + 3, length(line) - EqP - 5));
          if KeyValue[1] = '''' then
            begin
              //
              KeyValue := copy(KeyValue, 2, length(KeyValue) - 2);
              KeyValue := StringReplace(KeyValue, '\/', '\', [rfReplaceAll]);
            end;
          AppendHeaderField( KeyName, KeyValue,I);
        end
      else
        begin
          // Püfe ob Variable, Baustein, oder Struktur
          if not typeset then
            begin
              ps := ParseStr(trim(Lines.Strings[I]), Identifyers, psm_Start);

            case ps of
            0 .. 1: // Globale Variablen & Konstanten
              begin
                AppendHeaderField( 'type', 'Ressource',I);
                typeset := true;
              end;
            2, 4: // Bausteine
              begin
                AppendHeaderField( 'type', 'Block',I);
                AppendHeaderField( 'name', copy(trim(Lines.Strings[I]),length(Identifyers[ps])+2,length(Lines.Strings[I])),I);
                typeset := true;
              end;
            3: // function
              begin
                AppendHeaderField( 'type', 'Block',I);
                KeyValue:=copy(trim(Lines.Strings[I]),length(Identifyers[ps])+2,length(Lines.Strings[I]));
                EqP := pos(0,':',KeyValue);
                if EqP>0 then
                  Keyvalue:=trim(copy(KeyValue,1,EqP));
                AppendHeaderField( 'name', KeyValue,I);
                typeset := true;
              end;
            5: // Typen und Enumerationen
              begin
                AppendHeaderField( 'type', 'Type',I);
                AppendHeaderField( 'name', copy(Lines.Strings[I],length(Identifyers[ps])+2,length(Lines.Strings[I])),I);
                typeset := true;
              end;
            6: // Makros
              begin
                AppendHeaderField( 'type', 'Macro',I);
                AppendHeaderField( 'name', copy(trim(Lines.Strings[I]),length(Identifyers[ps])+2,length(Lines.Strings[I])),I);
                typeset := true;
              end;
            7: // plc_Conf
              begin
                AppendHeaderField( 'type', 'Ressource',I);
                typeset := true;
              end;
            8: // Visualisation
              begin
                AppendHeaderField( 'type', 'Visualisation',I);
                KeyValue:=copy(trim(Lines.Strings[I]),length(Identifyers[ps])+2,length(Lines.Strings[I]));
                EqP := pos(0,' ',KeyValue);
                if EqP>0 then
                  Keyvalue:=trim(copy(KeyValue,1,EqP));
                AppendHeaderField( 'name', KeyValue,I);
                typeset := true;
              end;

            else
              // Sonstiges
            end

            end
          else if not HeaderEnd then
            begin
              if (copy(trim(line), 1, 4) = 'VAR_') or
                  (copy(trim(line), 1, 4) = 'VAR') or
                  (copy(trim(line), 1, 4) = 'END_') then
                 HeaderEnd := true
              else
                begin
                  if not Commentmode and (copy(trim(line),1,length(Opencomment)) =OpenComment) then
                    Commentmode := true
                  else
                    headerEnd := (trim(line)<>'') and not Commentmode;
                  if CommentMode then
                    begin
                      EqP := pos(0, ':', line);
                      if GetIdentifyerBef(line, EqP, KeyName) then
                        begin
                          if copy(line, length(line)-length(CloseComment)+1, length(CloseComment))=CloseComment then
                            begin
                            line := copy(line, 1, length(line)-length(CloseComment)); // trim Comment-End
                            Commentmode := false
                            end;
                          KeyValue := trim(copy(line, EqP + 2, length(line) - EqP - 1));
                          AppendHeaderField( KeyName, KeyValue,I);
                        end
                      else
                         if copy(line, length(line)-length(CloseComment)+1, length(CloseComment))=CloseComment then
                            Commentmode := false
                    end
                end
            end
        end;

    end;
end;

{$ENDREGION}
{$REGION 'Methods'}

procedure TSEW_Exp_File.SetHeaderField(const Key, Value: String; LineNo: integer
  );

var
  phf: Integer;
begin
  phf := ParseStr(key,HFIdentifyers,psm_Full);
  if phf >=0 then
    begin
      FHeaderIdx[phf] := LineNo;
      case phf of
        1: FAuthor := Value;
        4: FVersion := Value;
        7: FPath := Value;
        8: Ftype := Value;
      end;
    end;
end;

function TSEW_Exp_File.GetAuthor: String;
begin
  result := FAuthor ;
end;

procedure TSEW_Exp_File.SetAuthor(AValue: String);

begin
  if FAuthor = AValue then exit;
  FAuthor := AValue;
  if FHeaderIdx[1] >0 then
    UpdateLineHF(1, AValue)
  else
    InsertHeader;
end;

procedure TSEW_Exp_File.SetPath(AValue: String);
begin
  if Fpath=AValue then Exit;
  Fpath:=AValue;
end;

procedure TSEW_Exp_File.SetType(AValue: String);
begin
  if FType=AValue then Exit;
  FType:=AValue;
end;

procedure TSEW_Exp_File.SetVersion(AValue: String);
begin
  if FVersion=AValue then Exit;
  FVersion:=AValue;
  if FHeaderIdx[4] >0 then
    UpdateLineHF(4, AValue)
  else
    InsertHeader;
end;


procedure TSEW_Exp_File.LoadfromFile(Filename: STRING);
 var s:string;
     sf:TFileStream;
  BEGIN
    sf:=TFileStream.Create(Filename,fmOpenRead);
    try
      setlength(s,sf.Size);
      sf.ReadBuffer(s[1],sf.Size);
//      s[sf.Size+1]:=#0;
      FFileEncoding := GuessEncoding(s);
      FLines.Text:=ConvertEncoding(s,FFileEncoding,EncodingUTF8);
    finally
      freeandnil(sf);
    end;
  END;

procedure TSEW_Exp_File.LoadfromStream(Stream: TStream);
var s:String;
  BEGIN
    setlength(s,Stream.Size);
    Stream.ReadBuffer(s[1],Stream.Size);
//    s[Stream.Size+1]:=#0;
    FFileEncoding := GuessEncoding(s);
    FLines.Text:=ConvertEncoding(s,FFileEncoding,EncodingUTF8);
  END;


procedure TSEW_Exp_File.SavetoFile(Filename: STRING);
 var s:string;
     sf:TFileStream;
  BEGIN
    if fileexists(Filename) then
    sf:=TFileStream.Create(Filename,fmOpenWrite)
    else
    sf:=TFileStream.Create(Filename,fmCreate);
    try
      s:=ConvertEncoding(FLines.Text,EncodingUTF8,FFileEncoding);
      sf.WriteBuffer(s[1],Length(s));
    finally
      freeandnil(sf);
    end;
  END;

procedure TSEW_Exp_File.WriteToStream(Stream: TStream);
var s:String;
  BEGIN
    s:=ConvertEncoding(FLines.Text,EncodingUTF8,FFileEncoding);
    Stream.WriteBuffer(s[1],Length(s));
  END;


procedure TSEW_Exp_File.LoadfromStrings(S: TStrings);
  BEGIN
    FFileEncoding :=  EncodingUTF8;
    FLines.Text := S.Text;
  END;


procedure TSEW_Exp_File.AutoFormat;

  VAR
    J, I, pp, lpp, epp: Integer;
    commentLevel, Indent: Integer;
    Comment, oldComment, LineBreak, BreakBefore: boolean;
    line, NewLine, NewPiece: STRING;
    Codepiece: STRING;
    NewCode: TStringList;
    emptyline: boolean;
    ParseMode: TParseMode;
    columnsize: ARRAY [TParseMode] OF Integer;
    oldParseMode: TParseMode;
    ForFColdParseMode: TParseMode;
    QuoteMode: Boolean;
    LQuoteChar:Char;
    oldQuoteMode: Boolean;

  BEGIN
    Push(psm_Normal, 0);
    NewCode := TStringList.Create;
    try
    IF Options.Values[DefaultOption[efo_Linefeed_Double][0]] = DefaultTrueBoolStr THEN
      BEGIN
        IF (Lines.Count > 0) AND (trim(Lines[0]) <> '') THEN
          NewCode.Add(Lines[0]);
        FOR I := 1 TO Lines.Count - 1 DO
          IF (trim(Lines[I]) = '') AND (trim(Lines[I - 1]) = '') THEN
          ELSE
            NewCode.Add(Lines[I]);
      END
    ELSE
      NewCode.Text := Lines.Text;

    FOR ParseMode := LOW(columnsize) TO HIGH(columnsize) DO
      columnsize[ParseMode] := 10 { MinColumnSize };

    Lines.BeginUpdate;
    Lines.Clear;
    oldComment := false;
    commentLevel := 0;
    Indent := 0;
    NewLine := '';
    LineBreak := true;
    ParseMode := psm_Normal;
    oldParseMode := ParseMode;
    QuoteMode := false;
    oldQuoteMode := false;
    LQuoteChar := QuoteChar;
    FOR J := 0 TO NewCode.Count - 1 DO
      BEGIN
        // Comment and Commentlevel
        line := NewCode[J];
        Codepiece := '';
        emptyline := trim(line) = '';
        WHILE (line <> '') OR emptyline DO
          BEGIN
            I := 1;
            Comment := false;
            pp := pos(1, OpenComment, line);
            IF (1 <= length(line)) AND (line[1] = LQuoteChar) THEN
               QuoteMode := not QuoteMode;
            if not QuoteMode then
              begin
              if ParseMode=psm_Bitaccess then
                LQuoteChar:=BAQuoteChar
              else
                LQuoteChar:=QuoteChar;
              end;
            IF (ParseMode <> psm_nonST) AND (commentLevel = 0) AND
              (copy(line, 1, 2) <> OpenComment) and not Quotemode THEN
              BEGIN
                WHILE (I <= length(line)) AND ((I < pp) OR (pp = 0)) AND
                  ( NOT charinset(line[I], whitespace + [CommandEnd, LQuoteChar])) DO
                  inc(I);
                IF (I <= length(line)) AND (line[I] = CommandEnd) THEN
                  inc(I);
              END
            ELSE if not QuoteMode then
              BEGIN
                pp := -1;
                epp := 0;
                WHILE (pp <> 0) DO
                  BEGIN
                    lpp := pos(pp + 2, OpenComment, line);
                    epp := pos(pp + 2, CloseComment, line);
                    IF ((lpp <> 0) AND (epp <> 0) AND (epp < lpp)) OR
                      ((lpp = 0) AND (epp > 0)) THEN
                      BEGIN
                        dec(commentLevel);
                        pp := epp;
                        IF commentLevel <= 0 THEN
                          BEGIN
                            commentLevel := 0;
                            break;
                          END;
                      END
                    ELSE IF (lpp <> 0) THEN
                      BEGIN
                        inc(commentLevel);
                        pp := lpp;
                      END
                    ELSE
                      pp := 0;
                  END;

                IF (ParseMode <> psm_nonST) AND (epp > 0) THEN
                  I := epp + length(CloseComment)
                ELSE
                  I := length(line) + 1;
                Comment := true;
              END
            else
              begin
                WHILE (I <= length(line)) and ((I=1) or (line[I] <> LQuoteChar)) DO
                  inc(I);
                IF (I <= length(line)) AND (line[I] = LQuoteChar) THEN
                  inc(i);
              end;

            Codepiece := copy(line, 1, I - 1);
            line := trim(copy(line, I, length(line) - I + 1));

            IF Comment or Quotemode THEN
              BEGIN
                NewPiece := Codepiece;
                LineBreak := (line = '') and (not quotemode) ;
                BreakBefore := ((trim(NewPiece) = trim(NewCode[J])));
                IF (NewLine <> '') AND NOT BreakBefore THEN
                  Comment := false;
              END
            ELSE
              NewPiece := ParseCode(trim(Codepiece), BreakBefore, LineBreak,
                ParseMode);

            IF (BreakBefore OR emptyline) AND (NewLine <> '') THEN
              BEGIN
                IF NOT oldComment THEN
                  BEGIN
                    ooParsemode := oldParseMode;
                    NewLine := FormatCode(trim(NewLine), Indent, oldParseMode, FKnownIdentifyer);
                    AppendLine(Lines, oldParseMode, NewLine, columnsize);
                    IF ooParsemode <> oldParseMode THEN
                      ParseMode := oldParseMode;
                  END
                ELSE
                  AppendLine(Lines, psm_Comment, NewLine, columnsize);
                NewLine := ''
              END;

            NewLine := NewLine + NewPiece;

            IF LineBreak OR emptyline OR
              ((line = '') AND (J = NewCode.Count - 1)) THEN
              BEGIN
                if copy(line,1,length(OpenComment)) = OpenComment then
                  begin
                  pp := -1;
                  epp := 0;
                  WHILE (pp <> 0) DO
                    BEGIN
                      lpp := pos(pp + 2, OpenComment, line);
                      epp := pos(pp + 2, CloseComment, line);
                      IF ((lpp <> 0) AND (epp <> 0) AND (epp < lpp)) OR
                        ((lpp = 0) AND (epp > 0)) THEN
                        BEGIN
                          dec(commentLevel);
                          pp := epp;
                          IF commentLevel <= 0 THEN
                            BEGIN
                              commentLevel := 0;
                              break;
                            END;
                        END
                      ELSE IF (lpp <> 0) THEN
                        BEGIN
                          inc(commentLevel);
                          pp := lpp;
                        END
                      ELSE
                        pp := 0;
                    END;

                    IF (ParseMode <> psm_nonST) AND (epp > 0) THEN
                      begin
                        I := epp + length(CloseComment);
                        NewLine :=NewLine + copy(line, 1, I - 1);
                        line := trim(copy(line, I, length(line) - I + 1));
                      end
                    else
                      commentLevel:=0;
                  end;
                  IF (NOT Comment)
                      and (parsemode <> psm_nonST) THEN
                  BEGIN
                    ForFColdParseMode := ParseMode;
                    NewLine := FormatCode(trim(NewLine), Indent, ParseMode, FKnownIdentifyer);
                    AppendLine(Lines, ForFColdParseMode, NewLine, columnsize)
                  END
                ELSE IF BreakBefore or oldQuotemode THEN
                  begin
                    AppendLine(Lines, psm_Comment, NewLine, columnsize);
                  end
                ELSE
                  Lines[Lines.Count - 1] := Lines[Lines.Count - 1] + ' '
                    + NewLine;
                NewLine := ''
              END
            ELSE
              BEGIN
                oldParseMode := ParseMode;
                oldComment := Comment;
              END;
            emptyline := false;
            if QuoteMode
              and (Codepiece[length(Codepiece)]=LQuoteChar)
              and (length(Codepiece)>1) then
              QuoteMode:=false;

          END;
        if QuoteMode then
          NewLine:=NewLine+LineEnding;
      END;

    finally
      newcode.free;
    end;

    // Columnize
    FOR I := 0 TO Lines.Count - 1 DO
      CASE TParseMode(ptrint(Lines.Objects[I])) OF
        psm_Struct:
          Lines[I] := FormatColumns(Lines[I], [columnsize[psm_Struct], 3, 8]);
        psm_Type:
          IF (I > 0) AND (TParseMode(ptrint(Lines.Objects[I - 1])) = psm_Type) THEN
            Lines[I] := FormatColumns(Lines[I], [columnsize[psm_Type], 3, 8]);
        psm_Var:
          Lines[I] := FormatColumns(Lines[I], [columnsize[psm_Var], 3, 8]);
        psm_Bitaccess:
          Lines[I] := FormatColumns(Lines[I],
            [12, columnsize[psm_Bitaccess], 8]);
      END;
    lines.EndUpdate;
  END;

procedure TSEW_Exp_File.AppendVariableDef(const AVarname: string;
  const aVarSection: TenumVarsection; const Atype, AComment: string);
var
  i, lFound: Integer;
  ucAVarname: String;
begin
  //Suche Variable in FKnownIdentifyer
  ucAVarname:=UpperCase(AVarname);
  lFound:=-1;
  for i := 0 to high(FKnownIdentifyer) do
    if uppercase(FKnownIdentifyer[i].Name)=ucAVarname then
      begin
      lFound:=i;
      break;
      end;
  if lfound >=0 then
  //wenn gefunden: prüfe comment, Übernehme (längeren Comment)
    with FKnownIdentifyer[lfound] do
      begin
      if Length(AComment)>length(Comment) then
        Comment:=AComment;
      end
  else
  //sonst _V. Einfügen
    begin
      SetLength(FKnownIdentifyer,high(FKnownIdentifyer)+2);
      with FKnownIdentifyer[high(FKnownIdentifyer)] do
        begin
          Name:=AVarname;
          VarSection:=aVarSection;
          VarTypeString:=Atype;
          Comment:=AComment;
        end;
    end;
end;

{$ENDREGION}

VAR
  I: Integer;

INITIALIZATION

SetLength(Identifyers, HIGH(BaseIdent) + 1);
FOR I := 0 TO HIGH(BaseIdent) DO
  Identifyers[I] := BaseIdent[I];

SetLength(HFIdentifyers, HIGH(HeaderFieldIdent) + 1);
FOR I := 0 TO HIGH(HeaderFieldIdent) DO
  HFIdentifyers[I] := HeaderFieldIdent[I];

SetLength(HFAIdentifyers, HIGH(AlternHeaderFieldIdent) + 1);
FOR I := 0 TO HIGH(AlternHeaderFieldIdent) DO
  HFAIdentifyers[I] := AlternHeaderFieldIdent[I];

SetLength(WellKnownCnstFct, HIGH(DWellKnownCnstFct) + 1);
FOR I := 0 TO HIGH(DWellKnownCnstFct) DO
  WellKnownCnstFct[I] := DWellKnownCnstFct[I];

SEWFile := TSEW_Exp_File.Create;

RegisterGetInfoProc(SEWFile);
finalization
UnRegisterGetInfoProc(SEWFile);
if assigned(SEWFile) then
  FreeAndNil(SEWFile);
setlength(Identifyers,0);
SetLength(HFIdentifyers,0);
SetLength(WellKnownCnstFct,0);

END.
