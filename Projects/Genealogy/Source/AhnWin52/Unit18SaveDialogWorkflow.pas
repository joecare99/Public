unit Unit18SaveDialogWorkflow;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  SysUtils;

type
  EUnit18SaveDialogArgumentError = class(Exception);

  IUnit18SaveDialog = interface
    ['{E9B96701-53D4-4FAF-A375-6ED137048CCD}']
    procedure SetFilterIndex(Value: Integer);
    function Execute: Boolean;
    procedure SetDefaultExt(const Value: string);
    function GetFileName: string;
    procedure SetFileName(const Value: string);
  end;

function PrepareUnit18SavePath(Dialog: IUnit18SaveDialog): Boolean;

implementation

function PrepareUnit18SavePath(Dialog: IUnit18SaveDialog): Boolean;
var
  FileName: string;
begin
  if Dialog = nil then
    raise EUnit18SaveDialogArgumentError.Create(
      'Dialog must not be nil.');

  Dialog.SetFilterIndex(1);
  if not Dialog.Execute then
  begin
    Result := False;
    Exit;
  end;

  Dialog.SetDefaultExt('txt');
  FileName := Dialog.GetFileName;
  if Pos('.txt', ExtractFileExt(FileName)) = 0 then
    Dialog.SetFileName(FileName + '.txt');

  Result := True;
end;

end.
