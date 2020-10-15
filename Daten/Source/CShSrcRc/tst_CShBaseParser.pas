unit tst_CShBaseParser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, CShTree, CShScanner, CShParser, testregistry;

const
  DefaultMainFilename = 'afile.cs';
Type
  { TTestEngine }

  TTestEngine = Class(TCShTreeContainer)
  Private
    FList : TFPList;
  public
    Destructor Destroy; override;
    function CreateElement(AClass: TCShTreeElement; const AName: String;
      AParent: TCShElement; AVisibility: TCShMemberVisibility;
      const ASourceFilename: String; ASourceLinenumber: Integer): TCShElement;
      override;
    function FindElement(const AName: String): TCShElement; override;
  end;
  TTestCShParser = Class(TCShParser);

  { TTestParser }

  TTestParser = class(TTestCase)
  Private
    FDeclarations: TCShDeclarations;
    FDefinition: TCShElement;
    FEngine : TCShTreeContainer;
    FMainFilename: string;
    FModule: TCShModule;
    FParseResult: TCShElement;
    FScanner : TCSharpScanner;
    FResolver : TStreamResolver;
    FParser : TTestCShParser;
    FSource: TStrings;
    FFileName : string;
    FIsUnit : Boolean;
    FImplementation : Boolean;
    FEndSource: Boolean;
    FTestBlock: TCShImplBlock;
    FUseImplementation: Boolean;
    procedure CleanupParser;
    procedure SetupParser;
  protected
    FHasNamespace: Boolean;
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CreateEngine(var TheEngine: TCShTreeContainer); virtual;
    Procedure StartUnit(AUnitName : String);
    Procedure StartProgram(AFileName : String);
    Procedure UsingClause(Namespaces : Array of string);
    Procedure StartImplementation;
    Procedure EndSource;
    Procedure Add(Const ALine : String);
    Procedure Add(Const Lines : array of String);
    Procedure StartParsing;
    Procedure ParseDeclarations;
    Procedure ParseModule; virtual;
    procedure ParseStatements; virtual;
    procedure ResetParser;
    Procedure CheckHint(AHint : TCShMemberHint);
    Function AssertExpression(Const Msg: String; AExpr : TCShExpr; aKind : TCShExprKind; AClass : TClass) : TCShExpr;
    Function AssertExpression(Const Msg: String; AExpr : TCShExpr; aKind : TCShExprKind; AValue : String) : TPrimitiveExpr;
    Function AssertExpression(Const Msg: String; AExpr : TCShExpr; OpCode : TExprOpCode) : TBinaryExpr;
    function AssertExpression(const Msg: String; AExpr: TCShExpr; AValue: string
      ): TParamsExpr; overload;
    Procedure AssertExportSymbol(Const Msg: String; AIndex : Integer; AName,AExportName : String; AExportIndex : Integer = -1);
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TCShExprKind); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TCShObjKind); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TExprOpCode); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TCShMemberHint); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TCallingConvention); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TArgumentAccess); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TVariableModifier); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TVariableModifiers); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TCShMemberVisibility); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TProcedureModifier); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TProcedureModifiers); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TProcTypeModifiers); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TAssignKind); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TProcedureMessageType); overload;
    Procedure AssertEquals(Const Msg : String; AExpected, AActual: TOperatorType); overload;
    Procedure AssertSame(Const Msg : String; AExpected, AActual: TCShElement); overload;
    Procedure HaveHint(AHint : TCShMemberHint; AHints : TCShMemberHints);
    Property Resolver : TStreamResolver Read FResolver;
    Property Scanner : TCSharpScanner Read FScanner;
    Property Engine : TCShTreeContainer read FEngine;
    Property Parser : TTestCShParser read FParser ;
    Property Source : TStrings Read FSource;
    Property Module : TCShModule Read FModule;
    property ImpBlock : TCShImplBlock read FTestBlock;
    Property Declarations : TCShDeclarations read FDeclarations Write FDeclarations;
    Property Definition : TCShElement Read FDefinition Write FDefinition;
    // If set, Will be freed in teardown
    Property ParseResult : TCShElement Read FParseResult Write FParseResult;
    Property UseImplementation : Boolean Read FUseImplementation Write FUseImplementation;
    Property MainFilename: string read FMainFilename write FMainFilename;
  end;

