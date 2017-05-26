object FrmClock: TFrmClock
  Left = 1253
  Top = 199
  AlphaBlend = True
  AlphaBlendValue = 196
  BorderStyle = bsNone
  Caption = 'JCs Clock'
  ClientHeight = 178
  ClientWidth = 186
  Color = clFuchsia
  TransparentColor = True
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnMouseEnter = FormMouseEnter
  OnMouseLeave = FormMouseLeave
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Image2: TImage
    Left = 8
    Top = 0
    Width = 168
    Height = 176
    Visible = False
  end
  object Image1: TImage
    Left = 8
    Top = 2
    Width = 168
    Height = 176
    OnMouseMove = Image1MouseMove
  end
  object Button1: TBitBtn
    Left = 34
    Top = 26
    Width = 16
    Height = 18
    Caption = 'X'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 300
    OnTimer = Timer1Timer
    Left = 280
    Top = 224
  end
end
