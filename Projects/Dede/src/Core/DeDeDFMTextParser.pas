unit DeDeDFMTextParser;

interface

uses
  Classes, DeDeDFMModel;

function ParseDFMText(Lines: TStrings): TDFMObject;

implementation

uses
  SysUtils;

type
  TDFMParseFrameKind = (pfObject, pfCollection, pfCollectionItem);

  TDFMParseFrame = class
    Node: TDFMObject;
    Kind: TDFMParseFrameKind;
    ItemCount: Integer;
  end;

function DetectValueType(const Value: string): Byte;
var
  S: string;
  NumericValue: Integer;
begin
  S := Trim(Value);
  if SameText(S, 'true') or SameText(S, 'false') then
    Exit(8);
  if (Length(S) >= 2) and (S[1] = '[') and (S[Length(S)] = ']') then
    Exit(11);
  if (Length(S) >= 2) and (S[1] = '(') and (S[Length(S)] = ')') then
    Exit(1);
  if (S <> '') and (S[1] = '{') then
    Exit(10);
  if (S <> '') and (S[1] = '''') then
    Exit(12);
  if TryStrToInt(S, NumericValue) then
    Exit(4);
  Result := 7;
end;

function ParseDFMText(Lines: TStrings): TDFMObject;
var
  Stack: TList;
  RootObject, CurrentObject, ParentObject, ChildObject: TDFMObject;
  Frame, ParentFrame: TDFMParseFrame;
  LineText, ObjectText, ObjectName, ObjectClass, PropertyName,
    PropertyValue, Directive: string;
  Separator, I, LineNumber, SpaceIndex, PropertyStartLine,
    DelimiterDepth: Integer;
  OpenDelimiter, CloseDelimiter: Char;
  InQuotedString: Boolean;

  procedure UpdateDelimiterState(const Text: string; OpenChar, CloseChar: Char;
    var Depth: Integer; var InQuoted: Boolean);
  var
    Position: Integer;
  begin
    Position := 1;
    while Position <= Length(Text) do
    begin
      if InQuoted then
      begin
        if Text[Position] = '''' then
        begin
          if (Position < Length(Text)) and
             (Text[Position + 1] = '''') then
            Inc(Position, 2)
          else
          begin
            InQuoted := False;
            Inc(Position);
          end;
        end
        else
          Inc(Position);
      end
      else if Text[Position] = '''' then
      begin
        InQuoted := True;
        Inc(Position);
      end
      else if Text[Position] = OpenChar then
      begin
        Inc(Depth);
        Inc(Position);
      end
      else if Text[Position] = CloseChar then
      begin
        Dec(Depth);
        Inc(Position);
      end
      else
        Inc(Position);
    end;
  end;

  function ActiveFrame: TDFMParseFrame;
  begin
    if Stack.Count = 0 then
      Exit(nil);
    Result := TDFMParseFrame(Stack[Stack.Count - 1]);
  end;

  procedure PushFrame(ANode: TDFMObject; AKind: TDFMParseFrameKind);
  begin
    Frame := TDFMParseFrame.Create;
    Frame.Node := ANode;
    Frame.Kind := AKind;
    Frame.ItemCount := 0;
    Stack.Add(Frame);
  end;

  procedure PopFrame;
  begin
    TDFMParseFrame(Stack[Stack.Count - 1]).Free;
    Stack.Delete(Stack.Count - 1);
  end;
begin
  if Lines = nil then
    raise EArgumentNilException.Create('Lines');

  Result := nil;
  RootObject := nil;
  Stack := TList.Create;
  try
    I := 0;
    while I < Lines.Count do
    begin
      LineNumber := I + 1;
      LineText := Trim(Lines[I]);
      Inc(I);
      if LineText = '' then
        Continue;

      if SameText(LineText, 'end>') then
      begin
        Frame := ActiveFrame;
        if (Frame <> nil) and (Frame.Kind = pfCollectionItem) then
          PopFrame;
        Frame := ActiveFrame;
        if (Frame = nil) or (Frame.Kind <> pfCollection) then
          raise EConvertError.CreateFmt(
            'Unexpected DFM collection end at line %d', [LineNumber]);
        PopFrame;
        Continue;
      end;

      if SameText(LineText, '>') then
      begin
        Frame := ActiveFrame;
        if (Frame = nil) or (Frame.Kind <> pfCollection) then
          raise EConvertError.CreateFmt(
            'Unexpected DFM collection close at line %d', [LineNumber]);
        PopFrame;
        Continue;
      end;

      SpaceIndex := Pos(' ', LineText);
      if SpaceIndex > 0 then
        Directive := LowerCase(Copy(LineText, 1, SpaceIndex - 1))
      else
        Directive := LowerCase(LineText);

      if (Directive = 'object') or (Directive = 'inherited') or
         (Directive = 'inline') then
      begin
        ObjectText := Trim(Copy(LineText, SpaceIndex + 1, MaxInt));
        Separator := Pos(':', ObjectText);
        if SpaceIndex = 0 then
          raise EConvertError.CreateFmt('Malformed DFM object at line %d', [LineNumber]);
        if Separator = 0 then
        begin
          ObjectName := '';
          ObjectClass := ObjectText;
        end
        else
        begin
          if Separator < 2 then
            raise EConvertError.CreateFmt('Malformed DFM object at line %d', [LineNumber]);
          ObjectName := Trim(Copy(ObjectText, 1, Separator - 1));
          ObjectClass := Trim(Copy(ObjectText, Separator + 1, MaxInt));
        end;
        if ObjectClass = '' then
          raise EConvertError.CreateFmt('Malformed DFM object at line %d', [LineNumber]);

        if Stack.Count = 0 then
        begin
          if RootObject <> nil then
            raise EConvertError.CreateFmt('Multiple DFM roots at line %d', [LineNumber]);
          ChildObject := TDFMObject.Create;
          ChildObject.ObjectName := ObjectName;
          ChildObject.ClassName := ObjectClass;
          RootObject := ChildObject;
        end
        else
        begin
          ParentFrame := ActiveFrame;
          ParentObject := ParentFrame.Node;
          ChildObject := ParentObject.AddChild(ObjectName, ObjectClass);
        end;
        PushFrame(ChildObject, pfObject);
        Continue;
      end;

      if Directive = 'item' then
      begin
        ParentFrame := ActiveFrame;
        if (ParentFrame = nil) or
           (ParentFrame.Kind <> pfCollection) then
          raise EConvertError.CreateFmt(
            'DFM collection item outside a collection at line %d', [LineNumber]);
        ObjectName := 'item' + IntToStr(ParentFrame.ItemCount);
        Inc(ParentFrame.ItemCount);
        ChildObject := ParentFrame.Node.AddChild(ObjectName,
          'TDFMCollectionItem');
        PushFrame(ChildObject, pfCollectionItem);
        Continue;
      end;

      if SameText(LineText, 'end') then
      begin
        Frame := ActiveFrame;
        if (Frame = nil) or (Frame.Kind = pfCollection) then
          raise EConvertError.CreateFmt('Unexpected DFM end at line %d', [LineNumber]);
        PopFrame;
        Continue;
      end;

      if Stack.Count = 0 then
        Continue;
      Separator := Pos('=', LineText);
      if Separator <= 1 then
        Continue;

      PropertyName := Trim(Copy(LineText, 1, Separator - 1));
      PropertyValue := Trim(Copy(LineText, Separator + 1, MaxInt));
      PropertyStartLine := LineNumber;
      if PropertyName = '' then
        Continue;

      Frame := ActiveFrame;
      if (Frame = nil) or (Frame.Kind = pfCollection) then
        raise EConvertError.CreateFmt(
          'DFM property outside an object or collection item at line %d',
          [LineNumber]);
      CurrentObject := Frame.Node;
      if PropertyValue = '<' then
      begin
        ChildObject := CurrentObject.AddChild(PropertyName, 'TDFMCollection');
        PushFrame(ChildObject, pfCollection);
        Continue;
      end;
      if (Length(PropertyValue) >= 2) and (PropertyValue[1] = '<') and
         (PropertyValue[Length(PropertyValue)] = '>') then
      begin
        if Trim(Copy(PropertyValue, 2, Length(PropertyValue) - 2)) <> '' then
          raise EConvertError.CreateFmt(
            'Inline DFM collections are not supported at line %d', [LineNumber]);
        CurrentObject.AddChild(PropertyName, 'TDFMCollection');
        Continue;
      end;
      if (PropertyValue <> '') and
         ((PropertyValue[1] = '(') or (PropertyValue[1] = '{')) then
      begin
        OpenDelimiter := PropertyValue[1];
        if OpenDelimiter = '(' then
          CloseDelimiter := ')'
        else
          CloseDelimiter := '}';
        DelimiterDepth := 0;
        InQuotedString := False;
        UpdateDelimiterState(PropertyValue, OpenDelimiter, CloseDelimiter,
          DelimiterDepth, InQuotedString);
        while DelimiterDepth > 0 do
        begin
          if I >= Lines.Count then
            raise EConvertError.CreateFmt(
              'Unclosed multiline DFM value at line %d', [PropertyStartLine]);
          LineText := Trim(Lines[I]);
          Inc(I);
          PropertyValue := PropertyValue + sLineBreak + LineText;
          UpdateDelimiterState(LineText, OpenDelimiter, CloseDelimiter,
            DelimiterDepth, InQuotedString);
          if DelimiterDepth < 0 then
            raise EConvertError.CreateFmt(
              'Malformed multiline DFM value at line %d', [I]);
        end;
      end;
      CurrentObject.AddProperty(PropertyName, PropertyValue,
        DetectValueType(PropertyValue));
    end;

    if Stack.Count <> 0 then
    begin
      Frame := ActiveFrame;
      if (Frame.Kind = pfCollection) or (Frame.Kind = pfCollectionItem) then
        raise EConvertError.Create('Unclosed DFM collection');
      raise EConvertError.Create('Unclosed DFM object');
    end;
    if RootObject = nil then
      raise EConvertError.Create('DFM text has no root object');
    Result := RootObject;
    RootObject := nil;
  finally
    while Stack.Count > 0 do
      PopFrame;
    Stack.Free;
    RootObject.Free;
  end;
end;

end.
