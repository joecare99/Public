unit DesktopMcpShellAdapter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DesktopMcpBridge, DesktopApplication, DesktopWorkspace,
  DesktopWindow;

type
  TDesktopMcpShellAdapter = class(TInterfacedObject, IDesktopMcpShell)
  private
    FApplications: TDesktopApplicationRegistry;
    FWorkspace: TDesktopWorkspace;
  public
    constructor Create(AApplications: TDesktopApplicationRegistry;
      AWorkspace: TDesktopWorkspace);
    function IsRunning: Boolean;
    function ActiveWindowTitle: string;
    function OpenWindowCount: Integer;
    function ApplicationNames: TDesktopMcpApplicationNames;
    function HasApplication(const AName: string): Boolean;
    procedure OpenApplication(const AName: string);
  end;

implementation

constructor TDesktopMcpShellAdapter.Create(
  AApplications: TDesktopApplicationRegistry; AWorkspace: TDesktopWorkspace);
begin
  inherited Create;
  if (AApplications = nil) or (AWorkspace = nil) then
    raise EArgumentNilException.Create(
      'Desktop applications and workspace are required.');
  FApplications := AApplications;
  FWorkspace := AWorkspace;
end;

function TDesktopMcpShellAdapter.IsRunning: Boolean;
begin
  Result := (FApplications <> nil) and (FWorkspace <> nil) and
    not (csDestroying in FWorkspace.ComponentState);
end;

function TDesktopMcpShellAdapter.ActiveWindowTitle: string;
begin
  Result := '';
  if IsRunning and (FWorkspace.ActiveWindow <> nil) then
    Result := FWorkspace.ActiveWindow.Title;
end;

function TDesktopMcpShellAdapter.OpenWindowCount: Integer;
begin
  if not IsRunning then
    Exit(0);
  Result := FWorkspace.WindowCount;
end;

function TDesktopMcpShellAdapter.ApplicationNames:
  TDesktopMcpApplicationNames;
var
  I: Integer;
begin
  Result := nil;
  if not IsRunning then
    Exit;
  SetLength(Result, FApplications.Count);
  for I := 0 to FApplications.Count - 1 do
    Result[I] := FApplications.ApplicationAt(I).Name;
end;

function TDesktopMcpShellAdapter.HasApplication(const AName: string): Boolean;
begin
  Result := IsRunning and (FApplications.ApplicationNamed(AName) <> nil);
end;

procedure TDesktopMcpShellAdapter.OpenApplication(const AName: string);
begin
  if not HasApplication(AName) then
    raise EArgumentException.Create('The desktop application is not registered.');
  FApplications.Open(AName);
end;

end.
