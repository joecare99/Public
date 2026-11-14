unit ConfigurationService;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, Services;

type
  TIniConfigurationService = class(TInterfacedObject, IConfigurationService)
  private
    FWorkspace: IUserWorkspaceService;
    FFileName: string;
    FConfiguration: TMemIniFile;
  public
    constructor Create(const AWorkspace: IUserWorkspaceService);
    destructor Destroy; override;
    function ReadString(const ASection, AKey, ADefault: string): string;
    procedure WriteString(const ASection, AKey, AValue: string);
    procedure DeleteKey(const ASection, AKey: string);
    function ReadSections: TStringArray;
    procedure Save;
  end;

implementation

constructor TIniConfigurationService.Create(const AWorkspace: IUserWorkspaceService);
begin
  FWorkspace := AWorkspace;
  FFileName := FWorkspace.ResolveFile('virtual-desktop.ini');
  FConfiguration := TMemIniFile.Create(FFileName);
end;

destructor TIniConfigurationService.Destroy;
begin
  FConfiguration.Free;
  inherited Destroy;
end;

function TIniConfigurationService.ReadString(const ASection, AKey, ADefault: string): string;
begin
  Result := FConfiguration.ReadString(ASection, AKey, ADefault);
end;

procedure TIniConfigurationService.WriteString(const ASection, AKey, AValue: string);
begin
  FConfiguration.WriteString(ASection, AKey, AValue);
end;

procedure TIniConfigurationService.DeleteKey(const ASection, AKey: string);
begin
  FConfiguration.DeleteKey(ASection, AKey);
end;

function TIniConfigurationService.ReadSections: TStringArray;
var
  Values: TStringList;
  Index: Integer;
begin
  SetLength(Result, 0);
  Values := TStringList.Create;
  try
    FConfiguration.ReadSections(Values);
    SetLength(Result, Values.Count);
    for Index := 0 to Values.Count - 1 do
      Result[Index] := Values[Index];
  finally
    Values.Free;
  end;
end;

procedure TIniConfigurationService.Save;
begin
  FConfiguration.UpdateFile;
end;

end.
