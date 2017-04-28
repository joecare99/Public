unit fvForms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,drivers,objects;

type
   TDelegateCmdProcedure=Procedure(Sender:TObject;const Event:TEvent) of object;
  { TfvForms }

  TfvForm=Class(TComponent)
  public
    constructor Create(Aowner: Tobject); reintroduce;
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
    function RegCmd(const ADelegate:TDelegateCmdProcedure;Eventno:Sw_Word=0):Sw_Word;
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

uses fvAppExt,app;
{ TfvForm }

constructor TfvForm.Create(Aowner: Tobject);
begin
  inherited Create(nil);
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

function TfvForm.RegCmd(const ADelegate: TDelegateCmdProcedure; Eventno: Sw_Word
  ): Sw_Word;
begin
  result:=PAppExt(Application)^.RegisterCmdDelegate(ADelegate,Eventno);
end;

procedure TfvForm.FormCreate(Sender: system.TObject);
begin
  // Empty
end;

end.
