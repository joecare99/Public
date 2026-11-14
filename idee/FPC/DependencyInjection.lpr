program DIExample;

{$mode delphi}
{$M+}// Wichtig: Aktiviert RTTI-Generierung für Klassen

uses
    SysUtils,
    DI.Lifetime,
    DI.Container,
    DI.IServiceScope,
    DI.IServiceProvider,
    Rtti;

type
    // 1. Interfaces
    ILogger = interface
        ['{A1111111-1111-1111-1111-111111111111}']
        procedure Log(const Msg :string);
      end;

    IDatabase = interface
        ['{B2222222-2222-2222-2222-222222222222}']
        procedure Query(const SQL :string);
      end;

    IOrderService = interface
        ['{C3333333-3333-3333-3333-333333333333}']
        procedure PlaceOrder;
      end;

    // 2. Implementierungen
    TConsoleLogger = class(TInterfacedObject, ILogger)
    published
        constructor Create;
        procedure Log(const Msg :string);
      end;

    TSqlDatabase = class(TInterfacedObject, IDatabase)
    private
        FLogger :ILogger;
    published
        // Dependency Injection über Konstruktor!
        constructor Create(ALogger :ILogger);
        procedure Query(const SQL :string);
      end;

    TOrderService = class(TInterfacedObject, IOrderService)
    private
        FDb     :IDatabase;
        FLogger :ILogger;
    published
        // Mehrere Dependencies
        constructor Create(ADb :IDatabase; ALogger :ILogger);
        procedure PlaceOrder;
      end;

    { Implementierungen }

    constructor TConsoleLogger.Create;
    begin
        inherited Create;
        Writeln('  [Init] TConsoleLogger erstellt');
    end;

    procedure TConsoleLogger.Log(const Msg :string);
    begin
        Writeln('  [Log] ', Msg);
    end;

    constructor TSqlDatabase.Create(ALogger :ILogger);
    begin
        inherited Create;
        FLogger := ALogger;
        Writeln('  [Init] TSqlDatabase erstellt mit Logger');
    end;

    procedure TSqlDatabase.Query(const SQL :string);
    begin
        FLogger.Log('Executing: ' + SQL);
    end;

    constructor TOrderService.Create(ADb :IDatabase; ALogger :ILogger);
    begin
        inherited Create;
        FDb     := ADb;
        FLogger := ALogger;
        Writeln('  [Init] TOrderService erstellt');
    end;

    procedure TOrderService.PlaceOrder;
    begin
        FLogger.Log('Starte PlaceOrder...');
        FDb.Query('INSERT INTO Orders VALUES (1)');
    end;

    // 3. Hauptprogramm
var
    Container :TDIContainer;
    Scope1, Scope2 :IServiceScope;
    OrderSvc :IOrderService;
    AClass   :TClass;
    FContext :TRttiContext;
    RttiType :TRttiType;
    Method   :TRttiMethod;
begin
    AClass   := TOrderService;
    FContext := TRttiContext.Create;
    RttiType := FContext.GetType(AClass);

    Writeln(Format('Methods of %s',[AClass.Classname]));
    Writeln(Format('- Name: %s',[RttiType.Name]));
    Writeln(Format('- Method.Count: %d',[Length(RttiType.GetMethods)]));
    Writeln('- IsInstance: ',RttiType.IsInstance);
    Writeln('- isManaged: ',RttiType.isManaged);
    Writeln(Format('- IsOrdinal: %s',[RttiType.IsOrdinal]));
    Writeln(Format('- IsRecord: %s',[RttiType.IsRecord]));
    Writeln(Format('- IsSet: %s',[RttiType.IsSet]));
    Writeln(Format('- TypeSize: %d',[RttiType.TypeSize]));

    for Method in RttiType.GetMethods do
      begin
        WriteLn(Method.Name);
      end;

    Container := TDIContainer.Create;
      try
        // Registrierung der Typen & Lifetimes:
        Container.RegisterType<ILogger, TConsoleLogger>(ltSingleton);   // Singleton
        Container.RegisterType<IDatabase, TSqlDatabase>(ltScoped);       // Scoped
        Container.RegisterType<IOrderService, TOrderService>(ltTransient); // Transient

        Writeln('=== Scope 1 Test ===');
        Scope1   := Container.CreateScope as IServiceScope;
        // Automatische Erstellung: Logger (Singleton) -> Database (Scoped) -> OrderService
        OrderSvc := Resolve<IOrderService>(Scope1.ServiceProvider);
        OrderSvc.PlaceOrder;

        Writeln;
        Writeln('=== Scope 2 Test ===');
        Scope2   := Container.CreateScope as IServiceScope;
        // Logger bleibt dieselbe Instanz, Database wird für Scope 2 neu erzeugt
        OrderSvc := Resolve<IOrderService>(Scope2.ServiceProvider);
        OrderSvc.PlaceOrder;

      finally
        Container.Free;
      end;

    Readln;
end.
