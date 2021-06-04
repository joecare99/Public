unit tst_CShBaseParser;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, fpcunit, CShTree, CShScanner, CShParser, testregistry;

const
    DefaultMainFilename = 'afile.cs';

type
    { TTestEngine }

    TTestEngine = class(TCShTreeContainer)
    private
        FList :TFPList;
    public
        destructor Destroy; override;
        function CreateElement(AClass :TCShTreeElement; const AName :string;
            AParent :TCShElement; AVisibility :TCShMemberVisibility;
            const ASourceFilename :string; ASourceLinenumber :integer) :TCShElement;
            override;
        function FindElement(const AName :string) :TCShElement; override;
    end;

    TTestCShParser = class(TCShParser);

    { TTestParser }

    TTestParser = class(TTestCase)
    private
        FDeclarations :TCShDeclarations;
        FDefinition  :TCShElement;
        FEngine      :TCShTreeContainer;
        FMainFilename :string;
        FModule      :TCShModule;
        FParseResult :TCShElement;
        FScanner     :TCSharpScanner;
        FResolver    :TStreamResolver;
        FParser      :TTestCShParser;
        FSource      :TStrings;
        FFileName    :string;
        FIsUnit      :boolean;
        FImplementation :boolean;
        FEndSource   :boolean;
        FTestBlock   :TCShImplBlock;
        FUseImplementation :boolean;
        procedure CleanupParser;
        procedure SetupParser;
    protected
        FHasNamespace :boolean;
        procedure SetUp; override;
        procedure TearDown; override;
        procedure CreateEngine(var TheEngine :TCShTreeContainer); virtual;
        procedure StartUnit(AUnitName :string);
        procedure StartProgram(AFileName :string);
        procedure UsingClause(Namespaces :array of string);
        procedure StartImplementation;
        procedure EndSource;
        procedure Add(const ALine :string);
        procedure Add(const Lines :array of string);
        procedure StartParsing;
        procedure ParseDeclarations;
        procedure ParseModule; virtual;
        procedure ParseStatements; virtual;
        procedure ResetParser;
        procedure CheckHint(AHint :TCShMemberHint);
        function AssertExpression(const Msg :string; AExpr :TCShExpr;
            aKind :TCShExprKind; AClass :TClass) :TCShExpr;
        function AssertExpression(const Msg :string; AExpr :TCShExpr;
            aKind :TCShExprKind; AValue :string) :TPrimitiveExpr;
        function AssertExpression(const Msg :string; AExpr :TCShExpr;
            OpCode :TExprOpCode) :TBinaryExpr;
        function AssertExpression(const Msg :string; AExpr :TCShExpr;
            AValue :string) :TParamsExpr; overload;
        procedure AssertExportSymbol(const Msg :string; AIndex :integer;
            AName, AExportName :string; AExportIndex :integer = -1);
        procedure AssertEquals(const Msg :string; AExpected, AActual :TCShExprKind);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TCShObjKind);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TExprOpCode);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TCShMemberHint);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TCallingConvention);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TArgumentAccess);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TVariableModifier);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TVariableModifiers);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TCShMemberVisibility);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TProcedureModifier);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TProcedureModifiers);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TProcTypeModifiers);
            overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TAssignKind);
            overload;
        procedure AssertEquals(const Msg :string;
            AExpected, AActual :TProcedureMessageType); overload;
        procedure AssertEquals(const Msg :string; AExpected, AActual :TOperatorType);
            overload;
        procedure AssertSame(const Msg :string; AExpected, AActual :TCShElement); overload;
        procedure HaveHint(AHint :TCShMemberHint; AHints :TCShMemberHints);
        property Resolver :TStreamResolver read FResolver;
        property Scanner :TCSharpScanner read FScanner;
        property Engine :TCShTreeContainer read FEngine;
        property Parser :TTestCShParser read FParser;
        property Source :TStrings read FSource;
        property Module :TCShModule read FModule;
        property ImpBlock :TCShImplBlock read FTestBlock;
        property Declarations :TCShDeclarations read FDeclarations write FDeclarations;
        property Definition :TCShElement read FDefinition write FDefinition;
        // If set, Will be freed in teardown
        property ParseResult :TCShElement read FParseResult write FParseResult;
        property UseImplementation :boolean read FUseImplementation
            write FUseImplementation;
        property MainFilename :string read FMainFilename write FMainFilename;
    end;

