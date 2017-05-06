unit Childbmp;

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
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, CHILD2;

type
  TChildBmpForm = class(TChildForm)
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoadData(const FileName: String); override;
    procedure SaveData(const FileName: String); override;
    { Public declarations }
  end;

var
  ChildBmpForm: TChildBmpForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TChildBmpForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TChildBmpForm.LoadData(const FileName: String);
begin
  Image1.Picture.LoadFromFile(FileName);
  Caption := LowerCase(FileName);
end;

procedure TChildBmpForm.SaveData(const FileName: String);
begin
  Image1.Picture.SaveToFile(FileName);
  Caption := LowerCase(FileName);
end;

{ This procedure frees the ancestor child form class's
  Memo1 object, which would otherwise conflict with
  the subclassed window's Image1 object. }
procedure TChildBmpForm.FormCreate(Sender: TObject);
begin
  inherited;
  Memo1.Free;
end;

end.
