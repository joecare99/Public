unit cmp_DBHlPanel;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  {$IFNDEF FPC}
  Windows,
  {$else}
 // LMessages,
  {$ENDIF}
 Messages,   SysUtils, Classes, Controls, Graphics, ExtCtrls,DB,DBCtrls;

type
///<author>Rosewich</author>
TDBHlPanel = class(TCustomPanel)
  private
    FDataLink: TFieldDataLink;
    FNhlColor,
    FHlColor:TColor;
    FHlValue:variant;
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetFieldText: string;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    function GetPanelColor: TColor;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetAutoSize(Value: Boolean); override;
    Procedure Paint;override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize default False;
    property BiDiMode;
    property caption;
    property Color;
    property HighLightColor:TColor read FHlColor write FHlColor;
    Property SollValue:variant read FHlValue write FHlValue;
    property Constraints;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

{$IFnDEF FPC}
uses
  VDBConsts;
{$ELSE}
{$R *.dcr}
{$ENDIF}

resourcestring
  SDataSourceFixed = 'Actual Datasource is fixed';

{ TDBHlPanel }

constructor TDBHlPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNhlColor:=Color;
  ControlStyle := ControlStyle + [csReplicatable];
  AutoSize := False;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
end;

destructor TDBHlPanel.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TDBHlPanel.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState)
    then DataChange(Self);
end;

procedure TDBHlPanel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TDBHlPanel.UseRightToLeftAlignment: Boolean;
begin
  {$IFDEF FPC}
  Result := inherited;
  {$ELSE}
  Result := DBUseRightToLeftAlignment(Self, Field);
  {$ENDIF}
end;

procedure TDBHlPanel.SetAutoSize(Value: Boolean);
begin
  if AutoSize <> Value then
  begin
    if Value and FDataLink.DataSourceFixed then DatabaseError(SDataSourceFixed);
    inherited SetAutoSize(Value);
  end;
end;

function TDBHlPanel.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBHlPanel.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBHlPanel.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TDBHlPanel.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TDBHlPanel.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TDBHlPanel.GetFieldText: string;
begin
  if assigned(Fdatalink) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.DisplayText
  else
    if csDesigning in ComponentState then
      Result := Name else Result := '';
end;

procedure TDBHlPanel.DataChange(Sender: TObject);
begin
  Invalidate;
end;

function TDBHlPanel.GetPanelcolor: Tcolor;
begin
  result:=color;
end;

procedure TDBHlPanel.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TDBHlPanel.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TDBHlPanel.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TDBHlPanel.Paint;

begin
  if getfieldtext = sollValue then
    color := FHLColor
  else
    color := FNhlColor;
  inherited;
  if not (csPaintCopy in ControlState) and (align = alclient) then
    begin
      canvas.Pen.Color:=clDkGray;
      canvas.Rectangle(Rect(2,2,width-4,height-4))
    end
end;

end.
