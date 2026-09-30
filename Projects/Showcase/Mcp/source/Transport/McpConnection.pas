unit McpConnection;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, McpCommand;

type
  EMcpConnectionError = class(EMcpError);

  TMcpConnectionDetails = class
  private
    FToken: string;
    FLoopbackEndpoint: string;
    FWorkspaceRoot: string;
    procedure ApplyJsonFile(const AText: string);
    procedure ApplyKeyValueFile(const AText: string);
    procedure ApplyEnvironment;
    procedure SetDefaultWorkspaceRoot;
  public
    class function Load(const ATokenFile: string): TMcpConnectionDetails;
    property Token: string read FToken;
    property LoopbackEndpoint: string read FLoopbackEndpoint;
    property WorkspaceRoot: string read FWorkspaceRoot;
    function HasToken: Boolean;
  end;

implementation

function JsonStringValue(const AObject: TJSONObject; const AName: string):
  string;
var
  Value: TJSONData;
begin
  Value := AObject.Find(AName, jtString);
  if Value = nil then
    Exit('');
  Result := Value.AsString;
end;

procedure TMcpConnectionDetails.ApplyJsonFile(const AText: string);
var
  Data: TJSONData;
  Root: TJSONObject;
begin
  try
    Data := GetJSON(AText, True);
  except
    on E: Exception do
      raise EMcpConnectionError.Create('The MCP connection file is invalid.');
  end;
  try
    if not (Data is TJSONObject) then
      raise EMcpConnectionError.Create(
        'The MCP connection file must contain a JSON object.');
    Root := TJSONObject(Data);
    FToken := JsonStringValue(Root, 'token');
    FLoopbackEndpoint := JsonStringValue(Root, 'endpoint');
    if FLoopbackEndpoint = '' then
      FLoopbackEndpoint := JsonStringValue(Root, 'loopbackEndpoint');
    FWorkspaceRoot := JsonStringValue(Root, 'workspaceRoot');
  finally
    Data.Free;
  end;
end;

procedure TMcpConnectionDetails.ApplyKeyValueFile(const AText: string);
var
  Lines: TStringList;
  I, Separator: Integer;
  Key, Value: string;
  Recognized: Boolean;
begin
  Recognized := False;
  Lines := TStringList.Create;
  try
    Lines.Text := AText;
    for I := 0 to Lines.Count - 1 do
    begin
      Separator := Pos('=', Lines[I]);
      if Separator <= 1 then
        Continue;
      Key := LowerCase(Trim(Copy(Lines[I], 1, Separator - 1)));
      Value := Trim(Copy(Lines[I], Separator + 1, MaxInt));
      if Key = 'token' then
      begin
        FToken := Value;
        Recognized := True;
      end
      else if (Key = 'endpoint') or (Key = 'loopbackendpoint') then
      begin
        FLoopbackEndpoint := Value;
        Recognized := True;
      end
      else if (Key = 'workspaceroot') then
      begin
        FWorkspaceRoot := Value;
        Recognized := True;
      end;
    end;
    if not Recognized then
      FToken := Trim(AText);
  finally
    Lines.Free;
  end;
end;

procedure TMcpConnectionDetails.ApplyEnvironment;
var
  Value: string;
begin
  Value := GetEnvironmentVariable('MCP_TOKEN');
  if (FToken = '') and (Value <> '') then
    FToken := Value;
  Value := GetEnvironmentVariable('MCP_LOOPBACK_ENDPOINT');
  if Value = '' then
    Value := GetEnvironmentVariable('MCP_ENDPOINT');
  if (FLoopbackEndpoint = '') and (Value <> '') then
    FLoopbackEndpoint := Value;
  Value := GetEnvironmentVariable('MCP_WORKSPACE_ROOT');
  if (FWorkspaceRoot = '') and (Value <> '') then
    FWorkspaceRoot := Value;
end;

procedure TMcpConnectionDetails.SetDefaultWorkspaceRoot;
var
  BasePath: string;
begin
  if FWorkspaceRoot <> '' then
    Exit;
  BasePath := GetEnvironmentVariable('LOCALAPPDATA');
  if BasePath = '' then
    BasePath := GetEnvironmentVariable('APPDATA');
  if BasePath = '' then
    BasePath := GetUserDir;
  FWorkspaceRoot := IncludeTrailingPathDelimiter(BasePath) +
    'LazarusVirtualDesktop';
end;

class function TMcpConnectionDetails.Load(const ATokenFile: string):
  TMcpConnectionDetails;
var
  FileName, Text: string;
  Lines: TStringList;
begin
  Result := TMcpConnectionDetails.Create;
  try
    FileName := ATokenFile;
    if FileName = '' then
      FileName := GetEnvironmentVariable('MCP_TOKEN_FILE');
    if FileName = '' then
      FileName := GetEnvironmentVariable('VIRTUALDESKTOP_MCP_TOKEN_FILE');

    if FileName <> '' then
    begin
      if not FileExists(FileName) then
        raise EMcpConnectionError.Create('The MCP connection file was not found.');
      Lines := TStringList.Create;
      try
        Lines.LoadFromFile(FileName);
        Text := Trim(Lines.Text);
      finally
        Lines.Free;
      end;
      if Text <> '' then
      begin
        if Text[1] = '{' then
          Result.ApplyJsonFile(Text)
        else
          Result.ApplyKeyValueFile(Text);
      end;
    end;

    Result.ApplyEnvironment;
    Result.SetDefaultWorkspaceRoot;
    if Trim(Result.FWorkspaceRoot) = '' then
      raise EMcpConnectionError.Create(
        'A user-workspace root could not be determined.');
    Result.FWorkspaceRoot := ExpandFileName(Result.FWorkspaceRoot);
  except
    Result.Free;
    raise;
  end;
end;

function TMcpConnectionDetails.HasToken: Boolean;
begin
  Result := FToken <> '';
end;

end.
