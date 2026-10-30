unit Frm_Toolbar3MAIN;

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
  Forms, Dialogs, Buttons, ExtCtrls, StdCtrls;

type
  TfrmToolbar3Main = class(TForm)
    FloatingToolbar: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Bevel1: TBevel;
    AllowDraggingCB: TCheckBox;
    ResetBitBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FloatingToolbarMouseDown(Sender: TObject;
      {%H-}Button: TMouseButton; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; {%H-}Shift: TShiftState; X,
      Y: Integer);
    procedure ResetBitBtnClick(Sender: TObject);
    procedure AllowDraggingCBClick(Sender: TObject);
  private
    { Private declarations }
    Dragging: Boolean;
    XOffset, YOffset: Integer;
    procedure MoveToolbar(X, Y: Integer);
  public
    { Public declarations }
  end;

var
  frmToolbar3Main: TfrmToolbar3Main;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{- Initialize }
procedure TfrmToolbar3Main.FormCreate(Sender: TObject);
begin
  Dragging := False;
end;

{- Display number of selected SpeedButton in toolbar }
procedure TfrmToolbar3Main.SpeedButton1Click(Sender: TObject);
begin
  ShowMessage('You selected button number ' +
    IntToStr(TSpeedButton(Sender).Tag));
end;

{- Start dragging operation on clicking in toolbar }
procedure TfrmToolbar3Main.FloatingToolbarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if AllowDraggingCB.Checked then
  begin
    Dragging := True;     { Dragging opertion in effect }
    SetCapture(Handle);   { Send all mouse messages to form }
    XOffset := X;         { Save mouse coordinates to compute }
    YOffset := Y;         { offset from top-left corner }
  end;
end;

{- End dragging operation on releasing mouse button }
procedure TfrmToolbar3Main.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Dragging then      { Ignore if not dragging }
  begin
    MoveToolbar(X, Y);  { Move toolbar to final location }
    Dragging := False;  { End dragging operation }
    ReleaseCapture;     { Return message handling to normal }
  end;
end;

{- Move toolbar if dragging operation in progress }
procedure TfrmToolbar3Main.FormMouseMove(Sender: TObject; Shift:
  TShiftState; X, Y: Integer);
begin
  if Dragging then      { Ignore if not dragging }
    MoveToolbar(X, Y);  { Move toolbar to mouse location }
end;

{- Move the toolbar to mouse location X and Y }
procedure TfrmToolbar3Main.MoveToolbar(X, Y: Integer);
begin
  FloatingToolbar.Left := X - XOffset; // Adjust location of
  FloatingToolbar.Top := Y - YOffset;  // panel top-left corner
end;

{- Reset toolbar to startup location }
procedure TfrmToolbar3Main.ResetBitBtnClick(Sender: TObject);
begin
  with FloatingToolbar do
  begin
    Left := 24;
    Top := 24;
  end;
  Dragging:=false;
  AllowDraggingCB.Checked := True;
end;

procedure TfrmToolbar3Main.AllowDraggingCBClick(Sender: TObject);
begin
  with Label1 do
    Enabled := not Enabled;
end;

end.

