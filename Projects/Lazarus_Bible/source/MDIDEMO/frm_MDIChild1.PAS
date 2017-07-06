unit frm_MDIChild1;

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
  Forms, Dialogs;

type

  { TChildForm }

  TChildForm = class(TForm)
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
  {$R *.lfm}
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
  ShowMessage('LoadData from ' + FileName);
  Caption := LowerCase(FileName);
end;

procedure TChildForm.SaveData(const FileName: String);
begin
  ShowMessage('SaveData to ' + FileName);
  Caption := LowerCase(FileName);
end;

end.
