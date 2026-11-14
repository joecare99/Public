unit EditPropUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, RxMemDS, DB, DBGrids, DBCtrls, Menus,
  DeDeDFMModel;

type
  TEditPropForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    PropNameLbl: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    TypeCB: TComboBox;
    ValueNotebook: TNotebook;
    ValueMemo: TMemo;
    SG: TStringGrid;
    RxMemoryData: TRxMemoryData;
    MemoryDataSource: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    ValueMemoPopUp: TPopupMenu;
    Pastbinarydatafromclipboard1: TMenuItem;
    Paste1: TMenuItem;
    Loadbinarydatafromfile1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    SelectAll1: TMenuItem;
    Copy1: TMenuItem;
    N3: TMenuItem;
    Copytextdatatoclipboard1: TMenuItem;
    Savebinarydatatofile1: TMenuItem;
    procedure BitBtn1Click(Sender: TObject);
    procedure SGKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SGSelectCell(Sender: TObject; ACol, ARow: Longint;
      var CanSelect: Boolean);
    procedure SGSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: string);
    procedure SGClick(Sender: TObject);
    procedure DBGrid1EditButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    function ValidateAndStore: Boolean;
  public
    CurrentProperty: TDFMProperty;
    SelectedRow: Longint;
    UpdatingGrid: Boolean;
    procedure EditProperty(AProperty: TDFMProperty);
  private
    procedure ResetValueTable;
    procedure AddValueRow(ValueType: Integer; const Name, Value: string;
      Subitem: Integer);
    procedure LoadValueList(const Encoded: string);
    procedure LoadValuePairs(const Encoded: string);
    procedure MapValueTypeNames;
  end;

var
  EditPropForm: TEditPropForm;

implementation

{$R *.dfm}

procedure TEditPropForm.EditProperty(AProperty: TDFMProperty);
var
  ValueText: string;
  StartAt, Separator: Integer;
  Row: Integer;
begin
  if AProperty = nil then
    raise EArgumentNilException.Create('AProperty');

  CurrentProperty := AProperty;
  PropNameLbl.Caption := AProperty.Name;
  TypeCB.ItemIndex := AProperty.ValueType;
  ValueText := AProperty.Value;
  ValueMemo.Lines.Text := ValueText;
  ValueMemo.PopupMenu := nil;
  ValueNotebook.ActivePage := 'Default';
  UpdatingGrid := True;
  try
    case AProperty.ValueType of
      1:
        begin
          ResetValueTable;
          LoadValueList(ValueText);
          MapValueTypeNames;
          ValueNotebook.ActivePage := 'ValueList';
        end;
      10:
        ValueMemo.PopupMenu := ValueMemoPopUp;
      11:
        begin
          ValueNotebook.ActivePage := 'StringList';
          ValueText := Trim(ValueText);
          if (Length(ValueText) >= 2) and (ValueText[1] = '[') and
             (ValueText[Length(ValueText)] = ']') then
            ValueText := Copy(ValueText, 2, Length(ValueText) - 2);

          SG.RowCount := 1;
          for Row := 0 to SG.RowCount - 1 do
            SG.Cells[0, Row] := '';
          StartAt := 1;
          while StartAt <= Length(ValueText) do
          begin
            Separator := Pos(',', Copy(ValueText, StartAt, MaxInt));
            if Separator = 0 then
            begin
              SG.Cells[0, SG.RowCount - 1] :=
                Trim(Copy(ValueText, StartAt, MaxInt));
              Break;
            end;
            SG.Cells[0, SG.RowCount - 1] :=
              Trim(Copy(ValueText, StartAt, Separator - 1));
            SG.RowCount := SG.RowCount + 1;
            Inc(StartAt, Separator);
          end;
          SG.RowCount := SG.RowCount + 1;
          SG.Cells[0, SG.RowCount - 1] := '';
        end;
      14:
        begin
          ResetValueTable;
          LoadValuePairs(ValueText);
          MapValueTypeNames;
          ValueNotebook.ActivePage := 'ValuePairs';
        end;
    end;
  finally
    UpdatingGrid := False;
  end;
end;

function DecodeDFMString(const Encoded: string): string;
var
  Bytes: AnsiString;
  I, Code: Integer;
begin
  Bytes := '';
  I := 1;
  while I <= Length(Encoded) do
  begin
    if Encoded[I] = '#' then
    begin
      if I + 2 > Length(Encoded) then
        raise EConvertError.Create('Incomplete DFM character escape');
      if not TryStrToInt('$' + Copy(Encoded, I + 1, 2), Code) then
        raise EConvertError.Create('Invalid DFM character escape');
      Bytes := Bytes + AnsiChar(Byte(Code));
      Inc(I, 3);
    end
    else
    begin
      Bytes := Bytes + AnsiString(Encoded[I]);
      Inc(I);
    end;
  end;
  Result := string(Bytes);
end;

