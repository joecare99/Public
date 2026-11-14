unit DeDeDFMModel;

interface

uses
  Classes;

type
  TDFMProperty = class(TObject)
  public
    Name: string;
    Value: string;
    ValueType: Byte;
  end;

  TDFMObject = class(TObject)
  public
    Children: TList;
    Properties: TList;
    ObjectName: string;
    ClassName: string;
    ParentObject: TDFMObject;
    Component: TComponent;
    constructor Create;
    destructor Destroy; override;
    function AddChild(const AObjectName, AClassName: string): TDFMObject;
    function AddProperty(const AName, AValue: string;
      AValueType: Byte): TDFMProperty;
  end;

implementation

constructor TDFMObject.Create;
begin
  inherited Create;
  Children := TList.Create;
  Properties := TList.Create;
end;

destructor TDFMObject.Destroy;
var
  I: Integer;
begin
  for I := Children.Count - 1 downto 0 do
    TObject(Children[I]).Free;
  for I := Properties.Count - 1 downto 0 do
    TObject(Properties[I]).Free;
  Children.Free;
  Properties.Free;
  inherited Destroy;
end;

function TDFMObject.AddChild(const AObjectName,
  AClassName: string): TDFMObject;
begin
  Result := TDFMObject.Create;
  Result.ObjectName := AObjectName;
  Result.ClassName := AClassName;
  Result.ParentObject := Self;
  Children.Add(Result);
end;

function TDFMObject.AddProperty(const AName, AValue: string;
  AValueType: Byte): TDFMProperty;
begin
  Result := TDFMProperty.Create;
  Result.Name := AName;
  Result.Value := AValue;
  Result.ValueType := AValueType;
  Properties.Add(Result);
end;

end.
