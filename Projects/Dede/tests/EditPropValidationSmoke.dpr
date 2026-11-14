program EditPropValidationSmoke;

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
begin
  Form := nil;
  PropertyItem := nil;
  Stage := 'initialize';
  try
    Application.Initialize;
    Stage := 'create editor';
    Form := TEditPropForm.Create(nil);
    PropertyItem := TDFMProperty.Create;
    Form.CurrentProperty := PropertyItem;

    Stage := 'accept Boolean true';
    PropertyItem.ValueType := 8;
    PropertyItem.Value := 'true';
    Form.ValueMemo.Lines.Text := 'true';
    Require(Form.ValidateAndStore, 'Boolean true was rejected');
    Require(PropertyItem.ValueType = 9,
      'Boolean true did not update the target type code');
    Require(PropertyItem.Value = 'true', 'Boolean text was not preserved');

    Stage := 'accept Boolean false';
    PropertyItem.ValueType := 9;
    PropertyItem.Value := 'false';
    Form.ValueMemo.Lines.Text := 'false';
    Require(Form.ValidateAndStore, 'Boolean false was rejected');
    Require(PropertyItem.ValueType = 8,
      'Boolean false did not update the target type code');

    Stage := 'reject Boolean case mismatch';
    PropertyItem.ValueType := 8;
    PropertyItem.Value := 'unchanged';
    Form.ValueMemo.Lines.Text := 'True';
    Require(not Form.ValidateAndStore,
      'Uppercase Boolean text was accepted');
    Require(PropertyItem.Value = 'unchanged',
      'Rejected Boolean text changed the property');

    Stage := 'reject unsupported NameValueList save';
    PropertyItem.ValueType := 14;
    PropertyItem.Value := '(Name=02,Value)';
    Form.ValueMemo.Lines.Text := PropertyItem.Value;
    Require(not Form.ValidateAndStore,
      'Unsupported NameValueList save was accepted');
    Require(PropertyItem.Value = '(Name=02,Value)',
      'Rejected NameValueList save changed the property');

    Stage := 'store valid set items';
    PropertyItem.ValueType := 11;
    PropertyItem.Value := '[First,$Second_2]';
    Form.EditProperty(PropertyItem);
    Require(Form.ValidateAndStore, 'Valid set items were rejected');
    Require(PropertyItem.Value = '[First,$Second_2]',
      'Valid set items were not serialized');

    Stage := 'reject invalid set item';
    PropertyItem.ValueType := 11;
    PropertyItem.Value := '[First,bad-name]';
    Form.EditProperty(PropertyItem);
    Require(not Form.ValidateAndStore, 'Invalid set item was accepted');
    Require(PropertyItem.Value = '[First,bad-name]',
      'Rejected set items changed the property');

    Stage := 'reject unknown type';
    PropertyItem.ValueType := 13;
    Form.ValueMemo.Lines.Text := 'raw';
    Require(not Form.ValidateAndStore, 'Unknown property type was accepted');

    WriteLn('EditProp validation smoke test passed');
  except
    on E: Exception do
    begin
      WriteLn('EditProp validation smoke test failed during ' + Stage +
        ': ' + E.Message);
      Flush(Output);
      Halt(1);
    end;
  end;
  PropertyItem.Free;
  Form.Free;
end.