function ValueTypeName(ValueType: Integer): string;
begin
  case ValueType of
    2: Result := 'Byte';
    3: Result := 'Word';
    4: Result := 'Double Word';
    6: Result := 'Short String';
    7: Result := 'Custom Type';
    8, 9: Result := 'Boolean';
    10: Result := 'Binary Data';
    11: Result := 'Set of Items';
    12: Result := 'String';
  else
    Result := 'unsuported!';
  end;
end;

procedure TEditPropForm.ResetValueTable;
begin
  RxMemoryData.Close;
  RxMemoryData.FieldDefs.Clear;
  RxMemoryData.FieldDefs.Add('sType', ftWideString, 15);
  RxMemoryData.FieldDefs.Add('btType', ftInteger);
  RxMemoryData.FieldDefs.Add('Name', ftWideString, 256);
  RxMemoryData.FieldDefs.Add('Value', ftWideString, 256);
  RxMemoryData.FieldDefs.Add('Subitem', ftSmallint);
  RxMemoryData.Open;
  RxMemoryData.Fields[0].DisplayLabel := 'Type';
  RxMemoryData.Fields[2].DisplayLabel := 'Name';
  RxMemoryData.Fields[3].DisplayLabel := 'Value';
  RxMemoryData.Fields[4].DisplayLabel := 'Subitem';
end;

procedure TEditPropForm.AddValueRow(ValueType: Integer; const Name,
  Value: string; Subitem: Integer);
begin
  RxMemoryData.Append;
  RxMemoryData.FieldByName('btType').AsInteger := ValueType;
  RxMemoryData.FieldByName('Name').AsString := Name;
  RxMemoryData.FieldByName('Value').AsString := Value;
  RxMemoryData.FieldByName('Subitem').AsInteger := Subitem;
  RxMemoryData.Post;
end;

procedure TEditPropForm.LoadValueList(const Encoded: string);
var
  Remaining, Entry, TypeText, EncodedValue: string;
  Separator, Comma, ValueType: Integer;
begin
  Remaining := Trim(Encoded);
  if (Length(Remaining) >= 2) and (Remaining[1] = '(') and
     (Remaining[Length(Remaining)] = ')') then
    Remaining := Copy(Remaining, 2, Length(Remaining) - 2);
  Remaining := Remaining + ';';

  while Remaining <> '' do
  begin
    Separator := Pos(';', Remaining);
    if Separator = 0 then
      Break;
    Entry := Copy(Remaining, 1, Separator - 1);
    Delete(Remaining, 1, Separator);
    Comma := Pos(',', Entry);
    if Comma = 0 then
      Continue;
    TypeText := Copy(Entry, 1, Comma - 1);
    EncodedValue := Copy(Entry, Comma + 1, MaxInt);
    if not TryStrToInt('$' + TypeText, ValueType) then
      raise EConvertError.CreateFmt('Invalid DFM value-list type: %s', [TypeText]);
    AddValueRow(ValueType, '', DecodeDFMString(EncodedValue), 0);
  end;
end;

procedure TEditPropForm.LoadValuePairs(const Encoded: string);
var
  Remaining, Group, Entry, NameText, EncodedValue, TypeText: string;
  Separator, EqualsAt, Comma, GroupIndex, ValueType: Integer;
begin
  Remaining := Trim(Encoded);
  if (Length(Remaining) >= 2) and (Remaining[1] = '(') and
     (Remaining[Length(Remaining)] = ')') then
    Remaining := Copy(Remaining, 2, Length(Remaining) - 2);
  Remaining := Remaining + '|';
  GroupIndex := 0;

  while Remaining <> '' do
  begin
    Separator := Pos('|', Remaining);
    if Separator = 0 then
      Break;
    Group := Copy(Remaining, 1, Separator - 1);
    Delete(Remaining, 1, Separator);
    Group := Group + ';';

    while Group <> '' do
    begin
      Separator := Pos(';', Group);
      if Separator = 0 then
        Break;
      Entry := Copy(Group, 1, Separator - 1);
      Delete(Group, 1, Separator);
      EqualsAt := Pos('=', Entry);
      if EqualsAt = 0 then
        Continue;
      NameText := Copy(Entry, 1, EqualsAt - 1);
      EncodedValue := Copy(Entry, EqualsAt + 1, MaxInt);
      Comma := Pos(',', EncodedValue);
      if Comma = 0 then
        Continue;
      TypeText := Copy(EncodedValue, 1, Comma - 1);
      EncodedValue := Copy(EncodedValue, Comma + 1, MaxInt);
      if not TryStrToInt('$' + TypeText, ValueType) then
        raise EConvertError.CreateFmt('Invalid DFM name/value type: %s', [TypeText]);
      AddValueRow(ValueType, DecodeDFMString(NameText),
        DecodeDFMString(EncodedValue), GroupIndex);
    end;
    Inc(GroupIndex);
  end;
end;