function ExtractFileUnitName(aFilename :string) :string;
function GetCShElementDesc(El :TCShElement) :string;
procedure ReadNextCSharpToken(var Position :PChar; out TokenStart :PChar;
    NestedComments :boolean; SkipDirectives :boolean);

implementation

uses typinfo;

resourcestring
    rsCShFilename    = '%s.cs';
    rsUsingNamespace = 'using %s;';

function ExtractFileUnitName(aFilename :string) :string;
var
    p :integer;
begin
    Result := ExtractFileName(aFilename);
    if Result = '' then
        exit;
    for p := length(Result) downto 1 do
        case Result[p] of
            '/', '\':
                exit;
            '.' :begin
                Delete(Result, p, length(Result));
                exit;
              end;
          end;
end;

function GetCShElementDesc(El :TCShElement) :string;
begin
    if El = nil then
        exit('nil');
    Result := El.Name + ':' + El.ClassName + '[' + El.SourceFilename + ',' + IntToStr(
        El.SourceLinenumber) + ']';
end;

procedure ReadNextCSharpToken(var Position :PChar; out TokenStart :PChar;
    NestedComments :boolean; SkipDirectives :boolean);
const
    IdentChars     = ['a'..'z', 'A'..'Z', '_', '0'..'9'];
    HexNumberChars = ['0'..'9', 'a'..'f', 'A'..'F'];
var
    c1  :char;
    CommentLvl :integer;
    Src :PChar;
