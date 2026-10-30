program ParserWarningsSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeConstants, DeDePFiles;

procedure Require(Value: Boolean; const MessageText: string);
begin
  if not Value then
    raise Exception.Create(MessageText);
end;

type
  TParserSmoke = class
  public
    CallCount: Integer;
    LastBuffer: TSymBuffer;
    LastAdd: Boolean;
    procedure OnNewProcedure(ProcDecl: string; Buffer: TSymBuffer;
      Size: Integer; Progress: Byte; Add: Boolean);
  end;

procedure TParserSmoke.OnNewProcedure(ProcDecl: string; Buffer: TSymBuffer;
  Size: Integer; Progress: Byte; Add: Boolean);
begin
  Inc(CallCount);
  LastBuffer := Buffer;
  LastAdd := Add;
end;

var
  Parser: TNewDCU2DSFParser;
  ParserSmoke: TParserSmoke;
  Lines: TStringList;
  ClassParser: TClassParser;
  Defs: array[0..2] of TStringList;
  ClassText, ClassName: string;
  i, j: Integer;
begin
  ParserSmoke := TParserSmoke.Create;
  Lines := TStringList.Create;
  for i := Low(Defs) to High(Defs) do
    Defs[i] := TStringList.Create;
  try
    Lines.Add('procedure Malformed;');
    Lines.Add('end;');
    Parser.InitParse(Lines, ParserSmoke.OnNewProcedure);
    Parser.ParseIt;
    Require(ParserSmoke.CallCount = 0,
      'A procedure end without a begin was emitted');

    Lines.Clear;
    Lines.Add('procedure EmptyPattern;');
    Lines.Add('begin');
    Lines.Add('end;');
    Parser.InitParse(Lines, ParserSmoke.OnNewProcedure);
    Parser.ParseIt;
    Require(ParserSmoke.CallCount = 1,
      'A valid empty procedure pattern was not emitted');
    Require(not ParserSmoke.LastAdd,
      'An empty procedure pattern was marked for insertion');
    for i := Low(ParserSmoke.LastBuffer) to High(ParserSmoke.LastBuffer) do
      Require(ParserSmoke.LastBuffer[i] = 0,
        'An empty procedure pattern contains uninitialized bytes');

    Lines.Clear;
    Lines.Add('procedure FullPattern;');
    Lines.Add('begin');
    for i := 0 to (_PatternSize div 10) - 1 do
    begin
      ClassText := StringOfChar('X', 40);
      for j := 0 to 9 do
      begin
        ClassText[12 + j * 3] := '0';
        ClassText[13 + j * 3] := '1';
      end;
      Lines.Add(ClassText);
    end;
    Lines.Add('end;');
    Parser.InitParse(Lines, ParserSmoke.OnNewProcedure);
    Parser.ParseIt;
    Require(ParserSmoke.CallCount = 2,
      'A full-size procedure pattern was not emitted');
    Require(ParserSmoke.LastAdd,
      'A full-size procedure pattern was not marked for insertion');
    for i := Low(ParserSmoke.LastBuffer) to High(ParserSmoke.LastBuffer) do
      Require(ParserSmoke.LastBuffer[i] = 1,
        'A full-size procedure pattern was changed');

    ClassText := 'TParserSmokeClass = class(TObject)' + sLineBreak +
      'end;';
    Require(ClassParser.ParseClass(ClassText, Defs, ClassName),
      'A valid class declaration reported failure');
    Require(ClassName = 'TParserSmokeClass',
      'The parsed class name changed');

    ClassText := 'not a declaration';
    Require(not ClassParser.ParseClass(ClassText, Defs, ClassName),
      'An invalid class declaration reported success');
    WriteLn('Parser warning smoke test passed');
  finally
    for i := Low(Defs) to High(Defs) do
      Defs[i].Free;
    Lines.Free;
    ParserSmoke.Free;
  end;
end.
