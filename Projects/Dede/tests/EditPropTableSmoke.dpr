program EditPropTableSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, Forms, EditPropUnit, DeDeDFMModel;

procedure Require(Value: Boolean; const MessageText: string);
begin
  if not Value then
    raise Exception.Create(MessageText);
end;

var
  Form: TEditPropForm;
  PropertyItem: TDFMProperty;
  Stage: string;
  EscapesRejected: Boolean;
begin
  Form := nil;
  PropertyItem := nil;
  Stage := 'initialize';
  try
    Application.Initialize;
    Stage := 'create editor';
    Form := TEditPropForm.Create(nil);
    PropertyItem := TDFMProperty.Create;

    Stage := 'load ValueList';
    PropertyItem.ValueType := 1;
    PropertyItem.Value := '(02,First;04,Second)';
    Form.EditProperty(PropertyItem);
    Form.RxMemoryData.First;
    Require(Form.RxMemoryData.FieldByName('sType').AsString = 'Byte',
      'ValueList type label is incorrect');
    Require(Form.RxMemoryData.FieldByName('Value').AsString = 'First',
      'ValueList value is incorrect');
    Form.RxMemoryData.Next;
    Require(Form.RxMemoryData.FieldByName('Value').AsString = 'Second',
      'Second ValueList value is incorrect');
    Require(PropertyItem.Value = '(02,First;04,Second)',
      'Displaying a ValueList changed the source property');

    Stage := 'load NameValueList';
    PropertyItem.ValueType := 14;
    PropertyItem.Value := '(Name#20One=02,Value#20One|Name#20Two=04,Value#20Two)';
    Form.EditProperty(PropertyItem);
    Form.RxMemoryData.First;
    Require(Form.RxMemoryData.FieldByName('Name').AsString = 'Name One',
      'Name/value name escape was not decoded');
    Require(Form.RxMemoryData.FieldByName('Subitem').AsInteger = 0,
      'First name/value group index is incorrect');
    Form.RxMemoryData.Next;
    Require(Form.RxMemoryData.FieldByName('Name').AsString = 'Name Two',
      'Second name/value name escape was not decoded');
    Require(Form.RxMemoryData.FieldByName('Subitem').AsInteger = 1,
      'Second name/value group index is incorrect');
    Require(PropertyItem.Value =
      '(Name#20One=02,Value#20One|Name#20Two=04,Value#20Two)',
      'Displaying a NameValueList changed the source property');

    Stage := 'reject malformed escape';
    PropertyItem.ValueType := 1;
    PropertyItem.Value := '(02,Invalid#G0)';
    EscapesRejected := False;
    try
      Form.EditProperty(PropertyItem);
    except
      on E: EConvertError do
        EscapesRejected := True;
    end;
    Require(EscapesRejected, 'Malformed DFM escape was silently accepted');

    WriteLn('EditProp list table smoke test passed');
  except
    on E: Exception do
    begin
      WriteLn('EditProp list table smoke test failed during ' + Stage +
        ': ' + E.Message);
      Flush(Output);
      Halt(1);
    end;
  end;
  PropertyItem.Free;
  Form.Free;
end.
