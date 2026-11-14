unit McpJsonRpc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, McpCommand;

type
  TMcpJsonRpcServer = class
  private
    FClient: IMcpToolClient;
    FServerName: string;
    FServerVersion: string;
    function NewResponse(const AId: TJSONData): TJSONObject;
    procedure SetError(const AResponse: TJSONObject; const ACode: Integer;
      const AMessage: string);
    function HandleRequest(const ARequest: TJSONObject): TJSONObject;
  public
    constructor Create(const AClient: IMcpToolClient; const AServerName,
      AServerVersion: string);
    function HandleLine(const ALine: string): string;
  end;

procedure RunMcpStdio(const AServer: TMcpJsonRpcServer);

implementation

function CloneOrNull(const AValue: TJSONData): TJSONData;
begin
  if AValue = nil then
    Result := GetJSON('null', True)
  else
    Result := AValue.Clone;
end;

constructor TMcpJsonRpcServer.Create(const AClient: IMcpToolClient;
  const AServerName, AServerVersion: string);
begin
  inherited Create;
  if AClient = nil then
    raise EMcpInvalidCommand.Create('An MCP tool client is required.');
  FClient := AClient;
  FServerName := AServerName;
  FServerVersion := AServerVersion;
end;

function TMcpJsonRpcServer.NewResponse(const AId: TJSONData): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('jsonrpc', '2.0');
  Result.Add('id', CloneOrNull(AId));
end;

procedure TMcpJsonRpcServer.SetError(const AResponse: TJSONObject;
  const ACode: Integer; const AMessage: string);
var
  ErrorObject: TJSONObject;
begin
  ErrorObject := TJSONObject.Create;
  ErrorObject.Add('code', ACode);
  ErrorObject.Add('message', AMessage);
  AResponse.Add('error', ErrorObject);
end;

function TMcpJsonRpcServer.HandleRequest(
  const ARequest: TJSONObject): TJSONObject;
var
  MethodValue, ParamsValue, NameValue, ArgumentsValue: TJSONData;
  Params, Arguments: TJSONObject;
  ToolResult: TMcpCommandResult;
  Capabilities, ServerInfo, InitializeResult, EmptyResult: TJSONObject;
begin
  Result := NewResponse(ARequest.Find('id'));
  MethodValue := ARequest.Find('method', jtString);
  if MethodValue = nil then
  begin
    SetError(Result, -32600, 'The JSON-RPC method is required.');
    Exit;
  end;

  if MethodValue.AsString = 'initialize' then
  begin
    InitializeResult := TJSONObject.Create;
    InitializeResult.Add('protocolVersion', '2024-11-05');
    Capabilities := TJSONObject.Create;
    Capabilities.Add('tools', TJSONObject.Create);
    InitializeResult.Add('capabilities', Capabilities);
    ServerInfo := TJSONObject.Create;
    ServerInfo.Add('name', FServerName);
    ServerInfo.Add('version', FServerVersion);
    InitializeResult.Add('serverInfo', ServerInfo);
    Result.Add('result', InitializeResult);
    Exit;
  end;

  if MethodValue.AsString = 'notifications/initialized' then
    Exit;

  if MethodValue.AsString = 'ping' then
  begin
    EmptyResult := TJSONObject.Create;
    Result.Add('result', EmptyResult);
    Exit;
  end;

  if MethodValue.AsString = 'tools/list' then
  begin
    EmptyResult := TJSONObject.Create;
    EmptyResult.Add('tools', FClient.ListTools);
    Result.Add('result', EmptyResult);
    Exit;
  end;

  if MethodValue.AsString <> 'tools/call' then
  begin
    SetError(Result, -32601, 'The requested MCP method is not available.');
    Exit;
  end;

  ParamsValue := ARequest.Find('params', jtObject);
  if ParamsValue = nil then
  begin
    SetError(Result, -32602, 'Tool call parameters must be an object.');
    Exit;
  end;
  Params := TJSONObject(ParamsValue);
  NameValue := Params.Find('name', jtString);
  if (NameValue = nil) or (Trim(NameValue.AsString) = '') then
  begin
    SetError(Result, -32602, 'A tool name is required.');
    Exit;
  end;

  ArgumentsValue := Params.Find('arguments', jtObject);
  if ArgumentsValue = nil then
    Arguments := TJSONObject.Create
  else
    Arguments := TJSONObject(ArgumentsValue.Clone);
  try
    try
      ToolResult := FClient.CallTool(NameValue.AsString, Arguments);
      if ToolResult = nil then
      begin
        SetError(Result, -32000, 'The MCP tool returned no result.');
        Exit;
      end;
      Result.Add('result', ToolResult.ToMcpJson);
    except
      on E: EMcpInvalidParams do
        SetError(Result, -32602, E.Message);
      on E: EMcpToolNotFound do
        SetError(Result, -32602, 'The requested MCP tool is not available.');
      on E: EMcpAccessDenied do
        SetError(Result, -32003, 'The MCP tool denied the requested operation.');
      on E: EMcpError do
        SetError(Result, -32000, 'The MCP tool failed.');
      on E: Exception do
        SetError(Result, -32000, 'The MCP tool failed.');
    end;
  finally
    Arguments.Free;
  end;
end;

function TMcpJsonRpcServer.HandleLine(const ALine: string): string;
var
  RequestData: TJSONData;
  Request: TJSONObject;
  Response: TJSONObject;
  IsNotification: Boolean;
begin
  Result := '';
  if Trim(ALine) = '' then
    Exit;

  try
    RequestData := GetJSON(Trim(ALine), True);
  except
    on E: Exception do
    begin
      Response := NewResponse(nil);
      try
        SetError(Response, -32700, 'The JSON-RPC request could not be parsed.');
        Result := Response.AsJSON;
      finally
        Response.Free;
      end;
      Exit;
    end;
  end;
  try
    if not (RequestData is TJSONObject) then
    begin
      Response := NewResponse(nil);
      try
        SetError(Response, -32600, 'The JSON-RPC request must be an object.');
        Result := Response.AsJSON;
      finally
        Response.Free;
      end;
      Exit;
    end;

    Request := TJSONObject(RequestData);
    IsNotification := Request.Find('id') = nil;
    if Request.Find('jsonrpc', jtString) = nil then
    begin
      Response := NewResponse(Request.Find('id'));
      try
        SetError(Response, -32600, 'The JSON-RPC version is required.');
        if not IsNotification then
          Result := Response.AsJSON;
      finally
        Response.Free;
      end;
      Exit;
    end;
    if Request.Find('jsonrpc', jtString).AsString <> '2.0' then
    begin
      Response := NewResponse(Request.Find('id'));
      try
        SetError(Response, -32600, 'Only JSON-RPC 2.0 is supported.');
        if not IsNotification then
          Result := Response.AsJSON;
      finally
        Response.Free;
      end;
      Exit;
    end;

    Response := HandleRequest(Request);
    try
      if not IsNotification then
        Result := Response.AsJSON;
    finally
      Response.Free;
    end;
  finally
    RequestData.Free;
  end;
end;

procedure RunMcpStdio(const AServer: TMcpJsonRpcServer);
var
  Line, Response: string;
begin
  if AServer = nil then
    raise EMcpInvalidCommand.Create('An MCP JSON-RPC server is required.');
  while not EOF(Input) do
  begin
    ReadLn(Input, Line);
    Response := AServer.HandleLine(Line);
    if Response <> '' then
    begin
      WriteLn(Output, Response);
      Flush(Output);
    end;
  end;
end;

end.
