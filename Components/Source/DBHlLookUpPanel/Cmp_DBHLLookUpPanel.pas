unit Cmp_DBHLLookUpPanel;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{*V 1.6.0 }
{*H 1.5.0 Anpassung an Themes}
interface

uses
{$IFnDEF FPC}
  Windows, Messages,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Classes, Controls, Graphics, ExtCtrls,DB,DBCtrls;

type
  TBeforePaintEvent=Procedure(Sender:TObject;Reference,Data:string) of object;
  TDBHLLookUpPanel = class(TCustomPanel)
  private
    FDataLink1: TFieldDataLink;
    FRefFieldName: string;
    FNhlColor,
    FHlColor:TColor;
    FHlValue:variant;
    FOnBeforePaint: TBeforePaintEvent;

    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetRefField: string;
    function GetDataSource: TDataSource;
    function GetDField: TField;
    function GetRField: TField;
//    function GetFieldText: string;
    procedure SetDataField(const Value: string);
    procedure SetRefField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    {$IFDEF FPC}
    procedure CMGetDataLink(var Message: TLMessage); message CM_GETDATALINK;
    {$ELSE}
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    {$ENDIF}
  protected
    function GetPanelColor: TColor;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    Procedure Paint;override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property DField: TField read GetDField;
    property RField: TField read GetRField;
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
    property RefField: string read GetRefField write SetRefField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property OnBeforePaint:TBeforePaintEvent read FOnBeforePaint write FOnBeforePaint;
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
{$ENDIF}


{ TDBText }

constructor TDBHLLookUpPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNhlColor:=Color;
  ControlStyle := ControlStyle + [csReplicatable];
  AutoSize := False;
  FDataLink1 := TFieldDataLink.Create;
  FDataLink1.Control := Self;
  FDataLink1.OnDataChange := DataChange;
end;

destructor TDBHLLookUpPanel.Destroy;
begin
  FDataLink1.Free;
  FDataLink1 := nil;
  inherited Destroy;
end;

procedure TDBHLLookUpPanel.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState)
    then DataChange(Self);
end;

procedure TDBHLLookUpPanel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink1 <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TDBHLLookUpPanel.GetDataSource: TDataSource;
begin
  Result := FDataLink1.DataSource;
end;

procedure TDBHLLookUpPanel.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink1.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink1.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBHLLookUpPanel.GetDataField: string;
begin
  Result := FDataLink1.FieldName;
end;

function TDBHLLookUpPanel.GetRefField: string;
begin
  Result := FRefFieldName;
end;

procedure TDBHLLookUpPanel.SetDataField(const Value: string);
begin
  FDataLink1.FieldName := Value;
end;

procedure TDBHLLookUpPanel.SetRefField(const Value: string);
begin
  FRefFieldName  := Value;
end;

function TDBHLLookUpPanel.GetDField: TField;
begin
  Result := FDataLink1.Field;
end;

function TDBHLLookUpPanel.GetRField: TField;
begin
  Result := FDataLink1.DataSet.FieldByName(FRefFieldName) ;
end;

{
function TDBHLLookUpPanel.GetFieldText: string;
begin
  if assigned(Fdatalink1) and (FDataLink1.Field <> nil) then
    Result := FDataLink1.Field.DisplayText
  else
    if csDesigning in ComponentState then
      Result := Name else Result := '';
end;
}

procedure TDBHLLookUpPanel.DataChange(Sender: TObject);
begin
  Invalidate;
end;

function TDBHLLookUpPanel.GetPanelcolor: Tcolor;
begin
  result:=color;
end;

{$IFDEF FPC}
procedure TDBHLLookUpPanel.CMGetDataLink(var Message: TLMessage);
{$ELSE}
procedure TDBHLLookUpPanel.CMGetDataLink(var Message: TMessage);
{$ENDIF}
begin
  Message.Result := Integer(FDataLink1);
end;

function TDBHLLookUpPanel.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink1 <> nil) and
    FDataLink1.ExecuteAction(Action);
end;

function TDBHLLookUpPanel.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink1 <> nil) and
    FDataLink1.UpdateAction(Action);
end;

procedure TDBHLLookUpPanel.Paint;

const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
//  VerticalAlignments: array[TVerticalAlignment] of Longint = (DT_TOP, DT_BOTTOM, DT_VCENTER);
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
//  FontHeight: Integer;
//  Flags: Longint;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

begin
  if Assigned(OnBeforePaint)
     and Assigned(FDataLink1)
     and Assigned(FDataLink1.dataset)
     and FDataLink1.dataset.active then
    try
      OnBeforePaint(self,FDataLink1.DataSet.FieldValues[FRefFieldName]  ,FDataLink1.Field.Value);
    except
    end;
  Rect := GetClientRect;
  if BevelOuter <> bvNone then
  begin
    AdjustColors(BevelOuter);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;

  Frame3D(Canvas, Rect, Color, Color, BorderWidth);
  if BevelInner <> bvNone then
  begin
    AdjustColors(BevelInner);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  with Canvas do
  begin
      Brush.Color := Color;
      FillRect(Rect);
    Brush.Style := bsClear;
    Font := Self.Font;
  end;
end;

end.
