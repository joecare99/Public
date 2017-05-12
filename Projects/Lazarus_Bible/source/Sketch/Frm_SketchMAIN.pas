unit Frm_SketchMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, Messages,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    Demo1: TMenuItem;
    Erase1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    procedure FormMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormDblClick(Sender: TObject);
    procedure Erase1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Dragging: integer;
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Dragging := 0;
end;

procedure TMainForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ssRight in Shift   then
    Dragging := 3
  else if ssmiddle in Shift   then
    Dragging := 2
  else if ssLeft in Shift   then
    Dragging := 1;
  Canvas.Pen.Width :=Dragging;
  Canvas.MoveTo(X, Y);
end;

procedure TMainForm.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if Dragging>0 then
    Canvas.LineTo(X, Y);
end;

procedure TMainForm.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Dragging := 0;
end;

procedure TMainForm.FormDblClick(Sender: TObject);
begin
  Erase1Click(Sender);
end;

procedure TMainForm.Erase1Click(Sender: TObject);
begin
  Canvas.Brush := Brush; { Assign form's brush to Canvas }
  Canvas.FillRect(MainForm.ClientRect);  { Repaint form bkgrnd}
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.

