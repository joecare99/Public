unit COLORDLG;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  WinProcs, WinTypes,
{$ELSE}
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus;

type

  { TColorDlgForm }

  TColorDlgForm = class(TForm)
    RedSB: TScrollBar;
    GreenSB: TScrollBar;
    BlueSB: TScrollBar;
    RedLabel: TLabel;
    GreenLabel: TLabel;
    BlueLabel: TLabel;
    RedEdit: TEdit;
    GreenEdit: TEdit;
    BlueEdit: TEdit;
    ColorEdit: TEdit;
    OkBitBtn: TBitBtn;
    CancelBitBtn: TBitBtn;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure SBChange(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OkBitBtnClick(Sender: TObject);
    procedure CancelBitBtnClick(Sender: TObject);
  private
    RedPos, GreenPos, BluePos: Integer;  { For undo }
    EditControls: array[0 .. 2] of TEdit;
    ScrollBars: array[0 .. 2] of TScrollBar;
    procedure UpdateColor;
  public
    ColorResult: TColor;  { Selected color }
  end;

var
  ColorDlgForm: TColorDlgForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{- Update ColorResult using scrollbar positions }
procedure TColorDlgForm.UpdateColor;
begin
  ColorResult := {$IFDEF FPC} RGBToColor {$ELSE} RGB {$ENDIF}(
    RedSB.Position, GreenSB.Position, BlueSB.Position);
  ColorEdit.Color := ColorResult;  { Show color }
end;

{- Initialize TObject control arrays }
procedure TColorDlgForm.FormCreate(Sender: TObject);
begin
  EditControls[0] := RedEdit;
  EditControls[1] := GreenEdit;
  EditControls[2] := BlueEdit;
  ScrollBars[0] := RedSB;
  ScrollBars[1] := GreenSB;
  ScrollBars[2] := BlueSB;
end;

{- Update values in Edit boxes for ScrollBar changes }
procedure TColorDlgForm.SBChange(Sender: TObject);
begin
  with Sender as TScrollBar do
    EditControls[Tag].Text := IntToStr(Position);
  UpdateColor;
end;

{- Update scrollbar positions for Edit box changes }
procedure TColorDlgForm.EditChange(Sender: TObject);
begin
  with Sender as TEdit do
    ScrollBars[Tag].Position := StrToInt(Text);
end;

{- Save scrollbar positions for possible undo }
procedure TColorDlgForm.FormActivate(Sender: TObject);
begin
  RedPos := RedSB.Position;
  GreenPos := GreenSB.Position;
  BluePos := BlueSB.Position;
end;

{- Respond to OK button. Accept changes. }
procedure TColorDlgForm.OkBitBtnClick(Sender: TObject);
begin
  ModalResult := mrOk; { Close Window. Color in ColorResult. }
end;

{- Respond to Cancel button. Undo changes. }
procedure TColorDlgForm.CancelBitBtnClick(Sender: TObject);
begin
  RedSB.Position := RedPos;
  GreenSB.Position := GreenPos;
  BlueSB.Position := BluePos;
  ModalResult := mrCancel;
end;

end.
