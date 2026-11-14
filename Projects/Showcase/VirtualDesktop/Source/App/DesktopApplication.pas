unit DesktopApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DesktopWorkspace, DesktopServices;

type
  TDesktopApplication = class
  private
    FName: string;
  protected
    FWorkspace: TDesktopWorkspace;
    FServices: IDesktopServices;
    FOnOpened: TNotifyEvent;
    procedure NotifyOpened(Sender: TObject);
  public
    constructor Create(const AName: string; AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    procedure Open; virtual; abstract;
    property Name: string read FName;
  end;

  TCallbackDesktopApplication = class(TDesktopApplication)
  private
    FOpenHandler: TNotifyEvent;
  public
    constructor Create(const AName: string; AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOpenHandler: TNotifyEvent);
    procedure Open; override;
  end;

  TDesktopApplicationRegistry = class
  private
    FApplications: array of TDesktopApplication;
    function FindApplication(const AName: string): TDesktopApplication;
  public
    destructor Destroy; override;
    procedure RegisterApplication(AApplication: TDesktopApplication);
    procedure Open(const AName: string);
    function ApplicationNamed(const AName: string): TDesktopApplication;
    function Count: Integer;
    function ApplicationAt(const AIndex: Integer): TDesktopApplication;
  end;

implementation

constructor TDesktopApplication.Create(const AName: string;
  AWorkspace: TDesktopWorkspace; const AServices: IDesktopServices;
  AOnOpened: TNotifyEvent);
begin
  inherited Create;
  FName := AName;
  FWorkspace := AWorkspace;
  FServices := AServices;
  FOnOpened := AOnOpened;
end;

constructor TCallbackDesktopApplication.Create(const AName: string;
  AWorkspace: TDesktopWorkspace; const AServices: IDesktopServices;
  AOpenHandler: TNotifyEvent);
begin
  inherited Create(AName, AWorkspace, AServices, nil);
  if not Assigned(AOpenHandler) then
    raise EArgumentNilException.Create('An application open handler is required.');
  FOpenHandler := AOpenHandler;
end;

procedure TCallbackDesktopApplication.Open;
begin
  FOpenHandler(Self);
end;

procedure TDesktopApplication.NotifyOpened(Sender: TObject);
begin
  if Assigned(FOnOpened) then
    FOnOpened(Self);
end;

destructor TDesktopApplicationRegistry.Destroy;
var
  I: Integer;
begin
  for I := 0 to High(FApplications) do
    FApplications[I].Free;
  inherited Destroy;
end;

function TDesktopApplicationRegistry.FindApplication(
  const AName: string): TDesktopApplication;
var
  I: Integer;
begin
  for I := 0 to High(FApplications) do
    if SameText(FApplications[I].Name, AName) then
      Exit(FApplications[I]);
  Result := nil;
end;

procedure TDesktopApplicationRegistry.RegisterApplication(
  AApplication: TDesktopApplication);
begin
  if not Assigned(AApplication) then
    raise EArgumentNilException.Create('A desktop application is required.');
  if Assigned(FindApplication(AApplication.Name)) then
    raise EArgumentException.CreateFmt('Application "%s" is already registered.',
      [AApplication.Name]);
  SetLength(FApplications, Length(FApplications) + 1);
  FApplications[High(FApplications)] := AApplication;
end;

procedure TDesktopApplicationRegistry.Open(const AName: string);
var
  Application: TDesktopApplication;
begin
  Application := FindApplication(AName);
  if not Assigned(Application) then
    raise EArgumentException.CreateFmt('Application "%s" is not registered.',
      [AName]);
  Application.Open;
end;

function TDesktopApplicationRegistry.ApplicationNamed(
  const AName: string): TDesktopApplication;
begin
  Result := FindApplication(AName);
end;

function TDesktopApplicationRegistry.Count: Integer;
begin
  Result := Length(FApplications);
end;

function TDesktopApplicationRegistry.ApplicationAt(
  const AIndex: Integer): TDesktopApplication;
begin
  if (AIndex < 0) or (AIndex >= Length(FApplications)) then
    raise EArgumentOutOfRangeException.CreateFmt(
      'Application index %d is out of range.', [AIndex]);
  Result := FApplications[AIndex];
end;

end.
