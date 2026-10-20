unit cls_fv2dialogs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, cls_fv2forms, cls_fv2stdctrls;

type
  TDialogResult = (drNone, drAccept, drCancel);

  TDialog = class(TForm)
  private
    FResult: TDialogResult;
    FCloseEvent: TNotifyEvent;
    procedure RequestClose(Sender: TObject);
    procedure HandleButton(Sender: TObject);
  public
    function Execute: TDialogResult; virtual;
    procedure EndModal(AResult: TDialogResult);
    procedure AddButton(const ACaption: string; AResult: TDialogResult);
    property ModalResult: TDialogResult read FResult;
    property OnCloseRequest: TNotifyEvent read FCloseEvent write FCloseEvent;
  end;

implementation

procedure TDialog.RequestClose(Sender: TObject);
begin
  if Assigned(FCloseEvent) then
    FCloseEvent(Self)
  else
    EndModal(drCancel);
end;

procedure TDialog.HandleButton(Sender: TObject);
begin
  if Sender is TButton then
    EndModal(TDialogResult(TButton(Sender).Tag));
end;

function TDialog.Execute: TDialogResult;
begin
  FResult := drNone;
  Show;
  Result := FResult;
end;

procedure TDialog.EndModal(AResult: TDialogResult);
begin
  FResult := AResult;
  Close;
end;

procedure TDialog.AddButton(const ACaption: string; AResult: TDialogResult);
var
  Button: TButton;
  ButtonIndex: Integer;
begin
  Button := TButton.Create(Self);
  Button.Parent := Self;
  Button.Caption := ACaption;
  Button.Tag := Ord(AResult);
  Button.OnClick := @HandleButton;
  ButtonIndex := ControlCount - 1;
  Button.Bounds := Rect(2 + ButtonIndex * 14, Bounds.Bottom - Bounds.Top - 2,
    14 + ButtonIndex * 14, Bounds.Bottom - Bounds.Top - 1);
end;

end.
