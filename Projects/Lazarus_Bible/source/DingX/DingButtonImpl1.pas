unit DingButtonImpl1;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  StdVCL, AXCtrls, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  ActiveX, Classes, Controls, Graphics, Menus, Forms, StdCtrls,
  ComServ, DingButtonXControl_TLB, Ctrl_DingButton;

type
  TDingButtonX = class(TActiveXControl, IDingButtonX)
  private
    { Private declarations }
    FDelphiControl: TDingButton;
    FEvents: IDingButtonXEvents;
  protected
    { Protected declarations }
    procedure InitializeControl; override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    function Get_Cancel: WordBool; safecall;
    function Get_Caption: WideString; safecall;
    function Get_Cursor: Smallint; safecall;
    function Get_Default: WordBool; safecall;
    function Get_DragCursor: Smallint; safecall;
    function Get_DragMode: TxDragMode; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_Font: Font; safecall;
    function Get_Visible: WordBool; safecall;
    procedure AboutBox; safecall;
    procedure Click; safecall;
    procedure Set_Cancel(Value: WordBool); safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure Set_Default(Value: WordBool); safecall;
    procedure Set_DragCursor(Value: Smallint); safecall;
    procedure Set_DragMode(Value: TxDragMode); safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_Font(const Value: Font); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function IDingButtonX.Get_Font = IDingButtonX_Get_Font;
    procedure IDingButtonX.Set_Font = IDingButtonX_Set_Font;
    function IDingButtonX_Get_Font: IFontDisp; safecall;
    procedure IDingButtonX_Set_Font(const Value: IFontDisp); safecall;
  end;

implementation

uses Frm_DingAbout;

{ TDingButtonX }

procedure TDingButtonX.InitializeControl;
begin
  FDelphiControl := Control as TDingButton;
end;

procedure TDingButtonX.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IDingButtonXEvents;
end;

procedure TDingButtonX.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  { Define property pages here.  Property pages are defined by calling
    DefinePropertyPage with the class id of the page.  For example,
      DefinePropertyPage(Class_DingButtonXPage); }
end;

function TDingButtonX.Get_Cancel: WordBool;
begin
  Result := FDelphiControl.Cancel;
end;

function TDingButtonX.Get_Caption: WideString;
begin
  Result := WideString(FDelphiControl.Caption);
end;

function TDingButtonX.Get_Cursor: Smallint;
begin
  Result := Smallint(FDelphiControl.Cursor);
end;

function TDingButtonX.Get_Default: WordBool;
begin
  Result := FDelphiControl.Default;
end;

function TDingButtonX.Get_DragCursor: Smallint;
begin
  Result := Smallint(FDelphiControl.DragCursor);
end;

function TDingButtonX.Get_DragMode: TxDragMode;
begin
  Result := Ord(FDelphiControl.DragMode);
end;

function TDingButtonX.Get_Enabled: WordBool;
begin
  Result := FDelphiControl.Enabled;
end;

function TDingButtonX.Get_Font: Font;
begin
  GetOleFont(FDelphiControl.Font, Result);
end;

function TDingButtonX.Get_Visible: WordBool;
begin
  Result := FDelphiControl.Visible;
end;

procedure TDingButtonX.AboutBox;
begin
  ShowDingButtonXAbout;
end;

procedure TDingButtonX.Click;
begin
  FDelphiControl.Click;
end;

procedure TDingButtonX.Set_Cancel(Value: WordBool);
begin
  FDelphiControl.Cancel := Value;
end;

procedure TDingButtonX.Set_Caption(const Value: WideString);
begin
  FDelphiControl.Caption := TCaption(Value);
end;

procedure TDingButtonX.Set_Cursor(Value: Smallint);
begin
  FDelphiControl.Cursor := TCursor(Value);
end;

procedure TDingButtonX.Set_Default(Value: WordBool);
begin
  FDelphiControl.Default := Value;
end;

procedure TDingButtonX.Set_DragCursor(Value: Smallint);
begin
  FDelphiControl.DragCursor := TCursor(Value);
end;

procedure TDingButtonX.Set_DragMode(Value: TxDragMode);
begin
  FDelphiControl.DragMode := TDragMode(Value);
end;

procedure TDingButtonX.Set_Enabled(Value: WordBool);
begin
  FDelphiControl.Enabled := Value;
end;

procedure TDingButtonX.Set_Font(const Value: Font);
begin
  SetOleFont(FDelphiControl.Font, Value);
end;

procedure TDingButtonX.Set_Visible(Value: WordBool);
begin
  FDelphiControl.Visible := Value;
end;

function TDingButtonX.IDingButtonX_Get_Font: IFontDisp;
begin

end;

procedure TDingButtonX.IDingButtonX_Set_Font(const Value: IFontDisp);
begin

end;

initialization
  TActiveXControlFactory.Create(
    ComServer,
    TDingButtonX,
    TDingButton,
    Class_DingButtonX,
    1,
    '',
    0);
end.
