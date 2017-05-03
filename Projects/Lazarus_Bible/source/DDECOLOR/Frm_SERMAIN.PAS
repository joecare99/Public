unit Frm_SERMAIN;

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, DdeMan;

type
  TMainForm = class(TForm)
    RedLabel: TLabel;
    GreenLabel: TLabel;
    BlueLabel: TLabel;
    RedSB: TScrollBar;
    GreenSB: TScrollBar;
    BlueSB: TScrollBar;
    RedEdit: TEdit;
    GreenEdit: TEdit;
    BlueEdit: TEdit;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    ColorServer: TDdeServerConv;
    ColorItem: TDdeServerItem;
    procedure FormCreate(Sender: TObject);
    procedure SBChange(Sender: TObject);
    procedure EditChange(Sender: TObject);
  private
    EditControls: array[0 .. 2] of TEdit;
    ScrollBars: array[0 .. 2] of TScrollBar;
    procedure UpdateColor;
  public
    ColorResult: TColor;  { Selected color }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

{- Update ColorResult using scrollbar positions. Send
color information to any DDE client applications. }
procedure TMainForm.UpdateColor;
begin
  ColorResult := RGB(
    RedSB.Position, GreenSB.Position, BlueSB.Position);
  ColorItem.Text := ColorToString(ColorResult);
end;

{- Initialize Edit and Scrollbar arrays for easy access }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  EditControls[0] := RedEdit;
  EditControls[1] := GreenEdit;
  EditControls[2] := BlueEdit;
  ScrollBars[0] := RedSB;
  ScrollBars[1] := GreenSB;
  ScrollBars[2] := BlueSB;
end;

{- Update values in Edit boxes for ScrollBar changes }
procedure TMainForm.SBChange(Sender: TObject);
begin
  with Sender as TScrollBar do
    EditControls[Tag].Text := IntToStr(Position);
  UpdateColor;
end;

{- Update scrollbar positions for Edit box changes }
procedure TMainForm.EditChange(Sender: TObject);
begin
  with Sender as TEdit do
    ScrollBars[Tag].Position := StrToInt(Text);
end;

end.
