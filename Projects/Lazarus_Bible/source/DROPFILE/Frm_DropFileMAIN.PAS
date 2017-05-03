unit Frm_DropFileMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  ShellAPI,  SysUtils,  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type

  { TMainForm }

  TMainForm = class(TForm)
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    FileNameLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
  private
    { Private declarations }
  protected

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ Tell Windows this window can accept drag-and-drop files }
{ Disable drag-and-drop files (recommended) }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Handle, False);
end;

procedure TMainForm.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
var
  i: Integer;
begin
  memo1.Clear;
  with FileNameLabel do
  if high(filenames) =0 then
  begin
    Caption := filenames[0];
    memo1.lines.LoadFromFile(FileNames[0]);
  end
  else if high(filenames) >0 then
  for i := 0 to high(filenames) do
  begin
    Caption := filenames[0];
    memo1.lines.add(FileNames[i]);
  end
end;


end.