begin
    Src := Position;
    // read till next atom
    while True do
      begin
        case Src^ of
            #0:
                break;
            #1..#32  :// spaces and special characters
                Inc(Src);
            #$EF:
                if (Src[1] = #$BB) and (Src[2] = #$BF) then
                  begin
                    // skip UTF BOM
                    Inc(Src, 3);
                  end
                else
                    break;
            '/'    :// comment start or compiler directive
                if (Src[1] = '/') then
                  begin
                    // comment start -> read til line end
                    Inc(Src);
                    while not (Src^ in [#0, #10, #13]) do
                        Inc(Src);
                  end
                else if (Src[1] = '*') then
                    // compiler directive
                  begin
                    Inc(Src);
                    // CShcal comment => skip
                    CommentLvl := 1;
                    while True do
                      begin
                        Inc(Src);
                        case Src^ of
                            #0:
                                break;
                            '/':
                                if src[1] = '*' then
                                  begin
                                    Inc(src);
                                    if NestedComments then
                                        Inc(CommentLvl);
                                  end;
                            '*':
                                if src[1] = '/' then
                                  begin
                                    Inc(Src);
                                    Dec(CommentLvl);
                                    if CommentLvl = 0 then
                                      begin
                                        Inc(Src);
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
      end;
    // read token
    TokenStart := Src;
    c1 := Src^;
    case c1 of
        #0:
            ;
        'A'..'Z', 'a'..'z', '_' :begin
            // identifier
            Inc(Src);
            while Src^ in IdentChars do
                Inc(Src);
          end;
        '0'..'9' :// number
          begin
            Inc(Src);
            // read numbers
            while (Src^ in ['0'..'9']) do
                Inc(Src);
            if (Src^ = '.') and (Src[1] <> '.') then
              begin
                // real type number
                Inc(Src);
                while (Src^ in ['0'..'9']) do
                    Inc(Src);
              end;
            if (Src^ in ['e', 'E']) then
              begin
                // read exponent
                Inc(Src);
                if (Src^ = '-') then
                    Inc(Src);
                while (Src^ in ['0'..'9']) do
                    Inc(Src);
              end;
          end;
        '"', '#'  :// string constant
            while True do
                case Src^ of
                    #0:
                        break;
                    '#' :begin
                        Inc(Src);
                        while Src^ in ['0'..'9'] do
                            Inc(Src);
                      end;
                    '"' :begin
                        Inc(Src);
                        while not (Src^ in ['''', #0]) do
                            Inc(Src);
                        if Src^ = '''' then
                            Inc(Src);
                      end;
                    else
                        break;
                  end;
        '$'  :// hex constant
          begin
            Inc(Src);
            while Src^ in HexNumberChars do
                Inc(Src);
          end;
        '&'  :// octal constant or keyword as identifier (e.g. &label)
          begin
            Inc(Src);
            if Src^ in ['0'..'7'] then
                while Src^ in ['0'..'7'] do
                    Inc(Src)
            else
                while Src^ in IdentChars do
                    Inc(Src);
          end;
        '/'  :// compiler directive (it can't be a comment, because see above)
          begin
            CommentLvl := 1;
            while True do
              begin
                Inc(Src);
                case Src^ of
                    #0:
                        break;
                    '{':
                        if NestedComments then
                            Inc(CommentLvl);
                    '}' :begin
                        Dec(CommentLvl);
                        if CommentLvl = 0 then
                          begin
                            Inc(Src);
                            break;
                          end;
                      end;
                  end;
              end;
          end;
        '('  :// bracket or compiler directive
            if (Src[1] = '*') then
              begin
                // compiler directive -> read til comment end
                Inc(Src, 2);
                while (Src^ <> #0) and ((Src^ <> '*') or (Src[1] <> ')')) do
                    Inc(Src);
                Inc(Src, 2);
              end
            else
                // round bracket open
                Inc(Src);
        #192..#255 :begin
            // read UTF8 character
            Inc(Src);
            if ((Ord(c1) and %11100000) = %11000000) then
              begin
                // could be 2 byte character
                if (Ord(Src[0]) and %11000000) = %10000000 then
                    Inc(Src);
              end
            else if ((Ord(c1) and %11110000) = %11100000) then
              begin
                // could be 3 byte character
                if ((Ord(Src[0]) and %11000000) = %10000000) and
                    ((Ord(Src[1]) and %11000000) = %10000000) then
                    Inc(Src, 2);
              end
            else if ((Ord(c1) and %11111000) = %11110000) then
              begin
                // could be 4 byte character
                if ((Ord(Src[0]) and %11000000) = %10000000) and
                    ((Ord(Src[1]) and %11000000) = %10000000) and
                    ((Ord(Src[2]) and %11000000) = %10000000) then
                    Inc(Src, 3);
              end;
          end;
        else
            Inc(Src);
            case c1 of
                '<':
                    if Src^ in ['>', '='] then
                        Inc(Src);
                '.':
                    if Src^ = '.' then
                        Inc(Src);
                '@':
                    if Src^ = '@' then
                      begin
                        // @@ label
                        repeat
                            Inc(Src);
                        until not (Src^ in IdentChars);
                      end
                    else if (Src^ = '=') and (c1 in [':', '+', '-', '/', '*', '<', '>']) then
                        Inc(Src);
              end;
      end;
    Position := Src;
end;

{ TTestEngine }

destructor TTestEngine.Destroy;
begin
    FreeAndNil(FList);
    inherited Destroy;
end;

function TTestEngine.CreateElement(AClass :TCShTreeElement; const AName :string;
    AParent :TCShElement; AVisibility :TCShMemberVisibility;
    const ASourceFilename :string; ASourceLinenumber :integer) :TCShElement;
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
        Result.DocComment := CurrentParser.SavedComments;
      end;
    if AName <> '' then
      begin
        if not Assigned(FList) then
            FList := TFPList.Create;
        FList.Add(Result);
      end;
end;

function TTestEngine.FindElement(const AName :string) :TCShElement;

var
    I :integer;

begin
    Result := nil;
    if Assigned(FList) then
      begin
        I := FList.Count - 1;
        while (Result = nil) and (I >= 0) do
          begin
            if CompareText(TCShElement(FList[I]).Name, AName) = 0 then
                Result := TCShElement(FList[i]);
            Dec(i);
          end;
      end;
end;

procedure TTestParser.SetupParser;

begin
    FResolver := TStreamResolver.Create;
    FResolver.OwnsStreams := True;
    FScanner  := TCSharpScanner.Create(FResolver);
    CreateEngine(FEngine);
    FParser    := TTestCShParser.Create(FScanner, FResolver, FEngine);
    FSource    := TStringList.Create;
    FModule    := nil;
    FDeclarations := nil;
    FEndSource := False;
    FImplementation := False;
    FIsUnit    := False;
end;

procedure TTestParser.CleanupParser;

begin
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.CleanupParser START');
  {$ENDIF}
    if not Assigned(FModule) then
        FreeAndNil(FDeclarations)
    else
        FDeclarations := nil;
    FImplementation := False;
    FEndSource := False;
    FIsUnit    := False;
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
    FMainFilename := DefaultMainFilename;
    inherited;
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
    inherited;
  {$IFDEF VerboseCShResolverMem}
  writeln('TTestParser.TearDown END');
  {$ENDIF}
end;

procedure TTestParser.CreateEngine(var TheEngine :TCShTreeContainer);
begin
    TheEngine := TTestEngine.Create;
end;

procedure TTestParser.StartUnit(AUnitName :string);
begin
    FIsUnit := True;
    if (AUnitName = '') then
        AUnitName := ExtractFileUnitName(MainFilename);
    FFileName     := Format(rsCShFilename, [AUnitName]);
    FImplementation := True;
    add('using system;');
    add('namespace ' + AUnitName);
    add('{');
    FHasNamespace := True;
    add('class ' + AUnitName + 'Class');
    add('{');
end;

procedure TTestParser.StartProgram(AFileName :string);
begin
    FIsUnit := False;
    if (AFileName = '') then
        AFileName := 'aFile';
    FFileName     := Format(rsCShFilename, [AFileName]);
    FImplementation := True;
    add('using system;');
    FHasNamespace := False;
    add('class ' + ExtractFilenameOnly(AFileName));
    add('{');
end;

procedure TTestParser.UsingClause(Namespaces :array of string);

var
    I :integer;

begin
    for I := Low(Namespaces) to High(Namespaces) do
        Add(Format(rsUsingNamespace, [Namespaces[i]]));
    Add('');
end;

procedure TTestParser.StartImplementation;
begin
    if not FImplementation then
      begin
        FImplementation := True;
      end;
end;

procedure TTestParser.EndSource;
begin
    if not FEndSource then
      begin
        Add('}'); // Main
        Add('}'); // Class
        if FHasNamespace then
            Add('}'); // Namespace
        FEndSource := True;
      end;
end;

procedure TTestParser.Add(const ALine :string);
begin
    FSource.Add(ALine);
end;

procedure TTestParser.Add(const Lines :array of string);
var
    i :integer;
begin
    for i := Low(Lines) to High(Lines) do
        Add(Lines[i]);
end;

procedure TTestParser.StartParsing;
{$ifndef NOCONSOLE}
var
    i :integer;
{$endif}
begin
    if FIsUnit then
        StartImplementation;
    EndSource;
    if (FFileName = '') then
        FFileName := MainFilename;
    FResolver.AddStream(FFileName, TStringStream.Create(FSource.Text));
    FScanner.OpenFile(FFileName);
  {$ifndef NOCONSOLE}
    Writeln('// Test : ', Self.TestName);
    for i := 0 to FSource.Count - 1 do
        Writeln(Format('%:4d: ', [i + 1]), FSource[i]);
  {$endif}
end;

procedure TTestParser.ParseDeclarations;
begin
    if UseImplementation then
        StartImplementation;
    FSource.Insert(0, '{');
    FSource.Insert(0, 'class aClass');
    FHasNamespace := False;
    if not UseImplementation then
        StartImplementation;
    EndSource;
    ParseModule;
    FDeclarations := Module.ImplementationSection;
end;

procedure TTestParser.ParseModule;
begin
    StartParsing;
    FParser.ParseMain(FModule);
    AssertNotNull('Module resulted in Module', FModule);
    AssertEquals('modulename', ChangeFileExt(FFileName, ''), Module.Name);
end;

procedure TTestParser.ParseStatements;
var
    lNewImplElement :TCShImplElement;
begin
    FreeAndNil(FTestBlock);
    FFileName := Format(rsCShFilename, ['aTest']);
    FResolver.AddStream(FFileName, TStringStream.Create(FSource.Text));
    FScanner.OpenFile(FFileName);
    FTestBlock := TCShImplBlock.Create('Main', nil);
    FParser.NextToken;
    while FParser.CurToken <> tkCurlyBraceClose do
      begin
        if not (FParser.CurToken in [tkSemicolon]) then
          begin
            FParser.UngetToken;
            FParser.ParseStatement(FTestBlock, lNewImplElement);
            if lNewImplElement = nil then
                break;
          end;
        FParser.NextToken;
      end;
    AssertNotNull('Module resulted in Module', FTestBlock);
end;

procedure TTestParser.CheckHint(AHint :TCShMemberHint);
begin
    HaveHint(AHint, Definition.Hints);
end;

function TTestParser.AssertExpression(const Msg :string; AExpr :TCShExpr;
    aKind :TCShExprKind; AClass :TClass) :TCShExpr;
begin
    AssertNotNull(AExpr);
    AssertEquals(Msg + ': Correct expression kind', aKind, AExpr.Kind);
    AssertEquals(Msg + ': Correct expression class', AClass, AExpr.ClassType);
    Result := AExpr;
end;

function TTestParser.AssertExpression(const Msg :string; AExpr :TCShExpr;
    aKind :TCShExprKind; AValue :string) :TPrimitiveExpr;
begin
    Result := AssertExpression(Msg, AExpr, aKind, TPrimitiveExpr) as TPrimitiveExpr;
    AssertEquals(Msg + ': Primitive expression value', AValue, TPrimitiveExpr(AExpr).Value);
end;

function TTestParser.AssertExpression(const Msg :string; AExpr :TCShExpr;
    AValue :string) :TParamsExpr;
begin
    Result := AssertExpression(Msg, AExpr, pekFuncParams, TParamsExpr) as TParamsExpr;
    if assigned(TParamsExpr(AExpr).Value) then
        AssertEquals(Msg + ': Funktion Params', AValue, TParamsExpr(
            AExpr).Value.GetDeclaration(True));
end;

function TTestParser.AssertExpression(const Msg :string; AExpr :TCShExpr;
    OpCode :TExprOpCode) :TBinaryExpr;
begin
    Result := AssertExpression(Msg, AExpr, pekBinary, TBinaryExpr) as TBinaryExpr;
    AssertEquals(Msg + ': Binary opcode', OpCode, TBinaryExpr(AExpr).OpCode);
end;

procedure TTestParser.AssertExportSymbol(const Msg :string; AIndex :integer;
    AName, AExportName :string; AExportIndex :integer);

var
    E :TCShExportSymbol;

begin
    if (AExportName = '') then
        AssertNull(Msg + 'No export name', E.ExportName)
    else
      begin
        AssertNotNull(Msg + 'Export name symbol', E.ExportName);
        AssertEquals(Msg + 'TPrimitiveExpr', TPrimitiveExpr, E.ExportName.CLassType);
        AssertEquals(Msg + 'Correct export symbol export name ', '''' + AExportName +
            '''', TPrimitiveExpr(E.ExportName).Value);
      end;
    if AExportIndex = -1 then
        AssertNull(Msg + 'No export name', E.ExportIndex)
    else
      begin
        AssertNotNull(Msg + 'Export name symbol', E.ExportIndex);
        AssertEquals(Msg + 'TPrimitiveExpr', TPrimitiveExpr, E.ExportIndex.CLassType);
        AssertEquals(Msg + 'Correct export symbol export index', IntToStr(
            AExportindex), TPrimitiveExpr(E.ExportIndex).Value);
      end;
end;

procedure TTestParser.AssertEquals(const Msg :string; AExpected, AActual :TCShExprKind);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TCShExprKind), Ord(AExpected)),
        GetEnumName(TypeInfo(TCShExprKind), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string; AExpected, AActual :TCShObjKind);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TCShObjKind), Ord(AExpected)),
        GetEnumName(TypeInfo(TCShObjKind), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string; AExpected, AActual :TExprOpCode);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TexprOpcode), Ord(AExpected)),
        GetEnumName(TypeInfo(TexprOpcode), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TCShMemberHint);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TCShMemberHint), Ord(AExpected)),
        GetEnumName(TypeInfo(TCShMemberHint), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TCallingConvention);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TCallingConvention), Ord(AExpected)),
        GetEnumName(TypeInfo(TCallingConvention), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TArgumentAccess);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TArgumentAccess), Ord(AExpected)),
        GetEnumName(TypeInfo(TArgumentAccess), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TVariableModifier);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TVariableModifier), Ord(AExpected)),
        GetEnumName(TypeInfo(TVariableModifier), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TVariableModifiers);

    function sn(S :TVariableModifiers) :string;

    var
        M :TVariableModifier;

    begin
        Result := '';
        for M := Low(TVariableModifier) to High(TVariableModifier) do
            if M in S then
              begin
                if (Result <> '') then
                    Result := Result + ',';
              end;
        Result := '[' + Result + ']';
    end;

