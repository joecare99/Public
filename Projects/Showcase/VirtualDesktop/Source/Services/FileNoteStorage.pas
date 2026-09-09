unit FileNoteStorage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Services;

type
  TFileNoteStorage = class(TInterfacedObject, INoteStorage)
  private
    FWorkspace: IUserWorkspaceService;
    FFileName: string;
  public
    constructor Create(const AWorkspace: IUserWorkspaceService);
    function LoadText: string;
    procedure SaveText(const AText: string);
  end;

implementation

constructor TFileNoteStorage.Create(const AWorkspace: IUserWorkspaceService);
begin
  FWorkspace := AWorkspace;
  FFileName := FWorkspace.ResolveFile('notepad.txt');
end;

function TFileNoteStorage.LoadText: string;
var
  Lines: TStringList;
begin
  if not FileExists(FFileName) then
    Exit('');
  Lines := TStringList.Create;
  try
    Lines.LoadFromFile(FFileName);
    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

procedure TFileNoteStorage.SaveText(const AText: string);
var
  Lines: TStringList;
begin
  Lines := TStringList.Create;
  try
    Lines.Text := AText;
    Lines.SaveToFile(FFileName);
  finally
    Lines.Free;
  end;
end;

end.
