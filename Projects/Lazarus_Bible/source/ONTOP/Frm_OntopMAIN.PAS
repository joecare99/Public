unit Frm_OntopMAIN;

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
  Forms, Dialogs, Menus;

type
  TMainOntopForm = class(TForm)
    MainMenu1: TMainMenu;
    Demo1: TMenuItem;
    Stayontop1: TMenuItem;
    Exit1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure Stayontop1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainOntopForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainOntopForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainOntopForm.Stayontop1Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    if Checked
      then FormStyle := fsStayOnTop
      else FormStyle := fsNormal;
  end;
end;

end.