begin
    AssertEquals(Msg, Sn(AExpected), Sn(AActual));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TCShMemberVisibility);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TCShMemberVisibility), Ord(AExpected)),
        GetEnumName(TypeInfo(TCShMemberVisibility), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TProcedureModifier);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TProcedureModifier), Ord(AExpected)),
        GetEnumName(TypeInfo(TProcedureModifier), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TProcedureModifiers);

    function Sn(S :TProcedureModifiers) :string;

    var
        m :TProcedureModifier;
    begin
        Result := '';
        for M := Low(TProcedureModifier) to High(TProcedureModifier) do
            if (m in S) then
              begin
                if (Result <> '') then
                    Result := Result + ',';
                Result     := Result + GetEnumName(TypeInfo(TProcedureModifier), Ord(m));
              end;
    end;

begin
    AssertEquals(Msg, Sn(AExpected), SN(AActual));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TProcTypeModifiers);

    function Sn(S :TProcTypeModifiers) :string;

    var
        m :TProcTypeModifier;
    begin
        Result := '';
        for M := Low(TProcTypeModifier) to High(TProcTypeModifier) do
            if (m in S) then
              begin
                if (Result <> '') then
                    Result := Result + ',';
                Result     := Result + GetEnumName(TypeInfo(TProcTypeModifier), Ord(m));
              end;
    end;

