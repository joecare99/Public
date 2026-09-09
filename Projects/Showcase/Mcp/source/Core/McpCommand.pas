unit McpCommand;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson;

type
  TMcpCommandScope = (mcsUserWorkspace, mcsDesktop, mcsLazarus);

  EMcpError = class(Exception)
  public
    function ErrorCode: string; virtual;
    function ToJson: TJSONObject;
  end;
  EMcpInvalidCommand = class(EMcpError)
  public
    function ErrorCode: string; override;
  end;
  EMcpInvalidParams = class(EMcpError)
  public
    function ErrorCode: string; override;
  end;
  EMcpToolNotFound = class(EMcpError)
  public
    function ErrorCode: string; override;
  end;
  EMcpAccessDenied = class(EMcpError)
  public
    function ErrorCode: string; override;
  end;
  EMcpCommandFailed = class(EMcpError)
  public
    function ErrorCode: string; override;
  end;

  TMcpCommandContext = class
  private
    FWorkspaceRoot: string;
    FAllowDesktopCommands: Boolean;
    FAllowLazarusCommands: Boolean;
    function IsWithinWorkspace(const APath: string): Boolean;
    procedure RejectReparsePoints(const ARelativePath: string);
    procedure Initialize(const AWorkspaceRoot: string;
      const AAllowDesktopCommands: Boolean);
  public
    constructor Create(const AWorkspaceRoot: string); overload;
    constructor Create(const AWorkspaceRoot: string;
      const AAllowDesktopCommands: Boolean); overload;
    constructor Create(const AWorkspaceRoot: string;
      const AAllowDesktopCommands, AAllowLazarusCommands: Boolean); overload;
    function ResolveWorkspacePath(const ARelativePath: string): string;
    function AllowsScope(const AScope: TMcpCommandScope): Boolean;
    procedure RequireScope(const AScope: TMcpCommandScope);
    property WorkspaceRoot: string read FWorkspaceRoot;
    property AllowDesktopCommands: Boolean read FAllowDesktopCommands;
    property AllowLazarusCommands: Boolean read FAllowLazarusCommands;
  end;

  TMcpCommandResult = class
  private
    FIsError: Boolean;
    FText: string;
    FStructuredContent: TJSONData;
  public
    constructor CreateText(const AText: string; const AIsError: Boolean);
    constructor CreateStructured(const AContent: TJSONData;
      const AIsError: Boolean);
    destructor Destroy; override;
    class function Text(const AText: string): TMcpCommandResult; static;
    class function Error(const AMessage: string): TMcpCommandResult; static;
    class function ErrorWithCode(const ACode, AMessage: string):
      TMcpCommandResult; static;
    class function Json(const AContent: TJSONData): TMcpCommandResult; static;
    function ToMcpJson: TJSONObject;
    property IsError: Boolean read FIsError;
    property TextValue: string read FText;
  end;

  IMcpCommand = interface
    ['{93DFB4E4-FF4A-49F4-AF61-C16416B8F527}']
    function CommandName: string;
    function Description: string;
    function Scope: TMcpCommandScope;
    { The caller owns the returned schema. The schema must describe a closed
      object with properties and types accepted by ValidateMcpInputSchema. }
    function InputSchema: TJSONObject;
    function Execute(const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult;
  end;

  IMcpToolClient = interface
    ['{B93BAA56-A2AF-4CBB-8AE1-BC514BB83407}']
    function ListTools: TJSONArray;
    function CallTool(const AName: string; const AArguments: TJSONObject):
      TMcpCommandResult;
  end;

  TMcpCommandBase = class(TInterfacedObject, IMcpCommand)
  protected
    function GetCommandName: string; virtual; abstract;
    function GetDescription: string; virtual; abstract;
    function GetScope: TMcpCommandScope; virtual;
    function GetInputSchema: TJSONObject; virtual;
  public
    function CommandName: string;
    function Description: string;
    function Scope: TMcpCommandScope;
    function InputSchema: TJSONObject;
    function Execute(const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult; virtual; abstract;
  end;

function McpScopeName(const AScope: TMcpCommandScope): string;
function McpScopeNamespace(const AScope: TMcpCommandScope): string;
function McpToolNamespace(const AName: string): string;
function IsValidMcpToolName(const AName: string): Boolean;
procedure ValidateMcpToolName(const AName: string);
procedure ValidateMcpInputSchema(const ASchema: TJSONObject);
procedure ValidateMcpToolArguments(const ASchema, AArguments: TJSONObject);

implementation

{$IFDEF MSWINDOWS}
uses
  Windows;
{$ENDIF}

function McpScopeName(const AScope: TMcpCommandScope): string;
begin
  case AScope of
    mcsUserWorkspace: Result := 'user-workspace';
    mcsDesktop: Result := 'desktop';
    mcsLazarus: Result := 'lazarus';
  else
    raise EMcpInvalidCommand.Create('The MCP command scope is invalid.');
  end;
end;

function McpScopeNamespace(const AScope: TMcpCommandScope): string;
begin
  case AScope of
    mcsUserWorkspace: Result := 'workspace';
    mcsDesktop: Result := 'desktop';
    mcsLazarus: Result := 'lazarus';
  else
    raise EMcpInvalidCommand.Create('The MCP command scope is invalid.');
  end;
end;

function IsMcpIdentifierSegment(const AValue: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if (Length(AValue) = 0) or (Length(AValue) > 48) then
    Exit;
  if not (AValue[1] in ['a'..'z']) then
    Exit;
  for I := 2 to Length(AValue) do
    if not (AValue[I] in ['a'..'z', '0'..'9', '_', '-']) then
      Exit;
  Result := True;
end;

function IsValidMcpToolName(const AName: string): Boolean;
var
  I, SegmentStart, SegmentCount: Integer;
  Segment: string;
begin
  Result := False;
  if (Length(AName) = 0) or (Length(AName) > 128) then
    Exit;
  SegmentStart := 1;
  SegmentCount := 0;
  for I := 1 to Length(AName) + 1 do
    if (I > Length(AName)) or (AName[I] = '.') then
    begin
      Segment := Copy(AName, SegmentStart, I - SegmentStart);
      if not IsMcpIdentifierSegment(Segment) then
        Exit;
      Inc(SegmentCount);
      SegmentStart := I + 1;
    end;
  Result := SegmentCount >= 2;
end;

procedure ValidateMcpToolName(const AName: string);
begin
  if not IsValidMcpToolName(AName) then
    raise EMcpInvalidCommand.Create(
      'MCP tool names must be lowercase, dot-namespaced identifiers.');
  if (Copy(AName, 1, Length('workspace.')) <> 'workspace.') and
     (Copy(AName, 1, Length('desktop.')) <> 'desktop.') and
     (Copy(AName, 1, Length('lazarus.')) <> 'lazarus.') then
    raise EMcpInvalidCommand.Create(
      'MCP tools must use the workspace or desktop namespace.');
end;

function McpToolNamespace(const AName: string): string;
var
  DotPosition: Integer;
begin
  DotPosition := Pos('.', AName);
  if DotPosition = 0 then
    Result := ''
  else
    Result := Copy(AName, 1, DotPosition - 1);
end;

procedure ValidateMcpPropertyName(const AName: string);
begin
  if not IsMcpIdentifierSegment(AName) then
    raise EMcpInvalidCommand.Create(
      'MCP input property names must be lowercase identifiers.');
end;

function IsSupportedSchemaType(const AType: string): Boolean;
begin
  Result := (AType = 'string') or (AType = 'boolean') or
    (AType = 'number') or (AType = 'object') or (AType = 'array') or
    (AType = 'null');
end;

procedure ValidateMcpInputSchema(const ASchema: TJSONObject);
var
  TypeValue, AdditionalProperties: TJSONData;
  Properties: TJSONObject;
  Required: TJSONArray;
  I, J: Integer;
  PropertySchema, PropertyType: TJSONData;
  RequiredName: string;
begin
  if ASchema = nil then
    raise EMcpInvalidCommand.Create('An MCP input schema is required.');
  TypeValue := ASchema.Find('type', jtString);
  if (TypeValue = nil) or (TypeValue.AsString <> 'object') then
    raise EMcpInvalidCommand.Create(
      'MCP input schemas must describe an object.');
  AdditionalProperties := ASchema.Find('additionalProperties', jtBoolean);
  if (AdditionalProperties = nil) or AdditionalProperties.AsBoolean then
    raise EMcpInvalidCommand.Create(
      'MCP input schemas must set additionalProperties to false.');

  Properties := TJSONObject(ASchema.Find('properties', jtObject));
  if Properties <> nil then
    for I := 0 to Properties.Count - 1 do
    begin
      ValidateMcpPropertyName(Properties.Names[I]);
      for J := 0 to I - 1 do
        if Properties.Names[J] = Properties.Names[I] then
          raise EMcpInvalidCommand.Create(
            'MCP input schemas cannot contain duplicate properties.');
      PropertySchema := Properties.Items[I];
      if not (PropertySchema is TJSONObject) then
        raise EMcpInvalidCommand.Create(
          'Each MCP input property must have an object schema.');
      PropertyType := TJSONObject(PropertySchema).Find('type', jtString);
      if (PropertyType = nil) or
         (not IsSupportedSchemaType(PropertyType.AsString)) then
        raise EMcpInvalidCommand.Create(
          'Each MCP input property must have a supported type.');
    end;

  Required := TJSONArray(ASchema.Find('required', jtArray));
  if Required <> nil then
    for I := 0 to Required.Count - 1 do
    begin
      if Required.Items[I].JSONType <> jtString then
        raise EMcpInvalidCommand.Create(
          'MCP required properties must be strings.');
      RequiredName := Required.Items[I].AsString;
      ValidateMcpPropertyName(RequiredName);
      if (Properties = nil) or (Properties.Find(RequiredName) = nil) then
        raise EMcpInvalidCommand.Create(
          'Each MCP required property must be declared.');
      for J := 0 to I - 1 do
        if Required.Items[J].AsString = RequiredName then
          raise EMcpInvalidCommand.Create(
            'MCP input schemas cannot contain duplicate required properties.');
    end;
end;

procedure ValidateValueType(const APropertyName, AExpectedType: string;
  const AValue: TJSONData);
var
  Valid: Boolean;
begin
  Valid := ((AExpectedType = 'string') and (AValue.JSONType = jtString)) or
    ((AExpectedType = 'boolean') and (AValue.JSONType = jtBoolean)) or
    ((AExpectedType = 'number') and (AValue.JSONType = jtNumber)) or
    ((AExpectedType = 'object') and (AValue.JSONType = jtObject)) or
    ((AExpectedType = 'array') and (AValue.JSONType = jtArray)) or
    ((AExpectedType = 'null') and (AValue.JSONType = jtNull));
  if not Valid then
    raise EMcpInvalidParams.CreateFmt(
      'MCP argument "%s" has an invalid type.', [APropertyName]);
end;

procedure ValidateMcpToolArguments(const ASchema, AArguments: TJSONObject);
var
  Properties: TJSONObject;
  Required: TJSONArray;
  PropertySchema, PropertyType, Value: TJSONData;
  I, J: Integer;
  PropertyName: string;
begin
  if AArguments = nil then
    raise EMcpInvalidParams.Create('Tool arguments must be an object.');
  ValidateMcpInputSchema(ASchema);
  Properties := TJSONObject(ASchema.Find('properties', jtObject));
  Required := TJSONArray(ASchema.Find('required', jtArray));

  if Required <> nil then
    for I := 0 to Required.Count - 1 do
      if AArguments.Find(Required.Items[I].AsString) = nil then
        raise EMcpInvalidParams.CreateFmt(
          'MCP argument "%s" is required.', [Required.Items[I].AsString]);

  for I := 0 to AArguments.Count - 1 do
  begin
    PropertyName := AArguments.Names[I];
    for J := 0 to I - 1 do
      if AArguments.Names[J] = PropertyName then
        raise EMcpInvalidParams.CreateFmt(
          'MCP argument "%s" is duplicated.', [PropertyName]);
    if Properties = nil then
      PropertySchema := nil
    else
      PropertySchema := Properties.Find(PropertyName, jtObject);
    if PropertySchema = nil then
      raise EMcpInvalidParams.CreateFmt(
        'MCP argument "%s" is not allowed.', [PropertyName]);
    PropertyType := TJSONObject(PropertySchema).Find('type', jtString);
    Value := AArguments.Items[I];
    ValidateValueType(PropertyName, PropertyType.AsString, Value);
  end;
end;

function SamePathPrefix(const APath, APrefix: string): Boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := CompareText(Copy(APath, 1, Length(APrefix)), APrefix) = 0;
  {$ELSE}
  Result := CompareStr(Copy(APath, 1, Length(APrefix)), APrefix) = 0;
  {$ENDIF}
end;

function IsReservedWindowsDeviceName(const AValue: string): Boolean;
var
  BaseName: string;
begin
  Result := False;
  {$IFDEF MSWINDOWS}
  BaseName := UpperCase(AValue);
  if Pos('.', BaseName) > 0 then
    BaseName := Copy(BaseName, 1, Pos('.', BaseName) - 1);
  Result := (BaseName = 'CON') or (BaseName = 'PRN') or
    (BaseName = 'AUX') or (BaseName = 'NUL') or
    ((Length(BaseName) = 4) and
      ((Copy(BaseName, 1, 3) = 'COM') or (Copy(BaseName, 1, 3) = 'LPT')) and
      (BaseName[4] in ['1'..'9']));
  {$ENDIF}
end;

procedure ValidateWorkspaceSegment(const ASegment: string);
var
  I: Integer;
begin
  if (ASegment = '') or (ASegment = '.') or (ASegment = '..') then
    raise EMcpAccessDenied.Create('The workspace path contains an invalid segment.');
  if (ASegment[Length(ASegment)] = ' ') or
     (ASegment[Length(ASegment)] = '.') then
    raise EMcpAccessDenied.Create(
      'Workspace path segments cannot end with a space or period.');
  for I := 1 to Length(ASegment) do
    if (Ord(ASegment[I]) < 32) or
       (ASegment[I] in [':', '*', '?', '"', '<', '>', '|']) then
      raise EMcpAccessDenied.Create(
        'The workspace path contains unsafe characters.');
  if IsReservedWindowsDeviceName(ASegment) then
    raise EMcpAccessDenied.Create(
      'The workspace path contains a reserved device name.');
end;

function EMcpError.ErrorCode: string;
begin
  Result := 'mcp_error';
end;

function EMcpError.ToJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('code', ErrorCode);
  Result.Add('message', Message);
end;

function EMcpInvalidCommand.ErrorCode: string;
begin
  Result := 'invalid_command';
end;

function EMcpInvalidParams.ErrorCode: string;
begin
  Result := 'invalid_params';
end;

function EMcpToolNotFound.ErrorCode: string;
begin
  Result := 'tool_not_found';
end;

function EMcpAccessDenied.ErrorCode: string;
begin
  Result := 'access_denied';
end;

function EMcpCommandFailed.ErrorCode: string;
begin
  Result := 'command_failed';
end;

constructor TMcpCommandContext.Create(const AWorkspaceRoot: string);
begin
  inherited Create;
  Initialize(AWorkspaceRoot, False);
end;

constructor TMcpCommandContext.Create(const AWorkspaceRoot: string;
  const AAllowDesktopCommands: Boolean);
begin
  inherited Create;
  Initialize(AWorkspaceRoot, AAllowDesktopCommands);
end;

constructor TMcpCommandContext.Create(const AWorkspaceRoot: string;
  const AAllowDesktopCommands, AAllowLazarusCommands: Boolean);
begin
  inherited Create;
  Initialize(AWorkspaceRoot, AAllowDesktopCommands);
  FAllowLazarusCommands := AAllowLazarusCommands;
end;

procedure TMcpCommandContext.Initialize(const AWorkspaceRoot: string;
  const AAllowDesktopCommands: Boolean);
begin
  if Trim(AWorkspaceRoot) = '' then
    raise EMcpInvalidCommand.Create('A user-workspace root is required.');
  FWorkspaceRoot := ExpandFileName(AWorkspaceRoot);
  if FWorkspaceRoot = '' then
    raise EMcpInvalidCommand.Create('The user-workspace root is invalid.');
  if FileExists(FWorkspaceRoot) and not DirectoryExists(FWorkspaceRoot) then
    raise EMcpInvalidCommand.Create('The user-workspace root must be a directory.');
  FAllowDesktopCommands := AAllowDesktopCommands;
  FAllowLazarusCommands := False;
end;

function TMcpCommandContext.IsWithinWorkspace(const APath: string): Boolean;
var
  Prefix: string;
begin
  Prefix := IncludeTrailingPathDelimiter(FWorkspaceRoot);
  {$IFDEF MSWINDOWS}
  Result := (CompareText(APath, FWorkspaceRoot) = 0) or
    ((Length(APath) > Length(Prefix)) and SamePathPrefix(APath, Prefix));
  {$ELSE}
  Result := (CompareStr(APath, FWorkspaceRoot) = 0) or
    ((Length(APath) > Length(Prefix)) and SamePathPrefix(APath, Prefix));
  {$ENDIF}
end;

procedure TMcpCommandContext.RejectReparsePoints(const ARelativePath: string);
{$IFDEF MSWINDOWS}
var
  I, SegmentStart: Integer;
  Segment, CurrentPath: string;
  Attributes: DWORD;
begin
  CurrentPath := FWorkspaceRoot;
  Attributes := GetFileAttributes(PChar(CurrentPath));
  if (Attributes <> INVALID_FILE_ATTRIBUTES) and
     ((Attributes and FILE_ATTRIBUTE_REPARSE_POINT) <> 0) then
    raise EMcpAccessDenied.Create(
      'A reparse-point workspace root is not allowed.');
  SegmentStart := 1;
  for I := 1 to Length(ARelativePath) + 1 do
    if (I > Length(ARelativePath)) or
       (ARelativePath[I] in ['\', '/']) then
    begin
      Segment := Copy(ARelativePath, SegmentStart, I - SegmentStart);
      CurrentPath := IncludeTrailingPathDelimiter(CurrentPath) + Segment;
      Attributes := GetFileAttributes(PChar(CurrentPath));
      if Attributes = INVALID_FILE_ATTRIBUTES then
        Exit;
      if (Attributes and FILE_ATTRIBUTE_REPARSE_POINT) <> 0 then
        raise EMcpAccessDenied.Create(
          'Workspace paths cannot traverse reparse points.');
      SegmentStart := I + 1;
    end;
end;
{$ELSE}
begin
  { Platforms without a portable reparse-point API retain lexical confinement. }
end;
{$ENDIF}

function TMcpCommandContext.ResolveWorkspacePath(
  const ARelativePath: string): string;
var
  Candidate, Segment: string;
  I, SegmentStart: Integer;
begin
  if Trim(ARelativePath) = '' then
    raise EMcpAccessDenied.Create('A relative user-workspace path is required.');
  if (ExtractFileDrive(ARelativePath) <> '') or
     (Pos(':', ARelativePath) <> 0) or
     (ARelativePath[1] in ['\', '/']) then
    raise EMcpAccessDenied.Create('Absolute paths are not allowed.');

  SegmentStart := 1;
  for I := 1 to Length(ARelativePath) + 1 do
    if (I > Length(ARelativePath)) or
       (ARelativePath[I] in ['\', '/']) then
    begin
      Segment := Copy(ARelativePath, SegmentStart, I - SegmentStart);
      ValidateWorkspaceSegment(Segment);
      SegmentStart := I + 1;
    end;

  Candidate := ExpandFileName(
    IncludeTrailingPathDelimiter(FWorkspaceRoot) + ARelativePath);
  if not IsWithinWorkspace(Candidate) then
    raise EMcpAccessDenied.Create('The path escapes the user workspace.');
  RejectReparsePoints(ARelativePath);
  Result := Candidate;
end;

function TMcpCommandContext.AllowsScope(const AScope: TMcpCommandScope): Boolean;
begin
  case AScope of
    mcsUserWorkspace: Result := True;
    mcsDesktop: Result := FAllowDesktopCommands;
    mcsLazarus: Result := FAllowLazarusCommands;
  else
    Result := False;
  end;
end;

procedure TMcpCommandContext.RequireScope(const AScope: TMcpCommandScope);
begin
  if not AllowsScope(AScope) then
    raise EMcpAccessDenied.CreateFmt(
      'The MCP context does not allow %s commands.', [McpScopeName(AScope)]);
end;

constructor TMcpCommandResult.CreateText(const AText: string;
  const AIsError: Boolean);
begin
  inherited Create;
  FText := AText;
  FIsError := AIsError;
  FStructuredContent := nil;
end;

constructor TMcpCommandResult.CreateStructured(const AContent: TJSONData;
  const AIsError: Boolean);
begin
  inherited Create;
  FText := '';
  FIsError := AIsError;
  FStructuredContent := AContent;
end;

destructor TMcpCommandResult.Destroy;
begin
  FStructuredContent.Free;
  inherited Destroy;
end;

class function TMcpCommandResult.Text(const AText: string): TMcpCommandResult;
begin
  Result := TMcpCommandResult.CreateText(AText, False);
end;

class function TMcpCommandResult.Error(const AMessage: string):
  TMcpCommandResult;
begin
  Result := TMcpCommandResult.CreateText(AMessage, True);
end;

class function TMcpCommandResult.ErrorWithCode(const ACode, AMessage: string):
  TMcpCommandResult;
var
  Details: TJSONObject;
begin
  if not IsMcpIdentifierSegment(ACode) then
    raise EMcpInvalidCommand.Create('MCP error codes must be lowercase identifiers.');
  Details := TJSONObject.Create;
  Details.Add('code', ACode);
  Details.Add('message', AMessage);
  Result := TMcpCommandResult.CreateStructured(Details, True);
end;

class function TMcpCommandResult.Json(const AContent: TJSONData):
  TMcpCommandResult;
begin
  if AContent = nil then
    raise EMcpInvalidCommand.Create('Structured command content is required.');
  Result := TMcpCommandResult.CreateStructured(AContent, False);
end;

function TMcpCommandResult.ToMcpJson: TJSONObject;
var
  Content: TJSONObject;
  ContentArray: TJSONArray;
begin
  Result := TJSONObject.Create;
  ContentArray := TJSONArray.Create;
  Content := TJSONObject.Create;
  Content.Add('type', 'text');
  if FStructuredContent <> nil then
    Content.Add('text', FStructuredContent.AsJSON)
  else
    Content.Add('text', FText);
  ContentArray.Add(Content);
  Result.Add('content', ContentArray);
  Result.Add('isError', FIsError);
  if FStructuredContent <> nil then
    Result.Add('structuredContent', FStructuredContent.Clone);
end;

function TMcpCommandBase.GetScope: TMcpCommandScope;
begin
  Result := mcsUserWorkspace;
end;

function TMcpCommandBase.GetInputSchema: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('type', 'object');
  Result.Add('additionalProperties', False);
end;

function TMcpCommandBase.CommandName: string;
begin
  Result := GetCommandName;
end;

function TMcpCommandBase.Description: string;
begin
  Result := GetDescription;
end;

function TMcpCommandBase.Scope: TMcpCommandScope;
begin
  Result := GetScope;
end;

function TMcpCommandBase.InputSchema: TJSONObject;
begin
  Result := GetInputSchema;
end;

end.
