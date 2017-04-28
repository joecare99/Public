unit fv2forms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,fv2drivers, fv2views;

type
   TDelegateCmdProcedure=Procedure(Sender:TObject;const Event:TEvent) of object;
  { TfvForms }

  TfvForm=Class(Tview)
  public
    constructor Create(Aowner: TGroup); reintroduce;
    Destructor Destroy;override;
  private
    FOnFormCreate: TNotifyEvent;
    FOnFormDestroy: TNotifyEvent;
    FOnHide: TNotifyEvent;
    FOnPaint: TNotifyEvent;
    FOnShow: TNotifyEvent;
    procedure SetOnFormCreate(AValue: TNotifyEvent);
    procedure SetOnFormDestroy(AValue: TNotifyEvent);
    procedure SetOnHide(AValue: TNotifyEvent);
    procedure SetOnPaint(AValue: TNotifyEvent);
    procedure SetOnShow(AValue: TNotifyEvent);
  protected
    function RegCmd(const ADelegate:TDelegateCmdProcedure;Eventno:integer=0):integer;
  published
    property OnFormCreate:TNotifyEvent read FOnFormCreate write SetOnFormCreate;
    Property OnFormDestroy:TNotifyEvent read FOnFormDestroy write SetOnFormDestroy;
    Property OnShow:TNotifyEvent read FOnShow write SetOnShow;
    Property OnHide:TNotifyEvent read FOnHide write SetOnHide;
    Property OnPaint:TNotifyEvent read FOnPaint write SetOnPaint;
  public
    Procedure FormCreate(Sender:system.TObject);virtual;
  end;
  TfvFormClass= class of TfvForm;

implementation

uses fv2AppExt,fv2app;
{ TfvForm }

constructor TfvForm.Create(Aowner: TGroup);
begin
  inherited create(Aowner,rect(0,0,0,0));
end;

destructor TfvForm.Destroy;
begin

end;

procedure TfvForm.SetOnFormCreate(AValue: TNotifyEvent);
begin
  if FOnFormCreate=AValue then Exit;
  FOnFormCreate:=AValue;
end;

procedure TfvForm.SetOnFormDestroy(AValue: TNotifyEvent);
begin
  if FOnFormDestroy=AValue then Exit;
  FOnFormDestroy:=AValue;
end;

procedure TfvForm.SetOnHide(AValue: TNotifyEvent);
begin
  if FOnHide=AValue then Exit;
  FOnHide:=AValue;
end;

procedure TfvForm.SetOnPaint(AValue: TNotifyEvent);
begin
  if FOnPaint=AValue then Exit;
  FOnPaint:=AValue;
end;

procedure TfvForm.SetOnShow(AValue: TNotifyEvent);
begin
  if FOnShow=AValue then Exit;
  FOnShow:=AValue;
end;

function TfvForm.RegCmd(const ADelegate: TDelegateCmdProcedure; Eventno: integer
  ): integer;
begin
  result:=TAppExt(Application).RegisterCmdDelegate(ADelegate,Eventno);
end;

procedure TfvForm.FormCreate(Sender: system.TObject);
begin
  // Empty
end;

end.

