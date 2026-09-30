unit DI.Container;

{$mode delphi}
{$H+}

interface

uses
  SysUtils, Classes, Rtti, TypInfo, Generics.Collections,
  DI.Lifetime, DI.IServiceProvider, DI.IServiceScope,
  DI.ServiceDescriptor, DI.Scope;

type
  TDIContainer = class(TInterfacedObject, IServiceProvider)
  private
    FContext: TRttiContext;
    FDescriptors: TDictionary<PTypeInfo, TServiceDescriptor>;
    FScopedInstances: TDictionary<PTypeInfo, TValue>;
    FRootContainer: TDIContainer;

    function CreateInstance(AClass: TClass): TValue;
  public
    constructor Create(ARoot: TDIContainer = nil);
    destructor Destroy; override;

    // Registrierung
    procedure RegisterType<TInterface: IInterface; TImpl: class>(ALifetime: TLifetime); overload;
    procedure RegisterType(AServiceType: PTypeInfo; AImplClass: TClass; ALifetime: TLifetime); overload;

    // IServiceProvider Implementierung
    function Resolve(ATypeInfo: PTypeInfo): TValue;
    function CreateScope: IInterface;
  end;

implementation

constructor TDIContainer.Create(ARoot: TDIContainer);
begin
  inherited Create;
  FContext := TRttiContext.Create;
  FRootContainer := ARoot;
  FScopedInstances := TDictionary<PTypeInfo, TValue>.Create;

  if FRootContainer = nil then
    FDescriptors := TDictionary<PTypeInfo, TServiceDescriptor>.Create
  else
    FDescriptors := FRootContainer.FDescriptors;
end;

destructor TDIContainer.Destroy;
var
  Pair: TPair<PTypeInfo, TValue>;
  Desc: TServiceDescriptor;
begin
  for Pair in FScopedInstances do
  begin
    if Pair.Value.IsObject and (Pair.Value.AsObject <> nil) then
      Pair.Value.AsObject.Free;
  end;
  FScopedInstances.Free;

  if FRootContainer = nil then
  begin
    for Desc in FDescriptors.Values do
    begin
      if Desc.SingletonInstance.IsObject and (Desc.SingletonInstance.AsObject <> nil) then
        Desc.SingletonInstance.AsObject.Free;
      Desc.Free;
    end;
    FDescriptors.Free;
  end;

  FContext.Free;
  inherited;
end;

procedure TDIContainer.RegisterType<TInterface; TImpl>(ALifetime: TLifetime);
begin
  RegisterType(TypeInfo(TInterface), TImpl, ALifetime);
end;

procedure TDIContainer.RegisterType(AServiceType: PTypeInfo; AImplClass: TClass; ALifetime: TLifetime);
begin
  if FRootContainer <> nil then
    raise Exception.Create('Registrierungen sind nur im Root-Container erlaubt.');

  FDescriptors.AddOrSetValue(AServiceType, TServiceDescriptor.Create(AServiceType, AImplClass, ALifetime));
end;

function TDIContainer.CreateInstance(AClass: TClass): TValue;
var
  RttiType: TRttiType;
  Method, BestCtor: TRttiMethod;
  Params: TArray<TRttiParameter>;
  Args: TArray<TValue>;
  I: Integer;
begin
  RttiType := FContext.GetType(AClass);
  BestCtor := nil;

  for Method in RttiType.GetMethods do
  begin
    if Method.IsConstructor then
    begin
      BestCtor := Method;
      Break;
    end;
  end;

  if BestCtor = nil then
    raise Exception.CreateFmt('Kein Konstruktor gefunden für: %s', [AClass.ClassName]);

  Params := BestCtor.GetParameters;
  SetLength(Args, Length(Params));

  for I := 0 to High(Params) do
  begin
    if Params[I].ParamType = nil then
      raise Exception.CreateFmt('Parameter %s in %s besitzt keine RTTI-Informationen', [Params[I].Name, AClass.ClassName]);

    Args[I] := Resolve(Params[I].ParamType.Handle);
  end;

  Result := BestCtor.Invoke(AClass, Args);
end;

function TDIContainer.Resolve(ATypeInfo: PTypeInfo): TValue;
var
  Desc: TServiceDescriptor;
  Inst: TValue;
begin
  if not FDescriptors.TryGetValue(ATypeInfo, Desc) then
    raise Exception.CreateFmt('Typ nicht registriert: %s', [ATypeInfo^.Name]);

  case Desc.Lifetime of
    ltTransient:
      Result := CreateInstance(Desc.ImplClass);

    ltSingleton:
      begin
        if Desc.SingletonInstance.IsEmpty then
          Desc.SingletonInstance := CreateInstance(Desc.ImplClass);
        Result := Desc.SingletonInstance;
      end;

    ltScoped:
      begin
        if FRootContainer = nil then
          raise Exception.Create('Scoped-Instanzen können nur aus einem Scope aufgelöst werden, nicht aus dem Root-Container.');

        if not FScopedInstances.TryGetValue(ATypeInfo, Inst) then
        begin
          Inst := CreateInstance(Desc.ImplClass);
          FScopedInstances.Add(ATypeInfo, Inst);
        end;
        Result := Inst;
      end;
  end;
end;

function TDIContainer.CreateScope: IInterface;
begin
  Result := TDIScope.Create(TDIContainer.Create(Self));
end;

end.
