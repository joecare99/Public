{ Basisklasse der Dienste (Services) der Delphi-Bible.

  Ein Dienst kapselt eine externe Faehigkeit (Dateisystem, Prozesse,
  Datenbank, Druck, Interprozesskommunikation). Die ViewModels benutzen die
  Dienste, die Views nie. }

unit ServiceBase;

interface

uses
  Classes, SysUtils;

type
  { TServiceError }
  TServiceError = class(Exception);

  { TServiceBase }
  TServiceBase = class
  private
    FName: string;
    FLog: TStringList;
  protected
    procedure Log(const AMessage: string);
    procedure LogError(const AMessage: string);
    { Loest einen Dienstfehler aus. }
    procedure Fail(const AMessage: string);
    property LogLines: TStringList read FLog;
  public
    constructor Create(const AName: string); virtual;
    destructor Destroy; override;
    { Startet den Dienst. }
    procedure Start; virtual;
    { Beendet den Dienst. }
    procedure Stop; virtual;
    property Name: string read FName write FName;
  end;

implementation

constructor TServiceBase.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
  FLog := TStringList.Create;
end;

destructor TServiceBase.Destroy;
begin
  FreeAndNil(FLog);
  inherited Destroy;
end;

procedure TServiceBase.Start;
begin
end;

procedure TServiceBase.Stop;
begin
end;

procedure TServiceBase.Log(const AMessage: string);
begin
  FLog.Add(AMessage);
end;

procedure TServiceBase.LogError(const AMessage: string);
begin
  FLog.Add('FEHLER: ' + AMessage);
end;

procedure TServiceBase.Fail(const AMessage: string);
begin
  LogError(AMessage);
  raise TServiceError.Create(AMessage);
end;

end.
