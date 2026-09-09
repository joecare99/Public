unit UserWorkspaceService;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Services;

type
  TUserWorkspaceService = class(TInterfacedObject, IUserWorkspaceService)
  private
    FRootPath: string;
    procedure EnsureRootPath;
  public
    constructor Create(const AApplicationName: string);
    function RootPath: string;
    function ResolveFile(const ARelativePath: string): string;
  end;

implementation

constructor TUserWorkspaceService.Create(const AApplicationName: string);
var
  BasePath: string;
begin
  BasePath := GetEnvironmentVariable('LOCALAPPDATA');
  if BasePath = '' then
    BasePath := GetEnvironmentVariable('APPDATA');
  if BasePath = '' then
    BasePath := GetUserDir;
  FRootPath := IncludeTrailingPathDelimiter(BasePath) + AApplicationName;
  EnsureRootPath;
end;

procedure TUserWorkspaceService.EnsureRootPath;
begin
  if not ForceDirectories(FRootPath) then
    raise Exception.CreateFmt('Unable to create user workspace "%s".', [FRootPath]);
end;

function TUserWorkspaceService.RootPath: string;
begin
  Result := FRootPath;
end;

function TUserWorkspaceService.ResolveFile(const ARelativePath: string): string;
var
  Candidate: string;
begin
  if (ARelativePath = '') or (ExtractFileDrive(ARelativePath) <> '') or
     (Pos('..', ARelativePath) > 0) then
    raise Exception.CreateFmt('Invalid user-workspace path "%s".', [ARelativePath]);
  Candidate := ExpandFileName(IncludeTrailingPathDelimiter(FRootPath) + ARelativePath);
  if Copy(Candidate, 1, Length(IncludeTrailingPathDelimiter(FRootPath))) <>
     IncludeTrailingPathDelimiter(FRootPath) then
    raise Exception.CreateFmt('Path escapes the user workspace "%s".', [ARelativePath]);
  Result := Candidate;
end;

end.
