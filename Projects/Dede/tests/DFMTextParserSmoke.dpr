program DFMTextParserSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeDFMModel, DeDeDFMTextParser;

function FindChild(AObject: TDFMObject; const AName: string): TDFMObject;
var
  I: Integer;
  Child: TDFMObject;
begin
  Result := nil;
  for I := 0 to AObject.Children.Count - 1 do
  begin
    Child := TDFMObject(AObject.Children[I]);
    if SameText(Child.ObjectName, AName) then
      Exit(Child);
    Result := FindChild(Child, AName);
    if Result <> nil then
      Exit;
  end;
end;

function FindProperty(AObject: TDFMObject;
  const AName: string): TDFMProperty;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to AObject.Properties.Count - 1 do
    if SameText(TDFMProperty(AObject.Properties[I]).Name, AName) then
      Exit(TDFMProperty(AObject.Properties[I]));
end;

var
  Lines: TStringList;
  Root, ControlsNode, GridNode, ColumnsNode, ItemNode: TDFMObject;
  PropertyItem: TDFMProperty;
  I, PropertyIndex: Integer;
  FoundCaption, FoundFieldName: Boolean;
begin
  if ParamCount = 0 then
    raise EArgumentException.Create('Pass one or more text DFM paths');

  Lines := TStringList.Create;
  try
    for I := 1 to ParamCount do
    begin
      Lines.LoadFromFile(ParamStr(I));
      Root := ParseDFMText(Lines);
      try
        if (Root.ObjectName = 'TreeViewForm') then
        begin
          if (Root.ClassName <> 'TTreeViewForm') or (Root.Children.Count = 0) then
            raise Exception.Create('TreeView DFM root or children were not parsed');
          ControlsNode := FindChild(Root, 'ControlsTV');
          if (ControlsNode = nil) or (ControlsNode.ClassName <> 'TTreeView') then
            raise Exception.Create('Nested tree control was not parsed');

          FoundCaption := False;
          for PropertyIndex := 0 to Root.Properties.Count - 1 do
            if TDFMProperty(Root.Properties[PropertyIndex]).Name = 'Caption' then
            begin
              FoundCaption :=
                TDFMProperty(Root.Properties[PropertyIndex]).Value = '''DFM Inspector''';
              Break;
            end;
          if not FoundCaption then
            raise Exception.Create('Root caption property was not parsed');
        end;
        if SameText(ExtractFileName(ParamStr(I)), 'EditPropForm.dfm') then
        begin
          GridNode := FindChild(Root, 'DBGrid1');
          if GridNode = nil then
            raise Exception.Create('EditProp grid was not parsed');
          ColumnsNode := FindChild(GridNode, 'Columns');
          if (ColumnsNode = nil) or
             (ColumnsNode.ClassName <> 'TDFMCollection') or
             (ColumnsNode.Children.Count = 0) then
            raise Exception.Create('DBGrid column collection was not parsed');
          ItemNode := TDFMObject(ColumnsNode.Children[0]);
          if ItemNode.ClassName <> 'TDFMCollectionItem' then
            raise Exception.Create('DBGrid collection item was not parsed');
          FoundFieldName := (FindProperty(ItemNode, 'FieldName') <> nil) and
            (FindProperty(ItemNode, 'FieldName').Value = '''sType''');
          if not FoundFieldName then
            raise Exception.Create('DBGrid collection item property was lost');
        end;
      finally
        Root.Free;
        Lines.Clear;
      end;
    end;

    Lines.Text :=
      'object Root: TForm' + sLineBreak +
      '  EmptyItems = <>' + sLineBreak +
      '  Lines.Strings = (' + sLineBreak +
      '    ''first''' + sLineBreak +
      '    ''value with ) and (''' + sLineBreak +
      '    ''last'')' + sLineBreak +
      '  Picture.Data = {' + sLineBreak +
      '    0102' + sLineBreak +
      '    03}' + sLineBreak +
      '  Columns = <' + sLineBreak +
      '    item' + sLineBreak +
      '      FieldName = ''Outer''' + sLineBreak +
      '      Nested = <' + sLineBreak +
      '        item' + sLineBreak +
      '          Value = 1' + sLineBreak +
      '        end>' + sLineBreak +
      '    end' + sLineBreak +
      '  >' + sLineBreak +
      'end';
    Root := ParseDFMText(Lines);
    try
      ColumnsNode := FindChild(Root, 'Columns');
      if (ColumnsNode = nil) or
         (ColumnsNode.ClassName <> 'TDFMCollection') or
         (ColumnsNode.Children.Count <> 1) then
        raise Exception.Create('Nested collection structure was not parsed');
      ItemNode := TDFMObject(ColumnsNode.Children[0]);
      ColumnsNode := FindChild(ItemNode, 'Nested');
      if (ColumnsNode = nil) or
         (ColumnsNode.ClassName <> 'TDFMCollection') or
         (ColumnsNode.Children.Count <> 1) then
        raise Exception.Create('Nested collection item was not parsed');
      ItemNode := TDFMObject(ColumnsNode.Children[0]);
      if (FindProperty(ItemNode, 'Value') = nil) or
         (FindProperty(ItemNode, 'Value').Value <> '1') then
        raise Exception.Create('Nested collection property was lost');
      ColumnsNode := FindChild(Root, 'EmptyItems');
      if (ColumnsNode = nil) or
         (ColumnsNode.ClassName <> 'TDFMCollection') or
         (ColumnsNode.Children.Count <> 0) then
        raise Exception.Create('Empty collection was not parsed');
      PropertyItem := FindProperty(Root, 'Lines.Strings');
      if (PropertyItem = nil) or (PropertyItem.ValueType <> 1) or
         (Pos('value with ) and (', PropertyItem.Value) = 0) then
        raise Exception.Create('Multiline string list was not preserved');
      PropertyItem := FindProperty(Root, 'Picture.Data');
      if (PropertyItem = nil) or (PropertyItem.ValueType <> 10) or
         (Pos('03}', PropertyItem.Value) = 0) then
        raise Exception.Create('Multiline binary data was not preserved');
    finally
      Root.Free;
      Lines.Clear;
    end;
    WriteLn(ParamCount, ' DFM files and nested collection fixture passed');
  finally
    Lines.Free;
  end;
end.
