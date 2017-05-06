unit CHILD2;

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
  Forms, Dialogs, StdCtrls;

type
  TChildForm = class(TForm)
    Memo1: TMemo;
    procedure FormClose(Sender: TObject;
      var Action: TCloseAction);
  private
  {- Private declarations }
  public
  {- Public declarations }
    procedure LoadData(const FileName: String); virtual;
    procedure SaveData(const FileName: String); virtual;
  end;

var
  ChildForm: TChildForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TChildForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TChildForm.LoadData(const FileName: String);
begin
//  ShowMessage('LoadData from ' + FileName);
  Memo1.Lines.LoadFromFile(FileName);
  Caption := LowerCase(FileName);
end;

procedure TChildForm.SaveData(const FileName: String);
begin
//  ShowMessage('SaveData to ' + FileName);
  Memo1.Lines.SaveToFile(FileName);
  Caption := LowerCase(FileName);
end;

end.
