unit DesktopMcpShellTests;

{$mode objfpc}{$H+}

interface

uses
  DesktopMcpBridge;

type
  TFakeDesktopMcpShell = class(TInterfacedObject, IDesktopMcpShell)
  private
    FRunning: Boolean;
    FActiveWindowTitle: string;
    FOpenWindowCount: Integer;
    FOpenedApplication: string;
  public
    constructor Create;
    function IsRunning: Boolean;
    function ActiveWindowTitle: string;
    function OpenWindowCount: Integer;
    function ApplicationNames: TDesktopMcpApplicationNames;
    function HasApplication(const AName: string): Boolean;
    procedure OpenApplication(const AName: string);
    property OpenedApplication: string read FOpenedApplication;
  end;

implementation

constructor TFakeDesktopMcpShell.Create;
begin
  inherited Create;
  FRunning := True;
  FActiveWindowTitle := 'Calculator';
  FOpenWindowCount := 1;
end;

function TFakeDesktopMcpShell.IsRunning: Boolean;
begin
  Result := FRunning;
end;

function TFakeDesktopMcpShell.ActiveWindowTitle: string;
begin
  Result := FActiveWindowTitle;
end;

function TFakeDesktopMcpShell.OpenWindowCount: Integer;
begin
  Result := FOpenWindowCount;
end;

function TFakeDesktopMcpShell.ApplicationNames: TDesktopMcpApplicationNames;
begin
  Result := nil;
  SetLength(Result, 2);
  Result[0] := 'Calculator';
  Result[1] := 'Calendar';
end;

function TFakeDesktopMcpShell.HasApplication(const AName: string): Boolean;
begin
  Result := (AName = 'Calculator') or (AName = 'Calendar');
end;

procedure TFakeDesktopMcpShell.OpenApplication(const AName: string);
begin
  FOpenedApplication := AName;
  Inc(FOpenWindowCount);
  FActiveWindowTitle := AName;
end;

end.