function ExtractFileUnitName(aFilename: string): string;
function GetCShElementDesc(El: TCShElement): string;
procedure ReadNextCSharpToken(var Position: PChar; out TokenStart: PChar;
  NestedComments: boolean; SkipDirectives: boolean);

implementation

uses typinfo;

resourcestring
  rsCShFilename = '%s.cs';
  rsUsingNamespace = 'using %s;';

function ExtractFileUnitName(aFilename: string): string;
var
  p: Integer;
begin
  Result:=ExtractFileName(aFilename);
  if Result='' then exit;
  for p:=length(Result) downto 1 do
    case Result[p] of
    '/','\': exit;
    '.':
      begin
      Delete(Result,p,length(Result));
      exit;
      end;
    end;
end;

function GetCShElementDesc(El: TCShElement): string;
begin
  if El=nil then exit('nil');
  Result:=El.Name+':'+El.ClassName+'['+El.SourceFilename+','+IntToStr(El.SourceLinenumber)+']';
end;

procedure ReadNextCSharpToken(var Position: PChar; out TokenStart: PChar;
  NestedComments: boolean; SkipDirectives: boolean);
const
  IdentChars = ['a'..'z','A'..'Z','_','0'..'9'];
  HexNumberChars = ['0'..'9','a'..'f','A'..'F'];
var
  c1:char;
  CommentLvl: Integer;
  Src: PChar;
