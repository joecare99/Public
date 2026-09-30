unit uSimpleDI;

{$mode delphi}

interface

uses
  SysUtils, Classes, Rtti, TypInfo, Generics.Collections;

type
  TLifetime = (ltTransient, ltScoped, ltSingleton);

  IServiceProvider = interface;

  // Interface für Scope-Lebenszyklen
  IServiceScope = interface
    ['{B83C56E2-9F1C-4B9A-8507-6B1832A89F4B}']
    function GetServiceProvider: IServiceProvider;
    property ServiceProvider: IServiceProvider read GetServiceProvider;
  end;

  // Interface zum Auflösen von Services
  IServiceProvider = interface
    ['{696144D9-6A42-4A73-A7C7-56E0EB0B6F01}']
    function Resolve(ATypeInfo: PTypeInfo): TValue;
    function ResolveInterface<T: IInterface>: T;
    function CreateScope: IServiceScope;
  end;

  // Registrierungsinformation
  TServiceDescriptor = class
  public
    ServiceType: PTypeInfo;
    ImplClass: TClass;
    Lifetime: TLifetime;
    SingletonInstance: TValue;
    constructor Create(AServiceType: PTypeInfo; AImplClass: TClass; ALifetime: TLifetime);
  end;

  // Der Container
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

    // Auflösung
    function Resolve(ATypeInfo: PTypeInfo): TValue;
    function ResolveInterface<T: IInterface>: T;
    function CreateScope: IServiceScope;
  end;

  // Scope-Wrapper
  TDIScope = class(TInterfacedObject, IServiceScope)
  private
    FScopedContainer: TDIContainer;
  public
    constructor Create(ARootContainer: TDIContainer);
    destructor Destroy; override;
    function GetServiceProvider: IServiceProvider;
  end;

implementation

{ TServiceDescriptor }

constructor TServiceDescriptor.Create(AServiceType: PTypeInfo; AImplClass: TClass; ALifetime: TLifetime);
begin
  ServiceType := AServiceType;
  ImplClass := AImplClass;
  Lifetime := ALifetime;
  SingletonInstance := TValue.Empty;
end;

{ TDIScope }

constructor TDIScope.Create(ARootContainer: TDIContainer);
begin
  FScopedContainer := TDIContainer.Create(ARootContainer);
end;

destructor TDIScope.Destroy;
begin
  FScopedContainer.Free;
  inherited;
end;

function TDIScope.GetServiceProvider: IServiceProvider;
begin
  Result := FScopedContainer;
end;

{ TDIContainer }

constructor TDIContainer.Create(ARoot: TDIContainer);
begin
  inherited Create;
  FContext := TRttiContext.Create;
  FRootContainer := ARoot;
  FScopedInstances := TDictionary<PTypeInfo, TValue>.Create;

  if FRootContainer = nil then
    FDescriptors := TDictionary<PTypeInfo, TServiceDescriptor>.Create
  else
    FDescriptors := FRootContainer.FDescriptors; // Scopes teilen sich Registrierungen
end;

destructor TDIContainer.Destroy;
var
  Pair: TPair<PTypeInfo, TValue>;
  Desc: TServiceDescriptor;
begin
  // Nur Scoped Instanzen im Scope freigeben (sofern es Objekte sind)
  for Pair in FScopedInstances do
  begin
    if Pair.Value.IsObject and (Pair.Value.AsObject <> nil) then
      Pair.Value.AsObject.Free;
  end;
  FScopedInstances.Free;

  // Root-Container bereinigt Singletons und Registrierungs-Deskriptoren
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
    raise Exception.Create('Registrierungen nur im Root-Container erlaubt.');

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

  // Suche nach dem Constructor (z.B. Create)
  for Method in RttiType.GetMethods do
  begin
    if Method.IsConstructor then
    begin
      BestCtor := Method;
      Break; // Wählt den ersten gefundenen Constructor
    end;
  end;

  if BestCtor = nil then
    raise Exception.CreateFmt('Kein Konstruktor gefunden für: %s', [AClass.ClassName]);

  // Parameter des Konstruktors analysieren und rekursiv auflösen
  Params := BestCtor.GetParameters;
  SetLength(Args, Length(Params));

  for I := 0 to High(Params) do
  begin
    if Params[I].ParamType = nil then
      raise Exception.CreateFmt('Parameter %s in %s hat keine RTTI', [Params[I].Name, AClass.ClassName]);

    // Rekursive Auflösung des Parameters über seinen PTypeInfo
    Args[I] := Resolve(Params[I].ParamType.Handle);
  end;

  // Instanziierung über RTTI Invoke (Metaklasse übergeben)
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
          raise Exception.Create('Scoped-Instanzen können nicht direkt aus dem Root-Container aufgelöst werden.');

        if not FScopedInstances.TryGetValue(ATypeInfo, Inst) then
        begin
          Inst := CreateInstance(Desc.ImplClass);
          FScopedInstances.Add(ATypeInfo, Inst);
        end;
        Result := Inst;
      end;
  end;
end;

function TDIContainer.ResolveInterface<T>: T;
var
  Val: TValue;
begin
  Val := Resolve(TypeInfo(T));
  Result := Val.AsInterface as T;
end;

function TDIContainer.CreateScope: IServiceScope;
begin
  Result := TDIScope.Create(Self);
end;

end.