begin
    AssertEquals(Msg, Sn(AExpected), SN(AActual));
end;

procedure TTestParser.AssertEquals(const Msg :string; AExpected, AActual :TAssignKind);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TAssignKind), Ord(AExpected)),
        GetEnumName(TypeInfo(TAssignKind), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TProcedureMessageType);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TProcedureMessageType), Ord(AExpected)),
        GetEnumName(TypeInfo(TProcedureMessageType), Ord(AActual)));
end;

procedure TTestParser.AssertEquals(const Msg :string;
    AExpected, AActual :TOperatorType);
begin
    AssertEquals(Msg, GetEnumName(TypeInfo(TOperatorType), Ord(AExpected)),
        GetEnumName(TypeInfo(TOperatorType), Ord(AActual)));
end;

procedure TTestParser.AssertSame(const Msg :string; AExpected, AActual :TCShElement);
begin
    if AExpected = AActual then
        exit;
    AssertEquals(Msg, GetCShElementDesc(AExpected), GetCShElementDesc(AActual));
end;

procedure TTestParser.HaveHint(AHint :TCShMemberHint; AHints :TCShMemberHints);
begin
    if not (AHint in AHints) then
        Fail(GetEnumName(TypeInfo(TCShMemberHint), Ord(AHint)) + 'hint expected.');
end;

end.
