unit frm_DisplTestColor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, cls_RenderColor;

type

  { TFrmDisplayTestColor }

  TFrmDisplayTestColor = class(TForm)
    btnOK: TBitBtn;
    btnClose: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    pnlBottom: TPanel;
    pnlColorDispl2: TPanel;
    pnlColorDispl3: TPanel;
    pnlColors: TPanel;
    pnlColorDispl1: TPanel;
    pnlTop: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    TrackBar1: TTrackBar;
  private
    function getTitle: String;
    procedure SetColor1(AValue: TRenderColor);
    procedure SetColor2(AValue: TRenderColor);
    procedure SetColor3(AValue: TRenderColor);
    procedure SetFaktor(AValue: Extended);
    procedure SetTitle(AValue: String);

  public
    Property Title:String read getTitle write SetTitle;
    Property Color1:TRenderColor write SetColor1;
    Property Color2:TRenderColor write SetColor2;
    Property Color3:TRenderColor write SetColor3;
    Property Faktor:Extended write SetFaktor;
    Procedure UpdateDisplay;
  end;

var
  FrmDisplayTestColor: TFrmDisplayTestColor;

implementation

{$R *.lfm}

{ TFrmDisplayTestColor }

function TFrmDisplayTestColor.getTitle: String;
begin
  result := Label1.Caption;
end;

procedure TFrmDisplayTestColor.SetColor1(AValue: TRenderColor);
begin
  Shape1.Brush.Color := AValue.Color;
  Edit1.Text := ColorToString(Shape1.Brush.Color);
end;

procedure TFrmDisplayTestColor.SetColor2(AValue: TRenderColor);
begin
  Shape2.Brush.Color := AValue.Color;
  Edit2.Text := ColorToString(Shape2.Brush.Color);
end;

procedure TFrmDisplayTestColor.SetColor3(AValue: TRenderColor);
begin
  Shape3.Brush.Color := AValue.Color;
  Edit3.Text := ColorToString(Shape3.Brush.Color);
end;

procedure TFrmDisplayTestColor.SetFaktor(AValue: Extended);
begin
  TrackBar1.Position:=trunc(AValue*1000);
end;

procedure TFrmDisplayTestColor.SetTitle(AValue: String);
begin
  Label1.Caption:= AValue;
end;

procedure TFrmDisplayTestColor.UpdateDisplay;
begin
  Application.ProcessMessages;
end;

end.