begin
  Src:=Position;
  // read till next atom
  while true do
    begin
    case Src^ of
    #0: break;
    #1..#32:  // spaces and special characters
      inc(Src);
    #$EF:
      if (Src[1]=#$BB)
      and (Src[2]=#$BF) then
        begin
        // skip UTF BOM
        inc(Src,3);
        end
      else
        break;
    '/':    // comment start or compiler directive
        if (Src[1]='/') then
        begin
        // comment start -> read til line end
        inc(Src);
        while not (Src^ in [#0,#10,#13]) do
          inc(Src);
        end
      else if (Src[1]='*') then
        // compiler directive
        begin
        inc(Src);
        // CShcal comment => skip
        CommentLvl:=1;
        while true do
          begin
          inc(Src);
          case Src^ of
          #0: break;
          '/':if src[1]='*' then
            begin
              inc(src);
               if NestedComments then
                  inc(CommentLvl);
            end;
          '*': if src[1]='/' then
            begin
            inc(Src);
            dec(CommentLvl);
            if CommentLvl=0 then
              begin
              inc(Src);
              break;
              end;
            end;
          end;
        end;
      end
      else
        break;
    else
      break;
    end; // case
    end; //
  // read token
  TokenStart:=Src;
  c1:=Src^;
  case c1 of
  #0:
    ;
  'A'..'Z','a'..'z','_':
    begin
    // identifier
    inc(Src);
    while Src^ in IdentChars do
      inc(Src);
    end;
  '0'..'9': // number
    begin
    inc(Src);
    // read numbers
    while (Src^ in ['0'..'9']) do
      inc(Src);
    if (Src^='.') and (Src[1]<>'.') then
      begin
      // real type number
      inc(Src);
      while (Src^ in ['0'..'9']) do
        inc(Src);
      end;
    if (Src^ in ['e','E']) then
      begin
      // read exponent
      inc(Src);
      if (Src^='-') then inc(Src);
      while (Src^ in ['0'..'9']) do
        inc(Src);
      end;
    end;
  '"','#':  // string constant
    while true do
      case Src^ of
      #0: break;
      '#':
        begin
        inc(Src);
        while Src^ in ['0'..'9'] do
          inc(Src);
        end;
      '"':
        begin
        inc(Src);
        while not (Src^ in ['''',#0]) do
          inc(Src);
        if Src^='''' then
          inc(Src);
        end;
      else
        break;
      end;
  '$':  // hex constant
    begin
    inc(Src);
    while Src^ in HexNumberChars do
      inc(Src);
    end;
  '&':  // octal constant or keyword as identifier (e.g. &label)
    begin
    inc(Src);
    if Src^ in ['0'..'7'] then
      while Src^ in ['0'..'7'] do
        inc(Src)
    else
      while Src^ in IdentChars do
        inc(Src);
    end;
  '/':  // compiler directive (it can't be a comment, because see above)
    begin
    CommentLvl:=1;
    while true do
      begin
      inc(Src);
      case Src^ of
      #0: break;
      '{':
        if NestedComments then
          inc(CommentLvl);
      '}':
        begin
        dec(CommentLvl);
        if CommentLvl=0 then
          begin
          inc(Src);
          break;
          end;
        end;
      end;
      end;
    end;
  '(':  // bracket or compiler directive
    if (Src[1]='*') then
      begin
      // compiler directive -> read til comment end
      inc(Src,2);
      while (Src^<>#0) and ((Src^<>'*') or (Src[1]<>')')) do
        inc(Src);
      inc(Src,2);
      end
    else
      // round bracket open
      inc(Src);
  #192..#255:
    begin
    // read UTF8 character
    inc(Src);
    if ((ord(c1) and %11100000) = %11000000) then
      begin
      // could be 2 byte character
      if (ord(Src[0]) and %11000000) = %10000000 then
        inc(Src);
      end
    else if ((ord(c1) and %11110000) = %11100000) then
      begin
      // could be 3 byte character
      if ((ord(Src[0]) and %11000000) = %10000000)
      and ((ord(Src[1]) and %11000000) = %10000000) then
        inc(Src,2);
      end
    else if ((ord(c1) and %11111000) = %11110000) then
      begin
      // could be 4 byte character
      if ((ord(Src[0]) and %11000000) = %10000000)
      and ((ord(Src[1]) and %11000000) = %10000000)
      and ((ord(Src[2]) and %11000000) = %10000000) then
        inc(Src,3);
      end;
    end;
  else
    inc(Src);
    case c1 of
    '<': if Src^ in ['>','='] then inc(Src);
    '.': if Src^='.' then inc(Src);
    '@':
      if Src^='@' then
        begin
        // @@ label
        repeat
          inc(Src);
        until not (Src^ in IdentChars);
        end
    else
      if (Src^='=') and (c1 in [':','+','-','/','*','<','>']) then
        inc(Src);
    end;
  end;
  Position:=Src;
end;

{ TTestEngine }

destructor TTestEngine.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

function TTestEngine.CreateElement(AClass: TCShTreeElement; const AName: String;
  AParent: TCShElement; AVisibility: TCShMemberVisibility;
  const ASourceFilename: String; ASourceLinenumber: Integer): TCShElement;
begin
  //writeln('TTestEngine.CreateElement ',AName,' ',AClass.ClassName);
  Result := AClass.Create(AName, AParent);
  {$IFDEF CheckCShTreeRefCount}Result.RefIds.Add('CreateElement');{$ENDIF}
  Result.Visibility := AVisibility;
  Result.SourceFilename := ASourceFilename;
  Result.SourceLinenumber := ASourceLinenumber;
  if NeedComments and Assigned(CurrentParser) then
    begin
//    Writeln('Saving comment : ',CurrentParser.SavedComments);
    Result.DocComment:=CurrentParser.SavedComments;
    end;
  if AName<>'' then
    begin
    If not Assigned(FList) then
      FList:=TFPList.Create;
    FList.Add(Result);
    end;
end;

function TTestEngine.FindElement(const AName: String): TCShElement;

Var
  I : Integer;

begin
  Result:=Nil;
  if Assigned(FList) then
    begin
    I:=FList.Count-1;
    While (Result=Nil) and (I>=0) do
      begin
      if CompareText(TCShElement(FList[I]).Name,AName)=0 then
        Result:=TCShElement(FList[i]);
      Dec(i);
      end;
    end;
end;

procedure TTestParser.SetupParser;

begin
  FResolver:=TStreamResolver.Create;
  FResolver.OwnsStreams:=True;
  FScanner:=TCSharpScanner.Create(FResolver);
  FScanner.CurrentBoolSwitches:=FScanner.CurrentBoolSwitches+[bsHints,bsNotes,bsWarnings];
  CreateEngine(FEngine);
  FParser:=TTestCShParser.Create(FScanner,FResolver,FEngine);
  FSource:=TStringList.Create;
  FModule:=Nil;
  FDeclarations:=Nil;
  FEndSource:=False;
  FImplementation:=False;
  FIsUnit:=False;
end;

procedure TTestParser.CleanupParser;

begin
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser START');
  {$ENDIF}
  if Not Assigned(FModule) then
    FreeAndNil(FDeclarations)
  else
    FDeclarations:=Nil;
  FImplementation:=False;
  FEndSource:=False;
  FIsUnit:=False;
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser FModule');
  {$ENDIF}
  ReleaseAndNil(TCShElement(FModule){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser FTestBlock');
  {$ENDIF}
  ReleaseAndNil(TCShElement(FTestBlock){$IFDEF CheckCShTreeRefCount},'CreateElement'{$ENDIF});
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser FSource');
  {$ENDIF}
  FreeAndNil(FSource);
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser FParseResult');
  {$ENDIF}
  FreeAndNil(FParseResult);
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser FParser');
  {$ENDIF}
  FreeAndNil(FParser);
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser FEngine');
  {$ENDIF}
  FreeAndNil(FEngine);
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser FScanner');
  {$ENDIF}
  FreeAndNil(FScanner);
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser FResolver');
  {$ENDIF}
  FreeAndNil(FResolver);
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser END');
  {$ENDIF}
end;

procedure TTestParser.ResetParser;

begin
  CleanupParser;
  SetupParser;
end;

procedure TTestParser.SetUp;
begin
  FMainFilename:=DefaultMainFilename;
  Inherited;
  SetupParser;
end;

procedure TTestParser.TearDown;
begin
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.TearDown START CleanupParser');
  {$ENDIF}
  CleanupParser;
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.TearDown inherited');
  {$ENDIF}
  Inherited;
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.TearDown END');
  {$ENDIF}
end;

procedure TTestParser.CreateEngine(var TheEngine: TCShTreeContainer);
begin
  TheEngine:=TTestEngine.Create;
end;

procedure TTestParser.StartUnit(AUnitName: String);
begin
  FIsUnit:=True;
  If (AUnitName='') then
    AUnitName:=ExtractFileUnitName(MainFilename);
  FFileName:=Format(rsCShFilename, [AUnitName]);
  FImplementation:=True;
  add('using system;');
  add('namespace '+AUnitName);
  add('{');
  FHasNamespace := true;
  add('class '+AUnitName+'Class');
  add('{');
end;

procedure TTestParser.StartProgram(AFileName : String);
begin
  FIsUnit:=False;
  If (AFileName='') then
    AFileName:='aFile';
  FFileName:=Format(rsCShFilename, [AFileName]);
  FImplementation:=True;
  add('using system;');
  FHasNamespace := false;
  add('class '+ExtractFilenameOnly(AFileName));
  add('{');
end;

procedure TTestParser.UsingClause(Namespaces: array of string);

Var
  I : integer;

begin
  For I:=Low(Namespaces) to High(Namespaces) do
    Add(Format(rsUsingNamespace, [Namespaces[i]]));
  Add('');
end;

procedure TTestParser.StartImplementation;
begin
  if Not FImplementation then
    begin
       FImplementation:=True;
    end;
end;

procedure TTestParser.EndSource;
begin
  if Not FEndSource then
    begin
    Add('}'); // Main
    Add('}'); // Class
    if FHasNamespace then
      Add('}'); // Namespace
    FEndSource:=True;
    end;
end;

procedure TTestParser.Add(const ALine: String);
begin
  FSource.Add(ALine);
end;

procedure TTestParser.Add(const Lines: array of String);
var
  i: Integer;
begin
  for i:=Low(Lines) to High(Lines) do
    Add(Lines[i]);
end;

procedure TTestParser.StartParsing;

var
  i: Integer;
begin
  If FIsUnit then
    StartImplementation;
  EndSource;
  If (FFileName='') then
    FFileName:=MainFilename;
  FResolver.AddStream(FFileName,TStringStream.Create(FSource.Text));
  FScanner.OpenFile(FFileName);
  {$ifndef NOCONSOLE}
  Writeln('// Test : ',Self.TestName);
  for i:=0 to FSource.Count-1 do
    Writeln(Format('%:4d: ',[i+1]),FSource[i]);
  {$endif}
end;

procedure TTestParser.ParseDeclarations;
begin
  if UseImplementation then
    StartImplementation;
  FSource.Insert(0,'{');
  FSource.Insert(0,'class aClass');
  FHasNamespace := false;
  if Not UseImplementation then
    StartImplementation;
  EndSource;
  ParseModule;
  FDeclarations:=Module.ImplementationSection
end;

procedure TTestParser.ParseModule;
begin
  StartParsing;
  FParser.ParseMain(FModule);
  AssertNotNull('Module resulted in Module',FModule);
  AssertEquals('modulename',ChangeFileExt(FFileName,''),Module.Name);
end;

procedure TTestParser.ParseStatements;
var
  lNewImplElement: TCShImplElement;
begin
  FreeAndNil(FTestBlock);
  FFileName:=Format(rsCShFilename, ['aTest']);
  FResolver.AddStream(FFileName,TStringStream.Create(FSource.Text));
  FScanner.OpenFile(FFileName);
  FTestBlock :=TCShImplBlock.Create('Main',nil);
  FParser.NextToken;
  repeat
     if not (FParser.CurToken in [tkSemicolon,tkCurlyBraceClose]) then
       begin
         FParser.UngetToken;
         FParser.ParseStatement(FTestBlock,lNewImplElement);
         if lNewImplElement = nil then
           break;
       end;
     FParser.NextToken;
  until FParser.CurToken = tkCurlyBraceClose;
  AssertNotNull('Module resulted in Module',FTestBlock);
end;

procedure TTestParser.CheckHint(AHint: TCShMemberHint);
begin
  HaveHint(AHint,Definition.Hints);
end;

function TTestParser.AssertExpression(const Msg: String; AExpr: TCShExpr;
  aKind: TCShExprKind; AClass: TClass): TCShExpr;
begin
  AssertNotNull(AExpr);
  AssertEquals(Msg+': Correct expression kind',aKind,AExpr.Kind);
  AssertEquals(Msg+': Correct expression class',AClass,AExpr.ClassType);
  Result:=AExpr;
end;

function TTestParser.AssertExpression(const Msg: String; AExpr: TCShExpr;
  aKind: TCShExprKind; AValue: String): TPrimitiveExpr;
begin
  Result:=AssertExpression(Msg,AExpr,aKind,TPrimitiveExpr) as TPrimitiveExpr;
  AssertEquals(Msg+': Primitive expression value',AValue,TPrimitiveExpr(AExpr).Value);
end;

function TTestParser.AssertExpression(const Msg: String; AExpr: TCShExpr;
  AValue:string): TParamsExpr;
begin
  Result:=AssertExpression(Msg,AExpr,pekFuncParams,TParamsExpr) as TParamsExpr;
  if assigned(TParamsExpr(AExpr).Value) then
    AssertEquals(Msg+': Funktion Params',AValue,TParamsExpr(AExpr).Value.GetDeclaration(true));
end;

function TTestParser.AssertExpression(const Msg: String; AExpr: TCShExpr;
  OpCode: TExprOpCode): TBinaryExpr;
begin
  Result:=AssertExpression(Msg,AExpr,pekBinary,TBinaryExpr) as TBinaryExpr;
  AssertEquals(Msg+': Binary opcode',OpCode,TBinaryExpr(AExpr).OpCode);
end;

procedure TTestParser.AssertExportSymbol(const Msg: String; AIndex: Integer;
  AName, AExportName: String; AExportIndex: Integer);

Var
  E: TCShExportSymbol;

begin
  if (AExportName='') then
    AssertNull(Msg+'No export name',E.ExportName)
  else
    begin
    AssertNotNull(Msg+'Export name symbol',E.ExportName);
    AssertEquals(Msg+'TPrimitiveExpr',TPrimitiveExpr,E.ExportName.CLassType);
    AssertEquals(Msg+'Correct export symbol export name ',''''+AExportName+'''',TPrimitiveExpr(E.ExportName).Value);
    end;
  If AExportIndex=-1 then
    AssertNull(Msg+'No export name',E.ExportIndex)
  else
    begin
    AssertNotNull(Msg+'Export name symbol',E.ExportIndex);
    AssertEquals(Msg+'TPrimitiveExpr',TPrimitiveExpr,E.ExportIndex.CLassType);
    AssertEquals(Msg+'Correct export symbol export index',IntToStr(AExportindex),TPrimitiveExpr(E.ExportIndex).Value);
    end;
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TCShExprKind);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TCShExprKind),Ord(AExpected)),
                   GetEnumName(TypeInfo(TCShExprKind),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TCShObjKind);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TCShObjKind),Ord(AExpected)),
                   GetEnumName(TypeInfo(TCShObjKind),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TExprOpCode);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TexprOpcode),Ord(AExpected)),
                   GetEnumName(TypeInfo(TexprOpcode),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TCShMemberHint);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TCShMemberHint),Ord(AExpected)),
                   GetEnumName(TypeInfo(TCShMemberHint),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TCallingConvention);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TCallingConvention),Ord(AExpected)),
                   GetEnumName(TypeInfo(TCallingConvention),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TArgumentAccess);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TArgumentAccess),Ord(AExpected)),
                   GetEnumName(TypeInfo(TArgumentAccess),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TVariableModifier);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TVariableModifier),Ord(AExpected)),
                   GetEnumName(TypeInfo(TVariableModifier),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TVariableModifiers);

 Function sn (S : TVariableModifiers) : string;

 Var
   M : TVariableModifier;

 begin
   Result:='';
   For M:=Low(TVariableModifier) to High(TVariableModifier) do
     if M in S then
       begin
       if (Result<>'') then
         Result:=Result+',';
       end;
   Result:='['+Result+']';
 end;

