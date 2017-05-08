unit Frm_OleContMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  OleCtnrs, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages, ole2,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls;

type
  TMainForm = class(TForm)
   {$IFDEF FPC}
    OleContainer1: TActiveXContainer;
   {$ELSE}
    OleContainer1:TOleContainer;
   {$ENDIF} MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    InsertObject1: TMenuItem;
    Exit1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure InsertObject1Click(Sender: TObject);
  private
    { Private declarations }
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

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.InsertObject1Click(Sender: TObject);
begin
  with OleContainer1 do
  begin
    if InsertObjectDialog then
      DoVerb(PrimaryVerb);
  end;
end;

(* Delphi 1 code, now obsolete
procedure TForm1.InsertObject1Click(Sender: TObject);
var
  P: Pointer;
begin
  if InsertOLEObjectDlg(Form1, 0, P) then
  begin
    OleContainer1.PInitInfo := P;
    ReleaseOleInitInfo(P);
  end;
end;
*)

end.
