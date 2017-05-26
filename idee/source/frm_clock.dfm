object FrmClock: TFrmClock
  Left = 1440
  Top = 0
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'JC'#39's Clock'
  ClientHeight = 183
  ClientWidth = 184
  Color = clFuchsia
  TransparentColor = True
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnMouseEnter = FormMouseEnter
  OnMouseLeave = FormMouseLeave
  DesignSize = (
    184
    183)
  PixelsPerInch = 96
  TextHeight = 13
  object Image2: TImage
    Left = 8
    Top = 0
    Width = 168
    Height = 182
    Anchors = [akLeft, akTop, akRight, akBottom]
    Visible = False
  end
  object Image1: TImage
    Left = 8
    Top = 0
    Width = 168
    Height = 182
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseMove = Image1MouseMove
  end
  object Button1: TBitBtn
    Left = 32
    Top = 24
    Width = 25
    Height = 25
    Caption = 'X'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 300
    OnTimer = Timer1Timer
    Left = 280
    Top = 224
  end
  object XPManifest1: TXPManifest
    Left = 32
    Top = 56
  end
end
