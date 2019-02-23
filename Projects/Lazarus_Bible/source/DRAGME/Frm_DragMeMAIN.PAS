unit Frm_DragMeMAIN;

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
  Forms, Dialogs, ExtCtrls, Buttons, StdCtrls;

type
  TMainForm = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    BitBtn1: TBitBtn;
    procedure ShapeMouseDown(Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; X, Y: Integer);
    procedure ShapeMouseMove(Sender: TObject; {%H-}Shift: TShiftState;
      X, Y: Integer);
    procedure ShapeMouseUp(Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    Dragging: Boolean;          { Drag operation in progress flag }
    XOffset, YOffset: Integer;  { Offsets from shape upper left }
    FocusRect: TRect;           { Dotted outline while dragging }
    PS: TShape;                 { Reference to shape dragging }
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

procedure TMainForm.ShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Dragging := True;        { Set dragging flag true }
  XOffset := X;            { Keep offsets from shape upper left }
  YOffset := Y;
  PS := Sender as TShape;  { Assign reference to shape }
  with PS do               { Create outline rectangle }
    FocusRect := Rect(Left, Top, Left + Width, Top + Height);
  Canvas.DrawFocusRect(FocusRect);  { Draw outline }
end;

procedure TMainForm.ShapeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if Dragging then  { Move outline only if dragging }
  begin
    Canvas.DrawFocusRect(FocusRect);  { Erase outline }
    with FocusRect do
    begin  { Move outline rectangle }
      Left := (PS.Left + X) - XOffset;
      Top := (PS.Top + Y) - YOffset;
      Right := PS.Width + Left;
      Bottom := PS.Height + Top;
    end;
    Canvas.DrawFocusRect(FocusRect);  { Draw outline }
  end;
end;

procedure TMainForm.ShapeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Dragging then  { Move shape only if dragging }
  begin
    Canvas.DrawFocusRect(FocusRect);  { Erase outline }
    Dragging := False;                { Reset flag }
    with Sender as TShape do
    begin  { Move shape to new location }
      Left := (Left + X) - XOffset;
      Top := (Top + Y) - YOffset;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Dragging := False;
end;

end.
