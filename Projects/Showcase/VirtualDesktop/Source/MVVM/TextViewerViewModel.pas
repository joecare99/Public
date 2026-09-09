unit TextViewerViewModel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Services, Mvvm;

type
  TTextViewerViewModel = class(TNotifyPropertyChangedObject)
  private
    FWorkspace: IUserWorkspaceService;
    FFileName: string;
    FText: string;
  public
    constructor Create(const AWorkspace: IUserWorkspaceService);
    procedure OpenFile(const ARelativePath: string);
    property FileName: string read FFileName;
    property Text: string read FText;
  end;

implementation

constructor TTextViewerViewModel.Create(const AWorkspace: IUserWorkspaceService);
begin
  inherited Create;
  FWorkspace := AWorkspace;
end;

procedure TTextViewerViewModel.OpenFile(const ARelativePath: string);
var
  Lines: TStringList;
  FullPath: string;
begin
  FullPath := FWorkspace.ResolveFile(ARelativePath);
  if not FileExists(FullPath) then
    raise Exception.CreateFmt('File "%s" does not exist in the user workspace.', [ARelativePath]);
  Lines := TStringList.Create;
  try
    Lines.LoadFromFile(FullPath);
    FText := Lines.Text;
    FFileName := ARelativePath;
    NotifyPropertyChanged('Text');
    NotifyPropertyChanged('FileName');
  finally
    Lines.Free;
  end;
end;

end.
