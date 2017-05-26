object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Boxflight'
  ClientHeight = 633
  ClientWidth = 759
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 8
    Top = 194
    Width = 400
    Height = 400
    OnPaint = PaintBox1Paint
  end
  object PaintBox2: TPaintBox
    Left = 8
    Top = 8
    Width = 745
    Height = 177
  end
  object TrackBar1: TTrackBar
    Left = -2
    Top = 600
    Width = 753
    Height = 25
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 672
    Top = 360
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 1
  end
  object ScrollBar1: TScrollBar
    Left = 414
    Top = 191
    Width = 337
    Height = 16
    Max = 255
    PageSize = 0
    Position = 127
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 414
    Top = 213
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 3
  end
  object Timer1: TTimer
    Interval = 20
    OnTimer = Timer1Timer
    Left = 584
    Top = 248
  end
end
