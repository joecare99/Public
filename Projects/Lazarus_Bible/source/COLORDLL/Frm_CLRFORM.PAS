unit Frm_CLRFORM;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  ColorGrd, Windows,
{$ELSE}
  LCLIntf, LCLType, ColorBox,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus;

type

  { TColorForm }

  TColorForm = class(TForm)
    {$IFNDEF FPC}
    ColorGrid:  TColorGrid;
    {$ELSE}
    FGColorSelect:  TColorBox;
    BGColorSelect: TColorBox;
    {$ENDIF}
    Label1: TLabel;
    Label2: TLabel;
    CancelBitBtn: TBitBtn;
    OkBitBtn: TBitBtn;
    Bevel1: TBevel;
    procedure CancelBitBtnClick(Sender: TObject);
    procedure ColorButton1Click(Sender: TObject);
    procedure OkBitBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ColorForm: TColorForm;

function FBGetColors(var FColor, BColor: TColor): WordBool;
  export;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{- Exit dialog via Cancel button }
procedure TColorForm.CancelBitBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TColorForm.ColorButton1Click(Sender: TObject);
begin

end;

{- Exit dialog via Ok button }
procedure TColorForm.OkBitBtnClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

{- Get foreground and background colors }
function FBGetColors(var FColor, BColor: TColor): WordBool;
begin
  Result := False;
  ColorForm := TColorForm.Create(Application);
 with ColorForm do
  try
    if ShowModal = mrOk then

    begin
      {$IFDEF FPC}
      FColor := FGColorSelect.Color;
      BColor := BGColorSelect.Color;
      {$ELSE}
      FColor := ColorGrid.ForegroundColor;
      BColor := ColorGrid.BackgroundColor;
      {$ENDIF}
      Result := True;
    end;
  finally
    ColorForm.Free;
  end;
end;

end.