begin
  AssertEquals(Msg,Sn(AExpected),Sn(AActual));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TCShMemberVisibility);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TCShMemberVisibility),Ord(AExpected)),
                   GetEnumName(TypeInfo(TCShMemberVisibility),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TProcedureModifier);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TProcedureModifier),Ord(AExpected)),
                   GetEnumName(TypeInfo(TProcedureModifier),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TProcedureModifiers);

  Function Sn (S : TProcedureModifiers) : String;

  Var
    m : TProcedureModifier;
  begin
    Result:='';
    For M:=Low(TProcedureModifier) to High(TProcedureModifier) do
      If (m in S) then
        begin
        If (Result<>'') then
           Result:=Result+',';
        Result:=Result+GetEnumName(TypeInfo(TProcedureModifier),Ord(m))
        end;
  end;
begin
  AssertEquals(Msg,Sn(AExpected),SN(AActual));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TProcTypeModifiers);

  Function Sn (S : TProcTypeModifiers) : String;

  Var
    m : TProcTypeModifier;
  begin
    Result:='';
    For M:=Low(TProcTypeModifier) to High(TProcTypeModifier) do
      If (m in S) then
        begin
        If (Result<>'') then
           Result:=Result+',';
        Result:=Result+GetEnumName(TypeInfo(TProcTypeModifier),Ord(m))
        end;
  end;
begin
  AssertEquals(Msg,Sn(AExpected),SN(AActual));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TAssignKind);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TAssignKind),Ord(AExpected)),
                   GetEnumName(TypeInfo(TAssignKind),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TProcedureMessageType);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TProcedureMessageType),Ord(AExpected)),
                   GetEnumName(TypeInfo(TProcedureMessageType),Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg: String; AExpected,
  AActual: TOperatorType);
begin
  AssertEquals(Msg,GetEnumName(TypeInfo(TOperatorType),Ord(AExpected)),
                   GetEnumName(TypeInfo(TOperatorType),Ord(AActual)));
end;

procedure TTestParser.AssertSame(const Msg: String; AExpected,
  AActual: TCShElement);
begin
  if AExpected=AActual then exit;
  AssertEquals(Msg,GetCShElementDesc(AExpected),GetCShElementDesc(AActual));
end;

procedure TTestParser.HaveHint(AHint: TCShMemberHint; AHints: TCShMemberHints);
begin
  If not (AHint in AHints) then
    Fail(GetEnumName(TypeInfo(TCShMemberHint),Ord(AHint))+'hint expected.');
end;

end.

