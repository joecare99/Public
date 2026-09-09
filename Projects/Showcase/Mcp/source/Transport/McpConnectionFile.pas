unit McpConnectionFile;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Windows;

type
  TMcpConnectionFile = class
  private
    FFileName: string;
    FToken: string;
    FEndpoint: string;
    FWorkspaceRoot: string;
  public
    constructor Create(const AWorkspaceRoot, AToken, AEndpoint: string);
    procedure Write;
    procedure Delete;
    property FileName: string read FFileName;
  end;

implementation

uses
  Classes, fpjson, jsonparser;

const
  MOVE_FILE_WRITE_THROUGH = 8;

constructor TMcpConnectionFile.Create(const AWorkspaceRoot, AToken,
  AEndpoint: string);
begin
  inherited Create;
  if Trim(AWorkspaceRoot) = '' then
    raise Exception.Create('An MCP workspace root is required.');
  if (Trim(AToken) = '') or (Trim(AEndpoint) = '') then
    raise Exception.Create('MCP connection details are required.');
  FWorkspaceRoot := ExpandFileName(AWorkspaceRoot);
  FFileName := IncludeTrailingPathDelimiter(FWorkspaceRoot) +
    'mcp-connection.json';
  FToken := AToken;
  FEndpoint := AEndpoint;
end;

procedure TMcpConnectionFile.Write;
var
  Connection: TJSONObject;
  Lines: TStringList;
  TemporaryFileName: string;
begin
  if not ForceDirectories(FWorkspaceRoot) then
    raise Exception.Create('The MCP workspace could not be created.');
  Connection := TJSONObject.Create;
  try
    Connection.Add('token', FToken);
    Connection.Add('endpoint', FEndpoint);
    Connection.Add('workspaceRoot', FWorkspaceRoot);
    Lines := TStringList.Create;
    try
      Lines.Text := Connection.FormatJSON([], 2);
      TemporaryFileName := FFileName + '.' + IntToStr(GetCurrentProcessId) +
        '.tmp';
      try
        Lines.SaveToFile(TemporaryFileName);
        if not MoveFileEx(PChar(TemporaryFileName), PChar(FFileName),
          MOVEFILE_REPLACE_EXISTING or MOVE_FILE_WRITE_THROUGH) then
          raise Exception.Create('The MCP connection file could not be written.');
      finally
        SysUtils.DeleteFile(TemporaryFileName);
      end;
    finally
      Lines.Free;
    end;
  finally
    Connection.Free;
  end;
end;

procedure TMcpConnectionFile.Delete;
var
  Lines: TStringList;
  Data: TJSONData;
  Token: TJSONData;
begin
  if not FileExists(FFileName) then
    Exit;
  Lines := TStringList.Create;
  try
    try
      Lines.LoadFromFile(FFileName);
      Data := GetJSON(Lines.Text, True);
    except
      Exit;
    end;
    try
      if Data is TJSONObject then
      begin
        Token := TJSONObject(Data).Find('token', jtString);
        if (Token <> nil) and (Token.AsString = FToken) then
          SysUtils.DeleteFile(FFileName);
      end;
    finally
      Data.Free;
    end;
  finally
    Lines.Free;
  end;
end;

end.