procedure TEditPropForm.MapValueTypeNames;
begin
  RxMemoryData.First;
  while not RxMemoryData.Eof do
  begin
    RxMemoryData.Edit;
    RxMemoryData.FieldByName('sType').AsString :=
      ValueTypeName(RxMemoryData.FieldByName('btType').AsInteger);
    RxMemoryData.Post;
    RxMemoryData.Next;
  end;
end;

function IsHexDigit(C: Char): Boolean;
begin
  Result := (C in ['0'..'9']) or (C in ['A'..'F']) or (C in ['a'..'f']);
end;

function IsSetToken(const Value: string): Boolean;
var
  I: Integer;
begin
  Result := Value <> '';
  for I := 1 to Length(Value) do
    if not (Value[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_', '$']) then
      Exit(False);
end;

function TEditPropForm.ValidateAndStore: Boolean;
var
  ValueText, Token: string;
  I, Parsed: Integer;
  HasValue: Boolean;
begin
  Result := False;
  if CurrentProperty = nil then
    raise EInvalidOperation.Create('No DFM property is selected');
  if CurrentProperty.ValueType > 12 then
    Exit;

  if CurrentProperty.ValueType = 11 then
  begin
    ValueText := '[';
    HasValue := False;
    for I := 0 to SG.RowCount - 1 do
    begin
      Token := Trim(SG.Cells[0, I]);
      if Token = '' then
        Continue;
      if not IsSetToken(Token) then
        Exit;
      if HasValue then
        ValueText := ValueText + ',';
      ValueText := ValueText + Token;
      HasValue := True;
    end;
    CurrentProperty.Value := ValueText + ']';
    Exit(True);
  end;

  ValueText := ValueMemo.Lines.Text;
  case CurrentProperty.ValueType of
    1:
      if (Length(ValueText) < 2) or (ValueText[1] <> '(') or
         (ValueText[Length(ValueText)] <> ')') then
        Exit;
    2, 3, 4:
      begin
        if not TryStrToInt(Trim(ValueText), Parsed) then
          Exit;
        case CurrentProperty.ValueType of
          2: ValueText := IntToStr(Byte(Parsed));
          3: ValueText := IntToStr(Word(Parsed));
          4: ValueText := IntToStr(Parsed);
        end;
        ValueMemo.Lines.Text := ValueText;
      end;
    6, 7:
      if Length(ValueText) > 255 then
      begin
        ShowMessage('The short string is too long and will be truncated!');
        ValueText := Copy(ValueText, 1, 255);
        ValueMemo.Lines.Text := ValueText;
      end;
    8, 9:
      begin
        ValueText := Trim(ValueText);
        if (ValueText <> 'true') and (ValueText <> 'false') then
          Exit;
        ValueMemo.Lines.Text := ValueText;
      end;
    10:
      begin
        ValueText := Trim(ValueText);
        if Odd(Length(ValueText)) then
          Exit;
        for I := 1 to Length(ValueText) do
          if not IsHexDigit(ValueText[I]) then
            Exit;
      end;
  end;

  CurrentProperty.Value := ValueText;
  if (CurrentProperty.ValueType = 8) and (ValueText = 'true') then
    CurrentProperty.ValueType := 9
  else if (CurrentProperty.ValueType = 9) and (ValueText = 'false') then
    CurrentProperty.ValueType := 8;
  Result := True;
end;

procedure TEditPropForm.BitBtn1Click(Sender: TObject);
begin
  if not ValidateAndStore then
    raise Exception.Create('Invalid ' + TypeCB.Text + ' value');
end;

procedure TEditPropForm.SGKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (SG.Row >= 0) and (SG.Row < SG.RowCount) then
  begin
    SG.Cells[0, SG.Row] := '';
    Key := 0;
  end;
end;

procedure TEditPropForm.SGSelectCell(Sender: TObject; ACol, ARow: Longint;
  var CanSelect: Boolean);
begin
  SelectedRow := ARow;
end;

procedure TEditPropForm.SGSetEditText(Sender: TObject; ACol, ARow: Longint;
  const Value: string);
begin
  if Trim(Value) <> Value then
    SG.Cells[ACol, ARow] := Trim(Value);
end;

procedure TEditPropForm.SGClick(Sender: TObject);
begin
  if UpdatingGrid then
    Exit;
  if (SG.RowCount = 0) or (SG.Cells[0, SG.RowCount - 1] <> '') then
  begin
    SG.RowCount := SG.RowCount + 1;
    SG.Cells[0, SG.RowCount - 1] := '';
  end;
end;

procedure TEditPropForm.DBGrid1EditButtonClick(Sender: TObject);
begin
  ShowMessage(Sender.ClassName);
end;

procedure TEditPropForm.FormShow(Sender: TObject);
begin
  if DBGrid2.Columns.Count >= 4 then
  begin
    DBGrid2.Columns[2].Width := 120;
    DBGrid2.Columns[3].Width := 110;
  end;
end;

procedure TEditPropForm.SelectAll1Click(Sender: TObject);
begin
  ValueMemo.SelectAll;
end;

end.
