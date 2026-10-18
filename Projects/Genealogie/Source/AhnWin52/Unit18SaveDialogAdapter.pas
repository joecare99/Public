unit Unit18SaveDialogAdapter;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  Dialogs, Unit18SaveDialogWorkflow;

type
  TUnit18SaveDialogAdapter = class(TInterfacedObject, IUnit18SaveDialog)
  private
    FDialog: TSaveDialog;
  public
    constructor Create(Dialog: TSaveDialog);
    procedure SetFilterIndex(Value: Integer);
    function Execute: Boolean;
    procedure SetDefaultExt(const Value: string);
    function GetFileName: string;
    procedure SetFileName(const Value: string);
  end;

implementation

uses
  SysUtils;

constructor TUnit18SaveDialogAdapter.Create(Dialog: TSaveDialog);
begin
  inherited Create;
  if Dialog = nil then
    raise EUnit18SaveDialogArgumentError.Create(
      'Dialog must not be nil.');
  FDialog := Dialog;
end;

procedure TUnit18SaveDialogAdapter.SetFilterIndex(Value: Integer);
begin
  FDialog.FilterIndex := Value;
end;

function TUnit18SaveDialogAdapter.Execute: Boolean;
begin
  Result := FDialog.Execute;
end;

procedure TUnit18SaveDialogAdapter.SetDefaultExt(const Value: string);
begin
  FDialog.DefaultExt := Value;
end;

function TUnit18SaveDialogAdapter.GetFileName: string;
begin
  Result := FDialog.FileName;
end;

procedure TUnit18SaveDialogAdapter.SetFileName(const Value: string);
begin
  FDialog.FileName := Value;
end;

end.
