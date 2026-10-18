unit cls_fv2menus;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_fv2controls, cls_fv2canvas;

type
  TFvCommand = Word;
  TFvMenuEvent = procedure(Sender: TObject; Command: TFvCommand) of object;

  TMenuItem = class(TCollectionItem)
  private
    FCaption: string;
    FCommand: TFvCommand;
    FEnabled: Boolean;
    FVisible: Boolean;
    procedure SetCaption(const AValue: string);
  published
    property Caption: string read FCaption write SetCaption;
    property Command: TFvCommand read FCommand write FCommand;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TMenuItems = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TMenuItem;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TMenuItem;
    property Items[Index: Integer]: TMenuItem read GetItem; default;
  end;

  TMenu = class(TPersistent)
  private
    FItems: TMenuItems;
    FOnCommand: TFvMenuEvent;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(Command: TFvCommand);
    property Items: TMenuItems read FItems;
    property OnCommand: TFvMenuEvent read FOnCommand write FOnCommand;
  end;

  TMenuBar = class(TControl)
  private
    FMenu: TMenu;
  protected
    procedure DrawSelf(ACanvas: TFvCanvas); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Menu: TMenu read FMenu;
  end;

implementation

procedure TMenuItem.SetCaption(const AValue: string);
begin
  FCaption := AValue;
end;

constructor TMenuItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TMenuItem);
end;

function TMenuItems.Add: TMenuItem;
begin
  Result := TMenuItem(inherited Add);
  Result.Enabled := True;
  Result.Visible := True;
end;

function TMenuItems.GetItem(Index: Integer): TMenuItem;
begin
  Result := TMenuItem(inherited Items[Index]);
end;

constructor TMenu.Create;
begin
  inherited Create;
  FItems := TMenuItems.Create(Self);
end;

destructor TMenu.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TMenu.Execute(Command: TFvCommand);
begin
  if Assigned(FOnCommand) then
    FOnCommand(Self, Command);
end;

constructor TMenuBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMenu := TMenu.Create;
end;

destructor TMenuBar.Destroy;
begin
  FreeAndNil(FMenu);
  inherited Destroy;
end;

procedure TMenuBar.DrawSelf(ACanvas: TFvCanvas);
var
  I: Integer;
  X: Integer;
begin
  X := 0;
  for I := 0 to FMenu.Items.Count - 1 do
    if FMenu.Items[I].Visible then
    begin
      ACanvas.TextOut(X, 0, ' ' + FMenu.Items[I].Caption + ' ');
      Inc(X, Length(FMenu.Items[I].Caption) + 2);
    end;
end;

end.
