unit DI.ServiceDescriptor;

{$mode ObjFPC}
{$H+}

interface

uses
    Classes, SysUtils, Rtti, TypInfo, DI.Lifetime;

type
    // Registrierungsinformation
    TServiceDescriptor = class
    public
        ServiceType :PTypeInfo;
        ImplClass   :TClass;
        Lifetime    :TLifetime;
        SingletonInstance :TValue;
        constructor Create(AServiceType :PTypeInfo; AImplClass :TClass; ALifetime :TLifetime);
    end;

implementation

{ TServiceDescriptor }

constructor TServiceDescriptor.Create(AServiceType :PTypeInfo;
    AImplClass :TClass; ALifetime :TLifetime);
begin
    ServiceType := AServiceType;
    ImplClass   := AImplClass;
    Lifetime    := ALifetime;
    SingletonInstance := TValue.Empty;
end;

end.
